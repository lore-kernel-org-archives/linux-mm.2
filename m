Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8901CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 12:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088446B009B; Mon, 15 Jun 2026 08:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FFD6B009D; Mon, 15 Jun 2026 08:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB81E6B009E; Mon, 15 Jun 2026 08:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAFBA6B009B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:09:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99E7DA09CA
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:09:43 +0000 (UTC)
X-FDA: 84882027846.20.BCF890E
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA28A40012
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 12:09:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HzwgEsTm;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781525381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOdMIsFz2F8FrAy6a0jOSLjcHU/RXuOpv1/VNxSWE8o=;
	b=QukhFcVYmRhoPmczhhf9ZsjBsPWAtWqEMdX5exwjlFwjJztjYsmsKi4vF4ERRfQdmEL3/v
	1yiWhRNBnaVIImJo3PKVN1tlhrU6OxyFimqC6cXqf8bSM+JJVKvyAgRN/MC8gtBzHi79rU
	NUzJI1fPhnYOPuLzwqg1G72PxMl7rUU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HzwgEsTm;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.170 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781525381;
	b=qsFAU6zsrSlGgNM0N70L+xmqxGVjqKuBZafWh+zalXh2VtXujdw2fmYuJppET3U6JrMRyl
	3sNIov+vxUWoovb51gq+uYrLBuTU5XIrvTrnv8JgjX5noiwaulBV4X71Fy9zaYyXAGrKm2
	ZRALCSEvPp3B4s51wkR2s+5cIDcoqsM=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-91588056619so229649785a.2
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781525381; x=1782130181; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOdMIsFz2F8FrAy6a0jOSLjcHU/RXuOpv1/VNxSWE8o=;
        b=HzwgEsTmbfLyjLq5gplfLTID7rGnDamnL+hZ1R3des5xQaEQqdStUqYyZEND51eBr5
         bRXxWoSHlsbnHtP8XmA+EU98xAlJKXWC2zvZaqvAMc8JhOXav8ufFlSWDsZfkyvDriy/
         KPG9COJaKJNQ85grfQxrcitvumKr2UNKjj1jnpuzLR4ix4zVUS+TAV4jvwJ3PuJOTOqB
         YJsVOg4/Ml+bmdZPFQA3JELiQ786ZbYld5hOSfu0WYnyiAiBLIm3/x8/5IL+6Ff4PUH0
         qbhZsRDJ0ZIGGlCgcEJFhC0Ie+Mih0rk6a86PsZgSuA1k5xy4foTjPJhoERmewaU75yY
         gPyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781525381; x=1782130181;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOdMIsFz2F8FrAy6a0jOSLjcHU/RXuOpv1/VNxSWE8o=;
        b=mD+LccAv9fxMh/svnyHkI7i3TJzswNwI++1HoEyPQ50iWMPTqkrJfa2KOHAdsRFzm4
         PQoqz5ra13vpBtS+DkmN+UM8mmlEr6MZwNCuM8ScSE7ycO9HJPvlsTDrmJeK+gC1uLk1
         KcFVniH661EKkju6aZo06yFr6Zm0e5bWKadGMAZ58gziYOOuwWKlX+AN7hKGEotP88gN
         6QSGPpr6COzkJy60+L82JdTprJnJyVCTjT75bNghfS6GOHZdt5Hn4/s/ucGiX+f1sAfC
         T7n2ARMDJk24JCvEcbm4Llu6Oyp8RF3FCqOxUplGvUgPMieEysiaWjF0ayGqCy8hbkIG
         oUvw==
X-Forwarded-Encrypted: i=1; AFNElJ9N9S7HYwGFrS/5kizGL9zRUyIUOxXWXm9kp2jCfoKzzvKsjxPMwaCZ7p+kii654xKE021BFQA6LA==@kvack.org
X-Gm-Message-State: AOJu0YzyY723IiNMZyhuNTRaaYjZTa31q8fctKaw4sfnhjaQfXoCqae1
	zNuTwo+5MZ7pcS0cQh+IlNHUjLApRxVQjJIQgwZ7dBpazJovuLLayrKm/EZb1OvqeU0=
X-Gm-Gg: Acq92OHX9GgxsaItkBoQpqBJXmKsu8lEaZaPmiREHbhsfSl0tQ9+AzJQJhH0/pnMK8P
	Uzyk01gnxgccO8D2t1XnuGozF5Z0OL+VsAts86zX+2jhE/TZbQNuHcH4/b4paw+loJxnLB7rgwB
	BcwICXjY6hd8d869bA5kmNtaT21rl+2FGKOnP/fY6vYdMBxQrIFlJs/AFsZefNLkFJbKcbeCkmW
	u15dopSsTxmrCxQfZchutKH5KAkNlHMH9gDS0BB+2V9UK60HdeH0Xq+6s1Q7v3nQfFTMY/c9nn0
	DBV79A8sOQ6oWTzM6vhHfYkZ6gdDu0oYSKef6Dliq1tNWQaeodZVTWGZFpChqgkLTuUholKBh3N
	DH38Esl0nK/q6Yvd9QIRnBistGlGPeUFuv7cY4h3+OcWzVnBz23kS+c7FmWFkevfuC1bJuEd/7R
	HHaigdlFgE/LtF6q8kh+OFNROXa+YFwaWiAuYgkopCCwaClOS69dqq3UprNgjBPjKUFc6Zp3WEj
	7TjJA==
X-Received: by 2002:a05:620a:bce:b0:915:8f08:5fa7 with SMTP id af79cd13be357-9161bf92252mr2134995585a.52.1781525380729;
        Mon, 15 Jun 2026 05:09:40 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f05fe7sm1176650485a.12.2026.06.15.05.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 05:09:39 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wZ68I-0000000DLwG-2JkO;
	Mon, 15 Jun 2026 09:09:38 -0300
