Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1159E66892
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632836B0098; Fri, 19 Dec 2025 16:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3156B0099; Fri, 19 Dec 2025 16:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8046B009B; Fri, 19 Dec 2025 16:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3900B6B0098
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:30:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99D3613659B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:30:11 +0000 (UTC)
X-FDA: 84237513822.07.2CDC9D5
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9134C40005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:30:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHcc9nFD;
	spf=pass (imf04.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766179809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ehPSmNwMGVcwoZTHlDIBfUpRRJiLXS+Rdg4CTzgEj6Q=;
	b=J/YC2yDjDWC2PGNUPoSo5rGDXvWuCmohhipasZXCd4d4113SV/9Bgjqd1gAjE5CR+HRpaW
	CZnC/I7929grdlXCff8xS6IVGj/nCxsLWBaRDbfeaW9UJcXUw8Sww8FwbcHf6b8V6basJK
	ZH2kgIERmeZgLSAx3KrmvWIc0GX8edc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kHcc9nFD;
	spf=pass (imf04.hostedemail.com: domain of kari.argillander@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=kari.argillander@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766179809; a=rsa-sha256;
	cv=none;
	b=NWxgVA2gjDF6pqQn28z7Yx5NXTv2HyOGdS6GE7RP9PpzltfwW0jXYh/Vgm30psQ4bn8V/x
	2FhFfk6BaISyi8hna8TepWbJRfffIwWxavE6d+H/uAN0N6YFs7TAYgpgp0EfvBaww4BWvl
	/8b+9coyXqIicS8e+46MnDXjxCK5ZMg=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-595819064cdso3580756e87.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766179808; x=1766784608; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ehPSmNwMGVcwoZTHlDIBfUpRRJiLXS+Rdg4CTzgEj6Q=;
        b=kHcc9nFD6vN/R40PM8mPXTYIXmWvRmNo/6KPuM5AIfP/V0mtVvTBuOqbI3c61q4w9H
         1fhXlRF2QaTntGdLfU53Dpf0bCuyaAe/a/QmBz23opKpB6S3DnE0NiCILwhfFOz26sca
         507+1muM480hCN90VA9NCyE999Is+SKRf+WGEg+StLT0ICfoC1g2ETJxicZK+z8ymMdN
         jP4KUnyJusVZIJ6KOF0j421XPgzgXeH81xFyL+49wsN/a2bVHTnLKp8vKeG6ldNxWsic
         LkLT6JHQlQAFVLhWnhUz1OL4AuIF8I5Osc3wWnzIanOCOzHyPBCaR5q6V8D3S5Q9q6yp
         TVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766179808; x=1766784608;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehPSmNwMGVcwoZTHlDIBfUpRRJiLXS+Rdg4CTzgEj6Q=;
        b=R/VljCP30/XPmEpjAaag7mxJuRHBV0FyGegI3H0xcO1TH+egmmocgYIuB+3ZH2M7q5
         BegNUx9bGzIJbzwaHWUWyeig1ljd6fG1UwMPzNwpDX5ep9K7YHMSXnLV6GSHGQMwDkbY
         PyYSNbNrjGLjSGPls2uaGIs2/1m/fe8xe0vvIlp7pyqOWAJIimo177SeTHoTzHwWCoyV
         FWHop5TBcXVCZgw/9QVD0VmIlMoJBGIDIX1UUljEF3crMwMMRSBieJjSiZOEzXmE/cEu
         0qzgDNWhbp7GboX5rHo4X4dkwAhDLJllqR8Xdd4JHgVaEaleMNJoLFEvOqZoW6Hyo5OQ
         aOxQ==
X-Gm-Message-State: AOJu0Yxy0qE5u89lJp2x0VN6Ay+PCt/mDE6FGnBmTeubfgA727gUphQ0
	j7rkWOtQ08tfkHdT9uwTl7qvImDKP9zODWsEI1F0Uu9CI+91qkWOqNQ8
X-Gm-Gg: AY/fxX7bWex9PSjwePN83dBgpwWPerU1SIjshNteGwvAislRf+k8/5e5PL2hyD6GpFB
	VXNuONKVpHi1VgX+bXirnXiSfZL3jz8HDMccWBE2R6zGiXNup4g6JyXNunp5nYOXmGphZ85K1Jn
	0UJFF+7qHz2WRKWQjMmm5iXl1HkOR+uc7GALoUQmfmbL+VOHE/Phcva/FvEiWk3qtm75s3Gpat4
	OpbMPpmQ5F81os4FhCEHcRTeYFyz1AOw35JMdZbBPuv/j20X7QrexkgheWnAl90xWSflhZR9bKC
	mkti5WKVLMbbul4pJDh1ZOuh2tFLVHRDYEZBu/UJDtsXDwp7Cmm3Wx6HhsaPA1naEeUsudJFCLC
	Ny/89MlrJHrTHiaLjmXzzdp91g4ezCmLGqK/2HrrU1lmNpK/UI3h8acpLVudckOokCDfjnEGiJ9
	xb1xjbV4SM/4AZwmX8Jg3kNeI+3XoW3fb/sFzfx14uu7O6/e34RdT/P2TipLzI7q4MaqTpkUN5E
	UiMqg==
X-Google-Smtp-Source: AGHT+IEIvBwkddfsy2qs3/Dkt4Qs6IXl/7tpd4f9MZSJ671KBBAi5GQMyG2sb25sEfyCw5Mlhn1L+g==
X-Received: by 2002:a05:6512:2352:b0:598:f6cf:edca with SMTP id 2adb3069b0e04-59a124e725cmr2485335e87.8.1766179807353;
        Fri, 19 Dec 2025 13:30:07 -0800 (PST)
Received: from LT-5CG5341NQ4.nordic.imtech.com (37-33-132-227.bb.dnainternet.fi. [37.33.132.227])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3812251b2b0sm8264431fa.18.2025.12.19.13.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 13:30:06 -0800 (PST)
From: Kari Argillander <kari.argillander@gmail.com>
Date: Fri, 19 Dec 2025 23:29:36 +0200
Subject: [PATCH] rust: page: Simplify overflow check using checked_add()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-rust-page-check-v1-1-df2e52fa3bd5@gmail.com>
X-B4-Tracking: v=1; b=H4sIAL/DRWkC/x2MQQqAIBAAvyJ7TkhFyL4SHWTbcglMtCKQ/p50H
 IaZCoUyU4FRVMh0c+EjNlCdAAw+biR5aQy611Zp5WS+yimTbwID4S4H5RDROLTGQ6tSppWf/zj
 N7/sB4IAtzWEAAAA=
X-Change-ID: 20251219-rust-page-check-819ccc39c53a
To: Alice Ryhl <aliceryhl@google.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1766179805; l=1981;
 i=kari.argillander@gmail.com; s=20251219; h=from:subject:message-id;
 bh=hEPhKwT/pgywPCq0dB8gQ/MONU1VQk+JP/YIdz6V9os=;
 b=hUci18pgOdk6yTb8UpLS8La4oZ7CgBWZEVi4bwZBPyMtxobfJC7ZYdcuiDOOURX8HfAW7o23m
 cDtYQgBI+d4ChqGw1QSAG7qw8CyNnRcLeNZ49DSZtkTAH3F3jDbuiZm
X-Developer-Key: i=kari.argillander@gmail.com; a=ed25519;
 pk=RwSxyhTpE3z4sywdDbIkC3q33ZQLNyhYWxT44iTY6r4=
X-Stat-Signature: izu8a9f17orkxiaqm6ns7okdbx9mtqpe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9134C40005
X-HE-Tag: 1766179809-685342
X-HE-Meta: U2FsdGVkX18zvI5NDrKe/tcdudtdzm2cSTDm7VdE8tqHIr6e0ePi4n4Sw4IMU8oSr5ZUNS8ARtjplwVZfRBGrSenLxP6syXTdXku7ZfSHplpYutkhcbuIFi7X4afqh4fcNdQ5wMmYO6LntSL8SjB6h/CEpLN2N/kP5vClzyGWcpbJjf5L46/umMrASq3lbr9QTU8EVsbZaW3y63H60ZHazscgW6ppIQo0APplMeEcyQM8UL089Zfw4uBljtjP3p3gjhlZRMmB/PUh6yxRAXZrYwZ92QfA6nNgvJ5m3IFBt594c6x0ipQVYh72Vt4MqlAyhpd1mKph2gw5/TnY+N8+OyjwVgZq4ekidEOuy1Ta6FGlObikARDzsnXtzugyWEn6WmxtgEEwBdkNmrkzk7JpHr3IhGYMuSOBi6t9Q2WEgsB52ByxyQJ/1UIQnJmtkFkt1Gsm/DINXMn7UaS5ManczhdIA02Ex/bW5Zk5BS+Pg+kvSLPuyIxY/inA8JULVrE+yvgXQydTCTMDeiQTSu+OR7logiV+nLffOIdZLElDSO4XJvIoGte29N5acDjz7D/qLoMTz0FKe4X33vB4GJm6pZgISABYQ1mbccxMIaIW8Bvt8oB7NdBuGAGkZLoL9gUX+r7kiCIRmOpRowN2uyhSAbfp0TGNzEfPREB7KHjfb+pjxmWDmccDcKG5CUSSkEFRd6T2SM9Ouv2mweLCAtIkCKojE2G8p53VL4iBumHp3I5WVLzr9Ikh/O0PApf9CFLa1utjN2tqYup5+aMLKD2ayDt7UanUSDKzOx3Rr6X+Uq20165DVNGZtYMsHfKBX8uhTcSZ4n7NUHD/03usXQGHDmc2aygzWfw8EdHRVxNmLalyVtxm3IGyr3a4z6o5OzJ4tz+IsftLcPX16l3rMrZJQ8I4EjSExyufsq6G4ZbhSzBAdOk8Ycj5uS/JxuI7MZWAuDl7Gn1Aj+Y8Cd82SQ
 dUIa1I/h
 CPLmO5Co+s1r7IQgA96oSsrKagQFLwM7g4CAJQ+/ygheL1Q5Ma6VW+wHOztNmbDa4tgNpfygWTFQhhPCPQC6EoYWPbnBn+w4QtCDrfm+wFDgJotmcz8xFAwy30z/o97AmkEK1AxR+7Gy/TgDTqynIHlhVFmL+llyljF8yCuj81mQCLjE2S8q6CqueMh702GOQuhEE9OU4lWekVzWQPmMI+VZxD1uB3NjGMYRiI8CBGJu+zmfhivCWz+fN/SUkhdx0UroK6/CReU5DVuy8UIb3dH/IzRmQBJtkWps6ZINoXCtIxri4BsviKHdw8HLc+aKAQuAeHbg0c0goT3p6pVWQRhHcvoNptV4NDZTzoQlHSF8GsGLK6IPLbloo+j7ilJH4iDKwPS77trxDlgDzWSatVDNRXeQdmLZXzYtqc6x5mZNlsU0doAS8fO1tC7rFmOHzkux36/znCK/2wHtsZgttriSPo5L+hqWJHtO8VTpVdA8+Ih+ybnulR3PWcfIDAmIhcdZsBtA5lwkqom+Tof7vOk4Mcji7QMQr4jZn7HV4Kg/YC7erCG6I1belXVpuVWmZqyKu
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

Option::is_none_or() would be nicer, but it requires Rust 1.82; the
kernel currently targets 1.78.

No functional change intended.

Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
---
 rust/kernel/page.rs | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 432fc0297d4a..a07e6d256860 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -239,17 +239,15 @@ fn with_pointer_into_page<T>(
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


