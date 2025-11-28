Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB86D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88B66B0062; Fri, 28 Nov 2025 12:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5EB06B007B; Fri, 28 Nov 2025 12:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 975C26B0088; Fri, 28 Nov 2025 12:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 83B7F6B0062
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:33:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D0681406CC
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:17 +0000 (UTC)
X-FDA: 84160712034.05.B05E92F
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67BF0100013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hfYrAG1O;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764351195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bnhKRi5vMG4C1RgiMTiJtyV1fNcz/ocV1c2ZiiV551w=;
	b=ln3ogDxdeH0eXygPU0ZD4+8oYrG1sp4zOMhd66JK3X6WaL0lmzRLjScMG70Hf6r6Yobq4O
	Ut0JyGn4XvsEO9gXSh715hz3Uwj1oW0FV1RHhm10virMHgM3pQtOwlfodDw7eBZo15w7fo
	8pFJHhtsAlcH87SHIcVzeenyNXZ3WuM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hfYrAG1O;
	spf=pass (imf05.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.210.46 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764351195; a=rsa-sha256;
	cv=none;
	b=YQN9K6PvT5720V3t+iv/FCP/xEVOAZHmelC7oqzDuWC5zqtztu5GWkcxhTPEaw8EWZ/20D
	slDWyr5ETqxXo0SlLXUj4+NIQpj95h4aPV6jjmTmw4Y8k5cvqlMIaeEuNdBboI9XCL/LI9
	KCjoXzOSDUdLYyJfeuGDBKF29XNgekk=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c75b829eb6so1367474a34.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764351194; x=1764955994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bnhKRi5vMG4C1RgiMTiJtyV1fNcz/ocV1c2ZiiV551w=;
        b=hfYrAG1OIhUV7wPYSUAZa+cd1BaeIF3IaaMTBGTSzxpWjXi2U30oeiK1bz4rlE5uRx
         RGH7Z+eNc3dSDuh9J0JaskUWBKNr5oktrexITFfRXeAMCK4DZM32ad+xsb4zhx4ZZ5yw
         981OPfanm0BCgaYX1pTwfGKajarUA2DIxyfz+02N5EID8bGF4QrA2aMA/h7E/ks6oCVn
         cDF1syA2i9GyxVgusLkJXv9iCO72VvScT3hABGlkf7Xiiv7BzYUzJ4tghj0cSABwQAJT
         +CAel9ZvOZzJ2x1eX7QCdiSJ36kpwwqreME8nntcC0vPZMnk6lrhX8CxSBNH5UeRjjvL
         JERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764351194; x=1764955994;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnhKRi5vMG4C1RgiMTiJtyV1fNcz/ocV1c2ZiiV551w=;
        b=fvjmut0tgxRrbpgZUJ+IAzZphCok0wRXv0v36pyBh2JMwwv8RAejDz+ydM11QvcOrj
         0hEhnTIsOeVwsTuY8a9NBvtYZkUwmMUqH+DzSSdRj/rUA8vijndrBYxMYtq1frTbSoEj
         OeDGbQi9I5i6TVfDFWAwepl3T8MfvqBSqvgj0wEmRysRGhIw3VhjNxTmQGlCOmt1z+ll
         Sf6mc62E2kpgEpnBwbQXQC3x0HK3QISvZgQHDYuq9GWYrrFbS1atEFfb5z11J8Lv7YJk
         /KUZRpBBL5Fny5jaFAocBcUlxAfJ7FaS8+cBjiYgVZBi1n8CtoWKMsSjNkE9X+HKNUsL
         J1lw==
X-Forwarded-Encrypted: i=1; AJvYcCU7gcOt8jtZzJiRa3VRr+tZkzjnG8kzPzelHqFzsMX7CUum0OKuOlVmRdqiKMThNrgr+cRviOxSEw==@kvack.org
X-Gm-Message-State: AOJu0YysOeJEsZVZTSnrwa7s3UZ4ziRwsiynT85vGF2WoDmAsCk3KGMB
	/wCeCcPS41OXAU75zId8fvWWPHUw9+GUs5XJSYlAQInbtSjHBTUKZZob
X-Gm-Gg: ASbGncs4lhurJUAHj8aDqH+CZaLhbec/l7Nvar8j31lDT4qJSTMWAMxMGyHQy9TNlC5
	HVs77CrztbThZpHMjcVRUpeB8PW7egQ0Dk0a71v9Zfob3u5P4lviIX4VeGJofggdF6TdizyhYKt
	NxbQZi12Et+R8uG/n9L6yhu+SxHawp11jgad0BOYz2+w9sXoaF7wLT8N+jDy9lSKp35uX+OuDAH
	nMeRuKnm8uhtRsGGPYHixISHua349Sn2uCqTA4Sbomt6RIczwNAtvqD/ifUBMnU+D+u7DsnEe+V
	t/2rebN1u9iLM6/YBVwt8S8xnQtLMw/8yMbW7O7gmTgALzjv8pngjYAmATJR705btCH7dj1EtKe
	PWSrZoNnipQvF2+EOc5bL5JEQ6qXxYtLRMQ5wWsBjMvKjhlJAAwkq4VSuusjQ8qkVn2ad808Ikd
	zJFiNsd3XQ2s0Ve4Uy2VKA
X-Google-Smtp-Source: AGHT+IHgo6JXZuqBgOrPoUlZEOVnNGoSuhxkJ8mlwl9YdfKcqMScPAGktu5T4z48tJi4/rELbGs3yg==
X-Received: by 2002:a05:6830:8284:b0:7c6:8bfe:f5e with SMTP id 46e09a7af769-7c79909e0ebmr16700750a34.32.1764351194162;
        Fri, 28 Nov 2025 09:33:14 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c90fe0f65bsm1769459a34.24.2025.11.28.09.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:33:13 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 0/2] mm: only mark/clear KHO scratch memory when needed
