Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3CCCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0556B0088; Thu, 30 Apr 2026 14:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8611B6B008A; Thu, 30 Apr 2026 14:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750066B008C; Thu, 30 Apr 2026 14:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 642C36B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:39:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FBBA1C01EC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:39:28 +0000 (UTC)
X-FDA: 84716085216.17.D31BD2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60A7A10000C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:39:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFTLA2bX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777574365; a=rsa-sha256;
	cv=none;
	b=YPunzS67vL7IUWU8XY+FB9PcklbO4EhU39ZJ85njcMUPKbftbvr4xIPmFc+DicWkHmXX4d
	5OSEYK4IxmnWqst3by1Kn0I7TgYZqw0knjH9BV8ifm5dxz1IMN3E3ObwYX20stFu2/MNSJ
	HdnyJdplLJck/PD4VHT5WBWb19NxOAQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HFTLA2bX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777574365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3TgwCb3E3Be4Ts3/mA76mTKUDmZh1Bg2ryTIzSZytL8=;
	b=4LxxHXb/2+wWCVP2eQ3cAhX61jCLtqmMVKrgG7DO1m1k32xd0ThgipUF8V2Ad0sXiZ36n6
	URPe767h7LYxKFY+lGwxKPdRQmiSbVpV/SHV8VrUCaiSKwLBZzyEB1+thfveQcQ7nFmEr1
	AXNnt6plrsLA8B14NMQcFJPc0j0QWeM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777574364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TgwCb3E3Be4Ts3/mA76mTKUDmZh1Bg2ryTIzSZytL8=;
	b=HFTLA2bXq3uh7/70FSVdJdBdQ/owPrjQI5TRqV6eB7SJ3Dq71RZd7RZwLgP0n/LFcYtiwQ
	dm+98fms0XvgBATW2INRsYPcUCINAx0uS10zEghtTzN04VYcFttESisvlVRKcBa9RXT3S6
	VVlhb9BxDBkRYrDhGBDLc5ZgwNN/De0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-250-gjXjjeXHO2SRWpZko_4cVA-1; Thu, 30 Apr 2026 14:39:23 -0400
X-MC-Unique: gjXjjeXHO2SRWpZko_4cVA-1
X-Mimecast-MFC-AGG-ID: gjXjjeXHO2SRWpZko_4cVA_1777574363
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8acafc224a8so29810456d6.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574363; x=1778179163;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3TgwCb3E3Be4Ts3/mA76mTKUDmZh1Bg2ryTIzSZytL8=;
        b=W3+mcsr7BePmsWqnsQwd8Exegmphtt8iIwjlvqRz+iNJzT7KSErsAQioT17EV1l8h8
         18CQhLxOGm+e1GJP5GpsSeURQCBbyrkYvnxJBghrKiNESb52ToEvfXFoNUmjylV+KW6x
         fiAnt7n+LsONAXhbNZ1KiMEJIDzYoYPP0524sK0ySvmewfDfrQJIFMIYkaX3w8FhQ1ui
         FTQVPKT3KUfRE8eawuHSmsgL/vVKQkVInE3A0I0FpBXTu7ys/gsDByzJDeCW7nOJg2CB
         RiUcHvFQ/QNDNAnGxYOcRURLii1HclE5Cb9Cp1nkBIq30TBobta1G0s0U46/lOcxoMeP
         mXVw==
X-Forwarded-Encrypted: i=1; AFNElJ+kbfTwCW8oIb5dNKeUrydVzh/dlGk627zpQVuBbu8PTET8Aat2SgbJzyUPsIPyDv6whQq2lH8Muw==@kvack.org
X-Gm-Message-State: AOJu0Yz7NJC/ZVZjFDvVjLHMqvZbEWkaB8WuCFvmcRu34XtL9Rp8Z2Uy
	MtynKkfm5F1pmqihhEC0tQ7m9C6DwDh0G7A5yx4qbVESkJG+BNzeAVAeTJYegnFkIGW63iVrUa+
	o4ztXbBjI09L/TDd9S9aG2CnF63yrJEPBrO8MUO0lh8gYcC0JiEIC
