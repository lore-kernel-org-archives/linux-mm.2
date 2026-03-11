Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D62112580C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F476B0089; Wed, 11 Mar 2026 09:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2546B008A; Wed, 11 Mar 2026 09:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983FD6B008C; Wed, 11 Mar 2026 09:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E87F6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:47:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FBC31401AB
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:47:12 +0000 (UTC)
X-FDA: 84533908704.27.930665C
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C0574000F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:47:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IClbwMek;
	spf=pass (imf27.hostedemail.com: domain of coefficriwan@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=coefficriwan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773236830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qFaa8x68fHFwhe04fiR5haFh7BniLVb44DlzlpBkbAw=;
	b=W10FBlUpR3iQYOE9aU9LHQEuXGKAgsmu3pKqXo1OuB0q1/bCUiTaJ0RD7JWF3rOBf9PhBe
	poC4bDdLN4Y15NP2eBOsj8nlwtj+fyDfTpB8XZ/cHQnZr+C4ohXCOTa1wcr7CTtIfPO01y
	EM8F8/yr0ybNLbnuFrDlx2bxWddbMq0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IClbwMek;
	spf=pass (imf27.hostedemail.com: domain of coefficriwan@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=coefficriwan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773236830; a=rsa-sha256;
	cv=none;
	b=NsHtSqoz+d7MwICt71m6M+2oKHBofishbUA6SM/bhv9Spl5BSh3aBUqbSE2UQFEyoLiAyW
	iLbnQWVBBHLiXBvV2hOqyGjf1fTXcyqZUrhZLsmdYhWGSgPyxUhnTwQmMRNCVmcsw3tLou
	amv9LqmMlXo9wkOPSRGSHXAehlUQuy0=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b886fc047d5so2307574666b.3
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773236829; x=1773841629; darn=kvack.org;
        h=to:date:message-id:subject:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qFaa8x68fHFwhe04fiR5haFh7BniLVb44DlzlpBkbAw=;
        b=IClbwMekmTeePbRcS6Z3HJQB6D5SPBfRraGsy/uJ62EcZkHB6ulabuuIU5UVj+nFpG
         cDKks8ivqnr/OADMhI+u3YdeGNTv3L6dEEq6LEXNG8/GsDcErOa4aDksafjyfQxbwbQF
         D/kaGj15YrgCu5fC3FMQqyvyFJE39sCZmLy38ASyOS6Ke6lW2i+ulc+NvMior4zapFk0
         Ry+iifjPujmkDjcdc2TzydOSS/2Maj3D5hYGbF9ShRdCFPcA9UegaM5ii9rMFfd639Ye
         P2J/S8Y3uhrGUA2vuatijZHPO4PEnd7QpwJieugUwBQZVC7Qa32/MsKUaFO3MCDc511F
         4F3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773236829; x=1773841629;
        h=to:date:message-id:subject:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFaa8x68fHFwhe04fiR5haFh7BniLVb44DlzlpBkbAw=;
        b=shl23KGse+EwSJKSAuPvKz9hxCKuPLGxTK6hOxmTs9YenSK+RX7L3am0eFW1Rl3I85
         8peusMUyRAfMTNMukeYim2q6q1FJxh2jQFSD4o+t22V04ALG1NzDuvNWhvGfdogKVR+H
         4soVOnOAYAjUoh9TREUs8UpKFRJYhP+5X8XtD16oqdyln5hglee+MP0323mmC+N1iu72
         R1LZytvqIVsM/OlczTsuZtsIa+FLDk+vGf0XvhTrlzO0g3gKF4/a+RN9xC8oQg6XYmwL
         Ki41FZHRu0Kr41x01cjOxsi74rlp8FA1cODuajxDu0d8j2zCyuqQQQgG+9djVRNw6Rk3
         Q+ng==
X-Forwarded-Encrypted: i=1; AJvYcCXa+WJTgMZYjxF1+27KXH9AcojUaQAjOUDmkcQn9Kza+C4SBbFHGK+6CfuYX0spJ+YwegZSm0vWxQ==@kvack.org
X-Gm-Message-State: AOJu0YxOUjMZ7J7gCCKSlVVZai/j9h3YoPHE8SsQ9h82lwIE5U97H5C5
	bH44HzOpMjnovzZTf11wJdsnfjl0177H32DMZzuiIZXykt4dL4DNK3A5
X-Gm-Gg: ATEYQzzfghvXFv3qudn+pIn/YstbJ+OBEfp/tdIjoRWsX9Gl00djTIQmkd/r7+I8kau
	FDEsI/K+oIwnf1WE6hL445I6dXF599SNInV/e6ej3OGOmHqzI6wxJoEuui3zWXWaIHsALXCrP1B
	+qiJzqYqr9WOQXq2JhAFy5pGvdIasWZvjAFxRyy6eFrL/Ga9dEWSdBLWNLZYH9hMIWb6C7B2nZf
	r8wVB14E62jfVsf5F0kVdzud8xHjnPOuNK37xGf9vx2thXNMMIRaUxvrfF3VVFLFm792SeuKPdY
	hU3qZOfPZjg0vqqpJBpepMjQGW5RR4pn13CnrYERhj6z+te1XUwjuJCfn5ArkRhqw4zghPHl35I
	tif4FF36eW1VGUePDDUEBMG7K8dKqgbGBHpj2yBbDwlBSPM4JcXJQTW1xteVIsJPaJraCriZCIO
	N+y9MaRb2SM/3iNuOljeC73BH8LOQJKEHQHumOMQyidxQ7+9DzVBPK/WLT5eiCnSzriYZXegxNP
	Hf2f3kS
X-Received: by 2002:a17:907:944f:b0:b94:1224:c620 with SMTP id a640c23a62f3a-b972e24d9cfmr150447766b.16.1773236828196;
        Wed, 11 Mar 2026 06:47:08 -0700 (PDT)
Received: from smtpclient.apple (linkchronicle.wifi.rsr.lip6.fr. [132.227.77.197])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6631503c903sm523871a12.20.2026.03.11.06.47.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:47:07 -0700 (PDT)
From: Riwan <coefficriwan@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_6D4A7EA0-4316-4252-9B1B-1539839BDEF6"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: mm/rmap: Should vma_migratable be checked in try_to_migrate_one?
Message-Id: <83E1B606-C461-4FC1-BFF8-FC2BEFDCE2B6@gmail.com>
Date: Wed, 11 Mar 2026 14:46:55 +0100
To: "Andrew Morton (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <akpm@linux-foundation.org>,
 "David Hildenbrand (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE
 MAPPING))" <david@kernel.org>,
 "Lorenzo Stoakes (maintainer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <lorenzo.stoakes@oracle.com>,
 "Rik van Riel (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <riel@surriel.com>,
 "Liam R. Howlett (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <vbabka@suse.cz>,
 "Harry Yoo (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <harry.yoo@oracle.com>,
 "Jann Horn (reviewer:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING))" <jannh@google.com>,
 "Zi Yan (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <ziy@nvidia.com>,
 "Matthew Brost (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <matthew.brost@intel.com>,
 "Joshua Hahn (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <joshua.hahnjy@gmail.com>,
 "Rakie Kim (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <rakie.kim@sk.com>,
 "Byungchul Park (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND
 MIGRATION)" <byungchul@sk.com>,
 "Gregory Price (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <gourry@gourry.net>,
 "Ying Huang (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)" <ying.huang@linux.alibaba.com>,
 "Alistair Popple (reviewer:MEMORY MANAGEMENT - MEMORY POLICY AND
 MIGRATION)" <apopple@nvidia.com>,
 "open list:MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.3864.400.21)
