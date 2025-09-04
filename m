Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A95CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 21:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7B38E0002; Thu,  4 Sep 2025 17:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEA78E0001; Thu,  4 Sep 2025 17:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4AA8E0002; Thu,  4 Sep 2025 17:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DABF8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 17:05:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8886CC03F8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:05:36 +0000 (UTC)
X-FDA: 83852799072.24.B13F02F
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C51040011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 21:05:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSmSEKJy;
	spf=pass (imf12.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757019934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pePvqOR7Q5lmGezz3Zl2SMH1cqCRYl41xACklsYlDnY=;
	b=wl/V+/Bnp7/9wXnjL1JA6UEm/vecIK0lQAzasZeYxu5CkD1QI5cawVeHWtcSZWibaQtbgk
	quHlxNVD8UC5sCm5ou/XgRyxpecZ3A24347foz7k/FYRwalJaXMyJDdj5DA+FhXasssMQ5
	ZjyXN9wZZL6fY0zP7Lrd9UYyFOgGdY4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSmSEKJy;
	spf=pass (imf12.hostedemail.com: domain of levymitchell0@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=levymitchell0@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757019934; a=rsa-sha256;
	cv=none;
	b=1PtlRTvZDPXzgfqOXuvacEgX1hCc6KvyB25Hk2ejnEOfbCFBpZZKAOFl221hZdO5m7l+gv
	1hK7j3ef9qcPlOlXhPh8EmQczgF+/MNXwIVX4OWnb63S8zAbK5/QrqPRvF3tgkivTrw2Z5
	FQcl5R3eDXxs4+JY/JSKuqKrEFLhUsY=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-77256200f1bso1546493b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 14:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757019933; x=1757624733; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pePvqOR7Q5lmGezz3Zl2SMH1cqCRYl41xACklsYlDnY=;
        b=CSmSEKJyo3GewNOIc8jJw41Nd5Rg2PS1vT4g9DXTX0oTcSObyGj4jcIF1/qCO3Dz8z
         ol1/acFH4QdjD0lkgFe/cuazOzeeYBysYo9KUs59FK82QnpZXJI532eLEc7OcnWJjMNd
         IqvHPE8S4QRd+6XttTEwwIPNlZnkzhp+hliX6mX16iV29qKOsTCUg8UoT6IQGltXmDky
         yqEyhLZk962ZiUljiEvg5TreTaNCk0R7/dB9ylQ2KH+3K17DcuJ+U1UppUOQVQH5NZMj
         bwqcmVI/zl8+jRZdNsXScWpziL4aJWaSvmhDctjwq4xpfnBbBwyKflNJzEgGsQFW2oRO
         k5Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757019933; x=1757624733;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pePvqOR7Q5lmGezz3Zl2SMH1cqCRYl41xACklsYlDnY=;
        b=nbqGoA6YHRk3XLERdasMlZw/znWJ0rxMll+tvj7oQkjhouSfIiSLMKdZJlUclImR+9
         PztbINYBRNLrc0r/fCrMUA0sNZNwCl9rxd8ego4FFMV3RUvV73FswPVeFDfnpqJgS34Z
         l9vwjNPQE47EG16o7/T5pWv0MPOOsHKQ2rxQ2TDtGYP2ufPZ2X44mHaagN95wlxVK3tv
         Q8v2i3eJCEntOtsh+dl0auuPs/5+fUO/wGo0DfcfjU2tJBpyEl4fO6KKhrGvDTEL4pYW
         MfngGHz4a8vDDDjsJnAKoIvQYAaXFMlIrCxuc0j3vUw9/yMn+RapM0wNXMSIL7MUGmGW
         C28Q==
X-Forwarded-Encrypted: i=1; AJvYcCW9DpQN5yfStHftFMef8S+fAmWpw5dZLCv9uRZbGD64xmfXV/+l3CbuadhKhB117AsLip5n6SmCNg==@kvack.org
X-Gm-Message-State: AOJu0YyF7W0xfMRkZEVj8sIyNMB8EjzExM2Dm9sy7BvhSnfBrxfTrXr6
	0imILaEVgehl2fdiDMtXyzM1UvrSFtEKxmdoiGCRTGMmlnnkmQfdXxjV
X-Gm-Gg: ASbGnctaqlkgQn1IuIAzr8edWy0QzAq2D3sjz4HVvxLTcchJs0itVtrwx/2Q88OLpC0
	YOAEhiU9ssfH+AEkIFqm6yXSReTY+mgucBfurj60tnjLY2pf6l1AeDyQS84IXJpUs7pDxa4NoLK
	jBCVNHXYyHU8dvg0QTd/UpsRG/BHA+Q7T1gnnyqVJRXk3BMUYdnJJeeDn6VzKzbfe9l98eVQu31
	/opX5qyocWa9IIDIxNnf93g4vbPY9CtU45Ig+rTC2SkyMl4UhpLxpezCD+O4arUHChcE8ZzrWXW
	l6Bcc5T4DD+IcynuCpaZI0L0J12WTkhPPb+lPsPKTgq0oJayZaerjHu80W1DI6f32xNP+vAdGA6
	BKAssNIBLRf0wIj6k6Aa2uuJxRlJ6UC56Ol1U4Q==
X-Google-Smtp-Source: AGHT+IFqHr/M76UHbTB5jG3tqCeaieTz2lBy8yr6iwfKPpC80S5IkLRd3TQLo0XvYyhNo6p2eDpIkA==
X-Received: by 2002:a05:6a00:1acf:b0:772:615f:b5b1 with SMTP id d2e1a72fcca58-772615fb6e9mr21433903b3a.18.1757019933027;
        Thu, 04 Sep 2025 14:05:33 -0700 (PDT)
Received: from Cyndaquil. ([174.127.224.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e27d1sm19872865b3a.81.2025.09.04.14.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 14:05:32 -0700 (PDT)
Message-ID: <68b9ff1c.050a0220.35de1d.11b7@mx.google.com>
X-Google-Original-Message-ID: <aLn/GebopZOJZoyc@Cyndaquil.>
Date: Thu, 4 Sep 2025 14:05:29 -0700
From: Mitchell Levy <levymitchell0@gmail.com>
To: Yury Norov <yury.norov@gmail.com>
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
References: <20250828-rust-percpu-v3-0-4dd92e1e7904@gmail.com>
 <20250828-rust-percpu-v3-5-4dd92e1e7904@gmail.com>
 <aLi-7W21N45fBGJk@yury>
 <68b9f5e2.170a0220.1224d9.5d3d@mx.google.com>
 <aLn4bopPt8uS4d1O@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLn4bopPt8uS4d1O@yury>
X-Rspamd-Queue-Id: 9C51040011
X-Rspam-User: 
X-Stat-Signature: 498urm74ogeadxxa7duna7itwib7a5si
X-Rspamd-Server: rspam09
X-HE-Tag: 1757019934-34675
X-HE-Meta: U2FsdGVkX19ouGddcwtmgbenhPo3ZxRw4cFToIWvHyEtPU6IKhHVElhYTmuKLFldFbUs44D1rdgc24MAO2aW1GXm9QK5PFTsN3ArL1tqk/iT+TRxX4o63SoBSaq2mU50UAOW0tbQuFS8wzPvwg65gWk2svipiy4Cjdy0onU1pHJalnwt73UPTeBS20EJqgxRd2x2Es/FHnfq/iTMTW11IgPC7C4cP5TPPRSQBtJ6+t4fxaH40+tbn4fuiAvtvVWHMezg2BYDxMUehpAIfpRfPenf8BZYBQCZw9Am7mX6WJAhqiwVS2/il1nTN7DcIlRh+lgwkhi5FXGSDTb/64jP2ujKQS2MKcOuIWmTzdV5OqYIFnPgBWbyoAUXMO6E7aoCvy4v6AWdXvGhzqk+b72JKlMYSiWrX+LFRmdqV4uSwbkMADtu8Puk+wFl34JvXHW+ZI8slNCFYg6lrUX4fFACYG3KMPsFKaTBSQLqbHGc3xE2agql2N+tGVRyquxf5MQhttczhVbVWEaigKpQVXLeYHbkoAr1FRohPYN9zFWf8g8KxEIC2YzgmZYlQ3hAfOBlfegt/IUa2fkw4wBDdyk2xJyFEgY8SUCrFXJBlYCw9FarZcdc07UvUOnLe0y8C3XRsWn1ObmPSoV01gtBr6PYczO35QzRX2rXu+ZnjN6BGsJlp7nQesoVxxzVkal/2wJAUqMtddJpK3GfEhCdkRF8UTybKW8CsAZs8N4pp/H0X7it/X13C+UCIFpa043Iq8nhEVTrAJNG7kEkUWjAhrrStp4SAi1EWnXdMPvkufkPnMvrrf1N1YtM+Hxjd5Kx353bccNVyHQ3o39ZEEDxZ+vLCw4KIlDVEBi4euZlNZS20lKEAb9waXACwXYRygodulA46cidcUh9zoN9c5F0Vvu4XFDfU1DlyRFNKzXCMcZKuesVkMUC13IMZIwMF/ENyjaifBQKBQWF6O7niIsZMlb
 XQB3Yg5M
 1Dsg35bJLC0cYUi0HiLW2/7EYTdQfRmV7i/ui3z+OABSt+eD7BvhxVM2Ask/6RqTI38qWog8iqIG4d7uBq7jtZPKfWazyrYLBsFCIzzUhv+DVQ6ymMgJW0ZrCfHACq2r6B3BNJN9vmLhU6klB7IUDerx3ht2jXRPvttxZqNufWFcJ70PcCHjmo7nzS3AQPxnlb9vudytGrmPekvps8xB27nMnt2xTJK764mSI86CEeWsOMkLsyp+6/Sj9T7C9jkj+23lF8C3dnE7JFFZpVX5ll+ZEA4EOOepHMdtOKkyGCTUpRxs6l6SPYvE1l5CN7AQCOd1lFJXBwKjQCPnXQpIuP3TJH39YLsPvkPEFWiisN+jMEHUqO2/M8hOkNG1bSuuDITQ1GLu07aZEOQNATrHOXr9sVAHuRGg8q2dLBQ234p9gK/i3qi5Lh2Pk1H6c5h35ovjcYx7QFykOmbWJQ3KeRbmvkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 04:37:02PM -0400, Yury Norov wrote:
> On Thu, Sep 04, 2025 at 01:26:07PM -0700, Mitchell Levy wrote:
> > On Wed, Sep 03, 2025 at 06:19:25PM -0400, Yury Norov wrote:
> > > On Thu, Aug 28, 2025 at 12:00:12PM -0700, Mitchell Levy wrote:
> 
> ...
> 
> > > > +impl<T: Clone> DynamicPerCpu<T> {
> > > > +    /// Allocates a new per-CPU variable
> > > > +    ///
> > > > +    /// # Arguments
> > > > +    /// * `val` - The initial value of the per-CPU variable on all CPUs.
> > > > +    /// * `flags` - Flags used to allocate an `Arc` that keeps track of the underlying
> > > > +    ///   `PerCpuAllocation`.
> > > > +    pub fn new_with(val: T, flags: Flags) -> Option<Self> {
> > > > +        let alloc: PerCpuAllocation<T> = PerCpuAllocation::new_uninit()?;
> > > > +        let ptr = alloc.0;
> > > > +
> > > > +        for cpu in Cpumask::possible().iter() {
> > > 
> > > In C we've got the 'for_each_possible_cpu()'. Is there any way to
> > > preserve that semantics in rust? I really believe that similar
> > > semantics on higher level on both sides will help _a_lot_ for those
> > > transitioning into the rust world (like me).
> > 
> > I'm not sure I understand what you mean --- I believe the semantics
> > should be the same here (`cpu` takes on each value in
> > `cpu_possible_mask`). Could you please clarify?
> > 
> 
> I mean:
> 
>         for_each_possible_cpu(cpu) {
>                 let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
>                 unsafe { (*remote_ptr).write(val.clone()); }
>                 let arc = Arc::new(alloc, flags).ok()?;
>                 Some(Self { alloc: arc })
>         }
> 
> Is it possible to do the above in rust?

Ah, I see.

The syntax would be slightly different, probably something like

        use cpu::for_each_possible_cpu;

        for_each_possible_cpu(|&cpu| {
                let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
                // ...
        })

it *might* also be possible to use a macro and dispense with the need for
a closure, though I'm not familiar enough with proc macros to say for
sure. That would probably look like

        for_each_possible_cpu!(cpu) {
                let remote_ptr = unsafe { ptr.get_remote_ptr(cpu) };
                // ...
        }

though personally I think the first one is better (simpler
implementation without too much syntactic overhead, especially since
closures are already used some within R4L).

Thanks,
Mitchell

