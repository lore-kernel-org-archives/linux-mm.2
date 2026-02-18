Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A395AE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 15:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D397B6B0089; Wed, 18 Feb 2026 10:13:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFA1E6B008A; Wed, 18 Feb 2026 10:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC3B6B008C; Wed, 18 Feb 2026 10:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABBAF6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:13:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 496D51B4315
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:13:35 +0000 (UTC)
X-FDA: 84457921590.11.55CB028
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 845E040006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 15:13:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LUMjABu6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3G9eVaQkKCHQSdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3G9eVaQkKCHQSdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771427613; a=rsa-sha256;
	cv=none;
	b=zvb7BZ0kAYwZgOGTr8PvVonshpxlmNkmqPeW5SH4MWUZQV9znwnqWtojCMZVvhB86G1vEX
	GliwOrtCsgkUurSuS7+1rZzI1q1yqy/Q/dJ/Qh/nwvNr010dH2UvzphOMic6ntAUlOw4+W
	h6EaoiD7IEH2EbNjOTOZNit8tJhnopo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LUMjABu6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3G9eVaQkKCHQSdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3G9eVaQkKCHQSdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771427613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D1/Ls7LwysFMM1ACNCIQCse+fYSn6YnlDM357NSCbtY=;
	b=f2pMY/f1yEjq1jhgeNWlikjJwWfMKj+qbMM5TVaHhKq/mJ4VSboui8t5M1CeKFc/MCmJhR
	U+NMHLA/+J27nn5LjplziKl6mBRli2gJKmIRiLGe/SKy2HYMpB3KrIMhgZLvCEg1PkY55m
	vmudJdrUPzjtNxJm6CDjboo3Cq0u8Gw=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b8f10615953so470660366b.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771427612; x=1772032412; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D1/Ls7LwysFMM1ACNCIQCse+fYSn6YnlDM357NSCbtY=;
        b=LUMjABu6iY2fkVRGVEY7QOmMYw2yDRo0DfJKMD2bK4SlZcIYsi14qC5KkHQc9O+kUs
         m76bg48D/pMOvxyqWiqd7yqrnuW4Min5tjveISFZBge/A63yJ1m9oB5BPvymFWV02pDA
         l2SLnsdH1OV9SF6+XK6M397wfNxQOAkzDXSg+GsrYUW792Ly0ZkWxoDBst4E9FD3NFi8
         tDnUgJVQ+SNCgqZGdEQ+Wse/yMax7hCVwCgHdCNgOJqdj46ZVSQooshLhjoFXtTIYbnE
         UcbUdXYW6fOn2jJqNCradpOXUcLd1RWsFipdYbR3ymZoCHoHZsLIZVAwunlnkbr/5pmh
         pJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771427612; x=1772032412;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D1/Ls7LwysFMM1ACNCIQCse+fYSn6YnlDM357NSCbtY=;
        b=iCkEAK0cmuwzdHnkiPzIAqzm4I2a6GQON2IMdBgX7RVTZXMxw8p0zIAlnMuSOALSxR
         2JB7Sj+PDSA76ZjR+JVt4V0fgMi+jnvN0KijPTc3vn4O70qDoW+i2y5QchtKkK0Nc88N
         Zam/8yBg77FdMg7GMe534EP10ZZhhlfBnCi041VSWMNisSPjo8lUj6128g1N+1CBdkRv
         I/C/w04LKl/tCF1MSoq9wTeRVyKEW5nLmAdW8Q2FcCtlvfy7ilCWliYfbs27Uzi2mQ/d
         D0t24Tkj/tCSwK+rgtNriG9Yrv+aen6Lup5UgdMb9BKFys28fN8ejgxQw17crF2lSQ9N
         G5SQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOq2E1xCN/YWpZ4FxkvJQnxu0qVXloeXFQfoWQ084OvzWx9XvAPVfmMh6dUn+yIo/j98tv8bX1iw==@kvack.org
X-Gm-Message-State: AOJu0YyeOD2rMFdK6cY+A/mkP27fsBiz+ujvofWBAL5oj///xJ1gHmAp
	WKC9mSbGdzcJXFOKGJIkX4LrFQ3WGt8E7poxlFmet6zbfhejP1BBSNzAmLcGwmHjDVSLX0qgsd5
	VvI1aurmU/8diG5RAiQ==
