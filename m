Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1747AE8FDA7
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 10:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B04E6B008A; Fri, 26 Dec 2025 05:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DDF6B008C; Fri, 26 Dec 2025 05:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CD76B0092; Fri, 26 Dec 2025 05:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB706B008A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 05:07:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB0A0135F1
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:08 +0000 (UTC)
X-FDA: 84261194136.09.F7BFDFE
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F47B4000A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:07:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1LqUj7YH;
	spf=pass (imf01.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766743627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l7T+YGSbqj+e0hTazt6RxyEyzfQ8WVqvckzZlYgLl48=;
	b=ECXVRm05Y5tt7uz45MEAmpDOYLtD7qIDWcAHs0pbLLPpdiqhHfOcDpe9rRpAZYI5DgzWRV
	2vQQxsJSIpPIPRLLFzhPMi7m8TqerkHWXi0cRab9KwmtyEhGKR9KjSlaRpVZtG5wYPXij8
	7vqj7qAHaGlL0763A2JlQR2X3rT2c0E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=1LqUj7YH;
	spf=pass (imf01.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766743627; a=rsa-sha256;
	cv=none;
	b=ZgGnXk+9p7txGpUac/IGf1pwe8PU+rzVFVEMHXQPF/+WbXxyqQfA6cfQQxHdA3PJdlfgQk
	wzt3MeDD55M8BRMZuR4uW5AuWLZ6Drbxxaotv4Mmfx1K5Bq8kOW1kDfcCVncl6S2D5gEFH
	vmbhRNDmLRkbDNsyC4jAcpUrTfL8OIw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l7T+YGSbqj+e0hTazt6RxyEyzfQ8WVqvckzZlYgLl48=;
	b=1LqUj7YHCvgU0ez5JwfvoySJx//SwWrY32KqGLW1SdbhyIlg1qXuNVOjoAUPyu/ZdPsH9rs3i
	qjr8nLHKQyO2YQr/1rZGNn+kXPNTGe1zvSmoDsFKo/Z/KAC0w/MKer8QFlXf4gZHgAtVcAFWMqL
	znzBNwxvUDGUSD0tOgLeIfQ=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dd1RM4ZFlzpTKy;
	Fri, 26 Dec 2025 18:03:59 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id B6FFF4036C;
	Fri, 26 Dec 2025 18:06:59 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf500012.china.huawei.com
 (7.185.36.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Dec
 2025 18:06:58 +0800
From: Zhang Qilong <zhangqilong3@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <corbet@lwn.net>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<willy@infradead.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <lianux.mm@gmail.com>,
	<zhangqilong3@huawei.com>
Subject: [PATCH next v2 0/2] THP COW support for private executable file mmap
Date: Fri, 26 Dec 2025 18:03:35 +0800
Message-ID: <20251226100337.4171191-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Stat-Signature: zphr4gfzajwt9jschme4gnxsjxzwhknn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F47B4000A
X-HE-Tag: 1766743625-164034
X-HE-Meta: U2FsdGVkX1/6Unho/Mlm6GyLZFRJh71P3MyWbKpYsdvtmt2HriU4Oa20pmx7F5ROUXRxqTnJ1wyIG2P9OvG5e3HqdOopH2MVp9rxoQgkz/P1fNWUuuxv5SRoxXDTWmO0e/UYEGVAaTY+h3SSHDaH3SerOkcgBqwWrUWd10fBNjZgVIQET/J7cn6MrMax2Zppeblas7VnlT1WkvXRkqepc9mzSgsyG1GNivcz19pTOyHowjtn9lUn5n8yLLs7Yx9pcz/Yxg1KfLuUALoLny4XMbA/L5B8TY75vCxF4FTRB9A3QW0CtuhVq90R67JuzQAATl5mYp0qpQStrJoEBWwV6qdr/CagKsB85d7JqsTW0f4ONxs7BoQdIRUFFqZrv0zSMKfE1mavcjoB1knkT3c60+IV7qbUGkamAUvAxMp6//JAjKbSym8kXpJy4YTsjJ0PwnSadjZLYLeVTCk8p2eyQZ7LpwPHh/WY8nJsk17aHnwS/jAiWUaP9uZb6ihSh0tb3MBUHAi56rY4cvQnoS7Mqhr7zaC/fkUTJz4iNNzvxN6jnEEDbKoUp/v3ceaXrRpck1tJnlrSpfG3q7kaNDl8zQ33BgOPxjwaL7dvo+hpTHHW08jgRt3dFrA9Vyb9auEORcWLZX9FDMCE/vz98ZBhoxx2QN37uOTI3NwJdOXb9zmsrL4jR65xg++RVp3feMvJ8GY6IyIaPufi1TC3zhHahq+/Q9mKh6QxXSgK2uFR++yQzgpz4fORrdaXltaN1kGM0QYaFIH+tZClXCTkxQpP4/i+TC1ucW2xv1RJxyhGz/AgrfLrg44pwG8YcYIak98XH88UMfghrWvS3nAGkBWIlwJUg1s+HyA+9q/RMxWXamisJ6wV6M/SMuPDgJADohAiBRDlRBEgFLof2iEp502L9JtkWphzaWP+h7HfJWozRLNtMql1g67V5GcaLZXDPt/f+yYvld9lp6nqMCd6FPf
 RdDPWy0d
 Wa4eRi4l6yEj98HxlOEDyxlXu5zcdEGrvPB0rjCeHuH5WIu/RU7Yh1gIQluadGSZSdb4RMWZKvloHuinh7USGwzjLwmuVbsEnsf1tSFuRs33WyuuT2+kUHKdS30MluIAK2f8TJy6OyrlUzHSV4yGa1AJAtg6D1KKMr7WPDzE975MPkTTfihU93B+IMaBj3hU+7o0XWLiyzCa8ILU4i5bxLXrywlmcsyRpXardhbBEzfcJXHmq8H2pooeKzI/E/H+5oakKhLaC/iC0vhUNkBo5dzZhpHDVUci23hSVvpAU8L1m2XA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series implementate THP COW for private executable file mmap.
It's major designed to improve the performance of hotpatch programs, and
reusing 'vma->vm_flags' hints to determine whether to trigger the exec
THP COW.

The MySQL (Ver 8.0.25) test results on AMD are as follows:

-------------------------------------------------------------------
                 | Exec mmap Rss(kB)  | Measured tpmC (NewOrders) |
-----------------|--------------------|---------------------------|
 base(page COW)  |       32868        |        339686             |
-----------------|--------------------|---------------------------|
 exec THP COW    |       43516        |        371324             |
-------------------------------------------------------------------

The MySQL using exec THP COW consumes an additional 10648 kB of memory
but achieves 9.3% performance improvement in the scenario of hotpatch.
Additionally, another our internal program achieves approximately a 5%
performance improvement as well.

As result, using exec THP COW will consume additional memory. The
additional memory consumption may be negligible for the current system.
It's necessary to balance the memory consumption with the performance
impact.

v2:
- Add MySQL and internal program test results

Zhang Qilong (2):
  mm/huge_memory: Implementation of THP COW for executable file mmap
  mm/huge_memory: Use per-VMA hugepage flag hints for exec THP COW

 include/linux/huge_mm.h |  1 +
 mm/huge_memory.c        | 91 +++++++++++++++++++++++++++++++++++++++++
 mm/memory.c             | 15 +++++++
 3 files changed, 107 insertions(+)

-- 
2.43.0


