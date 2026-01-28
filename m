Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDFED2FEF4
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 00:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397A06B0005; Tue, 27 Jan 2026 19:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BA96B0089; Tue, 27 Jan 2026 19:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2B76B008A; Tue, 27 Jan 2026 19:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 090276B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:21:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4477316010C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:21:16 +0000 (UTC)
X-FDA: 84379468152.27.A5403A2
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F8D3100008
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 00:21:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OgMVMLqw;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769559674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
	b=eWcK18l2MYXH6UQ9RFjFj0UWzh2mt9NBuAxJ+ZWu9loIDEU65fGwcnbReTS1ZmX6x/zobw
	WlWRl2BZvc0/AzlAEuCLeagXAICOR5xSmOKF46rFacVvgpj2dZQ+ZhLcJQqHn0Cz5bJRpA
	uhpJ0aphZStebmIYrr6YPKq4uecsKQc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OgMVMLqw;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769559674; a=rsa-sha256;
	cv=pass;
	b=4ShQGkLaSbrQvU5YI+4Xuz9qQ8soH5fzGgMoL1DXAYALgzEXRHjGZ8CPnYcuRnSK7SHNuu
	WCjGg1eGsjmLowy7BB7gwJq3F/kjt2qgF3Ipj+JTzI2DFT9IUXcYhDFg4uOKcAh4y6S0OR
	Pi80NLno6qyVsvZJPzuKqjJ41hQCA7E=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-94801cf4bb8so1813551241.3
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:21:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769559673; cv=none;
        d=google.com; s=arc-20240605;
        b=f+Z5yLE2f7VET5DuTsgVqXdbyDErP5Y6v+8TW7AhhnUVBmAT1SW0xPierERUSNbcDz
         XghO4lY+x3vr7AZJtWOfEsyRMgm55vzgpwYStRL8mPM91ok4VyLKB/J4UTldUbC7K9T9
         Wl6SCXxc4B6wyt8vv6n+R1g/gJD5J5jk/EA8CmC/1KGkWhtBLQLI9iyQXzXJtr8W34VA
         s3wqzih/87EN6dqsmn++Rqr7jW7SoijJucXopjsjRI6EfOLd6GMed/3sd2tsSNrkSH+M
         PqUw52UvIYSW2xfy4sFyV/W0FW0IfSMG2mJmgFy6YHNcOIZAcL3fPnk3AvVpmQLLKq9w
         jmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        fh=FhBYaKHk6dUIqm7MLBQvQ+6ihxwSFKKqRURhWz/bC0E=;
        b=ihbQc/JJUz9u6qQ1hMt/HMdbMdJHrRJlTM9tGzMb1dhDEod163nQ3uI/ypfFv5c9ZP
         A9wUoXW7TDgEjXSn8u/CduqcUjCA5udMRNHcgafD3OP+nfS2qsWIfWRyL2XDI3LAjihG
         dLmf9hQDiD9H9MaehZ8zteMLgXjj0AnTyAd9ttQzNSTAUoUtA6RXTO3+LZiDr72Iqunf
         FFf2K4Bd3l0pP7lIO0HORYBrF5Q1vN2uIcfeikhWn3tgetqDyvODzOPT4LAZq0pRP2Ns
         LvLLV6KQ/eJ1USJDa8haIi8hhfCe9IdyfVwoevQm+i8sPwRv7StyE4weWXaU6KVAjmxx
         SUbQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769559673; x=1770164473; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        b=OgMVMLqwk9kMZZcUVKn+w0fYKiEV45TL1LTtprY3OpQLx9px4HXyBGajdb4BFsFqJA
         IJcy9ZAzkcKiVdJXWwSZ3vQyJVDAQEkU5ugtmfO/YXG9fUUiyR8+JlBm8hXuJ/Mvj4O5
         P4bzuhmszOI08zdqswBAuhadfYWs6i3ozl46jMnR6pxax2+fs4ZgjDirvmCkB1zylWW3
         Lda2GVQpjJKC9myCAf1eJ4V3WQANwBF/XHNh2avtXlZLZ9cadUKNUQYM4n3eGliCtYVa
         jJmCklWvjS8WgYOq5zSJMb3YRk7vvTBsxWB0yaosgJgW/gA/n3FMkq/HeU3q6PNx1vZ4
         Il4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769559673; x=1770164473;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtv6l5aP4r9bRMzqX9oNvs3QGYC/8h1s4fLDq3qnO1s=;
        b=sQiK+B3w72RRWwTIRkykDPVggNBoKXuKx5EJFecDF4ngXY8CxamydkIszFr4fxvDuv
         KTd8DDRCEoSdwalzDR+NDZcWRabVpiMy9k6iVdIOkg3VVWylYN8ZZjGlV/HTJkDvfdtk
         hBhpzUgMZt1fFdqF1T4ewDTw9iVMadWnc+of3AIUN50hJ4Nb2DTpneScT1yp7pqxBrMd
         mQRxNVfOSVRDGolMjue3mdiD4eZ+c8DiO32Cih0vFSfpFRPZy1DA6GqMX2714A4HTilC
         gncD5G/br+Ws2mFporlkIANpAEOA9DiDAfNQeLfnabjg095/l2YzScm/rXWufXXlY71H
         C3og==
