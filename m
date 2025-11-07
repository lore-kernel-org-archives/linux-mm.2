Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C1ACCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 08:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268FD8E0005; Fri,  7 Nov 2025 03:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A418E0002; Fri,  7 Nov 2025 03:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FCD8E0005; Fri,  7 Nov 2025 03:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 018E68E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 03:48:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A584A1A03B8
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:48:02 +0000 (UTC)
X-FDA: 84083183604.14.F9EC040
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0FB42100006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 08:48:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7FeyFDt;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762505281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/c4h3ES3w9kbEqEUIy3YPwulsoIPMocMG0kM07Y5MCI=;
	b=mCh2A6ZuLo7KAO/MwfBF/7S9m/KXQa/5E7exBQ1sheFmL0aNJrEs9naVlKKfAXBNzw5SDq
	nawdxfQRngU/lOo8OWkUQj2TeUy3RhtZ3I6gvSkS1ev8yGejxNlgX/Y8cbPd8cGPbFkG1g
	oTOVjf2WixQy7rtQ9C09vGJplN573gQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M7FeyFDt;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762505281; a=rsa-sha256;
	cv=none;
	b=UE9ohj6w6/GPDByCtmMt1TVF8HIO1RQxvB24ABzPJ29yPlw1tf/DYzzkwLva0Um6jCG5Xh
	eGCLI6+nSAiSesiQ+mitzpAcwfAoB5DVWA1DNvPb5/W9yGFEnf6QVYASX4HeUEdDf9LSPb
	KBAwLx/JceVHszqmaulARKvtSCHvQmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49B996013B;
	Fri,  7 Nov 2025 08:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18698C19422;
	Fri,  7 Nov 2025 08:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762505280;
	bh=r5HfqcJlbIcSqDVbrM4DbrQWFQDT9pFIOpMky7mOVII=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M7FeyFDtOYIKxkl3DFN8eMztM7r6/7ToOwzInZaWT6sjSOxLE6B9YWMpy9twj/P30
	 JrB79AsLVo1z52Xf/PKrfZuIFChuXSA1Lops5gNQg/mc4nMC70/htUOHfElaawAlsr
	 vMM0FX/l21ZJC65nhws7EJrWz8Mxph/4Five8Q15l+kqD0MoXOTmh6FRy51G6B/lJP
	 pmpKYaUHC3u6YNW6jbgZ9MTCJ8xnIZTN4iSzHGm6FnW3ke2oH3McgqhFge6pjEnuFU
	 Q9uPo7mrCh47AfX4xFZ+whyNrsuQP8TmS7NCqkXyH5vg+0KopWFi6DLCOpwdcgnwUl
	 y3bG78yWb4Mwg==
Message-ID: <d5806728-1f40-4e6d-b832-0076de3ae699@kernel.org>
Date: Fri, 7 Nov 2025 09:47:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/7] mm: introduce clear_pages() and clear_user_pages()
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-3-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251027202109.678022-3-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0FB42100006
X-Stat-Signature: rbdwybmym3rj5636g76thu83thpfej17
X-Rspam-User: 
X-HE-Tag: 1762505280-228744
X-HE-Meta: U2FsdGVkX196/HyI/3aX4rTPdqhZshuiNQGhLCZ+VXsa5fwk0IFDvhtZQGcoM6XXB0tjDapV04aZWjgO9vE29thZJ4tJrbHqqK61YR1W6FBs3UpQtXEzBtFiOQgFevckbex4WpefG+vgPx4v438BN3H14PAC2wtorVFxYMMqzgigsJ0VH3UM4/ARq5M2D3EXcxZx8YA4oXe5qp3uTQJOES2lOl8y3eXTHD0L73QmQrvT7T1CE2elOZ4k3AV2KcRRe8AXnVaI1rjr0hTqTuZ0hzR2qDXynDV+b7yfO8oL65pxHPF8GQgo6ib9m3UEH/B2n7Yd65MBW16Q7aI4YzGatlskVh/ybQKnO+9UoaeUYXXCg0t3p5PXfk86mqmmJ0+hr5tJnh2MXCl+qJomaJ7MMGYrQ+jEBssAEaSZ5XXtaQpTkE5s6m+/uKKe6tj2CrD237IH5D4GjEAG+eWQc7ImEhERx1pS9UzfooCC4oxd1qKtzVs9NxHV3tbQghqwbmZFk5M5+KdkwnjwB1MIv+8CJcXPRdcx33z1ZBSlZo8nJtCoeLH04S5j0ogpOflsn6l3albkGpQU5qsCGBzSx74ppNTmgmoRcMX5uMKtoAsSnY6Fah9JQkbGjOM8b9DIFWv2D1l6dgeRn80JCyq/i8kVXVvu9Db/oJc+ocuTUGa0+/BrSTTWi50p5yomI3+qpM0xaTfyITxLjC2YpJyFufj/SwOth1mUJpaVRwFOVsZ1TPLrNthyGzGxUtLQJMWIXOhyyb10yc+Ts7ij/YZvMIv2GbVw0QC1dDy5PQkq53UPHJDfq7+6LlUqr4Ng8Xg4vTBg32H4fOcRVK9wLbcCr9LxQXLo7CeuPcYyrO18ZsHek/pm7d2v/y4a3UnQsw2oAjS/PW2ZazrAI2UMiv+49YdCShv/DFiozO31ufA2/trl1poreMkieNRvgtaocOAACvW5Yof0ZBQb8CEO7l6dzvH
 VwFapwgx
 ZjbtVcdR89g3ABkHQ/ADPPKM4CiFK7wssf03RoiL408nohzjE2WX9CnndN7XjU5c2i9PoLehE+Q34X9qd7RLunkTfWtHsZCekCafOROq0aN0KCiMQsKUZLhPSdMfs8jKxBsuHjetN7wgfw03/vyNtwP7vq7xxX7BHCMu+GrccHxr3bXsjA1dO82PPR34YuDF97hho6j57LxDchuisOt2iyg38dIFzNn0zZR8btCwCRZuxHqMOf+BkpRD0ulHITghkSK/HTnDzEvBbsJK73/ocXPEt6ido2gKuitjsshKge//xKgCAj/Ge1hnmNXzi7wFDylzPd4OExkKWN2RWHmHMhTAsuDLdtVieAJtX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 21:21, Ankur Arora wrote:
> Introduce clear_pages(), to be overridden by architectures that
> support more efficient clearing of consecutive pages.
> 
> Also introduce clear_user_pages(), however, we will not expect
> this function to be overridden anytime soon.
> 
> We have to place the clear_user_pages() variant that uses
> clear_user_page() into mm/util.c for now to work around
> macro magic on sparc and m68k.
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

