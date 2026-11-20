Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D150606C96F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mNnqvyQ2
Received: by kanga.kvack.org (Postfix)
	id 6CB776B05FD; Fri, 20 Nov 2026 13:11:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653B66B05FE; Fri, 20 Nov 2026 13:11:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7526B05FF; Fri, 20 Nov 2026 13:11:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8D3B6B05FD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AFA916012F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:41 +0000 (UTC)
X-FDA: 85456290402.28.48E5CEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B56F1C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNnqvyQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198299;
	b=vQlPFa+W3PIxeX96rAknV30dwD7rbU/yNDW6Aj1xzYcruuD7tB4cvdf5DvVpYi/aCddce7
	LILeITkm4nEw+Jja2RMx0KRw0bmu9EZSd55WNMQK+c0sxY5DoeEQsctZXBKPs6EBIPrY6t
	QszEpmHHb3aNnnHX23mHH2pMaVjFmOQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198299;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucJJo35EhYc8uBblcAl6XMSIzkyavztIGCd0YleD0jU=;
	b=XjiAuo7ZCMzsmI41+7BMzsAtz09Vq2IyQqqY4abnqd8ylRle6IgYJpAJM/o6IDBykuQ0Ny
	AWT3XMDbhLEU5woeCg2raKwES8sAFuTMBmVudHZOVNPiRVrpEPoNemgvTCu6rEldIqp89X
	UcdzCyIcwAy2gcJNrvlnM5E2umEuo4I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNnqvyQ2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C21743F78;
	Fri, 20 Nov 2026 18:11:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198298;
	b=HlWepT8N/RcO2s/f52O1bBRbe0iOHUMPaPhR87xFs9tXetsWsOyy0xjWxpodNqsUUhUi
	 hL/BYTSSDXGYthe5iyihrD00g7DeHSknGuL5gtJYVkw8g0RsuP/fBdFmIlQJSxTS36niK
	 jFN8iwpToh3ykHu3hMKlhLz4QcbjFH18N5x1pgNmqXPJq6aSMQ/S0bFGWhPyIs9Merwnj
	 xvcjY332d7H+BMAmXUsalrPv1KARYJGy9wbdD+M9CHhIKX6HHpw0fmcovuqRRAYpHupeO
	 ly+B18ry6T6nhOesYjS/feLBdyiJBwVKHYjtl2NQTrj1Eoy5jyV6iz+9e94fr750xMQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198298;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ucJJo35EhYc8uBblcAl6XMSIzkyavztIGCd0YleD0jU=;
	b=qwok757q/8PPHCg1OCK4PIvyTBUXJFw/zbbxwpt80Sd5HHp1kfGPy4GH8KJeqkMZ9Vz8
	 rEyd3Tf/jLapKhFXxJZMCn7jmRMVPM2IULIputNpijTXiJxgvNpjSmSKnmQ2kFBZOgdNt
	 6xzPoS6HB5j+mlzpVuDhBauXjnQxAhEEv7w/2ZqatQlckTz40zPxTmDhDwNiE17WjPVBn
	 ijG+s/VKyGyM3CMd1xqNVvTPGy9CUCq8bdtNX2v+thMksqvM8P+s8yxAqfVgsv1n1Ivu8
	 Sb6iFLVDNIvVRkV0KH7AyM38e/GPo+3ptajIxr2YPfo1L9FaiSCwkGwHMB97z+M7Qow==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D2F231F0157F;
	Fri, 20 Nov 2026 18:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198298;
	bh=ucJJo35EhYc8uBblcAl6XMSIzkyavztIGCd0YleD0jU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mNnqvyQ2S/y5CQ3mA5UeNg8lnQsxvgEbK0ggeNADbf2ogUHqJSfhZ3ENv/Vg2GWC1
	 Wb7mlVDUg4pb40GH/JQifTMpHDe76E6vaoT3/lMl4/KNJsfSm/JF+vTSfrFFLSn7yd
	 AJ0eGUuryC6mV4lNFEupta1pomX90P7oS1wEoPqVP6D9ZObc9sZk5qcn0IGCvqH8tL
	 I5/RpB3ClDRRGgk8r6EK8V6lw8/Fv2girBsKMVnOj4yXl2gu0kY92UPW0d7GOFtOA8
	 U8k9bctBc1HARihAhDOScJXhd0vCwRnCWri9+aKuSwlkMUDGPkyp4Uqbd0rinLZ1Dy
	 e5NY8tLWjxr9w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D3BA84B9A0;
	Fri, 20 Nov 2026 18:09:23 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:47 -0500
