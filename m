Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1389E9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6786B0005; Thu, 19 Feb 2026 12:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029AA6B0089; Thu, 19 Feb 2026 12:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E176B008A; Thu, 19 Feb 2026 12:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D30D06B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:01:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7684359C82
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:01:34 +0000 (UTC)
X-FDA: 84461822508.13.9A970BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C33A3C0017
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:01:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vLOSLnBa;
	spf=pass (imf28.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rhE3G14llUlqGD2njmVg9BsIGRzs+4Xbb6Uz9oiHg0=;
	b=X88hg1FS+M0GogW4WGNNAKj3wfpbMJr+6+v2Shxw8/zr1ls12gS88pacu00H3DVpc4Rv8j
	eYAq5wV0C2dPcEDnebmpfz1p0vGiReWy2S3gRZppnQKdAVOLneNC90ZejpdyMNzHcBfrEx
	Lby/Yj2cWolBPrjN9/8lDLjnnFj/6Hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771520492; a=rsa-sha256;
	cv=none;
	b=2soFDYI8DeKAgjppPME8ub4AU2fIraGXDWiXdzs6zl9vRBMYhSX5DMCTfNubX7jlVW1WTk
	RPrKejiMithbP38bX0M8l2dKToeHRhIrH/LbIawm0oyp7WkZVSfTMzRvpiRd/8f/AOn3IX
	h4glXQ6jzWu1c6eMmQ+tS3/AFmkmyoA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vLOSLnBa;
	spf=pass (imf28.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1055F60054;
	Thu, 19 Feb 2026 17:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2761C4CEF7;
	Thu, 19 Feb 2026 17:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771520491;
	bh=1rhE3G14llUlqGD2njmVg9BsIGRzs+4Xbb6Uz9oiHg0=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=vLOSLnBaAI4fSY8BYAHwluYNtuFaKwe+d4Gz4lPJfoOucUQFWtlm2I/K4JA17A7li
	 Hy/7mYE5PL7j1keNG05JfKNESyw06jo/HpTcS6OppTLtgMx9gnm5ZDPld34hwnfqgk
	 Ix3NnCl/dVDXqlV1W1aHCZ8PF23n/MXkoqLVLVFtq7+139rlF3uKoxwn/nHANZc6VL
	 EwnbOTgkOIJVM15V2ggAXfNJagA2PAajORX68aQaHINDiIgFMKFtxuCs6YR9zXZRpd
	 +xjpcd7RZhX0hh54vmaJnHnn2kFATWu8caAaKHR+QgceGPVrfAolUZ3FGdinh7G6nu
	 41yrGX0BAj4og==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 19 Feb 2026 18:01:29 +0100
Message-Id: <DGJ3LPUDBDTK.1TK1DXXFNXYPN@kernel.org>
Subject: Re: [RFC] mm/vmalloc: vrealloc() shrink TODO - seeking direction
 before implementing
Cc: "Shivam Kalra" <shivamkalra98@zohomail.in>, <linux-mm@kvack.org>,
 <akpm@linux-foundation.org>, <aliceryhl@google.com>
To: "Uladzislau Rezki" <urezki@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <29e454bc-5a46-43b2-80b0-4d8d93e3feae@zohomail.in>
 <aZdBDOPUccXa85O2@pc636>
In-Reply-To: <aZdBDOPUccXa85O2@pc636>
X-Rspamd-Server: rspam09
X-Stat-Signature: jhieh41shuuup1o51uj714aum3kcmfye
X-Rspamd-Queue-Id: C33A3C0017
X-Rspam-User: 
X-HE-Tag: 1771520492-274979
X-HE-Meta: U2FsdGVkX1/6jWsCgnk5wOOv03D29CPzk8SJTmKxwsCnGbB4jAaSc9f4vT0al5L0W7NXejIzzmfBQdcDtq6A5Eo7/+uFDD0FL7lHYyxDCvBGiNABl6as2ZeeIiODW5ZrJmefspsy10LDYdKSZpBzqSoKobEWz7K7h1632IkmZTPBJHzsLaAXY2mVnvdplI3+jEW5L0uT/Qf7cVljI3sObkToTSFNrI8TA13oEzJXE/vLbuUyzsVoqb+4meq7/S+ep2oXO+Y7aIPWtm7bIR0TBDQ+Itgs9pYVpobH4P2mrdNbZE4yCKOOqxBcYesTrpcpgtNFhPxp2zvDLz5Kzf5aHximHFlwszk5ZMINSdWxovbhoGV9NHy9PozaxwM4+gYnOF2JEX/FjPjkeS8X+w/bLITqTgYHOdooqMmMniAfCbbr9MxVCuSexz/hbTMBfNI4kK7VGBJL2Hs7pKlM/wjLTUJCX528KGtJWLmfOzR6lDG4C2GzvGmqfmbjNo9lqsL/bENhlQMXu/bAUR4m1NKYN2I1kUP8FE6YwvCOfxpFZzr7v13/5jbB7Hh8ZJ/0DOH/oYL6l0QpTd+yFEJNdb04KSxtpw9FT1Y8pfj2Ncxglc8zzFOzjvgII7AuFLqspqe/6bCkOiOtP4BPKa4kWcJhzwAT9bZk/fk7b8uLX2g83Px3Hst6cWwR1ENWJWCXwuZls/bdAvMEnJot7wgB8E7ZyEAszpXChHjA/GZow4t1d3ifnNW3dH1avr7x8vsoutgYQDLG3y1BG+mWm/JsgZenqZO2q8GemG7Nci5K36M/fZsn+O0Sx0KLW6gwEXIifbEEAg7DRca1tEq7BZ0Xgf5oybgeb/8hsgacUU6srzUUPlmeFIc6lKa14WJJNGzRmToJOrajIfE/ykar68YgQfFwrOec59Bh6k+XXBYEi64ZFJ4cvwnazdW7JfzwUHj7ltahrAG8BD61782i9dkBBDT
 3NyOQwV4
 URGXRC0APHKia+RvoNXLhyBumB1cpoMlCpx8Puu55yZrhjl+TAMawfnaUn29f3/N9ensQ2y5Gne717VMO16WVbJIUfj2jsWPVqqiid7IOncpieIxajlI7hvINV7v682pcaQJgEBw8yUgm+hVT4iFP/QAwaVF/wbNUNCa8lV1LqOp7fAjaQZmALNEQtUrXgjqHHX1xXGShVVCTda0ukuY9UzB49kLAh7/Ca1+mrHzrtaZyWFUVB0lbegv/QRzEu+jtScokJl4wu9kE7MBpAucIDsZrvCDQ/NYhz1w3/aQh/ivguKMYC/v137Fbnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000323, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Cc: Alice)

On Thu Feb 19, 2026 at 5:57 PM CET, Uladzislau Rezki wrote:
> I think we have 0 users of vrealloc(). It was added because of Rust folk
> wanted this.

We just gained a user with the Rust binder driver.

