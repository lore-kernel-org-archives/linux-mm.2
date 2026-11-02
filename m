Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA4A4606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gQkuZo0J
Received: by kanga.kvack.org (Postfix)
	id CAE156B05BE; Mon,  2 Nov 2026 06:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37B46B05C1; Mon,  2 Nov 2026 06:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26D76B05C7; Mon,  2 Nov 2026 06:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D9F06B05BE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D777A0C4E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:51 +0000 (UTC)
X-FDA: 85389961902.20.EB4B398
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id D6F22A000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQkuZo0J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KsuSSSsxD3YbZP/yKFBKTQlRuo5uz+LJ8kNZ6qxTkA=;
	b=ontwTQ+AntGwPU+BYCxfW2559+UDj4qdH1TpDyU8R/WJtXYtPJwr2GKTaZsvYAqxtvh+aA
	znrloUkId38v5KlNPdFsnBvCs6B+meP03lczUcDk/TRqJyZ9sp3VBf2t9cbCjH4O86o+kn
	GNTRSMa974LjnzWHRa8A/C6wVG5+Z4g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gQkuZo0J;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619049;
	b=joIYRndOcivSZL2R89JTXHvQbkrcbjSlKWiKQY+/SdGJnPjGQeG+Sx4oGM8FOc8EPg99pl
	OeFGa+Gb9fTsfRd3/596H8t49n21q6bEIrVpMktuzpVW1wNVhFKMyHYQxvkIKeV8/e7HzM
	9iBbwL9fnoO5T8x7355XFMnIe3BLfU8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tNBisU1jDGaV5LYM3bdXrogdkDnLbwUWDMDBKdupMBU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793619047; v=1; x=1794223847;
 b=gQkuZo0JI3m86pQETUHqViBtRNUkM3cHwmmIdJslBDlVpod1/XlFyJXJXzZFvzrZhurZIzcS
 iGEFcWzgWMuqBRmRNIrAXwX4rhcOBSdIYtDyq+euhUOQBUuGyxvU+P5WnIF0zbPnigRE9ajHJRv
 WUa6F6ASYGk99VhRGpvyQNg8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4e70c995d35ab05e;
	Mon, 02 Nov 2026 11:30:47 +0000
X-Mizu-Trace-ID: 4e70c995d35ab05e
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <5822BD89-A433-4EFD-B335-2B6206E6583D@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_D525DC28-58C3-412A-922E-1CBFDF01DE76"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Mon, 2 Nov 2026 19:30:30 +0800
In-Reply-To: <179361471103.1337633.14353990207430443405.b4-review@b4>
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
 <20261102032525.3597743-3-songmuchun@bytedance.com>
 <179361471103.1337633.14353990207430443405.b4-review@b4>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: D6F22A000D
