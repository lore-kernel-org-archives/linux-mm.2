Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EA1C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 07:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4455A6B0088; Wed,  8 Jul 2026 03:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7236B008A; Wed,  8 Jul 2026 03:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E60A6B008C; Wed,  8 Jul 2026 03:32:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDD7C6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:32:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7281C1A06A9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:32:54 +0000 (UTC)
X-FDA: 84964792668.14.792E6FA
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id BB88920002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:32:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W3MagmaB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783495972;
	b=6WlQdoYg1XUZjrYiGrIwISLrZU83ptiLTkR6446ZGnJtgUDS/RSTnXrr7GQ2kT06j6Jjl0
	k4OOAU39XMlQyPaP2LZNvXCJvQEnX8a1c5DZE+1nP1Fawq8mbx9UGX6HchpuPPAR1uAlTa
	6xPpsaPtDtIh1kRksaPPc+HijWB3WuM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W3MagmaB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783495972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cAmllN+se0JthLQV82NE0k64TaDaKEJudyrSmk0kR+o=;
	b=bf1Yvds8FCsMOSNGd/UME2V1c0rR95vuWCKOI/T28wfj4p1wqlSLFRHPMIyA45en8z2iJZ
	4JMA4pOotjkrLVQTi60TBQsDSy1t0azY8dNVNKXyAKUSOHECxBhJR8TbdFQoBYCsUc7vnZ
	AIYX7lByYZJTfq/MsZ2dLjmXm/ctfdQ=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493bb0e2894so854895e9.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 00:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783495971; x=1784100771; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cAmllN+se0JthLQV82NE0k64TaDaKEJudyrSmk0kR+o=;
        b=W3MagmaB0UXqH7tKH2nb53H1Ugm69NG8T/jajWB/NbZqSnj1R0TuBk7UXIO5KZz8pO
         hKn4SLqnrLNT1c6KiSDoqQKpWNe26tD5OuQwPnw8sogLBdoiZahtPelimxDPeHPuLLI7
         aTo/P+Uh/xNcLCWENEE+Wm13HAvPhmc92t23Fk4JT4nie9bCmEhT2wOf8WW3qHvqT7Wy
         UeJL+06n6MDJVgVYjyyZQx+JGBxJ8HAGkmuizB25taciLSi9YgNzJJh3dgG8taasVa2X
         zRMreMpL0phOTQtyoySRRM3EMkKxS7jsvJgJsnKXnLvTST3aRG+wESFk9GZzKbp2DbuD
         U0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783495971; x=1784100771;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cAmllN+se0JthLQV82NE0k64TaDaKEJudyrSmk0kR+o=;
        b=DfF592YqnhFe+k/u40/gy76vu1nizbPce62Ct7ytRIgpYaLLii81y34Bl3XxrZjHHF
         hJvczJKsaLBKxB2u0ldsaLmW1V8u+3EHMiXynLgKgpaens6C19QyA9rONK89PLJ87fil
         My6D57vKTEqEJEvTJqsAtwKLZOdbw845y0uMPuqnO1xT0iLBpfdYO2pm4pSJDT0cirMn
         Ag7llqyi//37essSzEJfSifMEO0bs7/jEzNnbhccQUWeJDWmd0HGGeqvTGYwnDgHRDxA
         bgyOm88nl4T9kONNMNmVqwa2/B10pFYHmzN1Si+M12GeKjQK+CIQRyKdYdCMrkn4bMx1
         HZaQ==
X-Forwarded-Encrypted: i=1; AHgh+RoNeVKO7OrbjLGmAxZC4d1/tRf/pnrUaHqBbqrkczLCFB1cxDMtBV/7O4HrBDzNqpPFIY0wE8HthA==@kvack.org
X-Gm-Message-State: AOJu0Yx3to7mfsXZ/gLkbH/0eveH1Oe/fJyYAHfpY6WNTdd5oUe2F01Y
	wyNfyyGbHYUhBG741gNumxZsy7Pi/USRu/Miva5fA637GO0oN5DS2bxa
