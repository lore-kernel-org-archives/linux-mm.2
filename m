Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FA2CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 03:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09F16B0088; Tue, 19 May 2026 23:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE0996B008A; Tue, 19 May 2026 23:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7786B008C; Tue, 19 May 2026 23:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9165B6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 23:42:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BB1D1C0289
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:42:08 +0000 (UTC)
X-FDA: 84786399936.14.BBB1AB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 524E516000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:42:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VA2F7P9O;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779248526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfFs7ljUUn5ctVcdiPiZ8Wx+0rgfOs9EiT85UFleKDs=;
	b=tWnA8qokQ0RMdEewETQ1GdDa6YAfABXDNzTvGIWQd6bUwE0CKkzFGxx5G+ZcgSGNNm3WMg
	K45OZIO2hl2e7d1DvY2EOJEAZw2nGOg6EI6jah2P2qFxAoNLa7a8BFEX2+xL8N/f61IivL
	YEGU+GGMaJVZ1zATfEcXiFZxIX81CoQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VA2F7P9O;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779248526; a=rsa-sha256;
	cv=none;
	b=b7nvEo2HFyQChdQ3CPU12y9BtBuIyktQAEK1k2Z1tbCNPxXpGpw8wkCv+uo7kZqvxJ2qSF
	ldtb0G7zNQ0/YOYDD9g4D058HddF01SyKK3B/7v0q69c1JAlcnT6DhWi+hU1blva3abGnW
	c57ToMGfZZJeutfj2V+5/iJiUC06XY0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C56DD601F3;
	Wed, 20 May 2026 03:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E38A1F000E9;
	Wed, 20 May 2026 03:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779248525;
	bh=UfFs7ljUUn5ctVcdiPiZ8Wx+0rgfOs9EiT85UFleKDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VA2F7P9OYS10pVfJgs1MmK9a5HqkOjZF71WQL4NBlojEfveLSJkDTovu5Et01/NsV
	 BWNsJGLhFNg/ULzg6ZCaR6y+slGOVMcBt0nC0Tr9YEuqSHOaVEb63GA761nwwrY4aI
	 hUrgCD8yGzQHiCalrMs7yppZDCY0ewqG+ll+97s0qnU1pOrGrO+K9UXJUtEAVzz1W0
	 6p7IqjJUOhNiHosp+AXEyze914unbxRpxNJ3+UrqGUNwZuFSzg+wSm0Dn+lxT13mwb
	 3+ixGO6DAhqV2t1uR2QHXKF0DOWUNRH3KOaadR9K+b4WVvjaix76E7Xou3en50mHOF
	 vMeo6crJXrvlQ==