X-Forwarded-Encrypted: i=1; AJvYcCViSkmM/E5D2oJwctysFwBV8K8TEzAmMjgRionMgALVBD5VnxQF2QkYDPN6nd5R+kyf5ArUq3191g==@kvack.org
X-Gm-Message-State: AOJu0YwecBciuYCeCwRBQX6cyY9tgLPMN69WN9GJqmKMiEg6sXOzARyR
	7DgfKAzz65IGI6f06KjVz3vrVee9VRfaOXtxzlaMWYEr/SvasrMLDHcUvesXki1Mm2hDzbJT/b6
	86V4JjTDeBYH0XFm16xD9eH8C8FcggrGo/pHSf/8h
X-Gm-Gg: AZuq6aL8xpXUqiJGyvMCVkPx61HPDukp1fyaCkZWOJL10tQC9uA+3vbcYRdWrUPCO5k
	XdZW5uajUL3b2/HwCKPZCP+ZMiku2aPhv7k2+s8LMHxB+HlpRLoPw1Ecn1u5pbahDCtaEKWv8FD
	Me6euhvrF09Z7zfTu1i2CmNLjwD/Ke68dMjgT9dDZXnTEMDBDcVqJ9Ky9jAFuIHdqqK2ceFnRIi
	gqPqTjGQTgMUG4Z7cRJaVLAUGYOiEpDO/fXiKm2wDJ5gwpDQ4/Ygzbn50pyRkILE6K8M+iq+uZo
	TyU9nTM9MFaXft7HNDWDh2qRWQ==
X-Received: by 2002:a05:6102:2926:b0:5f5:2ab7:cef4 with SMTP id
 ada2fe7eead31-5f7236280c7mr1308564137.12.1769559672438; Tue, 27 Jan 2026
 16:21:12 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:21:11 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 27 Jan 2026 16:21:11 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <afddc163-4b1e-46ee-920a-85de3b347291@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com> <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
 <afddc163-4b1e-46ee-920a-85de3b347291@amazon.com>
MIME-Version: 1.0
Date: Tue, 27 Jan 2026 16:21:11 -0800
X-Gm-Features: AZwV_QgCVtca03XgnQCypNXAbjgX301aeAGuQByaW4GAjqTre8UeoPpevsc7bzA
Message-ID: <CAEvNRgFCwU7ezDV4Spj=H1JZohG9CSQRKMh_h1OGY1GrR2=7Eg@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "surenb@google.com" <surenb@google.com>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8iboiozgzft7nrfg8sez1ncee17gay6r
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F8D3100008
X-HE-Tag: 1769559674-366490
X-HE-Meta: U2FsdGVkX19VzT5jSv/NCJjJnyaCF57LT1UuPrsOcWJGOgWFL6BOW774VZ2eOLUrtUucPkF7ZmdT5JL7Cvu2wtDF/hgd9nxoqxAkGK3GcaO+ITf8IgugIp+hzQnBeHss1dC21TofVOhbjw9LvodGi4bIQBBlA0XEVuD4JeZW9B/fUzzGtykwoXSOxBWchX1bLrLwY8gc71ExoSZimcSw5AQ7PIKCeArhq7N5+xP1vHvUVg6BK8OdGxko4XPkrCMdcJQqIfbMqmTjraBuOAYmQ+W9c0LIrnukVkHTcZK5I5P9zEWDBfHhSfVzrDxSHIHNxn+f1N+mIYQ8k8NVTzH23E3FJalex+NKPakFipa5u+nraU4JAaSmwm/goscOFN9mle7WACdyUk0XYzJ35rPO2wmYUAVSRfLB5Zw7cvBbY8iLG1/hsPuIZM1BtquV05WgH9FzVTCOM6XW9YybXINo5Y/Y8QrKi4CUhg/0nTMKaZX4pjfS+yQG8W1zoH8luVmCQtU6uH9VcRCQmsZU7jS/T+JQtiG6WY0G22IkQ0BlJy2t3jwaQbHjlB4gtW4B15eTft5aRxyGZTgWH36/2+JHc1v5/tPQSB803vkfB0P11C/WqWmfPTSFfPacgB3VtDuYukPZb/f8JsJQTwAzWPtTy2rsM/7t3RW5KEMgVudIrzh8HscScTD+3tPD5LYCGA98JzXfN4ctSKzLSXb66tCfeRODBhoVOukbxfGOWxxCz6mcDTFctP3FRjzyH0ZQfYRm3Iaz49ZCz1PRKDEfKa+04XLepMFc6Y3+GuqfAUVM/ABYcuS7KQCZcBi7UULzPhnRyp53rXUOgXeM1gmBgjyyBdtJu/Fr300DrI6xdCajY9qeDhW+o+KVtz2eQHhxX/pEYAdC1X11Rpul9LxpOVS/yhImO54K7LJlX7oWVQTtQjHuuoEcrIGUJVXMiKXEN+f8jcOHi19IM/U9GbJJor4
 tNWcAcdx
 do1BV9I/qDMHGUKsGDz1wuUwEjyj7WSGYX5tVN+gY+i6yZrBAgdquLxK2HEUpc8S/dwATDt/Wd8bjXaxUdk75TALI97FJeNxACaKFiA3OS1XexjvWTcU6k1XeH34KBZv7ceQAxRvbR2YExe2PFseL0cggqd97mZUaFWiePJoNxyGNohc3zI4A7QL//Qoogj8Q1fJJ+OE45z2a87S3xGdlcbDS1SE+Sc35SpVSLshwa0P0Y7qUOGX2BFLdDvcwuVqNHosk8QWPR1o950mhWwPD4kr1H8aU6PogjW/GnkEWY3GhFoIzZzHuvHaqIUehzVvql8qPz1OMcwryhRkD7T3srrmW1FXZgbS57kP8rAyzzxBLUVun3kqE14/LZoPBjz0myIf5LA069r695Tu0l+kbRgAwzi9a3gDWOPCjzObGPluiVI2xyULCASXw1XNZtclXfXrDJXZIba7dGLj9ri8GUWubicGxTm9H7iC81pjaelEMuGqtG+foWKqmuD1Gn6rswooTTUeNa46yp/g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 22/01/2026 18:37, Ackerley Tng wrote:
