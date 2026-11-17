Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7822A606A339
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wp6qXcbI
Received: by kanga.kvack.org (Postfix)
	id 8EA396B05B2; Tue, 17 Nov 2026 05:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C17B6B05B3; Tue, 17 Nov 2026 05:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7046B05B5; Tue, 17 Nov 2026 05:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB126B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:34:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D557540396
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:34:01 +0000 (UTC)
X-FDA: 85444250682.07.487CE49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id DC9214000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:33:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp6qXcbI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794911640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Y6jdRs43MMUd5mnE51/FCbB/e1QngRZEN/6HJJEEn8=;
	b=U1MTYbXU4lFhpEiv8lPicOpfo4h3oHw+r1Gt6aYCfUunfuQRvHokDY6JOpSHfDFFJBaZW+
	LgN2KgZ/+eO8YfEuHHcXfJxkcAfhSrCaubdSC5NTtR649Ah/1T2woFZdvwUDEbgIqZxQIy
	zBkogCQhXMJaTAsB0f5+ac7GZfW298Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wp6qXcbI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794911640;
	b=3jcetqrLHn2E+gulh4v5kyFL10F99iOepDy12eeAHsuIDMPIdHkzt3AyYcnEM7yDkD4mNf
	i3z6+ewANMO5njyYv7CgVzNKGZUKXeZjPPM6hya2P62K8HsWqfvLk54btgNtUGzrv0aJwB
	YoXfWOjUFM/m1RQJFl9PjgVgvacoFqk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72415618AC;
	Tue, 17 Nov 2026 10:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03E61F000C8;
	Tue, 17 Nov 2026 10:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911639;
	bh=9Y6jdRs43MMUd5mnE51/FCbB/e1QngRZEN/6HJJEEn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wp6qXcbIQIE4bpxyM9/SXmq2rlIdWXyLmNwraaBrkNWV6Sdu92icFVFw9aZ6qHaj8
	 TM7d+AIbTJO4p98FbS9ecNFjyga110pcsPyeonG81MvaN8UBHdhbWSblvMqGPw8I9v
	 eImA3xLaN1XHowsn0syJtwfQTVThF3r/GyZW3kbs05gF9HB4cuYlfvElS43YqmgJfj
	 vp19XDmC/2FTNKIFzbcvmYw7ZZbaTQ+GJ2H04FDxIChNqtjGKTivP71goojxX692TU
	 RuXy8t/xkX7Z3LOOG7zhO1ULXJq4ot8jtasJlLJbz96XbMhs70o1wRrLwQUtbxXsE1
	 mx074gg6G7K4g==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.ams.internal (Postfix) with ESMTP id 367B11980047;
	Tue, 17 Nov 2026 05:33:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 17 Nov 2026 05:33:56 -0500
X-ME-Sender: <xms:ji38al9U-A9k9GqY5Vjo6Wlp300UGDaK750bgl1O6jnux9bo3o5-hQ>
    <xme:ji38agYYWZT4Oylp-ZIjxdISzQbNyW08g44Opy1PUbkJ5_BAjdztGux4wAVob-ubF
    sGPFtoBD68Swc3B45Gp26HVb73yHY3HasbRLHPddQOTS4i04CCVjAJS>
