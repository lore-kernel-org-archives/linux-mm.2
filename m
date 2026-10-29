Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E270606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hAWswFu+
Received: by kanga.kvack.org (Postfix)
	id 93EFE6B00EF; Thu, 29 Oct 2026 01:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916326B05B1; Thu, 29 Oct 2026 01:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BEE6B05B2; Thu, 29 Oct 2026 01:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 509226B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:31:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 92AB9801F0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:31:40 +0000 (UTC)
X-FDA: 85374541560.27.0B34E53
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36F1B180002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:31:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hAWswFu+;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793251898;
	b=MLmHBZ7YcsmQ3XMwN9WIxqQbSINjbEdc0OP/6oz7yXmVBrUtsQTlyWZtubvd+2UpZrOsAt
	IIcmnkPXEpdMm/UvKxXeimVEvQ2KPbtNybr6voJRmsCCDdflRn0bgYro6a/zvVKD+KL5jP
	OxBOdqDyN6TnlWVV6crTDI3EExdxQeI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hAWswFu+;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793251898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tbgBF2W836fRB/7YzfDNJKz5e9sNw+Vz2JnqiTb3oY=;
	b=hsYRoleEHl8ePW74EG7RpMBY3CbqS6M/PpkKWUj66wGJo8SOZnTpk+pkOGjBVUF/4DF58u
	HQqz2IdM0+T0iopmyaumgJE1ANp0eZRzpb7x28wkF7TgW+cNhMnrEU1nRm6bQs1XbOcqE6
	NfPZcrHtzWJPNiwh7VsRTXgaPxVtZ1I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1eQbS6jy9kfUwiggkZ0ltjPq9T+Kn4keWIoG2Nn0X+8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793251896; v=1; x=1793856696;
 b=hAWswFu+Ce41nCFxaWasktczYjBq/ePADb+lXdknywW/5FlOJ/0s3qbKAOeuPsK7y8559ewt
 YqMHFRUf/aJQdEGuUzAD8chqVqn7liN0JSlw+UrfJjsBZzSB6kps2gvDijA6FGwH2fFzX+Q6mHS
 IpFxnVQn/ZEDg9lGMMNDUrnc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 90d9593f77c07bc5;
	Thu, 29 Oct 2026 05:31:36 +0000
X-Mizu-Trace-ID: 90d9593f77c07bc5
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <ED2AFFDD-AB2C-4585-A2D9-4FECD65F9BA6@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_159BC117-16BC-4700-9733-15883B67FDDC"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/2] powerpc/64s/radix: don't dedup vmemmap covered by an
 existing PMD leaf
Date: Thu, 29 Oct 2026 13:31:17 +0800
In-Reply-To: <ik2lw4gc.ritesh.list@gmail.com>
Cc: linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Christophe Leroy <chleroy@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 David Hildenbrand <david@kernel.org>,
 Pavithra <pavrampu@linux.ibm.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
