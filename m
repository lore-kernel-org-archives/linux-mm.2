Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D514FC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 12:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98BE6B008C; Mon, 31 Aug 2026 08:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B326B0092; Mon, 31 Aug 2026 08:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60006B0095; Mon, 31 Aug 2026 08:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84E966B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:12:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FC9A8045E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:12:35 +0000 (UTC)
X-FDA: 85161452670.17.1B73A3E
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 91182140012
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:12:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gGfYbwOf;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788178353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5akJYmmRXUk88N0xG/Jq0H/5tMkiTfzIxeZ/sqRKUAk=;
	b=ntTMjUf5D/1hvy4yge24VSGlhrrcJhnYJOj1PW3+BbGTkXkdLWUYb4OUp1uhvDm4WHdILE
	Kjq8DEoe+S9SnFBY3KI9FKcTboia3n1QDSxZS+7fbZResIeOmQtd+ZQ9TSizTbjmPr5khu
	pRwVvhd77IRi7ZXhfqz2BCvY5KwoOY0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788178353;
	b=rlpOkE0Et4X++eWZrVDhFZDlmM1y5B60Ar1BVTAWPy0h5f8C3cKzrCNDHHh7pdGVGjgFnL
	ftK2RQqsrIsnJc0VNt9tCXB8Mlc3044+y0uS7vf/CWRzDqLdz8G/QSN1/ZMv4AxHgDOJgU
	DY5uRUrN5We1ScaFbaGEw+rcw+42P7E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=gGfYbwOf;
	spf=pass (imf26.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:From:Subject:To:
	Content-Type; bh=5akJYmmRXUk88N0xG/Jq0H/5tMkiTfzIxeZ/sqRKUAk=;
	b=gGfYbwOfRXEOpViqrUcm+fyEiDjZGznJv71548gpu2IJy9NiAVrJe21nRxsg9Z
	O6gJTs/izv3YjSmGLkjm3e8lB9TC07rgHLeZMaATrw9+UGyFRXmsgRE2s6db3Jnf
	lLERX+hY936Yl90WBpE1qrExGtwwNIwlGY2Ov2wN/sTLM=
Received: from [198.18.0.1] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnbsuZb5VqDhGmSQ--.62460S2;
	Mon, 31 Aug 2026 20:12:11 +0800 (CST)
Message-ID: <0f10d088-75c9-4287-bc2e-f2def5a9c7de@163.com>
Date: Mon, 31 Aug 2026 20:12:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Longlong Xia <xialonglong2025@163.com>
Subject: Re: [PATCH 0/2] mm/hugetlb: fix surplus accounting and availability
 checks during demotion
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 mike.kravetz@oracle.com, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>
References: <20260823034307.1072415-1-xialonglong2025@163.com>
 <20260828161042.de43f4751296883eeca633a6@linux-foundation.org>
In-Reply-To: <20260828161042.de43f4751296883eeca633a6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnbsuZb5VqDhGmSQ--.62460S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxury7JrWktry7Gr1UAr4Utwb_yoWrJry5pa
	y5Jw1Ykrs5Ar1jkr4xZ34qkwna9r1fXr45K3ZxJw13t3W3Wr9rKrySy345WFyI9rWfJay0
	qrWUZw1DZ3W5XF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UO2-5UUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xsC+mqVb5tZ9wAA3d
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 91182140012
X-Stat-Signature: ht6ur7mjbf7gisjst71qkuuzzkbcebhf
X-HE-Tag: 1788178350-194731
X-HE-Meta: U2FsdGVkX1+2DstFEC34zyuOe7O6EPW7LOEJfjgiD/5X1bxZiefmucg377ly2ttB80xuDojxy5IY2pZQ6k117TwW1J7kwkVSCj8SZuAuSd6TwY2HZOOmmH/jtcl1Ka72zw+Ouo/lram6Y94/SXTQS3eV/XYJcrXCZmb9je72YEumuJb/Y46Zm1fS5RDSue9Eqm7WPRc0yAKzpYa7jT83GjAX2+bWxmkaTLur/uZKfVt/0UMHfwK2GkGKw9OZnSRVPjnQHoOZdq0pAAMOG/dYcN9kKhY0uWEBnRZmlphaevEHCRiR8sF1bQrpAZxPd0XV/ONDB2cUbQvrqI+sQMuDeolw6Qy6RVDxzTFmE5BzhxbsfM6YM9UNnpXdeIAhIe9M0dAO5Uo3g+Md8mrcYQwIW7SjAJOutIpqUWxw6ZcOi2jbY2TO8YH08/NgX/VLbyL7hlDR5qklZNZLVgxf2crgrQD3XEI1QJYA4satcFqYI0KyKJcTsMpTt13Gr697tlTEfwF9rwSBlEoUF7ejfiHUonU9XRJ/CxBODz/CNbd4thbJ/sA/56KtEUBAovLfArDem9KkiPo1Klch8O3gzXFEVN71vU6s84RqdAzV9GYpGcUJ38dz2NmXwnN8DrnLsN6Gjy59i4SF+cYrrAGcwkqh/0wmoVFGIutrl9EkOVWpRKt01nm1qbJntmvRDZSNfVZK6xoLARbcLyhxTNkwZk/+mesVnME8MgypTnajyi/gSdpu2lMLapDDXzmnNLB57/SsAaUD5Zr+kNh2sVUZFp5QsE2z3kBZIgC6hHrTcH1oSzCdIHhQUfywxYatT+an1UjMOkjsaf6KtwAAz0vIpfdALDKGgthUA2QcYHmoCPYWZQ+BhhH4OGteG7p5ealnuHicTwFL868KSC+ijhYTkEsHHKV9tmT0elt8+Cs5NP0FVueM3E2kryK+EMACQbIaGP5KKXZf3zdUw030PP/6okt
 B8vanUIM
 n195x/G+CTjH2BybLqdU9debTC2g6WthIaIbrXd973OIomd/266PcAHZjG8h/6Sxvgbrdgp20n0LJmMslsoLpGpRfGheOUq0zP4nnZEadUWtLX06wK7FbNZT1jRndlHBjFS1Bz0OW6fMAGQEHTJRKezbNIXVVbuPdqJf4JHEDerBjDXWZcFDJqeSlUNxZR+H5wB8v4Q5/Xco7peQQ+KqsuON2a4ceO7STiGW2Mhs3aU76vzZbY88ammXEl2vWApn1s5zEpFYH0GosPfZNwBqgseYfGDw1lda1KNUuiBsowqYIn7vo18Su0V4KR/4H6JOlNnmgRJOlyS5WukoBNj9vnaOXszSis/Kf7xk/Sm05Tnj44b6oKVVzYPykgsYa4oL8rkxxMrDVXNEFcdlZnQGqDdg7UFTQk6YXKHdE08EwPzFfbPdnk4jH9slSpsUMb4Zd7ihD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/29 7:10, Andrew Morton 写道:
> On Sun, 23 Aug 2026 11:43:05 +0800 Longlong Xia<xialonglong2025@163.com> wrote:
>
>> This series fixes two problems in the hugetlb demote path.
>>
>> Patch 1 fixes surplus accounting in the source hstate.
>> demote_pool_huge_page() removes every source folio as a persistent
>> folio, but a free folio may instead account for one of the source
>> hstate's surplus pages (for example after a vmemmap restoration
>> failure). Removing such a folio without adjusting surplus_huge_pages
>> makes the persistent count underflow, and later subtracting it from
>> max_huge_pages can underflow that counter as well.
>>
>> Patch 2 fixes an availability overcount in the sysfs demote path. The
>> sysfs trigger checks whether any page is available but then passes the
>> entire request to demote_pool_huge_page(), which can remove free huge
>> pages that back existing reservations. With two free pages and one
>> reservation, a request for two pages removes both and leaves the
>> reservation without a backing page.
> Thanks.  Have you created and tested reproducers for these?  Gemini was
> trivially able to do this for me.
>
> If so, it would be helpful to includes the details in the
> changelogging.

