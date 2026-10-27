Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC2C606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=rQbXiCep;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=BkFc/OuK
Received: by kanga.kvack.org (Postfix)
	id 2981E6B074F; Tue, 27 Oct 2026 09:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FE06B0751; Tue, 27 Oct 2026 09:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EFA6B0752; Tue, 27 Oct 2026 09:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BE96B074F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:45:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 828CF1409B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:45:13 +0000 (UTC)
X-FDA: 85368527706.26.C58470F
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1692A140012
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:45:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r QbXiCe";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="BkFc/OuK";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108711;
	b=hFdkS434BjcoUitW5QZ8NJp/pKfLDmuUwpDXp1psjSEMPFya466vDTVdE9SvWTacXtCWcy
	IvbVgx4KwHfX/UrWLxeRA5JDTDlsZd6RlzTTc9iXU2jaOViRVn+31WAUxMF9SWVMTrZXMF
	aEgT7F5sNfrKf1hSxbGTajFemFj1KRU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="r QbXiCe";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="BkFc/OuK";
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.142 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8TAIza2maHFoLukZ9iYbRq1qc6+ujGeVY4cIhriAjjI=;
	b=GVkSgJzKfVjgBaCZkZLKJGKaakHAon6DAz2fOlM4CYaK+MgOgb/hDF2cem2wKMHBQS9Srh
	nf8HSxN+ex61g0gujw3vvSlIJdnijywi7FvHMjjX9sT/n47tAd9UmEu1qDsd1iu9zn06v3
	AFOkYUNkJWahzne/7TgjZD5MgU9Q5DQ=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 3129D1302987
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:45:10 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 27 Oct 2026 09:45:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793108709; x=
	1793115909; bh=8TAIza2maHFoLukZ9iYbRq1qc6+ujGeVY4cIhriAjjI=; b=r
	QbXiCepoMvMX78v2pXgxAc3L4YBN1LsHDtFluN8UK4w3oM2o+85HbDzIVIv4dXfn
	38sJseJaFFbHwZjZjzsMhJ8O95gQlp/Lk0Cmi4tuzI64arSFOqjnZYzUL57W9845
	w5hiLemPDctUhfWBO3cv0ZFm4SYHK3hKx4P9yIQmHSIjTAPBv7Gzl7aFCORgZrKX
	2xWFOIlDi9j5aYaXgxIvMTfYW6TIQWN34QbusR5bNMOjbL5+wsru9ykM7SRlbY8T
	3iuH237OqrxSrt8iEJGFHUduXngz6dZGR/X9J1J3PGR3EB51XMqFCSvfI0JO7Ody
	MYtLuF2aYVmDyu3luLzVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793108709; x=1793115909; bh=8TAIza2maHFoLukZ9iYbRq1qc6+ujGeVY4c
	IhriAjjI=; b=BkFc/OuK6ZU1iDEjgXsHUFdtgBRLUTJUUEKgfa9w+h0ksmiXSTR
	QOPFjYZ7WU+pI3YTlUOEZMOZp/a4Kz3TQqmOKLWoKLOXR/Oo7Oq6gHv6AmufAuNU
	6AU1sv5sXZSVWxvGF3K9imo+rSAS5+Y3NSFfSvUcKTG/+nqRmGSHadxQfrKqJTQs
	m2qdEx4jTmfGKOz/R4CM8ry5bR5VodN7YTg+1zCy+mBk+A8LLHOk6wGLdqLi8oH+
	B+JQ3J+le9+nVf+HJSVHurb/NHyqTD0an3GZ2db3zEnpVATYfEWZPJFYvrJR1oSx
	5AEw3lxrq24hjW6fPsqnmo9EiwXC7H9jUCQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793108709; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:xp2MvSDj/R51rJmrMIZ04vEtjrNTINQpLSnquTAiWC2vvgh
	0JcpmBzoeVltfVE7k/ZA6MVV/ViHFsBJxEQxLaGJ7yHe6bW31eUdZ3M+oD/dIBqv
	Z1D7nuT6Fy9AVWkXvG8I8mdjd4coItb4+SoVCQGQAdI1pgzamIbb0uTbEmMKuGBb
	lZogikewUKejSap0EkVxYxRND+k6u2KOANwb+7xjp7v9zLhkkqOyEkQY94E5ZwtV
	eXQys7NTJXB2w20JAR8mlcS3MQX9VruYN9AzPOccR9gZANTgyVwMAusTpHdZ+MPn
	OYEe9mykMZXVRSYHZk6wV9SeiZFvXJEgYlvah0g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:seaL8eoUk9zz7RKlbs/WO4VFngl+PPR6zsD+uJ3Mc/M=:Enih+tl6eKbc4ggwNBptcy2mvOiomnW/6tHkarBfMLI=;
