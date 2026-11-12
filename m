Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 310FA606A334
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CXqmFHQT
Received: by kanga.kvack.org (Postfix)
	id C88BD6B05BF; Thu, 12 Nov 2026 14:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60C56B05C0; Thu, 12 Nov 2026 14:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50A26B05C1; Thu, 12 Nov 2026 14:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90CB66B05BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:05:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 022A2160A79
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:05:25 +0000 (UTC)
X-FDA: 85427395452.21.FB29E33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5D79B180010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:05:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXqmFHQT;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510324;
	b=4XYW9aC2C+z/hyHLuQlyzzetCTuuAc4r87l5lRtPnsjExlJnONCO0IldfuoG5hIp5LxUR3
	t1QdwK9j1J1O2G9tj15TZaKmPkcDZk1pC04qB4B+Sbi0jfj7NqKjRj2qiCu4dDfPT6YNbc
	t2/95awOnsV8NsUjDwdH8qs1e8Nm2U8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CXqmFHQT;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DlAcOR69Sgyo6744hoqwcMZzZ6mU9x3ks7Z3NCbX8Wc=;
	b=uE9ZYGnTnMk+QPyjVbK0nVDz/BSL9yCAphpoZdt/uHP4iCxXzMoCmxiD5gVA6ZSIkTqbU+
	osAUvx9YEMT6oyqoyZFPfw8Xs8/OsDf3xxpwORO2DCKWoQCGcIhwphTcl/R8OMtg/TNMJn
	/JLqgQUPshZ6dWQwrwNyvkSUqhhBTSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84C654037D;
	Thu, 12 Nov 2026 19:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C601F000C4;
	Thu, 12 Nov 2026 19:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510323;
	bh=DlAcOR69Sgyo6744hoqwcMZzZ6mU9x3ks7Z3NCbX8Wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CXqmFHQTRmv1gRj1r+pYbCbA8wHqWEzRRHyS8pfqO0TTrL+uMJ68pW9Cw4rMuUyUQ
	 IQZ9fs14ahUAid+leUsj9RpRJ3nno9JfuWnrJf4xVpTNsMk6APV19c/Q1+165+I4h8
	 ZxKs1t5LsuvSNVmLJBrQUR3oxP4IvIwsU5WrY1GAKrRnW+J+EVEOAX/lHFdmqjhZsI
	 6jmKil9NC8S0AXK83iEBO4AJd/1BRLpkrYX/+CH20b3dlAyQyC9hb6P/XGpm2c56Q/
	 UGCnYKdK5A1ZJVoOO8bVctfLnV9Abu+lwPO5ibRHJYTWAUxoWJEimxjpYDdVwNDiI6
	 Zke8B84mfEeDA==
Date: Thu, 12 Nov 2026 19:05:11 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Message-ID: <avYNv-bmQAGE0ktf@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
 <avTzHDlCiaNSzhtX@nvdebian.thelocal>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avTzHDlCiaNSzhtX@nvdebian.thelocal>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D79B180010
X-Stat-Signature: 9wazmqs8j5dk5dcyruigo6wq7cj64uin
X-Rspam-User: 
X-HE-Tag: 1794510324-283142
X-HE-Meta: U2FsdGVkX1/MPMnUDmL27qOQQ9nkITvuXBtToo8Tbl0hwx5WM7avHhLS73e9bUEZdUXdsR1aAHOnMRmf5KjUnE0M+zOr4fm6kPVfv17F8gJu1LuQF+o+tEwXHfUg6NUeid3/yEanXElLTsJxDvLv1SgF086IhH6sCEQatsyQoyCqQPZ5YreaZC7ErAWAW2NpTqc3jdSu46SBN32AOcdke1r5EKj8Zd52AeI1X58yUMu08hstK25MTX3058QxhSI3P2CbodR6w1amGK6cq3K1TF8xVIuCBqkBIG4pDVRFhoFTXL40uBTSQtNsGGBtD6fAsRnF0GVKsnTxeDigaIme4XGTFEclZWcsm3Mwfnv2RF1Mm94gyf/FKnl7pNavZjU8b5J5wFzcxySs/SWyOvkrocufPrOaTTpjgbU4OCBPaoPtCdsql1FpHpeZb2WmKgBCEbpPnAmjhtoLxohuUNiTeQvVuGPJgfykZ/A3fmF1A+qIzlt3eH1FArqgzWv8KSd9oTYLcLiUcfY3hHKL3KauKBUVgUyqFSNMGZNBUlnYnbNIi78En+92oHFXUXywcxAOyOHkwIg/TScIWtC8bCVKuhNA4iCFD3+Us9rRutNRjo0xnAB+Ap0bXSYpQNmrxz+gIkaGh/A6rqqQLLg/UI4VDvSfqZY2+Z5kIHpUt99HzI0XgYjPuXPOJURnCW222LBV8Jt6sb9Z2mIrYJ5Sk2+GTXnUfbF4lQWS93/3wtcNkTBcN/1k4joKIV1bOqfEl7k3IdrKAzg9Mn2BL139d/d9rck4tHvw1IZibU8QgrFwgvKJCEKeh2mi9Lqvy1WqxVznJpXJQ6aj/0FGFKDXFJOXUQGPqGrh/eCDiIfiMfK5th55e47Ux5hmmKuvhoQkiCwMWhd0F6RQNG0H35+/FMizkQvR+gIen7lbKMSPUV0agEr8hBqiMHsOTqB/BVw0c/8LtrdNDYs5ERO19RBlhMJ
 zBvrvsZa
 TXjhuWw3CztuNTxt0syMlOx/4TGnVbTXHOesBKp5uYVnCdW6eUGrpq4MUDd8YEsJtS7oeE5aBvSOcetO3kz8yX+x4po/lP4Oke8Ocd5yPmx0CEN1xMVHN9kDW3uYJm82vU9Lyw4T0IKGATPZKxRKwf5eBh8rlXg1AoFZDo6ul2FMFyg9uSic2KHXGQc1AK2SWKGwtAg6jFjvHLwaLtkPwLzw9j2gvu6jwCE7IHlzoxR0llUePOyjBHmC0QcwDJIM6Od5QlYfFvP2Z/b2umwMSCGyLSawMsEjYU9Nt0Q5Y74jnTGPU3Hlc1a4wscI3KUl3RweKqIZD72ZXnt5vP/3O+KXbtXdZCXph5xws9H+vNLgB0lU7QXGt8EukUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 10:04:10AM +1100, Alistair Popple wrote:
> > Resolve this by pinning the anon rmap of each folio which possesses one in
> > migrate_device_range(), migrate_device_pfns() and
> > migrate_device_coherent_folio() before its PTEs are replaced, and
> > unpinning it once the walk is done.
>
> I was going to ask why this wouldn't also be an issue for migrate_vma_setup()
> which does something similar. But in that case mmap_lock is held across setup
> and finalize which I guess is what saves us there?

Yeah, exactly.

--
Cheers, Lorenzo

