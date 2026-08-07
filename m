Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB85C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04EF6B0088; Fri,  7 Aug 2026 15:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B34A6B008A; Fri,  7 Aug 2026 15:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD8F6B008C; Fri,  7 Aug 2026 15:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 658606B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:50:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA3578014D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:50:57 +0000 (UTC)
X-FDA: 85075516554.18.C67FC6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1967940008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:50:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y1TxN7DY;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786132256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGQLBYZ8sXJOnkR3tH0uUyY8O3oqFIt4zUiX/ukeTU8=;
	b=t7THLLuzY5OTFUORqTk5Ji4IHHnKeOBl1HqJN0B0FUwr6JIGht3h+lekafF4zEvdTvrEd4
	V1JH7JFEtGT3zdbc5vZDHVUfybI7zTfB0PDnNbWRDB2HP6MBe1FnoEWuLXHdEsr2ScltGP
	2kS9Y48P8/Hf1xbCQD7h5ncAW7zLB6U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=y1TxN7DY;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786132256;
	b=LTpkcuJKxZxw1vAb5MeMxIMGupRd8y7C3i3E5opxq7E59uV/fhDkXBLUIz6lp5Fe0PJkwQ
	VS0jHNRu+9Os5bnWWDHmDjRXb7uneQrpOqZVKS+uBgJaUGqbXieQdTVTf5kNKRffOq+QEg
	ZzeB2wdNrKcja1JMzy/wl8gpyndD4Uk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F6FF600B0;
	Fri,  7 Aug 2026 19:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55931F000E9;
	Fri,  7 Aug 2026 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786132255;
	bh=LGQLBYZ8sXJOnkR3tH0uUyY8O3oqFIt4zUiX/ukeTU8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=y1TxN7DYS0h5WK8bX+BiCJsu3MYwDVAHCQxDfN4c5JzJNvebxuBW9AdTC1+HhkvtA
	 zPmNA6JtgnATURgkCTCNYYg8+wZFZRicRYeVg2KQUCz5iMBL3nmVwP20D6Xp5NA4WD
	 gstX2HCC0T4ZJsgdoSsoNHqD8mPptk4Ne8r+9YRI=
Date: Fri, 7 Aug 2026 12:50:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Meijing Zhao <zhaomeijing100@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] mm: trace: decode architecture-specific VMA
 flags
Message-Id: <20260807125054.d69baf2c6df589ddebbccd48@linux-foundation.org>
In-Reply-To: <20260807084745.5d96995e@gandalf.local.home>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
	<20260807031349.3119855-1-zhaomeijing100@gmail.com>
	<20260807084745.5d96995e@gandalf.local.home>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: sr95ndgbbh1yny3nao8xcwkqphg9x48g
X-Rspamd-Queue-Id: 1967940008
X-HE-Tag: 1786132255-818879
X-HE-Meta: U2FsdGVkX1/BmeL1q7T8SXFi4NJPLL+pDieYOHkLzv09fhjzM/kvkl0vMpdY3+d/eJaTqHvCx8AUgh85cf2Cr+hT46bMbwmJsdblz8+NM2Xki7XuAp4+39+OJoETjdYP+UaBq/PG/obDUg+M5+2s+iNydmPp4zT2F/JV1C1mAtNomCbH79yd+OAUcIB0jG7sbkiZPqI0vvX4XELzTW06PV7A+PZ4nzVre9vU2z6Ee2gVWaRfH5PvBW7yMfMk2qCx8s5ESISSpxX8J5uV0berg4qih7xunn0OuQtXqTm4/Jm69iIYwqKHE+al8SLArqgzC/HgUI3/yjjBgv2RZN45IRxXhmf9NFJbTqHtiLhe3oFII87oCoWSgvYjApTVLHyFSoRuPNQ+ILzK+AOBih/pE4RkIJ8ckxtmxVizj3HEt9E4zlMgWQQGZJJ3kMhuwYvA3kY3cGWDJoNTG91ttJhXJonxDzv79Bm8HnjUnnxcAweK2bqV7GLb9xFwk9x7O/w282aENhUpQRrM/sZy/f71cue3AcKLYNSXm0W21aG2nVY/BF7zRGAJRKy9lpdEbgBEqKDid6L42zqJW3IPuMsT6MbCfCA64m3E/c/bPYLjWkv+1yWcCJgyrwYnGIIqaE7VyyBDyi8JF2AdLQD5ePqvaStz2T5B6xrEtDUfiX3G0m1x++cLhTAMp5EDqBTgaaaFgde9R6mSfx7rlXtcAN/6uPccbEkshfc9bxGubRgc9Nc4Z1BR4v0gK0syryiP9DbEECAiKSSkMAIuyaeRCCtP8d4xqTkTNHptaIEp+RAr6ILqDU4+fAWqSNt37YfSvJ/bPw2gjUX12/TAKRXzsMh5b1Ax72jFAItokYa+g3a5lvJIaMsBqY3CjJgtlZ1vAKQ7jcplyul+OafgV/FfOD3KjvOJ7k23vYP2kRt3bsVkmtrktRNbBHJEsvOUuxJI0HC/VrKVEe2a+rSsWA1qVp8
 YaRfNyif
 bZgssQYXQ1RgDp06Tuv4M6TPf0g6DFzvEUZS9OiKVyztXRBVQ2ZDQmp+BAbS5mCwWGIJY7MoGa3rlODs178A0yMF8+oL6mHgGccRzRR+xY8/uhqEx9FCb4RUzrhxInHxSqJdM3nYK46rj+6L9Z840RtbF7eLZEsPtZ/xNzzgIxlYhzKQNn74p8zLtoczeZYjxgBUycMchsoEVXR8R3AQLp0uUNtmd/jAD4rfCaRRGTBFHfSJYWmiM1a2efTQhHi0jOiRUs6HCmraIMvTtlLMSusc6hKSXwSrwr+N1qceH8vryih2kTt/96N96YXkQRzy9p76NNSWAVJ3fbCx0iRYLwM2GM3jpOEU3m81qjMX5R2cThoDB2zkEf8rnPib9YdMb1L+XkIgerwalhRWUEaYsE3Jlry33kQzLokjL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 7 Aug 2026 08:47:45 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri,  7 Aug 2026 11:13:49 +0800
> Meijing Zhao <zhaomeijing100@gmail.com> wrote:
> 
> > Hi,
> > 
> > A gentle ping on this patch series. It has been about two weeks since
> > it was posted, and I have not received any feedback yet.
> > 
> > Would you have a chance to take a look? Please let me know if I should
> > rebase or resend the series.
> > 
> > For reference, the original thread is available here:
> > https://lore.kernel.org/linux-mm/20260723092905.761037-1-zhaomeijing100@gmail.com/
> > 
> 
> You may need to Cc the MM maintainers too. Not just linux-mm mailing list.
> Modifications of tracepoints in subsystems belong to the subsystem
> maintainer, not the tracing maintainers. We just maintain the
> infrastructure, not the content.

get_maintainer isn't very useful with include/trace/events/mmflags.h.

As it's a vma-flags thing then cc'ing Lorenzo Stoakes (ARM)
<ljs@kernel.org> would be appropriate.

We're in lockdown-for-merge-window mode so please plan on a resend
after 7.3-rc1.

AI review made a minor comment regarding the changelog:
	https://sashiko.dev/#/patchset/20260723092905.761037-1-zhaomeijing100@gmail.com



