Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45928CCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 08:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38698E00A9; Fri, 31 Oct 2025 04:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0FB28E0042; Fri, 31 Oct 2025 04:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925808E00A9; Fri, 31 Oct 2025 04:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD458E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:46:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32D5316034F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:46:30 +0000 (UTC)
X-FDA: 84057778140.02.BB23669
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 624A740006
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:46:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761900388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7d2jDf+rNANjgdXJ9jgGNfHD9Jjf+8Cvrl1XyirvqFY=;
	b=cbsAFkykV2mo9IvBg4HkMEKJmrtzi8MDcT6b91mGrQgD02sqkTeCK3lrJvY7H+muNHzumh
	vwb+isJaqqcyd+budA6fOCg6nDggyyPuYplDfKT3J1JhX1PRjsfa3HqURXRezUaR1UMhgQ
	4OCAAgDtdhRceZHc1FjcGSMTLC+aai4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761900388; a=rsa-sha256;
	cv=none;
	b=Ln8Rlg6AqoNQBM2jRL4xkbHip3zUcDpRZnd3oa6UfuGXCdcKPGCM0zj6ZTWp0UgznyYbmx
	znbQmJappAsaRFlPcNwtEdsC1stBwzlY2FqJiE86a/ljqLGqNttpBbyj1HT5LmjUbH6nxy
	GTnBViz/h+Xxi7Ld0dnNB7Ds4lmMjOw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33d463e79ddso2446399a91.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761900387; x=1762505187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7d2jDf+rNANjgdXJ9jgGNfHD9Jjf+8Cvrl1XyirvqFY=;
        b=XVXpN7w1eFsf1Q8TGJJ7rGrSTElTpWL7XNFtUaGRkVwzTHaqn0kR4OC0fEzsP29ReQ
         o2sTcrAJqcs3Rpf9pEqTZvQtI0wFcnJwx/hq78McXjqfvvYMs0DedLspJKcgl1G4Ayo7
         B7QE5HavY1eDJQwawQAeDefLfgOKRnxXIXjm7F0fv5OOGj5n3jYw9JEkUp9YmgF1++8E
         0VXCbftmBFFmBwxgnNzzIdaDBfqq4WZDBjEPsFxOxQw01L+qD4qk+/F4NcL2UwXTfOZi
         2XjJhYHSrI2Q4XsQXg4jshJ0z6qhV7LQjb4s7ie8w/O4MJh4Q5KlLpYlWhvPdCqm50ES
         5HCQ==
X-Gm-Message-State: AOJu0YwaWHIx/lFUIJHzTJD3mmOFygy8XRDbM5CdULwiy8EGMPKhGRmQ
	M13CVWTTuTWmZqcQ5d4OXdvxFPa9xOmYQU6KHNKQcemN2tNMMm3rKG+95nfsXw==
X-Gm-Gg: ASbGncsE5hNQ42GY8f237b9lLyiPjAHk3ShmJYq0d/krNvz1VBuFfz/XZhKIDi9XFqi
	nDCP7H8e0dRNdlPShfEcMr0VFO8JMTG2g/E9jsumy05BkCSXQ3MkIknqETNvPYrxr3BNTfpxChC
	7f5e8b7Sbs1n5oLbBNsKHcVwUZNqDu03APimybrgvIM1/fE4tml3XsSnYyc4G6nskYsTD67nKZV
	D0xuQxXq4tFFw8NfZNczpitDswUFWpwTxEsrlWc44SK9cgnJznQ438GkK/Wjq1Dvx/dZAxoLrj1
	rZHCMyHTK0U2Tjcfmjk9N2rdxtsvTRPV/2uR/bMG6x1WDAqQn3etCML7anM2FOgFMeBL78i9zDr
	s5fSUGSIU2uyybv70iNgLkFx18eiXoCc3NyQSg1AkVDIFHbutivzZYXXzDRKbmDsFZmmnCqcjUN
	zDrUQdv1aY4SIT5+jXypD1xxU=
X-Google-Smtp-Source: AGHT+IG9MOSsDXHUjOBUeSNUFj7dBvuDkEH12Kq/Ecv5qWphiL900dFodWOVBiicFMyj2+J3dq64wg==
X-Received: by 2002:a17:90b:54c6:b0:33e:2334:ef05 with SMTP id 98e67ed59e1d1-34083070a19mr3342121a91.28.1761900387243;
        Fri, 31 Oct 2025 01:46:27 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([124.156.216.125])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-340924a0e4bsm1415489a91.1.2025.10.31.01.46.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Oct 2025 01:46:26 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: adam.c.preble@intel.com
Cc: linux-mm@kvack.org,
	Lance Yang <ioworker0@gmail.com>
