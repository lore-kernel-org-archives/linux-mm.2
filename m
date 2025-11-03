Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F940CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A568E0029; Mon,  3 Nov 2025 02:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB648E0015; Mon,  3 Nov 2025 02:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9F18E0029; Mon,  3 Nov 2025 02:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB458E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:51:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1EB013C066
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:51:25 +0000 (UTC)
X-FDA: 84068525730.13.2C59726
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6D874180002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:51:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=5nIjcMamPLCgGJQkcL7BlkexIV74mM0iX4E75eqixbU=;
	b=UUSIdqDY5GnK6TmlGD3J2zQheQewMg1TdS/gKQD3YrJfG5LNF8fSG6qqBU4vNzk4R2a+eS
	GR+0KV2qz0CL+gVHnyx7CDBsbn4oYVzxefi1CR2FPhZoNAhOPZa2fr2QOCAnt/hkAA/EAB
	KWH/cqm52FXgYBUnKdWHOuSOo0zw2uk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156284; a=rsa-sha256;
	cv=none;
	b=8Q05NmEu7BO6ScJpXVHiePWbo6iKLpxSP6eDnOVc2EFfvVr3CDA0knmI/0m0N5YPJX7iOx
	uPIiZdbnYUS0kGYU424KiJPaPKnPJaTnOaPV1boqEQtir2+0eeQpCpJe960C1rT/lmvNRw
	0TEsSkNau8qfQd46nzSVLEIe8mZq6rE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c45ff70000001609-f0-69085ef71258
From: Byungchul Park <byungchul@sk.com>
To: linux-mm@kvack.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	davem@davemloft.net,
	kuba@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	pabeni@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	horms@kernel.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ilias.apalodimas@linaro.org,
	willy@infradead.org,
	brauner@kernel.org,
	kas@kernel.org,
	yuzhao@google.com,
	usamaarif642@gmail.com,
	baolin.wang@linux.alibaba.com,
	almasrymina@google.com,
	toke@redhat.com,
	asml.silence@gmail.com,
	bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	sfr@canb.auug.org.au,
	dw@davidwei.uk,
	ap420073@gmail.com,
	dtatulea@nvidia.com
