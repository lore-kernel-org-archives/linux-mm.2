Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E37606A335
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 00:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F8dY3e+n
Received: by kanga.kvack.org (Postfix)
	id AA4EC6B05D6; Sat,  7 Nov 2026 19:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57DB6B05D7; Sat,  7 Nov 2026 19:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943B16B05D8; Sat,  7 Nov 2026 19:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C3D36B05D6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 19:44:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF44B8014E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:37 +0000 (UTC)
X-FDA: 85410106194.30.250F405
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5519B80003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 00:44:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F8dY3e+n;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794098676;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0rhvPH19u7tz1SnZv54KCQaJt1s6QEE0Sc/KUgXCZM=;
	b=fkcDnYdpDF2SceuCZVsrw5SvicdYHIXMT3S648Zr11ttcdZq+2kHktMrdyLzYFBA8ivkcc
	PZTBkx/OBMxBacbU7rKxpmIoeu5bo9rmN8rkhUk02g9FlnlkoUw4iwv9GKBwXqTADYZ+uG
	nWQunWXXTyszUKRTshCFTgByl4W1bD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794098676;
	b=DduWNCXwpzvVqwm0tSkKB0Cvofrg6EDfisYg+7Ylj3M/mK6PV1mUUlWQjxjZMyk14Qj+QH
	G4jyPF2ZitOUL+n7kEFkmNz0auocPmzUABH2Yz6pmFye2xemol3TX4mQ8b1O+4a/S3PEtu
	GJO8mTCJTLMrEf2VS7D+Eb1PRiZjoCM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F8dY3e+n;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E06DB612AE;
	Sun,  8 Nov 2026 00:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4101F008A3;
	Sun,  8 Nov 2026 00:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794098675;
	bh=w0rhvPH19u7tz1SnZv54KCQaJt1s6QEE0Sc/KUgXCZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F8dY3e+nVEQMeRaRSX+egwqFmjzHP+yfZe7X6T4CcyUPU+sxOVE9xC3+2ossojcxa
	 BKxqC6XLqS9L+nIRtq+h9RGwBMPXXZiKOcsbq9+ycC2vCV6eyQ2BgOSdygi4HxsORL
	 OYDQMtCMa+U2YE5pKPpE5YzdU0G+xObb0ebgT+CeSy8t2PJ0Udo0xg90ZuYMc9BEtO
	 bl8m5tHjXunSSqkzPbWu3hY/J2NA0sT0tbGSTyY49atDC9gDF+YjTltpHt4f0LiFgX
	 Q7ogNMCaYYxMOO3V0xNeAhspD6LcDReqO/aIJYWfiw6hUobeDiVogocx46nFq/IoQu
	 Sg2gYoI3RDLWQ==
Message-ID: <sashiko-outbox-203482@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 71/88] vfio/pci: Implement read and write
 provider ops for guest_memfd
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>, "Alexey Kardashevskiy" <aik@amd.com>, "Aneesh
 Kumar K.V" <aneesh.kumar@kernel.org>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "David Woodhouse" <dwmw2@infradead.org>, "Fred
 Griffoul" <fgriffo@amazon.co.uk>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jianxiong
 Gao" <jxgao@google.com>, "John Starks" <John.Starks@microsoft.com>, "Michael
 Roth" <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Sean Christopherson" <seanjc@google.com>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Tarun Sahu" <tarunsahu@google.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "Xu Yilun" <yilun.xu@linux.intel.com>, "Fuad
 Tabba" <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261106-gmem-alternative-providers-v3-71-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
 <20261106-gmem-alternative-providers-v3-71-8484dde66a7e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 00:44:34 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5519B80003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: z4ze61n4sk3ngjjof5wm9164cz1ukm85
