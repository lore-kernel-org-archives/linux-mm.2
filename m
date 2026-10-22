Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9ED606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 09:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PwIAuW2x
Received: by kanga.kvack.org (Postfix)
	id 9726E6B0287; Thu, 22 Oct 2026 05:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942616B02C5; Thu, 22 Oct 2026 05:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EE06B02C6; Thu, 22 Oct 2026 05:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2716B0287
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:18:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37147407C7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:18:42 +0000 (UTC)
X-FDA: 85349712084.09.F9CBA40
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE158C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 09:18:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PwIAuW2x;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792660720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIP2wew2boNsbO2jCY9QS6pi4IH2031MB32CXAZbJYY=;
	b=ugNX/rvYy9tkGS5//h2sQWY5jqWNzlWceCqTW//mBpauDUiwsmwouFcvSyNIt4AOZiGVNs
	pg83pchSaMeai//K7iVZnW2gKsgUC9Z19foGg9rkV754zzcdeF9Si+zT5wonCrAEDdafGN
	kNrhiOJB2+x7+jis9fWBrFPFmGeySAw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PwIAuW2x;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792660720;
	b=3NOHhEPSzVDKP2NFpPYrprVUQqKEvqSaMpE5f3PgoeYHPIaLK2xqcYZwbk3tv/5frnh2t4
	F2k0dNXHs1mii+zEpbhkbk8lVEaQP8BhfZzl+sHQUnZNhWLuS2kricRF8JHoVlvoXD7s3F
	NiQLSu9JnO6XdnpsmPSCr3IrVpr5I2g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PIP2wew2boNsbO2jCY9QS6pi4IH2031MB32CXAZbJYY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792660717; v=1; x=1793265517;
 b=PwIAuW2xhT18typ6yIM2xFYWQglrpK0p4byP0s6wMqy348GHuH0JbMddiYT7vUFqlBO8fl0/
 Tu61RLV0d9rSQf3MBJT6j+9trRlxHdpa+gnL6+mhkWJHqMUaJNZU9xOOm+MXDSVp7T0bMSot3k7
 xLd9Ty8MtW1EEAoJI7nIT0H0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 59d4a31ee7773685;
	Thu, 22 Oct 2026 09:18:37 +0000
X-Mizu-Trace-ID: 59d4a31ee7773685
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 03/20] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HUOJwEgjUzefxSUa=AZHj4JO7koonj2_-WYhcL8QcXPZA@mail.gmail.com>
Date: Thu, 22 Oct 2026 17:18:15 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <440A9FCF-2B5D-43A9-9B02-C32F5955AC82@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-4-jthoughton@google.com>
 <B8A44041-1516-4405-976D-534AA2412A49@linux.dev>
 <CADrL8HUOJwEgjUzefxSUa=AZHj4JO7koonj2_-WYhcL8QcXPZA@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE158C0004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: axq3zjqape1wpmgihobjmpzmc16tkidy
X-HE-Tag: 1792660719-388646
X-HE-Meta: U2FsdGVkX18gbRZnCyV56OIC3tnWHqbRGiN6/G8ISfmKlxDKbWn2ZFmvsRHmSDKLMOPBDlZY/vVOzuVvAYgFJznMpVjrobWODPw+WSOO0TS+vi3DH+pFaUK9Jt341iMhs0wyeaJxnZwiocAB1x6tmAoTKKkRQD8A0+G6my5J/bMdUxJ/qegbi6+1elPq1m1mLtVf9hA/Iu+qjqkVVFa6Nm0b3cVAjRupEJmg2ik2RLCA7E5E7sHKyfS9pAxRaMMtH7ojgWmnCP3tIZp3lrWoyovpg0LC5QSsz22WUUl5N0LDhoaC40lxuKY1crjmonL6GLB3x6ukewhNgMPHnZM1HMuftG8juH3BsLoJLLlA38iiFTp7JUkleGYw2pOmY4MxD/MfEeemb2PJ2NO/9Q8MkIpXgzWAYJIdSx9YopVQ3X76Y69FOQZRdk/sjJ4MFOg4lkagCHhl5mWJ6WjU7sZB4BMaBxGshySw0ZUuMj0AAJDIOzkN7j4RgR/sY+swR1ShN+B/7+BAcejAQQDFL+MbBd2ItJMZ+/dOtmvWleB9v4jAmw8a8T71cv3iAXeJl03mettf6LbbxA2P8HDqZzTzybszfG5cEG2a38hRGi/dVpXyvhaQjjBxzCGVD7uaiHHpc4EXPFSp8R4YbEb5SsqyMplQasKA/nOZu5FdNgJc5sNoAFQASmVM36HhvBHOIS5aEP0rtyZ6npBynBCGjLi+fLJ41RDLpdIeBpSCBbAkqb5aUw/gjtWopSEUGt79/0PbYg219k2NwKd87KE43lD4yIQM56KApRfHxB0KvM+yDPz44DSSQtlt9Z4ul/X6pWfDGzmzwqkD2IaLDBOBwfuzf2FFvNN+EGrLAW4hwJPGEpMP3MT6mUdQbzA4LiaiEIyibc0QQrSo4d3NsybnxzoZzGPovQjicsGmuMFaSsYTgRpFa+cT6bV+MenJLPlSBSAiOqvr7Tui5ZASbDnIfft
 YRuHv+2h
 FbDS28qbuhS4CKPL8mGLAs9/PdXrbYEfZXr17qcjTZXR2s9YetFu0LI95wPc+gYL1KY9KanBuxOhPyy2nAWygxb9BAtAz3DGcp8vxJlDNzN3x3DbTTEaga2s4PuXyXTMgfxUSOztmerW7+qC4TDVW5SgZdEFZO9wQUSq99fF7ES434MPkQAm1p6eqpnnaF8SOSk4h4dAatZgcfwtFKrp91eMSJQUqiZoz+rvB3IsismPJawLL6J5fXUuIOrNKrh6ohHRvbRNY0ANtLajQLbxQMQb8X0zK1LL0vM5rsxwpLspAv8q9lQEPbG1hv5bk+E9aMJpMTrrpF5+cQUopWf2lVObyRWBgkFfniCTKb/xUTTyApMNPX5cMQZ6QTLeGXLSUhPQZorEOcuqig3nsr7D6Qc6Ew+IC74tomrrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 05:59, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Wed, Oct 21, 2026 at 2:54=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>> Hi James,
