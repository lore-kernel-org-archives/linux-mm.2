Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC3ED606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HNkawzYM
Received: by kanga.kvack.org (Postfix)
	id B0FBE6B05BB; Thu, 12 Nov 2026 00:36:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0BF6B05BC; Thu, 12 Nov 2026 00:36:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFBA6B05BD; Thu, 12 Nov 2026 00:36:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70C866B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:36:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04EC3403AF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:36:04 +0000 (UTC)
X-FDA: 85425355890.01.F25DF47
Received: from mta1.migadu.com (out-112.mta1.migadu.com [95.215.58.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id C02591C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:36:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HNkawzYM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794461763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8AP+xq4dYAYyrMO9g0Pz0/bdK8mpNBZ2jUYO824rg8=;
	b=3B0Gk0hq6WGoDJj86CBBybW2ChcmRdXgRweojdhqn9636FCXK99O2nvxwcstA/FosDoL33
	tg+FEjvJvwmdf7LZqAz9ihWZ418DV4zlJsOo6sjyMhLje78rSIepEsGw8XUKEAGotUJl/Q
	2Vq+wnWQXu/LCtgneD3z7X4eTKt+BxM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HNkawzYM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.112 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794461763;
	b=INI0HJyR/iDZxxDgDCwsKy7drcOUxmDxEAuSmqOIuNpiGhC+rGiulOFoal71/oyG9+wtf8
	iilw4L1AZdk4a1e47C5Os5x5MVXQ4Gf6L7ahIzGu/w9GjZiZBWj5jVdG0F/PGO6SQJNHih
	HQfSGqsHTY4+dvYXEjQt5R4oc1PW7EE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x4GKRsib95qKzxiK/K33Qhp7C36CJ5fXuaJlzwfX+K8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794461760; v=1; x=1795066560;
 b=HNkawzYMnTCJRuSEOUbsyEc9h1tV3hK4EMBv4Z+F++BKfFLU6fkrfZ46zsdkphwFKMKokX3L
 IgOcJajGctrrFzKYlx8Owdwo+2e22LI+EknDANjkmRWtLRtwi0RQMpD3zPyPZwKWPTu0DvW2tHa
 vsks10E8wIOz6QY5FTAafuXE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 59eff83b8f1eaa97;
	Thu, 12 Nov 2026 05:36:00 +0000
X-Mizu-Trace-ID: 59eff83b8f1eaa97
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <040394E9-24D7-46D1-B2CE-251E6F7AFB74@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_2CBEFEB8-6775-4F47-B713-146B12E99856"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 1/3] mm/hugetlb_vmemmap: fix lost HWPoison state during
 optimization
Date: Thu, 12 Nov 2026 13:35:40 +0800
In-Reply-To: <1E848BF4-4AB4-4656-8523-FAC6DD8FDAEA@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>,
 sashiko-reviews@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org
To: Muchun Song <songmuchun@bytedance.com>
References: <20261111093747.50048-1-songmuchun@bytedance.com>
 <20261111093747.50048-2-songmuchun@bytedance.com>
 <sashiko-outbox-209812@kernel.org>
 <1E848BF4-4AB4-4656-8523-FAC6DD8FDAEA@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C02591C0005
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yay5e9q3nbesz5zamk9ajq1bxkmipft1
X-HE-Tag: 1794461762-441093
X-HE-Meta: U2FsdGVkX1+E57Vl+Meexanp6AExkTU4x9wfUPwf1EB/xUv+WAM3bodkcnPbSfF1v/kSLekUmWGK9f3YrG9d797ALJr9dJY1adKIR24BADun8utfhoGFhy0ix+03BrAyr19Liwc9bE6HPpcUwwAaexv/jmhLHH25u4JfiP42ZLZ8FUPULcqY2DOL485WGo7F7JEYxZHw6PkVk91eM+/eNeT/eNq1klXCAVxQS97HA/03txs9yycDj1QYkG/A5gc3gwoXuOYMwUeJvVjrqL5K99Mr88LIb3O+ejrYdnXHgSvoDSmR0HCj0uf12SaYHnW3oNzXOvO2GrAZQa+gqrWK8erj8nbNAPlDkjYyCl9dAFJwpktWeHYvGenXVkYeFhA1G+SH1T0oSXv3oK9aQsSyDbfLL70apYqaiUPMIY4XW7LyHWnL7UyG8bDAM21yVZDrr0bGkmE+0MCmPt3b3Bo8EPmPZaA7tI7G3WFKV+RvzdpC6gzhjj/ttp+ZksajChlSB2PJ/u4uR2L+Z+xbzUB/jGg7lAuZSfELuvYEo9htUDU6CHigfynXQecX+/1InJF5rJit643mbLhPqq83z1pVlShJus3Luz35qmx0/5r0vr1JIhDe+X0NKg2/0Y8I/leyYNLEEQdbSyly3vDuRBtyXXhVcHFXHJuIcOiaY2M1KTeUtjPe/8AvCz7kW9rU1VgAczhpnfY0g7kdJcPGvjkXFh7LpPQrPLdVgjq19WtMXUc1w8T9E6yc7DiWI7RIp8QS/0GwEf40j7J/CbajCvNpra261jcTATP0++TiRv7nws2GTC3ee2zbUDuB5fwpMhG7Zn8GeHWq3wlA3wg2suzgCOqavqUxNM/Cw8tseYPYuooII5jC2qSnYJliMxr5haq14YyD84lMCCePSrpTouBzpnFsWCTdnlatnZE+R+Zmf0W3xUrv7rOSA2k5nmyjeJeLcAqvYHDDNWx52PPvb7r
 pcMKnQDy
 wbJQAciDQ4n1SKQRCbabqj8OP5CX6sq0RUxEMW1QT7AK41/9U1B9h4y1gyda+4RGezEcn9YuQZ1gROb37AH7i+0L9gxyYEyGmAFeAJl4GHokUi7H9CMPFhEFplNCvvxdRp815xfxeu3wFRNDw6IcVwqxj3ps5zTxXD5UFpSzYoDSoWiezouG+uayYKpXLfShDeBaWBCk6+AAxxPAVaVmzvaMhsXI4hBqzLY2WWDR/2XjSFk8yRFynhaIm0QWEj23rK9n5ae8i0N7TfMAgS2TR20AphfNWlo23KD+xpvChudK3ruCrF54+T6M4fje/P/wrd4HW/9SO1WNGnAOJbJAOG3GDeCXKiytaM9e0u3Wbzap6bQG8eRkoAp6C6+3pOQeG0XezsFkLUvxyQlDw3PGlv2ED5tlkSUsO58w6nsaRDMsap74zyLMpDDdL0V2qge8ppTHq6VTTbCq43y8axXBAJ1uy9itaOLV493yzXvRrIBIb2/kuN2PqIzna2hCO8KjovPW4mevffgGqczBK61gYwhCqPbxD+EnDjMdU/MSUSFZJguMckbPTrdZhnRC/W8JFmdBpYSlPSB5AoF9T3tmN9yAIWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_2CBEFEB8-6775-4F47-B713-146B12E99856
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 12, 2026, at 10:59, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Nov 12, 2026, at 06:38, sashiko-bot@kernel.org wrote:
>>=20
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue to consider:
>> - [Medium] mm/memory-failure: unserialized unpoison_memory() races =
with
>> HVO head remap
>> --
>>=20
>> commit c0c1b7e9976626bf636152889fd9f5d88944d78b
>> Author: Muchun Song <muchun.song@linux.dev>
>>=20
>> mm/hugetlb_vmemmap: fix lost HWPoison state during optimization
>>=20
>> This commit introduces vmemmap_remap_rwsem to serialize HVO head page
>> remapping against HWPoison state updates in =
get_huge_page_for_hwpoison().
>>=20
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index 78f0a13349cb3..164a02866fd59 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>=20
>> [ ... ]
>>=20
>>> @@ -2038,6 +2039,7 @@ static int get_huge_page_for_hwpoison(unsigned =
long pfn, int flags,
>>> 	bool count_increased =3D false;
>>> 	int ret, rc;
>>>=20
>>> +	guard(vmemmap_remap)();
>>> 	spin_lock_irq(&hugetlb_lock);
>>> 	folio =3D page_folio(page);
>>> 	if (!folio_test_hugetlb(folio)) {
>>=20
>> [Severity: Medium]
>> Does unpoison_memory() also need vmemmap_remap_rwsem when clearing
>> PG_hwpoison and freeing folio->_hugetlb_hwpoison?
>=20
> I think the following diff will fix this.
>=20
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 164a02866fd5..abe92db14fbc 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2814,6 +2814,7 @@ int unpoison_memory(unsigned long pfn)
>=20
>        ghp =3D get_hwpoison_page(p, MF_UNPOISON);
>        if (!ghp) {
> +               guard(vmemmap_remap)();
>                if (folio_test_hugetlb(folio)) {
>                        huge =3D true;
>                        count =3D folio_free_raw_hwp(folio, false);
> @@ -2830,6 +2831,7 @@ int unpoison_memory(unsigned long pfn)
>                                         pfn, &unpoison_rs);
>                }
>        } else {
> +               guard(vmemmap_remap)();

Sorry. This is unnecessary since we already hold a refcount to the =
folio.

>                if (folio_test_hugetlb(folio)) {
>                        huge =3D true;
>                        count =3D folio_free_raw_hwp(folio, false);
>=20
>>=20
>> If a newly initialized hugetlb folio is poisoned by a =
software-simulated
>> memory failure before HVO acquires vmemmap_remap_rwsem, =
unpoison_memory()
>> can race with the head page remap:
>>=20
>> CPU0                                CPU1
>> hugetlb_vmemmap_optimize_folio()
>> down_read(&vmemmap_remap_rwsem)
>> ...
>>   vmemmap_optimize_pte()
>>     vmemmap_dup_page_from_list(old_head, ...)
>>                                   unpoison_memory()
>>                                     get_hwpoison_page(..., =
MF_UNPOISON)
>>                                     folio_free_raw_hwp(old_head, =
false)
>>                                     =
folio_test_clear_hwpoison(old_head)
>>     set_pte_at(..., new_head)
>>     flush_tlb_all()
>>                                   /* new_head retains PG_hwpoison and
>>                                    * freed _hugetlb_hwpoison pointer =
*/
>>=20
>> In get_hwpoison_hugetlb_folio(), passing unpoison =3D=3D true takes =
the
>> folio_try_get(folio) branch even when =
!folio_test_hugetlb_migratable(folio),
>> returning 0 on the frozen folio instead of -EBUSY:
>>=20
>> mm/hugetlb.c:get_hwpoison_hugetlb_folio() {
>>   ...
>> 		if (folio_test_hugetlb_freed(folio))
>> 			ret =3D 0;
>> 		else if (folio_test_hugetlb_migratable(folio) || =
unpoison)
>> 			ret =3D folio_try_get(folio);
>> 		else
>> 			ret =3D -EBUSY;
>>   ...
>> }
>>=20
>> unpoison_memory() then sees ghp =3D=3D 0 and calls =
folio_free_raw_hwp(folio,
>> false), which skips the folio_test_hugetlb_vmemmap_optimized(folio) =
check
>> used when move_flag is true and frees the struct raw_hwp_page entries =
from
>> old_head.  Once CPU0 installs new_head and flushes the TLB, the folio =
still
>> has PG_hwpoison set and folio->_hugetlb_hwpoison pointing to freed =
memory,
>> leading to a use-after-free or double free when the list is later =
walked or
>> freed.
>>=20
>> --=20
>> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261111093747.50048-1-songmuchun@bytedance=
.com?part=3D1


--Apple-Mail=_2CBEFEB8-6775-4F47-B713-146B12E99856
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Nov 12, 2026, at 10:59, Muchun Song =
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
-webkit-text-stroke-width: 0px; text-decoration: none;">On Nov 12, 2026, =
at 06:38, sashiko-bot@kernel.org wrote:<br><br>Thank you for your =
contribution! Sashiko AI review found 1 potential<br>issue to =
consider:<br>- [Medium] mm/memory-failure: unserialized =
unpoison_memory() races with<br>HVO head remap<br>--<br><br>commit =
c0c1b7e9976626bf636152889fd9f5d88944d78b<br>Author: Muchun Song =
&lt;muchun.song@linux.dev&gt;<br><br>mm/hugetlb_vmemmap: fix lost =
HWPoison state during optimization<br><br>This commit introduces =
vmemmap_remap_rwsem to serialize HVO head page<br>remapping against =
HWPoison state updates in =
get_huge_page_for_hwpoison().<br><br><blockquote type=3D"cite">diff =
--git a/mm/memory-failure.c b/mm/memory-failure.c<br>index =
78f0a13349cb3..164a02866fd59 100644<br>--- a/mm/memory-failure.c<br>+++ =
b/mm/memory-failure.c<br></blockquote><br>[ ... ]<br><br><blockquote =
type=3D"cite">@@ -2038,6 +2039,7 @@ static int =
get_huge_page_for_hwpoison(unsigned long pfn, int flags,<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>bool =
count_increased =3D false;<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>int ret, rc;<br><br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>guard(vmemmap_remap)();<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>spin_lock_irq(&amp;hugetlb_lock);<br><span class=3D"Apple-tab-span"=
 style=3D"white-space: pre;">	</span>folio =3D =
page_folio(page);<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>if (!folio_test_hugetlb(folio)) =
{<br></blockquote><br>[Severity: Medium]<br>Does unpoison_memory() also =
need vmemmap_remap_rwsem when clearing<br>PG_hwpoison and freeing =
folio-&gt;_hugetlb_hwpoison?<br></blockquote><br style=3D"caret-color: =
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
display: inline !important;">I think the following diff will fix =
this.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">diff --git a/mm/memory-failure.c =
b/mm/memory-failure.c</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">index 164a02866fd5..abe92db14fbc =
100644</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">--- a/mm/memory-failure.c</span><br =
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
display: inline !important;">+++ b/mm/memory-failure.c</span><br =
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
display: inline !important;">@@ -2814,6 +2814,7 @@ int =
unpoison_memory(unsigned long pfn)</span><br style=3D"caret-color: =
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
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ghp =3D =
get_hwpoison_page(p, MF_UNPOISON);</span><br style=3D"caret-color: =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (!ghp) =
{</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;guard(vmemmap_remap)();</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (folio_test_hugetlb(folio)) {</span><br =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;huge =3D true;</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;count =3D folio_free_raw_hwp(folio, false);</span><br =
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
display: inline !important;">@@ -2830,6 +2831,7 @@ int =
unpoison_memory(unsigned long pfn)</span><br style=3D"caret-color: =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pfn, &amp;unpoison_rs);</span><br =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;} =
else {</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">+ =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;guard(vmemmap_remap)();</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Sorry. This is unnecessary =
since we already hold a refcount to the folio.</div><br><blockquote =
type=3D"cite"><div><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (folio_test_hugetlb(folio)) {</span><br =
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
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;huge =3D true;</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline =
!important;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;count =3D folio_free_raw_hwp(folio, false);</span><br =
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
-webkit-text-stroke-width: 0px; text-decoration: none;"><br>If a newly =
initialized hugetlb folio is poisoned by a software-simulated<br>memory =
failure before HVO acquires vmemmap_remap_rwsem, =
unpoison_memory()<br>can race with the head page remap:<br><br>CPU0 =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CPU1<br>hugetlb_vmemmap_optimize_fol=
io()<br>down_read(&amp;vmemmap_remap_rwsem)<br>...<br>&nbsp;&nbsp;vmemmap_=
optimize_pte()<br>&nbsp;&nbsp;&nbsp;&nbsp;vmemmap_dup_page_from_list(old_h=
ead, =
...)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unpoison_m=
emory()<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;get_hwpoison_page(..., =
MF_UNPOISON)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;folio_free_raw_hwp(old_head, =
false)<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;folio_test_clear_hwpoison(old_head)<br>&nbsp;&nbsp;&nbsp;&nbsp;set_pte=
_at(..., =
new_head)<br>&nbsp;&nbsp;&nbsp;&nbsp;flush_tlb_all()<br>&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/* new_head retains PG_hwpoison =
and<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;* =
freed _hugetlb_hwpoison pointer */<br><br>In =
get_hwpoison_hugetlb_folio(), passing unpoison =3D=3D true takes =
the<br>folio_try_get(folio) branch even when =
!folio_test_hugetlb_migratable(folio),<br>returning 0 on the frozen =
folio instead of =
-EBUSY:<br><br>mm/hugetlb.c:get_hwpoison_hugetlb_folio() =
{<br>&nbsp;&nbsp;...<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if =
(folio_test_hugetlb_freed(folio))<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>ret =3D 0;<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>else if =
(folio_test_hugetlb_migratable(folio) || unpoison)<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
folio_try_get(folio);<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>else<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>ret =3D =
-EBUSY;<br>&nbsp;&nbsp;...<br>}<br><br>unpoison_memory() then sees ghp =
=3D=3D 0 and calls folio_free_raw_hwp(folio,<br>false), which skips the =
folio_test_hugetlb_vmemmap_optimized(folio) check<br>used when move_flag =
is true and frees the struct raw_hwp_page entries from<br>old_head. =
&nbsp;Once CPU0 installs new_head and flushes the TLB, the folio =
still<br>has PG_hwpoison set and folio-&gt;_hugetlb_hwpoison pointing to =
freed memory,<br>leading to a use-after-free or double free when the =
list is later walked or<br>freed.<br><br>--<span =
class=3D"Apple-converted-space">&nbsp;</span><br>Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261111093747.50048-1-songmuchun@bytedance=
.com?part=3D1</blockquote></div></blockquote></div><br></body></html>=

--Apple-Mail=_2CBEFEB8-6775-4F47-B713-146B12E99856--

