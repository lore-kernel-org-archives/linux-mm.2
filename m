Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F2DBCA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 16:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165796B0005; Sat, 30 Aug 2025 12:40:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1168A6B0006; Sat, 30 Aug 2025 12:40:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004F16B0007; Sat, 30 Aug 2025 12:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DBF0C6B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 12:40:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CC601A01FE
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:40:05 +0000 (UTC)
X-FDA: 83833985970.17.705877E
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8577A4000B
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:40:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NggsBWNZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756572003; a=rsa-sha256;
	cv=none;
	b=TKdxs62PuCRIjrNT0vEBOCzCx1j/s7tf7qm2spElD4gTfOXUYulJgnxYXuUv1QWbl38Rtx
	Ss4ZhVLheQcrFuhLXgH/UV0PRHAERjScFVEdgXsReR624tRRRp6EoDHwhOIAFSNaOi4V8q
	fE+0GEqa8XoPnNFgtybmuik6w7nJWaE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NggsBWNZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756572003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=omIq/jRweSA2RXSesekY4OTDGwBK1jNfbMwnq5InzPE=;
	b=BX18JSPMlBZQqkVPA/rFfaCWbrSS+vhQsa3En6KVaz0Tj7YSvj2tDCEvxoMFbzIz7+qzT+
	VqENGOU8m1VDj++B4PMZ8ylHsB1EbcPt1QUGqqZhKFIFjV8bG1z1hmVfC55P+1MrNV+b1B
	zL7F/xxTwPadOm/vgRqPEtr2u8Q1YvM=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4c645aaa58so2068043a12.2
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 09:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756572002; x=1757176802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=omIq/jRweSA2RXSesekY4OTDGwBK1jNfbMwnq5InzPE=;
        b=NggsBWNZElfvcs8A1MVP/tQwTJK+bCIp36h1RhDEjNWnGRbCCCiH3N699hmurPd+8a
         fDbKiViqiOjV3rISJQkWergXpnC6l6gO7LBd1dYEyavmh7rgGojKD8YiEk09E5tGGsAN
         C996CyaUAL14anAy2NafACzt6a3i06NXzcZtpEFZQx//5bkhXWa3YqxEZbKh0/FwOIvw
         L+E6rO659oMfpFGcHOkg8Ys4etbQ3V8Q00EwKDf5OM7zdqaacXrlWeCpM7abmxXPMMKB
         oGy3rsqSCdDl6TucO2wUdYy5Qq9T/MuQrdUAa0ZZ3Ssbyu+kjAYswkYE3x0qDL+nrtYl
         Q/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756572002; x=1757176802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=omIq/jRweSA2RXSesekY4OTDGwBK1jNfbMwnq5InzPE=;
        b=iWXE83hbG6B5V8m0u6bdZGQ+C8OeJL52RRbn2V7PM6ZWQyTqLaGNAN3EbbGmxoslq2
         qmxSh3dubFOSepJByN5gyD+ZxttzRZlXQuaH1968BGM+aP53BE6eNZDccIx+M68pnbom
         714drc+nq1xS0ZifAzXBqJW/Pub1BfPzbCJVqrO/pZhslEH5xQ5D93NXLj8tA2jHtRPw
         Cjp13/ecWNLQB/R2PMevyvnhwa71yKIrwVBZdhihUPXJeAL2wGhxZcmFarUUeAF+mEmY
         gf0EKiL5OdSL/FCipqqlEsvND7UsoilRDXMnDIbQQlHIVmPxRsqaqZX1TAV9NIp6mpZu
         lEEw==
X-Forwarded-Encrypted: i=1; AJvYcCUoK6p57O/knLlrg5dA7GGO6qE894FKNU+X0T8uyeMmE+kncTp48A0m4rN4Fax2/+I4I/wky1vTrg==@kvack.org
X-Gm-Message-State: AOJu0Yw8MV03VayB7OdOXpjmE+YyMlZ3bYp2NqU0wpPVQkPoStRtrgsB
	0v4Ue/k8RPRN4fkkT8I+9t/b5l9WPpVaKdKz3kDTk1qxpwOFrfwyU9F9
