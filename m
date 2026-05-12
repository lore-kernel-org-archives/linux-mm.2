Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6C3CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 09:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63506B0092; Tue, 12 May 2026 05:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3AEA6B0093; Tue, 12 May 2026 05:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77606B0096; Tue, 12 May 2026 05:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B42D06B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:11:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65F0F1C026F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:38 +0000 (UTC)
X-FDA: 84758199876.20.3FAFD70
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 45220140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 09:11:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PWHZXjeI;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778577096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=p80uB9ppx8DS0thaGwc0VH0L36R/21WsbTghYE9KDbw=;
	b=Bpe0DOJSP8mQDDRP3igj7W0vTiqT8hkT57m5r85LUahUYP60cGZLpgVLkQ7KlbLbFVWx9d
	9mB44bLoYEo6oeWm12+cz2ZfLNcSTRsatmD2sGou0dDF7Ov4Z/aJsMq99Ap8Zudvhrqp2i
	n716cCx4bbwueH3uZ3mUz3q8kAYP3Z4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PWHZXjeI;
	spf=pass (imf23.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778577096; a=rsa-sha256;
	cv=none;
	b=tql+aLzKihhGqxhg0wqD2Ce4ur8txxQCbcxDSkx328/DLFJQn6ZaPUgp8hFFdPM2lMPATH
	PPtZ52MQvbvLGvakgyw2klwmE8jNlrOQu3CA64rg2L2QFvMiIyXo9PxwFpHc7HvIrQ1Xqn
	zgHFxoPCyFhPmvzO2Qn8l+sbTurODTk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778577095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p80uB9ppx8DS0thaGwc0VH0L36R/21WsbTghYE9KDbw=;
	b=PWHZXjeIrSy+VsffKsMKeLjOC3+O1hMqczZMEHI3xV7U2mDBv55yFhaytySeHU9aIoKVEN
	WY5rd8KpaGkNsJy7CB0fH/XRZzX7GVM+y4MMdkyOYIFwv4oM94ihSGdUsdjbXV6kPtNXbA
	SrlVIiwKWZdxavxnvlw88cTfuc1L2pA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-EieOxPp9O_ajxHZeof5XwA-1; Tue,
 12 May 2026 05:11:32 -0400
X-MC-Unique: EieOxPp9O_ajxHZeof5XwA-1
X-Mimecast-MFC-AGG-ID: EieOxPp9O_ajxHZeof5XwA_1778577088
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 228A618005B4;
	Tue, 12 May 2026 09:11:27 +0000 (UTC)
Received: from [192.168.1.153] (headnet01.pony-001.prod.iad2.dc.redhat.com [10.2.32.101])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09A6130001BB;
	Tue, 12 May 2026 09:11:17 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH RFC 0/5] memcg: dma-buf per-cgroup accounting via pid_fd
Date: Tue, 12 May 2026 11:10:42 +0200
Message-Id: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NQQqDMBAAvyJ7bmCTqEivhT7Aa5HQxk3cUk3Zi
 BTEvzd4m7nM7JBJmDJcqx2ENs6cliL6UoGfnkskxWNxMGhabLBTm3GFLWpj3fqeSTyTuJhS/JD
 zaVahroMPL902FqFkvkKBf+fiAf39BsNx/AFCOWAcdwAAAA==
X-Change-ID: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Sumit Semwal <sumit.semwal@linaro.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778577077; l=4167;
 i=aesteve@redhat.com; s=20260303; h=from:subject:message-id;
 bh=J/qTQA7WOSp0NDpJTrrE9CeifCSS0KYK7Fhqb5IuZRE=;
 b=w9BOSU+QzmBOQFJx39er3JufOMU+NTrwANFwrY1GjbF+ilD6YeDqgSMvjLwB7Lz3uKINM9vQE
 qrkVFKK2zfBDqr0ZUk82SaBAThNIU7vg1o9c6Q1zxh0DX4Y13wK5MeR
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=YSFz6sOHd2L45+Fr8DIvHTi6lSIjhLZ5T+rkxspJt1s=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 13wlmlI_yc3aHQgop1Aihl_3vgxARShq560qljPVrMs_1778577088
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 45220140009
X-Rspam-User: 
X-Stat-Signature: n569opg3xxhzi8bgumnp6u7ko97diiyh
X-HE-Tag: 1778577096-135673
X-HE-Meta: U2FsdGVkX1/TCbCybiBp/GVgM0EHqlTh2Rh/dqcbzs5BFRAWlbjzaNBB1xg0CH/Gw/JFYiDr42ITwyRoqv+6S5a94NfA1OM0PrV72q/6EvMYlCoL4n+2rIAUulaSJnmQ0p0YSn72MTgXS8T5RX9O0aPuJhcmMfW1FZGeN62W0UJL6OBjzXWnfzqjl3fh0aWBTMz5WRoMc4sBhf7YDCSYhEPvK9JZBkUdfmZeAFE4tdy04dcpFwH8zWW0mCG/qWO+EVc1rv0LHypCnqRXntJ6yQlrLigxmgkacqe28ytTfa9l1Gs4aj6Rh2dNY1jhhyJtC/yCYMF861Qu0UCvwvVepMQS8aHNJnXbRPBIn+c/StOFHW9SIwThedbaxrSO6xdnssRB/J1cO+oiNqvEhfgdLPdu1XG8JyB/qtaXmQHmyFtFKa8KHouIk/Hlmr5oz8dMf/9p08RsB/mXeoSDNcGOMa+v4TjUQ0l6Cb5EGIzRtVT0HARm28OZu6OYgYeI5CVsqvwsenLMMlwsL28vEK5Wpuwo/3X0vv3m9oa8+f2c4tgHV5hi8NveYmNnY1pmJM1rtkr/dYETH0UlUqeGCN+cQLnpMe98z2/vprpYULC0PhcLBOkRi6CPYwrxdKY8VUxB0SmZ0SE4Qkczgu47E6OLapkvq5yxB+OaPMjJdltwSubHnUtC51YMBlYAEqRIyMCT4BXO39wfik0Ri3fRfKzqFbV2JYK/FR5F9cmrzhA5dM5eFVMqRdEtWjOAXuMs6+0NxuZMP2u7XJ5DlNFMD+ixe2UGzj8xRbV1x21m+4gtduNv5Yg3ob9Lj8xqwBLeX+lkRJp3BvjQp7GYxKScYP07Ai2D9+QtEv9dG2ErO5IQlXbesct9aZA0tiqmNZnu9jsdcmCndxRPPQoftCNIQBr7IVeryMPH6lKiJhdkRdFGU+VlTqKi1LmrjO+0d249ZzF/iFIbdNsrYQR7uE6HDZS
 D/jnsoMx
 napfAnmBJmOklam+BLRSc38wO+3uL4BzGWoWKBYKa5Vb3YboRWyl9ueldDk7vRwn0eLRRMLWBV9IIIJV7WbzqPuGHRo1PiX1tmeTC4XWHwGrBZtkLYvWSh7XDJRZUs3DtIKzlXCkUkwEBuFmfu4hM9zTo7yQf5hGuY5dQNj/Iy/zUPvs3OADbO1O6aYR7HNh1zrvSZGbnh1T5XwPrynEVaOUWApRoGYRDWmbVoY7KZpmuAqdvrtW89sjirDZ/CQxbBHMHrOMow4o+G8YgrJBrfJXwXFKHj6kJYskT+JV3Iq309FIN0gATHRCqM1vHbmUo/BpIdJnnCWXrpBGXG1ETBBA2m/Km/ZfWRKklEQ7SekHOCK5rzclr5DbWdXv6NbEJAHRnmHQvXXLydwBX5i5JIG2GqbSsYDp0e1n6eP0obAiPPhwY4VP+P6gL1JGnd6UhTcoEHZSLku9vfDNRTs/WxhvFe//AXUagYuwhBbIlowFG0h4h9nMxLxv4c95prELHefNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This RFC builds on T.J. Mercier's earlier series [1] which added
