Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B5810A88FB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C6C6B0088; Thu, 26 Mar 2026 13:59:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D8D6B0089; Thu, 26 Mar 2026 13:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E056B008A; Thu, 26 Mar 2026 13:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4DAE6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:59:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B176C1E6D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:59:03 +0000 (UTC)
X-FDA: 84588975366.21.28541F9
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57349A0016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:59:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hDJ7sixW;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774547941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80Mb9whJ243IS3wLbxD0sRPngPj7V2/sZvWpg8pOWw4=;
	b=by0trqblvG4WLfhb/YYFmY+i3x0NlPr6vlLfY4m2ZwK1Xa6elv54EWMOAgwBjsq1QedffN
	ZLr9j7aU3pAxugNRTFbICJL/Bt34nJxsh3l9eZGGgLqXhEtkqD0MhIiZrbOgwgNQC79tjd
	3PS2lpza57HyNuVV1/DU4yEDmKrze8w=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hDJ7sixW;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774547941; a=rsa-sha256;
	cv=pass;
	b=C4sGn+nEw3AJHS4XH+8WUeL5pDi3zIEy6aq5mpzQUQPTa3nO+ZzjDpp7jOUdh/03jxB4oV
	gT0+Trnxa30ykm0G/WPKyo3cOBSfjHPbplc3rtWtZj15X/eMvao2aNhRVdXMVNtL9lk7le
	zz6O5NjmZIFXYxWeJaz1E41y6tj7Mlc=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486fb112c09so12978235e9.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:59:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774547940; cv=none;
        d=google.com; s=arc-20240605;
        b=ZqqEKaz5vCo5P/7q0rMD06kK1mCFaZE6UNyvdp1vvEMwfagi414nmWtWBDmjkZTAJ0
         J4Su06UIZuVxwi/6xiWqWsFJA23gpJrkxpPIdZC3UfR2kAACVO+PRqfGO0FNwliEJO53
         8/PMiyf186kLgrzy307mT/oqq+5AMdzHWIwfauW+mVLq6D+gouUIvqGhwt7ljjs1hUi7
         9oY6QGtZEt9utL7u7hCclFX7BYsPjQlvt7DkXhlfx1XidzHvMeyEC+T/Lai5Q3NE0prR
         bPiJizii9XuY313/Zrj+pebLLbOwuF5TulouZmIkpcoYHSdprSLMEqrSqwC3xlcBWZIl
         9d7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=80Mb9whJ243IS3wLbxD0sRPngPj7V2/sZvWpg8pOWw4=;
        fh=uQZ+rRaaF+Q3IRr6G0okJM8IiZf1pOzzi/sVNXRjkvc=;
        b=Pmb9+08M/56SMNFDSMvs6/QTkWFn4LPasohghZErMXcZpowz79nERZNCMtV5IyG79z
         7R5Y6vjhITFOSAsbeqs+6B0nqKPYjLVfSwZWaY04l3pjllsNSVj5iURP8Pwh+tlfFvqw
         f0/0R7v/ykLevPSiz2G+jN0l0VCn0ZMM5lYoz9YeZQq2b9faIFW3UgErWDRZ06ocPVZb
         ZNU+M55pci8fr3AKQup8wxnEW23IqQlcxCICHvq5Lyltf/LvybLV9dM89FNtqO0UP31I
         Jn5Z5gchX3E5vaBxssKhxhSd2cvHHhcwyqcOtd3zRgxUM6KGTYnJgeNVK+r7i9CkFqI6
         9cug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774547940; x=1775152740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80Mb9whJ243IS3wLbxD0sRPngPj7V2/sZvWpg8pOWw4=;
        b=hDJ7sixWf2TgkWxi7pyLe8FK0xH3zvMgQrW5RCsymmwxAAcrXS0LKkk8hNtnMBwqcD
         tcMbijuM4mVDneieJ1egSlcjOSTwgP+oo/l1XfZnIZJkDJ6WZ8ZsS0r2ZmO5D8lV3Rgo
         aJS7/Dm0YYPnzH7C+0iDgpLHn1+tnbAQix86fzCvPZFez3zIG9uDCBQBxfsRPnXxzENX
         moHo1jfRtm/dgAeHvMK0D9APjuGKPeW6kpSuMe16RjNa6lkLMsqh93uOhgCJ+VFqMFeg
         /GNOW/etvBXWm3CGxXqUVdaokdGkwHy/nvN7GE5gB513CHghag+h7zKmjuJbVl0Qc6r/
         5c4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774547940; x=1775152740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=80Mb9whJ243IS3wLbxD0sRPngPj7V2/sZvWpg8pOWw4=;
        b=fapiwgcDs6hNwe3XQkEd3Vfb+PaRNrRliiZXinBLY08nwDWbWS7vbJSxh4UQ7nnuu1
         QSJ5lPuB9LyPEDo/my8IOAIp+HJZn+E63K8vAOPW8tEYITfb4RtMV1WNiiCbs7bk3Obu
         6WEshgfUsdTZ25Rh9/gQCxuJDXaAK8sELhm6nSCjfJ/uOP6RciqSnPGflM2/pGB7fX8O
         4hT8WmiYOcOQ0rSZKsBK7SvWKwFj/59ON9kBIlizpmVCYsUkdq8iZ/HQhUAcOPTPDhKq
         7cDrff8G48MAPMTcxd+1Xwm1fRvhdaTPa1VHj+Q2oOOyMjanvuLDmfTGm8S/JwuT3Nm7
         vF8g==
