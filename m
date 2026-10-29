Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12CE606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 15:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dNBXzeZb
Received: by kanga.kvack.org (Postfix)
	id DC8036B05B1; Thu, 29 Oct 2026 11:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EEF6B05B4; Thu, 29 Oct 2026 11:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4436B05BB; Thu, 29 Oct 2026 11:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5A046B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:29:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F9B9803F4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:21:40 +0000 (UTC)
X-FDA: 85376028360.01.C512F78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C685D100010
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:21:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNBXzeZb;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793287298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+9rlXcZZ8g+5YiYdei6kbu9KZrhPovwLjwJuy+h7zs=;
	b=gLh9yQy7H4ZhfwTo7QkKevdmUPXjV8Eipxr50ilIm0Z/bgCDKR5VYJ8i3CZwYbOeGEb661
	OO9hFVjcn+NeZ9QvJUITO1Y1VLcjBbDi6FIQ9KE0vG0Ke06Al9eHJhk4RkiJduDoIWXsnq
	SmJ2YrqbzX1+9aZjrMOpQzH4KuVGgHc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dNBXzeZb;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793287298;
	b=guMVlxcp86QIcvvTaWcph3K5i/r6DGJMC65LlPVbqZ1yySoPztjTbKIv7LKwdjlF0iKi3y
	ITFcQxtqn4tLpn6mMbppvKc3lX5hspZIkSVDqL4Fel0nxVzPtDw7QBSGoKDNZWQFueltfG
	ua/I0o6IY+bhXfnYGzXyW7xlJa1VB8g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B403601F8;
	Thu, 29 Oct 2026 15:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02AB1F01816;
	Thu, 29 Oct 2026 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793287297;
	bh=B+9rlXcZZ8g+5YiYdei6kbu9KZrhPovwLjwJuy+h7zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dNBXzeZbES6os+Zzxui4Zil8McbII2bpInSLLpLPFqT3WfE1SIJWJYlObDU+BBTZK
	 Gh6iiURODXPC1QRKVZDzmn3d2LU4ytwmxhfM/FyYPCluGvotplbNmJDiavNEB8BxZg
	 +1SrGz6edGBVHkAxzh1yNgQ7GXB6jzVpbOKR0CruZsbG8blRbZUgNhMuMqVMLZ0upW
	 4DaKpkJS0gyDiFy/06rFV5JRjs+2lcqXcfUoeBtt+BpZ8bI6wKGaV3VinksrsvCJN3
	 kfTb1LDe3Ksd2U5r0eca1UJBICmH8/eRDhOGgTcpzj34W5HOSotrHSBF93Iu877Z8i
	 W2csXA5IB2N2w==
Message-ID: <de5cfd94-279d-4640-95ab-97f44b6b9841@kernel.org>
Date: Thu, 29 Oct 2026 16:21:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/8] mm/page_alloc: snapshot the preferred zone against
 shrink rebuilds
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-4-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261028211930.3504634-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C685D100010
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c1dpikfr5krj6fcfuoin7n1wkkx1ijqy
X-HE-Tag: 1793287298-876230
X-HE-Meta: U2FsdGVkX18Lwt1bOLUgdlH1NPKQWaeVVqu1yZxM7JY0xfL6jSpCB1X+z4/Wtc0IofvRQL559tB4ICPMXGof9Gmfb0pjh5tbN2tpcU9lpAbU94bPkorrFE8QfAGDbjHp+Ry55tD1rz93NTEMhJbOJPGRWiVsqiJL/8vsnYCNvNaW7Ct6YTkEkZA5Dlmhna/IWpaNUk7qB7VzSJMQLs7RFQUztOXPzXhSQ3AxFrLmOft5JaaNE9QD8p4BSiREKQFOcgFtdyKCsxz4o1B2dFxYiY3UfB4uGOmj/0Sk9mkYvKFqo5Mrd9LK9IywVh/vLxcu3U956afhPk7OvCOErmAaoTFJtq0VY4cHLGpjpURAT+Mv6U6QR+piA5vCMVuZw2Xagcyw7AXXiqsZ66Q+a4AtpDGb/jaJwlYrftHGzaokrz6ZyHLtlj6gdi8vEQmYfeYKhLtBiyZXvnbKts1Y9EwSt/k3DeKABpMrOPiZ/biizOtFGj1uG/ezwstqnH8jdjqEJBV4+O8DI48PpUOygwhEDX+HZXgi4XuxDuvHaw+LRifHn0vC9VJZZcsJHu+enNyznuknQOYgf0j3B4emWDQ0T9D9d0z3Ka/IUdD00fzo3Vu/Ih8Fc7QqKu3pYCyGrzmSXnPdKT7wiC/bfb9+FwWNLZH99ErSePhko40jIWZC4YW8gxULoTbFlRDksvXEvowuDSzBElNplv90flWRYrTnxReAfybEPEPwnUwxYaYHezbmvlbGooOWINWf7NTYRtu5Z2iqqDqILSFB7Ry34zNPGllcjme/67WxbvLA+MJkdTifLODsq1xnuMW/Bzdat1zY8TtBPxPt3v5GzLOqEMzcTG91qaFbRpY5ByH6gOsN/n7lWotdUCnrriAoWsxjxnFRkeyKL4XNuraJpUFw/6lOICTxOv84M/sSYn9gINxdP8JhKriDyoXFpkBqXSEUt2w+obcPfH0m9dUBnGR2EYS
 ixjb05dR
 o2sbImlIl/EdkRslz482eR7SyKRKOMfp7AXezL9cXjU1JeNWX5bH+AeKWmddpUhkKf8uh502ftajfEYIAqjhbGcZIKu2wRm0MPw0fRhZPCldGdYILyWw6SngeATeQ6LkRgQuLDG0CslGBOGmdUXsK9NdV+FhJZ6lXURcZJhqqEEbsXzd/QEktuuWnN4Xa32ixrGQT0Ct+/guzOgu+dqaTydBveDJN2vhOrm8McjuIL8G06uw/hP/X9ayV4Y7IX8WTyuQbrOsbFkcbuB+do+HCi8cnWWhXuAwarfxDtEMevX45luWf4GZzMOy3D9MOKhZnphcJw9xUM0NrlwvHTLuPzoFKi0jAar317ySaGXDtH+ghDGgvczt3vfPPm5ttt3VPHQx9Kg7qKD9C4izMYKsh5Xz8G9K0MlEo7e9Oc2eJFkMpeayDm6eLBevRoC1GrYCbjX3syaaUVvk9unTspj7I8AXAbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 22:19, Gregory Price (Meta) wrote:
> get_page_from_freelist() and alloc_pages_bulk_noprof() reread
> ac->preferred_zoneref->zone at every use. Offlining a zone's last block
> rebuilds the zonelists in place, and the shrunk list's NULL terminator
> can land on the preferred slot mid-walk:
> 
>   CPU 0                             CPU 1
>   get_page_from_freelist(GFP_KERNEL | __GFP_THISNODE)
>     zone = NORMAL (slot 1)
>                                     offline_pages()
>                                       build_all_zonelists()
>                                         [MOVABLE, NORMAL, NULL]
>                                         -> [NORMAL, NULL]
>     rmqueue(zonelist_zone(slot 1), zone)
>       zone_statistics(NULL, zone)
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000060
>   RIP: 0010:get_page_from_freelist+0x6a5/0x15f0
>   Call Trace:
>    __alloc_frozen_pages_noprof+0x125/0x330
> 
> Read the slot once. Zones are never freed, so a stale zone is safe, and
> a NULL slot fails the same way as walking off the end.
> 
> Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


