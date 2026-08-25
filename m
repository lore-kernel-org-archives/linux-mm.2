Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F04C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCFAE6B0096; Tue, 25 Aug 2026 05:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7976B0098; Tue, 25 Aug 2026 05:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD826B0099; Tue, 25 Aug 2026 05:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACE8D6B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:30:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0A321C1695
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:30:58 +0000 (UTC)
X-FDA: 85139272596.16.779D0F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 16B934000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:30:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8mqEMXw;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787650257;
	b=lVixR3+FUCMRiX11UjX6jR2D50oNInQbD3l6X+gCWY5gZm7Ne48w6egMRZ0/UJhQLQ3MOM
	7UbMLiriXUo9p8LzXiJ4r82JloL7uzeqgunLTt3oliI/rbY9yPtMIcrBRZ1eYzIcjZ/oR7
	079TNEXeZ8hAkxNz3PdMv4i7Wh3ng0Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a8mqEMXw;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787650257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gh8/pecl272MBCAYPbJmmBSjqy/rlKlt0zMBNAm1cvg=;
	b=MZSRXFryG331CmUQhtdKjrFyIHlfQlM/ithRE1Z9omW1NTfnB7ZrA8P3pQREZvOMzJ6tAu
	lo/33NEQBecS9wwSkycYHCu16rBep8yj43b56g1Oywj9l96cjd31ZoMzqVEXeAqnBNCzRo
	vWmbcdW7bj2zkjZywysF7pZ/0HvHpbU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4311C6020E;
	Tue, 25 Aug 2026 09:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E541F00A3A;
	Tue, 25 Aug 2026 09:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787650256;
	bh=gh8/pecl272MBCAYPbJmmBSjqy/rlKlt0zMBNAm1cvg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=a8mqEMXw4UyHnqOLnccP4+hpmDVIOsw7ZQImwS/L9gT2NlupjBoCQDTVUG9Hl68qJ
	 8PO1Tbu/xoxaK6FYrmAaouXBACePTcX2aFubpuWAvbMBvub3Wp/RvSzrDlUp4u30j7
	 Sy74OmDng0L55vIMACt2sq+Z3dewQ5Y1Zom5aTzHkkQ39iypYgFycih2PbXrYNsdjW
	 PjSuXy5eqvK3KbUNXrSlkjI/HiAIk8dFr+I1LI2ys2LOlCPc04bM0i2KBa8M1SaSNG
	 FvOX7GPnWI21Vd/3y9Z3h+TiLQuA9Ic9voS94dISAY2vkEDoIwDTZYXbAA0jwGccv8
	 392i9RZYIyrhg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 04/17] mm/sparse-vmemmap: initialize shared tail
 vmemmap pages on allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 David Laight <david.laight.linux@gmail.com>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260825084608.47437-5-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-5-songmuchun@bytedance.com>
Date: Tue, 25 Aug 2026 12:30:45 +0300
Message-Id: <178765024511.3691569.7297082667315232689.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 16B934000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ga7f1gmqsf5k93rpcrwsun117zddh8rg
X-HE-Tag: 1787650256-896637
X-HE-Meta: U2FsdGVkX18fwidr2cViioMGf6uYLoa23Y2vgHhlwd6Om73WIiftNfMEOTkUHvcgqx6zOQQzgh6ifbEu0BMgz79uCtQu12SdPeD/hh14MBP/81XbIWFghIQMflFdjl9qct3TtCChUeHl44uMNUYqOGsGcZ5SF4YpGdY3BEVVrADAtUZmXnZyHhPCHmQ2rmDfGw1KGxEjw3aD/M/wCTcYVH7umSVBdAAhR3Tr5p9HcLRqP7JHPqIrAkimv/Rxy6qHhjN6G0OCSUrtLSnxNxZ4N9bp2GTXiMxgzZKACCijoaEZKRg/9oBZwDGWR7tzkC79ZQaIB0mibhRLujxgj7FJkqmNAu7cqc1GTGYJG5nh187a47Bn7CBPBg6vkiEIlb2iInWE1Cfnf9au2gqa0ing03Mreg8SQmvmy5PG6cfSoJVjp16mcBBEBS4JG0YEtapsseDmAvja4ITtqbQ87L8oe3bUCmn5RjsZnLBLhgOYqvg1yMUfgM6wpjEQ91MQV8RzmJnNf3VkSF7MKnCQx+/pmWO2uD+CtrrY0jCNla4MAMvwDv5LIF7HJ0v9TYR+BjSqprCLMfwPvHw7btEhVPM82hdAhg7IH5HcpohIJXkjasWvRROrofxKzaQwe+q61DW55ozBlcaLqMXWoa1ZHm2afXVERElDUVD2TErpMCjSMTLfdvyKQ8Ba+pY5ZJ1UDvdSCnsAvSTbgo1tqiJqpdSXLJUvfNTN7W28oYrZ5gHJi/ykQeKqThSdu/L9kvr/0lzoZDmfczSXn9Yc7+FYoJ69Pp6dS6Ep+f2mnao8U4O0HGAfRDkWOsmbpcHdHSv40TR7NTvt2mnrWaVGATsEl2w/iVA9PrOhQgKilfhEH2saY6V7512gUSvbjsjBfZ4c18FW5IMhdOvQJ/sh/1lU5J09tDSo3lCIXTRBJ0vUWttL+j3ZNflW3ArUo7/vuO5gm3ZMLsQIqnaINdGsbQLbQUu
 Y2poupW7
 V9HocZKo+HMTFtr8lXd5j1U5apkhFWgLZmNeeXjK+58ewIY+o7gam3rPcT+xGntkkpMkM41CAlW9SXBrb5TjICRLNoIy6jcAs9SbG+4kCqANAEAhPDXDgs88/EUTfmOJMqveX1VXIEe0cWWUwLY4NORtiOdCyctLnxzZGFrJDU0gKTPQY5zWtaaWNhAcflPBLsZ90DzR7CZ3vLHGdYyGimBnEd8IV/39nH3nbuSDWKVwm4bHABl7IoEbsQKt6Bp2DE3wUs65Iur4vUxqSanWb3TsYbwTej9YB+/gDK8rlm66FYWftV8/+5aMwnhShPeQ0fBtGw8e9Jrpu56QYfinHHBg9Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 16:45:55 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> The shared tail vmemmap page allocated in vmemmap_get_tail() used to be
> left uninitialized, because memmap_init_range() would later overwrite
> it.  That forced users such as HugeTLB to defer the initialization to
> their own setup paths.
> 
> Now that memmap_init_range() skips shared tail vmemmap pages, initialize
> them immediately in vmemmap_get_tail() with init_compound_tail()
> instead.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


