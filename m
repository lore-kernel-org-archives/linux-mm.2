Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4687D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 07:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00126B0088; Sun, 11 Jan 2026 02:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADEC6B0089; Sun, 11 Jan 2026 02:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FF86B008A; Sun, 11 Jan 2026 02:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C9B6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 02:45:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F225F8B749
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:08 +0000 (UTC)
X-FDA: 84318897096.07.AB99D0D
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2E872180005
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 07:45:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iinnEXHl;
	spf=pass (imf06.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768117507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=91Pn9D4Lx686aqQc6EvNJCkVLTacmBgG0CY6/mdSfQM=;
	b=BJHIhPof27UFd4aApqjPXEhoxs0r2ZuhS/Ybi+qAO9zYOuGxWEIY1+JlqfkY5nG1JUWZwJ
	tXK1erhxS1Rhzcth6DMDbnzyONE4jOSgQIXXSqpfa85tgqc4UvAGtKD4z+WlyoazpqfcQr
	NIfGghOXpKFiLG23HiZKu27TlTYi5W4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iinnEXHl;
	spf=pass (imf06.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768117507; a=rsa-sha256;
	cv=none;
	b=hHQIzf1FKTBK95zZLNijAVrHd8zxH2koQEAXxdr3JZ2Cs0N/FPrvo0TIyEkULRbe/NmRlF
	Y3lGXoiyFUBW03airdzo2uYFjcSiNoXdyzti6OzNaNiOQuHJptLIuu773+EjkX8M1sn8pY
	TXxFHn+xnFB2X7iqmZ0jkhbwscmMFSE=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c1e4a9033abso2925339a12.3
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 23:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768117506; x=1768722306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=91Pn9D4Lx686aqQc6EvNJCkVLTacmBgG0CY6/mdSfQM=;
        b=iinnEXHlDbG4TLE/72mneNLljYhzGYrj/cStQSlCxkvMXMdumqVXgw3h83Yf4pBinW
         tkBzU5SmN+NV3db68bZIBimbQofOvsESj7Zv9LGNSERXynHbUJP014t/3/dThKGX3yru
         OIp4aYS99pwOGlqxrKhxqNZILOcEJTdNVj+rgi/AAb4gsoV+lPrvvcinS4NpZ9P7QQ2b
         d8aPpd8IUswjOv2roOOuPGKXH0wBgsWM5GCniuL4KwpUdrHNNYO+FqaINBSHD5ZnyIjI
         csG7JspunsbE784p5lTH4xFG2cILIRwzsczMpPDGHuPEeU5pLR/q1j/EHlWILHiqHf8Q
         3juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768117506; x=1768722306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91Pn9D4Lx686aqQc6EvNJCkVLTacmBgG0CY6/mdSfQM=;
        b=JYDJcB847+oMY7RnM2syouMwstOp28LJJ9j3o92O3whPR31RoakKkDYCdnxl/74IMb
         7K306kqiEDB8LSDv5aRZxVZBpgMiorR+r4vrzLduk3Z3E20n5xOlZwY25SLuvfEeYv7R
         aH4WWr98qS5oFuJ5eJNlSrub6+4lJTJezStGlaDHRwbV7uCpbFcL3CibeBb3qwlZtTr1
         KbTeeXKBdieA8ty+9MIsJyqB8Aa97gkxbltW30EVA1L/SxX7QjcujyIK/NAa4CQnnVuP
         zV+4RrhMfPeOMqwmmSStxEfmdx8+t92gf+95DdSO17wRn0vTb9hThiW3nBErsSy+upXR
         a2zg==
X-Forwarded-Encrypted: i=1; AJvYcCW5SqaIPNPIKJhK6tIf9kExpka7Yu9hEK1yKKNnxtLeycHdTbANBdMDX51sQ5S7aMkGUmSaFthefA==@kvack.org
X-Gm-Message-State: AOJu0Yw4LE+yJm9hK3f915dh0DrUclAR1d8KSv4H8q/TikL7GresvV7x
	+2AU/E4weqacKUGGtRBhC/pUSwXKZWIwYXoe/gQigmPM3CCgBfPsUI7e
X-Gm-Gg: AY/fxX68x8HqktnHEM4xWWHBJa/6R3DiCVkDQp4Jf8VIxE+UENk1UC1qsQJosEWnw9c
	5G0dqx8xUaj5B+kCfvDNakw9HJPuFzQ6rvBqdbZgTCRZ2hY+KkyQbdsHAA2QL7q7lbZmfneFvmH
	oNeWRW612ckluu1X5tVD6BaKdSGddrs9XawO+vJovtP1OL8vxoMVMZgjcyaTEkx1Ry/DqqAo9ii
	k9TKAPjFVN/ESzTQ1aS4gyVJiQTl8T7vRovVolD0JwxkFAxMZ2lWlV6uRN2cUdC/pxfphAn453h
	hua+rB/T+z65rjUYEdCsY0zFEsVW2ZPliC9huokRW/Ps/G77k+hYyCOOGtH4DLJZCmBckq3pJWJ
	Safm3P0Nztp4ZvagJ49Bqxgk/WR9Osstu4YQHvpK4SQq3GIKanRwUUIy3nTfl+T5SlkvP/E77y6
	NlkE4XNaju3BHDb2Xn5CVKnb6Zg5alqAgHQea480u+
X-Google-Smtp-Source: AGHT+IESX9jR3Ww8200BgX5GPnSMc0XzoGJnxCyRuzNGJw1YTB4+hhScgEv6qazvZYWBl4/2/rr/tA==
X-Received: by 2002:a17:903:1a8b:b0:2a1:5785:4417 with SMTP id d9443c01a7336-2a3ee487487mr140445715ad.34.1768117505862;
        Sat, 10 Jan 2026 23:45:05 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.40])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2f8asm145284015ad.57.2026.01.10.23.44.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 10 Jan 2026 23:45:05 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	chengkaitao <pilgrimtao@gmail.com>
