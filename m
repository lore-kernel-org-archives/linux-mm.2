Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE570CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22B68E0033; Tue, 19 Aug 2025 06:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABD18E0001; Tue, 19 Aug 2025 06:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A752E8E0033; Tue, 19 Aug 2025 06:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3138E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:35:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58963B8147
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:35:00 +0000 (UTC)
X-FDA: 83793149160.11.29CB060
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7073D2000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wiA3uJDd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3UFOkaAkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UFOkaAkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aT2hi3ZyL1ihosw5H2KL076sTulcA2Gel0+KFrHTzHA=;
	b=bWQV1Fg9aT+Y3U8d4qGvpOAc3FB4R4IAppwEcBklseUZQIwxk3BB8OqZOa828UnZ0ERpLR
	OQrSqLf+k2z/lG07MlQxIkWbWSgfVnBOGKvv4o3H35e0gtsA03Dw2kbWGRgeE+W/L/AeTR
	PmQUhUp6BaV9sDGixsF+EjMI59WMFY4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wiA3uJDd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3UFOkaAkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3UFOkaAkKCNMzA713GN6A5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599698; a=rsa-sha256;
	cv=none;
	b=qbISysMKXa42OOzpiseJSP12jzc4Z8mkH4GiQQVDJVz6uiK6n1ajbqsL35UcTo6NmZRvAt
	JwuzFnaey0utOl4LUeb54eG4bqITj++EQpk9MRv7jo8CLeqDaytorR3FyhE0pXhYlh2e+8
	xQVBeH5zHycXgayW2krLWQZxlVPEo1k=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so22453775e9.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599697; x=1756204497; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aT2hi3ZyL1ihosw5H2KL076sTulcA2Gel0+KFrHTzHA=;
        b=wiA3uJDdgzicpBiYmiYOkvs81Z94cq0FeGT11Gkyzsck0BoaMwpClu8gaS5eO0A3ee
         ZSg4odWfBYdWkrd3cslBajs9Aec5OrR4jsFqHdckvmf7gvNDS/qYO6iq6qRdn/wjgY5q
         geha+OI/+X9h9W4yWP51J4v4nrdvk/pAn0X5/SuvUkkPyBvkRe8E5WGdK0yTXbP5okpj
         WWet2XOhpKXzSm5v8lnFC414sT9iKd4QLQnWjUlQn5lKEO8P1N64m9WhcTk+rRwfmr67
         Zz/8vHpuuFnCe+KUml2k+IAL06gv2hmoNXtCdGaZI0/OUt1dCep256gb2I50actz1IXJ
         VDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599697; x=1756204497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aT2hi3ZyL1ihosw5H2KL076sTulcA2Gel0+KFrHTzHA=;
        b=KGb4UPJ0MbdQlg7cp28M8DILN3tNeCUZaKptmXKUyHbNTtMXHU30mGFHt2XnCO0SCm
         PenXhBOl3I2X1aVmDR9l2pAhyXJwlAWbuCt4KrOHpqE3KkeDq2OnFx8w73MIISsFv2sK
         hJpUhdkjctZYpBbGXxbNl7XuouNgnR5pONvbv8iY5bCb9g8kRoHhsIB0T8FNtkxSn9z8
         uElg5Dj9FENMqjEJpHiUjRu0EtnaiZLUXDVbYzW0+ufhXqIev2xXgYhJpYHurOnW03HZ
         XUThyX6ziJW1pXzdTRyH1Zj/tjFCwz9l3hMJex7jhNs6fiM9SfOkgfUvx88GegU36MU4
         wimg==
X-Forwarded-Encrypted: i=1; AJvYcCUKXIHLbYz4ufe23381pqde1LW34sUTsIvpZiCVfvpUritIb+lOAZm/jfgKfspaWy2Lv9cie3jeGA==@kvack.org
X-Gm-Message-State: AOJu0YzD9JtPYuNn8K9CJW4bXGH8TOyHTJTD4/zvpCKGs/w9lPh+5dNg
	5Yx3Ha1ku/+42wyJPpMmEQx652ueSdWMUTSrxoNsE/+6aX1WMDKkGNa9OdySfJw6cOCA9sDR4Qe
	fKOfERxKhPUUs2dQrmA==
