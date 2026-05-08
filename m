Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E7DCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 07:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71D86B010D; Fri,  8 May 2026 03:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C490D6B010E; Fri,  8 May 2026 03:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F436B010F; Fri,  8 May 2026 03:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4EB76B010D
	for <linux-mm@kvack.org>; Fri,  8 May 2026 03:01:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4971B1A0761
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:01:57 +0000 (UTC)
X-FDA: 84743357874.25.8C575A4
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4904F100002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 07:01:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iha2P92R;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778223715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NjihaeD76Jsi8Lwgt5xatfktO5NhR9x51duFuCUS48I=;
	b=vEIOpYun1rTXkhGvhdmqdvIzWAuifKE8fS5Daz9JyC+WEDUxFZXAqr7vlmP7LPTg8meydC
	71VQzYc2vYeY+QngbKLXLmB+RPIyence0isa29hIEwDzv4hhol3T62N5oh2nq2ps4XFvuo
	VNuMiup50PIyxz/QTOT1mrR7zuTh/48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778223715; a=rsa-sha256;
	cv=none;
	b=rywzl1Xm6dx3CX0I90tVRblq5eG56RxuU+ybdgbm97S9IZGv4vDm2R2kW537VvK6iZMwp1
	5QbivMMTM+5Z2Ri7PeeLR6YYyFeZH44yfcEqMIc3PQ7lZNmPrU8isDU1ifEjTMPZOrbnFZ
	1zUefd3edkXCG369/aK89ENDx+o+rQM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iha2P92R;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778223712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NjihaeD76Jsi8Lwgt5xatfktO5NhR9x51duFuCUS48I=;
	b=iha2P92RrzX66oAtKsbukb/2Sw0Jn2it2q2sfp/ztwpYbr2+hf03kOW505Mxcb1lEHH1Sa
	H1TGMGI6zu6hxwo9RaHB1CDDQ/KHNSUQH0b270vEUH3aUWr6DvDhuP75QME4ASoJjvxk6b
	dgjJoO36+YMmfKBxkU3JaBgkcX19mnE=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 09/14] mm/truncate: use folio_split() in truncate_inode_partial_folio()
Date: Fri,  8 May 2026 15:01:27 +0800
Message-Id: <20260508070127.18666-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-5-ziy@nvidia.com>
References: <20260429153538.727855-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4904F100002
X-Stat-Signature: fbci5mecaa75so46h9cy456c8xqqbipm
X-Rspam-User: 
X-HE-Tag: 1778223715-398365
X-HE-Meta: U2FsdGVkX18P150aa/ISiwEKGQj0eRWrsO3mKnYNmw6VhlHDfYmBQSzQovY6qce8BALdjd404/IMtjRZoboqZEQVvunqWC+r8+Bfpf4mFaEOK+X2bAd5JhXCjthuqSy0uW+WD6TNLbbXAdl+gZ3IkqJxhwbI3R6jS2DonLzYX9fODPVh3FH4BiKo8ABNczaudJeuZ1RHk+HMb0P/dCb+WX/EkKreVxgFdcVx7uDg+s/IKebQdMl/u7lIk8/EQ0oqFd9uEtuS27IH+MMpbo9xel5C1/9QHhLxawgTdV+nNBjL9vlGvYa/oNK/w7mOvtRZrTkbsQXuUy3LRJPU9xOOrovaeZSVPU/NDn2SIxEFQR72JFPZvE0nT+XW3cWR+cYJqJlB1G7Xs7kkjBD15y+AK6PMUMekV4uQsbgFr3uk3mgjiVY4BXaYj/Evi2BxAQlslDEkNROGPfuBlfEbbvb9vG8N+rm2K9KXZosdG/3KzyGPqPEzggkU6M344K/nVXb9tv6nCD2nrmUMOm0EnG6NYRfXTx+2QL6J/pmG/lXTK0KlX1EznyThiyWfqzBsctvnIkg9ggcCzlp+RZfhmqdpdftmJTuFcRCIbdoySCjZVA6riYsnvHxK4QLTQc9g/s2O5yviSlyIdVIAKGRoz52eSCTgZSe6PDy3f3MVdFiiWEpkPitnMoSoxEbrVTf/OCPpNvvLtw2I8W+tidXAMyrfYtBdJA6UAJBWPcSG5FF9KCLrprIPLnFvclz8ebA26DzLpUPQa6nLOLjJ1yr25Jkh4X3tkzkoxjs2HYwr0S4Wm7wwICTFEiY4Wyke5Bzuw3UqPWMX5PQH7hfaUPSzhUAhNuQctr3rTh8cEUG8inDedUy73tb44eIvLUIHsVZpE5JtGxeqkzS6VDfT+DUUuYMy/ei/5O+d/0bqQOnL/InwMreF1JewsAhdaC/zrBcV8315b92Iedq7oduFjbTTOfF
 2vziiDfz
 cKo/cMS5klU4nrgYZ280uidHyj0vgmv+2+i1rQroq0PIQZeG0M3QlkSOTu31ce5HPB4psNSdTTjuqDpOmTbeE4Af6MM2zHreJccoENe1JqtbswpAomsYLTeawjwt3QvU2rMLuccjOhCzqcT46ByObP9L012U8KYBN4Q/huGs2Cik45PdM0H8OQTJZ8fERQqzMg8NkLs8rPQ7XTOUYtV7qUGtxs4rQXxAtJ/jTGP8U5v/sPI3Fftsjgbwotj5HFBY/2MWlwcdEXZvCf2JxecMBwEtIBYsHXcglK+KQl7CC2OKG3OrZvHB0a7dQFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:35:32AM -0400, Zi Yan wrote:
>After READ_ONLY_THP_FOR_FS is removed, FS either supports large folio or
>not. folio_split() can be used on a FS with large folio support without
>worrying about getting a THP on a FS without large folio support.
>
>When READ_ONLY_THP_FOR_FS was present, a PMD large pagecache folio can
>appear in a FS without large folio support after khugepaged or
>madvise(MADV_COLLAPSE) creates it. During truncate_inode_partial_folio(),
>such a PMD large pagecache folio is split and if the FS does not support
>large folio, it needs to be split to order-0 ones and could not be split
>non uniformly to ones with various orders. try_folio_split_to_order() was
>added to handle this situation by checking folio_check_splittable(...,
>SPLIT_TYPE_NON_UNIFORM) to detect if the large folio is created due to
>READ_ONLY_THP_FOR_FS and the FS does not support large folio. Now
>READ_ONLY_THP_FOR_FS is removed, all large pagecache folios are created
>with FSes supporting large folio, this function is no longer needed and all
>large pagecache folios can be split non uniformly.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---

With that gone, large page-cache folios should only exsit on mappings
that support large folios, so folio_split() with
mapping_min_folio_order() is enough :)

LGTM, feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

