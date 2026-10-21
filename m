Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31E6606A321
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RU61zTPD
Received: by kanga.kvack.org (Postfix)
	id BBE9D6B072B; Wed, 21 Oct 2026 11:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94366B072C; Wed, 21 Oct 2026 11:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9E26B072D; Wed, 21 Oct 2026 11:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F17A6B072B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:43:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C093AA8142
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:43:01 +0000 (UTC)
X-FDA: 85347051762.21.0EED267
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 70B63C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:42:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RU61zTPD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792597379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Zq0meheIWFxmeUOFFDG2C2Iy+OUkZpOHMmtcorZaUXs=;
	b=46+uMuH2zwAOpbD05H6EfbusVN62u3TXjdq7X5NGd++gQz8pcOH10Q4eCgVs94X+ymPcMf
	wxUQERYNJXfF20Zb3pufPDg6PCWNIM44ZchLw6FFQ2HI1lDzM4BGEjz+s+sQDUnah5fuV9
	pUOOHz83XgsoSFce7/1gkwyReGIaUEU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RU61zTPD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of aesteve@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=aesteve@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792597379;
	b=3U1xK3jcDAsO0LMQXzifV1AnaqOP82+xyur5wdQJZQZMB2tRAfobeCPu5mHJgc4FGYdFtj
	dvOCk5azqy6AqEzezevUidcZaoF6ms3P3j4DX4eWw08F/YcokDpOKISpu6DB91L6MlUIJH
	XVG8vy2/g5PdfWA/GyZVLgEno+UkBzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792597378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zq0meheIWFxmeUOFFDG2C2Iy+OUkZpOHMmtcorZaUXs=;
	b=RU61zTPDJEkBlDkw44FKUfHRuKMrB2ILdzxIelgp0wvSNY8UZxhMmT+lKvv+OxTDz0P0mk
	6HMYjIslyBacAkdKckGfGay1fRUhxDQ+8tH1AMfPnzkNmuY69OZORv1ZQ1FK3XVM/kfkI+
	yQlQqVZnDnwHjdwSNpoyS1O8Nh+mUeU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-EmzSbsWyOMaIy7nlffsu5w-1; Wed,
 21 Oct 2026 15:42:55 +0000
X-MC-Unique: EmzSbsWyOMaIy7nlffsu5w-1
X-Mimecast-MFC-AGG-ID: EmzSbsWyOMaIy7nlffsu5w_1792597371
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A3731955F40;
	Wed, 21 Oct 2026 15:42:49 +0000 (UTC)
Received: from aesteve-thinkpadp1gen8.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4760518002B1;
	Wed, 21 Oct 2026 15:42:39 +0000 (UTC)
From: Albert Esteve <aesteve@redhat.com>
Subject: [PATCH RFC v2 0/8] memcg: dma-buf cgroup accounting and charge
 transfer
Date: Wed, 21 Oct 2026 17:42:21 +0200
Message-Id: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNTQrCMBSEr1Le2kjy0saflSB4ALdSQk1f2ohtJ
 ClBKb27oR7A3cx8MN8MkYKjCMdihkDJRefHXHBTgOmbsSPm2twBOSpe8T1LqHOWXKDU02OgYBw
 F3XnfPUkbPzBbltbYu1CV5JBvXoGse6+KG1wvZ6jz2Ls4+fBZtUms6GcQ+N+QBONMSVQ7LoxUB
 3EK1PbNtM0Q6mVZvsLwuMfWAAAA
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
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Albert Esteve <aesteve@redhat.com>, mripard@kernel.org, echanude@redhat.com
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792597359; l=5394;
 i=aesteve@redhat.com; s=20260827; h=from:subject:message-id;
 bh=MS4zwLlyVCfwhsSvb1IeSKwj4iG/Qm98gmNYNJOwbsM=;
 b=agyIVdfvg7HqBQCD4OxEOrWUHQwfY+kfAKV8I5NR48qkBfOIAqjk9GzNSjeD7lsMVDMJTFUqg
 g2gQ3mohTjRADVTwZUpCc8K+uUr31IpGojhy7WEy0K4qRkTd2hYgodF
