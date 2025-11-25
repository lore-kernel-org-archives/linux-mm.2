Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC56AD0EE0E
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2A46B0010; Tue, 25 Nov 2025 11:58:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A296B0011; Tue, 25 Nov 2025 11:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979D26B0012; Tue, 25 Nov 2025 11:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 848FC6B0010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:58:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 32D32B80B8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:58:59 +0000 (UTC)
X-FDA: 84149739198.07.9A82195
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C18840010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:58:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lA6TYquR;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YTqmNHLzo7tzA7JTUOF0GwvLgycpcp7G73ozWdvx2A8=;
	b=z2L+P++1iUx0bLKqp3n3vMJNUefY7uaSRkNUdcMjsLi+bd5QD3WMudHB0Xcxb4lfMLtCcO
	OWWb/HEXiSzER1d8kkI45XRwBwvWR0ofVqfwaAgjRIQGVR2+F5N067Zg6PBWzwAUW3pOSY
	Up1oM3SQo7+C8UF7/HTNZhs0zulEppk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=lA6TYquR;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089937; a=rsa-sha256;
	cv=none;
	b=m16O0bNCtuYARIeHEmc994Dp5NCspi3xAXP4vVWS5uIPH3M6xjlEZp+kKOyU0sM60maede
	zMl3TtylI4Js36gME8ZRz4z2iACaqGOi+H0eOgpjXBqZMdXIuAD706DleB8N/OPShY9ajd
	2znuvb6gszR4zzcfks9BAD8CPwCVn3s=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7866aca9ff4so58650807b3.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089936; x=1764694736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=YTqmNHLzo7tzA7JTUOF0GwvLgycpcp7G73ozWdvx2A8=;
        b=lA6TYquRqLPpfAZlIzDF9/SU8+vhYIuFQq1fMEegbSYlz3khhGlxqQEUCKRuJYuqd8
         /x4pVBbl2gEn6BTOqqdqxebuhxOor99npOJRn5H5IJQzfqnsD5V2n3LpSMDngIgR4KQu
         deZ+uucoRo7Mr8HABJVBZpKcF2Txe10lA9t7V6UO7wBBxIWFKn/vn+TLp3p2mAuUsiT5
         WZkDH8y9In2/HyjWknloJaYhZcGGjzK/jy45bo0DGhrXQzW0hOQJc/LnMoJ9XJ3W9bSf
         0jPAn161BZhJ17qd1h76IrllhTFNyiUEGaeIKnVPqKureLIBrg8O434R+xCX5Krl+89G
         o3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089936; x=1764694736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YTqmNHLzo7tzA7JTUOF0GwvLgycpcp7G73ozWdvx2A8=;
        b=gRcXI3sD/hHZhcx8yDnWM8eKt3V7IXR8lihjpfDMRa1XRFSHx6gGPsXV3GLGtLlsZl
         UCId6U8KDe8igO1J/K7nHvUXgJL9LeTsVEN1ur+yqHTg45vteT6BTAsai+Jqx9T2eNzU
         OAeZgYSSjqDCHc2Or+HyraSBH2rewq7fjvLDQvhgRxur6T+Drneiyl9kv9AVH0VKCBLy
         UYRafazn3AxuMA3V7VXyQMNoynAN+XoitpHsLQRKm7vF4Zco2iiQ25LD7BVJLFVqd5Vx
         Dm7atIO+RquHEacWceDreQ/RqYwnaIMegzPUSjSnuI8TGXyb02ALqYO+YT60omTEqLG0
         FADA==
X-Forwarded-Encrypted: i=1; AJvYcCWnj2y/4ryT+tJm7X9QvMUJFTWtWvCQDMkLkXl5CB+svOhQd1vZ0jlTGv33+YHpMOq0jJvwPHuVWw==@kvack.org
X-Gm-Message-State: AOJu0YyAJvvb3y4iBmsKHCCoqgEu+pVC1dtPKbI/W2Po9Yorf4HpLzGW
	Fh60qnwGvT6J1aSQJ2MuL8425e1MgCwrL1d8A8mcR5yA7tfUnUdEOfE3iXQ3DrP+v/c=
