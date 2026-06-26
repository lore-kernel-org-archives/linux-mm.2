Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55D4CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 11:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7456B0123; Fri, 26 Jun 2026 07:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF6C6B0124; Fri, 26 Jun 2026 07:14:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0846B0125; Fri, 26 Jun 2026 07:14:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 873A26B0123
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 07:14:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05C96120410
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:14:15 +0000 (UTC)
X-FDA: 84921804870.05.DD1FD4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4616B20003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:14:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtYfFDMb;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782472453;
	b=F2KKA6F9Cmcj+Qar0kgUz2Clb5+h6Ea3/wEmAb1jJBDi+EKlGcNVZfm9oXBRJ7dzna3FFk
	B6qlKYXZUsPgCQYXj19l445iO1GqKtpFyC8nsMGueZlY8LR6ELhRhP11odhHuNWN8stOS6
	9IgM+Kp7mVaz8gmT1aGrKaZux2n776g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782472453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkLoybXTfezIlsdwsuEtEbzAWgE+RILpwfWU/sPIuWA=;
	b=JMhUYOVixAfbzbgUPUSZE1TCvewyUSvwo2l/dbBziiwALlP0KsQCFXhEzm9VRnANFEJcnf
	8CZxN28wUtYB3mQ+qVpGKQtR4mPKxcmwt8pUh2lWiqzEFGRwJtF4gI4mC/bMQ0xDTKnXGi
	cIWuMN3pxBLzZd3rBg2iJRQISDiA+98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TtYfFDMb;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B280360098;
	Fri, 26 Jun 2026 11:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA5B1F000E9;
	Fri, 26 Jun 2026 11:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782472452;
	bh=fkLoybXTfezIlsdwsuEtEbzAWgE+RILpwfWU/sPIuWA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TtYfFDMbibXE/aQtux0dRDDpsDLX9HbZGssUTgE1amA6JEkqCrj+Qb4/A/UYH1on1
	 Q0vvlU2sK4Q11H3ZoEgbtEA9T8ZToDEAnP1UprlkorFQnfEPAnnG2XQwutyivg6afG
	 kcIH2dq8l3d8VII7Mw8sAG82MQImnxDu+NDDL9yyIhPE6cW8QTIws8eoYeQjDyzffu
	 a9tHAcg/zSXFdNp57PEl3JlopVVfAbM58+Qxw7rYa4itOcSZRJWda7FcwI1e901mh9
	 Kwy5X9uQi4fdhNDfjuJLd5ZcbfF5ijML3CZuWM2KbeI4wkAakaVFSODLRkaDzow0pV
	 9H+kEEHi7sKNQ==
Message-ID: <45961106-ac2d-4916-b750-448b9cfda5b5@kernel.org>
Date: Fri, 26 Jun 2026 13:14:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempool: Untangle CONFIG_SLUB_DEBUG_ON abuse and
 switch to static key
