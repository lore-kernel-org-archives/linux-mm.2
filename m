Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1592BD6AB1B
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7794F6B0005; Thu,  2 Apr 2026 20:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702EF6B0089; Thu,  2 Apr 2026 20:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1C86B008A; Thu,  2 Apr 2026 20:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49B3E6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:27:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A01651B6FEF
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:27:24 +0000 (UTC)
X-FDA: 84615355608.16.B808213
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0B481A0004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:27:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2PROhH2;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775176043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2D52cADD1ANqRI3QqUbjRUWvGckUKszs0fT/FKQ78yM=;
	b=RAs+hlhc7wrrFInZtHLl/+8DGGBkKbUp4LvdeLthki+0PqK+o4OyZL2NwbbVmVqeZZDXTx
	q8zwaqjHg+PQxbZBHiIincszNoUkyh+K84oWVmDSXTUCPZMq+zAEO6/zQUOImOFr2BXaSi
	CMrz34esDixO0L2rxtR6Nrvq1Fy7fx4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r2PROhH2;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775176043; a=rsa-sha256;
	cv=none;
	b=ARgD+3sYVVYtSUbhtfehpHIEYWREcwxBmKiZGUbKkhEh34KtSGDF5UNlTfxdeI/OdwgyK6
	EBlIRe00fS5Mwk9e4E4E/TD7sayJvYRBtC4rME4I+Ju2hMO5itJYiENAYpkqH+7fhi/2Os
	Y1HNaceL6tPYsIqxCNmkmJhuEHSNt/4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F330642B71;
	Fri,  3 Apr 2026 00:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8B6C116C6;
	Fri,  3 Apr 2026 00:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775176041;
	bh=FAOmb0Y2QnL5Q8OwKXxRLtG/irKniaoNq15rFQ46vJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2PROhH2jnEOJuJiGfSMB2Ie2dj9C8i4DRhk/Aqeo0KMs0baIenige4web/BtD2lK
	 qdTPxIdmNMVBRzUzYyo72BW5dR/gOK0r8WEuvDdoxdPqMAY35+PHGPaPUug3uX4ch4
	 7DTDCuS+gZymytnetrpaEbFQZdeCOJcaJ1oo7MOmwBCwJgipfpo1eKTrTttgN3m2s0
	 hlpR7GrkOVKHLhPqPGIrDLX1WV3zLfO35jsDlk27YY71CUs1wCJ1nAxH3c/ZWMBF6R
	 4DnDPkIUFLu37nnZpabr8jvI4r5M+VBFZWiEV9WiOWMhhX9OIvu5GsF8PRsKISc7f5
	 kV7U9rFoVRGRQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/3] mm/damon: non-hotfix reviewed patches in damon/next tree
Date: Thu,  2 Apr 2026 17:27:19 -0700
Message-ID: <20260403002720.46601-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402155733.77050-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0B481A0004
X-Stat-Signature: fyh798fbzehzxrcjqj5egz68u6guxn4c
X-Rspam-User: 
X-HE-Tag: 1775176042-326910
X-HE-Meta: U2FsdGVkX1+R3ArASxUXtBbmDBg5IQ63NiR6s5P38zwyUKqe54CUAEOHaBHL6V9W84cMyFRBtbeMrBhfoEcPhCovmMvdB95H0oDzfnoFKk2VywBZ3L29Qbt5nwiYrSSf0jwZi0Hnlo8+JMp6ccpxNX/QJuryArCOLcSgNzBkQ0WwTVvG1cA07N/HcY5R6IQben4/oZNxQrJU59aY6ralvx2zojGgB+B/hOZzBi4z3zP1SLurdSd9rpoustAfDWY1o3Rv52XwpdOfvlyMvAWeTeHVV0wMuvcCgBrcpLa1Jm8d4oumCgzH2gGqd3JuhoZHOWSSiD9kJQJjtprZTyBzQdun9+rIVjbuecELB3t1LOfavK/0jR5RDHA1HD/GHcYsQh/8ri/U1q6TgQ/m/CceHtrw4+pDG9i3uAb1KvR3+CufB5i4ER6IzOUhVRLZWnZDD7iCzpm+5RO8v45bK/NmHSmWcX+mTJyNBPJ4nu9QDN5sq7WuIVsvwfqSWG5Tidb9KGIGe7hCLHnWXOSOQqo+0QwxDcZqw+0vW9N5Fik+Co/xOjfo6BNHXcCgu/Ktj4FCfBzAHApJVhrnXAgiN0pJEpoAXERdTxZZLZmCavlyf27qp9vMkPx9tCSlsxbVTAJ1f48DW4Pj2ynKh7B4fUvpGoMhPFiVBHap2iatFUmWDTmJmNT2MIG3RkvA0X+qJlUiHix22GN488nFvTeA9Aig7DsfmLX5iDdJl2lozZiIMdL7nmrAjn9H4D4R5JTupKNef3d3vsYYKr2sRVsy/o5kbPXH9rJsoYYkhnM47bWElJXKWPzO6FnN51eaIgtRxdYKOv8i2/q/3ZaJM1axQDepWcJtlkuvV9k9ioNID/ClRUew3I61R9h5ECaKo9YzyNzkav3Po32/61vD6XeGt3eGAegqNBAq2ZcOev96BMSDLk+tyCfE95Ef+9lFwV69tnrVaI/b5gOUjL6O9Pn2BEz
 s/irYneI
 CSDdMYSPoYBY+N6pxyTmxyyws2E1eHNs9kT7gKBfmsj5+TOBcl5e1Swn0eIhr+9jQx5XvsQAW0Lb7QyEJFFHVeuZiv6MVbjeMM6sLQmXBM2X5bm1/P7q5WNgkHzU04N+V0x5s4DJo1Qha7XdveV93o+MKWAufB451T8zefctz5P2Mto0u6PadbZTM5Th1q62NfQC8SflupQXGzKUmZt8f60BL5BCTNuByCckArcZtONvSzX7iqsiM4zEkJrFL4BMQd0y31wkE/ppZH+5nca7ib0O+HwtWeoKwwWl8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dropping recipients who are not 100% surely interested in the sashiko review.

TL; DR: no blocker for this series is found.

Forwarding sashiko.dev review status for this series in a reply format with my
inline comments for details of why I say the TL; DR.

> # review url: https://sashiko.dev/#/patchset/20260402155733.77050-1-sj@kernel.org
> 
> - [PATCH 1/3] mm/damon/ops-common: optimize damon_hot_score() using ilog2()
>   - status: Reviewed
>   - review: ISSUES MAY FOUND

No real issues here.  Read my reply to the patch for more details.

> - [PATCH 2/3] Docs/admin-guide/mm/damon: fix 'parametrs' typo
>   - status: Reviewed
>   - review: No issues found.

As the 'review' is saying.

> - [PATCH 3/3] mm/damon: add synchronous commit for commit_inputs
>   - status: Reviewed
>   - review: ISSUES MAY FOUND

No real issues here.  Read my reply to the patch for more details.


Thanks,
SJ

