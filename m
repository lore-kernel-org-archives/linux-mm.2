Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F52E6F07C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 10:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0F636B0005; Tue, 23 Dec 2025 05:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD8D6B0089; Tue, 23 Dec 2025 05:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F8B6B008A; Tue, 23 Dec 2025 05:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B89886B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:07:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EAB516010D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:07:24 +0000 (UTC)
X-FDA: 84250308408.14.724744E
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 591B7C0011
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 10:07:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AZQqlzMl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766484442; a=rsa-sha256;
	cv=none;
	b=KQSSpmg1AwRLEtMGpJwJBS7yDNUAQEK1LOSrivdM2Svp9v5ONH17usD9uvI4QDQDnL5EQO
	WdSA84UWzqAfnOrviWmz5izTHMV4z1M+Kgzpx8QongGfDTENBdKrRiXI4XxGXGIdxZlSAs
	s4kITKtoH83jz3mmgED7MsWLiG/2tL0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AZQqlzMl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766484442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lae5UGB0sBbMmlSigC5w6caqUQw5AlV5GUxciIGUOA8=;
	b=viT6W06gE82VdkeRayKey3/2k+h8tsQLWmFOdS5wWgYxqWKFsYp3VAdANHNjBsgqQ5N1NA
	a/xk8YM2Q35qk9/q9dj4m+cTA2RA6M7mJqAQvmAgu/MoHOLyhCZSeDugfggMICIfmEQWe/
	h9Cbx47hz+4sFehHeIIK0VyUw8d11KU=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5957d7e0bf3so5093456e87.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766484440; x=1767089240; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lae5UGB0sBbMmlSigC5w6caqUQw5AlV5GUxciIGUOA8=;
        b=AZQqlzMl/6yOpXngEaYm2m7Ks63akD+71vzQPvCgTrzF3OsADjVmAoOqX7u7zPPD4y
         AKrKt565N639czL8CM+5RPi4msBn8RnYRg0/8M1cIKIS5bb80XYHPwhkl8q1nro26PWX
         T0pBKNSZSj+hMAIi/gIBN8V5/IKGBBpxYtZqNwNC2mt2WUCU2+58eKfU5spaj1kA0XZQ
         dIB3YBus8AUuPl8nAqP6D/q5Ctp1ITkHiAUFa90w5InS833NPPRQH8w4qnb7V0MJZJqG
         dRBFnWLJiZ3vbUD4SwoJ9yUBbxZVZ5c+mTeumREswdosIvPpGvPQKx+l52f/z/amlv4A
         KR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766484440; x=1767089240;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lae5UGB0sBbMmlSigC5w6caqUQw5AlV5GUxciIGUOA8=;
        b=JikplnkZAoJLu0B3hEk8uxG9bY0QWtVAYmrLJ4xlIvkH3YI9ZY0VreuqHRdTkK2KHK
         4uoesHljGMJexubSFam1dC4tpbouYosi6N1k0NcQP5KeBeUkxwz7zdAkLKAumf0uh8un
         1F7SXPFtuO2Q576w3pTVSAQpGyxTR+u8E5GFWcripEV0fh2rbYo21tAfwOv+SNsmUtQw
         +yPovt1YzzGx8VrHD3VxwnQ98wj9jgdYmenxOO0kbM/zBTl985EnxjxI1P5QBfWrCXoN
         ohbXgH1FW/WjZLzulfe8jhgahV2ZvFojkYZ0NyUS1cViA5kN2Z7LojWgtx+IWf7n6MMq
         O6NQ==
X-Gm-Message-State: AOJu0Yyyf356oZtQ5Dssh7dWot814p6PZodAMOQK5LOd/5qjJo6OjtiG
	9d3ThLUIugOXojySPrKVGFLAEAPm+KbwZj4Iqnml8zbokXCgD+oBD6Lt
X-Gm-Gg: AY/fxX6vREtbbABrZZg5J1I/h99UV6TF0CGF31E13TVW35CbLC+7UDQnFW+RSS7168e
	YLvjonci9Iz8NgFiidhYEqoUxviW5qBRfESDjZfSR2gB4gm7WsKDVYxGgXCpMgWyy1V64cCIDHR
	irxUVfjAc/949HJUZwhxnFndoHpJWl6A4d+VKBVtv2SXi3GKO2w9dYBKX5PiUWtRh5A9mK4sKn9
	yDSu3A02pACHMhwZcT+Cwd3yW0q6xVt3VJshI0WV4n5r47AoGhdcsylKB/MDjDK+Z5aqR2q8QZQ
	R1jLGF7L1hV7wxHsj/9Huss4aiaUYWrGJLNnF2zWLggSl/+RtPwYueKNj7CB7WGU/SxZ4Rf7jb7
	VdYRb0Z66wsTcBmtm6N/hW2dm8tu8KdYeyGsGdY4DDbj6Xnq3lKoP/ac5Cn0NItrabj6vJEIK/e
	NER/MB4QA5aS5Ayu5Xj8PvKT2mPT5gQ1SCArbAvNSII47BTSm+srNB2WPr4sOUrowXJPAC6BRhn
	HM1+sbE5jQ=
