Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC50F8E497
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC6C6B0092; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76086B0093; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFE06B0095; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB4E6B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:11:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58274BC57B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:34 +0000 (UTC)
X-FDA: 84666270108.23.EB0C45F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6EDA01C000E
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:11:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=i8AMfNng;
	spf=pass (imf21.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF6BAkaWeZSEzVzHk2UHuLEjOQIP9lDChzxOI4INJVA=;
	b=Hj0PmjDcaaFhsfpoIt962Y0PxhMSe14v+Y05ohYMFn00LS0t9ExqpN83xj3oei5d/orh+3
	tOuEIsOolgXpD2YuU2oXabGOUNhEVdui+Vmp+Dq+ZvQS3twft5Fd6Riy2kvSgiIVJroqrO
	EBRXBX1iYX6/a1xbFk49VLQFLRxqdWA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=korg header.b=i8AMfNng;
	spf=pass (imf21.hostedemail.com: domain of alvin.sun@linux.dev designates 172.234.252.31 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388292; a=rsa-sha256;
	cv=none;
	b=hkw1haq2qxj32FjuAnqTPMtPIDJKS6KzHKzOs3HY3O59MHlXBEMwWw/x1UATcvr8fEWmpj
	Kt9yWQKSC+btjHTVSF4GSfhj7N8aQGIIULRhF0BsC1JsfKFkv9wzWy14eDNpK4JSjMVOfX
	zHc9RcaVYGvieROMZdmqZt3qP6XPxAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 148694456F;
	Fri, 17 Apr 2026 01:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCF45C2BCC9;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux.dev; s=korg;
	t=1776388291; bh=hv4TGP+tCPibLRF/F0RTc2CpoNa3r8c8YYHZgnw/d40=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=i8AMfNngDCDZb91lDsQvXzYUhSWj58fXjzfjM1iZtDmJP+h/w321m3HW883F2d5hi
	 o2XeDVryOXExKc8DjjVN/7e4J7vQCaCJY75TDslFIH1dO8q4EWU5PA8lwxqZ0wj7js
	 JEtHhegt7YplY0sWBY8VQLvQF6DmyJj4K2L7MKos=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EBFF8E49B;
	Fri, 17 Apr 2026 01:11:30 +0000 (UTC)
From: Alvin Sun <alvin.sun@linux.dev>
Date: Fri, 17 Apr 2026 09:05:51 +0800
Subject: [PATCH 1/4] rust: sizes: add SZ_4G constant
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
In-Reply-To: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776388289; l=622;
 i=alvin.sun@linux.dev; s=20260317; h=from:subject:message-id;
 bh=hv4TGP+tCPibLRF/F0RTc2CpoNa3r8c8YYHZgnw/d40=;
 b=S+iNkF483U9WR+fhQWZU8CgLNpKK5tzKrdQpDfJeKwwAKFnq1eIQG1QE2Vbudm17yD5D1Q1Ah
 LRbBsIrxCZ2AxirhO4muyub2XCtogmNE3/Jmde3gYKeYH9JshdNEVqm
X-Developer-Key: i=alvin.sun@linux.dev; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for alvin.sun@linux.dev/20260317 with
 auth_id=684
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EDA01C000E
X-Stat-Signature: whwdmox5bptqchey4jkyor631yw686qr
X-Rspam-User: 
X-HE-Tag: 1776388292-708991
X-HE-Meta: U2FsdGVkX1/BbpmMeJScPv3RYSX/pqm/h9mskblb6ByK53Hsff5COD1nXqy5cfcGKW6TJ96IUOrD5Olazjxk+6pQa20Gdui/X5V1JE8SnPqaWLXodRaOOsQdBPkMDobxlM0t5RzxlBa69WI1y1r690n4GMYqu9GK+CO9/7mw2ZEEuy71l2rDrq1uGr5M7KFa70GG8LU1umqHrJY+3egz3IMCMoySAGs0nioP7svSWKQgX6lNh1AzD7EC+cae94OqhIcyNm17JXh5OYMXZrXC7OYzZUoLuoIvt4N6j+wodTHILZ4hLe+L06b57M/A3t5vwXzmrPteb5WHZ5422SvmCQXr7ToattCeQBE9H12FYpsRTN9HYUaNDxDAu+oTLqJOlNcXdp9qEWP867MZDeAtVC0dcfizeDvfNzzF5lCaWiC+8xTAsdUAm7kqk9y/jIHwRFpc4XeT/VFoURRVu4+yIL4uT8fT9z/MBPT2j43Tb+XzHv50B8uPmm8lg5awd1pOrexS8ZLXmxWsL5I0a5b4hwiBHp8wVWekpi7C0USQlULDcGcPWWWWjI/yDMVdd7jEyBKMmFDOjYhdLPw6DtVGR2zRqva+18SmzavpM9StD3jfFETwQ6eMg4ezV1rCq0N5fQd3zc/SQYquE8nIVoq/BN3bWzzZZvhWjFe2UwUhPHneXhEIQ8UwxLz3RY14N7HCgvH4E1qEEbvvOXsWBsaz42GlzI9xl4H80HuWRXXsbRKQXnzyCwZUVgTYSh/bZChPziSJ/KHbZbek/ItkZUzt6vSxDMJ1m+jO9BMlijRLUBnLJ2IDkXCtOX5WlPdU4YdXANwIqASEryW1X4YUqZ5yQGzEWRddnC8VpSsUtzg7+js9iV+YcGiRK6d3Sk1qXTFl3dtm2xwGFs6EW/f16hkpTwOnQAybpHAdLDnWBHsJbRrozRvxEFRaTik8qYu8JMsArAU1ZL6/vfQrggghmI0
 uC7Cupf7
 VdXmql4ULRAlstuFlJp9ffRri2dbwd2UK5iJr17eNnrw65ZR23ZTN0rkx3iXtM0DXxmHZYIBOxrsZwxtmoHsujeC3dOf9NldsuuR896sEcEb24oPmgTmr9D8Ro/pbQeWQ8//VIbF7E9fGpDg7zzonUrz9W077DZloeAlTf+YY0edroFb4t2l6LYi7cikwUtEVyby9whtNstGrVgZ2qSQMFQmPFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add SZ_4G constant defined as SZ_2G * 2. This constant will be used by
the Tyr driver for calculating user and kernel VA layout.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/sizes.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
index 661e680d93306..872f5bb181ecf 100644
--- a/rust/kernel/sizes.rs
+++ b/rust/kernel/sizes.rs
@@ -48,3 +48,5 @@
 pub const SZ_1G: usize = bindings::SZ_1G as usize;
 /// 0x80000000
 pub const SZ_2G: usize = bindings::SZ_2G as usize;
+/// 0x100000000
+pub const SZ_4G: usize = SZ_2G * 2;

-- 
2.43.0



