Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B36606A33E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=cNB1q7VN
Received: by kanga.kvack.org (Postfix)
	id CAE1A6B05E1; Sat, 14 Nov 2026 02:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F2E6B05E6; Sat, 14 Nov 2026 02:25:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75456B05E7; Sat, 14 Nov 2026 02:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 920056B05E1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:25:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21FD6160205
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:25:29 +0000 (UTC)
X-FDA: 85432889178.06.B3719BF
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D4B920002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:25:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cNB1q7VN;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794641127;
	b=aQeJ4HdthupZdbil14waGCaSYPjDXN/hnIuxJ4jQPby3su1AxJiGc94/YGYI1dBfOnzJY9
	U0Add3e1aRzqQLrCdBYEIAHSw78ofqBkhuqCJZz48B6Le5urHSnXH+DCZ2cQVGJQYecgL9
	5O5eAqm59JzsmbmKXIftYpDbgcCPYeM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cNB1q7VN;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794641127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOpOMGwOLM8SRhOfI4bc8Q6VvL2aj4ajoW8MlVZKv38=;
	b=ZHpG+gaFRJNwIfDC38Pjytwr5qXKvgS69F9P+OavFZNAaWgCwQoCaMmlUsFtX79wOXlt32
	JAAtSgQiQgKP1goXv19WOzwD5VhCkYMOwFPYKJ4Q9+WkCoqotVLZMKggRdUqXWSplPJNfV
	G/fTDnF3n2+kG6ztuYc60y6RD5K+0Sg=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-94960131b30so74568985a.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794641126; x=1795245926; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FOpOMGwOLM8SRhOfI4bc8Q6VvL2aj4ajoW8MlVZKv38=;
        b=cNB1q7VNNDwaNhZB1EfPjib8kKGqoe81RskwYZspwfifyhzjNf937IABFP3+ibuz4q
         +7uWSRMwZuFYv+Qvj/yhsnyGLR9uusQzvixPQ+9exzwpJ5lAUcVA4zyUdsPcJHTFoMcr
         DqwYsipi6ngDl7yw5KxzjoqCBV5gxYGzAfHLdB+Om9fFkvG6gycBkhGLqXk/Ub5TjwAJ
         2tbCohfJWoizvdISpzkcJbGQLZWarJfI6/9waMi4af1B4NlxAA3Bc1i6737fmyck67sn
         cw3PkGp5VCt2IHKXJa3Z4buFteExXY2RY4ItJBLxBksONfYlquHMq44xehYxS1bhNuI6
         g8Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794641126; x=1795245926;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FOpOMGwOLM8SRhOfI4bc8Q6VvL2aj4ajoW8MlVZKv38=;
        b=EsirM3nPy1YNt2vm/qV77t/00aIwY6k8VVVKjTugucHIDVpG4MBQHN5FF+ns4liLIu
         HE4tHbZ3FDMw7qGtZa3g7LIeqSeFa7Gusnh0XfVRY65GiO2Gj9cUuRt08c5cAa5stk6e
         YcWaNYAtwBQRJIJ2c0eDgoJdONAfSY+1Vq683DIFjipc9jVB7A35vp/Tw+tBX3E+JELy
         E1f8lwYM7TyNTpV6JNwAg7oa/tCvuD2YFNLLwU0O8oml2ZvVruECxcqs3b4Adxrz43aC
         HxecuMKpjLTWQiJaoRVEYMt9foK5KQuwAYs5RepbWGLFZ81AlWXet97eZh4cVsQTzKFd
         zUmQ==
X-Forwarded-Encrypted: i=1; AL+hErF6YootBSlOe2IZqNEWmvn+3Sdcl+GE2zHjbxzUZVDBZmSD4PKpK1s7HQTUxZkmZMg53NqRwG0ExQ==@kvack.org
X-Gm-Message-State: APuU4Z/kUN9xZZ8O0qKq/Unu/AjpcXpkjIglNQchpcfTcLSusES/f5GN
	v7pHWPienS5K64dWyp5oRMsYVepxzoXVYWxPbl24dY28XxKY15WAK8gfZJW/qQuTBzw=
