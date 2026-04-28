Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA6FFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22366B008C; Tue, 28 Apr 2026 06:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84946B0092; Tue, 28 Apr 2026 06:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73636B0093; Tue, 28 Apr 2026 06:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9691D6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:06:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CFE7C1E05
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:22 +0000 (UTC)
X-FDA: 84707534604.24.F9B05C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7C047A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:06:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PmqFbsFU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T5w8IDtt6TMfW86Gab3OC+0Kyg9LhD0GNPwtsPkpIT0=;
	b=0YhXDvipA2M25lr+3sFuQpk+t3LLvq/82TLHW5Z/A3QQk7sOTabN9tolwPfPok7Mod2OSi
	u+zvYM+3PjgTtCI6H1BobsgjaByxcZwh1cqHr4l5fEEhRbPaDPSC1kRLlCzKVthsJhRyO+
	FWklcq651teML5C1/f5fWUYJDo1sUqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370780; a=rsa-sha256;
	cv=none;
	b=WRrO4pox+CGSGLzsqJLvM9Vxa52vqb1FVcwaGi/i4No+3qdDmCP9UIhq+NPtpiGfYIVPz6
	/jmkOcSX6SoI6iS8FlmDrH/DO0ue31bvC2fCdMkenm9FkMB5DgijNkzWrP7hdUYUUtdMEj
	f9J1sXVLkUF594tENkYglSCH8f0DIWk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PmqFbsFU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5516434A7;
	Tue, 28 Apr 2026 10:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE47BC2BCAF;
	Tue, 28 Apr 2026 10:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777370779;
	bh=AWfjFy1xojRQSJaJulb4Pm2bC+OIK+obMAqlpq0c018=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PmqFbsFUTG/9rSVRaADA2eVRe0zrojnWiuS374tRO6aCxI/ZVdQLX8e1K4i/nLlqN
	 lIr6CMk1lESf0eWaX/A081nMU48DMCkU88urF9KIsBgowmy7H18VGxqIVfJsBXN6pn
	 H28DoxSdOnPYxlU25pS0exa50Iph12eSYIJlEjUhTBijblJ2y4ZXFockuXxtRIe0Ag
	 qTd/vWY+GZ/XvYlcvUreNQKnj7hp8muwIJRIEwIy3k03JqjI1wDW/ft3SzxkbBgmHo
	 R4jLl9AG6Q1fNpjkfjYQ8m/d+Zo6P38xoFm2psivujM/hFsHbTNXSXkSBXJyfsiPGf
	 3M4Ix9DDhC7DA==
Message-ID: <7f729e75-dd66-49ea-ab5f-408fdc1a5c81@kernel.org>
Date: Tue, 28 Apr 2026 12:06:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
 <20260428094356.60415-1-agarwal.vineet2006@gmail.com>
 <548dc617-ca19-45f6-852f-adebcf8d3a11@kernel.org>
 <CA+rjy8dFQiqwiGT3Aa-=-ZaHDzeT_87ohEb7ti=Z-DxX2FvTPw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CA+rjy8dFQiqwiGT3Aa-=-ZaHDzeT_87ohEb7ti=Z-DxX2FvTPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C047A000C
X-Stat-Signature: kcpf5yzfpprpeujauohow9tuqo4f4gx3
X-Rspam-User: 
X-HE-Tag: 1777370780-871717
X-HE-Meta: U2FsdGVkX18MqXRysRn52pZTSbFecp9zzpv/SfkSa+65qgSK5KqqpeM0BLTjO0f5s6ObkChm+3/ED9IBD45cYA6LWa6vbzOFdhjWbQ9Iz6jHhAF18jfRi2nkfO1qmMFfpd712uR+8qgMoHInOshrRhSPI07ksH7g36j1PcXbMwWkTIukxTiQvEn0EHtisYD8lrPzSSSF9xR1s9WUxltxX5JfuglZwGDRHiacjQisl1wWa/eLtpkz20MqK20pa26zSUYj7NKWj1YtNbbUt1WVjNu1ZoYzxm1QvE84XzFAOB4lCAfBTdlwk6EEL3xPsdhniOOWJUOpfQRhEHVW5SulhtZfOhqAXiMX2ic0LIE+MbgfprjF1qr6jnRgkwQpPQgDNFUTJ+Opv1BBPmCVtVYFyJtVKnDhWQexNGIx22kd1kJVOStKneNN4uIFWUNafy9u75MJIk6MrTFnABnv5kR6s8es3Ub+Rv61tS0YyShSSVUyT6RJTRHv4ZuHBbVAwCyP7+LE2HCHfb+shn5WmfO/1PAYrYoCzl4TlCOYtl39PSwMpb3qTYz3jyeo8Ulwxzq5ZvJPynN1sHmqaYhAmc3Ep3rTSwZKVk0bE+dl3TvYy33iVv/rIAdUTMbx0M484B2cTpnQ38btymlncJR74oRIU6ATlVYF7luPnWLIwjwNwVDnnlYJwt4iY4LCH0SMC1p8nKRjJSKO/xc48BLK/s+ikUYZW56quIYK958uHXBExhQp5bdLq4azUm/Mw7S6uR49AzXioWAVXeaorTAVaTjIC9FSb3aA5GmA9zcBdA9EAwMyY/3ma5i5JVIErw9PTiK+dj5OwiKOEYBdWwKo+AUrUaqVHp0ALoqpysncjOavY6Q9GojPD971+NPOZ9Am7JIYQCBjtGtkBe+fj8k3BTX/w2dXI4E1bmblXvxxjc7CeKOo3FJCeiizte5s/tMscZRMaKxSCAoX9WsepFqtshM
 ubOIj7/j
 nFnMQ0twExXXn/+OVOAKfAU+/bE7zsrDYhiiTp/JPPt2DXwW3VImRF1tzM1saWju8fAcpRf/cVE90XBrOo3ara7Gfw7jVamQkOLyEn9+thFVKjIcrv9UyfBsNUYgddS5wDX4/S9S3EIphFj+PcxB/HRkFHHh35a+kYSvZmc6kHvqZxOBAZHO/nw3TZrTseCCiTrpjTyOjAA+bnCiJGkNLDifAprUduZW3xhHprcHjXjpZGWFWpMLc9LTThCIYU3YgmmSI8JuSdu/FCMT1vAV7RjnHQwIWjmQrqcw3idUhc7EXM9SUB1LJ+zy0g6pO7L5WPBFIyV4bk4smR0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 11:52, Vineet Agarwal wrote:
> ftruncate() is needed before mmap(), since the file is created with
> O_TRUNC and initially has size 0. Without resizing it first, mapping
> and accessing the full range can go beyond EOF.

Ah, that makes sense, worth spelling it out. Indeed, we otherwise get

$ sudo ./khugepaged madvise:file .
Save THP and khugepaged settings... OK
Allocate huge page on fault... OK
Split huge PMD on MADV_DONTNEED... OK

Run test: collapse_full (madvise:file)
Creating ./collapse_test_file for collapse...Bus error

-- 
Cheers,

David

