Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A12D606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=P79H4vu8
Received: by kanga.kvack.org (Postfix)
	id 6CFBB6B082B; Tue, 27 Oct 2026 12:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A73E6B082D; Tue, 27 Oct 2026 12:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCFD6B082E; Tue, 27 Oct 2026 12:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24D426B082B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:21:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 695B480A6D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:21:16 +0000 (UTC)
X-FDA: 85368920952.02.93EDAC7
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7BCA718000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:21:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P79H4vu8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
	b=F1O31WI+wmlrWAN8FLLS5+mpFprZgTU+dkoxRB85zEnZkzsNBO8FwpELJ/tWtjWWy+yaD6
	rr3G8Zy5W1YUakc8Ft2S6LmoLKKzFHfzG+KbvZ/TmTB+PAGQbLmQIEqQD4sOsWbl21iWis
	kecIVcvkEXNlUepWuvt+Z36+WmBji9A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P79H4vu8;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118074;
	b=654FjEyb98+ZQF8B1ccGlfFZUtBKiZeWeTsTzuHX0e1tqQ4v0HB4EG6EwFW3O0FtKRrR8z
	A3CaBLBQ0u+KXfzXm0y7bMqzqTpkvWl57mURTrQ5qIfURrinMp+K7wDVeeazqKdlTS0Eak
	or3BVKNVKkJ/AtZ0ILj+P99A6MRvsUA=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eac3b6b2ceso25014e0c.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793118073; x=1793722873; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
        b=P79H4vu81pcnMd2NFXPwBT7kVogzDKy0Pqlakj468L/wSxxRX755g+Jz/TW9hjRog4
         FAdazWsGZ/R7xfP9CiaB6t/z0iczYHvobIU0l9XB2E8OEjkxfuwVjnEy1Di+HwdVD5RH
         DBu0UFK9efCWEBlhu4zav4cXqK/swbHkI3W+WUE5/srKFAYHBK6yvNudn2Nip2Zj51YA
         vPHNdYlx23IuNlQdwknLSvEU2/t2OW3ImGqJnv7WUEBd9sDr6YXEHaNes+YXiySxloqn
         T4e/iRzY9Gh49wOsxc7EVfcqmjlQu3OoXDSQ/cIOxEGVquK24VCMjINYa0vonDteVsjt
         WP1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793118073; x=1793722873;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PxRb990Xj/uwND6b4fXh9A/3T5i+xI2zB08D/68nqZA=;
        b=qi3qUl2/S04gaNhAQ+8Zpi6xslkMhwt16QprKcDTgdLJpioHWBUKDhHiUy1/qYxEFK
         3VoDj6GFXRGKdKlS5DrJcMqKTrQ+S7BkWMH2pjMQlzQip6pvDREyyvfRi73Re6U4TrF1
         nXahZPXYHyK66myPSMrc6uBr4a/12N7YKE0jCVbNhevk++lz4A0zqUBNEJRuOB66yCRK
         zu9EJpoZpK58XIrthh15zcrpFsyutNjv24Ih5vJP3K9sxmSrlrhgeH4KH8XDbPLySUit
         MrXEao3SNr+M8EM8HWdzlT3JzouQMq12F6CVI/OYo21+3dxdavnZ56lTBt8ALiDrQ4b/
         Fo3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxhw5Kpz5Pmovshxdv6gRI3i0VqHMX2Dfy3mU4ed4G0g3qPXyQZCmrVapBoKbzGLagDlJbc/J/rTA==@kvack.org
X-Gm-Message-State: AFq9FYLaZfo0IE1BqCEgaP10XCPeaHJBiMTTr0ah/fAd4OsbVK87FvC0
	KPwJiJi5LZOzLFKzTTGDQuRL2Yd93Jjx0OgD2nZyNA8nEap5q1LngnIKJnBbzKjF95M=
