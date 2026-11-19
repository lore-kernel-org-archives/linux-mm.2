Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F84606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OoFAuLBL
Received: by kanga.kvack.org (Postfix)
	id 4A1366B05E4; Thu, 19 Nov 2026 06:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4788E6B060E; Thu, 19 Nov 2026 06:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369696B060F; Thu, 19 Nov 2026 06:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13E416B05E4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:17:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 143DB1C4481
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:17:23 +0000 (UTC)
X-FDA: 85451617566.03.4F517C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E7A61C0006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:17:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoFAuLBL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AobPWOfmzE3HwwF/Li0VAD7XrzGxn/GVq4nxLwzb/JE=;
	b=6zf8lrDooxB4BgW93lfzSpKz23pPpvIDWTmn/EkQedKZ3cauCXLTlfRC5KSOokCUQK8qYk
	Obtis/1wqewyvKERh4P1H3QW4GgvIIQep/Y3lfSQi42iawDT0Pgh8q7OqQYMEcHontSDTs
	ci/TsE5zsCj4AvamkKF6+IP+Ibq/Nsc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoFAuLBL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087041;
	b=e9IbfOrFuvDT3dJ0WugpbGpVgPCZBzoUkO8uJvmyrBPCWDVsOhljM1Ky5rGcT2PzBotzBu
	ox1zP6t8JzG2uSMM2nsV71actA30B6fRCXm+oTTnwx9AA3G7wj9dXEYVGC6rfcr61apRoU
	zIfnEac/AdrQw27cHP5I74fY8AnpbTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED9E36329A;
	Thu, 19 Nov 2026 11:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1D71F000C4;
	Thu, 19 Nov 2026 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795087040;
	bh=AobPWOfmzE3HwwF/Li0VAD7XrzGxn/GVq4nxLwzb/JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OoFAuLBLyrbCp46UN1DqjdfvdaUEF6buOWWn7dJXM5u7SBuptSdSeSEjIjPSlto36
	 ep6RVRQdAMkHPSbyStWx34/QptijWC/8sp6xbkMGTPj1iECx/8xExZdYtnFhSe0MdO
	 D4B5NwVRjNWBrHvndeCdJvat6B4dl2QB12Qvu3ewQF73QtGI1vamPYZg+pn7BXRvbA
	 KiML+OE5AiVdQDol/CqPlM4uKF4BI3gOaTddebE3minv2yBivpknT8m3rQWoj8kGw5
	 6cvAOO2zzwTspWVc0dBTqi5QR73Yb7ZdeHf/ClDE9ZhZCnLKHpF3VFrzsEnpSLCJTH
	 274YR2125V8pQ==
From: Mike Rapoport <rppt@kernel.org>
To: kexec@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	David Matlack <dmatlack@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Chris Down <chris@chrisdown.name>,
	Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>,
	William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v11 00/13] PCI: liveupdate: PCI core support for Live Update
