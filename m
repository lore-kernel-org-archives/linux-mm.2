Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90D3606A33C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Pg/fy7SQ
Received: by kanga.kvack.org (Postfix)
	id B76C26B05B5; Wed, 11 Nov 2026 22:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B262C6B05B6; Wed, 11 Nov 2026 22:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15156B05B7; Wed, 11 Nov 2026 22:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A92C6B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:47:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B169403E3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:47:49 +0000 (UTC)
X-FDA: 85425083058.30.F76AEAA
Received: from mta1.migadu.com (out-106.mta1.migadu.com [95.215.58.106])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C34AA0006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:47:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Pg/fy7SQ";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794455267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwZKB7nwtPgPNz+YCvPlIwTeSdJDxh3u1WNVkxdvYlk=;
	b=xjmdpfoipLnBA9tABpG6gcJk0mVuF6CmxJmjZx55N2ButQ+Y0l8E1jxxQEXlh2Wj5sY6PN
	t26FwkTHWQt+A3CDkZORUzrgjNGpmk9JB4Bni9dyCGOheCx5io+ut+2dt8ttfkaQ1eLB4Q
	eGewILH5rqc+earmqnaUXdPROHb+wQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794455267;
	b=JY6Tpy6Vo7Vk+ID8wG3AX9xWV1cJWwATuNgGyjTujEMzjsDl9GPW1OSW/tFN9GewpG2E2E
	P5Hq8njOZXs+1DijwH27jdYJjZvWEF32C9bwMnFHNfs8+XKJikAZnDwuWzZgTpNgvoug3q
	1UVJTvN5XJw1qInaHaYCU7I/kyHQKgM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Pg/fy7SQ";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.106 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OadfzCGW2WfZe3bKn2zs0QyfwtQX+wSf4CH5BaN2Vtw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794455266; v=1; x=1795060066;
 b=Pg/fy7SQkfATu7EVEkhbXVw4DwKfwKMto0NUPELfZ9AHXXR8xaAOlByyv+FN8K5l/dRzXkQL
 dfPCAwb6k9VOG0jSKXgv9YohjOi17WCLOY5hLDqrkMYDhboVmWszad9rSC+0FKMqOKXguOaensd
 9MhvQArqYWMf97YkIr4S4FRo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 64ab2262467329c6;
	Thu, 12 Nov 2026 03:47:45 +0000
X-Mizu-Trace-ID: 64ab2262467329c6
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
Date: Thu, 12 Nov 2026 11:47:28 +0800
Cc: akpm@linux-foundation.org,
 catalin.marinas@arm.com,
 David Hildenbrand <david@kernel.org>,
 fvdl@google.com,
 linu.cherian@arm.com,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 mark.rutland@arm.com,
 nikos.nikoleris@arm.com,
 osalvador@suse.de,
 rientjes@google.com,
 ryan.roberts@arm.com,
 sunnanyong@huawei.com,
 will@kernel.org,
 yuzhao@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B10D5832-7D7B-42E6-974C-6C394371108F@linux.dev>
References: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
 <20261021212738.321547-1-jthoughton@google.com>
 <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam06
X-Stat-Signature: k7qhz3mm87e31zsdu7kzin6nwpgb5g1g
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C34AA0006
X-Rspam-User: 
X-HE-Tag: 1794455267-323774
X-HE-Meta: U2FsdGVkX1/9BABEd/qtnUZzRU2w0E3D7Jwm+BMEuzSxQu9ny0hQTg34x36pD0l937lVVlZ9n5FSR1LrhGaxZWfgnhEZrc1Fw4q+OJPdLoNAFhHD2FPpBb4HqshR8K/MMdCrbNXTXtC5GMYfNQBXqdCRcW/DY2YGGNRmwVeDEifAnko3dLfoVD+3q1B9k0/E8NxOtZrlslmncDA319pa8OdTixW2X10qxfF0z36xxRbv2OtP7fnTT6+1Nv/0niJJ4oeUu3wSfyGQ+atQJFdAujjZiyICQ3lOoLBQMO7Ovtz9TFoCQ7SAEjlNb/F3KjNsn8uKeQlI1LNuwHGogsQIEicbAQ+OVD/vLfqZzTYfLX3iyj/8GPyb5RyNUcmurxq68YMnqw3+k74irTWH4qdQWIUKLjVe88DTizcj3neO064t3qppq4ONpYExMpnmxR7RzrcZnY/2UOzFe6Tw5yalk/wTAVQdtB9qQxifwGPaTT0VXCMupqo+heR8cWOH22WbTLFtOMZCiuFOFeCO3bg903TZsgQ067aGSDGxIQzxwoBY8oqZZSOR1FGASYSp/0+0fmEvf6W6VvA9z+aq6KOtyc+S6tGkmO10jXddRIXrKiHwCEDOwL3CiTailng942bMr7KQVROrwA3JS/0zcxveKs4M6bMcqWAydVXaz9HdAcdTMYyk8TZXlJeyPIkMievIYHvLsmcRyexTyTYZUDakpqKAn510NAbPb9pyZJvbnwcNfTrxIs8HhSKuIaOyzBvC/4e8kSyjE0YxDpERVkLVQY7kHMmE083uZxTEfqsAURf9w3Tj+C05h7C4Blf0D7JRhXL3zoGn/EcmDB8+TpaXbga99wjJo/QXXpyHLxoRc7Qzbs+mPe1JyagQOqZdmFl9hcjigpIY2DWQ2Dmruhc4lu8N5QDErhiz5/OsuX6TGHYldoRGrfaXt2ofUmgNu6ZaHBil5K1LvsCVHxn7X0R
 G5kWfCC2
 WbAAFxfQaKUtvqeyju0a2MYT9CUs34WPCL5BkTjv9OsmZ5/UKwRxZrS/nvEhyfp7yhsHTPcC6EQeKR0tjSdLXL/IkpIEpNuY9ag7MwBF2FnawI3cKfHuadF3+63PAmMARKlYr0NZCn49NefZb8ObMkW3nRCibiP3mOCGUsgCHOP746RWtIEGOMTwLHzEXD7VIXQfkT9woc+0o37jTRyAEBqj6fM4TEa2iLf59ddrOKYDvZqZtUPeQqLY1cMciQFBJErSJyQIvI0sNwGbo/s4zxBsuce9/0/4TZu+yvg0HYmsUvBhIZTx5+u3y/6B3CXoCUmdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 10:17, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Oct 22, 2026, at 05:27, James Houghton <jthoughton@google.com> =
