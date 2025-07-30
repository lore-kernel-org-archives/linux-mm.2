Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AAEC87FCB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 13:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97286B008A; Wed, 30 Jul 2025 09:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48476B0092; Wed, 30 Jul 2025 09:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36E66B0095; Wed, 30 Jul 2025 09:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2FFC6B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:52:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70B7758C3B
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:52:53 +0000 (UTC)
X-FDA: 83721071826.15.AA373E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0D7FA0008
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 13:52:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NnmcbnfJ;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753883571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INvhw9PaQlqHnlfqMb8yKpdneujvD9kPiqSCHTmOp+c=;
	b=7NmJpVpus6MPi9hzNVfnO68iH6YvDMHxmyZfs3GDvv+6lDHfOBkpEucGrqSnT9czy4FD0X
	yJTjThdxAUeLNkNQgYo0FGzghz+Ih7zhZ2mwmJLfyOA/X5dLvygwnq7rp89ZsLVs5n7iPs
	OxUlo8exFf/UjUSQtJjWnYLi5QvbCBM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NnmcbnfJ;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753883571; a=rsa-sha256;
	cv=none;
	b=KVjNh61VPbpFLK2dL7jX0qo1ho+gNdy8arhQWNf59KMGOnlRGVSGi1PyVkQHI6dfau4OqL
	A82Uqho8kFCTMWTmOLrWFIwuiBMqwbepTFo1l32WRPRzhcA+xCa+yxv9ZlQTfaRNXvZmaJ
	56+ZRgH7qPoxDLzZlcD1PK7QpPtVpUU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753883570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=INvhw9PaQlqHnlfqMb8yKpdneujvD9kPiqSCHTmOp+c=;
	b=NnmcbnfJhU2/NmsRFZVrdqjNb5iMgOgQqbzK9LVodq8aDOuY6kCm/h/jNenCXHLdwak9Bf
	6ihB/pUr2EfVQrfdqua1RmzzPZ1u+oQnEvsbeFbIqa1oGKbROs286G+gCPjrvmr2REfDDw
	Ese/ZybnmLWigjzY9x/lgBKwH0D3M4Q=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-199-DyqcL7lhNzCq8x3momBl1Q-1; Wed, 30 Jul 2025 09:52:49 -0400
X-MC-Unique: DyqcL7lhNzCq8x3momBl1Q-1
X-Mimecast-MFC-AGG-ID: DyqcL7lhNzCq8x3momBl1Q_1753883568
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ade6db50b9cso91028366b.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 06:52:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753883568; x=1754488368;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=INvhw9PaQlqHnlfqMb8yKpdneujvD9kPiqSCHTmOp+c=;
        b=Pi/3swlVGe6v9+SSoGFzkoOpVqqJyRytmG4r+gn2mDT34KeXpEJVtd90cQ0i1GzrhN
         e4X3QWu+3/KsxKR9ABrO1IIqhj7e9mmzJLR/BIDhav+GqLyOWwJz3MwBhgNXlDoG5Tbf
         DLYIsbFHVA/G62dz0PqCnU90zIJ+2iI4o33/9DVkKIKZO3DJ4wPg4wiBmKRcYvK9IrAr
         wVBX83BbDP1lXyhJAeUj8oB0Mun61bacTnqasc+KXHI8iGpCDqItnL17Yp56Pj6G9oFZ
         z1m0zbsOAdpWPCWkc8Op1Z7Z2AqFSzUMuieae2+uZ6xiFpB0Wf1NOzpWh34GUp1y16d4
         Canw==
X-Forwarded-Encrypted: i=1; AJvYcCXANRxCv4+KNyRdDUMcwwllqJkteBWL0JZvt/4DztE6pj9sYec5kuAHrPN4RyErtkJ+GUBic/YMhg==@kvack.org
X-Gm-Message-State: AOJu0Yy7PI6fMev+NLTwtI8E+Awy99lJhzu0vSoot8Ml7RY9Iuda3HWa
	zx88Vrrrlo9mpOUiEbgWWBxM+29ZbAie3IBAknMYQ0UQlf0AsXqspTAT0+t6YYFEGs3ogYQ+tGv
	kBrm7mR1VMawHr75TX9lSGzaKjOHWNTGAOVs8JmNzATPv8OS7Ghib