Message-ID: <8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org>
Date: Wed, 20 May 2026 12:42:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
To: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hugh Dickins <hugh@veritas.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260520011019.1707010-1-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uewpfnnogeefbugapwj441mrofuzsagi
X-Rspamd-Queue-Id: 524E516000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779248526-383413
X-HE-Meta: U2FsdGVkX181YkcfrIOjN6FKLUbGlrze9mOP28ZISKKL0sqm1O1V6ZcwOpWoKviLRM9jb0csyOPc+m9jIfdZTszffuSwJNFJg1zwr5tafPcUKKBnU/ymRP3sFANDah8qTTjm2HTQJsZQDByV8m+W6FcGIixdMSD6+XghfjBeKBXE8EZwwufF2tFGy5pKQybcER7wyiO6ZVmVYdqEG+OldFe6eUxYfMxII8hoxN1vNauSEbPuihg6krAj+8tnciAOENGboWdwraxKkGdiMSMPY6m+ksB3NbBlNynQup2Pl1L9MM/55rq9tBCtgQRBfUn2xnj+apJzX6FtkayNRtD+dgMypjXKFqBesejKIMzoRasR08B0qNX1wbnhBhjMgfggiX9RNZH0YvhRJA/DW9RCzRcb1magQDTdN4keaUaT9IKHwvcNYBKdw7vIBXL9djOuGw1NXPZqITILHzR9GgZHXdmXG90rc12wgf4o4qvkZjUfejnB5+xVn45rYJ85TKU+gD4TIJNBs/bWqhEV4HrSbpULZ9y5zvJ+YgXxE+KEy9XZaQ7DxX4j0uqlFfdGaeyTwLenI7NFXj1YMGH8+UsPlNldPHl1t93Td4fdT5ZIwd5uyvd8tpXV5gdv/TwySj4At1tJYLEPVb0FdaHMz64Qr90k39cfBx67SUJ1TIvEuEss/oEJHZgiaFYeFfaDo3d2TTtk7tucywH1izehvWTTh+qkEPE6cM7Z5IzD2Q+Fm2T/v+FYD83Tw3DBnLG07RY0UPle4eyWZAQ58otEAJYKzQd4RQhjUPb1iMVsfX7uoK9Fgx9Oq6vpmm7hQ5tmSoh+2eA+jlPeyL82hiGmeC6rGNzqknt7TlUXDkVW8iv4QLjucl96CdIG3QSEFBkIlUBCSi0xE4+s3CSlAhuVgftJLWrCCK49MC8s31b+PmDGoaAwuGECStwPm7wOMIRKOiedmkh2zc9uc4AVrryaAA/
 An9XQK09
 5ZEl0ENCRePrMaFGAwl+yRGqSaSzBE9vMNINqLCtwryYnZHC6IZOgoweYFLMWDUGEJbl98yDeJNrafQHWd5DU9g+qKPK7U3b63EMeiR8YukKc5o5GTbiZp7ZvSQKE+6519oPI8u2sGkp0YxRflAm6fXwJf1q2RwH3PmIcu10sLfLtgushKU1NuNQ1QMnvaTzzm2Y6LBONrncN0tbZlBu5VAEi4LtDwXUJAqIsjdGG1cVNV1TYg86RW5K2yVoN7ZFEp08v86lrh0vNdbf2ErOXuSo4edgfiK9GRChlQVSO2oZTx1MYgh0qSjN9tfENdoUtsAG4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/20/26 10:10 AM, Vladimir Zapolskiy wrote:
> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
> names are blindly used as symlinks to slab cache objects registered under
> /sys/kernel/slab. This kind of symlink creation is successful, but its
> dentry is obviously broken, as well it breaks the access to the list of
> /sys/kernel/slab dentries.

Oops. I just loaded l2tp_ip module and it indeed broke it.

$ ls
ls: reading directory '.': Input/output error
:0000136/                        kmalloc-rnd-01-16/   kmalloc-rnd-15-32/
:0000192/                        kmalloc-rnd-02-512/  memdup_user-32/
:0000560/                        kmalloc-rnd-06-192/  memdup_user-4k/
:0000768/                        kmalloc-rnd-06-512/  pde_opener@
:a-0000168/                      kmalloc-rnd-07-4k/   pidfs_xattr_cache@
:A-0000184/                      kmalloc-rnd-11-8/    RAWv6/
audit_buffer@                    kmalloc-rnd-11-96/   rpc_inode_cache/
configfs_dir_cache@              kmalloc-rnd-12-4k/   task_delay_info@
ecryptfs_global_auth_tok_cache@  kmalloc-rnd-13-128/  TCPv6/
fscache_cookie_jar@              kmalloc-rnd-14-96/
io_kiocb/                        kmalloc-rnd-15-2k/

> Likely L2TP protocol renames cannot be done, since the defined protocol
> names are exposed over /proc/net/protocols for years, but the symlink
> names can be renamed, because they are yet to be properly created, and
> this should be eventually done by this change.
> 
> The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.
> 
> Fixes: 81819f0fc8285 ("SLUB core")
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---

There is also a debugfs feature that would cause a similar issue.
Can we replace '/' in the cache name, without renaming the protocol name?

-- 
Cheers,
Harry / Hyeonggon


