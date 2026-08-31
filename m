Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67F0C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 19:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06CC6B00AB; Mon, 31 Aug 2026 15:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6526B00AC; Mon, 31 Aug 2026 15:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA51E6B00AD; Mon, 31 Aug 2026 15:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1E16B00AB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:27:04 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05CBA40237
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:27:04 +0000 (UTC)
X-FDA: 85162547568.05.3B17AF6
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3C77C2000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:27:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D2KcrGq6;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788204422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qiY4Gs9W/SFQ2HMe/A+IO8vIdD1aF3hD3uNun4m4bw=;
	b=wosGoKx/CYE2O4ZpL/L9GXzgqsMrHgd0To9u+6Ou3QxKjxwiuWo6+GvyZIizWWxWVDBDXQ
	97wKfu7ttEmWrYY6onpzRJAjSOeMrLsvd30hGyhrbLtv3LdLtGm5YKUF6g++DnW7YUvyLL
	8QkdN/+8Do4UuqBYkde5chKz2rtGEn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788204422;
	b=qSskKB+tssxOjKmjMUTSdYViKUN1PMXMkKjcrKbFPQXPYdM5QtZ1zCOX9WMdIt0DsGQzLY
	CwtqZ4GcFPzCw5t6RYSlzxGkD8t+3YLu2B14kG7XFoT/6Wdh7uoNDVSVXZ7N3X4sagRWDx
	n8t3EpfFBKDUyiHRBFNx2MuqdIWW8/o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D2KcrGq6;
	spf=pass (imf03.hostedemail.com: domain of rientjes@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cede6375caso23615ad.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788204421; x=1788809221; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1qiY4Gs9W/SFQ2HMe/A+IO8vIdD1aF3hD3uNun4m4bw=;
        b=D2KcrGq65IZv71Vj9qOELUfiuKo1HV+GA5HQ8OmzHO6CejnmvM8o9znEGaKZlfpk/z
         8x/7GLYFtTAzvdcrIbghx6qweFiW0mcIuo7XBerSRTLQySHxf6VAhX418K+C8b1c4acE
         Q//G6xhxJcl3SzHf3bJ256rT5Mqd4lH88tEqMxQzKwcACO3KQhBIH+Z3TTbi3EGUsF7c
         Ac4a80c7FNtocpQOTDQtyKTuYx4yFvS5HmVmsgA76zAS1y5Yy9hxplJ5kotiuBRyWRB8
         ZouYdjLa2w3te/xca3+ZcyKfbT12Z+uoovZaUrFbbitIeI5bo7TppsLi1u5w71frgiZR
         9yhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788204421; x=1788809221;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1qiY4Gs9W/SFQ2HMe/A+IO8vIdD1aF3hD3uNun4m4bw=;
        b=sXzNP4Yspb+EL0gLeKXzBgiDXZM1nKWdx9LOxprYsqQgbhO4FBQOoPVEEuPgeCiyL9
         YEngubMmT9KRDo12UK9xGDsgPtArlHDe+62jHHItS9ULvxixx0jDLpTo2CPs4K7Iy2yW
         skg2yIqWcBAoj0t4ge1SVjHtNHHu7mV5WhlLdI4tH3RasUbIlWmaOQ5v7CA7uERoWY22
         4tH0cRxSNcK/jXiIMCy7qr6CSyABbDfVuGEHKao0VnekP1gxc5ObuouJr8ZD2k8Y7LcZ
         YI4ykqqNRK0R0SeIyvkvtpV1Tj7bFFXDTtDou39oHQN6OGlQsIiIFF/O7E2wR8UUukNY
         KsGg==
X-Forwarded-Encrypted: i=1; AKwUvByuEhl105m6if6wSy8EJxSHob8Q5xDlREvmWKh1dvU4vTgNL4ScK3jIXJLPqlmqqT5mX/13tjA+pA==@kvack.org
X-Gm-Message-State: AFuF++kKfmHKlKxDQNRe+wwlF6i0R9oRXB809JTIB3IDtF20gAEv2ujX
	kLh9k7w4NeJ0ZEsvJdcnPdi44MV1GVawaCwMDfpZHA0fljHGpm6Pp0rQ/xuwceJGPT3SwrlbbDh
	U719OCXnN
X-Gm-Gg: AYBFou0EHvaVC/5pK4wjizb1vRO377GDc/af8PO15APRsMtXhFgG1o/NtH3BViK2OAW
	RDLfNq2NvTVfMDm04Ieiylr51D8hBunLXaXAv8ElHeIRIYV0AK8sFivKHJu0UZ5sIpREwmEApsW
	GZWTu/emQ8m07kSvL0/1mixB58zVpnQpAw5NFXbpSFHtZnI66rCaib+WWoitHunG5DEITXwsOEZ
	YLUQafOmLvxJ0zXN4+qR9PGT748Sm2Bs4ohZ5dwpn4emv46KGrqbcTaeoNt5GSFX2224vWu8OyT
	LYaQxUKoTpUHzmCoyBSTTCIW2OmQfPz1RdSybZ9+ZVsYD15VRVB/lfYxmfUt5q2awABIzF2mxkg
	s1UMBpHB1LcFjIR74DUrlIKGyVVqOHVbwbTgbfaCnJXWmZe3fYuszXqNwzEgNRpIa7BvvXQQMy7
	zR8nHyeV4pga3u//g4uwiX87pbOioNrA1/dzgvivE38ohkwTlCho9yYc3DXZD2T23b018pfHxPL
	W8fibh6l5mftfTigbUbt/rxS9o35yRP3IsD5559f118+QqSJJkB/cNY8CVt6hUnjy5qdgNcmnSp
	QY5E1jg86k1HqAQ=
X-Received: by 2002:a17:902:cf05:b0:2c9:bd54:cf with SMTP id d9443c01a7336-2d95208bd60mr1394265ad.4.1788204420447;
        Mon, 31 Aug 2026 12:27:00 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:ed0b:e40b:2b08:1810] ([2a00:79e0:2eb4:9:ed0b:e40b:2b08:1810])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990d62b807sm1130653a91.16.2026.08.31.12.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 12:26:59 -0700 (PDT)