X-Forwarded-Encrypted: i=1; AJvYcCUIvOuq1eSSpuPlkjIZS9eRYvJ4Vas4aO5KFSs59fQ4zoZegOoDSmI7T50zgjTUTyMyNOzf8UgfIg==@kvack.org
X-Gm-Message-State: AOJu0YwTwU5pAeJKkMlm4OkpG0XCrKcu/d4NSoebCHtAlHYpZcNVw18O
	47JJPZH/Y7AQyz/OrT0UhkAS9zhJFQty54xfDcycTCl8CxsBwdhKkuF+FNzdc2bIBpKqFvspWVU
	w8GHs95/Mx2tIg69HXdRsOIZ1zEdLGLs=
X-Gm-Gg: ATEYQzy9qkSwCQZAcFfGuu2Dhx+IhgbhTHU4rYFxuiFwLZgsVQYzvL8tZqZVs6gbyl0
	l2Z0R8dkBgaBE/9oQ8+dDxdDtf20MKpHcSWYg6vMaJ10yC+Ll1gPzLoGhQQstyCrKhDQOnahMpM
	iGz4NpMAB5W8SmnrSSLB0c/MpiXm72KBIaP7YBwm0kQLzNV7/2IozAmdWr1w4XuZ/88gEnMjUgG
	T5N1esmwg49SJkCi87JjclBY3qWQB5OyVuzptPgQcD4lt56kQcOpggG6SPREwT2SYlwRl3fKwZn
	Ko0tBA==
X-Received: by 2002:a05:600c:3b16:b0:485:45fb:3472 with SMTP id
 5b1f17b1804b1-48715fc3a88mr128851985e9.7.1774547939665; Thu, 26 Mar 2026
 10:58:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260326001337.828947-1-joannelkoong@gmail.com> <yet2ddivcs3v4g5wmr4zfjkwsbzfjmwjhq56zur7wjivd72abs@tq23xp4mle2o>
In-Reply-To: <yet2ddivcs3v4g5wmr4zfjkwsbzfjmwjhq56zur7wjivd72abs@tq23xp4mle2o>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Mar 2026 10:58:48 -0700
X-Gm-Features: AQROBzBJTNVKqxLNGXMdHzPrAm0v89gG-2H1rymc_kwPrrzGJPYjfQfe4mHTfyc
Message-ID: <CAJnrk1Y_R=bVQpugCwg39G75WXCpss5w9xzwd8fTrmrVN0YSRg@mail.gmail.com>
Subject: Re: [PATCH v1] mm: fix writeback regression for strictlimit BDIs
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, willy@infradead.org, 
	miklos@szeredi.hu, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: w3w7cx8fkgrccsnn319y3b8u6giyu4p9
