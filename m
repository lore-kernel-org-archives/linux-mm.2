Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8D0D711CE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F426B0089; Thu, 18 Dec 2025 19:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C7226B008A; Thu, 18 Dec 2025 19:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554126B008C; Thu, 18 Dec 2025 19:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 451676B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:21:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECAA58A7FA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:21:38 +0000 (UTC)
X-FDA: 84234317076.10.B7B447D
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id E383420002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:21:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L5S39WJM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766103697; a=rsa-sha256;
	cv=none;
	b=RjmZF1e1FkyEwZhN4fFPxtOm5MayTAYhwqtgMyu1lLjxazuZ9w1euctUvSgBr0o86DMRR7
	Xo2KYQUibNAnSYIy7yQXWIZ73uNVGiIdAHj2SPqU2SXv0W0jPBrzP0ozWsjWW1Akl+Bx6H
	fqOVZbMuQfpR7tV5XUadatkYphp2B3U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L5S39WJM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766103697;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqnJvZuDAhLr9ahmo6wXTWz98EHIguuClxuFq2i5FBk=;
	b=CHEbwFKcnyLregLpmBBfJb1IuofalTUBY1A+m8R+ToT7vQ+mg7mXX9locxsCo6y9qRbGHQ
	/L86yYXYNSeBflm48JeMlUMocUm4UqmYQI9V7KQyr9KyFyNsYZcX0V2b6XseHo5qEwkkap
	2/t6atiizWEWVeaFfhQdYVuXCqteimk=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b735e278fa1so223471266b.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766103695; x=1766708495; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqnJvZuDAhLr9ahmo6wXTWz98EHIguuClxuFq2i5FBk=;
        b=L5S39WJMM97o6XJJghYteZCqzTDLE23xZwVF7e6Y61jQWAtii21y4nXqTrNo0AB6Ke
         4WaXEbIiMT2XosztpL/6KJFPfkFY+jsYqcE+KSsefynUQZ7ErGp5eVoN2REUsmSKtrrD
         EiRPybd34bAN3id9FYM/khiDnaLWh0T+4o/PapYNgOA/rf+kZNmhQ1vJYdL4TSICrgaq
         CsGhOBCTeO8jLOLXlQtZqhUt0QsQNxgM8Cffzwh9Mvd4sADFdexsNDBLck6pw/HgWou1
         5rENYzU2v6aJ/t4DUfhh4sS9c4ndNtS38smhbWjiqShK3rGmCyN90qLQySFawuUFBXV0
         oqqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766103695; x=1766708495;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MqnJvZuDAhLr9ahmo6wXTWz98EHIguuClxuFq2i5FBk=;
        b=jV+kP2SkXy6hWOa5e02ZK+ihQ5zc5cVkOzSJlCMpbt3HEXEnUn4LsmjH2o6mRcroVk
         k1u7CWN70e3nOPh3nFy8ORZje1nAzX3ihe+t31TxOS8xvsbh9HzcU6iNd7gPfKcuOMw7
         KihjrvoM8pyU4iIjye/DkoUV+hIDEjvte2mVuOV0IQtC04jKHgTbGfOEG5eCQXscldlI
         nzXVO9fwFXUiBp92e3vIoyw+rQ7tQ31kbyl8bPYAau7klVjq8Ti8Pkrl6wmUGra3CJmM
         wela6LgiR+SIsFx/bFdiauYjP2WphvvuOLxatjToPpx6OF79ZzamL+bGQWEkzpSonZQ2
         VRVg==
X-Forwarded-Encrypted: i=1; AJvYcCXhqt1pp4sQOH29D6GyI6slJt5qlte9S/s1hfYM25v5gXmutTTWiN7Ab8XaivPSCt4TOKLianv+FA==@kvack.org
X-Gm-Message-State: AOJu0YzUzAOKUS5WeqcDpnkCP2knH2WanO9iT3BN8d6fZweWkEJ/23Ls
	olQ7UssAlggnQlPze6bCYYCZsSRpjAB+OrvFtkXbqtmbSZgrclHO6AW9
