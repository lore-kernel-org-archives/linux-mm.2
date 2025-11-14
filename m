Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25CA6CD98D1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587CC8E000F; Thu, 13 Nov 2025 20:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5384D8E0002; Thu, 13 Nov 2025 20:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EA88E000F; Thu, 13 Nov 2025 20:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31AEE8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:09:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBD2A1DFFD6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:09:38 +0000 (UTC)
X-FDA: 84107430036.17.A8BC1C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3863D14000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:09:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1j5jNdf;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763082577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jd+0UbwWQYKJMZJaylP1KFOlrtcT+hDouJ22nSNDKSk=;
	b=RNq8vXJ+BEdFMknNqHF5bEvQtxAr6xd5SC9GXwS0/zIlqolLn6HYYMybw8tnybE/o5pbCq
	o/lxxIuWAVRT4+0Fwio1UqF4IV1vaAJRTIO1cRKkzHM+usHqVPTb3GGAPYOVMQJaKKtWRR
	mGH2XzaoJOPPhJjbSjjT9v/kfTSLMUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763082577; a=rsa-sha256;
	cv=none;
	b=b8Q6JDNZRp7BoKjNmFFZ1Q02r9Fg23/2eZnV9kvgXMxC/96BFDLQKh1M5GJuKzVGnA0RWu
	WtNuhhbYuEwHUsi4+b+mlVwhOt0gz10n19o6PQdpmgXMaosUDoALA6j+MDNmTBcXHpQw0G
	jm32JPo92V0g6YymLdsnV/+Z3Nrry+g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1j5jNdf;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 74B6860130;
	Fri, 14 Nov 2025 01:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4C1C113D0;
	Fri, 14 Nov 2025 01:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763082576;
	bh=fmK0NEdWdF/kEYPSYxn/w3c3W5Hgog4Ht3cnrXiHR8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1j5jNdfuXYpxfsw0nmd485P7Yt5d/tK0QyWJkSu/4Z5IKr+8Yr2Ajmyx6HScl3lS
	 JCdKRYxWuwC8xHn1tukCkk17e8oeaz11RkiH1+etqLIK48vVwPcqzj/OwJYKlfeJ1n
	 spDaViGMJE46+TIxDYGClXtyph5phXa9V3ofm3fCjlMX75lZA9mk6ErZdjESNGpJYB
	 rRgRksLomwAazrVlF0CW8TVLkdBtQ26uVZ8m/me/Tt+vCE8KA1PHIPtU/rX/dMYNB/
	 XaeiH+5jiUUqGx7DEJxn+T2lMuyjpGOgfLWtBJmmc9OMKDya18jHRb7z7l2EbjUunh
	 /tdV6FXDY51ZA==
