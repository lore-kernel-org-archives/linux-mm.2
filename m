Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46FF3D0EE13
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988B06B00A7; Tue, 25 Nov 2025 13:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911C36B00A8; Tue, 25 Nov 2025 13:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2786B00AC; Tue, 25 Nov 2025 13:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64C086B00A7
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:30:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0100E1403AC
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:30:18 +0000 (UTC)
X-FDA: 84149969358.15.4FFCE4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 31AD11C0015
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:30:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b+tzixxm;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764095417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50R9krdCdPyNpUzZ0TXDkq/38Urjwel1MbE3jxh4hpA=;
	b=yYKz6cLTcQQQUCBL8nzZ6kaz3+oD2K4vzWwBZmorc1hvxL2qS7Gf88SpCA2dIkdewOEjvG
	G3GXqAktsuDQKnXSuBZHmsyhd9C65TcMiI8mG1X9jdTSHMjDRbUPXW1/60XRmg8V6uvoxq
	RYOqq7h/dgjB7Ab+QZoVExVnKvV4zGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764095417; a=rsa-sha256;
	cv=none;
	b=jkBnKmDZ2BZg5KOV9srJ2HE1Dl8F4TdywjKH57rF9pa/2l9HGyD57xrdEgzhWihP+vVZ1R
	w03q3l4CCMmMtuTKOG92sGoc9XPhJJSfHWN/oJ6nLF6QXe5s6ytDHHUpviGvmTPMpoTd/j
	0C/IU2jkP3GmiNiWm+HSpRtV6EuOp4A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=b+tzixxm;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63BCB60052;
	Tue, 25 Nov 2025 18:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2C0C4CEF1;
	Tue, 25 Nov 2025 18:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764095416;
	bh=ilWEu5RxIVLfVIaXLQHAdQTbENf6mqv/Hm1iZ1MhI6w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=b+tzixxmV1ZRmL/hj6nA0kkhxHaUdNXKQqWLsC+tDqtp42wPV/HVAldl2UR2lg/rT
	 xSJtZgyEUdh9WxYrFtcKmqnPiupLOQerU+GcoaZlxAwHQ7BHUkwHOT+4MLntXo2qFU
	 9de67fdf8StJsO22yf01YKRQiw7y3RYkO/wk+/pk=
Date: Tue, 25 Nov 2025 10:30:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
 rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, tj@kernel.org, yoann.congal@smile.fr,
 mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
 axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
 vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com,
 david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org,
 anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
 bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
 myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
 brauner@kernel.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, ajayachandra@nvidia.com,
 jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com,
 hughd@google.com, skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v8 00/18] Live Update Orchestrator
Message-Id: <20251125103012.c9f0519e166b810e2e03e1b0@linux-foundation.org>
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 31AD11C0015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: mcpxz8dgwtf66itepzdo177j1yy84qe8
X-HE-Tag: 1764095417-392439
X-HE-Meta: U2FsdGVkX1/JkVF3YsyrF7+TkE/x5m1qRCuST3sWbXRzUbG7z9yBRhS3IJF1CNbC+4ltpPTF+D6ifa/XV3MKXZgCNTLFbaE6GZREz3J+9w8nXJYDQQSrjCEfwmoqGks0HilTvxCduEcQjnOdhMwR5VIbVdiuEjcJTQH4bVkds/qheFRCZ5AkIkDfP77hNBVZR+iuUHdNAWDEazgr8ZVBoPt8VBL5X1CNlc49EKHYXjVUQiSKTZio55HSowWtqWf5r20Sg1F76p9OUNkLxip41vrhOYjStiEBIk+p1R4e2ZhXZuTO5Lu7PBFIoMdZIrY/dbJNISFMwsvVfn7rcVQ8anM+M5kiPw9XzSTPFjmdeRstpTSetk0UMtYH/YkEfo7xHamO1dRP0ibeJSMpGI1vsDY2q2h4VqltK89rlaorhU7S4CDGVx02RWdjiDPARs29Xrq23Vmdd02SH39wxOFVCdIrJTk/czqqxPTeQjUkTfsk0GNyekPLaqfMWlJQzufvgNWuWaVmSxaxY9gAP4dj/ju2A7h3EV0aSnBevWsDb3uyJgZjUn57iy9EFAN1t180KgYpP05lKE3F2s+btxJCwt0N45NlCYjdwdWlNEfMmh06Sg+rZKfdH2yPzrkN3RWCnwto0SUOpJWvPCDzeV46YGY0UteqPKwM0AfZpyyBG++BGMMpkYLbKWH/Y1Pj2CqBS/6gVVUqYr1XyB5dkXRYk27AKY9uyT1erPv1hIkIPwFsRX0dkQedLoPx+sQxtoSl/RqzECc3LbOlbZOOlaI0mCfoIb/1Oyzk4ZaG8scWY+smkUe2uh/omS23SrYw6PDG2uQfmbO3czu+NuBSxSqb+wQ1S3jVoorpa4lJgM+vP8KVKVZVOKGTw74CPGlu4puS2cTf9BVUUDsIBz9Ve70YKMq2EJcguXOrUVuq6ay0mS/sMjjdabaWRvPt7/cUPX6Vu3KFLal4cFoQ8r+fO2d
 aF1YJa+e
 p128TO0KHREQZNAWHmjrP+16OjhYZ7UBXQpS8JbkJsF+YJCR3rrkIrtsDO4vJvh8Ai7TXCUN9HB6km2/f9ML3ONj3Ja7xW+pUuU++OnftO1j3hm1H+upQMcN0y+cT2d3MVRxsdF7OcR3C0GcCWRdUko3CXBaN2YdsBJbi/0Jwi9ndUAbignIW/r0eGMKi07CyXGWJudbaBoRKUQPZ9h66kcIbjN7h+ouqd4IMt0JNNlmSXRsVjz7YRZv8AKRIY2rM22i3Nqj+X9C5DCR2ywnsMF9Mb6WDLJlqs5hYCXhZMSRRwwezxXRIhwIhuVKXYkxXOBfrtFcs/hgTR3mBFtv/qgo0OlkTht8Xb3cKHgVC1E9Y8VEp/uS66N9Yvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 11:58:30 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Andrew: This series has been fully reviewed, and contains minimal
