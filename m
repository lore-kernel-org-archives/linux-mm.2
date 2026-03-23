Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9886D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212B96B0088; Mon, 23 Mar 2026 17:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C3176B0089; Mon, 23 Mar 2026 17:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08AD26B008A; Mon, 23 Mar 2026 17:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC06E6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:15:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9761D1A0D45
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:15:29 +0000 (UTC)
X-FDA: 84578583978.08.E2A9EC5
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 70D32140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:15:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q8LL9Jm7;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774300527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
	b=aBhLMGlE3A6TG1MJQthjRgZcsFrpYiTlNvp2zci3X6jwzMB1KVHRUH37sZM8usiP5IcezJ
	/n2aSMTYpyJlWUxvCwEsN3VfnyDq9P88FwSay2fxMC/0sbpcrVFDswoV17U0o68mR/e6DR
	+Xjj9jfJ4fTGYNhoLcml3ce2JkMVf0s=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q8LL9Jm7;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774300527; a=rsa-sha256;
	cv=pass;
	b=EzXAdV9j2DO6GBQH9RtxaWVlP12vrmB23zypnz2tjx1VSoHv6jtMtZOJZkpYhPyUFjjChK
	mhlWKUZEmEByvbsL0tdEnWIyefwhc7cCBwxEMKjPxYZt6OFgApMrXsKO7O0ibSJF6E74IO
	O///rElMBb/CH8RXRHmuaZDbq5g1F0M=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5ffe6887e29so427557137.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:15:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774300526; cv=none;
        d=google.com; s=arc-20240605;
        b=VWgOl9gaMl5nNgir69I0JQVEAKaLBtTPxisNW6obzpbsyjYfDFz2Bjxew92Vq7P/qL
         gtdEwpieHb8US5iwM5EfH5klrdrPn5aEdNIlNjjf5iRgFgffVdAwI3gSBoglkQQ74F84
         VC0FaJnWI7x6Xqxsgi47xADNtS1IRFLFtF1WwzJkenZZPNGMjD9/MoP8MTDDGKnIipKF
         /E1NWyeVSTN6/QpQ+Dc+bAtBzXEOOrScrGazlJ8zCqQc8nYGBi4KUDWWrdh0beSWR1bY
         GfVp9NB2CD/y9SKz58ZDOlF7/TWkBk0q1oZuZG80ev9t8VnoO4DvLf9ZDzKFe+wzd+mw
         PiXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        fh=LtnA2WdMMlS3xTTeV9bKtHdfpFdWODbwBd9ln/l4v/I=;
        b=BDyHO/VjFLmEUb0LmMjoGCr6R17I1PzmqW5bmPakud6f4iCmap/bw9ACc3oagsGVp4
         LnL27P10M3RAzftAHoxOqeYM2J+ZBIa9H5Y4X9duKcxco2Q6GIz13Zgk6hhEg5U9u44d
         0YjflRmGrGa1syHa9xlQuwzXc8TAAudQCLjPwVluEgBzXvCdnDTlo8Rw1/LxN5KwlN9M
         o7WyGhXv+z4HXEhk8J1eXFv3JmcjmuOlp41yJbxZOu9/3oEoTB0gh+Xf1zHWvgH8GQoR
         NyZglP1+e7kLLq6n8f0AE37VaCM9vE/RQP8R37PrTe05pW6SG83GjI0poMIUDnOi1MYP
         Zg0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774300526; x=1774905326; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        b=q8LL9Jm7bfsgxAAKzBd/UT76Idtt1CZCh0hkXn0LM07E7Zup0KLjhb5H7gQ4RKLMz+
         SF9KG65GEn4qt1KGQsBqDacIu9mqnYAjkc1D5pkc18RoMZW4y7aHTtsCzE0qCdTov1kX
         3QZcoFlUcIqYqqqMTvuV1FzbEz+V5d4FY5KM03fR2akQEFN+O2gVLrmKFOvqIKe1PavV
         82O5P6uIw0G67ZxHGHhRr8c+VBUS575P2RpdI3yR8zDJH4M/KiRy0L++5zvLS7UvT8AY
         QJcN9qXtOkaIKvZYTIhH5j8KpCLVOQ0O7FmAcbtjaWdSqAOQzJHJbrHH/2qcvM+uKtw5
         mJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774300526; x=1774905326;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOYudi6RRVXGeHCIabojBlAXxTWtuPC09s4XfPfEePE=;
        b=dIsM2pe2qklZLp5uaM1UDpiQuezPs5biKej4R/oc0z3oogZCmQomLoOkEViRtLb+qb
         GeZzxse9fuFFqNpPZpyuuHQuGXGA1BMBBjVpQ7gkzBEbTtgjFHtS61u8HFiBKA9NLdML
         iHBndlsmxSzor9pS28Wlbe3+XUGK7Eyzolc4aA++bFxrSJoJFecEo1Fc1VofEdJCmcn/
         b9Z6/b4EQE+ON5C7HLMy6kmmZAZHQdk/XuZ2Mmx2Hy+WN9FnKLYD8WZpm9Z/A/KuRDFb
         RN+6bwdWiFc7sRF6+N9fjYdVeX/Iq0ae1Gb1DMTrQbimuzaPC1dCLmhYBRGlp9V5XXDw
         ffIA==
