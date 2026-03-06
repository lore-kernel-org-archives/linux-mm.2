Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567E1FCC05E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8031E6B008C; Fri,  6 Mar 2026 13:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B0946B0092; Fri,  6 Mar 2026 13:46:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD516B0095; Fri,  6 Mar 2026 13:46:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58C476B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:46:56 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDE3A1C914
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:46:55 +0000 (UTC)
X-FDA: 84516519990.15.20C61E7
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf28.hostedemail.com (Postfix) with ESMTP id 369DDC0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:46:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772822814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uZB2TUjhQ89IgPB6kx5kyxnRYTXzc3TQMzBkHq1J3AE=;
	b=rxLIo05LJoz5GYLwHA0TKj1SYaBsQuQ26a56Fwt02xTy4A0isBFCI96Wpz0ZOCh/uwjmbb
	EnQp2f3lirNvii38eUQSQtBwMS8oX/Hv40xR3R20jVwvolkK+pwe6uH0Y+9IH4kWVHwV3N
	naIAPpu5BFqLTIeUUalrevIPYZ1nmZ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772822814; a=rsa-sha256;
	cv=none;
	b=A8FLWsbUuD10KZkDRTkQXD+hXRhA8eT6Mxv9t/Izcfi4iJS2DV1ss4Oq0wgm8dc4/z5VC9
	6kMnB/CfduqdYFG6SiPHdodUV+9YS/z3yTdKEkoxw5+8T2jE7w2f/GoHZHPrUb8Vj6aXc4
	8l7aszLpU7leluXUjtugcxb+QgXlp6w=
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43F3359D81;
	Fri,  6 Mar 2026 18:46:52 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id EBE142002D;
	Fri,  6 Mar 2026 18:46:48 +0000 (UTC)
Date: Fri, 6 Mar 2026 13:46:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Dmitry Ilvokhin <d@ilvokhin.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, Peter Zijlstra
 <peterz@infradead.org>
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <20260306134649.72d925ba@gandalf.local.home>
In-Reply-To: <20260306103307.43d12be7d32b3f3b06f7bb55@linux-foundation.org>
References: <cover.1772811429.git.d@ilvokhin.com>
	<cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
	<20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
	<20260306130052.7da8eab3@gandalf.local.home>
	<ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
	<20260306103307.43d12be7d32b3f3b06f7bb55@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19XeTY18053BYONN5zueFhZ4yOewcE2IrU=
X-HE-Meta: U2FsdGVkX19F2+vb9/CMCWyUkj2/n46eNB9KkKwTUxxNKrxjkKN+9hbD1BOaYNCKYUqF9+f1Rk6470+2wu9uLxjJFgkTIEXJQVvugL+8AM2yJ+xh3QPV5SavxmpJgjCp/juBIyXd/oIb+o9kTbatcpvLjX3k7vg4JHxbfZziUl2+CLIcKAyWcBwuZuVXrDY3oRkoHjkva91cDdanqN2F1uX4MX+BwzRNK6T4V5pmcNC3kLsiBWnTDziJSNv6AuUTYEXGZAJUEHpcRydHEEVYxts3Ki9S/43krrNE/yTN7vrDPsM158GG8TCpN+6rEu0XCGnc9d2kwJW0NUbDzSpfZfgAsepzag9HO/nOwv1ID71TDoHmrhLzrTPVUBKepUxx
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 369DDC0005
X-Stat-Signature: m4h7sgi1ze7gsbg4pecuoqs1z71s4krd
X-Rspam-User: 
X-HE-Tag-Orig: 1772822808-477565
X-HE-Tag: 1772822814-592849
X-HE-Meta: U2FsdGVkX1/LYE0sTLldihGpa4WLMwwijf4VdP0dMd++MDCDFas60a4yDNwXgXM05IFxTO+H4CNVoeFwGyvwYzAflly7wJpDnFDQl0xSg6k/3+VUO8sTZw1IJgvbfZTQ9i2YIXiFWUklBui/+xvKklgSKfXJ4tsA/JHPis64aagNM7i3XWFkzVeSEVKPIPX/IJpvrQ6WuqCJqdgmt0aofmqUXJ8RqIVrQsVxVRHdvCjSmzR10LLmrWB3tpwqdtp7oxlyRITY2UYpMQ+qUTDTclwobdm/bwccVUDfjphk6r+E16Ju6YjDZBBGN6laNHMAKwRGj0ZoayHRIQzPa22hNoSENuip1Xk4rdZL1/79mlVNBj63PuKyqmQaiq8vcXedZXS7Y3fb/pehHYSAraoHv+BOt7xtz8QHCVG4D9OsCYyX/G6TRue2dOAXe+C/9m85tt6dGMC94TJkP8LKmtPjIoIdszwXLe3Onj5tZ8s/Yj/xTf00tFTsRohSPdD7+R8YwfznWJORnGavrMCNc3eQPCB8MGTAhB/rr9zOPbUFkm77ixqCCeJzIQyoKKHNoEEZ7JYrED++OIdDvGo3RPs51Sml3tIKlQNjudkeSiO0bg+L9f5j1gBjvlncgvEjSJ0Ixa/H5G6Nm8Xv7cBe8RwsFyZtrTdORoI8O7ZFLvCrIMpjhTJwAGTRXjkOBgllkVpZxalOu7U/5quchgB77XCl6Xq5oWGI9Ck2lk8Phpnmyrw/ryx4Cykp0XSPVtLrYL1vhjxBS5lPFg1j6Zj8uxNZIFEEzHbqj1qax1qvc0dWo36ITiD19yl5TcvTNgadsrAMBw030ebXXLx5PdvOx1yfb0s24BW+veg23D8T7xWESwyavBxL3ypJIuHL6gjkD1W/RRz+cFyWSPaa9gKwr1U/TwRZBBj18zdMAGrMvrcggCpVmhoi9PnVKbCakwn10lEDQns4WLc8osQ/5pMxo2X
 Fc9w8nTl
 BJsd05P6hGnWG8htk26WDiqD4/K/WFaYeA1gUbqj+ECSsKyI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 6 Mar 2026 10:33:07 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm not enjoying the ides of penalizing billions of machines all of the
> time in order to make life a little easier for the developers.  Seems
> like a poor tradeoff.

But if there's a bug due to not being as maintainable, that too will affect
billions of machines! To me, that balances the tradeoff.

-- Steve

