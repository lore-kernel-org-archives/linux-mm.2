Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411B7C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA4D6B0093; Thu, 30 Jul 2026 14:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454816B0095; Thu, 30 Jul 2026 14:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F53D6B0096; Thu, 30 Jul 2026 14:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 044526B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:12:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1091A1401C2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:12:17 +0000 (UTC)
X-FDA: 85046237514.30.2D50B1C
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 060161C0014
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:12:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jjd9ahJv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785435135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
	b=ff0lZPp7n2k4P1fQwKXlrPpHvVkABp9izJUx+CcCZEVUJkHudVBgpSOUluo9AflSICentF
	/ZGu27anq51C2lxvLYHbdc6k3C6evx2pN+MQG5FTFVesw177Y5kuK7oTlfA6IeLRUGlLoO
	YYUe9+/Mbf9+L6Gt/rPVwGSXC4b52hc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jjd9ahJv;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf21.hostedemail.com: domain of ackerleytng@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785435135;
	b=ITUbgsHYypY9RwJhg4zoM6cmZeQvRZqHc8Jy13oqtY2Z0BS9mEKuR4pWplSUxoTFXGc+0v
	yGvTwyjyYViXAprP0oufPC3SMgP7MvzXt3EqaeWar5XUsTOHdQTGr8FQ32OIeqDMo4Kghv
	M7h6txz/ybo54Q5pQa9/Or6Mw86z1PM=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d01663d816so754305ad.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:12:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435134; cv=none;
        d=google.com; s=arc-20260327;
        b=ofkGdPiRd5EGfO3ebBTE6CRTjoFIYZYop9FiJlNleZoJLKMHFehNjMs8ReRxKerXEk
         rOtXBb04M1C5lrzGPEq1EK48hl4+66fIShwxdmu5hfmLt9o9LW5sY3uw9yd6qmGnrWbX
         Pq13FU8wI2rx9pe0vcXi2l4GJuxMp8bGUS9S2lkf+cXVRutWvX2QkGZnxBWI/JW2WKIe
         SFgXNrLDvN3z8BN1j+LWTqnakGCGdGkFpospQDjhbyKTlF8pGmR5P4wrS0KoN69069bp
         dkj6KYCz2b0mNHRjSr6Zx6SRhPFqY4BfskkYprTkOAxBH1/vth6jcqsKtzaUpGKWlbJJ
         okPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        fh=y9Mhu+vU4ovpKgv74ehnr6utvWFZXfj8tm2BOVivxro=;
        b=AK523Zdr0fA3zjVrvG8QIF+ORny9nQGvzq7+2ymqHNEBCLA+SWhhsfVRCKM83xyKJy
         IF6iXTSXJ1gYCLeIAV48dA4HCLj+w3kaNoMGoqP2BrH1bOzCpPx2zVOs3GBZpu9RqI1G
         U4EKmkgllf9GOoYISmDFAae9r2iXYRVLJlYeiqELYA88m0xAYMRcJ6ouDuCMZSryc+7Y
         97qTqhkvQXi2vEOabLq+qIyHMY0PDsY4lDohi6d1wM0NRsasXIUp0GsTXOlHqK8dW6qL
         tUCwKym8VOUIYNEyGN6TqKwijB+nsjPI9KXUM51ONoB5mb0gbA4HGJh8toc7M3kGV2ST
         Fwow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435134; x=1786039934; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        b=Jjd9ahJvwmM8YX8toVbYjfyQPY/3zTYASDefNW5SII9ZxFQwvK4/qNc0Cnz+RJItc9
         TYvfBSjARjFObCH+Y0TgHGD/nXiNsdEMgMinGka5o5vqFcdNFiNa9aKlUgjXKwlAPHAU
         EfysRf/Bu7i8EJVKdV7xL+6kC3ZGS71Wjv1WwSj4HVa07PR2VsJAO4LZLcLLZHYvzRuL
         3yUxLQ4jqMs3sakDdFgiUmeKeL6ZH32TBHDDkfgcF4r8BM+EucIgitUe11ieL4MUE+V8
         42OlTEtxkLjWEY2mGdE1S9BCx+A5KEEMRQArYuEZbbjAjb71Bl34x4janB3GPQII9aH4
         koeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435134; x=1786039934;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gPvFSTghJ28Kixi5Kvwbbt6p3THpZRrypXj1JQIqIto=;
        b=VQE5Z9/1qGht4bDvuHO/BcyiOeDDYjyuxhDaKHi408kDA4XuZRcoYUZO+mToJR3C74
         emXhkxcvsaemFe4JMW04dYb/uSgVZ6OYRQj+l8TGl8cHaG35O9WPPkB7dbL0oetqxsTz
         LgsJ7TsK5hgK0amfzoOlwoJgT7K/XAqUIQPE8p7w8mIY66+ugITrCIFUjyNz4YcOPUK+
         5Fjj6f3UMrXiNCDNZnrJS9heZsvm+LVuV27O7Y1Xm8O6to1Pbtg4s52bhFFDw8FMYA1g
         KjweNxouOgoGvvyYQs8RzmYPABks4ZZN07v85Lo31D27cNmf12z1Wg65wnG3dtL5L4bO
         qhkQ==
