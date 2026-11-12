Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A163960A2630
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oIl0fASP
Received: by kanga.kvack.org (Postfix)
	id C02B36B05BE; Thu, 12 Nov 2026 05:09:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2476B05C1; Thu, 12 Nov 2026 05:09:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA1CA6B05C2; Thu, 12 Nov 2026 05:09:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80F8A6B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:09:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11B1AA04DC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:09:05 +0000 (UTC)
X-FDA: 85426043850.08.EF70D18
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 150F4140005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:09:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oIl0fASP;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794478143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xPCtd0ewEaMYLBvmRKUfVVx6VAZUS9abtar/G6UrVBQ=;
	b=rYiYYQyyT+uJE2GQYMuC8NQc4XJ5AoSOV9Vtv9gUnJmWkTqLCrEK+hxIRH5lY82Le/5Sqs
	mk3tkORX2pfGNqtrnpWEhn9uUwDdT81If403cMRBpQzbvV2c5hFaAA4UQ0y60XA7EawH8w
	SIeBjOBO4/2YSdDR+5KQew2nH5HWaO4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794478143;
	b=R0FadeqgRl7gclZVxxYWpRATH9eH+MsteQLBXHIACFr7cHSHnVgHXsZj76bfnSOYSHKuY8
	7PTvvZYpMEMcxgWNEt5hIp1P6w2ZUep6bJPUfs3yvlGWL8qhHnkG2naJAIkNrnlOzx5uN9
	+Doj5V1xcg3+vqxdlIUuGSzcAONGoxs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oIl0fASP;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-491aaed7565so2393482f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794478142; x=1795082942; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xPCtd0ewEaMYLBvmRKUfVVx6VAZUS9abtar/G6UrVBQ=;
        b=oIl0fASPgDP1JTUFcmBv4LVCstfNKw/qnXH9POiVTPnx3fSpx9W6do6wvfgmW210e3
         6lGU+OeJXGNUyTU8nwMfM12kv+TdmHq7Zz+EmJlcvgZznXDP84zL2Jh11+F2wpyIG72T
         o/ldfD0SdRrIC7CWLc1lfqbj8bsuPmQ5VrQit1YYbXKsUyP1hK41YANxHA7eNqpPtQi5
         Vi94tYLlliU5AlMThVISkp/GF2JCFn/IcCLnI+0+TwtcJ9sy61MRIieVDqexQXKTuvov
         /bv7DWlqMDyD6rA1HzLu8bQ2FDjzLWKxcb0ygQul4whqErIucYp8ULbkyIoSmtYBuQSj
         jmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794478142; x=1795082942;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xPCtd0ewEaMYLBvmRKUfVVx6VAZUS9abtar/G6UrVBQ=;
        b=mvEI0DhNN2qglOGTXPl1ZRJurS7VsaoJCOk0D2jaqXhpe0rYb0XYs+Ev5zMBtJil0e
         gCVsVYYRpSMVN+whdql+1MIi62xQXYtTbHqBX8dLKcdmWvEdW4whtsCfwT+kx6jMs26t
         cmEtyPRaz079jUxgTkhzmnoiiVL3NY9eogr3OoLwMsnr8f0sj/TNLfs5xPSg81VtEnsc
         z/I2P7E7PkEMEm/7NQwonxrSYigJwE2YDvNxBIcJR+SgclEBS8cIsrkSeH/d2+JwsoOg
         hTTujZGpxJ6NTXUJshEDgXRI+EpT/SIHHlEjUaHvXFzXXBcIItrYJqEme+zFlLZrmGD+
         b6eg==
X-Forwarded-Encrypted: i=1; AL+hErHlUW6MMB8BhcZ8Iz4m12FGV84o+/J0vSeR0kJhXkycs2vv0McrMWSa+B77kROGF0s/50jTFVe9/w==@kvack.org
X-Gm-Message-State: APuU4Z/WW+POvjpckMvGj9JHmwHBeG/4OnVON7BNL5PMl4uVwCAUhMhr
	0XoheZ6t+cR/Pg2A4nDwJ0YPaBflzoA8QO4MmRVvtpAAYnlhVY1BxxmJ
