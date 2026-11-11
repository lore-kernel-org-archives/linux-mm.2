Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ADC1606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 16:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DNUgV8Og
Received: by kanga.kvack.org (Postfix)
	id 74EBE6B05B3; Wed, 11 Nov 2026 11:52:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7A56B05B4; Wed, 11 Nov 2026 11:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FCE6B05B5; Wed, 11 Nov 2026 11:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29F6E6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:52:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C122BA7E39
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:52:39 +0000 (UTC)
X-FDA: 85423432038.25.1D5EC54
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id D424B14000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:52:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DNUgV8Og;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794415957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkZUJWdT/s5JOCVNB0A7LbBvMJ84RVXohV1PrRaEdAo=;
	b=rlKA/03RzA5eOBKRdPH45E9EeGlmc5qEugkDJw/Ys7XO5ah1JzWv5Kf3MRDRGr/S1Zt7ah
	xcBT+F1y9cLAHSNEU2ZIJmdZadEpNHZrPs6Y55Czpf6mBTql2Ss9VTMhHNaHgdkd5tGew6
	XmOrYLKPQ9eEDsobyibd2VqqaE3UGAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794415957;
	b=0uO7qBTO7SDnYbQULF8Yi9/Kt/aIjc6drfaOuEICrdVo/bnTDi8saPjLDCpilEtrPdSps8
	uOq7Le3RCIUZZ28wWmWaZ0404qQ8P2US73OXdCJTezW3aTjDu05H0uXjlrwA6YTUL7FMpu
	LNAezE62hMoZNdxFaVJSEOEzsUNrWB4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=DNUgV8Og;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-49318428d98so1843484f8f.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794415956; x=1795020756; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkZUJWdT/s5JOCVNB0A7LbBvMJ84RVXohV1PrRaEdAo=;
        b=DNUgV8OgZYjuPFHr/5aXhrYx/V/GGhFT91J948E9VoyOU88JZz3RpkkSHF/AkIEiqW
         lsLnr/hoXdvbBGnUZrraETdVsFKMGFF4DNULZj7ESOwxiJzpJmPmUcZwSH8G6QgKpUBE
         NtVej4tsY454myLQEammc9g6Vvrvkh/jxYIfCOnjQ5+ukanqRYhe208LkqYcVaKIAdrY
         0GdzqqBoLMLYzeGaS51LyoEMIU4Nd+Umm4cbnI90YBeVA0pN8ptyCmkQwF2r1eKCcHvj
         HZ+Th9hwO00xGFB2MCgKBDD0jkipvmgCjOLH2WsuJxGezJFzsZT3EtqCZ7P928zX0UxA
         J1KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415956; x=1795020756;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OkZUJWdT/s5JOCVNB0A7LbBvMJ84RVXohV1PrRaEdAo=;
        b=q91A8ETFQpVvbNfrKnHrnmA/yqlhQswPQ5n41BSkcuTs7DrXhoBTJFWIr6baFYhDmk
         tZ4cyVKesn47m1793SaYDhquU/04wAzGhslBW1RSkvLoXEUE14D++cYoWxl8jx9MLDAE
         vJ6xSv+JEBmelCyx50VlG/wA9bVhbQe4y3J4cEw+/0sPt7taKUtLE4y9rBCxSuH+BUby
         duNDnwXoozPoeyNkkbiCciClcPTj12WJEbDF/NkjCAnfYDCwfxXn+caH+uwr2ou5MjX2
         37JuPMTCcAbQQhukzMocceGI9C5UUFwpUkDl7MT4nyCrst0UHd1IfYeEXsghpQMRkcuU
         OsTQ==
X-Forwarded-Encrypted: i=1; AL+hErE4/aAhx3ol52GL79HbokrTU2h6ZBTIHeGPeXSo8keQmk9iMFF3vkWf7/LP8GSje10x5PQVCy2UUg==@kvack.org
X-Gm-Message-State: APuU4Z+U/RyeQMsIQCHSSfjO3uWJBZp/UC+ke6sgGPpkaXLzXi8/ft80
	jkgVFbS6ilH4nKF/WnxznWinH8EXwJHL81GtdPsUkO1FNkdEaljihR52
