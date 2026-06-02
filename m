Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B68FCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050056B03F1; Tue,  2 Jun 2026 06:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001336B03F2; Tue,  2 Jun 2026 06:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E589C6B03F7; Tue,  2 Jun 2026 06:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D44686B03F1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:35:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76504C2B84
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:35:03 +0000 (UTC)
X-FDA: 84834614886.19.D3EC68F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1113140009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:35:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1QPNacF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780396501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHXix/NGhOLLtCdUv2aad3HZZ/2TZlL5M+MCPpjSxAY=;
	b=KDVYBIv9qRPcquG1jfIx4RqNFU3hzk34HrcEsqFHTuVCTQpauphSe1yBeecv0s5K1DonkP
	7KHcJwd6CbfHnDBtN8MG5Zv9inGMIUq9FgdaK3zITLOlXsOPANEsp37BDkopMZkJ/3TSxJ
	vZ55BwlajYsxsEq7zTxSPerWTIktrA4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1QPNacF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780396501;
	b=h7nkZkGEK6YfGcUl721R8yGMsVJ6+dpUqOGmx8zHENd0w6dHUXO3jzleydr0RJVPPL7mHx
	o6MYtRPApCTcK5qRFul98fFBVrznaVQ937YxfmXgcK7hung8EiLNxk+fYsq5TAHMD6hfE8
	Pa6vP3SHGx/Piq4UCrbAr5xkTisAHh4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5ECD460123;
	Tue,  2 Jun 2026 10:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9728A1F00893;
	Tue,  2 Jun 2026 10:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780396501;
	bh=NHXix/NGhOLLtCdUv2aad3HZZ/2TZlL5M+MCPpjSxAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A1QPNacFkmg/7zJxu6QOoX2GLYdw8tN33sDhuF92H1qLfcTPze8uiEv4QVMkInXcc
	 p9pu34+MWZbcdPFg+NR/XlWuMXNpzYreR3Z3Vy13x9TyTxX1wOL4KAu/35VBLtKoBU
	 TZc4gZLNF0b9luIcu02EYrIcomeY+Tg5+pJ4lglUn14MxH8riPDALVgjqdj73Z269B
	 cqEHsLPfk/lTVJu/4H6gr7Z5o6jTnxyrJfv+/rUVctLv+Yd5h5I5RDvcLqKk71Pj1f
	 trWavw/23hF66wXucjmfX+h/dpFh7Dtyuum8smZ2OghhDhLGP2EioJab2DJwURImTf
	 eWBZ+7zJk6KQA==
Date: Tue, 2 Jun 2026 12:34:53 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v3 00/19] mm: Refactor bootmem gigantic hugepage
 allocation
Message-ID: <ah6xzZBh8IysNXpI@localhost.localdomain>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E1113140009
X-Stat-Signature: 44f34nd3crfj1cgjgf1dsfsiat17jysm
X-HE-Tag: 1780396501-850017
X-HE-Meta: U2FsdGVkX19ljIeXdD6FuEOEe1mUeqTLER7UTmi2U0vLzdzsqpew27D/DcHIDzpQfZG9XspYGmnFIUBruTYIdYExSQT51mo/c8nl98s2STuh153CPKCUDcNJBYA4VWSjzMj3+Ya5Zdvv8UBVAKL4Hv3ud3TIzosdS3Ffekncm53HFhy5Rcn/IWWBdED15uv/+2GIiJs+LKIthx79OMdMbtn14sxIBemBS0fyIODFlZae8SvzewGodAW8yfGI0zhk1aWnGSXrnsEOZlqkmosvqrnqR72A4aKVtFakgDyqAzSRl7AFnvyhbHVi4+zFvbCcMUdTh26ycAxyvuwBmJOZ6cKwgnAo3JIXahBIuw7ecLMyjQZcuJ7YHUtdOVJSuEsTJYeDZVBNajJiKhY/zs/bGA7wnfy6p3idSwcwaiHer9rJSFC+z3O0Qppw/85xFgJWFuYkf29qPzyn576UGSrzqUsitBLJk1Qx+maL5Q2V2w+x+xIuWnOQjJZLE5ve793H54N4slXNLIdB8ucgPdtuFemsmFCfLZeJNMNUq+eLQpk2eElH9JnwKdObIr0dFoA+wZmE1DP/vI3BLrPz3xxmqFpwucAwwiaQAy3MTlodc8Y35Cc8TPlqP57IGWs8WAPeXowo2/Z4HCt6BBYlA1tPUznIR+gDDC5OTj/RGJ4wQqfcETUXNd2EIAmznaJ3gSvjF56XAfFTHvcETbNJnOaB5t5joqdbiyQM6RArpyOThQVO9uhKATEtir87FYVgqnXa1ewTeFVoViobr4hF8V/jENeGj6HWKA+3zT0EDhyxcYOf9jYM7ScUGZx1AKfa/CUMHLifIScQ2XPGwmMra4f585PIySiaHBORl5bQX3uiX9dnh8vf5pbX71A5DFz6qrWm4XHyqvvVoOe/AJhlouDW6UBGgOES8J8kZ4reYFWHkECigmpQqScGg4MiSdvQ81bsHKV/19kapgjU/bX0lR5
 4XVwLb7o
 nFNws7kkz1EscaCx7A+uvMFVlbniJ1bkdxXI8Vfhld6j5doqKMMtv2RwFdSgcO4Q08p9ygfc9cy1ecG2tQy23BkkVG/YzkQNPencUfHMSfGDsvWcQrCifM6hFgu14Rx6LvE2bIhH/ItB+0/lFYU/ieNw/jlMkXNgX/PuW8+zUT1C0hR1y076zk47qUnxD1ibkosIDbA0Wp6Rs6ZAEDHbA2wMAyO+rSOOETC8taU9IQyMNMhY+wUppVIu3i11Hm+jxpvmlE3JuvdxISRVU86Y1x9H77YRnGBmEw8GO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 06:10:20PM +0800, Muchun Song wrote:
> This series is split out from the earlier larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. It collects the first 19 patches of
> that series as a standalone set of fixes and preparatory cleanups around
> bootmem HugeTLB handling, sparse initialization ordering, and related
> vmemmap setup.

Thanks Munchun, this split out really helps easing the review.
I think not so many patches from this series scaped review, but I shall
get back ot it later this week.

 

-- 
Oscar Salvador
SUSE Labs

