Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96980CA5FC1
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 02:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635F96B0088; Wed, 30 Sep 2026 22:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6906B008A; Wed, 30 Sep 2026 22:33:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FCDF6B008C; Wed, 30 Sep 2026 22:33:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 287E86B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 22:33:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0E70120239
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:33:38 +0000 (UTC)
X-FDA: 85272486516.09.605D3A5
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42F3240003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 02:33:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mjsLUnBj;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790822016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9j0HT1Hszo34Ho5ZkJDRpjHg9fKaHrKI0Yn8K9r13PY=;
	b=N//PybHZhXHMX07XHnukVd15apqxNN+mdauCKaYqqJb41RCx77ylZRfnDpBIlXMId4RlL5
	VR64pHtL4G+lJI3WGVlQz0x+ymI+7ZPDSnVSFIISDPhLsY3fvPu9PmsLbhV4JXSTv7AX7N
	tDzTWPle7kpPWvtsCMAH28ltiwaO5Sw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790822016;
	b=1QLuDBJOvGRn+p42qo1f4GHj8BvqEH8kA4udUbsev1+T6mELxTAD7bzrtNd4pJRMf5PfM2
	V5hsEYeuw2UQPTPnSZyimhiaQpdyareI0A+qW6J14aPREjKjcRSXsUprPFTQG6SrzEi0yP
	8Ybb+EXUwIrPjmhCKge5+41H9LjSh3Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mjsLUnBj;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cbH3JYvqlDpyYTN0NgAeZSXpYyTEo/j3lBZbAtwH0nQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790822014; v=1; x=1791426814;
 b=mjsLUnBjBUUwPSEy8KHj9gphd3r92ca3Y7C1dBFv8oSMrD1eciLn3JDtet6Nx34YTEcPF8w1
 s82Pf79xxJ1IWndAHqwPmaYvi9VwfsDIG7mevHCxbg1C/GImMOG+vHLon8Tp15/NJgXIA6SEH3+
 WO41M+kX8YVlIFF903SxX7DU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 796f1b244d11ec4b;
	Thu, 01 Oct 2026 02:33:34 +0000
X-Mizu-Trace-ID: 796f1b244d11ec4b
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH 1/1] mm/memory_hotplug: fix missing rollback in
 __add_pages()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org>
Date: Thu, 1 Oct 2026 10:33:16 +0800
Cc: Lance Yang <lance.yang@linux.dev>,
 osalvador@suse.de,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <203892F4-B04A-4F69-A1B3-DC1619176C67@linux.dev>
References: <20260930160432.5564-1-lance.yang@linux.dev>
 <d4fac8af-fd71-47a2-bfe9-3c6559b92209@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42F3240003
X-Stat-Signature: brhxn4ms77uf1rbantpj8k8qx35tj5x6
X-HE-Tag: 1790822016-985677
X-HE-Meta: U2FsdGVkX184p9EuOlPX0jVnJqa7n/hSbr70T5t13F4BHZVQpl2hLDZjtzP2o8jIOOb7covPlEC95QYxJYICbm41knJ42/a9pnhpHQ6KuFwh1v3GXyO7aWweIL8vZdMAXsiwUgScfG1eE6IbWuHQRXOew4nNX0KdHcXOgzzb6xRewd5BxTzBM1Gibhb1VxEYupk/ILInmmlkz7SbLaU4AeGgRGLN/hvp6du8mEBPmZJMPj3BaVRmbjP1ku5LjPDYt6PJXsw3KgtjFtlQUrr1+GZiTEykjNPqtpeWtxH/G2evxz+FvRgkZGcLMD0JfaGJQ/w3sulyjCMhSztrGDt3MDQR1mU7Ee9kS0b1PmU+qfW0WdHECg0iY3lr5IIdsRyIx6u//LixkRZo+Y73U79wnwXXSp6gDg3cIMaVON88lcHdmOA6ZwsvYJiSUpIvdrwOa7RRQj21ox4HhJBIRzCAlM5MPoRZNgEaLLNYVIhNJNjeA+5jvLFZFKxknThdSviHuC0o7MHWO9kLUB053SZLUDVfBb2zW6YqE+WSlWGYa+RyVhNVmgibWQil6clCtpmycXpFuO7ShXRKIfyOn1nK+YLSPFGemKcmpMuitKelYkcRtmZF4JQM4tNNwW6ogFBaFo7dq6HkFO2pGVGbg1+uh6I5pC+MmUw/0+HzDrS72wUWaqiiXIxnXotqtNPsLURp7goYeo7XSpNU4dO8lsl+mPqty+R+ruHsCRXQ9DXn1GRkBQO8ctwBKLUrUzirCxd6ckw5a1yaVr6HB4G/xcavs3W5gkudWk/689QSMaPEhgPvU6AUYMYH+a8QhWLpsILPV0Dqgm2kfI9bSNF+sjKJRkf4yXyY2Gf8J85zowwGEK9XsCv+KUM6GWfAq1yJbfdTwK1YFrxQxxD3NGg+IGbDbxVRt7pO+YtrzVeosswwYftGpvVQb35miT0da6ZzjSdpwQlp0GbwRLhvyQ6kubf
 SUiSNfTs
 LGlDRx5orZ4U4YpX49maO6icwAD23/yGSrvTwDCeHp09OTCUWtgZbQQMz7XPjvFtWH2Hlf1ahl4Gb5DZwAcyOe3OI7Xwgrw2bzSqdAuoCzzFNm9geXiOhC6VWpzOxhL55jAr5wUVJJTshrd4ZLolRxqAd5lK0vLxGvls9KodpSSc/MNAvimp/NweDWZN8MeaFdPTmFOtrnEyE+7/tisbyDkh0tGwtVLEPrKBfSfKAYlyPeZu6DkYVpfn4r9YEE8Lz2aAD/fQBDrBPIDisEpXJK/zpXU+NulR/UdR44XGUECEjrN4v/FU6anS7Gmr06q6ixCmv7gYwyqY0ACY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 1, 2026, at 00:46, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/30/26 18:04, Lance Yang wrote:
