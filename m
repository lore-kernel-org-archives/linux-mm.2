Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D65F483CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010396B0005; Mon, 23 Mar 2026 12:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A826B008C; Mon, 23 Mar 2026 12:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FD36B0092; Mon, 23 Mar 2026 12:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D298B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:26:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CE1EC39F1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:26:20 +0000 (UTC)
X-FDA: 84577855320.24.79DFAED
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AEAD40007
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:26:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gyy+YVAc;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774283178; a=rsa-sha256;
	cv=pass;
	b=EXjrweH3tqmrvVvDfcHbHmjfNfGeSfRCCGRhfLn5IfWqCEHKpM4XV3d1XQWymKvUF/+zz3
	Nkrf5v4EEadMxojg5XF8SLCeD5vhwKI5Nd8Zx4K1wsm4TRYeOv66Oy2fg8kA9tq+eqNTgL
	lpebNtwfrvKzvZirBmPJMjLykKwYPp0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gyy+YVAc;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774283178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sa02RWDZ55PD6em/0hw+fQdWq+DqfOIo8vL6O16AHXU=;
	b=E36BZEbyuQULLQU8i+LTbb0HqyYPUV4riuCcgM/bdj9wRYdIw87X1UMpSeUAReQRANHgvc
	vXRDWzF6mcpypApz4PqoPxr1Ad58MjGwRV+b+UTLZgATULVWb1ZOlopH2JeQIpBXNri6c0
	e5hKK8vr/SuBX3VHplnexuIWFGFEZkc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-667cde0fc88so16550a12.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:26:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774283177; cv=none;
        d=google.com; s=arc-20240605;
        b=KpsL81014nIm7zReDM/FiMGOlabBLjkGUCJ+I1zVuwr4jVaJ9HyHsaZNTbgBCeMlqQ
         bTpSGtmNTtZQf1diys9mku6PulH0vaQBm2vPkAYu7auC3mXV2zpMtSyW/eGumv9fJ1u4
         3zkQZ9ZEt8Pru2VEL9fF86/ubcf1vb0/zO5CXPQ3r479ZGXs3IUbtOwmU8lsFLleehIj
         AgglB3DRiU+IT0pW8xYYQDHM17D3+qP1trKJvjOy/wG2rLJRPJ9fAexSPPFrNYNMrMuO
         lQ7TJT3Lo5nigdjYNSCXj7B9xh3HtOz3ckpIzYZ3kFsty4jKzYbeySwEkBq+lXpO7Uwe
         5Hbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sa02RWDZ55PD6em/0hw+fQdWq+DqfOIo8vL6O16AHXU=;
        fh=fRGgiKubCejk743o8NHpcXKovqm1qQe8fBnBNRrur7Y=;
        b=cODsBpgPc2kkUY7s15Wh5ScxD5P1ODimWackfFEiP/lafzdpitvlPgnfjma6sUqK8B
         /EeJ8YHpyYYvyBFnMytAugxn6NgC0MFRc3es5EuiCjWgqjym0jMYC9bD5ggGFKoi05CE
         ihJY3xfeaYfKK0BcOytYRVCbotmIC8IhT2wdBy8YD4o+vMvBdcZkhc0x2RBV+aEgyP20
         L2n1HCZ+3DVEegLh2OuHTbidu98fPD2sSLITn/WCVFWA6fw3LVS4F7RyCtS8ZuEyAgyu
         ckKRazncMd6V6LkHbXx7OK70D5ZsLRqg0eGQygCsQdinMsaPkrw1R7ReL34J2X5wHF1a
         vDSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774283177; x=1774887977; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sa02RWDZ55PD6em/0hw+fQdWq+DqfOIo8vL6O16AHXU=;
        b=Gyy+YVAc5X3iwjf1hsQZW5MSfLbFokm2Gdu//adzfiDb+H9uz0KcoweOy36sT6aVus
         lFwgrel22HnN9BDlqV6Ub09LJoHImLkhViFstIcR78vnbe+Ue1pJK3VavYvdWFTlV1Jc
         iGO9yiMzM9C+1kodVZ5vol/IZLBsUQkLyh6H4lRg8ev5CULxq7Vz3pvAp3jPUfQzvYCW
         QH+Z5AxvwqGAazNrKbam4fHtW/RbH9/Icxm6UJ2gJEsQUfrlfPgaZzdZiIuFUU66Efhv
         peiTiiK1vBOXU5VpL8ZllIgSNptGAeXYCdhF7+mgtlLKls5OqSLMk9rB2BoeBmNaF/lc
         rw8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774283177; x=1774887977;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sa02RWDZ55PD6em/0hw+fQdWq+DqfOIo8vL6O16AHXU=;
        b=FiPt3MZmEfS6CHQYXruosS5XCdOEDS+RzTfNTHb7LYklD7fUsNUpj9558X9j3iWbsr
         +l+1i8sBcbyKHuIgBNpmuohhjvcm332cPBqyPIiCAVpfyAA6meLMiWJBHRcPZxzRfMOm
         pRQVPmCjCmZrxR0r2htsOXcT5FvHV2HpWZZa6ciLu+jOwzNrW+jdfXKsuOj/TSKJzt4e
         2125HMl2x4+n0d458Xu5w+WdHV3iBl669MywQqn/dg5dQEdE+EpMaDxq/U4TXFyVWYos
         cTuXuaxjGTmoXY5DbrvlFj4usidA3AbunJi6YScUiqSRnA3qLkBb2YEMU3Xj/XIMtRaG
         GbkA==
