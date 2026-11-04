Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3BE7606D833
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LlfqztJt
Received: by kanga.kvack.org (Postfix)
	id 0AEB46B00EF; Wed,  4 Nov 2026 18:05:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0864D6B05B0; Wed,  4 Nov 2026 18:05:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF156B05B4; Wed,  4 Nov 2026 18:05:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9AA96B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:05:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5AF7AA863A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:05:45 +0000 (UTC)
X-FDA: 85398970650.26.53C7DAA
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 737F41C000D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:05:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LlfqztJt;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793833543;
	b=5YuxU8p0iJWO/rCKXH8Q3GficFo144D9LWMpGEQ8CwreL1R967gybSd+NrYg9lKLqJ3Hd8
	LKG951DgPoSK0p2BL9Im1QEgU/e9NlPx1zhLDlz0veN2dczDgn7isC0NDgx0sDsdGEv8PC
	yDiQz50sZEi+/KZqHNaDGLYyP3H3WwI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LlfqztJt;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793833543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOpStKtlaMBvTw82l7hk12nLoKUsFYT90GYDj+kAndo=;
	b=PXG1xSXIsiGOzyReCOucgVPINE2fui/Tpog/1+zgyop4RX+SYKdlWOPFgu1hN8lwucCFHD
	CUGFbLkd0zuCn6pULzyscIYq5CLI5qtOuxhwo0+cEHtsyn3GBDmO8r4F/6PT8nEjLcX+Zp
	rSWvDHeag8Z+J/liECAX5yXFhflqN80=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so9421075e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833542; x=1794438342; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MOpStKtlaMBvTw82l7hk12nLoKUsFYT90GYDj+kAndo=;
        b=LlfqztJt9QRKdt7J22srM5caleOseHDPlmgxuV9PDvYClu8MKHX3TjR1cZQc/aLqX2
         IhJ9sj+ehkpXxsUoLtxHGj7Hg2SjL5oWBzlSRQtYUNOW3ibHz44l4e3qVr1VnauCPDNR
         ZWuuvkV6x7avjkFM/yryYhXol1RRN0h7xnqTo2OBBncLmWRQRS6WQlFsoYX6YPdq/rrW
         05y/z2JjwkXGmjrLXqTVgZCTPrdpjNN4TQvxHx6R0ii/mgmy6c+EEgPsmZOa8JQfuV4X
         RXCeUPvHPGk0u6WeeQfmgEWatU3jsG98K906e7N056vsoDZLR8FPCNBD7HbxLrcDxnrZ
         EbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833542; x=1794438342;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MOpStKtlaMBvTw82l7hk12nLoKUsFYT90GYDj+kAndo=;
        b=Q/tMi5C/69ib6j0JbO/DNwK1J6PaO6yDF/rcsYjChnNbI+cSfmH4Pl7cCFHhEIOiHf
         wQ3/MEjwjGrnrEiF0AFP+1prnQfm54gJwKrjPJOFbGAfdSQi+UfNqCnQjP1xG2q92FOu
         tdJTz1dhsJBC5mR6Zr251PyPhNhSb8QZ4jPkun5fztcqWeBs0YIcbON7O4KpELMrxyHX
         iWPeB12am1z9LNbRLlSNKGcr8qoZcaCBD+5Wsnb7gQsDAiMbfemTQf4IllUxktEMWufC
         newPcExXwmAgbCKofzHlUOlwDKy9msIQnD1q50ZnBWTa3L/uIWyvrallx9h46M+PXrrs
         +aOQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxlXxUFSGq3vFrXBqnviKvffQvL0Y5SsdC+CKIqQxcJAL8nVRnK12ARiwiOuAlD0pxn7roogGZHA==@kvack.org
X-Gm-Message-State: APuU4Z/0SAYJquGlhWpkwWTQDR71Qg5NLoqKynM+yKDJGxximHjp/1j9
	hGB0ek2Khb2KaQI3+OZDlVm0GbGBA6KZoeff/80bOhQUsFqF6VCuCMO2
