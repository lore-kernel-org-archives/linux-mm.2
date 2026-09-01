Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50752C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485536B0099; Tue,  1 Sep 2026 14:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435586B009D; Tue,  1 Sep 2026 14:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3249F6B00A2; Tue,  1 Sep 2026 14:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12D96B0099
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:41:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78C3E80514
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:41:48 +0000 (UTC)
X-FDA: 85166062296.07.93262FC
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id D15B380006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:41:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RPjHNstV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3aRyXagYKCFoK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3aRyXagYKCFoK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788288106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T0nDJQnfFlnDLvDCZVuLzJX537jxkgQCnIHPdf7AiK4=;
	b=rT7BcK4dors5R2aynsl2QxVGKZKUbBPcuGCoF1GD155eYcJfjB0YKuPZfwNRRgrJeX3LB4
	XQCwwCUD/eEaS3AuZ7o0hXgOOQEP9CpDzsFOajfvfONTpUpE67Ksethma6AyvAb4G1T/t8
	ILEotY1y+zIrT84KCUU0iPQ7I+FPBc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788288106;
	b=W1uw+6xwO4RsOfh8asgRUfanI5Gd9LovfB6CO2L4d+8Pll2r9x7TDnrtchNtAFJ1ilDfJa
	nhDgaBbOkOsBk9HuE6gqEaW5uzuCt4/sHz3yiJ2FqPdaDOQpVPdrI492Foa09k44+tFs24
	gNVbVYRgYSz8bld1tCusXXxkDo/UotA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RPjHNstV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3aRyXagYKCFoK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3aRyXagYKCFoK62FB48GG8D6.4GEDAFMP-EECN24C.GJ8@flex--seanjc.bounces.google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84e375d9736so126343b3a.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788288106; x=1788892906; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T0nDJQnfFlnDLvDCZVuLzJX537jxkgQCnIHPdf7AiK4=;
        b=RPjHNstVAU6Fr+wPN6EruHU0GEXQ3R+c2giVGGNiIViy+7AdfbX467Vf+Ft2JydKCd
         On88b01VjtfjWOC6qoYfVOhStyMMtrdUjAgjz3zaJfku9/8H36bIQiGxXh8HgEAvS7Cg
         pnvxJaKUjxKZ+bw9v5PgcV0IKePgwfTq88npJUlbEV2vE5f/5amt0NBWSz6IbUPZ7JgV
         TrZWhUX5rZgEYenRjXn1l8g+ALIVSM/lFiqPf45RhiDSOV/ixfJoMtB1LP0NwOUiA5Ke
         8C8rgn9k9XV1BoNBwlduNqQp8tkHiGCTfhkmXg76vyAO4xPJ/MdCTDobt5Qwr8FooZ2Y
         ITuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788288106; x=1788892906;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T0nDJQnfFlnDLvDCZVuLzJX537jxkgQCnIHPdf7AiK4=;
        b=jMQuHd0al/ri7QJgk8muBPupTAzjKrOHw3sc2/S3c6vV7R79iX/SW4AWaOF6sEnGNE
         gOCaL6eu+CvMkszXMTW2IRktja/pSr5CMbQrA95/5paV4xDW+eW+trb7zUjPVGpyeqD5
         Yt6AxE+1/63eK3M665NnrbMRaKOug5GmvPtv+HZMzm6glR4zDJyTgVVJpSmbDjv7ZEW1
         9X2KOLexic+89xI4UQ6Cck2ssfY5IigmHZ/IbbfbJ8KYnjQensROKmN59BtqpsEoYeUR
         Ajj7JXLolHhanVZBHu9Qqd49zFJ0zQwILF9ub2FwMw2dpEFIHCTx2ce1e5wWdN9mcOv8
         Le6Q==
X-Forwarded-Encrypted: i=1; AHgh+Rqh7nE0i9lxg0H0n6GfsQD63JgJx09Wz4yEXFEQ69JuVc9snvjYqp6oPjuQHs/0+HP9RYVWmgfddA==@kvack.org
X-Gm-Message-State: AFuF++khkBygnHIOfdwhRGSSL4oAtJYHcVotidSjz0NF014uSwQgniwI
	3Ud2O9bpFcgjpb7YofqD+CDcfjvnRCUgab6hQSRMgoW1yHNl6KmiL7bAX8xGzgB8BQGbUa59SIR
	5bXIRUA==
