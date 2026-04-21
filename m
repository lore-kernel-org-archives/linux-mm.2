Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862EBF327B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 08:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44446B0088; Tue, 21 Apr 2026 04:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4996B0089; Tue, 21 Apr 2026 04:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC366B008A; Tue, 21 Apr 2026 04:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 864B46B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 04:33:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 258C55CC30
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:33:49 +0000 (UTC)
X-FDA: 84681899778.29.C4677F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 645D780012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:33:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdxaoO58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776760427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MekPvRqjIAMoeE7Unw+UbAirTnG6WJAm99PLVxecFMw=;
	b=rG7+mvdWW8pOh4PAY3zWM6HOlzU5oSDIlwoywW199N1iEgNSOS4Di+l0Xwg1grqzL1U5Ly
	qQ/xYmVBzpLAeDCNJfCV9QsJTVrAZLEtyEqNUmolIsxPinmZmef3PI77qghNLtVol2DHL8
	pVPSVHEWE4YAaw4GOKaMp4A2jpUrxLg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdxaoO58;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776760427; a=rsa-sha256;
	cv=none;
	b=FIkEHb/+/BZd04gaXKDz1fdIl6bL96SXuZBKsGjg8sBx0p0f/lRp3SfeHr44XKUtNsZShg
	W5JXlm6VXnGHBu2TVrImFw30SXR9Bz70UKb/tOQT6fW6PLuT99AJNAeKEaRP7++hGs/ITr
	Z2o8ps/hk/BGbI1idPqr6Lsw/EYlO1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67B38440CE;
	Tue, 21 Apr 2026 08:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1E8C2BCB0;
	Tue, 21 Apr 2026 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776760426;
	bh=jAjmS2dX1uxy+qP2Pq5KWMNhPJnTErwZDStpHkkhbnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdxaoO58sQEm1TSGhXQUFnrptBs5/Q8ZCZMv+b6320vi9MPa+wmLCvLzhI2XQivL5
	 fcl/D3JVvgVU/HjxVKmYwyCc3MyP6q6NQjwJtWWCSQrq/K34ShTQCSU+4x+hm7zgiS
	 6rrFZDR9ffndkJe/Mkjir6ZsOR5J9zLbMyU3SS2ovkCdSgy4t+O8voZx0eW3HLOLNw
	 ZJ7SS1/4jE80YdXQORw4kiSHQxTK8onpaohvLI5gxQsmebZZ0Usolfa7fvpiagL3Q0
	 bvnYkkbDVwlwswhRgW0HS3bnvGnpbZgZ+fgXTExJszm9aylSXjWYx+PBb3Pb4SQcLf
	 6PvwndTaIVCqg==
Date: Tue, 21 Apr 2026 11:33:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 19/53] selftests/mm: va_high_addr_switch: use
 kselftest framework
Message-ID: <aec2YXutD-X_YZsw@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-20-rppt@kernel.org>
 <2abd2a19-08cd-4d6b-800f-24e42a66f00d@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2abd2a19-08cd-4d6b-800f-24e42a66f00d@sirena.org.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 645D780012
X-Stat-Signature: ypmhiqoh5eb7131b6b1sfh6mxft17xsw
X-HE-Tag: 1776760427-356605
X-HE-Meta: U2FsdGVkX1/V1x+vRoA1V4yQ3FygfXmmL7K86y9J0G9H4R90NMug6JVke06UAFeUUhYyeZcO0aTX5Htgts/WnViWGv3doUUfecQyxBGb1FYA/a4d0BUOBAGmn0Km6uJGAuzcmwi20p6GW5nNRvf64L1kDxmYK4Tc3iXxiegdNWPXBEFH/7XtoQmldjzsdY3Pmq/R1x/m7l9CVeqD5lD7gSOV/qY/SVBmS0TgFRE0CdHyPW2K7Nih87Z93b2RIdMAoP1qYWG8hAlwfP6IHbMM1JvuOHtM3Il7l61dtXEXy/p3Nda+hkV0VugAm35lcLRbSrPgN4vFe7UruWUWb1a8fG3KjBMX0eprwoo/bCgNIhh2KzjXxAdCfmVmLDkHB9GYnnc5PcThMtKcS3ev0vHQ1tRlp7/pzcKSfKkwul3LEuNdYQgAhXqedQ2hWP1OKGRqKYIWB5Dnhhlj3jMJok0nfgrmlyRwSzGLzE7hvQA9WJQCNKqepSp2JLKk6QGTG991CuDbTqDJolbObKhdpHtDzJFABgMCxQLCpAItUkAsSBmSYnyaPNnLd+XHYDS3bZsJpS1dBxDGSzTDKOudtIa9FtGLeeBUu4fufvlszw7o/HS8p7YDQHZ3QXvj/R8lRtmqSayd3as2dbJIFzlPJ0oT6xu5l4clHYIhN8merQJnq7TkFU3qVZCkpCQOLEvR5afp/6uZVjNzGiDc5zKLGoohHbDUfIt2R4zsLIiVkpDkoixuz/QA61MEYr5luiiS+bd5De1HlJR8CCwv9ARwKT5PSx8kbPDFuTCrdMP5dNLIOoMiuZbqpMoKKEv9/B3GZYpW/ht7w7IBAJEBk2+88lgx5WuMSFmfsFBrI9vHzFoaXR3SrKaDm66UsVSvvyo7GghzwSK1SYNoaxzlCLSwQZOOEkDeFP8kvM5i7G2iyJ7/U4fHjUFoaQqMggJ5QurG0ttUNCjyqJnvWALmTrorPEH
 sggM++Sj
 kMm0FTe7YlWh8XWgVk0NxKEr9mTaVL8MPV2PJfjAhfxzHgVJerU4GJhv0v3NNBPc2kNnENgQ0hC08kh1eNRqd+dv2yAMMXGRB6J2P8MiOvozJYDXV2cKQyXOxoSedCAvWT+L3iMbUbnQhDd3DnOb9gcfdsgmxzkdnnkuaqrkUxO2apuG0s3i/KNbyml7L1Yh6jKMgfvcS84btzaoXu0P6iuM3cGRcZwE+tkwhGAjOKGWeZyF31UNNcsKs6hwnk1pSqBtI5hIDFA+TjELHm8bXDGOxWM9an0B8kC7rbzmORYWnTiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 07:11:30PM +0100, Mark Brown wrote:
> On Sat, Apr 18, 2026 at 01:55:04PM +0300, Mike Rapoport wrote:
> 
> >  		if (p == MAP_FAILED) {
> > -			printf("FAILED\n");
> > -			ret = KSFT_FAIL;
> > +			ksft_test_result_fail("%s: MAP_FAILED\n", t->msg);
> >  			continue;
> >  		}
> >  
> >  		if (t->low_addr_required && p >= (void *)(switch_hint)) {
> > -			printf("FAILED\n");
> > -			ret = KSFT_FAIL;
> > +			ksft_test_result_fail("%s: %p not below switch hint\n", t->msg, p);
> 
> The test result reports should use a consistent name for each test and
> log any diagnostic information about the source of failure in separate
> prints.

Ok, will fix.

-- 
Sincerely yours,
Mike.

