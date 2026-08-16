Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68EDC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 23:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8259C6B08C0; Sun, 16 Aug 2026 19:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D68E6B08C1; Sun, 16 Aug 2026 19:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6656B08C2; Sun, 16 Aug 2026 19:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3655E6B08C0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:02:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9E35A0630
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:02:20 +0000 (UTC)
X-FDA: 85108658040.20.6721D0E
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id CBF2612000C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:02:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kjt1k+RY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786921338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ZNfUxpi7veRTWLY2tYd3MK6swZzgBzgGr9g7FewAwE=;
	b=4FZ44hyhDAPoA5UjEij87iu1T3mpuBB8AALKhXl0x4d2lmn+/jiE8fyf/JmGP7CDXCd5f9
	03ACoThDzm5+8H2zC4pXEiiK54JajLIBrL5Lff4c5LYJDDGfDqxkT4m+BcVdUDzoRSyGLC
	4OMCctcWn2qhLGnS54D//EvKGroCwKI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kjt1k+RY;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786921338;
	b=Zr79ZIp0imMW1Vi15whL5ImowwMiHoh6Fx09fnMSRTRxMi3b3B542Sbsgv978MXNiyBUOt
	aAoT+wSG5D7T4JeyQhViR4QIelZVnZAMw5214SBkGiCSIZWHJLu9dhaDB+vHvrnG0TR0UC
	xcRZG8wCHuLUrjC0hlT6KnBsm/dTu1k=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so2271827a91.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786921338; cv=none;
        d=google.com; s=arc-20260327;
        b=e2+p9x0JQI6oUQa0U//8LWWrmCYd0faLW3cM0CJNQ9UeBDTuc24vIOpJeuyu/qgObJ
         KY6iNX06OvAxaSHuqEtpE6wbkYtZZS4XzTXsx6yjs52sHRAh0PCMzRFvjJLX/l4CCqxw
         DZHJ6BkSAbWJGQACLD7dDaQ9h7aqwtC9GFcE9FL4olVuDIYFKFBHbP2uObZcpEaMS99X
         HjatmcwiLa3G5tpxEwaZFseG8QzJKril/WC6OJgEkp6mA873JuoCmUrFmd7aKiKVdpvT
         +2uhe9+rFt+PggMYN/sJflqfISNhfWj36T5HFRBvDjAcOzwMKk6zMimcLBbnAgl7UWON
         f5Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=5ZNfUxpi7veRTWLY2tYd3MK6swZzgBzgGr9g7FewAwE=;
        fh=GjSB15LFxqeSWlm0LqzSgz2RQGEuXWXLgAxhQefK/dU=;
        b=phpyDgH4fElAOga3JRFvSJBJkHdX/zQxsVPwZ+FB2R7FOOTNJdUVona+chVoNQARl4
         TM8dri9ZZ2F2SmkdnzGDbMR9KAeWCA2wXyBQFLsgWwv7k14PDYVE5Km2HulRF2AKivLX
         RivgfQd4fkJ5hBJcZDwJu/+SKD4KcPsVQUCIiMEard19eFdKFsuiRTfF5HEfBiDd33Xg
         Q7mBBz3ECxZiE9rB2tbc9T4W9fTXAsioIqtgyWDGG0P+Df3ZZOI46LDJ02s8uupc/opE
         qR+Hy3FTSpxA2qlIJC7wbpScR/mECZihDFYkv8w3fIcZmhH2RYhFEEM18Eko2IsIz8IR
         e0Bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786921338; x=1787526138; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ZNfUxpi7veRTWLY2tYd3MK6swZzgBzgGr9g7FewAwE=;
        b=kjt1k+RYnj6qVVR49hMYAIksVLu6RZ/NT4H939roxrdoHDYVGFtJcUo5MN6a7Hb5cH
         Y1Ql71h311tE0EYuvapWd7o32ZgI9lywRPG/OPUd4whkCCM50B2kHFT/asF7flup2nx5
         vpzpOrcQhv1kqCmOsGO8pWJ1+GZp0Aoz3kHN7gc4RwdLBFuCR396tR4veuyS7QBgeebN
         Ari0FLyuiW9nIIOCXd3soHBg3YXGVK87w7tgl69NVSL9PiKjIx694DBDL6gcy9iE5r3H
         ZYmDxz6fZmkKutAIe7GH7Vu5VwYmIqb1dZ95gycYc5PIKJKlubJnu20h505yCM3x8lCS
         g0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786921338; x=1787526138;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ZNfUxpi7veRTWLY2tYd3MK6swZzgBzgGr9g7FewAwE=;
        b=NHHFnQ+EkJzutbRc1719KKNxC0ZR1jofXql1anzaS2XmAXKZ5vASmz3iU3Oq1BoFcT
         YKDs0V9uoI5kaEdLIXq6Fc7n+BZ2pE0T1hCKVdS+O5URYVVaJx9diLJKLxJf7GhpRxz3
         wJefH1+ho/Cj93ceeruiSRPTv/n8fK0uZAjW8MUxLtFCLF2GNKeB7DEDZuBPngQQhoUe
         SaInG0Ar2Rh2jS/pnDhDin++njXMgXhA8LpO3wgH0a2ZbfIaK+R6wXey2AAvJa4bZV+r
         M6KLRFAXpvOwbyVs3QvJy2csEmeU1OV7+1oUVYOspHELeqLUw1YCtCVwSR7+0jahc7Bn
         oLaA==
