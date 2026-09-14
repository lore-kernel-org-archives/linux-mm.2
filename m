Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ACFFC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FC36B0088; Mon, 14 Sep 2026 12:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A226B008C; Mon, 14 Sep 2026 12:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CB3D6B0092; Mon, 14 Sep 2026 12:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 091386B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:46:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD1B2A01AD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:46:06 +0000 (UTC)
X-FDA: 85212945132.17.99F0A10
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15290160010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:46:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWMg+KKL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mWMg+KKL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789404365;
	b=UKNLkk+X2giSJoci5lobpkvchroaGYUQuALJVDgGhcdWqlZKovJrZrwwNe3rz3CEZzmke2
	OS4Jct4TyBf0hOBUaR8RuPZju1h7g8rSKYfWxTQo8yKzkCksy2cgAHeyNVRqCEFQECpu+A
	iZGoBwi1XbnOxi/YAQvq7jCuweEbPhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789404365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaEn4gJaLG6//UlaQV046R50HUoC/N5LfAqjMif4QV0=;
	b=revzkPS8Mq96qwDW27bGkxYmJYeh6/G65DztHFav44ucOIZhV/RFBGjkhtxBMtXvE0FHDJ
	msn/dRvqodWvEOgRZTpYmnWPFWzoPE9iE29Wgd5s5v1gmTolCM/l5pWrXJuy56o8FUqr+q
	7ylERzxBr5Iu290YDkJ6j/dIserDvaI=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469a3490bso2111458b3a.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789404364; x=1790009164; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vaEn4gJaLG6//UlaQV046R50HUoC/N5LfAqjMif4QV0=;
        b=mWMg+KKLxf8apKVQ4ekhJu/F4vqlBCxIrL/aCglBdDEMHa+uLhFMoaLpybwoj0wH8R
         DZN3DdCmHMLwxofjPlhdaPTI5wB1NEm1GeNUYAwsNOmVmupOkpXPaTNtMeWtP/NHvt37
         9b6Ul6QDz2hLcoCMQ9sMLm/XDQ9BtFY2vSJKsZbOYUeHWtZvRpSpRrQbhn2I5SbPEkbE
         fxWygN/hHpbYYlx0N1cxNnMOj5RrkvyFk9zd3YkH+sBJ+TStMuL2oOqoW5gq6cJlQxwW
         o9fnXYaSV7D/3eLfBurqR+EJj5wk/zRbLM3ceyLh5Es4j2l/z8c7GU2EZqB37+HqUKZa
         Ke7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789404364; x=1790009164;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vaEn4gJaLG6//UlaQV046R50HUoC/N5LfAqjMif4QV0=;
        b=HYlbs/tCIgVdnSmXPol/sRkuFIZ6QlmnZSbzggJUpB1z2h7s6NwT7XETv2GN1pxUCz
         IG5lf69BwQTCziZU4wIpsWvmtm73M/UvRLlgZKOytbxuEphNARXsOV63WCWwgZmhvExe
         xHIPdXU0OwKa/gPZZOzevbk9P2UertUfr+VzwViWpWa10KPacEh2kKZ63ltZMnxe9K5m
         IblDqrEivhitDv+8Tzf30QUdLySdHG97jifV0uJOURI1cy5JR9JrMlMeNiLzNSBvaIoq
         YzlersFWUOJRx5lnZBaRiVf5zR0jnd/E6P0+6/lnjBq2dDsrz9vEmM+Wo4JLwAktNVfY
         nXew==
X-Forwarded-Encrypted: i=1; AKwUvBzFfk6yjTENvKJ0UX/zVUmE+Ajr9yi0iWgWmvsGKJMFFb9XDV8o9YQd+A1LdeJV5mfMJF518FPdYQ==@kvack.org
X-Gm-Message-State: AFuF++mQQJqWrALa5lHIihuZLOiFznndtAIy3VIU4aEFcQAdUP+JZwit
	aLULan3HiBUHXcIciz4gvBGxq0x6mPoUWfHl5tcEtV9VOPG8wIg6rWef8oe5V5RV8Q==
X-Gm-Gg: AYBFou083a5wj44SHfq5jUQpKj+Na9U5UBHNvTCxvnprf+gR7eNdyHEsE7dVR+pkepK
	3oN72PmjlPb99LiITIHD8C66VrPCeb73kYKBDGCzvL2zxw19935yLJyugHXNNZropDfzLTjW65k
	ZPFltmmV30HCoYPs1s/III7T7lNUy0GjAcN8CVcEH2xiK5CMtw0LFh94Bo+Zk3yUIiPGgsR8Dqg
	h+rQgdMYMFtvTOEsukvY0qfedfPH32+oRw00cXrvXXWvfd3CHxiV00H9qlejPD+Z3sL+JxRnerp
	sXF3KDLd0qExw1QDkBKmbExYq1Y42+brY22Gl5fENck6DBYz86OP422stqow4YnCP3cIo745Bep
	o40n4zzQI5yPcOxOxGzK2W7E+y8BlzL6P0hQOIRaQBqdGWKrztb4xlDKjMTP2Wd7nzSZio9h3Oy
	2yX19XqhEJcxcwDmWJbNJ3FSzjion1V2gAmq/VWQNUxoP12uQlUoq4LNNQ2EtmGHgC49XGmlMcU
	lyISFEgSdf9CuT3r8Abcz25F3ETqFHWMAaFiewP
