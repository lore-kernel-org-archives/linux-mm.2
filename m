Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06601CD6E4C
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FD86B0088; Fri, 29 May 2026 04:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420236B008A; Fri, 29 May 2026 04:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F936B008C; Fri, 29 May 2026 04:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B49C6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:32:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D40AD1C0BC6
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:32:06 +0000 (UTC)
X-FDA: 84819789852.19.0CAE3FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1ACEB18000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:32:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="TV+/R2Zq";
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780043525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HCFl9tIcUOt3miefEeSoEF7h8rFNw+sRT0B6NcU/2J4=;
	b=nIGY3Vp97JCCNiq7hSigF0ep+Z0MLvrVqUuZqRwuH9e0AwvTmch9FUlBsjPP5jsjEem5r9
	eEVgvleJCBpB7Jqln+aYFqbBGnlhDKwiazByEJ4qbc/SFxWz/we99NQpFCL/MxxqvfxSwB
	QADqcjwtEv0xnBpSqpq4eeGylf5FuGI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="TV+/R2Zq";
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780043525; a=rsa-sha256;
	cv=none;
	b=hzwQdqAoMdhpL1j+Cv/hB+spqHhXwLp5uhNOEGJRhGlEzT7pR/OJSZKtexXK06NqaTv6wp
	lZG04jYaZ45E3d71AU6pQGYjt64tPMt8pwS7MtmjNoWdrOMHLQB5PNTEuBJng8CF9RGSfp
	MmLrfji3JeM+23ENe9V44sQ6cc14ju8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40E3C201B;
	Fri, 29 May 2026 01:31:59 -0700 (PDT)
Received: from [10.57.91.162] (unknown [10.57.91.162])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 273AF3F632;
	Fri, 29 May 2026 01:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780043524; bh=6FINnAeejbCpxEsJKKtRLyzzbDAImuU1hMJl2QkGje0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TV+/R2ZqySGE36yEvr5DLTOVlwuwSWVBVD3mZtBpqf8v0rbiwgfcbKu6cuFovDtpi
	 GaHm0tH/kehwWUycIvD+JGIA723f23KKbNPAGoLtZw8LFIA0m7DdkzlVGMwTtlPKMn
	 fsVLYwoh7j6HcLdUiAn+UEYC9Fs7vc4gZXqUTNVU=
Message-ID: <3b2d27ee-28d5-43ef-9d45-038b147d04b1@arm.com>
Date: Fri, 29 May 2026 10:31:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/15] arm64: Unmap linear alias of kernel data/bss
To: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com,
 mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>,
 Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
References: <20260526175846.2694125-17-ardb+git@google.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mszry3rzu9ftxj7j3w6nnaj54ie9uab
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1ACEB18000C
X-HE-Tag: 1780043524-370968
X-HE-Meta: U2FsdGVkX19yJGDbaGfFI2RK5ISALvSZdZ5p24W8po/ODx/HJLLsv08qXVG1TKmRe+lFdly3XVAgHEn2A99vFBYG3FQiZ8PGjAfWYngeFTI3JWuU+cfnu8FweIe0v5UUxXqXn4w8ojrJc24RIiXh18c/oQqBAkd6gYUicw9TKGwK/xnNLpEtvSC0tKy1tHAYIV4w9YhQxLC25w/OB/FSSK+tCEJQh2mGGRnZrhD6qjUjE07Pa8YbLlyeVYdGCC9vh7kJDTA/SSSxI7BDfU5Lccrpc7ZF8z4qy+4uSR0W7p/q8b0MNIjbOY3vR8iMH3cSWwWdbwvs2HDMq/UJe1wqKhbEG+ibX3tf+GTdz5FQaAJ8DY9IDcD3wZrKtUUzdrkmoHiXIPLHY3Mp/64Dz6MFm0aeOjAcZoljpYjAcaV6146g/ua4z+aSDdmBqZB9mwLFNvTHGx5AEimkR/QbTa+EtYIMk6izZ+gK0jFTL78guhNVM8DIACpn2Mi66DYQUTD3eJWi8IqiA9KzugQF77TcqxeJxgQX56NmdXL2hIsjUB8dPctTaMTdZ5RX4GXhl+7Cb67M+kOnKPAkmtHUEPjw51uOgiEyactITIyRpTSpKds7EyaD18ehCnusCcqPrGCjhZFEZoa0EwEYnmVMXpJu3ZrCQ4gosL2HPmqj98FMzm+uo1IShPp037f7nsAZ4cTA3AFC0zt+TYkR36EvOWM/YbncKezl4ubM91ugXgQzaeQrvbTKZlhH7CMXUzBv4ZK6KUBp/sBLb6NghOmwBq0oFPy7G8T2xqJLq+sVw1wSAKOJDsMmXZ2p9NKvOUHUYFRn0/ZReoLx2zgJIpV2LitJvKotq5oGhAsp1I9TB92SrnDkAki7hptMBv7PRPlKApVVdOcpAisI4V2gOkDlGAqAFX0Xr6R10q8PkApCor/aR0NUrzXrgqmRn21aFKtNHX32qCh8w4tyEkqoCHaQto4
 Q1snZPu/
 MeX/IiJ+D/mxJaDq3ULdwlB8hda+qVLrjo926Gr9MkZhn8fvf/MnS5fEgk14qoCWKTixM7UQRTEh6mcLE3LX7/DTfaP0T95YHGFwgWvyY5frTRDZn0kGq3MNALXvcPsdx7LAPffOKZO6U2O1tYxIpZSJBb+7gtL+x6Ziiv3uT8hAtwdu/u5fM8+GQ6F2NeH7+6yZ1CfueRnaprquWREGPjQX4CvBCR58dd13lun/EF8CKfi4uyLk9cyHY63iCp/MQ75ghNNnc6pWIGs1SRSHzrZV+ihCGP2JDVxYQkfa1WBWo2jREQsWi5P68ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/2026 19:58, Ard Biesheuvel wrote:
> Changes since v5:
> - Reorder series in ascending order of impact, so that the first few can
>   be merged earlier if desired. This also makes the patch that remaps
>   the data/bss linear alias as tagged redundant, which is therefore
>   dropped.

Definitely makes the series easier to review as well, it's all looking
pretty good now :)

- Kevin

