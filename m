Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18AA4606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G1gzl2eT
Received: by kanga.kvack.org (Postfix)
	id 0193E6B05B0; Thu,  5 Nov 2026 14:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE39A6B05B1; Thu,  5 Nov 2026 14:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE906B05B2; Thu,  5 Nov 2026 14:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD2956B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:12:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F0221A0AC9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:12:25 +0000 (UTC)
X-FDA: 85402011450.13.3191729
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 622EA1A0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:12:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G1gzl2eT;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793905943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QH8EWm3WpJvKmm+3SH11RyockHxBeCCGhqou8vP+rPk=;
	b=DF1Drpq7FeQsD+O9k9OFpVnVqidL6c2n9gxALcoWOp8ErfVY4l8Tlgw/wpiVDSkmpeqK9H
	GMkF2uXqRNfO+sqgP/B6vyenShU2IqhDPURuSoFKtsDdYmjODCc+eXJNLcXZRLLA8zH9+I
	32D9QfiV+ERxrKm3CmE4JTrxzw7lYHc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793905943;
	b=FKOx6bmcEe+HTfUJzi1dShywce/D7kBPtKpgJiQxLsDUNBLWbI6oqcFgc5nYkNl1qC8Z2S
	6hnkHFkAOd7h2wBR5nkU1TF9kaUccUop3LERsVqmIeFUlwVDbUoyisKGwMw5aNgXCuTz1n
	MhOEZwiJSsPCh/pI3kawQqT8cybezPQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=G1gzl2eT;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso1565340a91.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 11:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793905942; x=1794510742; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QH8EWm3WpJvKmm+3SH11RyockHxBeCCGhqou8vP+rPk=;
        b=G1gzl2eTmS9CL9b3cVZ2BeuQOKXu227sT7xgUSe6UswdbxLxnAWHN//BKfi3JYsvHl
         1tcoz8NRHnM295lTnmqs2V/cdTLmh/ugc+M9vFSZrU8RAl7DPqGnVVcCxZPzY2Ee7KOQ
         O58MIAH9az08I+up2MX89ZFv0nlCVyZ+oIMIPbkK6OGzlHstNJjA9l94gMQvrOLDFm5q
         22gpG8B/RpVxsu3BS3DHxLu8JqhNGaH33mmqbQE2ronoAqAEvBKjZkqAaRRreP0H5ffa
         Zg4yh7CIjruHA8n9CgI6Cf+OlGcJY3hpT2Ge8wCCNB7RsgX8Z4Uaql/iz1OM2JrZnNhI
         VNAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793905942; x=1794510742;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QH8EWm3WpJvKmm+3SH11RyockHxBeCCGhqou8vP+rPk=;
        b=1cP0W3T1pNdpigAiEgJymL43rxdOaCH/ktwr/aZUPY6dnw1cip+Gj+aW4NQsjEV8Vp
         6e/DuNQq9WkA2tk5ImpeuaZDOQfGJUlktbZTxCN2VhCX16kV3QMHGpSgjrY1LT32XsS1
         8w0YThKxRxNbNPLjZNSNVtO7PM6PoS4hX25vMF45Jewjr5MMNMPsX01pnZPnN+6TzAOf
         0sL8s9CkltXRhYByf3/AjwbjMsEtGoTPLWxSh8p4p3ZhW9OgP+/4iMPPI1Q8Uey0u5xP
         Hy08hxMmIirxBtW1Hb5PRZ+Qv0C1ZYX6apoJsQ8UcXNtWsh9AEMlHYNLsOjply7+DD1D
         +ciQ==
X-Forwarded-Encrypted: i=1; AKwUvBzWmT17sylKxiJ/XwqUix8PQ3qHp+5uFdHLnJ2XyzcVOc9uCwxlSVHnBmCoSQewEfERWCHP2jtaoQ==@kvack.org
X-Gm-Message-State: APuU4Z+2jNxBw0Vdu0oeFVDKgFeK+IN+vkfXeARfJh/hea59tcPg6VHr
	hQo63md2QU9qqva4aJykDp9fQXl5NQG22P6qf0sNelePnch6mJhgw4svcOiR5IVNTDEhgV4uioS
	8QIRCRmNp
