Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574F1606A6AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 23:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SJ5wPa5v
Received: by kanga.kvack.org (Postfix)
	id 77BE76B05B0; Fri, 20 Nov 2026 18:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CA06B05B2; Fri, 20 Nov 2026 18:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C096B05B3; Fri, 20 Nov 2026 18:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 392C96B05B0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:36:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BBBEEC025A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:36:07 +0000 (UTC)
X-FDA: 85457107974.04.4246A99
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id C42D7140005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:36:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SJ5wPa5v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795217765;
	b=0+iUmOEJl9lAxf5TqKwjtWlQD3rFiAByqnPxvqD+5EMZku0IthUUhsaD8ob0m8cdd4Viuy
	K41A4JfBru66Fb8uvriwgQsTaGU5F+NXBLnqVml2SWYjqknLu3wimi6M6z/uffVgSGe6Jp
	0YPJRtEaKKIsKtM9rWY8ESw1bp0m+fc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795217765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fq/GPepzkTLXxM8Wn2MMXhIXKeiLSAPdWNcRYRGgzY=;
	b=AMHs+nXdD+ojV/vrpWaCLs+dbKJQrIbDExJlZv4tVatQ6rGWIfINb6lr8IgCRcD4BKfsYD
	zRtTOtYvEhURSg3Qa38CUN4+9a/VbA5K1MzbAEL3mpBJEI9dHog7s1XLbQ27aStKZiY8wc
	rmSRPvam5bfP7x+SP8Xouv4+n9RLH98=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SJ5wPa5v;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2f0634667aaso967765ad.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795217764; x=1795822564; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=6fq/GPepzkTLXxM8Wn2MMXhIXKeiLSAPdWNcRYRGgzY=;
        b=SJ5wPa5vTrBbjnfIUge32Y57orOH9QfHPJSbSqjjxNgqFty2aXVp2mq47yRZ8v4v6T
         3PYomytVm/dHjG5CvpJHoUSK6THNDr+Cd3zzVKTgOQB+z2EMEWXgbd4NhU9eez1SyUY4
         oaGRvkG9g2riYeymbC3cUpMF7i7hhd5GkkzjJh1luBKW05IcAfoyf18kZnPJjjCqXaz+
         2q+9hAyd/O4vp6vVqH5EyrhwSpeqeOzqAT+GPNP2VmSSv068vODOATKRNnBrc05Za28Y
         eE6Jfw3Pr43lsjD7hoGRssOE5Kf5zK+qaFDTj1Lb4NRxTllAp4LR8ICeGTWIQP9CHpdq
         xPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795217764; x=1795822564;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6fq/GPepzkTLXxM8Wn2MMXhIXKeiLSAPdWNcRYRGgzY=;
        b=JVuvgxGmQV2b78qs9GvKXQUY0PxYS0fU5OjWl1n16ggRAn33RsT6LV3uPmiklmmnoU
         mJw2lpUxhRK49r7Qn3lur3hd+FOD0XBgqV/x5j3M7hSH89Vcugp7gEbxgEydQ22Xxdj/
         joYpHRm34DMb0RfVhvKqpJMYWfLDw+xrdthTNtShTeDNAgTe8S+zq95xSJk70veoH9jC
         A2Mh7x0LAiyPKLm+FcjrQ9g0IstvXM6XBvBGMy07bTkRxyPppeJO/f9dG0dZdEnCCJ/B
         69TUE1SkeiPeEbr1eEo+eHEERZsajdjzZXKlsgdX1IrBJJE1tLODunx1vCytn0KhpeUa
         6JUQ==
X-Forwarded-Encrypted: i=1; AL+hErFKxuwa7TMWNrO8joYCTUBHg5A/YSUfpaa0hzcKNDDhy1PEoaVoEd5CtbGfAJUidAPmKnKdIgFJig==@kvack.org
X-Gm-Message-State: APuU4Z8+71cbKCqESzDtnGrtHTXpO883c3JOr9iy+3fy7W8xMkwk7VxI
	LKPaxw+64KRp7AUQOvSVZdgMmmmIVDMNVlhWheSq0HsbFY/W/r4CokdkC5Icq7EbsQ==
