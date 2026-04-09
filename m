Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE596F364AD
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A18A6B0005; Thu,  9 Apr 2026 14:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0530B6B0089; Thu,  9 Apr 2026 14:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAAF06B008A; Thu,  9 Apr 2026 14:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D94AD6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:23:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8839CE02EF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:23:06 +0000 (UTC)
X-FDA: 84639839172.24.85E57D2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 387D640017
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:23:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N6nGOESL;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tp1d8ZS+UHvbq4+BjkPrR72AeyAn3NvEQozPe2yXurA=;
	b=unrwxdgiVGwVcE1R76yDBi8+HlQjTBM+E1luoaPPzK9FByElBqhhSBaAFmqF54XUz2Qi+I
	Qmk4v91ptqbDGQb1gkyRvnOMuHAxi/abDimeqOgkDjFMIEqBodSykMSUB7Yako8b7X84Yk
	FM8UXzC+AlFNtU1MNGaIZU711sbMmzE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N6nGOESL;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775758984; a=rsa-sha256;
	cv=none;
	b=NtT3qSSMrNsws8A3zK0fYFAU+0oBbGKRN1Q2n/ef4I8vhczpd6oabOvY5xWNDA1z1LzP8D
	hZUXchTRYAGJyIx9TtfWLQbtSyV8SG8AZDI5R7WZYMYa26GZEzDbudiYo1CTTmdUtrCJ9a
	s3uMPdZ7f9UiF7LbL8eBJdjA8j4LDrA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775758983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tp1d8ZS+UHvbq4+BjkPrR72AeyAn3NvEQozPe2yXurA=;
	b=N6nGOESLOR4718/3EbzZn8d8kH4NpJuQlvV8I1bGzNqgS0hNquCF6BEBYC/PNnzZNWP6k3
	ke8pHa76ZGm0qevRiDX8SYLpT3shoAgevb0d3sQ/zQfJvrUENgUNJdCWF26NaZeCuP4tyg
	UimpdXlXObuHvH6t2+loT/FdE5c5VB8=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-YD7AC6GiPHWc3--sjPiTyg-1; Thu, 09 Apr 2026 14:23:02 -0400
X-MC-Unique: YD7AC6GiPHWc3--sjPiTyg-1
X-Mimecast-MFC-AGG-ID: YD7AC6GiPHWc3--sjPiTyg_1775758982
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8d65190e52fso214608885a.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 11:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775758982; x=1776363782;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tp1d8ZS+UHvbq4+BjkPrR72AeyAn3NvEQozPe2yXurA=;
        b=pJqKKEOqXEEv8G2d+Tll73nwnw3GVvevuvp2q6OFOU1k03HnNULsPHtnWKHu7LFtFs
         B8vRdblBg1/O0QrfW2F0tdFY3Auh2yM8Q5LRizC8XWD5gDXPSqdGJSEfRFppsfahthH2
         siorztGU9xlfRrw+4KJe9HHI1lJ54P9e6PJUf89+d0DHGoAn7GG+C+E499ldYO+9dPtS
         u6/IzGaDuvRI43FmsKne2eYqaZ0nC5mUKrt9MpMu8men7DoQ1xaj4Xh89OCGV6nHHGwP
         pykxWwA9+1Rnjgr+mEq9Y+cs7IbZt9BgU7tH+Fve/kIWObU1hNi8JUpwXCX61jnhGLlI
         mp9w==
X-Forwarded-Encrypted: i=1; AJvYcCVeysyI+Xe8yhw8YjtB/VnZ9oX36+iF4oR5SjotWgOZYpaslFpYsA5ALnzmUhn0fByNAHQ0nXv1pg==@kvack.org
X-Gm-Message-State: AOJu0YwMldRc9a1ku2kA9VNYUv7aJ4X/QYhngXlks56oiV540yOU1h0m
	joc3o35u2z+aFQdYzhK5OthS39XoygXsUjWXpAVbv5FsL+uL5rqYzON5givC5/Umg3cvoU8BaJH
	XU0IJdoFkHANUCiTqAIbWRolTEeT872BM6Fc1k2qH+iCpAsMV96Dj
X-Gm-Gg: AeBDiet50YuT8VTromhUWKUsEwdjkoerhDkBmjg4X/1e99MUiwNwmdMETAZ+en0BWpE
	zErgOfRLLTa3LZe6RsmlFOETPxOL9Vth4IvGNN6zXA4xUDLj+z18BDiFrzPEVcz+1Hup0RXRLub
	iTcHi5H3wHswgDdyj8DedeWwxuEdHFDCZnxuK+ihdonjFuN4c3kbt01jLXdKqA6amG1FyMDjPP9
	9ZIbjUEs7nMoZ2ZQ0Rsu8XPrWMotUrWKska+LhSEJOwPkW5eqt5bf76vmO6FvAzKZMOPkvtWIZF
	OkdyOBeVJRusI6A6/CEA5oJK+c83UWpMv2kev568Jr5zxMT+90dl9CIiEHY/2uxU6bzeHB2pWZI
	o/hhzkZAOqF8dA2zGA6eSCsH3ag==
X-Received: by 2002:a05:620a:2908:b0:8cf:d62a:c814 with SMTP id af79cd13be357-8d41c2be534mr3849127085a.19.1775758981875;
        Thu, 09 Apr 2026 11:23:01 -0700 (PDT)
