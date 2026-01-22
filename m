Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC95D6CFA3
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6976B0308; Thu, 22 Jan 2026 13:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DD26B030A; Thu, 22 Jan 2026 13:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D926B030B; Thu, 22 Jan 2026 13:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 361CB6B0308
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:37:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C99A058E52
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:37:42 +0000 (UTC)
X-FDA: 84360458364.25.866E4BE
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA71C4000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:37:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ESK53roB;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769107060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
	b=AHvoI6b4w69sqvSggr6xG7We/ErT4K43mxVh6bivzhhOb7R77gUrwjBbqIu6PJ1Wg7Y9rF
	0Vd2Ukbn4wg0kZKL5vt6VRfRYrHlkh1moeOeX7l8kqfhqa+7OsNaRXEHFQEElbps2a6Ns1
	QVQwe9VV20mlE/Ym25gX/7KkUQbgIMY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ESK53roB;
	spf=pass (imf11.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.177 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769107060; a=rsa-sha256;
	cv=pass;
	b=lxwqQrcR1yNhcoFtinNur+O3xo2Y0Xkug+qO/fkAvSvjU/Q1qtIsuKKkwGLjBfxiWmoMz+
	43BaGFSMHE1RRqajx+IKIDqyEOGsMkgoZ51VI2Cka0M/ekaOJtzaIGSxMAz5JxEk+0dt7L
	8KbBOaYJXQl5nRr8i8D1KczuNnNHIOw=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5663724e4daso506444e0c.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:37:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769107060; cv=none;
        d=google.com; s=arc-20240605;
        b=lQDdy/Pj792ra3l/OILLsOGsVaEmkMJ2GEkzQtoDsBwCgmljpKEmbzvcN4cwT33hTa
         jyfJCMUARFN6hQqmPIiPdgJHhjVlaqkNVDgZwMyTkZt62xZp2cBm66eQU4q0gHJFrl8c
         IUXLBWZtczKa6FqczcMcC2/Vjg/n/qk4M7iwps5QYMY1Bz7AonAY7gsGWqIqTA4L6VaU
         A5Gsr9WSkjoiJ+gY34T2ZbSbwP5wk4XqxJBQHCbpoR+wOPs85b94EV3GV1Gdl+UE3iME
         OVhmIgmOJcralMNPunDfVQsx1Dih3J5YhGcRK5M3iCRDpJ2lS8O702igAiKV9GfD32N6
         1Vtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        fh=76M7TarZ78yl+ur2t5WdR9MuLgb/3neHwPVdS7L2MIA=;
        b=aK5W5sTQHzAIZ6MvDS/eyPVY+b44hUDwifEbi2TMhMmSQHul43Koe0eb32zrt2r5xU
         UmyaCm1wqXzVM985XuNbbwRx58ACaP9bFv5cLRlbHPDJeV8hAjEymuHxEldV0pU22UYh
         lTpcNgyetZoeUfqopTZ8W5MEIfzGtpvKYrZRlDthz6SC56csFrXVfJNSZES5GO1/XC3C
         Qpp0teUgYZiecV18UK/mZ/1OFZlahSH9BVVBn6AwcoaRV7G/7uGhN0a5wj5qMcJ7VaMY
         0e1TXbGJi1KtU1sBO/wUdZWJYRmpqqzTxvNb/sQFho2lzrf6y2gqJDuI0SZ889ycrJcL
         PKxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769107060; x=1769711860; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        b=ESK53roBqH3EXOtNCS28Ntws5WzxJe6QWZi9xaa957bwIK2k6y8bbklCDhNVIggRog
         yM1UU669N9lfGlKL3aWQx6OpFWp5F/Pz8htDtJrgknHeUL2IcmxVWdDCXUtxbngZcFKd
         XL2GRX/BUbEBYu0bSgeGYEupAfry2BfA1vpJOH7igcY73ve7m3tkwDD4cSHLswdVVYHQ
         dojpw/056gyHFYSb3ZeWFUJ7cXf38pECBlqn6a9JutZJiJyQ4zv4jyAaaLTOxRSb81Q5
         nVGcEvtPPfF/pqleP0Zf02Z/UHe0x8Dt1VRCCD9EGWv7v/Lko2ztsjy+1BGDDuUFg+1o
         JKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769107060; x=1769711860;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dm0SGSE+J6wsaq7NHikcDRa1xq67WXlvnQ6Xcq7PISg=;
        b=mb9IGAC29KOQfjPLkCIGW7R1H4dix6SBX6gBt7zkoy4F5IMHTq0Z7DiHhGDrOUN1A1
         Fa7nJGSsvkAGg5nXLFdojCfmNPrBGHEKnXW0Kco8bnQsKGs08POJj45SydX2aGuL71ka
         vXcUomukftki3feMpPdd5RUkrVPpzJOkeEXOEsp8Ys2VckP10A85dY9Q5ruAqnojIk77
         olnDwRF32yX8wkdV+MosF4XDuwNpKi526Kd57kvhzLIZfwLWxIRKFBpl52J3IXUxNbYK
         I8x/e2WU5JgSDpyvdYnA8T6b/oRau16JC+t/0wZh2H3G+mcPiteGdwDuKUCwjFmqXCXL
         oeEg==
X-Forwarded-Encrypted: i=1; AJvYcCVnnYQQ5HGTY6SwCc2tPIFWE9KzOHK92Nqrky3oirnlQeGvcpaoXOJeMwQu1uD6V/Hx6v0ga3g/8w==@kvack.org
X-Gm-Message-State: AOJu0YwS6IJZvtqpPF941hFKjZ97c2YgF+0yHbBp0tGCIe0J9y3GiOhY
	c9YgrWsEE0pMdXizz6DGgEAGk9EvhDtncqzzkyiKrXszx4rklhg8HbmUl5+cmaCmtW8WW1OljqT
	CQr/QsjwoYlJaNjlHgbgVkH6pb6N5DeJA3K/l2d1D
X-Gm-Gg: AZuq6aKtKuNGoSK2C7GtsSH/5z/senIgDoVe7jrNcIkyw617sbSLnPT/cJyvWXdPPgJ
	XOZIiqkyJgXGarHeQFrgG+fIsxRq23/S9ceaZIPU7gUMEEUoPT5oDos0NgzzJaqsuQW7NkbZhlo
	3T3Sfcnl527F8M4Bwm7QL6zkSZVGTmr8Tal68qhmRYd2oCt2z7QwnawK7Xf4/eMWfE90nIepGP9
	t1a0hcH0g9T5WKxCfmxu70Wp10UC1vWGa/5R8ZsewxHZjx1SXrU/AtCg+ZU0VSf4/fjCppKhNV2
	f5C3ims68JSDLZpv3IEIxUm0
X-Received: by 2002:a05:6122:1799:b0:54a:992c:815e with SMTP id
 71dfb90a1353d-5663eaa47acmr191602e0c.8.1769107059228; Thu, 22 Jan 2026
 10:37:39 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 10:37:38 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 22 Jan 2026 10:37:37 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com> <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com> <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
MIME-Version: 1.0
Date: Thu, 22 Jan 2026 10:37:37 -0800
X-Gm-Features: AZwV_QhFeXvGMv5345sr6hAOQL-xKTYrLyTeQaptQlhk8j2vfvA1j50rf6t-uyU
Message-ID: <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
To: kalyazin@amazon.com, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>, 
	"jgross@suse.com" <jgross@suse.com>, "surenb@google.com" <surenb@google.com>, 
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"thuth@redhat.com" <thuth@redhat.com>, "maz@kernel.org" <maz@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>, 
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>, 
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"jolsa@kernel.org" <jolsa@kernel.org>, 
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>, 
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, 
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>, 
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"hpa@zytor.com" <hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org" <oupton@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "maobibo@loongson.cn" <maobibo@loongson.cn>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"Yu, Yu-cheng" <yu-cheng.yu@intel.com>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "eddyz87@gmail.com" <eddyz87@gmail.com>, 
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>, 
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>, 
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, 
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk" <itazur@amazon.co.uk>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, 
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>, 
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net" <daniel@iogearbox.net>, 
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "andrii@kernel.org" <andrii@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com" <derekmn@amazon.com>, 
	"xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>, "kpsingh@kernel.org" <kpsingh@kernel.org>, 
	"sdf@fomichev.me" <sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>, "bp@alien8.de" <bp@alien8.de>, 
	"corbet@lwn.net" <corbet@lwn.net>, "jannh@google.com" <jannh@google.com>, 
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>, 
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA71C4000A
X-Stat-Signature: 145wkemjjq8q73j5szqie69odgr3bzii
X-Rspam-User: 
X-HE-Tag: 1769107060-825866
X-HE-Meta: U2FsdGVkX18dTwwV2YqFYm8bt+wUHfYMv1QqV1YkDGzD061tlGeKcxAK0VM9wELIAMZN1VK8r6qOWNt3KKL9LMNmEr5Eq67CSkcUSefZQ0Q2JOndrQGeOy/RzQ+82QqxMOEJo3YQ9O7K7wbVqAqJRSNcmbApg93TWiSchE1yP3cPV65MCnq504rPsRBS+50yX6662FaqEbJmDJ4FHPLZ4gFcAmQRCOAZ51rKzxZpsZrgSD+zufLoqhFj+nh+pDFO+5SIyCCq0wpkiCo2mhv20whh5PQcis9Uhz0mxFMQw/w+XQ/VuPyu+wX0IlfoSWlYWaWvvPARY1xEFTVA+DiLtuoFb0R4gVf1iuZ2mtujyZCkQiM4u+R6l2VwhAjdroXTjCPIVXAPakmrjy+lmk5fBh5ldCwrR/I0ffE6bC9yq9vYqy99RfmyTaISTYwVNaHBQUD+Bk/LSczmJ9VBpdDwtj96BpPqQN2MuQX0YI4/PVSakizpK7LZIg+5OSGjQMHLfw5p4755QHuy8Nf2E63L/EGQbZtC9TDJT1anyVfR1Pvb3SfFUqZGnHX2ITh4XvMPF5oEybvSze7vjCrgjhxfwAgaUgu8kpNuhSX25RQ6E8LqUKMb8gE/IHZRuVDNMLIeazpVTRrLsav74dnmjwvBsnVIFlNNOviT2R+2HMpG26pU0gZePfsTRFBhhOsZjB6Eg2sEDfWmONmy0ENpTNWf6eBVf+a+tvcO283FDxpkFlhLYQySlf4jDmJ6sSHWs+Ux/NfbtP3eylYy8E3cit+DnSzakK89UuHYutiNROyEcuZIsyuCCIP/UB7X1Z6LeDu6N8p0V6trmt9XBUqDc7yN/+lQ/iqV6xPzSDdGgUNFHKIsATzwAs7Eu6Y2YwrygVF/LQ7oHEhZe8jshZH2scQuiW0HNIeaJ7/kU6B/ZHt2+6eTwvzEMji1XXk+D/x27sEfyAfSqhHRkivabiQUqdo
 Qlif/c+J
 KB7v7UwK6cBLCzP4q9O/DtatBYNnvzdbHLB8CJYAv7ZLHQ+4GImv8GMOwVRujaxi+HWJbPz8xbkz+ZqNtvLsVF3tXVpb2yAW+As+8CWpHWBZG5Qpp+zu9UWrsPeidYXbxKLTZqoRSwZOazxDKx/bQjYJ3ZpaleFqcsDMoCXwWbBjoavHk1ALA/P0HNjQP5v8UmX/skTXWMrZ8e1Io5qlg7jkJUnSZ91ihPPxVNNgkhaNRrXjD5lyzZS91zP8GJKBn5Q5on7IHmRvgKf4DRR+htmf61GGZcqNuwN5fPosdPZ+0LXKC6P5XW4/6n2aJ0i5ZcqtBW1Wj/nXP54uDHMEGGaMiurGBPjf7V/wHdvG04yH2kHusXdGRrl/wk81aYKkJmN4j4fZELiGACTNJzbTssgv6qrHzMYjsMbi0+4v3cQqk58YNnC/Bk5jEkv9KLP6/FPRZzQn9YKsTZyHxAxNmt1JfDUlAoPIM8nLZX523IDb/CgSTErmSxHYx7fF9g/9sFYynxsUhJpX7q18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nikita Kalyazin <kalyazin@amazon.com> writes:

> On 16/01/2026 00:00, Edgecombe, Rick P wrote:
>> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>> +{
>>> +     /*
>>> +      * Direct map restoration cannot fail, as the only error condition
>>> +      * for direct map manipulation is failure to allocate page tables
>>> +      * when splitting huge pages, but this split would have already
>>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().

Do you know if folio_restore_direct_map() will also end up merging page
table entries to a higher level?

>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>> +      */
>>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>> +     }
>>> +}
>>> +
>>
>> Does this assume the folio would not have been split after it was zapped? As in,
>> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
>> restored at 4KB (split required)? Or it gets merged somehow before this?

I agree with the rest of the discussion that this will probably land
before huge page support, so I will have to figure out the intersection
of the two later.

>
> AFAIK it can't be zapped at 2MB granularity as the zapping code will
> inevitably cause splitting because guest_memfd faults occur at the base
> page granularity as of now.

Here's what I'm thinking for now:

[HugeTLB, no conversions]
With initial HugeTLB support (no conversions), host userspace
guest_memfd faults will be:

+ For guest_memfd with PUD-sized pages
    + At PUD level or PTE level
+ For guest_memfd with PMD-sized pages
    + At PMD level or PTE level

Since this guest_memfd doesn't support conversions, the folio is never
split/merged, so the direct map is restored at whatever level it was
zapped. I think this works out well.

[HugeTLB + conversions]
For a guest_memfd with HugeTLB support and conversions, host userspace
guest_memfd faults will always be at PTE level, so the direct map will
be split and the faulted pages have the direct map zapped in 4K chunks
as they are faulted.

On conversion back to private, put those back into the direct map
(putting aside whether to merge the direct map PTEs for now).


Unfortunately there's no unmapping callback for guest_memfd to use, so
perhaps the principle should be to put the folios back into the direct
map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
at freeing time?

