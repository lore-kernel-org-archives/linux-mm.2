Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A555EE9D812
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 16:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85DA6B0088; Sun,  5 Apr 2026 12:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5E5B6B0089; Sun,  5 Apr 2026 12:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73DD6B008A; Sun,  5 Apr 2026 12:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9682A6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2928213B474
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 16:56:50 +0000 (UTC)
X-FDA: 84625106580.17.3CC0A84
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id 232A31C0003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 16:56:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M7zv8SV4;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775408208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFvtQF/EQRNqZnPTUPg67LAGyHPrcqrBHQ7jLg4MTF8=;
	b=fxx4GUSp2BpwLc37BQPRYogobrh8f2prtEedODlq8LxZ+WwiYKXmTro5hSFPWTHSnrYLNc
	uu5GJhUhCPgBhK2pfSV+ZYcO8lyEqak0JanME9h74MREZ2XDq0J0xyulmgePXpi2a+NeHb
	dFslJkl5qSa2u4O269+HIxJUCAJzFjo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M7zv8SV4;
	spf=pass (imf21.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775408208; a=rsa-sha256;
	cv=none;
	b=qY2uuEoshk2rNQ+hbQes+G0OlYZNbtmf7K2+4YbyNRNCckvdj6CSC1g7Q8ZZcPupZfA1IL
	5FgqMFwQj7aDFvfpYjGsfJW5yFRwESD8sgcx/6qJNEpIZqiA2yRkQ0qGyfmPWvmG6rsKwl
	cOMvSv/p0TNY76fG2VRY3skW2df/V0I=
Message-ID: <c4138f66-edf2-4689-b5fe-16dc4839e9c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775408205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IFvtQF/EQRNqZnPTUPg67LAGyHPrcqrBHQ7jLg4MTF8=;
	b=M7zv8SV4cjrjb+YyPeE71EssW0qE0pL4fOJ+Nfy2dOQw7qKT75gTxWwXd3t7VJ7pQv+MzR
	doi0hOcDMnXCCO/t3Cbdhxa59++qaLFBiSpFWSPaIh/M5gWLB9BHkiJSGHEqWF/2+6Ab90
	Am2CiF8y5Sv3KMSrbLHOexlLh/l+4JY=
Date: Sun, 5 Apr 2026 09:56:37 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 02/24] PCI: Add API to track PCI devices preserved
 across Live Update
To: David Matlack <dmatlack@google.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
 Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal
 <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
 Askar Safin <safinaskar@gmail.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>,
 David Rientjes <rientjes@google.com>, Feng Tang
 <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
 Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
 Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>,
 =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>,
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 Pranjal Shrivastava <praan@google.com>, Pratyush Yadav
 <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>,
 Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>,
 Yi Liu <yi.l.liu@intel.com>
References: <20260323235817.1960573-1-dmatlack@google.com>
 <20260323235817.1960573-3-dmatlack@google.com>
 <e3fe7085-1297-47b8-bb17-a48196e8f37f@linux.dev>
 <CALzav=eyf4XRTi8MfE_GBNSm+tjmfX7=d0M8Aj5Hh0vJn7huew@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CALzav=eyf4XRTi8MfE_GBNSm+tjmfX7=d0M8Aj5Hh0vJn7huew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 232A31C0003
X-Stat-Signature: ihim9zorr8yoaob5a1noqwb1ix7tjb1p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775408207-848408
X-HE-Meta: U2FsdGVkX18m8oTZpHIp+i27Adw45mOs9xMfXPmY30FAKpoe81nh8ERntlqcq9ApdYNEZiBk3hiI65HlFzrgsgNtejISafq89RuOegiiqxcdYGSyW916AoGKzE+J4xOkFUkKYh8OZ4B+Zk+MA4Jy5nrvNbIRmXOWGFxL2LwVJDr1ksvqMGdtEvctIP4Qt0xbq+ry94x6pvFTVnYGWPkW5rOxcdvkm4EJ5IfMCHt5d6xy6Mx78Vd6xkU0Q3FZOsPMs3aZGF7y/IOqqNMIWeJACOBkzv/CtfnoqxyzjcrewAKVj37TYkkliczdqodYd94zQU0UBxgILcTBKCu3mnfu53o+LmmdI7oy47ARrEvxU/W1Cye4gro1cskTt4jU+b1j5NpmAWhmF0ky5aszZwKYqvTpOom1wRf5HDBtpsBFbGYCy+EKHzq0HBNhuabjNIMoQtiPadjZQub/BU8ugCznLxFpKPlpl97lpqmTqBevadlbwCN5yUwliKPVObzwsjgYSlvkYcIc250P7STH++v5R7JKkHyYhpcu1MBTCqu+CqZJK0AvwIn88d8B4rcwP/Luwk1ny6KxTMEaVO6TTbe26mhunfIRqGPY0FIEv5MII57PuFElZ5CwUgyTDNGybpMLPiT1DAgvD8QC9Rs3Cj5x4sYorrx1ZWmOXwlwtgivFKXxnbNlCerqwm91MQ2tD2lFUhTgHWcJDdSPeFNVXiccaYonofkx2eUtOxmqFiNlBCRfINWZrhnq0qz6EnnshjQS/pbXeEtWFSMgBjKRYe0cgdNpk2yq6J6lxph0YgH/8sxloLxsYCRA4eHd3+1Wbk7OAkwSx/32TDjAvtHfbgIPytc1XlxvrGvWLU6gKshrdb5U0hdaNdB1k+Mbd8mOPBUQLI4XGetREWDDI/I3yno7gBEbTH5rcw9GSYBzhrnhHjnQAr0ZA51yPDd0z/naevpQxHY7SEJgIrs4ESGiaIf
 wgToLXXd
 j4XcV+SCPH8oIQSUFmDORK3ccY1boTrv4nebMG/lrSpe3s80wr5srNq9yKeXymovwDY68/IYwdAybfSdA2BNmLGBeDo2DxtF3eI5otES8q/VMzvfHPGIKlBF6UPdFG1kf02KJUrC11lQF4uqRpzkDohDy7jRr7tvH8gpKrLWY5kbuzzEN1C63NDZwKojuDNgNvjfeFK8UYVAiy5GA9Xqb5AqprItLtz97adhvqbwZsP0QvhFLvrVXqvJOdwNZyRpQ3erRQbz+LPweb9jw77wB2Xym1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/4/3 14:58, David Matlack 写道:
