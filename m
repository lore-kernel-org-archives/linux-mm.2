Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB5ECCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 03:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8386B00A5; Sun, 18 Oct 2026 23:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4691D6B00FB; Sun, 18 Oct 2026 23:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380986B00FC; Sun, 18 Oct 2026 23:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 101876B00A5
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:15:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F6721C3D63
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:15:42 +0000 (UTC)
X-FDA: 85337910924.07.9927F9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ABA77A0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:15:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1p9YLpeT;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792379740;
	b=BogFzX7sSGnLEisvyMuqHu69Rlei9olxlozqhLAzs7JVFpYGjiO6tiIxNWajmSuldLOrm/
	dL8Ok/mXY4g+ZAHepYkmapXyfNlvwfpQ5GFfgAzl2suQmVIpsabTLtHDWhK5/o92weljrt
	N6VRaxkexwEo58l3z1UIeclGDjcuOt4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1p9YLpeT;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792379740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHRfflK+JeBKoM8boglU8kC3zJbIN9N75Z6QiHDkTXc=;
	b=qzi7LrnIrzgAfxLWO2IqylaTW+UNOos7SIwSSdilRHeuZymkacxbWXxpjZwqx78pdhEeMj
	/FBj8hyL28nx2NXyhxXdAa9xAdyL2JKPmsYTFGiy5B4uQ+NXMHhcbOILFEL645n5oJ9gcN
	eM/Y5z0uNkoTkyvY0GgO5RF/9q8J4Ck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7F7C43414;
	Mon, 19 Oct 2026 03:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121F71F000C4;
	Mon, 19 Oct 2026 03:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792379739;
	bh=kHRfflK+JeBKoM8boglU8kC3zJbIN9N75Z6QiHDkTXc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1p9YLpeTOebim74GzqQgO/JSYfD0qidsx549ARU1z3ZbUSWPp5tvwfqKiGJnIDrul
	 TzjrGDlGgmF9XVSIGdws19OVOpIvUYX3AM6z0MJzKf/NExsGf+n2LgCJnkBhoSmrgp
	 P+lheZzrelM0gZBfu14xN7Td5QGNFkzRv/PZTr+s=
Date: Sun, 18 Oct 2026 20:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 David Laight <david.laight.linux@gmail.com>, Rik van Riel
 <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org, Mike Rapoport
 <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato
 <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com,
 pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, Matt Fleming
 <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-Id: <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
In-Reply-To: <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
References: <aseMsMGpGPT/G548@pcnci.linuxbox.cz>
	<20261008182356.GBasffvDuTemTu1VUY@fat_crate.local>
	<20261009090042.39ba9c06@pumpkin>
	<aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
	<20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
	<20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
	<20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
	<20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
	<20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
	<atI_yuCc4BiweBQP@google.com>
	<atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: ABA77A0002
X-Stat-Signature: ixsh75uecc3ucgy8zoowea9c37hzw8z7
X-HE-Tag: 1792379740-261133
X-HE-Meta: U2FsdGVkX19XcvQPyCZH+3V8+z/bmdaI9MRkkkVV2twCyuFLprj5OzWT5lXMb/auWRZCkbeEHB4NFirS86ILRiSI4J3MPu1/Vgkl7EUflhm4Gl+ZovYfrkyLVT86Gd5JMnLBGmitgd8zjB7DZ69oeMp2T+Asp+3+Cuv4F0b7n8XXo5GZl8nMs12RJXV19vM/pkmX/QJoW71wLIsAiGZeZLYAknLTLgQFnGf0tTbS0dUh0kVgw0rU+9XB5IAeXQz43hFTKbqDtp+OEKK0uwwnOZ2kcGsTcwizZTiZaPrcX3LPyt7XjR8sfK3RINByy49TvmpoKgoez2rvY8bwHk3gMTxzvBeNLXVMd7n3eA1VfYTLxEjuVLrcsbQywEXtvbg55lUxI5h2N8sipfYRmeYAmhshSyGqWb/fHOVgRueqoXsj6DZEwKWjN5smK1robB7afvtJF/CGdrW+H9INAz/u4FPT2mR9a/qskQ6nY1v8lA5FBDZ2wraQc4MZMQI7b1gS0emDL/EBSAvvAKRpb+MhgAWPfw1GFOvaY/TgeRtg8KQFLbXbpA5ucaOicuq+GYg+iuen2+G6BMkLrX60xet0iyZvskMAvLSV9MpoDzJcI4VJmJkPkBdKKnS+iGxN0MPhiyJUEz9Yv/+JBWFHMh4k924ZoVv9amsnqcNo0ZHKxrjX+C742EqAJW+Fr/ESu6nl/t9gbS7kVNhO6rXJKO5nyyL7LV3lc1BMrK/yRKNViHzuBrmPnMhcgQzKMHkO6vx1XKgo9JoQnwue7GvcGgxSsB/01e7DfmmdD1cLsongby7Jn+lp87OMkMcIP6oXW9Q9qfd64sRIbtomz5LP6jhNhjCtfd5y5X7IQqPPrijnnic1qz0It58gvek8nfruDjUys1hEnLJoKtvMFMz4O+e7GN6ewnBXrhc3yB8YMtE8NCYvk0PmTfkS91REFvExunq1EIIts3l6Xm/+UaElIHh
 hysAfPDB
 fg3UW23qRjCNZJc3GbDrv6yNVd6upfHQ6tVQOOeRdArGB0R577xLuuWQHVjP6nfyFcudPBuxEcHEGJCGkh7LC+tT4uR6/LFBeABzALx48sa1Z5Ujn6SCVLUHBLuTj1TP49FkffadMLuDnqNW8xREEtGitT2hxyAloXEtJaV8RJr6vfZJgfeuQqyawpztSAHygBl+ha2qC73beOhivnv4fF+X2AaURi+NflokBN77BP2CeUHDmP0ItOPy7EWhKgjuyrXYOmpWVH6GSs+3fSyXxqbEhN98owxqECRLbUgtAQPlZY4bUXQGhiSTqjVc6ZKobausGh+eqv813sOVK+J0wzqz1b0Cncgone4BQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Oct 2026 18:52:29 +0200 Nikola Ciprich <nikola.ciprich@linuxbox.cz> wrote:

> 
> Hello Sean (and others),
> 
> I think I've finally found the (at least) one missing piece needed to reproduce
> this. At first I wasn't paying much attention to nested virtualization, because
>  we don't use it much (or so I thought), but I was still wondering why
>  why all of this seems to be tied to Windows guests. So I dug into advanced
> Windows security features and found out that newer Windows versions use
> something called Virtualization-Based Security (VBS), which relies on
> exactly that: SVM/VMX, i.e. nested virtualization. (I'm not a Windows guy,
> so excuse my ignorance here.)

Well we initially thought that nested virtualization was not involved.

It it indeed is in the picture then it might have been 55780d8a1dcc
which unknowingly fixed this.

Are you able to test that commit on the 6.18 kernel?


