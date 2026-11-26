Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3B0606A68E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=M1s9wfC/
Received: by kanga.kvack.org (Postfix)
	id 728066B05B7; Thu, 26 Nov 2026 09:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8506B05BA; Thu, 26 Nov 2026 09:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EEBA6B05BB; Thu, 26 Nov 2026 09:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEAC16B05B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:53:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3EC41404C8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:53:14 +0000 (UTC)
X-FDA: 85477563108.06.7A4B715
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECDC44000C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:53:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="M1s9wfC/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704793;
	b=7OrjTXlzddtYL1o3jlfiSXeBLZrFd7F/WEkFlYOrSKiqijzSN22E5axZIVQfvPuMWo5bPx
	0IT8TZzU4cZjZrfA7Fs7XhAeArpggF7X5RHm/cb38dYAyotY1ggbpQ76iupJlkZUbtHuc3
	QPU1vp6UiKr7OwAhmO3yuM9k8KUaOvE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YeDEQjq1QHnb/SlOHmlULyGohnJ9XGys0KZ0/DkEdK4=;
	b=lolrT0nZKeLMw3G3dRFcadCUrjZPu0dp3rt5ScMAvka/+ikpLzZ46oIzL+EampvGx/XLY5
	kwcKbAcKpVwo0HyvGtixml7g9g3Ay99gHphTymZHqT1s8kCZ8tpjH/5dB5zkxwVMJK1QFi
	l0vKf4Zjv55xbCUAp6evp1CoueBEgwQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="M1s9wfC/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so6538036e87.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795704791; x=1796309591; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YeDEQjq1QHnb/SlOHmlULyGohnJ9XGys0KZ0/DkEdK4=;
        b=M1s9wfC/fzOKmK2MBtsqJ8bDNGNSlVY8BZtelDJNuvJBFAsetOXyY43pusP/c/Pn8o
         UGJVCeeffZycPXtJlNdbGXvp3auTqnN5+vBkPjC81h/n+xSovJ3z+vkXYLIVX7f3Oviw
         cSJnron8ozCqyVR5CZqdPtO5nPN12kbK1hst/bGeFUXkNASNUuOKG8I7l40tmiTVXzyW
         22fc8U/6oU9+Z1iVD3n4cX2BHpB381dXDX/FLmKqWxAPRVvfNS1bWXwlIboPD+vbICxX
         Out2Q6yUNGVoLOAG+dMBkAUv79WDUs/+/FYOOJQwfjis0+gD27JTTrQyiUCQl1JgB8Ct
         Pq8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795704791; x=1796309591;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YeDEQjq1QHnb/SlOHmlULyGohnJ9XGys0KZ0/DkEdK4=;
        b=kV9prpNGD5WHfGs6/cjqUVlhMkNXrwAkP+Ri3GtcWLMEfmUxDlSX0WmD1G88I11k+K
         jwkQjGtXpcVDWVAn4+XoiDyc7jjYwQTNstdOKlr3oqrQjCKt/hgZ9iqslgs/7h9yEMJs
         NQSAEyLwk7K8EV+Ec7f6Q/Mmq8UcMRw+00YBRnUHlEY6LX4JU+/pbGZPxmod+db1Zamw
         EkQ75eWypbNnGk/sfmu+pWOB0MaQp0yFOOMKuZReOklaUKdfn7VgPhs3ogVy3kwOt3Wx
         B2bQtYHUeHe+ew5SLIWLxp/uu3bZ27OiE/Tc0hO7QT1GkTBnr5cx1Lp1yaRpxxSgME/X
         s6jw==
X-Forwarded-Encrypted: i=1; AL+hErFj5iNg3D4zCdIODWRosUVPvndiRRqBB/H75oZOEDGfN82G9sIoem23I2Xg+q2iXMACd/kdrOFI2g==@kvack.org
X-Gm-Message-State: APuU4Z8oyofowImpFYQ02t9k713UWhl9TRhQsXLbU9zOR33Hm4PeLdsq
	yDngz2wjy0j2gas8oef9MiOZear9nmK4CwQEd2qJt8vmEMPTUrbwx8b6
