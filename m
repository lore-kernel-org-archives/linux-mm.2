Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A9CE7DF11
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 18:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116E76B0093; Mon,  2 Feb 2026 13:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2276B0096; Mon,  2 Feb 2026 13:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F308D6B00A6; Mon,  2 Feb 2026 13:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E00266B0093
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 13:31:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B3C48ABEB
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:31:58 +0000 (UTC)
X-FDA: 84400360716.12.4B591ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB6D5A000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:31:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z64+NLzU;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770057116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xyo78MBxU8zUsEU7U2GUhsC/82MXVnewvubqA7hX0k=;
	b=etnK91F4EplxIqpK55IsbUYR4ksuH/JGxyhhqs3ArKe0Xz8S7fY7qjqsEB2aiRpHJkp/eF
	ODUfqPmh0czxGAXtDpimLSGMBKmgG+FlZ6dG9b6uUtmDPS2OWbXgTMl+IftltSO+dQE2Kv
	NUjxI4dtvIZPGlcg1BDpVGYV72g+fWs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Z64+NLzU;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770057116; a=rsa-sha256;
	cv=none;
	b=r62L+y5XmXmCe50K8x2QUJLzjeMbC7ulOpp/ZNHOp+nfXF+PZfzN/ZwaAxMsln7Kl+3WC/
	dcGva6TiRDthfU4h6Svt5MOUALpvVydZVUUUfv/hf97uY3OKDZ1mO6D2tOQD0vzlx2snv+
	1MoUN2w1OSU3qxVZsd0cYxUbcJEp57Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B78074184E;
	Mon,  2 Feb 2026 18:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256D0C116C6;
	Mon,  2 Feb 2026 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770057115;
	bh=R2DT4HWeigHMNhgXBru6V1V2CvzOd5jlqJE3cgcmIZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Z64+NLzUOnziLDC4Sju+bVTSPN/lMfQrg7oFTnaaBLAO0pfvCEOFbN2LWoEgFHGQb
	 tuwQPYYbGfuo4lQ9HuycGTPl8nkp4sf91QenGm+rx7Z+tyvh/fXmAbw37wUAg2C1Or
	 Qi/EJUYhDDtxpdb+E0p9xZap6Of+aB5bn+CIhc0E=
Date: Mon, 2 Feb 2026 10:31:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl
 <aliceryhl@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christian Kujau
 <lists@nerdbynature.de>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 00/30] maple_tree: Replace big node with maple copy
Message-Id: <20260202103154.ad1aa05611c79d21b070a861@linux-foundation.org>
In-Reply-To: <2erbnreqpkyzezjn6ake744bw2avcnb6wjalvwh25desdw2lde@bahzqodw4xsy>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
	<20260131122724.ce19aa2f8260530bd3dee102@linux-foundation.org>
	<2erbnreqpkyzezjn6ake744bw2avcnb6wjalvwh25desdw2lde@bahzqodw4xsy>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB6D5A000D
X-Stat-Signature: 8a3ac6wish6aizwtskbfsnfenz4ei35z
X-Rspam-User: 
X-HE-Tag: 1770057116-262443
X-HE-Meta: U2FsdGVkX19gzwFvA6xDQ7ExSDtvyK4E9dVjcWxJOjpMp+XDW+/gQUARRvwztHBUjy872/bootxtRJh5C7+DUbD0ej3Co+Ob6C8tpo+zkuAmknzaIUHhHdWkHmIiLByST7TAqEgs3+g/9tr0OlwBCWT6GDUcKV4xtX6LQBnHs5rRw7wIFZCd7TzKjoS3BhfzVFuPzd9tt6qjCpcvnJFuMbaBupxwgkgG+qKWjeYAuJqCXwPHhh00hL45M0l5gJfalySWUjf1qlCxpdT3XJGWY9V032CiIhOWoKUHMS8XBS1zpSnk9+jZHd4FTCEKQjzfpqqyuPD31PBGg3KGU0syTDS/1IehHk2050lLalj2sLAk2nvwsetBtpATHOZKjYY+ZtKDYdwSQIkxRsudGQc8GnA38mk4LzyUV7U+nJoEOxeLz9Obi/HIFB61U6HdQtitozVaPIzcgPjTrfiKW8W+ve1M5JintWVPxu+1tJ+rXiVaFbxPMEeoQWU6WyByTIEa8hSPn+3+uiCepNUDXbFEt7oj3RnV4ifeZQmh6M32ghae9KRp/oag3Bvn8EgDoIVK+b5e/bJZjfGVW/qamCmv67vZf7ZT+QS6lKZutY4gpqeRAgXca/Li5YpqpvhXIEUJ4x/tGCuKedm3ITE3d+UG7xhDOubpskypGAgOC3HmUhMOhPc0vwgIWs/HBKCcGz55ZDjk15OHDZW4xGruTIRHgD2ejBmy+KO3htdJF1L7QhVc9n3ksfALinUpwg8cZ5CeKG9kYXqV6rfqWVg9dqQO6eJkeRxzSkwr5Ejs/bQm6PgR6At/xNGgvhZo+TJaqSHDk2xhR67UCAS4GZ3ED5Ph13R7JqCgoQuhPL03odpH/XYAymdoxrYnd94JOlrqPhPE6f5nvsXejxWZ7wCJjJKuA0C9aneCv2pWaeCcJnFp78mxJPTIyn0s3+jT5NoXeT2h6I4gnlDk3GlXpKmndQr
 Wq2vvJw3
 pGKq+zVW095KtqjCOVdjGxz9rQVFOt33o70uSOwAuMDXyPZAsibMWh3lh6SPSEAnY1rQeOXozyAHnaDdFr4R96p5WRFqQGxnsE0147b7DJXWKoImspAi7lt6D0ftU6FJeC5z6QBuW5T2MaBt7EM+kHG7YuJB+sFanXaMULaR9PY2r8YQ0Tn1TU2R8fg4H9ZrPG/tGl9c3GwAul7qVIJePCSlqJJzzkBjoAVE/nE6NJb2nYiXVQgqSwfGmwQVLQXEJDsN/UfVDsKOdIQ1W/44wbeAp1XjuRVhXV3F+C9F9C+0TSFXVD2Z0Wc8YKVnEcfnowod45uMctlLdAlJ56eqyfioqbkYWOwhHSgLbE2RpjygLyhdYsJIjZe/7NcSwuXxYRZ9U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2 Feb 2026 10:40:06 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> * Andrew Morton <akpm@linux-foundation.org> [260131 15:27]:
> > On Fri, 30 Jan 2026 15:59:05 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> > 
> > > The big node struct was created for simplicity of splitting,
> > > rebalancing, and spanning store operations by using a copy buffer to
> > > create the data necessary prior to breaking it up into 256B nodes.
> > > Certain operations were rather tricky due to the restriction of keeping
> > > NULL entries together and never at the end of a node (except the
> > > right-most node).
> > > 
> > 
> > Updated, thanks.
> > 
> > What are your thoughts on adding this to 6.19?  I'd expect to move it
> > into mm-stable Feb 17ish.
> 
> I think the chance of making 6.19 has passed.
> 
> Can we please target getting this into testing in linux-next as soon as
> 6.19 ships?
> 
> The priority for me is to ensure this is rock-solid prior to release.
> My concerns are corner cases and arch specific issues, which I can only
> do so much to mitigate on my own.  My hope is that linux-next exposure
> will help with those concerns.

Sounds good, I'll push this back into mm-new until -rc1.


