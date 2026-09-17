Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9666BC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 02:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6BC6B008A; Wed, 16 Sep 2026 22:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6802A6B008C; Wed, 16 Sep 2026 22:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5465D6B0092; Wed, 16 Sep 2026 22:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24C9E6B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:07:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C74F1C0BA9
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:11 +0000 (UTC)
X-FDA: 85221616662.08.F46026C
Received: from mail-pz2-f25.google.com (mail-pz2-f25.google.com [74.125.228.25])
	by imf19.hostedemail.com (Postfix) with ESMTP id D58DD1A0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:07:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fmz1E8wO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.25 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789610829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Veq/d5GG4sWMYx11wlD0mjBLYK1jExJiTNsjFaM3d/s=;
	b=GLgl7uuXTANBHZhVPte4NYf0MMbdgGpZGCitDOAZuJKIlZyiXywZeo/sMK7Ejkub2iRTAN
	kIO8djd+NHgtHouRwOfG/rbOlCXZfdANBzduHm7C1Z5TA/Uk+8magDQwbTiCpSKou6cCKf
	L/2LPbcvHptsHOeJ95GXp6BVkREw9R8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789610829;
	b=Cqg9MIgJWZyW29rLyf8Eey9pbWkO4/QcQWUpybsu6yMFbchmyn4wwZEGuqwbX6o5a7G2c+
	ScYuU7/9RP9M/3BYpdzzmkBrikR0NaWmOt0Z5G2ee4ioVicoNtLmBkKZEuibeT3qYoamUU
	Gubn7Pj/0ZgTzbCRpL0W5I+3rvRDyv0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Fmz1E8wO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.25 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-pz2-f25.google.com with SMTP id 41be03b00d2f7-cc1cebad4aeso200565a12.2
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789610828; x=1790215628; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Veq/d5GG4sWMYx11wlD0mjBLYK1jExJiTNsjFaM3d/s=;
        b=Fmz1E8wO9GsGsoNZkE7rPt7L6e0zkXVdSJ1SFyDL0S2xLXujhL41R/WVq1bHbvzngT
         7bi8h+zwYd2vTs9M9L+cVl8guddrPxnGR0vCQDf9Th2RkdpZz1jTGQRP/MDxmmJIoDqv
         o0wd4+Yl76rKVOqNbjnMhWAkI8tcpqRoEzODA5FJFfNfMawf2xSFOf90ZC0reofmv4Er
         B6LakwBkwN4GT4bEV5ANKNWolliN2zgXMEsgki4GfUXYBR/GtyID0IQ0sjjuDDciMVKg
         jrzi+2p6/y3L5+GJhsh5rm4w7J/1i52CJKj/NIi3HLpIt415zxEZ/mslKJBUkJQaadYn
         AyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789610828; x=1790215628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Veq/d5GG4sWMYx11wlD0mjBLYK1jExJiTNsjFaM3d/s=;
        b=YvfJQNtPjSAI3oJqpMS7bAbTX5Sd2J6cSZpV9KMX0mrfBa5jDt9SUTNFChjl0ifhXs
         rDJU1lTWEVMOKhwAxxFz2585vOfSiFfvaNBcANJtGMywHggOb71C7j17nabxTmYcBP2J
         Cf2yUpytaS9X7C3Go4nDQ06UgixBeBNbh/nNDjudT9bdSqq6B3OsUBb8pvR20ARIYptq
         EnFpo1uHSnx1Z98lyddK8tiINKXPuK3Ut42pDMA/Pj5Nakew1QW5NurrL2ZwUOGJFXsT
         jxx5tN+Mh876m70rGqMVuuJ+4mjl7WgjD6C+LRVaGUKVD0MdC8X7SipslR1U8kHZ88Dq
         dBBw==
X-Forwarded-Encrypted: i=1; AKwUvByCgdTq13v63DDWiKSaK4x7K+1sRw40WfKeajFkKPwIf9m0MbGoCyxITfpMpciPY9/Pcx46qrNIHw==@kvack.org
X-Gm-Message-State: AFuF++kcXFzc6sBI1yLe26DsR3yDcsrW3sbp37xnLi3+yZUwvPt0riTg
	3md55K652z3siEFcA8PZB4G99DvNun8H9t9k0xTSf8fR+Yf3NdzTs797
X-Gm-Gg: AYBFou0JafB42RgBieGRKHZE6B8RErk2Ml8xpLTxcQJrS8ydSq7vIsULwuUZmgjgNYs
	5TKe1ZQF1bTl8V9zSEwQbGEsA5UR+Vu4Spu6uPrZTeqanCbqYMjWys9jhKRAoo6yeTKo2flT5Hg
	CB+dCARoQdptG3q03L/uZSyX/nc6MGY8M8uhZe33gwbs9eoOOvu88S55h6cbH/sLP2yhaVJgX60
	oZq+CJQQ9hXGKGyTmEHi5SDHxoNYzs8JZ5ifS+v3SvnQ9XpZe3QXk41rS6T0FXECP5K9besYmKJ
	ba31CQwhqQwcxyH80U+MRFrSlehI5Ig8UxKVnIAxF0ewVSyw/80rht02IBIgXoWKg8Yz2VwVa2K
	qzMQkWeDEy2NKl9/88u7hXO1lDtuZ2W4F9sGAq9EIy+p1spvM9EmVG8PVZNv98EjghlxZgAbCS2
	/82cs7ov6EfkJ93yynOvZLUJ8hWC7h7+xyUEy3WFP+PmgIf5pMGfhUNk+jrGoFa+lkZVewTV6iv
	G7AUUBg0OFf33dU1cntP8Z+Iyx5gGTzq3JF0N+D
