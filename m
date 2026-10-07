Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A3ACCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:03:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D966B0088; Wed,  7 Oct 2026 06:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147A36B008C; Wed,  7 Oct 2026 06:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035D96B0092; Wed,  7 Oct 2026 06:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2D6D6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:03:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69FEBA017A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:03:35 +0000 (UTC)
X-FDA: 85295393190.29.6E9BB7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8E19AC0009
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:03:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD4DUuKp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791367413;
	b=RXlY5ZnNYFsP2pLzEdUEqXax9EZOC8oF6K+ZRCmVrITyM9J7CWRQLy0yiWJEuGW0DU1pme
	DzBCSWaDURrZOL11boQATYISUotGhPtNV9rBUtVQ63hv+V9JTBYr2JCmiNAxa8UIrO5sMg
	5tjPyzQ9kJgXQEx/i7j+wPV2mnkxypw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD4DUuKp;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791367413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLIMshKXGQUE5mhCFk2wkoVfuzjryi/zbuwbzKQ67JI=;
	b=XWX6lQDX1i2WIO7PojIUHU9eid07fPjQDKwRxXlK1zPig2U/RC+saJyXOpmYTP+XdGcSot
	jGpMskeO+kP0YAyeE7ywu9FJj9JnJLtV/6pfBEkmyif+OLgias9PIfR4blJybVoz2Hqi+n
	ubbdUBIADJ9GbZ64tD866Xl+Rynpv7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533CD60218;
	Wed,  7 Oct 2026 10:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608461F0089B;
	Wed,  7 Oct 2026 10:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791367412;
	bh=OLIMshKXGQUE5mhCFk2wkoVfuzjryi/zbuwbzKQ67JI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YD4DUuKpOvcHEqgusbYqalLXVEyUTc3Hw6tRbKpGd+uNiQY9XgdXqAj2zcvKjUszD
	 I4dmbFqA2RFa13Vw8P9yZ9MejzkNV12at2Yk6g2gjCVmO1ZbT/jA1FIYO0dC1rcd57
	 S3Rc7xv2EPjEgMTZE02qhgbdAu/tftK8sC/Y/hQLNo9wQ2Aox5Hx5qUX2JPRJabSJ+
	 BMNjl7eYywp8Gq0bCab4sBCj/M/DP2sQFLn1dbHNZlmYvbetLGSY4yX+9o7MNYDsvO
	 CeX/fXu6TRQpyEhF84d1F1zaD1rn8K+Y6HPeVqrI2tfEoh0Id/3S+yBifo3NaM5Pra
	 qgLk/MJeHIK5g==
Message-ID: <392ab85e-5a24-4d84-857c-bf7785f52490@kernel.org>
Date: Wed, 7 Oct 2026 12:03:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] selftests/mm: add tests for UFFDIO_MOVE of a
 uffd-protected swap entry
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: peterx@redhat.com, surenb@google.com, aarcange@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
 shuah@kernel.org, kas@kernel.org
References: <20261003103030.63380-3-donggeunyoo.kernel@gmail.com>
 <4a24f7b1-65f7-4947-a325-7c9e9f642f2a@kernel.org>
 <20261005115051.3950585-1-donggeunyoo.kernel@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261005115051.3950585-1-donggeunyoo.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sqjixgq49mukjo7gsgk8zpma7muuq97d
X-Rspamd-Queue-Id: 8E19AC0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791367413-724696
X-HE-Meta: U2FsdGVkX18uS78FFCoBmWbEzMjJ3FOyViLDa6wi02zor+QaxSQZpIDJjBOC+xQ6PJ3HX8jaiufzqtL6yGmmG4rb3vYDLafhmwcEmNi6GG5Q80xzv65UrrAAryUOYlNN1VhsiHBwLiYbZL3EPtdeYXdJhQA49Mv6AlROR53zuTkTXaVSiFm9BvsgoflKMY+srcRnxtBjxf738WGSkM3P0cnOEP27vA51N67iRoLD+XbSGN1I3O8CfsPY5oNcyIJG6uvQVBiwwRQxCLpwtmoqAHVTbRgrZxm4LleQlvpPxodDTiQrmYvY9g4QO/Lh6tyFPYDFpiWpnumDFB7QMY0RrH8kPGvHeka619brEQubgHOaA3IeiBXS17mo/NpTcaNrAedk2nWTuS0DgRiuNIOPp4LvcCSRYNmgKDKr2Zpf/Xtd7qlptqxtUVgnLqE6pjQ+VviGDniUTiqzklu2fzUFt4isc/0t0VCWHt/aO7uX8/TzxR5OyQgJmkidDluiA15Vvi5Qr7MH6r6a510Uc74tG40+K+bdb158w3ZDGtZPcSCshEenBBDs9nj7vKMyAPxSUWpLoHw8kml3o+Gf6CqjxU/4L1Qni6FPH88kBrW1D/37sJHYgLM0GFvv/vc9dNQaErtaE00wlxfWD5iaW0lA7+ewDotMubqb0J7lJV1RUHhCqIZQzHLu1F5rjt2IT2SuotfUQbufuLXJU9Vw/qyOmXB6M1ZUKLvFaueHKm42pSj783G2BS61n0L7zbqO3zH16ZYJe1URmNAkA84FvDF7RNHCxmVlHMNa1luqZfik/455ywJcdDk6nEVDdU9YBMU36pHf+ac7rfSArMMZa20gebVr0eJDrOR70ZJzniIeloqv2qAXLuiC88NTKosvQ/9hue5wHlXYs4hJ0PQHBtKXsA/XGOyOxWJ3Apvygb9RDdAnQz4MH5OjY54uj654zeTq9aHFUdMWlgRlqOz5dSm
 kfns7v7Z
 3BTIKWSOkoV+z/6ZiCAMavJThguIzTEXxO5G4jIRC7TNlFdnvLYvAnSYoc86xPAUtT4kY2lfedqMgNt8sBaPJEnB4XqKvuTaEJvxuqaKhk9Fq2OqOgefCViTCrhHKBIy/pEdl+Ln8l/9/vfpevpKeLOo+9Gzmm4sjZU+b4rGpCTsv5X84+kbhjeh9uFYE6elnunbJ1QacS4AIKlAreJADZjKqxVqwkWlk1mKUgqg04+syvpp65ixXDGbV/5MPSSD7CP5SHT5VKJl2ZvZYeLKAHkwc0AXcHJO5N1qw7Vh+HZbs40MYHMEhrLgqHKx+wa9MxntFAIV1CQeXtwJQszDxetaPLuZcoUexesiMmwXr1xRBFamrmZa4vcjoFutlzXnc+jwDuEbpWWiM/8Ny5fLNAGEqNUrjDOr82EZqXZA0N+S6OtCmzEtjoL2tNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/5/26 13:50, Donggeun Yoo wrote:
> On Mon, 5 Oct 2026 12:43:48 +0200, David Hildenbrand (Arm) wrote:
>> The CI complains as reply to this patch:
>> ...
>> ✗ userfaultfd(2) test failed:
>> # not ok 43 minor-collapse on shmem
> 
> Thanks for passing it on. I couldn't reproduce it here. Could you share
> the full log of the failing run, or a link to it?

I messed up, it was for another series :(

Sorry! All looking good from the CI POV :)

-- 
Cheers,

David

