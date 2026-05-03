Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569BBCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 13:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B79E6B008A; Sun,  3 May 2026 09:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968AE6B008C; Sun,  3 May 2026 09:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F1F6B0092; Sun,  3 May 2026 09:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76B256B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 09:21:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03CFD140989
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:21:26 +0000 (UTC)
X-FDA: 84726170214.30.B8FA986
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50559C000B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:21:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d9jLZgsq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777814485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kwDcXAtkSlyOTZvlmd7z/DMbgn6BGrWKKPHBHUrPyk=;
	b=by2N79OfFk1FskxbB1XcBxKeul5uuHh24tqcqGbyj7BT6uCIqUN0KaedY63qdbSZ5Ivcz0
	1aM4UA7JZy8GbsUXkqE4DMH9pIF/K2+VxpIAYO4O0ljn8ZTtAg4aL90zSx56U2yacKfsY/
	XwNCuEscBAxGRxYuhcHj7tni4aUfAiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777814485; a=rsa-sha256;
	cv=none;
	b=VJ02EV26i/dPG7t2CpcM6HZAalQudfDnQBCwhRaZu26i5Q5eO6WIJWY84ShjsswwBhKABP
	JCSzpRCCpHewIWoxkD1azbxvE+aCB8Uel27sRkAO/MTjNbDkpHjDi87QWzY8oVnJiV96BQ
	KrsaYQwciwqKYuccfo25y0g8v03APk4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=d9jLZgsq;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92B576013B;
	Sun,  3 May 2026 13:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFD0C2BCB4;
	Sun,  3 May 2026 13:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777814484;
	bh=/T3m2Xew3DaNtCYramal21sgWUOUmUr+OLU81uWBVOQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=d9jLZgsqz1fKoLEVBryPGvmNQfmTRXTFgOTN2UncH1Nzn2pejMzSoUAMDsRjJwqc2
	 xA7rh6yY2fzUdpElr4IVzZ0UwALLXvpaGOJLPGb1mY+o+LErCNIat134vtpAZfQkht
	 vVhO24HbTsJC1Mf0vmI/3EkzS8LEj6keFzy9awOY=
Date: Sun, 3 May 2026 06:21:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH 7.2 v16 00/13] khugepaged: mTHP support
Message-Id: <20260503062109.0469201428642a4f7fcfd915@linux-foundation.org>
In-Reply-To: <CAA1CXcBJFoqDrkQbRE6JnpV-gjfNXe2sUxaCyXPC82h3qk9Jig@mail.gmail.com>
References: <20260419185750.260784-1-npache@redhat.com>
	<20260424065828.031775921990de37f83a2468@linux-foundation.org>
	<CAA1CXcBJFoqDrkQbRE6JnpV-gjfNXe2sUxaCyXPC82h3qk9Jig@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50559C000B
X-Rspam-User: 
X-Stat-Signature: fypfo46xdtf3xacyfu4zo74gpqaswp5b
X-HE-Tag: 1777814485-139336
X-HE-Meta: U2FsdGVkX1/HUwKLip0DWPXYN/evnUbETQDjab6SIVEus9O2PYBqWFxUCWsaQEX8vohETDy6sGDXn7lWNNEkCYXCqDdEui9mKsTdU8Bk25ymdjjvkT6y+UbWeKpJpkNOuGY6IGM5+PHyLpBq/YG0Amdxpcbum7EwqgaJQFQNC4avb7VFFip9rwHg+EdofhtmyUU38cZKPtbnDMQwFOtDqK7Ym+dbZtIzCThZd+CWoFfJzAZR1svQE/MUzJBAMViXJfY8Wrj2+HP2Qmu9bIbKpi83q30DLH5WqqAYqiiCBUXvo6njJqWOzsFrU4ujbfPPpZq2kZ6rDUz/+iXIcWW8mRF9MHi49Xvypa+InQLUjTw0g1smNsKf5PNADZVrK2KoIoe9KMuMfSywmpNINpp7+S41Zd0x/x6ZfivLZM/rCnHUp83l28XmN3KAJ5tBIg2Es+11XzVJlM9Q1hH1HL0iqAhXiLNdnGfh/IF9Akj0hEhHYsPqwwPVgnGNqa2XGuGUk7Wwp+ZS+T58l+XZqbj/UCW6DJnUycpTuQbkT0WWfcL4Xqg+e9sKB4cvZColXz8OLtBDtSoT30wl/x+37i1ZpueKrXxlvl4MHvYSbkskQjna0JpVy86TBFAsOph3Tg/z1yeqjNf5B7xXCYPHPFU7TQur52pv+UiTaaLiLWH2bsciPG09aTXnp2kMArpKizBTfI2JMevJr3MHU7IyddXtqoOcnF9g16kWN8FaCivFXud8B+4e7MVUT6R7bQZAos0iUMGWGct+srmZHe4QCmhiPc+iO/JJEDlbcZSBuOMXUC//WyGJU6+D9LBs+D0dRLZhAjxTHsl4IprIa5MqvZAfXTQpMLWp1uLgy3mMymq83GXOg8lCeZ0wcZAcF57M+IhFIM3sTOG+B3Ihc5+Uocj4jwirF95TP/ncaciAGF9nfadty5rRkpKxHD8s6gc2vBbCfSpc1E1BDyaaoxoTrGp
 becuSCZs
 T1zcrPnfXw1YimglZDZKZXfNJhtrlF/IVuNzbJ7bNtGdo/EF3obICv7VjMbSLLAIVDgkPoZgsytOICdQ4hEPgyXo4HVFyFdreQAnXKzqNAu6Qt7+XlMSO3hcOoLJ5RDNP0e0mmCRD8nlPc+UTk5GN585yMxFs+24vHtdGHvZjE339xVDw5e5hRLYT18BvjvQYQuzvZaYIHvLUCisjM9w0eBxxBDAFZFLla1VZEOCdBOxmxnEdooQLIP8gEmECe/YbuPxpra6MSSkuq+sU2ZiRse5ARttIGCqeukz9AGMCGaudQdnyf63aNfKktBhZZeYEXsbu7ow/sZRI2QQz5kNJxB1wpePy9S5lVQBdg+1mclqNGY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 May 2026 06:23:31 -0600 Nico Pache <npache@redhat.com> wrote:

>  Can you please pull the changes from the
> staging branch so I can resend it soon (probably after LSFMM, so no
> rush)?

np, I've removed v16 from mm.git.

