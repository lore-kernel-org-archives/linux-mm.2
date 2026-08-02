Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB22C55175
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 14:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DD76B007B; Sun,  2 Aug 2026 10:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEDC6B0088; Sun,  2 Aug 2026 10:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4AC6B008A; Sun,  2 Aug 2026 10:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 334856B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 10:32:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 815431A04FA
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:32:06 +0000 (UTC)
X-FDA: 85056569052.19.8417495
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf13.hostedemail.com (Postfix) with ESMTP id 74F0220006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 14:32:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=ShvbEXV9;
	spf=pass (imf13.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785681124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVeXt2ArlqiR3/0/LfcHWKlhvnpKeMMLKq5cVyM3RN0=;
	b=XZ5qAiHo1sVrhbqfeC2vxuh82leN+m+GXEpFugl7sQMRTZR94KLlfQRoCL9rbeGQR/YzQS
	voA62bLpIAqPtJ1DJu/KgrSAHcUcazr4+LkZagzWbdOE3UITTOLkYCj6fBY26NzGJeVlSV
	SFz1SXOnvhimS+jEcke2g7orbkq8SRg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785681124;
	b=d8hikbsvj6xQL4gnM5mJcP69W/9p5zsA4WFcQrYri66TQqSuU4qmLAbC84eAZqFBjMV0O1
	hBK2JXRvSY7zaV04gncCKx/HZ4O6tVNaJizQgfeAnOBigsCTJgaGw9fhSIRCyrcGxZocuI
	Vf+wEq5sfdvfve8ZmRGiVmlp2n7IvQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=ShvbEXV9;
	spf=pass (imf13.hostedemail.com: domain of shijianlin11@foxmail.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785681117;
	bh=sVeXt2ArlqiR3/0/LfcHWKlhvnpKeMMLKq5cVyM3RN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShvbEXV9IeQeZBjjqJ5E3/WuuSbn/MbIiHkR9+ETC5nda48xNih4y4inUk6+qlt5R
	 gCQxqau33pVIH4JhdEdGRX+lDI30gbFkNyB5mLT7KN8Pw9T0grnDcgA6OoYT94GSpW
	 c47UF29QSrBb59TDQrkIxy6rmm9B9qXYPQWPigcg=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 7F7336FF; Sun, 02 Aug 2026 22:31:55 +0800
X-QQ-mid: xmsmtpt1785681115tvhnllpmf
Message-ID: <tencent_D1F8E887A8986E0C7271E59454885AE3F406@qq.com>
X-QQ-XMAILINFO: M2SvzgchpLqfihnCn+WEuv22MJbyItHmxROMWPyba2abxoIKerP8pQVzYwNOgo
	 Y/By3o5/UpYEpKDhIuQM7AWjpOjemZscRfMMyu/CMbVbPDeAIHzXvZCvjvcNj9A+zqh1KR+7ukKz
	 qtZPFMCNha5hmls7puGOXD6R/ocefnDRWEWjXTuk7QbgAEqBoEy4Hoa841kB+5XTg54cBq6b0aiW
	 C1mGI3OJUexTQKV7tN6KLDx0CRkiVZ9VeyxVewobT9xWrGDD0DrJII5QlrjnOfmcCQX4zEbL6Mjc
	 5hAxDFFKnWr5gafD7alrJvUSbqqc6bA/KP6M/tWKmxF56PzdKySGIi0kx/5mXE1C5zjPbJd85OLv
	 o6hhb4CJGUZQo+iqFtHx1XQJvWKy9kTDKBuIzVl8GDjbDXp6BiZqc/YmMgwwn3qEdqNYXpagQo9x
	 fRZ/ikJoEH3IKAOpME4o55aVrB5ssuzj+vuVLzl37Rh+GklOhqp3HE/VJziROKTm0XTIFYv54G1j
	 XFvVUHYQz+rpOG/N6bKck+znyPxTPAJEDrndOXgaB44+0pZxOGVrquRJadQN7mUTGHqLBXiUwpHh
	 DpDrexT4xv+NKWicTFuR4IZQYHM6yWr0FQpUYBM3XzRAA9Rqc9pEVBSoQVs+rqAiuPquJklr+Jsl
	 YZ9fxIVOXuXKqbCFCXtWOFkP1DhrvRAxUrVpTnyiaq7seNER3MQe/1481WqbgqEtafRy5CuNXT3J
	 OMBORIUiWqF4N36suwwT/OuqbMa6gQpCCqDzjHRAgetfudFW40U5E69jNcufY05KEm3uArN4ug0R
	 Lm3TJVYMdlFHu25hjaC2JDN/ss0XXK8/TuYRJfCeyNDdPr0FX7f+h1Rezt4Ab4LxpCXXmua8Vpzm
	 J+fAoMSHM4MhVryPxikgYGxk5wjSiTyovqupDcjxaNSj2I3rdjbLkSr1hVuKZmW7pm1rv/s+q3+1
	 yeyXV+nwvgpVnO3B3XbeP9X5KxDqdAOr8X7OnljVAQWjrN7ZphfwZ7ZQZplm5fZNwhTJsoXSKuVE
	 qnIUS8x65eiOF3iTjygveKsPbcgBg=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	vbabka@kernel.org,
	hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Sun,  2 Aug 2026 22:31:54 +0800
X-OQ-MSGID: <20260802143154.1659328-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com> <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com> <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74F0220006
X-Stat-Signature: s36ki1arqq37phjg18tbdjxn9apkee1f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785681121-163369
X-HE-Meta: U2FsdGVkX18Q9hi8epLY/RokLTDhbIwUVtQkvRtFh18j+unZmoUJDj3KB7jJkzbytwY6GnwMA1Wsq0EtUafM2rdjoVhK+5QT06idUnUZyvHMEo3LWxqrny9EP301d7r+Ef/7/rY2qjBVPXo/AJzqUCDYbjE4oWI6lqxMAcW6f26Ha4QtcUgixNo5nkGNzaY8SeL2riY1IQvhb1tKpE1QLz/ezl7hR6dY60XoFIRHCImIURrTBRX9D9tx3yAb4J3KPRd8UuiX4p4cahWjVu3m5lDP1LdJdJvVgSGF9X6CfwY21SNBwo2kFZH9QEFzUEj7l9EneeHRB67Gq/2ZUBSVXKQbfqA9qSYOpyhwlv926N4sWAtZzerWG5dNSKNyq9OKXJ/xhvSLkDmYoSqYZZeDPNH5IQVVM9hfo4c4dEAGAsHh3nwsHXDqE+c3oSnYj1ViSTmfGPOcO7JlKLTAlxF6louioiLA9oah87xKrZxLkFZLwspDjgLH2xP7dIXrobEY24KaEGbBwxnZqKpLDZahOP1eDoC7z/BOVIweyaBxKQpejK6h7nL0Zqyf9FsVDdo8qpSnNrhInzjT2G6+1yPMiVTaXcj2Hi55bfdCB9HE6UCqKcfkp9wazJmw1rvUuijm13FzXr+J76JOSEh3XFFS8Ko2kcDFPkj0dzdV1qGHMMKQFE+0Hw95M8hu3a0mZlIqOynzSqqAHNEPFkNghnkHm2vr0H+xNnpujhkA6iVIP+ZNdNB2+1DhfyVVQFpFoku9fcZjNjDX8q+qaXJkU50+SEO6tfgv5noZ/IuI5eOLNS4jLZuUMivF4qmGNU3UoYrd+PfJwtTD0GaKrsKG4EdF/choOvigSsU4GX4YN8oYU2s1YnTM0jK7RzWHNd8Fokp91wR/GXn8YpnrkfLxDyrMQ+G1EgLcsEo29cspCgeKLpDKXu99guuiuNusm45w5mjbHOCU5/6InSPq8qfd6GC
 FGQI4N19
 SMak0iyUEvWsvcaiK4cO8bsqYMPP5vgJw14T/+A/xXxE2/hvPJt+2gp1rTHOTUQQC0aZ8MRmqhcP5rZesFHLseKez7aUziEt5xr76d/X1PzIERV1Evu2tJKorf5IDG4XjlGrCc2btMIItYvVGJ7BYgXvgq8S0vkEtnK4prmpSDi/QjtfX/DyT0HsN0NNIXHaGXbo+APOC/s129cB2+E6zW6WJqGOgRWT2WvQqPNEXdNr8fG3MaZv9cn1rUqh7wqYMDpGPtyUutpOPSDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 1 Aug 2026 11:44:34 -0700 Andrew Morton wrote:
> Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
> temporary then copy that into sysctl_lowmem_reserve_ratio if all
> proc_dointvec_minmax() returns "OK".

Hi Andrew,

Thanks for the suggestion.  v4 uses a temporary ratio[] on write and
only copies into sysctl_lowmem_reserve_ratio[] and calls
setup_per_zone_lowmem_reserve() after the full parse succeeds.

I'll send [PATCH v4] in a separate mail shortly.

Thanks,
Jianlin


