Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04021CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB1A6B0103; Mon, 18 Aug 2025 08:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884E76B0104; Mon, 18 Aug 2025 08:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A566B0105; Mon, 18 Aug 2025 08:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62A506B0103
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:08:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1FB8D1608B2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:08:32 +0000 (UTC)
X-FDA: 83789756064.08.FE54171
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D84DA0009
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:08:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755518910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WwHR4L38YBvpbyc9IAuaJrYktKE14RCUIzI0kvQgQXs=;
	b=lMr8SDTQZ5KjKVrEcI8HrOsdHK5fTxjjxaNiCPrZeGUapgWMN/lOl2OEFnaai0AgZ343Pm
	9AvKCSb24uF83BpjrUdfz1O37r9HzGKaA7F7LkYyZL0FDftKXbhy+119laNC/fTq9sOh64
	Dmj+ldbltts9U/49zEQJ1ss0wMKZO/M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf25.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755518910; a=rsa-sha256;
	cv=none;
	b=jpBn8GT9HFvoMMaXFTI2AMYRRBu3MC2I2u3zgqarFbwfRypZP2ZD1oiQBKw65gt2snTVtw
	X0cNm9IKLE3gYJnn1TW5fMAke8vOOWOH/0sZG98NHcPlnj0XB1d5gocX/M0uE0Z4jFnrzm
	OWK+QceYXezV9HbzvHOIeESjcjbwrMU=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c5BLj5FtxzYl6Cw;
	Mon, 18 Aug 2025 20:08:13 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 20:08:24 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 18 Aug
 2025 20:08:23 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <mingo@redhat.com>,
	<npache@redhat.com>, <peterz@infradead.org>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes using robust futexes
Date: Mon, 18 Aug 2025 20:08:19 +0800
Message-ID: <20250818120819.26709-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aKIvd4ZCdWUEpBT_@tiehlicka>
References: <aKIvd4ZCdWUEpBT_@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D84DA0009
X-Stat-Signature: g1duskmwan35iwmt4xq6qnbjpemzdk18
X-Rspam-User: 
X-HE-Tag: 1755518909-605016
X-HE-Meta: U2FsdGVkX1+8+fLT2Ugn2sfHT1C+On6VpEvZl6ckR9m2I+1tH4oWu0DjDOAFVTMqMY/D8drdoD2ACvWk7lrE/Z1+5FwlI7V9AzcntE+nf2MnTit5OgKHTg9SDutaaG99JSAn+gZ6G8+qqbzU/RaRruMELFNA6HV6g38Wg1loFEXVqQRST1206wly+46NXkOgDcv/NCDTZcHnrYJSz0eA+83D8xetwgjid4qp5VxiVzAqN+kYJt3I8VH0i4Ej8yVnXQi7Pn6DW+B3w6/PmNBylyLU4VO6p6JM9rp4LTQAxbTGdCDrpAcmpdhst2IcATd8Rtf2FAe3LFy218otDJDGT4NcBiSwKbU4cMMbHlu5UrlEgYQsL0f0e+s2nNqTBPXyfI6qWfgwm7hcJ6k+0tiF0uwNFvGDWSxhm0tvp8AmaWKNl5Kbem+BJVmXu++9wKnZ+Ye9sy2duJYviQ+hk/Lv3sp3X7S8rgvVm+kMDukxR+4cJxMEumkIARlo3sL96OglUwIK8B1Vh54bzFbqiGedAih0BJQU8XwVoP4p+lZMS4gh3YPIPeXlOTGD+OL1VD8VcG4Rx2W6huqiHqPgyT2iH7SOvCucraSE3/mzoXhKbXlO+fZCHdKVWQdWI5Q/X2kY4+k+uKE/Byt9XeZVQaSJXGO22N4ILpCNSFuOexSDZQ6QD0/8vAx8GTQGz94yhyUAwreO7e9zbbqdYXQoW5JzqE4SniqPzgLInj+PD42EpF2v5U40lmxv/wAJ+bAPh1xLoAKH6KE6BKZVbekRs+/TdY9RrS785G66e9RyXsJZtvTej6P+CBoeUkJWDW+gN+Vv81at7aqF7/iQEYAREUVdMCyfvR2T5N42WnVAeuj0yxK4/BEi7IuIi+m3pz7e8jFPQbcl/5QXuj5cQcyKXwpmmtaBVK/VIO9R12eZwThCtIpbA8DIIo8zOb4S+69m2+w4iATP3F1SULY66hS2FLF
 Ws9RyWnm
 Z5dcBsAXc8FWB3IhTxJLN6QVdtu8rY79shSKQoDvY00zL0pmERVOlUTpF2cp3YlxP4bq9+An0HdJlUGB4tI7xLi+5OSqfEsx7rSo2eZ1OEaNJqkr00LxP4Zhh9cpRHE5sP8jMWDxxGtNxbo0zYONHt6MwbU3BLv8HfPbMTvwL1a2f2tqlnyh5NZexK8M7qcESRfJ+THPumePS5QR8sdoSb77t3INQeZelxazemlRWOehckSwQPWYFzKaHrG4GHZq67Frcw40xirJGVaA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu 14-08-25 21:55:54, zhongjinji@honor.com wrote:
> > From: zhongjinji <zhongjinji@honor.com>
> > 
> > The OOM reaper can quickly reap a process's memory when the system encounters
> > OOM, helping the system recover. Without the OOM reaper, if a process frozen
> > by cgroup v1 is OOM killed, the victims' memory cannot be freed, and the
> > system stays in a poor state. Even if the process is not frozen by cgroup v1,
> > reaping victims' memory is still meaningful, because having one more process
> > working speeds up memory release.
> > 
> > When processes holding robust futexes are OOM killed but waiters on those
> > futexes remain alive, the robust futexes might be reaped before
> > futex_cleanup() runs. It would cause the waiters to block indefinitely.
> > To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
> > The OOM reaper now rarely runs since many killed processes exit within 2
> > seconds.
> > 
> > Because robust futex users are few, it is unreasonable to delay OOM reap for
> > all victims. For processes that do not hold robust futexes, the OOM reaper
> > should not be delayed and for processes holding robust futexes, the OOM
> > reaper must still be delayed to prevent the waiters to block indefinitely [1].
> > 
> > Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]
> 
> What has happened to
> https://lore.kernel.org/all/aJGiHyTXS_BqxoK2@tiehlicka/T/#u ?

If a process holding robust futexes gets frozen, robust futexes might be reaped before
futex_cleanup() runs when an OOM occurs. I am not sure if this will actually happen.

> 
> Generally speaking it would be great to provide a link to previous
> versions of the patchset. I do not see v3 in my inbox (which is quite
> messy ATM so I might have easily missed it).

This is version v3, where I mainly fixed the error in the Subject prefix,
changing it from futex to mm/oom_kill.

https://lore.kernel.org/all/20250804030341.18619-1-zhongjinji@honor.com/
https://lore.kernel.org/all/20250804030341.18619-2-zhongjinji@honor.com/

> -- 
> Michal Hocko
> SUSE Labs