References: <97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com>
 <2C88EF3C-1E7D-4395-99C5-711FFB01469A@linux.dev>
 <ik2lw4gc.ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Stat-Signature: puhjc4fs6cydoiiknnmwtktxp6mtqy1o
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 36F1B180002
X-Rspam-User: 
X-HE-Tag: 1793251898-537802
X-HE-Meta: U2FsdGVkX18DKf70Ze5wDRlYLEEBv03shrUtzRxr8y3NjSRiZLiBo0EZRKSDXtkuvHDs/Z7yP635Ob3P4Ou0T5dPzquBkNMwWvSL0w9rKkv1UEcJGvzIgIcNem99MJ1hTYToOFC0KxaqZG5aAAqymY9sFMLnLUF+ZwFoYBMSB4F390lFZxxDcmMREYR4jTMDIMezKkrAo0eMBbyxFlME89QLJ77qKxEZH5KldAe7rPkO8bhpN2f3CK7wZX76lfDqj+Vvtlm0hlUnP5f2GjiUnyqPiBZnFoq3cuaQaEIUCF4RuoT5NxrH24bM6RAOyJh22RstoC88N6MTg+s5BBSOI9LQdkyeBn0JA8LXdsfURdcyGfEMvwtjAvxKYEqZ+PteG/VHlbTq1AFrSsXB4qI25bZD2HmiB33F2XiK1f4kt8zvBecC0ovy8BFz0UQrLx2PldkJsqrYRXR/2gaHvfzjAljR6IHciGb91vS9dTznKqNR5BM77BDFmuLiDwPpSVudawq4c8oM/8Sjn5tp5/UGekRluJvj345OFuuITI0b7vSqGq02Jk4epm3DMPTRmk2wsdPOieyuWtFmV3C5eZdBRqEvCiFJuv+T1NltvWg8JN4a1tlMOs+6Y0BCd7yHLMgW2nY2GrLqehbzSWkjTZJ7BexChXCY0n14YbLNDs/ADxXCZB8MtROj9zJS6AvIRxOQD3o3nbNFa9CY71x1SZpMdqbxEdJiFNlFasi3HcSuNT/LdJyCrufs3PwKLnNyki7yqO0XQ3/GfcvJy70XFuh6EXlxcX6AFK7wuZhTVmGiuLiW+OCqaawQGFO1D0cxv1GuVwrky3DO0B9YgeI4vn89XTdM5/DZzdqobVHIKma7ZwbuEj1v6jF2kn7gRWWvqdqJnTCHzNnHmZ/P0cXBcCF8X/JHfPszOIHnWJbkRddWp2afo2a4aBZQaiEoq7r7LaBh0aT5OD2lw2zHA/rYZEv
 RUDmOn1o
 Ymhgz4AF5iPDH2SWzg31a6gcC+ohgXAzBveSai0DVOIZTXW2cH1/Wea1DtIMHcBjqXMpvJU6kYI3WfyeTYIzG3+9WcqSGSk3qo641IhsqMagKIJIbumlYZsmm5Hi1c3FRz4tx7PkU0JybXu8qYwV0jlOj/MsAzfIlXiusljC68X847YvtAbNNpmRzaszOKDy+LrdQrKkqfo/9A7QMJCLL0zYkrPDibUqLLQ/SPAZaLKpvHeklcxIpd2brqx8hg4a2pJ5ZpuENRetVdwGWvogi0WcCxCxP53bh577GMccaM9KZjvcInxkcP+MqluBw3MD5umuqcQsLLCok4/Jx0jyoLVRMtqXi1/Cpv5uL+NWQxIZHUQlQUcAeGqEXMUlnT7pojC/NWHE1KmjUSygAdPi2//30Et0x69UWq3Ccs/uJybODu16VrePAyO93SlBCHU3WI10+lUUB5DkeQYh5KW+C4tpPRyH2T41tq4xWPRF4vAHblhjjVh4UQFUuTofqqgwwPcRL4nLzWAVK2Ppw5Ui2cZjOxmvnAU2LgcgN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_159BC117-16BC-4700-9733-15883B67FDDC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Oct 29, 2026, at 11:50, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Muchun Song <muchun.song@linux.dev <mailto:muchun.song@linux.dev>> =
