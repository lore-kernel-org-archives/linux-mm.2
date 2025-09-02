Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243D3CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797858E0016; Tue,  2 Sep 2025 04:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 747B68E0015; Tue,  2 Sep 2025 04:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FA18E0016; Tue,  2 Sep 2025 04:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2E38E0015
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:15:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CC45BD81C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:09 +0000 (UTC)
X-FDA: 83843577258.15.C0A94D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id C9D4AC0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cysvr0t0;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljgQE6xPMjgEsLMyx80S8frJUxwb6xjySanoEF8fZEk=;
	b=Qp0ecY+ETJXzRpHglw+Vt2nna12hiqQw3xNJL/onfDM1QljC2LsdJ7FQpjsihEDnC1xSpY
	lR6TewAChUO0KsTsA04RDKADrE+3LXUfPgF2wpUoof+Oy1G+5Eacb75Pp1a54rVemynBT3
	fj4Ajejf1/8uERWDkuqsjQZtfhVF9/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756800366; a=rsa-sha256;
	cv=none;
	b=hl3yeco1VT2ljpZrCIU6DhK5RXOXmjITiAvmVjw6N4l0sXy9ojxYQVIo2CLeECM1oo8YM7
	/yCfKqHoRan/0WqeZVm81hbv8AxZpo122ie1yrmFXOnEntTm+AwYo8wzM+OmJwjoMHg4TP
	2MzK6p0ICmTqIKyDF4Ur4eOagE6H4Mo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cysvr0t0;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756800366;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ljgQE6xPMjgEsLMyx80S8frJUxwb6xjySanoEF8fZEk=;
	b=cysvr0t0ntukPbnFpT8GZg6mQzzws3cEKvz3bAnmEqYj3trpab9oHeaTJL2Dvkd9+BVeUA
	ipnF7vfBQ5ZaR29g618dbHumbw9mnNcKqNChEK/eDjr98cY8up1rRZbbncGFw4zO7XMjas
	Cn8CPGBatfApygb5W6iUv+ooIBQ3UpU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-cvAzGcVON7qR_vtoDYNykg-1; Tue, 02 Sep 2025 04:06:03 -0400
X-MC-Unique: cvAzGcVON7qR_vtoDYNykg-1
X-Mimecast-MFC-AGG-ID: cvAzGcVON7qR_vtoDYNykg_1756800362
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so10309135e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:06:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756800362; x=1757405162;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljgQE6xPMjgEsLMyx80S8frJUxwb6xjySanoEF8fZEk=;
        b=LvAEb1wWCkkZ176xLXul9z6wVcmbGk1wlpb7VLMJnBdgiz0pjhO4mTnldojH5aRloZ
         xqirr9PFfiNTDvKuSHTuwOOu9PVXjIzKDnyC2cFANVchvgYAqGIj76tYM9UY2cGUErDr
         LPL1wWK0tgBkZymLtWXN0ax1oFToMtiYLsh668ym4tmCsmcUpaAc4RlzGrOtva4kX+fF
         oTosw1vb0XJFQtMShDAjHGA4hb5scbUsSGvJ72YRiV9BglvkqqlrhH4iYDNMq/X3nrks
         hkp/zUDZnQy4ngGk7gVljgEfyMqysprOlNRUXYsbSrKL6X2X24cmVLPebdk9f69JrRCp
         PhCw==
X-Forwarded-Encrypted: i=1; AJvYcCWezn7C/NofacbNB3wO13CS2dq1vUFO/GFRiYlCrD8tnPzg4FE1WiDJr6EzZPSTD9Px00xkXO26Yg==@kvack.org
X-Gm-Message-State: AOJu0YyvlcZSVSzMMvtxCS2Xu9fFvLA3WyG9i91qdfUvgQfM5MFss1qT
	Wz2NVZNL5Nq1q54dUjWrBdETSQ7X/YOVYwKxjZ+WDY0naOWo12dDE4fQguNMFUwB3xoMgfE8FGT
	iuFP1oWMuWVXIKYl8wZGz+r9BpWzYaYRZM70fA2wJvCbX4YDKPrRq
X-Gm-Gg: ASbGncsStqkWj9QOPyjfU9GTiGuMVg0coiOdwuR+6oQP7btjeeVhSDUp+8nfjRHyfYF
	sp1FeEXdCNIdWAGyXJ5VXm8dF1Zh1vuVaztLDrwTwvYcEmDxfUQBoEv7AfCaVkQb9IreHnFPdDR
	hFVDQ7LEYY+WuXjDLxDY+5cw0NdvjzgeSnXyYnoke8rU8lavPSgbP6KpHZzpYfhrBnXnBwnCMP5
	8SHUSBjMG44/Eoi6XsuIKQQJYzjCQ/bEJ8QkGo/rGAgHJihthifxOHEANql5Yu3bHQ3/hYeYjsX
	KzUp/EnthJvrYKVbvDMMUKfU6Qx/CZP5KSTXKC0DpRehuJqYNVSv8Xxp5Yf8o0v7f+oridX35L0
	1ych5KnVfLE/uQF0UlP6/TWC7YzyxLCtykJ577x0TTS/orLcWwEdYM6NH+/H5I0y18H8=
X-Received: by 2002:a05:6000:2301:b0:3ca:ad45:6362 with SMTP id ffacd0b85a97d-3d1dfcfb6e9mr7271289f8f.41.1756800362326;
        Tue, 02 Sep 2025 01:06:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE89e2rQnCWFQJx3mBpIBce4Sf0ynyHLTGKH2yytotONMMUzyt2emLxtRzyXBmVv6z/AWM1KQ==