X-Forwarded-Encrypted: i=1; AHgh+RoetRr+x7V7nADSGBwNW9wmWuHEvBpG6PIKVPyXfvHmwrNDXR25T1Oexzh304N75gReYuHOF4w4WA==@kvack.org
X-Gm-Message-State: AOJu0YxD4kv2Ku5jJl6SGI4+oWNKBBgfzJrXfM1GcJqh7ueCQ1HdUnY3
	xSP49qeJkwMOhHUfpDWobBGJA0DH0fqB48oEEf0ihKny1hW9944sxmAVwALpeXX0oYiUY3KuSaS
	Wcc+pfFZth6jqYJJ+a0wRt9bqAb2oG5syBYUM3gdp
X-Gm-Gg: AR+sD12/DxrF5uPmgHF9mraOthWyQJr88T1eb6FaX4f9ax2REOVr7nPZu4ldzVAcji/
	2iAG7H4KDyzs9xBHBwwv31n0ouwJ1afrdN9pmXcZo+YAcczjA4qX8YNu3Ncl0Vg+0oOR2gMjybW
	A5kDEu7DCuVYNyYu7TnMV9eNDTo9vjV2snzh1hoti4j3uAm4lgpGSWXcpwXGjXHSNUl/2GZ8Q2Z
	LP8AJqvZMNzToIifzSzdj29C8klbJSIKNjZe5SHTT+QXNky7FZmbUteW6zqbC2Q+0A3jGaPx5y7
	t7ylDAC9p0jxfLWDxV6Ip3Wh0LqFc4Unrim9CGzAO80qpVKnYerjBXVCKLPZU+hlEtQ7+331I4T
	triwb5xohP2eWaAyYL84gR+hz6I/lT46cpg==
X-Received: by 2002:a05:6a20:7f95:b0:3bf:9b61:f7ae with SMTP id
 adf61e73a8af0-3c90046cff3mr3701207637.14.1785435133085; Thu, 30 Jul 2026
 11:12:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:12 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:12:11 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-8-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-8-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:12:11 -0700
