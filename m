Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0003A60A2618
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fuTPRggN
Received: by kanga.kvack.org (Postfix)
	id F3AF96B05B1; Fri, 20 Nov 2026 09:44:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13156B05B3; Fri, 20 Nov 2026 09:44:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27EF6B05B5; Fri, 20 Nov 2026 09:44:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4C476B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:44:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 430D5C0F6A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:44:50 +0000 (UTC)
X-FDA: 85455769140.15.AB338A2
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 54F174000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:44:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fuTPRggN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795185888;
	b=pmQXAhhjpDEWZH32XvEFFs+f+fm0IsdLft4wKPWgGPGou9mqiEOrdV43XuVp9PZEmra6jW
	LVYQwIa8i4xBEpPeHbX2WJQTOELXL05bDKZeoH00X6UQStTp2jymUDjzxjdrY0rwrX9eaQ
	N6usKIGNMHANeQK/nXSON/6WtJ6D/Uo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795185888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAmEuVaLj2um1QYSHCqaR42KS0RtEEeYHE8D0ahDr3M=;
	b=aACFJZmHf9gE0yfQF9l/o7wioy89vShISRLv2v1BiFFyV54EJqkNLRQP8q802yEiS8BcOE
	GDfwgE9E+zidywvLGUv0DXKu9zUxwkCGTorG7bkC/4k2+PMAk0obnAwc+XDjkS440u3yoM
	v5dSWhenPd9lMBDaEDfgeRn4j15doq0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fuTPRggN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=praan@google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-533202fe429so308611cf.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795185887; x=1795790687; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UAmEuVaLj2um1QYSHCqaR42KS0RtEEeYHE8D0ahDr3M=;
        b=fuTPRggNY13e5VjTAGXrjS2Cdgb9PUn8nqKuiDgDPOLzTjOierlridZHUm1vBT0T7y
         X1KeCquPR6lzinahMjaY3IirtTXKF2BqXKSHtg9F2vTr+JeOim3hNpMMN3SrZzREKxmJ
         2d+tcD26E31pIOzOwJUuWKhZdBe0lA95JuYtn78A/fx5CxN58mgNcPXvpENsV9o2U0II
         5Pah4hH9VMqAUR3TmeBAh3oZ5prf5QipJTKtVic2OvS0nhkxzzu+ZoV+kWBATfobJxEZ
         SfNtoqvROu3z+9RBjVdcDSbNKxZTtQER/7/JS2WDMJXPjtgnrUw4WQhykYFhK6dnFgOr
         jMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185887; x=1795790687;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UAmEuVaLj2um1QYSHCqaR42KS0RtEEeYHE8D0ahDr3M=;
        b=vQPIwfemDBEI4z1Y2cUtcN47hbXic8uksCCKhOjDYbiXCaD2Y5LnXqW5IdOdZzhCd9
         Ax9samlD8F5bSh9DCx8V6y3YZZ3DfhtlQJkJmto2gTj8k4jlu7x5MfZUMFLA5Id4ZR0Z
         k0VLL18biLxiPmlvVddg3w9xq/KkgMDvhqLzoIMFn9Qpqz0Pnz9lYvdPQei9zhZ8oREZ
         CFZXTDd/o+YRGJBgnUS86D96/TqTS8cKESwojtKbPi56ZtiYoHinnQ/nafReRLqGmPdt
         CfKEKDUjwFw22M8ky3Jt2HzPIt6Cpk8cYaf3V8dnpnp0tBvqCw3ojWB/GyMeMGXTc2nP
         4zNw==
X-Forwarded-Encrypted: i=1; AL+hErHziUqYSKYEN3agbf30rCJNMqUtv62Sq1wjdk9ufMWgzpL8B0ElHLljxbKAOFsPv5vC4ASF9aR/9Q==@kvack.org
X-Gm-Message-State: APuU4Z/2657P6Ypapj22G8DR2ntnfsqXNdUmY8XM4mOrb3MQ51kfkS/s
	8mll0wm5CSDCw6mD1bP5otMBm/+DrGPhWjBHa4I+KszxIIdyFb/y1t1hXe+ueLLhGA==
