Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9D8608B7D0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KTz46fZW
Received: by kanga.kvack.org (Postfix)
	id 83D7D6B065B; Mon,  2 Nov 2026 10:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE316B065C; Mon,  2 Nov 2026 10:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7256B065D; Mon,  2 Nov 2026 10:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAA76B065B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD931160185
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:29 +0000 (UTC)
X-FDA: 85390583418.27.58F3463
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 042021C000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KTz46fZW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Nq7oagcKCJMI5C5AF43BB381.zB985AHK-997Ixz7.BE3@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Nq7oagcKCJMI5C5AF43BB381.zB985AHK-997Ixz7.BE3@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DylHlhnLbbJiaHnChZ4MNuIpkseXw4m+y/UR6vnlJ4E=;
	b=kn4VY6LdD24IbqIHohbrcZ5vxVKrfBjsQU9AI06I6souziUR4GW1bZmvg5V6mGYTkPa3Ay
	aA6D9v+upHZr696r4kqgiKrQvMkEngxk8YMFvvVh24tGdddErxZj3JvQXzQSeV2oHUmFwI
	cpKltvXjarO3iuA72v79JOEUE7xbjKo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KTz46fZW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Nq7oagcKCJMI5C5AF43BB381.zB985AHK-997Ixz7.BE3@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3Nq7oagcKCJMI5C5AF43BB381.zB985AHK-997Ixz7.BE3@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633848;
	b=U0/DuBdrtLF7rz2Z4dA8OTFytqaSv4StzqtI2N/GBXIMTrNNoD1bHI/nmRQCdvwwppfYGI
	Xw0o/+RbhWYUnFJRAqg9OIvIG/evae7+WN3YdyNn5OC2VvmPxIpBq9OFVDQfQBOEGNY97R
	yc9v1A+uRlxSa2gi2lv/mWIoBoAE6to=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e93e2f72bfso53695485ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633847; x=1794238647; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DylHlhnLbbJiaHnChZ4MNuIpkseXw4m+y/UR6vnlJ4E=;
        b=KTz46fZWnLwh6fvnzFelY7vmEFgsoeFiALVQgkL1Ox/6KnwB532XETWc8wbvw/q/7F
         ihxPYwEymBOs73sVSw60BlG5UeTUHfXCSjGagoGiZJpyYk41SU2faIBGoNfzAGsJxW5x
         HvrfIzw1M+QIqQBbtz5pSI3yfK13NCBLF2YoKIrjiwPW7BOuMt/X5fI2l0Cp6t4LjWZ+
         lsLwsflWWjz0PzQeuicPQkjANe0tom+1Bqsk6mwD2qvNSlwMPuEuNbwxKmqFU+bwpv78
         6DVYCZ6UP1UbS+S/Zwr7SjZ8j1iTGmlX1UhSgBOpl8yzg8tLvPiUdcUkXOh5oNBUzfNf
         rU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633847; x=1794238647;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DylHlhnLbbJiaHnChZ4MNuIpkseXw4m+y/UR6vnlJ4E=;
        b=Ub1slZHO974+xBRS6x2hvVKKxW7GMN6Pqno08ZMTw75UnHhCksw5mBvn4atKf0nEZ7
         7sdb+/yqa4MfM4C/vF7ET0kjmVdBsDekXj712yQvVsm+Vyi8aAancx+/tv+UyKr15Fgj
         b/XYIt3LESjUOsd+NWzXZnsMIDmIoHCozIa8EujJtYh0aA6CrsANLrBLoCKf3xUzkTVN
         YPMrEPdS8KpYVqERbUi1BzIKQy/L44NXKJi7Pit0pNaY/mWTzCIgrvUo8JCrIxVwNbvy
         t8OHKrKaU+nSueCVyCuzojhBnQsCWT+3tx0W/MvWgfOqPRxFqrDaY8Jfj/AqHzOe27kn
         jpZA==
X-Forwarded-Encrypted: i=1; AKwUvBx3qDfnBNaVoizjzoEYd6t3lqA2yisVL/YcemeNHOKNCMRMUNQH12+FTv3RjJlGYlUfRDdlw5y8mA==@kvack.org
X-Gm-Message-State: APuU4Z/A6Xp86T7Ba8Q8f6D1HBzRQHdB4C8ZElUpxKb9uMNOjqHjKPzg
	9LIGSEULhLb1kjpAAe/GvWXeq1iUm8IYkgB8mt/P3az4+Fat6hyS9Bc2+YoVkLe1+S5ueXrOHrD
	dnLhq1JMbsg==
