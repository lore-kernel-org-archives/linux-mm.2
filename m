Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 079DDD73E81
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E2D6B0089; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8736B008C; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EAC56B0092; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D7C46B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:35:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA8F9C13E3
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:35:19 +0000 (UTC)
X-FDA: 84385702758.03.E18AA42
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CFEE1A000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:35:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b=gMHDc7jv;
	spf=pass (imf19.hostedemail.com: domain of me@snai.pe designates 209.85.221.48 as permitted sender) smtp.mailfrom=me@snai.pe;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769708118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Td/1webZFtgsexoz6A4dWJ1XKLPDFkv6w3Bvpiy14F4=;
	b=PCzIkNZRzc/KuUOCEZjRjskQJ1kohkLJBsE5HHEFnnNN6wDsi/38KI8XxnU//p0S773E8g
	EyQUeBp1XNsaJZUjAhyxvv3BSVJuYb6OOPjYTvXvYDTJGpz7IciwWqsuB7pi4lPj00QlTy
	uaG7IOJWSGFFRt+D7qhXuKs/0BIBXUE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=snai.pe header.s=snai.pe header.b=gMHDc7jv;
	spf=pass (imf19.hostedemail.com: domain of me@snai.pe designates 209.85.221.48 as permitted sender) smtp.mailfrom=me@snai.pe;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769708118; a=rsa-sha256;
	cv=none;
	b=BYnyqo9Rzr7qoVVbQxHsiz0Vv2oGpYbsodnNNHH53ZjH8M8+lYT6AjaB2HcsXtMDsqElZG
	vm4buuOF7bvsrDcrLsAGfykZ+o78KQl94Ykkpo+8YzdG3qoTHHLdY4lvivaT80y08eovog
	CkoRkzeU+vRVn6m2J2P1SEllZyomrJo=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4359a302794so910895f8f.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snai.pe; s=snai.pe; t=1769708116; x=1770312916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Td/1webZFtgsexoz6A4dWJ1XKLPDFkv6w3Bvpiy14F4=;
        b=gMHDc7jvk8wXQyB2Vpgg4ga8WoOEBNsaM1O1aokJsMngMgqTOPJn/BK3ScoTMo0thh
         FsUvuhhnqcWqHKkuZg16y0DbNpEvbnnlWts6VJvnNScX5rTzsKz2D0pewuUvwWoF4ZmS
         wX9EP0S/zZblU6V4mevd4JcUpv7MoPmUlmnLvHbSC/4QUiIR9RwqmR2d5MYP+MJ/qmEy
         v7BTPYxdHoWNW6pVo7dxnPSp+JAyOBxAzK6LYmCs+8TklX0Dmh9piqd8flf4CStlGxyh
         i5s822dwjzwIcmjtdUsBc9wHcpTnI2Dgi37BpUmwSqpOVxY3NS3VoJBH6EOSCksVRCW7
         +ulA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708116; x=1770312916;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Td/1webZFtgsexoz6A4dWJ1XKLPDFkv6w3Bvpiy14F4=;
        b=LsQmucezierJskNihol/w2sUoK0fUFxdLwf+h1VSIzu1I6W1x6xiuKAuTTTRr6iO4b
         uij0JL89rP0Lrpq3/p+j4VVUGwqCeg5o4lc4YVglYXwX+l68vWCgXLJpaq4ceIP3YqqK
         1oDMys9mxKcsiAkHfAC7jAeqSzyPTr8ENAn12Wvir7YztpnaGSMy/IUUvocxoS/saNAc
         lnAx4H5riTtI9Eb5xDi7reNM5nTNCso7rIsVh/EtIBG6+ZsBLHElUoDjVE2/GDPlzbsx
         qe3Hkzr0aRc9YZc86aZpp6K5xqDbDGI+8vUWMLr83CoosNfZFauTocTC/pN+0lKLVY6M
         u12w==
X-Gm-Message-State: AOJu0YwXRwSecs3dchJm4lVroWyC6CaKoQxoQSXicnkzv/IdVfEvo9dP
	GwunF9oibMKaK7eewbnlYRni1PCZVgGEZrtGsFwfmM45E+wj/TMp0O4Ik7lGFr7XFPM=
X-Gm-Gg: AZuq6aKwCUcjo32rJxA36QVV5GSmSX845ieihykdGVFveLyrPAZh9HTshNLR47MgbLd
	4K6Z0O+kRj++PpaO68PI+bsctsboJB/aWAXnhqxG5y+uTQxlBDBXVMxcqUVMtVV6W/NNULWz0CN
	D0JccDCGhSqo1Ano19YyNQpdOrc1yeMxkkkb/MLv489zIYqAvFh7PQ8gt7nak3vkxB4YaPWhYVY
	+hQAlkOkileDNQfMvUMFmS7RmEabdUHfARkW6eKQXolllOkWXaGDqYKx7rAku1cpZG/DajWAl3w
	mp3pgm4GKGPJzO69l3LJhvth65uVgpuI++l3b8WIXPVPi6QK1/EHjS0Loh6acSKyxNied7Y880U
	TfXRWNafYY+I01AwDLq7aCwJ0Fkh4qasMXZ3o9beYdltvwj3t3bAoMpf1LD5idBFIt2LYrTQqgC
	VV2UmC7hsOk6OSCPlA0v/JQ00peYgMabM7CZ3tB+NnXXEj/uXn9z1yd3LUI7BgX0aqlBRDd3PKU
	FH4MbUGTRcvBA==
