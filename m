Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AD4E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7756B0128; Sun, 15 Feb 2026 19:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6722F6B0129; Sun, 15 Feb 2026 19:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DD86B012A; Sun, 15 Feb 2026 19:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 678226B0128
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:07:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10CEC5C52F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:26 +0000 (UTC)
X-FDA: 84448317492.08.4DE0F95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67A5B20005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EegIw3n9;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0OB2spwbqpbrWnKpH1XvJh3my3mWEyQXGfx6tFx9fg=;
	b=buiUA4iRgzKN8J+2ghGrdP5fVL3KqwRs57WzVfJoD/g819yM2Y2Ef7xQtN2yJgaKyZPdkM
	JQeQAH2JAchxnorL4njpUj7EBZ9CBvNlQFPL4bUwMSFeFfRWqsvHnBUvAuuhmFAWYY05lG
	DNvwmYtOtAhXjhvl+nHuWMx+ucm/7PM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EegIw3n9;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198944; a=rsa-sha256;
	cv=none;
	b=IFUpZibI9Vi462RRqa1fh7/8TJ/qfpNnDMXjoktdBvpjQLY6aB1XrdvDBOCWpeARdvOHuC
	sv6zBJuLWOv64YAObP2O0GxgChI1BDKbrJ7QIwZ0LkuEE2DzZVQ6tG6KDD7NhPoEu6IyRo
	o0RkoVDgpWyNJRS9HjeolYkwNM8aGfo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F022B6013F;
	Sun, 15 Feb 2026 23:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B953C19422;
	Sun, 15 Feb 2026 23:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198943;
	bh=7BsUMdxU+4o8Atmxvi2C2Yk4sut1Zh21/NZvpuROV9U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EegIw3n9AdLDkfngVG9lXqk9jft65qhpfo7Y99ZYTJpFjM0kcakmlgeOqfTqa39np
	 CGDtEygqvaUzQVXVkn7uhm35v42HlHKpNJSF6ZWaMThfSXkDbT0d5oZuA29WBFXLSz
	 yPcZJxj4Drwm1X8Od7cbhYIFkTCOpMGP/Mw8JO3JMPzvPFwe2h7VRME0TaLde5DGvU
	 tqQcC3t4+ligYcd1ufKAT3OebAopO/oTInmhAMBA48c98UMtB9Q/eUtdUQzJ/kmKMC
	 JAekf0ru/muJbn6mFt0y4zH+Qzy6ZtH4g3gt9gD2+t9NCIOeNypeXp6jnK2HBP6iEE
	 jP1Jy+fPjLrkw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:19 +0100
Subject: [PATCH 32/79] block: rust: implement `Sync` for `GenDisk`.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-32-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1028; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=7BsUMdxU+4o8Atmxvi2C2Yk4sut1Zh21/NZvpuROV9U=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklg4ccLaxdetyIDs2ivzwrKOGT9mU3qMRJbLi
 d6udKXYB6SJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYOAAKCRDhuBo+eShj
 d/SMD/4/4YwNGwDDtKVPiCoYpIESWdAQIduCAObFrzlsZL/kCIkB0OMU0EMKO2cMmBBT6bBYFd4
 qwedoAdYdDByA3piKaKLOQezC5celEc4+F+IphMdiaMg4tBLjAMqFL89thiK2OnvtZbp6OL79rT
 NBUa7EFfsQiAnB4bZcRRYzklaRthtLFmRqcIdJZGHau7OsWUvw3wj+aPzdlf//RqEN63DtvzKEc
 mRMVMLqSeZr1ZHQ4CwBFbyEC1yrDP2WFEy6gj0BiiuDexcKL8K/0N/NvzxNK3bCPtUOV/1pHbfU
 3uUAbAci131lesi6I+yYt/+QInj/lXfCzn3IKf823uTyiqVLSMPbbOVzKhxVmaTkMeRFucAhRSZ
 oiHx2upFd/aQAOuBcGrj/OkFuwkvJvIFJxLySCTC8t22KX8GEn6V6j7UuBH5S9W0B1McCBvVeFK
 XncX2V3/mHuBkbio45kWI+PXeWDVQSAeqXa/60JmUhvrhg9Ch/X1pWqsL712Tu/qQ24BswVQ8aO
 gI+GMJV7qKO28JtHvCtGjpLDZ1K8M12Y3tsyn1GNqq0EPY0CAlDJY0rrNnaNhFQGgYOlPfz9TCx
 g06pY4/jCcEw5VJ1WUVg/wtHYiBCYOySd7LvzbXLfFmR8VWI35FnRmPOOxWnuQE2C71SiAefNiI
 TzllyUbiu4t9g4w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67A5B20005
