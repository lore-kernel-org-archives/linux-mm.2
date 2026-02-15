Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806EEE63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C831F6B00A1; Sun, 15 Feb 2026 18:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60F96B00A2; Sun, 15 Feb 2026 18:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D406B00A3; Sun, 15 Feb 2026 18:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6EE6B00A1
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:41:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA9F11C1BF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:21 +0000 (UTC)
X-FDA: 84448314762.05.6607CD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03EFF1A0002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSaFrKiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q2u03CbdvrE+hunDelycDLrwC2ypDCwTBT1aPfftAh8=;
	b=ix9xQcj4vTcfUU8r1s37olvqWceQe5NPYfqOuFMcYdRe//zpnPl7Mj79XnhmT13G29mdDI
	/n5G8bywuZGTl0241QWGRly9X3/76SzRkXvgj5etyi9s/D7MdQ9+3CzYNX8rrr7jusrqrU
	Lqtk3Gb0dlmr8URtxfWG4IN9f3IiEcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198880; a=rsa-sha256;
	cv=none;
	b=knFuY0v3WJn64NMLM83mkvqnzTnmk7MDH2WJie4eRjWqjRXmAFCnRVS3fIUM6UubKm/fP6
	Zwaw1MHMOzea/g3osNCMkiudyIUdH3x2lnRg9t7EgYosWy+Me5inuNc/nUjVtYtHcoqGNl
	jRwUbP6MIDSYtr7jRvIX+75RNWCONzY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DSaFrKiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F10A61118;
	Sun, 15 Feb 2026 23:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAFAC4CEF7;
	Sun, 15 Feb 2026 23:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198879;
	bh=ishZSvvB3Z9zb8FDhnjXHtGNUf+npQzs8cRfHAQ8f/g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DSaFrKiFGB6/amTCrWtVtDcKfgshDfMj5idpSAyBQc4yEmAPlpMjiRG9o7/hxoA+M
	 WTCYeCZIM4P6YzdnFkyfKuLz3UPN9hqAqyYC+wcMYr9Yi0yYLgD0VPRqB+sx5aXIOs
	 C/E6Z8NUcStd5iRUdv9VJcw+ehamkLxBVU38EOSl6xuW56SWqgD83VlJbd/YcFurEx
	 7LYrG9sJkDwKUScLvbLY+nKP699y2FMURC1capUA2px4hyZG85LvIiqVOA6zvXv4f4
	 D/DZ1hfai2J4PRkFEsULcN8QKKNp/+gCp27DCBc17FPEwYqWQ9Qsk8dnvf/tlTco8c
	 DVe0LQHWytQlw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:26 +0100
Subject: [PATCH 39/79] block: rust: add `GenDisk::queue_data`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-39-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1053; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=ishZSvvB3Z9zb8FDhnjXHtGNUf+npQzs8cRfHAQ8f/g=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg+2aHPwWeYSKM1xwW1IHpYHkn2PT29EkZ7q
 RTzFzyPMfuJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYPgAKCRDhuBo+eShj
 d8Z7D/9CVhX2J92c1AOi2x4M0wJNziPWeHyPAG1ev/9oJdujHCMyMp49WszuFgmYujNhRiF4/4c
 tAHeQSTiybLHs+yKXAnrC+KhwvhsCWCYtQBgBiHRQ3fZpNV9of/AN6cCx8Xzs2nnAvWfHnzjkJx
 QhMdRd0cykNNVSPrx1CrOqryOPKGdq1KDuacQhb3pKkaAW8sQoE2YZJMLPSftYv1lSm6BSEtBGW
 vQ4keKzdQ7e5ueIC7V+Ej2aIMn0UmLJ9nEt89YVSVESTsEjh1/5m2dBLns5sOpcwdaBBrzU4TEK
 ObvgiTy/7knmletLmc3TLdmFa+yzzwQCeG5sZNucLKSPB3QbxFGNMgfXkNvVpH6Vwy62TbQXewA
 HnyYyaTtno1Dfy0yiWJD6n4TvZEXo1F4ipk7n39r1Blt1O+yqe3Kw5Eo1UCmApquRGRGnqMhwah
 T165zGyKMU1sQDfDUqP9kOouPyBPxtr8izJ6IHmP4eV/4RWmv8qUtQbO5tsy+HpeITKktMtVVfo
 vf3U1q9tcqvCGojacdc30nqWkUqso9gnXRqEqX6FcufnzT/nSa3hAojU1ubkKDCZUFabyG9lPSM
 wGQd0G7QkYQm1rELpA12e1wh5z7GlXx8ePguS5fIAJObeSYnrn2k16JAXQDe7asZ8vwfM+UyBWg
 iQ/8jHAkGqbPItw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 03EFF1A0002
