Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208B9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o8OgvbNU
Received: by kanga.kvack.org (Postfix)
	id 0E65D6B05B0; Mon, 16 Nov 2026 21:51:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097136B05B2; Mon, 16 Nov 2026 21:51:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA13C6B05B3; Mon, 16 Nov 2026 21:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B280A6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:51:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C8E3402CE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:51:03 +0000 (UTC)
X-FDA: 85443084006.15.D1476C7
Received: from mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22EE9C0003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:51:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8OgvbNU;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794883861;
	b=EyBpDByFPgMAgi0NKMIqZML8QSdagYBKTUIyYaUC+FJIxDsPmB96+K1P5GdBaRjnJoBhy7
	nqT2gTgQMM/r3YEItkMf865oMNhCqpfxez+l8J220+g4UqvQo9CMG2donJZt4EgEI0/Iqo
	eEwOPvcWFbrScrcWFFSEZArpUHsq0zE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o8OgvbNU;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794883861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J36ev77VPeG4gzASiB2toRs/InVHTTr2GXhsMpgCBJ8=;
	b=dU/igYXtCXA2Sej7sf5czNqYdMkQECkTsht2hEDIoKnf+p59Kv54vhDEsJx9lsG2CWK1CX
	g1yQAuS1QXhd8QFVOKpvIieZ5BW5MYm8bTuK68MgFMaRb/eM6cdd4mv8GsVf0jhj/ael7q
	+x7uwfdi5z5GdEfyU7U57c8cVsgeU5Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lYPss3gZ00+HEgf58I4TgLSVjUqDhD6A6d9akl0A8qw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794883859; v=1; x=1795488659;
 b=o8OgvbNUD0LLXaTPMck6rvqqU/G60WFers41Eg3PIoPB3KsF515Cr/+MjXVnrAi8ROrxw63J
 MqUT6ntqkKuoYnFIjifH8Rp8aVfcs8I2XmIrAlkAnjRb9ufHmzHvnQDcwTEhOkWcdgUNLTXh3i7
 yz0KRe405p+/wfCzooYZMlYQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 251577191161234f;
	Tue, 17 Nov 2026 02:50:59 +0000
X-Mizu-Trace-ID: 251577191161234f
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <B75F059B-0311-428E-BF0D-59D2BB1621BA@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_70210311-FE19-468E-9FD1-D86963289445"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 04/14] mm/mm_init: factor out common struct page
 initialization