Date: Mon, 31 Aug 2026 12:26:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
    William Roche <william.roche@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>, 
    linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com, osalvador@kernel.org, 
    harry.yoo@oracle.com, willy@infradead.org, osalvador@suse.de, 
    jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
    tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
    akpm@linux-foundation.org, muchun.song@linux.dev, liam@infradead.org, 
    duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
    surenb@google.com, mhocko@suse.com, boudewijn@delta-utec.com
Subject: Re: Linux MM Alignment Session on hwpoison (was: Re: [PATCH v6 0/5]
 Only free healthy pages in high-order has_hwpoisoned folio)
In-Reply-To: <8f023b9f-53d0-0eb8-6f75-65957761cf40@google.com>
Message-ID: <1bd6206f-fa12-9195-7b57-f8c24e235176@google.com>
References: <20260705180714.3708947-1-jiaqiyan@google.com> <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org> <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com> <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org> <168ad406-f6b5-4623-adac-9f894e410e48@kernel.org>
 <8f787434-5326-4a8f-92d0-467e817a23b4@kernel.org> <8f023b9f-53d0-0eb8-6f75-65957761cf40@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C77C2000B
X-Stat-Signature: 9xybpfrz9mnoowid5sa6t7msf4ceunua
X-HE-Tag: 1788204422-194056
X-HE-Meta: U2FsdGVkX1/+4e/EpGCwSPuz7piehhKBZl3TeNCgbqh1csDFtyHSmDcIyrW7GnkyBiangAqLiS9yIEg8TKDHd9bfkk1DzWa6zltWmRyMjZts7rUnHUMLASmFFm6aMbJLE3j8L7xtVJIJz6cj6HuUl81mFlQmlhG5tYY9OxkislOz46oGdZ4lSOxJ1LDUraZzHe1dVTet1QgzCaCqsiDWGuUXycGvIcukRwfiTcdpQGeEa6RMNpMxspFizgEY84qOSfNQEOCSD+vGj3+k/8sumKQPz6toVYJFlGtrN36DUj+DLfsBYEZ+RSwn5Q/HQxVDjqW+R0I4cfnMJJ5D10N2eqGEnCInDsigl6bwU9l910e2F5npFj6rJq7w4Vxh2uuPiaZj2V0Q257ydYkc69xqsh1ramOe1ecKQs76q0eWnoPqROieiZxl9RLcBC+rtl5VlM/sIvfLXwjFj8KW5XXiRZBZ66YZv4Db6IDct8zN55CQH6q/22td6czsI97mpYo/QvStPN+bpR8vxptfyXrEvUaupSsqt5iDEZTZ0aStbcUgsJI4V7yhkf2KhLq/RBvK0AZ1arwelWHtonBZZRYfpgrUpWrD1jKNEXc/YCmxGLo8PoO/eCdRKlJ/n09BPpjST0quKaeJaotojqFLNlBZfqgjifqzpJ1s08D730IJH7HWqRbnnLPXYnQhXmE0kTB2/d0o0J7tRQA/Eu68N/m6f5eCaYDVmFxMIuJLL9soK05+hl6/ZKVutfRg/wlaNmzEXlT2O3Ax4QUNM2ndy/NE52EKLTl9sgnxWexawivcIFkMz0sYGLrcxnC5YAc4/uoS3sGDxl5M6coXki1k6dRwA0lk9EMWePa/awQbEs95riEETxJNNKku41Yal1px9Nwmm92ODpwnmn1b9ECp8loPSw2ADEot0lH1Y60KrzIV3UZmM/ZPy8bahfb6YHJikxMgm6O+8CYo9YZdDoRPhbV
 GGU4UlV0
 wjDGJKML8nfx6vOPXHbZ/MJSy3XN030ZefcqIHyCcdGcZ+sJvGOEQ0ANbqhNBUErDvQGJMUJnHMmnfbaoCdwyXQ3kVo2RHpadCb1W82CLndS3dHN2hRC2RNrWx6Dlyp8yHG3oJoIkj7kTOKor2MY8g7fbTYPgbpeqSa+MwGlthaE5f4W9FSexBqMKXtCoheKcGySlpn8k748AjAL8BuymIBd3bVKT4B8YWXIcvroZGWJdLpXA1dR66YlYhYklPaE6+/LYKNBTqwvj8jpt2syGmRWmLOdRn9pm4adG3TBZn6A/w+5UGNqkLC0mJwnfaX5k8qle8pwGAPBWT4OvFOygGNbi+JPlzdl7MwRWIh+tsxQWRMyzRiOitA3xtFHCbiKk43IZuwOCYDRcyn/thSVtnnNJHQhn5WsTkKJH6HQIB8aMbh1UUlH7t9sZbBxrhN4ru9JU1uF3DxGrD8ozKZDLEgEXGPVxYdqGkqYXO/v9VoMPtFqy1eyZfjWWwXx9q3tTnUSFgLzHTcbEDA0C+zYPO6O0T1pEL5bi6jvFNV1eR0ME6+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026, David Rientjes wrote:

