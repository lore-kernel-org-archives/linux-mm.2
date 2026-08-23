Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9896AC5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DD26B0095; Sun, 23 Aug 2026 15:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEAB6B009B; Sun, 23 Aug 2026 15:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDA96B009D; Sun, 23 Aug 2026 15:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E13E6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:17:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88313403A5
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:17:47 +0000 (UTC)
X-FDA: 85133493774.30.2922128
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E6821A0005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:17:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S h172nv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=U8qMIjuW;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787512665;
	b=7h3RZ4ZJtbHKOqJeb+IQMdTpEx9aE/MXP2hgJPehj+iwyIa0RCnibB/q5bd1IpJWSpnqt/
	govJW9QGgliGFZgGVpZD7kfdXxF0IP2WJi368OuM4ivC4Bvr8O5VPuWL+1ieTI66gLXvLV
	MOeSLLiDLlbH5ESq3md+ibGrRjUshdk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="S h172nv";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=U8qMIjuW;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787512665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wLxy792B6yNuuTN2hFZ7joedHo9NROFJ3RumMARwe4=;
	b=i4i7fT7vBaNLWScJfmn/F16u/4LPn3UX/qmNWe7Jg3fle0KZhW2/0ZuLXBR9phuARc8KdW
	Oo/MjhAsA6vJXyvh5Z1Al16r6lK+UXNLTeqwoCiVU64U8SgpRWSENJRxQzlMfRWoNasMeA
	pk93dqothM/ThL9psyWtDxXMy2HNKIk=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 8F87913000E2;
	Sun, 23 Aug 2026 15:17:43 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 23 Aug 2026 15:17:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787512663; x=
	1787519863; bh=0wLxy792B6yNuuTN2hFZ7joedHo9NROFJ3RumMARwe4=; b=S
	h172nvLnDkyAB1weLsxE1VwjgqoHALsfHUizskU3E3z31baxwgN+rW1PV9h79e3C
	84TIJB4elaZ6xWcLDZDEkQUADqoHGtBRewFTon3qC9tkFA7X2+tluK++KbOUmj9A
	WUnTMTvXpPFjcOWm54FjWs6WJ9o8nyntXF5BX+qSWZqOxq4m1Xhs7Ig02aSTpLrJ
	aaNbhKSmdZxSD2GbXmZt1NHTsjxmAzEE416BVjypZkiO42Ct9FAJ8N/aPKCL7K1q
	/6nz435RiaGaGgn8KTDj1yIQvQC7x3qLO/bfdnQTtRjOKEghTWAKIwrBwwVPjtL8
	l8jSldykja69bCnbss1og==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787512663; x=1787519863; bh=0wLxy792B6yNuuTN2hFZ7joedHo9NROFJ3R
	umMARwe4=; b=U8qMIjuW70/dXCbpvwKxtBUmcsNKlSWGtC8DP27jJSw3dFa+qJR
	CAXLqVVJGP0QHLewjKcKipkSYrg/1JhdooBpXGRkFrvgvgiDXh92JqCGYE+TuGl8
	/iuRrdeZuTZwfT3wUpJtOBNBDhQGF+83DgS995i4jL94Sp6VXxiE3E0T2TsNa2b9
	HRRf67CFriTL2KOjUFRc/3c6aNydflTkMXpvPKjNaDb+Dgy5CuDUALZMxajwAtKU
	q02K/hTfErHbudYv8B+1kRlS9JpQAvo1bA7kn5v2M0PmSxxBF+U6rYlyMI4XpCdY
	xbfdxiMB149O7eSVe2z7b2rHfwZ9VxpDBng==
X-ME-Sender: <xms:VkeLam6xJ1jN4ngbIRqfCtnvcsyWVK5AHmD0y-o8_0L47t0lOBQHaw>
    <xme:VkeLatjqbES0ahdNINVRRmjsg72zGXz2VwnU5dfa39uyaADW124JWUAOgexBmxXGK
    bpvm9rq8kgwUuIRYBolkweSc0Omlubrdw3UJkmG7_bFPaldfu7MBFpo>
