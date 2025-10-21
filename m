Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AF2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466FE8E0015; Tue, 21 Oct 2025 03:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E7C8E0002; Tue, 21 Oct 2025 03:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B878E0015; Tue, 21 Oct 2025 03:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 258748E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:37:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC0DC1A03C7
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:37:23 +0000 (UTC)
X-FDA: 84021315966.26.B885BA6
Received: from mx9.didiglobal.com (mx9.didiglobal.com [111.202.70.124])
	by imf27.hostedemail.com (Postfix) with SMTP id 89E2240007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:37:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=didiglobal.com header.s=2025 header.b=F6XKfL8z;
	spf=pass (imf27.hostedemail.com: domain of jingsusu@didiglobal.com designates 111.202.70.124 as permitted sender) smtp.mailfrom=jingsusu@didiglobal.com;
	dmarc=pass (policy=none) header.from=didiglobal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bz2COxVLbbO+0xNIIj1XYl4plzJn4e3cBaijQkcaMjs=;
	b=ZaHZH6k9yfOOWlnFI03JrdlB4Dh8AM5Kn3MCCSJa/MRjmaDofJBkfWVwZluuS8D6xK/+cw
	Pg5OW5vi9fzrS0bJ1uo1NfgZWK6aqD5Is9g/LKS/1NvcCqCoiNRWAEMhjTT+Dbk5sXsNSI
	6xXt2EELx90NQs/xxM1bHWh5EnN3QNo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=didiglobal.com header.s=2025 header.b=F6XKfL8z;
	spf=pass (imf27.hostedemail.com: domain of jingsusu@didiglobal.com designates 111.202.70.124 as permitted sender) smtp.mailfrom=jingsusu@didiglobal.com;
	dmarc=pass (policy=none) header.from=didiglobal.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032242; a=rsa-sha256;
	cv=none;
	b=CCeYzC5AcWDz8/wSL9nwNFiCbWKXkpSHq1NhLt55FxNZTWttygFfg1Sdyt+YJBIQoHPH0F
	cJV/I4ZiyyJW1+Vn3rH6NjWgKIY+bV7NLs3d9EWcMjG3NJovDbAxsXAPk93gUwfCHRFcQX
	hb/KeGCKYGdOCncuspesCC2QcPyVq4E=
Received: from mail.didiglobal.com (unknown [10.79.71.38])
	by mx9.didiglobal.com (MailData Gateway V2.8.8) with ESMTPS id F2854181D0F585;
	Tue, 21 Oct 2025 15:35:09 +0800 (CST)
