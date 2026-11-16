Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C765606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 05:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fLH9oLtc
Received: by kanga.kvack.org (Postfix)
	id 0B4176B05B3; Mon, 16 Nov 2026 00:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DC26B05B4; Mon, 16 Nov 2026 00:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E234D6B05B5; Mon, 16 Nov 2026 00:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AFAA06B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:30:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27B5CC08BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:30:04 +0000 (UTC)
X-FDA: 85439855928.14.FC0FFBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3611D20004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:30:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fLH9oLtc;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794807002;
	b=3sUtTy1DGV7Y76Jbf3soRNjasmoC1KVLN8VHx2GnlPKBRY6iWXQ9jhb+wLuWPN8pKFEusI
	5dH8ulHC7Qvq/X0ALdHNvdkRYYPKXRmTpGg+QggWEdAoHw2npSf5jcDZUzC1P/4QpE6NNr
	EgdRrrvsPshbz9IW2zeXHTClXJO3Ixk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fLH9oLtc;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794807002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk2Zu0f1DcqbosEKPJowBE4Ne6xneVgP8DSPeZYYzbk=;
	b=IKn5FPj8abE0Rm67TCvaXulsS33TlSUNjf59ntEv92u1XyxG1hIIVZ+hh5ygsIVo4ysHla
	yHaPvyZAv/tJIdG+sAxgharf9YOQ7o3MuxGKpzxyIilDt9MlfJO3q9VD7xYiAAlxu6SMJz
	Hp52sKFva22b3z5cGe5tmG2gLORD4K4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E50144ECB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E61F000CB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794807001;
	bh=Mk2Zu0f1DcqbosEKPJowBE4Ne6xneVgP8DSPeZYYzbk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fLH9oLtcPkXkGwa4fE4J/2iVMbLj5QRz2iTWZoByKBupgk/WdzzvfCHJUeK5ePGnx
	 imR/4xDdNfG4llLAK36/cOfkUko4hhCBzIoExFwwVh3wqK9fpBFIxXeoa5qyr+ZWXS
	 KCZH2iDdOPZzSWbela2oNJE3JUsXIFc0nKeqDqnLcGoxpCrPiG8B4OW0BcdvikrNa/
	 qE9JjCeC/SZoqt95oJEoQJISy2TUs/xyxamfsq9pEEn/Hn8Un8ezcgNwIGYV4E+ZbZ
	 hkAozbQwW3mfGLx0Xqdn6d+Zg1wYotwy9ugeU7mowr2YeTWmgEOvXRCfz+U6LFA3VQ
	 w68NAwnS6s+ZA==
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f20b304c0so374789285a.3
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:30:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGG8T4QGOMNqw42wtgNSk5oWs2oD3u/AfobQPr4XtRCn8CInXX3Rhf5Z80PSN776hW2Du9QenBVjw==@kvack.org
X-Gm-Message-State: APuU4Z/KR6DWeATmw0itmBYs3zf7PFWH25vnsgZrJjsDmtTrsH2wyMY8
	F/YmcN5jo1Z+Bvpvtor//oF/cTTh9pBdy4DKpkkz9pNHEwp3jsOul3SgDFHJuKdjy2ggi2BLjno
	5QYRC3KPkKdGkVpfk/YhoYey/SA3FnPQ=
X-Received: by 2002:a05:620a:1b8b:b0:949:6476:91da with SMTP id
 af79cd13be357-949647698c9mr955938785a.31.1794807000541; Sun, 15 Nov 2026
 21:30:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CAMgjq7C_cH75JrYs8=P5LbxnDjDD6bqeqsCidOPa=r8Z+42sCQ@mail.gmail.com>
 <20261116042556.42111-1-baohua@kernel.org> <20261115205046.8473acf5a93d69d460598559@linux-foundation.org>
In-Reply-To: <20261115205046.8473acf5a93d69d460598559@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 16 Nov 2026 13:29:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ycvQ7c1WUmk7y5gW0tE48kThsLECmKo0UtA5Hp3tLr1g@mail.gmail.com>
X-Gm-Features: AclHuK_8BnV9_Nby9IDOzlOHAp8QLuDw8I-j62xEDKsAvvH5HBBNGmkFtfwxX5A
Message-ID: <CAGsJ_4ycvQ7c1WUmk7y5gW0tE48kThsLECmKo0UtA5Hp3tLr1g@mail.gmail.com>
Subject: Re: [PATCH v9 10/16] mm/mglru: Run aging when pages are rare outside
 the youngest gen
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ryncsn@gmail.com, axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, 
	kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	sidchintamaneni@gmail.com, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h91ntrkbmzyc3ajg94fhxiysi8jenj71
