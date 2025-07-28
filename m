Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A372C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 14:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5786B0095; Mon, 28 Jul 2025 10:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D196B0096; Mon, 28 Jul 2025 10:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3336B0098; Mon, 28 Jul 2025 10:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4B46B0095
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:09:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 119241A02D4
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:09:37 +0000 (UTC)
X-FDA: 83713856394.17.78052A7
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0FB5FC0010
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:09:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfHA+jpv;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753711775; a=rsa-sha256;
	cv=none;
	b=z7cyhP/7+BdsYBqi8GwwTpIGVeXe1LJQNFI418dVWSiZCVZeqLLWERTenikWhg3XOPiA1H
	30SKstIQ6YPZKe6SJ/rTA5NWloTcxL2jI5YrtVDTFvka+/HjMELFm6b2ZFJl208gFdzVYW
	8JtD4odAuhA7k3qjIkF60sddoTx2sJI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RfHA+jpv;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753711775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoVJp+PzlmK65Fu6OBPPC9Y7UqzBBQP2JVcFxv3Q7YM=;
	b=08QIYPuxAkYo+PY3u06GDMWxOPfDaWl9Tu1VTC0DjqSj98fQYqU4/wzumMQXeO2ejY+poq
	xY1YzG1VkoDjZhdti4eo6NVjj3eR8w1+kPdemjIY+58GR1V2LN8NXmJW0JM5eHIDs/84Vu
	91D3BGkzWQpyiqJ+cn8/PXQooIQkdQc=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4563cfac2d2so47562425e9.3
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753711773; x=1754316573; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AoVJp+PzlmK65Fu6OBPPC9Y7UqzBBQP2JVcFxv3Q7YM=;
        b=RfHA+jpv+7s898rvkx5F5XpmNHnm7KNnEtGFxYgxBK2ft/8OENbystPRR7GkW9xjYe
         hZ3LAIKa1HtdNh5RQfajXWnYlWkbE1aJ9Kb2Ub68oFum4L9NygIFKP1B1kjJtOQpZH10
         h1RItra8vsE01YMMHZtJPIAqfvUpCXp3MXgyotxQmRbJxMjwVyDNnjaeMNQD7zQ8D6kj
         BAS43syT6eJfKotaA4MQx22Lwm1Sf0W1v8V9LY7gu78UgVN0yQVgZqp27ZZ8/9u5qfuF
         3b+0/HqlmA+pbAzd0pse2+sNV50/MYEXtXK/EsafckxSq8jqooHUnyIFmgv50MFzoLKM
         839A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753711773; x=1754316573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AoVJp+PzlmK65Fu6OBPPC9Y7UqzBBQP2JVcFxv3Q7YM=;
        b=wMd1lbnM3Gm0aiBgO2sc7KF7TLOoi3SkaDd7ERvB3MsQVdSuPzdU7N2V8vrtPffVrb
         +Fwszlqb3g23NqbSwhZyOnZpTQrLFRDOdnPCVF1NPzUzKBZtFSe1F84IkQqDBQbBUONv
         3pQRvbgoF7wBzv5UADE8iftjZHiWR1Ivgcakj42iA7bC3C+4A4V8Rc9kDfvQ/XMcHH7h
         9oDBO+pqTQBj9D03MjcJqVLUB9K03zQg4CRrsgiAcNu3wh6aoYy0elr/XoCq5dJxdphH
         /Em8plVYdQir/Hapw+WSv4/JMYrH4xvFBHMKyD0q7OXxLmLvFASEBN9uTIOpEWTwkD4v
         zepQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVQL09EQ0K7LQ0PuvZ4SOx4VFvqM/CoRvn3596ppZ06ZDxgkdQqq4rwVb7m6JafuMtNSabHf1yMg==@kvack.org
X-Gm-Message-State: AOJu0YyQM7GAANh0D58UfYt3T9TzJ+Q/K4q8/Y2iY7q8LpvtlmePZ3nW
	HEZcJdHN1VyvEE9tNfieWdLiU+gToCRjv6R7X0F0uNvGVRD2xqFin1gk
X-Gm-Gg: ASbGncu4L9NqnHOEotAbSBbTLuI13GLM1yyECCIVRcqeEdAshwNTe+pr3WJjshra1qI
	qPS9LdtjXIUHUxQuGdfridS/vmHUNBRqk0t2y0t4WSwGNcpMNUwJOu0sIPuJpYY9kUQhdZFUwFT
	rjInrN1gMZ4j2a6czjCTNNGs9AmCjLqGjULuxjrh/YbYl4VDVAHP5aBJcfO+3wptp7G2pbLhvpj
	YQm2OkFSY0itDEJs0eKJgwUdCcCEqk9OZTRgEcgEJb/kkyQ663vt0lTRVIQy/W4XrZEW8Lx+iWs
	WlJwYwhEfvayXHDQF79wPnCrF0Iqo+AW3qSQxGippYexrKzYw6VsJJ7F/jSrnW6Fh6cMdFEGD4e
	LZqcBl/LG+xr0LLL46zSs8fD7mnHeI45a7IweSMvj/VYSYdnzlm2ZJxSnD6JcSXXD+uNI/qaecz
	89o+YNmI+ERw==
X-Google-Smtp-Source: AGHT+IG1VpKctfAXo/Ciiy+9lJwSYCznXMT+Foj1yo/y2TScu5H84EeoflD48I1yPNL3rv/8mp6TFA==
X-Received: by 2002:a05:600c:8218:b0:456:1f09:6846 with SMTP id 5b1f17b1804b1-4587655b244mr96594925e9.25.1753711772828;
        Mon, 28 Jul 2025 07:09:32 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:14f1:c189:9748:5e5a? ([2620:10d:c092:500::7:c75])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054f338sm153778935e9.13.2025.07.28.07.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 07:09:32 -0700 (PDT)
