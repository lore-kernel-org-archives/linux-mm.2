Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 953AAFED9FD
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 18:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D407F6B0095; Tue, 17 Mar 2026 14:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1C46B009B; Tue, 17 Mar 2026 14:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF53D6B0098; Tue, 17 Mar 2026 14:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94D2B6B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:13:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F11A16034E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:26 +0000 (UTC)
X-FDA: 84556352412.24.5DD8FB1
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf27.hostedemail.com (Postfix) with ESMTP id B9F644000B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 18:13:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773771204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Dx/keUR56n0qG1WQao/xrJvv5VzCqtDsAkFO6iCfs7Y=;
	b=h/tDhLqj9twOa0s65MsXNjVx4plZvIAO0q9tr8MfIl5W3Ro8AbeJ2BT3gjL8w46IcewGcA
	MlI+4ms1idXpCY62hSPfNjM4AsXBOpmd56cocbK+JwizAzpRa+1EpWhNMsbTcZT94WEPTu
	eCBxiOCXZfeeXnEvWqQ1bEKCahe/aw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773771204; a=rsa-sha256;
	cv=none;
	b=xf+iN5BZ2wUM9UZFlIbjRM32E/u9t+cK4GasQISWvY5bMDxwZlE4x2Z1rMRTTnKQzzjoe0
	dUIKiE5P95d/vjoSE4fHujUcxJoXtdd6Lga4Pp9x0SV1hIL5gZbQ0PqfeaHlwWUNQiVFqa
	MWwhXUvIzOuJi78yI5Wp1z0K/ETbOZo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 18 Mar 2026 03:13:19 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: rafael@kernel.org,
	akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	pavel@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	usama.arif@linux.dev,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 0/3] mm/swap, PM: hibernate: fix swapoff race and optimize swap 
Date: Wed, 18 Mar 2026 03:13:15 +0900
Message-Id: <20260317181318.2517015-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a8w7a6xx97pbqepu87sjrkw93qkpdnc6
X-Rspamd-Queue-Id: B9F644000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1773771203-263181
X-HE-Meta: U2FsdGVkX1/1RlQwIQRUEInMl1ZLVfi6j6fN47rU0PkE0xv0soHL0eD/gwM0UyE9EBLqyvIhFb9UJ+tVOwFoerADLMiL08XLEWH2PWauCotLUPGaFXdSvn5m1DWhXKbnvoGR008o+4OU0yZUoRcv7ZXLU0HsegrVI8xZvtApntCpmX3bR8eXbnIYL7b7DXrgb/YC4uX+yk3LiLU3NFqFkkgkwJMvY6WxDwqEd1TG/PL68/+s/RX/E/pK4OnGzKFPQAwN8BP8VnNtmaLc1+rbG6r68m0DZYRCb54aCTXz9UKbvdXWDTlk9LOZxcW2O2KH4AQfqoPK86qsghojGV9rnkW0T7OvdXuEt6WQK3So8iJLNOdX86Vtc40BAfat8HPCnS/y5JsfUDm7zhveRO3BxV1ctYc/4C3TXihxXbLwH3daiRwa07UHIu/EwJW7p5Ytv0wtFBqj4S/ySDDWxY1339hEnLyQjDEZSc60YsqMPTppRkkvxja7WrzPbSNxdrHL9dZKIw5GjCk+0t2hmmx8UJt0R0wKDs/Qz1rWeKnH9TnRKPkQdjj/p31rLfTkvdSwb1V1IxMRbQsenixNbWShZjxw81IpRTaTQJyXVqMYvR1FBWXgqRtvlmWDiGQZE89pmioAFKh+nUTRoq+sABzRO1A0dbRf62WiE05MpoWvEMz3pAnPmj/3eH7TGwdR125GubKXBFixxm56O1xWCOJpDjQmyG6unUV/iNa5BbsQbCnvRA/+92B88sdpiSl9Cry7eQoPDyy2IIYOJJtCVcLB0QcEG5frT8L16eVNfYxsULpefJqZ1OgQnMNMqNMjwTVO7GQx6ek15d9YKSPQhaPw10va6Bx/psjMGihvqmBuOEayYf3VSsj2oWTE582vCTAYXWIY4GUqlYSJCl8kKHfYzq70Erk525yo7mwjgbWXD2EVhEwddp9vbmkp49CGCdNRXUrP98MtVJjsU2OKTgD
 aqtznKl4
 /xcgr7p9NKmw8ecYO+i2piSOIndKjYVhOFBX7qYSbE4F3uTw3BraBSkHSh+uZbg5puKKjQEhBD3xokhV7aaZtvk1NSQ7oouP6oTmiCROLBFaRNQTQX9sSj3+XJGVNhICQVh6DkJIqG7asUuqq27/D5I+bXoi9ZX3foD4aUFBKEFaMZTBtDd9mkQX4h6NZ9KJRw15BThAqpFCp2ABIUfEoVpf/UjV17RvbuDX2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in the uswsusp path, only the swap type value is retrieved at
