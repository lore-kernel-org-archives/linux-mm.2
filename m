Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3EF0C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 01:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB0F6B0088; Fri,  4 Sep 2026 21:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8CB66B008A; Fri,  4 Sep 2026 21:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBA86B0095; Fri,  4 Sep 2026 21:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3B26B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 21:57:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C4481A0224
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:57:02 +0000 (UTC)
X-FDA: 85178045484.12.4739164
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 775394000D
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 01:57:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UF2mm+cV;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788573420;
	b=FtUqdnoykqdCxMTyKYsQHhLEJAMvetTyKnuX3ixGQ5rNAGGfVFC7uSnvtABvWGg8AApMC2
	GfHst08caN15wLuySRCStRzRO6cXYqNxphTN3xdgryYk/KMq/tOkkI8a8RPe6V9gkda+xI
	zrkv9vpabqqBhwR6VsZbnKuGkdHdD60=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UF2mm+cV;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788573420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntf0Gs9o5nHGu8zNmOc2HNk/o4BHxgRxMWIB2pzt8o4=;
	b=cW/8ekfOr9wbgj/RPyfQKPQgNga5Xd767JtXiTYWAJVRa7LhV9z9E9L196o7ttgtFHzgBf
	dtgPrjqpYmew0Iugkd7Tj0KfGSuB8IDeskMgjN8yz1FAgvpHjkaLmFeR7zfdagz0yJsjB4
	rO2pq3KdH5ftZ/F+0sZgN67XdEkT9JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A38B5600C8;
	Sat,  5 Sep 2026 01:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC991F00A3D;
	Sat,  5 Sep 2026 01:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788573419;
	bh=ntf0Gs9o5nHGu8zNmOc2HNk/o4BHxgRxMWIB2pzt8o4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UF2mm+cVyRVguVIyMXeo1zSa8ehJU05+xgU9XW/yThJCEM5wL9xkyCaKdw0jHiItR
	 jjlazVvNsQVsxEg7fx8vXy0Pm2/cBBXGzBwnBlQJ8tbQKgYlxDlDc8DcvA2HlI8/gM
	 p2QyoWJm+hqRTm26hBZOm1Ozdeh0s+rF3pvjyb2U=
Date: Fri, 4 Sep 2026 18:56:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Gregory Price <gourry@gourry.net>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13: warning:
 'node_is_memoryless' defined but not used
Message-Id: <20260904185658.cb3316b1d54ab7320620c26f@linux-foundation.org>
In-Reply-To: <202609050628.ywCLhOj5-lkp@intel.com>
References: <202609050628.ywCLhOj5-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ty9xxnxkkxu9s4y9eehuysfrx5n6yjk5
X-Rspamd-Queue-Id: 775394000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1788573420-967100
X-HE-Meta: U2FsdGVkX18rsLzUWHlAH7+6vUQ3V1tOgHxlRoEvnO+l98uGJV1xSNDHCjPKISGPYiFLFB/V0/5S4fAzAaHv2lQYE87yN/phcuIZPaIzc8rKfDnO7eOtvbabOkP33iCawEoa1pjjOdJo6PqwyXahyUnKhhfxfVtFm+o3iE4IYMQkGy38JK1DjBFDKnvt0YOKybYNqK9kPir4+RrxLMk9TTiP0Sp237DP9w/K2Y21uCRSEQWUJ/ppaXkQP7GCenfeSlbgRqwjaiNM7wM75WBsmroUa2Tz73dkN+2v/RR7tvCX/DHVN9ZpVOJ0T5JIgvBWlDizgcRC3BKgDBysW1j+x9HLa51rLslz4NcRXwhinVIwHu7CfHSaYo1Zx+XYnT29aAUsVaH83azmRz99oyCFg+gKWGrwIeqKVFYSqdyPi3F0fwFfJwq77vFcQoX86Y7vydP6kVt3d5ICdIfCZRDzP2nBLySVgrWy9NypVkDyKXZ+xKDuc0rl2fQlaQs0sizaD1zgbEXWW54FGGefGXEZy7Qd/ppKu6iu8QkzNobU1v4wTJqfZW/usYg1mOohXg9JOHmQA/ECnBNq3dMU65ghXDK45DFNzDI/yT9AFNlb7s86sX3ZrAKttZ90z2BOD0NFSzRMD/x13SdEtxzT/FbuWh9LnEjK/QeifHxVUsu3nnrvCvsqXmynJaC9+9NzkYCTItjMAv+SAK5ZpW727bmEoCCMhPs6o54TrYyQfLZWgqQhTOgvAJwvdQByVVy/IvNzNCGNOdQea1AZ984Q8ij75/UofqyoLFFUdC1myrVZPkbEry2AY1pZioo1PZgyMAsR181ePjQ7FjqA75x7oOVd6WCUmaveaxMRXXsCrn2c0nClNrjF5oMOcHXYFiYqVJmZsDysAI6RExn9L0ufJaYgaNCODCGXJgjdp0ksMqr8ghWRpB1dP67ut1afalHMQzsCSpOkiB5CNCkivpE3Xeo
 juYEa4Sp
 MtnB/Jn2iRni88b0wqfEmlvhAOtFLMYd4fZar08d5PzNPH0x4J+3Kc/FcSSO6zw3Kvz5lqog8ZjQf6zxfm+54x2tjGNNk3B+j79vo9gd5XIcHyYjA4w/r6L0sYoAGpNI3MARVkzv5JYm/Ih+vhYgr6BXo8QETns7mJjZwO86G4A3IjIm627tWWkgaxjPVozoO06EXayIm98nXA7Q/9DErWat6spv3/hEIsvIwOHPMZFfUPX7EPmS43Pl2mA1FMu1VkN9VhstxFl7/lgukERmxCpLxW1niBoBLUZJzZXJoZoXOUJKCACcCs7OP7f3hLLICCU6MAdNV7kXV7oUKamRwDmc6zAmwpjdbW+Wfr28CoS+R/SGYz5EvGkeRGmXoDWqc8JrOfhDYKg1HEvJ3SyErP3O6DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 05 Sep 2026 06:32:19 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Gregory,
