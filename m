Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F0E0CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 13:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115A66B0095; Thu, 15 Oct 2026 09:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6DE6B0096; Thu, 15 Oct 2026 09:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8506B0098; Thu, 15 Oct 2026 09:37:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF4B26B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:37:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66A221209D5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:37:26 +0000 (UTC)
X-FDA: 85324962492.13.63A47D2
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9F1E1A0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:37:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J1mJApcx;
	spf=pass (imf19.hostedemail.com: domain of 3EtfQagMKCGEQMUFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--rnv.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3EtfQagMKCGEQMUFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--rnv.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792071444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMRUyKDIlmUyDqr3MGg93OZa2p3kWIknOepDwEvmiZY=;
	b=C/eqNjB05GHSWBBMs5izFGHtnkG4It4ThCJcA6CXx5r7II3d6vGuoX6IOx7sciPsZrjwjj
	Unoe51m1K4MUjozET1zs6flqkw1WH61+GwVa6QWZwc92bu2yZ7C5aMeQkrh1enNkQnixcd
	XfbILjMuURTEYec4lhbTutuS2sNJhM8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J1mJApcx;
	spf=pass (imf19.hostedemail.com: domain of 3EtfQagMKCGEQMUFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--rnv.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3EtfQagMKCGEQMUFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--rnv.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792071444;
	b=ptWt6WKuoP3cmfDMS4KsGYfedaNP25hWsx1FziwdnDU8WxqyRlnjuaQdroxSZ9077sf7WX
	v9chebaSfJKcr05AapM3VLZ7iVyRBYytCDFU3d3Wtvw2zN9XnYDmpDkjvbvSYEcUaR6vV7
	dYoXXzGpvvMPO8x7tMD19LzWgZim8GI=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-341eff9e381so14865252eec.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792071443; x=1792676243; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KMRUyKDIlmUyDqr3MGg93OZa2p3kWIknOepDwEvmiZY=;
        b=J1mJApcxbweD0YXtsqD7DPQRyfu6ZgtmZUZv2yyR8bhtq8bc8oJcD4idhiz8mwjEHR
         fGIXhsoMXHPvnhDOjnPedPvYxnpcWgoEFhLsshNg83kHqKZrhd/a/waZ5TgBGanedJII
         E2PFqHCqePCs9JQ1sfWCWc1TZuyz25xkhZ2b1CMsiR6BCbRmXwb/4IFFaoGXBnS4qGaf
         xWywyGJVSEUYmbqYpzhzZEczfpi1nxLVYKT2FFcU8Bke5lFBYJRQ1v9JWQTNu9Zg++hS
         X63pLsQoVysqUSLffey59WWQIG8FXyFk7a3ulrXd9S3JTCmUwaZiSFiRWtWSu+q0a0Mw
         6wlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792071443; x=1792676243;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KMRUyKDIlmUyDqr3MGg93OZa2p3kWIknOepDwEvmiZY=;
        b=p/1jvTuGkB7a+n5RoeiSlJwDhMesu+PL13ZrYgceqbhHgsv1IUDVVR9jeLAsRyfh6u
         Q/gmgotAwNYd+cxCSrhMsdFCYepnrv5qKvnAcGJ2g0POoLLPIN6BR/QE1ivOJfFfQtyM
         /rrJ9mh1dHVMZlpw/8PgIVAIPyGDo2OaFNQ+oXvs59xZyUT2mGxml90fOAyA3EK8i9UA
         73RXscqKrR9G47QoBQtW5chT5uB+LFHlnfUm70nmWaxRBrp6XH18JpZji7VgzGTAU+e4
         V4DiUcvRAxlzfe9DyPLPLNgpXlOOwEge0mZQCnz1bv9mjMA9tTtt9dOFitxGBXW65rc9
         OANg==
X-Forwarded-Encrypted: i=1; AKwUvBy6iAdC0JS7z08KtjCLj8YdQrxV7IvgwrvfdNRvVEUCy33iZzRdk44TTC1AXU03I7KVsoXYOmrraA==@kvack.org
X-Gm-Message-State: AFq9FYJhnqarYYiygXdtPMCgiEXkAK3ruiKLQZxKb0COw3uKCrRASBPa
	OeiT+HE9X0nsGrKAI6bKm3EGDrp0cObPqxkPDOyBmrE/axeYuEwVWWcJkhORetKnp2oGEw==
X-Received: from dleb18-n1.prod.google.com ([2002:a05:701b:4252:10b0:161:fc1c:61e2])
 (user=rnv job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:260e:b0:159:aa67:28c1
 with SMTP id a92af1059eb24-16a5eb53f9emr28763528c88.20.1792071442858; Thu, 15
 Oct 2026 06:37:22 -0700 (PDT)
Date: Thu, 15 Oct 2026 06:37:22 -0700
In-Reply-To: <atCKXeWnVAWvhSn0@kernel.org>
Mime-Version: 1.0
References: <atCKXeWnVAWvhSn0@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261015133722.2351642-1-rnv@google.com>
Subject: Re: [PATCH] mm/execmem: only free ROX cache vm_struct when fully unused
From: Arnav Kansal <rnv@google.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, rnv@google.com, rohakum@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9F1E1A0003
X-Stat-Signature: 86nptfeesrhqee6f8jfkfspbwis6rsdc
X-HE-Tag: 1792071444-599566
X-HE-Meta: U2FsdGVkX188yikTeufdgD4JjvwgJQZhe0mAodEYuf8i4s2F31581Q7NvzKktsIHpELzQgmSMfw2+140TrqWd3ZmT+qrnxqfhxevBbJTRpHHNy/oFgxfSb3NBS/wNZnMF/NOSq1rrITlATOW9CbSEozv8TJscunJjo27mnhLE/hy0l5B7GHN2tFLOAp+s8wyPMlvoYydYOG7TsxcV8OXYcoerBBAabUZnxu0kfKQBvHXgxSn35xw2UdENMrDnVkIOfiFtukPe10lV2Eb187J7i/rV04pU9q3KS/jke4alfYPZsmkOA5SSr6tjkpu0NS2i+yWvseaqMUGKJkz+a8xZHNkNUGS2nlkqMGVRoqCaD3uCp1/UqkUTYWjlDYqwiNd1CONjT01flopCylD5FKRcIfahjkatHE9bVvSyFhPHlUxioo60PK9xFTUoooAnYhuvcBCGcDaC6gwN74+LxE+XGK0AB9Or0Rt6bbIXUtMdQfvJH4t24QECSwLgWtPDBgbr7+KiQWVr+buPA7imEGmtQ1vXpcLdSyGm6xnz0dxb9etu7UA/vk2d0JqDqA2kzFJpUIYV+iYl4QYKYXIVgoUgtsnqO0edoEIKAbLrD+cjqZB6uNHjEQh5TXUoMAEmZviKwY37Md+PwgsbVaFFh7kzMas4XIu7OL9WhWHueG2RQYHQuQQHhaky+uOrCB5Oc1XZg7W5o8emhSzTXN33atXE5zg9N9BxQ9JoVuhT2M9PRrXbNOsiTRrhLOHy+SfcS3hzVs4drtDMwUtChCMxQeBUcAa83O/yUgs2pHmMaYjoDeYOQ8fu5+Na6+YNFhWO0yFfCI3JfUPGdxO9LjA6okOYmY/27HzRzIUO2DOiva0oLzYApF/rJvqT7a8oMbxhCT/KTRrBNUN2GzuEBLhtU5E5FS8tAFmL/jyQmtJ7DUCBvtJvxFqyx4E639TFIzj4ooAxQMMxU8+L474weQRH+k
 +HARW0fH
 //k8zgxGoZ9MoPqehhygLy+QU/EerI+RGpUaVHDwge/dzYaSM6btiBxseL+OelvhsyIKd5ntpmPGN/XCZdQMY3nleyHNmps8iYOzUcBhOOdg+uxGkG4TJ3WdGdX08rdOzFtJbEAXZO4iOP99xDDfuuTTGv6g3FrsqoiTONvya3lMOPezdI/gp4ElcXFZj2+IjGugEjf76HPxV68JjDFclpycevgH72W7BMNhQ7jWlm59qE8fTRUO4g4UgWUF1z9SfxA7jF+mpOtvL0yeNMTJSJomtxUVFSeH9bfZHlwrYl6gKGYIYANhH+9E10aNVaDmzl1wP+6M9hATMzydBB4fHEXQRbJeh6DG8amKkz4UDXoMf47sp+DHU4iBd3Z3qb4h2tdwERH+SZVNncRKw0dVMc2B2NpgWBJJuhle8Zzk/ECfjp4lmCQtR/4cRsC4vIk3wD3NSWrCGZheZqGF8ASNh4B0jCxat+7IE7F9bJzStKdeUoKcFb/duaJXfXbj+qC2+Q1G0yI411Zhtg2Z6Gj8M+4rI/oBo898n7/S9Sw2RmcOfq42Z2B7E6Z/TCCvQm/ZaIsdTeC0hHmNYh7N4gOkrs6Pnn1MkOjgO+Bgeun8R/Nk23bSKTE7JQgwr67p1riafBBMq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 11:10:05AM +0300, Mike Rapoport wrote:
> On Wed, Oct 14, 2026 at 04:30:58PM -0700, Arnav Kansal wrote:
> > execmem_cache_clean() currently uses:
> > 
> >     IS_ALIGNED(size, PMD_SIZE) && IS_ALIGNED(mas.index, PMD_SIZE)
> 
> This is not the case anymore:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/mm/execmem.c?id=569db54d8b7a4ec463a62c444de0d6f5f10e9dc1

Thanks for the pointer, Mike! We had checked Linus's tree (v7.3-rc6) and
missed that your series ("mm/execmem: fixes and cleanups for the ROX
cache") was already queued in akpm/mm.git.

Commit 52d95a55a011 ("mm/execmem: free ROX cache chunks only when they
span an entire vm area") and 569db54d8b7a completely cover this, so
please drop our patch.

As a data point, we hit the exact multi-PMD premature vfree() from
52d95a55a011 in production (on 6.18.y) when a large module (> 6 MiB of
.text) failed initialization and unloaded after a smaller module
(kvm.ko) had been allocated out of the tail of the same 8 MiB vm_struct,
so having 52d95a55a011 tagged for stable is much appreciated.

Thanks,
Arnav

