Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CFACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 12:58:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C4B6B0005; Wed, 20 May 2026 08:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D966B0088; Wed, 20 May 2026 08:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042F96B008C; Wed, 20 May 2026 08:58:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E65BA6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:58:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A774D14019C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:58:28 +0000 (UTC)
X-FDA: 84787801896.17.983DF94
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D94D6180006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 12:58:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NffAtSug;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779281906; a=rsa-sha256;
	cv=none;
	b=bZNVodIisGsWOzhMA6k0jsttJ/nna/RslkgFVwHT75z9MwZ1JX40x8+NiYlPDUM561kixE
	6MGZbLcWNxRGm+NciqXobbCZhHWsGUPT7upSFY0Gn/JPjGCLfgAA8N4m1d4/F79fx+MbTn
	VT2l+t8cUjq3LLDlm6GXsf7GOvleoHI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NffAtSug;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779281906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkW4pvVABxc/wOKESG2c5A2yb2O6fz7b3zhSvVthsmc=;
	b=60J8RZ44iBm56qPMt1PL4zn2dvEsdavMDdp7vEdcnjygFKjYsaneggYi3ModD1rn3S8JiO
	nXlyfxyQhhdfLxhkxNQpMVqvnjIl2aapd4s4RiNKVgx01LbmfcgcE3ePHQ8HzAZ2FnegW7
	a7ahLlRX1L6Qg3RLuyIc0JDZwiNQTRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4028460145;
	Wed, 20 May 2026 12:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139A21F000E9;
	Wed, 20 May 2026 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779281906;
	bh=YkW4pvVABxc/wOKESG2c5A2yb2O6fz7b3zhSvVthsmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NffAtSugrfa5NSP2dageADCVoO5P1/NvBAAZ9M2cPo9QytiaLhUEQXbbGnZAnCUey
	 KTk34rOn15zkN1A+UOc0jl9v+F8MNc1ugv4dB8L/z6XLaNESDh/RhBIjmGdcsGdC42
	 9Q+mAkSftX4CaNHxvoEbVMlydPqd1Ie4kmZQ1FVv9OruJCBnWsPpTmBq3fZbHu/94i
	 FC4TIlM4zD7Ee/3lQqOYuBlVDPBCryukvT9maixB6hK651FxrV4wx1Btp1YKZJ20Q1
	 MjYSRRhDw3VDjQQKPJUR6h94cn7h5r2tJlWCqktLkqh7iw3+ky8DPENNaoVvMeO3xU
	 8Wy0zd2DFyNLg==
Date: Wed, 20 May 2026 15:58:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
Message-ID: <ag2v6KW8E94kl4M_@kernel.org>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
 <ag13GbKcLMIoHOHj@kernel.org>
 <9382431f-3746-4477-bbef-87abb58bf180@arm.com>
 <67e9ecff-e532-4659-b4de-7019474af608@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67e9ecff-e532-4659-b4de-7019474af608@sirena.org.uk>
X-Stat-Signature: kbkp7qsydx7xpcutij1rci1iacuksdm7
X-Rspam-User: 
X-Rspamd-Queue-Id: D94D6180006
X-Rspamd-Server: rspam07
X-HE-Tag: 1779281906-551602
X-HE-Meta: U2FsdGVkX19U6SvRI00eKoPNwyPzghSRybhSC20X4DvU8+a//oHgj3BeC3O5ngpkYRia+bNBclOLO8h9F3TdJLx6wAwjzwvnIWi1CCcyakitZR64dd/mkMIEcm4E0PollJBqJWKmEo4kj8J0wtYWpZ4yAKFWMNNht7MhnZz8OVHf5AxQFiuCsfzI+jYkaAW89UZGqwt+QjcWiAuh2ADzeHi/0JtNHhAvRfOc5QKUTBNOL8ZS5hEsTAR6R8zIdUdu71Us+PJiIq/QAWdBgo8hLobWe3kOipE23kixiLd/B2GNlgnl3TVqP9RiNWhKtYG5pIgw3lRETRTULv6oWPheEyPcKBJlsxsxlvuyWeHm8OvH/YFZ2JMgNueLwR/8b3T3qyzpgpfO62nEcr3zv3qSjhDUCEA3RDAHokFhCHoWBi3mf64v4Y2A7xD2+e6lXatSeKeZeHh0K426CMjwtRRNWVgSZqXfx+9XhCYP8KOTuWABTMW9kMzSTfNP9zsGJw9u3jrMMywFxAeNfYcg/t5JHRC6/Xj6QfScfI7hhsYHAfcjv8udjivrtX6J0xiv/Vd9m/co2Pf/8OdnQh8LQWS5u9/qv+AZpDztTURv8LojvR51NyZIXUQZEkGyAnylYBqiJBBZCWQi/DlzMhkice7oDcPq92+QhkWlu3tuDfxCc6S1eNIRKpSLK0yQ2jtY/I+H5I2sWfZVj3vCEcECP5i7KTwqyvjECvHmmYpfXYc6CHmSqim9oHqGYZBwkKu+1R2TFaKarDJo65VcCQng3btLW/5N7SihhMOXjpGcI8zW9LL7WLjDh6zFGgJSzfbZluYH+Tga8noc0tvSrQJXL6cH/ZRvsLTVJjSHZLvd6xt3F+juJgXMqXEX6Z2sCCNqBAVgGzToyOveLPB0goby2KcBBGw2UyY/VLnijApLoMrMc3+Bq9uyEFsJ7ZFxkfLDh9tUDaaAfvEIthrU8QgWtM1
 fSAHwL09
 h+ZBMCX2lKW3N8DmUotxudSVPjvJtNcfNVcHd5Nx9DmdaLrWpflxFvYONPPYvmUbEhbRMeTbvjQOa4ADwMFVkAmBKX4r4c8fIlrwhu/zjIA7VPb/znXl4ynlNe1uY2lget3/ZOa+I2nhvtF4WRv0ujbI3tfmb29+FiAEEhUB2b/KBo8j0FROUdzJyW2WR07uZiobugYm8pX3YNNdUovESVa788Bwq4bLhFzKEZyf0jhh7ZyPQ5m9Hz7D+9dXrJWyarL+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 12:58:32PM +0100, Mark Brown wrote:
> On Wed, May 20, 2026 at 03:45:53PM +0530, Sarthak Sharma wrote:
> > On 5/20/26 2:25 PM, Mike Rapoport wrote:
> 
> > > It seems that we need to better share the common code in
> > > tools/testing/selftest.
> 
> > > And adding another copy of the hugetlb detection and setup code does not
> > > seem like a great idea.
> 
> > Agreed, but that was the least disruptive approach I could think of.
> 
> > I am thinking of doing this now: should I move the
> > hugepage_settings.[ch] to tools/lib/ and move the read_num(),
> > write_num(), read_file() and write_file() helpers to a separate file in

these might need some adjustments because they use ksft_(), but in general
it makes sense to me.

> > tools/lib/ itself without any ksft dependency? Then both
> > tools/testing/selftests/* and tools/mm/ could share the same code.
>
> Using tools/lib sounds sensible to me - as well as the sharing it makes
> it clear that it's a library used by multiple things so avoids the
> issues we sometimes have with selftest directories referencing each
> other.

I'd make it tools/lib/mm as most of the files tools/lib/*.c are stubs for
the kernel functions.

-- 
Sincerely yours,
Mike.