lookup time without holding a reference. If swapoff races after the type
is acquired, subsequent slot allocations operate on a stale swap device.

Additionally, grabbing and releasing the swap device reference on every
slot allocation is inefficient across the entire hibernation swap path.

This patch series addresses these issues:
- Patch 1: Fixes the swapoff race in uswsusp by holding the swap device
  reference from the point the swap device is looked up.
- Patch 2: Removes the overhead of per-slot reference counting in alloc/free
  paths and cleans up the redundant SWP_WRITEOK check.
- Patch 3: Fixes a spurious WARNING in the uswsusp GFP mask restore path.
  (Founded during uswsusp test)

Links:
RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.arif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
RFC v2: https://lore.kernel.org/linux-mm/20260306024608.1720991-1-youngjun.park@lge.com/
RFC v3: https://lore.kernel.org/linux-mm/20260312112511.3596781-1-youngjun.park@lge.com/

Testing:
- Hibernate/resume via sysfs
  (echo reboot > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate with suspend via sysfs
  (echo suspend > /sys/power/disk && echo disk > /sys/power/state)
- Hibernate/resume via uswsusp (suspend-utils s2disk/resume on QEMU)
  - Verified swap I/O works correctly after resume.
  - Verified swapoff succeeds after snapshot resume completes.
  - Verified pm_restore_gfp_mask() WARNING no longer triggers (Patch 3).
- swapoff during active uswsusp session:
  - Verified swapoff blocks while uswsusp holds swap reference.
  - Verified swapoff can be cancelled by signal (e.g. Ctrl+C).
  - Verified swapoff succeeds after uswsusp process terminates.

Changelog:
rfc v3 -> v4:
 - Introduced get/find/put_hibernation_swap_type() helpers per Kairui's
   feedback. find_ for lookup-only, get/put for reference management.
 - Switched to swap_type_to_info() and added type < 0 check per
   Kairui's suggestion.
 - Fixed get_hibernation_swap_type() return when ref == false (Reviewd by Kairui)
 - Made swapoff wait interruptible to prevent hang when uswsusp
   holds a swap reference.
 - Fixed spurious WARN_ON in pm_restore_gfp_mask() by introducing
   pm_restore_gfp_mask_safe() (Patch 3).
 - Updated commit messages and added comments for clarity.
 - Rebased onto latest mm-new tree.

 Note: Kairui suggested adding WARN on NULL in put_hibernation_swap_type(),
 but kept silent return instead, as type can legitimately be -1 when
 snapshot_open() fails to find a matching swap device. swap_type_to_info()
 returns NULL for type < 0, so the cleanup path stays simple.

rfc v2 -> rfc v3:
 - Split into 2 patches per Chris Li's feedback.
 - Simplified by not holding reference in normal hibernation path
   per Chris Li's suggestion.
 - Removed redundant SWP_WRITEOK check.
 - Rebased onto f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b.

rfc v1 -> rfc v2:
 - Squashed into single patch per Usama Arif's feedback.

Youngjun Park (3):
  mm/swap, PM: hibernate: fix swapoff race in uswsusp by getting swap
    reference
  mm/swap: remove redundant swap device reference in alloc/free
  PM: hibernate: fix spurious GFP mask WARNING in uswsusp path

 include/linux/suspend.h |   1 +
 include/linux/swap.h    |   4 +-
 kernel/power/main.c     |   7 ++
 kernel/power/swap.c     |   2 +-
 kernel/power/user.c     |  19 +++--
 mm/swapfile.c           | 154 +++++++++++++++++++++++++++-------------
 6 files changed, 132 insertions(+), 55 deletions(-)

-- 

base-commit: 7d47a508dfdc335c107fb00b4d9ef46488281a52
2.34.1


