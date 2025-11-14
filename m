Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FDDCE7AA4
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA228E0003; Fri, 14 Nov 2025 04:49:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2018E0002; Fri, 14 Nov 2025 04:49:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEA68E0003; Fri, 14 Nov 2025 04:49:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4298E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:49:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F16A5B8085
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:49:54 +0000 (UTC)
X-FDA: 84108741108.08.6771921
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4C6F32000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:49:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lih/M3wg";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763113793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9p6zNQaZofKPXDVbEjLNpyZi7K3pMHGouHv6P32PmOQ=;
	b=IxK2MyrIs9E8pjdEZfSrj93pagzT4516TXbx07VM2buMcEgJVSE52wdWYQPpJmuDkli+e/
	qca3n7Y787GJW/tpqAeGDgJAj/txQdDOGD8PobSBY5pd1BCMAQ40Spc0led9/iOqd/4nKL
	F5ElVpFTh9P1v8ALXUR/pWcQy7Uu6iQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763113793; a=rsa-sha256;
	cv=none;
	b=LSx6mQ1sHhJwo3/K/Ejm4bXQO13BlM/urO5vRwmp4rmJtclJnRLb4NLAIMxkbnuCweuLUd
	st4R9w78qKCjxKC6mFbLVNzAgYIz8iheDioYAZjl5WYWYR54XPIC1Ezo+SCEhsk02bkNM+
	WuxPA4ZJnGqTKCafo+F+yAeZHKj8gqA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="lih/M3wg";
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B3C176016E;
	Fri, 14 Nov 2025 09:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEFDC4CEF5;
	Fri, 14 Nov 2025 09:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763113792;
	bh=3uA3zpQxd5hQBezqb4ncqzRvItd0P/4i4e8EDinYtIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lih/M3wgEkun+8Ov6VUfh8QRRTPJ6iq3V1SkzkEvlhlcxf8RQlaOMprDBOCZdqgDz
	 AxQ9ZhGdMjG6Jdp/t7fmxdmgHU7ZpG8/+xkqR5r9QsR8fdryYcWYA6bqaOBsAdeqNI
	 pAs/X9jdGbwjXJr3BYEkmHCiJA5uM7z+ny4U7b+pZVuvb2uyEMATodTBZNPA0DFGbL
	 pjB6umIxaKWxXCbzRsuW+adKY7dOQaPY70b33BPlF25nbCzZhdOoWUEVhGmnC35rnu
	 N1KBPCNsoeG+xsaM7l0pTjs7XHsisdNUdhCyeIFZkDpJS4N9vAvuzDDqpLsSz7jLT8
	 l/qtSyz4wS2tw==
Message-ID: <2bb9f0c2-a258-4a57-882e-9629f9cc81e6@kernel.org>
Date: Fri, 14 Nov 2025 10:49:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v6 2/2] arm64, tlbflush: don't TLBI broadcast if page
 reused in write fault
