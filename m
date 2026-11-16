Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED67C60A2626
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bI8+6lYl
Received: by kanga.kvack.org (Postfix)
	id 139F66B05B3; Mon, 16 Nov 2026 05:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112766B05BC; Mon, 16 Nov 2026 05:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001E06B05BF; Mon, 16 Nov 2026 05:53:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0EEC6B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:53:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66CF680913
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:53:11 +0000 (UTC)
X-FDA: 85440670182.09.51CCA88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 70236180005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:53:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bI8+6lYl;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826389;
	b=CSwCr9D7CbLrE0+HanUAqeWLapWfQ44muIdJylvtgb1VdN9fbjM3G/BpkX/Eehcg+NddOo
	5ziOBMnLuex2Vc/353g8o+JbiLTrlFJPqWta9c0Z0xNcB+plyIufrtzDFf6nSRsQTgpYSE
	MDyXznAXOJhunI1sIWESmcV8WYee8mQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bI8+6lYl;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsVyf/Eh739256Lt8KexYgfuWst8mEdj0Tcojks+JIY=;
	b=WUk2W4i/DtkhFrpeX5lVJM7cVuI/hXewM2RKBc8/7KFojQJ9LjpBcOhc0ZOtmih2yG6RH8
	L4PRFiIwLwBmzIW3hskoC7qumPvfx9atpWjIP/SC9utS1COeQMGMKSvPTHn6/Au8hZ/M5G
	xtckVYtD5Ys8LttzjRmWjVOqZJDCAUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C53D461FB;
	Mon, 16 Nov 2026 10:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72CE1F000CF;
	Mon, 16 Nov 2026 10:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826388;
	bh=NsVyf/Eh739256Lt8KexYgfuWst8mEdj0Tcojks+JIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bI8+6lYlyuFNEvgexVeFAv1KnceC/KqVyWEJc6Fg6ZQ69oVcXbyKBkrbWP7LBTdUQ
	 UZ3D1NJv1uVPo88zLRT9VaY5QgamkNcUOjwi17R3BOYH9eit4krVc1R3+1TAGYuAK4
	 E3J9UnK3xE9d3F45zZTYJioaSR348U620yQxrdLu+MW80+HUd+hYjLe8wM4VD2/b/1
	 XkSBs5qFaeHm6oQAdPzcMvzf6baKwkCgNgi3NgnTLweEW52b+TZP+gUN6ORubajShc
	 FO9C8LsrjC4M3/UnYL4bSSRA0DTCbIeXFcRJhCCfS0pzz6UkXZREnQkpMlpcvZVRbA
	 RhJAqJvSx95cg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id A290D198003A;
	Mon, 16 Nov 2026 05:53:00 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 16 Nov 2026 05:53:05 -0500
X-ME-Sender: <xms:jOD6arHbBDpbSjMbSvRFccO32RM4SCBWpqPS2PjvHSb1SWgXuJY9vQ>
    <xme:jOD6amyhD2lOcKuuXXKDbwkxoy4aKDpfUyIJW9FyO1EfjXc2R0zcL2XEacDOXyPHG
    q5oXon1J5EN9xOsq_2h6yU68xtX1Qym7FfemeFk4nwPoDPSRqQK1GYq>
X-ME-Received: <xmr:jOD6akRKqz0MPdSD8kNUrft2CaAAFy-qRx7xYTUQAGHBkyB_GrAdbWNmj7g>
X-ME-Proxy-Cause: dmFkZTFG5jkGbtKQz+KGXv6DVcdUEvWZSsyE9ahIjR2txn73RzTRa9O7nCYJLLKho03THN
    kIcI6bk1JWvKgrACd3MeIyH/ItCs5ocrfrQlgBBAtTK+8cUnU9dva1V94OFKzYh9Q45wLh
    wgYa8t8gWpHZTq+fMVNAzFXuPM2oWMKFirGFrX1d4bjjdlBDjZWOLHk6xQ1UOgE19k76dg
    KMwcoWXsLpaqsh1YNLfxGlzUI5Lf1YABKNxKfHVQfhJ3fBiwYOpRnzTIaC1lFykVWNp/lc
    eG8T/kEyhaU+f0dGoSCn7SwrEFm4dlwZZDTny1YZKQVkn+D5ZxNC7jiBTui0awWbf3GiDJ
    66dhhCq+9NInds/qJRYRfX0u6DmEQR3Eke068vTtjJDhfc6x6h7q6Zfic1h1KhN9c/o4s9
    fXGNBVCthuOuFLhGB0mCC1lVdj9F+EzthsJCWrSnqM8m9WGSR+RTutZrnwPJit1tTtEi2j
    mDwaR5MGvGHykZckIYpdhXxPg15jad9RPHS+ek702xHyrPI25/zMwezMComYrYLqFm1+0A
    eMtn0gk1Af+8uwiHHandzEFqWxl2B9BA7i2mO0wJavaKFX1exmZRSZi+jobOLhBULyakYw
    OI+SIuCRTa5nyvu2zNx22SirO/dSsJNQjZfOzwa3z46IiWQwGOAbP9d9923Q