X-Gm-Gg: AYBFou0Y9Hp3089ojYPY3YYgJqVJeZlpkrjyecnfNsRtwsYzzG9DxIw116Nk8zEwaGr
	auUJESVnQuJBOBZzakxsfjo1jj0SzQezIPgG0GyqiizJdlSRw47+BVO8PNaEYlJ80/8iZqIixx6
	NKOqjHCl8vMqfqjuM+Xju0XEjwhAoWhWEhduRDekb5g5fxlg4PJPI9sHZuxoYLEWn/bMUd5YlpQ
	h3Sk24mAyOfh6wUPJE7N0Y21yf3eH00lB4GGmlf6CTz8/uYLnEycqqZhWnUBDQtWl8Vl+V+JVtH
	B/JhNjCXFiZgMqm5VBdeTtc2d1M8AsVXLa2tcY7J/Rg95aXX/XFP0qbr0kXVzAL0FQ1+O+QiBxM
	agFes10ByjY1IKXBN/WqrFnCnA+9/Fv9Eoe/by6p92RrnUMqKIvZSPhaelvcyxy2jQQvqBPMHS1
	EOfN6frS69DBPCq0gZf/xKUXAx7NxWLoMHLaWm5EWekLvtrzPKldbsZnR72EWQzYAWDbSl2sRe4
	wxx7jG4zn9Q1gF6hadqo7HSUglnrfQfd5gNFa8V1heHFJHkpw0QN5QaT/2hUOKTSl2aNHfS4hEt
	bldXKXKjtAl9XvwYtFfAkXg8r8jrPG1XVbEsa1D7zAvUEE+BMMqYp3wcG3agOcmf
X-Received: by 2002:a17:90b:268a:b0:3ac:7c52:faeb with SMTP id 98e67ed59e1d1-3ae89769d66mr17879218a91.41.1793905941532;
        Thu, 05 Nov 2026 11:12:21 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944eb1d1sm5401592a91.0.2026.11.05.11.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:12:20 -0800 (PST)
