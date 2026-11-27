Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848B0606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 11:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eitgixv6
Received: by kanga.kvack.org (Postfix)
	id 8D4FD6B05B1; Fri, 27 Nov 2026 06:30:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886D06B05B2; Fri, 27 Nov 2026 06:30:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7752A6B05B3; Fri, 27 Nov 2026 06:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50F6F6B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:30:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF60A402E4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:30:25 +0000 (UTC)
X-FDA: 85480680810.03.948DF51
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf30.hostedemail.com (Postfix) with ESMTP id 711D180011
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:30:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eitgixv6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795779023;
	b=Gbl1gGy/1lfqLbGHj480AR1KfhIhdujM088Ffn7b0rNza2/a9IusAzZbxQrG/rNHmg9i9i
	OVkYMpqjQ9JT8iSwol6St9ZVDqoFDL8I+165anWnfr8462/3ogm4hxNg6hG1BaVIiCGoBN
	H79GGEKT8mLnQAGDEjGqpk0Wzf+ZT4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795779023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/DRujHK3h9OYFJqK+Heu3tFSqlmEJ7ZaPjCgT9OJxg=;
	b=uRc124gFLPBHGcWzAD6LZZR6b/Seqf3H1DMUZfxnud1HVoxsC8vxEw5sZa1S0JgY99M3SC
	rJfX10URINIAMpdhegGfLRggPd6cKlZTBNTpLHisdDLYhM+0FsyJx9sQG21FyaWzRQABNv
	Mw4MGv62182xOIg1cVp/vVs4EuLt/oo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eitgixv6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=REZrybfYS1Zew1thSQ+aV8V2RYKBra503CLdmEQhDsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795779021; v=1; x=1796383821;
 b=eitgixv6I+pNEX1HpAQ1E8IKBzaweA8zRqqg30/x+/dl9QFbHc/I3kMYqomiXNzl4P4n7ZPy
 7QIXGHr3c1/VBjcHwrusmYTrNIv1s4Z4PmnusrVReX5VnOouX23uft/0qFTjUvhHeC4qjbjQSuu
 05ODtUAOSq2fPqXkLDjeRrMo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 64e8215db0511ddf;
	Fri, 27 Nov 2026 11:30:19 +0000
X-Mizu-Trace-ID: 64e8215db0511ddf
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] tools/mm: add a drgn script to show HugeTLB reservations
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261126-hugetlb-resv-drgn-v1-1-345a6ee7c08c@gmail.com>
Date: Fri, 27 Nov 2026 19:30:04 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Usama Arif <usama.arif@linux.dev>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Ackerley Tng <ackerleytng@google.com>,
 Zhao Li <enderaoelyther@gmail.com>,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>,
 linux-mm@kvack.org,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org,
 Omar Sandoval <osandov@osandov.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FDAF27F6-A5D1-4911-BB86-6645272E2BD3@linux.dev>
