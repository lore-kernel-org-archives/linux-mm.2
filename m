Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0535EC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 11:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAD76B0089; Mon,  4 Aug 2025 07:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C0D6B008C; Mon,  4 Aug 2025 07:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571696B0092; Mon,  4 Aug 2025 07:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 471046B0089
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 07:50:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE66C140151
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:50:48 +0000 (UTC)
X-FDA: 83738908176.08.4EE5380
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id 814BD40008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:50:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754308247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NeEWNZRUDZYDzokpI/DH1h0JZCY/gU5YAXL/+E8zd5c=;
	b=RhdnIs/DMZmos2UxHFaeNwimthuiy13isEiSHGqYxd+/J04jhQbITMdHgNXZXCjdMk9M01
	5sMUrWuUNH1WBg9LglFKuYhK1IuX7BWBtQ5I/oUSZlxXDikGhkKKdSE3DLBr8ZrLU5L/u2
	tm96r3Zgp8EpHLn1b20+2NRpC1k5HaU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754308247; a=rsa-sha256;
	cv=none;
	b=2PlJ1qNsGDLnbhtgODOHV/iOw2g0YXHI7X0Aah2Zfmn0tYQLqB/WmNMZ7Q/CaZYTsY/b02
	J2KBlCUbVwTuqi5P9Udm7xCBzpRmSOvxrlgAUGt0tc/bYICz8xAggvfURswiEyKC2MayOt
	aEJSzkdCtZv6e9Paj5TOyf4nCx/abWo=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4bwZYV2Mn9zYm5N0;
	Mon,  4 Aug 2025 19:47:42 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 19:50:42 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 4 Aug
 2025 19:50:42 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes using robust futex
Date: Mon, 4 Aug 2025 19:50:37 +0800
Message-ID: <20250804115037.19690-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aJBKijr1nR1CleBL@tiehlicka>
References: <aJBKijr1nR1CleBL@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: jdnygzo5e8xse7119qqocxj1cekouuqo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 814BD40008
X-Rspam-User: 
X-HE-Tag: 1754308246-192217
X-HE-Meta: U2FsdGVkX19cnZCMGGI9qPEYDCQ9WGqUtso/1073SFpMLRDU4woRSqRSNMwFBIpWI4gOoTksaANDTX5BQ2m5/Lz7NPqUkhd2nBeqmgt2BJbCbz3cASTxAkQBW2MNyyFcjKgLJhE2Ze9nbnGeNW+R3/4tamK3lnuinNrWE1rDB2ma/egXXO6/u4v4wSlKBC5uFORXiVIaK4LjUtUrB+21TrvqbaNLz/zBBjAfHmW3p846tb6gs41F9ig6VoUiloiaXv2hZSBAL5dAYVTcep1K1qk0M3++WFs6n0rn4btokVMSyMSK1wmvWuMN+Iykw+pQtrlzGwMGMOM3vu117ASQQA/acF1i8KM1lXNRZ+r2wGVyyisgpITdCEw/N92UXb7bEydZFCg/hnFN9144VzEVfRoff0Ko3hKwGzNXQXllt6oIu/qGs6ShfX5tgzwhUkDN/tBs+qQfM+bngAbdf4PY9JGzjOGkALt+j3/27Ju7YVxEomqU+9WLD/9UzvN03480JOQPLxk21xQ8ld2JUIokxsNVGlfx0Jd6Yi2IGEeMD3eF7RCK0Pi/Z2GekiuQbF12ebMobVwSivwLKpEsTqT4TbjTcyTz3mVJaQFJEQ7AzY8nGYD9VhOhz7M1fmVNAUL9NPI6EOXQFSfGrBYl7l6RLzcPz8W1e2xmMMVHTmXPwJXxBYX6bO+GrLqZqhe9G7WfTM8iHf5hKf6U9jBTPmcs3UNOXCA0VHZzOeDo7khOyvE2pyRAKeuPomrCNANT+SdsmIjBr0YQJBv6YC7ux/uJe+ousfD72IgJRodzGEt37xpIlvDHYepCG1nQkChn2fXq/UNVNnQRP2rbSxBB9N6IKbZKh7fSUAm7auHD0BVOgWiWQPlstD7rYQ2XzrTCMJTErmI7pljY569yhZvK1KCeiTz3GM1a7TWgexAc+ympUboEnxzUHTBH5pB43SwynTk7HxnlKNuUa9jid+HWtKa
 /qim4dW6
 TcviHZQM2IOVqeLapw2/HWmgkUHlenULSID5sH35Dpi9D1RWraOo5KS2ga1wD18LqrS6t2XkwRG/Hdnk/QnuN/ml7UkYSVdUxGSDeTq4vpjZXS7xf8CHP2gYJKloKYKqdy8eNOqQOXj3mLm+3Eveit1hwd0cJDVFz99bsb8IIl2abKUSgjv/kuhb3dbklHtmmspMIsYHS6E5a3XxD9r+tmmXsVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
>> From: zhongjinji <zhongjinji@honor.com>
>> 
>> After merging the patch
>> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
>> the OOM reaper runs less frequently because many processes exit within 2 seconds.
>> 
>> However, when a process is killed, timely handling by the OOM reaper allows
>> its memory to be freed faster.
>> 
>> Since relatively few processes use robust futex, delaying the OOM reaper for
>> all processes is undesirable, as many killed processes cannot release memory
>> more quickly.
>
>Could you elaborate more about why this is really needed? OOM should be
>a very slow path. Why do you care about this potential improvement in
>that situation? In other words what is the usecase?

Well, We are using the cgroup v1 freezer. When a frozen process is
killed, it cannot exit immediately and is blocked in __refrigerator until
it is thawed. When the process cannot be thawed in time, it will result in 
increased system memory pressure.


