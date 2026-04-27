Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03870FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 668C06B008A; Mon, 27 Apr 2026 17:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6157F6B008C; Mon, 27 Apr 2026 17:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6006B0092; Mon, 27 Apr 2026 17:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0736B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:16:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4CBD120197
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:16:20 +0000 (UTC)
X-FDA: 84705594120.03.1820A01
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id EF1998000B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:16:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOnVpJw6;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoYHmP3P5CE9uRo6oAHvuPVhyMgbUDB0HnjltwJJ+5c=;
	b=7X/8EQDmDpJctQot+CD3K+NidsYCOMNSABdBfrWkjyHtFFS6kKB9a8WpB5t3wlYJ32wXQL
	MhYWzK92IAvKdXCtgoRbDOY0Wdz1ovM/ttIl87U+rjsZH615FtKsUejVp1qL0F95o58nxS
	xnl+ZA6IpfSMTgEnFweuAN+m3fFm8NA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BOnVpJw6;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324579; a=rsa-sha256;
	cv=none;
	b=Tl7s+Pu7CAl+icuojvtQ6h6SCH87DYByAnpkJ9DdXPuhzXYipjqZPyy7Etvd5lT0Ga7ITd
	YOQbr3KwP+HounCwoV5HWtzMAmv0waeo2Vm+pHe+r0Cnza6QCG5fAABFnLohMyRghVP+KQ
	1lBTCgFHJtfpzF6xz+FeXIADzLLi66s=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so9199672a91.2
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777324578; x=1777929378; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xoYHmP3P5CE9uRo6oAHvuPVhyMgbUDB0HnjltwJJ+5c=;
        b=BOnVpJw6iO7QDnt/VpcPCsMeY5xU5Qe3/SsB+ekd3M6fYcm9elOfFVQP42DIFhEkPk
         mudWYYDdNoxdccxBLMzTo2rvQTM8v0zGYHhElZ09tsBRSD/5oftSsDCcJf+jaV2ym1q6
         d3LttnmUmFssFeR300T/la8mKiKSZJ3yNfV/biYT6GTugtjE3cUoLOQD1+3f863i9nLA
         mfpDVRPKMvX33xbQF9URFfBwI011aysgkmlRlkfa17qnS4tV5ixI9muantNx7G0xBVd8
         0fDf2xM5oLD6irDkVuoCkgZMerW7749q12i3sYBAN+3+UxHXEH7lhrped4WMxngy+8pz
         CDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777324578; x=1777929378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xoYHmP3P5CE9uRo6oAHvuPVhyMgbUDB0HnjltwJJ+5c=;
        b=c/8lAhoq73aYLJomT5jojLJP5PAxqu1uvDaR4K0U9wsRDdzhu9wpfLjA3gYJixHjX+
         5iUtxGiuNx2hwLAXnukmjcddLj4DOBpzt8frBZZ9A5Vo22/hsNhpH33SJZjcU7K+Hqyl
         3C+8xrkgrzn5KASJ0CWtydJwxCgoio/HhgPljZ0lxfczWT0kmSVOa6aDtOmYvEB/wwbi
         c3RuWvYSAorePdU3P5dqtVvLyxQ0tDcQBIyHbH+i3XbVe+/HCFaZ9yJKm+qr5WIpoikx
         53AtNpwL40JnCYX5y/F9zJVpwUE4I1zdCVUX3RUeznjTDpxcXwtvcHRFHn5JjnNmsKK7
         ytYg==
X-Forwarded-Encrypted: i=1; AFNElJ8jpsqsfAHTg0eEppXhV4JhgHVJi0Nvk9JLwFccy598wYS1RHX7izPL3s+0ZHD1lCED+sBTr1V8FA==@kvack.org
X-Gm-Message-State: AOJu0Ywrtfc2ETHYJe4Lclb80Er96Jyq+8FEKadsdCyo3eYqGgIUxpTy
	x/XwOOxkiHwLnpUcD2Eg0g82z0SLeVmlZNAhvvqRKEYasTlnMnnwlBHTXj5pIWKEZA==
