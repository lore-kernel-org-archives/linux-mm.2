Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735E4CA0EED
	for <linux-mm@archiver.kernel.org>; Sat, 23 Aug 2025 13:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA4F8E0025; Sat, 23 Aug 2025 09:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2CC8E0018; Sat, 23 Aug 2025 09:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9828E0025; Sat, 23 Aug 2025 09:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5857F8E0018
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 09:05:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB93B1DDE92
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:05:17 +0000 (UTC)
X-FDA: 83808043074.03.C52F310
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC7394001B
	for <linux-mm@kvack.org>; Sat, 23 Aug 2025 13:05:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=Klob4DAx;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=bxvj28n8
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755954316; a=rsa-sha256;
	cv=none;
	b=CzvcH9r+AUiS5ldOs7Kdk6xkVN80ZQm90QiCFHHmIgTBbRSNc+/ghTKm5ngGld5vh2cr6F
	gyYm1QI9zcWLCjq4kdwVLi0so+8ggCepJDSEnKPe6+9Lnxx4An++0plDunYFBErM0q8OY2
	8yPtDNVw9Li6fijLh2S2DOSyOiVm4dM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b=Klob4DAx;
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=bxvj28n8;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755954316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/+5QaPnbawAB9+9CprgOyXuWrPA3BDw+ITmY3eFxYI=;
	b=vC3g1eS9arCkEU574wxBx/PC3561ux+UclOt2YC1ap6cYoq0yscUQ+mJQy2SeWWOPmt1t0
	Z9Y6gHPaRn4j7Awox0OAXQ6FHXaLfA96DbWAyDn4csVNGCRa4S+ddLvjbu/J+EGtE/E969
	mMxctnpBuszbtq8NzzXFrfsJ97szrKw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1755954313; x=1756559113;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=5/+5QaPnbawAB9+9CprgOyXuWrPA3BDw+ITmY3eFxYI=;
	b=Klob4DAx9tUzA2YL0N54l5w43RiBgkpJvmvNrJD2E/AMyubgG628hbNU0XsILyRhobocK6l16eUEs
	 7r7dNgZAACwG6D/d/X3sYcuTDVc8WO76dM5bCKIsBfUCOvrONEFZeSC3joCzDB8y5x3oDfvsiIZ9uV
	 1JiLZ2hjrDAxiBs1mn42nXj1kOs0PSr81w/IKTJqzsUABcd7TGod1NTM21K6ydHEELtzY8v+GYiSN+
	 L1KBMK205AsZmZLv8J4SgPzbZjCPtwwztH2BjXIyaIHa8kBw3qnhiI4n+UfSfp9ApJnUY7Sa0t8D5r
	 AQ5Mn35vDcjB9JGtMUgbHM/f/KY4DNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1755954313; x=1756559113;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:references:in-reply-to:message-id:date:
	 subject:cc:to:from:from;
	bh=5/+5QaPnbawAB9+9CprgOyXuWrPA3BDw+ITmY3eFxYI=;
	b=bxvj28n8v53SeZTzpDLY4K5hgIa2b/hVHYJ3/EfptsPSWYr6r0UG+GcYg5BGQ6YMb08PqbLlKdiMs
	 6cYSDvgDg==
X-HalOne-ID: cd25f38d-8021-11f0-a170-494313b7f784
Received: from localhost.localdomain (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay6.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id cd25f38d-8021-11f0-a170-494313b7f784;
	Sat, 23 Aug 2025 13:05:12 +0000 (UTC)
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
Subject: [PATCH v4 1/2] rust: alloc: add from_raw method to Flags
Date: Sat, 23 Aug 2025 15:05:08 +0200
Message-Id: <20250823130508.867235-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250823130420.867133-1-vitaly.wool@konsulko.se>
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DC7394001B
X-Stat-Signature: aewzzn8eszsobcgc89ytcpr6jjdzhsob
X-HE-Tag: 1755954315-967049
X-HE-Meta: U2FsdGVkX18iAe0KcBEC15ykD1jY2LTETh2KRenYwdFFRQ53yWUBOV0XC573FBM0mtX3mkZR5B277elONGrO7NTYVumXiRd2bsQ7gHDmTL9tru3P2pSqC66Gn75KFLmheYfbvw9voMVjVEXDd/4cN0B9KhNim6wSpOnxm1O3qQWFxPDqBlRuNHmQ93uSTwlMs1lBgQfJA6sdbHJwkIyz16usccX/crbtwQvuvH3NF3Piq64gnJCTnvA9sQexWirwyn8Cl0j/51xDTX59JvAk97uSMLanrmsgezutLJZvGTRq1Bvyt55JfKkozeb0qq57uAgUpfZlWosEK7CRTYbo9EkMKiFgayerubrQH6vBR4/IeggDUNZDJUpDWqpqi9KZWj0U1ZvCs7n7oDCDn1yAjjxWzo7bFuH71i8WnbMDNdD1ufPN4IDezup8muXy4OpbUlODAlSC1pAOYNiB4WAx7ND40+pZkbil7A89wMpVWL4t5LbLmFCg7yzwxaOwIwodr2A9uhGb/i+C1YYTqAuplMoVTrUpNhH9evtlLR0sVxO0L6ROOtXnS/Adb1L9sllTI52cXuL5sue7rJxEN/oahwwHkVnRhGx/i6cF94AfjtCInmAzfp2a2UIJfHjezJJNRgbSJ3gTQLHVYsA+BeJX9b6Qz8C2e5l9H+5rViF6sSIkBkGffnHIWyjLNUtt4JEzRNQNp1WtGCg4xmbT3oZJGXuFhyuzbbUzq0du/LQTb16dXRMgWgtPtTUZO13JqFdjgSIeVgbQ56+XdEspd+UKtaR0CTYdUr6Cnru5JBj5hh2CwBCTJInHnE6qqvGdO6bsHEVtZT+GDEXe3YzrXamX/Yfn2qtllCKFRwf5Mg8ByFwcqQc42fzIrmww/hGRqiCWzPtWzCT26E1PsNv634M2kZgpayw3qkAh0n/iIxFcVGiL90Gisa5jiw4voFoKI4nGejYANfLmOEUZhZURht7
 /ScNUGm8
 yMQ3yMou1AIqoCgl7Z1cRkJreypWYZPU3X3QoMVnjmxfRF3cRBuUBWOuBwyF5t4TezPKofwLVub+zhcxH334WMgyJzWYie21Jft1xLmbb+1MrqIP29HjXDxFcpvW1LEpGUIBtHv9+z9mvz5H9WFziZdo0vRCHnYmxfyWC8MSt4Bs/Z2NPZcYmxojeC6Ud3kcRP/NhgP1LjtUVVALdE6l1fNkaHlrPVtt8Y8iblEOshqQZXM0i4wymek0ajnPuSyGQLsM7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We need to be able to create Flags from its raw representation as u32
to properly map zpool C API into Rust. This patch adds from_raw method
to Flags and makes it crate private.

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 rust/kernel/alloc.rs | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index b39c279236f5..808bd4281164 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -41,6 +41,11 @@
 pub struct Flags(u32);
 
 impl Flags {
+    /// Create from the raw representation
+    pub(crate) fn from_raw(f: u32) -> Self {
+        Self(f)
+    }
+
     /// Get the raw representation of this flag.
     pub(crate) fn as_raw(self) -> u32 {
         self.0
-- 
2.39.2


