Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 567B2CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 11:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A30F6B0088; Thu, 14 May 2026 07:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853E96B008A; Thu, 14 May 2026 07:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769B36B008C; Thu, 14 May 2026 07:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66D616B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:07:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F2D2B1C0727
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:07:20 +0000 (UTC)
X-FDA: 84765749040.24.D81E6C7
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3A416C0007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 11:07:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FSkv2BFN;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778756839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ajRUalzhgnnfvlPn0WFR2fLEgViH6plKkchspfix3c=;
	b=0cqAErM0tt/n++pJQz+yaZyxhNEJEHnT1+80bniheHsSXuCDRmkTgER/4Au+huuKdOCxpF
	9GxLiz2PLjH4nxnGm9relt3sRH5gpnMiaQdlgQSmB+XOAlO8ip7eXk8tRO1tbbbz7aSYVs
	o8y/74/Ud0KpuPa7zwSusQfwWAyvbto=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=FSkv2BFN;
	spf=pass (imf22.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778756839; a=rsa-sha256;
	cv=none;
	b=8riKYtvBI+Z49uosDuGHiC9ajbCcSV30Y5oBej8I3MVt0MukpT420DoOe2Tbmyq2tg9UYK
	FVgvuTBFT1HgWuJ/Uj/I/5zLqi6QN34lc2hTpgDrK3lrAoppPDmWxoXxkyrjzz7QzTCkCZ
	3YpsbFKOYxMtpZP6fq48qOUA+84bGJ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8ajRUalzhgnnfvlPn0WFR2fLEgViH6plKkchspfix3c=; b=FSkv2BFN8Uucm7POm/m+FRQU/f
	OKnEJNeRs5TovgCDj71pFKXBJ1ywjwTYpsPkhqP9CZJSYJ2pJwTrRoWL15Kaz7/MMYxMntaic2dBR
	YWzDWy8dFIHIw5lFZC/dpG4I+/ayRH3T7wofabgAeBm2v8IZqoGuF3ep2U5WdJxuGiIevSKY5ovUV
	PD3MK0HHzJHnjLAcT2nyMQDmdsvV/0brczMU5K6/j0LxqEhDkA6JWF034qbFbC82lluwRPT0hgXgz
	QVNwSPf7c6MuOxJy4ycOlhxtvmO22G61aJu46aH+Dhl//jaXkvhovISFZBaHZaZKCfruOsjKVAYPn
	+t0uCj8A==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNTu6-003tUh-22;
	Thu, 14 May 2026 11:06:59 +0000
Date: Thu, 14 May 2026 04:06:51 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v7 4/6] mm/memory-failure: short-circuit PG_reserved
 before get_hwpoison_page()
Message-ID: <agWrHSXGQzZPEg0L@gmail.com>
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
 <20260513-ecc_panic-v7-4-be2e578e61da@debian.org>
 <511dc52e-f2af-43c8-a9cf-19321b091dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511dc52e-f2af-43c8-a9cf-19321b091dbe@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3A416C0007
