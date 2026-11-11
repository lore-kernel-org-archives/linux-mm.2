Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2285B60A260E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i7SZ5Zqf
Received: by kanga.kvack.org (Postfix)
	id 4A9E16B05B0; Wed, 11 Nov 2026 01:45:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459CD6B05B1; Wed, 11 Nov 2026 01:45:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348CB6B05B2; Wed, 11 Nov 2026 01:45:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB736B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:45:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 909FD801F4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:45:42 +0000 (UTC)
X-FDA: 85421902524.11.3A52E11
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B2D8A0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:45:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i7SZ5Zqf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXT3VLYjtA8pogy2vMiWc4L4U/Pmo90wtlWq1YzWIIM=;
	b=3ceoT5gOvBY3kK91ufgSVRdINLW6T8yilrOGMMsv6iTjVlJcRR0uaqtTB/jE5t2+cReVJP
	4XTnr16qQNj+IFl6F2GgR7CHRYzEBotrTbY8M7d0bIgwM/H0O2kRLcsvUK5AZciWJrM+o1
	JyjoZLUDgFNOhO8VpcjsrgL0lAsdsuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379540;
	b=N0V6ZP5roGFn8K+a5Nz7gSSvM2cn/Y2W3N4JXlqPmmRnBnbkyWJe3wJebaVkSqNPrKHJPG
	Bevws9CMB7ARf9T+WLVXdbyG9Vpt9WpPz0GMCzu017j+o6NgT/Ay4mmhWekVM78Lb2gQG0
	0n0ELo70+tMlzMR8HZpXIhAJj9+fxhg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i7SZ5Zqf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uQt+gZcqLg5yhdeDpbR8lZj610GLoqQ3N3quenEOm/0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379539; v=1; x=1794984339;
 b=i7SZ5ZqfFUh8+Ep8t40cQxMTTzvs1wnvCcN7cRU7l79WEuHge0zOUm+/dikIBdWZopEIZxkV
 Zq80mkeyZ4TDTDJB8oSzrj4ZKgEJr6DwZAD9fcyP4Yzoc6PGXpW+pxy8vepQN+mAOrjCNtX4ZBz
 V/Ty94GjcnB/qIRLn2qg853s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 83ebb53e35329805;
	Wed, 11 Nov 2026 06:45:30 +0000
X-Mizu-Trace-ID: 83ebb53e35329805
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 07/20] hugetlb_vmemmap: Disable HVO sysctl if arch
 doesn't support HVO
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HWOPP6PLUVvL+v0-UA6YMG-o4p7dY6UmWif1aDCDgscoA@mail.gmail.com>
Date: Wed, 11 Nov 2026 14:45:12 +0800
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
Message-Id: <08C72590-E44F-4DF3-B1DE-E7CAC0A43CAD@linux.dev>
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-8-jthoughton@google.com>
 <2122761A-45AD-4AEC-AE88-B51E92E2CA40@linux.dev>
 <CADrL8HWOPP6PLUVvL+v0-UA6YMG-o4p7dY6UmWif1aDCDgscoA@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 5twn1zewx93xbo8hb65kq4e9cag5391r
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B2D8A0006
X-HE-Tag: 1794379540-386475
X-HE-Meta: U2FsdGVkX19VcfGClNzClhLkY7Q3x2d57RpvhMSjSZZR+j5gjozj4YKYdb1iE9RAAMgXFdtfPUEiLdpNsOFRdszs6kyaA270Uwqe59xRIbWOVFAH229Ay5jlauIpdrpQahorc0y9cViHN/mAYZnYK5k3ICZpXS4F/Q9geaEjrMlK+vVycD+fcw1ezN/HAw4ID6PvCj6nRJ8255qlabF/SJTxtZfzfW8cqtOLIGz4Oru0yH699M+5J8peDbTidbj3tl44OMb/bwsYYLANUDbDYuA2qTNRzMchSbV5S+wCb+tBEhX5/Fwrn92qdI02nhT5fKAknvxOGd7/cMhusX0GVedzYdqGeXnPjhRGOefn4S46F86ASnefGPITrM0uY9KzhZdWsEwxSketTeaBHAQn+pmpCsgukth0lTQ6BVQLsym4VPwf9raOjCxisaDpMqIWTz0xV4ou7pL5ObHdjlifrx1f8LS17TwXFcBW4rZ4fIkjOOm16itIKmF4oFHCnEJgrL6HwRjb2n+m2tUUSaRJU1EwcROcnEdG/UyDJr8Ky7rjVHsiCCuHvD8HnQpLsL2GN0Dh4lkYZxHz+9H2N6xqQbrA30GR55JYi6Uwnn1FZyshl2sdcCx5eHGpR1CoYSFztOnmfvyLMBQWRTYxWSyTQO51pmHpTqLFsGs08xGh7TsdHIjWEjPv01PfayWKY7GyqIoF9SkaVdnVDzFBZfnmakd1IsB/5q4Jbn2pSM+klX0vLebiu9v+bH70Xvw701anoW3leBlfJZkPWeCXTavVweFH9ou3MnixM0dB/ZifmxiSVbmTaK9XDxg5gI0S85JQks0y69Pequo0Y/PuvwcDenO6FMpvFy3AG+V0xgEp9LYztNzHBn94t1PukadG1qNPHtkM3Pt1ES7k3nQgcqlQVhPICV9lo2wauPkJgC1UsFThmNgfHrkel39EEMiYGrqpxVjuPh04gb5+1uGe4T0
 ucjTA0IP
 Eq6KSkSRTPE7eYTFHZjDwhJ0eA3pGd++0pasScY6odmJdvg9iL6CtnaIwimk3KsC+ah4N9fxq2GNq5zCQxfi+e0+eylVoN/tZuUrcvEQwHbjnAeG+AVmCi4InvJ4oRvAXnKJuFGpU2/JKXsE4iHJQH2rQPW+hdQNceHHUua87ubcG6qK4X03c9lHJCkvRE7s4a35p+UAiVb2RMTJGpL69iZY+WP+kxp7CxpHFrDYHWhp7sr/vErFThXQEUzKys+NlHFsoSQc0uJDh4xNq6upg4zcWfuqHaODsb9f8XK0AeSaX3BMdCob4Js47hjohwuRjtg1s7sLfaZrs6lUidZU+5vJikari4gFWMZhe2kY1sEfjOPdh7sGWqdMFNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 11, 2026, at 05:50, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Fri, Nov 6, 2026 at 11:02=E2=80=AFPM Muchun Song =
