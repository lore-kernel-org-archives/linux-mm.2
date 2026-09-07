Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EFBC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B346B00A0; Mon,  7 Sep 2026 10:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5606B00A7; Mon,  7 Sep 2026 10:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795ED6B00A9; Mon,  7 Sep 2026 10:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490C86B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:14:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC21D14018A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:14:25 +0000 (UTC)
X-FDA: 85187161290.01.5E7406C
Received: from mout.web.de (mout.web.de [217.72.192.78])
	by imf21.hostedemail.com (Postfix) with ESMTP id E303F1C0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:14:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=XXqSvEpl;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf21.hostedemail.com: domain of spasswolf@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=spasswolf@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788790464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GnMP+KCTCgbdas0U1IyYmNs2t5yhn7KLiMgPLuSCKsQ=;
	b=qLzv5QvBW2jNfLNc1L0R+NQcxi4OeZN+MNvimZFn2o7CdfA7op+Em5A5O6DwZ6V3SIBXt7
	rfUzdV7TKAw1ISfj50S+hbUXEEvXNjtMS+1wyS3GZ27MeLmay+LjGN+iBaoiVeSsXhmxCG
	ZuEHl6C5hgNdKF3lgRiNnPC/gEyQE6E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=XXqSvEpl;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf21.hostedemail.com: domain of spasswolf@web.de designates 217.72.192.78 as permitted sender) smtp.mailfrom=spasswolf@web.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788790464;
	b=2tw7TBGutYULRusvyWdZCGsdLvSdhijGMVhsIZSRMpL8sLHymkbtnvdAE4ReeGDzVfKrpc
	c9Ogq54OBwClW8riLCQMcyCJA63fC5TwaBEd8MMCOR9bDd0a4M1z8mAhNF0B6eTC6/7T3y
	Tm5FopQSO5ssgf22SDPSeY6x0KcEh/4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1788790451; x=1789395251; i=spasswolf@web.de;
	bh=GnMP+KCTCgbdas0U1IyYmNs2t5yhn7KLiMgPLuSCKsQ=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=XXqSvEplLPQqQ6WvMnrz6pXmAZhDLw6ROp3FHe97qI3BdW4yY2Md1VnfHsXmnxqS
	 4+xuKVwtCSBnX9o6bxg4XOWaXZU4nHoUGT1JDsLJfS3pZNKEhss6s1FjOgF12Pgyp
	 97LtnLaMnxU0AdToFsckmiDkshlIwKcgk4Pu51KnpH/vO1d7wLkl0NNC7kFxoeymN
	 vnA5Oao/EKXFhkgKi+IvhqxINJd1OI9uaxym62/wTjbjG/PLLWXF6zMXR4bNRt8f+
	 gUVJOtCTwSLQUVhFgBF8wyKcD3eaahofMVtbbKBPtYHCBnvu6/rZT9TmgUZCI1tFy
	 q6WIymwC28LD99tg2A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MgiXO-1wMZFn1Y0S-00cL9v; Mon, 07
 Sep 2026 16:14:11 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: linux-kernel@vger.kernel.org
Cc: Bert Karwatzki <spasswolf@web.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-next@vger.kernel.org
Subject: [PATCH] mm: memcontrol: fix compilation
Date: Mon,  7 Sep 2026 16:14:07 +0200
Message-ID: <20260907141409.215031-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G2vb6+5FFlvznn/JhEyhzyxR3dV+ribanwtr5FETGq1US3wHy9a
 Cp4Epu3nkl5eJh9BkXNyP7WDCvmxo15b2Z4JRU9GrXnDpskX8A0cEJZLovEvhnHnQa3K4J5
 b3hkWmmo6PYURqKLTQ1jF6Ar2s3dylmlu2ykY/eJqgjp6lZkgTVHnyrhxT7n/h846kDFO9D
 pvFUaGhKiRRRz19R5XEYg==
UI-OutboundReport: notjunk:1;M01:P0:c1+siLfUC0c=;8UNvdyqaiO1qxa92hmCgFR+9yR5
 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
 ILVwGsk9s+Dk8nqovfBotZ