X-Developer-Key: i=aesteve@redhat.com; a=ed25519;
 pk=zI2RBeZgocwYm3AkJW4CtjoJnKoDZrfBl1xe5Ed6h+U=
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: b7D9V0twLEexJi0RIyT-9MPT2GE-8CYoJYbQbD69k5M_1792597371
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 70B63C0004
X-Stat-Signature: 9ytcix11uufjxe3nuw6e36h6sun7so49
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792597379-438813
X-HE-Meta: U2FsdGVkX1/akTqU7AWTFTT1Mu1E0JIYafUiOnS9DptS9hlYfR6JRqUyVIUjYbsUURSimK0JeLrL2sKd9UMR2rZ2DmZb9xb3pAFpSRJ2CCVhBB+6bUaPf7BTaOpr9APIr0F38hXj4nfYCQIZTt52e6+LDS50z1Gtm53KoMp6fMjlw3N/grOKoC/wbEyKIArHFgqHik5d/llq0I21/lO8jipmAuxJe0X6e4ZHLE7acn3/wBlFj0Ys7ehGYKCm+mhKjHuoAHPPQBLU4pvbqYj92+TYiSiUqjoE6Elqpb76Ne5HHnhBvi/RnR6OEeu9AabxTme8MahovVZ6bk3XXH7unpU3JPrEDX5p4++5zn8e/bCNgS7JjXcV7GfTfWnhTTVW6xz/HoUJb/8uqo/1Sp523CYLx3Z63Qiimkfiu6qWAtDwz8nEWAwtIL+YcpQQsc1a+3zqV8JRDAujqhZYaaDYPawLk7qlhOeGoH6QsXQQKMBrjffGj6M0Bglaetl5SgSHBt311cwpt6ArLKCC99rmp6rrJieolD7GzLioXMzV57IQaE2Rgk3bNiOOL1RTA1uRRfWxCprF79pWC7TIChsqXPsOodRTAS59j711rjcKrt/2b6o1dy+BnZjdJ8saVsnr7TyOGS1D//PGvE5lZitOH5cskiUoZXYuhD3bgbh6MGCKfHz8JS+bz7rhBdi5Vt6su+dS3ovNSCJ0Q4P/RJyHxjIm+7Ij5jnX7OSRZcqZboUN/nSzIh8cMHodtJilb2hFf5e3sgugAxMD82I4iCkj4SqBnkS7tUwd9AxgSfMkc6kcdsiSUiwiCBoICyBdwC0GT9MrE365LnVRqOBFFuE8JflW+IF35wh1lYEjorLHf4SKbT5mGfPx0zb6YBdoHZm/opabI9H2B1Bn0Wn88DuekTg11/b2ew+2/JSjNu8RelkicaGospKdf5FHkkFJNa48bVtwaGmhDPGlQVh0hfn
 4SBoOCJS
 6Ba0gATVWDS9PzEoOYpbNV3cJZlHGM8HGWFoPM9XW66TLsKI5zEk9oI7h6fiqfoLgYUZjz7VqmJuEUwqSpe7VQFzmd6E2b1JT/dN7i9W0cQPThSpTNQk2cMgBxAN34ULfW6l0Gc/YO021juRJdjiaMVGqhtv2/8ZfdmT1DeKYLV1Hhwk1H8zjZijw2qSc3/m/cpGilVPsSD0JRXrGMpnt2rMEvzlgNDmtcPBuUT94fFC4z+Bsy0Uk5z36nP+Pc5HTvtSZmda9Zv/4Iv/bfsYCswYC9VGphRJNdRfGpitCfTqSde+GYUu+iemV44lcOTte1o+TtxQrTmxhpeS6iefdhGeoyr6qVNB2TkD0Z684NQFDKRYmkFLScMkN5ZwIpRiwdA/Zi4QQ5yObfxZXB8B65LcaWM/11JHiay3KUtmQywXzEuVyV1wEFy25RMk+ePq3HYsvF/9TeHCh8LrtsWkVHA68aWBvk9aOe3zEbI3mblKD6cw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series adds memory cgroup accounting for dma-buf allocations,
building on T.J. Mercier's earlier series [1] and incorporating
feedback from the v1 and LPC discussions.

Patch 1 introduces the MEMCG_DMABUF stat and charge/uncharge helpers.
Rather than charging at the page level via __GFP_ACCOUNT (which would
require every dma-buf exporter to implement charging, and makes
cross-cgroup transfer impractical without access to backing pages),
we track charges externally on struct dma_buf via a MEMCG_DMABUF stat
counter and route all accounting through a single path, removing the
__GFP_ACCOUNT flag from system-heap allocations to avoid double
counting.

Patch 2 adds a charge_fd field to DMA_HEAP_IOCTL_ALLOC, accepting
either a pidfd or a cgroupfd to identify the target cgroup at
allocation time. If the target cgroup cannot accommodate the charge,
the allocation returns -ENOMEM.

