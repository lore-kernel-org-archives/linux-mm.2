Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F1DCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 08:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3AF86B0005; Tue, 26 May 2026 04:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11BC6B0088; Tue, 26 May 2026 04:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01366B008A; Tue, 26 May 2026 04:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AAA9A6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 04:21:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 799691A02AD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:21:55 +0000 (UTC)
X-FDA: 84808877790.09.37BC237
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9004F1C0006
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:21:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E bSZoOB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=furBzsQc;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779783713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQjXxGFL5Lg67GSyDSM6dyIeupTs1FKFZvV2GOAivr0=;
	b=RKLfQaCJI4mgGPMJN1YjdKQxsLCeTAgoUkzTcIWCc9osg78QY1Dy8NdbBi54WEqetK6lRM
	xSMUmDRrUcY0WhLhjDG2jCB03kwzUA6G6c/DnUADWlNUWD0pOaFxjvyk7xWjjMfFi5I6zV
	5qoooR/qh0nnoUNol8KKsD5URPn2VfY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779783713; a=rsa-sha256;
	cv=none;
	b=ZjKV0pkOty0oO9CxS79/ssrksp8dTnhhAfCTBvBiPrgL2V7bB5uM8OSVfYZGarc4s53jlz
	GAP/izGcgEHB6+kdijZHn+fwqwAG2PpfaF4jyU41wBkTlSlK2QnolEvdbQcLO/QJ4kEkap
	cnRFe4J4fhS9apiVHClubmNbu9XfELo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E bSZoOB";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=furBzsQc;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id CE9D01300098;
	Tue, 26 May 2026 04:21:51 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 26 May 2026 04:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779783711; x=
	1779790911; bh=wQjXxGFL5Lg67GSyDSM6dyIeupTs1FKFZvV2GOAivr0=; b=E
	bSZoOB6ff9yD6/VEnqTMqTzIFIge0DRBYape1xA77WJbH68HHhXCNQQevy78b/5s
	Rf/J+X1CJ461tvRk5IwaWTb7X+ml/aA55f0Mw2E9Obs2zmNaN6dvIFiursq1//2J
	Z+c0OL5Dg7frIjM6UMugBgi021oy3flGqxDidMRpbGcYCtjrAwlKsjCTtmvfPcCL
	1TTcfR+9oNdk+N2fwIXJW05luI3rDdEefK6CND2+aCX2QM97qlncn91sCvqcj8TQ
	cE7cEBh3LzbtmtaNFo0XR8ezRaiej1RQbtdz7G3jF7/s4LjJElQqu4JzMvMV03Y9
	0w32sxfKVvl0sQyM79Okg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779783711; x=1779790911; bh=wQjXxGFL5Lg67GSyDSM6dyIeupTs1FKFZvV
	2GOAivr0=; b=furBzsQc1Q4glZjGfRj6U97GnnIbyE7KdPKCsClaRU7r/S8O2Zn
	ZBqkE+p4Oi1cyypYt4K7SPcYl3GHWM+vcss94wbMfcmoXXfBej33LHI5NIcS46bI
	i8BC2L8ttC6LI+2+AM+0tRYg0adxdRI43GsGrOc4H7vshUtqLhdQKcxt1Dy297JP
	HuYDqtZWASEqyAH6LZfUC448OOS58BogHTzX6oZ2Cqmv1COvJp3RyycK5Ct3G+bS
	frY54sNqw9qVWfRUHvAIq+rx67MjlZKhSAFAdPtlzkJDumm0yQqmusFdv8DVGprL
	ArphrYaamLkD49ciIEc2rw/z9rmvJ6nhYgQ==
X-ME-Sender: <xms:H1gVahWEOl6lQaHH5I9-6Y6sQFAUA_lBCmGO4U0d615pNhOVxo0CMg>
    <xme:H1gVap-jTrAh0tuLMxPN-6CthtN9If06XsY9Ic4P2QA_Pc0zV1D0PqhLDQii7BFDW
    zzHWrocheAIDm8-t93kD-mvxs2Lxzd8i3cFDgUIowNhEsk37sHyyVY>
