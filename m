Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E10CFB44B2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814BE6B0095; Fri, 24 Apr 2026 08:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C55B6B009D; Fri, 24 Apr 2026 08:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4356B009E; Fri, 24 Apr 2026 08:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 545D36B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:33:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F41C086090
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:33:13 +0000 (UTC)
X-FDA: 84693389466.03.A141C61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5067AC0009
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:33:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLDco3bB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033992; a=rsa-sha256;
	cv=none;
	b=DjmbUHbYBX8q6hM26yCyNSqomvvL8/X/tjqL+dwCAjXPjMb4AwOQiugTssaV/wQWUdFqnP
	7Iems3h4aijrxEqeEiyuh7hN7nwLbezFBeaDsdTDocrBhc09Ghb5LizIquIIikM6YasfYq
	hhIOsqy7MWqHH+I6PYT2DguP5++vd9c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLDco3bB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZJ9GWp1jxsGc6Vz7xGAdGWrQ1InyP2sPpCeJqxt7fc=;
	b=SMDFADwQu/Vl7PxyEikGBFPtjc+JhyBD1Se2fNEomYFdSBA7jakfSSlZnBue4fNCZvkdls
	xYMXeH+R4Mhd0oAFBHIZ4L3iDLdk36I+8SrFergazOTMpNReJvr7VFhJcvSzWyPpArFVYU
	UvCu7YbzF6M0PHcUp3eZqUTfzA/Onyw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B099405EA;
	Fri, 24 Apr 2026 12:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B592C19425;
	Fri, 24 Apr 2026 12:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777033991;
	bh=m0zzjIAi6G3mbiTZhqEoSZO9I9LqVeMoE28CldoBOQ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eLDco3bBc0PX4AYSurXPqBWJwbosfw7HJtTqQMEb1e7HgcJDAe2lM28587PkhaPlf
	 65Ybv2D8qAO2qCUzL4klNk66vCwfZaUL2iaIUwmPoboyVmiwjsSJWr3w5R7+2uw1ij
	 xGl/2h1ImWFD8mCquOSBL4AUB29FAxoOrHCDjoA+yL2OBuPkkPXwi+jeidmphGPEhV
	 KMoX5Tj2FsFwb01ItnjsOxDDTNrvMDxm00VuwVngUAlJ5KIAKdlSl4SYgSrlog1dyB
	 T0s0pJ+dPo4hV5tygEubPKF5IlbBSUmlRP4SNsGhqvjn+1jn/Eys+M7Qwq6Os0g1+d
	 3knpQBIl8aGWQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Joerg Roedel <joro@8bytes.org>,  Jonathan Corbet
 <corbet@lwn.net>,  Josh Hilke <jrhilke@google.com>,  Leon Romanovsky
 <leonro@nvidia.com>,  Lukas Wunner <lukas@wunner.de>,  Mike Rapoport
 <rppt@kernel.org>,  Parav Pandit <parav@nvidia.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pranjal Shrivastava <praan@google.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Robin Murphy
 <robin.murphy@arm.com>,  Saeed Mahameed <saeedm@nvidia.com>,  Samiullah
 Khawaja <skhawaja@google.com>,  Shuah Khan <skhan@linuxfoundation.org>,
  Will Deacon <will@kernel.org>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the
 PCI core
In-Reply-To: <20260423212316.3431746-2-dmatlack@google.com> (David Matlack's
	message of "Thu, 23 Apr 2026 21:23:05 +0000")
References: <20260423212316.3431746-1-dmatlack@google.com>
	<20260423212316.3431746-2-dmatlack@google.com>
