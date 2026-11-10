Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9276606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hsvLCxY6
Received: by kanga.kvack.org (Postfix)
	id DA2B46B05B6; Tue, 10 Nov 2026 08:58:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B1F6B05B7; Tue, 10 Nov 2026 08:58:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9926B05B8; Tue, 10 Nov 2026 08:58:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9EC36B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:58:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C77DA0918
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:58:43 +0000 (UTC)
X-FDA: 85419364926.12.35CFE3E
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2456B4000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:58:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hsvLCxY6;
	spf=pass (imf04.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794319121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AuBCb/I7k73HlQgjzDYi07i0QVcp76kIK/7/UWRP9M=;
	b=35Mtg/xdoluJDEA12BUDLxquAfimGgOfMdEKvJx0wRGllwUaaf+E62FdzGdbMfzCZGqlkc
	dzYTlb/EsNQ+BkDHhrhJqPdC5/zztY+Z5oNrGgYguFPDjYB0cyHfCqUI6GjTzIV+edkz+B
	lrQ9n9fXZhjgfO/S+IqIYOx0/oBjPCE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hsvLCxY6;
	spf=pass (imf04.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794319121;
	b=tXCXvWc3EBgqO5B9wGxif/FXSL+wuGyVSQU5hi+DmMSlFRmWmPiREhDmynseHA72LpqqaC
	H9f9Gxoh8WCYy6i5/spKqHNtVhAmHSfq5QPcb4sTq04MR8TcM+XM0xGjNBGboHS8jhOBkb
	0F81GhIS2gghdmFr6JwR1/7h1hkZWcg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4AuBCb/I7k73HlQgjzDYi07i0QVcp76kIK/7/UWRP9M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794319119; v=1; x=1794923919;
 b=hsvLCxY6r99RkLOOur29/ut9GZYcgjhbe98kOeDegndbF5xsvHPU4dT7WUBQRlIoTSeU1kqE
 sceJK6OQTU2tPZU4ffffyCXGkebtTETZ7/z7OYsrVEzvCjB6ESel1NtJnBmQk8XSTaQYvRga8uX
 ZTPjJ5D2KVJkLQ9QIZCJIIWk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 68181a37af8247a7;
	Tue, 10 Nov 2026 13:58:38 +0000
X-Mizu-Trace-ID: 68181a37af8247a7
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
To: Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Qiliang Yuan <qiliang.yuan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/compaction: stop repeating failed async compaction on every THP fault
Date: Tue, 10 Nov 2026 08:58:24 -0500
Message-ID: <20261110135824.3264904-1-qiliang.yuan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
References: <20261102-bug-mm-thp-async-compact-defer-v2-0-b407e974db54@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m4bxh1ue7831pmdjzgyhpk1t5yx8y69a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2456B4000C
X-HE-Tag: 1794319120-341406
X-HE-Meta: U2FsdGVkX18vtpc+3Ev2cz1AB4xuVrMsv8f6xhm5nU4+WJ+X2XRJmdGjSB63dx8a7KBLuoecxEERvA6raXSXqCifnX5FN9ZJFyBRPpHH3IkRmVpNcH8mVgbsnpf2fwUrx0CTGOKqqagtcVIXcHyM/Ic5Aff3jojmN03pwJ488JI/KJFUW7M2aMfdR35GzycyCfDIZiWQL+zFDpEWkCQNVn7js66Etun9jpyw72XHXNTmtpCyh8IRnLT8JTpRAWXGEqeerm1c2f9/NsPB70+wuxSbVOIcEnP2qCzXdJwMBYvgV/oWFRCS5op9unihQzg/pnoAYlVp2R69PtUNHo1yj/V/LLWkH9q8Uw/HShP7NecT5X79tclFQ5fpV0Xe8FaSZ6jZrX1XjLpBCDcJwIB807yXZk5M8Ps0GakOeraCVoUjMj/vFoKv/OV9nrLDlPgUtaR07ljs7qCwAFNQtxUJc9ymqoWjU7jlkdav+89ATdaWgaZZ5TkWHmm44oY8LAUmD4pnSP/mKoJcDJAa+NxmXYAjl9YFF0oVzTnoFKapDY5iapg/7wZJ5/pCJLSRjq2mtQlcrQN9KrTYFWFru+0K0cEifESvns1A7IMLb+HuGw6PUSJlsragzAjDpnKUefF3K3l0/HK8uPAjUbWsw858XmM+EKvCr3ULutl1J85/xE6gXYlKLikVkBpULHqcoHdNx8XqHyuBhvnDgOS7rTkDErDdJQKd0ZJ6Jp03oTqSaFbbkiHLoD9R1q02iC4MBjEpqxcofvPy3xEz1338gETguIoQeAs3eiHSC+okONdE2g7fRmmCtkY1unZLkK2jgS55Xx9jB8humZ/bRhlpTYEHB/f2jLxJ04gkSaemq5hLlAv6lx65cMJ5RbCTsbJ1y6CxcKRIvkqk9/sUYcDJIDLYmaRgd0Zk92/jtHhUD/DswOtrrccPSgOgTghYk1+QhiOp4ytadSYnGylSWX+DUQN
 1Mp7KIe4
 2+j3Zc2NE/4Qhm0jq0bGjbi/l7ppJUV2qkL6DWggYT1Hb20Rw9Qn9NeIAXvpB7h28uZINO0Xb7ucX/xpTaeDlgLGD9r0/taaWc1cmVA72P/9IpDOjB0UPZ8XZur4FXb3KKGOypPgLtFZB7zNxVz8jZldZn2H71VVyJ5vzbT7EiOkPqroM9ba9R8ggaJGldbVxD9KsZhXXvbAtYupSBXxnYPOz2l/t9qx5hXGvKI9By2S+u9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vlastimil, Johannes,

Could you share your view on this series when you have time?

One known issue in v2: the cc->mode != MIGRATE_ASYNC check added to
2/2 blocks clearing stale skip hints once sync compaction is fully
deferred, so local THP may not recover after the pins are released.
I'd drop it in v3, but won't send one before hearing from you.

Thanks,
Qiliang

