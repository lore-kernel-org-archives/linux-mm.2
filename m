Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F31660705C3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjyN9Fuf
Received: by kanga.kvack.org (Postfix)
	id 467076B05B4; Thu,  5 Nov 2026 14:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EAD6B05BC; Thu,  5 Nov 2026 14:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337C66B05D1; Thu,  5 Nov 2026 14:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 131CD6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:38:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94288C0C06
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:38:56 +0000 (UTC)
X-FDA: 85402078272.06.6C24F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C092CA0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:38:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjyN9Fuf;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793907534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9oidt3W9iu8GAyDMM4ltoZqLGvtpDsP22WY6CZR8UYo=;
	b=M4ycqy3hd5mzdXY9NuvW2e0IzaMTvg5TXq1q6NRuvyQMMxU53/voFsqKdqRTV3WAYviWjw
	kw5QIVE/+eqRagPlhErMelOoNYBNtQoL6AEaI3OdT5OkWIEq96FgtCl6P7frH8j4YKsKDM
	UrcRNZqCiUPooss2sRPhzjGWHEygyhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793907534;
	b=cDUNH0s++ReuYmLdwDew0GEcWIuZ1U28FuhSe0VwzPRVB8mZUN/6G3Qo0LbTqGewRxbtYx
	jR5k4GQqPCrP9zwEpVKGpr0aDS2ASaMXHC83Z2+IO7EdxIRY4xfcFM5tu/tF/o1N/kvVE7
	iIhcuH6+wd9tpku6KLMGn7VUWbtOnOM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjyN9Fuf;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14768409E9;
	Thu,  5 Nov 2026 19:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C961F0089F;
	Thu,  5 Nov 2026 19:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793907534;
	bh=9oidt3W9iu8GAyDMM4ltoZqLGvtpDsP22WY6CZR8UYo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SjyN9Fuf/+rCKMLpNKRgJnjQV8FQ3r5/qOTVKUkTxVJvouyVGPiDzw0OkHzFqxgKG
	 laFZ92O779WGlYoHtt4x7OgAaT6CLe9ONxfm9G5yqpI7ZNZlmvkQnOu5q4ByamZRdm
	 L9Fa4DI7ZHkI+eICgdV/7RW89hxHvH7iuJCJYbYxpp92efjX/m+VCymss6/ixHmrDN
	 12kChIvAWV9AtsUij8vMhjPj9MhltujZlW0mx570IIOXk1pCWs3IL8H/kofvglWjjS
	 2xu6VTI9YLzsjeqvrW+thUXrvpq+6fKQ2fB67NXiVUDcKL4toIdtYOoiBNWAzH1PIB
	 ODUgYMm7viDDA==
Message-ID: <6099bcde-15be-4197-905e-13dfa4c83bfe@kernel.org>
Date: Thu, 5 Nov 2026 20:38:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/cma: fix range selection in
 cma_declare_contiguous_multi()
To: Mike Rapoport <rppt@kernel.org>, Ivy Lopez <skunkolee@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, fvdl@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1792032699.git.skunkolee@gmail.com>
 <auM6nqlB9FusAr4B@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auM6nqlB9FusAr4B@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d6cx3rqok955gfpyanof1mtssr8ar73w
X-Rspamd-Queue-Id: C092CA0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793907534-713255
X-HE-Meta: U2FsdGVkX1/mCO4zikgAVnETs5kvSGAtmBzhykOumE94PYndbTGMe6rwMUuUIRM7sZ6xqSTsvfgUrHkuSP1TWAYHgXl9EIg9EknsMhC3sKn8fyIMKekSR77Z3cS9vOOdSKW4a3Fvbfoa3B3UaIzkcz+r+z19WvyEjnOtvaWdL4dHm+HPE4RY9Lh0JQy37KhylKPD4pF/Qcmh/ogkEhTjQJ8Elk8ebpJ/Y+AylRzH2uIKpMZ1EPHREI/5nyMCMMkZFLTVoGSpDr/fOIuKar/iiSnNnGzMlZlZUcGbQL/rTxL7IG6AO1zVixlo3l3UGWNf32ztqB7sK9cI2KwA9nCiSq/KvhSlr6Rcu+B1ARQX4V2MMpG8KfnykJK1j9Lg/qeMfvi1oIcSgURizljDLuylXB8ybIc+v+IV8glxn7Vv/1Qu1Oa5rw9O0YrpMci1CD1G5RxEQHeGAiuwdqFvdrHSCqwMtPu2igD/py+e1Y8R3a1naLrcv5ZqUhzn9aTJoUhL+35FViiDUpt5PZVGPjfCcMDXxbDp7D+6/vuhe6082Ei9NtlCv9BhS0qQKIo1Ca9zb1VM2KRA6LyAfjnulOmm6GRVSxiPnGKZq/jYPP9hJznzDV3H5slR1J0BEA8kVcNr8lTWwidFq2ZnNTRyJm2YS1DjxsZutKT+Atw9YSd+A8MltYyctLwhWca9y03PzsUxLagi3rFI52+vFW/FY8M3J3uC66QXQRXEnY/a1ieFDpeASuppVXZGS3UYKKxvOTLhfa9Jth8G7bpDoOymLwbHuhNIRbzLLqk8dGpUtpB2t8FZ0+pyTEUFmPxzMqIZC8/CYM0nTjGumzyLrj7BoSTV1Mu0+wj+WUIyYP1wC6ZfhlhuD5+ZqJXMqaqgsYT9Y+9QSHbtbHLID75NrQOmrDC6geV5L+x1Z5Zo3a5zFcDjti4ro46pTtEtFhUJLTclXMz3ulVg+Dk+E41cGKGt4tI
 IKF+4kK4
 OMbU18RHDbsJHjZyoXn7uvM+5gzYknTv6EJxrYL+fQuKu4GuC6gM/CondnbF/6eThnOoSKg8C5iLzxOSSd3VviS595dHt6mMIyqkSFWRjfJ7qFA19O8DWjZ1NZ+qaWlCSXEWMRMhG1jloBQaMwWBaKYVuUsDhpNLYCkGRpqgAIbIQqhDTdr3D/HzUQ1P0Ow78Bj/Pv5HyrG6Fp8DNegQD0H484q3AQPcn1CQnTvZc2qn0I2DRT6zdkHk3BmqK9L7KlKcIVTdt537XgYOqhlTsnT09FYZTKjkTHTZMuE0nWPpKAgfWqtaP/A2LiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 13:22, Mike Rapoport wrote:
> On Wed, Oct 14, 2026 at 08:53:39PM -0600, Ivy Lopez wrote:
>> These two patches fix two independent bugs in the multi-range selection
>> of cma_declare_contiguous_multi(), found by code inspection with the
>> help of an LLM (both patches carry Assisted-by: LLM).
> 
> cma_declare_contiguous_multi() seems broken in many ways.
> I'm working on a patch to rewrite it.
>  

Do these two fixes still apply?

-- 
Cheers,

David

