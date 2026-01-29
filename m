Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C654AD73E8E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215B96B009E; Thu, 29 Jan 2026 16:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB096B009F; Thu, 29 Jan 2026 16:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22DA6B00A0; Thu, 29 Jan 2026 16:25:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF0E06B009E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:58 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9DDE1B0960
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:58 +0000 (UTC)
X-FDA: 84386283996.24.66F441D
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id E3B19C0008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hKAbmmy6;
	spf=pass (imf28.hostedemail.com: domain of 3Y9B7aQgKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Y9B7aQgKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ibCvH5eZEobsLpnry66xHV5xBXd91tAWSqhhlaOXScs=;
	b=klqE9549CQ9+f+sXjluuHzQFw4G26y5ik0R0Tlw1uiWUzp3xuGsrtb/4f9ejhWxlsQEJS2
	cE25bVY9GKf9hPmP4dcZQzpxUNIWaUFnkXk8YG+TXGauCL57cG4IYRWk0HSLsT+SG547Tf
	JJekxjtZNNdNhKzAhhpFqmwwpUbXNyI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hKAbmmy6;
	spf=pass (imf28.hostedemail.com: domain of 3Y9B7aQgKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Y9B7aQgKCEYlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721957; a=rsa-sha256;
	cv=none;
	b=R4e8x8WMrsRXJlYwFG6x4erUeEV/3K0uvXfKBKqtoHbzObYAa7QA04YjfNop5IfHilJnTl
	D2jxh3JthbAQcTplT0rwwoQr+lEs80x+j2qe8OImnxSaBNGT1Csj0ohB2FhfL6engKoGjO
	AEKE+6EArfb7y0btR7GevZMisEa4xOI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34ab459c051so2563731a91.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721956; x=1770326756; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ibCvH5eZEobsLpnry66xHV5xBXd91tAWSqhhlaOXScs=;
        b=hKAbmmy6m/QRZDOwGa+OGPRmjIsUidHfmvapk0xxo8+ZR4ikCgY1puJLBVPCUYjqnB
         677pAMyL80zlm38EAnp5uMPeS9epTSkB/rJ/PfLgbVhGK93LwTVv1h/0mLxiqHxI4qiz
         5MRN9wi9rs70H+33dBWj9pTE5eslvbs8+J3NnkvFllaOTEcXVBKxcQIgaWljIVUBBWfa
         xl3ofnUHpUmDdLYvLS6N9oMbA9CWIF9GoN1lWjy8v4WjuKcn0FaWAESIEFgeL+vRi/AQ
         172yqj22EiLIjj3p2yGgkq5kfOpp7HnmNtooC0en3H9YA3Lm6VYQH7RejGOMIqDt/3h0
         1Ppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721956; x=1770326756;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ibCvH5eZEobsLpnry66xHV5xBXd91tAWSqhhlaOXScs=;
        b=iCdbnBuh9a+28SH9XMei39IVMbBLBBeRWpGQlaDILKN3LygD/XXYcNI8DLe0P3s0ce
         wolutzh4CTi0zk1HSLRSOzfZmrspLKPjLiP1FiQ7HddBVSNoeOBWWhJPYFLJ+iLHgmhD
         rf45BoAPQII0U8mokbOXGVlmqnb3VAyhgPvocl4ApcqVVQpU/AN3+1Su4p2AOR8Desq7
         qjoltdktWe4Wjquzc0+QE1gZZxNfvzNjUiRplrzoLTP8FPg06TcWC6qvj2Yqs4lp52yF
         Di/ZmtLKd0zMZHO1lMjIlg1xIBWxJas+vCiUb6B5N3U2MFjE44BEoKiUj04jbgT4QWf+
         /QRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWInGUAwO75f2vVXvW7xLKBGQdBFmDD/baYKXyUVG0ofJXvpjXRJCCgQgKzhcg8QBgMleIxEOyKTg==@kvack.org
X-Gm-Message-State: AOJu0YyzRz0ou03Q0ywyfaWKN6mF/GzJrSt+gjydMufeNd1KgTTVzYe6
	odjEDxLwRLCahHO3pUqe+DKOtc9neldpd/IuRaayzPZPZ7cGlQNI07/tV1tutu59RIoxauGjBDl
	U6jf6n7bvTbk9Cw==
X-Received: from pjbpv18.prod.google.com ([2002:a17:90b:3c92:b0:33b:ba24:b207])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3ccd:b0:352:bd7c:ddbd with SMTP id 98e67ed59e1d1-3543b38af32mr802532a91.23.1769721955711;
 Thu, 29 Jan 2026 13:25:55 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:58 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-12-dmatlack@google.com>
Subject: [PATCH v2 11/22] docs: liveupdate: Document VFIO device file preservation
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3B19C0008
X-Stat-Signature: 9y5d6kts96w8y76fi6cdr6xqyxu7mw37
X-Rspam-User: 
X-HE-Tag: 1769721956-963441
X-HE-Meta: U2FsdGVkX18rGGXAYihVUz9yimfOn0eDTwgSEE0rCJT1tLp27ZcEslv18dyjvqymHTfpVlJXZ5PIl7Dz+yZq2hi5C9xCn5XyKSd84P3xbbf5EHmxRm4kGlg3NCI5XqqnxrYUyqPSSCqtna3mEUlDB3pXZlCQs6vhTNOnn+WAylP7lUdF+zELt2w4TbL3dVG2de4TiXcddTKJs18r00v4aTUTR78IkWXN4+dlH7kSBIwmBNE4I5tx6F6s5gpwj7Pfd7Yk3SbY1UokX9ZJssfQ4AZlH4nZqcfgE3PXP7zH0FuYt0QVpI4vhTbWzq8tYJwwKOuG0QwN4zViF4ZFQyKGo09KdDtjjd3MM4y7LXUvyrSTXGauGbadeVns0C0qtJx2izWappp6xwgh1DeLDb3ST4Uxf5P5LvehNHAaAQx+MV6snB5CtUjgSCHF+p8FFRcU27u7n3jJTy0foN4JXUV/BBgjonol5ymuom+x2zF/dOP4clt0iO9O68om7UxWyi7B6eJARHI62fRHYcOl0ZiOJq/RoQBJcoQqPzfaRJbBvBqYtZ5C7rywT6u4SWFg4EKp4CAWZh8D5KcF1WQFL3T1nng+rj7rbi7CRwH7q06gszo6cATdID1J49zyxVy8GaO14mcy7aj6uWnm0kZR/FjapkckOf+/kZ+I4wXWZaqiwi+Lf7Z3/RyfslS2B/5uAGJO/RqKcrzHrAy9K/FSYJo0w6NwTdzpvVisrlnlkgA0n+S/rlR97Zm0omQmQvWgfh/B5jl9oV4Mx8HUk7NQbiodAnOtqjCuCeNZ4sSYzbAYlXr7yzlqanvHnUtALuM2s6kuA6evUHWd/IhROyduE7O+xLPlCpScW8Bkwa+JKb8TCJ3pjOsyNSNOBv/8pHAEdsprlNnk1VraqOYnw5oj1slsBnoj/BQmF8wf98L/QgKSyTwKaVrBo2MKAB73ArAANaUeVzwovDKYbz146JPYbFB
 kss0BtGJ
 0thhS+/fdCUG/aSc7SlW2dyXXcKYWsD+z8PJ0+iAlds04fobWHoQkvwyRzBof4Bd3TW9YiRkg1Cp5yVb7MHFVOkBNIEZ78VFKzRJr4E/1nEqch+P+hnvExvGM3iDM5JqMKpfNljfy3RZ0pZK50WoPCBEXl2QHNPRsrUcW02QyWpsf2JSzMgqbEFXlgS6D4zzQ6WbxvqtLwSTqVbhZrSWgQwVX2VtLLv11K5sd7v8NdiLfxjnEvVJn16tqQTj4G8bDP5HnUWkHhbBqXMvSX+atcsZ03jBrE6GVPaMxo1KJ87sKuXOWc/TXx7nnE5eGCr8M+OEy/q11QLDzb4PWngf+OyV1EySbn8zgxPx/DkrrJF2P5Jj8bqJeKh617cyDhVThRWGUmwfXJTOI1Pdbau9xKu0x74GdPwCs7pVutcnS/crPJpHG97hR1Yuh1aRPX8HoTxIDHIbg87qDmFz6MHQWXBC5xaYBb77J+n3sacR4vZgih1mQgoT3Ruu3bnL17zzaVV1bZtt1tv6FzBswulsbIZsQwO9HpPHXBW0yKW1JlFJ7WzGWG8F0N4ZK3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for preserving VFIO device files across a Live Update,
as well as some generic file preservation documentation. This
documentation will be extended in the future as new types of files are
supported and new dependency/ordering requirements are added.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/userspace-api/liveupdate.rst | 144 +++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index 41c0473e4f16..dbf1e4aeddd7 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -14,6 +14,150 @@ ioctl uAPI
 ===========
 .. kernel-doc:: include/uapi/linux/liveupdate.h
 
+File Preservation
+=================
+
+Files can be preserved across Live Update in sessions. Since only one process
+can open /dev/liveupdate, sessions must be created by a centralized process
+(e.g. "luod") and then passed via UDS to lower privilege processes (e.g. VMMs)
+for them to preserve their own files.
+
+luod::
+
+  luo_fd = open("/dev/liveupdate", ...);
+
+  ...
+
+  // Create a new session with the given name.
+  struct liveupdate_ioctl_create_session arg = {
+          .size = sizeof(arg),
+	  .name = SESSION_NAME,
+  };
+  ioctl(luo_fd, LIVEUPDATE_IOCTL_CREATE_SESSION, &arg);
+
+  // Send session_fd to the VMM over UDS.
+  send_session_fd(..., arg.fd);
+
+VMM::
+
+  // Receive the newly created session from luod over UDS
+  session_fd = create_session(SESSION_NAME);
+
+  ...
+
+  // Preserve a file with a unique token value in the session.
+  struct liveupdate_session_preserve_fd arg = {
+          .size = sizeof(arg),
+          .fd = fd,
+          .token = TOKEN,
+  }
+  ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg);
+
+Files can be unpreserved with the LIVEUPDATE_SESSION_UNPRESERVE_FD ioctl. They
+are also unpreserved once the last reference to the session is dropped.  To
+carry preserved files across a Live Update, references must be kept on the
+session files through the reboot(LINUX_REBOOT_CMD_KEXEC) syscall.
+
+While a file is preserved in a session, the kernel holds an extra reference
+to it to prevent it from being destroyed.
+
+Only the following types of files support LIVEUPDATE_SESSION_PRESERVE_FD. More
+types of files are expected to be added in the future.
+
+ - memfd
+ - VFIO character device files (vfio-pci only)
+
+File Retrieval
+==============
+
+Files that are preserved in a session retrieved after
+reboot(LINUX_REBOOT_CMD_KEXEC).
+
+luod::
+
+  luo_fd = open("/dev/liveupdate", ...);
+
+  ...
+
+  struct liveupdate_ioctl_retrieve_session arg = {
+          .size = sizeof(arg),
+	  .name = SESSION_NAME,
+  };
+  ioctl(luo_fd, LIVEUPDATE_IOCTL_RETRIEVE_SESSION, &arg);
+
+  // Send session_fd to VMM over UDS.
+  send_session_fd(..., arg.fd);
+
+VMM::
+
+  // Receive the retrieved session from luod over UDS
+  session_fd = retrieve_session(SESSION_NAME);
+
+  ...
+
+  // Retrieve the file associated with the token from the session.
+  struct liveupdate_session_retrieve_fd arg = {
+          .size = sizeof(arg),
+          .token = TOKEN,
+  };
+  ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
+
+A session can only be finished once all of the files within it have been
+retrieved, and are fully restored from the kernel's perspective. The exact
+requirements will vary by file type.
+
+VFIO Character Device (cdev) Files
+==================================
+
+The kernel supports preserving VFIO character device files across Live Update
+within a session::
+
+  device_fd = open("/dev/vfio/devices/X");
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, { ..., device_fd, ...});
+
+Attempting to preserve files acquired via VFIO_GROUP_GET_DEVICE_FD will fail.
+
+Since the kernel holds an extra reference to files preserved in sessions, there
+is no way for the underlying PCI device to be unbound from vfio-pci while it
+is being preserved.
+
+When a VFIO device file is preserved in a session, interrupts must be disabled
+on the device prior to reboot(LINUX_REBOOT_CMD_KEXEC), or the kexec will fail.
+
+Preserved VFIO device files can be retrieved after a Live Update just like any
+other preserved file::
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+  device_fd = arg.fd;
+
+  ...
+
+  ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
+
+Prior to LIVEUPDATE_SESSION_FINISH, preserved devices must be retrieved from
+the session and bound to an iommufd. Attempting to open the device through
+its character device (/dev/vfio/devices/X) or VFIO_GROUP_GET_DEVICE_FD will
+fail with -EBUSY.
+
+The eventual goal of these support is to preserve devices running uninterrupted
+across a Live Update. However there are many steps still needed to achieve this
+(see Future Work below). So for now, VFIO will reset and restore the device
+back into an idle state during reboot(LINUX_REBOOT_CMD_KEXEC).
+
+Future work:
+
+ - Preservation of iommufd files
+ - Preservation of IOMMU driver state
+ - Preservation of PCI state (BAR resources, device state, bridge state, ...)
+ - Preservation of vfio-pci driver state
+
 See Also
 ========
 
-- 
2.53.0.rc1.225.gd81095ad13-goog


