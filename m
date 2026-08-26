Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61EA9C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C5E6B008C; Wed, 26 Aug 2026 17:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCF26B0092; Wed, 26 Aug 2026 17:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9726B0095; Wed, 26 Aug 2026 17:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C7CC56B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:43:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56FA1401E7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:05 +0000 (UTC)
X-FDA: 85144746330.06.38134C1
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D1ECA0009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=TLIrC9qN;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787780583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=rFh8K9X6Cb287z6h8TyTAFxq2uilJCdUc/GfOmstgL89keJxPMjcTDLwV5Df8KH2HOToZo
	rrHabQwS7jVlrIpzF5rbTXQczYYB3KC4WvMZBECLam4+m0WxMpZSNwcD6ij+BbyZz+D6TH
	ErWHuCheVZwAc2vEgRKLdPv8nvOYrYE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787780583;
	b=2FJjpYHNQfLs843Tn5nTShDuiGjM3bE24S2Os5sxL5Qu2gZMgmec53I7TZbNGBng2hJJ6A
	hmu7FAWuOGKbp6tkvedrM/5vpnpVsMtQZnFkRUhldfnLqFSDIVO/VQ8PhFa6K0zcuHTZ/8
	qauahcEQlUjCzu5nu3QUZugDmcNSbc8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=TLIrC9qN;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1787780568; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=FNVd718H131dLQmwNYsgt3Kj1GXZpHMizVGMwUuAlEZPK9tMtEBASFejMOkY4SknwfAe0dJCxqdlO/qsceWKfqG8sciKvier/AfthmoBoUPyHrGnIfQ6k9JW1YQCAW7FKTJeCC1dbcvGsRvN+ed2s4N/6raLPXJBcfq7wMU4M+4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787780568; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=; 
	b=U6D5Udi58fpwJpCnVxaAEgPdrrAR5NRTshGe/SziK92GoILdh/GZl/PgsPalPMVUq8CsczCzEEd6JafZkaq2EQ/BjZu0zU68l21P75VEVp8swg2KnRYqnre0pdg3lz9yR5hLMpyrQK3nH0/cZzFTtYCKLDcdXJ4JhIE82MsSGTY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787780568;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=aTrG2U3nnsahZNHEmxNMi33V9p9IP53O5HAC6ElbmRA=;
	b=TLIrC9qNZ15On1ncutqU1nUvypenOamHL0MbURxjZNUZlNsJQTwm5BNdM0f1/oru
	CNJqqVRCI+EJ2jImt38la+g0FvtJ/jHY+pcdBCxbdm9jyLjs811RP1aoxsM3oJoYf1Q
	M0PQ0oyvIatFJnb3jMhE+JEjt9wDSgfj3h5zokUA=
Received: by mx.zohomail.com with SMTPS id 1787780566270342.6469272564714;
	Wed, 26 Aug 2026 14:42:46 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 01/11] rust: xarray: minor formatting fixes
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-1-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 18:42:22 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 Daniel Gomez <da.gomez@samsung.com>,
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>
Content-Transfer-Encoding: 7bit
Message-Id: <509646C4-8225-41C3-8A32-96CD105EA302@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-1-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D1ECA0009
X-Stat-Signature: k6p5iba3tswx93488kxkrzzx1exty7qk
X-HE-Tag: 1787780583-544463
X-HE-Meta: U2FsdGVkX19StnZDxd5hwlKUOWLkb1RsIxDThddEGzW4ByFMCB7/8zrD5cWaAOfkPTyPaKcipq2rheuxL0IldLInCWHYAAyr8Vq9PSpuvsczboODF9H//RZ6bQ4+zMpQADN/JkAaxHHVQGgWnAZlCAeRH6YI1rWpC5we9ofb00arMgMgzlueODoJGisFqpvKB9OWKoxfgfJe0na0A+4sihyom29MGCsMGyjOdeufwuFEgYWbFDNRxlg+sDk3tPkEV5s0kj/a8O6cFnRE7i5fTsmbesHzB0/DfleQepzgFJbh1ga4xjPaiaiBmOpaRR+DSwldw9BjJwuuJ+b4xuFJXTwhdtmuIPrh2JFF6v6KSZMxweecooKjfoaRTIJBD5lyzghxEUVQoHfXk5KECFMgg2eapISc+YIoq6ull/JT2dMkp62ZPvC3gTJ9PsfgaJIf/q6o53w1VNp3XRI1tWtf8DKHgKMy/j4kn8wssyiU4k6v8vF1NgiwaC8Fe9FhalaPC1ta9LqOuwrHo4+O1J2jFQNntMymqL3XqBRH9No9V7n8YVV5auxogGrn00LD85vWPHxNhdAksbHlQzqtB8DGnK/UMB4BvbLZW0+Q+qcHbKIbymM/Ct/aYnaHFl0/HFInitueEbna1P59hQlmEBUp50vv0CZONhq/fqt2meZ2TDVQi9ok0He0FZELMrBxdKloZpJG6DKyIpL3bGWtRzOME/lBj4zQZJYXMXhMUwHf/TSlsmgLf5tjNqQd5GzXi2MeJpkp7Tq86LfLP/TbrabTGbsVsNF8kjdXeqqdd+YO5V8mLUTjRmj6Rw5bDf3JMtaZpqWkMDmIqMs0gOX8pJMQHP3C1PCQ5D7nP70acXu22rLEGtwdqEQREwuI4wpIL/5rm8x1K3GazLKAijFVdWA5kuwbOexhfJwIfX1uZXn/JSwHrfanC2hBYO1ti9xIe0krNcHIFaOlAflebhesdQn
 wpCm//ae
 FmXu45c0Smu7Rvzy4F6DVMEppKhwUf9r7+dBqtaXDaNqRxhgLjWHWCU4b2BE+r1jqrDTq+clmhUi3lnLGpOvLa00SOl8dcIzT360oZ1abfedG3/BIv/PRP8vKrqOxYCm46WVrZVMpxK0Gba/lgYraxaFSfNpUlgjH8jLbeNg8pZcjI5kt60AEIujr+e9eNrJuVBaP91WxYRE4jMkV1EcLogHyDrd4frkznk9LDlG6pFC6AYoJCf6Icy6UM9sKbuZbcDb0ogLLcVMtY9XzYEH48En0c9ZJtbwLYHYNdDvKIow4cuDyH4auLMRSU49BgQMJD3msW6TVNn78etjyLLk6vkJoBZ1wCUxkBNoaTgmgKGKyqfuwZLQTDd5PX6bXwkyPXTObSCd3Ll7A6EpU8gEv7slth0bxeYLidSVdv2Nc5XKEoYD9JouEdhuRWWXrBXFMg+XQ+PueBiKBvJyRVjrPLNp765JuJwJKHOxDE3Nq8rwtFdGhsn5iMgjuQIFxTsoCZVi5KN3y5yZzuGw6F79uGQC0xXRn+wc3vvTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

