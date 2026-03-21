Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB66E109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47DA66B00F1; Sat, 21 Mar 2026 13:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454D66B00F2; Sat, 21 Mar 2026 13:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391A06B00F5; Sat, 21 Mar 2026 13:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD616B00F1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:58:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6708BA18C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:12 +0000 (UTC)
X-FDA: 84570829224.19.8EAF815
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2358040005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:58:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=icSI+ue4;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774115891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mlBDNS7j8/emmWuIK2UQ5HjoS/QYu92EKlQy9xzW8WE=;
	b=qDSXoH1tiElJzXG7l/wlfZgONiCHTs0fAFj0FUspWb2VZ/q07tKBbmuAcXoxQaL543gYwI
	Jk8aKrroNSerlWAS1W0y9Scw3NcwuV2dx9B1JF/tgVLvAeDSM82pwXiw3ZZTL2agjfNKPs
	xhal3innNi2ZuxSl+Qz8LuSn2RRddYw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=icSI+ue4;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774115891; a=rsa-sha256;
	cv=none;
	b=6xPRHZeu7lvwYWqLRBnIYt2F7+yoEkDaWGikGgTD+n/qw856p6N7OHgf6mjsPv8gr1jLj6
	phKlcD95Stv8y+tyY4JAOXNv7gZ2M7+1wEVXK3xyJZ+WPFn9qSuRg4+oH5DyZpNdw6zbQq
	jGhqS7hkLylqqqKtxSbmXYdI3MfwmcE=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cd7ecedf2cso155120785a.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774115890; x=1774720690; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mlBDNS7j8/emmWuIK2UQ5HjoS/QYu92EKlQy9xzW8WE=;
        b=icSI+ue4TMVTYxZSa+2MitR1StyTMAH3hEX64JpUKq6NS9UDZeFecXsHNRce4qpxwp
         vKgTiRtNw2rwwmjEe7Ty/cSUK1XiQbZ7vRmCzwBMI35q9QPtNKkVE18d1z8vu0e1tRT1
         x+dHuluypRum1DwsttRusBRaY3wYWV/ZrnHxiu2r+W99Y1t0BbG3KxAAhv/by34nHFeE
         Bb+diDVB/KPKisucKPpTAj+UVkKAesXbKzFPqjcrR3ltk/NPDNpfG3jb9Jw6F6g0jBik
         o0mZ8YwoVe2+dUEp/C0n01hD4LGSkUaYHDmRHBxmTGvmRhHMyPtSNLbbpPjrDzPdXHzn
         K2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774115890; x=1774720690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mlBDNS7j8/emmWuIK2UQ5HjoS/QYu92EKlQy9xzW8WE=;
        b=MiNobbIW2VnUEN/vmT7sFNGgU97DNOm3VHkZn6MaIFtlqQDpgEFTio4LwJ2aXfzkve
         XEGfXKryFBJ0/9JDj5958LboYH+Mc1bp1nDQIotk0tobpWprcQ2vvTLZ8lCXM1bDAkCo
         5OxMX8o9RhfzmiwU1zV2VO0SbhyUf41ebNAXaMF5grnZCONb+Yr1gZp5KTgNV5FO0O5D
         Ugk4OROMgKdLcAX67XLZdnb1EDcYkp+yk7VcwTENaF/F97Cqp2UB4J8PMMIW1AkRFRSQ
         K5m8pgS8MWP087ldeKXB35eyWOkc/GD2dCzyn/xEgqgXYMON//UIsC1INSBCILgef7o5
         Jk8A==
X-Forwarded-Encrypted: i=1; AJvYcCXKV50nVOE327ibnC1UusEeFPbLypXAoj7MZDsNjSx10try54LP5UFj7PQkWQO5UjngRAoGw7JMnQ==@kvack.org
X-Gm-Message-State: AOJu0YwYrigRI3HOsjXPpUjYke8sA6s/pwwPTV6PnOHBryVVEJh1geFs
	N7kFJFJT+RiA785AXG12TwnGL2pvdiC/4A5XCffD9h9q43FWYjAvxGm03HyGBTw6MjE=
X-Gm-Gg: ATEYQzxPdXmGY/Scfn6hayKcytHa2Kc2JckrKvgQhrvNxvTir6a+t/Crw8UoIDOROIq
	SYsMApDl8dgokLkM1MRxC8IAoePhmkHiD94lz3QcJS5Qv531CptuDlt0yRuNN+xBv/mR/TGk+mn
	HeQTL7/m7YXNByeKfXa20VeigoPoUl89vqiuhZX1kJL9fxbOB2On3auIQKjx0lSd+kiZh4/uCCM
	aw1L2NrgmrlneQstQ1ECsLTzsjWxRKNl54y3rF40Va86hw1Um46+PspudD/aPNWJuBE8UlMBrSl
	doN5uCUIIxu27iPl6DN0uG9v7vYr1VcPpiS2O4ptejqg4M6HVPfJDHyN1v6lGZCn1yw1iuvhIpI
	5tyTeByCYgq094isLubtRevgAKjoXnBtgCU9Hwssz8Xdsbb68mOGE1446kAdQRYDci1n/J/3aBc
	8BhJbcTOq7hqx08TIfd4AxGweC1rBcje2ZkwYChL2ZCj5eC72mGhtJhdjvlQbdURa/zV2+i1v29
	XBJ
