Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FECFFD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FE76B0088; Wed, 25 Feb 2026 17:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FDA66B0089; Wed, 25 Feb 2026 17:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF096B008A; Wed, 25 Feb 2026 17:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5856B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:02:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29AF01607AA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:02:31 +0000 (UTC)
X-FDA: 84484353702.21.A4DB1C2
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 62C0B40009
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:02:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VkGc+B1E;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772056949; a=rsa-sha256;
	cv=none;
	b=wKSlJogm72bGriHDWzwUgaoTDZisnlmlx201/TYm1udIdAdfax3NexRatdS0Xe49ZDvkOq
	mjB7X/PKKar+034MI34DeybmPCpnHv05OHCQbHCRumqAiQiKcTJ6EeDoeD8UTHkQryw5cM
	l+O50JIcd7ZE0jm+siHn80b1BTXwEYE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VkGc+B1E;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772056949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
	b=YBjlOYS+V9ZslCuQ4qZX3n2a0HAa50HpGD6Dk9E7HC1QRQWKpoVhv+2WOHoZB6WHpylKGW
	8t1S+tiC9MMer52RCt2DWFnblVSrMYpdiO+z3i/u6yOpEe15IjHYyyHZ6m1Mw5U8q96dMu
	cdM6yd9Rl/L363LK/l0PM27SIYXY5sA=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7986e538decso960777b3.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1772056948; x=1772661748; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
        b=VkGc+B1E3P2VLYq1+9SqFxJDUnXj8A2o6PTy3ZEOJ7uVCLOSD52PQPBlaRnfn0oocl
         hd2VbTCMEW2LIVG5Qop+fyBi+L2XzAVYA9ADvMzFfHe8pH2VDthYPdDXYm4EwXgOndk/
         v3MHp38FqCW9D3DBi/sYf9AWycnoaaCmiq25cOQC2nT+VRG3PTIEVV6Egtctn7wt2UVW
         WA4hgS3dXvtZNNcptGJbeCCQHXr7gvyY/5vfuzvAkoJUijXoMW7jM/YVvURmNVkgcJL0
         c9nzVdZ6Z15Q6gdI9/hqfXJHxF4+xl8sHkfx8ekzkQVOFamVTVo4DWgA5sUS7IabQvH/
         LgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772056948; x=1772661748;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
        b=mJ5F695Wl9l1kAtlXB+TzuAsTwceJIz/fOkTGUxaJnOw77Hox1aUa+P2dDmBJqND1X
         JbRnJfXMdjlOmzykg4bxKhPAiKoI2KMq8NPAAahIX8ajCF/r6neqGUV1QYQi1aldsZeR
         70uwfccdg4QaPLsZs8UDaHBiSWjgAvXqDUzesnJ+5SmS6+PJyTRIru0RnQ8yXtGhuxjy
         xMozrcmhS+hxsp711O49m7dfj0pe8rj8dts0I1xChRkDzK1NqkLGa3P3EYlMgbbAm8Ds
         rkh/pGlpJbyoYAepMmgDAyyBhldsVHRD9hqwMxbXE7D3UIWbNxawtm225INcTa7HyotD
         q0TQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGB5RPxFL11g/WsaN4kCjD7wL2qwwEMw35gkzKG94iOmi4P9JyQc6stgSs3sOFDc/SvekILJiVRg==@kvack.org
X-Gm-Message-State: AOJu0Yxn40A9gKF2G5wCCL5Wf/kiUA3LA+ELjRpomaquUYEKrxzzhrns
	8vhU2134zkjY1aCZ2faOHZ+jVpOONMOxcYTEIhSgqmXAWzuL9S3KT1C2cJQ+FL8vpHU=
X-Gm-Gg: ATEYQzxE0qOsTIGBjszEFKFTEjb7gjzwWv6C5YAKL21waybG+cEMvO8MHYRBCx4u9GB
	i27OZz7FMXHr8jpTIDC+wDk36tChHDQYs6PzQAj8YVXylTHPb9R/uLgcRGzMh9kX50BSBo2DcL2
	28Bzkp9XqFploqhoWrChOsX89san8OcfYVqcs9CjBKXBdpGEAvfef1Mr6RhwE2HfKrZzPlFacU8
	QPuYf8bZr7H1a0okpipP0JWhEVkxPHuaksHwo7LF6YgAUVV7x35iix/lKn0Jpctu9w3uUsnLPb/
	oYoE7K3LMHhR2QE6Txrm7GFi6CjOGElw0qQaGlvl9q8zsSa1zmbyfeLpNEM11X6kpPcNcoCm+K4
	7+thkLplwc4+hDxeLFlj5Xr8JmBkEzxFHVx01xabnJXEK87OUsOHu8lAnkIOn6IoayFaZd9B3aq
	eAXDwubg46+4mGAiZbnOOFMRtbqDVWiWxyG/Y+E3/wCdFWpPFySUwyFiABIHxsyG6d55IymYCXk
	KobG3OPD0TfF2rDEapu5TJXLL6hr75zwGC1iN1pJ+yzGEZXow==
