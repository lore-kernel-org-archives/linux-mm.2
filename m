Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA664C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 01:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D68A6B0088; Sun, 19 Jul 2026 21:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287ED6B008A; Sun, 19 Jul 2026 21:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1576B008C; Sun, 19 Jul 2026 21:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CED886B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 21:27:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49B4FA0F50
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:27:05 +0000 (UTC)
X-FDA: 85007416410.17.3A8BA5E
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5AD57120002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:27:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ar7IcKin;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784510823;
	b=AtJXhElm40Wq61wPQYcXl7HYqMO0a0sWgbc59pqlkOd8m7WbxA+ZAcNAUmFrHvANAhRRi1
	uUOr7HyKPLbnF8oPZjUKQ3IJc16CZZxUOiPRBIU7riSKoTA8OzEi3FZTSbtjCCXID5tlHI
	MDcirS0NtzjOxa+382gW6cvXMYsHn8U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ar7IcKin;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784510823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFiv0hXx9c1wz+9oCFT2VYuHi8ADjSyN7c0ptHnERB4=;
	b=5C0zztjQ8fYXRvbRHdTPDg9Pnbs/VH+iynBT6e/Hn1+0lLrnUyYX2t6nTff2DxlxxK8vFa
	5YUi4+r6EPXGju6Tsfo6UCEaQ6Q5bnC0eSYI3c0R3/LWWDOYljS+jYxWkOMcKbwrVncziH
	Q59wajoaFcFZc5Zbcbe0u93g2y07Cc8=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caf228a910so74618775ad.2
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784510822; x=1785115622; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BFiv0hXx9c1wz+9oCFT2VYuHi8ADjSyN7c0ptHnERB4=;
        b=Ar7IcKin8NyLbJ5ENTF+M8dCXz1KhUjm9W9L0A7zeKVVCT4Qxd1PYP+8Ikv+ofGytl
         quiVZwtqytlDRQWHMZRNkAe4KBvFrOotysIT8Z48S4PwBzSzcAvs61ulD+Stvo+B2Hbr
         gCaSMvYYNRDPfElF6O8voDbQ9HNK911mY2sP+OWwi9eYVBgEuXrSg0Y24VV02vbfcwPX
         +u1YbhO59rMITytU0qPI25eqBWFQpoVLfwuCorzrskjllg5otuoBqJbYMwH4khfAj2Pz
         Un0B7FeRBVf//Thfb604kJZpePfnJCLC6AXtMIJmPEikkn6vdtaFgL1FWkt9j6Vv8bB8
         xAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784510822; x=1785115622;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BFiv0hXx9c1wz+9oCFT2VYuHi8ADjSyN7c0ptHnERB4=;
        b=XrSTvNXmhh35IRBJXM1ATcYYswozPc1RqGUq2bbi2o0LBxQoTvr9qoDKPDkywVFvTV
         hnyoT+n5Bjv6U1Cfj+9G1K1YkdU9jnFXG5Bb8dTrjKbYciW0mHSNVXf/N2I2gejh3Qa9
         0Vd31jE7EZpFWZ2+o+hUMTS56WYEXKwcMV2rzSOr+BHSEUoRnCH1qLFIaXOD172V7ZGa
         9DqhfkF/Uw0SwYf+ktdt7Jnl91NPiyD/Zr+lkvMB8o38YeWYgxJfXt/bo1wEkAXo8j2K
         twRZ+fH2Gr2H1nEbCAA4wricE6zHT1LRXLxa90ua7lMLITyVdgUc9DUSXC6AS8vBlgRN
         MHbw==
X-Forwarded-Encrypted: i=1; AHgh+RqxFoEHujeUCx1tGNqaHdxLdGdEZXSKBwIH81pIMozOeo50hgq14Ep/CskGyY9EibLQrkuqs2DXng==@kvack.org
X-Gm-Message-State: AOJu0Ywky8+LqDSFlnRrHpPsAoRNjMkgi5Lrj/8E/RHAGJo9avuUFqJ+
	9Yiz/yW0d40BNvNUWfnPDGZWkMDCkRvLzjTccUeOQZ+17PJ6GIUJ5ySJ
X-Gm-Gg: AfdE7cn2CAwIFZlQNg23++edDjoUwv4wNa+71/hpFOVIfk7OircSTKBiH146if8BLYo
	asySVRnXXMs5WwTo82v4TldBAMpjCzfFE2OJg2WQKwblAyBYRrK33OdiXRSVKQGfpLgLlenOiCd
	pgijcsFP26bqmykUFoi9ctHpIB7q3zuzdPz5+ykjzEMalmjwQcKQVoLpDkCC9dm0j7qIf8y9nd6
	BE6kI92fOHJtmMTbT0BGMbuRaoUV+J4MHrngPDghen2kqY7AbMv+EfLZgjA3Yz+XLMh7E92mCu8
	Wdfy/4nFpkj3hdmQMKIV9wNsHvAiDZK2xmKcfKTAK/lb/tcqw8HruDPBIxv/5dZ8aDVjgfR4Xbe
	t9sNf+72ZR6a61WqhU+KRkC+1+Hsl5hI4xG7RAC3kTiDrsIiAqnPe1TM5adLUJ14/r+MEU18cmw
	ZkRvijVUa5pKL4aZ2s87j9DItxKtRvaWNodoMtHroC6cQ=
X-Received: by 2002:a17:903:2ec5:b0:2cc:77f3:a927 with SMTP id d9443c01a7336-2cf34961e63mr155206525ad.26.1784510821982;
        Sun, 19 Jul 2026 18:27:01 -0700 (PDT)
