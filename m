Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5409ACAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915FF8E002E; Mon, 29 Sep 2025 16:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDBB8E0002; Mon, 29 Sep 2025 16:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A798E002E; Mon, 29 Sep 2025 16:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB428E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:32:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3BB711A04B8
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:32:13 +0000 (UTC)
X-FDA: 83943434946.08.DC0F357
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7D88C40004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:32:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pCf0Bpat;
	spf=pass (imf17.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759177931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNApyH0+2Xlf7Nm+Qv33A6yF8KK2Mee3Uh8d1UKlKfQ=;
	b=5gRhzDF04l7CdWt5jZaUN+wI2uEnpYNZeWTde09YGkrwAk5mBH5ev19i+t2bJfEqQnZ0aQ
	npNrdJknP1uPaWWehsp1wgxA1AjjBSJPQS9DtMtWWrmtMeMRgxncDOlUvjS/AqKkmVS4+v
	hvm5sA9lwOyIqIRdIn6wHdcz1zRdc7k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pCf0Bpat;
	spf=pass (imf17.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759177931; a=rsa-sha256;
	cv=none;
	b=mPVgWdcy1Il9WBPM7SzIyufbiuhZvnS/jOtmk2AFkZij0VnrmpjDe5HDFS8f89IIlUl/Bt
	+HfjeT91PAOxFD/fpkwpJbuOY6f0fHV/SDmzYrONQaZKlkjmrXXf3kXmHUbk8pFcLxsegq
	/2WhlR6VnJUP4+tNUC4S/OEMSD7t3Qo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03A53406AF;
	Mon, 29 Sep 2025 20:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F22C4CEF4;
	Mon, 29 Sep 2025 20:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759177929;
	bh=ne+Iy9QthEM/h4gXruzj9mfQSwF9p/v7sj7AC4pgo+4=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=pCf0Bpat2e/6sMP9BFpxqNCX9HDxD7wCA+PJNzyMTERWbxQdoFdEdM2+/EEtYn74X
	 EdNov68tcVMXnqIAXK9doBhbKr5ITjnbwMArPdHPIgGGt2HFtGS7NtfKrTJ8nAUEic
	 FmAE/3WFAzT3yWpnYWPEz4KGEmsONMYO89oMQmepWiXjoAzIDN4ffpy8Qn20yJQP4x
	 xxjZbNA1w3ygRq6hz5zKd2ubTjxrZ4vtVzrZyFGq+6hUzuh3dkNA4zF6PVYDuhYiRB
	 y1FbPSpr3y0oYgZDy6xr32bf26H5leMleyVti8M41q/DNNqktBsI2IihLdrKzc4Ku6
	 KtRQdBZNjYPpA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Sep 2025 22:32:04 +0200
Message-Id: <DD5KJ1WIMGU9.19TA3OW7MMGBY@kernel.org>
Subject: Re: [PATCH] rust: slab: add basic slab module
Cc: "Elijah Wright" <git@elijahs.space>, "Miguel Ojeda" <ojeda@kernel.org>,
 "Alex Gaynor" <alex.gaynor@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Trevor Gross" <tmgross@umich.edu>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Liam R.
 Howlett" <Liam.Howlett@oracle.com>, "Uladzislau Rezki" <urezki@gmail.com>,
 <linux-mm@kvack.org>
To: "Elijah" <me@elijahs.space>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250924193643.4001-1-git@elijahs.space>
 <DD1SGLU4180C.361W5XLH76XNC@kernel.org>
 <DD4IKU7O94WN.2VALE9M80XGQ7@kernel.org>
 <f6b874f7-0031-4a7e-b781-f888249f25af@elijahs.space>
In-Reply-To: <f6b874f7-0031-4a7e-b781-f888249f25af@elijahs.space>
X-Rspamd-Queue-Id: 7D88C40004
X-Rspamd-Server: rspam05
X-Stat-Signature: kg4ts8j74it1p18bsabotq1pbni7pn86
X-Rspam-User: 
X-HE-Tag: 1759177931-834581
X-HE-Meta: U2FsdGVkX19RdpJunZLWkmhbQQGen4qUltMldl/txdVuO5/zBtKd53dwu8JBjYiV3HrJgHz/4o3QIbWqyDMosTlaPASGDXXLcXZLvHURMEuwBgIRm5LeehCCRitIQBV87gsBtYq73S2p08MTy6M+AUetaUpZN+B66D4D9ACJI1AvBBcGdTlsPLJQmsL6b/bQaBUBl+xh0uz7FtUpxRNWWSi+gT3i1l51aYYN+Ys/xjcua+uSHejaei3z4la0NdYepuiBHNiVGyvxLWlUtajNcfo1f2ept1wxAXlbauI1iuQOTfyd7rpE6e6TbaxWhFeeSvHrefQYQilZXSHvpQK05++Zr8RTx9hdOJnJVOmLQQ+IDMqU7sNyrJ8XO+FZAk2KFOFoqxq0wfjfBDArtM3/qINclWnTBHeCLu26vgj3Yd2C9Z84vZgoI7SBKNoUp+VLco2OXWk10Xsc4HEBAbDell8pIdR8w4ES0/2uksemheaEXwVKPikDmUo8t3tbM8hPojY0uPIUf5/jJLXyG2LANiHm6D5YeQelBLuQRnp3GaN4PznpBUv+clB8bx4JzAKAjT63Iv7uuJ+0UDTcVUN0vnBqWXPnXIz/NC1BWExsxI3oOfdQvn3yv9F6AWm5WPk+H2pj3mF8pPtnQkX7wPmUGovAtlkx+wPY2VZhiRuBqlQEXxLqoGkQjuhz6trMiNneA8/YlUWooUYbzvq56xJAE/3UrGPz7Wqw/Py/yyGwQf+7B5nfZIuT/JNdLoV8LRq58jHeJk+Vkh7V2uVfP08236WCjib17vlmZrcOrVFzLGnpoAtQQZkf7zi6eiS7bQ/qgRx1jcrb4M42/4pLJN31vwpdf5RJBbSoF99/Z+V5nGUG0ofxjbcoplPANLgj9n8RgflYSN8d0dRufRIL7bNBylBGp3FG08crP5O/z65/5gL8KGaHUwNShykzjjlt/qhSTjPtP4fUi/wA6IG+7WU
 eomSTn3x
 suoROBvWm1srTQ8Z5XHRIq9iXb/Nvka7EoXlCoTOF4F7OLFpmmjNChNwM4vnMpxphtIX8KLjngnmbUz4f+NAdCNXEgic2CbOtZD+MUb3cqsCAHyToLyyMliGsrvscHsotMCNK7c3A+P1yVX2BW6JMPrm162x6cNalrE1aSK/eZEH8xYAqoNja93BFUWGZ0zZvCrws64YsSw38PCC6i+riKuAFHxQHELEayY1+LG94jZ/+lrK01703JGlpOWFpXjXA55u0yuCUYbLSSvVULsNb3wV0JYep6nBrd6L1tjNgDTWUBDB32XItloRNnmJ69L1W0oYtcDV2gwmPnSElovwOkcgzLI2BI70TlIJL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 29, 2025 at 4:11 PM CEST, Elijah wrote:
> On 9/28/2025 7:47 AM, Danilo Krummrich wrote:
>> On Thu Sep 25, 2025 at 11:54 AM CEST, Danilo Krummrich wrote:
>>>    (3) Implement a macro to generate a custom KmemCache Allocator trait
>>>        implementation for every KmemCache instance with a static lifeti=
me.
>>=20
>> Thinking about it a bit more, I think we should go with option (3) for n=
ow.
>
> do you want me to implement that now? if so I can take a look in a few ho=
urs

I think it is what we settle with, so if you want to work on that, that'd b=
e
great! :)

