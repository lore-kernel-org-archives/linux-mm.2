Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC57C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 19:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CC86B008C; Sun, 23 Aug 2026 15:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D0C6B0095; Sun, 23 Aug 2026 15:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BEC6B009B; Sun, 23 Aug 2026 15:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78E536B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 15:49:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02311A03AE
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:49:48 +0000 (UTC)
X-FDA: 85133574498.24.A3D835F
Received: from flow-b2-smtp.messagingengine.com (flow-b2-smtp.messagingengine.com [202.12.124.137])
	by imf07.hostedemail.com (Postfix) with ESMTP id E575B40003
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:49:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 5xrzIn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=P6dU7JeG;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787514587;
	b=GSBOzztnn3uPspj86v3tPIqAmkMIsrN66uTB9I/i6sYl4i5NvpanpsDWzVb/BUyLnZ9psu
	I/cSK3tfHnLjw5IYjXrQeUKcjGQjUkJzJHmhyMpnQWoaRkC0/rpy/493KM4Kdgq4hCmu2m
	BZiuePqtqobiFZuZzs+gcVVyjbhrSZs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L 5xrzIn";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=P6dU7JeG;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787514587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+PEmVTxFVbO+G6COCTpau9qWfIWMrb/rGYLGbdWQbM=;
	b=OH0fADgdeYqAXgp95XH7myFrIWfyWYCP+/NspfgONBCMH3M2ObvZetmgBjTvldqVxhA013
	Ix1Xn7TwLq6ySw2/Tb8xZPfhapm2QkhaYxxUprUG8eO/7BDLfWZ3ccyr0T9V5vn7s58iEc
	PRCsyjScOXij6nWyVLfkSE0qCo9ny/c=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 1B22813000DA;
	Sun, 23 Aug 2026 15:49:45 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sun, 23 Aug 2026 15:49:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787514584; x=
	1787521784; bh=i+PEmVTxFVbO+G6COCTpau9qWfIWMrb/rGYLGbdWQbM=; b=L
	5xrzInGO2VnLLP+kVJT7DZP/ivx0Ssj4v8hOScufJqibAcwzWwOB+vTyxWDJyKDn
	lArMZlyIGXQes3ORBC93AiLNfzZPIuUMYVV12S2eD2YK9t5UwaVhVGF6V1+MVf1+
	KnXr/jclQ/69T3IEdUupadR3QKWHU4jkXUFXrsL47omMP/clYPuJhGQGQ0fGfrgS
	IxID1ObLWVhGjyyGYGATA2Dq+abxwFIWD3LLkJfCjAKzkeXef1b0YJFXSjJW4Hf/
	EaK5huZGlVOiUmZJ4AU81GC4+qsAmYRlRvyinubNoo7Cl17vbh1FIKsQ1uocmBT5
	/F8aQEiW7bO0AsfsXEpOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787514584; x=1787521784; bh=i+PEmVTxFVbO+G6COCTpau9qWfIWMrb/rGY
	LGbdWQbM=; b=P6dU7JeGgXFt1i02vsq9XaXx7u5SUds61qKOVxQ5PZRBSj67I+8
	3nQuYPqcKm7sH9wftWk607NqclDOdERI3ArpeZdbrlYbo0NtSMRAcfQPr5z4CjAR
	T3vVaShP6qp99QZTNCkHPglTYI/F7Pq65oA3I5T+kqlz45T9Qfx84lGmK8RFnSr1
	rFxBQBGmBPxj3RiXt1ntXVpzuF4ACtjy2lgIEHmeriFTOKGYOWoY/s1vOzPmbG3Y
	PRzmHO4xYNV6hNzEfLnyOUsskXOZFBNa+3DtanPB5iwFkaz1PBuwdrqQTYT+q7Dz
	ZdbkJHQT4MFh5x5rlLPS2cAHtR8EdFvPPFA==
