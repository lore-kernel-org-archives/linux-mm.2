Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E05C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233156B08F0; Sun, 16 Aug 2026 23:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3D46B08F1; Sun, 16 Aug 2026 23:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA1C6B08F2; Sun, 16 Aug 2026 23:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF6A16B08F0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:13:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7335040667
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:13:13 +0000 (UTC)
X-FDA: 85109290266.05.D01A05F
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf01.hostedemail.com (Postfix) with ESMTP id 97E8640003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:13:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nOv0PWhk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786936391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2m2gkFnEIMedh4SD2cdL9BF+Y+jc08sxrvLi8/Eepho=;
	b=NHC/1CG0wdiTiJLCYQvMzTihDV/Zim5bjN9XcLdqPTEu+QpIU2APGxn0h4aMWsXgNHg63k
	7zcXMrbZR6QeYmTxHb94mpYMuqlM/iIZuUUBUvzQpifPeHcw3FMwFet+RXg1N9imHWF+Gl
	FyeTAxfK138gb/uaDyqZjWd1dFamD2Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=nOv0PWhk;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786936391;
	b=Of4pPMiTrs1Bmy0yw+4uz7bJdbqpVqqE3TSZTI2EdErznkE7NCyZKJpw75D5MANcOMAr7P
	yZtao9pX+AMgxDj60pq+0+NrVQZFguzbEZ2Smvm6qmZbq25SqLvcOpxjP/KKNhkMS+Wsws
	qXWytkQ0RD3rTFy3pQkF6bFJulS9EPY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2m2gkFnEIMedh4SD2cdL9BF+Y+jc08sxrvLi8/Eepho=;
	b=nOv0PWhkS5CZro9o5eu4i4FZs0VQ3eCZGJDSQDGkZORH/3rp2j9GpueqJpr/QjtRQUQJEWPe7
	EosiAhoILjeCBf0vepfTBWtcscZeq8UlL/n9PllBdmv5o2gOCATMmyZO6m55fFS2/mFhi9vsOZw
	/uLEvwnBPKpRu2wcIS5V3JI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hNd0v02tDzRhVJ;
	Mon, 17 Aug 2026 11:02:23 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1AFBC40538;
	Mon, 17 Aug 2026 11:13:01 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 17 Aug
 2026 11:12:59 +0800
Message-ID: <4b9293fc-82d1-4776-81d6-d7463439c1ae@huawei.com>
Date: Mon, 17 Aug 2026 11:12:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] docs/ksm: fix advisor documentation and comment
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <an3VdkvUvLapWzmw@lucifer>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <an3VdkvUvLapWzmw@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 97E8640003
X-Stat-Signature: a8b1mqhc7xbpeysg7xbf8kt9bf6mpfny
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786936390-790617
X-HE-Meta: U2FsdGVkX1+71rA7S5xmwdwvWY2g41CxH8C5cnFBnvTb1nMm//ejXqxLYo0xPW33Hr9dXKy/1K211w/epHRPoTbHFZ+1y/qKlM8BqVimnzTkAUnSMfaaCXH5dtUF0T+Xmvt69OFy3vAIWbT491Nm/ZfuNthBXT1tXLowaTtcNezSEo4rBKiToz1IaAgHO14gRkem+KGxNApGUD267WtbPPoQFqcNhlKc32IoR2OhHA25Ed6QGza56S4yn9rwjF1UosUadm5jSxflwRwLK2RJHz2Po94ZDGmKSft4uJsYOMYZ7oTZGoZZeDfP/Xulv+vvC8v3X1h2SbjYKwxQPJfD2B4YbX+Z8bik3XkUH9xcFwho23B8ENAhk7A4qrsqrmh1YXzuM+V8EwLpMCDe71Ov6wRARJOx7R2XB0C3WTqYgFRcEw4I1gvDgSx8xQlJ68FSaKjueIurXtAB0WZz+1JvJT60wMoDnK9IssC1jJ3j4A7PNuhxfQyDMXigzLeJaAEbf2DRDGTjUt1/h6EnDdKOszM6uvLKxoznWVLE60YFQ4LJh+4g1AyaPh5ZGywQHlRrtdlY4SRfY5IpUBWK3waI3z/h94jSVtXqM+uXL/xcDW2xW2bs3AmIZQm4KGaLq6BXT/0mlJK/HgbA9Xj8pznCUYt1HKIBE2VSJySRL5sjZJnyIcWyFs6NIVDtusVr1v2BAOjat1bC5eue2X7E7UwRM0NlYYJ1u+eUOMKrRTycIt5JVP/frMPTKAgcad47YdkvwvRRvgFqocF9hy8fAhG1zS3Bebz9CHg9kWA9qSNha4cTKEvgOu196SWW6LssFTVc07+Nd4c1ejvoFBa4gbvRu1b5phU+gQyKiYc9vgBh0F15EuEtTmarBOiJr9vAxW7Y8X+FjihwbtS/NsZt4cmWoO7LDjKwLSGK7Z42rbyOQ8crjywzJNnRwpW5NXMqmTZdG0Sryho8iWbNkBql8F+
 HdgbpIwi
 xSHOWLICdfOT3+u7HaNZ8CAf7S+8f8eEwTxRIO9tL3qdV8mcV/hY8BvlqqQc0l/VbqaTd6CxCdNpPfxzd1d4Mdk+FzwmAsVaa2aUw6977H+cm9CtnW6d6tZFZeEIqPsi0BLZzs8IJH9JIPJ8qBtkxNVi19ZmUvt13kJ69aCosdwLZotomhsx3NjRccc1U+sphXDD6wzzVmt5krYZvM0E/cV8DlkjlHyXekdZJj2KmBOBEvbnFgPH/6T0RZNcl/p+eOtwgtf0FSKbgflKaSb7kFC5mZs6qA8xMcXJjzXGKsNHsb+4hTDcOJqgK6C+uAR7Niobb7SzKBISAi1UEY958bT7NEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/13 22:35, Lorenzo Stoakes (ARM) 写道:
> This is a very bare cover letter...

I updated it:

This series fixes two problems left in the KSM advisor documentation
and code comment:
  - Patch 1 fixes two typos in sysfs knob names ("adivsor_max_cpu" and
    "adivsor_max_pages_to_scan") in ksm.rst that don't match the actual
   knob names.
  - Patch 2 fixes the description of advisor_min_pages_to_scan: it is
    described as the lower limit of pages_to_scan, but is actually only
    used as it's initial value, and the runtime pages_to_scan can drop
    below advisor_min_pages_to_scan.


