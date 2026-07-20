Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5672FC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D6CB6B00A3; Mon, 20 Jul 2026 11:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4873D6B00A5; Mon, 20 Jul 2026 11:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3501D6B00A6; Mon, 20 Jul 2026 11:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC34B6B00A3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:49:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 712D816020B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:49:08 +0000 (UTC)
X-FDA: 85009588776.18.63C9536
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7A0A2100006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:49:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kVVkvYaa;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784562546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89meaKDhwFe10Z71hE7i2nRHODsJTbsiRnn58cHYtjw=;
	b=fQqDP2RwLKJqS/JNVnXyZ0XOrGMePpnUwMD3+ykN6gJexfMkNU7sWFyUKzoiXofGxx34mk
	Bk7XIZwo1gsXuviCQ8NpzKDdeS+++LR5Q7Nie7F5ybJCL1uScj6f3sziDaYCr4epLv9+Mt
	VJC3nqkNKiuSwv0T7eB/rFzcr6MOaAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784562546;
	b=rRORXyfQtf22/X15i8ptXTGjKU9jx0ijuKU6YkfTabdzO3wrlB+3Ft/IMSTdDkefkGO92N
	bkhpBgXFd5CFjGS1jl4szqRGbz9EKHjH0pOgoxy5Idhwt3rf+KTCZb5sW9Wp62L7XvN6hA
	iITVBwWeJyGSE8KwOp2Qcq2e0Mj2Ye8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kVVkvYaa;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e622cc874so763066285a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784562545; x=1785167345; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=89meaKDhwFe10Z71hE7i2nRHODsJTbsiRnn58cHYtjw=;
        b=kVVkvYaacl2mSO9tlI2DkaTCwKsCsWKxIl58ILrDhp8oAiudApBl9stewnbJZXRp2U
         NfXsfKZ4r0dTzb6YMFdsfgqZuaAxbMWiDF6D9eNRHNtGc7nVMG2vAV9qfmw5cm+nVjWY
         jwvkZqtl7ueL0tYXG/9fkaUCgwq9jIp9Kuhb1OM+y57CiUzva3Q1UPEy03l+vbmsTWEV
         5NXY9v9o9vZ/oiQUS+LE/Q/yo9f4uTPuV06VO2nZu5n7MaBjRl5CclaBgL3yTKagnEUz
         8j8YfWNVfAuoGWlyifgmddiX0krueLvEqpX8NylEQJo8Apa55PGUSzhB1NzNv9mI57Ld
         h8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784562545; x=1785167345;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=89meaKDhwFe10Z71hE7i2nRHODsJTbsiRnn58cHYtjw=;
        b=cBoFA81tcaCAgFbEV2VIkFmi5icv2rfYOsUxiAO/ikeslKZqFFK2ubpWpET3fwBfEu
         4W2s9gwVLb5v07nTkc6tmGXpvILuGeVR7lEb+6j2gJKdJ2D51jY8vIK41jiPd6JWo+h+
         zM9phrjAoRhTBn4D2I06JQ8VoGdvfEsr9X9QdTEdp68HAAwO9nJP9IZzxlsqTm5eeXez
         OIlEv6FstXRwCS0pjo8UceqoH99yJw5cR0HkxdAMtNmdpeeaffvPjWzcY98MNdKr3+rS
         5f41ieeTDgDNSsOjD2uuGO6tgQe4TxjGg9hMdUoOSLycSQZKSQL18YPMSLG66JdbxODj
         V0wQ==
X-Forwarded-Encrypted: i=1; AHgh+RrNTc23DX26PDOQPaw2qmMRIrhaU+hGhVo0zRTd6JYPAjDEQQcGg6oDG9s97RhaHsCTSOz/kVw5OQ==@kvack.org
X-Gm-Message-State: AOJu0YyS2611WNqh9xYsRRYwTBwVNKEPdusLjI1MeXXnro2v1dD8GK5T
	QlcgErlI0TdCjZK3VjvFN9PTDEIUzgdU5ABwU7ST7pY6SsbCX/8yiPSx0AvYNhCViNA=
X-Gm-Gg: AfdE7cl5rTAulCpZ9peOCI6R/lSN51wOPcr8RHYtxTN99lkXISo1NXlinVs5yVNNIKQ
	CFI36xuXt2whQu4q41pilrcdGypLAViXLnikGluMyrv1JCMWGhirG9a6sIoGYRCv+ME0af6Qbqh
	pv1YSzyb4CzsnKikE7arkLCaauw8X5qREoDWF1lFWKIEg7AUaadlHYCpzXW8wkkjmxPMyPM6HtI
	U6VRpY14nBV4f5wOk5xfhTPGzucPNdcgjj8itmmwJjydngD3Enw7Q88blt2H4drL3JBfqDhhLwr
	QuqVvjLC1VjxjFFKXpfbUOV6W471aZmyv1Uv139K2MM9nio1Cu/v0jsYu+TZGy01zcFgYIq10eC
	A21j5dCrtBkvQmV9YFoCE1LvZqCQcyJSpO1Wx+SgVOXSO/eXhfrTxG+kbOQqn58KvS5vFWbvrbM
	hDk3qh1PH5Z8AJ9E5JtbpeId0McBKvjz3WxGIq1gGQKn90sPJI0VVEmpkUWg==
