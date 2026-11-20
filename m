Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70C760A2606
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U3yRfJrB
Received: by kanga.kvack.org (Postfix)
	id 071D66B05B1; Fri, 20 Nov 2026 06:24:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023466B05B3; Fri, 20 Nov 2026 06:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C306B05B4; Fri, 20 Nov 2026 06:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB01E6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:24:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E3E5A8EAE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:32 +0000 (UTC)
X-FDA: 85455264384.29.251E8B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D41F1C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=U3yRfJrB;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795173870;
	b=z36g23gyvDu962vNcqlSo1H4z8Y/jY2RNYIQlNju5O2vSKgFiknMF+cMWpKf945emDKev4
	S2WGV3xHOenzUoHKTdV3Om9x2SFthX4gplM09tUbAvT1s2vkBBHaJ+9mBRrbOo0n3Dt2aW
	ypU0xm7XZxXI4nZJDjtNlnV8zU+Nys0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795173870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6Htv9LFeSLw+jD+wOsLXSXNdz2GUdPCK8J2LmStufU=;
	b=bWUB9MmamJC88n1CafdxeMcDKDBr+DRWLYSeaArrs4CZ39E2Bm+ciAxYXcasZWGe4z3nnz
	r6wW9Or/GNCgXoOpc2D8c1qcWxmOynyBi7WAVuSslubg5fqZ2SWCaMi5dPRFTeA6/zJ1DE
	O+7nFLM7wGUsVyQeYhXgMZk8ULV2IGo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=U3yRfJrB;
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf20.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE86662581;
	Fri, 20 Nov 2026 11:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71081F000C4;
	Fri, 20 Nov 2026 11:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795173869;
	bh=e6Htv9LFeSLw+jD+wOsLXSXNdz2GUdPCK8J2LmStufU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U3yRfJrBpx3oWJRtEqrvXe20VwuatH58XY9LrYJOHdjQNWdRf8/Pu0LlT3+5+/OPw
	 /7SMXklt6GXUcQGsKa7halMtP+PxFosUnXpbr6OKOvlLafNZQl9j9vOuqBmN3vxy8x
	 5IX3N6K8k2FPiiDVNgqGzoLRRCCjW0HPm/txvrk0=
Date: Fri, 20 Nov 2026 12:24:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Nico Pache <nico.pache@linux.dev>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] vmw_balloon: account 2 MiB pages in NR_BALLOON_PAGES
Message-ID: <2026112010-alabaster-correct-8594@gregkh>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
 <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-2-d8944b587819@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D41F1C0004
X-Stat-Signature: dnabmwim4ep7uondbaykudqobfcw77xx
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795173870-485349
X-HE-Meta: U2FsdGVkX18EDezaGTXj+7zsaom2WipGfJpc8md6YqGM4OKtvwRxKGO3fyyaxtmZCo/WMT9ECYsF+qXxhpFXya9wjmbzQ0OBtbjGh4tTXqcSVSHB2g4da39nS4Qm/In5NgsL6DfERn8GwF42mJNwxrUKdqExYC32WPLNkbYTvuUjuH/Hc/aP83dwHpUFv+dlcFT9CFgfjkR0uvjm35N6YYUYjq2v/fQeQQhi1PZC7vHh5lhfi/QV+y8Sw1jYmDNsu7GZV/tOw9CYkdBv6bdG/9nXmjSYev4lv/OEirrlTg3++qTz//abPTY5YYHdP0SCGd1EPe3OkZPSkeh3eTlKVLzX45Lop1apQJ8H4p6nbbFIA+IrWOFg4aasATQH0vEnwgFOn+I1CM+vcNUEDZBT2EEeWd6bzadHbOArzyAFx1eSkewNlMWVrfEfLfHwUiQ+tlwRvqzrgd4/39kft1IWwIarmh32YrhSP1+gbkBh/bjsdiMi1XY9K4KXYcyIsJYkEeRndk1GHcNfSfblfI/CztOXxC2uM/a5IvLY2X5d3KmETn7GGpxDnMlUxZSCrKr3u8dfWcmgiMTaR6MyLeMzUNQM9zA13ysKnwPDoMyeeQ2DUmDsPp6+lNG2Ac9hwm0JJph4RnTPB3hAtnSY5zPcXAoxGjjxk3Qs+ejvYI+0vaAFDK5ejc+wIBeIhBY6S2yBzzdY2bNXOJB98VwZ21HYNe4T+c9wQTRkmNkqi1jQOt3NXDf5pjS2iQueEMuqOcaiWqaMGkrNLS1uMef3mQTHGzh9TCWgpffRHOerkru+Vkf2VhCmzMRSXNJ21oJzTsuhNMGHCvfgjk4c0+DxwAeP78QJ5XQAbryJGqvYLzRMOInxLQHo3pPZcz8hLHDA/a1Oq/PfLfGFaiPUe5RKiEj1rRSNthNiW9jZsb9kVJB48wfw59it8r70qRwg1aEUe4LPgOxP/8IMiff56pEZypQ
 NYSd0Q75
 +/CooCbbvpa9xY/R0pahFh+8gZN5UvSHBGFhQ6tn48ugS4Ry9Zr8vzGthbdBG7PYc47G8huFnldmUJAgnw2F8IblD26e0CWriQn8eFORAsx3CBRCWXkjOZFMsWBP3oUOYACDP4/9rtorp6HUnayEwD0B9HLtTbY1JZ3Ajo2v3YXJRPBgF50eRKLglDc2Zl/o7+zZLAydrEyzemHmMj0LWxb5kwIzLvj8ZxhXuZP0Dy41wF0X7NiNU37PRQSHX9Jn21fPPra3Ib9nm1MUlghrPLdC+lf3YNHc+7UytOoPSp0Ee7jVM0wWivUl0o4KQXwo+wU7xndKvJL+na3F5ubjKSjjxyCIE+tv+pETVu82I3g3zdhwyV1s48RMt8nlXGWeoXdpLuIJNKJrKOqcRvHXLLRVanLPnyU+UyPtRvr77P9KMjUNCB8FkV+FIe1dl2tNKS4uil7YimPFxnE4PLnfNRKC+Sn7I1GMzkPEaFXjK1ntPRxPrJYOj/itGxQb9/HyoXoB0bXevCfQ2RB4JXBKSz8khXIvmQtojAYFOMcGJbrMjkFp/AC0EFh5aDxucnG1t0Vp6B3ePK+adGc1lohq4IniGTYUP9eNVqd3x02dAdSqLF2N/78ArrYtM4UOy+Bm7tOsLpWUC2OlO4gZoqUxaNGWEpcgqtSiePxdtQ4zBq90D45yfDquIcipye64QWnlR7H1jas+E7mQVINQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:34:43AM +0100, David Hildenbrand (Arm) wrote:
> vmw_balloon keeps 2 MiB balloon-inflated pages on its own list, not
> using balloon core that takes otherwise care of updating NR_BALLOON_PAGES
> for base pages.
> 
> So far we didn't account 2 MiB pages under the "Balloon" counters, so
> /proc/meminfo etc. would not reflect them.
> 
> Fix it by updating NR_BALLOON_PAGES when enqueuing and dequeuing for
> these pages manually.
> 
> This has low urgency.
> 
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  drivers/misc/vmw_balloon.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

