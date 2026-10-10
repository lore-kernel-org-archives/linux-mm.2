Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DA2CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22656B0088; Sat, 10 Oct 2026 04:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D30B6B008A; Sat, 10 Oct 2026 04:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E93F6B0092; Sat, 10 Oct 2026 04:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 721DD6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:19:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A8921C4202
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:19:23 +0000 (UTC)
X-FDA: 85306017006.17.1AECCA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DC2E180002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:19:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WxEche/l";
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791620361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a9vcN5JkECAkVJNOQThJPXP1vaehPftc9ECVJHZpd08=;
	b=dM16O8wM3xYHVTSNTwsMiNRtObxKgAQ9ZYjTfkgA9bouDdZijt9ZogGJtjPt8pEz37CSmj
	vTEp1em2lbCZAK8xs1/aWu8lCRLaSA/62tXg1xtAWFZboOKhXgNqOCmMXla+91/+lQb6YY
	wjQHOxb4PISIX1k3vmbSvbdxbEH+KyY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791620361;
	b=xxHt7FgOp0OQQ3XIn/j1AbygZs+5zvnePAKSqfGe9oX0LjW5rXh479cf/7iJ897TKZfZsv
	ChuzPCmIXvKsgoPvOTH2ZLHNypyhtGQ1eYB8nkXlWkoylZvVyDIoQS4kjCI6fjW0P+0Sb+
	RWbhtzPpRpbixOSinKqPiFx+xtZ/1ww=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WxEche/l";
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A939E602C3
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6376C1F0089A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791620360;
	bh=a9vcN5JkECAkVJNOQThJPXP1vaehPftc9ECVJHZpd08=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WxEche/lEUDz6jUn0sLV8ZxYgjaj2t6pVfrGwVvoHyyMDFmmtWPHu5jlWhHqFe77x
	 nxdY8oYMKsELpCWQKI7IGdVd05gm49Ad/i0DGPeADyD7UHUk0gwyP157NL72WZNtAO
	 foo6IEQrC4tbTf7NyC7bik3vRj1nF7uOnS5/KajONYgGqkrwacK7MYH4DN66NJ/Gdo
	 cGhWyE81SA/S7Ic5k6DLukuPSHkGlO4wfAEfc9aqaUAlewkzDeyFOcEZvvQsz+JrON
	 O558gQt7JUvjqM7iZQRpPLd2FdiX6zG5qx2uOxxWnPEsJtHa1p6b1xEAw71YQpZSYE
	 a3zi5FTxTA6Kg==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-917ad52d7b6so6928606d6.2
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:19:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxulMvv4/e2EZGRtLwhnZP74ERbc8NLFKHCwuuOvR8F/H3RLiIIqBbpfYnKvyB5ZdWLN39aqXSO1Q==@kvack.org
X-Gm-Message-State: AFq9FYKrCr1jJ9jWWPeASxfj1BEKdpNouFVG1e4dMABdEjmbfRtSdBci
	8t/DAVArABgji/1bbvZStB8ukfj/esazLlAFDxa5G70HQmPLylm9YlTjARkjgXZ28b1MorjcuRj
	wxMGUqpvSWtczUoD1uLauFWozYHBvMws=
X-Received: by 2002:a05:620a:3726:b0:93c:7948:6e84 with SMTP id
 af79cd13be357-93ebd23a637mr713801685a.52.1791620359703; Sat, 10 Oct 2026
 01:19:19 -0700 (PDT)
