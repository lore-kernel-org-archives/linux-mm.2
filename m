Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191E7C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F1A6B008C; Fri, 21 Aug 2026 08:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045DB6B0092; Fri, 21 Aug 2026 08:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E9C6B009D; Fri, 21 Aug 2026 08:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1DAE6B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:30:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5927D80457
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:30:14 +0000 (UTC)
X-FDA: 85125209148.18.0840A4F
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD00B18000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:30:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkx4NayF;
	spf=pass (imf16.hostedemail.com: domain of 30ESIagYKCNUJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=30ESIagYKCNUJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787315410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0TDZ3//ZKM374BdreK4yr9CabYhqfPGunU2baHmMPE=;
	b=4ya+ys8sasWY1TwooRpzlMbBkSMUI/Bq+zCq9WUKOPxgZW5AsTzLykL/LaVvPe7ondvTW6
	ywDPfMISM5NcbV8xDZ/mHAuGwExBbtAKseJPC6ktD1yeK6FpjY/kuBuG0QL1gm/Y5IbD+e
	zPUWOe2incPzfySkNUeEObGzKT04jvI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vkx4NayF;
	spf=pass (imf16.hostedemail.com: domain of 30ESIagYKCNUJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=30ESIagYKCNUJ51EA37FF7C5.3FDC9ELO-DDBM13B.FI7@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787315410;
	b=clY9UUxfrA6IdwrC3JAbE/uduMdqbGH7ucwuoSzkcwdHdwo81I5Fx58u2OdeK8uTvityyX
	QFTGs8FNGI3yoxNrmkJ1y2YVcpJZkoYY/vqpbk4trEE1FPPZcN5IfJAdh3qG9gxBrKAZ4y
	eSaDVFcblGAacy2cnlfNIHHIxwNRJt0=
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84f0d3ab2f4so704869b3a.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787315410; x=1787920210; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0TDZ3//ZKM374BdreK4yr9CabYhqfPGunU2baHmMPE=;
        b=vkx4NayFrliwd4ao+gGFKxKnFpg3wyvv5/Rp7XqZcWmTKQ6OsMCv7j4z4pMoa7/uEW
         cbkCeIPQFzhMBXAMkcH+EWUyR0JxLE+0YLM0Kz2Rb6LvjixWgPHWwVEIr5OpmaPKLMJo
         kUkaYVZcD03ZfaF+k0lGK8vM49L930SmavYj4kf9DqONtlN8f6DoulmI0YCe9JY8abu6
         4de+pxCC5CVGPEyUEd3bIUPKTOaR2/odQmau96YuGbRB6bh0CQgLCkaWeZ1/LiUnFUWW
         knxJNkNEyd3uLUO10HFzAC4qLfiZg6E/8O8y1DAw4JE2dEy3zFypIoCXglXeE84lp8A7
         /i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787315410; x=1787920210;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0TDZ3//ZKM374BdreK4yr9CabYhqfPGunU2baHmMPE=;
        b=O8u3WhF8h4HLZXBLICSl+ltZw6JTEiWJAoJXZjvRNyeXAhurH5vYt22h2h/MYagAdv
         iiAhCXoqdZCjrsYxIWnBCI6bPaUb4CtBAeD78qfEVSEUy6i1g/rxj91ORZxI2jVrsffh
         L6hdgrTX0eutYyuVp4r7A7x8LsoQUBQKzvxKsl/jax66zqBUPUrwWKJMz4n6p2khaaJn
         OZLgNUVJyJ+MwdXdg1PNV5fxBZjlYMtiHikKE3hgLIKYPEDlui6heGe8DG9IwZS2XrHU
         CdId5+cnuE2jOpuzQkyrMAJCHSfOSX99b24ZPZ981KGLSvh4CPzuuD8ez8cwEJmKqLB4
         IYZg==
X-Forwarded-Encrypted: i=1; AHgh+RrJZzXS6IiV/1W54cIDbi0T8YNF08fBwW3NeRw6bqxScLvov4mOToBm+tR2UzmY156fyDSjkiO8KQ==@kvack.org
X-Gm-Message-State: AFuF++kweIlKpyYc3St3wkswUbUR841Bt8xzWBau9beibgUzuSTJVw8/
	Vye44nKzXfYikuaNl/+WCOe9d24DKYSoxTrFPPByREYK/Q4qWZZ7WnMzFfy23FvXHLu2N6wAOei
	wxkpAkQ==
X-Received: from pgly12.prod.google.com ([2002:a63:180c:0:b0:cb5:f989:9b3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ab03:b0:847:8acd:747c
 with SMTP id d2e1a72fcca58-851fa01e93fmr11460030b3a.13.1787315408882; Fri, 21
 Aug 2026 05:30:08 -0700 (PDT)
Date: Fri, 21 Aug 2026 05:30:07 -0700
In-Reply-To: <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-40-2fc18ee6d3ba@google.com> <fe1c6359-7371-4ccd-9807-1d81c160d12b@intel.com>
Message-ID: <aohEz_1JFVDtlSnE@google.com>
Subject: Re: [PATCH v10 40/41] KVM: selftests: Update private_mem_conversions_test
 to mmap() guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD00B18000D
X-Stat-Signature: 1x1h61okwx3rqecmjp8tydgcit4jb4d4
X-Rspam-User: 
X-HE-Tag: 1787315410-227806
X-HE-Meta: U2FsdGVkX191hIULZzUf4Zi8zWkq6eoE6dzjkk2JJYsyzXgOZHDpDlBRp0D/vMB+1kZ7IlvwN4pGFVN+xk64BQTZThJVOTlRywX1gtGmF8GCv1oVZI3PhhBI/xdn57jIVZwcXGMJkJGG2aB1mEKVV6LT9qX80Eohyl7p18P+tEvdUGcqlLT/3MSMfv1QlEpuf4w5ZvkWVzBuihtbQbG0nx1jtOgaD+9d2vx0czv+IBEVkZ7gJf+cOSaTS2ol6tyM1pEc0WcUdzDs+w9kGka48cZn508eGfRyKAguVFDuqs7X3wDCz14njXhH/mIz33QTVUh9iZ+Hw40Xf7l7Bg6r/quSKJumRQWhB7l6B1SOzvo+7JO/ZghssEaoGSwCtE2XM+5dAv0OKdgmVGTf/pPwpvRjYQIM5G0BL2tsspeED5O0jsU1uZp9ehzIOv6p6PpTN+5ejxzZqTbthsbmJCQTTTODNwqoPNhlEJZVxVFqyWhMuSDXJ6xnZ8/XACKkEcKSAmboKaTLqCbcHWaYsfD5z4l4USlzBiysojQ1BRAdw5GWdMpGaO2lM8RPKepxMwVrnt5V5Kf0rFrZ/dA9vJc03iEKstKHtoTa48lNTn8bS6rYSDBoWi5tvncyC6tNsXGhnr94V/IisTrWPX7Tjf+tmd4ghIVQa5D8odUMvGQgG0ChQfFwZ3XQ6G28LL8eoaCo5kiiilFw3yx6Igo/YYexL9hXsVTaXBUMK57BdPJClvCbsAtN/iajYdiS943mC+9o6osF/eE7l9qxz+D+GXN88M/REkBK0OXVwlPQ1F3j3L66VklM6ep9cZAH/0bx2H+GpApRwsQCkJvwCjUFKZyInqbmQvC0/PedWksMvGjTWDPhKDQNBQ3eV31R0bLTsz9egtBkA9LYvNaqt9LgAutXUnBk9oWlxH/WAQ9w81RHw8iWCI6yWjOY6tRwRMAObvzB2ykpqyscX1XRMvWXEy6
 Z5CHDFO5
 Fieq0x67YpIEZL9JI0jaR7cI8Hgo6o5PfxvGRAe9tyDgR0nGIuh+HqYUmJuAo4B4U9I4DXMYIxrYy3Lx4HpjaoKqghrEXEbF56Y4npWCvgaWyFWsZgbcKJ/m7zx53WGkN4pDNDIwc07E14hIwq1fH0ipDh1nV/yoPJA2FNUFU8ZKSeJe1Uuvi5jV6ajzq4nYzSlPN3EOE8tJ2PSnceBcSjsNjAuTaPt9yXpWuA5tYBUEkfoB2XdfhZ9E9OVwfVMHFNfBI6+IOnnYBRfImgqEP2xdQ7YVEhiPTKf+gs0BXc1EbzBpvoy03CsWm9kZ6KAAEiXvv6g7qhY6v3gorwbRXFYucmlD+ePujRoaL3bXRE63f/vsFxwxvTxHeZkJgsJ2hpl9115cCk1KzQeym9lOwhL76l5fUDSoxo66tjfIB7eAhQWrZyygUCLeZ+uomsMToeZFvg1vyhu4YwTaIGsdpiHzx/t88G4nT8TeRA+CQXkVNdt65p9RrBVdZ5YKIP4ouvLB+XiH5KkQqcm2L4F8YSp+NJef5aUuBNOkWJnJ9N2iE34W7HaEaR+7xQwF6JVyNdh+5U7Gcqq6dQPSG4fTLBwoCz8fbjeOTSHQUC+1GbEc6B1zUcgXWJUpSOQFtwRtYOO4w3mi9YwTcV4yATSjX5KWz8ybtbp74w+5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026, Xiaoyao Li wrote:
> On 8/8/2026 5:53 AM, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng<ackerleytng@google.com>
> > 
> > Update the private memory conversions selftest to also test conversions
> > that are done "in-place" via per-guest_memfd memory attributes. In-place
> > conversions require the host to be able to mmap() the guest_memfd so that
> > the host and guest can share the same backing physical memory.
> > 
> > This includes several updates, that are conditioned on the system
> > supporting per-guest_memfd attributes (kvm_has_gmem_attributes):
> > 
> > 1. Set up guest_memfd requesting MMAP and INIT_SHARED.
> 
> If I understand correctly, even with in-place gmem, the model that shared
> memory comes from the userspace_addr and private memory comes from gmem can
> still work without passing GUEST_MEMFD_FLAG_MMAP flag.
> 
> Since this model is not prohibited by KVM. I think we should keep the
> testcase for this model to ensure test coverage?

+1.  Deprecated doesn't mean unsupported.

