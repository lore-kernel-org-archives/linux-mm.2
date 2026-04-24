Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A6D0FED3C1
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869336B00A5; Fri, 24 Apr 2026 08:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A196B00A6; Fri, 24 Apr 2026 08:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FCD6B00A7; Fri, 24 Apr 2026 08:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD1E6B00A5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:37:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04DBB1B6AD5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:37:38 +0000 (UTC)
X-FDA: 84693400638.16.76305F5
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 40D8740007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:37:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d8Q4MA/b";
	spf=pass (imf17.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777034257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=30CzM4Cyi3aFwkoMrw9gUsQCscXsMUPR4XUS+ZTxUOU=;
	b=45mK+FDYjzGERbM4w3z1sVy5siXPqCSb8tT53Ga2MWAZhuikUH1samIpkJtKDzWg2VA9d1
	k3XkdWj/IzwBYAzlfHcE1cpHiCMX6eVDd09O88ky7SJ+vSkRCAM3fFDiAbXIs/owihoS5Q
	j3A3FAhgEopb8Z97QVvbhu1B7d3piHs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777034257; a=rsa-sha256;
	cv=none;
	b=xiaG5XOHJdm6XDGuGvMs5cnJXczchk+CJ+xCy5NPxVzf6wnnGSpKvdSHABovpVhYuRvneJ
	HgrfzhGj2/9SBL5kIP9KnCOzsSQ+FbBnv+KG1XuCYgNJWlJopYmURE1HrQ8ihzssMXVC4u
	2OjeS86TQk716iSkqMsVabua1G0eiXM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="d8Q4MA/b";
	spf=pass (imf17.hostedemail.com: domain of huangzjsmile@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=huangzjsmile@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35f9ab079bdso5182770a91.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 05:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777034256; x=1777639056; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=30CzM4Cyi3aFwkoMrw9gUsQCscXsMUPR4XUS+ZTxUOU=;
        b=d8Q4MA/bjJSQahKnV6Ul1GaVwIgzWkoYXi7ow8iG1sha6MeWTTzaIh1WED4MSgdERl
         HtX8M5CJXxvUE0lxOR1trobtBp/7SUTohMZVuz8+9CKNQzSrC8VpEQrzeP2qBGI6JPh0
         s8S83TwUcITsTDisabgVEVfBE4s23AxnElE5NAaDRbmdaap0C17i9SOP2ViQrxtalBVd
         rMUfNjzsl1sNRwPXwEuoDErd+iqYDNXaMLI+8J0jxhtrqdR5ML4jlpbysMCQ3s5WfD5V
         MP6G9t6VUDbgEuQdA/RMNNCLK1SJTm3DGmeX+vxuE68c9q5cwDH9/OI+TJvlmJC7sRIM
         OOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777034256; x=1777639056;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30CzM4Cyi3aFwkoMrw9gUsQCscXsMUPR4XUS+ZTxUOU=;
        b=KXUGEkBylDvjmf3AqnElT1cUN/YZXQ+3K40Sa5MQXbeLHUnFTz+t/Xljaw8exmY+J8
         tQKzH3fiCuElzcbO/3lyObpvTn3LCya8J1Q2htEsSEaVA60r1ZVUkuQgKuT4+il935Oa
         vYNCijHG9ojcfs8V6wShbzbnIWBlG/ry1MC51lbW+KKkA73wrjJVr8UmXHAzCNMIISdc
         fmCZBoxuR8kyJyBv8SuxRHVEVSa67mA1sWwHyfb70CYzkTBGmRSX/GPf4X9YT2PKBhAp
         TXq9VQmtmQ8px+22JCbTm+QnMjdbG87CXbwvM1fRrCAau/QQNrmrVQyeg+dUkB6rCRi2
         kcOg==
X-Gm-Message-State: AOJu0YwwAFkEbHk/pTzQlQyZ5ZgjNbxUcWvdQQMci2SKY2Dag2JGmOev
	k3BId+ISVcJoJQrYZ8xR9bZ+Q6/X+RUtdRCceCRwqoy5/Cz+KlL7o0+s
X-Gm-Gg: AeBDieuee2QSLDOB66VoR/WRSimPd9wnyxHibJXmPpLHtVxLpdq6ECgi7crxk4+6cTv
	U1PsMFy41ywY6kKUnmrpsiyOaAcIQMZL7ggjLHI6Ob5npRKGHl3hkp8bQJPZVOP/WPxc46kTNEk
	iP3x46tC8X+iVwCI3lXzcWq0AJH+rxdYHWOBuJmynMOrjmhVJH4eRayuNC11+dujogSfC4kjP1p
	grcSYMIG0uHlNXqMr2Ln0gKxksq8PsBmDlaWkh4tfk0fwfbYV/S6xtjH3cE6BEEGgVMMbejrZeN
	c4dmpP3csGVzDIdzCUGl9xSur/Kas7srCvzQDdNhuMt9uPJ9f8iba3pCJlE9yq56EZ5bVoxvaj3
	iISX6GVLsU0XOhTILa3XSLelIXsRzdn8tLJ6kmRjCugS0PrRrTQX8kQfWFfAS+gXc0V2mA4Jc1h
	V8FyFwVNP3l78BX7vFhwG5ZFbaA48pOOhfa8idmAGR5VOfXFT/1TMP0iHGza0zwLFS1TlRxqw=
X-Received: by 2002:a17:903:110c:b0:2b4:5e7e:34ce with SMTP id d9443c01a7336-2b5f9fb90efmr324443535ad.39.1777034255986;
        Fri, 24 Apr 2026 05:37:35 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cf67sm219017155ad.51.2026.04.24.05.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 05:37:35 -0700 (PDT)
From: kerayhuang <huangzjsmile@gmail.com>
X-Google-Original-From: kerayhuang <kerayhuang@tencent.com>
To: kasong@tencent.com,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	kerayhuang <kerayhuang@tencent.com>,
	Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH] mm/swap: Add cond_resched() in swap_reclaim_full_clusters to prevent softlockup
Date: Fri, 24 Apr 2026 20:37:23 +0800
Message-ID: <20260424123723.1820591-1-kerayhuang@tencent.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ozjzyantfkkit74oigom7s13n51sst83
X-Rspam-User: 
X-Rspamd-Queue-Id: 40D8740007
X-Rspamd-Server: rspam05
X-HE-Tag: 1777034257-328177
X-HE-Meta: U2FsdGVkX19azUEACp1VhmuQl6pKP5QMS5Lv1ElZCHxIL/DDxv5yMQKv1BI5W49o9uCWNDOrkQA71C4+tCt+X4h6mdVCSxrKwV8x9ifTpDrOTGMhkkz1yFas690yB79OHxxDQlyIZmIcfHHnsBxOUK+Vd80Jel193jURMFl6PcWLnaxZSnW88ECzETTYgkmJ7+lb9oNItOlDd8q5+6ryYIIvQRgPbpPKl9QSuNRdOBJBro1HZHGQYtTgMy/Ve6NVs0q1FUXnuRep57zb4Ffa7zaAuSk/pMq+dN6spEDPWB7hAfcTii5CDI1qMWf+tUKkx7aWDZcQaKql2Occ9zP4ECuNWwu1jMjlkzk3VfYSm0i/meppOJ/4o/nrlgfIYUspfu5Blhcq0UJmgv78tmIvNEX4xZVTg6qFKgMxROaqdJjUgxWJXkscrGNh45sP5M5AY/Ypxkb0wshSnuJPGDxe24PPKsrWt3w96/m9aawQV8MvReCFnMhASzVVcx3kjANnGTTAyHuplvZX4hmCHBJ9vWLijHBLDD2hr/27knDnrmAS5bSr26Jirw31qYZ3R63GQ2r3OXGj6ozNdE0jusBOBv5NwZ4TPQb1+NKF69zq9Y8ktXK/GPJlsPQeGWpdEGlYXCnWvcxBuWLf3s2bzsy5O77MBRiTT65pe7hQ+E201jSqobfm5LIaxyEtq4SG6vRP/wJLV7NrIw0ftIuP14eqixbDM7eRj+kbOw0Ub1zVU64+VrsTl0qIPJs5NjcSHr7Kwh+9H9c1DhgOToWjBDgivBnrPRFj9yZ6fFwvcbv1nZ31iXC11AdpA4nucTUnjlK4yILakTRDNA0zLOPu0hq3DSXd8+J1vi1c1ma2QghnNZYGRwIqmGXR67iv3CvMA4y9Ta+VVBk2/Gq4zrTA/JSVmslkUTO01p51yFlNkhRPP3NxKTJsHRlFpCQDqhqxj5IAQSfZbp0ClvjcTSwlJts
 8jMK4IeS
 ywYP3JbphNd1JAaUd5OVNUIfqw0oiVQJvXEOBLF7VFo+tQ4aGBjm9GCqmNJjHUrzuYNuuTAt2+Z5KHHbznoFCz2pfugRa8iujESSg5CDr2andQx5sxSN+BUmjASnpfKrIvT7OcFCDHjXZZ3zcvSCcGm17anWLjgDQ53/SMYljXv90VXpyvlbVtsygZTdtrzuggT6Mtsscrf+hSh3/3Ou7cloetUzglf8x5DejCH2WdK+cHLnijF/T1V+x/wI4Hk0wXKIIvBG6PzJlaXx8UHiCs7p91rVCFCZC9aP3MFITRTYXroGC44YQVtMeHE9r8DTPNI72hYA61S9y28046AubQj7ClCt+WW1CIaqA/4cXz2+GZifNMVKPr25ShELFNR2olSnaYeHmwOCA0to1uS0eIIzVLlZqSgWfZGiOlkgk3atjdkQxU6w+VBdhkJFc3mrvjc2x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add periodic cond_resched() calls during large full_clusters
reclaim operations to prevent softlockup issues.

Signed-off-by: kerayhuang <kerayhuang@tencent.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 mm/swapfile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 9174f1eeffb0..74a1e324449d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1054,6 +1054,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		swap_cluster_unlock(ci);
 		if (to_scan <= 0)
 			break;
+		cond_resched();
 	}
 }
 
-- 
2.43.5