X-Received: by 2002:a05:6000:2301:b0:3ca:ad45:6362 with SMTP id ffacd0b85a97d-3d1dfcfb6e9mr7271226f8f.41.1756800361810;
        Tue, 02 Sep 2025 01:06:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d2250115fdsm13170209f8f.40.2025.09.02.01.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 01:06:01 -0700 (PDT)
Message-ID: <ff2875c5-93f7-4fbc-92e6-ce4c607ce240@redhat.com>
Date: Tue, 2 Sep 2025 10:05:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/12] mm: constify various inline functions for
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
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
 <20250901205021.3573313-11-max.kellermann@ionos.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250901205021.3573313-11-max.kellermann@ionos.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 49xEQBsj4C6vp3RIN3koJoUBpnO1foGeDF0xAfvWpec_1756800362
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9D4AC0002
X-Stat-Signature: e5h9n8z3a5ji1ffxei1kjbkjbr7gxej3
X-Rspam-User: 
X-HE-Tag: 1756800366-112715
X-HE-Meta: U2FsdGVkX18Y/tuzFlbgArAnb4KzmmBBhXVMqW/t2XBJKnmQJRdwRWtmrgQMO3/5qzx0PkhMKoMtzenuQgNGgzvY+invbMnrUiP+nJ8fVDLxvnEJ9gTayFXSkOldMkSah+HJEDeAT3D313A4pPeSFCLy2NZZ9dn/u3MJ1kBp320HzrWpvF139SxuC6d7TS+lFJryepOCyijeDp2Lst+1HkfBIyBWWQ0VQ4eBqVK6XOULnmCtRZcKYWi2YZNWzvb85CFIXH+Fg/ndpYp8ZyATW/bSzX7tBcaDpb30yBXIKAA12MJfWltJJ1WjTcbfjWoxSzTFfFEpGo5kNbIl0DjcJ0cCQJ9mQ+RlS4gp0PrwpMRtzLPtcOxFT0AzVt82M/gp4GnFLobYEa0xZ+/e2pKncbdCvPRBJekS0uE7XzZpz+RDcSEaf0OfYDjkQ03LeqeqLONTP60wn/AmtrCxlS4dCmzzVQUvwzmVuckY0IeSspFzC8zq3eSb/5NycBPkxE/rjef+72qNd3G68rWD9uF8yPvuINoqxpHUtti/ACarDePemEc5/+0mfaDRQJXUaGqTyItd/OmId4WIm+zf88M+FMmWZ8H0FFWgzGJy9O222ImA36OArXwjV1VGhPHeM6g+rOJ7K3iyM2NqO7Prsr4c+nag0D5QgigXBX35DehOJR9nh+aNb4IZkfL9AcAolz4B/ce1pcb2/QblH2jpFQ4sSpF8aImv8pfXK4Uu/Gew4wvSjsswXKuzx5qxukrSuftpEx7YTzocR57gvtKn64va/skhg4OIvFIqgzniKQZO5Yf3bjmk3EQ/WvMHOIGFHP7wKdLrhtNaDn7V/ulbYftYvdr9I90C62d8B1n7codyCRH2XlSVicp59tUjqcHg50Izx5eXFGjU8gaGZYgYVGmSClsXM7z/3jPQAbdb7WUSjKzESR7NvjgMVXDNorek7gfBNUN8Y9SpePkKg1dBsKE
 NAzqw4oV
 PdHb7JbxRM3PuLrSEHfWW109yYlWaZDFjNh+o+YZ70DBNXYiwk5Z/+bRjwpy+gRV9526SHfcjMTl6MZ+CydMy9X4GeVHyIAnNojlQZbG2mbaHPp9tRLEmvTUU1RbYjwS2FrwDspstfM1BacrxUH7c+YML/lA8U1zd9D7B3zVDneAHmEvdWYfUxIxA+m9ZvewMqZDVwG9q23JTPjOChDiKMznUU2Gis8vPj73wV4d4tQLHYjlr9oxOH3cIH1fAv5qqrr6qhETtm4zRkZCRuZzOViS2G2fe6vqkRFR2KY/1pHCNklYYnn2GcAuD+Gu5pwXU6Q+QGBhpNSYdyNA6YKobu8YTnV76EFEUrwJWxUoaZb8yEtd5wSDUCVXfe1HKm5/Q6JCCnvuH1hh7PgjrvGHScPDGmvndqxhy4tH+wZrQkpOrElTnWlw0UnVCC7UMqjNNNKhNKR2eCLQcEpDozP9axTYupyEbpZ6OwuK/R8rhvpyJas7lq4Qjj5kts0b+zj4L60OmEBUvRE+cNjeuggwEHWYCZtU+Mi6Jp6RaZSoNyUKKkw+yWS8B0DyFdDyQ2LdopYFY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 22:50, Max Kellermann wrote:
> We select certain test functions plus folio_migrate_refs() from
> mm_inline.h which either invoke each other, functions that are already
> const-ified, or no further functions.
> 
> It is therefore relatively trivial to const-ify them, which
> provides a basis for further const-ification further up the call
> stack.
> 
> One exception is the function folio_migrate_refs() which does write to
> the "new" folio pointer; there, only the "old" folio pointer is being
> constified; only its "flags" field is read, but nothing written.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


