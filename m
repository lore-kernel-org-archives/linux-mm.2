Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8976ACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 08:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23538E0012; Mon, 29 Sep 2025 04:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5BD8E0002; Mon, 29 Sep 2025 04:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC37B8E0012; Mon, 29 Sep 2025 04:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A530A8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:13:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 758E7B8103
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:13:59 +0000 (UTC)
X-FDA: 83941574598.05.2320CA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B1DC1C0009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 08:13:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b7yDvBY3;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759133637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=825b6zMzjY8Y+RCD5NI3l7UYrvSfHC1zXq7lSsQhX40=;
	b=hk7oWlQLJrFnw69K3Ad3lU4NBAhmXQrvR+JPdUUebzXZ+f1ucWfK+lqKk1GEJh/XEfv80u
	ntTQHqnTBh7TvoFmTRhab3clpexg2XsEv1YLbKATY/LnU2gNfH+yiO5BdjuKhyeKRPbhZH
	NOrMNvHYH49Od/KVUpi9MVfL7rJU/R4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b7yDvBY3;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759133637; a=rsa-sha256;
	cv=none;
	b=YY/jSVmkTHbXY4R1/JKmy0JfJkqHJeH3AYLSL7g8bZvjHOftpnFCmU6Rpq03FDSGGo4P0r
	ZrPuru+LTNtgfw/L4NuZw6tfYFlM6qF+7liD+d6fc2zJDgeuMAMB9YoDeLRX08Pk9DbzRu
	B1OVwqjK/GRaiLZvPA1nFFLCkZNAyJ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759133636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=825b6zMzjY8Y+RCD5NI3l7UYrvSfHC1zXq7lSsQhX40=;
	b=b7yDvBY3TRRbyzqvKaof9OWRhYsEb3CzzTMoFlTaKdpM7dsl8sO/gxcvJoZRinnsU56+Wi
	pn0Mecd4XEVcBZFTwIFva/Jz+hqyblLcB7oARFbLNlsZHDpA6q9SBQerRQeYB383VfTDca
	zIroHfVb+4/wYCQtRL+EtWcl8HyWKlo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-AAe9K7jCO1WxH95oGN7VXg-1; Mon, 29 Sep 2025 04:13:55 -0400
X-MC-Unique: AAe9K7jCO1WxH95oGN7VXg-1
X-Mimecast-MFC-AGG-ID: AAe9K7jCO1WxH95oGN7VXg_1759133634
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ee1317b132so3569184f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759133634; x=1759738434;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=825b6zMzjY8Y+RCD5NI3l7UYrvSfHC1zXq7lSsQhX40=;
        b=UovFWUdtTkJ+NvIZ75ixb+8PLyNAksHX/D49gWOYibbM43DYuKs08i9KR33iTgNAFv
         QqWHxufzzUAiTa4Z7KXBhQwuKqUVdO8MAuqNuplFFgHVEsyGYHzNs+S/f0uDfKPaRiCZ
         cwk4EqNOS2jjoRe45trvEqCSynjCpvtyaYPSE+pAesD4AQc91J9rIivhBQKYyJfhLGqO
         f08g2TPkHEwAUl6w4PNrLdrldv4/ceenhmO2BimJnEJNAWDMhGdURf303Z3LwAuhi+Tx
         SPA9/xsKz7TFhxJk6m/YhJDcHNSBVIC7TvXbjP5KA+kyn4iAfvcaDNWn96iszydbJ5GP
         y7LA==
X-Gm-Message-State: AOJu0Yzn9hPMYY+AaEgSNNXx9y6EZv2F/ojaJy2ZcHIrCT+/r2kYd3wc
	ma5Qgzz56AteqPUOvgRwdmfGBU+GA35Yex5avo+h+5+Hcn0oGEkfXSfzvUU6BV7pqlBfWJI24gj
	Vvfhf03XKnMV4HG4d9Luj3j7vPa5lger/Nj3OaEMmevWGyakGQXWC
X-Gm-Gg: ASbGnctiRZcI88/agpVBc6/4TFVfN0812loyL0Rz+OLI/pDABI4GH3TPdyHhT+3DhmN
	Y6jcqb+O+mfA5kUSgCY3MeQI8DbQCKcflsGuQ/awYfRhW6TuNDr6dEhKBw9C69PMcOjmVlU+H/T
	CsWZ21A2ZuTU/5hcB3RAmX9FnTds02bQeQLusI4JY3kLoK0lVm763VOg2n7Pm1KttNZgeJz41SH
	9W56VeoQ84xmewf+3BoV9bnUF5gfwGIfQXFxmsNRdg5hEs946kAOauBcK9+HKQYCLIE/M6eBshA
	69zyPDsXeZkLgBPJqF3hBdeK6dXdhE77/QrUsJD7iC/iBZByzMdM6W0szhpN0rEvJw6SOq+0pti
	KZcBzubfookGNG27yFIko0Akh7zNlWwB+VOe6uvDYjN8XATNaSI9XNiTpJ0jGe1DdHA==
X-Received: by 2002:a05:6000:24c3:b0:408:9c48:e26c with SMTP id ffacd0b85a97d-40e4d9ca9b5mr14140267f8f.62.1759133633765;
        Mon, 29 Sep 2025 01:13:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlNo1L0uDKeL2uvczlG7NbrUWKE5LpIxOTM8w8OoKWamJNh/2Uv61dFNnXykrR0/bRanHr6A==