X-Stat-Signature: jx61sc56k4heewsoukaoz5zh8cqy8exh
X-HE-Tag: 1778756838-710821
X-HE-Meta: U2FsdGVkX1+vuECaxsRtz7e5tdYTKaOhCmwhjuvNBfMFbt9/0c4JbgnunCvNnWSvqc24RBUlBN2OmpKlvBzsV1/bEQ5IsnJAsjuti2ZlvNmsk7/yfbVVV8J2Afr/lGoxLCPw7r3xZ63xigpaXDlroXvp1eZHIXsRftmInJvWxvbYknuXcU8JLzTDKl2ddx24NMViVgE7+IHqU+uIJi3/C5P2/se0C6aLQ2wFi3o0HH7m6ImRKa/h02XW6SeNRnnwBvWh5LIcvisv3zI0uE3l9wmby04f1paR4uDoIfTkmHSKoEzhm6j75MJ3HmtYGkdF9Sw+mOIWCry4kd71qHgEJB02dLrxq46MOIOwDdBqiFKy744CW3wEjKdxcT0auvdOfUORYxL0TrtjMmYLqfpaejcr4hb/Hg/ez9awrEgBJxmB8V7vfAIaR3/NXeNOqed502Eg6/Y7Zn/YJQZnaalB+GHcvhkLt9pMtnvBN0k1gVedUNzKLVYzPK9pj8fWNx/hs+vc/ljbktdOms4nMf2rJWHsxyVzHTp+ccIBC1LPOexvbn5E45qj26fUsSHZdGAT1VNQXcbX+OY9asUoJRuftRTVXhp5Wq/eUnw6Uw9CfBVHz4myjWF/g66B8vdIpprE43e8e/itpuKo50YIGPyUhfwPPynjMn8F9U1KZB9beKhcjYFDm4lopF4hiGiZFjHyd9F5pZvm5tCdUIqo6f9GLtN61FHVcDmgA2WJxsDmZzQX+vev+l4b3beUOUvu9HSOdbQk4bORTttJdRhNf+U/ksffLeMAA9vgp96ThPAN3pOILV/eexxIAPbwxlehTxZmIbDW+Zvfl0IOE2vjWeAbTG49n18d0lLAWbnHhrASFdSyIL+QYhFeOOUX+8vBT+UgbWDYaomHxF0W2OgThXfCH2iTEw3mf8Hka+YhgnH1gFeQRLT8p4xLbjS157lqo2+hnTjsEJX53qNukVB3Y95
 DvP1gPDq
 Qu26C1Ed42CGuzxQNUJRWyT6ndarXRLwxnzfoQ2npOp4Ho6HjhAX60kHJtAf0rSi4zURjjU7qLfa9i4T+90vwfLcIN0+yp9/baHDj5gVxaPESQrjvJwmyZ0RS1+jdtu04qD+S0agU3McT2em8OukHA/7dXFg0eraO70pA9Uss+t9a/FK4D1yR0S3IY3XWf3QWStn95r8WVMpgR6EySOwKHjiC/hUPvOYFrYQtJ2NyHhRuEQaoML/thFwwr6BdptW16VZ7LVnpyOmbNbTAsipyoTtp/LzVH9GzwS5Yq0vAriB/gL8D/0Thjy2mPQl4wT8NBXm2fA+zYRsCEE5p0/KEnTG2RrlsNtfHuNVg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:49:28PM +0200, David Hildenbrand (Arm) wrote:
> On 5/13/26 17:39, Breno Leitao wrote:
> > The previous patch already classifies PG_reserved pages as
> > MF_MSG_KERNEL through the long path: get_hwpoison_page() calls
> > __get_hwpoison_page() which fails HWPoisonHandlable(), get_any_page()
> > exhausts its shake_page() retry budget, and the resulting
> > -ENOTRECOVERABLE is mapped to MF_MSG_KERNEL by the switch.  The
> > outcome is correct but the work in between is wasted: shake_page()
> > cannot turn a reserved page into a handlable one.
> 
> If really required, can we just move the check right there, into get_any_page() etc?

Sure, we might move it to get_any_page(). I took this current approach
based on the following facts:

1) Lance suggested it, and it sounded a good idea.
	https://lore.kernel.org/all/20260512124837.38883-1-lance.yang@linux.dev/

2) There is a _similar_ check close to this one in memory_failure(),
   just before this one:

  if (TestSetPageHWPoison(p)) {
  	....
	action_result()
	goto unlock_mutex;
  }

  and now

  if (PageReserved(p)) {
	...
  	action_result()
	goto unlock_mutes;
  }

3) I wanted to give get it as  real layering point, not handwaving.

That said, I will short-circuit reserved pages inside get_any_page(), in
an updated version.

Again, thanks for the review and direction!
--breno