X-Gm-Gg: ASbGncvwBQKbDGVyeKHpfQRXcrgYpQYUPAXAH2KtuwZiYGIe+qyMBxVpIaEKMPVgxkU
	EG0EvOqZT7FdGlEFM2AyZwHXQXuR3GbYD2Jvusha+eCuHnq8tTDgvH8U6GPeve339coM4bwyJVl
	F4MLzGs9JQ4B+gT7gPAxP/s0UMBC2hCIvwSE0BHZ2rnxuxwbNaOb68av8WjBVDEz5On+K0uKFcr
	AHr72It4SZaorshZk9nxKtclH/GwmtGfUQOVmvikyFCrSY6lFE4IzPDpp6bM5nYwaoIbdhK/SU9
	mwyo0ie9qoM1cWZnug9D5IKHUbXwkX8lC7+2XUEziXsPW40ZikHOOF9N29o4Yi0q2q/mxCW51W2
	AIuiOS0YrSW7detc9WAFNF2ppbY9/c6h+hiw6AEryFUKdf7xEvlZ7zQvqxNyZLUBFHsLMF2hSz9
	BfiMrH8qjxCUiSn6WC1Y85E4BQgr2DbuSMuQ0szW6+XBEVrsJYtZ/lqZ4BhFEp4kYR
X-Google-Smtp-Source: AGHT+IFlGlAqfg3sgpTFRFuiP3B5xnmQBkkcc9sAGNtrDo+gmfCnheeaiZNxk8RVJmj4AT68BfJgow==
X-Received: by 2002:a05:690c:2784:b0:786:7aaa:a04f with SMTP id 00721157ae682-78a8b47f8d2mr141269687b3.8.1764089936257;
        Tue, 25 Nov 2025 08:58:56 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:58:55 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v8 00/18] Live Update Orchestrator
Date: Tue, 25 Nov 2025 11:58:30 -0500
Message-ID: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C18840010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5n5no5d1ef6os3nzye6d17bzqyirdrkz
X-HE-Tag: 1764089937-303929
X-HE-Meta: U2FsdGVkX1+p4o09hUVgqllsbMorcnaa/MpBmxNupHllOUkDhzZjMX6daInk0y0oBVr8zP3eAXQ2/sZKDE01+fyDBW+NPri3KooTDxR37bqA7h9mTzIwSqMSqba+LpjGljeFRZaMrPUKA9k+eZYbhxQCKjWGaQm1BoaRSM08EU3v2mJgg+dxV7vApPcJS5rsSDTp4EMlR+2j7r/Rmp+HvoJ8y39OvD6809fh+R5RBoEKNNJL33RF66IHZUBd6lxpDY+jstOCnBWBytn0zGwgF0Am98nYTRqHfc66pAX0UnksChvK5ACI8wlwOtNfyCTnVJ4rryM7TGPVlxsP+q6LxyZGuhBK4Vzh4qpRABavJbG+/jS9w0MiUV+oM9Ssr+PeyFh8oi7Yg1zWtmh0CbXMvmJVO2ZxbTnWMMqQK5hwRvwtKZVakMf8GNLGH7YuD/AX3iA7z1lHoRxyZ9TGxLU3Y2YN0BS4V3b7qrOFH80OxD4qc7nirPvR/wJ0/Koq0I6nw1OlrM1AsJXOSn6wGjyTARag86Ws8ZH/eWEuZ5VohlxrQXrxKMDJCI/n9A976ahu95C+D3Hxab0mcyc1/p1aEL7dG/dfzkjhhEMwMJ62xJrkISwRKkEP72KsH/aMUa50oVFw0a2uGCiH/lhJ9/GjVyRqOQJRB5EEZTYGZ0udOxnCLShWhPeCcJN7bxTLwAbLEbz77LckYeIJbcqMKIN5wDjERCCoxBERNub8sFULJD451b524OWLHmDdbeR2aSqiJcW03rdv4IEus60tOR8q+IhevEhQ9kdPy/L9Y5EQosbtAeeaB54MORuHtJTj14SgZOeIMkewCWhdVMovkqT0CggUcx6Kd+uUR1augW9YhDWlyzk945RehULvUjtz9z48npmjwHPjB79Ew0Sb/ssygqWhFp3p8lQYkka0s4uNr8lgCMT6H3yIZ5PIoksnW3pbjJNRRlrDzDDdGo1wpaf
 ECEs106x
 hGJZz1MkM7wyqy12B9lZSfuhferd1k1rygxCDxRJM4zyvIQP3k+icP7GEF+PuD1cucEdZB+RyQB8XjZBkq3+evk1bFZ8PUxGlALuZJq5xXtlV0E5HAJgN3tO5ks9k2ByrQhWolDjhenVKZdy/zYw2U6s+aPnnZbdRny1jdXxpolrpplTN2sD0OkSZsY2Vr73v/aqUDaadjl59+2hNCkgQ5mayHGUKipmLMf5Z/VYeDQJuNwnTi1DnCRKl7bb3+PPZf7YA8EoINHmPTuq9WqHg02sWQTAtL21bk7ZFv5L32B9vifmaxxzvsbPiRnnCZlLsyIKR8yWqae0XUr1rfVzxAKA6WgGRjw1GOFtogAARtB8q0EzYb3FOiqsOwMbojesdYXVzmharo6uWxXbkwNXNr1ZqHLdehRNpvAbBwWMr5asPE+8nswFOMXz9S2L+bcLDqAGVk6ULlF38qQ3HIUiXW5NBGmbFKHfuBRdTja2ktynds3Jc8io55WlSRhHG3JZlDVWICQe8cO09bx3l59RxtDMd7N6JwFmeUQNOc03rolspqHmGhMLEkYEJ6fVaz6ZSI2299EddTNXMpgsyr8pl0v9m4mLYyR1vTjxFXNPWI3IFoHMeNmpwvd/PVS4FfZH4IadTDWrGgVDJWdhRG1Gv3OrVnjEZK/E4bLj0s7ECiT9A5Rc/QhuUs3TqP5hT5EJuUFCu2UlaYAP2U/mlwOnAE3kFTtZ+0XKA5GXpYql5Ra+UtGPVS+uLNDHZRBstWokLESs+SqB99TAlIpO/1f0WIRi+1tE3U6H/rTDOsO/A+tMfZTS3a0FpHGRkqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew: This series has been fully reviewed, and contains minimal