X-Gm-Gg: AYBFou0LdoY9HmU+rM3YnuYoALoIfP6oVKi5woeFQMMKJVBmQ0LRVein79ZrFh3tXBG
	6SYYsQHbGQ8qdsoeCbUgWd7ilwDGp3y/z/LFht9j8/VLm6G4YZ4zPumwcXfvSAHeEjaWbLM9opJ
	n116/+fykRzJOe3cCtzSmBydoMetBf7voB8XR7GsdkRWPWlPPyZnoNoc9lNhSw+z7O0I/FetKNE
	BpucFBfIv/o14ifqtyZuFCOOt3KAWVOYt8G1mA22IXQuNuNKbJuOi+oe7jc8Vb2nMNeip9DxG3s
	A0SSgadbBy04RyxjMlJYAVrAL5ZWzuq87VlIiGiIaDOE2lPJFIOjqxL8zLUFde7A50pekM8mzrH
	RhoHWWGuRm0IzZjTI/KM0Z21kKImFAfwvWsXkG2UhHzD6X843N/gFpb7WL10yxeC4ZeFIQPD4ZQ
	UnA0c+x7KT+Kqq95ZiZ5MunIr38x5/i2QVqvwhEfe4xvxFETGnaM6h1cKoD7MpO0huBs2r/dkXg
	SOES2Ypbw655TG+hrGk2tBSrhhe6E4JHcyT/l89Bo37tVz/mbISMt28ZSwtxU67x01je2ug6A26
	gNpTE7v/FBCcMJWV4UMjRDaItmennGUaGVaXYmFinU/PyqZ0z0rv6Lf7yBiQQ8/Fpfwsw8deqxd
	A+5wMA9S40wiqG7UBa2VQy2jgGXIb8g==
X-Received: by 2002:a05:6122:1352:b0:5c9:c60e:3a40 with SMTP id 71dfb90a1353d-5ec232e48ecmr4515149e0c.18.1793118073126;
        Tue, 27 Oct 2026 09:21:13 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4a5f26c7sm304662e0c.9.2026.10.27.09.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 09:21:12 -0700 (PDT)
Date: Tue, 27 Oct 2026 12:21:11 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com,
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auDPd6tjzACQVszf@google.com>
References: <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at-8vkVpN2SF3XgB@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7BCA718000C
X-Stat-Signature: 33t43mr3ywgax5sr6m4i9pi9uuauwsiw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793118074-255973
X-HE-Meta: U2FsdGVkX185vnJ7BpDd/dljeLE3fsip2/ijHG/rUMIqwpXjR6yW2SfmjSDp/ki2Gux/e3fNXEurx3IDdZbO26DRdHKr64bFRvQqa/3TnJnOdlfr4u35gl326ywztAW0IE0n3Tl3Kzt4Bn72tZcrQqMUPG34JUTBkVLUQhyYbWr6FWgbzHu0DMEA4tqeaaDkWmbaZ2aJBD9BKdHIiZdvZ1ZVA0rS32wVAOtz5x5hqb+vXB2vay0IArk/BkH20NVQSg/wlvAZ60zUedeC0M2WHE93ZwUkPra2yUYjcHKCWR60OG5c+sRvSwBCaMuteaut1hr97JmLWxDF+Hetpbu3A7KavUuydkmf/v4Tb4BZwh4LFeL/vt6yZo4TD1b3rd0+wwc9PEyH0RxiizjYCJfRf5jWSw5VOa/fLR4utS6OmZdg//zyZyrro6wyyUvf/g9PPUpwPtRblsjpAHXqcJ+YLKO2SEfjW+Pyam3101gaSeZQOHmcO0sMYVPTxWKorjQATawWzrRZ2az7llS4+u02rGB3/+SKLgKA+75fdju9mY5KP1i8EjbPA7RR/jbLlIW6GrY+01SIbYYn3MsQvpIqIpaw85QWStQvaP63ok7o1ZyJvTmVac/MadX5LgAPwBSqA2j/a3oL16uFs+3an/P7JjqbAWWXCUT1veHtjSysBFRnKTIyvOsIFTxyG1Ak0KgEBXk5/gw49Px8LLjgk8tEMTTCrKW47ZiPvPnFXeQ43mrYHgJIUkTFrNReccw9TuW7GvjCkJ9hPHi0oY9UCJ1VdOMJc57VIDCAivM6p6w/2ksX2V3+A8Yq8Vuize0fIMEUsiNUGYbvkFEIFHPrOZoUaMCHfZ52SLJzPlIXLjqPlwasQSF2uTkEOPflLYKyfmZzJTpkLlcq8ew1wLzllAxy1H8falxSOx14dtoworj1fj5tWcaZiJf6OvTrcw/ZzzUULWdFJ6M+YGjjGw3gXbx
 aTTNvXYe
 zg6U3ocTIWgdeRskfEss8LDy/5u34WK3586eN59HRp/9cKa/p5VVvdnnYAtSReVEgUEStJIj2KA1auw/kddgftfmaynAZ/voaLp30p4wJNPhtPbuYvTNIEhfSiSIA2TFQaNUz7KqtN0FR0XwavQmiol80ibZReV5zP3PifhrgmPXkh6Ccr6MHZbIDiQMnOLxNyIHxpc2z0AYMdDlbr29ozvuJJmKDeBX+VcCxTq8r+RfnCUUsCmm+0uja04uj5kSgwaX9PHnhr2jfTqjBFLbxuRbgHaNWRguRzF10gGLq1FD3+vx/sUqx83yQF67H2KB35ngA/mk2EKws7izkPGYPSp0QQybpZXJHe5A2nfPXIHa61gm3IWQlWVxqpCVXZ1uh2J/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-26 20:49, David Matlack wrote:
