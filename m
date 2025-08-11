Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4E8C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 12:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998B68E004C; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9496B8E0045; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838578E004C; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0A78E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:32:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C88CD56200
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:08 +0000 (UTC)
X-FDA: 83764413936.11.42EE499
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id C2C2240010
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:32:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rV9WaAJW;
	spf=pass (imf11.hostedemail.com: domain of 3xOKZaAkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xOKZaAkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754915526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cBznQW2jozfPAknKzYDGUUpAByXONdMvspvsg7mmV1I=;
	b=2eEfLDyU0Gaus8+jiFdGTPQ+yb7TKG2uQk1tRmE7Ae6Dmy7Ak1i60uPccgcBzcGOEoMwP5
	LCrW0uqIpTZuMTGjl+7l80katZ496D+conxXV+3nbpUU8B7lB4Rt32H2vtMzM8y8suL4fX
	1+3HoCZaSK6NIZ9c5jshgk+XePsY9Oc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rV9WaAJW;
	spf=pass (imf11.hostedemail.com: domain of 3xOKZaAkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3xOKZaAkKCD0Zkhbdqxgkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754915526; a=rsa-sha256;
	cv=none;
	b=4HP+OoeIGPoHlpodkDQyviX2piYoQxkKiV3YLNSVs94F715Z81YV90UfqfbNYU3MF6AXLq
	aM7GWriH7ZuSd5kB3AijzGEMjXokjrtZfc4838yUS0bsZR0p5fqFyalmjlZFVseLjfcT9Q
	hYNcBzhHVsTGb2xh34TlKHImg0XVRDQ=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7851a096fso3137544f8f.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754915525; x=1755520325; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cBznQW2jozfPAknKzYDGUUpAByXONdMvspvsg7mmV1I=;
        b=rV9WaAJWOlmzKk2ALESp+jkzIBq6sjZUFUUTP575KHkoRPfA+7+nN3PKAybIVr4pfT
         GcxJCoNZkXdqrLgjZ9Es9PgamgvuoV3f/yhkjawgPFH6n+6mmjkXEZT+MloenAzi/oME
         5yRKBHEkYiPecQP//Zk+N1FKHz/VPhpXbATr9CeL1GC9sYdAAy38qwiChHhadsfV1QeP
         BbpEW3UQgAECrvhFrhud72KRfnqjlR46wFMFrKnfzDY+/+6wVj9Xtv3sjDVY2f86usXV
         e25DgC5XjZOvmXyKTZ/3RCtmC7BB0y556oArbtD5Ek5lKMLLTT0iV0P+j5IxWv/v0ve5
         2Obw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754915525; x=1755520325;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cBznQW2jozfPAknKzYDGUUpAByXONdMvspvsg7mmV1I=;
        b=PNM45MVK9Xs6BdpoX9wHMwq/bci44SHKFWmn82pUxN2P36dwGizXuBn72RRp6/hMMb
         G2+lIM1oRT4AHvsQswQCiuOybk3AFpRVS1tJmEolnSqeu6qa100jEo5UW/2nX7EdNCZ+
         IWZS3VCi+x01okHU+rqmBtCVJFTdejBiimCAYnWP2vzp28OFFQqbsI9TzCHKpWUdMHwo
         a/23lpxSOV2kKWWStnrlGI/kNTpH6vCSNhqIRA9N5FmPbVyWxZzFNCSoRb62F64LOxUM
         d1J5QlDA0q7T5UYriCtvFCqkOTjfwDyD3yUHtNACnKDx8/Tc9VBI9Dj8qzpgML66Gvad
         CqAw==
X-Forwarded-Encrypted: i=1; AJvYcCUR2hR3jT/41TWQoxo3YvGq6oyrXSWhbnDlJtJG4EQ8CAz9qY2FfTxl87/BnrX0Q5MiNbSbkMfs/A==@kvack.org
X-Gm-Message-State: AOJu0YwGpv4zt1n3FU2AAGd+pReXmBoCGB0Tm8QJiowDUhL/Ol8MnZUu
	i2rC8pyT5KFxk3PixxJgmZbzaLfqhF41r7jNL5WpDoTevPf8XnuErxs1CfbMBYnfOkvlnZoOWtR
	Mx5W8WFSs1n/W7ln9bw==
X-Google-Smtp-Source: AGHT+IG/Z7TLbDdRCiOWcvFypzhdjqXp/cd3cMWabRFYYCugnNAQDA35iDfdsoOmBv1cEO9jIyPklYpgoxPqh0I=
X-Received: from wrbbs8.prod.google.com ([2002:a05:6000:708:b0:3b9:afb:8189])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:24c2:b0:3b7:9b81:73f6 with SMTP id ffacd0b85a97d-3b900b55f20mr10096012f8f.54.1754915524996;
 Mon, 11 Aug 2025 05:32:04 -0700 (PDT)
Date: Mon, 11 Aug 2025 12:31:49 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIALXimWgC/32OQQ6DIBBFr2JmXQxg0MRV79G4AJziJAotWNLGe
 PdS3Xc3b/Lnzd8gYSRM0FcbRMyUKPgC8lKBnbR3yGgsDJJLxTuhmJ7JebaQL9McrF5DZKYRGlE
 11owayuUj4p3eh/U2nBzx+Sry9VyC0QmZDctCa1/lthYdi1bALzxRKs7P0SiLI/33eRaMswaFk Vop0Vp+dSG4Geuih2Hf9y+ZKdjh5AAAAA==
X-Change-Id: 20250715-align-min-allocator-b31aee53cbda
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=zzHfmtHVdGKVLDTeJmDuM0QQ2WoBFrZ74R1S49h3S4Y=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBomeK6v4t7/LGcr8Z9JdjgvaB35kRT6S2yphLKo
 cZCh7QDQFSJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaJniugAKCRAEWL7uWMY5
 Rn7LD/9eiMkB3/YXJ/np/GC3JyupWv/t6ucU2G1PY7FnRqFYjRG/uei0BWZ13TKDupvybhdbwWS
 KJwMtGcUsPUrcI6ix+QA6tqY4fufThS9TCd7WmO7MTdTsbgkvRULKC4st958E+QKQ8E09cX6ATy
 TPGL0oomYmc3HIHRoFqWEfz5GvgvzyzlJYCuoBTgeZbtT3i7ZBQnIZkxZJI+GeHLWBaGreBEwlS
 l2B43fHLS1o7Wswkfi+PGalOrE5uhkhZLzS/dX+z5BAV9qlcVYWR1jnu1PCYwLkKDXI1ZO8w16T
 B0qZ5sF2jfOKIygenezFHbeQN6VXxJxEvSMgJRf59W8gfoNMZWh2aygPpaZAWFVWMSGmULEbgm4
 vbuImfsCL9ecD07UEvs+0lz2PQoPRJkgPw484UHMvw1imeCm2xlX7FW/wza7SPL3Y1MfpYmpSoB
 XLEmHuZg0kjHp2b866rkvquSJmvvUbmBqeclTVr24qKAH0b0s4u0qeyupfLyGs1Mau6la52u4dx
 /Q1Lgw/3K3Hom/IYJ0O92K2VUJMJ8B9jl3F68wnPJT9ruh03jL3NBytDIbdyBSMPDjHdEQKnlLm
 miRCcr3IPs4H0nGzRIrbbvp7i3PU8anefCyibX+59e0vnQkXPfpMQBuI0Kb1jx4ZE/vblw5lR6h YrF4CikooKg396A==
X-Mailer: b4 0.14.2
Message-ID: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
Subject: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for build-time
 XArray check
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Danilo Krummrich <dakr@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: C2C2240010
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: op3unopr8d1938qqi14w1iojnz19hiae
X-HE-Tag: 1754915526-980678
X-HE-Meta: U2FsdGVkX1+kuSDDa1QS9doc/jU72hEesRPAwjNnF9L8g7sopGYMHHPLau+hDoqc45hrqM/2BxGW9NVtT4cvtkBIpNSgBAbkOD8qTdDH4Hn0Vvw7pwPOrkh2jEsFEx5kNa1rodJbr9UZOcuPJ1g1qo1SAGIQixpJdmM5Rt5Apq7clsf+CpDopVGzaHP+orZ105HMuaBJxV06kYvpu8++FaZ8APoL+8UkiwtPX2r+Yr/EtDJT6bbK3fKz+5lxmUseKqa1sO8++hU4r2s/TYBasAxiuWalpNZ9d2ttktEYKEvlCPoc0GZ0eOAuKDTJgacltLBsTYi8LBifS+mMBjV82FUCUdnCQnrmqOJrgDjfjoaGbkwaGxSCUtW432ukyYSYE+ES3KpJINiyVlow/B1KR7Ox3zVlJ4uwR1cRDPoLyhrj3djFMtyv3pOANqIPt+s2UwS0OeGQekTXtMv7P9VafZF+NNmf2YDGMUkNTSUTFHQx5BTxzXdtPHwww5DDW14gM/XBNtbpRMIBuZ52fcyrqW/F8zrOB+ExxieRhaKPLwueHyCfJysCF/cZi5RkieS08Xs+ib7qctmzwt9CT0zTx90MGmh9GzJ6bWWEbcqBL5mijVFefZPJg0F3MQBroO38dDCqXz0Bta7q+LWDfdJR9n7XJQqyfveEP0cHlEXwxXrhPoELaRyyVloUx4mb9O3jlXwnFIqT5pTtRlyWFiUngw01hQjLOj1Pdie7ICxTwHoNgHHVJW6JOioyCcvnldbJnRoYEo3ZWBHN9mybe1Kkou1A2x2FWv8aVdPPhpvTyVE37KsBl5hPX0MN/3O6Uq1mgxmk1oeYWI4QWDhfZ4ghhjeopsAmVeI5qeu0OhZBN6nKaDGjfBWDsPJYXa203UI3jRpqTs2WSA6L+63Lv6EPAkcjPa0Da/Ml9cc7+R7qNKBHjAbesPgu8xSiAwLlLgrDTUbie/OQB+0WCDeEGPf
 ZWwbKOHa
 165hpZdcvRt2PiSoNw6M69tkn4hu34xSyARIa32pt1tTm6voEVX8WLlW2HgIGbpVU8SfJloJwdlZcNW96Kzv3bALibjSwqao8inVJBvDZEJDypPmOHXEi01MJrT4keHxuUexBRP0vaRsQDs4b+hTS14F2eCvN54pxCnjRi8ncGs/E2PAYIRANWo415g4Hq/sRPMQf7tqkV2QNguksIjaJFWEiUGLlIFWlYKhBgw0SvZUu3S6BF4mtPGbiGP5qBtemLufwrQlzH24PPxQIe2kn08FCaSwVmfXIUdZopLMy+K7EcJuq4G4OOqS7HtdGzHjqS7unINd2Ce+DCmWddYGf7NQObSLxczeAHUpYIbsWkFJLrAOLinEMg/tHyfkqnDWG2BPj1qje7Utc8GNnFEYkI2Ca28fHHgOO3jrQ5k7HCzbDPruefAE6TsIEJu9omzMxxylWuUw1dKZwjQ3lCO9RvNQZGVfCZcJcPpCEZDUopqLnN6hWURx7ICRT2+YAuEaxkfl8cIDl4dtr7i7QwpeJFUvwI9A2eQiPgUJIpCLJDhJ/+C3pjy/OdwnSOYhXSE6Kgkba9VLeQpXvNtWkvaZ+6EkBKHYyQ57HOpMb6VxWudeyiImr1NNNIblkKA6bLWI80535WThcRtzAHcbypv3X0D5tgBZX2FobGKN5GAwHPb03f+A6SGlMoqKghrXFluCbCUJWaaaB+8SVvPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Rust bindings for XArray include a build-time check to ensure that
you can only use the XArray with pointers that are 4-byte aligned.
Because of that, there is currently a build failure if you attempt to
create an XArray<KBox<T>> where T is a 1-byte or 2-byte aligned type.
However, this error is incorrect as KBox<_> is guaranteed to be a
pointer that comes from kmalloc, and kmalloc always produces pointers
that are at least 4-byte aligned.

To fix this, we augment the compile-time logic that computes the
alignment of KBox<_> to take the minimum alignment of its allocator into
account.

Intended to land through alloc-next under the RUST [ALLOC] entry.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Changes in v2:
- Reword guarantee on `const MIN_ALIGN`.
- Change formatting of if/else in kbox.rs.
- Rebase on v6.17-rc1.
- Link to v1: https://lore.kernel.org/r/20250715-align-min-allocator-v1-0-3e1b2a5516c0@google.com

---
Alice Ryhl (2):
      rust: alloc: specify the minimum alignment of each allocator
      rust: alloc: take the allocator into account for FOREIGN_ALIGN

 rust/kernel/alloc.rs           |  8 ++++++++
 rust/kernel/alloc/allocator.rs |  8 ++++++++
 rust/kernel/alloc/kbox.rs      | 13 +++++++++----
 rust/kernel/sync/arc.rs        |  6 +++---
 4 files changed, 28 insertions(+), 7 deletions(-)
---
base-commit: 062b3e4a1f880f104a8d4b90b767788786aa7b78
change-id: 20250715-align-min-allocator-b31aee53cbda

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


