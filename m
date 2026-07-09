Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C536FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 09:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2066B0093; Thu,  9 Jul 2026 05:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72BB6B0095; Thu,  9 Jul 2026 05:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963986B0096; Thu,  9 Jul 2026 05:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3E86B0093
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 05:59:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0A40A0443
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:59:17 +0000 (UTC)
X-FDA: 84968790354.19.250C21E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2989B80003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:59:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dExGaf5Q;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMFPUfubpTUqqjgZWLJP4z/dS5j2QFCMuHdsl8oXIgE=;
	b=33NDpmRerNmon0w0mbmLBV0sx1bLJzDMxokxbt58aRMlQY6E0MdNuFUy3XF1vSWcq5j8h+
	xuEg8MV1aHi+0C0/tnaxnfq6lb0jiWMUKWC0/TNrgFIAchSyO/9VCPNqKnrx6xsA3v3oon
	p6Cnw8e8ZdCmo8aLkIxL899xDN6S8Cw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dExGaf5Q;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591156;
	b=JqWTtM+viwfk/xGqLCnXvMXYqoTEoTlr0W76Q6AvB2mDrD4aqi3WONqbVVxQSRuxk15sMP
	Up3gwsxIVnVExFEOVYgs7BDGc0RTPE6wFZHAG1Nu+PVWmDq3xaVAWpRg+UZPPYBwCVe5ib
	tCoFEc3JASvYE5qxr5ganIPlnskzpq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DFB64063C;
	Thu,  9 Jul 2026 09:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BA81F000E9;
	Thu,  9 Jul 2026 09:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591155;
	bh=DMFPUfubpTUqqjgZWLJP4z/dS5j2QFCMuHdsl8oXIgE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dExGaf5Q8RdDWbn69Ukl/DgYVpNelCUOqtGeHH/lNMOOd9ucomy6B+dwsxJPGkiLc
	 rleITgoVMnHxhjsr94C6gUQLvYb0SySD+Pgii6Ca1uo3W0qCVZFulhUfhUl+E2dQF+
	 QPT4a0egAx01r4y84WjWWjv9zqoHCIEB3nDxzvMaNJA1ZOjte7yk2dOqa3VMKbEpHL
	 4NwQbyY/SYnBZO+Cvt82MWkYcxSNEnLPJlx5OGYD9JY44BS/YgEKY1739X2LwUoQnh
	 Tk+EOjR0EZUU8O608frDUhAPWwF4EBMtlvgJDQqrDWLCuPVkNBax7ktBuo7UN9+49f
	 0YOR8b1i9TskQ==
Message-ID: <48ab1aa2-4743-4671-8600-2e51cbb48dfe@kernel.org>
Date: Thu, 9 Jul 2026 11:59:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ksm: Use precise linear_page_index instead of the
 whole address space
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260709173312403qgj1Af6pRkFMDSsmc19sM@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709173312403qgj1Af6pRkFMDSsmc19sM@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2989B80003
X-Stat-Signature: e9bznothetqw8s4ngrda7fmxexeg4brc
X-HE-Tag: 1783591156-743776
X-HE-Meta: U2FsdGVkX1+tbDtwQr1wTT7pALZ9qiB31Hp9n659p0017DsjN4SKoGKQhG0QNEqZfNTrU4bx+z9UbS0AZPvrQzvnfYiHn6j1SG0V6MQthXH8dWfptZOSbHBTj3CNePcs4AtlLbhHkIkx16QlBSiY62bMkHOb4GEiPcF2DJvGsvoZekalLCLDQT2X5VjzyGI8ET32B/k77NB3nHVdSTp8snj2gY3/eSWD8Oxqm3+ZYXIQuqYebosskaqiMFcHZBJ4p7GMRGhDJM66SUU9UrXL2bYDs9q9iFh4tp7W3J2V/r6BQZG5YgETTgWhdBfxTwxoEH4KhwlvUwZvmmP9VaVGZdwdkpra6bVdlXq0vlT3rRMezA0Y86271dq3y4KHmTDoId91Z+t3VJQmqkv0hcwJWQpalIXUczsFBUeH6J8YBLDGeBH5NF97X4FTosN0nVYOmxltuwudQFiQzHKoMuRpAdCxAorhkCFL7w59SqxL3xAS2pLlx7k8YJagqpayj4TkofPGrQVSf/qkuZrST0e2qe3HijWv+e0b7kr1mVb1a1eahonvMOmypIwyGm4snWhGZxOcZNHDybz7uxwX0AUEPl/UJIbrlPCStJMRnDfENqPvNUKUqc3Xw6Pvelitv+49+U7I7uB+koCxXzwHGtyJMoGcYuJg14rcoC891az48xClLK7SUcOczP0j+rFbUrQLx4NL36JMtkXZUu/tCWVEpOBe9k4ef709P4QkkklxgHreRI4II7ClEUt9QinkWxI0fHNJBgEqpzbVHDpQtz38NdiRrHQ8DTidNCMSl4S7VI5+lvAnw5uRFt8pLdmq7FVp/qQE2uhLuqfndqHldq4mKzc/nnh2kO524652XwC/D8FHENlTJdc22Bv9kRveDmERwbLtGqku00giNpJgxPPLkib5mzw2Pz2h8z9z5JQzY/EVRcycdE2Q1j6xZL4u4JQ4jlHCI6/B0A1z11LYiNg
 ivxMBF8S
 wxp82w+9TwGmYPtEhVPPbhOsgu/0g5dJIJV2IWcoa95L4UWVrblnFMwB8roXxDwyeKIDuSM93evLCDm0Qz+lw0gueCs68EuysQZZWie3yGUBlu5oSRyXP4f/UxyVlYWXihd4Q2DXRUHiIKlptwVyyYKE263w8/KEHswHV0X8Jei2GdntkTxoqBFHo3d+mTpaekUJ03D9Y5kNYdi3bZI1RfhGvyq9zUtQyzFxhjahaMNJpGas8fdfnlFCYknkaQWo4k5nDxkCsfnAkny2X8Pgn87EIBNyH1aJUikAAbdj5EcBpsv43Fjuq8DB5maETx6/J6Rf9PhFEbGsg38qNP+2u396fjsUp0dAifvULwKp2EV9csI5q+6CPMuqQXrRtkciSo2XQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 11:33, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Since we now have linear_page_index available that we can use here,
> allowing for optimizing the RMAP walk, we can also use it to locate
> more precisely all related-processes when error hits the KSM page,
> which will decrease a lot of invalid iterations.
> 
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

