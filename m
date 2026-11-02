Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5BD606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kEe5aCO2
Received: by kanga.kvack.org (Postfix)
	id 097BC6B00EF; Mon,  2 Nov 2026 07:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049126B05B1; Mon,  2 Nov 2026 07:08:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A8F6B05B2; Mon,  2 Nov 2026 07:08:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B12676B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:08:55 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41877A0C38
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:08:55 +0000 (UTC)
X-FDA: 85390057830.19.1815907
Received: from mta0.migadu.com (out-63.mta0.migadu.com [91.218.175.63])
	by imf31.hostedemail.com (Postfix) with ESMTP id 342D920002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:08:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEe5aCO2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjJ92/YRxESOcxXg0+jeJTGUWnllnz8alEghdzFizqI=;
	b=wU7E8248CXpiDfSNYdjdIkIbdUAH0EdYzgjaht/gq7oHsWqcXqlNMTiw9Bw75+XDHI+7pX
	Ta/YBmQAdkei5ws98tMnUF2lhHaJwiD0qMUOxU5W2zL46YZc5ausi7LSRlss8f6gtOtFlB
	3r2lih9+pq4fnhW8EAhxaMwECvkGprI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kEe5aCO2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.63 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621333;
	b=uH1ya42JvSTspbpBStK3fPbe8WIaeVhS5n+9qS9LKZEpZBGkSeYokdcpDoYAodHISvw1yX
	2Tr+5c41qzQQZZRV33WkarMrHaydy0isSHPciqUTR6shxzUpOh50+GZfrTQVdinoZUZNWR
	i8Wx2C756o1X4dJbwf0GlpZUb6Cm4zY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=US3qDO+m6nnJUa6wwuAwT58HZ7ZuIJyUtTEfmDSqGeU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793621331; v=1; x=1794226131;
 b=kEe5aCO2JsQo+97qDxlgZ1i1ViIAMSsI/r9uG7vMQ8ecygtGsiSiGfpTfs3SdogDROKkVWmk
 Vbw9slbHR5eGIc8yT/XEf5zDXEMd/t+yXIUusCgkOZ6qej6LvPIyvff7cS/CFhkLeBWQJWODB+b
 BdAzKRQH2DUmLkk/cQ6aUj9g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 087bf30dbcb0ba0b;
	Mon, 02 Nov 2026 12:08:51 +0000
X-Mizu-Trace-ID: 087bf30dbcb0ba0b
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <C625F98E-9008-499B-A05C-12C1944330A7@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_DC0F39B8-148E-4EDD-86B5-1A6F95887C3B"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
Date: Mon, 2 Nov 2026 20:08:31 +0800
In-Reply-To: <179361471104.1337633.3959715900505206111.b4-review@b4>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-5-songmuchun@bytedance.com>
 <179361471104.1337633.3959715900505206111.b4-review@b4>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 342D920002
