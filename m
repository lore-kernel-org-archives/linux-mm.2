Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE3ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FE56B00C1; Wed, 14 Oct 2026 05:43:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648366B00C2; Wed, 14 Oct 2026 05:43:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584CF6B00C3; Wed, 14 Oct 2026 05:43:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 341956B00C1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:43:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4F7B1C3AF6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:43:18 +0000 (UTC)
X-FDA: 85320743676.27.06B3CBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2C51440008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:43:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvHMT19c;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H5SgPo1HKKa1EEOsG2iecS6xN05Y0dz7KAy0sbsqSs8=;
	b=kGL7YqgA8E1wx+TFNNhwbna257xHqZeB8eu57UhXvdCyBOMlZtA9g0hP975QwG3uOEssRq
	zP+TEj/XaNQ0EyEmLUlx5DNC9GwPH/VWqZXnS7HhHHqlFXERyCIyAuCDhtVm7y5tDK7kNi
	XFMw88MtTEl+QSlFUw4OakMaPmkda5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970997;
	b=fNzvVg8mgSnbKXZqcQ4REZ8iTK7Mn+xOxHRptyqJUN0ROlyxsGWT8/d7EsC/AvCuJbzeLj
	0cNZBfKgls4AIlqrDEZop6G8NVZaxXh4r2sASFI/WVEMqsmM/hGmFr2/8YPiunicJlzEGO
	r1Jc6FCAu5pCNngSSjtJ8mX7GSn0vF8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TvHMT19c;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E7BC60214;
	Wed, 14 Oct 2026 09:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E471F008A4;
	Wed, 14 Oct 2026 09:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791970996;
	bh=H5SgPo1HKKa1EEOsG2iecS6xN05Y0dz7KAy0sbsqSs8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TvHMT19cp3VI4WXyMxkIIIl/rLkbwnHjQpC0jxXIXIcVqdL9JKKmVSSbx0r6hV7NC
	 Vrdpvz6qL4kqmdUa6ndhhBm547HYFlNtakrQ3150VOtqtxUgg/At6OYcKjKBZk+DZv
	 vTHNv6FZ8qbfem4AYLoZguZfvTOcrfUV67OCW+gFpCPJKpbB99Tqo/D3vKkSz2WuNh
	 vOWrjJzt4ic8ZI5b/0emBeZqAp8Vv1jjPYP+7Cil/RqS1xO96u9SkfKZBXadyOL6aJ
	 clD/IfYffLkkLB6aXQpFPDbtUq6WSVhV9vCPzmBbfUcRE4h+1LFv2vb8qkbUou6csD
	 GdwrM3es/LR9w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Haolong Wang <18766350203@163.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm/memfd_luo: preserve the sealed exec-bit
 state; reject kernel-private shmem files
In-Reply-To: <20261014035228.473825-1-18766350203@163.com> (Haolong Wang's
	message of "Wed, 14 Oct 2026 11:52:25 +0800")
References: <20261014035228.473825-1-18766350203@163.com>
Date: Wed, 14 Oct 2026 11:43:13 +0200
Message-ID: <2vxzmrsgipn2.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C51440008
X-Rspam-User: 
X-Stat-Signature: 77xpamhk8mbm1zfzho9e6wke6bucwn4f
X-HE-Tag: 1791970996-786752
X-HE-Meta: U2FsdGVkX1+VwgAfKQoD6+oZW12QsuvwU8ASGN3tHMu2en2Cvdn9mqkt0jsQFvWbMqlP8HVMBZbnEKLELTNMGQYp03/fWxv6f42gTEZNPJoC0NqglAhINUjxM7TnfPf68l23xc51oWdFrqsYBpW29ntFcKU0RtcQQih3Gqhru7PRzbOyiwIBhllRm7lwVFiBMk++uCw/J1fOFu3XNYPFalcDGuJTtQBXHyIGAun8jl2cWHdNp+MR6eiMGXvabgN34hY61llt3p3cLMYP6t6k9mBaf3c+9/h+x0yzeSH5GmdHKjxyUuSefil3koxZd7R2hg+2C49ae5w3KxxPvgzxM9aRCUKKq/ipINWQwgSLxJKhnvHFkPZXAIsKvzKKK1dca+hwTOWdvnjIaPdkD/er0YmhnhP8saXRvakHEGJye8jE/9VoL/Cul9NATVjsyUDyJZmvsP862BABUtxDsrXBNJKaP7932YoKBLX85/pDxYdKdj77RKSAPuTb367tD5g+QMmWXRpRZMCW1IMC1RQFoAWbb3SrhiqpRtFK3J6zOVOO4UphLW5wHg7WAS38/k8nYO4JpDEuUJSDZeF3UGbpbg5Gmc/t4ugqwlJTEuVe96goZaGZnZ5zQCpTnP1aB9Rp4eNjPLlbSITbqfBvmM59yBYVtGzfcBpt93dU4+u3gq+kUu2OYXZW6wkZfmJQUbSdFcwKNdNa1yh+mxD4vXe60tvG99qZJ/XqDzBgyq2+SCdA9/hlS3i8o4ntQyGpKpLhKjHaA0UQVc/D53+s4MirBmCZHsvnZRB4lKLo5Acnxq05EUAdLn1ddPOvUT5NI2eh3XwA6Fz4cbkowiCmse/RaEtsCdld+InO6DtBII9rgAhxy0JCM9b/oAcu7o/8cWi+1PYxgAB+9i6GbQxgR/Fj31BYblzsaSO4cSV7agWbnW8FiyDl7NMMiEXaxuS+A/aSmQC+zXeD9QiKwRu/zCV
 GqV1cZPC
 jS/Pjd9SyTjpBj8pKAzNyzGXMew1/sPzac1khzkf+OeCgElpR01IJ/D0GPBL5L7vZQSDGh8Jc7LikVGIyxiS5cpuXBqV4zt/65trPhdH6rIYoVno3fO6wH+DIsK2gxfi/gOy7PmFMSRwEHmtOoTWQwOofn2tGLnC1o8FsAfJ09wlygdM0afLbR2733MHKFAA1DCiyafxmEvclmGXloIu4ve1f3TtCFsBscwIduS0e8YQpUbOgtUhTGFcMIdvNsFZE0I3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I refuse to review this series. It looks entirely LLM generated with no
quality controls at all. LLM generated content is fine, but you can't
just post low quality patches and expect humans to spend time reviewing
them.

The commit messages are unreadable LLM ramblings, the code is all over
the place and makes very little sense, you have made 3 versions in the
same day, your cover letter doesn't even explain your use case and why
you make this change, and so on.

Future postings with similar quality will also be ignored.

Please spend time to understand the kernel development process and spend
_your own_ time understanding your code and polishing it.

[...]

-- 
Regards,
Pratyush Yadav

