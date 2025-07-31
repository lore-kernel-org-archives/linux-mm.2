Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAC0C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 06:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02566B008A; Thu, 31 Jul 2025 02:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA396B008C; Thu, 31 Jul 2025 02:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF0426B0092; Thu, 31 Jul 2025 02:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE0BC6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:13:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46F7F8013A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:13:36 +0000 (UTC)
X-FDA: 83723543232.10.6E75DF7
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf03.hostedemail.com (Postfix) with ESMTP id A43C020009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 06:13:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753942414; a=rsa-sha256;
	cv=none;
	b=pyp+Egi5cwlAQVr58l88Q1yQn0aQuwsDIECDSAgfZ5YI+n00hAlyLeVmghFh+UzHtgqhlJ
	G4gbExSq+71Rmzwit6zaX+P6+DCXNB3AJMfnj1mlvJ6jbFym0lOopPO9XoViz7TZVJnjxc
	vctXpg5W0gsihPl1MLv4fcJcuvnkS14=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753942414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxsZGd7YgAS9Sn5G5vitEHBjIz95xbczdqHtaH9IPFk=;
	b=VFZbiF9z0nouC81IJ/su5XpeedOWDjBiwgsPDI5YH1rs6X66bD2L6PWfJh8hDHi02OFAuO
	svtfzj7mUVxfe+YAfbPUpYLN6roPX7wLb6qECgoqUjPXRUMxtZf0FoFEYlQMRDdkhBg5CN
	3CACtY87/5xjh51C1xcATDn1UDCoQh0=
X-AuditID: a67dfc5b-681ff7000002311f-2a-688b0989ff45
Date: Thu, 31 Jul 2025 15:13:23 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, toke@redhat.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2] mm, page_pool: introduce a new page type for page
 pool in page type
