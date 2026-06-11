Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EBFCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C293F6B0005; Thu, 11 Jun 2026 09:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00C36B0088; Thu, 11 Jun 2026 09:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DBC6B008C; Thu, 11 Jun 2026 09:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A53426B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:36:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 578B41655AD
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:36:32 +0000 (UTC)
X-FDA: 84867731424.17.B0A0694
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf29.hostedemail.com (Postfix) with ESMTP id C6BFC120007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:36:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tgx5l7fE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuTYoMzmADbLZx5mBuWf/jeTSzrUAeENzv6Lo4hWe+o=;
	b=c5k4+XNojUgscYSTUN8VlfCE8Ugsk+tMWgpZ8dHzxVAFO2QRWWhSsSuDA5VWmcoejddDqf
	DR4egtUpXbdE6uuDLao/41pGA7lQCRtj2+QbXa4kzdV4hx7TQ1r0bUUKkjfLMfezEUbSbB
	dM8h2IEmiINyoeYV1P4VRXacTmVueV4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tgx5l7fE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184990;
	b=tuKpwOgLXeZ2wZM3xn4uGgo+tG/UB7/wUZu8hVDTEQnaBubFhivxiowbUs5HiADmSieTqw
	2QhqIhy9KtwMYzUXDn4xZBVHP888iF2qxe7Zd3xYTn4ZKfbEblbuSH+F5JBo57q/pR3K2H
	0fRXZtt42Lrq21QqGW5YnOk0p+lTSEE=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781184976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuTYoMzmADbLZx5mBuWf/jeTSzrUAeENzv6Lo4hWe+o=;
	b=tgx5l7fEPJqyKE3EtrMYdNW6Sxds47dKnfzuGanOOuaqz+09uI8JEBtA4tqIpP4uCgwPLq
	7UDlQm+/7kJqyHYp327Oly+uc3y7A61cb5UVnK8c+xrAVpSRXfNCpi3jez/PyI9YufDup1
	hGu21L2FRpVnZ8eH8wkwbY3pXq9n9/0=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 11 Jun 2026 13:36:12 +0000
Message-Id: <DJ69DK9H09I6.O3GUDBXQS1QF@linux.dev>
Cc: <linux-mm@kvack.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "David
 Hildenbrand" <david@kernel.org>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, "Ard Biesheuvel" <ardb@kernel.org>, "Christoph Lameter"
 <cl@gentwo.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Brendan
 Jackman" <jackmanb@google.com>, <owner-linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/6] arm64: mm: explicitly declare module and ftrace
 execmem regions
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-2-abarnas@google.com>
In-Reply-To: <20260611130144.1385343-2-abarnas@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6BFC120007
X-Stat-Signature: 94zsptspj615uwr3y1o4d3gfjhqnpgof
X-HE-Tag: 1781184988-698122
X-HE-Meta: U2FsdGVkX1/jV27alzsB73ur13V2X5RrvksdI8n6+w71P/nJrtJUqej3jIDatE3LkilQxBUHX387Gbm7zg5+7wKCKwgQMdJ2jUlqkygit+lVXAYTUs4McY3XK/Dm95nO1c0JF/T5pog63XCuzwrPFVnNG9TzDsaFPkdK3ub+4npUVI/go+VY+f4ud1/PWS7gLLWhsIYAFE/H4GFGDGyZ3fkZIiOaeABl6ciVdBe/653mFYOc/Ydu2Zo8fNKaFMiwFOLpHItQRP0VwNtWZRR/9az5rmXUktYxGVcatCALlu2EijE9fDU4S+9hf7XexV8O4EPygbopdYNooqtHUSGL1lqXs6lO8CXuNqT2zo2WV8vAM+mUSnzLVR+/faBFr3kophq5YnhF5S17KtD8g3PNs1CP5ZCCtkihzG2hyT6modhZ0Glp1m6BFd56CGtACgr4ltejmvlf8GbgGhFVB+k8oc7RquQ2KB+I7uO71K1c0FY+eAEspZdszeMWL5jseT3Gwr75OMna5HkRfo+bQqBmy+b0C9KU3FN9+n0vV0rPbYKyTj7RVpgCDRslDax3/gNv/UNAbG9mqLrBbhPe5IrzWyIrC1vIqtSupVZuPekE65er9tSotkOVJR+89vk7bBcQHtEDcLexSKLDYAf0FUbVFl3p28qkva0kIUM9o2ziq465b+r8k4Ffzh7XJ2kRGY/jlrPtPtMYhLHfX/vNRq4I5MSTRaG5yJBm+PxtXZdvSQ+IeJq6MgdFcIy/c8nV19brAbLQdlkrWsHyqFomlWLLDEdpaM5lHy7WA6F87M9hL6192Wki+e2W+e6uXTpyXFgRfqQx4rPVTNCMqMkFqQH1Djw+En+MnWU1uqHT/US6EeAYBd1w4x3uStlPVHWrltz5nclTjMjgGLjYOhLKtp0joL4JuIUOtH5nRZVTQxaZHKvoPiCj5kPVm26f3XlG2xuJ98VFi6FrHVsOpUlbGFG
 Sy8NbpQR
 AxxuFTbfDnJN9R0ChdOEsZi4TGkCmtSSEaTtrI/k75V3jmwVP3ictVbmUhDtHGVwxZvxkpPonyDY3zx12F7iVHTFgyMye7GvVhsJmv6LNi/xPm2zaFlh2NHwA/I/SNnfaMrJ+xoPtx36/XdtRTMqj9b0K2caqSInP5B2+m3R43uozIH7L6FFpA7nFnfIiQpfO6srMbD7gnIK+vYL5CvDL0qyTMucuTwH23pBYF4NbMe/aRkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 11, 2026 at 1:01 PM UTC, =3D?UTF-8?q?Adrian=3D20Barna=3DC5=3D9B?=
=3D wrote:
> Replace the reliance on the EXECMEM_DEFAULT fallback by explicitly defini=
ng
> the execution memory (execmem) regions for MODULE_TEXT, MODULE_DATA, and
> FTRACE in execmem_arch_setup().

Please can you explain in the commit message _why_ you do this. This way
reviewers don't have to make a mental note and come back later after
reading the rest of the patchset. And once it's commited, it will save
readers from having to chase down the contextual commits to figure out
what's going on.