X-Gm-Gg: AYBFou2of4wi31dZ1a+SWc/ChQtoj5kFxxqAb6ytMV4Td+SB2yOnAtes4FGw0zJ6/JD
	8ugpsgP5+RuY3r4vKjb8VWXlK1QXGLdXv2pWjSq0sYCiCt980iSIT3ON6bzMekpRZDYDhqdP+Ed
	cSv5fRgx6f5cv7v9cCu836xcxPmHCq2XMqeVsIQf3DP/gGls4Gf2NTZ1QcakIO4jBe2kHj8/KkB
	4NUr6asbm0Zxalww0Eyw15AXQXN/GGRupi5dZksQrzoSub2vpthKMUCYSOtzgwHOGaIZYsCEdII
	Q74VZ1xlCnPVShly2a32A38HHIaFktOuiVsLHCzht+Fwt3rzchwCv0kvGfpK0wF9QDlyqI7MG1v
	AyWs3vftcno+txQ1ec6lwkJKCK+zI3oLPaTj114ENpA4KZ7RE3bjWa3fQZr7qI83Mg2EF1XMatg
	+6gfzIqYfleuESxC3G57qNhypk6ihGmTS41cmBFyzHB4vsI+G/zaATZ++869U2snohjpsfkX0qb
	YIrweLitbRv+857ytdv7XuW9nxlBO3eRQQ3w7JET5tm0L/7kI2UMh0eHKUxXT8p4hTAGnaaV+qB
	OZiXwCr2HrWoGt0zTh/1Nwg=
X-Received: by 2002:a05:600c:19d1:b0:4a2:677:ad8e with SMTP id 5b1f17b1804b1-4ac1970b9f7mr379985715e9.34.1793833541916;
        Wed, 04 Nov 2026 15:05:41 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed5538basm5998977f8f.44.2026.11.04.15.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 15:05:40 -0800 (PST)
