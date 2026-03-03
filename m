Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE978EDA68D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 16:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1236B0099; Tue,  3 Mar 2026 11:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A87D6B009B; Tue,  3 Mar 2026 11:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6936B009E; Tue,  3 Mar 2026 11:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0B96B0099
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:04:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7F32160252
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:04:44 +0000 (UTC)
X-FDA: 84505224888.04.B155302
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf20.hostedemail.com (Postfix) with ESMTP id D76071C0003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:04:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RDJ2rTJB;
	spf=temperror (imf20.hostedemail.com: error in processing during lookup of ak@linux.intel.com: DNS error) smtp.mailfrom=ak@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772553875; x=1804089875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cGcX36y89/T5vL/Y0yMIMgZb0PkX0uiV7XGDgPPHKf4=;
  b=RDJ2rTJBCWlqsfFHNqkdOjYDJX7VL+omfTqsBmSIYP151jKMeYrIm8A5
   EPFRD6YdScVBX5WAONlUAcUg+KhktZXeAQhpbm4Ipm/6+SgK59pTqevPx
   9Z18J5LNEgOEmIPqpT+I0nUq7jr4RTsm9eRDw9srraDakDqWdItSIvsuc
   dKYME4+dBIYGnlFWpggldUOFfx2Qq+22U34PHpUKaLt81Q0lIC4KpBDNo
   8489zqBIfnv1XH7C2heSvocwIp947kVBJG2DPd5l+T0LKrOd0aTO9KLpq
   +2qMXiLDncHkWE4OsI4lt9UCHmtYMTdnLCWNg2aTGA59jZG2h04EZrim7
   Q==;
X-CSE-ConnectionGUID: EGLvryUDS/S8C9ThezWygQ==
X-CSE-MsgGUID: 014qxXebSPCbYxsc2vGQjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73467241"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73467241"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 08:04:29 -0800
X-CSE-ConnectionGUID: Zo/HjMiMQ7e2eYOCpmhHlg==
X-CSE-MsgGUID: Jaa9naE5RYGFfdmQiKLS7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217279773"
Received: from tassilo.jf.intel.com (HELO tassilo) ([10.54.38.190])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 08:04:28 -0800
Date: Tue, 3 Mar 2026 08:04:27 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH v2] smaps: Report correct page sizes with THP
Message-ID: <aacGi1DEZoc00Sv7@tassilo>
References: <20260225232708.87833-1-ak@linux.intel.com>
 <d2c37aa0-ec0a-457a-bbf8-4624cdb8074f@kernel.org>
 <aaR4y-lCl7YPEcnX@tassilo>
 <af715d91-6d49-462f-9e9f-3a513ff2ef77@kernel.org>
 <aaX2B9Efh0dBed6c@tassilo>
 <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a08a249-211b-40b9-b6bd-7c54af2b9d15@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D76071C0003
X-Stat-Signature: fktg4bpidnhfndtz8upcrrdst6oc7j9c
X-HE-Tag: 1772553874-564971
X-HE-Meta: U2FsdGVkX1+zu6DnHfqm9X0u2vDwubY3QlGSK4mFnJARTex8aLbbcS9xz7eC7YQInjVTqBOWrn1sdUGYdkdAS147PoevhEKOYxj7Su+Fmq72vcY+03Mw5nYmpclu9/gG58Dl8zQB7aNwRT3RK9ktxKu5ok/+gk86lnHkzGJXwBG6u1kp1+1gzfsai7Wbhv7NkVxeW2pDgX40RftC65ifIJ4Us3smKgbDtQ7GVwRkGCcF0jKI7/8GZii4GiwAuAzJE2tAkLNOKa2UJwwsyI+B5CK/AIEcQT0EzKLDAmd47pLppwzXFvcNK278YNNjD5LEX3kgRZJh90H+yxHKbs3C67ZPkvnAWZOILK05dtAMfwtwGXejZzf7coPcHJuVeHSu7r9xu8LkFoZeCbclYFUpnDrwXsU/lUIJxpveENuAXIdzLBgFkpK2AedcfFNZ/aU0/2bP030e/BdvqRWA+vc4WVwwFDRpp+tt/WXA4miu11ZI98+AGmHKc3MuZFTzO+Xx5ib0L0FyWIBNtnwaF7op63oJbOCDVHLKuiIaGyRBdTSfNOpgcZpjbc1h8E7HjjaS+loOBYyYXxaJvufQyGpTmJ0l9kA2IZRpZHZN425r0PYquxULcLDEIy4v22nMvJGFWcLnbuhx+fpA+tDjOhhXGPafCXbd0JxBTsd6nHD7ZaD+SYYgUpYUutdHJ1mMjFmF5jJGzELsX0nrKDMwuHLu+DJpGMIsTWk/QGx4XmUjYlHDQeNwdLyIhPpufLenbKYmI7E7aFTqFASTHYXDGFZGvfojqqWar2lwc4k7fzyJgw626p3x/U36EvbvMwqROYxQeOfue/h+kBQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


BTW your comment earlier about partially mapped compound pages made 
me reconsider the code and unless I'm missing something the accounting
is all wrong for this case anyways in the current code.

The code currently calls smaps_account for every PTE, which will happily
account the complete compound page, but this will be repeated for each
PTE entry. So for the mTHP case when multiple contiguous PTEs point 
to the same page it will over count by the order.

This doesn't affect page size reporting, which is idempotent, but 
all the other mss counts in proc task_mmu.c.

-Andi