X-ME-Sender: <xms:106LalEg9r0RTs3mwls47QXnEu6A7KxEG2NwN5H5G9W1Pr8zUxVnwg>
    <xme:106LajVO92JzZldxwHl9wjXN60dX0R1Cvq2AqMeIFetapqVvc49O_OvOVuwlPa17X
    rj7sMyhYDheNqdsixjiDD6x3NJyPIwXpsZt_jEYiJDuW_oGaEDSvj4>
X-ME-Received: <xmr:106Lag3-SBnj780sHq34ebQ8HIf2hzW9fmiQP30HgOig874lAR92xIt3BOU>
X-ME-Proxy-Cause: dmFkZTEnq2IcyVMu+h7DjTUHabZYY7hv+NX1QZIFs2I3G53FDoijQmaMTNOrpiXT9n8h+/
    6zWv2EHJ4QvOWg1bjrm5dlNVp49+1KtLAJncHOSEP8pZVia+BIMq9r91fhBAQg4waWt0dX
    5xpeZFTVTyP7xRHyt4gH8zYlHICa5dTwq9SPUMJtTUgg2ntiRnC62kadst1O30BNUeXXfZ
    ADTffG+O+9rYvXbSqWiLBk4oZX6X94jrhohuCjkteJ/hESx3rAzpx1CxMlduqo3xGBluvd
    arc3SuEXhWbFjC0J5ZDsb/qZ9V0eYI1QOwymv3OgOvNOf1Iwj0ljcgWUiGmVMqg5cQ45fu
    ZitEpkmrkvspZ4rUKSqMtTF2YBzziSZIfqDoQ0Qlz4mNM/Bb9Eh4FBEm1DvA5/ZH6VjGRp
    4LuJMrVSNpWFX/PSF6R0GriglTfhVxIqvJFjLbuKOlgEdNV6n6fFJ88CMTerblB8JF7O82
    WW2haMggx9TayWkCdbpOUut6+n8X1G40XDiMOANXFWU2wDR51viKl419A/7DvnItTyZphW
    rfkBlDfSh/8XuZ2sayzxssG8XECnCnp+xhMjsnxvuc57t4pPlwe3HzL/jA6jAozvMcqfS0
    /gQ2dBrBwKIZSvAkdLh9+oqowQV5bx9SHJ76noicK2Q3EOwct3ynE8kXSSRg
X-ME-Proxy: <xmx:106LaiApnPZLQIgXQ9cRavtRtJQUXnLJ_VnCea5_MZ9hzGBSGRmN3g>
    <xmx:106LauBet7ipy3-oU8Jcdnh7Uy7eH8VwZhLkI41rGqLVMfXyAA_CoQ>
    <xmx:106LauMz6dBgkuhTXcAR_5BBHJ9OeY7VyVCSgZavyYr7Y1o3b979nw>
    <xmx:106Laiwchmwz3cgJf1WS0n60pllN6rb-6W32iBfr51UIIx4YHm44pQ>
    <xmx:2E6LatgJSk5wvoSDyF-aOLTWelbU52QivjD0KlRgSVzMR_yfELO3WHfW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 23 Aug 2026 15:49:43 -0400 (EDT)
Date: Sun, 23 Aug 2026 20:49:42 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
	agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/19] selftests/mm: make the swap cases' swapout
 reliable
Message-ID: <aotOf7s43-oD84r-@thinkstation>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-6-kirill@shutemov.name>
 <178721523516.2799959.17614116166980239496.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178721523516.2799959.17614116166980239496.b4-review@b4>