>>=20
>>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> vmemmap_remap_range() can potentially leave the vmemmap in a =
partially
>>> optimized state. In this case, a TLB flush should be done if the =
walk
>>> caller asked for it, even if the optimization was not fully applied.
>>>=20
>>> A follow-up patch will more completely deal with partially-optimized
>>> folios.
>>=20
>> Why are we dealing with partial optimization cases right from
>> the start?
>>=20
>> I know that in patch 12, you try cmpxchg 16 times, and if it
>> fails, it leads to the partial optimization state. What I want
>> to ask is, why do we limit the maximum number of attempts? Is
>> it because during testing you found that this kind of failure
>> is very common? If we did not limit the number of attempts,
>> was it because during testing you found that the scheduling
>> latency caused here is very large? Or is this just defensive
>> programming? In my view, scenarios with such intense
>> concurrent access to these struct page structures should be
>> very rare.
>=20
> This was done defensively, yes. With 16 retries, I never hit this
> without fault injection. (Perhaps I should try with no retries...)
>=20
>> If your testing did not find any problems, my suggestion is
>> not to set an upper limit on the number of cmpxchg attempts.
>> This should be able to simplify the design of the initial
>> version of the code to a certain extent. If we want to
>> determine whether an upper limit should be added in the
>> future, I think we can add timing monitoring in the arm64
>> try_update_vmemmap_pte function and trigger a warning when
>> the measured time exceeds a certain threshold. If someone
>> reports this kind of warning to the community in the future,
>> then I think we can improve it at that time.
>>=20
>> What do you think?
>=20
> =46rom userspace, you could use kpageflags or page_idle to =
continuously
> access a single struct page over and over again. I think that's a

page_idle does not support HugeTLB pages, right? We should only consider
/proc/kpageflags; reading this file requires privilege =E2=80=94 unless =
a privileged
user intentionally creates malicious software.

> pretty good reason to have a bound. Also, the AF can be set even
> without an architectural memory access (so a mispredicted branch can
> still set AF, for example); that also makes me want to have a bound.

However, I don't think this scenario would cause a significant amount of
concurrent reads.

>=20
> Catalin also said wanted a bound here. See the bottom of this reply at =
[1].

I see, but I'd still like to explain my reasoning and see what everyone
thinks.

>=20
> So I think we should leave it in. The extra complexity is pretty much
> entirely in patch #4[2], and I don't think it's too large of a change.
> I hope you agree. :)

Because I personally feel that having only part of the vmemmap optimized
is a somewhat awkward intermediate state =E2=80=94 the all-or-nothing =
semantics
seems more natural to me. At least until a clear problem actually =
arises,
I'd prefer not to consider it. At the same time, we can also keep the =
design
simple.

Thanks,
Muchun

>=20
> [1] https://lore.kernel.org/linux-mm/aoRn3Fn1dhTdsk6d@arm.com/
> [2] =
https://lore.kernel.org/linux-mm/20261003002123.505555-5-jthoughton@google=
.com/