X-Gm-Gg: AZFdTZfL0aYwUtleDlChORQazBxkrNat/TwKLIg40lDQvgfTZ4hZf/ZRm06TjsD/xWP
	mho9bKmk9WqG8iNADJ7ChLggqPJvEdJC8NSzSnJ5NwOuXfbL/+KRq+Wsgl3uRqsQ6bNSyO8eV9k
	VUI/YlY2/cy8bW7WcDSzlgMNk+rm7mam/nx4dXdaqnrIZGQRw8sEvNi3O24qhb/k1pSBH+rTc74
	1GNIeNQn1tyx3qY63DI9r+ICO6ooapbtnXdripnyE1BhaGCAMCqverPn/Et2J3AuablSIfkSDKp
	bRRRxG4PDtpdfQvXgGf02q/PS/LVhXZzykCR4JBYMq65GpP7m1y0uPsfhXDLNTkasLpvkuUNdZX
	f7VEtmpYTqLCEe9Pzofw/P1kwxNig79l/WvJYa2/U55LjMiYwINbyUkjYMsSv0Ub6nrwB46Llzi
	wQYrif8S9aIAjBFXOio2yXpX8QrrtbMEhUo1ZGUAVimy5/yVtbix4vWfbE7QbX4W+yUjRblqPb+
	CzO1x2XwwnrbJml1wtHVg+jC5Hge5mwa9d0ar9xwK3exHFs7t1QFM2lOGYtbFI44sqAL94+/+iK
	uaiIvY1UMpAkZRMJGwA9UJCCZmj/KBSAPjpO
X-Received: by 2002:ac2:4e07:0:b0:5c1:a828:499b with SMTP id 2adb3069b0e04-5c1bc682145mr6200113e87.2.1795704790902;
        Thu, 26 Nov 2026 06:53:10 -0800 (PST)
