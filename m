Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885C4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9E6D6B0088; Mon, 27 Apr 2026 09:23:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E286E6B008C; Mon, 27 Apr 2026 09:23:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFC86B0092; Mon, 27 Apr 2026 09:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B97C96B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:23:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D10C1401D0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:23:44 +0000 (UTC)
X-FDA: 84704403168.06.B721E2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 995D04000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:23:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=keRPqmoX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gBUer1rWmgE2WRHUPzST+NTjyYkQ073REfOKlXWxsY=;
	b=HO+Lln0hUatW/g4AHvGcyvHd2Nm4WAKmymBkt3c8LmJl62OJaOnkqCFPpRDnZuqYcirRLq
	HgAVvBKCgQ1c9r55y6KGy3fnnsIMfv5YnJmAQUt07YXz7DrMuh3SsmaD7jDcvmM1mX7hqY
	Bg9UY9qv+rMgI9xNlkJL9yjyFVSv7cA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296222; a=rsa-sha256;
	cv=none;
	b=47Zg0a/m7yqFVTVBv0HfkMXeyN8vKSMivT4EWRUEQCR10d3AOhPF1sDQmVROmz+Z8Cfn/T
	Lh8jz0zWK46I2/jx1D+BEpU1XGdgBms5WtZ9leYktytxp0Rc/6udVs+RsQHUEB3cB4pLcL
	CuwozpSVGaiA1khOxHADCLU+VBjXPZY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=keRPqmoX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E765660138;
	Mon, 27 Apr 2026 13:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA73C2BCB5;
	Mon, 27 Apr 2026 13:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777296221;
	bh=9SNdGN922VYga1JfQ0RumaLfPFgOOjYtthX/0Ll8Wfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=keRPqmoXEQVEMnHAPVtcM68vKB+aQBsOoH0KZMMV8/OWuQTSRdB4GpDONopGqcw8S
	 XW05BbY3zjK9z+EPi7eOpTanKL89b2CnXdGXSKmlR/2yezKGDOrKPtlzNYlNpgyBPm
	 3DcCBKGvQL9TjSl3Yu8ODAFvOBhErDRzgeab/g9S8oT5ftRLVZHVoKjqydr5G7F6R7
	 vnKQDDKt1i+YY5MEDUA0FAKGClqcn+45WrjIjRWdxRSiyBke29JmQXIaPJ3qaGYh6y
	 Q+JjXAzaYWUf+Db5kecXudNpXcRQNewsfOPjPWb/vRodacWwowJunPCs9YL9PEjLOM
	 xcgY503NyLU2g==
Message-ID: <06218a87-8346-40b4-adf4-dc494b5f1293@kernel.org>
Date: Mon, 27 Apr 2026 15:23:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: remove page_mapped()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
 <20260427062137.48739e6fa6e550f1f0e8ff48@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260427062137.48739e6fa6e550f1f0e8ff48@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 995D04000E
X-Stat-Signature: fiqhr5bnnzqczg19iy5umgouafsocf3y
X-Rspam-User: 
X-HE-Tag: 1777296222-814107
X-HE-Meta: U2FsdGVkX1/swnnPXw3EGbN0C3M7n8wi4Nq0OwP3IwKtPRqGDbyQ8YzMDJXBZUe0FN+98Dw6DXYXMj0UOGHPT2owZTts3HpybXgsXkAoHcftP4ByYW/+lSmnKLJP4pkoFoB/nKuhpp92XvE1OwKb4AO4lFkD9ZBjtgWvtPmWYVuiA5Qr++1Vu9w4Lp/XEcG7CiFgKUlyNtGIWGMxWkvekWQqF/588yBKue4lYb53fvy9kPkQfGEb3tbkb0ne8Jp8DWO0GiGv1CABtmvBJMsg71/az+GW7XaXDQdTSmAQFDMGClzr4zdYgJjM3OUlOgj2BmHCufTe4cRF/xitQ7yXvcbKeQeI5NllfWL2R1cfBheAPi6L7bTgP4CUGyQ3SDBqApHT7Z8u0nfihGv+FaBcONDDD2SvxtH07bGUJQ8fHWz3/k96boDoTCGq/LoutH+UmCWP12D+sv5Y42BuLFMj2n72y0ABBiHYSFuZduPmEnVbCke1X7yf4edBc+W9OzsukXr4sqViag+KLhUE2PkpLh46y8Ycy68r/jircS1KBo/KHGZV73ALL20fDwB6zIE3dYwas91QXVXDrIWIlVEP9NRxFnIIdcncfoX+o6lhiF/tv2Kk30MKlOSf3YedASAuc+rV0KueWDqHHIksh1hWYpMWBcOk0dkalTc2+xyWLbUQwa7CzAJ5/yrf/loEQrDFMl+0PBqlPDhm6lOx+SpRwxW5MK+5Q/pAk8+KBLeZsSIhF8EyyKYtngOJQN5hYjjR5uiQtn4XuRI51q2BLoQXZVqC4UMhGS5WGF+E020J0vXmEuTRGpOzBV5KggYTH7xFG+wNtm6jQj3/0ENOpQCU9a3qiGB+5tkBSQ73AEyRV8zfFXzusyGYO6aj3tdYuZLJxaggiD664DqTqC22Y6FNVK90w8BIVMzhAoyOSSW9hnaOYuG0TpfEPrecqAoriLNKLrXGJ0LXhGViFJjzjOY
 UoSc3Fb6
 JwRyXe2nn5l3ppUH8EKv8kC97390O3Mq/dbukU9ZzH2DFYTtBhq0xCVuYheR3xdjiUELpS+shYEjAdCM4dsnuWEvaqEMi81UPPuKFxIaezhgr2T6UEM2YPMlLtL54O81Td+l+AcRaNJeHa7KNKklP2LsUalxY/o1AAhjdMz8TEpaphl6jGAfykEsOrcJ3j/U+YQQpi7+joHlnYg6BZdw85hbKC2uBahjV+Gxe9O+JLy1hBKTbbW66Hg1smqE8U9ucoGwMj4aNwTkNQJD7pUNbPnp7+NYr0tRMyxhi25aJGd7Cyog8Fa5yhSid2LKNwYSCLe+F/4cMC/lnOTIf87FYv7iwa/UF62QnCsqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 15:21, Andrew Morton wrote:
> On Mon, 27 Apr 2026 13:43:16 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> Let's replace the last user of page_mapped() by folio_mapped() so we
>> can get rid of page_mapped().
>>
>> Replace the remaining occurrences of page_mapped() in rmap documentation
>> by folio_mapped().
> 
> This broke Breno's "mm/memory-failure: add panic option for
> unrecoverable pages"
> (https://lore.kernel.org/20260424-ecc_panic-v5-2-a35f4b50425c@debian.org),
> which added a new page_mapped() call.  I made the below adjustment to
> Breno's patch:
> 
> --- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
> +++ a/mm/memory-failure.c
> @@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
>  		cpu_relax();
>  		return page_count(p) == 0 &&
>  		       !PageLRU(p) &&
> -		       !page_mapped(p) &&
> +		       !folio_mapped(page_folio(p)) &&
>  		       !page_folio(p)->mapping &&

If we have a folio, we should really lookup the folio once. Not 4 times.

Breno's patch likely needs some love. :)

-- 
Cheers,

David

