Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1A80D68BE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:38:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF136B0088; Thu, 18 Dec 2025 02:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16CBF6B008C; Thu, 18 Dec 2025 02:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04D676B0092; Thu, 18 Dec 2025 02:38:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7D1B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:38:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A33C8140DB8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:38:55 +0000 (UTC)
X-FDA: 84231790230.12.04DD1FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9A271C000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:38:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EAm7LrRs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766043534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ESjkpNwJcYelSkRMexEXVmvcIFXYFEY9ac48yNViMo=;
	b=ht82rRfbEMvZ3oW7Bz81OGlfFhFwiczCgqHP+GfeGlMgX/felpHTR7VtsZvMt0VmekqtdM
	Dy27zTXkbTPLDUf+QdjX4mCOTd2knt2TlhmMrhEPt7ic2Nx1206wYs/uLinaCMMZiZj3hD
	DaBvMXxxs6dIXdjetfLbWtHPT2mepLg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EAm7LrRs;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766043534; a=rsa-sha256;
	cv=none;
	b=5MYAVPR1rL5cXEZ+6TE/7hza7KUMkyaX5DeQ5W7ADlpg1fXW39COKQshp81Bf8RN+ylK6w
	GJnroTHzHJ7EtwoQmXz0DvpDtlgEXl5EfWsWD4z8Je8VEfadDo6F3sc2Mgg3v6xd8ejLyN
	CT+J6MgsdWdFbOIA2WCkkodRJ/EnmM4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EE6643A5F;
	Thu, 18 Dec 2025 07:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E792C4CEFB;
	Thu, 18 Dec 2025 07:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766043532;
	bh=5SI3/UU5qYW0Gb+2KkOWE2iWbiZU++5QzEprZ0o/eFs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EAm7LrRssxRdkvRkw7CLYGtK0bR7+ZV5I0cxEUckORwjhQit/pXLe41NEgyw/67Di
	 W3DXuF+DKleZstjksQ2HpOc8nYxifFruSqKcRqg6OPBTOy67yqASQgBYq+wqCyfV4Z
	 rJYtkyMcvmGGAHg4YmcLy5B5jKJUVBwf2sXV6DFMtgtSEtEO4YIl0KMie5Dne3Qjfx
	 9uB7TfKPHxc0e0kWl2kn13O6YWvO1lEhK1pTTGMnW5GoQKUhK66/hxyYafcC4oDS8J
	 VZUl9j0Ft1W4X9iurM+AhsR9ljgSuetW2RuHw5oQO/OAriqcvu/kf/YqDcizigb7ns
	 sMlkIPwlo2NDg==
Message-ID: <b6c896ee-1c1a-4256-b8d2-ee5182b0234f@kernel.org>
Date: Thu, 18 Dec 2025 08:38:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 0/8] mm: folio_zero_user: clear contiguous pages
To: Ankur Arora <ankur.a.arora@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215184836.8c003ad094e8bd6bdb96f478@linux-foundation.org>
 <87ldj3f264.fsf@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <87ldj3f264.fsf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oimbddatabijwsorr1bdxuqsiaueubxg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D9A271C000C
X-HE-Tag: 1766043533-764660
X-HE-Meta: U2FsdGVkX1+WYD8CUTYKgR+4Fwvhzi05EN11ZBKDSlO8HNjSPlFCjtLYfZCMlNLDJ9UX0sUvnmAt6FxgXg0yO4Dpr1ZfowgyrM7b/BFh7/6xZs/IIG1wBsXTLbjsXhOqqfF1dkXbT/gPgSBMc++RR81c1UlbfEx0LS0FWrf62CP9IXHsUeGkn5Sw6gojklKyEEkcr+a/8Xl4ZeSR3dNmB1qRVqNo+mIV8KUBNeW1POV6LD52p+uLntchf5woZGNIFxc2XP71smazne9E8VgVv7Bb6cDmqIOcqcq4u0njC8S/57gvANG96PuiubFWNlb52/FzU6D9neLqGHIDX5S+l/wHVbwWtdGEByhEFwyuwoe0oy+a9uofXAjp5RpfiqkBDhdzUSyuE7t7EAz80Aj43bPNADFuZZkJyQ5UZei4xMhD0wE7psLqWQlB+Vq640uR8kqXbMG41DPS+eW0HGS8C7Gd9fOOCPVEFwWTzPf5Ck8KDlnXobmhLNvvnLZKK5hG8XIabmEpyx5px20uSDbgbgknzUhcWcz8smu0ihdCCofT8or/1McF29Tnv+Gpc4CnobEZbLV6NUT/0icGZj51sScWfODTCdA5fiyVwGTn9g8YGcrnS3lF1jnInfet4WQpxZLv9p7cWS4yry5lc6AGLv1LFPye8A+HVPHTEpL8TvOxVV6Mwie04sWrnuiwJaGjiKn77gKv/C1RZDTw0Vv8lLJ+fb2IOqf2747lPMi7luDxUMMnEusIVwNIGy7R9+uKrET0AdbmdTuGNJ7AP232QLYW4LSc4KxPTq1j64caHAsQD0gGKk9Q7VzWKtdHNIvOxC1Nwy3WPDVTzNuf0ge2wcoY0d3rga8jVfBHxDESGqsubcn6cI6Q4aTDnA8Lp1zF+9SLBa0u6ssHpqJ8kCfZlEKzoGqCsSUTvU8nN6U9ZdkVnFP/i8fSPwAZMG5+rnSXMO+b/CVoiSqRFQA6X5+
 9fr6d11Q
 Y7slbF/f+/91C0ODXqFfV+JcXuDej054Bao51R3Nyuik/U4OvF33qe4JHkjUrYtuYUTfV/r3wmpR4ZA0piNfoKlci74X6tGk0FZSOb0NI+N9h96YsML6ZxAgbzyFQQUYd+owpUwe6N33uWa13KL5cJdA5tTtM+6BKhcZxpWFfmEMc3mwL0GwVigeeoPb50nVQHEyZLt1xqK9sb5KhcrQ14H33TtuUt8DYgNt4tYoPTXFKUKYASx/h/LZmGB+K7lZGMVaKl7DU/EY9imiwPzw6mk4Qn+83uoFGhsp5eP+Y0qHUUGbgD7wYEqdEqpxRMOd/+z+eqIW1+mckBsxp6uwkrhixwDGDUprvamQFckbXYeEdkknkz2U2yLvGtMeMEh60rI2zh+5c+ik0XDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 06:04, Ankur Arora wrote:
> 
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Mon, 15 Dec 2025 12:49:14 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>
>>> This series adds clearing of contiguous page ranges for hugepages.
>>>
>>
>> Review is a bit thin at this time but it's at v10 and seems a thing we
>> want to push ahead with.
> 
> I think David Hildebrand has looked at all the HIGHMEM patches quite closely
> (though, not this iteration where I reorganized things a bit.)

Yeah, I've been reviweing this from the very beginning .... and I hope 
we won't start to rush things in simply because I am not looking for 5 
days ;)

-- 
Cheers

David