X-Received: by 2002:a05:6a00:2992:b0:857:7337:5db9 with SMTP id d2e1a72fcca58-86f860d2bdfmr7633241b3a.23.1789404363216;
        Mon, 14 Sep 2026 09:46:03 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b21f0597dsm4930607b3a.0.2026.09.14.09.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:46:02 -0700 (PDT)
Date: Mon, 14 Sep 2026 16:45:58 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 08/12] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
Message-ID: <aqgkxmXlhfqsdfAa@google.com>
References: <20260728221007.2098560-9-dmatlack@google.com>
 <20260910235149.GA364189@bhelgaas>
 <aqRJF8OME7hn7CJr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqRJF8OME7hn7CJr@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 15290160010
X-Stat-Signature: 8kh78wuigk647uxskz9xq59s1he7xzif
X-Rspamd-Server: rspam01
X-HE-Tag: 1789404364-661939
X-HE-Meta: U2FsdGVkX1+f3bylwPVYCqpE+LRWENzaAIa/tJJqyT1x/wn8el3sGRG5wezbiTNDHo/Ph2PzpzQAG6MSxdT00+wO7xzAHKyqROJsKFT22OQIULReOJcX00ScYyOE3wyFiBd3eLFkCYCIqXsjgy+Db4e547f2m3OgI89VO3y3q3PklHUBAXOAHNWIBISTv+9zLyrIURpnwu8R2pzswKzeKmnrZzVpyPMJW1eHn75R5BSIQjyRm4DF0cm7vUlIN1RaD48VQ74rdBtHpap9FO0ql4IfYWQMVhVLPsYAmKIZb+2K0ygs3UnIXKVM8WGb1G9FLFcBHak9NbH+kiQJR3GPFmqwKiPBci2GU9ZQOjeiRD3NfRNbj0cGwwFEODgvA7MurIZQXRyDCwynsgXvVuo08/iW/RH6RzjWqLVLPoDAj73QYBIf3OANYLiRrTaSYjYf7TBZHbYJExOn8dHpyI9rz08BDZq2N3jJDiT+T9/E6A8xzGnrQRx/0m6Uxfl2Irirg7x1NXbp9eVEDXci5Dx/zBJhVXbKI6h7WK2hp63VilAVPW/rAuyxL6giIvkiGLbTR4Fij9molqRTloLKB1hz2LQQQ8zmww2f7dSQjG0vtavf7J5B/80ZN1kxR2sgpuqV9GYbIuO0YfOGLAEy64Zn6oKj6mf5Cgw92YHNnVmpdTji7QwSs52Xf2v0CCzQT6z1s1qWsems7s/aWllKmtbIfTjZ0Wba0d/GlWJmHWYQax73MBXkigP47NsOfmThsHs+x6659OhyJPRPIdvDHP/q/FwqdRsH/Q2MW8UVN6xYlhu6tzv2HzuvjmZRf2ASz0nTbFWGNM2hz+mAin33TQTftRGplbS3ihz8eSXCl3eyPqruRNcRklr+UqyqoARyTq8HPXj07JJrSpfRnG0q66lCVMZJTXxKiOseqJOpks6VBtAb6wmpXJ4SGHPOOy0WneuIzZPu4baBdoiY+bp087H
 vkMYhJlg
 nfNMeDqVoVG1CWoGpGPwmD4sRrO0kP5N+Q7nvZVv6K+5qWMCVabkXC3pLS9hm84bXPehjqRxZoeh1LLydlwajbRPX8x86bvhbkAYo38GNRLGG5+E3MuEe18qqG2jlFTm++FDP2VC7ePtARcy046HXG0zubzPJJg67SMhNVYg7m1U/fYiGf9r32t47cBnMxXZE0yjkix7f2COYqgKucHMxTXpcrWypNjLWIAczJQcPoWTRGTLs3tkDQQMnDzFeoW6LIx/0b3I/viJzOr9Bdj/F22p9iYJ6XKtAQKsV49aaKeMd82mMVoTkGgoHWnmjbnCVOOWSraxhdBt7PfQdFEAxALTaoGrMVlm/WRsU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-11 06:31 PM, David Matlack wrote:
