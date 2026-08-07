Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46415C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 16:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2AA6B007B; Fri,  7 Aug 2026 12:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C996B0088; Fri,  7 Aug 2026 12:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CB36B008A; Fri,  7 Aug 2026 12:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F22176B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:04:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73255A044A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:04:16 +0000 (UTC)
X-FDA: 85074945312.04.EA3006B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D9A042001A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:04:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTyCse8f;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zs2CupHJANi6pFKoOr7VXhIxID/q1i4SSnWqfldLHUY=;
	b=7CS8Hnumw1UxZjYCjg/GFK/IufbvFSTxpVlg2l/g3tjHbVbPFobEfVz5dmnZf37LejBP6m
	aUCI9w8vCi8kt1HAGLGkOkIsfuxWEoS831qjuTCqvd/ZHb3wC3PUUJDyUz5V9Vr/zwYf5c
	Ys5QRPRzHp/mAIY4f3/ITEToBG3ZfKk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118654;
	b=GhX38umh6IbLtHgAB3cu9SuF6hAj9mFeLg6UNhlWrpMvwBH7W7u4cQ9R5A1DXzKGXrZsk6
	4QRED4+XAxRBzDh9GR78EZfHrovlEGpax/Ro8Om5ayHukhui0gfcGjuyqS9AJC/6SQitUh
	oeqv3S5PKZkH+jpnMctR0o9bBFOD1bQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YTyCse8f;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6ED6C6136E;
	Fri,  7 Aug 2026 16:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ECE31F000E9;
	Fri,  7 Aug 2026 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118654;
	bh=zs2CupHJANi6pFKoOr7VXhIxID/q1i4SSnWqfldLHUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YTyCse8fS+KyOcXFqDpchgcsLq+P7g402dHJN9Dusau9lgeVS1BVe7c3IMT2BzBaH
	 5jp0dhcKHpUuTJP+eSZtDJ8ZQhEGOfFftK2DSGk9WK3dhynpuXNzawniCV+37EgAyb
	 BmfLD8TYvOCJskJCGxR47GJotjRWrb7WFTWCz+5XUVio33osF4zxo0//5veMimhyUo
	 Es8KEnAp4Tpu04SLTQ1Xgz7J41xb0RX96kQ2K4IzM9BA/OBiOVZDkvdzgZlK+OQpiK
	 gQd6nkpb9Xg4nGC6DBoI/giT878pMQsN0Nnb9BF6UqK9IfWKqd7p3P0v4l6Ew3S7tY
	 3zHAj7fOPVDbg==
Date: Fri, 7 Aug 2026 17:03:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
Message-ID: <anYBzzrnnWv1gxIv@lucifer>
References: <20260728202014.2517142-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728202014.2517142-1-noren@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D9A042001A
X-Stat-Signature: g55aoc83orx4km8gjk6rxj7xpogi6i7c
X-HE-Tag: 1786118654-250006
X-HE-Meta: U2FsdGVkX1+g3gyigeLZRgid4yMuAoHoMIzn2PinH75xHz2h+ENVCFhRcd+TPPnP4PmnZOxh6/wYIy4S0f3Jv4ABujFPY9MVKFlgMbVLFRbOmeZ31hqXsFbIAc/+ZA6MAKrjqXGhz3Hx6+w4BnquKdN0P2GRtzDHijONIW1gUhdrFrJ5SP6fc2cBj3VGjc+FD+Gx+gwjFE1Gyv4w6q3BhDcu15RS2++Q55hYRHCoc6Cz2xJ18lhKLcAwEvzM14ctM2ZA2U7wupQ9xn3nL87EoEbZCKzXld+NGIXymIITf2njn3ctQcSR4bAXog+EuQvr3gYg2y7dBsNMDVh/xczehr9fb/7nXFVyfOHKjJmU77lKSENbSRghWmRrYlrrLFfVkdpUa1a25FHUOl6sofGdJcw48tQYwZ3ddOHowVHm51Kainkx7hsO3ET6niuTx2c0mJ8q2M+Fp0B2R3LFKpA0cVJ6iPRLEUKTew+wFHJtHJ5aEbElSwQpEgx0/V91cRfAa/78l3Lx3PuJ6bpStZZlUyg4S5gp/CYJHxHw4iV8AiLpESOPnpbRWzUKh7YLmv4YwViF5sHNyFJTdCdWkXt1uvILEhsdXgvRNf/Bnjy58eq3ua2GJzi0LKDVHm1S9e8pk4c0oTFKONOIgjzFmj39UrgbgS9Zt5To7+5Tg95wJxOFt228u/SmnMn0KcJQbtC07ELm+3r/sOjmsKoWKoERn5PhwfxYPctWOwgIJqxcjdGLkuWL2n6CP9MPsxdV/UJrad6ivekRlvTeI4YOHIX+pxj3rw/sUXFr0R5V3NFDJRj0xznefpelwCsN3Pky2X6M4Q5lilRLQsut2JIbUeM2bxN9eyCBSyrTQOimxu/Kg2kKWh0hHzuoYi3mRGdw+hyyurKnPWjMolFjJVA+aMyKxAGMdwhitqW1teULH+hjtTF63AOmeuTVSMbbV/N0fMxm5ie2Vgv1qb5LKQwHnA6
 vrPzjbG9
 8Ptx6cmyYGLUhSmgUw9d3oDCvXWHWtNi0HvmRa4ZQIf4zeRRg1hEdOZvKjfPE3ESQzjUrC9ljyAJegO3Owc42+blvm5O6T4/jTWUMEILkhZsQw7wznbwz60Q9fYWqeI3aVSvGGevVCU/mWhZl6UANsVH9mpafjubyOXrWZM+D0fF3Jy2qbLDIWUAkRDhpLuas7ZVyWpnZMYK7SYCl6qD/zuGERewHd5W2h4EXs/t0mAKTFpzm61qLz4K/2bLIrwgAN0RY4HLuLwhlJaAMQSd6h4sYMeA4ID3+Q4i4TlBrn/NnunM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I gather there's a respin coming so I will wait for that before looking at this
[my email is a mess as usual!] :)

--
Cheers, Lorenzo

