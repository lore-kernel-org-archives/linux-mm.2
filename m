Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACA0CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65FB6B0103; Tue,  9 Jun 2026 15:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3DB86B0105; Tue,  9 Jun 2026 15:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B346B0106; Tue,  9 Jun 2026 15:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 859C16B0103
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C4821406EF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:51 +0000 (UTC)
X-FDA: 84861328902.08.87C007C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 93EB440012
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jfEuyFm/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hPzuRGlGHR6F8zQSGoWCISEe22ewkDpnFmVeBMxzdI=;
	b=bwxan1c3/ZSjZQMRznWjQczVAR5v01H+rIGlJjlfBLLQnz3fx7yU8ttJk8mBeMB0dVFmfO
	sbY21Zr4kuG18vrAd1pqif1JtijSQtTTQXoZHnfApc88nlusFpacRJNeYMgM87SNul9BmZ
	lj7A8SOzD6MLYiDJiHuMjgUIavoHjxo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jfEuyFm/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032549;
	b=ojloDpECcIsg8cFF9yxN/0yPZVHT6E1xLuy15HlGlJTlvqccru5R9qFbwNdN/bTMiVlMxM
	oj4KPSt1I0Zm7mtndZACxR9RsvFG8H4w8UUWMrNjschDbmdAzar5gSqyZ9jusLmZbGjSsD
	CewIHZY0UOnS/OmCz7VLSESAbx6/vvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1D0042E57;
	Tue,  9 Jun 2026 19:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB0A1F00898;
	Tue,  9 Jun 2026 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032548;
	bh=1hPzuRGlGHR6F8zQSGoWCISEe22ewkDpnFmVeBMxzdI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jfEuyFm/hAx6MS5urtW/zDAEkpRUKAk4cdbEVABbdlVrV+t5b+q5Qbld29ZT1yWnU
	 lfPpLpHjmMHV/OqnAiK+dvaoXKcbK+L8adV0xvRMa9m3w5GSKvvr7OeAX4dg4IOi8M
	 n1T3enn2PrweRL0/wGuXqXoVdHkPBREFWSnpQCJiIE6W7Q3GA2aZY/HGEcjOIptEyY
	 k024u37TRsmV6aSkYZc/m89BCBfYzNbBckqf56ZK2/4NgaKtMZ3VGGmo+RADdia2/i
	 ynsR4htHT6lBqCY8Za76lYCknx6AWTYz64mv16A1eg6mhOnQk//SII2Ww+bfNILznH
	 NhELfBySmcNNQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:00 +0200
Subject: [PATCH v2 21/83] block: rust: add Request::sectors() method
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-21-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1028; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=saeAx929MEumoW6R7srpYWt0jl7c4t9NDx7UHc+Auss=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTH0CYyD0Jxnz7sIleuTxhsvjwvNVqKG9as3
 3F8Reqpp6+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkxwAKCRD6UCkIqsW9
 0DhdEACqiXEmIVrM/wsxmp7AywwJPAcsP9j6NfegAc3bKCA/HCuBa3Y/zaNeXx5o//XHLGK9BJV
 O/naUSzVBIptU36gVfx2L62+wP24jh/mKBc8IFEZWqL+HvVZUKpdiwnG0ZHygZ//gsPrgNd0WEk
 Y3Kg4i7ossqWoy77DyoKcHagMdPztQ79Q1kDy+PioTtteSRFbSKtHkv7JB6wfvSqB1GhfKqQW3V
 ERsPUYYtuhV87vQ0GAGIp3VZwX90RxofIcdZ+3qR93QhhcRdha6p7Jh94AUFLDgyKu+bD/JvRNA
 bkBao4jIQxms245dn2k7sXJVgaufRLa9Qy7GgiOWpN7aUeM/JXNC1MiEQucYYOBQ8uwckuU1bom
 B6+1Y3kQDpi5G8PaTZlVMeuT0fImCQWvldoYZB5xqW7Ctf4yZ1O4/aPWcBO9fu4/cZqqaYQEVg6
 oqwWB+hpBNG2ea8vNo30qSobQN9qfBCLVBsCPd/nskjTP3+k/mbudUkEEsZAvKVcRLiYow791P0
 8QuW0znNVuCnL1T5hPxjtK/7wvEcvqILu09syvrh3FLg7bX7+a4mbGKQg7mdukiBDsErixKBsUm
 Q/myXiwyirEyQMN+IhzeVbUewjW5CN5l+eIUY/sd2rpgkZhdhz95CExMKCjVRTXGrHvfW7GItAG
 N2IkpJWR3O2Imiw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 93EB440012
