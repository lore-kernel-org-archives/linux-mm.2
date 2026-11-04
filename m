Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCE4606AB2D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Z3xTc5QN
Received: by kanga.kvack.org (Postfix)
	id 30F8E6B05B3; Wed,  4 Nov 2026 17:35:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0A26B05B6; Wed,  4 Nov 2026 17:35:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFD16B05B7; Wed,  4 Nov 2026 17:35:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBA566B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:35:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73149806F5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:35:29 +0000 (UTC)
X-FDA: 85398894378.26.3F5ABE5
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id A146740009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:35:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z3xTc5QN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Osoc1/zc3WCPxn/uivsVACevUkiPfuARX2+mZ1FpT3s=;
	b=LGGBPJ+p+Gq+b33TtVpDj9ji8H9MJ4IsdD2dtnVlkfvEiRFuX2zGgORJfSfNIZVktgXKQ5
	LUGDNrpx/pTrpT0jXFaqvFRRTFYjv4E+eFXdGemX64SWg16+LsyvIOK2Ao9J/SMzt1uaV+
	uQzbR6shbWiOJgZ8IvSTGbw9+7rXhNM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831727;
	b=4/L61TkIhzsbg79/peJbEEGgWRed9oYdVcjGrtA2kT/gVGbPQTkzewUTyismrElCEA57YA
	3G+3BeJ1Zja7UWEcm9dSicVwwMqWk6WG4dS/Mjbe0UZxvJ63GXeVdfrwtu27aNZxBFYAbO
	MoKVQW3zIVmrAzqzkei/H4LpnClPq1o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Z3xTc5QN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8a06cc097c7so948066b3a.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793831726; x=1794436526; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Osoc1/zc3WCPxn/uivsVACevUkiPfuARX2+mZ1FpT3s=;
        b=Z3xTc5QNO1MMscrqXpjoruP1GmkscmH02zX5qIUEGGbuafSIp3MRmWetzaRhpsVMYq
         pUfm218vOe9KFzaioCqIQDyrpZmiHwuQr4NxAxDfQOEA3Ktn5GtcWvM/Hj7Ei6DqNVnB
         SqA+h3lkdbmc0Xr0C1ti7XYQCd4dVmNcb08DAnghizXO0ctVi4owrUiubQ/aNfBHhRF8
         CAkfTi8VV5uD77L6DDUOCkdmH9dMIycGMDuwrD8P97dhtf9DYZ5wONLf3xKwOOU26X9c
         V/QuBR4Ejw7VZcnNgzQ56L3gTVVj6c8qTCjovkZGbIcbJGHitBK77zkvSWPfxgbcFPnj
         btLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793831726; x=1794436526;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Osoc1/zc3WCPxn/uivsVACevUkiPfuARX2+mZ1FpT3s=;
        b=e8iawOPnOluOLCn4UkzJnttokiB5BtuV8FqHh1q5IoIv/p/h2hSSv45iAF5E011AEJ
         RlwAvKLYp32wma/QXwIGxPxoehR4RJq9tG+JU6dsY82vam0OHHrmEN/6NotpxCmg9RGp
         4RNAvo5d8/wVaujVB94XAIQVLBi5tzjezX5QA7mB2JwknKvGZ+sSeIFeVpFZXu5xIFE4
         P9e6SWKwdWtz7ixNl+Ut+H9sqmnzoNkv8CZtR7OEaSXQmSxgpuYpzoMh1T2BSVlg4/SH
         2JgeRl5m5+nUqH69GX4Y3S40K3zug3vVX1plgeAQReu0HTfFkhw6eVUltiOMcp7TaiMt
         eATA==
