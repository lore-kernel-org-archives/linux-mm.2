Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CDED11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 11:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0F36B0026; Thu, 27 Nov 2025 06:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098CC6B0028; Thu, 27 Nov 2025 06:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F175E6B002A; Thu, 27 Nov 2025 06:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C6D6B0026
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:12:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 614228A833
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:12:22 +0000 (UTC)
X-FDA: 84156123324.18.E732CFC
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id C135D140007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 11:12:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LXBPzZV0
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764241940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2lrLpSRcHNo+/6QyI3Yf/wIv62AmlzJCb3KPciCVus=;
	b=MO+0+jG9p4evEEZWnOtGjeod8SrLG43exuo+ak7ILD2yiyHnwrHOoLRmygiFXFYTst2m8T
	j2Q3CDROKnRi8eMZsM7Hx46UwH2opdwJESq3RZjTbJJs59SFsodlJ0E/dTVU9HhO5sTftt
	moKIT+OdRfpl3RjfuVSpdsnbRfIWfCY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LXBPzZV0;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764241940; a=rsa-sha256;
	cv=none;
	b=kXp935T965ompX/lDBMttdn9WqiT26FhIhEx8MLisw5zC3LnpRctDQSGpOcm1P12E5QUXG
	UPPJjUtPDYW4h6z7uGreZZht13T3sDQXUFYYT0CERrMolxPVBQP/5gJhZDQnfyvHPTrtnu
	tSb4GI/rgX8T0NbowG7pqV4Gpc55Xg4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t2lrLpSRcHNo+/6QyI3Yf/wIv62AmlzJCb3KPciCVus=; b=LXBPzZV0dYoWZBXITQoynLOeTW
	jyzsqaFRYOnArMHj6rGW863hCh1g2mhaAcVvuHTYgFCfhrJMZdlHFJkxyjLib0DtLmd2JcdYphlW6
	/yFViSeHKLrCaOKBTXCuIiKamAFTnsdKPFRrFsOFZxogfw4u983n8tM/vQm9h8VV2euOnBxZQ/p2j
	0CjgeMvoMmIT+uvcgM3ueLuT68vmw8kYnSgVhqPtVrwT/tyFYPqH7O69H87ddeudJI9UWv1n0zo3W
	oCROy9u/eXyNJo/Z4x1as1Dc6YnCyxwlPvAhAN4wI+EiZY6X0taaa2fPqAcfy3hmzwM59AL9XWMOx
	GxyYEV2A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vOZv4-004zti-U0; Thu, 27 Nov 2025 11:12:15 +0000
Date: Thu, 27 Nov 2025 03:12:10 -0800
From: Breno Leitao <leitao@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kfence: add reboot notifier to disable KFENCE on
 shutdown
Message-ID: <nqzny5rxn27exzhfzaaxg4tfbshhmr5aum76ygficd46b54c4r@tqrelxeucsti>
References: <20251126-kfence-v1-1-5a6e1d7c681c@debian.org>
 <20251126101453.3ba9b3184aa6dd3c718287e6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126101453.3ba9b3184aa6dd3c718287e6@linux-foundation.org>
X-Debian-User: leitao
X-Stat-Signature: tgu945rqz41namhcc3ak9if7415tfa8u
X-Rspam-User: 
X-Rspamd-Queue-Id: C135D140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764241940-438211
X-HE-Meta: U2FsdGVkX184w+cYlMNSZSno1NvE4Rumx/hO6RSL3egUCSWIBU411PLfUFg7qA0amPNs8zCIL1k970n4db1TBDB1gLWDOhGz2uAQ+pTxzDyKsKi5WwGdJSoyJpE9FLQTlqv5PGKgubtLkr7Lhrry7MNLFH8Mpey4U3+kOadnWWRQ64VAT6yjnsI6GYM9vA6Dn23RjjIe2Za0aUC/SJF4M5NIuxdxROf5WVI7ZROp2quke3QUbsyHd8d8cXqpLiHCqMmFsDRyHlNYq0qRer/WD5E+26Rf6AiUqPO4/5MTQ6TObTgxsA5XdEEiZ1UEMPX7IkZuY0YcxziTrYoizxnnwejXZvIw5Yg4oxznhdFO6Ry3YinCWnRenj0kjOKvjwCn4u5Ynrw6mI40KAHy4h8e8aGcGk2HmMwdiMUJHrwnHWIdVXUcRZfqAbv4l3BWzjy/dUcT+R9CaQ1V1C+2OShN25ejW1Sqhv59mY2p/X3oxZXYGYwTIjMLJ19X3UmAzZUp8UrutN/8MwRSVzElbH1H8p0OHsfJR5xluO+NBjiD/om0pqPPt7VpqoYFOduvFbGJJl6aC6Tt3qATF9RMhkvZkkQGkNVlyqYoEK3D19So2aC5SGzw10yJkjmAptuqszcSM/H5XGCApGS0ut052kZwKoUmju4vMHv75/laCw57ESFo66DeQu4hC9zhY+iP9ROc60MGpZpoOPhN1VHrkqQgAxrCC3uCDH6NXkHnN4z+geyQSq3Z6kPBBJBtyFITgn7LXeYMLIWs1B67HUdorWfSpNy5E1ENrh0UxEyc7tRlocFntXhFaL9M3aA7CKecLnaZeIyrQylOnqLO/DUmmOBCFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 10:14:53AM -0800, Andrew Morton wrote:
> On Wed, 26 Nov 2025 09:46:18 -0800 Breno Leitao <leitao@debian.org> wrote:
> 
> > During system shutdown, KFENCE can cause IPI synchronization issues if
> > it remains active through the reboot process. To prevent this, register
> > a reboot notifier that disables KFENCE and cancels any pending timer
> > work early in the shutdown sequence.
> > 
> > This is only necessary when CONFIG_KFENCE_STATIC_KEYS is enabled, as
> > this configuration sends IPIs that can interfere with shutdown. Without
> > static keys, no IPIs are generated and KFENCE can safely remain active.
> > 
> > The notifier uses maximum priority (INT_MAX) to ensure KFENCE shuts
> > down before other subsystems that might still depend on stable memory
> > allocation behavior.
> > 
> > This fixes a late kexec CSD lockup[1] when kfence is trying to IPI a CPU
> > that is busy in a IRQ-disabled context printing characters to the
> > console.
> > 
> > Link: https://lore.kernel.org/all/sqwajvt7utnt463tzxgwu2yctyn5m6bjwrslsnupfexeml6hkd@v6sqmpbu3vvu/ [1]
> 
> 6.13 kernels and earlier, so I assume we'll want a cc:stable on this. 
> And I assume there's really no identifiable Fixes: target.

This infrastructure showed up when kfence was created, so, a possible
Fixes: target would point to commit 0ce20dd84089  ("mm: add Kernel
Electric-Fence infrastructure")

