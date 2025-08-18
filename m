Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2E5CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707388E001B; Mon, 18 Aug 2025 03:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF218E001A; Mon, 18 Aug 2025 03:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CDD68E001B; Mon, 18 Aug 2025 03:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA8D8E001A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:47:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 266DC1A0871
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:47:56 +0000 (UTC)
X-FDA: 83789099352.03.0E404EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2EA216000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:47:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XVle09w6;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKouifB7G5rcBd40ZGRdNWHNyUYJpa/6R/7rwWgxaNU=;
	b=J0yzmGxtdYlEEk0c6UhtIa0sMMEUn4zysyVTMevSlnD1PCM5pCmSsSMymkweJQltEfAXZ+
	C6Or33JzCB4m808C/JUZS6mof7lcDkbLVEZiFMJLe/2a3uPFP28Mxh87IccdI7DQBWR+mW
	1q9Us1LvoyiQmxkzj+YWdVVsZbokg3c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XVle09w6;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503273; a=rsa-sha256;
	cv=none;
	b=XWJHFv2tO3iUdJRzLzhWBqrnf3hOFxSkm81ihD1zYw/g42SZSA9zKzCbTAd9sLCjbsZjof
	2CfukoulqvlXAkMVETHSnrJWKu99QvcSU7cR3XVkXQsC0c5/W0DY97jm+qt7mS43zUk9ES
	OnNzxB7Tn33/mWV4azJPgLLqXgLyd9M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yKouifB7G5rcBd40ZGRdNWHNyUYJpa/6R/7rwWgxaNU=;
	b=XVle09w677mML4zl4ckHmP+KEelydPKilolIXKpTfeYR+I2jKQo5z52ABH2ysvE+IhuIvp
	QwLopuLCf/QZW8nrg8/uXFQucYI+94DUcuDKau6/g3hIQT90dZ8XL741LTbMAt4Bk+R5V9
	1PVMCqkiHVbG5+Q4NkJLcHNaBWUG3Js=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-Xc9liKsXOpSBL2QZCMR0Aw-1; Mon, 18 Aug 2025 03:47:51 -0400
X-MC-Unique: Xc9liKsXOpSBL2QZCMR0Aw-1
X-Mimecast-MFC-AGG-ID: Xc9liKsXOpSBL2QZCMR0Aw_1755503270
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0015aaso12115405e9.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:47:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503270; x=1756108070;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKouifB7G5rcBd40ZGRdNWHNyUYJpa/6R/7rwWgxaNU=;
        b=TYJvqaptP78NiNeHs15sCTQq4b0O0gKDpAplhOn53aWJE0E60tkojqodcGg/XgUflu
         Ty9VhuT/Bw8OwF3OSvuoeDKbnvgGCw0trPFxnKRElbdLtc6cBSqKiN1UKLxh6pcYdeoX
         vurRIrczmUNaQXGPVkpdprgewyj3W5oW4cZ8fYRjf1nrmWolsU3zI2Ap+oCOpWXVzl75
         qdRf8I6Xl/LcyQ5JZ1DC4Afmp3wULHhEDdGviW52x8siBEpjXRYiofNXLrlPkA/W1tLC
         ucWptEVtcQrqAI3AViUeyzWIwZsr+68hXK6l87KnNtJLP0djmRcps+igtjP0HX+vRG/1
         244g==
X-Forwarded-Encrypted: i=1; AJvYcCUOhH5QmlBSmGDKZVe2p8SboKABh6xSqUrKC7W+KXN6RTbhzd8URnHOJCWE3k/y6na/utGPE8Qsfw==@kvack.org
X-Gm-Message-State: AOJu0YxJfwBpdESAhY9f5t00JYpyjhmjgDq/+LNV3t+D+G7pjiz/kdLP
	anSBzTQ970Et1gUfyakhxRw03uQGJW2PJH0jxYmJSK/ZqQCgj/qfMCOkagxnYM21QgXpXxn/53X
	cVIBXtaZWqstZJShGQGRsb34qQN77Y7t9KF2TtHjLMU69v5oQT780
X-Gm-Gg: ASbGncv8zjlVNDs/juhzj3TzP0yaK3skDrLd3I8dy3M41mlkbwQh6NHzont+78VDo6V
	gYRbXUEbVnFejbxeiIvBsr78NnrDXwJ4XkHcNAg7Fe+Wh8NwSmqkhKvCMzRGg5A7ygm/HAWwzeM
	uomFlRYbtc91vgr5eYFB+F3gs/hM3T5JEiKvX/5J6RoqfEV3XBZl+1t1cyiFqC/BPTlpb7QSjBU
	GGLPDMxDxeG+6FtQD/fc2qaq23nLPHQi+ZCRKtFb/ZooI49bFBr9udevufo/yuweNe4w0GwBV1y
	oInY4u+eY0EUQrDYkWHCaarEl5hhWzkNYEXoo2qUNM5jDrSfDN71nkaFMf1HkXCNMrF+FSkRPUB
	vTJBfy/Ba2aFISdarDtHyp2z7vFpreYwRl8I72Uz2MYLORHsOU6gh3kINo4F7hpNd
X-Received: by 2002:a05:600c:154d:b0:459:db5a:b097 with SMTP id 5b1f17b1804b1-45a26784890mr58197275e9.16.1755503270199;
        Mon, 18 Aug 2025 00:47:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8vuz2TuDec3PC8OQ2oalVcrssQL/Ez40NgjEUbWnLchljSNogxqDtuxCMN5BdLp0bZtq2rQ==
