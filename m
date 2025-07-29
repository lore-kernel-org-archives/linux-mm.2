Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A287BC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 09:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E156B0092; Tue, 29 Jul 2025 05:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404AC6B0093; Tue, 29 Jul 2025 05:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B266B0096; Tue, 29 Jul 2025 05:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21D046B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:18:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B48259709
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:57 +0000 (UTC)
X-FDA: 83716752714.13.4BD42D5
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id BF5B5C0006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:18:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XLtx9Ggo;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753780735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHc/ChzXX4pKy3XoznGpzP7XumeUqYKz1lD0ZucY3MQ=;
	b=h2IIjnNWBk/9c09Lf/edu/kztYRifE/rRgidTwGG3KKWMiMiZ6s8ErhlPGHVK8ji+IaVDA
	ySyMdNjCaThr40xMeFvi9u3RFUMT2gzGkOzb2aaWuPduDV8XtikD07v6ZdHP8u4ct7dxBK
	qWNo3cqhOWQJYaxTa3nZ94wStzM72jQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753780735; a=rsa-sha256;
	cv=none;
	b=RYZmPzNPli+KE/17ncpY09fNDwt4Ct/kMMV+du1/IxNhGuDcFYyNA4ya8hx4ZezRq6HW/o
	Rw/cbybk33IA2x0W2NYUL61+OxviLZtQWppyKDFZxbRyNiH/JJFDl6uAlHX2UzaFmqg6Yi
	uVpyGep6HDyvemhVu4gPtY0MclLOWSY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XLtx9Ggo;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24009eeb2a7so18957255ad.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 02:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753780735; x=1754385535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHc/ChzXX4pKy3XoznGpzP7XumeUqYKz1lD0ZucY3MQ=;
        b=XLtx9GgoZFcO42V13Yj3T63Gd290UbrWFVeqkeUVvdjs8F7HrBaID00jSY3WJl0QTn
         reBAEiFaGAyra8a8pmnvrvt1T7c5cTifluTOkCNqi2VfMHBGXVrVv3FNgNHLMxl1PR75
         LDSo+L++qCh2mhkOl8CrkWRvv3/TS2VfEUjxt4b7sEJYGi0HyvO1+iFD86X5FoskPBu0
         wxDnu8qfvNtfnEG0JkWWZM6gWehKvAE7IULGjLG+Q05/8IjX3T8UhUMEDpsJXl8pyU8e
         4lu7NQjr5VMf8/bbakPyeUldFBZYw1/IoIRqpN/TJfOsIp4+k5ywjKax/BK437qXQuhQ
         ZUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753780735; x=1754385535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kHc/ChzXX4pKy3XoznGpzP7XumeUqYKz1lD0ZucY3MQ=;
        b=SiLk6ZKNuR6u/08TAw+775kSuccdpRa3wiLs1bSRHEqyomcmwnN6Ej5Ib62CotErXI
         nlTjZjk+DhY18CPpln5xV3ggwbALjl72tUmRfDu3+EBu6sdKgFYhMoOS3Xa3L6ZbLUsq
         4vDwKfAoZbaVs547fnZAvb8EwO3TMSPE5pNwTAc/DMsHkbb3hDHyjR0pUPd9vkVuBjFo
         dioFePxID/VTJp6Hda84RbfsFOCmAEwxcweknfx2bsmAcYol19S/rTm4OC0tnP7OY5QK
         nkry0U61XalUcLikY6POPiVkfCv3Xi0KADhJHgG6bqwv6yiiAEUyCTsXYWjan42lz4uj
         poKg==
X-Forwarded-Encrypted: i=1; AJvYcCXB+GjA0mS2aR1ks6R48YkodqrZ59+KGuqdqo3Y2zzTQG++C75NqBZ3s2nFzWw7Iez6iALR1d/UzA==@kvack.org
X-Gm-Message-State: AOJu0YyxhfQokqY+ZbR52lPF+8S/6S39XlOTClZ0dDQ1+bQugo/oNdFQ
	w/sBr5iJwPIz052LXqJlLHVnn1zueQmj5bKmWtTX6074+KdGTBDfpOLg
