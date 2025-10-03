Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A68CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:11:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54BB98E000D; Fri,  3 Oct 2025 12:11:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBE58E0005; Fri,  3 Oct 2025 12:11:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB848E000D; Fri,  3 Oct 2025 12:11:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 232BA8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:11:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C20FC5B93A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:11:05 +0000 (UTC)
X-FDA: 83957292090.14.B8F86E2
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id ED81440017
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:11:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TNtZBnWD;
	spf=pass (imf11.hostedemail.com: domain of 3lvXfaAYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3lvXfaAYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759507864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNh2mX9a3msgEQw2OsPB0rXj0BKWzfoqoJiUnuGpBLY=;
	b=d1qq/vqKxSGnMFSmGkJXIe3/3hyt0eN90XP8Z6YIWM14CEMEDIWrqw8PKlzZqlnH8wBJkK
	7MAb6qu2zpqNCCA5gQnY4/GBRLosw0FerNAxstPdD8LZJhBfCQJq6N38jtmpPC8OormDGp
	+IWQYcUFt7AIQz6eq+N6Sn3YLx/+6dg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TNtZBnWD;
	spf=pass (imf11.hostedemail.com: domain of 3lvXfaAYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3lvXfaAYKCE89vr40tx55x2v.t532z4BE-331Crt1.58x@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759507864; a=rsa-sha256;
	cv=none;
	b=EI6P8Enh4qZz01AeGGeMdCW9uDngGaXKDkAm6aw0PVvFJJfnXm4nFuHuQMRQ1mPvRebgkX
	jOYvVeLXeKusIUaQUfF77BgoGvL7jfQU1AxpNqk4bHRskxnlTWF4AxQB8GwY2BwoltqwIx
	PeZW8yyOGuxI6lJSh6+3DqN6PVadxCU=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28d1747f23bso24809705ad.3
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 09:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759507863; x=1760112663; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lNh2mX9a3msgEQw2OsPB0rXj0BKWzfoqoJiUnuGpBLY=;
        b=TNtZBnWDVw3ob8fIErlx4/AW5VYWccnaQRiOc2YLbz7vFBD+mHIHRHqelyBJ66reRq
         jucQDF4uJgyptO25KPsve7FdFZQY4rgRB6azCQbb59+sPLm6hN/mlxJF37gT6MV2q5+b
         O0PpuI+9qEFqlB2bXOlqv9yq7MaUrFlCZ/cmzchsW5zTnOykkkFAGm0jkL3jMHPQNU8b
         2rV1yMFk7f76GKf07LqajCtzEr7K6U+Xf/D2+ZvgrhmfeTwvvObClsHWki/XCcFqdmVN
         uX9hkCz8jwgSvDKKzp5EF/0wh0/qakQXvzkSXi3eLKcOnljuQNCiytWU8WLAQ+vBW0jR
         JKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759507863; x=1760112663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lNh2mX9a3msgEQw2OsPB0rXj0BKWzfoqoJiUnuGpBLY=;
        b=J1tU6NPyBerTBLp7AjmY4jRBL7nU37Uq0hEuueb7rOcr4BZKRel6e3oGqccr5b55Sw
         LGRShXK9zR7CSxXkBLixiS1cEveK/rotjSRbxmZkfTEX+RqlFtCQoWUU1k7Wf0J0pYlW
         jXdQtj6wzIwaKBPHWaJ5agqw3vQMCu9F+VjoQrV/NI9twDOjgI4YMWlsC8yCPUrl9eg0
         l+9EzOMHl0DFNmxb5r1RinbBvCtR+u1R/Umo0OrXuOqOA3esJbQyugSj03jRrM/e8Hws
         mXkniCrJ53WVW05GtAY5svVBOA1lLH/ypiwGnbJCgIsjP8XXB7AjkspHH+5wv8rQXJM2
         zwTg==
X-Forwarded-Encrypted: i=1; AJvYcCUPo8+C67Y1NDZgAD9gtIV5BKo58Rmy86DWWg33NxYlDsDabxJIQUJYccDZ3Y+AAgxgTswf70+PnA==@kvack.org
X-Gm-Message-State: AOJu0YxNpMGzk7XVu8vT0zw0Yr3A5cvY4GFbW5PP6M5zII73ySG3kYo2
	vsuWdRx6G3MsHVUFd+UeZz0TYA1iDvtFfBbzuSxZFa21Bo7wtbMT+9F0LyZ1h4nJjgE3D78dLNX
	2Gw4HSg==
X-Google-Smtp-Source: AGHT+IGqNOuAruJgEcEZ8T6X7B8VeXMzqceZ1ggBpiDOEhdpqVLI6EnOOFhpmeY8C5TVlMwWJfNoQPt99zY=
X-Received: from plbjw19.prod.google.com ([2002:a17:903:2793:b0:273:c5f4:a8ca])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e786:b0:268:15f:8358
 with SMTP id d9443c01a7336-28e9a656d8fmr47206475ad.42.1759507862519; Fri, 03
 Oct 2025 09:11:02 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:11:01 -0700
In-Reply-To: <2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <2ae41e0d80339da2b57011622ac2288fed65cd01.1747264138.git.ackerleytng@google.com>
Message-ID: <aN_1lSZJKBKvU9gV@google.com>
Subject: Re: [RFC PATCH v2 35/51] mm: guestmem_hugetlb: Add support for
 splitting and merging pages
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: ED81440017
X-Rspamd-Server: rspam05
X-Stat-Signature: jq6nfnnka6cq71dz9rxdrttgsu8cjmbu
X-Rspam-User: 
X-HE-Tag: 1759507863-626304
X-HE-Meta: U2FsdGVkX18plTA2Fjb1By4gMCPtqh3M/eNJLTQ6qA8hOAMqHLn9QE1Yyh5cSVVpXPRjxV1FEWJJO3Jss/kc1aVcZidlVfOJo0iJ6sJRaSy8C5c8KMQ/VcbbEXOidpvTG4j0lQh7aa9RpVgmSQupK2SR51XfxCTuoYODO/Ap9O19SRWzPMCn+kZXRugPN9o/43/CIA50pSur4SPNIsdzR2EP5goKOZeUkOtKUiQSrYHNoUKo6FAm+9b0cMkkgOrQg376OeM7g9ex3KI3cXUkK7vMyOdDxulAs5fnrQfgiyeXztZrZ7pktiBH15ymNnWOlglaticXxwaQpFMN9UamYf5kVRa67qZsx2alsDSQLxg2S5I4bHW5+qNup7NTrliH19ZYA6jBogY9L5VB4InIs/hb+rX/542VIlHpF4r2JXAb7AlbYIoYz28sIbL5Je0jbnYi6ehZRBFdLpjPAHS44l+B1R/FyOwTYDesIic8mFIVG0De4xAyYUIvhTmpZ9RQvoQce5uxgDhDeaqftC2mopcldtgW+OgcX6kkqiuk6gZ0bfoSHzUVbKx1/j6Jg25FRjjLVp3UFztLp/40rQGva5vN0F6AYDWPigoJtIfwSqfCBI7pwQ4n6RyTWNu3gC2vs5sg/6vd4CjuGVboIK14q8c5MyzGP0lo4uDDs3stFlQ0ysC438+XmC8COdN/QlVKWM7+W/yVrKje8VnyWX7jZBcGi1EdyfjbXowlqNTBwdOV84hdQ0tXNnJennA/dSTFZNLAXDPgCqtLjCV4amFZOf817GbUn3Pc9NpyzgKR9xyi7wJlb6gJBeeFBKrECcKCouxqnz/ge9ibix+EfTtbj9vwzDLfvlC5/jiJQfA8b+3hChsflqXuaiX7TxioxeLIEQkZBCS6l6SwEWd+hdlF4WCvksv7skG1pk8yB5GZiiEslTHb14h7FmgU5IYAYWMlk9ZwoSiwj9iilbpLYai
 MHH9mOEP
 JiIaq0YxeiZUSGKMVD3Fpeh5kfKymsd4V/EZdw36f5QtVcYjlvFrp1OeGKtntTlDFhH5i2Ktpyphsff6TJjd6tirvUdpY8lBB7mIv7uVM94RlTtai/idriNUc70PTLL5bB3Gp4rk+jl6asd9GZJlDtK78HY7gOLkccjpdvXf3JuJiDozCMAr+bBHDwEE4HC222zfZe0IfuoGGgO/ej3NsJrvc3rA4ekn7NW0jP/u91SZER/3HnMxm8diIkDzQOv9PSd5/y0dgeStvHiKZDf7hilodnToruClfHzI1Ga6r+kB+wDQCGEFnR1CJ//bTyfUR3GVFXrxM5h0ePBsl8ZNcFS9TcFm2kEHnYWVw/wc3Vtsk/6+1UQx93i8Z9bFxQfpUum3jyaynq9A6HmJOKuH/2tVgz55IOHcPzFEEJBXLUnscdx6vpxY+IehqsLqyrINrN2t8e4GYIYDiONkCkdYx37WIfJpKuGRlB6iPDatp8F8GB3ZAOaQ5ZB6Fl4YF00Wr9gZlESiVRAiDHWfK+GMhWKbqVOb8nBnYeg0GfMIuyukXKemHK34JRM4NFkjBOFJ9NhLfbh1HWffLj6mclLvbnQkoyMGBQWRhAMZn4e8Lsz8k33XYdI9ki1F54s9bLgcQDH8yk16/qjUu/7xj7vcwI+OgqsbJEAf+K+1hIZaxb+MCKzr5BsA/QdZxpjBPWtgV2ETVJBY0m5e9WoXnXa2fwQGVM3qdkTHx672hNJkckuth40g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 14, 2025, Ackerley Tng wrote:
>  const struct guestmem_allocator_operations guestmem_hugetlb_ops = {
>  	.inode_setup = guestmem_hugetlb_setup,
>  	.inode_teardown = guestmem_hugetlb_teardown,
>  	.alloc_folio = guestmem_hugetlb_alloc_folio,
> +	.split_folio = guestmem_hugetlb_split_folio,
> +	.merge_folio = guestmem_hugetlb_merge_folio,
> +	.free_folio = guestmem_hugetlb_free_folio,
>  	.nr_pages_in_folio = guestmem_hugetlb_nr_pages_in_folio,
>  };
>  EXPORT_SYMBOL_GPL(guestmem_hugetlb_ops);

Don't bury exports in an "ops" like this.  Be very explicit in what is exported.
_If_ KVM needs a layer of indirection to support multiple, custom guest_memfd
allocators, then KVM can wire up ops as above.  Indirectly exporting core mm/
functionality via an ops structure like this is unnecessarily sneaky.

