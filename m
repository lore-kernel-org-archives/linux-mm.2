Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98A20C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153136B0088; Fri,  8 Aug 2025 05:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103FC6B0089; Fri,  8 Aug 2025 05:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34AE6B008A; Fri,  8 Aug 2025 05:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E19976B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:32:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54FEE1617E4
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:32:57 +0000 (UTC)
X-FDA: 83753075994.19.117B20A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A50CB1C0007
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:32:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWH+IkQx;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754645575; a=rsa-sha256;
	cv=none;
	b=Rv68ElD9raBH+Hl5JQf9YSu1a0j9IuV8KEZ7eJBJh/ii+Tyn+xV658ETVRZ9Ng+gEFIjxp
	v80Cqn8ZgDzxqxNUJm10Ah7cWqDhChLu6i5fgxpCSdI6OpSAwy27EWGNLK2chuvHeX50S9
	3yU1r72J11x3W61HRfoF9tugCFkqmIA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IWH+IkQx;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754645575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fqawn29acQYTvV5f2qtOAfggWuwJrZMxIhaMzrXxiY=;
	b=BhtF60KKrrVOzBovWAjlvZLjZD3h8tzYu7sKxuOOebaGxNyme0V5gjHwYI3y3Y9gisZIWe
	Kv6FYpHuaWDN38Kmgop+2x2CIVcfn+D0Sqv1e971cVzgpYcxfbW71KYpHTzFSTL2mjwl4E
	Kh8BRTY3PK7WlwFWanFFaWy0rm3D+Qw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754645573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8fqawn29acQYTvV5f2qtOAfggWuwJrZMxIhaMzrXxiY=;
	b=IWH+IkQxSDv2WtrlGFg5NPC/Vvp4PDG/DcLQNO0Uu/ny/PQyI6UUwJ6igQL0FFHcrUBRK0
	cbxYgN4Mm5a2qLhTe3Wlgvtub1E9XvIE5lcihUIjwnbHGKEFWCB5G5RsuEUOqIyRZUdPBl
	sA13TbRiI227mpKRS4F15CZoT0sGO9Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-dQLhdqagOiyytqJkbHXBXg-1; Fri, 08 Aug 2025 05:32:52 -0400
X-MC-Unique: dQLhdqagOiyytqJkbHXBXg-1
X-Mimecast-MFC-AGG-ID: dQLhdqagOiyytqJkbHXBXg_1754645571
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b79c28f8ceso1385804f8f.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 02:32:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754645571; x=1755250371;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8fqawn29acQYTvV5f2qtOAfggWuwJrZMxIhaMzrXxiY=;
        b=ROlhwH6hoUSmZWZQmMf2FxfPQJk77x7axLZlRH20YSuDAYCpFEJbDhh5uv4ci/AVTv
         SBJZJWId0OAFeIc3EZyqbZeOt2ZhFbCip+VZzIYT8NdnbeFbrEjXkn7WGnXKJazbsO94
         vS+m7DgICQoJvgd56LtAwEUc1c3f2KwtDigD8JvLhWaCF90aQj/N3vTm4XhT1VO2yM6B
         vy8PFRYAnB8rfMaU4N9vmt8hB1JmYAuaFxvR0gNzF5ALfgIYHlwbV/zMQdd/EJGaDWUi
         HUIOQlLdD1LftxAODIRPAN/17sXyk4PpYNL+tQK6lkSC2xhRwWb+gTucsTV4tqVamlPg
         mqqw==
X-Forwarded-Encrypted: i=1; AJvYcCWzcjlqe56QFBnyQ5APv0EUbfLSJ5eqqCjlaedfaZOnwvxW9X7LreaChVI1TqehYCMjSW2HJguFEw==@kvack.org
X-Gm-Message-State: AOJu0Yy4DZruY2W8Mw8sB8jtntiNKUiCk8Xr60RjumxqBBtwRa6lqEeS
	uBL17g+R4w1OyP9cPqhutgLyN8VCokocGOSQGr+r4R4WBFY2z8PgOWmGrhyfnzWRk4TBXg3Owmh
	JymoTqwEbvC+RMpVj3LeEgYArp3WPdbY8Fq7LRv7IcVZEXhT8xvDN