X-Rspamd-Queue-Id: E575B40003
X-Rspam-User: 
X-Stat-Signature: 5cbdrseq8dep4a561j8t1tjee4unmnrb
X-Rspamd-Server: rspam06
X-HE-Tag: 1787514586-875963
X-HE-Meta: U2FsdGVkX19DSsZ5CWcgLYmzNdseojEWCEy1MKAgkWTLQxwFcLXOVSi+e/ERuiVkf1/ZhqgCzCLNPgfGEuodTMlF/R7TRN09eg+h/ymotx47lE5bY/Ba9IrxrkORVV1yiJjWreOsZyALuvNM6f2rlz1itFa/kt2rQDgm++8geaZWIx3zHQ2RikW+yF6qsNyub+HjxhBbR0ynmToY+C/cnkeKgcVSjEJqnrWGVaZvCOLhoZS+UONcDJhBTmXLhzTWcYsvsPsyg+GPl3t3eerVGr0Ds+EQO/JlWHN+9BQflNKVNVx2nuxC+iTe+YqmevucDdOoBx/Li9OjXzlM0CQy7/51pTA/NXfNk8FMn9FzX98ROfv88BfjjaTY0ctx10UHazGAbXqPThXcHaU4VfmxR+nsnMh47nA7XnfnWQpHL7+CfWV7+Wukc4e4FmHURtA4bEo3xa/Km7oYJbYUJvPrM0SK8hWb96O1c/kwnLq6tjKdHrCV7IfLKa1123NSBT2nKgVsLkBqbcyIHhIahPArawbJ5/9vTRVMjoNeqq/j+xCUI87LRP2XHmYrgOE70KaN5jmYvOhYcFADazIr4AwucYUuYPJTTsE4wgbf8DpKL86KLc193hItnHsCdPJGptYIQtbBJRRxo/vAE19Lh3y/jl2dFpRVkDjg1OkIXBTcPLbC0bs1+F7c3WPIpZPL53f8EIMbmP2Fs7Cag1217cFys29tRKLuiYvN/h1g0gx4ZkVyf1B4sKutGUtS2APL3/cVmxbYi5xL+BAVq8GxJyQcQ0PO2GKxsIQk/kblB3GO/PqG0Tc2FkHRMwzkw9BWpNIwAI6Mt7v4jPM+1zqOLmyPHjU8YnW9mt2dLxkerb4hC3/t8TlZYe7bJxsUeDo3V4A822P6dpJ8wgSN7mghs3zz+t0ArhQ2aE+/mjipJg32JidOzowd5bAUhUkVU3vo1h9a+A8S9t7RQ32qFfCxVWD
 cEG+zhi7
 LDyzeWiiZqiSIciQgLPb/ks3jHKdiVDhQPxtGYe4qlff8azCdl9Z9ccDzrO2jrH17oMxmL1gvvilkFkv4irXz2+cLviybyUOcWR5RGxzLQpabN9cLJpuTfJnXwglrtpL8xHwnKS74e0lDBQLFR8tQB1sJneN6sNpwN6vMMr2CEUPbSGjPhN8mf/ro/5kT4Bqtrww9nGwAb6rWNhfiAW4eT5k3Wp84XeEz2wLzDgjR9QK6a0t1KEyKPIBWu03PiAYwIvOyVKwTHE+DM998I50D5ROwYOPq1QDgcEzqVmr7xIkH6iY4uLH2js0sE6pMMHOVWq2RRyQ7UgUjxPQz1/xkH0J6O1WqC2qbUNQ9/wmEljC6qzE92h+CbGciLantBYes5CkX70on+X26Er/x0qw5IAb/RnD4VywbNOaRbM6RcKPDxU7ojDeoujR2BIdNFHlPlJMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 11:40:35AM +0300, Mike Rapoport wrote:
> > Ask again for up to two seconds, with the range held out of the daemon's
> > reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
> > back, so only the setup is affected.
> 
> "Retry several times for up to two seconds meanwhile holding the range
> out of the khugepaged reach. The collapse each case runs next restores
> MADV_NOHUGEPAGE, so only setup is affected"

Small correction: it restores `MADV_HUGEPAGE` -- `wait_for_scan()` sets
that before it waits. `MADV_NOHUGEPAGE` is what the setup puts down.

Ack, for other input.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