X-Received: from ejcr2.prod.google.com ([2002:a17:906:2802:b0:b88:4b98:9b5])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:a49:b0:b8f:7014:8437 with SMTP id a640c23a62f3a-b8fb4193791mr846036466b.2.1771427611551;
 Wed, 18 Feb 2026 07:13:31 -0800 (PST)
Date: Wed, 18 Feb 2026 15:13:23 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABPXlWkC/23MQQ6CMBCF4as0s7YRqhTpVQyL0o4yMQWcFmJCu
 LtVFm5c/i953woRmTCCESswLhRpHHKUBwGut8MdJfncoAqlC1XWsqPBI8slWMlulqibxld1paw
 /QT5NjDd6fcFruzfjc85u2scfa8Q/1PXoHrLTN2fPCpuLdmZRH7mzEaUbQ6BkxDzFxGjDMdiYk KHdtjclkO0hywAAAA==
X-Change-Id: 20260217-binder-vma-rcu-e699d5752ad3
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2675; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=84Ip3tw5AbdKr5Kyt979OjbY4zlojv3t7VOkkXCJsi8=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpldcWKLJgmMWFi2DkcATTG2dyWp/K26cydARhq
 CloiIJ/C0GJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZXXFgAKCRAEWL7uWMY5
 RnjED/4k82Ivr29rMWQ77Z8WP7YeiFsjTEkeoP2bk8cr0uF6Of/W9lSj2QtQGXskyQB521HIxgd
 nWfplqXli9EtKksgcLh046LavJWk7BoXwy3Hh4J7hw181wQpG6sRKOKQFzdbAdQcqhlzpGGA+Q7
 lFIJ/4eGqX9A7aWQBodTREnOqNQvmQ/oCFCgsPVjnW0OkiuQQH46pR1KPCfH7GnjTTfjvUmV+nn
 GU/keDlCm891o4WsLg528CprWGmO72vq8MEjzZVrO1iE/bqra6QbHW5Q4DJyPrl0LkfXyXX+Bwv
 ZiKDTTc5oCNsSskyxe55FPlxUCiOV6ZjdSJf7TGL8vOmimEvS4jNpE/Oi82cCMGLG+RUBwUY2I0
 LIadEqhc3H6wdMq4fuEXuf545CwLzqGQ0OKz0mxMr0l7+fakls9dBw0iGMxd7FESouU1e9Sis4l
 npfYT9QFQgIta/Jxz0nn4IXxeRf73U6dpHYtWZLoJ2QGZJ+JWTG/AoA2q+fHXVH3KaUmg0rPc9f
 07+ewFAE7izMtFVK7sepppAH/SNsP3EEtsxl5eJsrOwF4m6ji9eAU0Pw7pnUzJBgheVcljWJAEY
 9+xQoWJgE+YoPvTlZFB+JvRHIMN23K7uWBG9YrBZLfVrezbtN57bxO1DjuehmokeRBoeRAgG28t bH7Mq26FTP/92HQ==
