Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C11CDB481
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 03:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C80F8E000C; Thu, 13 Nov 2025 22:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FCC8E0002; Thu, 13 Nov 2025 22:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5C38E000C; Thu, 13 Nov 2025 22:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3878E8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 22:25:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D674BB738B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:25:51 +0000 (UTC)
X-FDA: 84107773302.20.E068978
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07C591C000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:25:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LD1bDONF;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763090750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BOAaIJj5XwJhKO1WBdjW9luvIK9JXdag1HuhMw79QE=;
	b=jwCo5wRi/U4vV/llljwa/Xaaj6mo1Cj61r1asoj3McfhL3tbihKN/155gGgH+aQBsY/o+g
	fsIt6EuxW+Ouu9MnJ/Co7XjpW5q4mXfCz3ZLTl9XGxJ6kAvuAORBWwtsALcQLjRYvp3Ugh
	1pIKHw5MqIyq7Y8YyuT/0p5Sc4nIypM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LD1bDONF;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763090750; a=rsa-sha256;
	cv=none;
	b=1V7qwsFfR0FqYyOy1Ux2WxBS4VUtlicx3s62QZ67UWhK0c7JL1C4oBjIzUa5juu/H92pO2
	/d8mh8yS404uxHvMdFKqwjkIc0uLhe3vhtiVqsEjQiXJUa5KPnyAShaCIUUnQHY2oaimMB
	YUgut3FE0pEps+58OeVMQjFrMUTOUR8=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7291af7190so225376966b.3
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763090748; x=1763695548; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8BOAaIJj5XwJhKO1WBdjW9luvIK9JXdag1HuhMw79QE=;
        b=LD1bDONFqYGxjKBTWhVPJB2ocrA/OOhH5aoK1WRADxWm3dEYmQsGJ6ZmINNbzJgcHD
         mZRTThUcnm+n62loexrK0U8XxAf1hXRhM4c1O/xJ/q4gdFfDOl986zVzarvNB8g1lIbP
         L3Yk0dI2aje26/bgkjFJ6sH3uU3/wOeqeUUMyH5q84p+21jTI5XTMiQmepE2b2D6RTsN
         NxwR6T2fPyOSm87Nw/pW0FYpexuAFINXnpyHGfLhvKpq2WHN+fo8Sfol9hgxf3eZ/Wc9
         Y37CudaUpCAYStaH0nShXJbvN/gZULtraVqLECXpAlAIolnKGsbuDVqmtUg9erHQ79EW
         /kaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763090748; x=1763695548;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BOAaIJj5XwJhKO1WBdjW9luvIK9JXdag1HuhMw79QE=;
        b=mXYZPdxOdxPyXd0lhCxFA8u2uJ2FfNR0k/kkm48qbwnSg7vTVWgSCohv8j7TgNNgyA
         BObRE4AMsLz7Duo4Z7JHYybVNIitW3Opi10zhGmHDrTk7T6IchgjYwNC2w3mVnZ/DLUe
         bEC/OFMCwBhSwvDi4phEtmqj8GOHav/sItla+A0Wy58F8MDSlXeaY0JKzqXoK+O6ytFj
         d/7+k9TgeZAK0aln7EtXIsDHxz1EjD2NfWXJfgYocvhJHDKpi1ezCWdZD1IO9CjNOrRr
         /cb4H+DJ+5Pe78C+P2TnuiYzQYcHg5E4Svs9R/HKZAPyvlvGTCirq5++Q62UI9JAZP2x
         OrQg==
X-Forwarded-Encrypted: i=1; AJvYcCU+dwiREPLLvIUNmZDovsLed3YIjuw6wfjTy2COQOIr627xbEnB4FF7tRQTPY8rxuElk83dr9Fp/g==@kvack.org
X-Gm-Message-State: AOJu0YxJ9juPpQVwEML8HCLsskk4mpzfF2g4EA3ubvRIKb61Cq/ZAC0E
	bF1r/nf/QyMWuOo64IY1vl4ehe0CdtGZyGe4Np3CubK6EE0NrtU3ooMN
X-Gm-Gg: ASbGncsVuQsSW9DEB37KJGjQpIV9itofNe3rT1JDPso4pQ9shtnqTHmqqwNYbRdqh1a
	ywT6l9qHaOxte5Qo+EgiGFECRNHdch8rMX4KJ6DP1jyazd5JZi29FUJb/EM8KvOU7xdsqW1Q9XW
	iTflq9NjGW8ieohJfaRXbS9+qUw+ocBGafvjH+k3drCTIpvAcK4REl2anQrSRsHnpXht5ELGmiK
	KxD3Mf3oLO/1Q/v4h5yMw8DHu+WmyCCOg1uHPu68zOsl+yadwQ79AT92XriouCJxG2EFjgzRfkO
	JPE9UTXBU5Seq5shc5F8uJuMK6/AjhJJf4xh5eaGNrJ97z11iJ4N8U0xYa8m6HWyjUxuE17EEBT
	AZyyUkcQh23LPh4xe5VD46VlM1JW3xShg+36D7ZhyVnpMh37vmkFoL1ZJgHuoAEBBfDSUQjGkHa
	pbkCoGg+2q2ZyJIg==
X-Google-Smtp-Source: AGHT+IEjsfUWKv0dMN7iEw++28D290GN2raAylUVWloG8c1aNiR9QCg2B1VyrKJNEtRpL0OsqHQ6aQ==
X-Received: by 2002:a17:907:3f1a:b0:b73:2fe3:db09 with SMTP id a640c23a62f3a-b73678f4722mr150819766b.34.1763090748488;
        Thu, 13 Nov 2025 19:25:48 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fb11f80sm291996866b.32.2025.11.13.19.25.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 19:25:48 -0800 (PST)
