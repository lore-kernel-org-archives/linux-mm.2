Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6249606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RU2cjMWh
Received: by kanga.kvack.org (Postfix)
	id D2B206B00EF; Tue, 10 Nov 2026 16:58:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB976B05B0; Tue, 10 Nov 2026 16:58:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B556B05BA; Tue, 10 Nov 2026 16:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9366B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:58:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E52A2140128
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:58:07 +0000 (UTC)
X-FDA: 85420573014.29.83E2981
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 565062000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:58:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RU2cjMWh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794347886;
	b=JGeCbNvAh1FXjfNXbxRraaBhD5975+knazLtfHSVhFgMtfzRVZwrn/PFGSDaFAfoFFMo3m
	PE+ezuTPpr26K62ztxAsUv2dIK7uyRv0zmxPO7M9TOyzhPCpxvKmM3EBN14TUUFg6YEo74
	3a9mON9SPEs0jfk72z7sSpD8k66B7So=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCLtDsSduJN5lzJAUixPHHYwKmpqQ8jqEr8sEL58PF4=;
	b=NIZs9hAFJU5Haeh5ioAzZe/05Rd7DDPhpnzplJgsjZEA5xzHobogGdsBJyhjwJ2za4rG6d
	Vc3Oe18ICEIGyGsx33Uw9HsIhk8SEVXbsVwrKTyntu/Ao/yYfBDgd2cCyCvko/VLM9Cci/
	qsVqvq2L7qKig9aFeB7bhP0MRS+M3yQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RU2cjMWh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC28160546;
	Tue, 10 Nov 2026 21:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35C91F0089F;
	Tue, 10 Nov 2026 21:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347885;
	bh=kCLtDsSduJN5lzJAUixPHHYwKmpqQ8jqEr8sEL58PF4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RU2cjMWhLWTMYaymg1ZzNblHwkcH4bTSYnInlSJSLxQsbLjC6we9+twDh/aNKBpa4
	 ZOKhki2iaWRw0swT0pifRUi3rxOXErfR7rClmPQEWk31ubc+5+qXPLLxH13EM0akS6
	 0ZWYESXcdj7/o5BNONbMOR2vOWEz13IA8pdcE75+hgsg7BgI5AeW2dRxttIvda4X6j
	 J+6ShQT7+OblzOw2TgJHbu68zmtNalFHLGuAc4d8x00CSXbWGAs9iRbgDbZMC8z7LO
	 YGPMXyraW5fb57oy5qxA1F0oSNcFfbE9f48qSfbZOj8UrmeiMqncEm2Hj0LIvZK+0g
	 FMQPrk4s2OT9Q==
Date: Tue, 10 Nov 2026 22:58:00 +0100
From: Christian Brauner <brauner@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	linux-mtd@lists.infradead.org, dsterba@suse.cz, tytso@mit.edu, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v2 02/34] ecryptfs: fall back to a read-only lower file
Message-ID: <20261110-eliminieren-raubbau-gibts-97763ee773d7@brauner>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
 <20261029-work-fs-sb_rdonly-v2-2-2f44f64f0b66@kernel.org>
 <sashiko-outbox-191221@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-191221@kernel.org>
X-Rspamd-Queue-Id: 565062000A
X-Rspamd-Server: rspam12
X-Stat-Signature: gs7j3pmu8zef8kg4kgittk1pjetd9qrr
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794347886-746466
X-HE-Meta: U2FsdGVkX18BY1Je60IwmcA8wUpUtyIwjljpqK49Kh8WEW230oFHhVf+P/YZ/DhRWr0CT8TQZGdjwwvluu0RaIJGTqnRglBJ8iK3LnDWcLkwRfONZVts/dEsgt/HIamh3cwyIV9ZyJNqwhkFpWcQw9+bCWCyB9fbLzFbbh+iTTBff9R6nuuGWzXLqfWFaqGNcskL57jAJ2gApilKcb/+097KGrehb6fNrbaa47giJb68pOqqKwenPZQizC7NCp1DvSa5bl89QG2xnSUtTpA4wcyjbW/ddFT++fADR1eJ5WddnpNxe58dSG2hByAyPdpTByor8BWTdcqGqKkwBRbFzOHHXRhDfZlJYLu1e+eOnGc7Ac2BlO1uIm2dKOAlMgxSuCI/bx7U9V9CYZt6EGYF0kyvSnaiskpCfxadGNiJ8EU2HERsZvulk1FaWErzKWUcMcduUJXb710oP5dDyVEq7IHcbE+JgfEV0c8gvhAuUnEJd7VrQV4CRA43somUV1WuY0lY6wKohymcRkulCcBCPnSIUgbrz7cqJr390aBvQAkVH5dSlMpLJqIT4Ll45VvszKOivUvjK+K0oqgJcHKHQzUIspihSY4mzwbu1J/813kHt0vHt4CsrB5DcFPLGokBe+FZUT8aSNwm+5aEUsHAhbKSNTvN7f/JWfwlpTQfzoRO+DmStRcmf8mmrzJ4Cg4B1rwpzKIFe42of8b92QuEMb2aWYvRPEJVFIlJllQpuWU8IYl4fEwRSt5KixrfJ0pZ87L0RBVD5U+IdJWKtF+q/ralHncXctdupSoE3tK/mbLpopqe1scOLFdKkBzqd9vRW94ZcBlptI4atlOyIIeFjagTMfin5PRTevpKgS/XmiwYA8y09Ys0m+Z1z2M/+oDNLRX92HyAYBk7k4jioYb5oprQsYuLSusiFeD+xxADQhnG2udSZjABjum2PZ2OWCBGThEMpORJvs7ZmwWkNZC
 P+U4c/72
 7/CNtdNdQ8xYyoVwh9KWACCPUjEypidesxY6uUFHGEpYRl8oYve7Vb0wNfzTqoB5qRPuyBQr6QkQgOnaIR5KWlXZPhN1Umx7nnDVH//RBkxD524wgPq6krCVRHWXOVCFv8ho6NmBMxI+NABsAQ08BZJcIBpjK4jocFjTbNyzMUJiZ9Qy2ne9FLhRyTfWpo+AG+kwUpnaZT2eG6iwIDgKNJ8r5joxTgopfSt9ROGR+Oxp5ul4XyxomcVj0IJbeazge/AA0HMrXYGILXWggamgX/ujO2F6Q0beFs2g+9U4s+C7DI2Sb1rs4j/EPX8324l2o1Nw5dzW20QEk9CII20BPoFaTOSx7YxTsx5AF09kNK9ItYpAsMFrbLgBNS0j3b2YfpGW5lhsRiXbLDZcV2aJQq9lwe7ouxCSC7pmxks0mxKPRfIb+UaBywccDMYus17ZAKWiDp4/InzVr3SIcVJ/uiI9vZs8P9km41OjG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 04:09:48PM +0000, sashiko-bot@kernel.org wrote:
> Because both flags remain set from the failed initialization, does the second
> open short-circuit metadata validation and succeed on the uninitialized empty
> file (and if the lower mount is later remounted read-write, allow writes using
> an in-memory key whose header was never written to disk)?

Pre-existing.

-- 

