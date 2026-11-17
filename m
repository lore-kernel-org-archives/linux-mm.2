Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A499606A335
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=twXPUU79
Received: by kanga.kvack.org (Postfix)
	id 47B316B00EF; Mon, 16 Nov 2026 20:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405CA6B05B0; Mon, 16 Nov 2026 20:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B976B05B4; Mon, 16 Nov 2026 20:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01BA86B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:58:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 753A7A02D1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:58:16 +0000 (UTC)
X-FDA: 85442950992.21.370FE0A
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 687C4100008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:58:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=twXPUU79;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880694;
	b=k7ZvU8RQ/IuNfjY+C0nSi9VSeD3A2Kv3U2cZdOdQlR100d7/GQ+i5GZpEzojVt0bvYNuAX
	cL1bOYqn9jGBDaJnxlYgHm7YdoVjqcVv77l14MHkawfqHLQhYl/qFwqIxSu5MsaC1ZU3VE
	v14k/qksLYapZVXNHKpqnfHhOtmVvTs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=twXPUU79;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJaijdCSbGvAI2XUFUPLj4Bepyf0Mp+otbYEfC/h5uU=;
	b=7Dx6wPJ/Y29lKBFy2G3n5+pb8PPwHsULISYQ+6846PqawYuBTs60/2fmHEIHzAHocLHGNY
	CI318mjQO7pcQBEzfTrhFPloQFxQBC5Nf88ZnDSaUoIYnUR+ytE/MRMwh/NTn4hJ70+UZA
	LHin4yvtW9Gswn/gVTUqfmTXNO7tI3s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3eqXtP2dV1n2wti1WI86PMgmoafgSRMDKa8er/AFqsA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794880692; v=1; x=1795485492;
 b=twXPUU79LsIubbO/MX8DOZUuHOAzG8R4zI0ANp03ggukcEHXnZfyXIDwfkzqaUg0kgaaKTcJ
 SOryyyv8UYPGh8dMVlu3yMasOd96r3W8861X2b1qQ01xvfi/wzKZrQXhEpCYPLDMtQsfWped/xi
 p8xOYrGkB0JVytdsbqa6ugIw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 663db3f24a33422a;
	Tue, 17 Nov 2026 01:58:12 +0000
X-Mizu-Trace-ID: 663db3f24a33422a
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] hugetlb: Don't restore vmemmap of non-HVOed folios on
 bulk restore error
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261116221557.3128331-1-jthoughton@google.com>
Date: Tue, 17 Nov 2026 09:57:57 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1041A207-7114-479F-AB70-8EA33AB361A5@linux.dev>
References: <20261116221557.3128331-1-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: etfk7qk1euk49db4qfwfcf9z9n7uyb4r
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 687C4100008
X-HE-Tag: 1794880694-788232
X-HE-Meta: U2FsdGVkX18Db6jIUAjemhZ71LDOL/tfHxfR+W35yv9rIVFCWUfCfNCLCPnBq4KQaWw6/0e3+CsC2zoRu6NwGTsuKp8o+0453Bvh72Eep51N91VnxX0uNt0kt5D393CTU38DziYtajJFL1/t2g3cVcNGg5TmRShjaJETOKr+P1JYSH3ZN+u6g2hAbAqXsg6BgjRIlwfYu6kAhUJki+dwv62VFbIp7hCI1YjFv+rx5Z7BaToB3ywjPScOFtREvyRtD1/Ht2mOLSp+94O9MsCQmr9/hfVs0Nw6iXT20C60VeqIbtiNfJ3KkNGj1Falq4wSjUL3uxKEvElBw9JWBUu0QV9HVBB9fgyNVoyx/RBOiLm6PHvN352rwugSAdB7fLTCDerQr+VzQTL6KSMywDWfQoZpK4p5w5nHU8NXTOnh6JSmNqw0FhcS/YlVuR7deKIKlQthaVUZLe0AbT0hc9ws7gea6oThR9F6BCT4YD+ojT4LhnHi7dxg6Q/lhJwmow9fZq34K/QZoKe/mYfIidfhLSbh4g6dDI3Bo1UXALo70Ow78U7zNjyJecmFnsYou321FX7AMfffpMhA08nUWMT9pWruNU/Lb/SuWbzraSbCXg/TR4XVvCbcx161XevGEi0Yh4oyy+7uhNS5mnIhinFW4NeF66YT0/x/C1B1syyGODuQAe7WMhpV0mC+KSPGSiLJdkEpP2C5iMC0niYFpLdsCSgYMjTbmSENMJnuhCE5NawfB5BrivBEDvSJmWJ/OFr22cjtHnu5Fl/fi5DTdSgV3hD21WE3/+oUMnAlC8B94Ouf4cam9N4fekoWmRPUFrToUXELcpdtVf9Mo8RHCVteQiFYarcck4MHfKn25+P+ytajOhqAx+Y1V1Cm5rF3hYcA53EEjGx903b3+HAf5eIA9YGdz4lZUptRQ6w712Pq+c8SkzPA3uK1rGuzBq8YCuKJ7OaujndcyueuQ9fWY2M
 qbxPtl5y
 mT45ucDKMZHW+iE8kKzedC3xfvrudRRvjD7JfaHGgWhdCAqrNDrxQgWDRsE3sGXmbGQDpWIHH8ye+iIhGkiWnIwRLJZXD8sSGCll0Wua/+/4ehwNGgMX33cDwE+oT/uEICHA/gbN5QMidAUZIL3jz7+yPksaRfg3eLR2LYtpaj8enJypxzqQCDZLI/vkSnbhcM7FxBx7iygNWiage4woKfxnJom65O8s1De4E5tS7WIhqdtvNjxAVOIVeuRXACQxXqI8BC63/MFJEG+V3bHxkrm3XTPbzIjiNFvbx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 17, 2026, at 06:15, James Houghton <jthoughton@google.com> =
wrote:
>=20
> When hugetlb_vmemmap_restore_folios() fails, it stops processing the
> list, so folio_list may still contain folios that were never vmemmap
> optimized, e.g. because HVO failed when they were allocated. Their
> hugetlb flag has already been cleared by remove_hugetlb_folio().
>=20
> If no folios could be restored, bulk_vmemmap_restore_error() then =
calls
> hugetlb_vmemmap_restore_folio() on every folio left on folio_list,
> including those, which trips the !folio_test_hugetlb() check in
> __hugetlb_vmemmap_restore_folio():
>=20
>  page dumped because: =
VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio))
>  WARNING: mm/hugetlb_vmemmap.c:503 at =
__hugetlb_vmemmap_restore_folio+0x270/0x300
>  ...
>   __hugetlb_vmemmap_restore_folio+0x270/0x300 (P)
>   hugetlb_vmemmap_restore_folio+0x1c/0x30
>   update_and_free_pages_bulk+0x2c0/0x368
>   __nr_hugepages_store_common+0x2e8/0x3f0
>=20
> Otherwise this is benign: the restore is a no-op returning success for
> non-optimized folios, which are then freed as intended.
>=20
> Skip the restore for folios that are not vmemmap optimized; they can =
be
> freed right away.
>=20
> This is very unlikely to happen without fault injection, as it =
requires
> both HVO and a subsequent vmemmap restore to fail.
>=20
> Fixes: cfb8c75099db ("hugetlb: perform vmemmap restoration on a list =
of pages")
> Signed-off-by: James Houghton <jthoughton@google.com>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks.


