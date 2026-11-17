Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10951606A888
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XQEk7i4J
Received: by kanga.kvack.org (Postfix)
	id EBC956B05BA; Tue, 17 Nov 2026 16:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94076B05BB; Tue, 17 Nov 2026 16:53:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9DA6B05BC; Tue, 17 Nov 2026 16:53:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0A646B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:53:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17F5E160538
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:53:52 +0000 (UTC)
X-FDA: 85445963904.25.EC88ABC
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3992318000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:53:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQEk7i4J;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794952430;
	b=0E3++r/hKyl1G+CiQJ5jEKU7fb/Wg+guSDo03ZKKD5E8mSCg5IYhuBOQOSx5KRrIBbFqvs
	Q0fBSYdFV66W++/zlhCLH7G587hZI0aBec5wTfIgHdvkH5ymnyyd/Ka+7P+sohmVbPdLGL
	ru/hMaBk6gVZDA+ZBmaLBjt43HoEf/0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XQEk7i4J;
	spf=pass (imf16.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794952430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KA67CSPKfAaW50KrAR7ZlRBvAWHajM3WvHASRWCft94=;
	b=2STg3uljNfiRh6WRAda/LDJowvtJitiU69OqkNJamlrCLHzdWDyh0sFJFVgQuHgrwjP8Qh
	xPS93J8dHlO3uXwCQ+cdHJIdA88AU9p4YQ7vrFY8BBSNegdJByANq87OKcBR0TahWHKzos
	h4RfGaud0pjurzkPaMC8w7L4IAA1hFQ=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so3562505e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794952429; x=1795557229; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KA67CSPKfAaW50KrAR7ZlRBvAWHajM3WvHASRWCft94=;
        b=XQEk7i4JB4tjTCGxHJ2PImiB6TMydAZODmFGivYO11+KfDM08b4NiMnOhafKp/i9CP
         OZY2Q6LYz9t7y5k1F2drlUZBfodkqR/djpy0N+sMGvEQERT26wP3aBuSHrwRt1/SEtOk
         pYxeSxsiSWNQ/dqXNDLCTKxp0YTBaQvM8MBYajnE3q1HLsUlRv0Oh2wCFj1aU+hzULif
         ahN4ckW6ZgMfamCx6/ULuL8uSmYEYXF13O7DToeL9PT3lvpmiQJaD+U+lJNa4gQqfor1
         axM2mzy5mlP3yp2EF0S78osfj+HUC4hPSLAzif9r8JHthxnwrjgb3RRZGrRJ//vXRsF3
         7kSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794952429; x=1795557229;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KA67CSPKfAaW50KrAR7ZlRBvAWHajM3WvHASRWCft94=;
        b=AMiJ/Dp1fD0nLnVK8FKn2ZLPSLUDkGqSbvJTU4P/IvorFXkVQt092Y9lSX4u6I0UuJ
         h2U2yxSOVPNumIjPlqvRIAlQC2JZxezGBWWm1QSsWQNvnDsHZA0H72ggJBJJy77HiAJY
         Nu2ePK78C2t9pu1uWzicYV0gmD8LkfzN3EuseKq2TQ57Iyc/u7NK1ixs4zN5cONnoVyA
         7E+KQsOEjC+eYnvJYlNjgkymIyd2gEcmzFLwRDQXV96CX03Jdmyz+jVHHtB15hkGnhWb
         +CkTArO1xQ/lOFnuqU833ZGGgBiUWUkAwQ8vM+/a8BwK2aVR30eq46ggzfGHdN+B6eTm
         PC0w==
X-Gm-Message-State: APuU4Z9k2lJLnBiR4sEq67GgroZLJ6WLs3SHGR/0Hu102U7u6kvq0GWS
	Iqx1CnhezIeoZUItEPD40zap1k6msrZ9iY5ZSntLDjgt+h1jOyR2SdbW
X-Gm-Gg: AYBFou2ap+c/M9YR5IqeeOEzUrCrU4HcLH9zS3wOGz8TGdpajHJqHWx9/cQJxO53Gue
	+29HbwElFkLSdzJQhhvWbYviUhyrivyLt1uCwgsUrEdWbign1YDSkREjGM1midnRVfPQSN2Jh1R
	o13TvTPDMXEsniTCcL1B7/m5YYYHIiEyOiY4TwoQ2vFoH01P+B6d7NI+5GlFGkt4gbM8k/G1x7H
	sraViNU7jQPs3WyADzzc8H9xTY6f0G5Qwzapr30nEdwO7deIm2iC7om7UYZEPeKqAbrAsabLJWV
	PaK14usyxghV8xTrBZUbRNwiraQf6iyYXGku/f45oh6yRvRx/St1ZbJOSbISoji7MtQLxP+tQZ2
	JjBIRNW90jY46eeF+1gBnCCNNBkJsP6A6szIcPLwdVRJ7SAk6y7DLleUBZ5nP1VO7H6buHJvjDK
	4FDjJlwUpE3nm9USsdDaEsxw20lmikdYPWZsu9Nvb3outpHJVMx3X1VtD4omRdmN60UUgNOb+ZN
	esIK96oMusIIv1baQ1Copd3Fhk1wEYVs4zpdymwiePipTwrRdJGcdrdk+xRe08pyBYuqfKDlVzE
	1bwC9rWC8d3k0yz0VMNtCnD7
X-Received: by 2002:a05:600c:4e04:b0:4a2:1612:6367 with SMTP id 5b1f17b1804b1-4bb7da18a01mr8456775e9.15.1794952428596;
        Tue, 17 Nov 2026 13:53:48 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7d256f64sm14712755e9.1.2026.11.17.13.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 13:53:48 -0800 (PST)
Message-ID: <71e860ac-3a79-4ac3-b8a2-09a115f5e97b@gmail.com>
Date: Tue, 17 Nov 2026 22:53:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: update walk_to_pmd() to explicitly return an
 error
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>,
 Roman Kisel <romank@linux.microsoft.com>,
 Saurabh Sengar <ssengar@linux.microsoft.com>,
 Naman Jain <namjain@linux.microsoft.com>,
 Michael Kelley <mhklinux@outlook.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261117-huge-pfnmap-fault-races-v2-0-276007e73bcb@kernel.org>
 <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261117-huge-pfnmap-fault-races-v2-1-276007e73bcb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3992318000E
X-Stat-Signature: 3mixth9bffyao9q95frgwbee5jys9wyj
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794952430-185975
X-HE-Meta: U2FsdGVkX1/nIDqqOc/6mrh+dCFG9Zy5lrvWbv6leeQN3WwmaGe1FqrAyRRBAyQVAwF89rcKaAmZER671TLciM+4umJXWBNA9btWxs89LIhWFfpe9wa3wnfe+wJ+38Sojuxq4e1rx+7/LvLd/KXr+vrYyPWKi+KjlvO1YNrQM24eD43v+8oy+ZNVIgec/CMXobbZ6zQ2n/LfWHajdS1IluvPnA9mhRJ9w+rpMsBk1zTD4BCRSCqcAbLWzoMPonvOeriqTGQSW2APXli6Y5vKFr1PuBaWp7f34FLGz7x+yg/jx5cJou+vwYnfZ44aJ0gBnb07qWQfLXzKjr08A451+RoDWr+OnFIEBtTQPENY9GrRtQWE9fZorXuIjDUavoh4jSX4tAIzBfJTZ5Oq4IIdcf+T/ve2DL/3SJove/AKzBjcNehnPx65CDoMMVe9d8rRTSQgL3W2BIrw+ISMDAFiStPQJ+tHxQ3qC2t3i6Zmtl+4h+8lv0YTqmfoZOvHhSh4kvFyBtr5StEDOcJr2yGfyp6VJ5wsbcRHIYRMQKScsKX9aT669HBtgIFTFFjgkv3FOoI3Q0WEgwnlTqPkkotYqE7yzDeVFtM6VaCKALmPV6Ph+pusG+szRkZCM5Z+mBNs6oOmuVhRdLsakU7DG1fYAwYYRn4ijC9HhOYQsYexT6C/V0kZ3ehGtM8QWd94tdzbp2oMqQvaTZAGeHkqeKGOqKO6o2VoyqM3fzUMbkqp3hWjTmgD8O4CuuRSyWNhycXP0BIUyeAefKOto/B+Brn0AuHPEsuAOxeExchyKMZEB16Q5hd75sNO10JbJn2bMLsXkvvhjcccxBdaKD9yGogdPK/YiL+MRwPp+DW68xpqzN3dYlEUd0hQPUfyAAjxdtEzJxQuLo96aGLvHvNlHXMTkbZrdGgfk3K4X8wamlpTE2dX3H+9F9Dfl6jFiBtASGiL5HlDe54LCoxqfP/CFTi
 1FS/sQ0i
 xrv9LpqmlPq+4oUULKuFcdFy7H1Qt+Ruezv/MOIK5zUD9sOzpfMseNjmmrkE3HTHVbJCpk/kyP5jj0f0UrxNCdyIz94h6UTZCEFWnsta3E2dr2WLo2Px1nsBHt1Vsek/zpnrQiYIHJygJPZdxMgjB/h2hmP9pEFgwIeCxnetNNndJFaIItJpEZz5fflQ4Ch8HjxZBk2qYfSjNMxBVat0woPd1Y04s8T9nx/JVewK1DFL20gNTzhRg7Jp638p2rBmKObHljWb00LrhvwkIse090kROkoRamTsVzw5ZUnGoXRtjud+6zTEPvqdeQiJ6pfQYmh9j+9A+6j3fKcRisy/s2gFCuA1FVdIzs9s6HXDkNG6Sq/1+TODRferHKd9Ji56ll9hgaKqyPEDsvfK+zxVDAQrorqQlsNw3had/LNEeMV9QYREetZUGVMo9nx2cphMvJ2v+W4okntRbGO388SCUcJjnkU2P7KYOrlz+QuJDHvgFlc0FvGXVyejyjVlJlGWOP7Zlz/T8AHEGTjdpgdgt9hZGqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 7:31 PM, Lorenzo Stoakes (ARM) wrote:
> Rather than callers inferring an error from a NULL pmd return, explicitly
> return error codes.
> 
> This allows different error codes to be returned for different failure
> conditions.
> 
> No functional change intended.
> 
> This is a prerequisite for the fix to insert_pfn() which follows, as that
> needs to be able to tell a failure to allocate a page table apart from a
> race with a huge fault, so mark it for stable alongside that fix.
> 
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

