Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F3FCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 12:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4896B0088; Thu, 14 May 2026 08:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685EA6B008A; Thu, 14 May 2026 08:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B306B008C; Thu, 14 May 2026 08:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A9546B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:54:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC3C6140285
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:54:51 +0000 (UTC)
X-FDA: 84766019982.14.D476740
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 56AE912000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 12:54:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekvMJoWt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778763290; a=rsa-sha256;
	cv=none;
	b=jhIoFBu1Kl/hFq8nQDFDk5IjUaeE1y0hEVHgAm2yrYYuIXBNDF4Jl4L7yLi6HWuHZae7wl
	h378kE4z+5KIcoY9rXvK6eQy8MVj9+EaLcaxyL1rLpX/3kzr3aoBdygpXIxMCWYZ0mTD2U
	QIQcik9ooX/F8GjX+vXHQ8m2YT+CQ+U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekvMJoWt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778763290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eocSjzjGEohS9kuAk0mEThWRjeWGoCi0Xrq5+W1FtdY=;
	b=vCNgkk+Eab743DNEV8urGclzs6ZboAMb2PCLoWGjEJgf7W3EzgtHDXGggFlt6jdgRxtXnu
	R0abXzr42GmC4IrzN0ZCoqleK0+YuhC/Oh+Khwt6SOjSlbAXf9y45OnJdmWZfRiEzL2CFH
	n0BjzzRUokYttQgDAS2txvSV7fE4fJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AF32060132;
	Thu, 14 May 2026 12:54:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5E2C2BCB3;
	Thu, 14 May 2026 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778763289;
	bh=EK6fP//EqCnlEnafeuGcNvXM4mmM1lfqv269NQoHluo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ekvMJoWt277faH4jeuTl0fCcIJawazhJlHvYHG+h98rM+cbNY3RUyfpGInoa4DRhf
	 odthu4Y7UvwYafDJhLtkTtBqTvWiESIfskgaihO0YTRi56xlgbLyNpgW5RAw8aK1Oi
	 5UPqlaVU0bSBQ171LH/Da5Ffxrn4b8o2MV2fTNYBFZBtv5RNXQjx4g+auy9BSnKQ2O
	 v6+RCp2NCpxm+hgLtiqp0VAMHDDAfWOpzsI27HdDj/VKXg/IwYOPh1odDKlBfInSmd
	 91KzIu/TqCNGedQJ/qE/UxNUQ//blDB6gKO2QHaWaM2X7rTc3qNFlpQvZkg8qpabzn
	 AZO1DKbX6Ok1g==
Message-ID: <a67c7265-4a67-4454-a146-ed729e08e063@kernel.org>
Date: Thu, 14 May 2026 14:54:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] mm, slab: add an optimistic
 __slab_try_return_freelist()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn,
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20260427-b4-refill-optimistic-return-v2-1-1672467a792d@kernel.org>
 <ilvntlpu67ihrbna6hps62flwtiwrwddljoqg6olos7c3qstz7@gsxg5bhcnwbz>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ilvntlpu67ihrbna6hps62flwtiwrwddljoqg6olos7c3qstz7@gsxg5bhcnwbz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: modr5n7bhfei1zkn7cztwqnnxa9qj7bt
