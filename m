Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46590D2FED9
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 21:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7947C6B0005; Tue, 27 Jan 2026 16:34:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717626B0089; Tue, 27 Jan 2026 16:34:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619AF6B008A; Tue, 27 Jan 2026 16:34:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 51E646B0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:34:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF4A61B0570
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:34:35 +0000 (UTC)
X-FDA: 84379048110.30.D4776EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2EB4E40007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:34:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DjTBNLHT;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769549674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yhd+PfTa6tgv3U2hczRMCCkXgcyCDvJgnwegq9pCA4=;
	b=FyIg1GbyYxFQSzcWdVcJzZjeXMR9s12DuBxn4/cF6yYxhmk0YEWa7fuw8lAJ7yGuwYy/IA
	ZWnsFzqZu0fPe8hq+4XpIdgBxbU69aXpyQj1r6LxIX6QE5/bSzCVw3SqPcoObB8w7AFcwG
	xDGOHvRRuUi+uh2D+Om/IIEi54x4q0Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DjTBNLHT;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769549674; a=rsa-sha256;
	cv=none;
	b=j592zsFfNzSs9y6dmNK9Vi5B0gAzg2/nHBDDbsAW+4DqMOZbpankSZoYpDsfmxzs/4Pbdu
	zzaKk9i7IAP5GeLa7MXueAJ9H9cn46/4VGVsraiLs3pbCqJbspyICuMGAkV4eYSC9ZQwjm
	1usHWMQWq7BeeQwRBd/03CEzPRmRrfE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D4FF342AAC;
	Tue, 27 Jan 2026 21:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A5FC116C6;
	Tue, 27 Jan 2026 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769549672;
	bh=bR9qRQiDPotvAWn2QIuk3A3vxmknksey0H/5pA0EgaU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DjTBNLHTNOC+jXRWsQ6HIWju6jaCg17tDZSayr8cblHACDU+z7Syip8Gie1ClWfDk
	 YXi9aqZvE3iKKO+oV1rWm4swd+zSyWuVq6ApEnjlVtei99TwkJr9wfiAoy1CLgEKvE
	 lAlqYtdgL6tUK0UDATd8mL/cp6frej8XW69FO5PU=
Date: Tue, 27 Jan 2026 13:34:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, david@kernel.org, mst@redhat.com,
 jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
 osalvador@suse.de
Subject: Re: [PATCH] dax/kmem: add build config for protected dax memory
 blocks
Message-Id: <20260127133431.671e4605eee807abe84f92f4@linux-foundation.org>
In-Reply-To: <20260115024222.3486455-1-gourry@gourry.net>
References: <20260114235022.3437787-6-gourry@gourry.net>
	<20260115024222.3486455-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rht91e1dfpkh5c9fax5916rgcnqegopq
X-Rspamd-Queue-Id: 2EB4E40007
X-Rspam-User: 
X-HE-Tag: 1769549674-844217
X-HE-Meta: U2FsdGVkX1/axdWa2Pa7Zz2IJaa4gk8ZKe9GjfVcQRznW9mg6VDe0JN6UHMUi6nnWGXIvKREVMZQbxzxz/CeUYlk0CWnfFnO7mwA90MOxfx58DcbDiyJO/CBazVumLqt6pgE3S/RXi21N5aX6BIibg2bNyFlxsRKJWTpDg65/68uMRm2l3xwfjvi0DfgtbL/t6pP7rudnf9Ocqnx0crV7Hu0KUyGRtc9c0wtUX2xVni+o0mqVNwbpDd854IIquUvLpg/YuCI2P/ZhTaXMEX1X/ZKOHIFAFJzEQZdU7zPkzmXOz5QzBSbpFuYW+P88HQHWcd5hz71fd4JvGgTZiOhAzssae4LlwkrFt9J1yL8jaDNatIi2x0+qwy8SarJtiU9KM0qbxmYLwHE8j3WmrbcXk/LL9UytSEuAmc34be0TbAXwf/NEO/hlVZslzhGAGV/Tf/Pp4AUyGsnRMVazl+bSB31KaYzySGCS3H99HWyS27vceod4Z4CKBjPzfYkYQeo7Mv6PIRSgJmJG5jPWk1tR7bCW1mdg3o8g/Nqq56hyphbFVou1/T6n5hRrQq931v5jYf5h2SAXaR5cwIc6REnSfvMJ3mNoWmkwSX1g+XdsKYQILq1DNy9x03zup5M7NHW2focBAuKpc9aNCoPh07ygFZtFAK70MHiT606MIkUh4hG8l1ld2Wz88unQ46sFS6SGzT/XmEKaUC5GuR2bNv/w3TmTY0zZCqAnA1+XPTPnXDIFyH0A6D1a0I/DcBkGT9kGi0Ftw7MXLYnEoKguVuimnguQviMikoKhgcHuWm+XvszPcL4FOOFg/g244t5sY0MDqRUYROc0I9OkceGgjtE65916hZjRZZr7YywMKLQB0Yoc8qHcoEcPUPe7woGXGHfmwjsNEgPf/3QpqCfSawx2NNjY9KknNkecfyqXse6gXubW9qaFZfFoQ/Qcgteo2pLCHHXu1QGuPRSy9nLCrD
 I6DP9twn
 zunZdOR3t+5vpgxJHf0gt8avVty6eV93+Uv82FHg87A90M5hc1Xitz16Rm3nSY9sfz3sCF2T7iVXJQQMCSNcEeXtEVpnbhT+Hllafir4vD0QJfEkGii9Emdm1z4ZCix8SbQY2SPiA6R/kvN/MSrg+wF/aIQRv102F2iAA2LKdjbTk98Rn8/jiSNy37AFqskFe1vztBGRC9cu8l1m0u8C1Eh3rmLM4s6Rpd7I2TQBAzXqawpU3vRRsiom9tz3DmXU3+mNX+3McmLXwGxZeldlKzxmVBFM2WzsR5fF26IVrvO+dKH7VfgGuZs5NBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 21:42:22 -0500 Gregory Price <gourry@gourry.net> wrote:

> Since this protection may break userspace tools, it should
> be an opt-in until those tools have time to update to the
> new daxN.M/hotplug interface instead of memory blocks.
> 
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -78,4 +78,22 @@ config DEV_DAX_KMEM
>  
>  	  Say N if unsure.
>  
> +config DEV_DAX_KMEM_PROTECTED

Users must rebuild and redeploy kernels after having updated a
userspace tool.  They won't thank us for this ;)

Isn't there something we can do to make this feature
backward-compatible?


