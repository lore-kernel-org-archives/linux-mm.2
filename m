Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64520FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:32:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13546B008C; Tue, 28 Apr 2026 03:32:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB3F6B0092; Tue, 28 Apr 2026 03:32:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01086B0093; Tue, 28 Apr 2026 03:32:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF8DF6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:32:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45F671C0535
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:32:52 +0000 (UTC)
X-FDA: 84707147784.23.932E86B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8DBE71A0007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:32:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KS7VVKWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777361570; a=rsa-sha256;
	cv=none;
	b=O9ouVOgaphWEuyH6ed+qN5Zn1hjbnwGFX5hQNM4OpEGrA3YdJRdOpmqz//6YMcdwguCe0g
	h1ohrtOzhf8IrAfub++4oNGSxnpodn9gW/v0gX0E+YJzRMugVA+ZVyehsFVXgtORDcnz35
	U8Y3pOot7REz+KBrl6dZUIaZ8wtOeZk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KS7VVKWJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777361570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k12cCujQ2Gzo3MspddaiLfy8AcAN7OgiJ75sz5W+vT0=;
	b=00PGzJVQ45Jfl2vdyvoz12YjCaU3r1wwFrIb2xGjtjY5TBshth3TMGFwWQgHxZT4CjuI/Y
	WQdqLpUs7iGe8QM1Sm4f+3XjY5A3VIktziVnBVibwsL15E+jEeqpnZbJTCSBKfy77ELp6n
	Lj0EeQ7UZpfGIiQ7wEvwpk/5E00I9eI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 161C4444C1;
	Tue, 28 Apr 2026 07:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE54C2BCB8;
	Tue, 28 Apr 2026 07:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777361565;
	bh=bivJkrDnkum5vfxFBGBfafZmKUqFTGG/gO14qECezIs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KS7VVKWJYg+OP508UYe/zMGahM3pGjCvFKJNFgui6nFLKxhqcyUTWKExOOt/iPanR
	 1kpLWf3iizL3uPEkGZDnNELXdYcSQmR2QOME22VyoIok8i+xmr0YrQ82VEzaqP4hSd
	 kRkad5IRChKSJvPXOs9HjfC+HvNs2zfMj2hjHJXF8XzM/c51ES4I1dWBRptVLPgF9+
	 J3JdUsgduxLtmu8U4FMz4gPuVsoijnN0Uc2lZZHHNSLm4EJlzt1Juucu6EAMcKT16O
	 5IqdNjee3CXQ3PJCrp1Am+EErSqQV9mjC24edo3savF+AJDqw3zjJGobF99o8doFuv
	 ZWBbcOfL84Xiw==
Date: Tue, 28 Apr 2026 09:32:36 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
Message-ID: <afBilACQByFLa-hi@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
 <96DB49C7-A7C2-4F53-8321-FF4A4ECDFF95@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96DB49C7-A7C2-4F53-8321-FF4A4ECDFF95@linux.dev>
X-Stat-Signature: amk9wzi8oxko166bzbgf4wageu6zmf8e
X-Rspam-User: 
X-Rspamd-Queue-Id: 8DBE71A0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777361570-790545
X-HE-Meta: U2FsdGVkX18Sng8vM70RftEY3iJ2lP9yluTSawosilDbPcCrvbye5QnUlz0MaFLUHJTRC702lzyDsAlpba63pjBibxcwqJCVchu2qDayFYaXbW8+lfz6DQWFtFkRiUnOSv3XOEV996KCb/ET+BnndQuEMeeUrDVEkj+p7pD1y28WCD2FA0idCK6nIc0n4q6GonZZsWp6iNHi2H4vYQDpLZgnkEgeWY3PcS9sha+UgMqwnxPWRE8puu/asK6g0BX/HZ5TNV19DI+Mn/1806yZkBE2niJrN+SIWyJd1nzC9DgfCIXPT7myjCjdEFT8rNSdRQq4jUphOoIl8uGdC1YkeGe3GvuwAwv+7gwx1g/BXrSajkej8z2dcAZV/1pd1UEln6t7kOCXYxx9FHNMXsTxm5fSvvPBC+VJQdwqaOTPxIVUdrJfxe8yfR7brIptd1xBnbd7G5+WFCN2C/drjofQQvnuLqOLx5ROWZiXZIFW1GtuCpwtrOKmxSFYyEt+U/ySshKQzaqBns8HTOjj6cQEzBa00slQUhoC63m9KyoTF+NDF8duc2cRTUllS8I5etr9R1Fa8EmKsUngCiqFOCkapVxFXeMfcKVJ0utHM9lr5bLxGIaDH+Gz0v+uLm3PvN9+GBBAGDP0/7zDfHGqBxom1rtgGkz1cK5yzqa4BB1x0XEq/w7XHvPOR+4Wuqw6HfBc3sU73pZo23gTZeEl+4BrN927tSfKI1zknhVcLQEG/7K83bMtOh6bA78O63+hsamXC+GQa6UK6BTwbbmZ8yLFW3/lP7/yOKzdGA9J6HEip26FFI3i7o7u77yUzf86epoadXxsNVVk2LIG9n++3t7RglhKLUGvqO9j6tryNjs/xlkgKfFkInl415jNi8KVSrLnXFOLmH0zIEe+cMstxDbYGiEARkamdT1SWPDWKeA8lwyvifnpoaNEl3pp/zenxdt75TwHSzKtbIKVvYwP4SX
 VimsrjS+
 oNBiT7IwP9sr+ylzejIHgNg9PVUGDhfNPRdqmQl61PFVtIXgw/GmuwTPCyzc1IHpzQFxARwO8BzQYohkJSBVooxElPOl+6g81juIV2dL/EKuqQDfMKw3b8gnHCLlQXZ5F7iF5B1lbIZ/fdJHXaX9EtInmt5DFIUTRpjRMmezBPcyG+Gmr6HtnBkaSudcKRsc+VXeQj2czTCeLXcA+GF7oQIBFqG+RZFXkuZhImQBLSHIT9bVbuqJ8/DtvqAW76uRP/KOO7KNQUFalmEWQTjABRZLvZMOD697f+mWYIwN8padzB/nqJ18NBaak7PfDZrecy+GnliaHei+i/sk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Tue, Apr 28, 2026 at 03:02:14PM +0800, Muchun Song wrote:
> 
> >> diff --git a/mm/sparse.c b/mm/sparse.c
> >> index effdac6b0ab1..5c12b979a618 100644
> >> --- a/mm/sparse.c
> >> +++ b/mm/sparse.c
> >> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
> >>    unsigned long map_count)
> >> {
> >> 	unsigned long pnum;
> >> - 	struct page *map;
> >> - 	struct mem_section *ms;
> >> -
> >> - 	if (sparse_usage_init(nid, map_count)) {
> >> - 		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
> >> - 		goto failed;
> >> - 	}
> >> 
> >> + 	if (sparse_usage_init(nid, map_count))
> >> + 		panic("The node[%d] usemap allocation failed\n", nid);
> > 
> > Please consider using memblock_alloc_or_panic() in sparse_usage_init(), it
> > would simplify the code even more.
> 
> Hi Mike,
> 
> Yes. I have several more updates for v2. Please hold off on reviewing
> the current version to avoid wasting your time; I’ll send the new one
> over shortly.

Thanks for the heads up!
I'll stop for now :)
 
> Thanks.

-- 
Sincerely yours,
Mike.