X-Gm-Gg: AYBFou0t1n3xxVrRdQQF5SVpuOTqBctbDkQSDvS+YunAw1+kwCICWSrSML5Kv7/ul4B
	HBhgQJk/gmnf/j/x5y6BDLXZwJDvqJyVLvlnXkHaho7IEptoQGRZ0TtWF52mYeU2RbxGig1Ui9X
	l1n69vvtKz4APHjK6wVVYYhyEywN7c+3PmlA002zI2S545OHVHD4+70UTBZ0gArYt3JcZOnSQyC
	a8JN1DuY3jislGtst8A6sL6UzRtzEzL2THnUrPkwDuvEv6xrO1PxnSzB6Oh4wCMJU1bXbo9KEgv
	yvmjNZHcFAc1rHTWNH2ealBugRfEGStjUEqt3TaaY8sRVYXLUNUqvqXqq5R4AzJyaIn98ik5kC+
	Gsd14ks55k+BFspaflRImZhw759RC95BB+2GvKPNHLxbfhacDZwbt8z6wdNOH+yJWoJdrL7OF54
	7rqlVeemhTyBcVWI4eKPXg64IK09U6r7AMjed8AeQmiC5K/FHyHATwIhVcLBljjl1WgnTAuep2F
	1jVRa/857YLO30EC1cYfH/qQsb7hIuJH12ihAtKVQJKmwAKDIcYj/vyiobEwFFlaP+RxpWuz98c
	z3Uw80wssYIeKt3oY001tYpb2Qem0nvtAvVwPGrW8tm6X2rfPWGR9eBLyhkYivDa/nUTzHjQ5mO
	il5Fax38=
X-Received: by 2002:a05:620a:2a06:b0:93e:b0c3:388d with SMTP id af79cd13be357-9494b9432demr830714785a.11.1794641126492;
        Fri, 13 Nov 2026 23:25:26 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c803abbsm351077885a.7.2026.11.13.23.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:25:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: reject shadow-stack mappings
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, leon@kernel.org, 
 akpm@linux-foundation.org, david@kernel.org, kas@kernel.org, 
 dave.hansen@linux.intel.com, bp@alien8.de, rppt@kernel.org, 
 stable@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
In-Reply-To: <20261114002027.GE3706007@nvidia.com>
References: <20261113195536.2660763-1-gourry@gourry.net>
 <20261113200303.GA395967@nvidia.com>
 <179460249376.482102.14669935557901467762.b4-reply@b4>
 <20261114002027.GE3706007@nvidia.com>
