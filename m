Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05292E85372
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7336B0089; Fri,  3 Apr 2026 10:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6FD6B008A; Fri,  3 Apr 2026 10:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F686B008C; Fri,  3 Apr 2026 10:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 474B06B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:13:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D90288C1C6
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:15 +0000 (UTC)
X-FDA: 84617436750.15.B000E0B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9937C1C0004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:13:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLTvtaiS;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zCsOheHk8XlC9CSFSmzc3izuiVKcS+6jE7o78F0/vE0=;
	b=J0UZC3WhRQ7wL5CPfrhLFQQ38XY8DKfT3oZzc5hp5unJuwyku69OLcNYbOMd5oBNnw81oK
	xjMVGAWlPaxUQmpRxCudSSrl4UTkJvSfokyT6zPxOvWWr77jdVNrZqs3d8ydih7EtatyEH
	dgTZOTubcoxj6bMo1H6/cOjuxT64VxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225593; a=rsa-sha256;
	cv=none;
	b=4wL5HvB2ZAMcni9IZVxjqPovRGhlmc4n5E+pzRWLTflwFfoCcPyFNQGONdCO7te7J0GRqs
	/NfCyKh6K/n6JmCVcDMdiNAgYRjketiMP0+iZyeeVWXTkvzQKGtsAUSfSu3x0hcWlq8fcF
	9Zhujb4S2YoomwH1HCSf8YcIfsPcPT4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FLTvtaiS;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775225593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zCsOheHk8XlC9CSFSmzc3izuiVKcS+6jE7o78F0/vE0=;
	b=FLTvtaiSWxQviBvxU4h7/A+XbG3am7WWlQ2wB8YCHyn0ClAEPCQJiSUrj17HebJrE994mN
	MVgSQo+1wfZ87acCzH6H5WqYi+C/ZyaRqFaJrt5SEiCVGDvyKidPVbDqttZYp8ozVMknBl
	3P03nWtE9B90+xBCTBBglUItlOuFaOI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-JDXRzgMIPlug_z9UOfECuA-1; Fri, 03 Apr 2026 10:13:11 -0400
X-MC-Unique: JDXRzgMIPlug_z9UOfECuA-1
X-Mimecast-MFC-AGG-ID: JDXRzgMIPlug_z9UOfECuA_1775225591
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8d3e4c19307so278700085a.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 07:13:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775225591; x=1775830391;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zCsOheHk8XlC9CSFSmzc3izuiVKcS+6jE7o78F0/vE0=;
        b=BLsqzMdJxRBM6nyR7PTe9hOS0G2aafhOuQIuNPYMTOS/s7qsmuZpMX06XoUdG0Ciyh
         SyIA2tk4vWI0UsSToWdxg4HTvcDT1igYGoOedn+HYfAhRMt98v9LvU3Q6UjJY6KMrROk
         wSHKakeTekpnEbDYFSyoroNoQGbnQzBBRlsf1kQiDr+m91iJlDDG5XA5PMm6KxJw/OLb
         R5Uyl7Rj+4l9xRz73vB7UiJdItYmlzQFuxLuVWzy+WgXi9c9hF0XasuwUBTB3FgGAHxn
         x6fCptUI41Kdf5Z+Z2D+5Ii252zVqy1RANzwQuZ1c5V72DfCAuK1y5cA4YFdypWWShcG
         xtKw==
X-Forwarded-Encrypted: i=1; AJvYcCW5mRXJmCUmOmPnI+fele3TruoPdX6c2ZSi4v9W0cves1EjsaG/gk7zqRHZr+JicPFAMnfWOxkTNA==@kvack.org
X-Gm-Message-State: AOJu0YwSv4mhT81OOrODs7lKmavCEoyG5YKPmlpg0g1rlP1nbmAd89Cz
	SiY4u7VK02aFQxjxnJ4TVJsDKCgYbVWoEpZThCJRSyXjHBbk09vU7ulH2OulE/ZMu60OptPT0wX
	4up+KcWFantfPxzL6bzPuUTxfVEKQNXnN0GJXeRI0AG2tsmGyQKSh
X-Gm-Gg: ATEYQzwIdQ0NtF//cNe9ZvYDt7RZ5treDvw3E4oU2G5I9Kk5s8qsI3u4X9xGAB2yEt8
	4z+UpvbAVsbRwvrK8AoggxyTX1rDGvKODsXkzdKgrN/u32R7Xlr4CXszCxETCPPaUt7wT+AYA16
	6XA9QcjOwh8JIKQMvuZnNH8sFcNlBQ6ng4rCHbF04Rihy3yZN+mkGaj9fBU6RCI9vDH0i9wDUJ9
	hCyPRZiJoOKF2+x0dBjVsC1wvjNTTqKEYfaxRUnsqvKWjRsyW9QAv2NiRMM+MOOUSsB4YXlJsDt
	iRhatns58WdzBEnJ2LPcjgwv7FBcNycspzZ7+r+Ww4QBBo9eadodl77d3v5ODTxVsjxf8Dxx23F
	+PUoSabmJKu/+1rKjhCIc2Jnn5LN+EKSKKJqBXoNnKv1RQWu0yOjzdL4Mzbf0cAA=
X-Received: by 2002:a05:620a:470d:b0:8d0:176:58bf with SMTP id af79cd13be357-8d41ec0d06emr460637685a.63.1775225590897;
        Fri, 03 Apr 2026 07:13:10 -0700 (PDT)
