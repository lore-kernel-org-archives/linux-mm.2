Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739C1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED668E001A; Mon, 20 Oct 2025 09:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4F08E0002; Mon, 20 Oct 2025 09:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDAAD8E001A; Mon, 20 Oct 2025 09:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD4B98E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:39:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AA96C01A9
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:39:50 +0000 (UTC)
X-FDA: 84018600540.08.1DC491D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 071DD160011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:39:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QODdlZA4;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760967588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKZcA1F6orFvmN6jkpU8+pRILDVS2Ry+Ciuw5aXRh6Q=;
	b=bXI+dXv6atODZbrOmTgFr694O3oLjVLlo+rh6hXpnifNktOcVbH7HTMdBXs/vZp0xI/5qp
	WzCc61kb4WOJ4XXX3stiR4zkSeOzaGKdjuJjkxBPGVK2eMepsh5Zz/0LV3F+obm9wNRKpN
	t6LYspHeb+gEzDFKdc/ikUprfhkNO24=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QODdlZA4;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760967588; a=rsa-sha256;
	cv=none;
	b=ReYNb4IqorTXgAwAkwoLWvvZiwX0b88EYe8Dw7dQmP6ti21bXtuGFFpnyEFGYF+bfhDhoO
	GyEhAUOFtbkRzeq22Q7A3xfPBGi7oBo06BhDin9y7+wuwBN8FAZ7R5AjHEweivvcvW2gP9
	qm2Az8czbVV9cCWlJtBKlAB+okNvhmM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760967587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SKZcA1F6orFvmN6jkpU8+pRILDVS2Ry+Ciuw5aXRh6Q=;
	b=QODdlZA44qa2IXtLTZEER7I3KeVKlsVNf8oeZ/hcmGqLQc2Os9CtVRXU5QBKpsgpeyV4i0
	2uK5ie01ZLiNuZwUlKTbYHEea67KooKuODXJSQXU7ynUqNeTiPxSzlqWJgwOu2Ygh4r8w3
	1af0TSAEJwh/IIOF8/CN/WTzR18Y3X4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-Qd4ty-iJPOyy9ZzKb9UTjQ-1; Mon, 20 Oct 2025 09:39:46 -0400
X-MC-Unique: Qd4ty-iJPOyy9ZzKb9UTjQ-1
X-Mimecast-MFC-AGG-ID: Qd4ty-iJPOyy9ZzKb9UTjQ_1760967585
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47114d373d5so44727115e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760967585; x=1761572385;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SKZcA1F6orFvmN6jkpU8+pRILDVS2Ry+Ciuw5aXRh6Q=;
        b=Lz4JImIMPOuzun6hqTyIX6n1LBSJyjEJB279Ixf6+zTZ+5aRH09VO9O5925lC97Qkh
         xTnYoNWvTsR6i1rbBRRQcL714ZaMcQXXtqQ9pYgfPzP/CcLgP5NLVeXfBrV6FRA2iuFu
         FuMr7xgTxD5EkyW1NXzvB5w0DGpCdDFXAA4IRg5cXTNT5n5I3SYBuHkQLTyd23yFhELe
         /sD8IqfzHdMUmSmQbeHWscKJNvWYyiQI3+jUUEqhVNJxwFGYJqVb6mjFOAFjet4HVvDn
         zpWc2ncsloUrNS5lnTOvsCNQRpnPJxAXZWA742ivb9GkYXpc9gfkMn1P4WH2lqwwfIyk
         sB8Q==
X-Gm-Message-State: AOJu0YxH859dlixWI3NhdYqpZ6dGElO3o0AuFjRZN5r2H6NYLwZ1g3Ph
	BEPsj5OStWrXsCrfV7oSauPfpCFvUSBiOiGKEszbdZ+lagAuIGwuS8G3eqrgWU7311hidmPGYuN
	J8I9/DyOGFKKFBMHMYLXHqzgiNu4hmD+RpobSb1VK3HoQMHhgKgrv
X-Gm-Gg: ASbGnctQrIHWNU1STPAYZ+dm+AEBZoFDwkoiQtPn7l5GMLiG+Pmnxn3eEkbrPxZcbet
	+B8fONHArHCDTVGwogpGxbpx7ToIpP9ZWxNOeB6RtMX36IvG/N2NU2D8VP8IU2H2JJyAJIYkfAE
	QVFewikNBbIQhRgC8yBVfxyEhXyukChrTXyGwpj1R7e3snW4P7eNXDC2PXP2RUpMVm3o/ROCGay
	RyEoj6I6jeRx6sOJHDhlkDLuoz6W12RRLlrk3MbgYui8+MeCzL5vVmDe+K0fsUm7fJtI3fo058K
	s99gVkc+pHkTHai1Ncpbpf8TUHWc9t0+I0U/THUgjz7MUd+WpmIql3gQi3dSaB5UOr44s7uftsa
	nWT3NO2VEvgfVHnUdBk4ii0VKHLZWmX3TGfAVFxD3h2/wrtsyXxSVcWdWzzuZlHtmqLFwyurIBm
	2v5P3dZtSszgwuNT4SsLWBmhTnCO0=
