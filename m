Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A475606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KKaSdtvp
Received: by kanga.kvack.org (Postfix)
	id 0105D6B05B8; Thu, 29 Oct 2026 23:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04736B05B9; Thu, 29 Oct 2026 23:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1AEC6B05BA; Thu, 29 Oct 2026 23:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 982136B05B8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:03:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14079405EE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:03:35 +0000 (UTC)
X-FDA: 85377797190.21.027708A
Received: from mta0.migadu.com (out-97.mta0.migadu.com [91.218.175.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id D63ED40007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:03:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KKaSdtvp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1HTdK9Us/nXxv6524NGuZeaCWy7CFdEOV2AIIWt1JQ=;
	b=IoRyQnX97/+KvWXfbdtULObTCtEcI7xebwpygM+CJ+C+PJQ3OM2+L1GjkY4XSANVuZBJ27
	/1T23KLcllfG86ABsd2rTm+W07HdsXgCXqWf8yNDpz1WPER4pyeR+gbHol3TOaugugl/VZ
	CWRud5psop0ZC0whL2o95b9ahvk44i4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KKaSdtvp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.97 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329413;
	b=axEeYjX9lEo7Nj2JeDLRm+ACBOl5OVqt0vuSgz0mqHrGi6LmdrY99F/SzFU6D/ltNqhWNY
	VtG4ocvbmxRUrzxfwUHq6+a4k+QYe+sEn0SJiPaYCD8rZLAH5XvCHsx7YeiN8un1Zunp2G
	F/aL1CeKZ0Yl1Vp/8+K5/KuyhCUFpyI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=A7GiL3udSSdyFKnyh+0Vow6D9krgem3lJz6Fq4u8pT4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793329411; v=1; x=1793934211;
 b=KKaSdtvpu7txiAPoaxO8Yi6oAg91UieXpbfe9qIH3UNe/A6K+26PUE7c87i/lLbsBJfJcwDy
 HnXgdIK9fg6F+VRmcJTj7SAJUXDJfeOGWvmjFSXMhkmUpcqbaQFxIPp4jFyCXa5y/2/JK3WWnBO
 6f5UQ7hbWl/4DFYCEZ9Mr+n4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 70512d1ee8cb6ea0;
	Fri, 30 Oct 2026 03:03:31 +0000
X-Mizu-Trace-ID: 70512d1ee8cb6ea0
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages
 with PMDs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <h5i4wlx5.ritesh.list@gmail.com>
Date: Fri, 30 Oct 2026 11:03:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Pavithra <pavrampu@linux.ibm.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <20FE1232-A48B-4F72-8F18-89EFF70EE0FE@linux.dev>
References: <20261029063601.1961415-1-songmuchun@bytedance.com>
 <h5i4wlx5.ritesh.list@gmail.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: D63ED40007
X-Stat-Signature: sfgpor9gr918hdrewzter5g4rai5q6rp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793329412-451925
X-HE-Meta: U2FsdGVkX1+yNfn7zNfxKe9SfIGkr3vGZ0suiLcsONEYzkHt1XXfHfaHtET5LskMg/tdcIUHYnLx6Zj6E9eLkZvFv8cVTYosw1HD9bGhCxXzf/RUsCYMdVXfD8774BnN3uzuwHExzvbB/AH8Y6AkO43cWVGJjxCV4mmkUO02LajhqRa7K8wWle2tjjFoE8aPJDn93nN3K1/vUGc1C32z9Kp+eV3XmXaND7EU2xvb4fPMutYVRQLa3QJpPggoib7LIjMwr1kszyWi/Yw2MfujFBdIhdOEeCMcUC5bFRQf0ifAzIJkId3XtUJKck4AZa+BMlowSnSwUbpuWQePysIi9o2kyl3A9XlIjyhNjFQdJkyD3PFWFSMhEgFOGMrDYhInBUhSessu9TRKrsQL+9a3yHmwafygn17fZ1Vlk710XvVVVWCEFOQmmsSQzVTqoT4wtHIe4/n/F4v5cQFWKY9o7OjpAqe8gKFfmLk6qoQFblXnJz28CdZ9dvYS8AOc52WYVExs+ZhlUStRGIHK222QBxVp4TmjJmB2iHsGmfj0mdiZoOANO/RYGww9lQmlMKUcGLUfjaDJ51ySlk4ZiWP9+7jyuLMQhtpLLVDxCrGYv28RtbCE7CfKPDTvSviESrK4QV40EwJ+da2rOmALPwyT75ztORTJV2QipjM6dq216RnVnHfie4kZZ2MbTyLwWtvYDZ1Ssiu8VPo7mIAFNCOnIi5xCnt3xWTNfjpdsvEo1WNcXvOSynUjlYvbqDIUE/DagjSNpWHnK34lfJ1OSao/o7YmkDuvsnJJx+coxYve6MgsloVsPAakNSYHtk25T/o+uwuQpQwDa/iwTLERUQnrp/BOzphdHYyYPvvHxVrFAZ5UMW70szTUB+RWrR+xhaXt0ex3+uoi07TyL0QXtOwtjEhJTV4xrgST9mCRVXwk06lFDWruvf5NzEa4ux90qRlMjtVAL/of/Bf5z4heCg/
 4Kjg93N9
 H1N2QykbSWusAp0OSArXMVIgdlELzwgBl9BRdSPY416ky6GzaLFWMFqXXxih6EOXrZ6apdb51T/f8QrC6BufzHBrFhRxepXfJqhppEAAUpoCm+AQCaJkFBHLIcWJjOPQOwLj/TIh4/Pd+8CgR744Ibnjn86AkgJKYBjWDW/ih2FwUAAGHKHF7C2oYfJPp6eQ/ayO1dvLVFXK9MmkNzF2XCHDWas0zvG0NWmjf9E27Ur+fOTR+d04ekG9qjcLJfL01CYrl+K3/qNLkHRD5wELtCVQ6cqggDrS1pvz3p0AAZ09MH5ZkR1981g8RILqXCvbA1v7uQVMAj8H9GWaSuSKOjc5UOs7PbJ+Iv605oRel3Pe9J3lwVPXeEaQRBXtTJpQQYuFMcyMj7NgJ/Sd9FFQZY5JTrZFA4vljR3ezOuRLhamYlrRc0n/w62zokvkmywLn3TAzQ8DtPCjXXcZbQqbDYrg5nLLLcRSTLKX8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 29, 2026, at 23:45, Ritesh Harjani (IBM) =
<ritesh.list@gmail.com> wrote:
>=20
> Muchun Song <songmuchun@bytedance.com> writes:
>=20
> Thanks Muchun,
>=20
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
>> This first triggers a zone mismatch warning in __init_single_page(), =
then
>> faults while initializing the pageblock flags:
>>=20
>>  WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>>  Call Trace:
>>    memmap_init_zone_device+0x164/0x430
>>    memremap_pages+0x43c/0x93c
>>    devm_memremap_pages+0x3c/0xa4
>>    dev_dax_probe+0x264/0x3d0
>>    dax_bus_probe+0x140/0x1c8
>>=20
>>  BUG: Kernel NULL pointer dereference on read at 0x00001400
>>    __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>>    memmap_init_zone_device+0x358/0x430
>>=20
>> On kernels without these initialization-time diagnostics, the
>> uninitialized metadata remains latent. When userspace later maps and
>> accesses the affected device DAX range, the kernel operates on those =
struct
>> pages and panics at that point instead of during device =
initialization.
>>=20
>> The Fixes target predates the section-based vmemmap optimization
>> infrastructure, so older kernels do not have section state that can =
be
>> marked non-HVO. Backports to such kernels need to handle the =
PMD-reuse case
>> in powerpc radix code directly, for example by initializing the tail =
struct
>> pages that core ZONE_DEVICE initialization would otherwise skip.
>>=20
>=20
> Actually that would be totally new code right? It won't be a straight
> forward backport, correct? ...=20

Right. Because it's impossible to backport the whole section-based =
vmemmap
optimization infrastructure (48 commits).

>=20
>> Mark the section as non-HVO when reusing an existing PMD mapping, so =
the
>> section's HVO state matches the actual vmemmap layout and all =
required
>> struct pages are initialized.
>>=20
>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap =
optimization for radix")
>> Cc: stable@vger.kernel.org
>=20
> ... then should we mark Cc: stable here with the above mentioned fixes
> tag? Because this patch cannot be backported as is to older kernels -
> for the reasons you mentioned above.

The comment following the trailer is used to guide stable maintainers to
backport proper prerequisite commits. It's hard to do that. So I choose =
to
mention the alternative in the commit message. But with the help of LLM,
I found the alternative is also not the right solution. The reason is as =
below.

That pmd_leaf() path only creates or reuses the vmemmap mapping. After =
it
returns, sparse_add_section() calls page_init_poison() on the whole =
memmap,
which overwrites any page state initialized there.

Therefore, older kernels must pass the PMD-leaf information to
memmap_init_zone_device() and let it initialize all real tail struct
page entries. Initializing them immediately in the PowerPC pmd_leaf()
branch would be too early.

Another solution is making vmemmap_can_optimize() range-aware by passing
the vmemmap start and end addresses.

On PowerPC, reject the optimization when any part of the range is =
already
covered by a PMD leaf. This ensures that an existing PMD mapping is =
reused
normally and that all real tail struct page entries are initialized =
later
by the core code.

Maybe it should be a separate patch for old kernels? Thoughts?

>=20
>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>> Closes: =
https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070=
429.git.ritesh.list@gmail.com
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>> arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>=20
>=20
> I think, this patch should go via mm tree, due to all the dependencies
> coming from there, right?

Better. I hope Andrew will pick it up once I send a v2 version with more
proper commit message changed.

Thanks.

>=20
> -ritesh