Date: Sat, 14 Nov 2026 02:25:25 -0500
Message-Id: <179464112539.482102.8723246686117488051.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: ywj9ecusfx7q5gxforpfjy7jwywgntqb
X-Rspamd-Queue-Id: 3D4B920002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794641127-227497
X-HE-Meta: U2FsdGVkX190jIFv+QplECNZXBPPFTJbkfrRNUCoMotuwLBP/SKxbfAybVGaa5BRv++k8wT96/dZ7NLXbKSb+WcpW6KOWtdGpe87TXH3SSMnPIksyMpVX1WrRw8GMH5qJwFw46HU8W4WE2+dtHdAZnSoqyfhd4oK63BGEB3EOZQAZqruqbw0OS0ewe5ICKBVtnOGaLkK4oKmiSzlbL0H7Ci5AE6jye88mPso/2c3+LryNHITi8XXlr+PQfv9b8MiHyMYJpAykPjDr0NaIMrgKemAJrzHFc7N1egwUa+ERTV5gou0+LTj+AHzFD34dNfQ6gSHNyCfP+DigFpzpGZ64CTZUeZMQfEJfh7UixbQbnqyf8YQWUb/2MUPTyAxODYqH5aMjWVcWv1c6WT0tkJsQktUnXO/+smRiFBof2HPWBCZ9Pzj3zoKKrGXqOPdwDQC/os1GmQAvsHSmOnPCliJw2NmcIC4KMnAImLPJ0LmXb5nCKVyYZSbeZmmJdKd+6UpTeYMNP/g/B/aofFDNMgAmMZMoa341z/hqcMr3czDDEeK2vrmWrFdgy/VNv9BTmGg3fNyulqCtjlZxWQWMXibxE7QTpUEcUfs/xOZ6eUxXrnk+cA9aRDc+JAQRkAYZBYCPRrUkpHi0bCUvseoJXTYEg4+ZqAC3hv+tzZZhApLTY0mRRz063Wg8YCHmwPz84LcGxsol8Ex+V6RRUt2BBUtD/EcJzzVY0a5oAbPp0pwU10gQRXEU2hAnc+ldPBUpuMHRZYEf4yaXwyPIca0GMFFPrAtoeye4cULpKqm3IT5nEDfrQQUBcg4tKItsGj+Ct9i1ny7bX72ale48ORgAAe9W5prA7JesFYsmB/eIee//Y3IKCR+2aN76lmFJaeX6sDgJ7DQtY2ViOXUiNYTi/MX3WitlUMpJ8ep92Q9hge2yIGTuPw4r6yvngfxaw97QQ5UTQSvs6QGViJcEy6NKl4
 Yw3YQ9bB
 I4rUqOJf4oPlDEqvbafvsvhC6/RK3ZZ/K1wupjmZEJTuv3jlU5TGf6PBamXqsCOBTgaDzav+5t8RTnXo9f1i0ERr9Is6KLnjf3Q0lwKedKsowOQ24kguiZKr4ZA41QX8HLhsBlpg49aODSH4EIAC0Iqu4v5WHUOJLpPXDDX6jCEWL/SiZ7Ql5Am7TT8/4H6OWs9XtDCzaSm6LAbrtjMU/1yn+fXWDAOzC4/BCt6PlWJSsoz2kx7QKkU8rHkYgcue9arktDT6O/yMHaLvdqhIvjx7nnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 20:20 -0400, Jason Gunthorpe wrote:
> On Fri, Nov 13, 2026 at 03:41:33PM -0500, Gregory Price (Meta) wrote:
> > On 2026-11-13 16:03 -0400, Jason Gunthorpe wrote:
> > > On Fri, Nov 13, 2026 at 02:55:36PM -0500, Gregory Price (Meta) wrote:
> > > > HMM can grant ordinary device write access to a userspace shadow stack.
> > > > On x86, pte_write() is true for a shadow-stack PTE, so a populated page
> > > > can be returned with HMM_PFN_WRITE without taking a CPU write fault.
> > > 
> > > I'm not sure I understand this? The pte is writable but you don't want
> > > only DMA to write to it?
> > >
> > > Is there something special on x86 that makes the shadow stack pte
> > > non-writable by the CPU?
> > >
> > 
> > Some of the context is here:
> > https://lore.kernel.org/all/20261111-mason-migrate-et-al-fixes-v1-10-3d2454362e8d@kernel.org/
> > 
> > We had a similar issue with migration, but this should handle the DMA
> > case as well.
> > 
> > It's "technically writable" but the kernel is supposed to prevent that.
> 
> Bah, it's not writable at all. The CPU PTE has write disabled and
> someone thought it was a good idea to make pte_write() return true
> because the CPU allows writes through a special instruction on this
> special PTE? So now all the places like this think its writable, when
> it really isn't.
>

I completely missed this, that will teach me to trust pte_write() I
guess... what a bizarre design choice.  I'm sure there's "reasons".

> You could also fix this by having something like pte_real_write() or
> whatever that doesn't lie about the write bit in the PTE :|
> 

or rename pte_write() to pte_fake_write() instead and restore
pte_write() to its former truthful glory

:| indeed

> The patch is still fine, in that it matches what everything else does,
> but I'd include these details someplace..
> 

Thank you for taking a closer look, I think Andrew's changelog
adjustment is an improvement if you're ok with it.

-- 
~Gregory


