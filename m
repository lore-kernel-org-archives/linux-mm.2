Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F64710F9943
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD2B6B0089; Wed,  8 Apr 2026 10:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E196B008A; Wed,  8 Apr 2026 10:54:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993A16B008C; Wed,  8 Apr 2026 10:54:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87FB16B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:54:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1513C140177
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:54:57 +0000 (UTC)
X-FDA: 84635685834.22.0916C68
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2E86616000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:54:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dm2b95Zy;
	spf=pass (imf08.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775660095; a=rsa-sha256;
	cv=none;
	b=mHl4Rvgyaofekl3rtpo2RQ5xUCBGQ9R8CoSHG4oXX8LrZyWyu6RyOk6cMXTIWkwJpWgLt5
	BKLJYte+XdpkrU2DiF/tPrtoSOMXySiDE2Z2eDfC5RoQg4D4WgwLwpjdWTZ8/VdJjjznOH
	8tUkK+d+gZJ8Sr+K3huRmlJknrS8DN8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775660095;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=baKfOAhSwE8l4WQ1pZT4bGLMLb7Y9E7/47saq2sORVE=;
	b=vQS3tg6lqBtAjCK35Qc8UqfnpbwaKgUPsv80Na9xnDQX+Y+TPHJvR+kXYvUtHqaal84C2p
	7tdNxv1Eczt+n+JN9KjIyaUXWXhP2lKyG7U5dfmxZY9AlQ5A9kBBoj23ai0EXcgBteFbO8
	Bz/bRBORlS0ONVrrxcqXboB/HN+DpOE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dm2b95Zy;
	spf=pass (imf08.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43b8e8e7432so5139810f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 07:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775660093; x=1776264893; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=baKfOAhSwE8l4WQ1pZT4bGLMLb7Y9E7/47saq2sORVE=;
        b=dm2b95ZyGmK6GyLh+CLI/IVn7L2cjWktgL8HtYlgKrdhjlNFjxOmhltFuEq8whogKF
         wwconBPQi6vIt5+0McR3xnQJKWLhtJj5B7FhmAhrlIyqMIaQZBCEnfltC3kFzO9U1PFh
         DAPI0vezRzfnuzGUNh4WzZwuvTZVcQuTBrQsQ0Tr+LaXJQnNlpLPcwSb4UPT1T4w4neG
         IuVhRkUdfKyfZXXSaC8QZz3lMgjee0Pcj9fJp6I2EZ+vNZhl90RvkdxUEb2pD5fVVf0n
         5yBPF+z7HukQj0NbtUFLL4yQ6tya5PJhRBJIkRF+CiNM1T6DIVPoDYUE1jPOqp2+L1vM
         eqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775660093; x=1776264893;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=baKfOAhSwE8l4WQ1pZT4bGLMLb7Y9E7/47saq2sORVE=;
        b=FWJ/ZVb2HWbnLk3bskRKpXnUf0chfXI8D0DdtgeHaD/w0MxYqsN8nOCpTx15zwpZFz
         4J9WgRiPiES9K4LVZN1TKla+vlB7u60wNatpkilpc7xdmiMxrTQqGjBLtuPMo1EtQ/dw
         5pj04py1dMjx0N+6mBohFkLEnL8AvDMXeZDOMRcCnyyRtEt/wyJxXt4e84dX2h79eiqU
         VlysLdyt92bi89223bronTk/XUBqfmJwBqvt5f89VUm0+WXVAyUw8fLMplrfSzKkL3wB
         Hoc6DHhqstlrgi69u3KY9No/aZz87XP5CO6BrtgtLxqNFqF3WJzuj8upl02A6yuC3zFF
         HDJA==
X-Forwarded-Encrypted: i=1; AJvYcCUuUnjGTwD2uIvwePisUgQPXFN+f83yBK9uptUZKUeMIVt5HZjzmaSN/GYr6ZylEDWTLIs8kJchlw==@kvack.org
X-Gm-Message-State: AOJu0YwPl5tyZYtfP1zL+CWAFED7MQp/qcaPY/ic+TXzTp6/n6CkHdh1
	6TV3at072692scuHd/Vh5A2muJWqZZisnoTKA14KJWJbboMsDZyYGRCg
X-Gm-Gg: AeBDiev0wyYyi2zdwONIXlQRF+4SqlwVFLVF5f3ZyhqlYjUdtsegnGLzV1xqbTqwc/h
	mL7Fwd6yrKJ+SVviyP631SsSd26ZpZur9e7NgBphYohgBopOVY0gtXUligGPIkBHYjN5OJb8Pur
	xqAfYIRFd/oBmxr72KmNsyKQkyd+Vzyj1sqlUlJbtLhSlZEG33TUO4pomzPfCVAOLQS5tc/mYQe
	z2h59idv7QpMZsNN+WQAlDjSqkRCP9xHd0K0dDt9mMGhPvyG0xyGhm6vo7oFnU6x6bVoGZpaUYk
	xw0ySSqpg9/2QvM2qLVa7X5pcPyimXvPe1IgW5MhmV5l9kuG2qQbwn+MvV6fvf9SV5hFgOBu3+/
	qTiGAhdQ5uc5l5CfbeYnp6ESwWV0twCVCk2GbbdL2Jz2irWirvGj32RIRECE5mDXMnpqsJXPnjc
	+q+G42+qaDehtQwuUD7c3AGnrP
X-Received: by 2002:a05:6000:40dd:b0:43d:71b:204b with SMTP id ffacd0b85a97d-43d292ebf2fmr33731412f8f.39.1775660093254;
        Wed, 08 Apr 2026 07:54:53 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::3006])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm55762103f8f.35.2026.04.08.07.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:54:52 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH v2 0/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Wed,  8 Apr 2026 16:54:34 +0200