X-Gm-Gg: ASbGnct18mFD9atPIlEBws7RQVxGDqS/kkt3W3pbekS3EjHxGxHQYiwiaeaHPmsJQZl
	eEDJogYEXZe2NHprer55foavFaqwwDN6JsvKddQDZOWYmH72SagWqbmy3Hx+iO/Q6NXV39lPB1y
	gA0mImGqYVTwA0hpYgJTcYNjpDs3NA1GXt1SZiwrAoDb7jWonk+v+gmiO7RKOMp/siyvMqeK7Us
	coxTTssrgHfGrgPojuoqgBAzprgV9ZUQz01zVyvqCA6IitZ+rZEq4ORqC38SnS2VEos7z+qNUcQ
	ogG1kMEvxzMmUfVMSLSyuAfZObXz5iP69Pe87cJ853QVZAgHvJNSY8u1P4ol+nJwollnJKi+FCT
	j4jcD0DYUNsY+Wh0TZCBrhDvdZnXngLltDWy1dECsawJtinkRJAiAXza02KPPu4ThtCv+wuAWaZ
	tuU3pEufrxoeeQzRqkiQ==
X-Google-Smtp-Source: AGHT+IF58PN49BVPicK4eXVJa8rOyB8Avo9KrMnatVloYSyi+rVeeyvzrog6JTu0UoAF3EqvJJSf5g==
X-Received: by 2002:a17:903:19e4:b0:248:db40:daed with SMTP id d9443c01a7336-24944871fc8mr43509805ad.1.1756572001992;
        Sat, 30 Aug 2025 09:40:01 -0700 (PDT)
