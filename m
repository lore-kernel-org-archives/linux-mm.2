Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38F2EC5516E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D28C6B009D; Fri, 20 Feb 2026 04:52:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0816B009E; Fri, 20 Feb 2026 04:52:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8961C6B009F; Fri, 20 Feb 2026 04:52:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8646B009D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28205C3875
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:41 +0000 (UTC)
X-FDA: 84464370522.13.9A423CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 431DD40005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPkoJgHz;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq4FT148+U1qC14uOzP98fzEOEq1xubS3TDVd9YMopE=;
	b=j37uZBKbMMCGZGaTQ84R/gQGdYY4akmARXHJ7bGEaw26wVV7E7yQD20Dmkjv1P7a0NAyuB
	DmYWRIZt4AFId/BhGN/wiwcL8owWU5x4F5lOaSVq9EP1Am8iVnaA8Dl0k2RBvcLljFzA0Z
	SWWOidVPV2EFoAWA4REDNpH0riuogFs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cPkoJgHz;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581159; a=rsa-sha256;
	cv=none;
	b=uaXI4AbfJLShOJ4Tf5UzalNRh/+TWCZBowSwsa4Ssjndq4Oza10wc62kPDbOYvjrJx3QYQ
	6VskpTHA8T0fMPe8HXnL/TqbQdj1Gn6nMksam52y0iZ+vzzS1ojZs7esOipWyWvuKjcAoP
	TE4EeuKTnS2p23CraEIzi2f4muVvk30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2243F4377F;
	Fri, 20 Feb 2026 09:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1BCC116C6;
	Fri, 20 Feb 2026 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581158;
	bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cPkoJgHzjTOK4adLqKvtWOk0lV5xxjHFhFd25u0lCbutgaak9HaBvj5iIti9G5zzW
	 t5vdRzwJCLIKRG+RRSwnAgaRKFt8OQCM5Bsl53NinxBG8sVCTF4QNaeLdH9UxPUy38
	 SnApW6PeCr6R83MsQ4DvuDxOcpHt19YUEVb8MoxXaiN0eIPQECQ/Mvy2ooVEw6Susy
	 EaQEmFLvxd1MwRXs2wqSCWeHSLIcYvdOQxH7HmLfJLbN8RM7dhkJKZWm6wOC3jReXI
	 d2uxnfQYxQPohdutcdThilJmAB86H/L0DvpS2d8rLyBBWYMWfuezR7qHlVEqzMZcsA
	 g8ACwDxkQlGnQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:15 +0100
