Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31839CDE032
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE868E0007; Fri, 14 Nov 2025 03:43:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896348E0002; Fri, 14 Nov 2025 03:43:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC5A8E0007; Fri, 14 Nov 2025 03:43:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 691FB8E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:43:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 148D5136DF1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:43:46 +0000 (UTC)
X-FDA: 84108574452.14.FC3DDEF
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 376E812000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:43:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bO3pagQh;
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763109824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZqdt41d+LPz+pOMoPWH9r9sMNv7qqAmbnlAWDdsj9s=;
	b=uFSuhsyI1KR1DcZfUB+uCcb3EAvrShxay19P5eB1x9kUVEo5g0sub65nhjwRIVV+2LL1ua
	cWQozRoJ8uKKLOO9EmXl3KKBlC4f83SKfzkq+AhPWrQnj3ZlEAhNwC+pFNS/87sJYftJLl
	a4G5QrA7VXkS5e4SvoSuQBAWrDDO+/M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bO3pagQh;
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763109824; a=rsa-sha256;
	cv=none;
	b=YRv00ws1cX3B6ofdE3+UsntUsRXdyf6ioPGIDQqATnIX21vPCPGnDGlHb4rVNx9cZgm+BX
	Ci8llPzEeO0/rrif2Z5pazTtzYTJr6y0ZeSJkbt0j3j/6yMnojUph6aNU1WAtSTZCxr4jR
	Ts+K8+joW4vg33oDlsPSrVClxGG5PP4=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-297f35be2ffso26118195ad.2
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763109823; x=1763714623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZqdt41d+LPz+pOMoPWH9r9sMNv7qqAmbnlAWDdsj9s=;
        b=bO3pagQhbQwH1sRFQQFMR0bEiZWCbeQjfNm0Bh2oZQhFnTlrCbdYCfUdD27x9TwKYF
         ybcuoEaMHE1X6goc0bDo32sPZTQXbte4Ckr98hFR1E1PqhlfRVVAQZ94yzfGJmAMJHV5
         8I3s8pGv5taAm9hWwptSOftWXFDOODzVV2nhsjDd/3EZEotVDY5OviCZGCUEK3PnB8i+
         5WS/Ic1n5cuswkVOw/lfAkELdoUltQghA28Lophj3GjD5mg73wvbjI6mSDUXXmA0/6Rm
         ONQRKM51sX+U3o5uD0VR4gpKUKqxGtu0lCeRXWiAYCDwAZIqkuRzirUgFaIqZv0TRXsM
         Wz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763109823; x=1763714623;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CZqdt41d+LPz+pOMoPWH9r9sMNv7qqAmbnlAWDdsj9s=;
        b=Z4Dp1QL5LqpGxHGxhC1rqtSAM0c9NZsSIpMqRBw6mIxLAGTkWg36o5pykbVDqunBOV
         g8y3WJzpy9Q5nX9JWp/UZe11iCbmbd+xhushe3F1Xjo3sFMcV17oJg3n945JIbplxKY3
         JwDvYbkgk+1QVpaylveSTtuDfEBhyYspVhtHiHwmmnwczC+ArAH6FkSgpfMm3y/SFuj4
         BvRB2wJkVLXkmz+GuwYU9x6aZH58oLgsU7kHQ6Y8isKZ4cm7UfyJH0amUNpiOqvRxNVL
         IsRqfeVW36XY8TVV/dldyxX7rFoDwO7iWrp9qJWVjZgwAtT8yVPCA2dN8vZsDu4rm/qJ
         xWSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVm1n8L8z8cQHyPBesPQpf3CiMKCYLK56Gmvkv6QUoU73Lz5fzuXeCv+9UUHFTlUYejTmBrrRcn1w==@kvack.org
X-Gm-Message-State: AOJu0YytawFeXhZWykcQufLS/HiJcTwxlBxFtoBdSzGgc0xtIdzF+4pC
	knaVoh1L4rv/qy3BnZPmTKX2Ygqj1TYLMsVSrgOOuOGaV/XsWcltJJhg
X-Gm-Gg: ASbGncvMx8Ro9+SBpcMI2AilqoRDI7VnIi68QQkMqDcktZg3V6NgBUGOumtOdL1Ew7N
	hrR8yip70L156QmXw1O6lSzBhg2h6fHFGxbBBrHBtuUk0KW26ugh3gNmInuBLcoh+l1cgiumVNp
	QgDpJHl4kFlomZIKIoFW6rtgP9YghEkHPyVIBq1hM8Y+9BUdrTHxd0u7NttGIVgkUfMJ+EemECa
	6NLshVyWVy9+PSnDIN8jTAsK9llf6X6xgG4lpLCYRNTm/YVP8TnwMTprw08pTOHAyObb/Pxyesw
	h7JsVbT0s/4MLe4L2cTKcVcO0BGmHnRE7iON2cGp23lm8POK5+2JNeR46sQbblf4/cCslHY0keb
	NJg0UXJ0x7dY4AhTsgDPTULDTdT8719ZMTfpt4NuNtdqVzOBztoA8O0eccx9/n8JD1FYNqIxaUN
	RhXUtPqxk32gu7iVQ=
