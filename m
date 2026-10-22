Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954E5606A321
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KMvWgC9Y
Received: by kanga.kvack.org (Postfix)
	id B128F6B083B; Wed, 21 Oct 2026 22:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2826B083C; Wed, 21 Oct 2026 22:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D86E6B083D; Wed, 21 Oct 2026 22:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7664B6B083B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:17:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 075CBA8194
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:17:58 +0000 (UTC)
X-FDA: 85348651836.07.156BE39
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F175A0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:17:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMvWgC9Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792635476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeHN50YZ/NG8ZWpDQLHml+D4SpMDuGPRyLBAp8LeAZY=;
	b=Mqpf2FqPJ+lP9/+n/VgGAJ5rUiV6UYVEJicK5bzeCNVOk9zCQwzSsJYIcoEzbmLkI93Crn
	l6e6KkC6/qjZu76wGAqpQlwwwkYaseGGLI98b/wzHkk95EolijUbVa4GkqzBINBMVVd3Cc
	xzwiG9xy02kyt9Fg7VAtozTZZmEx1Bo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KMvWgC9Y;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792635476;
	b=icIYpkkzCoPWt5rEnKG9COwoSAtRMOMo6voGX2Ek8aDWLYMPN4jQWfpRH0/FaB4yzz9MV4
	kOQCVzgc1xH4ye1TD1fkeOlFh0vdSXn/YypDbIWaQ9aY1yozAWU9NmvANkL8V26ZcVPZmJ
	iGwR//4SVgvRCCQGSseAcpMfs5zdJqM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Qhn2nJhqTpx6IuD7zDJXbEf7KoM/IdTDiwQaIPdkdhQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792635472; v=1; x=1793240272;
 b=KMvWgC9YhT7JwLA4p6mmxcta71P/xjEZeCiWVb9d++PieQb4pAJeRubKFQ4dm1iY2DYYOqCG
 MyoHS0aBFYhp1T3QrcGllxtZQKNi0Fah5GwKX8/ArkV3vGVObLlvdsTJhgpHRgQQ+N0jPAZEiLI
 gGfev4uOac6V5hIX9RGczOQE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9562aa6cc98d7210;
	Thu, 22 Oct 2026 02:17:51 +0000
X-Mizu-Trace-ID: 9562aa6cc98d7210
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261021212738.321547-1-jthoughton@google.com>
Date: Thu, 22 Oct 2026 10:17:31 +0800
Cc: akpm@linux-foundation.org,
 catalin.marinas@arm.com,
 david@kernel.org,
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
Message-Id: <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
References: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
 <20261021212738.321547-1-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 4F175A0006
X-Rspam-User: 
X-Stat-Signature: 3ahxj9cmsfqk18ka95oca6qfyyhxie7i
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792635474-26572
X-HE-Meta: U2FsdGVkX18+8zHkom+tquIlMD2wsJQTD5pvJOI7AJxM17b8dq47gfIu5TKVHMO3LzwGDHrCShfCTZb+L0rwHhLV26hzVt47gU+h8Dgcrq0g6tMR0rISgs/JDwpMOfYXAmIEOFCGbT1yHOf4x4b7cgx5Ue5JCGyMv9AO/EME+2AMptRMigDqTybR5q96JGpf/6YvIw5bUXip+2ro0OlDsBVEv4pGufkMBptjysi7FaWLLRakIy/Z7pY0d8+nsz+FwWBbjbL+e1iQfE7ubW8Sz80KtHTKQcJUssRm+x5HpPxmE7Ot9JS50Khd0LusCpMizJ9aqvm1yF66dTU+A7jGY44ZL05f27DdgjnInEklArumI8RP2tHwTfX0KurqG3N50ALCMhkRAWr1awtOETg2bVbYEUz4sUTIj7CPKkWbiuzyoFc4+OGv4hsTOLbRRgs0M8FsNEje4cpqB+HmtyBSos7hNoqx+lv3rMvIupT/Cvt2ofY7Q7PS0uK/atulZpQrajBOivDrG5XcFxz46FfhWiOSuXeMlVyHkImIfrUhlNDJILm49OoIVvqIfJh6HEbEGGHrwRho4GjbXARm8abPAy6IbQa+ar0Ch/bWbr/OuEb/J3ShBTk6++xiqfmKNgBHYhk6pfJjuIBeqtPfUk6r+wj+6aaXYDfj205kOrUaQqDGaw0st1dO1g5o3DzDJaw7sjqhSWE2xiuA+pIq2fG2OAauWVdbuP+WrtFSbfgW1Qmg4f2lSMSnrWlRByAi/ShcmE3Y0jr5d/hOPTNvEcY8+7unqnK7v1WqQHRsq7A4K+5Vv0KCWyiBw8hFt3GvNcDATAB9Cf+n8HsqqTeA2X26Of1stwC/0QLiGTGJpO40Czvp0Hz86bPWe5QQfZzFiLuARky394ex+N6ZnsYRYUDqLdkgGipkO9i5oD5uzbxL4fjqqqNUwQdirfb008HSSFENkIVQVWpyhlqmP0b3wKC
 uFTQrSPX
 BnVR+/qXBrjWKaOd6aGV++ZMSQiNKiZsSFsWKv7c0jF9ZIE/YBEmiJK6m9Obq61bq43vw9Zmb5HAzw9JqKpzhWNVtaFjfCjK/ZHuOMAoizEsEzsNqZ1GA+K0QmXM90zF1IY88YftRX4Je82BYnQyiLbvNq+xm5uzWFOlWd0ozCYfilVhw1hz5sTkXOniMr2uoDlaie5iRwYh90St48btBFjnndd9o5Uh7hrEXIQkHX2/MsWaVjIuqlHFH/YqA2rxeXiP7MzidDei2cUwLzG+XqKnuwskRyzEmZ3yN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 22, 2026, at 05:27, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Wed, Oct 21, 2026 at 2:33=E2=80=AFAM Muchun Song =
