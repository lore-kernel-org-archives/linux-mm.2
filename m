Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD0BCD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502796B00A0; Wed, 20 May 2026 10:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9FB6B00A2; Wed, 20 May 2026 10:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0346B00A3; Wed, 20 May 2026 10:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 307DD6B00A0
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:45:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E539E1C023B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:45:27 +0000 (UTC)
X-FDA: 84788071494.10.50EC604
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8B3B16000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:45:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JenNrWPv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779288325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXmdRbmYCHoIn3PGJ6dUolIetDSUosv3AORcVct4e6A=;
	b=2zzuqhnlALoivkKrOF48Qxz13oRat4pIcViHav1O6N+zkfTlIctXZE9OXu2oLr/dILh1kr
	17YZIFRoXSOUrACfHRNoXjwnqoOm3fb1gxLOJjkTS5/9nrDHiSKDUD/pen+sA4KuHtMj18
	kOn2DeenVJ2bW8oQebQ++lOpEmx/giY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779288325; a=rsa-sha256;
	cv=pass;
	b=SGEy9l8Of4A+xtHQSNEE6G+B/xEi7ZlA3Ayu6P/O8Y/SL3o5f8b6Te9y9B/tmOwk3z3zP8
	BdpU0DVhRiuiYfEEWUDUaranxbKeXU9iCth7rMaLhiSNpEnudtxvJo+gsXkT/fWM20BEgX
	oThbFb2q5FFZbjJElLKafddDD9phSuQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JenNrWPv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of tabba@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-515548f390fso3091cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:45:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779288325; cv=none;
        d=google.com; s=arc-20240605;
        b=OuBb4Z230YhpHYHMCcFUlVui9lGpO60EL/lAZ50g9fVrLaM1MR9Y8dUYTkZ5RPwWgr
         EoZcrPLV5X2qUv2quVq1hJu3l1VHHP9mqskYmov100Cessw4XwxFPEOH+ZJmo9tgk2/M
         3W3urN3kruFUbzYWLUJVQxdMAsJqoik31HHbz1LWIk4b2yFTR7Fl+KdfeLQq0tbP4kVP
         RjFckKwgVSOc+URo87/Y/DZf2u3ZCZlaJt/FVYd6z8vzkhRObGv64Q4ocCtMKZe6BeV3
         z1S/mn0nmWNKUm0nIsy/Tfi/on+jaM+n6mznVGtkD1xpE28wXDjiZDCRijOA26m8xxg6
         RcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BXmdRbmYCHoIn3PGJ6dUolIetDSUosv3AORcVct4e6A=;
        fh=DCh2SNTtowW9WWfT+Utl7FgfR9fz+z13f4dBDpwMkB8=;
        b=abYjrlfrcWD18nLcbZUM1R3nd/M2JBKvhIlg7gR8j2LoJVMLJad2ROD3VNWv78g/Fc
         pBcfrC2YBMl8PLCzyzjGEoLsL7iPY10NdreZ968kzY4MyTFG1X9wx8JlgMqlAJfx1ulK
         ISfEO5qkbgL6eOb21LFiklb99mi9rYPBSoUOsy9Lb3J+lljPvPiFRL/j52dzkAnY4wLx
         Pv3RAmDiFnICwNqCpheBaYJ63fdVZlQFeUb3ygsfvLSbFvDfy2edjThMSmqhXE+zzjfG
         p/OID9inhKcC4/7LBWXbbdxBaxiD6Th0RSAFFQw0jcPAXwpZkcqy/ZRl0NlxEHEz4ufL
         n1VA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779288325; x=1779893125; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BXmdRbmYCHoIn3PGJ6dUolIetDSUosv3AORcVct4e6A=;
        b=JenNrWPvNnozJpvGkSTgNfxSRA4SPDNvMM6vtDE4eBiiAl3YKVo7iOcz6JXuU9UMKr
         yoslcL+GnIx081KTDNFvr/x1C5BG/8hZo0w9C0A1IKv3duxkK+vxugYvIVvJ2Ulm6pYW
         +2wCyO+o3dY7WeFcx1fmKa0UzxzFpHslK0rCIGC7Py3coM9xKArhZxM9Np2KmYa5YJpV
         jQyY7n1ok2oE1IKVbLvFwz9aVRVIvM6GOYELIs+AqBrfOSVV5fHWKBrSaypbeS3vB/Gz
         HmRGHMmnxdTBogguDGGgYJS3xxLuYIcKEuFzDpgJmivNQUPexHymFAu5wOFVEi97UsHB
         3QeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779288325; x=1779893125;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXmdRbmYCHoIn3PGJ6dUolIetDSUosv3AORcVct4e6A=;
        b=SZsELru1O+0O+XVIS17q8bV8Eb3iC8usyGCOc94pzdCaEtCi2Yge1raBafw9FP8ZH9
         EA3ZsPIFLcHnRQ1XxZGHgYIPITmjrJis/oPQl8DDss9USBTLPqZtTYgAzbOrg034uCDi
         6JqdljBb/F2bNtmN4bjunOEBgLiegF0yPjuBKlxwUSPVYp+5jCDupI7J+H5h6+qrJ8eH
         8tcV0FTBPukNAYLouIZ8z0wScU0BqG1pMH8QR8D2fdxrsPrd8HpzCYUQYPPYy7lSzA6M
         eQEc4i1MOck1s8fjXr+ZkaGggFs+bNUt0ddcv+XhwIm5Kw/dIAN0B4VFB27v/VL6QIwM
         ao/A==