Message-ID: <20260408145436.843538-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2E86616000E
X-Stat-Signature: 3yeawchfb38wmji8hnfipwx54ezjxxqs
X-HE-Tag: 1775660094-270816
X-HE-Meta: U2FsdGVkX18HwimpUVlebuHtAEN+rBso6l2XLYR/tvMeeMlg/XpaZtDWperD7t3JvGXjI7Lv2xRqv6y74d6esbxUEAzNzIJsoCPavojnyJszWTDS8H76lqeGrvH796JMRIbtdRTQcO5pKuXwGqElLB3CZEK+7OelbP28MJH++PyUL+4G3FWaKRXqoXodpydC6sjUEFCLFlhBqwOeJF+G1U37tAN6rDfgq3yTu/gfkq7X0WZ/8HQnK3zceldl7qffovL1qfV9It2cVsbA3l0JXf+TJ0y9vCUci4QnYA3ErV5dCp29AkxiHmA+JQeMQufVu2sLcCFrW1IjJolBeV82seaFoWV85m7it/VntNW1bCyKyNLOZJN4uwEdBeCTefKehqEUGcYmBiWPnZ9+FmvAgGJB9lMrmgZmM7UEqHpWfBQ7V3pXOLkT4PhdaFP9vlxJmvhf+vglUcFunZY8sl0imPPX6ebKL4Jy1Q1iTx1cboj4ETSUtuc0JV8De9fWSoPrQx4tNlbDpzfHNHp7GcqCSlu+nIKw/ouSAaILX8rRAl+KRaHFBehhZDjgwaEK0J3kZVGvgpOE5tXuL96z6AewaBHoZuqJ1iXN2da3jWTJdIMAkaGlIGqMSCp0tkjjATG7427pI5UmjteLSSTbFIVzCFAi8HWY7Ls+e/zRxmbivaW7MY8iGlWluWZNQ6SUBZjdGkEiMvYB7ikhgZoS4XEbCAzAxB5xVRxrtE4Blo7g6Gc0RfY85Hcm24VP+tYUUqldXkRrZRv/FDlgrQiOU/NTL+5KmvB8e+1iTM0fFbsKrFHx0tgQhGLKX9DJlB5RJG1/jX0C/N/kMDPR+E2Pzfi7nFBFmeS8D53kS3z3OKux+hpIDXmzf/qnausbA1YJe4kUcUkKLh+7PaJUBtnxqdczzkRjorxCLy2eJXtKvofpHe2IvBGeAIMYwdbHAgJOehVXvbFqwUuPa0ECl8smKx2
 Y5jOwA9k
 hZR1N4Ptxtp+lrplPetD//XUtC28PlEw9VkYhgPKEYf6h07HklQ91AmOSu3rCSHD6NXI+KItsqOtstGN4hem8BVlP0wkf3AEpA1qt4zQeKUEcHSAN9Lz40l3HzerK9BDTfah33kZ3Zgm/zrPr6cLhzDNTvLFj1lIiQ2x4gnY4F1jfm4cds0voAu40N1YphqhO5zjqGHbzvBcRA/MoSqFj/w09XCjlg0bxbrPujvXTqPgDhofGDPcIlib8Cw9m+ZVhRCRdgh0RWWhJItfQL+n97niQRE1FjeR+juHvEWQHGEPWV/W50+ZEfW03z3dm2D7nuIQbxEA64X/c7TQ5pgmza8pGyLNJlcmz4ImCnzSyNl64maPwGfzA/H/yZw58TC6Su40iGV7Wm5ymvWn/VAh0DMHsHq0e/4a2MSfDAbUMNu6PFwWWDp/9efFvspeN3JKewzbvLrxwQqCQQD8Fg6G3mQjLnEA7w0A3ctiWW7R7xWgVVcNM8btZ/HA+JQPVWQygGI+C+DeKIe8YxNckFeF1+3iRUT9uVS7yjuf3oVDBunVxuhCOxpdM3C+tLQjhAktsVSDbjYbXbY3OvVT9NXBUEzyFpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This adds two flags to process_vm_readv/writev:

- PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
  instead of PID.
- PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
  page fault.

v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/

Changes since v1:
- Expand commit message with use-case motivation (David Hildenbrand)
- Use unsigned long consistently for pvm_flags parameter (David Hildenbrand)
- Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenbrand)
- Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
  which is not exported to userspace, so UAPI headers using BIT() would
  break when included from userspace programs (David Hildenbrand)
- Add selftests (new patch 2/2)

Alban Crequy (2):
  mm/process_vm_access: pidfd and nowait support for
    process_vm_readv/writev
  selftests/mm: add tests for process_vm_readv flags

 MAINTAINERS                                   |   1 +
 include/uapi/linux/process_vm.h               |   9 +
 mm/process_vm_access.c                        |  24 +-
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/process_vm_readv.c | 368 ++++++++++++++++++
 5 files changed, 397 insertions(+), 6 deletions(-)
 create mode 100644 include/uapi/linux/process_vm.h
 create mode 100644 tools/testing/selftests/mm/process_vm_readv.c

-- 
2.45.0