X-Mailer: b4 0.14.2
Message-ID: <20260218-binder-vma-rcu-v1-1-8bd45b2b1183@google.com>
Subject: [PATCH] rust_binder: use lock_vma_under_rcu() in use_page_slow()
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 5ug5zhfaa7iuwju3djwkx83qkd4p5emb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 845E040006
X-HE-Tag: 1771427613-781950
X-HE-Meta: U2FsdGVkX1/cI4eghO7xsG/a73eI/YgW1HOp78N/I9TvR7kMu2sqBGNIJBsxeS4NnYKFKiTIcsrW2Na/CHJqxz7Y37ALzXOQZLv9dqwNY2wlm8e0IFsckilmOVK5G8b8Om394l+gjVBeCpqsn2JqA3PlteD/PDNGRnB9URf94LKNpzBHFLfz9Zb/pJq4BUHaITvP64zPwfgzDEmEVVPO/SYXNBZ84KCIwLIA7HaHbVJ8i9TSCFkYaTeJSAYTFLAtGKctnzYx3LcYvmqt/0ZHC9ocxIpIeT8RPTRgsqXlFSNkPqB8FlrPeFHbaN5zHQt2+aGTgaav52LzIZaGMWvi0PFZWZ/AeF/55Q5yU8qaJVhOgQqVyuHQzGNLOEtqXiJjw0+FhfJkxZiu+itR+An7OnPUgSPJx7SFhG0ApbE491iuAVg1YABsGpdOP+tVd+opErsva2gxW3TCH2G0ys8oWl5jrJUSrCufxpcU62x/izUFdxWt6tPg23P7y/j9DavYilWBK9GXkWmsidLUO52P+Dokdw51v03YrBiNizCWgsjjT0TwP75x1csGKOyW2a0heMmQfrUteCF8z8W8LCgnQSh2y9hL9eF7u3/SnEzp/o1k5L5dnJPb7vTOl0Rm21gXFV3NKDcwI5F0wPkNMtTny3dyQAJryjqNTOp0gZ1Hix3vxTL6tuXzSa0X8skqKQ36hTmFeo0cL3maY4jh/cSJjGkQ83OXBdh81XMHlEfbLLW8iF2rW+t7+6R5ByyWiviAdtex2HtSkrYC5hISPs8MV2Hv2gDuZs78LunQ/j7QkNFWN4D7dBOSiW8rQDR9U7SfwG1nCHXcIEJVmAdwSDOoas51TpyALoXSg2b1tnu3ZSkpyr1O7IkGc2m2BsS335kSu6D840SGMOCPRWlXi6M2gsah6JAThgyqnPGstnWqRRiFjPVFcEZpt6AQFDKLDcTiQUvdKV9CxBMRx1EXSff
 xqJWJeet
 quWoodLOglQ6W5tXo87LYM/RXZYWJGfik1sEluIKfsJQ3Ffrj7JJhJq5e+xU78WPHh73q1sPooYhWLxASceQiUjR6t8w1etfVE4N/rWGN8l/CV43xlElKQ0eo+/vri1guNY5mfMAUl/E1r6A7O6Gw+nwbTn0dhY/8oFsWdHDR/jqgaWJZzXq5ZohpRkfNDxHcRX0L20JTBsS0B0RYnCzBetHXWmudZbm8vZBEgAl/uscb49eUehQ9sQFobEd+hCLJ8VCLwE7NqXIEPY/uWIXeBiwGMIx1WWbKAmXs/yYRvnyx6rzKHN2mYRmVK4s/EyGmA0jiEkdn3FIsgMarO/FSPmnqX8mhRWS9D8vu5Y6dPLfkw3hDnBYjBZh3wac3dGNZ/xbrosH8Z6aJ8PQbMo+SUksF9yYnF75aHtPe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no reason to lock the whole mm when we are doing operations on
the vma if we can help it, so to reduce contention, use the
lock_vma_under_rcu() abstraction.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Depends on:
https://lore.kernel.org/all/20260218-binder-vma-check-v2-0-60f9d695a990@google.com/
---
 drivers/android/binder/page_range.rs | 37 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index 67aae783e8b8b7cf60ecf7e711d5f6f6f5d1dbe3..9dfc154e5dd4e889c4f3aa89e5edb89434113e1a 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -435,24 +435,25 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
         //
         // Using `mmput_async` avoids this, because then the `mm` cleanup is instead queued to a
         // workqueue.
-        check_vma(
-            MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?)
-                .mmap_read_lock()
-                .vma_lookup(vma_addr)
-                .ok_or(ESRCH)?,
-            self,
-        )
-        .ok_or(ESRCH)?
-        .vm_insert_page(user_page_addr, &new_page)
-        .inspect_err(|err| {
-            pr_warn!(
-                "Failed to vm_insert_page({}): vma_addr:{} i:{} err:{:?}",
-                user_page_addr,
-                vma_addr,
-                i,
-                err
-            )
-        })?;
+        let mm = MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?);
+        {
+            let vma_read;
+            let mmap_read;
+            let vma = if let Some(ret) = mm.lock_vma_under_rcu(vma_addr) {
+                vma_read = ret;
+                check_vma(&vma_read, self)
+            } else {
+                mmap_read = mm.mmap_read_lock();
+                mmap_read
+                    .vma_lookup(vma_addr)
+                    .and_then(|vma| check_vma(vma, self))
+            };
+
+            match vma {
+                Some(vma) => vma.vm_insert_page(user_page_addr, &new_page)?,
+                None => return Err(ESRCH),
+            }
+        }
 
         let inner = self.lock.lock();
 

---
base-commit: 2961f841b025fb234860bac26dfb7fa7cb0fb122
change-id: 20260217-binder-vma-rcu-e699d5752ad3
prerequisite-change-id: 20260217-binder-vma-check-b6fca42e986c:v2
prerequisite-patch-id: 4ca86894150aa7ee26c04440100cb71ce599ce80
prerequisite-patch-id: beb72c0aa2ce3d495dd69817507ae6885e5ae1e6

Best regards,
-- 
Alice Ryhl <aliceryhl@google.com>


