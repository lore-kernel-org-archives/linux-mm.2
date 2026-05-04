Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF42DFF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 12:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC546B008A; Mon,  4 May 2026 08:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C2A6B008C; Mon,  4 May 2026 08:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8276B0092; Mon,  4 May 2026 08:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7976B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:33:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4D8016011F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:33:19 +0000 (UTC)
X-FDA: 84729677718.14.357BB90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2EEF81C0010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:33:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoB4RQQJ;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777897998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov6I0fG6PAhk6kzcN0LszLBnd8CpCPYKOpd/yoDhomk=;
	b=VD+WIFg7Vgi9g6T2yQqxEKJb40mjb8O8YefpmrtmI0iowmQGio1dDgDFFaT4h4KUlHltKK
	aH0n6RR2A+M/SRfjIFm+mzX+Uef1/UfDp1Am8avsDPHqDJMQIb3+/m6F+AJYl1TuOFrex+
	XCFbQgdTQROS4ua36NSO+LuqMdaZNKI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CoB4RQQJ;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777897998; a=rsa-sha256;
	cv=none;
	b=OquuPjEpn28GogaBVMaithCHA5glp+PWrYG49DokvEOGcRD6VYAZJXh3qXUujDNIiPPT++
	yxa8eewaDkTk0jt+sJMIAzGmLmnXZGEpuHOfC1UhFcHz2/ompqoSJVNMwpX12gA8hfrAS8
	DSKiOLB32SyKQZ53V5HmTUJM0qjZj7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3027B402AD;
	Mon,  4 May 2026 12:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8A0C2BCB8;
	Mon,  4 May 2026 12:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777897997;
	bh=LA1iLLIBKGSqtuYqkYcNQYTiEQFmcJ4cV7wZm2qC/PU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CoB4RQQJaumPYMEwrV4y7Wo+oUqeWjddWOodEV8YfxYmYJUJzbw9Wiu9SjHA5zpEB
	 J7W6a41Zys8k3f++8yirXpAwwCwUrwO58Ae7pKD1jv8LgxP3xNYzGV227bquDARcDQ
	 AjUxxnzkor+xdDaHX5WrW2BXuzYGJvsYQNLDBo1TvK9ID6Eequrxo+FsVRn/10N9m7
	 MlahN3TmZy82LP+WK3ke3NkO9B+LioA2CaVr3J9A+vDGIC9ZXCZ0UoFFjCeSzypeBU
	 0kVE5sdbY/OXQ2DHga2a5WbAdaKrUwXvq/C59u4yjN2bVhKuc4spaoL4B+f0zh/i3p
	 z7kO8dJEn3M5w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Michal Clapinski <mclapinski@google.com>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock tests: define MIGRATE_CMA
In-Reply-To: <2vxz8q9z2w6t.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	04 May 2026 14:31:06 +0200")
References: <20260504102742.3833159-1-pratyush@kernel.org>
	<CA+CK2bChn3bAFBnmD-fNw2zh-JrAaA73DNmm416EbjXr=mTakA@mail.gmail.com>
	<2vxz8q9z2w6t.fsf@kernel.org>
Date: Mon, 04 May 2026 14:33:14 +0200
Message-ID: <2vxz4ikn2w39.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EEF81C0010
X-Rspamd-Server: rspam06
X-Stat-Signature: warcutktuszq8189cabg4seiybg18z98
X-HE-Tag: 1777897998-420602
X-HE-Meta: U2FsdGVkX18zSBqPGSPzvjP4CRU2DvZbIQEfHCdTWsBOmzSpKWOlABRZg2MkF58joXXBk+dqpJyWzdeLPSTQHtBBIUY4VS+VLJL9lUitsb+sq7P+HAg6CzYmkkVqqRVg66eAkt72fWGKEIpxfbJNnQ9sq/ppPKKj9VvqqhbTVKUb/sW/P7kb9FlH3gYULcn2O7EnBG8UhfV8rnr/a8itMWxmKtN/8VCMoIh2ztofVRn+3cVPaXDL0VhAX8IigqhBuqAGLn+L+exAcaEtTtbkIER/2p7R0/3rWTikynMdI22bet6OOsBiSkuU5opePoHjVzpU4bE95+HzGRjzYqWFwtAFIpnWOV+nI1w+8E4XUGITVa+7aUe/XcUwuMriTFbgWEUSrR2T24JeYLornDqN1DViHXGZ+HFEDHt7qJYZ5vgf7GJIfGswtRjFZPu0OCowdBjq1n9qoQZ8hrdpm94CankgpeWl06VXPMOAjwr8p4+1WrFAGVf5IPthLD8kJqaRagNSAFSnO1cOInex6iUg/Gpy67MD+/4H2VroDWybfJuyxHoSBUhDrcElDa08TRAwfgMp4b95kSmoUOQ5DNojhq5QfuwTvD+NTr9tj282LOkbpjmto8K6xIfVUD8pUpX8LvIjDWz/5Co9NnRKP6AwrhGHStYymCE4jB4HA0NNXjvJgOXbl1Y8lmn85ZemOenSHz8HoKBgiaIAof+r1N2f/YGUpFA9OBwydm3aJ+kphBKJ8UkG4r3yhA+pXCsjQV1+qfBz0ufJlkHusAJ8HN72HUXrfHoGxLvI1I5FxAM+fly4EEa/5v7ObXMcSq7rdE/6+LYmGrajIfJGk/F8OXi786ZF8bCla6z0JO+nyvEZ/5SXKHpU+qSv89HBEt966B+LjYzeOEHBGHDh2hCMn1235pxLJvmg+K9YKcFg5mSvIZ+Vd5ddGajAyrMGQRhzTzx/SzDkmBNoxq7jdhsg1bS
 KOcoK3kS
 U109w3etqQTtvIl2Dpw22tAaZrmJtukLNK6oSjdxdOx1t5bwj21jFEaazUglWGjtvX7C+F83efMKvjG34yJaffhgSOEHO0+Bv/LaeB3QcLLBy5o7eXUvjq91WCV5t2IrUXhojtAehgruh8HVTDNmkammS8162Eq+C79EhyRrLKppDbDRY2i2neyg3Xjh/5txLc39mHjULtTdiJCO/GMyL9uODmRLfW7gn3pCCR5F7iUTBc8asFK8bObwANDQxOfb3MA1ZNnmBEEWE/VI/+CBzpA4lp3RO+gA7wmdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04 2026, Pratyush Yadav wrote:

> On Mon, May 04 2026, Pasha Tatashin wrote:
>
>> On Mon, May 4, 2026 at 6:27=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>>
>>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>>
>>> kho_scratch_migratetype(), defined in include/linux/memblock.h uses enum
>>> migratetype. This breaks build for memblock tests with:
>>>
>>> ./linux/memblock.h:634:73: error: parameter 2 (=E2=80=98mt=E2=80=99) ha=
s incomplete type
>>>   634 |                                                        enum mig=
ratetype mt)
>>>
>>> Fix it by defining enum migratetype and MIGRATE_CMA. As is the case with
>>> the other headers in tools/testing/memblock, do not bring in the whole
>>> thing, only what is needed.
>>>
>>> Reported-by: Mike Rapoport <rppt@kernel.org>
>>> Closes: https://lore.kernel.org/linux-mm/afcdDm4aAJvNaQqH@kernel.org/
>>
>> Link does not open for me.
>
> Dunno why. Works fine for me... Maybe some temporary issue with lore?

Or, look for the thread under "Re: [PATCH v9 0/3] kho: add support for
deferred struct page init" in your mailbox.

--=20
Regards,
Pratyush Yadav