Date: Tue, 17 Nov 2026 10:50:39 +0800
In-Reply-To: <179482576829.2379196.2091312590305150578.b4-review@b4>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
To: Mike Rapoport <rppt@kernel.org>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-5-songmuchun@bytedance.com>
 <179482576829.2379196.2091312590305150578.b4-review@b4>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 687n3r147tx4px9x8qf978wxckmq9wa1
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22EE9C0003
X-HE-Tag: 1794883860-113938
X-HE-Meta: U2FsdGVkX1/Wq9VO6q0rA6uZn3Tm5UynBmIeUNfpVWpe0o0coKUk4+EQoIuYlKPetF6ojCxNIGYZoWIa4NlqSfd2TblI7IjEE4ByLx+WWBnhx13h0jhlEQocQOm8O7lsBz2MGbkVUMYk3xdAmu9BY30SA7VYDwCz0dZhF/eFsoAs2NjmHFdwUIzICeMrKLiKju3zaUEiK82uaKSfJ/hxdcGGiPlyN6p4kAdgDNeQyOFcj5WhdCWVlx0xZsh5dH6Ud8CxNnMiz8xqb2MSzNULVzwjJ8M1WW3X8rE2ET7SMZ2650ztC9lvXj4TD+XeBik8FkOqEZmmJ3etSRw6BWGLhoUL+usaMMWZqUDGXAbEgg83YOxIHzmp1Nu7NcwbtxU7tDEpwcxJH3YrLtxoQENZCkOHjQS8gn0geAilXF8HFGdXO/XNuuxCRe2MLVG9zbjxJwZ5WqyRyj0iWvwjm37rua43pMWc7gKVTnBN8LkcSzw3kHsH8fwaiZ6hkFVRAaGtqfKrMQkd982rf6J9McUhovcEdrV2SFgu35Z5aOTYYYU4R+o/Gb0UVpSwZHVrUMmrOuloiQcKtjGZxefEoj/AF3f7b0/0zfXTTVpNOZ370F78TM8j6tDLiNb4ju8LaPoywxyyK31OoTyFFF9PKEBiTh0CMd5E44E3sv9w7uvTbC/6cfQVG8WKEtjwYq85G13W13WIp1/ekSkSNvoPHqr5TWtcObwB5nnQC+dzI/24R+if2p5B4YJJi+c3acH7pBJHVWekOaRsBJR+WtzovM8QP8sP43hloFI1wkqTNj1WlS6z0IhEwfBUrGafEPYJCEZljkeDVXmOs64AHj+UYGgxlgwTcdAUhkiFbhZR/VMqHS12dPsA3Vs9plu+HEwLSGfgt8ZZ1CLbvYb+gF/fOqyWN9jV9YtVLT0QtvwlAFQ1JkZxqnUkZA713kk+c0J8nBkWeeW2XqlVuKPQj/BGZDp
 931f9FCq
 NyJftj/h3oiyEn653FQHGdz9g4V014ogMkFvgTCcM97WqdtbH9arfJxSIo6EQlsdejBupJikxUI8g2S7TJmpeIavcIe86qWV/bH1p1eR9g7kCAo9KlernIgSpoA5GHGnZRon1hJOW9WGkYt8HeQu6Ytdm7xuMwIrYDTxmp1/FJhYulkDkjOvAQ2+W4EMo3oPaICvSJodL32NQiToz/NDkpit8/04fOk8G3NWWj1yzGLekbaMxEZJFCMTKKyYruYBDgH/4pXp9bR8nsAIwVwnxg4B5IIItpI+jWfynZLHsmupfwXI5Xqtnx/GqdGtgEY9XD7v+nEn0BvdPXvQIbOMi+GBNik9woq3b/Xdtg4xCohQW2JxA3lxQaRwtJo6iYpi8bsn5G6Rv03kkcVIykSsezGbWiafRZpzGG3zjTBXP7AXuIye68mj/Qqwpi+hd/X9270wGJw1LucUgLe/N7yxplSDrQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_70210311-FE19-468E-9FD1-D86963289445
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 16, 2026, at 18:42, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi,

Hi Mike,

>=20
>> Several struct page fields have the same initial values for every =
page in
>> a zone. __init_single_page() initializes this state as part of its
>> per-page setup, while the shared vmemmap tail path open-codes only a
>> subset.
>>=20
>> Factor the PFN-independent state into memmap_init_page_common() and =
use
>> it for both regular and shared tail struct pages. Keep section-, PFN-
>> and instance-specific initialization in __init_single_page().
>>=20
>> This also initializes the last cpupid and KASAN tag for shared tail
>> struct pages consistently with regular struct pages.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> v2:
>> - Remove __meminit from memmap_init_page_common() so HVO shared tail
>>  pages can call it after init text is freed (reported by Sashiko).
>> ---
>> include/linux/mm.h  |  8 --------
>> mm/mm_init.c        | 22 +++++++++++++++++-----
>> mm/mm_init.h        |  1 +
>> mm/sparse-vmemmap.c |  7 +------
>> 4 files changed, 19 insertions(+), 19 deletions(-)
>>=20
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 77b5d450fe45b..2e182498898ec 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3022,14 +3022,6 @@ static inline void set_page_node(struct page =
*page, unsigned long node)
>> 	page->flags.f |=3D (node & NODES_MASK) << NODES_PGSHIFT;
>> }
>>=20
>> -static inline void set_page_links(struct page *page, enum zone_type =
zone,
>> -	unsigned long node, unsigned long pfn)
>> -{
>> -	set_page_zone(page, zone);
>> -	set_page_node(page, node);
>> -	set_page_section_from_pfn(page, pfn);
>> -}
>> -
>> /**
>>  * folio_nr_pages - The number of pages in the folio.
>>  * @folio: The folio.
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index af3b81733193b..d0a11989bd249 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -602,15 +602,27 @@ static inline void =
vmemmap_optimization_verify_zone(struct page *page)
>> 			page_zone_id(page));
>> }
>>=20
>> -void __meminit __init_single_page(struct page *page, unsigned long =
pfn,
>> -				unsigned long zone, int nid)
>> +/* Initialize PFN-independent fields common to pages in the same =
zone. */
>> +void memmap_init_page_common(struct page *page, enum zone_type zone, =
int nid)
>=20
> I don't think _common adds much here, memmap_init_page() would do.

