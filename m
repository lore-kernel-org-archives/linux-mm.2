Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123B3C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059AD6B00AA; Tue, 25 Aug 2026 07:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B0F6B00AB; Tue, 25 Aug 2026 07:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDFE6B00AC; Tue, 25 Aug 2026 07:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEDD16B00AA
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:12:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36A96A3701
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:12:59 +0000 (UTC)
X-FDA: 85139529678.09.3F72F18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F98DA0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:12:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxJZvv1H;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787656377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XALoSUgAzEfoqMKtNdIg7nrqtNrcRJdiHQ+rbwEDbr0=;
	b=eiuC2QoBv95CGs3BsSUp1ISh2GB+/cwDEUPWhoZZEBnGxTkvH1MoxC07sBPV+NypHjYyPn
	oklwxtii5Umde6k2J9tIEfF6uStq87uwgaYmpSUGGmc8+YIPdB07D2OxgW2sbdTa5ZG4oQ
	w3pheDeue1qoNpwvbf+UNebDbGHDPbY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxJZvv1H;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787656377;
	b=sLvg9OaP8N/UCX1IrcI+tQvj5+1A4ZgppyIH7atBN03K4MB1P6y/clRfww2yg6oKa1xZeC
	sI6xVdTnMkidy3wgmh20RrlD0q9exwS6GUvoGHvj6gE68Qemq5VFV7nlH46iqkGCVyqYdV
	SuyebqiaxKsaHF8DyY8+4NTL71A5osc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E100A601E9;
	Tue, 25 Aug 2026 11:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2111F1F000E9;
	Tue, 25 Aug 2026 11:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787656376;
	bh=XALoSUgAzEfoqMKtNdIg7nrqtNrcRJdiHQ+rbwEDbr0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UxJZvv1H46cgSqfKef0IYrRoRKPQsA98B3FPETAabyrn6I+hkYCNQr/RpeST9X/iP
	 CB56oTuqfZG0mLbeIAGJN3SqAv0jLhk0RVVKf99Tk+gErpFDuW+yp+OTdBnf/mtAhc
	 dC+Mtsq5rBEw7lmHDTEW/AwVf9vzfB2eHpDv3Q0AZatWDqreY9sfzAplnbzSoLeVCO
	 Xf+boLydcdESZwrDXYW1nCBEEY061dHvqe/eaL4qN/N14UvIePLtPL46StHlMJ69XB
	 llEvF5h0vSj4kQZjggx6IadMYrIsbtyABYGdR5HZc4ROljIpFDtb5e8GG5UgeZFoby
	 FOymU1gx7QuHQ==
Message-ID: <fbb3e23d-9579-49d5-bafd-d602fe160fd7@kernel.org>
Date: Tue, 25 Aug 2026 13:12:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] selftests/mm: add a GUP selftest
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-7-sarthak.sharma@arm.com>
 <787b5acb-978c-453a-be81-812269f47f40@kernel.org>
 <b97ab786-fc41-4ba3-a2df-16d32c6fe99a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b97ab786-fc41-4ba3-a2df-16d32c6fe99a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oom1goeziecnn1eom94wzdrxius7tkxf
X-Rspamd-Queue-Id: 6F98DA0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787656377-63072
X-HE-Meta: U2FsdGVkX18UrR3UpVGaFJ3cCHThzR1wrGCZ9nEeI7O2HLQwJp02qCTt1+dZt6XfpVEyTPLDIVzwxuZXkaFwfffZN1REh3iFtgA73wveoQ3u2KULQWcgfrnJR0UvMc+sVqp2LbebiFadMulbSmno9oBZnbUlfLzJxelzAy0Rn0KcS3tkEwLMVSjMgSedSirU+C0coXa67ptiOV90mnb/VE80V01o1lHFj0h2qjM32N9W8WSva/VvQrJSBf6OzQNKyqLl3cvUig7vxSqIbrPes9A/7mXVtgnU1d9YK5e2WfBNiYRSVTm/iU2Fjjd/dyV9aXQ+3dYnLCjdeoKFGyhd5WKW2ffRbnYxgcAVwhMBVP8DMVvH5nxcw47CBvnAwNq4SqjzD7OODDcDJyy4LZPRP4tVFJ9g53MAu4pgUSdcysqqaX2QEFan5WKaIDm9s6F2e82sFOdUoSY986btA6dGOBl3gChhpfQrZBVv08K7WS490QtnM+M0EYpvAmYRRYjaDMjtsGNBNIG/khNwBSEIowPzszm2wQCui80w+51ofqL0rKY2fSfk4rSVlJqaAnuEH17xSO18sXYEZoLS+pQDsuo7Ngcw/LZMTSWk/tM2WqQjdxR7anTW9skRmQJSYB2G3fF3eGVTFmIVfzIgGutTHdKDdoxKKTmur4qIxs5GNoMPYUGaD6n4umTo8UZfil55iVl/c4m2I0FXCBMXEsJe3efRiGfgcF3EvEvzg/DQn4JhqLMpfvzB2uBq5sTGOp3ZmVOwJ/XQdW0CcItBSNl2X3vIpZUG695CHB/uq7xThdXxCysBsggZb6lWrsWbfgn2/2Bbuu+RaS5QXdhk8geaDxvqCIOSWiv2XM7Vacv0ZoSDuar+Jtd28T755tRq3ZA1IyqoRah08bAfdSjeUO4xvGoD2xpQoYQR0qowJAJ20fp6IfTwHcuvqD3RbAcGL6VeBkqIWRZYal90KFCmcy2
 d0kxzXo/
 PcdAnMomuZ6hZTPL+cISRiq2kmfxxEtWDheITU6tdFc3R5+pfjf05pyuqzWFfF5lrfoFlbGGonksfhGgHiJh3Gq6uATFhrek/jMowJuHMMK00INM/nmdoVbIo/yLK+rSVltZZCIWt6zDESVK7WSNbDzCH3MqWjYeblKsIdp7V/y6OutAMC5E1AvSogC7jcxxVEOB+bP7URvQ8/NfW10VMSjLbI5Cl8P+nCARzusV3Ld3zHG/K0pp46N2iY6K7i+yeyc4C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> Maybe we'd want a dedicated dump_page test tool in tools/mm that would make use
>> of DUMP_USER_PAGES_TEST. But maybe we also want to remove DUMP_USER_PAGES_TEST
>> entirely and have a different way to trigger+test this.
>>
>> Ideally we'd have a proper automated dump_page test that actually checks
>> expected output (somehow).
> 
> I think we can take this up separate from this series since it would
> extend the scope of the series significantly. Does it work or do you
> want me to incorporate it in the same series?

No, not at all :)

-- 
Cheers,

David

