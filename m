Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A2BC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6979F6B0099; Fri, 28 Aug 2026 01:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FF16B009B; Fri, 28 Aug 2026 01:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585456B009D; Fri, 28 Aug 2026 01:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351396B0099
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:29:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA58780366
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:29:03 +0000 (UTC)
X-FDA: 85149549366.04.E2B9B54
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 963D7140005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:29:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=irdEQKOf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf09.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787894941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
	b=7OL13Lg1mHr+o57ojGtEDnQftHHFpTyVORRzgdXzypGkN3J1HXdpcakDdyqFxwUNPM9Cl4
	obQL7iAlvSiyi9DTh0QvhNoc1zYlZWTRlR2wz0Ob98gDI71GPh+oZIMbLzKTIt2VYoozbm
	fn0sfWrQMt2ub75ViGImWWAPBXrm6WU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787894941;
	b=xcvGBf0eAGv56bS50+0GEI2pIYitfyIlTkjXja8QnhoPz8FMHTDrYXtluZANBcxwdUkoO5
	XUXvFAjng9q6Iirsmt5XSYPBYt8h/aJSeFKXxxioW6setoTN2Um6uokodBZwh2GHNHTd2R
	kNrGJQ3do4tKvLYomXyeR50lHbP+oPc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=irdEQKOf;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	spf=pass (imf09.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.214.170 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2d01663d816so4776455ad.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:29:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787894940; cv=none;
        d=google.com; s=arc-20260327;
        b=gWl5JJ7cgthNnYk/1Iv24JwYiHS/hshwZK6MRuAWje4v9u6ABBwY/bjjqvcUYaffRb
         br+xWhUSELj3FFZOaWTYo3bLqpkxKd/2INdVgRVEt2uD0oso4pGo3Lx5ZG37/vAJu3wE
         trJGEEZK8Nv9aZa+7RCyGHsLGAAHVtIkNsDNhUxJXAZsLY0lCvEd82GEZDtOMPGC+URl
         fLBDbt2cOsgISJiE4wi5RrabmjjBAxBJ/iGduKPB2OlW2aEpjJqoO9V8gY6XmovCMjow
         oeCfk44wbDFtM7yITMBqmuROgp/qmjAzg5GoRu+5coKBelE2nOIE7tAEmpAtfXLdmzwP
         eRfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        fh=Db8IxUEpWs/sSp3lItTCxpF5VuMawnfyHuN3sUCkCmY=;
        b=EBM8794l9ZhMcFIdU2vTzj69F9fLOkcVBNnYiv5NSahmTgazHvHpxM4Y/HZ/RQShr8
         v5hDYO/ZeWuOzWlgk26TARMJfWKUOzSxLV6npMJuU3VB7MRqYfxpP130wqokCERqBOP5
         1lV+M4CMW3mdobXwShjTtty0dIZYBliVoxdorPBQioc9NcJUZVt59vODZs91wH2MsANq
         AnDXu24lCXBwwQkrhdsSWXQYc4eqHrrwEyNM3jF19r8KZ+FxRqiwnlD4XUjE2T3HUJHa
         IpAU8AkAOOabEElz1NDj2B7WuQM6pTnvknMwOqyW6/nzu2MD+3samwviS2qWoAp2XN+0
         8SAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787894940; x=1788499740; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        b=irdEQKOfqFEWJgPfs1gzIHZo/7ziB+A7OTNTj/6/luxEPQD4pSHjIxTD/LVDQ6BrU8
         BU/YkKLXerFvBXBWEH4/SkPmHpspHLYUwu2l8Lgv5kPySZiJh9wNBFmfBtk1oW4U/irM
         ZCwGwqC/+tPFJwqEDlA0FTcx3aZ1SLXPCHfLjy1CkBGVcRSeVY6m/E4bjKMakyf42tK1
         Aqf/hodYuMWJVksZTJMuA8DUhWAHRVEEVGF2eQ297oF/0wTl+Q0zggovtDS566+l21Kb
         lhF/ntNxS2uyTpMRDy5DOjq2OWRE/xc7F5M8Qn2c86ANfDqhrYnE8l8KERCaZIpYo8gg
         htug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894940; x=1788499740;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=323/e/RaqA8mIXEHSxzv2u3juG8I1v9sZLdgI4Di9tk=;
        b=b6ulxzusu0MLcWu7cWgyGERn+OK9NaaqN37Ec8q3nt5MIEaUwPi9jylGG5+ztndsME
         A3GRuJLDgz4nkJMhRqDVuqhSuDlIEDpIyNf7hO3tO5Qpq7VG9fN216OsA9DBc11+9iXH
         0jMW8AuAuQIPZO8N+T19adN66x4+hoZfO49Lacb4Ci49ooREk75GIZg1pCtwM119NGQm
         d3KE2PCRb4lRo+qtnCm9UkXhD2MZVXcTkn0JHjvdZAsgSqoSlPdvHlIY0o6rLtFW/0kk
         X20LFaOU9Pkj3KmVSNLbBrOuPgtInDV7iJkTmsDgF/OsS8Rmp8Ho1BfHgGuikWFg/HZI
         ViRQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr8WASgmsmGzcG1eXb53WdR9nLZqs4A+c+3RCwrHdCWndRbA9tPvTKN8W7ujkm8G4W9UoN2aHrjPA==@kvack.org
X-Gm-Message-State: AFuF++lUGIpD0Hs9E3Dl8vb1FKrS1oru7h0e5cvVixFlNyUeMXiWU8gA
	Owp6n91j1XICBpTfQgcgShbeB4zgDLfIVuGzPjC23oNEt0LVYbPef81FXOooJlNykfszKj52rfj
	dqs684Xq+xjaTnPp6yYigRbG08NcxChcfqfdbZTbk
X-Gm-Gg: AR+sD130fvP18hXf8Rg/08f3B1T+7efZovEgaS9psiV7mnGI7yf1fW3bXmLnTcTOEsi
	S1TKn/Ofp64CDDTiGBScV1NiJZ1LV3SaLDnN7V7+lYHj0vLgy4Ow5JEMnB7Taz6U60efVnZnh8G
	AebwOGACdQH/AjbE77mcPaat+qhlOpAsGGwPLcZ7m6Uq8HBTOaCnloDLrQHVHm4+tONWtC+Phl3
	jvgLBgmQ6FmJ2V9eyAQNszwySXRvcRrBQLJfYl2C5o6xwzdop28GsyvffwPyveEoLrcqQSezRa7
	hWstmkYmd57ptXXGCw9U/NbHsWAEQ7wdXgJMhTY3p4GF5RUqYj6nO4+MJeKtwf5dhGq7QX2okhs
	mpvmVYLFs8BqzPKlYE+sSBDphxwnXyLtiYwIrri1QFDU=
X-Received: by 2002:a17:903:324c:b0:2c2:62ee:5a0d with SMTP id
 d9443c01a7336-2d74df1c634mr88380135ad.14.1787894939423; Thu, 27 Aug 2026
 22:28:59 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:28:57 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:28:57 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:28:57 -0700
X-Gm-Features: AcwNN1UlzyJTQI4xLeKZfZmMD9WMPAJkGc0arO9zP77WjK-dTinfNX0jJqWgP4Q
Message-ID: <CA+0ovCgWzUMK+nNbbtH7eV65Ca=fDN4Ozu7iASgryjvv8Tk8zQ@mail.gmail.com>
Subject: [BUG] refill_stock -- VM_WARN_ON_ONCE(mem_cgroup_is_root()) from a
 write to the cgroup-v2 root's memory.reclaim
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: falemi@asu.edu, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 963D7140005
X-Stat-Signature: pxeh79wbuofpqsq7tdnzc7xqqtcc9e9a
X-Rspam-User: 
X-HE-Tag: 1787894941-518469
X-HE-Meta: U2FsdGVkX1/MP+ufwTDKwTALsY48lBg/AeacHRx6HlBcL5dZkwUnuuk1Ud94iuZtPfIuuX9A5doWbV24zINDYWOGos+iK08OLektadTvNZPVsYqiM4xQJTKP24oiCRfJslIYMeC4YWsRLDSOWJvSsqcSW5ZmHbgpzAvu0+3GCDf92ewkeUnnLaYoEGcm85Ytb5nzWjJ+ycOffNq9J1y7qsezEndbKy5lXjZkMrrggPyztM0HLD4begtZMmV//TCA4oiEMH/iAlE2hpreLoMe6Gqs7bmY00HImiWwF0iRu2NclvqfZQOWRJhBEqTvyr4XYp2Abd5lJ33yO0uXzO345rzctlljn5gKDDCVLxY0jWWpshFBP+5euoad/oKgM7BKTnPdfiJfRfF2AHDwWJcRz0iJPW9em+uQXoDePyTKtmYaLxGTZMBIj3NCskVivJOGk7zIM0LpSDe+9N3ZoK3+GXEHwp9CbsbNyJXG4NpwgjL69U0P4b6rpxcWVtza7GSP9ICNH81Nmo177pEAl36VsdTKIGIP3LJltzTS2yi7CPNfOp6Fk0ZApT8vARSsyTRg/Gn0Sl26/4mgx5ALZXdrRxzYr0wqZgA8TY8UKC7qNg9WDO3gNIgWc/PMDi7eh/CLHmsy1389xA5zd4lWG76PwOCU7x6/uWeBw/7jPwIO5c19jLVHpuqt6mv1qHs5lljb8Uh0Y5IS1r54SZ+JY5O1pupvpLJYC9P0Cil6Eg+NXt5qg0LzwNw+LjhNiUhOagusttoUATWNDcc96GRNHDOqoZaMnKKeGPP/qq2eZVpSTCE38guG95WIUao0OVxSYcxPkQfEnKMyMfsjhrLWk/50xCGVvKw6q7NiUEqPrD6NcaOMzOz9W566+ED5b68FZf7udHNJW2F2WNpuEgcLMrqIppzVh/AwGKa7UDO49n4+kU1Ykhv77kPpTKO6XU4kXRno14edRsvtK3Wmo3AI0B5
 z06mSd1w
 WgmZSoUQOPSFtu+4Qkg5xLWcpZzOVwg/aKedUYtNg0Wi6Wbp/gn1KL2yAMcDusWKwtDv1qXra9w+wQDAlo5xRu333j98W9DMtCHHZlXj6lf0jDEUZ86mhFa7Yx4tLvJC3MhVOcNqASZh0do6c/KDNaSv9z9ACtvhEqQQHtAiyR/VYS0WZbCnKaFlzaEjPk0BY1mDOa2V5Dl11xuQKwBsFIk5W+fYD+RWS3aq2mIgoLpEgg/hkRHPxseVT0r4fRq25e9lGkxy/0rl1ih9fO/5vj3mXFCZMnNzxz2ZhjbetUPDZVjz8HOW1inlyGhSQInmC1nzaoGYP4KdfMuGc6vh+fqVITBk5TSAzb2P1SOB4L+dUTa6bJ0MFgxUrQT2ORyOt0hgFUuXpZd+HPAaQmJf/HvUERA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/145-memcg-vm_warn-refill_stock-root-cgroup/

  mem_cgroup_is_root(memcg)
  WARNING: mm/memcontrol.c:2198 at refill_stock+0x644/0x940, CPU#1: repro/9490
  Call Trace:
   refill_stock+0x644/0x940
   try_charge_memcg+0x12d6/0x1570
   __obj_cgroup_charge+0x35/0xf0
   obj_cgroup_charge+0x1de/0x210
   obj_cgroup_charge_zswap+0x83/0x270
   zswap_store+0x1620/0x2000
   swap_writeout+0x94c/0x14c0
   shrink_folio_list+0x3388/0x52b0
   evict_folios+0x374d/0x48c0
   try_to_shrink_lruvec+0xe72/0x1350
   shrink_node+0x3320/0x3b90
   do_try_to_free_pages+0x6a2/0x1990
   try_to_free_mem_cgroup_pages+0x30d/0x830
   user_proactive_reclaim+0x504/0x840
   memory_reclaim+0x1f/0x30
   cgroup_file_write+0x331/0x8f0
   kernfs_fop_write_iter+0x3af/0x540

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,

