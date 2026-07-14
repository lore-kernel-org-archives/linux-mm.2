Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D2FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 00:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB2E6B008C; Mon, 13 Jul 2026 20:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C1B6B0092; Mon, 13 Jul 2026 20:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B4D6B0093; Mon, 13 Jul 2026 20:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBD36B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:32:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21A82A0031
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:32:39 +0000 (UTC)
X-FDA: 84985506438.22.2F8957B
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82D0918000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:32:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783989157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Va0eNKIKvKuFzLCgPpEqEkJRX3T73HtPSJIVjBgCKPA=;
	b=GEVyDBjQoU9ASaxRzzIdhEIkW35trKWTrAbeU0mdWnIHk8WKXEC3WDcdzUuJXv4ykrBNZN
	Fe1xzWa94IkPTIaNlTsx4TkwTBYogEYsPKzA5FmcbJVg19Hp/q7rtUjBbfZdsfboyaE7A6
	MmzlOJjtl2upZ4TJB47AUCbU9AFfduY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783989157;
	b=V9GmyMlQ+NvmqXiKJ6TbFSZiCIefxmHmeB49cZKijHSjJ/qP/ulvwIuhfpIPAA2B0G+Dks
	QaJIfHRNOZFq6Jn1BXDxj2W6frCPJH5HBAv3R962hMYdhI/hEb4IZaeBP8lwekPFll68SX
	9KokR6P2OTu9Qc18YVlTcx7/Y//kHj4=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gzgHb41PGz5B7RB;
	Tue, 14 Jul 2026 08:32:27 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66E0WOl1099310;
	Tue, 14 Jul 2026 08:32:24 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 14 Jul 2026 08:32:24 +0800 (CST)
X-Zmail-TransId: 2afb6a55839883d-29373
X-Mailer: Zmail v1.0
Message-ID: <20260714083224130jlbtZQdI9DjitrA0KHUHU@zte.com.cn>
In-Reply-To: <CAGsJ_4xtCBE5cO3-s3ss0t+GuqrAKFRYvT=SyFEO=txDYVq-hQ@mail.gmail.com>
References: 20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn,20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn,CAGsJ_4xtCBE5cO3-s3ss0t+GuqrAKFRYvT=SyFEO=txDYVq-hQ@mail.gmail.com
Date: Tue, 14 Jul 2026 08:32:24 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <baohua@kernel.org>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MiAyLzJdIG1tL21tX3Nsb3QuaDogY2xlYW4gdXAgbWFjcm8gcGFyYW1ldGVyIG5hbWVzIGluIG1tX3Nsb3RfbG9va3VwKCkgYW5kIG1tX3Nsb3RfaW5zZXJ0KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66E0WOl1099310
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 14 Jul 2026 08:32:27 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A55839B.000/4gzgHb41PGz5B7RB
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82D0918000E
X-Stat-Signature: fn96mxspnj7ucwyzjb8m75sojq7qc4ir
X-HE-Tag: 1783989156-980329
X-HE-Meta: U2FsdGVkX19X0ELEPITLFJ2tXUhvJCCKsfI4xZdGs9d2JYUYmDjuxPmYk1nlBehuRIbH/Bi6Xng+duRdDRfq19H5XDB/HEiGzk1bho/6Jur0I7SWKYaCqWpk7dZZJ6gyxm/crD+FIwQt3ICAOK80g4xhtNEWwGfUu6HdTMZbrlQ7pPjTECw3wTaBxh6B5aBQwIkwvdvkD85sIZnuMlV15A+rLIo33GCHIqF29f/RAYdh8nLCOBEyCG3JiD4hNLMLABqqQErcPOaGq8eOJg1IxMmEkgcLg8PkrvjBZWhVo70zVxJRhu8m0cEaEFH0g0HILIr6Bpw0wtfpl3C3JiXH9/v/qNmzZ3yPFmdv/voby+RJOx45Vj7IOqkbt7OZddfgTf4jbxzSrdzciG3qmESr/3UNPBwXG5i85TSWB9b6DhvwxBD2vAcIIX7a4Z9MYWnps3PprzEYy4WJcZygrsXcSAcSAx2UHc0DerfIOzaDOvP+qH216m4xiRGvkKPxpiWGpl0dCV3SvOUvqcDbpiMUd7ZeEAAiG4mdYdK110rrbytWc88jzG1T99N7FBqNvUrWKuNu2fuDAQK1YsQ5OrvtRwx8K33LhMqHJJ0n5O/FNltWaE6Dpo4zz1cZzkWEFkXe0G9fiUFYnic/8rl+j/nJip6kLpGk81cC/ad4+P7/mgPvpoZNWwJfgIhQOHtYLpEHopAaNhpp0XKZvOBFIqnETkckBu+EVH8S93H3n3FAnfOVl4GDUYoZlcvDxLcRCANjNgcurjfspVppBQiNcuMXjyCosSs55U7x2oND0y5tnZJEpEyAR9Xs+Y3JaZPIpVutK4+PxBi26vcQAp2TfSrv6WgZlQGJGk+qLBTC8FKwJoi0uAUrOiEMqhTHjHOXrReHH1Kbm5YmyPDz9gALvLvcw1IoFhTg6LJOG2jsPUKx5/kgs2PHGWLtm84wgpl7qfui4yWj804NS1fhp6NW0SS
 UFYVPkm/
 iEL31KC+JxiZG9jT2nUjVOuAuMAHAHSUOszja9GR3he5MYONERUe3efg4XgX9akqWhELV7+h19VhSU3y70sMCVQVLvlttGYxKc2uAUFvSadbmdycTNkwawhFR0/t6AzWNUYwwtWA6ukgpZ8iObbCuxg9q8oQfmWsL6F4R7j8Nz39GFLuWFQ4DTPhAgwk+Jqzq0Tjx5A3e9N6S9bMMnP4d9/VEE9KTWk8AyMoQb5YRa6g4rWM4IVQMBH4RzXwk/k2kszS7cuhngaJ8rNU9OspiaqZ1DGBzpclO/fPg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > From: xu xin <xu.xin16@zte.com.cn>
> >
> 
> Can we have some words here to explain why?

Sure, my SMTP settings were messed up, so I had to manually paste the patch,
and it just so happened that I left out the description. I guess I should resend it.