X-Gm-Gg: AeBDieuRYuylUDA6VTRoXSWeU0qFEZ7PFtqZYXp+f+w3fYlPTXsHzfU3EJIdnDkYrMR
	LweVpbn+xCZ5+BeC3B/ojaTpHpuLcQFeqW29JlU5U4DKR8hxIUNyWZF9iseCQGc74zt56/oiSTZ
	nR8OJkWivY/l9Bsrf08drt3VFMZhUZ/cdJ6agZwPmctxOvc5c4tPwrV1Azrep6zyxzaGnRMLzeG
	Wv9r/Tk5QkzEpxMAzYwfxQWUKInMZl/RtCD60lHpiUmFzz4YysU5PXLBIMN4BECffAC8eQyMi/G
	9OPJJs/n89YpnJJmTGZEMloViToixGPtLY3OGsyDpvO6XeambAPh8LWqR+nmzInO+i9lfk2bm7L
	ZN+bTRHK5qIWKlT70TJq7VfmY5ckC54v1b81/pOQsG+PDui8vDjkePUJzdR6yeYuQwPMI5UiVNL
	EW/W1d/Zpl6ia4qyMFy3l35NjCuZEvUHvAgv/PyfZpFouhvfYPveFa+lOk7vb4Ba5W/TfaWYJm2
	L7KYQ==
X-Received: by 2002:a17:90b:2ecc:b0:35d:a861:36dd with SMTP id 98e67ed59e1d1-364921cdd5dmr252218a91.25.1777324577283;
        Mon, 27 Apr 2026 14:16:17 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490dd6be5sm347273a91.6.2026.04.27.14.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 14:16:16 -0700 (PDT)
Date: Mon, 27 Apr 2026 21:16:12 +0000
From: David Matlack <dmatlack@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during
 Live Update
Message-ID: <ae_SHCjNGrEPurzH@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-6-dmatlack@google.com>
 <20260427114745.00000656@linux.microsoft.com>
 <ae_J2pRWFf5qjZXb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae_J2pRWFf5qjZXb@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EF1998000B
X-Rspamd-Server: rspam06
X-Stat-Signature: isrij8m51ccxjbrndga9txsgpadia7tu
X-HE-Tag: 1777324578-631690
X-HE-Meta: U2FsdGVkX19UdDeVfltI01mk1IKUjDTcywGqS1F2tK/rop6rCBDPRGGP1rCSBtp5xp7rddNVEghzuSCSnsif5+jNi4Vv03BCVwa8UlprTO9yFQ+wVzQn8C+zhBfpuyWLk8Qj/+jbHBDUOQiS1ugEtCCPtY6uBEMIaX9i+HQ3lsOBTE6zpDJNmKVBqQRUbmBrz1Y2CHp0WOciT9if8u6czwJ1VFiPBh6A/NnJ97kzWuQEcOOO8mEjwRmyk2NYtG00r4bhxkBm3w5Rnf6tTjrXk8gGPrmlaVH/cgSd2LUS4/1MR2h0AOQyfhCQTm//Iv9rE/J+a05DxGMfHTO7TBthtKUYsljjIAwIW+eCDHvJcp+3lXDKEQ6b0Lc2Ukk7UIPZHEVb6uIMIgf6B/QP1KMQL6DbFu/7MJhSZx519pCFX67CruhAtK2rfqshff+oYhVw6kz6eqop2HeGEWcJ3RjcjVdVQzCRugC49IuAySOhe+zF8Lb67xCi1mn17Z3vEIN4y3Q/d4RJGUNaMZu4T7EQ9EMpI6htdsv3g+nePy3sH8SzNRTd6/3s9fOOrjA7wVBGFhjY25fV47ZaHtKFCO7cZxfF/e5PbqFsHhvaTDDjs6XGeD5AzJ0TNexX7lnjVgIh6awCJmwFCAjGzc58i2Ym3/YKdk96vBSv7duMNVWP1oD5jpSG+ypf7T0QCMSWXSwjJ1o3lG/BLkuMaoYDJaYhcrzDS0bS6zKqYzTFCgNBkjOQwV99cIJNnLXE5XlsnJTd6ZA4ZIKfyA6Ov0PgjJnc5c/kJ1wn2+B5Qz9mjGxRf08rTmra7odNJbSa6vLHU9ZbpJzre7QmF3mzneyC2wedpXCQ6Mp4jNmHjTIQbHyA26SEC6eLl6JOMqF02IobjPNVYgGjm6wSFiH09t+wQnsbNt81+aoII8gdAOKZ7j529cBiJAMnHr2ky+IWF3SrOL00l3Ep2PFKN/rZLMq6FBR
 /6FnMZR5
 cckQGt9KmDS5rotgIItJTUjuIqtb94Ay6POypyc38oFejbLIMdxZSCDJUJDigUtRR3E9S2LVCW73PyA4rPWCLSVFGF/Q6iLcZTaPpOirty6JN2LUSwZ81ghdG6AdfHYLDvEBA6PiVIMOl8S1VNX3c2if5Mv3BvUuRCGm8nkbkQKuJRkIB6nsJgIXPEeREu3TuY5Hhhe0RmcjuDbx1GAph4MwUe2vEH9xVZ2AXsnnGt5tVTg6eSuDvcBH3D6f5XTfAzUyKWKZrhjRUbmtQWvH/SolfZapHsrv74U5SDjwj3Ts1N/uKTGbWUDLT8ZpRe3f+L6w1bUfigLWTVB3et2wPeqbbE/RSIcOYflFI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-27 08:40 PM, David Matlack wrote:
