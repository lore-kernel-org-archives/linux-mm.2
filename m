Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CAECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3C3F6B008A; Mon, 25 May 2026 11:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C55F6B00A0; Mon, 25 May 2026 11:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4B36B00A2; Mon, 25 May 2026 11:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 708586B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:03:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 225C64016A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:03:32 +0000 (UTC)
X-FDA: 84806261064.19.2E54F09
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E0E8C001E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:03:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=03IsWniT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t mc/uU8";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721410; a=rsa-sha256;
	cv=none;
	b=6lACf5VQm7eK7HWiy9nRdJeJ9gcO6uOamohRSjKlhkC1f+tMhjdUjEwck7huwLm+k73/7n
	0pZf+Gr7ru+x23/IC9rwMRWWtrWXweVmxCu3947eMf92D/6NO7W9F7eIw9f/8Th+zngtnT
	iR2u91SkDZEprUrTz4y/rkWnfN8gD6Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=03IsWniT;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="t mc/uU8";
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXzZ6FbcGPN2pMfLDn9YDPXN9/7MMjZwWofNjo0GBTY=;
	b=q8CZKbp1a3Mch4uoRoQE5cdVvQX/UQWow6RHfsEPys8O+EzkRmIlH6fIWzVyTJ9QHlG+mp
	sGpKdpf5PWB4czJOM0Tbt7CRj0JqS/nBWhNT4ONJxfa7nnKPn3NnSE/z3Xp4cVunFxMBKG
	6keJQOo7b1C0pujyPt5fvZGC0tAFjxo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.stl.internal (Postfix) with ESMTP id 5855C13001E9;
	Mon, 25 May 2026 11:03:28 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 11:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779721408; x=1779728608; bh=SXzZ6FbcGPN2pMfLDn9YDPXN9/7MMjZw
	WofNjo0GBTY=; b=03IsWniTRnh1R8EAfEv5ai1Zo8MK0BrKuK0/hG1OqccgJOKE
	61QEpso0G5CifSJLVCpwlP5flwvH4QmrPIrFTX+OZwZjHkKXvAOlGdpqD8Gd7tfw
	p8KCNiIsHuIycy1Hr5qs3Acd7gaEzoCtkrziqEN3OyrgjHHvMXGZ4SV0o1hZTrEC
	R+hrmqWb76Xf3fxEiiIgIVZYMvtxKwyOd9m5pEHmrb99sSY9lG7CE1uLy8xkfRoh
	u1vg76o1i8SkHwTwEgDBwZeCLXPNHm5vqOo+5WVEKyh5ajitTIr6857pn/xzgnIn
	YIp/ctVEbQMmcvJRb4+JwvoZ9pFi+AvjUvkiDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779721408; x=
	1779728608; bh=SXzZ6FbcGPN2pMfLDn9YDPXN9/7MMjZwWofNjo0GBTY=; b=t
	mc/uU83cU2iH2hS8K3ryhyqfxqojV4CyPJ3fM1ysHdcz2jyFPiHx9kI8YPE/kJzN
	t+/rLHVGNjjxx9LrCLwM2AgJkhv3PfJwbxj16o3y0bvZefZ1CzDtyaFs3w5fq/9z
	FfD0A/kcxSHCnVsAY/mKEQUAq8U4g6DHZr+g+i+vK1lYBzuA9ymKs64ehLkNO1M6
	LlT+IpTK8B7balmGjYTNxwwA+zPBMkPulfcslwyzqbE1/kRCrCiGuDdG99RoravM
	dQHxlL03CxG9hYePKEsj/0R9sB81z195Y89huv438+dIzgs/3kRlS3734EIsHCyO
	3Tmr57n1jLmguaDmQsXLw==
X-ME-Sender: <xms:v2QUavaJr7C9BVIC8VOg3HPIMfv-TiLnJ9Om-GUEwvq3xnUEalgO9Q>
    <xme:v2QUamxK1nhAF7UtfBFTnCVDUo-MzoqyXoo_wlwkpEqJJdPivyFAdUVbQphPxxa_L
    0OJPB4sBUIAyUiYk6Pzk1Sqf29IBd3qzQfGIYQSwh_hKZrX6PndbA>
