Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF57BCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2C416B0010; Fri, 29 Aug 2025 14:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCA46B0011; Fri, 29 Aug 2025 14:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3266B0012; Fri, 29 Aug 2025 14:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9FC16B0010
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59367C0933
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:10 +0000 (UTC)
X-FDA: 83830639620.15.4B0464B
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id 375C710000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=cByzuceN;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1n0BAT1fuH3lX7MFumBUOjEEjUCMCEsnFKx8em6Be6I=;
	b=0Pyb8HLjocQr1HsFoTsI9KRn4G2fAGmayaaVybgueQpk4EsqISkbsylSkzxdAJ2xIGjkYk
	VSU9AxTveRBmyg3Izx7kYf5CZzdtRsBCNq6FldThIsXGhEdiwok24c9hwNQQRSaIiGkZPz
	bCS+ulymkhF711YoyUVVz9/aOBMFqBk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=cByzuceN;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492328; a=rsa-sha256;
	cv=none;
	b=mEi0fp8iEgubHydkZPOLqbD/2uc4rx06b5roXeqOjCJwz6eIdPzgrvQxU1FXhEm7ctDN1M
	W/hSB3lCYOoOEzMFU2HM1GwABi55NxMp7A9NOAo8rC9HlP2CXUDjxBgoEGlKpoKARyguuB
	x3WYF4XRajHfk0kSRaeB9ZcLaMM9nQY=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afeceee8bb1so367322166b.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492326; x=1757097126; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1n0BAT1fuH3lX7MFumBUOjEEjUCMCEsnFKx8em6Be6I=;
        b=cByzuceN4n3EfPWIr3QrLWwigTgEj5Xy6hLXVquwTzznjcglKSX5tBsd/p5UXZRFOo
         DCuPkSpu4xuUfzaETYoyFaIp5+9NBBpSQ780ulmNu7fZVlePeGQrCnam0EAtBlVTGADh
         jnKMt3fT8fIFSjhtcSilfcjb7WVm9UrfNB8KFtfST+o58XFj30kksHQL66FFhTI5Pcjm
         NXavVgHbzlKaq74p74LgUIj1ki44UBsIxO6/r4t4E9dSa6wpzEl07tPZxiSeZ6Tk41aY
         xgpxoh8Fqv79qSmukY81SNvhEFNY9QD2NIjnHtKKPH9M9gKvSBClYRps0oASoQ5FyIMp
         tbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492326; x=1757097126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1n0BAT1fuH3lX7MFumBUOjEEjUCMCEsnFKx8em6Be6I=;
        b=r9GKKWz1UA4d/h65OwlaklCIRL8RNyrvjL+qyHnjTUqmf+sfShj1bRfTFrJ4zvAHzv
         Aad6EwOetifZeu4aktiQ0u4WUhspsD1k/4bDiMa9Cw+YF4sv99mop9z55R3tKpUBrz/P
         cPNDGeHX2byexu2sNYgbOokA9S44Ms46p+5R4p5FojWt70/I5qvMQaJ6/r7iYCRKaHZf
         CDILTjAykARXhUNa8hk/O47bUwAKYM2PweqtROSL06dNVvy1z993Yxzzj2PxYhaMBpOD
         Rtn2FdsCOeC6RVrCsnL2uSd2mZ7ECGyvED1M9hI+LVP980shSXg1GvPAyWM0rql4NMW2
         0fSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoTdr8NTSOMUEs+thHdgspxYhtmWVEKRkDD1RYmp2uIwVdtHvhaShVM92/+rEt8D1JID8spo4Bgw==@kvack.org
X-Gm-Message-State: AOJu0YyotP+hhl3lyC5xa8XGU34SDgL5yKv3Ihls1H+bMBeqpeipQtX/
	3DpiZJPWjN1yvKeec4roQa0nJOYDR5VkfwBdK242Fr7EbX0TSK9dXO7w6oPGg2ZYE7s=