X-Forwarded-Encrypted: i=1; AKwUvBxqDaJXLR+SPIeGljGP91WfFAV2utOiylw4yZFcbAH1bsDamTVl/Ty8ICiXIn1aJxIaE7/Qbu26/Q==@kvack.org
X-Gm-Message-State: APuU4Z83kyUEV1pyFvq+bstGQISlq32eTx/8oek0N4d90YyHoYbTnynz
	xIJnur7D8z3yH6Xwp7iEy+loi46vn2jNai5Iig3jRygXpfOqSL5xX/D8fCeRPzlUQA==
X-Gm-Gg: AYBFou1vpaWgBgSOW++gdnxxaFP3gPuQ3O+vyJSMZmiiLerzAunZBIqtgmloVvt2HOF
	7vxA6l7Q4pJpeH9PbAzxueObGiwJ6C7n/i8vDhb7mw/+yzhnRzQMnRSJqL9Bn9wgfvuq33xO8rw
	YXD+JDr0koXz+pmZSWkgDAFm9UaWn9ofCKWfy9ZOecEMJ9x6SH0YTJBgW3Ke6dm/K5z3EXyGCBk
	BfTf8qFUq6L/3P/cHN9nsl5HuFuhXB5teZ44aYLKHiprmIDDtIl0mgdvSkQdE+59eAwNnVI5DU2
	AVy1DxH0kYG6td1Bxh5iIZr5Xy6c/akeuKl4Qy49RMmMnMMUN/tMofb0z5H9XkqniT1NOS3UP6v
	dp8oK+1ZA0bF5g7dRhCGjIjb52eFsGY0jRznPtAHvKnZbvvEppfhJLjr7rSZ1qreeN++G/8+rQ5
	sGNpwDRA/KUFmW4gh6/Mh93y6e1AqRsB/ADp57H4jky1rVlVIA0JpB3uGvV/uMPEGHs6znm9nzZ
	Jifg5Y0vumGqG9z9f5NeGrVQuWZy2FQ9TUfAyWebTH8aTOr7TbfPlqdiINP0u+1RAfuwt1dyqzD
	e7EzAKNVt5MJqWb6TAwnFb0n33ER/IptovFBjkd0H9R1yn71gi8cVzs0VRPoSiN2FPNXztEsoJI
	CxhaAiKSlKg==
X-Received: by 2002:a05:6a00:1f0b:b0:899:67fe:3c52 with SMTP id d2e1a72fcca58-8a9be1a4461mr15308534b3a.15.1793831725909;
        Wed, 04 Nov 2026 14:35:25 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09b569495sm1376244b3a.37.2026.11.04.14.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:35:25 -0800 (PST)
Date: Wed, 4 Nov 2026 22:35:20 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files with
 O_RDONLY
Message-ID: <auuzKNZsPD10XM4q@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-10-dmatlack@google.com>
 <2vxz5wyck08d.fsf@kernel.org>
 <auuJ4msatqzoOrjN@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auuJ4msatqzoOrjN@google.com>