X-Rspamd-Queue-Id: 3C0574000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 615edyghiixupzwjbujhqfzihsqdicks
X-Rspam-User: 
X-HE-Tag: 1773236829-200526
X-HE-Meta: U2FsdGVkX1/9vxylI+CBc/oY1KcgmtvZJZcPPPru0YkVMnN65ZCUSo1pGXDsXnHpBNJl5TmbGgJUkwYCBfsmMbjeeTKINAIvnV+OtmOV0WKyw0sImpQ+1Nlo4aZGxXvXCQUbH3zau4uo2Q+tU/gCrSpILXLG0fryBoCQp0Udg0IN6VgxZpgvzgt4QQ+YCGnQiXyX40XEugFDQc0abeV4JVcw2rUm0pSaGLslZ6wSWcDQsoOxBV8tU2hsevotfsolVvL8ToJsCgJ1L0bEWtvuG/FT5jfoOKN2EE+xmv6VTRgjPnGov890wfuUTKMVOAX3ku61bpuOyRKsJcL5+OnLx9OCWDxyORwEqytSUHdt474kl5XoP43g3gZKppigmvsT1FDfTNgLji0vjrp9zlCX8Af2prWSfQaUXauFowOVA0LeoQaVaaohpc1UGnLvi0K3Ce0cOo64NTGp62Ssxh4ooEFT8ClOwmFspY9ie4ROJFJUjySzKnQdBQ77lrvILITX3S0x2T4OwSyycGLZ4FeDsvRpRrzpqCyr3uejqxL6JzkDCmC1JLKCf/q+JY214e7c/AZOLr6wW8hBZcPO2x/TJUyTYr1cb5Gc5IbsDd66jTLxHta06wtPOaWSalmhlZXzdiv+dl2xYU4XCEBHQiiCUDWsHQ8sry78rAVIElrjTeeQ3XhW2u5qC3y+XK6DkfUFoBCk+r8SrGEnDTqqwdzQ/Hq/e4uHrtTarcrjKZIvS+aeW1PEMOja1QBxsJ94VnMc4BOmEnrtqh7KUdh9+D5EzzkesspOdQxDimCOY6ntJne50Vv8k7RrwsdgYIsv23dr8CmyZE7nKPpmtbAGv/iZJ0MIkfM/+P7UyOY8xGqzjRauoiNpD1v+toBNBgeS+zTSHIqAfb+TO+jFKJ00FbSgNnjTuPNW06va2GGe3bdigFliHdCKbNDjETqHHIKWKIIxPJZbXikAfEVWTdyfF+x
 XolGvjGf
 fYkB7SGu2Dx/yFs3ZjQM1cBbpzizcV3U7q5LVmfgSvYZ/8XLl9T+7x3EQ5IY+kvUEK0zH5HZi/vtYQ9QF4bOIjf8pknfKmeRt4y8Iz9Ell6bKJ1w3zTCyJ4yyUfa6/CDs0uz22/AD+RSVZyFzzqrrXdeYJlV0iuuwsHeZUx/+kNuarex450B3nMW5fXDsjhkQH52IE8an/k11ws+xwL5kZvPJD5o4yn0A1n42y4QAWcfq+8m+4A34McF6u4EtbNx0D26lijSmE61/qd46DofMV0RLvdu0085MmG0cMwnskKA5sPtQxGaYDKOx35yT2JuJc/wedTXf6E6PtptLnYYoQ2gMfJQLZVdIz8DajhREN0D8pPFUSLNwYYITmBXZhWQrEydas9u2X/iPr9iOz0LNH76zM4/N+6G8vsCR2zPcMeuVkSQPyEmHRuluwhF7jA9fIqNkN3Of+iMVqposqcFSduf9+6eHIWVpFDwG9J9NetTKEojRKRDsB6DptlaUFSM0RwtiAdW35wjpsPMJe2A6cT3sbEiVBPrsqEncZT3CjpuEc/9Q+sg9rmvorMnPugbe0xeYG/jv2oRF15Cfgvq7MGCo4rUvZiezX8TSOiDMsI1rbVsNTFx3plSTPPaiOouZv63CNiMulQz+1t/P5WPzMXZILJc+Fdd0QZ5h3SgstzxEdREpEk7rPeOJx7U/vBocFDbwvKd7QQaZwvsSGC8MQIoD9QLQZTRIf2saYRdbZSDvcY8o4ZLJ4QosVuURVdcLerMayA7ogaAb20RI0oOmArWMiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_6D4A7EA0-4316-4252-9B1B-1539839BDEF6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi, I=E2=80=99m a phd student working on memory management and I have =
