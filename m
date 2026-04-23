Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213B8FAD404
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786846B0005; Thu, 23 Apr 2026 00:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DB56B008A; Thu, 23 Apr 2026 00:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AB66B008C; Thu, 23 Apr 2026 00:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2DA6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:34:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAA308B937
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:34:42 +0000 (UTC)
X-FDA: 84688554804.04.83C9CE5
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf21.hostedemail.com (Postfix) with ESMTP id BDEEA1C0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:34:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776918881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6pl+qt7fFZihY9OigldVZxGvH7CICXaXD40uR1cI70=;
	b=sKtWzqiYBaWeEhID8wBFI75zkIw2R46Yw21l1qUYcZd3vtheKe0DTP0i3RUs6Zx3s2uO1O
	w3U49ngcN18+SrujK5ZFnvuQ7TPQyTQC6ADbTFYfFytArIXz2hR+N3pqfaQ8PRn0GY4grC
	SdoDjhdsJ5G/TQOhuq7WfbT9ryZffe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776918881; a=rsa-sha256;
	cv=none;
	b=00k0Sp5l3Gr3c519yuUW7pnbdhCNGmEW/Uo0dNoZiwClwsOvgFrURsV7vfUe3NtdG9Jo+Q
	HEPGQvdpZv0PMPtdkTHt53wLllR7J+lz5nX3k7SV38B1UIBRkk/vc7R4ejl/48SoXmNvxa
	lQD9Ml7Gddd5+gzCyaqH4i4HgLDGxZ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 23 Apr 2026 13:34:35 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 23 Apr 2026 13:34:35 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <aemhW7/etjZUo9Xg@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-4-youngjun.park@lge.com>
X-Stat-Signature: f9dn3mzw3nxyfsn8j7koe5d3s1da5ci5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BDEEA1C0005
X-Rspam-User: 
X-HE-Tag: 1776918879-366114
X-HE-Meta: U2FsdGVkX1+A3FUPYLajgGD7X6fhI/3iTXJIOJDQHlKZbSz0j2qJfQjJm2fNjlckQEuSeCKomRMtGQkPgiMyZtJXuRqceZ7dfYqG2wDuXkgCc1vCSIQFz8s+/legwK0L37OdUhdpozgtQciDCTAb9EF6vSBOVhox9ZLcgobJ6cAPL2NSJN2jReQvZOAdjQ/v6yhnP6sDP2P5TFf5lRckTKWUtleCiKfKJHUWrSAezl8gnOekOjhljO6ffcIoRBvhRaH5Y082L/tigbcO1iFPjDOzaSzUGK0aoCqezWOGxoQYkM96/OWzdyBBnWPQHPDzFe71ZA8ePDB6J4BXY8oAG2GcuvNIelGmvK9kd6xzhpz98cWTFTJj9F81uby/Bbt0+uU2hnDvpqAt4D9PDuW4A8bOep4Yq6KeN64OvAA0bf/Tshkh8M+DAnhDfSd4XSqfatEnVyoHwdzlrwKUc7AIidU4XvFqsdRvkxECBKMVLlxYhwDLFIAyskCOvMqp10upv+2q+WUN3u1MPYZwH2qeZdwaYy/qFeiO+s12AFERYxB5h4xuRxXeOuaavnLzEQo9PwuL4md0VAyY9j3PZodUYp8YkycUD8Vu/uDr8KVt1DMAKqut1crPOz7XrfLIbs8JKcQxlBL/8YCvcFLfQPHaUTgScIWT9OlIsd5xu/gU57AYE4qgzGBI03p4YyeR6ccy2LDavjS7tUh+SS9EkJS3PriPgpVC/cG7c5gXFHGF0uqX4/knXpoohIAp+kRfpmkmNWClpVM9jeGyK+jOsnKMqiqoWY9C4xKk/M1IB9b+BWn7xBchz66NR7g1lF33UtYT/wU2JMxD7EKIR8hlgD4Nk3h6jSvf42P8bjdbJ7aWE7Z7BR40pjzLCM0OhCKBlOtiQf5gVp3Ytt0nQuiLiz9NZrXKYi4n/SFzsdqeChWArkyxPWpfrlf8TvUENJ3oV9xttymTLT8B3fa91JT/Lgc
 st97fMIB
 plnhe1YNjd/u/KB/eQMn9dWwD8Uu+B+wNiA+1a4da87rmIQuP/ND0Eh9lnwyicbfk3iuSI2pT+V/sLFq2nrD4PcK2sPWO/B+VfgRAKkvHAe68jmDQS0zxtLfeOwpPHXgf+d9UkaAzSxxe57hlKiOOVdD6vQM3YoGzNtIJ1WVx1oXjJ3V0u8f47Cb8WQVrmCk2uxXNH9iIwkig8X1UKpsRtwWox9IX5NFTjnYM0J/wYgvCn1h4alhi5MdqIYIj+1hCj1eSZNNHydubT/3vmAoCR5hS9mfzBaf984DqwRFLYE+DYW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 02:53:22PM +0900, Youngjun Park wrote:

There is one review from sashiko on this 3rd patch.
https://sashiko.dev/#/patchset/20260421055323.940344-1-youngjun.park@lge.com?part=3

The concern about delegation and the global lock is valid in theory.
However, I do not think a change is necessary.

memory.swap.tiers is writable only in delegated subtrees, and delegation
itself is an administrative decision.

memory.swap.tiers is a configuration-time operation and not expected to
be updated frequently. Contention on swap_tier_lock would happen in a
configuration context (tier setup/update), not in a critical runtime
path. Therefore, it is unlikely to have a significant impact on normal
system operation.

Avoiding this would require computing the mask in the runtime path,
potentially on every I/O .Keeping the cost in the rare setup path seems preferable.

Best regards,
Youngjun Park

