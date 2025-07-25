Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FD4C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FFA6B0089; Fri, 25 Jul 2025 13:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832356B008A; Fri, 25 Jul 2025 13:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F8276B008C; Fri, 25 Jul 2025 13:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4326B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:35:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC8605BA00
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:35:49 +0000 (UTC)
X-FDA: 83703489618.06.B8F49B4
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1C4C3A0007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:35:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhK7voCO;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753464948; a=rsa-sha256;
	cv=none;
	b=YQJjOb2uE6iD0DyqZC+v/1sVab344cQ/Ve/apcQrWBxU+EhrqeBBrB0br2qmDYyz7zUwGZ
	70cL3gAiPXYnfXycD17mv5tHZs7pLzoqqgP2XqirAxNCHgnzRaDDlie6OjY9GBSEHW+o4O
	BKgWMhgO7Q2vlaXgjJhC6Bnn+TocX8w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jhK7voCO;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753464948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rXoHcgz0BuBvSlur0K+rM4eE0Cd8HhmoNnuGF/EZk6I=;
	b=kiBrahHJ9+XPXrVVV1o3kIHiK22hXzhoBkYRQoMDq8TLofRtG4tEcBbqqYOuLe3uJYkzds
	KEtCPmPf72jOdojMcosPRRCnnsISd7sq4UfnoeJIt5w50+IfOkYBJ4DdSqTJ1JoI1eZ3B3
	P83CuTMxVMvq/yN2tkgZXf6KtKPeDn0=
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e8df1812f41so697941276.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753464947; x=1754069747; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rXoHcgz0BuBvSlur0K+rM4eE0Cd8HhmoNnuGF/EZk6I=;
        b=jhK7voCOG4sxoA5h9lF+oBshA1/vutWNBuEUlHDlyMqfLSItcENSzOOuwqCTr3ciJG
         9Bs+9Lp2MljsnzIEAAotV/LgzEUifIQZIHPHYl+PSmU+93CsVe0cYSsNCzpjRitPjHeg
         6diVtGpnl7HJFm0rmZAQd+4/l8akQ9s4KygwPHqfkNQs6MbFfioT43sHj/tx9vawPNVr
         o5lQH9cBeqkzNx1zfa9BR8uTOGVy0PdHTAlbK7zvZkE11yh5T3VKpGMXNsuELaR7ZhlG
         XmarnfVgLHlA78oAPmSfTIpMIc5th0/fGvNu4Vnf1liROuF/zKrg8N/ej4JNMSH8ijvM
         nHyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753464947; x=1754069747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rXoHcgz0BuBvSlur0K+rM4eE0Cd8HhmoNnuGF/EZk6I=;
        b=WSTtdTXuiHPWdgbFOTli46OotubS57bblfhFPdhlSUj0tdzLLx4oAYkrVZc+dNzZfL
         fjLxCOpaMtTDGPRd+sscPVf3mYHEk0PaUH/N+O+IvWvs9n9zCKgaHiKeyCXHD87+8tLs
         qay0+MUaMvMbXjR/wne5ALGx+7JKNOwj7WovtKRXQYAv+ivVt9blwfO5m9vx7fpOzilh
         n3ebBJbtAykYvNn/FBs8w7x/1Eg/pG8smEcAZ27F/ps2QxCN9pTtxAwwsTnl0xsYS/at
         2UOfOPxYi2s4PfmieG/t3Kzxns6mGGaYEj0FxN6VkzLD3hdnd6Tsr9r7frk5BQDKA2fG
         vBYg==
X-Forwarded-Encrypted: i=1; AJvYcCX6CvpbGL3cjvieOhhG2HNeKmZof7sK7CzrDODc5Ss7g4JdFnrRUVYIeETir1mcibjT9Z6TU3CRuw==@kvack.org
X-Gm-Message-State: AOJu0Yw2iWXhtbtyoq7IsjoL9ljaiOM7l49gugGGYV/S1S9mJIw1L4Pi
	9DQ1rT9twQAs0Vo4/O5rw27L2Y+FoOc/9CtkXaAHZGMNcs0QcoOH4KSB
X-Gm-Gg: ASbGnct7Dvdp53T4fJCwqm5duRjGXRUPXBfz6iDltcPBaKLwnsFuj7FQoYt2UqP82vn
	UTTqvw7AtTHrR84SDf+ip1dDcy4isCm+AlfOaWgXepfgzuw4bwFeeJM10dnl3A8fq7TKeX8r9mT
	IktZhFI/rwUGiG+V1B27fknpuX3DcIgQL7kbpn7Lhwtc6XFJ0JNLydTpfI/pmSU8GMJWIS1mswJ
	FwETzXoUdmxywuB8xiaEgKT9IKSP1xpXOid2TvCMd43Jl+3MAp6VeW2t1xhzlSIngSLLo0DvMhb
	15u5wbsEEBSWCm2neCNbgVwPL+LPP4W1KmuWcF2S/5bj+HIcHtR7PPQzq+Tv5y9Ntnf1OvoCnB7
	66wGpZy4yYtIdwvFtGo8QCA==
