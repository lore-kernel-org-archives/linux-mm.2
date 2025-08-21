Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979DDCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7AD8E004B; Thu, 21 Aug 2025 16:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50C98E0048; Thu, 21 Aug 2025 16:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FE58E004B; Thu, 21 Aug 2025 16:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE6BD8E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:24:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C5B3C057F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:24:48 +0000 (UTC)
X-FDA: 83801893056.10.F554ECE
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B9F61A0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:24:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HFiuK0GZ;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.222.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755807886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
	b=dkUkf4uHVb+CSdnvgsHbrElhIYtCwDbBjy1ZTj/ZFC2QwUoWmdiCLtP0iI0/Vb1VOZ2aU9
	viY8LcIyBCYDKP0j8/FLdbuhEK4+viKLYj2R2o3ZvMZM5jb60ynaQt27FPm1cDlgXgQErJ
	npmacv0zEGAJZC2qn7sNjGd9iH8RqgY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=HFiuK0GZ;
	spf=pass (imf19.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.222.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755807886; a=rsa-sha256;
	cv=none;
	b=yXCZZTlZveE87xbw2VhPSkA8GWGk7ckbMfNhT+dqeXgNF0R/X21vFwSBFjYIb3Zp403nLz
	XB8gqN/XVTcCLpR+2qKKJzB0u5tU3GFBTmXLYAFltevYu1LMuNb9aDqqUvGyUC/1eq2xN5
	Xg9erni3BfkfIBLfyD3cBQqO7WStYM4=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-89226ff4772so106496241.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755807885; x=1756412685; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=HFiuK0GZWGlakjvu9k5+0uwQv1priGG8EaO3jtTaEv+Mh5ke7fuZf07KFiZZ4Elu1L
         QWwexeVpOzm46hp3KnnG5L+t34xpuM7stGKsJ28HFQSR0Ux8OUAgwGqh8jaVS6kpF4Le
         mgtpCHCpOOf7r5ePW5ORmDNtbUmYULRWQGQho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807885; x=1756412685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=EoV8CF+FPpm1pjYtaCG5j939gEYsKOsr3LraDErwiXWD16GyuGoVmvADkoBb8fRBW8
         okL2vSlT1buZdw7hLNceRGAxqxkNuAwNJtShScOQmzc4te/+lYyc+ONXbzDdILe37D+V
         FdDuSCqvCYASBCicgqbWH3ycMqdf/AfWa3bhzln45p708Jw4KQRU09cvnoCQQjDGTfmn
         VZrlE3OtwchkvUiSYq3KV2aVXbKYIDX3a53J4A7onCVSuzMouhSaUtdDVQxRZhYuQzZZ
         Z2iS5V7PAWHiGEQbnKZoCNaHOEZaqPJqMKBfpApmU9klsm7Bz3OBf8a5fKMqayn4S6UJ
         PS/w==
X-Forwarded-Encrypted: i=1; AJvYcCXJuJlMBLjR0PxKq8iRe5wmyfA0PRJ3h1hRVOR+PK1/xsj4ClsXgdehXOxAw8oTGQW7Wlorn99Y6A==@kvack.org
X-Gm-Message-State: AOJu0Yw3QfegBxuPmEY14dmKR4y1u907Mn5RXEp1welyMmX6uhRosSko
	v0HA6CC9/JLpyw46SzzL04vrOVX+GN96i6ZclAsu747PzgtinAItVokBMnpKSPUzWMG8LivPES1
	iHXZeJns=
X-Gm-Gg: ASbGncs0qoAxa6EO7hshAAVuA7gOPXT+hPT/XIn6beFekiqLOva41d/pJvg8+5sXk3D
	s+pIFr1ymqIjOSHcFIQoKQdnbj/tRAx/CROb9sNgffvuE5rozGZsfLBeOaSLHfcI0WWjvTzPZ9x
	qrIYgWz5pSYC8+kBBCGr0/l0tJeoQdbR67GH9NVtqGnSaaurdENol4lxHF8kxITrWV4tgCk2u/J
	5mIhsOxcWFREwafSjKVNIdPIrOEg2/Y3fYJlrTtnCx0CrbvcClBdP3cJWJtqQdwZrl7/+cv7myf
	RSgDRFzKl6N//22abnHwIV2Rw5IZLwaqp5OpzjKj1ySn7kQQLUGDWIjvuEsL/xkmhs/2TW5pfpp
	YwCDZnJR1TWuUJPFEa9InMyDgDxfLsM4BOO7itoTErcHyMuXghIn9Bci6pU+GJ4sNFt9VVxCn+t
	03
X-Google-Smtp-Source: AGHT+IFEvsJDsK/JTBQ2ctPTW1hH8yThwbNpQxX9Upg5QbrsLCVE9mo6RO3Njqg6dSR2RLYiEaaBvA==
X-Received: by 2002:a05:6102:f99:b0:4e5:8c2a:fbee with SMTP id ada2fe7eead31-51d0d9724aemr200530137.15.1755807885224;
        Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-8920dd0c67csm928473241.10.2025.08.21.13.24.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-53b17534eeeso554913e0c.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:24:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW5DCCQIh/txLvYQwGPP6q3Va7JnZvXSNYhZP7CQOhgKZk7FSeEAY8Tj9DLhLrsn9QU3cjSHy0u0w==@kvack.org
X-Received: by 2002:a05:6122:1ad2:b0:53c:896e:2870 with SMTP id
 71dfb90a1353d-53c8a40b923mr212315e0c.12.1755807884664; Thu, 21 Aug 2025
 13:24:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
In-Reply-To: <20250821200701.1329277-32-david@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:24:23 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
X-Gm-Features: Ac12FXxaZhwn04a0gbwY6rjh9UGLxnRlGOG0Jy0WjRbVAG0UxLDqNy0Wydj0GQk
Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 4B9F61A0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p3y7dmbfn7pe79pecy74cze4f3659pni
X-HE-Tag: 1755807886-324225
X-HE-Meta: U2FsdGVkX183OE4CXFtkNlFgp26wKW5BUJDg9gRmpOofgkOvUu09Hg78Nu04M0xo0OL6nEEvjArP6YHffDlclJDi+iPJGammbdg6bs4Jz8eWa2rE2qBWzOT+tldjd8YMPAxoKV78UgaktG9AbWgncgVLkc+btOThoBM5Co7yiJZBf1Xz0zbi4KDPNEBoV32hmGVXHHKz+2FbjyY2QZUshvtFEokPs1PpvDbnLnXUAFF9QKDgSPERW2ACQ0AjuCxmpduhk+1lHu4wf1Fd3Jm+4uMIop+JXbtHrLknH9wHZ8TcYhkKFtFpYfKzFe1xrXRU9IHgIqx2PiRDgFnWRlo2wPyKrY5HuxxuNI/Q3kE5b9vu4zupqnEa0dMmZ7Fj8daYx0Nlqfou+JrkcweS2DXmTsXZuQ7lGzGn0qJXTkWQfQ7IJHOOvPsrpCog1JcJHYOtOGAr0qZFXGzXh2iJ1ijcQnmIC8Q/7EoSQWhZh/paXR+Uegv5BX/vUu2Ld0kvrnjlkJV4Q8lxwfVJAGr4/q73gvipLd/jHplQxuI0mH+fPUrFxxoqYM4tTZrilSIHVduWnOnGlq6a1YMipudbCwU/hDrFwpj1V6CpF23KXXnIzZ2D2MT10vyBXbJmP7FQDjd+h+bblGywGWj8r8hRCZjpJ/ybssyMu2IOPrEx5QdLDoylJZi6OojB4oailBrG7bO/hik4lFsosBXD4bLg/UPyE+7C8kygY1qSjSlP2ONBdCJa/R+MaOhHPGulDwxfELG+lkZFOq/uUKXn5CpUv8BB1a1HJXCXNucz9jjNZvN+fuBu4QeF5PK8X582vc12D6ZrtCyg3rygOVWyx4cetXg3+Dj09BPuelfC3jN4Z8ZaH4P3VyFlcfgsqxoJymASCi4RgsjPh5JFpsy4nH/O+W4DPtm68B8IyqQkWmQUwmjJW00ZGGVd1C5OgV175yh6hFLvLD9T7DtaWI5qkQWM9gd
 9UmHU4bK
 HMX1Q/pOxcBseZ/AHW3kzM4u4s7B5JYOByg8ifPR/P95brET39bCXp3ruyI0VTGfYxuKRmo6PjT+9R/AXhfgu3G6T0AcOBxV8FyZU7esRi+heO9zU0x6lm9h3cU4bROSqBcNfY8vK5hSJ+6tYCTZAwWSR+VAP+OEMlYO6dFhaeuceUX1LeKwd3j9x/mn1uMTYfK5LiWrpJVIbzRq5hRa1Uf4MYcPv3SUdFNmMsnWj+TLtDqNxNJTOKt/XNHr1fgJBIsgdZDVFHfX/99Prg13/x5KZYdxkIZTvk4adK0KeKNSzwEICOuwfuDI9cgM3e10C73yVOQ2J1tGkcUyk9+L6Jpwc/vFPySeZDzeZwwzV6cWbmBdb37Bw+rquD2tOvaT40+mJGiMDDW79960mOPJkUOqa9wFgofRFif7roKOtaQ1KzeXbgXV6tQQSbUqchvhtDQrHQDYcWsHPa8SqiI3fv+zyNgiFo9zgoR0JycUZrSmsgArrbFe7s8PgXp3MbHjlk18jolWmEIqm7PdjfTnqRGULxjFoyQMHsOqhu1fjbto5Im+Jd/nZGiasTnhLkh8L+AKpfcYeb1PhJYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 at 16:08, David Hildenbrand <david@redhat.com> wrote:
>
> -       page = nth_page(page, offset >> PAGE_SHIFT);
> +       page += offset / PAGE_SIZE;

Please keep the " >> PAGE_SHIFT" form.

Is "offset" unsigned? Yes it is, But I had to look at the source code
to make sure, because it wasn't locally obvious from the patch. And
I'd rather we keep a pattern that is "safe", in that it doesn't
generate strange code if the value might be a 's64' (eg loff_t) on
32-bit architectures.

Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
64-bit signed division by a simple constant is something like ten
strange instructions even if the end result is only 32-bit.

And again - not the case *here*, but just a general "let's keep to one
pattern", and the shift pattern is simply the better choice.

             Linus