X-Gm-Gg: ASbGncutWJ065rv44n0mDmuIQ4hfAT0eWf3LD2zoaTjYHO5xu3d1wJu9btd9LV/qLPm
	QRa9OZLrcPOKROuwtaQjiXz/r+9VYArGpfMW2Y0UfXj9mCkRJh6dMl3AUFrVYhToqTkvqTMp+UA
	w9uyLKj/SzKw64M28BlDtU2fbbO7q7zp9DgtN2sOIKuU6+MMWGuL9Jb1n0AhlDfIfF3cZOEfSda
	K3y80pbCrmqHp4juVzRm9w/dVzAV56zV4n5nVndsOkyjwCESrgPDE1yqQBRunSNL/D64V/9Lgfu
	g8TMgubffEmhUjANH6bT9qBnjJl9iSUIzUjb8ACgXtekkHFD8xa0OLmHAZWXOkExIeRwRBs+ONl
	/9B5Y+oSqVcRlhsD8LoSubfbebkTGaXPOLyzSiaPEiCZpMv0FTvisR0cIzAwfXl+1QTAU4rdRAn
	A9bxBGgTuqZjEZqfiy4Tv1gEo6Hhe94Ds7XRXGX5+IbZQ=
X-Google-Smtp-Source: AGHT+IFM/WcHugYqf6JhyROeecktHrseO8ZMkPb1VybTOz5v843w2YdplzoiMvny80PtOIwil6biOA==
X-Received: by 2002:a17:906:fe45:b0:af9:5766:d1e2 with SMTP id a640c23a62f3a-afe295f1a73mr2279764766b.47.1756492326379;
        Fri, 29 Aug 2025 11:32:06 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:06 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 00/12] mm: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:47 +0200
Message-ID: <20250829183159.2223948-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 375C710000A
X-Stat-Signature: c8586ctpm6dkksemjfyfx6i64b347tcb
X-Rspam-User: 
X-HE-Tag: 1756492328-934681
X-HE-Meta: U2FsdGVkX1/2WAqsrrH1g/XBITjks8jsWbEES/Ml/gjpwoLJtRE++iHc01EtfXbj/cvgiH4z8iN8rpZJUu5dojZWomE/6EnlPQB5HEYXF9tx/BTeifF6kcllC6qVSqrUCRUPcBA2gznUko+N/Dfv6PWWpydi3hV0wtcx7yrI6YRlU0xp5673GTRfItvf7N+/G1mo7s+F8F2U2Ry04S8ve2BatFfw+/RWnun7nUqmO9nd5FQ+fP2zyB4dsS19mRIYvAvpcstlsvjr3bULYlr/DORUBAH+6rpRLcOLEauEf2/odfW9dZzpsYaneUJfw/6x080Tb2BYAKsaX5cCTtRGhehdzt6dZgUwNX5RuP4fpwEaRMT8bjWWjqqgAku1S6zjOvo42P/PdCwYobpR+Z0IdFxO1PUZa7N4OjguZfNk83KHbM0UaLYDxR+SOFBWQgIMMH1mPL7hlA/dyV4uNWuUn9qBiyS4vQCwTqkvYpSVg9iHOPuDC8Ff8ihJsz953SqOkPeGXsHFstiUH3rHFj+s6vfJ9J/ofceV+OXrecVTW4xTVGaTAL90D0xdo54gKlZG1ASCxt0DQySbNHs6BrB/Rv+KcDMsfWwArL49A74ye6DLcJMugG/jj6YJbH+O8EsqlCnnvW+vF9Xz6Zu3aijVPeA168AZf7hLPaiQm9X5iNu1+b2SnGuTnkPKc9J3oQ8cJwmQS4EhTZIdu2hg3+lRMktZtIQStCnMyT1QNnhGEnhjkWr+qJ7K++kLquZ2BtYbWBniu5eCljU9bKgBQS1zbqk6QhkvEn2gYhadbi32rdrfac2b5aNGbtYcdgt7eKDXVdZmP9t58JQSr5AUuNmgEojW55WQeaPUNbxh33aqHpjnJs7zRyCXZ4W9b2SO5AdwMDZDkikkzcTHkyPMdbQQRLCXSFT1qSozF+vwXH0/7PnKJgevTAFSXFQCK3qjUSAPJx42myDCY5iJZ7bLbjO
 RhHYhBWU
 LVoZTU0q8y3uI8O9IWhQGw8usPfT0XcajD6L5vJvWZgUPhneu9/gMI0rXI7XMM4X1Y2RBBGidhnSjiYV6PrLdr1ux9+GAkJZDGeLn0KkOU0VHFWxWv6kwgAqsKJSOBCeMJCUWOWYvDD021cO7NXXK7HQQCjeTLbGg5vyKwioZzKZtvu8PjkyRydAXU/D0OfsZnzBxmY9q622LinxjDtEokbkH/iVGZa17i1KJ36iD3FYV3phh1SKJoN4Gmbw5WTszmNjXLisact4FNESOobT5WBaSd6Y8eSxvcja/w//qOnlxMymvdta7BNK/5v5y4l/h+ESqNgqhy2HU4Er0Qp+OcTMCg/9iiHfS+j7w2GbFhWxEKF8mDwOmJ4AZIev46Uj+UnNMYef5VzVcDe0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This work was initially posted here:
 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

