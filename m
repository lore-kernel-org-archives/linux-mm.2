Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0745B606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oqzVMeGG
Received: by kanga.kvack.org (Postfix)
	id 2E1E96B05B0; Thu,  5 Nov 2026 06:56:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293056B05B2; Thu,  5 Nov 2026 06:56:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1827D6B05B3; Thu,  5 Nov 2026 06:56:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9096B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:56:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94BCD1A0A08
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:56:00 +0000 (UTC)
X-FDA: 85400911680.01.C52F245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9D43718000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:55:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqzVMeGG;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793879758;
	b=ckECnNr6fe6RBAXLi5vsnGIXjqVmaptxJYx1oc4HiZLadJsWQnWetsuwALRfbA+rV9a5YX
	+BOA0lFF8gUBTbCe/jsM6MjStOwu3c4Ka6AM+neQ4PE+PdUV6RqXWam0gtIQtJ/co/q3FA
	v2k/gfHysH0EpEU0D92XxmW4cS9bztY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oqzVMeGG;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793879758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blv6O4bi3KniNZSZaBAb+qDrJFTIo2ZPaosrvloZpPk=;
	b=Htj4CuUlLSOoT+CJyqt/6aK4bik2BB43x9BtfMlnPB+pUboJC0Os5TFa2T/6g5IbCEfRJE
	erMyiJz8hFtObTSKVC1pziuwQXxdUbrhJI+33eRhYlGnJomH8iFkGMN114GaOPHo2FzRpe
	ebdGfoAojZ+d441C+0nEc+OXxpZIqOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D6F061104;
	Thu,  5 Nov 2026 11:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0071F00919;
	Thu,  5 Nov 2026 11:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793879757;
	bh=blv6O4bi3KniNZSZaBAb+qDrJFTIo2ZPaosrvloZpPk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oqzVMeGGZirazQHJMc84rnQz1Gu2mB70FSCvJkBrLvweibXF4wsY/4M0Y2Lhx/JZs
	 qw7Ea0EBOjtlGPPr4kmm6VzfQlHuIWQ/J7i2BbCEbBj2GWIO5bhR80r/ItPo7dpoBI
	 cAgTXtoqj2rNzhKyfF+eQqEAuZRHuk65nwzyBCelmqsImIVl3mA7vc1IHMUj0VRtGV
	 yPkd5BQstmItoEWVyOu6W3oTK7UX1g5q0tbVrJtv6GU3l3gJeLAdeIO5aE/nGJ/w5D
	 2S/Oe0OK9deFRdtX1OKlotSAksqYunR+WoGkm5HO31ndK0dxXtbGl2XJa1jyZ3tPOL
	 7apKaboUlQ19g==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 069A4198003A;
	Thu,  5 Nov 2026 06:55:50 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 05 Nov 2026 06:55:54 -0500
X-ME-Sender: <xms:xm7sarg6hkHAPeR6qNnjGTgOC0c3MwCRkcRyyDte-v2Nz4AuHE-Ysw>
    <xme:xm7saphsT_LOQ5_t9aQEuRe60HCsp6dNKYCbhW7KxfWQC49PQymdRBbbUn-i5i9sH
    QStLn2jAiEAJRwyCkhmX9Ae7rIOj7T8-vP480JX_RsiCJb1ukBSvOMf>