X-Gm-Gg: ASbGncsTrjgy/0xiV6rr9vRA4kZ/WU1Sm60TfLFwB1mBqHp5g2Ra77tzZXqAmd7Erqg
	P+bzO+DuShSieXFsqg0SMLXVYywdyAvm8Lpj4276MuE8rqf/w74kVjKOn0g8LZq+S216BIyhfhJ
	7M/hXlljXqeWHuoNXG5g7ra7uNv1vydk8ZQlohV/2r0aGqfx35N3dl5qTVZuySgI877Rkp9PgTk
	w4dSPZubT7Lz9C8lN002Kl87lbN2sw9uExPfXa7g6x7GjaQlvn+07xkLlMEZEOwDEky17htxv68
	uYUfMpL83ap7jJbpSU+f1IB7U76g6stGmEaLzDcqskhJrHCtr6f6XZEFyFDmLw==
X-Received: by 2002:a17:907:7252:b0:ae6:e25b:2413 with SMTP id a640c23a62f3a-af8fda42a6emr459883966b.44.1753883567588;
        Wed, 30 Jul 2025 06:52:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2KhtHgQZ228r5yO4JfetEAu342+CZE6Zr5/g2fkWHPp7n9P5vjQqg7A7lY87sHfovdnuCuA==
X-Received: by 2002:a17:907:7252:b0:ae6:e25b:2413 with SMTP id a640c23a62f3a-af8fda42a6emr459879766b.44.1753883567129;
        Wed, 30 Jul 2025 06:52:47 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af8f1b172f2sm210258566b.80.2025.07.30.06.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 06:52:46 -0700 (PDT)
Message-ID: <ffc43855-2263-408d-831c-33f518249f96@redhat.com>
Date: Wed, 30 Jul 2025 15:52:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v2 22/29] mm/numa: Register information into Kmemdump
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-kernel@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, tglx@linutronix.de, andersson@kernel.org,
 pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 corbet@lwn.net, mojha@qti.qualcomm.com, rostedt@goodmis.org,
 jonechou@google.com, tudor.ambarus@linaro.org
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
 <20250724135512.518487-23-eugen.hristev@linaro.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250724135512.518487-23-eugen.hristev@linaro.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8uflt7zKywy18PW4r9chduP-aGNHPF6uiYD8zrUYH4U_1753883568
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: skfph3ttjtcwoethgheastgzf1wpxxkf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0D7FA0008
X-Rspam-User: 
X-HE-Tag: 1753883570-38343
X-HE-Meta: U2FsdGVkX1/RgOfD4Ie0hvmnydJzjbJ8kdJLWz3QPgByMjYGBx0blaj2LQqlzBRSlRf6CtfI3GOtRuonsnXwELSuLxIKrvcyTsOyOR5KlNvH3AHVs3/+uRUY4Lv4DR2gNGv9jSjffpQYcrfiOyP2zXHeF8dPo5Bb6SQ+8C+F1OHtobIm1sczZeBg4sNp+brTNeS+zSp9nwD802IvrYnLWMxkmMA8YYaN49XVo7REZIKa7tahx+rac4efeXbV5A0BOTGihqVMxqyecPAMrnYS+qTXfAAnJAKVas2BAs1ZZWR/SjrLKmiWt9qjB/JgKs1qa+5nYiSsR/YQrJBhxT+ZQC82fQhZ8XebGy18v1Qf5PHc11R0Z/TGFddvOKOoLIBzfsfk/XJqfGXFS9ypS1FdoejuOv7dIDxym32lZ1uyfiZmsBW3yTfsaibStT51awim8uWA23bFPTbYv4YKqBRtvt+OW2EqhUYQR/4bRaBdqMSptzDfK2bejSJ4p8w0kFtfKf4DUpOLlTJqTFJ8K0+BtyAGJUsL++DPXzWcXZMhCLVn6NbOfuau6UFSjy2Iy1PaVP4lDUNbmPLlH6CiugxzJB3GKyNAE7dUdA87tUcsJ2VdZXZo5h4w/57Nh4PA94r1ZN0paOD2zatlOsCmUeszB1JxAsJTSK25g+zS14vHmVWN+uFCOa9JDH2xzr52sSPfA/CgbE6KggAztxkhv4ppJ+7ultbzIJgeogvgAlVceTrFYXeQt7I872Y8dDryRsjuIQuL5WidfvjJMZ7DF4KNG+oNCtpqEjDUSNCD7pXqTsBhT5zy9IaDewAgw4SoWNDxudepHKRzAdftVgWSj2QRswWJJdXkqs5k65+mrosigYqDe4NQ9EkVf3+KfcxeppFAQ1C195nFcQB+pLKYwx1b2cp0IjcGnXiszY3ZMLYhEcue4MCWsNnH3KKazszLwMXhtrB7d7E2mIdlH7LWvuz
 v/lzD3q1
 FqmgBtoKd525Y6NWVlMUf4XGDM8df9PsJe09b6q8A3Sjd21/7zGNWt9NoOauoWGbxsZ0Xs05GZP9+7o2Exfm+VzQ927FxQQJEEWi+UquiKonVTCwZZrJXRj8Z2B27AvCotQZrLGQkK6Zi3s63vf99HB+O4/i7zsJ2OWv1COYroF1w4nGgIlSgeEBpJL53gOwMzWfWpZzTK52mz0b8DuM8O6G5TH0x7N6QbZbovOgpzB8/qJBIeVCN7erKVL7iShy/m7R7u73PS7zj9gMXpLQxOy6YEgoHI6p5fBNdv/8s+WM8YIRH/X8v7s/g0WuD8MITYhdy5DWVvzC0NbYxvnUjVi2klRNlASAj6UGkX1TZq/X5nk1WfIFRTe0X6hAdfo29gWcw6cShB5XhxK5v9CS0EkmpkqVaMEJYKjQIfTTeHrM482mV78/VvVwxZ/q3msNLRT86q0E40xjWUzfYd24NDmGQw8b6ITaIQ/N7nIxI5PKqlfep6qivul4KKa5cMMEIG8+zK/oat48ovPhD+ss6MWAdKlINiu8vKx2pqZO6ItiuZbY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.07.25 15:55, Eugen Hristev wrote:
