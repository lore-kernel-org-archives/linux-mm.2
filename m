Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C78CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DCA6B00D7; Thu, 21 Aug 2025 12:54:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5BB6B00D8; Thu, 21 Aug 2025 12:54:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932546B00D9; Thu, 21 Aug 2025 12:54:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4E46B00D7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:54:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 295E1117C81
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:54:58 +0000 (UTC)
X-FDA: 83801364276.12.A2F4E51
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 688E3140002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:54:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755795296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bqbFSeag5rsbNDhSYotEQkQKqGJ8k60o0/WUvEhP/fs=;
	b=bj6xQuGcXzESoJhly16V5SYHVe49VKRTZ2ofXbIFB9UHyDwoj3l5vO+AqImwbWpAbvGfHK
	SHZXm3c0v27MIAxVeOJ3aeXOnKwBnauyA0rmi6KP0WAQcs4uUjxJ7zCgu3x51Eq2lxFNu4
	WXkTWiNFyD5TWE4mKexlcLcyAokMcOk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755795296; a=rsa-sha256;
	cv=none;
	b=AbkruYcNOcup/2TopKywy0+cMrkChYXio2b452cgwKz6JfaMCVRseWddhgSwOHjZRJRiH8
	GbfGMFvaEpGtkj/fbXpgT3Od7P8gn6tMyLgdC/uoCXtFC2D2+FfkUPvjakE85bDwGKhqFv
	9DtkvhL+CMF9U1XucQsmRwMmLS3PLQY=
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06922C0485;
	Thu, 21 Aug 2025 16:54:51 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 40E0120018;
	Thu, 21 Aug 2025 16:54:41 +0000 (UTC)
Date: Thu, 21 Aug 2025 12:54:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 07/13] khugepaged: skip collapsing mTHP to smaller
 orders
Message-ID: <20250821125445.5fb61e90@gandalf.local.home>
In-Reply-To: <b6ebe641-0a0b-40b2-a34b-07393f883985@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
	<20250819134205.622806-8-npache@redhat.com>
	<b6ebe641-0a0b-40b2-a34b-07393f883985@lucifer.local>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/b6eVfnCtrADYpbZkvhr6irAR8DA0EUBs=
X-HE-Meta: U2FsdGVkX19Wf7TImvNRKkdHzzdV7rkvIZhG+KmuYqaxLydUul5FOaS3X4td4dGtT9hZEXmh4L+Dk8si1hh/hVBWR74FiuUmhfbXmOOdNsDbKjyxYi57fiY6knL4h00MpaMfUIRDYdx3ziQrdIsPCvPgRRHrclGadS48nN02wTZ6PBrjY2LCI4Cx6XQvgzeBaGI9oL4ltMiwZnPR2Yi0mXZPr7egX1qPLgUYcMX9zTYFyPwQ7S8+0OCclKm2BNIeOnyiIs/374my40vMRvHjeexxt6cc3ZwRILylZC8aFqZhZnXFnIGB5uFwg43P3fQzfHePcSZ5aET9TTEaSV2JJ2QzqHIoYI0P
X-HE-Tag-Orig: 1755795281-660595
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 688E3140002
X-Stat-Signature: qibcagcc111tgj47qy51jo96stw8z185
X-Rspam-User: 
X-HE-Tag: 1755795296-414539
X-HE-Meta: U2FsdGVkX182PbpqGWc8RHS0/Lq1Pml5Lme7tIrTvS8ZPsuBpnHFgkneb3fssD+giln+c/8tVT7pALyYmMp0j9b1kWLqUopwJqfkOfvSjyWvPlw17yGqN0i0BJLFoIEUJct7/Tm5MDlGfNe+s7SccQgJWPnqhvUiNka6Q9OJ6smKm6xbA+whJkIznsiJXbgJ0Zn29h6kIkB/BbNKfr2MERUVc1xhGvT/82WiI7yM/1+QRJxrzOagikx68IaolbV0pQFkMSLH7FcRgJG6aXW0J8byu0/12axiKoODy6a2EzHP+Kkn6ZC6Sko+z1HCvLT3iP/SRvhnKGxRRyKNsrz90pHFmmOdwt+cyUGnIodBqZXxIR6WpegsiJqO6Fml3mroLeiJacCdjSuHW5e+5ZbmIK2beAC4XDbYLp+6Hw1sI7DKkgX2wAjPivLHkRue6SJC63+J2D5wEiGeomlkGLkyqRHcn+I6sHe4jrRI2eadrFUMkLo6C/0oaKUSxAkHHA1qqYG3xUbIIZ2mypgb/uL0MRvKHwovlU26NckvbLPSF8/zBizvbkEDo8/4pWVekJlEizsC/fZeZZUSij0jcIGszvY2mkRar6ylZ9rs4tETN10eL5cdIqtm0f5JAeCk+FNqNiAotlYawXx2PgN4pyiRmyGLqssmk5xH7ee++EnWOVLTmh18lBzu5/jn8HOX5vg7WQO51rJq+AoR8vxrExMTlQUIwirdWuUZhvld+TfYfAsAdeuyX+5iTbYarvBYfZHvseJVZ9oA3ncs9GYRGhdxNSlUygKJSe0g/KP/CXOsIzfE2cSPzotIL96FnqySNKJ1vM23knXvyqmUOzZGzIkRnZErFSArfmOoWQmxsb/7Lskfz5Sgc97VBG/MSPpLqC5XaGwWj+qth2BhuZ36eJVgDuYpqqime/F+iGLnQG/5ipHsCL+IR4KdZeAOagld9zZBBoutH/HfTQ2+tKLCPgU
 FRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 13:05:42 +0100
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > +		/*
> > +		 * TODO: In some cases of partially-mapped folios, we'd actually
> > +		 * want to collapse.
> > +		 */  
> 
> Not a fan of adding todo's in code, they have a habit of being left forever.

It's a way to make the developer more depressed by reminding them that they
will never be able to complete their TODO list :-p

Personally, I enjoy the torture of these comments in the code ;-)

-- Steve