X-Forwarded-Encrypted: i=1; AJvYcCVp5x3hi7ppKB1cwc0ADSNoYAMYw+uWQ7/DE7Z9p+30nYZ4Y8bJ8L11UbbzuDduj14kxTPiYYqhKg==@kvack.org
X-Gm-Message-State: AOJu0YytPvnme9HLa2GbEq1WoIJ6cuMQlVw5/obDs0deOq1fFYxMjmLg
	NKEAHgqAj6PKDE7B2vJao8aeXsR9LIAewV8s+zofJqYzvC652gGDvC4rlOe7V/5JcSMUT3RtRgN
	265cbR7RBwU8MiqBDEKV4XPkOCSkm8TlKxpL8bUKD
X-Gm-Gg: ATEYQzzEM2Fxigki/xbXHLtaz6fnoc/eABVfrTV5qSzm+cvYcOZCPDxSnySa0/NG/aF
	BiyfZkI6LL4tgdPxLn+3vQYfRQYPINEtHcflNfEW5lOmOt2b0PPWZVAozaG8pnIEooZJ2yO/OJ4
	zjy+TKQn9ofwSAvt5wkUO/Pfz5PklSuI65GBas0GzLQp7ZYTUkUXaNIbzPbkuhC+wJcZftT6NDj
	zkUzE/bQA7oC01hwkb2TvElMDRQII5f55B+T0r0EomRJ6Y+duHx+mTbbhxTVgjOji10N53gWyiG
	nfpNCYg9p8BzSA/ppSPRjjjCE2oATxVyZMWP1ZyDPL7UkQwpUvuMD3mtws7uxTugz4PoKQ==
X-Received: by 2002:a05:6102:c86:b0:602:8894:b770 with SMTP id
 ada2fe7eead31-602aead01admr6510052137.4.1774300525553; Mon, 23 Mar 2026
 14:15:25 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 14:15:24 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 14:15:24 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-11-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-11-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 14:15:24 -0700
