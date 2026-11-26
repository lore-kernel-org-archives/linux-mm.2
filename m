Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40564606A338
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 08:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=VuVtHnGr
Received: by kanga.kvack.org (Postfix)
	id 5FF216B05B0; Thu, 26 Nov 2026 03:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE8A6B05B1; Thu, 26 Nov 2026 03:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47AF86B05B2; Thu, 26 Nov 2026 03:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC2E6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 03:21:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B3EB160327
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:21:10 +0000 (UTC)
X-FDA: 85476575100.26.585EE21
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8278C40007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:21:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VuVtHnGr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795681268;
	b=OLZXF8/J9EGRWegbbW2Tv04bqyOjcVQS2ZvYn+I0I8BdLcjr2oqZWnBeVh/U9akQX1i2Qs
	bvLVoOEJ8sZZxPFr4OcMyu1qkwd4hGN2AJ05P8FBv7aLksu9ybDi6FAJYsjRRqBa8gj6SB
	bG2Cp6iET3v4FJZFpiAMN8vTeYZOcio=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795681268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XMVDmbH25df5MhEApmqQitq30RsFa91wwEAJ21DK2s=;
	b=L3YD9PRGCS7JLnji5fMo8Ggz+xNaBfT4fGS1uV0Esadtuw3Yw4aQKJ1NVd98xsexhXAoFj
	xwxuqGfZSBqKLvsHBTlZnGI0w/lQt0SoZs/OStcUQ4J+d85b0S0WHKflQBoF/uQbHa8WfH
	xI1gaSn+4uxF6iwngPBtq1P6pZaefWA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VuVtHnGr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so5471369f8f.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795681267; x=1796286067; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5XMVDmbH25df5MhEApmqQitq30RsFa91wwEAJ21DK2s=;
        b=VuVtHnGrcLu2eOGv3vJCI5pyfq3cbbHjDEYvoJf1a/VsSwF7V8+TVAbBiCajpdgNyS
         AHW5ABus6XWJRxIL+IERRY8NM2lcSO4stkCF0GTM+rj3xPsRO7RcLzJwB6061Cqdce5T
         qTYWimicg4uejpVWErEeBnHhHdKq8icYzHdLGF7Xgkv+tmmj79ybzi7pELm2Hzey8hBW
         p/rCfpB3bJbVUp72hLvPXQY4UWMuCyd5wPkw0o9zDAdC6iGio2tFHWHfSaEQi4l3apDx
         AlCKBt8fKNBepIMUsiiFD1mAhokHhPo5BAnpDokOQfxKVsSLH9fJz5LC5Z3Ui4ol/TUI
         ijqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795681267; x=1796286067;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XMVDmbH25df5MhEApmqQitq30RsFa91wwEAJ21DK2s=;
        b=Z3G7j/T3PdX8vx531XEZofLqYXHTsCsjKfjCk1xUXqPOgVNC4Le25K5In2EwnBAhhO
         lQqg51g7KQcyqzwvCFXH8rQIsA65xQd4t2MCDzdbH5CxKY0+TDhGgWwrTNAbpCc4+ZdF
         xYkedGCZi+0/ko3+MU21uzaJ1NgIRFlwrz83yZwqUK6Dn59kUAGV7VazmCYjCqvX57mK
         xowpN+L3MjYvIxRVOQ5Ht2QhFJNu4qikWteoaaNvyUM1Njc1iJMe/0MByG57PkFk/Z+b
         gn4l5TjdsqMvbD8zLoPC8ZdfvV4rfyud6kvvxt9HfEYmtBHQg4lsGczH7T94mQTNc8o/
         lGuA==
X-Forwarded-Encrypted: i=1; AL+hErHcLZP8KO6V3hgKuSbPKdR9QoeL+4ykPIx/FqyhNFohm3QuQvAg7LUbKB+c3PdIQv/PzwonWWWHhA==@kvack.org
X-Gm-Message-State: APuU4Z/n83fdyFxTjnHHz1dWG7Y9tiKrHMwPl2tjoeBN8bmapEQksghf
	/dfbDkThUlx3JGeG6EZxZy008j+npl4iVEMFgFO80x5w58hgsxVW+mCWEKRpgD+UTFQ=
