Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C4EEE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 22:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9358C6B0089; Fri,  6 Feb 2026 17:59:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3286B0092; Fri,  6 Feb 2026 17:59:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2146B0093; Fri,  6 Feb 2026 17:59:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB176B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 17:59:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1CFCC184A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:59:24 +0000 (UTC)
X-FDA: 84415549848.28.96CF15A
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf01.hostedemail.com (Postfix) with ESMTP id 38E4D4000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 22:59:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=YyzMC78p;
	spf=pass (imf01.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770418763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBeZ3QqeRRrFj81rm3Ls1gh3UuGDICwkpAl601siemc=;
	b=wwo0+49dHUc6uuzx9XsS0JpoqpcsT2E9WT+k/ulEm3lTSrtp4ZymtjtJGbx/SLCES4LTW8
	dFcZSjN+ZQYCamBbwt4m4Fs1o21hKLIf6vos9SpN0MFZJNiYGoE1BJptzIn+7XDmxKgLjB
	EIhWHYag+jkyLSCoZnByH1OyW/2bsvI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=YyzMC78p;
	spf=pass (imf01.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770418763; a=rsa-sha256;
	cv=none;
	b=o8rNJSC47QjfzwrFzPyHlScxMG0J5h1u3/S5C7OQdaOno+DjNWCqxHgkHt0cpEkBA2Qpnl
	vC0/NXNdunBMlg9+UNZ2ji/hGuVn6eVRf6o263pI92Ox7ujT+px6knC5ahzcSsRRe0ecp5
	kn0bJscZzmHlCTdXpeWQPlNVBqB1bz0=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 82B7340C3E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1770418761; bh=RBeZ3QqeRRrFj81rm3Ls1gh3UuGDICwkpAl601siemc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YyzMC78p4uc6xu28e8vgtoPqMypY5xFMnDOgvZXDtINjD9hAA9rSluQ6SejloPR2K
	 98OGQr1IUV7GV8jevu52Lir0ixlyqwnAtuBbeWnSaA06m6DlLPEsBi3ok3LtywF2+A
	 8Kp/8VySVkAaxf7CHWPdENjgQ6/m7rqIIvAMoGArlMY2xRkWr/nZWT9o6j3BFwPaRh
	 HiWuw3DbWsK65Sp+KPgli/VEa1ReWjIJk5GcpecJf749d7tjARBNTTYxmVkvd8SzHJ
	 37Sa+Y/eLzYj35c4UToHdvyD/Naxbs/7A9UjJ2cxphn80j8xlwOvcsQM0E2k15K15Z
	 lKKhUxJqLyIsg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 82B7340C3E;
	Fri,  6 Feb 2026 22:59:21 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Viacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com, slava@dubeyko.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] Machine Learning (ML) library in Linux kernel
In-Reply-To: <20260206191136.2609767-1-slava@dubeyko.com>
References: <20260206191136.2609767-1-slava@dubeyko.com>
Date: Fri, 06 Feb 2026 15:59:20 -0700
Message-ID: <87343deawn.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Stat-Signature: hjf369robd6rqqyyiud3jyjbzjrkoaoj
X-Rspamd-Queue-Id: 38E4D4000B
X-Rspam-User: 
X-HE-Tag: 1770418763-290391
X-HE-Meta: U2FsdGVkX1/EUF38HKdkwTfWTqE4w6rMfyxvn09a8tHeqnrUEKG4cKGQ0VBwbmDRHbJeW6oLkROwqXMW/vbBSrgx3d+aBs+ijoLIKuZjkocrS8lO0BPXJGNAFuAe1tzin+qJbXb0DL9C7Jp9/mBZwbJ0PlyFKHEMHMAV6Zrdvhx7oUbq0bU96D1AJBkVJ3SSPf64kpAQyi8kxG/qL5RG69aH+KaHat/UNTPeK5iwtcJ8zficIkFc98I0hq45n2ujQN6wBdKUpQLDiMrqmVTKTvu262g3L1dH0uHOeF+KoaEQxQMt2D/guNZrLr9gu6I+4p34Uh/McZTV7DvYOJ6Uia0DVB7qA0iIaVNbzQ3xvsve6T8Yah+yYWsSouVu3JzdiF9zHXLXgvh5Jex9q8uQTbkOwiGR04D5agXGC8laZZ7ocoLZhpjpGUioMaJI1lh+fTDD+lNAliKOWSPL3eh/iN3NMv/Y7pAow0hP1d01WyDBN4q32kMhVdsEvvWrTK4JizcshHprRYy3tWvJdUbPQy3gb+OpC0d03fjv8D/rylMFy3sB3PQOCaLdC32+kT6Rgz4EwzDkeDdKEF5oXz9TEFGqlzhXO227bVvEuiixsSUbLoSTXmPFFS9apojoSyuakGLrl3YrAelMLdi60mCmoPzLPmNIqklcsXy/Q3Uio0YkFZwrrMTHYOgolVST9K+9kmiFMb4Hpa3LGOZXoTfGWDrZ1LQIU6/MLMzmrker0zIg4tvx/3ptLBFbcWOorobmr/6LA+7x6ZpEjyeinQGvX0Xfo5Kz5XrWXGqGJKEM8y84ky5m9MvcmHQ3jBZM8k3+1BbgpFZjC4RmxzbIgencWE5qUmax+/KXA/T7L/FsBwKeNdOTsOmKl8VkSO5YlaDVu8GmD38bFUCN4nLKoQmyvnAvpjQ0D9QgjnoNYJ1tdPKQIGbzVeJHedleJ87hVuJ4onPRr45UsntbA1Uw6PK
 1PpZHFIm
 CeUTC20vJdc9L7lFDdJe1PUz+wZ5JWf0uttkd6avFVebjkNOrjrjpZoj3/gm4aA0amhQ2JVlvdOZJVkQhQvFDn3MRYQ1UXh45WYgF11FVyrnNYDGIeyv/BaBxu17OmeTVAz966sQVF5VaVlHX+cnjolqHLaKZ5j1aumjCafzitz+ukLMJPAKNFcLVm2XLRcVZn+H4s07LzG9zaST2Bk3/vV/N+BrzlZOrWncg1HmBPy2bgrumXmY7tozs1f2HSBDFUYbXiG+OQwu848atEqz9+P+GUbPIJKVXV/p5814/x4LvkZaUqVU0rKYlo/w/8hxldIOoWYdKwPVzRA5AlFXJxVB3J6FTeXiSbuz8kR8Gx9OF/aPN+uYpVwk4/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Viacheslav Dubeyko <slava@dubeyko.com> writes:

> This patchset introduces initial vision of Machine Learning (ML) library
> in Linux kernel. It is an effort to define the ML library API and
> to elaborate the way of running ML models in Linux kernel.

I went looking for the documentation files ... but then I've always been
known as an optimist.  That would be a nice thing to fill in.

Perhaps more important, though, would be a real user for this facility.
You must certainly have one in mind, can we see it to get a sense for
how this library is meant to be used?

Thanks,

jon