X-ME-Sender: <xms:46rgasQk3ATXoQlHGjlYmuUDjSQehUiJuO75_MfqTS3uwPRLu_wIsA>
    <xme:46rgan11uqiyYSdgHiJXmG5QnS1EDBnVXq6mGeSsgsrEOCR3a6_g2S7o2cyvomTzm
    ZZa_QNqot9iI9Roj0DWugZ96g4SKX62q18Q9B6J3Hs3sbKRGB_Xapw>
X-ME-Received: <xmr:46rgap1PkLRQUwyTCxzr0telQ1P9i-4_Phsd-V1cyR4QwVZE_DZCiDPDoP0>
X-ME-Proxy-Cause: dmFkZTGblqe+wfRiQe8bcmkWYEKf3fZ/EiWo5l7bp+xDj5MkloEPRlh17pptfO3Q5h+fqJ
    tnwEFFeraUcTpHK/tCx+CFZKuwAI9oAZ0CLgKu5WtNsHXbF250PIeIsdaPnp5LB4TK8mhU
    3nns4LfB4Zb+Gp3SuArkJViR94h5KQbl5QTycoy4R1g6lI2N0HZjNGIm1/REnmCSE4sSeb
    iO9NqRbEJ6d4mXWOaptabctmr11CwGRSteBTFl0vIbKml7k332veFp+P4Y64yWzaWlHibG
    Ewcvn2Ke2kyuD/kc9DgTOu4B6JFDMG09zfFLBSRnyziPPuYJSbTWmODezy3iyx4WZFFmYg
    AKcGkfvKZ3Jn5tMBUDtbg8/qv8CjlroBAxGH8XbxFUcHUfdWZYLaJrKeU/3ZpR3iLu4k/4
    tdze24ILcsucOqdyrCjtnaa6N9ElZnbYkKcFhdU4rFr6+ipli12b2fbq5vGvVNLQE0Bm+j
    4Z58gp6/30oTfcWjMyZEG454nT+YEoqoN8YOoCfC46f8hOw6scje4vy3HXntvGyFjtI07Q
    YuLghAS6wlzOoQg48qg9z2d9JNOhFzuKm5IfqBJ9OTB/mAc21zfw0KhF6XU7tU6512y5Nh
    gc8xPuKLL2Kj6fvREKwSuTfhh9PbqCiVuj0nX9AA3UioLAXC56WYyiFhjoEA
X-ME-Proxy: <xmx:46rganCSTWOYxoqEvQYDO11fv7rB5mKBaWaqdJW2oHHAYT9oO5qgOw>
    <xmx:46rgaldfQE5UbEhMGsBcWVrD_KfEwjuoJgQpGnsMuo64AT4Firlkhw>
    <xmx:46rgao4Jnzqcv1bFo7EPmNvUWPeBDlcV6FZpWbMo4bPp6vB_TDa8Kw>
    <xmx:46rgaiRCQE_k7-iCJwGDsDXClD4aAZpjPLZRtSBsCpBMJIustJdVgQ>
    <xmx:5argat7gTGe6XnTgOpEjZVHu_v9aliKhzaSspQIOg9cv6OQc_EWgFnAo>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 27 Oct 2026 09:45:05 -0400 (EDT)
Date: Tue, 27 Oct 2026 13:45:04 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, ryan.roberts@arm.com, abuehaze@amazon.com, alisaidi@amazon.com, 
	blakgeof@amazon.com, dipietro.salvatore@gmail.com, rvvandan@amazon.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, linkinjeon@kernel.org, 
	sj1557.seo@samsung.com, yuezhang.mo@sony.com, miklos@szeredi.hu, agruenba@redhat.com, 
	djwong@kernel.org, hyc.lee@gmail.com, almaz.alexandrovich@paragon-software.com, 
	cem@kernel.org, dlemoal@kernel.org, naohiro.aota@wdc.com, jth@kernel.org, 
	willy@infradead.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	ritesh.list@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	exfat@lists.linux.dev, fuse-devel@lists.linux.dev, gfs2@lists.linux.dev, 
	linux-xfs@vger.kernel.org, ntfs@lists.linux.dev, ntfs3@lists.linux.dev