Message-ID: <e91c3b2c-b3b1-4271-860b-89c8e0d2e2e9@gmail.com>
Date: Mon, 28 Jul 2025 15:09:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm/huge_memory: convert "tva_flags" to "enum
 tva_type" for thp_vma_allowable_order*()
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
 <20250725162258.1043176-3-usamaarif642@gmail.com>
 <e83ac8e3-06fa-4ccb-95e5-4f95ba5aba7b@redhat.com>
Content-Language: en-US
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <e83ac8e3-06fa-4ccb-95e5-4f95ba5aba7b@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0FB5FC0010
X-Stat-Signature: 9ksyrrbeoje3a4pcf5fmjempzc65rhw9
X-HE-Tag: 1753711774-631347
X-HE-Meta: U2FsdGVkX19yyU8elpacnqT/wS5VVP4fSeq9Qg4DEj//tLHFGqky1zDJ2xgj2Oj/TBtFDDqItPHF2+j8ufZ1s7Lr+5+dPIi4JL80Hv7cP8VUQexRN0BU2R8z3WPDmabaf55f1+I0dZxWwt0/mtoKZOYyZaOYTenelt8BrAyQDFfVlcQbkczDv8M41qXOXkQ/Poy1OAsLM43doFvixi87HpUN3LPo880hfrdAFwUZkOYebkCiwEVLnZPUaXADjfs1F3Jqc4AZDA4yWrHOmipiaBCRwS0TSPKAVw1zWdFq4h403pHPWo/pQrxIxiK/qhicurchDvglL3j/2ENBlfy+BDps3fnQBobqeGUPDcaeCOa4VGnnpdttOfhW44eThSRJ7UJtD9NvIqKE9UR9GEGEVzuxoyrwZWXEyqjd6EuAt/H1ZnynL1bEScrZCbzfpdPG7K/RdG7mJDa9jnFmLHyKRqH1nb2EfF88imf5VH7On6HxjEmSE8FXkCoVQ7bq2aZS2mJJY5K9ec+fEBDNCxmzCU9NjnNqqyqjZr/zAir24R5fLGXfr8FhQS0i8XK+76uFO0+ESdL8rGMPMAp/8ST0VpD8evGJK51juvx3x2Adn/vlKgSfbm1759vym20JcmJF45FfDNtebwgh+voTnbn6EQaWaOTOve/XBO8ViziYEouInTWGS9zWdqvvU93I8F0XtKcthD+o4OINNGAaDkipUJdjgpGn6Du7o++EZRtqSBaKBG11hSGbEX806qnpKyVAyB0DrA0/Py9oCBYdRIt6npbA/cW3TnAyY3WXuFxTZcC1iYGUR450wnQha/h2MK+wRZhxhDFP7dsVMVyb7uLakY1fKOENxc3LZ32WtIedEZTgzwSYwZYGF1SebyDhIMXByRHlXy51axYEV8cM2X27cJ/fQ7jNaBuIBSVoEEqr6jGgwWbU2tJb4B+7/sNCr+xZyAngMb3DfP0x8ecfO4k
 Bfx050J0
 ehxaQM7WS02GEBqUCa6q4nQN2OWFSj6ZJQGy8m1D78Lx9wEftyW12jav5rrUfrEv+HgWpr1sfbyfX6K0McvhWzO+BZU5w7+VrT91Iln0v5tKq3nQCoAWXXGLVEGerZPuh7OjAiYWW8Gx+Mbvjn1QDVR3xeb/186ntHBz4aAEwBi4nW2zHJWsW0o0r8H/CfDQ2bfO0XYea5EnF1yXP5hz8yrkRdyV4KmgcHBcco+K+7NV5BVOXJxT9P0Cbtu4GD8T2m8DtorQ5JEIP/Weybf8Fcgo/gBJDvr/EcFIEM08r0+3nmsKLEUXDGTcCEm2Rn/6xT+6N4rbUjZjGt2ytAUelCc0X2TuqicJDGBamu4vkQglAiTxi1iUuv0ftP3SspllH9y8dIhnZ6Xkdl9wnf17GzkO1d+sD4C3hlBkpv6dnT57xbGNLSzl7oXj7x18ymZBSQL76LZdvc/3WCoDWfuJC97BEDER6F4pzEznvmdJ5ZHZZR2mxmY13gKMUI03jgLvMXmCAIzb9C4S+pv1ozEoqFQRZG/h5X7lLhpD7/vLAnn91vlo0gopM+UTxarmhYJQt0NVL56heYmRlO9vUArFG5RC2d0vppF2y141yiDaW7IlFJ0sEx14tW67NGaRWGGkMGDMJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/07/2025 14:28, David Hildenbrand wrote:
> On 25.07.25 18:22, Usama Arif wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Describing the context through a type is much clearer, and good enough
>> for our case.
>>
>> We have:
>> * smaps handling for showing "THPeligible"
>> * Pagefault handling
>> * khugepaged handling
>> * Forced collapse handling: primarily MADV_COLLAPSE, but one other odd case
>>
>> Really, we want to ignore sysfs only when we are forcing a collapse
>> through MADV_COLLAPSE, otherwise we want to enforce.
>>
>> With this change, we immediately know if we are in the forced collapse
>> case, which will be valuable next.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Usama Arif <usamaarif642@gmail.com>
> 
> Nit: if you forward patches untouched, make sure to add your SOB as well.
> 

Thanks!

Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Just adding above incase (hopefully) this revision gets into mm-new.
If it doesn't, I will add the sign off in the next revision.

