Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30053E909C7
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936996B008A; Tue, 17 Feb 2026 10:51:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F76E6B008C; Tue, 17 Feb 2026 10:51:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837666B0092; Tue, 17 Feb 2026 10:51:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA566B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:51:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 120A71B3F9C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:51:17 +0000 (UTC)
X-FDA: 84454387794.22.09F0528
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id F29411C000A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:51:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771343475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=111An18P5NPZp2WnP5EsC/86se1pm0vl8ebi8m+L0Is=;
	b=I5xNgvTFcD+JvSQ2oJPQQCuHphqTTNbr81Gojy95WTtxtuTLTs2tLWY/FFOlOxpHnYHvox
	5zyPQ7Q+RjhhH36aH/cN+v6g5MiJA5CEsV9ScceMLJPpKm914/fWfcE5xssqHGAjvMMB3n
	aLlerPTyTGMo7wlOukQ/I8Vu+8jrmik=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771343475; a=rsa-sha256;
	cv=none;
	b=ZzxbPEZblN3rPdwTPa3jDtUc6XBnCX85uGk7SWqVaWNncAOxElLoE1BAFKOZO6bRcrm9Co
	tRYLL1hFQYdoD3eZk8Lyn40QZXxDyOBrZeka2SPfQOY/zXbr938u/i5O81gY/zGjGsAJ0l
	6LmVnnAUdPTXGU7MNVTOi3rMPUa4FRg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 712C61477;
	Tue, 17 Feb 2026 07:51:04 -0800 (PST)
Received: from [10.1.30.186] (XHFQ2J9959.cambridge.arm.com [10.1.30.186])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACF763F632;
	Tue, 17 Feb 2026 07:51:07 -0800 (PST)
Message-ID: <0a772015-f9ea-4c7b-a42f-393a2f591f98@arm.com>
Date: Tue, 17 Feb 2026 15:51:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, catalin.marinas@arm.com,
 will@kernel.org, ardb@kernel.org, hughd@google.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cw4sf5owxe3oskgqe4ex4nd6bqrzbkob
X-Rspam-User: 
X-Rspamd-Queue-Id: F29411C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1771343471-818801
X-HE-Meta: U2FsdGVkX1+CSkp1D787ytJi0s0RtSTlIC7FAvYSusuDu3AqRp24x9sNBBaY2EDIXcDm37frfmUqvgvulzNXZx4SR/SvWU2Xanbk/Q6kCY+zhig2JqDNA47+YYudlM6376ehOMaVu1faE0jhoQfDLpGxGm+cc3QVvV7LgnsDK42rWqoZuNX06WAksNE5kEZZqO1H4tX/+vHj90hv2tTsAOQ+bJ9O1PiuDzLCVeiL+K/tgAEHRISa33MxH1P2WPnBIuMChhpNixWQr/cUzBK6KtERyKGNkv7o+3+6vb45SJW2E+9rYbIwTKBCRC1zzrm9+3weTwfze2jUE0gCA4oRfgCxyQ1Wi4cpn41JRuN1AGk61wb0uQ3of/16tQpJFVbR9MX/ngjRIeIoOyjyEcINL5sXaEbFDlyg58gvMd9tuj7NtMc8r4MqDjjOTTekyw4hraMQWvHsXbBv2cjJlcREaL6/kfPhCMVBSUefW62EQ14qJpEDvAg9nyl7nNwhQBNcv4HubNxcybI+h47JLJn8OSHr+rfGAg7T9TY1e6qMumo0Ngx5GuEq0nrqp+IOr3Zb71rR5lXbRuPkTw8oKwpGE+CI/xvEIq2o3ahznOKlNk5NnBY2DixxNEEtThUVxlorIOjdivgCTLuCuENgremoQJNyVXL43k9M4CCl/l2B+96vFqaQcYYF2PY/+3kaYaj6cdE7Cezybnr3fG4hA1ZNEnZ3trhqX/cC07zHPE53IOQNdyT7UyQoo1N+99SvWcInBALRvNvz+EwAQZ8qffXptn+lniPNs2oANuVsNHu3eRH/dOZKVaPYvIyCsLaJPXyqU4fI9ePExOv/C+V6gXt05ErocJDkzQao/toNZgGgyPfG/HM9EeXHakATbKJ1caDHx6h2xYiTHOzMm+LIGUAF+bU8VmovxCzZ/S+CIQXj/c6NyIk1OYVpVTBLG8RbdCINzfENXMsVhFdByLiDQe0
 FNirItcF
 phbXmuxtx5uZa4Hqr4x+S8VXyJJ40gPqPkP8nfMV37twbWW9T5+8lSiG8pzV/BOHhU7y9dcZc7PfkXBMKQWLqPVESvfLJeCFccvnqhbzbzXNLCmbAmV5/E8WbCVttOfKb/rz353G8lFQ+CuQj8NzXm3xPBUDj03/JfnCGJQTy2tWOGRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/02/2026 15:30, David Hildenbrand (Arm) wrote:
> On 2/17/26 16:22, Matthew Wilcox wrote:
>> On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
>>> 2. Generic Linux MM enlightenment
>>> ---------------------------------
>>> We enlighten the Linux MM code to always hand out memory in the granularity
>>
>> Please don't use the term "enlighten".  Tht's used to describe something
>> something or other with hypervisors.  Come up with a new term or use one
>> that already exists.
>>
>>> File memory
>>> -----------
>>> For a growing list of compliant file systems, large folios can already be
>>> stored in the page cache. There is even a mechanism, introduced to support
>>> filesystems with block sizes larger than the system page size, to set a
>>> hard-minimum size for folios on a per-address-space basis. This mechanism
>>> will be reused and extended to service the per-process page size requirements.
>>>
>>> One key reason that the 64K kernel currently consumes considerably more memory
>>> than the 4K kernel is that Linux systems often have lots of small
>>> configuration files which each require a page in the page cache. But these
>>> small files are (likely) only used by certain processes. So, we prefer to
>>> continue to cache those using a 4K page.
>>> Therefore, if a process with a larger page size maps a file whose pagecache
>>> contains smaller folios, we drop them and re-read the range with a folio
>>> order at least that of the process order.
>>
>> That's going to be messy.  I don't have a good idea for solving this
>> problem, but the page cache really isn't set up to change minimum folio
>> order while the inode is in use.

Dev has a prototype up and running, but based on your comments, I'm guessing
there is some horrible race that hasn't hit yet. Would be good to debug the gap
in understanding at some point!

> 
> In a private conversation I also raised that some situations might make it
> impossible/hard to drop+re-read.
> 
> One example I cam up with if a folio is simply long-term R/O pinned. But I am
> also not quite sure how mlock might interfere here.
> 
> So yes, I think the page cache is likely the one of the most problematic/messy
> thing to handle.
> 

I guess we could side step the problem for now, by initially requiring that the
minimum folio size always be the maximum supported process page size. That would
allow us to get something up and running at least. But then we lose the memory
saving benefits.

Of course, I'm conveniently ignoring that not all filesystems support large
folios, but perhaps we could do a generic fallback adapter with a bounce buffer
for that case?


