Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499C4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:58:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064838E0060; Mon,  1 Sep 2025 09:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014EF8E0006; Mon,  1 Sep 2025 09:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F928E0060; Mon,  1 Sep 2025 09:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFF9B8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:58:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8060F160876
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:34 +0000 (UTC)
X-FDA: 83840836548.01.729C8C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 59F5814000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:58:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MQf6XXzN;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756735112; a=rsa-sha256;
	cv=none;
	b=5ncKbkZobYFX2AWYjem9HpXgQcFHrNdlGKlj3RM2bi5iXgbLNmyv/MpTRQbRkhH/uYEyJG
	TIE69WKt+FZq3cyi9Fze1ZdW3ImneySb8OQnwQ8KImbXq8hpV6rd+jmfKdlf7A7glf0Pvm
	DKKwiFnQdDEhLhiOV5LCkanZD8r1Rvs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MQf6XXzN;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756735112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ouEgWBG9S9w8yO368Oo6KmFAlN0WSbR0WI/SVZscpXU=;
	b=Xf9BmS8Hs1cqT3rt9RY0AthtsImapvjNSYTXeqdjk9BGxAo2e/lvw5ExpkYnci74OMQ/WC
	MHnpln8VFml90Y80bd0q14Xt+RR+QISSjQ31uerotZZhCh89ayRGeunkXUds/sokkmVmaF
	cHWaoiRPT6i8+EdIG/I/S9SFMyHV2UA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756735111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ouEgWBG9S9w8yO368Oo6KmFAlN0WSbR0WI/SVZscpXU=;
	b=MQf6XXzNGtBhtWHo/V3JYz4S6Cupf66RzXQl+a4/9pjscLBL2Jaf3+rMlkfKUZbS4SBY1m
	n+JTHWVx4EQGF44/ZPi9TugrLF8/RRGHaFyzyIZILHuTxlZLLZMKFGSuJog9K0DfjOajWJ
	c0b5FPoYGD9RftbTsQ75kN40UCrcpYo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-jvcNrBnoNzSJwk0XY8b9Nw-1; Mon, 01 Sep 2025 09:58:30 -0400
X-MC-Unique: jvcNrBnoNzSJwk0XY8b9Nw-1
X-Mimecast-MFC-AGG-ID: jvcNrBnoNzSJwk0XY8b9Nw_1756735109
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7265febdso30050235e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735109; x=1757339909;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ouEgWBG9S9w8yO368Oo6KmFAlN0WSbR0WI/SVZscpXU=;
        b=qg6SjMZY/VXXbynnU64XmkqPIf6BHqppAtRh7tQo5ID6LCRhFe8DTkz1fgX3nh0+uW
         cTNtb4Q0u0LavIWaBlQV4qPX0D4RUJ2HNXXu2auF1MQqEDNfvQfKjYtbfq6iAYnWJl6N
         d5RhM61q8AFjrunLJvSpMtEriK6gU46nztlQ02MyoOt5do7TdRtyBka9all8Vi0G41QL
         aSq6SeDdTNxvfIE+79jeF6g88rUf6k1gfGs4XElYbYktlS5DLob6a228cJvyuR558tSh
         RJ4AUCyshSOcsn1+oMTwQGHl15i7vRklRnUjsmlUGQzrEmfokTgj6E/Ietw+as2Y8/wv
         3eHw==
X-Forwarded-Encrypted: i=1; AJvYcCUQmxeboaxtNlwj3DwqDd4iuCpNi2crr9Ja70Ns+M6TvsoKdFhHDe4QmvkOJiJZpfGrg+Nkc0xTzA==@kvack.org
X-Gm-Message-State: AOJu0YxPBMdBoUi2PgvQ+yuLfiQHqk6bZ782zLqP3dyma00mK2tRRKiW
	SrtvHX+Ab/LIfz7xpJ7NV6HzZxkhdlcRicz7k05QVTlNeGxpUkR1T92CGMD3dIq8LoyGJzLFta6
	du7g97Q3Uq7WkYt20+zM1lMLk+JswSsNxpDwlxNsQ/sM1cud23kLp
X-Gm-Gg: ASbGnctrDlCH22GPASqhQUjWLyJ8zZrSl27bC2RTymx58fui2VtqLcuHVppvDYKVGO6
	oRSozwTqZKNFnxmNPUJfiN04ZWV3AuPNP0GM1Zz0nFwQVZZ9ADI6h9185vwQzttflM0XqVaQxN6
	AChowmIGqg2Yhn4c8uZb3RkQRk7D15vSyLa5IpOSvzl/hiqg9G/1fjPkWkzbNIFoZVjLW5bSY2Q
	RSkHtuf65IgR/Ox/MO7RtMx8d5cjs6laTCU4dmId3XPlng7Pc/ezWfcPHt7moyXMTX60OJFf2mZ
	hDZoo2jVyNgIEmYe7HBdbwAnaPPBrxmNlLAn5ZABGv0CRQRkNFk9MBatuLF5S6IoSimng2GhFTp
	HQTV35CiK9ZSAby7qmAMlUKXc3FbWr3iA5zXSmJxdBoCtHWLXomhUeqK0DRdmPiWblpA=