From: SeongJae Park <sj@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Date: Thu, 13 Nov 2025 17:09:27 -0800
Message-ID: <20251114010928.151974-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113145636.731a24e4@endymion>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3863D14000A
X-Stat-Signature: iyf59pqtrnzsw95tc1gw198aam3pe4pj
X-Rspam-User: 
X-HE-Tag: 1763082577-683251
X-HE-Meta: U2FsdGVkX19yDB3ONZLt+RJRInNrugKd90w/zC+mdIjkV1vu/uk8grflU4SI1X222MxKf/BIne9J9+6+BZzvIVzAfIyxWk7xjK6DgL5UiQc+OHladOETlX07wTTqSEmc1yLd2/5gV0AVvgNZfnm+zInVaDQHhF3lzGTdQCEHINxdcT9hcBuA6e5mVPFjkepJxMcGm+moHIVUa0aAfBZNYrYy6FYPAiQX0YoAgUNamcP1H8Phqxk9v/2obe/mzBT9tG75NAgS/1lCQUU5Dgnd5Trx36LXVBQ1pvnCl9neggbs5dNgOquYCXP2CTDFKWYhNiaAJjrdO/CPkaslv4ywZR1H6K5vMVaILTWDeXI98+/tOioH3GPbXOMkhzK3XFm1bihIZeyiw91PMaVn63LQFDUNlmZSzufE62Om1y6lyYc443UoQbiCY82H5z65hOZr+Kefic1HyM50dfyI9M1yuzjaF88Uq5s3ZgF/yPbA9mOpmnfQiezP0qry24of6oLwprh2c3Z/oRIITyS3rM4MF6ohuVgv7AqDo4nPV9DARuCCwta0CaCzm+z6bFaFk825bE4XEUGFUJI1zeuZ31XaW/+3JnQMfukqxCumglRwMxAd0uGEFhiN/n2crSrwGZavMeO22jDHbCr4FM88q+oIeWqCQGYKSYa8g72RY78MFk9/QdHtLav+CKdvt36X9hLh6WBLprsHhPDkpu0gVh5b/iPO6Xtxn1OfpIoz7Sy/SQ6XwZ/8wYiZP2VRDzy9OcpbuWJnG2KMG46qInjwjAsJbIgmGnpVK12YcTXJfKz8ODE71WqKNWeaa5VfGLZcKkHwaSznEss3iD7i1EhIAI2LtXcWwYbBDyvIo83hzNpjYO/D17dtYJ/M91PRNH5w4sTH3ibwJeSKVwWUyMAaMVWmcDzAeJ/EQz8Kn0UqKySjqMJLgNJHqA3p3Hhh94Ms23nZyYGc/mmQob22hZjFtRL
 1cWWk4qt
 xkDy19RMwzm/GyqNsMy3IIvkNA7prizJpl0X+L44mzpn+wDrgQQNm3UCJW0JaVhm/lOiQYRMF6qfXFkjshCAjeUIghsp1HSZmyziQxckolG/bZXdvxFLWEPixy0FrgFmwUj7bqV3SDlJHVoB3afnwfdqn12DJtnNjryK37O5kXcLX2/e0Cb3zJPyJNa7fDCx0erlB60XaCwSPBumjDKq0blurv0FL96rQQNBWw5xRl2loYR/4PsiSKokW6o32f7omtl6F+WyoRx+2p+agAN2d69PKGk4cYeSRFQrJjDlMq/NtBTEccUvp+3yx6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 13 Nov 2025 14:56:36 +0100 Jean Delvare <jdelvare@suse.de> wrote:

> The sysfs interface to CMA has a marginal runtime cost and a small
> footprint, there's no reason not to include it in all kernels where
> the dependencies are satisfied.

Overall change looks good to me.  I have a question below, though.

> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> ---
> As discussed with David:
>   https://lkml.org/lkml/2025/8/6/371
> 
>  arch/loongarch/configs/loongson3_defconfig |    1 -
>  arch/s390/configs/debug_defconfig          |    1 -
>  arch/s390/configs/defconfig                |    1 -
>  mm/Kconfig                                 |    7 -------
>  mm/Makefile                                |    4 +++-
>  mm/cma.h                                   |    4 ++--
>  6 files changed, 5 insertions(+), 13 deletions(-)
> 
> --- linux-6.17.orig/arch/loongarch/configs/loongson3_defconfig
> +++ linux-6.17/arch/loongarch/configs/loongson3_defconfig
[...]
> --- linux-6.17.orig/mm/cma.h
> +++ linux-6.17/mm/cma.h
> @@ -49,7 +49,7 @@ struct cma {
>  	char name[CMA_MAX_NAME];
>  	int nranges;
>  	struct cma_memrange ranges[CMA_MAX_RANGES];
> -#ifdef CONFIG_CMA_SYSFS
> +#ifdef CONFIG_SYSFS
>  	/* the number of CMA page successful allocations */
>  	atomic64_t nr_pages_succeeded;
>  	/* the number of CMA page allocation failures */
> @@ -80,7 +80,7 @@ static inline unsigned long cma_bitmap_m
>  	return cmr->count >> cma->order_per_bit;
>  }
>  
> -#ifdef CONFIG_CMA_SYSFS
> +#ifdef CONFIG_SYSFS
>  void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
>  void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
>  void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);

Why don't you check CONFIG_CMA together?  I think that makes the change more
complete and safe.

I found there is no file that can be compiled without CONFIG_CMA but still
including this header file, so I expect no real issue for now, though.


Thanks,
SJ

[...]

