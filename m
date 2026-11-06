Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719F2606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1119sdt
Received: by kanga.kvack.org (Postfix)
	id 5FFD66B05BC; Fri,  6 Nov 2026 11:54:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D64D6B05BD; Fri,  6 Nov 2026 11:54:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514A96B05BE; Fri,  6 Nov 2026 11:54:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3032E6B05BC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:54:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACFCB80166
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:54:09 +0000 (UTC)
X-FDA: 85405291818.03.B3880EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0DE8310000D
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:54:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1119sdt;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793984048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=nXkPku4ECf8+FOGTi2fh40tjvx3x65bjc12ogntMkA4=;
	b=myJfNexEjTOWiGr5FII2/vOIavelvIMNFh5qJLOmCdpdJ9H+G6VOSenyUgdVSyxzOWwvNo
	kRZZmJVflSp0guGnkKA70Z8jLyOXM5++UBOODD85gG+mW7b+HY3qdbCt/FSuO/XOKVqG6I
	SIOS+W/MlS5u4p5oLLlihNSU/yXjHGU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793984048;
	b=or61xcSRMFOr9kd45MFHxiCnxUpuBgXdGGO0oI29pnvVcxw5Xee+c5CWHJn0e614Yy2Qh9
	7U28RCnSKl07xXbKwNSnUbOUOm4SrvqUN7u4ZxBAzj2e/MJ7wXoFIrG7mcSkvaavprtTTJ
	3iEB2URk1ZXDi/RhFoeGqVmxUDKMfHo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1119sdt;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F30140B87;
	Fri,  6 Nov 2026 16:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091041F0089F;
	Fri,  6 Nov 2026 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793984047;
	bh=nXkPku4ECf8+FOGTi2fh40tjvx3x65bjc12ogntMkA4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=i1119sdtyhZsM8PknNa5avXoFmwzuiIke35BTEuBCbNCWkS1ohvh7y+6wQBsbEoEZ
	 eQN9eAW3mlCLhMojmvKcjCddRof0kSNMlSGm0Nxzci1Wz1Evx5ClpIWyVGUnTgxZAy
	 +RSLh79efseypAACmsCIdx3vtldAar2qEpK0SL2kAmGE3DoZM26Dg4q+wniBl2mlEl
	 U47AsA8uBcLZZXF6M060ruX673Yl4gxPbYsXSophDui+G3AlB/dInW2YmwLlO1rnAu
	 9DhP0Jo9QGK10F23c77M9ZwltzFkGUnsvcnC4rTSQz74vN0pSFcjjlTUzxiLdd8CLt
	 k4vobAlpOj4xw==
Date: Fri, 6 Nov 2026 10:54:06 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 04/13] PCI: liveupdate: Document driver binding
 responsibilities
Message-ID: <20261106165406.GA1632826@bhelgaas>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013162529.1928093-5-dmatlack@google.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 567b3if35bmeaxysmy8syud1yfznzqwf
X-Rspamd-Queue-Id: 0DE8310000D
X-Rspam-User: 
X-HE-Tag: 1793984047-964345
X-HE-Meta: U2FsdGVkX1884JTLF63rqlB8IRrzHLVjIcS53wVgwXYqc1Dp2m9MVkrr3HjnazHttGvlcBN98olhWzUqa2XaBP5a45o/6JTOT0027p8GcWjp96RgdkohrXfXlheI85U28jVQ7kPtHyMJXBst4eRFxPNSbOQt63qFNqFr811DS0K7CpuhNGNITXIy+2JS/gUqeL3bnswgcnv2N32fsfQ1h3faxHNJKAQyvRLMOntYmzGpk233qWN4wgefRIT7zqwIYXsED63dWZV+IvnMaYVfo2DqH+4tAcobL1SRCPh7Z2uFcjqOwfHDSevVuJWEuvLj+3bUvjUMpDAWuMrP+EaSE/dZ+dnto3S3N4okBSZdJeM7NMWyrCgvOupRNzvNcv4XFNaEYVEiftiFepyOre8/XfPZqUZJbGKA/lakQgydrF0+qSuWL901hTIcRaPKccdDBGaVdISDt6duuLGBfZybIfBXCT9622v66BFLHzAFiAz/Uuiq3th+IrOJuydNeupwnYaOVKhcSPdpaN9CT5hNOvfW4xNHbXoT5ST0Tkno7VeLShvVs5yI1dSat9exslYG+nwBoqswv7+lz522q7qd9yCuPNVJ7Rfq35qQjwvb9rWWxmyBOMGnzBf5JgN+fRNImqJ5wq+ursuOpyttpY//DZH+3C/6apDQM4kiJ5Pps3OPUX4ztgXkUG47O7x8t/JmKSXO89VYB5gumRbzeLx3KRTmEWNusrQ/AOiIItsLTBT39gquc9TL3GK6HtgaOPooaB8foADhlwFb02+jCSSNsRYtWqaPe3x+HVeQoUnlYa+BzxhwCkF0Hu3Vzgy1cZleSWIBnNoU/gBOM66XxE+xR6fQAYcWDWK2QrhbMZDX5jAVKy+6Rba5l/F5KkkGcBtwtfmjjK5iDTf0bP6Soi3fpHRdwjceaiftkiEpm88gg7bv7roeCKLftyK3aQomrE1uWQ7GyrA/2Wxf/sAGYuB
 +kpqBg3U
 PWy4KMmnTCTeubVjnw8Z8LNer8FrnQAvIG/LdfaYREz3E4eZdRdACbSE+6y3eaGwv2eJOSAR7nKYvmx6WtA+xzyoF9W3a2y6le+7Vdqdd31Ln/NX3R99iqMRb+Y/WG3yJmimIctqDtgt7kHdKIkAT7ooZcE9DxdH1O8fFmTJRZ7nNE01wACU8FZMA+yctIzaJzuqnSaeEHqjbqhkH8E+UZxfR1U4zBOgmB1ZF2gRBk+mvn0xFUcJlqyc2kJtikQIJ+m+dcc78tkj3wnRQvuYSrZOGbZFXIIVQr8Nrga8WH5GxYolPMHnTFaHePO8a4iJBSxHm0ACefVVIP+ri6lAvtww3KcuQwASiwrfFv7XWocGbghY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 04:25:20PM +0000, David Matlack wrote:
> Document how driver binding works during a Live Update and what the PCI
> core expects of drivers and users. Note that this is only a description
> of the current division of responsibilities. These can change in the
> future if we decide.
> 
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/liveupdate.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> index a1d9b2b1f9e3..d6b659b346bb 100644
> --- a/drivers/pci/liveupdate.c
> +++ b/drivers/pci/liveupdate.c
> @@ -123,6 +123,20 @@
>   *
>   *  * The device cannot be a Virtual Function (VF).
>   *  * The device cannot be behind a PCI-to-PCI bridge.
> + *
> + * Driver Binding
> + * ==============
> + *
> + * In the outgoing kernel, the driver must ensure that it does not release a
> + * device between pci_liveupdate_preserve() and pci_liveupdate_unpreserve().
> + *
> + * In the incoming kernel, the driver must ensure that it does not release a
> + * preserved device between probe() and pci_liveupdate_finish().
> + *
> + * It is the user's responsibility to ensure that incoming preserved devices are
> + * bound to the correct driver. The PCI core does not protect against a device
> + * getting preserved by driver A in the outgoing kernel and then getting bound
> + * to driver B in the incoming kernel.
>   */
>  
>  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> -- 
> 2.56.0.385.gd3acb90ef8-goog
> 