X-Received: by 2002:a05:620a:470d:b0:8d0:176:58bf with SMTP id af79cd13be357-8d41ec0d06emr460628785a.63.1775225590198;
        Fri, 03 Apr 2026 07:13:10 -0700 (PDT)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d5336aa9f0sm21287085a.28.2026.04.03.07.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 07:13:09 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Subject: [PATCH RFC 0/2] cgroup/mem: add a node to double charge in memcg
Date: Fri, 03 Apr 2026 10:08:34 -0400
Message-Id: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYyNz3eT0ovzSAt2U3NRcXSBOTtdNyS9NyknVBSovAio3SDM0MEi0TEt
 LSjNSAppSUJSallkBtiFaKcjNWSm2thYATWgic3YAAAA=
X-Change-ID: 20260327-cgroup-dmem-memcg-double-charge-0f100a9ffbf2
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2t97aGZZlZ_iPLl3j1Sh6ChL_742KvDSKSI1WZ1yGY0_1775225591
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 397bab69bu6w7jxfzkfs6gnckztfbe4m
X-Rspamd-Queue-Id: 9937C1C0004
X-Rspam-User: 
X-HE-Tag: 1775225593-919707
X-HE-Meta: U2FsdGVkX1/F/ire6KMcUZ5AcFDeyrCxlFJVT1KD1iyBgjuAGiXVQITA1GUE9KzMM3BUix6QrOVUcJKwELIdjzKjDpKuqZIpdJ1u8X27fmGR7rgfwEgf8xTEKcZDdHcmSxGaabk8tRN+rGC+vYqPMADkxDUaowBTxe/MCyuVzj3xTViBw0BSEXar37R1wltwZ7DG+x1cYDDHu0HCaROgeaUJziT3rZEFT0smv7KJn+160jxVttOEznP+xBs8VP7hCErul8MEAY1r5eoN1umyD77y8c2FMOGQX9R7x0hc/DGOwjCC0gWQmIP17yvIIuCwjy3uoYFk4N4Wf/ypy6p2RBedd/P1DI7h6MSxych14kTyQPu+GEN8DOI2s+MUgxVDphUdvI6dZvHwfKCCUJ1/5ruUCGGmV+xmgwyhBUyXVrN9OWzzIUu0jnDrrJGkw8B53a6nbkpSHsXT1Vgkjw0lHKIPjvGhz61EtnbbiocHNb9gLPszhURuaZyrghzmd/78ae5jpmQL7PdDpUDoyPWKPjKInJ1xm616hIgZTij5DXfAYXKx3k4UZ0WWCIhuagJ2/miULYUbBll7ND5+etvU3LPR+ByeNQUTN2nzjFRlAslWgHZyEg30ZAKm/FUzLlPqxvbh68vCrlJ4csjDCeZmzS3bmkXEUYNODfUoZHtqE61ZmaMKEsA+qbZ9RL3tXSbdwOcuz4trNUGXrYPACOiha3X2OVTgyd+cnyg1guC+PBhcQhsnXOPu04+u6AVl585HPNUks6rNoF8TCY/Uykvm7fxB+pI4qtWG8wvPjE5pGlPesPzA0t5MZzDDI2jNZ5HZJ/dZ8i7LiHKq9ow8ZUAUZhHx3nsp0wPjmybRSkObXoK4ICepnV0oFfh9kz9RXu6QoUD2TlcI/J9Mbji7lh2bdGhEEePn8JzmQ1/NuUA1TLnylAfEflVCuNcXfL0CnXkHzQb+kQSEu+GUA4orPK1
 DUjUBb99
 vnIXtL0w+gjmU3PKMvmF7jzmhzH6BI2LmthF4odDT/1FzXt5Hg6LkYv4w02C9ivSQRKc3RcFYVVyL94kAFL7LA1RJYqcCkO+dnaH0vtRb9GkDnwRMKi7unaoyOm3G4T2j14Uqjkbgdd8NJ1U/ayIALB8Weaka2RK6EiPb8jvkwUdT23F2BKfcO6P61SybAS9vYu7cGL9D5d/ndI91ZH9Kn6faIXF150vCbJMUYYVlE5qssCanhelVwzWbmouCC/u7fcOI8xIUxT3vPO8NjRltxbrOckSsYlthb9gAh/pHvv12QItZ3Zi5cuquqWonI163fmiAUKnDg+tgXE5+JKrtIbpTfujR+Q/lJubGUGrgLIa8oRmFF9XxPeHPQm2Hg8h4rkP4kKf53JRlu0VFsPblk9IR+bU+0OvnxblbhwCgGGow3ygdaX0cxFywudnTHOdmN/UInNRCVwmnbbR+6SL3VrvhAwSbTxzfb7b7axlSJnwqMeYlmwTUHMtuSZvPxymyKDfL8wkMNbHz0l1QILo8z682hsWY2CuHUTmt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was suggested previously[1] to introduce a knob for dmem region to
double charge dmem and memcg at the will of the administrator.

This RFC tries do that in the dmem controller through the cgroupfs
interface already available and walk through the problems that creates.

[1] https://lore.kernel.org/all/a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com/

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
Eric Chanudet (2):
      mm/memcontrol: add page-level charge/uncharge functions
      cgroup/dmem: add a node to double charge in memcg

 include/linux/memcontrol.h |  4 +++
 kernel/cgroup/dmem.c       | 86 ++++++++++++++++++++++++++++++++++++++++++++--
 mm/memcontrol.c            | 24 +++++++++++++
 3 files changed, 111 insertions(+), 3 deletions(-)
---
base-commit: 4b9c36c83b34f710da9573291404f6a2246251c1
change-id: 20260327-cgroup-dmem-memcg-double-charge-0f100a9ffbf2

Best regards,
-- 
Eric Chanudet <echanude@redhat.com>