X-Received: from pfcy6.prod.google.com ([2002:a05:6a00:93c6:b0:848:49f6:6f5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:8016:b0:857:4dea:e20e
 with SMTP id d2e1a72fcca58-85b5693e833mr15207248b3a.0.1788288105188; Tue, 01
 Sep 2026 11:41:45 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:41:44 -0700
In-Reply-To: <apca475JqemLUjlb@google.com>
Mime-Version: 1.0
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-15-85e5fd25252a@google.com>
 <CA+EHjTzJbC=ZvB3Mopw-TLf=13-iqxGw5RfTp6Gt5S1hi8WRRA@mail.gmail.com> <apca475JqemLUjlb@google.com>
Message-ID: <apccaNCJ2lH5mbaY@google.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D15B380006
X-Stat-Signature: tbgzuchtze58pxo6tf9rwgyzk7t98soc
X-Rspam-User: 
X-HE-Tag: 1788288106-551413
X-HE-Meta: U2FsdGVkX18NeQ1aoQCvd+dlRQg2/zqkDygCF6i/t2CKgkRNSGD+j6HFEX5dFaaMMmxUf48zdJfVrRiuPdmiu+7kgQs3v+FerzZBK3hQMOXu2Ftuq70kGaImQNeEIzFWcrjDjq/6MFmda0OWG92G8vG3loHHKg+9D6PwKLSEBruIjRDLGrF7VE9DeUAMMPp/gDXiLlRRUbThTjVevudeSyWYYuzCdcKpjSroUl5q1UXXdjY997sbyW9kjW0Eq31iwrHHvNi7zEgtqVON0+pshwloxP6YFWxiu6OJuR8lWO6L0J7gx+RXCnTez8Yf3A1KQV45GxZbnmmKazn2gwSOxwM6AQK4QkqtIOAEV4H/nGp2YfpS+Q1aThXOrfLcDGTNzdgR0BtmcIOJSQUg+tyG77wYydQGyi3VCYc3PqZRHtOwmANnsv9Llg4+aB+riiGWGVK/FHf2BS0L11KAsqJKXiUlcXoLjo0S0E3N+juVzyZIKCpViB1kOPv0IKwrEVKulCFYfA6voDYt+1YDGxGG5qfut/rjfbeJtkgA9vQ24EviZrWdeoJ6Fd6MmIYrEfNmGARfFILSLy9Y4E1mLAyugN0e8GXDeP6ll724PlvvLv3amjUEitxNRSSU3rvNGbvuo7tJfD8kCZ4SmFE05dPplZtKQDK/Q7ZpXXj6RT5IJANpLvK+JQcx1BCiyYtbQVeVjXvDk1PqmXMfrpj1W+vxRx1S6SqYjQrxd6VFCXtTUV3Zr4AzAenamT3+ZfXAH+bFfcEr3+uB72cruvr6YROzYlWC6HdFAkRUzL4QjjBtW1IMtgpcm3dL7pZo1miOGrYeEQDVbeGb81jybP41J6atIpWYK2hDoQEJZ/DKKW8J7T9thjrpwOHF5haKJGeRIrNtlp1uvjvhnhAMf3GaOlP/Vkcjgk7jkKy340J0f9JwZL8A+AdYihT0UaWj2aBvy+4KVL1I/S8XvkGjr7Iq73B
 ZvglXfqA
 1qu3gDGOausDJPxkk2hxwE1zzLTRyM+4v3UAMvGCQvzxsQde4DiCk+m27I+rLnVdQXepa3BegFn+CRzU+0zmdlycrYgp6pYE9yTGSZjiO/kpz1jqCJ6qcVqlTeEOX+sfKlbTHLLSAhdvb9HMBefOH7HB58V3r2KPWpjfT5H2U9SacQa1QV/gVSxem5E8lPJwE2/OwoIvIlGYdL3/ITlDTvhJa4phIs2+bZfxACNnou0tfKQmrongK/vltBDuGLEOokoDIvqmBi7M4wQCUp+3oH2vmFarWEeX8nzvkHqZK9VUOqvKP2W5T5fqGa8RoKEj27sE+a0JwBEzdJqeils/D04frQipdSVdd3mGbObGqBOLhPALl1JWttIoHeY/fh6Jj4YfQj70JS9dJ/rR5UuD+j0+H7gkhzCYUjcS5z2uJXn+o4ltPJcF5AByBSR2TiQV258+lmLIJUJe0dTKqFPWFfBkAmwMaqpmGF2MRh7IubxtBp1Ugmw8I2rhme8uH87YFsdTfOfQB4H7Ia8vWoJ+AbwR0b6pUf6pNcBfKjmdcnntnzhuchCSjvzbCxRSOrMFcvBPVnfTVXIZt3DzGJef/nceq5YaYrop1e6Bo9ncQiqTkxGJ7VFys0l0nEcMHU9ZKNiTvbiYplV4s9aP5ohwLNLhHna2hMkfgjeEO+qn/Uv81pIE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01, 2026, Sean Christopherson wrote:
> On Tue, Sep 01, 2026, Fuad Tabba wrote:
> > > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > > index 803c7cdbbe0f6..fe02c47c85fb5 100644
> > > --- a/virt/kvm/guest_memfd.c
> > > +++ b/virt/kvm/guest_memfd.c
> > > @@ -538,8 +538,46 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> > >         return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> > >  }
> > >
> > > +static bool kvm_gmem_has_outstanding_references(struct inode *inode,
> > > +                                               pgoff_t start, size_t nr_pages,
> > > +                                               pgoff_t *err_index)
> > > +{
> > > +       struct address_space *mapping = inode->i_mapping;
> > > +       pgoff_t last = start + nr_pages - 1;
> > > +       bool has_outstanding = false;
> > > +       struct folio_batch fbatch;
> > > +       pgoff_t next;
> > > +       int i;
> > > +
> > > +       folio_batch_init(&fbatch);
> > > +
> > > +       next = start;
> > > +       while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
> > 
> > has_outstanding starts as false, so the loop never runs and the function
> > always returns false. The outstanding-reference check is dead at this
> > patch, so a to-private conversion would not be rejected even when a page
> > still has an outstanding reference.
> > 
> > It's fixed later in "KVM: guest_memfd: Handle lru_add fbatch refcounts
> > during conversion safety check", which changes the condition to
> > !has_outstanding. I think that fix belongs in this patch, so the check
> > works when it is introduced and the series bisects cleanly.

Wait, why are there even separate patches for this?  For all intents and purposes,
"Ensure pages are not in use before conversion" introduces a bug and then the bug
is fixed by "Handle lru_add fbatch refcounts during conversion safety check".
Just don't introduce the bug.

I also recommend splitting the export of lru_cache_drain_for_folio() to its own
patch so that it can be more easily Acked by mm/ folks.  If we want to squash it
with the KVM change, then that's trivial to do when applying.

> Why even bother with has_outstanding?  Avoiding it requires copy+pasting
> folio_batch_release(), but it's less code and IMO the end result is a lot easier
> to follow:
> 
> 	struct address_space *mapping = inode->i_mapping;
> 	pgoff_t last = start + nr_pages - 1;
> 	struct folio_batch fbatch;
> 	pgoff_t next;
> 	int i;
> 
> 	folio_batch_init(&fbatch);
> 
> 	next = start;
> 	while (filemap_get_folios(mapping, &next, last, &fbatch)) {
> 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> 			struct folio *folio = fbatch.folios[i];
> 
> 			/*
> 			 * Outstanding references are anything other than those
> 			 * from the page cache, plus 1 temporary reference held
> 			 * by filemap_get_folios() in the folio batch.
> 			 */
> 			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
> 				*err_index = max(start, folio->index);
> 				folio_batch_release(&fbatch);
> 				return true;
> 			}
> 		}
> 
> 		folio_batch_release(&fbatch);
> 		cond_resched();
> 	}
> 
> 	return false;
> 
> and then we end up with:
> 
> 	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
> 	struct address_space *mapping = inode->i_mapping;
> 	pgoff_t last = start + nr_pages - 1;
> 	struct folio_batch fbatch;
> 	pgoff_t next;
> 	int i;
> 
> 	folio_batch_init(&fbatch);
> 
> 	next = start;
> 	while (filemap_get_folios(mapping, &next, last, &fbatch)) {
> 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> 			struct folio *folio = fbatch.folios[i];
> 
> 			if (__folio_has_outstanding_references(folio, &drained)) {
> 				*err_index = max(start, folio->index);
> 				folio_batch_release(&fbatch);
> 				return true;
> 			}
> 		}
> 
> 		folio_batch_release(&fbatch);
> 		cond_resched();
> 	}
> 
> 	return false;

