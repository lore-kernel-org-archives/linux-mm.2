Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F60BC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8216B008C; Mon, 24 Aug 2026 11:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9687F6B0092; Mon, 24 Aug 2026 11:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8589B6B0099; Mon, 24 Aug 2026 11:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6386B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:51:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0953A140198
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:51:45 +0000 (UTC)
X-FDA: 85136603370.28.56124A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5F8E8C000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:51:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KLYHtqIZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787586703;
	b=MYKowQBR8iA/aEEbWDV4eCyWVDpVqS8B34cI2yWSOsT055/xOZ+6yLpvxw8/Sc1MJxDHyz
	t8SmJ/heIu3pvenZBV8z5AWzI+nhQB2EBol7UrMTqA75d3IMuTshD5f3poOvpPGILAsYwO
	kG0vQUj7n5jMZKWzrxw6+AdZJgOh88Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KLYHtqIZ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787586703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBZXZg8XyazabFSG7+jXaRU5eW4xxTYW1kiZhb3p5oE=;
	b=MKLwgifHgHxBVeCnuIr3eODslan9aRniqzTGf60SvZjzcPGFx0E/UzgXcW6/cJyIi0eZVz
	hSTMmpvewA0hzcP9Os1Gh5Hb8nGXnYSmQ+mSiK2D3J+lhoxHxnZjD25RE/ylKIIw9p3YId
	Lf+/d3taO0JxkjSDXIbeyseBcjzxGFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D099F6013A;
	Mon, 24 Aug 2026 15:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8811C1F000E9;
	Mon, 24 Aug 2026 15:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787586702;
	bh=WBZXZg8XyazabFSG7+jXaRU5eW4xxTYW1kiZhb3p5oE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KLYHtqIZxdRIYDXtaaqoX2/ljO5lG1Zu82Dntr1fIhjL54cQHCrwzOvN64gRGjOuC
	 3ZIlfGOd5o3DVRNyAkTakRpY3nbAUmsMcYEEn+qkj5lN+4OWRBBDGT9AHlHCfRQkFU
	 ZtnAJyeea4W2kqfjiGYx2phf9OGh/d426eLtjbOmhKN1SAiUTgiYqPEjZZYv4OWotC
	 id/QWoppDuGm61CNaVlvELeeCZbK+Zl5nLR29120diREBBX/z5HGoSgDCIPcLoJb5E
	 Ouxv+7gB76sATufgD0OghTTuJgJ4oe4nZZfYPfa3BVdGv8nflOtvujgNNeJwteZmme
	 Avdmoq7P7PFIQ==
Date: Mon, 24 Aug 2026 16:51:35 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aoxnmhXB1w1UoPpu@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
 <aow0Z6mrG2esKpRZ@thinkstation>
 <e1c8c6f5-1b5a-4cad-a52a-f7eff00997c3@kernel.org>
 <aow6J1i2G7U0spjH@thinkstation>
 <aoxPzKTVRmZgmBKg@gremlin>
 <aoxe92BxF-5xaScD@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoxe92BxF-5xaScD@thinkstation>
