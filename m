Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E719FEE4C9
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 12:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5EA6B0005; Sat, 28 Feb 2026 07:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293D36B0088; Sat, 28 Feb 2026 07:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195676B0089; Sat, 28 Feb 2026 07:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04F996B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 07:38:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A26B71601FD
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:38:53 +0000 (UTC)
X-FDA: 84493819746.11.9831CFB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6035120007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:38:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sv3Sja53;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 32eGiaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32eGiaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772282332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOaqhQImVlbU+bIaPkzVliN+MSpqLdHsMK4C5p4HbTE=;
	b=KYDqZ9dHRZnBpnyn8KV5uhlkT4fDqj66GRarpphwpz82JE18Ilzk33MJHASUREqtxV6fPI
	ARhf5HgF5ZLmr2cCmSRfxdtmJ6L+ds+DQmoFuoZctaT52x3tSZWFxOWobXQNVIDVSRftuT
	ci6k5ujSSjbGY9aR5pCAT8coS6/eCUA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sv3Sja53;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 32eGiaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32eGiaQkKCHwfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772282332; a=rsa-sha256;
	cv=none;
	b=e0lqLWGZzsghj6FzOSii+WAGXtMlDSqgdIp5ZauwVFz2/kYQ7t+bSgDS1cFtMyIJ+1aWzg
	ldEZyn/pFrSv/bDb+9xGlzgksICMR5HsWagpKIaKD3QEk/R2ZAhbXCpbroB+XryI8qiaGB
	1EqVgH9N4Zx7AkMsclUf2s8CBAwquPQ=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48378df3469so19515175e9.1
        for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772282330; x=1772887130; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOaqhQImVlbU+bIaPkzVliN+MSpqLdHsMK4C5p4HbTE=;
        b=sv3Sja53VSPRPtqQiU0nJXqvhsyxtW2ZEx5djUCYWArkPQz+yXafporK0PFXGIDeeJ
         dZOB7l/LgFPUR6j1GELwMRu9LZHjqqnat7sw/hYLa8TOM/s9JldgTZeBn+8f+J493tU6
         v+sjvaH1lrXNDv2HUG0whtk1W5KYeb5w7425UHwTby42GTk4H1GA2JEQcU1A/94eQjDe
         gknc6TzXltNPDb26zsRqzKMm1DhpIF2WtHQ9TsqOj0GcrJCAvG3MVCfb0eYTq4lgdmQF
         jeVBZeCp4JO4pv2gfp8ww4fi9gjLR1nAxaIY25XFH0sgygwu9KPs3H+rvC5m8ropFqFu
         Y54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772282330; x=1772887130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOaqhQImVlbU+bIaPkzVliN+MSpqLdHsMK4C5p4HbTE=;
        b=Mc99T3lrgC5GxA3LP/6NhIvPscXlecIRt2BC4GlpG5kWUWS/CMhyR7Q7VUhTom80Ja
         AFqddMzdeEMe3f03NABpRFHjUXCuXVXSf7xahBThGVoxrsft/WR6CNrTtJBoLJf6mT9A
         OgmfvVap+rXed4Yah+hYOb7H6VSghwqxOnDGD3gmkieI9RsVXs8KYOG3eS+Wgc+D0y0m
         kXt1sIyvC9Pjpywm59WwYRa20REdcwAMQQxv+78lSggDLkGbi/NF/ktSEOLYyt+8ua62
         MPaEo09XDofDt67Z3DW3wbWPSOlfeuWUjLZBpoWEyWwvpOhmIRTA36juYHfrMwipFdtT
         18GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV2MzOnmlfrPH5KVkVXsjwz1y4bSQl6+5OX1u/7hLYuPr5Ok87cQ4BXTieh9o2fDUwzOnUhHX8Lw==@kvack.org
X-Gm-Message-State: AOJu0Yz1VywRjUsCPOYDUgXkv/7EyF+SM7B2zfK/2bn4dlonzFMKEFdJ
	Cyob3aIePkgN0z3mnSe6gCTogp47uO2w69n/VOo7Rp3tRaK+JzWhI4pkztpw3uTJ6wwqIlsE/ks
	jJhmGgzh2eDxXKGyHPg==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:480:690c:88de])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b5b:b0:481:a662:b3f3 with SMTP id 5b1f17b1804b1-483c990c263mr116931775e9.7.1772282329804;
 Sat, 28 Feb 2026 04:38:49 -0800 (PST)
