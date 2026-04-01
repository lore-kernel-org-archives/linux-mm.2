Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89B610F6FA9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB2D6B0093; Wed,  1 Apr 2026 10:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2696B0095; Wed,  1 Apr 2026 10:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFA36B0096; Wed,  1 Apr 2026 10:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30F196B0093
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:40:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07D7A140950
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:40:21 +0000 (UTC)
X-FDA: 84610247442.09.DEE0DA8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F4B92000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:40:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnwoGBjE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054419; a=rsa-sha256;
	cv=none;
	b=6sxyDMUF80hbr2q2Oqi9BCK+kjwPAEgQVbqp8/Th5ggcl62OvnYJn24wf2WTVPfw+wDLmV
	+qPDtHkLPTkirGE5M/QgYt+o9Jv30IVbldnwGdB6UKK3nZcHhZKFho8xFFctLSIwzU+MUZ
	3BaguRR+Ot4joxgyqfjGni2sK7UO2y8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZnwoGBjE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2RRM3QGRUEh5mk0XorWfno6FKqdtME4d+e9bl95YEw=;
	b=zVOfI8DzU/oOYV7PgDzA59vShHc+YNbaqLIKEqQTFo27EDfRZuSbfImkC6IRJUg5VfhvwW
	59RFujyJkO7/WCcZTnFrhCb7ipX0dXEEV1pPf3htv64R0X/iKLjoJbEGHK4xCxJ/sagqLW
	99FCNOHXQplgDUh8eAcWVoEmPe6EoGg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F802402E0;
	Wed,  1 Apr 2026 14:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE94C2BCB2;
	Wed,  1 Apr 2026 14:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775054418;
	bh=TykJ8jJa8X/A3BfI1NqncbeKLLHymAMT2RdQZ8mQvPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZnwoGBjE8UYsn+9Xz9/gonK7PmqMkPpL1IB6t7JB7DCHwrrblJDIa0hgV1ipYoMhw
	 UQZXBR7Wl5F3qV2fqgICwVZxPLmYkt2doik8IaYwSJ/7iDDBLX33AD2su9nPqO07dR
	 tRqWqxK6/rbyi5ekZ5BDxU0bZKz4iKvzi88B6paqwvsnZkMW11YQkyJ5gfQ9HTG3LK
	 ksHYB9pkywb4n3rstunacatxXd5ylpUyTcqBsn+rPb4HyOClK3si44RlGn2i4fFymM
	 /MI4fcS6BVZSxz6GZLlRbrXCPW2aY+Lkp9RuJOPrcDCI5NEm2pOSrt0Gvv4XqqbLM0
	 qANAOlkXh9GXA==
Date: Wed, 1 Apr 2026 15:40:16 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sayali Patil <sayalip@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org, 
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: Re: [PATCH v3 08/13] selftests/mm: ensure destination is
 hugetlb-backed in hugepage-mremap
Message-ID: <b590a17c-13ed-45f4-9f51-ac662d00e7bf@lucifer.local>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <3b6ffba238a4b59de891acf896fa25d7d3193228.1774591179.git.sayalip@linux.ibm.com>
 <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee15d52f-45df-415b-b0d9-3d267d147e5c@kernel.org>
X-Stat-Signature: m8ruf5ieo8izjqokd4p6ahydu3gmox94
X-Rspamd-Queue-Id: 3F4B92000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775054419-322442
X-HE-Meta: U2FsdGVkX19Nsdugm21mCYLmgSLKc5dNOHSEKrK4ENw1AiXnMnyqPisO/zcGU5VmDvbghBJzmr0BaPsqSUHOkO53UF3JvOaKrf3O82wlZK0AjRCJC8DznGz529Wu9XHIRNP6kFlSnWpJBE8IfRcR8KRc/LLCAduFFRGZHe3yF4hZPi/TRmPOkBUWlYgLtfuQ3IgKXiKECl/8TF8nDlbAFZxAaHAethsLoELHGMqmvRX6UOXch1yU+VdKspZD1qdMn5ZXY/YgPPwDfk/8iZbYIsjblQdUMQ/JEQStNzVgK/B708aMvfF+8SGmakDuPL/ujIYXZlxPp8yPtI95Gk98xEHz5VJ5wE5bsn42TNghzw5HcwDfr/FtqqRPblHxq+Cz9YKox6M2VdPK1qFWeYxCal0QNl80kygAqfHvMUGy8GVDBft599TKbUGcT/sCw9DP6Dx1Dbhqp5XeBOAryPpzTy5Y2rX+QxzGljRrHaztNPiXK6M4TO5NDIsfUPKDS3x8gNzkEifjwXCDN0KlB8ajvfiVnvjEZMnNHUN1yeYZAj8+X8crE6BD02gnegt5230chIT5rDh5vLzbNc8GrYe8ScOUKTcTM7d7ddBAnwRwZgY6FwBUoMuCw3rQqnCf53VaggU1mADhmo73mCeKdrazdwZYto4e80PD1hkTi+F2ArLL78VIhDlhx48ZDIeQ0q79lgqIZ+7uSLqO+DzjdlmFWtY79iix4C41HnVsqkkUuf4E0Equ+n5Ii4nBGaq1J9m1PeK71gw9DrVXuoBmMLOx9O8hcjqs5tfdTXTGiahRrDUXh2U8fbGc06YAhYcSYe6Zpf3UQpR/nzsDMIialWAngZXeNGS+GyHu64fBlpdI9brzRml/qjM0i9cDPii2URtz2hcG/aDiegGRlQ8vt6FlJuVOW3BE6Tug3KD6WE0WMjdoDs6CXWT+E8OXl4G5pJ4FdgvVJfXvhviXFySGHMF
 or6pPeD0
 QasDeWUMTqLTFH0hhT7OPwYpumQi2uejBBYQuy6CVFuOicSkvwR9OWKIs9U3Yh15qaK6PlSdyBRbzNZL2X9WtP2wfmegNQ9HgW+V8BBX7eDQfXCsCvBk6YNoqKW/whhkFYBMSe9qsCANtnBuEw8D7io4AbqlqqORaGJopb2sfIKt+/QXTJb5MGUWvwxs+ue0ot140bO2Q+1PQwaj6HgTKMoxGwKVTPVL72Qh5p/zE5FXrmINXTQbhRmnK97MnUBOCVpWqIOL6hQJFNNWDFAR0iCOvgdQxMXo+dL0r8bznD9fyN4+N/+knE6POpBnwwSwLo+KEiukA/wNGc70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 04:21:55PM +0200, David Hildenbrand (Arm) wrote:
