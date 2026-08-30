Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D748EC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 12:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B705B6B0092; Sun, 30 Aug 2026 08:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA1F6B0095; Sun, 30 Aug 2026 08:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A101A6B0096; Sun, 30 Aug 2026 08:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 803BE6B0092
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 08:48:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 09B5DA3BE1
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:48:14 +0000 (UTC)
X-FDA: 85157913708.10.A772CBE
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3422140006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:48:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkjd9mAx;
	spf=pass (imf12.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788094092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2dVvCYD9RAYS7/u5Gv2TMbo54nxfZe+ySEn1+VlbEk=;
	b=is+OTqWZOmHcRfKoz/gyQtFTPYcTFvwrklFk7LZIHwTWluVrw7Pmf0hsAHlep1t8oQ6ISn
	VLiwcs6VEHYJmNFoKMsxNhjwXY4/VrLgZJgTgT9xBDIkpGrgFuNLo/36D9hn4MHKPK8vPF
	TOBLtsvxePL/2rkVjXW2nP4h/0FtN0k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkjd9mAx;
	spf=pass (imf12.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788094092;
	b=uWlwh2Y2ZT6pUdKkeOsvztsyIrerdx6veAzuR9huiN7BQBBhyREMUD8haICbW1CBR5zR/e
	9TieLXOiLp2BHj6vAU3NZafhxkmsYvY+OevvhVb0Vxoyf4JtxHWIZWBkY2mGeoH0WWzeof
	eGDnFckWDDegBosRDqaY1HskiDqSiU8=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1c3c90074so2017025a12.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788094091; x=1788698891; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w2dVvCYD9RAYS7/u5Gv2TMbo54nxfZe+ySEn1+VlbEk=;
        b=lkjd9mAx+Mc/Ydo5ZX2Gp4/yC8dzhygIpvM3HZkDyaJsOIlDPqwZX+eGZ4m7kTqhn5
         +/PxV58se6fi98Gl1my5sycha09GGowQ/m8wndyV/VbKju5bGW3Lb/s9lrXqsYm4lp40
         Zy3p9bF4YB4ctxF3fd2l4paHN4Uqi15+c6T9l0ZoCHY/QjzuHHWy1zZ8YcR2AEg9WWca
         /V1N2WCR8tTdiLO+X2FVNlR5RiqcSulIAQ/Qg38qmSy6C4uop91vKbNzFcWjgyspxp7q
         DIeAxG84dRPB5lfLX+hO/KkwSCI+BqEnilhYJt6x/D0ShrvUlf4yCdfdKVvZcHd4TXXi
         i76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788094091; x=1788698891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w2dVvCYD9RAYS7/u5Gv2TMbo54nxfZe+ySEn1+VlbEk=;
        b=hla/LiTqsu5dEGdmMjZfNEuudypTjBKHAdnVK4jmaQEQJUt4yoC/H8r898pv482wwv
         O51cQ/YNBd1T/NVw4+XAp47mEGkglgB/ZotDET18SE8qrLvFLcpKktl60DJYKIyZvaqG
         V47ZIU4METcNSfBY88G8cvU+SgirVigXP/kq9opr22zMcXu46WZjIzCuxgTUEd/4npMw
         ADzqOsiO22J/SA7w1LP8fNsqP+4RSy1D0Ol2X5piPaeFWi0MGK1rMLlKBikrtt0sqbvT
         leC7G5hUdPYAcm3+9T6Y1Zf2NcqMd1G3rfWzOiNQdlrk1kUXoXE5e8/+z4k1wxcSzCBx
         HsMA==
X-Forwarded-Encrypted: i=1; AHgh+Rpap3i79Uc8hWggxtj1GC2iQmuy+QvrBJ0+1dCCKaQt2HshT13BWIQ9J+S7flMLdz6lqZpsrOlZXg==@kvack.org
X-Gm-Message-State: AFuF++lYU0CI6nksqsud65XZmRDx2bQTrkkzpFibkUfYKgCTfiLW0/li
	S0+n17C85sHo5RK8K0Y7WS2ZIC8KKCUMJSgIOB3RiTCg4OctuRsxbwpn
X-Gm-Gg: AR+sD1134Inc+jRaYm6qS8XNrqWBUX3tvYLR/PbJFTWL4f7fKj57n9koL9C2cSHDFN/
	RdflXSd/od/sRTCd5DKp13LzHihOSdzeRWaiEQJ7MaSGbp+f37sm5mI/3ljiwuUa2x+xkMFY3O8
	SvFFTi5bl0AuHmn4lGoTauk84bONw1KnaJVxBLwL24v67mex8Jtwccw20tUwz2zquGreEQIaTwG
	EgeUbUki1OnbZs9R5OXrylg5OiCXpwzeg7SGDHvPTVZsh69YxKl0LJl/6CtE07v3I3qRzWtxXyD
	zyhd8JMMMwVCDK6H0EJY8RgjYI2MERWWgsayaJ4YzIJ5Ik6SRUW0JXhEc3+XoDH41iBv1M3RPfY
	trDOIucgryv92f8B1Jb2YGSxY1qns0XYDmvNBIyGN507kBQMP0YzeJvEszrQwj7QPcNFyhVztLj
	SnV/u9CYd+dQh1cFWvzoo0umr8sh2sO8BXO+iroX0akz0nGkQZjqZnCcHPm2xxQ8HxrwkcYXINU
	ZgcK+wDFZb97tXfD7WIpLog6k2h774tGQTryUHNHDY=
X-Received: by 2002:a05:6a20:d0a1:b0:3cd:8bba:824f with SMTP id adf61e73a8af0-3d26562ead0mr32088995637.4.1788094090908;
        Sun, 30 Aug 2026 05:48:10 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286f552473sm25325171eec.0.2026.08.30.05.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 05:48:10 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: willy@infradead.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	riel@surriel.com,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Date: Sun, 30 Aug 2026 09:47:56 -0300
Message-ID: <20260830124756.457887-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <apOkscUtVMpFqFjM@casper.infradead.org>
References: <apOkscUtVMpFqFjM@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hhqg4t3b1p4t8eqx9duiyuqkxzgao3bw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3422140006
X-Rspam-User: 
X-HE-Tag: 1788094092-551852
X-HE-Meta: U2FsdGVkX19mbLGmZBTcrH03lTyqBg4QLDu2qO1zlhZj7xlQflDow7PuYjsgVbsof7G8HnNSYY1jiI7dt5pfCZMD6S53xMzAhmZtKwKtOMLcK0PQYVl+BaRw4uaGe1eZLkWTHTgEp2c8rIWd4yeBuep7OA1bomOqtOI1tFnKdKpU3HTF6d9Um6iRLb7Lpg8S9qfDNCG/oVl7odfVLYOB3H7h2TaB2FIGRLxv7Mhyxgwu/eleZEC0Sb/r7DxsBFfQDPRvPpw+9Ccvd09uquaP9UJG1xEK+CoJkJaDiDqJA3HH23nR1/6URBQWgv1c6yAuUeOS4t/EzXLRRxZladwGcxCKoYWwCLKY2Vc7ESiIDdGzVNdSY/TjY/JDd7Kxzcgr5HquEGdRU/RPj3vYWFLYP3zsvVv0+4QPNDzEY1EgLCdoo3RLTJVRAM7nXEYSCa+9wOEfYjIhMNRReJIZa4q6xCbntXABAtX+gfKUEjT5AgQimIsnQ30x2Y0aW8cRQuMxrbJ5lBc5bk628sP3UAbFygjXc68QD84L6kAHDQyWNlI9MPrNL+vm3nYqJ4xoPTSzR1kS66j0aOKltNy4yS5+RWbxyW6ejSBcAYfuB0ckV9qTMooCTQBtD5FiUrhaa9n7xBt+dJAqOmBdC5Kk4iIRAIm2ymjW+KCBsl13McASDoTeKW7EsPcZv17Kio8PYLFS3KowtmUFph7+etZPdgdAxWOrExJ55xh//xRhXlgHCjCmINwKsiJ8KW7vcHz+geFl4kYl1ah9MY+psyFetn9uFpselrb4YbcBfMQoXbMhMxYUcyCU4DOiyZ3FW5Mw2Ta/IHEQPU2VILYmt6jqzlq/vVG5Mp/I+B7XsE1KjVeG3GVaKmw911Extj8E+lBW4GUHJ8dVeSe7oE5JVdLXOKrlc8q/+iXbdsKzzuYRxpqOFtLqcRUpgizyYK8DGjBpJCJ1vw5tCclI0lMVn6e0eOe
 lHvHmAd1
 otqBwqxqxq+LLPU2oWsq1Q4cBEcOZ2G+h3FIwjRBJUurt8X4gI6S3bxHgkP1kKuMuJ5kt5W9x61wQ97c8PDrcaCUohpTNXZEpf4gAfNEU5UrDLcxQyYmlhd0rUeOpWPr0NB37mTFd123i4XjgLHByyGBUG1ySU3w7Iar5/AIukvDGG/iOdk4lGVhR/exMZvWU6Yu7rO7YfSOI6k/hog8Mmys49mygk2NpuVewhhmpBgP3E43k+9p3tz/Qf9cC2zYmpNmzPGO9QPCNQb8jHk3DWo5VUAhtPGrah1ECZEWG5DzcdH4rptT6a8zzX0xStv2Q5BtjPWrG0nRS/xBqWaMmpcP84yGhycVQ0vQ/7yE7BXDNMIgIqexUnCf3M2c3qhnmQUUqXLTRRZckEhcW3p9N5ijFziaaAp+udjstEnC7bP47DyeRf/cjx0I0IBV3x/Ssi2EYM3sxtQi9YHvqEeBy+VTLnBRTeDrJANvWe9H7AL95eQC3vUtVXfa62oi2mqELjYPsPnWHfl1z4cPDzF8Rjo3RfhRDrYdD1zntXPcGCr/RpFUyPEZMow4KcTSOijyq843DgzAZy1mTc1jGT7UJhUkxaZd6r2LosWDF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matthew Wilcox <willy@infradead.org> wrotes:
> > >> Fixes: 164b06f238b9 ("mm: call wp_page_copy() under the VMA lock")
> > >
> > > what makes you think this is the right commit for fixes?
> > Maybe I would should analyzed this better. I only seed the commit that introduce
> > this function (and consequently this reader)
> 
> That was what I thought, but it's not enough to determine if that's the
> start of the problem.  Look, that commit does:
> 
> -       if (unlikely(anon_vma_prepare(vma)))
> -               goto oom;
> +       ret = vmf_anon_prepare(vmf);
> +       if (unlikely(ret))
> +               goto out;
> 
> ... and anon_vma_prepare() does:
> 
>         if (likely(vma->anon_vma))
>                 return 0;
> 
> so either this race was already present in 164b06f238b9 (and you need to
> go back further) or it was actually introduced later (maybe the write
> side was introduced later?)

This commit introduce the vmf_anon_prepare():
+static vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+       struct vm_area_struct *vma = vmf->vma;
+
+       if (likely(vma->anon_vma))
+               return 0;
+       if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+               vma_end_read(vma);
+               return VM_FAULT_RETRY;
+       }
+       if (__anon_vma_prepare(vma))
+               return VM_FAULT_OOM;
+       return 0;
+}

