Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9976AD65559
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 13:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F246C6B0005; Wed, 17 Dec 2025 08:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC0E6B0089; Wed, 17 Dec 2025 08:10:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB1C6B008A; Wed, 17 Dec 2025 08:10:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CCEAE6B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:10:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 725D75C08B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:10:52 +0000 (UTC)
X-FDA: 84228997944.06.1BE51FB
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63DD3A0009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:10:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yiyc8N9Z;
	spf=pass (imf25.hostedemail.com: domain of 32KtCaQkKCIsp0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32KtCaQkKCIsp0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765977050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=55z/kcnyK4/jomiZdp6n9WsDi2cwF/5hOkFlLeTTiF0=;
	b=wTrXUOPFg6crioQ3Zrd8hqOwJf6SgsEeifmDrcKqm8XEX8OjaYSA70FWGsZkeSV5OPl1nO
	6gMjSORwyFYuK6QsXmIDp9WPE1//QmyEK57iholfQJLaAZeAVQ8xAe8pdZNRr9oWtmxLdD
	oMFRD8tguQ7/NmVeRsH97Q8JMYj+Qc8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Yiyc8N9Z;
	spf=pass (imf25.hostedemail.com: domain of 32KtCaQkKCIsp0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=32KtCaQkKCIsp0xrt6Dw0v33v0t.r310x29C-11zAprz.36v@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765977050; a=rsa-sha256;
	cv=none;
	b=1dhuIKqT4e64LjgpBD6XWB2roa0UChRJ6cvet6Z+SH/x9npHq67edzo7orD+ka0qZ8lHFp
	2m7lS7F/n19OB2apC+sXMjFIgENyYvcm+88fEh6+T7IM7Giv6G4yAfK58G0QqKhOuNfNh2
	PU5+4CfUH56f8R7mpf5qMN5kYaZjSuo=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-430f825d4d2so2298951f8f.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765977049; x=1766581849; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=55z/kcnyK4/jomiZdp6n9WsDi2cwF/5hOkFlLeTTiF0=;
        b=Yiyc8N9ZP4B5VX5A3rRthIe1BlNNGm4giOc4rd2D4O9N+SVSe1KTpS44fRsBLIH+W3
         xu2hhD1BtDB2XqVwV5OgdW6zcdZELc3B8dpNcYJOjNGbToGElHv1uph8eHgtTi3lMJpY
         HY/QuJpGVFSxMkDvhEKknDbr3ytEibbXVP0nh3UzKsy0v9/v7m93dZVr+MEmi5G2SR14
         sDT6MzocUDu3t42AMR8UmjFcG3ar3lrnqXwvyGCY8zyR0M4QlBoRN+/8QA1m2SDvenAj
         O+KopRL3sX0L8nIY7aJSZ0A8j3gKDrMr8rXB0HdbwZ+uH7BzBxD9VvTyCryXwr8OqDdL
         tPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765977049; x=1766581849;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=55z/kcnyK4/jomiZdp6n9WsDi2cwF/5hOkFlLeTTiF0=;
        b=MR0nLoQTKdnYt6EVLkHJ0kjhEIKBtfGETyHkCKQil2yzgYxMND6To+Sis08xxP9UGj
         FKEY3J+TdeuJfIHPu40Km7OgqzuJqVtrY0Z+sPuHDWsIBVecvbH9C3j22UPQMWVTKj7w
         y4Ide5IVeNK+qe65Eq2oMqoSTd+zJwogIVPya8JXaH2fKXtdvdgQECJDMMwiVc6mdQUM
         PHRSJUUUT4NpDOJI2AdVPOMjQ49rV5yAvaUirt7HubQB7jMqWgnokxvg7NZ7rU94m6wF
         B2gHohT78jJIpasXtA7mYnef314MR5gAcKkSUODwpJJoNj7BzVRaf1o7O8XDRr0b3UrE
         A3GA==
X-Forwarded-Encrypted: i=1; AJvYcCWSoeDx+tT2pmcOyDyTRZ4OL+jtj1ak1krO1SPq0ynjoW4hYXrhDzhfZQiGya+Xjp5/PR28L4KbKw==@kvack.org
X-Gm-Message-State: AOJu0Yw6ck1lJhr7gxZp9q/tcb0XHFjLXUSoscLvDH2Twwd9LQn5LR0W
	qF8dVkFXSCavNZqpMrVWOB50Jm5ilhPY0MhcahLfHU04KGbgJCsjC93TR3Ol0eeJ5BKmo0wIvzS
	u+IYqpX6XAgA07LNwQg==
X-Google-Smtp-Source: AGHT+IGvw4zgme++j/6mCd0eYW7FhdEhTwz2nifrF5I4TlPoKnDQGwHnPqTVXe9HihQmPwoNHm1qcgNVLSM6sxA=
X-Received: from wrbbs15.prod.google.com ([2002:a05:6000:70f:b0:430:f5d7:eb5c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:186b:b0:430:f5ab:dc8e with SMTP id ffacd0b85a97d-430f5abdec7mr14495399f8f.13.1765977048487;
 Wed, 17 Dec 2025 05:10:48 -0800 (PST)
Date: Wed, 17 Dec 2025 13:10:37 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAMyrQmkC/x3MQQqAIBBA0avIrBtISaKuEi1KxxqolJEiiO6et
 HyL/x/IJEwZevWA0MWZ41GgKwVunY6FkH0xmNpYbXSL+5Q2Qi8xobgTfaDWhNmGpiMoURIKfP/ DYXzfDzkU/lVgAAAA
X-Change-Id: 20251217-maple-drop-rcu-dfe72fb5f49e
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3923; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=k7ah473lbDl4JL4MlfAcQeYPB9OEQ+mxsApvnfPnjng=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpQqvOGiHo1F5JsZO6XBpXWRgaranpPKixIVKf4
 j/gRr7XyWyJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaUKrzgAKCRAEWL7uWMY5
 RmrUD/0cJnplKl7x0+RCQdZX0u9m7BctBfwLBjcxJu+Ihrw+JDvFUIkVbFO4JlieGSegRZuf+5B
 6Rzl2TIGB63yx0bfOcdKed6ABKXdxxu4fD3fwwtPRX4PUMRKp7nmCYQXhjhGn57iHHoQ6GDCRIs
 pKlbvYWHagfWjkH0diRrw0wrili7zVWhw3DJAqK9vNwEtH+OhZJVrHTiOYfuVgYPGIVnxuALJb4
 2skHPG1u4KFFZYWBoRu4YJAybh9IWyqsanln3+P1YwM3HV5143x3IoMoHllIwSYQEPtJFk3bMtN
 JpvqE2adnQ1ASHzYlLfNmliv5bYIECFYcbM+r3OK8jPW1t6nacsCZjppSs5z6lNdIxlDgXFQsQs
 OOFnyaQifVxCKaInpWwMAdqHYwQJazIccYuFTM8fKJ4oL1SwKUuBGhB6eP3Ug6+WniFIZ8SQbE9
 0oECnzvBy3JG6P51A7npsmdOGxH+f1te5Y2aQNiAvWi1+0+PzleYU+Fcq+qjNTPQLK6o86vdRhK
 VNlD+7s8OBupGifiiUGEJuaj7Gv16qdYugvaWEDOm8xExxWVNLPCPqpqnAWtu+grhHbv3Sy76qy
 Iq+jL9GoWzwe0HnzXluEaf6bgHbFH67uUhGo7s7iszrg3CCObO1vjJnOKmQ69F5oeHksziTqWlv wu4NDmOHMnkjlDw==
X-Mailer: b4 0.14.2
Message-ID: <20251217-maple-drop-rcu-v1-1-702af063573f@google.com>
Subject: [PATCH] rust: maple_tree: rcu_read_lock() in destructor to silence lockdep
From: Alice Ryhl <aliceryhl@google.com>
To: Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63DD3A0009
X-Stat-Signature: odeo3y5kdm18wu5t3rqcx14m4hkgfhi6
X-HE-Tag: 1765977050-118172
X-HE-Meta: U2FsdGVkX1+/kZiLzel63zvOhuBr+0vE5r5VoZC+dwe11JbkOFzBhcjaLGCpJXyexlfakHwSLq1ypxyk2shklrDJz31DwpuzPmmfB5t7Gig8t7ZOxU48OsjpUAoT5C7BPxpLUsxYcSOfs//8dgEZ5jf9COASSTGpKgUgzL1TYJ5o6Z28gtfsxz5S9Epiuob+V/VzAAYUvyf3jbY1hpKhiTdGIF60+7eMRA6dcdw+Nc96GJ04cenREwjyuGUwWMXsBfygmAOi5gVteKUP+jLA5gxBMoWu0pDjv7ofb4hT9CKsBBNON03qt9Z0MyuJzqmUpOj/5tBnJpCGcohS4lGZcGPtszPdT0thd/Ye5nA+hARoeFRdU+lWwj5sis4Lq5+Y8jkRpn0icGurc3z8WcZLBtS4cykhGT3fcZ8d3RpfiPLYMaliLrLtFS5Rrdc1iDVnaa426vwimCvlplkEy3a1QsMHWw6n2Uge69xgscfL/J+rmmJNYmSpNyO3xtjd+lrYLNCANHPiAcVTlYRkOs+mhHkj5nwypFc+SfXJ9ETeOuC80jneFebUDhSF/n6+0mMUQME6B2vdiJ8Ce/UeKWNVlE64OKeFyUKRPMpFhz9troi95KHGyTn4p6dhzbLLX0PJ2+ATQr0BqZNd0aMgFvrSmu5fxruvrKxV/hFH//4NWhSUj7Bt65IkZnpxN7B9DVAuf7lcc7QkSx88LhfT7nQZfEuNMtC6FqhVuiT6fYJJaln//w8XqUV0Pclk/PXegbBhY/Qa1wIlQlIXfcjkgCXotpP7ZJFtkizRIWqQE3hI3cjTtVYdpCMlFOFwgOWozoAblDlLvygMvFKRuPL0wF3zE3mW5fYcoURIQegiYYpGbUyYaiXAST8ItQHC3/7UvtgfF2XppI/yPLb0H2t1zL1w2aKEbaCPKipwAiPY1eFphLyhL7KuFo6aplwi1JXg+HT8XmFGU2uEG8RMncGdNIg
 cx7ytxHS
 dLFkLe5LBjaYgyZhLmWHx+uHMnQKbhHDb5H3zlIWKBto1FulWpvKGBTchViJAEv6ZtGiSPRjHSUFeJ3OwU1wXkN/tYdcROCKvRWW3XvWFlUv/nwmMLU6wqne6ivAVYlRvzt53EhUCF6/xLzV1kIbJNEB5HEpdjurieZTRinpMRPL4rhdgSHFUUrEH2+31ard9orzAAu3szHIy9R8G5gM2oHzSTgunJhwopt8CNa9RH1F2dLDYyk2uhp5ARsV5/O7Jk7OL8ZgvnyqaTIYo4yOfowBExJ/tCWBCUsnhvuYF3+Iq25lRpM2OHBDRHNeHphVkg7P+n2sI4G9Ud/FYf5tzC6gtMayljh/EcQqTWHQ4IHcuMwDm4VINz51olOCHc0xLyI+pUTpm8IJi/6KbP0fAXi0FMtTltzMF1ZEOWpl6x/EHxHxJW21rz1Q61OOyLZ5KN0pLhjRQz9Ua2hJXo1N/BEoGcG7WVbRdI6H0EF1Q4rQuUfZhZaIRDUSLV3nk7G+9czkjNITxcfMk6bWC1cPABuHRR0eTqSaSJJWoY54qrDJi5+JCje4545L/V+G+jDYBON4nRD6aAoN56gH5vxS2DBRSQdrFwB5d2g92OWnYmJyK+L3AUxvVYgUwUs1w2SFi45Yl6CZpyYLx0EmFTLxKaEbUwaQvv77yoDXQVguEMsP0d8duqONzoJM0GbgJjf1GZO2iXKaR18AJ/X/1EMGTSDJlWTz6ABkHift4Ng9QnWZSwZGlY9DuiBHTYi4SlD5es7TFXgrsVElNLo5jFyuNMBk0HZ6aRqvU8pDMaJ1krApBmDaqH6oL3p4Iy1c3aoMir1Wm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running the Rust maple tree kunit tests with lockdep, you may
trigger a warning that looks like this:

	lib/maple_tree.c:780 suspicious rcu_dereference_check() usage!

	other info that might help us debug this:

	rcu_scheduler_active = 2, debug_locks = 1
	no locks held by kunit_try_catch/344.

	stack backtrace:
	CPU: 3 UID: 0 PID: 344 Comm: kunit_try_catch Tainted: G                 N  6.19.0-rc1+ #2 NONE
	Tainted: [N]=TEST
	Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
	Call Trace:
	 <TASK>
	 dump_stack_lvl+0x71/0x90
	 lockdep_rcu_suspicious+0x150/0x190
	 mas_start+0x104/0x150
	 mas_find+0x179/0x240
	 _RINvNtCs5QSdWC790r4_4core3ptr13drop_in_placeINtNtCs1cdwasc6FUb_6kernel10maple_tree9MapleTreeINtNtNtBL_5alloc4kbox3BoxlNtNtB1x_9allocator7KmallocEEECsgxAQYCfdR72_25doctests_kernel_generated+0xaf/0x130
	 rust_doctest_kernel_maple_tree_rs_0+0x600/0x6b0
	 ? lock_release+0xeb/0x2a0
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_try_run_case+0x74/0x160
	 ? kunit_try_catch_run+0x210/0x210
	 kunit_generic_run_threadfn_adapter+0x12/0x30
	 kthread+0x21c/0x230
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork+0x16c/0x270
	 ? __do_trace_sched_kthread_stop_ret+0x40/0x40
	 ret_from_fork_asm+0x11/0x20
	 </TASK>

This is because the destructor of maple tree calls mas_find() without
taking rcu_read_lock() or the spinlock. Doing that is actually ok in
this case since the destructor has exclusive access to the entire maple
tree, but it triggers a lockdep warning. To fix that, take the rcu read
lock.

In the future, it's possible that memory reclaim could gain a feature
where it reallocates entries in maple trees even if no user-code is
touching it. If that feature is added, then this use of rcu read lock
would become load-bearing, so I did not make it conditional on lockdep.

We have to repeatedly take and release rcu because the destructor of T
might perform operations that sleep.

Reported-by: Andreas Hindborg <a.hindborg@kernel.org>
Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/x/topic/x/near/564215108
Fixes: da939ef4c494 ("rust: maple_tree: add MapleTree")
Cc: stable@vger.kernel.org
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Intended for the same tree as any other maple tree patch. (I believe
that's Andrew Morton's tree.)
---
 rust/kernel/maple_tree.rs | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index e72eec56bf5772ada09239f47748cd649212d8b0..265d6396a78a17886c8b5a3ebe7ba39ccc354add 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -265,7 +265,16 @@ unsafe fn free_all_entries(self: Pin<&mut Self>) {
         loop {
             // This uses the raw accessor because we're destroying pointers without removing them
             // from the maple tree, which is only valid because this is the destructor.
-            let ptr = ma_state.mas_find_raw(usize::MAX);
+            //
+            // Take the rcu lock because mas_find_raw() requires that you hold either the spinlock
+            // or the rcu read lock. This is only really required if memory reclaim might
+            // reallocate entries in the tree, as we otherwise have exclusive access. That feature
+            // doesn't exist yet, so for now, taking the rcu lock only serves the purpose of
+            // silencing lockdep.
+            let ptr = {
+                let _rcu = kernel::sync::rcu::Guard::new();
+                ma_state.mas_find_raw(usize::MAX)
+            };
             if ptr.is_null() {
                 break;
             }

---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20251217-maple-drop-rcu-dfe72fb5f49e

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