X-Forwarded-Encrypted: i=1; AJvYcCXusJtaizjPdMXW6FMvxkV32Jlf+AVdzdqrnJwxBz78UNlM+70GaCJ65V9MFQWbdaWxUgWSgmojlg==@kvack.org
X-Gm-Message-State: AOJu0YzYr0n3gHJ7oGQIwj4ObNoofSx9KocSzBwSF8azH2G72FfYu8gR
	43UsSQNIv1TDqIsW3JKzDHT229+K7VTigekK3lYg8nh5pCja4zszaCf4THbztfuCvI5NM5znR0e
	HsEpVQUBmRh2vDC2VE5sC0698pAcaG74TJMLjug5I
X-Gm-Gg: ATEYQzymc8J98k+1HFuIK+LQmIubcSaHq8R5S+HYRHbv/SKU6aa8i0hNnIoxvPEAomq
	D5wckYxkuqnR5LLs1U9e8K/p9YE2VdxoNKjm+9zJ3DSrVYIlksbOPJf0pvWQBm6k2g/GuNq/ngC
	Vg2/WW+hFNCM4F+jMLnrSiNtmf0WKSJCrA2rt3euCHnK0mDOmAgf7eUj161xr3lJFZqHfVC98ET
	ieaGvtchA2GOGU+IOOs5PP4R5N2h8rbxZUtJyTOZmXNMmdZ0ReEhMpjyiwAd2G5QbyXk5+OQ3VM
	lc5PtA==
X-Received: by 2002:aa7:d1cc:0:b0:65a:1240:b8c4 with SMTP id
 4fb4d7f45d1cf-6694d002a64mr43286a12.3.1774283176120; Mon, 23 Mar 2026
 09:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260322070843.941997-1-surenb@google.com> <65cb38ee-2815-4b11-929d-3fc1528cc620@lucifer.local>
In-Reply-To: <65cb38ee-2815-4b11-929d-3fc1528cc620@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Mar 2026 09:26:02 -0700
X-Gm-Features: AQROBzAnXd6fOd5-0DtwGKGuyxDjiwJX4YSM6ZsiwuTxV14NkOPK2l2DDkj64jw
Message-ID: <CAJuCfpEm4u3viNt3hG__RbgCJBxFQpFvjx2cAE-fg3DGPfja0g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/vmscan: prevent MGLRU reclaim from pinning address space
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, yuzhao@google.com, 
	shakeel.butt@linux.dev, willy@infradead.org, Liam.Howlett@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9j71j8bkeex76h7s4gtox3e6amp1zqqa
