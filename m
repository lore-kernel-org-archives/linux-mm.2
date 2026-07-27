Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37652C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 00:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558676B008A; Sun, 26 Jul 2026 20:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508C66B008C; Sun, 26 Jul 2026 20:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7AB6B0093; Sun, 26 Jul 2026 20:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F405B6B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:41:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6538E160582
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 00:41:23 +0000 (UTC)
X-FDA: 85032702846.21.C68DEC1
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BFA510000C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 00:41:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KRlyVlYp;
	spf=pass (imf05.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785112881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rj5ZR/j8gEE2Zz++PWd2qbirX2cZs2l8PGm6xJNCOE4=;
	b=RGl8dnMy0JtgzDXgM/DrNlS3vQzBlaL7JFNJ57KseNBgw9lMQLQkXb0kwImaTxBVHQz/r8
	rtWq+pN226dJuSP2rgbLuJG6U2lslyyeFAXJsEnquMpbXIeqUnzcz0/KnoVxWqT1TygKOl
	SJ2BYqBqfC997GVwm41ubCTxOHbrVHo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KRlyVlYp;
	spf=pass (imf05.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785112881;
	b=23YTxA9zbNbprNdnAeyzBrnOii3H5chIWlsrjM1bitcgcWVNDI8QT69Mgj8VwzZJF7dV+R
	qjDC/lqizseJKQOKTW9G7kxbEpZrQSH784HmRzuWu6XCPoZ6JNvmLmm2zEN10AM8ZSkUy5
	mtqslRpwXOGGzk9svquVeLVe8nx+CI8=
Message-ID: <c3440ed3-0fc2-44e5-a05a-922344eb34d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785112875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rj5ZR/j8gEE2Zz++PWd2qbirX2cZs2l8PGm6xJNCOE4=;
	b=KRlyVlYp6pYFsYFATRhclKvDqnjexSHonIihZ6tDf/jclGw9yBI7LDiDqDB6H9CGK5Dm3B
	seaLfFNRROnf0/I7jkQTkIWOdIsxfFIvg7/CzmzUPkMbpHzCb4UseN4LJcTYAwNLf97N3c
	K2CXArCY6yj1KdwVOp0kqWDJzF83tw0=
Date: Sun, 26 Jul 2026 17:40:54 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v5 17/20] vfio: selftests: Add
 vfio_pci_liveupdate_kexec_test
To: Vipin Sharma <vipinsh@google.com>, kexec@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
 ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
 chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
 dmatlack@google.com, graf@amazon.com, jacob.pan@linux.microsoft.com,
 jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
 kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com,
 lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com,
 parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com,
 pratyush@kernel.org, rananta@google.com, rientjes@google.com,
 rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
 schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com,
 vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-18-vipinsh@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260714151505.3466855-18-vipinsh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BFA510000C
X-Stat-Signature: ipbc9ehnqb19ioo555gcdc9gh5j9crec
X-HE-Tag: 1785112878-292923
X-HE-Meta: U2FsdGVkX18xGtg5Yf5WGzNj/14jCUkYhGIEzWLpTNEJ2aQxuXeO4ujUT+liPoUxxtfJWc+NxKju2dVRuVCwZJi6sjHK1me9Y1eX7xgKaksFtR2FFiRgp0fosDQPngaTikPkisCf0FrdStstJjDQAX5k+M4WDNjwsaodiohmbUQkC0/fvb8xAlMCm4OO+y6KpcjJ6M/ZMwF/RrssaDgj5ZZl0Mxqxddc9yNytr6z3ZlNHpKakDntu/Qzkx/ajFT31cDpyvMBmWZXcaBuJOG/JlVsRjqG8shvtyGMMlR6hGJiag1dQzxERl8gnSXdqjYdH3G0KZSW27awo27TPnwj5RG2sidkUb432h7t0kTrL0sdIff5DZm+/hblzfwax+7kT8l4zS8zJVu+N3emxoOaRZ1ObD1etcV44Duy/fCjglR1uVGT2MCiw0f9V4XY0T+uWzPnpo09Dl0jDISEIqrJ9YFxH8cOiJjhdKprK0HdI9zlpRxs5nG/unyUOilpgbDwG0UQ7TEoQSDHNt+kcaxOBNsQwteEpQwxblBfMZWktKktEvV7d8U6eXqbUVuZrUqtc81mI+b+elsPs9HYTof3Q2Mszou4z7Zr4I3J2SFE3YgS6N43PgqMLr4GvC7LdKecn7Ir04b14ZQL7MBF3EUB84/sdXkbsX6jZzT8DIO/UxnzIE86DOJXNua70s09fKH6SLMGpIHbygiY47+nxN5Jbgza9/ZrAUqJ4Br/bJjOLe3zKrNHlqfBnPhrLC/TdvSbzNbyyRo9ZH1cosWqinFw3AuKcPHzAjrb1BP2L4UDAQ3Cl4KaX1/6UNBP/Kc0BUaWvL20XcUJilIN9+COQOtyJwY0sSsiI1OqfaDEUwaGbZRa3d1yV33kIz82AwmrFUaHhJOulyYK/TSnDIRNyiUCUEiJbGlvX++FYVjmyNKGDEWYG+oQMXD7lc+ERVQc30ERT7JCE9E9PWW4GPMqIjN
 8aJTmVZ6
 sPODQEW7aeZ0XexAOkLlLgYeZOv/gJn9mh1zUWKk5J+uMvDErorXniPUl66cpNNMsZ/X9g7Yo9Mhex2LQO0rdyQG9xGb0JglVs4rjt6Mc7j9uvpGSnoo21UWOcZVFDM9fuPym8od8reBU7otT4IEs1p4zc2AW7VhBzJfHMgod7MT3Tvsf9d5YdG1Q1nCGSf3YunYDR7eiJKMkmsDG6HTPEuBbzP3d0aBboQVLS3tLqi98YwGzY1UsxaATC1qyBKkDg9891cPSOWKaSjPSs42Oi69YdOQeL12hLu+DFrghQtmXtE/2v95hNDcnC0sbQduV25KMbJZ6t3XOrts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/14 8:15, Vipin Sharma 写道:
> Add a selftest to exercise preserving a vfio-pci device across a Live
> Update. For now the test is extremely simple and just verifies that the
> device file can be preserved and retrieved. In the future this test will
> be extended to verify more parts about device preservation as they are
> implemented.
>
> This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
> manually along with a kexec.
>
> To run this test manually:
>
>   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
>   $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
# ls /dev
autofs           disk       iommu         mem     rtc0      tty10 tty21  
tty32  tty43  tty54  tty8    ttyS18  ttyS29   uinput  vcs6   vcsu4      
   virtio-ports
block            dma_heap   kmsg          mqueue  sg0       tty11 tty22  
tty33  tty44  tty55  tty9    ttyS19  ttyS3    urandom vcsa   vcsu5      
   vport2p1
bsg              dri        kvm           net     shm       tty12 tty23  
tty34  tty45  tty56  ttyS0   ttyS2   ttyS30   usbmon0 vcsa1  vcsu6      
   vsock
btrfs-control    fd         liveupdate    null    snapshot  tty13 tty24  
tty35  tty46  tty57  ttyS1   ttyS20  ttyS31   usbmon1 vcsa2  vda        
   watchdog
bus              full       log           nvram   snd       tty14 tty25  
tty36  tty47  tty58  ttyS10  ttyS21  ttyS4    usbmon2 vcsa3  vda1        
  watchdog0
cdrom            fuse       loop-control  port    sr0       tty15 tty26  
tty37  tty48  tty59  ttyS11  ttyS22  ttyS5    userfaultfd vcsa4  vda2    
      zero
char             hidraw0    lp0           ppp     stderr    tty16 tty27  
tty38  tty49  tty6   ttyS12  ttyS23  ttyS6    vcs vcsa5  vda3         zram0
console          hpet       lp1           ptmx    stdin     tty17 tty28  
tty39  tty5   tty60  ttyS13  ttyS24  ttyS7    vcs1  vcsa6  vfio
core             hugepages  lp2           pts     stdout    tty18 tty29  
tty4   tty50  tty61  ttyS14  ttyS25  ttyS8    vcs2  vcsu   vga_arbiter
cpu              hwrng      lp3           random  tty       tty19 tty3  
  tty40  tty51  tty62  ttyS15  ttyS26  ttyS9    vcs3  vcsu1  vhci
cpu_dma_latency  i2c-0      mapper        rfkill  tty0      tty2  tty30  
tty41  tty52  tty63  ttyS16  ttyS27  udmabuf  vcs4  vcsu2  vhost-net
cuse             input      mcelog        rtc     tty1      tty20 tty31  
tty42  tty53  tty7   ttyS17  ttyS28  uhid     vcs5  vcsu3  vhost-vsock


# tools/testing/selftests/vfio/scripts/setup.sh 0000:00:08.0

+ echo "vfio-pci" > /sys/bus/pci/devices/0000:00:08.0/driver_override
+ echo "0000:00:08.0" > /sys/bus/pci/drivers/vfio-pci/bind
tools/testing/selftests/vfio/scripts/lib.sh: line 9: echo: write error: 
Invalid argument    <--- the error is here.


# lspci -vvv -s 0000:00:08.0

00:08.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
         Subsystem: Red Hat, Inc. QEMU Virtual Machine
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Region 0: Memory at fea1f000 (32-bit, non-prefetchable) [size=4K]
         Region 1: I/O ports at c000 [size=256]

Hi, Vipin

I worked with QEMU PCI Test Device. But the following error occur.

"tools/testing/selftests/vfio/scripts/lib.sh: line 9: echo: write error: 
Invalid argument"

Is this a known problem?

Thanks

Yanjun.Zhu

>
>   $ kexec ...   # NOTE: Exact method will be distro-dependent
>
>   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
>   $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0
>
> The second call to setup.sh is necessary because preserved devices are
> not bound to a driver after Live Update. Such devices must be manually
> bound by userspace after Live Update via driver_override.
>
> This test is considered passing if all commands exit with 0.
>
> Co-developed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>   tools/testing/selftests/vfio/Makefile         |  4 +
>   .../vfio/vfio_pci_liveupdate_kexec_test.c     | 89 +++++++++++++++++++
>   2 files changed, 93 insertions(+)
>   create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
>
> diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
> index 591f1a52c310..a2f0a459e1f4 100644
> --- a/tools/testing/selftests/vfio/Makefile
> +++ b/tools/testing/selftests/vfio/Makefile
> @@ -15,6 +15,10 @@ TEST_GEN_PROGS += vfio_pci_driver_test
>   TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
>   TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
>   
> +# This test must be run manually since it requires the user/automation to
> +# perform a kexec during the test.
> +TEST_GEN_PROGS_EXTENDED += vfio_pci_liveupdate_kexec_test
> +
>   TEST_FILES += scripts/cleanup.sh
>   TEST_FILES += scripts/lib.sh
>   TEST_FILES += scripts/run.sh
> diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
> new file mode 100644
> index 000000000000..15b3e3af91d1
> --- /dev/null
> +++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
> @@ -0,0 +1,89 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <libliveupdate.h>
> +#include <libvfio.h>
> +
> +static const char *device_bdf;
> +
> +static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
> +static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
> +
> +enum {
> +	STATE_TOKEN,
> +	DEVICE_TOKEN,
> +};
> +
> +static void before_kexec(int luo_fd)
> +{
> +	struct vfio_pci_device *device;
> +	struct iommu *iommu;
> +	int session_fd;
> +	int ret;
> +
> +	iommu = iommu_init("iommufd");
> +	device = vfio_pci_device_init(device_bdf, iommu);
> +
> +	create_state_file(luo_fd, state_session, STATE_TOKEN, /*next_stage=*/2);
> +
> +	session_fd = luo_create_session(luo_fd, device_session);
> +	VFIO_ASSERT_GE(session_fd, 0);
> +
> +	printf("Preserving device in session\n");
> +	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
> +	VFIO_ASSERT_EQ(ret, 0);
> +
> +	close(luo_fd);
> +	daemonize_and_wait();
> +}
> +
> +static void after_kexec(int luo_fd, int state_session_fd)
> +{
> +	struct vfio_pci_device *device;
> +	struct iommu *iommu;
> +	int session_fd;
> +	int device_fd;
> +	int stage;
> +
> +	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
> +	VFIO_ASSERT_EQ(stage, 2);
> +
> +	session_fd = luo_retrieve_session(luo_fd, device_session);
> +	VFIO_ASSERT_GE(session_fd, 0);
> +
> +	printf("Finishing the session before retrieving the device (should fail)\n");
> +	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
> +
> +	printf("Retrieving the device FD from LUO\n");
> +	device_fd = luo_session_retrieve_fd(session_fd, DEVICE_TOKEN);
> +	VFIO_ASSERT_GE(device_fd, 0);
> +
> +	printf("Finishing the session before binding to iommufd (should fail)\n");
> +	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
> +
> +	printf("Binding the device to an iommufd and setting it up\n");
> +	iommu = iommu_init("iommufd");
> +
> +	/*
> +	 * This will invoke various ioctls on device_fd such as
> +	 * VFIO_DEVICE_GET_INFO. So this is a decent sanity test
> +	 * that LUO actually handed us back a valid VFIO device
> +	 * file and not something else.
> +	 */
> +	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
> +
> +	printf("Finishing the session\n");
> +	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
> +
> +	vfio_pci_device_cleanup(device);
> +	iommu_cleanup(iommu);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	device_bdf = vfio_selftests_get_bdf(&argc, argv);
> +
> +	sprintf(device_session, "device-%s", device_bdf);
> +	sprintf(state_session, "state-%s", device_bdf);
> +
> +	return luo_test(argc, argv, state_session, before_kexec, after_kexec);
> +}

-- 
Best Regards,
Yanjun.Zhu


