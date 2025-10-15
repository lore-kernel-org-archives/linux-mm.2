Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A06BCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A298E003D; Wed, 15 Oct 2025 10:18:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3398E000A; Wed, 15 Oct 2025 10:18:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84398E003D; Wed, 15 Oct 2025 10:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B12D18E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78A8BB6B35
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:26 +0000 (UTC)
X-FDA: 84000553812.26.8E64780
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8424320015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PvLQmx+o;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
	b=hBIiITZsCt3oohNBxnCECnEw4cnbsnMPeezc1FQtiqKSOkPk9x8dZ7hmj/n0Q9z+S5MFwh
	NYcjSMx2+BUzu8zbRx/ZXxzFZUJPhJLL+eDeiIfJIQrfe50yoF5847HueQJGCAu6ERfX3i
	Dj51pEAx+UetVsn5K1mWbPDx55AtKm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537904; a=rsa-sha256;
	cv=none;
	b=M5Qu606ZtLoEAH+jFF2fZBIfma6ljsJPq7owyD87Bgb4fMZbswscxmqz+kpytU55M+btN0
	bpzlcp/9O7pVuD0INWDsgL39XMGAssxaxNXAov8QjQx/RleU8ddIHLWRyPytZbq3VMknnO
	NKcLSY3XfYL51hCcVuQ33GyG3igRXx4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PvLQmx+o;
	spf=pass (imf03.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-271d1305ad7so104080765ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537903; x=1761142703; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=PvLQmx+ofPtAIPl4YvYqaPvMiNSRa2NwURayfdtjsV1tzH9yPY77DxJOW2Yx1jXwS3
         zYuRAPpWpkoIWtd9F8IxRf+Jmd+hcjs5mFM7WoyP0Pj8obphSKFux64LI1+JirFBeytj
         eXtW7VlXx9EymYUUU2gEQfD/g8dr2kbEqO4owJIIgUKVK4QINwNT4cZFbn2KiBZuRSNO
         FRLRIQliaEJ1BGScsEFyjSCs56QedJK6CeGpaU28h/de/3CDKP7ixcjr19iZEkfC76Fx
         wYE5vMMxIx6GVV7UxIUS3X0N6B4w2kgcRK0fi8/eaQ/3o8DMhKN8FMbrTC7H5w9D6dqi
         VIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537903; x=1761142703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOprrquoKlbkEreJojZ4KykFg8G0TswcVk79ghRz+Tk=;
        b=kStrnOWZ2/m49IcvhiltFzs0/j2SWcvslvQnvMEM1Efbn8YEE0z2pJqh73fGRQqr6z
         r68IbZ14iFb+DSZUcPGNuoAr4UnVl1guHsnxebYkZWOkU1WIZScQgqjzzifqs0EwBXX8
         rxqoW6noQP+w9N9HtytjGgSUqbWUaCeiLwlC/drKs4xzA6jRYbPj3YGAdGFiRmEieJ8V
         fIPnSOV9WbVneO6fttSZYOBKUWdL8mMunQmDJDcDK7hGUn7gsIDLtxuc0iq9ptKGezQ8
         9C9BcoAVJEDhikOOmbJTHWNkwchcEqQY4igCFzo97iDeV/VMh2Ws+Dr39e4x11jXFrs1
         t6TA==
X-Forwarded-Encrypted: i=1; AJvYcCWFLcJjorCmSW2vhYp6/a0O6SdEL/WGUztF/shG9XlLl0d9YICt3DWirOR24AFyBnqZIrXTO3nUoQ==@kvack.org
X-Gm-Message-State: AOJu0YykJ6RKS85hIxjykyj+g0ke5pM8CuMfofhS0twn2xXh+9pkyY+/
	J8GvjWPSK5BcI9QAubIYhrQ6O2UT15DFggQrgHA6Ud3RT4yuDZyspkTp
X-Gm-Gg: ASbGncvjUXVpCG3ABQPrxmvCeziM4/TlUC76sJ/JwCDu4VlH+3avkc8Rbxi2bPte6pu
	dkqUuUoU5I6HbxErI3rAv3QD+VIlHLEoKGSg6p3cVo7CsLwgUCBv5227d43bTRjhEj4H1HqkWNS
	IUlLbF6cJyZRz24kcLeNEz91DNydlWD8jK/quwlBuzpNPDZTZtwvNJlQhnXynQHxwOlHK6FY97K
	NxOFxsLC5TCZkBAXkDhigHYsQotU0REiEA8HSNCdWnvGbr+zOlY941W6Nzkwa8K4y+zmu/EP4XM
	lfAp0tswUW2W8E/il6lDKCmLVwcIl8k4MOBsPo4r26NQ5ANzBJvj9D520uCJ1yy4L5OfzOUR2LI
	mz/150a3TeP9h8uM+CplRynAH2/sOLevgNXGDpD/eHknC2o0viaZLYmScG0rfKZilgaZIbmlbOt
	iCRB1X6e752g+6JqXE
X-Google-Smtp-Source: AGHT+IFbpJ/lHtUZtOELQrDFo7AxEZqNrS9hHE1/EnXHjZzMn0AR8tXrPtdpNdO0986Yh1aFevTgmQ==
X-Received: by 2002:a17:902:e78f:b0:24b:182b:7144 with SMTP id d9443c01a7336-290273565bdmr371321185ad.7.1760537903035;
        Wed, 15 Oct 2025 07:18:23 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.18.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:18:21 -0700 (PDT)
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
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 6/9] bpf: mark mm->owner as __safe_rcu_or_null
Date: Wed, 15 Oct 2025 22:17:13 +0800
Message-Id: <20251015141716.887-7-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 8y8qiemo6thejwy3diqzoscjhkog1ckh
X-Rspam-User: 
X-Rspamd-Queue-Id: 8424320015
X-HE-Tag: 1760537904-580801
X-HE-Meta: U2FsdGVkX18ozf5QnNzg206I5fg7JM3HFUp4oNQH88FcUYxKFCO2+xBu6sFmd3eMngUqfw2TOTr1YSTf7SO+WesmkG1awmTce3xn0qg/8fOnNvsK0eCf3fLmT8Ltj5TYN2lLBnM80GsbuEnkeAK54dhaUuk2B/KmL+5GgO0JzKds1uMHQI8i7rgcklzttcFgF0UCzyewCFcf6xNEx2DZuax0Jf5HCid0fDa/uPNAV3131SUpQwQhwo9Sthi+n38MEc9FDmxqZKIP/e+yJ5P6HgUDkRgzhNeDHYWvx6X24Ji4S3SZjrZoP5Mi0kpVkySvznrqFbLNN+S9/hJrCzxwFZzHKZ3WI6JMHUt9oHzWGqoL8lYWXl70Iujd1bgNIV4mB4hvIcIhitl++VeaXBmVS8VY/EQ+o46+yv58WXErNuEmg7KnAHC5KwHWuX372bAhA5ENQBzUBXWTTS+dyvW2ZHbk8ljDzBUXINpzSBMmh50+ndC31E9901yQc51vtl/x/zR6h+qdwx5wEYe9HkrQ7JTBKe6VWOOvplDEiMdk5Eb/87fQxToAeAbQ2Mh564eodtxIcSeXd7CeEf7Kv+vTXpS7iDZ+Bd6sR/v+vE9qDUbJDKZAj04Y2BiLb44uGJ+/y4YGa1cp81kxIbXzPRBeecOcQ+cOA/fbGZaXcWnMAo4ET5kjFmXaaz/Ickgw5DrOMghKo3ZmBx6exBS15IYhrDy2xeEXvTmcvSGr6pDWho1yl5zpS/xBldviSJg7d94Ujtu5xo0+K5xGECz4DawhD9lOHVgZ3Qly6z7Rdl3E2zYvc8ES47XPROO5i++8ch/Rd3m8qtBZ8BMpxQGU0pdS07OvbVinNfesWqKeMPM9Gy1q6+btVu1j0Iu0DgRCYpAe5ThMbrQIkMsO5wLqxn6seBxB0sbGNC1bDUdFrhmmYVLkv7ykVhlYYfECBenWHI7UbbuJqcbVHVOZXZ2uX16
 0eoS3mWE
 LtE8ImnQ9ELOdesNy+E0gaxVJUxv8ywMgfsDwLYyoV2Zmm84/ZDkY2v/FJIQ7rnwrh0WXLbG9tNW1/TpCH5qMNY9QZhUU2B+CSSPAEjvYToSiRZRcYvZAFe3bfRiQOpd/21nLfNMnbtE9XN5qHNhxYJx+7lXlYuw7gL8OJ5S3DmNUj9ZMzUmIQq8cOUmQpiAmsjzEWpviaLaKwPnpnETWtCeiUXCP2ignaf0UzxPWOqgFXyXJliF12b6mMaEWbojsmdL1LizsLTxnOv2L4pU/yj+ZUkwTpHiT/w9Hjlu6TyBkd+/8Lgr+AjfR6WmvM+pZsygXnxg6/7mCYDXtPDQiXGpdaG6MP7q5JfuyJU4rRbWBupFc9Ws+hqS+vzw7mziGwQ9Ut/Gv2Asqs/VnooySkS5FwhCPCxKFon0WOUsHG5ygt3hWhwRaTEW+YxvMr/tdKRCTwfb/7eReSJn9N/NZQcfbqe2gBvifJpHCOzL1ykq8Gl479r+veCzxaHVxkjGWAzYMZy8f4/z+8/MeD03GjF77Z/ZBbeCgYIgzIh//2JhbaeA5x2tzgT9tcNl8jDx2+jWjot5+Zzy1Ycs=
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
index c4f69a9e9af6..d400e18ee31e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7123,6 +7123,9 @@ BTF_TYPE_SAFE_RCU(struct cgroup_subsys_state) {
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