Message-ID: <20250731061323.GA10743@system.software.com>
References: <20250728052742.81294-1-byungchul@sk.com>
 <fc1ed731-33f8-4754-949f-2c7e3ed76c7b@gmail.com>
 <20250729011941.GA74655@system.software.com>
 <18eb9e6c-1d60-4db1-81e1-6bce22425afe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18eb9e6c-1d60-4db1-81e1-6bce22425afe@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SW0yTZxjH837nVqrvKpuveGFWM0lK5oGY5dlwmxe7eBNjmDFysWXRTr7R
	xlJYCwwMxOq6KB2nFE+UqkU3QcCUFAeFQdUWOTmDgcC6jYEyMRAVtoJMDtHxacy8++X5/59f
	notHYrVX+TjJZMmSrRaDWSeoOfXjmAvvFqq+N25x+DF4fPUC1D3Nheq7AR48tU0IZuf/EOF5
	eyeCmY4uAR6GowguVs2x4OlzcPDEt8DCeOeYCHX+XTB66QEHbceaWRgr7Rag2LHIQvv8lAhH
	AzUMeBrtItxpKuHhxMKPLDTb74ow0OoRYKT+OQ8PQsUc9Lgvc/D3yQ4WRkt2QKf3LZi79QhB
	h6+ZgbmiswIMVrQyUN7vFeAvxyiC/vAYByeXjgtQeaQEweLTZdtU2SwPlTdHxB16Gn40zdKr
	l39jaCTYy9AW958i9fqzaWONnjoj/Sz11xYK1B91iXR4qE2g3WcWOdpy733aEphhaPG3UwL9
	Z/x3jk4HB4VPV3+m3p4qm005snXzR/vVxp/8azMjYu53E7/wdrTEO5EkEbyNnO5JeYUTt95z
	IpXE4XeIa+I0r7CA40kkMs8qHIsTyMNfQ6ITqSUWnxLJMV+boOyuxl+QhmtJSkeDgTQUF/FK
	R4t7EbnWMCi+DN4gPRX3OYVZrCeRZ5OMssvidaT6maSMVfhDMl5XJCj8Jt5Arjd1MYqH4IhE
	zo1WvTiI4LXkRk2EK0PY/ZrW/ZrW/b/Wi9hapDVZctINJvO2TcY8iyl304GMdD9a/qVLBUuf
	B1D0zp4QwhLSxWgodhq1vCHHlpceQkRidbEacC+PNKmGvEOyNWOfNdss20JoncTp1mgS575J
	1eI0Q5Z8UJYzZeurlJFUcXZ0MaX5gyMxQd51fGB3eep4SnJpNL/PKUZV0Y2anN3Vw+G8yZ+d
	K+7VfvmVK/zv4fvds5XB/A51WX3y+fYER8D1g7c1qTxkwwdWraQNzknzbbvv5hDZGZd/pcJt
	yrpdWj9L98boDyY+4ZO//uTjxKHMxuy+zIFD6+Njo2+nZRRcj9dxNqNhq5612gz/AeksZTpH
	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SeUiTcRjH+b23o8Gbab0q/TM7wHBZWjxhF0T0I1gHdlFkrnxpyys2NS0C
	Syubtx3m3MKMUmegrTzRkmneHWjWOq2VYXh0aObUNF8i6r8P3+/38/z1cKRrDu3JaSOjRV2k
	OlzByCjZlsBE32SXFI2fYzwQTKW3GCgZi4PCd1U0mCwVCEacr1iYrmtCMNzYzEB/w3cE16+N
	kmB6nETBj9JxEnqbHCyUWFXQc/MTBbXnKklwZLQwkJY0QUKdc4iF01VFBJjuJLDQYG6l4UlF
	Og0Xx2+QUJnwjoWuGhMDb29N0/DJlkZBq7GYgq+XGknoSV8PTflzYbR9AEFjaSUBo6lmBrpz
	awi40JnPwIekHgSdDQ4KLk0mM5B3Kh3BxNjMtaHMERryHrxl1y/BDQNfSHy3+AWB7ffaCFxt
	fMPifGsMvlPkgw32ThJbLecZbP2ezeLXz2oZ3HJlgsLV71fh6qphAqclDjH4W+9LCn+5181s
	c9srWx0qhmtjRd3StSEyTbnV46idjTvT10EnoEnagDhO4AOEvvaVBuTCUfxCIbsvh5aY4RcL
	druTlNiNXyL0P7exBiTjSP4yK5wrrWUkdw6/Xyi7Hyht5DwIZWmptLRx5duQcL+sm/1TzBZa
	cz9SEpO8j2Cf+kxILsl7CYVTnBS78GuE3pJURmJ33luor2gmMpHc+J9t/M82/rPzEWlBbtrI
	2Ai1NnyFUh+miY/UxikPRUVY0cy73Dw5mVWFRro22RDPIcUsOeYNGldaHauPj7AhgSMVbnIw
	zkTyUHX8cVEXdUAXEy7qbciLoxTz5Jt3iyGu/GF1tBgmikdF3d+W4Fw8E9CVoIAxcYgfWKf8
	tStDeSwmRRVszv6pmk/sMJ8I3jBY7t9Chck6zvqy/nv81pyFAlwUeJveWaby7HTmpHxs/2qx
	7AzOemTeajg4XOAe6u0c72OVKo9frYtSErUFI/X9V+fXROQNTrdRT595J+u3Jxc+XF7Pma37
	dgcdeX9hwUZ3BaXXqJf5kDq9+jeGdsXvKgMAAA==
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A43C020009
X-Stat-Signature: hf5kn8zasj9g55bp7xu1u9m1x4utoie1
X-HE-Tag: 1753942413-694807
X-HE-Meta: U2FsdGVkX1+vl04Z5i1fGOidHuKgXUOxN4DaYa7/Pj+l5S6kzWXobjYR9YeXov8bzXKLeAu3ev0xa7KRt1IWYjgtU1bmfUqmCYNWcaHdBKpMEr34mzwZzp6mKB3ueySC0sLkG4Wgk8hKYzoEkrY9gtfFADsaJ8NWqnfAlcpHdQAonHVgnbU+rZkghWMvKa/55Fx1EqYlNsI6Zbw4HvJtaRdOxL+bdOgg6QZZJ/AQsBJ0VwZJrewjZdSHYONqcZcLOqBS3jUl5q+m9KcwR9Nr0DsTh9vsrLdhOLr2WC5pH8u8lemk9BuDRf90ypzS2+JkQ9vNk9ZhJzTKo5wf5wIQq+oM+yVciby72lRAk/KGLnSopTCiLDXlVKmS7Q7N4UMg0oPuYZFe3DGu/b9ER/GAaWlon3/iDRg5im30ebc3aeC/MHOQ8W/5SAxMXxuDDpaBpX36CL5ZnJb2U8ZVOf6HLwkj41Jhj1FGz/DQ7e6YZP57CwI8t3GykLWDeVjflK2LXencM73PFWI81DfbSUDGOCBJ7w6f8Tde2y0vf1p0/ix7hfKJFyJ7u00d5GPTM7i63XNnSNVA/47j3KiDSFbMMWVqsLQf19jjn2mgLOVJiKuasfNak3NC3/tNUZaD2MghzrOIb7kgxuJnZNihXEGHjTXiT8+6cOXuLlhEvA06JihMfvx1Rf7zMG9CNCpSzTMP3tGp5OMGkfQZAG2lvA51xBT/SPahKIZjJP3z+BDVOIec+e/fT/6Ec+wrpUNsUDhPoS+oqyipip6LSa74BsTG/JIBWEs9TYF/Ssi4JiBT1g2F2SEGXu18PuvkthyqxT7F/M3Y2zWpsD8Clw1rLOkKzvqmh+W3ZBBnH7MplEeJXjlFlPqTBbEKoRntTv/Hk8M8iZTe1MqxLQy5jmj62TdAO8qHoD71nFO/XmLdGhbHAfJI3bH0kMpFn0gmJqiIsyqZ7SF+kqYicuLdHwQIkVF
 okO6Lenb
 ck9W1tDsBE4N13v+x1IuU80o0zpFWQoczMJiHhemkkHY1xthRjkrrDQ8kDrdAxiB5BXytc7HQ6FDsZhzXFBJJH4auaA73UZAAkv6VQOGqcXzREC6jZFDGywUnyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 10:22:30AM +0100, Pavel Begunkov wrote:
> On 7/29/25 02:19, Byungchul Park wrote:
> > On Mon, Jul 28, 2025 at 07:36:54PM +0100, Pavel Begunkov wrote:
> > > On 7/28/25 06:27, Byungchul Park wrote:
> > > > Changes from v1:
> > > >        1. Rebase on linux-next.
> > > 
> > > net-next is closed, looks like until August 11.
> > 
> > Worth noting, this is based on linux-next, not net-next :-)
> 
> It doesn't matter, you're still sending it to be merged into
> the net tree. Please read

I've never worked aiming at linux-next, so I was wondering if there's
a process for that.  I've been searching for the process if any, but
nothing special was found.

I still have no idea how to deal with this case.  However, at least, I'd
better send the patch once net-next is open.  I will.

	Byungchul

> https://docs.kernel.org/process/maintainer-netdev.html
> 
> Especially the "git-trees-and-patch-flow" section.
> 
> --
> Pavel Begunkov