>> __add_pages() returns on a sparse_add_section() failure without =
removing
>> the sections already added in the same request.
>>=20
>> For memremap_pages(), the failed range is not counted in =
pgmap->nr_range,
>> so memunmap_pages() skips it. The sections already added in that =
range
>> retain their vmemmap mappings and subsection bits. Retrying a
>> section-aligned range can then fail with -EEXIST.
>>=20
>> Save the initial PFN and remove [start_pfn, pfn) on failure. For a =
vmemmap
>> population failure, section_activate() already cleans up the current
>> section, so the rollback excludes it. If the first section fails,
>> __remove_pages() receives an empty range and does nothing.
>>=20
>> Link: =
https://lore.kernel.org/all/BAD58999-1EDD-4A37-ABA0-DB1BD8AB3453@linux.dev=
/
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>> No Fixes tag, as I couldn't identify the commit that introduced this =
issue.
>>=20
>> mm/memory_hotplug.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 796af1028ee2..ca4656698148 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -380,6 +380,7 @@ EXPORT_SYMBOL_GPL(pfn_to_online_page);
>> int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
>> struct mhp_params *params)
>> {
>> + 	const unsigned long start_pfn =3D pfn;
>> 	const unsigned long end_pfn =3D pfn + nr_pages;
>> 	unsigned long cur_nr_pages;
>> 	int err;
>> @@ -413,8 +414,11 @@ int __add_pages(int nid, unsigned long pfn, =
unsigned long nr_pages,
>>    SECTION_ALIGN_UP(pfn + 1) - pfn);
>> 		err =3D sparse_add_section(nid, pfn, cur_nr_pages, =
altmap,
>>  					params->pgmap);
>> - 		if (err)
>> + 		if (err) {
>> + 			__remove_pages(start_pfn, pfn - start_pfn, =
altmap,
>> + 				       params->pgmap);
>> 			break;
>> + 		}
>> 		cond_resched();
>> 	}
>> 	vmemmap_populate_print_last();
>=20
> Makes sense and LGTM.
>=20
> Do we have a Fixes: tag? It probably dates back quite a while ... not =
sure about
> stable, we never saw this in practice. But if it's easy, we should =
just do it?
> (not sure if we ever had __remove_pages be limited to hotunplug =
support)
>=20
> I'm planning on picking this up and sending it for the next merge =
window (so not
> as a hotfix).
>=20
> Looking at this ...
>=20
> x86 does not really expect add_pages to fail:
>=20
> ret =3D __add_pages(nid, start_pfn, nr_pages, params);
> WARN_ON_ONCE(ret);
>=20
> That's probably something to clean up as well?

The warning is a historical leftover. The original code
printed an error when __add_pages() failed. Commit
10f22dde556d accidentally turned that conditional printk
into an unconditional WARN_ON(1), and commit fe8b868eccb9
subsequently changed it to WARN_ON_ONCE(ret) to avoid
warning on successful memory hot-add.

There is no no-failure contract here: __add_pages() can
legitimately return errors such as -ENOMEM, and those
errors are already propagated to the caller. Since
WARN_ON_ONCE(ret) has no effect on control flow or error
handling, it can be safely removed without changing the
failure semantics.

This also reveals a potential bug introduced by commit
ea0854170c952: when update_end_of_memory_vars() was
added, it was called without checking that ret =3D=3D 0, so the
end-of-memory variables may be updated even when
__add_pages() fails. Returning immediately on error fixes
that as well.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