X-Rspam-User: 
X-Stat-Signature: hac4qdtkxzbgijesah9swon4jsby94pj
X-Rspamd-Server: rspam09
X-HE-Tag: 1781032549-242503
X-HE-Meta: U2FsdGVkX1+ywbV7nw5fkCLaojVTThAE/2hHHMsibypq5EQaAs0AVM9oPy0c4nmkQI4lbj9iHCHnKadL+aYlgABdoE/Cb82csC85APm468xq7OFJhmPDIl0Fr7EAKVhFmM5pC/fg57ytsB/AQNIzaPJ9f13Qx7apxL6M7+de86ahu+kxNMIRXgd9KqlroVt6LGPces8PdewhAivYlkDxOsaNYL1KacD4e/Ryp1uxaMHnEfYGQPELG06zh3ynVOV2hWyXEewVHOeO26RQXCWSmdLvfj9JgoINq/CsI8vkyR3WaxlT4/7ql64Z9eoXjDMuKEl1tXcVle6j1qlA+ymANT1rCgZPEF/fFdjpc8g359a6pxNzbzktG348WDQVKmMdChI6O2JOKnXAyZY/HmOF39+O7IeMJWw5BNWYRCT0tpxCxFtrmW57VO3bJYbwtHWCqU4gGCw0BvhaiTHvwI0PZzS4kk3wPnHHWyY13KC5GtxzqnKo1knS0SdD6Wa0cp2h39hnHuH9fHnO6v68S5+zXmxNgfXIUrBZVsY/Gzamd2RWO3KKRxFtoVk9E7HHn8wAxWqXIi5pNP1kXtpg0wMMsrNw5hQGTTx/GurXXfCRnHExst6OUzOMGtzcI+jEZmDOc0mlTEy/SIJNyjeCs9+PWPM7MEVA1rjy1pzLLMS9zMi6WFctFscfR/YdLcF0SQ3aB9OSMkf4M2FPav1YQTjy6eWXHpYuuIM1WWgbNdiKown9U9JbkU4r0op2XHy9FPTlKvojJKICo6FjfTj5UJjhD7OqpwmTLZIpTS7/kCnRNgVJC7dM6rFZWEbWxQO/Grz+i5oa9LkQPcwcEklvjBmpV0F4dLcewS41BsgrBhLvRXu9UEP6x9BONzJR5y+qbEPVMU3T5NtnEMjZPCIC6BbrFJZk+tx1oX0oFKFifzMtahWrQRKbbfRoEvX+wD0vErJzrokjtvLYoDbCztLuTKj
 oPU8c9ng
 x34R/jUBn7uIvH/MImMzHVKe8Z+ZJnych3Xw1WxpfJ24mqmsr02T0FkMDmVQbrr8l3mDj6GLRi8ww3jAWKXIzYbvstoLaEPSXisKKEAbnDMb3v/EUCZKvaUBG1ELG9UqNt6MmaUOV80aFU+hMcUDrPbRWFR0CvGVz/uM8+IWb2qRY7ax1E8NTHz93+GbUphTx+unQeJS3C3YvUdipkOILjtuVdSlcKSNkjjbDABCHH9mX9RdWI8PZdThHCCXnnrvmauGQjkyZc7sp9008ujKML1Yg/KHAQWYyzHM69PCFoVjbk8Nh1ylV9rid5/qk8rF6FQj3IANeyJwpXNQdeFH57RaGVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new method to get the size of a request in number of sectors.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 19bdf17de166..54fe580b7b42 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -183,6 +183,13 @@ pub fn sector(&self) -> usize {
         unsafe { (*self.0.get()).__sector as usize }
     }
 
+    /// Get the size of the request in number of sectors.
+    #[inline(always)]
+    pub fn sectors(&self) -> usize {
+        // SAFETY: By type invariant of `Self`, `self.0` is valid and live.
+        (unsafe { (*self.0.get()).__data_len as usize }) >> crate::block::SECTOR_SHIFT
+    }
+
     /// Return a pointer to the [`RequestDataWrapper`] stored in the private area
     /// of the request structure.
     ///

-- 
2.51.2