X-Stat-Signature: fra65j6c4nwcdiswam1aasf5btfrt4cp
X-Rspam-User: 
X-HE-Tag: 1771198944-975639
X-HE-Meta: U2FsdGVkX19RvQukVfJPjvDZFiO1I5H5a50/r+bhTIhODBAuzNRM9THMlXyGdJvbeOQ4VB5KAifnKHJ9IFi8v+6pVPTtK/WxXqJlawdg2is37inejc86Xa9UEPkY8sVNOZ9rezfZpvwB1kam6MGWIiJxst09V0YejIsSvw6wI8rVWB5io+HWSiR/gebrx3sa9/IQvNBjBjYaOlTEJAzvIHpJOOIUJC0ckgWQi0b3zy9oxPZAJjZcR5UqG/9m6ugg+aOLQf6t87jKEq4niAtdKTFVVlKfDBhCFN+D2d6qFljIJJRxDoqpMZSajyJfw+TvhSxB7d0MOPLgxkmCa1L7xd5LET5LRhUIBiFN+fzKRgGkGa1DBUTAvZe9DWO8muQAJH1sgtgLzwm+iSbsnVmMjVixpWxP6C4ZAOWncujCJ2lcwe7orfo1zmGPI7mliNu3HCUCmN2P+hvbJBGfnUxOjV63Pr/UTs0OwcZLNZFY+gDJUSC/dGZybt52UmU17u/ecPN08HhnIQa3LT37o0IlB/OrbJdwzXnxFbDO+QLKZlHEjxtCwEqfnISrguZ6x4ENTNBlv+Bm6+I8W0C355nfA4GWPDnpspPMkXRES+Oq+yGWg8Y34eLBAMiey3jwBLDmrU6Ab7Hyuyxq1AS5lpJW0tdAhosqxtLnXZ9KXhCiJwt5Q6fKYtDfWgpAU+z+fvmakZ4Pq/y7CXweDGSGWnzOuPCQalfRm27NJs02OzccYAJP9Qzp/E2doPdfQQCSIah+RvL85XZTt//EnVMwkvCgrBk7HS1LTO7mt5zSBVp+HkklM7GdzC0Qoe3NmTDBtky/kd92OchYVQZA0tSo6CfeAZlEU+hPptDNCqpOOn4R+dr/VtqRLG6NGE6dHaN7tf6ZLOBOm8gA/WGEzQcsfnwYvjgej9n2Z9VKemzxdAk9Vi2WD5EiWHS5O5wnMz3RAw6dRVKZ0QAXqiKY/yXSmCp
 yGDLN63d
 /E806NQlUCSKpMVDmQqZaq/2fzT1A+IEpaLdvnRY35LXoPLqjuAqEwvItPFkNZtaHJV/56Wk/l7wPI89vQWkqk2z7WsMdooP9G0EMQ1QRKVEFdtc5BE1pgvs+hkMJaOJXP9FEvT56+SIKyC86RWfW4V2Gx3NAEUGXM5bbSif+/LxYk9W/+oN6wZT7zY5TCSFDU7fGP26NKJmQ4S8hecMWNhFqeNBw/RrqW//Zcltt54ZYMd2knd6bT6PEXADp71OZcAOAYyQsblx181lXTUFzNYT7AADFxYShI3aB/72GyBhOZ5zDBRudgZo9GMYWNKnLsU5VbnU1dIG8X56h2fFs4S/lCerR1BXl4m0e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`GenDisk` is a pointer to a `struct gendisk`. It is safe to reference this
struct from multiple threads.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 75968d6a57639..72bbf3cadfe82 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -218,6 +218,10 @@ pub struct GenDisk<T: Operations> {
 // `TagSet` It is safe to send this to other threads as long as T is Send.
 unsafe impl<T: Operations + Send> Send for GenDisk<T> {}
 
+// SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a `TagSet`. It is
+// safe to reference these from multiple threads.
+unsafe impl<T: Operations> Sync for GenDisk<T> {}
+
 impl<T: Operations> Drop for GenDisk<T> {
     fn drop(&mut self) {
         // SAFETY: By type invariant of `Self`, `self.gendisk` points to a valid

-- 
2.51.2



