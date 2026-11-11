Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025CC606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=sMNjZYsG
Received: by kanga.kvack.org (Postfix)
	id 071AF6B05CB; Wed, 11 Nov 2026 18:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021F86B05CC; Wed, 11 Nov 2026 18:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E534D6B05CD; Wed, 11 Nov 2026 18:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA236B05CB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:14:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55A8DA7F98
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:14:06 +0000 (UTC)
X-FDA: 85424393292.11.40697B1
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18BCEC0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:14:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sMNjZYsG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YE3Omn29rE1S2bQW+kmuZewe1GXmkpcFPI6VWCg3I6U=;
	b=H/b2Vv2BjR915sdU6iuSKhl6GmIwk8drqOsfkNBBy/8a0mgOZfRI/us5m3FoK3XRIE/rJs
	9VLf9IzbtKlcv415T1Hl1EYE78TGpuq/Z5+iv2HaN5X9TO2JhXNeIQhqcMH/J27qT5yXA8
	rebx+1JBK34H7zseKKDz2uRhk19qdQw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=sMNjZYsG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf28.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 35.83.148.184 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438844;
	b=S7SQh49VEPcQf9/l17x5Ouzz8RsbvcYCWfUZOe7wrdDStRY4VEyK7J6Az8Sw+qVw9d/fOX
	/6gPwU+C4vGhtiO6rbnUqXMcFc+JDpSKlWOnQT5itGzfizg7MJVOb8QaYG6I0rrSjqk+zh
	Xev0gZ+68BKS6x9IFmSJ2KzsTtZytt4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438844; x=1825974844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YE3Omn29rE1S2bQW+kmuZewe1GXmkpcFPI6VWCg3I6U=;
  b=sMNjZYsGHhq4PqRekgHRxd/Bc9y5gfCcTTj7imFA5SYaKcCxJ53/vCYN
   08QIeu3DLRcYmLVQiji2DOqFFO4PV6XTIAp6+wYYm8SfTDbKrhFQa2Rg7
   VGsnK3p8C/SVJKwnCXs/IPMYvxZ4BDtkatU5orpuGqOddCoXffBleXAi4
   OMhhSaVxwYgDv74rs//UvXVBS5MyQGh+wQ3QvaExk4chkRzeekjXwX4RV
   FhcOwP87k9k0z5cQ+sMOXXS9aWdRMdpENQID/stELP4GoJqYsVG3M3C2+
   s0dFKoN4PvEPKMUwP4luiIOCaqrlG2t9St8ywzDIEUftY8x3xVf4t1vuL
   g==;
