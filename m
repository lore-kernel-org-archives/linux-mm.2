Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB61CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 12:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC22F6B0088; Thu, 15 Oct 2026 08:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E731C6B008A; Thu, 15 Oct 2026 08:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D625A6B008C; Thu, 15 Oct 2026 08:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B38176B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:07:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36CE41209A1
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:11 +0000 (UTC)
X-FDA: 85324735062.07.98E7C87
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99B7C4000F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:07:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lAbunh58;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792066029;
	b=zoe79U5VZXI2r1ijiKEqTC2+SYRrSxoBToJmK8pvV6pJYxpMxFq2EOMS2G0ZEvXYmlr3TL
	mZVbXjHyllxs6eBaeX3k9peWs0JxDP0GFhqDNomV77efnmCgVqmw5fG91LsOG1KD/kQjO6
	HCmcl9JGYxK25J/jEyKvoy7dhr3m8K8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lAbunh58;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792066029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNVtcfS2xg3DROGsluh5T3nF9NiayUsv7CXTN/Tx99Q=;
	b=aiRap3DtPSEEfWFD5HfWIEcrnW6VNvszMAu/V0kKoLKginzNZo5hBfXBq2gkMRnZp6CyOs
	UlgygErXhAT0J2EnWuKkExWsKj3PgOeD4zCdOgLB48+tMeTbiRQQ2P9mFFbS4T8a+q/fyK
	icCNqR91ytcZlmJhufKzFNEXl/EXSI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B1140C07;
	Thu, 15 Oct 2026 12:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BCF1F000C4;
	Thu, 15 Oct 2026 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792066028;
	bh=yNVtcfS2xg3DROGsluh5T3nF9NiayUsv7CXTN/Tx99Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lAbunh58w0sPCqIegE30teTf3db7salNSpWk1wC36CrjBrWY9uVZngeRD9Qgsgtb3
	 TZFfXXJG+UJVVZNDnCw3Bh5nInmh0d+kCmDoJI08ipkX2ufGJaZRoVdRtZg+zNmqSN
	 L/VJEL4KXe+8Nc8oQmIUURXJUJzVsZth/itA1qAJHdoXr3QEbJ6NeLFfXS8QjEq4pg
	 4kmsNpavXPW8VVnatniAx8Fpd1ofRRlpLZZ51waMLTvpplz8NwBknsk19YipMvY03a
	 lHYK1oWh6YDhcezLDaClYtUYM0fcuLMlTLqwKmfpxvkcX2zrDCGouW3C7mAVRa0Vd8
	 DAF1CfdU+LfpA==
