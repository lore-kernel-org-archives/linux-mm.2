Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52199CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEDB6B0088; Mon, 18 May 2026 15:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F3B6B008C; Mon, 18 May 2026 15:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896846B0092; Mon, 18 May 2026 15:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 734836B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:12:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14A92A067B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:15 +0000 (UTC)
X-FDA: 84781486230.23.059E1D7
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31065140011
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:12:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g9D45ldl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779131533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+w6R6IigdyQN6IOxgpsJUgNwtXZPEURhPU7T8xIlS1g=;
	b=RWGgX/0Fr5Vh0p5X+nphuy3oAusPAN9qio4IeOJLOZzpW+lluXJlQwiITE//GzXptwBdJ0
	h7+q6VSQgvLXWPTQCmLl932jV9efdy2d5OFrFcMb08wJHcKxFGlPI3p3bru05CM/4rw3Xr
	irM2Opv1QbQcI7WiGQNIsBawEI8qj9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779131533; a=rsa-sha256;
	cv=none;
	b=hNCcAX+QpcbqunI+3g436pZO8aAhaq2hQAu7a8vN44NcZn/BO5YZryAFjEt9PlrFwhr1Jg
	hFHDkI0ZPlR7Fg1KKxioFcrcJsysVQeQaJDWo7H0FQGMQoMsugWfoaF/HJRupAjFrjAygT
	nsI58Vi0jKsFm7XtNWs0TpS1lT5ZTco=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=g9D45ldl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=skhawaja@google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b2e8b95bdbso1745ad.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779131532; x=1779736332; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+w6R6IigdyQN6IOxgpsJUgNwtXZPEURhPU7T8xIlS1g=;
        b=g9D45ldlyI44O2xw8kj50i3KLwjoaqMI84lKn3SVbQ9l3GojYJwEqeqCSw5w4M3QB/
         br7/VlXKRv0MrnlbblYdicmjgHUqc2AwvzTpSVDwAa2JX4OTOI5nShAx2zw5Si35/JGO
         3OChfSgnmCCtFEhI5CPGCzXr9WqDv8eYT+YxXyhX+DTkoECECFLYq7AhCIG8AvyQVTOY
         jG1MQxsYLUDZRGn+w5BZZAnoBol0fvD/xcDXX7gEmSEwAeHQkwaTzOQJASlC4+1+A9JJ
         rFvOybQQ1Azwqn2YjbLZbL0UuZD8KlHZ6Daa6aXo8SGNf5aswjoRJIQLMxs8eFyQom3w
         Q0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779131532; x=1779736332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+w6R6IigdyQN6IOxgpsJUgNwtXZPEURhPU7T8xIlS1g=;
        b=NJWAmonVx+6VgTWQ3E2tYTgifCfmLMIfyQWAYChcKXK48QjpM2Pm7c6CGFmphiD7nH
         QSUWpF8K5RdZGuomCgkTJk4udd37vvzSKB7pB2+qZtkkIOwUMEdyXJ5hPFxmotjvzb50
         J8wxhg41T4aIQv/rKvtqAhhhfLkO8V7wR+AenDnXbVN8n47QMQVYh2qC1xTC8ILSWgyr
         0XXKWiXRMEzzegKlHyqQPTKvNqQH/IaRyCcyDQ+5ujbQfzfq2Me8+TP1n4Uz+knwsuKx
         CkCgXaWQ0akKORj6IHiRIgwH7R5uGyRjZbxeO0HjjsZ/Ir7FSay5qgYsZQ4x9tkAiI+O
         wxLA==
X-Forwarded-Encrypted: i=1; AFNElJ/ykA6W+oEZy1E2T/7KWH0J9BdXQ7vRJbxcEpN52LMEahSpkzR6MRDhZGrivYLguHKXb5BA+4hT2A==@kvack.org
X-Gm-Message-State: AOJu0Yy4izaH03A7N/XcifsJRj9JC5YK11ZEvlHInhholph02Ch29nNc
	kchUGC/qZxGHx1D8+3bnuKccIEq7WrJT5twS3suf90iIn7JNAVp7//TM8Vd3pL2JFY4y7jMKejw
	rN/nEWQ==