<muchun.song@linux.dev> wrote:
>>=20
>>=20
>>=20
>>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>>>=20
>>> Do not create the vm.hugetlb_optimize_vmemmap sysctl when the
>>> architecture lacks support. This serves only to avoid confusion for
>>> users.
>>>=20
>>> arm64 support for HVO is conditional on certain hardware features =
being
>>> enabled for all online CPUs. By the time hugetlb_vmemmap_init() =
runs,
>>> all secondary CPUs will have started, and the system feature set =
will
>>> have stabilized, including HVO-through-BBM, which
>>> arch_hugetlb_vmemmap_optimization_supported() checks for.
>>>=20
>>> Signed-off-by: James Houghton <jthoughton@google.com>
>>> ---
>>> mm/hugetlb_vmemmap.c | 15 +++++++++++++++
>>> 1 file changed, 15 insertions(+)
>>>=20
>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>> index 8596a462fee6..817ce39d4cf3 100644
>>> --- a/mm/hugetlb_vmemmap.c
>>> +++ b/mm/hugetlb_vmemmap.c
>>> @@ -763,6 +763,21 @@ static int __init hugetlb_vmemmap_init(void)
>>>      /* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct =
pages */
>>>      BUILD_BUG_ON(__NR_USED_SUBPAGE > =
HUGETLB_VMEMMAP_RESERVE_PAGES);
>>>=20
>>> +     /*
>>> +      * Architectures that need to probe CPU support for HVO have =
done
>>> +      * such probing now. =
arch_hugetlb_vmemmap_optimization_supported()
>>> +      * will return the correct value.
>>> +      */
>>> +     if (!arch_hugetlb_vmemmap_optimization_supported()) {
>>=20
>> I'm wondering if we could put this architectural check into =
hugetlb_vmemmap_optimizable(),
>>=20
>>=20
>>> +             if (vmemmap_optimize_enabled)
>>> +                     pr_info("vmemmap optimization not supported by =
hardware\n");
>>=20
>> then, we do not need those code. If the current kernel does not =
support HVO,
>> then the sysctl does not exist. It's already a common case when the =
size of
>> struct page is not power of two. If users really want to know whether =
HVO
>> is enabled, they can check via this sysctl file. Therefore, we don't =
need to
>> print a log line.
>=20
> Yeah, I can put arch_hugetlb_vmemmap_optimization_supported() into
> hugetlb_vmemmap_optimizable(), that will make the diffs slightly
> smaller. And yeah I can remove the print. I put it there mostly
> because it can be confusing. A command line that gets you HVO on one
> arm64 host might not give you HVO on another arm64 host, and the print
> would give a user a clue as to why.

We already have the log to indicate that, like:

	pr_info("%d KiB vmemmap can be freed for a %s page\n",
		hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);

We will see **0 KiB** can be freed when hardware does not support HVO.

Thanks.