X-Google-Smtp-Source: AGHT+IGN8Vxqk7TEa/HSRtqK0wjzo/ktRj/6q57PMgBH4vZllHFBJy79YxEqw8earTNcRnAgxsYsVA==
X-Received: by 2002:a05:6512:b28:b0:595:9195:338f with SMTP id 2adb3069b0e04-59a17d70bf8mr4996009e87.23.1766484440099;
        Tue, 23 Dec 2025 02:07:20 -0800 (PST)
Received: from LT-5CG5341NQ4.nordic.imtech.com (87-95-81-50.bb.dnainternet.fi. [87.95.81.50])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a185d5e32sm3865918e87.8.2025.12.23.02.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 02:07:19 -0800 (PST)
From: Kari Argillander <kari.argillander@gmail.com>
Date: Tue, 23 Dec 2025 12:06:17 +0200
Subject: [PATCH v2] rust: page: Simplify overflow check using checked_add()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-rust-page-check-v2-1-fba3dbdde1d8@gmail.com>
X-B4-Tracking: v=1; b=H4sIAJhpSmkC/3WNwQ7CIBBEf6XZsxiBkIgn/8P0gMu2bLSlgUo0D
 f8u9u7xzWTebJApMWW4dBskKpw5zg3UoQMMbh5JsG8M6qSMVNKK9MqrWFwrMBA+xFlaRNQWjXb
 QVkuigd+78dY3DpzXmD77QZG/9L+rSCGFHxQZNTh99+Y6To6fR4wT9LXWL6Dpu6euAAAA
X-Change-ID: 20251219-rust-page-check-819ccc39c53a
To: Alice Ryhl <aliceryhl@google.com>, Dirk Behme <dirk.behme@de.bosch.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kari Argillander <kari.argillander@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766484438; l=2211;
 i=kari.argillander@gmail.com; s=20251219; h=from:subject:message-id;
 bh=SKYy/YgRp1r9S3quaeIxAAdqBkH5PhOTty0BpFAOeK4=;
 b=eDq3mAAdL87bd1kGflfZuQemmgrHgZMjA+4U7KTkOhoEVqa5T3AaiJX306VXEbUHbwR8s+PF0
 Qh9ieyXxc8nDTMB3+0Pbhz81iZQ9WoAI2AQICkKYLbFmV6GUZS8BKHm
X-Developer-Key: i=kari.argillander@gmail.com; a=ed25519;
 pk=RwSxyhTpE3z4sywdDbIkC3q33ZQLNyhYWxT44iTY6r4=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 591B7C0011
