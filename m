Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76F6CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 13:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE178E000E; Mon,  1 Sep 2025 09:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DDC8E0008; Mon,  1 Sep 2025 09:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5572E8E000E; Mon,  1 Sep 2025 09:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 337D78E0008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:48:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEBE71DE615
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:48:40 +0000 (UTC)
X-FDA: 83840811600.28.44EDF83
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id A1D0D40013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 13:48:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AIK7HAMZ;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756734518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=KbWzt6EZm5PWa6rcY46y5P6laguL6UbPpKpoBdeQEnxrBBf1QAaTFab+F2teTE3xV9FdEO
	DUwYjVQZc95s3J0neVu1o28NtjDYwUokl+j/iXrT9PS5qYzzWILbkpED2pJk7wuEmR+XnN
	kah826Ery6OWzqS+jAmX5CJPuN1zZP4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AIK7HAMZ;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756734518; a=rsa-sha256;
	cv=none;
	b=IF+uezqWqR2mYlbFEJKP8crLw9Aapx1oUBLDOrAthCfknn5x+jp1aUOO+h25J2br2smIzq
	GK3dn/yxNA7Q/ph7f+JwzViuJmtH73UO++DRAfhR66wEaoQtxj5O++4+ApENKAQv4bCfnP
	uiqbZjgs1Ke2nVn1RwFQULyXe3FIS/k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756734518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
	b=AIK7HAMZ7hQU9F+NYTF32Fvnl72aibk2+z1X2YWbtdrQSRBOnmbXbjVwOYgPctrruiehCI
	viwZFtReDbTjcUdJXmfNV7KXc+SWlhxXyxp/b37SWYnqs6TLrA7cV7JqKr30jhcSw+8c1E
	Htt2TzVvA+itf/C04mR78065zS/QvXM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-sD3sNW1JOGahpCftUgzJsw-1; Mon, 01 Sep 2025 09:48:37 -0400
X-MC-Unique: sD3sNW1JOGahpCftUgzJsw-1
X-Mimecast-MFC-AGG-ID: sD3sNW1JOGahpCftUgzJsw_1756734516
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8a2b9fcaso10274175e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 06:48:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756734516; x=1757339316;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hQXxZK+8L2C3hWSBdyN50IL5R99xW41D+fHSrVTbeg0=;
        b=AhOz7usXnL/uNeEbIPJxcZovv8YM4HHYBDd6eArOdQQ165l+cUZjx5OaYUnydqIVon
         4r8LD4Bp41BuJwTvhVFpDbUshcurMzGlZqaDaSKy/kkCzKUrY/vh7wfZAXOzofqbrjnl
         TCfXbT4J6bXrF+6Fewf3vxl2lIBlWR2xz6B1RZCeze4E/3o916ER6jolJ3p5ehlaH3pq
         RQsO6ZcAdmFHTW56ENPRTwq3jgaGOlmPhrtl/LryzLvxXFAVodZcCA+ElO4Yb100+xqG
         P1OEXVuhdHC6M9/i4C00Cr5IgnlI9nV0K1v2TJiG0vvlwzUJGOLBdyenY9PmxKbMxaxK
         JNeA==
X-Forwarded-Encrypted: i=1; AJvYcCXNy2FOJO3StI/ySlze/vQKIiVNtE0GIWM1crMaBS+IgrEZQL74lBDSwrRuzGQZ6iZ7yngnGaJuUw==@kvack.org
X-Gm-Message-State: AOJu0YwH58aHb6okY6+F9K3dmvaiRx97y6k479P3MWtv8+CX1juSGPkA
	396N58jnBtyHhl7BlEVr0tAeZxzHGD4AItDGtdDR9d57blOUBkMeIvtBZANG5Kbh1XfhAFbNze3
	px0gS7ifTlpU28faizRol+Y/G5mPXA9BFigvyygcQ9AvDd7yNvaQU
X-Gm-Gg: ASbGncsgGuxMGW/g+EOkrcR9W/wa3vHzf2H5AAIZIWV1Mycpv2Fls/8Un01h+ATrMSs
	L7w5fAgi18OcEmEPFTMUfPcryfW56/tXDGBnYdvywOHzPRWbg4IKm0JFfsHGJG5oAW6Z57++nhD
	N1gSHKs7dG5yiYXDqXUQXZ6/4SiifWyWeTii2pAfwcnPSCvnuwP+/T0ZraOd+HICoaojDj9ITiF
	CLwiU3EZ3hNBY1jytjj09BxnfbsmtLiR9dekHj5ppaLEb++thK7Ly7y+j60jOyEBg0v06ZlVKeX
	a224kD9ApxrOauIX1O9FvqRZ9eDMsOKlUkuZNIekDCZH/cVVH0bx/JsLfMj2i8wd3BfYv7xlCXA
	bknvWqRBAENk5067tCao22YLbIjUzSt2w9r0cJOMYjRyEAaKZ8IykkZE7p67VCcbdWDU=
X-Received: by 2002:a05:600c:a47:b0:450:cabd:b4a9 with SMTP id 5b1f17b1804b1-45b8557ca38mr56454995e9.29.1756734515763;
        Mon, 01 Sep 2025 06:48:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGYU18Ux39mAw301hmA+r2EuvPPz5FrRLj6WAhAzZ8e/RC+hpi0j03A/urkuaUOvkYNjzyqA==