X-Google-Smtp-Source: AGHT+IFOGHcN3UGy6VodHfv2J2ggOgbe86pTWO6txjKCELGMHO36iGV+vPOgfJvJAny0LQ3kLq09givQwoeUMc4=
X-Received: from wmbhj22.prod.google.com ([2002:a05:600c:5296:b0:459:dc8a:ec9f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c92:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45b43e0acf3mr15822075e9.25.1755599696980;
 Tue, 19 Aug 2025 03:34:56 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:46 +0000
In-Reply-To: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=1469; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=EOiel7LVR149bFLKGxoFqzCvExjuT+NKJ9JARxaqNE0=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNJ4MbXWnL5teO5qvs43aMJT0mDzFTXDzw79
 BbWKKmKtB2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSQAKCRAEWL7uWMY5
 RhYTD/wL2LeD5NE64x8lArC2giqMmSV3REyTMDWOno7w4OdPBRVM/Oz9wWYgLIPTbeV1QmF5Jyk
 0XFENYuN8fmnsFffLrBXTMq6HAdVs2Lbajo5+L4zmGA1gkzlBXbpJG4PfOZ4qvn5Dzkiz1bYbAi
 WhhbeCup3Wjv2LGWY29sPJ/DcWceGwtlfpR+YONXd/b+VJZPR8MWAcVAk3XUQhmSKRHGr9a1xio
 cjWa6Tna348T5l5OKzZxmniidC1Yh+x2ghDuPw2lMyxLGjOvJ5AUSug5VwWHTJ8B51CTGopnW3d
 LaXtTuSEcD4p0/4HQakYfNJBjLug119/pRyALfhYvDz6mYPFLtIJmSV575neg1OhS3UbJjWI9bH
 XDzc93hsgAH9PEOYfSq2DZ4JNvOMOHACzCBdlTWr1lATj2uvnXmMVcFq3MPOVxVVO/gG7RRLbfk
 nJYOGikMz8NZ2gstjBPkWZsVrN4Acir72RBvpbfHv6qTXZgNMwsuIAKfm3krzGCEr7m3Hpgo6+x
 UQeOjkoq02yqNvmFTs4O0hPchVA7rla9sswrJS/qIKIhUyksF6QnOdLtx9Hjpy72ukV2PSBbvEc
 +Fb8UzdjoLFkzjp5Jt/h9BYeap/rzovKPbTyRpCiZzKuxJLoqfEkRkFydZRrjBlqjJjU2Ct9ZNg 8N/gEflH+HHezNA==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-5-229b48657bab@google.com>
Subject: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7073D2000D
X-Stat-Signature: nmodak5toyy9uyr3b8zdrmq6jf9cyt8r
X-Rspam-User: 
X-HE-Tag: 1755599698-176227
X-HE-Meta: U2FsdGVkX1/DEMJEuiY+ag138U2hFQ8Fqc5HlIqjOofSQNIKn2FHpPdI7hZSR5/r7FuUFIRHOIMNyjkllg8yex45EZrr18MH6pwO2/uQIEC6GHSWhYujrrqLTobGm87kwP4r4btOPHuP3XP7nPnw8lExGCebPIExQln0UzquIvy4AEzN/Qt1U4aGsIWhpBVYmRtzQjKO+VyHvtf6rZR0+bi7q5PNA+/4DjbvvCjN6uw70v0bqfijWDXnYk0DfWB8ZP6VvvVj1dkDwvKVyiHtRUhk/eqxsysxFDPjrCOas3tDL9w1tdEspBwowDFswJin0QgBazysKNgQK+uww2rGHfLBk1E/BsrphjUfyBbLuYhYM4kLWQZU7G0D0M0dRYBLj/K5zfsz3GMlatvEgKedlA4G6EogPJ2YYxCuPJAly6RK6/4zckEJp5ZERs8BJZ4RuvOk3gs+K8nOZThQiERERjb7nu5/f8oWP/TQkw3G72vkwWrgEwWByCL//dNfHuGLXf76J2PJG3Fkkk7MX18/kM7u/IDjA2PgD4S+6wfc3zGo5L3oA94wqamorBX7QqQb0koeec01KAC69TxAQuB0ISo2setE91QBIdSKUQnteLoIRJES1JQd3P21k+ZLbMPbFRSGZEE/lg/UxMUXunyMgPpfB+UP09znd4dHj3WNWftGqCRz4LOYOmW70Yl6GOUjc1poyWJvNDF/N7zinqSaVZPkX892jD0rMg8g9rIHUSYAaiTHvkkmC6qxOTBCGdqFsG+eWXx6rXlj9HKJj81t9qIIL+7KxkqwactNLjsP+K+J7oHwdwJeJpyvRB/U1B1mYJD8oS8WxiqwAVEBcZYvaTGuiteQq1SUZ+OzFAR1ZjsiusXjSiRQS83hjpu4dLfxLv7vqirPX/bJCHig1puDGiI/N/4bPhKKfie5d5UytbCZ3lleOrAgSKnAI0tKjO2tBi+2NMy9WiYU2xGNGxr
 xiPXoiZe
 s/mVFz682u2y0fNtt+OkTljuYwNiR/NqD0+8Tgb5Dy2/T2EznC0wtqtPnl/U6Ry/g5flCnKtI8ItZAsTL+g+kb1Vz+J8ypbr7QXo+qXS3x838Nv6ehXmJWkSt2jiy9hd43kEJJF6/ULdRuFZUAutcpygSZLsD37M9vB6edwPIIXcEP8D1T/jgFSfmxwiGJ+2PWmU+xxYdkLofZgV+esE19Y24NDo9buZufm32+S7EVRTJ9jRgBc0tHQGu1gk2Fnc0JrNjluEGfavvqalwR0lDNn3jXO/ZI8XziXJYrIqxmAnOXdUTmYxnEBsEwJtYMtjlaaHPzw4W9siuAJmnbP9mxjEWIKGrCbOlW4+gSKYUBWTjMV4CtlG4Rxjy/O4bQShg3phR0gVaL9A4mGz3ZJ7p9Myy0nMAPNMznJS/SfpXfcJELcqt05etpTlFrXM+rdBljL6ZeTLU6HwyxXhnq9kquWF8RP4MePmR+Nkq9JkM6GJbFiErioxRhx7la9VMwBq0Wz5vr5uUz3kor6C7dwURuYYpGeOVhcsstR3HkLojCB2xsSli2yVDyufFdv4m4+3JANjsfmWVP5n21Rz7i8NF0e+4WOU37w/etsDC0azdNqU8vIGEH9BYIs0lz8mwWR/JA4/99Dc0UmdgaZwtGfPKzhHJC/+ae4N+/syVvaIOy2Cz7ORltwSoZkJ8qFAmZQ/ArlTZQoe0Uu0DsfhT6WvukZoGHwF5H6kNymms925zgx7u313t1xlsEfzXV0UyyaK4rBZuHjabzx+GTYlctr2eGvy6pKQU4dMX/s3Pw+rxvRHjJsHZeCCcRQmCaNJXS46CJyYJ8EJYNgM2cMttbz0UOTI570mQTClL5jXVD6fxLxOW4VfzW3PT8lz22Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to and just below the existing MAPLE TREE entry.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let me
know if you want anything changed. There are also a few other options,
for example, I could just add the files under the existing MAPLE TREE
entry? The get_maintainers script should still send any relevant patches
my way because they also match the RUST entry that has a wildcard on the
rust/ directory.

Which tree does maple tree patches usually land through?

Andrew Ballance: You mentioned being interested in being listed here as
well?
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 26053163fe5aed2fc4b4e39d47062c93b873ac13..4a52d884e36eafe1c819227207123c51caf02ee5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14674,6 +14674,16 @@ F:	lib/test_maple_tree.c
 F:	tools/testing/radix-tree/maple.c
 F:	tools/testing/shared/linux/maple_tree.h
 
+MAPLE TREE [RUST]
+M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+M:	Alice Ryhl <aliceryhl@google.com>
+L:	maple-tree@lists.infradead.org
+L:	linux-mm@kvack.org
+L:	rust-for-linux@vger.kernel.org
+S:	Supported
+F:	rust/helpers/maple_tree.c
+F:	rust/kernel/maple_tree.rs
+
 MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
 M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
 L:	linux-mips@vger.kernel.org

-- 
2.51.0.rc1.167.g924127e9c0-goog