X-Stat-Signature: rk71kaottq731gnaesca8nhzkdnwweb1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771198879-865713
X-HE-Meta: U2FsdGVkX19cxTa/1ylW0ykJmcd/rN1CU5NmABvf4YDWilk7vOAfr/10OrNkztbZxa8MTx/xdxDzct7caXTCwhkeAwnsxMuaOaukkR79MBy9wJtyc92S5fj2GlTkDQyTh+NuEm2QajbNt2ArijJh/mCBGG2KzkwYV9fDu81AxEjzF60f0syGuxJEJCLziXJkD7AxqkDqL6b8kfcRGrVoJKC7R+v7zf1/KPS9UHc86MhQ4MbHRXmYhkFze6AWYEnudNkjkU3UxesZGCYv/abwFxChtqpxpux8xdyv8IMTKkd9rX6kqaked2kk+FMdR7slP0cKUWQF+ogDEMabQ9bSb3UuoMznP+kXamqQPRx+A+3O99czI++T6hTD3j9INVfINygd1TvkzQYFwj/UGyIjYnx5jqi2T9eNWO61m4Zu9IqlqZqd4NE9bxZ7LOjpTnBp+yzO5hzo90T3BFrlCwyCb4M8CzrnwiqvytorC/kzqv5khHipIytsjGFgKVneRhbBPL1LH4MeLTMq8ZHjlWDhojUPaGO65jbTHQKHsSyqqLnYhmkJr4PkvcBM99DGJX837vsri48iVhOqA+FOK42d+NATe+qYJOCOlEvexqZuqXPAId5hWEFV2z8OheBnBHxlqQSuYQkpJ+busOUqTIg/NBoNbOu5WhXm6N9tCIBMArIXpPV/bb24H6KiFNxDsVvMkXLb/AV75g7Q5fbsftMnoRoHubv3rAxi5karTismlOPIJ/4kgKledOrzuUGaogIcfUAlm7Xh1ZVgfosUBVik6SVHjaOXQZwgCH38An2+tHWT8i+GUWD+ENmTiSqQubc5a4nDIHsjjUlqXvCa3cP0qLHnOgGaQuFsu3Qmfgzahrq5qU61YQ6N6vJC16ruS1GmWqI1r/HBKm/I2BbnU8A9/eDe4MPKwUHdOwvvUVJi1FMi+Mx6+BygM86p4nDdgN+cJ0oMonmyPGg1JVeRVlS
 3fkMcLg0
 5Gu/d41h6fqbvkruUUo2dTvFjKBHZvOy3W4MW+z0q4DuHdmelQ8kFo1kx0WNWtx7UqdWy8pnM69TLJumH57o3UAZDVVNo0wis3FJ3pTTWdx/XLI+RbbaLt1H77Le9/3OgViZ7QgJpzt+AqaHYVtMidTMBQ5G/7GLdVLrDW8K+jE05iFOAd+kcEI/BFBQiQ5iNZxSvrhM7akH0t1EPxqLnoayOVc4cJGCwJ22iLK+CGPBwxTosen5Knd4aiNWp8J7LTC3NEFWza6wJqq3DDvcwadmE3yuuSlbaiKBXFHwWWzWdiF5Dod1/NK+u68kxcX1YMtceANhU7gDIRAao4FWcaGPzw+tzBerCiAxzrzwTKkG9ptc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to borrow the private queue data of the queue a `GenDisk` is
associated with.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 8a22767f1b916..fbda2f572e17f 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -246,6 +246,12 @@ pub fn queue(&self) -> &RequestQueue<T> {
         // SAFETY: By type invariant, self is a valid gendisk.
         unsafe { RequestQueue::from_raw((*self.gendisk).queue) }
     }
+
+    /// Get the queue data associated with this [`GenDisk`].
+    pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
+        // SAFETY: By type invariant, self is a valid gendisk.
+        unsafe { T::QueueData::borrow((*(*self.gendisk).queue).queuedata) }
+    }
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a

-- 
2.51.2