X-Rspam-User: 
X-HE-Tag: 1794098676-813034
X-HE-Meta: U2FsdGVkX1927lSwi0HQEMl69z/0h2eGiIV+YOOp51+3PPRNau2uQVuPnwImzzUqMlBtpyZCrQJYk7vWCawkRtr2LomwOVp7Ik067IubJdz3nQ5nvaW9PRSunKZmjCWqGE5fPUegJbXF8SAAEbzzmcIewwNlFz6Ig4dwI9HLiGT+FpsOld5W8hp/SeCAEeCeZqz2jZADBvhDaUpH1dEmt+5kGTbeTcJFVLv9s44gkvfU/9aMMzIn9XXj5zuxFzvic/eb+eBi/NF7wFSQ4s/NICxTMsHfa27s7OyQ6tWWkt7gukLauAGnV7tpB7lrEKLmRZ2psY9Z4dIqcG+jC5SkycMYVFTcbXHaNQ/GOJtGOctnRu269s1C7a6p+o/K3tGIXPl/IYHDV5CS6vuVe6PAzvHmzetMUxOrx+a5AbR9V9ToRFC1wgHZnookdUNVjP+9forr701PuFoLNLQQqH4zEkwxYjj3udR80xFBtJVbsMHjf4Qb8WLR53c+T4vN7nfwOtwRwc1v7qDUR5yix7Cm8PtgmP6W+Mejy3aj1PLFuH/COee9noAamwVeJlHGm7yWDiEsVsV4iRNWZ0JN0U/fo8VIGcDqkv9LaIfE2KlV6dX6Dzdy4qOnI/DYjsrIAc45zJRVxR0TkdfUYiZgOPPRKHr2ghC7yLDloik/Ot1QssHfmNApMK4yD9ktoEFsapeqGMBUHmmhWPFWVTRrWRNqOtY2KP5sbSMBGCpfXQP5HZE2kPfB40lkRfIcd2Dzb1pyvq6tRg/Hm3pNbP+ZzptBIbw+UlFK8RsH3447q8uAxjL7zFUShlZj8Q6QS/aSr0xTM2e7mSwGE3U3VhZYnoarhdjIB/tRMDWRbmC4e8bqOox72ngiKblmNe8GobqFlhIBr2MCLqNF72URXEd00iGuiRJ75kUF3iGijJJ/9+oquOv0LwK5eBFW9COuMLb83fenn0j7EbGfTyL03gpQ6r6
 yC+ITnHn
 mninsbMF9kegjg7UilXXbR9RQgpn1uVg1S91IRkVDjgkwmEO/PtTZvZON2OVd+7v/XNLm/xlVYyWqBnQ4zXo+0ZwQWRwbojnhfW0QUm2+adSc+pMfUQ9SmVgT392syG0hKHIruuHQS13pGzO8ownYoi6QgLApm7YodPsdMxz2ULxoPSNzrnRAnk9gkoG4zD7vyD5xqX2NpKn7x2nFv4gewfHaJLC/57O1NccGOi6VDAJl5FV1wxYxX7LrW2m/KGHXeKJiKTeVAC/U5EZ+APVjUHgAR7gfnShEV91e6jcvQ462BkNAlqH8U3piVz1FD52gD0iEcSJX9QN/Kr1IGR69rVER/QoQ1PDhhxDbWxrvjFWszV/H+zUCQnI4HhaJ1coCxw/2cOIHPkfSlvC6IO/Epvr+IeXRlV3KFSG+OV3CErfWygOTFlGKoqPgQZomallM3Y/02Jg+dHsN3VOWJiTeSTQjo31faZgd3tdViPspE/WJMxZU9pesvqnt7Vncs5N6cCvawzf9IdnAbAGLn8qQaj3Mgy4GMd0BQsxDk7M1+IEQzETv2RhOy97SX+QiZPu2ZZvz2ufnZKCEYihzNXYhqAQLs8KdeiZT+pslfYeKghaulGO11EseuypHT6htSswPT1aDjONYIhYjhPz5xL73ZbBLdz4Rs4s8q6yf1WHTsVdI4vgNFrcqEM+mCnWJpYJPQmkc9/SECUISmbSYzdoNjH0wnjSjlE5FZ6zWBt+ktnA+09o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] vfio/pci: unserialized sub-page BAR access in
  vfio_pci_core_gmem_rw()
- [High] vfio/pci: D3 MMIO access in vfio_pci_core_gmem_rw() when
  runtime PM engaged
--

commit a60cfc9fb84848a43b5d6f8b77f7f250457c4495
Author: Ackerley Tng <ackerleytng@google.com>

vfio/pci: Implement read and write provider ops for guest_memfd

This commit implements the .gmem_read and .gmem_write provider operations
in vfio-pci to service guest_memfd read and write accesses to mappable
MMIO BARs.

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index a9274d95e9066..c976574782663 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2871,6 +2871,42 @@ int vfio_pci_core_gmem_lookup_pfn_range(struct vfi=
o_device *core_vdev,
>  	return -ENOENT;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_lookup_pfn_range);
> +
> +static ssize_t vfio_pci_core_gmem_rw(struct vfio_device *core_vdev,
> +				     void *kbuf, size_t count,
> +				     loff_t *ppos, bool iswrite)
> +{
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index >=3D PCI_STD_NUM_BARS || !vdev->bar_mmap_supported[index])
> +		return -EINVAL;

[Severity: High]
Can a sub-page BAR access here race with a reset or power transition?

