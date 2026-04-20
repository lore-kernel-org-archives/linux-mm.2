Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B594CF588DC
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CFB6B0005; Mon, 20 Apr 2026 10:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E8F6B0088; Mon, 20 Apr 2026 10:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BD66B0089; Mon, 20 Apr 2026 10:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E91696B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:17:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 824ED13BF8E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:48 +0000 (UTC)
X-FDA: 84679137816.21.EB8775D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id A8EBE180003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:17:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJ+rN4ol;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776694666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5HAgeJOZaSUjQDMERltKw7poLkmLCttGsEyTv6VLp9I=;
	b=u5j4ewV5vlxn5pPfeWE2CAH8YM5BnAijPoVW30C/PAa/4QhWh5U4HiYRikTh+/T89L28B8
	2Tgk6APYMCXPuxwGPki0DKW+H9MaN4huW+e+LmHlDKU6Vn3F6bF5saoW0H5OkfxFMnyn2J
	OYjigkbXJgmalLxRI94SlRnEiShTkeA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJ+rN4ol;
	spf=pass (imf06.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776694666; a=rsa-sha256;
	cv=none;
	b=0WUR3nruAipTtOeVlymljZr3QgWlg8KvNoclVPq0o2PAGKUj0OLo7MxydvW7SPEy4fLopp
	9Ny1rrFJRvg6hr/mdJ59D9R3IRadXVimaOTa8f2ivDaXpSgzfJR1+bInblYcqV2uyI8Se2
	7TIzRt2YRtNzF7GMNV9axoWuWi3WeM0=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48896199cbaso32933295e9.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776694665; x=1777299465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5HAgeJOZaSUjQDMERltKw7poLkmLCttGsEyTv6VLp9I=;
        b=qJ+rN4olQKgnzw3JHh3gWjq6GpRLoXLceTdG2GbBQYo4I+DYJn6D3M1FmgQk13le7h
         +OcQFicN68YGiMc4O1RGAFuSlql2hNoEO6vmTVFVFtxg/4sG/MT7IFDBQaDMf6vmEIg4
         /Yeq4+5FBj6qF1vNXYoY3c3arnm3DYLqHb+kDceZpWo0F1lQBS9o3ZyfX+MwWkO7z83f
         9eBLIPKBE6SKh+qIMkNnANcV0oVvc9m6kRceJqcfyr9EzmJQEwHsHuehTf0vP83C43WL
         eHI/3deSunvkT2o6qAkMLxJcDOIxBj99giCWXv0JeW+9hmVhPryy5LHopeuw0D5cJI3U
         YiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776694665; x=1777299465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HAgeJOZaSUjQDMERltKw7poLkmLCttGsEyTv6VLp9I=;
        b=AtK4Pr3SFsRI37g3y9BTT6YcDkEVWr+qPqzuBB18v/lNCmx5TU6D5XsZ7aUCHZ34+i
         nPK+KvhYopyP0+kZCEj8olXGbw5J0Q5nYXfnpBCe+MA0/w1goaRJvSiIh0jMwru9iDX0
         lS2fKsdEICrmqivpfodEw8wzMZih7m7YvgYeLnK1rExPOGeI7kBo9gppv9xXmS/MdH15
         AjKuewSbxXZf9/+y1HMgAhNt6b59R774btdW2ETLmtEVXC0BHY4gJhob8+Gm2ULMnR8F
         qlW7hkuTndiGhqCkalYZ7zr5ZKMF/1Tqv+ikJmQY8SKRPUHemrYuywFD0DZDAZeIZgci
         C6Ew==
X-Gm-Message-State: AOJu0YxdSsUo2KPQDxK1ml0QHCya4LfD68V5HsHMZK4gVe3kkx3fbvh9
	Tw+vtvitL1IfVoI2lVyq9JP64KHJaafy84WHOi7IWBBx8ROTnQ+JZ1Hx
X-Gm-Gg: AeBDietT3jxwdha/xda4HXnAd8AIhT8OSaBKrEKssUxmAkdZzJ7R7A8X0jGWf6BkdKZ
	VFZkhCx/5sionLpdebmqg0iAQl33uc8K9i8ZEFiZu3ejg1AUb5CdE98Yclwtl1RWezgZzwn+V3Z
	FioewEs4L3iDExgqF7gjN8qVatfwYnqg+Skjuet1J/w9/htiv9DZZvk+Dfff395XCUbqWsRiC8P
	2me2iOFjawm83GGAMeum0ZR5JEcEYHyo+mSv2KGi5luqLlj8Tgyfom1TRawnikv+nzDeae+1ANW
	aEiXYJAC/2Tggt3KROJrtoYtLg1Kqoh6yfDxbi/zB4e5Nt5vp6gwAkVF6B0SOAUdi3bIfc9T57M
	kIJ81lxiqUxttFIyyzJiXHK1RkegF124TNERtPYp/8MrAhSs4fojZoK3kF8PCSe1e5G6kW2iFkK
	G1JG516UGsTGdBSWlQZZRDbWHiPSYNOR01fsWRVFI=
X-Received: by 2002:a05:600c:859a:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48a53ea15bdmr3192745e9.5.1776694664793;
        Mon, 20 Apr 2026 07:17:44 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:355d:3be4:308b:c943])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-488fb77b001sm131753195e9.3.2026.04.20.07.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:17:44 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH v9 0/6] liveupdate: new ioctl, change session inode type, bug fixes