X-Gm-Gg: AYBFou0RlTZyE2Mhz/mH+k/TB8I9/O5LznqcwpUy7WeBP7W08I0q94EEtgqePktrOVs
	LefY/uIMZ8ihE7Vxfg0G1qTVz6EtS90vSLvnA29JTInIdecUkTI2wroD3N/byaFikW2l5VRzAjD
	EF2+wt1SsecZhR29r0Shvb2xkxzwkdnQqizI1qTsuAeuME2SimHctBMRqI5RB3eIul+2ufyf5No
	ediSvUdivsnrYN4nPc0/ilPArAVprLVGdixMINr4FEpXaeS3bwIusVpq8Wav25nGFo9gMCSasNU
	Gu+InxCytgr+IgDLXfM1Cz/I4yfsHKjxFx2909IwNszFNsVNmNl5MUxgvKVcYrQ0nY+cZAMKsR4
	69VhjJpWQQxxh0DnN4Y23f8WL+3nblblyFBhCE+aSlGQJ4q+iNbgIaDFuIzcap5+IT9CXMfQnT1
	PLHxMF6wghDgIrzEB9Qjc+SVRFqpNqs7JD3ivXvD6pW5bvWh/R8/PiCxZYnRPBItGPXKA5uH+Pg
	VHtYvv89iVueOp7u8oiM3kRKlD+Oxk5kHdx+UiVE+IXFrV27tXGDY2WwT+jPwAb1t4/lM3lG2bo
	EhfJO9GYjMxdrRZ8j5hrWYouhj7fq3Wij1VUuKjjjX+jGper2kwlLGn1zM6pMsrimAFzxEZbAQ0
	DJmC9ODGyIFfp
X-Received: by 2002:a05:622a:2b07:b0:536:6ea4:e6a0 with SMTP id d75a77b69052e-55d7a35af5emr17844321cf.11.1795185886849;
        Fri, 20 Nov 2026 06:44:46 -0800 (PST)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028c80dsm14013017b3.13.2026.11.20.06.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:44:46 -0800 (PST)
Date: Fri, 20 Nov 2026 14:44:34 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v11 08/13] PCI: Save and restore the ACS Control register
 and Egress Control Vector
