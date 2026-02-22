Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFA6C636B6
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 19:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854FE6B0088; Sun, 22 Feb 2026 14:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8365D6B0089; Sun, 22 Feb 2026 14:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738546B008A; Sun, 22 Feb 2026 14:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC0F6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 14:36:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF4451C79D
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:36:35 +0000 (UTC)
X-FDA: 84473099550.15.351C475
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4A5BA40012
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 19:36:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AZCMsAWK;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771788994; a=rsa-sha256;
	cv=none;
	b=l5dMaXT8CtXCsRf19kq1M5gWwisLYMzs01iY2gpXBO7zCfJ2vz1+dOebsmni05o1KkGf1h
	tfkGq7UGwS7pGjKAlo9V8AZFE9DDi+5NoAZPTuUMyUh6aHztIUOVkxa/YMzecReOsaEZRU
	2xuuXG/8YTu6DF9pEpukxZHt6u8r8Hw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AZCMsAWK;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771788994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLtATVfziq2NsHaixCdB92k9OFRtTqAdufX9O9CyUHU=;
	b=Oy4GIta4eFflnkau7V8q2vVoBHxkn9Z1PVihMYfEtY3UbBL/ZGSD956jYeaU5eGixgH+CE
	N5L4jccWVe8piI9ktHRIbCREQtCaU0h+gs/9V3kk9sxsAOU/b6moOhvMiKYFsFiHsakrIG
	uCtJaf/zPG9qCy2oNuqIOWUBxIepvq4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E54334034F;
	Sun, 22 Feb 2026 19:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAEAC116D0;
	Sun, 22 Feb 2026 19:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771788992;
	bh=j6Aq3bLjqLlAE41T2HRH6SRYftcu10d13je1+Jl1r4U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AZCMsAWKL+/zY8NFl0Po/6EbZiGpdgS8AA5J6C27bJSt27K4bXZpGss4wAXbRL7G0
	 txWNxp4a2TET+NfCMmAHz2Ut++fN12p+1OZEySCZc0eHUWQNTlhJ2rfBQs6buFLkdn
	 ORFfplOCuxjoO/fR6VoOASJReEhD/6m8S9SHmYBA=
Date: Sun, 22 Feb 2026 11:36:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Chris Mason <clm@meta.com>, stable@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/swapfile: fix list iteration when next node
 is removed during discard
Message-Id: <20260222113631.6011221e2d8d8f3973f035ae@linux-foundation.org>
In-Reply-To: <aZpe3kD/xmz87zYH@yjaykim-PowerEdge-T330>
References: <20251127100303.783198-2-youngjun.park@lge.com>
	<20260220151338.3234934-1-clm@meta.com>
	<aZpe3kD/xmz87zYH@yjaykim-PowerEdge-T330>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A5BA40012
X-Stat-Signature: fh5j7amtq7ar5ybkyf7b4c768br4gbc9
X-HE-Tag: 1771788994-43460
X-HE-Meta: U2FsdGVkX185XUmmIXfTmD0mSk9BM1sSfFCu21YP/u9F8POzzc2LqtRVoSdryU5Ee2IdP2uhP8lobOSzHj/9rEHZvlwhTomZWBNcCWhsgKMEKNNWPfQGt12UpxEqsA5S061xgxVJJ7RT/4Nam5IJA0iSy75MNdETI79lkLjDfWChZvX/EiqKoER9Fz4b1+smsveZrsbLowKDGd73FSL992LIKP7PGzgjbkOnQ9Hdo1lCo7w4h+3+9/J3T3DDnluanmihkMrKt1lU9ZwmT8IeJsKn+1qJo527bvAIjENokTFO3akZvkNU86FQ29o1CRpufYm9UN/mZ9ZFshdtNIJBZvy/kW01+yvwr+LgGAir+T3N2QiRuWI9XDE+dscEVddj72fooda5mKqyjMQSn0iBfGfSn8l/WJ6zpt6yuRaguqvOq2jDKzgp9YT5lUnVAg+j3NOwmyvSf2AWPpfi3/N2vKfS+4ww1IdqCGUZGsOHUWzdVxK3M7lW+EaEG0tfe0DKdb8CbycSJDjSiJaUEO/V9F582Rg6K6rp2GEgoqEiIdmEMsbnP9MNfuBC8XX99aSfv7C0fpBmSb5dpDI0BJdAOU0NAamqV9rNthBlJm11zCDarqpbG3iRpUS4mkikeOSKtu6vKwHIO2siZUmDZ19k90tUPlEoOh092dE1KcSdAmRgqP6+ZJS0jJ7RoXtjkrRTtYljaxDapoeHYdoZyIK9iqjMDyj3QnOCHKDqtoTCEz80IbnVG7drg1lEOc6Fqf6tZUFZPOd5dfBpWW1sLKWGc2p496veyWiTlpySvh1REtT6Qqxm+UXAb79gQPh8gWQeFev76FJJSJrkIUcWS/mPGPuSvbQqwwBo3eOwdCNe53vq3/or3OB0DLVCMwZC/73eFILRFL9L76EndiD0RsrySMycKLyzb2d/pO6BsaodZgA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Feb 2026 10:41:50 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> > Hi everyone,
> > 
> > This fix landed upstream in v6.19-rc1:
> > 
> > commit f9e82f99b3771eef396dbf97e0f3c76e20af60dd
>
> > Author: Youngjun Park <youngjun.park@lge.com>
> > Date:   Thu Nov 27 19:03:02 2025 +0900
> > Subject: mm/swapfile: fix list iteration when next node is removed during discard
> > 
> > Looks like the commit being fixed is actually:
> > 
> > commit 9fb749cd15078c7bdc46e5d45c37493f83323e33

yup.  I've updated the changelog.


