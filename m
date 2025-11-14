Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C1DCE7A8B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 08:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D12E8E000E; Fri, 14 Nov 2025 03:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8E18E0002; Fri, 14 Nov 2025 03:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5AA8E000E; Fri, 14 Nov 2025 03:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F23098E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 03:53:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 977B94CADC
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:53:09 +0000 (UTC)
X-FDA: 84108598098.25.5AC4E0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E0BBB40007
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:53:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GiHZ7Clw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763110388; a=rsa-sha256;
	cv=none;
	b=FKQWjTWBLdq5PTFPTUGK6x3DxpqhcjpnDtttzvBXIWF8dG0f90L2FnlKM+xb0450EdLFZ8
	C5tc8Fihb6UTxU9MoTKWGqs8tY3Jdq9KH1LYN9MHrvJ97rH2vskNuqNWjhy/4WJ93OpDKC
	d3N195lPW44SvAbh9swrQ9u+yC7wyjI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GiHZ7Clw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763110388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0ZDSLhJMzbN91RjPN1EbDilhkoQXAuNj9rynmBWpuE=;
	b=H5PCO6Rt4Ci02q/AA4i5AELKbMP3hat7g3LXk7ymoDmax3y2aOKjE0+LfSEHIZm2xkT+Xt
	REmqcDXE1HexIORwSn+lbHuXOG1v7phpUmcCMUATMiFsU4ZbgaLpSW1VtNaqBPvWm7mjQu
	S+/pwVXUQU+m3CvQZxJ8EStbFI1f4pQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D50904444D;
	Fri, 14 Nov 2025 08:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A4FC16AAE;
	Fri, 14 Nov 2025 08:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763110386;
	bh=MWXd5szugeshV852D+6iJV2/VOZL59gQzQ6IN1NcrI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GiHZ7Clwa0t4iY7B637Zx733ucT4kzMVGQdk9zVLr0hZm3HOcByGnxZf7x87ZSwAl
	 Q5n2SW5PCywXHD8aCsjAC8aGObZChB1i6yISgbnwBdFi8olIYu5CTJnV2H7UP/76t/
	 A9wAqfdvo1R/eEVCKhozOL09tz4rd1ItAjlDkNc4SJUFA1twxkPTS6mbqQbm96MYUz
	 Ow7EGvQ65qxKA3Dc6Ojp7GVgqpRxpjim85UvD+upUODQg+ueKLTQ0z6jxORfZQBwVe
	 MVEjxBtx2ApbrnOBA44HQ3u7yVo58o3scOGduG2iUxSdz1+iICyrjzsUU212Q/Sxf/
	 GyqRqPnXUZiqQ==
Message-ID: <a154f3ab-36ec-4b5f-8c61-6719808a2a34@kernel.org>
Date: Fri, 14 Nov 2025 09:53:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/3] mm/khugepaged: remove redundant clearing of struct
 collapse_control
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-2-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114030028.7035-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E0BBB40007
X-Stat-Signature: 3ucmqhmz44h9r9xewzoegyc3w1p1ro6k
X-Rspam-User: 
X-HE-Tag: 1763110387-947762
X-HE-Meta: U2FsdGVkX1+7fVvPlS5Wpf6aR6Ftxb95TyD5qjQwcccbWp8900FZyTG5Fp3sLkGl8GPfF/NI2cm9TLG0u7fsq5Rz9td6Nv5u4K8ySHPNLUbBpAx/azEqchdmeo5OW9GXNqbmWm1L1gKI+rj/9A+5dVy1E98Nw+mep5A8zATeWhuYcbl58EzY5H/sGqGfU2NBRJZQumuRwYmka9Wmo072Vy9nSHpybH0eNF7Sth4OMtWgTx4Q66TcNt9cPij+VtKcCxFkVlWlQHHy5W3q2QDQRFMf2SDlNiA82uPOnP2wMi6WSTq4H2AAOT/uR8jDNeSTi2D0f8tnQ8CfC0KRt7BAzAli1g88YTCKq4Wt+6bnvLM+9r97xTTMqJTZTuh9YooUeba8hPiCVZ3uZY5bP/V3j+cLIfzq8CeDBrqOr8Poebx9rTOf+Y1dvkXFOpyuvp7PBW8jjUeCZeQlPEI6hwB4PE6WL9AAXfT8zojuYkdhadAs0VOWBQh4cuOqUgDYVaszWc/qGM5wmoVrdUA6S/McDbUIECN1aBVq0H6GqPwU9/kmq1mV7AT/D+NPkFymBki0ctX6pwB5sjBO+dIXyDhiZTuSiyKWEM2CH5f7ywXecLRWVvTDpwGJmHMshVXLgbSpPDjQqyPeMPUFEMWe2Acro/BncqqvZHgBTNUYZCvAm0DrOrW4gf49B1KsB0Teyh3q+BMdkMTupos29TMlbo5P59w5PYMlEixGUiFSC5B/AMaBxb96TVNss+u6AIy16ugfTr5NgTdWZvusSmNE49THJlQ8cWD1T9aE6/YhpAxFQGqpiO3wJEVbt0DY/9cO/PEH8DmMRPPDFtGtUHj5aoreHIKwp+O9cMepcqyxpIrxZpBVhAH4EknVm0vOsJsHMz8+S/ZskgN7V3N6Y9B2mgzw1Wr22MF2AFbaSXgtb+JZ0uv79G4Vc10XQgeni4et3uav+7zeJR1tws9W3hDqi4i
 WMvY+LsE
 KBrAGLql96ij23p4h5cOm5NMdzEi+WERNESpA4kHvbOWTFN2rEF3t5IdhSPaSCIy+O4XArDuRXrpzGNHHmSWmvIysjQ1oGv0Svs+woOGq1/AYF1zfD36p20kXDOkpVlLzekngvDzF/61EdnuLRr6VnBN1pr9UqbkG/GKcgexjCaMA/4L64jdQQNdns7sYzT7RnMzeyshGRCYOYGmjXxqtGvrADhd91BNis95ECpKC/elfwkOxlB6/jqjoT4P00+QhTbBE/cZPeYsgAIkdgCBr13KWj+2h+b2gXFWW/Ojv4MSeLPlCj/sC/cAcv6H9dr8o6ZbODA69Zz3enFVMN/bQU17Z8HyJO7iL74fTr9Ah7AWFUn39XbgOCX2mldrVrcC4jwfAXJgH8Z80sThQHcyk8MfDSmGK1Oxyw1tzaj5FW7pvgTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 04:00, Wei Yang wrote:
> The structure struct collapse_control is being unnecessarily cleared
> twice during the huge page collapse process.
> 
> Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
> perform a clear operation on this structure.
> 
> Remove the redundant clear operation.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Right, and the structure does not seem to get used in between. Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