<muchun.song@linux.dev> wrote:
>>> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> =
wrote:
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index a1b51251103b..4dac7ed1df57 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -1613,9 +1613,14 @@ static void bulk_vmemmap_restore_error(struct =
hstate *h,
>>>              * page is made a surplus page and removed from the =
list.
>>>              * If are able to restore vmemmap and free one hugetlb =
page, we
>>>              * quit processing the list to retry the bulk operation.
>>> +             *
>>> +             * Folios whose vmemmap was never optimized (e.g. =
because HVO
>>> +             * failed when they were allocated) can be freed right =
away;
>>> +             * remove_hugetlb_folio() has already cleared their =
hugetlb flag.
>>=20
>> Since you mentioned the hugetlb flag is cleared. So it's unnecessary =
to clear it again.
>>=20
>>>              */
>>>              list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
>>> -                     if (hugetlb_vmemmap_restore_folio(h, folio)) {
>>> +                     if =
(folio_test_hugetlb_vmemmap_optimized(folio) &&
>>> +                         hugetlb_vmemmap_restore_folio(h, folio)) {
>>>                              list_del(&folio->lru);
>>>                              spin_lock_irq(&hugetlb_lock);
>>>                              add_hugetlb_folio(h, folio, true);
>>=20
>> Something like following:
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 6a011b627986..1ab3e61f4704 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1616,21 +1616,31 @@ static void bulk_vmemmap_restore_error(struct =
hstate *h,
>>                 * If are able to restore vmemmap and free one hugetlb =
page, we
>>                 * quit processing the list to retry the bulk =
operation.
>>                 */
>> -               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)
>> -                       if (hugetlb_vmemmap_restore_folio(h, folio)) =
{
>> -                               list_del(&folio->lru);
>> +               list_for_each_entry_safe(folio, t_folio, folio_list, =
lru) {
>> +                       list_del(&folio->lru);
>> +
>> +                       /*
>> +                        * remove_hugetlb_folio() already cleared the =
hugetlb flag
>> +                        * for folios whose vmemmap was not =
optimized, so they can
>> +                        * be freed without restoring vmemmap.
>> +                        */
>> +                       if (folio_test_hugetlb(folio) &&
>> +                           hugetlb_vmemmap_restore_folio(h, folio)) =
{
>>                                spin_lock_irq(&hugetlb_lock);
>>                                add_hugetlb_folio(h, folio, true);
>>                                spin_unlock_irq(&hugetlb_lock);
>> -                       } else {
>> -                               list_del(&folio->lru);
>> +                               continue;
>> +                       }
>> +
>> +                       if (folio_test_hugetlb(folio)) {
>>                                spin_lock_irq(&hugetlb_lock);
>>                                __folio_clear_hugetlb(folio);
>>                                spin_unlock_irq(&hugetlb_lock);
>> -                               update_and_free_hugetlb_folio(h, =
folio, false);
>> -                               cond_resched();
>> -                               break;
>>                        }
>> +                       update_and_free_hugetlb_folio(h, folio, =
false);
>> +                       cond_resched();
>> +                       break;
>> +               }
>>        }
>> }
>=20
> Thanks, Muchun. :) I think it's slightly easier to read without the =
second
> folio_test_hugetlb(), like this:

More clear, LGTM.

Thanks,
Muchun

>=20
> 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
> 		list_del(&folio->lru);
> 		/*
> 		 * remove_hugetlb_folio() already cleared the hugetlb =
flag
> 		 * for folios whose vmemmap was not optimized, so they =
can
> 		 * be freed without restoring vmemmap.
> 		 */
> 		if (folio_test_hugetlb(folio)) {
> 			if (hugetlb_vmemmap_restore_folio(h, folio)) {
> 				spin_lock_irq(&hugetlb_lock);
> 				add_hugetlb_folio(h, folio, true);
> 				spin_unlock_ire(&hugetlb_lock);
> 				continue;
> 			}
> 			spin_lock_irq(&hugetlb_lock);
> 			__folio_clear_hugetlb(folio);
> 			spin_unlock_irq(&hugetlb_lock);
> 		}
> 		update_and_free_hugetlb_folio(h, folio, false);
> 		cond_resched();
> 		break;
> 	}
>=20
> Applied this in the v3.