> I still think it's not advisable to define name##_wrap since anyone
> could accidentally start using it on the incoming path and we wouldn't
> notice at first (especially since same kernel Live Update tests would
> keep working totally fine). I also don't think asserting the combined
> size buys us anything. The header size is just a function of the
> number of features, and what we are trying to protect against is
> structs embedded in the payload changing size.

Fair point.

> 
> So I would just do:
> 
>   /* Marks struct name as a KHO serialized payload with a kho_ser_hdr. */
>   #define DECLARE_KHO_SER(name, payload_size) \
>           static_assert(sizeof(struct name) == (payload_size))
> 
>   DECLARE_KHO_SER(luo_memfd_ser, 16);

My main requirement is that DECLARE_KHO_SER() in include/linux/kho/abi/ 
must be enforced by the compiler rather than being just a bare 
static_assert() that someone could forget to add. Since kho/abi/ headers 
contain both versioned structs and unversioned sub-structs, it must be 
mandatory to declare versioned structs in kho/abi/ with their 
static_assert size check before the kho_ser_*() helpers can be used on 
them.

So, how about adding enum names like this, that are going to be required 
in accessor functions later:

#define DECLARE_KHO_SER(name, payload_size, nr_feats)             \
    static_assert(sizeof(struct name) == (payload_size),          \
                  "struct " #name " size mismatch");              \
    enum {                                                        \
        __KHO_SER_SIZE_##name = (payload_size),                   \
        __KHO_SER_NR_FEATS_##name = (nr_feats),                   \
    }

> Plus helpers that allocate and initialize the header and return the
> payload as a typed pointer. Both the outgoing and incoming paths find
> the payload the same way, by computing its offset from the header,
> rather than through a struct with a fixed payload offset:
> 
>   /* outgoing */
>   hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
>   ser = kho_ser_payload(hdr, luo_memfd_ser);
> 
>   /* incoming */
>   hdr = phys_to_virt(args->serialized_data);
>   ser = kho_ser_payload(hdr, luo_memfd_ser);

These would become, where without enum, the init would fail:

#define kho_ser_init(buf, name)                                     \
      __kho_ser_init(buf, __KHO_SER_SIZE_##name,                    \
                          __KHO_SER_NR_FEATS_##name)

And payload can also check the existance of DECLARE_KHO_SER, using 
(expr1, expr2):

#define kho_ser_payload(hdr, name)                                  \
      ((void)__KHO_SER_SIZE_##name,                                 \
       (struct name *)__kho_ser_payload(hdr))

We can also add an optional kho_ser_alloc(name) to allocate, init, and 
preserve.

