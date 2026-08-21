Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36DC9C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FFA6B009D; Fri, 21 Aug 2026 15:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F87E6B00A1; Fri, 21 Aug 2026 15:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E896B00A2; Fri, 21 Aug 2026 15:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF2056B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:43:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71DFD1C0B2E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:43:47 +0000 (UTC)
X-FDA: 85126301694.01.778E295
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf06.hostedemail.com (Postfix) with ESMTP id 255E0180008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:43:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=UOnKEwpA;
	spf=pass (imf06.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787341425;
	b=dKI2qdmBQ7wmghXplXXyCJoCDDj+nHALTL2JtG5996kNQCHyFXkubK7gTfnCScqCyCDoAJ
	W4vp/jtgD4nCn1lYWMmxQTIu8t1U2TFh2crtzTjKyGmIny1DO828ju/CuX/cfdIF0z5Rm5
	5QNSBvEcMIsAGn5/Emf3ni1sVehgRE0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=UOnKEwpA;
	spf=pass (imf06.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cuOCLoydud/Ghe+/9rUSZTIFvtw+XcphcGGyMAn1DU=;
	b=gOgYqjkS1XnRHeGNf0SOssXxY17U3uqd5NbQirQOtQ4UvMZVENhHS1yZBS4MDP4JbwGu9z
	GjANsUtkgmUW0n3Ny5oVq59S7n1nEE1DeUKiEXnUh+P6iGR3UtqONl9fFAvWdjze6czqHp
	l5WYvgaFw92Fn77UVsrcYikrj0LyUys=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3cuOCLoydud/Ghe+/9rUSZTIFvtw+XcphcGGyMAn1DU=; b=UOnKEwpA8W47dATxIYHpCwlglm
	j4OWzlHUpBHdblDB3DgM+AINW95cU3xyMHpn7Fklf6Jw0KIwvusAjWUVz5slYDNAWJEP898gssApf
	lPX78bB3RKwn9jXCnQE220o4PPErwSQpjtxhshKpHyQLzYg5YrQa5QDCgTQE1MLLVbxb2+j5kwd/B
	GF+Xrj8jZyAjbz3bGywWiR5VYKhZoQpN2ZPHAK3KsRLdowFg5hrcfQ6KnGJQwbtjmWISM9Rp5hjM9
	5sEvcrw+gbEWnVbRhTcxqwufFylrTO+Unnd0apooj8W7MgqkwCzwaoYI5NpwHMdlm6DPKPXs+Bmti
	rDowhHGg==;
Received: from [::1] (port=52878 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wxV9S-0000000DuUZ-4BGv;
	Fri, 21 Aug 2026 21:43:42 +0200
MIME-Version: 1.0
Date: Fri, 21 Aug 2026 21:43:41 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: kees@kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
 jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf_fdpic: reject PT_LOAD with filesz larger than
 memsz
In-Reply-To: <aog5Kx6HB3jxb8cJ@lt-jori.localdomain>
References: <20260820222824.3165092-3-Jeremy.Jean@oss.cyber.gouv.fr>
 <aog5Kx6HB3jxb8cJ@lt-jori.localdomain>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <f7380c43c8cb88cafa170faec902c1b7@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Queue-Id: 255E0180008
X-Rspam-User: 
X-Stat-Signature: d68b48wkocohyn9o4qsumnykgdcor3h7
X-Rspamd-Server: rspam06
X-HE-Tag: 1787341423-293226
X-HE-Meta: U2FsdGVkX19con8QN0ek4Ghfilz0Hd5EOItA3m03Ain3c8x7+MTCTHKzHi1eBIFoOQIHl15MXSMk1OhuAOmTEtDQbrYXmcitzRwnIKtyi/NQhGA0X2BVZvwS+szwQ2eH2dgAAwKymiWLDNzratudspilio0fUC6fWDlwwHwGmtlikvqigd5mynEZeBjac+kgkqs01qoTvPSd3ye8t/i0g0iLpaQvSRQGp7bP/V/iMRsScJDsAUCQf6c/u4BK6quRcCf7j3Y+lL2dS+xV5QW20WhWSdu5SbrUd0rvefmt62w8GZ+K17CNp3A+FCVqggeRQkVdFOnZea57KAWCOalGbvLsifVeRqFXpCqEXGZgik0v1RiAwpS4X/rDW9DVvixXEuizXESl+Wcl6jeD08AtFaUYdcWtQHnxCChNwueIzz0WFz5Ex0/gkAs60sd7zVOgQfXqKo0FaYZKf1A9laIwx5QzmJB2d5y4eSmNwKQxEOb9h9QOL+bGO6QyMWBwS8u4L+gggy4nA8vp/SYD8SHW85ZPP0paAfJEyQNqfP0/2GAVtgIML//B01lqLp52vGKQt3UrHMYFMYOO/Cte7L7WkQOoXeSpqEKiMbzkGMCRWFbtYARKzLjcyykaEFI/VqSld3aPBAHt9wBQDvsAkiqU0YeHVzVEv8X346GgLyBTnKlWEvym4pySEA9Xa5dMuO8qdiL7Zr5aDJdgRDaaepTwzHxDW3DDWbStn0XXuGONoTv7vjUhvAJ4s1w4DS8X+hezc3wtxs7V+vJEY/z7UeRU5zzVKGXy/TEm2GqOpXUwAcBGoDz7lJV7ILzz/ePuUtWPdvmyS1glamcQyaUDM/zMA8xFyOxuFGdF180rRzbLGP58ejcqUrCUjus5YUojnofnyWCvtCLro1Hq1RCrCNDEx+SrWV6XbUybNCNgOyYxEpozz1OVbjEgBO+5H58zrN5OcM9SlaDMKcJjMMApjsK
 gKcWw0vx
 TqZrJNzJ4hsGB57jqkbaj4/sBckaUuLj7EImYi+gA0wfBWVGVDk1l20EI+wbq8iOh7HiovZvQaKsFqqp+qgy2p8nan7ilnyTxq+csI0aG3yzlPqTQ+lJd8IIopVzlQSUYjieXOUoulvc51MGNFeVe2Oc2xLubc4PzVDoPYO4r/edSYa4zPxW70ECskGuAPryItkIVa2bgDrG3W2W2v+lDFD8Pj4nmVmhMvhkOn6LvUq5ZwFl8iBYTxAlKq3CQTB4sIjXP6TK9f6gsTrxU6ArDAd8vwDkYyhn/Vs0DVV0etx0tj6j6u3n8aeHkffRCft0VGaKYn1Vi4OzxHk5tTMtjraifZUUM2wLi2i4/fmpmbrl9s0d8gMGJ5gRTUMzsyRSNdpVpKW1NS864JRBau6vTDUpgmJWQU91oWHoosd0u0eTnFOKvBgcqrXa4MtWzvjAif4rDQwdONiYBLhTduFdXbbJgXPrQZ8w7EMeLPutVKO/DhkUzsGOBcCO5IDy1XTlmAXAdvcMQof4q0d5eglQv1vcp+xqBWVRjXKfH6964hVancS1lgJzaUrbWAPN2KmJTA4cf4TIwsR2kgTfd+C6GIxGecungetFqq1EbEXq3VSfRGGZxbv6dhwpb6j+ToCwQxN7vy21hIcTVv9Tq+4tpIPUc08NMkb5yVpT1qZw1e6eRLVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jori,

On 2026-08-21 13:45, Jori Koolstra wrote:
> On Thu, Aug 20, 2026 at 10:28:26PM +0000, Jérémy Jean wrote:
>> The ELF specification requires p_filesz to be no larger than p_memsz 
>> for
>> PT_LOAD segments.
>> 
>> elf_fdpic_map_file_constdisp_on_uclinux() sizes its contiguous 
>> allocation
>> from p_memsz, then read_code() copies p_filesz bytes into it. A 
>> malformed
>> segment can therefore copy file contents past the allocation on NOMMU
>> systems. The direct-mmap path also subtracts p_filesz from p_memsz 
>> without
>> first validating the relationship.
>> 
>> Validate every PT_LOAD immediately after fetching the program headers.
>> This covers both executable and interpreter headers before
>> begin_new_exec() makes execution irreversible.
>> 
>> On RV32 NOMMU, an ET_DYN with an 8192-byte p_filesz and 4096-byte 
>> p_memsz
>> copied a marker from the second file page past its one-page mapping.
>> After this change execve() rejects it with -EINVAL, while an 8192/8192
>> control still executes.
>> 
>> The flaw dates back to the driver's introduction in the pre-git 
>> history
>> tree introduced in v2.6.11 by 91808d6ebe39 ("[PATCH] FRV: Add FDPIC 
>> ELF
>> binary format driver").
> 
> I came across this about a month ago. But I wonder if this is even 
> worth
> fixing. You are on a non-MMU system, so running a malicious ELF kinda
> means gameover anyhow, doesn't it?

Well, this would act as defense in depth, no? I agree that cases where 
this
matters are probably rare, if any, but I don't see why this should not 
be fixed
anyway. Isn't it best not to assume anything about the use cases? The 
patch is
only a suggestion to start discussions: I'm merely raising this to your
attention but you guys (maintainers) are obviously in the best place to 
check
whether there are better options.

Regards,
Jérémy