a memory.stat counter for exported dma-bufs and a binder-backed
mechanism to transfer charges between cgroups.

The first commit is taken almost verbatim from TJ's series:
it introduces MEMCG_DMABUF as a dedicated per-cgroup stat, so that
the total exported dma-buf footprint is visible both system-wide
(via the root cgroup) and per-application (via per-process cgroups).
This avoids the overhead of DMABUF_SYSFS_STATS and integrates
naturally into the existing cgroup memory hierarchy.

The rest of the series departs from TJ's approach. While the first
commit introduces the memcg stat infrastructure for dmabufs, the
export-time charging it introduces in dma_buf_export() is then
superseded: we charge at dma_heap_ioctl_allocate() time, using a
new charge_pid_fd field in struct dma_heap_allocation_data. The
allocator opens a pidfd for its client (e.g., from binder's
sender_pid), passes it to the ioctl, and the kernel charges the
buffer directly to the client's cgroup at allocation time, so no
transfer step is needed.

This decouples the accounting path from binder entirely:
any allocator that knows its client's PID can use the pid_fd
mechanism regardless of the IPC transport in use.

The cross-cgroup charging capability requires access control.
Patches #3 and #4 add a generic LSM hook (security_dma_heap_alloc)
and an SELinux implementation based on a new dma_heap object class
with a charge_to permission, so policy authors can express which
domains are allowed to charge memory to another domain's cgroup.

Last patch adds some tests to verify the new charge_pid_fd field.

We are sending it as an RFC to spark broader discussion. It may or
may not be the right path forward, and we welcome feedback on the
trade-offs.

Collision note: Eric Chanudet's series [2] adds __GFP_ACCOUNT to
system_heap page allocations as an opt-in module parameter. That
approach charges pages to the allocator's own kmem, which overlaps with
MEMCG_DMABUF. This series explicitly removes __GFP_ACCOUNT from system
heap allocations and routes all accounting through the MEMCG_DMABUF
path to avoid double-counting.

[1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/
[2] https://lore.kernel.org/r/20260113-dmabuf-heap-system-memcg-v2-0-e85722cc2f24@redhat.com

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
Albert Esteve (4):
      dma-heap: charge dma-buf memory via explicit memcg
      security: dma-heap: Add dma_heap_alloc LSM hook
      selinux: Restrict cross-cgroup dma-heap charging
      selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

T.J. Mercier (1):
      memcg: Track exported dma-buffers

 Documentation/admin-guide/cgroup-v2.rst            |   5 +
 drivers/dma-buf/dma-buf.c                          |   7 +
 drivers/dma-buf/dma-heap.c                         |  54 +++++-
 drivers/dma-buf/heaps/system_heap.c                |   2 -
 include/linux/dma-buf.h                            |   4 +
 include/linux/lsm_hook_defs.h                      |   1 +
 include/linux/memcontrol.h                         |  37 ++++
 include/linux/security.h                           |   7 +
 include/uapi/linux/dma-heap.h                      |   6 +
 mm/memcontrol.c                                    |  19 ++
 security/security.c                                |  16 ++
 security/selinux/hooks.c                           |   7 +
 security/selinux/include/classmap.h                |   1 +
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 143 +++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 126 ++++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 205 +++++++++++++++++++++
 18 files changed, 633 insertions(+), 10 deletions(-)
---
base-commit: 74fe02ce122a6103f207d29fafc8b3a53de6abaf
change-id: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>


