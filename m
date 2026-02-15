Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9454E63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BAD6B0125; Sun, 15 Feb 2026 19:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0235E6B0126; Sun, 15 Feb 2026 19:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67B36B0127; Sun, 15 Feb 2026 19:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8676B0125
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 19:07:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5015459CF3
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:56 +0000 (UTC)
X-FDA: 84448316232.13.E8CB276
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BDAA6100003
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:41:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMsAXC55;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcwtqCY4XsBij18H69BXwmk5yX16rn/1XmLYtowxM20=;
	b=bKTtxaOuqrACMuoXMTlJIPX0yIbLLoN0WKV3UmZGGqoxc4SJMxZI08z0j2HyMhbmnyfhLH
	4n5lZ6LA50w9b3ZDh1DJ+GYDW0ijuGi/V/s7Mda8/Tz7pTFV/eiyq/6NiahXgQL7GVY11Q
	4vn+yq88p4ERECk2FRw8S7LW8JQM2aQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vMsAXC55;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198914; a=rsa-sha256;
	cv=none;
	b=MH/+uXAeRxamNuM1uq2EUToV/AX+cu1w+SJOIqg3bzcLYRwxLCapzvUeZIlqNaqSI+jE2g
	iKG4WmVx32LTqWIQOyACMIGd6kzHtorqgJZTyO0p8hGT4PB3eG/R/lfYGJCYCEO/piuBt6
	Rq8ALtLC7RPlIqIvKYjIcTtjFkX2kKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 533C961119;
	Sun, 15 Feb 2026 23:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DA3C19425;
	Sun, 15 Feb 2026 23:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198914;
	bh=RW3MTz8xkW1tKyTv3RDY6oAQVdhOz9YY/OU7mpdXt4Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vMsAXC55989y+KeDRqJR9UNrCpg6LC4ikm9xU96z5HhXpXX2/OVMOrxMJky9+pV2I
	 OpQHTkkXKIMaSUkEox8w+LPL55BJg9WmjYVy5gcfFHwyI+BOsbKN4suMV02ot8g8E/
	 vcFo6GVQhbKSHgoVmdLIR29O9ErRwX4DlpBc0jTUBP5AFlWaOH3fd2gqeO8jj9fMdT
	 hewruuea3G9jMNzgye73d02EIDvEUJXvyR5KyxlfW8yTj8SNxK9lqMiIovW1QfYjD3
	 2ZjW9fih3l1wcubS9H2S0O+TO8gfP/cL1FsGO8diL3nuoK6/+Y/wu6V/k/lE4uk1GP
	 cV92ez/Pa1pVg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:51 +0100
Subject: [PATCH 04/79] block: rust: fix generation of bindings to
 `BLK_STS_.*`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-4-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3781; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=RW3MTz8xkW1tKyTv3RDY6oAQVdhOz9YY/OU7mpdXt4Q=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgfSRI5aGYFC7AMdVoyVwiZX6IUJslmIUQF5
 nE91okZ7AmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYHwAKCRDhuBo+eShj
 d2QXD/98TQdnkcOiqdL0C2IVNHBsSku5PEaZGrrhYH6IoIEShsbzgzZ5XEkKnf4VsaEQmG5p8Tw
 KfcM3mfT0ZA2sy76Jf1PWiCH+ayYRqEXtS9oF9b4cQfrWlw56O/7iu6yP9YEnL63/bF4bB2tcVn
 cVh0TNZAkEMPVzxsoQ5CMX2xcOyu0gM7Q/pKqDohmVn7TJ911Ie4cLrnFOrM1NcKk/vAMPL+BuH
 gbKFIHCjL3kkQU5UZGfb4cpxAXe6QPfiJZ6Hq37JzBdLITGKE7JmOJm5Q8k6HUVgrAexdyEwHL5
 sShRPJp3jfYw9ukmElW9NaDjNhrx3AbpW2fKqiOqCTnEp7ODnU3HdiMAZAI5k+2TG5ypMtw2mV8
 DNJZiSdq/w4oWO6VZ6s2GvR43prj2eq1P40rGOraKOKq2DdW3xZvrDHoP0wWeqJXdtJCRX5aQ61
 TSygTC1vqeX7rEnU+x6HWuoomxj7D0zflbJr+2/KBsqEVGZJ4Cars0gcWKNfUwfphENG6RCyVsP
 S0RMkbENgM5Ljfn63kw7+Lqmmo+AEd9rnH5stK133hs3D0zM6LTt2EAbqIRIc88g0mdhB8HBuUr
 yJl+eeWDzv3eZU77J4rrl+VtyrBzESbH8LXDt2bf43mIPstBhu9xgwxFiETlZwoNwLbmFSfRw83
 /WUIjxXuemLeoyw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDAA6100003