Subject: [PATCH 56/60] dax/kmem: add a private memory mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-56-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198154; l=5242;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=zrM1qpXNDU0W3OEbrrofBX3aJ+CtXsUD9H1wIf9M9+I=;
 b=R6sNzzY6t+TWBdJe7KJBQcoH3BsMwxDWl4rWxlfetNYs3LP+oZXkDWdpnsHICyDBXQ4HWIrdL
 DUshXIHhLEGAEndhFx3dYv0seeaJh6E4Ar1fYAuHjKqy+U87r8NL2cs
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zqfnaoac64t4w9kbbxsoudmctn3rrpw7
X-Rspam-User:
X-Rspamd-Queue-Id: 3B56F1C0006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198299-734444
X-HE-Meta: U2FsdGVkX19pOKitm+NiF/VRgCbHB01lh9XrF13nv4WMLMU7lQ/MJ+Q8MRogbPP+uzMtTVyLxZAc9AwfRzmT07bHdFAWQuL4DBWORZzfoyO0QTJ4bteSFIVra+YpXmShcOaYi/7Z7ZLoeNaYtMQ9asnMuCYJFRcTF0hVZ5TNH24NWO3i7/3Q9da7IGoSs0P3EoCoDc7gXW1eQyw8RqUzUALLt+7kwp+tqsY6oKdJIWdLQAXWaMiZ8ykUJ9d2g7nVlUB4oAowHKHZDdHSIbh/XCO+j8PGmKDD2GtVCjuvzEQf2m1gVe/dFsN6OGa/NH9QqzDamqnd5I3yz0W30DryhDtuTSLPjQRuk85rc72kQofYQ+5yVsU6c96uc1l6reakZylbW9d8Zw3NHoYLinv4Zg+apzZJDVAKXIua999bj9OGCUhq7cz6InB4nQFP0tNUD4GM/ksuDaLORH3E5A7LJPhPXjQJaC1CBku0jtNWvsQ88uFSQ95fT4r+DGpI4snG1jTasln6JFSTanxi4Ryf81jq+P4Mw1x5n2iP3dlVHvAww2m4UnBS6tfnq+gWgvdUDcxWPgzqqbUOEPigxEVP1k0ukIgsyDCZZUdi5DrtHyL1JlYvMQlLM/yWRY5fibMDXUQW5+qUpYzfI2dtmlt1c5/EjhwKVcQMEtmk+KPhWe7WaZj2Ul1P+xVI4sK0e5mh0GOmOruOhyaYFWtcHPm/jJWbOPYOpQ2YMeq8JJT54aLQTxujtJLsjcLjk5sef0ReA/KRsDi1ZiBtxVWARZjflId0PFOvU/iCmRxAtqmavi1YgUcGTQEbJrYOjjoVdQPH3W6cono7ZHRrl6TbexE5zTOhROc+kWqrRQ/gDVbN8dHsfTE8abMBnYrg/d83UouGZzHqos5Qxz1oX68fc3kzX/uO2q4lPoIPDH629K9HcCYQSh7oPI5f0fsovjJ0GUCNyZxv/b5FfIrpvY3f3jV
 1SN4XaXD
 Q7oOI8pEzzlC8G0iJnc6DKJNnkcppdflr0aaf30dUp/HcAdlTlH3TMoNXxiO9D0Q8PtrBJc9kRLZBjTHClq73j+S4tzBxZGRx8Usp6620c9cpfbBb+mrZ9L7btaYCJPmBz8Gj2d5Bj26fh8g+Capg+G+9YOaSJqBiFiRl6EaYF/4+PenpR8cZMkq3LZThMJhDamU+dgo9b3jiK0wcUYdMVmKa1m/3HCrpkosekorkNZmUCojuEn6GWtLM4tppRa6pmyyg/9r0tJPg3XH2DreIsxGunFmOBkyiTNJWh1OBieVw3jZi7dcCi6sQsesNzmpjJahU9k9DUJafnweW3MLz4+0xc9pBsbkxZgSqFXSGirwaOtcJCUsMgpad0h5qGUrqt/iAAVPHZskH5YWcYlniwhM021fKdNTJ/p0FR9SJlYX4hb5ccJFZDDxrBhmDF6x2yetBoECmV1S2ELd0ZMi60OL4X9WtwlHxy0ynqNRKQmUFeoMLI6ONLap6KGlOD+dStdlzKYJoyYj0IZEPvPJoIr6dpN1dV13h4aeOcvEpsZ30BYmMNXlPzXJKcodkbWzXzi45E9cc1NlHmtpusZ8quRMplwqV8KNFbX6oF6TROtQ6JmafdOI/wrk//zYqeEcXukEuSQRRgaMR3eb4KXbp0v8SWIWDnNPidsoOjpqUr+Plnp74gVYpyLbS5TAbzVjGblj4xfcQV9e0ZP5WPTlR28KXYD46XvIe5oRNmuZztLyaOPGH8mgXy1o2Yacl5cHrPSkFzR+ZF8bMPRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add a `private` boolean sysfs attribute, defaulting to false and
