Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B61FC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1772C6B009B; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1285B6B009F; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067B76B00A0; Tue, 11 Aug 2026 12:20:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF4506B009B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:20:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5370F1404E4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:35 +0000 (UTC)
X-FDA: 85089501630.23.9858B3B
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E80120011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:20:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fNQlldhn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mkETv97u7qIlNZ5VKVja2JYD2hjPriEq9ckMj58Ed+Y=;
	b=OHn/rks8Wpt/fGo3CEY9eb9sNE28ZOBWCkgDnDY28hQcpjX5fHpGAHSTsQ5yUUMtj34VOy
	YuBbKta0QgFZpKcb4s3pGM3m3PQYu6zfYYy+WsPOcEbAtmHLy4Z0aSKng7VKJrHJEGso8c
	9ccR8mo8dXC2vBxP+y4RfVTzT6qYr88=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fNQlldhn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=imv4bel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465233;
	b=VMzsJE290HxHXVt4AOGUvVW+cNvjK2TU1EsHZdhht/Ryb83JZHouEwkEFVQO9HeDIY2KCD
	OfFC+f9JNRlqPlomA39Y2+2s308FB+AbnXiVtXIMVCjNjg/NuDVz5746YPADLRr+w0fzOv
	nduNXGyKYa2yTIs9r4wjOdqJ+4pN2TE=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cf50c6f235so1871955ad.0
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786465232; x=1787070032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mkETv97u7qIlNZ5VKVja2JYD2hjPriEq9ckMj58Ed+Y=;
        b=fNQlldhn6vKv0vLAcv4Hzh9Pfgl5i2wIXBBJ7V/fVvVCebubYM4HjJuTJHBIxcF5Zr
         3+qw937oIsV9b2Ebm4DQZuqSCZABM+tCQkfk/HkIiovRkxZ1T+Q+FSMtvmiepQIQ7uQV
         GKsOIEd7M0MZncmohVctAqux+FrzLzAexSuJ39/la4KXQJz+QD82DPOTdaVGaAEN4GTZ
         UWD6pgXtSgEHcdmpPVHLAGwyWhM6WoUgcEqwSHKKJ7pHpUT710lZWsc6r3xy5QLUksyS
         7PzyXE1xvPHKZkZ7/gaWn2WsWGyaX3FWASAoMhmOQ+xqWCu2kdoQ7fFyz+1ZWp81NbNA
         qd4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465232; x=1787070032;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mkETv97u7qIlNZ5VKVja2JYD2hjPriEq9ckMj58Ed+Y=;
        b=oRdw5mk0WM1UiNMLFJMUCo96XUziO6W/NK+rrdn4D7WGO53RPdtqQ7sIR+5OR8BtVW
         axg/yQS3VgiQYE5w9Ca80447NPjoFayTeXbw9vleEBVPo/rH4W2RFMiOASHv7zPWSlKs
         cDsGQBJ8tH5ohPSTE+yTXDl12VZuobrYnyY/D2submxvVbDGY6+ub8aqvfvrQmYIoQ1C
         TSi5Bf00HvxDny02dTl4QBitTfHoCa6e0xdluOwQYB5F3zg+KpsIFnG/NG/+WVegQEmx
         1qQxl4SEYEIcxM7PO5WW9lSwJAZcaa+Q5TRu5CuNGrHTZ38DVguA2s+wqZjUzcklEJl6
         8UYg==
X-Gm-Message-State: AOJu0YyXw8AhliP8McwKCJALCCWxHSCEZm9B46xq2FWj+HuI7DmgEGye
	0PuBANzYLbnrl9SMDoqBhQ5yoI2QEXVV0+lAV6CzmK+iVDfqaPmtLLt3
X-Gm-Gg: AR+sD10TBimE6QPNnrX0SNDSVVllo1z0UvlNO7ZQQYhm12x4F2Mf3QeZtv+phBJEO7w
	t7/UI7bOnWxCiD29IEquuhwKBQ7qmxY+RaOmd1yg6B5cjH0BLlYJ+tJbfpyYxPnZpwD8Dxm6Kp5
	M1yE0oi5CqudgFJBzUeBcoAf4TEtzF0rqHdJo9rbfbqUBEThyrFAcchdg8+JTc60KUokLYKeS34
	j58HNprc+hzwDOszOIpqw7EIQCXHSaWgVjKZDCoT5KN0TDxppKCVc+A65YLkrETNWcFhyUlkBma
	yxKOJX2wmBzDWJmgh6cWJnoX4d9ABEf78VeQgynA+Cgv7y/QbfnoY40/+xSdmq6QK0p2pGOCN47
	RGLVAuykouXtjGv34arCc4fWCrQlGqsqMZGJl5wcIwD4D13KZzun7f1D/JndC8kQDcO7bnanxP3
	18PpAqkjNB3wPVroV3EIp8Db59DRiTSxswIjNmy/kzoZpIrlLgzip7wViWZfeRgdjXOV54J/uHU
	fezEzrRS7/nloh2V95vXA==
X-Received: by 2002:a17:902:e80b:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2d32bdec182mr21923025ad.2.1786465232190;
        Tue, 11 Aug 2026 09:20:32 -0700 (PDT)
