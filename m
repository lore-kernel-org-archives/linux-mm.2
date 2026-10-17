Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89032CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 03:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62FD96B008C; Fri, 16 Oct 2026 23:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607906B0096; Fri, 16 Oct 2026 23:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5438F6B0098; Fri, 16 Oct 2026 23:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 175AB6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:06:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 088111601D3
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:06:34 +0000 (UTC)
X-FDA: 85330630308.22.11C4805
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf28.hostedemail.com (Postfix) with ESMTP id 71345C0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:06:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792206392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XwN4z2P4MTZor5+C32HAWzZ6rrCCPwudbqof/0jK1Cc=;
	b=ev7ppu+CaP1XEBG7UFTpHpuWokb+S6En6OtDCaBcoPgA5nyLTOD0bONQLBf1pMK15h/zyu
	dwfqK92iDThmGSEDszLx0ayb4L31b4548YBKSwT5cxA6aDJoINTy0lmCMdutAk9wtMNEkV
	R/Wt3zT+fQe/84P4i7FSpgEfPXvxHqA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792206392;
	b=CPH7xeXEWOe+p3nbh1qT5yXI9x6KGwYj7x+urgkTgwur0P/35dptrAVjEl9hMsCF3A6VJg
	Vj3MVdcT27jtIJXBNjGswCBQpaPDDJ/yA1cznHjVHTr6QuMOprpT/PDf7TGe6dKcast3Dm
	PNsvLjEfLV/hb7VuTigwkXdZvfEecBw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHukW-00HaXh-Vp;
	Fri, 16 Oct 2026 23:06:21 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Manjong Lee <mj0123.lee@samsung.com>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mm: bdi: reset min_ratio after the sysfs attributes are gone
Date: Fri, 16 Oct 2026 23:06:20 -0400
Message-ID: <20261017030620.793108-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 71345C0003
X-Stat-Signature: dmzdri9dzp184sma845nuc6wmc6mi489
X-Rspam-User: 
X-HE-Tag: 1792206392-88534
X-HE-Meta: U2FsdGVkX1/8vrxyLd0jStE1MM+Qynyt33B9o/sIWcIlzX6B3huG/ulZIU/4WBEL/wBcAFs9ai/SThkNZIJmTcCvXkHiVF+SuGQdgkoXVBxiHEyKqLaQPyaIWA/cx2nl0Z6XpRvpRvxYiayOXzrcvbpeKO+wkngnm+b/98mQGWbqh+U0s2ViUejg7ElcW/dvKipx1d79hNIDNQlEJhrBPNLmrtGmoPK5I872Nfe3tRSqx9atsfdVfmeby6KsIUU2gKKyfVRtD/QBqX7WBzX5J8wb2LHiFqamAK0YdUR6js1rlbKCQQQpup43W+0z2fhiLlTwq1Z6HpuK4Kel7HK8YVPDVnSP1tRh3s/di4QOREB735HyBens8skJlYnR70DfcyTRlYXxLu6MTSlc4y+/vUbNGgPRRLmJdpdCj0Lb6/atTVTGo/8JOaqpTP9Iab0yfIAdvItSWFT5vDO2QPluqBSmdzRHLjKiLXtl2LsUaWdiJiDEa1OgVFj42S1lNVYgGg634ohBVNj8gHImUXArBDJzffaWL91XLe7FxgsNCxmWF1we2ITAzyXRUxhS0OHmZUgR868HwPRFt4UYGB7W7kZgJH1gxivru68XBS5DNKZPdf3VKtm700iFNwJnOy03mL8r35h69mp5eQc9g02E6w3PQZ3t4Ad5jGeWslqAl2mBBpZzXVWKjWsm7iZCyovnyjAUf06prgTUDhDTcdVUM9NwXTEwEQt8bbiCz5qHVSSQyNuYXUivStiQgwweQqFp1sDwo8gPXbQ1detqhgwDbr0ViLcUXRb2hhLG8VuAK2UneBTW1sQuTNpTtq5rbJvWQXlaa8q4ZfOfIIDBDbeaJ7ikMrXyI1HlWB2hoRoS9b7wR9hp95ijAxtDTc9pz5BIK7Acr+2JffDlQ+XAQ/sT6AyjzaeNNKeR+ZXswiNKkH4BONNRPwbD9AwmqvSucwXn0twcwhFA8QfkYTSUNFi
 P49MkgIM
 XJuV1IerQDmA1OKUIZN8zb7txD9iFMgeDeNCKkdvw4Eogz+fLJNc+iyy3yBGq9PX4VpRjDJ1Ekf+1M6osoRCLE8q5qzz7XXg1lPCa4jPus2dX6bnzoYLYIIe43ba4jPYf7slH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A write to /sys/class/bdi/<dev>/min_ratio (or min_ratio_fine or
min_bytes) that races with the removal of the device leaves the global
sum of minimum dirty shares charged for a bdi that no longer exists.
Until the next reboot, that share of the dirty threshold is withheld
from every other bdi (__wb_calc_thresh() scales by 100 % minus the
sum), and a later min_ratio store on any bdi that would push the sum
to 100 % fails with EINVAL although every bdi reads 0. Root privilege
is needed for the store; the removal is any del_gendisk() (a disk or
loop device going away) or the unmount of a filesystem with its own
bdi. On an x86_64 defconfig kernel (v7.3-rc7), 2000 rounds of
LOOP_CTL_ADD/LOOP_CTL_REMOVE on one loop device with a second thread
writing 50 to its min_ratio leak the share on the first round the
store lands in the window; afterwards `echo 99 > min_ratio` on another
loop device fails with EINVAL. With the fix the same run keeps the sum
at 0 and the store succeeds. Affected since v5.16, when the reset in
bdi_unregister() was added.