changeable only while memory is unplugged.

When true, dax/kmem onlines the node as private memory with
NODE_MEMORY_FEAT_MEMPOLICY, NODE_MEMORY_FEAT_RECLAIM and
NODE_MEMORY_FEAT_COMPACTION.

Userspace targets private capacity via single-node MPOL_F_PRIVATE_NODES
bindings on anonymous and shmem-backed mappings. Reclaim and compaction
manage the memory, and the system does not otherwise use it.

The attribute is hidden without CONFIG_NUMA or CONFIG_MEMORY_HOTREMOVE,
since selecting private mode requires unplugging the memory first, and
the default behavior of dax/kmem probe creates the memory blocks (an
unfortunately backward compatibility wart).

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax | 19 ++++++++++++
 drivers/dax/kmem.c                      | 55 +++++++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index 60703fffa99e..d024cf8e5ae0 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -175,3 +175,22 @@ Description:
 		A device can only be onlined from the "unplugged" state, so a
 		device must be returned to "unplugged" before it can be onlined
 		into a different state.
+
+What:		/sys/bus/dax/devices/daxX.Y/private
+Date:		October, 2026
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Select private memory when a device is bound to kmem.
+		Accepts boolean values and defaults to 0. The value can only
+		change while state is "unplugged", before memory blocks exist.
+		The attribute is hidden without CONFIG_NUMA or
+		CONFIG_MEMORY_HOTREMOVE.
+
+		With private=1, the next online enables userspace NUMA
+		placement, together with the reclaim and compaction it
+		requires. The memory is excluded from ordinary allocations
+		and from other memory management services.
+
+		Userspace can bind anonymous and shmem-backed mappings to it
+		with a single-node mbind() policy using
+		(MPOL_BIND | MPOL_F_PRIVATE_NODES).
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5ec653bc88f0..2954f22ececf 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -46,6 +46,7 @@ struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
 	int state;
+	bool private;
 	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
@@ -89,9 +90,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 			       int online_type)
 {
 	struct device *dev = &dev_dax->dev;
+	unsigned long features;
 	int i, rc, added = 0;
 	mhp_t mhp_flags;
 
+	features = data->private ? NODE_MEMORY_FEAT_MEMPOLICY |
+				   NODE_MEMORY_FEAT_RECLAIM |
+				   NODE_MEMORY_FEAT_COMPACTION :
+				   NODE_MEMORY_FEAT_ALL;
+
 	if (dax_kmem_state_is_online(data->state))
 		return -EINVAL;
 
@@ -126,7 +133,7 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		 */
 		rc = __add_memory_driver_managed(data->mgid, range.start,
 				range_len(&range), kmem_name, mhp_flags,
-				online_type, NODE_MEMORY_FEAT_ALL);
+				online_type, features);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
@@ -380,6 +387,33 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	return len;
 }
 
+static ssize_t private_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+
+	guard(mutex)(&data->lock);
+	return sysfs_emit(buf, "%d\n", data->private);
+}
+
+static ssize_t private_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	bool private;
+	int rc;
+
+	rc = kstrtobool(buf, &private);
+	if (rc)
+		return rc;
+
+	guard(mutex)(&data->lock);
+	if (data->private != private && data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+	data->private = private;
+	return len;
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -560,12 +594,29 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 static DEVICE_ATTR_RW(state);
+static DEVICE_ATTR_RW(private);
 
 static struct attribute *dev_dax_kmem_attrs[] = {
 	&dev_attr_state.attr,
+	&dev_attr_private.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(dev_dax_kmem);
+
+static umode_t dev_dax_kmem_visible(struct kobject *kobj,
+				    struct attribute *attr, int n)
+{
+	/* Selecting private memory needs an unplug, which needs hot-remove. */
+	if (attr == &dev_attr_private.attr &&
+	    (!IS_ENABLED(CONFIG_NUMA) || !IS_ENABLED(CONFIG_MEMORY_HOTREMOVE)))
+		return 0;
+	return attr->mode;
+}
+
+static const struct attribute_group dev_dax_kmem_group = {
+	.attrs = dev_dax_kmem_attrs,
+	.is_visible = dev_dax_kmem_visible,
+};
+__ATTRIBUTE_GROUPS(dev_dax_kmem);
 
 static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,

-- 
2.56.1