Date: Thu, 5 Nov 2026 19:12:17 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org,
	ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com,
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com,
	chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net,
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com,
	jgg@ziepe.ca, jrhilke@google.com, julianr@linux.ibm.com,
	kees@kernel.org, kevin.tian@intel.com, leon@kernel.org,
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com,
	michal.winiarski@intel.com, parav@nvidia.com,
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org,
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com,
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com,
	schnelle@linux.ibm.com, skhan@linuxfoundation.org,
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com,
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 07/27] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <auzVEUpFEoWltpVg@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-8-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102153656.1431701-8-vipinsh@google.com>
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: skruoj8rrdpacayggu4jjpx4yixb7cbb
X-Rspamd-Queue-Id: 622EA1A0002
X-Rspam-User: 
X-HE-Tag: 1793905943-248111
X-HE-Meta: U2FsdGVkX18lEpY202tQvnob5AnbNtoFOcCu7CzetdiheQdOXlvUfP5VTJJ/vQgZIO4I7laC6NQPgESh2cVkMt26r9sOq8b85oV4x1JdUOeEZ/x1Q+HeLp5k80QNycMAN6ikYYDX8FKECInccoRtRboKZegPxuTS/2Eo14sE76LzC2HRIEW60HrH9clzC70mZq6WSp8iMWe68oRRUQu4g3iuWeRNygFO4MukyfD8W/0nNbI6vupYk2dciPCDYxLHgHpWwkCh7kPgAZgfIMQQaUeboGMoqyajOxnoemLWEtBY8kBTAQeYodna3VzI3x7pBkexYc8V651WBPTYqmtUHzEGxuMB5/yJApQYWbBco74vt0aDWuhp1Jn1XjCJKzpc3gDdvTz2Auie9iEoXUmNHRYItnU1E+awewtqbMsYccBcp1dXnRRQXq90Ob00lIWJ+0eElUPPhZIutqXTtftNzMD5uUiYXYBlxNmryzABkUUHJbqxqseikDOMKRQ3v1Wb4vsN74iDVFgy2m4MxPWvmKj/ZfnhLeDxlcATvsfcjHakiKZBRUjw9eNhJVyl1PcES8Mjd9td5JS1YXszo+AtH8cPExWIl1uV3YDLgNk+WdtIPpWipWEuyEnf2wxNVNWu23cobS8YOmXTSqljQsnPBU5l+D3T6O5sDnHgBtzjdxZ8LcPfh/EVz46uWSU8P746NoTBpwhGCXPpwyWMP5KwxkfE7ZVt1ODd2STcbPPhUBMz9+Kos7f6b+hNVerJL5dvtJ5U6nJOSCEFNCkx6s8VqZkL5dbAUACg/A0YdXna7WH+Et1DwBLqEG6JztP2N45QzsXnirc9JdNZGSwCHllrad1/WETZ4zm0bCRIvX6Ros0vhvg42QXrnWv7E5Y7H6JpGTaQjABbLa15iCNFK5t4ujAGJ4AobpYCRzY6rwGjI4jNTwgPsiQrBNhxQw2o4LVLCL49THOQv3sKBnJ1i3q
 1HMaVMni
 LK7P3+Q/iwNS6KNuMqHk5G9cQ0EeuCqD/7kTruHP5wMFvO0hvlv/3YjG/Tafm8bqdEM5PgBnK4MB/ycMJpfzq+Fgb1Q1iYryAYoNphbvI9uAIgfieEq3H02VGg89ffViwamC74KzI3LHhnsb17oSQHnRy6kB9cYdr8zfCL3Dyz9ITnzc0gFk5rQ4m/3/D7JBM7elu3PxYgS+qyu/hajicvEtBhSFATXcC1zA+mK5hXjxw11efgOjbhnPQm70btfhmgPZ+053hj1odSHq+paaZ1CEC9pL8VwqP/4RBj+ra+scF3hCCoUONeJTOtqeueUf1AtpkTWGW/3EDlL2dbqACSQdArrsckMNPppBbDd4MbE0GHDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-02 07:36 AM, Vipin Sharma wrote:
>  * TOCTOU synchronization: vfio_pci_dev_is_frozen() is checked locklessly
>    on entry to the ioctl, read/write and mmap paths, and re-checked under
>    a lock that freeze() holds before any operation that could change the
>    device or vconfig: under vdev->igate in vfio_pci_ioctl_set_irqs() and
>    around every config-space write in vfio_pci_config_rw_single(), under
>    vdev->memory_lock in vfio_pci_runtime_pm_entry(),
>    vfio_pci_ioctl_reset() and the SR-IOV enable path of
>    vfio_pci_core_sriov_configure(), and under dev_set->lock in
>    vfio_pci_dev_set_hot_reset(). A racing operation thus either completes
>    before freeze() takes its snapshot or fails, while existing BAR mmaps,
>    ioeventfds and dma-bufs keep working. Serializing config writes on
>    igate covers the PCI_COMMAND, INTx disable emulation, power state and
>    FLR paths at one point (the INTx disable emulation now uses the
>    igate-held __vfio_pci_intx_mask() and __vfio_pci_intx_unmask()
>    helpers), and also serializes the irq_type and virq_disabled accesses
>    of config writes with VFIO_DEVICE_SET_IRQS.

I think there's a simpler way to do this. Checking the frozen flag
locklessly and then re-checking it under whichever lock covers each
path spreads the synchronization across igate, memory_lock and
dev_set->lock. That makes it hard to convince yourself every path that
can change the device is covered. It also makes every config space
write take igate, for all vfio-pci users, even when
CONFIG_VFIO_PCI_LIVEUPDATE=n.