To: Huang Ying <ying.huang@linux.alibaba.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251114085403.101552-1-ying.huang@linux.alibaba.com>
 <20251114085403.101552-3-ying.huang@linux.alibaba.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114085403.101552-3-ying.huang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o4wfbwpykansqg1km57xcwdohfu4zs6y
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C6F32000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1763113793-278671
X-HE-Meta: U2FsdGVkX1/A5K7Hx85XGI1aubQe/KKfvkC4IAMLTu6IL9iQOYaElDl28rL/AiI9Ymxh0Jl6vRPOKV/FjAa4nBu66EfuNvrOLK+TSNFMWtxRpz4tZfeOlu7a9v+2Qk66jw4x9OM3GTbSuqqXi013M/UwdgQrY6hbkurw4Jt/qw01tIkpg0qzZkIt3Z4/ED+H/r2h9CflilNeub4vDNHMTMP6EZ55U0vgVYE5nD2TU3/rmaUHzfVRWE+0FZWZfqtxvsHv9Fa0MATrP6Z8dEmU0gw3GlzKOap+IIcSuYmW+vW2jjf7m+9sutZOC9GClUdBMxdvVgD62ss2hv5gxZzzetUqw4o1zHCZAOaOqjTLhYTDl22MjA3iDNLZHaoMe8v2okZ7JPAqvJUPVbrUXsFeQNV4yND2Wx3m3GKIQLpHyh0vGb9b7ZwvTkI3lr2guha2S9FG6pwweRdI7ImxBzniGUtydvXjc3hYHDlGTLe9FUHc/rdC0pOC23ljMIVCIqam5RIdLNT/LQnVTJ5kiLwhLZu1/y5bnR5oR9992up3VwEaP3gwsWNsjlQRCv5pKpESbCNxSfBLzEsV+psZ9nNtQCSLGSbx8vs17N1TK0pi/m00+0pSEMCAdgpvec5dAuMcx85fR77dCV0K1ulionGcEy0wRbUYEkYLmV+kmqxw2KnsJVSWJQClHuR1uKzOwBvh7QJXMf0X3PaM+Hmq+2ALnVbOEcK4YUv3fsSoCOR5LrsCJUrMq9smwaTjCjjcRMjnXC12OXn/wAYGB6f/i7KNR+3AFDUnCujBMdAT4d9dzpLs8QMr0VjP2akXkK9SpckQwPB0w+Cg6ZTdeUJWTIoaM7ZAc8qwlCZwdJ0kcCAi/tQVVegIKYXMGv9JtQp7i/hz370Oju1W7dwjcp8XVBGqODd2x+/QC53KOhpaDY9+mhKhkvKAHIeRqsx9exZ7yyzGPmmCGwWgwtFAwQ5QRyL
 O2Wq9QrM
 lPkyaEge8Pi52uNubOPQx2IEbn5zpZFFWnQphdlOBLDgMsPFsUfCZfpGKD0NRzxDUkGjC0GO2oNeKqmbYiQKzfcQJjELye77KMYLtkBLt+KPEG4I4qt9ZD6bVB2NS8gNRex4VVznbaHNFE/MpzeVcyY28H11jThWPI6Nk5rq6Oao57Uir7m+3HcBb+PtnXL5EVkcGnkg35V9A/LlJeBG9dRrP2e/cNQgFBVyLqthaP6SfiOlRWeF9NZZmpzLJHF6JtE3Fv5WRtmStLBzJOSTRLgaTDRhgWdS67SgHjXVPFydI56sRjh8bxt2LRr11HJ78JfNyOd2gzz6I34vpIHl2WXbxaKRSW3U1sRXyW1THDQnr2XHvSEVDzu/7y6zmhNzdy2uTuipCX0HBc9anM+PwQe7Qbt05F2eS06wS7bjnY4aN/jhC6GyFfqeY8SB7ahd44w4Q2tAJ8J+UZE5fOcCLojcQno6JCZid7waQ206GvRnm/qHay52YLksYK8gzXUUpINpZW0af/Lhwm5sXkOZfUCjqVIZ376aAhEHvIeZp7qY228vhxS5bfgzoTsNotY0PaCBYpuPFw4SPYIPQRDeTzedaLkaiA2id23hoU+p44n22CTyF9Ixj/lu8+gpG9Rgz6wg/LbTcs9Ggb2qo/7dx4lokHhkQwyovhOxBlot36dX0nKznDWRfkHukAlF5x3IiZFbscwr5sCX+5WWAx6cgwuwk8cVfvk2eYcP1gooRQaIDlUQr7SQfhC56IA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 09:54, Huang Ying wrote:
> A multi-thread customer workload with large memory footprint uses
> fork()/exec() to run some external programs every tens seconds.  When
> running the workload on an arm64 server machine, it's observed that
> quite some CPU cycles are spent in the TLB flushing functions.  While
> running the workload on the x86_64 server machine, it's not.  This
> causes the performance on arm64 to be much worse than that on x86_64.
> 
> During the workload running, after fork()/exec() write-protects all
> pages in the parent process, memory writing in the parent process
> will cause a write protection fault.  Then the page fault handler
> will make the PTE/PDE writable if the page can be reused, which is
> almost always true in the workload.  On arm64, to avoid the write
> protection fault on other CPUs, the page fault handler flushes the TLB
> globally with TLBI broadcast after changing the PTE/PDE.  However, this
> isn't always necessary.  Firstly, it's safe to leave some stale
> read-only TLB entries as long as they will be flushed finally.
> Secondly, it's quite possible that the original read-only PTE/PDEs
> aren't cached in remote TLB at all if the memory footprint is large.
> In fact, on x86_64, the page fault handler doesn't flush the remote
> TLB in this situation, which benefits the performance a lot.
> 
> To improve the performance on arm64, make the write protection fault
> handler flush the TLB locally instead of globally via TLBI broadcast
> after making the PTE/PDE writable.  If there are stale read-only TLB
> entries in the remote CPUs, the page fault handler on these CPUs will
> regard the page fault as spurious and flush the stale TLB entries.
> 
> To test the patchset, make the usemem.c from
> vm-scalability (https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git).
> support calling fork()/exec() periodically.  To mimic the behavior of
> the customer workload, run usemem with 4 threads, access 100GB memory,
> and call fork()/exec() every 40 seconds.  Test results show that with
> the patchset the score of usemem improves ~40.6%.  The cycles% of TLB
> flush functions reduces from ~50.5% to ~0.3% in perf profile.
> 
> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Yang Shi <yang@os.amperecomputing.com>
> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---

(no need to resend just for acks/rbs, maintainers can pick that up)

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

