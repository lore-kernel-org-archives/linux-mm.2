Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C6AC61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 15:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB0B36B0088; Sun, 30 Aug 2026 11:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62046B008A; Sun, 30 Aug 2026 11:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50F46B008C; Sun, 30 Aug 2026 11:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CFED6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:11:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6154A3DBE
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 15:11:30 +0000 (UTC)
X-FDA: 85158274740.12.ECD0F4F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B48014000B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 15:11:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GNNoPCnY;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788102689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyG9tz+TSnj/rxvvPnlHrADvCYJXm+MsawAjXsGmswM=;
	b=v07448jSRZXwPITviXr9k0kFT16YyDpd2Hs3PoVgcELtTlLB1cidJ3ly2ZEje+fYc/4d+4
	ieuXJNMHRTFz6vwPfWPNBMHGv4sK5euyzs9MqTZmBejSk/BkumQtA9nQhzpDNklh1IdK6p
	fNP0GiWdw55RUzBmU7qezL0tUN3Vq1I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788102689;
	b=8q4+2P8y5Z41Z1FNKnxG7tp3g6Laklps98IzZSnuuaRua5V2Lp7mSE56TJb4ukocjewfPO
	eEQfxgsZSb3KVgtzgbeapOLHGcA7FAzpSOe63TtulmUm+3yG3iDYfBu229nh5l+ad2SO6o
	6ACUxH1FbNtwl/WFf7e9FwrlRT3eCB0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GNNoPCnY;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68BD3419D1;
	Sun, 30 Aug 2026 15:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB121F000E9;
	Sun, 30 Aug 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788102688;
	bh=HyG9tz+TSnj/rxvvPnlHrADvCYJXm+MsawAjXsGmswM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GNNoPCnYfdqBton8YNLsVJxe0Vx6acTMuSP3LmHDTWzmprfUEf4d8l39/ANjOMBmI
	 6Xxd+ytmKvCuQPLFKt8s3JEkL9fDULs+kWLp52HgqZI5BCimG2ca+whU7pLZdjlG17
	 IwA91N00zqgrhCajC4A9PHIrzNd/dV0kfrF7mQRUt/+VO6HRQZ67D69Ls0eFaOnBX2
	 0pLzQa9J6WnCoPKUgpU0cKWtP+EWSKqovVNIOTwHwtEDcdhDsUbxIp37cxpE+4zEuO
	 Q1NFP57GQdDnRiJGbUVatKjNeGrNzR+4eg8PaVb3f6g+BIXpjKj/ipCQbx9XycRQc+
	 MR00djAuV0QNg==
Date: Sun, 30 Aug 2026 15:11:23 +0000
From: Harry Yoo <harry@kernel.org>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>
Subject: Re: [PATCH v2 1/1] mm/slab_common: reject zero object_size before
 calculate_alignment
Message-ID: <apQ9SGYssBn7LYy8@dev>
References: <20260826015506.3178758-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826015506.3178758-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4B48014000B
X-Stat-Signature: zsqwp8oiaj1so4w4ygpf46g8hizz7hjq
X-HE-Tag: 1788102689-435251
X-HE-Meta: U2FsdGVkX19H2mp9RUM2nnZ4/TyQjuS2VatluH4fhYVq45inupiqXMJHikFaChwN+MEL8iNEktaEZ5rTFRqarSVi843Mhw1v7thNj0SIjfK6yRC4AenLNGh/LAcrUGggQiMttnGULo28QA+aclJjKuQlis2respaLEphIgGj4tAu2Y9EfAp+pDfTxhrw3Tm3iKg+5t5S+XcqV84LCFVTONqdrxpX37N9RqniTIeUZGjzIelW1k7mipg+lNRzLnPDZ4ZOu3ptH/yNrQXclfoBNSsfroQEzLQ84wTTlzelH6YBXM2r4F5pAjsO48+aPjIILmflAUTjtgqqsXk61OPUebCdECBQaXCNZP9Mh+Qc+qwp7dB4lpXBJPp+LGP6AVVhgDw/yDzVhs+MWPTvrg045h9umw+XjQQoDk5rD2v6tUqZJ9Zpzh217WGFmw4EX9gie7fM5u+fTizdTANDbFzQvJ0SvG/beP4jHHM4X2RPjw6d3syWHEUvIsBJSBPWldcMH0olAZC64yg5DSxur9Scd6nBZJ9DYeUngHxPONwa9+E9yW2Z/ER42jRqCuCGYBIpMKu3Gdd49sBmu0LEVeHVgGcc/yWQPuohAkE7yH4a6eavQn0svD++PVPYiKC3OQsfN90OdF3YMfAWkGzUU5yPrymyPpnzvvSynKD+UTiv3yGwEpo4wwnFrs3nm46ja7+X3GyyJ9AxMMwlN/HZlMztFfe6f9vWLW4UexOkyWmHQE3VZsYetWiUm9kVqNSVPn5ZFihhjDOi0U4YygLgA2uaX9QU59AaiDIPoE1XM/Grl7c+2ltTeCyvkJRKC1hey/mGEEmqHEd0Xl5NZwzXbuqrAmoBhAH/eAyhHF7RSu6MXwlpyjCu5QBYr0qxRksQzJZI88CP1Zt+ZEfd26eW9xfKa3h1d68wSDQO7pRB2ZJHJzL3GFsKeAGu8s7gIWWOyVUm1T8qbsI2Y0Epyufd7fM
 pRb2fIvm
 ynJ6TpzMeSiou79T95fHvnywDL/FoQB8/XOgOL8Nst2/emCMt21VPKwIlv2CJVh4BfK3QPDj5IP/pYDDBTmF+R3pd77e6SksAI0FUIU/Nhyv+55nBpuNhixM7X9tj9svkHhEY/aKjS6Yq4VyN/aOM/R9j4CBKVOJcJ9/48KL36GoKnUD7ccuicpymsU96fGQIIm15Qmf25oAoML0OYJOfucxDWhm/gHFL6MONgz/+A45I9rRiH1x81Ny7M7RPMoIgoxdRPWW9C9vIAn8Ksfb6gn8YyaDJ5ouFHYIJ1i0V+jVuawKFH85+ZY3Lvya/ViCaDjnGyplyUkOYihdPmRxlRzDHDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:55:06AM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
> while (size <= ralign / 2) loop. When size is 0, ralign eventually
> reaches 0 and the condition stays true indefinitely, hanging the
> kernel.
> 
> kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
> size == 0. Add !size to the check so a 0-size kmem_cache_create() is
> caught on CONFIG_DEBUG_VM builds, where it can be diagnosed when it
> surfaces.
> 
> Suggested-by: Hao Li <hao.li@linux.dev>
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
> Changes in v2:
> - Drop the !object_size check in __kmem_cache_create_args() that v1
>   added to the always-compiled path, and keep the guard only in the
>   debug-only kmem_cache_sanity_check(), as suggested by Hao Li.
> 
> Link: https://lore.kernel.org/all/20260824092454.1693745-1-xialonglong2025@163.com/
> ---

The patch is small and benign enough, so:
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

However, to be honest I don't understand why anyone would ever try to
create a kmem_cache with size == 0. It doesn't make any sense.

I'd strongly encourage not addressing every theoretical issue raised
by an LLM that doesn't bother you or somebody else.

-- 
Cheers,
Harry / Hyeonggon