Subject: Re: Accounting for vmap_area object growth when kmemleak doesn't notice any leaks
Date: Fri, 31 Oct 2025 16:46:16 +0800
Message-ID: <20251031084616.64054-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <PH7PR11MB6523C5200943207E879FB5CAA9F8A@PH7PR11MB6523.namprd11.prod.outlook.com>
References: <PH7PR11MB6523C5200943207E879FB5CAA9F8A@PH7PR11MB6523.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 6xg1hamyfyphyswgdy966jmfpk7ag7ni
X-Rspam-User: 
X-Rspamd-Queue-Id: 624A740006
X-HE-Tag: 1761900388-750756
X-HE-Meta: U2FsdGVkX1/KJyCMDBlE1liFW22UM8sho/Uvai6VC97TBGYtq1tdAYOtRg97GEykxcnkMrjN4AkfVmZrAme17cPovI4pRkZ0S6dTsEAVon5CdUh0SflUf8saHjnNe0VS1i+vPiHV+e4UV4b2rDtJtVU3offJnE2hfrfc6FnXUrKXKJnJkomDFhXG5Knf8cs34SVZz6r0+gZdkojvVwHxdP+iZm8v73d039tKWes1SpbMjkjs4Pjy3uiMqklIoG+fBmtLvmkKgJb0J1+UHngUDuuHXqjDWw5xYjTrc9fmkTTLpZFpU6FbWBEUMwar5hDCrS/Go11bYhEGqwRxiLbuNb2o3QWT1l0UAEM1NLSSTDa3EGkuaVChfsiHUbHnyn1BQX6FvHz0zcy2mRZRwqtdASyqip8WrXKdiv+pFvEAoJt9MVDHO/kJDR2SBVbbDWo6bnjuja2lAhoUawt+64IVudk7ZblqCEX6GMh89hdSy/XwJ41znc4xgokSs9IK1HY9z3l7FirTeOBBoh9zAdO5pQmSNG+uBnDR3/OI72xihvS/DAy+Gs6Ux8diBh7WBw8XRoBJb18wRYqA1OBMFEan3xFlXdzv93YmMaPJx/TCOClMdN7e1I2oC+G/NYG0QtIL4YARAIuaYZwtsqXTnLwtoaoLRq3NlRE7Rl/zGF30ec7/U6p/2mnonAA7jwNl92eGyBmPeRZDY2CvwN32cnLHlV60u5Zi0kiBQmVMpBBE+wZoElWxVeM5WOZYshBIP0+f3A0H9vt/ojR7EzYunUJzM4gdw2zwi1zty03iJ2c7n5STZ9dm0rkcbXso3w35TRpjnOWVQGSxga17Y8PFWSi82xIFbX4dGMYtDGJRKMnE2kZW0EATHg8itJLgjB3HbcIDNA6hdQ3Cj3GHfgoyA62LFWMHpIEn3bH6Ud2AzGENpmWoD3I8Ly6ceoouL2qeJBuxzCW1oktH4IlRrAoyoJ7
 B4J3oRlG
 mcR9T7R5i92S0gGpz3LUruEq3B+SEoJCz6mTOp8aUrSr3KIwx5BlSS5SzwI33eXxYhSYmt314LDRHzTYmdsO6aRAjm+saDMbAz658ZGY3k+4ODYk7a3UZPkUfnCIeElSwYNKgfZdSLpj20j97h2JpVy9LBex1zo/3sQatX8R/Epsvvu5LXRKuvNe6gM9Tov9DkaGHaSqC3g/NRE/pPgl4SMAfCh1Q+Ix3w8J5Avfj5Aocz1rgKoaWiwYc3RRG+yZyXKCxYCHXkh6fd9q4XcufdRdcwZdAZXHkTZC3YaCcdqK+v8hThyQFjcVm0jL/ItxgXh0doDpoplBFh7UpYix1q+lmMjXtn8bTF7gz1ACilQBFTMKWl35NUzjY9ETt9NjaStGpC8brB8bngWl3p7stvui06azsflPJxXZ+Q2/pCukW964v3FEdyzXTdvzmvSRnF/64w+J3TCwDe39nF3DXkxFnk1QAU1d0sLv34IHjoaqetyx8zP1HMt7LYLVvFknBLij55c3cPMiPkfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <ioworker0@gmail.com>

That's a tricky one. With kmemleak being clean, it seems like a logical leak.

Might be worth enabling CONFIG_MEM_ALLOC_PROFILING[1], which is perfect for
tracking down the call sites of allocations that are still live.

[1] https://docs.kernel.org/mm/allocation-profiling.html

Cheers,
Lance

