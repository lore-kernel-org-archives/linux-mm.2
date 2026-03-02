Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00977E9B352
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9AB6B0092; Mon,  2 Mar 2026 05:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6B36B0093; Mon,  2 Mar 2026 05:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07C296B0095; Mon,  2 Mar 2026 05:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E96026B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:01:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96BED160B9A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:01:15 +0000 (UTC)
X-FDA: 84500680110.08.A65540B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC2BB40006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:01:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kb23xZ78;
	spf=pass (imf04.hostedemail.com: domain of 351-laQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=351-laQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772445673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjS8FX592qmj/rFkafjn+lojx6cnlsSGWxK3ppaLTGU=;
	b=RGFE5FbIJIZyV/bwJ87ngtiukefanbqERgJZWPBv7ulXZJChnFFLCFP5j1GGpnANqIC2/J
	0Ht8EESjpAUNpVQRItpEuDvoA4KBrmzQxpz0S4OGZl0DMqsHuXlbTz55TalEg7DdFnmKJ4
	YDYlvtckshRTGS3CEq4xiJoPk0Awmzs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772445673; a=rsa-sha256;
	cv=none;
	b=lZhW4CtkUluDpobp8ZTPgUYwLT3hCo0SSszFZiQTBhq8uqAFfNVEJ/QjAJF8XivrotBXcb
	r5dqNtufSGiF4r2I3cuABujdXZdpumXkt/mLgoof1/YIHQtojg7usdpU7P4X9hSkSG0s3u
	CPnOSYin7iIFqj7CGYiYYogQdzK2v0s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Kb23xZ78;
	spf=pass (imf04.hostedemail.com: domain of 351-laQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=351-laQkKCJAu52wyBI1508805y.w86527EH-664Fuw4.8B0@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836c819456so28859195e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 02:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772445672; x=1773050472; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tjS8FX592qmj/rFkafjn+lojx6cnlsSGWxK3ppaLTGU=;
        b=Kb23xZ781Wdpw/1Y3yWknWY+Cr+XSRk687muNTdMRZDllPm7wB5G5dIbKqgsoSZUV4
         t0eL2the3ugV1EQXZUvtoO+i1kuZ47UxJDEhzmLpfJ3MsUQ4mBXHyFM5ctmQkppQuwap
         /bMIeTEsLxTADyE2SNnA1e8VdtDbUwmVp965dgKeXyXgi7YV0wFsa1bhXQlpDoZrTr1l
         qgRXeRtWyJch79/lQrGp6vpeywd/6BKBkpZIoofg/mJjRjCIv453CAi8IZrm908GAXSe
         wB6kMPLK4jBUQbv4r4P+y2lW0ysNPQgcCOSK2ItBYcx5jUNO64t4s9SR8gbo/kzUDfEF
         dNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445672; x=1773050472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjS8FX592qmj/rFkafjn+lojx6cnlsSGWxK3ppaLTGU=;
        b=LTsDMEA1G+IxLKYWC5dAwpaf6C4CkKm6y3Hy+ZT2CpxMO95Dc2U5jfi7ER5bIEjPVk
         N/tb9YvS/+0RNmJ2iPxO+kY3aMqj3TZNkNfWLhpWGXN49LBzt5kElNpMKGX5lVaiXSQQ
         8TnxRu321qxVJTi+3BqFNcsSn5X5HQqAoCPV1pE3QtnKSD1DzIz7ZLmCOi+SnrQcV+OM
         w0wgiRzb9JqoCygi+9c+CRIC6TvNOUCQccfLg1epeEZ/ksJ9EzucDpMGlVWKI2aw/9s+
         79gOb2oAFH9FKZcADR7IU3aDj2Eott4oU3L5N8l7FCUXM9XeRlwr3UV9JHbNgFzdISeR
         rRBw==
X-Forwarded-Encrypted: i=1; AJvYcCVX9iFgVBHSqEck5kdlEpJRetZ2Pgm3sdSr2CO1izIbvMwlC9yyQSO0YsNgSC6AoRv0oiTQ6VIA+A==@kvack.org
X-Gm-Message-State: AOJu0YxiMFyD7i7HIx6D2Bh8cBn5hdh2cgQWYk1YFtDp0C8hx5N+UHc3
	mQOJ/wZdmjB2QACNfdFaEaaX6tm4XtLBFkvmbS2ZszIqOzgccIFUhdim0lpIKQY0ONx+LMkvr8/
	tib9lWZgbMARWIno+cw==
X-Received: from wmbg9.prod.google.com ([2002:a05:600c:a409:b0:483:7827:ade4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3110:b0:480:2521:4d92 with SMTP id 5b1f17b1804b1-483c9c23ffbmr196674855e9.24.1772445671732;
 Mon, 02 Mar 2026 02:01:11 -0800 (PST)
Date: Mon, 2 Mar 2026 10:01:10 +0000
In-Reply-To: <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
Message-ID: <aaVf5gv4XjV6Ddt-@google.com>
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
X-Stat-Signature: t4f3njfrg6ghmx1fdpayjq4uuwxa91qf
X-Rspam-User: 
X-Rspamd-Queue-Id: CC2BB40006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772445673-410050
X-HE-Meta: U2FsdGVkX1/F1ytRx1+ZypzlhH1dKwrTMVVRiDDPj0T0FUyqPW40ZTS0HfnFX8krkgK5XtdU17OUW7ip5M1N6kK9Wh5LqOO+vAzBeqoq5X6msrqudduHlr0XZf5hdUHLEc0dNKReysYEUyzEN7WNwwD2vE7U4p5yOZtWS1+eFoU9b9WxOGeKDRCSH0YwilOW3eKq79aUayI4kM10iODiiZD+tvPM5LXvv5+UFp/Liy0Cql8hk3FvNlE/9Cz9twJXR2/QbTR+7JFMIScz4WzvEuv35ZM8ihxpckL/hP7GMADawbm2Xo5MS9k8U3BxNszrRvDjDkeNPiQnpONzOIBHggPC/6otgSkNJJ8lcCRdMf/DgojdzVQ8GHQn9aXsL5Mn/3GmQzmV4ccA86VIOeVLgJH/kEdv4oLPte4RG5JCChnqX6qKpGXurpMVCcKUrxcMJzDrZ6V4CJOf6Igh+mjUjx+50WdiPXZmgEd3KwJanZbUIpvabnBACn+tHNxQ9HRJfB4JChk5ScSJtFBcSLtbGVzESvlBvtAxI1xK5lDJ1hiCbrfIUPOjENBK3vdFXLWBbxgsRJjn2BOt2ju/a7KjH5JlBzj1dCaiqxb2YPo5X/yJHjxVOzIPGhhcq1WlbnRE4R/NluA/QGiWkl2mTq55HBuewbKYbloSTSWzET7d4dY2eDPSCLWqF/wk/TXhMAnsN/J7vDyN1jikqYXu/GKfwRUQCC7VnkQmFdjVScybgfKkxQNCuQRDszNLHF4oJ0AXaA8XZJO43ycEcVx/xHtOvBwkfe1wv7Y+aDoO8prEwqZx4U7eULjMmqr2KM9wP9lPMQm3NWwXe8cc59E0wynYB3pbbAIw+z7heeBJp4eVu9fsTbXQrlP/o1gzXse+YyLZ2l6kmFNzBHHORjDq5EqkwJC3844I6fxlDwezhkvdMdDWWgERNB04s7k3y746qF3Y66lfnSPuRUsMa4YJ8xt
 D9pGUPI1
 We5p6uQBrtqWUa4dtSlGwnod3BSkurzG7lQNiYKTn6ke5xNPryi5WsTaRcBNXypsY8rXYflOet7bwDUMFa6kYhoHeyTvzUsWa+DLtaokU/lztoL9E/gYn5XyRMRtNyGWeeheqtqhgUIWqO6jCXVz+A9vIwhl0gjruNTL1PZwf/Eo5JylOIVp/AQHupf7RPSav4JsD5DCNsAMyTsjKwra08No6FSS3CkZVnSUw9HBVvjw+wvDwfajwJHunCGpFaTKuDhykysCEfBTM16BY+eOt2mxrpCj4UkI50Ojmd23Ix0ldzI1jD1HYeFFtimMKmfVubfdA/6FfBVLqUg+Y0TsLTqF6xIShiffuugUzsDhw/cUZTRDvCIsf9nLkk0wHYcp52CUSF1bZ8FeLaAM4mzO8Sxau3j3L/UlOEUnlpeUVT4bB+JJJBfPJhpn3vd1A8yF1l0xb8JtBSMz0AFaq5B65TJzqDfzW7UUldy8yrH3vs5rabqBxz0n0YSkmwNzRCY/C7BK3DL0bD+w61UlBToYzYt3dCp4RbJhKb6QlRQ/oFWvSvRv/pEIvKAxUkSYlUCWIvJ/M3x+Z14ocxU37E105y7+On4kfUE2mjaDL898p9XoBbcAucTlqwlHG2hjejw6eIj5qkxZIE0J2tVTeCBZpCC6G3GBEyaj0CZsb+e9pK42J+6cbin0g2NZGQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:18:45AM +0100, David Hildenbrand (Arm) wrote:
> On 2/28/26 13:38, Alice Ryhl wrote:
> > On Fri, Feb 27, 2026 at 09:08:33PM +0100, David Hildenbrand (Arm) wrote:
> >> Nobody except memory.c should really set that parameter to non-NULL. So
> >> let's just drop it and make unmap_mapping_range_vma() use
> >> zap_page_range_single_batched() instead.
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > 
> >> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> >> index da21d65ccd20..b8e59e4420f3 100644
> >> --- a/rust/kernel/mm/virt.rs
> >> +++ b/rust/kernel/mm/virt.rs
> >> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
> >>          // sufficient for this method call. This method has no requirements on the vma flags. The
> >>          // address range is checked to be within the vma.
> >>          unsafe {
> >> -            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
> >> +            bindings::zap_page_range_single(self.as_ptr(), address, size)
> >>          };
> > 
> > Please run rustfmt on Rust changes. Here, rustfmt leads to this being
> > formatted on a single line:
> 
> Having to run tooling I don't even have installed when removing a single
> function parameter; did not expect that :)

Well, rustfmt comes with the compiler, and it would be ideal to build
test changes before sending them :)

But no worries, I took care of testing it. Thanks for taking the time to
update the Rust code as well.

Documentation/rust/quick-start.rst has details for most distros.

Alice

