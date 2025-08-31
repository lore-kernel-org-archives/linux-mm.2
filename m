Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C37CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0268E000A; Sun, 31 Aug 2025 05:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3270F8E0001; Sun, 31 Aug 2025 05:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9908E000A; Sun, 31 Aug 2025 05:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEDEC8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1B761DDB16
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:43 +0000 (UTC)
X-FDA: 83836555446.16.F70B323
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD868100006
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZAGWPpAZ;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dI2up82+VzPNoEGOK0KS5pECnWl2zWb60qbdyWAfei0=;
	b=jxnMT1MisIjuP7uzqcCOhK9LELxe/J0yr41gSlZ4+T+roMEqNhjVpvlNPKGU3dTZI5e/G/
	aNULn+C1i1odePMVb2FaQxFB44nH2dDSgym0AhWO2XZOz2X4Mq4Sig81RjC0x0S/fDjLy7
	fBz0nfbT85yBJ0nE7zhPvO0u6luRDZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633181; a=rsa-sha256;
	cv=none;
	b=5Gg8SqOs2qIUzuaT4RAU+RHWr3SgRpmMo7JG6Bl7qFgIJXUYTN3KZJBXEYclmaWSTLXvnA
	kSpeStPxbTYrSPpFp58NhOOPdLGqQoWHfUmJz+Xjrv7tK8AFxKZdpRk8fs+LzM+wKuFTWy
	hZebyXJiuzyBnDDgAKBXJ6bQvTEBCA4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=ZAGWPpAZ;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afcb7a8dd3dso480771566b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633180; x=1757237980; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dI2up82+VzPNoEGOK0KS5pECnWl2zWb60qbdyWAfei0=;
        b=ZAGWPpAZdaYBOwYU2BPzkjZGbh4w7GQI8A7OKV8vXY/EOBC6s25xyTKZCCTdzSo8hu
         zYZpPfpVXB/247EWVhZq+ZPsVC68eB3AZgV/aGWys1b+SLT8RbCaXBlyXyYpw4sv1UbQ
         Qtcgb4LVPOwLpaDh3l7ZpmfL7QnnnrgVAyvONDnjIYdfwCLal5nXlsBYzA6BFllHYBuE
         aKR0pAAhLtPhH/ila2TNbTkeSy2SeYAIOlgXzTrNpRN2v/4tqUzhcbuL7KJI3gNH8hrs
         +L1PihYogA8VUkITEEG2EyMuUxCg83QKbUd051ab2WweZCMZ855IxV9ReUaFIp9p3XYN
         1F2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633180; x=1757237980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dI2up82+VzPNoEGOK0KS5pECnWl2zWb60qbdyWAfei0=;
        b=jtZfrCDlZNLnkzur54ApclpVtmgZoZByC2iAuBzg5jT3F73L8k7egCKlRaLljfePzU
         XcPThPyzFHweJNo34CytSsjOxasp5aRG2AKs1Ksl181VKoHJkOSwuMhOMwXWpDRmhKod
         8uUgvONdK5LzWoQDhxjCwuis34L6BQ8FX6ch7DhaKf91Vj5SpoqtTPiofb9fNKXcWK2Q
         tqBdhcM8v3z/s3eu4ee467KDQ9SVJZ9i3BQgWJVVwUEgGtbDo7E447+LlYlZETQSe1Cl
         FbWoRj9HtuuYHu+l+SU58OkDTzDIHkxBqnlXWkT3W1aNRZYg3zHwpnILBwtxoijO5r3s
         x45A==
X-Forwarded-Encrypted: i=1; AJvYcCWo57SPqhsX47CoYglpgmOrUEGSAnYVpLC9oqQzu7KbrJ13gG5PdZNMfAX1ctvXgAkzh/RiPBoj2A==@kvack.org
X-Gm-Message-State: AOJu0YzZALbaYXNJ2vNyjLP+QOHE9oqP7gdCkLd/it4j2c6kYIMrrHdZ
	QdWJ/5HQgBU3ls+w8eu/Rh1aNvyV5us7E1X162STZSxnpnKer6TJoIHYfCjzXg2yqvg=
X-Gm-Gg: ASbGncuZ9VISOxR7g3bA9dN3wn2pefMnj4wYXowKjW9Goh7TrtBk2L3vY2WMyjnCq8V
	3RY0fJEvgUnXuJvgbJBPAkhwmxx6BaeTce0ruToVr6kUbyhO7uhu5UDx+mVQfMF6r0YCkeq0XCi
	wKogAQxxc2am2HjCPqvKhAnaqYr8X/20PcNixzKe7kQl2WHveY+gWB0m9Mebg0iCgg0abPdbnFV
	Dw8idMdG3tXu3YEZo0TJLckS95Ko2vzlNiVvbTbhnwR8rmllHnOCnSlzX7HW6SX4EPB2p3D3RVB
	P8B33mX4FdjYA6FFdJKMRmKhDxW2HqkcPZRVSX8gJgNk1Pdp3roaktrB1vSKlMKNlAHQDKGAqQ1
	9bVsBE+3HiuFS/QvWNd6rFRC6jUY693J4q/VATDW6jUelSZV5MdgvODBddfXQxM5N8bq05GmBAO
	CGBcUYt0TO7+eUs9ZpT8Etng==
