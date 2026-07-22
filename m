Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A45CBC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 22:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242206B0093; Wed, 22 Jul 2026 18:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC5E6B0096; Wed, 22 Jul 2026 18:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0937A6B0098; Wed, 22 Jul 2026 18:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA1346B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:25:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 414651C0572
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:25:51 +0000 (UTC)
X-FDA: 85017846102.08.FED6D19
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E7BD180007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:25:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y+qA5Tc/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784759149;
	b=xcZMmhKamXPoN3fMMaBb2qgFixWaBixdgzKc20Pzwn5bsmOTxTaroGVc750XQ0oIk0bDVr
	ZQ1D+BkWjoA/2oMQ8aCPeudWGrEtmn+b1vzyfGIveGcIhHa9TdmxdkTvtFMExlY3Dntbfy
	tklaXaedSqAqO5vMAlzBIhECaAg4Ezg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y+qA5Tc/";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784759149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5h3qQWpco5+qoVGf6bp9Mmlxz9tLEeIFkYyIcMI6PqM=;
	b=cZ+/w0mSa1a5Wms+p2/oOV7pft0NGuN3V38tjHyX/fSAixzy4U/X9CV9amm+5Yvp1uVVMz
	z6UoJje4oKkcn+plZeUeE20z/2z7Q8StJPhs3yz75+4ijxoWPgr9qTzh1I1QQI/82XYbuk
	3dx9foeK+xx5CgtQMNh8ENt7nSiamuo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso40155ad.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:25:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784759148; cv=none;
        d=google.com; s=arc-20260327;
        b=fgvqKjIq2KN25QF+HssBSrUF6S4zC+55areLUK8tCVqRZ+rrAVgREnypRgfLRRbu9z
         7RMDRpkybxLS7f8SbB5tbuEJVa6wjqootg8X2HyG2yHZ+gR9BExhPh2kzSvZnfQkvUO9
         Ne6DjQ+fvV8Whap1VJRNCz7N7+eQ0ATV2s4hWxalOv2vHRne834xClPp3HNikHFDkJoF
         81MH3t+PK/YDUZmh8asEwhw08FslYNIuj81BchReHIfy4jdKenNwHyjrHVVOUi+K+LtN
         tr2k59v3fcOD04sO8DoB4BnQF/mEqnhdnapuQV8g72Ix19bm0O8ePwr1lKztFkgt1BKr
         ViFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5h3qQWpco5+qoVGf6bp9Mmlxz9tLEeIFkYyIcMI6PqM=;
        fh=+mvauQbnvNcgWzD+lEqMAOMQlGldG9mW+Yew+hfpbmQ=;
        b=FIMvxEb3YAu76+vZR/tXUSrO9sFpi3YpGCxhQ6z7CQdiBoKTFpoxPIMSk0ArNcJE4L
         xe28wG1oBMpCpsnZVtXkraAO4ckP++ul/DijF1nPaD3G+xddVXM6JBNNzG6TJdsx6snL
         1gah7WkJBLAXJ91UdrsiTMPKCDS3l081d5QKJIMi1MQSiKXi1GcKtcHPWvlNjLVbxII3
         hVXHD7OhZzprZy8CTL56xo0Vf/DxFit5J6dz5y2FmvFqpOdWeH8WldDmqEjobRUxJEgb
         p73TuAOQnCEKWAh6phvi0aecDyeC/zYg4soVJO55SC6Xh5/0kVc8Gs/RBqzfCyE1tFw1
         uTlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784759148; x=1785363948; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5h3qQWpco5+qoVGf6bp9Mmlxz9tLEeIFkYyIcMI6PqM=;
        b=Y+qA5Tc/rdIW9wh7eZXcdZgCsUwmMaZjCh7GG6mQf7eZLsQP9ZuR4L3MsWf7lrl+e1
         WFMgrP8Iiss/+6G0wg8YsU/QonPGgA9jBAGFfxJQliVl/+OewsU8zeWykA7IRACMg3EO
         mA9bbGzon8K+mUMD7/3jA8F1ZZ89i63RyypC8c8XP8H3AHC2tLCl2sgbUGSkeUXI8NQ/
         aVVbshTp1go8VCF39yC7Nw1EXXP1XM+oNaSGs8tIRL3ugHs7/ljxiTXa8IsBy0o6jkca
         uiCLRvW7rEWwMoHo+GBFx5HSpHdEKVDjaEikyRLUVdzk5JhbfJwLgr3I0uXj6AXLNHHY
         5Mug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784759148; x=1785363948;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5h3qQWpco5+qoVGf6bp9Mmlxz9tLEeIFkYyIcMI6PqM=;
        b=foxi9i2wxoS3en7XSBZnF3kuWYFzbHbtmFzuJMdu/pzimFvLfhzD6FctzZbmrJlNky
         Gfr3+8QaRQ4noKB+CX9dF1pGE/tU5VuUVcRWGt3SnABaCkdoZWpmLS2huNQgA/WEsmjb
         BEnJSdlJyGHN4vGG0oVVUkFdkLhu8qcbpezDdyL5M2YZdzEaB9dPtK3ygP2WaB9uysoy
         sqPQEA3mUbhfk2v9apvUZv4mkZjToHve+0SLTRNZ/eyT45MHgV9bkEXvwuyv9/qLq/Cr
         IU5JrUyIjaXtnlu2k3u21iIT5HImSVUbNvM8Eaoi1XwGH4OFvX1U2V0dz1MvB/rQMdEt
         VJwQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQaGUUkRFmErzKulZ0Vn9+WjxPGjW9LSqWDOLAgUmJvkQRR4rpLajH3aG4v7McgnbLIl+AeufAcA==@kvack.org
