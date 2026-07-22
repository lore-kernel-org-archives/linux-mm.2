Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6328FC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFFD16B007B; Wed, 22 Jul 2026 03:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0666B0092; Wed, 22 Jul 2026 03:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EBA6B0093; Wed, 22 Jul 2026 03:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97E676B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:48:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2069F1C0560
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:32 +0000 (UTC)
X-FDA: 85015635264.06.7A79922
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id D74B81C000C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X+uJzJHX;
	spf=pass (imf20.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706509;
	b=GUsjMBI3nPGrBVJ43l1YB8kGGS9qBqtMcJNM5gsNnhfJ6n9fiO7Gif3kZDsfRoTgS1YHi6
	E8DodjKk3XDbZ0jOboKZlHdDfMyboXiuIthX+Ll0IZqQEDEuYzmmrSbdHZkqLocYBzAoDa
	flNUoT+rCcq2pLX3KfeYqYtzi2pf5J0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=X+uJzJHX;
	spf=pass (imf20.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oQsvWeF08xm/cz62QQ7JV6m3YH3pHdn8PCl60XvFBbI=;
	b=VsOmui+A0k+7P0XCeb8jPUhbqRzdDooeBDQCMvUkjZh7wGSoRfM6K8vAx2j3Ps7SlB8eHZ
	fhJFerNPzUPIRdTlEAI9DdQgpDicl05sniPgcEKQtA1JgVV6yo1HZpUGHP4PG3D92muauh
	/kcqCKFT6caXyZUEprCOArqHqA9u6wo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5Bn1S3152888;
	Wed, 22 Jul 2026 07:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=oQsvWeF08xm/cz62QQ7JV6m3YH3pHdn8PCl60XvFB
	bI=; b=X+uJzJHXFTJRkUmO1eSuxnJTqF5cMBVbPSdZZNMyFp7PuRLPOetdVfQy6
	DS7l8Pu0vRoEx0g0ZO6h04/wri8Hb5zldtKQ7J/GLfJUH007LJXUev7SbBD3fT82
	y0Vl0G/RBsrIc4L+ddCMEYKZbOJ3tgxVciTpkmiHtvTr8Lvb/PhYku5y/GKbsYeQ
	nNa1JNd/AXMiqYo5enkG70uqQ4N8ksiiJBzgOu501ZmHAHq73ZITd/SdYfXRQ+E2
	RaUc2KMd8QFwB3oLShFqFORuX0xZ6N4wCqGTbOBAmiLStgKzgdNAl+sop+LspQ2h
	H2G+Huqie8x56fzDjl+Cv726iO6Mg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ah8ftk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M7Ydav006030;
	Wed, 22 Jul 2026 07:48:18 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ge2d3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:18 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M7mGu320906642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 07:48:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CBD4200C8;
	Wed, 22 Jul 2026 07:48:16 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACD86200C7;
	Wed, 22 Jul 2026 07:48:12 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 07:48:12 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH 0/2] mm/memory_hotplug: bound offline retry loops with a configurable limit
Date: Wed, 22 Jul 2026 13:18:09 +0530
Message-ID: <20260722074811.378283-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: uH3J0IC4BLQRRc7TsamBY_18RwlwdEy0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfX2fR/wqvrPdZ9
 gcSBOJS21TlRH5KV8QeQRc/tONQ/R98JJTaplH1zsrzDA0PvDFQUGPczxZxO336O4VS58CFzA74
 6cc5Vw5pZ9NuDq/cFo0LQi9RdHw6VftINfZIBgbYWPVKdlrOz6QKGMt2v+xFU4b7VoPzIuMf4Ja
 v/4erICiC7p2z8dal5lRoRSX9aSuj+9jVCIm0o6x4S/660+VAelh0mNTTW7J8Ks6WIgz36cyP3X
 khV0VMDleakdKr9QXQgbzzRlijMNJyRFiGQMz2MKTuHLOoeIGM45L8vJTiDPpMaWimJSSpevfVV
 fQex825+9dgZiXovXRtRzC6N4N799wkkY+6X1h4EAWEX294sNVs66TotNwKxTPvB9rE/vHSvaBD
 nN0DcUePNFeeVVzvNvzFv884n+18MkwoqKN+R02E/8eTxXeAfr5nUjVt9sKDyHJqHtjkDnPp0V3
 lp4tfOQRyMNqpT0pu8Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfX+KoMIT1OvV3v
 XdxoGeL2On0HYyU3/5+9UnAMwlCpYltb9UOvhLdXdnP5DWGXziDAgTdZMoTsMkpv5AkUUHhs7qN
 cAQIX7AyBbbytZwx08LpUbAE2ZRQeAY=
X-Proofpoint-GUID: 5_BFTVUCTNJ7UATzgwzC30MdyJE3QD6G
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a6075c3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=zej21AwQAAAA:8 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=giDV6BoF7Npqmo5PyuYA:9 a=ztjCmhadxVTV2ceFFhsz:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220070
X-Stat-Signature: aja3nagw5hoz8h9kgtffig9mfn5ig1ta
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D74B81C000C
X-Rspam-User: 
X-HE-Tag: 1784706509-883056
X-HE-Meta: U2FsdGVkX1+g3ysXGx75Si4WOWUb6SLHitJ4zSHSZ9RqAbaJBIPRkKH8qtat/LCXVYlANsa3p3hn68xCvXFMKR7i8dOWUKzF8+vZAvZ+7i8AvOAc/1HYMqIYtbvKMfElRO5uKtKXbHcMlvSRGofUO0GDvqkYybNwhwGqNQUfHjXx/LScWmCNM6HRj2fti2+YN+gyDkCV2Bdk420nzBNhCHd6uyUUFzkuqGVpaQ4RqTltUDCHgRoa3iMAF2u7Y05iRcH+h6V+vNT4Zn/Uwj3sm2dt7DFoTU3zEiHI8hcgtWB1kX0jqTxr8O/1FhjtpvK7NgpB6DuKOnWXrEZtq1z3He6J4oFimijmdhPkAFGsyF+DRZpzleVQ9LZ7Zo1zgvzUCfTNzDFDbANbO6rjobQR+FQ+X7ZqNliE1EVjwoNsQpev0ygkab8i86kzElGwC9efskqUDCQ7TaduAx5J+P2gVarcalEJlisnRyUlSuooC9fbQhX3O6s7MDnipZcmJjuq6XsBDxeMMVMngbL9K0ui76bZKSum3IIoXhyBSIcC7weRpj5ZuujvjBSTu8/ARpo0UZK68ctOE2u0p51UVviK8nW+FAN+1KpXjut1f+ilnjPOvnJ72lfS7J1HiMnhn2W0Squ5e8mEcHaUS1hZKv7wPsMG0HP/coM1NTjti0cF/1DTTjSkSAGxhaUBT3Plh95k1Yp5Vokx1OkLTykKmOi+83EsR6MquoaNop5mUHp6GP5a7Szw4etSiesH8fejVYJQdigyi8mKI9Zk7qRniVYeIT0HTAXRB76DeOy+5nQapB1oKMAoJHGe7/xBTa93ajQG47SpCRt1d0O2ypVMOvjkGyF1AF+f9sLLktUG6aXEWFQC7S9Rdu5sUhlMIyIsN6ZFJU71xKDPQJZ60WdLYk4NQxka80U+MIf5iSDNWtThndSH4UtiMYyih+9zwB3wguSswY/geAAGIqi/KQkpDf8
 1hfQoKrL
 eI+UFkOOEfhkRAXuQgTVF+O5COVXpKxd4l+SWBrxKDgAelB/jgkMJMRFJcQYpUk1CBXBrWMRt0xrG27wiTWOT3q/VoBgRvoHI10wnMjpdSz0G1Vykf2yEBgFcZgBIz8K/vvempl+sgkVjivdwfoUYz9NvPloueLOyaqjmxNhxnArwOya/ffp9WGDUxHFUgP1IXAEv5M4vPh+gQ4pirfo3rZlwhU6n/e1XQYubwTB8HMWIXRx1tb7ooMNHakpBl+njJwIVsdl5rFfyLpIynzUNMT7vcyyixRxN4OBqGBzAQsPTR0TE/KScFh104NAys0ruQJiYSZjKl9N/ihF7pdC9xpYz3BjDQEs2kDsZ3t4WH/Iks1K0yNxPaXrAp+A+NLFNSMBE+9t2GaAuJ89TJ2R/ytaInQyvcub126AabbZ3zwt8CMF3/v1W4yiigqkr3kDOYD6VmDLaKT3xfyXZUGEMmh5JngfqCGQ//LLivix6vCZjZX6A9AeyyM8iIpbPzwMLbYmCTCiq69l0Kmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory offlining can loop forever when a memory block holds a page that
can never be migrated or freed.  This series adds an opt-in retry limit
that lets offline_pages() bail out with -EBUSY instead of retrying
forever.  The default (0) preserves today's behaviour exactly.

Patch 1 is the fix; patch 2 is an in-tree selftest that reproduces the
hang from an unsignalable kworker and verifies the limit recovers it.

1. The problem
==============

offline_pages() repeats two nested steps until the whole range is
isolated:

  1. Inner loop: find and migrate movable pages out of the range
     (scan_movable_pages() + do_migrate_range()).
  2. Outer loop: re-check isolation (test_pages_isolated()); if not
     fully isolated, go back to step 1.

Neither loop has a termination condition.  When a page can never be
migrated, scan_movable_pages() keeps returning the same pfn,
do_migrate_range() keeps failing on it, and control never even reaches
the outer isolation re-check - the inner loop spins forever.  The admin
guide acknowledges this:

  "Further, memory offlining might retry for a long time (or even
   forever), until aborted by the user."

