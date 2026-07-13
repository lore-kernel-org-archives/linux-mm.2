Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E301AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10FB26B0096; Mon, 13 Jul 2026 12:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024076B0098; Mon, 13 Jul 2026 12:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2DAF6B009B; Mon, 13 Jul 2026 12:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A18376B0096
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EEDAC0A89
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:55:34 +0000 (UTC)
X-FDA: 84984052188.18.2F05DDA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C8DB140008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:55:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qc030D6t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783954532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MfDofiY2Gmbjmnj1RvYUotVS2zPd0Y+nfag8esS2yk=;
	b=d+LNdKvgeRSbq0VGisHv9mGIytBi67tqTQaGkrQLPDyU1PQlU8+Af02y8V/82Epu4KIzww
	g4innTPwEinNGiIeYttcAXyr4iOoUC4fEYtRpwFfaXYYlZvyq7Vb/0leq6ddGbndXfSBB4
	5IBRAgAF9vvUVXYHCKYjaabY5/ktnjI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qc030D6t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783954532;
	b=DhxHCKBXNwdUZRsH2rnIlUjBded9iT/XhpWKunHyLhpKOOxIW/gW5zrPb8D9SqZH10eLoI
	WGc02JB7qvMblD3gxp89QDwMd43tZSp3e9nmeGWNzL0ijuRLBzSoiHb4RG0NUs5g5Kgz7C
	v1piBam45tJAopyJp1F/Sb+R0+yovYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783954532; x=1815490532;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0MfDofiY2Gmbjmnj1RvYUotVS2zPd0Y+nfag8esS2yk=;
  b=Qc030D6tin3vPa3gAKioY/tWLzsuMeZ3l+A6xDkO9F4ly69c3yf85UOA
   VTuKVYaWNDms9o/MCWwzrG3U2+glYhGEsRDC4cfrKwluH+yY26HyPYDUs
   14uB+SwcokMnM+Hi07mLGu0Jf9jlTcjBHNv0Sf4yAzqpeaXbgzIw8mzqt
   sPvz0yp1wr4lPOLyMQ1RvIMdD3QhNXysu+xvQJXmz5FFTSeHnWzSpZvS7
   Kjw1L9i+zxqJcKFCq37kXiO/JJpggaVBJHfV5yub3tCzQBA0XsgwOcS/L
   5seK9Pxcqk9QsLq+RBT8trm+ZI/O4jKmCfeuZ27VLg15PQLs1vBVLRYGb
   A==;
X-CSE-ConnectionGUID: cI769ZBhQLWEntw8vpOhrA==
X-CSE-MsgGUID: VnYR1H+2S2OFmQQg08M2/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="102114276"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="102114276"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 07:55:29 -0700
X-CSE-ConnectionGUID: 8iQLhZ6PQQm6Wp6XafDZ/w==
X-CSE-MsgGUID: myzw+Bw8TMuHbEAQ1H/KWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="253839285"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.108.45]) ([10.125.108.45])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 07:55:28 -0700
Message-ID: <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
Date: Mon, 13 Jul 2026 07:55:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/34] x86: mm: carve out the generic compile-time
 folded pgtable case in effective_prot()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org
Cc: linux@armlinux.org.uk, akpm@linux-foundation.org,
 ankur.a.arora@oracle.com, rppt@kernel.org, linmag7@gmail.com,
 chleroy@kernel.org, klarasmodin@gmail.com, chenhuacai@kernel.org,
 kernel@xen0n.name, kas@kernel.org, zhangtianyang@loongson.cn,
 wangyuli@aosc.io, tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-11-yeoreum.yun@arm.com>
 <c3edfb13-08ec-419c-bc05-8f3f64186b24@intel.com>
 <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <ac365196-8ccc-4d8b-83d7-28fec763e75c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6C8DB140008
X-Stat-Signature: qqbuif9t8x9eqmmica5w8wb365uppitm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783954531-609543
X-HE-Meta: U2FsdGVkX1+sBn52aBXNJVizS+GRtidKfxS7frqDFcR2NTbUxCFy7KSkPfegaBfsY2HnOdwJAq0pQ8NBJHBe+/GJEOaMCx/qoUqwU800SGxMEqXDDaS9zYT5UcwzrouotD6LcwpZupL4VRxz/2HYRcxyCosqIClEY1nXV5amAJNaJP7rPhpX7QYsAGGvC4pJUVeAm6O0SCnHGI/0Ln8e1DAhJ/4mPKK5VTcWJH60Oly0roI1nFficOpn0gnPzMncNbRU3b90dg1OS8Qw93JNi9IH8RbfEGUCEpUZr7mIOsQIwap6B+oR/IsbR1c51cKRpkQLNrVl00Sm0OqkSwUFUoZLE1PXMNzx3pFt9hC8x61V+f9TvSGpgFRG+1rYv09pC8O/5nBOMgW517r+Ft5abx41qmqYaxMdPdvnAzO+lGewABP0THCQ76Qzeg/juSfNmcdWum8xmY5Ynl+8vaKzEXB3txDaSaLptX/71f0g5H9wDltonnsDjSjARARPAMby48PlF50X2F0jrDVJChpueLnETqgCqED6rj8l9jsicsSJUIP3L+RanhA1XgJDp2dnx/9LdL6YVpunndAe5zhHVtFfnk29Ac+L7XfVrPP7ZYvqR0bk221vkOuGWmLrPX7uzNJUlsivbB9ycbGdCYKBE0ZrCJfit0BKZxSO+9RWVkPwYsj2tLgZTO5j/8EJQ6uLy2Z/zCT+LtAqt7nC0ZdDDOSbSGdRvKy0RHSoGUxM6VteOqsw2XuXY4UoR0RxcuJ/+QSg9GcH/7R5+vYI7auC0kF9yKTrhs1HNdsOp7Fd7+8+iwWoZiiGGBVEhAKDfa1EWoxneDRibOye6CbK/Jp00QZgDPqPjpLCtP+mT/fQrK0nHal0rgkh+4wKkMfZDftimtpyf2zHUOKF8INbO7aN5smpt0Z8owveuvZH0O91tnYv7s4O4dirbAdHxI7iVhBww4v+UiLKbppS5nypwXA
 HtXKBiD/
 oiRhgYggRyqRO17As+heJhsixjxbZb9v+QdE8wlD2BnWqpx6pg9JDT8+4IP6JGHkIuKKelCvGcXsxttdi5fF27GwB4pWOhiegzZJDawFBc9SpaPY24Uemk1ljHz6gY9xgeT0KvKtmQQyFvKy8+xUFA8C/ZhlpfUjn6TFPkpb/G07dHP6ShMYpSAK3VM1y/9NJrlewEywLEPZRcSw+cQqvwDVguk5p8V9EnbpUFnULsl3SFfEyfCgV/tio5dxxju33ad1BE2zVYPP8AeP6V8AlxADPlQs2DaVFZnh955ED/h29u2w1u3hdcb/ChHG0yWoxJTvOsYG6/ekpAlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 07:41, David Hildenbrand (Arm) wrote:
> Essentially, we have to teach x86 code to ignore levels that are folded (e.g.,
> pgd, p4d) and start collecting effective prots from the actual first non-folded
> level.

I guess that's what the series really comes down to.

The model is moving from (using 3-level PAE as an example):

 PGD => ...folding => PMD => PTE

to

 ...folding => PUD => PMD => PTE

Right?

That's actually not the worst thing in the world, but it is a pretty big
change. It moves the software model away from how the hardware works.
It's a bit more grand than I thought from glancing at the cover letter.


