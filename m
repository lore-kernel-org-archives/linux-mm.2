Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1541CCD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB616B04CF; Mon,  1 Jun 2026 22:15:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BC96B04D0; Mon,  1 Jun 2026 22:15:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297396B04D1; Mon,  1 Jun 2026 22:15:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6626B04CF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:15:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D5C64051F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:15:35 +0000 (UTC)
X-FDA: 84833356230.28.A71279D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A89EE4000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:15:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVPnVtx8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780366533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDNolArekgRosQOyPhKqBidL7MM7+dNKWKcNGsM/o4A=;
	b=FpQPBWdgT+/EmRdU9nhE4/phBdmfx0tNjY5BtqEta9EXNQQLPXIoKVhIJVQC+gRtuRv3Na
	ncZgON+KCYUP5H3iGg3jG64JuwAZ8O7t5D5zxeS36aXra1wYoL1/OK9MqTQ8syZnUpNBEM
	goQ8FtRTEi27KMSWyjIqAOs9zw46nVs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVPnVtx8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780366533;
	b=CMnis/dICEborx+yMcm2DW/erIzfIB5SfuSWAZjbKyMHmQXmGcnnfiWSgQKxll5kRAHXWF
	Ama/GIBJp5tbOlQQbj2IfjhIlQGWcyiuSyibbgH+5wl8NYewP4MjAaFneBDvUBh0tAqo7U
	IZ6VHJOdNYj+ET5DWVe+Hwi93IZk9fI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E99445F0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFE21F0089D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780366532;
	bh=vDNolArekgRosQOyPhKqBidL7MM7+dNKWKcNGsM/o4A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GVPnVtx88mdLm1WWoKMJNVP52OGVT6hSqHGGU/NMJ2ZYmp1lM4EhG7bBar3rDZ3Zi
	 TcxR6ZPw9T/2gM35LpBRYKZl94OtaE0v9KeakbfZBDag3dMj+cvnK/i/UELlGHpaw4
	 bcrE6Vk7PjxVS662uUJnk5KxxtHPd4+2betlow6/BTSvgaI9DUQu1VWM/iYhUarxJQ
	 q6DAuG49IeAm8A3EP1ny0kmt0Tn4SFFsDNg81XUyYHbtjjYbNtlppOnjCQhMF242J8
	 XaHZv6Zah5JHZMdfugRssA53ppN1fZHnH10PoWAJbGYnDdk3HRNj6nSsLa40P+aqKr
	 EYJJmDXRRaasQ==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-915336b83adso393108485a.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 19:15:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+fhyc/Ny2WixyGBkGMZFo5gajL/I1unuV1tNQ80AW6o5yZqrZeEbr29u2y+2P7bZn74aFdwQh2mA==@kvack.org
X-Gm-Message-State: AOJu0YyPIuL0zPitoqmiHtdT8gQx9+NJBG3w/jCF6Tla6kWHS34DrqPU
	3YG5tXH+4MVmBCE0PbedCIMCLA6bYiqNDKFxYO9B969DsEYlen5BnLTkjRY1YS/wUw5ohE3cS8O
	UlwaZvuZMjdO94FtL4sERILveZ0R08ZI=
X-Received: by 2002:a05:620a:46ab:b0:914:dc12:60d9 with SMTP id
 af79cd13be357-9153da3c92amr2245294985a.46.1780366531281; Mon, 01 Jun 2026
 19:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com> <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com> <ahlzj--3Gm5pD9ge@lucifer> <a90bcb0fa3a044588350e92a78258a09@honor.com>
In-Reply-To: <a90bcb0fa3a044588350e92a78258a09@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 2 Jun 2026 10:15:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
X-Gm-Features: AVHnY4LJPt1t2ZBIxfgvbOEnyfUBTI1uXsLcte0MhxaOkYp5LfKwaoVVIHaTQkk
Message-ID: <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: wangtao <tao.wangtao@honor.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, 
	"kees@kernel.org" <kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: x5r7jras4819o9wnrxyaqy5yxighfmdp
