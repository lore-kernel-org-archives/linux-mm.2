Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 496EB107BCCA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 16:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75EC6B0089; Fri, 13 Mar 2026 12:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F3E6B008A; Fri, 13 Mar 2026 12:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922116B008C; Fri, 13 Mar 2026 12:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6036B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:36:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 273D81A0205
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:36:25 +0000 (UTC)
X-FDA: 84541592730.07.D76F6CC
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3D70640006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:36:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=qn6kwUTK;
	spf=pass (imf07.hostedemail.com: domain of r@hev.cc designates 209.85.216.48 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773419783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+bv56JD7xnnmkG1/WXNNS8xw0C/IEr4oRQdePf+aIw=;
	b=bKsQdu40BOb+VNFA0fSdMDh4cl98OkCPyI43XjukwcHJwvtMM2CHQH85xj4GYmIlZf5DvE
	XBtHdLUeh6Dc7vWBcgP7sAam3OE0E4iK1Z1G4Y9oShKUqv1bxeGx3T92Zuehvh5+9sjOha
	RwmpLYZrIlstbSG1rr02wfMfRvhPV5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773419783; a=rsa-sha256;
	cv=none;
	b=VDwMhpEWmLh1v1weGUR+BSqhqZno5+nV7ZTubwHNYS/YLFJUcPe7s47vjBk3qHg/7ge7G8
	90hro+qgj46ax1ebk+v4HdZRFwcm8QwdPlVuYr/+m3tiNxeBufLPNznq95l0FRU/W569sk
	h3bMWIQMMbgapRQdtdf1M//DcQQVijU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=qn6kwUTK;
	spf=pass (imf07.hostedemail.com: domain of r@hev.cc designates 209.85.216.48 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35a1a36f0c0so1274755a91.2
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773419782; x=1774024582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+bv56JD7xnnmkG1/WXNNS8xw0C/IEr4oRQdePf+aIw=;
        b=qn6kwUTKsrhgxS5kpU3TtgO+sCirz0HsoFFl1Xk457nN58WQ/rJpy3I9F6ngqimlbA
         W2JOiYaSFVeF1E3AXFwAnpvIN9vwS6Y9kbld5leGr7+6/abcEetgbuNsd+41m1fRfz/Y
         z2CQUlv2M3fzph3XtRgKzFQX2rSvIirtzaHQTYBX0CXDcYnl3gmjrMqSU5FnAEviC/U/
         5QqkWH5jjyIncZtLFF1QcvUIbNyh93jllzfaikHYqRvj3SvpZi+i4Re8yAg1EsR9cw4e
         BqUC8A0E3ijAlhdsRlKDWusJSbmJeufpw45YlZDRPvq7ylpJUswcH0lLYAKrj/fmg0ax
         DTjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773419782; x=1774024582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+bv56JD7xnnmkG1/WXNNS8xw0C/IEr4oRQdePf+aIw=;
        b=FkY/xNyDaJ49iuCHffAGda9K4pSiedDx9K6T2Vy/kAx41fVGIxxabpkhf4YlVPOjh4
         6h5A3Euf9f7lhCFqgViaWX1NYjjMqo9RYcOAvQ24eBpB2OM/yH0TqRb1NdLQdtUHJqr3
         +lOw/SNgvhnQiCWpqbXHnp23M5YUFS7Qc6RQJ3Ltyvx102QRHCi3FIWbz0nHwgAeg2rx
         E35pqw8YDMGPnGJD9s2+C/0paWq7gtXFNZzk9PPSXtpkRymaBrLLVTV4shIkVmJlXdpb
         gALKGRgK3WnhPpFMxE31nlxWMJCoNANJkrYzFa77t7OUJkeD/Q9T5YbhTwv2jw0UFUBN
         hknw==
X-Forwarded-Encrypted: i=1; AJvYcCUZv2DmWegfX2hXSyXGXLMIq0fxo/7jydXPLGystO/aCQnVTCXEAd8H8+HFATnyuVf+WDW9k2/fgg==@kvack.org
X-Gm-Message-State: AOJu0YwoK5yGteZueis5L1K+tnZf/4Ffr77+ojG3voKg75qNv7mfxiwr
	Bd6wGKE2MG6pD9dcIMGRD18Vrpz6BehtatbGbWrNDDL5wS6EBqpnUUmHHPKG8J7VJbA=
X-Gm-Gg: ATEYQzzbwvsrsKtn17NwF3nrjAIH30ppZQjU6lR+O7uYhLA4g7oIDIpKqKi+XWs0qTw
	ZQBmWV+Vqm89As7uvyfvQ6L+bLRU/BJ4h7FwXmi9K80CyjKFHUKOoEuKkZb34+fvpJzAftgusDV
	nejwo86Om+xCtFMY0GvCFf4nTUMoyjmATtG/FUEa6GzCsx1BFyK260ACtI42sOFcyNUl68SPc7b
	h6aAEtI6UIqzpZM3Dv+r/hUVACIoNX1ZJzwAM0rJls6nRYO2dU2DUU7LPUbAdik6BhbSnZ73h6/
	bN5Hsd9UuXdndq9uzjJIDIl0+emiYOUSv6I44xupp2qEA/XzBKBZ7ktwVEnUOLJ9J1j8kfHmYxt
	bI6lpfqCw9DIsXYMrh8zye7cC7UhDH3rz36DzaTRFNVjm8uOcQ9JSAb+K0xe5R+pAHmVeKdA3vu
	pxHuo=
X-Received: by 2002:a17:90b:278d:b0:359:f3ec:c773 with SMTP id 98e67ed59e1d1-35a21e4ee48mr4110674a91.3.1773419781856;
        Fri, 13 Mar 2026 09:36:21 -0700 (PDT)
Received: from gpc ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359fe40bed5sm9754313a91.5.2026.03.13.09.36.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 09:36:21 -0700 (PDT)
From: hev <r@hev.cc>
X-Google-Original-From: hev <git@hev.cc>
To: usama.arif@linux.dev
Cc: Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	david@kernel.org,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	kas@kernel.org,
	kees@kernel.org,
	kernel-team@meta.com,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	viro@zeniv.linux.org.uk,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Sat, 14 Mar 2026 00:35:57 +0800
Message-ID: <20260313163557.147948-1-git@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D70640006
X-Stat-Signature: 1wanri8ay3aci14bp8irryc7d3gcwbe5
X-Rspam-User: 
X-HE-Tag: 1773419783-364830
X-HE-Meta: U2FsdGVkX19yu+gQ3vQDRTR1Me1F8ja4UI0wjhe8pVakpJdxZ3nsrjzR/iuIAKM+fV/ao/A1Uz9AsSrPOW957pWr9UVs7eUCIv+xen7yRIQsswVMVEk5FxFASFCRdXUsdRo7MT5PZ8w/wAgNvPzUTIIrN3WrEqp0Tz06S0krtwamiPKPwbj/C9/wn85l4zQHIkMyk+EAGHl/3YDFBm2y2jpnLcLE2PLUtT+KyJjxT6LPLvQSrQQH49Y+c2af1O3mMysKzQ4Rg8Ps8Y/STMN9hHtbQ0O4ue9hTK+dVZIhZu4kHa9f1QZ/TK6xbUPZDywTElmA/RSCNtyO2It98cyvMNyafftyNSDJW0NiH39chfBN8pdIhFK56q7HuM2Ym0QRty5MnaHbmzWTTVRSOWwgtpL0V52R5LSz2ehKAUtNgLVAWqBmSPHdUOEOQ2dqcnOUfSbnFg6ewDko5Rrz+sAaQryiXz0m2RPFtI4sl8s263Zc2PWC/ZJ+t+CtD1Ggxnq98Kydfm4IHCF1YrXUSRxtqZLQwPgpS0HdeXN/b1kGye/NYCM+CovCELScazjAQVPebclmsHUMyCGPcCbKnw3v6jn/5iFHCGAda05Gf0neurr19mrBYmlgnGFo2vmhwaOvTYygcbWjdREnikJsTFbqfuTetbJ8BWZAZB/RkUNfdPBMQE4mM0L5y5ohLGebwQ8IeIPya4aX5r22+9iQ3s8Cm2FxaeCCuKl5KOzESYsmuNcoJ9eM8/bgmbTVYszIowQMHOqPtjgrm5cmfzcSD1e1ElKcKY8Hm1YSi0D+6k6ATDDTAA1BZeB4nT1SZ4VpH9bKpVanIAMsYYXWxzrBlM8Cv8bNgDhoptQ/WgeXYK++Hlr6N5u794E5jaNZi5pTATA4/dekspsT49ZUvVQWbyaIfUxagEZwJVAsNfcYH7Ab7Wi0471xVnY1lhktlTB7c67CWnuW4iVKN357JsSyvS2
 xVOUmOoI
 QK5nmxk4W7H829KvY+BkGoFtp/aPurfGY7WPatV79RIsgERSuXMkySE5e3bf5gVQhn6Lps38MYUuCgwyLgBnKb3+mltxU6gWU9knHJ88vjFiTYMOK1UhX9OlDL+UYPygmPTXzZ/qwXL1tVtYaNW7lfc3hn4EsAIX1gYZoFzAW9l6bPsPUiwxEEtV/cUbMDjxfSCRHVObn4p45pkeJjCJv/hNUoFW9sjikOPjuBA7v9lq1K2Pjeqnenn+INyCBLVApuF9XBjC2pcVFTrryG+NdXQCb/jvEfDtjzQfvsS6brFX7f6GwFtTPI9LR+3OEbqbc83lWFMlMNMbhpmZazi6kZhU4tFiD6HQfcq8dj1pVPbSF7tBylmbtlVGHa7e3n5HFjIP4Wo9HhCad9dMLMGoJKYsbKQlJR207su0eRdg0PVmaxZbRURQan5+fzXcHRT34xa3XY+/31MggijM42gMZyywflnbobljV27CFk8ay08U6ptAR9vIby9hcyFrG0wqtuxmiMxy3r5d7iqpcYtKICBrxID+1I1ZZ6Ag/dSpytkZzGPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: WANG Rui <r@hev.cc>

Hi,

I ran a quick bench on RK3399:

Binutils: 2.46
GCC: 15.2.1 (--enable-host-pie)

Workload: building vmlinux from Linux v7.0-rc1 with allnoconfig.

                Base                 Patchset [1]         Patchset [2]
instructions    3,115,852,636,773    3,194,533,947,809    3,235,417,205,947
cpu-cycles      8,374,429,970,450    8,457,398,871,141    8,323,881,987,768
itlb-misses         9,250,336,037        8,033,415,293        2,946,152,935
                                             ~ -13.16%            ~ -68.15%
time elapsed             610.51 s             605.12 s             593.83 s

[1] https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev
[2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc

Should we prefer to PMD aligned here?

Thanks,
Rui