Date: Thu, 19 Nov 2026 13:17:06 +0200
Message-ID: <179508650609.356641.3313376675131770414.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E7A61C0006
X-Stat-Signature: cbw43o4yxiehasiq77frtzj58qcgdthu
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795087041-273106
X-HE-Meta: U2FsdGVkX19jyFxuicx93b5h65zdxLmedfm+AhcnoHNr78/yNuth5ZhG92HuVH/pAjGO7/Dmnqk/43JZSRYyRKL5VknnO15iTeRoOmRd1n+xnK1R6FtvJ9e8qIszwvdnnQnFi0GT9GOQ0bQBK+84mJIzEoGtzzoOA3veLdIqy5FuG52623kyaNEER7jGHoOl74EywHyDpxW7f6/0R9YicooRC0DNnFm/SX4qfewII0lSD8+dH6AzBtMf9TWzWCSGw98AkLODveJX2K4qgKgicIisnjmAXdSURkg0P6OQR/4LwE8XaSWFyQGI8gbOy6+0s3vb36/9uR6+ZROrtzVFOcijzrBVJajcnM9HhJxfGdPCSzu15Hke9mXNYg1zHua72E6d2sbygj8jtw2AlyaFhSOyIraURVeTbBYQCBtGqxzpUVkrKsm2f4JJpb4dtRZuqQIJQEMISOAja0HuJfEbZaC5KjVuepyyMdVG3A1ZsDv73SV1OYYnLkxtXqStr49hieaPi6Pyu2e2YF9uiyKk3IAHRoOWb83tpt/0iKxSXa9PNHka9CZk7a7eGceur94GkS+41KJnLbRx/wqvK9g6znE2E7x6mUiYSw02dDEQ+MMTMO1GcTXmpnEkOjzny0FdODbFc8KEC18SENUzCngKgEUi2CQQmj39VLEmm4mg8DCZ+SOdPobHlFe9ZVvxtaZChWFyR+NbX/Qb5oR0hLu2ggO4KQT0QpKTmQ8HUYW2rKCWwM0jZIVMlm05/tO1XBhoIUa1dLxzDHO0aq0P753HP8a4YuZl8o+iyiloro05W+cxTwCIRrM+3Be7A5oo00dhmJi5XWiUN65Bzv6uX/3H9O03z78sS9D13JnGbs3+D6/ybTmZKJrs8BFHjIDdqIpwE7SfVlVtYcJlHlt6qkztbqBEj/zzmSQmGo/s1khu3RHEk1A7ZBKMMHTswEj9I2EJP7ALOEJbhBVJGYcek4o
 B3WhjcZ9
 xLEydsLH6SXYz+6NI1HdoH8q08QenmJvuKA6DB+/hxs+Jji28fLMa6DxGzFbFZ71R5tuACTfAwRHOxiV03Ulaa1u7crEWmXbV56r+KEWtavpcdne4LHAmh9Ou8OiS+vhJSigWoihv5qsi1IRL6+YmaAyts22Eelpsl5ARJ0EI9K44hmaXv4u4lth5eUt79sGrfOTPCFEi1KDNGw1JtqE00Wf0umNyraUfkHqXi9Yav9+T+iNmMEuRmztE5ErFqhcU8zGv2ycIehKI2Mij1Tz0wS5PPLE7QYTss/TC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Wed, 18 Nov 2026 22:36:51 +0000, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v11
> 
> This series introduces support in the PCI core for Live Update, enabling
> drivers to preserve PCI devices across a kexec-based kernel update
> without interrupting the device. This lets devices, such as ones
> assigned to VMs through VFIO, keep running across a host kernel upgrade.
> 
> [...]

I updated the lu-pci-preservation branch with this version.

I'm waiting for Alex and Bjorn to confirm they are happy with it before moving
it forward.

Applied to lu-pci-preservation of liveupdate/linux.git tree, thanks!

[01/13] PCI: liveupdate: Set up FLB handler for the PCI core
        (no commit info)
[02/13] PCI: liveupdate: Track outgoing preserved PCI devices
        (no commit info)
[03/13] PCI: liveupdate: Track incoming preserved PCI devices
        (no commit info)
[04/13] PCI: liveupdate: Document driver binding responsibilities
        (no commit info)
[05/13] PCI: liveupdate: Auto-preserve upstream bridges across Live Update
        (no commit info)
[06/13] PCI: liveupdate: Preserve bus numbers during Live Update
        (no commit info)
[07/13] PCI: Refactor matching logic for pci_dev_acs_ops
        (no commit info)
[08/13] PCI: Save and restore the ACS Control register and Egress Control Vector
        (no commit info)
[09/13] PCI: liveupdate: Adopt ACS controls in incoming preserved devices
        (no commit info)
[10/13] PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
        (no commit info)
[11/13] PCI: liveupdate: Freeze preservation status during shutdown
        (no commit info)
[12/13] PCI: liveupdate: Do not disable bus mastering on preserved devices during kexec
        (no commit info)
[13/13] Documentation: PCI: Add documentation for Live Update
        (no commit info)

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: liveupdate-7.5

--
Sincerely yours,
Mike.