X-Gm-Gg: Acq92OHkbAwH7ojGEH9z3KmfeGd5nOcwovAVH5iZa2tZYg3a2tjxmjohw+VF+YKMgqC
	8GHJAZ+cjCprn40VVSDjl9p7D228DPDEVUFoyYkuXW6S1BSDpywuwLNE+L52+B9L74SnrTdf5Gh
	x++oYU6FKbUAvKK/7ljvWTEMO85/fC1rO5tTVVJeGg2yUKDXVuGPtynLL8lJZ6OW6n/Eygk1erj
	LKvYGPubbbC47iplZxhr+44nTpNc6M4qS6CQyfGCKTMBCYa9zkKpG/+X6rBnaGGO46+Sr1FPFG6
	bEolRUO4vlI+oC25hPo8v3yIPhmCibRO38pOXgNZPAZHt+XiZx8Z02g6DPewAxMGnqKyV+HJGKs
	biikvIGuUkGcigG7DYQv1hX9tE1WLYikF1GwlxiB54SN9C+VFE8ET/A+cVthwnCu8W6zdaRGTjb
	PHr+oLpWr9rDy1rUhqD/mgb8EE4KNFbxiTHOuhTiN7PtAyVH9KV2CV3VGiDK6Yj3D5LFLkpw==
X-Received: by 2002:a17:902:efd1:b0:2bd:bbe:e3a3 with SMTP id d9443c01a7336-2bdb03a42b7mr2583995ad.10.1779131531408;
        Mon, 18 May 2026 12:12:11 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5cfe4973sm159670935ad.41.2026.05.18.12.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 12:12:10 -0700 (PDT)
Date: Mon, 18 May 2026 19:12:05 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] kho: Add kunit static stubs
Message-ID: <agtkMYr4-boyOQtK@google.com>
References: <20260512195135.804833-1-skhawaja@google.com>
 <20260512195135.804833-2-skhawaja@google.com>
 <aggfP-0A-i-bYlP7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aggfP-0A-i-bYlP7@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 31065140011
