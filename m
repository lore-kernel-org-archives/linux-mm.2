Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65EBACDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DFE56B0088; Wed, 24 Jun 2026 20:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491D26B008A; Wed, 24 Jun 2026 20:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6B96B0092; Wed, 24 Jun 2026 20:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17BB76B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:35:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82D0FA04C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:35:14 +0000 (UTC)
X-FDA: 84916565748.13.5F1813C
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id D323A140008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:35:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GvzrnvZZ;
	spf=pass (imf23.hostedemail.com: domain of 3vnc8agYKCPcrdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3vnc8agYKCPcrdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782347712;
	b=UHToGp3u+XgPDzxKQaZibMLKRK7WLM49ztjYueHRmS0QQXXW78sh6tL/5wZ/bRinR0P0uG
	2W0+tkyKAgthw0NyTsbpZQyFdUx2vZBe+uTE8y/5bbZYX82+WqPsmUuB79FE6kEV+Xvv4X
	7ftPYBDxCQmAg8vzA5qiR8D69cwKR+U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782347712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNahi9jo3ln3x9OacQs1ORbpzN2GfmnsobY71bssZU8=;
	b=cdzThf6zBhyPy9OS6HajX7d8x3TxzwVBXS6ZJ2iAM2hhF0xEr19fQQ97zaafx64UJoVIlX
	rxI19I3pI4dAwXc/ZYCjnsJSfzr5CrIaEPXgolEfS5qNXDEsPb3niYcoGEsrcHP88bg6UJ
	PKGYlz0Km761pzy0hW53cV94VuOGfho=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GvzrnvZZ;
	spf=pass (imf23.hostedemail.com: domain of 3vnc8agYKCPcrdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3vnc8agYKCPcrdZmibfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c7f0d806f2so7364235ad.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782347712; x=1782952512; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XNahi9jo3ln3x9OacQs1ORbpzN2GfmnsobY71bssZU8=;
        b=GvzrnvZZfFfkkHJDkqQicfRbGHBGtvYC8Qp7GWkvnf4GkqXLDMCI5HsJfcav4HubqE
         L8hcJDpSJ25whaVwBMsJZWYNA2r77oIBCZrI0rAbqinHaHJ/9MXptfvEKlOLpOpe0NMm
         qtRSZG8NF64iSUJjMSifAlpSQjdVIDW2VPeJPlb7UjQczk5JEOCpNAZ1NmlNqtegpo1v
         0dEz61ItfxeL8SJSPkOlI9ARInKIe7yTYkdwZedgbolV4vMYHJ162oCtxKKfbK/SP6r2
         JmeZ/1VfzGzJKO3KEEoCHXDIkBPjRo1x9B4+ekav1MgEcDEJn0M1f3CQyi18N/mb1ITc
         //nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782347712; x=1782952512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNahi9jo3ln3x9OacQs1ORbpzN2GfmnsobY71bssZU8=;
        b=PNzUp5s+Vx+Yf5PemzgaIgAwDYBGvS9vcCQWa+fQGuGAEoZUkT8dmwoPP/W/HnIchC
         d6j/l+bh5PwbbtHzw9Dki3cuJfxaYy06KthAewWzl44/3wtsjcXqQdHNy2tU5QDNQCZl
         Ehq+hXtlgJPDu5FpfKPeTw3g77Rz+36osciftnS6/Z4MMJt5NWgc0a1gQScZaLjPn8i0
         gftR4DOBBI/HvIT6OLc8rMyhtCCXfSrVnYJVz3erFODpDitqd2RMp1RKGvRkKfaxcSlT
         u9OrXNaQWgpICZ5R0C/xGDttskHuvAWar9IdVG0r1GbIVFOVBqrgPLc+GHSQwPoqtJ08
         Y0aQ==
X-Forwarded-Encrypted: i=1; AHgh+RoufyN1H4m9ZhgXLu0mo8JuTTeG/ftUEWJ+MX+mXgYkBHhLoIwz72dldCvJubHYA1ZOOJtdzUrJew==@kvack.org
X-Gm-Message-State: AOJu0YzCtNFCM0FRboVD/KFJVtZdVATkpCAeWdd2J2PDlgygJooyqLjY
	re7gtnwKKYlogGQ4xmIGBddbmbr+2lSZjX8hskoWW2fKMmEV6e7U5j7ssV4nEhs57phKqGSalbL
	8oooTlw==
X-Received: from plly17.prod.google.com ([2002:a17:902:7c91:b0:2c6:bce1:2477])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce81:b0:2c0:cf44:3b3d
 with SMTP id d9443c01a7336-2c7fc7579b0mr4179365ad.26.1782347710976; Wed, 24
 Jun 2026 17:35:10 -0700 (PDT)
Date: Wed, 24 Jun 2026 17:35:10 -0700
In-Reply-To: <CAEvNRgE8HZDOnexMJeim6TjmxGG1AUXFY2+HH1YyKB=aM6D-DQ@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
 <ajwMYCSrPlxg-Fok@google.com> <CAEvNRgE8HZDOnexMJeim6TjmxGG1AUXFY2+HH1YyKB=aM6D-DQ@mail.gmail.com>
Message-ID: <ajx3vmNPRf-M9kR6@google.com>
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D323A140008
X-Stat-Signature: 49mhuihmzzfqmc7znk7bcjiic371fw41
X-HE-Tag: 1782347712-48397
X-HE-Meta: U2FsdGVkX1+9866RN3bi1fanU7qng+sIPKHe00koShOmx7Ho81J9/hSMYAnEjkOOOs/w3YyuVvJ0VltGRtz732INOeVWI8LQvW6AD5jOYYo78QbwQ13yPLOQnn1iMMkPHsGw0NRa6LhbNiZZ83U/31c/IKL0w7ju+p2M+Ar/R+tQYgE8lCXxgBAgIH0KySMOl40IyAxU5/6wUESqIJZAiWa5VXgu8B6pxOFIGTL1AD0hGQmCDzGHh4+p41HOaBqXWuSftn1LKXJcSTy+G2mQAh9TvAuDm1i579OvtTFPFNdvEWQ3h/6JXn47bsRCJCLh7/109pdBqlEeH7bcS158R0XZoVICSwNAtg2u+6Niwhj2+RzS5t5QEh0sqGX6fU/y0zaXLroLp8HcGsJEnqBaITK88gyPHll9D2vSpx0WXLpuSDjXci4jHwMkkThYidTvnfDiKPNMVQcP3UQ1C6nVeIy77I6KQcjVKghhM4YZKNqYt+nIFBVXdy0t2rC0teSu9vn5Z2vCUcmYEGi/Ff3EwbL/iJh93RqqCQ/L1UTvzVvgLgInzQIzlvamBQhNWn92PARyQd5hxxpmWKLeP2yNKTzWPJesqXcQX3/v8ENHfwVmacdURx7MsmRa5zn4eUNZfDTigxyU9WP2c+pHiE3zvgeuCXMk/3FMTLcotVgfNHT3BDfT+rMD8h9TRRcu7dxz5GdnQQDEKhfV4dxft/m/y65FQFyKtDe8dHc9jAZkXyXcQk16K5xh/x8HKG3eQ4eu6UIfHJk0bKIz67ypAPtSU9ZPynpt4qkxCluxGhegzUubUpHQCRPXI0k8e1jO7MhHGUTyCyHmRF6KyYC0BPdb0WEeeWWrIDgPsyQe4JvDlgCxF5DGnv+6mrmERgSf6UPPWUdFkcgkJrdj32/CEE8sfgL9sYOonsRNtblGn02oRB49kfmI08tKKoRbP5xr0ngMgXpkcm56dWajhZCk3xV
 BljGxbIp
 ZQg+H+T5CB4TlYf2xfglR8jUuSG/EYqeKg+U5lGuasYnZfgGpWRVb4vzQNKx675UfD7Z89TH/CUksfv3PmmU5hESe731a5iCOkkvMW/EoSxjFMorKFnwMqBldIdb8bSRbwG/ubfj6MMzNZzTvjJPywqm5IzF485siTKRYWNAP9yE8rbQReovqfxGsGEQoAF1nZvqG/Joc60XJWisTPGjZeV7ZsadNQMrtGIGkA4hutRH9rNZ8clQUYPN/MyvPJa/wRbZQd/0QtWnsYlLvoTLuKvTQRdA743jOBqzB2GyVVgDmXbhd5s2M1XxFdwR+HY6QTLvwpA9c/O9hTKrxIuDaFi7/oyiMR2idADcMQBu2XHSFzxQZn1T33ZIJFt3LRs/otHo5f1IAKcGX0SL7eKFSX/7l2l4VJ3Rqwc5RVfnateqTGTaBTDshmIEUGHwrdGcNA2GMgKvwzuNTosBeraT5qJtrt9Ul+n1NAryq2LDRf7C9Jqf8dLfyCoMR3fcw+AcAWNjDwYZHCE6gN+Q7FH9gHJk3zhiWx7zKa/h9iQ18k+b3DkgxDv1LJd3YnR+NklH1sZn3jXCct0r4YENJpD+KWgOUHV6TjDqSd6Bu1kf6/PpzcrlfF+f+E4RtZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Jun 18, 2026, Ackerley Tng wrote:
> >> When checking if a guest_memfd folio is safe for conversion, its refcount
> >> is examined. A folio may be present in a per-CPU lru_add fbatch, which
> >> temporarily increases its refcount.
> >
> > Under what circumstances does this happen,
> 
> It happened 100% of the time in selftests. Perhaps it's because in the
> selftests the pages are almost always freshly allocated and so the
> lru_add fbatch isn't full yet? (and that the host isn't super busy so
> lru_add fbatch doesn't get drained yet).

I chatted with Ackerley about this.  What I wanted to understand is why guest_memfd
pages were getting put onto per-CPU batches for lru_add(), given that guest_memfd
pages are unevictable.  The answer (assuming I read the code right), is that
lruvec_add_folio() updates stats and other per-lru metadata for the unevictable
lru, and does so under a per-lru lock.  I.e. we don't want to skip that stuff
entirely.

One thought I had, to avoid the IPIs that draining all per-CPU caches requires,
was to disallow putting guest_memfd pages in folio batches, e.g. by hacking
something into folio_may_be_lru_cached().  But due to taking a per-lru lock,
that would penalize the relatively hot path and definitely common operation of
faulting in guest memory.  On the other hand, memory conversion is already a
relatively slow operation and is relatively uncommon compared to page faults,
(and likely very uncommon for real world setups).  I.e. having to drain all
caches if conversion isn't safe penalizes a relatively slow, relatively uncommon
path.

If we're concerned about noisy neighbor problems, or outright abuse, I think a
simple (per process?) ratelimit would suffice.  But it's not clear to me that we
even need that, because there are already many flows in the kernel that allow
blasting IPIs without too much effort.

