Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C65F9D0C9
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 11:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24846B0088; Tue, 14 Apr 2026 07:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86FE6B008A; Tue, 14 Apr 2026 07:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27DF6B0092; Tue, 14 Apr 2026 07:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5A06B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:53:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 329D4B9C09
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:53:20 +0000 (UTC)
X-FDA: 84657000960.17.C598C6D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6456D4000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 11:53:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mdp3GqyO;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776167598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGxGeXMPessPve6hMUk6clxFgaOpuXVXmxatiNa4cLc=;
	b=kFiEibtyttQhfmnMbBpBJjBKeLyAjEsgl0rtpL8Mn/wYXEMIe/41bZowCPr85X9PB2rG/Q
	+nFx5hVVlvqXBL/t+XiJcxfsvhW4HnMPze4WMRctxQHW+QH2JVfKeEHK+PRHA3fh/6ob1/
	TGlcEkVmQTiHmLMpV6DzQJIjm95deQY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Mdp3GqyO;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776167598; a=rsa-sha256;
	cv=none;
	b=t5xj0CF2qS14l9WeSPPYv+HM7vR/j7fyUaat3paa9MaGC4BlYx11hNYxHVVT5rMYxAj/kq
	7iU2+a7Sy/vf3WQtXwDVSH0dL/TT8FUcnZiw0eE5eBOv9llttJJFjgaL60angYbQ12eMpO
	ROLyJ4ZWV+KPGJ6cuj17rnVIlNu65ds=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8A0A4ECA;
	Tue, 14 Apr 2026 04:53:11 -0700 (PDT)
Received: from [10.164.148.48] (MacBook-Pro.blr.arm.com [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A2F2D3F7B4;
	Tue, 14 Apr 2026 04:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776167597; bh=bOWJvnb+WlBXVvkWaUAUBioPsi6PAKoSEmTmEDuBu6Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mdp3GqyOMVjYlN0r28tMkDTgkwOFuC9SrcWUedotlxK3zLLM03/skZBkZdiQojFeN
	 dSrREtJUafgYqbCT/Go2OER5USAVJLBHaFRmekq7tT1j2W3xLrH/dreSqGRNr2jtOv
	 0C2TRa8vcymaJM3PMCgAGgrLcqKIPBVusR5D+TWk=
Message-ID: <806952ab-8461-41eb-b7c7-7c8be56bd7c9@arm.com>
Date: Tue, 14 Apr 2026 17:23:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260410143031.148173-1-dev.jain@arm.com>
 <5297e0da-d8ec-49df-9b32-0d9f907588d6@kernel.org>
 <8b5544eb-5ec0-4c85-a2da-7a454fa606dc@arm.com>
 <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <134c372e-5c9e-493d-b954-d9954546beaf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6456D4000C
X-Stat-Signature: rhqyjix7jh9rryhzn9amqjsywaunazaj
X-Rspamd-Server: rspam06
X-HE-Tag: 1776167598-211617
X-HE-Meta: U2FsdGVkX1/JhPTg2O1UuLtRPSn9pQkGMd2qd7uHr7fBki32FhE/1C4TkmKWJscm+/Ct1Z2loQ1CeU8iw6y+B2b0H60+UhXaIBBh7vr01hUu/mpXcZuGrMEtNNGYT7SUVQL85TV37TJ6kPG59FcWLZpaBicA8Mk8In/UNqXQNxEMK93jqk530u4lQhSaMgNn79UJKRoGb2QlEU5fIfThd+1Ddc8OIQsMfOA/GQrUBo5f5yYpmizo6bed+MXJ0P0m99693sXS+Nx+62Hm2T0hE+zp0lX1zbQvmcl+pVluKVDFPYVNbSwK3BHNl0R7uNoU5sLCvhORVLd2Y+2h5RkzN/fUuFYVmRU0LaCT6yaZcbifwkGJV0zmbedlTRAjktxKCjpDTRg5SJNkOF6m0CvsbMkWJXJ9WUYkDjsBN2E43R9sJePGnswG+lPp3Kpv0DwY70WCXtNPN0BKmLs12aZqogByol19C59IIZik58b2Ua0WJMQDy2BTDgVV438Qc9LdlJOJ7YhDMg/5xrM7AZEqz9TxcVq7BTEyam5SvK3O82eET6DXMZzrGxwR/Bn6xdgt9MhgJaolbf7LFyOdkNHvMW7n9s8IrUQvMlClcNce7Hy++lBVehTTTWBC7ykwhkH/QQlnDH/nqprYdyQI0Li3BZuW3thf46NyVPJR+Ps/oZAyNlDeGadSgyZQbwf4w64YuNqHdnH6X+CeTtHKWks41S33udM2MLHSL54cQcSHLwVmDWR7F3rJQJMGu2uC6wFCiTrj+/03kOwKPxR+3qCK+gtcU0lMuLmFg6j6qtQvKSID7sAjkVQ0ieO/rtYbJoCtFpaAX7Cx89v+tbmdcgn7PRwzaGI5EcGsFPJ02tJq8jaqrUOEuvCy3wS7dFMRiu01Vr+VXxyWv+x4zTV2OBPy5zgBIggt3F8ZHIy0ZOVdNpKb6opkYPuqzhEkCr5WJCd/mgcfw5TbyhnG3DHWSoQ
 nsC+HWzD
 SborLgoi2vR9nR/ayay6aVFHweBt30au26ddCbivwNT5oBnlHgFiwqDbK9huucKXNLeMJNgKed/pbNhiSuZynKe0WVrmRhivNCtrVs9i5xGw132S2AiMEnAXqrOD7krem2Lsbt0jNkhk7wPRHQVGROlGXSoCmKWVf8YDFAxHKnoGZtDuKI+C/pzKejoWHOV3oaVa6lxx9MwLONjcwQnrnkhksRchbo9/OhUPzikyIMODLqgSJbxSSHBjX5aw7tMLXY4BmvITVigSKrpM+JwVpIMniVx5XxMut0MyK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> 
> I would suggest to rewrite/simplify/clarify the patch description, not
> talking about "buggy" etc, focusing on the simplification.
> 
> "
> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> mremap tests") validated remapped contents byte-by-byte and printed a
> mismatch index in case the bytes streams didn't match. That was rather
> inefficient, especially also if the test passed.
> 
> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> execution time from minutes to seconds using chunkwise memcmp") used
> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
> the problematic index only if it discovered a problem.
> 
> However, the implementation is overly complicated (e.g., get_sqrt() is
> currently not optimal) and we don't really have to report the exact
> index: whoever debugs the failing test can figure that out.
> 
> Let's simplify by just comparing both byte streams with memcmp() and not
> detecting the exact failed index.

Thanks, I'll use this!

> "
> 
> 


