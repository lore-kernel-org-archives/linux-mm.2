Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B408606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=onn1sehd
Received: by kanga.kvack.org (Postfix)
	id 4009F6B05BD; Sat, 31 Oct 2026 05:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8786B05BE; Sat, 31 Oct 2026 05:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE286B05BF; Sat, 31 Oct 2026 05:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1123C6B05BD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:30:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92490A8588
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:30:44 +0000 (UTC)
X-FDA: 85382401608.18.E2B1326
Received: from mta0.migadu.com (out-98.mta0.migadu.com [91.218.175.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8F960A0006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:30:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=onn1sehd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znrLCuEJJGmNbO1Yhr6pNkt2XZN+PDlviOAs+EksPeM=;
	b=Ed/TEoPI+alVOHv9UV57GtMNJG2IHuwYvUjVaLiAVC4XiPzGg2A9hP0fSOl8iB/3K2K6nf
	PfK8b5VgtrdgKDuETMAxZFDs0LPf1FGuNo7JP95YQ7C6nRdVZCoYDv+6FLqgZtDMU/XP3X
	S9ggzop/Qq+9KF9vD9q5L4We5OWJ19s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=onn1sehd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.98 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439042;
	b=av8FKE6uLEZCdsRzw4v0UdNU4Kfa/mSCqecYG01K78zh/dGHzdwbECkmEUbeiu1joSwnDM
	3wYLVSMrGRuVhdnloHkIzSwRF0B1/A7Uvc+vlgd1HoJf1kuRBSnUlS9xrstxhJGycr+vRo
	h2ciioeWY0+LMkYnUTO6uUSF8meZuRA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PvpE2xVkJZQp9Z5Dmn2rK7a3rOZLgmd/wYqlMX90kr4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793439039; v=1; x=1794043839;
 b=onn1sehdzhf2xVt9I5V0tDQ5w9aAfRk0sOy/O9MWDjUCaWL8OHQphb5kYXw9lprgNKlkr/MS
 yocmdX1yyu4yR+KFfILxLldFXdGYjd9gx/6b43A2Zc+p2/kh4Dr2f8mKdfMkwsgEkWOdiGpuCX+
 7ItVumMlQ8COOuay8M73TH1s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9f95f1fa206c4141;
	Sat, 31 Oct 2026 09:30:09 +0000
X-Mizu-Trace-ID: 9f95f1fa206c4141
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v5 3/6] mm/vmscan: move struct scan_control to a dedicated
 header
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261031090041.58574-4-ridong.chen@linux.dev>
Date: Sat, 31 Oct 2026 17:29:49 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	bpf@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_) <bpf"@vger.kernel.org (ope>)
Content-Transfer-Encoding: 7bit
Message-Id: <CB3856A6-C6D5-41E1-B6BB-B263BB63BCD6@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-4-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 8F960A0006
X-Stat-Signature: yn9fpba41e1rnrcesmgjs76fx86mt3w7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793439042-373779
X-HE-Meta: U2FsdGVkX198s+M47LBRqTkNiZ8L65npx8BtLVTYlaCLnaJAvaQOfrunHHqJmJwyo1v2r8ATGx3iiWnp0lx2iSVonN92jzNa6UAnrY8qTMm5YoKQ9wd18Uu7jjB9yhCu7j/2VVmBdh7O5gbf4V+7MURJ5N4bSjkwu26uNT0H32GehyLSeji8COXlm0PA5JUgbBeuyTg0nkdinrzPEkpZYJsw4xwOQvQAUDQ/xIAD5LObbjuZ5BZPxWXSc3DutoysLVI4Yo52gE5EI28T1XOVa+rgowXkWYvXd965Qo5BzYFvwxgkpJqNCgfjFnG/Fmh7OlGwaElfvlIiqfXhtxQFwkjB7obaolCCOTAOJro/qJacgA6c3dLI7euV0h0//VvSrE5RXUfqjsOfJB95S4Xrt0qOFfJfM2+Huj0vswnGH+IWbPA6zvlsebs7t66TJ3aTr0TIGJeqvmNDirjYg47IeteEE1r08Alj00WTOE2PH0EBF9rWeWbCl252miBdBVUnoNZgbWQEbEiPGzrS31PGVLMo0l5Pslrw2TxCONk41bfCRkmlPnJYYdN5Ga6GMpI5ZgsBs5U+UdlIHzU82/WLAjALDQmT//WRnqcwC0i65DoyGXldjjLJPiWtd43aktbw0q2OJUSP6jSWYMzmvxsYAmjMbCShgS36WtHLLVAA3Z58CFcgmsDZxHtxIHjO/C1ZJT1FgG9Qe2q0+5I6P+aBu3HF2LNj8wbNdqcfDghAEk0saPYjucPqQCJEPzbVdyIozJ7o/alTDv2OD+Fu+J3zi5hNhFWUUT4BgFVOcGvvEmkcfbn660MkF26xEve8z8M8QJlhCXdus5ogGuo9p2nh2URnGME/9LKzyKo1g6zKHoKc+q3EC1Wg1VaQLcdZYdxyqZAL5k4HqUWn3DL1KTeDkIvE+ZWWqTF1HhcdDUTKZ0KAOE/RG9gIEpmWNXzO6XzqKXU3zRvjKkh2W8aManL
 WOHa9KO4
 rus4AWtOb1j34RXnimP9Yo/4sLxfCM0tdvqOzd5l2XKkHzZnTZ3jN3ofn8WfxjBBe4RO41zyhG6V8yTL0BcOyjrof236jk+YG2Zzp7IKAmEB/q47LAEpw2W7OdVXab8KBwYHvE4s16x+N+2ZPfPZUnHKDBYgHR0C8nv/3i0iAsWeUAlAL5tnufBYX8LXp+veXTeL+Io6ce1VHWt9TNNxTNXxxfwKeYAC1LqWrhsZpfkCrH9XHb+2XGiqordQhP7bPsgwQ3SjHMoZW8ELe64idH45EJWWBi6IwhX2u/u1VndrsTwsx6mH+NkpZYx+gs1oUGM1h0DadqrZqbcXWzdS+qzpaymHy/dyL9zXY/HiWiCaNwWSQ8JzWUG6X1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 17:00, Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The definition of struct scan_control has lived inline at the top of
> mm/vmscan.c. Move it out to a new mm/vmscan.h so the reclaim-internal
> state can be referenced from other reclaim translation units without
> duplicating the definition.
> 
> The header uses an ordinary include guard and pulls in only what the
> struct needs (nodemask_t, gfp_t and struct reclaim_state).
> 
> mm/trace_vmscan.h includes the new header directly so that any
> translation unit pulling in the trace events (mm/vmscan.c, mm/shrinker.c)
> sees the full definition of struct scan_control regardless of include
> order.
> 
> No functional change.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


