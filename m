Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BFDCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6299A6B0096; Fri, 22 May 2026 09:24:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8656B0098; Fri, 22 May 2026 09:24:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE656B0099; Fri, 22 May 2026 09:24:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD016B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:24:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D40A11A07FE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:15 +0000 (UTC)
X-FDA: 84795124470.26.E0E9ABB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BC0C10000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHtcqGUb;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779456254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46NyHzj3stcXZnP51xXm8AEPZCDBIfj/VG/WitvWNgs=;
	b=5uO+1MmW5OSaotsTJEoIseCCGjhIhjXU9bkHhssmeSoly3+vhdguO6cesiTo4HHOzON3Ox
	UXNAmAebpNEyw703FEFX6BrbWMNBYPcTBh2lN2bo6Hyfr0ckVj7DNI0hdETQ9ESHC5lJxo
	OecAvZiOJt1z1pn9UvqAOoL8nlQvDLU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GHtcqGUb;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779456254; a=rsa-sha256;
	cv=none;
	b=jBIkM/51CNr1olj44go8amQCxgswljy4zYEwWHVza0nUMI0kYnYCbuDhJCNqydx3IBnGoc
	cl0wakC/2w6LII1tCinmrreTEO4lD73p1+9rhpV3CzBmEYS1abBTgeewx9xJ+GmRiqFF8/
	tId5tTuMp7FwJGTyTVAX0N1woa8xjDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37C194175E;
	Fri, 22 May 2026 13:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D61F00A3D;
	Fri, 22 May 2026 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779456253;
	bh=46NyHzj3stcXZnP51xXm8AEPZCDBIfj/VG/WitvWNgs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GHtcqGUbEssMPpnShLAlpNSehIRjZL9H0xancMaKqYitLz0mUR6TLACisQckAnGtB
	 FsaYcp6cb3SPgHgF9oGJLJLhheIiPuqjv+214shLErZoK35uTMDqXuBOKZUAnDndC3
	 L/LnbSFR/fESiuCrG8h8oRadwJULpu3N5LQigmPbSTKg/HFUIMW5p0mb5ZhgT63MTy
	 nJU7UlxQuAyfgg5EdCnez/t9viHx5xY5ulScuwBG/4Z+cktsTwxbk5YgnoT3ucUJdt
	 xGhmAc4xsPhmrqu5lC6IZwwY6YyJ+Q+duWMsbNOChBmIDMMMbV/xvscPya0kIoyyuL
	 Wa7fPDhHCFUdQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Muchun Song <muchun.song@linux.dev>,
  Oscar Salvador <osalvador@suse.de>,  David Hildenbrand
 <david@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Jason Miu
 <jasonmiu@google.com>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] kho: allow destroying KHO radix tree
In-Reply-To: <ag-Xa-bDOouXAFXb@plex> (Pasha Tatashin's message of "Thu, 21 May
	2026 23:46:23 +0000")
References: <20260429133928.850721-1-pratyush@kernel.org>
	<20260429133928.850721-8-pratyush@kernel.org> <ag-Xa-bDOouXAFXb@plex>
Date: Fri, 22 May 2026 15:24:09 +0200
Message-ID: <2vxzwlwv7f2e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 9dgyx53xs1q13jjq1joai6pxqueqcg9q
X-Rspamd-Queue-Id: 3BC0C10000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779456254-237345
X-HE-Meta: U2FsdGVkX1/8uy+stm/R8RIEzjigkA81pUVHcA0QtzUZANUIPqkSM4Zi7nI8XJr7fkip1jHL9KLY1ybhufMLY0HxHIAjbsSxkfZapR71lFf+CbxQYZdfWqD31VbtOiezkR+AOChN++4c8AoeogikH9qnsBqUJLzIdjhK1GIKFnaZ3B0SEGwMRHeog9e5Yn+gWYZB9jlABsubCXGs16epUR/nE2DVOGFEtqJ42FN4HmskJZGxiO8+db5GdFD82+dbYOlGFsZlOFcOYxoXQHbOiZOn3nWbf2cpxHv6SQ0z8+zMDvYysXYllbTtQzb+vu0wbjmgEopdq6/Id/TgajAoI8fpH56CqSa63z/7FOaRFI/Si7/ze3xA8ghejtF83JahfoeoK9/my7E0TtCcUGmTh/od63JxP51MDsx537bqoafoX74g9jfkZkFKqbVGAhMNVhm1eg1GaDGMVCV6t7Q9dhbc4q1vsXGcxqNLoVy6t5OLHkIWJVBN89HU1OXdQ65Udekfq0C33dc2sgvjrRkho8b30wS30dGJm5/G2yuQOxEG12IOJRZCtLI9EKOTPCbNT2sq96MKjYNoyhpWvsW3VTOK0O+BAt6/8luM83cJtEXJjDm4cIOpyfK52OXLcgM6hk42dcplRwqZg+Oa0KkAgSs3PFbItgUOhyaQaqfPYpQPelD1IFPOOGuEBBEuYwrwdCIW/lW3KUNeyBrAM3p/t+S4+l0Ei8wImCnwyQIOVSx7XQeRdgb0rJwoqTNqLfDVuvt60CjDgySGzEK+V2S8aoO0UYDHOCStbG3Nyih8d5UZAiy10pgLNjp8vN2DrztPQkmZL6ZdsuTug5d8d8zdAE7J26LM//CsAA8TlsHZjoWJs5pvrfe7ox2AO0NYasWuu7K3SjDC/P+ropI13SO5jkh6wKPBtF6J6IdlgmqUlFJFSbmTwwhKarAWpYtj0UwXogG/rLcSK/5Vqnuh21l
 zsf7Zk0X
 Q6kNXDN0r/f+iJySV/kcxuujKwctEhHlSBcpmrJ1TGRZ8A4nZQmWdZT1ChC3+urwx7hGT2NKqJ+T7vggXQ4ntBPWh0xfAKteFx+IGd5YuJisgb0UECfa/7LD9dcAqavbj4kERoP9q2HKvZyBHk31I92nvCk0VKV5d8Ik4X29rQZTr+hjAn1GXY5xT3dR8OIrJeRVtvnBxQkbOfXQvHTAGYTfFZLOWGwICx72b1WvR7LgzRPiuNLokbCSPP6ONEK9WyKby
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21 2026, Pasha Tatashin wrote:

> On 04-29 15:39, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Add kho_radix_destroy_tree() which allows destroying the radix tree and
>> freeing all its pages.
>> 
>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> ---
>>  include/linux/kho_radix_tree.h     |  3 +++
>>  kernel/liveupdate/kexec_handover.c | 34 ++++++++++++++++++++++++++++++
>>  2 files changed, 37 insertions(+)
>
> Generally, in Linux, recursion is avoided due to statically sized kernel 
> stacks. However, here we are bound by a relatively shallow KHO tree, and 
> kho_radix_walk_tree() is already recursive, so I think it is alright. We 
> just need to be mindful of local variable usage (frame sizes) within these 
> recursive functions.

Yep, recursion is strictly bounded and the depth is no worse than any
page table walkers for example.

>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

Thanks!

-- 
Regards,
Pratyush Yadav

