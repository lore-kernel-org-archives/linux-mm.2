Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC13CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 09:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60828E0008; Mon, 25 Aug 2025 05:05:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38598E0001; Mon, 25 Aug 2025 05:05:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EB08E0008; Mon, 25 Aug 2025 05:05:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0198E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:05:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21C8283C74
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:05:51 +0000 (UTC)
X-FDA: 83814697302.07.ACBDB30
Received: from mx07-006a4e02.pphosted.com (mx07-006a4e02.pphosted.com [143.55.146.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1356AC0005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:05:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=iram.es header.s=dkim3 header.b=n15LO+qs;
	spf=pass (imf22.hostedemail.com: domain of paubert@iram.es designates 143.55.146.78 as permitted sender) smtp.mailfrom=paubert@iram.es;
	dmarc=pass (policy=none) header.from=iram.es
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756112749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzEViH2qeblykcKgZ/ETV2fumwaV6V/zw4MF9XRlfeU=;
	b=5P1F6jeRo9etKLDCLyjVLndGruCdxQsV5r/Cqj+vV6nQ774VinHTeAvoLveavEUqS21QNz
	PjqoXJ2LAhMIVAn3IZHJE9osFEK8fEEb2rIuTM1GRx5NWP1GSwXQbu+VRcyn6nv2YCqsAF
	1mKcQXmGooNM9k/PlmeoyqaB6qJAacw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=iram.es header.s=dkim3 header.b=n15LO+qs;
	spf=pass (imf22.hostedemail.com: domain of paubert@iram.es designates 143.55.146.78 as permitted sender) smtp.mailfrom=paubert@iram.es;
	dmarc=pass (policy=none) header.from=iram.es
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756112749; a=rsa-sha256;
	cv=none;
	b=7aPpsPr57pRkXoecN0KenvXkHWAF7AHjJB5uGVc0Nr7jc2nY7dJQofDjvJOJLmZU1Dt+bW
	JNARNSJYXyc5lZb0L5DZQ1FoEXMUrYUHyMGqwkErYAYG1tVewftSvdgRq3bQVZpXvy4cLz
	LI96vzwR2AHbGh531uEQKvfl9YKgVks=
Received: from pps.filterd (m0316690.ppops.net [127.0.0.1])
	by mx07-006a4e02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57P6PQ5K015116;
	Mon, 25 Aug 2025 11:04:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iram.es; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=dkim3; bh=rzEViH2qeblykcKgZ/ETV2fumwaV
	6V/zw4MF9XRlfeU=; b=n15LO+qsawzZh20Qn/20l1l3bhwYF9/v8hNwrHTt2L8t
	YHSDQEyu9J6ONEXYGoxQfYm3Ggf16oO3UwGJAZEK51gLu9abRXIVlP9ie9/udLL7
	Vlfhay/EhcMLO6GbTgoclzxF1qcLRBrkE3EihGPSdKezANy9+D2Cdx/5OLrK3z3P
	7r76IEpXgztUNYUxrEhMw0UXauFqIUi8+ZA2utAQrS4aaSkVhRNynL1fUj9Pj26W
	RYNLdEnGH2aGyRoVuxeiBaWTR4RYBRNkE7xsbyR/wTTSjB3BnhkWS55NR/lFzIsN
	npKqwMjN09rJPyjCS98FknJTNCPu5rvyr8UEZrzx2Q==
Received: from mta-out02.sim.rediris.es (mta-out02.sim.rediris.es [130.206.24.44])
	by mx07-006a4e02.pphosted.com (PPS) with ESMTPS id 48qq0ka2r9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Aug 2025 11:04:54 +0200 (MEST)
Received: from mta-out02.sim.rediris.es (localhost.localdomain [127.0.0.1])
	by mta-out02.sim.rediris.es (Postfix) with ESMTPS id 0EE4014009B;
	Mon, 25 Aug 2025 11:04:53 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mta-out02.sim.rediris.es (Postfix) with ESMTP id DD484140F82;
	Mon, 25 Aug 2025 11:04:52 +0200 (CEST)
X-Amavis-Modified: Mail body modified (using disclaimer) -
 mta-out02.sim.rediris.es
Received: from mta-out02.sim.rediris.es ([127.0.0.1])
 by localhost (mta-out02.sim.rediris.es [127.0.0.1]) (amavis, port 10026)
 with ESMTP id 6dKRDSvFm0JS; Mon, 25 Aug 2025 11:04:52 +0200 (CEST)
Received: from lt-gp.iram.es (haproxy01.sim.rediris.es [130.206.24.69])
	by mta-out02.sim.rediris.es (Postfix) with ESMTPA id 5905014009B;
	Mon, 25 Aug 2025 11:04:51 +0200 (CEST)
Date: Mon, 25 Aug 2025 11:04:50 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andre Almeida <andrealmeid@igalia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 10/10] powerpc/uaccess: Implement masked user access
Message-ID: <aKwnMo7UllLZkOcK@lt-gp.iram.es>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
 <647f1b1db985aec8ec1163bf97688563ae6f9609.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <647f1b1db985aec8ec1163bf97688563ae6f9609.1755854833.git.christophe.leroy@csgroup.eu>
X-Proofpoint-GUID: mUolfay-w1WXToAdGEjUbL3FPWWo1ug9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDIzMiBTYWx0ZWRfX8G3CF8JrmY3U
 BGgHltBwz3ExKiF7DjIdHKqJVml6dwPnDSIeKEc3k+1nbVINQyRJb932oCgW0jxo7xUZuvURGrb
 0lybQtEVPgVxAbInIze5gfIj2JwT3kZnBngcdOQ1rNrpkmK6XO+qOvi/3NYDqqlaI7ClQamdSoH
 vwbsnvjm2+kk4adUbYXXsz1ZxzAyoPEue6z9kJn/NUNd9sTJZPnYn6++gtQEWTZHxIgI1Mezejn
 IX5Dw/Tgz3Ak0bsTmPj43e2B8M+5UfPLHEl4VUTBjV1p6IqneumXH1JSTpP1qECQ20vWmgERkrt
 8sybnJI0U6q1FctZz3KfFVtLiKnzgBH2N40FoGH06e4A3x8tQFeAwpXa6Brm/2LjZCyy8v8dW0A
 gnkNeD2S
X-Proofpoint-ORIG-GUID: mUolfay-w1WXToAdGEjUbL3FPWWo1ug9
X-Authority-Analysis: v=2.4 cv=fJQ53Yae c=1 sm=1 tr=0 ts=68ac2736 cx=c_pps
 a=N+btqqeLiyZkBSWNmht35Q==:117 a=N+btqqeLiyZkBSWNmht35Q==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=XLq9KcJuiYQVQIFsEiUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=salida_notspam policy=salida score=0
 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508230232
X-Stat-Signature: 6ref896x11wr5kk1mf6yxfstf15py11r
X-Rspam-User: 
X-Rspamd-Queue-Id: 1356AC0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756112746-644638
X-HE-Meta: U2FsdGVkX18iaTSjf5BUhRQjLlZ5eJrXwgxn2clmOUKS9JLTfwtvhyZRiG86nbZBcerzxtUPrDW9fQEgvm9Re5Vrd8tma6nSSDG++nfkkih0kCadOuL4b1cAjkVyJC50k/mhp/51zYnOW8DEcDnWO2vGKjh7eY49EHsixdtJfrIBzbRSWUZYDwCFADdHsQD2ATsEHpJ9UdL/f/zZcg/0c8Ix7Bc3mshsHPWZzA6KKPFkOTx4CzGwPC6dAF6q7iGDXBmJFix6gNFcMtVCOTbEhWeD2Ot0daY9TqGiDoxLKwpdGjB4cI4pjoNSakAwVajgrO9KyZdj8zwdfLFYHXIRXDn5mSKl3TDKZ0eX25qEFI1Evw2Q0XGKv78xql49bDHU6va8KWDM3e5lMgAV6K0txv7z1qX9nSpjOkqHHT27K6AyBPrhCkWXrUGjf2I0ydZcAKXjlKcFO+QOJg3f8NcbGfjDpJ/hpYMxRD7gqcV8GTdmkyQogOQx8sP9wRUel2g6E30ABz6AII7vDvQZN8fOqJ1cpsU2e8BO9XJq3QfJNH48T553p80h7RJlMOxERdtr6X9bBNeImSI+OrRkZpuGn/tvW14DBtDCyDHitHbV/fOMAm2qTFJiEWkhl9BG7hvGRQNUT7TY8ZZRLMlCG1dnArMvt+pYV5cDXyv7BSciep+d0Tc/2S+nEAmxfCFCQElVaCTfN4Lr3j4ePfwdYl/pYxVrz40IkJz2L761ByxyrR46XmbxWGW6QLp1r8T+opmdDX2/BWbEqdY2yVrc17JgFIEiC93++zUtbLPrtiKylAqxqBYmsbDMn3TfWb325qaBzzZZgVOtUXPhyLl3w/gxe8g9/qAq4BBfCAfJI+GVU/mGkA/buH9OHmsGSwq53/aLNOL7Ek7W3Ej9vdR3VIu830rPWU/GJks20wmqDJgYLjFbrdnoPASBCPvO66cOL1CjZNPko2Sy6OpOpQ+lcpr
 OxHT8W7k
 BGSQ7owu7YemA4oA8r1nM+xpKHxfxjDfSx+heVCJarNQZll3LAATHBT0CAGFeIoDM6A6Y2i0NxXSAX5l0kIPRJUDwHHP8xT7UMOw/VPmZDtV/7LqGAO3UFfTzp5Skq4ijHrP9IUHB6oe+P9KHUpy3RjMEbHeImWFn+j2kN3ZDOmgha9laimFFCzUkWyL0HoO0lsxZ2O+7dpBuYt5WaJ4tklR7gvsxoVogEgsDBa9xk4WiNn830F+kG3FfJWH2VyrzjQLx6hNVXD8ywne1Bf6Ylz6GhyWHIeRvLGZK24QCtNUrfbrMvXottkDqEx6I1bsx+wHCEHRqUyKp8l9FyWU5S81dpZSi+4XqEQQpJz6X6Jn7TbC3E3eV0AF5Kz1lfcTwPtHa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Christophe,

On Fri, Aug 22, 2025 at 11:58:06AM +0200, Christophe Leroy wrote:
> Masked user access avoids the address/size verification by access_ok().
> Allthough its main purpose is to skip the speculation in the
> verification of user address and size hence avoid the need of spec
> mitigation, it also has the advantage of reducing the amount of
> instructions required so it even benefits to platforms that don't
> need speculation mitigation, especially when the size of the copy is
> not know at build time.
> 
> So implement masked user access on powerpc. The only requirement is
> to have memory gap that faults between the top user space and the
> real start of kernel area.
> 
> On 64 bits platforms the address space is divided that way:
> 
> 	0xffffffffffffffff	+------------------+
> 				|                  |
> 				|   kernel space   |
>  		 		|                  |
> 	0xc000000000000000	+------------------+  <== PAGE_OFFSET
> 				|//////////////////|
> 				|//////////////////|
> 	0x8000000000000000	|//////////////////|
> 				|//////////////////|
> 				|//////////////////|
> 	0x0010000000000000	+------------------+  <== TASK_SIZE_MAX
> 				|                  |
> 				|    user space    |
> 				|                  |
> 	0x0000000000000000	+------------------+
> 
> Kernel is always above 0x8000000000000000 and user always
> below, with a gap in-between. It leads to a 4 instructions sequence:
> 
>   80:	7c 69 1b 78 	mr      r9,r3
>   84:	7c 63 fe 76 	sradi   r3,r3,63
>   88:	7d 29 18 78 	andc    r9,r9,r3
>   8c:	79 23 00 4c 	rldimi  r3,r9,0,1
> 
> This sequence leaves r3 unmodified when it is below 0x8000000000000000
> and clamps it to 0x8000000000000000 if it is above.
> 

This comment looks wrong: the second instruction converts r3 to a
replicated sign bit of the address ((addr>0)?0:-1) if treating the
address as signed. After that the code only modifies the MSB of r3. So I
don't see how r3 could be unchanged from the original value...

OTOH, I believe the following 3 instructions sequence would work,
input address (a) in r3, scratch value (tmp) in r9, both intptr_t:

	sradi r9,r3,63	; tmp = (a >= 0) ? 0L : -1L;
	andc r3,r3,r9   ; a = a & ~tmp; (equivalently a = (a >= 0) ? a : 0)
	rldimi r3,r9,0,1 ; copy MSB of tmp to MSB of a 

But maybe I goofed...

Gabriel

 
 