wrote:
>>=20
>> On Wed, Oct 21, 2026 at 2:33=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index a1b51251103b..4dac7ed1df57 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -1613,9 +1613,14 @@ static void =
bulk_vmemmap_restore_error(struct hstate *h,
>>>>             * page is made a surplus page and removed from the =
list.
>>>>             * If are able to restore vmemmap and free one hugetlb =
page, we
>>>>             * quit processing the list to retry the bulk operation.
>>>> +             *
>>>> +             * Folios whose vmemmap was never optimized (e.g. =
because HVO
>>>> +             * failed when they were allocated) can be freed right =
away;
>>>> +             * remove_hugetlb_folio() has already cleared their =
hugetlb flag.
>>>=20
>>> Since you mentioned the hugetlb flag is cleared. So it's unnecessary =
to clear it again.
>>>=20
>>>>             */
>>>>             list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
>>>> -                     if (hugetlb_vmemmap_restore_folio(h, folio)) =
{
>>>> +                     if =
(folio_test_hugetlb_vmemmap_optimized(folio) &&
>>>> +                         hugetlb_vmemmap_restore_folio(h, folio)) =
{
>>>>                             list_del(&folio->lru);
>>>>                             spin_lock_irq(&hugetlb_lock);
>>>>                             add_hugetlb_folio(h, folio, true);
>>>=20
>>> Something like following:
>>>=20
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 6a011b627986..1ab3e61f4704 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -1616,21 +1616,31 @@ static void =
bulk_vmemmap_restore_error(struct hstate *h,
>>>                * If are able to restore vmemmap and free one hugetlb =
page, we
>>>                * quit processing the list to retry the bulk =
operation.
>>>                */
>>> -               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
>>> -                       if (hugetlb_vmemmap_restore_folio(h, folio)) =
{
>>> -                               list_del(&folio->lru);
>>> +               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru) {
>>> +                       list_del(&folio->lru);
>>> +
>>> +                       /*
>>> +                        * remove_hugetlb_folio() already cleared =
the hugetlb flag
>>> +                        * for folios whose vmemmap was not =
optimized, so they can
>>> +                        * be freed without restoring vmemmap.
>>> +                        */
>>> +                       if (folio_test_hugetlb(folio) &&
>>> +                           hugetlb_vmemmap_restore_folio(h, folio)) =
{
>>>                               spin_lock_irq(&hugetlb_lock);
>>>                               add_hugetlb_folio(h, folio, true);
>>>                               spin_unlock_irq(&hugetlb_lock);
>>> -                       } else {
>>> -                               list_del(&folio->lru);
>>> +                               continue;
>>> +                       }
>>> +
>>> +                       if (folio_test_hugetlb(folio)) {
>>>                               spin_lock_irq(&hugetlb_lock);
>>>                               __folio_clear_hugetlb(folio);
>>>                               spin_unlock_irq(&hugetlb_lock);
>>> -                               update_and_free_hugetlb_folio(h, =
folio, false);
>>> -                               cond_resched();
>>> -                               break;
>>>                       }
>>> +                       update_and_free_hugetlb_folio(h, folio, =
false);
>>> +                       cond_resched();
>>> +                       break;
>>> +               }
>>>       }
>>> }
>>=20
>> Thanks, Muchun. :) I think it's slightly easier to read without the =
second
>> folio_test_hugetlb(), like this:

Hi James,

Could you send it as a separate fix patch so that we could merge it =
first?

Thanks.

>=20
> More clear, LGTM.
>=20
> Thanks,
> Muchun