The single escape in the loop is signal_pending(current):

    offline_pages(pfn, end_pfn):
        do {                                    /* outer: isolation */
            do {                                /* inner: migration  */
                if (signal_pending(current))    /* <-- ONLY escape   */
                        goto failed_removal;
                pfn = scan_movable_pages(pfn, end_pfn);
                do_migrate_range(pfn, end_pfn); /* may never succeed */
            } while (pfn < end_pfn);
        } while (test_pages_isolated(...));


2. Why the kernel itself should be able to bail
===============================================

We keep hitting this during memory hot-remove operations: a single
stuck page can block the whole operation.  This was also reported in
[4] earlier; one example, where offlining kept failing to migrate a
busy block-device page-cache page (aops:def_blk_aops) in a normal zone:

  [10880.889199] page dumped because: migration failure
  [10880.889232] migrating pfn 2a87b failed ret:1
  [10880.889235] page: refcount:3 mapcount:0 mapping:00000000718ec5a6 index:0x857 pfn:0x2a87b
  [10880.889241] aops:def_blk_aops ino:800003 dentry name(?):""
  [10880.889245] flags: 0x33ffffe00004104(referenced|active|private|node=3|zone=0|lastcpupid=0x1fffff)
  ...
  [10880.889291] migrating pfn 2a87b failed ret:1