the following question:
Is it intentional to not check for `vma_migratable` in =
`try_to_migrate_one` ?
If the vma is not migratable, it would be logical to cancel the page =
migration at this point.

=46rom what I understand, `vma_migratable` is called to check if a pages =
in a specific VMA can be migrated or not.
=46rom what I can see, user-facing migration paths (mbind, move_pages) =
and NUMA balancing already check wether migration is possible or not =
with `vma_migratable`, but other migration path, such as compaction with =
kcompactd, ignore this check.
As `try_to_migrate_one` is the only place where we have access to the =
vma (due to reverse mapping), it would be logical to check here for =
`vma_migratable` (before we only have access to the folio).

I=E2=80=99m still new to the Linux Kernel, and may have missed critical =
subsystem / behavior, and I would be curious to know if this was =
overlooked or if there is a reason behind not calling `vma_migratable`.

=46rom what I could get, here is the relevant context:
- Implem of vma_migratable : mm/mempolicy: check hugepage migration is =
supported by arch in vma_migratable() =
(https://lore.kernel.org/all/20200402041052.Y4zsoYman%25akpm@linux-foundat=
ion.org/)
- Implem of try_to_migrate_one, previously managed in try_to_unmap_one : =
mm/rmap: split migration into its own function =
(https://lore.kernel.org/all/20210701015416.0t4MkxtDR%25akpm@linux-foundat=
ion.org/)