X-ME-Received: <xmr:VkeLarDT9CPjTGW61p6Jsqhoc9O8NZ106xWrj7vSXnvB_A087UHOcPCEccc>
X-ME-Proxy-Cause: dmFkZTFvj3ReSWIb55/gzqe1p2vADJpe2m938hpzU8Jp7sQQ+uDkp+Af7BRN+YUj5izGrP
    ozuQI6+mhwe05vF8+hIceVJhtt1lF1UWX+PMS29zLHNWwa39BloQnd5iwe2kKi9NCiuWjd
    AoJ0VbO1+/UwTRpxrTcW8DnKYlvqZtZ/K63Eq8Ad/8llZfx+26m8vP+SLHnA38cimd2o7j
    Hk5nbqLS1xqX7kWzc9TQstwh/PffKF9YfFowcjA9A8/TqWlG4FKoyX7nXQdsj9P6LrqfBC
    ovvkf1ZdC73R29CcITbF0ySlcxWl9XoA8//IwsOs3etdbiVdaNDoyfODSeYV3n7lBndkIF
    i0NacUKwx0cTYf94OCY15U/bvqUDAgUEZNv6ZQy/GV1L5x3fuHZxWO9uwIbYeubchNQsjJ
    C0TPVQ+JBNKfQ2eOG9Nlg+RTSa+65A3djLXMJ6bgpXqp6t18Sm1ld1JgYSeY1lRO0gRfR7
    4lc+MGguPN3TbtIpnwBXqV7bfmAYQ/0rZ4R4IL7SoGn59qriew3214fXxwirQicHxdgOEd
    rpApnVQooRr+E+/G5b93MS0peDpCOTYtZeoZdrhmpJrPDSunoGUBJcStTt2lw+39+nOU6X
    yJ5uAQ2h/Fm2kZJsyy4TAgikyNB+2MMUTTh3kRhsRmea8oQwEhP7kdLx+CWQ
X-ME-Proxy: <xmx:VkeLamxVi8L2vSLLy3s8GdNfNkJMPLYn4WV-kr9G1a4joGEKLyQaBg>
    <xmx:VkeLapO27o9snJry_3TK_bLugaYkcskVBYSBV_ekpYWYpj-OqqN39Q>
    <xmx:VkeLatfq9ktOAVIA_z5DgMCMx6pReY6NXRpfZiwE42_tJEVIw1JllQ>
    <xmx:VkeLag62a9T0KNyJrxbApaAzNu7We6qFPp3s6U4XqFNCVdmQWGOe9g>
    <xmx:V0eLasgDVUyQ9Nj9xGGyaGXOaIPKyEqKegRWKR1ktifySRG5-yGHhh9B>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Aug 2026 15:17:41 -0400 (EDT)
Date: Sun, 23 Aug 2026 20:17:40 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/19] selftests/mm: scale khugepaged's collapse wait
 with the PMD size
Message-ID: <aotFuN5NTCnawTy3@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-4-kirill@shutemov.name>
 <aoQuCP87uX2kHl5q@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQuCP87uX2kHl5q@lucifer>
