Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75BBAC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 10:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCFAA6B0089; Mon, 28 Jul 2025 06:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59586B008A; Mon, 28 Jul 2025 06:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B247F6B008C; Mon, 28 Jul 2025 06:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFAF6B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:57:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F8781D58B8
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:57:12 +0000 (UTC)
X-FDA: 83713371504.04.E30A1F0
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf08.hostedemail.com (Postfix) with ESMTP id 98DED16000A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:57:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753700230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5UpYzpn7VIXBKCEFcqyopH5PUot+b66OXxIj+HGImKk=;
	b=dohVDwk+dZXzuceA8w3fVgqryBN4cR/J4gPkp8wkiajgJBwgX2yP1XhHR5U9ufMlxCAhy7
	U+ayYhduYkrHPU+ZT8acFYXGsj9gR7TnWMqJa60E/j/+kqpsA/coWfCnUZ81k2XEGOBkdO
	SsSvtLF0J5G9y1m1OhMlEPWgGXz3AgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753700230; a=rsa-sha256;
	cv=none;
	b=1yntwnTgjXjELHqHAXvAazf41i88bTF8FFG4mCw6OG+aPek2F5bZHqZVcnT1962gew1gmy
	sdRv/cLcKx8f3m8MLcGuZ0YASXZBs5lzlIhr2ytvQ3VzNiiaUFExRJ+cZ1vq8PFHg/at6J
	5uX/mlYuGABcKZWcezSiAHjZlaONqLM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-681ff7000002311f-ea-688757822918
Date: Mon, 28 Jul 2025 19:57:01 +0900
From: Byungchul Park <byungchul@sk.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, asml.silence@gmail.com,
	bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au
Subject: Re: [PATCH] mm, page_pool: introduce a new page type for page pool
 in page type
Message-ID: <20250728105701.GA21732@system.software.com>
References: <20250721054903.39833-1-byungchul@sk.com>
 <e897e784-4403-467c-b3e4-4ac4dc7b2e25@redhat.com>
 <20250721081910.GA21207@system.software.com>
 <8b6e6547-cb39-4e64-8dff-6e16e27e7055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b6e6547-cb39-4e64-8dff-6e16e27e7055@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaWxMURiGc+65c+/txMQ1imMJMWJJpbXE8lkifhBHRDTRkIxYJnpjJqZV
	U6qVkIuJpUwVLTod6di6IWWq7bTpWLraW7XkqmprUEQVVU1Hq8wU4d+T9/2+5zs/joC1HtUw
	wRS9RbJEG8w6Ts2qP/Y7Hbp75T7jZPtTAEfeRQ4udMVDVrNbBY7cQgQdvuc8/PRUIfhaUc3B
	h/J2BGdPd2Jw1FhZ+Jb3HcObKi8PF1xLoSmzhYXSfUUYvIdvcWCzdmPw+Np42O3OZsCRL/NQ
	W5ikgpTv5zEUyc08PCpxcNB48acKWspsLNy257DwObUCQ1PSfKhyDobOu60IKvKKGOg8dIqD
	J2klDBR4nvBwrM7JwStrE4K6ci8LqT37OUjflYSgu8uvbEvuUEF6ZSM/fyLdpSgcLW/9hOnV
	nGcMVa7dYWix/QVPna6tND87hCYqdZi6cg9w1NV+lKcNT0s5eutkN0uLX86ixe6vDLXtaePo
	lzf1bHiwXj03UjKb4iTLpHnr1MYTn9/imLeq+N7STFZGBWwiChKIOI2UlGTwf7m7MI8JMCuO
	JTX5KX05J44niuLDAQ4WJxDX3st+VgtYvMqT1I76vmKgqCe1sqdvWSMC6XH7+MCQVryHiPNK
	+p9iALmd9rrvMhZDiNL73p8Lfh5OsnqFQBwkziOlR36PDBLHkBuF1UzAQ8RmgSTvyUC/XzqU
	3MxW2GQk2v/T2v/T2v9pnQjnIq0pOi7KYDJPCzMmRJviw9ZvinIh/6fK3NGzyo3aa5eXIVFA
	un6adzP3GrUqQ1xsQlQZIgLWBWtizvsjTaQhYbtk2bTWstUsxZah4QKrG6KZ2rktUituMGyR
	NkpSjGT52zJC0DAZLbbph1obrEneNnP4gQVzHJsfRySGLoOmjtYz+aBvWbO6fNQMye6V792v
	HCmn1vrqD1pSHs5eM0N5lTtixY0iU3VoY0H15iUfuurlM5U153omTo1YpJePRWxfeH/n9enJ
	L/snXPoR1nDowXtrGrZpx9XZFlYej/cktvPhk0/S0abXOjbWaJgSgi2xhl8QJnYFUAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTYRTHee5zd+91tbjZqovSl1VkUlZQdKI0C6KbZAQKgRS58tJG02RT
	USuYL6ll6iwlnYtmoakZ6rQ5dfYyTbOiZGFNK996sUjMdzTN2qzIbz/+//M758thsPsNkQej
	jIgS1BFylYwSk+JDO5M2Jh5JVWwu6l0FhopyCu5MxcLtXosIDGVmBOPTb2n41diCYKy5lYJv
	TaMIbhVOYjC8TCZhouIHhk8t/TTcMQVCT/FnEqyptRj6s55QkJE8g6FxeoiGREsJAYZqLQ1N
	19tE0G7OFEHOjyIMtdpeGl7VGyjoLv8lgs+2DBLa9KUkDOc2Y+jJ9IcW4wqYfDaIoLmiloDJ
	y9cp6MivJ+BeYwcNV+1GCj4k9yCwN/WTkDubRkFBQiaCmSnnyiHduAgKHnfT/hv4BIeD4psG
	v2O+prST4B33nxJ8nf49zRtN0Xx1iTd/yWHHvKnsIsWbRq/Q/LvXVop/kjdD8nV9O/g6yxjB
	ZyQNUfzIpy7y8PIQ8a4wQaWMEdSb/ELFimvDAzhyQBQ7Zy0mtegeeQm5MRy7lZsxVxAuJtm1
	3MvqHNrFFLuOczimsYulrBdnSql0spjBbA3N5Y53zRfL2BCuXds4L0tY4GYt07RryJ19jjhj
	VcHfYinXlv9x/hpmvTnH3FdnzjjZk7s9x7hiN9aPs2b/GVnOruYemlsJHZLoF9j6Bbb+v21E
	uAxJlREx4XKlapuP5rQiLkIZ63PyTLgJOd+m+PxstgWNv9pvQyyDZIslX7anKNxF8hhNXLgN
	cQyWSSWRRc5IEiaPixfUZ46ro1WCxoY8GVK2UhJwRAh1Z0/Jo4TTghApqP+1BOPmoUW6lVBz
	JR8lhEvyszpPsPsGCx22FQ+EpT17yh9Juh6lnchZbc7MTl2UPhvcR2FputdeQx9Oq9JVljc8
	VsX/xGuiRoJHJ4LOBnv4t+7JO/cioDSw7+7Fm6G6yI4gsdtU5aolxwt2H6uasAbapbpDb9Zv
	e99+9ODUyXSywdf3wIVsu4zUKORbvLFaI/8NkQW17zIDAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 98DED16000A
