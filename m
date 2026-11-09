Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E51E606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MMq0OsFY
Received: by kanga.kvack.org (Postfix)
	id 9EBCD6B05B1; Mon,  9 Nov 2026 00:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974F16B05B2; Mon,  9 Nov 2026 00:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FAB6B05B5; Mon,  9 Nov 2026 00:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5900F6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:48:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C11381A05EC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:48:34 +0000 (UTC)
X-FDA: 85414500948.16.8239CB0
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	by imf09.hostedemail.com (Postfix) with ESMTP id 26D5F140005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:48:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MMq0OsFY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSOyM4K5zrqmDFF61CwIn14s5ShEHbu2alo+0Cxugro=;
	b=nG2/dS56bIb38oRqK3fJvNuX+ts8Xcch+7zmdaL/NJnXwYw8BZZ11zBXwlZ2mQmE3YDfgj
	E7jcMafQAMYp+dKgwFjXGa+M7WL0zegt+QK7Hnp5G+5tFqPTTZv4oCW9p69FFTLGzpn/Ad
	WDkO4l0ano1H1ayS2UEAZ8YPtxmgLi4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MMq0OsFY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203313;
	b=bcsa6ZvxkAdE/BSn2pn1ouBLUWGUWJ4KgzYG5AST5HcexYQWA0aZoYz75d9nPiDupSesSR
	cqgwPwaATz7ngg1toJ3HmCPK1pS1U0rjT85IRvFIpwtmje+lI8+xxhk8liniXVKK+D9kVc
	6qqhwKVtFxkDyeSZ5vCi7IkW6fw4PLI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JSOyM4K5zrqmDFF61CwIn14s5ShEHbu2alo+0Cxugro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203309; v=1; x=1794808109;
 b=MMq0OsFYOeDFfLKeanMq/JRW5emG22N+JN82VeucMQQPT+M2lExIrVamS+c7q+asXdJ1pdl2
 1X0kSw1FOEdPQI/obnIvW1WVZJsWlAMtC3SyfA526L1kdBXP241tfsR5N7B2uuz87yZGgwPpUpd
 dE+PwLyiJkXRbdzGAO40uSAY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bae7ce2de6921a50;
	Mon, 09 Nov 2026 05:48:29 +0000
X-Mizu-Trace-ID: bae7ce2de6921a50
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 4/5] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Date: Mon,  9 Nov 2026 13:48:23 +0800
Message-ID: <20261109054823.45056-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261107043122.25650-5-songmuchun@bytedance.com>
References: <20261107043122.25650-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 26D5F140005
X-Stat-Signature: zhuxoz3mqznfi3i8qj5r41srsubio91y
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794203310-79054
X-HE-Meta: U2FsdGVkX1/EavlbxUnyPzESo7ARtKg3i1KsnyUc6p8DWsTpmwYviLuxyw6sRzF5fGvXdGWWAJwxkJKych+BOyVrNFFniGcB9jiRaXd/pNDFlo14Ambf4vFlGBYY1ONdDbU/JhMyyJYwkXwZtmfecJT0kmvnYDUxXoUJdTlHdM/BC8skT4lsBRU4XLFLC7mKDeoWEmDf1+SPvrzzllutyuiqP1RUgAjd22O5f2XerU3Cb2QJSKObwr3bvWPgidAw9LIqqA2TskU/42mGOdZH7fsT0NC0UPyCMDjdUmizlcwSyC3UEpxmvgqPQau6yaUvUprjkDvZAfaGZqpuk5bIndQwUSHxMEoCuz4fk0N/rWJ2qkxFRtdSZDjWrTugOYPRgCpnvMk9W4uwfdbWVVy+v1z3Jsy03WxfEnHCLUqZBQLY9Fqag6El6yUGO8+ZUsQ7IQitdB6OScCC+pjx5QR1aiNaKI/dyvoJcoghslv993kE1/NXPC/PcPduK4eYJ762s9DBdCWu7Y2bM5DC1r2U162ba2Nwk9rlZdSzRbYUuGPhbAsyjPfm3NjIb9q1mjhv+80JVV3DEgA8UzE21C77w2nZZNbswlmetoAwQ9yoIG1a5ae6W3Uai3MPSqvYEIX2fzQNIO/pvAiVvuZSBwhXoNO14A4byNiML4i5X17ofhYwo94GtqWz7gzMPosKrNQD8ARTqwX79DZFwymK2ZB+6YKM1YRVBDKnmR0gLzFl/ajPUVeDCBAP41qYlRiLgsCBp9zCKe6f88ee7HTp5v6wVUnf0X+yhKCVWEU28XA7/STINp7l9h/iZ6kjD8AJx/pNZqsIa52rYpfJp1rrma+NE7lJGrWdojdq802SplLAhFhyCuEg2mDp9wGWndd0kft+zbchxu/CZQFU9TXNsj/EBq4n6i0hZOalP88zV04yND6v18mTBeQ4F+Nya8KtV0aOxC0gmrkBrgYYJaZS8z0
 eq4AZRSU
 B8Zyr0Flk85ie3Jysp0/PvfVtcKoD/a2bpBrmd0eUmYmIpHsDCWKnA3edHwTudI4VJjxASycAToYivXGeW8ydreNprRcoc1LyygAQeK+73R516H8ifAHLsWckwtrA22XU7N1Sr7ChtK/JxdN6HOQ6/eooYoHf73zLNzI2FXlyF4VAR11/WHCAntrUxTjo7buyXAl92R04LvQ9QGbnYCaXjaCm06q3I4DJAuqM3H9lKYuzAfYjTmpbIqwUiDc4bUZV94t6lAkMbTCQqSvlZLZm39pgU+pkfVdD5MZaXn767s/PY/gbZwz4CetGYkMW9y6pgZdoaxGMqSoPn7v2aAa/341/Hc31FQS8gehRg2xW3oGmk9hkgDz3OPExJjj769Xbfcq9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Nov 07, 2026 at 12:31:21PM +0800, Muchun Song wrote:
>section_vmemmap_optimizable() can already decide whether a section uses
>vmemmap optimization based on the section compound order. The DAX-specific
>vmemmap_can_optimize() helper duplicates that policy, so remove it to
>simplify the code.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

With the arch fallbacks handled by the previous patches, we can just drop
vmemmap_can_optimize() now ;)

Nothing jumped out at me, so:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

