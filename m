Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD69CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 11:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD4B6B0088; Fri,  2 Oct 2026 07:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E5A6B008A; Fri,  2 Oct 2026 07:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA44C6B008C; Fri,  2 Oct 2026 07:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF6B56B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 07:53:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7C4EA6F83
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:53:41 +0000 (UTC)
X-FDA: 85277526642.29.378E367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 264EAC0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 11:53:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrjaOiT0;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790942020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmxZmAkX7sFWhZEhSwoTFCk9Ly0sqzCLy0ifziPCklE=;
	b=QOlQx6KugIeeIq8IFDlLA6m4d7m7BW2vBDuNkIerxYXeWx3D+HqTNWQHlwnJyVwvanepZr
	SEKlJeoiBBjJpwFt+wpkdotkguGlgLmA5b70TDVHEDXrqvrPNlXswrJxY49L9hUAbuUVfp
	BU/3Gq30OFgWtDq8BvkM7UkJeS2FX9o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790942020;
	b=d88Io/QnfKuir8xLLSOgNmQbgvjbGJgLcZddxXAVVEIkuemf7y5WT+itwA46OQHPz0IUET
	DAVIMzng3IOYCOy+MZWSbZ4cl56m5M8fQS3AiMu9u0L1sMfvtQBLSmjuUYq8PRcb8iu8PY
	eU+Kt3foxNuLrlNNQahG215FeglcGfs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LrjaOiT0;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BD5240093;
	Fri,  2 Oct 2026 11:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51911F000FF;
	Fri,  2 Oct 2026 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790942019;
	bh=JmxZmAkX7sFWhZEhSwoTFCk9Ly0sqzCLy0ifziPCklE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LrjaOiT0/kgKG5xJcHuIQQl96aDNH27jEWYo6/eukxIaqQwYL0Yi2fb+zu/vFRBId
	 DV/PZj2ePkgKFhE9/F4nvTYUADBF7H7T9RJOwDn3NIgMGlyMKcDuTAtoTIIkUsgDb6
	 x1URYwePs3Vebu4nOuyyzGzHW5Vn2MCe8aXxTi+YGMS6b0csgZWtq74p7c08jB9xPQ
	 ZpKgg9fwiync7utyBiMm2bPjVpvUOrU7S6mG7pstrUJvNj/jPcuRO+yDhhTGtADvXL
	 1IZ7ntsJFFvW9x/WXyQUNm7oAqTFgJ+zZzw2Hn0ou+zpclpaPwQJ68poxNuVNU2M6q
	 o+8PkQiPxtQUA==
Date: Fri, 2 Oct 2026 12:53:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Hajime Tazaki <thehajime@gmail.com>, johannes@sipsolutions.net, linux-mm@kvack.org, 
	liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, luto@amacapital.net, 
	brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, 
	broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
Message-ID: <ar-bIzYDdlOKUqla@gremlin>
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
 <ar4br2vW7yZGd3gt@gremlin>
 <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
 <m2se2o3jyc.wl-thehajime@gmail.com>
 <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
 <ar9ldn036SgT-bq1@gremlin>
 <CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUKcUxHZKhTEF1gwWrU1o8O6jt6N3r90V5hynrLFdwY0A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 264EAC0006
X-Stat-Signature: 6ahqonkgkw1sewgdu893y99o119roq9w
X-HE-Tag: 1790942020-55667
X-HE-Meta: U2FsdGVkX1+qUMiTs/oSCN7nDuckErCg13xLK2bV6oP6SIetDfiMmVVGq5dOypHFlfr3mVPmuQK0+FqYXn+BVNmHcsx4yrOJzByEMRJsfct3vNFt1mXSyco6hHV9J/y83IOQCg/gOZQ4MElxVoG3UY+Xdqt9LdQc6YYoCeKoF/sJI2TBKyXLdaPyxAoL5aV8z/g+bfcfjBFgQEmoSXTiIWnr1/CQbuL295NH3kLTLUOG1X7r0wQPhH9jT1iW8qiWQo9IXwN25BtsI0CUdTe2JB5XP0Tuo3fCyn4Jfm9vJzfVQggVKZWAxOncfXMJgyKQFWWoOu6dU3x3YqbzzLjPjWcBXfUT6kJK5lK0jydvonX4dnzLd5C2crZWR3BNAP8I9h0LQzTt42xxMeooGGECzDDBwquXkVaSGlcfz7kb2f0YV5CLIwhWou/Xrvq/IZiSJnW+VKE7VUqYeg6x0T/ZaB1gqRS4vass8Vf2aRlW5mE4sioGGT7/92e8bG5R5EpNLOj9/OpAqDRR3GY+LdjIinZ7wF56KK2BofPLgxb6l+WF1NFYVnAlPd4zAeo7/5/eqSMkJuVeiFUkdHBVinZ+AtJTIg+4S0og4+mSwcBMjWUKvy3IbUKEaW9Dhl1CF6OYenV4bjVcTdU3urO80YjV1/bmfOx+hVvRD1zeJzcWvS3wpiuQiczH/oQklm82VtD+5FB8jx5kKKtR4HnNqi78aOV+sResqRGKZ0XuN/DUkgo+0SPFnkMEWaEwssVE8lLgBSgpy+Eg4RbxEGGzW9s6zqxwYkBqZKg4cOY+pqj+SMPiHNW+MQapZwoA9FriVYUmuojd0enikBpVJ9G/A9B6BRk0WYdjbbpoLJHBfPvL4QC32+RmLkYaoKO4sfwSK09pJrocoxdsmACnjcYOKzdF2Qqi5qxy3xtSLbN09JKXayX0DuWJM3PnaqvDjKQy03aAPTdLVXG6AGfyyNNOXzr
 gdSyu22a
 hEacOmevecr2QyDEXkZ0z3dN7U80okcYDQgztTrC/1ztMPoxqZEE0H1cZ10mBfZ0o+pVSOJKkd+7vIQK2nGoU5jbz0tUSZJB10IuHF1cbQ0iGB5LCDmsBFYLFbIx+A07cOn5R1mJmgbhuWb7u+cjcWqlCACmo7Su9ht2BM/AbhFQr8WMjkwJTQrCB+jP9d//l65t05owk43/66gbNPeQ4+UDfgsboX6K2rKu9FoCJWIxc4bl9y5Xag7VaHFPL9dAm971kSSw/uGgIdotVwzfaBvN40w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 01:38:31PM +0200, Geert Uytterhoeven wrote:

> On Fri, 2 Oct 2026 at 10:10, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:

> > But fork() -> -EINVAL or -ENOSYS = nommu, then just have the child quit and
> > etc. should do it.
>
> fork() is not strictly an MMU-feature (you can implement fork on nommu
> if all memory accesses are done relative to a base address register),
> while I think mprotect() is an MMU-feature. Unless it can also be used
> to change the protection using the one or two BARs most MCU haves?
> Anything else that is a real MMU-feature? Non-identity mmap()?

Does any nommu arch implement fork() in linux?

--
Cheers, Lorenzo