X-Gm-Gg: AZFdTZeJV5cWhJfzEn3AMclBvkO3kfl7PvXJP4DZ2hl/gERXNzSK59iYJmHfU9oXDQN
	dyxBxu/bZsV2bC+PoZdDJ6yNJvX8GnX0gf6jqptjih8IWkzck2v0MRaEjAS5DrHS4Ybf0Q3d8rz
	h5EghxG+5CJgZoeotdWmJ6N1wdkqmX4HzkVygIxWkcZYlGFer58DIOjtfBtTQQBppfp/w4nQQYt
	rd4qpPeQxdQrcsdQemVMvT0iD3CKvy7JfMFsltoFFNGmitCHNOdu1B8Uqm+q/WCkZ2VkE9NcH8u
	Z2bNu3khPmxDiRV1s1BjvZVE5ekg+YqUN/tToWqnBVnkz8NyCMvtnWaq7ZRbhGE6yfozxZvNpsL
	n/c7XgFC/r9LbhgcfS4fv73l50gqcGCktHjBmPjbprEyK+mtdr9/PF5x8vbDeHIESN0A8Tu9ZUP
	o50dOQM7P1WvumiyBT22ecDEVuHjlbM4WAGKW1YUq9rXX9Onez1Si/ACmJVxwLUnDhp6ns4vWFD
	u9sH4/8QECEcsi3AzjZHa/IFz70Axq+tz0iuxQAZtfsrNDHOBVLYLtcJDO3fgV1d3B+tJQ67X71
	kD1gJTbrYU7s2w+d99+2jFfzBJwUpEHm7gqHMt7TkvEeKmMoLoedza0pF9U4OEJJ
X-Received: by 2002:a17:90b:3c11:b0:3a7:9ec3:ea0e with SMTP id 98e67ed59e1d1-3b41c908114mr2771810a91.22.1795217763469;
        Fri, 20 Nov 2026 15:36:03 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm5906545a91.0.2026.11.20.15.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 15:36:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Nov 2026 15:35:58 -0800
Message-Id: <DN0FL1752MH5.1FSZE620OJBM0@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "David Matlack" <dmatlack@google.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-pci@vger.kernel.org>
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Alexander Graf"
 <graf@amazon.com>, "Alex Williamson" <alex@shazbot.org>, "Alex Williamson"
 <alex.williamson@nvidia.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Chris
 Down" <chris@chrisdown.name>, "Chris Li" <chrisl@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Jacob Pan"
 <jacob.pan@linux.microsoft.com>, "Jason Gunthorpe" <jgg@nvidia.com>,
 "Jonathan Corbet" <corbet@lwn.net>, "Josh Hilke" <jrhilke@google.com>,
 "Leon Romanovsky" <leonro@nvidia.com>, "Lukas Wunner" <lukas@wunner.de>,
 "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava"
 <praan@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy Dunlap"
 <rdunlap@infradead.org>, "Saeed Mahameed" <saeedm@nvidia.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Vipin Sharma" <vipinsh@google.com>, "William Tu" <witu@nvidia.com>, "Yi
 Liu" <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live
 Update
