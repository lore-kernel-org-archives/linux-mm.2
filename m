Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81FFA60A3819
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HAjvAPma
Received: by kanga.kvack.org (Postfix)
	id 972926B05B3; Tue, 10 Nov 2026 08:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921F16B05B4; Tue, 10 Nov 2026 08:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ED376B05B5; Tue, 10 Nov 2026 08:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0ED6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:48:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78038C01D8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:48:26 +0000 (UTC)
X-FDA: 85419339012.21.759ED3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6707010000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:48:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAjvAPma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794318504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paY47Z+ZpDtoIZ3i7uCxhoYzpyOEXAiLycHInjnGEmI=;
	b=UZ4YdqUg0soZ20FLn9FrrQ1w98cOvCn33sfUTUzyLeK8XNG7hy+28k7dWdHAeUtL6UxRgv
	FIG3Lp7GRJ07xVV4u1vGOSy3HvPaQ7ZkAhXU3xdRVCGNHI1mrVuEhpyJVrEwtrSmO8b6gS
	m61cTh4t0D/YL59eJjc0jP/G+UBmFDo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HAjvAPma;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794318504;
	b=bm+tJ8uC3vxQfgxDR9S/IRdI8CWnvyrZLCGJX0QBVDK3GZtMJX6CmnJBVcr89PATK8+kMp
	EO0raMn5hlDWCDr5kIJK69n35tSuQ8c5HBKY/QKTX4uf2uXdyMG0Rk8ipc9I+N1p61QQKA
	6WujAm/5Mmy5CL/zM0g/5+stHDcTFuo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCA5D63975;
	Tue, 10 Nov 2026 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0322B1F008A3;
	Tue, 10 Nov 2026 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794318503;
	bh=paY47Z+ZpDtoIZ3i7uCxhoYzpyOEXAiLycHInjnGEmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HAjvAPmapJMkoy4+BGsY1KE4rbLUkQcBnvby8WbR34ltf2wXVPqqWfsphNv0kfeF4
	 0779J0tOWIV1Il3pIh4UmlzM+pVAJ1nllycACb3b2LrTtLTKNyhJWxoNEvwzoz3Sh9
	 avlZRc8D/6BtpljhObyqry2VYvqDb4FoJUGeGpRkp5Bf1CHJB73QJr6sgcc2P2R+Sy
	 23QnQ4++F50E44oMF/6sBG99YUrz59p958FqxX6eCf6GYZ6GY/L8JVNM8tUt0C/QCt
	 Ycw2utFjmDNvdb7eCvjzMbzzvYfTNuzMtWeTymvfjrJKvXRp43O2+1jLvbwZ2/q73Z
	 4r/j38/OROjFg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id F1655198003A;
	Tue, 10 Nov 2026 08:48:16 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 10 Nov 2026 08:48:20 -0500
X-ME-Sender: <xms:oCDzavwRUEkh3Vddp4PSkAeM6tYwnDcFdWnYYfdm6T-Q7VC7R74Nog>
    <xme:oCDzagfmTHU3GHkQ5Q8MLDdOaHxqrFkzx3ipCg1Pl-goEPGww5tyTTdpd2B2CVdNm
    Z_Zx9pEKptbgzigRp8DO8tdJXURqMx41dfGrcpQoWcX8e1Mb9qCHlk>
X-ME-Received: <xmr:oCDzatltycWqntVyjyxP-ykO1D4aOkQWOaI-fyD1FjJQIaFIZvahgdMSm94>
X-ME-Proxy-Cause: dmFkZTERFrmMnBfEvkf8isDUARn3LuFwW7Ic3uZtkKhgVTcfc3eTgZiX/QtJzVEtIhb0Km
    Ou3o5nwXL5vuXk2DLYMmnkH/Q3R8ZalE05i16qMWWGXsnbjWWsn+SCaNHyVwfcnAadYgvc
    Il1U/cdEkRkxAfIVrCfLvQHiea4wSG1MrTV9DcH2YSX8YJGc5IUiyeTd0fMr5I6w0hLSQ7
    RIdPa9cSpQyprJqlNhPy8EmcrljlPXLgBlLdLrhBw8nc5F33d3Hd4G/yEhSZX6ajSB/3Oh
    Y7m2UE5EtY5sZ3pqo5VhYaCgpnG9qC3Rns/dbXKbatMvGyYivQ9sj/YmTVE6EBA7q6IwW7
    AsgfBHSDTR6aXzqCJ+7vROrPBjGc8pAw1QyDWcKwCTF1pNRltDRLCsFo3pg4uyVTsTZRo9
    vLtv3+kE6N4zUjuUgni8CQWUnh0g193ZAYgjqwTXkDVYgGf0krgpyo0IvtpQ48b4BaP3Or
    Ko6E5PWqygPGBmT08euEqkps51bGcgqj1qlSftkPduuSez6CH553Vg+09q9yeDtZccaZdA
    sDPeoALWq7rZQDUdlNq21IxajBQxNye5v97mBUs6r16h9Nf+tlyN5/SlnekRgDzRvYiXjA
    oueyUXjpFqoSj3CCaMBcN+0q+xtDoJe2d4rVU/xIJbq7Er288kksauiPK2aQ
X-ME-Proxy: <xmx:oCDzavS96LBkUIy8jHgSlUKnBosr6fdOspsx_OLCYC31pcbhymEV4Q>
    <xmx:oCDzasdP4fD8ky3mgRKFW530OTJPqZa5WDG2lpq6FuR7eOxwlf84qw>
    <xmx:oCDzas21v4uys8Gvdesm_hGJ88SqVMvHHa2YMbvcs4ygURIWDvRfqQ>
    <xmx:oCDzatIlrWFH7Plvc1z6LKSQ19gaiwA85B7pgzmBsWUL7i_xNYwLVg>
    <xmx:oCDzaoIn1aCcUOuHPzHBn97SY3kDElFqvidVhUx9-hmbC6MN-q85eKmn>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 08:48:15 -0500 (EST)