Date: Fri, 28 Nov 2025 17:29:32 +0000
Message-ID: <20251128173257.969322-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67BF0100013
X-Stat-Signature: 71xa7j1xgntyz68qgcsfcmyxuj6kppof
X-Rspam-User: 
X-HE-Tag: 1764351195-215380
X-HE-Meta: U2FsdGVkX1+SQVyHikWikgKSh4SvkXgDaFdv3y99rQIXV58AGoExChLEN1Av/WbFohhmAUMVLItYgMckpK4a22oSBAYV+tZt4KHmE2LXWZSyMdZ5EF3qV8X75twngXaozz5uzOP7XTyAIsYcAOwoRSAgfy9OVjrdmLMONYlZLwL21aFaFMq6Oi3DyogzW8W7Fc1fWtsol0aF9jKkj6h6Yhk8TThWvXB78Cku5km1f0rrPUrEI7I0AmbrZrwERq0dxtlPdHHG/jXfshmks9eKjKyPEpMHhbMSVQxBLuLOn2coo1EHo0MtD3pCMhXYCkctKxof/RZBA+MkF7IGYTaujCsmuik1JhFG5PR71+Beoy3d5E/A6gr3AgyNE3fE5DbgQf24dE2Z9vrnXnY/kFoSEroA8AbKwvUOEhWxym7J92NoAi68S9I48/AL+3MxTRZUHOf+4/kP3xTrZBiqEtrNf2hr8p53pPJLaJvZrd3i1PQh1gDPdN20IOX04g/RGL7vDe+RjOB234GL9Jtq7M7ESj1+EicPiym/tJAZXcxusYQrCjExxzsqKP1JYvyzOim1g6yT7P31Zv7s0hQK1S/3hiZ0tvnjEk5Bh3+ylmkz86+jhCaC5lFq+5TS2jcBcaXDr6VjZCeCewdHMlz7QyxjMyN40d5HlFr2w5PwpzTFCjXH6gnaplNFOHHXfs1CAEue9vuCxgiOEtnWTzWCcUUpKYrCGk9XOEf0RQmx+x1+S8WJBae6yXDN5EAhVKFecodn5stRBxhkBFy1h9Bs28dw517yY2jUyfAdt6lj+X0Fg0hYBedqo5Ttj2A4qB+vnK4EMXWyljf7FHnUu/tnNqES04JPlsj0qQqWDHhgcBzQr76/T+O5YuYImzZFyMWiQf5He0xF6olJNl1w5aPaLGl8v7EF8W/DgW6LcK04vflyi13+0gU22Ef+XSmyOWZ7WvqUXAoYIcgtG3G89YZ2li1
 vkOXAqZL
 sXkkAuuQwjlmrKhQKrpzl5BkgwxdaIZgU+gezThTFIrRvLDX6ZjeOYRJxvu8zt7bMLXsbu/bPt88tzlfkIAvxovATYIscsJ8T+TKMEofDxmpa6yQoZioxDwV8Qx5Y6lM177ORo4Ac0FWRnGkUjOxtGETHK6oOQG20Gq8/lVZhjqSBoG6rpJ4yCloy3FFh2cBYDjWG4KB5YG7d9azlrnISAbxIl7pRQ0lCiVHJT67KtqsxmBYaYMIN4Zt1PKrSXuUDABr7/HHqOmF639rY81vfGLnuULTvffCQ95/4aV9oDVPLBxLmPgkquS7JIr0xBuw3iqJUo9/TsmEWZFXi0tlNs7fvPz/cmyfyTZLPtAoJs3vK1a52FCP84oc+dNKjJJOG/eHV8GPE+NpFli6nw5uQdnYd3RpCy47wxLVGwJr8bllpvYkc/SrfQ9d2kp1DFKC/7bDR+UjNJn7RGIqDuvo3zJ2A7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000257, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch memory for kexec handover is used to bootstrap the
kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
hack to get around limitations with KHO. It is only needed when
CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
(both checked by is_kho_boot). Add check to prevent marking a KHO
scratch region unless needed.

CONFIG_MEMBLOCK_KHO_SCRATCH is also removed as its only selected
by KEXEC_HANDOVER.

v2 -> v3:
- is_kho_boot already has stubs when CONFIG_KEXEC_HANDOVER=n,
  no need to move the functions under CONFIG_KEXEC_HANDOVER (Pratyush
  Yadav)
- Commit messsage improvements

v1 -> v2:
- Remove CONFIG_MEMBLOCK_KHO_SCRATCH (Kiryl Shutsemau)
- Move memblock_mark/clear_kho_scratch under alread existing
  CONFIG_KEXEC_HANDOVER in memblock.c.


Usama Arif (2):
  mm/memblock: remove CONFIG_MEMBLOCK_KHO_SCRATCH option
  mm/memblock: only mark/clear KHO scratch memory when needed

 include/linux/memblock.h |  2 +-
 kernel/Kconfig.kexec     |  1 -
 mm/Kconfig               |  4 ----
 mm/memblock.c            | 18 +++++++++++-------
 4 files changed, 12 insertions(+), 13 deletions(-)

-- 
2.47.3