changes compared to what is currently being tested in linux-next
diff between v7 and v8 can be viewe, here: [8]

Four patches have been dropped compared to v7: and are going to be sent
separately.

This series introduces the Live Update Orchestrator, a kernel subsystem
designed to facilitate live kernel updates using a kexec-based reboot.
This capability is critical for cloud environments, allowing hypervisors
to be updated with minimal downtime for running virtual machines. LUO
achieves this by preserving the state of selected resources, such as
memory, devices and their dependencies, across the kernel transition.

As a key feature, this series includes support for preserving memfd file
descriptors, which allows critical in-memory data, such as guest RAM or
any other large memory region, to be maintained in RAM across the kexec
reboot.

The other series that use LUO, are VFIO [1], IOMMU [2], and PCI [3]
preservations.

Github repo of this series [4].

The core of LUO is a framework for managing the lifecycle of preserved
resources through a userspace-driven interface. Key features include:

- Session Management
  Userspace agent (i.e. luod [5]) creates named sessions, each
  represented by a file descriptor (via centralized agent that controls
  /dev/liveupdate). The lifecycle of all preserved resources within a
  session is tied to this FD, ensuring automatic kernel cleanup if the
  controlling userspace agent crashes or exits unexpectedly.

- File Preservation
  A handler-based framework allows specific file types (demonstrated
  here with memfd) to be preserved. Handlers manage the serialization,
  restoration, and lifecycle of their specific file types.

- File-Lifecycle-Bound State
  A new mechanism for managing shared global state whose lifecycle is
  tied to the preservation of one or more files. This is crucial for
  subsystems like IOMMU or HugeTLB, where multiple file descriptors may
  depend on a single, shared underlying resource that must be preserved
  only once.

- KHO Integration
  LUO drives the Kexec Handover framework programmatically to pass its
  serialized metadata to the next kernel. The LUO state is finalized and
  added to the kexec image just before the reboot is triggered. In the
  future this step will also be removed once stateless KHO is
  merged [6].

- Userspace Interface
  Control is provided via ioctl commands on /dev/liveupdate for creating
  and retrieving sessions, as well as on session file descriptors for
  managing individual files.

- Testing
  The series includes a set of selftests, including userspace API
  validation, kexec-based lifecycle tests for various session and file
  scenarios, and a new in-kernel test module to validate the FLB logic.

Changelog since v7 [7]
- Collected Reviewed-by tags from Mike Rapoport, Pratyush Yadav.
- Addressed mostly nits. The diff can be viewed here [8].
 
