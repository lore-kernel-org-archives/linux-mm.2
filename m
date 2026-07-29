Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76AD7C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DD26B008A; Wed, 29 Jul 2026 12:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E6A6B008C; Wed, 29 Jul 2026 12:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7406B0092; Wed, 29 Jul 2026 12:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8BA6B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:21:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DFEF1A0737
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:21:26 +0000 (UTC)
X-FDA: 85042329372.20.8294DBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5BEE14000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:21:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MOh/4662";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785342084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JM4FiXN/GSZDdrwaTNMY9uV5gz3Vu4GPflJilJ5fnjA=;
	b=1cI1G8J3KN1ZD5bl6wdHd9D4b+N9aocpJ/oqNYbdFTM+RRQr3THNnfyS4hR9N60EprcFWX
	nwH3wau/Nqcaqvtm2napYSsmjCadESZqwQbqgdh+1cglP9adM7Veh17Q6P6ravfKSd43Wx
	yBFBuEOdu+dpXkwCNs7BIrDGQEt/Y0M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="MOh/4662";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785342084;
	b=4yIXEAmAh0w5EM5kF9485uTYAX6klwHijgWaAKL04AwRlYz0zR0nMgG7JjUytO/yj+CxkX
	+BZ8Ugkkh/2BGI+WkuRBq2QKs5SCCjeMkDJnxGl5Vj1E1z8FHLvSIiEsljDUN45HIwweDj
	iFGwxj7HXJwX3E2mrMNw5M1689F5iGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C24543961;
	Wed, 29 Jul 2026 16:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D131F000E9;
	Wed, 29 Jul 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785342083;
	bh=JM4FiXN/GSZDdrwaTNMY9uV5gz3Vu4GPflJilJ5fnjA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MOh/46620tT8hSHj6p/BSKgS94jECE/HC4cUhJ+8nmae+Iz9xMIvr1U+hrnfKv8ek
	 hO4IbTNLytAwdbfb6QS7Gqf4KepMbYFy/+ZW7ORJMm3eJPd2tPTfwSHuPSlpBc8CVu
	 k5c32H2Sq2AHvh4Hiyn4erLAtAPrYvj3ScgDWY+etN6t34d1Cgr9WviBAFIRpkc7+Z
	 Vm8LMGuZbLY8p+ymN8vNqn0LQhz5BHcbBBJBacAvmqfVPUYf/6gevXxuxhfE7sKKYj
	 4Onfq6euYjNuPG/n9PLMUIWddt3boORc71rGTZNVj2kyB9fNhAXu32PdY0Y/4K3fHP
	 RxYYHotVl2i6w==
Message-ID: <e5d6417f-5313-4fbb-a245-4f4c3a9d91e9@kernel.org>
Date: Wed, 29 Jul 2026 18:21:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: fix missing debugfs entries for caches
 created before sysfs init
Content-Language: en-US
To: Li Xiasong <lixiasong1@huawei.com>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, yuehaibing@huawei.com,
 zhangchangzhong@huawei.com, weiyongjun1@huawei.com
