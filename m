Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB24CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FAA6B00A3; Tue,  9 Jun 2026 05:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E1B6B00A4; Tue,  9 Jun 2026 05:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA12E6B00A5; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D51E16B00A3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:38:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98770163C4F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:38:00 +0000 (UTC)
X-FDA: 84859872720.06.EA12A3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD973C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:37:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q+Au3FIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780997878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qwucw59smD/DvO9rrlszZBUvmF6xEK7aWAcJM+Z/Or0=;
	b=EjKsi/5X+F8mQ6pc0a2D+ub0GMSr8rNbCJCWqxmmeyopbG3Ztl4poFWa+u9MjrP3H8L7f1
	gQDOpnz5nFz0KjlqAoatR5kfYBlm0VCCuWU6lVDEidm62ZRCqZSy9mG9030HMqnihlnT/4
	v10JDdCj8gPsynrT3BdE96gxKxnofLc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q+Au3FIt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780997878;
	b=hpU9CvEEOvmXsQEQnYGWO2wikOOtA6NPLJ7Ifa0s79BFMiF4oqzougOC+EfyNxmEQ8u/KK
	x7W5CRLZXV/9x8fL8SiA0kWAZfRaAeJUqBQTXugx4oi9w8JQ1vvaRNZadRXQz4CEyU7OyD
	dRk0sfIUotp+Gn3xon2Vdit/dKwffRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D526E4321E;
	Tue,  9 Jun 2026 09:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B21F00893;
	Tue,  9 Jun 2026 09:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780997877;
	bh=Qwucw59smD/DvO9rrlszZBUvmF6xEK7aWAcJM+Z/Or0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q+Au3FItnV7du1RLl4QATejS6hA1CyceafytEBvGMuQml68C9tuUZwoPCQPB0zRAC
	 buyqQFvTdHEl/zQ153mQLsgVrtjSn4vwEPyxhddme+E7dBwamiXU+J4kqrFiQwxxTs
	 9I4XlAguFmoe1oj5buy/ZzUmCMzdKZxLj9oQUoHLk26kUeH6J4Ha0YGjm+NdY/XOOK
	 8901TAkTc63VYP0MrqQMVZQ3enZdAGdZc29weefq3Dwf5qhNKCZI0wGAABGgcfx9Gv
	 lbtdIjlw0rRdSKldNnYxl203EN/R/YKJbndAYyt0Gm3J16Oix/0lq3FRPUM2IeLunm
	 X3PW5vaZTIVRw==
Message-ID: <93e279bb-3f83-4906-9eeb-277621f6893d@kernel.org>
Date: Tue, 9 Jun 2026 11:37:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context
 nodemask
To: Lorenzo Stoakes <ljs@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 chenridong@huaweicloud.com, akpm@linux-foundation.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rientjes@google.com, chrisl@kernel.org,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 jackmanb@google.com, ziy@nvidia.com
References: <20260609002919.3967782-1-gourry@gourry.net>
 <aifDlU96HSRy72Rb@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aifDlU96HSRy72Rb@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD973C0002
X-Stat-Signature: 6kuf96hz8pw4xm4itxhqh3z5b9sb8pki
X-Rspam-User: 
X-HE-Tag: 1780997878-954693
X-HE-Meta: U2FsdGVkX1+/3lcZ2YofSSg+154TJJUbCV8TlFrMKruKqyXX3H2Up21b2IeYjw5cNHpu5ikwrBfB9WXkZhgSZVjkOh2COEGybV0A0CRi20gaAlf+lN6XJSIGAHxSt0vxFvO98lSM+MwIkfNmFXZXLGtx3dKsMR+jsmO8q/EsjMi25YWIM1aWGJadDtoinqssCmzVyPAMAHTohoehmtml+ySERiO32J5NbWTIe8SM1c8bFZnDv9xAKFfQKmzq7wuUdknQ7EQtgulqN/0I7CevKp7H11H3NOagrGmX/za2Lv6I6eW+YJuMrrz/5WnHejPzhicWEJWVDLRZsQ0Nml57nysXLWtb0qcRf7z5DK5EuShkzaAPqXy/zsYmCSVK2Zkq/6/iOBCePxufrR/dHxTALxsBW3tGlA7//Edor6b2UWC1obNChUe+vPWsKvytpgQZ3yvI/3DVtwXSNkEUMz239o16J0/AKLX1Fv4ZtM1uWk65/rn4CrBZMacUVNhRtAtEebCDpsac4gaJC/fIYBGM+pKcghInUXbfhGqWzo372jWyEZLwEfDB1NOpLOTGkP1QAlQdF5wm6IhnAuE2WrucEFDm9clcq+hRJ93gBsfz5y4mI+hljjVnCDf3Uhk5OVuoMX1RFrfh2QJyZ/Z34wqfMWq7kkeWM0i/t+BPXIB1FIZvA12vWQNkeYwFm6+iTAuesHwoqq6xvwPVv44YhrZPmMF6rxell/jfZYaLn9hkvrB+F6I16NxnZTod60nDtJbd7AlqoSrotGbjdfsKjX/jc5DBYnL8rf/GEkSmtuNgp6cCWZfaxPM0OxZo/FQVsXjy1YkCkb4c2zNgKaAqATJKT66ZVv9yedPuu55wZC7/xK4hyKzmqn/AgOcHpCp/Lp9DJ3wx1oAdC8Kia4EhRrHzX1I/D6fe+rkDzBxpQbSAuvNW+sxRupP6/JqutGgrh12thqm0xpdwRaWBgDGrlIl
 uHO9BreO
 KsQfccZSMnr0fxPIUwNwBVLti7qKpw0PfBmPd2xycjGUc3BgGE0uGde0srlvCjIdK25DzIqAXBUVZyhntiOL+brxZhAc2t7hJSXl22ushGP7jHowLBcFKFwSiQr6RsBwe6N1KCik+n6EWQth7G6CE7J39+K8D0XbCHTXV+duaDqKsP7iMd4u3i1IKVvJJHzHe+NuSCwWMCaINFlC6OdGgcj1hPgqPD1JLgLqWVYZaldrugLwnYtAqKwua9b6gLl5GKpPUskBpTtjEqBtZfZ2mtP38u2vhuPyv4B2CPRvNHdsF8UXq9dVVZKSClcmhnmkZxbDfPpXO+aBJTcEuYRI8lRVA61CujP1ZmsMfk7I2PA7UA7sr40xeMx9ebTgAVi0VCzBZlIj7C4dIHKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 09:41, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 08:29:19PM -0400, Gregory Price wrote:
>> The nodemasks in these structures may come from a variety of sources,
>> including tasks and cpusets - and should never be modified by any code
>> when being passed around inside another context.
>>
>> Signed-off-by: Gregory Price <gourry@gourry.net>
> 
> Thanks for doing this, it's nice to gradually up our const correctness game
> (as much as C can ever be const correct :)

+1

> 
> LGTM, builds locally too, so:
> 

Nice.

> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

