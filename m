Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 024A5EE2089
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596016B0088; Fri,  6 Feb 2026 05:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543176B0089; Fri,  6 Feb 2026 05:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4450C6B0092; Fri,  6 Feb 2026 05:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 348976B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:46:48 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0333613BB4F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:46:47 +0000 (UTC)
X-FDA: 84413703696.05.1B2F0DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E579C000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:46:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DwwqXPk+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374806; a=rsa-sha256;
	cv=none;
	b=EVXoYa+Rowh2xLFUsyqCvWfkSRFsaVaVR+lSZjDUTswNR1DePDsZ3pkM/OY4rqajwW+mbg
	xbB9Mt64/7/6Jpf+vEtPGyCQ9ZpA4rm8mQKjVgENsuHsfptXAdamk+GHbrSUet+qqgHqJr
	RO/rXyNPP0JU3S8ji63DfSGu0tZXmFw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DwwqXPk+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cArcO8doHePVNVOuHnDWRT93Ld2F55OEAnBp5AcHusY=;
	b=OeDjiromXxa+p1uCgTy2G9bz7gA3bG1p0V6fNfzlTM+Nm6lGhOPaNa0ABU212XkSSaswa8
	M2A7fbkqDDIS2vfXHLNMUwCjgE504GHDwB9b9crDNGKmqhwzbJYiiS92SM1mECAoGCi5H3
	q38xT72IoIGEZqG/Grvb9oHlSK/ZinE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB65560010;
	Fri,  6 Feb 2026 10:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C11C19422;
	Fri,  6 Feb 2026 10:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770374805;
	bh=PHMU2xpIBrdrA0pF+qsCVfYhTTFK5H/MMPeHTteF43Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DwwqXPk+Csnrpw30BYx+2nsLWv0boIzO7iMdbCNNpRZLSG/N0sDO9H2tjtg985UyN
	 /hPmZZo/7w/om+ounqcCGH6rsEdKq9hyK+bIJunB0jOxRKifa2UBsxQfGi2HSIP1oK
	 Hvlb+G0+6bdfoFCP3AmZ9/LZjd3Ge/vmQtIqiGsOuufhq3xVahaBSdp6ueIzzTClDm
	 xMn0eUF4xpnlpPbEaBkFgOuKGNzx5ggRgenGjZAnf5v5jFK512mPPOfaMmnSi6fs2O
	 Lf2Bq0C04Let6Og4BmjjltyWrZEkpWDepf0JLHZnrfzM7cLdXQMBpL8InnORyvKsbo
	 2DYZWGKzMzY9Q==
Message-ID: <ef853093-3007-49d9-aff2-fa39fef2b9b3@kernel.org>
Date: Fri, 6 Feb 2026 11:46:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ksm: Initialize the addr only once in
 rmap_walk_ksm
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, hughd@google.com, wang.yaxin@zte.com.cn,
 yang.yang29@zte.com.cn, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260206175745201sbMJ9Ru8QZsjAo7YMopKS@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206175745201sbMJ9Ru8QZsjAo7YMopKS@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E579C000A
X-Stat-Signature: r75iw1wo37a1yxuufh55jr8fke7o1k81
X-HE-Tag: 1770374806-527047
X-HE-Meta: U2FsdGVkX1/nldafKBa2PLfdBOZw+u80jwCx7V/OqMP9OkvlSqhQTCeKZ9WxZtg0/1lJPMuFwKbw8yFYwY8BLKYT34r6w2RjucHVmrV+9rvPGnirSv8Szwb2VwC7ylwgas6bwF+GMT1PWJvf78pJ9miEc50RBedw7j2NGiShbZqd41QQKiCdl9ULqTlvVTlXJFEkzOTzBzoonR8Wffgo9c12Jtdf9gJ2hA+2Q3MdYsW6Nge3i0wOHI/d4aGeKhZAoJdEuOQtF7N7Jg3wzGkX7LxJmmhKsGx8HJ0x9ufZzKHAGYRFhNyQzHlc9nZepD79/mJxZpqGLcV2n+PjtR2g/VHeyArybrnfmXt48bWU+5GGKvF18Ks7emRilOM8fJDeNuOvBRXROzuVBhmxn/XTsEcqTEVg4TqnpW2+s4iZQNzdp4iH5zWsRMJs0z4rEElLZyRvTLFbEAlMTA2dslGCNe/izpj/kE59uiHERTKQjtaDFbiRQONGjcoldnLERRHdaRmje0wce2etTK4dOZE4h+uAAdp7KcByfrsWJUA3wASZK739QCorePFBt9amL+QMjTUNeYRQ9jM9IgxfUgwhHRjTa3n+7sJR1D1ZnYzW6ZWSBdrbVQkPRUUYGMojMxuOJ6t5lF7wvlU6McJeP1vn07CTLd5PEoCPyuGyxwbWV6HC5gvULBMEAVDbQruox3QE/8L1r5CysPvqTrURdA6iJ6VpGb25sVQvfANvERzmudWkvN6DZQfp+5BLx3XPGoTAcS8W4/NPmLUiOquuLp08EQANyXIYG9LJ762I0wnjYPQTHNRsyIuBuS66z7NaISu2YT3CJxirkbkSJYsza+pqlxMJBBHZ3hJjCwpBolkd+pStFzyutQIQEfpXCnFQNuyJV3ONvLN/VL9Xjtk5eij1BlhVo2SWsHoBhPuh3VqhikdZbLnp698FcL1BJF/slI9KBkF0TUyGGrX0AI9m8EQ
 iq/VJ6nJ
 WTT5qa3VfIEnclDcloUmy/aagRGtr7c2z5MW/9iVzHgPlUEpg3RahXejKFQX1U6Ompxjwx7ROyzCjwlUQa8yj1ol9lJTM/0/SjCwU5qSLRnS1dqlM7qKgZ3fOc0ORHcBVTvQCrrM8Ofgr9tA+bLq8F1MP8Gv7Iau/dalk/PquV+Pj2jicrGMJ230+7ArjsuQJnV8l6wW7arye41gcf3F1Y4Zly2ZUjmR935kSyguLq6PINgBqkTV5tqY7EIjeHxGMDdsAWxr6mHVpzP50BX3UB26Ya/tTdopBthMlaLj0MGMEuPoj3xMBqTa3OFCgcL2Zi78fZgDJZt2bD7ZeHyjYXpWqqdDOCqESuCe2V59a2kwDPbzLiiYix7wkmzB8Fad1dNWauXkonBZq8E3I0adrK8sgTuUeMrXvH5N5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 10:57, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> This is a minor performance optimization, especially when there are many
> for-loop iterations, because the addr variable doesn’t change across
> iterations.
> 
> Therefore, it only needs to be initialized once before the loop.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Make sure to pick up any tags when resending! :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