X-ME-Received: <xmr:xm7sajtbmih0YyaDyMm21NI9mlZlJKu1ERf_jsafuT_wkmX2BV3b6DPUd6U>
X-ME-Proxy-Cause: dmFkZTGlpGWVVjYxBjIq1GW6Bog5Gen4I6Dm00lal7CBkODI1PCEbTquXBXmwJLyHC/Pb0
    hMLtvFsGD3zC1Q9ttsCzhqKULfkv9x8zovlqzN/hdkPtWOD8WUDm+Daf7wKsKNUXKXlpo1
    bFIC6ERf0hO9ea/mtihFTDTyCipqWMJPUwRZGVRWX3+eBSgzzlFuXNMBzbbhxlm/Cl9kVf
    qHHUJaywNb3F4K6tjLmbyevw8rCLxUMHWT/9Cg7vbj68E6lN6xft2IojKQVeQAEiLSZSKx
    lZLMQWm4VlvPjllWVTTLhjTk/9OEr1u49yNsfSP/NsyNB352Y3dF2bwT4gQcnry4plValo
    pLBIrxlGDfR+ywb7rTy1vTBYhNUtZgulKr8/JOC/EmfHBLyljCXxPcnuZybgIU3nR8ttxi
    NiKVBEjcu+cD8pgA1PtU+/LtIQKKOkxMmEkK+2AN27LTuVqJRbL9HjNlKVqR6Vm29IM2Ss
    bW1D/tqn1Qh7RsiFzCWJnWmIGuFgJB8hm5YY9wNsUwbACh+M1Ai8sD5/j0rhKczYofrL27
    aXPtMu+wOfFCKeUYjR/MrD3CrT+5sz59Rxv/1Tg0Q+eOY2Mg2KwKNNAUJXxVMCWR0OVfE1
    bQ7XT+vKIldd2Uz1zKn8/hce34bPrDJtxKm7F4XRZxYtmRPCZ3bkrcCgt+vQ
X-ME-Proxy: <xmx:xm7saqTsbIEzTlIIyfCI0NvMcGCThm014x3v0iWjB-FDRz8L8axO1w>
    <xmx:xm7sasFTrJ6-LeqVH8QtOdfuMUwbHSbYmm9ap3kQlN9bZZLnAFIoIQ>
    <xmx:xm7sashUZrl5LGKDtq38sKALGMetuWkB1zjzVd-gCh8VJKBe5TmQMw>
    <xmx:xm7saqi_fCFvdSbiD3UGPjXEJwWp0mtld2wkwhPL8zMrxF3P2PETsA>
    <xmx:xm7samz0sM-HdoJmBgpTBx5he-nOGHlSFJzl8pION3Xtidy7Mpg2tcSf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 06:55:49 -0500 (EST)
Date: Thu, 5 Nov 2026 11:55:48 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>, 
	"andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>, "luto@kernel.org" <luto@kernel.org>, 
	"pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kernel-team@meta.com" <kernel-team@meta.com>, 
	"david@kernel.org" <david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "tj@kernel.org" <tj@kernel.org>, 
	"azpijr@gmail.com" <azpijr@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "rmclure@linux.ibm.com" <rmclure@linux.ibm.com>, 
	"bp@alien8.de" <bp@alien8.de>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Message-ID: <auxuOzjRJPqsTvfm@thinkstation>
References: <20261102144001.342837-1-kas@kernel.org>
 <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
 <aumzjHyJsshPJBUI@thinkstation>
 <b45fe4c2a730a23845a36b5beba4f434c7be7477.camel@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b45fe4c2a730a23845a36b5beba4f434c7be7477.camel@intel.com>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D43718000A