Message-ID: <awBc0m4oW9nW4hgX@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-9-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118223704.3286085-9-dmatlack@google.com>
X-Rspam-User:
X-Rspamd-Queue-Id: 54F174000A
X-Stat-Signature: pj7617cp4xg1p6pmb53pzeu8psx5ipyd
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795185888-271914
X-HE-Meta: U2FsdGVkX1/I83jPjhnj7YPImd1lghRJ4+yItaugdxP/+VWWWiWGzAGNc5PhOsgitIPGkeo6Ru7xbnO1d3++EAEhBwcb2wbTq3uK72VqGxDLchUan2IbQMZpAJYteLTT6oyX+zoipBlAHPPthuG+HRhz82mKsTTi4p5zL/wpfXsQjWz1O2ABn6HN8eXTeQIq9qmadgJ1e/X7WNA1C2T9sUAS/OSsUjTMUAvdOQLo1RCk218e5dOhQoHPeQ6ZWWS9lEu+Cdxd4LzKhV7gIT+Kgaw+3T02VYVMqmTsdxtzIPu+42KM3PCGcozxqa1PR/k58/N8LSMzImWIqLRRdnmxWdovj7Ubh6JkHzliKOX+dmQJ+KFKgMzGVYahh08DWoZ7KYpvuJ1R+qeDnwoiLfmS83+TcOPFSn1gNs5Thy9LCnQnVt0mQOJJJ0xkXx6BLIv4z/6tSE4gR9XhW4tIDKCH9aYrtY7Mhez4xoReiaPiK3TWCKZ4Mtb89dDLQqHVj+Z6YPjSCGvKv8PwatN8xHZ1ip+btAvhy5rh7G5Nleq4ac82e5ZeeCkW38EWAx5rVihjN/idOFiBePVyGWufoYhwqxigHYSHG8Dn0OrLDiII9stxucE3u8aWTZCzDpclPZEgtfs1eS1gOW7tb1GKYN00GvX8cuCEcIeW6YpTOWqrM11Qp77ZtwVS2H7w+0ovHxjUk4qgcokvC6P7AFYcGQWXvEBhujYQyaOumujd4fGJ7LKXpcoU7QKickXFYB/g61cwsrhRnQutUWi4t5bI4MSD5Hm/aSMMY9+0ZdnD0UBOA9GyKaigy+9v2YMPy9GRFNmkCS5hYrR8RTrOvJMPZ86KUFRH9dkxZ0/pAZYOA3ilJShhAD1MXRkR1l42ka7Dv4tjqQUAR+mtYdwbDhKSAFrubjw1IbRnCgCVfQcqTGSEcVBBBsf3EmXHDMc0uJaibdopA6sySvBuYrOrtr3OVlh
 FrZaS6V/
 8X+AQB20Qn9szBzGifRmakVuo3YQznNHQxgsOZKDWFTFnnD2mUZG4zEiqWc26G0y5yXgMC8wAusyUVQp9lChKXu9EE0ismB2IxKo+CEcXVMBO8uLwPNOM+Z+z1o506rDjld6ePYcYRUhkhYmJ7YPMvzXQOF19gh8IraWEnVw4R+Kbwyf+xTC6SvCWkc0D3dI/SHSLAJYZRcHpGyWTuevIWL9mHLphk++KdlTuQA/PVQrl8nvIhuL2RqBMrAIaRDVp9R9M7tuzqiunqmFyPjzLpRHW8CXDB6/VgyrUTPgp/q08ElqN78w2rMrlELj23ZRZOV6gsuUGsWhfM0kIM6EjSYXdlvUQaDZ9hq4OIiyhE7NBHhTGKXdQr0hDgmnUn3jsVRzsVKDuLnwDjbqDq1jdfZ/bKonKCglqMvbpXZXacPwNmvjtsnlSS8fJgdo+5iglsnZ4kvFw+wvj23puI2kNE6mnLvHJVc4SXPhgvesX5z2eM9GM1GCCeAEvv856OUKq1SORzI017/kEmxOe17vA1XHzUdazKtp/+IUloHZ0KXKy4xVyK/xdq1siaWqCKXgElb17sNYGhy4h9fi9743S3KN29YRUOAjiPSe+8b/w+6NPvFuDmJgvnymFCq/Ngg39+p0f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:36:59PM +0000, David Matlack wrote:
> Save the ACS Control register and the ACS Egress Control Vector in
> pci_save_state() and write them back in pci_restore_state(), instead of
> recomputing the ACS controls from scratch with pci_enable_acs().
> 
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
> 
> This also lets a later patch adopt the ACS controls established by a
> previous kernel across a Live Update rather than assigning new ones
> through pci_enable_acs().
> 
> Save and restore the Egress Control Vector as well to keep it in sync
> with the Egress Control Enable bit in the ACS Control register, which is
> now restored from saved state. The kernel never enables Egress Controls
> or programs the vector, but the firmware could have and they need to be
> kept in sync to avoid changing how P2P traffic is routed.
> 
> The Egress Control Vector Size is a HwInit field of the ACS Capability
> register (PCIe r7.1, sec 7.7.12.2), so read it directly from the device
> to size the save buffer in pci_allocate_cap_save_buffers(), similar to
> how the VC capability relies on its HwInit fields.
> 
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS state there as well, otherwise
> a subsequent reset would revert ACS back to the configuration left
> behind by firmware.
> 
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so don't
> allocate an ACS save buffer for them. Keep configuring ACS from scratch
> on restore for any device that has no saved ACS state.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Reviewed-by: Alex Williamson <alex.williamson@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