X-Mailer: aerc 0.21.0
References: <20261118223704.3286085-1-dmatlack@google.com>
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Stat-Signature: ujh7m4yp9hu11cya3f3ssnh9k5rt7x1g
X-Rspamd-Queue-Id: C42D7140005
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795217765-829051
X-HE-Meta: U2FsdGVkX18+AoOmOy9zKHwPZuSwMZ+XAH9ekrv1+6GcFA9zJ2eIzLLURYAYbwGM4kV9cwyp1sgOgzqM73+Gz+55qtvK+EobLfFlU25EXFSTCgTaIwRysQicv9sHRKL2RMTp3L1AWO7yzT/hYHr0MHES0Fmsrsx2lSkgim5CATA7oJByY08iZtONTZQwYP0WrUiDBM56LApfMW2NYK/CVvOCssORmPAeJaukEa6+uRzNdFvp+do2dKWdNRpH4HA2YdoUSU6jNAy5a8ZvfNa8LyMCzHcnZyjlOXuiCXIkouPP2Z8OPKA7Z/f3wr+4OlUeR2P9jTujLqgHjMkuNj5MMKUGByG5jNCAatRW9DiAGdnUWc9GS4iUK39VHkuoLygES00mvgjziDz6j5D7liA44nymX4WMh/0UICsA4zNMHLUKCbqyVdgjn0p1Brt4SNDNMg34xsI0TEBTUMztysiVz/w+qkPzoMW/vTV2Dq368Y/1O4NN2CfAsUHp6QZU4/kBGJigITLCiNIeLGMRMVWnWH2dykVfoy4vpspWIebSPKdL7xN9HljympJ0R9WuhSCd0jyTJ+DSpkQ1x7V05PlUovwyffqwIYsBGSGR3vpOMPk0UlFYIbM8TQoFIZ1SAW/4sYg779bcGXshUXJhY0fwxLUz6g81KeRR8qxGOFQ3eHpVQsS9/uWRWDZ4l1BCpOn4jfn5VAgNaeYa6WwFWJU4doLRt3NBJpZoiiqDsGn7yX8jQFpkMjtWsi0G73gaEoKefOIlvuMJ5xDImhqkD5rIB+ry5Gy0BkyC9PjtStK5NZzFa4MDlftCbzEYfyG/RqGFJ5/Od3xvl68JqqWtu4sk0OPX/rH3N9K+0Qh0jMwaVDJyhsGaet7YFUKK4Xx3NyrQ7vvXm2tVuj+5si50P9al6e0fIRmM58wWG5Y7LS4iqL7XEtt+NOOkj17Wp1pWujdJtsAK6Rx6qX8KA8cqEFX
 JKgQWENl
 9Hp9pL6NgWvd8rIgedAyuA1kOf9L/waOgnVXxwy0JKrIqD/ZZExuB0HOUT6a8fYaznIPTuX+lm5666nNNGAwM8FJnGsDJMhL7yN3R0JvE9UMB12y1okbQh9gLmoaxZn838vrewZNjbrzFf2xw91FoClKlzXGWzETcdagl9PXpdJreeomiAO/8OBIgyt6EYjsZ0Tue9fuD78JPZYyNIxrFGi3UdUVLiakgpurdWYsz0h5dvWCJIdPuiQwQY4f4j/RfxLdlQYb/YCURpNpvqUWq4q/WL8NYrROvZcVn2uXSQujY8u77v/Lbxy5N9KUYxR0B9/HwPYH/QwM49tqmiYoIPHQ9k59WJPxVPS3TMRVGuyZ/1+kewtdubTnA10Pp/IV7h89/7PklilXYG4pSjMWaseNl4Y4YtNEcEhlJ3r55kWvxQcTCMhTRVZcKvSX/4HYrHpZSXM6ZGdlbhUirNHv6KoRDSQJsnX9zirWVt5LD+3i+IdFWHkiBsrGAZUEJtECVS66m6KEUsmcDlpBogg/R+1IimEH+4LhFrukjr98dyn0jzXpOFgxxbs5kztfmeDI62IIIQUUKX9S1zoNDJVZWGA2v/7NxUsUWOzi9u9nmSBCU044OXZVAsuhn1sLVR6U3fG4ggMqHVSu2phpfFErKSfHLjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 18, 2026 at 2:36 PM PST, David Matlack wrote:
