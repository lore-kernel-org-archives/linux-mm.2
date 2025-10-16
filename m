Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97688CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95338E000E; Thu, 16 Oct 2025 02:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45398E0002; Thu, 16 Oct 2025 02:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D158E000E; Thu, 16 Oct 2025 02:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC7038E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:39:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FD1C1A020A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:39:59 +0000 (UTC)
X-FDA: 84003027318.13.5D79551
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72071A0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:39:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BC+wWOdD;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760596797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QTTIy9g1iNjp7kgSKLGx+esxC1+Y8L6sCLUnwXUSZcg=;
	b=SoUoDjKH1jrWslVb5QQe2R+1m6oTExSugOf8codZJUq96P/KO0M/yGX6mmFVUAqu9DhHT7
	lJ2s66uo1uNNg3HNXWxvC96e/hJm6b+UJ6hL01Prh7h82M1vHiVetBnLNxbAvWcgSMR5sg
	pxpZ8LWt4UHK360efmeQ2teI6Ct4pzA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BC+wWOdD;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760596797; a=rsa-sha256;
	cv=none;
	b=19IeoVGaagZf3EeqpE7JXPe8rnpMAh2aptcb9cq5yRSRs53jzAU3DfTYTzpFCxhDeLuJD3
	bY/jKeXf2j27nZR3PRZabi7V8WvU+bQoPExNabyZ0VtiFznXcu7Hj49NL9PaHhDsA0uKOy
	uJLjx6Um/EfsC56Ilh98at5NlvXp2W4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b57d93ae3b0so233585a12.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 23:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760596796; x=1761201596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTTIy9g1iNjp7kgSKLGx+esxC1+Y8L6sCLUnwXUSZcg=;
        b=BC+wWOdDkmzSwyTSHFDXDi3L8Jvax3xZoRQXARJ2gMZG38oEWlsBRXF0dk1j2IKhSD
         032oknEJFCXGVwsLZAn9lwmnBIt5Rsy/fF4wRdXJY11dC0M4GBBkODyhfP4SPLn4VJrk
         fVZor0SSBTZaaSjBb7Bxi0Z/ZMjrfJfozX7djhYusbCVMNVniwtlhX+bQbRqvnQDf/sC
         M/7/CMscktbmINOh6T9g8kNIOyABkiEKbNF2vPnJLdq5lJ7PBD85RkwgG5CHw7UluTwT
         EJTTZX5JUOk+XSfDtjkV/HhuoC1kcSmJuWhK28ktLCHeyR6NlqrdlU7mWY8DMWpA6Qi9
         cMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760596796; x=1761201596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTTIy9g1iNjp7kgSKLGx+esxC1+Y8L6sCLUnwXUSZcg=;
        b=VSpqWLbwWMuM8XLk5CyahqL52FnL5A/NwPtYa4LfEBVZDD7WrFL94wNpYmsjKZjoy5
         pd4SbgiyMLO+H6PgpRpCqdOMvKNt1CgbI1WPEx19qWMJrnHNW+clqy8pT3XIbIE/IAHt
         igB2OYeR0+igkFkSEJaznMd9JJWJcAwzkWq6haQ8Qv7ejsc8PvbvkFAjq88NifsaW2ws
         3FwLcX5riHSn84YjviSlYeF3vxqIMT12hvNauNf9j+nTHyAv+F3FaOmjaUkbVvtuepNm
         y1/lY9gwY7u1TnZ/V270eFaexCb/zvE76ehOrxBVdLFShSUpGOAKxyj9prtSFI6/f2Ct
         /KXQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0FQL07tquC9UGh6qPQPkJweZ4OQBKa2DRWh1UFiPX8tfjA2k4+cewntn8wz+OR2cg6bHk6QuDfg==@kvack.org
X-Gm-Message-State: AOJu0YzMjNMchZxhdZucwwRcRHkAiT55p/nIJzGUlxf07XoLd8L6QSFc
	+N0AKIvRjzTNClDNm91YmSp1wrnaAP2SDrH5VkX+6FBkOQGZ4dFkAsC7
X-Gm-Gg: ASbGncsOOu+V+4QclUwqhQZCLKeRP7XLj1Im/cmBy187GOxYJk+SiMpyZfrIMQFiMn3
	o5fehLmK20NHBhPe+NcIE5qGUZwcKzOCpFDT5C2KVh+m4daMw2elGUl4WQuQqb9YoyO8JvWbrWq
	HG9UhS3D59WyXXj8PdfXKdktJ1WpkvgFVWtQ/76ATtwTIUPm7eMustaR3XINjNtBeQwdPVW++na
	naFGBm0dy81UhXF/xfdeTwP60IOQ19jhMyGGwGbs6xd+JNxzu+nFKOc8IPsAhX3W8oLU9g8FpLh
	fbzbxPaCqAdiLcqRBHpkO02b8D57AdkEnmhohpxBDB16Kh4h7kayiMj1gY6X54RVM2RFSp35HUh
	WChwKYUkVIuStzwJ/WfobyKoIfIAVKp+ydTQ39HvBjkgrF8rTOb/hvWhYxaRP0asYf4FjpSBT9n
	YkUHQZnY22JqIMBHCv82dwnFLnVxoD4K/TbH8ixfEnLPoUPkHHsZI=
