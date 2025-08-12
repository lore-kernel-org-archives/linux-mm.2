Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB6BCA0EDB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF21D8E0188; Tue, 12 Aug 2025 14:39:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB0F8E0151; Tue, 12 Aug 2025 14:39:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB8C38E0188; Tue, 12 Aug 2025 14:39:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5E708E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:39:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54023135A93
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:39:44 +0000 (UTC)
X-FDA: 83768969088.14.1E01DA2
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 116D74000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:39:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755023982; a=rsa-sha256;
	cv=none;
	b=13Lot4Me7hUB3JhJQ05KLH/EF3UT/y58GiY0zJOlD8EFWB8nmW1OkLntCSxlXzpgBAnNsL
	tfP8oV8MX0kK978kDG9yKk0XV8FjD6j6bNSjLyO9dA4rymJf2BFR2hE4ta5Av6t4clnWsV
	SNt5eBJCRCfw/njfdJvzWZJ/sXjeMjc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755023982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CtG2kVxK8k1NQdvyEki9JRqyDdfWlHhua5AM1GdDq2k=;
	b=c4Uak+RGpjl2HAJgTezrCN1qY997xk3YqduoeYZ7QHHcphb3c7fNNh7WLEB9ig5B6CuWEB
	MLtTqi7oH9VwHZYnYnAM4gwLmFskDUhx4dje2K6kaVIdL3rPX3d/SlwWKNm2DmePTjia2T
	kvJwVWsYfvsGmv1eBCVtdqFr6jQvXwk=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c1gK71N21z9sSN;
	Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W34agYFEkjYq; Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c1gK707Z2z9sSL;
	Tue, 12 Aug 2025 20:39:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id D45368B764;
	Tue, 12 Aug 2025 20:39:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id KCsZS5tQGZ3E; Tue, 12 Aug 2025 20:39:38 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 03CD88B763;
	Tue, 12 Aug 2025 20:39:36 +0200 (CEST)
Message-ID: <1cc6f739-3891-4cc7-84ac-676fef62c445@csgroup.eu>
Date: Tue, 12 Aug 2025 20:39:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to
 "struct ptdump_pglevel"
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250811112631.759341-1-david@redhat.com>
 <20250811112631.759341-7-david@redhat.com>
 <dac9e243-33ce-4203-a598-2877cf908cad@lucifer.local>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <dac9e243-33ce-4203-a598-2877cf908cad@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 116D74000E
X-Stat-Signature: qp1bj74bfpukzkt9jhftt9depwbkxw7a
X-Rspam-User: 
X-HE-Tag: 1755023981-236377
X-HE-Meta: U2FsdGVkX1/7CqJItE7lR2fFGZmb4iX1cDHMKBsjRPucPPfWszeGuofiXRSowmiiIS8gcQWcy11SlOoE6wY1OBS5Veq5/ZTq1+bCUskhrEZ84tbLWl2TjJ4I+2gnmjEx55Yx9rIbv6pjrMzY8/xnwfEXxp08j5JzZJzHPmDVOhe1dhgZW4nQXViisiMpNa2vy8ds/+RF8EV4Eep3uXORdPpJo6DE+yEN8W8IsIeuAdF+NkSlCf0zNEKy9d8KQtFw2cT3azIXn3jcMJnn+mwCX2OH9dq9nVehw7zt1zBGjMGDVRIEmHWLUt3sB7DF1N1oQBWJTa4IKhg04PRlvz8yYHdSDs9TltLF6HjM2a2myxrJu6eb7ZVtGfDXNm0hTXA+DYq1h5X9VfhMTxXY3+9HIHpm+eBdM7edn1gyP7inim4CgZluyYlZ8Yo6t4BUSCuNodV+bA16PNwHSk2LR9YA7Dis4SvNJx1Jh4rax4MtiVLIAONFA7VcTl0Es4r1CF7zuMkLP5RyFfpuldc8tarNJidD9uUi3brtfX0SgE8efYLSwpCYjNZvbRxJvbYWbSR9wrzZy14FHJ89Z3GZy1bOdhWCHGVuA2pN0xccZKAuPvNmLn6XzjPKCtcCygyaOhn2rhg8+bfFmIk7BGZog8IUkDOTX5Veq6zUkPccJX/Ej/YK+/2Xy1V24vnJ4Ax5hI0GCbeGghbQG8oh5BdXBZ96dfh7jj6QCgDZFTwTBoDNainPpgrNDW4XEIW5wvvF3PT1uedP5LHdI26LZILLCD2MUYoyZrmXKt9yVju10zCCvDaow54CLTFyiPCxR8NNELh3LbIbxG37yqa/ls76tvE+LdLCHBJ97lj+69JihF9XHmeS2yA/zG6VAwclj8neu7dIRjF5jD5I5NMzjkSxUJz3YMEY9AWDeRMcenLlt7c1dL0X9kl65M1KBzvMgJWUf1q8PrtiI78rvMBhJAvhTPb
 koQwr4xR
 /DTWMz94QFBWhjAJ+vPpjspt9YiUAlRKuPQGWHiPc/i9ZgHA2j1kH0WjUWZn8VTVU+QfbX+VZPBaWZUVGsetyMroIaPTDXM4MF33DR1169mHZBzzZ8UhjWGqhcAywUltu3DDX6qH4/vgQvsZNpO15JH720wt/d1Io0Xyp7BVrxH1nN2foVwGPrbZ+K5UGjznmmqo6M2xCRElkw2JpWcgTZs1Wu+m9arHJVRW8dFaSvqWPE9ys5kcwBKLah1QzIlQGXuzUIrXW9HVA+v7385MhKlaLHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Le 12/08/2025 à 20:23, Lorenzo Stoakes a écrit :
