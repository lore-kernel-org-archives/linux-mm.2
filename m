Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB17AF483F5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 20:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB576B0005; Mon, 23 Mar 2026 16:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545C06B0088; Mon, 23 Mar 2026 16:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5A76B008A; Mon, 23 Mar 2026 16:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 295176B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:22:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE455160D5A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:22:47 +0000 (UTC)
X-FDA: 84578451174.22.985ED59
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id F05B01C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:22:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uemvEWqG;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774297366; a=rsa-sha256;
	cv=pass;
	b=Ln6j3BVPpeVJirkMxegFgYT2gn+ixOnlTOX59dz3sSOf9d1oR0/gFHYZcUddBQgFw3iwly
	txuHBfJ2LlQ1n1s8bmhLzlFiH9nqBhHfJAjPA9pe9TnmWCv97aSj07GT89Cm32d/AoYWJm
	CbsYa4HncdlDcPFP27YVHS/X3zEXEMQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uemvEWqG;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf18.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774297366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
	b=jX0ZuFFjw0ypgSi0AHvmonhKYODFfHZYU5GxvolfeF+t5mePEldEMEYGisktFVDmOO3hKJ
	ca2BDs2HxpohO35kkMqACUV2H9z0kn1CftwE1sQuESRZ+rfzxOx2xsNXGNMtyydfy6XM/H
	dReMNSqL7T6JJG3RyracTM+oZfneG2I=
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5fff13d5a19so3578430137.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:22:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774297365; cv=none;
        d=google.com; s=arc-20240605;
        b=cBLR6vdGswhYVZ4IPEc9V4kkCJWb7tpJLtTwl/HtOMQub478pRC2ifX/7eg2nozPxA
         uc9Sc7W5E0YYeDIRB10BOLCuCfuYqncxVF79lY1BNU/i6rISLsDctlVeKHnSHjw2qaQ7
         +X+FeUtm1R1x12CUGKuEUo1M5IU95EF6kSJ1S7veLO1kSpHKiP2ZkUje4jBH5OYlMA5S
         cV1DL0lXhJ9OZ3qrvHFqQlw6yN45oHhfXBwsDDzSXGw1sgaHVRrFy9kysDScq5hME26i
         03twubdBDPhSgbUBYBDkKrr2eGeoxt2xRw7J7hZh8O5Q+1bDFbQ++8tKCem0tLREqLTW
         Hk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        fh=PAbbmAT6XDMn6NVOwbFWFyu4k7mKNcO/DsysiBLfuLA=;
        b=jzNhSNLO7V09KWnigZaRy8Q+5LOmzabGTwmdyj5M3qXOeUVOzCh9jSecO2fG+SZZ7a
         zlYWvsBOCJvKzk+zBzFzW/S/j9wKGv6B887PL+e4+TrPLJMCXDTlPSNWLw+fAJagaGMJ
         E2LoKQolRScP9ARKKIObTIeX/3LPXeEkYHumAfhsbWH+9hnPJ28KG2eLcEg8EGu0+6DV
         7WTpjFQSPoKDdhPeDaV4mTO0nACuI87/IV2/BpPbDPWKACT2S6KX7q6zVKeSTvS37W6L
         yCcx+iTAUNz274VD1TU3lFVw62VaX3AW0un6Zecns4euTryqdX99A1NAAg8CS4mnKdoJ
         9n5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774297365; x=1774902165; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        b=uemvEWqGuhv4MCkMdtkG6zSuTQNrQNT1jjylFYazWx1sXifkmBik39V+nLT4bdou/t
         O3oFWscH1Tq00W8mP0fVXUAue80w7DWA+8mLJUcrKz8JV6Qwc74SO8gI65klcZuYDtXq
         tE1LarFX6j8fmBdoygeBtA4mmI+n2kgpTTf/ji6sFuo2gbGbhZDsRITVmSgvTA4V7VD1
         cFW+TQyOnOpP023DAuY8j0U/sM+SfR+/VioEUfh4aWLT/QOCURdkIGtI4+GlETN8Pkho
         gNK4GRlpJjxLMXMCJtq/3vI4jqaXsZB0aCfBLCwE885Keajz0qbz9010s/TJgobFBFQg
         cIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774297365; x=1774902165;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DfIEo8yQ3CK3TKTvqaXVb6LUrtHQE6Lxe6QzmQiMk8w=;
        b=GzFnKIAfkPW43CapQz80AlXD1L8h+py37sDWLYZAzPHCSzAxCki+ZioH0qLc6D6QGz
         ViAbKpf/IdQ6dYZSU2PFKXE0muis0e72LYyXuOgfDMBl+9hxrg3AWIXIRm3EIfsv8Pb5
         HTMgaONNkY6el4UQVtkCFdcjqAFVib9WsFWZR+MBkd813VwxofZBu0L2QFurlvUskvlR
         zPxU5LLfsASp7hTLJUdYqsY/+HUzqklf3U5Dyvw3JRWSWehqxGNi9/WDsY/5C+KCIdRc
         oc3qHxs/Cq1RZk9IV0kgic+xhvF0dqPrc9ZCpVbOhQreUsDYx3rLJA2QlsGhgUwHe0Q6
         WSfA==
