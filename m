Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C28B606A339
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kGmKf3wz
Received: by kanga.kvack.org (Postfix)
	id BD0E46B05B9; Tue, 10 Nov 2026 11:07:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81C66B05D4; Tue, 10 Nov 2026 11:07:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97886B05D5; Tue, 10 Nov 2026 11:07:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9108F6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:07:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F43EA09A7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:07:58 +0000 (UTC)
X-FDA: 85419690636.28.5F22726
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 78862A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:07:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kGmKf3wz;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rr13xWGGj4cOXcLlAfFPEFlHdCgyfIdPwKJSNmQ6jxY=;
	b=bRwjupUEpLJnLro0qDhaWRC9z8azXqRi0EKazuGtJ6LWKo49pFAjY44dhEkTaLz8g73cX9
	H620e7GI7oyl1VpoprPCd/yTVXKNRJRtVVmg8Ua5sjFHME0OCKkt/XLQq/mq8w6O6I1p2y
	Ad1/MkiFFdDNV76xoYJzs8Vuv3clP0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326876;
	b=NraLtVqH+RD10Ch5JJpHklet0oYanng7mQYUmuKOzTIRiJMwxl1mt8BYSlQsEiQkdPneva
	aiECvE4pP0GeIyluMiKBfCI18yc7Hq+uSJUx9o3JykXtvD+kvLBJkXyW8mYLIGC2mByHFX
	0Rwbo5Y9SIxQtJsiuiW9h9GixNCmCOA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kGmKf3wz;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A06B5405CA;
	Tue, 10 Nov 2026 16:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FF81F008A1;
	Tue, 10 Nov 2026 16:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326875;
	bh=rr13xWGGj4cOXcLlAfFPEFlHdCgyfIdPwKJSNmQ6jxY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kGmKf3wzt805VYWVqW+MBTOqTcI2w/6HR9x6GkPSmTCdbAUjCe7+Z3P5pTARCwOga
	 Bk/dTss4NZSdI1RYw+3X+W/fa9/HuDdOEs7s7J6YRjnbDqezTif77ZVL5IL2pdZ6E/
	 JYGDJ5RpojShPsM7QTag6v84N8sVFsAEBmUT8JduC4F/4x7lmfdZ3eCs9cmZOi3373
	 JYCVRas0ydcZWDZHfCEFev3VVz2haiC4hxXFIhFgDr2PKcHX54IJYC8dnkHAw6vWkA
	 Vq3CLVtBmSl9if5/PlhFrSYaT/6R1K6SJvphYSU4WkRjAGgGJYgH2QYU7JhC2xyJgn
	 puVlfPI9XQP+A==
Date: Tue, 10 Nov 2026 16:07:48 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Lance Yang <lance.yang@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Seunghyun An <san55@wisc.edu>
Subject: Re: [PATCH] mm/vma: predicate vma_assert_stabilised() on
 CONFIG_DEBUG_VM
Message-ID: <avNAgtDzM0MYevV8@gremlin>
References: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-vma-fixup-debug-asserts-v1-1-0b2e0680cd7e@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: i7s3cj68bj3d3ytjpse8a7dc3rxheqak
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 78862A0005
X-Rspam-User: 
X-HE-Tag: 1794326876-145043
X-HE-Meta: U2FsdGVkX18kC1ID2RbIborG7D+x1PN0KbBpm49sHE7+fIf4XMtCEe2iVJyPxErkaaT36xWft74KinCnFA5G+sspuyNEiNlUNuSOSmaQsL4xSxZBMwWhZ44iEiTl6nofbhqsJlRzLdTNps2oPBtqim5v6HG4BpBPLEjfLMhV1Tek1SrRNajIJ3tTqcrmj5CelZYWM4CTRPS96XXhAvh7YvaN+mph7F16LfjTq7uc98zmB80tgd5cBngxQ1fDz8ag5PXh5J6frBKxeKyY/ov6ZVYzwAciYrEJyPq+ddusRb31n/YTAlRomqUsoZFLVTqZ5dFGjjMaYoHr/8GIIBVL1Q2zOuZQelWzzHZIf/rgaspAkjg3WgEiMLMa7E9AqdjP7Q4pj1juwY/EIFlQCfo7SviuF8nuKI+eCs0M/aJTAZ7H6LtZdVjGxd/hOcm3ld9zLXEYWNmBETrTxMfcLEdlmDzrvKdo/m/nOmQmuvaeckEPvwVObojHOMDV2rTZK9lRauYzXy28ocJCv9rk9CKH6xklT/TFmxO3hnFaQuoQ0D+RZaqjnhATD+DakoHcMCiLeFmq6Ol82+R0hWxKvO6+Zx/FVpTemV+MwCBw0EjzU9kJgJDZ8ElAB78GfWtv1Z+oZizB3ZojBgdtNl7uJpyMH1c2Kt1lHKOI4+6j7KLn+hYiAiZQrfaP4AXtmmM2K9p9hCCvNTQv98xlNV1JxXcQ8LiRMlVEjCQGE0dqIG3s6N51vDd1pNVlERRK1bSZNnDtAmdXv0CQpGsnBbvoHvhvcX+ckEbUujb0fJrCLcPj/T6TJLUGr7ZcLmJF7UbcJofimlxJ4NySmyUptTE7arFlT6n+vvl96GdSJaQWSbFZ31bP+J4ISRn07BmBFxf5MIyV1RsfU8QlkBwvXKLs67cr8z8b1aLSklr2zXq+abLJuz77Znx5/nasLE5aM3PpNdGcLleA3ApcJlstHMqQube
 Ap5mP5AA
 X0zzDjo4rs1u/pnSHsHw67NJG5HJCiZC1O2eV9ArxX2wEpOGTcouNEWPz4vhuKlK86q+EharqQb6xTw4w+FMdfLYuAXK9797i95PeSyPCvfQcnGseqIHaG8hLGJgOvdKAVOjffsGHaHXcuVsKCQPnfGdFRv96WAHWLdqApuIZNLwfkb59h4rgKDlCUXS6wy5YjnOAFYO6nWfJ9sroB4s0HwG/81ApENnTn+dLeX1awlFG9oucxlyCA18x91c0LIqrymgYy/3Fm05tqjJ5RAd3R8OyVp8QSFrSy6svAS49iZ5NTr4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Andrew - could you update as below?

Thanks!

On Tue, Nov 10, 2026 at 03:10:40PM +0000, Lorenzo Stoakes (ARM) wrote:
[ ... ]
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 9ccbbcbd7aca..9c3a9c6525c1 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
[ ... ]
>  /**
>   * vma_assert_stabilised() - assert that this VMA cannot be changed from
>   * underneath us either by having a VMA or mmap lock held.
> @@ -418,9 +423,18 @@ static inline void vma_assert_locked(const struct vm_area_struct *vma)
>   *
>   * With lockdep disabled we may sometimes race with other threads acquiring the
>   * mmap read lock simultaneous with our VMA read lock.
> + *
> + * Assert only if CONFIG_DEBUG_VM is set.
>   */
>  static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
>  {
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM))

Actually I think this should be:

	if (!IS_ENABLED(CONFIG_DEBUG_VM) || !IS_ENABLED(CONFIG_LOCKDEP))

So we keep the lockdep asserts going regardless if lockdep is enabled (you'd
expect most users to enable both together but still :)

> +		return;

--
Cheers, Lorenzo

