Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D8DEF483E3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635C46B008A; Mon, 23 Mar 2026 14:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E7596B008C; Mon, 23 Mar 2026 14:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE4D6B0092; Mon, 23 Mar 2026 14:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37FCE6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:43:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C014213C1D6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:43:35 +0000 (UTC)
X-FDA: 84578201190.05.BE51804
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3FB4140009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:43:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r0VA1nTB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774291413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
	b=O25kvFXEiqS89SFCWq/aI5Ln3Jk8xD7Hge6XLeUNV7In9Co8uhC4ngHeTIfjDLs+uj54RT
	CDP32V53EvJQkE6ps8B+Qk8VDFRLZ83SGaBneIQoaU7rPzTO9k0XvkaYelm6LZes33qKhs
	UQ1rWSr9GfI46d7Wvh964SYDQWSjQl0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774291413; a=rsa-sha256;
	cv=pass;
	b=FKWmfVb/TD4UtjIUCqzDWV47f/a0fPTzaIDWM8AWpnT12nKClV6K3i7HnR0zFBOEv4f34U
	Ll03E3HDCoYiBhdXE5sSPxysWU6GaBu6D+z62H7QNQJX8dNgcZmkxyIt3znrnMM7Mayf2w
	SEpbzLs0WgemPYogZtfWVdd61cQB6R4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r0VA1nTB;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56cde28a9b6so1282301e0c.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:43:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774291413; cv=none;
        d=google.com; s=arc-20240605;
        b=HJnMwO3TNQu/45Y1lUrWLI05WsBdlUhzf89Z6YLjzycugUA58n28cednfGflAc/XUv
         7rwgFF6fa24mCXNm7SjOZsRGgj5AVo0/X83dCAkYabxYHI4YtVUGABY22edml52xUzHg
         ttTuPHG6ipaeimwdg86psjU0UrXnKFn4GWK2Uwz81oWGFhVpi/R+ifOQyNPkE0nHMSNz
         bj+AH154obtQ7+Qo/oGgoqtkneHnImIeK9BBTqygmjojm//hSTPVBDp5hFigQIbMATHh
         gmaiDFaPRb70OgTsUViRJUFc0GJbV7G2BjxzmCa9IjmAJ9pAskj61Z2kpDdGiv8T5g6W
         15Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        fh=oU1Iea9ORpylS86yx1bXPnHBVjPoAA8mzVI7Oigg1i8=;
        b=YOc4BFMAylybnbhcyzQfEC2elf0wfeS73ooElUtcfXcSE5P/Xdf+PL680q+3ADzJFs
         IazDDG4hzeZ/nlIAkTXo2tohQKUsROf6dNXzyIUJwH4zzVApERJqv+Pxs6MUGZ+y2R9/
         HVVusB1Cnufum2XOkFMWim2Kjci2Zax3+wQM9tOSFybMzzENp9I4GPe2+OV9I1qPCk1D
         wGBfyATp1B7KB97DCaoPiNqCAafsTngKp8aKjkBNspFOGHMYIOxyr0kzCMKvSuOKsWsb
         rlv8Uzw95o1O88mXbxx7jN9gZbIQQchZUhgRPcVb4q2XlKBKMx0R67Mxj8ZxYl6StOJU
         rsUA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774291413; x=1774896213; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        b=r0VA1nTB6uEFiXmplm7wjDdj4GqDBYeSg5J2rcqL3ofDfnHQfsINweqvqGsmQFFoah
         URooeudFV92YnQ7IfVScfjOowtAgYV9oRZ56w8RvDJu19mcUmgiWsVFqzgBFU1TnN/Rk
         NO94z0ikubKXHNrMpj9FD86pUqqf+nEnd77gfmHJKj7DYfnRzG70uR7B3vCvtB+zEJaQ
         LXySKvaW/WEw57I7NT7DKTVbBXEGyN41CF1ce7P0HUbS9ayp27P/lZ3vGopmOGoW7rgP
         pyfH8SHt8fUyBMKvQU+bXAqyNe1HecU5BhV9/M8c2NFul8bj/VKZH8OvkFxMiM/NMGd/
         kTcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774291413; x=1774896213;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJ1uKbr2A9AcnUKDcibCUYQIsuprIaoAVD4N5Jh2tIQ=;
        b=QjxaWQJQ3tkywuuFdKVXqMf2xpOELOJBf5XriGKqVIQMGEqX0LBzlkQipGfdBfXvH6
         tlulN4QYFeZgA3yFvyLkESboK/DI2aAY+8tEZl28/r7H5A8YFJmWXZ53Oe1YwsK7T2BF
         +JaYnQXlnE/LcejtRoUwvBq8QcZeEfV2eWPwTGCKQmb4qtj+VyeW6GAZ38Y37/TdX/Py
         xdCFNRx0cfmoTlDwEYQTwJ5YiRMw8RNWMPujE3wLWg3CtRCvR1i3u6wqfF89e0WSrBKZ
         M23i/IHxcbLoRK1/+FLDjxx+q6cget4tBQednhlcKucSgi+Y/yJp/pYWleFA6aPX99+d
         Uohw==
