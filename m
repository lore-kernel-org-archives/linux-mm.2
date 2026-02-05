Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC989EC1E9A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 10:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4546B0092; Thu,  5 Feb 2026 05:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582406B0093; Thu,  5 Feb 2026 05:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456616B0096; Thu,  5 Feb 2026 05:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 28B286B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 05:51:44 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1D60140486
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:43 +0000 (UTC)
X-FDA: 84410087286.10.56F5D2C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0AC311C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:51:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Chs8LF8y;
	spf=pass (imf20.hostedemail.com: domain of 3PHaEaQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PHaEaQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770288702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VLcYGJKdfae0UDgu1rmn9Sa9RDtDWULKl4q8DTm9pQw=;
	b=kXyBzxciRxUxeWvU6yFQ1B9YlQLM2nRUxymyv/mdftDiOkPuRjDyjqqqvp1v7Ph1qX+1Kd
	43RZbTvFURHKwaRbSIy4/BlaXJoYqXOV3xkeJfrEdGe8RHA7iJOHYMLvSUgxG4K1rEsOoV
	88JQXEmGePokR3AirouIEE9ugcT1LME=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Chs8LF8y;
	spf=pass (imf20.hostedemail.com: domain of 3PHaEaQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3PHaEaQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770288702; a=rsa-sha256;
	cv=none;
	b=xyU2kEWain3lVIsCx9QC7OAt0kc0WeRx6Dx5To2co8cjuLiSb6fV8bz0uvwk4ON287w1pE
	Q36+TweFwnE2dYlEyoZ27YwnkxeNf7E9mibQyqRROCGyyFLpGJUfA/MnF9tSH810w5LGiI
	DyXDSAhVlVI/CdMrEM+myMmNRUeej1c=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so11723275e9.2
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 02:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770288700; x=1770893500; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VLcYGJKdfae0UDgu1rmn9Sa9RDtDWULKl4q8DTm9pQw=;
        b=Chs8LF8y2EiKsz6/jsmo2hsx9iiITyXGyA2hjXv4UI6o7LmlosmTmL1G5zahFETjPG
         oFvQAFdtj/6QghFuaUPpNn81LAeOJoVQNb0u5owwZQQorGf4bNZAUzs/nM8qaV8cPgCB
         JMbArtU5drB7i13CHz3Pu2WpTmv5MJmCWuEL4T40TlyXl0E9UE79S+M8eABFFMUV7beD
         UOdiXL9HksuruOk9TwlWIA0DsisTDVjg7/N3pIGdLxwdsujFqKwfIScC3CStBJ/cbUfx
         GcEX4lMLZ+jbpsd1t30ZYLsIv6tSPh6SBu7HRsGvtN6Xn9xRknA6l8Qm/CnfJQmo/JN5
         KlUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770288700; x=1770893500;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VLcYGJKdfae0UDgu1rmn9Sa9RDtDWULKl4q8DTm9pQw=;
        b=RPUvKV2B4u4zSPX+lB+lyen4riDKg2SPjgTgrbXFVqcfeSBmE5UdwRsZljWtA+Sr5m
         DeXn90HByo7UNkhhrVQkV/f6bjY8fOoKG0ObHypK+41YEtjBLYWqTQmEZvr/CUwZRx7m
         5eZWDN39zpTN9mslLikirCPbeFs/OuaeyIf57pkgEnm4rOe+NEZAvTYM1jqYq/Ra6Dz9
         6YFKci6v3AOfOPwbeH6V+jsQ0PPjT9a+34u6JPJRcCB/+KiUiohQb8Olrxbq6NHmUvPI
         CY1161H/ehctJPfncUYAHKiU/B5lhUIRp7AN4cra+4YTL7np3/6qXqO+ottTGdboDpIg
         jM4g==
X-Forwarded-Encrypted: i=1; AJvYcCUcnQAkLDVhtEIOBYnsTgMriIaHIeAxFBfpaDGAmobgqFHI1SDuDSKNwxWfdCHoUGJ9Vy7zk6mFtg==@kvack.org
X-Gm-Message-State: AOJu0Yzpq8LR7pn7At8gZB2x6NsA8UJMWi8tXDsfg/DzYOozyQD9idYa
	TL3CJCZEimVXCegTuiTONuu+8GB1d+tVBnYNHvwXgAi4Q1OYpMHc6NcT7GtazlKhcbhNLP1TAGU
	SV+yk5mKbA6b4WHM5iw==
X-Received: from wruy11.prod.google.com ([2002:a5d:620b:0:b0:435:ab2d:c11b])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5295:b0:477:58af:a91d with SMTP id 5b1f17b1804b1-4830e92c9c2mr72417905e9.5.1770288700302;
 Thu, 05 Feb 2026 02:51:40 -0800 (PST)
Date: Thu, 05 Feb 2026 10:51:25 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAC52hGkC/x3MMQqAMAxA0atIZgttEEWvIg6xjZqlSlpEKN7d4
 viG/wskVuEEU1NA+ZYkZ6xwbQP+oLizkVANaLG3aDuzSgysJqukTJnNgCN5i46CJ6jVpbzJ8x/ n5X0/Pk2sgGEAAAA=
X-Change-Id: 20260204-binder-tristate-729ac021adca
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1462; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=B35AnR3cY3KY+ESrYf5USuFHaMGr2T6vQRpPugNJCz4=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBphHYzrqBA5nhRZndl3zcRt9KeGBwaoiOcP+yXj
 cTUEYoiB1yJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaYR2MwAKCRAEWL7uWMY5
 RibnD/9j3gbFLogRDIYf1C8LWr+gvE5LRxKD7sfVosY6d9Ys7W4CkF0F6hQYUFD/U6wpvqT0ok3
 9z7p1wFNskyBGJ+JfAGI6EwJh4sQwT/KKX/W6/Q7IE2wDDj0TsVO9osUl7hdEuh3UXRFikyHQds
 xHKx/OiS3SGuGA1o7RtHGAdWpNnRX4Gt55C9nwh4DKWBnqVO+WpDL8B/y0TZ9DclhJrukb9BRvn
 /QpX/9TRHlU15ACrIGJcOWsm7ebc4w0GWH/zGhg6cqNpJxp1b04N7DzeCnQOZXqYbWyYBYmPWLF
 ZDAqOvBrhXwq7ucLR6QsSL2zZ2k3JaCtpgSMJPOxbCo81CLXSFOyeuTUw5kQSx5n1ral7Jsaifd
 MKcD+a58cZ6rBJjC68hOa8ZRdwzE6OappKRRrJqoPLIvB6scsZ8aDkLXRoI85EVcSQEj1aDPlBQ
 bq55rH0uAncExMiB5V+337URq0Y8dwo2ey6Sr4n/FPOdAhU4tcBu0nt8zvSyhY5w02CGfx+oJv/
 6JWrJUVkzPignN27tKv6rqSXBnTyAy3qw2xb5J7cAW34wJIslC24jarb2/X9T0115pKoM7mzUr/
 HoU7eNSRHawmAT2CoExCy9WOXks3DLTBu+pUXzK0ul6an10l1wEA19p4D/F62pEImvUIFcbbjWD 3qVK2o2UeRXk75Q==
X-Mailer: b4 0.14.2
Message-ID: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
Subject: [PATCH 0/5] Make Rust Binder build as a module
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AC311C0004
X-Stat-Signature: 89n7rwebz897byx1hjqn1fwspd1c7nwc
X-Rspam-User: 
X-HE-Tag: 1770288701-507338
X-HE-Meta: U2FsdGVkX1/xUpny3kEnRK3zaLOjQ3ReJlLFtU7iIvjx3LbS7SBgDcrJJ2L3G/JCT27zj8tL/7t4oKj4OBbmUzFSb4p9PIwMti5UAj3jJZgtPzbyX4qAlN6qCjqjSLXmxnaRgC/SVbaQZSmNg7jnod1HozR4pnGv84bRooXwe+IuyfIJcHXX6dt+561fqsituPdd7LHurrA+Q+sC4hv16Qz8gWa+Hh+xEC+zMmLq1rcgqsUnZ0tI23KVi9EMBimBOvohl3z+Cg4+L6eLScgGAdgot56SyTfnmTqVtP/1QyrTkh5WulNVFXnVGocLtoLZfCWa3DA9gXrLl0Mek7vss9oAY9pDvAxFhIPVOUjsm4XupvK7l0lS40UoIbPrJFtzTfE/u3mcVy5bmt+F1n3BzYpGHahBdqqOFbEviHQbfuAtwdtohiKMtJPmk1D15XlNJg9dhd92Vxiib3sy1LeMT0j0qpayJsR5pypiNqLx2/kAupjBnnl/RijD/lMjLMnfl0Px4N/gsSAic0/jO+dtAOAQgyMtVasml9Lj/l0DxHJmM9FHXcmQ+x5epwQNi4MG7JC6RR6MHjJzbTYgCbkKI/3atzV5rHKxB9VuiplFQZIeO7PRQhw/9VcSNZAYW+Stku7AjJpU4aQSJN/XnuRm6W80iDd5tFyugav+C6wpFMmUCQfc9yZnBS2dkSaSvQPYeRGBr/n5SdQFYz85RhWlhg16c2zRniQeUy/lncrBZDhRamd+ccCoyuMCDH8FauuPQQLrFIu52LrggJ+5sQKj2iVdJ1bV71uMQQ3OF8Zo4G0sqsFJy4Kv2V3kUsZNi0gQZbjOCWUU++XgEKKmw78b+QwzAztGxDCLWED2MNmOZ2q4qF9358dmg1Rh0ZXbr9r8l6elhpdXqOQM4ma6MS7i87yV4HRq7eaCIuf2hOAzUmIaafbeba8rXCwYhtLVQ4ziO2FSVEoM8aaplS0aaSe
 GbtlCLhI
 b9iBzZl7RsdXBj1T/E0KtbajxpbeBkWq5dvRR6KEuu4Ys6c5smAaGBpalQ2k+r3XH85yBxEOpubT71tEByhcWkgmdxqXC/EjNZ/Dn1SebFXxUxyThdmMwdWe/OAUrmyP/fdYqdxSpHzxkATa0+OHpsjDbpYW0a7b2zHQhqE+7oo8syR7QxvpITlvCOVA9U4899e1giLg90tOLUeFH+Al6TYC4EklqV2VjAOGjTsMAzgelw4Ugu1KU03y+F2C6LxvEOLKH7GgTXPKLGZ9tnwoTsWzk7b9shgC1sOz1efGQox+ucDttdnjE3Sow9iiTBQE72Hu4tyKnU0SJiUf3K9xCcA0FvcMoG/ySq3mOOK/dVmc6919sRLof2ysSlJiM7Js3AsohI7l2Y1kLmzCv3yJTWUMQwj8UOQAW3vbueugJHk6YvWt/g+qZ2+67z/UL7xZpplDsMlFWdh+1KcgjYmwYKaABV5+Mmnxu1cLDwIvAYssD/IlnBkunXCmZpagORCip9MYMcR1RPT8L2r4KDqVmkSpL4ed1wGGlotkqIWKccnVxvLdbSgtr/aAMN1PH62hKwlm9HSGx8LA76hk7t1e1JWbqf41q/iNDGO7A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently Binder only builds as built-in module, but in downstream
Android branches we update the build system to make Rust Binder
buildable as a module. The same situation applies to distros, as there
are many distros that enable Binder for support of apps such as
waydroid, which would benefit from the ability to build Binder as a
module.

Note that although the situation in Android may be temporary - once we
no longer have a C implementation, it makes sense for Rust Binder to be
built-in. But that will both take a while, and in any case, distros
enabling Binder will benefit from it being a module even if Android goes
back to built-in.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Alice Ryhl (5):
      export file_close_fd and task_work_add
      security: export binder symbols
      mm: export zap_page_range_single and list_lru_add/del
      ipc: export init_ipc_ns and put_ipc_ns
      rust_binder: mark ANDROID_BINDER_IPC_RUST tristate

 drivers/android/Kconfig | 2 +-
 fs/file.c               | 1 +
 ipc/msgutil.c           | 1 +
 ipc/namespace.c         | 1 +
 kernel/task_work.c      | 1 +
 mm/list_lru.c           | 2 ++
 mm/memory.c             | 1 +
 security/security.c     | 4 ++++
 8 files changed, 12 insertions(+), 1 deletion(-)
---
base-commit: 4df29fb5bcebeea28b29386dec18355949512ca1
change-id: 20260204-binder-tristate-729ac021adca

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


