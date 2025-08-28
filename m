Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06ED7CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5249B8E001C; Thu, 28 Aug 2025 03:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5508E0001; Thu, 28 Aug 2025 03:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4448E001C; Thu, 28 Aug 2025 03:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 251728E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3B0FBC192
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:58 +0000 (UTC)
X-FDA: 83825357196.11.30B7CD1
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05417A0009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhunD+eG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366557;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0BfjvXaX7EhpBrJcO9diF40ujDlSeO28TY40tQufFs=;
	b=h0aSgWtx4fqZXtO6XbtPZLByfehHO6AFWPsAJ36SwAGdrEfU+ICbMiUx+IWlJ2zItybQGy
	KsmDTUde1JhLFem3GH6+U1cuKhP6vZA+JR3JMCgf6y1hiuc+M4KEvuCHpfyWS/tWPOYi5N
	ccTjV6BwqiE2hsMik0KEotNyaHcbRM0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YhunD+eG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366557; a=rsa-sha256;
	cv=none;
	b=q3OTx4T30phsidwftAIvrk5ae/HYXCUTcseBs+ypijwr4kGmx1+Simp//Ak9wTRKSQ+tfv
	I5hLx4rMpGE0rbv8G6GgX3oKoqikoYl2IivLaxC7WPkRUkAVpKjfe2UU2jueQ76l6fdT1g
	v1ymOvOcbq4Ses2HpgV6XiHR3dhfAMM=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afeee20b7c0so26089366b.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366555; x=1756971355; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q0BfjvXaX7EhpBrJcO9diF40ujDlSeO28TY40tQufFs=;
        b=YhunD+eG3bBNTgY/DsMW3q0gHpDXWoZGNkWJ6/vId8ysNwIvERqqNQue7A8+8KBVMF
         cEjXgph3yHhQLowPw233SON+fzpJk8pMrvuRKMD0QT12qz/y+4I9iozj9g+Bct1vEhfU
         qXY2lrJd60/oYnVAjdhCfF+EsidCe1S76ijlLQt4ITtqLm23t2fTnK8gQoVDIW7nAr64
         jQVk6Dscdq11NYEXE7Xa2UTN6o3J6+ScF428uoC+hiR3K3uYqTkcxX2nruxO7LsDUKKq
         6sizghOhR9ntMYBd3fbyilUytZIR5eMkT3EW7hyNEFm1RPvlsVji/OhmmZN43HXgoc5o
         FX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366555; x=1756971355;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q0BfjvXaX7EhpBrJcO9diF40ujDlSeO28TY40tQufFs=;
        b=gTtZTlhNGg+cfsTkRZEIaVrGOVDoSTtJftioIwXIJmDO1K/Etq6IaRYHTGo9b8meD9
         wY4wPSUEyWjI4i/hVVkjyqm+r4Y//iDKyLVgypDul00n70q2LS+Sjx3ganV1XdvkqrC2
         4h5Dq0OM9fFkrZ3nUA5Jhj8gS9Vr2PCk3SlfQ0CI6xl3E0Adit0s2tfUitBq5PbUfycH
         SQJLelEA7ujf1oMwM+V7iWTi0g2NOyAGDTI301o1g2DvXchdo4ndcww/Bbe5YTZ1cFjC
         MvIWQ0AUmZMCsE6aIVfxKhrditDLnUYezdogdgO4WSgJNI6jEvE2SirmqGSiBSpTEVyF
         8h8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXXb+IeHK6wibLvq+KgPAQYINGs0afSnXwD0UVgEobWb4a085lGsPe3H8lr9qZZ+Uo0Kp+i07yGJA==@kvack.org
X-Gm-Message-State: AOJu0Yz82PFwyPmutCjNTzerTePNfYxOTjUmzj3KDB7W/oZIjT82/qdi
	sFrVw31Zyy1Ut2DhXjGnbkwecIcSkjAiimZvgwlOLKVS6C8JLlm+bPYf
X-Gm-Gg: ASbGncvnAnVi12J10vdDvH/+jeaCVfZIRry29uhJVlow4yC/r3U44gtgt0HEJccjWiV
	+uPPFc4gtsd2zaP4bMBsRY+teV/Ozxx76+jW9cJhbPUSEclq891bBwAM1HnhPgbNVDHsgzcMQm3
	NHxm29cGnqiYyYAgs1WKALwwCq9r3iSedAOxDjm1Dp+DxqeqRGCtZjrdI/9yEoAi9/qqyNuRQi2
	aqvcsH3ik9IEV3SQu7Y0un1b7z7j8s5Dx0FKm6XjHxSgtSAUKJ3uTmkyStA0PuXOTy3rr7sulC5
	mSLlEfY2lXWXOM2qdmWyfdPbMhtFYBQVR6mNQRLsIhyU71oZZkLK8f0w3qSapN97IogI/Zch3i1
	WdQRxfibpK/32nI3KV8ysDRkTvA==