X-Forwarded-Encrypted: i=1; AJvYcCVsl4RHau2UqWexSOqms68DE93qhlMN1tgOaS6FWdya/7ltTz4U9IFKZOxMlrSY5AcsaeGtXgbOgg==@kvack.org
X-Gm-Message-State: AOJu0YzWIiJwE/pjKrLatIV3H9ngxx8GWw6WNSlQKSMZ1k59spL9vvXC
	oBqQ8uPULUavBOH6SQhOajrw9X3rUrDe09dpes4Z92K9jMvcm7qMUTfBWuJqV1BYLzZvHo846GO
	RbWLfAFalhNKSK2SEzVt3NrKjxJSzY53mOwBUyaU6
X-Gm-Gg: ATEYQzzZDI3/jqtfaZ13zPCWLFsh4i8gMYOtglLaRmDomPxep8tfZeK2z5au0wwlkFq
	L/5x1QIrNxlMClJeFOFrpOlwSIHrP/oVx2XjW/LD/uocrD6RqX3ftJ/WeZ8/x5PSENhfB+/7Zo7
	KJ/zj1T+hOginWFE6DSqzL0kgk5i+8r8K4hznJ0RgnS/k/MvMma/2vb9saJwWth79wcXRncM7mD
	Ld75/jjs37Hb+qbqSEAD6qUckRV/vJvzvIPwJoGtmxlX7kSEHez1wU8A6LuflOGfbqWfmSeOW7H
	orgwBrHnIA2hzAMc818GfgP0Fft9u8bMSMb8rfiwJAkEPkGr+9ffEBUQ+7r9gPYtDYXjdw==
X-Received: by 2002:a05:6102:3a06:b0:602:8742:1fa with SMTP id
 ada2fe7eead31-60316013f44mr514571137.9.1774297364023; Mon, 23 Mar 2026
 13:22:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:22:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 13:22:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-6-kalyazin@amazon.com>
 <0a14c10d-0dab-4b9c-85ec-e0ee25cd0db8@kernel.org>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 13:22:43 -0700
