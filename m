Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA8AFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980126B0005; Tue, 28 Apr 2026 16:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FE46B008A; Tue, 28 Apr 2026 16:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EBF6B008C; Tue, 28 Apr 2026 16:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7030A6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:20:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B1351A0401
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:20:34 +0000 (UTC)
X-FDA: 84709082388.10.03F7DED
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37AB640012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:20:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lk52Blsw;
	spf=pass (imf11.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777407632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaR4AuPDQzq9MeZ+Bqr1j2DtvJljfw3TYQa7ZG83Cs8=;
	b=KfjAqHKCbB1b8FNJUhPfIRULJHAcJDjqKVYHU/zs7l6YXHl+VYPXzxNFuefZjt8JPrsagv
	3uKvhRqH/C1hVsjMth1YynL02PMa8znuxfHaGU7YapMP9BgulZzmTGLXjjdrnbM0wm9qgn
	OwjILW60qRM/aDacN0Z/r3PQRyyUcWU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lk52Blsw;
	spf=pass (imf11.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777407632; a=rsa-sha256;
	cv=none;
	b=ardB3hCfEWwGmtHPfsmsaj9MuwJXZMc0NKhxI+LUGizBUleXL22a22dqi5IuFFRpdoaJLF
	52Z4y0irtyhAeJl+q+lVWi8nuHdbDlRex4Zc78l7Rx6LjEmVEWunpRizHXVjpw7mya0cRD
	zsUoo1ENUsMztOlmkWAoA1wiSY+apFg=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b243198058so13985ad.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777407631; x=1778012431; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MaR4AuPDQzq9MeZ+Bqr1j2DtvJljfw3TYQa7ZG83Cs8=;
        b=Lk52BlswyhxSeS9DLDIlsAUVKIjFYXl80WMdOt5eQMlQQB8BTxqT1/F9L+t1pQKQ3q
         goUnOVbumpXjad+GQ1rH6AygkR4fZeBiLI7mJX79mt1a/JVXbclD/WzYzEe0sDYhWSUQ
         hP2d0sS7CBda/ADK3xwSGdUxtvkP9gc8hZkJ5uaQ3USYUxZzQEKFbMHrEjMXLf8QztUO
         u2a+NmyFUJLrwDNJwyZ45D+EMfo2Ai8Ww5stRUDqCpdchQulOlJK+WJOGGzIpmREvuOT
         5p/sNMP2OIfj51J7Az2EQ7yRoFECU3xcMrOQZku4KoEcqv7pVEXuJe4uRCAwjpwb3RPP
         jUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777407631; x=1778012431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MaR4AuPDQzq9MeZ+Bqr1j2DtvJljfw3TYQa7ZG83Cs8=;
        b=s9J0IDl4HKDUMRsxOS9vHotkD5rV2j5a8rMDUxJDbdlQ7sQsin8KNKtQTI/KvhfwnE
         MxQN5dFwfDXARnY/UCnI0h+JGCNeupdGUbARLdr0TLERpijBuoUSLHZjimfOEGqRx34s
         jja2QJ9bKA4TDCPZVv3vaPx0jgraNv/aqFjGglHJaW0ZrSP1K4tAUtEaUziLtzyXGI7b
         1d8XQ22ZurUdcieBqItk4+5l3v7lUQE78Z3ErkkIb91g40GsOx5iFNjkApZ3iFUwIk3O
         sRpq0PbrhNxTV+6740QhD8Tghoh5wPlzZDvzBEL72I6yS2oRMLgJ1EI4Qabwboz6bVbZ
         nSmA==
X-Forwarded-Encrypted: i=1; AFNElJ/+W0vRW7KO0tNFI5XDB+crQWqO4wx7B4dESbQ3xJ7Pa7lgtw/HdVEFROQJU3OnL1sr83IORobLyQ==@kvack.org
X-Gm-Message-State: AOJu0YzliOjlNf6gX0bansbhNKrjcnPGClkOuD/I8fwoBDeyAyx4jk/S
	jWn0zJzZLSxjGGec6m3lT7ng0z/s0Gsn1YCYJ24YvnlWNDHWpy8XDOz7druSnJY3hQ==
X-Gm-Gg: AeBDietEoFFU5ZWTOOuO1a3C8rIDRvEtSa6Dnp8G3F1y4h+WnoQ2x5Lt89oVDeErIxd
	kmanc+WY7jPeB13+ejVvts9Nha3VpUZMKn8pSQ6YoTovDtbhv8nrsd9otSScdhlH89OtNCPHuqs
	mGgEHg9mCtNHFOqfuwGIILeQroNAWAn9v6/d6+rmYRYM/U4jDFSYBtO7WMXW9nhacLznzaQKIO/
	mB/3J+PXURXKjkPcdgfveg8nl5YSla0jmdNmZ20qHxA5zAHJJtmlqeg5hdcuMB4COjrGt+Sh0py
	30T0/XMdakLxDb1YL8Z92kkDxR0rLIh072VETsJ7upY5d1VpmYEtk0b6Yg9cNTi+a7qEjWdqqwH
	OCQ83nes8+0d+1AZOqiaJ7ZX+c/cTHanYkrUyCobqN8XUZYNyqdv3DKSAWMygGG1cRtg2Ro2k3b
	T1vao1Gjj5FIbow8sJTxoYYKibVc3ufgwaLsXWoJ26PK+f/ahVgnajbR/H8imkEQsU+kZeRH9Qm
	LPtr60=
X-Received: by 2002:a17:902:db0e:b0:2b4:60e6:44bc with SMTP id d9443c01a7336-2b988e32430mr88155ad.13.1777407630352;
        Tue, 28 Apr 2026 13:20:30 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834dae00d13sm3520508b3a.8.2026.04.28.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 13:20:29 -0700 (PDT)
Date: Tue, 28 Apr 2026 13:20:25 -0700
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <20260428201231.GA3885809.vipinsh@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423212316.3431746-3-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 37AB640012
X-Stat-Signature: ed8btuxjmgs9jhjigem9tow94q56m8cy
X-HE-Tag: 1777407631-394005
X-HE-Meta: U2FsdGVkX1/yvqBvRPXjepFaTNxKSGT23mYkClUnqX2pXqWgpuzC7Um95bjZsia7MmiMcuIfQsd0OmlSoXCsQF6tj/2hkamIuuvXYiP893bvkzPKm6Ju/c9esTsWdCB1Gp0aE8EnHTzFsV3SDQljcsGYroZzZMtoRUynjNB+cHDeV3cRf0YGEwZdMITeeVUvSnpAINKKT5m9fxAAZ0pMbUdpuQpk+g+XPlswkgP3+oHiaN61rtKpwssfBI3xLCpmGAdL0HNpjUWFbBkTqmi6e5D9gYozH/33tEb5Fy7rP+QKorR3/v+ZTq3woDlJxDP3HR3gvnm34ZcWoT9TG+lrjmlhbeWQxmfacx6mhg1p2HtQgA0yXDlex1McchNqN+DbFnw+5W8V/SlOVhx36i+GqhhpUsfiYkBRkOjxu19hqiVZJL+2SKkm+e99fISoX77yTYKGXAGLybix9dcxABJwkTtQjHVq+ZSLKKk4Aw6Vo+eDVG8epj2WaNMPaJ5uUR3W//3VV0KKqBeqBXHJE2Mgtd8lO4urV19zpSskf8owLcs90rQV4hFz7l0gv8LOX1oEIcT/oeov1caVqPILVUlI7eObM7vxs4yoYhQZshKDe9weEWy8CahzGbetQlLNmt483e2zcQE1+MIrz/TdWhsNEPuq3kI5c7fHMRdk/DDwq5DHFwZzp80n9j6rhu6s+dQ+lKhT19kf4a6SjlRNUskmba0Gq7A/lZ5SfSzadsdK5TztjQrShbYfTFgDQ5Gwb/anIxEKSWxgW1tifVG/s4TiXDFwA1FI0s3gkx5PDVpzg3smgE8k3/U/QW4bsPCi4LNjM39gS1XVsO51t7h+ZVME/S8Gvc2Nmx0apiD1oVOe1eLS3ih/knJ8/x6qqgWAfQeaASJ6Uy+/VR9FID8e67jJFfuODueFBbuNKRkcyrjIUpCcbhmetsX4LU2ikXqDFXQwPlavwgBHYYWee+8tIag
 tjulZMW3
 KR9zANaD6xp4H5+uLPyaEv76oR2jMdO8N62v3KA8ScEYyWn47OHARRbIvrWHH/0UGfRlwaR8xkv1t3XIXuvyCfM9OVnLCpyzKALo1YT4DfbmnSPjNtHzQiGeK1dNfwf5SCBMqb+gZCwfdcOPDtcSZ6c+mS8Q+8VEh7NEblz88YaY5hIqf3Nj+Si/NHlRGhJARi8uPktV9x8ktgXxSdvT3/IdNjo1MmQ5JqYarAUvnVaz0O1hPqiUGbh6Run7NdzjMpS7CTwBPKECve7Asqidicenz23iz/9Ph1yWwkMxH3Ukytvni6D5gVQWmbgcPPPKiAOEUvTDi0OJq+juIMAJAfXy7HdRf+paAY/qUqIXv2tiAoIY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> +int pci_liveupdate_preserve(struct pci_dev *dev)
> +{
> +	struct pci_ser *ser;
> +	int i, ret;
> +
> +	guard(mutex)(&pci_flb_outgoing_lock);
> +
> +	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&ser);
> +	if (ret)
> +		return ret;
> +
> +	if (!ser)
> +		return -ENOENT;
> +
> +	if (dev->is_virtfn)
> +		return -EINVAL;
> +
> +	if (dev->liveupdate_outgoing)
> +		return -EBUSY;
> +
> +	if (ser->nr_devices == ser->max_nr_devices)
> +		return -ENOSPC;
> +
> +	for (i = 0; i < ser->max_nr_devices; i++) {
> +		/*
> +		 * Start searching at index ser->nr_devices. This should result
> +		 * in a constant time search under expected conditions (devices
> +		 * are not getting unpreserved).
> +		 */
> +		int index = (ser->nr_devices + i) % ser->max_nr_devices;
> +		struct pci_dev_ser *dev_ser = &ser->devices[index];
> +
> +		if (dev_ser->refcount)
> +			continue;
> +
> +		pci_info(dev, "Device will be preserved across next Live Update\n");
> +		ser->nr_devices++;
> +
> +		dev_ser->domain = pci_domain_nr(dev->bus);
> +		dev_ser->bdf = pci_dev_id(dev);
> +		dev_ser->refcount = 1;
> +
> +		dev->liveupdate_outgoing = dev_ser;
> +		return 0;
> +	}
> +
> +	return -ENOSPC;

Since it is executing under a mutex, and we already failed
'if (ser->nr_devices == ser->max_nr_devices) check above, will we ever reach
here and return -ENOSPC?

> diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> index 5c0e92588c00..5b4c8d9e462c 100644
> --- a/include/linux/kho/abi/pci.h
> +++ b/include/linux/kho/abi/pci.h
> @@ -23,19 +23,20 @@
>   * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE string.
>   */
>  
> -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"

Just curious, why did we change the version here? It's not like just
previous patch is working enough to perform a live update. As the config
is experimental, can't we just keep it PCI-v1 for the whole series?

> 