X-Forwarded-Encrypted: i=1; AFNElJ9uxh62VTOUdLHcdkef4TnPEv6z5tTYqsMb5kp5WRreqHMyTyYt2NEcWzNX8Y4QlmTEd4OD+UODgg==@kvack.org
X-Gm-Message-State: AOJu0Yw3LRJDGFZ4gRZQ5RnL9TDrAzTtyvDxgYyN0v1AqYm95NEB9GHm
	R1DhtmuTYeC+HQXD4QidaO9PjuwbMLflQ6IhcAuUkEE2uV48DWEvbPeoCr+TeSXZbykbH3/HLP8
	/OK9djbAU4l5EpvIa3LAJ0q2b2cuU4aSehjEzFWyz
X-Gm-Gg: Acq92OGUNIui8zK4opxWkz+u1wFiAx0EVySukVFxTsBsrXJhsiaE0cslGruCwm7i9vi
	zrmob1mOc859M6dNAv7s0FXe33mhra5r9bq4xYiOzdF9+jgNLnBs7rDS3WKluWrCczhehlsRq6v
	8PDTM0IwN7ZsIa2p696XKju4RkGxTs/KrQiNgxvRH9OPhilSa9t6pvHfUoQyQiGAlUD7Y39AY/J
	Ite0i6mSrXHmpt/IpZcPZhmtbG6yUy1PRhyXSnkuNBNwKH2y1tZCbDQE3wiZgB0KCsWvBskTX/8
	jUSOI8QQLCIMO9pCXzoHQaT7uWnTzA==
X-Received: by 2002:a05:622a:5d4:b0:516:4197:361 with SMTP id
 d75a77b69052e-5167937f111mr20387831cf.4.1779288323895; Wed, 20 May 2026
 07:45:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-13-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-13-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 15:44:46 +0100
