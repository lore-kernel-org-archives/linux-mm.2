Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3846BC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 293086B008A; Thu, 10 Sep 2026 06:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C746B008C; Thu, 10 Sep 2026 06:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11AFE6B0096; Thu, 10 Sep 2026 06:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D92396B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:09:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FDECA4DCB
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:09:13 +0000 (UTC)
X-FDA: 85197429786.25.A08B9CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8086E100009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:09:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAOxyzNV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034951;
	b=aMNECFNE/2xzZvqYHX3opnD50iGTtEdJILWTN2HRJuJjCNsNtBWA7FXfmTWPFRkIjSJLDf
	Oj0N2/quxA0Hq+OFoBSi95PjZxbbJHPBmMXvIIN82GSc6iVG86rW2T7Q3a+kUQ2II7qmEG
	tgAbo6nED6OnLfC52HiQ9zgaOBaRRyY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BAOxyzNV;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9PGX3cvQTKEp1StomMC/PUuNY3LIk1gdRQb5hd00+M=;
	b=EkBbhsWPHAQwF+me6r2GEftj7BUzWKBeeLqWNhQgf7/+kzQTVNkIfM6ebHemh6xUgBIGTb
	uNWVSUOqWzDxk6NIiWRBRBL1sC/4yp1HaK9AH3B7Qe3p/Dit23KlvvhlNOLMErSp+S7wR1
	OPnq9vpisSv8qOOHpdPD3STSSGNHYnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 973DE413CA;
	Thu, 10 Sep 2026 10:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8C31F000FF;
	Thu, 10 Sep 2026 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034950;
	bh=b9PGX3cvQTKEp1StomMC/PUuNY3LIk1gdRQb5hd00+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BAOxyzNVBmdk0w4Ok8N6GqK+3kwon4WEcnxstz+r/TqzWTPlAHxm+HOGFc01l/A77
	 RQTg3M3ldGn4sB9a9QHOqudnvyDNwWz4Qvp+9FfBqU5zxaRIQTIQ48juQh+1laj8sL
	 w/5VaC34duOFKT4kTvGC9QsZO1IwYZsuFzjo7XJTUUkViDCw4cZgBrjT+HU2g3+oOI
	 IuwbNPTaPc87hlZ24/4dYFFFL+bl+5rg79QkXtq56ZKwhU4YPOIcGG8SLKPpEi5csw
	 HU6JWoPT4olrK0Xm5qRwntLlk5vV6MU9bPsYT5MHC/mlTY9BxWf53tdHfC41G9ngs8
	 xEfpJ+9TdcOhQ==
Message-ID: <a4d74575-65d5-46cf-bd2d-dcabf2543811@kernel.org>
Date: Thu, 10 Sep 2026 12:09:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/5] mm: Make per-VMA locks available universally
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org,
 willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
 jannh@google.com, aliceryhl@google.com, arve@android.com,
 cmllamas@google.com, christian@brauner.io, tkjos@android.com,
 dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
References: <20260831203056.838265-1-surenb@google.com>
 <20260831203056.838265-2-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260831203056.838265-2-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8086E100009
X-Rspam-User: 
X-Stat-Signature: zsxgr7nen7c77shjqisbk15439cu665o
X-HE-Tag: 1789034951-818845
X-HE-Meta: U2FsdGVkX1/FV8gualKNZSYmsXbCE8Hb2Y+yPBIPykPKhhRaWwDUrqpNgCSXM3c3N1juP1cJNYKc+J0f8ufajaYiSkH1GF4siGCcAbt8K8jupf7Sp1wJMQJECEzZ2ciPW12dJiXkkAjq8HkaQ/suUul5It+ulwSJrz0vh+u2r8En2w9f6nBIaoPYjj6NsaNHx9+96II3kewRmabGNPE58Wp/ZmEfVIhLIIsx6LfDF15aFoDsoHvB9cKLy1EvM2hs2buWaHeuiqkmkeqxCFG0TMJuRQ6Vexf7pS2DIOamT6nsi/5rmzXUnojszpxXZNMsmmudE4X0HlD4pyPDJVJazR2ffb9I5hYVRKUBV80zvqpWzSCW+y6pqXKOhqrg4D1L8v8j9PSU8LsFJ/Afnzw/eDLerwBzfDUan2dLQIIRkvIu0Qt1KhyZj0ohN3PK9K2vovaCAtU7I/sL/gEonGVaFtULc5UAE+JUIvxnVdAsBf8Ob8VSElnSzqTB1hSRgQwbsfzWXILc60FpplPGLO7jcuk4ar9MUZgBOSJEYU3A4iwIPumdQlEFMxinAS1F9PUQe2TrZ3g+jYTecJQafmvg54dKCdofhg/u+PPo6SIOkvUkPefrG6uRa0+CMD8zAxZA+BzcGeRL0cii2N7sd3r1B3SVLBokq9SJUpv2anck+X7qK51H3h7Z4OYJizlgqWSxQCjzBUd3NcF/tpyhxiPCIRoHVwN/WBtfv63ybeODkGXMIu9h3uaaJMqo/vkMNqE2MRLiT+qaQ6MTfVexpK/ucr+7giEsEhnfoMGdtaQWVj6bTu8mTFY5qwB4DrWYnZVT7up5578DxZ3O48J8cIKRFXPXOx5jfmpGY+1WZrIjhpEFRqoXcn8+4CDiCzTSzZZxEyk/TZvcEkYtnUpDevR8tfGtakycDljvKrxnb7CYp3v+5I0jlBz/3LqHx60NDVETBhsJoXvS1+fm7mz6Uau
 gMJjPt5e
 oWIGXGojG8X2F1in8LMIxzXXQ3laNRbEXz2q9IvWu+ntYAMkscYceJgNZNMm/4PJZnCcmDJPgSlaovBqgoXV4Fsigxi5nv0yjGOmH+XzAjAjn5Lh4PxUx85opsV9l/Q8RRZSBRI1FfrJKZjoiHrBleFW8+AJrajpKJX8ljNOxA9LpSOzHIUKNQUrSXHpuHKCIBSQzKnvOrW1RyO4oxle+WYjX8FZpRcep5Z2yRmyGgHsV/zi54S4/Jy6w/TbtHAkxZFDLFYmXOQKaFwaf89lLPHqvxHHhEkR5f0aXQIldasCPpgtxxxVhBkjf/uY4lXmjod2u0Dr9uk1h0lota98wTMmQX/GxChcIqMzMfK80AqDo1XEeNE3JH0QDAV0tnZ9L2+tq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 22:30, Suren Baghdasaryan wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
> 
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
> 
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=n configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
> 
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
> 
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=n configs. For now, do the simplest thing: use the
> same implementation everywhere.
> 
> == Considerations for NOMMU config ==

Echoing what I commented on v6 after v7 was already sent (not realizing there
was a v7 after my inbox got flooded)

Maybe the NOMMU "support" could have been had in a separate prep patch (where a
lot of the description below could have been moved), making the patch itself
just mostly a removal of code.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