X-Rspam-User: 
X-Stat-Signature: ohqfmmxq1sjy684mac5k8jfqcj6atzf9
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793621333-431749
X-HE-Meta: U2FsdGVkX196hQd+2frBzNpju1Xr67kBwCWDMWm17n09SeFUygpuH1E1BP/jP3GG76tLtmXP7dmxacrgDcGG4mio96Flvf0gzEufCWnJ1wqcADi8RIPQdIATPcGqo3YQouhMVezzOAjeUe59xPOL7Kp8ANrD0kahEzlOBS6ElrRIIdC67J92OHqfN9BrGM9bs5XCto2AeqVJ2djYRl6WZ8oN9mOivp0TSEtKmdydo/YA+skYMnWsi5VX17Xg7i6A6/B9po/0jQm0YQJnu5mb2TXTNEiuH/YCNu8cO8oRdahF8zg1gq5NKIBcbAgTMj9GAPUr38AdBij4McXDTDKSI6EzVRZrV+QvtfQ0DZhiKgC5fOTkuO0odGAi178CgismhVhPmRtIJzr5C6fWEFrNt78ccnk9XGqO7flDrqmij9tEEzsWBOM3Y3i0vKYt0SCTMK108wcVIwDHLp/d+UCW1mWENAqR5ECRxfSNFOLxHiNRT8PxVpYpW8qgE6FkN9RwzmFcEgtpdnnEnRJ8OqifFECCqMbfFkuVBXJPmTuATwrYQklOvHqhZeNjbzPK0ZmuwuX5OOi0hAfM2XxlzEHCl/M7CxyztHd9CtzG0z3fTqorrwsE2VTzi+lqbzuUWR+3NFo2uw8im3chctm/YgmQuDOOMl0NnID7MS44rTBAdMHqFZ25ZPhV2MrZnkYKQk3A23rk+yYNtfl3po4RwXrB9xY7d21Z9zEou2tU1HP3nHjUiYSwPnMw/Ju3se4pUcyRMLx+LPowkcbnr9w3lwdGg+yqucz5LlatAZ2Op/oVSh+bwo/mu+33JQS5NbE+/WU1SF1ZX7+rFaMrHyIifRfVTwzDukuE0MIreJHuzGzEZC3a40cCJMcHub+Ow3KXhPb5SoMZpQHjaWagqfB3Y4fZWZQhQP1aJiv38xRQ8p+gBhrMYygn9x+uGHZFJP1RS0QxryUE2nZMrckg1NshPk6
 WkIHDZNr
 YaQMmz9GzHcN1bQx2S6jwUjjMybq6P3/vh20XxPY1SBeFcVpTjpFd9p/h4RyqhG/KjZTL82PYn/g8Ot7w6pQePc3ZrZ05+4jzyKJuuBA8q79TIDdG+2rPVuJm3i55wDduV0Ly8dZADtAlrOWby8nQqVdLxwJOVrC68ovMwmMg5AkmC2mQrrYf0ajFbEtzkXxplPxux7GaBm20pMn4LUK/ZKEPsF/8oSOboggpo1rvW3GHMvnP3q72oIdhncC14kzsM+WWLE76KhBed4v7ZeJId0Vx7hyk/qln5X1wtbrErxq1qN7aflOPcWCClvsmgVN5XN2R/EmwlClm1TSCDJdfnkDwzzM07MTXitL+I7qeoUNlrvLRPVU1FT0Bqroy6EVt/WaGctiyZXpAwJ0S1HqlYBvoCgVc4qkfjTnEPf/BJF6OSpJezm+cVE6jQxjqyvYIV0EHagJrB97/1jFSZa8IYqSDfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_DC0F39B8-148E-4EDD-86B5-1A6F95887C3B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi,

>=20
>> Vmemmap page allocation is currently tied to restoring a virtual =
range
>> and assumes an empty destination list.  These constraints prevent it =
from
>> being reused when pages are requested independently of a vmemmap =
range or
>> appended to an existing list.
>>=20
>> Generalize the allocator and give it an all-or-nothing list contract =
so
>> the restore and optimization paths can share the same allocation =
policy.
>> This also allows HVO head-page allocation to fail gracefully under =
memory
>> pressure without triggering the OOM killer.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v2:
>> - Collect Reviewed-by from Lance Yang and Qi Zheng
>> ---
>> mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
>> 1 file changed, 18 insertions(+), 21 deletions(-)
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 0e5b2b182d1bf..4b20a8efc0678 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long =
start, unsigned long end,
>> 	return ret;
>> }
>>=20
>> -static int alloc_vmemmap_page_list(unsigned long start, unsigned =
long end,
>> -				   struct list_head *list)
>> +static int alloc_vmemmap_page_list(struct list_head *head, unsigned =
int nr_pages,
>> +				   int nid)
>=20
> Please indent with two tabs, like David likes :)
> Applies throughout the series.

Sure. Should we update scripts/checkpatch.pl in the future for MM,
since this script seems to favor the alignment approach?

