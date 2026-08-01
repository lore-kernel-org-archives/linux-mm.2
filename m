Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67CD3C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 00:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8326B0095; Fri, 31 Jul 2026 20:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FBD6B0096; Fri, 31 Jul 2026 20:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDD86B0098; Fri, 31 Jul 2026 20:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F35EF6B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:03:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A8D51201C9
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:03:06 +0000 (UTC)
X-FDA: 85050750372.15.00E833A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8A7BC000D
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:03:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCVvSJdV;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785542584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKe36ovYx0ZIRWZyBdCD5oqQviaXIOCy9RWreiRdHts=;
	b=ACxd68XFGQndZ8y+USls/ZITm0atwq6iiDgz2Xhx7qTnEh3BOGeAQqWqadIymh14aL04CR
	r6z+zZ7JC1tx2U6jTEcNKaI1wq6iVUGHu2Fv2B8vv5jAaG3fnA2/IvpCJ359omwdJK+bd3
	kylrDBTr7XWoKw9qzATkN/Ot2PucGiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785542584;
	b=Q0tfVZlANZRTuf3nyeTXJkLeqroMP0ND43SYu4L+f3mIUBSbBgsB/Fdg0rXH7KkEkYrTbl
	8OtbXgZaX3JyOWQgHAxfwtMRA+fOeBfd+a49mDJcuaaOHEjytu+6fTwMp4oBcaYkZX7M6o
	gzNMeOps5mNeNCX2SqINkktGVo4siq0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCVvSJdV;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E32FC43A78;
	Sat,  1 Aug 2026 00:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9C21F00AC4;
	Sat,  1 Aug 2026 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785542583;
	bh=kKe36ovYx0ZIRWZyBdCD5oqQviaXIOCy9RWreiRdHts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCVvSJdVnbUQEK77KUzBs/Bk2LG9oTBGvBRgRHfTrvgrnx2HJbuZU0F6/ecmMh3qN
	 GArXeBh3QnH2IRie6698xUPhpXwnT5Wmw6vu0qrBvA0HP9P0acjTvCwqUkfY0VfQsd
	 8qEsHGHpinbA2essXEKq51osF507kZmLvbHxMCh9Z31YST6OMTGtyo87ydZcpIcgX6
	 pnxw7kAtkEK7eeT2uoXhC2f0U+/FyPvdxy4u9eKSm0VnPaBEJuEiWYpowGxfnoJNsf
	 T+r9wLz138TXlZf85JV97U8TSEdsRkple3QL3Y/AKW78kIuDjLtimQ0p5QDhg5jDWV
	 TUOA7g75W9oJQ==
From: SJ Park <sj@kernel.org>
To: pratmal@google.com
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	corbet@lwn.net,
	ljs@kernel.org,
	skhan@linuxfoundation.org,
	anshuman.khandual@arm.com,
	gthelen@google.com,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	liam@infradead.org,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Brendan Jackman <brendan.jackman@linux.dev>
Subject: Re: [PATCH v4] mm/page_reporting: Add page_reporting_delay_ms module parameter
Date: Fri, 31 Jul 2026 17:02:53 -0700
Message-ID: <20260801000254.77032-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731193705.2902728-1-pratmal@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8A7BC000D
X-Stat-Signature: 8b1knj6ggpyg5ca7yqukhats41oo199s
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785542584-718253
X-HE-Meta: U2FsdGVkX18Sehld5Q/6SoSr8Zt93dvz56tewDfEB18on2rydNWq+KSOW8lG8eCrUy7ifXBOVuO6QSiMBeo1EuAM9fLAMYtY2I0mF80RHF3BAz2zJi57MLIuR2Tk4797Uya9v13hW9Y3GzHunGsJNH8db7VRmoQgEUsFDA03w7xyqpGEMdlfvNVfQyrrcxif2zuRTJsrBRqGeATte35l1xroQWGwO7AiT9/WFvOcGlyBJTIxAWBytwEmd70+2vZiP05vrwwJiRC965TD22CuB6vJ9k09MzW60HDcNNZFCpRfwVk4VDvNSBf/4SkB6jGceM6bYMQ2PiceZf3dC876CBpIU9Cb91kJFr5wnR84/gava7GON2NHXk1fWRi1QT/5c/HsaIfa5TAkUCTIdO2lknyngV1rsvV34N75YV1DGgmaYJ67YC3HhcrqidPeTzFtaGGSsb4ioMXgIqIo/1FSQpa6x0WLxeULojf12f3qEFPTdBXn4MAPtEpNCm4MfyOsQQAYi+PKUGrnyEaMQiyxn8z9B2yZg181OSqWwvVY4HTcIMcwtIyymMPdsGOmW2u42xzC5HcPtcEa5HVEuMSngGu+IpCmJzK9oGASc4bb/DVICqcQARAZi7jkt4FYRgnM7AYuheR9xjh1OlV31eab4tYnh1nN7PdP8nsZGdAOLCDyKKk/cqhQhrhMI8vRzghQDaEt7Sj68rWqAi4+wXHtEK1Y4FMd22U7fqhiYvSPLVgpJwWOhVtiS5YYf8n94f1v7/O7XqCELQgvwTvl3/0sC/Z0uqCzqlnZYNawuLKqZr56aYBOjtwwdHrF/eCAo/jTla3i2AeCuj3gt90/tEt0rfaRYN0rB1SwfN1+mJo/IBfm/P629ECpoEKXLEpz158d5skKoo/Wjq2jnpyu/N3JJnv8/sE/dT2ri78qcbgHmoy00AzyfjdWmlsvLdQWoXpl3ckQDh9vRpcJ5CXTvd8
 2TTkhf1+
 4ma02nAVlQjCRu85udrr9+q7sfSP7ircolgPfgi8W9z3vKCKfbykudtgQfP4O6zc5w0dOprhku3TzH5Uep0NNxy78gCQrcOr+I2hFPFKQGwbr+OLlTENa/FLgTo1VzcyiLIse5JrGEz9J63cjWIpcNHf94rWGM8V1cOr4GpPhrHSqiUGwZBH40LZNM/OMzHjAbI5ctbMI5vnMjWfDcdGO9QdvqSQPduHIzJcPI060oStA8z0hKxMk10c2pjwtGqI2EPJGu8pZNBsu2BRynh2HSuK8cR185tPaBVsbNqV0drxtM4mccJL3r+7h5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Brendan changed his mail address [1].  I added him to the recipient list.

On Fri, 31 Jul 2026 19:37:05 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Free page reporting currently hardcodes a 2-second interval between
> reports. This rigid delay cannot accommodate diverse guest workloads.
> 
> This patch introduces a module parameter, page_reporting_delay_ms
> (default: 2000), allowing users to tune the reporting rate:
>  - Lower values enable aggressive memory reclamation by returning unused
>    pages to the host immediately.
>  - Higher values help batch pages during spiky allocation/free churn,
>    reducing hypercalls and nested page fault overheads.
> 
> Setting the delay to 0 is safe and execution is strictly gated by:
>  - reporting is only triggered by high-order page frees.
>  - expensive hypercalls are bounded by a slot capacity watermark check
>    before proceeding.

Looks good and making sense to me.

> 
> Signed-off-by: Pratyush Mallick <pratmal@google.com>

Reviewed-by: SJ Park <sj@kernel.org>

[1] https://lore.kernel.org/20260729-email-change-v1-1-666ae7c2b7fc@google.com


Thanks,
SJ

[...]

