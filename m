Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C03CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8FF6B008C; Tue, 19 May 2026 12:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280CB6B0092; Tue, 19 May 2026 12:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F8F6B0095; Tue, 19 May 2026 12:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 063546B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:01:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B42CC1613
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:01:20 +0000 (UTC)
X-FDA: 84784633920.12.6844EB2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 13590140018
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:01:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X9En0bXp;
	spf=pass (imf23.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T6OjxI0zZxwDX8SXPRnZD+crOhWj/eJOyVt4Fi52IP8=;
	b=5qokWho+YFZHBvZrHVKqyurA1ZT7qsQnyQWGPlqXzUvPkRMEgXW+1iIFDdQtRl5KYe1bp3
	vQkk8f5NT9shmKhPFNF1Ya+k2eqCP76CW+/BuGi9QHU6vK+A3dxoJTy6hkUol5yNBSPK+W
	eE9Q+9kMZn+2cJtk/WRf6kU8Q1XmPtM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206478; a=rsa-sha256;
	cv=none;
	b=F2EVg2TAkQIgv4mFkcVolt4PYJJUSH9AeQf+DPnQyX/ru9bcGOVC8cbeHZ2ZOYtVfp+pQu
	aRsukGAEMRSP2kQVdIywGRcTx0vwSo0x/htwgRM4xr7WD7B5G27/9H4xcUZ+ltZ5/u1fxL
	F2g6j/gmIaIFsYW3UVHp6JphCHp+ZAc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X9En0bXp;
	spf=pass (imf23.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779206477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=T6OjxI0zZxwDX8SXPRnZD+crOhWj/eJOyVt4Fi52IP8=;
	b=X9En0bXpHBwIIVh+3vjD/xWh23as8xI/3zxLdyhKkuqa4n05o3ifdAj+8ILebsOhrDlbUc
	WTpjcld3uItVSA9CvoOSXeiXiKtKbWfnZAmZe+OmVJLHLBoAeSnjDLLLO+WrswzdRei1fC
	VlnEKYydMVoemm3ZZLBvBC2+Cg4e2fY=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-4jdxZkAPMX6f6SFE_sKUHg-1; Tue, 19 May 2026 12:01:15 -0400
X-MC-Unique: 4jdxZkAPMX6f6SFE_sKUHg-1
X-Mimecast-MFC-AGG-ID: 4jdxZkAPMX6f6SFE_sKUHg_1779206475
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-90f4bdebe77so761419085a.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779206475; x=1779811275;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T6OjxI0zZxwDX8SXPRnZD+crOhWj/eJOyVt4Fi52IP8=;
        b=AL1k1F2ead+omX6ctaQCtAnA1u+kyR7rhZl1O1BTrp6nZ1PRmKj5CEsUqERPYLsNYH
         jBwxhojcBQkTvl4aZF9ORjGmBSxDNhFUuhM/MkbRev4VSps//T8I2eK+wRjNe2LFruru
         C0aCYALVEYQHSfsyB6UfMTg7hJDmNSo2ym0IqpFBDGxgZlteJDPxshAX/nLr8VTXxk1v
         U3a+jrwlbwajJxyFABNoLuofxVU2YTggiZjzcX+U/2Bx0xxOK55Lee14hQ92NDkbsTHt
         +v9PyU5Hlw0jvKCa9n8RKkQtFwk+7lqEf+Xql48jRGY1/vjNNEDoE0RJG/hVom8GUMYw
         mzaA==
X-Forwarded-Encrypted: i=1; AFNElJ9T11ZgDBBW/eTn8IKOn5GXwoa9GM/uHoUC7SJdlDed4Tg0NnsDHjY7+doe1I3qxqDJj/D1FmDFFg==@kvack.org
X-Gm-Message-State: AOJu0YxNSjlaVqiyxntLkMK+FCEb3hbib4NUJnKRCpZNosBH8jjl0zY3
	wMTbn8nGNlRzAY7ATvyKvaY96N2nYlgjKbaNb42adNLjXl1FGFTv1ylCm26QIY/FkWeGZgUuOpQ
	lXBQDtPyj9LaniOhys0wUry94u2C1POMIuMVwIL/xZs/I0tBdlqmI
X-Gm-Gg: Acq92OEecoLRlJ6y17bODZO9sOmJjcxv8/RORoxFodxpzmAhwUHCivuBbQUl9Cwfae/
	7T9j1qjXg1BaGBKmN6rNJPM0VgGV26CvmAgfUVhPCxkLHkGx4nlvU4vjnlFR3Kh+HWH7rmb3QW/
	Xyg7soT8I9FNsHyXUt8df6y7za6L/CX2toRRFyC+PlolLYs/Y3H0W/w9/QMuhHmoLk68Jh2ip8V
	S4SUGwPzKvdr3TJkS1bIYB5TJXzL82dM9o+K93MUATWfFeGyzWFSg29g0QRBcfFFwv7CId7ps3v
	Ca+BGhJol/f1gGD2V9zEvHPwJHIz6E8uuWCkSjc5jzgE/3RUWfYjitaoM27Sr47HC7OArWu7mVv
	1/3ufm4HiebSUa7X0FpHXfhA23vtBSTinj6/8n9MmOz0jky+8SzlACwuy9MnV4zPeRQ==
X-Received: by 2002:a05:620a:460f:b0:911:4cb1:8a60 with SMTP id af79cd13be357-911cd178131mr3073458185a.13.1779206455446;
        Tue, 19 May 2026 09:00:55 -0700 (PDT)
X-Received: by 2002:a05:620a:460f:b0:911:4cb1:8a60 with SMTP id af79cd13be357-911cd178131mr3072809785a.13.1779206430240;
        Tue, 19 May 2026 09:00:30 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bc9363fcsm1883933785a.27.2026.05.19.09.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 09:00:29 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Subject: [PATCH v2 0/2] cgroup/dmem: allow double-charging dmem allocations
 to memcg
Date: Tue, 19 May 2026 11:59:00 -0400
Message-Id: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQrCMBCFr1Jm7cgktRZdeQ9xkSaTH7CNJG1BS
 u/uoAdw8Xg8+PjeBpVL4grXZoPCa6opTzL0oQEbzRQYk5MNmvSZWt2jDSUvL3QjjyixAV1ehie
 j4EVw8orIXLwfvAaxxFTnXN7fg1VJ3X+uE7V/XatCQtv2yqmuc6zNrbCLZj7aPMJj3/cPgkfhe
 r8AAAA=
X-Change-ID: 20260327-cgroup-dmem-memcg-double-charge-0f100a9ffbf2
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org, 
 Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JGX3rHHrSjxPn-u5D7h8Jfj_9XpvQa0-juSUvFU5hKc_1779206475
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13590140018
X-Rspam-User: 
X-Stat-Signature: ihce4k6qodizac9kfgm8cwxe4on6h64s
X-HE-Tag: 1779206477-212099
X-HE-Meta: U2FsdGVkX1/hZ1X6ZaK8W0TF89CfC3dXLztQ6nnSer8JORpviHhlSPaZuOO0+bdBlb5UfH1NlT50/FnP0uBHuoNH6pPtVRDaJfHgqkXsC0bx7o2s56rVmwQ6U0ZwhwcLTfmnoC6VGASdGsVs913kQyORWYpbiZvF6WkXc0rxTl4+ydBY08ClFo04eTZBIMQfsLabgJWUh94/xuic20IKEHBcKyD+44GXhgEmBsZJFFKaFjDxDAKdfzVU6Dmrlqhwz0d8cWZ/7nnZXHYeVsVhe63F7G1wIMIw6JLsqKT5906usgX2QI92//fKqhrBXyJ1nk7KYVlHCCrpy+GowAgz0qOmZBW7zQnHn2SLh5aGkOBXTmI7b6VqwJyUdB1i7XxfKu+8vI7X5n1OG6BMq5rAq92YeXbtjDSpt/BSpxR6OLomHTKf6p61vHBegeEIx40yu3zQ06gkzqiSQVoflg8JqZzIZUkdYB9VvGjdIh+DA3OVhleivbfHkL32Lnw7kx60rJngEXLpbBmrQMdrOn5/qqcl+6yqsmbd37Bi5ksIkMBgelOTPBF/ssHxpdyR5279c0QHbMFGsgliLTrIpqFsASuPRUVmkl3HN3EggE9gi9Cx1O584/BmmoWv6YE5+1tCPs/yk/phFrtfD34FNPi0yGFgQM9Z90o+Llgk8lzu/edkh2YipjIb/M9fpLCg+JNajHx+DFcir/3m30W8iDHcMQ+bDY7N6cZ4yZbfpOC7IpvtB16RmgJ88r9Nrai4JOGSfOQohhmZAJmrSoaYWeOBWjdcYF83b9h56McbXjvxQUwBdErl+bNM/g3oXXLbV+Bz3LsSNXSTLH6Xsx+sCnHUumZn/DHHawpyMQL1YMOAa/qeyJX18Z88NnSgsR0HrjuMrjtNAyfFjOGBBTFWMwreuPUjvouLjyuOiu4lIkvEL32hbYbZ+fsZuuurdViNnaozwW3bRD0Lmnn69sYew9U
 BFD5oXli
 +GISoitgksVV5oICAEBr7g617bq/tgLtq/AXdL5K472Ueu6StZ0FEbhu1AiEBL8tX9N0jwfFamQwrLqq+QOjwMChmhIwCOTaRlGzQHGGXCN0zHPNCnWxbH8T4tAIj6OS/a29+qoPbq8E/x1qpa1XE4ZzPaMC9Y56WAase76HvP+vmoA/7Mmw+4NNa+TTOGfR7MAyQB9Ddc126L4lZsVMOMTeU/ejZkmM9k+ASaj7AF/efKRaHGZKzKu2Z2S57kGKYVNJhisRnVURaF/7O8QxAAp9KS+ioJ9hgjUZb9auo8h4nfyjEqXcP+rA6X67u+x2VNAvwvDDRMADXskaScP6Z9VSbeq6/A2oYaM0RyVei8+HQ5+LBxM9UK4FcEm+uhZh6K1Xo2WTejXsHXAMRpFCfWxkowkt/p6Aeg//S1E8aaok+PxVZlBPeZxk9iOgIRWTQuGYxNns03YA6bXIG4CGuQ7jt6saNS5h3/IsqoPV3CcifPmwClDsqr5U/dE8DDHqVmV4x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Following suggestion[1], offer a cgroupfs entry to allow an
administrator to request that a dmem controlled region also charges to
the memory controller.

Add mem_cgroup_dmem_charge/uncharge helpers to resolve the effective
cgroup from a dmem pool's cgroup, perform the charge and update a
MEMCG_DMEM stat counter.

Add a "dmem.memcg" control file at the root level to configure memcg
charging per region. The setting is disabled by default and locked on
first charge attempt.

[1] https://lore.kernel.org/all/a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com/

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
Changes in v2:
- Use mem_cgroup_dmem_{,un}charge to account for memcg pages instead of
  exposing raw nr_pages functions. Use it to centralize where to find
  the effective cgroup from the pool's cgroup (Johannes)
- Set depends_on for cgrp_memory if CONFIG_MEMCG by having a memory
  controller in children cgroup (Michal)
- Move dmem.memcg to the root level as it applies by region for all
  cgroups
- Add a dmem memory.stats entry for reporting memcg charges for dmem
  allocations.
- Wrap the memcg enable/disable/lock configuration under a single state
  to avoid toctou races and simplify transitions.
- Link to v1: https://lore.kernel.org/r/20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com

---
Eric Chanudet (2):
      mm/memcontrol: add dmem charge/uncharge functions
      cgroup/dmem: add dmem.memcg control file for double-charging to memcg

 Documentation/admin-guide/cgroup-v2.rst |  23 +++++
 include/linux/memcontrol.h              |  16 ++++
 kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
 mm/memcontrol.c                         |  65 +++++++++++++
 4 files changed, 259 insertions(+), 3 deletions(-)
---
base-commit: d989f135f71699294bb2ffd4726b526456e2db68
change-id: 20260327-cgroup-dmem-memcg-double-charge-0f100a9ffbf2

Best regards,
-- 
Eric Chanudet <echanude@redhat.com>