Subject: [RFC mm v5 0/2] mm, page_pool: introduce a new page type for page pool in page type
Date: Mon,  3 Nov 2025 16:51:06 +0900
Message-Id: <20251103075108.26437-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSa0hTcRiH/Z9zds5xtjrNLsf6YAxEsbQLSm8Q4ZfgFEhK3yqqoQcdOS+b
	2RQCTcm01GVbeVm5CqduxmxetplazaWmXcwuTExnVgppFtNmXsC80LeH9+H3fHppXDxF7KBl
	yem8IlmaJCGFhPDnhgdhc2dp2b6qUgZ05noSTH9VUDNqE8B8/QQGOmMLgtn5IQqW27sQzDi7
	SZjs9CB4eN+Lg+5tHgF/zAs42FsnEPwoe0TC964xCkyWaHAbxgloy7fiMFbSQ0JR3iIO7fPT
	FFyx1a6EG7Mp6G8pFoBmoRoHa/YoBe9bdSSM1C8LYNxRRMDLijoCfmudOLiLo6BLvw28fVMI
	nGYrBt4bd0n4WN6KQXP7RwpuDehJ+JrnRjDQOUaAdukaCZU5xQgW/64kp9WzAqh8MUJFhXM5
	LhfJdU79wrmmukGM+1R2k+BcHb0YZ68Ypji95SLXWBvKFboGcM5iLCA5i6eU4j5/aiO5nrJF
	grN/OcTZbTMYV5Q7TcZsPSU8HM8nyTJ4xd4j54WJda9dWKp5k+qboQfPRhq/QuRLs0wEayyY
	xAoRvcZN6rTVM8kEsy7XPL7KW5h9bK12doWFNM5cp9mhjsdrwp85w1YZNGtMMEGsoztXsMoi
	JpI11T9F6/1A1tTwbG3MMtU0+91gJNZFAPu81kWokZ8e+RiRWJacIZfKkiLCEzOTZarwuBS5
	Ba38gOHy0mkb8vSfdCCGRpINotE4SiYWSDOUmXIHYmlcskU0mEfIxKJ4aWYWr0g5p7iYxCsd
	aCdNSLaLDngvxYuZBGk6f4HnU3nFf4vRvjuyUblTbuoLCAtpzmqcTjsarA3xOD3pEuvtg1eL
	++OVpgVqkyRomHLb/WKcd1KPaSLngj4s9dA1o6ELu+65N1teBWrfRYdhxze+sX07dVat31jo
	W+Lf6lO1JzZd94T1eo70evWDjWadqoD3qS6LtXakNtS8nWtS2dUJ3WljJ/J3SwhlonR/KK5Q
	Sv8B0EkNPv8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRfUgTcRzH8X53t7tzuTrM9DAqWEgk2QNofM2K/ol+BEUEFVSoQw8d6szN
	xEWJNunBdM3awtJoEdl0q+V82CY6YzNdWSaaNTHTrAxSLHSNdMLSoP9e8IbPPx+WjOijYli5
	okBQKmQ5UlpMiY8ka+IDKax8xwN7EtRaLTSY/xTB43GHCOYt3wmobWhF4J8fYSDU0Y1grquH
	hinPLIKHDwIk1L4to+C3dYEEZ9t3BD+qn9DwrXuCAbPtMIzVTVLQfsVOwsQNLw2VZUESOuZn
	GLjkMC0NN5Uw4Ln3UgT9rVoR6BcekWAvGWdgsK2Whk+WkAgm3ZUUvLxbT8EvQxcJY9r90G2M
	gkDvNIIuq52AQMU9GobutBHQ0jHEwK0BIw1fysYQDHgmKDAsXqWhplSLIPhnaXJG5xdBzYtP
	zP7tuNTno7Fn+ieJm+uHCfy+uorCPtcrAjvvjjLYaDuHm0xxuNw3QGJbwzUa22ZvMvjj+3Ya
	e6uDFHZ+TsJOxxyBKzUz9NGoU+I9GUKOvFBQbt+XJs6qf+MjzlpXF32t85IlSL+yHLEszyXw
	zbr8chTG0txm3uebJ5cdye3gTQb/ksUsyV1n+RFX47+whjvD36/T/zPFxfLuHo1o2RIukTdb
	OtGyeW4jb372nNQh1ohWNKBIuaIwVybPSdymys5SK+RF29Lzcm1o6eW6i4tVDuQfPOhGHIuk
	4ZLxdEYeIZIVqtS5bsSzpDRSMlxGySMkGTL1eUGZl6o8lyOo3GgdS0mjJYdOCmkRXKasQMgW
	hLOC8n8l2LCYEpQQdq1nyts3pQtGXTSd0fQde/5w91p15miKK6g9YPxgcr3ee9vjDdcq1oQ0
	MdmE/+SisCFVV9mfcV8RirdYoPeFP3c2Vd2i7wydLjYNRD/a228uwsp3NRWuq0+Pn2DWX94q
	NBZvsQ0ubCos+BbYnXj8wgomOX/VhuJ2h2GXNVZKqbJkO+NIpUr2F4rnsTHhAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D874180002