bdi_unregister() gives the bdi's share back with bdi_set_min_ratio(bdi,
0) and only then calls device_unregister(), which removes the sysfs
attributes. A min_ratio_store() that gets its kernfs active reference
before the removal runs to completion after the reset:
__bdi_set_min_ratio() takes bdi_lock, sees bdi->min_ratio == 0, adds
the new value to bdi_min_ratio and stores it in the bdi, which
bdi_put() then frees. Nothing gives that share back.

Move the reset after device_unregister(): once the attributes are gone
no store can run, and bdi_set_min_ratio() needs nothing from the
device.

Found while formally verifying bdi_unregister() against the kernel
binary.

Fixes: 3c376dfafbf7 ("mm: bdi: initialize bdi_min_ratio when bdi is unregistered")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    The window is between the reset and kernfs draining the attribute's active
    references in device_del(): bdi_debug_unregister() and the device
    removal (uevent, bus and class teardown) sit in it, tens of microseconds,
    so a tight store loop lands in it within a few hundred add/remove rounds
    under QEMU TCG. A store that lands there also fails every later min_ratio
    store of 50 with EINVAL, which is why the unpatched run shows few landed
    stores: the leaked 50 % plus a new 50 % reach the limit. The same window
    exists for min_ratio_fine and min_bytes (same helper), and for the
    per-superblock bdis unregistered from generic_shutdown_super().
    
    Reproducer (x86_64 defconfig, root, loop devices 20 and 21 free, QEMU
    -smp 2):
    
      gcc -O2 -pthread -static -o bdi_min_ratio_leak_short bdi_min_ratio_leak_short.c
      ./bdi_min_ratio_leak_short
      before: min_ratio 99 on loop21: Invalid argument   (exit 1)
      after:  min_ratio 99 on loop21: ok                 (exit 0)
    
      /* loop device add/remove racing a min_ratio store; root, CONFIG_BLK_DEV_LOOP */
      #include <errno.h>
      #include <fcntl.h>
      #include <linux/loop.h>
      #include <pthread.h>
      #include <stdio.h>
      #include <string.h>
      #include <sys/ioctl.h>
      #include <unistd.h>
    
      static volatile int stop;
    
      static int store(const char *path, const char *val)
      {
      	int fd = open(path, O_WRONLY), r;
    
      	if (fd < 0)
      		return -1;
      	r = write(fd, val, strlen(val));
      	close(fd);
      	return r < 0 ? -errno : 0;
      }
    
      static void *storer(void *arg)
      {
      	while (!stop)
      		store("/sys/class/bdi/7:20/min_ratio", "50");
      	return NULL;
      }
    
      int main(void)
      {
      	int ctl = open("/dev/loop-control", O_RDWR), i, r;
      	pthread_t th;
    
      	ioctl(ctl, LOOP_CTL_ADD, 21);			/* the control bdi */
      	pthread_create(&th, NULL, storer, NULL);
      	for (i = 0; i < 2000; i++) {
      		if (ioctl(ctl, LOOP_CTL_ADD, 20) < 0)
      			continue;
      		while (ioctl(ctl, LOOP_CTL_REMOVE, 20) < 0)
      			;
      	}
      	stop = 1;
      	pthread_join(th, NULL);
      	r = store("/sys/class/bdi/7:21/min_ratio", "99");	/* sum must stay < 100 */
      	printf("min_ratio 99 on loop21: %s\n", r ? strerror(-r) : "ok");
      	store("/sys/class/bdi/7:21/min_ratio", "0");
      	return r != 0;
      }

 mm/backing-dev.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 18e999053bae..fad1495d3b20 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1162,19 +1162,20 @@ void bdi_unregister(struct backing_dev_info *bdi)
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
-	/*
-	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
-	 * update the global bdi_min_ratio.
-	 */
-	if (bdi->min_ratio)
-		bdi_set_min_ratio(bdi, 0);
-
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
 		device_unregister(bdi->dev);
 		bdi->dev = NULL;
 	}
 
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio. After device_unregister(): the
+	 * sysfs min_ratio stores can no longer run and set it again.
+	 */
+	if (bdi->min_ratio)
+		bdi_set_min_ratio(bdi, 0);
+
 	if (bdi->owner) {
 		put_device(bdi->owner);
 		bdi->owner = NULL;

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0