X-Received: by 2002:a5d:588f:0:b0:435:a9ad:d21a with SMTP id ffacd0b85a97d-435f3aae39emr604940f8f.40.1769708116233;
        Thu, 29 Jan 2026 09:35:16 -0800 (PST)
Received: from snaipe-arista.aristanetworks.com ([81.255.216.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e131cf16sm16904163f8f.22.2026.01.29.09.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:35:15 -0800 (PST)
From: Snaipe <me@snai.pe>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [RFC PATCH 0/1] Bind-mounting memfds
Date: Thu, 29 Jan 2026 18:35:14 +0100
Message-ID: <20260129173515.1649305-1-me@snai.pe>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CFEE1A000B
X-Rspamd-Server: rspam07
X-Stat-Signature: rdncgx9eubm789czqxnqeunkfw197ctt
X-HE-Tag: 1769708117-108878
X-HE-Meta: U2FsdGVkX18Udyj0Hin9HdWWXvjR2SFmx8yrcw3ob4Hl9yiZPtBr87jp7W0KaSW4TwDJk2oPgh+phpqMeb3+5tMwUS7llJkbE/CfYq/qUjg+tqxlyYcJEysWeAAUmW7XBczyzUi5ZOomlxiFbSugKDDdKC+zAUInwHu514ryPg7u7Tant7wThVA4kCR1/QGSneW1uXbqZytgTsvOx+FTX2AztIOCvdBfaOZLl8rUoTX5GMkA8SXvq/zu8vEjBtJUC/PFJ+3L+nEs03tEyJ6qsYM3H+9fsoN6AxhjyPRHprIqYM0Mkmm/k5XJ/V/RmefVAFOgv6i7eD7UFZBzlNwLJnrHd2Kl3n9bTxax29+DdP/Yc3LzBzPEgbaWyvz88v+DOvoTfmUYH1Fky5j1BSJbK9dIJ1Xf8ADrXyzl8uBTCH7930RKbFxhu/aWbRomXgHMywz2YiRX8Pbwmhu3O/6J/+BbhqIPR4zP6898+LVJjZrFJqUqsVYvba0PYWYGU6fmIvzVm+7xu1Cb0RUhBuRy8SGbcWv0HAGlU4e2cWZJDzgAYC1z+b2dUr0QH5BwKMJP1Zon66Zm6oZxWNm+G7eLqQ+u3ZK8U+aCVpqyD73TWiS/V4gXp5gMSSftG6Eaoc3QHjycSnH5oSt6p7lwjX6bUC39XFepOGZjF+3srcS9oOkshqM7a5gy1WVDZ59weDWYBFiDWgzpWTIjC14ZdEEDlBxviHpzw5TTzZVEUKcoR+dcQCmeaYKSVcBO1qh8zzn2apyavFRt0PoUXeOEQm7hRNzdsw69I3w6oQXqUx4a8eayZmH+fr8xlK1/zZ3Nr7iwLN0P8Ib98OADrIk7vq6U9ZOdijyLo3J0tXCrQihskesRed78Njl3eI2iscGLsu4zPVIu4pY+bJAUtqbGBjuLhA8/m6iwKvnpleBHMylkuDFrlgFk3rnwoQuzfSoJEGo3RjWpqFh/ITSlGp04L+t
 VqGu93mO
 xyiWqc5qoC9JMl9l7GSNg3zgvMVKczLYalvH/3WQ1/NR5UqdSgAL2oHYyt/Mtme6xHqf9D//jebjYhIhpfIzdEzaHRW6J9V8s/wD17hb4kVK7nSBUS6q6IemGVxrTLpZyUV8HMGqB5Gg+6xPs0aIbt4bMLs/qF9EA5yoXXgNKo5RubdBzKe1PkE/3RDZwQVtNLZqkhxTcBipLApZoBLN06lImRitpvNk84s7f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000672, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Franklin \"Snaipe\" Mathieu" <me@snai.pe>

Hi folks,

I'm sending this patch that allows the use of open_tree on a memfd with
the intent of bind-mounting it.

I am unsure about the execution of this patch. shm_mnt fails the is_mounted
check, but unlike pidfs and nsfs I can't compare the dentry's d_op
against a known dentry ops global.

I opted for a simple check of path->mnt against shm_mnt but I'm not sure
it's the best approach. Please advise if there's anything better,
otherwise, the patch itself should be straigtforward enough.

Franklin "Snaipe" Mathieu (1):
  fs,ns: allow copying of shm_mnt mount trees

 fs/namespace.c | 8 ++++++++
 mm/internal.h  | 2 ++
 mm/shmem.c     | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.52.0