X-Gm-Gg: ASbGnctf2AkTy7vHzXmEjBNRYUaKhBotWeFP3eezLYsIKYIshR49jrGV5BAljVl4ouK
	npwmuyKUF3Y0UdeqFPd0VqBzRy2d3rW+Z3kQSarOKEjcDTehFxPm8zT/ilSC5sNkB+HretSOk+c
	AvU7sG2w20o0sXbYQcD4aKDwJd/GgHG9Qa2amwfHdHsDC7PqDJrJCP3qnv0dKo+WxzmYvcJdGEw
	3qxZpWnYK1ZNzzbh9cvBaDvdWUD2XReoc4FMha4MoPs5+u1MsMyqzKfeFCIqcA8kJHCb5GbYEaR
	XGjeHzZU7B112pCYxnUG2O/p2dlsfefAq3fxRGKs/aie++3DpO3AhGMYVsfKAx/UXUTGC6IqTrv
	4REC8TPOGbngRao4O0vAlvAdS6Q3y8gn6dhx6obluCYjcraeo
X-Google-Smtp-Source: AGHT+IEwNw6iWdRG92+MOtfdkpGPTDLwGGyBzjfG9IcNP6NgCSwLOpYypWU0d+qgja6a81bzLFBFKA==
X-Received: by 2002:a17:903:2345:b0:235:e1d6:4e22 with SMTP id d9443c01a7336-23fb3040f6cmr190837245ad.18.1753780734575;
        Tue, 29 Jul 2025 02:18:54 -0700 (PDT)
