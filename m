Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CEAC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4EC6B0099; Wed, 15 Jul 2026 12:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0077C6B009D; Wed, 15 Jul 2026 12:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12DD6B009E; Wed, 15 Jul 2026 12:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B14EC6B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:15:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 423091A0248
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:15:40 +0000 (UTC)
X-FDA: 84991511640.06.14AA223
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 935A1C000E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:15:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fTVMM911;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpE5mssH+9dA3LmavqIEEepCUILvXP29revEr3Jgrk4=;
	b=OH1CuLNkOBlfT/Nyv/sCyiKs/nkAGzfruEbfgXb30k32qEgcFeWIvm/mObjwhmoJQIQ8XS
	G22TXmd5dqstPwo4bGyXkuYJwJTP3lEHfBtvKcznuKIlAQ0mJbB+KwKTK+B6SU0Keo+d2q
	H7Juy/LEsrt6Y2Rmr8TO2eU9cIe/6Qs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=fTVMM911;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784132138;
	b=f8CVMWzY9MxMYW7zPTnJgxukRwULvZVkNW2OM6auE0Dnlto5obKw3SRqJgEReKe5dJYjok
	6VsTUBdRt96YEapT2yNmzJRHzqTtTH1KLgXGkUNRSdj+rEGr56I05dQH9dmpaEp9BYFvR+
	3d/eI2q7uIAiS2bLc8VmOSa+NeVsFKk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OpE5mssH+9dA3LmavqIEEepCUILvXP29revEr3Jgrk4=; b=fTVMM911R3k+nGguUUHdSctMHO
	qwfb9i2nf70P4szGKemXObVmACqxRYwMTEWoAYWhTdEdq+wA7xNQLsipikRxCyYmibSDdTeRL+dFs
	XH8ma8cfVk0cs699MLfvp44MmVSef8FnsWJK0ZczCMk0TG05jrTJG+SAMbKZbqvv4jiyRUyVY79th
	T4Eunv7nZr1dfG0eGoUwVblK1xlqUI/DrWyu7n76eLEhMRXcCRn+8VhORT74nzxqM31eVlupMTUzb
	VsJcF2nAI4UC/8tPxAzP6mIkpJIr7To5ksssO2V4inmwMSK7AA2T/P7uZgxyJhFyx7qyhfwNxfkIz
	+h4/e7EA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wk2Gh-003Am4-1V;
	Wed, 15 Jul 2026 16:15:31 +0000
Date: Wed, 15 Jul 2026 09:15:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: osalvador@suse.de, avid@kernel.org, linux-mm@kvack.org, 
	riel@surriel.com, Muchun Song <muchun.song@linux.dev>
Subject: Re: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <aleyArKTozc4ml5g@gmail.com>
References: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
 <alSyhslcItgtqSHT@gmail.com>
 <alYT8J9aRQDx_8pP@bender.morinfr.org>
 <alYZ7fso3zp3j3jv@gmail.com>
 <aleSDxoADBD0Qkb-@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aleSDxoADBD0Qkb-@bender.morinfr.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 935A1C000E
X-Stat-Signature: m6wbn54hqjdh98q9djd3or99grpcb8ue
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784132138-498099
X-HE-Meta: U2FsdGVkX18BPl9ltVdb4gE2l9YKfjn8W/vWBQDRyofdwgYOhSmARGIU9ipJApgvv8/onQPr0oqqshrgsNIGVXPMNCH+bY009tH8BmF34bBLZqPrlRtmUidQi9jp910+CVBjOvK5wBOjClLW8D7OF6P/DYU6HmLvVjHVfuHR5Pc9yDOL9NxTJ8x7yrYfzdts0lOiMgfxGt5wk3CfZtImSc8cfxSC5dIXDXbAVAePtGH3pBwC3qVGP9CXiaRnZlAK7QKt5erAGxUEQPmAH8C0hE1ftSZmEveP9vwXfDtopIZHO2FQAqdkkNpvf06/K3g5nYftk3vDdEty/qMV3kOTQj4jmjyRBxnHwY6jXlyBb7zbPbOyvMKSQdGjmnyxj5HAXNERqNaOsKKDGAdtl9ycycocXYJjzRLGbyW5yEiZ1m+RJxtEUPV16okLX3E7Iz6wbtVHAXHahaJGeIRjembP4OBwut6d/TrDlbsbti3eUpzNJaJ8wBdpxZjqF6k1Yac/iNuSvIVbq3ZzZ+Z606FSCPpBNojHD0qyhzqwHU1RsNflHgF/G6v59XLf9GLSAu7KItECq5qx4DMqYvtThqx1X5FiQRnFAwefb4Y8TtrH3RKRKwkdSVZY2m4yBpB4DDI3Zg1ntk3EXLqy7RAuQIj9fqW8Gia7KYMIFZTIuwcP2/e4Bio6PozRLFfjPTSP2KK2VIz+OrXKAcA09PZyn4naaY7aOeyaRNJfIc7XTbcex/tjqIxab/vhL029H7kvK0Lw0dTRFFwnhvnp7ccAXl2qAPnnDLcOFDVVkIgYUvU60jxzAaZWWdZnEVuCfKCoDTWrPGbSJXq20oItsZpYmfv2MH1+vYsNKdgoBSsRgjlOSwSkUIcgMU399HerNELLo/9H6xoY2Zf/3bLyrcOqQ4hP3UgG41Ucd4SwJ5PcdSaqktC2Tack6bfRsJJCCr5GzUG+2NEmcZ/4888LyHO7Zrt
 oSDjxCH+
 4GbmUm3SCaVpUkw2sswAdPdl0DxILhhFDhLFSkAUVJVVwtW5vQpDEpR5H4rTjcWCmgZGMruHj9u44OvBlyg+F052+VKVf1mTMiO/woJbLZMTVD5mBYi0nXRPXIVfCGv504dMPuJBatkNuvv/VHm9yI/+dTShInDBQsE+r1kVTBTOjOnfGbutpBM6m28bhx7XE/HyZ92vnVWo/IsFiiUl6ay2AF/AaWQMqoD9QYLrELxNf1htLbaB8sc6vhYVPcoJL+xfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 03:58:39PM +0200, Guillaume Morin wrote:
> Did you have the chance of looking at the selftest version of the repro?
> Should I spin up a patch for this as well?

I've skimmed over it, and it seems fine. please send it in a proper
patch and I will review it.

Thanks
--breno

