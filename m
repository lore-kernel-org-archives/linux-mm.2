Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3463DCD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 13:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4374F6B0005; Sun, 14 Jun 2026 09:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7F86B008A; Sun, 14 Jun 2026 09:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D67B6B008C; Sun, 14 Jun 2026 09:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 201D46B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:38:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B9463C27B2
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:38:50 +0000 (UTC)
X-FDA: 84878623620.22.4424FE6
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id C389D40006
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 13:38:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=O4X4Q7co;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781444328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXg+GT95yYO4T14XPgWTJKtcxJfATzJGx0/pfKwDeqA=;
	b=SFgGjqsGiwChgkP88mcJaqZT9SKnjyRNYdlU0PsICkNGF6wpuhlIRycdnFWFtOqySvt64w
	l6Qu71hLZtoXW7TDVft+ndy5zsGSTR4OLWExVUnRS+CkZ+HQPRbSSO+3LBSDwrT7gcouwK
	naPFq9CxTpbnr46ggPeyIYyaROQexLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=O4X4Q7co;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781444328;
	b=qCCOZ9+nN8fvn7PQkxDRSttqbNuBg4PfhzwQftvh7bTCf+L+VtqZW667sbj+8i1+NGZEjD
	Nz+q+HvOPndChm1i4Mu4ZItoDaLMzlxcjLmvTUow2O2ZX2feEoUEvkTEdq8dlibiuOsgcl
	h2ljbdM0iRUusR0/by5vdbo/OLC0vO8=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-517dc520840so27705261cf.3
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 06:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781444328; x=1782049128; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXg+GT95yYO4T14XPgWTJKtcxJfATzJGx0/pfKwDeqA=;
        b=O4X4Q7coQyFRpRzeIdaEoJ8LI2oykMQjx5Y645piUBiXCyeYm12wV2oUcQobWTzu8K
         ILTrVabCjbCSewNcjczakCu8Oae8DbX3DOY2hbcIAAGJiYp2tKH3k2eX6Oj4B4pm98A3
         MpOEi1DEzmF53YKfeVKWsmARp49ZV5BvmlZnf8uHyDKI33Aj3mxhiKhHojde477uqSGB
         zYfJ3Z9MTYf67rII1p0l4iR0gNnYAgP0hZcyAhZNqrqhQzGlLzdnjrim3XtKRZ/xSlzT
         BF/td7has3H94KdbhRp0WSO+TjRMUefzotoFoH4mP8GJveetQslfuh7jGqdevUosYDGN
         0tJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781444328; x=1782049128;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XXg+GT95yYO4T14XPgWTJKtcxJfATzJGx0/pfKwDeqA=;
        b=Tncg/ef/K8HR4iBHeNx6aTTr6gnz65RrzsxHsBwEH3O1kJNwesqyTzUMvqF1CPRHCJ
         xHSsMbgrr/OPs5MBTnBEtYeqT62dHi8LMUffawbcp/VT5pBojBtm+X3rtu7vBxSXShUq
         myu4hw4XFvCFaeZwYNBodotVK0j4+yO3JlSIazhl5/ZoFkyue0br/0IzwAxM/td3zOWa
         7qPd4kUrXTaAV5a3S2OAkBy/jcfK3mZTUsJ5jjmxZZfQxn1Joeo453SqjN2fi/Mh4xa8
         2BWB+t3hWfEpsMn7f0oR7RvMMpyE+49fhIHTpsxHFqG5kYGHlkdOHb+uibosqbz4Mhnq
         4tzQ==
X-Forwarded-Encrypted: i=1; AFNElJ9MO5T3fhHtcop1Kffo7+56rfbZWDG3ApRWVaEogfDeNuutWfiEgsDC+7wi8AGdY4oQkn/7D+DtLA==@kvack.org
X-Gm-Message-State: AOJu0YylKHU6EjksXzcgC2Ch2TJQEfWiUyuhuYaWnNsyQ4OonBbzL0XI
	vwM/y9WGWxfDns3iplTfS9f+xbfJR0HXIV01Szm3N0bPHLQoeY4uViuPwhqI4iJWECA=