Date: Thu, 15 Oct 2026 13:07:06 +0100
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, ackerleytng@google.com, akpm@linux-foundation.org, 
	chriscli@google.com, hannes@cmpxchg.org, jack@suse.cz, liam@infradead.org, 
	muchun.song@linux.dev, shakeelb@meta.com, sj@kernel.org, ziy@nvidia.com, 
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Message-ID: <atDBk7ZKfDtKQKTT@thinkstation>
References: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eae44a6-06c3-445c-9508-58b372c01b2c@kernel.org>
X-Stat-Signature: weaucn3sx7dg58pxix3ezhghh1da4fwd
X-Rspamd-Queue-Id: 99B7C4000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792066029-49250
X-HE-Meta: U2FsdGVkX19aU5K4onBuewFejlsZ8pOI+uSuO5XEk6aUa3abESQ4WknU5dEVjaXgb2cJ898YqFcMW8BQIBJZeAH8+ABelB98U+yXOFQZM0jPSxJ9FDVSXmkJhAdJcQ7OXBw6SMKZBodIlQaN2yElS5mzOUwVOHmbC8kf86Qz11Re5ivM59GkC1pKGzICjRmmKi0pbIUi3sXbHMgfsg1y/cEFrXEqgv+Nb4kLz81SCn893Uf3ycYUIvdsHDYUq6XhFlTRPVbePTGk8DoAZts0OeLp6bKSlPL6W/LdtdcHsPy3qkHg2qTB/798E04jaejcw5K2CeIRzN4ZoMw4qp3eSG4UClQX+aPW1ok04aM26YH9GV4X+ozRLyZMu+yIUoDLv0oIFxDk8WCDytZvz59itahqKwLjHyFd3gRgWZ7HWPWcEAVnyN81zlI4bn4L9LfwIPq739A8YX/rQqMxnttTtCqFeH4wVhz5VbI426tUjFtlnIgdya48LoaWP787McdOxi1ieqQGhV+o4fDSkSCeOGRC74UQqBqVxa45qLskTRnpFB3wEUChax3R3bQHBiqbBsWbuV8Ggux9KcqQ8FbUgBRoUjpQOQd9YrLqP3qX7ZtygvjJNovzFPIWtL6gZ/h/bJGJ43V/kUtBlVdXcip6GQYxLFlz3eOL7EpBsDcZfHSQLs63peyi2UGjcgdJfhMDOLj3ffoloYD2mS5c6SFB0gvnAp87ujbajHH4NG6nZDSG5PEBJJA25bFER3edLHpBe/kuyPtJxCHT5o3QRa97ifRZsNNPSyVeCHCjZ4mUzo9aOW7reIMlxUnE4rnRxMJTSqQBwkRksh54jdImkQ9g5T5DZNDocdWHoemha6olO2JWw191+kjmykJ0/aasmN9oJZwQjAWyUS8XrwSKKKOouuSld33pnnXcJHd/xSRyhk1t4vDLtKz9AmTCLg+Ep1OVdAlxuCVJT38aKXBVsRY
 mZbHKmUN
 nGb0JTAgG9eqCjQvdX8JpO5Mg97DUzrovIP4e09oG33kRzm4P2DJMmBkCrb06DCvlTPx7wN/j1w8PBOvd8exD1xDu7w44R2ZHoXpT2mwcuk1tYpAsnPaJ1c4XIf/zu4rExD7D4sJF0zB00d02m0Y9QqiX0ZAJksVnpb0xCj8cdkJuvVbDz1+wTHMv8n5yl8jOUTfWplwJZy/c//eymLLEkPcE7DKg2LgW+7sQmlRhOpgN7LENBPpTn2ZY/LlrtbB86A8RYHCnpSyQv2lAQdT0dIrc52dj0q1GAnETcjrwZhQC8735OleAmKgQ9/07A0AuRhAwyHc1qzKUQQiZpj5KMieCD8r1CD4sx2Wffu0QoSDm9tZNXB+dva7TfWAy7NjVcyWW4H7D2f0QNEGQYF47Z3LqvqSBraxdzwJ33Cjb2EUUyRSwPXMTKZgG6UNHuMBL3pI2EjnWlxoreRMjaf7yHsipwn3trraBJH6g1fZ0FnGslPgEySb/veGKPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 10:38:14AM +0200, David Hildenbrand (Arm) wrote:
> (CCing all people attending the mm-next call)
> 
> Hi,
> 
> After talking to Roman at MS, he just informed me that sashiko now has a new
> feature combination:
> - "embargo_hours": hours before review is public + emails sent
> - Mechanism for signed-in maintainers to lift embargo immediately
>
> That solves the key issue I had with sashiko: people/agents re-spinning stuff
> too fast before a human at least had the chance to jump in first.
> 
> I suggest the following sashiko change for linux-mm:
> 
> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> index a9198de..ba123da 100644
> --- a/projects/linux/mailing_lists.toml
> +++ b/projects/linux/mailing_lists.toml
> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
>  ["linux-integrity@vger.kernel.org"]
>  ["linux-kernel@vger.kernel.org"]
>  ["linux-kselftest@vger.kernel.org"]
> -["linux-mm@kvack.org"]
>  ["linux-nvme@lists.infradead.org"]
>  ["linux-omap@vger.kernel.org"]
>  ["linux-pm@vger.kernel.org"]
> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
> 
>  ["fsverity@lists.linux.dev"]
>  reply_to = ["author", "list", "recipients"]
> +
> +["linux-mm@kvack.org"]
> +reply_to = ["author", "list", "recipients"]
> +embargo_hours = 24
> 
> 
> Which means:
> - Embargo 24h
> - Mails sent to everybody (author, list, CC list)
> - No positive-review ("looks great") mails (default)
> - No other static email addresses that receive a copy (default)
> - No additional ignored author email addresses (default)
> 
> I'd say we start with 24h and see how it goes.
> 
> Thoughts?

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

Quick question: when are maintainers supposed to lift embargo?

-- 
Cheers,
Harry / Hyeonggon

