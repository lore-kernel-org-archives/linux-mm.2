Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9800C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 08:32:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAADC6B0005; Mon, 29 Jun 2026 04:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C59246B0088; Mon, 29 Jun 2026 04:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71346B008A; Mon, 29 Jun 2026 04:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94B7B6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:32:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B1FFC28AA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:32:01 +0000 (UTC)
X-FDA: 84932282442.17.8A0976A
Received: from mail-m93247.xmail.ntesmail.com (mail-m93247.xmail.ntesmail.com [103.126.93.247])
	by imf03.hostedemail.com (Postfix) with ESMTP id 043F120002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:31:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782721919;
	b=cj/kM2XscEmwn9tQAI5g7jzE/szGTTgxLg5CiRlnXlxAbCCZO4IhAMWnlVBC5iCsQR1xNv
	EmHov6PpkzjctNtR9tloJ754F1sIQHYb9z6nMqpVMMAtdlidJzgNuijyPJlo2QIKpwSNX3
	ikmnymJvjv7mCtWjRi/1l4mXhLu41zA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782721919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BevwdWB0rh2qYRT/wJtPT3oEDvJ+AlldzK9wm8gokBE=;
	b=KENdZbxCfXIV4ijfr0Ypu4kfQ6BFVVfZv1s8BZKP5aaHadFP65uZOF30BQWggA11Z4MK82
	++kgc5hoqeW/iml4v8N8DxHv/SGoKe7bcxZdg2cxYDKxMgsaLNF0W7X692oNdzC2cmEuet
	L5Cf7kvuUH6+CY4n4uyJ2qPuL0MC0Y8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c062846a;
	Mon, 29 Jun 2026 16:31:49 +0800 (GMT+08:00)
Message-ID: <8762c792-da23-461a-bd19-5976157c18e5@easystack.cn>
Date: Mon, 29 Jun 2026 16:31:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 3/4] tools/mm: add page_owner_filter userspace tool
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
 <20260625043101.338794-4-zhen.ni@easystack.cn>
 <20260624215044.1c50c765a240f50fdf49189a@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260624215044.1c50c765a240f50fdf49189a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f128190b90229kunm1c7606521c68d2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHUpOVkpKTk9OHkNCHU1IH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 043F120002
X-Rspam-User: 
X-Stat-Signature: jxx1ijmgyri53rcqf8b71w4o9ui9h34s
X-HE-Tag: 1782721917-634710
X-HE-Meta: U2FsdGVkX1959ekkuz9wNOIMuO4GObW7C+xMiGYAZsdpjThnK8nqItDv/g9D+7JeqTBSNqdbSnSpPZDj1BTqLtrcScUuvOOOyuxqLlRVEGfKcuZigOH+PHAa3QeKNSQlMzdjNDgM55g2BEQoePs2mLj+z5XnKOFA31lK3T5LqhiiSsaOmLfcHQI7QbHnJRuR1j0UbnXlcEBsv2xepbOzDMxdOEbb/K6BM/atmcIbKCq9XsppIf+pTEqN1xwtr3MVaPll3YlE3d1VfrovL2W2YCR+ErkE03wPgxAXZ09dDK5lDA2M/zuGuY4heIMrl89s/FJhWizMc0aZdjTZgzFkrBHWZSTB8TlDTtIB7V17jfkevezToEPJNkJPiUbR6/kI7NIyy3P7XzlLm1D/mdhvBOT3fQn8Q4UiP3mku/fb5ldSXMT8TlgfTdSKqEX1G+eFRkCXLjsyDxPuDYOwtNMlkUlH1w4/ZhTRaZOcbsi8QjagpIUiw3UhYJDab8pwmyTdPKXEGgFU/cFJxp+Pp93WiF5H9XcvN874UpraZW6VUnOgvE6Fdd0lLgyrzKosTfmrJuR3Db62zGjuQJA6WwNLqH8GO0kjd+EL7vJHWn2jUHb38ro0GW2o0gXBmMNZ4LM9Yt4yrmFAji7LL+vfn71hXjpABzkc9mNmCdmeFO9HXP3Y1WsammN0pNbeiCNCjYArwEnDYev6Uh5AKH7VO8fyj7qtxhRdFqWI/z93hxqROwPh0K9mFmh5Wyn+dx3NQChKqXURw+vgCYlacFUV1ep004NGHQc6qjwSPxJBNUvAZv8DN+ol6acQnrivlnwi+mV/b0n0Me2iCf8SAgDJBurPV3T8sMiWWfMzlBzmYS9wMIG1dcoO5uR4vpYFint8I7n8ZKHbiwx6tFrSjZvO8pxMPLx9LXdkDlTKNriMaQ8L7OTlHsIChO8Lfvsn1x5G9M1/Y/xhtmW3bPTqACintD0
 CrsoxW/6
 9Aq9ThGvcmyOkOG/Qs+UtifypQsmfX1rbI4FDjitCyRnHIK46Qk9I/Lzll2wZYPfgWJPue5eTp2+ln5qKYtgV+kYD5zNhGvv617I0UowaR/9zWgkasNQWkLTp4pwGydYXYOyQJ4z7EGIOLAftUVwuZfWuTIHSNxO0DjcNUVHoKSGaLJI2ygSKqV/JIRQxm2p1sH1dP20U4uLHXAp2HPm462qTobyoDQx3mL+WrcNMoOvZJE1QVk2pEfAG9YwFaM+XgNtq1ZFx1I1PeThNIjUwv5fImNSdcUaXT1bYm+iIPfTBMcrNUAPR650AbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/6/25 12:50, Andrew Morton 写道:
> On Thu, 25 Jun 2026 12:31:00 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> Add a userspace filtering tool for page_owner that supports per-fd
>> filtering with print_mode and NUMA node filters.
> 
> Could this functionality have been built into page_owner_sort.c, or
> does that not make any sense?
> 
> 
> 
Hi,

I've considered the possibility of merging the two tools. They serve
different purposes:
﻿
- page_owner_sort: a post-processing tool for sorting/aggregating
  already-captured page_owner dumps
﻿
- page_owner_filter: a real-time filtering tool

They function like two stages in a pipeline. While there may be
opportunities to share some parsing/formatting code between the two
tools in the future, a direct merge doesn't make sense.

I believe that as page_owner_filter's functionality expands,
it could potentially replace most of page_owner_sort's features.

Looking at page_owner_sort's current interface:

Usage: ./page_owner_sort [OPTIONS] <input> <output>
-a                      Sort by memory allocation time.
-m                      Sort by total memory.
-n                      Sort by task command name.
-p                      Sort by pid.
-P                      Sort by tgid.
-s                      Sort by the stacktrace.
-t                      Sort by number of times record is seen (default).

--pid <pidlist>         Select by pid.
--tgid <tgidlist>       Select by tgid.
--name <cmdlist>        Select by command name.
--cull <rules>          Cull by user-defined rules.
--sort <order>          Specify sort order.

For example:
- Sorting by task command name (-n), PID (-p), TGID (-P), or stacktrace
   (-s) seems less useful in practice — users typically care about 
specific processes rather than sorted lists.
- Sorting by total memory (-m) or occurrence count (-t) overlaps with
   /sys/kernel/debug/page_owner_stacks functionality, which is more 
efficient.
- Filtering options (--pid, --tgid, --name, --cull) could potentially be
   implemented in page_owner_filter as well.


Thanks,
Zhen

