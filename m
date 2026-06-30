Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29A7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0906B00B5; Mon, 29 Jun 2026 20:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90546B00B7; Mon, 29 Jun 2026 20:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A8D6B00B8; Mon, 29 Jun 2026 20:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1E276B00B5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:13:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C802A02DF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:13:19 +0000 (UTC)
X-FDA: 84934654518.01.F9099A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9201E18000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:13:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Efq3waWr;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778397;
	b=Rsz5TxGOZ7+vJ1Tel+qqzdaSnNvqFYCBNnJWWMq8bUgSaKqVMmSSCc3G2v6QZtnuPcyCSq
	LMvuZHcgeDLmC9Svl1MvCfPr4XBWeQWpCSde3wuOxJYk4ZWNQ9ysn96uez0nOdX6g80I3b
	+DpXVjUVEbYq7W1SO9yMZea9SaOfwzs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjF0l/h9OZCEgfGf7GrkzYyWlLtuFsVav+p607uCMBM=;
	b=QSvPuE5S1JE/z+xLMPkIegGy+YYMfpSb5yoWYcgu06kEdpxLH2I8sN8C/eQjvyuGrStNpd
	NkReX9Xi7DIcC5kz4Xfn4BfzybWcld3nMm208A6rJx3Y943dNQHjfEQYjQC/bUK75MxYhm
	x8AjPZVWpVIyax2ifjxQWyB+0/57png=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Efq3waWr;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0818160008;
	Tue, 30 Jun 2026 00:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0231F000E9;
	Tue, 30 Jun 2026 00:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782778396;
	bh=DjF0l/h9OZCEgfGf7GrkzYyWlLtuFsVav+p607uCMBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Efq3waWrCIaXPATELijKYmR0Czufu1OT9QZhBjnOlb8jXT3KT/bcwGXu8zYs7gn2r
	 /8xVkA8STm3ySUKB/ZzwQSVefKFsBAhtMdXH6t5qaESDu/RmPnNUqADlJqjqNOuXMP
	 xw25wdJosfDZ4GHq9XMvN+KusUa1Tu1/UQq+9Tk+YGJTbMEvPHwiF5stm93r8HIi/t
	 5DvRiDWXoELlRbay8wLv2E5Q/QVXJ8Z7aj1zPj+BhE/BjLb51uIHhagPcpBiKjNL0T
	 EvGB9NjNs8yn83pgZ4RhMdUeP/U8BaXk6cf0wyXW4Tr0qPCSWH2fW8s59pPhie19fb
	 Px3MsHWTPyRQw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Manuel Ebner <manuelebner@mailbox.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] docs/mm: Fix braces
Date: Mon, 29 Jun 2026 17:13:07 -0700
Message-ID: <20260630001308.140793-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630000620.138992-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q1ewe87dc553ontm7n7h1khdzcr1f1g7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9201E18000B
X-HE-Tag: 1782778397-288874
X-HE-Meta: U2FsdGVkX1+ReGPAdUQvkdYUUnnpXLXX1bFx/l32TYd6DMtPfpJ1tTsg96/Unk0T1HyN9geuv0/ZBqD4cY9LLKq/4FISKs54vjo3s1cxOxPHTBR1BknNpKI6ZZ5Z7afl774HZtklOGilDExqAa6pW7b/FRgHx4HYD5OWY8kzqmwJiueR/mE4RFRkVpLlBo5en0kPQZFOkvFDPnKL0juOYyBQBjqyvcigs4z6A3L6zhqvgc8WV8IqY15n2gXnToZGjNcvvvwbSX7kr+qEGnx+4zpYm5aV7vpHFYt590t+Vk8wYDD6pv5WJTtXmzji4g/OIjIRXDcxhkMOt/LPxAtPATrTASWPDQKFwk6nkiNi3Lo49psX4M590oYuTJJ8GhE6Mib8SpyXTkJRx07CV4PRcpF4EQQJMRiz9Vt900RAOR4xxalXGo6+2qP7d8H1XpTikXYFgOdkDnpsnNCTU2zWJZHVtw+Q8L6zLUINGIubIYyfyzxKLwh2FgYJkhzNx0hEVl1jRTffyjnmixKtGszb6dxoIARfzlQhLlrd7IXmu3fy95J3qfvSjkIJQq8MD1koUi5Ncs1x6LOppCB344IZozLgQkMOcIVeTO7YwXFYn+8ih5HKfvd+ztLMvXD7eixktCcxxbvlEjCdH5/pxIkr4FPPZ6lI6xjK8EiNWgIf/9YfO/UAA5W2+CllJg/SjCyJYwL14YtOFcWCaQfELPWeJQ/gP0ibOSlJQ4HcgdB9uZqummR41DYA0PHdDt0qmKuvtZ1arKXfqeZrbVKeS5/uljdJltppz0b776yl3jFV5SBY7zBIlN7F5EzuDgjf1OUbJYMebQ4G2fkF/VC8JmL70gppIy4TraSqUsDrAoqGMcO0N9ls5sH6hd6DMyNlLiTVDbCDqWyom8N3eN9cXc0w/yqGoWlAXzX1/afUYe5TsuzRppRm3AN88r4gOqqqWRwv6fX4FvIEPhtqIlDweQ4
 1raujGEw
 +qyZNXeoM4Je3bSc+rYFWMK8MS2cjiEaeLyFdYsGfNde8y4xotnnJIE61hkmeS+rZjJaEPnJEw84tykXMrG4FvjDnfY+kRYr2B/CWPWUanENoaVvH/+1qTrMvTJQ+yal/8a1G4Ob1a3WUCMyplhgpWW0HK42A3+VYqooRAQxyNHWBBPy90kzStmvyEVln+8FPoIDUg3I03H0HufaJdk2dQPZkWTdp2OglXm41IE5bD5P/HQ6fTsLyGnWg01RZb2PTkrrVqa+Tu2WEaRWqsX1gECS54qkVmyilSxSo98FpANd0kdOeITDJtd3gVqRN4FzJLA/AO/tzvnwMpAZ/3A4MXmztueoq3NQrIAus
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 17:06:19 -0700 SJ Park <sj@kernel.org> wrote:

> On Mon, 29 Jun 2026 18:11:56 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:
> 
> > Correct typos in mm documentation by balancing parentheses.
> 
> Good eyes!
> 
> > 
> > Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> > Acked-by: Randy Dunlap <rdunlap@infradead.org>
> > Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

I mean,

Reviewed-by: SJ Park <sj@kernel.org>

Sorry for the noise.


Thanks,
SJ

[...]