Date: Mon, 20 Apr 2026 15:15:08 +0100
Message-ID: <20260420141741.2688371-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8EBE180003
X-Stat-Signature: 5x5s7mfxaqpib3zha1uar13bn4ed5bwa
X-Rspam-User: 
X-HE-Tag: 1776694666-408058
X-HE-Meta: U2FsdGVkX18lgQDLPpdwlD3mcxvd69jEthSqjlXm4FXN95VoZ73AiDcLijHsEXCGnX6bi9wm6Nw70ZPvhwSxpW5lfLSPL+KMALl1jk2xPpYFjaxmHVzlTR7nMP1Fh7xY0DKiN0m7YAJPOn/UM8V4k7EwzVfxPeIGSjvTVuuixwnQ+f5CHChqoivqUDZobzuIAO4YbNaQbyxYquyNRTgtvUJKGu7AvW7YP0BsWddt3m+S0BgUAPfu1x/IW0qQ5hZ7wTn80M9rYxi0WFb1JmzXZCrWpPaq2QXvm9c3ttJz/9zCLyLukSuHR8xiLhkLrHn3Jr58PZV1lXlu7pwVBy2218gCXzBID+vT2MtpHNzgoLEs+vHI2dH5cVZPLCgBsseHw6MJyvsPhGTDeHPUbLh08ossRVKGzX8jQUgxfQ1OegyVn0Cwx7DXIegFduHfrh4Sat/egPjGY1JRfgXY7H6EzWDQJzaSUo58cMkigvZRK5z2MNdwz8U6A5BoDE+teRRZVE+pu5SpVMBIesHW3vfDXA8r3/K5YyJkoJzAI8sJZfx30N1YxAhP2ri8ysIvuIESPothEBwsRtK0N60Z1qau1wAiigT7FAq98IOX1N78BpLZucDeCJP/ITJY8FGlxVQBF0k+w2Adyv8uhc7R/GyIPXGnj2I3h+Npnr1yE/qRyEUOJ758Wlv5NhtB5u2qPwxC799ROLWDjjXZK+1UW/0jfxppaaBymkNoIVqsSldkeNdP6Z1KkhiJSjnkc2WHQx67bxu3AOfODh8Uv07/+LmzsIGTislv5ztZh8KTYR84r/EiFZYb38tPOLASBABqw0jNxVekba7+I3Wx9eOuvsckoglqJKoUM0T6DAU+xW0qBhfWRgVPr4FFMt6wwgwjwms9gNrdgTp3SzeG7NgdHr1dn0id2xIkVE1bEXD9q0S0jfzoaiFLAX13UXOBYx6N+7I+43CyX1kKGuyHKU72jS3
 4R79pfTp
 e0ziwkCk5vfcPwnfb63k+1Muu25e3IB4/1rswx4WyUxRWqjQ6Wh8M36R/HaogttiOGB7Oa35fd6s+90VLXdqBZEyQxI557nnK6OZnSBIoaIBeILzqOzNLOMeii8ys5K1qqvUQ2flzHxo02zdejvWiajYnVb2/qm7B5RsrlAAI5oM0mNehSAdoFL/Na1UeryHUDkX6fyWScsw5wP77A1mps7+oovh+uS9gp64J3exZEiKpR+lRSE881plmgRAe1yb+J3q2f1d9S8DMaFBLw9Bn1BTFknts0L9lpB1sXteg466puVIx0wC/2e5UjZrCfGF8t7XGBXZbAKMa8dmXPjYJFQPu9iOjZDmeDkcUb4OlCiH3ddtZ5xIFSCSVLAjBwU3HqeMSf0pScrehC3tfxN3rREYnMe/1HvcPN/sIx/u26ra073kYszYvO+wAbaPMAZxyj+g8Hj+Y69gmMEXTBNmZlUp/Tc2idqWCs6nbgswNdS/76exHTk4f+ybmntxjk4SQJjYJib14NA6+Pv+lhQvIWI2BqUSPO2H2UW3tVb9Kk+GrkZsG3E/klyLR1I8gflNZXO/r/uzIfamvNJAITl80Rxv8zb7gji/ERhkft9HNI1G/ZGyzX02CeqsIfYWEldua72nFypoGW4KRKSmMYx/4i8o9/v2kez/D+669b8TFXnD96HA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

