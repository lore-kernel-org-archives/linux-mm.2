Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1442CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DA76B00A0; Thu, 21 May 2026 09:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505836B00A2; Thu, 21 May 2026 09:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41AD46B00A3; Thu, 21 May 2026 09:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303986B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:48:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB1A8120356
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:48:08 +0000 (UTC)
X-FDA: 84791555856.02.FD806D5
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF9DE4000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:48:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbEvunrj;
	spf=pass (imf07.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779371286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x8ZLZpFna8QE3sntZWYFYWQfy/d2E0NvjrGgGfpza44=;
	b=Qu/V6NEhWKF7IHHhOGJV69fuW1z56njbU0zTBMXqglWHPyrfoyplfh2Gwokyh3JsXH19v0
	j13Y8QVMoksp7hga4VEr0NaoANGmtRxZhhROponR/32MRu6edoVg8esCXpjv/Y21Wj7gQF
	YxsiWZuXxcvAwMQelTzg4/3WZaATkSs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbEvunrj;
	spf=pass (imf07.hostedemail.com: domain of tabba@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779371286; a=rsa-sha256;
	cv=pass;
	b=P0BogiuceY+AQ9Rc4j78hSw9QNSfb+KriDWj+zqquQ86d+QLc/mb98GHiFOxbqKeLoIVxd
	J6btT4Vg9LCBmanMEG+xvcJnjErnTtSiJQCIftVc4GLR28zLN8/TTJGW6gc4xP3jQo9EJB
	0rfYegoUaD2nX31/A67gwVzUTN+vsO4=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-515548f390fso721cf.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779371286; cv=none;
        d=google.com; s=arc-20240605;
        b=e+U6+Y4YVIWAYg9+RpLjlXU5MlkKuRFHdM4RxJd3gdw9DZ4FMdlSOPKGUW3+EdgABm
         kpjZmbbnUiWv0cjPsPHSWMaLaO/o3A5HM/GUxVesZKlW9b20ZGZgePYnLayjQfcAeRwL
         4nFGM2twI4xPLDsmTlrbyFwy0fa8ICj44ejIZ8t7ekB9sUT5PwAS8PT3Z/7mGYsf01sv
         3V2T5MSWZ7WSHJFZBJgSxPEQ6rZTCIVaRgyyN6/+M/JhrJ3V7/RRrvT3UgvIbVZhci8K
         KQGxGmlmC5IQiSlu6lhIKz/HDu9qrKM2+kpxDxwDqLyrm1QLxSL6StIgHa7MLXi0Dnfj
         Mwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=x8ZLZpFna8QE3sntZWYFYWQfy/d2E0NvjrGgGfpza44=;
        fh=OuAHWj3/wnYT807lQKhrnc6yKyT5vkmu5foz+E6pfHM=;
        b=eAugvR1h0ZZJy3mc6nXaXUvwtKqZNjyoVKbRyaVpqh21/e5WKxkzd5NE4JE6+bhWTJ
         527+RB+NGthlB+VGWVqIjRQKMfXNLQ690/vB2xVBYyBatpi+xGzhwuHG2YywtJEVIFRc
         BXtst0Z1vZbfSSaB6Y0xVMiu5ye2Vq3dfAuS9SpaHLkJJrCrmPIif7RX1RjgVGftWuae
         LcI4s+ZTfOp05xlxM5248ZR+aciMVZD2vBlx0F0123wFux9+2Mu+Q47mub/JzwVoEHo6
         JDG9OjVyULYaiZfZINaLEfQa46qqhdELRfA4v6f42wbYhWIuuR7ZYyuYe0mIZh4Qy81+
         W+cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779371286; x=1779976086; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x8ZLZpFna8QE3sntZWYFYWQfy/d2E0NvjrGgGfpza44=;
        b=kbEvunrjAO2tlXB5HAJnlmreOQgthcDQlN0rAC9PoNBt3S2EJdu+z5QAZVUNjhN4Us
         UssiNRIZz7gF6uuZET7ePbOmODvA2LTVhhzTm/FT7NAL/WbH11Kn3pXMNUcDJRgtr6i9
         NAXAHrzg8WlMy7EhwN8684S4iVt5g2OsplPZy0ylaDm10iDHCsPHsF+pXV0+w7Nz1UMu
         yg5U+4PTa828o6QP6PEyhhRNFKdHavduxqnCRbcdrOIAb3EiexaQgSJHDcy9Ys5J7BcA
         LOZdH1e6bNN1BppIy/Rx6IhmaEoGk6Q8+OSca2ckS/rvcjpD5S9V7GMJQTXmhWGWAuXx
         9Czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779371286; x=1779976086;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8ZLZpFna8QE3sntZWYFYWQfy/d2E0NvjrGgGfpza44=;
        b=cQEJzFJgCXvXNNJn0Jbb+6ltFjV9wPnue3LD68hyyl+4UUT4ZLMV3bQr7ofCodP/FB
         M3ZAmVSQHfnyiXoF164AenGQVBplowJlkBJDlaCXcWfKSHKDWV9XziPcwnWo6dYYGbNq
         q6eJzmyD3wd9Ell/NfGXpCgxAkZjN4HwMuQqyO2VIIIUxIhjnRn5N0+pXtDEqfwanKRe
         V7bXqo1JK1Sw8v3zXqiqBlu4QV1T33JQXJF943YkVg9tDUnDj4BEATgIyVS+w+P62D25
         GiSC5hUMsircymsWFRZBwJ9dVbV+Lat34/EIZgu5nllcM7VhEN4wXMF8YvtXb0BKQdBD
         u+tQ==
X-Forwarded-Encrypted: i=1; AFNElJ/MBtKmFl6L7oaMo1Sz90oRHMHsM2rSNotsdLUqXW8sceGI53NdKyPsqgoqlMP1miH6NNc2cPp/SQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl3y23F5ix99mR+JeIVh+OfFVW7uhuKBvC8U8H2R0021copzQo
	pmQcemE9f/+xUusgVtBaFoVaTF7yJKHCPQIOExVF/VGwrBNgJncSDKIHqLzUPodd/th/8CFeUvO
	ZDiDBFl7WiYdml2sHIza8pqgdePAjbaVaG+PgUF3b
X-Gm-Gg: Acq92OFMTy0Zd4RcHo9qAb6o7PK9454+eUdajNjGUPlyq6f9P3ZDf97jW7l3lV5MruY
	yBrROCLqxZHBg/RQZgZb+A9RuP85KeweeO4IQgbz5ewv4jZjKCcKFb8RdtpaxQi3t2n9wVD3vsA
	EuSxkFC2GgRqoRy1DcjQrKZ9W+/RNAjBqbtejkZnJP6v/l/rI/z0frNm/usQp5wR4/fcqUISadR
	oHfwe/qttK37y+z3sfJP6GcMs2m6TYdD8DtO3Of96LomNgOdOeScqw4Ga/ASnnDuz/FfhyQq6F2
	2l1EddHOENqpA00pHNk=
X-Received: by 2002:a05:622a:9005:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-516c53118ecmr8206941cf.1.1779371285395; Thu, 21 May 2026
 06:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-5-91ab5a8b19a4@google.com>
 <CA+EHjTw-cUM=FrJevtSDtR7K6MwUfGfOx21LMFDn7DAy5bFzYw@mail.gmail.com>
 <CAEvNRgGQvMdDmVfbk42EY_PGN0ybTp-x21Zj+pg_X1mk9iCRtA@mail.gmail.com>
 <CA+EHjTzLCD-dU-euZKgzwyEr2ecPqFDNutcaHm2fCDGA+MHVXA@mail.gmail.com> <ag8JIlHjohAOC3-g@google.com>
In-Reply-To: <ag8JIlHjohAOC3-g@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 14:48:00 +0100
X-Gm-Features: AVHnY4IjTx7kpi4F7EdVLun66lc7vUTNuuJ9Vgrkm1t1onCQ9N7OW44CxOISbbA
Message-ID: <CA+EHjTyF19FPod10EEm3pMaPvsAR6HUXOhtC83qSSqxQ2g1s2Q@mail.gmail.com>
Subject: Re: [PATCH v6 05/43] KVM: guest_memfd: Wire up kvm_get_memory_attributes()
 to per-gmem attributes
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
X-Stat-Signature: 1a8sxp8948fa4scupkt1mjujz5zsqbpz
X-Rspamd-Queue-Id: DF9DE4000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779371286-84958
X-HE-Meta: U2FsdGVkX1/7LBnD1ljl4l9PvCEjm7gSjPWj1gzYGH6pWNT4sROVYbeiNSPl+muRyOeULk7X3O3aouqo7g2lz1tMfuLjOYCNZlvXEsu2nDO8yAQHwga52IQM2Ez+2cNXzIKUUdm44w+0NIVfKd2NKk5Wo7J/PpTXFBg55SKVmlAGnbRmfZ6YFv6WwPj23Vl8floN8zv8TWHOYNW0VLEaAP7Xzl4pU12nSOkLzGHBUoXU5fysRjvslvxWy0KUd5DMa1Xt9OJWDygJnRvrx7OUaYJIYHjNjZu888cVLt+c4NL91Gv5N3rcIf/IsyFshGtVtgelW67GLtmrPMJBlFDeuqAsAgQ9lV2W2Xgmqrlwy9hRpAFq5rbknlKFPDIBT9CZ2BvwhrS9Cl40XXLPTkv3R9yDzhLaIOstGnnlcD/yOJSe40JHNWwkIxLL/8hatm8vFSVSXcGSFHkIwOgDfZK/xCxhQIO66a/wz2SaTPOTqRDODC94Jd34VhmGGUNRruq8+rYqxh9XCLzQWy4kaxU9CsU3JoftH+5oReU6bHTLFBUcUfPS6M3vKn5DVFWORAOzvfYfHkE71El0r+B1TTcGYFL72joIFsO76cZDshsd7b0gGT0sVfkWsZ0dTB5RIXivLPgEHKtx2h+Fhn9N5VIGcJt4SNQ2EgXE1bZW2oa2Sh0WnNY+G8G9zRY+5d5+MuSxr6rITaiVjuqU8Zkirq5FlY73xla3RZglA9+SLHJVtNidXCAY5pRNzznP9r7KlhOBzliRK8Epl9EdBO7A9zjx+K4vdwB7C6l/sDjaioplinFSp4qsDJYT70C4O+8WoyC1Lazw3niDr6NQgpjy1jF78C4KQ6K2S+Y7EBkjuOYouCXe4un5VyhnvsdM1/SP5Y2MVgWQNBMuljDcr5uBstnrp6jv4PPXXzJdTIw9QcU4SyJBuA6UAX7GO3rEkQw5Rw5DH8DTZcWuu6CZckOqwTF
 LzDCTA6i
 nTlq2xhqqeGszSotBxAEFZ/ABsFDFmN3jxExTZlCiKEV+gYMUBii8Bhmu50R7ILvaBMUBprkkCP/4DPkFl53a/PXcDheQQGpeTCoDsz654ch7I52Q3nFpldK4uSuLlrrGLxpWGtrQxFsxedbsxMuCiUQwyykQXMQxesd4G5nI4n5tGjKskMtNWnoiOJ3cljgrQwVh3JVcJP29+mCtseYjNrlr0+s5q7VEFdDlwSKBwoA/TGXznbrdGjmrO69pUiYEP0DqDhcM1PTxDI6qjPZ0xGSZQIR9ts+riDY+lyztyp5kXNQdUNVTNVvu3LbMouic9qHT9Uy4A6fMO1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 at 14:31, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, May 21, 2026, Fuad Tabba wrote:
> > On Wed, 20 May 2026 at 22:44, Ackerley Tng <ackerleytng@google.com> wrote:
> > >
> > > Fuad Tabba <tabba@google.com> writes:
> > >
> > > >
> > > > [...snip...]
> > > >
> > > >> +unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
> > > >> +{
> > > >> +       struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> > > >> +       struct inode *inode;
> > > >> +
> > > >> +       /*
> > > >> +        * If this gfn has no associated memslot, there's no chance of the gfn
> > > >> +        * being backed by private memory, since guest_memfd must be used for
> > > >> +        * private memory, and guest_memfd must be associated with some memslot.
> > > >> +        */
> > > >> +       if (!slot)
> > > >> +               return 0;
> > > >> +
> > > >> +       CLASS(gmem_get_file, file)(slot);
> > > >> +       if (!file)
> > > >> +               return 0;
> > > >> +
> > > >> +       inode = file_inode(file);
> > > >> +
> > > >> +       /*
> > > >> +        * Rely on the maple tree's internal RCU lock to ensure a
> > > >> +        * stable result. This result can become stale as soon as the
> > > >> +        * lock is dropped, so the caller _must_ still protect
> > > >> +        * consumption of private vs. shared by checking
> > > >> +        * mmu_invalidate_retry_gfn() under mmu_lock to serialize
> > > >> +        * against ongoing attribute updates.
> > > >> +        */
> > > >> +       return kvm_gmem_get_attributes(inode, kvm_gmem_get_index(slot, gfn));
> > > >> +}
> > > >
> > > > Doesn't this imply that all consumers of kvm_mem_is_private() should
> > > > validate the result using mmu_lock and the invalidation sequence?
> > >
> > > Let me know how I can improve the comment.
> >
> > Given Sean's context, the comment is good I think. I would quibble
> > with the the "_must_ still protect" phrasing being a bit too strict.
> >
> > Maybe just soften it slightly to acknowledge the exception? Something like:
> >
> >   * lock is dropped, so callers that require a strict result _must_ protect
> >   * consumption of private vs. shared by checking mmu_invalidate_retry_gfn()
> >   * under mmu_lock to serialize against ongoing attribute updates. Callers
> >   * doing lockless reads must be able to tolerate a stale result.
> >
> > That aligns the comment with how KVM is actually using it today. That
> > said, this is nitpicking. Feel free to use or ignore.
>
> Hmm, I wonder if we can figure out a way to consolidate some documentation,
> because this is _exactly_ the same pattern that x86's host_pfn_mapping_level()
> deals with (see its big comment below).
>
> There's also the stale comment in kvm_invalidate_memslot(), which, stating the
> obvious, speaks to the memslot+SRCU side of things.
>
> Maybe it makes sense to to find a central location for one giant comment about
> how how MMU notifier events and memslot+SRCU protections work?  And then refer
> to that in paths where some asset needs to be tied into MMU notifiers and/or
> memslots+SRCU?
>
> [*] https://lore.kernel.org/all/agcbWe8s9lmPuJwG@google.com

This would fix a few related issues at once. sgtm
/fuad


/fuad

>
> /*
>  * Lookup the mapping level for @gfn in the current mm.
>  *
>  * WARNING!  Use of host_pfn_mapping_level() requires the caller and the end
>  * consumer to be tied into KVM's handlers for MMU notifier events!
>  *
>  * There are several ways to safely use this helper:
>  *
>  * - Check mmu_invalidate_retry_gfn() after grabbing the mapping level, before
>  *   consuming it.  In this case, mmu_lock doesn't need to be held during the
>  *   lookup, but it does need to be held while checking the MMU notifier.
>  *
>  * - Hold mmu_lock AND ensure there is no in-progress MMU notifier invalidation
>  *   event for the hva.  This can be done by explicit checking the MMU notifier
>  *   or by ensuring that KVM already has a valid mapping that covers the hva.
>  *
>  * - Do not use the result to install new mappings, e.g. use the host mapping
>  *   level only to decide whether or not to zap an entry.  In this case, it's
>  *   not required to hold mmu_lock (though it's highly likely the caller will
>  *   want to hold mmu_lock anyways, e.g. to modify SPTEs).
>  *
>  * Note!  The lookup can still race with modifications to host page tables, but
>  * the above "rules" ensure KVM will not _consume_ the result of the walk if a
>  * race with the primary MMU occurs.
>  */