> On Thu, Apr 2, 2026 at 2:29 PM Yanjun.Zhu <yanjun.zhu@linux.dev> wrote:
>> On 3/23/26 4:57 PM, David Matlack wrote:
>>> +config PCI_LIVEUPDATE
>>> +     bool "PCI Live Update Support (EXPERIMENTAL)"
>>> +     depends on PCI && LIVEUPDATE
>>> +     help
>>> +       Support for preserving PCI devices across a Live Update. This option
>>> +       should only be enabled by developers working on implementing this
>>> +       support. Once enough support as landed in the kernel, this option
>>> +       will no longer be marked EXPERIMENTAL.
>>> +
>>> +       If unsure, say N.
>> Currently, it only supports 'n' or 'y'. Is it possible to add 'm'
>> (modular support)?
>>
>> This would allow the feature to be built as a kernel module. For
>> development
>>
>> purposes, modularization means we only need to recompile a single module
>>
>> for testing, rather than rebuilding the entire kernel. Compiling a
>> module should
>>
>> be significantly faster than a full kernel build.
> I don't think it is possible for CONFIG_PCI_LIVEUPDATE to support 'm'.
> pci_setup_device() (which is under CONFIG_PCI) needs to call
> pci_liveupdate_setup_device(), and CONFIG_PCI cannot be built as a
> module. This call is necessary so the PCI core knows whether a device
> being enumerated was preserved across a previous Live Update.

After the following changes, the liveupdate.ko can be generated 
successfully.

"

# ls drivers/pci/liveupdate.ko
drivers/pci/liveupdate.ko
"


diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig

index 05307d89c3f4..e172c31b33fa 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -335,7 +335,7 @@ config VGA_ARB_MAX_GPUS
           multiple GPUS.  The overhead for each GPU is very small.

  config PCI_LIVEUPDATE
-       bool "PCI Live Update Support (EXPERIMENTAL)"
+       tristate "PCI Live Update Support (EXPERIMENTAL)"
         depends on PCI && LIVEUPDATE
         help
           Support for preserving PCI devices across a Live Update. This 
option
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index c1251f4f8438..71bab8ecba85 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -413,3 +413,26 @@ void pci_liveupdate_unregister_flb(struct 
liveupdate_file_handler *fh)
         liveupdate_unregister_flb(fh, &pci_liveupdate_flb);
  }
  EXPORT_SYMBOL_GPL(pci_liveupdate_unregister_flb);
+
+extern void (*pci_liveupdate_setup_device_hook)(struct pci_dev *dev);
+extern u32 (*pci_liveupdate_incoming_nr_devices_hook)(void);
+static int __init liveupdate_module_init(void)
+{
+       pci_liveupdate_setup_device_hook = pci_liveupdate_setup_device;
+       pci_liveupdate_incoming_nr_devices_hook = 
pci_liveupdate_incoming_nr_devices;
+       pr_info("loaded\n");
+       return 0;
+}
+
+static void __exit liveupdate_module_exit(void)
+{
+       pci_liveupdate_setup_device_hook = NULL;
+       pci_liveupdate_incoming_nr_devices_hook = NULL;
+       pr_info("unloaded\n");
+}
+
+module_init(liveupdate_module_init);
+module_exit(liveupdate_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PCI Live Update Support");
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 979cb9921340..93f76500cb0d 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1434,18 +1434,12 @@ static inline int pci_msix_write_tph_tag(struct 
pci_dev *pdev, unsigned int inde
         (PCI_CONF1_ADDRESS(bus, dev, func, reg) | \
          PCI_CONF1_EXT_REG(reg))

-#ifdef CONFIG_PCI_LIVEUPDATE
+#if IS_ENABLED(CONFIG_PCI_LIVEUPDATE)
  void pci_liveupdate_setup_device(struct pci_dev *dev);
-u32 pci_liveupdate_incoming_nr_devices(void);
  #else
  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
  {
  }
-
-static inline u32 pci_liveupdate_incoming_nr_devices(void)
-{
-       return 0;
-}
  #endif

  #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 165056d71e66..4880302bca43 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1369,6 +1369,9 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 
*sec, u8 *sub)
         return true;
  }