X-Gm-Gg: AYBFou2aD2gRLVfTvMNdZWO9bpzKkdMmS6HL7ANweEO8E/pn+xI7hmq1QXPsQ+xDGGR
	K82S8AjVH61UO4rDB7GW+KdN18GsdgRzcgqzyhLYp9LtpgrsNTHndWL/RJHmTCV6++KRZtWj4kq
	teSpNKrFHc6D93TwKxehyfxRBie0kzBcMpw3vcDSXo9rRB92r8FZHFK2T7DCPDh8HiNuV+Z88WI
	tAXRIWpE/y8+m/A0ei7YvFAwZvBA3dOm25LB6StyndTOM5fuKIRETt+GiNZA3UzVctWoKAXCjOw
	ttXQKCFtGmHvvLeQFw2p3okN5wCq5kgk5Vy/SoyOtkrmCwTx4xg8HSbYqFcJ0blsX7dEmdPfl62
	dVcLKe/ZZ6qi60w6C3z2UjVwNl2K41ORcKPcs0hVO/AtAhczJ6cIFI758Kx4zFAxaJkKz0inzH5
	0gfj+ZRiPBQvFGHI3xGERWLWN7g98Gk8XJDYNzZ92HItIkkH9hb7NIP8V/ZxSiWu+s/b3Ez/GF0
	3txtgeyJutuVEmO0WcrCGE1yy/K88W88qJnEtxOoGHXIM1n/8yIYsXyvFi5eIhJDzyEqqEy3Rb6
	xsv7iwIjcb0dYLKy62wE2P7K
X-Received: by 2002:a05:6000:4b06:b0:48e:7026:5243 with SMTP id ffacd0b85a97d-499c7270e9cmr8410567f8f.20.1794478141350;
        Thu, 12 Nov 2026 02:09:01 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983600bd6esm16211466f8f.28.2026.11.12.02.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 02:09:00 -0800 (PST)
Message-ID: <048ba947-e63c-4361-8982-b40372d4f062@gmail.com>
Date: Thu, 12 Nov 2026 11:08:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/huge_memory: use the large-page PAT encoding
 for huge pfn mappings
To: Eliav Farber <farbere@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, William Kucharski <william.kucharski@linux.dev>,
 Vishal Moola <vishal.moola@gmail.com>, Alex Williamson <alex@shazbot.org>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-5-farbere@amazon.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261112051440.16140-5-farbere@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8hxddy3o91rfcq77i19dfomdkrr57jw
