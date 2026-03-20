Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C31109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6976B0434; Thu, 19 Mar 2026 22:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50366B0437; Thu, 19 Mar 2026 22:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17AC6B0438; Thu, 19 Mar 2026 22:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADB8F6B0434
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:50:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70D3313BAB1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:50:35 +0000 (UTC)
X-FDA: 84564913230.11.D821F0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9E0B1C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:50:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E6TxFQP7;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773975033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUe5diwF9LMlG4HOdeLfCUI9nGKq9uEG/5cDNEUAsgA=;
	b=SpwqBpQUWzNomCsAJKx8R03noveRYKNnIRRJ13uqlUGB8uHWr3SMvaX2L7MWTgE/sg06Ue
	PyE/Y29vad+bWX6ZH/Yt8VDnELF7+dQEN6ATQv6d195iabY9j23S7lW+EPFxVogeHeCoPb
	xgVVmKXKUECI9l104rN7zo1FNMfrNPk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=E6TxFQP7;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773975033; a=rsa-sha256;
	cv=none;
	b=TiDp3LhdTNqRUgNyB3T/CHFZVLTNKatbFBE+0IrDDbaL2okV0Zcf3q6GnHU5ITIsEqq/kr
	YS1PQPw8dzfo9O0pcxic5mILUAxZYbtLUvWKPjl7Yn+2FX+sMnGjr0+yoG8BS3K8GU2Vr6
	jEO308I2Yzc0J9qYXf1Bu05wDNiDKy0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 67D4D60097;
	Fri, 20 Mar 2026 02:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEBCC19424;
	Fri, 20 Mar 2026 02:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773975033;
	bh=KVGDEI6eseEcgaCSXUJI4ZcpUMbgOitzgm/GxAkzI5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=E6TxFQP7Us5HlcDBS3w1rFIHGHtPxPvGxTJH4au24oBWmb5WdPGXDBC6r4qsM3aD6
	 JpTdit6mPR52t4ng4EzRvC/xyyYMeDQcybaiGVDgWNBSO1+jy8v8jT77fYccRdTWPC
	 62tDCIG/2twQCkcLRvwx/+bO4TsEstd5elYdu1BE=
Date: Thu, 19 Mar 2026 19:50:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 0/3] Fix swapoff race and cleanup in hibernation swap
 path
Message-Id: <20260319195032.5c3b187d5779cf43cd63fcd0@linux-foundation.org>
In-Reply-To: <20260319142404.3683019-1-youngjun.park@lge.com>
References: <20260319142404.3683019-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kpiyo3an7wr4usdnfty4fzcnhdfofaby
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D9E0B1C000C
X-HE-Tag: 1773975033-382226
X-HE-Meta: U2FsdGVkX18Nzis8T20QUwJ/EIIfx8mGRMhnxz4S/BrY7+m+xxA4YNUa1CtT7i1V/KdE4uUU01yYN1W+mK4nPDddqTAUKPDpOQS0kxAfNKJcSmOoEM8uz4EWl8FpPiPKvosP2rr70IDFC9Zhim2JbjC8e8U0H4zyrP5RkJPAfFet9ciaf5YCNBhlhBDyG5IGB8hvEWCPHNsPmtOT3Bu3BelTIsGB8TajsTrxB301mlBqE3NLVmeMsH9xOVueYofQgNbpos771CUmDBhKzY12R0XGmltURANx10GRs5ZucCQ6PuclfP6Z4Z6wpZJ2UXd0OFhJvV7TEfKizficVsOMNKNfKpjS97CnqELKMJ/ktK2GUj2RCUu9O6QlB8OwiD2KfLxaNFFFqgxzoVmzusjwtE3erbVs6i1pK6MFbQo9rZFGPzLgVm7ldRs5Pn1R8t1x531lLMFp2jJ0q80EcPv/DKLl9Hp/axAJ6izWd2yZfFEB46S9Z7YnXFayzzR6tAjHVJle9LSlRHplWWKRHyd4tmYEji2V1mvrt7/7Tp1VfXXYKK2MkF7JpWuanFwR78Hzw1IbW2ImCwmh4bvPlTZU6/e7ztxschr8i6hUcOYc1RpbEkUpuhPK72K2SQum7SZjhVhr7wbqyGc97nFlF/Uv5+OhMKGQjKN0zc0mK4VmCKdTsitGXaNuc+BInPDoFIwp9fRbxxvvG3a0kcNsN6y4axbZZc+osXZwXMU4hGO4XlPW16pp9ohItfgJ41C6/U2PnXOPAx9rPlg2KSVSm9lR9M+Y0klmiP9c7vPhyoXXhuJfb9DG6EW7XLbAYERFIZfPT2YlmHaTSaXFn/1OouYKfmIrRLByGfUnzLLMwVyy+7d+DPZnx+dUBa+L8vKzQq+m11WjKJFZTWcuW6CdoBCDBaEjo9ZVmqJ3RNy4tRUn/Yk2PwBUVx5I5W9ENBh3fbpb+hgsnb5KVg+SEUswyg+
 QOaphrVh
 dKJKpO1GdWYneuvjZqzSKbgfkrg9pW8vC1lGTx5uSP0mokBDy2CCN9Y0Nd0fhzMErgU/mCFAfEdd0KRc46A9M6lbEDgMk3CO4ApFqqTHsgWlgqc1MfE3mIY1fHF4e5QWmDtYXpZSOd8p+k3HD/PXV7MaeCQU9T41Lwcvo/EI5G/2jJUpnXgfhyljqRH8tLROLssj69HVa70TnnZz/ZrzJMUROIEY+3BZ31i2pfZmF7mRqMAHW05BiHfTbFM2CtUM0X8sYFfjF8qfPZty0hYSdfT7Uai7MHjGauDewOkIaTW6femG+WW944HMGTiC+k7GyYylBnWdJr2feuZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 23:24:01 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.
> 
> Additionally, grabbing and releasing the swap device reference on every
> slot allocation is inefficient across the entire hibernation swap path.

AI review has questions:
	https://sashiko.dev/#/patchset/20260319142404.3683019-1-youngjun.park%40lge.com

