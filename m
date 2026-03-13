Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF15106FD9B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 07:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB08C6B0005; Fri, 13 Mar 2026 03:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E726B0088; Fri, 13 Mar 2026 03:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FAC6B0089; Fri, 13 Mar 2026 03:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 879636B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:31:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E0081408B9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:31:40 +0000 (UTC)
X-FDA: 84540219960.17.C186E43
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F67E180005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:31:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlmGVkWk;
	spf=pass (imf24.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773387098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I1uzZX7sv7myV9mNqzucwtZS5S1busM0uO/n4issQkE=;
	b=hbMbtOF9bIVWUaNha21S3/8FWZ6NB8Gg8cPq5cEVu2wYhjEqmGYvwICW11sMk2FyYrRocQ
	wItsJd3qy0AJ8l2wYm1ZTXZBdWe5Clc1ac6QAh40HNPvhFk+o/sjvZIEpnYEVBS6RNcDZj
	f+whikawADvJmhE9u1gsxu3J4dHJM8I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LlmGVkWk;
	spf=pass (imf24.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773387098; a=rsa-sha256;
	cv=none;
	b=mpdKk8cbOZ2Dy3L0oQ8CwjJjPZK5g2kFwP8V/fIngVNXQ97OzJHDeTs9Xzp1oAm5o4B0qD
	uwIWLgiWtFBOsdPHAipyQpmVE6uVfOtWA1+JgjVEutMni/p+M1nOWfihaozwRWqermgt+Z
	k9NQweJNKUBUoFi/cAwQaWlA22R2sWk=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5a1322af04fso2251711e87.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773387096; x=1773991896; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I1uzZX7sv7myV9mNqzucwtZS5S1busM0uO/n4issQkE=;
        b=LlmGVkWk3ceYP09dsykV87Vwrcrv6v121y2jxHoezuluiu82Nbtx0dcPoqxiEFff7J
         tfHxF6ThWriKZdBUzmDAHfBA7nwFSEwowF3urvacJBIvgCz+nrUojjBhyrqaxU6CjOsk
         oXtJUBTM0ioB298unS8iqXXq8EPHIosEGqEmv1kkjdzRD6r0mLW4L+0d7y4WRiQeAp7m
         pOYSxn1b3GRn3seokM2NAkNAo7WR5JFJ+JRJoee3ryPGInialbC+KjK5ZUUi9VtUcWI+
         KuEusmgYXA7C+ZJcykY2esu0wlkGPJWqqHIYZ4WOzI0vyg5mPfYg/rITBOGmgrL+Yqx8
         4r8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773387096; x=1773991896;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I1uzZX7sv7myV9mNqzucwtZS5S1busM0uO/n4issQkE=;
        b=TlbR9Kgl35AQ/w+cptn/oAN4OEE5vKFHby8kDfXjSPyp6WaQ4zWCpasO9VvXAbZSE5
         y7+nFOPM8M2/oNrpsX++6w+x6ldwDZpMfLgjFM7tdIDtRnvrHruPzroax3PfYF6tTI5g
         sHqCjGr9/T6Y3O5eJ5Hs9qz+BU524vwiN0I3NgxeIpjOsY5hoILRXkWvEy151VblH+ig
         rHoICETmUAmXxkGOGjyoQsvtCZRoedf4z7+pRgWo3hsSuzKWNWxyaUVOFujFjrMnu0yW
         Y63Lpp+KDB1hcaRx1ZPtwtsZiYt3v6ReqSKNQnZfiacQbO/pliGCBg+Ig2m2zdqP1oAa
         KlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtkcMQWB73gjLLl0fVaSOJ3RUV+qIWkm/ircWAGTnyXmSIf7+4BD20Zdafn93yjMcJEHbPzYRtMw==@kvack.org
X-Gm-Message-State: AOJu0Yy6tvqPEoemRQH1Gbn4msxUtbRyrkx8I4Smv3gIwfnFgCX4BggT
	GBpgyouTnNUHAGrXEPo0p3fkO65ccN07fKJyasg6csBwkksXURbnuLY3
X-Gm-Gg: ATEYQzzxyNcBi0oV7G0ewU3aSynpSqWQBeLWzW1l5DzGw4v9W+3rGTHJaWajLYgcnQ2
	IMyWeRChKMzRTFVdVZVHmsyEqNgZXKpbtDpXuhnldQ04M2+GEHrPKb9evdrHwhzuGKFYHKupaF/
	BZ+VL9dUgx7YYyHSHYiuj18M6+857R62RHEYco68VNkzd4EupwMLeWlywuToZIR1lujG/F8gXtl
	Km8MDWfLYhsbajDtdPIQ4eWgheSl4YPF4xAejX3H5AAGAXPDBUoCheApgbGE4ddjgghfqsm7Q7V
	lwSM5CzhaK1KEiML/eYE6Nrp+MHneLVCpbY9qqkAnAxWP/bygqcLusMjdK8z64dvMB657lWUANL
	/YhQW6aTpYM4gpaSdKOv2anuZIoZFcbTww7dxvtv82QKr4Jnj4bx5vs9oV2ekL3U2WfMUDM53r4
	vpxY3a+hMfdZG3yT/hEFjs8AXu2TRSOBSHtMot3+pHPFjXI+xA9yiiCCFpgoJ1A/vdaBZqqk0mH
	AJGVoza2A==
X-Received: by 2002:a05:6512:24d5:b0:5a1:24b3:d6e5 with SMTP id 2adb3069b0e04-5a162707017mr612711e87.15.1773387096234;
        Fri, 13 Mar 2026 00:31:36 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a156162b08sm1329379e87.53.2026.03.13.00.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 00:31:34 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH v2] lib/maple_tree: fix potential NULL dereference in mas_pop_node()
Date: Fri, 13 Mar 2026 07:31:32 +0000
Message-Id: <20260313073132.159184-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F67E180005
X-Stat-Signature: 9dxwjw9utuxf396noin3jjj63tgb5utb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773387098-598762
X-HE-Meta: U2FsdGVkX19mU6DTGQF5p48hGSgXoLta/u2JOfN/cEg/ZFd2Z6D+oObb5poDQwNO1rcS+DHxdnIwybY0zYsmXbSGNeMsvv2bB5LEoXcccWN7NOl7OzaJHa63bafsai9LDOJTpsN/V1FxczED8NqRtwnU9e6A7u2SvU3/NBAYfOrh/GGn6WXW3VDCmx1uFQliDx/awYOnE7q462bCyMpgOeRSNNI0gJoWOkeufNhgcsyhDO8q+ftbTMPKUQ+6v7njZWC6V1wO6UJuoNxajyPshSXpbiKY5m9KdLZq/4Dg4KPvEmsN/q0HbQKHtEmReSJKj+za1XXVykrxcTJtMmfleNyXq1eMyX3rXmou1QNy7eYAN4ii6u6lEG4jKfvm2tbhna9WfhU+9AMYEdCw01Pk0YedtN/KlDPyqfTOGvsWq1G1a97OM9ZyrTphNrRvK7+2RHUNpD+/LPXjqCQSBkz2VFBTalHcwwveul5pXxcFeO2lkJrvvssDx0LjGVHNe8+Nzdgx38ZbWSZ8MGE5TWDp11wkzuG1XEhzX3jw5Zrgk3uAxLqwXH8Oa3s9vz9PzokEnV0wyTEDXHTARpL9LXSbnH+2lNoa1lWxtNgT5rzltEgnPJ1HBmzWQwfaDB3SBfNkDidaG1RhqLYUqtOPB0zTLEhMcV9VWZSZdH0nQbKvQNo+1tZLmiHgX++BZWkaBbA12uFGVIpf/T0PTkd/ccW5biFU0eEmes4O1bXsw7baek0GvjD9bA6XJUspjpB2O1J1rnkhrZORztW+eOBjG9lXqXXrJjlNt+tAPJaeio5o2rFILEtZzVg3yxcA9eQ/EwFE1K9pn0ksvRgjvZVQlycnhEShb2u4jlFYQd5tH5x1wY9bWYMJi+dFJ7qcTMz07k6moKRv1K6FIgUaJtwK3o17auvTOtg8rJ+gDs0LwidHmEsgOnm1Wy/Lghcx8iUCjXeTBUR3g9L53BsF1GP7YFz
 Qi8Xjnzi
 2JdVvc+ZNNtyKXnnLsJIuFIT2fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If kmem_cache_alloc_from_sheaf() returns NULL (possible under
GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).

Add a NULL check after the sheaf allocation to bail out early.

Signed-off-by: Josh Law <objecting@objecting.org>
---
v2: drop WARN_ON_ONCE — this is a recoverable allocation failure,
    not a state that warrants a warning splat.

 lib/maple_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 739918e859e5..1eaaa5f964e9 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
 		return NULL;

 	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
+	if (!ret)
+		return NULL;

 out:
 	memset(ret, 0, sizeof(*ret));
--
2.34.1

