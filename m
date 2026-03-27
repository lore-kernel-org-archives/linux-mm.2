Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEC610F2872
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 22:57:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3986B008C; Fri, 27 Mar 2026 18:57:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D647F6B0095; Fri, 27 Mar 2026 18:57:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79F46B0096; Fri, 27 Mar 2026 18:57:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6BC46B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 18:57:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F4D2C23AF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:57:29 +0000 (UTC)
X-FDA: 84593356218.14.61CC870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A75EA40009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:57:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfWOM8eH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774652247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdAohesmaMLy4iPO57KuI9UOjWaPJ3weBmlXektGgJo=;
	b=k09SKkTiYWpQki23cN/No8u2d7LFcJYufFnh27MccOh2iPZ8ZFnhwp7L+Tj0vvq0vwXc5Q
	suqAGIG51V2gwmRpABDhtjYMQG1NP6P9yZ5xaTq4A6QArJovoGkAX4oHG3EhN3sD4fQKR5
	xwZ7/Ex8KyTmuhOcjrBdCK+newSJQIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774652247; a=rsa-sha256;
	cv=none;
	b=0RgH5ZZ0b8bo3ekjaz5qswH7KDXYysyLu9M9r3csyPlw6SMLl51IOMtMLdvhl9fpRrEHhg
	yj55haMp8AiivrTftSKRNhp1VlKu/oYIfxdUVpUj/QIo6Ia025gLJzt8kIqO8X9UN3ZJdB
	wVXLAGoBQMIoBI1mNySJDovToUKu3Is=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfWOM8eH;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E27DA60054;
	Fri, 27 Mar 2026 22:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7640FC19423;
	Fri, 27 Mar 2026 22:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774652246;
	bh=1gPhvFFqtiKNhLFWqZxqekg0toLeQJ3oOjvtXV4w9q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfWOM8eHRZSguTkeM9uHdXD3MlFZ+g53dC0CbjaiWWcFZoomoCRIP8IPOGWP8ep7P
	 rvTj8clFtj9UwD9hGhdS/GM2Vcw4cPF6JG9XmHs2quvP+qzm/EzasUxvLok8PPPtL+
	 4OJAy6oe8YxWRNQpoiT8k+K3OplT7jOI+PIWU6mKLj1k6GIUX12Z6TDhCjusQwIjLt
	 vBcE+Mxp2uNs8y67WXeJ6GXEPFLkN8md5wIhluzbL3Kf8OUbbSk6PCXL1kjsdHxm0n
	 TBwmBDjgQH1rC31io6DEDrWH2+a6wS6aGIcHsxqJlkXvzbwpQyybiJtISlgDHYplUw
	 ISSbdYk0pOMDQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH v3 0/2] mm/damon/core: fix damon_call()/damos_walk() vs kdmond exit race
Date: Fri, 27 Mar 2026 15:57:24 -0700
Message-ID: <20260327225725.8591-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327142605.4834-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A75EA40009
X-Stat-Signature: bwbpqhdrwgshk4cutgzm93mnti77ozcb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774652247-488042
X-HE-Meta: U2FsdGVkX1+RITEoD2eMDwCT4niHRXtjHj05GSoI7OBkU0E/PuSRK1FfmyxFASnX0/qqarv/CeSCKptdK61Ysei2ALzYwJW30IaVzGrrOERR2/6W2rnZPqs3iTtxfNp2z6aPNjjifjDYHWpO369A+AMSiM5oXZtVA8lYLMF0XTQkA7EGFcoTGEviWFIH0aVTyaGMZeDMPDNqugLqB0v8hZKJsTz8K1szuafj1USLBPBiv9BzxE0ztcbz92tsxpm4dPEhC0kuDnSAK2WpShl3u/saxWOE2klIZW0FZ91XjgTHIMA2R8kJiRh8Ixoq6zSlpqIiyivSgvFcsk3GGB5SuzDovw+OuFdV50+pKEX/5UuUfsPsbiwiOYeMTXKouPIh1ri45mLfdFkppT6JBZOr6PvU0soQcNwfxJz2sK5t70rSK525hUbcYyukJKQDDxnW22d+LMtutBYjRr/gsjxwanFNrMo8EJI2Nixt9m0bqo0cwx05LF3eq0ztRMULBt0LW7mfeQkky3Gstdb9PYFAvHo3yRlnzFipr+lM3qOgOJFr7ibw+CnEl9/4RI1aYyrMzVUgwY197ptao8p2LmTK2f5bug9ZSJ5aw14qvhLV5DpWa0NQs5DxgYgsgMUC8+M5dDe441ARF/MowclVVDGVccWrStHHfpNvAr6K/+ILunjEGlC6qZSYqYlfRMlKPS5VNwIFSNVGr1PcXLcXJiYUevqkyD/+/Yg7cTRFcfJi7TlIas0dXKc5R7wy5RqPp/fy/l9RNX2m0n7/OQdMephSv8gfIFeDIJ0bMclaSMn+HKw68fK9He7fvrG7rpvjfnfa6/62kfw+OB0nkee2OYXR6nwpZnvdOzDKGeEewtIoywSV+NiIIQJpIoTLJcJiMHyfGz9AuUTEU2WXylC2+0De2Ae7+/STe+gnK9MDznfEKvm9LN1H7oMhQabdbm/q2I/j3/HRNZ6uxG88GDH0hXW
 36t95Ujh
 b/W//BWLtugJOf2SeEopCLF+IUW/ypIUmGjaU6sm+GNUvVleDkLr7JqzRoM/iMSmNKtTEExt9hYPlgZH2CkdpfIgX2sezOFzlEHvkZjJqpqWIObEgok0Ob/f/WJmAhogq4mjIXYY+LifTx5vQv6ESuTDR1A6wmP1GfCgaPE6xUlbCCk7F8GlmfojY6r9eiPj7aiTs9IAkQ8erO8X3Ey4D90Nt4wxZJ2zCld8YsKAA0eibRYIQPQsV2V+DmOGDq12HP/pJ0apMMoolaXCQTYb9KGCBD37pFhAoeeqtQcvKEU8BBxcXsOITV9sJXpgL88U8C11Of3BDv4Rdn9QlR1zvqmtcMXKrkKogkohP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko.dev review status for this thread.

# review url: https://sashiko.dev/#/patchset/20260327142605.4834-1-sj@kernel.org

- [RFC PATCH v3 1/2] mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
  - status: Reviewed
  - review: No issues found.
- [RFC PATCH v3 2/2] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race deadlock
  - status: Pending
- [RFC PATCH v3 2/2] mm/damon/core: fix damos_walk() vs kdamond_fn() exit race deadlock
  - status: Reviewed
  - review: No issues found.

# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --thread_status --for_forwarding \
#             20260327142605.4834-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