X-Rspamd-Queue-Id: 6AEAD40007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774283178-710835
X-HE-Meta: U2FsdGVkX19/M4cG+yggQch2EaE0kaa+KOahK2ElrX87xhblYjbo971mREcZ37pKO+qDHbJ749qjcQyZ6tUDXmhljDiyOmF4eatVz3MgbRDc1Xog523wCvt7Ed3vnWL+Sab4rHNJ+4DcXD+cdNNNZ8xBJ/iZU2mDXvhesQ8OkaYV04KIfrD9146ill+YwS6E6OCyrnc1ssk1Eo6lTK6aJhf3TN559duw3b7u3wI5QPUAskytFZvaMFJG9HCFZchToe3kaqsPHFbV46yoYMR6xJPQ+8ME8aAREwRKMzSwkaRsuprXRapC6vwqQ9zIMoaSPmY5AYOdAPWKtf+l4H8VSRgvivVfUyz9Rkw2MbroZB7UjGXEhJnHqmhuKee9G/V3xNb6RnJcjtLQ7C0Y/DTEaRWjv37SgARO3yA1TcVbyFD8hhOaogpbJdT9xD0MBuiGmYAl3Jv2eAbWXOPtBjBvm8kHU9xc4IWe7HDBMuFXUjl2/BTMqs2YccrIkt0z53fMtgca/PbdzN4uzw3Os2iN2pXx64VS6etIIuy2ZOhShvTrrPSY4ikkA+m/M/dbMyXEVnImlkgx76wAVwuy4k+GvS1w0q3iZVLlcsUB7wrcYfDWllI8wqVWu1cEnr7U7jRbb6RKwNqOmhI9zcNI+WMPLMA4s8qsFeMkK65i7cDaUI1A1sFB1B7fWywRoVWM0fn+I6Fw/ywez6mvefh8kkjHnGD3ANL10jgnzzOKoXwgp4OcqYpS+ElldphdMmRPklISKSYdsARZ8uF0VvxOQpZBS4K0i2UhpcYT+QPrkOjq+GM1X3AfMW9bMdeRqUgdb/VxFVEC2qbS3Xp2D0+kq1SgmtWrb43Ao7Tfl8+21uFjOEOEIWl2FEqZXHmsqUHP9xP4oJLFBhI+YIq6ncVvB5hubj6Cb0yq0uInev7eD1bD3vXWUdAe8c74bZwoDl/TEvol8tYagM5mTsV0u8Igj7l
 4O0aqre2
 yi4dYeiX89td5AQbNV0sITfqphyoon7I4zLJAUoTNUBP32UUZh4e0jktjaz6fJ7uM+AW0TT9iM1thJfQ1S5L4o8ToY/mLN+x+VLC0IMLLbxpnvSQmxWWTPnq9jJjBsoN63Lw6ve7TJj+TkWPjO2pD77G2VaKhIHJ/s5p8Y3gix7CkZSNL0NZX3hSAuEVdyzKsKl0E9IriEwjlA6eauGZYJn7b47fEYNHr0zwulf9FNiEsLzQljKhcwhJUXaCzE3IvV1RwF5UumeafEl0RLS0CAfBht2+fj9ET9Opv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 6:43=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 22, 2026 at 12:08:43AM -0700, Suren Baghdasaryan wrote:
> > When shrinking lruvec, MGLRU pins address space before walking it.
> > This is excessive since all it needs for walking the page range is
> > a stable mm_struct to be able to take and release mmap_read_lock and
> > a stable mm->mm_mt tree to walk. This address space pinning results
> > in delays when releasing the memory of a dying process. This also
> > prevents mm reapers (both in-kernel oom-reaper and userspace
> > process_mrelease()) from doing their job during MGLRU scan because
> > they check task_will_free_mem() which will yield negative result due
> > to the elevated mm->mm_users.
> >
> > Replace unnecessary address space pinning with mm_struct pinning by
> > replacing mmget/mmput with mmgrab/mmdrop calls. mm_mt is contained
> > within mm_struct itself, therefore it won't be freed as long as
> > mm_struct is stable and it won't change during the walk because
> > mmap_read_lock is being held.
> >
> > Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Oh and sorry, missed this - do we need a 'Fixed' for something that's jus=
t a
> perf improvement?
>
> This doesn't seem buggy?

Well, if we are pinning something we should not is that a bug? I
didn't CC stable, so I don't expect it to be backported (though if
it's accepted, we will backport it in Android as it causes real
problems with reclaim), however if someone is looking for MGLRU fixes
I would like this patch to be discoverable. If you feel strongly about
it, I'll remove the tag.

Thanks for the review!

>
> Thanks, Lorenzo

