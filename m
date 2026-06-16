Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C800ECD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E98A6B0093; Tue, 16 Jun 2026 16:38:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874A16B009B; Tue, 16 Jun 2026 16:38:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762A36B009D; Tue, 16 Jun 2026 16:38:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2996B0093
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:38:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF86D1C10CC
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:38:45 +0000 (UTC)
X-FDA: 84886939410.30.73C7BE8
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1BF3918000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:38:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3Yd1Z9n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZboXXhSPW6+dD4pxDQDq+/2Nr1RExG44843PmiSexM=;
	b=ITVtuNYPXLLGxVD11THe01N03iTIsDXGeUp/wBA29Tw0ybp6cV4BRBRd5scflNEvRePn62
	vAIMlpJAptSSWWtVL6/4ecbPqcx5T1uaJzSdOqzlD9aYGvFYr/nZ6JqXL9a3Ka8za9jFVe
	DpZWKqlBWbmyzQsbr8tkUW3+STeqF18=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3Yd1Z9n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642324;
	b=KPf+jfdCrBEqLkzrDllDyT70hiW3eXvwkSzVN0ocrnxxSjL08A4sprp4hrNPs31OcghOsd
	kacRNWwx8KLqtvXY19I4EdNmOOJqYzR1Z5fU05w3QqZyUXZa7fY1DrbP3upkBYCtvTPnL/
	Xk1RnOXaznyuxxNaryQHnruvpGzoDTs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51765531803so81611cf.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781642323; x=1782247123; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZboXXhSPW6+dD4pxDQDq+/2Nr1RExG44843PmiSexM=;
        b=l3Yd1Z9nOOoLpRRCVE/0JegJtDkmM1bi2yVE3En+MlCIZx1Vr9TwkFS1d48sLteZA2
         TYp0j5ChwvNW66SlOxdBHeGVOuBZvkpwMhTJHBq5MPBWSvJF4AIjuHBtzwl+fGmg3YPr
         3DDQ+XQpIp7TWvkwsr/WkWl6eeaQLdnEZN7QAyADrIaqIVHq9zmmQ9KxL/UugWcRtNLg
         rlCDb1O8ZKkYpyP3VKEiagT4xVg9/V7UTN6mX0v2IMsmn5ol9cnngxunb6y9kXAhIAxP
         aD2KPGvBUzr1L9Ix9/LN5mdzK/JKal14zZgpeVwHqsaCKq/zSIya0JmoxK6hM5kjf7c2
         iGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642323; x=1782247123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ZboXXhSPW6+dD4pxDQDq+/2Nr1RExG44843PmiSexM=;
        b=d7uCpBXDFeBXloUFKaBDjIrCceAQrfxjpIgPjaSjoj/+JesDky/lVXLtjaDa0m61m3
         dqflOV/3XIjdAAugR/8Ygc8TsYsa8Jjb6/lm0wZSy9Qc4SAEpxg5PF2jgS2QkfeVF/fX
         LPb1NYgMSXrYYYbcRIdij+5UPYyoKQtYM2WIWHtHhuQE1hr+zpqy7bCI1xc+VPlTjgz8
         zQQFuCogDTN7kz69CwjIOzD3utkQ9QwlgPIwlu9+nF0Uo1fIrdfrb4AB7neYSBYiSLvY
         KXG5sH8QzXE7i/qE5d9d1OWqS3RWrJPxlrjupQUgBb8Os+pSE65kb0Qq/XhuBHVpUWBi
         ptcw==
X-Forwarded-Encrypted: i=1; AFNElJ9kumbIPEhRGFxMQFAugT/fwuvoMFOyINQ3k4hcTG89+pc37IT5D7KkywGyZgYU0pZI39wbbmPyjQ==@kvack.org
X-Gm-Message-State: AOJu0YzEmAIo7IVW6zi7Ccc3ODjX19P7TM288CyykpLO/Pnur+CGZWjy
	nUjAus/BBycoa6fIib0boYchlxETRVL9mAfAB4pQogkSKEwzvUY5+xufni7VVsOWFA/Guqgl4E7
	6zMP9Jaij
X-Gm-Gg: Acq92OGulzL0fHS4lnx9+St8Q+8CsHv9Dbsb9dDZKKxAwqo1yrOfwDNBWGJYp7igkFa
	HzWqdY3V/kPpW3eNa3Yxp1+UpgyxeDUn5DBv4SanPeB//3ZqyFwoSBAm/VkkVbdhsqlwUs8mZC6
	9attMt50BilvBrB5D/QndrmExWDtAcsRyKMAHR3UuM94BsaZp9XA4reWItDNr9O9c5/rNkdtnxd
	220lcepAIIHkchOB1clvY6exxhId4WAKJcVtDqKj7yzQfux5JJNBcxmX/5mhrZsqWUuPgD4rBvi
	m7yyBqt/puAXOjvymNmBTCl5HL3vGwUkcHf1FmUwxnJJx3PXlWCDmN8V3Ur4VDzXZTZq7sb1nSo
	WbncbOedC6bby47rhXPjMvrh1ivc/DZjg0gCiISiCJN4FQgBy0nIeOU6CY5AE/ywnNCmKqzT/vJ
	Maynl9aq9HabeTiZ03nEw236CItNZHjbIGopN+I0qr8SWvX0aMBO7QVj82KRGZsCgKYFMFB3H17
	e4HPGn7dbQ+SQ9NQyo=