X-Gm-Gg: AY/fxX76Gvz+ArXrc3sx2+ZdFhVYUz/4BBO22JhuLdr77itQKkd8GXIfMQCvPzG7bOT
	cWTLsQlo4WEpbOyEIoMwNIijA1/LyeGBh6xpFg9RIs+HzkI1t4HG75zm2Smp0jO1zLRpRkpyaOI
	iadGwk0xVVlXiV5VT8rUP+RoC1Ph6Xk7k1cPQgjQu97vvdYM+Q0DQ1MBw8bK3/pIKmOzjfzYZHK
	akngrfr/VKGBqzoVHtl41jGQPdjNAOgbLWtZTfpnI9u+frh+VkaobTl2C08ZMgWT1Lo4n4Zgat3
	QChhIDruAxS2TF3XnL2jNbPkGB5FiKtvv5zRrcGVAKLqfRxIu/eZggEn0iN2UJgyZOB3qJ7yp2O
	wmXVYVIIb1/r0y6RxBqnVOdNZMyF6HwIXyIxh8Ci3v1qCDh5p1s8mxiBrq5wwI8fsyr0DjQZaL+
	rfDOD8VDednA==
X-Google-Smtp-Source: AGHT+IHjCVy/tl38KId+ziTUgW5tLSsVdBoDRJeXfm+nWcc1y8jFZ9nAzDbBgJ6b95d9xHaO3lmZMQ==
X-Received: by 2002:a17:907:9408:b0:b73:6998:7bce with SMTP id a640c23a62f3a-b8037152a19mr111138766b.33.1766103695157;
        Thu, 18 Dec 2025 16:21:35 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f51a74sm74641966b.63.2025.12.18.16.21.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Dec 2025 16:21:34 -0800 (PST)
Date: Fri, 19 Dec 2025 00:21:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Bijan Tabatabai <bijan311@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, shivankg@amd.com,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH] mm: Consider non-anon swap cache folios in
 folio_expected_ref_count()
Message-ID: <20251219002134.uqgtnr43zz7vvvtd@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251216200727.2360228-1-bijan311@gmail.com>
 <6b4cadb2-6246-48cc-9c76-64ba0a23198b@kernel.org>
 <0C218C18-916B-4BB0-8B37-AC82503E4AD9@nvidia.com>
 <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47adffe-b2c6-4d86-a970-b31c2e620146@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E383420002