Hi Andrew,

Yes, I created and tested reproducers for both bugs.

Patch 1 requires a vmemmap restoration failure, which is difficult to
trigger deterministically. For that test only, I added a one-shot fault
injection that makes the first attempt to restore the vmemmap of an
optimized 1 GiB folio fail with -ENOMEM. The injection does not modify
the demotion or accounting code, and it is one-shot so that the later
restore performed during demotion can succeed.

Patch 2 is reproducible entirely from userspace and requires no kernel
instrumentation.

Patch 1 (surplus accounting):

   1. Hack the kernel to force the first 1G vmemmap restore to fail:

      /* TEST ONLY: fail the first optimized 1G folio restore. */
      static atomic_t fail_next_1g_restore = ATOMIC_INIT(1);

      ... in __hugetlb_vmemmap_restore_folio():
      if (huge_page_size(h) == SZ_1G &&
          atomic_cmpxchg(&fail_next_1g_restore, 1, 0) == 1) {
              pr_info("TEST ONLY: forcing one 1G vmemmap restore 
failure\n");
              return -ENOMEM;
      }

   2. Boot QEMU with:
      hugepagesz=1G hugepages=0 hugetlb_cma=1G hugetlb_free_vmemmap=on

   3. Enable overcommit:
      echo 1 > 
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_overcommit_hugepages

   4. Allocate one 1G hugepage:
      nr=1 surplus=1 free=0 resv=0

   5. Unmap it.  Due to the forced restore failure, the folio is left on
      the freelist but still accounted as surplus:
      nr=1 surplus=1 free=1 resv=0

   6. Demote one page:
      echo 1 > /sys/kernel/mm/hugepages/hugepages-1048576kB/demote

      Before fix:
        nr=0 surplus=1 free=0 resv=0
        surplus > nr  (wrong -- surplus not decremented)

      After fix:
        nr=0 surplus=0 free=0 resv=0
        accounts consistent

Patch 2 (cap demotion):

   1. Boot QEMU with:
      hugepagesz=1G hugepages=2
      nr=2 surplus=0 free=2 resv=0

   2. Reserve one 1G page (mmap hugetlbfs, do not touch):
      nr=2 surplus=0 free=2 resv=1

   3. Request demotion of 2 pages:
      echo 2 > /sys/kernel/mm/hugepages/hugepages-1048576kB/demote

      Before fix:
        nr=0 surplus=0 free=0 resv=1
        resv > free  (wrong -- reservation has no backing page)

      After fix:
        nr=1 surplus=0 free=1 resv=1
        resv == free  (correct -- request capped at available=1)

   4. Touch the reserved page and let the process exit:

      Before fix:
        Bus error (core dumped)
      nr=0 surplus=0 free=0 resv=0


      After fix:
        touch: OK (value=0x00)
        nr=1 surplus=0 free=1 resv=0

I'll include these reproducer details in the changelog of the next
version.

Thanks,
Longlong