X-Received: by 2002:a17:903:2307:b0:2c1:ee6e:be1c with SMTP id d9443c01a7336-2c6bbb0fd15mr461975ad.26.1781640594220;
        Tue, 16 Jun 2026 13:09:54 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ac9c016sm13938380b3a.8.2026.06.16.13.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 13:09:53 -0700 (PDT)
Date: Tue, 16 Jun 2026 20:09:49 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <ajGpxMXk9iyXLzC4@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-4-dmatlack@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ids64u7sfpzfwkkmjkatxfr6g944nggx
X-Rspamd-Queue-Id: 1BF3918000C
X-HE-Tag: 1781642323-414343
X-HE-Meta: U2FsdGVkX1/gbxoGJZfkvvuAEeF3xFaofEkUqysFDHouKPiqC56U49Wc0+jINAulLvy5fs4ds1qN9LwwZFmOmtDXKkMCoyjcuzdTwfFSW2NO+5ZaOtNH9KGje3gnCFAI5+WFR4PPcum5yVwP+jxb2oY5o00KjBBYsS978VBLa2+YS8Cpr2qFW86IifOdElGnqWkgslY1Q+rl7dEqO987Lu8Hf3eG7ePcwEfm5ZZQSJVkjAjPyC/UUjIVL3q8PFrg+hbo2+SVlrzKLn2hI9d1Z+lrr0FyxdE5yEQ+V1DOQ5Nlv3dcuq6Jfb7vUPZz0MCfC0XaDrdyb6A89O6GglBqNiHa2rvYw+3sEIJg6zW53ftgipuDg9K6ucO/prwjp49tMXLwIhU9h17l5YjJAfk7qeumuOcZskpBrio+IHdsnCi2mXZ6l2dXqfkYpLHYMCyswZab6x/Z6fQJj9Nmb+1o9kOM+myQa7j92AvGT76h+4YPbS/0oEwOV/Z1pkneOBVuJDHfSnqdd+vdP86wxWb4gS57e7cLRQ5poFI1Hz4U9EgFKEE1cFl+6JBLUR1+79dGLwMNJommEogFeyUCMlmjuaoP7jlhtZx62QBzoBfmXg3YACzTP4psiaWzAJv24F4hinaaipTyabcmTW4XR4FF8veb0UjN0wQWDqPqEbYySlL/OfB9XMMqS0k6Dh7aF1Qoa8oERrU+hx3UDaIxyBBtZcdjo+ZEGRKdIhfwU/aHJYauXSGIZJlPpACNK13R3LN25dZ3dDNd1xVplpivrnsSG73pfLSzcW8dj2oxdpMV/GJRb+fnu5MeRDc3UpMxy2V3tRtzHfmRJIyT3mIcqoDqyG5W8Lxe4RLa4Z5dp7bCvIXnX2pYqwFc8yIDsz9eHzO/fIeAAHrz4S39p3UAYA5nIFpvPZS3cTpHX8KZ5vs1vbzOOimskWvt3OvBoUdmbNQmixIiyjXpxaUQLjBbRyG
 21cCDgz/
 3dREd2EBO+KGW01ubruqyeWhA1Cg6O4EJJCv4i9/3XG2kDTMpm+IVtg0AXEefDbFUd8rCu+Ol4MEK1dXZyPVzj7qkGDMscpqcZDTszx+1CnMrRXqsQAAkC3M5llGoylTuo7jtPv+azdDSXczS/zPpQ1YCfrvMOdoz+mz5dMYOEGTyeGnhle7Ek9kHsGiIwS84M4njiKp5ihzXDdW0vcX/itYfHXbiFDJ662+HhtIyd5H5gGYj/IvZMgF/p54TtucvNN9Dp1ShEP3QfFKnZLMy/fPNIQTFCho8KXvtAFqIPE6KekTHtuFIFnJn46/O4YKYjNnDWmAefUpg5QbJOhdzzaYH1B+4Kz7vi3+O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:01PM +0000, David Matlack wrote:
>During PCI enumeration, the previous kernel might have passed state about
>devices that were preserved across kexec. The PCI core needs to fetch
>this state to identify which devices are "incoming" and require special
>handling.
>
>Add pci_liveupdate_setup_device() which is called during device setup
>to fetch the serialized state (struct pci_ser) from the Live Update
>Orchestrator. The first time this happens, pci_flb_retrieve() will run
>and convert the array of pci_dev_ser structs into an xarray so that it
>can be looked up efficiently.
>
>If a device is found in the xarray, the PCI core stores a pointer to its
>state in dev->liveupdate_incoming and holds a reference to the incoming
>FLB until pci_liveupdate_finish() is called by the driver.
>
>This ensures proper lifecycle management for incoming preserved devices
>and allows the PCI core and drivers to apply specific Live Update
>logic to them in subsequent commits.
>
>Drivers can check if a device is an incoming preserved device (e.g.
>during probe) by calling pci_liveupdate_is_incoming().
>
>CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
>domain and bdf can be guaranteed to fit in an unsigned long and be used
>as the xarray key.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> MAINTAINERS                    |   1 +
> drivers/pci/Kconfig            |   2 +-
> drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
> drivers/pci/liveupdate.h       |   5 +
> drivers/pci/probe.c            |   3 +
> include/linux/pci_liveupdate.h |  13 ++
> 6 files changed, 251 insertions(+), 3 deletions(-)
>

[snip]
>
> static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> {
>-	args->obj = phys_to_virt(args->data);
>+	struct pci_ser *ser = phys_to_virt(args->data);
>+	struct pci_flb_incoming *incoming;
>+	int ret = -ENOMEM;
>+	u32 i;
>+
>+	incoming = kmalloc_obj(*incoming);
>+	if (!incoming)
>+		goto err_restore_free;
>+
>+	incoming->ser = ser;
>+	xa_init(&incoming->xa);
>+
>+	for (i = 0; i < incoming->ser->max_nr_devices; i++) {
>+		struct pci_dev_ser *dev_ser = &incoming->ser->devices[i];
>+		unsigned long key;
>+
>+		if (!dev_ser->refcount)
>+			continue;
>+
>+		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
>+		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
>+		if (ret)
>+			goto err_xa_destroy;
>+	}
>+
>+	args->obj = incoming;
> 	return 0;
>+
>+err_xa_destroy:
>+	xa_destroy(&incoming->xa);
>+	kfree(incoming);
>+err_restore_free:
>+	kho_restore_free(ser);
>+	return ret;

Hmm.. This is interesting, so the KHO state is freed and it cannot be
reused. I see you already pointed out that we are putting an LUO policy
to say that the retry is not allowed.

But what should be the behaviour of liveupdate in this regard? Let the
system boot in a normal way? This might break other subsystems as they
might depend on PCIe restoring state properly. Also I think some of the
PCIe state, like device-id, BAR addresses, ACLs etc, might be used as
source of truth by other components.

For example, lets say FLB retrieve() of PCIe fails, but succeeds for
VFIO/IOMMU, now VFIO/IOMMU are restoring state of a device that is not
restored/preserved?

Should this be considered fatal?
> }
>
> static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> {
>-	kho_restore_free(args->obj);
>+	struct pci_flb_incoming *incoming = args->obj;
>+
>+	xa_destroy(&incoming->xa);
>+	kho_restore_free(incoming->ser);
>+	kfree(incoming);
> }
>
> static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
>@@ -270,6 +335,91 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
> }
> EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>
>+static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
>+{
>+	struct pci_flb_incoming *incoming = NULL;
>+	int ret;
>+
>+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
>+
>+	/* Live Update is not enabled. */
>+	if (ret == -EOPNOTSUPP)
>+		return NULL;
>+
>+	/* Live Update is enabled, but there is no incoming FLB data. */
>+	if (ret == -ENODATA)
>+		return NULL;
>+
>+	/*
>+	 * Live Update is enabled and there is incoming FLB data, but none of it
>+	 * matches pci_liveupdate_flb.compatible.
>+	 *
>+	 * This could mean that no PCI FLB data was passed by the previous
>+	 * kernel, but it could also mean the previous kernel used a different
>+	 * compatibility string (i.e. a different ABI).
>+	 */
>+	if (ret == -ENOENT) {
>+		pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);
>+		return NULL;
>+	}
>+
>+	/*
>+	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
>+	 * but it cannot be retrieved.
>+	 */
>+	if (ret) {
>+		WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");

I think this should probably be considered fatal as mentioned above or
the caller of this function should get an error so it can fail. I think
retrievel of preserved state should generally not fail unless there is
memory corruption or ABI is incompatible.
>+		return NULL;
>+	}
>+
>+	return incoming;
>+}
>+

[snip]
>+
>+static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
>+{
>+	return false;
>+}
> #endif
>
> #endif /* LINUX_PCI_LIVEUPDATE_H */
>-- 
>2.54.0.746.g67dd491aae-goog
>

Sami