X-CSE-ConnectionGUID: U8t3y49qRK2yKOTtRsmNqQ==
X-CSE-MsgGUID: qhRG+rLpT4ebH7E5UzMWWQ==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33551552"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:14:03 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:22885]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id 5be80b4a-ae4c-4ed0-bacf-81eb9d64e629; Wed, 11 Nov 2026 23:14:02 +0000 (UTC)
X-Farcaster-Flow-ID: 5be80b4a-ae4c-4ed0-bacf-81eb9d64e629
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:14:02 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:13:59 +0000
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
Subject: [PATCH 40/40] nitro_enclaves: Document the driver side of Nitro Sandboxes
Date: Wed, 11 Nov 2026 22:59:44 +0000
Message-ID: <2d8e0949932082a4730fb094d15b8cf5f3cfc212.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18BCEC0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hx5cnpsquticsnw3px4y9azefxxn73rt
X-HE-Tag: 1794438843-491134
X-HE-Meta: U2FsdGVkX1+sJNw2urH1WqQkPORuqIcakbLPwNQ+KPOyXeauTMzHwQKNxnMTJapmnngmRv4chEtpMqw9YlWhwsASfof5evt/PiPMocDQiWbhFCNKiUUu8zWvsLM/gpx2t47r9Hn5lthNB9JRksYyfDZjlbD8EpdQgUzxbvy4862sgXtQRE5fahreA0a8pYxAzT4eTUaGeZlwoMAzbe82O8jTtOMLjIH2z8qf+o58yLI/7h8/beFBW8TN89hN1ek5BtRWJhObK/+YXqkDTda0dGZkIACOfi+UF7rJAHcXmpJ8iaU7ikXCKwbNuPUSgpUma/+G6q0H9yY8riDKzoeu/ET0IPK9/dgxkgmi9uVhWdn82UFmun7gdZ20Z3M1VytGuNsqHb66UOoyxHXFRM6B4zgE5+pb8mGYJttB8nO2jQ+1z0tq48s2xopKllbMIS55U72oWUf5VodcrQiAmT0RDbBvSHt3ywCAmuDfEdaMCG+mg8y7K0u1rG3WujZ2mkMLeSTKXEPpiEudV0Y0b4aYncr+t0jH9oU6IvTw7jyv8XAEziZTWE8ObTx11S5VV2PpOtx1JR87WFcq+GUJOfqKVfQVmvJ5MWW9VePgU7jNCIDeiVXpEzla/YKM725CFO+9mavtdbQx1EU7Pr5tW/LeN73cBIvTBzTzen3PuBH5ZiMHDzKaRj4giRRIf7k+6FROe+0r2uX+JS5PP6Ux78tXiumq02UpR5Gja5hhkg2zKtZbQ+7UjOBB0N6Ok/GimSKMcw4meB4tWSd3fTpI1SsfzV49KmazGwAi8WuvnwJUV+IOSiogANPTeeNEk9L6UBLGyP2MKMOfWSWvpn12MNhyfSd7LLOF2cTj/JuY3lmXD4y/3xYCclmN9FuaIgkV/lkCpQyuPB2NQ3DImWI3dNI50N8bXtFy23Om0vSA8c0LoE4eVib+ehHNR7WLw+8t6wr3ud4vFicx5rhlgnRLys9
 d+y1FVP4
 qE5U5ArYV5ipZFOes1bOWECrdCvLwf1CGJkFtlMLiK5SgS5MJmp/jyHSPMGfWIO7q/CAEv9tXV/Bo1bQjhPYmnPnu0Tgxxl3Uc4s1bVA210NuD9hwXMy8hrlGYIJAWZ6st2A26L1egDZTWyklMaSiobik+OrGc09ZZlIBxkDNWHr5WcC4NsGZCWg7ESGRhD/qxmM5EO9uVwzKFlyr95bRXAOqUelCS/DQ2QbJULSgeb9x5qiqG/LR5imjd902yvvLzcyTHOGqYgvCqRRlKp9REC+qevDfYarZtrxh2aH5xziBJzJS2XXs6DNPWdaHo3WYWF3VvChRG55en4n/hFDJ9KOvtBNoZPCb2kkH9yU77KLabypG2fx6Wf4VuUOl2S6AS6IYQ0x2A03061vDqcfu2GnPW0lgydr4Hct7H2XI1yu7TNlt5UUtUwCpzoJ2696UcnG7yxlKu6k0k2YxiBcW+lW2zoZfUwg4ho0C8HmfyBcAobm3WyeyikH/mAGaEmMPWxXsUlhsmTmJKpdba2xkiGQV4nXvSqVFZCsD77haNqheKKwZKBC4yZqsxUFw9rTC6peyKe5BNc4cE+uSPT3vzMXJUSYCR+MQyFrekBzG3pm3GOvwWt37pTpunwCVoSccr+K9VV1ATeeroovZMSQKbSzUWpCjx4Ct+8+9O71qu5GbAw1VmIDPb2kLHqLx/Ei5CKkAlfHQTp+h1vx7CMLK0bjvcBKKfpw3VnNp1/ZIbxad8jI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users of Nitro Sandboxes and authors of their parent tooling need one
place that explains how the calls that Nitro Sandboxes add fit together.

Document the driver functionality that Nitro Sandboxes add in
ne_overview.rst: what NE_GET_CAPS reports, the launch flags
NE_CREATE_VM2 takes, direct mode, why a slot needs its info page first,
what NE_ADD_DEVICE names and returns, and the two directions an event
travels. Link the public AWS documentation of Nitro Sandboxes for the
user side.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 Documentation/virt/ne_overview.rst | 82 ++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
index 3aa33d3f06cf2..dbf9261d0391e 100644
--- a/Documentation/virt/ne_overview.rst
+++ b/Documentation/virt/ne_overview.rst
@@ -270,3 +270,85 @@ The device holds every donated page until it is told to let go, so the driver
 takes the whole pool back when a probe fails after donating, when it is unbound
 and when the machine shuts down, and the pages reach the allocator only after
 that has returned. Pages the device will not give back stay with it.
