Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E65C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C58A6B00A6; Wed,  1 Jul 2026 11:27:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176366B00AD; Wed,  1 Jul 2026 11:27:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0678B6B00AF; Wed,  1 Jul 2026 11:27:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD3B46B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:27:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B30B1403B9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:27:26 +0000 (UTC)
X-FDA: 84940586892.08.390955E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 837C74000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:27:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKKi0Pjh;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782919644;
	b=iZEw5p7cTdRaVH3zXQEdOCcKL1NLeRt/K+OmzHsLlNsJ9FjNtK2ZZKPY/GQi+ou6tILfG/
	AF3EsWhbFJ8Xj4y2T1EZCp9zVkDb547+nGS4pDmX8NMBpfoercqoUUOicSsVYABhD63jSB
	gh9PZNiV7i9+0Sn82oAgiFsEK+HL4V0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782919644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDPki3aSQKwtM32F6/ODm6VehYF+zL7sFr5GC+qEOok=;
	b=bUZHo88zf4NJTxYjHsECIBAa821nHUepOP3KJ89Xfh167BrO8cZqaS5Or7JJBdZVzKMtpu
	ddcJ8L9ZyBYSc4W3LqLkvpDn4MS1V7f3XjCt1utJxDbBk/oeq5guqmXLOMjXHur+aMeEbe
	C+PCvsOXdULB7DXD74mECzaeNuWX/1Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YKKi0Pjh;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76CC542AD0;
	Wed,  1 Jul 2026 15:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1041F00A3E;
	Wed,  1 Jul 2026 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782919643;
	bh=wDPki3aSQKwtM32F6/ODm6VehYF+zL7sFr5GC+qEOok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YKKi0PjhG524FOlcnZSSXXmkfcT7tcUu2/JsSJbF8zV6fzvVZP/eFT7Ogyjgx8oUp
	 GEAfscTvc63KGQOWjB1Hr+2y/ZsNVxYcH8UC753C91wjjnm/x2FrLcWLeQGpM/5r17
	 Zi0mP/7BQi0EXk+b7WxWlKV4L2W+EkDT8IZj3+lBAFuJg0Qb+ndFndZsKd8em+9RmA
	 MORHEnL/ptOeYSnUKu6dBO730fTDEzk5NUHoKfOyfOxzGeUiTHWh28aDxxAAqh43EN
	 aAAtDzrCFG/o9qsUqHkWlWDWBvBqotNVXEtxbLfVUoaYTLm9IGyCFgDU6EOeApKLEy
	 2lI3focxEhLGg==
Message-ID: <f7fc1fda-ad40-4a2a-bf93-28d3eaa9ba7f@kernel.org>
Date: Wed, 1 Jul 2026 17:27:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ksm: document side-channel security considerations
To: Lukas Gerlach <lukas.gerlach@cispa.de>, akpm@linux-foundation.org,
 corbet@lwn.net, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, skhan@linuxfoundation.org,
 Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
 Tristan Hornetz <tristan.hornetz@cispa.de>,
 Michael Schwarz <michael.schwarz@cispa.de>, Shukai Ni <shukai.ni@kuleuven.be>
References: <f75d286c-4d9e-4b64-8a9e-03e1afcb509f@kernel.org>
 <20260701123430.20699-1-lukas.gerlach@cispa.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260701123430.20699-1-lukas.gerlach@cispa.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zwai5g93nwywjdou1k14ktokkfr4jhrb
