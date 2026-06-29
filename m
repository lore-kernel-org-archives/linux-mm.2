Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8305C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED426B008A; Mon, 29 Jun 2026 03:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C4C26B0092; Mon, 29 Jun 2026 03:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5746B0093; Mon, 29 Jun 2026 03:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 637EA6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:32:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D7BB8C2C3D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:32:55 +0000 (UTC)
X-FDA: 84932133510.10.4E8A445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39EA780008
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:32:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnirC3HT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718374;
	b=pdpTVDhG7AWNRlV+EPic7MnWe0v34jMSH8kc+zYpWwDX4sVusaJcPhMsjGGRKU6aSG3HNw
	uysKcZ68S7tFgd0QmIpzDXuFqMvEjYEjIc2fnMAH8RrBqg5lRDE4GtyjVRX4QM7SPceV1I
	65Im4GRObWYBe5oOnsfGI3ngIkp+aVk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQILP1+Z2TxXq0Un39haziwkuPxEamc+fCQlGCoapCM=;
	b=7F/3XUWslSDdVhz1ITyJjydiMlIkZqyBHMBR99YKTt1sTt3dELzRuQ81qkHReazSHETlbC
	nYTfA9MrRTUcumQdWDrwoUUgb0nI3+WpIfzoleCFT94V1in4uFL1lt59knNBCVMwvV9Lpn
	eGZNaFf6LuLt7WTE6uOLs4GoovDS/pg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CnirC3HT;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDBC060054;
	Mon, 29 Jun 2026 07:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA43F1F000E9;
	Mon, 29 Jun 2026 07:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782718373;
	bh=aQILP1+Z2TxXq0Un39haziwkuPxEamc+fCQlGCoapCM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CnirC3HTjkIR9w6pTl0JI9ZfCHSyLlfdtJqq3qzs23ldlSOyk6YpHgO/UrGeHvh5Z
	 WH8zw+3VPjqMbBKI3vVSB4fdjr0kZcIbo2YEkVO+gnamjjEjtSUvfiXz3rNyoEbSR3
	 08RQHDP6IOp6JknYubSgPA85cpO36lUJCm/bwayHYHt+x643I9C/ZxslWUvYtY0HBk
	 Lyipy1yRp/kmCJpJYn8om9BELNB+HnaLg/C6ZaVVk+Ly6J3h9Nf2c2PaCwO8ed4rAg
	 x7oYI8AJaUgFJps+suGY/aR+TrEILM+5uOluEUHEodgovuL2Fugnrs+jCahLLrU/xR
	 ZelfKJC5TJazg==
Message-ID: <078000c4-9786-42f6-9228-eb9894a26b30@kernel.org>
Date: Mon, 29 Jun 2026 09:32:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] mm/page_owner: extract skip_buddy_pages() helper
 to unify buddy page skipping
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626024550.25677-1-ye.liu@linux.dev>
 <20260626024550.25677-2-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260626024550.25677-2-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39EA780008
X-Stat-Signature: afx9w5kefuzie5ftqfj18f8csbm1b9zz
X-HE-Tag: 1782718374-310087
X-HE-Meta: U2FsdGVkX1/1WzoNJQyuwDlgPPYL5gwG3Ayawn6mr6NU9HL7G6NMqt7BRT9hZFRcby9kxraV/IPa5bC7ZrBWCsl3NOgFpgMVlJ6GOdHcD5j4GaHA6dVjVA6K50QtbdnHHW1NrnjXKYsD/ZJJQqdR2QwlbzuIRsB0eHus/U+0gHqa8wLWQ0EOw/1ZTYb8loCvTcgBFCwNhYmKtvzJ0QC/cGTRDZRHfoFvK8lY6G3tTILDnYA1k+N7ZVJXQ4RPrsGsfmcQMz7w+6gpCOubxisPqkvRqvzDFjccx5GFpOgujAaUB85/6++f61t5H6Pi4wto2zvpDpLLsJ6eF92ovc6KrGT/qDJ5VzN0zrSk0E9HLi/GYzTfnXkrzb7lqb/AdAb6XbMEwemG3DZJv5gWgtMHQsYf3LwLgrm9OXetnhn40QX/3+M8oCYFVNt0Hvw7At5ZGcoZq/opIIUL+xezQjcr742DqTJQtgEakrTO93fs171nM5Fw7S2W8BbUCqBiMHPwhDs5cMsQnIzQ3VkN9sZ+9dV59MF7HY5Gh8TQx5+0xs/EWE6NwkUqBDLPM0J+JxY4nlfWAO51pFo1MNQBRbRDrNc/Dh40xxecY9WtBpTdIxF0G/rXv8tRR6kAOhHkjRadTx4qrT/Gr2wmu3UdJrEGc3yctOmxiSDbmfcPRnSifnNAkBBeklufdNrTNmjyBbznmNhz/W05eytcx/cJOMw4PJs2c9sdKJu7dKNUR+/Xh7R9vTg0858i3nrDnbMFY81gn6LRedztGhtwUejWBpaMySMqlWAyqhkzOwj4IF+8hKRbSYm0Zg/aA/TWtEJr6s5HW/pL4Qtb+PRuY60lZmMr7JmtG/XukfHw4f+huueqvWU3N6QPMDS316MFPBh9g/tLO4nmqhyLfanTgadakbXmkDN32sGcsrwmtK9PPMTGbLU83Fwj9kIXFOFFiQ5SpkB6IZ29oK//0T0itayE/dm
 7tPoYMVg
 TVZlGwzJDhIbateu8e41JjV5/EEBqU62voDz2hJO2c5Zoa28oSmv0/6y8SBLzO2qeSBw4xtKpK2lmEknfairT35kDDRAgCVDekSPUVN3t87IAxNuHzsT2GfE9JeQeTLfsRvWHK4f7udDRdUykxC5m3XypIRxzm9X4+en8F31vCNqorFhF8ifRUpD5qIdqDdrrdG49JI2UyJGgqfhssbtkaoFNvjVg/7BD9RXPbgr8nQzrm/v6hcjdAg/TFpLx8LifRAt4IUdOB+DJCJEuEy0EXIvnCsfv4NYEfiLkk6C0oLx2MIVxmgcK+fzLT0s6ReeQ5rxNceBbZkaDsIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 04:45, Ye Liu wrote:
> Three places in page_owner.c duplicate the same pattern: check if a
> page is PageBuddy, read its order via buddy_order_unsafe(), advance
> the pfn past the buddy block if the order is valid, and continue.
> 
> Consolidate them into a single inline helper skip_buddy_pages().
> The function returns true (skip) for any buddy page and advances
> @pfn past the block when the order is valid; returns false if the
> page is not a buddy page and should be processed normally.
> 
> The old init_pages_in_zone() variant used "order > 0" as an extra
> guard before advancing pfn, but the continue was unconditional and
> (1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
> about zone->lock is preserved in the helper's kernel-doc.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


