Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA2ECCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9768E0026; Wed, 15 Oct 2025 08:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1578E0020; Wed, 15 Oct 2025 08:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02688E0026; Wed, 15 Oct 2025 08:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB5628E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:36:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7C96B6258
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:36:35 +0000 (UTC)
X-FDA: 84000297150.20.D03C2F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3B27940017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:36:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCp0b2Of;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ooy0+P+qSQZ9PBAsL6C2FQjAzQTmePqNdX02r+q1V8o=;
	b=dJ24ZTaUa7AELcHullupHA5BmWKixRuBHUuBK0YFcpchdUL8bnydESmPmCsflcOsHO5OCd
	bqn6ubm2Jy5uT5Mw+ZsYuCDFZsR8OtW4zAKR5yI6pOzbt4BTfECdDA/+L486yyl+pG9FK7
	EIcApMPJVMc2sNQ97eteAZ7xOZze6eU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531793; a=rsa-sha256;
	cv=none;
	b=15rwBzd3hRD7t/kjZhHF3eveylDUh/BDyHzBxS3dNJf5Jl2b1qSgdle0RQ91wDulGkaN8E
	Myw+7fwDuwUJApRYPCRy8HypFS2CV2BzdPeeFRoxIv1A1k1dWBEqh95k1jurljnImQCL9f
	pf+gqm2iDCFvhxOSuNT46GETT6L/TNw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dCp0b2Of;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760531792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ooy0+P+qSQZ9PBAsL6C2FQjAzQTmePqNdX02r+q1V8o=;
	b=dCp0b2OfHF8qMRqrF0Cmt5/65QwmfZ3NzkUkPRt55VmTbwlx8m1hhLEMqUtgnP2HugwRam
	IOELrx+FtPYa00MD6EuDJbd+2LV8O0K5qYsjPUcX36Dii/lGiK3qz2/89XY3fkhn/y3FAS
	ew6n7md+b1U4IxEf9ny+PZ6Lnj8LB3w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-7VcCQIlZMQWY9OIXM27ozQ-1; Wed, 15 Oct 2025 08:36:31 -0400
X-MC-Unique: 7VcCQIlZMQWY9OIXM27ozQ-1
X-Mimecast-MFC-AGG-ID: 7VcCQIlZMQWY9OIXM27ozQ_1760531790
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so1286488f8f.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:36:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760531790; x=1761136590;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ooy0+P+qSQZ9PBAsL6C2FQjAzQTmePqNdX02r+q1V8o=;
        b=EZyJ429BS0Z1NRCStxM/kKI/OWSEHbJDc+tq1gS3Qx1ExotF0gHP4yYfLAPnEduJit
         Hmuu3xDAkvdHKV2gNuqOi0jQ9tthrRFShfM5rrwEWp4+lv4um47f+0fZA2z1SKzJerHt
         QOwL/u7GuiubiaRX1YdS73WoVSUt3yjL1sFN9xnss3sA+LFm/ptOAv3i0JeCFw8GtPCf
         r2uLWC+i/IRHmgMCUnqnjqA4JDG66ypjTJyXH9p81TfxVJ+4dbWle5zvXOZgSgRBQqMD
         uPVseMol2OLSB9NMmeAoSB49Sn8Lu7NiY3YxqS8vqqa0OdqirWLvJaU7cIfJKq9oTklR
         pJjg==
X-Forwarded-Encrypted: i=1; AJvYcCXctOhfEJq3DwGd1TtkAlgCTqX9fFWFe4QFTqNXOgLQwuoGdSINl97wbXdl6sQcNjDkBJtVnYBS3Q==@kvack.org
X-Gm-Message-State: AOJu0YwFXOOmbeD+zglUuuTnoCBbhcCQCM1wj11GKrpdl3WhAxjlKhF1
	yJJXsA8Mz0lEtcVqvk1v9SJSP6i/RMQzNHra+Caqo9bodWMwKKrUVDVAxO87xTBy0QrTxTD+mnL
	bBkLp1n04jI5w0fXBHsyS641z5wrUl7ub4qaNzlaeGdyTxIZIN7lZ
X-Gm-Gg: ASbGncuHlCTdlijHngjehvNmYTU6PACy9uS0nlJw+jgUROIC5+R4stapsepZehCJoe9
	imutNd7A2lystyqSQMYBRoH3TyaFPpiVyRuLVwihqp9QZJZJM1MfMl4DIclvfVTprdSHRI2WnZ8
	VAb6caCCYLcTut/6eFtYkMDIKHWRgi3fl3lHedPIYl6ZRcygCEb2kTmiShW62fs/Fi3+E26jkyD
	UzwEunjK0J5BSIX6m6kcd6z83KtJFP1rtiz13BoT8wjC3T36586u9VAugZz/HjHGw6HdXECfvxa
	de/Ncn9oH4KC60euidLxx5hfR4q+fN0xV2tBEidw8kE04NwuSQcZj6/6c6OYKRU=