X-Gm-Gg: AYBFou2kshTmEMpeUYPETVA0nDxlotKT8qDjRDj3Yc78rbpLfVXJTu/JZjKLEXT6BPu
	ezaWWhUxUN10I8mKuxEhryCZBoyyluAGjjXV1IrS+XXVMNKq9dWQ7MyHbN+hTKtUwUVtAv52lTG
	PWG3GbKSJp/jzaFjepPKSOwGFRAQkbjwiOhhQgurZ1w3ftrtuBv/pLo7bgfXKta6wWw7m/eqhvg
	5qIqAOycrjClCuDqCBENSWosnVN3ajxF44QXTi8WbBohjPbiFzmqdPR3MIn6TUMWQPWrXF+Advx
	/ujvJOc1UJ+7SXkVreIlG1hyya/eYzI50DHNtH1kH6oxmfm6Ix2vYI5+ceJNPo0ghTVrUIh7N42
	z1YpJBkBksDFI1TdCKkM0xW+JbpeHjAp8DP7POPi16UAo3KQ53GOx8ggu88pQFK3nd8IMV8AaqN
	HARnM1h+8X9scjI5sozTAvaztpomLFxgQ7oWFKTGVIUhQZxylQyk8L8i4Vm0bBqUJ5/Bsjc47zQ
	ye6TpUZzkD0L1zla9oAdHUZn1it2MAu90z1Do/Pem7q3iCYNjexShIHjk5hsyK7XwuLHGbWwKQQ
	9DbhXSepLsyG+2Rc2n9klsLYhkhDKlafueHY+PCO64kwYOJxZimUEiG/QDgmaQiNwDYC
X-Received: by 2002:a05:6000:25c1:b0:48e:720a:ccaf with SMTP id ffacd0b85a97d-499c38bb2c8mr5760029f8f.5.1794415956141;
        Wed, 11 Nov 2026 08:52:36 -0800 (PST)