Message-ID: <853a133d-f332-47dc-b7f3-eb57f34d9344@gmail.com>
Date: Thu, 5 Nov 2026 00:05:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] mm/huge_memory: copy file THPs at fork like
 copy_present_ptes() does
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
 stable@vger.kernel.org
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
 <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-2-c56d0d26f970@virtuozzo.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-2-c56d0d26f970@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d7b4pd7gu864994h5sftfwxqei59jkm5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 737F41C000D
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793833543-140346
X-HE-Meta: U2FsdGVkX1/Nqe4Vb3Cv1cOBv7k7ftIgfjl7a7LX1VqHpRyj0o1pDfJTRYkHGP5uX4NNZYpFfEf2gQnkkAjGmFhs6Hj02YOwP2JRP7qCQEt56eOZyDv0uCuJt9xXn7kYMPVhsrUM138OBOeqXMr0UI8U11p5FoziWgSHGxRbS2gki0QC6BZxwn4ZUE0EKYm5d3p88A9t3oJTqH1U1lHPytc2V67fd058vy5I6NvzJoBvHT65gtizgiVeSDs2+vwwvmEn0l9ApVvsi86XphEp5asEbf22w4d8zy5GzhsWOn7fdHxr6BYj9pvHeh0Zyb0bJvOG4fZOM3pnW0iba4eRAASfhPUZfoyG1hclPVS/SvOtK9iGkAZsWaiO4q7H78kq0pgJDdwaekGvCLbD731Q9vxwGQDskSksP15T5CoUQfdqkWD7IE/xhSqP37hWeapxLaLV0HG04RtFreZxYu6KEPbcCr0qEUYKBOUqNirwqTqbpXpXbcDChHxEVr7hcAj5zSKS+LdGWdBmoiAaMK3QauH2YeMWGVndQY5cXIKKuZzfmnaMLIT6ZUF5x2Z0WPYej1ow73e/cU0xC1bVpnhM/cbcLZDvzXTOvqV4koqnMklXbcUTHzCn8c3N/d1nOqCMJfDVuHaKfn8nFXTxmWC37d/3VCfLbkL/QiEmU1af9uuBj2Xe4P2ipUBgQWJNhQSdw7xrzIhZPhhlb7iwnpg1kXPurTGhAHbHtvPolJi+C96obDSzeFX5BaEv5SjtDIOeQTr4mZ24egfBQNeHnAvh5nRdOkNEllUNWOsLQzZzAdu5h7WkII+aDjeEltyHd318v8o89VWYSaXg0ckgocKu9sZxC6QST3ftJ8UQVuAdSC2adlcWJgWXWvkpgy1gkMgA0ZjtPzIWh20OQUP5w7cyK9ftZFn/2fPLItKYOtGhwoLEk5pUmx6w4G293tdbmfTsJaobfP5HaAmGOjr/EcA
 R0h+xtfy
 tq0eII2R8XN1tO/DDPr9slfn92oViwq18vu4cjbymbyDsWqz1VuWHADbl/HOtfYQtLztVgyRIzDZSffOKv0TA6uP4UnFZNIJYoMe1skIwsAWQUg6NR1Vgs8zu+UvrlKDcMOLngnmn7dzuSx6HwKnlURJFyPlfI+JgKOmKf5U3+lU9W0dckNdeZjKYLIhg+izgNSzfPhPWUIbjelEIWqitDmgzhNppN6m+U1HlEk2KFNdl711Lt2ZvXQ7az+JlQ4FAcuxgWYMX/2DCW4JuswOV1/nrqyE006LYwBCbIQebnIu+KeJr5DaWbDhA0FcZ4UYoGsyMQHRgT8XQce7p/RvkDQwyacXYzO79uItmQZnSuvaeyHVGgVSmFnOesho9i2zdm1Lf2YGgai9+Eo+SMkWIF14kvDnRmUj4fhjtKrwZtaqh5dXqw2vyBgLb3NSifRAfgE4Pfn18eamWcCBRsyjyQw4lD1OJSyA/E/lPf7KvagsLO7YexVuIxmHSj7Vo70TAUOUlPrY5zCXC/WixG+VRiq59/OkuMXMcvOT6VQYYH4Zeb1eLspMB2+s1Jg3+74FwSxZSDDK18Aq8GBcpMvHIrd3nLmqowNct0r16uB3OlPVGUivllbV/ImlWjDCzMhXYd1Mts2Ui5pgs9S+00E4JL1L5FNfr/WnblGvt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 9:40 PM, Konstantin Khorenko wrote:
> This fixes no bug: it makes fork copy a PMD the way copy_present_ptes()
> copies a PTE. Until now copy_huge_pmd() skipped every folio PMD of a
> non-anonymous VMA and left the child to fault them in again, while the
> PTEs of the same VMA are copied.
> 
> Treat file folios as the PTE path does: take a reference, duplicate the
> rmap and account them. fork then pays a reference and an rmap update
> per PMD, and saves the child a fault per PMD it touches. The next patch
> sends PFN mappings through the same tail.
> 
> That covers the VMAs vma_needs_copy() sends here:
> 
> - private file mappings with an anon_vma;
> - VM_COPY_ON_FORK ones: uffd-wp and uffd-rwp, VM_MIXEDMAP, and
>   VM_MAYBE_GUARD, which shared shmem, file and DAX mappings get from a
>   guard region.
> 
> The DAX huge zero PMD is copied too, with a reference taken by
> mm_get_huge_zero_folio() as for anonymous VMAs. A migration entry of a
> file folio is copied and accounted like copy_nonpresent_pte() does, and
> made read-only in both processes only in a CoW mapping. A device
> private entry gets the same CoW check, as in copy_nonpresent_pte().
> 
> The copy then gets the same tail as __copy_present_ptes(): write
> protect both sides in a CoW mapping, mark the child's copy clean in a
> shared one, and drop the uffd-wp bit where the child is not armed. An
> anonymous THP is now write protected only when its PMD is writable, as
> a PTE is.
> 
> A page table is deposited under the copy where the fault paths deposit
> one: in anonymous VMAs, and wherever the architecture needs one.
> 
> Cc: stable@vger.kernel.org # needed by the next patch
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