X-Gm-Gg: AZFdTZedQ8zDWdPyCZQwcJiLAvVJTA/4MxZ1kY5JM+4znaz57X5/5UBxKSVswlKJqZ9
	kzlBEcvtmg6yoTZFsqDNObdcF8tuj+2SwBnVio6n+8KPU4NToiyILNj4nuwqvYmPGGbRACi2CrB
	KtUe7CPuZ8rGlhB/OfI6TBy2UPU7IxcWL+hdYMWmLj5/nqqBb7HadnxAt1v7vESkdeInfE2qru1
	zU/uIRhgWZ4ZQ7DR2POoHLQVLIQE/z7mWX6FImwdKg4wzyJf3IPVTzglPUwaVzwJDQvmMeuK9dk
	pNDUPdIgpEOehQPmqPp6WTpiPqWWR6kUizTlzvUZq277Td0bAB44jkMrFGcXVtLzb1jyOLdszVf
	jfYmmW7MGrntWQDO/4+px1EYWlMtvwh3203/QLTnwZ4UGyvfobXTLjfB0PGf9OTXhn3rcG+5m0y
	AceppE8+ddioMMg66VnipBnihPFCcTNfopzrn8VCFWwc/HlsfSdeJlY4SJWQqweeGXvKrEooNbz
	CU18mClZK5OBjIlxfFxVHiRVZvK33aYrLPGHRs6GIjiCrDaemurY2Z2+gUiwW9R7anzOpnqG9+a
	e0xj5+qno7pFYJDzE0pdkZjPk4UGZ+QPg4olLapozr5S/7AvcYwjhgUfUA4RlA==
X-Received: by 2002:a5d:6f08:0:b0:4b7:7b8d:6b20 with SMTP id ffacd0b85a97d-4b77b8d6b73mr12609058f8f.46.1795681266888;
        Thu, 26 Nov 2026 00:21:06 -0800 (PST)
