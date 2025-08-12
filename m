Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85600CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EDF8E0137; Tue, 12 Aug 2025 09:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224F68E00E5; Tue, 12 Aug 2025 09:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114988E0137; Tue, 12 Aug 2025 09:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F092F8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:29:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5122160319
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:21 +0000 (UTC)
X-FDA: 83768186922.21.9DE4954
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id E81031C0003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:29:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CkyeBcR/";
	spf=pass (imf21.hostedemail.com: domain of baptiste.lepers@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=baptiste.lepers@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1sFms8DfYlZzU9dKa8CQCWgZb50bkFnu2RQfAfYZeVs=;
	b=UbkZbCbTeT81vbaHr4SwdGnVOGIv05IV+DFY+42Qc3zdfQ+elFqHPg13llFl/fFx+g2OKA
	hw1fECyD62qz70S1c+2lWS1X1msllH8SaTp3XUf3+6WPYTyV0j4La5nJM8k0fXN30fiR3h
	kH7o36JJ1JOMat+9TvJrUhPyrYQzOlU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CkyeBcR/";
	spf=pass (imf21.hostedemail.com: domain of baptiste.lepers@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=baptiste.lepers@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005360; a=rsa-sha256;
	cv=none;
	b=AwHHURnsMr2ITU1Vv/5Mos7lV6MtuzG0DquJDhxwSgAcvHNalCLQmWv+EIm8epoKbdnzSJ
	CiTmLL7opxFEdim/ZrKfd7MhfRTHXWF0gH1OoPkXqbk/QRqrFyE6bZLzbKM6b5vFNxc2hj
	qSwmv0KTReYN64C4H9TK7nZVauFb7jk=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b7848df30cso3660365f8f.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755005358; x=1755610158; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1sFms8DfYlZzU9dKa8CQCWgZb50bkFnu2RQfAfYZeVs=;
        b=CkyeBcR/LEjmy/B9K6GvUV0o4wWchm9l3+ypk/69nGoiiK7F0RvET28IHhUKKZY9+9
         UDW8tc2oaRxhKswSNgcQ/X6/1twfidjgpBQtMiJsXlS6JhV/gcIeQLZ3sz3iUWbaFXet
         MJU3Jz1/F+MJE+etYR/fMJqqay4W6zhHK4kLfmUsHUyntPyPBG7q9UoKB/CMw8sXBuzU
         MkcTZ9MkhoRlkKV0NJNX6Hxdv90F3mYx25AQ1KAf2im2j2/vrgfvwJPKl884D157oohR
         L6ar7+S2Ny7KdCKEIBPn5rPNVOw12d9rhf9FmkOGDNu34ldpa2rJ4HpMIBfaWGoM6tKB
         OVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755005358; x=1755610158;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1sFms8DfYlZzU9dKa8CQCWgZb50bkFnu2RQfAfYZeVs=;
        b=I8c8hBJ1z/4BogQVZht27WStlddD2KFSspuAM+Uj4ZBwitQUpk2xrsRDkkxmPowCgr
         kMyXgtbV87mWZs/lEH7l21/FQ3jvs0ZmLz6mIl3suYSXFqkYEWsSOJbPi1el9JHi/DO6
         DHc9sA2lOYk2H4bybTWN4ZqsQnWyOAnTX+iSII+yoTswpUcmYs5tV7V2He5TNducBBGu
         l3X2ZCuxgYh818YmU6a4+3d6Qw/ugLbDfxd93izH6AcyhWOn+CphnRNvVXxYBr0RjGTJ
         qjQ77FNSlIe8VkzCCC8YspXO1HDYwoKCW3J0dDq3XwDOckG1wMwz6Gto57D14wyfgS+G
         GCIg==
X-Forwarded-Encrypted: i=1; AJvYcCUQh6n07zfUkkfmxhqyu8ItAPWsD5JBaxR0Bayw1SO2CZ23+/S2SzOv0V3maaJs6IPcWAiQU6iiSQ==@kvack.org
X-Gm-Message-State: AOJu0Yzl4VYgQwUhz0CdHsfWbJyhqTJt2tsiuOn7V/4RvPHgesvVly+M
	iTbqGM0DQxMKwcWwS5uSH1Cs2HWGBx5UdZPGf/Dyogc+mlb2GfVZZMCf
X-Gm-Gg: ASbGncsdW5sVbS9NRPWrGoBs7Nwogz1u69J9zJ9CiElrTS3c/U90q85Im2I48rSW3+j
	rMYzrVTzOX4y/YkwRKMGSPEyf2PFkHRAC7elG5mq09yDaH8+bWteUbrIImtgk/1JlNOanNVYmMP
	omHG2WZg8rtV8DVymKXCOigNB/VFUaMZp+q67GrRoOV7TwXXG3E9p/3Ej/MY6XFSftdtHGGlgm9
	DOPTDg+uPtckS3TAvVlB2vT65WcvleDk/XJh3daQmNWJ/yF6kCEY52OFO+h+ew72xYT1JGpQ1X6
	yRFvkVz0FDHdiUmI8LngwaXYR0fSD+7+fD2ESdrnW+7CJG03bPu1fwlzWLnV0WXo+1J5Q+fHH+6
	i/0vcUarQzl2wwBmf1BHNAxWfpcMiWHXyYZA7+CtI+gbD
X-Google-Smtp-Source: AGHT+IGYEv1UKXbeigwHa2TP8gKJ65pVI0sFh0NThS1xGWQn0fvli/9NFZm7AX5K1g9q3yR/X2RpyQ==
X-Received: by 2002:a05:6000:250d:b0:3a5:8934:4959 with SMTP id ffacd0b85a97d-3b9111f4b67mr2712178f8f.27.1755005358067;
        Tue, 12 Aug 2025 06:29:18 -0700 (PDT)
Received: from blepers-Latitude-5420.. ([213.55.220.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b8aab8c0sm433003905e9.19.2025.08.12.06.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 06:29:17 -0700 (PDT)
From: Baptiste Lepers <baptiste.lepers@gmail.com>
To: 
Cc: Baptiste Lepers <baptiste.lepers@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] rust: mm: Mark VmaNew as transparent
Date: Tue, 12 Aug 2025 15:26:56 +0200
Message-ID: <20250812132712.61007-1-baptiste.lepers@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdatn9gztiyorg361t1dtyb8x9ecfpea
X-Rspam-User: 
X-Rspamd-Queue-Id: E81031C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755005359-917001
X-HE-Meta: U2FsdGVkX19AQ/nxZDJSIXwolHd2ALjCdYTNsxdXyIVe9A/tj/Vqh/QYMlkEI9hPIsTKsuRSN/hVhSu2d0hkxpzoLz61NUZj4EQLAXcU3hwux9gJHHCPbgHvXCI1nZBZ/QvnEtrQjLRWxR0C8mZisvY4t2QWSkru3tbTjYOp1m117A5c4Rt0rG40uz4rfhPdEuHxNqr/5Y9WZoqU9F+JeZQvQMIT1Pnpz3dat+wUT7p1gpjkQVVdW9oUnG/ovxJY/a5ZENqNXTqXo9Ck+LJ6KOgxayOaTTdILthl71q994VNPBKUaNgspbhkGxRPCpHyqslFYAv/ON4/ofJnlfSGBTwOM4ZRQhLS99K06ekgQ9sHgwLQ5VU3ZDEZ8Gwt1FyMkQFpXYAProZze0+KGtfbqQO+rdNMKFhdt02LF6fKbgFJARnGV4RrCbt9HWqmPQhVBPBAeNNpdxFUin8fel0qO+bJ74VYicnEpJkgB9lnTgqI2HPo2Ff9dZa33oYhPt1HGzjasjdHdYKj8Q6wueRRw8HPRW66uYx0ne/glRlF1F+zFMRzxtAtJgQJKOBbSsH4moAC1jQzhdQmcIusRcPftx+wqzwbxezlP/LA+FG7hgfpJe8MqL/IdBfReqmdSeLJRPBh5fk48R+nwKcNEaQM+lCEIvlazG28kjThRjpKTQSU+mVAvtP6d6CmowZc5J8PpS0y9odkOy4u5szruWDaF1AZnuID1nBn2yqG2jWYsWRpUBNXOB41b7I/qZJRBBeYA5MeVJ0hc678GkcTKxRM7JgMnwgS5SIExWKz4J9jd0KPtiLaIsEZo89CJmxYwirzgZoeNX3KrWo526jaW1QGxRX47l+y8VXg9f/yxoP6/10Tr5E/sG/Iw+J2ZyTiCDvVheBRrs8JKkF8/Fsc20yfM2JKrAf8nfIt+IhX8BZPY7WukbrBKO/sB8D3wn+t38sLd2ik25sBbpwhk2FEQRV
 1dOzlozT
 qhy8Aju7QScRdY4lak0HPoucbnw21hqdcIobsIAgL1wBuGBmLwUGduHc6vlkwvPaZBCmH1UPoaaPZVRv0thS4UfLhz+IuVU7LdgWTce+flvuM4cB5RZ8Y/B1LAp90BNAUXJO26sHpq8JEKxRKmlH5zMvuA14kHL8DfWex1thwA8HoKuk7BL4H8XrZ7bIm15C8EVxMXX76wrC46QRcsE5YPLZv2TAgcv4toRGFevGtNz+PL3xAxruw0kNg6D3kMFMtglStq1ropS/PmuVtyi1h2TgeVcKUCtgZmz7c27mcKMeerHayo+1YxrIQYhwLNoC6yrL84iVceUjzwFL0vEMYVkYdGx9gjF1n0ajCfSEc3awdOecvkIg022OcItH00yieK9zoBU/pPgrU+9IJOuv9YTVNNYPwogbY2BiY/aXwYH5V7+H08C2OTfpIZ8+FtwXY4IqyH7zUr3ia+KqMY6iOFiFqpQ6XmWWghcppjIDTCUW3qGv4k0aT+XAwP6dsFXFVLlvBrYLvlJnpcLQfloZsaM3AQxYbgkj8rCEL00CbThKQJRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unsafe code in VmaNew's methods assumes that the type has the same
layout as the inner `bindings::vm_area_struct`. This is not guaranteed by
the default struct representation in Rust, but requires specifying the
`transparent` representation.

Fixes: dcb81aeab406e ("mm: rust: add VmaNew for f_ops->mmap()")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
---
 rust/kernel/mm/virt.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 6086ca981b06..a1bfa4e19293 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -209,6 +209,7 @@ pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
 ///
 /// For the duration of 'a, the referenced vma must be undergoing initialization in an
 /// `f_ops->mmap()` hook.
+#[repr(transparent)]
 pub struct VmaNew {
     vma: VmaRef,
 }
-- 
2.43.0