Subject: Re: [PATCH 0/2] mm, iomap: account dirty at page granularity for
 per-block dirty folios
Message-ID: <auCqlqe97AMeqKHY@thinkstation>
References: <20261027112702.3747009-1-dipiets@amazon.it>
 <668c53f7-20b4-4400-b442-71749db88d03@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <668c53f7-20b4-4400-b442-71749db88d03@kernel.org>
X-Stat-Signature: paesr83nr6hs93uyri7im6ypqks57bwb
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1692A140012
X-Rspam-User: 
X-HE-Tag: 1793108710-304676
X-HE-Meta: U2FsdGVkX1+Y53ZoulNQ5ibZvI08a9bCUDSXKjsD46fp+BeirYG2DxXDK+zWgtxGEcWCPc9+8FEPewImkNG3F8/Q6Nikp0yBPt2ztqFvoWQKX7qRKhnpSkOoSFOMuvmaAoqgIhPxmSrOHpVtHoB//6TdHeQi+rUawChFBIzdoqyE2nk6E6Q0WKHHtaT1vj6b7Sx+U6Zksb4JsftGoaQKu8GJCjXW3UmD4rpbdOIC8T7grXdFLYskFPNx0uJjCK6A2Qw9RLRf318YkIEIK0vzXRdZGs3M8/PrIFrbFKVkLf2M26j5riQMCrcbbqgZoViS2tx0gNRW6U1+Lg5lX61WNRyptvZjwzKrvLB1bg9+kTdiYai9KVdYmDyR0BE/qZwYQEkNJUbJZEWjErH9fJTDW8uUHkmRwDTxp2ymtic5HLga06JajjgagZfWBUyMBRZ0OWPGx7mUjnnUkXt4YGmdWwp9RRd43wdo60Y42s7qXYCyKUFZCrfulvQIyFO0CDAOhiV/FtbXq55KrGh+KGBJNTjRP9ZQwizJfjTqQfhS6KZUwUolb1Thc9wTfvgtIm71DDHsa0WHOdhZ/GcV7rQ9WTrlKVHBmxsZdNZzEII6+Y33MhPsf/2kQ9UWLLht39PAiFWBR8n8hGtINwDjdXEzUvrxGVMbk9Ox7f1e82B4eJLnFbr2dAu9KvJ8mVreZJjz9YDsXd8bI9mOBIASSA+lOhxHV4ustGks4vKVxmFzV6f5rfTEL6zZBgh21aVjnchT565XtmEuztZi34rFTsnBxb7RNOwaSFzDiYi3oSp9e+2PvGgOE/G4Fr6RQxF6p57Wfsa1R/UMFw1ToIskIg69+3cepKcjbS2a1xJJUZpwWFADLp+ZW6f3I4gA9KmbeePXFE79VOVd9wJ+dYpyx8pJ7cevOz9GyiyYzOljWLrHz1FEmCASM7LMDyt0oFy4mcX4E5tX9w2b3CBn00gRI7X
 DCxa5lar
 902zIp+71+ICTI8bgTGpTlHGy+lDTJjNHdz2XxaU15cYH8x5kolobZDDIaOVVatcuNn9qjPEXSZnhjlEqHdxklQOgGyRbyIXBCyC9s2QfrOQsZt9y3P/X3ivpQRsDuOyron9YvR46juqJfLr03d/yiukhDiEgiY0CUxpvi5wObKCzwDDpMOhIHrIgoDOqc9bUTz6wJ+IyDarziBf4ADRxUwXWkL8cX9QYCmnSem+d96PSocIx1VH7H8zQQy9acVJhtKKfYZMzfzdJtQP5ngHsUHfxOet9t20GGTToIn7djVVhy3/jaDwBDuK6ZPWJfuZrSTqzOuckQQzvYgP7dBgAzCV7W2WxA+Svc3xOlBQeB48XqclhaUNTH4xvIP6KtHPj2+h1M84FK+0hM0MtUaCKICFnXza6Pm2550NRnooYtE2IAnm0ixFGjEkq4ZBFPfqA+s0Brc4vNJjeIZ9oZ9+bSBLg3Bavifg/wTsf7hj4iI0TseDG9kd+ZoMNgVXyXlyRW10uCjdKE8hzGa9m24iHY4ns4uRgNjokGtUXOFh8wqaSzbiDafhxb1a68WBEyOFptkhTQ+qaYkMG8zw0Qls7ZUa9OOZgVvGQBADwPOrztgWOsVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 01:22:22PM +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 12:27, Salvatore Dipietro wrote:
