Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB2D6D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD166B0005; Thu, 15 Jan 2026 16:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3309C6B008C; Thu, 15 Jan 2026 16:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212076B0092; Thu, 15 Jan 2026 16:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3BD6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:47:33 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B63E21A03FC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:47:32 +0000 (UTC)
X-FDA: 84335535144.22.5D04C1A
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1325100003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:47:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gwj/0bG5";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768513650; a=rsa-sha256;
	cv=none;
	b=AfyXLhyEAWSwxgeTsTyNLTVVIShXey4gST5Oxp4U9B5quwauco5Zmzf0khmjE7zOJ5y7JY
	CqeodLn/KzXTrB0ePvFyJqFmXm/GXpf7lOgrzhVfBM4daGOsG5t5RNMKSu4E0QrzXwkgky
	UrG6l9I8wi9Na17QpJazmYYLtKmw4z8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="gwj/0bG5";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768513650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBmCHfpLlL8iGEYc8icjykZfZHQFfzihdrkSCqexEsw=;
	b=o28vTL5iRiGnward7qGA0cClNhVQ0UTQqfBRgdm78INxJBaXs0N45XHigMkB833wpoBg63
	xEOO1UUJPc2NNp/GEz+ua+5JAaDuBB2YnoVgIgYI3kPRMczksbuMJZnT9pwFMTgEoIwNAO
	S7U3SB4e4QvBwGjmojSFPF7lHg/d24o=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56367b39e3eso1678003e0c.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768513650; x=1769118450; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YBmCHfpLlL8iGEYc8icjykZfZHQFfzihdrkSCqexEsw=;
        b=gwj/0bG5grLrEJq9uQJ0epQ6m24Z5D7mdYrbOWCF8noTgutRaoKn2wFpChEqrav9wr
         aYxc/V7PiTEpTA8gcB3YsO0y5FQsT/hbooK+0VWHvr0f8GUU3xcwKlQesho+k4g0O12z
         Wp7EDxgnKYHdsKUIMMCzE+fqEvb2j0z0LldS/d1S5iEbIRSimTnSWs3MVR69e8kGpS8U
         O3dJPEuviXgBzke8G+iFXshjueWrefHjh2bghDfdSgDosBFifRkT5nEGQmta1ipWMgwG
         ANX791Bl6wqrsIvcA4KdhUdLf/5tbIrR99FVYcNuSOE6qtBSX4HJuCX+J5BV7fdHTfUz
         1c6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768513650; x=1769118450;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YBmCHfpLlL8iGEYc8icjykZfZHQFfzihdrkSCqexEsw=;
        b=k+m/e1hPwxzO6dP1zsqRoXv0TC9ZEXZt5D9p1Q2DQ4b06klOFOfWsDGdzZ0vNLc/zO
         HSqQkdBEzvARu1D08voWMpkuvINVdthuyj+5YyTdi9a93n0aW/DDnjJ4vHZhFchSUCPz
         u4YUT349ZRjB6av2SwSUzGQYT6GdgzTQ8DyBB1cr1sWDCjn2C7KiX566Uj17WlIJbd74
         r1+S04ymNDu5AD6mmTBJaV0QxjwTRyUYfzgsTMa0Y1tIfhYZg84E/bK4oBvGlsQlrAkW
         PbKjyBmDetY4vUd4CiexxP4kf/b7JUuml/CiBOgTg23uFpymYETh+DTDjpo7uy11u39w
         9Zeg==
X-Forwarded-Encrypted: i=1; AJvYcCVUpcBzkKVev2KBSp7doDaZVDYdTAwKYiwPy3O584euX926b8PqhNEyjlf9rgcC2tRAWrTvaYwpLQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6aaOkW/zFk+3YL1BLOmb6IrTcJ22IMKzGJIAVP8oWKXS4vYxb
	s5sCX+kJLC1twjKKjUAwef3RNywcp4kt9lnaIQyhw4OeVZkfuzFUYb0uviUeYYPuxwt4GEuZsor
	BPUvNSA+TmSiC0TzhyzNQmDVKfqJ8o3vi5epXesvV
X-Gm-Gg: AY/fxX6w6Ju3GqM3LkP8UcNrrqFvJ65T4TnUb1Nz+SOL/qs0/OLaETvc+FNbmidQpE5
	0pQLeCXrbEeKxIyiIOuXN2B0XYbhfmis+scFoaCmg5APQdPkFkzzx30hHAPiTnpzdA6f6zZT4jL
	eKiL8xXCBl51mWcFo5XLOC0lOIl6gHkdbHy1A5kVQt3cVrbDSQ1OzvrFeVzfC1frrof+o6NoZZk
	dPUeYTrHyi9s8Iz+k+UQx3f+8vBpcYbRgKQ65LoAKfYZ+KSyWREroWBLgqKKOiNqrhrciDbh92o
	nYsq9x2kEse54Ak1rrJkdPIWBA==
X-Received: by 2002:a05:6122:500a:b0:563:466c:2 with SMTP id
 71dfb90a1353d-563aa9aae66mr1528951e0c.5.1768513649399; Thu, 15 Jan 2026
 13:47:29 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:47:28 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 15 Jan 2026 13:47:28 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260114134510.1835-5-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-5-kalyazin@amazon.com>