X-Received: by 2002:a05:620a:2802:b0:8cd:87aa:e3e1 with SMTP id af79cd13be357-8cfc7ec2244mr1057915785a.29.1774115890136;
        Sat, 21 Mar 2026 10:58:10 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc9089ca9sm426515985a.24.2026.03.21.10.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 10:58:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: brauner@kernel.org,
	linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	jack@suse.cz,
	shuah@kernel.org,
	linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	viro@zeniv.linux.org.uk,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH 0/2] liveupdate: prevent double management of files
Date: Sat, 21 Mar 2026 17:58:06 +0000
Message-ID: <20260321175808.57942-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2358040005
X-Stat-Signature: izuzomrp77mzzcxcyjscwerw38xyjg4h
X-Rspam-User: 
X-HE-Tag: 1774115891-578203
X-HE-Meta: U2FsdGVkX1+bZeZp3jpVgQi0OmdJbMowtgv36r/bBs8gNuSRcB+Wh14rtNKc4tYAngjJ6zkzsYtoxMUvPsyWH6RMR7aNi8TPosgpJqFQ+fdrEFbgjkIBtq/wXqu0wWtmLDW0ihtlzV1nYzbcGK2atGwhEMKeyoO3pSRWU8zD2hX8QvhDSY88iLryfSocBOmbmCfy3bdNcvO/vpevaxybEJwyhkf1o8+i3PWtAv3bj5icDCBVXgUDBYS0cPN824Fftx/2XJlJ37xLTZvcp3pnD/GL+e9TKgB4bhVh0/76/nstE2H4fQUlW8Dp6DM0AnvVWpucKMrqSa3Fqx6PmT3C8Lc2fHfyofLeKOtE0FeJYuJ0drd4/l5Un1Vjl4gXAJM5t1yf8YUVZWvUCs4IjRazQ4muHW7r50AgVkmAXyBp82hCqxRLw+S16OvOtikgfX206S2koKxacNqynbqE9YcMUWDICJPs/YecplL6j1S1ESKam4VH8hmNg5pvQRThFCYfr03OInjbJ1vRjXf247eR3X46nPQG7FNLWpCxD+HduVG0HbzZpgDAmZGnrAzJaW844iVHUkMVNmGQE1bghLJTT5XbruD1c363z/V91uUoL96YJ79PBS8VJCF6OPllpyEr3N6ufdr2dEDiV2ET6ESCZxF2hCevf7mRUiMB+boqQxov3fyNGC91+bQObHHJQpXfDQaE9JeUtH00rINndn438o92mxE2M4g87CX7TR7oKW2a4QH8UL0TEMC5M0kpDd3jbmjPe9biWVq4Bw/jUll5YSNwmN24vZfpEZQS6Z3+NbBHWfi31UbW8UYTcz2Vr6F8nm8LLRX833TGKzeL9WdFaYc+8OiMtJhZ0qQPsRKcomeIRu9uGFhlPik11E6joIc1VXx+8pOWwogjbi2dxb/6ty+NR0lqnO3NC7aI4i0MEQ87yp6HKhEtAvqrtX6/aDTtrRkoHCO1kdfAFg8sow6
 jPHrEG50
 EpclGkl2Ae62EXyTMmEA3wUY/DLnJgdqpOT3Z0T76wj4oSPfmC8RGnqNy8i3rI6S/njR9NHa782Jeujw9Vcr39zBh5UrwhhDpOKLprU+8aDX8S9uuWtUDgG+dmjqKbV6HNSQHk/MfF/lu2dZVMbX+pXUF35aBrycCRyQ10ivYqco3hRrXVmXU3vBrHkXwrJ8MGcrWS8SFygaMy87TMPxJb4EiDV81YtnwIMQ63jlTvak4Ji3uztbXN5YQmDQG6hmG6kVeYzpvM7wF+uCjJvlxZTA2lnyAq5vEPLwKdU8Tra6pcWpi7TUD/xguAuPc1TbgBQmOvZVa6rkOusg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, LUO does not prevent the same file from being
preserved or managed by multiple active sessions simultaneously.
This can lead to conflicts and inconsistent state.

This series introduces a mechanism to prevent double management by:
1. Adding an I_LUO_MANAGED flag to the inode's i_state.
2. Updating the LUO core to set/check this flag during preservation
   and restoration.
3. Adding a selftest to verify that double preservation is correctly
   prevented with -EBUSY.

Background:
Because LUO preserves files of absolutely different types: memfd, and
upcoming vfiofd [1], iommufd [2], guestmefd (and possible kvmfd/cpufd).
There is no common private data or guarantee on how to prevent that the
same file is not preserved twice beside using inode or some slower and
expensive method like hashtables.

[1] https://lore.kernel.org/all/20260129212510.967611-1-dmatlack@google.com
[2] https://lore.kernel.org/all/20260203220948.2176157-1-skhawaja@google.com

v1:
- Rename I_LUO_PRESERVED to I_LUO_MANAGED (Pratyush Yadav)
- Set flag in luo_retrieve_file() and clear in luo_file_finish() (Pratyush Yadav)
- Added trailing comma to enum (Jan Kara)
- Added selftests.
RFC:
https://lore.kernel.org/all/20260317023834.487682-1-pasha.tatashin@soleen.com

Pasha Tatashin (2):
  liveupdate: prevent double management of files
  selftests: liveupdate: add test for double preservation

 include/linux/fs.h                            |  5 ++-
 kernel/liveupdate/luo_file.c                  | 27 ++++++++++--
 .../testing/selftests/liveupdate/liveupdate.c | 41 +++++++++++++++++++
 3 files changed, 69 insertions(+), 4 deletions(-)

-- 
2.43.0

