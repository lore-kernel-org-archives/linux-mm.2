Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D61ADCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A28C8E0008; Wed, 22 Oct 2025 01:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A108E0002; Wed, 22 Oct 2025 01:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6198E0008; Wed, 22 Oct 2025 01:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC968E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:18:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A721288B39
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:18:12 +0000 (UTC)
X-FDA: 84024594024.25.D456496
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8D65A100004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:18:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=RV870c22;
	spf=pass (imf05.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761110290; a=rsa-sha256;
	cv=none;
	b=DqzYcVziQ3nlMRp9AYo6iGahnuvvKKBDgLmCK6Nml9TnKY5l6gYMSgaH9J2gGmHce6VMKR
	kSWLzsBeHyTN+s2cPfFN/8T7TupGYSQKv5vbTBRecAVZVj9ji1hBTnnzMHmuCDT+CD/Md7
	TSwmpBeBrW5nFV/YvWG+X98rSWtyb8U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=RV870c22;
	spf=pass (imf05.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761110290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teAud6Qwz333bGc0PlLBgP477zERkOpdS5svpKstPXc=;
	b=U3GoxWZVfpGJC+u/hhKfHCZM6PlG3onz7G121k0EGcNFzzZfPWNjFTpaW3mJn2HN2vhoCR
	X46tnwDAmAZ91QexKwLfR+cSmc7EwLFXMf89zf+UcmRrY4b8v5buwXr3zO0z2OF5/3vDxK
	0/kOgRglxuazk+8eraWsCtTLVOXJLcY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=teAud6Qwz333bGc0PlLBgP477zERkOpdS5svpKstPXc=; 
	b=RV870c22xWI6DFospbqA4RVRtdgkSEHUB66rwzVxh1Cfc1sI+tPinmLxrriKO5sm7DkWPvpxCo8
	9ni6ZE4zfFEWDsDWmw5mqQuS4kGbfQ5GR35b2EMi0WTyl2ec8uHgC8HV/ljsotwCQIzhG5dP9ORU1
	rivMuii4PfZum4OnODRcq1xxaEl9ykaEgiqPq/G8oQ8ZlaUhVw0yK+m4J7aBP322jc4OmwsB5um7h
	FBogF8hysqml/AbbqM/5J7CZroniiZEuZkEan/HDAa01PLJ37e2SYuZlb81seDVpMbpZMAmKoxGTn
	DJPFhNVriLG7pSd1JzmqAC9p067Jk6PK7/FQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vBREW-00EaFJ-2z;
	Wed, 22 Oct 2025 13:18:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 22 Oct 2025 13:18:00 +0800
Date: Wed, 22 Oct 2025 13:18:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 23/23] mm: zswap: Batched zswap_compress() with
 compress batching of large folios.
Message-ID: <aPhpCGz1dWoZsMeH@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-24-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-24-kanchana.p.sridhar@intel.com>
X-Rspam-User: 
X-Stat-Signature: nczfrr9wrnh7k43uhd4gy5heuq9coa9e
X-Rspamd-Queue-Id: 8D65A100004
X-Rspamd-Server: rspam09
X-HE-Tag: 1761110289-843853
X-HE-Meta: U2FsdGVkX19F1/o0qHK17UF8lc0ViizSlhWf1CUItUROgcLk+maZ2Q57DvUER317N+JTDt96jLD84Y5HgqiJsy0i2ERCPSx34LbIw631uhKqQc023Ro85rYJyuir03M2mWYzH1Y3/OvYAgbPHZGWldBDb5BRgbvF5L6tKW0Cj8n2ysWEFh7E+ityb9E8j0soUk3GqjYZrQbxEK2MqLGPcalfy6y13J9TJRWRDknyCHAbADXz6+kmiYM8UA/zuwJxhHOBhukboNpSHAls4ytFHCatFwCVakURNnKmfxUefL5y2fdkHtspI2fK91dkqetlFV7JCW+Bg+Iqdyw5l2FOw1tcZLmTOgaoNGN9D9BCn2sclHvrViHWCq1VgrxSVsEQOZjMCZyBowxDk39uzYd9eebWTNx4WwDQrl6qN1pKekqLmp4UeRrwJBRLdxFkyw+F41+Xv0HHTSdPbjsJ1r3m/mxGyLyoBZtpZyEXJ/68MlVsqSNFTYXzAGbbatZMEt6yvKhQGZN9v3ZsDUMKEszxHPD4t/e+CI1JId3W07aB0nwWpW5YSTQBScXFGmfrD+PqZ+oAscUalFYZr2UHHKLONjBIaa1JhkgCnj4e3Perrw8aB6r46ClJEyGspJpUW0tREluFmg97NBoUDPVV3UkFH8tQOIHt23VUnPQLZ93lgaxb8E1DOyxRn2sdVvq4gFY/tbC48ukztSRx8BA8iPM0aBYfpCnyOrTAadK+0ZU1g2NhAl0AWag7pPymb2oAAIkO0C9Nx/OYxg0L6qk/UvUNSdBasmQ1zvUsv+Id8gSNO474aoWpW7lUtXW3g4OTF48cOV8Iq4oTBvsjY6+gptXevP7DzjuhuS0ryUls8+u0f3+Ll4eo0hICEuWq6FSQGz/WF3M31qF+eVMW1ac4IeVP1I0eaSSsRlKqdwSVM8H+PISAEbqruSKlQDUeSpCygqvG2UD1o3nDlE2KckgDsPL
 xuSGefuX
 EJZNmKvmwndNSQ5lJNVpxAwX3034hM1wCGX4RwyEU0mFWVyQ15U21g2ePAdgwH6xFMMd1ip1AwqSqgoqvWS2qP+KB88JKr5neOLEU8dSDPBbd50h++Cc2UHEfm9xD9zCmdWE5Kktuctccc7sdIWu9c5NdLewP1zpYH86Fkb2m2yPQQYXk20eeGW0STZ3e5elh+/y7YtOLLJjkS/lCl8OQe8pdYxXQ/hI3F1+mYZsvAxsZJKxcEunieyw3Vz7LBVKgMosCS7EyU4qbaU6ucaKpv1yZ1ckUZcWA6EBDoRKKJum+5dxT7pUwfSDh5+102BjjhbkMbrx9JXDKuhLf5C2BeaROAP/aye50bHJ/y8xFqh85BME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 08:35:02PM -0700, Kanchana P Sridhar wrote:
>
> Another initialization level optimization that happens in
> zswap_cpu_comp_prepare() is, only for batching compressors, we allocate
> extra memory for "batch-size" int pointers in the
> @acomp_ctx->req->__ctx[] that are statically set to track the output SG
> lists' lengths. This optimization was necessary to avoid the latency

There is no need for this allocation.  Just store the output lengths
in each destination scatterlist entry.

Before the call to acomp, the destination SG list should contain as
many elements as the number of units.  On return, the dst lengths
should be stored in each destination SG entry.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

