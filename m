Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91007FED3D7
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023546B00A0; Fri, 24 Apr 2026 11:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DF46B00A4; Fri, 24 Apr 2026 11:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E539B6B00A5; Fri, 24 Apr 2026 11:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D39836B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:55:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99BEE16022B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:55:46 +0000 (UTC)
X-FDA: 84693899892.22.635C2FF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47FA720011
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:55:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3bS9i0B;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777046144; a=rsa-sha256;
	cv=none;
	b=JrFNJ+ZHHwI6z/p2rFC50ZlpPjWTG8EylCrKibEXNik6xby/hKDWgNrJgiZE+tAQwuwERD
	kmqVV5caxJb4BaPbn2C2r1QbLUMgnyLF2KTG1nfUhq4TEMQS22x4IrKcWzzR1ZBoQgmWZd
	Pz1kqBfsJbxxbQdTmREiKQaaj33ICd8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O3bS9i0B;
	spf=pass (imf13.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777046144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLmU//rnAAA5yNF6Ee9JskKj79xD8INjyMeyu+N95bA=;
	b=0ZlbVI1X5IPwB89fiV2P0XN5WnmJCLNmVNDkxMkjVIhW2/jwJ4ZsGpRhuttgNJ6kZFOVJ+
	1F23LZuiPypAgxXd8v1IDEJpzCojOKG3kzlqu6Jbv2E6pJJLT/vmUBJbin9DziP9yPqqxz
	2AtjBZ0lSleADc5WeM3o3bTisuO6i5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777046143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qLmU//rnAAA5yNF6Ee9JskKj79xD8INjyMeyu+N95bA=;
	b=O3bS9i0Bug9ZofHx2fd0fuHbDlAO33JkaEKeTtghMdV85FPNwMYCM0LsQP3jQWrsttYkdK
	5nprh6FwtOJttSQC8oOVJwtPXnqmSQUBKTL5IaYhX7xdps0OYE4CsZxAl5J2Vyk2QmOV5j
	uqcwcRjWMD4mgPe22KwPDt1KTLwwIuE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-dHZIqCmFNPKsY2ORlkti_g-1; Fri, 24 Apr 2026 11:55:42 -0400
X-MC-Unique: dHZIqCmFNPKsY2ORlkti_g-1
X-Mimecast-MFC-AGG-ID: dHZIqCmFNPKsY2ORlkti_g_1777046142
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a16036c90eso199816866d6.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777046142; x=1777650942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qLmU//rnAAA5yNF6Ee9JskKj79xD8INjyMeyu+N95bA=;
        b=W/G09qcJN36TSKCwk83jDq2oeG4TROL4G1Md8HlXPLRXSACi3ghwWCa+XTdYM6GUeO
         g7Oj5cOsPRkc1hjZtlPQHQJp39p5+d5VSVEMqxlnYFu8m+og/zPOXpTngLFNN/eUtvbx
         Nun3PJ/DDANXKxL/CmMUrhdiPIX0af6pqibjlRJyMASXTGb0SFv8K5fN+NQXFF0CUl3g
         /rcNNKl+bTDchxQtFjKY+99qkyd8OeyiYNjbAXW+wFev4vzrVzPw34t6/TDiFQzkH5cL
         l4WdrvLsqngqkFy7WjxuMmIfhG98C5y/x3LMWOBENiUBXj8unLsncwx8vxBvvk4Sa5RI
         6+TA==
X-Forwarded-Encrypted: i=1; AFNElJ+oi6mY7edIU4RtnsCq9CDif36oIDzcnA827xZ17fql53oeSS4Q+rUQpXTLB4YiW5hfDbKUnxAUaQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0PucjseeNrGht7JiFVNx1P8aU6olRpts7uqS8hfbk7MPjbstb
	DPlSOqKfJ0rIL2A2GMLQtSvJPmqyj9WTxc0VtEl9+Jk81jcVOlpuMQ5DHiUBQ53JS54SzOWw/6X
	P05uJ0bxpOGelI4PecX3iK0tW3YKwzcVra2rx0kqxcHw5lT8lnFwm
X-Gm-Gg: AeBDiet9m5eFwSJT3lFLttcIwZfKeC69PhtV3nVaiMrbi7oA2rpuENJ+hFb+uKH5WCc
	4Rv7rBlQFrCBm31tzYpBtvH5sMg6O9nEg7UMS9ldcnlE/kwYBXD85s0UvmsugMdpdTMBb+behIn
	TxM95u/0GVcA9KeXr97KQxUqEr16IpUQkR1bXYdu4KJBBiapoqMHwX9EPzketxf85K68RGq5pkL
	UL3dG/9nq0BcHPY4+3nXW6Hto4rCJRdi3pTMckVpIpZV0i+wkOAXov/IBUW5EEcoOgEYgHyhNCH
	xowKcE619Ksj7hZAS6zXpCky+yQ5Ge7fn2FtV/vcQNTO/g90StVyuyloS1CPuZjhEW45RztZ226
	XuTgtebENEze88CJcyeIgpL9xTZVtaMS0mn/e7uxG+AbRUnKSF89qYdLCPQ==
X-Received: by 2002:ac8:5892:0:b0:509:3cd:b22f with SMTP id d75a77b69052e-50e36b41242mr499700361cf.23.1777046141638;
        Fri, 24 Apr 2026 08:55:41 -0700 (PDT)
X-Received: by 2002:ac8:5892:0:b0:509:3cd:b22f with SMTP id d75a77b69052e-50e36b41242mr499699791cf.23.1777046141002;
        Fri, 24 Apr 2026 08:55:41 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fafe9674csm148150631cf.3.2026.04.24.08.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:55:40 -0700 (PDT)
Date: Fri, 24 Apr 2026 11:55:39 -0400
From: Peter Xu <peterx@redhat.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeuSe0PY-g10KNUF@x1.local>
References: <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
 <aeprnnccJeyHB2rt@x1.local>
 <aes7b17nG0cXrtEd@thinkstation>
 <aetZUOINzfTXChLL@x1.local>
 <aetyhki-UD70dyRL@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aetyhki-UD70dyRL@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aXprHpoZhpkywATSLY3arXF0ZSO4Vb4gPUbsxKsJYN0_1777046142
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 47FA720011
X-Stat-Signature: ytffqfxpda8dbpudm7ma7k5sqity3mc1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777046144-496948
X-HE-Meta: U2FsdGVkX18fuiRjB4UHTbMasBNuztgRSNlDDNxXVhOSf/Bxe6JszXLRWs88TbvqJ0Yhs6TWYXS5nTLpKBwWfB0+m1aKB7BeXvarG0SXaLdMneM4TZwSqb1anqK3aW2tqps2+TT4dA4/TKN9l+4JDJoDzmBr7aUkaRRp35UasPjde4/xFAq97oiAKssqWi8Yt44vMXi7MbLodUtuMYvUG0TghsDfnm4HBcgvdEOURPStmg+7PlpQdSJHkpN1SjLiQaeeIDjbUge8dkiAOGp1ARC0RnPcEe1uigy/9zCkCMjC5bru5gqLDTLKmLBOhFq8IqLSG4xmO2ZeJ4mw8tCki8G52/2JMJQUV6f7jr2pdTuBYwXbIA1HqQ4Zzv023iUP+S0sz2TF4XzASvGkFONa1wWfzWkTPsaTcy5Y+j68v8NyKr8gpUev3Gv8pbKYjEq5bRX6l48BQmrhLsvDhRtDmEeU4zukfnsVmj4d2F47XOlRazYLoUS1QTHDDhazAsc3YKL2eXI/tm4+vC1KmeYSxByH38n3bBCxNoS1cNN7jrDrDtxiRBpumkC9oySekvECq4Hxf0cOZFLl+WlnJf8XvI1ObhGAG2+amK39tMHSs4cJJ3zgzWy1NNw/1uX82oFHoM/ldFvUueTjWplDo3JS9f04NDelsyEPi5GBx3cjQNpDJFQWRT1FXOO/7Z0EIa55xbmcpOSfrMDyfR7xMyiH2tkIRBnIPpgUk7GeMVcDkps1PjD3VmICJ4j6VcN7Do2y8gl1AIuc+3HpSfTi2TIF2MSjPLCDGSGYXNrsdRNFaUN3P/k/+TmgTakB104Lg297jj5Yem3Crrt4p35OlC+mgg6o3w4Hvc2pSemJ5KNfPOWGUzVxFcsYxXgcNWZsGE7PMHxIRZOdDp5mRsdUtgm72dWbglQmSiM/wRQsWX1aGcrL6r5spWYXqwGpZkIcbXrybiG3sXurVMAahti1mIa
 JjOlNjCH
 /8mSMuV23ptgyqa+OLnC0xRbiXP9d0j8AM5JtWzovvinSUWYyCVUDN9+1fgC85GtOJCziFSEQQtgcCVwJNdIYwVm30q4SNDLyLgZNQAWEQFOixR96Hk1lfFBgCZ/uG1toLBJsTM5cnL3DyiR7vSf954vrvKaUTQ9rRTTTVJOYvzUTdZ+Uzyu6fQSfHPafn9qPF/UI3X0Ytt5zbo/w+faorKShUbFYjQbqD06y07N2qSQxuMN+cNOBPiHm/YIaB8xO+/UXLfT02W6WBumBODrVrbFcjlrD8GoHb+9PV/9dhimWPqITj8eBtMuRlBw1IgVkK59BRAUCkzJ6xOjOzRd9jwkgbn+e6QpUc4nEW1TLQHhZNr1crBTEchf0K/a2BhpvC/bj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 02:49:58PM +0100, Kiryl Shutsemau wrote:
> On Fri, Apr 24, 2026 at 07:51:44AM -0400, Peter Xu wrote:
> > On Fri, Apr 24, 2026 at 11:34:48AM +0100, Kiryl Shutsemau wrote:
> > > Both page_idle and the LRUs (legacy or MGLRU) track accesses on physical
> > > memory. We need visibility in the virtual address space domain.
> > 
> > Yes they are, but ACCESS bit isn't.
> 
> A-bit is not a reliable signal for userspace working-set tracking
> because the kernel itself is a concurrent consumer. It is exactly why
> page_idle needs PG_young on top of the A-bit: PG_young is the "kernel

I assume you meant PG_idle.  I actually don't know whether PG_young is
still actively used anywhere in the current code base.

> ate the A-bit but the page was actually touched" escape hatch. And
> bringing PG_young into the picture puts us right back into physical-side
> tracking.
> 
> > For migration, see e.g. remove_migration_pte() has:
> > 
> > 		if (!softleaf_is_migration_young(entry))
> > 			pte = pte_mkold(pte);
> 
> remove_migration_pte() only propagates young-at-unmap. It does not
> cover the common case: A-bit cleared by reclaim before migration
> started. The concurrent-consumer problem is what breaks the signal,
> not the migration boundary.

IMHO it's a separate problem, and AFAIU it was well solved at least with
old LRUs with PG_idle. It's just slightly unfortunate it doesn't yet work
with MGLRU.  Also, when the extra bit is in folio->flags, it only works if
both the consumers are reporting per-folio, not per-mm.

I'm actually curious whether there're numbers or solid proof showing that
in your case the per-folio perf is too bad already to justify a new per-mm
API, like RWP.  It's because currently this proposal is still so far very
much about "let's implement a swap system".  It really doesn't yet have a
lot to prove on hotness tracking POV.

Not asking for a time-consuming test immediately, but IMHO these should
really be solid clues to first justify the overhead with current rmap in
production.

For us, we know the overhead in theory, but we never really measured how
much.

Even if so, I don't think it's unsolvable.

I want to explore if there's something that can still be generic and work
for per-mm tracking.  I believe if we can have some bit in the ptes, then
when mm reclaim code walks clearing ACCESS bit and sees some vma is being
tracked, then instead of setting PG_idle, it can just move the access bit
over to that special pte bit, and only to this vma this pte.  IIUC that'll
benefit from both worlds: fast HW-accelerated access bit, and no minor
faults.

Would something like that worth exploring?

-- 
Peter Xu


