Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F68DD111A8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 20:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675B76B0007; Sun, 30 Nov 2025 15:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627166B0008; Sun, 30 Nov 2025 15:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CE36B000A; Sun, 30 Nov 2025 15:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 441746B0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:31:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9A4E1A0D2E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:31:11 +0000 (UTC)
X-FDA: 84168417942.01.44AE506
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id DFA5D4000F
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 20:31:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bCdapMnY;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764534670;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzGIbtyf4uypqKnERTUX+BxAGcXLaiND7k9n/IPFZIk=;
	b=UU92bmLt1XJlEWHU6aidzCZLUU3Jc7alVujtPXk3q13wWzOVsyLIY0lgobTfmVCstwqa5q
	abxOMUMQRst8rkgQaPC2ZYocvU1AOKkQwu5WwFHCin5eiZFfxLZS8C8DalI8oCDmPSBmbv
	vcUofD74ijINQcJG6KORx/ohVK7QxsA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bCdapMnY;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764534670; a=rsa-sha256;
	cv=none;
	b=BlLX96ita+gB8N7z8bLr+mrxcQ3SXoZCi73mD9eKH3ukGLcUSK56tuX7FQuMEripyPdhqg
	+Uzv+VBZXGSUdQWAB4o/JFYbKHatgVCTb1xkqVtZJXXQU4mk4EEt99ggQ3ij+nTrNno/6c
	J6IZhW/SJutJ+DRxNL34c8trQEwvRvc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PzGIbtyf4uypqKnERTUX+BxAGcXLaiND7k9n/IPFZIk=; b=bCdapMnYT5uevbv4N0JalnY/Dt
	6jOLcg+QfJj6cOpH8DdtSQpY3KWu9OyjzGVEf4f0QiOauvmo8dRZOmQ14zLlAjuGoYhY4z7ovKsd3
	guBykyMIIqW9XVb/5/OxhdpEqc/2WEV3HuvV4/q8tqRX+ilxweQEpFr26czhzABAHHOBL+QL98Sjs
	H0JpKxUi16TotiVWYyjyHqoIfr8H2fWw4GcsiFx7ZUiMFYa7kQ/muhLXbVeI/J6w3AI/qEu5rj46K
	+Szxejg03Z+8MYhnTD/jpCzhmjxu5qmwApZhsSze41DmZWWFsZo9xRSnTwUyuGBPHWjITZaXjbSI2
	FivLok6Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vPo4k-0000000F1yA-2jlj;
	Sun, 30 Nov 2025 20:31:18 +0000
Date: Sun, 30 Nov 2025 20:31:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: david laight <david.laight@runbox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-alpha@vger.kernel.org
Subject: Re: [RFC][alpha] saner vmalloc handling (was Re: [Bug report]
 hash_name() may cross page boundary and trigger sleep in RCU context)
Message-ID: <20251130203118.GW3538@ZenIV>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <20251126185545.GC3538@ZenIV>
 <c375dd22-8b46-404b-b0c2-815dbd4c5ec8@huaweicloud.com>
 <20251129033728.GH3538@ZenIV>
 <20251130030146.GN3538@ZenIV>
 <20251130113213.40c8e7a0@pumpkin>
 <20251130164348.GV3538@ZenIV>
 <20251130190331.40385ddc@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130190331.40385ddc@pumpkin>