X-Rspamd-Server: rspam04
X-Stat-Signature: jindemyzksp8dyco734uzhdbs677jgci
X-HE-Tag: 1779131532-837599
X-HE-Meta: U2FsdGVkX1/wJtx/6w5Yvcf8w0dJ4SUrb3zP6TCTsVTlXMsQDifWTVJaW0GSwzlAAB0ri1e7SA0abwFMFM8tsLGs5pOvKrK78xZ8IJ73ptL0+ZRBt7iiAutKRTJBiPcXMcnoW1u8QK5ghUAzWtI57QP3F6VwHRum4b1LiaXYQ66q0wyHglUEuJ23dqmwFUc3NIorNNlICraPUuVqnPlVGsQPpjazNevl85GZ7/NPSLoGjE+rHvhbHPhW7oW39XNZOMnoG+IqLjwlhBpqtdxrNtITVT6TK3wCNBIqzwSpWM7lHgYiL9r9O6nLDYioonLNoReAUJCJl8UfSPRo9KtcssAlWnuyNvjavz9KbdjuoXqfJMwTSsCfYGY6JmvtS/pJztgzw4rgi81hGgdk8GlBftoDUCwHGlUAyhSRQpumsKEhkt4aZPMvYrv0z3zPkg9feSQRiUObx/pAObcO4D/unwOW2N++OcEAnrgLyrfyzE+QlahwQYb0iNFzDiCuQ5L1vgcbhFGgu18MSLCnZ+DfHMzLOwzP3h0mxdLZfw5var7c55BXj3YlB9gIKHROoga4ZTi2/dPioFXDK2PBYi0hpfcOKfonuX95IL3Hv/tmq2Of9HSJm73eyxScrEwNnVG6ymdgTB/p3XZlAvldMHTQnQlxqvKEmd6PQaJGJuBeywoKWRfNPBSe6MM2r2IOR1W0TYL+Xe4MWBUMfeCrf0o6hU5ejbuuwqZ1EF1I35pOisB0mwVgwrYsOVETC0EjqvK0m7d5AQ747cC1epGGWG8MJJOlJOxcd0rqpiY+/KtKmXfsYnqeCn7//zn3RtGZheQmx8HSUzQrR0GpenW5uJxaQoJyAyOBSUDL3MKv6jgxH2BVkq8nGGGlrSux0/qyvL8zeLufweIqwYLK4CXFMlx2zWu3MtpVXnekytWkfNiAfpW6qgG+R3+4jOR1yxGcCgcFF9vil9MgfzEHzssuQTT
 7xL7UZN8
 7budi9cpeDXxOmPu8yKFfTtTZ2yavb7MY26+GWqmG8atpK/L/M5iHIdSVPtyFXnsWbx/hDblr/MLvlxZdic6CYJxjn4ozsWP6xcCLyok34WaAkHAu+cz/54ToEyo1k5LkIrd9jNLMNXFzYUeDgdLabW+f5eSPPvr6R4kqeiXCQuCZaY/5ZN6IVB+OnAdkcDwVwUWaoJU2iEK7qGq9w3q20PgiYKfYFOwvo5spfYmBzsDlOB8U9imLbQ4ukZrn+TTDqxlt0mdeMvYPmex1elR5eyohtvTHf/tXItrJgR+5KUGDaPw0Dvywa8d02TFybXtU9Vn5eOd0F9Fhm44lXNCu3kSqRZALyL47WmL03cOAj1RG27/fsDkjb0WnTh+jEPyi+xat74ynZxexcrOETKxWUowJj9fZjXlrTSJnOdaipga3DHTuiFUgPdsAkexKbqX7KBrHNpN2qogeZB60e8zA4tstOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Sat, May 16, 2026 at 10:39:43AM +0300, Mike Rapoport wrote:
>Hi Sami,
>
>On Tue, May 12, 2026 at 07:51:33PM +0000, Samiullah Khawaja wrote:
>> Add kunit stubs in kho_restore_folio() and kho_restore_pages() so the
>> users can mock these functions in kunit tests.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index d5718bef6d4d..1375291d9b07 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -11,6 +11,7 @@
>>  #define pr_fmt(fmt) "KHO: " fmt
>>
>>  #include <linux/cleanup.h>
>> +#include <kunit/static_stub.h>
>
>Can we include kunit headers before linux headers?

Agreed. I will update this in next revision.
>
>>  #include <linux/cma.h>
>>  #include <linux/kmemleak.h>
>>  #include <linux/count_zeros.h>
>> @@ -437,7 +438,11 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>>   */
>>  struct folio *kho_restore_folio(phys_addr_t phys)
>>  {
>> -	struct page *page = kho_restore_page(phys, true);
>> +	struct page *page;
>> +
>> +	KUNIT_STATIC_STUB_REDIRECT(kho_restore_folio, phys);
>> +
>> +	page = kho_restore_page(phys, true);
>>
>>  	return page ? page_folio(page) : NULL;
>>  }
>> @@ -459,6 +464,8 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>>  	const unsigned long end_pfn = start_pfn + nr_pages;
>>  	unsigned long pfn = start_pfn;
>>
>> +	KUNIT_STATIC_STUB_REDIRECT(kho_restore_pages, phys, nr_pages);
>> +
>>  	while (pfn < end_pfn) {
>>  		const unsigned int order =
>>  			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>> --
>> 2.54.0.563.g4f69b47b94-goog
>>
>
>-- 
>Sincerely yours,
>Mike.

Thanks,
Sami