X-Stat-Signature: 8mo3eenwz86ds686bxauykdc7yeab789
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A146740009
X-HE-Tag: 1793831727-317870
X-HE-Meta: U2FsdGVkX18HXf6WlH0Z5Ygy18Jeza/bp5tD/gGCzfaRlnelRlnOlIFwxG/k2Wc0jJkj4dovSdMvyLGpCrnFtWKdRMU9C+es9846uS/RtKDSx/q9L/BHyykZKrCnpAjGjGgMEoRFxD8FhE5tlybfEvvhX5VRagZBHF8drpYXO9W84cWjeLoDFr7FN9J5fphYI1/VHzDvozObZqCyk8276PyGUaSmhkZ+HynmTL1soNzbvIuf1PNnM0AgW8yQJDMD260GhBs7nzKES0VvMEUHqLGJeNAIkqtsZqGhJIDaFd2qHUA5AjogDLW2w3RbHu2lRHxJHYwRcb/toNyISi0V4MdMq3p1NNMwTpg5OfV+bhWiBcO/tFMxcNQ68LKThdLM19CxNN9V+44RNSaYcDhuzPmjT3Nhik2VG0UJaYAUBN76Oiv8Mt5XvNbZAJgO/eMsdxITK7mdhV1SddS8g/khWmoImnLpdIKM773LLUnI+pp+N7i1ozw8p0oOtTg9ryv/L8qplxRSt4Vt1yjUJvWYp53Z3oIVrtgmbuu0I8+SJcJwiC7GiQPcO3IJU5q8rsSnqci3jiBiFR+s+UD7H3vH7xb6VfXOtDkqA99eXn37Q5Wh9m3JwIctAE8UIqEdzXvpVBjebhcqaXe18/yMydOXcSQJ2lrOKjnWGYw7nw/IdV1RNvtPytydcMlYWLpNZJIZ058wHe9xU6DZq+6NZugzCChrCc9wUfQ/vK/s5UIX1bOS+yVRsAhlGiY5OphbPW085rroQg2Pjlfz8Me5iP9NUlGUdORRDT27qVnvafBcRrmaaKKLsUW1HVeVQvs732vTXE+1mLp6VyiomHP1VMsXtCr40/aIMdW2RRTQGZanOmcsD//7pMQx3MYfopXRF7thSoM5y81gcsTMdo1WgSSnAkoPscjiy+Aulzx/3oBh/QE8B63evL/olXK2wAVVcQoYTNEcscc2S3vZ5uFsNmj
 eOfYdXdI
 V/Ul74Zs68YSGHcz/ndetst3PmhjCjunmiEWwAt9Dns8XrQJ355uoqNVFyweQfXvNgiM4QM41tCJ8EtB6qaPzXsogmmNdRSFJcHtt13GsRGxgqcnM3ntGr8QRzW4CHIrVM2109KzrgCYyoBjrb4184x5a3hzv0llqFTNvU5Rka3+je6HnJKOmFhydYNKmquQkswFVSEm4I5ngy3048pe6TFZ0pAW+tgq2FOYYiqAb0DC4KLK575kmmHNKBJFhMhwcehJR/VySMVa/MJXGfYFtQbd68wEr8huSQoQoK41XiW/4ra2th2GlmefJKNhR2yZgL93z0MiFQ6fZ6fFIBKKZFp44y9XkXe4BSGGMd0I3bKzvMmJFJF9V6gXGvZJrjWQXq56H6NduzpQRXLNgsaidiCmL+T5GwpZmGGNt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 02:45 PM, Pasha Tatashin wrote:
> On 11-04 17:52, Pratyush Yadav wrote:
> > On Tue, Nov 03 2026, David Matlack wrote:
> > [...]
> > 
> > Can't you put all your binaries in a separate session, retrieve it as
> > the very first thing, and then finish the session? Then you can execute
> > those and retrieve all the other sessions.
> 
> This is a good workaround. I am not opposed to this patch for 
> completeness of functionality, but if we decide to keep it, perhaps it 
> should simply be squashed into an earlier patch. The current diffstat
> looks bad, as it mostly deletes code that was introduced earlier in this 
> series.
> 
> In any case, given Pratyush's suggestion, we could also drop it.
> 
> > 
> > Why do we need to support this in the kernel?

That would work for binaries, and I agree that use case alone doesn't
justify this. But I see O_RDONLY as part of the retrieve interface, not
a feature for one use case. The retrieve argument is modeled on
openat(), and openat() lets you open an existing file read-only.

open(O_TMPFILE) only requires write access because it creates an empty
file, and an empty read-only file is useless. A retrieved file isn't
empty, it has the preserved contents, so O_RDONLY makes as much sense as
it does for any other existing file. Without it, every retrieved file is
writable, even when userspace only needs to read it.

Preserve already works the same way: a file can be preserved through a
read-only fd, as long as the caller has permission to write to it.

If we keep it, I'll squash it into patch 7 in v4, so retrieve supports
O_RDONLY from the start. The commit message will lead with the openat()
reasoning and keep binaries as just an example.