References: <20261126-hugetlb-resv-drgn-v1-1-345a6ee7c08c@gmail.com>
To: Aveline Noir <jm5905938@gmail.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: 711D180011
X-Stat-Signature: yhkw7rdmyqesjekufi666jxp6e4uykik
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795779023-280775
X-HE-Meta: U2FsdGVkX1/K2jt9WZurOIiLjC2cPmY++8A0GyjDYQjbYIRsfzGk2kzrDUlXBn+5wFXEL/wKCA5QB0ZOKO5DobRxmFMiHcNirl0cI1Omd4uSefdNUFBtLZdFTLrwI191EY44IGavF2IWNPMzHDkkyi1fuWRYBP4vaN2pd/LYueIMBIpU+HSWcUxRTLrJYsLeVSF+nlM2wB92DMQGT7FCGeHfF3S1aQOQCE20BAg0s6DyFR9SbQ2UFIwwtagmdmnWTzAQiFr/BmwykoVvby8KvF136g/qqHxhEfxxkOXNAKWzzo+P9a09ApvrCLJ8iQPm2cjiWFRvjSh5OpJCMIGZUg4YnH2lkTJScsUOk52W3kVk3s5oVUCOiq8AcxNrCvLlvZe9Uz+Hd9+zzhIA0iFWT9xdSLMW5jfuGqNJxNGTViU/bJdaHZrxy8YKV/On55ROEoZQnsVusGSDoZioJg4MNdhAml7/EyRxk/K4X5QxUmiTQr9WEJVZpWVDf6YGlkqMKJN4n0giuqWquIlK/XKNVKt/Z1fbleGgATorgyv0qufzYMNlNG82l2+H8LyL3Kl1SZ3Tc5Hl2e4gSxhpUXk+4IlavVpHevBjHC2jbqJ4t2Ne+uFGV338CxAR74FxWw6TESS03Mezyf9UhjLgZhXqZZ3qpqurH3JChG74b3lhlXfk3F49jdiqSNco+r4fsL8sXgct1epIcO1E/TTuL34W7G4vVf2iPtPz6x5/+BIqEo+KhhrbyenWiLPAUtkRp7eHH95PlrMLjJJHAs0qzj06oBDSAeD8OTGj1SQOL15/+L7vbEm8gEifRC0jO/vgP1nRsGJmFhhjTq/m85amOvs13uKNup55UGCAlBptP4EenghV5NpNIghJcrXk4GjuNEfOOIYlRAHhoAPl84lveEuALV8H2d1n9Ngyj/0NYzxyPSrfpF1x9xupN1+BJGsp5MH09oYv3yw5kaSuiE09Xgs
 3kLvlcK3
 x2WQNyzxVrJ90AnJmzeAVCEM6+ggnkRTXAP55xxLHSSnVdZUWmzeAyWFAgm4Q+g/dx95GCGy3Ap/UDhYN9FH64W9rjMsQN1qsBhxslcylhGBozBDPhVeweSm0S1u8JkpLChhkTO5mCg6c7Ry3pCJliN92S91681V8yNmXyzm0R1jVRcCLxImZxP7UBtrj8LWA4DqJd99gp2dAOYB6ZungsEm0RCUxd0dIJgA17p2hJbssSGEjvxhT/sy2q4TIx60jiBF9igZex4tyMWFrhEq0/vIBS97F6QBKu5YBFNlotNDmqp/v55siJ/m34C+35Gq8zm2DDsog/vMpvuPH8o70Vx0EBJUHbW56L8EUkQFZCniylOmo1psO67u2EnPQLvIFENQZOnsHslBnXbBMrPX4oIrzBYUCnrmQXQs13GW7jJZ/d+JyhwdFSKDUNQHILhxJP6uRFyfoZe0fLqUBHxvf914DY2YJnDvhfOFXqdHbJp4VWkmyjTzfSKDoLn3zx5QgPwoqCk8fzhQfTaOZ6plbKIYbVgr9m49rHwSnZ5vSRQKHmdoQBC8LIzPIv0F7OkjcQfT7Z5JS8K2w+xMHoqKx6bW4eDIZhvKfbkEa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 26, 2026, at 19:21, Aveline Noir <jm5905938@gmail.com> wrote:
> 
> Add a drgn script, show_hugetlb_resv.py, to show where HugeTLB
> reservations are held in a live kernel or vmcore.
> 
> HugePages_Rsvd in /proc/meminfo only reports the global reservation
> count for the default huge page size. It cannot show which files,
> private mappings or hugetlbfs mounts hold those reservations, or whether
> a subpool is below its minimum.
> 
> The script walks those objects per huge page size, compares their
> reservations with resv_huge_pages, and checks subpool minima separately.
> It reads internal hugetlb and hugetlbfs structures, so keeping it in
> tools/mm/ lets it be updated alongside them.
> 
> Usage:
> 
>  drgn -c vmcore -s vmlinux tools/mm/show_hugetlb_resv.py [--json]
>  drgn -k tools/mm/show_hugetlb_resv.py [--json]
> 
> Output from a vmcore taken before commit e4949a80f3b0 ("mm/hugetlb: fix
> subpool minimum reservation rollback"). All three reserved pages are
> attributed, but the mount is one page below its four-page minimum:
> 
>  source=dump status=mismatch (counts in huge pages)
> 
>  2048 KiB: nr_huge_pages=4 free_huge_pages=4 resv_huge_pages=3
>    inode_resv=3 private_resv=0 mounted_resv=0
>    attributed=3 unattributed=+0 resv_floor=4 floor_shortfall=1
>    sb=0xff11000004000000 path='/huge' min_hpages=4 rsv_hpages=0
>      min_shortfall=1 used_hpages=3
>      ino=191 name='a' resv_map_pages=3 instantiated=0 outstanding=3
> 
> With the fix applied, the same test leaves rsv_hpages=1 and no
> min_shortfall.
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
> I wasn't sure where a script like this belongs, so I followed
> tools/mm/show_page_info.py for the placement and MAINTAINERS entry.
> Any feedback is welcome :)

The Dragon project itself probably belongs to this type of script? See
here:

	https://github.com/osandov/drgn/tree/main/scripts

Thanks,
Muchun

