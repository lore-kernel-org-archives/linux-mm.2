Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17E1B606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Mn9NIxSc
Received: by kanga.kvack.org (Postfix)
	id 30C8D6B063D; Thu, 19 Nov 2026 22:30:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD476B06F2; Thu, 19 Nov 2026 22:30:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AC776B0673; Thu, 19 Nov 2026 22:30:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDC9F6B0745
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:30:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F08BA8C4A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:03 +0000 (UTC)
X-FDA: 85454068686.20.0B19B38
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8876180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:30:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Mn9NIxSc;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795145401;
	b=BOk0p2WIBlQZQY7ma7bpeOKZrB55Z5dSjOEsPXSR4v08TYp32tQJ1MDWIoc/sSEpPhX2gT
	cY+VKI9ZZlQMa/s3XS8eHLYkSUfgSHb6AzP1/L4j/eIR72OfGTzd9cDoPIf2/PPeuKXdLe
	ROcq2Aw9i8OO/Dn09DJZ9b8P341vblk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795145401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2vWivvs8YtRgI+rlfkcyXQ95IULAvX+plc/aI2l6Quo=;
	b=W0uPxt9YYLYaqoxOe3wS3EYNE/9unKKZUbDOZcil3TTkhhfWAvA6BPk6ctrtoJpijfMitd
	CDxAtef9Gsg7JOj/+zcJ+jDEQ5w6pbG48NaFx3LqQhFyA3wMtJxFOFiWg+lICWclPfbVOR
	RxtVKajMqzKrLkyFl5VFHPbevR/Jk7c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Mn9NIxSc;
	spf=pass (imf16.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so121160eec.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795145400; x=1795750200; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2vWivvs8YtRgI+rlfkcyXQ95IULAvX+plc/aI2l6Quo=;
        b=Mn9NIxSc6uQjwSdqHfGGnKpzhzXdTP1g6uSYSxabvfQ6o/MyyCpTj/zFRMMD3jV8SE
         C3cbNdwut+A792m1EpzrQpPMcTHv1TlQon+rf7KMLcoWmCgYgrAPervvvXO8f2zyZbmM
         N9gBOCr9pQvpndR6rXjrBcVxBSPqID+BL/pMPu3I2bXAiCw9/pvr6+fY9J+y1l5n2t3W
         mN4x3l0l431MXoWSkuoQO4UYYj8EEbG3uwRrUV9pLNlIvmN80+gLJBRa88yVAZ4dA5uV
         yf1dgwrar2SayYBH/Bvv4Kt9GeFK5yHWOLN41dfihqPt3VAQPLA4GWrWlei0RjXHYZa9
         hnNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795145400; x=1795750200;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2vWivvs8YtRgI+rlfkcyXQ95IULAvX+plc/aI2l6Quo=;
        b=G0F/U0Upkf/rGfCzQIgEsmj+GM5D7Vd0tsKiLhCKfWzKAbKwSwzHUFGdFEC/IuZZy7
         fryhywGjAfNQZIfJ3B2WCXNJ3hfDCL03Fe2RvnkKfWiTcSxGiV6TRaCBd0EEa1wn0TcL
         Q1Ow1mUne40PUS0x8b3ML0zm4gw6g2ud/DmNaG5XL9e5VfJwdBjE7zvixAgRpoPZJN5+
         b+zC7ppIoNqWpffviYpApbt9DDuUV4aL903p/AKO4v0ppUsrWp2SQrCNQkagOo7Cdk5w
         OgfHs637qUAJsUwm7hGk2p8xJr1IHdntUs/CsalRIg3BGpQ0N1W0u/b0P+I/0Vi43613
         /W0g==
X-Forwarded-Encrypted: i=1; AL+hErHAu0SfBFuGT9xrG3Nr33f3Lmu6avBSbKa28j7ZvkcEtsVCk4Qf2e8YBjokM3dVNlSX2Tu9OzkyAQ==@kvack.org
X-Gm-Message-State: APuU4Z8iJJyz9n7YWD7SmMLV+1Kyae/7+AkuiSJ5P38L32JkMUeNkcfV
	/GLzFa0YW8DVlDTUYyy1W+GOLNzjdMJZxtRCEC190M7fCRJ661nPhI7qJWGsSvazzcmd89pC
X-Gm-Gg: AYBFou2ygKOpPssC1Jx8gov2x3+ExpJrgwX4dSX2m+15owYb51aMNZHoz8lC8g2ntxX
	XK/1TPpXzujReCCXUDUDdC5frUP8l1k8Edfz9YLNY4j7AvuIi4IBlM5imCCcuaAYYm/2MRQHGzt
	eo5ntqLBxr3mNWKT8Xse3t3MPBhFHgg+AxTIr1Ta79IcXmQ4FjMsyaqml8KuSBQRHYY8HA9jiDm
	ejawXLSxG7oGgFzpzZIMbgnJwtoUFdxl7hUMiZnWgFRzgC3pu8ZAk/YWU1zLqfHwsZs+pWc1NkP
	RnkxtlqWw0eats7wjo/Q34fF+ry+GPs/xpSuvSkgY5bi03niWHUsrHcG4+jPljKYwWltyyC9OYZ
	R8JJB25CImtmNb414mbGTKKXNWG3L1iIsLSMVzg5os+Kx74pCc56IX8qUZ6hGEmvaBd2LJRyZCy
	sAmZtmhvSwBr5sulg84pC1VHl/GPP/zv7h2zrbNtJVWLrByNIs/XWscRApni6YqsXm4v4x6kpyw
	e61rv/pTboTzF17ZY1HpyemOgdJfBbLz3n3g0N+V7KeY8MrfrUryacEQ/M2SNdv1YQPGAR9DcxL
	ZHQ2zJ1danGfisKYANK+jNBBqwmWDtFqAlUTmAbNPQ==
X-Received: by 2002:a05:7022:b90a:b0:199:4f68:7710 with SMTP id a92af1059eb24-1b5567b347cmr1783883c88.2.1795145400269;
        Thu, 19 Nov 2026 19:30:00 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567e644dsm4362507c88.5.2026.11.19.19.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 19:29:59 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH 0/3] mm/migrate: batch PTE restoration for large folios
