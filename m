Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC90ECA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF5B56B0027; Fri, 29 Aug 2025 03:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5936B0028; Fri, 29 Aug 2025 03:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94676B002D; Fri, 29 Aug 2025 03:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B78346B0027
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:17:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A5E8160597
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:17:38 +0000 (UTC)
X-FDA: 83828939796.27.3B5BE6B
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8ECB1C0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:17:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=qglSs33k;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=HrLnCpRQ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vNSad52aBrW/gbkd9CRAeWQXdQBZ237EXpTRnMLWU/0=;
	b=dYiWCMVwrm/oIG2VJX45G9phrGcvgSh9D9qUJDEbkEs5kzyU7SwA7KXopJ38ShPCVp47vK
	XawnX3KEWgImuYoMQz/wSWJBYG9hOBn7nYkDTwxmmN1LFasUFthViWreK1L4EBs0bx6tzo
	I/vT5i82/6QUmHZ9JjBVv/AP+3mQBmU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=qglSs33k;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=HrLnCpRQ;
	spf=none (imf21.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451856; a=rsa-sha256;
	cv=none;
	b=nvlGV24Ds5QI3/M+CylX6XVzDy+dfUNGJiEOwr+/O+irv7wEFPQqvqb6I0m/yE2DLMN5Ya
	Lj1xMvbSL7eVbcKJrkYmYjDYJHSrmax6IC7ScwR/TxatP/l/w9EaJftjHXNDmO+cgJTZJq
	FgC/SMw4Xz7i3sr+ZJSP6YmhMqJg3Pk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1756451853; x=1757056653;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=vNSad52aBrW/gbkd9CRAeWQXdQBZ237EXpTRnMLWU/0=;
	b=qglSs33kjKLVStmyCTImUb3HM1CVAO1GdmLl4a7I+RqoWe2lcOvnsWIBih85REuY4FHlJ/OFuqY1p
	 mEZPE9Zko8zLlgfBXZgWiFfLTtYveJne9T3MZhN5Y4AGy7IjGQACD98UQEHB84+b8lH4MqNa3VkKAc
	 8zxkl46I5NkY1/QQvJYGrUJSJ7mtXLcDc9lHV4fGtpCOB59dBus2oFs6Y9oJNYw9FhCSvpshslH4RB
	 46PcMYY1B6jMaHIy8JAhrLxapabwP5aofmbrCp0TrPrRR4NlS26DzMmTYLlAgZ78spcmb4o0+9hzn8
	 M3TU+GOlMQl2tYNovy601LRob4Zu7dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1756451853; x=1757056653;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=vNSad52aBrW/gbkd9CRAeWQXdQBZ237EXpTRnMLWU/0=;
	b=HrLnCpRQI3jFYuLAMCltoTf6/IViB3Rydh7f9UKA47DxyYUsZaUINxTN/LCvf1nZwOkIN+KfLrRpJ
	 68fEI/xDg==
X-HalOne-ID: 3a975893-84a8-11f0-8b9a-c9fa7b04d629
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay1.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 3a975893-84a8-11f0-8b9a-c9fa7b04d629;
	Fri, 29 Aug 2025 07:17:32 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Bjorn Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v5 0/2] rust: zpool: add abstraction for zpool drivers