X-Google-Smtp-Source: AGHT+IG9/SC6VdPA1FDIVemhgKL/bLY9YjlGaqmfBfHgryKUgf1+YXYjJdmBmW+U8go+rXobjJicqg==
X-Received: by 2002:a17:903:2349:b0:298:5abe:4b1 with SMTP id d9443c01a7336-2986a76bc5fmr23755615ad.52.1763109822755;
        Fri, 14 Nov 2025 00:43:42 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:4f6a:b780:1077:5032])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0d17sm48880405ad.72.2025.11.14.00.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 00:43:42 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: Re: oom-killer not invoked on systems with multiple memory-tiers
Date: Fri, 14 Nov 2025 17:43:15 +0900
Message-ID: <20251114084315.155333-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAC5umyiA+KkQNTv-mN=mA9BXHmqMH9Trr_07XYOh=QTLLm=zNg@mail.gmail.com>
References: <CAC5umyiA+KkQNTv-mN=mA9BXHmqMH9Trr_07XYOh=QTLLm=zNg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 376E812000A
X-Stat-Signature: utej3xwpd74gdxxa81576rs9i59jmt55
X-Rspam-User: 
X-HE-Tag: 1763109824-325214
X-HE-Meta: U2FsdGVkX18IZoxpYzMVwIgKzFEQdWAq/ifGCy4Q6oOko/8mRX0pThDdAJesMpeEc930K2PaUY52orRlIad4xeBYljonNcKSjkAOe2PZXVT8BMyBdGgOJvSGM9IBCPkAdPBcN1M72PtKnxzqqKRFDNqSEUwxdu9bYygsRww7VUkScKL+v3xcHBaRTLBFTKxCDByi42sERjnh58bERRnpviq95UCI1BkzJ4U5vHh1FpqV4TiTFTLtyRwnbP0H7kvDYHiUNODMKmUyjceM4IZkEGsxmgmUcwcKdslDyEgkJltmvlVR44vtwnoTOpx4q66EuqDEaDePIMUtWLC4kKyjdfWuwmQl1yxbHIFm09IFQVwkBIbrB/Ua/k7iEnSSzDd9912IHW0xhZuf3S5ahumyt/Zno3d3w7dpyxWfng8i1y1PdGJ0PooIYKDwg2ZDHXLoXP4xvYuRqI1pZBCL1capUdZuyTQa4bw5Jf+ebRjlX+UFxJ73H6PGCejvUB8oxJt4M7ISDlK4pBiVznrm3YJIFzrrIq+37gEdqvp4vdI8dbHYISpovdT4NfltRIB61YRA8w9bSq7ihbjcxz3Sti45vs/mJlVho+zCHZEhszKZb4OfxRR4UxlNTjNLcDNqOmqDaLtCH76xZbEitbT8Pp5BygDaKPaQnPlPbqWmj+XgFMC5ZhWwBc1aLteRPa+i7zxmbay+7lZlfWuMr659kOCr2N68divBdBejoQaYovqE8kmjNVoQCszcBHnQnqd7IlBRw0tthpJXQRZElSx3EruEoAYvhHui0FCRUa9rb8jpWZi/LnmDzkb7QSXEGJkCQOyJv0hiFuxXhAAZMPRdeylwa4p0TPpJAoje5zddO17F0lTELGD4YJ7k9kTo06EMEPEKvqfOylVcZZcailC6Io8jHGFGob8wx0L22MUuPp51hs8E8Yi0gsgaC3SwrQpn+MY1EhR08bm3kCt83afdXUf
 68/DceyJ
 v5eZqx/85tu4dcPNIGL7YDGWVAxd7GTLoatAHv02gZaqHQXjesK+UMWVzbdtzjkZq6eLdRup8HS0WpA+ojOHaVCFIW8ktotcECp+rwkO1xMxlNeX+Kfe/rEz5Z2/xcliWzuZI0rdCLFfrDWvmaAbwwocNBc5f7ThxgKYloFzwUSR4HTSuwv9SLewwAAUbhbQYJbm6VBeohFEO7gVw9BlE0i6QqmnbL75iv71XVmNemNge3McJ11ncOKTus2ayLdqwD/DCcpeeYt8K4p1nnMmcV4KOAvDpOkFJKf5DtoXScCEisaBR+A3fOyJrRzybWkzUuBRoTi/hAnem/JC7jM4CrszYtrvJd8b60X6J9N4uv9s1fJcM4XXAOLZlu0wVhABunSdh1aX4830vLc6BAf6j1D4lNApp6HYDXPW2QUOPUg+yGlqjkj2gi6ACN+lwU4R619lknlCwSJQy7B6C+9Q8dN1978NoK00pHp1CqqQaHgrs0eW3Y4Oj36r+/mhp9DoCx9PQh5lJ00Bl/TPcc2dwvWK/EPu9ZmK3FdEZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Regarding the issue I reported where processes that run out of memory cannot be
terminated by OOM when demotion_enabled is true, this can be avoided by not
demoting if the target node does not have enough free memory.

Specifically, the can_demote() function, which determines whether or not to
demote, will be changed to also check whether the target node has enough free
memory (for example, whether the minimum watermark is exceeded).

Does this change make sense?

---
 mm/vmscan.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8890f4b58673..63d751e54b08 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -356,7 +356,20 @@ static bool can_demote(int nid, struct scan_control *sc,
 		return false;
 
 	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
+		unsigned int highest_zoneidx = sc ? sc->reclaim_idx : MAX_NR_ZONES - 1;
+		int order = sc ? sc->order : 0;
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, highest_zoneidx) {
+			if (zone_watermark_ok(zone, order, min_wmark_pages(zone),
+						highest_zoneidx, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.43.0