X-Forwarded-Encrypted: i=1; AHgh+Rq4dCqcf/fwRJQhmymcLRXbrliMY/B/JSZtMtugIQyjudnAPOg+i1Vj5rWtY8HV1ppEiLnIp9qHGA==@kvack.org
X-Gm-Message-State: AOJu0YwVb3t7I8yVPNmuerflqH7YIae8n+42B63KGeOiV+hlJAOdMhGG
	OgzvkcejgWOabM/RMDjyVgLJJO6ECSuICOzJl0ySHEeurdVvBmjaA0c8f/TDUfT801yz5UZToMc
	azWm41eKGPL9G9EWWPqIPyCtoMDpb16jd4/WjW5SY
X-Gm-Gg: AR+sD13wRIpIzbP+o+ix+p+RtWQgk+t9LHoIATum9NqWjv5RAWQ8lB3Rkm5RVgqTsXg
	64xXPHNHQ2wJ7H0VXNepQD0ILy+cOIeQfMhG8SBgJfMbxGpfZFvz8/mKE3Bq6MknnUBKTdwMsx2
	Jxy+7Jrw2k65V9AodD5po77wAmafeKjdClB2/SXxZV0FzxQZJCPbvT+/9hZecH4EUQg2WBLHCNW
	hluqReyA6/nfg6wXhHEcBoZeXsx7rzMLnZUhEafsWMDPSdyoDMsaBVofCXv2bD3zHWICgVWdT46
	ebyZc4aVUg3XbrKODheXo4bFISzk3WFobEaAHhKEuhvNw0uOhtLAYmB835jVvOXPcknHvUvBMg7
	O5Q==
X-Received: by 2002:a17:90a:e7c8:b0:38d:adae:4866 with SMTP id
 98e67ed59e1d1-3933bd2066dmr20117316a91.21.1786921336732; Sun, 16 Aug 2026
 16:02:16 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 16:02:15 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sun, 16 Aug 2026 16:02:15 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <beecf36b-b0eb-4691-918f-fd39f46d5d8f@linux.intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com> <beecf36b-b0eb-4691-918f-fd39f46d5d8f@linux.intel.com>