> Annotate vital static information into kmemdump:
>   - node_data
> 
> Information on these variables is stored into dedicated kmemdump section.
> 
> Register dynamic information into kmemdump:
>   - dynamic node data for each node
> 
> This information is being allocated for each node, as physical address,
> so call kmemdump_phys_alloc_size that will allocate an unique kmemdump
> uid, and register the virtual address.
> 
> Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
> ---
>   mm/numa.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/numa.c b/mm/numa.c
> index 7d5e06fe5bd4..88cada571171 100644
> --- a/mm/numa.c
> +++ b/mm/numa.c
> @@ -4,9 +4,11 @@
>   #include <linux/printk.h>
>   #include <linux/numa.h>
>   #include <linux/numa_memblks.h>
> +#include <linux/kmemdump.h>
>   
>   struct pglist_data *node_data[MAX_NUMNODES];
>   EXPORT_SYMBOL(node_data);
> +KMEMDUMP_VAR_CORE(node_data, MAX_NUMNODES * sizeof(struct pglist_data));
>   
>   /* Allocate NODE_DATA for a node on the local memory */
>   void __init alloc_node_data(int nid)
> @@ -16,7 +18,8 @@ void __init alloc_node_data(int nid)
>   	int tnid;
>   
>   	/* Allocate node data.  Try node-local memory and then any node. */
> -	nd_pa = memblock_phys_alloc_try_nid(nd_size, SMP_CACHE_BYTES, nid);
> +	nd_pa = kmemdump_phys_alloc_size(nd_size, memblock_phys_alloc_try_nid,
> +					 nd_size, SMP_CACHE_BYTES, nid);

Do we really want to wrap memblock allocations in such a way? :/

Gah, no, no no.

Can't we pass that as some magical flag, or just ... register *after* 
allocating?

-- 
Cheers,

David / dhildenb