Received: from v4bel.. ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f30027sm10547465ad.25.2026.08.11.09.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:20:31 -0700 (PDT)
From: Hyunwoo Kim <imv4bel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	imv4bel@gmail.com
Subject: [PATCH v2 0/2] mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
Date: Wed, 12 Aug 2026 01:18:56 +0900
Message-ID: <20260811161949.3879321-1-imv4bel@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cqtko91qtxfngxeomwigtd9i3w3skp16
X-Rspamd-Queue-Id: 9E80120011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786465233-636218
X-HE-Meta: U2FsdGVkX1+6rVSIwEo94i1TnSnSDxabAgS2v5Rqi1Wm2lA0NNuR6l1ziQqFISDlCEji53VvQT7n0S/w0Na1Wan+V8u7167Jpawxg4vkT/OrddM7Axfh10TYLAdT8m9j8zptUTyrOzrBsHSNZO1z+M0EZjUGuOX487u34uc8zFhrQK5vDyI2x38VepVaMv5YvkP0iR8v9tUr4FBVJiErQjDgHcW4pJytQlgggEk3R72KSs1XIg80o3WvX9izXfI0nUZgDTaGKxAs3nbDUVHrb9mxFr8X/4ufBQPwMLpJAhHqFyolCL+PMKEWtucgS66KJnMvBFlAVvvB11t/FersXKF1+E+JLbRBPDMlGyw9a5nikGjjX5J/8m2UyjwoYdGyQivyaii0W1GsT4rhALBhDBOPZge4EAlWH90MMMizim+niDpHCmKHJmbfUQl1jFXXjkBjNqXx4uTTDGYKUFe8S9iFR4VGjT64VN6vhm7z/p0COVCNbINw7cYXkhWn1fQ1daUbTPUHUJMZQ35/7S7fQAsFrvyttggB8tFs3OBo646VocPuC2RHrpkq0rNjA8gyRngX4JTA5IWdXnYLItTKqMWrhdWamqge5XvCuOk4w1bXcCpdWhvmxYKoRciXayOmOAnBGgqYLrVGVmNPnD4QXB0ffBPi8QErUgb9oRL23grGBE8oCVZ9NNGU9UBkdUearcRQQ5uDBLRrtZAW+KQSdv0bvzjYcXcOi1Ebe64PfLVKEKRjYARJvqcjahoxdxnaWWwe3ePpp6Wb/AB30nzZdTVnr3RG3gv57tOdaFMNPqvjGJJbFkVjpR3cLYmqtZI3m6mZHerXXLklUx5QfAzm07jpkLpEoiBZEhT4nIQuXEB+wzHRKK2/tDTGt/j/OmXzYES9FHHr+OlDI28rZR3jXgGAuZG5SlNi8ADH5es/HgvWqfnvlyZdQnBost700x50vcdD6RstXa5zg+fIlP1
 ms5P6AKi
 x8gmZEy2DzaJZ9yCdE/lOC3W9wEv6nJrzxRB+4VwPwRpC7JWyzUsiXMPz71dzrhTo/LAVDZzbgQT9R4bHa0FmQcbHbJF9koTMazj3yRLmZYcgxD+ePyifvFbizOQSxMp0BjWe1G3idR8AmH+CRxY5OR3Qwxd0gLJrsC/qdzFK0SKNQtpiXhJ+fEV5jPtCRMcyWOSuQ/5rediwq+S/POxGkpIK+VDqk7JHkZhEhzkMt56iGuCUxJ5N/y2ttPes2yaSq7JsMdQR/LhY/jvoJARjf9xTPvtXhVBo0YCCum+gL3s8N++e4Kjwl7dbGAmSxWROWuaeM7djCWVys8e0YIGIXLCYfI0YDo2+MZ82tLzfne0u493qA+gkjccVWyMm1+uS0oWrX9RCXD7lzTxtLMYAkjRo312dIViymgHkPvAvbtaSjg17KzCpKrU1zienifRAiXNydbqkWFbT/3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_pmd_range() could return with walk->action left at ACTION_AGAIN,
which causes walk_pud_range() to retry the PUD walk and invoke the walk
callbacks twice over the same range.

Patch 1 is the fix.  Patch 2 adds a regression test for it.

Changes in v2:
- 1/2: reworked the changelog along the lines Lorenzo suggested and said
  how the bug was found; the fix itself is unchanged (Lorenzo)
- 2/2: new, races smaps against MADV_DONTNEED and checks that Rss does not
  come out twice as large as what was faulted in (Lorenzo)
- v1: https://lore.kernel.org/r/anmdrYGVqM-U4vlo@v4bel

Hyunwoo Kim (2):
  mm/pagewalk: fix stale walk->action escaping walk_pmd_range()
  selftests/mm: add stale walk->action race test

 mm/pagewalk.c                                 |   6 +-
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   2 +
 tools/testing/selftests/mm/ksft_pagewalk.sh   |   4 +
 .../testing/selftests/mm/pagewalk_race_test.c | 138 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   1 +
 7 files changed, 150 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/mm/ksft_pagewalk.sh
 create mode 100644 tools/testing/selftests/mm/pagewalk_race_test.c

-- 
2.43.0