MIME-Version: 1.0
Date: Sun, 16 Aug 2026 16:02:15 -0700
X-Gm-Features: AcwNN1Va1JdlpRRtXfl-rgaiOwbgkg6rBN2xjp1zNZlzVot1c-IWzDKRKQ6t494
Message-ID: <CAEvNRgGtnQfhCkrWah3jNeivbHCQqRSQEXs=uqJhBmS+GVntrA@mail.gmail.com>
Subject: Re: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: rrgm8doh4gud4ui488kjx6jrh6yx1p3y
X-Rspamd-Queue-Id: CBF2612000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786921338-806549
X-HE-Meta: U2FsdGVkX18xRHD9aDv58SL2IK4ds3VW8vC4CQarHIt4mp0/+NR0U+xpyHjz6zAV6QhEduUPIIgRvH2a/Hzrhs8Wl1pgdBwghJv8LVBn8j+n7ziSa1pN6qMw9rwDXJzLMjEylX6gA73sLbEfjsdwj1tU1lFnwJ98M2t2WiIgAjC6oitWLM/lvbrdRN8EcXQ4/KITny5Mki7EEt33VWrALR15U+pVnKRwxLVogZOuPZ/wNjnxHp/uB9uUCG5E1Dpyjrz4coyrlHGSsng7VfnYKMQd9m2HkDp7jvswWEn4d9PToalxwMLROmXlFPFSFZxiUNd7g0rFLSMxyDPgUcgs5uVhy5sckjF07eZAZ/WOVbRVJwnkkSMgrrkEb+65xZBenA4ltz8z7kW8tHlZFy8/B7KOrlLeXJF2RZBclT9jAbPrhrUwtchNkQtxwnSDTNV/J1XAzAJrMiO9MvihfSjLgiKRGk9bSVyWaAkXc4nXPsoAWB6L1ntb6OCHhQa1SDWR5SjWMLVjlM1p/cQxx/8Hn4WJLZItUE7TYBmBOZohYcD8v8qb+E41f3iGGcB9Mzf7gpT71WLXg1FMnJK+n3hyRpifUOsvWy2Rg6J+B5eXBoMP/f1FRqtPUfBFaT+8bhQZl7NQWS6x2znpwDxn732Hj18bmlNNIZaPM758kMotCcTiMtYMfos8uhE0ld42Gyw70Acg3nzAlXm7Q5fVUAWdmSrTXsgJgXqYishCHiBiEBAB7fORe84GQ+G8OyyRC3XQ7ENvCJrXJ8IVrelGKAUhNz4HeU0xRfOrR2F5djManL57gOigayy4UNw5ziW3dEX4J3r/UwFIVXSWxF2zFosEzcG+bmzGnPz6ueoCM9w2MeJk/B5U+rdJQCiJJUD8Knv4rHmPY1gU86wVjawMaJhutUNHtv99GCX83KICTf47hM0gSW7Q9L2a36PTj4H7bL00+x+8nNQnz9Nyp6S3a4N
 wjeEESfm
 uioCtBw1JcdcUN0c0DDyq6kU8XHuHLseT2N1vLN6Yv9G0NR8kR8kVUimZ6jSosK0Dba0qXtytsEIh90S2VlA6o4hErE1a6gE6LyUFqLmv4TFES4/IbwdZpIcePXyVLvClr+0w89faWCu2NDH8u9NMlx0dpKtX1AfeXNpAAa/jPQblfIChoWGN28a9zwDTw3G8SxIH/NyoDmXFU/wJaC/vLyVBEXMO8m/4c6S27qcoga8UFdSrSztryx+IU3YiyYZ+n32uWD6P0z/GoCakrGAjgvbm9E2o/ZbsfNkcKBuwPWHKDRePtt8BKdp0bXhH2WZmXef5iq9njbebQx5PkNrcbAt9baLrOPDuOhOweY2bDiPJobHxc1Img356h2Avk33gJsATVFvzl2cDW3ml2si0qwA9ydz1xj7Y+bz7YwtIfijbxTP5ebqGqSNobQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Binbin Wu <binbin.wu@linux.intel.com> writes:

>
> [...snip...]
>
>> +static bool __folio_safe_for_conversion(struct folio *folio,
>> +					enum lru_cache_drained *drained)
>> +{
>> +	const int filemap_get_folios_refcount = 1;
>> +
>
> Nit:
> After adding the helper, the use of filemap_get_folios_refcount seems
> less obvious. It introduces unnecessary tight coupling with the caller,
> though it has only one caller currently.
>
> Is it better to pass the value as extra_refs, similar to what
> lru_cache_drain_for_folio() does?
>
>

David also suggested [1] something similar, please see
https://lore.kernel.org/all/4c638fc5-5a74-43d0-b5bf-d7ef893cb994@kernel.org/,

Please add on to that thread if you disagree with the suggestions!

>> +	if (folio_maybe_dma_pinned(folio) || folio_mapped(folio))
>> +		return false;
>> +
>> +	lru_cache_drain_for_folio(folio, filemap_get_folios_refcount,
>> +				  drained);
>> +
>> +	return folio_ref_count(folio) ==
>> +	       folio_nr_pages(folio) + filemap_get_folios_refcount;
>> +}
>> +
>>
>> [...snip...]
>>