X-Gm-Gg: AfdE7ckPOJOaBQLZVApuxc/TsBnZ/uzX6PC7tBNIp3cBs8QJdEaD/TePK6HDXORlkdo
	2rgyDAoVnFrWinlfmYxj67LrCWc+Es5JvhD90+LMZQ4zrxbrl0wBm6/UV9Ecd+MfdbCe/OIQD7V
	T3XfPqFlRiw/gBbuk4xCOqQ8+GilY95DfNRlrhp+BAGwt35nYJ5wyHn1fLna3MfTM5U5nrVUtlP
	fzUkIgK4//ZzwV94VOhSDKp+/03z0sL0xiO5m0D+79wBHzr1Yn5XIP8Kufb8AVP6IEsLUyDyhVv
	gTuA6MOvWTxfj8TM6zkhbY0RbqLaSaSOx5V23ATIvkaR9vgbuEJKUlZsK8F3xo8QNtPXlypGTyI
	/obrA4fZ1TVZmbp/SXWW4unCywqoVjampX8w4vzGApmiE/LK3yH3mf53mfa5HPN4QkwYNch+Azk
	vhIImGZkpvDhNyphoTl2WO4sFHkEHpRlBbpuqoL75yRAhocUPt0tFgMz3En1Qol6q59J+4LZmZI
	mO6GgltFwnEAj8+
X-Received: by 2002:a05:600c:8284:b0:490:ec79:3046 with SMTP id 5b1f17b1804b1-493e684e722mr7381125e9.0.1783495970941;
        Wed, 08 Jul 2026 00:32:50 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e610532fsm32876355e9.0.2026.07.08.00.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 00:32:50 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Doehyun Baek <doehyunbaek@gmail.com>
Subject: [PATCH v6 0/7] docs/zh_CN: update DAMON translations
Date: Wed,  8 Jul 2026 07:32:39 +0000
Message-ID: <20260708073246.1652828-1-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB88920002
X-Rspam-User: 
X-Stat-Signature: sh8mx6skzrqstw4d6zc8y6xer3nkagb8
X-Rspamd-Server: rspam03
X-HE-Tag: 1783495972-758822
X-HE-Meta: U2FsdGVkX1+WYnHfTnKCkMnj9Tp+FOr9p58MeCpoL3Z4gTYT4TH6wi9x1nRqqVvus2AnA+FpHgSUz2XlS1/dd8o9PB5gPO76Qxexp/8BINCj8fIMBB0rgg6WUX/2A+1gsxfyFDW7BRgxTfrqwIFsVemBXDHmlI7u/wQtbgS/e6YU942ilJu5ZysQYOuh2zksHKZOXhSNh5R/dzBTy1gruMe3j6rQ5/lK2hMgBsBFQ9i0zI3oHVgdpU37fWidia9E9Y3jd3Cfl3zeNTIMJSzv/751Kife4oQfduQB6jlawpyOrEqjWCOUbFn8ynTO3PbutVjp9DmxYlFA4P+imomLV2ysyf5/6VSafdEWm1XJxuYbYK6Vu9uKXTmAFAt+7qX6obrK9as8wLkg2vHAHl3jTrQtX6+Tq6r0Mg0LARe9tpCzvmVkWhMX9DoruqBVo2nM1nGiRpxpDtBLw/ivm8Ol8p9sYAZCaFezPC8z7Z/yIu7XXCKn/ah7MRCKmBJ7oNxlXpvmnY2Pmd9SWDFLFkGo+Wm6NqF0J/nVY2oE8aBDrbbUuuFHMK3NfZ68pPhMbXB37eCiJOzm4HxjstU1b5hlugBez18Y7vSdCAqOj88Ep1QKHFqtQ1iZzTvtY3t6ixVzMcYSYBfu9E1xAT1aU07q0ZS63es2kuXFOMkqvDgEt/vbHIqidrBrYc1FVtdAMqU948Am/znXa/irUXG4Xm/poPAZIqA+5YRp3ISyqTslOMzKMG6px28zHw+PBM/MR309TtumYVT0WSQPJVT4UBkUvbqra49wMCVEIfO+nFRKS42lAWgyHxzVl21EJJTxCkLbT6bPgbCldg99cb9OWjptnF9TybVMC7sq2d7BJ+Gf2xpcEoXKEOvb70qXbRuduetxiijmdNyZhmsBoGl+33wciK8PF0eOjb3BqeYTGtkv1X2e6cVIRoZazHDKOp1AB6HUHNifT+iz/MUeeU6jf71
 Okpvl3wr
 QGEOy8bOIvqbphClsRBTpeKWUNwMk18JXEO13dv5pEk4+mXRcSVJluPWoaDHqnAaTiwSxPcAZENfOEgO3KJb9q7yZtLNj6siHWHc8uOV9NyajrwxKU3kly1JljorTi7CAySqL2kg8fcTpm7ncJAixloD/ohvevBS8dDLN3euhbj8Hj44hwqOb2YR7GhfelmXO8By0LLI5kQVq2qKSNn2ScGeI0VDc+QpgFKgIJv/9ajUbNZ72z6RaIAs53NkjWXAygKNQilJGQMiboZpnu8+IgUZcPVWOovwk4UF6QVCD7C1GUFAchazfZXDwbeE0HIskxf5P2OVDw2kDKvgqL9C0ga7k+rfExI4pwZC340sAglyBjk9LaX/oN6JGXN/D8r+H8pT6+j8/EQOKgA8yUMmXD5qLuc0/ye+sOj9mRj6sYOlbuEsLrLTZrF27kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the Simplified Chinese DAMON documentation translations.  The
