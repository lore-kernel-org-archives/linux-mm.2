Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E086D1A632
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4F86B0089; Fri,  9 Jan 2026 09:13:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C976B008A; Fri,  9 Jan 2026 09:13:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E9E6B008C; Fri,  9 Jan 2026 09:13:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE7E6B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:13:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24AC1140862
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:13:17 +0000 (UTC)
X-FDA: 84312617634.16.DAA4989
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 460DE4000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:13:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1AHF+d1;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767967995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xrh/8FPyG5Q0mXalG8m6mWFORCOgBGcMZ4E1hB1Icgc=;
	b=hiKG6RBCJK/b3zYeTFHnZwaCzr4EOlS844axrQ5YKtxjhYtvN0Fvky/t475EOXqHflmCB1
	HNUBnj1aEw6yMthPmCVANRBQkUlsYOcUBrK0BXwO7x/rr17qzpq7C/JsaLqFYCd6zZAF4h
	6HJkBThSVC4COS7WMo5F/njkDe8IjHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767967995; a=rsa-sha256;
	cv=none;
	b=mTv/Wp765OeJZMoPJYhJX2/J5sR8bGv8ZXL2Bpe1vqsFHjytfDNA2ZZbFYjka1tO1dNJKl
	6I/RqA7j21gxXVpVfHqha+iezzCD2yua3u+2Ybn4YZMW85fh9Xwg40ufDOteDONP1k+uM6
	0be4I5/YRuXgBYXoyE5pSWXZSuGHQgs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1AHF+d1;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DB9943853;
	Fri,  9 Jan 2026 14:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8359C4CEF1;
	Fri,  9 Jan 2026 14:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767967994;
	bh=zfTrIma4u2eTRFK2jPd6kgFySsJEA/u5aLMa3tKAV2c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r1AHF+d1hLsa/qRNBXVzWxoX8nfLtX6asrbvdwVLhPc2yU0u1dnhdAnfH+rJQPPSh
	 WB6i9K28hd6WwOEiKSERiESyR6hbSwjR0TgNnonOaasdFuZGy6eSM4Tv6klSdavMGk
	 M5X3psDCH5aqO/uoD0Hf9W7f9tkHj7N31MdpByBdYhcCNmZMWJEnnBrEQsNNRw3JiP
	 1cOMZYTdEeY2kApQxbs5Z874kf/n78tLWpIROCuafDnqIKFGvYv67ATprzishHzrfl
	 RY0vegzRUMy3pFvkjPX65p1gakoT+H+U8+eqvaAZbLsFWBhxAn4rciU42PC8+mKvlw
	 rGENQuxdown3Q==
Message-ID: <4d94363b-5b3b-4401-a9d8-da136d71f8c3@kernel.org>
Date: Fri, 9 Jan 2026 15:13:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 1/2] mm/tlb: skip redundant IPI when TLB flush
 already synchronized
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@intel.com, dave.hansen@linux.intel.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
References: <20260106120303.38124-1-lance.yang@linux.dev>
 <20260106120303.38124-2-lance.yang@linux.dev>
 <da1e8a00-99fe-46d9-b425-c307ea933036@kernel.org>
 <7472056a-3919-429a-845d-c2076496d537@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <7472056a-3919-429a-845d-c2076496d537@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 460DE4000D
X-Rspam-User: 
X-Stat-Signature: jg1axji9gyurky6pk5urn9jxomm9s4kr
X-HE-Tag: 1767967995-847802
X-HE-Meta: U2FsdGVkX1+tIouPraVHGsMR6s7cDOQf19mbDIWQs+P4Vi7l26vhwUw/KhqJvdAcl7rSu1whutKDh7WiOPTqjCiOa/SQEEjM2y+A/02QnixJd5r08cWInsV3WMEMj5G5QTuJ3cBFNfQTtqDL9rQqjt2sgNaz6TUzCuCScMXz9D5839DhAkt6zSM/BIlj6fY8SKi3r8WafdbcC2lhgJ1j+cwPdp57od84CiXKi0hW2hOROU5AT4iqcz38j3rHW3NOttcrVNCTSQaDmEdGNECFlf9Macc2cDiwtHcu7GqFTizSXuUTSiTkrYQtnXhZNksIr0SPHjibU/HI8a2dOXVNKrp4JGqhdOyEMPa1R1BzY0i6EFunP/N9qC5aA1kn2FRhI2Fbm5RJY/9iVm3N2LdOtkRB0cQWMWe/2lmhN7JS/zg2yHX4q6Q291+YsW700T5ctREyKc/HWa/Ky9bwSy+MB8/XtrH6CsY6Ks8VSmOcD/EqlTMP1JsVeEP6OvvLeDTMzvjxN4YQeU6v9ceJ6673LESzU5MNppAv3BveO7qn03nzHWnj0mN5BBuuEV1Jwe7X8y1kOBgO8cvnqjcl6ZLO/1UiTlzlN3yrFj5yZmbTuJaKFlxHzbKmGTgzH+JEgq4WWN0I1hGHCOT5CEprlVHm6gBEQJm5BXVskEfEMY2IFpUZrqhutJaepdOSNUFr0NmmtapGfooQOzDRQ0tPp+wMiu0aTQqfDdrbdrgZdS/lKsqLkvUoEqBo5rD5mOJu8Ge6YJzF1DE+eKVFr0JAY3K8n1LhfwZZZ89GftlwDnxyR+yH36P4I8VaiJCzlmVZ05vHc7HnC/NKxAaVxRnQwkshTnX5RR7l/59WQt9DuGCiqOwLrySBTekk8WDjBG5BsaZWIWECMvpbZrgjCYe2lFQHg8DjvCvRb27hV1nzIu+RdjJ+1uSQ4OITBNNgZaF+tKRmkZLySZweprjecYWnqR3
 VQpSl8uO
 I4SLT8TN4+0Trk3nLxVJmVPCw+tUr58TJGEQ5ZU5fu0SUSLOpNkEywNTtJqBxKiGgOA4D7B+oy3D++88JU5fWtMLCathqV+VL1v/gNKatM09Em8Ci+rWn2R1i5fRwsiCLSXw//KK1HggjWAT8Aj6O7BUEV8egc+wz/wW9TLMVXucz1Z3b4+38L681LNoG6vf1m9N8+9KcXOOCN1WK6tODPmOd/D/YRm+g1h0YT7nD1+lr3+7n6ABQ5CjGqYFw4hMYr9mL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> What could work is tracking "tlb_table_flush_sent_ipi" really when we
>> are flushing the TLB for removed/unshared tables, and maybe resetting
>> it ... I don't know when from the top of my head.
> 
> Not sure what's the best way forward here :(
> 
>>
>> v2 was simpler IMHO.
> 
> The main concern Dave raised was that with PV hypercalls or when
> INVLPGB is available, we can't tell from a static check whether IPIs
> were actually sent.

Why can't we set the boolean at runtime when initializing the pv_ops 
structure, when we are sure that it is allowed?

-- 
Cheers

David

