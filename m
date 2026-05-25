Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889AECD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846CE6B0005; Mon, 25 May 2026 10:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7F26B0088; Mon, 25 May 2026 10:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E62E6B008A; Mon, 25 May 2026 10:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF1E6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:42:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBF34C0309
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:42:00 +0000 (UTC)
X-FDA: 84806206800.07.50875FA
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf07.hostedemail.com (Postfix) with ESMTP id D2A504000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:41:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Qe0PHr11;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E 4IUI8S";
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779720118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnS5+hXg8zM/uBnkqtNnKx0lfH+fdAFqqZps+s+LYiU=;
	b=gDWoiB3P4o7IamiwFygLBuu6M0K3ZYdXP2up76uU2sNTVhrbV9s+3iJKGFjvHEjSEVp8U2
	jtzMuWk+tO4Ltr1GfwxCR1EEQXPt40zFhypaZx3Cm4KhE2vtq3MiM+sN+72ts76kWRBkPI
	5vqQnwJ21g1qURLcf/Utfch2rNNBPdY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=Qe0PHr11;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="E 4IUI8S";
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779720118; a=rsa-sha256;
	cv=none;
	b=LPPJDcpGj5wMg9Uta6uDNOP+S3lFp8Orlt5wQVJr5JRr/GO3JQEuzwaFKs8IDHJlb2OvQx
	YRdkUtZY4oai3vXUnD4/z+RZXB1Znhff0TtQphF8Q02ji2MEW/fTz0vLWdozt+fmaEz3zi
	faSstQMiXkhSYVOjXPWEniSCg5sPVUE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 7CC34130038D;
	Mon, 25 May 2026 10:41:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 25 May 2026 10:41:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779720116; x=1779727316; bh=PnS5+hXg8zM/uBnkqtNnKx0lfH+fdAFq
	qZps+s+LYiU=; b=Qe0PHr11cnnci+E7a8ArJ949nEn6XQaRRTNfJ+pbk+qmsXbq
	OkXqr7WFi4J5MkKlNv/jH1A8IIPyCZ2bR85a0tLbhaFwWburtTzjjwHP7Kc0yObN
	Nl6P5VB87zOaDDMnNjKw80jJ3fTP+KOGVLlgBIXC/mGZh5VSrvWlKJX3iRj1nUXp
	1VWy4P6FC83ZjlBLLlcoImMGgxZP9iQLIP37OrnhuSbrgwtDS1BJ+7Zax4CEInyU
	gSXm8Ui4w71NVEoaWIrzV2i+yqQh9SuRyYsZFL+4j6HQPu8qOJQZ1xQY52lgjsbS
	MD9uWjxfRPYWGmZqDd5rjCCngbpvFwBfveSiGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779720116; x=
	1779727316; bh=PnS5+hXg8zM/uBnkqtNnKx0lfH+fdAFqqZps+s+LYiU=; b=E
	4IUI8S5Nh3vDp4XXiwdQRaMdqy51ZUdd2568cGLJ5WsAf48WDXBOHyUWRhWWsuH9
	2ohgZomUnOBHrb6hF2inIBHXySB5I9PyVNSzDHHzTmae5dDEYiq3UG1XcZ0PyuQA
	MpQT2alGPx4O9PKfhLcW33Xovn/TGUPwrOVf3sFu92RbsyvfqDgDLfSKIPgHxqmw
	T4PRDeG70r4Jun5zZH2IEoI8X/JzaCrhU/O/zpDVpXVGWXYINciNL7yGobhEtPE6
	EE7mpW4GKH6zSWOfwESsQTnd58W5aAA9rwAXyx13xpNLmNA92jG9rkHLjEwRHwID
	Qp/9pyPG7TIIS0hm0u5hA==
