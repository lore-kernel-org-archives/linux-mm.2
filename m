Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1D7C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF5C6B008C; Thu, 10 Sep 2026 08:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3607D6B0092; Thu, 10 Sep 2026 08:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24EE76B0093; Thu, 10 Sep 2026 08:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0505E6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:57:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B651804A9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:57:00 +0000 (UTC)
X-FDA: 85197852600.02.1F10640
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id D821A40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:56:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OIG7N2AX;
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789045018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CKchm62sZ86IgrB2SwATbeij5NNcxRfyf4EvG63ewTA=;
	b=nwdTzvv7RtRXbd0hiULnL2gK19xE64YTABgyqFGUDyx5KMSkiCXy1HVaKx577T4cndtmXG
	YXAFJjCfi+K5N9rM3+yBM3C5CHk/e5epRfDTWValN4tdPUkzG5It3YrudmjsHZMEKn7xl/
	umRmxcgWna4EDXWH5yWgJT+rvKf3A1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789045018;
	b=nNnUbOb3PchNJo4LBj0iGVVPQ7WuSkrftMj3rTn2zvt1uHlkNqVjg+gysBQL5lsKg51Dbv
	WB7M1kiPuKDbEnx8tvMWdMM7ZjNtdBscNmuGb/NF4y4/n5cUiybBvDoFnJjsbM7UrjcaH/
	9mfAmTaJkU/lPw7yp/VPa8MUD4uHgfQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OIG7N2AX;
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-39b2ad83680so2892660a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789045018; x=1789649818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CKchm62sZ86IgrB2SwATbeij5NNcxRfyf4EvG63ewTA=;
        b=OIG7N2AXTde9HzijfIoTEXQJ1OgSiAmZN3mleQTC973UswhU6BfayRuAncXme8ONiN
         tk/yh1zU7geiGlC0hf3ylmIEB+zwNXm7W7R1LLM6aPX9o/lN9xKnFd3H8VYl2618NiLE
         k2Ec88gtKZtxZBvmtbwEiaeILQne2Pcveqj6rdACqbXGPxdFs36cW3gU/F0zb+zMs5/t
         db9i/RALCYfi5LC86bzqnZ4xjHevyXz9vSyw1kOZ1NBXYpZqJgUiXcNY7hrgxYAbwy9E
         n3Nq1WGlkXK3vzonSEPdMfPKIdYhtfC/m5hrmbjD85eGj+5etbrok1nuQtoff6iGZ9OF
         dGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045018; x=1789649818;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CKchm62sZ86IgrB2SwATbeij5NNcxRfyf4EvG63ewTA=;
        b=aBp65R+I5cxjf0405CU6T9LKYBxH73nyPht5TIoddpE+yudAC5U9oYW2lKqALl9+6R
         KhvPmBx9eds5YqYyIc8pFQjTMxHVXSDM539HTzR/AKRbNDsc0xAT5eUL+Xnz1J5KkeIF
         1R/Kh91LvXYacNru5GH2CtHUrhMa+tPC/YeO/U/EVtnrwq6ls/qOJ2YNa7qzSTSCgVl+
         mfR5Mh9HfTy2G/Ysrv9r5/ByjsryOGE+d8CYtyT4zqPLZhZkHuxYCtPQYmv+XO7p9bVw
         j4AQ/POviLF1xDP+1jmLBCMxMgmGstUsnLbR1DJdkVuCndgzCPn9fbah0mQAYp9O4g5A
         Cq7w==
X-Forwarded-Encrypted: i=1; AKwUvByvkYNHUlZW0WK0J9jWSs6+vPu8IIh8lx88ro6aBxjZ8NZuiW6NCKYnuR3W0fJAidKB2uljRPn2Fg==@kvack.org
X-Gm-Message-State: AFuF++kVeW4eLoRaFNMJOw8n+wUCjjqGEStDshvWNDMQt119/zssWP+0
	JkCcG4zRJsmE3EJw0YPScxVRoZ5Xuqgc/EEmMR82Iq30hdszfD/5li80
X-Gm-Gg: AYBFou0Z/Bo3yQ+GQEj9zw8TDeuD8m3hA5xah/DRQabr/tsn4gYQVmO4/Vg/IQTfGXg
	YEek03uaJFHggxRKDaFlQQU1Msr/6djofeyGedsHdqMoo4+p02s6/YQmu7AB0eFsit0/ZERv/Ef
	E529WdSdIS8z3j+vqYPQYR2QEbIyfutg5hz1+q1LAP/XFKaKSTsw7iuPJBSAAOPcXwL1+IWwgIZ
	c9soYRO48dWs8sQd2jAaOfPyk/oSO/ZL0FVTdogagFV9ePrCN39eqM3zdyIn9LfQgLsnxiq4zbR
	RUaEG8wLqiRsLDx/GnFviGnDgwh5ugPwRXgR3T/P8hE6e+Xm7TZO4pIl8Jh/H/5x86EDDdpZTRy
	4VLW4+S/vie8cm/iNudv0SprhJKwf9RqYiHIgEGh6ksicivRwzOT70oIjC/Am/zpU88u8PbCUa1
	rBKwMaqzQeUrAZVNZuMIwn9RGmSYd5EJEBkLEnZosj7CqtYIidxkIzK39o5w==
