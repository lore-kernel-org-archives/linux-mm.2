Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332B2606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UK+E+WZ4
Received: by kanga.kvack.org (Postfix)
	id 440866B0751; Tue, 24 Nov 2026 10:32:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CAFF6B0754; Tue, 24 Nov 2026 10:32:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB8C6B0751; Tue, 24 Nov 2026 10:32:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5C006B0751
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:32:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E93740C32
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:32:41 +0000 (UTC)
X-FDA: 85470404922.18.FBDF937
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 91F3820004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:32:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UK+E+WZ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534359;
	b=QCFKuQx8ZzxTPAgvOujfKxpfm1TwfGgjqNqrP7seCRmdz8VhYOZKBfjtb84HwGIiV+FoVP
	mO8HUJcbd9d6iO7iyiCER7OtHKwOQ8qA3cACDiPUI6r83mpVr8nQf6kmRQ5orS3HoSCEuP
	rZLoXgssGdWZSs3S404NHui2taBszdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DViz0C7Vglsfa0BWA31WXXyBe46zwLDFGwOF1Bp/uI8=;
	b=w04fc4FQ4NTS0OmwCjed0xXltsRyV9apDAbHNP1/d/8gQo76Pw7IuI7LyNNuvuVS4kxqrw
	NPD5y9nL8q0RoNkZDJK+hmax5Wy23Orff+QI6D1VFZvlo3+wzk9UP304EetfUxmo046Ju/
	YvhHKP9h/3Ceph3HXdyezO2nhkx0seg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UK+E+WZ4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of mbkchelofficialdev@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=mbkchelofficialdev@gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3adfc004920so43712641fa.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795534358; x=1796139158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DViz0C7Vglsfa0BWA31WXXyBe46zwLDFGwOF1Bp/uI8=;
        b=UK+E+WZ4ElUodH7N/nZZ+fIZgKlEhQr2HnzX2j2UNgw3CaHAGRbcBlHKsfIFJFYb+n
         PiFhr+voorwrDGEuL0zZ5MGNwibJAHe4OUHhUFVdgkMvNp6aPvI9tlJMsf1Q6GkEd4Jr
         lJSZ4srNufPzXd95fgQkGl12W1hjTO8jweUT7nGMSFx5qPge4d0woN3oIBBK4SuTOI2F
         pGdnPY6GQRwlJmCV+b+TMwTieedGSFgfXKqxyJSlKnUjLreSpjpSLTWXBgq0XOfIvZso
         wZNjvLh/2GJg2/srQNeQgcorDwEOuIr2vIQ/sJ2Mqw4rM1D0yFoW8+oJAIKlPDA0RmBe
         BZ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795534358; x=1796139158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DViz0C7Vglsfa0BWA31WXXyBe46zwLDFGwOF1Bp/uI8=;
        b=v2v0LOQ+zeZphRq5P5mgNSQxkdBo8UG/5oGcarCxVFpsk/hCQ/8Mx28eZNsa+8USNX
         Z3sK7neOPEGyno6mFfejsvUJqFEFdbKgv93ZgM9z4znqjPVFLilvj26sERbYvYwf1UNp
         u/wLr9lOX5M+B7I29d86rXfj6iFy50hRW2Pa5S2IPtnhSsC5kVE1+SnI/o7UWHs25n1x
         AbqDnRAGoGbxpm874jqm251mHSXfFCsZpSUchk2EeDkZhaAmlPj/bDX/JZFE8DDRq/6z
         5UHUf2CDymP+eswC8d2728yB0nzeLTZhmYNMnX93StjkOMUyTD0mqmOR4aVwI3vOvBDf
         ObUA==
X-Forwarded-Encrypted: i=1; AL+hErEqzIyiAvox5kF+Qo70OHIjkR+EJ0AUiNuQloxx9p9hx17+ZNlUhNkgZNbKp0FquDdFh0DMWeIevg==@kvack.org
X-Gm-Message-State: APuU4Z9lPDY+C3YEhgOFn642a1yRGmrcwp6GfMEx2bzo0j8opKT7fQNk
	tO6OZYyOvALqNQudEjRjL5AmSEODGYXEKNEmTgVSc+ArLS/erXDt1vhY
X-Gm-Gg: AZFdTZeOrHmtB3IyYVb6agcgb8uILYLxMJcqUqIbrQf0JW3DG1qa+S8MqEQjEFuhihm
	excUYiWdYJbv3pfkul6fiZzCuSid/tGCHU4I2rAMNG/3O+XuiJGpZ1WSJOh5e+KjDYv8qAm5TxF
	A7YhOdtxXF1jDaRtydRxv7DdgDcoZLmq9kICfXckXW39di22yIss0EUIDSofaQlXQqYEZcbby9j
	2+qMaTg100FVgDvV/Fzq83/VIHIAS1qlF0OurNvwiu8tabi7U93CiubB4Le7RE654e5cxcFF9nT
	2dxQ29ldykleq6sEBvc1U2l9YnwZM6XznYDnSq0sD7YBM358W4XCxk365wOXvRm08u4lRTrA5gx
	GAQOyjf0Od80UgLniRhIrRiEWnqQCOF1NlVOeio+IL1Q0aopU1JTo3uxdAWnJj1+jIwg89eNse1
	Bx1DkU+6JcOmoermJXitgLRLBSlOQQl2Uy803N3EI/ko0R60wxseGXi6v9ep3WSnJKpkUYDFtoa
	gKvJJR0q7LAdEydnNixaUFZhN2+gOAExvs3oGAnD4H6BhhdS+fUkXlmBQT83WF8u2iQ8UpRG6Mb
	AQkmdGzpWqfyBj42pdM+kGVsi7JgBYpHTtfB