X-Received: by 2002:a05:620a:2908:b0:8cf:d62a:c814 with SMTP id af79cd13be357-8d41c2be534mr3849120585a.19.1775758981349;
        Thu, 09 Apr 2026 11:23:01 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb8d6bf40sm12146785a.29.2026.04.09.11.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 11:23:01 -0700 (PDT)
Message-ID: <0f354976-854f-431d-a10b-0910fe6831b6@redhat.com>
Date: Thu, 9 Apr 2026 14:22:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] mm: introduce pgtable_has_pmd_leaves()
To: Lance Yang <lance.yang@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, dev.jain@arm.com,
 npache@redhat.com
References: <b65d560458b2488f715b5afc1603d786e786ccf7.1775679721.git.luizcap@redhat.com>
 <20260409122654.42622-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260409122654.42622-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: luBj1CvDnghXJ8nbQWNw4FJmJHTM094qagjQLsBMhxs_1775758982
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 387D640017
X-Stat-Signature: jfazcnfgfzstp8f35zuhjf51ykfez164
X-Rspam-User: 
X-HE-Tag: 1775758984-626492
X-HE-Meta: U2FsdGVkX18wRDpeA8I9PdWMrJFx6t0XqtBc3fdSTTsE7AYKB4+Ci5U6EC/4N8SXZYRoaVKGvX+AzYwYF8GbAVYiRdsS+qE9u5F7VCA4FZEvFNCucHI74oNKsZbM2Nnjr3hYrJI+Xw0od5EZdU3JZXFcML7PKGiZSyeUnIF42qiDrpHHxu3igFmuCzNWoE5MLq51jYKIlFGuVECdRuDHh3+PFWU0lxCTF4/VpKrawVVUJqohF3J3Idh9POi5jM6nN2n9VS4uM/EQzgtiMrd3vKdHH6KDRDOr7UNks8avTWsxyr1g1cHBaQZlT9DTDHKK8OGH3DyrAcg+aRtBDgeW35zFJ9ip7IqdUjJYd+nP8eGNnsejGMM1AxyG78BV59c1LCMtigXPPw9KhsDu5kL9XqssbVuKh1DHwxXMUuo+swzKyqoP5DtY2c2UTbImW03r5swyjCujRZpPKQOcMJUqOAd+UmCudpm4MSqndHCXN6F6snF70MeVUkc/ozKhEpwLmXRZ/Z8ROzu5dRyrt7l6US3trmrZPnyUeYo9nxrKW7gbGXJofWYxw4Xqhc1bvPKSeJ5MnBibXR5oOf3sAK3OUIYPyNWgXJs7E3F838574G/3r1k+xMhL6VRSiM1U67euVKoBY5hox1kJAuxdxgB/BTGADIEESCgIhPZpgiCngvf++ypx+GK7NYybLl/OhNabVjfBi7UJUyEf2qRbi1NjPO8rZApiZlb+q/TrtKdlQa6RqVtn+RQpJd38valQTT/uo68zFNyruz0ErMa04xL9MNSm42KAj2EY2nTRce9AX6g8koRXpdBT5gNZbyNP6or3SijLIeOXrs7N4KftmTjMmVpwq79WmneKjs3MZGVYv6YhDCiT4LtRv/mM90mwxwtieJ2dhxZIngkIAqA9b6leEVqmBqc66z1Vvpgd0y5bvwWJ8FiH2G3OKA4ioA99kfhbLNabDpx00rh/aIsibnI
 wtgfjnOJ
 dC82sN2wjAq/EyElVkJN7kVY/IKf1XyPW9C3WYWZREoCRsxEJHvieeovCGkBjrChPssMWF6argFSwyLW698VXCKgFsZGeNx66rKqIvtfimGkoxrrLUeoafUvKU+tz0g7+fg0fcNBOEqGQNfEJ0IeOM+ptldsuytgmyPfud2q4j8QL1DmyPAUEN85K/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 08:26, Lance Yang wrote:
> +Cc THP
> 
> On Wed, Apr 08, 2026 at 04:22:57PM -0400, Luiz Capitulino wrote:
>> Currently, we have two helpers that check for PMD-sized pages but have
>> different names and slightly different semantics:
>>
>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>   implements this helper, it actually checks if the CPU supports
>>   PMD-sized pages
>>
>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>   by the hardware, but it just returns a cached value acquired with
>>   has_transparent_hugepage(). This helper is used in fast paths
>>
>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>> which is intended to replace both has_transparent_hugepage() and
>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>> It always returns a cached value, so it can be used in fast paths.
> 
> Set once at boot and then read in hot paths, would a static key be a
> better fit there instead? Something like:

This looks like a good suggestion, if nobody opposes I can do this for v4
(although it may delay inclusion a bit).

> 
> DEFINE_STATIC_KEY_FALSE(arch_has_pmd_leaves_key);
>   
> static inline bool pgtable_has_pmd_leaves(void)
> {
> 	return static_branch_unlikely(&arch_has_pmd_leaves_key);
> }
>   
> void __init init_arch_has_pmd_leaves(void)
> {
> 	if (has_transparent_hugepage())
> 		static_branch_enable(&arch_has_pmd_leaves_key);
> }
> 
> Cheers,
> Lance
> 


