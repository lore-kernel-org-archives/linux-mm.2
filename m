Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE523E75448
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 10:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ABBB6B0005; Wed, 24 Dec 2025 05:43:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EEE6B0088; Wed, 24 Dec 2025 05:43:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110B56B008A; Wed, 24 Dec 2025 05:43:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED5B26B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:43:10 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 751AD59FC6
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:10 +0000 (UTC)
X-FDA: 84254027340.18.44C93DE
Received: from mail-qv1-f99.google.com (mail-qv1-f99.google.com [209.85.219.99])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2634140010
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 10:43:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=dzEjWxYb;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf12.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.219.99 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766572988; a=rsa-sha256;
	cv=none;
	b=di2KxJjSdE+u/exC1/dyF9eEqxo8KCL8lIBwPrPN5W14U+RXoCKVeMq8GRuQVuTtCFxAJM
	mp1Ga4R/uvj7c7jEGSQZ1Lj9Aq9dcli0v8mP2uFgkw9EDmEv8Z0gFh4ejA5CP3fza/zhu4
	IMZL/CJ25BBkdqLVwcS2mnqcwgdSkas=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=dzEjWxYb;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf12.hostedemail.com: domain of ajay.kaher@broadcom.com designates 209.85.219.99 as permitted sender) smtp.mailfrom=ajay.kaher@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766572988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nCs2SAia/rHlPfgeMvF1iciOa1F61MisCzZmCnV7BuM=;
	b=x8lRCkDws9xBz0pXpFYmYZYNw0GWDy/KF3ic8zmP4NnuajUrskrNkJFsrQ0f/toTNcxgPb
	EKs1ROFC2M5J2r4RH6S26wjA/WB29fpCsS17tF87dpZaIXWszcSgC45y+Fl+GoUDwfdkHp
	NZzem4bfgVrcB6N4QJG2N5lq1HTSYwE=
Received: by mail-qv1-f99.google.com with SMTP id 6a1803df08f44-8887f43b224so83182676d6.1
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766572987; x=1767177787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nCs2SAia/rHlPfgeMvF1iciOa1F61MisCzZmCnV7BuM=;
        b=hgJ4HQRxeQINtW3pw2zges9Ikbq9BNG1pwGxo65NkpYVGPDSRelXJsEfAht2RVPc7q
         l8clC+aTgfHwfWDeapbt3xW979ZqK8meA0sEjSJ9NmLNaN7v+IaJT+2Y4S1gehz9Rxf9
         jEHBEEJjfK94D5qIwFHZ47OGyvqncJbmHMs7UbPvQnU3oBAz/5vJ1se7tmJQpA969Xs1
         Qbv6tHODxsOET8ZznU2u0ley04H0EmNevjWiawzhOJ4wcpkmrgNYOHKzXPW3b3CGe4+t
         O5wgZqUl7o+HvJFt1MVqm6KAz5pF8YUYKLA2P5UGvASwNVT5Mt5XwD9kg2afh+43kMR/
         VzQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWImvQOT6i7NcWXaHQ5BwoPpYdJN4F5uH7OvQC/JTmdUcA7wHpaADDGYNyBQ2xyO7vJwrhuLXTzw==@kvack.org
X-Gm-Message-State: AOJu0YydUaFYgo8OHltXTaDVmCj/YxF7zOBw70tFE3FOOSuSXj8CXv9i
	cQh0XHZnpDMuCUng47eLbLGfPdCpAl4DIzWjKhYF84ZVkTuNkCZqNXzrGouWElXA8D+aAtzB7RL
	sBVXBdGgS2XZgELTCOTBybBB021fIVhzSjPhg4UocU/udt3sh9Rwwv/wMvPTuEicMrA+J6OxdCi
	ttYddZAKtzMD38Aa8mIagfxclwyf3u8Fq/17XHeo324DRa2nBi4/IEur69TpvhX3tW6153apzz7
	CzC6A==
