Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 253F9CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA766B0120; Tue,  9 Jun 2026 15:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B996B0122; Tue,  9 Jun 2026 15:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781716B0123; Tue,  9 Jun 2026 15:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 677856B0120
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0503790AA1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:17 +0000 (UTC)
X-FDA: 84861332556.20.EC86762
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2EC2410000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJGWcflN;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vBcgswxHnJVjRfzfe4sol9/FUdXWuk9h/h15LXryYU=;
	b=eUgjumQY+j5hdRkZUexxB51XBvf+Gk2qXwt7aXV4sx7fxzHdGkRIMzJxIidqojWen8puJS
	IGjDyfoA49J4aTXQNRo6tw02eGCbEskAIJEXhVRjpoDmtR+g3ukPMR1ADDq+63GJCiGS+D
	nb0Xp+AuzjZYBwQp/AgUkAA1e6M1tyA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJGWcflN;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032636;
	b=AErUxvyY80u81ZECKnCDHhQvEJGAD5fQ52/Bhtup/y0cenrUfiIMTvDZC1jDLFvfogVmIj
	47qMdSnTB8258C7Y+YC/sNoD1H9UUF70AzUQ7pwnRM059mo8E6c6wEDqKb7G1BgwZdacym
	t4QX2AHU94Z9mZvfsCXCtR7ADgD8VcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80695406B8;
	Tue,  9 Jun 2026 19:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD21F00898;
	Tue,  9 Jun 2026 19:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032635;
	bh=0vBcgswxHnJVjRfzfe4sol9/FUdXWuk9h/h15LXryYU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QJGWcflNSh6sOYC4ukSS5Gx/oNMYV0HgjwWjG0RF2pFsvZU8qk1Klls5Ps0LskIVr
	 QZAdRfPu5eTf1wFPIVYIg5jfHlJ4v2vjSSHik2KzVdv02pYwOnwv1IEfzma9XETfdP
	 w9ECu9XPIWVQfwA/bU6cQqXn5jZqvetAYF2/Z4jfRqZpDeTUvGJXJC///PmnT59Bx4
	 p1Ya9/0kdz9iVuA6Tk4ThQfJ6t7uFQHnf/jEqy6HbQVvBb/pGPTQ0wtHd9U3Q3O768
	 m80m/joroPPzC9tzm9LeWFs+dv7j0VChFsMQLhEsViifiouT96slfEkJj06Ba6nscQ
	 TyIqJQnGJYuCw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:57 +0200
Subject: [PATCH v2 78/83] block: rust: add max_sectors option to
 `GenDiskBuilder`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-78-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1620; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=HoPPP8LHyfFhtce3K0cUJuW8NUYoe+z4X7dgaxFLGfE=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT7S1gTtW+R1WhBEPArVYTcHteX7mgWXqCHu
 TgIUJ9j4RmJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk+wAKCRD6UCkIqsW9
 0MPdD/0diJL/A2gSYUNUwHklP3bHcD/77AQjbTl7KVNQrN/kmQvABFD9xTfID5LimPN5gwnDeBK
 vm2AJdxSZ3PbOyQs2aBEXnm0c7ossw/opjWZ2lMbc7uxV55+wNurDPo9CjVtqzNCjy7QIs21dBs
 Y2bUvKFpQsbNkgiuGSF7HEGuaFdpabmHDTrYyR7YM+Pmx4vLs0qiWiQygWTNIwn7iIIN0fpmjkA
 VrBc4LfNcHsCMtNb10VS1TQzSJa+77ceu08WfF9acCVJ44jhF/BDMu8lSgD0fPmS7jZqWKZTuIe
 jmMxx4XRYFIHfgD/5DRd3HnGSvA9q800AlCTrcxyYdVIrAR4/4eCobhxFyXnkLYojGJiy20O/9Y
 wwwcCEiHuHYiBvmXA0nMhkAvfshZcJu1raF9gtUDBgxyDSDrHaDPDP8ay+spS+UYdTP3u6yMiYi
 pGeYRQzkhA4ZnhcGZy45GadpiPZ8sf2z/4/6xJliKLX9N/yDPJ04Mwq6mvwTRYOpdzr8URH6jHW
 ygCAqRZpjDI3sF4jpVMaF2VDsPfgH7fRycsHCc5c6vhaSHWfSXJkxUc+B5I0YzQryV5UIo3mtPZ
 vWnoO1tFE6ZjT7pMk31qA+VnVKnOk+7BstKDYXsMhgynKA6amnzncerTtDgswXJLlwANnaXwddT
 T2INwiJ1HtR0AiA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2EC2410000A