X-Stat-Signature: dxgq7rmu785opkqu8eq8m9uuicbmrynt
X-Rspam-User: 
X-HE-Tag: 1771198914-681971
X-HE-Meta: U2FsdGVkX19ZiEwD5iXiqSudT4UD6gvgbVrVb188FabIRz7ull6mTZEuypoKysrVsEhBuaI092/LFjGzIIVlo8oWNwXsu+tAtIVqEvgPS8Ifg3ldlHk+ZAPs6sWgocO/d+H92r5xTnhriV0wC13pkNq9udOXxqEcruoDos+CBQ6BWaIz4e8+l3xXu3nR0ZvAvMbpjXb+ck1+dkfG9yz5lQ4k5YkY8zVA3s0i1xNqtG2FQOTdCmsOWOIykFQNuYqq7EtMJW+/ZjkDq/F16xbtsxrUesuD6+mVBfEI9PvWRxmVDzgKHAEZ/aMlFe5B/KUpaALUgslLf2EVVPl42g+g8zlJoypF7a85AsWqHVt5Mn+CBmWdm0voHJ2xm0cJ10eTT05CwYKd4BQXsEHAhEupzAdrFdWXVHQ8gXUBurRKkvE9Rp+DvKCYYOEMAz3qU8dn3seEYGFdIOLfYAC7YZSOyGd5MFqhGrm3M9DlM5LzSGBgYTMfWhRjjV14KONyU9nBDlbqN31ZnzFsBnfpVFhyFv04hvDgOrBOScuV1k4tiIu5VTs+09+bk2nLreZo7edAZDcywa4fStZlLhqG7uUEbHBVwdWXb9asI/biZs9jxdumFlXEFRYH1w8r3go0nNd/3qFnpIA5eaEIIw2rU/ydlAXfnDaAFrJsKJn211fIantJZmgYYEpT7wE6atdYVHaUz5iXinVUV/L9JsOvEMhruZE0IlKkEG3r3iJm650PHNSjtaobtZEYWpmI9b+QRJj50PO4MkgSxOD+TuC/1WeZK/jIAKwuguDxx+WD7GJb06ByZwsW7Fe/YVW4GLh4Gy7f6WWClwaaE0bggWFDr8ZUkARlzAw30Mf6UEPhaaD78SmBDfN0GwGgHnJ1QaZM6JFblxunkw0lajdQReKEANwIF5CsVoM/KxxnoGUTL+OzCzDl+m/WT29nDIZdQsDOnKpcBaoqb0dy9ilEOefJknB
 Y66IjT0L
 1nQpgrwTk+w4Z8jEkPZf6+/FvBu3AqfOUu7e4GwPTdprWbOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bindgen generates constants for CPP integer literals as u32. The
`blk_status_t` type is defined as `u8` but the variants of the type are
defined as integer literals via CPP macros. Thus the defined variants of
the type are not of the same type as the type itself.

Prevent bindgen from emitting generated bindings for the `BLK_STS_.*`
defines and instead define constants manually in `bindings_helper.h`

Also remove casts that are no longer necessary.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/bindgen_parameters            |  3 +++
 rust/bindings/bindings_helper.h    | 19 +++++++++++++++++++
 rust/kernel/block/mq/operations.rs |  2 +-
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/rust/bindgen_parameters b/rust/bindgen_parameters
index fd2fd1c3cb9a5..0968541c9bc16 100644
--- a/rust/bindgen_parameters
+++ b/rust/bindgen_parameters
@@ -5,6 +5,9 @@
 --blocklist-type __kernel_s?size_t
 --blocklist-type __kernel_ptrdiff_t
 
+# These are generated as u32 by bindgen, but should be u8.
+--blocklist-item BLK_STS_.*
+
 --opaque-type xregs_state
 --opaque-type desc_struct
 --opaque-type arch_lbr_state
diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a783106cdac6f..e0ba5c712c560 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -113,6 +113,25 @@ const gfp_t RUST_CONST_HELPER___GFP_ZERO = __GFP_ZERO;
 const gfp_t RUST_CONST_HELPER___GFP_HIGHMEM = ___GFP_HIGHMEM;
 const gfp_t RUST_CONST_HELPER___GFP_NOWARN = ___GFP_NOWARN;
 const blk_features_t RUST_CONST_HELPER_BLK_FEAT_ROTATIONAL = BLK_FEAT_ROTATIONAL;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_OK = BLK_STS_OK;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_NOTSUPP = BLK_STS_NOTSUPP;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_TIMEOUT = BLK_STS_TIMEOUT;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_NOSPC = BLK_STS_NOSPC;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_TRANSPORT = BLK_STS_TRANSPORT;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_TARGET = BLK_STS_TARGET;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_RESV_CONFLICT = BLK_STS_RESV_CONFLICT;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_MEDIUM = BLK_STS_MEDIUM;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_PROTECTION = BLK_STS_PROTECTION;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_RESOURCE = BLK_STS_RESOURCE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_IOERR = BLK_STS_IOERR;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_DM_REQUEUE = BLK_STS_DM_REQUEUE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_AGAIN = BLK_STS_AGAIN;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_DEV_RESOURCE = BLK_STS_DEV_RESOURCE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_ZONE_OPEN_RESOURCE = BLK_STS_ZONE_OPEN_RESOURCE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_ZONE_ACTIVE_RESOURCE = BLK_STS_ZONE_ACTIVE_RESOURCE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_OFFLINE = BLK_STS_OFFLINE;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_DURATION_LIMIT = BLK_STS_DURATION_LIMIT;
+const blk_status_t RUST_CONST_HELPER_BLK_STS_INVAL = BLK_STS_INVAL;
 const fop_flags_t RUST_CONST_HELPER_FOP_UNSIGNED_OFFSET = FOP_UNSIGNED_OFFSET;
 
 const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 8ad46129a52c4..b68c0208efc66 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -124,7 +124,7 @@ impl<T: Operations> OperationsVTable<T> {
         if let Err(e) = ret {
             e.to_blk_status()
         } else {
-            bindings::BLK_STS_OK as bindings::blk_status_t
+            bindings::BLK_STS_OK
         }
     }
 

-- 
2.51.2