X-Gm-Message-State: AOJu0Yz7IXfFiu+yq6ahsAwu40Oroj3yDkYv85RvQgXxRq3bJBPexzgv
	NwxQ60Kmk+Q1u69PIE4As0aT2qUStlogkKq8UWWppeSqAzqJYpYlNoUwuO/eYWOZfXm5BuP7eCi
	fY7WDdTOvRR1AAorW8r81+JoodeyM1N7toxaecLZ5
X-Gm-Gg: AR+sD10Q895gbiXtykQ+xSW8Dm8wVoIyrf5v9juw5xEH1MWK6mpCaO9GsQZSJ25sXIs
	l1C6rQPv1ddZ8nSFvLk1EtKiWOZSssclFj6a/wrgfPBSDxGoX7IkrHQRUK6b7giwEyojlvLxQcJ
	V4ijXZ8qX/xuEuYvD0RMYyJBJckEmfkTNDT1NDChPjiVs7kUUDw4XRhBa/bKRT5nNux7Ww9VSAD
	XtaO2XRWyIhz8WcWCYAEV/43d9i1Wqk7NfMa7nXR9Rxv74t8ZDhws/Mt0hvTU4n
X-Received: by 2002:a17:902:ccd0:b0:2cc:80b9:3a1 with SMTP id
 d9443c01a7336-2cfa805cac1mr833945ad.13.1784759147611; Wed, 22 Jul 2026
 15:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260721051903.691848-1-kaleshsingh@google.com>
 <20260721173939.6bee67b6af17b54961daf4f8@linux-foundation.org> <CAJuCfpFVSrP2DGNr+tZadVzbuWvi467F879qndkQ4VTx6R1w_g@mail.gmail.com>
