Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68954D73EBB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F856B0088; Mon,  2 Feb 2026 02:18:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27286B0089; Mon,  2 Feb 2026 02:18:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26776B008A; Mon,  2 Feb 2026 02:18:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 900D66B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:18:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DB72BC8C0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:18:43 +0000 (UTC)
X-FDA: 84398664126.25.D8C8A5E
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3440420004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:18:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=iFc7uaIW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="n yUyY6Z";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770016721; a=rsa-sha256;
	cv=none;
	b=AvKKIjFA+P6YT9k2q5PrsMYVm4p/6VUqDI9zUAvmvFNWsUyTZ1U/c7Sbhfgc8JVHL6mjbH
	+QSvPz34G0XJWNfpgwKE6QZUeZtdnoGooaw33UDiXf5N3NXiac2k/ptpOA+0+8ot3Z765N
	I2DTfP9yb2wSFCanCIpdaCmsPyQ+r8I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=iFc7uaIW;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="n yUyY6Z";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf13.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770016721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWsy0gJ/yVJSv34AofHi/+W85hyUn1fqDnXP+KPI4Qw=;
	b=E0nmMxx9DZGi5k9HYrKJCFgbi/+68HH7vZRP80A/yHwXWTZtRH3qCfwwJBK/DvbHAyRKg+
	yDAQ3o5kCnWFPozgRy2qiHomn2McS+EcK6z6Ms79SAhn9PGaBiZ/d6dLf6krs1gvgPSXn5
	SWtM0n38do9/xQP31Jw5R+XDWZlEIeE=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id AFA171D00128;
	Mon,  2 Feb 2026 02:18:39 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-04.internal (MEProxy); Mon, 02 Feb 2026 02:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1770016719;
	 x=1770103119; bh=bWsy0gJ/yVJSv34AofHi/+W85hyUn1fqDnXP+KPI4Qw=; b=
	iFc7uaIW+B5Gf/WlCx22+CwbiPmyegRYiOTd0j2iA+4FeDfQMQ1h+oPVCWwmvaZe
	edZ8w6iYGFfAWAIKkT5769Mcj6cCrJAFEhIVVSSMYxjhZGRVLTJIzXfsp6Y9V6/N
	ftkta/zG2fo0Pu0fQ+g+V61XQgL/mNRwPG7AK6LQQaltL8+muWncoQ69w3QtCJ77
	iZ10NXSEEtlnnqttmjapzFOXVLOHRet0MJo39Pl/YFIBa5ExsEpnPrSDomxkUIc2
	GLgeKGDqaBukJXcLzoYZdK2rnN6MsYeeULPgmODeSVRFmuxSqC8ZTmc5iq0BjXuv
	RYR7xz1zvUyTCmGQxhaQ2A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1770016719; x=
	1770103119; bh=bWsy0gJ/yVJSv34AofHi/+W85hyUn1fqDnXP+KPI4Qw=; b=n
	yUyY6ZDSljIKTnmw1AU7GZoQKxryxhRIYeKut79PY6EpIo4dDmcCJTDmL340FEZM
	arnUpQYsf8NpWiQdaoK/znZjuzEbzTrtoTM57NOcsefIe6jLTa79aAwcH+Q26dlA
	kfrm4l24S1y+cOEOoH0md3ANgPi3jEkE5dFUFMo1MkOQVFcLoGj+6GsxJF6sUTq9
	goJo4HdQhI+/JOxlKoCTfAdWi0LkcOhpT0GzCfevMLZm6YR64q9tlNyYQ8MZFU9H
	KsUfWwvv/hJzF5Luln98WEXrNb9R61/ArKAuWOWurR6v5QYx82r94SuL3nDvf1ts
	Cki+HJgGyLXC/AJxulmRg==
X-ME-Sender: <xms:z0-AaaHuchIU3x5nSYIc-VVd6NdUr6Sbg1mqzflOOiG45yc58l224A>
    <xme:z0-AaWIUT5PETf_ixhI7pLkCh_EMtEuyrj5_BIowj94zNOGsEMpG5t2SrC2TJTYpY
    BttaUK1ejqs6QdqVN3Iirlei4OKwO_YLBkSxHmvfBbkgKp0HFmJxT6->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeejtddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhgu
    uceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvg
    hrnhepfeekleevtdfgueeggfdvveevueekveffgfekkefhudektdekjefhveevffffffei
    necuffhomhgrihhnpehprhhotgdrshgsnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvgdpnhgspghrtghpthht
    ohepudegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegtrghtrghlihhnrdhmrg
    hrihhnrghssegrrhhmrdgtohhmpdhrtghpthhtohepuggvvhdrjhgrihhnsegrrhhmrdgt
    ohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpth
    htoheptghlsehgvghnthifohdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepfihilhhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkh
    gvrhhnvghlsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:z0-AaX2CsiNZEGqiJkZnfP90VJxgixWG276SLu_N5kWWJRCsWK7CyQ>
    <xmx:z0-AaQfyrsxpWwmmlbfaYy5V_XbNWjZMWV2EB9PbxyjJoaKZvcMACw>
    <xmx:z0-AaeD2KTFzSggUELf464ZDsBWaAFBTHhNkzqYZKmlA4aFN9V-9Rg>
    <xmx:z0-AaX-BkpRqiZ7558uXDlWhF5bR10gTJ8mNz31aGjZbNtYJlmIaMQ>
    <xmx:z0-AaQ209crPTfm-OURqy6SS8zvLO4mc_NKjMYyRXBStbay593PPsFAC>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E923270006A; Mon,  2 Feb 2026 02:18:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ASnEhGskTYsw
