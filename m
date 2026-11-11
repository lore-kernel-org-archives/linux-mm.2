Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6A5606A335
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=o7prbt93
Received: by kanga.kvack.org (Postfix)
	id 3E09D6B05BE; Wed, 11 Nov 2026 18:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7416B05BF; Wed, 11 Nov 2026 18:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE6A6B05C1; Wed, 11 Nov 2026 18:03:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 003C66B05BE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:03:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 883A016043F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:03:51 +0000 (UTC)
X-FDA: 85424367462.07.C6B9AC3
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf05.hostedemail.com (Postfix) with ESMTP id 63103100011
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:03:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=o7prbt93;
	spf=pass (imf05.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZpZWYLtWRnBPFXGp6OY8AG/et/NJXXX+J/qVt0UTEw=;
	b=Tr7mnPfZnTFXHI3gx4sn+STwFR9CID2iRbhZUj8s89eMQLqh49W098iOcmY86pMhb/gYnr
	MvN5akAZ6m0cbBYwF0xXi09TKk51B4GZu+ChL9lRrrQK4EEBK2Tzm7vRBr+V4IN5WkRigF
	Hq4TXZ0yjtuFdy7MnWRM5oYHPeP90yc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438229;
	b=AcaNKv/BO5Y7J4Os0fPWVRQoqDjLE8UzmhT60PkB36e4dJ4RrAQ7m9yVofxaGPpTwHv2Zi
	kmbfxkK9Ud8fRjSbUHDqkuM97eT2/KMsrhy5aNwqoS4ONTdcvhi+JvI+cpD+UyCdOOgyGB
	Dns6YTx6s/WKk3p6YbZQQmbtrx46bVg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=o7prbt93;
	spf=pass (imf05.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438229; x=1825974229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZpZWYLtWRnBPFXGp6OY8AG/et/NJXXX+J/qVt0UTEw=;
  b=o7prbt93piBtBkkPuYksDyxusE24/+HiK8hZuzwnC3/BhxjMtnQOgo/R
   Ga+Aeb72zfiQ5Eh3Z83q+R/7gTyC3pCoaJlu2bz6eriof/KY1KrzNoDTX
   k1CTm/mRav3qB+jOpis9wG3PkWMQ5xChVODdU90tMoMyxtEmO0ne3nBjr
   f8S2vSVSZ6VA0OnzqZpBkmpTa+OXtvnPxu2nHHXcGyO8oMamZQHD3OTZI
   QcNhXSKkgQZaLDn8MJ8DIaY+Pvexx59cf7RfoeGRR5fMk0TDgs7WgjM47
   u0PtgepyN61aF/KTmqZzI9neabno1a1WTwi9y77nM+Bnk3jg9jFwJdKs/
   Q==;
X-CSE-ConnectionGUID: At7pt/IlSw6gVH29Bv3WDA==
X-CSE-MsgGUID: b4EEKbGASU+wjQKOsbulng==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33629800"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:03:48 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:4679]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 24e0eacf-a063-47c6-adf8-0884f3aa6ec1; Wed, 11 Nov 2026 23:03:47 +0000 (UTC)
X-Farcaster-Flow-ID: 24e0eacf-a063-47c6-adf8-0884f3aa6ec1
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:03:47 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:03:44 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 22/40] nitro_enclaves: Expose slot pool state under sysfs
Date: Wed, 11 Nov 2026 22:59:26 +0000
Message-ID: <ff9b4f64f1ae4e8f045aaab56900485baf4e330b.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam06
X-Stat-Signature: bnnnpbzcfz6y37z3itsaonq31p3phi7c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 63103100011
X-Rspam-User: 
X-HE-Tag: 1794438229-391661
X-HE-Meta: U2FsdGVkX18DxcE294QNtSuNSQ7xuOKul0Tg2ngXpyOTYXtnWi7jATsUd3DM8UbV8lQp094Earh/g2BELzB2EuV6q/JhA1//u61MYSymw5Q3w2doQjUVC4CKBctp4RArZWlwMHcwLY2i6nzn/wC/Y+xOyAWwD0B2jzvx+ztPXBMEE4pDwh0ldwSWwl6JC6LNAN8ubCy91R4iZ3VQje8VAiJAqwCx+Hh63NjuMfaglN+s6GOMv6Sa36jT2PAIf6YuK0ypK4051QkvitQglQtL9dKFxhuJkyq4DomLoCjS4XxybEQxIbbGnY6Uny4Cw5qUq3Z7ETQcPVAGcyoNc7bwemKF04GetR1+YVISIxNAeKNq1BaK+YD2EOp6nARINzSff4ZBpm4B+kKBz5U1t9DKDUdikHXtGu/fMlB+QYbonXMKwyhEEQ9LzmSSyIX1z16ZzRgWSbgHsKNaDfLHihwE863+0eLus6XY+9+FszGhvXnYx6ycGfMFDDUwRCKpZ/3YvKBrKEBN3bOxCukIDGkADhzPuqm+WWWhDguwMt2kAi9NvqZ86j438N2rRCvNDUjz5l7+9V1JhgcO4T+a9kakrRJzQK0ZsVxmecOhHjtTidthWO053f7xpDxW+4fQlNmfWEQxCzU5QqIKwURVRv9z2ceusRmQNvfDfTboWCS2NLTcvxXbrpCh6gwhEJMp9QvdhcLneb/gRK6MnXzGxhThXjStxqqVXunfnzmj/AbKD5w/wRA9tlS/5USp8Wg18f2L8eMYGD0Kb0RZKxfuI3G/c089MBKRtw+r4O5L1JvM3CCFJ2lOPiMa0M5VixMG8jgkC+bkEOV5S98S8DFWIwJ+duEQoa0KZz7ez757jOJ3c3tCLBbFRpNqJK491+YsKOMM2qn/zKzZCq5SWTjmwOEqSY23t6v8kY1rspBz6Bz83ENl8PDPLGFc5SxWGGZ78SwP3K3iZBqXsZzjPrrGgPf
 p2ffVi9d
 CwnYroFTCEyBlgCHnxO64AOX+4IQtb4xaGhQokinxvr8/TvmIA9eyGCGWH9Bb7z7WCB7tPwMctJ1PkOKzQuxWQKbOUwt1BnTXa0X9ewo5ZU39+HaxtA40G9gL63xVhbWU8WvbSrbDScg3UWoUqulVBCIy+MuzWXN7Wk9Sjuzp10npFRvPqTjsk1/4mGjo0m04qR9CQsnI5X5MS0Gr1pQA/OORli7ZpJMeRGttAnht1lK//iwgqBlK3b1HOuxowRvVGBpxy1Lh34YyhWwUKokfBxGavOtMQoy+JcknpuKw1y2Y9J7fFdqHL76ymEFV4m3Wk8L416x97lJoOsg3qUcM37xIcBueoc7fKT0XhD4Go884UnqgVnDpIqJGfVfUYGtXN2hdc/uHLzd8o5sDJlK/M+0XFd88M1XTK4JKit5lYDA48n5kRUOX9wYbIn7cjJ0EnhAzb6s7W2ry3RNUg+7j5TZcxcx5VJiWzNy5c2dFsaqOpwmDB6p4wOhwdfL9fYfCsqwPfV6+MKot6P2bueNbf49QsPBdyJcp4agvHX4g47K6jLyn0V9EpgBjlmsBX+GnAhqL59+3TNrM9PFpRfHkrpY4IsA9WgAUoBwV35DzMpP4MSjPMq/nW1SLiB8uarCgUu/4dgIhM47JIstoohRqSVMnCGHioVnH3d6I3ziSofTWRacqXZWtVNbEz+UH4kgS5wwwZk6OVjZDDBuXJvODjZTkPe57/r+6eWwO//41k5yIaYoaluxFZKSAbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An operator who wants a host to run more sandboxes needs to see how many
slots the slot pool has and what was donated to it, and to grow it.

Report the pool size, donations and limits in sysfs under slot_pool/ on
the misc device.

Writes to the limit allow an admin to increase the pool size. Pools are
increase only. To reduce the pool donation, you need to unload the driver.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 .../sysfs-devices-virtual-misc-nitro_enclaves | 156 ++++++++++++++++
 Documentation/virt/ne_overview.rst            |   9 +
 drivers/virt/nitro_enclaves/ne_misc_dev.c     |   6 +
 drivers/virt/nitro_enclaves/ne_pci_dev.c      | 173 +++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h      |   3 +
 5 files changed, 346 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves b/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
index c549364353186..a8741ae97f122 100644
--- a/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
+++ b/Documentation/ABI/testing/sysfs-devices-virtual-misc-nitro_enclaves
@@ -74,3 +74,159 @@ Description:
 		The directories appear once the device has been probed and the
 		misc device registered, so a reader that opens the misc device
 		the moment it appears can find cpu_pool empty.
+
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/max
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/granularity
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/base_size
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/base_donated
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/gran_donated
+Date:		November 2026
+KernelVersion:	7.5
+Contact:	aws-nitro-enclaves-devel@amazon.com
+Description:
+		Read-only. One value each, describing the memory the driver
+		donated to the device's slot pool. A device that keeps its slot
+		descriptors itself asks for no donation and reports max as 0,
+		and then the remaining files describe nothing:
+
+		max
+			highest number of slots the device lets the pool hold,
+			as the device reports it. It reads 0 in three cases
+			that it does not tell apart: the device asks for no
+			donation, the device publishes no vendor capability so
+			the register was never read, or the driver turned down
+			the donation geometry the device reported. Only the
+			last of those names itself, in a dev_dbg() carrying
+			the size and alignment that were refused
+
+		granularity
+			size in bytes of one donation to the record pool, or 0
+			where the driver turned the geometry the device reported
+			down
+
+		base_size
+			size in bytes the device asks for as its base donation
+
+		base_donated
+			1 where the base donation was made, 0 where it was not.
+			The pool takes one base donation and no more
+
+		gran_donated
+			how many donations of granularity bytes were made to the
+			record pool. Probe makes one and a write to limit makes
+			the rest
+
+		A donation is drawn from the CMA area of the node the driver
+		asks first and, where that area cannot serve it, from the CMA
+		area of each other node that has memory in turn. It fails when
+		none of them can serve it. Comparing base_size and granularity
+		against base_donated and gran_donated says whether a larger
+		reservation would have changed the outcome.
+
+		These files change while the device is bound, because a write
+		to limit donates. A read takes the enclaves list mutex, which
+		is the mutex a donation and the release of the whole pool take,
+		so a read sees the pool between donations rather than part way
+		through one, and it can wait for a donation, an enclave or a
+		write to limit to finish. -ENODEV says the driver has no device
+		to describe.
+
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/limit
+Date:		November 2026
+KernelVersion:	7.5
+Contact:	aws-nitro-enclaves-devel@amazon.com
+Description:
+		How many enclaves the device can hold on the memory it has
+		now, and the file to write to give it more.
+
+		The device counts each of its two pools in slots and an
+		enclave needs one in both, one for the record the device keeps
+		of it and one for the memory it runs on, so a read reports
+		whichever pool carries fewer. That is the number of enclaves
+		that can exist at once. It does not count the enclaves that
+		already do, so no difference between this file and max or
+		in_use is a count of the enclaves still to be had; whether one
+		can be had is what asking for it answers.
+
+		Writing a number that is no larger than max and no smaller
+		than the number read donates memory to whichever pool carries
+		fewer, one donation at a time, until both carry that many.
+		Writing the number already read donates nothing and succeeds.
+
+		A write that fails part-way neither reverts nor completes: the
+		driver cannot take a slot pool donation the device accepted
+		back one run at a time, so the pool stays at whatever size it
+		reached, and reading the file back reports that size. Each
+		individual donation is all-or-nothing, so a failed write never
+		leaves a run half given: what it leaves is fewer slots than
+		were asked for. The write returns the error the donation
+		failed with, and retrying carries on from where it stopped
+		rather than starting again.
+
+		A write can be refused with:
+
+		-EINVAL
+			the number is larger than max, or is not a number
+
+		-ERANGE
+			the number does not fit
+
+		-EOPNOTSUPP
+			the number is smaller than the number read, or the
+			device takes no donation. The device is never told to
+			give a slot's worth of memory back, so the pools do not
+			shrink
+
+		-ENOSPC
+			the device took a donation into each pool that was
+			behind and raised neither, or it reports a pool is at
+			its ceiling, so no further donation can raise the
+			number
+
+		-ENOMEM
+			no node's CMA area could serve a run to donate
+
+		-ENODEV
+			the driver has no device to describe
+
+		-EAGAIN
+			the device kept asking for a donation to be sent again
+
+		-ETIMEDOUT
+			the device did not answer a donation. It may hold the
+			memory that donation offered
+
+		-EINTR
+			a fatal signal arrived while donated memory was being
+			cleared
+
+		The device may answer a donation with any of its own errors,
+		and a write passes that through as well.
+
+		A read asks the device rather than reading a register, so it
+		can fail for the same reasons a write can. Both a read and a
+		write take the enclaves list mutex, and a write holds it for
+		every donation it makes, so no enclave can be created or
+		released while one is growing the pool, and a read waits for
+		it to finish.
+
+What:		/sys/devices/virtual/misc/nitro_enclaves/slot_pool/in_use
+Date:		November 2026
+KernelVersion:	7.5
+Contact:	aws-nitro-enclaves-devel@amazon.com
+Description:
+		Read-only. How many enclaves hold a slot now. An enclave holds
+		one from the moment the device allocates it until the device
+		frees it. That is normally when the enclave's file descriptor
+		is closed. Where the device turns the free down, the enclave
+		keeps its slot, its memory and its CPU threads for good, and
+		the driver sends the device no further command.
+
+		in_use is not a capacity. Nothing here or in max or limit can
+		be subtracted to give the slots a new enclave can have; the
+		device answers that when it is asked for one, and it can refuse
+		while in_use reads 0.
+
+		A read takes the enclaves list mutex, so it can wait for an
+		enclave to be created or released and for a write to limit to
+		finish.
diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 16d6b4a2771c7..ba030cde59989 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -242,6 +242,15 @@ in the pool is read by the device alone. Probing carries on when a donation
 fails, with a warning naming the error. The memory pool starts at the number of
 slots the device backs without a donation.
 
+slot_pool/limit is what a parent grows the pools with. It reads the number of
+enclaves the two carry now, and writing a larger number donates to whichever
+one carries fewer, a donation at a time, until both carry that many. A slot
+pool donation the device has taken is the device's until the whole pool goes
+back, so a write that fails part way leaves what it donated before the failure
+in place and the number the file reads afterwards is where it stopped. Writing
+a smaller number is refused: the device is told about memory it may put records
+or enclaves in, and it is never told to give a slot's worth of that back.
+
 The device holds every donated page until it is told to let go, so the driver
 takes the whole pool back when a probe fails after donating, when it is unbound
 and when the machine shuts down, and the pages reach the allocator only after
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 2fae731acb977..208c1997609d3 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -425,11 +425,17 @@ static const struct attribute_group ne_cpu_pool_node_group = {
 static struct kobject *ne_cpu_pool_kobj;
 static struct kobject **ne_cpu_pool_node_kobj;
 
+static const struct attribute_group *ne_groups[] = {
+	&ne_slot_pool_group,
+	NULL,
+};
+
 static struct miscdevice ne_misc_dev = {
 	.minor	= MISC_DYNAMIC_MINOR,
 	.name	= "nitro_enclaves",
 	.fops	= &ne_fops,
 	.mode	= 0660,
+	.groups	= ne_groups,
 };
 
 struct ne_devs ne_devs = {
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index 9e304ffc2bd13..1aa4d5508dabf 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -13,6 +13,7 @@
 #include <linux/err.h>
 #include <linux/iopoll.h>
 #include <linux/jiffies.h>
+#include <linux/kstrtox.h>
 #include <linux/list.h>
 #include <linux/minmax.h>
 #include <linux/module.h>
@@ -849,7 +850,8 @@ static int ne_slot_pool_donate_base(struct pci_dev *pdev)
  *
  * A donation raises the number of slots the pool has room for, up to the
  * ceiling the device reports, and a pool that has reached that ceiling takes no
- * further donation.
+ * further donation. The pool takes as many of these as the device will
+ * hold. Probe makes one and a write to slot_pool/limit makes the rest.
  *
  * Context: Process context. This function is called with the enclaves list
  *	    mutex held.
@@ -1347,6 +1349,175 @@ static void ne_slot_pool_release(struct pci_dev *pdev)
 	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
 }
 
+/**
+ * ne_slot_pool_in_use() - Count the enclaves holding a slot.
+ * @ne_pci_dev:	Device whose enclaves to count.
+ *
+ * An enclave holds one slot from the moment the device allocates it until the
+ * device frees it, so the enclaves the driver has a record of are the slots
+ * in use, including those whose slot the device did not free when their file
+ * was closed.
+ *
+ * Context: Process context. This function is called with the enclaves list
+ *	    mutex held.
+ * Return: Number of enclaves holding a slot.
+ */
+static unsigned int ne_slot_pool_in_use(struct ne_pci_dev *ne_pci_dev)
+{
+	struct ne_enclave *ne_enclave;
+	unsigned int n = 0;
+
+	list_for_each_entry(ne_enclave, &ne_pci_dev->enclaves_list,
+			    enclave_list_entry)
+		n++;
+
+	return n;
+}
+
+/*
+ * slot_pool/ sysfs group on the Nitro Enclaves misc device: report what the
+ * driver donated to the device's slot pool, what the device asked for, and how
+ * many enclaves the pools carry.
+ *
+ *   /sys/devices/virtual/misc/nitro_enclaves/slot_pool/
+ *
+ * The device counts each of its two pools in slots and an enclave needs one in
+ * both, so the number of enclaves that can exist is whichever pool carries
+ * fewer, and limit reports that number rather than either pool's own. Writing
+ * limit donates to the pool that is behind until both carry what was asked
+ * for. The other files say what was donated, how large the runs the device
+ * asked for were and which allocator served them, which is what an operator
+ * needs to decide whether a larger CMA reservation would have changed the
+ * outcome. A device that keeps its slot descriptors itself asks for nothing
+ * and reports max as 0, and then none of the other files describe anything.
+ *
+ * Every file here takes the enclaves list mutex, and so does every donation
+ * and ne_slot_pool_release(), so a read sees the pool between donations and
+ * never part way through one, and a read during teardown sees it whole or
+ * gone. Reads and writes land only between misc_register() and
+ * misc_deregister(), and neither sits inside a region that mutex covers, so a
+ * read waits on a donation, a write or an enclave and never on a teardown that
+ * is waiting on the read. base_size is a device register and the mutex says
+ * nothing about the device, so it is what the device reports at the moment of
+ * the read. A read answers -ENODEV where no device is bound.
+ */
+
+#define NE_SLOT_POOL_ATTR(_name, _fmt, _expr)					\
+static ssize_t _name##_show(struct device *dev,					\
+			    struct device_attribute *attr, char *buf)		\
+{										\
+	struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;			\
+	ssize_t n;								\
+										\
+	if (!ne_pci_dev)							\
+		return -ENODEV;							\
+										\
+	n = mutex_lock_killable(&ne_pci_dev->enclaves_list_mutex);			\
+	if (n)									\
+		return n;							\
+										\
+	n = sysfs_emit(buf, _fmt "\n", _expr);					\
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);				\
+										\
+	return n;								\
+}										\
+static DEVICE_ATTR_RO(_name)
+
+NE_SLOT_POOL_ATTR(max, "%u", ne_pci_dev->slot_pool_max);
+NE_SLOT_POOL_ATTR(granularity, "%u", ne_pci_dev->slot_pool_gran);
+NE_SLOT_POOL_ATTR(base_size, "%u",
+		  ioread32(ne_pci_dev->iomem_base + NE_SLOT_POOL_BASE_SIZE));
+NE_SLOT_POOL_ATTR(base_donated, "%d", !!ne_pci_dev->slot_pool_base_page);
+NE_SLOT_POOL_ATTR(gran_donated, "%u", ne_pci_dev->slot_pool_meta_nr);
+NE_SLOT_POOL_ATTR(in_use, "%u", ne_slot_pool_in_use(ne_pci_dev));
+
+#undef NE_SLOT_POOL_ATTR
+
+/*
+ * limit is hand-written rather than generated: its read issues a command that
+ * can fail, which the macro's single expression has no way to return, and it
+ * is the only file in the group that is written.
+ */
+static ssize_t limit_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	ssize_t rc;
+
+	if (!ne_pci_dev)
+		return -ENODEV;
+
+	rc = mutex_lock_killable(&ne_pci_dev->enclaves_list_mutex);
+	if (rc)
+		return rc;
+
+	rc = ne_slot_pool_limits(ne_pci_dev->pdev, &cmd_reply);
+	if (rc >= 0)
+		rc = sysfs_emit(buf, "%u\n",
+				ne_slot_pool_effective_limit(&cmd_reply));
+
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	return rc;
+}
+
+static ssize_t limit_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	u16 target;
+	ssize_t rc;
+
+	if (!ne_pci_dev)
+		return -ENODEV;
+
+	rc = kstrtou16(buf, 0, &target);
+	if (rc < 0)
+		return rc;
+
+	rc = mutex_lock_killable(&ne_pci_dev->enclaves_list_mutex);
+	if (rc)
+		return rc;
+
+	rc = ne_slot_pool_limits(ne_pci_dev->pdev, &cmd_reply);
+	if (rc < 0)
+		goto unlock;
+
+	if (target < ne_slot_pool_effective_limit(&cmd_reply)) {
+		rc = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	rc = ne_slot_pool_grow(ne_pci_dev->pdev, target);
+	if (rc < 0)
+		goto unlock;
+
+	rc = count;
+unlock:
+	mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+
+	return rc;
+}
+static DEVICE_ATTR_RW(limit);
+
+static struct attribute *ne_slot_pool_attrs[] = {
+	&dev_attr_max.attr,
+	&dev_attr_limit.attr,
+	&dev_attr_granularity.attr,
+	&dev_attr_base_size.attr,
+	&dev_attr_base_donated.attr,
+	&dev_attr_gran_donated.attr,
+	&dev_attr_in_use.attr,
+	NULL,
+};
+
+const struct attribute_group ne_slot_pool_group = {
+	.name	= "slot_pool",
+	.attrs	= ne_slot_pool_attrs,
+};
+
 /**
  * ne_pci_probe() - Probe function for the NE PCI device.
  * @pdev:	PCI device to match with the NE PCI driver.
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index cab5434fc3e0d..f5cb24312d442 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -578,4 +578,7 @@ int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
 /* Nitro Enclaves (NE) PCI device driver */
 extern struct pci_driver ne_pci_driver;
 
+/* slot_pool/ sysfs group on the NE misc device */
+extern const struct attribute_group ne_slot_pool_group;
+
 #endif /* _NE_PCI_DEV_H_ */
-- 
2.47.1


