Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79031CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A2356B00B7; Mon, 18 May 2026 20:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853A66B00B8; Mon, 18 May 2026 20:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768706B00B9; Mon, 18 May 2026 20:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9296B00B7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:54:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA99140116
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:54:58 +0000 (UTC)
X-FDA: 84782349876.15.6D5C22B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2275E4000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:54:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vK5R7wNW;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779152097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kXOFniQFsgPgOVw2tqKJudy/66bz7juRJBzvWcnifmo=;
	b=vEO4bSRGEBUHq0ZvWNA1jn6TYL0GCaEhuxzNEZ2couefbqj+mfIuSg48HL2aE1C6k6YRWG
	l4jTsLaKywaW4uNJ7T31qX1K9CEKc4YmpHWkBINFB5PMlZS/qcaN2gTQqlb6btgEScDsFS
	hq01HlU5sHBi5Nn07+7Ci+tqRxSuuZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779152097; a=rsa-sha256;
	cv=none;
	b=s00Q8qx9RYLiyux9o/Z/PiYZzpj3wMQCU7Cjp/DdqvzWr7aSc+jvjDmwoKP/BkNOOmyFDF
	J199/uIZ9W7RstBoON5n5drAsr3JH8NBJwX/dEh+ZmpQZkTtBHDE1QQiftI53X9GK9BE0t
	g+7ymD0lb2mKpIhTjb8WR5THjGon5aw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vK5R7wNW;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26F2B4439D;
	Tue, 19 May 2026 00:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70072C2BCB7;
	Tue, 19 May 2026 00:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779152096;
	bh=rjK+kkOfq8osA8oY6NXr+4d4KyeVsosRN8eq39UvKYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vK5R7wNWdyEsDjzjeRvL9vOaPwLXy7ax6Zxw3caXnzB5E8TsIepJzz/Il/kSIGVUC
	 sfszVBboFtw7yIBMCrWn3ezkcoqZGFJFh2OFlcHNuPGyX/vmKwFntLlLQh6/S+eRvq
	 b7qAcfAcU/jRgIdb9kPwUMSoFBtmUmUHoJSrsDkA=
Date: Mon, 18 May 2026 17:54:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes
 <ljs@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike
 Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 00/28] mm/damon: introduce data attributes monitoring
Message-Id: <20260518175454.d968f11139f64c3b8d93a5c3@linux-foundation.org>
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2275E4000E
X-Stat-Signature: u55tcfa4smncms8noq31mmd8inkom6of
X-Rspam-User: 
X-HE-Tag: 1779152096-164520
X-HE-Meta: U2FsdGVkX1/Dn6AP9d1XT2sXPWt0nMV8/HD/is9YRejZq4BJOsiVvRIogcbAhDkHYnZIuHzvhoHaeyDQAzIF87z8TvRW6BzGf/dUTzCV6+6F5HViuYJ/n+/NY7SsKvar+B8UFtpC04vhvgxeOrwQMPlhUznKmMRG5p3TpS667vgBa7Quu23ngFCfJ/Ex+Q4gJ4tUMhubEs1PE9qsT0tOBjtEWKQGvyfUr9hwPwTNPDLFYbb0tcPwlFRJTSBz2V/mmAV56XIpNdF8yXALbyfqQY47XkoJHvfz0jdEV0A30YEnRgjKdzjhgmw4urkbebzQwf7KF9jUqfzn22UHBbhE18R0zKxFYtWSlhnEeSg0LUIiMZ8gOAa/YbzaL+Mw6ViIjibpHwEgPSM7UEJC2G7ynlKBPg0OQxPd6NCTYy7G2sPDhgyYS4sSCxaWfqg32FEkm+FM9LtgkiSbKLcJX4VaTAa/qDKRrloSSOw/XFV8sc3q1nUtF9Dm1pe9ziDsMrOShRdddnnen8t2+ZLKUdobCSzK6RGKPgZa5PS+3tgGJLQ2m/t0rBDkg0JcJRNNsBzUJSbPHh/yHx5vCSVwA30j6gPCS09UJV1UyzdGSaPCnl/mqLTO8fWNVUsSyINph/UWWSpMMPF145NBUKylfQ2dPrGxzRoUnCDwS2evATstmmoik738uLayaacXRzSE4CQPxiJgnpVX8A9VMA8idESEfv5GKkh3Zcl3BR+fS/VKpCnYOAIUEdCZBrPyWL1hS+lSXX+l4Ip5hdYaay8jX4Mt+hOZByjKVpfVrwzM7RWw1c7YtC50ClHoTkKxG5iuVMMrXo1Txu02FPmlR++UH/7IlwtuqXEj9XUgCeCFSI/IFvJs2li2tPrugizl1/PMudNM7JLHp1Tswfxn2rWD4hi/AogfUqN4wgDyUW5UJo3KqFP5jdq/jij9sXIrPkyryXKHIzNp0UEWFFU8Hm40ZZv
 IugvqTak
 fXxM+gWj+HCESRG9Mp1l43WJ2wj1X1YhovA37bNgRh4LM5AzbXkanrThsjaPcr13LlUD7BLkwvTpII1GFhYJExYNL6U7uXnkY/39rUeGPEeiSNQw+NIm90PEi8wPC2Z1tN5dTZNnZvVQPKXcREjLGuIHr+DStb8RmVjnzGlxilI60Jh9OJbg7WIRk9ci9e02XhvPkWSYIBnxn9dyLXzyqe2WowKBkCk0Gh0QUt8utFZol4YiF5MI4fCb6MLGQ+5bwY9adz2rAx1BaVAvBO9DrTvRrlevlcN6wtwTMgH7LT8vh4fY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 16:40:48 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR
> ======
> 
> Extend DAMON for monitoring general data attributes other than accesses.
> The short term motivation is lightweight page type (e.g., belonging
> cgroup) aware monitoring.  In long term, this will help extending DAMON
> for multiple access events capture primitives (e.g., page faults and
> PMU) and eventually pivotting DAMON to a "Data Attributes Monitoring and
> Operations eNgine" in long term.

Added, thanks.

> Plan for Dropping RFC tag
> =========================
> 
> Making changes for feedback from myself, humans and Sashiko should be
> the major remaining work.
> 
> I'm currently hoping to drop the RFC tag by 7.2-rc1.
> 

I removed this section.