> > Since iomap gained per-block dirty tracking, a large folio can be
> > partially dirty: struct iomap_folio_state records exactly which
> > blocks are dirty, and writeback only writes those ranges.  The mm
> > dirty accounting, however, still charges the whole folio even if a
> > single block is dirty (up to 512x over-accounting for a 2 MB folio
> > over 4 KB blocks).
> > 
> > balance_dirty_pages() then throttles writers against a number that
> > is unrelated to how much data actually needs writing back.  On
> > workloads that repeatedly dirty small ranges of large folios --
> > e.g. PostgreSQL, which writes mostly 8/16 KB pages -- dirty_thresh
> > is crossed and writers are throttled long before the real dirty data
> > justifies it.  On the benchmark below, run on v7.3-rc7, the
> > unpatched kernel charges ~159 TB of dirtied pages while writing
> > ~6 TB to the array, a factor of 27; with this series the dirtied
> > pages charged match the data actually written.
> > 
> > This series makes iomap charge and discharge the mm dirty counters
> > per dirty page for folios that carry per-block dirty state, so a
> > partially dirty large folio is accounted for the dirty part only:
> > 
> >   - Patch 1 adds the mm infrastructure: an AS_DIRTY_PER_BLOCK
> >     mapping flag, an @accounted argument to __folio_mark_dirty()
> >     and __filemap_dirty_folio() to skip the generic per-folio
> >     charge, and an address_space_operations::accounted_dirty_pages()
> >     callback used by the discharge and migration paths instead of
> >     folio_nr_pages().  No filesystem opts in, so it is a no-op on
> >     its own.
> > 
> >   - Patch 2 makes iomap charge per dirty page from the per-block
> >     dirty bitmap and wires iomap_accounted_dirty_pages() into every
> >     iomap-based filesystem.
> > 
> > This was benchmarked with PostgreSQL using the pgbench simple-update
> > workload on v7.3-rc7.  Average throughput rises 46.8% (139.8k ->
> > 205.2k tps) and run-to-run variability drops from a 23.60% to a
> > 3.98% coefficient of variation: the worst iteration improves from
> > 97.9k to 191.5k tps, while the best gains 8%, 199.4k -> 215.9k.
> > 
> > Ten iterations per kernel, same database and workload (tps):
> > 
> >   Kernel                     Avg     Min     Max      CV   iters   iters
> >                                                              1-5    6-10
> >   ______________________  ______  ______  ______  ______  ______  ______
> >   v7.3-rc7                139.8k   97.9k  199.4k  23.60%  164.4k  115.2k
> >   v7.3-rc7 + this series  205.2k  191.5k  215.9k   3.98%  200.1k  210.2k
> > 
> > On unpatched v7.3-rc7 the worst iteration lands ~51% below the best,
> > and throughput decays as the run progresses: iterations 6-10 average
> > 30% below iterations 1-5.  With this series the decay is gone -- the
> > second half is similar to the first -- and the coefficient of
> > variation stays at 3.98%.
> > 
> > The over-accounting has existed since commit 4ce02c679722 ("iomap: Add
> > per-block dirty state tracking to improve performance"), merged in
> > v6.6, where the ifs bitmap started recording partial dirty state while
> > the mm counters kept charging whole folios.
> > 
> > The throughput collapse bisects to the v6.17 readahead series, first
> > bad commit c4602f9fa77f ("mm/readahead: store folio order in struct
> > file_ra_state"), which lets readahead stay at the largest folio order
> > once it has ramped up, so a single dirty block charges far more than
> > is written.  Patch 2 therefore carries:
> 
> 
> How does this relate to
> 
> [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap writes
> 
> https://lore.kernel.org/all/20260903182943.662461-1-kirill@shutemov.name/
> 
> ?
> 
> I assume they try to solve different problems, but would more fine-grained folio
> dirtying also make your solution benefit?

Yeah, it solves different problem.

And I abandoned my patchset. The right way to do this is to make
page_mkwrite() per-page, not folio.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