X-ME-Received: <xmr:ji38anfzunD68jqATVMcyffrfLUwjJrMTeHab3NZ6oSzI8ot9X95jKgIBl4>
X-ME-Proxy-Cause: dmFkZTGPoCZIOo/tLs+Jt+MNHEmRpH88IwE5gjVBo57y2PhV3xWyC7Orpw8u3hp9Sbsccf
    sXwt6xUeMAogQH7zZvv/pYlPFYqWnSoj1Rdm2isbXzFwg6zfm38sm+AQpZvy49cVwXdb7r
    vVlDCMrtvmBVbG0q+uBYPlLixR8jQfegKQU0DMP3tRnaXusL5beUtu65ZIuBoACs9qAJnO
    omyZk6X+S08zPnin8zP6uc/QQjwy9dVJp4qPj/VrzVDDlxNGwYHUx3loE+Ute9wlrCfK6Z
    fE23V+MKFqIh5EKMNNDVh8scW8u3EEK/CgMlNw+xqUGFFsvMYQ/ROnA+NPMY6/OHiO1SMu
    Llo8g7ojqT75VbxWo5K+LFkZVEo/rBG59vu1epq9BFxhrECQ9+7upcL/ZIv88Vp1qr3Kdn
    w+cJ4GLs0MJMFFNjsC0mgyfGTJgXJYCxsPiALYLd3+5vOXbHayeaaXCNOv3ECHgO7PrHEB
    LS9ptwb+Nz8o+Nx2gdYuKxTRu5QjJv/+TTlM1OInQxL95R5VPySwvBds6Jkp8SSqVa8aA6
    WpfEFBCXDfQBHlHX/LLFFlUUQoFakSH6XhebYIY3Gm5EyPZf9uGeaHEHpsK47gblP6/yOP
    xM2WhpaJAgTHegCsiQIfKYIwh3upci4zvXmLjwR0HLdlPoIhYddkxGKVHaUA
X-ME-Proxy: <xmx:ji38anriSs2E8qw_U6l9QyA8TecYQEH3pa0tNws1LYfT0wFGFXoTHQ>
    <xmx:ji38ag84_WU6TMq3OYf9z6IWk2cPUzK8V8LeZZL951tvIqHwSxqvSQ>
    <xmx:ji38arISS9EdnkQK94hqvguI-cTUOEI5QfrugXTHLcrEspAUGbpLtg>
    <xmx:ji38amOnf0c-5KjEHTTH38TWSpEGmU3PkR2uCycMfvadPdGaqPUjIA>
    <xmx:ji38an_oN9qoF0edvVZ0A4Eu4hqrbBuA7Alhxc9znTtQp8_OHztP9YFm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 05:33:49 -0500 (EST)
Date: Tue, 17 Nov 2026 10:33:48 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, byungchul@sk.com, gourry@gourry.net, 
	jannh@google.com, joshua.hahnjy@gmail.com, liam@infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, 
	surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/migrate_device: avoid leaking folio references
 during THP splitting
Message-ID: <avwtWUVHwcJJKfWR@shutemov.name>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-2-usama.arif@linux.dev>
 <40f86b39-96cb-4fb3-9282-ec06504774e5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f86b39-96cb-4fb3-9282-ec06504774e5@kernel.org>