in commit 2a058ab3286d (mm: change vmf_anon_prepare() to __vmf_anon_prepare())
the vmf_anon_prepare became __vmf_anon_prepare.
Where the race problem occours `if (likely(vma->anon_vma))`...
This commit 164b06f238b9 is introduced in 2023.

The write side is introduce in commit d5a187daf585 (mm, rmap: handle
anon_vma_prepare() common case inline) in 2016.

> The important thing to know is that the mmap_lock is a read-write lock.
> That means that two readers can be present at the same time.  So this race
> can happen when both threads hold the mmap_lock.  I don't know whether
> they do in the syzbot reproducer; probably not, but it doesn't matter.
> 
> The other important thing is that _we don't care_ what the value of
> vma->anon_vma is.  We only care whether it's NULL or not (this is a
> sufficiently common case that I wonder whether KCSAN shouldn't special-case
> it and decline to monitor it ...)  VMAs are created with a NULL anon_vma,
> and then if needed, anon_vma is set.  Once set, it is never changed (uhh
> ... at least I don't think it is.  Lorenzo, could you check me on this?
> I think all the places where we set vma->anon_vma to NULL are in
> situations where the VMA is not yet exposed to the page fault handler,
> like in the child side of fork()).
But if I have a write in the same time, this can be a problem, even though if
you only want to know if vma->anon_vma is NULL or not.

> 
> So it's inappropriate to use READ_ONCE() / WRITE_ONCE() to "solve"
> this problem, because we don't need those semantics.  It's sufficient
> to wrap the read side in data_race() to indicate to KCSAN that we know
> what we're doing.
you sure? 

the __anon_vma_prepare(..) is write on vma->anon_vma and the
__vmf_anon_prepare(..) is reade from the same vma->anon_vma at the same time,
you sure that is not a problem? (I'm asking as a curious layperson.) 

> 
> Also, as Lance said, I don't see how this is related to huge_page_alloc
> failing.  All I see is two threads calling  __vmf_anon_prepare() at the
> same time, which I presume is an attempt to COW a hugetlb page.
> 
> I don't think it's enough to just add a data_race() to this one read of
> vma->anon_vma.  I think it's quite prevalent.  There's probably other
> syzbot reports that mention it.
Yeah, I mentioned this on commit message because how is said by KCSAN the
__anon_vma_prepare() and __vmf_anon_prepare() is called after huge fault... My
interpretation might be wrong and if so, i will fix the commit message without
problem. 

Thanks Matthew and Lance for reviewing my patch and sharing your thoughts,

