Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469AEC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926726B0088; Mon, 12 Jan 2026 10:05:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E83E6B0089; Mon, 12 Jan 2026 10:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F7F6B008A; Mon, 12 Jan 2026 10:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 722466B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:05:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26912C1D7C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:05:34 +0000 (UTC)
X-FDA: 84323635788.02.0E86FD1
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5103A40013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:05:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eb5J7+AM7hMHs/8rMAmXiWtWiI1frjLvFc1DdzTFI2o=;
	b=sRqL5E4Xot/2tzG8e9YoTFlr7SSU/vr3itlOssw5k/vCvqij2wSaF4sYHTw+GmVopYQcaq
	kQDBOH8nH4oVEcCSSUII2Q1QPZdQyhVvr7U6zuY17xlYTit17yMrKPDx7i6oH00uNaGUEf
	d5ik2XCNKtGLNgEvyhZ4X4+mdEvywlo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230332; a=rsa-sha256;
	cv=none;
	b=On2xYjzAatGw3Jxh181x/R1jGwgRgsW/KMNKLOjNtIhnwfNdPTqvRj9N+GuAr4oTc8yp6J
	i7rWvFQsGqSR4PuUZDyM/+tcEj3Rd1+y3LT9YWjbXL/rd4TcmO9VhfiYfgtcl82Ja5k9ET
	m3DLjPHBMcmcwOuvfi16bGEqhQ/HflI=
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 52FDC13B014;
	Mon, 12 Jan 2026 15:05:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id F2E762002D;
	Mon, 12 Jan 2026 15:05:20 +0000 (UTC)
Date: Mon, 12 Jan 2026 10:05:23 -0500
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
Message-ID: <20260112100523.6ab884be@gandalf.local.home>
In-Reply-To: <6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
	<20260111094823.6fcb1fcceb7cfca2dd37b66e@linux-foundation.org>
	<6fbb17fe-f2b1-4233-9834-5a5020cd87b3@efficios.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/IXX5X2GrSacT7vWCjRhpUMWV//FH1/IQ=
X-HE-Meta: U2FsdGVkX1/IntiD8c6ZUJRRSq0u0uLBSB/y0015X3rBH6Xogr/HB59Qv8pJUVIxqu51FohwNnT+uoluB5aqmjFBtW5bE+ZA3W+tddIPd25DDSL8BUkpJdR7yVe8HmjNL6RZR+K0yOKiwuyHdpPNhBobGPX21vux5N/6ZgrDPbmVqw++5pqIPOJA1om5i+Uqj4XxRVaoiOEdFiK4xdd+ObSgtmEMXm1kpglP42d8gnT5IhpTYOUCVSKZUGq98nR+88et97cLh8Xxp+CQZWkGOS0Eq/FhTkbHRdE7mIChOQwS1rLmLghKvwsmjNE3v8Iw9aMrNIdYaXGpThncxYOK0Ua/FLvsblhpmEntzXxdM5+6LhdTbd/Av9LEEZ+MJ8Rp
X-Rspam-User: 
X-Stat-Signature: z9jkushrmo6cen9obskcedymfttod441
X-HE-Tag-Orig: 1768230320-229295
X-Rspamd-Queue-Id: 5103A40013
X-Rspamd-Server: rspam04
X-HE-Tag: 1768230332-764727
X-HE-Meta: U2FsdGVkX1+Em777uvjApsF2JRu3l3xalrZqahWiexbTD+UDzZUNJqmDJ/zKDX3v2u/Yiuk2+6jbRXmgKSZj5TnfQJ5UIJ1a82C/+qpq0Qdl9ILp+278H1yee7Prk9fobaAeyQdHNAZGyjW4KOALivl6UFN/HyW0SceHlMQ7yEOF8h7rJ0N39y24ET/e/qQHGTMA2uq4qtdwgzh1907rMIjSYS0BXHhHZl1akkgz0sQx5bjKmwCPhyo/4ifa+lmlMTZ3RBCxM+mffqiHeAZT8TIaXRlzGKncrqWlDuy+gMy6etRtBz58I+npwHxn9ABZkZ44ii4178okNrxO3NdAfnF+0OzXGzUbS0yDH9+7qSiUzl1fKK0ITyup5IvLQJLiHwk0vR5srOADtib9dohW6qY8HY4oea4+bTsAnAGeczU/RgJTFGF+MW8j2NonGP5l32/n9kL6CxtZbtvJvPF5ZiAjBgMTwBRr1rxBdTM7ge/eVYo/i7vSzVWVO3YAH9qA9wMCN5CWSxdE4VjmPANbdl+ULkzXZAtn2PhuypkPLyz1ub/z4DzxGzumujRRhZZqFmMM9DobSNqOhPhBLXztUyrCj9rOULdHfYEgZicqjLvI0gWpj0W35Dpc5GhEev14OoZpWHlV6X0rNZaHne3D0MYvVsBFmkiVy+VDAllqIPiUDvzLMZIyoOhPo+q5jqeOAQ8KeRBVqTekZq7L/85lCLEIeBl9p55QqRZ/N5F7rZ9H2p5M4lwin2wlEFCvgcadHDNH+osRN0KfOwhACcXLXPO2WJ9EVAPPF6yfH9wtklkb6SwUTQQHr/bxfRptDxuGURpYTSyqQWBn1N/EBCaShHmcPhwCfqu5CTqpOr+Q4eNK+Y0hSloqZ2fumj03zzdnDNHhLxSZLlg2sFSw3HTleK/aFgLYz5e/dLs8WkKTZkUjCYWkgDR8RiRkGB1P30+4h7S15ECMxMXMbd9QIaJ
 rBVtMW+n
 A/+4QZCkXrj3PwyOLBEJg/DJERaAMX0pf8oG4/iJC5MmJKvB84jSCm77ADNOxrwLBMZdA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 11 Jan 2026 13:04:59 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> As a patch author, I find this feedback really useful. Is there
> an easy way to get this feedback privately before sending out my
> patches ?

Hehe, we all want to look good don't we ;-)

For me. I let people see the good, the bad, and the ugly (probably more than I should!)

-- Steve