X-Stat-Signature: fpynhheucx499mp4fy6eckmehx3dfckz
X-Rspam-User: 
X-HE-Tag: 1781032636-606566
X-HE-Meta: U2FsdGVkX19nuQU1FLgyYlWI1aSgko+/qXtmFt1qXshMwwrupqYoOczwbHeguBZ/xtC1OMxN3QPQLnTZjGQa+Kjkb0fmzDEpEOCQmMkAC14bipTecwuFyEkICtMeVTTh/1iLcc3te75VxKrYQDXaPJOJ4uYflJOtfmKXjCYQPOCYz+hSxxMipAeFgcMwcl5Q2wgyFaAZh6cJVbySuxuflziiyX2b5g+eO3a3pVctjYXWRAeKo4yUuMDjpXrMD5QMy+QLNDVoHxWnaxJ7a/EFbXIHuyEMYpflH2wdG3vS3vnrwIZSo/jmfC3H/0BsKIxHu39aDaw9NRVBCrIgFHxwuP1N3vDhkCkb77Nn2h3Go5Zy3AO18SdZQ6Mj0p3yC5csZ27vp3Ej4et9BCH/ZepNqA9tu4IUn8z1j48cqV32/zENt43SaZpvuUaxOkNFDdZNc/Rk8wvfsYBQsiQu7mP9PcCS1af20DH0x74KauNeFgVFn1VkUb9P39BtxhaM0Euh1TbXXQjwJRppw2gaViDLzQhhZy/+ReF3bogOMvgHoi62w6r+ok/d8BMG4a4Dup9oIiLxsMgYTc1oY7KMulu19sEQVyJjx82F5nZzYilys0D1UikQNOQCwuPBJN4KLJU4K6ivRoGsAb8xJWVebs7nZEqxSp/hLs0a2Vqo5eEEqou3t9H7jLmex8ZPdyy05Ql9LHDQPElpl5+PB+6SHxOQnUlADjSkaHeOE11SGninSwTmaJgpk0hMyLkDO7C/5b+b8O4PEq2w+O5qMdncYfxKimdejGESr0TTSkEqekr8skd9/hBcn1KCmq/EoGqrsQyymJEmwVCVNwKzlESsD5IEob1KyqoN0ARNA8Ynv2Cs0dxZayBrt23aTmv874M/qBChipeprPMcyWbABL+l9roO5n/LmvNYx26zZSU06bSVqYkMR15k8BQmyh03lBBkCwBxDv7ft9CBIn/6x3Q49aD
 eHJdjP4J
 vHu19gKJsd98rU4sgLOOPKcCPIHAatWkMBdcv0TdAkhjiM6bAHYnfTlXd8Myoom0ZYGm0eygn30wrwCz21MtgllHrT/2haLTdTaa2hZlr5x+rJUXCJzhhy9e4+p6GCqfZS+Y7VHugddj9Goa+3qZ8E6O21eSQqB2Q5m/YzSIcL633P7t1+UwlPsZ6yXf9nsEPwfu2NHWjja2pSumIPmvOusROviMFIVJj9N0X84nbxQABhVaQwbV90ts/BFujsPULfyzs3N6paq9aEJsvZJ8krryvWOCdNIw+RN97EXfqN9sILvv5twZl24IqQ3xHpapiNDCNLP4bKZy4FWDJjfKDTlG1id2xpWECIN0xf7sPU1Gec+6bOm7y6ifCsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow drivers to set the maximum I/O size when building a `GenDisk`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index a50ba7b605d7..6d760dafade5 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -58,6 +58,7 @@ pub struct GenDiskBuilder<T> {
     zone_append_max_sectors: u32,
     write_cache: bool,
     forced_unit_access: bool,
+    max_sectors: u32,
     _p: PhantomData<T>,
 }
 
@@ -77,6 +78,7 @@ fn default() -> Self {
             zone_append_max_sectors: 0,
             write_cache: false,
             forced_unit_access: false,
+            max_sectors: 0,
             _p: PhantomData,
         }
     }
@@ -181,6 +183,12 @@ pub fn write_cache(mut self, enable: bool) -> Self {
         self
     }
 
+    /// Maximum size of a command in 512 byte sectors.
+    pub fn max_sectors(mut self, sectors: u32) -> Self {
+        self.max_sectors = sectors;
+        self
+    }
+
     /// Build a new `GenDisk` and add it to the VFS.
     pub fn build(
         self,
@@ -199,6 +207,7 @@ pub fn build(
         lim.logical_block_size = self.logical_block_size;
         lim.physical_block_size = self.physical_block_size;
         lim.max_hw_discard_sectors = self.max_hw_discard_sectors;
+        lim.max_sectors = self.max_sectors;
         if self.rotational {
             lim.features = Feature::Rotational.into();
         }

-- 
2.51.2



