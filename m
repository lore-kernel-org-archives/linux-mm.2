Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A280606A331
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gIwImG9d
Received: by kanga.kvack.org (Postfix)
	id 4868E6B05B1; Wed,  4 Nov 2026 18:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4101D6B05B2; Wed,  4 Nov 2026 18:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D79A6B05B3; Wed,  4 Nov 2026 18:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA4C16B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:09:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71EDBA8625
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:09:29 +0000 (UTC)
X-FDA: 85398980058.12.D3BC874
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8BD96100007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:09:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gIwImG9d;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793833767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QJ44xLdhQI1uBh7xxp/N2gaMNtMNeyLEDRfUNR/7E78=;
	b=DefNpnz4r99EkVWrerc7h6SdQqc80nHchuBAQNFQHTKKsYpz1hTigXzlDajMEqy2Mhq5ld
	dmFMoq8USt7BdIvmoRW4vOBelgBsVXDlDUUcFbm0I+o9oYubZj1WU7UhX/8m8nUML2N2WL
	SDXgD5ukNnBqosjh7kLoBx8nR/vpZCE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793833767;
	b=rvhCsI8mAyGsEqxrLRMkdw/hsUDeFXQYvixI1qajWr4IWHSz03A4jJ2Slttrj4VTNwvLxL
	36xhK1At6CwDRYgFCWQjXMargWpa97Pb6W8GpdTelcz+Jl5Q/4fU04WWR9PIFDcxbSgami
	i5PiHIgA7J/KJe5Dn0zMk6ZtzSKdS74=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gIwImG9d;
	spf=pass (imf05.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49d05d51553so7906345e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833766; x=1794438566; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QJ44xLdhQI1uBh7xxp/N2gaMNtMNeyLEDRfUNR/7E78=;
        b=gIwImG9dSxOIyTAbD+iaGxY5ejJbIEoNc4mrtO40Z50SQZ7L+OwFuzKxm3hCaCmpOR
         LB03ARAbZk7vr+FwdWoQjyAxAQE+H9PQ+vGHa+sxBh9E8eIwYRIk8e2J6nikQvKUZxGl
         q0muKS8EQKI+eeZVUomWVNbI23z3r/HxgGEzJ/8xNBtJhXmSJ2G8YeOb4lrCIS/3cFoX
         k0C6ZeowXH2Gdud4E37QbKLqJ8PC2K8io9rbFCD6R4IPwUSDJ/e361K6lH7nHQTnRuAo
         JukacajLi/YSVF6FOnFqZYqqR/3mGTPgbDzgtLrXynZlVZ9ZsLZ7Zs1fjEbJ9VhQvIyv
         eyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833766; x=1794438566;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QJ44xLdhQI1uBh7xxp/N2gaMNtMNeyLEDRfUNR/7E78=;
        b=ogocN5InHolSEX0COOtGCcYq+tahZeWHDers7w/6fLj/UDaBW8aYHbrFKLDA0utTqE
         1X5WVQY8Jcsht/kAXV9gnv/OglJwtIKsrFEd2YDzTlDs6Tx0QnXQ755xOLIg6ntDZ7Fo
         a1wfloYYM8aHRh5MwPN/+vwGUFE5hqf9a02S1M/KBjt/C4DfkznMHufXN/DIBX1c+5hA
         +DXFSBazfY9rrg9kCJ02xm+1W1SkWjq0x/ZpElxkSAix31gucZbA1U4EpzabiaiBRnmd
         FSF7Dl2+ki/MY6ME/IXHsDx2T81znlbsN86kVuWnf45JHxAtcgoazCIHufiIb9GxqFRn
         NwvA==
X-Forwarded-Encrypted: i=1; AKwUvBylH2eLpWAUHf7phBFUO80Ntl+PLD+JIH+H4jgUoHdElzPWgy+N+bQZfAvRErVP8oj2epBUJs5S0A==@kvack.org
X-Gm-Message-State: APuU4Z+EQitNfLXAhKZkHP+/dU1+j2tOzuEnwUOA9oF+lTzpUXyHnBJP
	mS6/13R/qH8lUB61OG4jUWjzVUCYdQl979s2VCfB5jVsuky3bpaa0S1e
X-Gm-Gg: AYBFou2Oo91xH/sjxouJX+j+K4ea+NimWE4t/BOb3sQ7GyzpVZ6fzw+y6ogelt6FwFe
	TxmkudAgJoH2dQitMw5YeUVTWWuC73whD2i/xa8/JHGJrFIVND5vBJkebjEc6LamRK+J5jA+OW7
	HwYC15Btz2iD/zSQZXyJaoIhBh286LyrRMS2FBFPG3oKypHFlfPGfXofaGFrURcQ5SSt8B1gQok
	y2TOOiY8YRU+kBYkb1BQBBX/2ovJNhDd2RbQdkU81yw/K6DpWyCYCEu6AiLyPoaJPZdcKe0/qRg
	f95Z1a1VKWzJxrTII7Im6mbu7hnSN8T+n9bH4zbCWjuNxPXy0GlFb+uHzMawrWXA3f08po04K0G
	gJQFlp6OEtA33S4UndnRw5EcCxnW/z7c8TWgP8Oen86BkapUAGqQhRh4MhjfHsbM84zk801IbZN
	YKeebgt65bgNDtHs9R97fUu8Uyo9Wyj5f3o8I+H30DL36UGFSScTJT3tvl8Nzh8IiYSJ52Jzfbj
	J1LL8yfRknDTZz1+ppmpRHhuePcNMH6gCnJJtl9gC95c5c4JAz0kTGawmWpIxgY0M7u09pc2uYt
	FT4pf2nTFyFNlEBlC1b7x3k=
X-Received: by 2002:a05:600c:3b88:b0:4a1:cf60:dcc3 with SMTP id 5b1f17b1804b1-4ac187a6ffcmr414345865e9.29.1793833766131;
        Wed, 04 Nov 2026 15:09:26 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56e2ae73csm18115315e9.1.2026.11.04.15.09.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 15:09:25 -0800 (PST)
Message-ID: <a9ed4146-691d-4a35-9b82-e60329688277@gmail.com>
Date: Thu, 5 Nov 2026 00:09:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
To: Konstantin Khorenko <khorenko@virtuozzo.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
 <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ix9cefmyjs6unj1hpzo7az85ef3q6up9
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8BD96100007
X-Rspam-User: 
X-HE-Tag: 1793833767-959418
X-HE-Meta: U2FsdGVkX1/RD10mUjdx18Xy/ebSMpqO24KDvt/R4Lp/l4kZFJNmdflh2cfPiwxIq38351PIzDll/+hlvCFfFpdPcPOqYwgGpgBuwiEOu6KMGP2D9hTpIc/QzlHMOP4qcl0N5Djij3TPc0YkqkPEyCttRGzSVTpOI/XjWx07Xc/L1VCjTK4ECRumFnDmPD0Q5l8hucwwvozzYk17r0K5ZcPgwvzk+RqjqcbZc77a1E1qaOhV3dUbeEFF9a7U2YBQoZHwQiR9mrHtzJPSzlk+qWO0gsNoW551n2zwMCT9DQyEI+W5E6hzhymPgTOa7YuJPMf/JMjHMC+i6+QbP0ij/nCwtjuWJVs28avARGDv1lugzbf2WK19cwYOfp0tVZsLxlB2surMi8TmKKqnRAfVs44W3X8iPevKzWW+jZt6sCNr+YKSGjrHTW732ReG4TerIRPeVYSLbowCRlnsi4yWBNhJ49Lugy2KOBGya7M00t1soGsVu6L5KYq+zQ3cnVjXBj30qklfTizReHv7DIbWftecGzFQuj6AyfolZZtma7/5nczjH9XZXZ68oPE/DxJ851/pIO6ITutfxBZ+rzcbMiyEKoMg0pkxgWSvjdwISCExg4RcpHVTaYgXvxnTv0I3SlOKcmPYXWL3YyGLmz7sLIHFO7ixz2wHf1TTXB6zzi2Vwx+c4qSX0KF+Qu3TPTfphrghfv05M6YX0WsnOSWfbt8Xrw5B+BMZAXJO/5VY3RrdVhmaSmts8e8pcNYoQ6OaGK/8UYF09k1BDyYrQmHOlMhN7ZP0nyWtCKEG7QfChoPZ9eaXdvhtU1fD7Zl0LvsaQjUis5U1jGGHkXsso3kobEfYFiYCcifJ93uIjS9ENsY9JlN2ihegh5ur0C8kYx/KoaP/dHGkp13icVborq6Crx8RDC79DS5PjVJeAHi9PrSCRpULkJZB8xkxHopprPd0zbePRiSdsvFcJFzNZni
 WdZyRkYY
 9xqAXPEv+VGm/g8/ZqVLdmF9B1omENCMVk/2+Dlw/d2WPfbzhBG2QgNxUb5MSHdmWsGKSZQ/c7nlQ7kR6IFXJndBUUdeKLneM+wGuaZaHxg9Wbq7XQhUGLaI8KW8eHnm9uc+6k72qmfBIhGkY8xhZeP8si6Jr7rlmbBjxGhnnBMuv/LmBDLhKqqdCl/tJfmAeLIX34Z104RjV//u4BTyY/I89kRxQiQeiXbtOl/3SWfZf4fQ2VS0iGfdOp0ZMDhSGVcnl6WhavJgEnR6gMW5L13PMwFo+0gqoIehwT9kM0CYEoayHY/D+c1OmLc17ShKW+3nAbWOnSA8i8fZuExdLwYShUWbPRPqnx2CbyqzmWnhno/ZE5jPZMpmdpMgkDtr+CeS6B+DkKgXOr+klvduNUwXhMkybW8s/xYiqqCD5V7SCDvRYm7hpQw/R3VXzGhGNyL5Q34AiOkSHEUUypqdyF9aabX7acUXCMlsDx3jhUIUVBQN9LqUcmVjK/PHHg84x8pYsW9bhS1MLP63jsHarh+C+PY2OTok8F5dPdH7dhWXGA1jpcvKaLgg/oSsrTNTPZUn+9sqOzRbB8+ipTOZSbG47o4Rj5ri3hdL32tV6q/R9USBYx7KIfgR1+Y77vEuExCVXIhy5L5qGQWi7b1zzQ6uRqHZf6b3O8WcAEBtA5KSOhAFeZLgUL7QXUVV6SJi55sM2p93TwAouhoNBtEj4DjUOkWqUHLy0pN4cM4Kz9Pk3CfpZ1CvWelMzv9O8hWpnccMu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 9:40 PM, Konstantin Khorenko wrote:
> copy_huge_pmd() reads a special PMD without the page table lock and
> copies that value to the child. The mmap write lock held by fork does
> not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
> lock.
> 
> The zap visits the parent VMA before the child's, as dup_mmap() links
> the child right after the parent in i_mmap. If it clears the parent PMD
> after fork has read it, and passes the child before fork copies it, the
> child keeps a mapping the driver has revoked, for example:
> 
> - vfio-pci: the child reaches the BAR after the device memory was
>   disabled or the device was reset, instead of getting SIGBUS;
> - panthor: the child maps the pages of an evicted buffer object after
>   the driver has released them.
> 
> The same branch deposits no page table under the copy. ppc64 in hash
> mode keeps the hash slot array of every huge PMD in that table, so the
> child dereferences a NULL table on the first hash fault, in
> __hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().
> 
> Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
> from a folio under them, as copy_present_ptes() does with
> vm_normal_page(). The zap clears the parent PMD under the same lock, so
> either fork finds it none and skips it, or the copy is in place before
> the zap reaches the child.
> 
> The copy of a PFN mapping then goes through the same tail as a folio:
> 
> - it gets a page table where the architecture needs one;
> - in a shared mapping it is marked clean in the child, as a PTE is;
> - in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
>   protected instead of a warning being printed.
> 
> Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
> Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

