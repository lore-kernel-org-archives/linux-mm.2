Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25AB6606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JfCOlgZK
Received: by kanga.kvack.org (Postfix)
	id 3D07A6B00EF; Wed, 11 Nov 2026 22:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A906B05B2; Wed, 11 Nov 2026 22:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222A36B05B3; Wed, 11 Nov 2026 22:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBDD36B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:46:06 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D90D1603B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:46:06 +0000 (UTC)
X-FDA: 85425078732.03.F0A55D1
Received: from mta0.migadu.com (out-233.mta0.migadu.com [91.218.175.233])
	by imf16.hostedemail.com (Postfix) with ESMTP id 686BC180004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:46:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JfCOlgZK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794455164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q54ZgYaX8BjdWBFfmk04kAiTzB08DOd9/jUUeigtfjc=;
	b=3J8J5skGD/Y8cZ0YoTIcEBVvkbPeOq+ChrdN+528IahJa1xP8SWF1eeP96Yg7SnlO1MHtF
	yD6ixTLdE3EppJ+Xd1TNVxM/pUshN4pcEHDCLIoA3p48iSr203iD0fYkc5NFB0ceE472tQ
	Lh97PY8oYLwNfmeun46W0H11B2Vx+0o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JfCOlgZK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794455164;
	b=BocpU4Ae4QwDWexJ4LOHWczbrA0D8WX5KLxW508vO+WHv4Aa/O4mVYcmLvTNRDi4ygf60v
	y3DBspCxfK6wSGLOYmiH8TRM0cAlTOgMiJIwQBljgZgAAmcWpudvStApgB9SDKwW+VV9Di
	Q/n6fuUOxJFBSrdCuVYR/4NMX3dxyRo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uUF3fmeZqYTyfU8Q2e2uhi8JIMAFbE1pwH9DFp8fOB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794455162; v=1; x=1795059962;
 b=JfCOlgZKx+qSQRlgo8qJNrSqQcpxWW5l3NlJiskBbfyE+OxcdqfoOY7+UY3M0Slhj8HSp3Kn
 s0hDW5+dNFvsAR4jZ28h2u5p3XPgrBzEL8SV/p8JQL7ZBKye6Kxs1QsbjEiuKPE/EtPwYYncpVl
 ZYd94v25peKsm5sOT23kXx9k=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 71c781794d33c4e8;
	Thu, 12 Nov 2026 03:46:02 +0000
X-Mizu-Trace-ID: 71c781794d33c4e8
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <7C857138-E17C-40E8-9F72-6FD3E3AB493D@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_59036DDD-4E62-4B5C-B6EB-875A19D0062F"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 01/20] hugetlb: Don't restore vmemmap of non-HVOed
 folios on bulk restore error