X-Google-Smtp-Source: AGHT+IFC4bRN6MyMlkLu60vIdZy0jDA0GQB8a+RomATv34IfNGV8yvzSBB7SsYElFDMEApC38s1j+w==
X-Received: by 2002:a05:6902:1204:b0:e84:3657:e50 with SMTP id 3f1490d57ef6-e8df1172419mr3406693276.3.1753464946920;
        Fri, 25 Jul 2025 10:35:46 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:42::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8df871bab0sm138800276.45.2025.07.25.10.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 10:35:46 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Fri, 25 Jul 2025 10:35:45 -0700
Message-ID: <20250725173546.2295177-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C4C3A0007
X-Stat-Signature: 7afsbw6ozwpmaucq1sj53y87rs1f96cd
X-HE-Tag: 1753464947-756837
X-HE-Meta: U2FsdGVkX1+fDhn04iTLlrl0UnGX8TFP5WYtY2bccO6G2D3YgQXCpMxwygkMs+QcsgXefaZEcwmpdOSnvmkY2GTVHbPMHVfxg3Dw0B4+TGwr6Bdkt+mvm0LehifrI2Ma12Zev6USC9yxCSL7BdT2Hgvn6GVW8WOMhgqTsfxauP/Jjor0K+Nc+y4l1z7JQWTuNM+879O9/41xpqVE4mh/AA4BPsZowyQ+aEgtIjTvOJPKOAXKNs5isZssVCLHSK0UPl7V1oGH8bbNfr5AuSRuV00kFKn8mIuFivnJDh0QdGZX7NZtcKTeKk4h+t+OZBYraSJIPfPkVqxxc0L17mS2Pj353I1xQEi3ef7o3bZ5o0GXKEpWW1RKMWW9OuFxd4dewv8iNtwmTxcYpjSv05+lKHw8yRXtQK8QRnWp0HsoiaIPZtgaY6nSJdK7c8eZ1LqBwNyYCxhX5A9W58rpi8dcPlRFJym2HzRXCckiyO7+a4G5o7qLVombh7psJCeT7OJ6DxYJV8m6NIsxkfv57oqt0LjC3oSc92dnDbKV/NlK1jzvRD5DaGEfyUV3Uh5paWoHMeTYdEIXTfv40Sc2oucs7+y7cSJ04X8inwoRV24y4svt0TDXb0F/16hKvv0l2ToPf+R6ZfxpOa9msYH+9V0t+HQb/PB3Mpg+kCpi+mu4DoxGl6Shws5uepLYHg2nt+FBNvqWiT3sCOxHLOzNP39ctthcKrv+ZUuiX89KJN65k0j7uhBpMM5n9uDJKaBnKN9GxUYpwIbqUuUjXwG0qcvQT6WgG+8Lzz7zOmoFCK+JeJJP3uxQGlvMIqZl/m2Ir5Gy5BcV/RFtJ+DbsA5lbsPMNHkBQ7D7I0SZokQMxI7Qqbl2HsAImU6OaPk+prbafw5UEyv0mFkp3yn3G5m3JTHaczydkXIdQirrokXLSBvxgw53ZQWbSACiyN+rA/3O46eV1IqxAxG4NlGSZFJkJ0H
 nbS5ntjk
 6w/AmDu6DZRcyuS99qpFTp/KllZZZx2dRFg8JIfKrBe5mhz6RPxiNx0F609hMGB/kJOFcbCnXmeliYz1Flq3tetYZtInoCR6enm9vgbYRTbblCuhX7RR3GugoNg8Jv5ggIHd4xLQhsA9wZwT43YyCyXQ0wguEDh+izp1VeMzyeK9wtdq2oMO8fIxhqr2IE1Qsa38OYf07//hugIRLAkuGj+riDoOYQZNAERKTFnSjIs898gNILPEHQ37ooppAp1feXIsahhAlrSfKEQK9Tfkk6ProsqWpoff3IlwLFIds+NBpILKFj/WnMuz+3R3YgbsWoAuqjOdC/A/ke1BU/LYEycDXhaGAel7OowNmwBH9kdkzYcDxgOaGCoDbjpcuLZTj1LAQrgsHDlKnGpLjBM5QUT5rFWkd+t/pBeoWdeUIgUtLKmzU6ego0J0n7n6iZaGmLlCa9gyfX81G19Zsf0m387FVObF0laceEScYKvh8qHCXJHSRXK3EJyqNV0Cu8LXhMrK13T4/qXtIHD1NQCvepjrme+3UNwf1eX1kFRX6jiKGkl0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zone_reclaim_mode API controls reclaim behavior when a node runs out of
memory. Contrary to its user-facing name, it is internally referred to as
"node_reclaim_mode". This is slightly confusing but there is not much we can
do given that it has already been exposed to userspace (since at least 2.6).

However, what we can do is to make sure the internal description of what the
bits inside zone_reclaim_mode aligns with what it does in practice.
Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
description would be to explain that zone reclaim modulates whether page
allocation (and khugepaged collapsing) prefers reclaiming & attempting to
allocate locally or should fall back to the next node in the zonelist.

Change the description to clarify what zone reclaim entails.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/uapi/linux/mempolicy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 1f9bb10d1a47..24083809d920 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -69,7 +69,7 @@ enum {
  * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
  * ABI.  New bits are OK, but existing bits can never change.
  */
-#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
+#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
 #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
 

base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd
-- 
2.47.3