X-Received: by 2002:a05:620a:25d4:b0:930:ab28:9459 with SMTP id af79cd13be357-930b41e29bamr1533354985a.56.1784562545561;
        Mon, 20 Jul 2026 08:49:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b54773fbsm894382285a.39.2026.07.20.08.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:49:05 -0700 (PDT)
Date: Mon, 20 Jul 2026 11:49:00 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 01/15] mm/vma: introduce VMA virtual page offset field
 and add helpers
Message-ID: <al5CPpc7XpRX7Vbt@gourry-fedora-PF4VCD3F>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-1-2d549757a76f@kernel.org>
X-Stat-Signature: wopa84ieyax64jgew1ygrf6cdx486e34
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A0A2100006
X-HE-Tag: 1784562546-236443
X-HE-Meta: U2FsdGVkX18QtOWlGNSi3yL55dxrf/rg1t0ELLnydadsKALe7FV7TWsn2d3xa3vjBNHOU9abDDjNwsLIdUWMy8EkEVWYdzdEq7fHDhwTlvmmjfFFmmoW2pOz+9gIom5n75w4g0zoaaF1dBpcGSPmtVdF/5ifcmNbhOCeUlb/8D050/Y3UDeAv7dyCofCGu6WJffwWfKUqY1qkUeEVD1Ipp9dksZx5Jlz+PXGRPXv2J4pUAZwbMhOHSfZIOagsVIKBsaJPyzDKIkZoQMb4VNARhuNvakXKTmqI7Agka5DJJ+RMe2eKmnxAZskQgtO8HyUQWBxMjxeKXqf50KV4GV3z7BhujJIT7ehWVaEEZBH+rn+j1R6434/Bni5H///FBuJCATPVNsbso4CY3OcVoQ18PV9QGYjXstSS39hKiiz7eZl40pTKbwQfbG06QWEHXeo2y0tE6zUhwTwRsHE1wMS2FVl+ko5mxE7+DZVnm8SaOecLfTwyj2Muw5u77wB+Q0fR9dr4kS/eHmYvw0FKXXKVWKwAg2kiFhH4MOzchP3ASquc+vW7LqfglzhPO1c7Wzgol+Kz6ZbJjCfU4e5aq3LPYZ7z+35esigIjd1mvsvp/D8mg0NoUMo9zsuviRowhNmck2qVQLtmsT8KUuuPw76wMNpy5CLwO8E9+TNfL6LXJk2V75uMqd90RmmE9nCRG/bT8imwC2e35NmjtUZ0j9H7A68fBPM9laVTphX4VQ8l0+hZ3VL495yR4UAQDtPuv7v+Rh5cQA22u5MFFzm74aqVPQ5fZtsvuVhRcdomz3X3D/QRfo+zePcslQ+U7rkyXuZrL+99/hQ2ipXfn9q6QKZK3KH1OUUYHTvlexT1qZad98vAI/QFwVi39B8eYQ3zL3dYKW9t54HGmosfjcuwXKf5k/T6NncmAUCrRGc/OcdN9WWXHBUwkIOYb/FY0xdiCCUWSI/S5xmNk3m2lD/ni2
 CSZ3PGzg
 2i88oMWXZ36Vxz/OKNgrKtOq4YLSzt0xsUVrlkEU1z4nDn71Q3txTeb0b30qkjVPm1IBRR2qyxvsJ9CPAxAQwooDkZ5cF5H46QnMB+pjlUmwZAYYuUM4xb/ZL7IOEkecTqFqPVETzD8uHJqIUtdWC/q9ouYqWJ5nOSGJukca27DWq2banlVaVckOdfwyPsbNsUTJDTwwp+FQ3rEn5vjRWcWzIGa930+0M/Yqt6Oh7ZKt73ClSQL+cslw/+L0yfpvA0y27Qknt1n8TxCQI1WQ8vZoxoYkIvDEEsAM9nmbXczK//EqLDWFR8nfQ/mFYPnMoKAi7KYpFEOkVur4NYo8i1lwHvbibV0AiCb4BQ3SpSyNb0LOk6dVHGFg4gr0YzLZZR3IY7lFlpourO9JRsJnjM62l8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:38:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> 
> The virtual page offset of a VMA is equal to vma->vm_start >> PAGE_SHIFT if
> they are unfaulted or were not remapped, otherwise it is equal to this
> value at the point of first fault.
> 

The latter half of this description is a bit confusing.

Why would the value differ from (vma->vm_start >> PAGE_SHIFT)?
(because it's file backed?)

It sounds like this value can change in response to an event, which
makes me thing a reader could see two values across two calls?

Apologies if i'm fundamentally misunderstanding something.

~Gregory

