Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 100C4CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EB56B008C; Wed,  3 Jun 2026 12:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF616B00B9; Wed,  3 Jun 2026 12:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC9D6B00BA; Wed,  3 Jun 2026 12:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 024816B00B9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:17:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 939571C04EF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:17:13 +0000 (UTC)
X-FDA: 84839105946.28.7A2B5C5
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf31.hostedemail.com (Postfix) with ESMTP id CFECB2000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:17:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780503431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JHIJ3Et2QqMNPNtyfeegjgis/iERCvZpcsDMwLnD5P8=;
	b=Gv8MQ5MlwGdj5yK6heTgzJkeVoZd6mO3+2pg5t2GBmDdNMVm6v6BzrJFUcZQyifrhUx54W
	wAKJac9BvxM5rVEfO2RnW20bHPFIeyuPk0T6ku2aa+QazE3jjS6ExYSit2VLoXWOHAHx6I
	ZsIxGdtOd8x5JkkLonHl5kUvqoRvjvA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780503431;
	b=3l7GVEN96W8hc1Oo/KNJ2wgR6hLVwzi4E5bQxK1iU4Q5LiG8M0IjcI54bLOCU/p+LJTocW
	rkLDzHqPVxxnOmomuJuFGKkkM45Zl2nscVVPjr49Y887S6VX141j06c+38+hTWWWzHc0A/
	fLrJHe284YRQemQX/FWmRsFECH7rGsc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	none
Received: from omf15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE67D4046F;
	Wed,  3 Jun 2026 16:17:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 1CB8C17;
	Wed,  3 Jun 2026 16:17:07 +0000 (UTC)
Date: Wed, 3 Jun 2026 12:17:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "mchehab+huawei@kernel.org"
 <mchehab+huawei@kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
 "bp@alien8.de" <bp@alien8.de>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>, "Lai, Yi1"
 <yi1.lai@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
 <linux-edac@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-ID: <20260603121707.7eccb9fb@gandalf.local.home>
In-Reply-To: <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
	<b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Y0GCOrJZJoVDEDn/Ri6LOhG4txmh7D10=
X-HE-Meta: U2FsdGVkX1+2ifXGDugSNwAKZybwNq+9PxgoHWGdVhxv/lrTyh8JwFDrTn44NWmCU5r4q4m5vzrOvnMvLqBnff4SfGmqK1pEw8YoKykgGzU0UXgxg+qdTzmvxBKIRUXUl6olCkZkYm0E8U39MQwDRuz5bcxEqKxx3Tvq8DawBVmTksaiy72WLoaQTS9SUwLIqM6axn8J4qsmuea1RyhKFGw/oPCw1L0h0f0wpU4/4tzhKquBYxQjOTXjC4eM2psgo6ndtw7HQIcO9M9zi4KcerpR4eI3IwucdL8nbC9MttmLSCpUg7S8QgQbVP331LPW0hIUKcIcspp62UblYaMBJbYj8wjZ5jLsko9MM8g3XSmyg4EQAC0r9Bqi5TC1UhULcPZA7eagucrrZPyz1XqPBoFX/Gp7EtlH//6Z6fG30vxTal6/brvBA5L4rMLU5liawh9IBc8CDCQw5Hvu0UL6sPctwCp1AlJyKfUvWfTVn0tiEuOfTjPK6n/cVYhFjg9c
X-Rspamd-Queue-Id: CFECB2000E
X-Rspam-User: 
X-HE-Tag-Orig: 1780503427-767641
X-Stat-Signature: m1j3gcyp1mpkyetc83i4g7zzaibuezti
X-Rspamd-Server: rspam08
X-HE-Tag: 1780503431-111887
X-HE-Meta: U2FsdGVkX18KFBufCKovzcPmRrPAA2s/gNmwh+nUat00i5542wN59cNPP74mgOsdm+qkqPrw0hXhoxpcKyzH89db2+YvQ8gp6cls2yZlgMYnKKAHY11PHReoa/Gd2qieJ4Swv5LtvjGINHGVMAIUICedgHusNzoMxzbsDZLVS2ew6KYx9j8+axOyVr9p+pIjF7mQXeoBj13Dcgq7tVcXhlXe1d1cTCUsrQio8+BRhMDx5qAT8NolaAj12++lV1L0c9XkKj/gwjil1NN28QQpaynh0USdP1y0OizcV+pmEDOw0V0eSB3kAlDVaIl3y67q/fyKZkvR4zGl2GHanBvJ1WIss6YvcwBijBcN+L9B81DRa2ERjTAJf6gr3CaaGhaNuE5POmryAEsRaoFZqNpq0NrrbTQ193g8KQe6yv9lmdDTucK4DZ05n/pEmUcretjbFVQxfGsEa4XX17AjiTJGXcXjHG53/QvfSlc+dBr4Z6ux5l1+P0JTAshbDayfPoTIrLvz1U0ianl3tXN5zbwdU3f0i67tVv6AFCVb/d5r4q4mVV4RBW23iLR6t7zkSGyvrtxezqGR66IauOt8eGo+DNQIR0tY7Ounwuz62aBnRnGGe+dy92lorptwi6YhC2E6VtwAB+9r+neeQzANdvEn1GN8f7cBNrJua6gtmg58qps+QdxbuTYxzIj02cVToIFsfM1lnVCqGn6yZENZFUbvHiCFA5ZGAluhFLasMPTSeuyvDYHXdm0o9gxpufnWgBNH4lakfOzkm9bdWb4Bd6+rhtb9a1Mhu+o1T4JneLEhqsvcbtZu6Zt9SZM02UWQvlAPBiZc/0ERyqA6hw2TgVV7WWc5TIIHQhASbUImJbpEbaDfkHjocXnQ0mqAhLTz8kljOPTHDQq5iQGV1bILq/Bbcsu5L6m1cqqk+H9g70vy0q78pINbahEXqB7CI3W2V6j8zL/yu2iUxTqyXsAv8+7
 MZMIJiA7
 ZfzPv5qPFp4f/IxLwuRaRkFRiE/jLZ6CPCM1pM6Ggl6pPED94NQu+U7lhbF1QsJc81yYTNr9jOwySoVn1rMNEiPwGdB1yagPVad2YboZd+jl6Dm5NMp1p+vXRn5OR+cgpWymnTVp+bqjDRPRm8Kc4ranK9hPQ/MtbxJDDDWADadeciUfzPi1RZq0qUQhoPxfhw04mpKynXeAU3FWBaDZHwwlyiGlc+YYDkfpsQxBJgTAG+uf+WapARebgcdiKaGQeT+szpv/ItIgw3+YHVRFIuUVc9YoZ2dKoGGoiwK/wxkPbgeJq+HObIFAKLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 15:44:54 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Likely the latter. BPF [1] documents:
> 
> Q: Are tracepoints part of the stable ABI?
> A: NO. Tracepoints are tied to internal implementation details hence they are
> subject to change and can break with newer kernels. BPF programs need to change
> accordingly when this happens.
> 
> The Kernel ABI document explicitly doesn't list them AFAIKS.
> 
> There were previous discussions on the stability of tracepints [2], I don't know
> what changed in the meantime. CCing Steve
> 
> [1] https://www.kernel.org/doc/html/latest/bpf/bpf_design_QA.html
> [2] https://lwn.net/Articles/747256/
> [3] https://www.kernel.org/doc/html/latest/admin-guide/abi.html

Tracepoints are not stable or BPF programs only. But other applications
they are[1].

Adding Linus as he's the Supreme Judge on the matter.

-- Steve

[1] https://lwn.net/Articles/442113/

