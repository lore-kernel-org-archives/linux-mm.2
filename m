Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EBDC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 11:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE1F8E0008; Wed, 23 Jul 2025 07:38:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8959E8E0007; Wed, 23 Jul 2025 07:38:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAE08E0008; Wed, 23 Jul 2025 07:38:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD9C8E0007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:38:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C32F140661
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:38:53 +0000 (UTC)
X-FDA: 83695332546.26.ED2E860
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 33A3740004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:38:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aW3f+BSi;
	spf=pass (imf17.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753270731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTVDq7tqt4jNdxmpuXh4QXyl10dLJquaJYZ+1Q9DQZQ=;
	b=SHwZLKdQ5nfGxOQlEexfzJU4hCUgF+MbQliYMVm42v/CdeQ4+w46MHsmcbgA6e7gOXESM0
	zxptt0ZEmRYRPzplYReD6meQEH31i91q12ILg6GBuvxWh/AgxHJl4IqbDrBLDIrEOKW8sj
	5i/yuSJf4Yux7nAFMIFAi84QpttEjeQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753270731; a=rsa-sha256;
	cv=none;
	b=OEsy761Fwq9C2pOph/BTvQWKouQrT1xp6jBJnuWox62P+j2KG/geZbdJ+U3S+xxbINHnBm
	rTT//ZbeLmytjlR/2uF2V2Gw6vVHNbAprPUSsDlkc/9AhJR7VcmdXBvQyoGv0989CyV2cC
	/HVYwzW03pRxccuBiMzw5W8174r7Bck=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aW3f+BSi;
	spf=pass (imf17.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 23 Jul 2025 07:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753270729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pTVDq7tqt4jNdxmpuXh4QXyl10dLJquaJYZ+1Q9DQZQ=;
	b=aW3f+BSiEqV6nwQRpRu5sDRX6g8o8us3mskDaHE/zN2IYxn0eNYZiiLEMOQ6b9vDC1ift4
	kIwb0sLOxyeqViTn1vkf6nqt9IZNeRdrzvBM8y+0KFCnHF64AoPX5rgSq6xOY1fsoy154j
	m6/5Xp+O+rcYdvrBpLoriv9icFznMtE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>, rientjes@google.com, 
	vbabka@suse.cz, cl@gentwo.org, roman.gushchin@linux.dev, surenb@google.com, 
	pasha.tatashin@soleen.com, akpm@linux-foundation.org, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, quic_tingweiz@quicinc.com
Subject: Re: [PATCH 1/1] mm: slub: Introduce one knob to control the track of
 slub object
Message-ID: <aqscos5ivap537qljhqa2pntrxfimfkfuflji62rl2picpvaiv@sams7xovbtn6>
References: <20250723080328.4012263-1-quic_zhenhuah@quicinc.com>
 <aICpMWKNvhveAzth@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aICpMWKNvhveAzth@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 33A3740004
X-Stat-Signature: fioxwxak6z7egiw94ubz15i4hgrs3wmg
X-Rspam-User: 
X-HE-Tag: 1753270731-215490
X-HE-Meta: U2FsdGVkX1+O2dnsjketh3PxxkA79kNFqMnaOsmgojKSQ06Vn5CbuX3KIftAaB0Lz6ubEOUnH+PFL8APaQidzcT9Zo1gK1qTzpRs/LcwyK1fXg/whJ2NNW01nL/RQd6hAhKQXUHofINbPwcNvX+ryDRTpN8/+uOUJlLZaCgM13BH1YzNHKWkkIn3UoZIW5Tewh8uNBzhQESAPOkaQPPTRU1Gjgmko2cK9PsnUzyIrBeGmn00PAgnK8EiinUkXbKGbYcCEVN3q7JBxFClw/1SOHAtdVsf6CR498sPlhxC3QWgTLaH5VIuQjGhSKdClptI2T7KWOkYwJiJNwa6tX89PDeckzdCvz3fJVbVqqMc0gZE0IZ6L4ECpDKNvphtvNJG15SqpWuF5eeivp5JDYELdKsyatQ0PsWsiNLIg3sJ2+//jyfAOYoT21pIiaZe1+lAccbmhrW34itjFzsJmHKN0MCa9UgqgcmFz8wxJha1rY/8zfsheAa1SQC5RDeCg1+2AJUyMmET1PKDoL8oM8bYEg886svXm3Di2AQNxG4R4P+1ub7W3x/YlWPAqtCYmzzD6BvpXvgCR5PWVJ5RY/E8QjPywYbAuEzS5Lsi+9nsgBUXZLwSRsReUhybTINLUrsj0xylLLvIR56uLD6+84GPYwJZZbtg7qK/XagBY6Uga3VoefUK/PVwrUGAeinMyLLoQ2qzVarDZwzNLjujv3q+bmYY8djHnuaCXliyMiCVISgYTP7XHtIJbofBZ6O1UCafXgtY/F7WivbF6aQCL2SrUS7YJf1in5eqnqyA7aJYonKcgbiHq2OUVGH3KNHqrcwg6MMzX/sz7Ekjal45BlknVHo8XIHoQ5BSLJWN+V/tzPh7u+OPE6a7cgo1LIKfGUce9d35Hkew4+jkcD7Sx2ZsmMgae/I9vtGymquGMv0dSMOubSRF2btspdYPhvg6pb1zya1x/P8cCe3VmOtkmzT
 bZvuLH1k
 j7T5Nn4+XXdkjeuhKF9WFxm8KBvLRK2Y+BwIKFapDykOMfG422dh2miL7u6Sn6g3/RpkFcMc1jJlfnZ8AMg93odqcP9tidxIYL/OU0UTbjsW9UX3okQYYg4hx4VN5Pb60TMptS2UfHlOkshvi1WygF6aEQqWbcj4EmWh6rRdc4/APWtuERlEQnB+GdlYXalOq3PpV95A5L6xjVHbmQhMOTqWK2A2k8Jv+TEBDo8UGx19pQavDRcLOqa7DtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 06:19:45PM +0900, Harry Yoo wrote:
> The subject is a bit misleading. I think it should be something like
> "alloc_tag: add an option to disable slab object accounting".
> 
> On Wed, Jul 23, 2025 at 04:03:28PM +0800, Zhenhua Huang wrote:
> > Mem profiling feature tracks both "alloc_slab_page"(page level) and slub
> > object level allocations. To track object level allocations,
> > slabobj_ext consumes 16 bytes per object for profiling slub object if
> > CONFIG_MEMCG is set.
> > Based on the data I've collected, this overhead accounts for approximately
> > 5.7% of slub memory usage — a considerable cost.
> > w/ noslub  slub_debug=-
> > Slab:              87520 kB
> > w/o noslub slub_debug=-
> > Slab:              92812 kB
> 
> Yes, the cost is not small and I hate that we have to pay 16 bytes of
> memory overhead for each slab object when both memcg and memory profiling
> are enabled.

I believe we did something about this for page_obj_ext; the exact
pointer compression scheme we went with escapes me at the moment.

We did it for page and not slab because page_obj_ext is a large fixed
size overhead and the page allocator is slower anyways, but it's
conceivable we could do the same for slub if the memory overhead vs. cpu
overhead tradeoff is worth it.

And - pointer compression is a valuable technique in general; coming up
with some fast general purpose code (perhaps involving virtual mappings,
we're not so limited on virtual address space as we used to be) might be
worth someone's time exploring.

