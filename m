Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF86CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5708E0017; Mon, 18 Aug 2025 02:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9D378E0013; Mon, 18 Aug 2025 02:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8BCC8E0017; Mon, 18 Aug 2025 02:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B66718E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:59:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 410F3BB5F7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:59:08 +0000 (UTC)
X-FDA: 83788976376.12.301827F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D890218000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:59:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LRCUF7pX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755500346; a=rsa-sha256;
	cv=none;
	b=jrRZvyd0rJr20VWoc1fDJmEwtNL6qxA285we6pmqOuN2nMvO6AKEsOhh7iiN3TRBXiCQ+6
	PZ2ysv8pUhRPK4QkCs+3RYB8WrVQ7fk8cxox4eHow0UBlj1MpQdGTwPUKt3eSIiQS4o1z5
	WTCF04DfagLKnuNHDeooF3XBDqniKC8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LRCUF7pX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755500346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPhHppo9Id9H3Mf+xNXwTczb/fY9tmDFofhTHWpEmEI=;
	b=JtU/+/nOcvt2ggCmtKkWOb1hOVwedywRlNfmQqZ31qxFQbjID6oS9m1ZjZg1BcryqwTXFM
	dPcvyUvh4EQ/et8+wQwpvweS7ymV1IgagPUrTgWEvUh04C6qFE6s7w4EpbdVe1HTPlsBHS
	Y1Izw4/TjPY8Oyb99iuSgeWB1Fy7G0Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755500345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tPhHppo9Id9H3Mf+xNXwTczb/fY9tmDFofhTHWpEmEI=;
	b=LRCUF7pX9oBGT+Cbdyw6S2hNEICrsJlS8hwR5s5YYZ74GAxy4RFnQKydbSdiY3H9yw6/b0
	a2uwfFlJMYtCwAYmzbiETxJj8DJqwlJGcNnrpLuA88N4rqLaZ0vh/H1yPWBJhtbgH4978U
	1XJGmP90jSJ2jejobUQLd64276p8md8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-lp1R0YdbOsyLtgT1UZ7Yvg-1; Mon, 18 Aug 2025 02:59:04 -0400
X-MC-Unique: lp1R0YdbOsyLtgT1UZ7Yvg-1
X-Mimecast-MFC-AGG-ID: lp1R0YdbOsyLtgT1UZ7Yvg_1755500343
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so19676705e9.3
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 23:59:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755500342; x=1756105142;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tPhHppo9Id9H3Mf+xNXwTczb/fY9tmDFofhTHWpEmEI=;
        b=lodXGRAw8rLPRQKdeC6WK0HrfL0U0ENOWXfsi/79kwLIKJSReGFqEAGoUHRtNdkKFT
         vV0oQ52R+StZc+zeybBzE3B6SzfOQI2OzOKXIp1JOCdfDNNbIgga3/bP8QxDkkDlrqKb
         ugBtREG3DjtkdrjAnA9rXK3uXWwGN8nJ59oUkkMknFA9yv7vYRLfW1G4YvcjXNCfzQh+
         6t0XfKsBCU3Qiy3T7Lirr9eAm+D+8Ro8ALMM8vI/gqjSY0UODoTM1Snqw7uQyIUZcCf3
         jZ7gRcMdpWXGg88lVoZcUfEpMiUgcUStzWgRdAhc96goWqJNbgCcWZwwq0DWjuDBqmtP
         eoHA==
X-Forwarded-Encrypted: i=1; AJvYcCX0h1o/yGBA7wc+dgTWKvno5fx/IcuHukgGsiFroeHBGp7pbeBy3ip0clYZdA153JfoFVETE6pmwQ==@kvack.org
X-Gm-Message-State: AOJu0Yw/j05fCzO36UyV4+EuaopuhGJxwh+oX20iOlAnqiWAe1cxzXSy
	cltJHXzBV6Mv3MDyP4/lcNLb+qVBjzKpsyfTtfz0CIklq4vcanDlyVs0J8MhQHZuiFjSsHyLoS2
	N2o0peraMph2EnMD0z+7SbMOAaLeTAgpEqHtKey9k8sBsejqnOoPx
X-Gm-Gg: ASbGncu63AOrp67G5NbAry0cTFln6lk0ogqD5R/x0HPh/fROHEtul05arP1gVp3oGW2
	3Lb1NtzSfVYDdCJ9jom7Vu9Ipbxdv6snBvF0OxtHIxy59W1FBojNKvyiZ0lrpeK406jQpFodNxS
	snuAK8cD9HSIsGg4MsyWOcQj53YhcUMH2/Tgte7iIFhSh/ZyepwyobhoQs/6VC33iAdmd+5bRjl
	NhYH5vdZ8pIn4t5lBFKxgmVrlpDrSHZ0/n1apqzxHpel2gI2xsTDhy/keegkn83je8gwjC9a9Nv
	76WpAGb5/xdd7lq6lv2hKq75L8mxnDBL+74rGTr6/5MWjaFEVIpshnztKUQTRZ+/ZJR/EiOtt8F
	gyaqoq8Gs6Qm9YZr7tvz/G1/txnRLZdQN+EbyRN4TIFRB5/Y30XhsdTG+uULo6JJa