A userspace-driven abort (timeout + signal) covers the common case
where the offline is requested from process context, e.g. a tool
writing to sysfs or an "echo offline > .../state".  There may
still be scenarios where handling this in the kernel itself is helpful
- for instance, hotplug requests that are processed entirely from
kernel thread context.  An ACPI DIMM eject (kacpi_hotplug_wq) runs
offline_pages() on an ordered workqueue, where there is no task to
receive the signal, so the loop's one escape (signal_pending()) can
never fire and a stuck page also blocks every hotplug event queued
behind it.  For example, an ACPI DIMM eject stuck in the offline loop
looks like:

  task: kworker/u16:3   Workqueue: kacpi_hotplug acpi_hotplug_work_fn
  Call Trace:
   offline_pages+0x...
   memory_subsys_offline+0x...
   device_offline+0x...
   acpi_bus_offline+0x...
   acpi_scan_hot_remove+0x...
   acpi_device_hotplug+0x...
   acpi_hotplug_work_fn+0x...
   process_one_work+0x...
   worker_thread+0x...
   kthread+0x...


3. Prior reports and proposals
==============================

Variants of this have surfaced repeatedly:

[1] 2020: zswap/z3fold pages made offlining loop forever;
    isolate_movable_page() permanently failed and the same pfn was
    retried indefinitely (same "isolation failed" signature as [5]):
    https://lore.kernel.org/all/D90B73BA-22EC-407E-838F-2BA646C60DE0@lca.pw/

[2] 2023: a proposal to bail after 3 consecutive migration failures on
    the same pfn.  Nacked: any hard-coded retry limit leads to premature
    failures; pointer to userspace-driven termination:
    https://lore.kernel.org/all/20230428100846.95535-1-yajun.deng@linux.dev/

[3] 2024: a proposal for a hard-coded limit of 5 migration retries
    (fuse temp-page series v4 4/6); dropped in v5 after review:
    https://lore.kernel.org/linux-mm/20241107235614.3637221-5-joannelkoong@gmail.com/

[4] 2025: ppc64 hot-unplug hang on aops:def_blk_aops migration failures:
    https://lore.kernel.org/all/7ed99822-9d63-4c6c-a492-d4820abebe18@linux.vnet.ibm.com/

[5] 2025: ppc64 hot-unplug hang 20+ hours on a single slab page failing
    isolation, also blocking pcp_batch_high_lock users:
    https://lore.kernel.org/all/d35eca2bbdf8675c43d528571bb61c7520e669cb.camel@linux.ibm.com/

The common failure mode is the same: when migration cannot succeed,
offline_pages() has no way to give up on its own.


4. Why a configurable limit, not a hard-coded one
=================================================

The kernel used to have exactly this bound with a hard-coded limit of 5
migration retries plus a 120s timeout removed by commit 72b39cfc4d75
("mm, memory_hotplug: do not fail offlining too early") because
hard-coded policy caused premature failures on large machines.
That commit explicitly left the door open:

  "If we need some upper bound - e.g. timeout based - then we should
   have a proper and user defined policy for that.  In any case there
   should be a clear use case when introducing it."