MIME-Version: 1.0
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
In-Reply-To: <cover.1791577417.git.ehab.ababneh@intel.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 10 Oct 2026 16:19:08 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
X-Gm-Features: AclHuK_GyqhJzFU674x9sTXMJsFNi6PizF-xomQhw66ySxZ6AOmNeI0WZYrAWlc
Message-ID: <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
To: Ehab Ababneh <ehab.ababneh@intel.com>
Cc: ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	buddy.lumpkin@oracle.com, akpm@linux-foundation.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8DC2E180002
X-Rspam-User: 
X-Stat-Signature: xuo97sbitpw55bdne5od65r5yc374eso
X-HE-Tag: 1791620361-285754
X-HE-Meta: U2FsdGVkX1+fQ7fXzIZ6AL4jLnbNSzrvSEzFcLUCGj/7jKhANfbXPDehD9mVaq8XV1UjxQAr81Gy7hZPVhpCY7/MprsRFGbMe5NV69cQzv9pZ3TNEHXOUgAeCGUl/y+24VomNLRHLaCxo13wzH84J72fqM9qY/dMxORItk+oMe06NSU6S/5gPi7JScBfYkKAdxWnYTq0N28iRm1FBGyDxdbnqzBafzBGMTMn3UY/aArn6yYgEYntXHshNrdz9ntTK3ICqCb7PnmkPlE1+rSoirhY1cSK4wDZeGqx7++cNL4weJ18gvl2RW6mm5du60gbrkzdRs4QOOAqxoumN2iH4PMr195KOeggX2zzpHFIBhWICwwQECyoRatQQG0tfMVDp/hfVrXMCHhzwSPC5O1InhdpBQivZHKQyPrrn9r6zyxLesQYXSh5DU+sD7gMVNINxTdPiFP+NIp9MA325ezKB6T2GwKytjUhJL8w7yKNIi0CPVJpK0zrAhjU+PySvwKwCniKHj8dUzdy7AI3x/QsQgMdG4It2HXGiKe+hAxGY7tW5wFuIWNMyl8qdPQ56TNVuB3qyMPzZCq083NKLUQz8Y0St+oVgNLQoxd0d2KNZp4mDorldzrX7uX/U2NZrl6lFO79REDLlMwSdaUGVt/qF/pv8Um5E5AOzWz5RRLBhuWAWNaswqLz9M1oS/lm+PVdtKjOp/j2fOOFf9NhBECR3WF7i+rp9389/rMAH3XUsZmQKfnYYQq4pXWwdbymY5Qdvu22MoTqWQN1mQMrLwa6kyDil1UGhTXFaw989HK9xdZSyp3Ex36nsV7U4+9JSk1AHu/F9MFgFuechh3S67TluN5xhs3Cau1KxpNrUlfKLwuiXzF5g258+hzf7R6VxbhvOvWPi8CbGTRAwD5K4SV/rf6T9frbSRCGZDuXNGYbISC+g5ZuZsPwVtdnBTmdevzub4rvvpwYlEYr0i3vqbT
 Oa2CDNJT
 ZTk/BkE3LhzJhRDsTjU4oEHQDeRsmeMq600yaLN/QdwtFS47KVMA13+P4FOlSQLlyxSWPx6t3pRRp3WSWtgiYKv+kvI6KmifUUHA3UlYX2pdgRBR6siezh8KJ45F5V7H9N1xMSmhTrvK/IO7V9vxltJZQR5KTvnh+mFJT3qFkKWeAGWz9VfVX1Q36fNKR372otJnuWauczI1J7nkov9fsJxZNRKxNVqu/VrMQ2TJf1FdyexsVpNZX4KYqlIsdd2rAABR/gvfCwwIT65cWZpc8O15HEItuzlpZ0jDvDYpqt1xlYAUA2brDogWwo3mqZviEufpiagk6DZFLXz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 4:30=E2=80=AFAM Ehab Ababneh <ehab.ababneh@intel.co=
m> wrote:
>
> This is a follow-up to the RFC for adaptive multi-threaded kswapd
> on NUMA. It handles concurrent MGLRU aging, adjusts wakeups to node
> CPU load, and scales the hopeless threshold for multiple workers.
>
> Under memory pressure, an lruvec can end up with only two MGLRU
> generations. That leaves an older and a younger cohort, a bit like
> inactive and active LRU lists, though MGLRU tracks age differently.
>
> Regarding the concerns raised in review:
> - In the updated Cassandra comparison, four kswapd threads reduced p99
>   latency from 6.5 ms to 3.35 ms (about 49%) and increased throughput by
>   10.3%. We believe the latency gain comes from the reclaim design,
>   not from changes to LRU locking.
> - This newer result compares four kswapd threads with one. The earlier
>   7.3% throughput result was measured with eight threads.
>
> We also saw periods with zero file scans. The MIN_NR_GENS guard may
> contribute: when only two generations remain, it makes scan_folios()
> return without scanning the oldest one. This patch tests whether letting
> kswapd scan that generation helps reclaim progress. The current traces
> do not tie the zero-scan events to the same lruvec, so this remains a
> hypothesis; more per-lruvec tracing is needed to compare it with lock
> contention.

Hi Ehab,

There is a patchset under development by Kairui, me and gaofei:

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/log/?h=3Dk=
airui_scanbalance_0.3

which allows reclamation after we arrive MIN_NR_GENS.

This might fix your problem. Hopefully, we can find some time next
week to send it out.

Thanks
Barry