X-Rspamd-Queue-Id: DFA5D4000F
X-Rspamd-Server: rspam02
X-Stat-Signature: 7mukcjz9orzzyagai73gx1ewrrw5gfyj
X-Rspam-User: 
X-HE-Tag: 1764534669-708591
X-HE-Meta: U2FsdGVkX1/SVIw5+ZimlR96iBz7wb5onnhl1fEOfNb4PZgksrMixsBkS+Bju4ju/Zzsxy34U+jA5YwE03bwTRDGEel+k7xe5ZMAaQCRZOFFqiVe7npssJU5o4o2EXzv/r1tCFegM9wgOcIX1mXpt2jsLk/uZFYn7ZO0f3onlNLRx9ghfpesLis6bDZzK92Vhty6+mfE14vX6R2Ex1ftVukLWe3nIBBFSFHxaPjVk6bSWJSCVghKYYdVWe00oWuAwoiRQrhwkNuT7ePtTAlIfRC2DDLAGfCpfypJU837fMoiNLzxZ5RvdM1XuQbuc5B9zt4bwhTJPNFpRDqQuNwC3ssL/r6aXY+notxObT0xEGEB6oo21xcq1I21dPFqix2om/RqMJ49OUSOtS1XeTWdCfpgc8l+xLaDqdhB9PryttUcZeNnAr98d9rXlJQxz0gDz1TjjAXvxAVXn3u8/H0hb/A7VvtpPk76rxQSuUavaTubRHshe9FkBBmavdwz7lRJ7EPGEeLFMTgbOnPODkhgoXlAQeTGkhySw1jbgRx+SY+icW6TnF37hVdluN0XfWmdcAv7LJu2SHAzPD7HcjAAbEdXl6YkPnboQEjmI75gN8Je+CxvaMCtz4dvm7nwiEkGZfgw97ojpnYOft6BNz+b9DoNOQH0thjkE8d2lJCL7fOtlCAY+PE7GVgKORDsYiDMhMxxiw0cjrDF8vE4FqFlq22xR3Qf0m9UvvIiviwD8Zvqwr43MtdmFpm+16oILvhfckh84bNRHK/OqtTyFxY+uZggc9KRJvoBiEpYhsIa5nsPGcfyCPElZoi8Z84yDdl41q16BI9l9mpUgdbF2D6UqHlzE3Xq3fLh+mrgJKSqin3cZCt786iS1D2XalPk2G+2ahb6bWntkCdBXIclo8Mmb0JzgC4mKdA2Uwofhi1hKi1dyRBDhikDn7smH7LY1muiLvRyyNMtozlrPKv2ZmL
 P4bgbZba
 VygnKu6sPHRUFlSSeB/P8kMKOPd895uX3SlyIuXZOODtbubmqzZcpWUsXED2awplj0xnrE26TgecRWGJX8Ha7W5+5J1D3LnEaB4J1It+buLm6gmfkD/y3ZGWIyurG6BZD9NcWDwtAhraglgMvRYQJzZTiGU6a/HMIQRMBWq2Hwl7EhwlqdmJDGJddOOSX6Q0lFv0kCIBDnVikuQqyalRQ8ntMFTmuXxKQ/vwTmK9TR3BGQyNaNq4Yh5nb+lVFFGh2N9oEFCXy99dDAmw/OV2nvvkiogDS7EUBtT4LCIXk6IZ1AtPwMeeMFBVMnHmmSy1DemNnBIbyBxKODMcOW0YKuP8MNU6N/wLZKW224lkgN4vwMGyFsE/aU20tMBevEhKlS0KvGdR5kUuV1bvc4pg7EvmV0q6V9l09+0sLO5gKwV8PtF4ZHg/66cnVUplrkUpi/n2FYCH92nUJmlSH0ad5cXjhI1FA790qiQH99Uno6yYQcZM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 30, 2025 at 07:03:31PM +0000, david laight wrote:

> (Doing the updates in the page fault handler definitely sounds like a recipe
> for disaster.)

See the comments in arch/x86/mm/fault.c regarding the need to do it in
#PF on i386.  Basically, you have

CPU1: does vmalloc(), needs to grab a new slot in top-level table.
Updates the page table tree for init_mm (rooted at swapper_pg_dir).
Starts propagating that change to other threads.

CPU2: does vmalloc(), which grabs another address in the range
covered by the same slot.  It works with the same page table tree,
so it sees that slot already occupied, inserts a new page reference
into the page table hanging off it.  No top-level changes to
propagate, so it returns the address it has grabbed to the caller.

CPU2: caller of vmalloc() dereferences the returned object.
If propagation from CPU1 has not reached the top-level page table
CPU2 is using, the top-level slot is empty and MMU of CPU2 raises
#PF.

BTW, it might be possible for two parallel allocations to grab two
areas, each requiring grabbing its own top-level slot ;-/
It certainly can happen on x86 - two vmalloc(SZ_4M) in parallel
will do just that, but with NUMA you can get it 64bit boxen
as well.

So simple generation count on root page table won't solve it either...