X-Google-Smtp-Source: AGHT+IEhr/L8VPnGshJjxBj/9WCDm+DJHt+7rzQ5CfHD82xuLdTCKq57B2ez0nIcu0jWqSHeyGzjOQ==
X-Received: by 2002:a17:902:dac6:b0:290:ac36:2ecd with SMTP id d9443c01a7336-290ac36323emr16169675ad.14.1760596796060;
        Wed, 15 Oct 2025 23:39:56 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1d64:636e:f4f7:9293:7b0c:3078])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29099b0215esm17555295ad.112.2025.10.15.23.39.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 23:39:55 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH bpf-next 1/2] bpf: mark mm->owner as __safe_rcu_or_null
Date: Thu, 16 Oct 2025 14:39:28 +0800
Message-Id: <20251016063929.13830-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251016063929.13830-1-laoar.shao@gmail.com>
References: <20251016063929.13830-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 72071A0006
X-Stat-Signature: q8ed6qxib3j6fcc6uhcg9858tgrmm35s
X-Rspam-User: 
X-HE-Tag: 1760596797-327550
X-HE-Meta: U2FsdGVkX19kttj5f0Awdvccd/kTO8eEYWNgoxQj9PWP11ni9GKSigOoIzGFzu+3XCiPtifYc/v6wob69M+zWToPLK/jsrSei0Bn9Z4uisTfEMoan13gfLTpQjME95PhBYUPFkwIJlNuJXmfYfxdkCZ/oxXCnoHawnST14jaAubPYT0gUwQS/lrZ126sf/2RDXrc1I7Lv3dlR3kgegYl1hKH6ZExrMWzbuAn4EjnYoYDvdiMwkTYlvX/M2iPeX0Un7woP3IogM3Tey4n/6dtELTBthNAiDwlIcHGERNX+Wn6vJlgNtEXr2DHpyKhZzsTOBdSHqI9sL/YG2d813/ANB+ghpV3HWcC9ovFfD3TMoeioMoCLqpS+wjam0I4b6JBGk+yycqzAinzNEiwmOe8gYs3wJ4ElGolPcwRBBvashLHRfgNJ73QnfFNoYJOVqDziGMU60b4ZOv7B+faeOkH+FkWrkYaRMZW7PiTDDMhIbmssJfebfRXQ5K/Fu/oxqOyhwnfY6XsVt1kifxggkUhWtsOn/620RtNXj70cHEHDjuCyCjEXUdai3G9SBC4pzYgSKq9rciogJBvLK+NZzMDEnK7ee+QW1GxeHXvl0TAvzr4/m+GJn5hmCM6x1pJoWQYq+AXQZrqxauSsvYWDLMJxlBOXhmjP3Lndw+8NvhI5S3ip/YiAC5J2GW4jd3g9UBFzq45MssvFUDf8oIecuPZTR5LpujAOxnIRdNL1+x81mwHrKcijaYxi2qfQ8eP+tYz2YGQvHX8FrI+N1GGdu8BcrDeC0mkmro+iBordMkfBPkBC0LyoLxxNKJXQ9Ozm4LBwTvkXQmRzhhcL4nMjK9Nmz/DxwQ7cSC5k79QcxefdOqg3zBacoG1sCr7nX+3RHEnvCqMqPmp6EzmmpKXrS82vkrrDmXUGyvHLWdyBc8S7XW0KK0r2K3WAA3mqMKgBL5zUt2IGEu3YBS1aV8OIE6
 4ockBwRn
 oENCBl/jYiw269kmrpxobooA/XURSjm1SZBRvhVoCX/w/JroBSYfBr1jNlNGDdz71fJ8Rdc0+0U8GiPwqFl3XqYru2CZdhgfjo4b5CXtbxCNwfttR9To9+sHFZIEMHWpprQ/mR7VvPL7iW3qfbDJix5B28Yu151ICwDpLvY53454PWMglBZ4DcZlDyhrcGLKka21vT10NivxdWhRuYS5OBejNHRO55MeUBuZMrxTvoTmgxkfRKaV/gSVe7ZhhCFdQrtEJm3BThud3iKCOLysw8Mpu9dY4ZUvgfjKiZVVzCqyUKq/ng+p5sht02oaSVVxLvDaOUsBu6G36eJ2oZEJdc9pP+o8kGGtHBp4uMwLUM9j4QPmT+Hf3mtE7QpBxleJ7JwNMMgr6RUORxZPws9B+Li7d3IqfT5/k6fq1kuLRBDcWNO3qt1HK/scbx45jJYE97zSVgIdW8jKqTgfYss3gAVjzXF9w8BuZq95xbQxswVdAnZm0gfPVdAtXuISpc26NLO/In+I1jbnBBuirYGsj2XiS5lOIPEqobYtmUthGxOuVc8YNmY/Kpid8bhbxazwVhrG+Q+HfHJWU9YfPpd2G4FlK9zk3vD+J7xnDhzHt4lF23vHHHK14otS/UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEMCG is enabled, we can access mm->owner under RCU. The
owner can be NULL. With this change, BPF helpers can safely access
mm->owner to retrieve the associated task from the mm. We can then make
policy decision based on the task attribute.

The typical use case is as follows,

  bpf_rcu_read_lock(); // rcu lock must be held for rcu trusted field
  @owner = @mm->owner; // mm_struct::owner is rcu trusted or null
  if (!@owner)
      goto out;

  /* Do something based on the task attribute */

out:
  bpf_rcu_read_unlock();

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c908015b2d34..d0adf5600c4d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7054,6 +7054,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
 /* RCU trusted: these fields are trusted in RCU CS and can be NULL */
 BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
 	struct file __rcu *exe_file;
+#ifdef CONFIG_MEMCG
+	struct task_struct __rcu *owner;
+#endif
 };
 
 /* skb->sk, req->sk are not RCU protected, but we mark them as such
-- 
2.47.3


