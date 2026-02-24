Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E1FE9B260
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F8A6B0089; Tue, 24 Feb 2026 08:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947086B008A; Tue, 24 Feb 2026 08:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8497B6B008C; Tue, 24 Feb 2026 08:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70E816B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:25:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39A0C16010C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:25:30 +0000 (UTC)
X-FDA: 84479422020.09.72D711C
Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57A4540006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:25:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=xma9dofd;
	spf=pass (imf27.hostedemail.com: domain of re@w6rz.net designates 44.202.169.39 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771939527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZm0B0zQQ6hc9a/7TFYjP7sWkRc5ghpuyKwhkfv3bWc=;
	b=Ya6izaoNf5Y5XX3H0Zdv5sg/TFkGCoxdSZE4g9j8VSLglG/x0LRPsXHuQequnkKNQUHYDd
	uk79BzsHhNiaAu+slDIWeJerJo2aYk0Kmro2oLuAce0CqtHQ47fR3CoroOxpnoi7EKHYxX
	9Vl8IbW2EihcQHgPzz6L0Hlxgl1QUYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771939527; a=rsa-sha256;
	cv=none;
	b=tHAyo4ftqrTNqgBkNfwptO2laqbOH/dlcX2g7EpEf8kJwyykZjzNyl3BRGnXH7R/lCr2iA
	XWrXMgZTOM7/WkzhBY7EkefNdcENehLMh29HUFZ00Hvl1zyNouVi9huRjZuL0OlXkOsQ19
	UXnTBvekCzxpsTquBWMLPr5unBYvkgg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=xma9dofd;
	spf=pass (imf27.hostedemail.com: domain of re@w6rz.net designates 44.202.169.39 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id uq7QvA9IeCxrGusPmvTSba; Tue, 24 Feb 2026 13:25:26 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id usPWvIOPbjAxuusPWvw5Gr; Tue, 24 Feb 2026 13:25:11 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=699da6c6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10
 a=18PHJyqfMDr_zX8ZnccA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kZm0B0zQQ6hc9a/7TFYjP7sWkRc5ghpuyKwhkfv3bWc=; b=xma9dofd3wNOQg/PFJ6wPvxaoB
	UDQ917OjDgfcK1pmkAuqFEp/YKrA+Ed8cnQIfAtIbd1rNCrBN/TxafOwyQGlvIbCbZnmv5PK5wDJM
	DoOgs3NunHOOALt9JBeOt/QozKfHOnlR00Z0Br58Rvs/+geBrR8sUWWdVRW3D3QdgvfFVWj6EKxew
	2F6/vGmmHxFua9dMM4Rsxmtvfkhdyt7UpDx7vWcyqCpGQRtIfxWO2mdYTSr0ReLykKhp/DzXSAAUO
	claCRrGqYqxhTNe3/ceZLZPbA9z+fHKEEXM+sIsVijdDh1gvnQNHsXDylY9txKRL1uXv1Mz5Y/6sz
	QHXIh6uw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41940 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vusPV-00000001sk3-3mm6;
	Tue, 24 Feb 2026 06:25:09 -0700
Message-ID: <30dd1efc-9bd9-4664-999e-610d181600f9@w6rz.net>
Date: Tue, 24 Feb 2026 05:25:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm: Regression with v7.0-rc1 on RISC-V
To: Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc: ziy@nvidia.com, jackmanb@google.com, david@redhat.com,
 jane.chu@oracle.com, hannes@cmpxchg.org, willy@infradead.org,
 muchun.song@linux.dev, osalvador@suse.de, sidhartha.kumar@oracle.com,
 vbabka@suse.cz, claudiu.beznea.uj@bp.renesas.com,
 Mark Brown <broonie@kernel.org>, akpm@linux-foundation.org, pjw@kernel.org
References: <1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net>
 <64357180-b91a-4319-bd0f-5f09e38cebdb@huawei.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <64357180-b91a-4319-bd0f-5f09e38cebdb@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vusPV-00000001sk3-3mm6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41940
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLUOA6yrws2JdpllxUdAbQ+dq5FL5zbs/JLeOdi/srEwNGimwU2rR3/QP1p7hvIelxai6ygYQBp580GTjY21HJyZcG61XljmoV9pNqvB26/+fZvRFUsi
 KWrJJbmZib9Nbq/TlGKVpm+LWTVGkCjmtB95UUchJ+xBoOVnpHxQk+Lof3MNL6vDKQcslpcLRi8wkA==
X-Rspam-User: 
X-Stat-Signature: u4kuep4jjb7f1wy7s6xiyeuqgbawe3ha
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 57A4540006
X-HE-Tag: 1771939527-734162
X-HE-Meta: U2FsdGVkX1/FzyLv1pAk6xnD6pu3NVXuHVi3h3Pnj5IKWHwGu3yCi0TUCwMhx+9EEq0PGVxfUaMnFkBy+o7OQ/p2qUzjCtHpEZC98Mxw0QidXUSRBoPEPpYmsXb5DbtXTnukXiSbtAIXRZu3gjzdSo9CWuhMHl6Rc4xWO7JXxoocTbVdNIVuT+WJfoP02GbA2H1BEp/tcaInp2I2sgEU3BdCzt5Hz8T/zsK6GlKsSNX5IiLBaNX/nVlLfjGsllQyIsnpO1WDPLEfqVPOO3SRV/zRFFV/vMlX8k0NU4bOVFExdZuxapbjkAEG6W6wYTPVuMsNh40RYGSQ001am2Z/FUeED20jyyTgEKOISJLMOZlBbZRickTOIG7g8hkccMH7r8yEX8gh8lJnUzZooj+6/wyo4kygmJh6GPiRX7gt/qbW6f8mleVOH6vdqBEv1X4K4TkUU7+bS8fOwaRM5lZzz9YFPLD/PLInadiNWJ/BpsYfN9OpRitRlORZ0JSC2TFMRc7o011zxjwJwCFlBmcVrsm52ShvCpj+PmVjd6ZvoFBCc5C/K6A/9EU3MDGwvD0gIu4DhveBwlge2XVR45xH8JQGxwaH3duYW7oMo0HMkqnzPf4tsXgcF55XSPf4FjSVYrTbdgxT//SFf0CoM4BzeJyLVzHadDwMO74diNZr4xV3yIxeT8odep84UZBPoHXTo8GtR+LpwPqLwOiVMrru1qjBOcp8huV+YLhmUIHG9jxyetUprBnVkzOyE+rHDWJv7bk+SWG6MDzV4DHSwDTRVkQj/589zsVydFD4mk98LRfk8QPyG6gb0hTya+IrL87sR1MPZ5h6/wz4+pk2nxY5auT1EQyhhrrIhmFOdLJ5iLmeuJjOr3YoCmfTU31q/tl63ZN7U3sOfZo8AqZKrO0ANJszvoUxvzn9zsr1n4MpJHG6LvJQ5CQycU9mXkok6euJFgYu9fPRSzX0Bl2uJDv
 G/r8uUZM
 cCYqStxE68LPW5sSfA58+0AnReLqjN/Af1dTIU0jOENhsKnxbT3JWkFhBtyLaa2iV93pD0jLm3hUz3xD7X7ZGBRYDXddoHz9WP10tz9aJqhGDFMdd0Iio0drpycDoukyXDUHgg7fh38yB388KHd84Pe4wLBwD/kUpyFs6G2ZRD2U97GJX5A2bB50+4lGcDFiaq0p5HCdYVfhV0tyhfyuOUJtmSI3ZXu8ZMEKqOPtU//fARBHnP5cpVt2SOqV0hbJIsOKpNSUwBTnKIiTRVuo5CYXf/aGu8gULCvb61y2evCMMO7kn8Us1AT9tUTd+t3EXi1YdSlcRvOILQOfOmR6dlshcoc/7dQGTVg3OHOBCaXRlTzQD5P9aXIYOu8kc3bhjYFk6YaIXh8C4bdiR/oHkVtw37MQ2yFUpFizcs1xeyPFcQBfcI9L76q7QrS0BqpCJj7an
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 04:58, Kefeng Wang wrote:
>
>
> On 2026/2/24 16:37, Ron Economos wrote:
>> I'm getting a BUG dump during shutdown with Linux v7.0-rc1 on RISC-V.
>>
>> [  OK  ] Reached target shutdown.target - System Shutdown.
>> [  OK  ] Reached target final.target - Late Shutdown Services.
>> [  OK  ] Finished systemd-reboot.service - System Reboot.
>> [  OK  ] Reached target reboot.target - System Reboot.
>> [  173.985249] BUG: Bad page state in process shutdown pfn:f8850
>> [  173.985311] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xf8850
>> [  173.985336] flags: 0xffff80000000000(node=0|zone=0| lastcpupid=0x1ffff) CMA
>> [  173.985365] raw: 0ffff80000000000 ffffffc501e21448 ffffffc600f2ae88 0000000000000000
>> [  173.985386] raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
>> [  173.985403] page dumped because: nonzero _refcount
>
> The refcount set to 1 when cma_alloc() by set_page_refcounted(), and it
> will be dec to 0 in cma_release() by put_page_testzero(), there may be a problem somewhere else?
>
> Could you enable CONFIG_DEBUG_VM and CONFIG_DEBUG_PAGE_REF, and try to track down page reference manipulation by tracepoint? or 
> for CMA-related
> pages, introduce explicit printk both increments and decrements of the page reference count to identify the root cause of the issue.
>
Something strange is going on. I enabled CONFIG_DEBUG_VM by itself and the issue went away. Let me try CONFIG_DEBUG_PAGE_REF.


