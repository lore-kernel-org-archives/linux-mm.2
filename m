Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8FAFEE4F2
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 17:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2335E6B008C; Sat, 28 Feb 2026 12:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6AF6B0092; Sat, 28 Feb 2026 12:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9046B0093; Sat, 28 Feb 2026 12:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EAEB06B008C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 12:01:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98CFB89DE0
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:01:37 +0000 (UTC)
X-FDA: 84494481834.11.7BA4436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D29A540015
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:01:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D92eRQ8q;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772298095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3wnXlDBCPYk1DGB+Y8y/tFL0ECra/U7/MrOl3dvcfQ=;
	b=YkBLOu8Qps0A9k7pz4R4xPM69tm0Bc2uYicSOZlQ+2e9vJySC4iBCuoQPRrX8seQD0BGBk
	2Q66to6n3OS4a3IN+xADjzvygfMRkeiLmd+koOW77tJUNhPQkWO8oUtF/u6DPRzfnQZsNH
	RYL14u5no3xsrYNChrts62tUhIGDq0A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D92eRQ8q;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772298095; a=rsa-sha256;
	cv=none;
	b=nRIrtTmZgK/5GksjTr5Ehbu+9Zz4Nhcm4mlk/0WuAoEZ8dgxSZ3zHKnnua+0/drlCJtFdk
	sYP5Z3urN+cDFqLxQV+KvaaTuvo/6yCSlnOUWVekRmFxHp9QP+C+AtPgmDp2k4AX3R/Pnm
	wfcU25UVsScdhOpp79Mw/11c1oEjczk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D09CA435D3;
	Sat, 28 Feb 2026 17:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B81C116D0;
	Sat, 28 Feb 2026 17:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772298094;
	bh=gaS/vF7ztnyBcuFCaUB/Kfe9GGvI/Oo6VaaFyfLL1Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D92eRQ8q7AeKuT1F068VBIuSajn7M7DUTmkBMnNIPElPUydM/5BrqrbQ+zGgsOddG
	 SjQlES7DNXnxJfP2cF+Tfbox7uadf+8N86jhGx4GiXQm2JoO9dakUCQr8jJ4+2ODw0
	 ZyvKyTZ3byQ59lYRByY0TryMqCkzImlA2yhXaCFizYONoynLLA3B7ixd4O2tHVvFOD
	 OZ2/VfHN3K3DU5osYFz4RbjRDqvVQvKpQwpi2QTxxvs3hsOjllMuoz3bB4nMhx1Q/E
	 f/9aJ8PEuQ8tBDhvdMyS/aJrrnE4PO51OF6oAnudORF9YdIL4eaEM/xnibOfhHVAsH
	 fBg8NyoBI0BwQ==
From: SeongJae Park <sj@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Replace READ_ONCE() in pud_trans_unstable()
Date: Sat, 28 Feb 2026 09:01:26 -0800
Message-ID: <20260228170127.88672-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260227040300.2091901-1-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D29A540015
X-Stat-Signature: fobt4s1os9zs5yx8m6h9kdkg8jt1wiu3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772298095-270514
X-HE-Meta: U2FsdGVkX18gsPlKQyn96VyLb09c2VC9Fid48+nhXjaeSrQgpjtv1E8YwqQbAV/08sPiC18pHlPd7kqGJlRXwEieV2MAhNO/1jGu9Jnl2N56408lqSQaMnmX/d23jU7GaCU64FPlM7DTXwOsmCYdZw45Z43KPGsHqie5UPsEcyX1VfX1431HDVYW2qSH1lAPm0timpECqAo9HyIiAQhDc9JDZzdZefNXnFcsX3cX4dRgPvVLh2OjOsBvtlbMnWRKkWPQGvgofArYHcCfclxeVma7oLEWeFak+LUt87LgA+sQ3P5DIcufGN/it8tHqdbpIo/ButpOMnHZqcn6UlN8IkvtP1AhoIDtxOnxNRa+9GepnStJRztH98aXQrpEK3VyISKO+CmBCz2kkiHDVgvfq6Sl+X95aMYz4/1YSX+Hb87cxIN0WhASIly97/8TA3n9kkPwn5bY+yS1SUgB3jZKvXm64CJSUO22ltsdc3RH5R7pFae7wIdgLkr3dJnT+fs0aheMnYta1GRm5c2rdrZLqo5iyO8LU5IwZH1nxWZ8vkUhfOO9TqwYQENgCY7EIWXkS0qUs1eMp/KjYeBcIBMHE9W8FTznQc0wTMEiUYWWDCNtQdRY0AJ2EkmZaDBK8SUab/AiH7gGXaXmjzbqJxcJ38Buo+RZURKoEDNARHN7l+QUnVBZC5DmcV3/LzAr0OKc/Jvm73+AyiL/RPqVgeSFto2WWNab/P9gILymze7/306EaIyajojwHg3H8ZwUtjMVKTKc0HRDW8rzdCi3qBziVZULVQZGgLZwIpVqlAvBx1/INZJsoyRIykVMOYKetYIxglQ9ubFNfxGFeFItpl97PS+tLq/815uZzKaEUcAMsvIjUeYB95gL35/a3k02FdJP/f+Jah8rAQdUT11HltVAaHvm/81BDcbXi4q11aCZFJGndn25I+cs5SMPdvTb1j1UiLcTfG9Ue8vnRy6Pyfu
 ftWE8pjM
 uoji4y9ozEMPTL4ef6kGvsEhD/ajrrBc/dgTeTaHFWhhkASFkLSt2nJE3lCr/ZN0MXjZltHYXeHj20QGQID6z9LFKkynMBIANUwWZawkZfEiMy5t/qVKdO5PUWjMbYzrfNniovCWeuD+RGgiHxSJI7XFkjO7wYmis6ky3oofyQAq5p0yV2AAec4vIiLPqptbQIK/6j7kvgM3TEdwDlcSTVTXHHah67dZgTpMEyXl69N/7HkP8jzXnINVCYpXCHdkyBd59P+uAXE31cnfTz2fwDrbMYnSDj/FOR3YcELxg8jq4BwKu/Y75wwEMfhr0NBADIx+j//XcGMydh0OT3c4X0p+Hmnt1zEtdlJ7yxT8B3VmIOr9d6ptfQBlrhMBzz4J7C6HIeP9P9bESJi4KgHSmC0Z/kIW/f9/WtYpufRQ2Ant99Cs4HoIXD2rtMj+DDczKDhHG30yhBOm6dMlMA9JeWTGc4iBg/VSwPdVI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 04:03:00 +0000 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Replace READ_ONCE() with the existing standard page table accessor for PUD
> aka pudp_get() in pud_trans_unstable(). This does not create any functional
> change for platforms that do not override pudp_get(), which still defaults
> to READ_ONCE().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