X-Received: by 2002:a05:600c:46cf:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46fa9b02cebmr189549035e9.27.1760531790259;
        Wed, 15 Oct 2025 05:36:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQEv7n4XLXJaSEJX/SITQ4VMcrjiffoRvPhoDRdJduQpEbyWpYgYfRJYQt1Ld4+uLtEwQ9Ow==
X-Received: by 2002:a05:600c:46cf:b0:46e:35a0:3587 with SMTP id 5b1f17b1804b1-46fa9b02cebmr189548825e9.27.1760531789835;
        Wed, 15 Oct 2025 05:36:29 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426f2f72e18sm7689658f8f.0.2025.10.15.05.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 05:36:29 -0700 (PDT)
Message-ID: <ed99ffc0-4a70-416d-9bf3-58c4a3ebe566@redhat.com>
Date: Wed, 15 Oct 2025 14:36:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] drivers/base/node: Fold register_node() into
 register_one_node()
To: Donet Tom <donettom@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org,
 Danilo Krummrich <dakr@kernel.org>, Dave Jiang <dave.jiang@intel.com>
References: <cover.1760097207.git.donettom@linux.ibm.com>
 <910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2doVJ4TH3Bg3nqZ3LgIwKZJ5HtMcpTlT1LPfIhNupOE_1760531790
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8q61e95wpontt3ecp8d33mg7nd6is6d9
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B27940017
X-HE-Tag: 1760531793-399404
X-HE-Meta: U2FsdGVkX18tRJfrnsIG+aycnLb2/WgsOtmf5ek7pAvtPrteb0Ze4g4+TQLs9kaMUzzOssQwNtdSsW6NylCpfBd/Eu+U7wXQGz/WuCYI0186UkHywNHTjzviZ+SvwobVnTlYivLvhy9lIyxMIw3/kYfeNv1QJIXbbXW2hpaCkBDYMtrKXg14Xqtm5U+g3unqHcJdbprBCMEpFX2wmlbWRasjd6M7MxEHGfmbWZwRVtPBQsxBfZa1xkHXyrauRfNaZiT91M2AWwCU935lb43MVhdwMISsZx87ZlLrt+ALVmYh14RwVH+3wMneAvvA0tLjr9BxvXvX4fi5Qu7uaKQNp/7xhlyLZKv4k0ODPU1AQyVSVfyCOnz4gmTurKqJUe5Oavc3cc/BBiFkODHyW79Yc3LNNGnq1qGosw2PzCfHHY4uisxp8CabctoLViJxJAMqibLu1Z20bAO27JCJA4acJXgln1zy68c3RILPe6Ly/5GFl7L9JxpQS3b2eLA2M/lRgeNAIb4/ATQ1zG8YONsCN7uOUi9MFHwF4NidRY3MEVGLMugScR2gE6L1ro0EwoJ51U3V2oimdozK0jqR6AWBWBfbTOtN6q7T6hBxxd1d7nqr2+VqlYloIdCManIa4siZXAUWOFVuAbrKYf1HIxY6oa3jQAbPdMFcCq/9BzXjY7LNwn4nW01MCgSnFaOTImAx7oZDHdA4Y4mZLGdzRK9uc85LMCIUICbRNH/zX28Re4Fh/2ilJcStrN5ehEkKGFjj4Bc1vNGsnVHhe2GYcZ8mtFb0BMPgx21j2EJ0v2C+VzKShpdJ7TqQwTNjx6pLnh2lARh8Ai+gWMX2yul7obSjRMzKe45DzUe70jg0jteGkztjqQifhal6qGwfOP8jq6sCp6AqNGX6xtA1aeg6CgZIFulZbHCbHc/W72jqK3tGv5Glif5q6w+xyckuwjtCoScQVVAPNlMxRL2UNmIqris
 Mh/rizFa
 oaCI6Sd6VsoQZ5R93ZIiGvvvU3ladcZTI4eJfzsr/OpoabKADWz4CV6J3cPYi48phpWWzQG5U3pf/n0ugjFVYasyD+ZcsZcpdNG+y5AnKVq6fvIF4Ui9GagYtcRMZMu0xmMoyhAEuctDTBXe9dg89xCrUlVid3eP7iumo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 17:39, Donet Tom wrote:
> The function register_node() is only called from register_one_node().
> This patch folds register_node() into its only caller and renames
> register_one_node() to register_node().
> 
> This reduces unnecessary indirection and simplifies the code structure.
> No functional changes are introduced.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> ---
[...]

>   /**
>    * unregister_node - unregister a node device
>    * @node: node going away
> @@ -907,7 +880,13 @@ void register_memory_blocks_under_node_hotplug(int nid, unsigned long start_pfn,
>   }
>   #endif /* CONFIG_MEMORY_HOTPLUG */
>   
> -int register_one_node(int nid)
> +/**
> + * register_node - Initialize and register the node device.
> + * @nid - Node number to use when creating the device.
>

I assume that should be "@nid: ..." to silence the warning.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


