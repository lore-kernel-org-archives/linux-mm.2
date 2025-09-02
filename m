Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C67CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3B68E0009; Tue,  2 Sep 2025 04:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9935F8E0005; Tue,  2 Sep 2025 04:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882108E0009; Tue,  2 Sep 2025 04:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DCB58E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:35:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F0FD140B50
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:27 +0000 (UTC)
X-FDA: 83843651094.30.46D7AA7
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1EF1980005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zN2n8Ks7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3S6y2aAkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3S6y2aAkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802125; a=rsa-sha256;
	cv=none;
	b=nlHBxoJX2LrlR56oQ/uTxMDyAV27Kg0Pa5n4czgBKI8dAs/teVQpvSN1M1N5wUyT/UaeL/
	JU9I37M55SVYn3WgsG3Xa5M9OpZaFnEVt3vXjTlmeMqceg8Rfu4dI0FZYkc4gIT8y6RX4Z
	XUg3YAW0cUhAyEbkWHCH9jXsYOmCQVE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zN2n8Ks7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3S6y2aAkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3S6y2aAkKCMoq1ysu7Ex1w44w1u.s421y3AD-220Bqs0.47w@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L7MxrkiSkI0tgwRsjoY6xKHPjr8GHGYJw9pm6oGclAM=;
	b=t/xuGEt4LSibm8ay0a+qJfeciqgkFmSNkVXVu2ceBV0dgpJMThGsrNQbAD6CzIOAK1u8hF
	ydieiy62iHimyWyXCxSnNBb+uMrnDC7hdTdfL2t24PKJU4J4Qw8mp6bwjZ888+AHnn40Wd
	8kIs2eyenycwTDn6IB4YnGex1vng9Q8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so46444715e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756802123; x=1757406923; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L7MxrkiSkI0tgwRsjoY6xKHPjr8GHGYJw9pm6oGclAM=;
        b=zN2n8Ks7b/nHq9H9/PWplGhh0O/HhtG7N/nZturFnUEGpQYQxmUmNZGUfw/Wz8BIG6
         HlJ2MCpunBA3ZVk8Ae5S75EntnsaQROW9dhM6cS1ZsGvCJ/gujaAM1F1QcdrMY7LbUvg
         mb9wBr8vd6EVFpgH17YJFy5TCTxcpa3wGLQdZ8I+CTu6bm0o70UUn8YDprMCiVsBiB2X
         7MQGfyM4gjniCMbHnCkN03y7abUrPF5VTNTzNdfjsdYXjDvF40MGbzj3aQ8Orhhx09z0
         UKqiN7YeOQORFDPf/w6o38i56HpR9l+E+2MpuqoYVE4dTHD6heHD1U7cayfyEFBq2EbU
         SyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802123; x=1757406923;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L7MxrkiSkI0tgwRsjoY6xKHPjr8GHGYJw9pm6oGclAM=;
        b=FjOm0SgnYcwBwaEvxuH8+F9sKZrTr+IIdifBns6bpEfuZPw+x7Ib5gFZIRPmWhr9YZ
         AtvOTGSGOCBe336mGrJSrSM41R5s/I6vu+AqEzSAk1nIF58NhFuczeFop+WDrKiCvqY3
         epDiMVRaJ/s0AQ4RF7+RmhYjsPiITum2WYtMxq8vupJOxl/iZfGpegOAsLpnOxMeXZYC
         k/7JSIMRqmpIuQCinwHZWxl5mG2cZVi/jcgkDjdV9QQnS5wq/4jkmC4BaCI23IzxxmRF
         Jcvi+Yo6snA2tuiU9hRriZzp+/54Vmjo2om15557702bMi2xkJyAxLyuwYTGWRj39/j5
         L+mQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5mGp9Nj/PtUxabMkcJAI8/ZYGDXmS3rqFoeMngInXB2AUyFowv/ZcNCZyVVm2BFm2Ywa7vQlCeg==@kvack.org
X-Gm-Message-State: AOJu0Yz79AKONsd/aW4fJ/hZ4gHKT4qea+SNFtChaxirxHNT1d8l8YnD
	yEKWHCOS8/+e0xp7DLM6VvmNufZRICi3Q3vdHJ5AU2520JyDabzmp+7F5PgTfRZyP6vUvLfmAfc
	J/gficcbgb68J0w+xXg==
X-Google-Smtp-Source: AGHT+IGYaRH6+3dhGuOGyDm3NHBh3pZKdOxTCGZaMq2CbQ+83FErPxgEzC8uU7DS45ZE9EKybSIqQ/NQhW9R+YU=
X-Received: from wmqa17.prod.google.com ([2002:a05:600c:3491:b0:45b:81de:b730])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4817:b0:459:d577:bd24 with SMTP id 5b1f17b1804b1-45b84c3afa3mr61041265e9.7.1756802123520;
 Tue, 02 Sep 2025 01:35:23 -0700 (PDT)