Received: from localhost (109-81-21-11.rct.o2.cz. [109.81.21.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67f1b2sm36108136f8f.25.2026.11.26.00.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 00:21:06 -0800 (PST)
Date: Thu, 26 Nov 2026 09:21:05 +0100
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Frank van der Linden <fvdl@google.com>,
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, Jiri Bohac <jbohac@suse.cz>,
	kexec@lists.infradead.org
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
Message-ID: <awfr8bnK7PQa6cyD@tiehlicka>
References: <20261125155108.24098-1-ekffu200098@gmail.com>
 <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8278C40007
X-Stat-Signature: pp43butyw8fikcan9tx6sur6jxxy5zkz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795681268-672067
X-HE-Meta: U2FsdGVkX1+vLXjCR12ZiEDEOYC0/jIvIj73CDGoSCxjHKNCamIYom41L1Yz5sVDE8pJ857qnr4p3zuaSAF6xBRNpm6wcH4TGjpdHmGB2rT2WoOEUYWQfAWnULBjjnkwW6PaK8StrfUxju213owemviaAdx4ztu15v4pKJkSDrF8nhHay/2oYynh6SJA/vg+IyBP1gjU+wsRxmgh5zCiOIltrr3qry0wMunwx4OJ/FCmUctEeWszHAhoctjuDru7GGhHwrA2FEQIiRwtNtMz0E5iXMzsMuPgHghoByhaQHbAFntz+ObysnQSV25ij7geoR8lvU9oqGJk0vpjqdXvM045Au2cTUL4Ijl3A7dGGFfcwdXGToAIKGBCssDAKZ5Hv7c/holhKZrLysthDo3jYmN8SnDJEDLAK6tIEtLIuwEED2QAfOPmm9F15jlOmT76nw5EAPTOlQrjkV7t+Nqo4eo8Er+KBUqzEZha11UWQUeRNNYpVEUeFmrLz5C9KmXeFivtPHLlM36p6VKdfJ8K+h1qg6yijHbJLAjuzezBNBnuvoYFqnqdJGB4Y+kSK/VAN1a3dX+r9Xy2i2alhyY5wHSS2vSTabx/axFMwofMuzCcD6HgpKohmCCheSnLLzSpEIic+g9JqYIE97CAf+Nj0JZeq7J63e5QkFKNOk1MKVxvot22kV2AZIPJTfU2APybD5oNkkOoxQe9NkivmlRcDCrvOYSJZ2qEU06QftQyJ8nLWp1k3x64ecRdmi3q15pPsbp4/8WoMU8lZn/bJihEjjO0HfLftfo8+ppacsBqzdJ1mU5rYEFgymvJXFHQWjLDGRZTr+5bqUfxSjZVTdppX7od8WUCqLtCGTlM/k8wf5dayinrKmxMn8AgtAcHk7OWHD3pVHh9BKCz/VDI321zFu1k2it8jrfJkxxzmBdgnHQayVWAaRH5Mvug7TdKEh000CIL9YPqFxVdnLMrJ+7
 iLdGnHXJ
 OKCBmjdYdUplajOtv2rcHBPvtLixTSm/BG7XgTGse6lA2as/c7MAYg9azEtOUv1dpAxTnE/mTv53ifNOja2DUsENAm8zJY7S0OlyVRwNVKlI9FW3CedbWOBfeyfV5Un3IHWI41+5pCvIL0c69PhJkhS83YmHXdekdBhcU3j95Hfvl531PH755pe4dakluWMz8jJFBUmUDlh4wre6Ec7BGRJZCkLhOJrbg1v7ie6or+dxXhq+ayQeyN2Sp8OKLZwWhonhCLfLWYccMjg0iSRfqiG+OaH5KnvL9JKQxjT/c0p/Y/Ttw+N5Zj0Vj2khYoqq6aNQPI93P+aGpEep0vgcVt3QmIj77Sei6ELM/7yaUQMCUrUcv9YWO5cNA3JJ1qgyOumQ9tCFhekbLK2NTj6cIpiYdKxG8MAP/kXyyksOT91X402oOHv7W2rU0WSfbeK11tSuLQMHykgnIekPEvoDcGRqzMWcAWgskFH8ZZVGaCmWigi7SAdwVsFN92hGdR1qteXs3lwg/bdYShPJ2/tilDCTM9qKEL3u7mh9xReEGSDSzcFe5DpIj+oHMbdPaXlKn2tEPIju/60B1TqTFFv6+u2RgOIf6JHyiMo9L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 23:43:40, David Hildenbrand wrote:
> On 11/25/26 16:51, Sang-Heon Jeon wrote:
> > crashkernel=size,cma uses existing hugetlb_cma memory, so
> > crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
> > from hugetlb_cma can be long-term pinned without being migrated.
> > 
> > After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
> > but a device can still write to a long-term pinned folio.
> > 
> > So reject long-term pins of HugeTLB folios overlapping
> > crashk_cma_ranges[].
> > 
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > The above scenario is only possible with the two patches below applied.
> > Currently only linux-next, which is targeting v7.5, has both of them.
> > 
> >   "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)
> 
> I think that's a real problem with this thing.
> 
> The solution is not to disallow long-term pinning. :/

Yes, I would tend to agree. While there is a risk of stale writes from
RDMA on long term pinned pages on the crash kernel I would simply advise
admins to not use cma backing for crash kernel on those setups unless
they are willing to live with unreliable dumping.

I can see how reusing hugetlb cmas might be really helpful for
crashkernel as this can consume a lot of memory and you rarely care
about the content in the crash kernel - same as any other userspace
memory.
-- 
Michal Hocko
SUSE Labs