X-ME-Received: <xmr:v2QUasP94d7p0-T0j59dhp6_nf_9BtetJEYa4gj8twWSLOBQKDSpU_uT-_uJSw>
X-ME-Proxy-Cause: dmFkZTG1wMCWpF+jWh6JnSJRhnqCk8CHl4QtqDfProGnjDknbTusgbpse+me6X77xlp8sU
    pPNxIj+Mp+FdEPWI05pC3HZcM0qkOFDj4/tQ8sG9sMRhjP7fWYuRX0pEYH/g2EsphcjVGq
    9MAevLENFONJ+wVfywlf7YE9Bs6NntmPIbsNW5CXGsmDD9YGnkmsDNfDQc4r2ovKlufsa/
    Uz2NHnI41MmeV+FXzhmNvyFKUNJf+mNu2Gv9qFUBO/q4AVDJAqPTStv1i7KbreaRmq7P7T
    JAC1hLjWmv43jXlh+xP8ebsETokOEoVOATwSiRSi21F3NWJyrIb+XpEy5jSNJBS8Ir9cVj
    jdysgh+hAl6d2YdjAzJThYEATI/wa/dFbqQHExdIK4RThCagFnaeS0aA+bGUkXbsVNztNE
    ZsVizg+x4f6GA9wsgLe9QkLn8I6h1P+f1lLMWfdkuRDL1yOxYjzv+Jyy61c6ebXR7mC8I3
    lW9eHQOEirXnGa4mSmwz+N8Ih+ElakvuT6QfjMMIm58bhCuyQ742HyN135kkpjeaqOow2A
    hxD3ZnePQheD048cxkFPSWmQoO2CcAO2GaSIInb3foDl8W0cc+6xM43FEdgNynpCVO859A
    55hlF3n1FZ+3bfSQFB/YtAhTiFKIbz93aq7YVB56Hb0w+KLMlfQhY0ddSJow
X-ME-Proxy: <xmx:v2QUaqNH2RFPr464jd7IZ01S4AOzG5mV9iey23pXW65mvzu-tAAXww>
    <xmx:v2QUan9xKwpQh8OBcLNwEykEIaFn_p9kXm63OvTQ_5pLeki04V7ubQ>
    <xmx:v2QUahZN58hm6EJFRMNWDcratJG7qQtbMP4seq78FZjndW3XELmcqA>
    <xmx:v2QUatF9lOxG64uz_XBfM4O_IZEFpPPsHfguDQDVBpLaerzNBFzF_A>
    <xmx:wGQUaiF9GbJdr7UaaFw8v8MKqP3w8hxqSDjoCEd2WD0j5MrJhohR-a7S>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:03:26 -0400 (EDT)
Date: Mon, 25 May 2026 16:03:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 05/14] mm: add MM_CP_UFFD_RWP change_protection() flag
Message-ID: <ahRj49iYG7bWz5kh@thinkstation>
References: <20260525113737.1942478-6-kas@kernel.org>
 <20260525121319.3B03D1F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525121319.3B03D1F000E9@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E0E8C001E