X-ME-Received: <xmr:H1gVanrKRxJ3h_ACpKSNg_0pRqzuNVQcDy4m0mPBOMGb2XUrv_afVUMfF3tMQg>
X-ME-Proxy-Cause: dmFkZTFVRF4ROBUmcM4hrH1rPz69sP/HFNDpACqKIdo4b+hALyZE5EaMnrNSuoBbpZNyB0
    nqeUFxhnfH+dLhiV9z7ujtcLPqsdJDhF/oYhZOfD4dZFHr6PPfvVj58Gvm4JOLxXnyKsPS
    sJ8Fhto7GS92EsPkmf30kDQzF+BdauRj/CHeYxvZTekBZsSXcKJ2uLhyPskML7OP/LintN
    W5UbK0ONoP65MQKF0161Fr7z6DSeT/aMoulLSZ+gOZaye6pXnXHnm9hyCPCV+3HxzO9TuT
    /6QGJlCHh+MuEiaxBoHdq6q8m2T2yLDq45K4OxKghO8GogTwWUPj9R1gBbFKfQ8GKhDPGK
    kieU3s1wgChMWdmysZgtYhacCwJjTE/z57h/dYC7VuMJJTJAr3umOnbTD8ZhKeVAK/8cEh
    ZR4+lpAEkWVcbRA8G9r1Z71w6ZTTqAxEIckACVYVv/xkElv/EHY/kpdclqcZWOam2IF4Vb
    QGTWLQQrkjtaQI7UUgvX6OATkjzkWsQS3xb0wJuxWecYWD4UsKkSIIsd8DZ/+40Wm0CgWw
    NR+fZeeA5kkK0hZnUX+G1qT7RifK/4jMTSucw/o05SGvIwUGMjZzxhKvoK68ucoyXPcYD3
    8ou43prSxxZOBDrMrSjdtEwtbG/73oyest4J1o8bggBD5gYBkf5re1j1axPQ
X-ME-Proxy: <xmx:H1gVao7b0dRVl-PnEE8BWR3TTrOqxqdR0NW0urHk8lYblgLi8MAIRQ>
    <xmx:H1gVao6Oi4mdwVYQ_rApI1rzMc0xQlyRtZAmJ7BK24PvP6r61D0J9w>
    <xmx:H1gVankmwyqJGA90XZ8vNzDxvZDQUHeCMoF2dwRfBU9NTGyMuWBngw>
    <xmx:H1gVavj-wl39pOMFhQWI2MabbWxzdmAg5Ao4cS-wHFETDcT2u-UB9w>
    <xmx:H1gVatC7sT6FImTCQ_qXttStSS38HVnn3YyKeSYgNdKJ-Qx-NiJVQ559>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 04:21:48 -0400 (EDT)
Date: Tue, 26 May 2026 09:21:44 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and
 UFFDIO_RWPROTECT plumbing
Message-ID: <ahVX0DXLhqo912j_@thinkstation>
References: <20260525113737.1942478-9-kas@kernel.org>
 <20260525121111.E857E1F000E9@smtp.kernel.org>
 <ahRoPjww-xTjjl3O@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahRoPjww-xTjjl3O@thinkstation>
