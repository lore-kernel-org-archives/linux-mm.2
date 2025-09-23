Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB290CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419E78E000F; Tue, 23 Sep 2025 04:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9A48E0001; Tue, 23 Sep 2025 04:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DED98E000F; Tue, 23 Sep 2025 04:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13AD48E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:23:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C54F41603DA
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:23:43 +0000 (UTC)
X-FDA: 83919826326.19.56B6C2E
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3664680003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:23:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIGXZ5Wt0eWi6Q/LijAXF08LDSB2QvxFC1Am7g5+32A=;
	b=Td1Oc87ujjSGW0OiMV4ghhlI2dZt8BgHtko8PM40kwHRHQYx7QXvPbhQbDQDtSFJBY9dW0
	SeDVxDkAb6gwXc1vAZnRgfiCk7NCh5wJN2BRkLJoT6epZiPETUw2+eE99jIfEkYJe+36Av
	n9n1GywewgP6NnuL3LNWLjwi+xX5ows=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615822; a=rsa-sha256;
	cv=none;
	b=u1IBQgdKhvgE4GsGNXMjV8G5KxvJ7DXAz6BWlb0FRV3S3rHb90I9T/2cM6DmMwb73sVe5x
	T7JMcKRBtJzl9gJDPI/o4qqqa/jTJSXCQ/pb6AgCcEvHtHq+0+jDmNOu6ARuqLoxdaPpSl
	m10IcUREznDjlpKr+KqW60s/0ZLTG8g=
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 6D214123F30AA;
	Tue, 23 Sep 2025 16:23:33 +0800 (CST)
Received: from sjtu.edu.cn (unknown [10.181.220.127])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id 3510037C98C;
	Tue, 23 Sep 2025 16:23:33 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: liushixin2@huawei.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	guro@fb.com,
	hannes@cmpxchg.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	shakeelb@google.com,
	sunnanyong@huawei.com,
	wangkefeng.wang@huawei.com
Subject: Re: [Question]: pagecache thrashing and hard to trigger OOM in cgroup
Date: Tue, 23 Sep 2025 16:23:21 +0800
Message-ID: <20250923082324.6976-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <c2f4a2fa-3bde-72ce-66f5-db81a373fdbc@huawei.com>
References: <c2f4a2fa-3bde-72ce-66f5-db81a373fdbc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3664680003
X-Stat-Signature: ypipenbi5md6fzoeogcb5s147c8xqb83
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758615820-965061
X-HE-Meta: U2FsdGVkX19JXAEwEhaMKdlc8u8Gb1QXsMn86PsdHTn1f5g535TBuTBJ9xdaqRBdOoZLtghx173Kltsn65piFW1pRH0qDBHCBTXOX/i1wyW46F8JNMaRNGG0LOU5u/3j1yjURRDeIKtX2XDYSVDdu3sym/YAdT8SLiCyDxIoGQrUEWnIlbEtHbZM5s4H+IASa2kD9wmEuhoRqKxPZvEYJmLmcVGFTwnkU2ITMajUMDJ1ozbvptEpLUmItPhCS6BSLyTURYqpOuUrqWGrYMGvS5J6pk3ktCVg2fi3uivoYS0X9ir3VtWblYW+hWvKDJbxaS8qPmgHyqPgYWERiHbzBvHnx0DQWpyWFhNwMHntA/gm0WDbFupjgAOwXv1IyBYhES0hXMOGqjBLnNm99JFpfK8IQZQ5lRqSIL1hOavUC1X9sVAV9Q0PlVrzrGm1oJ/bA1YPc2ukEMp+tT/yYQ95SB0VjD3xeHjRujbbbgGXftVLLIBgxykuK4/hz/sG2J0PPNzN4etY0GkVG5dDdYiAAz6Yzopjga0vI9AmXl2vWaInCzbutXAPUNz52BW8i+xip4ChWQEyKOTrTtsIXhx+lsDJ3fOOJP50s8A/4USU0+3OUTr5R6rVwwim6OqsX8eNesMRvz0dExYjhHRdxiZPr736pND7X7UxTBfeBjZSfZyV3TQtM5kBUQeyMowO9nem+LPCU9T4HDJnOd/s7NfcXw8uOdCD++XVCNgUhdVl6Ew9tt5epfWfRN0MYiRCCAuE7LsbPaW9F5YDoe4ul/Hscs+++O7fE4UdM5l8Dn49unghEVmx9nqw+aI55IXvNh3hGIuxdjP63RKxLwkeq3BuhTgOuSrkLUT9YS0W3sCDi20LdwRboXa8KE8Cv6Pgsh/GwcObZfF6nFM44c/JEF6ZZAQqbDxCZh2QXaUXOgsA8LX1J0Ksoz0YzYrqAkdG+TL4IcdHHjJU13oTMZnAgqs
 Zr52B8Mg
 E9j1DWlECAve59d/3PEvklwwU/U+zQZyypF28nO6jLdydHJv6FaBL/oFt5DxO2FzwYkd8qUWW8QpFT4tfj/knFgNG4+64Y7aPTbmmpz3wF9Po7tv1rnOugpXLhVmjp/eEmwFayI0kHwXZ1K4pWTtZ2o3twlCDLPDJfdAteAT+XRVugoIGaJr2b213siZm5Z/O2VL5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liu Shixin,

I’ve been trying to reproduce the thrashing issue you reported. Using QEMU with
the script in [1], the memory-hogging process was always killed quickly in 1-2
minutes, regardless with or without the patch. However, on physical machine
with 6.8 (without your patch [1]) kernel, I was able to reproduce and observe
the long-thrashing installer. I’m now trying to understand why this difference
occurs.

> By bisection, we finally found commit 815744d75152("mm:  memcontrol: don't
> batch updates of local VM stats and events"). Before the commit, the process
> will trigger oom in very short time. We suspect the difference is caused by
> performance changes.

Do you have any insights on why this commit affects OOM triggering?

[1] https://lkml.org/lkml/2024/3/22/410

---
Thanks,
Zhu Haoran

