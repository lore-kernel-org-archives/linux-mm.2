Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 931BFD1266A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 19:38:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A049D6B0028; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC796B002B; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3F56B0029; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60ACA6B0022
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 14:38:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C06AC0330
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:20 +0000 (UTC)
X-FDA: 84175542360.08.2E034C9
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAE081C0004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 19:38:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vqafxAP5;
	spf=pass (imf18.hostedemail.com: domain of 3KUAvaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3KUAvaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764704298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cY6zIVgs8oj5wBS1r8U63RsVERdgroiyYEhYKwsINow=;
	b=ZbE94/YUnPKyEWuZLqq4V6+A6W7/d/UavbKnEK+DQCBVNWEHbYFjCroV1ARgNXegMRcj8c
	fvL88yKtbV8GMmJIu3IEfqW82zATE9R7+XWqFuRHxqK/gOcCEw2PamdMk5XwDvcLJJ9p5v
	kux5eIY6mhDeItVZNTHK0qZCSsO9qDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764704298; a=rsa-sha256;
	cv=none;
	b=Mik9ECg+JrNgAjB2MLQH+gOzcLPzvP1nhICpBlenDnp+/YfltTv7EV+9zDhqG25CqoCZ1g
	fNB6Vwn/FIZ/0Z2arHMMUJkiaaUfoPNpICPEIm46TP6PH/NzOSPiPeXLy3sf2dRWAUvmS2
	HWu0mCSOAeeW03Pak6qK8FfY0WE832w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vqafxAP5;
	spf=pass (imf18.hostedemail.com: domain of 3KUAvaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3KUAvaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477c49f273fso56607155e9.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 11:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764704297; x=1765309097; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cY6zIVgs8oj5wBS1r8U63RsVERdgroiyYEhYKwsINow=;
        b=vqafxAP5D6ylf0OoxwuT9ZXQAp4JEgi66cDzxQQAuYzaBytgtEqwoZa2oSNOvUFMau
         QrVeQqsLBmkDMv1gb14zewP09NtcomxyzmGjogwIIWNDEt1SewU04WMc5RysrO6XsYvt
         Vk5fs9dsTz7E0+FT8j1KOnsP7QW852Y/9jf8K9zBBXMPekfNw5x8zlA47uxlCpx1kgSG
         YEIhoJB/bguSvJatUpOEfwGhUnTBL4HaS3gpZBCGjrS+RamgGayvFhgb0NocQekl4BYU
         ocG2Zlmi8Io86qAURbA4giZI7FT0zADD9jkVa1AggPVBr3TRK3G/kFl13m/y1KoP9qh8
         lSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764704297; x=1765309097;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cY6zIVgs8oj5wBS1r8U63RsVERdgroiyYEhYKwsINow=;
        b=YVgscP7lJiq5Dq1kQf4yxdp2QLyzQyR7vXPN/YD7U4YLL8piii7q92VawWcFaLC8IG
         bf+J3ZUw9qE64UJnIa6kXxaMiyXWnl3sTgyWat3/9wVl9EUzb3Mu4L3EoeIL+OM+Cc+g
         6tnnhEZ0h5ZSUZlrseJIw6RTNnLZYL9K94oHRBJh50PmAXYtpbLMgWDwLEO+/KnMab3m
         fhxFo5k5d1lDIAubgIY95qZ5P67h1ohrTegQsPmrZ1vRP9uc0H93XgJezmGMGKxZbZtM
         hNfwooYK1CZuplacf9zO42roz8ClNSTyQZcxpUbDWDA7m6y3PzsCM/T4XhxuGCqIXdTR
         XfYQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9aUIL4FL4X4h18nq5YqHYR1h3odFFvh1OkMnQgB7t7W9LVtyoCIiWOWqP6UnpdiGhqnB3tb3c6w==@kvack.org
X-Gm-Message-State: AOJu0YwBOtLJ6EVqInEzuww1773p5+ilfu/bdkj2YRaPEnv5KoOAkyag
	GyRkxKuUX1D1MdOFZVG7oo6sCUGjmIVVXlrGb2gN3QmIavDJLv0PZ45JIPIqyO8MMSaXtngVWke
	gt0qxGyq9D5N4rssySw==
X-Google-Smtp-Source: AGHT+IFcwWbMYlcRexEdOE1jDvEmEKwihlP9NvSbx51wpfs2n41agdwJLpO0F/fYzRDb2riuwhzLO80opasVOCE=
X-Received: from wmkz11.prod.google.com ([2002:a7b:c7cb:0:b0:477:9654:b44c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fcb:b0:477:557b:691d with SMTP id 5b1f17b1804b1-477c01eea7fmr401133835e9.25.1764704297175;
 Tue, 02 Dec 2025 11:38:17 -0800 (PST)
Date: Tue, 02 Dec 2025 19:37:47 +0000
In-Reply-To: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
Mime-Version: 1.0
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=947; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=XEQRtG4ngq8j4eZKlMeUQVFI7+jbBl0S1gcS78Q3lKE=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBpL0AJP35GVKABLJqVHhSfe4YaZmYI3EO+6htmH
 wgxD5vup0yJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaS9ACQAKCRAEWL7uWMY5
 Rk4SD/0WnfGtosH+E3CoFEpZy4BInOO22qAAUHaIIYRg0qldDVoF5v8cNx0xIEutblsjTOdGLl/
 ynKu1+UYXtJz59WovPFRKeLmjwCtGiLBXqE8Ko5auf9sogK7TsOwQERHIzcSgyZEUrynyfNYXAJ
 7oiJmoUNXmTPkc2rIQ0pFLq0Lxuzu+j9q15n7ekvBoLIFETw/hDUmtCAZ0WP4GehXxsFqwB9SoU
 xsSvqWIVjtlxgm24rp/cj6jmZ5F0ECT3VhBna6a0IJj3VK+/YQ0pA6Z8QGMJHxXDRXXmqflBxJl
 1EIXyRyegvhcQuqAKYh3MpWSK+jsbnvVOn3/c6lMWbJGXj2E/qREGc9fXlmDC4OTDpLBIRzCmWT
 St/+9gD/6WqIyj2pEMarUhya+o7bk4TbqbB5izGAp/cU0Md/DLRurq7uEWIvsyNpOoEOwrH6S7n
 920XrgYGI5qIP7s50tL6MhDrYU6yh5UVVm3ey/h89cUWSSsZprN73mExdl3JjyBLTLWH60Bmq1K
 mMi75sUZtORA8cYpijsB2G84gtNfDqgplfrUcxKFJbRqxnWHNSVT077fKViv3nj7hLjlNVkMqy8
 IlT9hReYjGbdoD3ns1UXt0NhKK+79OVK0z1z5QVVbSnE2R2GjmxrCWHIkfDcW1XWsBhn2Ax/XwX ksepAqcYlargbwg==
X-Mailer: b4 0.14.2
Message-ID: <20251202-define-rust-helper-v1-23-a2e13cbc17a6@google.com>
Subject: [PATCH 23/46] rust: maple_tree: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: AAE081C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 18mihpqtd1tstk5mhh6aginuimfp5yfb
X-HE-Tag: 1764704298-101194
X-HE-Meta: U2FsdGVkX1/iqRFk2CqB5zk6PgVaVqgXNSMhRn2E438VfamOYiJ5TGFQOfeFSbvHXvQn3Myv83/u5CGLaHo+m00HlbBmLGzCzTXuk1RIE4OVITPB15dqfx4BhNyEW2goqS4JAkZ+KkyCJRj3rUTzMWogh1nY2KrFpSYNV4FHI+okwWX0ol23zMMPZUB9IKufPD6Si1PFknDCgafWKeKDlAbDwdmgSNEVVB6R4CGRnOimkOKgTxWW8YYxOV+JAwIbsQgx4NsxfgmHy8sWJitWkQzwQxfUZQXSUz+9IyqlD7vTh8fkGCJumyiAQ87YczCWqZTFQhSQHEdV7tav1q70HKDvMggnUYu53HSiQG6EncVhkIAlZ5IdwOSCLthwR83MvT+pO7GWLG7FQSxzlmeMwRGE7y7Ys93Xmr8n15P7ZPDHa7AcHTqkJV1JF2QhzqK8eISFp0wTDl2cnbfnxS/HaatTmceEzBeYFrCa8rhnhPBYjGq0JQhTuZJEL5+zwE2HkdDrB9Wi0F5vR7fYAzZYP/nkaibmoGeUrM9qGYV4x0mK8CQ22XInfV6cCjHfJwVkk4Bd/i0yfSieZSBpigSaJIk7rVnklZZxpcsjEIe/Vbnd7ZtZg1TpdKiXxHBVu0UM1t82FOJe5LDCqz1fTi/urT/rcL3IhX4QurFUQGJCjm8IEeE+kd1NHSkpOaPYCP8rfLRjUX20o92GfZVl8MlXY9d9KBjhmbG6rlnO7SrJY2KdKdhsIii5dAUHR+4/V3RSORIAK44lx82AcgLRS7zvSjRKnlH7qmrrUTGP5dlq/1BCW6qffOpY8Tp1ioIgOf88OjdeStZ9gveT4ZpH+CxqJzDgVCQk5WGXYA+1QkdAOHchJlhjMKgW3se35unsAw7QbTQXsElByEHSJtGG4BqzYYB7mppwET5J6qxVNyGhonoHj5sUn879A3sQMqBtts6cA0MqnAGkhBxCWZT2aR5
 bKgcAe46
 er6FeM+DztLoSa2qwwlyZlgAzHDOvGjYl5vOty6kRoWOn+3TgEth9PGj9rGx4c+U4mudNjo9f8hVoyu6lJ+yfvggTOA4D4/A7W99rusO3AlBjr/CAnCUu8BQmrPTS5TLOHNPJp3tIMETgJJFngshod2xQmziYMrAsjNBTaEMfjfLv4SzpWLE/TSioKr47WsBd6FFhD3sOWUpNbe3UNqtSIvLvMA8WfTJp4Dk4rWBp7p99HofEnVgbMfYO/pL801pUE2VxZkk1ZDa5a701ci6zrpZ7juuOw3+mKKpnjOxwU68BqDSMDcs/fWQpFYSfhZS+wJzij/ZyyMChFB9upxrClrn0m7SYcDqelZjNqocROW8DKlp/acZw1A1E9etCf68tt1ThrXamEJjy76g44BK0u/qcY9RwcijEY7+++xWYr38dpTihxs6ZLVwEkWVSRhYLWkHN3Xqapa91jFqLMbkuJXEaWNqfYYip2qzrKT++SKKvmUFaPxL9ACqcWRTZzeyCWFqGJhFkpazLcaKNfxNy+G11g93ovvlkKySOsjBRooFUzXtbFgdijNVp9l6kKrk5G3Eo0MJOwxtFe4xHFxCtFqzEs36Jdzxc+hqDtSGag3dKpdOkn7MmcS7X5bCssg8efHQwcv69VnYrD0m5tekdEO9ytF1M5ZP+zBgR7vKVGAjxrJMMnAnpHvk1rq7mzVOFJJvTRntEx9m43MxeFHwXMqIUCL+rQ9zkJ6gSfoyfgMZocjmmaFyKE9aCnad0CY2ZDvG32ovFATY6o2CJoIt9fkr5hNgg0Orpsr2e9J0HdMKPUX7Xj05fZg/qu4drHRJBN18IHxH1zm34Bxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is needed to inline these helpers into Rust code.

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
2.52.0.158.g65b55ccf14-goog