X-Gm-Features: AQROBzCF2PwLv08LGPIvZtVRv2cQA-zzDMITL8yo-SXZFcfoxiXCsTVqhJQCkhk
Message-ID: <CAEvNRgGb95C3uRxPy2_Uj7SmTW45hNNdJxi5RR209s5KYcHgBw@mail.gmail.com>
Subject: Re: [PATCH v11 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>, 
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com" <tabba@google.com>, 
	"prsampat@amd.com" <prsampat@amd.com>, "wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>, 
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>, 
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>, 
	"rafael@kernel.org" <rafael@kernel.org>, "vannapurve@google.com" <vannapurve@google.com>, 
	"jackmanb@google.com" <jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: mei1w73m3hxht1sxwcf1i1gp3sriq41j
X-Rspamd-Queue-Id: 70D32140002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774300527-627811
X-HE-Meta: U2FsdGVkX1/c1ivkILX9sBhmREtRdZ36/1deYQqGSlpHImw8gbRhB0eTo6okLYrFk+DTu/vM2fSk/R69nREYbFQvF8zqiyzk4kzRo+kjJR0vdV4rfk+AF8sJtO9pVjy2boUTmQZWZ668VvVaG3wyrlJrXxiSqJR3XyBPfdsGgzTnu/HIbaKBUfwDdT2knuOwgcmg+vdw1shUucMEH9pe3d06GjvdhmyiwNc6CjF+rT+hRnOfAN/E5252uy0Tt24f2bmXrDLG7VteHWJi4DCIunoNfuu6+9c6sU5rub2PdQYkBAfOKx8OYfYR3t0N5XdgGHlMG/YpqPBX3tLabVo2fGukq/KtqJIteyxdjmFdXV9rf7DpG0PfqXs4x5jDhR/HQwK+IFEMlnfMQDP3wnGhivJUEgDI7Y2DmPq3JHPQSQDHXjuOtCqILnZg8C9RH4LTGzfEjU2Zw8q4+qUojbV/hvFH5Ch3HQ8ORNODlfDaKuyGiCkIbCHmuiWP/znb4w8Kub2PydAVD7TgLA5knZDLGwka5BWDOE+Bde3n6vmc6kYn36RHaG072/sPfxBNX00wA39sIyFp5XgP0JWyB7V18p6FMlwU6WarMACI3FsXVAE/QZEVo4Chojf+KLqxZ99fzNLTtW2BOuILYAMp+iI3XTpsWLpFEKRvotqCJUEBzpQy3qEEDfqklzohFhOpw/Bx8s9k+XMfo75cCI8bW7pdIUyXuEkV5du7xbG31m62ueT4+rv/TZ8xEYqFEWZIE6Voc758QMHvyjsHni7NyoHzbtQHIL1nzc7g8QdhfkBtEFLL7s1uRkUsNw4y7DH/jK0pdcZKQmZpwnkD9gioJjU30XTqGr0OoJcaRbnHfnwbvigK+JR1as71bt3RxJOY4WPwzrQkPPMfdkCNqLFjl0XEZAPLvvtsLiu6Yz87hR1FzZP0BhXxm8w7fcedymskZMOXiZ/831tdsf2pDst6DSi
 /CBP57dU
 Kc+45U/1/VPkVI6r9eOBMhVBa8V7raLOanzEqngwsg6zGfQHOJyxuY54b03TrvCzjFSpZgL7bhFXE5sItUjFJegorOtEgmMbyf3qr1FfJqpeoTOHXX5Wi9Nkm7XWqTIsbeTDdXDmybcIHr1KutvO0LPUX0iD6QOZNarossdd66IyRI8R5i6p8JG6NvKTlnPtat19zYdFBunvo/khhDJwlUI/9jN+Mr/WiWixpBlJqXkXp4SPKx4PjyPUjrvOjbGhottoEykctnYKHSYUiqQ0JVS8LUa/jkummDqhvt9+jMaHDs4T9cXZADPIT2vAmEoBTi7rCVap4pL1mxdoL/NxeXSehn5t+9AUCSdviO0MCpwxCrfFO5OiyMzOFBdcfbztRsKGXcVfv1198WSsZdqkBhHBzNS8q/SFikGbgaVQZnT+uOkNrW5fYZNhKuejtM80U6GoGfgeLbPJY5iCKe67k4ZE7Czzu4VlF74b5FH2Z0Ae+Fpwt6oIcsuszdsP5KxmjcM05X5RBsk2C9vo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

>
> [...snip...]
>
>  static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  {
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	struct folio *folio;
>  	vm_fault_t ret = VM_FAULT_LOCKED;
> +	int err;
>
>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
>  		return VM_FAULT_SIGBUS;
> @@ -418,6 +454,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>  		folio_mark_uptodate(folio);
>  	}
>
> +	if (kvm_gmem_no_direct_map(folio_inode(folio))) {
> +		err = kvm_gmem_folio_zap_direct_map(folio);
> +		if (err) {
> +			ret = vmf_error(err);
> +			goto out_folio;
> +		}
> +	}
> +
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
>

Sashiko pointed out that kvm_gmem_populate() might try and write to
direct-map-removed folios, but I think that's handled because populate
will first try and GUP folios, which is already blocked for
direct-map-removed folios.

>  out_folio:
> @@ -528,6 +572,9 @@ static void kvm_gmem_free_folio(struct folio *folio)
>  	kvm_pfn_t pfn = page_to_pfn(page);
>  	int order = folio_order(folio);
>
> +	if (kvm_gmem_folio_no_direct_map(folio))
> +		kvm_gmem_folio_restore_direct_map(folio);
> +
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
>

Sashiko says to invalidate then restore direct map, I think in this case
it doesn't matter since if the folio needed invalidation, it must be
private, and the host shouldn't be writing to the private pages anyway.

One benefit of retaining this order (restore, invalidate) is that it
opens the invalidate hook to possibly do something regarding memory
contents?

Or perhaps we should just take the suggestion (invalidate, restore) and
align that invalidate should not touch memory contents.

> @@ -591,6 +638,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	/* Unmovable mappings are supposed to be marked unevictable as well. */
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>
> +	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
> +		mapping_set_no_direct_map(inode->i_mapping);
> +
>  	GMEM_I(inode)->flags = flags;
>
>  	file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
> @@ -803,13 +853,22 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	}
>
>  	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (r)
> +		goto out_unlock;
>
> +	if (kvm_gmem_no_direct_map(folio_inode(folio))) {
> +		r = kvm_gmem_folio_zap_direct_map(folio);
> +		if (r)
> +			goto out_unlock;
> +	}
> +
>
> [...snip...]
>

Preparing a folio used to involve zeroing, but that has since been
refactored out, so I believe zapping can come before preparing.

Similar to the above point on invalidation: perhaps we should take the
suggestion to zap then prepare

+ And align that preparation should not touch memory contents
+ Avoid needing to undo the preparation on zapping failure (.free_folio
  is not called on folio_put(), it is only called folio on removal from
  filemap).