>=20
>> {
>> -	gfp_t gfp_mask =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL;
>> -	unsigned long nr_pages =3D (end - start) >> PAGE_SHIFT;
>> -	int nid =3D page_to_nid((struct page *)start);
>> -	struct page *page, *next;
>> -	int i;
>> +	LIST_HEAD(local);
>=20
> Can we use a better name here please? E.g new_pages?

Yeah, make sense.

>=20
>>=20
>> -	for (i =3D 0; i < nr_pages; i++) {
>> -		page =3D alloc_pages_node(nid, gfp_mask, 0);
>> -		if (!page)
>> -			goto out;
>> -		list_add(&page->lru, list);
>> +	for (unsigned int i =3D 0; i < nr_pages; i++) {
>> +		struct page *page;
>> +
>> +		page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
>> +		if (!page) {
>=20
> I think goto err_do_cleanup is cleaner than ad-hok cleanups

I=E2=80=99ll use goto style. Either is OK for me.

>=20
>> +			memmap_pages_add(i);
>=20
> This is confusing. Updating counters only to use
> free_vmemmap_page_list() seems worse choice than walking the list and
> __free_page().

I think the memmap accounting should be done right after each successful
allocation =E2=80=94 that way, using free_vmemmap_page_list() becomes =
more natural
and simple.

Somthing like:

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index c04f53f708d2..cab9ec14873d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -207,14 +207,13 @@ static int alloc_vmemmap_page_list(struct =
list_head *head, unsigned int nr_pages
=20
                page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);
                if (!page) {
-                       memmap_pages_add(i);
                        free_vmemmap_page_list(&local);
                        return -ENOMEM;
                }
+               memmap_pages_add(1);
                list_add(&page->lru, &local);
        }
        list_splice(&local, head);
-       memmap_pages_add(nr_pages);
=20
        return 0;
 }

Thanks for your review, Mike.

Muchun


>=20
> --=20
> Sincerely yours,
> Mike.


--Apple-Mail=_DC0F39B8-148E-4EDD-86B5-1A6F95887C3B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><div dir=3D"auto" style=3D"overflow-wrap: =
break-word; -webkit-nbsp-mode: space; line-break: =
after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Nov 2, 2026, at 18:18, Mike Rapoport =
&lt;rppt@kernel.org&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Hi Muchun,</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Hi,</div><br><blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">Vmemmap page =
allocation is currently tied to restoring a virtual range<br>and assumes =
an empty destination list. &nbsp;These constraints prevent it =
from<br>being reused when pages are requested independently of a vmemmap =
range or<br>appended to an existing list.<br><br>Generalize the =
allocator and give it an all-or-nothing list contract so<br>the restore =
and optimization paths can share the same allocation policy.<br>This =
also allows HVO head-page allocation to fail gracefully under =
memory<br>pressure without triggering the OOM =
killer.<br><br>Signed-off-by: Muchun Song =
&lt;songmuchun@bytedance.com&gt;<br>Reviewed-by: Lance Yang =
&lt;lance.yang@linux.dev&gt;<br>Reviewed-by: Qi Zheng =
&lt;qi.zheng@linux.dev&gt;<br>---<br>v2:<br>- Collect Reviewed-by from =
Lance Yang and Qi Zheng<br>---<br>mm/hugetlb_vmemmap.c | 39 =
++++++++++++++++++---------------------<br>1 file changed, 18 =
insertions(+), 21 deletions(-)<br><br>diff --git a/mm/hugetlb_vmemmap.c =
b/mm/hugetlb_vmemmap.c<br>index 0e5b2b182d1bf..4b20a8efc0678 =
100644<br>--- a/mm/hugetlb_vmemmap.c<br>+++ b/mm/hugetlb_vmemmap.c<br>@@ =
-334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long start, =
unsigned long end,<br><span class=3D"Apple-tab-span" style=3D"white-space:=
 pre;">	</span>return ret;<br>}<br><br>-static int =
alloc_vmemmap_page_list(unsigned long start, unsigned long =
end,<br>-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;struct =
list_head *list)<br>+static int alloc_vmemmap_page_list(struct list_head =
*head, unsigned int nr_pages,<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;int =
nid)<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">Please indent with two tabs, like David =
likes :)</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">Applies throughout the series.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Sure. Should we update =
scripts/checkpatch.pl in the future for MM,</div><div>since this script =
seems to favor the alignment approach?</div><br><blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">{<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>gfp_t =
gfp_mask =3D GFP_KERNEL | __GFP_RETRY_MAYFAIL;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>unsigned =
long nr_pages =3D (end - start) &gt;&gt; PAGE_SHIFT;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>int nid =3D=
 page_to_nid((struct page *)start);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>struct page *page, =
*next;<br>-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>int i;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>LIST_HEAD(local);<br></blockquote><br style=3D"caret-color:=
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
display: inline !important;">Can we use a better name here please? E.g =
new_pages?</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Yeah, make =
sense.</div><br><blockquote type=3D"cite"><div><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>for (i =3D =
0; i &lt; nr_pages; i++) {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>page =3D alloc_pages_node(nid, =
gfp_mask, 0);<br>-<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>if (!page)<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>goto out;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>list_add(&amp;page-&gt;lru, list);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>for =
(unsigned int i =3D 0; i &lt; nr_pages; i++) {<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>struct =
page *page;<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (!page) {<br></blockquote><br =
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
display: inline !important;">I think goto err_do_cleanup is cleaner than =
ad-hok cleanups</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>I=E2=80=99ll use goto =
style. Either is OK for me.</div><br><blockquote type=3D"cite"><div><br =
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
-webkit-text-stroke-width: 0px; text-decoration: none;">+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>memmap_pages_add(i);<br></blockquote><br style=3D"caret-color: =
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
display: inline !important;">This is confusing. Updating counters only =
to use</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">free_vmemmap_page_list() seems worse choice =
than walking the list and</span><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">__free_page().</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>I think the memmap =
accounting should be done right after each =
successful</div><div>allocation =E2=80=94 that way, using =
free_vmemmap_page_list() becomes more natural</div><div>and =
simple.</div><div><br></div><div>Somthing =
like:</div><div><br></div><div><div>diff --git a/mm/hugetlb_vmemmap.c =
b/mm/hugetlb_vmemmap.c</div><div>index c04f53f708d2..cab9ec14873d =
100644</div><div>--- a/mm/hugetlb_vmemmap.c</div><div>+++ =
b/mm/hugetlb_vmemmap.c</div><div>@@ -207,14 +207,13 @@ static int =
alloc_vmemmap_page_list(struct list_head *head, unsigned int =
nr_pages</div><div>&nbsp;</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; page =3D alloc_pages_node(nid, GFP_KERNEL | =
__GFP_RETRY_MAYFAIL, 0);</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; if (!page) {</div><div>- &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
memmap_pages_add(i);</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
free_vmemmap_page_list(&amp;local);</div><div>&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; return =
-ENOMEM;</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; }</div><div>+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
memmap_pages_add(1);</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; list_add(&amp;page-&gt;lru, &amp;local);</div><div>&nbsp; =
&nbsp; &nbsp; &nbsp; }</div><div>&nbsp; &nbsp; &nbsp; &nbsp; =
list_splice(&amp;local, head);</div><div>- &nbsp; &nbsp; &nbsp; =
memmap_pages_add(nr_pages);</div><div>&nbsp;</div><div>&nbsp; &nbsp; =
&nbsp; &nbsp; return =
0;</div><div>&nbsp;}</div><div><br></div><div>Thanks for your review, =
Mike.</div><div><br></div><div>Muchun</div><div><br></div><div><br></div><=
/div><blockquote type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, =
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
display: inline !important;">--<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
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
display: inline !important;">Sincerely yours,</span><br =
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
!important;">Mike.</span></div></blockquote></div><br></div></body></html>=

--Apple-Mail=_DC0F39B8-148E-4EDD-86B5-1A6F95887C3B--