X-Gm-Features: AVHnY4KqHADZuRuQJRLOmHo6Gq8ybi2wyD-GO9LIDMQsvWy73n-zAaUp_TqUxxQ
Message-ID: <CA+EHjTzDx01W5Xy=eMg54DGe8-+Pfz9u8XDgfSDiAJYu8MznmQ@mail.gmail.com>
Subject: Re: [PATCH v6 13/43] KVM: guest_memfd: Return early if range already
 has requested attributes
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8B3B16000E
X-Stat-Signature: dzkwbsgpox8kpof9xz6hphsdp8p8z5ay
X-Rspam-User: 
X-HE-Tag: 1779288325-870014
X-HE-Meta: U2FsdGVkX1/aLNth66+j9eEF6xP25lz/e9JG8vHyOO/zgVs9Wy7ekuDB1Dw/+78IfY4hcL7ftSKJHdBrf3gOGrL75WwR0tIZNunDcUpaUL8yEoA/Jm6o0tZm0fk5wQz8bh6aAbjnlAXwOaV6Hptw+EbtotKlZ+IijSPQbCimcw7ak/AZjNabn5EoeZfLRn9e2ZwycQf2pDDCniE5X9LNi4eayuPSXKt3IS6sVvfUCSTNx5ggMAImUZWh+07IjShkzmvms+/Bd4mqt/Q6kn3glS+KQB/P5GxRpYTWWB1CritlOrR8vdmUyKhqzLzGKVK+JFYpqjNuU0PziV/8phCK75ENFd9MVELJsa66XnOvX1BJ5h8QEFBXILSyffaTAqC/lYBe320nBKZOS5/UwKZRd3k70k7J2imNLI/vNxH05YAGh4UVZrcAnF/20yqywZ6Vn1Rovq/sIXCWz3xteT9SO7y0gY9NwU/wej9OOooOtmrZBDGLxXDY9xjbIxkU9vHnFNjllPu6LHSQgUkqGIEFNNsJK6xUoscYlzRGBAF5NBQV44iGs3Zd8gy0GKvjJLQBslzcdLa0FLRfeP9XC27/byd5hgT4gy++LS95LxGE8SV3uTmGNsQF3n365KOo03auRDfU1KNYZVvyk+NxIqkBmVkGrDmCh6F/nvE2mvDTTNXmJp2SHM/FAUurqpagtLate6fWtFrRZr08OQdmblFAC5RLScX5Y740zV/+9XVXuneoCGF1vxJi2KwrjqA+MkCsDwhG5wcjjbRQGtVgP8xKKRKs3Q9UFNL7YI5Vvq/Nvw0W3Q0ItSJ1pq8iACmg6ZZPGSQX/p9ZaDIY0ol/thJynB7H613gaIVeyoRL/xfu1Sbo4PDuLIBQfhRkoJv5kiRy2sc+kVMubUIGsAlpQHzg+4VHZjoFaC1i+dUOqJ+pNQ5ygMMrrZqOBuLSQo1T1YYHpnRjyKoIDuhZyN+Vd8p
 VKLCBXhY
 ACVpXy3Xa3lO1KjH4/XZGrpBzO4f9KpbY7aS04HOlqXlIer4OBw7RvIeD3nKlwfU4ON5qctx6WqG06PMl3AjAX55boxKq/xSjxdMkKxFQuP4Zp57Xs4tXaD+u17QvYO06H4+4ZgCU/EVxbLsF7Z0D6iNMCmQ8HgKT0ojsuPl94diPLPTGtv+s/FRTCf7EsW33h+mORpdJ4Q0B6k1fDmcvDRGjyj92VnsU5zXCBIF2apGnFdg+nZvhVp0NfuQJSFA/8zIjQj2R/5jEhdPGYnLl9jDxKKkHRaNT52uhYm4Dt4QxjJpNS0jQ5IUJtdXO4eZ8MybR4Zj8X6w+ydcaHB5Eo1kE5Sa6FaHJzZQ1qdmY9DwToJXwRcpF7XB8OEfZjD/eOGvDTOaqJEyNiaz/pDHRyUwdDjgdYppsRQdR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> Extract a helper out of kvm_gmem_range_is_private() that checks that a
> range has given attributes.
>
> Optimize setting memory attributes by returning early if all pages in the
> requested range already has the requested attributes.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  virt/kvm/guest_memfd.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index baf4b88dead1f..034b72b4947fb 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -86,6 +86,23 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
>         return !kvm_gmem_is_private_mem(inode, index);
>  }
>
> +static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
> +                                         pgoff_t index, size_t nr_pages,
> +                                         u64 attributes)
> +{
> +       pgoff_t end = index + nr_pages - 1;
> +       void *entry;
> +
> +       lockdep_assert(mt_lock_is_held(mt));
> +
> +       mt_for_each(mt, entry, index, end) {
> +               if (xa_to_value(entry) != attributes)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
>  static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>                                     pgoff_t index, struct folio *folio)
>  {
> @@ -649,12 +666,15 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>         pgoff_t end = start + nr_pages;
>         struct maple_tree *mt;
>         struct ma_state mas;
> -       int r;
> +       int r = 0;
>
>         mt = &gi->attributes;
>
>         filemap_invalidate_lock(mapping);
>
> +       if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs))
> +               goto out;
> +
>         mas_init(&mas, mt, start);
>         r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>         if (r) {
> @@ -1140,20 +1160,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>  static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
>                                       size_t nr_pages, struct kvm *kvm, gfn_t gfn)
>  {
> -       pgoff_t end = index + nr_pages - 1;
> -       void *entry;
> -
>         if (vm_memory_attributes)
>                 return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
>                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE,
>                                                        KVM_MEMORY_ATTRIBUTE_PRIVATE);
>
> -       mt_for_each(&gi->attributes, entry, index, end) {
> -               if (xa_to_value(entry) != KVM_MEMORY_ATTRIBUTE_PRIVATE)
> -                       return false;
> -       }
> -
> -       return true;
> +       return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
> +                                            KVM_MEMORY_ATTRIBUTE_PRIVATE);
>  }
>
>  static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