Subject: [PATCH v5 0/2] Generalize vmemmap_populate_hugepages to sparc
Date: Sun, 11 Jan 2026 15:44:51 +0800
Message-ID: <20260111074453.66728-1-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rx9rcc7nteo85hwewc58spg669foirai
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E872180005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768117506-130915
X-HE-Meta: U2FsdGVkX1+5iuNhFPg+dKPU2ChoSas7WQRUZLmthc9lrr3jcXgsmHA1Ol0wg1sHgrMoEg0e9q1Hs8e4lAn9Uc9hD1oY4p22FKvDIbkzUM/VKEPO6bFwQDdgGqyEwmgRurssuMnk5eCCTjyTUyhdm8mbQ5IbIptZS3nbWGUwTcDjb1X/lZaBSTSo9uiSK+Ydwlg/WftatwMBdpcwoCI7niEN6tZtsZjCfPvz9PxpX0dZj+MbjyFH0cDU7fkqNYNCB/+aba8mXFeCw9jAntKcWh1hqB8XJI2L5bLk+2Rd9ifFH5o1HCpQ6Z01UagoCiMwMpWnD1cAjZRU1sjMVY9Uho359iQS8n111DEpUR3JEKZi/cbFW7DcTx3+qGggSRDKjvDrmtlKWvYyeqyvGR9/l5rOJ+c3yDD05W854k4qaqWVlM/dcby72jFh6S7iYodnImc3OsRap7dNquo8qZtQpHRIVa/QmHGibBNEXn8vgv+IRNJ1nInq27/EIuDvXSe2oXUWYNkddr2TVE4zw687y1D30I2PKbPu+Rfl+ewBKpnMIMHRshAQLGitJ5qKK4kveFn/BdZSqvQXg8QS17Qp2tr32rieKe67u7I7c8OuENcInpXXTPqb/DbvPvNnMFZUMxVsJ14pRQZbNeSz09FYAszyX+MHodD6MqLZGkif8yH2nna9d9cPxDoKGwbSQ3sE2cinVY/WgjTfjeVz/PMCLJ/Imfg1oxrnahtVW4PCOa0fjrmSym06hV/5M51R+7WjgxFTKOf2UV/mA1ZrvHhb7USbhuvBkNXzHt/+M04TIs4zLIIhKF7dMdYUeqyS9vNnb0VqxjGFNY6queyZEFjUiofr7OQ8VgtWMmPFT2xybJVdZl6T3VNqCwIrDDvXNcU9WZVqJJ7Z4WP+qukUf0aDRXucWr8Hkm9IEMClk4nb4ULY27FIEda/1w1NYtU+Cxq4s66g453UVgVFL21K8zk
 qE2cqoxW
 qMmnXFoFvvWnlQBw8a7lF2GR7o0JgsAnjIuO0VPhTvjIlJr2RT6bD+r51oV/hCjRPrswk5TMsY1B/JFQdg2Ad4zcNRLSVFyDimdxk+aQvXV7k0sgF1VuG7xmCgo7JUTQDNoDqtjzChfRKCZHHaTco9eXpxBYN5Ip0kQiqDHiiQfVk29Zw3t5y5HV8NoZd65AjXdwMJauT/JJxUkWU18kNIF8KXrK3Ny03HpRlaEi0g/PfWICBtuqxpFPV2kVyTAF/TfiPxcHGzO0bBdh1sScEkvGoZO2O448zmPWGNrWkvjOboS1KqGwXLT9jR24+TeYpSi76TECeHkf28QuZ8NXGC8HkJGKGT/EG24xthW5eccmNWPp4SKtuykH3fPZR2yHfIPl39rvo1nX3k8GkkG6Y2dLN5xJoIdcIj4oWIWq3RbijB2qfC1C5lFwcr43MG8+/kGYkvc86pwU9pX34oo290LkLwNBVgaao0aUOJS4WiNLZ9jM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change sparc's implementation of vmemmap_populate() using