X-Forwarded-Encrypted: i=1; AJvYcCUIhRbYdxoYjodAVoTBevWxXvoUB/ncM6gj7/IOiXbnMP5zJNZIrvQsYtEIPmnH3K1J7zmJusvUfw==@kvack.org
X-Gm-Message-State: AOJu0YxfWLfn2oPLsH/iXV4rkE8KXg9cBAXJOXXxh+AYXF4VFr63+NDa
	ntnt8Yrnverh/HisgMj7c+yJ7RlP9shnOeQdFconAFWFmo8OAkJe8pTPNqz0gfDrFEsH9mk7EwI
	gG1XorkY7TImvAMhoigwDNjd3GgNCk+edrgasiINZHSd9wjF40PSyrKZT3jc=
X-Gm-Gg: ATEYQzyigRAxSUdNYPAhNvpx/ZxwIGPUyCx3EeoUr0/Qp6Tx9kZ/CA/S4t5XGoZ6ZEY
	FhZBsMQ7lYnM/O4VnxXSpAe4dfvgDMiMZm+5kbwJmWXHLZVd1sgisM2EhUJtD4OHOLcdFQJ45Uw
	DTKSrYHHXb4U8LqwUXzhlXG8IDaU9QhydiUqS/Bk3NmG+Vzboy0wWdeyJnKoiofrzUghtVr6SuB
	WyxfUcNvtZSrzHIj6Y+rWsfyQJZ//K3uXI/Gw4hRO5eD8GDhkeROWpMXenjkl8BjGsmkF5Yeqpb
	pgSZBbPdsazwvYFyZsuXc3gPieK63BYxxuNEBFZjZmxAtJQqAFPREPi/zjZ9OiC1jR3Pcg==
X-Received: by 2002:a05:6122:3c54:b0:566:2711:d8ab with SMTP id
 71dfb90a1353d-56cde344094mr6273796e0c.6.1774291412097; Mon, 23 Mar 2026
 11:43:32 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:43:31 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 23 Mar 2026 11:43:31 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260317141031.514-3-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com> <20260317141031.514-3-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Mon, 23 Mar 2026 11:43:31 -0700
X-Gm-Features: AQROBzAKG1Xpk4hVDWY3sqqSXNvIKws3qrAExzeSImrnNlU_ii0wYSbiIV_SQDw
Message-ID: <CAEvNRgEFBexkZCjOMFHJRQFHOpiUezD2jbfDVFrGhYXODdpMjg@mail.gmail.com>
Subject: Re: [PATCH v11 02/16] set_memory: add folio_{zap,restore}_direct_map helpers
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
X-Rspamd-Queue-Id: C3FB4140009
X-Stat-Signature: e64pak9k64gmzniqn3q7xd99bd4qeeps
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774291413-935922
X-HE-Meta: U2FsdGVkX1/BeHXBm+HJECiar8du4BKPqIFJZzbECgtISK1DQCnJ6z2eZfJg+5CeiFfSSuSvz6F+DAKMoV4Ru7mEr9ExsRJOou8vcXghemwijiYG1kfN/ncHa/Lg/6eO0UgArf8yQlX6AVOjl5j58e4aZ7oHTONt6hGpv/EdD1J3qmo59uR4SrvPvPZmNkx5pKivahgQS3igMRpQMmiF70kbvGmKcLdUAYcnV6trPMDkr7wNQm65l58qOIcuh5wfAvv0sLwKu6jcDgsKkF9FD9887juH08OHu/QuEMmAoE/rnBx/2FLn5upu2463W5aHsZFcsIiW4DKIYz26NxCev797Dunfd300C0gnMBDGjqfTlbjIpa/r+JG/K/xen0+qhhCLROjhoKlgnJbiztgYsSX8Gk+WwXYghJIwd9j55opFTHxKj6+YbGBxakIs3oBS/z1h5tAp2C8da9ZDKSRE2Q49F/ZOKOlB9imRclHhbY/RtJ1dIMeMh3h8MmDowRpnJfZAP4YM8epBS+ViW78Vk1tC8gY3aanZfhdLkRHv6347OWScU9byWdqABNYxbiiCOZ027PlLxgBnnE60EAK3V4xcbj6isl4HY8LJR88c7tDPJOhuccnwzGewcPScCDIUk6WFtH2aQoEgw5eZm9j/2M53GgjEXUhG5jFhYHfRG3t1u5AAJVZ5lSCavzyRcmbd2oCVNEIpTAtI/xjIUXJjVZXRvNTsuqpHEzEYciPfhCIBGZQ6X7xUNZf8Bw6f0M91VzkplrVczo9jTiY2mFNfIijzJmcd5FsTQQsGFWrCmzWL4JiVRZ5sYtq5hrHFGoVB4eBpNRzNx/hGotB+VYekO23C/3qf6Yb1E+LMxLFp/Spv20SoyRBalnQd9NRu9tn515oyBpy0kO5TrET+KxyKxX/d8kJ7271kpJbGM+qYLBX9OGLLk7niRgVoMw19KNmQ95/0IgQh4dkO/ToA5uF
 ABKt7JaP
 MwY8gOVtH+K+zfg0a1xk1QOPk51hwCSeHZM3KhLBzuflg/A8ZtpDMUhjom61v0aS8cTWVQIsy8lqQNGaBoxy3I+lSAv7/+lcjY1SHzT8gVWm67o0fNxqlDViSM6DzpGfAvgzGpg9Iua3IoAJaMc/1b/g4K2V8RxN2Id7VnJDr8XVbrrx1h0mCeLba01gMOg1ZDuhraIXpBWt6icwv/QskR/E02o9dnBT8lrC63xKYPBljoleV8GxD6AEFvu/OkxCj/1X4oLvWLWkKHGWpCEwUO/dPPUaToJ8fn4kNkXMM/2mDheEC1jhNe5VrnYDRMW8zCmENKVEcDlsPfA4W7x+ig2L7NduubAIiCEk0hJLXITYG+GE9hYP84wjMg9O8YTUY/c8DhoIl+VJBXW6ftmN6RUOe3czBAL1al8LSzbVoniKh4EhjTSODg5EsBVDIofXH8qUrYW5MKeTFgELQqCy+rDcZRJWzXRWnQmUndmM6dFMDlAUYL3whUVC+vD2TdZuA7SCAFJ3XyB8xOs24WB9+lmfBXoE77dkTqx7M4nPf4C1q7fhYj6XdgfnLAoDLBAWixNBIYPSl69nkwhJkiIcTZV0dOfrJWxLKQzEOpT7OMCd2gb4+wR6XeTXMcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Nikita Kalyazin <kalyazin@amazon.com>