[1] https://lore.kernel.org/all/20251018000713.677779-1-vipinsh@google.com/
[2] https://lore.kernel.org/linux-iommu/20250928190624.3735830-1-skhawaja@google.com
[3] https://lore.kernel.org/linux-pci/20250916-luo-pci-v2-0-c494053c3c08@kernel.org
[4] https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v8
[5] https://tinyurl.com/luoddesign
[6] https://lore.kernel.org/all/20251020100306.2709352-1-jasonmiu@google.com
[7] https://lore.kernel.org/all/20251115233409.768044-1-pasha.tatashin@soleen.com
[8] https://github.com/soleen/linux/blob/luo/v8b03/diff.v7.v8

Pasha Tatashin (12):
  liveupdate: luo_core: Live Update Orchestrato,
  liveupdate: luo_core: integrate with KHO
  kexec: call liveupdate_reboot() before kexec
  liveupdate: luo_session: add sessions support
  liveupdate: luo_core: add user interface
  liveupdate: luo_file: implement file systems callbacks
  liveupdate: luo_session: Add ioctls for file preservation
  docs: add luo documentation
  MAINTAINERS: add liveupdate entry
  selftests/liveupdate: Add userspace API selftests
  selftests/liveupdate: Add simple kexec-based selftest for LUO
  selftests/liveupdate: Add kexec test for multiple and empty sessions

Pratyush Yadav (6):
  mm: shmem: use SHMEM_F_* flags instead of VM_* flags
  mm: shmem: allow freezing inode mapping
  mm: shmem: export some functions to internal.h
  liveupdate: luo_file: add private argument to store runtime state
  mm: memfd_luo: allow preserving memfd
  docs: add documentation for memfd preservation via LUO

 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/liveupdate.rst         |  61 ++
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/memfd_preservation.rst       |  23 +
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 Documentation/userspace-api/liveupdate.rst    |  20 +
 MAINTAINERS                                   |  16 +
 include/linux/kho/abi/luo.h                   | 166 ++++
 include/linux/kho/abi/memfd.h                 |  77 ++
 include/linux/liveupdate.h                    | 138 +++
 include/linux/shmem_fs.h                      |  23 +
 include/uapi/linux/liveupdate.h               | 216 +++++
 kernel/kexec_core.c                           |   5 +
 kernel/liveupdate/Kconfig                     |  21 +
 kernel/liveupdate/Makefile                    |   7 +
 kernel/liveupdate/luo_core.c                  | 450 +++++++++
 kernel/liveupdate/luo_file.c                  | 889 ++++++++++++++++++
 kernel/liveupdate/luo_internal.h              | 110 +++
 kernel/liveupdate/luo_session.c               | 646 +++++++++++++
 mm/Makefile                                   |   1 +
 mm/internal.h                                 |   6 +
 mm/memfd_luo.c                                | 516 ++++++++++
 mm/shmem.c                                    |  49 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/liveupdate/.gitignore |   9 +
 tools/testing/selftests/liveupdate/Makefile   |  34 +
 tools/testing/selftests/liveupdate/config     |  11 +
 .../testing/selftests/liveupdate/do_kexec.sh  |  16 +
 .../testing/selftests/liveupdate/liveupdate.c | 348 +++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  89 ++
 .../selftests/liveupdate/luo_multi_session.c  | 162 ++++
 .../selftests/liveupdate/luo_test_utils.c     | 266 ++++++
 .../selftests/liveupdate/luo_test_utils.h     |  44 +
 34 files changed, 4407 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/mm/memfd_preservation.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst
 create mode 100644 include/linux/kho/abi/luo.h
 create mode 100644 include/linux/kho/abi/memfd.h
 create mode 100644 include/linux/liveupdate.h
 create mode 100644 include/uapi/linux/liveupdate.h
 create mode 100644 kernel/liveupdate/luo_core.c
 create mode 100644 kernel/liveupdate/luo_file.c
 create mode 100644 kernel/liveupdate/luo_internal.h
 create mode 100644 kernel/liveupdate/luo_session.c
 create mode 100644 mm/memfd_luo.c
 create mode 100644 tools/testing/selftests/liveupdate/.gitignore
 create mode 100644 tools/testing/selftests/liveupdate/Makefile
 create mode 100644 tools/testing/selftests/liveupdate/config
 create mode 100755 tools/testing/selftests/liveupdate/do_kexec.sh
 create mode 100644 tools/testing/selftests/liveupdate/liveupdate.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_kexec_simple.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_multi_session.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.c
 create mode 100644 tools/testing/selftests/liveupdate/luo_test_utils.h


base-commit: 2cb7e27ffe3e3e1d8a837026462ebca22cba3b4f
-- 
2.52.0.460.gd25c4c69ec-goog