X-Stat-Signature: ydfwcassb36h1jf637mh7k9bjnznr4rt
X-Rspam-User: 
X-HE-Tag: 1753700229-682686
X-HE-Meta: U2FsdGVkX18paYL4NvBlshnMqLmFAaGjBHYqUwkIlY3h7a8M10PTxxdAUCGMeMQpCs9XUGQQ/O6dNl6/hxHmz696O314/ZofGyQ6M4SyTvkT/BN0zifdrKM4UxyK0wF6ylpQ8FLpUlpCr7JwzMi0boc2gGaZcyt2mVN099TVz6HbUsaC0AmSJNeGPz1I2gHtZnxC7gdubTc8Ewk4V6snJaM0KSMTKq8ZJw3mXfZW00rtNM7k/7s0A1yMrjVSEb47iHxf6MYGbnyGTDFmCpg2esT9rHH/Iw+73A1rhYcZpEiM33MPWufVMDjd82DsFB8QPaYRYGtRSd9jJxPpML873pQeIeGnV9a8dLHGE1GizqpQ2OT8YnKha7xq/GelzyJdJS8N6UQ4b6dNWIDn2CJA5YF4ceCaE0cxuTUagA2/lt/mdAW94+MfZ739KxaH5+XPn2or9NzcP3NUvxfDxaTJZ4kvrX0Bbxb9sEanZxHnRlq7FYYs6mgihxbxVGkehb+qr/jjC31uL3bZ0JtCKmKdqLHETmek0eIMr4/TVfvuQjgQckCdP0UuD71j1nAYAYkuTyGs+yWOYEEk7Zv580NmasLoza9rVK8cNBy4LCPLdSyOGoNaDogG43BP6c8d8lw9j5GZ5/o2PuCtvMXGCzkcXws3EVw+B/zo/nE6M0P0e2h4pSWGzNAGXQ0AMyWDAxPU2Ckk02mLYcwFNhRIeEqAwnkGCgMZD7JMmXbyJCmwidRj6AHxhV2PZnsqQ32awDG0J+6JJtkL+rOp5vAOfhq47KFnoVZ6rlrXMtwcRLsXTpHPHgdgHzYkmxS+6xFNpm65ZqP6P+gBp0mmbMy74u3MC3ksKlKn5bI5xJwOOzMnqZja/XkrkyUqsN7xRUhlNhGvCDfhLyQrOfd0ws07Z48qTqSR0CIvhwTS69yAgyf/892UwEOXvsaSU9XZdoCOwv57huWhKojZ34txChlQJMG
 bhw86vUH
 wvYweXxFP75Eoq8Ft1ZJWIX3lkhgDpCCUizZ4YnXTWVLJ7bfHwgBJYf/2A6/xBZL914fZasXZcLsSKd2kZcOh+REY5lcuLzIL4EE98XXggZASU/Hg2polNXTLlayIz60w8yB2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 10:49:37AM +0200, David Hildenbrand wrote:
> > > 
> > > This will not work they way you want it once you rebase on top of
> > > linux-next, where we have (from mm/mm-stable)
> > > 
> > > commit 2dfcd1608f3a96364f10de7fcfe28727c0292e5d
> > 
> > I just checked this.
> > 
> > So is it sufficient that I rebase on mm/mm-stable?  Or should I wait for
> > something else?  Or should I achieve this in other ways?
> 
> Probably best to rebase (+test) to linux-next, where that commit should
> be in.

+cc sfr@canb.auug.org.au

	Byungchul
> 
> Whatever is in mm-stable is expected to go upstream in the next merge
> window (iow, soon), with stable commit ids.
> 
> --
> Cheers,
> 
> David / dhildenb

