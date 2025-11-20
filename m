Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F24D0CF8574
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243BD6B008A; Thu, 20 Nov 2025 04:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F43A6B008C; Thu, 20 Nov 2025 04:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5156B0092; Thu, 20 Nov 2025 04:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC62F6B008A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:20:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 109845B326
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:20:51 +0000 (UTC)
X-FDA: 84130440702.29.3B10E4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 58BE514000B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:20:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5C3KmUZ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763630449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=koDNr0WB7QLtL2X/3ZNzEHPx7ezfgwdLvdUA9QzU4To=;
	b=lkHKQz3ZjkL/salqMOc+TFdDm4JZE8DPq5hyWJl8JlgqLn5gt22gbdESla+IkfZOBf5hYF
	dniI3IvFKt8fBIU69OEwtKkdkf74pKJXSHjN+yKWAZOBfvPR+w41pmqRZkgUanVkjSjS5D
	Vt/XOV0vq7/xqZfuKcmNqy/p76HvIcQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A5C3KmUZ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763630449; a=rsa-sha256;
	cv=none;
	b=L0sYNO0wEUTLe+UEG0y2FzVMV1n2/dg3CynJyu9Cqaat6r8saeIFevpVCrrMkRURSZqXu2
	XyO/OzPYVLvhTn88aJ/s1qLOD6GtIitpVaeGAsNHpFzT16imahIO+MFPpLeRw9OvW7yIeh
	KuiLFz9r7JPhefyj9iPgV8V7zm96soA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 93C886014A;
	Thu, 20 Nov 2025 09:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8231AC4CEF1;
	Thu, 20 Nov 2025 09:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763630448;
	bh=yz6BSooJtJ3bZJrufTJyKFke5JjVJzklkiFp+AbB178=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A5C3KmUZfkpWslBQLW4BDvGrTpFmFmj/djXS3U+y5Bwrb9i7UEHNxpcyANvo+KlU2
	 KjBMLkSiPDTfvzuGsqHUX0yV9H42wyR6HuuIgC/ziI6MLxIXyNk+NVy08lR3ezxAZ1
	 ht417KItqUmrdzZuozECQUeGw2AdRNgihsNRIMFQ25C3EWhw5QKRbrG3l2PoQeatFq
	 A8F1lOiIs7wFiv0k2TvGObBO3NEpmJkHalRemBG2osAwt84p2uoVJGvHvPfxDSKoQ5
	 RqVocKXd2RJ+GkuARkNclM62jazaGr/gs+5e077hvBSxxrQ0GULlkcjU6Uq7DCpgQK
	 JUVs/Wz3fkL4w==
Message-ID: <7430fd6f-ead2-4ff8-8329-0c0875a39611@kernel.org>
Date: Thu, 20 Nov 2025 10:20:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 39/44] mm: use min() instead of min_t()
To: david.laight.linux@gmail.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Christoph Lameter
 <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Tejun Heo <tj@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
 <20251119224140.8616-40-david.laight.linux@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251119224140.8616-40-david.laight.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 58BE514000B
X-Stat-Signature: kb663ipjwffe3jkag7mo6j5i116uyauk
X-Rspam-User: 
X-HE-Tag: 1763630449-253478
X-HE-Meta: U2FsdGVkX18MQbOeyISKo1umTLEu6KKEyZ1nrC9mlJ9aupnJ2R0YpGpgVFEDdnXzMeb/utY7z9g9G5sFHCHLodJ/6lzbV6exFAuRZr947Od2pgJHJ7JTbwN1nsGmFTnwGUOiOoOTFM9EdKtqlf+9C/4iuQ1Tpg1B+abl1zHOa0xK9fAngdXqrv49lgoDFkHVJkl39nVIMcS22/yhn0eekHfgaeNBxBiFLSkBvgOT0oO01kElXcTfKzQ7bliOc5MD8r7dwWmV8phhlkhJe/GDdQVfkpqAtH9nP5nW4Bo1W0s1fhzkXfeSWycClefeweCN831SiqIstrvcswgdMjviGtNaWmO7M9dd7oZF5ISYUzZrM4AKBY/kPlw9HJeO9UQMIYo3BMPWHsBxeZTORRML9wlASmjFwCeCmZp0D5o+DrXB+uuKbUNDxg/YqrmiDviEh2lf3CJetvtqsi24iHZ3efT7NHJ4saDn8tuPjscMGCYiJCCISiHfaYKEI8jbtb0Zp27UR6QrNqYDjYtbfFP0/GMrctH/lXU/QDvhL23gTLhIeZUb7PVlyF6ad18VCkfToqM530Eai98WKH/2So3eqITgKTzHinFHi+KRY4z15CKFCjQgn8JKwAM7wwv0++gd+lSrxn+o9elVoIges42dI3fghMmJJpKl7+cS6L46dE90KsGPs/ZAoMZNEZZBEP+1+nFplhMHj1NduudcudCaJCg7NdOas+IO15K/jp4JcPOZctTcvgJ2waMMacmJ9JTWmWJBkIG2etFxZL1hFzmDjimKy3mR9p3BlY1AXmS/2rKO5OQzMD+SDRXYNjhgljWtBHSJTlrh5koaWxM1B8wweXhT0IwtL1ePuD9T4ZcyOp4CZhB9pZZqcnR7o1upolB0d0JXmIZx5G3ccdw5djNl0DpUbsGj5I/exLVAC3BfDVcMxSCmI+CaqWu9jnZ522AK+4WzNVqD+FUAWio0/zh
 O+A1fX1o
 zJIqE/9akEYSIy2PI6eC49Skuz7iErCBqpdWitlukv3vX0t56voROTwgTkTWXs2fYsev0LX+VA2ELoCzkxgQ+jFwdntJ0U1efMicSGJsavWgAUh8HnHhwE7jt5OeszBa4M2qX6xmYPSy/1yfIx4jZG4EnTPvke06xmtvjO6Lw7Bx9yuqO3DGTQBk9TIlSEkrdP4bR++kpuf9BMCG7IHGS0/cRbrcowP7+/zqpd0hAFcaoAZXvEniS7d8GA9J1wqO/y8XqpA4iJVXK7NYROXpPxv5gUQ/FLb5vc7W1Ewd2uN5bbB9qNH8zFvi6XAeuQ15i4khzA27Zbs7q+aUiqT2PtN13ZQAetK3C8F74GwZ3QZQRUCHhw7k2vFNJR/LrRg1iAy5JLeWGArFoxkQN1IZBNSLm0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 23:41, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> and so cannot discard significant bits.

I thought using min() was frowned upon and we were supposed to use 
min_t() instead to make it clear which type we want to use.

Do I misremember or have things changed?

Wasn't there a checkpatch warning that states exactly that?

-- 
Cheers

David