Received: from [172.31.15.113] (6.red-83-60-147.dynamicip.rima-tde.net. [83.60.147.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498363dffa1sm11516874f8f.39.2026.11.11.08.52.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:52:35 -0800 (PST)
Message-ID: <9d4ce24b-7799-4d71-84ae-983028366ae1@gmail.com>
Date: Wed, 11 Nov 2026 17:52:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: drop the huge PMD assertion from walk_to_pmd()
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261111140655.34281-1-farbere@amazon.com>
 <20261111140655.34281-2-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261111140655.34281-2-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: gkf34rf6pt5fpzc6a3z7uc9f4y9n6fkw
X-Rspamd-Queue-Id: D424B14000E
X-Rspam-User: 
X-HE-Tag: 1794415957-352994
X-HE-Meta: U2FsdGVkX189GBXwowco8h9xMCBSNsyvETsv+bMIL2zDtsm+iH5+RMsQ49DjVvJu+8yvsLzc8rYwtom3g9KklZad9Ac9EDds+jbzs1f5hbS8Al1fq/ZKislp2CkP8Uq/nFsoZFuaKbzv5LeA4QDlA/RP/jMSbrgQpz6hkLg5O4JbZpFHAd8RlVbjfIyTAoVrdvS/UMhg6ZBKWUUWgETuvbH+swlh07Fg7cuiM6TQIoBl+ckR8cCTFSdAESdqp5MYHn8Dgsb/MkqNSHj4wB2vhFYgLTChF7RvP6Xnm40W+u8IpbT3jL3MnEffgggip1OrYQRnYPE42USrfsMqTRslIFFeD33lc2ha25PRULIj0Gl8U9hoBTrMS+X3ZZ75fVkVzfWLUm59JMKnxHT826L0Ku2trat+snBYVSX+SkdO1PocNFC+4YAQ3x6rOddWdV3TBeX+zreq7w8mxOr1Aahff2SQ/cpuOnprGj1lSJByfnfVRs55AmIxH3qO2tUI15Po+wrhUFj0Cu918EPqPfRrwVQlhdbnoo57J4stEwYyeWIZoX4U+eUNK3wC7h9RPwFI66dCzPqBURyDm9IU1zcCNDd39dcu9N+e6t7fRJJY02YgVFNaCRi400yQ/31KwA6lGHlnAWWkh6aHQxYaIzp0V4ZLwWmU2VLOnGhqilG5mTah1C/ZcAwD3JAR6ceKQyXBFjRr6dbDgd0cS4J80kk6X/gmeW99JeVgnelZJnYBpMHeN7SKM4JAOD560ExNEoOP8N5Bqfza4l+LADO/OIU0ZOKHok4tolMdIzJEKHKa8YmaAGmT5WOigXql2Lq9+xLrxuF7bk0kykb37J3fhwVDliGQt96XvziA5ht1XTIvbNVgJUnJ7BN6tfWtFZVxmWuSXiuBTgaRxi2y31zoVzsVKdkBe73xxlsCOxVlchyAYBFWAQz68CdYoldTZBgrt5zm/W462JMD6pWd1Ate9ly
 iDDe+ZaB
 UOLEt6cibnxxtN9bP70/AS8hJf10LaQWzbP5GA1fXsoQFFeetdCJGjMywnO6B2QskKESH3XwvsQdq0igUIJ6JinywpVxK1YdEGx+v3EseuIzFKCFJYlOtN6RFK+PqQThpl6bJags/6Go4ADVzTrZWkhuwA/eSTylNGXY9YbEbtIytmS+dRydK0Dv90xJu+Jotr6XcDJETBoJse+yJMuDQtBsMk8Wyz9FpN7IDR9qEwdhN+w0A8wksH/hQsTgUqcC6niIg6n51sgGnGZd2lo/qXNNFHSjxv7kilMJ/8uwuz5FDlfFsjs8Ci768LfZzhw9jSbwSliYN4jZVxCoZaajImauo51rd1nUe/TAfK+Jq33d575gLM5NJLfmj+vUYHzkrQPJ9rSG8KKf89utQGqnLExAjd8yFzetdQYXM0QhE4IgfoF9v9HWvN84lz8k3peLkSHsK8pvp9mKGAXcN83A3m4hgvCsR6dcnIlga/SaEpGgitUPjzTMidxDK10h1OTlsH56OWaUulNmy3Y5feVUCe2glxu1IH89bSqyzjGg46muDNzK1MjI5c+JOmwQaOfujuDtIywMdJ9wQymFosMzTP8XOtYKpzLX7HbexQIcEB63Z+ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 3:06 PM, Eliav Farber wrote:
> walk_to_pmd() asserts that the PMD it returns is not a huge entry. That
> held when commit c2febafc6773 ("mm: convert generic code to 5-level
> paging") added the assertion: nothing installed a huge PMD over the
> mappings its callers walk.
> 
> ARCH_SUPPORTS_HUGE_PFNMAP changed that. A VM_PFNMAP mapping whose driver
> provides both ->fault and ->huge_fault can have a PMD leaf installed by a
> concurrent huge fault over the same address, so a caller can observe one
> and BUG on CONFIG_DEBUG_VM=y.
> 
> The walk does not need the invariant. pmd_alloc() only allocates when the
> PUD is empty and otherwise returns pmd_offset(), so a leaf is returned
> rather than overwritten. Every caller already copes with one, because
> they all reach pte_offset_map_lock(), which refuses to walk a leaf and
> returns NULL: insert_pages() turns that into -EFAULT, get_locked_pte()
> passes the NULL to its callers, and insert_pfn() returns a fault code.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Signed-off-by: Eliav Farber <farbere@amazon.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