Received: from archlinux ([194.28.181.64])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bd06d1efsm5493328e87.72.2026.11.26.06.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 06:53:09 -0800 (PST)
From: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
To: Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	=?UTF-8?q?Nicol=C3=A1s=20Antinori?= <nicolas.antinori.7@gmail.com>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Subject: [PATCH v3] rust: mm: warn once on invalid VMA range
Date: Thu, 26 Nov 2026 16:52:57 +0200
Message-ID: <20261126145257.192636-1-mbkchelofficialdev@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pjtt3pb4mshugjzcyi16wehyahxhfqtx
X-Rspamd-Queue-Id: ECDC44000C
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795704792-371714
X-HE-Meta: U2FsdGVkX19PtFQROfaZ4i/9CZO9+2DX8uX01HMXzv6q08ZeDyKDJvmrsOJ48CWG3VkfeXT8EZdhel3OlrRcqaIzPdvnu0aJbV1S0sVsSGqAZjDpEcMGJblJ5Yr7bKIXrVSYX+zOPfGSQ+zK6v/aeiAkTCRxC0cOF6Pmyp5WUZE9N93RW8yTeiaxa9YHPjl4vv0wPHBUnzCP+pgFJFj1p9r6OjyrN91tUGOf9VlPTza9avWOhWDlyV2VusGe7asMhzpdo9BMmbgSNb4qEbfQJ1/q3lCb2Ur7a7n8rLXiKfqkmD6Uvrl9jN4CGUFYEPChO5Wc2Jspskl7Z8fFzLNF/sNYpk+jjea2cByTUuxBn8A1JqZjAFS5oaHtEiuXaTcOX8bWdrmAXjpeU8oDJXbOHdj8RxsdAQDmG+HYbIy5Go+ihEDhVUXw5xjUSGztd/BDIaQAK/ZfAyBRpFEnIvU338CBS2f7PO6Oh1FRxf6XFeEqYdbx9tsEFnyE7oeZ6SWZZ9+IjPc0BOuTL1l9YLLv463tM7IdGYlZwDHEO1/LQ5Ey0EO041oNV8AbOUTYlu4adnEfbKzVE5hjUb2xIPw6GXsqeqWXclQV+0827vdEO1/zd3THqsFdgTaZ+b4snqz+f2VQBGnfT891KycFvQXKGpcZz+oV+WVaPU684wR94e58DF02ELyudw8Bw8hFSl6CTlAxYY0uvf6KVHroxT7r27eKLghBUOoN/asSSf2/k3J3VMqeCFT7Y7oUMecY09nTRkCBeChS1WfdgoEI+7loTKe9IXAc5meEFdKHiIGhSio/WyxXY0B58HyBkrO0y9v1FCJBKQdBGTk4Hb+m5Nh6b42iRzjb2OuV4r3f4lIldtqLa8w4mWQSqzf/9bra3aDeoy2vCObqq4T9aFT3b1e361cz20pCPeLfkoBa3fuCDmwV5LSjsWyWuPvtjAxyUWLHCcDIcFx1nv+GgrpHYAO
 hXdz5ZD5
 v156w96TJcRdkZaoJvSlXwhDenA7TFBzVlkkikZMfMBBUyVkHCwvI1RRGX0DNKK4oJE0UxAja+tV+4XlfX6/SasG2n2aOJzcN67LC4JzrGHeCaCJPaLVwl0wBBFm3OG1RBozUlYoWlIXC0frvGy4EZVLwARBdWncWL3gye6rushAXqh7w9TbU/b4jWfy8kL48zvuWT0yS+4PxTgtIbClkXwynLN1cGtSCi/BCIh4Y98PHPmkFkXhCHBo1q68egky8h7yBdLQSUc9r6F3lu1a38MC8/frNJkaCwhDrF6n0FrZVJV/SmeaAi5dKt8KJ2eb0elvLpBU/UOKJL59zDr0gof1EjUzL2XxrIxMFYggED35y4Lb2UgDhlv1wKhHGuFwMQCK1pFqq/fLiDZ41H/UzdptP9vDSWW3wum2Rowd4MprQVN8659aHAUjBs4/iD/KZGptXaqr0gIqYFa9UAscSRr9OhtGyhq2B4i4k55PMHabEsZH1hOj5V7JH7saABSng2s6pdnfJmhnqXewqpRW0AiP5a+nYEXn2UmSdLbEHFfv+svvPZWWRtqZLhW0CgfYErnCqL9HDB79UlKKEjIpk89OcbliYIheXaqx5znuF78WLrFCNp1R2BijO9YUMJBr32w6wikYuva/CnyIMn9GwPbYevCOTCC+QbACq+MZ085ioZ6Zy1slzu2HIOB+vxqMKUW1Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use `debug_assert!()` and `pr_warn_once!()` in
`Vma::zap_vma_range()` to report invalid ranges.

Signed-off-by: Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
---
Changes in v2:
- Drop the `warn_once!()` macro and its KUnit test.
- Use `debug_assert!()` and `pr_warn_once!()` in `Vma::zap_vma_range()` as suggested by Miguel.

Changes in v3:
- Add `#[cfg(CONFIG_DEBUG_VM)]` in 'pr_warn_once!()' as suggested by Nicolás.
 rust/kernel/mm/virt.rs | 4 +++-

 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 63eb730b0..289511dc1 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -115,8 +115,10 @@ pub fn end(&self) -> usize {
     #[inline]
     pub fn zap_vma_range(&self, address: usize, size: usize) {
         let (end, did_overflow) = address.overflowing_add(size);
+        debug_assert!(!did_overflow && address >= self.start() && self.end() >= end);
         if did_overflow || address < self.start() || self.end() < end {
-            // TODO: call WARN_ONCE once Rust version of it is added
+            #[cfg(CONFIG_DEBUG_VM)]
+            crate::pr_warn_once!("Attempt to zap invalid VMA range\n");
             return;
         }
 
-- 
2.56.1

