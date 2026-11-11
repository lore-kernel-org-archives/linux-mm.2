Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4E6606CB2C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ul6g87vr
Received: by kanga.kvack.org (Postfix)
	id 9BBB16B05B2; Wed, 11 Nov 2026 13:14:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992676B05B4; Wed, 11 Nov 2026 13:14:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0166B05B6; Wed, 11 Nov 2026 13:14:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1036B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:14:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B895FC03EB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:16 +0000 (UTC)
X-FDA: 85423637712.20.5B637D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01B451C000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ul6g87vr;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=P77y/7kt1y7+rX559SuEiGkJe08l/ufdA6D5PwoUHF8=;
	b=r7l9IR4bPRRCF1BibjEUtScyPI8B4LQP+ld/ag2W2pMKj8hA9ld+9fnTb3beq5mvHrmnuB
	DFTWwSPLHLzSu6xKDIb4HrVZUepAZ0PkiVQee0utP1pgkb9Fs/gCDtKoA0ZoogVAhPdzwF
	0/aqwHZS8tyaK5CcMxfySCo8UuanYKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420855;
	b=3uoTwtQkbFMKp0nY8H1xk6/1Qow/BD7ktulO6C0O+OAvSxp6TiZ0dMaZ7xZAdO2zscBcic
	Xg/UnPGfae8yJ8wuOPsfN609+O5g8hrlHLfn9NEBCpuURpJF0Ke0u5lb3HPCdhMxVvbW7h
	pCRBrRO3ANuUxXk7C5P8FPt6WrWShlY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ul6g87vr;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F2A96353B;
	Wed, 11 Nov 2026 18:14:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292C91F00A05;
	Wed, 11 Nov 2026 18:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420854;
	bh=P77y/7kt1y7+rX559SuEiGkJe08l/ufdA6D5PwoUHF8=;
	h=From:Subject:Date:To:Cc;
	b=Ul6g87vrcahtCdQQl18AuyzeILV3lOpch0X+0iIicnk0DlFQfuQXsmH9TaKZlQL/S
	 WjDLYnab3GQJwmbI9XfT1YShrJPtcnxuFDsaCS0yeUehxX53peguu1LeEqugWcT/cY
	 o8QG6XaUY5RInTkZy+ihZhQfRXGT/QLcSrXJr0xJc3MAIrV21R4YgwdDxn5d+eT6KP
	 MLlMz3gS1TKsARmHMDBHBZcR/zOC69qflX3oCBKrUE71W5RT5C0085C3gWBqrnZE5x
	 Ou3wpKGynuq0cReHCBYykC6OBFahHTbtVFSKZdlv3wFgVH7GvjBdqv6/vCypO8WAgq
	 HVUFXq0FaggHQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 00/13] mm: batch of (urgentish?) fixes in oomk, cachestat,
 dev-migrate, percpu
Date: Wed, 11 Nov 2026 18:13:14 +0000
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3LSwqAMAwA0atI1gZaDf6uIi6KRg1olaaIIN7d4
 vIxzAPKQVihyx4IfInK4RNsnsG4Or8wypQMhSkqa02Nu9PD4y5LcJGRI7oNZ7lZ0VBLU0lNQyN
 B+s/Af0h7P7zvB5HA7NZrAAAA