X-Stat-Signature: grkzfxzzq3q5prtoam4z6p3cey977gps
X-Rspam-User: 
X-HE-Tag: 1766484442-53720
X-HE-Meta: U2FsdGVkX18ApxBWNZbvc26hsmzKXS8qxd/DyYXfN6Q/wjGpLSnMSPP+uQxOLrys2cS7dRh7okTKZjbp7jLcI5axqFSEHqjuzEQve+hQRDa+aW7L2ghbbi+tCq8hDUGm71DgSjT/u0bn5Cm8551FO0IUEj/zNfvoHnny8Tz2pxABbCmwwepmVAUs9IYVahPkB4DDx7mM5jaDfYWffPsDTi2dtpyQBxqDK5RV+qKiS4IgO0+kUspgCkYZzn+c9GquBXxPQTE+A5KO3GtPCk6DGyStNyixUOZGS6N7jYQHwMuRmSCkGskZ2Y+KAKI9aGuLv5sd0l5p9HYJy7noA1uhbQofnXQbDy+JSalsgKU5MRwupjD3jxa84A9XYmEOxX4gatXjAXK37RkLvjT4ZNC4XwNHuVvwwnTPmuv4zR08dQd/OOBNT1NuLq9uRyznwISxIywbv70Rg3pF9LmfO1ZiYLIiczBIPMnchdGkU22ueeAXmO18DHzU6IQEsuWuUEB7xfFwsXZXOEiAYdSbZ4LxB3jyLDdqXStBVRlQALvoVVqSkA1NOqK3SwqusbPz+dkYIKhsFsykDRLne+c4/Spx/cs8hk5vNaRnxf2mlKq6mbvy8krpJKGwJ5HaPIfma29rLZARnu6du3ltRc02ILIaJ4TTBbDq+EIiNYfA3uliZaCsPqaXNOC0erYE49rUE4/MTgeRVxw16PaPrTcIaN0iinZuS3YYnD86y+dOz72c3bIN8h9O7BQD1ub/EEerVPW2j+VPlJtQ+DPZAATzS7ARK6TKzxL7CAa9OMPJQY1CGv7uxjsrkDzRPH6yxcrxU3FGU8xXYUDYSy2vPUdaBUB66WdDsDqEk9DQiCQpDAdvlzxqsBv5Y+qrYAU8tNmG/INwOp+D7aYjTXJVFDXHA/qEJgDy/TL6t8mXu8+6k3xLdope985RBUJ7xndg5U095S6Toi35LDK7oqZdPbUjo10
 1FlorOsY
 Y6givXNXcGZN7wv+1IKS1TLL26rNzACNokYXlqedWqeRKTcAhCJkXPZtPYnht/FggymL95+DQKu6OiiQGi1P1N+E60quyVFAbPc3nXJ1rjC3LaMNcY2EC27Bb35eMTVhgD6r/J4sJ9K8vaqXHbBytUdO9imCq4fiLEmy5iTsP8cyqt+nMST3ZFZ8ETzHQXOpX5Xu4C/QFV+a1zddI4xvzvS5kVDKZe5uc42wjWKwgCekJwH5j3iRf+hmcKPz9NJxNvDcze2zI9EARp1Wm8UKSPdYgAzyVszCD+aZcNwQ7M5Lt+AlB5lKkGlt64GUO9QMOCC42SByazbvWAt/Ok2GY3p9lA3aZuv8gdwaSCH8jxf+gSRXArQ07SYsYbQIVZ9SJbhdP8l8xoAP8fG5PwBHsnC6UhZpn6j+P6ge7z4M8tlvC/yjiVZXKu6rssnfp553L+gLM8up/FhbCGiqgGuqjaLu4s7hezpcklDPHtgfpmRZouO7u9EhQHsRWD9BvhnD8EqwfZfM5b3CRjyYaoBKPza6IjYRwqAcTeseLw6iN0mPoSvAOU81jId6cWknW0ucaOukZjENdKQgiemJaAiBGsp2Npmewjrrwu1KvcI3DKW3DAw705+GVQgS30Z2ZccXVqmZUS+wQM29W3/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the explicit bounds comparisons with a single checked_add()-based
range check. This avoids redundant comparisons, makes the overflow case
explicit, and results in simpler generated code (checked with godbolt
for x86).

No functional change intended.

Reviewed-by: Dirk Behme <dirk.behme@de.bosch.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
---
Changes in v2:
- Added MSVR todo (Dirk Behme)
- Link to v1: https://lore.kernel.org/r/20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com
---
 rust/kernel/page.rs | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a..cd2af7e4c357 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -239,17 +239,16 @@ fn with_pointer_into_page<T>(
         len: usize,
         f: impl FnOnce(*mut u8) -> Result<T>,
     ) -> Result<T> {
-        let bounds_ok = off <= PAGE_SIZE && len <= PAGE_SIZE && (off + len) <= PAGE_SIZE;
-
-        if bounds_ok {
-            self.with_page_mapped(move |page_addr| {
-                // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
-                // result in a pointer that is in bounds or one off the end of the page.
-                f(unsafe { page_addr.add(off) })
-            })
-        } else {
-            Err(EINVAL)
+        // TODO: Replace `map_or` with `is_none_or` once the MSRV is >= 1.82.
+        if off.checked_add(len).map_or(true, |end| end > PAGE_SIZE) {
+            return Err(EINVAL);
         }
+
+        self.with_page_mapped(move |page_addr| {
+            // SAFETY: The `off` integer is at most `PAGE_SIZE`, so this pointer offset will
+            // result in a pointer that is in bounds or one off the end of the page.
+            f(unsafe { page_addr.add(off) })
+        })
     }
 
     /// Maps the page and reads from it into the given buffer.

---
base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
change-id: 20251219-rust-page-check-819ccc39c53a

Best regards,
-- 
Kari Argillander <kari.argillander@gmail.com>