> changes compared to what is currently being tested in linux-next
> diff between v7 and v8 can be viewe, here: [8]
> 
> Four patches have been dropped compared to v7: and are going to be sent
> separately.
> 
> This series introduces the Live Update Orchestrator, a kernel subsystem
> designed to facilitate live kernel updates using a kexec-based reboot.
> This capability is critical for cloud environments, allowing hypervisors
> to be updated with minimal downtime for running virtual machines. LUO
> achieves this by preserving the state of selected resources, such as
> memory, devices and their dependencies, across the kernel transition.

Thanks, I updated mm.git's mm-nonmm-unstable branch to this version.

I expect I'll move all the below material into mm-nonmm-stable in a
couple of days.

kho-make-debugfs-interface-optional.patch
kho-drop-notifiers.patch
kho-add-interfaces-to-unpreserve-folios-page-ranges-and-vmalloc.patch
memblock-unpreserve-memory-in-case-of-error.patch
memblock-unpreserve-memory-in-case-of-error-fix.patch
test_kho-unpreserve-memory-in-case-of-error.patch
kho-dont-unpreserve-memory-during-abort.patch
liveupdate-kho-move-to-kernel-liveupdate.patch
liveupdate-kho-move-to-kernel-liveupdate-fix.patch
maintainers-update-kho-maintainers.patch
liveupdate-kho-use-%pe-format-specifier-for-error-pointer-printing.patch
#
kho-fix-misleading-log-message-in-kho_populate.patch
kho-convert-__kho_abort-to-return-void.patch
kho-introduce-high-level-memory-allocation-api.patch
kho-introduce-high-level-memory-allocation-api-fix.patch
kho-preserve-fdt-folio-only-once-during-initialization.patch
kho-verify-deserialization-status-and-fix-fdt-alignment-access.patch
kho-always-expose-output-fdt-in-debugfs.patch
kho-simplify-serialization-and-remove-__kho_abort.patch
kho-remove-global-preserved_mem_map-and-store-state-in-fdt.patch
kho-remove-abort-functionality-and-support-state-refresh.patch
kho-update-fdt-dynamically-for-subtree-addition-removal.patch
kho-allow-kexec-load-before-kho-finalization.patch
kho-allow-memory-preservation-state-updates-after-finalization.patch
kho-add-kconfig-option-to-enable-kho-by-default.patch
#
#
liveupdate-luo_core-live-update-orchestrato.patch
liveupdate-luo_core-integrate-with-kho.patch
kexec-call-liveupdate_reboot-before-kexec.patch
liveupdate-luo_session-add-sessions-support.patch
liveupdate-luo_core-add-user-interface.patch
liveupdate-luo_file-implement-file-systems-callbacks.patch
liveupdate-luo_session-add-ioctls-for-file-preservation.patch
docs-add-luo-documentation.patch
maintainers-add-liveupdate-entry.patch
mm-shmem-use-shmem_f_-flags-instead-of-vm_-flags.patch
mm-shmem-allow-freezing-inode-mapping.patch
mm-shmem-export-some-functions-to-internalh.patch
liveupdate-luo_file-add-private-argument-to-store-runtime-state.patch
mm-memfd_luo-allow-preserving-memfd.patch
docs-add-documentation-for-memfd-preservation-via-luo.patch
selftests-liveupdate-add-userspace-api-selftests.patch
selftests-liveupdate-add-simple-kexec-based-selftest-for-luo.patch
selftests-liveupdate-add-kexec-test-for-multiple-and-empty-sessions.patch
#
#
kho-free-chunks-using-free_page-instead-of-kfree.patch
#
test_kho-always-print-restore-status.patch
#
kho-kho_restore_vmalloc-fix-initialization-of-pages-array.patch
kho-fix-restoring-of-contiguous-ranges-of-order-0-pages.patch
#