Received: from server.. ([103.251.57.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903702396sm56975555ad.14.2025.08.30.09.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Aug 2025 09:40:01 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: reddybalavignesh9979@gmail.com,
	akpm@linux-foundation.org,
	richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	davem@davemloft.net,
	david@redhat.com,
	edumazet@google.com,
	gnoack@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mic@digikod.net,
	ming.lei@redhat.com,
	pabeni@redhat.com,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: [PATCH v2 0/2] selftests: Centralize kselftest headers to avoid relative includes
Date: Sat, 30 Aug 2025 22:09:47 +0530
Message-ID: <20250830163949.20952-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8577A4000B
X-Stat-Signature: qoactdxekty6bdaue5cayrkq31xsmm8n
X-HE-Tag: 1756572003-551324
X-HE-Meta: U2FsdGVkX18fVbpDyE4q1US37we03UZK5G9/v7m447T0yMgHnDr5ZTGgSpSj/O+TStYfHpxX31P4SyKq7xxJhNdyYaIvl7YjARLYKC00UrioJY8hDpW4Dvrgj3PZVNtYXwyr45KGTAE/RK1Tf/KuVpmxg2diJkqA3QRf5Uktd7tkTrYchvNq+8fY5Emh5TWm4iwX3fBp1J1xZkdILAARKuRLI0ld2bmzwjiF9WHzwi1kAA0XedD8+v712NDT1kHAExLOXJJE2c2RJcy5ybSZri+x3IsWkLDDNDFcMeBNXN9NYwtn4yO1yjOkdKy6iHd0RV3Zp7R/faUQo5aHziYqgHldo3eN8xzy7MrBMSxUdZUmphlfCJ3/m4nncBJfXAztdWA82QV8qvm3n7obeKbM7PYgldhJvunM/3Al+2CsS7IeZlWzfni89+m7DbmDkcTboPBv10XdbO9R3P40wed0MdRlFTaRwOxoxzYg08pLqaZp5mO6dkGC0SJIbfwCfli2E/sPj5te4jFC8bJWidcA5oqhuSUJhUqiVM7VFr37B9EZPZjA2NNYocyW3uvrKkjNZFNLyeKo9v5oc3jol199ee3JploGUZXJhz4HkshMzlXfg4d/N9kIP76N9xuBaLHtlO/uN9pUocJZPcs4iTZfMEeO3EsSuOaXNRxq3A4/O1kS3bYfadstyjJnJYFc4HTV13QQSInMCde33OPMg2rfw6/wtQU4YgZkfSvfJn5LTAwL3YcqNPrt+HtbcTOeT5BmLj3bBMrOrri+sNbB01MZexth/tXdNsSRrEIsaB00egyWiskBSjmbGsYkFz0LXfpVYIk1Sw7+m6lnVyZzLX+CUKynFiCBhJztzD2tKQMvaPVyYMhDVA+NkMnVuCzRKFtyY/VHiPOf9LDxnjVrBLGiMVwhFAyk9hTRifUzFkaCVzBQIHliZOEZnD9B7+sXgOBUqnHBS67HgbaWS0+iIHR
 kpu2S/DO
 X3FCkeGUxfeaWuS/lfrvFL9avu6IKQXK7xcHWeLAXE3Ac4aGs4jHDOx//dYDjuVLQiH3O/XF51swD3ZFFphXNXdgJSoKRrSeioaNsJmdZLkYjgCkHMhUWBsJ8iUuyDGnzdShGEJJ/by9mHea970NDGc8IS/hzJGKTzABastOd9NxULvs+n6Rhf5aQ9mBaT/68r2PqDZ12r8KxjKzxlJGYXf3MQSrl8BdX63p4BnBdAOLXYuxopMse8w7mOxueURNWIwVFzoBWBUGyAx6XYJsXTFUVGp9HjblZoBNBNqurhQx1/xxINY9v69EsGMCui+s9gF5XiauNP0p5lV4k6C//QG+dLiz3n6j8GLTycME5MtaNH8yMY4SM49t5yRd4POBaQpm0H5FQ1N4QmA1gCY9KfFf81HK1v0a6RoiR4mQzbsJMPhN8rHrE74AdX3flXytP1tWKfqY+0eO53MDPeMEHjDD1MjR/rQHoN/vCdeW7LGDim/9xe94afvw0mgmzzJza+wvdaF3wZ/ycpRIXSAiI5QMjcg8BXo5IwzEENZv2ohEo3uI/+LBiTmMZQCVMSqjNB+xc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series centralize the handling of kselftest.h and
kselftest_harness.h includes in selftests, replacing relative
paths with a non-relative approach using shared -I path.

Patch-1 updates the build files lib.mk and 
include CFLAGS in sync/Makefile to resolve not found error
Patch-2 applies bulk source changes

In v2, the include path for selftests headers is added once in
lib.mk via top_srcdir, by which top level selftests build and
direct subdirectory builds work.

Tested with gcc-13.3 and clang-18.1.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/lkml/20250820143954.33d95635e504e94df01930d0@linux-foundation.org/

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
---
Changes in v2:
Patch 1: Move include path into lib.mk using top_srcdir; drop Makefile change;
Patch 2 unchanged.
Suggested-by: Wei Yang <richard.weiyang@gmail.com>
---

Bala-Vignesh-Reddy (2):
  selftests: Centralize include path for kselftest.h and
    kselftest_harness.h
  selftests: Replace relative includes with non-relative for kselftest.h
    and kselftest_harness.h

 tools/testing/selftests/acct/acct_syscall.c                   | 2 +-
 tools/testing/selftests/alsa/conf.c                           | 2 +-
 tools/testing/selftests/alsa/mixer-test.c                     | 2 +-
 tools/testing/selftests/alsa/pcm-test.c                       | 2 +-
 tools/testing/selftests/alsa/test-pcmtest-driver.c            | 2 +-
 tools/testing/selftests/alsa/utimer-test.c                    | 2 +-
 tools/testing/selftests/arm64/abi/hwcap.c                     | 2 +-
 tools/testing/selftests/arm64/abi/ptrace.c                    | 2 +-
 tools/testing/selftests/arm64/abi/syscall-abi.c               | 2 +-
 tools/testing/selftests/arm64/fp/fp-ptrace.c                  | 2 +-
 tools/testing/selftests/arm64/fp/fp-stress.c                  | 2 +-
 tools/testing/selftests/arm64/fp/sve-probe-vls.c              | 2 +-
 tools/testing/selftests/arm64/fp/sve-ptrace.c                 | 2 +-
 tools/testing/selftests/arm64/fp/vec-syscfg.c                 | 2 +-
 tools/testing/selftests/arm64/fp/za-ptrace.c                  | 2 +-
 tools/testing/selftests/arm64/fp/zt-ptrace.c                  | 2 +-
 tools/testing/selftests/arm64/gcs/gcs-stress.c                | 2 +-
 tools/testing/selftests/arm64/pauth/pac.c                     | 2 +-
 tools/testing/selftests/arm64/tags/tags_test.c                | 2 +-
 tools/testing/selftests/bpf/xskxceiver.c                      | 2 +-
 tools/testing/selftests/breakpoints/breakpoint_test.c         | 2 +-
 tools/testing/selftests/breakpoints/breakpoint_test_arm64.c   | 2 +-
 tools/testing/selftests/breakpoints/step_after_suspend_test.c | 2 +-
 tools/testing/selftests/cachestat/test_cachestat.c            | 2 +-
 tools/testing/selftests/capabilities/test_execve.c            | 2 +-
 tools/testing/selftests/capabilities/validate_cap.c           | 2 +-
 tools/testing/selftests/cgroup/test_core.c                    | 2 +-
 tools/testing/selftests/cgroup/test_cpu.c                     | 2 +-
 tools/testing/selftests/cgroup/test_cpuset.c                  | 2 +-
 tools/testing/selftests/cgroup/test_freezer.c                 | 2 +-
 tools/testing/selftests/cgroup/test_hugetlb_memcg.c           | 2 +-
 tools/testing/selftests/cgroup/test_kill.c                    | 2 +-
 tools/testing/selftests/cgroup/test_kmem.c                    | 2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c              | 2 +-
 tools/testing/selftests/cgroup/test_pids.c                    | 2 +-
 tools/testing/selftests/cgroup/test_zswap.c                   | 2 +-
 tools/testing/selftests/clone3/clone3.c                       | 2 +-
 .../testing/selftests/clone3/clone3_cap_checkpoint_restore.c  | 2 +-
 tools/testing/selftests/clone3/clone3_clear_sighand.c         | 2 +-
 tools/testing/selftests/clone3/clone3_selftests.h             | 2 +-
 tools/testing/selftests/clone3/clone3_set_tid.c               | 2 +-
 tools/testing/selftests/connector/proc_filter.c               | 2 +-
 tools/testing/selftests/core/close_range_test.c               | 2 +-
 tools/testing/selftests/core/unshare_test.c                   | 2 +-
 tools/testing/selftests/coredump/stackdump_test.c             | 2 +-
 tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c            | 2 +-
 tools/testing/selftests/drivers/dma-buf/udmabuf.c             | 2 +-
 tools/testing/selftests/drivers/ntsync/ntsync.c               | 2 +-
 .../testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c  | 2 +-
 tools/testing/selftests/exec/check-exec.c                     | 2 +-
 tools/testing/selftests/exec/execveat.c                       | 2 +-
 tools/testing/selftests/exec/load_address.c                   | 2 +-
 tools/testing/selftests/exec/non-regular.c                    | 2 +-
 tools/testing/selftests/exec/null-argv.c                      | 2 +-
 tools/testing/selftests/exec/recursion-depth.c                | 2 +-
 tools/testing/selftests/fchmodat2/fchmodat2_test.c            | 2 +-
 tools/testing/selftests/filelock/ofdlocks.c                   | 2 +-
 tools/testing/selftests/filesystems/anon_inode_test.c         | 2 +-
 tools/testing/selftests/filesystems/binderfs/binderfs_test.c  | 2 +-
 tools/testing/selftests/filesystems/devpts_pts.c              | 2 +-
 tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c | 2 +-
 tools/testing/selftests/filesystems/eventfd/eventfd_test.c    | 2 +-
 tools/testing/selftests/filesystems/file_stressor.c           | 2 +-
 tools/testing/selftests/filesystems/kernfs_test.c             | 2 +-
 .../selftests/filesystems/mount-notify/mount-notify_test.c    | 2 +-
 .../selftests/filesystems/mount-notify/mount-notify_test_ns.c | 2 +-
 tools/testing/selftests/filesystems/nsfs/iterate_mntns.c      | 2 +-
 tools/testing/selftests/filesystems/overlayfs/dev_in_maps.c   | 2 +-
 .../selftests/filesystems/overlayfs/set_layers_via_fds.c      | 2 +-
 .../testing/selftests/filesystems/statmount/listmount_test.c  | 2 +-
 .../testing/selftests/filesystems/statmount/statmount_test.c  | 2 +-
 .../selftests/filesystems/statmount/statmount_test_ns.c       | 2 +-
 tools/testing/selftests/filesystems/utils.c                   | 2 +-
 tools/testing/selftests/hid/hid_common.h                      | 2 +-
 tools/testing/selftests/intel_pstate/aperf.c                  | 2 +-
 tools/testing/selftests/iommu/iommufd_utils.h                 | 2 +-
 tools/testing/selftests/ipc/msgque.c                          | 2 +-
 tools/testing/selftests/ir/ir_loopback.c                      | 2 +-
 tools/testing/selftests/kcmp/kcmp_test.c                      | 2 +-
 tools/testing/selftests/kselftest_harness.h                   | 2 +-
 tools/testing/selftests/kselftest_harness/harness-selftest.c  | 2 +-
 tools/testing/selftests/landlock/audit.h                      | 2 +-
 tools/testing/selftests/landlock/common.h                     | 2 +-
 tools/testing/selftests/lib.mk                                | 2 ++
 tools/testing/selftests/lsm/lsm_get_self_attr_test.c          | 2 +-
 tools/testing/selftests/lsm/lsm_list_modules_test.c           | 2 +-
 tools/testing/selftests/lsm/lsm_set_self_attr_test.c          | 2 +-
 tools/testing/selftests/media_tests/media_device_open.c       | 2 +-
 tools/testing/selftests/media_tests/media_device_test.c       | 2 +-
 tools/testing/selftests/membarrier/membarrier_test_impl.h     | 2 +-
 tools/testing/selftests/mincore/mincore_selftest.c            | 4 ++--
 tools/testing/selftests/mm/compaction_test.c                  | 2 +-
 tools/testing/selftests/mm/cow.c                              | 2 +-
 tools/testing/selftests/mm/droppable.c                        | 2 +-
 tools/testing/selftests/mm/guard-regions.c                    | 2 +-
 tools/testing/selftests/mm/gup_longterm.c                     | 2 +-
 tools/testing/selftests/mm/gup_test.c                         | 2 +-
 tools/testing/selftests/mm/hmm-tests.c                        | 2 +-
 tools/testing/selftests/mm/hugepage-mmap.c                    | 2 +-
 tools/testing/selftests/mm/hugepage-mremap.c                  | 2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c                  | 2 +-
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c            | 2 +-
 tools/testing/selftests/mm/hugetlb-soft-offline.c             | 2 +-
 tools/testing/selftests/mm/hugetlb_dio.c                      | 2 +-
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c         | 2 +-
 tools/testing/selftests/mm/hugetlb_madv_vs_map.c              | 2 +-
 tools/testing/selftests/mm/ksm_functional_tests.c             | 2 +-
 tools/testing/selftests/mm/ksm_tests.c                        | 2 +-
 tools/testing/selftests/mm/madv_populate.c                    | 2 +-
 tools/testing/selftests/mm/map_fixed_noreplace.c              | 2 +-
 tools/testing/selftests/mm/map_hugetlb.c                      | 2 +-
 tools/testing/selftests/mm/map_populate.c                     | 2 +-
 tools/testing/selftests/mm/mdwe_test.c                        | 2 +-
 tools/testing/selftests/mm/memfd_secret.c                     | 2 +-
 tools/testing/selftests/mm/merge.c                            | 2 +-
 tools/testing/selftests/mm/migration.c                        | 2 +-
 tools/testing/selftests/mm/mkdirty.c                          | 2 +-
 tools/testing/selftests/mm/mlock-random-test.c                | 2 +-
 tools/testing/selftests/mm/mlock2-tests.c                     | 2 +-
 tools/testing/selftests/mm/mrelease_test.c                    | 2 +-
 tools/testing/selftests/mm/mremap_dontunmap.c                 | 2 +-
 tools/testing/selftests/mm/mremap_test.c                      | 2 +-
 tools/testing/selftests/mm/mseal_test.c                       | 2 +-
 tools/testing/selftests/mm/on-fault-limit.c                   | 2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c                    | 2 +-
 tools/testing/selftests/mm/pfnmap.c                           | 2 +-
 tools/testing/selftests/mm/pkey-helpers.h                     | 2 +-
 tools/testing/selftests/mm/process_madv.c                     | 2 +-
 tools/testing/selftests/mm/soft-dirty.c                       | 2 +-
 tools/testing/selftests/mm/split_huge_page_test.c             | 2 +-
 tools/testing/selftests/mm/thuge-gen.c                        | 2 +-
 tools/testing/selftests/mm/transhuge-stress.c                 | 2 +-
 tools/testing/selftests/mm/uffd-common.h                      | 2 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c                   | 2 +-
 tools/testing/selftests/mm/va_high_addr_switch.c              | 2 +-
 tools/testing/selftests/mm/virtual_address_range.c            | 2 +-
 tools/testing/selftests/mm/vm_util.c                          | 2 +-
 tools/testing/selftests/mm/vm_util.h                          | 2 +-
 tools/testing/selftests/mount_setattr/mount_setattr_test.c    | 2 +-
 .../move_mount_set_group/move_mount_set_group_test.c          | 2 +-
 tools/testing/selftests/mqueue/mq_open_tests.c                | 2 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c                | 2 +-
 .../selftests/mseal_system_mappings/sysmap_is_sealed.c        | 4 ++--
 tools/testing/selftests/nci/nci_dev.c                         | 2 +-
 tools/testing/selftests/net/af_unix/diag_uid.c                | 2 +-
 tools/testing/selftests/net/af_unix/msg_oob.c                 | 2 +-
 tools/testing/selftests/net/af_unix/scm_inq.c                 | 2 +-
 tools/testing/selftests/net/af_unix/scm_pidfd.c               | 2 +-
 tools/testing/selftests/net/af_unix/scm_rights.c              | 2 +-
 tools/testing/selftests/net/af_unix/unix_connect.c            | 2 +-
 tools/testing/selftests/net/bind_timewait.c                   | 2 +-
 tools/testing/selftests/net/bind_wildcard.c                   | 2 +-
 tools/testing/selftests/net/can/test_raw_filter.c             | 2 +-
 tools/testing/selftests/net/cmsg_sender.c                     | 2 +-
 tools/testing/selftests/net/epoll_busy_poll.c                 | 2 +-
 tools/testing/selftests/net/gro.c                             | 2 +-
 tools/testing/selftests/net/ip_local_port_range.c             | 2 +-
 tools/testing/selftests/net/ipsec.c                           | 2 +-
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.c  | 2 +-
 tools/testing/selftests/net/netlink-dumps.c                   | 2 +-
 tools/testing/selftests/net/proc_net_pktgen.c                 | 2 +-
 tools/testing/selftests/net/psock_fanout.c                    | 2 +-
 tools/testing/selftests/net/psock_tpacket.c                   | 2 +-
 tools/testing/selftests/net/reuseaddr_ports_exhausted.c       | 2 +-
 tools/testing/selftests/net/reuseport_bpf.c                   | 2 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c              | 2 +-
 tools/testing/selftests/net/rxtimestamp.c                     | 2 +-
 tools/testing/selftests/net/sk_so_peek_off.c                  | 2 +-
 tools/testing/selftests/net/so_incoming_cpu.c                 | 2 +-
 tools/testing/selftests/net/socket.c                          | 2 +-
 tools/testing/selftests/net/tap.c                             | 2 +-
 tools/testing/selftests/net/tcp_ao/lib/setup.c                | 2 +-
 tools/testing/selftests/net/tcp_fastopen_backup_key.c         | 2 +-
 tools/testing/selftests/net/tls.c                             | 2 +-
 tools/testing/selftests/net/toeplitz.c                        | 2 +-
 tools/testing/selftests/net/tun.c                             | 2 +-
 tools/testing/selftests/net/udpgso_bench_tx.c                 | 2 +-
 tools/testing/selftests/openat2/helpers.h                     | 2 +-
 tools/testing/selftests/openat2/openat2_test.c                | 2 +-
 tools/testing/selftests/openat2/rename_attack_test.c          | 2 +-
 tools/testing/selftests/openat2/resolve_test.c                | 2 +-
 tools/testing/selftests/pci_endpoint/pci_endpoint_test.c      | 2 +-
 tools/testing/selftests/perf_events/mmap.c                    | 2 +-
 tools/testing/selftests/perf_events/remove_on_exec.c          | 2 +-
 tools/testing/selftests/perf_events/sigtrap_threads.c         | 2 +-
 tools/testing/selftests/perf_events/watermark_signal.c        | 2 +-
 tools/testing/selftests/pid_namespace/pid_max.c               | 2 +-
 tools/testing/selftests/pid_namespace/regression_enomem.c     | 2 +-
 tools/testing/selftests/pidfd/pidfd.h                         | 2 +-
 tools/testing/selftests/pidfd/pidfd_bind_mount.c              | 2 +-
 tools/testing/selftests/pidfd/pidfd_fdinfo_test.c             | 2 +-
 tools/testing/selftests/pidfd/pidfd_file_handle_test.c        | 2 +-
 tools/testing/selftests/pidfd/pidfd_getfd_test.c              | 2 +-
 tools/testing/selftests/pidfd/pidfd_info_test.c               | 2 +-
 tools/testing/selftests/pidfd/pidfd_open_test.c               | 2 +-
 tools/testing/selftests/pidfd/pidfd_poll_test.c               | 2 +-
 tools/testing/selftests/pidfd/pidfd_setattr_test.c            | 2 +-
 tools/testing/selftests/pidfd/pidfd_setns_test.c              | 2 +-
 tools/testing/selftests/pidfd/pidfd_test.c                    | 2 +-
 tools/testing/selftests/pidfd/pidfd_wait.c                    | 2 +-
 tools/testing/selftests/pidfd/pidfd_xattr_test.c              | 2 +-
 tools/testing/selftests/prctl/set-anon-vma-name-test.c        | 2 +-
 tools/testing/selftests/prctl/set-process-name.c              | 2 +-
 tools/testing/selftests/proc/proc-maps-race.c                 | 2 +-
 tools/testing/selftests/proc/proc-pid-vm.c                    | 2 +-
 tools/testing/selftests/ptrace/get_set_sud.c                  | 2 +-
 tools/testing/selftests/ptrace/get_syscall_info.c             | 2 +-
 tools/testing/selftests/ptrace/set_syscall_info.c             | 2 +-
 tools/testing/selftests/ptrace/vmaccess.c                     | 2 +-
 tools/testing/selftests/resctrl/resctrl.h                     | 2 +-
 tools/testing/selftests/ring-buffer/map_test.c                | 2 +-
 tools/testing/selftests/riscv/abi/pointer_masking.c           | 2 +-
 tools/testing/selftests/riscv/hwprobe/cbo.c                   | 2 +-
 tools/testing/selftests/riscv/hwprobe/hwprobe.c               | 2 +-
 tools/testing/selftests/riscv/hwprobe/which-cpus.c            | 2 +-
 tools/testing/selftests/riscv/mm/mmap_bottomup.c              | 2 +-
 tools/testing/selftests/riscv/mm/mmap_default.c               | 2 +-
 tools/testing/selftests/riscv/mm/mmap_test.h                  | 2 +-
 tools/testing/selftests/riscv/sigreturn/sigreturn.c           | 2 +-
 tools/testing/selftests/riscv/vector/v_initval.c              | 2 +-
 tools/testing/selftests/riscv/vector/vstate_prctl.c           | 2 +-
 tools/testing/selftests/rseq/basic_percpu_ops_test.c          | 2 +-
 tools/testing/selftests/rseq/rseq.c                           | 2 +-
 tools/testing/selftests/rtc/rtctest.c                         | 2 +-
 tools/testing/selftests/seccomp/seccomp_benchmark.c           | 2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c                 | 2 +-
 tools/testing/selftests/sgx/main.c                            | 2 +-
 tools/testing/selftests/signal/mangle_uc_sigmask.c            | 2 +-
 tools/testing/selftests/signal/sas.c                          | 2 +-
 tools/testing/selftests/sparc64/drivers/adi-test.c            | 2 +-
 tools/testing/selftests/sync/Makefile                         | 2 +-
 tools/testing/selftests/sync/sync_test.c                      | 2 +-
 tools/testing/selftests/sync/synctest.h                       | 2 +-
 tools/testing/selftests/syscall_user_dispatch/sud_test.c      | 2 +-
 tools/testing/selftests/tdx/tdx_guest_test.c                  | 2 +-
 tools/testing/selftests/timens/timens.h                       | 2 +-
 tools/testing/selftests/timers/adjtick.c                      | 2 +-
 tools/testing/selftests/timers/alarmtimer-suspend.c           | 2 +-
 tools/testing/selftests/timers/change_skew.c                  | 2 +-
 tools/testing/selftests/timers/clocksource-switch.c           | 2 +-
 tools/testing/selftests/timers/freq-step.c                    | 2 +-
 tools/testing/selftests/timers/inconsistency-check.c          | 2 +-
 tools/testing/selftests/timers/leap-a-day.c                   | 2 +-
 tools/testing/selftests/timers/leapcrash.c                    | 2 +-
 tools/testing/selftests/timers/mqueue-lat.c                   | 2 +-
 tools/testing/selftests/timers/nanosleep.c                    | 2 +-
 tools/testing/selftests/timers/nsleep-lat.c                   | 2 +-
 tools/testing/selftests/timers/posix_timers.c                 | 2 +-
 tools/testing/selftests/timers/raw_skew.c                     | 2 +-
 tools/testing/selftests/timers/rtcpie.c                       | 2 +-
 tools/testing/selftests/timers/set-2038.c                     | 2 +-
 tools/testing/selftests/timers/set-tai.c                      | 2 +-
 tools/testing/selftests/timers/set-timer-lat.c                | 2 +-
 tools/testing/selftests/timers/set-tz.c                       | 2 +-
 tools/testing/selftests/timers/skew_consistency.c             | 2 +-
 tools/testing/selftests/timers/threadtest.c                   | 2 +-
 tools/testing/selftests/timers/valid-adjtimex.c               | 2 +-
 tools/testing/selftests/tmpfs/bug-link-o-tmpfile.c            | 2 +-
 tools/testing/selftests/tty/tty_tstamp_update.c               | 2 +-
 tools/testing/selftests/uevent/uevent_filtering.c             | 2 +-
 tools/testing/selftests/user_events/abi_test.c                | 2 +-
 tools/testing/selftests/user_events/dyn_test.c                | 2 +-
 tools/testing/selftests/user_events/ftrace_test.c             | 2 +-
 tools/testing/selftests/user_events/perf_test.c               | 2 +-
 tools/testing/selftests/user_events/user_events_selftests.h   | 2 +-
 tools/testing/selftests/vDSO/vdso_test_abi.c                  | 2 +-
 tools/testing/selftests/vDSO/vdso_test_chacha.c               | 2 +-
 tools/testing/selftests/vDSO/vdso_test_clock_getres.c         | 2 +-
 tools/testing/selftests/vDSO/vdso_test_correctness.c          | 2 +-
 tools/testing/selftests/vDSO/vdso_test_getcpu.c               | 2 +-
 tools/testing/selftests/vDSO/vdso_test_getrandom.c            | 2 +-
 tools/testing/selftests/vDSO/vdso_test_gettimeofday.c         | 2 +-
 tools/testing/selftests/x86/corrupt_xstate_header.c           | 2 +-
 tools/testing/selftests/x86/helpers.h                         | 2 +-
 tools/testing/selftests/x86/lam.c                             | 2 +-
 tools/testing/selftests/x86/syscall_numbering.c               | 2 +-
 tools/testing/selftests/x86/test_mremap_vdso.c                | 2 +-
 tools/testing/selftests/x86/test_vsyscall.c                   | 2 +-
 tools/testing/selftests/x86/xstate.h                          | 2 +-
 279 files changed, 282 insertions(+), 280 deletions(-)

-- 
2.43.0