X-Rspamd-Server: rspam11
X-Stat-Signature: pdygzrupmg56jx5pd3pwwkw9oeoqft8p
X-Rspamd-Queue-Id: 9004F1C0006
X-Rspam-User: 
X-HE-Tag: 1779783713-963876
X-HE-Meta: U2FsdGVkX1/vJelqzLhJPZJM5RJHeOTqunQSprZPH+qD3WCrgChBNximWBYpO9lTtj2IDnlpnWxy36euXl4WejT4KUhNPPV+f/dE1RE5++5up6tk3NHNISC3GobvPL0j4sQZ8P1QqeO3Q560OusvALxyUE7rW+2WxT8h63XobcyGoOcH+QQND7EPR2NyR7m7TsjobWe5ezB4XPbupkD6cDXHnBDliv748ABsA97AG/liSoVJfHuwG/JKyaDOEbxPCCTDI/PddemTBRBCpNM1Akf5Y964QskQk68ly+XXQ6ri8VC8FaQ4O0TmGF/iSK7BBMEbZ6CBfhNzcoDXZqSNBqbOfrq8VUzS6zaPZBTy0zq32zi7fOC5/nCoIgLwTaVdX+F8qn0zEcoZVscSyQfoCEUcAVAFyATR9nWfxqgdAZFAR8ZN9nt5VolaNI1OkyAXxI+0CfSbZsaYg7SZ4w/BgP+kMCitwtLK5eaDPKgclkZluODc9rR/uLgAv4PxnHaKHHuPFH6Xhw4Q5CuSVxvZ/HWfNMbGyIkUtVNTrYWAfcz3cTaaHonDbYKf70IZHdXGcR1XaAdW81YXsscIZ1+SRblRr5FGOAApZNkefDh9jwRKEw40ryaceTh5aB3Qw6o0bOrqNJkBvxmBws2uBBdAie94Pdfm+SQHO2si+mBQVWreRN0LSLWc8MqIVxQb0PLbnAJ5cpoVoJ2joSieVfDuCcV2e+wfCMYupMv0DPnrchk4Tvde0PYFbvVtdPeQQX4WVWddC3g5lxyXsFTjhDgCz1gK8Kv3+kxqazYCIPP7RwdTDfUAKXQ3HmTL1NAareQu4Z61K3kAkv6BbTnfCOtir4tOk1nekgNCYBF2abOdVQlIKSG6MzZmmgx/o0CGl8nwTsF6BQLfotAswT1+i9IFKCnHQcFpvCzaN+b9q2035LlyCirhsVk+Ejimi6kyXTVQJ/S7XAHDeVayOvzd56e
 fU8Z5dPY
 FOmKFlMLU6k527ELYrLqAQcS4ZRoMsKbWsu/oHlBz2B4GYPyyBWsW4thwSx3XJCGVKHMjJNnTmuaVAI9TaseMO9avViy2a4HStqCfwOl7vire/03XTl+llCssKnlF0VQGOO1PzxCenWXDYIexOmLtYMluliVQrwgQY+CUy6L1qqZxOVvUrVkdGsFXMcKoPKnDtolWZ5cmD+YpYyUT7OsG/fGdObY9T19segNUFQW8mso84zDR8izWl92kTsi91CVC7/Zfe9YddSs40GLt8YCFzMbj3W5y6C/p7skVnWA1CUaJMW+eSe8tvfuMueU7LBPqXLzdZjvZnGcI2GHNfZIT8Ldc2OGnsgpLS7PfrmW5LaWmqip2Ac+VeLSICIfQV7aP2YoOAg7avpd2RUSbRUgBg2Kmu5cHPRrzWngRA7j8oqmt5OfeYzHJ5QTEPbd5TrjGWh1+ew/PdPuXYlwormt4uIjC5vyBFSsuMfor9c11J8UzO9nZj1U5/LdEwl3VIxK+0kSC3ANqHMAE+7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 04:19:43PM +0100, Kiryl Shutsemau wrote:
> On Mon, May 25, 2026 at 12:11:11PM +0000, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > 
> > Pre-existing issues:
> > - [High] Page tables are accessed and modified under mmap_write_lock
> > without first draining per-VMA lock holders via vma_start_write(),
> > risking races with concurrent per-VMA readers.
> 
> Confirmed and pre-existing -- the pre-patch path called uffd_wp_range()
> which has the same gap (no vma_start_write() before change_protection()
> either). Will address in a follow-up that audits the userfaultfd
> register/unregister paths together.

Looking again, this is false alarm. PTL provides enough serialization
here. No change needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