Content-Language: en-US
To: lirongqing <lirongqing@baidu.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Matthew Wilcox <willy@infradead.org>, Usama Arif <usama.arif@linux.dev>
References: <20260604110318.2089-1-lirongqing@baidu.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260604110318.2089-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4616B20003
X-Stat-Signature: ttqzreoe1xun63prg86gqtojykqoj7mw
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782472453-179420
X-HE-Meta: U2FsdGVkX18c8NOHKrQlFRjejmu0erj0TFi1FbrO4gjDRfWk9zoSDSGjlVS0WcUdayYZov9ngokZOh3ZmogfHp2ozQyC4AVNTFdk+162Grs909P5smGRVqjduJPYNTtjvrU/4USrqXe92MXwd0JfU/wKdxjd0C0/FWGs/LPL68l+kFI0KKLZJgcZJIWXHeeuW3cZnWOBPphuvBYlA2AJBV4xCrXLed82lG7Rs4/Yg45VPptzOervHR24Rfi0G4fjSDjvOlQj3UvAUncpz0yRQRZIMovLpPPexsNmaCwQvl3MF/s7dL6CYg09beVFVXD83cnyzKW22Bt7n1zMHga/m/QX2Pxf7GxwzYzKFKfLP94mjheaPghO4FF1LIPQb3aq6lE9E7BaYLUtfrZP3Y+yPSe6rl8d//IG75HofCL/KX7jEhYtsHEYak0lS/8EoqVXolUXB+944NMkZto5DH2kmReZz6FRe0mI7iR+OUpRu8M/78UzQ3d1GaZq+y0ONIhxiO7yWyhJsNm58zf/RRkMx4Q81iewSb+D1RJDuMyJu1sMAqAGThk2W8lCIJGKwkFu2omNnU9polrS2fV4/iJxVVLBrKMsJZHAXMySq0Z5jXmkC+W4ddexaF/+w/lK93TIwAuIP6UG8Kz5v1R7Nj0Rk37GLB/eBYgIrocW6xA/aehnXbk0HMv5CqVMD4BD5eUwiVwFQ/j+JoV3k34b8DYlFA4Y21/IKDH+xMYOQtiyX0/UCNBm4d9Jgb4NyxPlkmB0uWlvnUKKa2K9ZqtBlUhViAgFin84ezeZLPEOckJMyw998Sm8JOVOYJEXhANkKUMVmT0US2XHwVIqxD0mQ11QuZapniV71VeQ5G4OcNueyOBRgw4mVpykAy+fqwLY0oKItORRLoSOss1OdtfUZTCWzr0AmYOoZ3jsBSPyyxbgCg61EZg85cYqULkd2BULbF7P5SjKMODDB9p8cFeECND
 hGVAUsF1
 5/chL+qw19k28AQBb5cDhx/dc+mNz69lYxbiSuZ2OzC99YnYXtDRvuXWixfp/rDSHHkBz1OjTwPnzQuYlGSh6cXqrAwWr8qSTYcPxO0kUmTLbVH3fhEkm/tS+6QG62G7hkliCaIzLaAvqJsTfVR/SrBOedbnbik/ffsoMQWkqOezkM5KwcKR+zMkxk/uRM+09xYT1u5rmswWwG0jnDSISYtYrVDggc+hnG/24qYlrHgjejhTzOi5L4lz1rGwx8HFVynRA5iH6h4L/WCLiCY4Ah12f+lbJ463NxuwRR3jFUCs0FB8KvVK4y/wqZmeC+hSqMkSOqapP9NgMVIvVCcuHdU0TQcnYiMve3nxTFC5XaxUW6rDu58Rhtn+MYUdRfuFhtyQ/WgL6/VVM2Qs+hC91AsD1ye8zaZzFSV33/GRv4q1yCf01uQ+m0/njZPml3J2fxYwMMgJylLsVJfVbq+yrjnwa7EiF+wSEZAEm3dKq0onTINxxCSY5YGqM/KcleioCZdq7+NqZEaQMpR39ONRBOob7LxsjN8v0C6mzEcdLVsql8M9phQ3X/fe6Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/4/26 13:03, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The mempool subsystem historically wrapped its debugging logic inside an
> merely defines compile-time defaults for SLUB and caused two flaws:
> 
> 1. On production kernels where CONFIG_SLUB_DEBUG=y but
>    CONFIG_SLUB_DEBUG_ON=n, mempool debugging was completely compiled out
>    at compile time.
> 2. On kernels with CONFIG_SLUB_DEBUG_ON=y, mempool debugging stayed active
>    even if a user explicitly disabled slub debugging at boot time.
> 
> Clean up this mess by removing the #ifdef and switching to a runtime static
> key (mempool_debug_enabled), allowing mempool debugging to be toggled
> cleanly via its own boot parameter.
> 
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Hao Li <hao.li@linux.dev>
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Usama Arif <usama.arif@linux.dev>

Added to slab/for-7.3/misc, will exponse to -next after 7.2-rc1.
Thanks!


