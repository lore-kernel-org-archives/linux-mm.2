Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9194BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 17:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D696B0096; Tue,  1 Sep 2026 13:49:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3CC6B0098; Tue,  1 Sep 2026 13:49:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532436B0099; Tue,  1 Sep 2026 13:49:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363566B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:49:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B774C120498
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:49:44 +0000 (UTC)
X-FDA: 85165931088.29.5CA8834
Received: from relay.hostedemail.com (unirelay09 [10.200.18.72])
	by imf22.hostedemail.com (Postfix) with ESMTP id E20F9C0009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 17:49:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788284982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygP2WicIyxvIfgiulI4Z+w98tf+NFr5YAyeGttsc9pU=;
	b=Cvacowr7o6RSsUCF9HH8zYr/zImahkRaJdJr7h85hsH43c4jrFUQ77nTAFT8wltueHuk3k
	Lf5cH/cLel1fWKw5D9erMIqhxPT82Q49NULMD0yMEN1wjNMSECT3AoI0mnPOoSug71235+
	2GUEHaHdAmG1jskj3leSSsBsWc7mq+0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788284982;
	b=6+uHU831MTreYTufpV5BlKDYjSx43kmX/cZobEeU0ut+88C17h/+5TAYYeKFBiBmO/vBAF
	8u9DyzhDtB3kA4dZjbNStpw4AbfmHtufeUctNLq4hzqgAVO3C7REbJgMNapDv18XSWFloj
	gBfSc4aI5LwqsPd5PUw6mE6NykpfVi0=
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5B95804FF;
	Tue,  1 Sep 2026 17:49:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 18B6320027;
	Tue,  1 Sep 2026 17:49:28 +0000 (UTC)
Date: Tue, 1 Sep 2026 13:50:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico
 Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song
 <kasong@tencent.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, Jonathan
 Corbet <corbet@lwn.net>, Jan Kara <jack@suse.cz>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>, Shuah Khan
 <skhan@linuxfoundation.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, kexec@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/14] mm/page-flags: remove PG_private
Message-ID: <20260901135027.028ea9e4@gandalf.local.home>
In-Reply-To: <21998471-74B7-4799-9E8C-D75003D1A4CB@nvidia.com>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
	<20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
	<20260901115542.35cf337f@gandalf.local.home>
	<21998471-74B7-4799-9E8C-D75003D1A4CB@nvidia.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19gFCgDW4g7ez/BxoPyHANfn1/41/yL2k8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=ygP2WicIyxvIfgiulI4Z+w98tf+NFr5YAyeGttsc9pU=; b=1mgqFkkrL4Js3FsbhN/khvoOEvnHVh/aadmAMTCUde9xGE7BUvdArUa1RFWye4SH2Ctek4vS4gXiMbJcZCGFh5DVr4gJ1YyJQrfjy3W7IYtjDzLOP7asP560ZaX5A29U3FwYxXzeZu3rRui/fC5b+U4Jy3KfK07GTDhVffGq7Bg=
X-HE-Meta: U2FsdGVkX19FFDvFfWjTCdlnsQZ6K9ZDH4G8yyE+mLes3dBmHWO8NPu6yEW8XXzWgHsuxMDRFSptqXWfMG/Mc+vYMqM5I7IvoIiQAb8UocwUi/mhVmxt81zskgiVGnoXtfTLsJnPK2S+57J8V1WnQFXxP6OtVQ7C3JQiqyk6GHKdnEceDMmgU8UvEa1Vj0wlxj76LZY6CogJO8meStEy2MeviQuBcRNaEP1/lsb0/kCfQ/lF+Pw1bHZfL8fAaIqQ9wHGLY9MM3CVEabUY6AJmK8sY0fn0jiO4bl6CHHeOt5dG97E3JSrappl0A9/PWW3XYCVCivoJPwoLVwpncq/jSqtrYDYGvgG
X-Stat-Signature: rxq65jotboo5e8ifu6pp6esabk9rnwg7
X-HE-Tag-Orig: 1788284968-292977
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E20F9C0009
X-HE-Tag: 1788284982-912504
X-HE-Meta: U2FsdGVkX1/BD503TEmadSAbpxrDg7IJa78c3UjrYdHiw8EFczmXUKS4UGeobXJKtq07zm0lZ+WoY2iK/vwIStx3BR8tkXmAD48Ssuz/Af+bf82JEQyAUuAGw+OzX4sCiUXaZlPkh4qu1XyDC7Gk2Xqho8zru3DAtR9ArCMWGY6GWViJplGMx8bbAFd4OPh5Zv+P4NuSkrgBN0ecuqZmkvADv7fzN7SogMzKcyf6KwNB2Tij+snGmKrbjHI+TtpZ/4ei9LBG8s61kKYigJ8BPQw9R9z+wu86w/reiAHEIhYYXiJoIRvlpBXL61g1nDdNIk6P9QhW9X34JAKLz1g55qC5HJiCTbNAU1ZnjHz+KTcor2pNmBm+CxsqvHh0hqFG9nI03S4FOYSXId0nQ/Ro4j3yp08nTB+AYGD+cM66+hSAKZ2nFj/wwNAnoieTtasb/ts+zWOpbtnEdFdPtuIVoIijCJFQaoePGOIBb2hqpIcgR4oJo+jb6dnIv0leWX8ehfS2assADoErtc1MqNxrhFeCU67X+F/eVgRwuRkRZVWtumbVxJH7fXl4oGjLYKFDdnGp5mDdHgB0EPrTUwHHXRCN8CkgHQOFUNyiIzUOap5js6WTf931Px3GCch4XenLsXBAT1SDXHHDmTY0qivCsIOFIpkiMKdkeo7GC7vPVn97mvo/eiiA1dfAECqY0cm6Na05cyjyVB1MUgDrZLb/Im7+J5uAvHkeVLoz2OifZALeZPOqJ1z9a/r1NeuUJQKY4yM4LMhMcdv1splGN+17KOSbwu0WEBTHVmRwCy18cwV4gmnkjORSj/DxF5T1VEZHQVBiZnAEQHEvyIQREtZEnQ49M4eO9tliUrbiUke74tLolKB31lKi2eX6/JQ3IxTG+DWkyUZFJYAAYerF8ftpKE6AC0mzAqUcjs/7+jwwpzKNWVpJ7iSVi9sIEX/AkM0Ew38NbMZeL4rk7PLnomq
 RMiuq8AO
 4Ua1zf0zEElf2j2E975+WeAtlxHOU45k2Ug2KkO0s6vszfwT3DsZ1mB21Wuqb/H/Pr6ae3H84KGQQRNoPPmEdVghRVPqSYWts5u9fDVuIN1yu5ChajOMNNv4HYnTMWAEAiUbQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 01 Sep 2026 12:01:24 -0400
Zi Yan <ziy@nvidia.com> wrote:

> No problem.
> 
> BTW, the plan is to add PG_folio after this series is picked up by Andrew/David.
> So the new __DEF_PAGEFLAG_NAME() will have no user then and can be deleted.
> It should be fine, right?

Yeah, then we just remove that macro and change the one user of
__DEF_PAGEFLAG_NAME() to DEF_PAGEFLAG_NAME().

It will make that patch even easier ;-)

-- Steve