X-Gm-Gg: ASbGncsjBd65QPvV8nHX8Q9vjqBNRBayreRp6LQcs70lCOO0Bl+RGjXwnsj1/ZHK90H
	wH18bwH5SqGmAkcSWSl8vltl4PqE+IUtj63IKRIdRabKBEsV4ZUKQEq6RT3p+VSjh+W7j2j6Scv
	7lcvO0gIbT914RI4h9h1ntHmoM6aFSdHffDI4haEo2en8Suy038Bkp//ZeXjDj9SwuwUfYeBZyo
	Zeji/CmLh1qjdyn0Lff48iyD4YrMVIjsOfn7bD6L9BY8E51lndYmDkAeBYPgP9X43jy0EIhRUNg
	1CK4y9BALxijt0vaLFQOuzM3iyur0Xo9z+pRy/AWxYk6NdYZpJLXtwvwL88ByN0W4314854hsbE
	PO2CkuEMkrlPGxq2lKjzWrn4IEz98QAeso4rxwL6u+tmoc10/jxtuzmDgK6adDDUZ
X-Received: by 2002:a05:6000:18a9:b0:3b7:e3c3:fbb6 with SMTP id ffacd0b85a97d-3b900b7b012mr1960523f8f.31.1754645571138;
        Fri, 08 Aug 2025 02:32:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFdsifZDD507tJMgAw/08JXefbfz0MKtE3hTWOJ4TApQ3mJ6Uysv1ySPif0mWJ4aM5BAsYn8A==
X-Received: by 2002:a05:6000:18a9:b0:3b7:e3c3:fbb6 with SMTP id ffacd0b85a97d-3b900b7b012mr1960499f8f.31.1754645570690;
        Fri, 08 Aug 2025 02:32:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac115sm29745063f8f.12.2025.08.08.02.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 02:32:50 -0700 (PDT)