Date: Tue, 02 Sep 2025 08:35:10 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAD+stmgC/23M0QqDIBiG4VsJj+fQv0y3o93H2IHaXwmVoSEb0
 b3POhnBDr8PnnclEYPDSO7FSgImF52f8igvBbG9njqkrsmbAAPBJNR01POAdAmIlOuWKVZqK6A
 iGcwBW/c+Ys9X3r2Liw+fo534/v7NJE4ZBanLRktrFIpH53034NX6keydBD+r+O1kYbdwM5Wqh TTanOy2bV8p8T0F4QAAAA==
X-Change-Id: 20250726-maple-tree-1af0803ac524
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2500; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=LU9/zAm/vd85kZy9FSstWyTgOt4MnvxmhM4IBC07EMM=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBotqxF/MbEuU83/mRGGj7liymTFS5P03Cv5j9Sb
 l7IyhjbakKJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaLasRQAKCRAEWL7uWMY5
 RnpKD/wMzs5gx8XfxeVmrJZBN7vjM0CxZyDAo3sGUyFY88ICB/YyiCVEA+P9JV4ZYiNGFIgEHIO
 3SvKLxaFADlTBrFI3SSW8QpuHj/ZMmLMZ+OGY2kJVGVb/v/cfwG/9CN8oAs/S9G5ms0u+CSGAOo
 qePBflkakDDtybP8cJoqrsu8fGO0oWh4Uv/qG0nPYySKMy5wi2Lyz3AG6cEy4gwvj07iA/NOUzd
 tgZ0KeINY9RbUD0+F9wTOlMJ6RTbyCFWRvTamk0Ttg35D+rC0A/C82qt+0HyVKKa7awhDAlxmJT
 +Wv0vzdoUcEM5YsgmuxOQ+jjCajTt2kuDmWm9y6zQl5CM/90dzZ4HlrLfaKavlOHtfAWcWh9bQo
 of/gVUgrjVlfSMVR5EJcudng0IXbf5O5Rn/4eE3HK9KQCqI2vGs5kKc3hktcY6gm83AMgAkfzDN
 sBtwAXe+31yAP4wtF43rYtsCmDzpM8X3ai8FRu9JeUio8gDw2Vw4BXOPO01ij+zBbu1sPfERD3y
 707JwJkCksfNpgAjsQLXRwzhGGkrtlwEoKYEBJ5aXSQP3V7ke+PpCvTuJUcR1/6pwOvx2mT7B9l
 fbWGRPBeJi/v56sEeeAfuzWfYxHmStPXZvnVIdikESCvZfUDZuXHJKfb8F2hrJhLlL2AlZgTUDD wczU/gyuD6+gJKQ==
