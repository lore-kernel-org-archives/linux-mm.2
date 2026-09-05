Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4129DC79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 18:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7CA16B0088; Sat,  5 Sep 2026 14:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DC76B008A; Sat,  5 Sep 2026 14:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C746B008C; Sat,  5 Sep 2026 14:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6716B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:31:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A91E1403B7
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:31:54 +0000 (UTC)
X-FDA: 85180552548.28.AEDE51A
Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id D21F380003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:31:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cmFtC0xD;
	spf=pass (imf02.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788633112;
	b=tE+kS7/PDwjOKcspUCqcMvGBQzfTOHcTh5u/CSe2IpKT7FKoqco//3IxTwoSEmqJAbT23b
	vmClSEtRLRsoptNh0rr/hhoz6YJtkaa7GB0DxR2Mp8FVAtp5BPDVTpCT31LQ5kz5R3At0j
	mHGeW+1hKTLB0JFL3lRYz+KMB/tUzbI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cmFtC0xD;
	spf=pass (imf02.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.74 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788633112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zfasN+n5VbNV4Zf/uf4x/WVUuqiwji5V6lr+yEJ2jks=;
	b=JrNZ5dBcN3RQY6eHm54AD5E1pdwyeCxKK3/xz8DXe9nsU/dpzbxEpTWnO07kmbLkrUsFpx
	1CZfEqK10UCT9wGBZz61WcPMOKBXRxWs25Tys0tzQc560HCBzAAHQgw1TizgV98cXFQTVi
	1B3b9mfwzMN0yuwcQLTIw4Yrg3IW0ek=
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-48436370540so945210f8f.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 11:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788633111; x=1789237911; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zfasN+n5VbNV4Zf/uf4x/WVUuqiwji5V6lr+yEJ2jks=;
        b=cmFtC0xDCxHu+lbH82N5bHZZ7oRIp4LYqUvre9XzO8bdP2vTJRt/Hzm3BO2Juxu28G
         azHKv+3OuH54iKbc3J6nJKKpnVW1h95ETMULVDBV2SpRUpS/nqmsPsj7U/rqlYHEGxrJ
         56H3ebxsnDvGZX6kKfJFafEBzITlfrP8bb9kUBAJ6Brr/uAlbFN3iXBXt+UKrnBtifIz
         u9o/CqRQF5EcqGMqp1Eqa7ofr/hWHFlqPE6SrUdOXQPDgKekoRj6cc2AyFo5e2CX/E9Z
         09+LLxMLOEc8+VGSGkEyVIN6G5HUCtjlj4tIOecf1U2ESDPrf/RghInfzT8J1ZmCskcS
         0mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788633111; x=1789237911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zfasN+n5VbNV4Zf/uf4x/WVUuqiwji5V6lr+yEJ2jks=;
        b=PSeKDlloV6AsqKuclMo/Iaym1noG8o9BP5Y9ccrfya2WIgb9eE3mhwc7qhBztwHaQg
         ketOFBNpnN3MeVv5onpknJ31Tr3+DjlkK+/7vf4Nv30gkxtAnvjj8gEh12RVCXUZjr26
         Gh4U5kdiFrtEy3rZmYYngxCSerukbce9Hp5Herpp3OkTiuE3FeyXqXA+tmP4V697zJ6w
         /yLaJLMFSxEtJUmtHl9Wj1EaVYkC52Tg0x7xoGdj9eiNVlGMbYZUW8tI8rl2JRPaGTfD
         sg4ILMCA3n6oOpfIKew6zcVc9cyWAWAmjnljo2YHdBrnbcYwicu8mSkk2k2cl3fhKKCn
         fdgQ==
X-Forwarded-Encrypted: i=1; AKwUvBwguxf4teIyHUyzOoGZpxyTVX9+I1/HbgBU9IhKxfi4+UFo/4CzJj7CcEt7kltzZUuSJ5WYQPcjkA==@kvack.org
X-Gm-Message-State: AFuF++n3/ztYfM/sRT8k2fAxW9oFZ8Impn5JAt4eyrS0D2gVz+FiO+2k
	imkG6DrIflkLnN5wfpzFqbOpPlzRatGCxbpfAf8D6yJulFF+jC2H3Epz
X-Gm-Gg: AYBFou3QXJLGGK5APSe7YB42Of8po5TraiVT2ymlSlLtCwbHZv7cXp5WXL+q2LEs7vr
	Lt+31FMOv3pwqY9lt/L4MqCAbpjFgVMotDXvJgOk4XGU3Brezkc60loHaFxZSpwyvZ/L16vAWVz
	UNyNJQ9i2QGaE6CWqlsZlpjt/jgw2Xz8VPBMNu848prObtHZ1rxqdIM8qP7fpI+JSvqIboz0S2m
	X6uhTusfOy9rPr06mia/h0L04V6K2C4KvbWbSQYlJiRiJ08N+AGxf/UYVBUWdzdM3YlgfNPKPSS
	3M6HbqA/8q/H7YrXgXzkPAnzTEvvk3E05HZktgRM3ZRzY5pJo9f0/4262ACypU4+hkRG70W1YNh
	587pzkGz2tane/BmYXMExieFHgl/HAKzaCIG8sn+5sedSepP7lfcsITTzuOE+RWvqbboJw6XZvb
	aZOjmcMWx4Tb5HUI9WWQtH7Hk0ddu4YB+rmdCZ0tTZTxls4L+4Fgo5TmyDFFef+uIwZR8qOdJxe
	fmQDM9OK192rj6y89+HYKGaTaQ/JbLQr7Y83b6b
X-Received: by 2002:a5d:6f1e:0:b0:485:8c16:5ef0 with SMTP id ffacd0b85a97d-4858c166129mr12096459f8f.42.1788633111054;
        Sat, 05 Sep 2026 11:31:51 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm13066670f8f.3.2026.09.05.11.31.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 11:31:49 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH v2 0/3] mm: minor janitorial style cleanups  
Date: Sat,  5 Sep 2026 21:31:32 +0300
Message-ID: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D21F380003
X-Stat-Signature: bjx7aw486zt3nnmadz889jypinbqe8ki
X-HE-Tag: 1788633112-574811
X-HE-Meta: U2FsdGVkX19dms2YqKMjpjNyvSYd8XdQoijjLB6v7WmVUGV1bw2lJAKWnFKowkYTZXHXEKjPuNP05wgTzP0zxieU6hSnMV0xhHtGQlCYnEM2NXdDzSZurlaCHgfpQVORAf6V3/q/QaVyI4OkuZ/bIHaM9vEMCW7k+2Gu6db0EGHp0KHHH2qoDHKgA7eV5oecs+rdUct2MXW2+Iu7bZSbd+kCLZM/PBqI9gl23CQdTfte76Lx5DkjbW2MOvDpUHIV7P8C4odL8P/IgPMiycY77MFQBwCvw/U9CfoIuBIqTGSoLKOmIGMX/qrrHP6pRYboKJyh8JNgrh6fIuEzGOLiOuBpn64UmpITBlkq7Ec0UDYinqarGGVUqsX6eDvKRlxXKJYvOL2ODNufHQJId8O0m0aUnND/tPOrGMac8dZpgK5rTjI+6O0GDdBoxHyuO7cry6vQiRQgw0kQLI7xe8iQg9uv+2hIMfeDRougvEnOvZsQuvfmV2JhDEt88xtR9VHY5HMjJ1IeQtjq4rnG3qmhdu/dUrdOduen+Wq7L5uWEqTzfXzYtrd2JHZNEJ14zD+FqZkjygCv9jA0lEIFYcWD2T3KW6w3Iw20zrbYO4b6xWAY6xK/S6O88FwaHMWAjiek3HUDSRdB+y2SgITt41e3MLafNx4o97GW8SnaL0fvab09c0fKgI27mCwJoOQj22uRepeYACf/h1k3w92LRHJuqMWjkg090/5c4sYYprNfRMglslApcUFtOyHqqPXcm6LLVCCZwEy2ztZT+lIhdzEulg6H32VPRA7VazuMxLkpcbVYHA/co318PQTl/oAnOQiczNDcZigtJwcSYvuSEvV0Qw9JItECBdZxeE2K2EiqWv09Wh3CiBLBc/Wfk/U5FwOfxKShSkVRX39Efe90V7ZdqbBn2r6mVY9z44XMug0jfT7viM+6SN7xHOjdXRMHlhlDGfXF3cmlA0zdCOwGkj/
 GnHvY7oe
 OknXgOZnKd9ES9HQ5cl65jN4Msg4E9154mu1g2EQ0Xpn6eE4M6GHK83KXZiwbht31Nf+oVYd94/wIfxM41btVT08/su/I6ufhnlVw8vMy9rGaVo4op6Opn4GgTwrFTXDjKmHleKXSKl3JUH+CNDo+az5Zmy6sxdWx5xT8JCIwu57TL96lXYy89oAB6CHY4Vna/L0X9fRqdNePgUeQM/Ku3C+PyPVjhsMa3riollNAl6hdfB3vzqBCflAnDKLN1qp598vUXmdplnE8H5Nk6O+l44lPpp6kohoD9brNXT/NXAli4AgSysjJY6TVM5HaRuiMCbqNR15ulycPeJGGipcjSFM+2P2tvnV0S5bnsHIMq1Gf2/2zuPOTS3g1N98IDsRAVkTof7QcN5BG5vhpTuPVKdl5bh9rnrBRvDhiqkqEMAbTbeYrPkaacqhLIF9l2Y1HO+ZwcceeUdr5ymx/mxW9ov5mZ50g2KaeOquyJGTWiSsX5jr3vykPfZb/Dx38JL08bQxR8KqARf5M4en3S7o8z7Dy0JDDgvoSBXNLr7Gc3gW9d+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series resolves various coding style issues flagged by 
checkpatch.pl across mmap.c , vmscan.c and hugetlb.c.

Changes in v2:
- Restored filename comment at the top of mmap.c.
- Restore <asm/...> headers in mmap.c as they are architecture-specific. 
- Remove blank lines above VMA_ITERATORS and NODEMASK_ALLOC declarations.
- Fixed commit message typos.


Thanks for the thorough review and guidance. As a newcomer every 
feedback and advice is really valuable to my workflow.

(Note: Apologies for the stray huge_memory.c patch included in v1 by 
accident; this v2 series correctly focuses strictly on mmap, vmscan, and hugetlb.)

No functional changes are introduced.

Christos Skarlos (3):
  mm/mmap: fix various coding style warnings
  mm/vmscan: fix various coding style warnings and errors
  mm/hugetlb: fix various coding style warnings.

 mm/hugetlb.c | 16 ++++++++++------
 mm/mmap.c    | 12 +++++++-----
 mm/vmscan.c  | 11 ++++++-----
 3 files changed, 23 insertions(+), 16 deletions(-)

-- 
2.55.0


