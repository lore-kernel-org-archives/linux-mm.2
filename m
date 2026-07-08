Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D59C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6881D6B0005; Wed,  8 Jul 2026 11:16:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FE36B0088; Wed,  8 Jul 2026 11:16:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F166B008A; Wed,  8 Jul 2026 11:16:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 32BCD6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:16:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A41E912019E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:16:00 +0000 (UTC)
X-FDA: 84965959680.29.6D23C85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id DE9981C0011
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:15:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oz5MizNl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783523758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jU1GPKH/Gizt9YoqdTBMhVGS7QSyAEyQGtAl+M4xEbY=;
	b=5aHCO5nCD85iRuAYFsZtQBLXoFE9wUeakRzfRAzjJ+OyDlPN2Xo+FNxV9enYxn9imwbm/x
	8S90i+Q1whLUM20yQ9rrkZKgmotbwfv8QVYTAyqwak4HinQpH6VvG/o28IJRIRvZV2QMe7
	0+ISSrYzo7TD1QET7hLtGMF9owkrZo4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oz5MizNl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783523758;
	b=JBQIXdPpeN/SNFftVNr3/4VHiakkPsPJrE3RMPLIJGGgyhV07RNMfhtJq2l1d3CAIHGst5
	tBKPYIrhPqCLZR9O3p0xEjL6hRRmP1vJrPg2eayv7YgSRBmR5iisOWZCNmqHlC5n8hQ4Ow
	U00RlUg4PtEjL6UAOOBa2huhN66hUGw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D3B76001A;
	Wed,  8 Jul 2026 15:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4211F000E9;
	Wed,  8 Jul 2026 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783523758;
	bh=jU1GPKH/Gizt9YoqdTBMhVGS7QSyAEyQGtAl+M4xEbY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oz5MizNlb3uPkGnFpOnL3yPlFyp/hK0LXvT8N06KF4hyzPESzeWEB+iwlJtHJIhIa
	 dR13T8MiYl2a40ogk62Nqu+2Gk2FTKT5VXgo0C73SUL1gbMkxE3UqAsKNP2E8DQat4
	 bzrqfcQCG0LgHsIioKX05E5K4V+GKc/DUSfusGCGqMBPQTK9euRN46wn8sygbBOYZT
	 fh4wLp7tmMwe3cImDY5wLR9lfW51F5TjZuPthIqsg8y5eu6x7e7WsjYu/YyBSj0IGB
	 dV2xazzYr+GW4aEn6CRUzKd3sYitmOPyZFmTA/Ln8P6D4TCM0ltE5yL4RmzqkXlcQ2
	 mbDmsSOkpS7sg==
Message-ID: <e57dc812-8ada-4bed-9d6d-cb9a6dc5e9ea@kernel.org>
Date: Wed, 8 Jul 2026 17:15:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] x86/mm: drop order parameter from free_pagetable()
To: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-1-156ce4986598@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708-bootmem_info_part2-v1-1-156ce4986598@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DE9981C0011
X-Stat-Signature: 9o856puupesxk363qtd1pu8djbwqn1yc
X-HE-Tag: 1783523758-159745
X-HE-Meta: U2FsdGVkX19lMjcNWPlUU4leUWCai5aOMQW1cTqRaNM5vNb3XqIFIibhrpYlaL8X7F7rMZSM5HQTJtw+eOugV2eSIjjrZ9lJ7v5LtfUIc0V3EJxYP5KcOZweaicC83rdgS7lA0RoNhYDRFLeHWYl+9qLOvWQ879JEU2L48WLBRs8nfzX/XwpLFNF9QJ/DQ/JDCVgedSWR/dB2/Sf6FD169sly09LVRhXKCLD6+05NHx4xqVJUjjsyMfR++3fsXiSOIvJfOzgsZE3c5f1WmaFF75n+t6dGdUriDzwCZ5rT8D+6Phcch9Entr31quCjjYgVzAGyvbI/3FVxodm6r0aQdJ/8WNVzyJuFQjDJS8NT+H0CJj7qdb0viJWXcPb7XJeG2TdDF3qArBPS+c50cTH0cuCq+r2WE4XkXNNLw3LxT20nNGQAshWebHW1dkLjnktigjv8u9XPItUtM6T3Cf/J1c658Y9/QS247Rd6gj0AQJ/fU8cYETxaEy1Oi1nBMENawnftov+gdFW8eNXIojSEH0YiH/VtV3WYxTyv1cNRUfF/TUR8mmkSGx3iMPODAvhc3j7XQ6e/npebKda5Ts3O7Wah4vdQsJQxMEtM8XTF8mQWkg2+0NJACfAnYKWB8k2+vvFlRhXC8JKSrOYFKJUMnm5+M4hJX6TfS5rkptN4aEhOvil5jd6WAe3lmkipQpZLQG2VbVZF9p6o0uRwLvGz0l6TsJr1oWYiQSBPW8rtzjW3JdfkveriTf7nEuGPYjDNOvMAF7c8GlEwAa3eKGPqYSPo1mU5lA/78mbGzSzF9iq2npO71FuIXYal1eh3Q1J96F2yXg15aN9Sz+WIrjdI3BHMaXBLo81sJ7okcC4nPwv95eN4KAifJcRkuUz8bb/DdcVNumyHp40hCAzrKPHIJx6FZGKewZb2cCAMvitXKd65UXIFSL2T8cVX+VN/ows6WjVdc1SdTKjwZzqpHT
 D7ySXPi0
 8uklIf7UgcRvONFpRUvUeV94ydtNfNudU9qrX8gOtPS2tvnZPGEdW3pdhKeAyBo/7bCoq/X0uI2kPKFKiAVkqqYUYtQwO1fCx7fFGbBYggYY/YbEQd4+2poPhBsv3lS3WXbDSWay7JtpmJ1BlAQNfmNlVyvTyu82Yey36P9++gXschSRI32Kt0pSIQblCqSviG3+TP+5zAoxsyiDNENknIUwbNDrlRVYVYjtwviLAIbXujCXSA4p5/R4pk0L2zuMa/Jp2Lt0xC5PHWdsgc1Z4FL5jRveYPf6ZZRTrq2CLnGCVoGSLnAWkZ+TfVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  	/* free a pte table */
> -	free_pagetable(pmd_page(*pmd), 0);
> +	free_pagetable(pmd_page(*pmd));
>  	spin_lock(&init_mm.page_table_lock);
>  	pmd_clear(pmd);
>  	spin_unlock(&init_mm.page_table_lock);
> @@ -1078,7 +1075,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
>  	}
>  
>  	/* free a pmd table */
> -	free_pagetable(pud_page(*pud), 0);
> +	free_pagetable(pud_page(*pud));
>  	spin_lock(&init_mm.page_table_lock);
>  	pud_clear(pud);
>  	spin_unlock(&init_mm.page_table_lock);
> @@ -1096,7 +1093,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
>  	}
>  
>  	/* free a pud table */
> -	free_pagetable(p4d_page(*p4d), 0);
> +	free_pagetable(p4d_page(*p4d));
>  	spin_lock(&init_mm.page_table_lock);
>  	p4d_clear(p4d);
>  	spin_unlock(&init_mm.page_table_lock);
> 

Sashiko raises some pre-existing things around use-after free that I will just
ignore. We don't expect anybody to walk pages tables we are tearing down here,
and we'd have to wait for the TLB flush to get this right. And I don't see the
need to.

-- 
Cheers,

David

