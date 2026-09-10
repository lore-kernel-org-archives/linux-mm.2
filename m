Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39491C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FF26B008A; Thu, 10 Sep 2026 05:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4179B6B0095; Thu, 10 Sep 2026 05:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3064F6B0096; Thu, 10 Sep 2026 05:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 112176B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:18:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6BD21C23D0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:18:54 +0000 (UTC)
X-FDA: 85197302988.22.197E2BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0A87640007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:18:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJJy2Sn6;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789031933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By4Fo104NqAk6U5B5IXs8V/eedehOHTPHBmWMz+lc8c=;
	b=sAZQSlzV3p5URtqSk5CglDJaKijWOurbEwz2f7hF2CyIfo0JVSx1kyBgn32Ao/hr9z+Ywu
	NFsyt7k85RW2yOsVrmOFDwdR96UbiGlgabTH0J8SYIkpUuksNuaN6ZU8ii6apakGvLFlKB
	VqTpaDv3sIetKNzfRLtLsRSvb+G232A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789031933;
	b=0qK+XeUswvtbgZCbg6E1jco1KLM7TRvfuylGwBEX1Tk1gT+8W5vC2vNrcQjeuwpreQy107
	0wFRRCTEJdzT3cEES7dt6My17PsvLi5+/itqppqQ6zRNc4FL5zcy5qWCJvKE2chyUaQRTl
	fFqeb1cPqz5tJZfn71sKjmdKMO95jYo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mJJy2Sn6;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23DA2418E7;
	Thu, 10 Sep 2026 09:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6031F000FF;
	Thu, 10 Sep 2026 09:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789031932;
	bh=By4Fo104NqAk6U5B5IXs8V/eedehOHTPHBmWMz+lc8c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mJJy2Sn6+IvRvRzhlXejWzBm8kAbAgnDCT86Q1Nt8mxplIZTo4xCBhQW7ac0t3SxY
	 Ky1xNFFZVCpRJ4bk9JzrRdjnVP9Z9BoYha/WHY8QdS5UZq1fdEDhNg9L9XUdmfdAa0
	 zMLIxCJXGlGjYlJ+Llo84pT729AeSDnK0CJ6R7UkYO8qf5x1LZR+LCmo+mP2hQwvcT
	 VXhzbtm/l1CCE3NkNFIYiMOks2ovwGcP6bdk1I09Hyl1R3PnRVtH/hv+hYgZj5u8oG
	 R/ssRrPtCw1rKfWAtLTcjtOiazhEj73xo/gRkW+G+EBEIDdqC7yWXYy0cpRgr0JU3R
	 PJCGb1pTXkAQQ==
Message-ID: <e8a9c3b2-17d9-43d1-9910-842b9131bf19@kernel.org>
Date: Thu, 10 Sep 2026 11:18:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 6/6] selftests/mm: add a GUP selftest
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Mark Brown <broonie@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
 <20260904123631.198697-7-sarthak.sharma@arm.com>
 <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
 <5e0b9365-cbac-4f2d-b915-85edf3093508@arm.com>
 <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
 <07dab220-8497-4eea-a4d2-b27a6e01eaf8@sirena.org.uk>
 <9695fac7-bf13-4e34-9cd7-4326ec21fcef@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9695fac7-bf13-4e34-9cd7-4326ec21fcef@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: u5ocg3qq5iq6bfqtjd8pt47zprt6wqpz
X-Rspamd-Queue-Id: 0A87640007
X-HE-Tag: 1789031932-331266
X-HE-Meta: U2FsdGVkX18ZHfNm6CBFcc7CAsbGReG9qOXUgYZ60BtfMvPoKTXm8RiUIQDEhojQfmylTQNayOO9e2viqU33wXeRUL6Q7+XJdzPShOeiGUAZPlcWI62M/rIeKtcgZvg8ugsNhbJ4YsoRnUg1JSudxS3DvNq2VJ8Cni/YHUsA1D2a+VKoYllHGt4m5uTdUYP4/ebVdOe4xoaALYy3vjTrT+GcgiL/U8m3lbwWE0JPv1Aab63YBpwxdDLX2GVxxoYbNFn4+97TQAfDRP6QiUDlhxz9KerKkPkg1LhDlHgkeZNZhMftdnAjVmWhfveWxaRRNypFkc3aQwPBTRJOBK1PrcZfUzSh95OPCRQdCx7IiqBVDmMfJnij8xeU5otQ1UsY1f6CV70YOVS3dztVp6lFwBSyTS2H+iw8GEsF4DWeUpHDRGsI4CAyKV9JQtnF8nhAqDdAACsPTKFVWI7e2kI319RhV4gsqqjY6Zq8HbxpFaxWQCtjrH+lJgkvrf5bNSs7Ff+VC/SE9Y873sRmIztqc8WPy/Jhtv0/BKaTxTjL6drMG5GaZchxkjxG1aw4aDt/GhUzywdzVYUBct18P2ZVopN/EDAYzmH4cLeB2h6XEwH5wOf9Y1F5txLbx6NjMmzV3J/lHgNjHN1XeD24Ji2w5dWwEoUfWnm+q5Pkn6x+XZDjEe92S5P7MwhmTp56Z6rIgaFAuIORTYfDoOoOy5eZE4iMETR5bl2+37ymVi86AMXp19O1jYdgOlfjS9kk9GL6AmBTQ9ZCp5oDQAnDmzgpVXF547ZphxGLHMzHbjixeIx32+/Lofmy4h41vjyUGgtBylgwdAmZ56qFUxr60wnstv4SbhSSZA1fyRjHgRAVZKwNKMJcBYULNYUpCXdzrUBN/x7CGc7EVvaxaSlIEsVMfMigpxJwWd8RKoFfEdo/DSeY091lhGfHINuFT1PMBqehSGR1Il/mZJAPiRplPMn
 kgx9VtW2
 /HQ4urhkDJC2vWEQDb68iw0t2W4XlItP2r9VRNg0pkG2NwBKDTzqR29YuxswCvOO7IfWy+dXfiXr9ABJAm+xZkljnwukCZhUzoVwqb+m1YLOVh46j6Wf2Whzvvq6g6BEv2JQQpTGOaJNKVd7vTJX7P9iWksSJw/QmNNx1iOeLRH+FrVFEWVwGtfTW8QI+h0NCvP9eoV6khb4FfmOLNdoUJpSVEr4i7kyDM3vTbpwOgTPrBC+f7XEiVNhcLBglFI/byLQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 09:53, Muhammad Usama Anjum wrote:
> On 09/09/2026 6:34 pm, Mark Brown wrote:
>> On Wed, Sep 09, 2026 at 07:03:59PM +0200, David Hildenbrand (Arm) wrote:
>>
>>
>> ...
>>
>>
>>> Yes, we should in general try moving all test modules out of the core.
>>
>> If you're working on this please make sure to take a look at how the
>> various automated testing systems cope with modules built under
>> selftests (personally I think everything I care about uses tuxmake
>> builds, but there's other stuff out there).  I think the answer for a
>> bunch of them right now is badly, but I didn't actually go check.
> 
> There is huge discussion in the past on converting test modules into
> kunit modules [1]. Selftests is not a correct place to keep kernel modules.

I don't care where we move them, but mm/ and lib/ is *certainly not* the right
place for MM specific test modules.

Anyhow, I think converting stuff to kunit makes sense. I am not sure if that is
really applicable to e.g., gup_tests though.

-- 
Cheers,

David

