Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2BB606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 12:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kw6iZr0x
Received: by kanga.kvack.org (Postfix)
	id DC0186B05B4; Fri,  6 Nov 2026 07:58:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97C86B05B5; Fri,  6 Nov 2026 07:58:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5786B05B6; Fri,  6 Nov 2026 07:58:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADEAB6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:58:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 487DCA02E7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:58:01 +0000 (UTC)
X-FDA: 85404696762.15.039642C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A71A740004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:57:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kw6iZr0x;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793969879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZ4lN681ajQHPx1uvbvHoK+Cj6ldX5GuC96t5z/VUy0=;
	b=Mw5jIwojjmyflLPIvzXPnI0aKUK9/h80iJ98fJrfhT/zj6ya+eTYClV2MGI+eCI4hc2mBB
	fcQ2FtbEW4lX9tKr525cWD7QSnyWTj9JHXIrYgsgfaXkG56BsHkdGuu3bXJpxm4DVJYugP
	5+sdI4QVJN2gtw3SFcw+XRUqTetddPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793969879;
	b=bOn7rPs9J2+ogO5Wd2Et7khM+sZY8JaxQRhTE/6mzmVJsUjAucNnh4jtf0qFx7P5ipNt33
	h52vQY9Ko6JWvHO1NyugnARI76Nhlsfja3SASsT9WsadFQterwc4LckiXyV5bLhq32B+lT
	j4RwshEm/1KgbAiDfgE/hkSJsb8lTvw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kw6iZr0x;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD28243F3F;
	Fri,  6 Nov 2026 12:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F201F0089F;
	Fri,  6 Nov 2026 12:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793969878;
	bh=iZ4lN681ajQHPx1uvbvHoK+Cj6ldX5GuC96t5z/VUy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kw6iZr0xdVbUVhaorQzM+c2I5I5tSdtyy0WJFxR+cWWcoPDeY5aQf5fDy9MbwAqHd
	 3+K2hixVUatcMeQ9phS1sB7NXBPM4/HnxfYoaiTAjOF7trOLC7O5/WTcm3It+dJCkN
	 TlSHZ9s7CbbBeZ2eZPTL02/gaDl7RQXeHC4X5BurkL1wy+8ZKaRLQjRuyWjopXrVL/
	 H6T8HWTF0ztxMUS6f2w3spK6ZLdX+Jhj3NocxzM9mf8C0UrJUQt0wYvREdX0Nm/VWr
	 IGtz7qAYdCcdV0SG0/rkjsvzpvRgW12X/4qbCRVIdvBNkl1mIWxxEGjTzc/UBgxgq8
	 Kd6uooG/WzNAg==
Date: Fri, 6 Nov 2026 14:57:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ivy Lopez <skunkolee@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, fvdl@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/cma: fix range selection in
 cma_declare_contiguous_multi()
Message-ID: <au3Oz50x-y3GPYpA@kernel.org>
References: <6099bcde-15be-4197-905e-13dfa4c83bfe@kernel.org>
 <20261106002347.255584-1-skunkolee@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106002347.255584-1-skunkolee@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: bzzrwwq59f86yjqr9xcx6xcfzf6egfwe
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A71A740004
X-Rspam-User: 
X-HE-Tag: 1793969879-7417
X-HE-Meta: U2FsdGVkX19HWDzI+Q3tiEbS+bA2ZhSFdDizGOLxFIHks9Yi81X2WhmNK0mYj9l2U59P6fnuqpQyanp1xjqeOTlUMr0W+zmp7qfS1IUscy0hdmxzCI2oyMqr9cps9z2Khvc3vLD+8TxGEY9o9vikfFndVrlc6SiF/qlOv+yC1oCSWpo3DaHcUtCLS89c9VT7L4aNRajiEf5DhB//Ez/0vHowfAcaJ1ce9TLtT81uhQMmUejxCIiQRjbVTZxAtZATpqrkKyhhgTbzUUZ9Eoe+Q1UeAAXY4MwpS/fQl7JwFzH0fnB0wseW5Op1p8C35qQhd9OubNs0CLbgX8Khkb63/xjNlccKG6GOExJuQmUF1q+gWnakK2v5DVfq3UroEzHpVj43Hc5jODW4qYn9/pgh+rNfxfTW2cg/WvcYIwWWx4TScam9TSWjFVrneJn+O+5zWY9l5OSeT3Ur3CAOBLV8j0Oa7dDrGjRZpkLkfL+be4B6QCcCUObg8zqZ1+S7O782ul6SyXoAivrNOuSYXkBem1q3rzg6Vl97mA2sKbHqsfRhDd+/UibRKwXOlVulRYIuUIc4qrSFuL2GcyN3EuvxB4FYh7oj5GLFSPqQtqWKuvDcyUfylibxE1vZTQpoRLyVujgkmHkYTu2ajNe1vqwU5MXG4AoeXnMBR/dd3SYBqr652SsvdX9VxObZAFL77jrIQ0QtUmPKzLcF7kp4S2FLK6/c7RbRrvsaH9+5LG0FIcxJFhrTeMj333Bt3MX+6pIwaGq5sIXRLpgQT/B1zkY5mJj9H4Sr8QrVK1J6XmkxQo7Q5tvdcE8ZaOkS/P3xN+rbQxbEV2YQeNX7jKkOmIFMR4KoDNGJr0E3zOsWC6yXlXaoOxyk/BB2vewvV1cJCpvDNmaC5waNDvLs3YkXbFZZb3T+gr4YEeN5rE4lecnSQJyxl1P2KmezIx6FPU1SobZnwFEG0Cf3kb5kDU1FUJp
 M/aSfcyG
 HE76WIyazRNkXV4I+80U3fBST9WaPzLQpHg0vg4os4lWmf+xaSK4LN+EIwyZAh+XPiVnWOtNK0VbNfNRdwlzhH1epuFo4fm6OZO0wGneCqaa+OHqbV5ApbizZoyg7UXDgMzN8snK+uYKrnVko91Oi7cRNN7I3KyYrlHpQGMqsy2sTU6BhODcQNcw9XGGJn3cI/4SwdsXjoGI/zfOlkKnXtdi0eL0Co3YthCk9uQ69nIYf14WDiXmeZmis9ycS69LMstBc02gx5AYeiKZwZMceeR7xbyXzN94d5w5PZ7oad2GU9bO8kV6YpV3uSneIa6GflMQTtiAAGDQRsoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 06:23:47PM -0600, Ivy Lopez wrote:
> On 11/5/26 20:38, David Hildenbrand (Arm) wrote:
> > Do these two fixes still apply?
> 
> Yes. I checked against akpm/mm-new at dba8aba0a9a0: both patches still
> apply (two hunks with a small line offset from the accept_memory()
> additions) and both problems are still present, since
> list_insert_sorted() and the sizesum accounting are unchanged there.
> If Mike's rewrite is going to replace this code soon, dropping them is
> fine with me. Otherwise I can respin them.

Sorry, got distracted, here's my version:

https://lore.kernel.org/linux-mm/20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org
 
> ivy

-- 
Sincerely yours,
Mike.