X-Received: by 2002:a05:690c:60c2:b0:794:e839:ad76 with SMTP id 00721157ae682-7986ff8a362mr18639447b3.44.1772056948232;
        Wed, 25 Feb 2026 14:02:28 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876af20ebsm703617b3.22.2026.02.25.14.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:02:27 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	urezki@gmail.com
Subject: [PATCH v1 0/2] Fix KASAN support for KHO restored vmalloc regions
Date: Wed, 25 Feb 2026 17:02:21 -0500
Message-ID: <20260225220223.1695350-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7xphmw1s8eg45w9op348duetkssuokyr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62C0B40009
X-HE-Tag: 1772056949-162871
X-HE-Meta: U2FsdGVkX19379PqB3klUaYSFvlB5S9tSmYd0cm5hTjYMAzvv6dGTCGPGA1gOW3paE3+/y8MMdOlGmTY3Zu8e5G6xwXoPqRLIKi9g2Njk0ati8oe+QycHA5qbKU7tmWazHAAj7TtxRMGncnn/5sdKetgqTdPAhjd2ZzbFmr9OFO4FMXamwT4GhHH891ZH1XvhAaJAKP4ye3RO51HQvthghgbioMpgbe+dwEoqySr8BRjadb559l3PdiU4R84lortN0DvtKYXP+Vvb5qNlH1LJrVa485T7klKrPDRdrGlngy00mbJA5qga6hOrtBzSeZAN2vyn7pGPsXrFgm35fr+LE48951tu3uEKFVbt3h09cgUrEAtg4fSmPpE6rXrErZphHJKH+Kdww46GlC46FvfgjMW40hfz70TFNOEy4RE2qwjKhVV0V3s2/3bcmJAj67j/dvvnsleFQZN8MeNCNTJjVffwVZKcvfsWmYVBh3RoIQCrL9GAa3XLhkeJYdV2pZlX9LX7lMlVjmKHeHo9siynBpYenBBtBkvhoaFJ3bMxAIvEFc/58MJbkn7lA8TWs+nX8UKc77q5zy2tg2RbrUgnOGrSDjuQ9F09HScCuv7j+YGIy5QjKINDKmCHaZXQhfFdXZmVnjQR451xgjcDewJu57cjBC0Vf8U4GGCWCrWo5omrf/ZGCvALpzVQCSexQQQ74FnxIIeB6PvaUaF7jWbrucz7mR3nhyqzwNJv8jJJvzuIYhxXVg9nHrOXtdK9ly75Swqu2u07D9Ci/pu8DoDGG28qNKGUURKG7WqBZqAkQ7LT8aPVPntYoqeDxlzqQ9F9G0XsmKOFpeNG5dWyj5KiDEx0hxfSGfYU0PlIVAJZDUKTtwU1X3mG0lig50+O7i3fVS0VBKdDbxpE9v9NQNiPx2K4fl/Lrv82SBQ8KId2pi3WvFm6Jb5WmpAZAi9ZFS5U3XnCgELaRD5MrhUU+7
 aIUc1Jqa
 JEIMk41viu1qncnU+Z4Z1zGUzZbAHA2MuAn7Bn+LIbKNkL9tam33w1KszlH60FnInR/kGMZKPHzCM5GcA8GO1npLB1IgBWD6h75/Fr8Hn1Tq2eEPFRj5aGqeSqaeXH6GFsw5SqRj/+/db8Ol461HU8erbs62qAo0bJGIXaJdwsuOYnp+x2EoKkX93lhxGGsSSFgCUkZIL8+atCgGDBSUdRg8jAhU3X67hDZRpGZdj6q6hqemWud0HBzkAMtrsqm8aK/Zqmx8XkpEaZjBtRbcmxxIMPpMjC3+kNB2V3kPhFoPSu+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KHO restores a vmalloc area, it maps existing physical pages into a
newly allocated virtual memory area. However, because these areas were not
properly unpoisoned, KASAN would treat any access to the restored region
as out-of-bounds, as seen in the following trace:

BUG: KASAN: vmalloc-out-of-bounds in kho_test_restore_data.isra.0+0x17b/0x2cd
Read of size 8 at addr ffffc90000025000 by task swapper/0/1
[...]
Call Trace:
[...]
kasan_report+0xe8/0x120
kho_test_restore_data.isra.0+0x17b/0x2cd
kho_test_init+0x15a/0x1f0
do_one_initcall+0xd5/0x4b0

The fix involves deferring KASAN's default poisoning by using the
VM_UNINITIALIZED flag during allocation, manually unpoisoning the
memory once it is correctly mapped, and then clearing the uninitialized
flag using a newly exported helper.

Pasha Tatashin (2):
  mm/vmalloc: export clear_vm_uninitialized_flag()
  kho: fix KASAN support for restored vmalloc regions

 kernel/liveupdate/kexec_handover.c | 12 +++++++++++-
 mm/internal.h                      |  2 ++
 mm/vmalloc.c                       |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.53.0.414.gf7e9f6c205-goog


