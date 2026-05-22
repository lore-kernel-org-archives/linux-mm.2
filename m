Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AAC1CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4B36B0093; Fri, 22 May 2026 13:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BC7B6B0095; Fri, 22 May 2026 13:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9166B0096; Fri, 22 May 2026 13:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEE76B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:59:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1D84914B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:59:08 +0000 (UTC)
X-FDA: 84795817176.27.8DF1EE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4392340005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:59:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/lF87yY";
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779472747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=QvhytzGMgy3nE/I3M4lZRHo1Fz4WHKJA8K2mHNM+zQY=;
	b=n7fnTYq8HhYr6jRXHIcBVY0OkaYWmtfjLcW7WOUHesSLLRhVsfOeKq6JBrQL3Aq7qg2e/B
	3CIAxUeW8nR7zuk+k9jIFdZkTtOyk8/GG2VdEeLXePKQCVgSN66nJitRoGfqMZhHxxCYYq
	b/aL3wyeParFr2pNFWDRmZzk2VTh09c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779472747; a=rsa-sha256;
	cv=none;
	b=kFz/AupnUZhA5n2yDOgOv36mC7LvgtfKKdN0WnG06ZU22bLSEAc/RbII9z4QqtbTa5yun1
	BJRyuhhsoO8go2HIahsgF6OKV2FgT0kcRhe7Axoa+tVMt+kfYM0SUIs2jxJGQZ+/FnW31T
	+5+arxxPl93jbV8V5vRIL+NH43Rtb74=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="R/lF87yY";
	spf=pass (imf11.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 6A2A140D81;
	Fri, 22 May 2026 17:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 23DC41F000E9;
	Fri, 22 May 2026 17:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779472746;
	bh=QvhytzGMgy3nE/I3M4lZRHo1Fz4WHKJA8K2mHNM+zQY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=R/lF87yYK3T8ZgihOcJLjT1tJ2iqucYpoTXz+lE+iNM8GsdPFgTHohAXTIRWiXCaq
	 Z3sLJcXDGLxdXpbjd5vXsU6R9vl67LHiffd1HrCgb9F7RXCuMOOfdz7pnSMbp79xKx
	 bqeV2FB/iwmC+djHEZ5mqJS5Do9oSrdFTfzKqDljYArEUikYmdVLSGNtDVRe2CbZXe
	 nSlHxZCLg/t15FV7B3ebQdjPPEJOXYtquDgAXX27hU8eVFNYP8lGHAlA4FwFKLJOmb
	 9sPWoEQ7WIovdqVHFNJR3cl90/fD+OjTmJ5s3ncJReREDo+cltiTIVjISJ3mzjWVrW
	 j+eMJNK+bTxAw==
Date: Fri, 22 May 2026 12:59:05 -0500
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
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v5 05/11] PCI: liveupdate: Keep bus numbers constant
 during Live Update
Message-ID: <20260522175905.GA232400@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512184846.119396-6-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: 19mmpyixfpph7gaq46o43pa71dtbbi55
X-Rspamd-Queue-Id: 4392340005
X-Rspam-User: 
X-HE-Tag: 1779472747-663894
X-HE-Meta: U2FsdGVkX19oPP1z77xPfsbs0Kyn3+eMie90OCXgDMJ/FtjTtl+oB3fVh7rOhp1ukrLI2x2zxnDeLBDX1WUWo/N1aFp/o2+I4zsIA+lwBx8n35PJIYYscjiO/UccpD5VyvYZ3ciabZ/HCiSHsQXLmuciRAgn9iisValwLzDS5IcwABsMsiQ1NNu1lNJQIe0gBiX3nap4lBgFaiBFUy49mZW8eEm8KQLTM48nEqLqHyYu4DMyvhazIdFHwjsZ2R9h2oOgjv/M/ePEDZsf82BzGiC9Kywh/2pD64NRCofIFEC5iOvtwUa+bh/MZnqX+Ud6wpc1DiXOE/H0IbHe7U6H9CIW0yt+LBCBqariOkpgmRyqEdqKEqWtDob5lsb3HBDcdYfg8JrE5/YPa44DQGCJRshgJiGPLprsOXz4WDeU7fIWkYN4OgiEox33TgvjYsVlSIRPKEACDGQMQIkepbiov9Wuej55vDqN9JSEEkqnG5gTOj/JpfTN+8tNQWeqzjPRJ5n6ywYdMcTirw4Prti4JiuZHyfgIlukQE65QLSTs9ukAB7B7rspV79/La3Npi8aD1dcJdjBrx0l+dmOktJBC46oriAf2qM3KNJCiuX2F5ALn60E0HYhiAgr3DkcaPHUolfFSw99uMgkZ+XUf8z3r9PwupjToiG/ySTIa2E7KoDsaPdQkoB2RN9MFk3wHTcZgKO1alGjdWwqXegQQo9Id7OJJqVrmu9T755zTmlD58BiQ7W6DJDGcdbO7pnhdNoMbbuXT+lRxvB/5SKa+GXv5xQL0B6xPrUb3q1j5H1XNgQ819IuYEoZzzgtpzEKlyJ0le6GuMkCEU76fnbkhoh11qDsygfPMM4VVQiRtRz1A1PrmmeCpEdOId86ie58lm5HyMGHderv354IJFMXgNpzrQo0WDK+MS7nO1PajctYzmW2k643RkSsJbmAMSShWCFvmgaRvnOzKNHGikS2a4s
 wUPYJ/KO
 UIIQUJ2z0xtni/8AUNZKX/Gas/hJ85ZaH2g1KWBDv+APQHSw7q1DkPbPljTHGWIE7VibnAbtasf18Od1dzsUnTwifdIr6OuEJuXzDXwnb0klyqdS2D0b5OSUWhuE2QYgHz3HuX+sB7WyHGTeOOuH/zknf3E5kB6cv+0938pf93Qb6mKCjPhq8lkTvGqp1DTPAlivtGCvU/I9so7i4sjlBUznSww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 06:48:40PM +0000, David Matlack wrote:
> ...

> + * The PCI core guarantees that preserved devices can be identified by the same
> + * bus, device, and function numbers for as long as they are preserved
> + * (including across kexec). To accomplish this, the PCI core always inherits
> + * the secondary and subordinate bus numbers assigned to bridges during scanning
> + * if any device is preserved. This is true even on architectures that always
> + * assign new bus numbers during scanning. The kernel assumes the previous
> + * kernel established a sane bus topology across kexec.
> + *
> + * If a misconfigured or unconfigured bridge is encountered during enumeration
> + * while there are preserved devices, itss secondary and subordinate bus numbers
> + * will be cleared and devices below it will not be enumerated.

s/itss/its/

> + * To keep things simple, inherit the secondary and subordinate bus numbers on
> + * _all_ bridges if _any_ PCI devices are preserved (i.e.  even bridges without
> + * any downstream endpoints that were preserved).  This avoids accidentally
> + * assigning a bridge a new window that overlaps with a preserved device that is
> + * downstream of a different bridge.

s/i.e.  even/i.e. even/ (remove extra space)

