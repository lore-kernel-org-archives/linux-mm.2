Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF32C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A933D6B00A3; Tue,  1 Sep 2026 14:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A696B00A4; Tue,  1 Sep 2026 14:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980386B00A5; Tue,  1 Sep 2026 14:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66C816B00A3
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:35:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE57540504
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:35:19 +0000 (UTC)
X-FDA: 85166045958.27.6052344
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id 23F004000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:35:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SyiYakrz;
	spf=pass (imf01.hostedemail.com: domain of 35BqXagYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=35BqXagYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287718;
	b=gBQRhqH8BNhWbQH5pFMBobW3d4uvaXPTMdIkcp9wRNfTR/MPsm9LVNpfNDyA+ZCkVPNq/A
	+f/FFDyzTTuKb0VArxHWrLI0NzwQ1hsApiXCetLY7M7zyBp+dIf0AXXkyCou744dBe55EI
	mpcMFQRhZuXQIchbMt8xK//RS8wdr0Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SyiYakrz;
	spf=pass (imf01.hostedemail.com: domain of 35BqXagYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=35BqXagYKCNEF1xA6z3BB381.zB985AHK-997Ixz7.BE3@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LA0MtyhL9+n6pP8AlY+vz7qS2JveEW6zRalGa05+rBs=;
	b=XYgesaK8JvAC1B3e6ocp1cWX26pOqXxz1g6iBoRgo/SP+WPRZaHpRsx/w9QfQI8XHo55Kp
	iLuCTHXBSTWDg/cWmcgihKX3XC+OeRbiJykvmih/2lS2Ai3sCFflNKw+sK6LEL+zfS2upQ
	AKgy3fYbgm5LdDW7mQT5vAOHipKNvKE=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc1d85c012dso302588a12.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788287717; x=1788892517; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LA0MtyhL9+n6pP8AlY+vz7qS2JveEW6zRalGa05+rBs=;
        b=SyiYakrzgRBIXplQeIHc71lmAvDv28CjEdj5HZUsWQ1uu8tC+cO831RnpgsjDy6JL3
         c7/fkpRSpSJMmh6mbQeNbizfJPVDdb7W48f6aubTA0hSp1/wh4mGcJ1kmGR9ppcI2CFQ
         T2o/kvNq1Kw01YRy/W5rJZt8NFC76xOZirErZFcOAojfQfbIrxQjJVRkpGEBk7Q6fxlz
         DqiNJq4ZmzRRoHYqYSizEm8ftrx/6BiVfeXNzMAj7rN4pIOANF2YLLCGZ1ufub6lfHIH
         6PKxleFiqfpd0TXH3IBqzIAw3AIFrHn8eIarzMsMBZvAPmIEMWjxfEl3ir2B0d6AyFiP
         X8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788287717; x=1788892517;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LA0MtyhL9+n6pP8AlY+vz7qS2JveEW6zRalGa05+rBs=;
        b=DZ01Cw/36UCVKVPiihtvzmCjwkNQI/ml0e0ubSw1tFm8r8ciJXuE1UZts+sQh5cjyC
         +SpV7FAdDWkYSOJCTEO3wVul1QaEUK+w8X/lh1lglRTOEYd8LqGfq+/U1epHloYrqgBn
         yrx5x+N54HLu3qvdCQh1IKCy42dXGwCCLTXI8AK13/MIL8xeQ15sg4Oz5TuQDGlsgx6x
         lFAO40DZ+3Nm66a9D+RlykuXaNiLircQBD6rfPtgGaRKAdFiZD4YywVUrfS31Osd8P1F
         M2ULOBv0QKUdEvCA6r9GICVfM1knU5xo2EvoK8mM4LcHPOQNOcWUaxAVQLJUcjzOBefP
         DSdQ==
X-Forwarded-Encrypted: i=1; AHgh+RrGW1inlH5GkcY/O1a5vktqA2+9e/cdWJDK63H1LWmx8OKlmFh+C4Go6fGVj5lQ8BJwNBAzhOPFTg==@kvack.org
X-Gm-Message-State: AFuF++k2/nAsmMkec3edhiVdruRoZIG3kKj2s9Pt4llpfkZoH7cz6NU+
	uihMfpUiG2YWfIMAp2maNp+8Z7FVmmL/dO6+Yeij5Xr0DH7lO9d6QiNWqxWbNQTum2Xb40Fydbc
	ZnWThGw==
X-Received: from pgcv12.prod.google.com ([2002:a05:6a02:530c:b0:c96:acc6:54d6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3944:b0:3d3:aec2:4dcb
 with SMTP id adf61e73a8af0-3d7b075b26bmr19293744637.23.1788287716571; Tue, 01
 Sep 2026 11:35:16 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:35:15 -0700
In-Reply-To: <CA+EHjTzJbC=ZvB3Mopw-TLf=13-iqxGw5RfTp6Gt5S1hi8WRRA@mail.gmail.com>
Mime-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-15-85e5fd25252a@google.com> <CA+EHjTzJbC=ZvB3Mopw-TLf=13-iqxGw5RfTp6Gt5S1hi8WRRA@mail.gmail.com>
Message-ID: <apca475JqemLUjlb@google.com>
Subject: Re: [PATCH v12 15/45] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: dhs5s9gqteo1cs7ew9b1tqpo5s6wtsrb
X-Rspamd-Queue-Id: 23F004000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1788287717-131481
X-HE-Meta: U2FsdGVkX18Q6BsVnZiU3SnCjayiTk0ZIH1nyPJTcPN9AgTWOa4nYZcr/vSKuGSKSz5TVrhgeBvqMWbgguzzGE2UYjwD0z6o4pPUc/NCHmmy1cvgRkJHBkjjzJKoLycjlryUla3L9jUCcuOR5lce/v6vCJXbhZUDnoPjfcigm51ilwRLFhAKVX1HwlTXUcuSKx0ExPoc6ScgHvUYQQNt8ORfvr/4FZExQoDx/zWDxzt7+VR7doLGISSae43kHB9sz/9MfCDjdNJN59h9RTsVfG1vIKhxsw1m8WyvNvEypCtOwmCi2OnBBMKQHe7Ss9/qHoPEsOSfD8Y88LPNmxwIobhA4yTsmP+Z/MuqISYOVaSK4vHC6kToifU+I1eb+0qlZwosrKg0dFhj3bxKXLA+SpCbQnO0qSi5m5ShEP7RjxaiOeTfB0il3/M2hDaGDFJ8+VLDecNZ5O9EVswZbBB6icQYBm3QUDi3O5ouRR1+c7DYUrr1HtMdGX3fk1YMvcIUo78FrkowseGGef18ulB750HmA2Zskq431CIcW9ZOkrcUpQYluOuaaPJHvlbul6Zug44zdtpNSe/JDGPMm9ywdJ9tXhOqtqaXEX5YuEG3zBoFFdDJ7gF1Hr9rLP5UsvegFAoHINoovkf7WRm/chvyokAZxFEWwUZyRZOIz2XJwwvmFc8a/w0H7pdnmPidz01HHUPbLDVF46WAlD9/0qdcSIpzr2kgGVX11n2RX1ChluuGvox3Q5FHPdEILlUREiwHwmq1Oy4xQ33vsvGEVNKeNddAMENooGxuhXbiLpVHD2YtF5tRyNEBsYgeYz8IBDYtzRXiqJqUlac2ILD3+PFdcIzbNTmtsTEOs1/1irPyRENKaRedwlYvVRtSNbIJ9Bg0h7yfFN3V9VgT/oAvXVtqnehmQshRAYEV6NvRvCpAv10Z1XXOjxbx+hyqOn2XnJJ8sTRSgW0CvF5Y4uGOLzM
 pWwxEhk9
 /eglZywtW8uB0DLHgCX2Q84HifbNCQQ1iECybgG8CAGN1+R6l1AwYw5mRV9U30EuhN5/NPFLZiyKEvX6+wd3/l07Pcd+BAm57BgbqvVgsqxUSscAzX3n3KJ/0c5PNDH50ubMEh6xg1LlL73khi2ntKt2iN4ZTOetVK9x/zyDbfs3OjdkD8Aammqk07GtBwlOm3agDkW13N0jxt8qBwLJjX0kWwTmPQ/c8GVWIbhw1LDauUZGWqnxUCcQH7AJoyAQsxgvyRQdBgCukgGvaxlxrRNZUBPjuHhd+sFkXpqHnjs96GvKaA6wYMGp8awAI62Hg+hC3gxgXTkAcGM6d6rwlxWXnqKYyayf1C+68Uaa+kcTbh0pdN1KNnM4GKH9+yCf1k3yAJBkEb/ahZSjrc1nRqEtxD5FqeEGO6HcrfFxNJ8Okq65/sZ+WvwdmTasuEwDi/3R2DcClo7gh7G8aew+kKt8BV1aFV8cG+lEzTZRJroplYJzZrUQzeZoq/NliHPRovmvOih0y62QO6d2RiXXmGYNL4TRo3Dz8hQU34GBR9PLKWiTjm93LvhLHenkQ0QpiD3XVJ/R2zowUUM1EkPh0QgaPk7M/mVM885TzqZqvKpqoZcpKmWqdukZy3unRlUpAorb8utHZcty+kQsH1Y2gBfoNx6l9MJqaLHfpAkLRV3iBJ98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, Fuad Tabba wrote:
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 803c7cdbbe0f6..fe02c47c85fb5 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -538,8 +538,46 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> >         return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> >  }
> >
> > +static bool kvm_gmem_has_outstanding_references(struct inode *inode,
> > +                                               pgoff_t start, size_t nr_pages,
> > +                                               pgoff_t *err_index)
> > +{
> > +       struct address_space *mapping = inode->i_mapping;
> > +       pgoff_t last = start + nr_pages - 1;
> > +       bool has_outstanding = false;
> > +       struct folio_batch fbatch;
> > +       pgoff_t next;
> > +       int i;
> > +
> > +       folio_batch_init(&fbatch);
> > +
> > +       next = start;
> > +       while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
> 
> has_outstanding starts as false, so the loop never runs and the function
> always returns false. The outstanding-reference check is dead at this
> patch, so a to-private conversion would not be rejected even when a page
> still has an outstanding reference.
> 
> It's fixed later in "KVM: guest_memfd: Handle lru_add fbatch refcounts
> during conversion safety check", which changes the condition to
> !has_outstanding. I think that fix belongs in this patch, so the check
> works when it is introduced and the series bisects cleanly.

Why even bother with has_outstanding?  Avoiding it requires copy+pasting
folio_batch_release(), but it's less code and IMO the end result is a lot easier
to follow:

	struct address_space *mapping = inode->i_mapping;
	pgoff_t last = start + nr_pages - 1;
	struct folio_batch fbatch;
	pgoff_t next;
	int i;

	folio_batch_init(&fbatch);

	next = start;
	while (filemap_get_folios(mapping, &next, last, &fbatch)) {
		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
			struct folio *folio = fbatch.folios[i];

			/*
			 * Outstanding references are anything other than those
			 * from the page cache, plus 1 temporary reference held
			 * by filemap_get_folios() in the folio batch.
			 */
			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
				*err_index = max(start, folio->index);
				folio_batch_release(&fbatch);
				return true;
			}
		}

		folio_batch_release(&fbatch);
		cond_resched();
	}

	return false;

and then we end up with:

	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
	struct address_space *mapping = inode->i_mapping;
	pgoff_t last = start + nr_pages - 1;
	struct folio_batch fbatch;
	pgoff_t next;
	int i;

	folio_batch_init(&fbatch);

	next = start;
	while (filemap_get_folios(mapping, &next, last, &fbatch)) {
		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
			struct folio *folio = fbatch.folios[i];

			if (__folio_has_outstanding_references(folio, &drained)) {
				*err_index = max(start, folio->index);
				folio_batch_release(&fbatch);
				return true;
			}
		}

		folio_batch_release(&fbatch);
		cond_resched();
	}

	return false;