In general, it would be good to have this handled in the kernel as
well, by providing a configuration option: a user-defined policy, off
by default, that lets the kernel bound the retries on its own.  This
helps the kworker paths above, which have no userspace to time out or
signal them, but it is not limited to them: it also gives ordinary
process-context offlines a way out when the userspace driver does not
implement its own timeout/abort, so a single stuck page need not wedge
the operation indefinitely.


5. The fix (patch 1)
====================

A single counter at the top of the inner migration loop bounds the
number of migration passes:

    max_passes = READ_ONCE(offline_migrate_max_passes);
    if (max_passes && pass++ >= max_passes) {
            dump_page(stuck page);
            ret = -EBUSY;
            goto failed_removal_isolated;
    }

Both unbounded cases pass through this point: a stuck page spins in the
inner loop without ever reaching the outer test_pages_isolated()
re-check (so an outer-loop counter would never fire), and every
outer-loop restart re-enters the inner loop.  Either way the counter
only grows, so the limit eventually trips.

Because the value is re-read every pass, writing the parameter aborts an
offline that is already stuck - an admin can rescue a hung kworker
without rebooting.  On bailout the existing failure path (shared with
signal backoff and unmovable pages) un-isolates the range, sends
MEM_CANCEL_OFFLINE and returns -EBUSY; the block stays online and
usable, and dump_page() dumps the offending page.

It is a module parameter, default 0 (unlimited = today's behaviour); at
0 the check short-circuits and there is no functional change:
    boot:    memory_hotplug.offline_migrate_max_passes=
    runtime: /sys/module/memory_hotplug/parameters/offline_migrate_max_passes

Alternative implementation: stall timeout
-----------------------------------------

Instead of counting passes, the bound could be a stall timeout: give
up only after some time has elapsed with no forward progress.  Any
successfully migrated page resets the clock, so it fires only on an
offline that is genuinely stuck, not one that is merely slow:

    /* give up only after X ms with ZERO forward progress */
    if (migrated_a_page)
            last_progress = jiffies;        /* any progress resets */
    if (stall_ms && time_after(jiffies,
            last_progress + msecs_to_jiffies(stall_ms)))
            goto failed_removal_isolated;   /* -EBUSY */

We are happy to send v2 in this shape if that or another approach is
preferred.


6. Testing
==========

Patch 2 adds tools/testing/selftests/mm/vmtest_memory_hotplug.sh, a
self-contained VM test (virtme-ng + qemu, boots the just-built kernel,
no rootfs/QMP).  It cold-plugs a pc-dimm, onlines it ZONE_MOVABLE,
vmsplice-pins one page, and ejects it from inside the guest so the
offline runs on the kacpi_hotplug_wq kworker; this reproduces the hang
and then rescues it live.  The vmsplice pin is a deliberate, targeted
reproducer used only to make the hang path reproducible in a test VM.

Actual run (kernel log timestamps trimmed):

    TAP version 13
    1..3
    # DIMM memory blocks: 32 33
    # pinned one page in block memory33
    # ejecting /sys/bus/acpi/devices/PNP0C80:00
    # block memory33 going-offline, holding 10s
    # do_migrate_range+0x1eb/0x260
    # offline_pages+0x361/0x520
    # memory_subsys_offline+0xdb/0x180
    # device_offline+0xd0/0x130
    # acpi_bus_offline+0x11f/0x190
    # acpi_device_hotplug+0x1e8/0x3e0
    # acpi_hotplug_work_fn+0x1e/0x30
    # process_one_work+0x16a/0x310
    # armed offline_migrate_max_passes=50
    # memory offlining [mem 0x108000000-0x10fffffff]: giving up after 50 passes
    ok 1 ACPI eject kworker hangs unbounded in offline_pages()
    ok 2 stuck offline rescued by writing offline_migrate_max_passes
    ok 3 memory block online and usable after the bailout
    # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

The test SKIPs (never FAILs) without virtme-ng/qemu or on non-ACPI
arches.

This RFC is to discuss the approach and find the best way to address
the infinite retry loop in offline_pages().  Please let me know if you
have any comments. 

Thanks,
Aboorva

Aboorva Devarajan (2):
  mm/memory_hotplug: bound offline retry loops with a configurable limit
  selftests/mm: add pc-dimm ACPI eject selftest for offline_migrate_max_passes

 .../admin-guide/kernel-parameters.txt         |  14 +
 .../admin-guide/mm/memory-hotplug.rst         |  26 +-
 mm/memory_hotplug.c                           |  38 ++
 tools/testing/selftests/mm/Makefile           |   3 +
 tools/testing/selftests/mm/config             |   3 +
 .../selftests/mm/vmtest_memory_hotplug.sh     | 369 ++++++++++++++++++
 6 files changed, 452 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/mm/vmtest_memory_hotplug.sh

-- 
2.54.0