> On 2026-04-27 11:47 AM, Jacob Pan wrote:
> > On Thu, 23 Apr 2026 21:23:09 +0000
> > David Matlack <dmatlack@google.com> wrote:
> 
> > > To keep things simple, inherit the secondary and subordinate bus
> > > numbers on all bridges if any PCI devices were preserved (i.e. even
> > > bridges without any downstream endpoints that were preserved). This
> > > avoids accidentally assigning a bridge a new window that overlaps
> > > with a preserved device that is downstream of a different bridge.
> > > 
> > > If a bridge is enumerated with a broken topology or has no bus numbers
> > > set during a Live Update, refuse to assign it new bus numbers and
> > > refuse to enumerate devices below it. This is a safety measure to
> > > prevent topology conflicts.
> > > 
> > > Require that CONFIG_CARDBUS is not enabled to enable
> > > CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
> > > bridges requires additional work but is not a priority at the moment.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> > > +	/*
> > > +	 * During a Live Update, preserved devices are allowed to
> > > continue
> > > +	 * performing memory transactions. The kernel must not
> > > change the fabric
> > > +	 * topology, including bus numbers, since that would require
> > > disabling
> > > +	 * and flushing any memory transactions first.
> > > +	 *
> > > +	 * To keep things simple, inherit the secondary and
> > > subordinate bus
> > > +	 * numbers on _all_ bridges if _any_ PCI devices were
> > > preserved (i.e.
> > > +	 * even bridges without any downstream endpoints that were
> > > preserved).
> > > +	 * This avoids accidentally assigning a bridge a new window
> > > that
> > > +	 * overlaps with a preserved device that is downstream of a
> > > different
> > > +	 * bridge.
> > > +	 */
> > > +	dev->liveupdate_inherit_buses = true;
> > > +
> > This flag never gets cleared after the incoming kernel boot up, what if
> > the user does a manual rescan via sysfs? i.e.
> > # echo 1 > /sys/bus/pci/rescan
> > pcibios_assign_all_busses() will never gets called for this device, and
> > may hit this
> > 	if (dev->liveupdate_inherit_buses) {
> > 		pci_err(dev, "Cannot reconfigure bridge during
> > 		Live Update!\n");
> > 
> > So, maybe clear it in pci_liveupdate_finish()?
> 
> I think we can allo wa rescan to assign new bus numbers once all devices
> go through pci_liveupdate_finish() by clearing
> dev->liveupdate_inherit_buses on all devices in pci_flb_finish(). We
> would need to hold pci_rescan_remove_lock to avoid this racing with such
> a rescan.
> 
> Now that you bring up /sys/bus/pci/rescan... I think we also need to
> set dev->liveupdate_inherit_buses in the outgoing kernel, to avoid bus
> numbers changing on outgoing preserved devices. pci_flb_preserve()
> should take pci_rescan_remove_lock and set dev->liveupdate_inherit_buses
> on all devices, and pci_flb_unpreserve() should do the opposite.
> 
> If we did all then then /sys/bus/pci/rescan can work like normal as long
> as no devices are preserved (incoming or outgoing). If any devices are
> preserved then dev->liveupdate_inherit_buses gets set to prevent bus
> numbers from changing during a possible rescan.

Something like this? This is a diff applied on top of this commit.

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index fead478e8a04..b1b0a5b1a5df 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -120,6 +120,20 @@
 
 #include "pci.h"
 
+/*
+ * During a Live Update, preserved devices are allowed to continue performing
+ * memory transactions. The kernel must not change the fabric topology,
+ * including bus numbers, since that would require disabling and flushing any
+ * memory transactions first.
+ *
+ * To keep things simple, inherit the secondary and subordinate bus numbers on
+ * _all_ bridges if _any_ PCI devices are preserved (i.e.  even bridges without
+ * any downstream endpoints that were preserved).  This avoids accidentally
+ * assigning a bridge a new window that overlaps with a preserved device that is
+ * downstream of a different bridge.
+ */
+static atomic_t inherit_buses;
+
 struct pci_flb_outgoing {
 	/* The pci_ser struct to be passed to the next kernel */
 	struct pci_ser *ser;
@@ -141,6 +155,29 @@ static unsigned long pci_ser_xa_key(unsigned long domain, unsigned long bdf)
 	return domain << 16 | bdf;
 }
 
+bool pci_liveupdate_inherit_buses(void)
+{
+	return atomic_read(&inherit_buses);
+}
+
+static void pci_set_liveupdate_inherit_buses(bool enable)
+{
+	/* Ensure updates to inherit_buses do not race with rescans */
+	pci_lock_rescan_remove();
+
+	/*
+	 * Increment/decrement instead of setting directly to true/false so that
+	 * pci_liveupdate_inherit_buses() returns true if any device is outgoing
+	 * preserved or incoming preserved.
+	 */
+	if (enable)
+		atomic_inc(&inherit_buses);
+	else
+		atomic_dec(&inherit_buses);
+
+	pci_unlock_rescan_remove();
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing;
@@ -180,6 +217,8 @@ static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 
 	args->obj = outgoing;
 	args->data = virt_to_phys(outgoing->ser);
+
+	pci_set_liveupdate_inherit_buses(true);
 	return 0;
 }
 
@@ -187,6 +226,8 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing = args->obj;
 
+	pci_set_liveupdate_inherit_buses(false);
+
 	pr_debug("Unpreserving struct pci_ser\n");
 	WARN_ON_ONCE(outgoing->ser->nr_devices);
 	kho_unpreserve_free(outgoing->ser);
@@ -223,6 +264,8 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 	}
 
 	args->obj = incoming;
+
+	pci_set_liveupdate_inherit_buses(true);
 	return 0;
 }
 