> 
> FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
> config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> smatch: v0.5.0-9187-g5189e3fb
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
>     1507 | static bool node_is_memoryless(int nid)
>          |             ^~~~~~~~~~~~~~~~~~

Thanks.  Let me try this:

--- a/mm/memory_hotplug.c~mm-memory_hotplug-factor-out-node_is_memoryless-fix
+++ a/mm/memory_hotplug.c
@@ -1491,36 +1491,6 @@ out:
 	return ret;
 }
 
-static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
-{
-	int nid = *(int *)arg;
-
-	/*
-	 * If a memory block belongs to multiple nodes, the stored nid is not
-	 * reliable. However, such blocks are always online (e.g., cannot get
-	 * offlined) and, therefore, are still spanned by the node.
-	 */
-	return mem->nid == nid ? -EEXIST : 0;
-}
-
-/* Caller must hold the memory hotplug lock for this check. */
-static bool node_is_memoryless(int nid)
-{
-	/*
-	 * A node still spanning pages (especially ZONE_DEVICE) is not
-	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
-	 * e.g. once a memory block has been onlined.
-	 */
-	if (node_spanned_pages(nid))
-		return false;
-	/*
-	 * Offline memory blocks may not be spanned by the node yet, but they
-	 * link to it in sysfs and can be onlined later, so the node is not
-	 * memoryless while any remain.
-	 */
-	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
-}
-
 /*
  * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
  * and online/offline operations (triggered e.g. by sysfs).
@@ -1815,6 +1785,37 @@ bool mhp_range_allowed(u64 start, u64 si
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+
+static int check_no_memblock_for_node_cb(struct memory_block *mem, void *arg)
+{
+	int nid = *(int *)arg;
+
+	/*
+	 * If a memory block belongs to multiple nodes, the stored nid is not
+	 * reliable. However, such blocks are always online (e.g., cannot get
+	 * offlined) and, therefore, are still spanned by the node.
+	 */
+	return mem->nid == nid ? -EEXIST : 0;
+}
+
+/* Caller must hold the memory hotplug lock for this check. */
+static bool node_is_memoryless(int nid)
+{
+	/*
+	 * A node still spanning pages (especially ZONE_DEVICE) is not
+	 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
+	 * e.g. once a memory block has been onlined.
+	 */
+	if (node_spanned_pages(nid))
+		return false;
+	/*
+	 * Offline memory blocks may not be spanned by the node yet, but they
+	 * link to it in sysfs and can be onlined later, so the node is not
+	 * memoryless while any remain.
+	 */
+	return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
+}
+
 /*
  * Scan pfn range [start,end) to find movable/migratable pages (LRU and
  * hugetlb folio, movable_ops pages). Will skip over most unmovable
_


