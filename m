Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDC6CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AC96B009E; Mon, 25 May 2026 22:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BE36B009F; Mon, 25 May 2026 22:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321C76B00A1; Mon, 25 May 2026 22:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205706B009E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:35:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4DE5160E88
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:35:15 +0000 (UTC)
X-FDA: 84808004190.26.D9B26EA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id 47E6980011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:35:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="eLzw/QYn";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4dD+8LEduyXVpGhWEf1ps9qWelIM8St2vWZ5S4kbJY=;
	b=mVnF0KmDyfJEjsZ5QynOcKStrbWuFChBzQ4B+7HwWvqAV87Ksj0y7jW2j3w20Q2ZS8NRPd
	PS+jRkozVndY8tKH9hHfKyKtMuJEpcdkVbdUsIcie20+7ecS92FLuQUxCDyIKaw9DqJna5
	7EDgRCusgp0e0vBTwjJWnPPxuCKsZBA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="eLzw/QYn";
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762914; a=rsa-sha256;
	cv=none;
	b=zOzOY845wsACzlpfUg8nOmYcb0X91333ErGPpsXkTJigl9q8GC2zg/N+peJq0C/e713QZ2
	39CnbEFvgpZQmMwKpLVrPaY8dhOC/chygq9HrHz3xWQ2U6wEa6beZOQV/EsAvHX1txyDPa
	kfm5TYsuRGV7rCxoi0Y0MQBufDaOh0I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D4dD+8LEduyXVpGhWEf1ps9qWelIM8St2vWZ5S4kbJY=; b=eLzw/QYnYKRLpwb1HtjkmB49gg
	79llPF4Rp2oo/ORPrTJf1wdsRVK9y+gEym/90lmbGVl0hVBTWAVlznrPuCCq6lqb761iOT6PzSQa+
	lHRxIH5A3E90q8ZlWu8dmgw2j/rrqe9qN36OHf/QTDdcHCUj6wa3ORgJ1Ci3uVrCG3pqB/SjeDJTq
	dzYOnrS2GY+UMY9yrNe6KfY9e+x3smQJwUM5bDzukPyivYUtmHALfIsAlq5CBp0/SwjYterNTJZ6f
	fbJyGrAhlaegMFsv7ZHuVO8pnKafkyNOcC03PK+Rv5lMLUEzXNcviI2hdf/0+tJi6DxJr7S+VNIv8
	Ym0BEBJg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRhdN-00000000WZ7-3iEx;
	Tue, 26 May 2026 02:35:10 +0000
Date: Tue, 26 May 2026 03:35:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahUG3ZCnc1RQ0EL_@casper.infradead.org>
References: <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahTzHyHBL8t0iNBR@google.com>
X-Stat-Signature: r8rns9sdj98adn8ery59xhfdua1zbo1e
X-Rspamd-Queue-Id: 47E6980011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779762914-176225
X-HE-Meta: U2FsdGVkX1+fVv4WwP6NFbUfpdAlg1MC2iHftEcfpC8c4A2uN71VIWtyTaDwKVwvhuIcrP1M6oCqWbzu951lsE0gePS4iazuWhCgNjwXpeEHER0TE2eBVt8kxBhO5Pm5cAz2EHVRPHneb6nRG+t3+uVBNx/O35aE+qXQ5trY16rA+2JsSfOFktc5rkqOssG4rgDMmXejoJGSxsQ9yJTUJ8/mZ7X+0ButOxU2cPaZw1EmayCAmMJUnAlQIcBlYpOKRvCX7LLo39/8RVlF6gcR665WTOsFFO9Luv8kf8RNgBIZl9Up2cGRkW/+LoyoeFYjg4iMPLSTDleKk6seLLRbUObzwG3EPfyMXy3KXV212HkXNR2So5zDt9VLUQ5axSDBsjD877Cr2FY47vuowTZ+fDjQtUqCJOUeNIv1qcAxM3R/Xy1mfSow3e/IIYJNOxUfgl1yZPiJH+Bx/m5BW+NiVl65FpdPKFbau/AxaY0LTwik/++gwvjPvXU3rIdIM2RCLcZ1mBRT05/V3PMT9E9bGS6pToIJqFdbQuLvOyAKqbNYJQwSJ8F4CwEeaxJKojxcvD8JWKEPSPoSuSw8iTfzYLjrMPSsseZeCnNS4Ea7AovsoCTrET2Ol1FUN4hYCjlBDA2Qn0EL5fjpDws8Xgwvk9uWmFfqHy7oHK+ubbk+qR68jPv2ZFsig61mQSKzZo9lWbpvE9NBYpvnzF6H0i6gNNmhebwQg/LQuQaDp6+pTyFJIbRM9Tk9wd9xX6RlGoAw9AqAxPMQzmI0R9g1HYvx6gcDlisy5cFElmdcQu84cBQh1L6wu6lR0kZ5vnf8EMK3hd81uhzowy5UwMywQExRIR53KA8SfvJHgBKHXiCc/q/lsyqDk+LmaW7UYzu0dMlzxNnNXRFm7tlbhOeCkcAI5zuvNAmk8WBrkLLnF0b2zmVKJdYkUwXG+X8ESWZJdTHJR/NMd2pcWt3O1MgizCP
 Xm1Uw7fX
 SGztA5C9Iz/SAh7gCEzAZ0IV0p319Z8j3x7SgxKuKCfE6raJaLp5X27i4WzA1NGupUjW9KV4d6skvSQCSnVf9iMiXkpje8XJkagd5ifrmMQ02Ptla17R7EGAeSmkCnAejg33bXyGtMmztM9t5bvmVokWOp643srVCat+TsMeMn1lvHGTqoq+8LjlTAUy4dv1Br3SD5sFSSWIfHfXaCFBOYqSrygbL1SHN3yDdB4Sr3/Q/ItOJ75LhfRHJuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:10:55AM +0000, Jaegeuk Kim wrote:
> Let me try to write more details, helped with Gemini.

This is garbage, and frankly disrespectful.  I'm not going to argue with
your AI bot.

