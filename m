Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2E76C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 21:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06E66B0005; Mon, 13 Jul 2026 17:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8976B0088; Mon, 13 Jul 2026 17:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983606B008A; Mon, 13 Jul 2026 17:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51BD66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:40:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2683A01DB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:40:25 +0000 (UTC)
X-FDA: 84985072410.06.B28ECF1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id AF3A440004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:40:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cm9pnHT9;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783978823;
	b=IcTa/l+iePqbDsVvrBKY9fdHEcdSRK3NR72kLrxYREwA2ELrKlCvBMq66C4OUZtvL08lv7
	86l/YHyQqStgMnBiXtinc+dazJJLlp8csuSeC8w8UG0XiL/BVklWu9xihNNY8RTzHogYBh
	KQEEnEu/8s6ZBrC27z1xX+BXqdAk0u0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cm9pnHT9;
	spf=pass (imf17.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783978823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTce3NANGkMxQwl5/BPNI0R4Y8vE5s2I+Fl2WAV2VZU=;
	b=rF9OuzLlMPkHp32OXnZ9E395yrVj/ZtRXhx972xwPTM/pJ/84h/AfEW+qcNf2fKWguY3PG
	9BO1tYYyQdqB3DL7ZOc2As+Xw2Ad2+kH/hOPZOUkjNqFPSKZZDpWNO15Hcio8+IwmHz08B
	kNgh3q/5A/nXC7AAx+kwvt/uoxQNyYk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783978823; x=1815514823;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bTce3NANGkMxQwl5/BPNI0R4Y8vE5s2I+Fl2WAV2VZU=;
  b=cm9pnHT98Jjq1CPfmYkMF4X59BaOVTbqQOGkbZw3g3tVvSrT78JYT0Ot
   fWyOKrLKdHnkVizzYLGoPQtA12/s1KeNpcAHX7ckNEvpEK1CnS+9qO+VD
   mPtzUyA98JEZx4s06c7Hpn6Oaax7VN3RlBdKQ9TduNAkYkS6F7lmI2fpS
   fnWrHRZkLgkwsN5r5S5MnUv4P4lwaox5Qh/ZEYqgS0mSks9DHJROqxJu9
   YGSVIvPCSBl/fqKVae3K0sXHim0fTqsEz5uctqpYuUqe546MeWYupQanq
   DcWaTk/R0LZc37Fvy60xi4TW/sS+e1w1xe4rwQ2TasonK0iE2HiRuNtC2
   Q==;
X-CSE-ConnectionGUID: TrOlxkX/TiWnbzpGLBrtRA==
X-CSE-MsgGUID: YBPnp7MPTuW/UpX8tRgvXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84613480"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84613480"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 14:40:21 -0700
X-CSE-ConnectionGUID: zjSlVSWlTm2TZi8lRy7/jQ==
X-CSE-MsgGUID: Ohjm+R33SxugWQdGgvdrlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="253927987"
Received: from smithj1-mobl2.amr.corp.intel.com (HELO [10.125.108.83]) ([10.125.108.83])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 14:40:18 -0700
Message-ID: <14e250db-1641-4085-8d13-02f819657d5f@intel.com>
Date: Mon, 13 Jul 2026 14:40:18 -0700
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
 <710b7eb0-8e0c-4f07-991c-2285c77e1beb@intel.com>
 <6007625e-c3f9-4ad6-99a8-61396bccbcec@kernel.org>
 <32d459d1-ad19-4baf-bbb1-0565458001d2@intel.com>
 <3ea30f8a-bb29-4bf5-8400-1c4840d46a88@kernel.org>
 <7e84b200-25eb-43a6-b5e2-5f27f2d82a77@intel.com>
 <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <31988089-095a-4eed-b5e2-c677c70f79f6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF3A440004
X-Stat-Signature: qazccqzy1nfb6bskuj7zu9wfofrbt9hm
X-HE-Tag: 1783978822-952769
X-HE-Meta: U2FsdGVkX19LJwoOL4fMlmXdfUX4SjJXeMv1w3LRQwEEGHRcD+FZFpASsQxHFp+kskRToomK0Iuftk8zWOT15vNRUsQaoFyAwo0jXOmF4z46PzUNWrbqX4XFsyZ8znKkRzojzejf3+GsigztxECwATTV+J3dHLtPoN8knHhZtJ0TKJN2sZq724PNmHhfYXF1cQ2jL2+mAOHrF7G9pfFGS5T5ZxWz5l6Q01PCE+uzZ6eS8vqgI342wlA5UBhb9BTfq3FVEFdxujEQZidtb7eDrV7Yd7LDLucdZiMzLqr8KG1od96PRrU54IJKiAfN0NceYb4HBa3OoR2uaITajx0/k42U03D8n6ot8CfitvmvRuDfnCpoNV7P65ldWg6REb6H04CXKN66hw+83/FkjZlvZgq7t3wXGvj2RQEJ8BOuIdMHWTBkxD2yyYQ41TZl8U4cOfzbyWLQ30/x9SXqw3WkdRdOt8GiRGN9ryoASshRkovzTPgLIDT6Lxkm6Sa9HMOXQFXbaT7MBsIMUIH9QhSdh4X2ROX0JZ9KCFQvhMzslCawWpmRNRJ38ViLUpHlx9rFD8icRzC/Nc28IV5ZoWdl3nWekSVyGdFangQoJkSjH285jDkFOCU9RwxHNh0LD+Yn1Z0ijLtYBtpCMF2AbY7pvyKRTo+sUOAXreoFIEWdKF126IkssviyyTQrPcapttSKJC0N9b67Ro3MhyuMcOEWQPFbHhL5zLQV7XwDHCMz02kphLf3WsmbojE0K8dfIDBE9nfzrgbwj16w+m/asWhooPieMKhMv2Bn0s9LFMvcbyLoUEDWTNpAldcIyNcp4DU7VEt6rTyuVGsAKT3Avg/YziuHW5nTkStGUauVd+f0wX8W4hvDtiwEB9VLBcUf+eRGFXi+8UtaATMqTnJ3k9y6bTfBjJOxgsipZ2siIfy737lr9f1B8Laq7LkIa8q9KV8KjBCDVH4db5HSzN8EVDJ
 nepqhCdj
 u7mxEW98Mr9unB2Z7LkiCjfDfF1/5ejXHx2y8l38LaKTyWygvre1LNL1EhEvh3uU2+N320W2c6cbt9Hr4Veymmlscsv/OXVOAkYuxlEkHYHNfJAxVw7vrx8jlmiPaGb4zfW+6sR1hPPY790IMvfvYCrXcSSlwH40yXbP/aEOCHYnw5nSpAQcFWoBNi4RF2279q2fM6LQPWfeOKv4720pk0PZZZfprE2a3kgul0y3+xF6Z2LAkXD2x3Vi5/d6S0wL9mzKsPjNcnZe5eyX7Hw2W95/Yj4b7Xy5VkpRGBJu6EP56gP94YbPkR4WgLqsszQJ63uPFCVIXGuefr6s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 14:17, David Hildenbrand (Arm) wrote:
>> To me, the double READ_ONCE() is a non-issue.
> To other arch maintainers, it is!

Ahh, so it seems like Christophe in ppc32 land was looking at this more
like a regression that needed to get fixed.

Christophe, just out of curiosity, was this something that was causing
you practical problems like measurable performance regressions, or was
it really just insane code generation that seems unacceptably suboptimal?