X-Stat-Signature: 4adcxb4mcz8jndgpfxbtkot989h46ey3
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793619048-855368
X-HE-Meta: U2FsdGVkX1/sWT0M/+aIRyIXfAn/KhYR7nkBYNitGGTNa4FDyQYx4nv9UI+DijiQG2iSeGU0yGGlCvaPrXMZY8UTeQwn0XfMnWmRnmyrw+KKU7exwOc73pRkVoKNLWF+VvucNcl4VjqlP0kL8zPrJRc+MGlQPmJTuYKsj/9PdS++S0PUGrFdjz1d2WtgN1tWHmN6UIzhSiN2Yq2ykOQOul8ALL2huMC55LBLNvjw2BDHbMZt3opkczOCBxKp8neJx1ltiH0jdD++dHn5e0X7Hyz2QetNo8JcE2qh5N6l8Gp4FMwSjYJtx+ZDwfq+cVjVuUEJwYjd5Csin1fPpyTCG4l4RKkpD47u8xVkQpF2XUhyl288GCg0BkslcPcnZ2j4+PSc9Jf5Xt8ra14DvsFfWIx+oCrtJc7IZXGIaRGmHIPD3civlS07nMg9a1HciPe8YqMtk+b6/Mm3Go3RsZrzPmb2yZIooT8QEaRqMo4jnpDwz/XV19m3lPUeX6lUCkC/yCuLUtYYg66LZcavHzFKjo4iuiUcGWoADBOnLvMbfUZC9XxL3J18UasO54UthFM+MVqu95AFlgBx5fUHCUAr1gyO7JT1JNZadV1Uz4+KMVXnMNhAkQgCJCi2h5g8/OCqAq1i2tZYwOi87LrBUocEfUKK0u+40BfsIRw/mLB4sM588Hvi0MfxLFbAL6CKXH0xWZRbOcye0HLKXxkYkMgaXvPvFyE4CEG+83P612HrzeXW1MwCFnZa1rcJFaeqqGZQy3B8evOudlnDVe9c5ilMPgtnz8aJCYzeTvqlN2g1qiqoU9rVA8fogbpyZ0zhtHX6GJMsvzmXMUReIxx5vIM7S5DO4iH05g/k3uC/VJNXAzO4gaZ/7qREEr8olYZOBFmAS3bOs3L8/624quGiRJ1CDhkAfhwEBFmgfcQAVARTrlanXkhb/4poTEFekriGGxGtd/IYFuy+QrryFCWw8oh
 QHf9wBnA
 ZSMi2JBddUoL+MZ8Sp13MSaggQqWfPZl74GqS1jFwrgZSM+8BvxBwzpl0+6fyaBhcqMgwyyPBY2HcXFp0MSp1NO5wuxZfi346k4vWUyQbtArbT80v9lHBLqVUHIniB+Y2JrgT2+Hg+7JO/wqVMAe8qZT6rBT6WZg69aHEmLaKFodsyb0mzEPYuqoqwZFFXW9QivB+EcblEzJYKnPJK4qOaUaWFr4tUIdlFlFKL25WkiWxVrOw740HKjTVjrsn6NCoLtT/SwqG+9PTyWeI0GQiGqUkrWZDM37HV6Y7NBBcUiFIMYaaSPdLl4VMq2h1T2tYX7RGYSuhJODoqMT4O/M4dyq9AjBzztB+zqbKYM4IYtPaaLgE8dRjIAFUdXmyLHXd3/gquJsltUbUAkSyR0/mTZWSb11zOg3OBrqErbiRurpoTK6X6M+XSYi0PwznCd1NXt03BcJ+PoGq+Ho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_D525DC28-58C3-412A-922E-1CBFDF01DE76
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8



> On Nov 2, 2026, at 18:18, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi Mike,

