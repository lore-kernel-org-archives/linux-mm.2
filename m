Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E702EC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C8C6B0088; Fri,  4 Sep 2026 06:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDEB6B008A; Fri,  4 Sep 2026 06:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEE66B008C; Fri,  4 Sep 2026 06:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F64B6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:43:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5F351140716
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:43:03 +0000 (UTC)
X-FDA: 85175742246.30.4D39EAC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id ABB47100002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:43:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JLF1jhWO;
	spf=pass (imf14.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518581;
	b=XoDaCHS/irai1Agn4LzZxSiE3+vws2n+j7r0Fjg0Lm5Aqa27vMPvQGAqyuzzYoE0ZuMkPL
	srGTCYR4yutDY4GOQx+6l4VXmbuCXvtYVL1Mbfqw+44RQOd18upK2dJSS451D1qckAf+MF
	JfiUyN1LSlxhriZzDXNoSEagV7WKvS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4a4L7BNv+LxG4ZtAuwYin4s42kbMGqQiy86Ml9znP8k=;
	b=4+9hFguXQ5CFA1bfEKv0QV0N3ip2hn67S4PzGP3EBVV3PxKoxcYsY1Va6r80lTNxLNR/0Q
	KL4W6ourk6ZSFR/ftXuoPGVurD0Qn0MLfuM22UOS8Iv/R4dhfWNibi9t3kNM/A/jcFtxkr
	RoeiRvdlfdtZ4WVKelW1kXuHysA0XUs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JLF1jhWO;
	spf=pass (imf14.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso673020a91.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 03:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518580; x=1789123380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4a4L7BNv+LxG4ZtAuwYin4s42kbMGqQiy86Ml9znP8k=;
        b=JLF1jhWO6mMHk089RL4mMcxW8usgPRadwr+rfDfqFMiIcw7YJXNn9H5W6N67SUObB1
         RLtVrAk3Lf7aW8IH8bmaokp3yJNDXfKb8Cl+WsS1OSXORrRmCC8k1gO4VolNGfSXPXPc
         2Uk3RVAUnzGt8y/l3rVrPcgG8WgMaQSrnNHvmne0pZ10/r6jcnN4r9q01UY4ZnCQArKY
         HcS57HeslMLSRCXFHdfmNWcssCWhan00gkJJxXf+oVdwV97zKRR3Vuao1tRzNWjrISw2
         CrLeweWci95VqcIppvnWKPYE3qrU9mR/AeYbG2mJxImperWhBadyz6dDuKgrt1BawADj
         3v2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518580; x=1789123380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4a4L7BNv+LxG4ZtAuwYin4s42kbMGqQiy86Ml9znP8k=;
        b=Rkr9ZCS7JaNpmHbINxLCGY2I5XCBGVfvwwOCHV6UKn6DyHT5g2+yg0X+T/aaifstUP
         igHaYqlzy7PBrk+nJbpw2YSmjzCOINznkbos/QXpGwlEQMac1E5ALeLBZa8Y1KRyMpXy
         bzCCMoH7P/RDth/G465XT9uSmFQl72FNYkUtvV4juoPxMxTKS9mYIQ7JaDsTotfREEEB
         4/gd3CYQpHuLTU4mZLDtrQ7N/POiHncO3em+/ifmJcHYz+YEYy9JsvZVvVHkPRMnQHw3
         sEzhgDIc4nKQfUnuh6V/50o1eaVkKEWHcT4AjHD96jJcVgYjB+e7gqOqXMgtlNUjM043
         /+6g==
X-Forwarded-Encrypted: i=1; AKwUvBwnNiDcTB8diPRqkEoH/3P8jHLGXmWtokzgV89aaCeuMQtB8tKl4UKOAJLuNOGzWegmH6VD8QQmSg==@kvack.org
X-Gm-Message-State: AFuF++m4Ikyn2kgdjf7uS0q7B/WUY5bgnj50EtOwcdxCHaVHOTeEQiud
	TFSRDqP7vCw4SdRTtzEzwU+H3wsDzPLnhbIRbKxelKtLoPPSF3QBsRJwUoumq3vE
X-Gm-Gg: AYBFou0y8yZocDwayLVf1L004ZTOkj02jhR82QOPEC5j3iuIkNojNayPzoZNGHOr8XC
	L6c4HOHG1tkpaPhewahJnIq/bUwuw8N9BDFvBwss+sU5dZDm3Rp4DanfHHVQlK9eqzMC7MyknSd
	ME6z6BXF59WnVbpUTyzFWq9R/1hBstsvmmGpSCYnXkYIkEaDWZDoeCxLzSa1+s9MosaTjF+bARO
	z1jbkXqWfVRe0TSnnHfe+r9aaq+9s2Ob9r2i3FUNcD8C0v7w0HXBuGO0ArVFvO1FO1MCmiiSQgz
	vNTGTWHhmLaXFFuGZbSNS64TCcaCXidiSJHm0/8M0r+h3rr2MseQvpNwRj40sawti+/tB1wniZv
	AsoWCID1hPArqbcXnVSqNittJyWgzS0jdEPiqIpeFJWQFD7Xf2g/VSvH6naTRbAGkXEft9m3DKX
	Tjuzg3KhfRazqACgjop0+DYeHQ3Qujl/kIh0oBFfx0k86bSAg5mYZ++GI9D1oqr50zUs3hRHyd5
	UDA/iIdpYaoFs8DwgEzk8RylLY=
X-Received: by 2002:a17:90b:4cce:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39b260dd4e9mr8682700a91.2.1788518580475;
        Fri, 04 Sep 2026 03:43:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b314cfcsm5981759eec.19.2026.09.04.03.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:43:00 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] memcg: fix typo "memroy" in comment
Date: Fri,  4 Sep 2026 16:12:53 +0530
Message-ID: <20260904104254.16103-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ABB47100002
X-Stat-Signature: bwxmgqryyquzn19y57q4wop6fi3q8i3o
X-HE-Tag: 1788518581-276100
X-HE-Meta: U2FsdGVkX1+JPOsp+O7aG/MznyvsPicWTWR3yQD7o2MXBGHiCwawDbKz1zLtP0wTT2r8x5xFRO7k331DhNghyssdp2sP0qLLl06ZunmGVVmoDc/FTtvHsD22UYCvi50EkCIYYmyIofbFvnt1F58WKDDf6+RZcv6kj9orEcFHkGSk/m0SZKczlS1mYODHO2ZUr1Tb4Ze14EZqIVqYDFsKMqLFNEDxDjAiW+m0s216dCsqBO4gKywyEA3q0pgC9u/wbHr28GhJcz6RzdazGAWCY3Gn1wsEEJ9sgaNPCOJcIek0qaIiLzz/XpTa3PlF7YRmWm38Wxb7mkIHa05jPet288y80WtFSXepANbzxE/dbE6IafgJ6dyf/fMXuVH7+VQ/WUCU1OAqtyrdglyL6FHmF6MqJhkypLCHFgbaVeMQfKKWVGJ+zqF5cVtyR2Vy/wCTrWLwXExoOJW8HuMMkWc8m6jIhxJtjglnNPi9OxrtQFH75pMqwz15gcuxQu712MkFQShSZ6fNUSijGMsdadfYYXF30TfP2ie5zBrh7lhZNwKPgNt1t2HgRkZtmcjPE8MxkodtMQqMmV6AsXddoKR5p3D8pZANTrmX34MsdDdP+bEolNkalUJ+TJXsRQERzPrsE/Wh+ppPFDgadWhgom68IMCddQzw3tjjWiunX4pv36bfhtmqnGUbFIcz8xpDzpR/auY22P5auiIlpv2H4YeA3B90q5XcI+dPxqYS74YPYxwCV6KanMs3Bzis8Ocux0cOA+Dd3zaLxEB4cWRVwVQdYC9BSjpt5qGGj1hfG1wDh4SpBma8v/JluYkBOxjmfyTBJV12thXNeRimNnSC00we4LEXhXG2WYF+ZhPWKno0QYJbEol3b8yJjVbm+6owRWInw97g2v6pWh1v4/RN1p0VgjlhR2dESvzbDvhkP+/qWrKKFQhTcBDqk5g1SvHMtk2HosjEdZ5/I9YqJc0UoTR
 Lz7vKSvt
 raWU0pGpIcdhrIG06O73uUNQq3PDUkyOa6FCNMq2ns71kRIAN16bO/wrxP1rbqRCcmgiORFncS/JFZmwRWZK2MsBzuMq1qXtS0VjU9SYBKWIKVoYnb25yL1E7rxoCzk0W11YnPFclgFL6fq4Fan18rdKQTqqeKCe+HhiXpIeNKdBzUE7ol8nIsuQuSolQbp80j9PITh9klGAdZmEKUM2sseHdQSv3ITXL9Rpn2XAszGuT3HBFjJGWUsTTav8rGvN5ACsFI800DuB+7yN/bm9RcfPoYHlDsR8HXANUst/s1HT6HUu7AbYum90NB7sHJ54hObHiS5eJdMepxVuY5PNK3m14pJKgfZNP3asQdWw3u2YV7bcPlzWMPN3YDTGuGRi42EXdWPGAH2RgV5e1eveRQhgSkn5OcZqpDmH+c/pgCmpxJW2pwvT1wlLY7t1PyGQFcwMj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct "memroy" to "memory", reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 include/linux/memcontrol.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a8..488dafe54d77 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -258,7 +258,7 @@ struct mem_cgroup {
 	atomic_t		kmem_stat;
 #endif
 	/*
-	 * Hint of reclaim pressure for socket memroy management. Note
+	 * Hint of reclaim pressure for socket memory management. Note
 	 * that this indicator should NOT be used in legacy cgroup mode
 	 * where socket memory is accounted/charged separately.
 	 */
-- 
2.48.1


