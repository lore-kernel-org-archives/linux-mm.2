Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E36C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 20:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29D46B0113; Mon, 17 Aug 2026 16:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02066B04F0; Mon, 17 Aug 2026 16:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF30D6B0874; Mon, 17 Aug 2026 16:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B61636B0113
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:16:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 504FBA32CD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:16:06 +0000 (UTC)
X-FDA: 85111867932.01.DFF0F81
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93CE9100009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:16:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r90QzBfT;
	spf=pass (imf05.hostedemail.com: domain of 3AmyDagYKCEMxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3AmyDagYKCEMxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786997764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIaLcIcx0/JCu0rIvBOyaVIEo2fmoa+vo14Zh85W4qc=;
	b=x0nigNrYHXf56qkCUIgbpA8cMlAWzbQS9XDQF7n8FbU9rLr+FiAkU2rU0GwgrMkBAmAPkL
	xuWhzz8e6n2aG8sxZZO2NNG/zAWsUbmzABZlLzYgjlso9yiIngUme46xJUYAqt6aHkKcZx
	gXYIGz2nZ4KBWSlzemWE85oNeZLHgsw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r90QzBfT;
	spf=pass (imf05.hostedemail.com: domain of 3AmyDagYKCEMxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3AmyDagYKCEMxjfsohlttlqj.htrqnsz2-rrp0fhp.twl@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786997764;
	b=Le1mK7ProIH+t0PRtXciDs/qwvGkvhumgjzadpX+qsTBBln3J6/qzU8kaygEFCksXdXu5v
	f9HAm77FuWrYB6DJ46oirREByH7PikIBuJoOpjmBVU48xsGyzbe3D71Z4PrPhkb/OlwShv
	nnukwWXpHyaY3zrGbwBVsVzyjFp2Dbs=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8484b9fb055so8761192b3a.0
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786997763; x=1787602563; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wIaLcIcx0/JCu0rIvBOyaVIEo2fmoa+vo14Zh85W4qc=;
        b=r90QzBfT2+ecqMUmuIpXuNs60TNu7cF0JeBuOln3rFz4HyIBZ7hcvc30LwGFy6d5Ov
         kUG1/ql22gUqVw4Lc8KFiwSP5PxJu5yQYq/+mdnDuLHOXXIK8tPfHbk+sZlX7SDg2m7b
         NEtudpQat91haf95HrvXzZG4wNf6Hl/CvbObsOdb308oXzbETqJSimRmcym6A7pS+Aha
         IOKkFs4if17/pdcf23aRzl4M+s2RRR38ZzLFYfi7EpMk39wKWnjtrXjWDUXz5rTfxAld
         M8uOPfpKlad+1VhVlDDbkSR9xzleCiM2ip+4JIQK4ow/kk3bp22fqNoL/zQVXdC9fgZe
         fyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786997763; x=1787602563;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wIaLcIcx0/JCu0rIvBOyaVIEo2fmoa+vo14Zh85W4qc=;
        b=OvrLrRfraWg86a8N9jHTaV2pdIlQCdT3bZH3LP2Ejmbe0XZY6G5YNEMCmEsHxQIJqz
         bFkU3XC1dtcJviJXYixInNAXz3onO3FTF0taU01l8iwLd6a05RsJM42hTh2mcw0pGdX2
         kN0P/uwuV8R+4wpD90F7/Kkezbk6AISGTlqFnabbyqhNTS2KAyt6LlYw/SKLVYS+gmOl
         3YzRj8sqnr93G0SJX7soZgxcoIlD8zPNPx/0d5JdKuYiPSPw3enB6no0FgAXysaEhLR0
         RVGT4xHmepjyY5kOSBhFvOKFX9h3FzL+0hOpcpxsxIwPzsOZpeGKEVdZUi8Ywuk1K1TH
         OjzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq5EMWFHdVaiK0W5VN6eKdgzybgC88OD1o9/xAQK2292Ci1m0HRygV4UH/O8q2X2Uk8Mdc6e+tbEA==@kvack.org
X-Gm-Message-State: AOJu0YyjqI2b1VQgMv2zuzk5GRLzQia0icu9Mh833yD26fIRzMijQd3b
	wyGmyrMNcQiKvQCizf54qLR46+SKJp5edCostr/xVQR+sf2EjwGZEXaTGqUopjsI53np+p5eIX1
	JB0/CHA==
X-Received: from pfh39.prod.google.com ([2002:a05:6a00:12e7:b0:84e:24a3:b91c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3016:b0:848:5540:2377
 with SMTP id d2e1a72fcca58-84fde13600amr27080475b3a.17.1786997762969; Mon, 17
 Aug 2026 13:16:02 -0700 (PDT)
Date: Mon, 17 Aug 2026 13:16:02 -0700
In-Reply-To: <aoNlZRb5SV7hyNuk@google.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
 <an5AcEG9mqDgnBYk@google.com> <CAEvNRgE+05c9U8C=Zkm1S9hLw3Lw6YMmijZhEe7J4rYQAuNyEw@mail.gmail.com>
 <an8umm0qisEidt4n@google.com> <CAEvNRgFNCDDSeuvbwj7pD_d18o1TBXo4TNR2dXHxpm18KPfR5A@mail.gmail.com>
 <aoNlZRb5SV7hyNuk@google.com>
Message-ID: <aoNsAmLSKCuc4v4A@google.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93CE9100009
X-Stat-Signature: yqt41jt74wgbiewmwn897i6u553xn5yf
X-Rspam-User: 
X-HE-Tag: 1786997764-581585
X-HE-Meta: U2FsdGVkX1+iGxtMSsfPMm3kkBXdMhfsd318NrP4Tv7cvPAW3qKAW641cmthOGZj2EQzxvATrs47SrecKSc3k7Vp/Tl1rTsogMKSurjX3lwvdOY99N2BDLqZuCnotqNZAZfJLJQZ+e8i2bAzfPuXRpKoWFHJ0FmAnCyXaydQfqIXwXnLNXdcIVtzBO/Qpf5dotM8kP9FveQ6r7PCy4Qb/pYEqpB8hjOX4QFZ+rrYB8vick5Z6+n4Ayt6Vd5jrqKjqkyXbhIakgajbQVI2HE1+QNmelQOXODslTv1XRcuXEE0WLM0bbcTLYw4ureQJgVFCwuSt5e/Nle74FuzuwPLhetWqPzrN0ybV61c/6sEM8o+1A4CzQUBmCDN48xwNjnI1c6mWnvXMplQTDHN+P+g0/KDlTKMdRTC5/WaGSjxmdY15NHGm6poBiG/Vd27AZAprOSwGddhOxcJAulNOAp2wAHeytNelW4DOfFuLUASvUo7S1CFiTX0DhDm5fCpCG6hseMDqyZhVt0hL3b3MiBIuyKyZw94q6El81/NyBRtdDealkgK1cA2GBp6hEpis62OK4ifKyN9Es+WffSgTJbAUljNBWzydz+CbGnMdlRBwy0kprwEdSwomVoWbgj8wk9y7ISl7VbBluxsknSG6TV1UgRpiyOjBDlOBFhS8O8CMD2HNBEZeCJwKyz2qd1AgHvmfvMmIg9MTyf76IbpF+FBDE38WIu0hGw9K+XRuGm1KzyVkALSEbnRDRLy+WzxRmPZqv1S5lK6mkulTYbRerwJNgfGTUZR0ssYfHuUl+Jq6Yw6bGoUReaeSJqDsf8XjVjGzHKXn3STvws9Bck1wkpjwCGkRND5aU0JaXjgM6H/WEL9VHbiOy5KSBqSDj2CAbCuYRJL7DutXQOzK7C7JmjERkxHmYHWFGkHED/IeWbwfUS4HCvY55APpQG09b1yZBHpHyVv2KSYEDqLbuaUPpD
 iMYskxS5
 6mfM1erD65pVA6UXzuqrdGaVsifDImSP6uzWJC+E2MwEusBBC+R7lEcFZqRFTvdhm3cbOJcNmSEWDGM70bGN4zeLyEAqkq0CM2nYlzxi1epJ30mpJkdHU+4kLHv8YlrNgM/8/3m9ixInK2sR8bsueXW8dm2CL1XChwCUYld0V00xgyZueToQGdFPR332oMMoMAP7vVPJvRjUev7QjuLP1yJiFgjNh3c1l/D+6uTGPoiTDC49rD643sZw6Z2/hGURuzNhSmnJj0+wPgAp1WGEtq7UZAu93r/1gTGW50eMTHOMwtPOGZEH+qeApB1Y201nTrbTw0k8S1YAqXFXS6srxREFPAjKPLSkT2JWib+BtHH/144k5KkrPCqDruI1SP3gz46RT3otBKdTmeXTAZghCrLSuUuC7vo07WBJ9+gaGcizcf+elmQriKhCjdq+W8ZY85qyapLQE+rhydM8mqaX43io7kczAhGWpfADWGlEV+OT+T72Nyc/iXVblwldJs5JaGtGaz3RqM1b0h+E/3oALnS4vVvXT6V3g3r9V3Kgkzoqiv4PhsMft8EhWHY6SvBf8rRztvU2Re7Odc2UihITLjsoNI073OonVWSh1JhDk4KFQ3/dob+mvCnXjnhlCprV5ZY35GauyJ3GHcjMg9dLOjOixQW+EPgZ7bc0m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026, Sean Christopherson wrote:
> On Sun, Aug 16, 2026, Ackerley Tng wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Thu, Aug 13, 2026, Ackerley Tng wrote:
> > >> Sean Christopherson <seanjc@google.com> writes:
> > >> > That's why I think it's worth analyzing the cost: if it's in the
> > >> > noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
> > >> > the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.
> > >>
> > >> Is noise defined relative to the entire conversion process? Would this
> > >> benchmark look like
> > >>
> > >> 1. Convert 4G to shared on TDX with CONFIG_AMD_SEV defined
> > >> 2. Convert 4G to shared on TDX without CONFIG_AMD_SEV defined
> > >>
> > >> and then compare the difference in time taken?
> > >
> > > That'd work, though I was envisioning something even simpler: use rdtsc() to
> > > count the cycles it takes to iterate over various ranges of memory.  Do whatever
> > > is easiest for you though.
> > 
> > I made some changes to add rdtsc() for the conversion process as Sean
> > suggested [1], and exercised conversion like this [2]:
> > 
> > 1. Initialize some memory as private
> > 2. Get the guest to fault them into Secure EPTs
> > 3. Converts the memory to shared <<== this is being benchmarked
> > 4. Converts memory back to private
> > 
> > I made it build the VM once and convert 5 times:
> > 
> > ./gmem_benchmark_tdx_convert --iterations=5 --size=1g
> 
> ...
> 
> > And here's the above, tabulated:
> > 
> >   nr_pages      make_shared            total    percentage
> > ----------  ---------------  ---------------  ------------
> >          1              930            39278       2.3677%
> >          1              252            28060       0.8981%
> >          1              176            26952       0.6530%
> >          1              176            27038       0.6509%
> >          1              176            26980       0.6523%
> >          1             1072            37236       2.8789%
> >          1              316            28338       1.1151%
> >          1              176            27182       0.6475%
> >          1              176            26972       0.6525%
> >          1              176            26886       0.6546%
> >     262144         15041018       6616067680       0.2273%
> >     262144         14937462       6608542680       0.2260%
> >     262144         15138858       6599494898       0.2294%
> >     262144         15721972       6610219850       0.2378%
> >     262144         15000406       6615114540       0.2268%
> >    1048576         61902982      26400884028       0.2345%
> >    1048576         61746114      26401170984       0.2339%
> >    1048576         61096794      26404409058       0.2314%
> >    1048576         61446290      26447461896       0.2323%
> >    1048576         61774646      26444608360       0.2336%
> > 
> > Looks to me it is within noise.
> > 
> > I also actually tried measuring the conversion time from userspace with
> > CONFIG_AMD_SEV enabled and disabled. Converting a 1G-sized TD was faster
> > by 0.2%, which is in line with the above table. Interestingly, when
> > converting a 4G-sized TD, skipping kvm_gmem_make_shared() was _slower_
> > over 2 runs. I don't have an explanation for that.
> 
> Might be some cache/memory locality benefits?  Though with a conversion that big,
> it could also be nothing more than bad luck.
> 
> > I think the code was correct. (If it makes a difference, I skipped
> > kvm_gmem_make_shared() using a custom guest_memfd creation time flag and
> > skipped make_shared if the flag was set on the inode.)
> > 
> > I thought adding a kvm_arch_has_gmem_make_shared(), defaulting it to
> 
> I would do kvm_arch_has_gmem_convert() for consistency with the Kconfigs, and
> because the cost of the reclaim invocation is a non-issue.

Forgot to say "why" I think it's worth adding kvm_arch_has_gmem_convert(): it's
a trivial change in the grand scheme, and I can see the ~1000 cycles of overhead
being problematic in use cases that do many one-off conversions, e.g. for guests
whose shared memory is scattered all over.