X-Received: from pjsa21.prod.google.com ([2002:a17:90a:be15:b0:3a8:cbf9:5e52])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b02:b0:3ac:929d:ba5c
 with SMTP id 98e67ed59e1d1-3ae89847b50mr8027654a91.45.1793633846630; Mon, 02
 Nov 2026 07:37:26 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:54 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-26-vipinsh@google.com>
Subject: [PATCH v6 25/27] vfio: selftests: Add vfio_pci_liveupdate_kexec_test
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 042021C000D
X-Stat-Signature: scdeizg76azxz1tccacgwj6zeieijed7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633847-998214
X-HE-Meta: U2FsdGVkX1/J8QRLr5byGrefExBHQyNRwh3WfptmupALF1YszQxOAT6pXzz3LADwhVSSfETUCMF+8yeNdE3lmQ5Xig3LDJFmb6+9g2BoC6AKDP3XLDTfEuz61w3Bn0BGW8+0t8T1wMA22QULya5ch6eIQoPI5l4PAXmKQorjv6UhYBwUYBy6kFF3MWo+w86Zoe2srd41nYWTy0y4HUO1MWkPxueo+SXCCnWX4ndeJGZrZIoWMFiPmTwxn1JgpWwvyaXF7woZy7QO932JzW7bYIiiV+ENL7N1TzmFd5JC7IJYglRjoo7u1gWhZ0vOl2n9G204meb++4rvuPCVyfL3hluUcL3av2WdcBWlIRg1X0Ynx4NypzVtSjkeFAs4QMZN7zYMTVrcA2fRxNjHhkIHrg/4o7nDGLJ/ytZvOxBi2PKCp45tnjkqV5gE7UEzy0j/APjuPZTXXbYaLcMv8purpUNhXVZCYOCWM2Fm/kxadHaDCZ799PLL3X8g53JX/IKfWNp23lLcH3VA6DdcqNTuXEnC19yucoQAOXt1iWMjMtaDnMg4AdGiJU6h3nJFeKA2RbNl/TphWFF45u0VGO9hpAGGzucxMs+XPVlaxlkU3bJDvg6nqN1do5DI6ZxiD77XflmyprpHF8Lt7aMmFpyGbqg9oS8GpTQ9HmLih3pn1OXgZJHxGG46CNuvFqwVEpfR0ezdIi8YJSV00lrG00a1OX16wR8lIq+VbRtcDu7eBJcuLKFVbAdhoIMAXeEjsooydheI/j6BWkwX2S7643oq8NzEUCYHg2TfKSk2GBCu8rWRnVPhnlmF30FWBRhpVZtYT8Ku1urgs9F/xYByo4kk4dxxMd/H4nvGPltfzPqaXnyKb2y93LAXnkHG5fG0YfkiCcJbj0o2rktSwx+znOscyLunnkgpC1XCY6eHOVH3vvgNlSgZRrYFbQxY2DCMTtOmWkbF+N1kqNxdWkv7ntb
 DFWuDc0O
 e89Wt1HNApljaZ8dJS0v2zkvwb0Bw1QnZdSiJYNKFG3Oo3Mrm8SCz+LJDPGKT3DBUkNnS/OHxGCYDl8s8yiRwNBKTbytgD+NjWSQg2ZCeG9BeX3/o0fteE43GZDT57Cm1NuW4q/mMzJ68Wd8zZD/MBslAYP2L+3Vyh1rK2e3PButh14TLm/oZdtYVuFAYpNp4+6YS6BXrK3PrSBE8kps3fqVNCGBHutVrlWLHdxKuhxDil0+1RSpQjw31E6g9fy6mTUYJasEwkFj6zAackT85eyY0TkhLgs+ROLrUXyN4r1U3GY5oEfp7+STnnMvl0uB+o08CDp+rAg73eqeHO2zNb1X4nmxoCZPSvLGqqsJwEsrdahpK97FL3ZLbxr5V+56ynBAeR9gCfoyq0EVTia5A+nI6/uBJvUEZ8CKZQb/Md3XCq75PEvCSx+GsqPFz+3BhZxwSp3pgJyWwdBUoOzU1+5BOAbBD4AbMJ5OfzALecc6+w1RdqUG5HvUQIy2bQz2JnDUb0mvXU17uArmA3ecWZFUZ1Dsm7t1h2iEs5RvxWC2ZQIbhi5mgqvZMI4j9Se0AdOWN9jPMm1AHMgxMqAN2vHZSD9S3JLfBpJhZgLV5j1obmz5e0oz4PbgtwHrFbPlVjiSiHyCcMMu8sCoVAvUGhajDG87trpDylMyV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a selftest to exercise preserving a vfio-pci device in noiommu mode