X-Change-ID: 20261107-mason-migrate-et-al-fixes-0494d34884c4
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2003; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qNocdPfgYdCqYkS09WXKZzoMqv0tyceAP/BmWJ6twEY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMh6/jjggEma/N5V3S07XynbZuybunzBqwu5UlJrv
 WJmeO2e0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJCB5kZJjzxOxws0rvo5nh
 an+Tm1ZIePvFZaofOV4ukycVd26OHT8jw5p7drqvkg04c+4cX/256vjk2ds3znor/5nFZdLC0tw
 yRjYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: wwie1dy17cz655gexzt99wx1hrxwm85j
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 01B451C000E
X-Rspam-User: 
X-HE-Tag: 1794420854-612800
X-HE-Meta: U2FsdGVkX1/85pCndY/EOvsFW7tb+rwR2My24GWtk5pX5+e299YnSMOZkRJw8XGK2e3QS4ijWz3gw9EBhKHml1N1TPc9xLYcGnFjv967XaEcHh9lU+r2wdpMzMznszC0BncpCwTk6kZwDvkKg7BzA9nsNvyzhf33Ebw99i03hPk9/8YSB8L3OBsHky4NFzxPxScfHi7alCqjZSNN++Ch0ARmg7aFP33bnrK6bEA/8Kd23a4Lm3c8vE0Ks5jH7lvb9Glq10i3uko08Z34IXAOHI99YvQHoUWmqa8IKCZcvuvAJmNCqt4yGNZjjeYmWlnLAHC2KeQS7WtiNmszmdKed5Gd5QMThJOajWzRxKXXkaA//JyjFrl5ldFzhacP4DAAevQR1T62EVOS37t+vPo6+LIfcCtmRf4i27cu/RQEMsb2C9YoaGzQp+AFQozBgurpXcbo1GcB4lZSI6gX5AhWjVS+mqn48kBk1Ur6SpbWxVqz/ayTXmUD8csGgBSfl4rY9Rko9OoMkSkATXngWPTpPuDOahcrF12VRHmt5rt7AQR8DeREHM/0gDqO8gpSzihAf2qo/6qFGYTLhhAvfUnWyZj0S4FkmPWbC7UqlIYvkQJGAGLK5xTgprxnBGpCPD6OUNDeInKmYwHNJ8oX5GbN0zSa2I9znuQcrVpaR+WlAXJLnjEIndWBm3T5vNA/vT//wllMepUD9NpuvnZ1tDLeeIjAdeGpupAebBWS8hUI9H8llGcbw3PcC1gC6ntyTTvYzrq/Gmr9IsNdJuvVLjfMsfbCFpJWSaMyxefO/s+6Qwz/Rg5QHVxA+R6oxaKbtjzESQDFUJIdnL8Dyoh0xGBvvCMCPqwCiR+jbbHe0JxRJq9qNlPHLAf4cnuXpFgQ1htkBxLV7aKUgkU4VScwnAbdWlDs3NVagbbX+WNf2vjSi9ZZhmLVnjX2doELpJbAKGmx9ZjwhzFIFU4DYou0ynm
 25DI/SPz
 dfBV+K5SWGDc6JI5T68NLtPQZBfNIVeF5i/Gi7K9Ditd4l+VjZIifnpCV/DJAtS110OdqVws3Cd7s+tzn6Ncda3744KklTQKmGCd+WhGDhK/ocWQCoSpXzZbEqZQqf0zKB7PjEpIZHElfNcYCIP6SPe5sVh61+vMmfbBWgt908m8N6Ylj2Mo9CZVbNI3/1rWRXUTY4pprWPIrcNRoijY22T/xdlRhQHeuvHBJoivCZHY8RcXEYzSTAiMTGoj8tgnW5KHw4wad2PizfMqrUt9USBQtvWgksEUjcyjpeGql0MdaKCodgYUV5qTOFWIlpS9k4gVY0ipW6ODE1dDHtGRkOllzrn6LRWxNCk2qHr2GumT4FmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A bunch of fixes for oomk, cachestat, device migration and the per-CPU
allocator.

These patches were originally AI-generated, tamed into upstreamable state.

Some are more reworked than others. Those which needed a significant
rethink are submitted as mine and marked as Reported-by the relevant
original author, others are smaller edits which are annotated as such in
the usual fashion.

Please check for correctness, sanity, and whether the cc: stable is
warranted (I have not included it for 3 where it seemed unwarranted.)

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Chris Mason (5):
      mm: cachestat: count each page only once
      mm: cachestat: restart the walk after each entry
      mm/migrate_device: fix ksmd oops on a migrated KSM page
      mm/migrate_device: refuse to migrate shadow stacks
      percpu: queue the balance work on an unbound workqueue

Josef Bacik (4):
      mm/migrate_device: allocate THP deferred split heads
      mm/migrate_device: don't collect a range twice
      mm/migrate_device: don't let go of the fault page
      mm/migrate_device: look up fault folio after a split

Lorenzo Stoakes (ARM) (4):
      mm/mmap: free gathered pages before MMF_OOM_SKIP
      mm/migrate_device: fix use-after-free of the anon rmap
      percpu: fix contig hints that are too low
      percpu: search the whole reserved chunk

 include/linux/migrate.h  |   1 +
 include/linux/mm_types.h |   2 +
 include/linux/oom.h      |   9 ++++
 mm/filemap.c             |  21 ++++++---
 mm/migrate_device.c      | 111 ++++++++++++++++++++++++++++++++---------------
 mm/mmap.c                |   9 +++-
 mm/oom_kill.c            |   4 +-
 mm/percpu.c              |  69 +++++++++--------------------
 8 files changed, 136 insertions(+), 90 deletions(-)
---
base-commit: 7f04048247a69019ccaa9c152002d3601b19453c
change-id: 20261107-mason-migrate-et-al-fixes-0494d34884c4

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


