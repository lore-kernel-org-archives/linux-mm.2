Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F36CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE2C8E0021; Tue,  9 Sep 2025 11:40:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46DEA8E0003; Tue,  9 Sep 2025 11:40:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CD08E0021; Tue,  9 Sep 2025 11:40:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 223468E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:40:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C45FE13B6CB
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:40:27 +0000 (UTC)
X-FDA: 83870123694.10.8B897D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 438C7C000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:40:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXslSKOp;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757432426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GncCjE3LDQxPsQwNFS4V0AxPTaIdO+pj35MKoSPtZiU=;
	b=7NnRB2pyES1pV9WpbmjewAbhhBnO9SjsX97cE72DN9dlN55Kn2hm4F/BvAxLH/7/qG6ilM
	I28/yiA22Wdj6nnXCqzUiKz+WaiQVRd6Y4h2y2s15hO3X8ZcWhEZgDLtvvrwC0QRgyUP3O
	2dhxdDLml+kFFl2zhd1br+U5DZow/sA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YXslSKOp;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757432426; a=rsa-sha256;
	cv=none;
	b=YD70TwikfsivBgLU53W92EsfsJVSd6+jk4s20a77d2C89LU7a4CPsHVx0NWHliSp+pFLwj
	ACIafepgEY/zV2JqgEPQZDt4R+P3bngW+FTSSQ5SOH4xJnLA4MKoUcjmowAS0uVxg9PwWe
	DacsXBu0z2cyJKPW5cCi2QM2V8PVKj0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AAB9E6022C;
	Tue,  9 Sep 2025 15:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD52C4CEF4;
	Tue,  9 Sep 2025 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757432425;
	bh=J+P+ERGtyQIPqKHoHTRunn1D/v4lU1nzFD4xwAWeJEk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YXslSKOpOjN++5UFXUYxNV490+NFjX291NvrK3OsZheHLjV2yS1bWPcGMqzcImcz2
	 NOc8KlRHnla4/PGZ/HqtrTIyv7hdBGYEm7b48WdAgJ1Uoott2Pd9/NHmqISuWWj+Pa
	 HNuOPgSc7Qiy+8mN4a7jIoHWLJosYqgMVgDL2MmHZJslXSv/YI+N6SeCIx9xyPiTAu
	 f5ypmAzDDRNFUD/dg/J9TwOMMHl5bIoIf5ytrhq8p/O4ddYNGX6igaKvDYQlqfAkgy
	 oDKZdeNHzNDHH3w2hgUmQ63xi0GgV2AVgW0tsEmvAKSHsrCWo7Fj5fJk+SfkZCpNUk
	 JgoAWFI0onM2g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Thomas =?utf-8?Q?Wei=C3=9Fs?=
 =?utf-8?Q?chuh?=
 <thomas.weissschuh@linutronix.de>,  Chris Li <chrisl@kernel.org>,  Jason
 Miu <jasonmiu@google.com>,  David Matlack <dmatlack@google.com>,  David
 Rientjes <rientjes@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] kho: introduce the KHO array
In-Reply-To: <20250909152814.GL789684@nvidia.com>
References: <20250909144426.33274-1-pratyush@kernel.org>
	<20250909144426.33274-2-pratyush@kernel.org>
	<20250909152814.GL789684@nvidia.com>
