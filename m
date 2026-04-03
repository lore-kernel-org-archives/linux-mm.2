Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B83FE7E365
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D65C6B0005; Fri,  3 Apr 2026 06:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687C76B0089; Fri,  3 Apr 2026 06:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E7C6B008A; Fri,  3 Apr 2026 06:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5166B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:21:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03348E0DCD
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:21:04 +0000 (UTC)
X-FDA: 84616851690.07.0C68E9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DCD312000B
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:21:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxEl3XFX;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775211663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a760oxxxOLaQW4dSBczI6dKIh47ybxbWXdBIMBPc9j0=;
	b=ihb8lmhzFPglgk/q6H1eKq2EUwnb+RlHucS/3NQ5yDY/oknCrX5Yohp4UVTiUFUUkA2C4c
	K2KW48uJREkmtK1G6JbtmmGG1a8z6dJSwGYM0hGH7VcpPd2ymlYzv+6uDwLV4vOTuJXip6
	SArYG+GvoiMKbKRidrmwXsgCcEP5Qbs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxEl3XFX;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775211663; a=rsa-sha256;
	cv=none;
	b=xnljpgdTlUPwEylTdM8qLS8ZcGocdnqPFKJIypuZoJI7w9CkBq1kpJzIzCFH6fzmNFT+qo
	wMYbPqtwl6dNuEswAdZPUb2Weffy9ZOD7mmxDQmoIGYKvQVtBWQQuNT68PffKRKFIU/YD4
	dVNzvv216hTaXUV/QW9V2tLc9QT+cgo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 300A5419B4;
	Fri,  3 Apr 2026 10:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C9EC4CEF7;
	Fri,  3 Apr 2026 10:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775211662;
	bh=rZjVCA+ZmnKNs7JcGv32uV1seTHFWhw6bGD9OcNlYuc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mxEl3XFXnkgN7eukpKzh1Ooc432bZb0W6xnC9Jq5K41j0v/QrjsycF+jFrsa8/pkL
	 IL5VCyW9HbNp0jKoo8Lxolp5+Myhq/Or25AbSIbLHaGlhRrw5nfOpSfQhfsibntZ1v
	 1ujbUxAwpHUOQ6PxQAwljbnp7coom0Bu1VJe+QJZpSzEm1JpoLDjWyIgi4ZAOnIRlF
	 GMpjIfqmPVdLBGbgf7HDgz2EI/yU8vo6NxHKQXkHRiHkZ+Pv7mZ0B9xeEoWhpIC95d
	 8UuzyD1OKKB1cIvbpnM2I7MP9qjr8hqTMgcOBJrsQRIttWIsCdsq7HvZowtG+uSiRU
	 WCXIMUwgsCxuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: rppt@kernel.org,  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  pratyush@kernel.org,
  skhawaja@google.com
Subject: Re: [PATCH v3 08/10] liveupdate: Remove liveupdate_test_unregister()
In-Reply-To: <20260327033335.696621-9-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 27 Mar 2026 03:33:32 +0000")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-9-pasha.tatashin@soleen.com>
Date: Fri, 03 Apr 2026 10:20:58 +0000
Message-ID: <2vxzeckwe451.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: h89g7grzfj96iu1owc9ppydf5s3ms6de
X-Rspamd-Queue-Id: 5DCD312000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1775211663-844617
X-HE-Meta: U2FsdGVkX1+vcKgFPfOMJyII3b6pVJVe9iyH/86859icdONFGRfvnqhpFeobwOrQmEzsGNIa00IaNH02z6ua2rBce3u//xBH2mr7CCMXUqFAHcAeuvBAhLZdyMwIfw9gJ+IFS9fJBsLMPvCDgTEkMe4LoY41B/X94tP5auKPq6haWxCXRKMgm6wP/anw5JuWJmIkT6tjFvJaNXS374OA+jcTqv8Hdq98rjHX2chnJcF7Lf8q/LZfp7+9Oi7NieBzCCoyV8OAOOyVkYm6ABqbhM3ZoUbf63HxeEthSJiL+LfSjrDiOL72yT2njk2nPSOhYwjO45ikthb9Mv6OBTv5PFapl6XLcCMWXvqH490UZlT2VKVUPd755U9UgBhEhjmwK6Hs2DUyxjb90+wg+T6P4EIDpayuS2QRHnT+h658QjH8alO+NXQtMQnFx0ZcNNczgQzR9vFz9BSNuAgrRHoxU+9RVwlJ6I2foYTXuh9JUhBzLoBxiZmbxYvoKti6m2UfnBRnG8qDyM1MMQNFXhPS58c9smIzsMEC9lvh1dRI4ngdEV3Axqth/ryofBhdei2+tyj+j++k2Enjc+/X/8G+8MKy1VyN3tYprg4rvfz5cIucXE3CojGENet3V/sO6lpBB87jNaEACOpdNa3SR+YI4KL+nlbZzOzkcQTR/ngJMxDK9lxEI4vsTbuX61qhfkftIYZJ6MUoXSaxmOUGfDhSXqYdRUw2Z3ljKHceEcvW98YM7PdpckDG9pkMQuvke6V+mrBI5yfQ5KEfAfpgtLk2yVgEQaIzbXhHcmsj0ynXEFGgZZBGoACmrFxwbJy+BQQQ2/t+0V70ntI3MwUaf5wt5l6RElLBzN3q0xSy6ZBVBGoSmotQwV0cpifwYuSPyNZWtgBjQkFa02n1A9pjWMWifOeMZW1uTGa8w6aNj/3k+Q6hCwFsGA35+mfgTJ/EzoIpHkddWn4/xgV7V4u6mPk
 str0C5bG
 z0VBbkYUFsNdca2gELcnwSwZldaPIJMk79mkY+RX+TWgGkQdJFxm5TJgZ1ZV/ZuKJqAej6l/hBGlvp93L5S+ezmA/FRWnqcA3YKJd9EQhC/pGRkDmmkKBj/heL3WqDMyo2X1+DJ2/2nMw8pO6AJpPCF8KU4FaxRBlC8SjNPWa2k1w3fryLYu7Wi2LFNQ9CSSaoykiJuIWWsph9yOF7AeFh/2EnuuxS3fSjJp37T49s6LtxVOMNhn9syCsYR0EbaKx+6GieE1B6AP3KoVb1DKIcxQZRh0/4IJCBZ6bfyVpiXjNyvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27 2026, Pasha Tatashin wrote:

> Now that file handler unregistration automatically unregisters all
> associated file handlers (FLBs), the liveupdate_test_unregister()
> function is no longer needed. Remove it along with its usages
> and declarations.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