Date: Sat, 28 Feb 2026 12:38:48 +0000
In-Reply-To: <20260227200848.114019-3-david@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
Message-ID: <aaLh2BxSgC9Jl5iS@google.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6035120007
X-Stat-Signature: bo9kerquwg3mtek8iktfs1dsf11aeizt
X-Rspam-User: 
X-HE-Tag: 1772282331-997613
X-HE-Meta: U2FsdGVkX1+YrXewRhqvHfsQp5aquUYaBzmUGfRyIO6RdSv21VvDR7n/oXQ9LVmfCx753yhFlUI/yH2AML65O+dPdyONFWXgjZQYQCemjfd6aAU3KHcMukqqsRr+szusTJscmX7Pkz4+cj0lRJC71oz3JOTKwvBi7+FDaltQ+MLsawX8BVH+0UTB83x3faY0MfKPPfZ6LkMkWotAuuhb9W3blJxyUkNs3XEIoqTXKBNQKg8o1xdwNe1WubDN0iqXvPkL+RPYfNRBUkLxMz+9N9TSxPU17M4CTacuiiKa4etLchwTldgOAxwHHpiNnvOfpLUeUo8uy9u3sUMPqDajHNcwdAlQ4WP9K2VDppoDQELFxsEXpPjRA3Ss4yXgfD3+5hXsbEEImtggP2liidERNcQaBcdCe9w2EHeFOm5OhMcoMlZglTY2A/H7e5xSP331UjXEr3Ay6xRAi7VCF6JuPopCl3eyAado7R2dZhVRHFkI40DQElgDfmWWRzP2lOxskxx53dKT67dZgqciGfFIQT0xzqHVh3M8QdL0cC16yJwB0G4Sv0oRSSp3LG0AgDD9tEDJSv+aMEexpTkNsOt95+yAvlJYswPTqvylOuf8lKB7RH+pqPoKZfAJhs6E4zPPpUHK9HpKNhVaR0UPxYQ7z3qo7XM6tMTBapgarW5IthPlqCVPqzW7/Nl5fXzuaEmR1WWwuLHso08eJBBiArQXgFkP9i9S0dh6Y+/d4PL8g5p2jP0fbtpvR2tpYGedJ3g81RO/9e15mt+Qkt63Gpoa5O2Vup/JOvJeCzeAErS9vnTu6c0HDkCKyrmOJF1DDqbN7Sthq0F4+RsCD9IFx5+a/PkDo8Ikk0dxaD/NITZsT9Rmy8ju9fy15AXqzJEJ4tf4eT3qx497g/GJ75VMtZ7aRuBYuDEEU7rbm8NaSGFFAEolifodbp9BxPK8CkHaYMPYJmEu0FvkPPgbg9VJoDP
 IlNHGil0
 LlZELqPgZ3XcrXA6nb46tcLVrPYThuxNYRwENzKC7DcY3+X0gsz3TsUMR9AeeIGZMc1ThaoQa+E8A14T7ksLSBj461iJg30vqHSKXUyVoJl/DlKNelBK+ZjOWeJmx003yDU23mjeHh/LR8BWy0q2ILTJZPgPmzMDFtsvfQQ1Fr6+Bo/YEBm/hRo9ydSXl9mZ96CJIo2MN/DIXi16JfNnaw+GAXj3WywgBA4jHCXricOiqC81AGgyPN5DEK8wCEk59UWsu6pUpuUKgRwbxB51OhhKbVlZJoao1rsEYN7hW12rp9OJgG6S/LXHcka++gdTvSnYuOOQm3HhAQYWcTuef2IIjYL7RCgyUtdejACNaCoHKzuE0p8mbuwxDpYsyoT7W+sKajdMFW5o5R5G3iEpyZwSdSYbAlKR7lt5BpcCf/Nw+xdQeb9X0qcXsevOhBsWkIrOhaBBtJz8tGgE4D4DfSOusM67tW48ItIRLt0NGnXcHhujGuoy9X28J0AUWKDKoze1r/amWRHW7ZM/Jd0oU0kzs7RMv7W84YA5AWZQVuLCK1xbEhhfj6UV1fQ9gtDomYb2G22XL5XhJ4nW4aWQKQSVOJaCuN38JjY5Yrz7J0a0tN1kS6KQYFihMBqZseTzh2jqpl+5t/S49GPIGqjPVjdfWKl6yaJdX5sBtKXiw4dZM+7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:33PM +0100, David Hildenbrand (Arm) wrote:
> Nobody except memory.c should really set that parameter to non-NULL. So
> let's just drop it and make unmap_mapping_range_vma() use
> zap_page_range_single_batched() instead.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> index da21d65ccd20..b8e59e4420f3 100644
> --- a/rust/kernel/mm/virt.rs
> +++ b/rust/kernel/mm/virt.rs
> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
>          // sufficient for this method call. This method has no requirements on the vma flags. The
>          // address range is checked to be within the vma.
>          unsafe {
> -            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
> +            bindings::zap_page_range_single(self.as_ptr(), address, size)
>          };

Please run rustfmt on Rust changes. Here, rustfmt leads to this being
formatted on a single line:

unsafe { bindings::zap_page_range_single(self.as_ptr(), address, size) };

with the above changed:

Acked-by: Alice Ryhl <aliceryhl@google.com> # Rust and Binder

Alice

