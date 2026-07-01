Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE42C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFAC6B00AD; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B03C6B00AF; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B6C6B00AC; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D53436B00AC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66D561C723F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:58 +0000 (UTC)
X-FDA: 84940472316.08.BC3DBE2
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf01.hostedemail.com (Postfix) with ESMTP id 740404000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lbAjDCrU;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916916;
	b=CCW4OQgxKub1SWpFEUh5a/VKdCEFzmt+5js1ENWxTXCWXaaYpTFHsgP4dV8akomRvGWY4q
	LeIhMIba0Vx5OO+U91G4UZ3EpzysyAB/7GJPualfltYXb5nZFmElLtTknxPfm5QCn0CUkJ
	1sxB7GYOkB0pkRieRTz9uoGsTzDKShI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yeBrKyTYd62MAAuwWA3B/I7+TptJ0cqa99x3wQSrFdI=;
	b=FNhhnCbtHvCK4VbjdOHQDvROJO8S/q3DWR9by8JJe/4fEz8B9nIVq2Ccl9lxpNcBp0LSGq
	k3Z6fMM5j9hXL0fx+tud+kPgM+7d20zN3BiZZKJdifLZtPjMaKgXYcl+bxWMzGih0jYxeT
	ZqlZxACb05QYxSZvLmiag4AYkQh3VJM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=lbAjDCrU;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yeBrKyTYd62MAAuwWA3B/I7+TptJ0cqa99x3wQSrFdI=;
	b=lbAjDCrUqMl8bTSEUK5aeTqv5pmBIm+Y1fkDTzC9HuNIygH5f7cVAKl19EqVqL5A3kg6UOv5u
	JpapKtKsCcbxOTmdWdkR8Oqt7EAkge3JqMU0X0WZa+zLTkTtr71ScbLvj0FDN0KP/Ap6fIoajtH
	8QpckyvFzepqLEu5JxGU7pE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gr2YF3kZhz1T50C;
	Wed,  1 Jul 2026 22:32:49 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9677B40537;
	Wed,  1 Jul 2026 22:41:40 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Jul 2026 22:41:39 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 0/5] mm: mincore: reduce lock contention and misc cleanups
Date: Wed, 1 Jul 2026 22:40:42 +0800
Message-ID: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 740404000B
X-Stat-Signature: w6o8pse46t1tqeueiip4noihek7pohaz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782916916-754228
X-HE-Meta: U2FsdGVkX1/3O0nrIeeF/oUcxYiaVurj7uv9bztf0jib0m+ZKoCIEUS3QskSyZ4Kv7z/br8FCY+Nq5CVghq/Prup70g8DhAFl5VHnayuZKOZi/k6IPlfrAhnbATIhdoN3+QKDpVW59it+r+7dTMU05NqjDnGPYzEJf3oaimHqrujfSdqIDhPoZQkI0IOfClgj9JsK68zLTEKQGdOc5sBgjk1/XBWWMuUXRVW3lmdVDCPl6AjisaTbOPj9mjnAFdCio1rad1S1Ak2GJhEsokqjOBD9rAWIvl2TPmGeAfGCOB4Sf/5L3QhkHdOjCMUttgmGgVVz6Z4E62WuPafe466yc4wQUNQGie2wa7j3pjM/60cd0IqdK20Kc0fcINrQ2hSA0RE+Bgpdvts/lexU4E6gvAqQaEWUY2Z7nLFr0oDXvmxXp0VQsgWgO4hbi9cXOvPPAmyJySr6GQOf7Y16hk28hmXP4VdusrVK/g62SAfAMgMKEsXulDoYQMfIvKCoSNsHib+UoFw6DEqEa4Kc1xe53trshWQ5IDVeZTlZvzYIkVKKVhsttud04+8hK3wharS0l0SXYvIkTX4J0s1mOmYPTUbEDpK9/WAiHaAg6unDis8h09IhYLvXjnvtddBjqflQIj8YegEZ9mXbI4EyhPHtKt4zg5E31QmPt/twQk2+1NM+fREK3dTtnh/H25uym3BAsdDU2VCOWClFw2NXcDN1/gRIiF7vzF84YbRJ1ppntrrLvNLmxRB7w1bKtv0vonJ2fct+3Xb8i960cLUBVybE6XVx6Rz0yeAO7Zwdn4aQYVw186vfv3Fa0maF8LFo/ecmWC+USR7RTM2c5sMsg6nghhhPXOD+ilozOllAbwLdyiYBfwyCdC/3d5+RnQ/diKo7GQOXoie7acxT0w8K5PgJc3skB8UFpTRfc3JDaeddiFu77Mr52H7EHri5tDmL3nmq7yRxH9SiPa3/Fec1Cb
 cWfWXIzI
 DbOjZhy6twEj+MsBGUUz8Dlkxd5bHJLXh7CLw/zAWmul+VNfNy4aIatiCmMVzZuCd/3tMEHDKMR5BpqVW8b6Wj5ArfdbDwMDRaUD7BgLq3bhu/q/oa5A4ZAQUUaNogrqrJMHEiLnyeAimlkB3nhZ6XHQFdwcLGue2Xli/pmTpVAqmCPG4pgQiad+0HiTXewSC6N7hcZuQe7vJB0zks9ywDDZyJ253KqBJbZJ6Uwo5sxwZIPVyoLtfjt7N1Q0CtQ8s/9QCgSfAiZ83UONoGDnZqbeS5FZva7Cc9WY2xwBMDJuPaJaodMs7CorhXmPvQV6/uzU3saOAkE2NlNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kefeng Wang (5):
  mm: mincore: attempt per-vma lock during page table walk
  mm: mincore: remove special handing for VM_PFNMAP
  mm: mincore: replace __get_free_page() with kmalloc()
  mm: mincore: remove xa_is_value() in mincore_swap()
  mm: mincore: improve mincore_hugetlb()

 mm/mincore.c | 96 +++++++++++++++++++++++++---------------------------
 1 file changed, 47 insertions(+), 49 deletions(-)

-- 
2.27.0