.. but got rejected by Lorenzo Stoakes:
 https://lore.kernel.org/lkml/d6bf808d-7d74-4e22-ac4b-a6d1f4892262@lucifer.local/

David Hildenbrand and Lorenzo Stoakes suggested splitting the patch
into smaller chunks.  My second attempt with one smaller patch was met
with agreement:

 https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/

Now this is the rest of the initial patch in small pieces, plus some
more.

Establishing const-correctness in this low-level part of the kernel
enables doing the same in higher-level parts, e.g. filesystems.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

Max Kellermann (12):
  mm/shmem: add `const` to lots of pointer parameters
  include/pagemap.h: add `const` to lots of pointer parameters
  include/mmzone.h: add `const` to lots of pointer parameters
  include/fs.h: add `const` to several pointer parameters
  mm/oom_kill: add `const` to pointer parameter
  mm/util: add `const` to several pointer parameters
  parisc/sys_parisc.c: add `const` to mmap_upper_limit() parameter
  arch, mm/util: add const to arch_pick_mmap_layout() parameter
  include/mm_types.h: add `const` to several pointer parameters
  include/mm_inline.h: add `const` to lots of pointer parameters
  include/mm.h: add `const` to lots of pointer parameters
  mm/highmem: add `const` to lots of pointer parameters

 arch/arm/include/asm/highmem.h      |  6 ++--
 arch/parisc/include/asm/processor.h |  2 +-
 arch/parisc/kernel/sys_parisc.c     |  2 +-
 arch/s390/mm/mmap.c                 |  4 +--
 arch/sparc/kernel/sys_sparc_64.c    |  2 +-
 arch/x86/mm/mmap.c                  |  6 ++--
 arch/xtensa/include/asm/highmem.h   |  2 +-
 include/linux/fs.h                  |  6 ++--
 include/linux/highmem-internal.h    | 34 +++++++++---------
 include/linux/highmem.h             |  8 ++---
 include/linux/mm.h                  | 46 ++++++++++++------------
 include/linux/mm_inline.h           | 25 ++++++-------
 include/linux/mm_types.h            |  4 +--
 include/linux/mmzone.h              | 42 +++++++++++-----------
 include/linux/pagemap.h             | 54 ++++++++++++++---------------
 include/linux/sched/mm.h            |  4 +--
 include/linux/shmem_fs.h            |  4 +--
 mm/highmem.c                        | 10 +++---
 mm/oom_kill.c                       |  2 +-
 mm/shmem.c                          |  6 ++--
 mm/util.c                           | 16 ++++-----
 21 files changed, 143 insertions(+), 142 deletions(-)

-- 
2.47.2