X-Rspamd-Queue-Id: 57349A0016
X-Rspamd-Server: rspam09
X-HE-Tag: 1774547941-87887
X-HE-Meta: U2FsdGVkX1/toWqiv/kyloS4YN+Vw9eBXdcrEsi9Tk7zj+4MLXigPF7nzxypyOPRj6fj4+Qu/hpHBan/A55qTvJjfrBIu/UlEONxPJAA/3xxEcKDA0a2afNVA74wF46dJQtG2RzS3YJ2ZYKyd98jn18RqbRwEspdErnJpIR/CrrF80Hl/P9DchxKXA1wt0nPZSwGoWQv4tKFHFShvocuMp/hsdLcsTcFEkdkMF3FcPHeYAHxhh/2nSw2rkTkOX+ExYEcH2C8tflGKt29ewS7Mw7mJLDd8RauO7yCJkSaCj9pW7TIklF9nJU+0MuKIu1D4turqVcJNF3gHzEGuRD6IsXNPsfpJ/7lx9vZX+jC2jX7Jygq2+ywMwPlqEb49T865Yce2quVhNO0lLvEXo6yBK5tjPrWxLyxzSO9wGoon9OhDCqgVVFh3p6S2u767VYEmsWRo8aCNRdVPa+Y+NS1j5L5a6WzmyMT3n16bKtqvK1QqU2fvDlZ998teW2WHB4uTed0j+f0Ow8clyUMrH6vILIV3cXnQ0/B39oDSCSZ+NERqWZjlO97fBCkXdvvw3UytSKBXShwxgoahvHxmRELVE4fgS7TA35L5EdhQqbxqssKJKpw1QRwFS6VBU6g5ahvKzKm6o6m6hMF2WkGYpyc6aB4+Wa8JET+08JiupOllq6WIZ0WRK3J8xjmES45Fz9GdcXzamlhqvNQCZHI4eiQCapA031G2i/F62A9zfylwQLtrOBp+N/EbP7S0mPpNcKLaK2WtAnusuB0RGkGQ6ImXWC88LeTQj/pngx4onWhqx14hBJy89lJnik235VvBBdqFjEEoonLRLdZeXus48XJ74wbSia0T/ghttisNhU1F6CrMOR01SbPb1YxdwPznEg9rCIyWM1zn32alMk+noUTjxOhV/7S9hb0bhNxsJE9Tftm+c8vuNUvHbHZQb+N/lgDumBHMrgZuiXeddMIokZ
 5PccON6R
 nm8tuQlILL9twsSi4Hsry5kQCVtXHM84jX4DGZC134CgoBYSj6YVRHZdlz+pkbqZaqi6Ptu8iv6fdRo67XaMlhRrcQEbe9Iit+De5yr6a2zeN3iiBQZIg5JxZFA22SZQIQnbdJdAq7VIKvSmKmwrqNfR5nvvaswyWkGZql8AsDDUqJgGt3OIcijT9FASQEaVuUyZNzWiiAIiQD+Xj6ocMqcYe201DQDVOYjODk9RG3jK9NiNwPNja2xwHIIGrQBUEdjTFyjdWsWwNiokVwYKtKbUZZBuA5qNjkvPieV5VtbO5ebhWcC4CILy6t/1Zd9xbs0SM98NftMJElpuUbZ78IjYdQ4Sd20prnF/IrSWn4ohcZV8nKhCHT88RIOJyNhXflJyubgwGwcGQYB1GbrflnwybCdOwHvYBtYjv9j0aPi1ct2iVsEOiyfooNjr3ibFT23kKm5l4l4KBQYhUy/nbtxaSZZDim9MNUo5Es2VN1QUCYLlO0jJzLNvV5UhV/SjG7N45eNwobXPAOASeXHtLoq6O7A1g0wY4B8dfP2ZQnuJjvI4ImcR9Cr7pRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 1:48=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 25-03-26 17:13:37, Joanne Koong wrote:
> > Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> > unconditional writeback kick from balance_dirty_pages():
> >
> >        if (unlikely(!writeback_in_progress(wb)))
> >              wb_start_background_writeback(wb);
> >
> > Earlier in balance_dirty_pages(), background writeback is started if th=
e
> > global dirty count exceeds the global background threshold (nr_dirty >
> > gdtc->bg_thresh). However for BDIs with BDI_CAP_STRICTLIMIT set (eg
> > fuse), throttling is calculated using the per-wb threshold, not global
> > thresholds. This means the per-wb threshold can be exceeded while the
> > global nr_dirty is below gdtc->bg_thresh. This causes two problems:
> >
> > a) background writeback is never proactively kicked off. The flusher
> > should be kicked off while the writer is still free-running, so that
> > dirty pages are drained before the writer hits the throttle threshold.
> > For strictlimit BDIs with global nr_dirty < gdtc->bg_thresh, this never
> > kicks off the flusher, so dirty pages pile up unchecked until the per-w=
b
> > freerun ceiling gets hit and IO is throttled
> >
> > b) while IO is throttled, the flusher is still not started, which means
> > the writer basically sits in the throttle loop sleeping while waiting
> > for dirty pages to be cleaned but no writeback is running
> >
> > This leads to severe stalls and degraded throughput. On fuse, buffered
> > write performance drops from 1400 MiB/s to 2000 KiB/s.
> >
> > This fixes the issue by kicking off the flusher if wb_dirty exceeds
> > wb_bg_thresh for strictlimit BDIs. This restores performance back to it=
s
> > original baseline.
> >
> > Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>
> Good spotting! I think your change makes sense but I don't think it is
> enough. The problem is that writeback throttling depends also on memcg
> setup so with your fix we still have a problem that when throttling due t=
o
> memcg limits the flush work won't be queued early enough / at all. So I
> think the best fix is to perhaps do your change so that background
> writeback is started earlier for strictlimit bdis but also return back th=
e
> unconditional starting of writeback (with properly updated comment) when =
we
> find out we're going to throttle the task for whatever reason.

Thanks for the explanation - great point about the memcg case.

I will bring back those 2 lines as the proper fix for the regression
and submit this patch separately as a strictlimit optimization.

Thanks,
Joanne
>
>                                                                 Honza
>
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 601a5e048d12..3f89b08b11b4 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -1835,7 +1835,9 @@ static int balance_dirty_pages(struct bdi_writeba=
ck *wb,
> >                       balance_domain_limits(mdtc, strictlimit);
> >               }
> >
> > -             if (nr_dirty > gdtc->bg_thresh && !writeback_in_progress(=
wb))
> > +             if (!writeback_in_progress(wb) &&
> > +                 (nr_dirty > gdtc->bg_thresh ||
> > +                  (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)=
))
> >                       wb_start_background_writeback(wb);
> >
> >               /*
> > --
> > 2.52.0
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