X-Rspamd-Queue-Id: 3611D20004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794807002-366708
X-HE-Meta: U2FsdGVkX19b5Ltr9y/lXkWoVYJVKt/rPRTwW25MMbQvEJVQaPejcIJGLPzvDEjWM/z/U536mfUxcoub4sBCaNnR1GZNn/trH2BD+EL3mBxs6bTvuImPb8cwuc88ZMOyAyMBL+Uon402ncc9dXcKHUxpGJ5OBEsnEosxqKsCzVYsrSW8JLZBKeyquv8nl1LWt7GmN+6CAAjHsjZiYOssrH68x990ecabDw/qsXVNTZGF9dp22IJBBIbZg8dCh0s86/AMrY06Zao3q/rewCJ6P726cfAVo1qcOBsH4Ns3L5CjJKA1xd2iRkVo2AIv1Ls41t49giYEt1llknDeEZhxyxq5JE02afgFGP6tMvHmP/UcyWanpQgVsqu/DBLEttwY/2+cutC2tqU5gLWTYShrGBC6UpZd1AI0dzSUBP6R+dY/TJIHT6Kyxg41Gy69SImAJ223MBhDV1r0XR4jbKYZ9O0XLC1qmij5aY6GibiG+LooSItIBSFmRaFeNRF12c24778lrfXdm420FUsrQx/KeyY9WXu+GH18WD8xXEQ/0r3/x2vGp7kMoApA5wpesIxEJcNPYv6cJJUdrEfKA3miB9Y+v4jzoPPNs+GrZR+bJPA7DqnGTGIYJBDgn/GSSr0VeJLup7nr9G/TTWJ+viIMcTSd8xQjl5jhy+q/3FAregbyBIFGNRXAVIVZ/21zz0TjQVI/LOj7+hVusr9aCpBX8fx2P+IAP9HIBXypTAq52mvvyXLjL47fk8NB72DyoPFhhAiT6Q8y0bs2pXLh/Jt/TujcWlr9fGBO5WvTf03vLhyX9UpytJJHc5UBeFZuP4CtPVCr8jsq/fwc+Bax/kL1vEgotivzEyZnMo1LqhR7d+EbYnWq1bgRCuzgtoyzZAyqg0+JxUFQRTDNMr/LVIssBHM50kMo7639kXDcdD3TOgdGfWydvY6R27wYGlui+6Hyk3ewSBuAm+eiSGuVZ9l
 0BrRo1Q1
 0+u4wSYDdt+/lkeh91CUtykM8RZwtj+z98LEEBjlnKlodVrPnv9ED+2pHxH9URsh92/w4Ka7zfn+L8yt7kGdHqeIjCM098j4R2t9KQ3Y16g1tmnjJaVddzussnhJ/f0ibBnSmeap7jTI+qUTTb3kVl2hHkhVnKboF9oQ9QcSCRgF2S4Hp2/v42q419sH3oYlMAIBGtOVfPFIZ1oENGh4kW7ng426sJ0voCwarINngNM1+tuHnP2wLS6wFZqR8e4ak6KVX4Jg5VYgnAsAz8moYdVe/G528MKlD1yprI77trGX9KMfAvAmPYlwkeIiutS3yqBJBLeyiXppfYuhGr5lj5+zH6oXRxn5jXX4UgXWAEo6gX4qOXjNhSMIqEiPFRqUfjIAgoTFpDtQwHPljOTHx7sFtWHPFSptBXMBQ5PWIxwcDiZyK3oi1tQYZLDUoWcC6DKneKnV/WjvbPWO2ZuMCrSciNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 12:50=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Mon, 16 Nov 2026 12:25:56 +0800 "Barry Song (Xiaomi)" <baohua@kernel.o=
rg> wrote:
>
> > On Sun, Nov 15, 2026 at 11:55=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > [...]
> > >
> > > A little nit: with the rounding above, I think we don't need youngest
> > > / old as an array, just an accumulative value seems enough now? But
> > > feel free to ignore this so we can avoid more update noise in this
> > > series.
> >
> > Makes sense to me!
> >
> > I guess Andrew could help squash the cleanup below into the patch?
>
> yep.
>
> > As suggested by Kairui[1], we don't need youngest and old as
> > array. just an accumulative value should be enough.
> >
> > No functional change.
>
> It got a bit messy because the later "mm/mglru: restrict eviction
> accounting to eligible zones" alters this code also, but I think I
> figured it out.  And I might have accidentally fixed an 80-col thing
> while in there ;)

Thanks very much!

>
> Here's the end-of-series result - please check.  It compiles!
>

Yes, that's correct!

I checked the code line by line and also asked three AI models
to double-check it. They all confirmed that it was identical to
my local code, apart from formatting differences.

I then ran another test with the code to rule out any possible
hallucinations on my part or from the three AI models, and
everything still worked fine.

So, Acked-by from me.

Thanks,
Barry