X-Received: by 2002:a05:600c:a47:b0:450:cabd:b4a9 with SMTP id 5b1f17b1804b1-45b8557ca38mr56454805e9.29.1756734515309;
        Mon, 01 Sep 2025 06:48:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e898b99sm157339905e9.19.2025.09.01.06.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 06:48:34 -0700 (PDT)
Message-ID: <1eb1ee06-1fc1-472b-b111-e9c824310cf9@redhat.com>
Date: Mon, 1 Sep 2025 15:48:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/12] mm: constify shmem related test functions for
 improved const-correctness
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
 <20250901123028.3383461-2-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901123028.3383461-2-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: POp4lHigpRCVWj17hbo0lWZJlYlyZ_5WQE8WjxlYXag_1756734516
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1D0D40013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7ykyaa6qznhi5cg7qacyxcwemd4c1y7y
X-HE-Tag: 1756734518-694605
X-HE-Meta: U2FsdGVkX18EPHYJ/fNd3sqUxlUtrSKObpsWnF8aen3XXib1tTedXZxu1H70noQDGw851KavgJlE3i2dOEsSAnzs8NYQI3ilsEIu0fTbsKE/oIeGYG6TaMpbRGoZwG1Jb2HsKZzG5rwVeHZi7Y8x8O1eAh4Ws8fzQgKiaKynEJb//g9Jl/eqV5qHQhPg1W3Og8Ljt3L/GnBEyPMxevhAqHFcEsWBChM4eP/ftTrdzZjpeuC+BJNq+PYufGGMThYx/BHqIQlTJNskM/txFBqj5egt4cNtAMmklPKOPs27QqcYUkt5i3EAjd4Wyyno9CpIq8pIOUvbUrBFUX6lgiACUpzWO8JPoOE6wDGvox18FC/3SOtMZM+mGw+67ow+QD7VENs7vOOJYG7588yqc96Vj4zzYiKg7JMid8t6k5uNcKHoU6D8bhod9jCrwfOkN9QaIWyCq4wv/hrcmVAnAy4G4AxZ/V3acRyIAtae51DU+61BhvOr/f1VkLkQ4++h+6x/zRttpeBfv0nDTrOn5Z9tqzaepNcjUzosW2UAIYbzLI/7JYC0MzT5jS4ne2Mp6qMqd/7OStdmyRwd8LoGc3FDw9TYT3mrGebvd2y/miag5vIDy1bde0xudAz8xK+B2aCjTJcqRzwk42Lmb+aw1qy1vI41IDTHLxP2CTgRyRWZG+2ohT163WBgwelUm0iKtrEL6l10oV3fvWGBTbfz9HK/yJ+Y282hdN1q8xlFpgW7PE2KF01U5YCW/Aw9plR3YqHqQ0ZtHoe10BFf9EKnlTp2UFXMRFke2Ub1h9zLgWjkE65bt7BbeqMhB+eRo/Hn2tYqVB1QmWwg0hXT46wsMlILsgYQiOaUAf3m7dd5Vd2LbuKfkFeo5v/oGiWtnodfU5ixU8GjE2Ru1968CBkCKEgQ/m6Z/g1/AGj7s7ef5LxLg9U7L1zgRUM9v52+H3LOjL8tWoYVitzu2R20SremIJY
 wjKd2YtO
 TLGYaB82r4wLQy32vO0Zb4iwLWcVOeq6FAD97R9pkrfGFL2UPPlUzF9fkEBuHTJxAKPUwdqURcaFcgpmIIXurD63lCIz2Uw6LQDZMfkUbvDN6YQKbqfDtZzlkl6JzKb7QVHMd34V/DazTXgWKxHF73SGpErXUh1Uh+CXV47XH8gZ6kjO5QRFejGJwhj3c/jHg9CnyieVnTq1/Ikv3th5NLlodKYMqQWgKC7pZ4ml3ftbrMX3tjZGTPIZ7qLxh83u77uv/YDCLHdx3r9avCBB5SzwcERbU/EhgEWEyq8RekuZJ7MHxBsb7CJDiEI+Mx4CGkMKJQLBttwGrOTcLYxfODKLO/R3hV1XO8xfp6Df9I802xoKX1UT1p+OxYjJhAJGILfvLHVhAjDeDYeWglPR037uIm4ZwSq/IF1J5hquMU7mKvQK3uIm+9+vDv26m6sbSAldpcPkEypxjh6b1HHUXu1VYZ/44snwvC/28KIfJToGZLnP6qGqGmyqcWxC8bA/5i/qJqEFmi/z2r8BH5vs4eQkoA+9vt+i7HGDSBN3cdonluT7GJzQGkAr71nuDR361fUHqUPP8h+XOCElgoMdJa2TYGu3X28hyK03Aov8pcwoXcwZ9bw0Qk8tovGzIYR57zc3us9vOQs6aFQFmZvsHtRFV2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 14:30, Max Kellermann wrote:
> We select certain test functions which either invoke each other,
> functions that are already const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


