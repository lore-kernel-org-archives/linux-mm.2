Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82872CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779326B0093; Thu, 18 Jun 2026 04:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751806B0095; Thu, 18 Jun 2026 04:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668F56B0096; Thu, 18 Jun 2026 04:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7176B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:16:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA1E31C4B45
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:16:54 +0000 (UTC)
X-FDA: 84892327548.05.9F26107
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E94C740002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:16:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itGltHhO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p1XzK4G6ffD8jtk0IevnqGkpzWMvNU1xe55hnYuSAk=;
	b=7Ksug9El3BLJsH7VQy7zsq0KX7Z8OVwXvaAv/uE4PfTKkLi15HJKxbeAeCX/KYLnVJpv3a
	nLHDTe6PvZ6ddPIE+Q9KHybjl7y9GjYnxThw9VlwYYZshjKebtTH8yAW2M93AypDg6feKD
	k3OOyBhNmZZg5iU/0uaAc5+ELHjaDcE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itGltHhO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770613;
	b=ACG7squSpTaeFcSrte6Pto50jIGJ1mIV30WVVNvLQlNMSH5UAby9E2YBiMJrQEGSo+RnbB
	qOmOjdYLABlH0t+1aWBChYKN4diVY+EuesC8sxwsHlrdvYUbfgLSn062jcdBY2XK0+U6SQ
	DVG26CpoDq1yX7Cm6+L8koqpuCiWM/0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AFA443A8E;
	Thu, 18 Jun 2026 08:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BE11F000E9;
	Thu, 18 Jun 2026 08:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770612;
	bh=4p1XzK4G6ffD8jtk0IevnqGkpzWMvNU1xe55hnYuSAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=itGltHhO0A+qo2YQg1yTaR26LJZkIGwrQ1XCV9cb9eeCjD6lKWdiILT+04nPn7yYE
	 ydnUOik8FLrVtfvLUafB+33pJzqWjMYrj6gxeiC90KAYvV7rgYcgGxVkZIrqRbS7sE
	 tk7nJRmC82hkkCjhi6InFF8KSUV7QXVj2Tx0LSSg674K7KFX7MENoNZUlYQ7OfEq4W
	 BZIO9ztJF8B+LrXPZqzl//cu8r7D0hyvI6Z1aOSKtH/JmZpMoV8LsAici2s+ZOtex1
	 Dsks4hIRBNglNFnUPAiDUQ3pyQHbL0GavaPGwor0YWh8rRmrAshukdfArKHJW4giDV
	 UniMSoIEii/KA==
Message-ID: <2de0f73d-076c-4301-9b78-4025910fe650@kernel.org>
Date: Thu, 18 Jun 2026 10:16:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: mlock: use walk_page_range_vma() in
 mlock_vma_pages_range()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E94C740002
X-Stat-Signature: cihmbabe9m7diy4xqb1cwmj9k4c8dq77
X-HE-Tag: 1781770612-873525
X-HE-Meta: U2FsdGVkX190DzXo0hEaO0KK3XyM/flXmNmvNtlzrntm6dKwlj07MIcrESfLoANCFh+G9uOKqzj021AlHVAJe7ol+EwRHmQPzjMtx3dZPAy3SIv/pQi/BpDW1UhI65HL10IIe56ksUAs4qKNjDOEO5S2pjVTdDRIH517SNlxjrrdqkLcGQ2ECbXqMU0PznrfuCrgHj9JhwQARmNtnmZlyh9/WHNpE4EoZWnQRqvYCP4zZtZ4qTYfIa0i1Z/hCpKaGiOFKFRnSAZu997K6TXau67WrUPp4vrfk04cRcirmas06x54wTq4G2SaS452fMfMK5snPbZz59DoDbket5SiduBc/f22j2gpuj0nQ52ey5DFdRfvtKOdZm1XYS0nLK/1eO7TAUvr3YInJ79KawL8VAwTeH2JxkmX6HcRKEy71WgJKYtLRV4Kxh3U6Z7q+WQmN/7tC0mihrQbUGxav00P2eFX8adKYEH7DxsbLNbaQFcdm4TiNns4gNGgAm4hJ5JBefu1ktFk3BZnP1C9Mi9UrYcjalroEvZjL/reuSN0BjWeAsAd336luU0iWClUFz6wSyqtK2rL/EFAd9Kcju03XB5e2eosreOSVJYZD0D5XmOp1u1KD4eaEllwaS7yIpaLlt4K1WbAC/ETqJU4xsZxJHdZrzhYJU/nRlMVfD6jOZTFNB4vQz8TnWBWFRyKWLBoEbeTv8UzXRkNauuppacS9P/vhcxBR+Vwdgais46oAxA+BFUoMoNHUZ4wNMpdJtoCppKAgxtuaLRrNWVQVzgga3fBFLlOMWzpylJ44nghcgHuq6PHgZl+5v3W6+hFIf17Z2ask6YElhbJIhpZnf+twyeJwHIlG0MFQt+5sI/ktNf2GkruTD4mvEjPQqQMbqQ/otuVEW2tCJhimcccK42HxyMF70toNoHGkwx8sxCG2HAcHioxD78dnm/LK38dWxoY1Al6wthLmqjyAhtamps
 WqfqO1Sk
 Tr3IKdU+6/t+XM0RjDcNDiZoo7v1vhhJILpu9leEPvz5Gh48EBVWtNrYOWYojcufnVLRzcMZaceCkv0JxMnDA77g4RZsijaqVwg48PbJpdK3qFPy1+p0uoThZaK7G7iZG9ZdgKm6APOrcDdo7g5AtrGosyAXc5TNA8Dklvk/WLf5VrcshvePr1+YOq1geEEzHW1oKSmA54KJSkm3jN6cXbPMllda5FGZsfc6GVQnqxm9Gpd9hw9OF0CeJIabPrknI/e+pEB0H+UtcBu3k6MIHFqFajjhqdRGzHyV2Jb4t0ioI1+Xa4yBoKO7dbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 10:26, Kefeng Wang wrote:
> The mlock_vma_pages_range() uses walk_page_range() to walk the
> page table. Fortunately, the caller always passes start/end that
> falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
> and apply_mlockall_flags() passes the whole VMA.
> 
> Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP has
> been filtered by vma_supports_mlock(), it's safely replace
> walk_page_range() with walk_page_range_vma() to eliminates an
> unnecessary find_vma() lookup.

Re-reading that after #4:

s/eliminates/eliminate

s/safely/safe to/

-- 
Cheers,

David

