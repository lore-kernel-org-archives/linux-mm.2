Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DE4CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D4E6B0005; Tue, 12 May 2026 17:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EA56B008A; Tue, 12 May 2026 17:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644C66B008C; Tue, 12 May 2026 17:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5171D6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:56:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E126A8D610
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:56:25 +0000 (UTC)
X-FDA: 84760127130.28.65B0CC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6EFE214000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:56:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0ePpw6j;
	spf=pass (imf23.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778622984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rj9PTtFCNDtqeILOtSzmdou6lhXp081HlOrSTZW2gUc=;
	b=BAQ2QXlV/sr+5z2ChC07S1Lr5o7WSXqqb8wmw734FpNq56i/au+NuSVEu7++SjSO9Qwt49
	Eyi1Hf/FDqUOkIKG1452nL5KPZ6BlYlKx1gCsQVTSZp2R0rFWWqN5vmEwCqFotmoBeyZUg
	wl+5BOskzDV4eiyYzgbKaTisQIdpMXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778622984; a=rsa-sha256;
	cv=none;
	b=WhUC/7krBs3G/M7lZ4n1xu6StPVZUkjgdUKYyC/Fkd0CkUIaV8+3xwlD5kZbzf48QIt2N2
	8L4ng4GENRGHhJabirLzp7SDLEIRNtZ0G1Uf8fChBJ3wQkaO2KLOt9cMky01trc5Dc7q8Q
	vtF7W/RYH0fWVGnmKePyIpMyFlFWNJU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0ePpw6j;
	spf=pass (imf23.hostedemail.com: domain of rostedt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rostedt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B12ED600CB;
	Tue, 12 May 2026 21:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51285C2BCB0;
	Tue, 12 May 2026 21:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778622983;
	bh=h1w6hB46AHpBHNXF0FWF92Hbuco+k6+hO1jwKtnHQBg=;
	h=Date:From:To:Subject:From;
	b=p0ePpw6jqbmaM2sqbiT+MSvclKt1dWKliUKxPWlqpmK9yB/7g/dE7p/6BTXw2m0FF
	 iVuO6mmrPIHpx5GmbbgfpSNqHwvGkpYTfb0lcBxMfpVcI2FvkJiUvJdQHjEA0NRc1g
	 A2Uyb8wHUeTMDZAW/WWhpg7X3GNfyjW1GezIGXbPSJ5iv/yXeiJMugG2knZzvlHWN5
	 9GKRL0pfUpC9QMoc0t4ev9iSGgRs2+INyTGbhpfIAp9/BI3FeLyfV288+u5+4DWaoe
	 M2whWEk9mTm2Ik8zqTt+8OxzSUqhJoQuXb9lf+vUrQNsBXR3/biTRD1e+zUATNntdA
	 X8crg4xADU9Kw==
Date: Tue, 12 May 2026 17:56:23 -0400
From: Steven Rostedt <rostedt@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, LKML
 <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Alice Ryhl 
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 maple-tree@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
Subject: [PATCH v2] maple_tree: document that "last" in mtree_insert_range()
 is inclusive
Message-ID: <20260512175623.4c5ca8d2@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6EFE214000E
X-Stat-Signature: m54nkt1xne6e46u37yiyh1in5g6ai679
X-Rspam-User: 
X-HE-Tag: 1778622984-919417
X-HE-Meta: U2FsdGVkX1/jfNkzZaWL+ZPzSjFYrUIP4p0ZX3eyYdTeLFdkKZZcKceF0Yez0c9RMF6vncRrzTptg7tdNEyjPVlzY2yxQ541Z3i7wKI6Hrnm9vmGN1AtDa4ga/t08PUjZYoJcjtnaZmOCoUtp58ukmJEJEQjWjUEP3YKXuzl6XMQLHypo/FOCiRYXgEnpnR6ytwz9/ljGIm2H8/q6iDTiLdu70RY1rdqp9UmRTKeJ8xurmg6gNPCUAkZUhNoK5+Lep6x2wqM90ye3guaxD/ghaHLf6YCAhkfEKoPDBPgb9EYgVKWczrhtcKvZBy/QwpzwIxcIo7nzd9+AZw6eDBdOa5yVWd6tubMtC5rhJZmbAfLfznteK7RQNIn8msydyCuruY4WaWFES3UhkkBuZNS4d0gqIokfvFjyL36rncHDextX+CrPMYf/ocXVeG6GmxnAai1pWO14r8BTfZu6Wgd4P9Q7FzWv6z3jN+xM58Y18BmmTzvurluEtpeyksh88TPuzCNmCqZ/uCNns9r7GogmDaMzbCdEysKU8tUO7ITtCRY95kP3K24B+T9nwvvLrYRdzwJv0yd+QKbPmptN18SrNNcjJE/8hbpP1gKiQcbQ32RqIfi4IEiNy+UfTWnzWhn1zhaYjL2tUTGsRtCj7QpowF+QQqTLbP27BNUq40TOOIkxD0kkquLpgyMPXzCZp8ajDhYnDKfnySXYWMuajHbIL7teF4GPvLLuCQiXlKcpHWWqaCoMNnypsAgqO23PgP9aq5Q8KphAc0w3M5L0AP1CoxCjipryzWvluWo8pP+psv5rH5w0rORutWdH0P9WxyvclkHCaitCo8USKjqy3aeJ4hRUKKQKVMcOU4xG+4Ct+YhZaTr01X6vrdd5POb/wK0eRTHE2VciV3RrrLO4gZUgE269wOyJxz9IhBp+KQhez939WRrbxkJmny7ptMsO+LWQVlV0FwyvvHjBUIPKb0
 m/jVmVUX
 0OML/jaCM+I0RmxIEHnXEKgZIXto/ppBctwvg/FJN8rP5Ck+pd+Ioit0PNEdBWCi73BuzEjaaHF2FgGfjm0b0PcQ7DfYWiM3U7UmDv7XOMMmqO/uXA7GR+PgT0ei/vb+NpgQVzety2tIznlp9UEe8pl5AiEPbhlTUDrrltNbUm+LLmVEnDpiNM+UdtBzn8+kqiyRGO3fbq2MA5UQ6yTg5SddZSJJGpVyYXKBBpPx0zRDVZGPLLiM6TV7Fd0m0yA8wVLsAHoYcL2Bhc+0n6W5MNcXYAFPHLNioYF4C3OYxo+mbL4TZezu5ijhHXAl8cDC/O6YJJNW881YKdJ4HVlQhImcGQjeX52Wn6rza01dVqKmlbyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Steven Rostedt <rostedt@goodmis.org>

The kernel doc of mtree_insert_range() does not state if the address
represented by the "last" parameter is inclusive or exclusive. This can
lead to bugs by code that assumes it is exclusive. Explicitly state that
the parameter is inclusive.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
Changes since v1: https://patch.msgid.link/20260506105218.2d027cc0@fedora

- Use "(inclusive)" instead of adding '[' ']' around "end". (Alice Ryhl)

- Add "from [first, last]" in the short description. (Liam Howlett)

 lib/maple_tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d18d7ed9ab67..7f6c9b729a1a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5727,13 +5727,16 @@ int mtree_store(struct maple_tree *mt, unsigned long index, void *entry,
 EXPORT_SYMBOL(mtree_store);
 
 /**
- * mtree_insert_range() - Insert an entry at a given range if there is no value.
+ * mtree_insert_range() - Insert an entry from [first, last] at a given range
+ *                        if there is no value.
  * @mt: The maple tree
  * @first: The start of the range
- * @last: The end of the range
+ * @last: The end of the range (inclusive)
  * @entry: The entry to store
  * @gfp: The GFP_FLAGS to use for allocations.
  *
+ * Note that @last is inclusive. That is, @last = @first + length - 1;
+ *
  * Return: 0 on success, -EEXISTS if the range is occupied, -EINVAL on invalid
  * request, -ENOMEM if memory could not be allocated.
  */
-- 
2.53.0