X-Rspamd-Queue-Id: A89EE4000E
X-HE-Tag: 1780366533-887745
X-HE-Meta: U2FsdGVkX1/D2cPWUSw+1d6p99Ec8IH0vGinAT0e5qbdF0Jdm0PFC1vj/xyB9bobpX6mOu7xZgHm3Ls8ktfKEgPEf0yF5VyCWKXQeaPfgusc6OAw+hRLrPYqcdLaoWWj56hc+ZFH55S3l4aK3mI3Y4cTfsxIoX9wf1eVW7mvJttinS6uVpcbPjyls/SrsCuvQlOQFVT/wpWGNpbUi4BShqQkxU32zJQ+JIE9QBdrr8cLuNt0Y2BwVsi0LbGj3T9ymdbXk0sYaMOr3hHt498Y/3Emhu8s4B25TTAgMzG0DUIM9CeNcEpg5ELXuZMprVhPIOw6yqiymAOqXwN8fmRW785/blcuOt8Av8pVC3qNaFrSenkYj8SWrX0zswHLS5Y4L01XoSyCVoNxmyQOkemZaVM/TaWk7x7oYA6Qhu6HnHmZC3OFBP1DTEuXe8eR49ZTBxHiW8YvOJQnm2pbjV3SBzaGJ0qyE+hXhwK5JxF75JywKTFR4nZzf6h7mqnP1LXUTiLEYcsf5QEuyvXsYtEmKSJPBAHAtzfRbMwMERpliKJsDfxS8XSu2SZ3oUNlizDbJC3LnGP5g/iO2HIXAwFY8Zy6UVdZPaL0PhXOtuqPXQeDBti3FYbAa4MLJPMMPkiZpl23Rn7H73V3Oipkt8wsDu4dTemfkYVd7ek9ZgB86E9cljFz/uIyw0StwrxZPNs4ZNiINodJtrIrrExiDe6KOxOw6ng2t6/o8JcmCfInrxmWhuiHq+mX+U0axQbu2rsq9TEzcZ32fcDW39Llw9gBoK4ZlpHRd07h0PHAl8ajABk12UE+HqRC0dpKtjgJYcKFGaT7p96dvzIVh5i7fFT7v9Dr99MYL40UGaqMmq3jt+pWfEq/829W5hslTZFWhkt7EdQvLi5+JrB6Hy7yCOMmX2YLyp2artBtj4+uV/IrZxXrMt3ZhNGjdHV4NLlGfa+L/uEw6SzdkklchFJfla0
 KoPesQED
 vbtoHvrvSfJOVMp9vJIN6EkeCSMedLiKyZWNH38YIX0mlrHEQSWJem+H7bjqbAnM31D40MzlMg9c8kUBv+XD4Hzwf1TeGVVM3a04DlAM9X+HPHQVOhHhcGhCWF+s2AepWehLsnpsTdEiPR9EU6X26tD8tgUV59bPZXoUD6ImxgC57VzVyCFAyGBMUN142OJwIuHDNYEyAlkHBtPW790RrNpCAy8lm5cmYDjP53eSUhAQTt/EHMV7mUTg6P+A4TUAvlc62D8NjtiHchR7i4HwovdPA7ObG0G47zzP+wjzQ+fes3qrqB3+BDuwVp9vJgmIONdJ7Ch0UGEwKc6nZn/J43zozzsBkTeQms1h3WGkzMJEVg0fQm7ZHGNT4xs6naNe/y9U93f7L2d03g2FzC2KVzST0SkHeLFHjR4ZvcPHHFex6zlFm0YBqIEl8dlq/8eSM8zguUhTVZpWI9Ewl0eEliJ6Lo/rByc/4aKsdoJ5QG2Ww8F+WoCYjvLXmMFXrD2ZHUJKFHdJ9m7oHDrtNINiy1GpIpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 9:46=E2=80=AFAM wangtao <tao.wangtao@honor.com> wrot=
e:
[...]
>
> You said discussion was welcome, yet when someone offered even a
> small comment, you refused to continue the discussion.
>
> If I had known you would be this inconsistent, I would not have
> replied to you in the first place.
>
> This will be my last reply to you. I will not respond again.
>

Hi Tao,

Please don't walk away from the linux-mm community. I read your
patchset and found it quite valuable. It not only reduces memory
overhead, but also eliminates rmap costs for exclusive folios.

Since I'm not very confident discussing technical topics in English,
I wrote a blog post in Chinese about your patchset:

https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA

I have to admit that I found the implementation quite complex and
in need of significant improvement. However, I think the underlying
idea is very interesting and worth exploring further.

I'm looking forward to seeing a v2 RFC with a cleaner and simpler
implementation while preserving the core concept.

Regardless of whether it ultimately gets merged, I hope the discussion
can continue.

Best regards,
Barry