X-Received: by 2002:a05:600c:3b0e:b0:458:aed1:f82c with SMTP id 5b1f17b1804b1-45a21844ae1mr69168805e9.22.1755500342384;
        Sun, 17 Aug 2025 23:59:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRjJq0XIQ1oLnzV4tapEXxp+CDryL3RteLWPsUBJ810j9eh5EZSzNq0LPGyZErkVrGEekgEg==
X-Received: by 2002:a05:600c:3b0e:b0:458:aed1:f82c with SMTP id 5b1f17b1804b1-45a21844ae1mr69168235e9.22.1755500341938;
        Sun, 17 Aug 2025 23:59:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9a72sm11554512f8f.34.2025.08.17.23.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Aug 2025 23:59:01 -0700 (PDT)
Message-ID: <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
Date: Mon, 18 Aug 2025 08:58:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to
 memory_get_phys_to_nid
To: pratyush.brahma@oss.qualcomm.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Danilo Krummrich <dakr@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Pankaj Gupta
 <pankaj.gupta.linux@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mpeNDgxrlGTg7jS5RpVxqQ0-ccYa4Z3ADaLFWdKnx94_1755500343
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D890218000B
X-Stat-Signature: too3z1kqa9mdcmycnthmo4h61qaui58y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755500345-218622
X-HE-Meta: U2FsdGVkX19NZALymb6l/F6txu5Pn+0ii9Y4ZpKQ6NY21nZrJpJ326ydNGO5ZfzFnz6VbdnFcpOckQMvYlhNYDY9K2tTnSYIHCbItCyK5EWIW9N2oa1VrGO7P/gBiTSqvZNfrkp7xfupRfyo+sVeR5Bs+1Qp4tfNi5ulr1nUNRBxba9Hw7WHowZm8oiYgW55WHyz93mV+b+OTQ4jJMaPqR9KC8hrBZXtT/dNKjRMKKhR+jJiHDoLWeqHNHjGYw2sc8KPgRZZn8yuRVvmkkvMV5XgHvQk8SMLVjNPdWMURvTDqbxyl6/LV2jYovBGNlPcxDi0Fh2bgwZEr9OX4H/qYM1z6y6G2e72XwB3Usx0w/FX916W9pfxEsKZ6nyjscy0oH8uwdpURW8SNxOhYXoXVMQzJg7VwGwPz3rdQC++K5Q9aVSXekKlVycEx6eZMDj1Rm5FEpyDrF+jTy1UNlAXBj/xbkiZRipSESrFnCtceMD+ogqHUskyomwth8b8rHN14DLVIEZxrNuCtBYQ///ar9osznsrUk99VZtrxEJneDfX5BihpyWpnrMkwJ8ub8gSLdAmto/yfposWIWAuxKqBHLB9+PXE1TmhUarkY2cngYv21NbxUTpZBKUD1SF3yB6LqO1rzKXYlqTQqDuhZ+6jaYnjsy3ORS/V6RUzNgogHBdxdbZUXrYq6U3Cc3eUT3vBkv4FwXpsUqnsSUv3T/rTwz2ue5J1HhjER0Rj8EpCdvp0XIZhWi9ockkSuCh/P1a1n9vu6LY9XUl0leYuaX5SfB2A5MJj9oDEiroWxoBIA9CvMr19GQOBU0b/RPYnP7g5JWoRJsPShGaPIjzAU5Oix7sRHePf9mhwjTbgPK27OVgTOZSDr8tKLFqhf/Lzq4rF1TCvPgHyNju2LQrrjyIfj3MsTE7PywNyIPuAzhdvY+Gqw19BMeSJ1MoBi10/kdlvAD7Vgi/KCLi9MlNmCR
 fjt4hYsu
 6l29d1iZQ+QiXuZwF2HBh0xByTJig9Kq9PdCR2juTixZclk89vvDFZuNDRUXpQXq3eTebqTiUknSqDyw5ODL6qF9cYu0BsKUhO9M3OyjOD9+V7ZuEn22wpyAm/JZVFDJolSp0J+mHjejofBbKQF2XminazdidYFRW6eKMCQEl8FLB4HeS/F5BN3NpOynqPMHV9LYIVGlc8K7Z/w0gGDuwcAjtB7BsVKs9rHl38iPWfJ8ErewM58qXEHtlIwcgMnHFrTyes9UEm5yZ8gQpfA9+PVurMRwDpd1+pcBzVL87HmiudpgOucik4TE5fPwEPJmh4QuEjgQkhAk5FSxhSPqEBACRIbASSPSmLOQIGx8TKLIpabJpNjMdtSmzKJajiLnoDRXQY4d8FuHMLTOzZ5bUvVbk47CDlMVId7UyIbZpUkSFzgSRZZLGpKjZWbBtD9iy28/W+59ppVUJ3mYqToYZQcroBtSchalURrYY+5Z2LU5aDCfnZlOWXh+R+xnR4oKLALBx7dkx65UUY99AJam4TX8OWibfQhIjsWNSz3iYet3HmibwDCCWTRotcR8tK+xPwK6k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 
> The function `memory_add_physaddr_to_nid` seems a misnomer.
> It does not to "add" a physical address to a NID mapping,
> but rather it gets the NID associated with a given physical address.

You probably misunderstood what the function is used for: memory hotplug 
aka "memory_add".

This patch is making matters worse by stripping that detail, unfortunately.


-- 
Cheers

David / dhildenb