X-Received: by 2002:a17:90a:d44b:b0:398:d93a:b343 with SMTP id 98e67ed59e1d1-39d709e7326mr12383992a91.3.1789045017611;
        Thu, 10 Sep 2026 05:56:57 -0700 (PDT)
Received: from fedora ([69.5.53.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e9014cbsm4800488a91.16.2026.09.10.05.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 05:56:57 -0700 (PDT)
From: Tianyi Chen <diannaaav@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope memfd_secret setup
Date: Thu, 10 Sep 2026 20:56:43 +0800
Message-ID: <20260910125645.285866-1-diannaaav@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ewjbnyptedhum93d6yktb1zoyuqbqjf
X-Rspam-User: 
X-Rspamd-Queue-Id: D821A40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789045018-890662
X-HE-Meta: U2FsdGVkX19HFmDRBUEZhL4nI5yZwDl0hxe30TbBPF3D56ds9waVdf8eov4flc09XBckpG2MSdmAHtL/VxweJvPSQ7KqEMJGtQq8cVXQDYPYXxuKE2lfU6xMdnQlyR9p3DLkSzpq6qwr3ADOiIRsk7NPBenzlFtp2JOzYvHuvDZCrrdP2gmGmwTdkwoO/DHZxbuJD8f3op9wg9rV+KdOkewQjiwaxUfY6d5C7Cq83VoEbxr8lUNszPjiuHOXFN7Ov2zvNrXdT+IHKU7ISRRcWK45EqryCDoTfXtjRaYV+Yjl6GsYhiuq863YnzjIkymtQsqDW/7Wl662u7vfisQCxUOS/rq7JhC0JE/5zTMkufv9tMkRw8ip09/qkENQfpE4m6jx9AUqimGUaLE8UN6cPGmHEb8pwWIrE0vIfSFicL5Ab627WR6U4tVxMOWOsAWJNGyUJjOMKByiZP2KTF1yiv3MVbeB9TgDNQYyVokTE+EzC7k+VCWaWksjwq8eLURB9BYgLnBTFEs/+MfeUPlAWn0Z0LFFHOQJ0OdE35eOi30t4VN8sk1WtH4w57Dj9Bum+NWkMsariYYVBZ5KWwLYirRfuS31apeX4cKlB1QUqtb+OZpNf37Tz+/U/9ElETykzUq7lPHlgnNk9bt3yGdLUAyW/mPbHQ+zP0A30ku4Le1P0qzfiCPBN4y5oKWNRVNddrg6bCmVd56xqAoMP/jor6ke8/gE29+YNZEBPv7/AoyWP3uY/jUNClIXGvzMWW7TC1GWr0CAqFJE5ELPE7P1S4yoIPO5HMXsJ+UYo/o91juM154hxyYjb2iUd6mGeNbwrMzoNevtRthYEmxF5JwwufugCoWSmIfu4y52uBNFJr5bgXN6zcjvT3DaF1dDTVfEKH0sm0TT6it10sIvadb5YLVvSkZSobMsj5thckr+hQjfVoSFOkLUZtxgDlHAWzMiAzNtXHb8dYwl42rsfas
 NtpfonV4
 y3CJjT/XmtP2S3zbARxGXkPrhoONRSoACn7MWLr6o4DLgK7PBuABg4JXzM6V8jHTsWmB9y6UZJtoGMikCAmVLpMEFionfxMhvcjl9lFa6O1pSQaB5EpZJ7BXlqt+TWUjhRBUgDkF/Jpp/PTz5Kt7eUyYjc+osa9Fx5TCbaM72WkR+8QqiHesBG2CgohGVzjbFVoQWSJ/9tHrpXY3SYuCRcV4CpW9Xh0VyL9eIOQdM2beByvf9bIXJQWCfklAOKVsb5JszAH7HvqBj2T1L0zdJZDVonA/OXGwKbWtMCNmY3W/CWUlzNgLvapcJMXKFon493/yTWMtvaK46qa+zSKcLqXEGgXCwXZS1MMaWXgchEjgOYYq7NjrLVUtlpbYbxrmhpFmfB77p69XEcQlainYsgflBJMqJkRUGVvFqc/fI8HzNF6mnHFP5Ib6G0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh can reach test setup after invalid options or category
selections. Its memfd_secret preparation can also change ptrace_scope
when that category was not selected.

Patch 1 rejects invalid selections before setup. Patch 2 gates
memfd_secret preparation on category selection and executable presence.

The patches and commit messages are unchanged from v3. This resend uses
git send-email through Gmail's SMTP server to send the patches inline.
Before resending, I sent them to my SpaceMail mailbox and verified the
received contents and whitespace. Both patches passed git apply --check
and git am, and the resulting trees matched the original commits.

David, this is my first time setting up Gmail SMTP for patch submission.
I'm very sorry for the formatting problems I caused and for taking up
so much of your time. Thank you for your patience.

Changes in v3:
- Initialize VM_SELFTEST_ITEMS to "default" before getopts, as David
  suggested. Only -t changes the selection.
- Use Assisted-by: LLM in both patches.
- Carry David's Acked-by on patch 2, unchanged from v2.

Tianyi Chen (2):
  selftests/mm: Reject invalid test selections before running tests
  selftests/mm: Only prepare ptrace_scope when memfd_secret is selected

 tools/testing/selftests/mm/run_vmtests.sh | 28 +++++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

-- 
2.55.0