X-Received: by 2002:a05:6512:3086:b0:5c1:ac37:caf8 with SMTP id 2adb3069b0e04-5c1bc7c3b81mr4720023e87.10.1795534357650;
        Tue, 24 Nov 2026 07:32:37 -0800 (PST)
Received: from archlinux ([194.28.181.64])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c1bcf33312sm3925086e87.4.2026.11.24.07.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 07:32:37 -0800 (PST)
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
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	Ivan Tverdokhleb <mbkchelofficialdev@gmail.com>
Subject: [PATCH v2] rust: mm: warn once on invalid VMA range
Date: Tue, 24 Nov 2026 17:32:28 +0200
Message-ID: <20261124153228.134723-1-mbkchelofficialdev@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261124132609.101657-1-mbkchelofficialdev@gmail.com>
References: <20261124132609.101657-1-mbkchelofficialdev@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: qnri7dxswxhkck69kx4e3c8nig3p5k3h
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91F3820004
X-Rspam-User:
X-HE-Tag: 1795534359-933819
X-HE-Meta: U2FsdGVkX1/pQpMzYzz0NEdCZmF+td9TYrCgizkdtDP3gss5LFNMZtur+WOgs6Jf2TO+rOl6djs/bajt54YG/YeaEzsS5qlKcZMST0U+wyTx1nlQbsBFgyL1BjaC17Q5yFBKXMcabNPaMcgcs1ktnPIAwvb6MlMU2M8wYSIiz5AYFZdWKkyt02SHoECCXPLpFzeP32misxQd004GnHkzc0DRPPXG4Vm2VnZCWDpKZvBiayH8qjli8JbhwojwRnMEpIPf9A0qmeYCjlMGXGVnk+al5drt/lmVORTzfXcdFBwrl5C/WgPQZ0lnAUM5QPycMIDEIoVwKEonb0R37ObhM8x4whscPYKIigZjPf6Ztfyu3NAy9xxZN8chK7RxosmykQ2IJNQYoAlSgCl37EkbIijnzgRRBWkLDY4F4n9MVI/cDdcFs1wIVfbgcDenjBZnB1rqbco0a/tfJ2Xpe3WykAtbweiliQmD+TrBUXJTdvwNo5gD15HOnTLHfmTXpG5t95WqMtGQPf/28KFvn9GBAu+qfPr968Uhf+JoxhrfWiaYmNPJElxpkOZzpA+75gktUylRwY6PeuIaJbs397qMAg2HCD2OZsIoMyte+2wueDGrrdr/xsb+merrmAoTWcud01m/JukK27Y05c3S97Cm1kcwfmqSr1ZIyGUgpfiY+fqLGNETP2y7ftOCwSTlMdpLMg28VaJoceY/HYWtzpBNBixuFCqgS74vHlIMttMdHuneePlA8iWolMtXW9SIEsdKrIMrZ8ovAXsOVRywJGaeV0VhezpdPlLepbdsiPaODo3cNGJWX6aXxelTNLGo4Y41yU0ngAlO6HjO8ihswLFrVokkkZtE2StaUkb/vIa0ULEE/zL2/zJW/SyjnRqTqwcGmv2Tb4caEw/DyzgtGYkS/IATzfDMShNVjIMlAvNW8+ImdxpgIdgR3CZJdaJCg2vKt3LtNOZ9rSAjmyjCoO6
 uVXizoK9
 Xh395r4LK8xzvQ9GDpKvdU7nwIZCJm6UMxmjLbhTxTEjj6JToLIUrVGHXVjQD9rQrpO/jMU19XiazCCnt+IaydXpI+JOKRKQHpU7nj6S0xN755oyz3TYFe8o9KWQqMY2rsbrq3zoY39KvjAXxvGqCj7KhRTKvyYYRr8JmwNKzgTHPNfqZaorbJmOT3gwOyRt8lEIDFfdhaGVP0w1JuyO8as8TUi5pJHGOzJz2+HopG7oR3/hMehyKTyQq6Uqd1xXM0UEH5TBAM8/yPutKhm3t3d/Kmg2IGGEeGptybFOcwhLEfCCAY194PKlYobJUU5r/jaDVlOugCussCpnI+jZdMarOnuQDcZ+0oJey3/N2AANlDJCAagVu9F5jQbAw3yXnIPUH1oyjIUsYwt5o6Q5wFlyruN8vjqMzyz/g0/EJQtHldLx08JFaFecXpnPaedckNgcVBdy2X68ZUSiDkGaEOxltoxYv4yMokRfM4SX9dyyBA0I9cM9Mv/dN9PBdciGWMWm+Wn89qLhBhu6M0aDSWoLQ0tYFePmlF6sWPydOcrM/TLaew5cgf0g5hH3RSYB7FKxK3pm4czdxCiEc4ijMZlkf4zbhOyzOnMWe53x2h0pCVc/Sjhnph3S+iIzCPnDjGt1tdH4SjIKjm+YPO9gRcfHbd631o1iJeLa9dMfdYRzCa6BvnYHyZVsNfvXr+JESPp90PP+h+AOMDWQ12KBd1+pLmVv7nQUeYaLMtCDG9hETgjE=
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

 rust/kernel/mm/virt.rs | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 63eb730b0..1a3a990c9 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -115,8 +115,9 @@ pub fn end(&self) -> usize {
     #[inline]
     pub fn zap_vma_range(&self, address: usize, size: usize) {
         let (end, did_overflow) = address.overflowing_add(size);
+        debug_assert!(!did_overflow && address >= self.start() && self.end() >= end);
         if did_overflow || address < self.start() || self.end() < end {
-            // TODO: call WARN_ONCE once Rust version of it is added
+            crate::pr_warn_once!("Attempt to zap invalid VMA range\n");
             return;
         }
 
-- 
2.56.1