X-ME-Sender: <xms:s18UalRHDNFeOe3OTBQrFotPD66VN2u2Ly4GPFB6QarTbGtKrgXF2A>
    <xme:s18UamDgnrsESAku88fIMRB5G-1vL4ISJPgekl2VsLyCx4yy_gyKuab9cacA3ftjD
    0nVp8lMdxSY-9FwglNyKMoiIzrUgK9lMFaJWnNOr4RdH3b-FlJc0g>
X-ME-Received: <xmr:s18UavhHw47OsCkjPL2rGtIolMQGuALs1a-RxsVw0BEu25uYsPtoygDaBOom8A>
X-ME-Proxy-Cause: dmFkZTGHZHLMjCHc643dxRklLh2oL/Fj1m4IuOELcM7KtVw32eoEW7vO/KG/cKBnN9WuTW
    xcg2IQePNYL331E/+iFrg9l3Q/0DfWc/pfzb7vWOi1Q3A9a5dIAx/Ip8sizV43jID8qi2T
    lPu7yzYYlC4jDwy9+0KEeh9FZYrc3IDuLVpMqBcYmpa2tVNF4MKCjt0kSOcetEMay+qG0j
    wZaWuQuIE2LusEhaCt/KcTuXfzwWNSSA/a6+c4ZC+utd7D9qUqXsnLmKd9bKV8qtvZC2fr
    pc8OG7aEFZFvhoMbEdIROsQzF6nr7BIT6NX92DQHbwsijQVdrSxa73C0r4i4pngBeREvjN
    hL3/kqYaofWdis6FczySG/sGGaRFcfuWQN4L5qMxnm2Rr+zzf1FxksyzGoiJv0k2FZ/K8/
    zQBu704Uw0qC1WUVP+hCihCOAHiH6XNmcc/jpi1zpZFBnIg72Dyz47nrLXF3IwkjFIzAto
    YjL4fW9iAb2sW+Vn4xEM8f0jhP7AufVvaz81ReUOMH23fd86Y6b3vy0foQkS+jXxDI7Xny
    xnj8rwQQ/qESJ5ItTQryqChWVlS6qj45d6PwWMc8Nqfhxik/XtigjZ0Xh8wk2D2pyhkRHq
    iaa7VTA7vbSK+AN0OtxxIDzz0O6aYvtMB9kSNLQR8XH4TbtRD8yizHSZz3eA
X-ME-Proxy: <xmx:s18UaptUyk2cm1cS1S8PkaMgt-0ey829YeBygKC3HG5-gC2y9DobOg>
    <xmx:s18UanIvnL4SOXBk1EY3C36P7GanH2j4vG4-ybdXMhlgG0ABKCiTGA>
    <xmx:s18UakqCqU_oct1qD2WFqCZZwTzcuIALl3fEMd3RtFvxNl0BWgg_PQ>
    <xmx:s18Uaj8iJrHBe0GLgbxMB_gpLlKD9k24wOQ2Wgc40b1dzLHj4cAZ7A>
    <xmx:tF8UakHpVxht5wWYv810BB8EPx5PKQBvAYDCYdMW3VylUs3AjsxKlXZW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 10:41:55 -0400 (EDT)
Date: Mon, 25 May 2026 15:41:54 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 01/14] mm: decouple protnone helpers from
 CONFIG_NUMA_BALANCING
Message-ID: <ahRfP026tvXw8gI6@thinkstation>
References: <20260525113737.1942478-2-kas@kernel.org>
 <20260525120640.328441F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525120640.328441F000E9@smtp.kernel.org>
