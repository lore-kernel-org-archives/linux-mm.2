Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48704CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F10E8E000A; Tue, 18 Nov 2025 01:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2058E0005; Tue, 18 Nov 2025 01:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6D68E000A; Tue, 18 Nov 2025 01:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 751C78E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:09:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23E01C038C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:05 +0000 (UTC)
X-FDA: 84122699850.30.2A6CE4D
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5376014000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PKEj4i1e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446143; a=rsa-sha256;
	cv=none;
	b=4H3zxRHXNmVLWpAjTDzuVRvK3a8AhKB/VPhwZJK70YzrHdISUBCJAXDxOBK2x3URwM9d5p
	qqTjcHmZ8QlnfgV2bkOneC7o3/CAmJhXFyiacNFbZSqHZCS13E80clESJvYetJeCP7svMA
	ZMJYwiERUrW53sg+XMLvFnlUiv/CyrM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PKEj4i1e;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tbjJEJ5QIY1nT2LFDtdU7oXesTYO2SXqm40Pjfmjv2E=;
	b=V42vSLeDwADS2gHKH/s5JF/9lNEoq1FXd/Q6l5fSZaLSJrdCABHn3xunfzmgizL4kXiL1n
	hNWow+PUBQ2jMkQo5YOKkfqg3fS+OT6VLgJ94CNJ6vT69ecrJdwNrtM5McxHdS2TZDHRWR
	Y4IWwxBEIGmDlitK/Vx6XbbHoMxZCLY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2953ad5517dso56643125ad.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763446142; x=1764050942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tbjJEJ5QIY1nT2LFDtdU7oXesTYO2SXqm40Pjfmjv2E=;
        b=PKEj4i1evbFNRmfDSgE+MJjeE1t5nUXOvHGRu3co8x9aYB5xI64eofzWr3UzKKEtPH
         hMO24G1ZXW+jufedctoB5nc7nIQXzl4qNYm8CYM/ELEuTjuWyxKis/LtGMKz6oHm6tl8
         o4fn+bL7H39PWzQwBy/kzuGAGA6zXAcUf3IBgeELS0UG5Ei6JrxckVjz7yMWvOiNX8S2
         w/DJ8pEQ3LXauaocFxEch7VbaG+5e3oNis/9sRcPPneiolx3mzHAoAMKXrFne4rXOk6L
         WOOPejmEUFFjXSWvGTPz4vkkqDrw5n/O4nOoL6sF62q5O7UZPaVBTgLwjXrMCbbmeQuJ
         nFXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763446142; x=1764050942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbjJEJ5QIY1nT2LFDtdU7oXesTYO2SXqm40Pjfmjv2E=;
        b=T2yw57eoZgh0SnqjFDSSJ4toV+lnoGfRUwtKY2I1I/XxwfBkzJXB2BI1fIYRPqxIzw
         GIiFzmFtZMv1v8U0JDVdJqtUZLPJvJwhOHzKPQQGQxJaxgiNiLI2rUjoLlnE+T4h6f7m
         3G8cMqaYZlzACbbMhPVYDB/gp1ad25Dk6IGYzP5x4sMiJpd9bvozbZY39NFH26WDFOVC
         41ywMJdBn2jE4zEDgzmc6HGjfAUnODmkOIH8KbVfPcj2NAHt0k2j1XL/66oJ0SPX73U6
         nU1Q33ZEL1eWOZ03PT+XnBpTQacDlovhQl9M9Et+obdLFi4l1EcMGkMOwG1uVRqMy0uA
         MYGw==
X-Forwarded-Encrypted: i=1; AJvYcCX12xlsVuCGYdoxI+ZRj572mRiRVQVRagYz0pZ5yAjauML69WuPGPub3Bfkg07QCh/yBxSDrCxuUg==@kvack.org
X-Gm-Message-State: AOJu0YxNtNf0qgnC6cGqEgu6Cm4ycLPzuYLQE4J+XCnCMnGnlbgQmBVI
	w4K50hw79booivPS9Y5in6cgVQGsbZ6l8aQ7+u+YV72yk5PxD3HrbjgT
X-Gm-Gg: ASbGnctRzDXLu9dOmuFlDw3vNGfIBKd51rBY9zFoLQV0+g79ZVYBwTU6euI2RoTiG9g
	zHecbf960178tvu3u9YyiMeatiExngzb/cAffgI4SzonpFwVHTwtXX0vyxc462E0RQ5t1mjtGMK
	+BV2oMhz3kq1yTH10b0+omKFZ9LZivL3u5367EDsLAhY9fRt6a1crCebl/bc/4wOHZBAGrVBD+m
	NsxK8Yea+deLlL8MG8Pmsgn9qpd8vweNiG47Dhu+YufkHVjH5SlZStMFaaG10Vv/9lsE8QI1Gc+
	Pcb91P8tddzl5KCWOKGlozD0tkfvvRuK9HlJkW7m1T7F41E1AaKCYyGi4bvFhLdZXqJvsp6xf2N
	6nk5WXuR1cb/OSH1XGewOX89VbLS648X9CwZVhaPgGgdxB9mls7kTsa4m0tMbflp4kmyUc4ljTS
	ConWrmC0E3T9JYvBM=
