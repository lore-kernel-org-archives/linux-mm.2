Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D55C79F87
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:42:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9A96B0140; Mon,  5 Jan 2026 07:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B8C6B0142; Mon,  5 Jan 2026 07:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0641B6B0143; Mon,  5 Jan 2026 07:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E72F16B0140
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:42:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99DDC1BDAD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:55 +0000 (UTC)
X-FDA: 84297874710.25.D17774F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id B53241C0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:42:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wg/gJY1J";
	spf=pass (imf18.hostedemail.com: domain of 3zLFbaQkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zLFbaQkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767616973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPim/bnU8LvyeLR4IV1lC0pyB+pbiZT/fuxdT+3ZgLQ=;
	b=aulcBvUc2RhIVAERNlnhVz6CxuGdZhakdzZjd/P97pCxJrOUB1AQvHpBz2vpu2nTqYt6vV
	ZQ1gRUtgllYQ2chld1u6TsW+VsvZZNIfY1lz12qQZYQXoOnXlIAqp5NDAxOYFcLYH0m4Gn
	bzgweY0ObCmVcupKWGonOWvJ807ILYo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Wg/gJY1J";
	spf=pass (imf18.hostedemail.com: domain of 3zLFbaQkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3zLFbaQkKCO8RcZTVipYcXffXcV.TfdcZelo-ddbmRTb.fiX@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767616973; a=rsa-sha256;
	cv=none;
	b=PqsmdvKLgsJ9j4jqTpIMU3VFgaX1kY/IpxON+WCszMdbx509piB93Aln4HXlnNjorGGCi+
	8+BEV17AZhUpC7/QEM37w4vny8rmSVUS5JkRSWQkeDju2Ko0svxK8arMVgi0DncmvyGSf4
	tSborA3viNh4AjzSDFBnOn3EoknLom8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4775e00b16fso60147625e9.2
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 04:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767616972; x=1768221772; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kPim/bnU8LvyeLR4IV1lC0pyB+pbiZT/fuxdT+3ZgLQ=;
        b=Wg/gJY1JlpPuVbqmj9rL8iNV8jWe+eUlkFHaSYPWiK68S64BElNlgzS9Htx09moJ/b
         kvsM+gZIOyIXpfWBwmLPl0CyvXkxs3zQMtAQfLhda6WvGijoQp8o951NEnQfnF5rXrEF
         3agOzfRwEOPIeEmsDtYAIplJYEl9JN/eGDu1/LQUp9kPJEmtCdsorqmsP/rjd5ebN/4l
         L3FZYh2DMoEssaczdg4j98UzwGMS9t0Vph2N9DyVMECRjfDzHxkob3C/DJTcXOACBB++
         3nGpChDJ0U1iaxw8buIoSKzlZpk1pivYJ4iqMjZ/tGsUFx5B/HU11g+58ow7qkXzqBCc
         oMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767616972; x=1768221772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kPim/bnU8LvyeLR4IV1lC0pyB+pbiZT/fuxdT+3ZgLQ=;
        b=abkEN0vl/tYOYdES7x6DNs0Tue7OpgmWvbtnd2LTElSXhfo2W9ZFQwXs6tksfVEwbz
         OP418ctdXNQq6Kx2fygaBBwu7+GvyzQeVhDt1DotwztKbuPiNKWycxn7MNVpwXbAE99h
         SilVkHXsvOlmawfsbfWrUjEFvS2ASf5y80IlpDYG/boqLJCmT00EFbt5B8rh+Mgtkwl1
         YTfkp0qG8Qr1CQwHf+yabEhzdGvqgUgHoZxZZL+H6F7KKzov6UZa5+ZXW+iOns2T9IAj
         Vk9s3Y4YzydL9ymdBKyIRyKBD38I5QloMcAx0FBGZzxHZOedps3S0Kkwe5xwaDT2g3ii
         w0BA==
X-Forwarded-Encrypted: i=1; AJvYcCUjShBCcI8+Qtd4UvgqjaJZswuNarX11nzE8NyPIRN2QJ/hctSAmVelzGB77KxQxnXYqxEwEsk7Rw==@kvack.org
X-Gm-Message-State: AOJu0YxzrVtxz0xSZ1aNpDCHmsoNoyLxz9XC2wZiIRACJby0CybDQ+DE
	IN4p2WP3Mbz72y25gPA+RRdvX/LIjimBSZz03pAZJxZIpgs6uj2c61Nnd+sMDn3Ng+806A7KJfc
	j5QiNjccMTj2maf+2bw==
X-Google-Smtp-Source: AGHT+IEKuUpjRUdDI18V8ybvVSN4B8FWVVfm5z9ZQIEQ5lcls4uthnO2XVm2jaCrQo1BFMS3SMRH4FDVz4X6uLg=
X-Received: from wmco11.prod.google.com ([2002:a05:600c:a30b:b0:47d:47dc:d5d4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:348f:b0:477:7925:f7fb with SMTP id 5b1f17b1804b1-47d1954a710mr546210275e9.10.1767616972235;
 Mon, 05 Jan 2026 04:42:52 -0800 (PST)
Date: Mon, 05 Jan 2026 12:42:23 +0000
In-Reply-To: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
Mime-Version: 1.0
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1092; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=eklUnMkjialDLjmOlCaGbwka3gC+QkgvK41klffYGdc=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpW7G75XlHGTbjrX5WBJdg8/f08EeV+yfpT5LCC
 Sst+D/4TVuJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaVuxuwAKCRAEWL7uWMY5
 RkiZEACa8ijtRTQzaOKuY5mDAmhbz7gVUxOYqZxuc56B8TEu2JchNUtPBzZmkNdhGGGxujg8/Z5
 L+hPwjKzgXRUPgR2Gbu3faZyVMScMhM7NfZ27zAvVDpw1gH1qFAv8+GB5XRwoJ6yoImD1GsKas3
 nOUGwYmOT28FOemvmP1AyljbngXLQkrkcVAo4CLQy07rj4e1x31K6ZaFPkaWaql+V+bOKBplBsY
 ESpdcidT5ob/77QaOLx3zzdtR7gsPhJcQ2yGkTJFuLHzGGjYA0GEz7m70B/O7qR6UoN+NE0RBW+
 WBulY9rt17SZgDVI1H+SnpEYYv5heeJI6hWYeMM/n696NGml4h+3NB3/FMx7EZarJYvMZ/zTRCS
 6QoRlqn+JZ+y5qHlC88lU5A9NzG2i0VKFfg9q4B6aLu1kt7e8DwZUazHnQWlrosV6YrZH4UCrcE
 epGQyjCywmOB1w/X9Nv4bYQ+h1EagE7nowm/nDRWVXuh1uJ/0RI+ObYfEorSBKLfUy2uzLelhtW
 26wO3X7wDiOzSg/75MhFgjOPYSaDdk9RRhqqOp0skHB9ty3qo5WtWjKbO3c7LrRMsPm0M+37xjL
 IImDrGXslKfjgpFAcesWHy34XXR73csgHFrEkBXpf8ppGrCy5hXc+uQsP2ovrATpf7XmZ0Zvghd F/47bcS2Be51srA==
X-Mailer: b4 0.14.2
Message-ID: <20260105-define-rust-helper-v2-10-51da5f454a67@google.com>
Subject: [PATCH v2 10/27] rust: maple_tree: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Gary Guo <gary@garyguo.net>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: eugnhnkxoj5u41ac1shh7ywekpkremt5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B53241C0005
X-HE-Tag: 1767616973-520891
X-HE-Meta: U2FsdGVkX1+RXLsCH38kakz5dpyRMM2RD6fR2KXHrA0Offm4KdDv9XilaxqfWXrKPYnsT6UbQQwvP+cGajMTvoe1tyCpkHJILaR1rUPpfIjKAPwtBcvdJ3DP9OBDwNM3i5yRJd1yekg+5KOtYoPyk0mXNrlJpbDoh6GxnVBiCcI2XTmKcvwdQagolJ2XCVmQmfJbQpgzSekjcLOPiKhzvbuRQiwLs5MT7HZSmcMw/+dT2jUaKFDWY5/k+2K1/Wl6Jy+//U1Uw4UOf/80ejXp6Z4S7fU7imv6JhphWMinYeYGOd3ilHriAFAEfc1uUoju2rCZaMDX43ZzIqIQhxx4pjGceBfQdsiCx9No6P+uJOPrjtcvmOGUCMLo2UtFXWquedW4h4ze6Hj1OAlNEchYcBfNoPQCDQf/OK8G3/aPaNVNAr5bdF01JxezQVlmmge2jOI21Jb6oDxFq3+2E8zIXEtEgn4f18NT8mkFdeIIYww6NWgyD7Cc3NunQXYK5QCntWPEZpEl+AYh5BBcZwkB0rNyS1jiuSGLBpfXg1EqXlwxS3ysbcml3fBHC6KKRchluaef9B2cZNUb9ujvkrLg53e29o+M0H+zOewTBa40oJy8v97kS5ZrjANgFWIfAP4MytbxUvCOfBIWFm1fUc4b934A0sH294oi5rJZRw5SmPUyJ8SWHfANOUPf7/jwWqMNW+2O+vpbNYwPhu1+iBk134ZLxYnXB+9myMx3jPfmChiiY4v0MQ1GA3ri3GtBBGenakhhm349VjB8fQnBr/Vv6iJ3yyiLECubNe7hb4K0yoRiFLEAlZtqNd6XJHWBXlQXtDnK/TNXwlcILbS73w7D6RiyVQHA8Aez0yp1eSeYf6sMHhVyWBDdhhWZYzYWk2akVF4hvfbh0sozuSQHm+Z6ZakjnJYySeFqF+8IpQp+QgIWODMPB6JTraX6I0yEqZSYRr7/rE07wFFF8eMoHdR
 4B0EkArd
 9/FlMl9MSZWDEahjyEFWGcnpq724JZvntUKVc3U0ozqjM12GCl5BikyuX/uE1hal5tP36rwXToH3RV8o8NuzOTj1sbmtPsaj/lf3Fgn8hRWVdd+kPOYkDbiS54Y8qjryklUnD7k5u1hi/TX4ctokmE23ZMdttX046izkrPNbdsziFX22rp7ePIYfk1syoBuR5L9CS7YWxCxAWAvf9H4wZZa4oToDEIlVbupVZS2E5DYBwjrK/JGrwtQI3Q9MI5TFiZwkvbJlPlVYE0ntRwqJUyUhu8WRrhK9tq/gXBEbp0BUxKiL3V8gedvonI3Xxq+Mn/5wEt6p9X4RFkU8Q0+cT8d4cU1Z6FQULt2g3U244d62FV82910PXv+5b4egWP/0rvPlzKfwBCmQVkbWZIoyRYLty3sHkI63XUueJOcWZfRcTib1F4d13gBFlHkfJFrq16xS7+Jq36xDL9759+TBWV31kb5c10p/oOBHlzE8a0eEFFg025yp/DwUU6jSylVnIakBHvwmwOZ0s7+OhNVVY2hJncQlkFekGyhWGoBOtsdM7NYAi+QEorlW+CLA/ZnKMryRfY3UKU4j/JeGwM7MPbyzZ0A7Fnw5/pLv7O0wvkFggAmUYky8AG3p5ig/xHvyV+AMpktpi5HFAxH9ITDSyPf0I3wcpMf44j9RMcgwOROAcC//vbVTD/To+ZVmlbNXwqwTlVHQx8Bos/8ZQqDizS+F4LY9j+oOFaKxMkTJ31bP29b90ONoL62VNz3IVDalxd8mNo2PE2ktcNB+Yx2ARxEr1PqZblf8gIGax7XBC9AeRi9hDcMqNt9Iy0poJ9vPiMEiigy258QFXhSIyOJhE2qbCaGRgGC/FsgJAhntEctb/iSR2h+BplIpSWuVBbkWiupvmk6xU35HyMNJD8+xXLzXgNRgJEbhkfs6IwrQdCFh/2ENmQoWm312wHEoptD0Egl3d4zJYdYZc53h3by2YeGA3/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Acked-by: Andrew Ballance <andrewjballance@gmail.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: maple-tree@lists.infradead.org
Cc: linux-mm@kvack.org
---
 rust/helpers/maple_tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/rust/helpers/maple_tree.c b/rust/helpers/maple_tree.c
index 1dd9ac84a13feed53c0ed5eec6805517081d0673..5586486a76e0de60969af1510b4b0428392920e6 100644
--- a/rust/helpers/maple_tree.c
+++ b/rust/helpers/maple_tree.c
@@ -2,7 +2,8 @@
 
 #include <linux/maple_tree.h>
 
-void rust_helper_mt_init_flags(struct maple_tree *mt, unsigned int flags)
+__rust_helper void rust_helper_mt_init_flags(struct maple_tree *mt,
+					     unsigned int flags)
 {
 	mt_init_flags(mt, flags);
 }

-- 
2.52.0.351.gbe84eed79e-goog