vmemmap_populate_hugepages() to streamline the code. Another
benefit is that it allows us to eliminate the external declarations
of vmemmap_p?d_populate functions and convert them to static functions.

Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
_basepages, which differs from sparc's original implementation.
During the v1 discussion with Mike Rapoport, sparc uses base pages
in the kernel page tables, so it should be able to use them in
vmemmap as well. Consequently, no additional special handling is
required.

Remove unnecessary whitespace from sparc.

Changes in v5:
- remove [PATCH v4 3/3] sparc: Remove unnecessary whitespace

Changes in v4:
- Add commit message
- Add verification that pmd actually maps a large page in the
vmemmap_check_pmd function

Changes in v3:
- Allow sparc to fallback to vmemmap_populate_basepages
- Convert vmemmap_p?d_populate() to static functions
- Split the v1 patch

Changes in v2:
- Revert the whitespace deletions
- Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed

Link to V4:
https://lore.kernel.org/all/20251219115812.65855-1-pilgrimtao@gmail.com/
Link to V3:
https://lore.kernel.org/all/20251218174749.45965-1-pilgrimtao@gmail.com/
Link to V2:
https://lore.kernel.org/all/20251218130957.36892-1-pilgrimtao@gmail.com/
Link to V1:
https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/

Chengkaitao (2):
  sparc: Use vmemmap_populate_hugepages for vmemmap_populate
  mm: Convert vmemmap_p?d_populate() to static functions

 arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
 include/linux/mm.h      |  7 ------
 mm/sparse-vmemmap.c     | 10 ++++-----
 3 files changed, 21 insertions(+), 43 deletions(-)

-- 
2.50.1 (Apple Git-155)


