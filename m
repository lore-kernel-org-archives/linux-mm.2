Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A59ACEEC2AD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:28:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EC26B0005; Mon, 23 Feb 2026 18:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106AF6B0089; Mon, 23 Feb 2026 18:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34E46B008A; Mon, 23 Feb 2026 18:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF6856B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:28:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AA6C57FC3
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:28:30 +0000 (UTC)
X-FDA: 84477312780.15.902F3D7
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1CD3E1C0010
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:28:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U9I3TT8y;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771889309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLOdiaqX3yPW7m0nfesCXj4Mjr6o8vyaIg3hDRZrwfg=;
	b=3wThLq5VW734cDZPdSbN/ghhPW2QUgV9Qqpov9w9rbqJl7+1IImIODHW2tOfTa/KCJkcTh
	D2vEhszrH1jvlr/3w900I3/+thd05b+RgXMmknTMLcVUTfZwWvtfz9bqUcKMowK9OfY1Zq
	C1ia+uceaLDBZCAhAFxiW+D16fPPkEw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U9I3TT8y;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771889309; a=rsa-sha256;
	cv=none;
	b=07wopyC3xqlZ/K3JmDo+R8yu6jcGJ1No5vEGoq58GqbYkaEr0rBCRIK2BmW5e65lP3/Yx7
	gzLsUm/X64Slmn9gDB2C/zmD6MZCoZIni4oe6xRwe+wK/KtdgaYjXLSJ3GXEIqApBjJZXU
	OEY5mgXdMdDtgxKNcj3kxLDjryYvjjY=
Date: Mon, 23 Feb 2026 15:28:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771889301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GLOdiaqX3yPW7m0nfesCXj4Mjr6o8vyaIg3hDRZrwfg=;
	b=U9I3TT8y7+uV4deYZUwpc4lIdgTCMA8gOEmXftR1Fmaq+hNfql6+1u3cYtPTi8xDkpb/8y
	UZpwFxw/9s7pc9xorCwqzRuZJawv6q/Xjd3SQ4PubC1AuBd9EVXJc5/ZQNf6ZH4rDlxEU+
	Q97zILbWyMtZuFl4NOxk2bX9/BQBdtg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/4] mm: convert zone lock users to wrappers
Message-ID: <aZzicQS19G_WeL-J@linux.dev>
References: <cover.1770821420.git.d@ilvokhin.com>
 <7d1ee95201a8870445556e61e47161f46ade8b3b.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d1ee95201a8870445556e61e47161f46ade8b3b.1770821420.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 18rjwwyoe7aa6pfa8mskmaaqn5nmjbxa
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CD3E1C0010
X-HE-Tag: 1771889306-901349
X-HE-Meta: U2FsdGVkX1/t50R5HxgDvmbCZQt2MtEZR71WEQvJaAKcat1u7ImsGvFHWeRVKeXK7MdSvdQ0bhKtl6ftGQfSkdV+LRZmqpBUK087ay5HiIKV4p8kTP5ZNNlwu77DA/D+Vs8GHKVNE84Br9ioIbXFgik9D4CIo8cN80uE8chmsm9L8MepgThlIvTk0y7JrT08ExeZhik/gzavltAbabZ8qAem+djPjxo8+wfu1sNZz0h/ChDmpl3WdsgYA2M2L0+6TXWuiTKcKz/NNZwv2w7H/wOEpjvWPzuIPKEHWx2YdD79NAuICPqMDS7W+KGnQey5YYi8SxOcyqCt+/OeY3DxVcmdxBv3OH35VM1kZeMAD6cnxBmM3QAR72r64IaMv8hANHpkWOJN65gIXlsBhI7/5nB01b3IejLLjrtByy5dT83EBR0Gtr9Ka3CJU2qtuEwvObv06XE5ve8FirGd8J+HT23/FCT2/3lceLZ8YHPenCtc4/IOcR+xkPGVrgp3B12pq68Mk9rJiT7Y6HC2aRpON8WreB9CmLbvVfNYJ2VP9T+sXuUMU1kPPG3SqisMCUh2IxeS34IM0LpO2YLkHhnk1J2w4XEnH0UlaJRBVEZbFyb0Gn6649Mg72tGK51/YyvJn6IxIaQLvYBr6/1b6C4HChew7EVCvqLe43wijBiCpJOhnb/WyRxzGxF45wbkmW+nX1+F8WAsVWTSV680ZADc40ctLriPsNQgEXdzVb/s7Lj9wUWYceLmUsRXEYoQklPN0OvSCp/j1Ru5mKjbkVZaovNv5Jy3U0STlQ9G6I3VFKlcRS6TLo5Kzyp+6+roWLXwoxoJMMd/od7lIvhwJ+zVyG0nKUFFHQf5/skIJZmK5HlKjF5eLVbGzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:22:14PM +0000, Dmitry Ilvokhin wrote:
> Replace direct zone lock acquire/release operations with the
> newly introduced wrappers.
> 
> The changes are purely mechanical substitutions. No functional change
> intended. Locking semantics and ordering remain unchanged.
> 
> The compaction path is left unchanged for now and will be
> handled separately in the following patch due to additional
> non-trivial modifications.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

