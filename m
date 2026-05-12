Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D94CCD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCB36B0088; Tue, 12 May 2026 02:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3BC6B008A; Tue, 12 May 2026 02:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA536B008C; Tue, 12 May 2026 02:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4806B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:04:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CB311603A9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:04:41 +0000 (UTC)
X-FDA: 84757728762.13.8D46CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 924B1C0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:04:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjthJASb;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778565879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IX35Jdqi3MH4eVQ5wI3tl4YgdW5pcXe+G4fe7LaGhWg=;
	b=CUuJJDnTbCLgyGm5mF02GadU97W0amdcxV3QR+BudY83K6C9sjTmaCr2wm2LP6fw3ayCGk
	diIhagEmMVTQsoz3QliowFSJYDOSpanFbnNErbRh9jpInzlK9PG4dCGwqi9TNDE3Vk3oa4
	a+zyJeqXbGW/CPGBowPGkVCmhSXTTzg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pjthJASb;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778565879; a=rsa-sha256;
	cv=none;
	b=1ec0e0y3I5BWe34qgMUzP9/o1wzI9ewWbT9ZB3ajv7QggS/XifTaSJTJEBgnj/IFO8x641
	SHsI26L7f501a0RGT061kpgl3yaQxd2bHeLtbXD+HV4ebvVKDfaw+2aLHZcPTzuFvNw3Ju
	uE+syk1+29d2f5enw0jolDIT8MXuYOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E97876001A;
	Tue, 12 May 2026 06:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36073C2BCB0;
	Tue, 12 May 2026 06:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778565878;
	bh=uHA/cyJUHSNZZYyU30IGH1X/xBpIaM8OJUOjXquWRsQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pjthJASbNNiSMw+beLARDGDk5he6NgmRzyyDIjE4ZEB0J+/7Pr2UV9tPoErHCqBCe
	 cp1w84ZHst1QwKMM7gGrZxZpWRVy0e1atUL8ceJi2d5gPVFxmnTcwqyRGWNjB7FjuU
	 gNeLlOmQMCIX82hfUQG4agOtUFGY2pn2IsBp02r6yfBWooo4mtK69vLrZo7pQzmvVy
	 Ua4mZ7RUI/J5G1VCkUtP+pjsC3xPtHbvHOyZGPHZ0giuG/05AoYeAT2gnK5WXqyaxn
	 jEeaHaPYynmEY4HzLouC9kgkA33b3Y0nGyymq64lYcvfPqWM0zzVtw/p0uRASQ33B1
	 sTzamrFDZXNGw==
Message-ID: <232399c3-b88c-4d79-8527-9c4d26e97ef0@kernel.org>
Date: Tue, 12 May 2026 08:04:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm/memory: Batch set uffd-wp markers during
 zapping
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-5-dev.jain@arm.com>
 <4b36ddb9-c11a-4320-85d4-3e059e67384f@kernel.org>
 <45ad2925-9d01-427a-9ac0-650c4b2d07e4@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <45ad2925-9d01-427a-9ac0-650c4b2d07e4@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 924B1C0003
X-Stat-Signature: dy61kosdgkdrmd35q9hs71md7sdhymfo
X-HE-Tag: 1778565879-724652
X-HE-Meta: U2FsdGVkX1+S1IFmAwRLxD7ucysz2XL+KLV1n0fBeLaELZFxNR7lCJbiqLxdHcfHRC3XLscjJFxqEPQvr62NN4nH09FmpCl5Ac8i3GSpxjXXX1qGV+DtX+8EyvrpkXtLtrQ03gYJ5WH91hr2Rek3h9Hig1pzTtBf5g1DKr4LmGIT9pD0Q33zOCgNkUgrYRBRS5GJiPRh7yyEEb9BSslak/IE9Ei9GiTHi5JrlYfiObhkX/P67sB83fvl4TqehxzicUMzCQ80f/0/uPN2RJyEelgQuu2zzYlWFQL7wnrOeMLkKj/Q7CmlB+/TtF2V1VvTnHX0bDGAkSmzw0ZAOKPYyRXXCXcyK+vav7ONOksnHSjWCbXxGlBjdzKlICxIzrUnMgOjeMdO4DuMl5C5/SWz/AePm8HPlhSYtJrLk00l//RR0pCYVuYWlU4U9L/Fo7QCmL23qzwgHQm6TtqAFM8zhfWockos8+EQWT8j3vMOTlp6DbVWxaSR+eMcaXD+tzo7+HhavKx6VovfDGroDoGlJJ6KKWyPBqFT4vZN7LZAzduyj120KZY5gNE/jliX98EqcvQulMlsmjGCZpMDB8TyOlMozjYmoeJ3aSf339cJEJ8HN6bLTG3Tn2OQhy/Y7pFWTVn3gaJ3ztHxU5Qm75jKNwsnxGqL+4+blWRZ6K5ks7JZL2OkSK4cM40O4hkrhNUusJrSoZlJZAkn8TfSBnwXadRn/Klh06m5tEhcI2KDRVr6tYCmfkSJaJEvslF+mPYKml1GKuX5TEVP4MplKixhIe8Th7qNyIMk+Yy98RinhEOiMmGi16n+tRN4tQCFnd7d891CS66fScHKNYSqVCGuAHYXS7FjHzhYdCaLUdwe/j+SWUEI0a4hszXIPNerzqScSup9NGHh2y8ID5M3gBUwlzUEsUWDlem5EkXS/hNpNAOi+EVlplwT5ddkJKVKftNK6NnyxUzQyTg6U/WHevg
 8rjsvc/3
 HqksO0uILX/EGbqtrr+ooEFGofISP3NXHnwC8QO3OKN4WajHQof5Jkm0q9D65Zy04/umVD2n1vigZOGeM87KyOBFbLebsfr4l6eGwNs8qMBzRV4xzeC7gSs94S7j4jnI2Z/FzhzmultFB6epIeicQsQI2XfDUvgwTrDdyHc/jkY35eGCs5+TbHt7DhP3JnsE79aKIrsnz6XNmKakGMNvrpoD1Jd+EM5i816MRPyRZK1V/xD7P8c7LzDDKsn7SWqx/jfFL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> If we conditionally do something, what about while at it shorten it to:
>>
>> 	cont_install_uffd_wp_ptes()
> 
> Why "cont_"? Did you mean to say "cond" ("conditionally").

Yes, like cond_resched().

> 
>>
>> Also, less churn in this patch if you don't change pte->ptep
>>
>> (because if you do, you should then also do pteval->pte :) )
>>
>> So I'd just leave that as is in this patch.
> 
> So I'll change pte->ptep and pteval->pte because I hate pte pointers
> called pte : )

Yeah, me too, but it's all over the place happening ... :)

-- 
Cheers,

David