Date: Mon, 02 Feb 2026 08:18:17 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Yang Shi" <yang@os.amperecomputing.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@redhat.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Ard Biesheuvel" <ardb@kernel.org>, "Dev Jain" <dev.jain@arm.com>,
 scott@os.amperecomputing.com, "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Message-Id: <fd18c462-60ce-4dc1-9877-2a1d162d5879@app.fastmail.com>
In-Reply-To: <20250917190323.3828347-5-yang@os.amperecomputing.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-5-yang@os.amperecomputing.com>
Subject: Re: [PATCH v8 4/5] arm64: mm: split linear mapping if BBML2 unsupported on
 secondary CPUs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3440420004
X-Stat-Signature: brqs8to7zs1thdpces38rz5xjbszuc5b
X-HE-Tag: 1770016721-456031
X-HE-Meta: U2FsdGVkX1+ernBjLFMn9DnMmAomDszyd5WsTEwak2Rux74G4ohMxoik/e3avDITtyqU+aiM+mih5zjENCYc47PVbgIoaLzWVjHg/nadjjH1bVZQGEksa6aAqTEy2p/G5moyuBivpYhuS6nCuEiKAIzEJfVrLrKQgHo4446UU7LLrHUiRMhRCA5qLSYcmqzKFvedKtlB3Do9PwqPC5eytVPc4d5jsg0a5g4JixUllmSEHJorTKZw1p99JY0a1Kkenml6OQ9TJIpntVuAmVmXNgAQdvfQRK9hpRIG72HefnoVFTcbVcx2/cH3llAffig9bixAF/8b4S8lb+WiOc/bBHBMVLtqn8FsUeBVHGk/UcwUiJbD1mtx3YZ6aKUqfxSDomWI1vCEp+AAYQRVEl0b5W97xbRzcsCtBtFnqZtDls6sYVTiRnIKgodzle8+hc7gWY1M9H1B0UJiaJ0CtHC01ncZDqdwdez+b6N8V05BVd6B/Jv0Pw+OSLAqDopJefvW4EMHQU15mIZjjbhhvewBWrJhF6966lCM0wXLnTvFA6tsUikFg/6o26J7UWoS/h/ETrViKFdmrSRYXa4ql6lhOYRs0JgIsu3MMfKMDJE23oM1cKKlhfE4UobwxMr97A3z5RRWQyPnPkNeXcZIXpMe/uGfxpYjMMqYSW88agEkbMp4mUHuCKSzjmZauxF3ozHENKsWwYQhG8CL3inasXfz1g5m8iXnfS2gbnF+zH8SYJbOp1wk01gWyxOluci6UnBX1zaR/rw5sWvPzkFF5fDuv05dNEFDXZsXAO1aJmU5RZv5+YTez8BJrHvEUBuV39SUX/aWo5TW7LjzuskS/ZSGjLRp9O+Xr7YKhMHgUxVJLbtseFnZC6Zo3cnzT0JQr5K6fbqg2MRKC/2TyKtgxLKIgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025, at 21:02, Yang Shi wrote:

> +	.pushsection ".idmap.text", "a"
> +SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
> +	/* Must be same registers as in idmap_kpti_install_ng_mappings */
> +	swapper_ttb	.req	x3
> +	flag_ptr	.req	x4
> +
> +	mrs     swapper_ttb, ttbr1_el1
> +	adr_l   flag_ptr, idmap_kpti_bbml2_flag
> +	__idmap_cpu_set_reserved_ttbr1 x16, x17

I'm getting build failures here, using CONFIG_CFI using clang-21:

ld.lld-21: error: undefined symbol: __kcfi_typeid_wait_linear_map_split_to_ptes
>>> referenced by arch/arm64/mm/proc.o:(.idmap.text+0x298) in archive vmlinux.a

I can get it to build by using plain SYM_FUNC_START() instead of
SYM_TYPED_FUNC_START(), but I have no idea if that makes any sense:

--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -439,7 +439,7 @@ SYM_FUNC_END(idmap_kpti_install_ng_mappings)
 #endif
 
        .pushsection ".idmap.text", "a"
-SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
+SYM_FUNC_START(wait_linear_map_split_to_ptes)
        /* Must be same registers as in idmap_kpti_install_ng_mappings */
        swapper_ttb     .req    x3
        flag_ptr        .req    x4

      Arnd