MIME-Version: 1.0
Date: Thu, 15 Jan 2026 13:47:28 -0800
X-Gm-Features: AZwV_QiX95-0WFEZIhu3a0jzKlg7ft8DnUjTu2uxi7sdZ3xYcaUb3m6pe5q87wE
Message-ID: <CAEvNRgFihTZg_-R8yEytDLVxbiF34nFgTEsghMp6tzBvazVqoA@mail.gmail.com>
Subject: Re: [PATCH v9 04/13] KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate
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
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
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
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>, 
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, 
	"coxu@redhat.com" <coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>, 
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>, 
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, 
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"pjw@kernel.org" <pjw@kernel.org>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>, 
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1325100003
X-Stat-Signature: fcsa9kaw1nwa4phcopiss9kijjakizzp
X-Rspam-User: 
X-HE-Tag: 1768513650-504427
X-HE-Meta: U2FsdGVkX19/JAQ/Js25WAzOVBwud8groFyRwy1iqhTjJ2sBVeMaAyxx2ylEIV4+55IbuVDSHfcSVB8NJdl016riSJGvkatup/7f3vNza2d44X8XU5p5+lwpCGZDy36Xj4hTJ4UHUVrxMQyFERZUpw9EnLwVql+2gKl5YZKuOPNH0KqSzzMNWWwCpLx2i0VuXK9AOfabD24WBcODZSTtj0yziW9Yniir8l7WD9oIfc5xQW9uNJj5ypIl54P5LaCaRk0r6XajFZRfpfAdqIMIXLEkfzNCBonGnrMxo7R8T/I2ijMJDPd9rKFcDYzi7bCud+JvsvAxSLTz/zj+jqJGm9/pXbzllVQWWv7DTocGdLMUl5sqX9vmzkmh7ui3Pfeduj1eE3atqLNGkb6rAexgarC2jkpciFHsdj71uwrSELvMlQqKVrwgwNLygiHilqvMQ2DGtrlb7TBM9USwLjU7HYFeVSDojUBBfi+N8utX1UySSg6MysqYJgS5rmN4OSovM6rRjwvpBUKCItSFWGp6InLtSVeAOjXP1dh4BIr/n0mX0sjGrgjnNA+nnI8xMLNzrG5cOV6yLOQoKCE6viIds4XqHfdOi8sObmS34bh18okKpy+5bE380fw9O2Um80dERkq6/tfLHAg+FUZrct1kUcwAzECAzN/vKT5oxQmTruRT48ntIjr5jDiNH7T5jW7/KQ5Nhz5HaXTNXSWNcE0/5XOq1ADTFz69nbH+tpE+B0by7HpvG7GblbwAmykDIrTpTGgE66Vxktl5w63GuTuIU1wNYHv+lYS+Mgcs0Y9TIePzrAYc0otahr6o/N5NT3DvtZ3WcdzBOmJ1sq2N6Qbnl0BkmpaBb9aSYMMgtoY2gQdtVwzYDatbRzS7HnQqZZuMy/2RbZFySG9NUT+ddlij+aFMO9WYD3z45arHmBejUgnCa/aoYtlj63fyc/FstogAjdHb4YJhRrR+Y/yGRrp
 TGZ/BfKP
 i6a6s7FuYy9EudonJuEVDIGwk13y/Ubo3AOdzD+GWRjE0rnSzTg9cyVESvTKhUs9XOSlefYk83TyZltiqjOiFEfWvfYas71P6XWsdr25Tab9pzxurLeFrRQp9lX0Ld6y8e0S+wgXXuWNj9jDzRYI6gWDFp9oTaaEb8cdEAHjtMTDxwaQUgddHk3/jxsVF9Gbc2MjFp0wxsuSPiAfSVxy38LeMzQgVQXJtDJEcCso9oK7WfqXE5/8Qeh29NY8WcuOFbNeEoaX+fhk2yorDnSWsqE+y8EIrIGU4xLqxEooNdmWkS54ntqqz8qLWhiZSfLSb+qdC6Z1rTL7DLn17SQEVkOb11jikRnFXKNz2OhZ96ngP3GOFe298jqMEdCFWVXtfwNLRCn932kyT7Plf9IC+4yqM1WlATxvip5pXdPxozeImTc39qehkcYBfSSJZdRCYt3MVHSPdMoBO8f4f5OhwNu/kv+F0GXJMCjh/g0lOIrQrhl0lPkL4jE8u/8RPuiWajbbE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:

> From: Patrick Roy <patrick.roy@linux.dev>
>
> Add a no-op stub for kvm_arch_gmem_invalidate if
> CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=n. This allows defining
> kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using
> guest_memfd's free_folio callback for non-arch-invalidation related
> code.
>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  include/linux/kvm_host.h | 2 ++
>  virt/kvm/guest_memfd.c   | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d93f75b05ae2..27796a09d29b 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2589,6 +2589,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages
>
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
> +#else
> +static inline void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) { }
>  #endif
>
>  #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..92e7f8c1f303 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -527,7 +527,6 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
>  	return MF_DELAYED;
>  }
>
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  static void kvm_gmem_free_folio(struct folio *folio)
>  {
>  	struct page *page = folio_page(folio, 0);
> @@ -536,15 +535,12 @@ static void kvm_gmem_free_folio(struct folio *folio)
>
>  	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>  }
> -#endif
>
>  static const struct address_space_operations kvm_gmem_aops = {
>  	.dirty_folio = noop_dirty_folio,
>  	.migrate_folio	= kvm_gmem_migrate_folio,
>  	.error_remove_folio = kvm_gmem_error_folio,
> -#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
>  	.free_folio = kvm_gmem_free_folio,
> -#endif
>  };
>
>  static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
> --
> 2.50.1

Like this change, thanks!

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