In-Reply-To: <CAJuCfpFVSrP2DGNr+tZadVzbuWvi467F879qndkQ4VTx6R1w_g@mail.gmail.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 23 Jul 2026 07:25:33 +0900
X-Gm-Features: AUfX_my343AdXLfm67EJ0VM2HIkYy0Q6sLnlzZfJO1IPOW7lRXEJUd7rPKBKswQ
Message-ID: <CAC_TJvd69gy5Gmrt2mz6o-yBd-ZVEUnAZ9UOcj8VW=EvfQ2HEQ@mail.gmail.com>
Subject: Re: [PATCH] mm: proc/task_mmu: Use walk_page_range_vma() for smaps
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com, 
	android-mm@google.com, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e891mbjmfifpqank5rk7cfcjgpxacwax
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E7BD180007
X-Rspam-User: 
X-HE-Tag: 1784759149-620644
X-HE-Meta: U2FsdGVkX19J3py61f7W72THA+7+vEZGxemyC9AUKFxoukR+wM+9Hyx1kpjqDuR+0LzCoIWlNGN2nJLf2G9tJcUr2oIBucl5NZtUN5y3F4hsFeuytneZql1ZK4nDKUaU/hPp1lrLBU8u6pD/CSBuU4YfflnpPNVwEryCLOUSjRVJqNz/McYoBlzvHQGX3Bkssfq0O7YP6QmqJKXHMqiWBqWWmx35gYXPcsXj32/6kW9hHioEYWEvBL2EtxKdsldjyzIqPW0aGbr0bAq/pn5zUrhFHJE7R4BosZBkgRmXcNLZvcTXJaesUdTpieymOhcQG+ZUonHETSbcmw0MLMtl3qGn/fuokd8/Yc2HIGarXpET6x7NbbxlSebvKZ5P5uUs1ArdLdoVzhMkbspo+uwkbU4aRWBlhWNP7Z8M8Esn1CQCuJHPdS8fScAgVtt3LLdLcBGUIYAZJ/IRJRPyG0fR1HWJ2F4FsJgk6U2rfPXDCdsFLhg8Mk68XQQ8xkNwOu/PkIT11exPhXczhUTmVXVKW/+U8ca9l2RXp54BCSIu+g1u/g/KnB9LbXwppEnAx8/1qlhrHy/pDgflhosQajvZqbBkdnNzcW3CcipwknxqBazpHMLpMAOo4pBA6oW7A3GXTlS7cMKpBP/y99QUHOf/i3hz7NtSwebGQ7LgRl//GV5KIVDO0gnCpMlyE1uKQpsIrMVj1FA+6ibgZa3enRnvKOVXalxnFeEJDmxNXgkbJdgnVRT25G/S8PWgOtZ1FZH8u+FZe2zREU+TgGShanmTLb8fsN0JSsfwB5Zut+SnIvTrB/0NI1uqU+K+kvb01lxFal/XJ9r59rs/ptAHBkqxVOD1vxYQxYDVPBs5oKuMgrpf2phzytz0rvg0k4nJkBLUIwTYMljZawUTEl6UGC1BL7BzaC1S6LiaBQqjNmIcg2fzdeUCIKHWprW6qDTy0X4doeAVxlnz+VBae8KYchK
 08mqqd7p
 uiEIc89CNtDxp5p/LR09indD250/6DoFHX0mm20V7UcqTf/9KTZROJcRpEd7ylL3CY0nrQBF35rN5KRaooTFOYziyWaymlzfLCNXtpaAkNCqSjh4cOFdYyLH35LVpKAUMsCHrNOS84ZYKF3geRN3VKXmcSjRBWsLeze+JXwHsTVN0vbR3LKhp5sc4BweH6ffcabbBRLOebDK0M/oSg8h6NdE58TaVF9F/gBhI3bXDT024Ae1axHABPmtIo2xPl4gnJ55hl+lszPea9UdknON+N+3NBgrAudfBp0i17zmg/7EfPuCZM9tlILrmSMtcFYZEIvghiWq23ED83GrSGKVkKB+M8TLiiJ56i3+p+IyVLbU2UE6U75wckXuGxwzilhDQAdFpVtsZLUq0hvclK7MrhV7X4zL1+OmtkoBo0qJLvJeWh2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 12:17=E2=80=AFPM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Tue, Jul 21, 2026 at 5:39=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Tue, 21 Jul 2026 05:19:02 +0000 kaleshsingh@google.com wrote:
> >
> > > From: Kalesh Singh <kaleshsingh@google.com>
> > >
> > > Modify smap_gather_stats() to use walk_page_range_vma() instead of
> > > walk_page_range() when walking page tables.
> > >
> > > walk_page_range() internally calls find_vma(), which asserts that
> > > mmap_lock is held. This assertion fails when reading /proc/pid/smaps
> > > under per-VMA locks (where mmap_lock is not held).
> >
> > So the kernel is emitting a WARN trace under some situation?
> >
> > I'm surprised.  The offending patch is only six weeks old, but we'd
> > normally hear about this very promptly.   Is a bug report available
> > somewhere?
>
> No, when reading smaps "start" is always false, so walk_page_range()
> is never called.
> Kalesh, this is not a problem that ever happens in the upstream
> kernel. In Android kernel there was an out-of-tree change that caused
> this warning, which I pointed out and you fixed. However, the upstream
> kernel does not have this issue.

Hi Suren, thanks for the clarification.

Sorry for the confusion,  Andrew. Please ignore this patch.

Thanks,
Kalesh

>
> >
> > > walk_page_range_vma() walks a range within a single VMA and does not
> > > use find_vma(). It relies on the VMA lock instead (when configured
> > > with PGWALK_VMA_RDLOCK_VERIFY), making it compatible with per-VMA
> > > locks.
> >
> > Sashiko said a thing:
> >         https://sashiko.dev/#/patchset/20260721051903.691848-1-kaleshsi=
ngh@google.com
> >