X-Stat-Signature: hn5ynu6s8a1jfpmr1o9xi4eth6tatyx4
X-HE-Tag: 1779721409-693372
X-HE-Meta: U2FsdGVkX19C7t18hU1vbHKRStqPUFTJCtl7B8N8K7S0iCqhTsWfSekoXViitTzRSWhzItJf3pAHT503E6+AIORoYzaa6dG1hfjVAqCAmh9GbBxcucMOJHrhMqtIZOlWCKdP73w6Cw1ZlOelJRiYd9+lQXz+ioEDYONN15iyqOCvEkxxB01YN0XXTrwml6Ksc2q62nQ+PhvLY5NmdY8KaOsatjRGh2LSk1QXp/wbnXnFLPLKRyCfs0RG9NBrh11Pb78L8LW7Aa+MjXYAf6avjNjLg+RhGNeB6BKiVcEJaO1PnkjBsTx7WUzwGaDpQxb2OAMZWYKW+gQcgVflhtGiZIIszu0nGcQ648neNWNKKoLnseVDI9WbxYtSj6j+GzcuKIM5BmEvvzpVRaED8XJhGYQ6kHgYsBbvTzlRGefopR180W5wNO37XTCEm4zoZFbw6usvu9WtngvWpWa3LkYhJpQ2SK/7s0XgJoaTJjIYEcTL0fFpPTPhS0nsZARmagMnaVpN+gMsSPa01aw4gnMlqlqpK7cOslrAtBn5wnJGk6AexFuiflBF4dpQf+OdqOldUZgRN4bY5+5qC0J8PGE3iqfRs1Z6fImECUrIJptE/uvRGx19u+w+ROFCSpVLrEhbg+eLrgNDoO6WOfOhWvHnVvOes6YHk7+se0Y6MytOliDSFa/ahpSR4j8uSh0n+7zfeIkqf+MhHSB+m5O3NgI7Sq1+cRv7O7laI/wnScBHSEZHrNfUV1/MfYNWRuNkpP/NYpvXUzoa2L0HUpMPgXs2vA/UdHvJZcKaCASmgWtX9b21SroMEkDhg1DTT3uwensfMG9L1HCo6tdUbqVmOPIRkeWO7q2Kfcb7cauKJ4yXs6Uz8cwBPVFsxsoBR72QYCC8M8nUwSwAQZ9Rl3BjoahJrav2yeE82W+AkQhiLuxzXSEBYO5zqPeG8uOlSfnz9RSle9AkC/0ODo6CAECW0bK
 BN0OmXqe
 LuqNLuozXwK6lh8Shv4WaWxlWkFLphGoGLms2DKdfFGjAhGHGnTKWLVgFwYkmTXHlEryEMCx+xIYTDi+QE7p8gIFOb/9z84m/nqzpCSyvtvGKMOcBzBcv/DArih2luaDAziJdEIGf/V6kMczlUnNm7IXkFwT/d6oEpnD9pJP4JG6b0AGf+8R9pDW+hO5VFZpG+ZTFhEnrFcPeMt7PzP2+tCp3nBNChbwA2311ib2SdlhuHZ5PDGlXV22xcUjZmA8poAeF+CqHiJP/9rLeBoNiFNaN8pSZubfTGVuj6UAYLaAVUo7wgkVU3onl0KnRakyOP2NqFVxKamdRi/fpcqoQ5BT4wP9YpbHhfE0x9f9R989nTyISwVAMC8FwqAM879PiXxC6pRhI6DMFDsGMwq/VqXXJfcMAsnRyHYWG5jum/JcjAy4TRsX6vCYVvda+J7dKlGw3/iprhBni1/7WhX2Al+2LqYs8qZazxvAug5LNxj4XWxBmgxaXtORveRO1DezMGimtNQy/ExyqCiFT6bqq66nSgsdYf8/EzWnVvGQS/4oc2lHUFtZ4UqpTDbne7DCGWGQysRrw8RMgvYK7R6jlDgrfdVdz1mL5xYgW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:13:18PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> 
> New issues:
> - [High] UFFD_RWP silently fails to apply PAGE_NONE protection on
> architectures without CONFIG_ARCH_HAS_PTE_PROTNONE.

CONFIG_USERFAULTFD_RWP depends on ARCH_HAS_PTE_PROTNONE (mm/Kconfig)
and VM_UFFD_RWP is VM_NONE without it (include/linux/mm.h), so
UFFDIO_REGISTER_MODE_RWP is rejected and change_protection() is never
called with MM_CP_UFFD_RWP on such archs.

> - [High] Resolving UFFD_RWP incorrectly clears UFFD_WP PTE markers.

WP and RWP are mutually exclusive at registration (the explicit reject
in userfaultfd_register()), and UFFDIO_SET_MODE only toggles RWP_ASYNC,
not the WP/RWP mode itself. A VMA armed with one can't carry the
other's markers; the (uffd_wp_resolve || uffd_rwp_resolve) OR is safe.

> 
> Pre-existing issues:
> - [High] mprotect() silently drops userfaultfd protection bits from
> migration and device-private swap entries.

Confirmed and pre-existing -- change_softleaf_pte() preserves
pte_swp_soft_dirty but not pte_swp_uffd when rebuilding a migration
or device_private_write entry. Plain mprotect() over a migrating page
strips the bit, breaking the trap on swap-in. Will address in a
separate fix after this series.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=5

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

