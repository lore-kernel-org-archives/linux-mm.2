Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67563606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y44GakXv
Received: by kanga.kvack.org (Postfix)
	id 6EE1D6B00EF; Wed, 18 Nov 2026 15:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F8C6B05B0; Wed, 18 Nov 2026 15:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6816B05B1; Wed, 18 Nov 2026 15:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D94E6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:24:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB487A08B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:24:34 +0000 (UTC)
X-FDA: 85449367668.03.C3D9C86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C767A0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:24:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y44GakXv;
	spf=pass (imf15.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795033473;
	b=YpJcbcCTkAfPQxcyE7vLP8HmTfFKkLF3hS2sd9650H7AQ0tyhzwv3HP4ZrdplzjoRRaG6O
	82KRe82/V+dcFYPvkxth6msjvGRkNvWQDvZ+6izeXbqo3vsXjBMMClu7LAH1gzpRnPpmGB
	IzP5iqlKF8nxCPgp/p1EZPJjPBSLmX8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y44GakXv;
	spf=pass (imf15.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795033473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxLntHqNI1+h3sJPoaAEyO+/hQb8YRhU4FckPwMqXOY=;
	b=n46LjzOMj3872iAlUKs0RHyMsBu0PTVHmwoWMmLFBfCt/C+s8IQwIT7ek3sSpNBl9y3jb3
	2ydlEFyUjalfuR0hqgAYdUCDtw+p7ueRePq5XLCLfvg5PSdQAoCl6dKRAt16tElVv2v9/d
	M5Vh1EZc8CsFqeiClItSq+oKBj0U36M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2300C432D7;
	Wed, 18 Nov 2026 20:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B7B1F000C5;
	Wed, 18 Nov 2026 20:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795033472;
	bh=FxLntHqNI1+h3sJPoaAEyO+/hQb8YRhU4FckPwMqXOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y44GakXvG5GHKA31JnnJ8TOHTL4DJuDPzANJjJWG60MjNDOfyRHhJIm8vJ9IDSIev
	 kJKebboMkeglmR/Z3kWmpAzBb/AQDqIH9Izq2L/2oEbS6SEXi6ZsaYaQUkJZjqCiEE
	 /cEFzHQ3SGAkusbdtG1G+mq2iETbisKSIMwmFp2X1YKr62QeB8t2Omdt7o8wYE65tf
	 74JyKMlIkz2XlLsmuBGfkZAol4hWxO6LXScQh90VN9uTyIGALwX/totrf6ZkzLWXcR
	 OAC91HP6t82IYLn0SO6X1Zc4Z9eHlbMjrylVDrjpOpZr9CRq/RJ7Wgclipi8eTEcKP
	 JLUuYHqvl39TQ==
Date: Wed, 18 Nov 2026 14:24:26 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: krzk+dt@kernel.org, rppt@kernel.org, jenswi@kernel.org,
	danielmentz@google.com, akpm@linux-foundation.org,
	sudeep.holla@kernel.org, linux-mm@kvack.org, ryan.roberts@arm.com,
	ardb@kernel.org, catalin.marinas@arm.com, sumit.garg@kernel.org,
	op-tee@lists.trustedfirmware.org, will@kernel.org,
	robin.murphy@arm.com, mark.rutland@arm.com, conor+dt@kernel.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	david@kernel.org, devicetree@vger.kernel.org, hch@lst.de,
	thierry.reding@kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com
Subject: Re: [PATCH v3 4/8] dt-bindings: reserved-memory: Add
 lendable-dma-pool
Message-ID: <179503346493.801350.7313588345506554121.robh@kernel.org>
References: <20261111110738.872947-1-vdonnefort@google.com>
 <20261111110738.872947-5-vdonnefort@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111110738.872947-5-vdonnefort@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C767A0004
X-Stat-Signature: pgdnfi4jax1cgu4dgfcnn1yub8oshxsy
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795033472-425787
X-HE-Meta: U2FsdGVkX1/AOf2MIV5PzjFTPBqEMkjC5ChNO32vQ+FicFG2WEuNVrCaga8QCHEBCUQt6D09flQC0I8tWFmzZFMIzmoXQ9Is5QH9jT34Co7T6mLbOvxwsMDqn3lhLhYSWmnwlgQVEiVBLaE9L0iI/nM9d3AMSBwEXOFzjCnMP1dvLMSmKaxyUGtzy7tWnI8KFGB75qw6cF7sJrujGz3lsIT9wSDkP0dqK//ESgdRF5iqaHN2hGGrjQTd6wwMywtjpXv6XQMYuXOVxRIRSKCAaHHcXHUZXAscMzu3osJ0YEUyIGt3tfasHDOprejZbLV3oSjIU4hQyW8epcUfGIghYXXqiNx8s7Aknqstig0BruPlhU2NDtHKwJF8olK7apBQMSuEsN3HsIbIQACgIwZIfApsoXYF/1CmWCQwQY30plJHWuJhl4BTg7/ALBjQfcpmKiouZxUxvg/O/KDHbrSIpvf1h3cI4h5uHDBKGk9votCkyol+BqXOYfQpkECIm8riyHwpm55JIb/onF7OymU0YeWW7H+jnXbWdpyoMH0s/poBhsxWjbxLg0ZZLTCJHKhvs9Rbmahyh+RB9Mh2KKJX0BXsP4Ffx4CUzyjX80F9IxzJLLN1IjhwBA9fICQWHdimLrgrEyjYd+4nJ9d3oCzgQZXRKOVDbOdYpJtvE6aq5f8TlajkQACk0n0qJ4huA5aeJboybpNoHZAW9obTGjlFN2mA27XkKiB+l+hFGJy4mbfWzkVm939Nvm99P76k4pe2rr8byfLnszYg+XA90fFFlzOui2FQkncdHtB5VEmIWNutviDPBOvlJV5aYsB9n6eDqLD8CasDBX63Qbg33p0ORUTmHf1ZnXN9TyPgHFNFEqNMcZcKF1GtnnWzdmhukqUrzYh3KdHL8GCrJibu+HKwdaoIm1IIfAzBwLDXxMCn1O5b3hNDoT/5rlVuzOXBAUSfanugLlyYvaGVzrahuQ+
 c1Ziv7to
 pJIu7NHkjoVIwVIVX/GmYI1Sv6bRAAy9COf7/BnkCN+UiRQzV7E7uiwQZhGkq17+wcFspCm9UaUkuQ2KD9xhNiBwoQMEvMsNdkiFZTSAfw9MCRi7al9e9ngBdwVYzyS/dV5YEFKixvls6TTGWRqueuYoyq4daazLBWyui0bqfe8yRuzAtv32HO1v0ns/2ssDLdn67qqRXeuQNHM3YC7fiU2B/d98d9s30+OedwVj4iPkTYCh0YPkJKm7cDpEmB0X6VH3kdu0601XZMpAOHFWbAA5jsX5aggFtt9SGgTHb79jF0GlRA5hSgDPpaF80zpPnp9Ed1Rjg3AVHXrMUJj9NI8Sx30IS9eVDxZ/X8TDoSLMX2bYyIdwcydYcSGeEUthCecQ8j+RJMq7ghpFuOG1k1g9ZkdYNNI8T7r0m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Wed, 11 Nov 2026 11:07:34 +0000, Vincent Donnefort wrote:
> Add bindings for the "lendable-dma-pool" reserved-memory CMA pool, used
> to dynamically unmap pages from the kernel direct map before lending
> them to a secure world.
> 
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> ---
>  .../reserved-memory/lendable-dma-pool.yaml    | 58 +++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


