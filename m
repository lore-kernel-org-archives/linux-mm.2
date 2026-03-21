Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C040B1099B58
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 01:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D729F6B00A7; Fri, 20 Mar 2026 21:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4A866B00BC; Fri, 20 Mar 2026 21:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87826B00BD; Fri, 20 Mar 2026 21:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5EE26B00A7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:23:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDE528BA2B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:23:55 +0000 (UTC)
X-FDA: 84568323630.11.E00F37A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 345C440009
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:23:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KYI1iLRk;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774056234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jB3wVb8b41+AhY+FGn1IfBV7nGIdJUQVJNEPUCsiQs=;
	b=DsBr9EQR/uS9zBeOGFe7D41Ta7jkgkJmg1pKWMWksAi4bHHv73CBthyKsLDR0KHUDHjC+N
	CRTfY0deKnJuq2zO8w6vF9HjsOoGN9WACxYYJppL0z61Ly05cvdYN0vv/QlPO3P/IxiSHK
	pHoaEOSDSM05a6+w0DYQsHqiSUXm2WQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KYI1iLRk;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774056234; a=rsa-sha256;
	cv=none;
	b=O7b8qawxCNHuQrnJO8yv+pnUlMENTrkdOwe93rdWkXlER13KcjYEan8ONCbd+eSVIrvZnA
	t/2hPJP1Dj7MjFvLkHp9U/GRQN+3tDUcfDRjyNuk1knkz/GIduLBR0dZPoBgAe2J6KoTon
	ugykvHG9yLzyTJ3WyOsdnJhGSVqYAdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2A4F445A0;
	Sat, 21 Mar 2026 01:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF70C4CEF7;
	Sat, 21 Mar 2026 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774056232;
	bh=rnrB+r9upjuRc+mL3xjhUHiIFwtv9f3pu+ODqRoiEwk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KYI1iLRkjpOcMtcGWhWI/CIiVv3M0XEkmgOw+PNHtt+ULqlxzMo4WftpXVrrKPtYj
	 FqeLjp7rFmN+uPb6hqwOrQL5pzJpVL9JO9Qf48H1JHtkM31dPeMvjRqReZmBRp50jx
	 CgIIj80gZKOAnJnSwrCytPR64i6NrAp4ucIDozrE=
Date: Fri, 20 Mar 2026 18:23:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport
 <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, Pratyush Yadav
 <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/5] liveupdate: block outgoing session updates during
 reboot
Message-Id: <20260320182352.ca6c88e409ff12d0368b03ae@linux-foundation.org>
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
References: <20260320163720.100456-1-oskar@gerlicz.space>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 345C440009
X-Rspamd-Server: rspam07
X-Stat-Signature: a5tefxy4j4xp8xuycfwzjp61ptdt4die
X-Rspam-User: 
X-HE-Tag: 1774056233-740413
X-HE-Meta: U2FsdGVkX1+a/+bTwWWqx78ZMPfrxn0uJ2I8eQwM6hmts+lRZ+ERQzrgjB1FvJ0M6y+ZywQPQh1EzjT+Djty7wQ7wPlso/Xi0n2YGKh7kdKXxqM+Y+HIQWf6tCb1Lo1LeXLLZNLVlfK8w5SuWBD/jwDbJVn7DpKixJ5+LKVxCQ+/yW5dq5kQinwlgkbHLeZJbLXE6P2xxcv8IV3vMPnXPTfMpRv8oykFkcgsV1z/Vus6ojK5cP1YAMoKGb+t3gWOkSu50s4VTHV0+jwTDgJS0GK8zfa4iuUTeN2x9q5q7LPk4/IG08lTBTn9USohnQI66qPeLVJrVsAbR7bt1VWs60I1YrnWOZk6Df008RCbfuLpQuTVOCB4JZbXFQWO2yp4uU1HIE7M7QqAQ1J0pdQrzHyLdkW32KY/bcK4TI3XNBj7FS0rtEefE6mPbL3MHHlBnpbflBYnhiZ9Gqk74Y44joBnlHWlzqjZoabAJU143hktQ0Kjl0rCVxAyoirQKiHaU9OhEjQhZRG2uW5GgW3YVoZgaJB9dL5LYf4qKI8uD6rNKhTGTUAtEnmRKr5RJfSjqz/LhMIr1lVunFD9+FN0Zs4AedusZRJBZkcaRSBqMbcoyq0nGPV71hZeL78xdtM9KHoEWAA4ZuOH4xaLv8Ze1h+wLOG7lXIp8SpiT4aZJKnbgoCJ6dYDJwGkeQyqsXXSrIQ5VEcMsllcMpw/TPaFNJOUGel+v2vyI9Dk0ZVhMm3LhszklxYefkkLNQZBZnK84A4RDas+jhaO6+62jl4MpAeXS8c+RwBLJyB0gSEZwyvXk6b3BwV09f06kZhWCSaQ4QuYE8DK29fy8yFeqXES/CSEaOrWMiXnooohVTSpshdhGTW1xp/X83n9A4JNqgN878dztQhGfzpNT6ylxLrRoWD5lL+uAIEjo1ANjKRX43JBORC6lVox4SGHlQ1udAmeRdZbidgbQ+qFtrNN6wu
 OI2kpXbr
 G51kazNVqBNS0LB5U7twVYuUfEGqHU+BKHcpobcf8hw6RUlj+z2GBIEs0T35QR00jqwOcx18AFHBkFAr35vy0/3klmQRdbkjCAn87u0gUIBI27omy6EXwT0eGD0B0tTC4BM1UKfui9s5XFmxUPa6+2fbAzRIz/eIWtnb21bn6P/JvwJdVCz7Q+ZzxMDTYHUXBAlF0vwU5NO4wPrdM2UsPB6dF/fKncyKJKMaDeVGVClM2rSWVYzbinKsN07Sz8TmmEaGgNbZVBCBtXAmy5NMeG9A4gEHh6LuqNFUU8PIfA5UmWVVFujgjHv2SY29JBUUsRkahzOwFptkG+ws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 17:37:16 +0100 Oskar Gerlicz Kowalczuk <oskar@gerlicz.space> wrote:

> When kernel_kexec() starts a live update handover, LUO serializes
> outgoing sessions before the reboot path freezes tasks or shuts
> devices down. That leaves a window where close() and
> LIVEUPDATE_SESSION_PRESERVE_FD can still mutate an existing outgoing
> session after luo_session_serialize() has already captured it.
> 
> The race is dangerous because the next kernel may inherit stale file
> metadata or references to memory that userspace has already
> unpreserved. That breaks handover consistency and can later trigger
> restore failures on already torn down state.
> 
> Mark the outgoing session set as rebooting while serialization is in
> progress, reject new mutations with -EBUSY, and make release wait
> until rebooting finishes before unpreserving files. Reset the flag and
> wake waiters when serialization rolls back, and use READ_ONCE() and
> WRITE_ONCE() so the state is visible across CPUs.

Sashiko AI review has quite a few questions:
	https://sashiko.dev/#/patchset/20260320163720.100456-1-oskar@gerlicz.space