Patches 3-4 add LSM hooks for the two charge_fd flavours:
security_dma_buf_charge_task() gates the pidfd path (target
identified by task credentials) and security_dma_buf_charge_cgroup()
gates the cgroupfd path (target identified by cgroup directory label).

Patches 5-6 implement the SELinux side under a dma_buf object class
with charge_task and charge_cgroup permissions. For charge_cgroup,
the target SID is derived from the cgroup directory's SELinux label.

Patch 7 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
dma-buf fd to transfer charges (or charge) post-allocation. This
covers the double-hop allocator case (SurfaceFlinger -> gralloc) and
works for buffers from any exporter (DRM, V4L2, etc.). If the
receiving cgroup lacks capacity for the charge, the ioctl returns
-ENOMEM and the original charge is preserved.

Patch 8 adds selftests.

Known limitations:

- Single-owner model: a dma-buf carries one memcg charge regardless
  of how many processes share it.
- Only memcg accounting. CMA heaps would additionally need dmem
  controller integration.
- Charging CMA-backed heaps to memcg charges unreclaimable memory:
  when a cgroup hits its limit, try_charge_memcg() may trigger a
  reclaim pass that cannot free CMA pages. A future version could
  move charging into per-heap callbacks.
- If a transfer of an uncharged buffer fails, the buffer remains
  uncharged. The allocator (userspace) is expected to handle this
  (e.g., retry, free, ...).
- The LSM hook is intentionally narrow. Broader cgroup access controls
  could be a separate effort.

[1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@google.com/

Signed-off-by: Albert Esteve <aesteve@redhat.com>
---
Changes in v2:
- Move charge_pid_fd to charge_fd, accepting cgroupfd in addition
  to pidfd per Christian König.
- New DMA_BUF_IOCTL_XFER_CHARGE ioctl for post-allocation charge
  transfer on any dma-buf, not just dma-heap buffers per Christian König
  and T.J. Mercier.
- Moved __GFP_ACCOUNT removal to patch 1 per Barry Song.
- dma-buf charge/uncharge helpers take struct dma_buf * directly
  to avoid the need for caller to manage size calculations.
- Added test_xfer_charge_cgroupfd_self to dmabuf-heap selftests.
- Added LSM and SELinux hooks for cgroupfd-based charging.
- Rebased to v7.3-rc7.
- Link to v1: https://lore.kernel.org/r/20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com

---
Albert Esteve (7):
      dma-heap: charge dma-buf memory via explicit memcg
      security: dma-buf: Add dma_buf_charge_task LSM hook
      security: dma-buf: Add dma_buf_charge_cgroup LSM hook
      selinux: Restrict cross-cgroup dma-buf charging
      selinux: Restrict dma-buf direct cgroup charging
      dma-buf: transfer memcg charges via DMA_BUF_IOCTL_XFER_CHARGE
      selftests/dmabuf-heaps: Add dma-buf memcg accounting tests

T.J. Mercier (1):
      memcg: Add MEMCG_DMABUF accounting infrastructure

 Documentation/admin-guide/cgroup-v2.rst            |   5 +
 drivers/dma-buf/dma-buf.c                          |  80 ++++++++
 drivers/dma-buf/dma-heap.c                         |  72 ++++++-
 drivers/dma-buf/heaps/system_heap.c                |   2 -
 include/linux/dma-buf.h                            |   4 +
 include/linux/lsm_hook_defs.h                      |   2 +
 include/linux/memcontrol.h                         |  29 +++
 include/linux/security.h                           |  14 ++
 include/uapi/linux/dma-buf.h                       |  26 +++
 include/uapi/linux/dma-heap.h                      |   7 +
 mm/memcontrol.c                                    |  94 +++++++++
 security/security.c                                |  32 +++
 security/selinux/hooks.c                           |  40 ++++
 security/selinux/include/classmap.h                |   1 +
 tools/testing/selftests/cgroup/Makefile            |   2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c   | 145 +++++++++++++-
 tools/testing/selftests/dmabuf-heaps/config        |   1 +
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c | 222 ++++++++++++++++++++-
 tools/testing/selftests/dmabuf-heaps/vmtest.sh     | 205 +++++++++++++++++++
 19 files changed, 974 insertions(+), 9 deletions(-)
---
base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
change-id: 20260508-v2_20230123_tjmercier_google_com-f44fcfb16530

Best regards,
-- 
Albert Esteve <aesteve@redhat.com>


