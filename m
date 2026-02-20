Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F77C53216
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 05:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034676B0088; Fri, 20 Feb 2026 00:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9F36B0089; Fri, 20 Feb 2026 00:47:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05DB6B008A; Fri, 20 Feb 2026 00:47:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC6BC6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 00:47:37 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59EB28CB4C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:47:37 +0000 (UTC)
X-FDA: 84463752954.24.441671C
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA5F01A000B
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:47:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771566456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gTNf8V4OWcG/w7f/O3EbDk5BRpaFz4ZKfygHy4f+kVM=;
	b=5T2+uqiW02W7X5Vs4JSy5qj+puoyCbnYWhF/cM44Sffn8pRiWNAGHhQVkNWRTe52HHMdjs
	/sBW07Zq3RWYAyk4FWVs/qvVEtBsJJJbsCeloJ1CSfdp6i6SnS6afwHjup845BwYahhamO
	LdVBRVpvLf/1MThj1cav5qJQGLBrOF0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771566456; a=rsa-sha256;
	cv=none;
	b=IPQpu7AyJsEZIfJX4JPpB/OfpkZjnZCde/T7GJih5R9be2whOqEAMkrvsp42XOCTTJ3vYb
	NZt+zm/j8PXz02eap3vh526OURzv/Rahgp/NVQnGUh17YOMtNl7BSoCdAM+Ss4BMLMVVvk
	lpnipyQdPdm4FtI0Kng3eGsmhKOXhZ0=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61K5lPdk649018;
	Thu, 19 Feb 2026 23:47:30 -0600
Message-ID: <85ce6a26fbeb79a58b64df682b08e5bbf4c6abd8.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Fri, 20 Feb 2026 16:47:25 +1100
In-Reply-To: <aZbjCFqlqdFwKSHR@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA5F01A000B
X-Stat-Signature: rws6bghy1qcjb1ggoe4tf5wad1x8sqzc
X-HE-Tag: 1771566455-498751
X-HE-Meta: U2FsdGVkX1/I8gRfXMvnwAbz5g6vsc7iK+b2/SGUZNSCLVMUvR0NYZT+BJaxH26gmC061tjimddpk20Dhk2Xy903hdeXSQRYJWcl9OPn5SpzaK03sEQe9thSA3d6RMUOLq6Mhs0qt5GwnkX8k77NUqROFQ4aocq7gARZ6GaUOcgjp7nixu43Aa+J8mvZk1WV0kP9nwikysjF6bbvnCveeCaDFUJdAVvSOEksNvl3AZQFAo8RXkw4zawfSg/MxL4rt1um+l5Sb05w/M6cDmq5LkYjrPUBExDIKEm4YN+IgnLyboloEuyh4YCvt7lLxvL8ZuIr3lVrlo8gJXw1/9Hm2VmhEs+aR6oY2ZEq665VBMcBBr04yzISt/7ZHP5AHhZuxFoc1+9mOx5TFpFGfoTGsYl9PiXxHyFd34DLNoXSlYiQi9IGHIrU6sb+1d7PEMXrIhAP+XRPxgnw9dZcfddUNcso8FY1/+RqOoDGdeYRFIbfsxUTFL4uS4xKfBSuhxRmME/8ilEOHkMtwFN/2DCRbQ7Ufhe3TjwfZD/U64LNDXmPS67PTNd+H39zX9gIznpwSRuhCThujNpbQpXh695VfvB8Gjb+8+jlAMSMfhqyO9hCIO2Wq7lVnafTm0E0k23lwnzC0N0PNzdrdccBUTRYR3LqaFNRgL0xWD17C/p2ksTtpLzvwTRVWaLFA9CHTQS68DmIVaMMTgvKF4TbueXy4xCVbryNC6LIpjGtI9nXownIK4OWi1i1oumF3jvu/LGuW8mkWyic0TEYO/CXDHXcKix7YQ4JjTfl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-19 at 12:16 +0200, Mike Rapoport wrote:
> +	ranges_to_free =3D kzalloc(sizeof(*ranges_to_free) * efi.memmap.nr_map,
> +				 GFP_KERNEL);

Another issue ... you need to alloc n+1 since you need a terminating
NULL entry and there's no guarantee that the memory map will contain
something you can't free :-) Very very hypothetical scenario but...

Cheers,
Ben.

