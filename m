Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E040CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF67F8E0012; Thu,  4 Sep 2025 16:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDE28E0006; Thu,  4 Sep 2025 16:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE3778E0012; Thu,  4 Sep 2025 16:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4398E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:37:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 468EE13B2FC
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:37:07 +0000 (UTC)
X-FDA: 83852727294.21.B7DDD1F
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 62BA140003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:37:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qjm0Djb/";
	spf=pass (imf17.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757018225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EI6nD7Kb2vJ6eXm1beP+MC7SFJD+s+Tf7//wFJSVUQY=;
	b=USycqczXvNvDVi9CdGSK5wjKSLI0A+ldzxCD4VMqnfvLwztbfifiCcZa9f5P+TA9OO0jod
	ChhvKksky5Pjj2LWopKEcHk0MqFfTXElMicjLlhND8VeDytnzZuGffczmcu/WxCt4CSn5e
	M6ehFSEt5LDeVvr6CNLndbjAs/vXV0A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Qjm0Djb/";
	spf=pass (imf17.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757018225; a=rsa-sha256;
	cv=none;
	b=VfJw5UUQr54xoNuatokqquncclBhV26sLVZtofOW1PKBGTKUibdMaPIP/RRKgJwr6VrND5
	R8SjTEqc8YkK2JIdpOAGYpyH3mAfr1KKLk4ZmfDeMCIxG2NH9cnEnZsfc/UNrTaV9wYFMx
	JRQFNurSRso3l2S+IvqKhGaQ4uHjj6g=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d603f13abso16969487b3.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757018224; x=1757623024; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EI6nD7Kb2vJ6eXm1beP+MC7SFJD+s+Tf7//wFJSVUQY=;
        b=Qjm0Djb/eLZ2CO1BtDEwBifLeN5xsd+SGr7NBRauWzKChSN+psZx6owgguG/wkveEe
         KSWNqT5pQlvGSiZiOGCLa/czmAQ7EMR+00LVJOW0HBTYQOpxr11/mrfJX/o5Bj/4fYo9
         L6iZp5DevG9UA5+sgj7e5wFqKOn4i0+vJMGt1EGj5ADgQRYIymZrByZ1pJDjElXyNypq
         H09aGlbxEqualuUcqrfBrL+excpMUN0bcLITc3NPx/iOUGKWZrwM5vtZHlwVUeNr6dxT
         mVlK7kDexRLHB5hnDxANqZFwQ+1PVl1jw25kfa8r9JVdbOhxEFOvzdJy1NxvJRB+k/qM
         wAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757018224; x=1757623024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EI6nD7Kb2vJ6eXm1beP+MC7SFJD+s+Tf7//wFJSVUQY=;
        b=uUNrDgyIHjJArk8TebCVBMBs+QxNy50c7y+gKErXFcScgZbQuLOllEXRXs/O8EZ2pF
         EDkXm3PPJgBVKCD33FXd+BowvkdJESHUH6mzMDa/51W3up50KzcVtH+h0IuwLMPKinD5
         lpsC4MYZnO1eV2ylnipZSw897fJbhmiEjlrClxmq10LxC5M3rcv0rJwnnoDKKwI9JFnn
         LRlCuv4X0rrGIXZId9B7RkVXU2VF+/40Uq/RAiYWAsigsNhuXb3KZ5Rf7tEV2R9Svj5y
         cv0SV/XhEATsLFOPHng6z35Ke4L5Hii08tXCGrBDWvBLgexO0hE6Zfi594RBts9H1PBB
         9HcA==
X-Forwarded-Encrypted: i=1; AJvYcCUg1Z605LnBgZIYWx209hOjzlKbqeb/31Fv5KSfhU/1Jo9zHFXCFe1KzcuePwgweVInG7OZ3X0ycw==@kvack.org
X-Gm-Message-State: AOJu0YzNWtbcEenxU1tXx74hwVSYRTWjDB3mxxIbkiISgMz5si4RWtDq
	mfXigPtNUcDyYpaX283xY9UQNkLZAfveLfWUxmRtf0g6NRtAVRoMo0vV
X-Gm-Gg: ASbGncv9I0SIazpHe+tx6eMeDfRVSNGCXs3dLyBZEHgXARMjiMhwclyzTbFUbjtD0mD
	8Whe9R2ByVMQG4EewnAyex+aiU2+SSvRKKLAPcDQRT1ZzN5QcKPP5SZK0AKrvWqKh2eJte8PLhr
	01MYjQe2o8gS+x5hUkSrEkNDsi0WFJPxjvLQNJbrS6889icoKbHn5Xu7Fi9LZ5oaM/5F9mTvQiB
	Er+G6FLBw4QPNirMl+IXbP0yrjMCieQheaNWL7nB+n1GPXDkzh06FlhcCVhNjO5fetO7uHMui7i
	700jta02SwC9/3/zs0sSu9Q0xNo5szIE1DHI0YTvTwQ3ttNMi96Gjv6wQ0QuuewToCUKVzuaEjW
	Y5Kk7AGGO4vujbFoTRRTdDxEuXBOuI6pV
X-Google-Smtp-Source: AGHT+IFiE5N1M0ZHCK0VNaiwKKRp7XpL3kAlt6Jadb18nEF1ZoE40INUGXk3t/leYVgwWHl3y69GxQ==
X-Received: by 2002:a05:690c:7002:b0:721:3efa:6d05 with SMTP id 00721157ae682-722764caa67mr246004437b3.26.1757018224161;
        Thu, 04 Sep 2025 13:37:04 -0700 (PDT)
Received: from localhost ([2601:347:100:5ea0:1218:85e4:58ab:e67f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a855a89csm23725327b3.55.2025.09.04.13.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:37:03 -0700 (PDT)
Date: Thu, 4 Sep 2025 16:37:02 -0400
From: Yury Norov <yury.norov@gmail.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/7] rust: percpu: Support non-zeroable types for
 DynamicPerCpu
Message-ID: <aLn4bopPt8uS4d1O@yury>
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
 <aLi-7W21N45fBGJk@yury>
 <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 62BA140003
X-Stat-Signature: 9bcda7rfxnmu6fc5fr413gntmrqq5zbd
X-Rspam-User: 
X-HE-Tag: 1757018225-855613
X-HE-Meta: U2FsdGVkX1/1FCa7VqmpALRi0kjWsEratAK4Pz9ClHHbGmsf1FNF8ds/xKnuOAFFVHG3eNMnUiZ2CfODIrSbr8PnfMaQIYa+FKv2JCbgVkaYHQzaHLAnIJ/1B/mhOM3azfto/cPoVp0uHpELB/cntpIqspOqzg/3qYcEfZBRRkXPURx8Kw8Nx7fbnBSvCErfO2n7MVQ7Wb+U5TgeHOpE1DSKBfXXckyXkZaLRZpkfN6mShljn4bOjKNWk1FQh88hKnUjVrPqDmadixDMLmYvO6a5qfzc6uM8kWYTI5ucJSMGonhDbIRELAYTPcMvZSnhzfMCberXqVMS287vlB+TR1iirotlWpVRWfgvh2jj6ygsIZwtWSr5G8bPGTKAplTfoymBRlARxd7miwbfwTK62V4b2zATwPEnkRFLF8vbFf+V0590YHUKfcV8L63bqYyZaz4EADj9VqdHP8ENTjzta8ldceYjNQR2z1VbtX6sqZz5piJ62rUtPxP7t7PEliXYlNOFVqMpDpOWgOonZI8uOIFrhPep8vg7r2gNRosKFZRyV3TDB0aQS/lUPvjNRz5h95+4D/tP0OY5X3VSlmMBsJGXoZ7c1r0mGVHOozFV1Sii4UJsTOLu4CUx79lF/dLJYrJAFkin/FRzHmY79A00QLgysOBNh4/ShdHTXlnwd3LkVItiOC+0I25sACsNggY/M0sacDQuAJTURDAolif8B3Q3qHwSNWF641WRBtrFHwnoDaCZCkmAiDtuc5Imv1hNmTFzIPWtlBWrjujlYqwi3iDOBfbeBktqBzBTlIeP33jpd9gJ4kmnZefTKl4iZpnj/mhZG+ZW/uWU6QDw8R5g3dArBuIP3CA6LXGTOdFV/c7fhShE/y5oqvMMQZxG4t0HcsHTAvW+23h54om4V5+qCFcD8SP8/74feA2YVOwSbwqFeUkf/V4r1JLwcB6k1Sm/blyb9y0snahFNcVaCAS
 Oso7N+BN
 4KbwOP3bNUSwpxA71WnD+envXejJOljZs9uvfUhDM+lLkb/+hI02hiW9p+Qpi01BemHX9+6Romli/8PYTveO63lByrKuBPLnjdUaZWJcqmvsOjFDdkQAAo3DrJSJJFRrPxl7gW6yY3XSF2JEdVsi89W8pgzRA0ejBNrBMHwHtC9pH/ZHzJuLfBxTrl0TTsjqXTkey5iZMmm0wlbemM/Do5gXI7Jx6119zYj6yNKW4Z8zZNzCSB9rGiTpFqkd63n6YgVcGHedNJC5LnEWR8FIMq1RaBpUEHcmgEQfyYgkfTZA/yDgufkgg4JCrWWTl5Vgr4mnHwhGbfcJOLKMDBaIcFl7fMMtz+rs7nfIXxzd+FxFiiGVlOV8PJ+/B6xVs1RTQSM0PTPgCpt8YVBuMgm7rwCe2VokRMK8GL6nNxKzIL7z9S7nR7g/PuQyA11KJ1WXBHZ1J9asCV6za8q0ENcgX+5HfvWfPYx2C8k36AW57ydvFEw4si6M9YHPOjhC/olMVCmD1nmi9LKqYuWwTQQQBnxt7kYxMHE34Y7TVBosvP6bsCLFYvLILxcgkFuZFNZgOz2iUrRzYr81OQ62ZvLhbHNer6vIU6mM9hbSNlU5bZsbpKY5pJ7atednlpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:26:07PM -0700, Mitchell Levy wrote:
> On Wed, Sep 03, 2025 at 06:19:25PM -0400, Yury Norov wrote:
> > On Thu, Aug 28, 2025 at 12:00:12PM -0700, Mitchell Levy wrote:

...

> > > +impl<T: Clone> DynamicPerCpu<T> {
> > > +    /// Allocates a new per-CPU variable
> > > +    ///
> > > +    /// # Arguments
> > > +    /// * `val` - The initial value of the per-CPU variable on all CPUs.
> > > +    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
> > > +    ///   `PerCpuAllocation`.
> > > +    pub fn new_with(val: T, flags: Flags) -> Option<Self> {
> > > +        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
> > > +        let ptr = alloc.0;
> > > +
> > > +        for cpu in Cpumask::possible().iter() {
> > 
> > In C we've got the 'for_each_possible_cpu()'. Is there any way to
> > preserve that semantics in rust? I really believe that similar
> > semantics on higher level on both sides will help _a_lot_ for those
> > transitioning into the rust world (like me).
> 
> I'm not sure I understand what you mean --- I believe the semantics
> should be the same here (`cpu` takes on each value in
> `cpu_possible_mask`). Could you please clarify?
> 

I mean:

        for_each_possible_cpu(cpu) {
                let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
                unsafe { (*remote_ptr).write(val.clone()); }
                let arc = Arc::new(alloc, flags).ok()?;
                Some(Self { alloc: arc })
        }

Is it possible to do the above in rust?