X-Mailer: b4 0.14.2
Message-ID: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
Subject: [PATCH v3 0/3] Add Rust abstraction for Maple Trees
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1EF1980005
X-Stat-Signature: f5rx718bsjk9t7esomyiwug7rmuttrs1
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756802124-255196
X-HE-Meta: U2FsdGVkX188HifA6ekod8JyVK6lOy3fPxK1QfW+iMOo0vBg2Vuswr+fkRiXGIFgSM/CPCFZjKnG4rUTWOniu9YMB0xvrOfGMJBtZvNi42I1aHM4Ushiq/anaz5ERs/2MLElwL5qj5/hLZ8iQlkcvszHXMPAv75mkeobBrW/JNbZ6O4ZgjsTvsN8ATPye+I3KfDwzNDut3Vz2LdMHm0jTLloXcu8Et9oq/TcPUzAJUp+VVhMfWxgbf0xMUFlj0nMf0EQM4h7stQcfy62sZXiZwNQ1lAMEahNT75p4xKD74th2hW4n71TLpOTcj3JsGd5KDekze4hHwynJAC6mXFgNMK3CcBm2aIi+Z53MxAke4VuV1wLCYrHZIRIRp4xFIIhGDON3cCvPcu4x+q6nuD9hQTX4VLAQuKKL7Af8boUvpXp/CfmGwNTD2qjbRajS29pDqeRyse4nOr36fME8f+Z79G3v29slHa7inoKHNqwv3MA7g8LqhesiwEWTTy+CQlI2SLMWnJvHtplSCbDxLEn0R9cJ2F3AehZNb9kLX3/maYG9GzTwW9ng7HPepwK4PmSg4S5Vuqeja5qUCEHyuWNDedz/i/yNjW0hwgQ1BKFl/gZSoBo8R1xghljTmCy3O/hYymXG769+S6KkX1UTaBIcsJ6XBE/7PgnSPPAG+SprHi6rmImfmzkygWFjD7IGTdiVhwhPPX4sgbAQcwvWibCQzDPruXRiuOPemkRHl8z7UI9ysRvKRZryTVQpOgNHXY/Igr2SuM8Xp30zIWv1tMeK6Ep79RW2s15JCZOjDuec1brJ4WBvNLTmDQ8++5g20QyIevsewq3UmdSvl5aiqulXr2kAJY4WqagzXoSvUjyKE5YHQp3tbeknuX2KdAyUc3awW4qo01o3ZjXUcd5AA1P3f9xsop5nGsdMmgEWP0VtFNxgEkrz2aeK84BgasCH5htC+KyfT5/ioRAfIZCeXR
 rddzwBuD
 V1h+bfGnez39FAQXMUKVHr0Sk1svC6v1H85GWW69xkZsN4bHKNMkRw0MubH9gIz86pv7ny620PtGTvvZsD+kSgt2PorkC33MZ2QDuTVBCbHq+0GuIPvOCLJS/nwX82j+6zzBS9UoAHu5L3GFHxWnS6UR3uOzEgN8n8Vm8LSdZYSWU3/wqh2v7m80JL+raX9jkmQAJQMgGZuujR0BqbXHigyodaDtBtIqt29rH9PN8AKlUMeVDY0Wa/HX0W7fcvvZ73AZLYn4i7hVD+SL/biBRyI8NURS2cRuTR7FM5dQmpHkKYrB08b0k1n9YcLT0cVpJOXXymC9A1vawZ02PeceX0h/OMtK9fzJ8FXCZCrOevttMHQFCRQYE6aFy34CtXdgeXkfW+1pOnBBgvxYphL4ytHZ/svg97dxaALtqwgdH8DhMIRLIfTS5Pz3InlXqzAN3I6Dul5h42hL5KspYF182Bzkhfu5XYdRZiZwKuZmsANwCzDEkPVb2829TR8+AHPYtsuwa3ERWQIPGL3oQyoHBYajrViWbmzcKmBTHv1Ko7w6j7SqvyE60A7jjkLK7eUaD1Szfs5eFvaufF1ZY4LkvGInkunxNsG0BTjzwVFAFGvMTi+3HeOyQl/N6GZjS7IWf1ohhSLoMf8793QhKq/4hZ7Pl2XYZA+g8YgySF6pb+d3k/NHKZmw38BjdkIXN76kG7vYCIERxHhamI4CP/ECvmRg79SCVd9K/8dS/0TY8RLf2f6Qkclv8WsTUmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will be used in the Tyr driver [1] to allocate from the GPU's VA
space that is not owned by userspace, but by the kernel, for kernel GPU
mappings.

Danilo tells me that in nouveau, the maple tree is used for keeping
track of "VM regions" on top of GPUVM, and that he will most likely end
up doing the same in the Rust Nova driver as well.

These abstractions intentionally do not expose any way to make use of
external locking. You are required to use the internal spinlock. For
now, we do not support loads that only utilize rcu for protection.

This contains some parts taken from Andrew Ballance's RFC [2] from
April. However, it has also been reworked significantly compared to that
RFC taking the use-cases in Tyr into account.

[1]: https://lore.kernel.org/r/20250627-tyr-v1-1-cb5f4c6ced46@collabora.com
[2]: https://lore.kernel.org/r/20250405060154.1550858-1-andrewjballance@gmail.com

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v3:
- Change examples to avoid unwrap(), but not unwrap_err().
- Remove spurious MAINTAINERS change.
- Fix unnnecessary imports.
- Drop lockdep_map_p patch from this series.
- Reword MaState type invariant.
- Various docs improvements.
- Rename mas_find() to find().
- Add to existing MAINTAINERS entry.
- Link to v2: https://lore.kernel.org/r/20250819-maple-tree-v2-0-229b48657bab@google.com

Changes in v2:
- Add MaState abstraction. For now it only has a mas_find method. And
  use it in the destructor.
- Duplicate MA_STATE macro in Rust instead of using a C helper.
- Change maple_tree.h so that cast in ma_lock() is no longer needed.
- Add #[must_use] and #[inline] annotations.
- Rename MapleLock to MapleGuard.
- Change errors to use AllocError.
- Add MAINTAINERS file.
- Link to v1: https://lore.kernel.org/r/20250726-maple-tree-v1-0-27a3da7cb8e5@google.com

---
Alice Ryhl (3):
      rust: maple_tree: add MapleTree
      rust: maple_tree: add lock guard for maple tree
      rust: maple_tree: add MapleTreeAlloc

 MAINTAINERS                |   4 +
 include/linux/maple_tree.h |   3 +
 rust/helpers/helpers.c     |   1 +
 rust/helpers/maple_tree.c  |   8 +
 rust/kernel/lib.rs         |   1 +
 rust/kernel/maple_tree.rs  | 648 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 665 insertions(+)
---
base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
change-id: 20250726-maple-tree-1af0803ac524

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