X-Rspamd-Queue-Id: 5F8E8C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8dgg8xfihbh5tnhmgfnf18ccoyymn717
X-HE-Tag: 1787586703-893967
X-HE-Meta: U2FsdGVkX1+JjH6FVN+uG0LWF5iynm8cUPKvdDQNac5D8sh4VX0FRHKteFT0c8ri1XPDaM/Yj5LqdQSsfO+8y3W3UeO2kqKltE4cQ2ari9bivwMFoeG/s7p/eTil8nfkPmhdj9xpcJ9+pi0vBfU/7h46gZ+QkHdKNJ3wEwdtxE7PzRGJnnESERgj9wLn6KftP164K3x2VzT7ExDbkwUcbe76Viho94mQY7xaWoE/XFAD/UDBw9Y/LfJYV24mhkF3csPW7qV3XeqVGLub4WcY6E6CCwVE6pzvdbY5R/OuPn8oChz79fb672zx380VKwiqG3l0tnVjAlqrw8nFsjt7DWIBnouEO8w4BPB0mjmBD1pr5SqJjT3cRyYdkLVGQAKiox35jfcUAhhSqVXCV5XfBrP6NMIXdP08bMD05vstZQWy+4K7f7S//oAtjku0PtyoeNc2lq1PqMrSskFpDtUSQcvDEGzXqe+dW+tS+NcXUMFQgMYtw+ZrQEOF+BsAYGdiutGZ1Ex8OY95X0QZKKONdW2U8/SduDyQ2sgnPRTpCc6nMyJuVAXlFE7Fkn77mZcqCeQymHDV0yYWPYJrBqHFuAq7GA5YGHQANblFmBw25iB83wlx2+pXD3hVcyQKb1355sTivcyN/+TWOR16/J70OkghgLv9/rjc7fJybThDNzaUraH5eZBxDIXXECAu45mbx6Jj0RlK5GyV64jiV4QbCzjQU3A4STv7/58dMwjoUiSu340HSMvqbtvg6KiHNZBi3s5FnnaXs8ZoyUFDmsAeP3jSkZHsDEYoIelWtnK65wmfcwAZUvUIb+uOYaXnpvJrw8pBtHSXleGDHpHmh+65nd6omN6hnGcnh4OWVjxKxyucNxtdhU4Q4hRMC7b3T5rsthWQ5bw0J+Fuk5O6dWU6JepKKz08OIQPTrsgcNzhsHugHMjPYb9ITSuppKN6ttZM87HziRQyC8uL6M7P2J4
 kvGCWtbf
 6ILIdpPKTwi20BJz3Hg4CsY+wGUqu7P48YMtQHB+qYBGTRp1u0NQ6EsJV8/+MoVh4tWzCSkU+4SI8o0ExdW3VVHrtHBCgW6sbU46fpZCQg1Tib7Z3I7qD3w7rBJGJxdt4eKAAVc6rKASbkR/UNMsTs57x/01cfme6hUZyNDcnVCo/kseC8fmBKEmDh3CTj4/CQbQIfSWdnBkDH9fAbhH166PKNzP1phEy0ji1rWvioBizlPNiyDPZgtf6O3XpZ+35EdFa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 04:18:09PM +0100, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 03:09:00PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Aug 24, 2026 at 01:36:03PM +0100, Kiryl Shutsemau wrote:
> > > On Mon, Aug 24, 2026 at 02:28:39PM +0200, David Hildenbrand (Arm) wrote:
> > > > On 8/24/26 14:10, Kiryl Shutsemau wrote:
> > > > > On Mon, Aug 24, 2026 at 01:47:54PM +0200, David Hildenbrand (Arm) wrote:
> > > > >> On 8/20/26 13:11, Kiryl Shutsemau wrote:
> > > > >>>
> > > > >>> I went for a clean collapse.c on purpose: the engine is new code, and a
> > > > >>> new file keeps it readable while both mechanisms are in the tree, with 28
> > > > >>> as a plain delete from khugepaged.c.
> > > > >>>
> > > > >>> Your shape is less churn, though, and it keeps blame: 29-35 move about
> > > > >>> 1700 lines as add-and-delete today, and most of that would stay put, with
> > > > >>> only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
> > > > >>> khugepaged.c.
> > > > >>>
> > > > >>> If you prefer it that way, I can give it a try for v2.
> >
> > Please don't respin this as a 57 patch series.
>
> I didn't plan to.
>
> The goal of this RFC was to show the final form I want to reach.
>
> I will move cleanups and refactoring to the front of the patchset and
> submit in small self-contained chunks while keeping the rest working in
> a private branch.

Sorry missed this bit - great, that works for me obviously!

--
Cheers, Lorenzo