X-Rspam-User: 
X-Rspamd-Queue-Id: 56AE912000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1778763290-409363
X-HE-Meta: U2FsdGVkX1/dYZxq/PCKVO0n34XlYnwF55S0IYaBmE9dp3QQKd+4Twk40lLEkZouo5rlc1fzd/J+TX5XzHbF9aH+d1YHZQGfOOaaQVDdDoD6DPTvSpu+iCP9gdCbnjU0bxdXr1sq2szUXS3k+SzttCvJZh/dPdZA53y3mQFwEpRx4RVpBmcSQtsY9JXCvQ0fL/E0fEM1GTlB9d50wQxZm5EyG/wHVcBecl/0UdyYxJnDcPJf9fKvfWYEMCphVJQSAuC3TKIIoxcFMQyK24IftVas78uktfQNLDgljRQKX83o0NUKfB/nNutdCrIym6UmbeI7eB8DFnvCZ/lf8UICPP+r38wfesbsRL49NQKq+leuOm+nJGh99bSl8CBwR7a4BS+JUv191+bGJrYvsylpYAwTeu1BAYWjfIQemRptJqVYRGNBjVbR/7b5c66Bb8TJIVRpYeNUUWyvvQHmkzFWZkD4lb1Bxk+GrEQXeyuLtPehsNRZyN66jbol2oEs6GLf1D/wd5TAr0ybyKQrH8rUWH47ItoefXNW27TKSy3MI+csWclmVzvzaStStedZzVYcUW1PZmmDNlGB2zIAK+lBY9aF13bgXBA55ki6c+GDxsDlin+6u31iB0Ghhhr6qykFHRbF4QyugwF+M7e5oyU3bSW4H8oaVF06Oydga8AmdGD4NfocIGdr81LSKs33nR7BmWm4DTSpBQTlWzcHUZDFAcbuiLuCHODRzKAiltKUfVdNmca5Prc0EWO0Gg4+J7gLj69d0DiINMhT+lBwp+Gp1hHNpf97kzqhnwci3lY2mOv7arFDh/kslEYBYg0/MPKLNNpCaqsMkSIrMIAx0SEqwWpRlfJJ8wtqDThECCKKKUtKXgh+c1PwZpLwbrq71+OGDfFzVt93tHbx+EflPt8zdFzWaDw3pc+2kijHMAi3I9948C2ExrYnF5LQv+F0ugHRrTOO8v3akLxyUHF/9Rx
 qA2Ql8ib
 7CoWgc1lMnceWVyUk5Lhj1O8RQ2F4pCAEmLFG1zA3cSSAZQ7hEg5gktyBoIrLmRY+ZpI3zNnBlHQB9fmtyEHWwoUF8QRlYMJ1OvwKqWHJt9NiCbLXwbDLXlrOPP//pz4gV6bqlCCVItiS+wwBc4Heg3sZDYJ93A84BUaHrGIxRS6/RLV2bDCeBQQVjAJfS/yn5RxP5/+nc9nlurqW7u0t1q6z3Ax2AWuj2UL9Lo5tinML13M55SKli7+7L58Ejg0pgQzYQxclrMtzcqAEcY8Txyl4qre5dsheXzTBWyDNLOvk1MsIe3DrApwV6MY/xkIRuvmoJ6rY8vAkXdIaNUa4GxyFHcKRSuXfYv3MnyOO3fbm/gA/o25vtz5mM45Xdeqe8ULxxQv5sKh+IeGaFEXTfpae76cI/AEIbtOd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 07:49, Harry Yoo (Oracle) wrote:
> On Mon, Apr 27, 2026 at 11:42:57AM +0200, Vlastimil Babka (SUSE) wrote:
>> When we end up returning extraneous objects during refill to a slab
>> where we just did a get_freelist_nofreeze(), it is likely no other CPU
>> has freed objects to it meanwhile. We can then reattach the remainder of
>> the freelist without having to walk the (potentially cache cold)
>> freelist for finding its tail to connect slab->freelist to it.
>> 
>> Add a __slab_try_return_freelist() function that does that. As suggested
>> by Hao Li, it doesn't need to also return the slab to the partial list,
>> because there's code in __refill_objects_node() that already does that
>> for any slabs where we don't detach the freelist in the first place.
>> 
>> Reviewed-by: Hao Li <hao.li@linux.dev>
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>> Optimizes the current refill leftover handling in a way that should have
>> no downsides, so we have a better baseline for any further changes (e.g.
>> spilling or caching the leftover) that involve some tradeoffs.
>> 
>> Git version here:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/refill-optimistic-return
>> 
>> It's based on slab/for-7.2/perf with "mm/slub: defer freelist
>> construction until after bulk allocation from a new slab".
>> ---
>> Changes in v2:
>> - rebase to slab/for-7.2/perf, drop RFC
>> - simplify to reuse the existing reattaching to partial list (Hao Li)
>> - Add R-b from Hao Li, thanks!
>> - drop the stat items - they serverd to verify the optimistic path was
>>   succeeding, but are too detailed for mainline
>> - Link to v1: https://patch.msgid.link/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks!

> with a few typo fixes below.

Fixed up.


