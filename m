Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C31C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F016B007B; Fri,  7 Aug 2026 02:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1FB6B0088; Fri,  7 Aug 2026 02:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8956B008A; Fri,  7 Aug 2026 02:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE826B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:41:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D7E4A0332
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:41:29 +0000 (UTC)
X-FDA: 85073527098.07.67FB13A
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61E94100002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:41:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786084887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eWqIESzvbZoD8Xsuu0UHuhT51rqMSbB2BWfDhXo4pFk=;
	b=GaemmD6fecfRV4MtPkySxRFbP4+fpsmV1yi1NFIqxpNYtbMdYggZTnyDwYDrg5X6iJ5xxa
	tjBNLfXD6/5JfToQhnXAJlQpkKuusjIEL8vdZFFcy6g6TjbhUVEGg47O2VyTMtTaDPfaX+
	GOf/KLnbndMkbKOvIXBRFzvbTLcOh/w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786084887;
	b=UaOEX4QqZw7PBcQk2Hp19J02hkuhD3E0udK3sjk/32q5tH3NUEIJJYAxqEDpd0UTJO+ufx
	bjkUNCcXo7KtBDcLDTl2JjhukSDuas5QD39L3VxPsRhSx+F0Ko22/zRYxrBqPE87LQ1UqH
	rvLyPUO/diobhzWEUJLKFO0tLwWV5nU=
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.53 with ESMTP; 7 Aug 2026 15:41:22 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.151 with ESMTP; 7 Aug 2026 15:41:22 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 7 Aug 2026 15:41:22 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, her0gyugyu@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
X-Stat-Signature: eaaw6xzje8nigcfg7n87dwx4xtfyg54k
X-Rspamd-Queue-Id: 61E94100002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786084886-315834
X-HE-Meta: U2FsdGVkX1+8Y1jLEHACusQgoKHfZtbOhuZQQ3pN+RfplFDpgJ2h329jZ9LnAmxGW1aVctFZjwxonBAcnbjT3suo3VEljNuEYTgRUNUo8wvPZC7xa9V5wc1YiS5iwNceEzAglwIEERS4ANF/KIC949rxM8MlyrTz9pU7OzqIVm6rZ31Ocjzp0zBpkTcDEl9rQhvCJ2mMN/lXXGAPhtCweF5nHwk3MqLI31nixyTdoxG7fep34dFNQzGx7AN/81zeZT94DdSrMoZF578IwhkHcFVT+Gg/8KGHycNTV1IZwxG/tBuImyFsEXRME6Svb0ODCQv1XiTbWFx7q+QZ79XKJtn48QmY13jDFETwFp9mvgW5HhyvwdKRPV1umjNBzyGffphPkgtZoHOlpblbqwMbeNFVrQtvj4IfkS4YClgnO4q5liGX8+yhqsEoRpA+pGtLAiI/7uT4o8IF1FxhgjauMI7hmeJO/qBz4+OKpQUnXoAcSsZh7xOprGzS2zFm19GDhxlS/wXmlY2Ph2H4iS/muvNxhAEVXsSbpymyiRFF1WJajtB08EoXnzYKyl5P4W2hPh+BkEWfcrWtXK/2eYXc/5W+sGsnAwBnmt2+6j7+O275yJbMSbrcpjbLPsUIFzBwSoR0MPoHkAzGg5wsg4uuHSS8AKVJWCcIbED6l0EosII/0I1eUp21FyDyMrhegVX1hBIw8mLUmVMqvSdX8R6tjYQjSUI2E0Nzo6YdwDrrySBViDsbeh0RXvFsRErt3fZquTVvNmObhDwa4g14CQBcfUP541n/bBuLrPHNJ04mXm+QfxmvAlnZMzG2BrV8/7b1OxeWBgQZIm1StWEaMSlEGMt5azwqhLOI7NgevVGqG6TbeDuTzYTa/lcQK1Wbjg6vDYiC3kVcizKvoTVM/wnzrJL2Ze01a4Fxul8GVasQb/vm8ZOU5zfPn9zyu997f20U0yZFvP0O28cqiz6QaYE
 hdzP89XW
 f/pDVj30ET7yUH23RGsZLS4tTPoKZCOuDq4nt9f6IAF/w2KF2AoDLcsXXwluXF4NPuQmNoLmn6/SWUlPSsR5aO3bvGTrNcyCGfM5KZ/ZH2Xs1j3LhatrI6ZtEsmVB99ArBWBIt+GbmiJ61vGn/S2mQocvmV1wMqadHh9kSvGL2dbg6GPAkSR9e6Lz6/Gz7U+IdnPICDZ+KsEY+VU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:06:55PM -0700, Andrew Morton wrote:
> On Fri,  7 Aug 2026 04:32:26 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > find_next_to_unuse() walks a swap device one offset at a time.  Slot
> > state now lives in a per cluster swap table, so patch 2 dismisses an
> > empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> > reads.
> 
> Thanks.
> 
> Can you help us understand how significant this change is for users? 
> If "not very" then I'd prefer to defer consideraton of the series until
> after 7.3-rc1.

Hello Andrew

"Not very" in the common case, though there is a case where the win is clear.
No bug and no user report.

For now I would rather defer to after 7.3-rc1.

And for your reference, here is the details.

Every swapoff does a little less work now, because the scan steps over an
unused area one cluster at a time.
But IMHO most of the swapoff time goes to unuse_mm() and to reading the pages back in.

The gain shows on a large swap device that is almost empty, when the last
pages still in use are near the end of it.  The scan has to walk up to
them, and today it looks at every slot on the way.  Now the empty clusters
in between are skipped in one step.

I have no measured times yet, since that case has to be set up on purpose.
What I did is the arithmetic for the case that skips best,
For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
and everything free but the far end:

  - today:          256M table reads
  - with the skip:  512K counter reads

That should be around half a second of scan saved.

What I have checked is that empty clusters are skipped as intended, so the
scan does less work.  That work is a small part of swapoff, so depending on
the situation it may be too small to see in clock time.

Thanks,
Youngjun