X-Received: by 2002:a17:90a:28f:b0:39e:2530:2102 with SMTP id 98e67ed59e1d1-39e253026d9mr9151823a91.11.1789610828473;
        Wed, 16 Sep 2026 19:07:08 -0700 (PDT)
Received: from localhost.localdomain (vmi2317699.contaboserver.net. [85.239.239.237])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e39b0399bsm383108a91.2.2026.09.16.19.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 19:07:08 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net,
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: Re: DAMON reporting more hot memory on huge pages (was: "Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports")
Date: Thu, 17 Sep 2026 10:06:37 +0800
Message-ID: <20260917020653.46010-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917004533.89744-1-sj@kernel.org>
References: <20260916051150.107931-1-sj@kernel.org> <20260917004533.89744-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D58DD1A0003
X-Stat-Signature: gidrtsp34k9k6fdjth75fmbtkupxhts8
X-HE-Tag: 1789610829-615197
X-HE-Meta: U2FsdGVkX1/nXhMjvVY/dxkpPkZI2lhqpTt5hUYxv3rlT28HMiUrYDDApOaG1lrqBLYKV/5VVRQ2xsAt8ZrpWjtdoDncOYKeVvE8tIb/+tzOsplQwoCfWmZK7zsgUmvSlQcoRPfB6dZpWR7GpLE54vDYzXw8MQ91NzKBXVJVzelnHzejtHbqQOX3boH555SReBcs4rOhIx1k7qKp7cr/dy0PXhGuZpo+JU23qcvIdh2oBDjrCDK7jVELtNUPAwlA7tIP0Ed8aR+jCC4vsdNMjpcV4eq5r3y91criAOYYes9XdagDygZPqoQIf1u+otIXjNzrXCHFPgiapL8e94PXJ/ndmH9aAkbUA80aExOA4oC41qhVZ4v9j8SmAbalPIG1scI8vW/W6ZmsmAQRmdzvlXjJQlMNE7y1dwCm8u8gvewj78t1uz+CSgvwe3Z7PlPsfeKHv3Uiu7tnPU3JEq5oMIanHpLfyhaGDfM8yeSaiqVKOjObZGvoRk1h4teskJLNIHb+lbKAtybRO0n48LrmSOnju14sLnUOrW3Dvpz6P3JHdT0SOfxLwbDqsGj8c8/hvbsSFCvzvkGw3BeXxbWgm5bh9ymP6R9YcbZsdnkb56CSonok3RIGZbsqLGYatry3nIyjav1FOgjIDRIpa5HHXVYNbaNWab1C97dNmdzxD2MLIC+Ez6PWAmtLzwSbzEWv1pZDDn2rrA21t3i9IoevqR9RkoRel2/ifKKdUUJJINEm1kH50UMLXd8VS6hbdLSJ5wHMSrembe0G+/S/DDnGPLksl0DRXbETu1TnK3On15bLxiXw7YiXbKjZ9w55dpGuL2KaJTbPKMgsNPGk6yDpH6TEQGpF0LGIpZyPVY3L0Sxp3qRdUv+DwPZRGk2zOqNGUQb2+4PX4+QOewHVC9cmDvvCuiaYeVPI5YwI7vxrt/jFxlbvVPIPUM+RrD6Fac48mg99JsremzIPIXtIFN7
 IsWMoOeM
 XO/3s1BMwKPyoOlLUzBz2+KbZ4DyGVWEFVNf4jKnKxZ2mpMAroKdKrwr8t5jOAjhE7Xkx0byWcJSgn3SLLy/49hjSgzS8K7NMhBTzHdEZ3dy9bcqQk0nHe97HAsfGn6i3+/RFaLd5mjILbezeWAB1MZjHxwxFMioq1+5jKBZnMyfp0gCQcD5HJd+Bm/ELGBzFLuR3JF7Kn/aIjvbJnzelWA1mBUTZLDsJDRBavguTbPHMXVUabgzptvKQeFqjqzfXSZirsFiooNgIuPZkoR3jwG9onc1ruRs79JDwozRSOsGpVdsEVnioFTsXGcpyPwocf4+4lC/BIgqcOoEd4rs4GNQ/rkqno++BpWqjkHIjLqKwtRYW7NMXCV+kht+hM/u/J54q5NZg3kCp40V/Pek61K4I7Pt6mpcKRxq0OwK4196bZPXBrfArjyrLjqfhOnguOj7ArhCQDKIOOeIYtd0eZ/Ioig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for thinking further about this and for suggesting the damon_prep
direction.  Let me first clarify the real-world use case and correct one
expectation that I created in my previous mail.