X-Google-Smtp-Source: AGHT+IETTLjGc3PPKg04ncd1zRzcObVAV207MWaWJmOCZt1EmbrBQuEK0aAe9NGL4LI6P2OcE9HkdQ==
X-Received: by 2002:a17:907:fdc1:b0:afc:aa44:bda1 with SMTP id a640c23a62f3a-afe296bcae4mr2097332866b.54.1756366555363;
        Thu, 28 Aug 2025 00:35:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe68891cefsm988052566b.66.2025.08.28.00.35.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:35:54 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:35:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 10/36] mm: sanity-check maximum folio size in
 folio_set_order()
Message-ID: <20250828073554.evipmbkxrint3tbs@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-11-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-11-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 05417A0009
X-Stat-Signature: npx87aph9n4o5zj43n7d9s9ietgqicim
X-Rspam-User: 
X-HE-Tag: 1756366556-394282
X-HE-Meta: U2FsdGVkX19UFZWcWejuMoVugW/wv+fjoGHGSu8Nl8swN41H2VOjRQm1CKrCekVkv4K2Isxhoq5r9H3W/akaYWM/bLKIme0wVqPQLy7heulFfGa7Ihh6ilnlmF+6O3X9ZBCNZQboV4k9MmCuD97AZTb7ZyZx7YVwdQNZmgkCMat5WXmn4GqriMq38WzCkb9yGigB/oDrANt/8HGLDaReUCDM1xJSzI5+IoY1gYs6aicNWft4zFjdvO9ETwefTTCJhzQv52jItUoAuFltSWUngF6egpcwge35UVBrxEtD11JZLiRDEdDsifacm1LrDWI0kdZloVHrcEcpMZoWzgBeUIp5WC5jmapdbfehzrjsMuo4kbU40VcJ8Puz7aNl824P0XgM/S8jvoFEa2Hw9w3qiFXSCzaRqdd1uiuTxoQJe/tmRcqVTm3bnVIW1aBld8QSfwT3HoLQMW5CfzMd/8PSSt64QjGsJwCGUWvrSVg/1+xSMU6nCBin5om2dEzqDVQWbSYNaX4lShfq92OCPGZqrshXhPWvr28IOxdm57VKDMDGAYArqLGqrUY+w3JBKPLUfr2RJPK5Szway/q+5v0hxhljwv7hN8DYAa/DyvZm+EmmZv+8VSGgf41bz64UdQ2327WdrBKBtC4pASU9iHgnSyI3cA1j1y8YUIWiLRQxOUznEfMVmk5/r9ZTA1ObbCp513+CKhJHRMLxFa7RkM5gxJ3ktlsVxqYa1Z4jSt8vXRK3gRQzMNPDDP2L3LSD5aFrh/bP3pO/fKhXerFZeNKVoYq0QFR+I1dXZ82flDPjXNrbm87yLIFM/vK8TFYFIgwEeAIycuAlZoi68TOgLZjLd6GlmXeFa2CwAuCZox+HcmEKaLhpSxYk2dkUFvwv+yBOaiUudnSaCBNYKMPG9bCjpxUQZWjLKWYL0iVu9ZYyW9FaMZLI7WStlRqPDqvoOcirCWgrhWa9zwQWIHsKmWJ
 f8iiK+f9
 w6kM4EFSKm/7BwqCscci8V/Ia2WlRL4e2phGzx+ABG0S6sBYhgTLLAmSmTG0fwww+aI9EhQWSgYYZb3fXZI3RHdiKIMMylAU8KHQ06V8d25QijnPc6lXs/+mmKrgPLhkquX4b9CBVYHV1Ow97ss59AghLm5RhL4o91hzjQ8L8VzY8ns1G6+iE1JkfDsKPDGG4jjD4bhkLWJtx8Ft7pTmmahjqc/FMXGpheZKi6R3wCZM1i98/NCXtJUl4UzuwybQbltEN+NOsvSkSsDVeaLaMbuMxpWY6GJtbarS6ijnzSkPTB5ge5L5/0W5h75ZqM+d3Lz0Od8XnFXCjNdeTzBnnkLCbDytmn3Z+Jg+fGQuBd2x5NLRPjQ4BVJgKaFdNuO7ik+FCXwPCGZMPzgEEspUqoPiEXgzL5LKADrG5AF905AeW0X5u8CmVsleu4o1LloqFEbYlsAOYX+rkQqdYxpHqSO70M3o06uFi5I6YhLXDWCqnGEl47PFZJleoD6gtsu9eW3gevq9GiIOJ+bte1iGgK8hOayQImPBWhdJjACFQmGA/sJkSfsik5E+i764no6VK4WRDAdj491l5iYfeAfqn/Tx5w/D3rUIMovmxWfgXiunZzRy+Q434jGln+X4lcqTqFvCuRV4fL93NV4XK6yxRRteT3bckEAS5i8hr/KMTbUTpV/WjiXhSy6N14rAo7QpmB4CcGVMQfsXLr+lm0b0b2+Hm1gi+eJX4uIx6RJzyc+yprSJOoDwaJO7vrQe7vZLckhY8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:14AM +0200, David Hildenbrand wrote:
>Let's sanity-check in folio_set_order() whether we would be trying to
>create a folio with an order that would make it exceed MAX_FOLIO_ORDER.
>
>This will enable the check whenever a folio/compound page is initialized
>through prepare_compound_head() / prepare_compound_page().
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