>> Nikita Kalyazin <kalyazin@amazon.com> writes:
>>
>>> On 16/01/2026 00:00, Edgecombe, Rick P wrote:
>>>> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>>>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>>>> +{
>>>>> +     /*
>>>>> +      * Direct map restoration cannot fail, as the only error condition
>>>>> +      * for direct map manipulation is failure to allocate page tables
>>>>> +      * when splitting huge pages, but this split would have already
>>>>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().
>>
>> Do you know if folio_restore_direct_map() will also end up merging page
>> table entries to a higher level?
>>
>>>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>>>> +      */
>>>>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>>>>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>>>>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>>>> +     }
>>>>> +}
>>>>> +
>>>>
>>>> Does this assume the folio would not have been split after it was zapped? As in,
>>>> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
>>>> restored at 4KB (split required)? Or it gets merged somehow before this?
>>
>> I agree with the rest of the discussion that this will probably land
>> before huge page support, so I will have to figure out the intersection
>> of the two later.
>>
>>>
>>> AFAIK it can't be zapped at 2MB granularity as the zapping code will
>>> inevitably cause splitting because guest_memfd faults occur at the base
>>> page granularity as of now.
>>
>> Here's what I'm thinking for now:
>>
>> [HugeTLB, no conversions]
>> With initial HugeTLB support (no conversions), host userspace
>> guest_memfd faults will be:
>>
>> + For guest_memfd with PUD-sized pages
>>      + At PUD level or PTE level
>> + For guest_memfd with PMD-sized pages
>>      + At PMD level or PTE level
>>
>> Since this guest_memfd doesn't support conversions, the folio is never
>> split/merged, so the direct map is restored at whatever level it was
>> zapped. I think this works out well.
>>
>> [HugeTLB + conversions]
>> For a guest_memfd with HugeTLB support and conversions, host userspace
>> guest_memfd faults will always be at PTE level, so the direct map will
>> be split and the faulted pages have the direct map zapped in 4K chunks
>> as they are faulted.
>>
>> On conversion back to private, put those back into the direct map
>> (putting aside whether to merge the direct map PTEs for now).
>
> Makes sense to me.
>
>>
>>
>> Unfortunately there's no unmapping callback for guest_memfd to use, so
>> perhaps the principle should be to put the folios back into the direct
>> map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
>> at freeing time?
>
> I'm not sure I fully understand what you mean here.  What would be the
> purpose for hooking up to unmapping?  Why would making sure we put
> folios back into the direct map whenever they are freed or converted to
> private not be sufficient?

I think putting the folios back into the direct map when the folios are
freed or converted to private should cover all cases.

I was just thinking that being able to hook up to unmapping is nice
since unmapping is the counterpart to mapping when the folios are
removed from the direct map.