> Merge Plan
> ----------
>
> This series is intended to go through liveupdate.git, the tree listed in
> the new PCI LIVE UPDATE MAINTAINERS entry.
>
> v10 and a follow-up patch were applied to the lu-pci-preservation branch
> of liveupdate.git. This version is meant to replace them, and applies on
> v7.4-rc1, the base of that branch.

Patches 08 and 09 have Reviewed-by tags from Alex now. I have a v12
prepped with some small fixes from Sashiko and a comment cleanup from
Pranjal.

Mike do you want me to send a v12 with these changes or send separate
fixes for you to apply on top?

Here is the diff from v11 to v12:

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 493576119a76..76e939ea52eb 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -127,7 +127,7 @@
  *    Control Services (ACS).
  *
  * In addition, a device cannot be preserved or unpreserved once the PCI c=
ore
- * has started shutting it down (pci_device_shutdown()).
+ * has started shutting it down for kexec (pci_device_shutdown()).
  *
  * Driver Binding
  * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -409,7 +409,8 @@ static void pci_flb_finish(struct liveupdate_flb_op_arg=
s *args)
 {
        struct pci_flb_incoming *incoming =3D args->obj;

-       pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
+       pr_debug("Finished struct pci_ser (0x%llx)\n",
+                (u64)virt_to_phys(incoming->ser));
        pci_check_all_devices_released(incoming->ser, &incoming->block_set)=
;

        xa_destroy(&incoming->xa);
@@ -937,9 +938,14 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)

        /*
         * Unlike ACS, only adopt ARI while the bridge is incoming-preserve=
d.
-        * Once all devices below the bridge have finished, recomputing ARI
-        * Forwarding Enable yields the same result for the same device, an=
d
-        * must be allowed to change if a different device is hot-plugged.
+        * Once all devices below the bridge have finished, pci_configure_a=
ri()
+        * configures ARI Forwarding Enable as usual the next time a device=
 is
+        * added below the bridge, e.g. if a different device is hot-plugge=
d.
+        *
+        * The exception is pci=3Dnoari, where pci_configure_ari() does not=
 touch
+        * the bridge, so the adopted ARI Forwarding Enable persists after =
the
+        * preserved devices finish, even if a device without ARI is later
+        * hot-plugged below the bridge.
         */
        if (!dev->liveupdate.incoming)
                return -EINVAL;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 08b768b9e905..2748ca22e9cf 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -560,7 +560,8 @@ static void pci_device_shutdown(struct device *dev)
        struct pci_dev *pci_dev =3D to_pci_dev(dev);
        struct pci_driver *drv =3D pci_dev->driver;

-       pci_liveupdate_freeze(pci_dev);
+       if (kexec_in_progress)
+               pci_liveupdate_freeze(pci_dev);
        pm_runtime_resume(dev);

        if (drv && drv->shutdown)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b5b578355a1b..f3d58b5e7a5d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1073,10 +1073,14 @@ static void pci_allocate_acs_save_buffer(struct pci=
_dev *dev)
        /*
         * Devices that rely on device-specific quirks to enable an ACS
         * equivalent keep that configuration outside of the ACS Control
-        * register, so they are configured from scratch on restore. The
-        * exception is devices preserved across a Live Update, which alway=
s
-        * adopt the ACS controls established by the previous kernel and ne=
ed
-        * the buffer to keep them across resets.
+        * register, so they are configured from scratch on restore.
+        *
+        * The exception is devices preserved across a Live Update. The
+        * previous kernel refuses to preserve devices that need such a qui=
rk,
+        * so a quirk can only match here if the previous kernel did not ap=
ply
+        * it (e.g. the quirk is new in this kernel). The previous kernel t=
hen
+        * programmed the standard ACS Control register, so save it to keep
+        * the adopted controls across resets.
         */
        if (pci_need_dev_specific_enable_acs(dev) &&
            !pci_liveupdate_was_incoming(dev))