X-Rspamd-Queue-Id: DC9214000A
X-Stat-Signature: bssdwgk4srg3aj6z9fo1ys8oga6dy5eq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794911639-311397
X-HE-Meta: U2FsdGVkX19lcX1fiThhUGgMWc6CBUjTcE2tcxiR7BEm1bErteFuXmit2f4iDZ7OCJOEVDZunkxPISrimngUF6Hu/SjyT0iQbgaEu3prFlAUCSsJnhG2lUwAkQNcUaR6pmEFzw+lZDPACkgN3ik4uorvRKG5Vw1pdBBLl8g0sOtB6kggnO6tMuFKct0LSAJoOK3kmn8Hv71pm2EzhQqh72ViKCakzWx45cyzK9FJ8GU/ZMgrxRmLRGWjnEqNlBN2nACRWABCqHFGOAfuXkEHgghKT4q+d3TymnsDWumNaXjvF4drM9WHWnHw0+t1bySIFBH0YUM2BNNboJu2N52gnWkaofKoF8jn3zxN0OrpfUWcyYVss6nC/5cGDvv7pgOFX3vcf01zbj0vB2UnrXp/22l/PxN8ULEyldw5Fz9FM63ZM1sQUTGDIQr3Xz+2cjhQiJd/Z47TpncX4yGaDXHMZkMpXDJmU7aqOTeTdXrr+kkxlnQXue6edzjnP/sr27fPw1k71D5DPw5CGmKgyL/P0vhy/UjbmteFQcWdJZ0TONkvc8j/jjMHxlWePqMh56E7vvhwF2Kiqt6PM/6fJtoctRv8QeyNjJ8tkhsfIZBybyB5yVh8nUGu2HLEpFJX/WE5qZf+rsoxtP1ev51dc0+8P6C5vzcLLxxGN+pHF8d/9GNTvp3B6//tjX51RXKVag8v55gjeasYvXtjWAFh5hhIoIDdPYUiY/kmnqNX/73uYl0pWQ+o9S2aW/iv5wWTpbauSebva9xxHfWdWpBFYP+KSYVui1J67Ysu7oJFQaMV2dYqnxnG/bLaF4OlRA2FFOF62k1sCcBzv4ddr1G1YoGH9z+20SBJ35uWXJDPw+rZEroBn6ZfBq7LcDwIJJIaizUhLvh1QPmegrH1a5CCTGfyhZWk+UB2VSa6ldzwxK254sWzFZCrlLVBrN9ZgaRTCnjOe2Av/OnEOiXGKOm7hit
 vgJ9SBGH
 LCyFHikcEdGOQv2ajJ3ISoWIB6qa9K6XwbKSgKzH3gsIYGvHSsAzoDDn72SgjUVezPuFA/n475rtEdjUiqQjZzZ9QQMM5/TYcrzjikrkpIMUASa1e/08iO0QY3Uik+iXFcERW2VRYYy0U7fd8aitNCtZJQYmLJzrqZPG1qRhz9fgcb6rQV5Vp0sbey2pIHZXe53El9SmeVxaVchtQM3CIz+1bwoPhJ+iAdB6cTMmfRGBwlBEdC8CbQHNDTkVI0Gv1Pf/a5eYb1VF6oDRFEBvphRV6CLW0chhGbFK+gyEhDhy9SgjJU1keh2V7xhrOvLAp8P50vhUU2uCrBmKdz/eSPYJXW1BNt9Ryr2u2nOLA75Vq60NfHk+pfWtRJEK7AoYz8DA3OTZoET2evp4MuhdTcIhu6tsVIpY8PDwC8jQFi7oOrPz0l6SN4xMlSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:44:42PM +0100, David Hildenbrand (Arm) wrote:
> On 11/16/26 07:34, Usama Arif wrote:
> > migrate_vma_split_unmapped_folio() takes an extra folio reference because
> > split_huge_pmd_address(..., true) drops one when it splits a PMD.
> > 
> > However, migrate_vma only holds mmap_lock for reading. A concurrent
> > MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
> > entries, before the split helper takes the PMD lock. The helper then does
> > nothing and leaves the extra reference behind. folio_split_unmapped()
> > fails with -EAGAIN due to the unexpected reference, and the reference is
> > never dropped, so the source THP is leaked.
> > 
> > If a THP is faulted in at the same address inside that window it is
> > worse: freeze = true replaces the new folio's mappings with migration
> > entries that nothing will ever remove, and drops a reference the caller
> > never took.
> > 
> > An existing migration PMD is expanded into PTE migration entries even
> > with freeze = false. Use that mode and remove the extra folio_get(). The
> > reference already held by migration keeps the source folio alive whether
> > or not its PMD migration entry still exists.
> > 
> > Reported-by: Zi Yan <ziy@nvidia.com>
> > Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
> > Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  mm/migrate_device.c | 7 +------
> >  1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 9e19fadfa65c6..3286bb8a4b73e 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> >  	unsigned long flags;
> >  	int ret = 0;
> >  
> > -	/*
> > -	 * take a reference, since split_huge_pmd_address() with freeze = true
> > -	 * drops a reference at the end.
> > -	 */
> > -	folio_get(folio);
> > -	split_huge_pmd_address(migrate->vma, addr, true);
> > +	split_huge_pmd_address(migrate->vma, addr, false);
> >  	ret = folio_split_unmapped(folio, 0);
> >  	if (ret)
> >  		return ret;
> 
> Oh, that means we can remove the parameter from split_huge_pmd_address no? Best
> as a cleanup patch once this is in for-next-fixes.

Yeah, that's would be great.

> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

The patch looks good to me too:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