+u32 (*pci_liveupdate_incoming_nr_devices_hook)(void) = NULL;
+EXPORT_SYMBOL_GPL(pci_liveupdate_incoming_nr_devices_hook);
+
  static bool pci_assign_all_busses(void)
  {
         if (!pcibios_assign_all_busses())
@@ -1389,7 +1392,7 @@ static bool pci_assign_all_busses(void)
          * numbers during the initial cold boot, and then that topology 
would
          * then remain fixed across any subsequent Live Updates.
          */
-       if (pci_liveupdate_incoming_nr_devices()) {
+       if (pci_liveupdate_incoming_nr_devices_hook && 
pci_liveupdate_incoming_nr_devices_hook()) {
                 pr_info_once("Ignoring pci=assign-busses and inheriting 
bus numbers during Live Update\n");
                 return false;
         }
@@ -2030,6 +2033,9 @@ static const char *pci_type_str(struct pci_dev *dev)
         }
  }

+void (*pci_liveupdate_setup_device_hook)(struct pci_dev *dev) = NULL;
+EXPORT_SYMBOL_GPL(pci_liveupdate_setup_device_hook);
+
  /**
   * pci_setup_device - Fill in class and map information of a device
   * @dev: the device structure to fill
@@ -2091,7 +2097,8 @@ int pci_setup_device(struct pci_dev *dev)
         if (pci_early_dump)
                 early_dump_pci_device(dev);

-       pci_liveupdate_setup_device(dev);
+       if (pci_liveupdate_setup_device_hook)
+               pci_liveupdate_setup_device_hook(dev);

         /* Need to have dev->class ready */
         dev->cfg_size = pci_cfg_space_size(dev);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 27ee9846a2fd..aaab6adb487e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -592,7 +592,7 @@ struct pci_dev {
         u8              tph_mode;       /* TPH mode */
         u8              tph_req_type;   /* TPH requester type */
  #endif
-#ifdef CONFIG_PCI_LIVEUPDATE
+#if IS_ENABLED(CONFIG_PCI_LIVEUPDATE)
         unsigned int    liveupdate_incoming:1;  /* Preserved by 
previous kernel */
         unsigned int    liveupdate_outgoing:1;  /* Preserved for next 
kernel */
  #endif
@@ -2876,7 +2876,7 @@ void pci_uevent_ers(struct pci_dev *pdev, enum  
pci_ers_result err_type);
         WARN_ONCE(condition, "%s %s: " fmt, \
                   dev_driver_string(&(pdev)->dev), pci_name(pdev), ##arg)

-#ifdef CONFIG_PCI_LIVEUPDATE
+#if IS_ENABLED(CONFIG_PCI_LIVEUPDATE)
  int pci_liveupdate_preserve(struct pci_dev *dev);
  void pci_liveupdate_unpreserve(struct pci_dev *dev);
  int pci_liveupdate_retrieve(struct pci_dev *dev);
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 874830f8e44d..33fbdc6c417c 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -461,7 +461,7 @@ int liveupdate_register_flb(struct 
liveupdate_file_handler *fh,

         return 0;
  }
-
+EXPORT_SYMBOL_GPL(liveupdate_register_flb);
  /**
   * liveupdate_unregister_flb - Remove an FLB dependency from a file 
handler.
   * @fh:   The file handler that is currently depending on the FLB.
@@ -487,7 +487,7 @@ void liveupdate_unregister_flb(struct 
liveupdate_file_handler *fh,

         luo_flb_unregister_one(fh, flb);
  }
-
+EXPORT_SYMBOL_GPL(liveupdate_unregister_flb);
  /**
   * liveupdate_flb_get_incoming - Retrieve the incoming FLB object.
   * @flb:  The FLB definition.
@@ -525,7 +525,7 @@ int liveupdate_flb_get_incoming(struct 
liveupdate_flb *flb, void **objp)

         return 0;
  }
-
+EXPORT_SYMBOL_GPL(liveupdate_flb_get_incoming);
  /**
   * liveupdate_flb_get_outgoing - Retrieve the outgoing FLB object.
   * @flb:  The FLB definition.
@@ -552,6 +552,7 @@ int liveupdate_flb_get_outgoing(struct 
liveupdate_flb *flb, void **objp)

         return 0;
  }
+EXPORT_SYMBOL_GPL(liveupdate_flb_get_outgoing);

  int __init luo_flb_setup_outgoing(void *fdt_out)
  {

-- 
Best Regards,
Yanjun.Zhu