Subject: [PATCH v15 6/9] rust: page: update formatting of `use` statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-6-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=TzCUGpEDUTKD6tcoKokHDlQAGVLw4XXksTwjbV99rHQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6j7xMqrOaWhqb9sz3GGfZ0fqISUkN5QKA93
 RZup+H7tAiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZguowAKCRDhuBo+eShj
 d0DZD/0dTBrrqUbBOcxFA2tD+zDIiI+fVqhQyXpWOHZTJ14cd+6Va4NBWr4jjedyZ060dAaM1sA
 Femvxpu86flN8RTIjT1fu/C1Xs2xhYXBJFk5pYbKzIzYG18wMgunFXxKnF8fzwQj5Q55A0x6dSX
 d4sn/PolHwlhr/GJeDpRZbrCiypzkXj4a4yuOdjQNdooFyEfvj+8NbUSFgbidam5i/qUWNQCy2d
 5iGDU7RejE+DaQPyVc7RRenEMGW0GkVZqQIEcFj4QpDcCqUBduVmeMKJTAq4Hey9md/SCJ1RiPu
 CYiacAclAAKm9n0ybuxbdSJxi0PTvf+fzWIA6n95kw67kRWiUY8YtQvAd+IN3vL64EW5L1uib+H
 RyPos2pTret4c2ZrRxYKFRRWWTZpDs2Ar6HDMojnmuJ+5+74601NEJqBPN9Xk0AYTrR2TglyTjd
 Z/2T9Aex4ZOhAl3GsayG4AEAIJ14DcEej1m+GxHfGKpvmAU4FjhP2JkEKPlWbTdmeZO702b17nw
 ZBIdWaLXJx3pPL4ZrTHqGfdpWlSYag7OkRTNCKhDn0JGyNU85S3MWU7JwuBf0oStMiFrR352hs3
 eH+ufisPMWgHK5PriCQ5BN9Wrjq/QaF7Y/kQaK5SfsooyRg3R42rIYY7jf5WnRUHCZCREvdgm5P
 RQI1LGOLLZoKTjw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 1adb4ssxazgxmfaqfmr9795zseed39eo
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 431DD40005
X-HE-Tag: 1771581159-675214
X-HE-Meta: U2FsdGVkX18unvoolIMlNFn7e9u7XsA/jbBLBlVwHkOiXTEqcPa4UcFR7seng+b1O2bYm9cC92AgzXXcrcURKKbMJ5QlNm2wkdVT9PFkl4phEUQcB3+nHJzNGrx/GH+d9PU9wz8BeJ428bLCLQsz7TyYW0ZiaeHxUp4yoZLKLt7pdhexy/b6VvEJYIxC9Vqf3tWy25553W4iTeo9NkGlng1KDYx9iWhyxH6/uqMwaXONcHjimLXzlrJVUuJH666jBGqf5dino2Eh9kLV20VIlKobYDwheVl3PiiagK2AybWGcT3jFfZM9CbzH7oAsb5TYPqpEeBdnBbruUhO2KvvPtOlV1hXOD4JsI0IXUodk1d6zlYpdVIKWKGKlS3Kax6JGDd00PkjtAiwOd03VaxzBhZB59sxc1skNoLAsYBJlkLuiuEgnytRM+YgZMZK0eTRc3i7rkAF08tjA0my+oHLkeQnWMAiXbR2r9A1Q2Zg+Vv/JaMJAkmFJx5Y0o7yAB827Pboam1+whuserkxfhGnZSulVlAt0ikMPg7M7Q4c/d8Q2PasdJzOBY/IShX0kogib2QL3CAxcUmLF4hhBItslcLR9ZqoftAiOlH0D/bT9QLSvgYDfbyV0UwchHC765W3FnzYSu/vKJ5oe+5j8/U9hogYwocglziFa5iicLqRMoXTKTtmpehgQupcF5mMWrE9d8uMFyBv7KnU9eVvafkOWY1K6fA5a7GlpNVnzj9qk4RmejI2X40IssDOLulP1KkeprP1W9ceCOS8fX+VJjraL+HYPgOSb0RH6y2Ki15b9wMky6W9w4jiUkLj0vKp9ZFaRkgI0ejZgmTLKNUZIjBDNb8p0q690+bD4jSbBUcJmfafvtzR/6GAFGT8zCi+FvO+A+jJ9FUx4ceLOEcUCyyEVVqVSVF6WnS9982zLBCAF6zvSnksxrv8IT2rMwOZpjgPl3D8zj2dmjJtfv/6Hev
 bPG5Y6wc
 u+pHCoOJWLMfcOxgYbLv8HLg3UA7YlI8INqcUjI9WyjmXiAmk6MbUGymHCZeGWS/YeOBDdsfkHJFDop/s16KY48l6RRX9qATPe53b8nFY1gJ3naGZA80upWbHmgAt3ab22Rbs30+vvspCOq2edTS8WxM+sbEd5yXxiWHofzOWCsPtjsP7+hDHyNQNJOVHVa9NWQ9xIWvfO5QEEdIizZr0bSukB9eF4NItbfWDWrPLnELSEiqLYSy8GPbRVRnDc0msrCukY5aDkgjCNT8xoZ/KsoJUWCrW4cikdEc0XPhHAL80kehJyAdLviXcuMkO8N/qA+gf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update formatting in preparation for next patch

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a8..bf3bed7e2d3fe 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -3,17 +3,23 @@
 //! Kernel page allocation and management.
 
 use crate::{
-    alloc::{AllocError, Flags},
+    alloc::{
+        AllocError,
+        Flags, //
+    },
     bindings,
     error::code::*,
     error::Result,
-    uaccess::UserSliceReader,
+    uaccess::UserSliceReader, //
 };
 use core::{
     marker::PhantomData,
     mem::ManuallyDrop,
     ops::Deref,
-    ptr::{self, NonNull},
+    ptr::{
+        self,
+        NonNull, //
+    }, //
 };
 
 /// A bitwise shift for the page size.

-- 
2.51.2