Date: Tue, 09 Sep 2025 17:40:21 +0200
Message-ID: <mafs0ldmnk522.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 438C7C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xc5u64dhn7qirc9n5iek4irzbeccgpd1
X-HE-Tag: 1757432426-870492
X-HE-Meta: U2FsdGVkX1/A/dnc1hhREvj9SyE8yGOFhoqorlR0tkI5mJeQuwpN1252c9wCTWnyHwx3PD06FiPp6G9H/x6kjGrbsSQswkiSM8Jjzx/Z/uhv38o0F6KmcYoKTHRU19rq3lgpmMakE0A25rFdOVzXK2syNoHDnKxyFW54KXnM/gOiddgG3M8EGKJZOZ0fJa4d1u79gR1ZGQAnx0IMBKICDXqj13y7i3c0kVF/pX+u6oDrjFMYaphkXw4atspULDBjofLfgJ8pLLOa1v2/iEZ8538pZWkN+GxB29EfkYHcfPfEuTuym/B4ArZBtg11LJUBnyT7u/3GqHrUs6wdSRqQ82l8MUYCXHfBVQmDMWKUJJWk6Sd95oKp+jyBBdPW6VDf+C+a138hkRlAzFrdOIPLRKTlhHqcmpsblHxBvwz7g6qS2y41ecGqnopPEO2f/Jp9nvd9o8DD2SPgnE1twKBa7BmiUCZ47N84f4jlgu8M5kA99nSFJUHSd1Ce76uUwRYZybEBG2MveJBSN2MG7QFFDCLvPZHqAfPSVz69z1K7diq7T1P+A9fp6WBl4JtNqTtQ7dnM0uIIdRvaY1AZfSCXz2cMCVvBnGhe9ibT8oJPok76SY3B9pjTzL080IeIX+7OXG+awtbNddo3xyXIvM8Ol1AdY/JMZitzhQIfLSFPpXq75EFYBhOUF5IWANnJD8WUH5palAYZuBvCKL6y3xVos5hI8+nwQoj9x07XE85maskjOPTKaCxlkXPMrR7gjTv19E6uCzl71Bl52ytgmKzF3c9fpnGbovVdMh5iE5gC2YObOcHGdx38DCWGoSPtrQwkNRoLrcMv393nQ4rLUosKHrrpQ/sgNetvT1pc7JbxVHwKvCUpsRq2GanNtMAJW/MsFqpvRY7YNkvXqTJ1Hp/U08LaM9p/wDuFMaON+ApxxqfBDQyYYHof5CZYnThglIc4+Ljv9a0HmV3bCRBT2ju
 rZPGE0d2
 OUt/ODEtFawDPu4uUn0kKHyP0XZMR2+4nqk83UZ8uYDQIdJGbu3n1NOhjlQWD2nIZSghckzHLSuuPlGm/4hq1RFfCEPX99RaaqvFWquKOQ3V335P+IlSck63QMiiY7CEjolklfmbN4ZcFPGdi1xxPlYMpVoqh/zr9r17Ng9zVOKnuE20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Tue, Sep 09 2025, Jason Gunthorpe wrote:

> On Tue, Sep 09, 2025 at 04:44:21PM +0200, Pratyush Yadav wrote:
>> The KHO Array is a data structure that behaves like a sparse array of
>> pointers. It is designed to be preserved and restored over Kexec
>> Handover (KHO), and targets only 64-bit platforms. It can store 8-byte
>> aligned pointers. It can also store integers between 0 and LONG_MAX. It
>> supports sparse indices, though it performs best with densely clustered
>> indices.
>
> That is a bit of an understatement, it looks like worst case cost is
> 4k per entry. I would expect better efficiency than this if we are
> serious about supporting sparsity..
>
> I think you need to encode the start pos within the entries in some
> way so worst case cost is bounded to more like 16/24 byte per entry.
>
> For instance if the page was broken up into an array of structs like
>
> struct entries_block {
>   u64 flags:1;
>   u64 num_entries:13
>   u64 pos_increment:50;
>   u64 entries[]; // contiguous pos
> };

Right, good idea. I can look into this. But only if we get an agreement
that this whole idea is worth pursuing. I don't want to waste time on
something that will not make it in at a fundamental level :-)

I think another idea can be run-length encoding to make this even more
efficient. But I have stayed away from that so far since I think that
can get tricky and bug-prone to create and parse.

PS: do you know if bitfield layout is reliable for serialization? Can
different compiler versions move them around? I always thought they can.
If not, I can also use them in memfd code since they make the code
neater.

>
> And if a high 64 bit pos can't be represented with pos_increment then
> you'd have flags = X and entries[0] == pos instead.
>
> Jason

-- 
Regards,
Pratyush Yadav