X-Gm-Gg: Acq92OGFo+erSGhcCVE3mqsPxoP2cIQuhwnvp8+ZYrNWA3fdL4/XYveKLp87uN+6TxD
	VoA7xugj12PvWsFpXI2KSS3j35wAFyV80O3W+lLfZmSTu4DRrHxUeuNMIv/2de7VghujG6bT3Ep
	LVgTWRZoEJzDFyI3SzMqlChRuaIhJehIEgbBe0GTpWNAfzA90ED3sAQC2umTF8X7/UT4qDmt4a+
	R34ur60OZ6kb9L22vV+9ntYBXWFA5m37H3tELgV9WSE6Se/mDbcDxhz4QTlM6LOU7tQ+9bAAeec
	Hy1f9fcUCfBQY7LySpZqRkrla8H/pDJN7mVR1zxgu4PmW1OVB+QVrGUGbuamVVbTCvSXmdgjfzn
	w8sk6C/RrArcA8T1KM314Anz/UJHdpHYskbx0n6fwAiklfB87I5XYhN8vK929mf+ofhc6n4YPH1
	4/P90VNJtWNFeIBfESvq8tFxhjXs6RsDdEZW/LsXyfVUHmYaTdez1cBx+PFu1y
X-Received: by 2002:a05:622a:8387:b0:50d:66b6:1564 with SMTP id d75a77b69052e-51953503dcbmr85951991cf.14.1781444327877;
        Sun, 14 Jun 2026 06:38:47 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb7dad16sm73669631cf.21.2026.06.14.06.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 06:38:47 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260522202410.3104264-4-dmatlack@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
Date: Sun, 14 Jun 2026 13:38:40 +0000
Message-Id: <178144432039.1257322.9644414453415904478.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3299;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=imkMf1LWuc5WHnOYfzLBjY+C/lZku32PXLp//Z5mGeY=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqLq7l1REohFN/W+c/zZvmZsiNBGib+GmmJ98Xn
 Q+7rb16wzOJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCai6u5QAKCRC7dyhM23N6
 3kxIEADBd+AmGBTMM3+Eeu1O0iFW2mY7VSiDXVMIuYE2Aff07zDsPuFqh4iaxqw5y6yQq1RDRS9
 C+LCuvNoHjr972Bm+MNjX7C07NBMYiDKF/eZq0xHbj1XYcvY3GjqVzl5O2NnP0UkUp3d5XxdB2U
 kRMKTDUBoWa3SJaUak+oxi08sxN+Je36bFKJwqBY9dcpbDzgF/LY2TXsLUIsLhTK7mJJZ1Zua4D
 UllLotthUK/tr3huxjhNXxTtHxzpkCFabCnjYT8xZjmKs/WZmMMSP5laKjVC95NnLsDcZQZJcaY
 fVhlX1FaX9DSWDdZ7SsxAYVJ7Ur3pbt9FjS0jeI2lOhMlBGh/ybDkx4+LAnHvXuwa1taPVB55fP
 eavqiJEVaCFIZWubPMrJDMotiK4Re7Jw1ldxwPS0Qef24xJe0PBaNgnXCwEFfIGun6uZ2ev1uiD
 hsnw6UqUOs1u/utfaWudvAaNnZjzHo0l/k5+sc6C6QYbwAOSME6sT5ASpuABBfnrKTvMiveYmU9
 iSshqRHWh3vmaVHLAuamw7P21HrLeUpe1rAs+hC2gyfZ3ZKwrw4ErSfhqVMgkOBVovFuHcx1P/7
 lQyQjY82doo6RAVRWKXjvFekoAN0iqkrC5llrFeQHZvb2oyr/0eG3Rdd4Ga+VUaHcMzU3/xLWHV
 PULRypTcExsyIYg==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C389D40006