>
> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios.
> In folio_zap_direct_map(), flush TLB to make sure the data is not
> accessible.
>
> The new helpers need to be accessible to KVM on architectures that
> support guest_memfd (x86 and arm64).
>
> Direct map removal gives guest_memfd the same protection that
> memfd_secret does, such as hardening against Spectre-like attacks
> through in-kernel gadgets.
>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/set_memory.h | 13 ++++++++++++
>  mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)
>
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 1a2563f525fc..24caea2931f9 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const void *addr,
>  	return 0;
>  }
>
> +static inline int folio_zap_direct_map(struct folio *folio)
> +{
> +	return 0;
> +}
> +
> +static inline void folio_restore_direct_map(struct folio *folio)
> +{
> +}
> +
>  static inline bool kernel_page_present(struct page *page)
>  {
>  	return true;
> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>  }
>  #define can_set_direct_map can_set_direct_map
>  #endif
> +
> +int folio_zap_direct_map(struct folio *folio);
> +void folio_restore_direct_map(struct folio *folio);
> +
>  #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>
>  #ifdef CONFIG_X86_64
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..cab6bb237fc0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -78,6 +78,7 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/pgalloc.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>
>  #include <trace/events/kmem.h>
>
> @@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
>  	if (is_vm_hugetlb_page(vma))
>  		hugetlb_vma_unlock_read(vma);
>  }
> +
> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
> +/**
> + * folio_zap_direct_map - remove a folio from the kernel direct map
> + * @folio: folio to remove from the direct map
> + *
> + * Removes the folio from the kernel direct map and flushes the TLB.  This may
> + * require splitting huge pages in the direct map, which can fail due to memory
> + * allocation.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	const void *addr = folio_address(folio);
> +	int ret;
> +
> +	ret = set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);
> +	flush_tlb_kernel_range((unsigned long)addr,
> +			       (unsigned long)addr + folio_size(folio));
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");
> +
> +/**
> + * folio_restore_direct_map - restore the kernel direct map entry for a folio
> + * @folio: folio whose direct map entry is to be restored
> + *
> + * This may only be called after a prior successful folio_zap_direct_map() on
> + * the same folio.  Because the zap will have already split any huge pages in
> + * the direct map, restoration here only updates protection bits and cannot
> + * fail.
> + */
> +void folio_restore_direct_map(struct folio *folio)
> +{
> +	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_address(folio),
> +						  folio_nr_pages(folio), true));
> +}
> +EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");
> +#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
> --
> 2.50.1

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

I also took a look at Sashiko's [1] comments and I think that the
highmem folio issues should be the responsibility of the caller to
check.

[1] https://sashiko.dev/#/patchset/20260317141031.514-1-kalyazin%40amazon.com