X-Received: by 2002:a05:6000:24c3:b0:408:9c48:e26c with SMTP id ffacd0b85a97d-40e4d9ca9b5mr14140236f8f.62.1759133633389;
        Mon, 29 Sep 2025 01:13:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f05:e100:526f:9b8:bd2a:2997? (p200300d82f05e100526f09b8bd2a2997.dip0.t-ipconnect.de. [2003:d8:2f05:e100:526f:9b8:bd2a:2997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm17183198f8f.44.2025.09.29.01.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 01:13:52 -0700 (PDT)
Message-ID: <2e7ea9a0-9235-4001-8aac-f5b124011c31@redhat.com>
Date: Mon, 29 Sep 2025 10:13:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v4 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
References: <20250927004539.19308-1-richard.weiyang@gmail.com>
 <20250927004539.19308-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250927004539.19308-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gOWi593gdZzwk6gLt2nYGY3mGbuI8naKek4GjPnfYzw_1759133634
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4nimzayyaqw41rdm61g51tdcy47gbuzm
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B1DC1C0009
X-Rspamd-Server: rspam04
X-HE-Tag: 1759133637-66730
X-HE-Meta: U2FsdGVkX1+5Fh+/YpVq9/h1XiUyLR/8VGvjH1pL1V0xGSjEM7FvpQTkcYC6jH21JPGsyz2drEtm1U0ptMdU0zVXlq4V6cAK7HPkH89lplDe6GQeBePSy54bD4uffugiX1+HOvUQChrYGcvxf2aIqSOUfkxbOhEltP+qoZoQBgwjnjJZH81dhmDKNcgEAHjBxej6n1tSvvHcKKqBnEYqRJId8DfvQf2rPAEZFLEOdQxaeHW6goJHd5Sjn99wp+v008wk2NtAb1k5h8EpTdCrzN9yRtWxnrkNpMJ4hh0LQ6w+E5YDFKqe/jbOrfddhi9GeYd+na7DhSynSE34RrO+rVzVbyEE0kfrWgE+SFGvKaj3JbmuuCu8TBw1o9g7JuNDvxabopmcPjx7KW6I0PZq0xkyNqHAfOEPPnEw7eQ4fODPLRWQIeU0V7dpc8dk9U3D5CHvguK2Dq8pYUaom/KSXLgz1gHpr6Tb02qYHLl12CGtIhXtDm/EX/P+TzMaMBfXBW83pEO+TC1Y7LV7uresdLPonOaxEaXyFCiu1igwTC9mL7j5iMIKusLOW5sf7o9iIOkF08xQJG5m/0PAH0bKuE1Eca8Kzu56WMLa6WXaaUk4ILD0+8LuIAyyQL/b/pOt+Gy56USzc531i01qGGAiw/ejew2Up6rWACldOEXiiz6y9waLv7NLo1veHxipFBp1gzzugCO0SSQ4JkmE0ZZoFUxYj+7yMNM9uRLDW4xKwdIMvVzuirydB4zNgi+/3t5hidL8LpXzKiEfxS/iBwGWwP/mMHJP3AUmPXUZc8Ei7/ID99pDJSFZZgPQM7l8yjPHrWnSHUHDgoi2GAwZ9wq1VaASVwE6K3Q2C+ne9as6RTcwrpPoQTNGe95pgabqtoUiCXeSH40EpCHHYSUfDE3HIRUyf+d+g8pQuBO8FeC+37QMMPE47P7tnuYLf6ErxQFyFd/TpRUqb2chEvH7eoe
 h57ms5sC
 /dWTWJpUKyVIItbK/c3smrRgaQczdHGXbGaA3lIoLpjMO9Z+ApFRgiALbKPXCfq6MnW5G3idpgufg/doWw9U3mAl9rSQO+UrmS1NzhjuWplOwUQBhZyt8q0Ei0LCyNl5vTCPTsM2Kw2Sny/eJii1CC+l/mYqif5zLwf52IvoHiMeK1Bb2EsNwKE9GfhaEU8ccJL9HQJoT6d2nfRuVH2Kg1OTZW3xNfrdIxv1WlmzIb1yNLYS9S3nC7cpcs/L0qoUDN/9eKtFiABNyIl3lM5ADYue8o8r9i0wcIN5N9WuBrYFP7NfoVHde8duwXNjK8JMyshPFfZ/P/fNX1OEwMom4VBXdQkBHTZINrBsS1CA7Ml1YH6tIv3Im8kDycMHEu6ruMk6whwqgUnuDF6yZCfg2UNzThx5lKmCN9ZfU1DKs8NVhLd898mN1cShoPfjTub4dRf6BIICBfvpPWZZyV/NqdOM1EVzxzp2S1YZ/XxCiPvv7LN6IbJlCW2Y2yq/IlM6p2eXISn4Yd5CamKMz9ryLReBQ02+dayGLgza4JarHfVqqe36LV6/b6C6NSE+3KEa5OrFWUXVi3fjkminzCaR5JKZrQr78X6xmtUhHiZLi8N1UgnGMgh9T2sY4oihzq/q0XrUriMP+BPoVt80i77mbMnpH3xWt6ZWIx7QGgZNpf5KWE1d4US4zx+4oV0ZARfQrD2tgKRxLEAMNQXwUxSKfOBUEDw7SrmG1yEfiz6YPF7N2qHBQcP5EM510jSN0WGiZeW9tniMCnLx639vdhZDnzOxEDAZ7Enr33cyERAFwYyX5/Tdr92COh3W1tSev/8qeyMzv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.09.25 02:45, Wei Yang wrote:
> Current code calls mm_slot_entry() even when we don't have a valid slot,
> which is not future proof. Currently, this is not a problem because
> "slot" is the first member in struct khugepaged_mm_slot.
> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
> 
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