Received: from localhost.localdomain ([101.82.174.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30be01sm74337015ad.39.2025.07.29.02.18.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 02:18:53 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v4 3/4] mm: thp: add a new kfunc bpf_mm_get_task()
Date: Tue, 29 Jul 2025 17:18:06 +0800
Message-Id: <20250729091807.84310-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250729091807.84310-1-laoar.shao@gmail.com>
References: <20250729091807.84310-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF5B5C0006
X-Stat-Signature: qs9s7ehyd9mxszodgdw1mrmjqhbt9gzk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753780735-49853
X-HE-Meta: U2FsdGVkX19LHb3jVE0mxvM3mTZaG5PqSQ2lexpuNckFAwGHayqcU2ypKf5bwKbO3LBFafpvlRpaeKlY4279bdLfmbXSXRt+0yFGv2yqsrHWP1wLSlVYMgaBKu1UUQXRQG8WakjCP+Zqa7he1g1YET7AwnXFHgQyz4BviWwzg8SB9luAP69TklvFl/13DuEEcQtHM7Fb7pcH3WRJG+tc8yZS5Db/JZj+abQcnWvV/NW4cl4I7K755cjHcRatsqDpk9Bl4pt53ZbqX1rJ65H4AnQWhsbROyhIY4A26LTHM9FN0ay/SEDSxVjAOyW+KWMt7YesuWrYfrfg0hIm4txisp5OzEHJWF3cRD5Lo4gZ08eSkluzoEJsJrMy/Z4+twQxYeZT6DgpbwoSpKTTER7x3U7oRW44Prq635Eg/MRLCJ3WgLJHpGrElzA/cErCPnRmeQEJVzyUt/tEQG6RgMgxuxXYMUpQ7lHXv7h7EpVaOCZ6INyMO3HgBZHXfsx89BmcP3odhctETFNx5tHAkR23F1B7+HjEryYYP9/9UojJ+9qg+sd3MlfAInvWB1SXLb0yLLWTGlPyudUJRi3GarWbwWwdR+FM98zRuDUdKx+p5VlQpsk27O9FI5+VcNioiHHc1iSm07ScvannZjP/F0v4SA+LD2skNa97qRCpc7cDemk4rxpXpTBoy3Lb6Isw/fBqvcQYk1FXwSmcb2Mvgo3SVOM7bKhsdvJLhAsq/Oextux6scIxA2/t9NoRvSGGCyxebnEn6TdH5zKxsa42Sx5AoTuEPrpRiAr0i1MeXqnX52aI9peqvbsicDM3WfCPfxmN6r9+PK3ix20X6NaNRJ+qy0d9EiGlOmBLZKnhMdYcBoCprW33HyhgFc8af1umk4HZjWeDbwlmg7ORE81Z0rtCvU22TvA5FiqinL5sp9sjbjeg3tlRxlmr8+DYX0AVnDvncwW/2BMw2Qd/lXfZVvR
 yO4GXy4X
 JRTUcr359/kSRtEgk0fhWJkNGy+yABPwT6mTqdTBUM30aEsTm8oNeBi08X1wPG4Ud552M2TYJFEJfMbHE3rBrnevnlLQEyFUCZBAa3Uw2b7RQUYPecI12NySw9MZmDZffK4FWxg7Z0RmQYDyukiPQTgsoXdl4cySXMBIGQgSe6uPBSxrYSbsSPdoDwvh5giADWKhXpw5JxEKG5rWQGuc4AEOQCeORLh4Bdv+9LYmk9BMXdWnwXLyJV6YDGRBIQJ/QqWcAXzbPxsBAx3tEWoInlZxNZ0T3TcoEYoQlHeijXtV5T9BhaDmVNycf+2bow3PPBAq0+9CJvUn31RLQoAfcNGnQL05GQaSyjOWiy0wG9NdJbbzzvpt59PnHEa83iQ0GgBxeQ5pjfsVnJL67w/Hd2cWaLJYKljEwYvjtt83MDm43Nwrg5/BunAEvcevXyaaEZf3Yl/rHDWhNgC97YRMKknfoJqOuIN+id4Ma4hMpzZX53gWXnVx1JYm5w4mCFfa0q+iMadWiRbkBt1OPNTr1zX3bY3FfMyTe4/A8Md1OvbqHVJkYthJZ8WFRi2qR2jiZCbLmwPj8h6/8vMiULcJQStyLCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We will utilize this new kfunc bpf_mm_get_task() to retrieve the
associated task_struct from the given @mm. The obtained task_struct must
be released by calling bpf_task_release() as a paired operation.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
index 040f988dbdbd..3b10a97acc31 100644
--- a/mm/bpf_thp.c
+++ b/mm/bpf_thp.c
@@ -191,11 +191,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 #endif
 }
 
+/**
+ * bpf_mm_get_task - Get the task struct associated with a mm_struct.
+ * @mm: The mm_struct to query
+ *
+ * The obtained task_struct must be released by calling bpf_task_release().
+ *
+ * Return: The associated task_struct on success, or NULL on failure. Note that
+ * this function depends on CONFIG_MEMCG being enabled - it will always return
+ * NULL if CONFIG_MEMCG is not configured.
+ */
+__bpf_kfunc struct task_struct *bpf_mm_get_task(struct mm_struct *mm)
+{
+#ifdef CONFIG_MEMCG
+	struct task_struct *task;
+
+	if (!mm)
+		return NULL;
+	rcu_read_lock();
+	task = rcu_dereference(mm->owner);
+	if (!task)
+		goto out;
+	if (!refcount_inc_not_zero(&task->rcu_users))
+		goto out;
+
+	rcu_read_unlock();
+	return task;
+
+out:
+	rcu_read_unlock();
+#endif
+	return NULL;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_thp_ids)
 BTF_ID_FLAGS(func, bpf_mm_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+BTF_ID_FLAGS(func, bpf_mm_get_task, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL)
 BTF_KFUNCS_END(bpf_thp_ids)
 
 static const struct btf_kfunc_id_set bpf_thp_set = {
-- 
2.43.5


