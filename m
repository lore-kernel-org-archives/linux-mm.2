Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE33AC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:03:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04826B00D0; Tue, 30 Jun 2026 10:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4F86B00D1; Tue, 30 Jun 2026 10:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC956B00D2; Tue, 30 Jun 2026 10:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9495C6B00D0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:03:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1715214049C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:03:54 +0000 (UTC)
X-FDA: 84936747588.07.04A4C5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78BAD18000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:03:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXXpJ6Sc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782828232;
	b=5h3KzPEr3+w70qjgtwXrfUararLVJDhZbuSqRqbyJH3TYZI1jnlvWqhMz/3cqA6GIybtSl
	MHD4LtVvrVruZjKGbzUbBeTKrfd+PVAggxQePOLQVuapyUYv8CoD19jd3m6RivO0M6ctbE
	eKjzW4TvRtSxZqd86iS0GYrzpcC2k9k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782828232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClHDIHe24wi5Yo5FWGkzU3UQ8Z+yVvMWp5sTcgmzYDE=;
	b=2XYyey42jH4t1KHP1OPIs9qg2iuJfumIb2wD64ZHlE6RQd3rmQxf4SDPOC53+5R/m/ffjF
	TAWa8Q+SOYq9YVAeh3UHaOWDfDA2WbYmmn9ut8I5hJjIKhTVtK2ERwdLaDQZKJWUE8jIW8
	FJThj90twv06JSRXhVcnsNaUiQfTrtk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXXpJ6Sc;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AB5C40B7C;
	Tue, 30 Jun 2026 14:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3781F000E9;
	Tue, 30 Jun 2026 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782828231;
	bh=ClHDIHe24wi5Yo5FWGkzU3UQ8Z+yVvMWp5sTcgmzYDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXXpJ6ScDKGWLDx/HgUzJ5sqtbpEXFA2Ctwbjq6K2MtMcDWYaEX94Gk0asH/tH/kA
	 iQfsHpW/G5+QPyWYgHQZ+raxxja9UDbc5KaMY8qqcx5ypmJbgKxucYJQz7ACutyeC+
	 hXENuFNiGhVTw4JzOBuubKINL8mI5jUDxDXctc9B3c0YOhH8OCYi8NOK8bcZ0amjtQ
	 FoVq4/zPENKLAwqqXzyjFl4Xzc3DMIw7QoLRGt+hPIfl7nLtbnkvvzEeUYznXte1W1
	 /NuGYU8As7v2GwZj24s0uelAhG9/j9W/z3vQuKMfFMgElgdclAyuQMjdkU0Ftp8dFa
	 WfGIV4wkZQ10A==
From: SJ Park <sj@kernel.org>
To: Igor Putko <igorpetindev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/vaddr: remove redundant RCU lock
Date: Tue, 30 Jun 2026 07:03:36 -0700
Message-ID: <20260630140337.91100-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630130253.3843-1-igorpetindev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zeg9fqchwy3xy3jzi13waueianzcr6gh
X-Rspam-User: 
X-Rspamd-Queue-Id: 78BAD18000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782828232-40944
X-HE-Meta: U2FsdGVkX18L4Z5tPgX+Ay8lWZnd+xc2DfxUl9hcYtQ2XlibWVUJQU1qGsqj8kWD3PAolv0rnE6zNUniznrWytLE5QzhzBhKti18SGd+zzsDl7E4VngbhHVegfVmAw4PJcLFZJCAxJ+BPu7NZlz4ZrBZa7BgUkLaASScozcmxj9MPTKXkVPM6Rs8le7Ry2qyo+rgz9J0rdA2kzO7AmaTQgXN+PMphTf34bYOR4LgYbISJ8fseOMLyGg3Mtp5ojYdQDENpvOok+3xLiisO+tHWKrqGQ57nTBRRCYpkJWaWOE6EMlc0GXiz+dbANsrgQ1taJPeXYObw/9EsBX+xYSHTnvHsj+jL16JsZDs4UZpZ01IKm+cVZUlLfykNhRlnqXCtKfXngWCfzyYqIvf41upSw35drrPDMZhLhR5ycf9WQwuA7bytKRMM5uIqcUX7ksk7QoD7rY2o4ikspDOGFxnYG78WKtT92SXPHHnTFtO9JaW+5UO0Ba3m9EhwNnhCQ2GrBbqPo8j6qvdYzzM62B6yr2+/nPg0ywlciRgKxDhPQ6ezuHgcnIki7lf00u8dw7tyRdu8dvrcnwsKqt3tYqlXZ/BcgTXuiyuc3r3RAtDZJ1gaG8L1Q0B4tG2kICO6ok/RM3m4EaKi8irQnrloRLMZb9MKeiMOdU9xBP3u3ZjBAJJh7nAEFD6iM1nNbE4SUK6iVEijp2bsMLjkVd/kRJzFxLdW0I1tIpckcxwTMmVpCkdhfqe/DPeT1AGiCewBrjnjMhOfyycA8j+Rmwy97u6sk2NGc6B2vlF1hS+36rLW/g4pppTylbnaz3DXltAZITuzzSf5v6m2y7jY0r34R2fef/SzGqmgGUNWV2ZVQGj/m838J7rl/Vkt6c4KJsEbYLYdwPOc+pLOgdOwBFKaPHaaAbrsrFINDHRsyFr1xy6omfAVTKeAyRCtFEGS+V2YlRJGWZHj6TXckYLWH55uUN
 iffoRl+P
 U8vLZ1T63V8UwZzUctmbjRn5/kwcGTYewRGQye52+L20KWS/YVaNFKZc6k8AOAYu/LiYxZk50NwCVHNdk6g8Pomz4Yq3kHD+ejyxG6HkAungrWge3qhBCRRXmqkZJwcvFIs4zz2pggkNaZpveOwCqVWGrAtx2wGfgkM9IJfmYv2DW2rHIoyenDqRUgVLFw/hxum0cNbahMiPGfRABhb1FcJdCRdvY6t8uI6SMVSUa5M3hXJOUwRUzDhemwqakxGSY0DY46PO0sgl75+xPqLd3TtD8oncXIQUH/ndFVPaYwmL8wUxw954+aPPuNcLu3zaAjBAWii2xUcediYpyVQ7dbn7Sig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Igor,


Thank you for this patch.

From next time, please give enough time for others to comment before posting a
new revision of the patch.

Also, please post a new revision as a new thread with a changelog [1] including
links to previous revisions, rather than a reply to the previous revision.

On Tue, 30 Jun 2026 16:02:53 +0300 Igor Putko <igorpetindev@gmail.com> wrote:

> __damon_va_three_regions() is called only by damon_va_three_regions(),
> which already holds mmap_read_lock(). Since mmap_read_lock() is held,
> the maple tree and VMA list are protected from concurrent changes.
> Remove the unnecessary rcu_read_lock() and rcu_read_unlock() calls.

This is not explaining the test part change.  Could you please update for that?

Also, have you had a chance to theoretically or experiemently confirm the
problem [2] that motivated to add the rcu_read_lock() at that place is not
reintroduced by this change?  If so, could you please add that to the commit
log, too?


Thanks,
SJ

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://lore.kernel.org/b83651a0-5b24-4206-b860-cb54ffdf209b@roeck-us.net

[...]

