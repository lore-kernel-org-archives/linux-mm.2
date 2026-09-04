Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A975CC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD46E6B00AA; Fri,  4 Sep 2026 06:49:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84F06B00AB; Fri,  4 Sep 2026 06:49:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74416B00AC; Fri,  4 Sep 2026 06:49:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88AB56B00AA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:49:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C90F160840
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:13 +0000 (UTC)
X-FDA: 85175757786.27.9DE3A33
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4E7C920003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:49:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmkPIFMJ;
	spf=pass (imf03.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I08m2HnQ/PSHt9c8bjpjQoWnw8928pNE4cB9PyVP9mc=;
	b=wdz8Q75RYMTFYP7U4iY1Dfvb2okjSACXLAIlBHEiv0bu0vmdYwsMU7EF7ocO+7/UPq49ef
	qVGGx8sWy6HSJM9kQflvAenuxKuh1duP4Ltex3kAgm6fz3OuflPs7eossTa4hp3G00iAQG
	AGX9irUEq6Bt1+1jQepduccesaDVIy4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518951;
	b=ie0VYOkmgS7NBRN520DCFrODNMXWwnU2cOifV0tq5i8V1i4FeEM9HQtBzrvfIzj5zGNaB1
	2tqhfO/1SsfRsI1XUN6H8Nea6kClq2JF31RaTRxKfkN5+aCmOJZEgitU19xdqJ87GvHPRW
	ZVTgBbSEEMSMsbPb3t/8kY/2qIq8Scc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GmkPIFMJ;
	spf=pass (imf03.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d6e954afbdso5619225ad.2
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518950; x=1789123750; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I08m2HnQ/PSHt9c8bjpjQoWnw8928pNE4cB9PyVP9mc=;
        b=GmkPIFMJH1EA1y8J1aSGskXW1cqVGoBzzjWUkrtlIsdh2/njGVDDEfi2ZwLHI+lQ5B
         aAZPsFLdZfF6LLpg694OaUxQSb1JHEiAOvtCH0eaC8sy0O2FbMtkQYYaxb64WdNF95gz
         OeUvy1AydgP08ZvOadkrDfpSxuBDgi1TOtIPltmiH95RbZDrwh4e6oMv22MscQMR9MKn
         ETJQu+6Vxj9UbbUMCia8mczKocKC1OfUicpT5t+lNVdrm2OFsopsNQrGT+oc0BH8Ba58
         uJlfSNG3TEh6ptdfXn2g0GGtYXu0vqzfkOv/TT/HmA0mCkN3hBdcrg+o303S4WvYfJki
         47XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518950; x=1789123750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I08m2HnQ/PSHt9c8bjpjQoWnw8928pNE4cB9PyVP9mc=;
        b=YbhJHeN26mba6xPqMlcLTPinvDbEezLT946Qjjm9ZMgBtth8jYZTWPk9P8mu3C8g/I
         VKnN6uOZBP6p7pLnQ6JduCclnpSVSHTCvmbM1txNaikgqtCs8kf8IcE5vF81AxIPBXHF
         zAg3qMcC7yE073wB+us8/M3LWg1swgoUH7VgtNDXByQQam9sC4A8rKJDw8LOeCFxrwwF
         C1q1NmCuFz44nsGzYZj3j10KD7KTTIrJ7MauIoZHW8y8cSeKX7dtoaUIAzhvbnlEArwj
         M+fbhv75Xo2wL4M2YGoSz6j6iVEiQuXH7FHy+3WFVKwe5wB4He2eX9hEnRdl6BRWIN++
         b3AA==
X-Forwarded-Encrypted: i=1; AKwUvBxbD1+6bO87mfNjIO5XhRoZkL9cxZr4VMa9We4ne2S8pZfcwgnOdW6Jchdp4vlc4dxv3UMxievnXA==@kvack.org
X-Gm-Message-State: AFuF++m16M3Dr5uApibLwlZ3bnMvrRQVASvv0yGVWXB/Xf558RFDF5Kl
	01IcCb0Nj4VAwhbGqwlLGbYzI4D+Ni7gEXiXkmpfGJ1rYe/HgM5/RHRa
X-Gm-Gg: AYBFou2yD61/Q7nbo90R++nOQqVWYiU94pueziMAVIXkE2blQjDHWWwAAFENo0dCsQY
	j3eethXnSR8jg34hJKnonv57E3Z8vDs23cMJeyUYREqtrd5A3HrOOwlF2WZfyUt43uF5+V12kYW
	d8KhdNfrWjc/BN9WpOthyB134B1CQ1cDgqmqa7kiV+dV4tSijCaiI/GvRz6LM0SSrdHxcj7kEuz
	Bqlg73A20Wr3eQaWp0MSb6I2jMzyjdMTNYR19mAh/uUhRBEt/iUDbCZWldFM+dbMPA0o8wcITjA
	SlPGnWIOxfZ4ZpCs7RbsKdlGEbjbfUy2vYWFLVAUH4Wms9aXT0BDPZlJcznIqzmbuUQ1nKKF/A5
	1kuIBYPiurjvprCEuwN4qeMgGBTOp+FLWUPD+dCKzI865wFCqWqaoxcOPv3xa8dgScycvAHCbi0
	yc/mn8udKMFxh/M94vOHNjsEKkHMeueNCmpPf7RMBzQ9tPTUcjTsPB0r5gN+vSdEFSn4sJ/0ZGn
	ifrSmCdgFhcMRc=
X-Received: by 2002:a17:903:2c9:b0:2c9:e846:a57e with SMTP id d9443c01a7336-2db12147668mr83223635ad.0.1788518950171;
        Fri, 04 Sep 2026 03:49:10 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm8583927eec.16.2026.09.04.03.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:49:09 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] char: fix typo "funcion" in comment
Date: Fri,  4 Sep 2026 16:18:47 +0530
Message-ID: <20260904104854.25272-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904104854.25272-1-hemanth.selam@gmail.com>
References: <20260904104854.25272-1-hemanth.selam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E7C920003
X-Stat-Signature: dk9nr7ua5b4684cto4aryapumfamfa5f
X-HE-Tag: 1788518951-917891
X-HE-Meta: U2FsdGVkX1+wC/J+5vKk9Z6JhqViA2MtFdWg84M25pa65ritBjTTg3LD43tz5Wwp05kQAft5D74kTz6DttznGTIpkgoCAwxg3eZpwwxb6XEdhHbmSfoM/UzhJ63fYv1dxCqrqN9L8noP4lImx7sxXz0nQfr6OzkOaOO06LM5pq0YSVIzteB47Lh+b+Z7aqCPZ8AEe0YleBNg1QNQM2o6H1xywELSdIZzdHIG7W3VD+E/EbpbNOOE/VqAYA2Ob6SLEfhvHSbb/qq60Ytma+oUDQiKWFSA97tAUwrDn/KHYLKQsmVaWFgwdl5/GjQcDDcJwQ491nv3Q1P3OF90WVebstrfzNws9UlehTpeEjIVzXTHK2SJ7vGbEUQJDaXO9WZ8sttZ7877d+kggrT2NuIbho0/41FmDvosJjyrZOvuBCZu7YtoyK8Ej4MNJJJhkkvOvO9Oj5HFrPqZL3LiuIQk2tKSWENcDoQy8hS8y8tHalA8YR9WYGrNhhijtwbR6A5dfkq2SctXbR9HYJbZJqIu6pLbTaAhzcNLMFNzsaU2W2L9Bd3ph1SiM+mHKNGuLMNBkvK5zeVuWH7jFMY8uFclAAUftiKIJ9tjhjFhLAs1SDHm826dEMdx7XWIg5BI7y25WFiLv6+TX1Vl1tpcYU0QIQ4zOW3xmkZ5KXOhZGPP6K8jCliFuDWhOYlr+WbaTG5sI245eb4nrHKVR2bj4Tf6/o83a7S7fM2ZykWMK4wwgkFV+XRnskb273nDT5jSoSukxlQffmxKZdbv7xC/KovJXj//Ic5AkmWRCTSP1oPj3FGThDurtJWfIPhB3oUoqdVSqE+wnIjGh9o5wXvq/5GKXNdHWtGaECSRIG7Je6AaI2LnnO4smsP+lKCnk3Z/TlsSx3411VfoieLCKNAaykQpc3bbwpuclGUZVKHzyHZvf/THG+luL+ipEKxu4BIe4NKHk+ojE4L1+IDjV6zUNQx
 4dv4UZF3
 jMpGRATNbo4zGROqoSdJsdxpEm34w5s3l5EFc2W49VzW1Mrm4n+1Hg49SxAS3kzeDaL8AhjwumuTyLh0jrEMc43P32R2e5arGKRLhzG9Ab1IfkzYJImbZezp5NdEx8Smps2K2c0WBakZMEd50rPh01MmC4PS5VVlsWgB0Qn9K4YDvtHuJahW2XYUD1w9/0DqByLfv1h4uUvqpbLezTDjjSWBvaGvglsqU9NCwFcPr14/9pCOgYqCErC7tkYR3ZOWwELcm5cT6/CblCrG8iMIPklXiei7ffuwTNCIIh/uozCr0ozToBPmScJvRBtwi5ra4ZUmeHGRLpe6ynWbLIAfStcK/iMy3SD/rD3to31YxACZMcHhLrRtW2pKIT8OPAGH+RMUtN9fEI4qBlwvjAF90TVUymJUjrCISe0/HEYFqOoWPVWpmeXHYMgvDmKh3PTQoORGn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "funcion" to "function", reported by scripts/checkpatch.pl using
the misspelling list in scripts/spelling.txt.  Only touches comments, no
code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/char/mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d7..f9db486d7029 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -76,7 +76,7 @@ static inline bool should_stop_iteration(void)
 }
 
 /*
- * This funcion reads the *physical* memory. The f_pos points directly to the
+ * This function reads the *physical* memory. The f_pos points directly to the
  * memory location.
  */
 static ssize_t read_mem(struct file *file, char __user *buf,
-- 
2.48.1