series is split by file, as requested.  It is based on mm-new after the
English DAMON documentation fixes have landed.

The intention of this series is to update
Documentation/translations/zh_CN/admin-guide/mm/damon/.  This required
choosing how to handle Documentation/translations/zh_CN/mm/damon/: do not
update it at all, update only design.rst, or update it fully.  I chose to
update only design.rst, because the admin-guide updates need its zh_CN
anchors and references.  Updating the other files would broaden the scope
beyond the requested admin-guide refresh.  I would do otherwise if
requested.

I checked the updated translations paragraph by paragraph and sentence by
sentence.  Given the size of the update, some issues may remain.  In
particular, usage.rst and design.rst were significantly outdated and needed
near-complete updates.

Doehyun Baek (7):
  docs/zh_CN: update DAMON design translation
  docs/zh_CN: add DAMON_STAT usage translation
  docs/zh_CN: update DAMON index translation
  docs/zh_CN: update DAMON start translation
  docs/zh_CN: update DAMON usage translation
  docs/zh_CN: update DAMON reclaim translation
  docs/zh_CN: update DAMON LRU sort translation

 .../zh_CN/admin-guide/mm/damon/index.rst      |  15 +-
 .../zh_CN/admin-guide/mm/damon/lru_sort.rst   |  68 +-
 .../zh_CN/admin-guide/mm/damon/reclaim.rst    |  82 ++-
 .../zh_CN/admin-guide/mm/damon/start.rst      |  63 +-
 .../zh_CN/admin-guide/mm/damon/stat.rst       |  94 +++
 .../zh_CN/admin-guide/mm/damon/usage.rst      | 521 +++++++++++---
 .../translations/zh_CN/mm/damon/design.rst    | 665 +++++++++++++++++-
 7 files changed, 1343 insertions(+), 165 deletions(-)
 create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst


base-commit: db6ed2a3d31068ca5577466591b2521dee0508ca
-- 
2.43.0