Received: from [10.125.192.64] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347554a2sm48005765ad.73.2026.07.19.18.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 18:27:01 -0700 (PDT)
Message-ID: <7dbde343-fbbf-6a1d-1785-ebf9f5a04f6b@gmail.com>
Date: Mon, 20 Jul 2026 09:26:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global
 shrinker
To: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
 <CAO9r8zOrXqsEaCEJUUAxbAhhN_OQb8ejogeUa6k8hX_JV8hxxw@mail.gmail.com>
 <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <20260717214031.8b22e9a37ea3b0c564b466f0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5AD57120002
X-Stat-Signature: tqyrgfmyrf7btwesbwqxtazu1wzwedm6
X-HE-Tag: 1784510823-33277
X-HE-Meta: U2FsdGVkX1+e9nOkAUHNUKHVF15Z2phZOoIhrKpEyfKm3W+vT24JtqSzoFUbTtQv3ccDZb69WKSAPIgQHWegsXsb5r05X5/tQV3tY4WjYjQU9RTjwoM7AFlRQvdICdLVerMCS7MxzYiuATaEhohsCPYmChbrJ2Z0ES9T89/ZJ3THrhwM8BtQI6/l0F8l4LPpa/CI13BusiQQ5uzX8amiVGO3S0RUejZq/ncyCuETHEOLkmwuNrNJSXNCXO7LXFlhVSMwjwrFZ8d3G4i0tv/p5Pa/L8gipAVmVrcgwAy0roXQf1GNadZmTWqEqwFHiQYs+SQupBKWlnB4I6posWFgzIwCVdqI/Mazs+wiJsHbVi5OryDKisx6W/XtnKeaErrdtxgLwi0IwOso2hDCN6bzuV/kra29H7Ey1waFrHtrotc9I2LMXKSAbJBhljuPczHXtIgQzT2DHzidfLiiAiuYBkS+qK1gFOjVzprnFbV4OV1nJrGTzmziKIpdHZGJfs4RioK3WhF7d+k5g9r6w+jHiaJ+odLEwnVvrCRnlv/3KKkSEd7RImZndu21E8HXzgaOnV2Xi9+K0TtP2vocVOaeAlKUy2jAH13ReZCNu73wPB7HQQlAkeMnQ/7RR/ToAB8p9WmKjqYiccYFcHroVRQBgEzCUaKEkU4eMCLDRK+YqwJY46CH2SnH7RIoMnXpnEvjzfCXKQQ8bVhB7WnhWhj43O5iS3gfkFCCrIgVMAnYuXUzrGZciUOr1iQS8+QRf5FrnflHa5KqkWv8C9BtzZ+28P8wbEatRb/QdIJ0v5s0cP+l0YVj7qQfTSM7dVj/3jdN1ldNwaXXTQLxI0vHxmPVGPPpg/cN9QlsQkZc0oqx+L7oDQoCGm1QfO7Ua8G351MOfGWdJ9cAg8OaFEguQHSU5jgFg+9ecpZxI9BB9LbB9MQFNKh4J3S6q2MTk5+EG91lNBlvQQ2lIAxX1k9WXlo
 0wcxfab6
 YL9OL8Tpcix7i3zWlGTqiyJUMO7PeFm2ISmIlw1hgHP+OwAAlGyEAv53kVlmkPCzjItT0iEsL2PnJVt3hhhBsF7Lg1fJkGU80bJCWOktwgtrJrko2PN/3Mdc5hUEbjdH0upV1fAhjiRaO29IlORAdUHIBZwtYRtSMuvjVe0F11LFsfGd4FfqzTMH5iu1MXlF+8nGQswKW7+S9F7P669GnzTYVczWNp+Ga0u9QpVMwfoioCzIX7Wzo6I3WXDzEwbkSFaBYoYEf3vFMwI2R7v5hddBnkNgAnKuISvGTR3SPrBs1fwYPQv+hsxov7p3e2rHvCYZgc6PXVonQBBs4MtTTXGl7P/0V0LSfr4F6yjUtS3RRv4dRIz7iDF3DtDRunHdaiqUcYMwGoS6ZaIOX4O0iwlgeX5zwyFQax4kH2QUrcSONj6NPQ1kQ9BNR1BcJY+aY4LvnW5vGc/i0U9NC7B1WIoJuPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/18 12:40, Andrew Morton wrote:
> On Fri, 17 Jul 2026 18:28:04 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> 
>>>
>>> The [1/2] changelog lacks a description of how the flaw impacts users.
>>> Please describe this fully and maintain that info within the
>>> changelogging.  This info helps -stable maintainers and others
>>> understand why we're proposing a backport and helps myself and others
>>> with timing decisions.
>>
>> The first line in the changelog should be sufficient imo: "Zswap
>> writeback on hitting the pool limit is broken when memory cgroup is
>> disabled"
> 
> "broken"?  Perhaps this means "fails to occur".
> 
> But what is the userspace-visible impact?  IOW, why are we proposing a
> backport?
> 

Perhaps the first paragraph of the commit1 message could be modified as 
follows? I have added a description of the issues that occur without 
this patch.

Zswap writeback on hitting the pool limit fails to occur when memory 
cgroup is disabled, because mem_cgroup_iter() always returns NULL. 
Therefore, the global shrinker shrink_worker() always takes the !memcg 
branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives 
up, so it fails to write back anything. As a result, once the pool 
reaches the zswap limit, every subsequent zswap shrink work run is a 
no-op. This leads to zswap store failures, forcing pages to bypass zswap 
and be written directly to the backing swap device, which can trigger 
issues such as LRU inversion.


Thanks,
Hao