X-Rspamd-Queue-Id: 150F4140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794478142-863163
X-HE-Meta: U2FsdGVkX1+H/zqRPTrzsmNEXiV53I1VDXJb3K4V4nFfJuvXduo6+IdkTV1dzQTWKy+Cebk8QNoane7wYiZJEUxn60ILN5bLE9Dfm0BSCR4p7gedeEgN47vyeKM3UKG0RlxwyVUXKCIW4yAdJFJzFDHkr/sC0pbQ4BJFuovxiEjCBYUVHgALH15eMIze+dhoDfNuiSM1hlyzO5fsdKSzsU0nJ5uOhInmbRXDnrSNc+RF/i170zCxjW/Zgw8qkBMcSOtaBY0m6iW4R9PIslx56YGfXw9yEOug2yQsR4eCG69PwAm5RvE0UcIzj4Znq38V2Em9rnF3GVw1RpZsca2r5CmHniJw5fA9tnE9lIDUN9x5Ls8IQR4Joegy2Par1KhzgJUVveOvLyaiaG+ZpiQM428GNjy3ntaHq3URwK/Y1lYBDIPrhucPyKUUDDCUCljPrXP+X/PdZDxFzmPnQKml9IeoBDAkPqv5DxlvIJKweGA+wH0YRGNUDdyxSK1TB8HX254K4gbBZsvu8JEGA+rsDO4TcGr45Lc/a7jZTWkuhm5wNmugGVMz13Yx1/JH3w3r/eOqi2A/O8fzvNN1QKCfXpNYuMqyeAZlR/twkcKGUl91cucqhw9wCzVCtG1EeS++cHZaseLTxVEI8X0672TnUWzRt2EWaRQdfqmDVMTv11RXgCAsVZ+3EXSQPxsSEy4GJadA/VJ6QuyK1qpATyZYaIdRxEt1pYb/dHAh8wvcUVntJNwYCxr9dBbSYAG/U2BCHdx2RmLtZeQwAn7xhruknOzXBhHXIShMlRio5J1L90yY0KIYiWFUkFvZ9bmii4i9S9larh1GWv56Qft7O6kw15b9h6yPp08f54Hcs64lySeyZD7LenOiYYV21UJ8X0temTcK/KYSC6kDNhRXKAn4CF5qo0Yq1autujhBYebIayednL2YU8oaIPemaP8UFyDx5YIu1EcS6Gjya1QPOB2
 PaI7jZSQ
 JV8Hz99O4Jp4ESSSSRcIpw540u+eT5flA/FWNrzUMBS9juCgPbhrdYMuKrl9bfvy8Yd1fh/jq7RRkFa0m6ltF+vDmSpB7eTy44VzhEiajNKsRhECqfMVS5o9dmjvZULupuWXSYd6i5vWgO7A+YlSNTwHVOIa6SiknBecvGJPU3i9Am3DaFYzLkSlUmlVcLwMoTNkgtGhzHdONWLiC4SIHlFg8TBmPQaQQIW0W/IC423C4pOlyab07WmJ5+jOqDp7CUAJNKgXCfMeNv8s1/RgaRlhPm7qCsNU/tlqNZE1I6AKOMzi2yfut2eI4Ai8ig8Ha5pGpeAcCuCPocNKZgn5a1jMhyb1bzsyOYdxtByrzdCKPHGNhI7eD+oloC4cU9yAL1pSKGlxOYHDQ7ashHSW0yQFtGzuBKgAbtqjJ5fQNNUVUstg+ui3qsD8AfBF05vKUD0yGEftD9hv7hBfQL26yHZGqWuu0GkKJVgvTRZco3JAMuC7boATtOxYhG3PmL1Q0xDh8DuS329jFispRWKKP1/0oxApBysf4+zoacEFYgjxbWFy96sK7KYyTNlnTLF5IyQCaqZJwoa0ushM89unB2zebkJRh2IGTcCwMxefnk3PnIfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 6:14 AM, Eliav Farber wrote:
> insert_pmd() and insert_pud() build the entry from the pgprot that
> vmf_insert_pfn_pmd()/_pud() took from vma->vm_page_prot and passed
> through pfnmap_setup_cachemode_pfn(). That pgprot carries the PTE-level
> cache mode encoding, but x86 keeps the high PAT bit at bit 7 for a PTE
> (_PAGE_BIT_PAT) and at bit 12 for a PMD or PUD (_PAGE_BIT_PAT_LARGE),
> where bit 7 is _PAGE_PSE.
> 
> A memtype that needs that bit, write-through or write-protect, loses it:
> the cache mode index of the huge entry drops from 4-7 to 0-3. With the
> PAT slots Linux programs, write-through (slot 7) becomes UC (slot 3),
> and write-protect (slot 5) becomes write-combining (slot 1), which loses
> the write protection. The other x86 paths that build a large entry from
> a PTE pgprot convert it first, see populate_pmd() and populate_pud().
> 
> Convert in the two huge pfn paths. Add a generic pgprot_4k_2_large()
> that returns its argument unchanged, so that only architectures which
> encode the levels differently have to define it, and x86's existing
> definition is picked up.
> 
> The folio paths keep using vma->vm_page_prot as is. They map
> struct-page-backed memory, which x86 maps write-back.
> 
> Fixes: 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()")
> Signed-off-by: Eliav Farber <farbere@amazon.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