Received: from BJ02-ACTMBX-07.didichuxing.com (10.79.65.14) by
 BJ03-ACTMBX-02.didichuxing.com (10.79.71.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 21 Oct 2025 15:37:14 +0800
Received: from pilot-ThinkCentre-M930t-N000 (10.79.71.101) by
 BJ02-ACTMBX-07.didichuxing.com (10.79.65.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.10; Tue, 21 Oct 2025 15:37:14 +0800
Date: Tue, 21 Oct 2025 15:37:07 +0800
X-MD-Sfrom: jingsusu@didiglobal.com
X-MD-SrcIP: 10.79.71.38
From: Jing Su <jingsusu@didiglobal.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<jinnasujing@gmail.com>
Subject: [PATCH] mm/vmstat: Fix indentation in fold_diff function.
Message-ID: <aPc4I/8zXCGyiapN@pilot-ThinkCentre-M930t-N000>
Mail-Followup-To: akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	jinnasujing@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.79.71.101]
X-ClientProxiedBy: BJ02-PUBMBX-01.didichuxing.com (10.79.65.22) To
 BJ02-ACTMBX-07.didichuxing.com (10.79.65.14)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=didiglobal.com;
	s=2025; t=1761032112;
	bh=bz2COxVLbbO+0xNIIj1XYl4plzJn4e3cBaijQkcaMjs=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type;
	b=F6XKfL8z+6mdY7++oBMvtYzVVzNdyI6x3ttO6nnxsRBnAeT8PLJ7n8AxfA3UtzTNV
	 5yXwhXxHDRQDIy75PPj9GfXGyXt9sg33U7NztRtYC2UJfAugDolbWULL7T5SjpEW25
	 aVtNwc6s/+f4fF3KC5/Nag6+f6+QnSC1y8yE+Xu0=
X-Stat-Signature: ibtybshpbcj11ub8ebe9jkisbcu1e9i3
X-Rspamd-Queue-Id: 89E2240007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761032241-218375
X-HE-Meta: U2FsdGVkX1+wDl9GzLHDDLeXs4HyOmyLS5Koy6Ycr2nMzT5T3LRpVoXFUPuPw6TnIDdxKGAadmiHsoMdpV5As44RpogGQRYQwjAzHzanFu0R0Aatf0C40hRXogUbK5GKe9lgWG3tMUScZjrOgcckQ/etgleuMY/E+TiqV32psXMeqZ8L+43aLTEFX+cyiFlI88usDl9tALoPlzeFDXxwRmguRn474z1THJ7L33/iDrjggBk02CPHmbFzEfZcX/8LA9ylTG1aI79tgwD+Na32FU+mKSgW/E8v99a3tKa2iM11HL1Jb87SBV6auCL8m44jZRMbKykQYwj0Kr5h3r5OOICofEYzcLHSB9Q6VgKE79X5g18T78gtJg0jMNc6CiqzbFQvlvn28E46GQsOo9usrewWWNw2c667UjwzK8JPuI6E3jVfYvAxmRpvwrOF8L8/t/5PtL2J3Gdoz24jUA/oz94CYEMLigD4k+Ay9Q8tDmiEnlUnYsa83U/MndypADx9+TnliGxgPx8AD6k0CK2XsdtUCcGRfzh+HOkCXRZsOL/KMdxBpqRzygDjXzw1aNvofvJDSRJbj/ErOM6wb5AwBj4D6ajQFGuDIrUVD5Gi1YeQfIi3wZsmA9RMtOR8wbOzw8b73UlnYlXVSw5MAUZAhFOAbJZRBrQLqa8TulFSgnYJys2+9pHZ83Ji5Hl9eDIF0ZwjSqp85k85jbohCSguqT2/0u7BhAUC/WIrofVJtwVcqo5JCylEYfz2EcR3etvheZPbaQ1YrgoeR41eVgdXF1Stwti+xJb+E6EEzwr+AnxTObC3w8eTqcazQZxA3Es/zzQYMwoiO/Hk76NX7KFTk1xtI94b4VruxVDq4UTnaxZC7omg+LUUwCFJsGTIDCG9iALvGJsKQtcSky9gNGTie0uEavoJhS9iEEAjYxDPgDlB20YlatK8+gyWG61FUsyFqDP0zEYNjNB5T6v7fik
 +6pScjKg
 /eUTalcOR3hzj7In4kwDf0LwlkCwzC8N17babzR1BzstQSwYBLtXTqFaf5xuciC9oVMAD75i+05MjQGGADmFyrAfJ+O9vgcsPAFvip9itPM+vXwgdNgyETWKT18ASuyvPS21tgajxmzci2behyeSxk3R0ackqvylJZbs4yeT9Ikn6Ud7H4NvrWNta8hXIcnkJY7KGaJIx4zbhyn4uCCAWo6us4cLi6UCcDOdzvIaQk+HP2bNCivJ8hFEEAFBiJk8t6qDzYhBUJp/8e/A06CqAv/p3+owmcLfU0aDc42Myj73x5O0xIe36UlJqtRK6oOucSAiodzVLmA2zKmoXyz+EbBQkWrlGe8EtDVdfV2c5xgfF7WwOZh89eD68gjV8Vj428Rjn5A3okwxFBXRx7LiEj30OJCtnDkYGKeZLvKpFLokDg6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust misaligned braces in the fold_diff function to improve
code readability and maintain consistent coding style.

Signed-off-by: Jing Su <jingsusu@didiglobal.com>
---
 mm/vmstat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index bb09c032eecf..63860c3d22e6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -782,13 +782,13 @@ static int fold_diff(int *zone_diff, int *node_diff)
 		if (zone_diff[i]) {
 			atomic_long_add(zone_diff[i], &vm_zone_stat[i]);
 			changes++;
-	}
+		}
 
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 		if (node_diff[i]) {
 			atomic_long_add(node_diff[i], &vm_node_stat[i]);
 			changes++;
-	}
+		}
 	return changes;
 }
 
-- 
2.34.1