Date: Thu, 12 Nov 2026 11:45:47 +0800
In-Reply-To: <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
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
To: James Houghton <jthoughton@google.com>
References: <491B482A-8177-447A-8CDB-AF83C13A5DEE@linux.dev>
 <20261021212738.321547-1-jthoughton@google.com>
 <11457D37-5AF9-46C2-95BC-CAD4B22741A1@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 686BC180004
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bqsaapetgxszaz8yk9xbcgks9buukz6x
X-HE-Tag: 1794455164-832339
X-HE-Meta: U2FsdGVkX1+vc8YjSr3BWrObUaec7XIvLkajpE65/ruh56pFoAW5R272mb5jHdzT3iz0Eo88SEDaT71oppPbcZChtoNQDJ30y+Hn7E7jjflZXsSgw8Q1sIGeUqZlvWG3/weFeCgAMJ+TrVdGILeu86jJ8K9r5WhU1DfmusR5m78aDwR5HgsSELNSEzaYogMWWzlTaYa3OJEIX12ZH5qyAJC68tu/gdHvQMHSHO85eJ0xLI1LCkG8uYKZ9Tw/a0AHZhucTpmJ0+2rSCKpjMtOl7ncka3woUz+Df8EtgkRriUigcIoMSMigqrCX2NTdkqc3LTFZhGEi3FhAFmRkLK4czpifNslbJ4rEoKOz5TJ9XvcvQGzVX/MjyAEDFAClG0LngwxN2izp9wJjLHNcEyJt1wLemlB8BuuY8oJu8Ez0h4Ni7IU9g4hj3ADYEzQ+HkFj+9AtSoaGKoK4GEv9zLznBvGLPqEXViwPiYvU/xzoR9WfyRw90YwVOhX5gAB0+mc2wYCmyWAJ2WH7UvpWN3j/B7x176iAUSKs6W75tqk4ntbGfN2PjfqI6RxLKF3ZmCQDH1Qji8j4JCEAOHB4rwj8+YKLePPSo1XgnGYh0AqA7WeY2lwr0FszycP9//2CsTGd/BIRejIaF27n4rCcsYDPKaEXtFozTdpPYxwezP7/RcPxpusJJyu0RI12dMLp2bJAmbI+HI9WEgxS/NqpTV2YCyEph+u6i8ddMNY4RgjCYy27mcbi0N9lO4TlFquHg52Fdfr0Hb4gIvB7TyRlXF1rzm2CqjsdZLiA5CuNdiQwoo3InRIcB3MA12ywLmDxZu/8Ptuv66tmrCm0104MmGwtQ0+RhdZTdcFsyMQq2mepJqxYR9c7twWRwn3MtWFT91Q9ueHS9dbGp869iCIzop2GudcAxn99FpuadiTHtblxBkACQasjRGdGglOMhkZR/346TO+AS9/tvuqsUNu4xA
 aWUsckkv
 Bfdpxmc6qf+Jt/U0jOeKk7QdCxEpC3LY84NcQ4EZ44U+fhOOEpqj5OceqTizelweHtRYia7+kafiKvsk5VF0FwPHb4bJk8pqegS0uMi+ddvpGnQQxGx7cT8wOaswHh6TE8SeZam5EPd6WdXVCIkai9O15DA6BvAqXXDPEUPb/CFFiaSztwClVtn3LUIFC7YDUYQqTYnXrU3PFDBANIW+HQbsaUQNrjAS3mdbxax7CoVpmKk7Cr4STWLD78G7GRbmyfbsnpnZDOZPeA9AxZqShNbVAQ0c63+3InuvT2LM79yd/bhbvWh3OI4S8aS34QMNHxzBvYFk/jjcfCibZnmL+5lNR6l31e1E62be77muyZ0h+hFK/dt9UbqgX8RZIacbgCyw4GJXhF3cabi8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_59036DDD-4E62-4B5C-B6EB-875A19D0062F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



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
>=20
>>=20
>> 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
>> 		list_del(&folio->lru);
>> 		/*
>> 		 * remove_hugetlb_folio() already cleared the hugetlb =
flag
>> 		 * for folios whose vmemmap was not optimized, so they =
can
>> 		 * be freed without restoring vmemmap.
>> 		 */
>> 		if (folio_test_hugetlb(folio)) {
>> 			if (hugetlb_vmemmap_restore_folio(h, folio)) {
>> 				spin_lock_irq(&hugetlb_lock);
>> 				add_hugetlb_folio(h, folio, true);
>> 				spin_unlock_ire(&hugetlb_lock);
>> 				continue;
>> 			}
>> 			spin_lock_irq(&hugetlb_lock);
>> 			__folio_clear_hugetlb(folio);
>> 			spin_unlock_irq(&hugetlb_lock);
>> 		}
>> 		update_and_free_hugetlb_folio(h, folio, false);
>> 		cond_resched();
>> 		break;
>> 	}
>>=20
>> Applied this in the v3.