X-Gm-Features: AQROBzAJTtmZ8_CHcmYDgt7IaYmvr2Pi4WE03drdmWTq3AGR3rA_vEwuIGtsbTw
Message-ID: <CAEvNRgHqJGwmAfS8TuGBbUoQehpqY9GdtjUS=+Hc1ViK79RL4w@mail.gmail.com>
Subject: Re: [PATCH v11 05/16] mm/gup: drop local variable in gup_fast_folio_allowed
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
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
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
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
X-Stat-Signature: ft16pfrcytn356csesr4ijxomqm6zm1z
X-Rspamd-Queue-Id: F05B01C0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774297365-106986
X-HE-Meta: U2FsdGVkX1/uO9kyaJMlSuau2Mgihzdj7z6GsB0P9jX3KaDGdrfNZy/ZW5gO4vmFJa7JbTuuOUy0vUGxorQFEcbTb1itfIVZSZtcn/Via3pPJJJMHuvNNBxtjbuThjpovCmxit0hYkYTt7irXOPhVUL6yBuNdCeL3pzv4D/CeH+OvJeq/Nyb92x5BUYzNb67YLXd/D++bmYVQfdBdfhqtj6ycI++IXdCoWHIRH5jNAIWuPtde5GXxvFMIACBRFVtzXTt6yHv540Gyr75naWE+KGEgICDfoWxiHjvXcrqOIBoiw3Wh2+9Jnd33PIQTI1xQ9f3bASs8NU4UqbUOEggZFZfWVwZecIN/9ZLBnpeayP38zi5v4LtSncwC+gaquGD3MLXItImTVHXfNrBfzbCcDGyqs2FIx28h9OLTckYrfxh01dDdVWT/ixcHwFaVrfwHZid/zRqEkIAmA6Qp2yFaqH06/3mqvwK2/JoQnC9DVhJyJknjljqaKnUed7rk9P0eTMndLwdIvO8hJnSBsVlR9aFaW0iXQ4xGA0nDeVkAidvTzId1OUIf4kRpfHiW1Wh5OolUDnvn+gNWqA5gNmt7Rvcukjoby5IqVguuZYUd+NEv2wohKOis/P1ibHe6nc1wtk1r5OX38dSZ/Uya2g6H6Qu7K8+1/O9fJ9ZxBht+IL+w9u/hJF5s8H9SL8kKB6gdjcYN8TjU0qzqiW58FbHcGWUoerqYN7jGhOtGo57RVf/q6x0/2C82aQeZqKcbgcTvVdah3j5B0pdDm0ESbiEfDmqdqyGUynmPnON+Yw7QV/pACJf5K9nGDEQ6HJ79uJpAk2GTew1l50+nA5HdcgkydXsq/oMIzvnQeBggnufsDAjpoXYGl8FUcyPB5aKYaxpHmFvwEmZnEpEh9MFFoWpU0xSNQHd8RuNC/tmWfnz0/zLHwB4W7KvWolkGHjkWiOPTxPMOukFjNZqO2XH5O/
 FtY3WpXF
 Xw7RIifONxzxNb5+ejI8biY//jhO1hf56nwhPluwiTGQ4iF7boMpfbRloYi1Zl86BmZ58Nq8vaB4v/JR7OQmsst+xqiOv4/3QVRTexrPh3MtRWfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 3/17/26 15:11, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Move the check for pinning closer to where the result is used.
>> No functional changes.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>  mm/gup.c | 23 ++++++++++++-----------
>>  1 file changed, 12 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 5856d35be385..869d79c8daa4 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>   */
>>  static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>  {
>> -	bool reject_file_backed = false;
>>  	struct address_space *mapping;
>>  	unsigned long mapping_flags;
>>
>> -	/*
>> -	 * If we aren't pinning then no problematic write can occur. A long term
>> -	 * pin is the most egregious case so this is the one we disallow.
>> -	 */
>> -	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>> -	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>> -		reject_file_backed = true;
>> -
>>  	/* We hold a folio reference, so we can safely access folio fields. */
>>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>>  		return false;
>> @@ -2793,8 +2784,18 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>  	 */
>>  	if (secretmem_mapping(mapping))
>>  		return false;
>> -	/* The only remaining allowed file system is shmem. */
>> -	return !reject_file_backed || shmem_mapping(mapping);
>> +
>> +	/*
>> +	 * If we aren't pinning then no problematic write can occur. A writable
>> +	 * long term pin is the most egregious case, so this is the one we
>> +	 * allow only for ...
>> +	 */
>> +	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
>> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>> +		return true;
>> +
>> +	/* ... hugetlb (which we allowed above already) and shared memory. */
>> +	return shmem_mapping(mapping);
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> I'm wondering if it would be a good idea to check for a hugetlb mapping
> here instead of having the folio_test_hugetlb() check above.
>

I think it's nice that hugetlb folios are determined immediately to be
eligible for GUP-fast regardless of whether the folio is file-backed or
not.

> Something to ponder about :)
>
> --
> Cheers,
>
> David