Naming is difficult. I'm fine with memmap_init_page.

>=20
>> {
>> 	mm_zero_struct_page(page);
>> -	set_page_links(page, zone, nid, pfn);
>> -	init_page_count(page);
>> -	atomic_set(&page->_mapcount, -1);
>> +	set_page_zone(page, zone);
>> +	set_page_node(page, nid);
>> 	page_cpupid_reset_last(page);
>> 	page_kasan_tag_reset(page);
>> +	atomic_set(&page->_mapcount, -1);
>> +#ifdef CONFIG_ZONE_DEVICE
>> +	if (zone =3D=3D ZONE_DEVICE)
>> +		__SetPageReserved(page);
>> +#endif
>=20
> Can't we keep this in ZONE_DEVICE part?

We can. But I put it here because there are at least two places where
we need to mark a ZONE_DEVICE page as reserved. Handling it in
memmap_init_page_common is simpler =E2=80=94 it reduces the number of =
places
where we have to set reserved individually. Otherwise, we would need
to explicitly set reserved in multiple places.

>=20
> If we can't, __init_single_page() sets PG_reserved for ZONE_DEVICE =
pages
> and the
>=20
> if (zone =3D=3D ZONE_DEVICE)
> 	__SetPageReserved(page);
>=20
> in the MEMINIT_HOTPLUG part of memmap_init_range() becomes redundant.

Good catch. I think I could remove this redundancy next version if you
think handing it in memmap_init_page_common is okay.

Thanks,
Muchun

>=20
> --=20
> Sincerely yours,
> Mike.


--Apple-Mail=_70210311-FE19-468E-9FD1-D86963289445
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Nov 16, 2026, at 18:42, Mike Rapoport =
&lt;rppt@kernel.org&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Hi,</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Hi =
Mike,</div><br><blockquote type=3D"cite"><div><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">Several struct =
page fields have the same initial values for every page in<br>a zone. =
__init_single_page() initializes this state as part of its<br>per-page =
setup, while the shared vmemmap tail path open-codes only =
a<br>subset.<br><br>Factor the PFN-independent state into =
memmap_init_page_common() and use<br>it for both regular and shared tail =
struct pages. Keep section-, PFN-<br>and instance-specific =
initialization in __init_single_page().<br><br>This also initializes the =
last cpupid and KASAN tag for shared tail<br>struct pages consistently =
with regular struct pages.<br><br>Signed-off-by: Muchun Song =
&lt;songmuchun@bytedance.com&gt;<br>---<br>v2:<br>- Remove __meminit =
from memmap_init_page_common() so HVO shared tail<br>&nbsp;pages can =
call it after init text is freed (reported by =
Sashiko).<br>---<br>include/linux/mm.h &nbsp;| &nbsp;8 =
--------<br>mm/mm_init.c &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 22 =
+++++++++++++++++-----<br>mm/mm_init.h =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;1 =
+<br>mm/sparse-vmemmap.c | &nbsp;7 +------<br>4 files changed, 19 =
insertions(+), 19 deletions(-)<br><br>diff --git a/include/linux/mm.h =
b/include/linux/mm.h<br>index 77b5d450fe45b..2e182498898ec 100644<br>--- =
a/include/linux/mm.h<br>+++ b/include/linux/mm.h<br>@@ -3022,14 +3022,6 =
@@ static inline void set_page_node(struct page *page, unsigned long =
node)<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>page-&gt;flags.f |=3D (node &amp; NODES_MASK) &lt;&lt; =
NODES_PGSHIFT;<br>}<br><br>-static inline void set_page_links(struct =
page *page, enum zone_type zone,<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>unsigned long node, unsigned long =
pfn)<br>-{<br>-<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>set_page_zone(page, zone);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_page_node(page, node);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_page_section_from_pfn(page, =
pfn);<br>-}<br>-<br>/**<br>&nbsp;* folio_nr_pages - The number of pages =
in the folio.<br>&nbsp;* @folio: The folio.<br>diff --git a/mm/mm_init.c =
b/mm/mm_init.c<br>index af3b81733193b..d0a11989bd249 100644<br>--- =
a/mm/mm_init.c<br>+++ b/mm/mm_init.c<br>@@ -602,15 +602,27 @@ static =
inline void vmemmap_optimization_verify_zone(struct page *page)<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>page_zone_id(page));<br>}<br><br>-void __meminit =
__init_single_page(struct page *page, unsigned long pfn,<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>unsigned =
long zone, int nid)<br>+/* Initialize PFN-independent fields common to =
pages in the same zone. */<br>+void memmap_init_page_common(struct page =
*page, enum zone_type zone, int nid)<br></blockquote><br =
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
display: inline !important;">I don't think _common adds much here, =
memmap_init_page() would do.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Naming is difficult. I'm =
fine with memmap_init_page.</div><br><blockquote type=3D"cite"><div><br =
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
-webkit-text-stroke-width: 0px; text-decoration: none;">{<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>mm_zero_struct_page(page);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_page_links(page, zone, nid, =
pfn);<br>-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>init_page_count(page);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>atomic_set(&amp;page-&gt;_mapcount, -1);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>set_page_zone(page, zone);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>set_page_node(page, =
nid);<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>page_cpupid_reset_last(page);<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>page_kasan_tag_reset(page);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	=
</span>atomic_set(&amp;page-&gt;_mapcount, -1);<br>+#ifdef =
CONFIG_ZONE_DEVICE<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (zone =3D=3D =
ZONE_DEVICE)<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>__SetPageReserved(page);<br>+#endif<br></blockquote><br =
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
display: inline !important;">Can't we keep this in ZONE_DEVICE =
part?</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>We can. But I put it here =
because there are at least two places where</div><div>we need to mark a =
ZONE_DEVICE page as reserved. Handling it =
in</div><div>memmap_init_page_common is simpler =E2=80=94 it reduces the =
number of places</div><div>where we have to set reserved individually. =
Otherwise, we would need</div><div>to explicitly set reserved in =
multiple places.</div><br><blockquote type=3D"cite"><div><br =
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
display: inline !important;">If we can't, __init_single_page() sets =
PG_reserved for ZONE_DEVICE pages</span><br style=3D"caret-color: rgb(0, =
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
display: inline !important;">and the</span><br style=3D"caret-color: =
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
display: inline !important;">if (zone =3D=3D ZONE_DEVICE)</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: pre; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;">	=
</span><span style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">__SetPageReserved(page);</span><br =
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
display: inline !important;">in the MEMINIT_HOTPLUG part of =
memmap_init_range() becomes redundant.</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Good catch. I think I =
could remove this redundancy next version if you</div><div>think handing =
it in memmap_init_page_common is =
okay.</div><div><br></div><div>Thanks,</div><div>Muchun</div><br><blockquo=
te type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); =
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
!important;">Mike.</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_70210311-FE19-468E-9FD1-D86963289445--

