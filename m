Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2582FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 047246B0092; Mon, 24 Aug 2026 03:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F126B0095; Mon, 24 Aug 2026 03:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E769F6B0096; Mon, 24 Aug 2026 03:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA0DC6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:15:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3E011A047D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:15:10 +0000 (UTC)
X-FDA: 85135301622.16.C160AD4
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf28.hostedemail.com (Postfix) with ESMTP id 471BCC000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:15:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="hO/e3OZN";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787555709;
	b=DhT3Z6SKZmio1Xi0pDGjDGEqsde62PhbbmGTIvvj0+iw6+0L6S0+a5oe2Gbq1hLDZdkNeI
	n/DgjSBLfLJFCxlSMCdqQz478RCWLOp0Ku2CKDOryFoKSRP8rxRlDTdfjF17HhRlm1B9J1
	dZUs65hGwo0TjENXNOy1LXbSH+dN3q4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="hO/e3OZN";
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787555709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMmBuSCYY9CI/ipcLyXVqFvMMwlodxm0NKYJ1S+Xf/s=;
	b=UIBhu0bCdbJPVG2iawSs51zlnkm7WSiFSfbEGOL1Nk4uUOL+iHoLYOkqZshMOh7fAQ3m4d
	rMMEqDO1K4G9usOGYJOW4Q53P7niVHH63jyBbDwgyqaNr5TjABRGH8lnM0bXBeTuv9ppJB
	1vy0j3pHirKHVHfg0JngtxVbPCrfn00=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787555702; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kMmBuSCYY9CI/ipcLyXVqFvMMwlodxm0NKYJ1S+Xf/s=;
	b=hO/e3OZNC1A4E7nQjCfQBY3wrZZLih0UlmKdXNaHaTSo2HRSMPy9YKCOh55y7V3eF4dUrjmMpPGRQ54PY78ZzFrqxhHpMufNU0nlSDPZPegAGrBP8o3DZPjhC+2jGfhs+NteMWwMO1+tHuCuqqpPTJMkQJIaQZUmhimMFyYjU78=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9UBU2-_1787555700;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9UBU2-_1787555700 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 24 Aug 2026 15:15:00 +0800
Message-ID: <f30449df-da64-488e-a4d2-5bc54aa3e67e@linux.alibaba.com>
Date: Mon, 24 Aug 2026 15:14:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm/mglru: retry the same type once if isolation fails
 due to races
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-4-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260820045603.68809-4-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 471BCC000C
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: oxngx95fnfwe1pwezowicy17jby9a3yz
X-HE-Tag: 1787555706-282284
X-HE-Meta: U2FsdGVkX19f7m2sqpcRRe0gri5U4c3GUOo1ldInyDkKmeYZuIPAFRvl0schN3mh/DwlxzXhvsfuUE3fmSv7uEmwkS8L1pmocIEK8ANr4vQL3Rc5JO2lCkNVxPzh56L25tW8j84dSiYqde9cpTQ3fw3r7ADLkTxlQhWLRa31UEn/9lQtwWvJWmFYG8+0mXZBEUBZLo+60fcJRIoECPmz8eLWRwAt1434gZWdqLX3caQ78KAdkFc7EiPq3qcMnhup8eA0CvqjHsaYpE56wjxwo6TYfV6Mys7XiWDvEHeQqegpznxQbzSfdL80d//ZnkJnyA0mWg9vIb1cYB1DrMAoMntuBwTc5MBJXeO+C/zt0y7IOYNEl0+sOi2obTSn2EewQy672Cqdxfi5pq8dx9CMqud+pqKWDccrpo8C4sEtJO+bn8vXCoBGFNTs2/I3GHOrYrkOyljvJzRe75SPB5BorfdkK4cQDk1BL0pOKKXNf/IUxZLKPlHdd6mB1Dix62QFHHwZZ2vUpKSlhDsOYCpLbqUvVIGz/iIkcfiWKLqLJuV9yZM1tB5nxq20e1vyEJfwVJ71YtlALsJh6nLkc6dCj37Q1VZsGgh3qR0soDj4MoL1VzHrG+SzkXTJVTsca+DFxVbqJXNNbWdPHeJ8rPaS3o4KHVH3MZSWLBnRI6XXGlv2i0cKHT+MwGkLjEu9JBqkiUsI/WwBKC9UE2DV9SpCriOVnFL5xcS7XPnnALRz1qRysmrJvLmkK4v6m7n6VoOVXFZI06W5er9izRoopaC4AXuUHXZ/KfOGQ5Kdz9Xo36CQQM8EpyJvwslhqI8rSp3ufVAPJ+ut31P5dpiEjILYSRs6aZEEsw8HqKMqcZ0Svoa/ma6DsSFqwoPs77SHs7GSWUE8Sgwh4E3fSxj6UyrLzebcjts2dO9E5+/FZJGDZMUHpF7jJNtE4ULimMQpRF2T5Z+u+soQeC7IWNmHM77
 EvX8i9r3
 nmL6/Hb39sduWpms0fBieSYk209tVWI/nN47au3NZxvIOS+HnfZ+tFG0uIyXUTVGup8QbTu2du2jcLTpW7nbcvCJRubMtDcpZEzsdABp2sxyAK7+vY9NY6g50unrR6osKbv60xndn7dlpE4f+h8IJ84tdUXaGc5kd9keGn7ANfb2butBe1mg8og+NTwPkwAE2tZv1ZZQ3O3/eptoAKhLpaAXk3T5C5eApRSQKTX2gl2z4rCEZF8JtuA3+8NTWpH6MNzE0T0gasjGncbEg8sEpPIm9ypDI6gkYcxdMbpfd3bFdC3mHciFux81t7kuz3fBxHDn/H5rf3kGy4CymCDg4R563E7NkTn6khI1OuUNdvXZp758Bm7GPtxTPXfe6TSf3fg3HaiRcBOMw+DiW4vHmtYCFNXslhf0zQaZk6/OQZekz7fI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> If we are not exhausted (i.e., there are still folios in the
> reclaimable generations) but fail to isolate any folios due to
> promotions, protections, or races, retry once more to avoid going
> through the outer loop again.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---

Make sense to me.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