--Apple-Mail=_59036DDD-4E62-4B5C-B6EB-875A19D0062F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Oct 22, 2026, at 10:17, Muchun Song =
&lt;muchun.song@linux.dev&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">On Oct 22, 2026, =
at 05:27, James Houghton &lt;jthoughton@google.com&gt; wrote:<br><br>On =
Wed, Oct 21, 2026 at 2:33=E2=80=AFAM Muchun Song =
&lt;muchun.song@linux.dev&gt; wrote:<br><blockquote =
type=3D"cite"><blockquote type=3D"cite">On Oct 3, 2026, at 08:21, James =
Houghton &lt;jthoughton@google.com&gt; wrote:<br>diff --git =
a/mm/hugetlb.c b/mm/hugetlb.c<br>index a1b51251103b..4dac7ed1df57 =
100644<br>--- a/mm/hugetlb.c<br>+++ b/mm/hugetlb.c<br>@@ -1613,9 =
+1613,14 @@ static void bulk_vmemmap_restore_error(struct hstate =
*h,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;* page is made a surplus page and removed from the =
list.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;* If are able to restore vmemmap and free one hugetlb page, =
we<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;* quit processing the list to retry the bulk operation.<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*<=
br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* =
Folios whose vmemmap was never optimized (e.g. because HVO<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* =
failed when they were allocated) can be freed right away;<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* =
remove_hugetlb_folio() has already cleared their hugetlb =
flag.<br></blockquote><br>Since you mentioned the hugetlb flag is =
cleared. So it's unnecessary to clear it again.<br><br><blockquote =
type=3D"cite">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;*/<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;list_for_each_entry_safe(folio, t_folio, folio_list, =
lru)<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if =
(hugetlb_vmemmap_restore_folio(h, folio)) {<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if =
(folio_test_hugetlb_vmemmap_optimized(folio) &amp;&amp;<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;huge=
tlb_vmemmap_restore_folio(h, folio)) =
{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;list_del(&amp;folio-&gt;lru);<br>&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;spin_lock_irq(&amp;hugetlb_lock);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;add_hugetlb_f=
olio(h, folio, true);<br></blockquote><br>Something like =
following:<br><br>diff --git a/mm/hugetlb.c b/mm/hugetlb.c<br>index =
6a011b627986..1ab3e61f4704 100644<br>--- a/mm/hugetlb.c<br>+++ =
b/mm/hugetlb.c<br>@@ -1616,21 +1616,31 @@ static void =
bulk_vmemmap_restore_error(struct hstate =
*h,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;* If are able to restore vmemmap and free one =
hugetlb page, =
we<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;* quit processing the list to retry the bulk =
operation.<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;list_for_each_entry_safe(folio, t_folio, folio_list, lru)<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if =
(hugetlb_vmemmap_restore_folio(h, folio)) {<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;list_del(&amp;folio-&gt;lru);<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;list_for_each_entry_safe(folio, t_folio, folio_list, lru) =
{<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;list_del(&amp;fo=
lio-&gt;lru);<br>+<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/*<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* =
remove_hugetlb_folio() already cleared the hugetlb flag<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* for =
folios whose vmemmap was not optimized, so they can<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* be =
freed without restoring vmemmap.<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*/<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if =
(folio_test_hugetlb(folio) &amp;&amp;<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;hugetlb_vmemmap_restore_folio(h, folio)) =
{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;spin_lock_irq(&amp;hugetlb_lock);<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;add_hugetlb_folio(h, folio, =
true);<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;spin_unlock_irq(&amp;hugetlb_loc=
k);<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} else {<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;list_del(&amp;folio-&gt;lru);<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;continue;<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>+<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if =
(folio_test_hugetlb(folio)) =
{<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;spin_lock_irq(&amp;hugetlb_lock);<br>=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__folio_clear_hugetlb(folio);<br>&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;spin_unlock_irq(&amp;hugetlb_lock);<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update_and_free_hugetlb_folio(h, folio, =
false);<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cond_resched();<br>- =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;}<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update_and_free_=
hugetlb_folio(h, folio, false);<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cond_resched();<=
br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;break;<br>+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>}<br></blockquote>=
<br>Thanks, Muchun. :) I think it's slightly easier to read without the =
second<br>folio_test_hugetlb(), like =
this:<br></blockquote></div></blockquote><div><br></div><div>Hi =
James,</div><div><br></div><div>Could you send it as a separate fix =
patch so that we could merge it =
first?</div><div><br></div><div>Thanks.</div><br><blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">More clear, LGTM.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Thanks,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Muchun</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>list_for_each_entry_safe(folio, t_folio, folio_list, lru) =
{<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>list_del(&amp;folio-&gt;lru);<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>/*<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* remove_hugetlb_folio() =
already cleared the hugetlb flag<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* for folios whose vmemmap =
was not optimized, so they can<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* be freed without =
restoring vmemmap.<br><span class=3D"Apple-tab-span" style=3D"white-space:=
 pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>*/<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>if =
(folio_test_hugetlb(folio)) {<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if =
(hugetlb_vmemmap_restore_folio(h, folio)) {<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>spin_lock_irq(&amp;hugetlb_lock);<br><span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>add_hugetlb_folio(h, folio, =
true);<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>spin_unlock_ire(&amp;hugetlb_lock);<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>continue;<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>}<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>spin_lock_irq(&amp;hugetlb_lock);<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>__folio_clear_hugetlb(folio);<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>spin_unlock_irq(&amp;hugetlb_lock);<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>}<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>update_and_free_hugetlb_folio(h, folio, false);<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>cond_resched();<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>break;<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>}<br><br>Applied this in the =
v3.</blockquote></div></blockquote></div><br></body></html>=

--Apple-Mail=_59036DDD-4E62-4B5C-B6EB-875A19D0062F--