Date: Fri, 24 Apr 2026 14:33:04 +0200
Message-ID: <2vxzeck45yin.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 5067AC0009
X-Rspamd-Server: rspam12
X-Stat-Signature: p71k1zaq6hsktxp7ka3k8zzpezcwtya8
X-Rspam-User: 
X-HE-Tag: 1777033992-166236
X-HE-Meta: U2FsdGVkX1+UMzewa0LUkJTZQGgh2DpVSYyZdmQAV1OsmWU+HpkOQp/ywC48jYV2dFfhnBxtw6ynS0f/aHcXXK7diQMsptYVph/FTHhx7wsHYV7h8UELYUdVyGS6zpyMPAuXeep1EmlDeSJD8LvKclBJK6FRDseQ1qcwOAmc0L0tfMitbbse/ZXij0UxuJ6dggoLnoIc9kVavyFJG8PhaQVFOsCV3K5Mp/SA/SZrrtmr6+aoIEE7gSusjgsXP1begjpJjeCHzg3WU0DvIqDwzL+cax75CLms0QmQod242e0wyKspg32IG3sadjuDNaHGGpS7C4nmEMhoGkxvBbO12OO5BBV8P4Z51IvEfBn0L99xFKschM97B/h1JE54HDm0TInC5XGDOiVW1g23muN2Ch+lIcee+F8+stMcjUZXow/05ReOnYR8YzbiVHwqS+mqpdKgvkYwUTCc/fFoiXwUXivwILG9H8mX+sx0bRfFG6lsYCoGobNHivuWKI0K5KPRtJRw7BNFCPQ7CsZTix4/3edOwCmkIddS9wGD/5NYxlGXe0EK1CEdmA/r6dxBfG88mylLb5wGh/QgY/3pCvyvyDK4ljBNQYqC6mCbx3BdGK93zQhUZhcwG6029EBOXiZ/nNTrUGao9b6xe6HuDYL4p14KGN2MSMz250Z0Nr7ceYAn4xdq+6de2ZVp4zmmF0CzK8piscRx195oMfSLd31yfU/a9AqdmfOzqzQwFFSRVFZnNmhUZK1s0oVU5s35k9IT/222H0ybKKi+51tf4aEqV9dCAqtwr4185p0ArX/1uACLyXUa1SA2L5TrzHrxVguEXJj6xn7A383ld+1AvV7KfoJ/GPndQlDbOsFSjSCQpcRXv6SEBICiWo9AFRzORIiMuJ42SXcWQcvFGS4b0RcUeth9Fzx2cAafaP+JReTfmfS1d/yTtVeNvrFtxkxxJwo9S8ydb7ja7jy080NLpVy
 sk5d/Wjz
 tZnmlP8A5ilTra4/dfN26t6YDQvw8FSegz1OTS1CMRVA9o7QqTQ0fnFQfkap1n8EAIO8Dwr9skrFrPctS4ePiNzpWPQ6o7e8N/LBrYMuWhz+kINjOeHQdsAFNOAvejd7u4wO/ql94UAatYjzXEFKnCNlCiQ76V6aI8r/3TgdzYbechXOSSDkdAIMN0A+vqifELBEXgNHya/mcxt2aVclicQzBpHbFCGz1p9wP8EcQ4a18yiiCK5j77wrD9VHqurCEeJrelpqRk93fkmNjkw7aC/MSEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, Apr 23 2026, David Matlack wrote:
[...]
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c9b7b6f9828e..94af31837375 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
>  S:	Supported
>  F:	Documentation/PCI/pci-error-recovery.rst
>  
> +PCI LIVE UPDATE
> +M:	Bjorn Helgaas <bhelgaas@google.com>
> +M:	David Matlack <dmatlack@google.com>
> +L:	linux-pci@vger.kernel.org
> +S:	Supported
> +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> +B:	https://bugzilla.kernel.org
> +C:	irc://irc.oftc.net/linux-pci
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> +F:	drivers/pci/liveupdate.c
> +F:	include/linux/kho/abi/pci.h
> +

Can we please also add these files under the "LIVE UPDATE" entry. The
code here concerns both live update and PCI. We can figure out the
maintenance details as we go along, but I think the live update
maintainers should at least get all the patches for PCI live update.

Perhaps also add the kexec list here? We plan to use it to maintain the
LUO patches, and adding it will make sure we get the patches in case
someone updates the file list here but forgets to update it in the LIVE
UPDATE entry.

>  PCI MSI DRIVER FOR ALTERA MSI IP
>  L:	linux-pci@vger.kernel.org
>  S:	Orphan
[...]

-- 
Regards,
Pratyush Yadav

