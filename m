Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E202CF45C8
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9776B0005; Mon, 12 Jan 2026 14:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5768D6B0088; Mon, 12 Jan 2026 14:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49FA06B0089; Mon, 12 Jan 2026 14:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E67D6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:18:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3506160BAA
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:18:30 +0000 (UTC)
X-FDA: 84324273180.21.87DDF2F
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1BDD0A0011
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:18:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768245509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r6lGopZInlHr+gqIy+X823d+K8SLErm2dTPKD6lH1NU=;
	b=CHvVArvggTC0gU4iGoGh3/4gqnblLUlm2FQfAYGXTe6a7RtU13gH5CeMOeLda1Nu5d7kiy
	LAhRM+192ypTyoA3lCb3SqERBY+yuVxA2+VwBx0y/apKcdidb6L1gAAnI8IJS19W2NDQWA
	VC2Ljt9GXg9v4neQWyBKhE7Q7ZwodYM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768245509; a=rsa-sha256;
	cv=none;
	b=cGjjPNbw7OgPnZMxmsR+0VpN8mjGk2nXwBSITDWhQasGM2zy8Cx5psREvzmRPeke8JJzIJ
	C5MRslzKZhRw3jGwxxcq7JmitadBqHxz06drl6VEz2hm2mGbGe2mekyY1Vq/5WaNklivjP
	M+JqOuzT+hJ0VcIi28G6qpOSX44SPdU=
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C323ABD3C2;
	Mon, 12 Jan 2026 19:18:25 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id AA5F220024;
	Mon, 12 Jan 2026 19:18:18 +0000 (UTC)
Date: Mon, 12 Jan 2026 14:18:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 "Paul E. McKenney" <paulmck@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v12 0/3] mm: Fix OOM killer inaccuracy on large
 many-core systems
Message-ID: <20260112141821.76dda1a7@gandalf.local.home>
In-Reply-To: <171c5a7a-f12a-46a0-b791-18e25a3c7877@efficios.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
	<20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
	<6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
	<20260112100523.6ab884be@gandalf.local.home>
	<171c5a7a-f12a-46a0-b791-18e25a3c7877@efficios.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+eMNLw3QA+soatFqAhld37HLNb45YxNsQ=
X-HE-Meta: U2FsdGVkX1/5Kc44YQwH8O0aSMQGKaTsgtaBbz0xWqU6yDj2E2Y9yNPaFtsmL41f6dCaP4inN1fLW8/ZeJF2q89IzmiLBah9Pfrd2Ux4vB10kcuXdYr5SHWFKzOpmVhllJcEZIrDcSiAcvgZrQuDHnEh/gaRtVhBKbFSY2StMWYkUCzRYjDuENcmNw94QJeLC9krXX885rolrgilAjlOuDpdMNluseU9dWqPiqFFD3wtVty1D4dsniIhEiL8C6bsSSKVk1LMHENRGzd0vW6gD6iKuba3Fhm8fKvmyGdV4zax7gXMeiD5ysd+TvUlEeAYKche0dEMvgjj7RbGGqMxLlfOtBqvWEsRzM3ANpJ7FSD7GKbKn6IgtsEHBQ59FXZK
X-Rspam-User: 
X-Stat-Signature: ur493pghcfd3i1oiedxcihmcp8mdw3sh
X-HE-Tag-Orig: 1768245498-912157
X-Rspamd-Queue-Id: 1BDD0A0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768245508-540304
X-HE-Meta: U2FsdGVkX1/3jOEFP1CfNRXFDmas1VJbT28HiMfK/ok6Ch1qfsq9J4KTFcOrLLhDI/TgVRTh4OjbtO2AiW3pM8IxsA6Pys/osSWbZ/hLf4HDhQGISNpUIB2gTqzVe0HryQWxfG+fILWQ+l/cOX8HkydAafNGjecLExVdcn4k6mulV00n44ZIcULP2vCYk0445hfm/nmnspy/kWBoBYAMOjuuwUmaG8zMQa1QXLlsMI9IbWFyhy9QGuEzgZrEG/qd3WthUYko/O6dY6b/ptnAb4mixZw08U8K5wlvF9MT3vkfXrAWXil+CQJ42l4lu8WfgwY43WAoNMZlBaDy+T/bqoudz+glqDyo1mann4h8WR5zCv0Qra7/kQJv+hpS9b6WAjxyAIbCqlb9FF2xAQk/kuxRhnrqrTPKKIwoEvv66WZFyUOToUD+771z1Tkjvf5POi1pnfsp4g/Ev/WlZJdYv4T90DLUFTmiC5vc3x6SZGSxulhRv86IMb0sT/ZpTE0kV9lmc3d7zIHLuCWdVDKQSAI+0mCIezFn12FcG/d3rfCZ3qyong36qKolJ0ExHIdjosGTELggbizqI1+kN4gWN7/rA9gLPegmKeKZ6GjeORnfADcw0CZPO++qEso4DlbosEUqIfMXZqRQIftyiheRVQmupTqpOTDVDh7QYLJsZ7dSwITpwc/A9qYFmXAogwt0G9dM/RzqSvrSDOUD0Da3Oi+Yogtj7ukGloIDflINpBfsZd+Bo63DXdKg3G2yOSsD/qB2MziWBLdmFq+15ExY4+HGLyJwlZv8Z0F9jhWzDm0EalghC3wTakIS5e6l7nNo3u+NrPZqR4qh/0q4eLmiMbHSxdTeNTIkaJEng8UxA9+ZbM+zbjz0KwUCgRdEnX6pE5O33We/lCJPVs5uXw//C3pJICaFjo4nbMSC+K0fd0UBEf8pjeCIy/n086EscQyFP5MGOzKIVkPzHwfaacL
 9WqLVliC
 tJDOO66gLWK+yRy8TWyHqVr+/vAMBy7tPcFmKOlTD6AW7RHva6DZw+mRfHanG65RzKEMr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 13:36:48 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> That being said, I think this AI review can lead to interesting
> discussions where others can pitch in, so having it in the open
> is worthwhile.

Agreed. I'm interested in seeing what AI catches.

-- Steve

