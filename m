Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1F09F36BAB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2236D6B0005; Fri, 10 Apr 2026 00:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB576B0089; Fri, 10 Apr 2026 00:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138CD6B0093; Fri, 10 Apr 2026 00:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02C4A6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:48:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FEEFB7EE4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:48:11 +0000 (UTC)
X-FDA: 84641414382.21.8041F9F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D8631180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:48:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lRQRKKOo;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775796490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYOr2TtMJdMZNyQWF4xJz8QKeocZDKNaSzxMtEjRG3s=;
	b=8YrHSFknkUFExbUTsO3DxbUFXTTm0BJ5db2aQcSCzWM9eONMUGhXfz2Ype94NqJTSnKZQn
	r3KBBwnf8rUn/bnUkvsj585IEArPhglTNvyb+uViBwiLiVkr9VTgAeDMCb329C/yFfKGuu
	MziBUmNZi7CRjA3YxAVZho7zLh9Q0bQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lRQRKKOo;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775796490; a=rsa-sha256;
	cv=none;
	b=Peio1LXd+puattWIdI9Ng/YU9naDA0juprUolXdPOw1noegqyWnV0rob22Bqkn4l7zGwTn
	4ZuZ2VEs44o1Bb+97WlXYNWdk9PnzWTD4Gu2Og4LhWq283gu6x3aJ2HaQS347FECAUqMql
	erRYPH3RNZY8vRJUXDLuN12Mr0pAldM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55C1A2008;
	Thu,  9 Apr 2026 21:48:03 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0FB943FAF5;
	Thu,  9 Apr 2026 21:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775796489; bh=c3DJ+S2oOSvZXmmTi+zH6GgC1NLBeyFjVpTiXZLQF9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lRQRKKOooSviZJCJhlupFZkcTLD7CpeoH/yuz7wjC+oBayyPRnena/ZGpFkvAqcYg
	 O/mgWTpyTMw10Oe5L9uCW3To1refRX442FAOZ1q1Q9E7fUuKTSjWgWWVi72EG0vw8B
	 gOyQQ8SLJFDCzSqAz8sfORy6kITdqnvEZuRVQXko=
Message-ID: <8a3849cc-e6d3-4932-865f-476a137f891a@arm.com>
Date: Fri, 10 Apr 2026 10:18:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 05/16] arm64/mm: Convert READ_ONCE() as pmdp_get() while
 accessing PMD
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-6-anshuman.khandual@arm.com>
 <628a1d9b-cc16-4cf6-8c19-b6ed49af8492@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <628a1d9b-cc16-4cf6-8c19-b6ed49af8492@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8631180008
X-Stat-Signature: 137x5gykmdkmsw8sw5963hx16pmhja4c
X-Rspam-User: 
X-HE-Tag: 1775796489-501926
X-HE-Meta: U2FsdGVkX194jA7cFNhE/CYhDymzhiJEB4XgTLN2mgOYTb0EbLuDkSsCr+8U/h4C8Hvy4MR0Wr64eWDQENWkS74qEBP7CZ2tMJPos5P5vf3Ha1blM5LTSTiTbtHlUS/2Gwb1/s9tF2UYtX68F3G0GqQtZGwMxyAyFOyP6w4miJuKvEm/45lpdGqLP17X3BFB+HGOgMrgUZArFy1kGOSf+8Hqgy+icTVOA1WazN6xqgW4o4zqDfif3TDOd6gQSA9dUHg+GGaExaX/xjkqDr2ZMv9SlfK6t5vGj5pZ0jcpRT+CKY1toAGzqSZ5YvNLdbm4QSDUVUfJLnOvgVHigq3zHtjf9xVOfw7emg+Qe1awXcSaHBh//FjJuVo/z+LzJQjAG+vFPB53XsWb+aYpGVWk/gr7VJtHBFsH/+lR7rICg+Fpzfg4LQB/INqAZfZYkOBMCYK265c9M3Ijo+Tx5BV8xmiHTXIPZ+T/6GhtGQ8xo5BMEp/Cgfaag/HJhn91qvelSwaDiKusMqFP7CRfmuQXps2eUIwQZS2pDaftE1HHW1CjIlfdOwROtsimi7FkDlnfeX3Tc44F28hGUp950OpLVrSoqkEmfzE9LTOuDsITSNcpR22I43K6LUK1JkkhSQYg1PrELj1/8sV3GT2tOQPm8IfVO9Bn40Sf3toqLYAdlQw7gINlTWOBNMThG/vxciewfIFP3ggdIjCdw9rhG5JiH5cfXWmadK84E8kw+49HBcQ243tsORamKyZmKD4Fi18t/b0YWrZwsagbyB/EaEpGim0nUP7dAbjR5yz1iOemVOFFZWDdXmz+njyEIAFmf7NBZxK44VTBJzqJsV1+61OfQfP+2NWzjp0feHQsnjt0UR6GuXaCet/xkZEfVyBLaJm9MiMo3kL7SNLWIM/TQeXmH6//lRlBo+CrKfQh++rYic9sRdkortH/bdVGY6YdEvmwtia25JkWJRSTgobiWuv
 k0Esaipl
 2rCSG7sUwBpshSHMxtoH1l6agoZeiVH4yCSjux61xIvSk6M6m9sPKEo29lwVa/0x0GJWICYK76sEF1tLZS0E1X1Za+3ox5vJYZV+yyiheNHiBYngz7JTiHu5Eod7blpIT7rYIt/hQ+aOxwkb3iXgRdfyE96t89qqzCY2YwQCGjLCXnjVvOnF+NeOx3CYHug8iFKbFjCibtkuPMcQ4wvlPgIzo7NtA/PoyoL/Bg7VmaDlBwADm5yppau/Hcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 5:41 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
>> Convert all READ_ONCE() based PMD accesses as pmdp_get() instead which will
>> support both D64 and D128 translation regime going forward.
> 
> You should mention the move from pmdp_test_and_clear_young(), and why it
> is performed.

Sure will do that. Actually there as a build problem while accessing
pmdp_get() from pmdp_test_and_clear_young() while being inside the
header which necessitated this move.

> 
> Nothing else jumped at me :)
> 