>=20
>> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
>> describe fully independent choices. A split-only walk can defer the
>> PMD-split flush to a later global flush, and a remap-only walk can
>> defer the final remap flush. However, when a PMD split is followed
>> by PTE remapping, the split flush must happen before the PTEs are
>> changed, because stale large-page translations must not overlap with
>> new small-page translations that map different physical pages.
>>=20
>> Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
>> new name reflects that only safely batchable flushes are deferred. =
Keep
>> split-only walks able to defer the flush, but force the split flush
>> whenever a remap_pte callback is present. Callers that batch HVO work
>> can still defer the final remap flush and issue their own global =
flush.
>>=20
>> Current callers keep the same flushing behavior.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v2:
>> - Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
>>  comment (suggested by Qi Zheng)
>> - Update the commit message for the new flag name
>> - Collect Reviewed-by from Lance Yang and Qi Zheng
>> ---
>> mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
>> 1 file changed, 13 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 4b73d6ec8dcea..63e899cfaac3a 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>> 	struct list_head	*vmemmap_pages;
>>=20
>>=20
>> -/* Skip the TLB flush when we split the PMD */
>> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
>> -/* Skip the TLB flush when we remap the PTE */
>> -#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
>> +/* Defer safely batchable TLB flushes to the caller. */
>> +#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
>> 	unsigned long		flags;
>> };
>>=20
>> @@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct =
page *head, unsigned long start,
>> 		/* Make pte visible before pmd. See comment in =
pmd_install(). */
>> 		smp_wmb();
>> 		pmd_populate_kernel(&init_mm, pmd, pgtable);
>> -		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
>> +		/*
>> +		 * Modern MMUs allow overlapping TLB entries with =
different mapping
>> +		 * granularities only if they map the same physical =
address. So
>> +		 * remapping must not proceed without first flushing the =
TLB.
>=20
> Are we certain that *all* modern MMUs for *all* architecures that=20
> support hugetlb are fine with skipping TLB flush after a split?

I think this is the case on architectures that currently enable
ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP. Of course, the point I want to
further clarify is that the "skip" action here is not really a skip,
but rather a "defer"=E2=80=94the TLB is subsequently flushed in a single =
batch.

Thanks for your review.

Muchun.

>=20
> AFAIU, x86::set_memory always flushes TLBs after a large leaf is =
split.
>=20
> --=20
> Sincerely yours,
> Mike.


--Apple-Mail=_D525DC28-58C3-412A-922E-1CBFDF01DE76
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=utf-8

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dutf-8"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
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
-webkit-text-stroke-width: 0px; text-decoration: =
none;">VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do =
not<br>describe fully independent choices. A split-only walk can defer =
the<br>PMD-split flush to a later global flush, and a remap-only walk =
can<br>defer the final remap flush. However, when a PMD split is =
followed<br>by PTE remapping, the split flush must happen before the =
PTEs are<br>changed, because stale large-page translations must not =
overlap with<br>new small-page translations that map different physical =
pages.<br><br>Replace the two flags with a single =
VMEMMAP_DEFER_TLB_FLUSH flag. The<br>new name reflects that only safely =
batchable flushes are deferred. Keep<br>split-only walks able to defer =
the flush, but force the split flush<br>whenever a remap_pte callback is =
present. Callers that batch HVO work<br>can still defer the final remap =
flush and issue their own global flush.<br><br>Current callers keep the =
same flushing behavior.<br><br>Signed-off-by: Muchun Song =
&lt;songmuchun@bytedance.com&gt;<br>Reviewed-by: Lance Yang =
&lt;lance.yang@linux.dev&gt;<br>Reviewed-by: Qi Zheng =
&lt;qi.zheng@linux.dev&gt;<br>---<br>v2:<br>- Rename the unified flag to =
VMEMMAP_DEFER_TLB_FLUSH and update its<br>&nbsp;comment (suggested by Qi =
Zheng)<br>- Update the commit message for the new flag name<br>- Collect =
Reviewed-by from Lance Yang and Qi Zheng<br>---<br>mm/hugetlb_vmemmap.c =
| 23 +++++++++++++----------<br>1 file changed, 13 insertions(+), 10 =
deletions(-)<br><br>diff --git a/mm/hugetlb_vmemmap.c =
b/mm/hugetlb_vmemmap.c<br>index 4b73d6ec8dcea..63e899cfaac3a =
100644<br>--- a/mm/hugetlb_vmemmap.c<br>+++ b/mm/hugetlb_vmemmap.c<br>@@ =
-42,10 +42,8 @@ struct vmemmap_remap_walk {<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>struct =
list_head<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>*vmemmap_pages;<br><br><br>-/* Skip the TLB flush when we split =
the PMD */<br>-#define VMEMMAP_SPLIT_NO_TLB_FLUSH<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>BIT(0)<br>-/* Skip the TLB flush when we remap the PTE =
*/<br>-#define VMEMMAP_REMAP_NO_TLB_FLUSH<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>BIT(1)<br>+/* Defer safely =
batchable TLB flushes to the caller. */<br>+#define =
VMEMMAP_DEFER_TLB_FLUSH<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>BIT(0)<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>unsigned =
long<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>flags;<br>};<br><br>@@ -85,7 +83,12 @@ static int =
vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long =
start,<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>/* Make pte visible before pmd. See comment in pmd_install(). =
*/<br><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>smp_wmb();<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>pmd_populate_kernel(&amp;init_mm, pmd, =
pgtable);<br>-<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>if (!(walk-&gt;flags &amp; =
VMEMMAP_SPLIT_NO_TLB_FLUSH))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>/*<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* Modern MMUs allow =
overlapping TLB entries with different mapping<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* granularities only if =
they map the same physical address. So<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* remapping must not =
proceed without first flushing the TLB.<br></blockquote><br =
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
display: inline !important;">Are we certain that *all* modern MMUs for =
*all* architecures that<span =
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
display: inline !important;">support hugetlb are fine with skipping TLB =
flush after a split?</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>I think this is the case =
on architectures that currently =
enable</div><div>ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP. Of course, the =
point I want to</div><div>further clarify is that the "skip" action here =
is not really a skip,</div><div>but rather a "defer"=E2=80=94the TLB is =
subsequently flushed in a single batch.</div><div><br></div><div>Thanks =
for your review.</div><div><br></div><div>Muchun.</div><br><blockquote =
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
display: inline !important;">AFAIU, x86::set_memory always flushes TLBs =
after a large leaf is split.</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
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

--Apple-Mail=_D525DC28-58C3-412A-922E-1CBFDF01DE76--