X-Stat-Signature: kbgsgfupxqgw8xdujqaq8i4dszdf4j33
X-Rspam-User: 
X-HE-Tag: 1793879758-244365
X-HE-Meta: U2FsdGVkX1/PhBPcFBzSGlEYtvV3RL66Ni31+jgj6KnKajL7HtKl6wAEKdmW38fIpodwuiu1kZgdoUpvgDck0CULghjvk9labQgg4FNpoeUkcgzEEYNfdvFnraavyQfgISjDxl/hOY9VMIZMhHU/lX/4PyLKXB32CzFOiOMuvnZLvm8I5zzSr+3rW56IAfTyWie/JnF06inswYSnn+h/bjK2gue8699TbBPcmzl1lc//oDRyXRHDDsbtZFq+vmG+G8mlcHX7pGRgTHYmJ8Wmyh5oaWFVTNQ/n5eSNl2Jg4w3Z3YD+c4PbSduwS1FAndsQnID4qHyHTFjyAcSke3G0sg40p1pmAvjMQGgsG84u/J25BEj/RL9YE5xHSuhb/CXwN76Eocw8pNw5VufxjPJTAnj/17QtblSm6WGdPcwl4Am9URxhRtyCDdmb0Gq9F80QGZYL+IXr7R6kXZgLsr5Sk9ZQYBpHCw9p+InkV3UaZutHep8oZ5h6dOMe3PD8zDS0S9vJN1Sy598jzTBo/+2d1TJ+FNVZ2+swpOKEAxhaPlmmhd02yDR2yrYFLinia7BTy4h4qcUJglwTE+M8xgh+muXCwgJld+TuIwxgLdh2SvNxj1+9V584WkwMTsHg8zXkmDI/7M5rN4iNxN5i4FZ/BiX5nt4odIl/6165dI79V3njx3jXyjc5tDMjxa03ZG8RPAB5sYl10meICEcgJ8KsgseRaIXOj6xVVq6NvJBf6JFdA7rkf7zCBeRpqxEmTkfHik9Hh56nEhxRTNzF3v1RX/64sYEQ0Qvz2IyFJURwz7L6PJQIXJVMPGHFK04RS88rdCabkW8BCaFYfTsDZq2UamXrgqjkUxLtJNwX3X4x+5lB4O9mn3F/vxlNcSMUGgHtUaW0vK+er+h/o2srP97+SfY+NyFPlBHx0Vw7D1kYtv1X4RRlvEMuVUdVKzsTll9CRvyaz83cG9K+29n20L
 DMaFMupn
 tYzMTVzWbRMdP+1w2w1VRwUIfGwWieacNe8oHgBlC2m+2OQ4t/wGMHC2Q6xCs8ch5IaWuEU0q6x+UREaDWWEXaf6ahUCHrI3fHcoAGfH8/KjaOHsBv5tEqQ4ez5HsSyrbpKTa3yfaYSqe5nPHicbohxPx6IE/EFSRsFT7pt8S/+ZgK4juzXYx3oWWiMR1l7dJB8WfqWCCC2VxUloT1TYNd8EMklyeES0KYTJWxUCycLzP9ADFOIrLM5O8hmCFn231uhHxtc1UZfqMq5WIuziY6DHJubiwVWBSUZwDf0lwSneuJfuDe/nQhKRhdpeBkbyU2rRDQr7eaDD8KYOFPfXULso2rhn1U9G60n5DQjqGKJyGWA0cmWkZQCIx8XSaVBBspvt9Jv50V4Hs+jwDADmsa8I1zjfB+PCvdQQnQmyVNoPBW7qoLXcDgb3GXPOj2LIHvfqXEHRD3nxn5aqIqKQqa6We7C9a62rsEUOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 03:50:04PM +0000, Edgecombe, Rick P wrote:
> On Tue, 2026-11-03 at 10:13 +0000, Kiryl Shutsemau wrote:
> > On Mon, Nov 02, 2026 at 01:12:47PM -0800, Dave Hansen wrote:
> > > Or, heck, I'm not that attached to these checks. Let's just kill them.
> > 
> > Works for me. x86 is the only architecture with them, although arm64 and
> > riscv have shadow stacks too, and the x86 helpers already keep
> > Write=0,Dirty=1 out of other VMAs. Patch below, without the Fixes: tag.
> > 
> > Rick, any objection?
> 
> Eh, I guess I'm lukewarm on it. These checks only catch the case at zap time, so
> it's not a huge protection that is being pulled out. I thought they were useful.
> At the same time, they have never triggered.

Yeah, I have not find any reports.

So, we can claim that the check served its purpose to stabilize shadow
stack and can be retired now :P

I will post the patch separately.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