> On 3/27/26 08:16, Sayali Patil wrote:
> > The hugepage-mremap selftest reserves the destination address using a
> > anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
> > while the source region is hugetlb-backed.
> >
> > When remapping a hugetlb mapping into a base-page VMA may fail with:
> >
> >     mremap: Device or resource busy
> >
> > This is observed on powerpc hash MMU systems where slice constraints
> > and page size incompatibilities prevent the remap.

OK so digging in:

mremap -> ... -> vrm_set_new_addr() -> get_unmapped_area() -> ... (in ppc arch
code) -> slice_get_unmapped_area():

unsigned long slice_get_unmapped_area(unsigned long addr, unsigned long len,
				      unsigned long flags, unsigned int psize,
				      int topdown)
{
	...
	/* bunch of checks */

	/* If we have MAP_FIXED and failed the above steps, then error out */
	if (fixed)
		return -EBUSY;

	...
}

Is presumably where we hit the issue.

> >
>
> That is weird. An mremap(MREMAP_FIXED) is really just an munmap() + move.

Yeah the weird bit I guess is that we _still_ invoke get_unmapped_area() but
with MAP_FIXED set to indicate that we want the specific address, so it's
subject to the above checks.

>
> Are we sure this is not some actual problem in the hugetlb implementation?

It seems the 'slices' check sees if the _target address_ has an equivalent page
size, presumably hugetlb-mandated, and fails if they're not equivalent, so this
change is just accounting for that.


>
> > Ensure the destination region is created using MAP_HUGETLB so that both
> > source and destination VMAs are hugetlb-backed and compatible. Also add
> > MAP_POPULATE to the destination mapping to prefault hugepages,
> > matching the behaviour used for other hugetlb mapping in the test and
> > ensuring deterministic behaviour.
>
> But then the test suddenly requires more hugetlb pages, no? I don't see
> a good reason for the MAP_POPULATE, really. It will be discarded either way.

Yeah I'm not sure about the MAP_POPULATE being all that important here.

>
> >
> > Update the FLAGS macro to include MAP_HUGETLB | MAP_SHARED |
> > MAP_POPULATE so that both mappings are hugetlb-backed and compatible.
> > Also use the macro for the mmap() calls to avoid repeating
> > the flag combination.
> >
> > This ensures the test reliably exercises hugetlb mremap instead of
> > failing due to VMA type mismatch.
> >
> > Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> > Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> > ---
> >  tools/testing/selftests/mm/hugepage-mremap.c | 11 ++++-------
> >  1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
> > index e611249080d6..48c24a4ba9a7 100644
> > --- a/tools/testing/selftests/mm/hugepage-mremap.c
> > +++ b/tools/testing/selftests/mm/hugepage-mremap.c
> > @@ -31,7 +31,7 @@
> >  #define MB_TO_BYTES(x) (x * 1024 * 1024)
> >
> >  #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
> > -#define FLAGS (MAP_SHARED | MAP_ANONYMOUS)
> > +#define FLAGS (MAP_HUGETLB | MAP_SHARED | MAP_POPULATE)
> >
> >  static void check_bytes(char *addr)
> >  {
> > @@ -121,23 +121,20 @@ int main(int argc, char *argv[])
> >
> >  	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
> >  	unsigned long suggested_addr = 0x7eaa40000000;
> > -	void *haddr = mmap((void *)suggested_addr, length, PROTECTION,
> > -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> > +	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
> >  	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
> >  	if (haddr == MAP_FAILED)
> >  		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
> >
> >  	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
> >  	suggested_addr = 0x7daa40000000;
> > -	void *daddr = mmap((void *)suggested_addr, length, PROTECTION,
> > -			   MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);
> > +	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
> >  	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
> >  	if (daddr == MAP_FAILED)
> >  		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
> >
> >  	suggested_addr = 0x7faa40000000;
> > -	void *vaddr =
> > -		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
> > +	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
> >  	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
> >  	if (vaddr == MAP_FAILED)
> >  		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