X-Google-Smtp-Source: AGHT+IFglY590tDBZGAnHSO9yYGk6iJO/gJRHJ6p8/Jsd/CDqMqAkjlpLSX7631ptCWtGbwIvRvDjw==
X-Received: by 2002:a17:907:1c91:b0:afe:c459:e663 with SMTP id a640c23a62f3a-b01d8c74aacmr415085966b.21.1756633180414;
        Sun, 31 Aug 2025 02:39:40 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:40 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 05/12] mm/oom_kill: add `const` to pointer parameter
Date: Sun, 31 Aug 2025 11:39:11 +0200
Message-ID: <20250831093918.2815332-6-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CD868100006
X-Stat-Signature: 6xu79zrpqqzsmb3dekd5jc675cp8ysr1
X-Rspam-User: 
X-HE-Tag: 1756633181-716639
X-HE-Meta: U2FsdGVkX19llHmLqfBg9UvhTYPC5gd2oZAv/kWmVIe08cv1/6G4hYlJdw4s3ITMpfq9I3SkqjjFIStWurKVk31KZdXGWpmoLEDAVNZJGcESGknr/AwWliVRuzyMNq5F6H1h3pzksBSb536l15BRBWtDeSug9H2aNVc3VgUipvSq7HOhmAdHIuSyFipv9qQ0z82MndVfmBzvuzmIv1JGpW949v1ObqlqIAQ6k3M1z/RaJuZnUL8gZ5Kvdc5Mb9itRA6+EAVSiy40gRDBmhzuIOARyZUuuVEeAL7Sk+qzG9xJm8lRF/6JLO8uxFYM9FBsNfLv09/tmB4Iuip44kITaCWnKVVegUOUp1A2OvgaajBae+fB9tnFb31RraAYXFU4ndMEyi7xtA77c/ccmU1lNJa+ASukUeNuYhD6ZWA9rIJ36wtBcntc/r+L/ftZXY3A15HU2MdBJXuyGh54K/WWOveerIfZUCbIpg+0zxECf184fQ3CGLXueAUQbKG5Ij+Q9n6awOH0OobzQSx7PvdzfHNtBcrNhO22B27eTIOsy0MoblQBdYTgjc9phSZMhzYpHkxv8KRQOh5Ug2NYuumpvWVvmYndkSFsUSCgPmnqm+WYKlGMTshXmOlv5zpENjeCqoRwB1OVmgdFPdEhFDnqK1azBRc4WSYqWHI4qExQ5y5PSMvhUAGabgGoAX32N9wGYr0ZDrygq9ycDL/uPk6yAEWuiCXZ9BBehM2kTXk16k/zODPFTCEVLbIEvziPjtv8o6jt9ncmlAO+nw6lqMT1zpXX68wZxGaFPrjzJZnuU8e0WuO9i1psblrgWibMDiaOgQeMtkkyJO+EHdd+nlTnl0UVAUQM4Ev/6sk78guHm/bqpCUFDyf4tA8YjS+tV1YjU+bZLoVbgg4zED0ta8bWtS/6gfqzGfdTYoD1B1Ugk8mpymANLiE2g0UIHZof8NL91+bM9Y/YGbGJnS86ezJ
 ujTWL5UG
 IBoM4m5+C2K2yUD0kjA2K/HtThSx6EI0tNiUdJGvBTgtYjJZmWLA6mLcGcfDoDmy6pTg0Mj0WlgOEM48S5sOVdevvSb1pMopQN/+5NkV41KuzdDRbw5rxMBrQGvWduXjc/Bmr9KYWnZg2CD97cUCg1FmmLgJrWnTUvZf1gmFEnSxsT9HcxP70nkyVA/uv5LwpPFTYJ+9x9s9CopRC9jR6PTNBp3AbSLF443M2YQ7jsMDf9LV2UBk9HCI3uq4sXk2KFooi4X+3oZXzh720dnDDz/yCoP2/v6U84WZwUXPetyRxDlKgTF+HcNHSeRsSgTwWFJAKuM4hMAkFuyRAR3vEbpxFCCLaAwOgl+ar2I3jOGCGOMXtZlrff03BiL7LCmrz3zjme7q8d4eBS70mWOR8cjdjx5PPW8G1vqeLXmGrS9W6QRG6PZ1JUuZHVorgmT75JgKg6fpC0UW2MP4qZM/23jQJBewYhAwwsQ75LsbloISdhHw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 2 +-
 mm/oom_kill.c      | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a40a3c42c904..1c18b89c2d28 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3840,7 +3840,7 @@ static inline int in_gate_area(struct mm_struct *mm, unsigned long addr)
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
-extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+bool process_shares_mm(const struct task_struct *p, const struct mm_struct *mm);
 
 void drop_slab(void);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..2620b32a8eba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -490,7 +490,8 @@ static bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(const struct task_struct *const p,
+		       const struct mm_struct *const mm)
 {
 	struct task_struct *t;
 
-- 
2.47.2


