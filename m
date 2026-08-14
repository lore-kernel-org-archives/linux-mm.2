Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B40BC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 17:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD486B066A; Fri, 14 Aug 2026 13:57:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E9D6B06FB; Fri, 14 Aug 2026 13:57:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 125F36B06FC; Fri, 14 Aug 2026 13:57:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E92266B066A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:57:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84A351A01E9
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:57:50 +0000 (UTC)
X-FDA: 85100633100.02.AC09052
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id D120340002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:57:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K400RLQt;
	spf=pass (imf04.hostedemail.com: domain of 3G1d_agYKCCIQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3G1d_agYKCCIQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786730268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTRpQbBcuIQQHhR/UQMYNM1PA+jfAXsDHcYqcmWTXOk=;
	b=o9H/GCvdk9GWoXtvFzmD1miFLPhSUtKkc2rJK09IeN7UAt36AzMpASSThzdO32/XS3KZfQ
	pHW3KvOJM7iUtEmHbDwRukjKn8hVjiINcShcaeOeV+PSV1ddcTkGldmTzVY/VQOb0pqv3I
	WnRMTZd9RE8cUwVjFR2VRMxohA3OTZc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786730268;
	b=KIoDKQSYeiHY2J6vRtBUHsJ2iFmJfuwe41RisNbvdXBG1NGDZbY6gQJQ6MsPYv61MXFUBF
	1XLkUZz9G2PLJMA09Q+rQ949pt5KrOCSd+JdnGer6AL+hBJ2MNVaEg8Tks/kimblkAOAa8
	e4th1523D7bOfTSSBZw8+yLB4PAcNic=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K400RLQt;
	spf=pass (imf04.hostedemail.com: domain of 3G1d_agYKCCIQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3G1d_agYKCCIQC8LHAEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cca3673560so19687895ad.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786730268; x=1787335068; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FTRpQbBcuIQQHhR/UQMYNM1PA+jfAXsDHcYqcmWTXOk=;
        b=K400RLQtGUmD39wwFJm8pP01CJgZwOFspzfKt02k2wLdcDJiOCYrPkgankUdkpaogf
         YoqEOO7LTNPvXlKg0xuQCaRpQMR2Txz0GadMNDeKutGJwXH3rqa8FXBujO+snKfkMe5P
         wNIVUDXzS5w6sh2xQkwOcXXr78eQdX2vW/c71fmh8T6WXkFTapJQ7D/k/jaXS3DBQ/0p
         V0rDnt1cm294oVZlZmGM11nfPEEieQb+S/XT4LqIEH7kxb88MhoE43vhxthxO8rHLMOD
         rcXfnyufPxIrTy+DV3B7tsOdzxXthwPjGYdVXH32uEGSbXhtsTAXge8ZiaQV0KlQEpcB
         6FFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786730268; x=1787335068;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FTRpQbBcuIQQHhR/UQMYNM1PA+jfAXsDHcYqcmWTXOk=;
        b=Vy32xWh/iL6YPdz20OoHKzp4i32jE7frWsdvye13dYSXQnkhdoBy34FImQWXAoZU1l
         Ods1lpVMxL3Lfo4iy7hJ79FAlAbfGjqMiaPyugW0B/emdZlXqRvU+nAukYjJGAsXMHZl
         ORjT9TFXoKtzo24EFwxEosPv6F0AsL//ZOwDtdlw+DH6TGHG7IUrb5XmLcjv5gWbZn9r
         y0jgd3GIBKU1ETvO98rQmy3QMqg8LV+iGKPfU/O9ibCfPrbvF34VyguKjp9U9yfA4RSm
         ky3p+at9y4W8oUd3LtIZipth23EIBuC8PfebgidPHDrQg3aGE5yAhbykFOlnEOymowJl
         sLRw==
X-Forwarded-Encrypted: i=1; AHgh+RqF4ruhvUFI+zzFs7+xb61aJmTq/kTrvLIq//76XkwKhYIT5cjxwZ9tr96B5Se9p2bHoRIORgqU6Q==@kvack.org
X-Gm-Message-State: AOJu0Yw8JE/H9fggF4GQoz9b9QUAKGT4SSa70hUwXGXNpus1TxfvnfzI
	RHU9S1Bycrb4IfEimFUkUzbwD+G2P8RqQl7YRXD+SJqmgN6Kxw9B0K0Iu1AVhQwYqEnl1Op5894
	XVGkmPg==
X-Received: from plbmt15.prod.google.com ([2002:a17:903:b0f:b0:2ca:5dc9:51d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22c6:b0:2c0:db23:4c4
 with SMTP id d9443c01a7336-2d3b0c8852emr91417425ad.16.1786730267363; Fri, 14
 Aug 2026 10:57:47 -0700 (PDT)
Date: Fri, 14 Aug 2026 10:57:46 -0700
In-Reply-To: <36baf0ec-0b7c-4ffd-9a1e-dfe9617e057d@linux.intel.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-18-2fc18ee6d3ba@google.com> <36baf0ec-0b7c-4ffd-9a1e-dfe9617e057d@linux.intel.com>
Message-ID: <an9XGrcPw3h-ExA9@google.com>
Subject: Re: [PATCH v10 18/41] KVM: TDX: Make source page optional for KVM_TDX_INIT_MEM_REGION
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
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
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Stat-Signature: utnr976jq4n7sypwohakm6joyhfxd7xz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D120340002
X-HE-Tag: 1786730268-97391
X-HE-Meta: U2FsdGVkX1/THGfxLPlKt5qa31X5FTgzYWeTa5dvyq3/sDzygYKJyHUs21t8HO23FXNWY872WT4tjjwwouqppbvDY4VqhE4CXt/DZ02QEOYay3CBX2aMIYyHJDPyu0L0Wzzq8zpBdnDoOBmRvMAlxwYztKhu0997p3vxNLV2NYV9cSPbYn4+kNtImbaGoineEZ2+Rm5HkoEJOqambLKvuMJYgSrrR1JOA0nIAqxV4LVRCWWyO14TflAS3LDnV72v2NxC1YKxOERQXtz4+41XPwsLoomShx/DBKdzwHkv7RnZleUi5KGzxoSQEu0Y1BW+YESuiofp9uHEfnbVHzLokpmL2KcGvvk4RL0Yww9Z0C3MolEWGcQVwTHidvlEutpm3UrsY0YYJnGEA1zYqPZn1bThwM98tHwi0thbNL5qCPOD9na9Q06Iu8oUXX/1R/lNDkNL1MnAcKsC2JPsevcTMon5LwM/W5QOXY49wE6BBnY3u4eoazF7/S7/va9Ur9Eu9ph5aHUTSRgxTaaM983NZ+F73umG8GKFfGSeVotSn5qSHNfHit4QUbtJepLQdWNiql29tfJZkdLpGZ1n39YUPwLiECJEArY5xmJ1W1NhDBetflc2s++3bBeSbj3Z4nO76nodJVB1mewJsO7OXyHrGcUD9Ds7osJa5Jb0Co+y0pt92jAgNX1dWdNNLQuk7TCvep3WE0ZPPTQ+q5X64tXYzQaGOUx/XM1YjCDDMq6PAIlJ1neKF8n9Rtla/bGUviD3tVX1QF0pjIZg4wJZ11eBKhZ4reqfNrs4F+BIULo8Hic8+n1xJn7XT0l2E0nejDWlewwJur5jWeGaEQ8KtiSWcq+AReH/SdDUNfcn4hw8kuChGGFcwfCJxA9aQlgEl90yb1CiLuqwF/YZ3NVgaBM441Kt6SiSQuQNyjKt/2p/GCw2ul0y4PdG9Y6YT/M4evy9D4C0OHd+94i/6SlShRv
 K3G4/Z1i
 4vnE4SS+R2RyMsysutFKGJoJElS1+ks0ogyKMPgfnQ9jMgILSPXAfjolaSYSMhVQHM17+8vrIWfg43cMdnr++KBAwEDkcfwDC4u7Z7pBBPChOwLH6gCjNcWlAxz2ZLwiuL9W0UjbgOx2cDtoFCS4aaKDmzkztV57TuD4rSByBmpn2GURgVeZmIw65E/xsK4zn++NtS7iZoimL7nrp7TKFkQmG/7O/4fFL7AtJtcBXCIrp2tyckMxYdAnFIulRntQTlP1efnmZpokZcqk0skNwXSbNAXN6YSjSG/Bw2ZMPRg7EMuLaM0rr8bRAedQEDLBB7e7Ym7bZ2LA1hHQHQ1IKdcGEdZrXSp5GV0Q68M9I8fD2NTuxsL65G1vdo0bAf1vQafB7a7dRsmU933WesZyi5a5jJG7c0vD5JJsAASvZtsmRXRmj618ElUOd0JsyQJRh85xgV3BC1btDKyMwIpYAgTIa2wwgtMdNnEdZfMOqVaob6CxejG2FDdgH4JBLOY8FJBEPKsaEns06B53tn+84GN29zgx/RajbZGVVI2aL9beiYiFP2Uc+4Wc5fipWK6KB24TVe1GeTtPsbeaNx5RYgG52waiXOTaMiSw7V8Ih6MdH3vONGFfnasZ1EzbZreFste3ndxatu3HR6XkYoaeG7wQ/M8wz6OOyvxfA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026, Binbin Wu wrote:
> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> > 
> > Update tdx_gmem_post_populate() to handle cases where userspace requests
> > "no source page". To handle "no source page", populate (perform
> > TDH.MEM.PAGE.ADD) using memory in-place at the target PFN.
> > 
> > Allow "no source page" only when gmem_in_place_conversion is enabled,
> > because retroactively adding support for out-of-place conversion would mean
> > requiring a userspace update for a feature that's being deprecated.
> > 
> > Also, KVM supporting "no source page" without in-place conversion would
> > effectively be an obscure zero-page optimization that relies on the page
> > being zeroed when it is allocated by guest_memfd.
> > 
> > Rejecting "no source page" without in-place conversion scenario is valuable
> > for KVM developers since it helps newcomers understand what exactly is and
> > isn't possible.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Nit:
> Is Sean's SoB intentional here?

Kinda sorta?  I handed commits to Ackerley after rebasing them locally at one
point, which is how my SoB got here.  I think it makes sense to just drop them
from the patches where I'm not listed as the author or Co-developed-by.  In the
end, I expect to apply this series and so my SoB will get added backon anyways.