X-Received: by 2002:a05:600c:154d:b0:459:db5a:b097 with SMTP id 5b1f17b1804b1-45a26784890mr58196695e9.16.1755503269634;
        Mon, 18 Aug 2025 00:47:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb68079da7sm11738572f8f.56.2025.08.18.00.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:47:49 -0700 (PDT)
Message-ID: <def7364e-ef77-4734-b870-278f9975e9c0@redhat.com>
Date: Mon, 18 Aug 2025 09:47:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 mm-hotfixes 1/3] mm: move page table sync declarations
 to linux/pgtable.h
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H . Peter Anvin" <hpa@zyccr.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Juergen Gross
 <jgross@suse.de>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Oscar Salvador <osalvador@suse.de>, Joao Martins
 <joao.m.martins@oracle.com>, Lorenzo Sccakes <lorenzo.stoakes@oracle.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, Gwan-gyeong Mun
 <gwan-gyeong.mun@intel.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, Uladzislau Rezki <urezki@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Ard Biesheuvel <ardb@kernel.org>, Thomas Huth <thuth@redhat.com>,
 John Hubbard <jhubbard@nvidia.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Peter Xu <peterx@redhat.com>, Dev Jain <dev.jain@arm.com>,
 Bibo Mao <maobibo@loongson.cn>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
References: <20250818020206.4517-1-harry.yoo@oracle.com>
 <20250818020206.4517-2-harry.yoo@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818020206.4517-2-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ridnC496NioP2mhhfrYet5ta-VrSZmuMSd8_vg5CYu0_1755503270
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D2EA216000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 98j4uhqfnz5ryy18wo443ymr6hg9kmk5
X-HE-Tag: 1755503273-626931
X-HE-Meta: U2FsdGVkX1/RBBFi2C4SEq20lznQzqgfi5phPqH642rwa1sUOIf6KXam6SY3vP9A40Z7uo51I+MnLP8R8qLk2EmvCSFfP2w8n0Q68gxoWmc1k8GMbVKWIPK/0aW6V/jYJ4683Z5NcTQPvKG0qbI+++o64qyCXTc8pamATpdZN2t6QW+NCwDm4QPIYAYPgZ0yN29XthP8Mlx32wVhkfZnaoWIpT/CxxGu7AFE/NsDdWjfA+bnsTLYQ/C/q7hnFWK5LPcIhhuOgJ2giYUcESNHoczi3PqEBfC9h7je/QjQUDIBNqyuiClLivaRMjvOimgAN8VbebwSUpr1dKQVDL0QDb25xZilZ24mBeN3MfA9M447OiWIGbz0gom8F9kaKHz0OOHlxllkk9fh/6JJs6KKl3jY/kUnIJlS0iFrXjp2QlMAU7YzXWtuim74SraT1824gUswMjz09GnmLKXUFozKAsPKIdJ8UAxidNhNKu6StBhbs0pPqYzfSKTBBZnd/XIwa6AgO5DF1Q4FdSWq3ppErknASbQ8rW6pvv+AE+QemWRDmN9odBY2h0QhbKTthwPNi2pxuRJpiHSRV4onKtiOlYHAYHLU5kQDoVUtRJnSxZUUd4RrwTxI3eErae2xje4dqXmSoZ3lOQuUVp6okAE206HO6KulublhuefnRHdTyYZa8pFK3lkljBaKuAZv1oV8eFjMpLu+U/PeXrZgwtyi8Y0wqa8Hs8plTDipCvXJ/mlqACXb96pBnvYdlCGM34tacfuiQpxWeS+up1GwMya0XArbu3sVyratpRz5GTxWeZjKmdNMdi1AGRSi+aBMDxH6OnEW3QRheeLmHJGok12k0/+m0MnvhwSsmUI5foik/JjcfRWg6N7zFvWgDZUWsRepuwL+Du7cXDHJ8Fr+/Lt2AWP8xS5ezvtPJ2I8dyO0SMTLEkVX8Jax0MlnjBMIQZnho93hqHJVcd/2aLBI7Xy
 ObZzLXqw
 CsdXuA3pRBKHX+rqDtU+4jNFJqBB1pkgp/LCHGTEuo0No/IEY7ZaFlfXmrk//l/Q3kDyYtAaw2iZhmmBbTM8PVy5T/EadYS3X9aolIMbFl/mgAEM2HwYiczN9TfYEkAdjMWZZ0cB53cAnjPO0GxVMjLoCWgI+3jADAyJ7JBUPKAEudcE+dt8ApfKnydf2ldbcVj7uwMPdN8kYyEYmB9U6cgCHcrVicU5kuR/K4FnLf4HWD+r3L6rbbUnKB1QduCdmwAQbXWuDkcUqVlMC/ht6WYh++JCmb6XjRS49voOiesz/ZI08aXUWU8F86QYP4v0GLQzzkQ5GdDIibrm9dXybXUTrBXE2k0TWsBu+EPGnvu3qGCuRWXrZ41ribs/4SRYmNHZN2e99gfoLbRf4ixKAhj4gDWFAVOhlQiHw2TfZBWW7bV1uYmfye4c7dqWzHgz4plajqrkpkpd138eY2/Tjm5eAq8PtG6a1dIg1rHxbc8QVCE9K7Gjv0Yd93g6nlPU6P6E24CdPgcf7Sy/7akasVh6YHnAcaqbK/FRrayObOaRv2k9F7N8e7FoRsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 04:02, Harry Yoo wrote:
> Move ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to
> linux/pgtable.h so that they can be used outside of vmalloc and ioremap.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Acked-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