Instead, I suggest adding a per-device rw_semaphore to struct
vfio_device in the VFIO core, e.g. liveupdate_rwsem, that protects a
liveupdate_frozen flag:

 - vfio_device_fops_unl_ioctl(), vfio_device_fops_read() and
   vfio_device_fops_write() take liveupdate_rwsem for read and fail
   with -EIO if the device is frozen. That covers every device ioctl in
   one place, including the ones handled by the VFIO core
   (VFIO_DEVICE_FEATURE, VFIO_DEVICE_GET_REGION_INFO and
   VFIO_DEVICE_{ATTACH,DETACH}_IOMMUFD_PT). This patch doesn't block
   the last two at all today.

 - freeze() and unfreeze() take liveupdate_rwsem for write, before any
   other lock, and flip the flag. preserve() doesn't need it since it
   only serializes state that doesn't change after the device is
   opened.

Putting this in the VFIO core also means other VFIO drivers can reuse
it if they add Live Update support in the future.

The lock order then becomes:

  liveupdate_rwsem -> dev_set->lock -> igate -> memory_lock

freeze() can still take igate and memory_lock to check irq_type,
pm_runtime_engaged and sriov_active. But the ioctl, read and write
paths no longer need to re-check anything under those locks. So you
can drop the igate change in vfio_pci_config_rw_single(), the
open-coded vfio_pci_zap_and_down_write_memory_lock() in
vfio_pci_runtime_pm_entry() and vfio_pci_ioctl_reset(), and the
smp_load_acquire()/smp_store_release() pair.

Two paths still need their own handling because they don't go through
the device's file:

 - vfio_pci_core_sriov_configure() is reached through sysfs. Take
   liveupdate_rwsem for read around the frozen check and the
   sriov_active update.

 - VFIO_DEVICE_PCI_HOT_RESET issued on one device also resets the other
   devices in its dev_set. Keep the check in
   vfio_pci_dev_set_hot_reset() under dev_set->lock. freeze() sets the
   flag while holding both liveupdate_rwsem and dev_set->lock, so
   holding either one is enough to read it. Please don't take the other
   devices' liveupdate_rwsem there, since that would invert the lock
   order relative to freeze().

I don't think mmap needs to be blocked at all. Creating a new mapping
doesn't change the device or any of the state that gets preserved, and
existing mappings already keep working while the device is frozen.
Leaving mmap alone also avoids taking liveupdate_rwsem under mmap_lock,
which could deadlock: the ioctl, read and write paths can fault on user
memory (taking mmap_lock) while holding liveupdate_rwsem for read, and
freeze() may be waiting for the write lock. Please update the comment
in freeze() and the DOC section to match.

> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 9914f3ac69ae..1f1ac7a798aa 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -644,10 +644,10 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
>  
>  		if (virt_intx_disable && !vdev->virq_disabled) {
>  			vdev->virq_disabled = true;
> -			vfio_pci_intx_mask(vdev);
> +			__vfio_pci_intx_mask(vdev);
>  		} else if (!virt_intx_disable && vdev->virq_disabled) {
>  			vdev->virq_disabled = false;
> -			vfio_pci_intx_unmask(vdev);
> +			__vfio_pci_intx_unmask(vdev);
>  		}
>  	}

With the rwsem, config writes no longer need igate, so this change
isn't needed. If config writes and VFIO_DEVICE_SET_IRQS really do race
on irq_type and virq_disabled today, that's unrelated to Live Update.
Please send it as a separate fix.

Lastly, please add the freeze infrastructure and the checks in their
own commit ahead of this one, e.g. "vfio: Add infrastructure to freeze
devices for Live Update". Then this patch only has to implement
freeze() and unfreeze() on top of it, which will make both easier to
review.

