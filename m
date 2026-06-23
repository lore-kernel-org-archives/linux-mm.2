Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE5DCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C20F6B0098; Tue, 23 Jun 2026 02:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A176B0099; Tue, 23 Jun 2026 02:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0056B009B; Tue, 23 Jun 2026 02:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 336496B0098
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:29:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4063B1C2906
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:29:09 +0000 (UTC)
X-FDA: 84910200018.19.2100932
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 97DF8180006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:29:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dZaxKjMK;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782196147;
	b=dRmw6Th4sjA41vU1tuUhL0Z0Man4wshktLmSZ3vNvE1JC5GBuBXYbabp1GFj9sV9ohZhut
	+H+hc5dw+FkOYvlk/C9IgFjx2q74DdmPYLMvSHA47/vEYSUWgkWRXO+1QD6Suj2hdxg5PC
	cyI/B9Zfb1WcqP5efNkEgaQjyzpLfu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782196147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WM/72UAw0KBUOaije1a6aN5pXM0KrE3wbUIEf3h6Yyg=;
	b=ihjfp38QKvIE19gcUNmKIJZuFnIQTDNxLORXHUE5PChhN+2fgzDib+WdBJEXVCosNzR73y
	YurU/kaitPgxTtm5Qe4hRYgzEkzEe764RxD0s+ubKpPQ8hjiJrEPPKgBmfK0ZHsVoPhcKg
	eHEsC3lZcHfR5OiyOl3YRZfiSsiYd5E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dZaxKjMK;
	spf=pass (imf06.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782196146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WM/72UAw0KBUOaije1a6aN5pXM0KrE3wbUIEf3h6Yyg=;
	b=dZaxKjMKNgYWWTx0WH3QATSVO1s6+2fsVaS5w/chhYFgQAzVgviewZFF4Y+az+eHySevwV
	zEo5J0yf5+L5V1Ht6tctbB9MAdOp2wRCr5q684mqBsQeRfEd0KL7IiarKV2vQC/oQT+XU+
	skp0Z/83eorcA+rkihLUFeJFiCtzE8Q=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: yingfu.zhou@shopee.com,
	jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] memcg: bail out proactive reclaim when memcg is dying
Date: Tue, 23 Jun 2026 14:27:56 +0800
Message-ID: <20260623062800.298514-4-jiayuan.chen@linux.dev>
In-Reply-To: <20260623062800.298514-1-jiayuan.chen@linux.dev>
References: <20260623062800.298514-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cmiuafh3cyq4gmzs7336zgtq65rkjo46
X-Rspam-User: 
X-Rspamd-Queue-Id: 97DF8180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782196147-879759
X-HE-Meta: U2FsdGVkX1+CBTBhfWAtopA40KV3H/0IjUNHnFRk/D1GI659j1GtPdqQpw/AH3AnAr9W0BEAfPaRlvrx7vRJXoL3ggFrlxkAH67xxSqYLOXe0sAQrPXzR+1HAoO41u9Kve6CgmfxJGRmBXfTJVoXvGBSC7hgzroH05lt2oSYs8dluWNi8D/MEbELAorkL9ew0cAbid64fdioEM5C3FwCf0zzoYSUjbCWkyHamlBKPcHSykxqiDQqdc8VMy4DnkniA3GXKHlsKGd5mgKSt529Y/7xH3AzLlDUGVqPxI/HEEg3qCl7PMbtrnYkPJCYfOFMCkDOHRdB+t3/5HDHRWFOPDsVgU2k2am3tloEdU7CLIUHW8mb9RTrkZcwUexdq3IkSF8cEwSvRcqOuXIjBa5mWipszYH8qxNHASnuaARgtiJkVZTCweHov0cToHcx5pCx6lzq3tGigesoqg1Wypt8y6SwI5gOOh8gZ3uQ8ilO9bPXk0t6GMdJ1UCTb46O9yocn+FgYgNqAeqJ0As6z/+C1WraE86bSQSss7NJ6zbJLSVjIj4XiT9bS1BcsHauqdjLY/L7DqjlRB/+pi1zg1tQIUE0ptSRBuaFrASKCFyaSapB8ukRsddLAbITeXs9HbeK2bWedw8Q2PPix+jDTg9BWTgPThBnbTHbng4vJw/29E2EO62cz778TVSu6fk7eaUMP5Km51WY/sEytXZlqzeuH3oqaA3iq8xm/2TGLjth4Ua9wUNpX8KOHN3j0K5ODgJdj39z+jp6Qj7kYy20bfwdhVUZvven9z8yMd8ov5QYR7bO+YHYyxwrqF/l61TdmFNKMojy0942jAfFpKr2Gt4YMiYBObBaiITXos530r7W6wElypKVC0JdMFYSHtbSvWvI5iA6NiHt7yIqi+zDEyoW3MoAOrQsD9IwrBQV0AOAn3hY2xO1EICyR/+lZfzX4P8EyI9FzXdLhL2Tg4lSKNv
 JY6C0Y/W
 LvmQbIHIt7IyyL59R0ExgmiOG5IxaWANtJ6ta56c0HEh7/cwt4FCEebMEeartWI1GiLOqaBC6iso3mRhssmeYOZNHUEP90qrfae5Lv9In32XHh5gO0vFjSvYVmB/grek+RM4r7WWFqfZqvo+o158XNu/7B/7ab9B01U5xreqYaoHdSmiLTULCO47jKwcz8iat2varLjt9/1tzhvL5QylA+AVvMNa84Dn7r4m3nuTsvCVQeAQ9Q0/eIOCGpXqDHpqlZSWGjOWbxglIP5llJj0vLGeWLeX4VZFEhAhFAHWg5pcYIGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8190c4abec84..1162b7f76655 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7922,6 +7922,9 @@ int user_proactive_reclaim(char *buf,
 		if (memcg) {
 			unsigned int reclaim_options;
 
+			if (memcg_is_dying(memcg))
+				break;
+
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
-- 
2.43.0


