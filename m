Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C37C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66816B0093; Mon,  3 Aug 2026 11:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17B56B0096; Mon,  3 Aug 2026 11:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF736B009E; Mon,  3 Aug 2026 11:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBCA6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:03:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A27F1605BF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:03:45 +0000 (UTC)
X-FDA: 85060277610.29.70C5C85
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 72C2E80006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:03:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IGCVNGeW;
	spf=pass (imf02.hostedemail.com: domain of 3za1wagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3za1wagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpmlhPaZ29dFNT38yqO3kihwGUlr59oo46zK4tKVuxM=;
	b=6OPW/sitLdyMmBIHXwFeyywVddDAxsSb7ZuqCn/E+5KrZp34EsNnfl5yGPSTNqV8ulc5Id
	b+aiQvzmMboqnAXiUY4XVr22fHJIgfA01iRU4tMF4u6jAW3IA4NCLhFtJxZenHSNvNzGfs
	MALXi5X9t9yo3iKpl4KGUQ6ERa0t8/Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769423;
	b=fk1oxg8tqvejNkQeGP4Ad2zQZirusmk/RJF10TNTKMSKO656X/aoYaTEzzMeq7tgoe72zA
	mW7tA1yRgqYQOZnlZvARekDRTGmJaPFD3QCZFPVxzeMwUdsrOMKUaD/LHcXVoR/TUWd4T0
	D7brrPTS5ILfT+cxwF+kje1lcnfYtos=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IGCVNGeW;
	spf=pass (imf02.hostedemail.com: domain of 3za1wagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3za1wagYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84e048a801dso5245949b3a.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 08:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785769422; x=1786374222; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kpmlhPaZ29dFNT38yqO3kihwGUlr59oo46zK4tKVuxM=;
        b=IGCVNGeWIqz5hrUiys3M5mJh54kNa/RpO5DrE7E6A797AcvelojLwve9MKNOEHx4AE
         hN80lnZ7mXYVETVB451IFmjAyMfKGM6IzbewJGaN1By8bc5IIJXsELq/Zi5syFIPPD/f
         nKNMSgJuESNzdWDKTPsl/6Wrbu6tbMlvdhecEOL/2XwWnEmani/dKnsJztaBkm1XlTM+
         u4qdZnt17UN3nvhtAFCs9HHfWn+fgEEHfQsk95cu8/Cu8oEkcLkR2ZyuerjWs1jWurYu
         iGY2aK87i1N6qDjo4i12DA5sRCSMMTSrubKQu3uzw7xoYCsirqrdfyobIprI8XULaSPk
         L4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785769422; x=1786374222;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kpmlhPaZ29dFNT38yqO3kihwGUlr59oo46zK4tKVuxM=;
        b=nwRmzFZuNQ+KsAiJ6xLuowMBIgR+OtspYh3+3FdPFAzgRf/F6xejosscCOGcLYSU5D
         Hhci4fq0xoKWktmvXl6Vji2An0QAJzNCmpc9WZrPsAN4dtC2aH6Mg2KwMuJW7f9fShhH
         Q0Jdyyie8xeRSYTNYeohl+chqyrIzkJogw2rk8y9W+dz/aGGmnXYPX7bM7Aaw+giaUmc
         ctJexfUXPk+WmtDptUYmXR/jbprgG8uVMDp/JgLV/F3LlOE3WQGGlc+FfFnXU6UTzEDy
         20IgCwJLksKVS0Q7W25XVGHxo+b9BYBJ0J/u/bnuD280y00b9oXvvf5ntOpbz4GKINRW
         KfrQ==
X-Forwarded-Encrypted: i=1; AHgh+RoBMQDpJHUVzPMXO7JBnSNtjEHzv82/al70H0GbFVmIciKiS2RJ5iJIaBoD16NzTT1z1oNmNgvtDA==@kvack.org
X-Gm-Message-State: AOJu0YztMioNFS6gKWbt3S7hdxThF+ChtJmlLtXA2JZIF6kRm7YPMfX+
	OIDyxexAekEoeatd+1jYvRVkJ7dbGOjpIHQHSBKhO7KxOujpJd6Ypzxh1ncACUMrEnFYBxXRfGq
	UuqBQOg==
X-Received: from pfbki10.prod.google.com ([2002:a05:6a00:948a:b0:847:7765:a4c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1f08:b0:84e:d51d:86c9
 with SMTP id d2e1a72fcca58-84ee490ac84mr9200662b3a.44.1785769421725; Mon, 03
 Aug 2026 08:03:41 -0700 (PDT)
Date: Mon, 3 Aug 2026 08:03:41 -0700
In-Reply-To: <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
Mime-Version: 1.0
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org> <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org> <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
 <CAEvNRgEas_9BEV-cNxXu4_wQx8sR2M4_OaW6DEd4=fszALMV0w@mail.gmail.com>
 <60552bee-3326-4917-b00f-5fb7ba3b8adb@kernel.org> <be77c2cb-6e41-4382-9d2f-cd299f634196@kernel.org>
Message-ID: <anCtzQrUkFSSq8De@google.com>
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
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
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "hughd@google.com" <hughd@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 72C2E80006
X-Stat-Signature: b9we8mjaxtcpgkozj9ybk4fq48r4kxp5
X-HE-Tag: 1785769423-325388
X-HE-Meta: U2FsdGVkX1/lpuMfUV0oIFItrf2p+1126Cc/OQD/GeOblpVIPHg/Ps/ZA8ls5lM31ovz43RrnfLrBF1aUZ70YIzLM//f1l/zXnKIsepym9IEMQZCccjQb4OrcIzvxKUEnmVXHkTFCF0tJPE74jGfdPb7foScPPNxJdIyUDxdlQO/ZqCZ19SBllSojK5dUDoTDxvseWEE2gPr8oQ2TurlcnpNwFPV2svmk12Z3VOGlG4FNAnhVBLS5geZbLcvU+t48ndCvWWhhfEFR/02dnlK+q/cNf5sExXy0WVssHafo4DWSaZhq2RQslUhv/SpQajoV2FHH/NNOga+DtSYUcduapAJ3yVAKUxQ9AgLpsPLbWsQsCvt1aXNM6SQM/5bsX+ev9knYib9wDFkK3q2q1JLGVBxKmBQevh8/usvDiRD9nzftjLJjWBaQzhwRkZ7sg7hvXJl1EeRNYoBwRpCxAnRpq3WrjAHEW9+YCOu86owp+SjUB/LDIvQv1Aac5iRGag18j7lu2XakAXoR610czEIE6QEQ2ZPtrcLfGfBeqOY0yRrR8dREVUIzzL95fih8CQNdOgF8gZd+huD7YK664Cb7vI5/BPX0Ll7+h8Gafg9Q84R6x424Q7pDKSxb6gh4WhbR8NEQUlcGTijW6ZJWrq8w3bnXrynKMwQQtU7xEA4MWFOeMphvacI2o7nYXyHAuWhLwD5xcOKL3HO6X+XXBmmdf5vxQVNHkL0tjDx8+5zNwIi5PpRb7mcLHmlzdQCwos1vSC7PDriTaN/Q2nvw3jTxvTgGnmYGrCtmEjzJ2vnKDjk1EA/blPn7pSKkld0dxNdbjtSsQfF+nZR3e5yhLCOPFFFu3IIKdz5fVpntM/A5D6pa5hpEuQF2EUB68uduozp0AmJWCg88Kxh9ZyKCONX8nS9HNDDEOlDpbh7k0O4PvqB9vRikHiIYucbc1s2Bn7oajOjvsT71pyay7A+Z7r
 mBOM527m
 FC197V2zuStRlzrJeKEo4GGvHB41Xp2wJa2Nl7mkUzu0sHeTzz/OnRDYwAQjCcHliSdZ8U//99FZ4a+atsWW2q/t6i2xtCyz+jIlM1ctRmDq6DnDDdcRs4qPpL2aHjL+QIP6Pj1WjEkmvxKzn+h4PFeEugUxFg6VOcSo8SNdn2zTx6V7ceUwlvCUEhnyz9iATBEf6HyfuMMCxNryRB7N6AaATp2H/8GUUd2kVdC/mb+Wbpoia6SRum0Esn+f7Rd5X94uLU1AHLsA3htzknCoVJrRc12SL3++VSG6c9r3EGOBxrXen6yZfaSwYv5pVYhsM5+P1kQ5EkXjMz+Zn2l8nxdILbBcM7ypa4CjeBX9HogUSORVXI0h7XI9bWGYFu28Lefxbo+dXjhrxl1IK1FMxkCNUuVyU3FbzGTFs7z01Ph5F6z1x+TVjHBEJRPkPSL+oJWun+jHAaZih748qygdR+8qwXKxMO4YOH/hlphXUiB1jschD5WNHeiUTTCa6FW1nQHVokSPeBc+lD00mxFGFLE1kM96F8fgmXn2PBzE421mt7eApcMVAMaCcmd/5g2hUDMsipkILjKtKYlwdhYlEfwAV7MZa8XF851xc7BZxHWjYOwjQk3gqILDxDlVI/N5PLZ7CokNNlZKjzfXf2APERVZKXGD29TWIFQyhf/ZWqxuzcQ0R9ot9BFo+Azyf3cfhNLzwMsRO/7imqrZEHtSzw4gTyHES9JkVhub81v1LLhnSZ90=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026, David Hildenbrand (Arm) wrote:
> I sent a fix for the GUP code that always makes us drain right now:
> 
> https://lore.kernel.org/r/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
> 
> Would the following (agains mm-unstable + fix) work for you?
> 
> 
> I assume that you'd have to call it as
> 
> 	lru_cache_drain_for_folio(folio, 0, NULL);
> 
> But maybe there are indeed extra references that are not reflected in
> folio_expected_ref_count() that you would have to consider? I doubt it, but please check if
> there would be a problem.
> 
> There is a small problem for merging:
> 
> (1) The patch depends on the fix.
> 
> (2) mm/swap.c was moved to mm/folio.c in the mm tree.
> 
> We could write what I have below against Linus' tree and have the conflict be
> resolved when merging. Topic branches are unfortunately not yet a thing in MM
> land.

Are you expecting the aforementioned fix to land in 7.2, 7.3, or 7.4?  If it's
7.2 or 7.3, then I would strongly prefer to base v10 on linux-next (where the fix
will presumably land soonish), and target 7.4 for in-place conversion.  Then v10
can be applied against an early 7.3-rcN and we don't need to juggle branches
(assuming Andrew is ok taking the proposed patch through the KVM tree).

Irrespective of this small mm issue, it's getting a bit too late in the 7.3 cycle
to land the in-place series, and we need to address Xiaoyao's comments, i.e. v10
is going to be necessary no matter what.