X-ME-Proxy: <xmx:jOD6asprkkehzNqaCaLAhLutc9UtnTp6gqRXSfdzVE3ZijSoaqfVEw>
    <xmx:jOD6akt9S7LsRgqeoXBV4hY_bC0DBxO4YIMur2oktxnkch36whwsNw>
    <xmx:jOD6ahtwexIrbav5m1a-df-luGcRQcIi05tkp9yTRIj9-WvMl0IxiA>
    <xmx:jOD6aoqwWQI7tNz83LxXoJ-JHIaKPZCUJgO7uO9De14R0KJsuTUN8A>
    <xmx:jOD6arELcjIfTmIVVKVcB6A3NHHtsFPzlD8Yz9LCB2vMv6C12kQRAsj_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 05:52:59 -0500 (EST)
Date: Mon, 16 Nov 2026 10:52:58 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Message-ID: <avrgcyxYFBd_JHrF@shutemov.name>
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
 <auynaZkzdzL6Aeyo@thinkstation>
 <avTEezDIsJBhsPmi@thinkstation>
 <13c40a66-4ce9-4d9a-801b-a3debfecee22@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c40a66-4ce9-4d9a-801b-a3debfecee22@kernel.org>
X-Stat-Signature: d5a6uozmxwezr77k79x5q3g5e7sjtjxk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70236180005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794826389-551249
X-HE-Meta: U2FsdGVkX1+FXFQQ9fnopFcx5Dh82eQXQCRPWzTeSLG257+o+LrP1zW6HQoTcrSxA08bMFx20Y+BQO1usdeY8i4gyr+jy6NtJopr/M/K4lUpMjS8Ek1VJ6cXWfymLS+SoV6l3uVsixsEUvZ/3GCBZWq68y5oHXQqWIEL6hJ+/hkCTL160GbI0sDG4AOd8IEgliY3fZxSRDdx5T5xdlwigTicmwmKI+hCvW5IwQWMxOm6B8K4emK1QzmRk7MnpxzV39ukvcVQSDFRKrHYxMn2T/RKOEbGrDRbvWEwuA/IKEkhBt1Ad563hxwjwqUL52FsdM59f61h/whv9E/bX9y42eL62IoR5ECUI0o0VmBgMQ8u0M9Y9KFas4fo07EWm2tKuUvGAHL5DLLXPXnvdWWymoVMRSe7b3aKZ1NLihAY3Ld2WxOS4hWb45GBAhe2ahCn3nVZumytYmC1Z/rcxPXzSUqDnUHehI9/0VEqrSxW6BadlsH5pMlBx3ahCP7mnFT+t1Uo96cARo7OquzUvFtJHfrV7S+pvPRQzj8ok/0K/POTokNL6x6Wt2Z6P/K83Gtu2AKf1b/DDsyoCBfnK31AvObv8whsV7SCg83Bm2uhxz1FOmA1CMQPb3nxdQ27MzBSfvuK44DmZW+IU5MCX89WE2uGxIPI+6FvO/csBPY5bqpAJfZlvalMLZWEYGjMLlH6gppQ28V5HC9IbxEalZ7otHzyh+awewWHbeOYnmJ87xyPjnqz8lH/8YyB0q8xkKqACteczZegzT6evwYvrHm3TLR4NXu18rc+dM2Hq1j3XQQCa4D27YUVMYUr7LPPa9WAtbP7M9019/4OAGE8sw7rQoit5oCa5YXhgH0ISSnVbNSwK8uKmAW879HTANetAQuGeHZcx5GVpLNirLirh2QemNBZ2mjlvM3Rpqh4TbPD5p8ty/z/g2IZFwTy96uuJGPrdKpN0F+O8np1/jUVYiz
 VKeshSib
 /GlBgO0QZfNU9PhS8ZpM94dVXxYT6RaFCYL7bCtti+zx/AhZcpe+LXonlQUCSLETUmLO1WwvMXU4Ua+zaAIm4J8YY34UvwVOOEcmMAIf01cDBTaYEy3c1bSetCZwYjCakBJAaAI1fs5w8l+qTgjg+NGNmSjca5o4GO7OG0rWWKAAFTG2tzeHCciW1i+CmAzpCnWJC9heYrlbnJnQ9q3WaZ0D6XfhqrICVwuW6kIT7MVjf8hB3qAyY/La+mQLQRgaEvwl6dXvDafZZgrp4QZxsuliod0uuq88NJHSRp9PIOOWMwONQzlfjoKgWjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 06:03:00PM +0100, Vlastimil Babka (SUSE) wrote:
> > Looks good?
> 
> Not really :(

My bad. Will do better.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