X-Google-Smtp-Source: AGHT+IE3RFemSplyBu8zf5Uj45CaZlE4BG8RKxjVOzc21wEQ70V+UBVF0+Bv8pXNhFUfzuFu+JZHGg==
X-Received: by 2002:a17:903:2406:b0:295:24ab:fb06 with SMTP id d9443c01a7336-2986a6ceb22mr197924145ad.22.1763446141890;
        Mon, 17 Nov 2025 22:09:01 -0800 (PST)
Received: from chandna.localdomain ([106.222.230.39])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2986e5ef32asm124461135ad.39.2025.11.17.22.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 22:09:01 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH 0/3] mm: Coccinelle-driven cleanups across memory management code
Date: Tue, 18 Nov 2025 11:38:48 +0530
Message-ID: <cover.1763227530.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5376014000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 6uehz4odejg3cii87dkyknepwzk1kprz
X-Rspam-User: 
X-HE-Tag: 1763446143-19845
X-HE-Meta: U2FsdGVkX182xOqa45xA6WjJW76RkYX4tRyP2hZe+HVnc1MlUyqYocx5AZZu/oDW5KIv77qtSQfz92G53biCtQ7HnoFOsNCLl8Wa/aDGeMaaTR5AkCEGYEqgdpj73AV44j+g/XNueZnZjk00rvCjz1GzVk6ZNVxDaflysUPCvqQpG4HvteuzvBaE5/2tSqrmgTigE8eHYo+9YbJ1DtvAczxbHGCtkJ2pU/X/HWvoeeADCLDlhn0Wj57rNgJXfX1J7ba4PUGBK94TXwx/i/u69QQB0cv+zul8qvuUEbE0SXsR2XOkMiZxMD7MuUiSndXjX+xRJdCbwjQcX5ktvspCv/bNO/4RDPZnNrQvE99TvlQpwGAgoh3xljSFMhLC9fp/GNAIy0jo3tYPITJxzadbZs3ReQULa7lPNAmlFuHNxLjT1Qt7jEI5Mfa2sszNLjqRfDUQ8kAaS42oaax1wmZgm9iVWJ0QlMF3vJIN619HX8j4KJY2ZVvnuKs1taWeeFd6PxUd4r0pdYb8ZenXoP7qhDkIU8xRG+O3q+T4Nk+F3COGBpB30lCNegZgNs3g4vXkd/nDas6x3dMV/WjIE6wacKCzPSLH8+71Vq9NEdGP7ETWa2jSAIntL3/FxZ0NVxyAKad3mYQwS0oThDgMsjQmTQWW/5rEks3EGCbSwGwJLkuTwwOZWNxEGdbJM2qQKWcL8JqXk6IUKMG+BQ+Mjz3ObUTM68Y287HRFlhc8dEZqYF6NcQMFpzCepRRknyoMBP8nUcrWH5vIqbYZYQAEZ1g7KgssTFBNqnNbPub5I9TJ/Qry8YjKMgGL7F3jesztoE4wxDh/QfrjhbGgzv6prbjWL2OxivJcYQYeZMeNcWrmdAHhwlOhXbcuDcuIydQe0qxDI/B1Y7KHBfI5aaNHQ1SYxxlN5yaJCY7J5+oInBgG/N0zOyQ6TJIGlqCuBG+CIcKQ4ZuCSrCDDzVaTT3+Uw
 IpnLCD5Y
 cf+z/B/WoK+yyaZnKCtpy5YhNiqNvQnzZtowIKGyUwYB2eiKwrePf4EuTDFs12MzMmhU7jJbbF187wPfh/EFJ+xa8Yj+jp68AVaOe6BN5ZY5DGrXdAJZzhrtRgTAfKj0aADcMpMvQLFQr9rn2GHFZryQ4FnLko5Vbi2ZhQyKK0ozmamRAz10O7qJlKBHuhNqSKknjhC3+l8gfPmSWKqos92UFd6fjRmMzfOmdxN0zT3/kfUQys0sCEsBaiNbZlX4UfHceZMSalV+sMa5JLLQ2OYsMKXNMU6DT4+0T88M7n7kZX4ikHJT7EENpA+iuKSCT9bWpf9xL00pbAr7/uZ+j28gW30vo3I5Yn097e4gY/jn7nDaXDnNzCXF+WUVJADatw3qEG+lbliGML/jvggVwT5ft9VgUReDq26zs7eds/kJKeIPBM5ZhXi6j9QQi3ebVz4pMAjAWSA4XFfXZLy6ADc3dn+/yLyYI+5wlbUHaDBuapTYomQSlhGcg0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series contains three minor cleanups identified by
Coccinelle scripts under scripts/coccinelle/misc/:

  * Replace manual ternary expression with the min() macro in pagewalk.c
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/

Sahil Chandna (3):
  mm/pagewalk: use min() macro instead of manual ternary
  mm/vmscan: use %pe to print PTR_ERR() values
  mm/zswap: use %pe to print PTR_ERR() values

 mm/pagewalk.c | 2 +-
 mm/vmscan.c   | 4 ++--
 mm/zswap.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
2.50.1