X-Stat-Signature: ufxio794owgca9tuuoxkfb88cm8nufrh
X-Rspamd-Queue-Id: D2A504000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779720118-365464
X-HE-Meta: U2FsdGVkX19UwfJOylBkCWW9wbtRDBQVKM1RZdkZG9X1Ct131XBOQsQs6osxDNTd4XE+pklDB6GZLI6jyyUKJUMbJLgVTAzj/fGY8HDdcspmnOBZY1BVoK5FalhTOJ9td1mlO7gSFNVtAK2PqlNeB+ZajupjXH83K5zkvrHoEIEnPIxJ8OU7ELotnwgkLAiPP37b8OgO44h/J00Q53SJ9oGFLcE4H2HQvVTyBOKOUXKkalN3QYUBgg8d3//BSGOltU4BnM0J4aeEvjRSN7Md9pBVAz00EX+A5cc0Jk1MgOxhxm5Fz0KKSGXoyuAiylI8cmQgkdEDkxj+T4V9k2w/fELwi4BDG1eDCiZwr3szZIdCv9FXAptAuyPN6+CFW4CqNWLhpdse4RFbI4MBbs0FaSrBXOirjjDpHOq4LhWUOReXIAcm8ufn/EJ9cWgCnAuzS40/puBcGhYq+oZfhSeudMn9BtcjM3q7WiRA/kI5+IfUCLfqQjYLRQZJXS0LZ8aNOBcLZM7W+WcllDigIfVlGdmMjwr2KwhSNH9Mh4Agr3BpgoThdGE/1v9+lnWjFZYj6keREF3m+9K+aKutVZ6Ksqjk70veSBhxP1iVtyDTF3hwxnq41zEmUsDfdQTlHSsbaQqRfSUbtMKQ983HFfUUKmKH7DPY/n2BcjDwUVhsgAqgk+dgSdcbqpkaX09vv7XA8lDK3bN8IGTQwyjBrPlQCoH/QgCcmQITOrDOeEsGIbDiIcUug1fqMrh+CfzB6TjFbnznvm8plAi9SVc968ICfFiFu6UUr+9TOMBkahcoBS4HSCT4lHykJBhCnaFXxIMxmh9ltEWNQHErmhxF1mYfVTtQfywca1evP0l8T7wvUeoyxMWZF75nrQ5ZZ3O3UPwW8LhU3nd7SAxqwpquA5je3ETmqLRiyHmyj/+/SEFvv8JT2IBajfd5pOJEyNz6wAFYCiyO+00dEm1isz6SChw
 r68CfsXm
 HAaF4L7dF2mmBcpBiLptllmVOqRZkx1BtK8t1O3nb3mEfqYWf+tmAdfSk8kO1j6aTgnewku3+WGGMxGbUnTi3AB0VBU1Dv/OMf2l3AqKNTlJ2VUg+jw94fefbWzdAtHbfe7pABec9xpDDzBzx1wgfI7m81bTfj+pHnnaWGamACuRXI6sVZFBIAdUqCWMtZNMwAh8G9ZzZ4TkryiOTZ67rAv3OJwVrXyL7v82IQOIk8Wgf7q/uQT8azpdMovfC9qUhze4qp7A1guF2JQnWccklqbHXnQ3ekqnwP/tXRsX6dZocNjQgFEya6ql5cisgcDvI8yQSQzJRMdutp6ahXKlbr9B/3gj6EsXgYB0jxZk7Dfry6Omufll7//UCOg8ZtRjdYKOsxgHJe4oAjz9g+wW4GrshubduUZa+u3UGjxjHcY5DH2N+0F5AO2jzwoGptvJCoZnecUDPFg1R0FJnwJlyepeS/o0vwgEg+SXZyGdMQF8aNHdwmSP6BWf7vqw4QMWMiS8245gFX84bpcWgV7B9Pa8d2VET3WS40wGH+mAyBD3nHO3lrymGBUBD+7I6s9Mkceai2Z1OGSRqm8kEoT1LtyH6JG8SBYR6bvor
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:06:39PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Unconditional selection of ARCH_HAS_PTE_PROTNONE on LoongArch
> causes boot-time warnings/panics in debug_vm_pgtable on 32-bit
> configurations.

Confirmed. Will fix in v5 with:

      -       select ARCH_HAS_PTE_PROTNONE
      +       select ARCH_HAS_PTE_PROTNONE if 64BIT

matching the x86 ("if X86_64") and riscv ("if MMU") patterns.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=1

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