X-Gm-Gg: AY/fxX7kYTcHrLsfliFcNBcDYkvFWBZI+KQ7I1yFDnHb3CORObpObD3yZWqrsbY1l7M
	dPk8rcqIXCaMAh/1Kp57qxKGoypQ7lG9qkYk+CRzfVygB3rzs2IPZiQPKCOTriY+13DXq/YHGPx
	LjlHBBavMsxBJenHR3i2wK5U+O7VbC4s3WtaW+OwIYL+mL6Tcm0TtU3luzwAmCtQK+7bcc1b3n4
	ePzw6LamFSasR18AJ11UDdbTxEQ8XXqOIPnD/DxYwatm4e3pdpqKIHOg24+KDKN1gdJF/npLslY
	zTLmcwv1Dl08R7gCH0nGgMnuIVN1+uB/fHfEbjqYHbtPfCE9cNiLvQ5+2DTC5IhyHyKvipy5Lt3
	0hMDpnq6DQ1BSq7aafYTgflcw1kSPUa70yGmXJxA6FYprqFn8KBGG4KQ9kXyR80FWmz0zV6tC/P
	czcDWPusk9QQGXBjc9nqYD19VsZm38ZMOjtC9GAbk=
X-Google-Smtp-Source: AGHT+IFEEK6c4mhVrH2ffAqPiAg/ZDeIvDejuTU0UA9FYbWax8cFh1KLsp3iI0QuFUOGEZs/646lg3/Pz9jg
X-Received: by 2002:ad4:528d:0:b0:886:3fd2:ea78 with SMTP id 6a1803df08f44-88d8213822amr184589996d6.24.1766572987149;
        Wed, 24 Dec 2025 02:43:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-2.dlp.protect.broadcom.com. [144.49.247.2])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-88d9842fd73sm21293766d6.30.2025.12.24.02.43.06
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Dec 2025 02:43:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0dabc192eso129602945ad.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 02:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1766572986; x=1767177786; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nCs2SAia/rHlPfgeMvF1iciOa1F61MisCzZmCnV7BuM=;
        b=dzEjWxYbhXMQapZ77XxgqW3jMxTZ8/MI7G2LxtG1qTtZqV/WW6vMUJpactlBoFVyxz
         HPXcwewfcUK7E39DbRbmbzekjxHnel9kawB3cXUPpk6Yp2gEe50+6cOodK1sDgi3vo96
         rKoYrJPTdlxE1vm0MAFH0oTdrWfCOKoQOH+cQ=
X-Forwarded-Encrypted: i=1; AJvYcCVpLi3WSjs1XHDOUK6YjO//baJQcB6YmxiFp4zMKzWkcBaNvcdP4zirPAiZhR4K/3W+NQvfx+kxhw==@kvack.org
X-Received: by 2002:a05:7022:213:b0:11a:4016:44a5 with SMTP id a92af1059eb24-121722de1e1mr24560864c88.24.1766572985885;
        Wed, 24 Dec 2025 02:43:05 -0800 (PST)
X-Received: by 2002:a05:7022:213:b0:11a:4016:44a5 with SMTP id a92af1059eb24-121722de1e1mr24560845c88.24.1766572985271;
        Wed, 24 Dec 2025 02:43:05 -0800 (PST)