X-Stat-Signature: nmbh3bz37k8e5116eym71f87j6apw3qm
X-HE-Tag: 1766103696-857941
X-HE-Meta: U2FsdGVkX18pFN8o7BSnIJDELupU0LxWYAA0njtXIJpigNvpoqvpts7/gZlqwRARe38/tz/NgUdB19RiSQcMFBok7JB+MKxt0lf85qwlyNWX3OZpPYIFXfTe36rOug+4RdSIQyMbHbCSr0tN5bdccpgFPVgLVyn94FCQzh86jVnaLXAch9AyCptnQsYm41usXzaTfVh1wkLBalLq/gSyAGmA//s4mDmDxefR3P69r8z5+4Ea9APcRXqXnQU4lu2pqGFy08Sfpas0pdQJEvpVrIkxRIApABF5lxsi6gIIzjmyCj6SPsCwaJ9tpo/1B/AXq8blW2pB83ewayfbVYYVZolmLpnbH5LeCi02aOpJS0ABMKZYSU3UnCh+r8W0wo+K2kDLkczoFD9NXJ1uB3IuMylmZJLsC73DB+zWKCOa7abUgg0KHVPbHjHVmA0GCzejcYZLbMSpmMjm4aeQEk5kGSvskgKVVe/f9nBHNfeh+jet8m+HHADhKUhdd4KptkbQgHUhGouz+zSxWvYT9kRw01kDYJL5QMkTePgHJCjR1SK4+NrwoSqCaYyJ/XE3DqQtNkF1H/oSjovDzufCARN/58TmqKpQITapJSxt6vHAxl+RU3n4p6qRickSCgB2hWUqrQm/oJrl3nGkZnHUBa4JI3sTauLC7kEh+U0rg5YLlYPRxjwnm9xro1ZHIajfkugdVpgUWpjrpVSAkyrn6UhTGZcNSA456BOBPxp/9ycNhu0IICM6nvtE7SpF3g+1Fhtwni9MwpXWpzbDe/kFLBf5pn/uvxiG7ON5W+PZRG1IukghI6zrR2DFLr4yk2lai03v3mKL8e/JAisBHXCiymOSEB7A25xYsK+XbHPE2qjTsclcxY/pza9DpqWDFmpEavYe3YZzalKcqTJX09wW1tkv8ztr7src5BgjkrPTSskUx6WqrSf8i8hzPilXjLvQNii8IGtIeVmlneLbR3w0nJL
 yXntdqnQ
 68fEA95U0xKsi+68hXUQiR6O2yN1osOUnDc1Rka7n3N8+hLDiYovfPo+/99pEnxSUwL98ocrt+NsqInfrujMLRmEARen6Lzg5fBBgiMBgZKy5kVOnZgf6fpoFSFpEOU292Wvp3LZ1nkxvVzkwvfn0IzxuSBYAOSgnTuCGTZ1hraooRr5YUu04HIc6L4AXzxOuducTSlQFbjmCmVDIStAU3hjcVMwWwpARybmwYyV9BBbZRj7XmoKqjEHsHLYA5j9Zlpw/CB7HpCH1H3OWv0XO+FYSGVnI84O5oCBDdoxpzafj8SGxroi0nU4qQqNhOCdKw5Lf+bCzaZVJx/Q69GR49dZtV6gX8RhVDn0pEfFbD1qDuPHXhYDwyCQiV6BTzZHh46zefD4t9zzTBmWJHBvYlwY0eUUaBDbczqt3ctntEOVsWzJETsaLLjEK/JXHXlzP8ZteLqa9WlsqqKWX4nrkqUhLmcyoe3hHRHFon/KpuCpuDXN7McPeAzaGmJuFoANCllyopN5vviir+q+f8eciC8DI8nNdfS+1cOu2N8MY4f6K1UE7H86Ee4aKTJshDvA309lE8Vxpjk5Tmt6hcKL0ECDkibxs+FYdqT1uAvEZLn0AkVdenxdkhVduEcdgxoKbNw/TjSU/+bBFn3ANNXrumfIuCyS+xA5AxmmeBTQY5VxUZWyhggHueZFyXmAcWpYAmuH5dsWfKJayxtY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 02:04:16AM +0100, David Hildenbrand (Red Hat) wrote:
>> > > 
>> > > I am not very familiar with the memory hot-(un)plug or swapping code, so
>> > > I am not 100% certain if this patch actually solves the root of the
>> > > problem. I believe the issue is from shmem folios, in which case I believe
>> > > this patch is correct. However, I couldn't think of an easy way to confirm
>> > > that the affected folios were from shmem. I guess it could be possible that
>> > > the root cause could be from some bug where some anonymous pages do not
>> > > return true to folio_test_anon(). I don't think that's the case, but
>> > > figured the MM maintainers would have a better idea of what's going on.
>> 
>> I am not sure about if shmem in swapcache causes the issue, since
>> the above setup does not involve shmem. +Baolin and Hugh for some insight.
>
>We might just push out another unrelated shmem page to swap as we create
>memory pressure in the system I think.
>

One trivial question: currently we only put anon/shmem folio in swapcache,
right?

>> 
>> But David also mentioned that in __read_swap_cache_async() there is a chance
>> that anon folio in swapcache can have anon flag not set yet. +Chris and Kairui
>> for more analysis.
>
>Right, when we swapin an anon folio and did not map it into the page table
>yet. Likely we can trigger something similar when we proactively read a shmem
>page from swap into the swapcache.
>
>So it's unclear "where" a swapcache page belongs to until we move it to its
>owner (anon / shmem), which is also why I cannot judge easily from
>
>[   49.641309] migrating pfn b12f25 failed ret:7
>[   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2
>index:0x7f404d925 pfn:0xb12f25
>[   49.641311] aops:swap_aops
>[   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
>[   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8
>0000000000000000
>[   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff
>0000000000000000
>[   49.641315] page dumped because: migration failure
>
>What exactly that was.
>
>It was certainly an order-0 folio.
>
>[...]
>
>> 
>> I agree with David. Acked-by: Zi Yan <ziy@nvidia.com>
>
>Thanks for the fast review :)
>
>-- 
>Cheers
>
>David

-- 
Wei Yang
Help you, Help me

