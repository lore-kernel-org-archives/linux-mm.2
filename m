Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479E8CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5BA8E00CF; Mon,  3 Nov 2025 19:20:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7965A8E0058; Mon,  3 Nov 2025 19:20:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5088E00CF; Mon,  3 Nov 2025 19:20:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D52A8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:20:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01C6BB8B85
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:20:24 +0000 (UTC)
X-FDA: 84071018010.04.04B4104
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3CE7E180011
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:20:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kxfHdtZn;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762215623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kg4LF7rkE/bXl9iieD20/QFbOQMW7syaEp2SBV98U9g=;
	b=7aLEPs5hrMkOl5JnpUKU/wPgG6Y9Zfn0uj1gr5kg+Y+bMJL4QqwmI+VVtHmlEh+tF2lBAu
	D2m4HnlHLbiqFL1YbENtORn9PAOOksgjTe/3KOQUm6EdFdUqkyWcVEu+qPmJQcrdntVJO+
	4IbZ93oKgbq/SKLTOFZq7I/Kbs2c0vo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762215623; a=rsa-sha256;
	cv=none;
	b=2jKvO7rm1rICaLPJ2pQoPaRIRKyUxM8mju0zE08CARv0vyre2D9Uy1u2N2k484zJ0cwew+
	0zu51oTHUp/6JP671lXcsXIpCP0SD1sB7o8qtBi0OEqXbflbs/COT7IYTEdjTcQhQf+T7c
	8LDkKZ1AMkWkDD3SMtll0Rh0IVsdJX0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kxfHdtZn;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D435F44455;
	Tue,  4 Nov 2025 00:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE24C19425;
	Tue,  4 Nov 2025 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762215621;
	bh=ARYJ94hkfr+wqtaTaCXJsG3Gdo7c5EgIBjp/zMCYw74=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kxfHdtZnLR8DJe75xj8jde8hiIdLJsDODUzrkcsU3oth4EmoafaP9q1vIet2FrDF7
	 Vif5lE2/OP4CwnUL/MCo+HJX3LicBWecGw1rfvdMKv85ziXudJQm5eF/OZ1UJX5vzy
	 P0Le76leURiT1Nbr40lIbqF1bECoQ5dIJm3nBBJ0=
Date: Mon, 3 Nov 2025 16:20:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>, Mike
 Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kho: misc fixes
Message-Id: <20251103162020.ac696dbc695f9341e7a267f7@linux-foundation.org>
In-Reply-To: <20251103180235.71409-1-pratyush@kernel.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3CE7E180011
X-Stat-Signature: 566uh11meftxef7da5mo95mht7oayji1
X-Rspam-User: 
X-HE-Tag: 1762215623-950701
X-HE-Meta: U2FsdGVkX18L+lyrASU4G3Y5TKsI+TBw4HB0H6WVt4dyQy0NmvqNKuNj2ePDUK0Lv50jVOQQ21yMV6EExVBWBfMwBSNBjK7Ux+FMgV9nA38JKMCrvtw8EHkAsIonyURDo/5yWnFWxCRpFW6sn1bDcUQP8bpJDfJCTugs0Oh54nOt4AyvuzX5zXNk5vL46pqKRSEYO805k8hX0ku+bSr1CA6klzyQfTF29gu/B4S9OKOZzmUfudCVOFUOrJuZLEWLMbgC9x9ZV8O468oQP6njLE3ot/G28PIEc301Yl7GY6njrIcqMZuivDX/s2vTBDLKBA3N6uUqU5bcROgAGEXN5cmBMAdIHsbEqT5IeNSgAJA3XcwWNqQntmz9Vu/0YQfXfp0v7NyXsjJSAevT1ogH5micA6L0QrSUfDHVDoCr1ERL9uxopu5z9swQy/rvhOKF8284oKW0HXIN8ewqyFH26+D8/Vp7axzy2wdYlycYJhWA6l1DPhaHZthRo4+6mgyjIE5aG1h06l5Qwm2bjoFnkrtMnvo7cV+Sz30Pj3sXbK8OCfF91c7jIcjxxDD/FXeR0K3LcGbb7j83FBSJAbvtk3NILMiudKUu9g19fvpaB8BEFaK7G3716XFlL/zQSOdQQpvekbtw68EnypQwNKa8pxFz1z6+Jq3a3tp9RDH6Wf2P0gt9QeI2911UiukZjqNhZ5iGe61u2M1rtyIIdq8acOUBRVAkiksPA276C5lLNpGjz880IEDSiTMQRlIuKneUjhpnnn9aFczKTal/srn32AM2MF8a8ywMtqLvqAPaeHb/OE/iQZi1Mo9tmgJC6wB+MQTK24Ka5Eq+usFgZI3wLPxw7fHfX1seN7st0RUNyvpzqW4hVdL3TMDV2xxnJMruSq+yokSCOdN9SbsV9ereM0VbAqvmHzEyI1YbwH3DfspKglFLJVue3vQ2Ubr/W+xyjY0wlsJw2KPb2xFupGT
 ojUqN/H7
 10cXKdONlt+1LIYEdR9Bxv8rCYge2dxOay2vp/E2L77iHzjCcLBkQjkwUalAIGout7O0BeXPe++YTzhHHhLJRuX4+G/X24f4yEruXs8lhkhcyePejhps1TMShZhmS2EpxhPmeXCLAM/CyYxyS8TVEcp/M3N7t4jqnAc87jiPhqV37v9OGZjZNkKj0PvYe0AjwhqQkgryfiUKgnLw6vw8qStclPxSseHQDYSyI1EBMp6cpC1UGMohdnOdGmYRvLjZCHA03rEZArgN7/+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Nov 2025 19:02:30 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:

> This series has a couple of misc fixes for KHO I discovered during code
> review and testing.
> 
> The series is based on top of [0] which has another fix for the function
> touched by patch 1. I spotted these two after sending the patch. If that
> one needs a reroll, I can combine the three into a series.
>

Things appear to be misordered here.

[1/2] "kho: fix unpreservation of higher-order vmalloc preservations"
	fixes a667300bd53f2, so it's wanted in 6.18-rcX

[2/2] "kho: warn and exit when unpreserved page wasn't preserved"
	fixes fc33e4b44b271, so it's wanted in 6.16+

So can we please have [2/2] as a standalone fix against latest -linus,
with a cc:stable?

And then [1/2] as a standalone fix against latest -linus without a
cc:stable.


Once I have those merged up we can then take a look at what to do about
the 6.19 material which is presently queued in mm-unstable.

Thanks.