Thanks a lot

Riwan Co=C3=ABffic=

--Apple-Mail=_6D4A7EA0-4316-4252-9B1B-1539839BDEF6
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><div>Hi, I=E2=80=99m a phd student =
working on memory management and I have the following question:</div>Is =
it intentional to not check for `vma_migratable` in `try_to_migrate_one` =
?<br>If the vma is not migratable, it would be logical to cancel the =
page migration at this point.<br><br>=46rom what I understand, =
`vma_migratable` is called to check if a pages in a specific VMA can be =
migrated or not.<br>=46rom what I can see, user-facing migration paths =
(mbind, move_pages) and NUMA balancing already check wether migration is =
possible or not with `vma_migratable`, but other migration path, such as =
compaction with kcompactd, ignore this check.<br>As `try_to_migrate_one` =
is the only place where we have access to the vma (due to reverse =
mapping), it would be logical to check here for `vma_migratable` (before =
we only have access to the folio).<br><br>I=E2=80=99m still new to the =
Linux Kernel, and may have missed critical subsystem / behavior, and I =
would be curious to know if this was overlooked or if there is a reason =
behind not calling `vma_migratable`.<br><br>=46rom what I could get, =
here is the relevant context:<br>- Implem of vma_migratable : =
mm/mempolicy: check hugepage migration is supported by arch in =
vma_migratable() (<a =
href=3D"https://lore.kernel.org/all/20200402041052.Y4zsoYman%25akpm@linux-=
foundation.org/">https://lore.kernel.org/all/20200402041052.Y4zsoYman%25ak=
pm@linux-foundation.org/</a>)<br>- Implem of try_to_migrate_one, =
previously managed in try_to_unmap_one : mm/rmap: split migration into =
its own function (<a =
href=3D"https://lore.kernel.org/all/20210701015416.0t4MkxtDR%25akpm@linux-=
foundation.org/">https://lore.kernel.org/all/20210701015416.0t4MkxtDR%25ak=
pm@linux-foundation.org/</a>)<div><br></div><div>Thanks a =
lot</div><div><br></div><div>Riwan Co=C3=ABffic</div></body></html>=

--Apple-Mail=_6D4A7EA0-4316-4252-9B1B-1539839BDEF6--