writes:
>=20
>> Hi Ritesh,
>>=20
>>> On Oct 27, 2026, at 11:22, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>>>=20
>>> radix__vmemmap_populate() is asked for one 16MB section, which is =
16KB of
>>> struct pages. With no altmap it rounds the request down to a PMD =
leaf.
>>> That leaf describes 2GB of PFNs with 64KB pages (128MB with 4KB =
pages),
>>> so it also covers sections that are not present yet. It cannot be =
freed
>>> while any of those sections are still in use.
>>>=20
>>> A devdax namespace that lands in the same window is marked for =
vmemmap dedup.
>>> vmemmap_populate_compound_pages() treated the leaf as an existing =
huge mapping
>>> and skipped it. The core then initializes only the head vmemmap page =
and assumes
>>> the rest is the shared tail. Those remaining tail slots are real =
struct pages
>>> still holding the page_init_poison() pattern and are not the shared =
tail pages.
>>=20
>> Right.
>>=20
>>> __init_single_page() warns on the zone mismatch and the following =
pageblock init
>>> faults in __set_pfnblock_flags_mask().
>>=20
>> Yeah, the new adding warning is useful.
>>=20
>>>=20
>>> If the section's vmemmap is already a PMD leaf, clear its compound =
order
>>=20
>> I think it's enough to fix this issue.
>>=20
>=20
> Oh yes, right! since the page init is done later and the optimizable
> order can be read from mem_section.
>=20
>>> and reuse the leaf, so every struct page in the section is =
initialized.
>>> The shared-tail layout needs base-page PTEs, so it cannot be built =
on top of
>>> this leaf and dropping the leaf is not an option while the =
neighbouring range
>>> is still using it. So, fail the compound populate if a leaf is still =
seen there.
>>>=20
>>> <Call Trace>
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> [    3.467060][    T1] WARNING: mm/mm_init.c:600 at =
__init_single_page+0xd0/0xf4, CPU#0: swapper/0/1
>>> <...>
>>> [    3.477419][    T1] NIP [c000000000576b30] =
__init_single_page+0xd0/0xf4
>>> [    3.477827][    T1] LR [c0000000005778b0] =
__init_zone_device_page+0x30/0xb8
>>> [    3.478444][    T1] Call Trace:
>>> [    3.478764][    T1]  0x10000 (unreliable)
>>> [    3.479874][    T1]  memmap_init_zone_device+0x164/0x430
>>> [    3.480392][    T1]  memremap_pages+0x43c/0x93c
>>> [    3.480836][    T1]  devm_memremap_pages+0x3c/0xa4
>>> [    3.481328][    T1]  dev_dax_probe+0x264/0x3d0
>>> [    3.481817][    T1]  dax_bus_probe+0x140/0x1c8
>>> [    3.482237][    T1]  really_probe+0x108/0x580
>>> [    3.482681][    T1]  __driver_probe_device+0xcc/0x284
>>> [    3.483186][    T1]  driver_probe_device+0x5c/0x108
>>> [    3.483656][    T1]  __device_attach_driver+0x10c/0x1e8
>>> [    3.484134][    T1]  bus_for_each_drv+0xc0/0x13c
>>> <...>
>>> [    3.499972][    T1] BUG: Kernel NULL pointer dereference on read =
at 0x00001400
>>> [    3.500417][    T1] Faulting instruction address: =
0xc0000000005f4ecc
>>> [    3.500417][    T1] Faulting instruction address: =
0xc0000000005f4ecc
>>> cpu 0x0: Vector: 300 (Data Access) at [c000000006756b50]
>>>   pc: c0000000005f4ecc: =
__set_pfnblock_flags_mask.constprop.0+0x34/0x160
>>>   lr: c000000000577f38: memmap_init_zone_device+0x358/0x430
>>>   pid   =3D 1, comm =3D swapper/0
>>> enter ? for help
>>> memmap_init_zone_device+0x358/0x430
>>> memmap_init_zone_device+0x220/0x430 (unreliable)
>>> memremap_pages+0x43c/0x93c
>>> devm_memremap_pages+0x3c/0xa4
>>> dev_dax_probe+0x264/0x3d0
>>> dax_bus_probe+0x140/0x1c8
>>> really_probe+0x108/0x580
>>> <...>
>>>=20
>>> Fixes: bd0862382adb ("mm/sparse-vmemmap: drop Device DAX-specific =
population path")
>>=20
>> Actually, the right Fixes is:
>>=20
>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
>>=20
>> On older kernels, these errors are silent. They trigger a kernel =
panic when the user
>> actually uses Device DAX, rather than during the initialization =
phase.=20
>>=20
>> So, for older kernels, we should guide them to backport the patch.
>>=20
>>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>>> Assisted-by: LLM
>>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>> ---
>>> Fixes tag here is added since the fix is dependent upon the change =
mentioned in
>>> "Fixes" tag. The Fixes commit-id is from mm-new branch. Although =
this could be
>>> an older pre-existing issue, but got exposed after this patch =
series.
>>=20
>> I knew this issue, so I have a local commit to fix it as well. I'd =
like to share
>> it with you, because it looks a little simple, does it work for you?
>>=20
>> powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
>>=20
>> PowerPC radix vmemmap population can reuse an existing PMD mapping =
while
>> populating a device DAX range whose section is marked as HVO-enabled. =
The
>> reused mapping is an ordinary vmemmap mapping: the redundant tail =
struct
>> pages are not remapped to the shared tail page.
>>=20
>> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
>> initialization treat the range as optimized and initialize only the =
struct
>> pages that would be backed by a real HVO mapping. The remaining tail =
struct
>> pages can then be left uninitialized even though they are still used =
as
>> metadata for the device DAX compound page.
>>=20
>=20
> Here, feel free to use the call trace from my commit msg to show what =
goes
> wrong w/o this fix.

No problem. Thanks for your detailed msg.

>=20
>> The Fixes target predates the section-based vmemmap optimization
>> infrastructure, so older kernels do not have section state that can =
be
>> marked non-HVO. Backports to such kernels need to handle the =
PMD-reuse
>> case in powerpc radix code directly, for example by initializing the =
tail
>> struct pages that core ZONE_DEVICE initialization would otherwise =
skip.
>>=20
>> Mark the section as non-HVO when reusing an existing PMD mapping, so =
the
>> section's HVO state matches the actual vmemmap layout and all =
required
>> struct pages are initialized.
>>=20
>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> yes, love this approach. Thanks for sharing the fix.
>=20
>>=20
>> diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c =
b/arch/powerpc/mm/book3s64/radix_pgtable.c
>> index 72793ace1fb6..fc3a2d4b422d 100644
>> --- a/arch/powerpc/mm/book3s64/radix_pgtable.c
>> +++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
>> @@ -1200,7 +1200,16 @@ static int __meminit =
vmemmap_populate_compound_pages(unsigned long start_pfn,
>> 			return -ENOMEM;
>>=20
>> 		if (pmd_leaf(READ_ONCE(*pmd))) {
>> -			/* existing huge mapping. Skip the range */
>> +			unsigned long addr_pfn =3D page_to_pfn((struct =
page *)addr);
>> +			struct mem_section *ms =3D =
__pfn_to_section(addr_pfn);
>> +
>> +			/*
>> +			 * Existing PMD mappings can cover the edges of =
a valid
>> +			 * HVO populate range.  They are ordinary =
vmemmap mappings,
>> +			 * so the current section must not be treated as =
HVO-backed
>> +			 * when its struct pages are initialized later.
>> +			 */
>> +			section_set_order(ms, 0);
>=20
> I think you meant "section_set_compound_order(ms, 0);"

Yes, because it's been sitting on my disk for a while, and I forgot that
this part needed to be adapted.

>=20
> yes, otherwise the patch looks good to me. Can you please post this
> patch separately then? Feel free to add:
>=20
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com =
<mailto:ritesh.list@gmail.com>>

Thanks for your review. I'll send it ASAP.

>=20
> I have validated the fix with my custom reproducer and I see the issue
> is fixed with this. Meanwhile, Pavithra (cc'd) is testing this and few
> other patches of your series. Once her testing is finished, she can =
help
> provide her Tested-by/feedback if any.

Thanks a lot to both of you for testing this.

Thanks,
Muchun

>=20
>> 			next =3D pmd_addr_end(addr, end);
>> 			continue;
>> 		}
>=20
> -ritesh


--Apple-Mail=_159BC117-16BC-4700-9733-15883B67FDDC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Oct 29, 2026, at 11:50, Ritesh Harjani (IBM) =
&lt;ritesh.list@gmail.com&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">Muchun Song &lt;</span><a =
href=3D"mailto:muchun.song@linux.dev" style=3D"font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;">muchun.song@linux.dev</a><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt; writes:</span><br style=3D"caret-color: =
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
-webkit-text-stroke-width: 0px; text-decoration: none;">Hi =
Ritesh,<br><br><blockquote type=3D"cite">On Oct 27, 2026, at 11:22, =
Ritesh Harjani (IBM) &lt;ritesh.list@gmail.com&gt; =
wrote:<br><br>radix__vmemmap_populate() is asked for one 16MB section, =
which is 16KB of<br>struct pages. With no altmap it rounds the request =
down to a PMD leaf.<br>That leaf describes 2GB of PFNs with 64KB pages =
(128MB with 4KB pages),<br>so it also covers sections that are not =
present yet. It cannot be freed<br>while any of those sections are still =
in use.<br><br>A devdax namespace that lands in the same window is =
marked for vmemmap dedup.<br>vmemmap_populate_compound_pages() treated =
the leaf as an existing huge mapping<br>and skipped it. The core then =
initializes only the head vmemmap page and assumes<br>the rest is the =
shared tail. Those remaining tail slots are real struct pages<br>still =
holding the page_init_poison() pattern and are not the shared tail =
pages.<br></blockquote><br>Right.<br><br><blockquote =
type=3D"cite">__init_single_page() warns on the zone mismatch and the =
following pageblock init<br>faults in =
__set_pfnblock_flags_mask().<br></blockquote><br>Yeah, the new adding =
warning is useful.<br><br><blockquote type=3D"cite"><br>If the section's =
vmemmap is already a PMD leaf, clear its compound =
order<br></blockquote><br>I think it's enough to fix this =
issue.<br><br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">Oh yes, right! since the page init is done =
later and the optimizable</span><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">order can be read from =
mem_section.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite">and reuse the leaf, so every struct page in the section is =
initialized.<br>The shared-tail layout needs base-page PTEs, so it =
cannot be built on top of<br>this leaf and dropping the leaf is not an =
option while the neighbouring range<br>is still using it. So, fail the =
compound populate if a leaf is still seen there.<br><br>&lt;Call =
Trace&gt;<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>[ =
&nbsp;&nbsp;&nbsp;3.467060][ &nbsp;&nbsp;&nbsp;T1] WARNING: =
mm/mm_init.c:600 at __init_single_page+0xd0/0xf4, CPU#0: =
swapper/0/1<br>&lt;...&gt;<br>[ &nbsp;&nbsp;&nbsp;3.477419][ =
&nbsp;&nbsp;&nbsp;T1] NIP [c000000000576b30] =
__init_single_page+0xd0/0xf4<br>[ &nbsp;&nbsp;&nbsp;3.477827][ =
&nbsp;&nbsp;&nbsp;T1] LR [c0000000005778b0] =
__init_zone_device_page+0x30/0xb8<br>[ &nbsp;&nbsp;&nbsp;3.478444][ =
&nbsp;&nbsp;&nbsp;T1] Call Trace:<br>[ &nbsp;&nbsp;&nbsp;3.478764][ =
&nbsp;&nbsp;&nbsp;T1] &nbsp;0x10000 (unreliable)<br>[ =
&nbsp;&nbsp;&nbsp;3.479874][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;memmap_init_zone_device+0x164/0x430<br>[ =
&nbsp;&nbsp;&nbsp;3.480392][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;memremap_pages+0x43c/0x93c<br>[ &nbsp;&nbsp;&nbsp;3.480836][ =
&nbsp;&nbsp;&nbsp;T1] &nbsp;devm_memremap_pages+0x3c/0xa4<br>[ =
&nbsp;&nbsp;&nbsp;3.481328][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;dev_dax_probe+0x264/0x3d0<br>[ &nbsp;&nbsp;&nbsp;3.481817][ =
&nbsp;&nbsp;&nbsp;T1] &nbsp;dax_bus_probe+0x140/0x1c8<br>[ =
&nbsp;&nbsp;&nbsp;3.482237][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;really_probe+0x108/0x580<br>[ &nbsp;&nbsp;&nbsp;3.482681][ =
&nbsp;&nbsp;&nbsp;T1] &nbsp;__driver_probe_device+0xcc/0x284<br>[ =
&nbsp;&nbsp;&nbsp;3.483186][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;driver_probe_device+0x5c/0x108<br>[ &nbsp;&nbsp;&nbsp;3.483656][ =
&nbsp;&nbsp;&nbsp;T1] &nbsp;__device_attach_driver+0x10c/0x1e8<br>[ =
&nbsp;&nbsp;&nbsp;3.484134][ &nbsp;&nbsp;&nbsp;T1] =
&nbsp;bus_for_each_drv+0xc0/0x13c<br>&lt;...&gt;<br>[ =
&nbsp;&nbsp;&nbsp;3.499972][ &nbsp;&nbsp;&nbsp;T1] BUG: Kernel NULL =
pointer dereference on read at 0x00001400<br>[ =
&nbsp;&nbsp;&nbsp;3.500417][ &nbsp;&nbsp;&nbsp;T1] Faulting instruction =
address: 0xc0000000005f4ecc<br>[ &nbsp;&nbsp;&nbsp;3.500417][ =
&nbsp;&nbsp;&nbsp;T1] Faulting instruction address: =
0xc0000000005f4ecc<br>cpu 0x0: Vector: 300 (Data Access) at =
[c000000006756b50]<br>&nbsp;&nbsp;pc: c0000000005f4ecc: =
__set_pfnblock_flags_mask.constprop.0+0x34/0x160<br>&nbsp;&nbsp;lr: =
c000000000577f38: memmap_init_zone_device+0x358/0x430<br>&nbsp;&nbsp;pid =
&nbsp;&nbsp;=3D 1, comm =3D swapper/0<br>enter ? for =
help<br>memmap_init_zone_device+0x358/0x430<br>memmap_init_zone_device+0x2=
20/0x430 =
(unreliable)<br>memremap_pages+0x43c/0x93c<br>devm_memremap_pages+0x3c/0xa=
4<br>dev_dax_probe+0x264/0x3d0<br>dax_bus_probe+0x140/0x1c8<br>really_prob=
e+0x108/0x580<br>&lt;...&gt;<br><br>Fixes: bd0862382adb =
("mm/sparse-vmemmap: drop Device DAX-specific population =
path")<br></blockquote><br>Actually, the right Fixes is:<br><br>Fixes: =
f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")<br><br>On older kernels, these errors are =
silent. They trigger a kernel panic when the user<br>actually uses =
Device DAX, rather than during the initialization phase.<span =
class=3D"Apple-converted-space">&nbsp;</span><br><br>So, for older =
kernels, we should guide them to backport the patch.<br><br><blockquote =
type=3D"cite">Reported-by: Pavithra =
&lt;pavrampu@linux.ibm.com&gt;<br>Assisted-by: LLM<br>Signed-off-by: =
Ritesh Harjani (IBM) &lt;ritesh.list@gmail.com&gt;<br>---<br>Fixes tag =
here is added since the fix is dependent upon the change mentioned =
in<br>"Fixes" tag. The Fixes commit-id is from mm-new branch. Although =
this could be<br>an older pre-existing issue, but got exposed after this =
patch series.<br></blockquote><br>I knew this issue, so I have a local =
commit to fix it as well. I'd like to share<br>it with you, because it =
looks a little simple, does it work for you?<br><br>powerpc/mm: fix =
uninitialized ZONE_DEVICE struct pages with PMDs<br><br>PowerPC radix =
vmemmap population can reuse an existing PMD mapping while<br>populating =
a device DAX range whose section is marked as HVO-enabled. The<br>reused =
mapping is an ordinary vmemmap mapping: the redundant tail =
struct<br>pages are not remapped to the shared tail page.<br><br>Leaving =
the section marked as HVO-enabled makes later =
ZONE_DEVICE<br>initialization treat the range as optimized and =
initialize only the struct<br>pages that would be backed by a real HVO =
mapping. The remaining tail struct<br>pages can then be left =
uninitialized even though they are still used as<br>metadata for the =
device DAX compound page.<br><br></blockquote><br style=3D"caret-color: =
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
display: inline !important;">Here, feel free to use the call trace from =
my commit msg to show what goes</span><br style=3D"caret-color: rgb(0, =
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
display: inline !important;">wrong w/o this fix.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>No problem. Thanks for =
your detailed msg.</div><br><blockquote type=3D"cite"><div><br =
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
-webkit-text-stroke-width: 0px; text-decoration: none;">The Fixes target =
predates the section-based vmemmap optimization<br>infrastructure, so =
older kernels do not have section state that can be<br>marked non-HVO. =
Backports to such kernels need to handle the PMD-reuse<br>case in =
powerpc radix code directly, for example by initializing the =
tail<br>struct pages that core ZONE_DEVICE initialization would =
otherwise skip.<br><br>Mark the section as non-HVO when reusing an =
existing PMD mapping, so the<br>section's HVO state matches the actual =
vmemmap layout and all required<br>struct pages are =
initialized.<br><br>Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add =
support for vmemmap optimization for radix")<br>Signed-off-by: Muchun =
Song =
&lt;songmuchun@bytedance.com&gt;<br>---<br>arch/powerpc/mm/book3s64/radix_=
pgtable.c | 11 ++++++++++-<br>1 file changed, 10 insertions(+), 1 =
deletion(-)<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">yes, love this approach. Thanks for sharing =
the fix.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
-webkit-text-stroke-width: 0px; text-decoration: none;"><br>diff --git =
a/arch/powerpc/mm/book3s64/radix_pgtable.c =
b/arch/powerpc/mm/book3s64/radix_pgtable.c<br>index =
72793ace1fb6..fc3a2d4b422d 100644<br>--- =
a/arch/powerpc/mm/book3s64/radix_pgtable.c<br>+++ =
b/arch/powerpc/mm/book3s64/radix_pgtable.c<br>@@ -1200,7 +1200,16 @@ =
static int __meminit vmemmap_populate_compound_pages(unsigned long =
start_pfn,<br><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span>return -ENOMEM;<br><br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>if (pmd_leaf(READ_ONCE(*pmd))) =
{<br>-<span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>/* existing huge mapping. Skip the range */<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>unsigned =
long addr_pfn =3D page_to_pfn((struct page *)addr);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>struct =
mem_section *ms =3D __pfn_to_section(addr_pfn);<br>+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>/*<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-tab-span" style=3D"white-space: =
pre;">	</span><span class=3D"Apple-converted-space">&nbsp;</span>* =
Existing PMD mappings can cover the edges of a valid<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* HVO populate range. =
&nbsp;They are ordinary vmemmap mappings,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* so the current section =
must not be treated as HVO-backed<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>* when its struct pages are =
initialized later.<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>*/<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>section_set_order(ms, 0);<br></blockquote><br style=3D"caret-color:=
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
display: inline !important;">I think you meant =
"section_set_compound_order(ms, 0);"</span><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Yes, because it's been =
sitting on my disk for a while, and I forgot that</div><div>this part =
needed to be adapted.</div><br><blockquote type=3D"cite"><div><br =
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
display: inline !important;">yes, otherwise the patch looks good to me. =
Can you please post this</span><br style=3D"caret-color: rgb(0, 0, 0); =
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
display: inline !important;">patch separately then? Feel free to =
add:</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
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
display: inline !important;">Reviewed-by: Ritesh Harjani (IBM) =
&lt;</span><a href=3D"mailto:ritesh.list@gmail.com" style=3D"font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px;">ritesh.list@gmail.com</a><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&gt;</span><br style=3D"caret-color: rgb(0, =
0, 0); font-family: JetBrainsMonoNL-Regular; font-size: 13px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Thanks for your review. =
I'll send it ASAP.</div><br><blockquote type=3D"cite"><div><br =
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
display: inline !important;">I have validated the fix with my custom =
reproducer and I see the issue</span><br style=3D"caret-color: rgb(0, 0, =
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
display: inline !important;">is fixed with this. Meanwhile, Pavithra =
(cc'd) is testing this and few</span><br style=3D"caret-color: rgb(0, 0, =
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
display: inline !important;">other patches of your series. Once her =
testing is finished, she can help</span><br style=3D"caret-color: rgb(0, =
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
display: inline !important;">provide her Tested-by/feedback if =
any.</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
JetBrainsMonoNL-Regular; font-size: 13px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
orphans: 2; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><div><br></div><div>Thanks a lot to both of =
you for testing =
this.</div><div><br></div><div>Thanks,</div><div>Muchun</div><br><blockquo=
te type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: JetBrainsMonoNL-Regular; font-size: 13px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: JetBrainsMonoNL-Regular; font-size: =
13px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span>next =3D =
pmd_addr_end(addr, end);<br><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre;">	</span>continue;<br><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre;">	=
</span>}<br></blockquote><br style=3D"caret-color: rgb(0, 0, 0); =
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
!important;">-ritesh</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_159BC117-16BC-4700-9733-15883B67FDDC--