X-Gm-Gg: AeBDieviLDkZbD5RN3hw7wXN3DjO/vXys84t5JV82vUXXU+0L/o2n/OO9JcYNfY9MZM
	eclEAPq/wTPp8PrcrN9QCi+d1SMGIDu5tS/Hb35IJYlhUeCux0FrHqcUB7ScexX8N22xlguttoZ
	DLjWwo6egYYS9l1mAvXD5kb3TyIoehz21H7ut9g3zJBLMSPxnzgce30naVswQkFX/5MH8w6gDGB
	v8OZftJV3Ikxvm/92/W11JfZWH+ozaYs0gEZm3Cy4Um7eUpvLkaXNDVdpbjMU3bJ0OTFNc0l428
	OSWtThu4HjzDWFrMcddYQxSaq0K+uYR/TGeDNjgagHVXkvx5LBubeO/heR8t/Fads6XVFisC6Cs
	2+SHY+oi4cUkSyY4/7PK6RkN9BtYBhguLx7z5YV5Yj3+eAAOni9x2ptHO0GVqTSe0esLo7A/fin
	36OdD1snoEyxhxgS9oAxuKB3I=
X-Received: by 2002:ad4:4ee9:0:b0:89e:df5c:19f6 with SMTP id 6a1803df08f44-8b3feefa60fmr58693226d6.42.1777574362187;
        Thu, 30 Apr 2026 11:39:22 -0700 (PDT)