> Following up on this thread and the suggestion from Matthew (thank you!), 
> I think it would be useful to have a hwpoison requirements and roadmap 
> discussion on how its support is currently integrated into the core MM, 
> get an understanding of what the areas to improve are, and get a sense of 
> future work in this area that people are planning.
> 
> This particular patch series is addressing an area of interest to Google, 
> but it's also quite clear from the thread that there are multiple areas to 
> improve for hwpoison in the core MM and it wouldn't hurt to get more 
> insight into what dependencies users have on it.
> 
> I'd propose this for discussion in one of our upcoming Linux MM Alignment 
> Sessions: Wednesday, September 16 9-10am PDT (UTC-7).
> 
> No specific agenda other than to gather core MM developers with hwpoison 
> developers and discuss:
>  - where validation should live, esp with regard to the page allocator, or
>    strict invariants in the page allocator
>    + implications for the fastpath
>  - handling for folios of arbitary orders
>  - handling partial folio poisoning and split failures
>  - race conditions between memory_failure() and concurrent
>    alloc/free/compaction
>  - soft offline for pages in the pcp lists
> 
> We might even want to be bold and discuss a holistic design overhaul if 
> it's warranted.
> 
> I'll invite those on this email thread and anybody else is welcome to 
> attend as well, the announcement email goes out two days ahead of time to 
> linux-mm@kvack.org.
> 
> If the time just doesn't work for somebody who needs to attend, please 
> reach out to me separately and we can discuss other times.
> 

Due to a couple of conflicts that people have, we'll suggest doing this at 
a special time: Wednesday, September 23 9-10am PDT (UTC-7).

Please email me privately if you're essential for the dicussion and can't 
make this time.  Thank you!