Date: Fri, 20 Nov 2026 11:29:46 +0800
Message-ID: <20261120032949.2036731-1-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 6nuhkxdw8p1m9rdxsash8o189h6hcn7e
X-Rspamd-Queue-Id: A8876180002
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795145401-812562
X-HE-Meta: U2FsdGVkX18dus5FFQAeR4a+gkYlLaAxL5zElnemtQr78RFXDn3Wu0PzXF4JftldWaPO+7YurgPj/F8mA3Zx61F4Pihw3CTRrSNWa4KQaQyPFQsfF34nNKrSNiIGGdRuRezIwAksrbefrcGn/RVvsYdzXWneb73LKjQd02DbbEALhYbc9ZcQudK090sO75SWSpAp/toelV27qWXelvQ+hdjb/4s8MGg13pDwcYcp+4rXQs2ZnZBMwprCKAtz6ZZZGTV19i8PugXA2qbvJuKzgFm7AoVYZcZ0SmhyiuL0ZtjOEsB0It20ZBRoBlh5T2MHhtjAexWnYuadUmHElXNv13+snbtepZ0tJbAZif8opPE7b161AjcoPWmUrXfOSqb6M0k08PFi1fk8TFsNdMs0he6QXAWq7pBc9l/HLU96cgQom0b/ruhi1JksBm2YD3UA4icIekOl0b1mE0fzkbg4PZ1iNzSHu+slmEgHe0weBvYltEfhrJmfrZ0GMbG0Sx3IwQAl9l6rZWpW8RIQnc9LByU2CUoRXbNKsDsCp3EyuK0JztT9mYkEVhAiB68lVKNKvIUWOn8UsC10ZnaSBh9MroZFr4B5u9BdkcT2wEFeUgiigaJGIQ1q0EhypZ/4fxhKi9lkJSo0y7ttDXhcS3YUl347jJxE+V8LlyQMq6+Q1FfKX1PztGj06UHHxLeKJKnb8tFXOB4jRmCBwdvfuADBTM2PU4FG8wKmkfPKN/4guFBV9/EcsCsTcn5cNMzLw8Kt8J0CUkeVvml+9RnetRs+eXC/g8vbwjZIAdMPApTIgcbTmoGtpYZib83yOBSZCA1WVKd5bqlLl6tkXgmDdUdK8v+YhAVaifbHATI+us5VPlUo2mBjjbTN2h8nv/mwwjKmMKE+F2O3/hqpSqH1SENnslwei7tQF+34IOdPaZdPTbjTR9jpYlTkIkmo90T2tpRU8tlwTkhhWZ5fRgpmjmQ
 /tmsETSt
 TckjQGMOriAXqZTtSssQyEmxqSb88URYZDG/qYwdZgRWxMfv24psKoe40XE97S7tsKT+2JxfCZ5u3uf/Q1fXFFLIC77YxVLRKvvhnvATM/XAKrdJamDeCtmoPsMhmoRhFO8Q0jmLtIsvDbz/oVCnn2t2tZmDqkPVpVQ0NcdRa1pn51vSs6hy2fcfcA/0B736d9FRT4caZnZHtk0TrSzMgj1OmUi2iGPoZh/PQzEx5l0yV48mqcvLOzAQ3gJAcmAj3RStIrPvzBwyJoinOH3YFxNRcp7ZBzayTZFXQQUYacpbaNjHaIwnJFE9N3lSo4yJK8sESX89ePBnQ2K+4aSpU1EU2jvfCuY3WEJ9Fqx4PZZ/JNEypZZ0/gCOFR0bewT4hBrSDlFEjzB9dklWyCVHdm0lQAyn8EiznY8F7s7f/fxpOc77+ZFwdnY/dMw6v3bFNYhqmAWnWVvRSIYsu1U2cvUH2PeJwaR9q/CEcOJBBzDTR4q2InFZMiIsPvikZFJ+NI1HotiDHFfnHLuhV44awtKQlQUUKVOWNU6ZcIrXWuXOutw1D8Y/VY7P2PlvQIT5qPtXZ6br4QX881eUrcHdOH803hlF+G2oY52ph2cWL3FwYZ0eAAYdxhHmcRb9StJ3XAL1PV84vqFravPmDvUNbLcmspjXly0V0UoeVH4dAijljBtlt+2g2IsgIAp2ScvJ+wyPsx/L8Ui2Bz0tmDGg+nGppH5ZvAIaXJGOd/OC8Xc/OJ0+D/OhWN6yg7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

remove_migration_pte() restores PTE-mapped large folios one PTE at a
time, constructing each new PTE and updating the folio references and
rmap separately.

Following David Hildenbrand's suggestion [1], this series batches
adjacent migration entries with consecutive PFNs and matching type
and flags. When a batch restores the whole folio in an mlocked VMA,
the rmap helpers automatically mark the folio as mlocked. It also
extends pte-batching to device-private folios.

The series applies on top of the mlock tracking fix for PTE-mapped
large-folio migration [2].

[1] https://lore.kernel.org/lkml/5f9c449e-43b3-4732-9c14-8199418cace0@kernel.org/
[2] https://lore.kernel.org/lkml/20261113083927.2727599-1-chenwandun1@gmail.com/

Wandun Chen (3):
  mm: factor out common softleaf offset PTE batch scanning
  mm/migrate: batch PTE restoration in remove_migration_pte()
  mm/migrate: batch PTE restoration for device-private folios

 mm/internal.h | 28 ++++++++++++++++++++--------
 mm/migrate.c  | 51 +++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 65 insertions(+), 14 deletions(-)

-- 
2.43.0


