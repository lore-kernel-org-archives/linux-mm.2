Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6AF606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XQCi86sA
Received: by kanga.kvack.org (Postfix)
	id 319656B08F9; Wed, 25 Nov 2026 00:57:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0A66B08FB; Wed, 25 Nov 2026 00:57:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E246B08FC; Wed, 25 Nov 2026 00:57:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9FF6B08F9
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:57:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35A51160D2F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:57:34 +0000 (UTC)
X-FDA: 85472584428.01.AABABA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DA4BC0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:57:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XQCi86sA;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795586252;
	b=Vi8aUXwcWWl4DsLtxwEqoCObdXxQ12QW+0QT4UFleo9zlgqDxLJ0nDKDfm99bUDC7SI08Y
	1PeLKkHkLBW26A5x2S+CNxz7NJThSjZho5udaBjbTgP6TcVk49Ps47phsQXz95JzFD3HSn
	x5ZhTJnAxRQlqbJPtEQUTNMh65x+cCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795586252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q968GSmLkmv+FRzp/+spwBiGX/qP9XmBOTNq6DpuJYg=;
	b=VPDSuGVHPbszj7iCOyYFDvglyWNuHv7coMrtYdfFgzQuZdcNr8zvc+dLeV3Fqjc2GeuAya
	3dzym9G/8fTYinXv9tjlBJuejHoz49h2Vkq0kgo3gdvzwS1zgLLkqNLpwIRUJfesmLaWWQ
	x91ApUnFx4dR+TWvAyID5KM0EZ+RqXE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XQCi86sA;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EBB6160200;
	Wed, 25 Nov 2026 05:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346311F000CA;
	Wed, 25 Nov 2026 05:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586251;
	bh=Q968GSmLkmv+FRzp/+spwBiGX/qP9XmBOTNq6DpuJYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XQCi86sAgGzkBEUTgWvt9P+rymD0u1n2NdNMxGWGoxWa+/SGUY1C7ynI+cTzFKIK8
	 x+gE5Drk1jIG59j0Qzr6RXHZYQbq33RUPUTAZmT4H8j8U9eScNpHS+gCtlDIuKS+VA
	 6wb5E1W52NjPMsnVYVFmhVukyYutxW0GSDhjMsHk=
Date: Tue, 24 Nov 2026 21:57:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, Zenghui Yu <zenghui.yu@linux.dev>,
 linux-mm@kvack.org, jgg@ziepe.ca, leon@kernel.org, david@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com
Subject: Re: [PATCH] selftests/mm: hmm: give migrate_remap_fault a longer
 timeout
Message-Id: <20261124215730.0f6adc9ad36c7abc623a1dde@linux-foundation.org>
In-Reply-To: <awZ2S5yZXOHIxBxm@parvat>
References: <20261119133955.54001-1-zenghui.yu@linux.dev>
	<av94SXo6ZAU7Z5TR@nvdebian.thelocal>
	<20261124213730.a8b4f5100785a2cde54fa8b4@linux-foundation.org>
	<awZ2S5yZXOHIxBxm@parvat>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 6DA4BC0003
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ejm7wefh7ftwfhcuq1fwyuu9eiq8ft58
X-HE-Tag: 1795586252-464210
X-HE-Meta: U2FsdGVkX19wFJk3vKE90AdTflRAmHazKjCdiddV3ZeFQmUvHhkcHxX6JXfqka6ytQSk5LXTEj3Mq/BEVEu1if6sYaCHfvJQcvjaqW2OTpkF9u7GIO2vNw+j5CBZjIAE7d8w9wNxjniVesnQnHZ4LwNeoPPte6SwzYJSMK6SA4ozjypRqka8Cel0ydjjXR8j6QXTn/Qqztdfp/lmWl36eFsyPUOU4+pvK9uG6gRDtFTEzYmvd7PJLk63M6DlIDwox0r9eVgTB4B3qlG+pQUFQcjftESY4W2fwPEI0R+kVY8Dpxoms4BC1u36OOHkElFCxKwRx+zy2rBzvpsbkLZ8gwxhST3JAo+7K0wu7+Bx1vILTaGi4R15RfAYsdGhNrTBbwI2p4X5rDVpH9Kq0Ql1CL0s2kUuH+UQOJ4+EqmxQA+/CYyUBGJJbbse5190VnAI/1SOapSpRYtoB5wX52dJHUaKzrRXeXwApI1+laZ9TamKd1qxQfasvIJXLhoFQ6ynhlyseqY0+8oPxwUg94HyYll0Nwu+4WirsbtplQQkOxqmz9XbsITM+5KhZC9G6FikbsuDOrdl4PBr2sgvfizOq9W+Ezo386ot+Urk4fvxSsU8vBBsVP/oCeODUE2HickI5M5z1gmVx9uKXycntTuxuuiyUxrHF1AHjOu0P3fuIr4RTD6A899yct9Xgj4zdnG0ojJzl7hJM4oz6ZwDtOAXGbwhmBjQ4+IIni3G2mLMgIi3LCiDnxKFMuz7cqvaMHTLgSQ5dtyEFMgh+wbF2ObVBW0SXxhv6QM0jUl0Mp859oCZOFonoFF0PJ41fRqpUulGrrQdUaz/q3fE7pfI/2ighuAkhaNDwU/8C10gnUZ2oR8Tcz/gfjooH7byXrOtq9va6Nubdb1+dDXqXgOcbI1V//64X5PB2VdOivJn2+9bm1rWMFnP9DxuuK5GBqfSqmg1TLrCueZCULi+V1mTceg
 Or2OsMgP
 sAy3dp4994T51qA1dVwAxjjxLue76BAMWE7ejNR6c+6ygGYS7Y6NZqakjtBsVaAgckJZ0KJL7rNVrMnoWinuYXABUPVxD4PJUmFxLptUk61fD5WMhNnBMcBDOY8M6z4qZPBxJNwltzHRP10qwOq2OtoZ7WACcUcZzLe1bgfNCqs+Qq9Yx9e467iZnadaRwW7nzFr+iGAq+rY9/dgh2arxRo2SekB8td9hXjK+DdI50N+Hy7CCfmNrH0Wq3vfkwyiWUQMe9pbG+7pxs2IFxvER0ZIN60L59OWneQs50YIVVMShutqwuaKcUBid1txqrXI4r3+GMu6t3MXqicql28TaInp8e0jPZFwRLGbqo5NRBa/jiRtS6SVytN4XshNpXWpc8ClskFcl6KCV2rAeH/woVIQC372JLSdtlp38EMtTwx6Sp0EpwiimD9xCDhU8yKrcljtMgwTYr7M1gFfKkNXIeyYI9BuJjUaHAnB2HL/JO+d+wHf9WRgmKMp/k1iI2wAipMc5M1Vb4gXwyMGIR71W4FrCjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 25 Nov 2026 16:50:33 +1100 Balbir Singh <balbirs@nvidia.com> wrote:

> > Zenghui, are you able to figure out some way of speeding up hmm-tests.c
> > to avoid the timeout without compromising test coverage too much?
> >
> 
> That's the delicate balance.

I think we should have tools/testing/stress-tests and
tools/testing/performance-tests.  Without those things, everything gets
put into selftests/.

> The changes below look reasonable. I can
> move the perf testing out of hmm_tests into a separate test or trim the
> sizes to smaller set of huge page sizes

Great, thanks.