References: <20260729101849.3734287-1-lixiasong1@huawei.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260729101849.3734287-1-lixiasong1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BEE14000F
X-Rspam-User: 
X-Stat-Signature: ficodaxbz4icyc68ux39g58bdfk33waq
X-HE-Tag: 1785342084-411390
X-HE-Meta: U2FsdGVkX1+H7le/a3GBbQGTPcYYfNBkei5P7QYTsfJ24koVJxwtjDhVignsKF68oIyiDhKlBV917hN9C/YmJ4scKY7PU8626FM8Mlo5/3BOqk+pIUr9+whAihw09346rXL2i9ZCfSHAuoMOtBOzu8zzcDaB9nA09OdlQwt8T/xPcyH7TP8WsOR3TEEb3AMKDtF6z7H9+RSfo21GHgJo1m/lX85aZQ0pev7HcI56PuoiEmHjao7JXYE390ZNqf/hDfX+x2/HXjWT9MdvAe0ZCxoZQ1u5nZW+yS0J0i8LRm7nRO3Uwut0y6MymJ5FiEIs3m4t4fnUY1VPJuVfQqYqaN512tQAQUm/LZqvZmt+8bBE+e9r8Liww8h5YuRHKy72gDQJP0a4ZaPN4tlqlMAqHgOZ7eK9tgFI9juuNecBD3zZOa4Tfq/+BP/KSS7cBFsVg/zgz98aJMgJeRM/5eUobCVEF+8rtkfQmfdFZGPuW9dQUhULDJjB66w9AIV0/9IKSiFqQeu56pOWhoRJl2q2/yDijEgpqCM41v0Hnl8ZtiiRBXro9Q7ir0Kz7uUNhiQ3K0k6mtCZRYLFBAwHeTIAgRZJAyBmpOSws+V0h2P7+ZMMXioJYPUBu4P+IGGMSiWu23yRBXZY8qsiL89YxHrrX68GzvYL0V7TUHpNtQJjjASDfDfaD29+gtCaTahi3tJ8mzFfYPEu4DvQIBay5NPUfM+4Uf3V/d1AZP7RuCSVeOY1iqYIak02JHITvRMSkCjERviTZZWXwKMWgSXBCDU4Bk8x5icirOYLPhVq0Qknfgzi8p7W3X9R9YsYQ/E7+i9sKDPF/Fz1vNyCsFojA8DhcFfMIZiz70k7Y/QgXNnVGgsagE5/0DMsc3kD4lg+bM/BevNu188eTBTZqkxafIpszRswS/2gUe+8oupOTt8444O3jfhYXx5YsGF9gSb9AA5uQcQQshvkzL1hWJ5CZuI
 zDAgm9ki
 uMVbaNUxFCbdb/SkcKcqnOzPRvx4n78wakbie/KhDLtoG27jBn8D4/0JClJu/xcSdFQnoTqX2e7WxsBx3nLdxIZbaFBzXXeauGRmCRORyCZpzf77iBOGWR4kVyxxFNKO0h9hWQHLYTG/6OXaZK+QpcL6dbdebUYy4Cn6NYzNCDYNWQP6kdKB4IJRolvnYjY45+TqkZJJ6IPLm0e3q6UUKB/5Zb5II/aMsFbFmSBi3pHUOyE+fvK0ee/rvoG/QeX90WCJ0ovLhqeEOSRig43m7bb5eDyCApvCTq7AQPi1UDJ3h2K7AXqZtJ2olsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 12:18, Li Xiasong wrote:
> slab_debugfs_init() creates the slab debugfs root at device initcall
> time, while slab_sysfs_init() moves slab_state to FULL at late initcall
> time. SLAB_STORE_USER caches created in this window miss their debugfs
> entries because do_kmem_cache_create() skips debugfs_slab_add() when
> slab_state <= UP. This was observed with MPTCP's request_sock_subflow_v6
> cache, whose slab debugfs directory was missing.
> 
> The affected window is:
> 
>   slab_debugfs_init()
>     slab_debugfs_root = debugfs_create_dir(...)
>     list_for_each_entry(s, &slab_caches, list)
>       debugfs_slab_add(s)
> 
>   kmem_cache_create(..., SLAB_STORE_USER, ...)
>     do_kmem_cache_create()
>       if (slab_state <= UP)
>         return without debugfs entries
> 
>   slab_sysfs_init()
>     slab_state = FULL
> 
> Initialize the debugfs root and add debugfs entries while holding
> slab_mutex, walking slab_caches exactly once and handling both sysfs
> and debugfs entries in the same pass. This gives the sysfs and debugfs
> initialization an explicit order and prevents caches from being
> created between the debugfs scan and slab_state reaching FULL.
> 
> Gate the new slab_late_init() on either sysfs or debugfs being enabled,
> with the slab_kset creation and alias_list processing factored into
> helpers that have empty no-sysfs variants, as suggested by Vlastimil
> Babka. On slab_kset_init() failure, slab_state stays below FULL so
> kmem_cache_create() keeps taking the early-boot path, matching prior
> behavior.
> 
> Guard debugfs_slab_release() against an uninitialized debugfs root,
> since the root is now created later and a cache may be released before
> it exists.
> 
> Fixes: 1a5ad30b89b4 ("mm: slub: make slab_sysfs_init() a late_initcall")
> Cc: stable@vger.kernel.org
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Li Xiasong <lixiasong1@huawei.com>

Added to slab/for-next, thanks!


