Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC574103E183
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC8E6B0208; Wed, 18 Mar 2026 10:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37746B020A; Wed, 18 Mar 2026 10:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7CF6B020B; Wed, 18 Mar 2026 10:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 987FD6B0208
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:15:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47BF8BB381
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:15:38 +0000 (UTC)
X-FDA: 84559381956.11.0E8A6D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A092914000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:15:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njLZ3fzr;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qp/eZxyNzBeNW4d/tMIiFzU5waXAtkp0wLmsHVhqXzY=;
	b=uHxjk/T4e9GYnd/o+ZC1fpdLFUC0RGSU0YmtCepLyGojiKG4O9B7OTf1mQ+4CptoE6Fk+Q
	XmECq/V6dWr7gKwShxSJtWxmSg9CRxnTQmgd9aiMSjg9knr7q51JjtGSZ8Hi1ZXHluBuC3
	pzTo9vU7s1DERu087ImTq0iy3AOTRAc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njLZ3fzr;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843336; a=rsa-sha256;
	cv=none;
	b=EbRruje62HlL3BZogIuKr3qNXiW7AvHqynxAHON0QkVb6wK5qwPYkUhLgTOxDV+KfZVGeP
	FL5Gj16yWIm8mvUc/bY2qLWayEDlcduqwOm17aCRkdnel/BTqqSq5pb8PabbahXOZpYKfQ
	suFVTGAIi9NKnKYP69p7Aj40TPPgNBI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F015560130;
	Wed, 18 Mar 2026 14:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F646C2BC87;
	Wed, 18 Mar 2026 14:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773843335;
	bh=Ptc2QynNW7iyUpE7OZ5J0jXqX6Hrgqnt15A0xLWasLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=njLZ3fzrrLmsX0DHIx+k1hMwTY5SkAcaZvF81uR54BLZ1dsypxged3NoZbA/yhNlz
	 KN55ShOhtdHMyWSdVpcZf5/4yV6NESEg6olfr+t56X9lxv6rSdU7CiQtGoCBiHriga
	 OG072IWvF0y1Qr+uyvxskkG1Kgt/vfkuNF9mHb9T7Ym0rKX9ZlgzVYVK2c16M1aeDc
	 P1YUC6gngIJDYCbHe9B+1HGrTUB48Iorbyk9bI447R/Sj1tFAirTALiuHAZhiJRWek
	 IxKJ+jiJob2dYWg8c9mIidCm50fe5jSEVw4nilL9MUOPrDuKAhRy0Si45p8pgA+j3S
	 g6a9QIUELJq3A==
Date: Wed, 18 Mar 2026 14:15:30 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Rik van Riel <riel@surriel.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Sasha Levin <sashal@kernel.org>, Jiakai Xu <jiakaipeanut@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
Message-ID: <709abbef-6038-47f8-8f06-b3e20d88878d@lucifer.local>
References: <20260318122632.63404-1-ljs@kernel.org>
 <e71acbdc-f46e-4dac-a88d-5b297f518dd3@kernel.org>
 <d1ae6b20-ffe0-43f5-aa8a-9f6056b5ec51@lucifer.local>
 <a90233e7-8dd0-4c77-b048-d84b869a6a4f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a90233e7-8dd0-4c77-b048-d84b869a6a4f@kernel.org>
X-Stat-Signature: jdgsnk99d4gp7ndzi99r161tbwwf3s9u
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A092914000E
X-HE-Tag: 1773843336-648136
X-HE-Meta: U2FsdGVkX19DDcJKa/NysH3pHJU7x4UuFR57HeIIWndUOSI3HEOGX5u6E5sisQUdGPxjApFlffrwiXinvbaK/MINzhZbK8NWZdx4aBgBW9T5219J8TzN1pNNcfGnRFhB7DQG+yKrVsCzS/kQJmTxM+DbbqiSQFFd2pfzPgCxVUzoK6pXCP7JAdf/+xduZGCnTUnKggVRvsNCqrzZE/CiSu9k7AqdjlfokMiW0E830m5ANrk9xDxZo5Jaa0nK2p9zsKRgX/7+P6+4ITP6SqLE0Znweg61k9lEcconLFyz1QXLFFmj/jcNNWXFJqRhDVvu1kj3v2b/PQmZLdGz0tHRWujaBm+j0QdTmBhJKlLj4GTL/rw26FOVYxb/Fi1SLVEhbxsMjY+9orNG3WgNehHj7qlIXABGSNwlcuMU5EH32G3ac9G7up4pTajaWq9fOKYn3csGWe6CF+wJZqDhSTyX7Ue8iRuGteqmS9BtKihMJdDWJBcq9yaRfK1eJ+pfZp53Sqlxf6NgiL6cp9M4jdgNYjhEgAuf+I4Lxg2yfaIkzspr7+kt5c7QFeK33Q0Z1MJmFQItLy6+iLGuvB5uyvZCm1njmf+324VQcDP9qptpTdwmczW+2CvUqTR2DeDglDvmVi+KircpOFqwJ/u/jbpYnEdQE7yFoLQElgZCM3urI7lzLCeSC0s2+ThsWuYCTT98asvAPGI6jV43WdissxKJCWeLKc0L13lj+7ILX3ArKjcXySIdgn9aM65erIYTZOvZsklku1WVODPTi+L1c3ZcYxDB3Gjl7yefbYuF/Xkp9oroqZXzgNIqxnhVY0PqwlqLm1trAgNsnpdgL8EiL6PFrfbJlaNX/4JBT9MuiIkmAiDU8Ky5HpoNCnXOlhpmTNF+5GZLwXeQtReZTJWBP5A+ErL+EaOFDOwn8sce0fytYDZnzJRDozRmRP/UtWDBwS78fPrj9Yr1dyuv9wEm3vt
 y7fH778o
 0LivgeYKPnFZahg3hRtYtKhXc0zz/dR78W9emFUwLCYTrqZxGG2xWW75oynUc9ApInxP38GWwvcnA1KIm23MJYy8fUFIU1k85hkiqv1nY8Q7WAnGlxNQVsVPUwEKEhOkGiK264/GFnTdrQaD/Cz0sJmZqxh4kVHA+0MvSi5qq/cOXgXxscjvbeHkm7L7pJXhBi6SyNBAfDMmW+lpYDlgvbu/ML39tfb5jk4O3X5ZImNoF7XGPrJ5xzce3/zoSce7K67m2dKQ8u1bA+EalhNTvGp8qYda/Vvd+yn6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 02:38:18PM +0100, David Hildenbrand (Arm) wrote:
> On 3/18/26 14:03, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 18, 2026 at 01:52:44PM +0100, David Hildenbrand (Arm) wrote:
> >>
> >> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >>
> >
> > Thanks!
> >
> >> LGTM. I was wondering whether anon_vma_clone() should take care of
> >> setting up dst->anon_vma. It looks a bit odd in dup_anon_vma.
> >
> > Well in the fork case we don't want to set vma->anon_vma, as we use
> > vma->anon_vma to denote whether or not we reused another anon_vma. For
> > split + remap, we already duplicated it via vm_area_dup() ->
> > vm_area_init_from().
> >
> > But... now we have enum vma_operation threaded through here, we can just do
> > that there like:
> >
> > 	/* dst is unfaulted, so inherit src's anon_vma. */
> > 	if (operation == VMA_OP_MERGE_UNFAULTED)
> > 		dst->anon_vma = src->anon_vma;
> >
>
> Exactly what I had in mind.

That's fair, will send a separate patch for that!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