@@ -230,6 +273,8 @@ static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_incoming *incoming = args->obj;
 
+	pci_set_liveupdate_inherit_buses(false);
+
 	xa_destroy(&incoming->xa);
 	kho_restore_free(incoming->ser);
 	kfree(incoming);
@@ -385,21 +430,6 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 	if (!xa)
 		return;
 
-	/*
-	 * During a Live Update, preserved devices are allowed to continue
-	 * performing memory transactions. The kernel must not change the fabric
-	 * topology, including bus numbers, since that would require disabling
-	 * and flushing any memory transactions first.
-	 *
-	 * To keep things simple, inherit the secondary and subordinate bus
-	 * numbers on _all_ bridges if _any_ PCI devices were preserved (i.e.
-	 * even bridges without any downstream endpoints that were preserved).
-	 * This avoids accidentally assigning a bridge a new window that
-	 * overlaps with a preserved device that is downstream of a different
-	 * bridge.
-	 */
-	dev->liveupdate_inherit_buses = true;
-
 	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
 	dev_ser = xa_load(xa, key);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 09bab39738d7..abd8379b99cf 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1442,6 +1442,7 @@ static inline int pci_msix_write_tph_tag(struct pci_dev *pdev, unsigned int inde
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+bool pci_liveupdate_inherit_buses(void);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -1450,6 +1451,11 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
+
+static inline bool pci_liveupdate_inherit_buses(void)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index fa26f4170add..f94fa1fc76cc 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1374,9 +1374,9 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
-static bool pci_should_assign_new_buses(struct pci_dev *dev)
+static bool pci_should_assign_new_buses(void)
 {
-	if (dev->liveupdate_inherit_buses)
+	if (pci_liveupdate_inherit_buses())
 		return false;
 
 	return pcibios_assign_all_busses();
@@ -1409,7 +1409,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
-	const bool assign_new_buses = pci_should_assign_new_buses(dev);
+	const bool assign_new_buses = pci_should_assign_new_buses();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1518,7 +1518,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
-		if (dev->liveupdate_inherit_buses) {
+		if (pci_liveupdate_inherit_buses()) {
 			pci_err(dev, "Cannot reconfigure bridge during Live Update!\n");
 			pci_err(dev, "Downstream devices will not be enumerated!\n");
 			goto out;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9a602b322e3c..dd6b26ca9462 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -511,7 +511,6 @@ struct pci_dev {
 	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
 	unsigned int	rom_attr_enabled:1;	/* Display of ROM attribute enabled? */
 	unsigned int	non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
-	unsigned int	liveupdate_inherit_buses:1; /* Inherit bus numbers due to Live Update */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 