In vfio_pci_probe_mmaps(), a page-aligned BAR smaller than PAGE_SIZE has
 its remainder reserved via dummy_res and vdev->bar_mmap_supported[bar] set
to true.  Unlike vfio_pci_core_gmem_get_pfn() and
vfio_pci_core_gmem_lookup_pfn_range(), which reject BARs where
pci_resource_len(pdev, bar) >> PAGE_SHIFT is 0, vfio_pci_core_gmem_rw()
allows them and calls vfio_pci_bar_rw_kbuf() with test_mem =3D false.

Skipping vdev->memory_lock relies on vfio_pci_zap_bars() revoking the BAR
range in guest_memfd so __kvm_gmem_revoke() takes
filemap_invalidate_lock() and drains in-flight kvm_gmem_rw() calls.  For a
sub-page BAR, however, vfio_pci_zap_bars() passes nr_pages =3D 0:

drivers/vfio/pci/vfio_pci_core.c:vfio_pci_zap_bars() {
	...
			gmem_start =3D VFIO_PCI_INDEX_TO_OFFSET(i) >> PAGE_SHIFT;
			nr_pages =3D pci_resource_len(vdev->pdev, i) >> PAGE_SHIFT;
			pfn =3D pci_resource_start(vdev->pdev, i) >> PAGE_SHIFT;

			vfio_device_gmem_revoke(&vdev->vdev, gmem_start,
						nr_pages, &pfn);
	...
}

When nr_pages is 0, __kvm_gmem_revoke() returns early before acquiring
filemap_invalidate_lock(inode->i_mapping):

CPU0                                  CPU1
kvm_gmem_rw()
  filemap_invalidate_lock_shared()
  vfio_pci_core_gmem_rw()
    vfio_pci_get_bars_available()
                                      vfio_pci_ioctl_reset()
                                        down_write(&vdev->memory_lock)
                                        vfio_pci_zap_bars()
                                          vfio_pci_set_bars_available(false)
                                          __kvm_gmem_revoke(..., nr_pages=
=3D0)
                                            return 0;
                                        pci_try_reset_function()
    vfio_pci_bar_rw_kbuf(..., false)
      vfio_pci_core_iowrite()  <-- MMIO during reset

This allows MMIO reads and writes to run concurrently with a PCI reset, a
transition to PCI_D3hot, or clearing PCI_COMMAND_MEMORY, which can cause
Completer Abort / Unsupported Request errors or synchronous external
aborts.

> +
> +	/* Lockless check on availability of BARs. */
> +	if (!vfio_pci_get_bars_available(vdev))
> +		return -EIO;
> +
> +	return vfio_pci_bar_rw_kbuf(vdev, kbuf, count, ppos, iswrite, false);

[Severity: High]
Can vfio_pci_core_gmem_rw() issue MMIO accesses while the device is
runtime-suspended in D3?

Unlike vfio_pci_rw(), vfio_pci_core_gmem_rw() does not call
pm_runtime_resume_and_get() and passes test_mem =3D false to
vfio_pci_bar_rw_kbuf(), relying on vdev->bars_available to be false while
runtime PM low-power mode is engaged (vdev->pm_runtime_engaged).

When userspace enters low-power mode via
VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY, vfio_pci_runtime_pm_entry() zaps BARs
(setting bars_available =3D false), sets vdev->pm_runtime_engaged =3D true,
and drops the runtime PM reference.  If userspace then performs a config
write (or a reset ioctl), vfio_pci_rw() temporarily resumes the device to
D0 for the duration of the call.  Because vdev->pm_wake_eventfd_ctx is
NULL, vfio_pci_core_runtime_resume() leaves vdev->pm_runtime_engaged set
to true, but the config write or reset path re-enables bars_available
without checking !vdev->pm_runtime_engaged:

drivers/vfio/pci/vfio_pci_config.c:vfio_basic_config_write() {
	...
		if (__vfio_pci_memory_enabled(vdev)) {
			vfio_pci_dma_buf_move(vdev, false);
			vfio_pci_set_bars_available(vdev, true);
		}
	...
}

When the config write finishes and calls pm_runtime_put(),
vfio_pci_core_runtime_suspend() suspends the device back to D3 without
clearing bars_available.  Subsequent guest_memfd reads and writes see
vfio_pci_get_bars_available(vdev) =3D=3D true and perform MMIO against the
device while it is in D3.

Conversely, when waking from VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEU=
P,
vfio_pci_core_runtime_resume() calls __vfio_pci_runtime_pm_exit() without
restoring bars_available =3D true, leaving guest_memfd BAR accesses failing
with -EIO after wakeup.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-gmem-alter=
native-providers-v3-0-8484dde66a7e@google.com?part=3D71