X-Stat-Signature: 4cwqfrxt4dysmyrkptzc1efatmb7hanj
X-Rspam-User: 
X-HE-Tag: 1781444328-649934
X-HE-Meta: U2FsdGVkX1+vxbOdfdbgZPDMgwPv6QV+6eL6PRuWqsB/ROK2W1oOHOxsDiEXwOrL9h+EN03mrSchaszh2UMAPiX26LbQTjFJQpJCFcoMk2bMBD7SlLnLaC/z8zaeS9f6WPvKqaynZXmWt0SpbLwTyi5nje8f/1909ioc6OP2bsL8YEzTQsIZS2nKlxH5JgxlyEH/hclKI+9IWYxDGRAuRTDOQMMncBT/+BRWkJI3XvnNmkRd211uAPKOPztdrt6k8k80wMDvGjSNNSQGN4og4QzpIYSbwDiIT88R+LLjK4zj2zHnOGqGwNqRKB/TzcI6+chI6ukGsodNUuXGv3bE9L7FNnaNa/ypW4mNAxTT32nIUESIDdsMisyvnppXiYXPOpwIHAuxAF6txVxbn//IfALBvLZd9KI8OqHAJK5sYyQQ+I0K7zKTEVcmiefyXxqC/kfKqY7O9bYhz8cbJhYt5rwK1Vp6YoRTo6zG4RBoFZ5IHOk3WRlc3y/pagK9BWaG1ns1O4u77DSfOdDQQVTnI434rSCi5+m8TzYxzgPDwteWMomSiKaxR9o7J0M0Zf3kj6Ibv1tJEhn28jrxVMjDaTKEaju0szOxyyQYEe29FgkXeakV27M/iO0lPRWvx408saLMYf4A5icQVC1+cbzoCBSvALFZQAT5ECfOizjfdOcwLbLXZikYM0Nvqhtixmi6iilLhOPwbZ6ZRQg4tW7FaYk+hKj1lY/+y40ql8whbesQsAiCXz4IdzsHH0FefnONkvoQDOyKYAd9w9QixHttKnm+EvQlcXiXQykGMYvkA/OLmsLZMP9186beb3kwvP3GczZvtRb18GZl1IxfmEiqCYA3WYhy5LUOR32lYCW/xXTlHj1FbrCRQEnSJl/gZoJasPxd+ReO1UyhMr9ijHgHjWtRDP3j+2HVx2yFMprv759ubVAyZTd9Huaz4dkW8Nbw69ISDJSatIh6whwFSev
 woHJ6R2o
 smR4rkxB4HqKsV/Qof1r82kA6u4A0UGzH9zecnALFrH/d2in3jm308fdI/jGEk3N9X7SplXuhV0zXv7FShRgF65MX3xiJU63d9lv05LLQQbcObRm3Yg1YbLz+5IEIPS9Q3y7CupHXYcEkeqie5kA4hvOGZDOoYFLsRlV+HtDkB6qHrook8jqF52jE3c4Ksn+I9CAC5XU6kfM2JtwlJya7LntzRyseZ/vnTj+dG12fTHDNec3kkMFd9V0nSiesuIF5qH8bIlN8Z+9A/n7BTooO6284nWPUpreF5RXnQltm8MnF6JvKtrxksWbRlqcInJnaRysSwj1K+PxKorzS9l7HQ4d0+ymsO/rwMh1MC7Uljt8FGnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 20:24:01 +0000, David Matlack <dmatlack@google.com> wrote:
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 10c9b65aa242..e68ae5c172d4 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
>  
>  config PCI_LIVEUPDATE
>  	bool "PCI Live Update Support"
> -	depends on PCI && LIVEUPDATE
> +	depends on PCI && LIVEUPDATE && 64BIT

Please move this to the first patch, fewer changes between patches, and 
also KHO does not support anything but 64-bit mode.

>
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index 065d5af822f7..96c43b84532c 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -128,13 +157,49 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> [ ... skip 31 lines ... ]
> +
> +err_xa_destroy:
> +	xa_destroy(&incoming->xa);
> +	kfree(incoming);
> +err_restore_free:
> +	kho_restore_free(ser);

This is the pattern we have been enforcing in other places in LUO. If 
the first retrieval fails, return the same error thereafter.

> @@ -270,6 +335,91 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
>  
> +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> +{
> +	struct pci_flb_incoming *incoming = NULL;
> +	int ret;

Maybe make the error return static, and avoid another search through compatible 
FLBs if it failed before?

1. Add "saved_err;"; if it is set, return it right away.
2. Change all errors to use goto save_err;, and at the end of the 
function, assign ret to saved_err;

> [ ... skip 15 lines ... ]
> +	 * This could mean that no PCI FLB data was passed by the previous
> +	 * kernel, but it could also mean the previous kernel used a different
> +	 * compatibility string (i.e. a different ABI).
> +	 */
> +	if (ret == -ENOENT) {
> +		pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);

I would assume this is very normal, e.g., no devices were preserved but 
memfd+hugetlb was preserved. Maybe use pr_debug_once().

> +		return NULL;
> +	}
> +
> +	/*
> +	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
> +	 * but it cannot be retrieved.
> +	 */
> +	if (ret) {
> +		WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");

No need to print backtrace, please just print a warning:
pr_warn_once("Failed to retrieve incoming FLB data: %pe\n", ERR_PTR(ret));

> [ ... skip 34 lines ... ]
> +	 * through pci_liveupdate_finish(). This can happen if PCI core probes
> +	 * the same device multiple times, e.g. due to hotplug.
> +	 */
> +	if (!dev_ser->refcount) {
> +		pci_liveupdate_flb_put_incoming();
> +		return;

Pleaes use 'goto put_incoming'

> +	}
> +
> +	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
> +	dev->liveupdate.incoming = dev_ser;
> +
> +	/*
> +	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
> +	 * that dev->liveupdate.incoming does not get freed while it is in use.
> +	 */

How would that work? If finish is not called FLB stays around until the 
next reboot.

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

