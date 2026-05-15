Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF95CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A55E6B009F; Fri, 15 May 2026 02:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F2A6B00A0; Fri, 15 May 2026 02:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF3B6B00A1; Fri, 15 May 2026 02:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D4C286B009F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:53:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FE5A1A08A9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:40 +0000 (UTC)
X-FDA: 84768738600.09.C0A9E0C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95D18C0007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:53:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=P9lzzOG6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778828018; a=rsa-sha256;
	cv=none;
	b=E0g/HvUkhP3mg1lJE3m2mizmLXs/0LZKgRtR9lv5UN7VYXNAt5/6wqOTXXBPAA3KahOKM6
	69E+e+FDKE8vYZV81rkF8kEtC1Xbf64qvy4fXOox5gT6GJfa2Pat5GRANv9Oc4nnhCiVzM
	JOJllEt+Y6No30l2f3rLVISxPO/zaig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=P9lzzOG6;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of 18810879172@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=18810879172@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778828018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oq7vhKTHh4eGazxWPRwxR72/b4iWb8yawVg9PFHIeTU=;
	b=MJUYcbSKE1Ht7Dzocg9c+tegepIqLxmfzRZhpEHLvXvowiKmG0ytX5U8sUsmkGqSuBEsq5
	BgCSqfW8FhrKpvUJnJh9Ol6wDCb1sw9g9JLvwn62e4fpiauouwWhAzHCz3/mV4qX9VeSlK
	xltWRjXLI+SHo7dsZKv72O6FhPMyl6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oq
	7vhKTHh4eGazxWPRwxR72/b4iWb8yawVg9PFHIeTU=; b=P9lzzOG6Xy07oJK1qj
	8fZfX1UvyPtfXc/P+CSYIqipwmliqfKxaIIy6mjlsz2udNxd6MdBPIj1dt9wymHd
	mxRlHHFRsfbBLljW4Ej5xVlRsOzrdFxXpW1GTgfu70nIuTwYUbMhTtDkhhCQd8Vc
	ypsId1x5M6bRPli+hgWWmTWH4=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBXDpTnwgZqtc7KBQ--.2204S5;
	Fri, 15 May 2026 14:53:34 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v1 3/3] tools/mm/slabinfo: remove redundant slab->partial assignment
Date: Fri, 15 May 2026 14:53:25 +0800
Message-Id: <20260515065325.4009527-4-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260515065325.4009527-1-18810879172@163.com>
References: <20260515065325.4009527-1-18810879172@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXDpTnwgZqtc7KBQ--.2204S5
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyxJF4DWFWrXF45ZF18Xwb_yoW3urb_Ka
	4Sva18X34rJrWxtr1xCr42vrn5t3WS9ry8AFsrJFn8Gr45Kw45XF1Du3ZrXa45urW2gan3
	trWaqFn8GrZFyjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_vPfJUUUUU==
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbCzg4I-WoGwu4ywQAA3G
X-Stat-Signature: zauj4nd3goo64u6s1x8bccrzh4gay53j
X-Rspam-User: 
X-Rspamd-Queue-Id: 95D18C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778828017-937461
X-HE-Meta: U2FsdGVkX18aCPU6hNc5OahI0InXIuyLV0dgF08pgqe1aVKNA82uuZAfug21eFQlkQK60N1GgZfXu+VfS27D+TqNlvbTkVLoU+rh+djnpk3V15TAcXIWJxWYcUwZF/6arvV52lnp/+/tmKJUqp1tFgZDAufoLSU92DGbx75B/Aci2xWULekqD6mVL3UkXTvA/M8DEmCJIZW0ETWcTgxMbMETpSjFwdmnRa8dqhH6h434YTdyf9uixthZSWjSAFvmD+/xvQyI/PHRHUuDUUrirgcJDfQTpnlQX0Zz+VwB6EfE7pSrJaLIm/3CSdVDGGNA89kzEZBMACI9WQqCMmc04sBBZDbZi1bYuMr3w7u6lgOfifFbCrTFVHkYQQhv46xH3foRrs/dUmduAnqq5PZkndhaocWZhFSp0NcJIU2RYSlgQWVFgjL8QwkVG4Ib5oIXR5OwvlqAIeh/pVCOOSMvC9cZkgfeO599Y/f7BA7O9zpgDSEIPnQSybn2RCHre/j2BCl02kN/rKIYUDuY4F9SPtxvJnM5qj/OwTxS2iaGpDe6Vr9fKMiqMMw9ncDFbOKyKT75B2VrLgAL/UnyfLt1+jo71C2N9rA7WUTNrLEAFoPwS6hfeb7Ff6el8Tqgmx9Y9zY6ltuNg7ygKBQRBSSJwQiCP0oSu5JNPA6xfzvfVLk6dkw9H8SL5sGMgu7OXQQfRI8F8Hm1oHuz8rqCB4JL4Q6ukKPTbE98uV0+DcaL/GRC58NkS67FktC8VCrcKxGEIKPrrEYIBedkqv2jipsI++BnyTsnVQMKlAcOzMYmCZ8IDZ/sCEOeMITiFLm5Hty5QTd9JRp2yEV5cU9wiITqka0PjAUwRGhMBMjFxiQasdTR0HizoFwA7G7VuRyqf7i9AuUrZN0iV8ii3G5UuFR6tid2FRg8Mvs1L3fz2qzqmvP5QSoQ7h4w5Pxlkygkt7JYaaV8uZCcY2BcVBQH5NA
 5RyaKBna
 95GrPRk5yOtqt3Fwi/JiUH2Z98XGKHF2b/FlA/CEKP/1ACpbHxe1RQANyuiFodg5U+PnSq8f0VbuOHWFGI+8GcqygjZ5nzzEK16YY5/RmD4A/hLvndsZakZeW/SIrgYKN6fOzc7+zovP66seee5NrxF6sdU9v3vm8hvb+VZBVMbNGVHJUJ0YAD2Bksgkq6MaUCXYNqSRwTZKNIxNH7U6AAyfcsV3AwD+jNG7Ugplgku0pQWlbP+04a69P34eKv01fwh+IBn+lY7K4NSTrV/NFyRnwqJTDh0QvaO0YStMvQ0t9MmhLWf0HiDXcZrwIQtljGYueXbs1yYQXaq6uuQ/d2MbBeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slab->partial is assigned by get_obj("partial") and then immediately
overwritten by get_obj_and_str("partial", &t). Remove the first
redundant assignment.

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 tools/mm/slabinfo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index ac00daee41d1..e52d718ba5f2 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -1265,7 +1265,6 @@ static void read_slab_dir(void)
 			slab->objects_total = get_obj("objects_total");
 			slab->objs_per_slab = get_obj("objs_per_slab");
 			slab->order = get_obj("order");
-			slab->partial = get_obj("partial");
 			slab->partial = get_obj_and_str("partial", &t);
 			decode_numa_list(slab->numa_partial, t);
 			free(t);
-- 
2.25.1