X-Received: by 2002:a05:6000:40da:b0:3cd:b0c1:f9aa with SMTP id ffacd0b85a97d-3d1de992040mr5005432f8f.18.1756735109301;
        Mon, 01 Sep 2025 06:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRno0/4M5FVI51DPUT+NywmYwJkSgIjJ2gav2/NLIxgn/5SvMqgqXvkYf8AQzTH6ogoMO3qw==
X-Received: by 2002:a05:6000:40da:b0:3cd:b0c1:f9aa with SMTP id ffacd0b85a97d-3d1de992040mr5005405f8f.18.1756735108751;
        Mon, 01 Sep 2025 06:58:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc496sm15630922f8f.1.2025.09.01.06.58.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:58:28 -0700 (PDT)
Message-ID: <b379e134-d946-4c11-b5ba-0344c852d49f@redhat.com>
Date: Mon, 1 Sep 2025 15:58:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/12] mm: constify ptdesc_pmd_pts_count() and
 folio_get_private()
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com,
 linux@armlinux.org.uk, James.Bottomley@HansenPartnership.com, deller@gmx.de,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com,
 davem@davemloft.net, andreas@gaisler.com, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, x86@kernel.org, hpa@zytor.com, chris@zankel.net,
 jcmvbkbc@gmail.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, weixugc@google.com, baolin.wang@linux.alibaba.com,
 rientjes@google.com, shakeel.butt@linux.dev, thuth@redhat.com,
 broonie@kernel.org, osalvador@suse.de, jfalempe@redhat.com,
 mpe@ellerman.id.au, nysal@linux.ibm.com,
 linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
 <20250901123028.3383461-10-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-10-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EaG9HG7osair7677KQppWNWgtVN31CYY_Q9ZjQrooXk_1756735109
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59F5814000D
X-Stat-Signature: 6hnnjf1k453pjsdpzatoqnq75oq6hfkt
X-Rspam-User: 
X-HE-Tag: 1756735112-754177
X-HE-Meta: U2FsdGVkX1+nIzZbSjAhVQW9WGt/kVQo8A5quRwTmn6CnH1+uKk61+GU+rI3aoLhC2d35NFGR51mX6UVqX3OncaBqwoYf2uMMK7iV46cVMhSFsnDIoziVx1IrY5IXmPxtEKW82SkWyxDvYA8DFDYhB+I3HC7Rck0phmLcZh0XR3S/mel5A3zdYgqn5jGfuVKcWaBKLxS/HiULAnPWzSXqmzDNRQ5kX5qhjFfQXUEKW6HbVMkwXOJHv3NopnLcsFy4c5aofN6OWoD6tfgAFcnJvvmOtiD7pj2FSEath72UD9oGsuZhivMZoalG6F+tg9AGj3wfMOlwIq7/S51CPiCXvJEDSQ5trIdMR7TUaEgPDem3mcUfgBkdo2gZz+K4b/ruY211Q9I1A+HvMErwQnFDVYQcnF24zDfU6nXlpTdVcZyAR0OvohZbpHrL7my3PQ24x+8SpVjhlSVKxcxdnjiOAezBQfT2wjf7nMKUUerk4X7aZju4VA8FhtfZ16XzCYUTgOE2JQX8ox70iaENhm5PQGrz/ALJAIUIaAXKnJFRGoB7BaslPDaBtImuWkS4LrgpjOW6+kwlBNRCm6GQewqzFdQ6v61caLcANiaEtIwN9yJb0YkEnGOvIiKjYVV9oDNO+EzsnvbSgDzCkRvSOiV9nghyBuQmtNALDzU1QUvCfYM6xOIPXrGXmE13rvMqPo6BD58gZyn1oTArZB2kagJ/z4nH4nonK+Ar1LKSqM05lCkCSG2HqwWoI1eaMXzQ6cwYAGcVHq3lxHj0fLf3LTQSxfPzGvz64WWh8Q4wGNx8pgM+QpzYDbFnHdpFDCWZ2tEpHVelJiYMqRwG/wrDSd9utlFaoRKyrqGsPgP7L577WhA4+bFhWC2QlrUUoFAtIEjhVFDzdzjD/S8fDfZqf2B7ODi/0S8pN3rSk5tGTvu7OsDmuL8HRflrL5yG9RuSrdlZsz8f/RsNmMtQ3YW/VV
 ewbhhOpo
 2HKFLpOGdmLym9tcw2sL62kH1DJKJ8YzZCl9X/aCfX6Expek33z78ktq6p+6lJePVwOedCM0WOOITfxjvHIMCazk8Ox5MncGyCnsC0Qa4IBGReqWuawF3g68I3VigmaMJDiBr2EnWd0TfPyB6I05wRk6GuWJMbhw08re+2w97Rk7KDLeLZTJukap1O1pFASqpJ51AlOCuiZ9czK7hkOtT1nPFj0n8kPGfKD0JEZXv4kiG3F0WDFLX6/wEg6dpWRL2eA7JhOEprCYJS6LfPOveVHWOyHwNpfZjLodG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> These functions from mm_types.h are trivial getters that should never
> write to the given pointers.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


