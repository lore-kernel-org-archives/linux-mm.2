Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37789C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C666B00E3; Tue,  4 Aug 2026 10:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BBF76B00E4; Tue,  4 Aug 2026 10:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3046B00EB; Tue,  4 Aug 2026 10:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1D846B00E3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:07:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F1044015E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:50:33 +0000 (UTC)
X-FDA: 85063570746.14.20F3197
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7E42160008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:50:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YABf4fdg;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785847831;
	b=wjgVUUHwTBemPWQVeh0GSDz4tiwRXHZgqqB6Obw8hh0MUvRyzMEnyRkXKxxE8m1RnAqBAn
	Oicgcr1jf/2HkCGKr9OaYQQaaVzeHI85IUsepT+a5a3lP3aspQ9tPWvJTpCcfJBAoEVxLW
	qSIyxqrnyWyY4ECRsrMEy1kRBCE/s5M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YABf4fdg;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785847831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwIlf/7Evmvt247IE4OinLG+J81ldxUzqSmjbn1lj4I=;
	b=newq4Y48EdkwVjmtfcuAsiY6Q7s7dlJObGHYnP6mfUWYOQDtmHNCz4K+fmexEsybE+fMJz
	44xFEHKhZsRk+mIxAGmeed72DL8tEH4yv26I6deH2LNZkithcadijTTXANiAvqwAVKF3fe
	n9kWvo59momn5MGxpDVpGsCnaKVFgVk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4524360A77;
	Tue,  4 Aug 2026 12:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA74A1F000E9;
	Tue,  4 Aug 2026 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785847831;
	bh=dwIlf/7Evmvt247IE4OinLG+J81ldxUzqSmjbn1lj4I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YABf4fdg/D3MZ/bWjeLut7tnE92glPPUblZGjARSmDu+SgTZpTVi3WlLm5HquAEGf
	 J2bpoFXvno4uXAcJ7Qo2ETmUHwVx7QaU4Q6WWLBRWh0ptmCIMDZ7RFbr0vY3E7y26f
	 HxBmGepETc20zSML41v9hWk4GYBDyII5UeitdQ7FJ1clvB48Hd99D6tRp7kXQbSc+/
	 XRPUWDoOmZMUHaf+U1rl7d5ImlwquVOEdD/uQN4srP+6xLmPHZhNDl1rgq1RFigrZq
	 Gs2boYFuSu/p89NeE3nlhVrLloKDlGkdWJOQ09Yz3skgBGv9l0vTzQ2rYw7eRih4tx
	 ETPFvsGGDEVUQ==
Message-ID: <dcdb8cab-c18c-4995-ad1d-2f2d4700e7c1@kernel.org>
Date: Tue, 4 Aug 2026 14:50:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de> <anHI4B-lMu6AJJfA@lucifer>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <anHI4B-lMu6AJJfA@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cipgpp3anwph38u51ipcwapme7guozet
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D7E42160008
X-HE-Tag: 1785847831-771548
X-HE-Meta: U2FsdGVkX1+UpkjppVVhx9dUPzNnYR2Gdv4UKoBm2hwymEs/E6HEObPSDc2Qh6X8wRY1h3UKK6ypfAVqRTmQ3WxteaVuAguoOk4EhPO7qeUN2TxpDemLmeGsNBsMqryWNxPaUIq5YBQz2/2hayiztNItfaSM461Aqsm+XkY/ToOuseDdL1qw881ImdZGO2lSh3CNlNGXVXVeQoY16FvARQdkLVokXnrMl0EfyBD6zjVABAit3FQYJ7R56LXASIqxaq/lellUn/qZsqErDj+9jpaPp1+F1FAZPq4XnPMfj1g6vUw4Rdd9sGRVreE+ybSCYngu00owx1HF5VFG5sx3ldW5RXRLyCzTvM2JwrGcqyAT3yIIGk6SNEZMAHWZAfvpKq8iKB1N9LpVc0wY5SgS9lHo8UqiQ3tPR1IhuXz6bj92oku5gyQvUJTVJNqXo98Gw0PwgG0ar+s1eVEnf6xAfJydDa9LLLtu+YbSlxTBjAytyKaymL8vW7LOzp+8/TLyqWopAFB8rCVhEWVGuRBB75QKbScOg9EpG2xz5/9x2PmRPfp/lJjqB+BTn3kxf9UK5doTAmKzpnawfsXBGq+81v7SwwpvElaEFR5VWSISYGp15ykpaw5S5anNYyu+KJhq/1eZy3G6NMUCIDJASiVBcXIispwXFpos4SfptT095b1Y7yoPThdNe14SMNWc5+T+1rSorVgsSCl4SH2e5LVgTAlCUeTme7/5O7pr8lKslWE0bIax3vZEcXeldcb6j6SGmVUqRTO9h/nUDUax/cK7OH+8NKGI9A343GPZVrVb9hJC6Dd3/Td4fWyw0FwIcYqwaEwxa0WL/m2SATfTeOOTIQAK5SFGJNWkL688MkarPOEBeggWWUPa4b4+z7ZhqaidvhnDo220JjMO1NmtRd1/GCuZI9qRSyx5WgvVOFaXnYK3xA62zQdwjQNGlgZWxWmFBBxCcXw5oIBUlJJzqtA
 9REaU1n6
 IFgL+1VJnTGxPMxJXdYOJxNtVZ/HP1ouuKahTGV8YoiSOZ7DJoKiMaARo7kxo3nrdsCH0RrZ3dQJzXKrCtDS6lKF9qfgn6HoBNsbC0sdkiCP+1b0CeQobMKUxKK640XW2HBlKCJ+9quyH9vTm5dA2bncXZTZ+5v3JpxR9nBA97kwokW8nT8yoWFwD9fHTsY/K2Z/9TRfnKStdQ8e4g4IpjTNIPm6al1P8MuNqEfAfHk8iQ5eLR/e3338CCzxonFJODoVxw8+KyuWV0fYjj6J7hqosrV5/M5qNzXYMFZ2aMIkewqGW+0SwLoqYvg44g/XMiKaRkChtI4ScR41kNILP1pXrTN7dFLMp7CDGQer7jnAi5fNS2PFTy6vBsUwvnEVCLV1yaxWtHQzm/sk4vj0FcCIcGLuy1QJubBYvoXRfLv/TOM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Le 04/08/2026 à 13:13, Lorenzo Stoakes (ARM) a écrit :
> On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
>> There is no need for write access to the PTE.
>>
>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> With below addressed LGTM so:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
>> ---
>>   arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>> index e2ea8ba9f8ca..f2bab31040c7 100644
>> --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>> +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>> @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>>
>>   #ifdef CONFIG_PPC_16K_PAGES
>>   #define ptep_get ptep_get
>> -static inline pte_t ptep_get(pte_t *ptep)
>> +static inline pte_t ptep_get(const pte_t *ptep)
>>   {
>>   	pte_basic_t val = READ_ONCE(ptep->pte);
>>   	pte_t pte = {val, val, val, val};
> 
> Worth making these const too (that {val, val, val, val} horrifies me btw :)?

Any suggestion welcome.

powerpc 8xx page table is independant on page size. When you use 16k 
pages, depending on the address you hit the page for the first time, the 
HW assist page table walk will fetch one of four 4k cells in page table 
that need to be identical as they all four define the same 16k page. Not 
sure I'm clear.

Christophe


