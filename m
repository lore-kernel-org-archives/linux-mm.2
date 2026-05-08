Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E497BCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 17:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3230D6B020D; Fri,  8 May 2026 13:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABFF6B020F; Fri,  8 May 2026 13:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2246B0213; Fri,  8 May 2026 13:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07E0A6B020D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 13:29:52 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA9B6A0164
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:29:51 +0000 (UTC)
X-FDA: 84744940182.09.CC9F7AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 334AD4000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:29:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fn8xnnaC;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778261390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hgJzk3vF23ZZ+tZ/Bfgh1CArlY8QNKdQUaetulCmg0=;
	b=JUCIq2V0YqxVjTEBoqBewQwX7WraH8PeBmhDSJRF978zepK5yQNT+bmhSNX1pb3tzTZuJT
	w4xBRnxFP65uV7+N1jhk3kM3BBx7OSDx+7N+boRXbDL/Nynkp60pbtE3PS8SaEHMzjaby8
	kUpWjHgaizjcuQC8+OW9aYM7XAYEzOA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778261390; a=rsa-sha256;
	cv=none;
	b=4u2R67HhutluB+XldvydH2MFzjNmRwOwXkK8+aTYPNSx0Hoi8ao6f3rH5qtHxxfGZfyXhn
	fS6ByauonEB9EKpu+fg52+0Wm2a4yqwT88qbbuMG9wCK0cbKd6XBukxQeeE3D8XRE0i8hw
	GLtmGV12FJdV147nfGd7i0NhHB47Zsc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Fn8xnnaC;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C69E6024D;
	Fri,  8 May 2026 17:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27E9C2BCB0;
	Fri,  8 May 2026 17:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778261389;
	bh=WImkrdfZDvCww9DRBeXh2LQGC9Ksn9raoEsYh8zM9y4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Fn8xnnaCWaF0vyPtBMo2X4/gXck247qHSFTKsAYHkaVbw0FUqJrs7SKseePgrdVcW
	 4v7BaTGoqZG05LRaPKk+Fzer0c4BuQMx9wfQ1lnjGp9PlyPpcZS6kvU1ff/Jo2ECj/
	 Wr+L1i/SDWv9cDbNP+2TI7WWnqmusfdrW2LgNd9g=
Date: Fri, 8 May 2026 10:29:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: hawk@kernel.org
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock
 acquisitions
Message-Id: <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
In-Reply-To: <20260508162207.3315781-1-hawk@kernel.org>
References: <20260508162207.3315781-1-hawk@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 334AD4000F
X-Stat-Signature: rnq8g8bjgcsks9cwsc65bbo3g1bge7a3
X-Rspam-User: 
X-HE-Tag: 1778261390-696760
X-HE-Meta: U2FsdGVkX18PPP4xVSkhblo1aupTBJLPuu4UZjGdKJlqXRZ3DhfraAMndk+sX5eFct8wCgy/i3YgrVgOQZ1o92YXGpscsHkseFLmPuBkDWCMQli/oNA4lIsuwsFWXd/qfP6WvmxbN+lQI8xr9W5SngAeSaaS8meG6XmgzHCEIc+qqwZKqbscrivrlOHmhz3loePrm036J7lCk0ZFMvvK7OKLBbpk7vkXS18Y3AvWg9/O7ii15XeoWWFPeMnf2/XKxdmY62HYXgCG+J66wSwdWS0CjGetOZ5RUTl4jrxp4fnOIECDuJxmJKhPxl+2so3yhHqW/GNS96PJM0OIw1KaZjorWG671PP35ml0YpUVwmIkWhIeawKGo1L5RPgW9i//brnQDK7XV4UM1rdEoTODgMsH2QxdS4G+b6jfa1wLMg0jac21GHHeVVzXwvT/Y5kggTs9u0Odk1nb1t+bPZREqi9cG4wZkN5or9VsIt7XPQvQKSue9AkMNn1Qfrvk0IlhNni9OQ3b18NcWZY0OMtx6fL7U3qeB+XCxfUFUcqG7C3yxSvsr97qbiiHg3DcNIgIAKdgTZFnhjZGzCnNefmH5zy+UNtz4l85NMXN9IQPbSdHuAFHEjY1uKfuP7O6uPW30wQLr+b4Kch8UfcFwrF1RH+bkW6manCCz1qN3qBv7ij66mt7BeXDELm08TvdYqBc1uUufENd5RRdhVA+nAh/t/UfConOEnIqi5ZhNsBfjuUIjJ9pxTItWKplWruhuYL/DSpKzjfvQwvFzkGuSa4dCo6XIbiBnssbQY46B6DrDY0Zc+UE25CqVNFeguUcZO6QDYWA7sPG2YOu9CqIp9J9b2YLVBvDYMfwvRyFlwVf9eAOT1TNiaW/E1neU4GR9Ac0ibjKaEkbs1rL4BnxGbfd7g4jr+SJw+vN7VTeG9cwRpodZpYQqujZ8bBxV//EHt57+2suVg3/gyKHb5ogLQ0
 N7JHGWW8
 Pmheiq34uQXnTlPNO3ppUwbUFMaxAUh5LFgsiQDXxWeAHrwQLLqqKyF34ZtMINAnyFgaIz3X+z2W0rt0rf7P+W2Tqpix7TAk5rTaF6cJtnWUpppcwrf0oVvj0gKRA+LmtRWB9NGpyQ0hCYDsnosvwAM22el0UYI5KZqhlPrHgeT76QGyjXIJyDEXjExw7bqz1hJPaYsxg6Pfre6K/RJQTXuaptiWYx9+fPpqZyUkV79wdLwFgC4NigkKcOcE/KXyXDE7A/BkUCDySoWOm2pDcM+1cdDZ0BUwT9wMxuH+JViAZDOTeNhNG3a4bceB9XIDAkzVFir9s1xeSwcJIwICy3KberdybLgUD+QHr8GIOpLdJaNiJZc+msMmeYrEgpZZbuVHo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

e .configOn Fri,  8 May 2026 18:22:06 +0200 hawk@kernel.org wrote:

> Add tracepoints to the page allocator fast paths that acquire
> zone->lock, allowing diagnosis of lock contention in production.

Thanks, I'm surprised we haven't done this yet.

Unfortunately "mm: use spinlock guards for zone lock" messed this up
(https://lore.kernel.org/all/cover.1777462630.git.d@ilvokhin.com/).

So please let's give it a few days for reviewers to comment then redo
against mm.git's mm-unstable branch?

