Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D78151061B1E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3D46B008C; Mon, 30 Mar 2026 16:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC056B0095; Mon, 30 Mar 2026 16:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B396B0096; Mon, 30 Mar 2026 16:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E08656B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:15:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 91BBD1603AF
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:15:29 +0000 (UTC)
X-FDA: 84603834378.24.6CE038E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DB10E40005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:15:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DXjJrXUQ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774901728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wajtOlEIW9iOZk8+zQne502UuaTwcYg73fwpA3+UxYU=;
	b=6IapWqbzEsAoYTqGGw8qfMudQVnGOsaIBvy1z0wWHhPAt6s23ca7/2W1dMAnNN/y0xXzV9
	cnaNHjSaBYgw+keGSCBOgk3RebZQl7W+xbundOgDQN2OH4QYwTJdatfc5W2MrgOjKXXE3j
	C/uKNFMywRoAmO1+GXzR9650sPwO5Bs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DXjJrXUQ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774901728; a=rsa-sha256;
	cv=none;
	b=UR5XpeTaS8KefYC3nRJPjdjJPGFCB8BGTFVYu/+Iofp21E5TD74B53pL7TuI9k0k5/JTJg
	QghLQ1HMKPBlai4d4yKk/H6WeghX9OR5FZPdgp2KGiEmjbIMa1Z2ijoszO8nu4IYFmjTcp
	lvShXzMlvkH8AHuMwRdzm9ECNpApWZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D74344587;
	Mon, 30 Mar 2026 20:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23289C2BCB0;
	Mon, 30 Mar 2026 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774901726;
	bh=GIdFwH4V271Mu/YGd/0E0a6mBcxaQo79oumlnrXC8oM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DXjJrXUQFhraEcid0ADlvzZgeNe5pvalqy/dGOPmBsUe5OqI8MnuhkjVpKerQOhFO
	 u3AaDUOmclDIs3JQP7V8OclSNvaFSZAepXwcODH288IKOKbcAPOGPFDN2LTyNMKytt
	 gsD/AHBc9EHdVGBooD2dysEQ76RdAbO4dnCawfIU=
Date: Mon, 30 Mar 2026 13:15:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge
 mismatch
Message-Id: <20260330131525.630b8ff8913ade1e0e5c2054@linux-foundation.org>
In-Reply-To: <20260328065534.346053-1-kartikey406@gmail.com>
References: <20260328065534.346053-1-kartikey406@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: td4eijrx44k8fdus4ikyp5xb7onb87am
X-Rspamd-Queue-Id: DB10E40005
X-Rspamd-Server: rspam09
X-HE-Tag: 1774901727-561724
X-HE-Meta: U2FsdGVkX1+YkmcJv2K3/YJDTNRbqxHYs9QCteEKgkQH2HzyDnQCN9sypFsB5uomfHFiTGWAC8kd47VXMGJiEh2PaUxDW7M8ZXGv/pq9AmyKagV6u8orKAVX7DV+1q3NHLiVx1V/V4hN69AiweAFfj/GRozSCtGBuSS8fllioHabJ6JH7JHDL2rSmgnVaNoNH+sFexcYXb0nl3b1vqBgpZUo8pWsQWcivu63bM3MQVLjPmjlL1jg+v2HAUxQRK2Kl2gNLthdFH7cQUQVGbvt/T1+fy1xtTOZjOV9qu/2k02Omg8xTzL6WevVTZNGNdGhWLHMqKRs7GcBQa6w851GdYlSzwmYaASZbYv5xw8LIupGZzSuDjUtCwAcmcFTk4mUNhf6sKtFswfFSnQdr1VM1MLAXL380I3EvyqB64axsu8upnaHCJcptXIZVLM0p0lS1jCvfrFXdTyzHzP0W77Pmuyvs22EQyhfrfqfaQzTDLxT3bZSVWurOGzAU2RZizjhar2mX/9tdj7vg2wteWGKOBbu9dqU9R9v9jfwpOtUBdgCAcamx0lFY6+j8/mUbljrNmFVKUSnyQESQM8KBiu+De39WuEltSzi+o8HN4C7vMidSMczrQCY3KgJnGnOzuoZWlKXvuiiC1aAVdsDzwNhU+u2AI4WUO0lEyU8sB+oVU317IA+vG4XdIz0393Gp2IpMjZ5XV6Ibmm3Cy1xovdCr4AM5cuOB8e57PL3CMrCuL9GYH471yYaHlVPolE3aRCQGIfaQIBcrltyXzNhy4yOeyu/WJeZJ6qama7UukihKzP3jFZN72IPCAytlzGVKr21u0TxW6P4jjWHjqCPO/c1zWX2nXZV77q6rJ2Oz/+UXvPOjvQSVgsK2V3INqg1QXlPLOFET7PO2otGW2tcTrsWfgqd/OOwhcD7SdOoyP8tmAf4BircRP7k1UsDwmtAKjFsvb/N0qEcM9PVciYZa9V
 T2kK6DxV
 6J00tXGFtgIZZ588DCQOOIWqqKI6E0lrTkW7U0IitCAqCwwsZjCuuut7m95JpRuLPf61Xc5NgAcFkfuvaeIQGITL8nsyZ+j2qA0T/2jRYcxC4krjwjncJXKqK/NWxBrPiSaLtg3xueaanqN6AJCmjb04kCPWe2tlVbpwniM/F/LuzbUE+I7x5sHYwyHmNRUmb717FjrE/uJ7DRJnIrUIWiOPJX6H6wUwcBb2dcRs1SRvP3ICkD8IEnj5++TxP3Lg/Yht6KG4Rf1iVt0B3NGfCFGutMwZPcRACYZvfBod1WHEJVUG9NyZodj37ZIgHptNEmiEFvqAnzjhstS/+It9mBhP24yDLcDKNPrp5EEKDW16r9beS0xPJZcZnxT7ZDI+72F7YrmtWr0l8PgFM4i6qhXZmKTBW7LL7D84ZgQy6RDHvrRnU8IdacgrAgwy6fRPWu1Nlk2HRdFN9fPt1OKANcTQioiSjehMDLNUU/rJaom+ruNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 28 Mar 2026 12:25:34 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:

> In alloc_hugetlb_folio(), a single h_cg pointer is used for both
> the rsvd and non-rsvd hugetlb cgroup charges. When map_chg is set,
> hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in
> h_cg, but the immediately following hugetlb_cgroup_charge_cgroup()
> overwrites h_cg with the non-rsvd cgroup pointer.
> 
> As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
> (non-rsvd) cgroup pointer into the folio's rsvd slot.
> 
> When the folio is later freed, free_huge_folio() unconditionally
> calls both hugetlb_cgroup_uncharge_folio() and
> hugetlb_cgroup_uncharge_folio_rsvd(). The rsvd uncharge reads back
> the wrong cgroup from the folio and decrements a counter that was
> never charged for that cgroup, causing a page_counter underflow:
> 
>   page_counter underflow: -512 nr_pages=512
>   WARNING: mm/page_counter.c:61 at page_counter_cancel
> 
> Fix this by introducing a separate h_cg_rsvd pointer exclusively
> for the rsvd charge path, keeping the rsvd and non-rsvd charges
> fully independent through their charge, commit, and error uncharge
> paths.

Thanks.

> Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")

Merged in 2020!

Could reviewers please give consideration to whether we should backport
this?

> Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

This doesn't seem super-urgent so for now I'll park it in my pile to
revisit after 7.1-rc1.