Date: Tue, 10 Nov 2026 13:48:14 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Message-ID: <avMaQIdAj5Zal3rd@thinkstation>
References: <20261109-fix-split_folio_to_order-race-v3-1-1cdc509e34be@nvidia.com>
 <5a7bb477-5392-404c-a748-4748cec2c84f@kernel.org>
 <940CBBBB-D564-4D4F-9C8A-A9A272F08064@nvidia.com>
 <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3557629-d86d-42f6-b181-bf8540dc1982@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6707010000D
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: iqzt1dujjwsohtwsnbpussnicwtazine
X-HE-Tag: 1794318504-784858
X-HE-Meta: U2FsdGVkX1/6zcfL8JEFxqYQRAh+zUGeuBMWDR3hLnJc0iHbK7txKMpod6LnribZs39YBOLUb05y5xHJxFfApY8G58rxLxwrG8+0i5YF48JefDAmGMr5zIn2Rj/lYw6o/q6no8qKas/TrWiptrBQOnnyQSiIyapCYIWrpEXLtqOCSXRMj9Sj/zlQk5LdhtmTFLPUqZaPSX+P6WFzK60g2kzS9zrWu5e7466MBpsWT2RFlER6Bs+K+5BXsR42XXocYZNk0INlP2L8/Hz3o21Sr64NZxupzlSNb4pxy1nZ48cYjoltVGJyWGrr8GhuFv9CDwYtizmAmYb+XpZOfkNKnUG4FdpppYzKloITNTfZgfSL4TWsdU3HmAsPWrUdl4A35HwpKDM79nFt3BXujGfKppAZnkq+O9sESj7HcYXRTEK1ZsSA6pt551VGQheOcc8+pSeLpjOLMQ1MbTXV9fYwbYehb/kfzuubZCn6aTWJ7DLFu+geEdyfwKInCS7qojFxKpC1qvF3dPsedKIKTJsebWKlDXRnRfn+0OBUkDhtjlErVMwnP6bQp3PBXLuJnwX5Mzyy1JIAr7mwUL7W1f8FIw1QIeXm2R40Vl24+r/rY9a4GujyZJntbxln4sNwQibZN6SUbRiYJ94drUGne98zoTx9mKEsy/k9v7RWuHqrGZe+BAcKSReSHT2qVs7GLOhNP041dfpJySymPzmazguvUzIMg1YZupcBLzCna5uBlYHtX2MF5Jd5QgVUiGt+1dSfDViGyFiN21gFCeRqaCWzq1nk298XcMgSSm003qITlEtKN574qRTE6yuVFU3UUm9dQcnc6Nrp/eIveIfdDH6/DxeXCOG5TJGDC1lDZOTonWQQJwA3FLB9DKLB37QZqZI4IgsQd4yn9i3p+7O84RTovxBd/cZv2ufyD6CEsIfrwCnBnCDW4PVtss7N46FHHxwI/B90R5bmzYEMNfUG10G
 g5opv8xq
 DRTFN/qiSvXvUy92P7dU0cuaUJZN352X2PrEgKsGCIQNSwUMyxAKf7cFr561IQIoVoxE02HQLXRrCp19uYYM2h9vhpHTXEh4hPtAv+NakZl4XqQyhv+z962BiOO1lIZlehJkxZYRUNTJ5Sgg4yjPlLk9cUjMhzpixjBi6FcnSCfPaRMehtKGPk4RFmkZinedKC4+PJrwnTxe7jXqRwQQ9hP99NDF3Y/rMz9hTxw0avzJN5qxyMGkvnBB1rCbwMh0O2xD0SgXfRIrQjsdIh7F/vv7CMk+v0KKTu9/0gZuJz0rftsoMs3BNKwn5pfdUc3mr49fqBarf6OiMw9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 12:31:21PM +0100, David Hildenbrand (Arm) wrote:
> > This is V3 of the patch. Instead of using prep_compound_page_atomic(),
> > PG_head is written before clear_compound_page(), after which new_head
> > is visible to the reference-less writers.
> 
> I'm confused, how is it then valid to have PG_waiters set concurrently while we
> read new_folio->flags.f?

It is not. The comment names the wrong word: PG_waiters can be set
concurrently on the old head, not on new_folio.

CPU1 and CPU2 below are two faults on a migration entry that points at
new_head. Both take this path:

  do_swap_page()
    migration_entry_wait()
      softleaf_entry_wait_on_locked()
        softleaf_to_folio()
          page_folio()           <-- old head or new_head?
        folio_set_waiters()
          set_bit(PG_waiters)    <-- on that folio's flags

Which one page_folio() returns depends on clear_compound_head():

CPU0: __split_folio_to_order()  CPU1: fault           CPU2: fault

                                1. page_folio()
                                   -> old head
2. flags  = new_folio->flags.f
   flags |= folio->flags.f
                                3. set_bit(PG_waiters)
                                   -> folio->flags.f
4. new_folio->flags.f =
           flags | PG_head
   smp_wmb()
5. clear_compound_head()
                                                      6. page_folio()
                                                         -> new_head
                                                      7. set_bit(PG_waiters)
                                                         -> new_folio->flags.f

2 and 3 race on the old head's flags word.

That is Ye Liu's KCSAN report, and it is benign: PG_waiters is not in
the cloned mask. new_folio->flags.f gets PG_waiters only at 7, after
CPU0's last plain write to it at 4.

So only the folio->flags.f read needs data_race().

The new_folio->flags.f read needs nothing; the READ_ONCE() I had there
in my sketch was not needed.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