Date: Fri, 14 Nov 2025 03:25:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce folio_split_unmapped
Message-ID: <20251114032547.bxw4koznsoqlov5d@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114012228.2634882-1-balbirs@nvidia.com>
 <20251114032105.sdkjaoiwpdmpynew@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114032105.sdkjaoiwpdmpynew@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 07C591C000A
X-Stat-Signature: dbo8nrjpeanpyqx5qckrj6h5kqex8pdk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763090749-583202
X-HE-Meta: U2FsdGVkX1/rfwBjKMNhfHsJzIRy/T9b+Cjab1KiTGv6IgsIDzWMJLWi+iA3C5dIv9VtTu40Fifshh9WycyCDtetwP/rBN28Xukat2cXj8xkTOntLdnQ2PQCxnO8WLfVpiBODPTdhJeqcJPmjdL/bffwimrvnt7kGrFMYABCYPCx+e+I013stQwz2vUlDdKfGl83eoneGvLt9Rfs7GoNHtDeEKsnFkLjFgLoiIbJYjhFST/DvppcNilrGgsY2rBA0oa9GSkrnGmfkoKyyk9usjiiMgW9pwTadM6HIBX1mWPUyP5UwlZiatD7sT2FJ+D14UqJxzuNys2xi1daFZEjD6gJDcQ1aNH817nYSCa7eLTwDwpz+NKWRJgvdr0vr5iOkhPS/vCLIYn+epwEq147pHIJokmbNDeDANdnbQ7JbEEoNd7nKFuSCxov1nOuc5Luk9VQJ+TY6e39QI2AxEZU1799yurxobp2/PIC8VZJebClsaZDpUIS2GcvTh+/wjK/80Ng2l688P8chKzPEorXoeuhgblyDo7ftqvt1oyFF7vHmdKbxDMSUm2vAx/Rv24+dFospf4PAFyyBKpJB2Q3qADohMbNwHKTRSLVSD0To8PYoFNq3uwxCCd6xGHr+0XM7OgE5y/s+Ptrwy2XgQ0yMS2iE4wO9+HKpc/gOCMbjlyUGx9gBly7tAGBwnhqRfHuNVEGmCK3UyfZUcxZK7OKUiXR43EeP5DDgEYt4iRgLN+eXZCPl1aF2tgqASq7EAfiJcDs5bTmCS5i6qun1tslAuSbROPEf2SFZg4fWYYowzKvKsDVuUnbaZRH0vGdxvQwOGuyz6T/8n5FWdyPeJ/iBu3RoauKHr51a6Y4NeFvMD0pUqgUoe4BsjEhxlsd3GaOq2XIOOSYu9+SB5OLjEP1od6BOmyt2dyOk6Af6bnpGdXgQAs1dvKe+tF2QPd8mVpJ4ARevLTBnH2Ya0JKmc5
 nC2i6jfi
 Z2xHmQNOvRhSIEpVVRGj12DwR2ZBTWA/ruZhHP2Itbejzu6drKvuAhOaCrR7tjXeOe/Gv2Cgf0ViZ+qgA+cLNyiXQLzjUNF932Vf/SBp43K4qv2kFrWhcQdugFz7P8DNDqdWElvlcE+grXu3oayB2PLk+5ELVnjuGg34lx55Kn0qYpwuXfvVwO4uaPIJFQ15s7PUamfnN0sZ8PtwlnjBR1OUtjgV5JCwEaVWEnl0SUqojLPPrhdA/jjKicglYT1aGQ5yVjNkQNijgkDwJiFr/6M+C2unp/X0f+z/fxNALINqA2tAM+YftwCU/MtMjywMrC3r5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 03:21:05AM +0000, Wei Yang wrote:
>On Fri, Nov 14, 2025 at 12:22:28PM +1100, Balbir Singh wrote:
>[...]
>>@@ -4079,6 +4091,36 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>> 	return ret;
>> }
>> 
>>+/*
>>+ * This function is a helper for splitting folios that have already been unmapped.
>>+ * The use case is that the device or the CPU can refuse to migrate THP pages in
>>+ * the middle of migration, due to allocation issues on either side
>>+ *
>>+ * The high level code is copied from __folio_split, since the pages are anonymous
>>+ * and are already isolated from the LRU, the code has been simplified to not
>>+ * burden __folio_split with unmapped sprinkled into the code.
>>+ *
>>+ * None of the split folios are unlocked
>>+ */
>>+int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>>+{
>>+	int extra_pins, ret = 0;
>>+
>>+	VM_WARN_ON_FOLIO(folio_mapped(folio), folio);
>>+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>>+	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>>+
>
>Compared with original logic, we did check folio_split_supported() and
>check whether new_order is supported for the file system.
>
>Currently folio_split_unmapped() only pass 0 as new_order, which looks good.
>But for a generic helper, it looks reasonable to do the check, IMHO.
>

BTW, I proposed to do the min_order/new_order check in folio_split_supported()
in [1], which may help to make the code looks cleaner.

[1]: lkml.kernel.org/r/20251107072944.zvqvr4kyibyofhuw@master

>>+	if (!can_split_folio(folio, 1, &extra_pins))
>>+		return -EAGAIN;
>>+
>>+	local_irq_disable();
>>+	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
>>+						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
>>+						0, extra_pins);
>>+	local_irq_enable();
>>+	return ret;
>>+}
>>+
>> /*
>>  * This function splits a large folio into smaller folios of order @new_order.
>>  * @page can point to any page of the large folio to split. The split operation
>
>
>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me

