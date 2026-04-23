Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971AFFDEE49
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9C56B0088; Thu, 23 Apr 2026 16:30:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99EB6B008A; Thu, 23 Apr 2026 16:30:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A046B008C; Thu, 23 Apr 2026 16:30:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 977FF6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:30:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1DA468BC19
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:30:33 +0000 (UTC)
X-FDA: 84690963546.01.140F407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B87F440010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:30:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OGpNXtGB;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekRumWJi2kU/9ig10cDmB11M9zG9idLtexgSQv2XT5Y=;
	b=wDY3BYaByJQPYj+y7rzBBU25qbAYRCv218SbHQWqIOmXfsSfbwHsQRV7/KjG5MdrXfFlfV
	B70A1GIw4x0OaGjhHU5AuZ4LhKX1ScHf1e/MnO1uoOwbNoMia+uIPZBgSaLTMrqEftM9sn
	LJnuz8tGE39rbpSb1A4RdoULL0EigE4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OGpNXtGB;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976230; a=rsa-sha256;
	cv=none;
	b=nmiLNyScibUiTUSTeIn0k2QqBQUdZXNl05njpIgtAa4Z1Y7K4R+pA+0TbDsCUczzPaBD6z
	KIDBB3DcycmVaRkxAk/m8JCFUWBjq+QQ1n8DlaQqX+pEXhaZX7ffsY3gF9uHi0nF6NxFRR
	F5REwJbW4KHL6SqaypTN3odbQ600T4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26B4142B23;
	Thu, 23 Apr 2026 20:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647A1C2BCAF;
	Thu, 23 Apr 2026 20:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776976229;
	bh=oCV9JFYj7k90WIS0590/2O8/cTgDcMiI0hAXUbdj4F4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OGpNXtGBm0ruwTxfn2i7ZXK2qzTVTfRRlgjZtDGJ1BJ+WMeCNqr5DeRM8NaZT4mHt
	 NPaiy4BrlDOIJzcF1E3mvczFs5rzBD3ZIk8+myZi0Tsxj0D7wrlksSBTSe+PYD26Ra
	 zeAKoN7VcqwQMJTj+YJNTFXrUsiZgTlBomWxL+bU=
Date: Thu, 23 Apr 2026 13:30:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-Id: <20260423133026.cbd3bc5429d4ca4eccdccda0@linux-foundation.org>
In-Reply-To: <20260419185750.260784-1-npache@redhat.com>
References: <20260419185750.260784-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pm649pj9pnz3ru5yxthbtbtwz5omk6uu
X-Rspamd-Queue-Id: B87F440010
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776976230-580972
X-HE-Meta: U2FsdGVkX1+J3TynTk/J6DCmiyDtHcuD+URLX87Tu7YUsDUbt0SGSqn0BjNIyx628cDM/C/g/dOpX7DkoKSxlj7xACUbLyn6dVogyi4UFrlu+nvRxkkFqe6r1Dvovwglz1NKykSsesSNL4Dzb/ThLyT0dsJEQ/MYy7MzOhySJ88pmVPDvbjVZaxvfBXI3rxCRAitfY4OYC4qci2F38C5fvg35hcku5zVFztcmmEkeUlHP8k2dgpk5idijL/EjzqXcALqA68zTvau3GU7dTiggHyvkF38bLpMZY6tkpph+NFSMvogY+4l3dHyDebY8jxaCDnMQe95hrsAYY1MJMez/Fi6IpXsN+o80RSrQMH5CM+tzXphyXgXHeVDmGutH0yD/pv413I8pVukaXTnQ66QlnUN+U8GqjZ+5PBjouQ6uKxqUc2u3jNor4fA2dFQkZIJKWna5szwaq4OLFAGTPSbL1DvoEhn5G0Y97GW1l/CsTLtXa7aNE3MiwkA2UpB8YB4JakZGO7/eKTkIHl4PI8l8+++HjGyfZPN5JM2NNYkNN3lsKIHTZjw2tXaEvt/7rBkvmRQQ8T0h/VZEreyZ66fzkA9hFqL8qTlPthL3tA74gfn6ZTeYPgwmnjpUfk6yuCNbDq8X/Jn8lVt2mG1t688fv7AKSXnHTzVDDHvcZufeN3QyxY+NhLWcu3C4RcNljgeoze5XdwzqJOWbx4lHUPRy6aYQvQStkrrCw/Ne+ElpHRBWI9j2tezRYNcQEXWdNkUFolxT9GazY6Aqrb7LQxqtC5ziKp7TfnbufxFDLzVZtqDUv/awRKwmmRGA0dVa8gU/jif4nqis499OvFOmb5fQBX28mB+FlxMOrdjOEs19e/KiFf24bTYoqH6mMTuN+NGySTfCD8VxDa9FjzeL5EV3rYVrhODR6zjwADY/aS65M9FxyyuOpgZp7dUFvTjNCFwVOE2cLKIhyxXapGpfe5
 +VI6Ubrs
 Qp7IS5g7DmFWTtG4bQ2qvjTsW4YMuNkiauBFJ4oQU574PwHxkDQi5mR3dpHwiDJv2lzuRwgEkrcNYabL0A6N7Zy1sSnKUVGaei0LK/fRRa3mnZqFpRW2hJuc0m1A+gFfc3btS6qesWF05+L1A6bqKRM8SS3fhaDMtNl2Wr/oQMizzZp+hMMXRtZJT5Rem2UW8ZBjP6h3orljxi16fP/2Qm0u89Kq1W8IMHUOH8aNmKm0lyDMytHlDYn46k7BCcOn5I329iWYW8s5z7I2l/UZFqzGOYtG+bcnSunEQsrF+lOc1SqQiEK3SjuV8HZBunsNhvfQbXlX4v3u8WDTSEfPBYS43Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 12:57:37 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.

Thanks, I added this to mm.git's mm-new branch for testing while review
is being completed.  I added notes regarding Usana's comments, so they
don't get lost.