Date: Mon, 15 Jun 2026 09:09:38 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kameron Carr <kameroncarr@linux.microsoft.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"urezki@gmail.com" <urezki@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [RFC PATCH] mm/vmalloc: add vmalloc_decrypted() and
 vzalloc_decrypted()
Message-ID: <20260615120938.GR1066031@ziepe.ca>
References: <20260521205834.1012925-1-kameroncarr@linux.microsoft.com>
 <aibhnnDFQTHWMEFe@arm.com>
 <20260611114954.GC1066031@ziepe.ca>
 <aixGqCqKkQeDfUST@arm.com>
 <20260612181807.GP1066031@ziepe.ca>
 <SN6PR02MB4157EC032AD55D182FBC1318D4182@SN6PR02MB4157.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB4157EC032AD55D182FBC1318D4182@SN6PR02MB4157.namprd02.prod.outlook.com>
X-Rspamd-Queue-Id: AA28A40012
X-Rspam-User: 
X-Stat-Signature: boun1coa847snd7i1st3xcw9dp3xeake
X-Rspamd-Server: rspam09
X-HE-Tag: 1781525381-55841
X-HE-Meta: U2FsdGVkX18y/GbxBoZ6sJm4MDLx1sIUNMdoXZ8Zj/UUv8RERgZodEMJjjGFW7mcRv0vNRhZ3jXAinZVmNnGm/IpbbdjMChZQdJKQ5BVyZwVfWwx/YIIFs8L+MkKB/qp7973s/nny+RuUweVN9/cOFEzfvYZ5PdqyK+JNK15OnZmvizUgTiJhuzQLBFcs8aDWlgGPmT2ekTySoyOZf97EJna+9di/jJV5PoLpkeFpv6mgk9MAOKApzKIyu3gfF/5k1zc49AmjVwGNpVV/zj79jvAwcVYLd0dDuhMkhAIJ9e+ALbAUafKPMKMeIAOeCT9HzCCiLjzLJg62zT7QWYGBGob/HMXBWnkcbFzhbPi9bd5m2Lft8eb50dCRuMc3OM/AxyBCJASSqULD1JP3DpIvUgArsm0CQaPK2faHybKlaG0bl7FerMmhixl/M1UwP91MZNd7E7TusNh6GxXkQ348MFNgMpW6o5cbILNynuagpxeMzLkEurN64cOJ+1QGCmtmlG4jASQytAoMipmX62acuomK8iiNUMAbnRKMWR42zkFvPuYs1GCqm4ou/82Ch2ySVXSkun/aIKyXOgoYPE/P9rUp3/er8gwie1Rg+bAgZOF0MRhY8rUgiaVGFkbS60gRTGmpOyLI9EhJQmToJxYzDmc/OEI3I1yzxy3d5C17emPh0IbMD+N9O2w9PPBbA7fzF3reTxWtK/MekQf0DYE2S6/EWhDDD4C1rZiaBnqY2jBBVZ9slc8FSCM6TjNBnZTf9lsgqQXbwibWZJDbR/qC7FeaSW7StskyBdqL97ZQRw7aTnu/gvLet471N57BCsVxZTe+PxMi2A3gqhx+j+qwxiIR4GAvNtm6f40UVO22eO290i9dQngMh63LZMccXZ04yY5RcjerQHwkYlPmUOAU+B1QO/TmNBS+TnLWmK3CyuxAQd14289CD5rmfcQe8nQOeA+GYMgFxQyfpeTWa0
 G35TnCcJ
 VOs8DdvaXZ2MQvksc1bp2wYY5mMnN8jNBVAKZML9ttindWgUuG5+vbStCp5B5+repoF/ifHPuY3IHkkKMrnduZSwW6z3hjs04cruCiFSWw8AA9S/9prVq/JBYmdq6+pYO+FgfxmOeFQOz4xXEZwmQMCgwyAttiLeDLx0Nu1wO/c+TZfdhxnJYoOYJSIhEu4RhI+dRHk/KlcIzPmNokZJoJO8HX1V6ajmm5BPE1nWxGLX86mJMj9m4JGR48TZzpzUJwI/fQBJKHdnSvvHUBklNrDV9Cy8ChyGyRQQ3Uj08kPavYN2oVz+UU2GYTaIvb3O7BFdbQMWZsCjqmKm7WShkyUgn1dZL87LnYzDntuXeG45ajptR3wuGlh5qiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 07:06:00PM +0000, Michael Kelley wrote:

> > I thought arches are either preserving the memory content or zeroing
> > it, you are saying some arch leaves it as garbage? I'd argue that's an
> > arch bug and they should clear it in their path.
> 
> AMD SEV-SNP leaves the memory contents as garbage after an encryption
> or decryption state change. On the flip side, my understanding has been
> that TDX zeroes the memory (or at least has an option to do so) after
> such a state change, though a couple of AI chats say TDX also leaves
> garbage. To be sure, I'd have to run an experiment to check in a TDX
> guest on Hyper-V.

So there are many bugs then if the pre-zero is lost and you have to
zero it again. Even swiotlb doesn't reliably zero it's pools in the
right order under these rules, though alloc coherent does get it
right at least.

IMHO this is too sketchy to be usable and optimizing for AMD is not
the right call, IMHO.

> > Otherwise this sharp edge is not documented and we have many other
> > places getting it wrong, eg system_heap_allocate() doesn't re-zero the
> > memory after decrypting it.
> 
> In the Hyper-V code that uses set_memory_decrypted()/encrypted(),
> there's always an explicit call to set the memory to zero afterwards.

Good for it, maybe next time improve the APIs :(

Even more compelling that hyper-v should be using the dma api..

Jason