+
+Nitro Sandboxes
+---------------
+
+Nitro Sandboxes [9] build on top of Nitro Enclaves technology. They provide
+a sandbox VM with parent backed virtio devices on a PCIe bus, so it can have
+block devices, network interfaces and a console like any other virtio guest,
+and the parent provides them from an ordinary user space process. The driver
+functionality that Nitro Sandboxes add is described here.
+
+NE_GET_CAPS reports what this kernel implements: NE_CAP_DEVICES covers
+NE_SET_INFO_PAGE, NE_ADD_DEVICE, NE_SET_NOTIFY_EVENTFD, NE_SET_VRING_CALL and
+NE_UPDATE_DEVICE_CONFIG. The argument carries its own length in struct_size and
+the kernel writes back how many bytes it filled, so a caller built against a
+header this kernel predates can tell a field this kernel never wrote from one it
+wrote a zero into.
+
+NE_CREATE_VM2 takes a word of launch flags, and NE_CREATE_VM is the same call
+with a zero one. NE_ENCLAVE_PCIE_MODE asks for a slot with a PCIe bus, and the
+other launch flags shape that bus or the slot. The flags in
+NE_ENCLAVE_FLAG_MATCHED_MASK are the ones the hypervisor enumerates, and two
+fields answer for them. ne_caps.supported_matched_flags reports which of them
+this kernel passes on, and is the same on every host.
+ne_caps.hypervisor_matched_flags reports which of them the host behind the
+device says it implements. A caller requires a flag in supported_matched_flags
+always, and in hypervisor_matched_flags as well when that field is non-zero.
+A zero hypervisor_matched_flags means that the host gave no answer, because it
+reports no flag or because there is no device to ask, and NE_CREATE_VM2 is then
+the only test. On a device that takes no launch flags at all, it fails with
+EOPNOTSUPP. For the flags in NE_ENCLAVE_FLAG_UNMATCHED_MASK the answer comes
+from allocating a slot with them. Bits outside the matched mask read zero in
+both fields whatever the hypervisor does with them, so a caller masks its
+request before comparing.
+
+Nitro Sandboxes introduce a mode called direct mode, selected with
+NE_ENCLAVE_DIRECT_MODE, in which the parent keeps access to most of the memory
+it donates to the sandbox. Direct mode disables attestation, but lets guest
+kernels that do not place their virtqueues in device-provided memory run in a
+sandbox. A slot in direct mode takes NE_MEMORY_SHARED allocations as memory
+regions.
+
+A slot needs its info page before it can be given a device. The device reports
+how the sandbox reaches each of its virtqueues by writing the info page, and
+NE_ADD_DEVICE reads those entries back out of it, so NE_SET_INFO_PAGE comes
+first; see `Memory pool`_.
+
+NE_ADD_DEVICE names the device with a type whose top 16 bits are the class, of
+which NE_DEVICE_TYPE_VIRTIO is the only one, and whose low 16 bits carry the
+virtio device id the sandbox sees. It carries the feature bits the parent offers
+for the device and the opening bytes of the device's configuration space, and
+names the NE_ALLOC_MEMORY allocations the device works out of. Each of those has
+to be NE_MEMORY_SHARED, because the parent drives its end of the queues through
+a mapping of one, and each is named with the id the sandbox knows that region
+by. The driver puts that id in the top 8 bits of the size it reports for every
+run of the allocation, which is how a device made of several regions tells them
+apart; the parent and the sandbox agree on the numbering and the driver does not
+read it. A device that works out of the sandbox's own memory regions says so
+with NE_DEVICE_NO_SHM_REGIONS and names no region. An allocation is a device's
+memory, an enclave's memory or an info page, never two of those, and the driver
+holds it until the enclave is gone, so closing the descriptor does not take the
+runs away from the device. The call returns the id the device was given and, for
+each of its virtqueues, the interrupt vector, the notify index and the doorbell
+offset. It takes a device on a running sandbox when the slot was allocated with
+NE_ENCLAVE_PCIE_HOTPLUG_MODE.
+
+Notifications travel both ways. Towards the parent, the device signals through
+an interrupt multiplexer built into the nitro_enclaves device: it raises one of
+a pool of MSI-X vectors, and records in a bitmap page per vector, which the
+driver donates, which notifications were raised. NE_SET_NOTIFY_EVENTFD binds an
+eventfd to one of them, which is the kick of one of the sandbox's virtqueues or
+the change of a device's entry in the info page. Towards the sandbox,
+NE_SET_VRING_CALL binds an eventfd whose signal rings a virtqueue doorbell, so
+the sandbox learns that the queue has data waiting for it. Either takes
+NE_EVENTFD_UNBIND in place of a descriptor to release the binding, and binding
+one the caller already holds replaces the eventfd on it.
+
+NE_UPDATE_DEVICE_CONFIG writes the configuration space of a device a sandbox
+already has, naming it by the id NE_ADD_DEVICE returned.
+ne_caps.max_config_update_size bounds how many bytes one call moves, not how far
+into that space they reach.
+
+[9] https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-ec2-nitro-sandboxes.html
-- 
2.47.1