X-Received: by 2002:a05:600c:3e8f:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-471178b123fmr99039885e9.16.1760967584790;
        Mon, 20 Oct 2025 06:39:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZp5bPuCsSg39x0tmPSC5bDxUwYrm+0x5vXVmx3BpT9aB5bP/KLEJ7tI2xp3A9mk0iaJ0zVQ==
X-Received: by 2002:a05:600c:3e8f:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-471178b123fmr99039705e9.16.1760967584434;
        Mon, 20 Oct 2025 06:39:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c831asm224123445e9.13.2025.10.20.06.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:39:43 -0700 (PDT)
Message-ID: <a84bfe66-2713-487f-8ffa-8449385511b1@redhat.com>
Date: Mon, 20 Oct 2025 15:39:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of
 asm/pgalloc.h
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-3-harry.yoo@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251019072509.9488-3-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qWKpgizSF2IjmaPMmj-PsUUtOr31I1eXDKc_vUmqnIY_1760967585
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6dwn9i68q8roskph1x1wqyqn5npgft1x
X-Rspamd-Queue-Id: 071DD160011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760967587-940152
X-HE-Meta: U2FsdGVkX1/ovkFk1xMeRbYWJ78am5KtngvgakKRjEjnHRciZOfq5CitWtypOtBkxWrrCO8sUwwSHIodWNnJ4o7dVARqeVmmDfx5xY9H/ALmM2rctD/SKwne7Of+wVwtHbtdJtzG/ZGy7Z5aX5jbMAthIW0IrETIjGHf7TUmMPdYC9Un0kXsTp4UnGdIBKG3+/xKJMxoRDfqrXNh6lVtJFQPOWoHtU0hQ+Zz4DzLjjFlRRZeKeR94kdUdpUO9CvhIVuaGX90aj1YfHswmcuXD5MKJz0kk1iIJzxlxyRrrqAvDEOkyXlLo1bHocyv6P5L7JyjE9BkvJVktvZlQOp7KPKHC9tbhEyojUBqV3vxU0LqLQc2TkybvNJfwFUVDjgVaRw1SBHHWJmuHwRAbCZHJQnsruqUuYuLfIwL+aB4w5trln0+OvEEen8rIuC7P4EIw779qtiCgI4tyjH9rF7lJv49NX09M5FEMv18ePQw65vI2tNNgHB19tqy/B329bt0VW7RAq5V24AS74cH16f5p7eDN1d3Z9suvgSkOy5beRcw8adra9Ag67a8cd9MiSiz/gjEHPh9lThIGljdeBaL4cIDgFo+dNvcV6h9C6qwQCUwaIPgxFLTbdKivzO4cWJCrRLhf0ISLcDh1RnJgn92VvHui88jaDCrQqzzZcHLQ9qhlQamnOab7iuy+uEqf/yvoDCpwspti/bYpG8SdYgM1v46qN7hfYEhQ7UhusLmlgKo7zno4JVJd+mXoQZrhLsDhujXopnaGFDXNc9EHSGDarUzuwHID1ZwdyKd+8nOQMSqLs/tLF0aJ0LLVl39uU61xhPYhXb/M0dGPfA/rAcCt/BzjfZS2B1ca2DXbUhG2FCZnPv0n/bK/URhVfWol5iEdzUOYAvCaA1AzDLgIEfBGeYW4+4jbgX8pTZ4di4LU4yCrNf63+zTQNrYWi9K+eZlyiox3fB1wb/dmQgOxYT
 /DGIq4fq
 4ezAOxc1GkJ3OgreO/dtBgtElAksBl8LwHeAc1Uknq4ivHd9IM2zJ/GDdXXIIJxmxxi7TRIT/EENGos9UvDJGOpDmw/LKCro4lq2nMf5CSK8x6cEQbeTxr/jSHrWtoesP+bm48nX6Xb8e3EcYl6Sfx0xpVzVVTFkfUNDy8A6H9x3mOETAdRasAhEqp8lUQhg0KD+nB+VN1BCwd5RwhDBIFFOzo+uZtt6WSspydF36v4W/SqVj9t1EMHnRjJpfjg0wvm2gSbg7Gm3yopFV6a21t/+ickcjeoLhRAw4VRhq9A1TKQ5s1+QkT67UPMc4dgQZK9rHT4M2++aTa6LwrcypLBv9wk7m5EfxDj0tRkRouPm9jv3tRe1plB/j+CS2zvegTAMqZEP7YjdX+TwLNdDv3jxiZYhMnrQ+jVKNr0uXnUz03po6U1QFqjYCUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.10.25 09:25, Harry Yoo wrote:
> For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
> is technically fine unless the .c file calls p*d_populate_kernel()
> helper functions.
> 
> But it is a better practice to always include <linux/pgalloc.h>.
> Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---


Acked-by: David Hildenbrand <david@redhat.com>


-- 
Cheers

David / dhildenb