X-Received: by 2002:ad4:4ee9:0:b0:89e:df5c:19f6 with SMTP id 6a1803df08f44-8b3feefa60fmr58692596d6.42.1777574361605;
        Thu, 30 Apr 2026 11:39:21 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-22-70-53-202-134.dsl.bell.ca. [70.53.202.134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3ff471941sm24955596d6.42.2026.04.30.11.39.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 11:39:21 -0700 (PDT)
Message-ID: <616e4945-0622-422a-ad6a-6f8749a840af@redhat.com>
Date: Thu, 30 Apr 2026 14:39:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 39/54] selftests/mm: hugetlb-mmap: add setup of HugeTLB
 pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sarthak Sharma
 <sarthak.sharma@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-40-rppt@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260428204240.1924129-40-rppt@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: w6gDYkAx-cP5DuXqoKpSYVgkzGazjBUnZ62eqQdcQeo_1777574363
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iwizh5mtkmx6zgbj4jfnnk1ecdutmqx8
X-Rspam-User: 
X-Rspamd-Queue-Id: 60A7A10000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1777574365-826405
X-HE-Meta: U2FsdGVkX1/YzQC8h5N1teKMVm9UfAVq2icsHqtOq4tuomPSWoDvXg0Rn2KqqV4qdmBJPxoiSCRoFfhi1BbRa5H0WwbSaFayLAF2soLmQY9O15u2saAQW5Op0hATZx3UlojAcaoXUVqPMTl1WsvaEefIB9WfkuoqWoGXK4dKMyz0PyNhm5nACFsbDLGgU8zoENPQaRecBUxkID9o0n4EL3lVU9vY4e9dThXV46mxXjk2egQ65KTgEQHNohVcFJQl2vfppxezB/OXKBKzc3SOlhnIzhmiyONRSMB8ehhLOU+YJV0+bDHPz0LatsyFvVWvA+aVRMtsjU/eQ7bNzY21M9LQZDa/ZsJyL1SOT1ltcGPbB71wvUDzlETu+aXi5V98PUVGekRmhX0YONQox9VDrXtz05ANZH1wHmbxinrvDQmaxSTPJ+qr0oAn9O6gR+dfEUhxtuA8Yereaz/SPnlWBVW8i2/l+hU/2M/hKsbpKqBV6vQ3B7GuVd9JF/kYnf4MuoV0jIdtM24uEjyzndbDP2PiEJs48I7bxQhJfhdyXIBnrauLsAnGWR6riobWQ/zho2+ngvJiwxSo9PzTDZ9+kruowxTb4+5XDft/Gl1q4uZHvqe0O9pra0CmpbVnOT0688IDNKdROGBLLdp/FAIMDNWa1Hkfv4+JMhM2C0Ne7h5ihMmewQBbPz9TAIo1Rr63vKQXFazENd4hjTIOQIHCF15v1WkVU6LeclBaq6/IG3S/fJ16u7aHjaLprqoa8Qfx9tkl9W/7XUDx07EVMA0H4ZMAGxGereU1W3PUT1OCYj56QxR8R1q5NKARqKcDJVnT8oKIL3+Q5rWGJBJCyNSzoaLLfqfP9CRt1b9N1hVgr53oYpx4x/u9FQbIUVRjQ9mHWP2OXYOG7XI/o/ANtjeHzXxFNdmlirW2AkUqgEWduIBFt/dqWte7XQXCb0PUERZSUcDKA+QGIMzwT+0RRyP
 LOHc/OkC
 8nSKYO57g3c3Eh4sigcXexWO2K7ZSxFW4n7hiHS0Nm65v71owaMJDAHVItj9cLVy3N3BOItYTaBYYvIgywfTf2Gw8FnjaGYqnaVoTkqOMa09pCQlFxJhvt/dW8pn0+cAO37u08QpEBOnC8ldks0w5AsIh2FtMNS88vmrGmm9rNfVZDsJnZw2PbyiLWzOC0naFO/5vezZ72FSaO0KwQCoojpsx8bYAgM+FhXyWZPyQeDqVo+ZqQsm7Uupi9l1ywtemuivpMDs7UEaO40qhu2pOiwyyHABn75Dvfo7Xr9MCj+1d/rpChpldz6UzRriEj49lN21BBB8kzcbmvz93vgIjqwjhtuLN6h9VWTXj6QwrDVrOMdgtwJUpNIihK0ZCnpKjhxUjrk1glN7Midng6cTXu/8lup6ycreeftSDO6OvGN3CgddQjn9360UJwFLF8OBMuRw89IrE/JVxag3aCUuKN+YOSgSNekM+AIVA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-28 16:42, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-mmap test fails if there are no free huge pages prepared by a
> wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>

> ---
>   tools/testing/selftests/mm/hugetlb-mmap.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> index 031085cb7d17..f12fc288ef4f 100644
> --- a/tools/testing/selftests/mm/hugetlb-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -109,16 +109,16 @@ int main(int argc, char **argv)
>   {
>   	size_t hugepage_size;
>   	size_t length = LENGTH;
> -	int shift = 0;
> +	int shift = 0, nr;
>   
>   	ksft_print_header();
> -	ksft_set_plan(2);
>   
>   	if (argc > 1)
>   		length = atol(argv[1]) << 20;
>   	if (argc > 2)
>   		shift = atoi(argv[2]);
>   
> +	hugetlb_save_settings();
>   	if (shift) {
>   		hugepage_size = (1 << shift);
>   		ksft_print_msg("%u kB hugepages\n", 1 << (shift - 10));
> @@ -128,9 +128,14 @@ int main(int argc, char **argv)
>   	}
>   
>   	/* munmap with fail if the length is not page aligned */
> -	if (hugepage_size > length)
> -		length = hugepage_size;
> +	length = (length + hugepage_size - 1) & ~(hugepage_size - 1);
> +	nr = length / hugepage_size;
> +
> +	hugetlb_set_nr_pages(hugepage_size, nr);
> +	if (hugetlb_free_pages(hugepage_size) < nr)
> +		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>   
> +	ksft_set_plan(2);
>   	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
>   
>   	test_anon_mmap(length, shift);


