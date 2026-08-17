Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A5EC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 11:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 874DA6B00B2; Mon, 17 Aug 2026 07:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C4C6B00B3; Mon, 17 Aug 2026 07:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7891F6B00B8; Mon, 17 Aug 2026 07:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585F66B00B2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:29:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DB1151A0741
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:29:39 +0000 (UTC)
X-FDA: 85110541278.05.C2D92FE
Received: from mta1.migadu.com (out-126.mta1.migadu.com [95.215.58.126])
	by imf17.hostedemail.com (Postfix) with ESMTP id D0A5340007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:29:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FQCDfwQ1;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786966178;
	b=Ne1BZCck8s8u5HelXrRiVlOay/A7PVoojRjqIrFtJky+5gzlrXGimVWl7/FQkD5MKN3s8p
	GAPEQIaOB14ZNBMEZ+p2TiohXrdTdgNNtcgl9g4YjpiKaFMjvAW1eSC87134sKXifgetZL
	EAh0oS+LNHrE44YZcKlgHNbkMMbFh+Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FQCDfwQ1;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.126 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786966178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCVHFjCoJCDhU8nWVYdXDPl3Sitt70Cj77o6Y2o/XqI=;
	b=rcghyBokHXlxU+282iOW1enrX3OE2AC+yM6yES6kkbDmq+Yt7KqeTY0plIecXyhSJrjxQv
	IrAlRm5Fw2/DH3f3IWIzOJcMRsDmKeKWcZNWnvinuZOqVgX7Qx2cggOkH9OhFWPrt0K/KU
	RyxEzB592pESRQhLNrWHQaO5tyBavNU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wCVHFjCoJCDhU8nWVYdXDPl3Sitt70Cj77o6Y2o/XqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786966176; v=1; x=1787570976;
 b=FQCDfwQ1gMFZvJTCmRxfcnZ1UflzOtz5jlvblwxwSyFXRiFSGWtv31KaZ+QxLqIqWfN4sqKq
 XqENtP4ExSoGef0V9XdK84LSJy+/QVR8mnLVgHYLXsskcfRB4n5xReDjDEPF2Abz2ogCkaMH3f3
 ZqEglMhOyUmTygQf/Oh/2iqM=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.4.50.126] (221.194.171.228)
	by smtp.migadu.com with ESMTPS id ba7939d909808a56;
	Mon, 17 Aug 2026 11:29:36 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <c13d13b9-6f2c-4550-a1ef-7e5e1c1c2777@linux.dev>
Date: Mon, 17 Aug 2026 19:29:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm: memcontrol: make obj_cgroup_memcg() handle
 NULL objcg
To: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <09bcf74312246a6e4146be8a0cb9787f8beddb28.1786955972.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0A5340007
X-Stat-Signature: sfeojjd7gju63nsktektedpwsefbrtit
X-HE-Tag: 1786966177-583290
X-HE-Meta: U2FsdGVkX1/ZE1fougTQpYfO2gdSqm8AtkjfMMWefdMWDVuJ7Pr5/D/OHaTdn//J1UpUZjbDFnPrIeFzCOCOwRsGkwSxy1sMBaXV51jiWMEXejmjXWZiIEpXgOsGM8cMsDz6IRxg90ZaejQZppKvpT+KrNopQBGXIQWUDRmFbMkV6IwQOY8OGWffRBHaH0+rPwaWe22vrP26ksZ6RyMXrInH5krYpHcCzQVAItgfZiODu5VIuKwzKJAo8js3k19FyKqB3GLFXQn01BnSY947rWE5gHihbLykRw1GLOCAQVK7oJD6jK921EysYNgPxL/my/4LBlqZRA0jlzfOyj9QW8wZXpg3awBRPBPdSjD0WFQnEfdgLhg11c28Ih/mLPNgYq4WGgrWZ78jAPXIBoJZ+5Uyk3KHSoaW4a6nVCXNFBOMsENfZox0YG1tsserNF/WrwsBC4UxRJHqcwx7+Z+3T5xIIVEkkbO2DZ5E0zYeuSeWylBXD+UyHRQG0VMsYcwPIKTGRJGoCd67SLxt4R7BKHzhV7z5NsejsUGbI7ySnd6TzHSjW7jUEhql+HSGjWnjUuhJBRyYAIWCPa70tQtGYmo3Y2fssD61Z3ss7Em0BnB5GBVRmMUAUhtA2mHfGZqDndhEdqvYW+1hCqwUsPPuHo8Q2RlHDFYbwab+JX6uvxJo3t5vCLfzF2Kxk5FM4WXZlSPfT5t2/eabWUKW718SYhvURaNx6luCqeVK1E6dg/cO9zQBOzc9lrjePXCO1xB0mrNocLP/8yB0hV7n7ihxWURL8wQ2AAw+2ooLAzYUR4OvXwJsIj0AYNDdKiPqvj1vHIeihHG42ckOZZADv25Dm3yin85+vCxZfhGwsb0+j4mSr2sHBhCIg4BdBDXRaXciTC8MdbKkqtU5DAaxiqRPazub4THapmi3PMWcnudgWHM6kWIlFRLi0dsgN2O1VNfXLgxUF7jITbb3+AyhCY8
 dJaW9KOo
 f/Hiz7smsWvrIrnn00qkRLjR/GoVEpFFnOHtkl7XA+iz8K6zYaI3KwUo1ng94c4vXxFi+yYi3JBK+HPVlwXNfoBs6PAQmUrYhaPiZETX4ruU7TYdKxpSFPSWO7/QGRS/71lrotCRWFJm9Zmo0U1I0uWGq0wBPihJ00xs7hyVzzhxxG/wcWr+CcaUyaRDvH1XlTb8UuVqWfiix7tRpt2db9V//cy9/BDmhjUL2QNlQKxwx0JYZv7kpOOvp7UNNLMtFUoLnEbZiQt/3dh0FVCuvnzwHbCJLQWhVZinzfMiVJGsYfVsGY18WABXVQYzwhHOphkpt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


CC the maintainers of MEMCG who were missed in the previous email.