Message-ID: <00e75d85-45ce-4248-815b-0c03d589a29d@redhat.com>
Date: Fri, 8 Aug 2025 11:32:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
To: fffsqian <fffsqian@163.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20250808072106.153449-1-fffsqian@163.com>
 <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
 <3d57fccc.8a13.1988900f06e.Coremail.fffsqian@163.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <3d57fccc.8a13.1988900f06e.Coremail.fffsqian@163.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aYDQi48pHWTrW1Bb5u2SrVtYjlBp2u-LlQTxNDG8h0Q_1754645571
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A50CB1C0007
X-Stat-Signature: g3afxtsdd3q1ksssun3wgw1dmbjouzyq
X-HE-Tag: 1754645574-420848
X-HE-Meta: U2FsdGVkX1+haPm5UmwCCzIsxQh0i1qVPMTUKr29UeKr3fkX9dkr9fiH1lhjlUNu04xHgy3GxraAKZ9YFU9JkOE7nKIAqOeF6eZjrGyQrP2kffu7eEkLlDprA+B4R+NnUhjsjlmuQuxEcJBOmjw1AzhrxdDdLpReTOye0oxuxpI7a670wcnmnlAMfWe8eZofvtpM34JkKvUh3Ira4IlUd5wdipEj2y53F3tCm8TEJVIU5TZws+qIktGHUIBZKbQPCvtKiwXjhnA9r5HApOEzzswm+fCx7r5jbkvQkqn6IeEjo1JyRHeWnbfhF+CZVdLhN/C7jeMqhj9FX3HiJWugEX1JcjRR1mVqCdWHX6qvpYpdE6amPfBBYNOCg73A6pauqpnlI/KGaWgtHxnk/TlNo/BQpPiqUIUTF3EriR/V6/3ELJI/D3/CUbf3ycVmrE1qBIVV+TN4JdaUGY6CUu+RUuBp0PpYTY3xwa6WzynWURtfBhARAVJvom7HArdd+apKBBp1zDw099UCdlCvDRCmLupIPXo4G9WxxnIjvo+cPyo0A7csH2yS0yZ+cw45v3umnGul0uUvFsgOkYyHmNj6LZnEZheMvWJygXbrlD90CG7BYtNJm5glXYVajAsstFST3LF3JOmFzHXFOOGxjM0NbUS2c9sx1d6xXZG/UJhegA8pKYd+utu6sFHONyQFg3BkoHE91gnKoL7XhPup1tZsONpnUcp8wPtyveKUGht7/7KJvL5pHjzRKOcBhMCTWKECYuGVKMV/S+HUiHa9zd2rRl+Ak591xyPh9K5zQJt5qRKpVzdBkdpW9aC8ZCYGCNalB6L4pSnmDW5oEivRs5ezV64PdBcDjDCrcfvYut7jEuqQf6fs2Q73RBI65qUMfMXfKC0SgaG2+Ai50GJBzw4B5ZVoLQxG9FChiar+JVjEMDTVsP/eRU0Tip9RIWYww/zBdj+Xcz/9Tl9KaVxBLvE
 ZORYgj2K
 oR75uXzFxheQsVDTBfNmI3aDRITfveGGUf/RaX7uIjA2ahx/5izyaVzDwQZaJGsW30Ujp6m7DyBawdbNr+5fucK1SwRUYhm4WFJSCDgQjorZ2IymzwBDQMyVf8wbjqEiTV3WzvyD3CZIA9nQWSUwdq38Y5WZYCZElGvyV6UFMRQZOZZSIfKwlHxmWucby17SSYdezbBHnOQORcx+FAMDvKs65o4+YZ5ezH4Ss9bStWK2dxh9rtRc+oWVt4k1/ybMCZzyg3YuNTe5xuHVIc6JWWsGast8PE6BWLk53trEy92cfcYHer9LeuvyLwB8E3dpdIZZ9Z8nWvmNdOyJdQuKMljlMFFbT6XsXzg6WE5vwQ70vXM5GVl4PbeYiFbUG23PHs+sUjHarNclLu0EmLi7PRyq6O097NIN0sElAU/eqPr7DE5Bn5TRbE2RYEmksGKXZK3gpCb5h36utwBJlffrKVdPotbUZArwuHBo4pdetUNx7gLGgSdm4PWuc+Eo6gWEpcfRlSmk9L9uvfBHCsMXbWtUA3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.08.25 11:26, fffsqian wrote:
> Hi David,
> 
> 
> Thanks a lot for your feedback!
> 
> 
> Regarding the question of why only I encountered this error: it’s 
> because my compilation environment has CONFIG_WERROR enabled (treating 
> warnings as errors). The original code triggers a static assertion 
> warning (due to the signed/unsigned mismatch in min(tier, 4U - 1)), 
> which would normally be a non-fatal warning. However, with 
> CONFIG_WERROR, this gets elevated to a compile error, making it visible 
> in my builds.

Does it?

$ make mm/vmscan.o
...
   CC      mm/vmscan.o
$ gcc --version
gcc (GCC) 15.1.1 20250521 (Red Hat 15.1.1-2)

What am I missing?

> 
> 
> The error message is as follows:
> 
> from mm/vmscan.c:15:
> 
> mm/vmscan.c: In function ‘read_ctrl_pos’:
> 
> ./include/linux/build_bug.h:78:41: error: static assertion failed: 
> "min(tier, 4U - 1) signedness error, fix types or consider umin() before 
> min_t()"
> 
> 
> I really appreciate your suggestions on the patch format issues—I’ve 
> addressed those as well, including adding fix information and 
> streamlining patch descriptions, etc.
> 
> 
> V2 of the patch will be sent shortly.

Please wait with v2 until the discussion is over. Also, flag your 
patches as v2 like [PATCH v2] etc.

-- 
Cheers,

David / dhildenb


