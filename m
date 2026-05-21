Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BA98CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE9C6B0005; Wed, 20 May 2026 21:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EA06B0088; Wed, 20 May 2026 21:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A65B6B008A; Wed, 20 May 2026 21:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBA16B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:00:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF6998D874
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:00:16 +0000 (UTC)
X-FDA: 84789620832.24.3564DFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1D7CD1C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:00:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=En9W2FUt;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779325215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyJB24P7MU0lOh7/s8c6PKCLDxcR2TJ5gd1Ela/Ygc4=;
	b=s4Chf0p7P3vI4YEbMvPsbW80GYPmuAUcsW8TyEYK6pArinoXqComLdCV/OpuVEmDVcyE37
	cGIoUGFQXrWu5N8OIZ8raaBB9ZbF0BioyH7ffHeTk1yGiz+1OVyJsfaFR/Y2Avu+6xiQ/U
	Tszsc/ss7jeXHprf97Gkf0LevzU+6nA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=En9W2FUt;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779325215; a=rsa-sha256;
	cv=none;
	b=8SvFRHfzYWjx7m/K9ARkVAy38X25PBtbfOtBGZPZakaV4hCtRcCtnicN28x2kiQpXPBdOW
	dV6lFtLCgvokfEyP3ajMseNHzGYFL510tWK5y7hR7HXFyKzcICcSVzTyeFaJ4GcQ5bTM4/
	Ua7DTbHQKPZVWiAtCA98ryVNbnpNjy8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 415424174A;
	Thu, 21 May 2026 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF9A1F000E9;
	Thu, 21 May 2026 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779325214;
	bh=EyJB24P7MU0lOh7/s8c6PKCLDxcR2TJ5gd1Ela/Ygc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=En9W2FUtcOoELe4Hhg+oCHOdLJTrliDx8iiDJcrZ1nXiPTyVZW3laDOv1US2KP1Qh
	 Ri0jIKsiTEEHyRd2pd1753kEKbY9KXUa9uMOq5pzd0K0ZxKtHOoafoPo8zfsj40IDM
	 gcvaHvz1/F3vsa4TLxGj71dtG8K5YUI6dRO/vLZDVDF9Lm8VRbtUsbNU/ncRR5i3BB
	 YHIFtAMTbTa8imvgjDIKhOyUEP/X5SQU9nw3rz186AJ+PKx3yXgpPPRElk4i2e5DgI
	 pyN5RRNx0PNMS1yylTbaJ2V9yMj8l9kPces4knB7WlHqUF+xXf5DBk99GGxV4PFpAS
	 wv7ePst3psntg==
From: SeongJae Park <sj@kernel.org>
To: Leon Hwang <leon.hwang@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-new] Documentation/admin-guide/mm: Fix typos in transhuge.rst
Date: Wed, 20 May 2026 18:00:09 -0700
Message-ID: <20260521010010.84958-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520051751.74396-1-leon.hwang@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xw7oioxexbtgby9e1nqdww96h1m1fq9w
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D7CD1C0007
X-HE-Tag: 1779325214-683163
X-HE-Meta: U2FsdGVkX19v7Qdnved3s/J2TFRwbpSx5jlB0nWhr2M341+xeEkW/wZxQ5FUJJHz3mBfWBzKcNs5B2ML2Jf/5DOr2DgtdouR5e+05UlmiwOvUotnsprBchxy6quel1ld5ddfRm3RD3fbi8IJ8YdXcne8kMsoFck6X+jTeNWDxOiGmpLiNvfoSaozaUAciL8cwah2M9u8TkrJZgeWyBWnPIzoui/IIXOs1p+JNgqi0Uth0KXBxk1MdkpsTlS4ltkxA1E3t43oaksjF4APnm+MGWYy3QFdaPNUAAoMOGcTMgDheY9fsAsedLi+4V8qPqmhFu6Fnvs865GwfEmu74n+wmCTU5NyLCT48I8P1pLCEs4GGszGsCFvhQwzZ5swB7lOMYeyd50hqxAgeMe2+62V1+/NsqF12coy2ko343Z1ayU8VJ3CROZh/Vefy9ijkDG/V/wP0Pt0iD0GrrsIA/2Tu+IvATbTaHpFzQrhsWJxWP12jPK2DN81inywimUrJxAfppXOapy/FMBi/IN8tQdPvqaFYrpFtyEoaKirOqhmcrfvv1gD7xIVtK1xENNB4yhKrOZADNFCYjuVDfmMmji2iWmj+hvcyIZ5eeScx9CUeu/9sOmjgexfA94vBciOyDz70rF2heCMlD/cRDtammDOfzfdV04WAwf0hCcyIfF/Hv7Wp4+XuByQEVLDJj2u1bRIY2KWCTSr4VNLvootiV0P9x8LJY1aX82OE75bEFEz9D5KNQQdS7UMgNKexpFrpWdsEHBab70Wd+ZPLS5YpMkXMbemmLqqGe4dOlxToB0MDglnCdq9ztGr/St98MrdrwLRO+bGEs9BzNasGlOF8zaYhu9YNtijc2K7AGgmWnz60sWFS2KsEi0T9cgyzhTBDunrM5rQUn427nhCNfhGuZD5tDx4SZd0Rg3rYEvXLr93kiS6mPfZf1r0nMI4wrrR0J3F5PSf77i3N9F2vmiCqIV
 7L9OfbHO
 5rv8ftpeotKK6q2whGF2tFLE5omxKPEiyRlHtTKO6DxtTmhyREoRjwsx/vxcTHqnqSrylRv4cZUMurjI5MLWhaCJR6AWEID1BqvK9jyaRcrxtfHSSgaXenZsPzIE/ZwsGoTokuBy7bjuj5mQwDo2tMdVARD2fvGrieoGWwLuRPRb9FB9xZ2xQQg1fzhwMFjWRAVWROAh9SswS11bPItDksGIsdDNAzAU33pYzLgKviZDTTSy/FEU7y3z4XabnaM03Uz1/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 13:17:51 +0800 Leon Hwang <leon.hwang@linux.dev> wrote:

> Fix these two typos:
> 
> 1. approporiately -> appropriately
> 2. presure -> pressure
> 
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

