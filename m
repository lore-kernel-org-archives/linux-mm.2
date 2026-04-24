Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00512FED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5424A6B00B3; Fri, 24 Apr 2026 15:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F27A6B00B4; Fri, 24 Apr 2026 15:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1CB6B00B5; Fri, 24 Apr 2026 15:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28EE76B00B3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9A651202A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:39 +0000 (UTC)
X-FDA: 84694408638.01.E6B8E4D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54611C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DFdBkeQ9;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tizH1hZ4/m/CMLzUr8DqgQxd7xmedgpSeepdPBUoxck=;
	b=S6s4mYdMS09Qa7NG15+oZQlhvi29fI6/ctTCDGPVxFD/Fajdz12Cx+MKH7+JAJ1jcPI2CR
	rRtx7VBVdJXDD/dqirhXUyyOJPyfC1ADvSbYQQh9Uaj+uQfOgfPtniJiuHkXd6vIr32HEc
	2xF4Y3SNyakik+nVK2noPK42N2YVYQY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DFdBkeQ9;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058258; a=rsa-sha256;
	cv=none;
	b=o+wc8Hzfjlwcr0TB5DDReMJGu/eh9l+Wkux05tCgSBeKGavWoM5aHQajOj2lD+dv4WiLYS
	XlnU/VZwLN0lprEH8AYDhGi+2yJbgfBlFNuew7Gg8coorWDSZ/hATacIxiKQSQzSdEZzH7
	H2Jqq6TK/C+C8TmXEAvmtgHX2nMObYA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tizH1hZ4/m/CMLzUr8DqgQxd7xmedgpSeepdPBUoxck=; b=DFdBkeQ9jOocDotu/u2n/2c/ms
	2ru9Uf9a6khtsE+zJM78ZowEZO5o+zzkDRHbNcpnTYn2wd5waP6Lu4UE1d9rNQkBdDwV0uThNGnUe
	+vHJdbBlksVmWeO/LKyFSTX1ab31l0ZPWXB+8FA1alrIM4lBXoPqM0UU+PcjUTy7K40mpLtsjqD3d
	q8DSWDfWjkPMoR9dXrzuYj8S4Rj1X8b1z0QYD2Bev56gf862+xiF1ul3+Nrr5R2+57oMmknjNE4oL
	ciYKrCOR2Zg53mbfC8ZkmNNdr82p9RQMCEHnnfYuv64dZO8e1sCWnREbdJXbbjkeTafU88n5huAYw
	ysHnhWPg==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGM1R-0000000FNYF-15Gw;
	Fri, 24 Apr 2026 19:17:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AA943303078; Fri, 24 Apr 2026 21:17:03 +0200 (CEST)
Date: Fri, 24 Apr 2026 21:17:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
	jannh@google.com, jgross@suse.com, seanjc@google.com,
	pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com,
	roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Message-ID: <20260424191703.GB3783056@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54611C0002
X-Rspam-User: 
X-Stat-Signature: g7bgiewtdygqwcthujffm94g45zc7eor
X-HE-Tag: 1777058257-398955
X-HE-Meta: U2FsdGVkX1/zWOZIf4n4uDU4jeHjwCSLruvrgJmwLhwj5gk4TMUJqLXWvRS6YZls2A2nY9TPSErqc2+lrBhCFEZcfqX0sch8MOPt6mtvu5l42wTBMSvF8+MLakolyIYvfspSQr+GwoOuAjqvNX4BWQWvcxYgO4L0jrJIw1d75Yh6HE4cC/NI6uBxJe3NsCmNchR5yAYduiVJf+OftReDh8dZDGvngIp+4krJA+9eLXH7lwBe/+6ilmf0BZx1kgCd2xQOLQvTOj/wB//EHTEdzZ26Ta61KhcX8kZXMZXqMpV3UKR7tnnAh20Y+jeMY0cpadpy0Z7Bs8etGKDBnyizuxUDwPu4vBi82b2QrNtSaVwVv7uOJtkGhMrDL2xKoA8XFz+zhkB1sIU9V4INU0n/CWaIKKI9y0UAQRKUJVxJJo8c/mt83eqP0T/u2XlCZRhAJm32IsnWtq/bIKnYG81Rr2VDEPTl72W1WL3tgITxMm3JDzZZVJSFNQTazggeUFbIS7G6B2ipwi8yuyUq8P7nFKWMnOIawGYizSuWcitQwBNfu2wG/wDSPN9bl0qShlvRAxin/jOYxP2tQM+BSMmUWresNj7bUdD1ORY2lM2Lsg7mI+vyIH4MN+Ci0QYdHAJZCTZxhb1Uzyd6hrsOXsIOKWBQAOPEF5HyTejtOQ1Z+tczWga2xUGy+j8ddIaC8ld5RfIMaNasnU5UyGvEpWSQoDG5T2zcKhS7mBUTl1BoxuNmrG+JS6kbioJiOAcfWZJGttTenZ/c5P6j55GfmlRZjyzcYQhr7XqyAQhY5rn/NJI7Ib3XRg5C3DyQ+h7YHvPx3QvOd+M8TS7Zq+ReFzobTjZGaXZmTyCW74ZCUTYL4V3IA5RuwTY2MTkmooQdXoFf3mXf7lT7L7BFrMIn9anwzDgIOvEMUFamH7k1yEo7Nk6Gafhal2KWbAeLUcb4eRrGE5eicQ2G1Mbs6sQDVLH
 ajOey+TC
 kKLA0weEKP1TVRtEkY0TuV1tIrMGMEQMmNibSHWz4ADHMSUuI+GwOeVWGq5M7NEk2tL8pcmdDCkQrEbQ/Bu2S9aOydZP2TgSHRg2k82/V+wwNKTPTfcZpUhF3qlbL0gQ/WCHqMeblTAatTjH204I3+N1tCRDw9Jczp08GjlxjX9uWhWIf+wiVSEgTBbEdGwpwrE0reFloChZ3Tq1LYWXJ7+SMfHpSTE2DX8jMptOuezmfnzg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:09:21PM +0200, David Hildenbrand (Arm) wrote:

> Forcing contributors to reply to everything. I don't like that, in particular
> not as long as there is no way for contributors to run it early in private.
> 
> In most cases, contributors just do the reasonable thing: incorporate the
> feedback in a new version.

Yes, so I understand that you can run it locally, but then you get to
pay for the tokens (and sashiko burns tokens like dry grass). I also
understand why Google/LF doesn't open this up, its a money pit no doubt.

OTOH, I see this causing more reposts of series than we would have had
previously -- and we all love more versions of series.

I'm not sure I see a solution, other than to read less email -- its not
like I can even begin to read all email I get anyway.