X-Stat-Signature: cqmxpz1smhjk9skw4ekbo3y6k5exudje
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E303F1C0009
X-Rspam-User: 
X-HE-Tag: 1788790463-711131
X-HE-Meta: U2FsdGVkX1+mmzQtSD22kYB8lpa6sd+LNQS2Izqr3aYMdUDkgWYWZ2q1iXQk8aRwVeL77dWonZqBe8ajii3wxCQ/Uv8sPqCVUPDmeHDGAF/3Can7jbh3s6E1nAdHLVwpID10L1TfBcM8xXmmgz+h4O2ypxDgsNEw1QAMj/Kz5jj2UluRQFlhcbQZy84c7RkSdhyKpRQSsv6jZXnhSBbkEb7J01MUSHVe+uEdH2iQwuRBUX+bU4jJR4+tcqj+y8HI37de3DLouHDyxLlq3Nfr43rFrtjfBUTyS/Jic200Lv5K632hwbjplww9K9y4JwK1Jin+BxIr+1vKOVrlAiunyeUYBelBisDz+OG3cDgvkADIp5XRCuSuB06tj7qTDjLrV/alY1FR/RgnBrOK3Ozvl/q/Gengafr6sm37kRI6dC3dqwXT8r3XtANiRUUGrIbaUlTxlms+wp413thYIkcMigkW1Vp3t6XTdXAWCzl499yfMvsN/vHEHd5Jvic51UQG+hzSusA4ZwxsvRxfWgVNjO0bmWxo+gI8JZWpuMKcndUmQKZdQcGe/gJZiof30xOz58RF4p9DK8IKyp+YlDTxLwm/qyBKIy9wx99QsnPo9LSabVmeH7q4N6w/T3JKvDlRbgzhVg9ShHeWnavo6bqmiYxKfwEPcCAYw6Lh1+8quTj0gS3Z541ptHiOoOjpcx2bNcOgnPqUs2MT8KDrQJ9DtQaiFG5ErKrqRHVBTnV1fQfB2as/Z1kparU/Zb4Tu4oSXSqu3EeiBPzyMdDG/2GSNnimosKE0Vxv9hphGGpbgWRCuw9sME7edR3Movln5ylfVkRjHRB8bRfBbdv3W9RKnIfMs/C2FRGkQSBCFRNOhPnMuB2C3x4z/53nlZMpEOhpraO5RO/4fOIBl0rxe/mQYhog4w/PUWu8rfgtvuFbSUdnTeEc53ynEJ1xKxBc2D4S6lfn7pZqJjh2LD7Bc6G
 S9/nPHy2
 ZopErNWLPTH8TjIXmbrRg7cwsE3KKLED/L1nNOtGzjwsk5MYbZHNBxydZ4ZsICgJsz6XRkzhoizvS6ftQ3F+QVr5JWo0VLHhDZsk5IBA0KH0OePPirqdwTyWnzTXJCVLLJgQ/LqwISLYTbxBEb/UyjIVZzClAmHhQyZw5t5OsfTX0EPjUpSkhKHAVbkTx7r8vYzHCXT7oXGCClW3kMabPgGuQZNxwvgBSIMsAWfjetTjUXQwtYJLv9Nx5T5pl/9uBQAztx3sljJhLA0fpUVZeX3pi6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
=2D--
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b9e0ebd42ae..e50135df6e82 100644
=2D-- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -71,6 +71,7 @@
 #include "memcontrol-v1.h"
=20
 #include <linux/uaccess.h>
+#include <linux/irq_work.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/memcg.h>
=2D-=20
2.55.0

In next-20260904 compilation fails with this error:

mm/memcontrol.c: In function =E2=80=98try_charge_memcg=E2=80=99:
mm/memcontrol.c:2859:41: error: implicit declaration of function =E2=80=98=
irq_work_queue=E2=80=99; did you mean =E2=80=98drain_workqueue=E2=80=99? [=
-Wimplicit-function-declaration]
 2859 |                                         irq_work_queue(&memcg->hig=
h_irq_work);
      |                                         ^~~~~~~~~~~~~~
      |                                         drain_workqueue
  CC [M]  drivers/usb/typec/ucsi/ucsi.o
  CC [M]  drivers/usb/typec/tipd/core.o
mm/memcontrol.c: In function =E2=80=98mem_cgroup_alloc=E2=80=99:
mm/memcontrol.c:4234:9: error: implicit declaration of function =E2=80=98i=
nit_irq_work=E2=80=99; did you mean =E2=80=98init_irq_proc=E2=80=99? [-Wim=
plicit-function-declaration]
 4234 |         init_irq_work(&memcg->high_irq_work, high_irq_work_func);
      |         ^~~~~~~~~~~~~
      |         init_irq_proc
  CC [M]  drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.o
mm/memcontrol.c: In function =E2=80=98mem_cgroup_css_free=E2=80=99:
mm/memcontrol.c:4443:9: error: implicit declaration of function =E2=80=98i=
rq_work_sync=E2=80=99 [-Wimplicit-function-declaration]
 4443 |         irq_work_sync(&memcg->high_irq_work);
      |         ^~~~~~~~~~~~~

explicitly including include/linux/irq_work.h fixes the issue.

Bert Karwatzki