Received: from photon-dev-haas.. ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254c734sm68746919c88.13.2025.12.24.02.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 02:43:04 -0800 (PST)
From: Ajay Kaher <ajay.kaher@broadcom.com>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com
Subject: [PATCH v6.1 0/2] x86/mm/pat: fix VM_PAT handling
Date: Wed, 24 Dec 2025 10:24:30 +0000
Message-Id: <20251224102432.923410-1-ajay.kaher@broadcom.com>
X-Mailer: git-send-email 2.40.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2634140010
X-Stat-Signature: fh8tem9iptkhi9kpk344kf4qpd8rpeou
X-Rspam-User: 
X-HE-Tag: 1766572987-79475
X-HE-Meta: U2FsdGVkX18NmIeffM+okl70SzwqJ7U2bvL67nVmlaJIlZ9vQRxDD816QR1L9PqVrHpKFd2N2SQpBmhfzz/UhNr3RhVE/mIYeS5SyJ5Qh4YZ3Mcp5N92mwvDEDvnnTlwNdtDdxBCM5Kf+xl4b0G49SvCg0OY+pYbNpieDYm8xZmB1Fxnokdcm/sJXs6CFFjji+3Oe6tSjUeLGG8mePEtnXSI2poQyiU6cnRRO0chA6xCql681+YGtHrZFX63Pxwk4htX2IgXt1kEUDuMtLlYQnMowExcxRAh1swtBH4nvO99BY/1+NcGLJE5Cb3apaZ56vvejjLxAHcsRE57bXu11rvMCbKu4vWmG+YQuAQU8vNDfot4PGOQdN6jUQfpWe5s8/wQAN6GyPdbQQAKIp3L8Lq/oIIV2jQ2zbx0NVSTcqYgaHuWzhwazcS3VBfWs4FifDH3QjTH9CLGwDzGrtGGwN3MWCJ07V/u5r1fRR9pMgHkJOiNrsOT2iFrsrTOtz7whd4vNd7nscuIkTOSUG9SMJTW0vaqqCn4w9VLACViiPUXI90l9rZv+JAN/UZ48n1nGQ5UBMk544uC3KteiY15CKfGamwedXlAmrqGvLQ0dAI9qn4AmhI/FAfU6wNK2XuF68GnHa42kCZJTAlHNpitJTrhBgYnshTD7YVcyFf0ypVuRPE5ZBaEstbVtIOtOXEtZO2KwNrhdgTeUbhB92AP7s4IskOtv5PzHa9Uwzziy9ynehAGjybhLl7x52MxrOpg9uqWhaoYEm/6Z5nTVYwkevtQIzdMwht68bJi/vFqqhwjMHL5ftA9ir/UTNv8TVUa71KjP5s5oBzXTUas4hRhFlPNI/XdBZzBxJJcsEfpzenIaE4GfWvQVKHcMJFYEej5bW3yMrX4aGqa9zeeH+LaOORNKhcnq1DL1feyLil18eGtOxUPWcuYgmZpEWZVO0JXJLoZoTDTrsc13GUjBBB
 aVuzakZs
 onlnlRkszQVO9itV2r8QgqCKfOOozyyT46L0Jq/WOqWMSMA8CQ/LGyR/8TedaQ6izjBV+n/9Lk9kMiUD2GYWP25xFqkk3WmtcDjTWHd03TTO5wp5W8+5pTqzc7DpQ1pcd0O82l8RPBhlE8vgIJ0zqEY2+GkYeqqUVgm2zTX2lRforubb43k3EwmXk8fG2ECjP31l97Z1IjhiS8uAixZLbFvA2Xk3zTPn7kI+QSLngxfzL5Jp1gnPkk6rgHSbUHviap63+9dgHFDpMG3kqJAlaLBkfmP4iqtJZ/dF3tQa8kcen33li4ltNFiF96j9Z+ewItNO6NZgSv2G4SyHtcZAIXaX9mQiRRHW6itZMqRAJbJbSCEsZDg6Kfokr2USBftStMmS7LtglOlQmNTTeTun/vls+QbgUmbFaTfXJLsoQqKHo6epeLuaQC7mtYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[PATCH v6.1 1/2]:
  required to backport [PATCH v6.1 2/2].

[PATCH v6.1 2/2]:
  backport to fix VM_PAT handling when fork() fails in copy_page_range().

 arch/x86/mm/pat/memtype.c | 50 +++++++++++++++++++++++----------------
 include/linux/pgtable.h   | 31 ++++++++++++++++++------
 kernel/fork.c             |  4 ++++
 mm/memory.c               | 10 ++++----
 mm/mremap.c               |  2 +-
 5 files changed, 62 insertions(+), 35 deletions(-)

-- 
2.40.4