SXF develops a hyperconverged infrastructure platform.  The workloads running
in the guests are customer workloads, and their types, memory sizes and access
distributions are not controlled by us.  Oracle is the workload in the case
that exposed the problem, but we cannot define one Oracle access distribution
as representative of the platform or provide one generally applicable
workload-specific THP performance number.

The platform has two requirements:

  1. Host THP is enabled by default.  Large mappings generally provide useful
     translation and virtualization benefits, so disabling THP merely to make
     monitoring easier is not an acceptable general solution.

  2. We also need an estimate of each VM's active memory as an input to later
     memory-tiering configuration.  If a small number of distributed 4 KiB
     accesses makes many 2 MiB mappings appear fully active, the hot-tier
     requirement can be substantially overestimated.  VM sizes vary, so the
     absolute error can become large on a large VM when accesses are spread
     over many huge mappings.

The reported setup is a KVM/QEMU VM whose large guest-RAM allocation is backed
by a shared tmpfs file.  Oracle runs in the guest, host THP is enabled, and
host DAMON vaddr monitoring targets the QEMU process.  The field observation
is that, for the same business memory-use case, the measured hot proportion is
much higher with THP.  The guest-side tmpfs 4 KiB/2 MiB writer is a controlled
diagnostic for isolating this mechanism, not a model of the complete Oracle
access distribution.

The DAMON setup is:

  operations=vaddr
  monitoring_attrs/nr_regions/min=500
  monitoring_attrs/nr_regions/max=2000
  monitoring_attrs/intervals/sample_us=500000
  monitoring_attrs/intervals/aggr_us=20000000
  monitoring_attrs/intervals/update_us=60000000
  schemes/nr_schemes=1
  schemes/0/action=stat
  schemes/0/access_pattern/age/min=0
  schemes/0/access_pattern/age/max=18446744073709551615
  schemes/0/access_pattern/nr_accesses/min=1
  schemes/0/access_pattern/nr_accesses/max=18446744073709551615
  schemes/0/access_pattern/sz/min=0
  schemes/0/access_pattern/sz/max=18446744073709551615

The hot proportion is derived from the bytes selected by this stat-only scheme
(at least one observed access in a 20-second aggregation window) relative to
the monitored QEMU scope.  It is used for later configuration, not as a
request for DAMOS to split or migrate memory.

As shared in my previous mail, our controlled PC and server runs reproduced a
large THP-off/on observation gap.  The exact-address capture also showed a
512-times difference in unique 4 KiB spatial coverage while the two aggregate
DAMON hot proportions remained nearly identical.  The conclusion is that the
current coarse observation can substantially inflate active-memory estimates,
and configuration-only tuning cannot reconstruct the missing within-PMD
spatial information.

> I still want to better understand the real world use case before digging into
> the specific solution.  But, I was thinking perf event based monitoring might
> not feasible for the case.

We agree that perf-event feasibility should be established rather than
assumed.  We will test the address space reported while a KVM vCPU is running,
per-VM attribution, coverage and loss before relying on that path.  If you had
a specific feasibility concern in mind, please let us know so that we can
include it in the test.

> That is, we can request DAMON to do some preparation action for the data
> attribute sampling, using damon_prep.  At the moment, set_pgidle prep action is
> supported.  Maybe we could add a new prep action, say, split_pmd?  Then, the
> following sampling memory access check probe (would be a kind of "allow
> pidle_unset" probe filter) will be able to show the access on exactly the pte
> accessed bit, not the pmd accessed bit.
>
> Breaking pmd would cause the overhead, but it would be capped by the
> max_nr_regions.  So the user could at least consider about the tradeoff.  I
> think this is simpler and more intuitive than DAMOS-based pmd breaking, at
> least.

This placement makes sense to us.  A split_pmd preparation for access sampling
is clearer than exposing PMD breaking as a DAMOS action.  We understand it as
refining the mapping used for observation, without splitting the underlying
huge folio, and then letting the following probe observe PTE accessed bits.

We will follow this idea and validate it.  In particular, we will measure the
active-memory result and mapping cost, check whether max_nr_regions also bounds
the cumulative number of mappings that remain PTE-mapped over time, and verify
whether splitting the host process PMD is sufficient in the QEMU case or KVM's
large secondary mapping remains the limiting layer.  We will compare it with
the perf-event path, stat-only first, without proposing a user-visible DAMOS
split action or physical folio split.

Please rest assured that we see this as a long-term technical discussion and
collaboration, not an attempt to rush one mechanism into the tree.  We will
continue sharing both positive and negative results.  I also plan to present
the scenario, evidence and tradeoffs in more detail at LPC.  Please feel free
to share any concerns or ideas at any time; we are happy to keep iterating on
them together.

This topic has now become broader than Ravi's hardware-sampled report series.
If you think it would keep the discussions clearer, I can start a separate
thread focused on huge-page observation and the damon_prep approach, while
keeping perf-event implementation and testing comments on Ravi's thread.

Please let me know whether this clarifies the intended use and whether our
reading of the split_pmd damon_prep proposal matches what you had in mind.

Thanks,
Lian

