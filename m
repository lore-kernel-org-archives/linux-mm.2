Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3962CC6B26
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 08:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EDA6B0088; Thu,  2 Apr 2026 04:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FFF6B0089; Thu,  2 Apr 2026 04:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97A76B008A; Thu,  2 Apr 2026 04:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8B306B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:14:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FCB01A052A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:14:25 +0000 (UTC)
X-FDA: 84612903690.18.AB75D21
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf07.hostedemail.com (Postfix) with ESMTP id D19BB40015
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:14:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6x3zf7N;
	spf=pass (imf07.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775117663; a=rsa-sha256;
	cv=none;
	b=1kAmMtaJpefGJuoMafHJhFgKB6NXAqRqF+SIT7GduiEmIdV8GfMeO2Yd8MuHzTOcmEoKUt
	lsGO5UrtN8J9YLwAHJ3qmRdijrN2x5mfL0rKNjMSMIjAyHkIHbOcx2Rd9tuqeU6guvsypc
	2RkSv1EM/qPeUbdkKBoSxuR7QpG3SBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775117663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8kppIVwdvYoKy7YwmYGnoqhLzOV6W3da2r04OdMiukA=;
	b=Sp3wj9qHagYx6WB9tAqAfvz5q21Ofm2yOSwJsl2e8WcrotGqz2JNGPm5VgIj+9BF0dw2O9
	PDeIOIE/FRlYxyKMM4jPcP2YZ3RLiCoxYt898gu7UqH5L2y9Gz4mJfA1fOdd+PvJnYORAl
	xmMRvAzVyYscgrEnit/PlxQdnrbAmjA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=A6x3zf7N;
	spf=pass (imf07.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c76bc3e8de3so211927a12.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 01:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775117662; x=1775722462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8kppIVwdvYoKy7YwmYGnoqhLzOV6W3da2r04OdMiukA=;
        b=A6x3zf7NjAHRdKsFUooGb4rYwrdiFHu9nv3BsGxhJV1NfQITzxudF7MIWk+uDa+4XJ
         Lho/A0K0dHWTQIReo37Uf1qTQxeAvD6T7/+NkSocqea4/DTrnHZQ+8XLxIHTeyU4aPNG
         g99YGwNXVG1ts+eMce/720QA6cNNQJ8MMc2jkzIr30e3vu9Ai71V4PPdDSaK1F4dTtrD
         fHoxQLfBEvtRIZj7M3UD93G5jJXUVcf/r7/VaUcuX4PO+YGoNgtjj8BGGrRY8A+FHHxg
         yuBxT7ge+1Oy8HOR1jgSsLhTCFgQs91jhnMA2mpfvTAppQP/tnORDP7j1e5w+fjso7gY
         z7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775117662; x=1775722462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kppIVwdvYoKy7YwmYGnoqhLzOV6W3da2r04OdMiukA=;
        b=XL1uL2RJwVuWJvxp71bVW+iB8VlPohqMJQ0pJXxHW0Jd8FcvmRzUN7ekqtI6MvzR+f
         h493KWJnykmSO7taej7dNBYTRoD21yXrgSi6r9jhPPIgsctkgbOiZpFleTp68zuQtmVr
         +iOeAA19Azl3BZEi+AnjSjUoaDd3aRCyf5tRIP+a8VvV1IQK5vFMngNooKdYGZjmiCb/
         M0hwL1Rj1IYgDIXfgmmE/rY+nS6KdD0GdoxjH8J/P5pHnYdgxu1FEOyFT4LCdw8kJ986
         EE4k+9J6JVQzeeZx66YDBxCQ2Gd95rzd02vlAXPw/JE1GAqMHRyHBSGyoh4yeaQIVCkO
         jK0w==
X-Gm-Message-State: AOJu0Yx16+aiv7RuhH4vhQcfp9p39B5zBx4Fi6+tlD6jQvDr3hW1JKyU
	bGAoezg+OjantD0S3ytDvpPLdnRNdPZBRhdSbeiLoZkzYyPb4ENUpuL6
X-Gm-Gg: AeBDiesMLlhMHPHf6zJ+OHR5JHq7/XVAeoffYPxeY87ZJfbCbx9vQpVKS8ufQH+rgej
	Mt2DRpm6QZTLkpX/+xSwpUh8aUTo5/Xvr0kc7gEnaOZg+QjS1OozyeCeLvMh6PYYTZEJIuuegiw
	in2UrChDqyebIrhdJlbyb7P2XywER61M3mCvcCuQxTkzkWS8xBagN6Un2Hp62l4B6xpbjXXS0DR
	dhQXwBJmvXxq+CNwdv/KME7wLXRqMpUR1SYldZRLBmuB91OdWcPQHVrVBlaAW1IEzJcCaUYWhSI
	+SmJtvZQmY+oeigrMHIuWUJ4/M3arIv1C16iiDevDHEAyFIYZQKvlqYhz4xLz3BimD0ecx+2top
	Azj9GSDsYnvAo89AsDzjzxY+nKEg3Gl/eYWrrwKKzy/wX6/YbI4kvxk4Vnuphh9iAHUYUKK/UbM
	NFzDtNd+IQWK8QvT0xOI8X+8guFWvLQts2QVu3UalnEPc2OrzL0A==
X-Received: by 2002:a17:903:3bad:b0:2b2:5305:d492 with SMTP id d9443c01a7336-2b2758c3032mr27643075ad.17.1775117662556;
        Thu, 02 Apr 2026 01:14:22 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274979d72sm19685155ad.51.2026.04.02.01.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 01:14:22 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qing Wang <wangqing7171@gmail.com>,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Subject: [PATCH] mm/vmalloc: fix KMSAN uninit-value warning in decay_va_pool_node()
Date: Thu,  2 Apr 2026 16:14:13 +0800
Message-Id: <20260402081413.1896640-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D19BB40015
X-Stat-Signature: 388ru3f693npnain66anu7c463zo1c4j
X-HE-Tag: 1775117663-754986
X-HE-Meta: U2FsdGVkX1+WABrQ7VkyKjXnC5wFtLTP9g4hNq3Gx9szbSNsNyZVcVcNgC1lo7CmUvGNzutv4IaP6us1dl4siMGyEl80RlJehta/yLNCJeVjLDxWI2cHBebPh9zSFZCMYeQthtpTpxA1ffwo91B+YnfjImjzMSpDQT/NMv/RetkG6vcukfiajB3zLQvXizAiQtL1s5FVo29OUjCeJX6afFHsSabjFCNam6M2DM4Ux/nRYfXg3E+nBzHpMKjY9fX4ztBgkmMPAURamrbf/6ufHZv1/TWjvIu4sTmvWzKbBYVCGH6a4kQJFRCvrEbVn8AKhnO48xKrg4w3K9bu+F5rHyzeNjCF9T7XJoYhQ2R2SmD4uzXK+seXhNP2C/vjqjlISPbyUZB4zCNFpCv948mpXPE7iOUc8gPdVTwSFHyE5ZSEkFXs4LnVx9LIKGIvu+74C12H1nXp+p7338mmrI/diFQo6VRidhJ1KqMv2BKcNINaJPcmJLuhMfmT3TRS7ejVhCPkMI8v47gv6HggVUMUquSBIivFkKx1yocXHMmEvI47V6o1i+dkXvWk3LcRyHLHp5iwwRm+brTooG4eJU1Zz9mdWugl7mGa2N3LipfqsyrtdrZkhvxNlldu5JFzXWO7E3v2yqYnyzOcJVMN9lrEQGmhpMyyEMTIF+waTpgls0+b6T5W+YT6wj8l3MY7ys/WIcCpdZD06Rlsf3PxixiQjQcf29S992u8okb3TdYwA23zDZFE2YdGVjnZy2UlS0XI4QkwnaJTMoSkNF13CIyOBHaulNGkaAi0Va/aQcyFb38njQTOOK7ZujvMN6QYbpH6wNScwGP9wT8OO++3U2xnNwgYAXK6kGi6FUv7f6iWvXES82F+n227anOT6nfz82qGmfyrClW7WNsJ/I8mKVMsnUxGI8sOFyZi0IdTyxHRK4kSZDBQuFdxZKUHvDh6iWos4LoYE5ilRExA4slFA35
 fjVP59mJ
 VDEyPdn4KazknouQAjgRG9BWAFfG6OygDG4jG6K97d+ulX0PG28pj69z+7VdXAL/dOzuIqcQ2bApAXrFAdWw8HYbxIo6+ELhwzjAtTYiPYwUskQR4+VN3YNB2y4MFgzskMxlNr5KqLHSxxBrWxAritewuVOH5ZEjjhoRGXJ0SAWz1exbYQvt+dtIVcfkskHzYwS2TOHoGUuE3HHyMuriLm3PRwM+y8/JabO8f++Vok7RmGP1xW4NgnPciot5BTWDPhtSM/tLzBcq9JDu6eWFZwijCy14cvFWzMuHXvOvNz+h1f4D4+kTi4D1BL0ptev4TDhuY0dNbaX83E4Z6W5umGWNQbSDftS+6IBnMvMOCv6APbMMXtOg6n2mdYX10K+GRA2UtFuCtaegsW7XctAWqLv5akaSZF35JjMdaztlZ2320wuOW7tnpM+1wqCcCQ7qo+TS6po9DEf/9F1BPAyU8WnZwebtljF5n0gCvH0Im2a2vikWq6Fb09Q1vxC+OO23xWWK3vwPk4F8dSBV6/MjJ9gZZnRXr3I0PKlhaEoWszo7o6o5dvPTSh1NF5OvlSXM/qAlolhW1igDeHj8OU13wqI1YYOb5grtqKkNK9GZYV+GVLskg2K6Sco1NXTY/ljUVAmp5Soi2a1VQKZx1pqd7RAAFaoU8j6fOWYq3twdDDzjv8NXNtNAjrqYpO4yFIZWRSI0Mbl6rib4VXc7G8q3T0YnxH7b+WUWdM6QW8qASz5BHhjN11JTHrYorc25/eNUtIkR7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KMSAN reported an uninit-value warning when accessing vmap_area->list
in decay_va_pool_node():

  BUG: KMSAN: uninit-value in __list_del_entry_valid include/linux/list.h:-1 [inline]
  BUG: KMSAN: uninit-value in __list_del_entry include/linux/list.h:223 [inline]
  BUG: KMSAN: uninit-value in list_del_init include/linux/list.h:295 [inline]
  BUG: KMSAN: uninit-value in decay_va_pool_node+0xf78/0x1dd0 mm/vmalloc.c:2255

  Uninit was created at:
   kmem_cache_alloc_node_noprof+0x3cd/0x12d0 mm/slub.c:4918
   alloc_vmap_area+0x327/0x2e30 mm/vmalloc.c:2065

The root cause is that if node_alloc() fail and the va is allocated via
kmem_cache_alloc_node() by alloc_vmap_area(), va->list will be uninitialized.

Fix this by explicitly initializing va->list after allocation.

Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
---
 mm/vmalloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..8aebbb51e178 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2071,6 +2071,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		 * to avoid false negatives.
 		 */
 		kmemleak_scan_area(&va->rb_node, SIZE_MAX, gfp_mask);
+		INIT_LIST_HEAD(&va->list);
 	}
 
 retry:
-- 
2.34.1


