Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9829C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A431E6B008C; Mon, 24 Aug 2026 09:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F40C6B0092; Mon, 24 Aug 2026 09:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2FE6B0095; Mon, 24 Aug 2026 09:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 691EA6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:42:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF4EB1A0111
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:42:02 +0000 (UTC)
X-FDA: 85136276484.01.791AE25
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1B04110000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:42:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tp6MMWCc;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787578921;
	b=7RwIDSJQZffoe/m+wtmdOgZ1gQGWh9FpvPXJeC+H3a0bmHyIhIAMDiq4DnnUcWNvHx5I4P
	fkIbgzHP5qSuOYmlJf/CG9x6cEd+mzugwQ3RINF7JQrq8KzKtbP5YgJnKMA3uITaHCN3Yd
	afl6x63a7u8mg5droxIrVIiq1v3kuX4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tp6MMWCc;
	spf=pass (imf05.hostedemail.com: domain of praan@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787578921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXklq75Z4X2qA44rayjTFnITvL4DP/DDkWPkbOCUBY0=;
	b=ZFSy3XguWV7lxqJxdN/ip0X36ffGvaeigv9kyfehyVOOVUCbnpZ86hcm966FCihpJ3o0yv
	OVml0uY8eRmjhQCzVaAZvN1rbiYMWZisM29uRC1s3TiYPzr6dSV4nkFzxHjzrA1pF7iBgU
	0ZUe/GigP5kNUeIBtkDIqYoDqyHIDhA=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d3b440b97aso155445ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 06:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787578920; x=1788183720; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MXklq75Z4X2qA44rayjTFnITvL4DP/DDkWPkbOCUBY0=;
        b=Tp6MMWCcAiDb31oYwI94KGXkfa6AUryTYts1LD35YAfdXL3Yb209mz/ncaX5k0ZT1N
         JoRJnl96Jcl/6InvXzcXLJxYwTtrayQhltLBs4LNAsIL46M8w1XMcP9mNtpW8OnXKFhP
         5476JTWdx1locHr1oFVI2UUHuebWSq8yvj6hhh96J1M9qL+Ucr2qpwmYv+jF1L7d0sAf
         VwxZ8UU609x/DHzzJG8pcyNrIZzZ82ba7Oh5pFYY5RMnP749yRTzraBUzBBRdV+EixPU
         sTpaKFP36wp1QFV7aSE+6XCFrT1NoNTk8xpN4KJimfbYArJrLFuCwM2FQP9uEpT53mdm
         jqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787578920; x=1788183720;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MXklq75Z4X2qA44rayjTFnITvL4DP/DDkWPkbOCUBY0=;
        b=Bdmt08PMk5QDq+3knFx4URIExlXxFQqk2NOcqxyVk/hIYuGV4IZL1exeJxwUjC/W3E
         VRX4BSrsWkNv/JK69a51buXhmsDlbLdPinG2zVFi2OqlT9QX90YNvkCzkwAYFDLbrK1i
         Xwh5z0jLmqJIrNT5XjI5rlJVQMlalWafdYJHPpzYar0e+9mMT8bRZ/eo5PPKuln1pWjn
         2HEOgRVghzu4dZmywI6YoLDNBkEYyL6Aj6qNMDHtQzueFU+Rvds6gf5PCTqotnzQLg3B
         OpmbQOGZdkHjWLZRMc9lPVQ9Em9DDuKgj7AEi42eRNIxIn3vdj9foWMd6R7LDVKaYUhi
         NLow==
X-Forwarded-Encrypted: i=1; AHgh+Rp9CBrvsocO2wMScQ/Zw8Nb4+HlmXNvGecIyCSdbcwP/GDQ6BkU+pVVJ/7d+tYpcaBw6F9cnhycXw==@kvack.org
X-Gm-Message-State: AFuF++mBPiSIEKpxhbl2ekFwigqg83hs4pnxl65lrT21zfbwIV+MklaA
	DFaWyuUneIftA+06kvCfnnQlddeSb7D9tN+4xWxtulNPU4kyV7D2ECksz+JV0wkgRA==
X-Gm-Gg: AR+sD12sfzmv+UIlCGuWK4pwU63cgwN8aIYovbjDeus66vWNz1tykJi2e8tBd5SiERc
	EAkOjn+npbxOiN2iLFSoL/rdUgIU4tpwXRUKS435QL2/WVVmUP5YhlVQaSQghCVw8WlCTzyUriu
	1s18GwY5ZPbQOYj+W8XUoBvbB+tiifNLushjk45QoPTPKLd5HKMGqDccmmuVYiYPDzHRcMN2CJp
	Jj96Jp+ULMg5gXlXwAxzOXDRNa5AP7djlsQ/aVrdaZ029vXaLwn0egEKOIRhqrdsVS0UDRAWXSF
	FZc+xuvDnQ5KmVfjxQqoYadVexsP3W6RwNrZpy7dWBL7FdBsptGnrtc7XDv5J8gwGRoflhZ7r3R
	U4dnKgdk15y/4O1lNAMUVKWMFZiZhPi3r7K6TQR699Wm30XdGVjM8sZJVXEck5OZeonEZt0X1Aj
	FZ7Ox/Da/aOMVjbzM0zwAwXSML2U4T8ZR6JnLiPlnV70Hy9aTCClKmvCYKQEzxOfhlxSwQGA7dd
	J+PwpyOP2mF9IhRuS+UrMjsoQ==
X-Received: by 2002:a17:903:1b4e:b0:2ca:cbe5:c3af with SMTP id d9443c01a7336-2d673b9e9ccmr8380625ad.7.1787578919029;
        Mon, 24 Aug 2026 06:41:59 -0700 (PDT)
Received: from google.com (164.210.142.34.bc.googleusercontent.com. [34.142.210.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d676761c35sm18347475ad.15.2026.08.24.06.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 06:41:58 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:41:50 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
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
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 06/12] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
Message-ID: <aoxKHh_zLBb5vhzY@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-7-dmatlack@google.com>
X-Rspamd-Queue-Id: 1B04110000C
X-Rspam-User: 
X-Stat-Signature: 5zmbumq9rrs4ktudx8y4zi3paok1a51c
X-Rspamd-Server: rspam06
X-HE-Tag: 1787578920-263851
X-HE-Meta: U2FsdGVkX18ZICYQHxI2dpSQGOP1L8uTUMK136fdf+71BAbDxeOtJ9n7lRSNXrGpCW00U3irWVc+mM09mPPq6eG+TqWrZV/q8DBTfFnNkt336v6Gm+mw/GMOZiumtLmXJaa0R7vihEQtAdpDwlNRLN09VGvHv831bHkK02Vy62vg8lBf6tm91ZKL0qO/b4WrmaczHnYu1zPxrnVh+2lvEON94MxZIQoQNj3jGCGEPKbw32qPs9lxn8u+o/2a0837A5sQVA4etAqwBXZKODR7z4VGoYdP9DmoH8MBwm11DHdhBlhtx4yN41UWssEhsmCI6GT4HRqnVvRdVnDh9tvjQefhx7tLbGB6cFD+16/wa6Quwhuyiya84pZLDDraqmqJ/v8motEk5mq0dgxSwtlXU3yUMNuHUKJrmf1O9RLuF0nd/l3T2oKItqX0v5q+hEoPiX5Fr5wo9nK2qoZoMVbkC1Ho92K43yoXc9n/x/gVAmBTyK0VZPUGoZwUEvp/Y/Ok26vcQv7W8Kx1QnG+DPB4pWSedXxHWDE2/gBg5wf4YVY1yfbZqjlhK2tfO1uREZqd/BajkAG0Wqo5GY/kS9zZdk5rJAYktK7u8mKIMchu/wVCVnbDmhjDKINKR1CwHWh+UiCHyQR0JXKYWWXEPXxrd6V4qqKicjdxkQ1lLvIFIiQ99CtH8lzakYlw6GyahMNi6Uf2bgPGYl+I5MBCOMrcCW8Fz9LZzqM+qeBGZz7XkquMK9Q0XScnfmvuR9BPxsGNSSPalMEUlfBWAcVKmGKxntFX8tn3+kiq3t82VjCsPYvdRSQKPSoXrGydMLMX3VoUJGvcLF0ytcvhG1gwiNhCcnYqwORFsJBbHcRj1hbg/Ww2z+PkGNjHna6xsNKzlUCjubGAOa5WLnODi8l6IP6ZQwnAlAMYJS9JpnkyxOqJlJyAwjJjyF3HxtVT+UT53l0kDi6h5Nq7PzXsgwxHj6q
 CRhYQjgk
 BIQFbfgdxDaJKRH1O2hcXM6mk/XH/bydf6O85YzPJBMbPiPK6QimSZ7+6zkniVqLtLxmFHdwuT08ea75yRDB0um9ywCdn4r4sFsbqDFtjYYs623tzSLM7rsr4uFIWMPSXkTcIxq4R67ScYEi2D2ugZMklJS07vzQignpbH3gBcbUjx9vyRLmT4g1zY79iKvM6L991OYBIt3m9H0pUecJtvp2yt8viK5m3qBPwJtOKY2dFiUw2U88ghy09ChdACuinyGp7J3nLclFrZQqh75Brh7B5QDaq5jT5Z9KDUmwY2fTUg9N6kT7QYnUM4NfDdzaJCQfkGVEAYPT+oC7YZy3JbRClSh27Omv3aYHMgo7cj8PK6tbRd97tinV5RG2X4bDyyvHxO0Rqu6wpsEP1hqjDnsL+FdfqJTU1EdyZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:00PM +0000, David Matlack wrote:
> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
> 
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
> 
> To preserve bridges, the PCI core tracks the number of downstream
> devices preserved under each bridge using a reference count in struct
> pci_dev_ser. This allows a bridge to remain preserved until all its
> downstream preserved devices are unpreserved or finish their
> participation in the Live Update.
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