A series of patches matured while implementing LUO support in userspace
in systemd.

- reject session names that are either empty strings or too long
- change inode type of session FDs to a new singleton magic number,
  so that userspace can immediately identify them without string
  parsing in procfs
- add new ioctl to retrieve session name from FD, so that userspace
  can query it without string parsing in procfs

All changes come with a follow-up patch add test coverage via the
existing selftest.

v2: apply one fix from bot review about cleanup on error path:
    https://sashiko.dev/#/patchset/20260415184536.1155220-1-luca.boccassi%40gmail.com
    the other comments are invalid: luo is not a kmod, and the write hooks are not set up
v3: add test case to liveupdate selftest
v4: split test case in separate follow-up patch
v5: add r-b tag, merge series with LIVEUPDATE_SESSION_GET_NAME ioctl
    as they both change the same unit test source file, to avoid merge conflicts
    add '__u32 reserved' to the UAPI struct
v6: add more test cases as suggested
    more verbose commit message
    fix docstring
v7: apply suggestion from review bot to stub out setattr ops,
    like it was done in 22bdf3d6581a
v8: add new patches to reject session names that are empty or too long
v9: fixes following review comments on LUO_SESSION_MAGIC

Luca Boccassi (6):
  liveupdate: reject LIVEUPDATE_IOCTL_CREATE_SESSION with invalid name
    length
  selftests/liveupdate: add test cases for
    LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
  liveupdate: add LUO_SESSION_MAGIC magic inode type
  selftests/liveupdate: add test case for LUO_SESSION_MAGIC
  liveupdate: add LIVEUPDATE_SESSION_GET_NAME ioctl
  selftests/liveupdate: add test cases for LIVEUPDATE_SESSION_GET_NAME

 include/uapi/linux/liveupdate.h               |  21 +++
 include/uapi/linux/magic.h                    |   1 +
 kernel/liveupdate/luo_core.c                  |  10 +-
 kernel/liveupdate/luo_internal.h              |   2 +
 kernel/liveupdate/luo_session.c               | 108 ++++++++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 153 ++++++++++++++++++
 6 files changed, 289 insertions(+), 6 deletions(-)

-- 
2.47.3