X-Rspamd-Queue-Id: 8E6821A0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: d75tweq6ch6nymw796wca75sb89jfpdh
X-HE-Tag: 1787512665-925787
X-HE-Meta: U2FsdGVkX194hlWDhoDvV3Hl1PxHSkrlLl5Q4bQ+znUzdlkOyC+HbUQf1I9p7WXXEcpqn84UGjAMMqDHm7Vb3D5IKig+vHhjafNcGqHNdmaSHtTCfnrrwzu0+hfxSvRny5pQ3CRE8a84tQ7mXhGlGtCdGroubDOu1C4S0xIv8ZYUvZwGMD48/vFixRUHmapWbIHkTV0V8ISlVl0BO57z+XApc2HD1fbnO3emhZIS3MpNemp4OuJASSvAjqa19R+vj6tRDJ8DVgs5P3ZHZS6VsJnO0KC98cRPfhb3m+QmbyaL71kfbhPQbC9zhQxBpF3i7uiAYg0ztlc8RQOIFJXRXZPNcMvt3FfBEONg498yOzlQIsHOd0Jbi0HkcpwUySZGP7v4hRF4oOQOmr19awVf+XQ9Zyc1qwwWyuSgRP2RC4hAXDv9aaJL+JiwDTNmIiuFjiqdBlvH4IpK9GJL/oEYfysZteMkRoF+Ds7d3UCLnhErtYx4bZGkDFKm1AuzFC0ZSvy8R7fkDr7ADmIktM7bpp8GxeTLGSxmm2hK/156dFeOyoxeE4JfADWojLuCEeCRfvrI4TUi9yhqYtw3HYY0Cqnbk+Gd2JTouXNO6KlOh5NUeZly4pRikpsn5+/nzOVzx/T97fR3hi4nJOOM4cid3IJ/YbXsxXL/jiJjDxdHVhgmA2D1L5GsnPyoaIR/GXXhROYwVg9d+DZbEa+h9Is26sVgljxTH3qMnma2UxhWM972YTR1oBTk/DvlpuZSZuUuGk9iOTOzHUwIyk/0c/T8wSUVqQT9btRciPHokylNPXd4GehYV0WwDUScjBR3wnNP//65uPEmdVOUo8alMFMqruAEH6E687PX03Nl+sx5/h3Hem7hLtpblSLZkL4opbdMRUqVdQOHQ3zSpRxMA2TIcLh2j/AqPYYvy4eVto+UMje5lJ5K+mXrwAEi74LePpp5A8eH1uZEIkuTASb/1p2
 C9PtLl48
 n18pVRvdmMLv4TEP4VdZmEpj9EJqsIeTiLqsKogZG+9hk1RZkvshXPxy4ibAy+BKuamvXb7+etfCwsJonFya4OCi1pZsKGTSk5Us2WbzEFSWMKVw0qtLuvA994opV1T+j5rza2Hsa1bzO6ZWZiDXbixzbc5Tu5T0OytTM8dQ5Tewzf9peeBHm9lqrPrSGMl4fhUaoUu/Z6ghzx7W2yyq+xdofrMyi04VLRVCL1ojakUAqq32WT3BeaYbKCgnrFJ0tPPHf5oGSHWZpOrfBR4YQ7EOL9mNUDbGsT2FCGbqWqOf2w7Cuh71xLmUbs7J4QuQNtlzjU9Em8pS55WamzBSkeCveR7jXnHdOHJzwNxThfgczdNXJedJ8tGpPBcGVKZUloT5EIWMYEGS7Jvud3gLEvxFCAWHO6ZZsfkSVHdujIX4uPx0XbQMccmay4vjXtE8tORUopa3odc1sckBf9TSQ7Y7n4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 11:04:57AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Sat, Aug 15, 2026 at 02:58:45AM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > wait_for_scan() gives every case the same three seconds, whatever the huge
> > page costs to build.  collapse_full() asks for four of them: 8M at a 2M
> > PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.
> >
> > Three seconds is thin at that size rather than generous.  Across 80 runs of
> > collapse_full() on arm64 with 64K pages the wait was half a second in 73 of
> > them, with a tail to two seconds.  The case has also timed out in a full
> > matrix run, reporting a failure for a collapse that was still going.
> >
> > Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
> > PMD is unchanged.  A 512M PMD gets 19 seconds.
> 
> Yikes that does make this run really slow for 64 KiB page size machines and a
> key aim in the selftests is that they don't take too egregiously long to run.
> 
> Can this somehow be trimmed some other way?

It does not change how long the run takes.

The timeout is a ceiling on a poll loop, not a sleep: wait_for_scan()
breaks as soon as check_huge() sees the collapse, or as soon as
`full_scans` has advanced by two.

On arm64 with 64K pages the wait was half a second in 73 of 80 runs of
`collapse_full()`.  The 19 seconds is spent only when two khugepaged
passes have not completed in that time, which is the case this patch
exists to stop reporting as a failure. This can happen on very big
machines with high memory usage or in an emulator. I use QEMU TCG for
testing on ARM.

I will put that in the changelog for v5, with the before and after
runtime of the whole `./khugepaged` run.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