X-Rspamd-Server: rspam02
X-Stat-Signature: nmjbxqqcmhmt54dt5j8abf5n97u91qhw
X-HE-Tag: 1762156283-458436
X-HE-Meta: U2FsdGVkX19Es1CX6sgs+gFOzers3aHC4YEDen/MjSN4Bqgamd1Y7syjYkXVFbupYeBBOHd/Pb+KLTjWgHnGbULU9zKBlB5zDXyptdG6bDMP9BDfQNZz3218k6wHb3wNGx4eO/Bq7stquxoGbHhU0GOx57q0vy0KeTBINigFgycpXUyITI0V6+mEzC570cNWN6HPm9NL5579P2x+ntR6sCmACB8aVAQzVQdAAixHGYa6sPPBjurTQ2jUjb+Sz9wkhtZLvCbhceU1hTPbRZXIf2yavDnWTrG0ogk3VxZD2lgKFhR0msGnfzWmk5XRHRjqSmzCQ/eoX3VT6riaBzyXTNDvyhc21f++4hEZt5iqVSFbyK2ih2BMkfbplg9Fp4UWngfDhzcl1y9bjJm2xPzhZphNa/RTLdD2zOW93uGW8i5/LTWC2zON1vNg+VPViOrMLACPm1/Zgnt0cA/qYmVW3yCW+Tw0vBp0VXNwgFC4mDME6cb1iQLblQabatdEJCFGmWZ0jQR35tJsgmS9n384D/jkKD/YCQ/CoJWpUC0vHRdlVAhoP8o8apAYNP33zs5lspDBpAFsqk79JBV/EdBt750EviKrbxsMqW7nh4qJ0Q4IKA52BhvnMfWVmD/WPy25jfgnhZTo4B1ozGz6dwk5DeBvmSRyzp0Rivwd/JDZZbaNPD9KIilb8zIJEhcbTQiApA1Q5dFBRpfU1i0Z1ImfOVcqe9pkVWwRUOzBbVvrG3i9AOVfAZIoxnnZ9B0sey+HIMLgkoV3w5bZEYbVhJ7JUUqar79iextHCwyTmIx2jSV+wpSpsS1YDuyuEt/KYGRWaaNI5KEZMpFPnlc01kBzdC3V5ka++Gyp385P+UUc8kHgOcZzBuuuxc0RsHG2NQxHU5DTxC7u1Pv2364CLoe3MvuFx2nHcHSFOc8VczO4sTUfkh5OEGShzj/btx7un2g/1B03ZUFSzhOZiT41l1m
 NMxKQZvJ
 3jFxpCtJIXOrrxbnlQYao3bSm87UZq4L+UjYw/TvOGWhxUN/Z4GvUoN1FIgpoAMcz8o/MhQyMGRvjz8Kfmdm/YL6ghg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set is supposed to go via the mm tree, but it currently also
depends on patches in the net-next tree.  For now, this set is based
on linux-next, but will apply cleanly (or get rebased) after mm tree was
rebased.

Changes from v4:
	1. Rebase on the latest version of linux-next as of Nov 3.
	2. Improve commit messages. (feedbacked by Jakub and Mina)
	3. Add Acked-by and Reviewed-by.  Thanks to Mina.

Changes from v3:
	1. Rebase on next-20251023 of linux-next.
	2. Split into two, mm changes and network changes.
	3. Improve the comments (feedbacked by Jakub)

Changes from v2:
	1. Rebase on linux-next as of Jul 29.
	2. Skip 'niov->pp = NULL' when it's allocated using __GFP_ZERO.
	3. Change trivial coding style. (feedbacked by Mina)
	4. Add Co-developed-by, Acked-by, and Reviewed-by properly.
	   Thanks to all.

Changes from v1:
	1. Rebase on linux-next.
	2. Initialize net_iov->pp = NULL when allocating net_iov in
	   net_devmem_bind_dmabuf() and io_zcrx_create_area().
	3. Use ->pp for net_iov to identify if it's pp rather than
	   always consider net_iov as pp.
	4. Add Suggested-by: David Hildenbrand <david@redhat.com>.

Byungchul Park (2):
  page_pool: check nmdesc->pp to see its usage as page pool for net_iov
    not page-backed
  mm: introduce a new page type for page pool in page type

 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  2 +-
 include/linux/mm.h                            | 27 +++----------------
 include/linux/page-flags.h                    |  6 +++++
 include/net/netmem.h                          |  2 +-
 mm/page_alloc.c                               |  8 +++---
 net/core/devmem.c                             |  1 +
 net/core/netmem_priv.h                        | 25 +++++++++--------
 net/core/page_pool.c                          | 14 ++++++++--
 8 files changed, 40 insertions(+), 45 deletions(-)


base-commit: e1f5bb196f0b0eee197e06d361f8ac5f091c2963
-- 
2.17.1