X-Gm-Features: AUfX_mx2gL8KIE-6PLoUtXVMOZbkrQaxrGgfvvgdayE505KQfySpbra5kxUa-V4
Message-ID: <CAEvNRgHW0P78eL0ip799XF+2geKwz7MQrjSFTgvCdUAuh9oykg@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] KVM: guest_memfd: Add support for freezing mappings
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 060161C0014
X-Rspam-User: 
X-Stat-Signature: 68cw3z8kkoy5xahtiu6csgjinnfb9i54
X-HE-Tag: 1785435134-326449
X-HE-Meta: U2FsdGVkX1+UwDsFfzQNqrCKWw5Es/fL5kCfaMAra1sW66Y5CXHIHkn0lW1oeshgNR2Ggky6PQUBNixye6sXX55C3OIMOFhrH5rLI+QJXkI7kQFESkUbH37Sui/TXNGJrI6UPRN6SLP28XijkApcXaRoanzgPOXg7yCjrtOIZQGZV+qdUB4NlwuG03b0w3+RiHETtT6yg0fQLQ/NMF8+kwbOR/g3TbqDYQyGQQr+7cK0mnhMmr0ybQ2vCwIGhb3NNQsYvwWoVV0eV6MEaK0L/WUTinLMcee846n2E4TUv2/2rSWX5t/5M/IO7mzFFnY5SgDKibQw//PjBEHpt8iwPEdPPQj7vmgW5D2SK8yjmCbiQo795vOtZFc7U0buTc2FVfuzDuoZZoYP5SXealqySM2jyYCtsxRsXY0CGymfF1m2DJNz0ZJiWBsgZPX7tfy8Rf5JWPXJ7jIU2AyYhELTd354B07mjQm2F1NEACkrijskfPPB1aq63nUNyxXtom0KI5YQaCgwjMFZJAMyAeR8pC/AlgCF83U5PBzs1n4H6m52jdf0+AAwxQI3w3jkIGNuRQVytcHKDk3AguLQwjFi74zSqBbIjnhEpx3NRU3Y1r6fQG20khlTZ9GZr7fd/yaXSu1gajZ+Ye0jwTAIhZKp1Ztc2ZLLC+7FABv50hU/zord8U9orRNQDje6h3t6C9eysKzqxIfelk8Nz3GeIrhaU408gM5DR5EvlR7Z8hcIhCTui0PSHkPgZCYGpbueWRpMMCdDxy/5ISOO+Lgd3LNSK3n5k8s3kB93H3Zr2IUpxTV6zgf+GGpOpdRgOH++RZLXyXwM9Z4dicsCm54N57yXOoGWoTCWZgaUP5pr0cKaBdc8vXbUgYZ1aZkfiXLlZonY7lna0ZHuEru7HxMgs5efAUTKIvBBGM8N44/T2v2HrR7zLbfyEEJ5iCnLYiup6xWP6NYjlUScpxVnqI3HUq9
 v4bmz+To
 OkP9C/8ZBFinv83srq1PzWZ7EFlM4m4CW5qvtxC3LPrEY1CYJSqZfJOE3OPRd9dXu99nY5HDt0jXYeu3pUXPyfhdjWOR1j9CVqzOYldDPm1eMWS7bNTN9irLWL5P+kyj0gDSJl8SomgX9ycBgzHvdrecqIbfdTOCaortlbqFL2rc/Y8m4DdvfrlsDoIRH47dQqC7Uc2lbsSOQiHUKA85iDdfvbssG3nWvkCZNAwlGqVO+W4TXJpJWU0MyN/FLP2JKeLObty5P1vifTlGlOVaZqRbg+uAFt1optxP/daIs8A+2xeR9UAtBwGejAuJYscH8Ld+wu6cgxwNfCBJzSmxtC55RGKtQJTSsAKyfvq6h23bPJcxgh0zhWfzMG0XcYDJFcbuZA7pS/+P+rCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

>
> [...snip...]
>
> @@ -273,16 +284,30 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>  			       loff_t len)
>  {
> +	struct inode *inode = file_inode(file);
>  	int ret;
> +	int idx;
>
> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
> -		return -EOPNOTSUPP;
> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
> +	if (kvm_gmem_is_frozen(inode)) {
> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
> +		return -EPERM;
> +	}
>
> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> -		return -EOPNOTSUPP;
> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
>
> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> -		return -EINVAL;
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
> +		ret = -EOPNOTSUPP;
> +		goto out;
> +	}
> +
> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
>

Continuing from [1], this guard is actually meant for PUNCH_HOLE... I
wonder if there could be a deeper refactoring to check when actually
punching a hole, basically the equivalent place as kvm_gmem_get_folio()
in the flow of fallocating.

Will srcu_read_lock() be taken in a nested way for the fallocate case?
It can be taken in a nested way with some intricacies, but maybe if the
freeze check can be done just as the folio is about to be removed (as
described in the above paragraph), it would avoid this nested locking
here.

[1] https://lore.kernel.org/all/2vxzzf0kl3dt.fsf@kernel.org/

>  	if (mode & FALLOC_FL_PUNCH_HOLE)
>  		ret = kvm_gmem_punch_hole(file_inode(file), offset, len);
> @@ -291,6 +316,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>
>  	if (!ret)
>  		file_modified(file);
> +
> +out:
> +	srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>  	return ret;
>  }
>
>
> [...snip...]
>

