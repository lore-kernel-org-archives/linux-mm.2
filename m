Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9396FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA38C6B0099; Mon, 27 Apr 2026 10:53:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AF36B009B; Mon, 27 Apr 2026 10:53:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8866B009D; Mon, 27 Apr 2026 10:53:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC1D16B0099
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:53:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00FCB120F5F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:05 +0000 (UTC)
X-FDA: 84704610732.03.F753A0A
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0136E10000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:46:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W5Wp1neS;
	spf=none (imf05.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SUkHRDbaC9aZSa+oEHyg1Tzg2ppQcm4MIPmCZq/6ek=;
	b=qHeEv8cYBb2NMONrM5WNXbjg9vZw4rZSedxKn6iA8BFsKROMuFwdBHxBOUNXdD0WNhXAHf
	qKv6sczLIpqbQCLzjq2ow25ttBUL9ggASVcEyGLm2zUrjpfd8VEKH89Ij/pLHRZ046t/GM
	tUsszh9EJFFnWQsR+wfaReWuBl0N6uk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W5Wp1neS;
	spf=none (imf05.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301164; a=rsa-sha256;
	cv=none;
	b=0dtlw7IqTuV5gHnI9i7pnLbu0i2GYHsZt8h1paN6Kh1QQBEX278s3e2qmHEIHiEYkrR/MZ
	+Qwip/OQcFATc2zK7qIeR0ve6pZOWLXL7SlYi+nWRGtMnHsDvktNckBnTn5/8QTJgSHUPS
	GCOXIm/Uy7EVLCHdhVJqv3IFFprIVvU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8SUkHRDbaC9aZSa+oEHyg1Tzg2ppQcm4MIPmCZq/6ek=; b=W5Wp1neSmz5WcLXieabX6NdOIa
	/vIMKR3XDwBY7vq7gRwuR4TKoy35qj/UUZ0zgGzJ+TQH87QwodOzx3msj8XbBY3YL8TI/vTQlsEcm
	q/yJ1o902d12aYqnr4+kEkLg+zkuyZNKMDrW8KOwBOxPoohzsRjkRBVW6wD3Gn1uOlESQf7hqBbMW
	JT7RJjxrMTKBekEc6MfeLPKnmfWHsJP9jJcc/EMyMVHBprz2sOxG3FgaFFDnNgab8aX9k2AKpXW2m
	kww5UFBHZ4GW7aj7c/oJMwfgwxnfvEa++1Dt5uatbhtsx/DrNtScv024D7pkGoeL16hdhnYczFseu
	iVigaT1Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wHNDS-005YR3-2h;
	Mon, 27 Apr 2026 14:45:43 +0000
Date: Mon, 27 Apr 2026 07:45:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, corbet@lwn.net, skhan@linuxfoundation.org, david@kernel.org, 
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 1/4] mm/memory-failure: report MF_MSG_KERNEL for
 reserved pages
Message-ID: <ae92WpsjxQ71BE9Q@gmail.com>
References: <20260424-ecc_panic-v5-1-a35f4b50425c@debian.org>
 <20260427123330.92847-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427123330.92847-1-lance.yang@linux.dev>
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0136E10000E
X-Rspam-User: 
X-Stat-Signature: 4h6bw34ha6zoat6ipfrhsuwps77x49b1
X-HE-Tag: 1777301163-861844
X-HE-Meta: U2FsdGVkX1+UJTuIzgRBvYBCtYm54hLLD6xOsW02Tc9K3b7hcVp/00J7fHR5GOQMONzb07NNpsBktJ1bc1XLOJIOacQYvzTrwafI7MEzL3l5EP+peVsu19jron1wf/V10+IxRzj0p76pEK7gBelLucOw0j+HCbSuQIpoa+mT7Smq6fsoQg8HEbF+E2uqUPg3PrNTe+gPU2C7h87j4BHgeVTj3BtM7NCTprDdV+PnmvJu22CnnQeTbsc8DgPnGnobXr1prNLR58vfI+CqWPnqufLpaNZaB8XLo+oBVUxJ+7Ren2wdaT1KEq/1sp7t9s9x2sDSQvmDmLTtHXqZAOQeReVy1QWJo/9Gih37XgdKDD1ipvU5+O0mdSuFjIWJ6bDkul5BcXl3Us9eyOuSFTApsNjGI2ryofO6P20FhUnEPYzzFoF8JrH9+f0QTG/5BI4WTAQ38xizEInmhoq7YVVycLJ73RR+1sJAHReRoah4ztcqxutdVn4QZc3z34soKDmdo4tlnx26DeGAkhZpVGCuE8oVIax4XhghQu7PVaAivN5HW8CeR1qTNDIP2o/D0EWPqANdZmDTvBpwVRtb3raorxgXFTFv7uUxzFfXVlb5Ov4zJN1TXFas9xO9oHAo1Bpuv1y5hbgDQFiVjD/NQmZrpY35DijVR3uQOtR0HPixCqehk4aw1AxMEzUiZxWarcB7LowK9Z9JzmTzZ6/aalWzGNoz2U46KWCtToRHHQbS35jkv9kZowTYDNZKM89NKmRGUy22yupjgnGpTHW7K5cvL57/vAjCxS9pRzvDE6tXnWyrjoO8c9XuQGDKsxxoG7ibpPrP+m5j/znWYWgLU0YApktNJOoLguPoPPn/y9Mmuxr/Rfc3MG7Mzg5D/vgooWOUjDhr4OP18Ge1aizAagGnN5T9ABM6nMyVrJSwXdOtBL9mP5+RDuG3ule2R9WI6s036tmstmfLeVX5SEUFZa5
 CLBf6QYe
 lH0CGU3+aquT0oNcpnc6YEdw76yewRHHaH05jUYUXWsmN6qfefkxgFUgE2DNheMEXL3PcIuxsBvnpbysPbyUe9GR940SHvGYgwVUTHpzMxRgKCQQu2jagMt+cd1wOS13Gbwzy6F4QsZ8a9UHPsMer44P5Ca4puNIGpk+UyxkNGSRhqtOSg0Vn87kUmYBwdwUp7bDBMqD7H3kE9KtTiAJt44Vo1TL7YlvSQGsXYS6+OOaIjs7L257ZWVz5fAdx7RN4d2TPAnfMXcZzv1u6KuzkBRc3aq9nq+Jk/WiyX3Mt0Jcyv6lEfBdRDB35wl+sZFSe3t/jz66b95a22pYnEb7hBlbcJJHJSUxOoh3Q2Onyg6UnEug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 08:33:30PM +0800, Lance Yang wrote:
> 
> On Fri, Apr 24, 2026 at 05:23:59AM -0700, Breno Leitao wrote:
> >When get_hwpoison_page() returns a negative value, distinguish
> >reserved pages from other failure cases by reporting MF_MSG_KERNEL
> >instead of MF_MSG_GET_HWPOISON. Reserved pages belong to the kernel
> >and should be classified accordingly for proper handling.
> >
> >Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> >Signed-off-by: Breno Leitao <leitao@debian.org>
> >---
> > mm/memory-failure.c | 11 ++++++++++-
> > 1 file changed, 10 insertions(+), 1 deletion(-)
> >
> >diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >index ee42d43613097..7b67e43dafbd1 100644
> >--- a/mm/memory-failure.c
> >+++ b/mm/memory-failure.c
> >@@ -2432,7 +2432,16 @@ int memory_failure(unsigned long pfn, int flags)
> > 		}
> > 		goto unlock_mutex;
> > 	} else if (res < 0) {
> >-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> >+		/*
> >+		 * PageReserved is stable here: reserved pages have
> >+		 * PG_reserved set at boot or by drivers and are never
> >+		 * freed through the page allocator.
> >+		 */
> 
> Not necessarily. PG_reserved is not a permanent lifetime property for
> every page that has carried it.
> 
> page-flags.h says early reserved pages may later have PG_reserved
> cleared and then be given to the page allocator :)
> 
> At least some drivers also clear PG_reserved when releasing pages they
> marked reserved.
> 
> Would it be clearer to say that pages with PG_reserved set are not
> currently managed by the page allocator, rather than saying reserved
> pages are never freed through the page allocator?

Would a comment like the following look better?

  /*
   * Pages with PG_reserved set are not currently managed by the
   * page allocator (memblock-reserved memory, driver reservations,
   * etc.), so classify them as kernel-owned for reporting.
   */
  if (PageReserved(p))
      res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);

Thanks for the review,
--breno