> On 2026-09-10 06:51 PM, Bjorn Helgaas wrote:
> 
> > > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > > index 77b17b13ee61..22001bdf4c97 100644
> > > --- a/drivers/pci/pci.c
> > > +++ b/drivers/pci/pci.c
> > > @@ -34,6 +34,8 @@
> > >  #include <linux/aer.h>
> > >  #include <linux/bitfield.h>
> > >  #include <linux/suspend.h>
> > > +
> > > +#include "liveupdate.h"
> > >  #include "pci.h"
> > >  
> > >  DEFINE_MUTEX(pci_slot_mutex);
> > > @@ -1008,6 +1010,9 @@ void pci_enable_acs(struct pci_dev *dev)
> > >  	bool enable_acs = false;
> > >  	int pos;
> > >  
> > > +	if (!pci_liveupdate_enable_adopted_acs_controls(dev))
> > > +		return;
> > 
> > Ugh.  The asymmetry between pci_save_state(), which does nothing
> > ACS-related, and pci_restore_state(), which enables it, is sort of
> > sketchy to begin with.
> > 
> > The command-line parsing in this path feels like kind of a wart (not
> > that you're touching it).
> > 
> > It just seems like this path is already hard to analyze, and
> > liveupdate is making it harder.
> > 
> > If we could save/restore the ACS state around the reset, wouldn't that
> > solve this without any liveupdate specials here?
> 
> Yeah that would simplify the liveupdate support greatly. Let me work on
> that for v9.

Here's the patch I have prepped for v9 to save/restore ACS controls
around reset:

From 0c69424454de0c569aca67bc69f496db915a9bcf Mon Sep 17 00:00:00 2001
From: David Matlack <dmatlack@google.com>
Date: Fri, 11 Sep 2026 20:05:04 +0000
Subject: [PATCH] PCI: Save and restore the ACS Control register

Save the ACS Control register in pci_save_state() and write it back
in pci_restore_state(), instead of recomputing the ACS controls from
scratch with pci_enable_acs().

This makes ACS symmetric with the rest of a device's saved state. Today
pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
the ACS controls from the kernel's current ACS policy. As a result, a
device can come out of a reset with different ACS controls than it went
in with, e.g. any controls programmed outside of pci_enable_acs() are
silently dropped.

pci_enable_acs() runs when a driver binds to a device
(pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
the device's state. Refresh the saved ACS Control register there as
well, otherwise a subsequent reset would revert ACS back to the
configuration left behind by firmware.

Devices that rely on device-specific quirks to enable an ACS equivalent
keep that configuration outside of the ACS Control register, so keep
configuring ACS from scratch for them. Do the same for devices that have
no saved ACS state at all.

Assisted-by: Claude:claude-opus-5
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c    | 66 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h    |  5 ++++
 drivers/pci/quirks.c |  7 +++++
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..dd25c01736b4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1021,6 +1021,55 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
 }
 
+/**
+ * pci_save_acs_state - save the ACS Control register
+ * @dev: the PCI device
+ *
+ * Record the ACS controls currently programmed in hardware so that
+ * pci_restore_acs_state() can reapply them after a reset.
+ */
+static void pci_save_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state;
+
+	if (!dev->acs_cap)
+		return;
+
+	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+	if (!save_state)
+		return;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
+			     (u16 *)&save_state->cap.data[0]);
+}
+
+/**
+ * pci_restore_acs_state - restore the ACS Control register
+ * @dev: the PCI device
+ */
+static void pci_restore_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state = NULL;
+
+	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
+		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+
+	/*
+	 * Devices that rely on device-specific quirks to enable an ACS
+	 * equivalent keep that configuration outside of the ACS Control
+	 * register, so there is nothing useful to restore for them. Configure
+	 * ACS from scratch instead, which also covers devices that have no
+	 * saved ACS state at all.
+	 */
+	if (!save_state) {
+		pci_enable_acs(dev);
+		return;
+	}
+
+	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL,
+			      *(u16 *)&save_state->cap.data[0]);
+}
+
 /**
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
@@ -1057,6 +1106,15 @@ void pci_enable_acs(struct pci_dev *dev)
 	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
 
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
+
+	/*
+	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
+	 * pci_bus_add_device() has already saved the device's state. Refresh
+	 * the saved ACS Control register so that a subsequent reset restores
+	 * the controls programmed here rather than the ones left behind by
+	 * firmware.
+	 */
+	pci_save_acs_state(dev);
 }
 
 /**
@@ -1800,6 +1858,7 @@ int pci_save_state(struct pci_dev *dev)
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
 	pci_save_tph_state(dev);
+	pci_save_acs_state(dev);
 	return pci_save_vc_state(dev);
 }
 EXPORT_SYMBOL(pci_save_state);
@@ -1877,7 +1936,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_msi_state(dev);
 
 	/* Restore ACS and IOV configuration state */
-	pci_enable_acs(dev);
+	pci_restore_acs_state(dev);
 	pci_restore_iov_state(dev);
 
 	dev->state_saved = false;
@@ -3532,6 +3591,11 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
+	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
+					    sizeof(u16));
+	if (error)
+		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
+
 	pci_allocate_vc_save_buffers(dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ba3c3fddddc2..037c1674f164 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	return false;
+}
 static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	return -ENOTTY;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7aee30734303..e500c202d2ec 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 	return NULL;
 }
 
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	return p && p->enable_acs;
+}
+
 int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);