across a Live Update. For now the test is simple and verifies that the
device file can be preserved, retrieved, and bound to iommufd in the new
kernel. Subsequent commits extend this test to verify that the device
cannot be opened through VFIO during the Live Update and that DMA
continues across it.

This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
manually along with a kexec.

The kernel must be booted with vfio.enable_unsafe_noiommu_mode=1 and the
target device must be bound to vfio-pci in both kernels. In the new
kernel, the preserved device must be bound to vfio-pci without first
being bound to or unbound from any other driver. This can be done during
boot, e.g. with vfio-pci.ids=<vid>:<did> on the kernel command line, or
manually before running stage 2:

 $ echo vfio-pci > /sys/bus/pci/devices/0000:00:04.0/driver_override
 $ echo 0000:00:04.0 > /sys/bus/pci/drivers/vfio-pci/bind

To run this test manually:

 $ ./vfio_pci_liveupdate_kexec_test -s 1 0000:00:04.0

 $ kexec ...   # NOTE: Exact method will be distro-dependent

 $ ./vfio_pci_liveupdate_kexec_test -s 2 0000:00:04.0

Do not unbind the device from vfio-pci after kexec (e.g. by running
setup.sh on a device that is already bound to vfio-pci), as unbinding it
would reset it.

This test is considered passing if all commands exit with 0.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile         |   4 +
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 102 ++++++++++++++++++
 2 files changed, 106 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index ece2a3618f2b..7010a243a0b7 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -15,6 +15,10 @@ TEST_GEN_PROGS += vfio_pci_driver_test
 TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
 TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
+# This test must be run manually since it requires the user/automation to
+# perform a kexec during the test.
+TEST_GEN_PROGS_EXTENDED += vfio_pci_liveupdate_kexec_test
+
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
 TEST_FILES += scripts/run.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
new file mode 100644
index 000000000000..4919175c1173
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <fcntl.h>
+#include <libliveupdate.h>
+#include <libvfio.h>
+
+static const char *device_bdf;
+
+static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
+static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
+
+enum {
+	STATE_TOKEN,
+	DEVICE_TOKEN,
+};
+
+static void check_noiommu(const char *bdf)
+{
+	const char *cdev_path = __vfio_pci_get_cdev_path(bdf, true);
+	int fd;
+
+	if (!cdev_path)
+		ksft_exit_skip("Device %s is not bound to vfio-pci in noiommu mode\n",
+			       bdf);
+
+	fd = open(cdev_path, O_RDWR);
+	if (fd < 0)
+		ksft_exit_skip("open(%s) failed: %s\n", cdev_path,
+			       strerror(errno));
+
+	close(fd);
+	free((void *)cdev_path);
+}
+
+static void before_kexec(int luo_fd)
+{
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int session_fd;
+	int ret;
+
+	check_noiommu(device_bdf);
+
+	iommu = iommu_init(MODE_IOMMUFD_NOIOMMU);
+	device = vfio_pci_device_init(device_bdf, iommu);
+
+	create_state_file(luo_fd, state_session, STATE_TOKEN, /*next_stage=*/2);
+
+	session_fd = luo_create_session(luo_fd, device_session);
+	VFIO_ASSERT_GE(session_fd, 0);
+
+	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+static void after_kexec(int luo_fd, int state_session_fd)
+{
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int session_fd;
+	int device_fd;
+	int stage;
+
+	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
+	VFIO_ASSERT_EQ(stage, 2);
+
+	session_fd = luo_retrieve_session(luo_fd, device_session);
+	VFIO_ASSERT_GE(session_fd, 0);
+
+	device_fd = luo_session_retrieve_fd(session_fd, DEVICE_TOKEN);
+	VFIO_ASSERT_GE(device_fd, 0);
+
+	iommu = iommu_init(MODE_IOMMUFD_NOIOMMU);
+
+	/*
+	 * This will invoke various ioctls on device_fd such as
+	 * VFIO_DEVICE_GET_INFO. So this is a decent sanity test
+	 * that LUO actually handed us back a valid VFIO device
+	 * file and not something else.
+	 */
+	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
+
+	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
+
+	vfio_pci_device_cleanup(device);
+	iommu_cleanup(iommu);
+}
+
+int main(int argc, char *argv[])
+{
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	snprintf_assert(device_session, sizeof(device_session),
+			"vfio-lu-device-%s", device_bdf);
+	snprintf_assert(state_session, sizeof(state_session),
+			"vfio-lu-state-%s", device_bdf);
+
+	return luo_test(argc, argv, state_session, before_kexec, after_kexec);
+}
-- 
2.56.0.317.g454f8302e1-goog


