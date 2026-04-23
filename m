Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7401BFDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 18:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9FC6B0088; Thu, 23 Apr 2026 14:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA706B008A; Thu, 23 Apr 2026 14:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899676B008C; Thu, 23 Apr 2026 14:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE126B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:57:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19A5312049F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:57:43 +0000 (UTC)
X-FDA: 84690729606.17.93D4E37
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7EBFFC000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:57:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QUa591AV;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776970661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v3UsaiegGHksvrF9Y9nL/7mOWH7jtFrC/O6F2cdKbA=;
	b=5HB9hEzmJCs0jbridoMAfsSfgMNTxB+5/R3oy/4ZLDqnilkDIv42rFWeFpC8PbAbsvA3t6
	Evl4DGlNZWUbbsrCNYKrNK8X8mzdgzYloqAUT2F5Tc3eoCMCGwr+iS6m3DoKGsMynFJBNx
	SNbx+np06tis92eYaEG1qvH4rlUZRZ4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QUa591AV;
	spf=pass (imf10.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776970661; a=rsa-sha256;
	cv=none;
	b=ZQsVPcEnmeoOI6kVTSrYeJcnhImUwlYxZTZCb0CORs2sYUX0hmHkQriAf5SyhNNYVbbRsO
	p1ymqFhOsK93Hoz/0cZB7YzqfDJQqFJYx2ZyViAUZ+MEYFvAMx5M3nS3Bc5Dc7aDA6PaUs
	fo5zHsyemd3AFsKVQ9ciRiLSlGt3HH8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776970659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1v3UsaiegGHksvrF9Y9nL/7mOWH7jtFrC/O6F2cdKbA=;
	b=QUa591AV2FsxmkvhWB/xaVqHdwAYltrhMywZQU5c+kpbZCl1L37mHzsXbhmaBefk9/2OzZ
	vuiW3bu/wDiayYyK9YarYGChFuU/l2b/02/+mkDZ3MWx9gel01R6OtBvPD6NwXR9+pbDTx
	+MkcASa9N9Cnecs4TtvBDQ29KzG4Jj4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-vLB300btMmusa8TGRfKeRA-1; Thu, 23 Apr 2026 14:57:38 -0400
X-MC-Unique: vLB300btMmusa8TGRfKeRA-1
X-Mimecast-MFC-AGG-ID: vLB300btMmusa8TGRfKeRA_1776970658
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8eaee67d1afso489391085a.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776970658; x=1777575458;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1v3UsaiegGHksvrF9Y9nL/7mOWH7jtFrC/O6F2cdKbA=;
        b=Lr4MwAZy8vO9OmzqNYyCMmDjQhVt0J5XXle0Xq8E3I3xTh+edxl1XzMg8gD0+fJWaM
         syiH/ivz9E2Antq25GO+5mIPMsv8foJDMN6zkHQWYXx4YBtlDTntQvkRpGPRr8WLFH/j
         kiz3mYiEMKyXNArg6txRqvpQ7E5bRWsSXhlKdRPLa5FX/S4EfG38Ed7Kit8VWxvcofjw
         TaxJTnD+DAtP9zQxksY4FFj6N7Oq1cYWDnzgp0oJUpgCbVV1VtGzLyxEqW03rEKFETBE
         DYRDviyETuQVyROHZ8mhgrlaGO/QJbJBSMEbnaTG1nM455za3wXsIP4lrZBkNTg8SkC1
         MN7w==
X-Forwarded-Encrypted: i=1; AFNElJ9pBP6A5Flq64xxW6QorB1auZzITmCvNLlVKJuVjMc9vDHYjpIREG36ZVLB80QOaP3R53HC1wFZvg==@kvack.org
X-Gm-Message-State: AOJu0Yw486iwQbHdZbNpEBeCMCnVd8KZNqul95BDDsY7+yQFb3uKVzxx
	rFBPzvmePguBMBpqSxzWle72bJ0QBN4NvfHT1zdBdD94+f5F3v7+zJEdexmJLsYk/PKmfDVhXIj
	yKgbzeu75ABvO06gEnNbe8S1qwhQBANRvwBs4uKy99IseOiGNZD6Q
X-Gm-Gg: AeBDiethLTq5kVB1d1MIZ1gWvVMzkf7uvQJlkPjuivYr7gcL8H3dr24Un3m58HqlGri
	aKO6WuDLUu3GvVdWgwuxaSloHcFdiA/zmbcwZPMha8oa0yCvlrOtxLeg54IyUTO1T3/9I7T1ZSi
	USbzeRelZEmupywgLMGP4SUO47SuV9iowjDpRcFBV6ZU5ly32heNKhzpCJ44s+BP77yhLbsBUTC
	0UDphwT/WFMC6gyNmuTfrVkCh5bdrWNOra9NXR6Q9cmLkaJ8kO0Np3TesKYtEQCBxaU3FZXgNbS
	zgiV0YtFic7U/+r4ch9b4+d/DMe/FdGIyhQDiBgOKNv43DIShhbIIQXf6RgP3lpurGD8xS8cWeZ
	RuJoif6Jx1HYIhTBash3YCtvdRzTEfSKpZiVYBrFaq6iAVKSHW3UrQv0Afw==
X-Received: by 2002:a05:620a:9042:b0:8ec:c4a7:f8fc with SMTP id af79cd13be357-8ecc4a80004mr1612410185a.43.1776970657771;
        Thu, 23 Apr 2026 11:57:37 -0700 (PDT)
X-Received: by 2002:a05:620a:9042:b0:8ec:c4a7:f8fc with SMTP id af79cd13be357-8ecc4a80004mr1612405685a.43.1776970657173;
        Thu, 23 Apr 2026 11:57:37 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ebce6ef86dsm1023174085a.30.2026.04.23.11.57.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 11:57:36 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:57:34 -0400
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
Message-ID: <aeprnnccJeyHB2rt@x1.local>
References: <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation>
 <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aeo5IPpQi7onyjTF@thinkstation>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M-H9DiotUa_Pi_wgrehQQHQ_WqQIZaob1Ik-WDqCtDU_1776970658
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EBFFC000D
X-Stat-Signature: grea5847aobbxhqjroyphora3wruknd7
X-Rspam-User: 
X-HE-Tag: 1776970660-347841
X-HE-Meta: U2FsdGVkX1/kpi9Gywl9le2KhmQZQeCllAR4Lc/S9W0BYl/s+RgtAMF7IczYyIcsGoejUqidUj5zS+EXCMEgSnKAQBmo5DsEtVg0ybX5C4ncqSUWrxKFEcg86QyuG5mzzJNFMtcUt+qLcvGTujMxuPzpg2ePYcFg6limPQwa8Ijt96eUTNceU7lgk2TdAaSyz4rQYUECfJnqHaLq5v6be3cMugAXrQ5IatpMaYPk50PvtHfG+qbaji3kqhvn1ya35/sGuBqBdRM229GLIcZh+n0YkeGFcr8MqDWwkULLOulqgpzH5A/0LYXxiS5YOZE5kqdy/OiUitFZWccA9wqi0o26DSk9eROotQu8Hacu6VQfOOe4j5VcsXk08Xd9W8brupEwb99sPTmXnPC23awtvonHW+vf/mD1AglRtlP7m29KZG2iScF4O/Hu9sGvhJHZnKiFPIgvCD0Yx3VuQtaEXFrs16s7CGw28t2o9CbgGH456Oo/NViJ/Sgto7KJtsw+f+UaHDbbuwuxk9qNOCE1ecdtQxSq2Fd/pwo3a2nn5vvweZU9V+Fc8poZXZROAZxUA/ZnJThl4Bz+IesvhOH0lWNXs+SFJELVWn/NCsCxsjxFF1irpxbkeJ5LQCkjmPzrPaj4DlGSkjEsmhnpY2iWkUX2J0stJStexi04C/nAjpfhikGgjvUsfNtV2C9rFzAF+X8kGze0TYfa3Uxy/SMIgR28mSoGHojxPybVeFr+TLyGpnyl4ZseAPP6kES5Z/+Xd21emvYTRX/sV+BQyCwKL8AWUrGZjPlZ2/+yNm3i9TbIOTEoeia723CjkiD1x+Gv4RlcNTFjw5by5MPfr1EvWZz2SI4jAluJfHnmi9NVByRQNwT/58X+xXFZ4EHisldx9Rq9afcEX3UL/3olauY5CCgC0HxwO3T2AcyrCO2SZ04DD/oyk/0nOubNeIX2QwXTxjrGc6wxmRPZEQd/0hC
 r3iTPSaJ
 qH0fMXPyBXlY3fwPJx8KfWWa/HjJVDH3Apakr3LTBzKLdUWeGDiNvQaT1rtvhub2PYltsIOw6a/5yBElUTHHunFDXMF3PWm4rE2CEIfZBeNL1QO+/ZAxiuTQwlUUZe9huXtFdGHou5yvbDuLXk6+0K+v3fPFebXW7pbWMki94tCSsHNqmkvpwyk5SznlpK/AQ1jg8TaTjl6quDV9MNTUb75HEEPVgz9A+QAqjwextMG1noBRMGYzk5FnyUYwUL/anFqcY8rJgEfwHelySn/mAEmuaY6rttBHnRFxvz0txsQKofbq0xBYx6cjNPxQ+cpvHYWDk/vH4gQ8jz6BFR74Wr/DM+CB7fX0PH6Q5F0Ln0IYy0dHYXTVsuEwF/h058a3c4LsMWM10rTDhRsrwAolFny3jZDF/hcNUUJTk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 07:08:00PM +0100, Kiryl Shutsemau wrote:
> On Thu, Apr 23, 2026 at 10:50:06AM -0400, Peter Xu wrote:
> > Hello, Kiryl,
> > 
> > On Thu, Apr 23, 2026 at 03:27:11PM +0100, Kiryl Shutsemau wrote:
> > > The patchet is pretty good shape in my eyes and will probably drop RFC
> > > tag.
> > 
> > I still have some high level questions not yet got answered.  Do you want
> > to answer them?
> > 
> > https://lore.kernel.org/all/ad59TxAHNwFWH7Cc@x1.local/
> 
> Sorry, reply to this got lost in my TODO list.

No worries.

> 
> > In summary, it's about:
> > 
> > - Whether we have explored other approaches on page hotness tracking
> 
> So, for read/write tracking we have clear_refs=1, page_idle and DAMON.
> Did I miss something?
> 
> clear_refs is process-wide hammer. And you can miss a hot page if it
> races with LRU rotation.
> 
> page_idle needs rmap. It will not scale.

Yes. If you would benefit from a per-mm page_idle, then it may apply to us
too if we will be enforced to implement full-userspace swap in QEMU.

That's also why I suggested (in my previous reply) that we split the
requirement: one is for hotness tracking, the other is about read-inclusive
trapping (v.s. wr-protect only traps).

> 
> DAMON is built around sampling. It is good for working set estimation,
> but I don't think it is directly useful for eviction decision. It can
> miss hot pages. LRU rotation will also loose info.

Exactly.  If we need to collect ACCESS bit (or anything similar) for
eviction accuracy pusrpose, IIUC we need per-page info, we can't estimate
by sampling.

> 
> None of them gives comparable capabilities.

I want to see if some of your work can be generalized so we can use too,
and we can also work together.

> 
> We also need a mechanism to atomically evict pages.

Yes, this is the 2nd question below, and btw uffd-wp can also achieve this.

> 
> > - Whether read protection is required for an userspace swap system
> >   (e.g. did you get time to have a look at umap?)
> 
> I looked at it briefly, so I can miss details.
> 
> IIUC, in absence of read tracking it doesn't collect hotness information
> at all. The eviction is based on fault-in time: the oldest faulted-in

For example, let's imagine if we can have a per-mm idle page tracker, would
it work for you to collect hotness info?

The other idea is, no matter whether we use MGLRU or legacy LRU, if we can
expose a better interface to share hotness info from kernel to userspace,
would it be possible?

> page gets evicted first. I guess it is fine if you don't care much about
> refault cost. Like, if your workload fits into memory completely and
> refaults are rare.

One thing to mention is, if we have any hotness tracking facility ready
above (e.g. per-mm idle page tracking) we _will_ trap read faults too; it's
just that it'll be much faster (when it's hardware ACCESS bit).

So if I'm not wrong, what I am trying to discuss as a full userspace swap
system will always trap read too for most of the cases.

The difference is only about that 5ms (in case of 30s+5ms example I gave in
the other email).  Your RW protection will also trap that 5ms, what I
described won't: when a decision is made, we wr-protect the page, any read
on top of it will still go through so it will trigger a refault.  My point
is, that 5ms missing over 30s (in reality maybe more than 30s) sampling
window (which covered read accesses) isn't a major issue, and IMHO it's not
a strong enough reason to include the whole RW feature.

The other thing is, as I mentioned in the other email, I still don't know
how the current RW protection would work for anonymous.  I don't yet think
the user swapper can read the anon page with RW-protected pgtables.  So far
my understanding is maybe you only care about shmem so it's fine, but it'll
always be great to confirm with you.

Thanks,

> 
> That's not my case.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov
> 

-- 
Peter Xu