X-Rspam-User: 
X-Rspamd-Queue-Id: 837C74000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1782919644-488063
X-HE-Meta: U2FsdGVkX18Ktbf/r3Tl8jWaYEFastpmH80TzFRderuUiafbmUFosRlNRI8e1/32HICrk92p1l3/XgibK+xgL1K3k+G/XhgW9GWzzoqsGj4HR0uq5g+gh5WeT3mYc7TXJuN7flpJZJ4f4nLR42iiK9Kc7S77Qd6agablvNVkFU8c/N9kL9tId6beCVdv/C1riFcoBpJUXvSvt2lbLdhNx2wevduJYVwQC7eKbCdPy1AwAwcx/f3QL8QiT3wO8ic1iKDIKOfoLSvDPPapGBOwWhVjXANypl9KFY6+tWCANgkFnnNY478juiEzMvohuG58yN3z7Swa5fxtEglKB9ikW/Mk5/Kec1h4BArsugAHR/028AOviqU96DYFN4/VbLaINmW0+y14bYzg8gQ9FawPx5gJOKCqcX8sfpVs3hxZiMtMX0dX7wetkT2lj+RufxDWMYdM6IdfdiZHzFaJlHlfFTUWiN6MLur68B1sLPDsd8P6fUgKCA0JiksiEvPC1YY3yVI4JI/ykhsx5o76uiYRCV9UNtkeRZ+dsYWT4Fo9S2NNuk/aPfvzc0FsPQODyKLHqDg0VdcpIFiBAWmTJqTcbC7/4KL8dduG0YhF3hFx+mPQ2USToXZPfW1dhw6hz+BXEvi+hEPD5q4tFLWrYrVoReFzr+K1aKnVRjFaYO1c23Y5qsb2U+/z8PwMC7oyiJ8Dy/tfz30mIvOAMfJidX6u9wE+ies8eWX6IiWIoSqVgAiVVIl7QEdbMZxDI+rY+5uiw1pgfgE4Ps99eyIcugqHUvw0OsxPkmEOj+fBbtPxojTKT6xiAf+jlRODb/dlsfIj75Pj2gs1WzqMyW5nN9S1rlFAnF19RJ/zZSgjw69a+ZUU+ZIVUu8dR2PJJVxB/LYchXEfQuPnGCSss5atNIU/UT4vYFkxSjiRws7PR3IoEfikrLE8vvrfY6gstYY3xHcwW/DXagPkEXpNkONPq7j
 uywEMgJ3
 +tgxVLwrvOY+rHhg3FZOdj77DnDSPWifhE4mz49Q+8W02xx7WpYwaRbiSrZPv0JM1reuq32ksWmGB7n6JJZwP/tIPYdsgr9tat31KOmUqJdjTf8DIc1BHwKZOvlyqVDcLykyBfdZ1lW1anWPVp1rnwtsknfBT77gA5yrnMxmoOkybH0QwxWKI1JYCe2NB/IEZZ9nTBU71J8ZlmRVBVSdtoPZ7rQdJoP8rup4/dEwl2jDSwHcxnLxvCTsyI3cw1C+t24mlTWv6S2iEz18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 14:34, Lukas Gerlach wrote:
> KSM is known to enable side channels, but the admin guide does not
> currently spell out the security implications of enabling page merging.
> Because KSM merges pages by content across all processes with mergeable
> memory, it forms a side channel that can be used to infer the contents
> of that memory across security domains, regardless of the user,
> container, or virtual machine the pages belong to.
> 
> Add a "Security considerations" section making this explicit, so that
> operators can make an informed decision: KSM should only be enabled for
> mutually trusting workloads, and any memory marked mergeable should be
> assumed readable by every other process using KSM.
> 
> Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
> Cc: Tristan Hornetz <tristan.hornetz@cispa.de>
> Cc: Michael Schwarz <michael.schwarz@cispa.de>
> Cc: Shukai Ni <shukai.ni@kuleuven.be>
> ---
> Hi David,
> 
> Thanks for the quick response.
> 
> I generally agree. The issue I see is that the current documentation
> understates the risk. The RHEL documentation ("could be potentially
> used to leak information across guests") does not read like enabling
> KSM is an arbitrary read across VMs, which the side channel we
> disclosed (in contrast to previous works) is. So the documentation
> should really state that KSM is only an option for mutually trusted
> workloads. A clean model for this would be to assume that memory
> marked as mergeable is readable by everyone else using KSM.

Right.

> 
> Patch below to clarify this in the admin guide. We would, in the
> future, publish a paper on this to further raise awareness of the
> risks involved with KSM.
> 
> Greetings,
> Lukas
> 
>  Documentation/admin-guide/mm/ksm.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..cbd5f2fdcfcb 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -27,6 +27,23 @@ KSM's merged pages were originally locked into kernel memory, but can now
>  be swapped out just like other user pages (but sharing is broken when they
>  are swapped back in: ksmd must rediscover their identity and merge again).
> 
> +Security considerations
> +=======================
> +
> +Because KSM merges pages based on their content, across all processes
> +with mergeable memory regardless of which user, container, or virtual
> +machine they belong to, it exposes a side channel that can be used to
> +infer the contents of mergeable memory across security domains.  Users
> +should assume that any memory marked mergeable is readable by every
> +other process using KSM.

Should we say here "... is effectively readable through side channels by every
... " ?

> +
> +KSM should therefore only be enabled for mutually trusted workloads, or
> +where the merged data is not sensitive; in particular, merging pages
> +across mutually untrusted virtual machines or tenants is not secure.
> +KSM is disabled by default (``run`` is 0).  Applications and VMMs that
> +use ``MADV_MERGEABLE`` should limit it to regions that do not hold

Also good to mention here besides MADV_MERGABLE also "PR_SET_MEMORY_MERGE=1"

I remember that KSM can also be used by user space to break the Linux kernel
layout randomization. IIRC, the attack vector was Linux running inside a KSM VM,
and user space inside the VM wanting to break Linux' layout randomization.

Is that sufficiently covered by your text?

-- 
Cheers,

David