Date: Fri, 29 Aug 2025 09:17:09 +0200
Message-Id: <20250829071709.1973086-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E8ECB1C0006
X-Stat-Signature: rh4fj73mrj56ho4xpeyie5crt8eobgqe
X-Rspam-User: 
X-HE-Tag: 1756451855-981496
X-HE-Meta: U2FsdGVkX1/dS63Nd7XfQaFjY559Jskips7hfLRWYiXk2PDGQraKUBMGzgmwiKv4BVmgrOkW1jokOEPE8JXw8fQEXtrVcw2Lr0UbAaZBE7lSy4uJPqzthVf04GCK8TF0AGuRcUsjbZU85e9cJNxP/ggIzQfav5cKoNEnJiu9JE9ZTaRjHIZKsT226/OzQVnO2jm5yDCvl9EQUjKuBO+OoVwLmBaFn4blsjYP6hfddmQpo+x959oNZyLvhqNpMSKnY6pfVcBhUXmmKIi5D1FrmC8qFsDebsoJjxgPgGsJUszfAUdG7HGaBoEuVp7fpmay2UCEk/NOWiAKA0AHgrpXEafY73PsZUrn9PzMGYmCg6FKzoTrkAE4T6MM8abXKeRLEjokkxAgjn9soqdu1KfC/vzIy2S98MM0CHMxeSXrBjywlfTcX9pnped2sKZv5SkEZlrkzcnEEA/9C/FV5H/9dF42O9nYvmY1t21IakUC2PFOFVdH8WmZc4T8PZ9yFaGELgVgXvMmDpFdm6I7sK2u4vFC3/ZwIvkwWmffa94hl+G4dgx6MQQKRdJi7s5NomaFD3oI7UU+mgJf9lL1H70vqTqBpcKpGeLusAgCHo2F7gt3ciovL/3H+QKx9TdLx/CA56TO/2qJLN19TZEfhoZV9XeDS44pZgx0gZExt72UKc457UFJFjqhZwJfuJJzkEMwKG0bSI62Xt6RM0Qe+NPgD3wx6zhRfL3DVIp1ST8LfgSRmyBOPSVExVaDa1SjNeGAS6jY2Etm4ZwAd5WjHyGyaiACCD0VgS8UrpBJL0IaKgp1Hq8cZXHF/lRD5brHkDEJh8NgarZF2E3CH4B+5qmakHnSaNgTizHVOOf+dSqqjGuaBc6bGZ0481ueGXEUq1ttIdiqGh8C2Qs60AMxAZWWLm0YtD+sUGDKBXEpbkTTjaAQvKK3VQ0TdhAjJ/ZoIxdvuMILThuSnn3ZmHimTRq
 VkEbAu43
 OADL/mg/hLK5uNe1MGfUdaHzXYZ2VxQXjqqH9djrEDAhCilreOeoswo30RUoU5BgIwyNoyNKcYfDuasfVw9+HhcuZT04yK37Z5gFPEMmHV0SXriQzZ47X0CARP6f2xLCMq7ADtQ6ZfcVkTwNMvKDoJ5te71EWJnfuqsyuugcBz6whlS/A16HKU+x0FkK6n/NPBlmsmbKAWqsLU75e3dqQegarav08Bp62WANUFB4QOq4bOp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zpool is a common frontend for memory storage pool implementations.
These pools are typically used to store compressed memory objects,
e. g. for Zswap, the lightweight compressed cache for swap pages.

This patch provides the interface to use Zpool in Rust kernel code,
thus enabling Rust implementations of Zpool allocators for arbitrary
Zpool users.

Co-developed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
Changelog:
v1 -> v2:
* reworked to stick to the existing Rust driver infrastructure
* removed raw pointers from the Rust API
v2 -> v3:
* detailed safety requirements for unsafe API functions
* removed unwrap()
* some typo corrections
v3 -> v4:
* added a working example of zpool Rust API usage in the
  documentation part
* change to Flags arranged as a separate patch
* improved safety requirements for ZpoolDriver trait
v4 -> v5:
* created a new type ZpoolHandle for handle representation on the
  Rust side
* improved description of Flags::from_raw()
* pool is no more borrowed as mutable for ZpoolDriver::malloc()
* ZpoolDriver::destroy() removed
* improved ZpoolDriver implementation example
* typos/markup corrections
* new files added to MAINTAINERS
---
 MAINTAINERS                     |    2 
 rust/bindings/bindings_helper.h |    1 
 rust/helpers/helpers.c          |    1 
 rust/helpers/zpool.c            |    8 +
 rust/kernel/alloc.rs            |    7 +
 rust/kernel/lib.rs              |    2 
 rust/kernel/zpool.rs            |  377 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 398 insertions(+)

