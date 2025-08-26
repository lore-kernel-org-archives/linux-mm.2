Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2D9CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 06:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF87D8E00A2; Tue, 26 Aug 2025 02:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0308E0090; Tue, 26 Aug 2025 02:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5BC8E00A2; Tue, 26 Aug 2025 02:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCBCC8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:23:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BE1DBA931
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:28 +0000 (UTC)
X-FDA: 83817916896.18.759C2F4
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id B8DA31A000E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DpskVHtq;
	spf=pass (imf19.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756189404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GSS9CL1BDt/KxL+nujeo0VUaPSx+hlw1HrZE8dR99xo=;
	b=wB/wAFXvz1yfCkkOH1MjG/eTP6w5VwLoCrnWeNW42V++tZtiK9Xjt+jY2oHPv9CqVLJOKO
	A/kab4/YZkZ76biPurwwef+eS1iYPD7vezdsxpRz0PcjcD4MvDttejZmesBPWKgixddXWN
	vOzDoQ7NCx6o9de0cLi8XCLDD6QMENQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DpskVHtq;
	spf=pass (imf19.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756189404; a=rsa-sha256;
	cv=none;
	b=MNiaeQvWfVbr0/ThNPnyT8v/yQXJxVdXgfk7GekoyixLxomji59uLmutYb0YX0S75zxIKD
	WOp+C7hecKjLI4yhHq28GlGZ9bUSGG8RZ3Vd1J2pVmws04XbcC3wVK1arseE3+Wy4iytsl
	gu2dQwkFCn94KFhA8EXomHEotixb36M=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7718408baf7so2099199b3a.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756189403; x=1756794203; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GSS9CL1BDt/KxL+nujeo0VUaPSx+hlw1HrZE8dR99xo=;
        b=DpskVHtq5MSEQzfRU3AcITK+g+hcMpKapnUfJl44LqpdpnFYHGqPOb/7Ep6PtIXu9B
         tWwpOUpPg9c04eXVmEpfX8jYVZbq981/OmIVZbfVgrUMtQ+ahDpBlgsR00ztjQUZ20sj
         watfEOwTB2VcLNEslUfndRwE5GDoyEEpMXQoimiv8UJHTwHwBAMxVM57Oi+uG8LzCd+h
         lzjm0G4lKEIOzJcn6mBY6IVF+XpftDt31P+rRDfIY0vhAFH/EbBhxiL/F6+jUE1J08Fg
         2aEbFG3/5hF53mnqzrCGW9h674HZLnNW4xMQbSjFEEpYMZuhTRtjpnlbaHR8vz/JwWFD
         s9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756189403; x=1756794203;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GSS9CL1BDt/KxL+nujeo0VUaPSx+hlw1HrZE8dR99xo=;
        b=qvZZSdDtjI7/cMpELGKAhLgZKVwYpNjWAhzkDNtLEey7VE9fxVY1WKuWrdK47DV8EM
         TxwrtpRNlswYbWAy/S5vgwDnxHZNLsNldMmb3DDRNtz7kQs0P7ftnO116rnC1fFfArGc
         1YKROxieiiOBi6ntQwsuaIU92TEe8J10djr6ptiE81tTmzRNPdaIR6ilzdabcTexDWwd
         yognSwfuocLtAow7xLleF+3us1Ab+M5bqVt6c43OuWkVYpXDBYydrr6rqENnfetNCdAE
         5C3ZPOBmJPOLDJVGsFfRt3InWsHWx/br1k4ulPjU3wr0Pl798BMwsXF4IIrM0k3Vack2
         pTYA==
X-Forwarded-Encrypted: i=1; AJvYcCUPt7P+0+W1IHX72WWP7RFKmJWnVRZkrtQVKBLWqiTFKbuTjm4XUOL4vXKEUQJR1+yn8BasZEtdNA==@kvack.org
X-Gm-Message-State: AOJu0YzhMOMJuel6kBdISQn9sR8gnY5DGgi3EiUDkcwFDvuHAc2hIaGl
	ULlnBi7Rv0RVyqQm+Bq1tBwQ0Mk+K8Wj8jDDwi1XkYNi1shligUgDAaT
X-Gm-Gg: ASbGnctZaWpju7FVJnok+s78gBuCXWWWl5cHxuuTuLJAdU8eY3+jvo3KCJ60VphDMnV
	UqfElvwWERnMMwOLlT6LsegdSsRiZIqUsRM71jeqghIaEuAbwvXpUYQp1mGNxmQCpGYoww9B5B9
	6boSr2p3QHbX0us28iP9GTLrrL669she183x2ZoBwEA3wOwF2BKPfRM1GxtyYwavvj7mn1DCNLN
	/AyNKhXq6g5T2GQztAOjmUmxshyRBZL3bgy6sx7wv98SOLcEEuIZzjwPD3avJ/CTs2qvB+Vg8Zj
	s2GhZa274KV0AYuWmliNEV965qUInbEDCEpxQjStq8LwVvPyDw/DuNJacFwpdazTJKTjRIumKQa
	MVsxKsXGKnJfH6IYRm60XQyVMKzrLTk1YuMfJtnBdyPYtyL6zOOWK1d+pvqMRumA=
X-Google-Smtp-Source: AGHT+IGRLTtVhf5gNNom+FlSyhvO5Na/XW6FPBbeHGtKXN2dl2ENf9MJuoeexJXgu1MdjlMBXZURAA==
X-Received: by 2002:a05:6a20:3948:b0:240:16af:401a with SMTP id adf61e73a8af0-24340cd32b2mr21363713637.32.1756189403516;
        Mon, 25 Aug 2025 23:23:23 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771fbbc3bb0sm492535b3a.66.2025.08.25.23.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 23:23:23 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	chuang@cs.nycu.edu.tw,
	cfmc.cs13@nycu.edu.tw,
	jhcheng.cs13@nycu.edu.tw,
	c.yuanhaur@wustl.edu,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 0/2] mm/slub: Fix debugfs stack trace sorting and simplify sort call
Date: Tue, 26 Aug 2025 14:23:13 +0800
Message-Id: <20250826062315.644520-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4ow3b7sn4qthg7e4pcdcmbus7iwf438
X-Rspam-User: 
X-Rspamd-Queue-Id: B8DA31A000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756189404-248454
X-HE-Meta: U2FsdGVkX18Hux+NXw15SZuhywT5Dkl2PieJ0rfOqmO90Bg/D0DqEdY3yNgCYeJIexqWOaHhK09ezIaCFM0MFwU1eZMavpuF0ecnyK70bVarzPTM4zdDQq5OFIJeZFwBRswyPWdB1nDP15u1mUIVutQXDVlQDo4RmkKnyW7D10GwjLzG63qbCZpJeZDoLP575CeAXQNw42SldfVoD2SiLQlt1YOJibqKUwVXyo3m4IIL0PNBSp83HpTLrXb389j7UOGOmS48zCbegVaYmWxHxGwPYKYgbvzGYClND9pxZ0ex+/hlnpDYdOszSRXShAchkrY6MM5MprM4gbXw7Knh0A0g7krQeBecW6qF5CIUeORRBTRnpP3EoW3MtSPAtjn4WUhakj9fcm/VK26ivYtxanswlY06MHXa3mQrDz9q7mJXQdqRoqREdtkSN58MGpC7CKLNcYsB4LDpSuJE6silGGtI6vEtBLJfIEDFGVs8U+t3uc53SGnRhA0hImPFBc2QbI85EbElmYeiUTgAWTq+v8d5o/Bc6VQrEPY/CDm5r8oElc8gu3UcnD5bN0MNUO9wokmfoizZQ+Hc9GJOfOE7d00oWDl9YGvcMC65ykxvI7xHpcaywLIFKHvy1KLdnq1wrVmRQ8FFvKxHP3V+56LsXIiEpdBzMZpJ6GxrXtsyTObhaqorN7ylsgCjYmgTral1yGjB3DMqfMFbtcyYd4KE/KXpu87OIZiMPlyED1iTk/f9amxqdcdxEFXqas2K+LTESJlqqtmlF0Z4ZhzE+p1bdbPxWuHW8vmqWYGqRIpKlYm/PVZCcixk2o5fML5yRiVmEh8cwuxH9qud80GeccyT89JQ7tzjYMeTrghaAT2QznTNnGPCdajvwPrQEKvYiqSg6Gan03g6l0ujYnCjj19jWkQ1f8etz29EuPhzQ14mDTRqVDh/jVHYp1HWxt8PNI4XjkXsQDXKRyxOf+s1Q3J
 TxfomlqT
 VM8K1QjHx7PvH6GMlJnYn/vsHcleQZbnng4TncuwodWbxHMoAt4Ok2HHMEmCuUMtVa/ERFRfx3Yj3S9NpkO7THJh0zW4NGMKzFEi25sQT3/V+3eQaeuk++s7Agd/ZFO/m3xQz6TDQmVzqonCi4Tqa5ygT/pPT/Ojv6tL01YmOq1D+ibhbEw2PZspGyl/+BpfdiGW8+7YP1r8Uj1jHiP36UddjPPpF03PNzLMklsPI+8AUt1ZpFtdYTRMDPPACQUdytRVr53dwUvgojrTNKC3/c1PQxxkTwEWhzgo8ncSdTBYN0YVXJF0k/d/yU6BykwKth4HqM1HHPoesUK+DMqfWP5hGfEUBa8vmYzEC7E4BE3ruvFGJvYYmgcEF5C+Tz7z0c/ubU5hjAVyI/UnQV/3vvzFGP5tBtweSp3gQ0whMxzPybZrsHFoWwmCkXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix the comparison function used for sorting stack trace locations in
the slub debugfs interface. The original implementation violated the
antisymmetry property required by sort(), which could lead to
unreliable ordering of the output. The patches correct the comparison
function to return 0 when counts are equal and replace the unnecessary
use of sort_r() with the simpler sort().
---
Changes in v2:
* Use cmp_int().
* Drop Cc stable. 

v1: https://lore.kernel.org/lkml/20250825013419.240278-1-visitorckw@gmail.com/

Kuan-Wei Chiu (2):
  mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
  mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting

 mm/slub.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

-- 
2.34.1