> On Mon, Aug 11, 2025 at 01:26:26PM +0200, David Hildenbrand wrote:
>> We want to make use of "pgtable_level" for an enum in core-mm. Other
>> architectures seem to call "struct pgtable_level" either:
>> * "struct pg_level" when not exposed in a header (riscv, arm)
>> * "struct ptdump_pg_level" when expose in a header (arm64)
>>
>> So let's follow what arm64 does.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> This LGTM, but I'm super confused what these are for, they don't seem to be
> used anywhere? Maybe I'm missing some macro madness, but it seems like dead
> code anyway?

pg_level[] are used several times in arch/powerpc/mm/ptdump/ptdump.c, 
for instance here:

static void note_page_update_state(struct pg_state *st, unsigned long 
addr, int level, u64 val)
{
	u64 flag = level >= 0 ? val & pg_level[level].mask : 0;
	u64 pa = val & PTE_RPN_MASK;

	st->level = level;
	st->current_flags = flag;
	st->start_address = addr;
	st->start_pa = pa;

	while (addr >= st->marker[1].start_address) {
		st->marker++;
		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
	}
}

> 
> Anyway:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   arch/powerpc/mm/ptdump/8xx.c      | 2 +-
>>   arch/powerpc/mm/ptdump/book3s64.c | 2 +-
>>   arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
>>   arch/powerpc/mm/ptdump/shared.c   | 2 +-
>>   4 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
>> index b5c79b11ea3c2..4ca9cf7a90c9e 100644
>> --- a/arch/powerpc/mm/ptdump/8xx.c
>> +++ b/arch/powerpc/mm/ptdump/8xx.c
>> @@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
>> index 5ad92d9dc5d10..6b2da9241d4c4 100644
>> --- a/arch/powerpc/mm/ptdump/book3s64.c
>> +++ b/arch/powerpc/mm/ptdump/book3s64.c
>> @@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
>> index 154efae96ae09..4232aa4b57eae 100644
>> --- a/arch/powerpc/mm/ptdump/ptdump.h
>> +++ b/arch/powerpc/mm/ptdump/ptdump.h
>> @@ -11,12 +11,12 @@ struct flag_info {
>>   	int		shift;
>>   };
>>
>> -struct pgtable_level {
>> +struct ptdump_pg_level {
>>   	const struct flag_info *flag;
>>   	size_t num;
>>   	u64 mask;
>>   };
>>
>> -extern struct pgtable_level pg_level[5];
>> +extern struct ptdump_pg_level pg_level[5];
>>
>>   void pt_dump_size(struct seq_file *m, unsigned long delta);
>> diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
>> index 39c30c62b7ea7..58998960eb9a4 100644
>> --- a/arch/powerpc/mm/ptdump/shared.c
>> +++ b/arch/powerpc/mm/ptdump/shared.c
>> @@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
>>   	}
>>   };
>>
>> -struct pgtable_level pg_level[5] = {
>> +struct ptdump_pg_level pg_level[5] = {
>>   	{ /* pgd */
>>   		.flag	= flag_array,
>>   		.num	= ARRAY_SIZE(flag_array),
>> --
>> 2.50.1
>>


