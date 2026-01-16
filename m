Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 665AFD47CD5
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0C56B0095; Fri, 16 Jan 2026 05:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6ECC6B0096; Fri, 16 Jan 2026 05:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B712C6B0098; Fri, 16 Jan 2026 05:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A324B6B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:51:27 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 80F781A05D2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:51:27 +0000 (UTC)
X-FDA: 84337510614.27.54369F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D383140008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:51:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7lZljhE;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768560685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYokbY/hdLg2PcyrQsDfn3Xm7OMEKd+eCsy1gfrsArk=;
	b=e/XFhnisWy8YfWtwn9+Fmxt7WZDHxxtmNfI70eekLNTOW+/wBR0VNIN/yyKVBufYlwvpdQ
	yq+AUw3GfzOGnDd5K4E4fHyX56dyQNGDGtFvOp7joLjMTo7u6ammYNtVnRf1+M7dRNu5zm
	cgi4v/eMTesV88v4+6w6Lu3bdCya5WA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768560685; a=rsa-sha256;
	cv=none;
	b=44QVGgAsbJdz1MU1uYw3pGBSY1fyRp64nQINE++us52rib8G78U/4G5/qcNv0ktCAl4HkH
	IonmKH/RL64fhJs0Ep47JJcxNo11u0IDFqCCTT6FB8GLVXgGRALOIMxrPFMWnMiSxMJkZg
	K6EKeSvjLXIvCtlghI9oc2UKep+VsFM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D7lZljhE;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16E5660160;
	Fri, 16 Jan 2026 10:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A495C19421;
	Fri, 16 Jan 2026 10:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768560684;
	bh=rFY9xlBxTcO5q7oAPkLGToaIjHoIexlwDVGdEZseowE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D7lZljhEaM8EZsQZkib/DBBz4E2jIkdHSOXRdXaT3UyzCaw1B043eK/BUrQfGXKQD
	 WYufWQmpgBxWLs0vBWa4it1La8XZaoby0CPydcmctlompiEpR35FLxgovt7jQ1KSSj
	 n+RnWxxw2P8Zm79JddxnB1y/hGjRdlDQw/m3IsA/2Pw3dPLD2tBbPoZZbyNf/yWPmY
	 //WZsrdDMZFsTlpsy+WcjjThVDXHRLKlKyvZu2Mu69L9WPxbXtu4QEvLlKoQ9r9YpQ
	 L6k6X0pf/YkbeKRyPt6zA1FZGrmvCr27y/d3+vszoGnqUH/2OV6GwOq2DJcHEUiMMX
	 m9+3TDLV3emvQ==
Message-ID: <5af933d1-8c64-4d3c-b835-d90c8e9f771a@kernel.org>
Date: Fri, 16 Jan 2026 11:51:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 ryan.roberts@arm.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260116082721.275178-1-dev.jain@arm.com>
 <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
 <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D383140008
X-Rspam-User: 
X-Stat-Signature: hjyt4mpr5jkp3hrj9bkmj633gdfda6as
X-HE-Tag: 1768560685-912397
X-HE-Meta: U2FsdGVkX1+dN7PPmCiyMBD9NdjrJFc+Izk6aVlhaxXyo0PshkP9KC9dbTUM4iZ8GL1xz8yfsITcAu/sp7ZDVUDLSXL2Ah+erkxu5JhJDcv1nVGVsV1lUSYReqyN9BD/lOp0xybwbKUBMzOdAJvv0mZPryV5H1MtmJlnFLnHnDqCSEbwZ7i044A5SoIuyN9fX8LgLZ8KTb9mM7mbqtzvMSBi5KFZf2TdwDnWCkw0xCiM1bPzx12jTGCkqHJuReHrT0qTcnhqHFq+HYp4H0VvScNn+oudpsC6nwSzVkZhl6EB7VC+w263/sGf6ykbr2oBKNyRWxTfbJ4bUV9Ev8wBsSdo5FFg9IT74ay7TIdKuRR0V3BOCDVIupoYr8yj04rgnxIizywd4qfHU1vn+gpC2z4knD2BxPBbDPwU5fkaITMQi49PpGO65FhxxOeYXvauczR6j+BWDCigx8M6gcXdve5VJf3N5iXfai1xVhvy3bkTW2gerCLULsJb3z2C1hd1wpj5pVVngZcN1e+EFl2O19FRA7LLuSh98e9rTpUxhdl5Cv7J+KFQ7CLAdCFq4NI8W6U6v4HJEXUiztUZs7JjywawZluQQsfz/fV9S7w4b4aYbW1et8IwIf0Q82wuXmYY5EgohTM2ATbLUa9IwgB7SjvT7YX6hr59d81r4QrpyLZznZo9oScW0MSbK2+wuaRJOtIO91DkLjDdCqP1ZeTv2EnF4CNR8DMRM22ZEURYuSNj2baZ8gEPvw/nkZluSU7oUm6o6h8cCfp69KoLD+NQdPesadqPyMM+z0XuNDOgEbtqUKo1kbZ4qyTr8C/22lxiulbEumyjSX/eHSbMwIkiCFVC1m4g1cpUlXH7OTFcxUDft2sKFAIa2UC3iM5NEO7VyTVpGpdHZ7e3oz7vhDXdeuNeKThyv3mEZBPQSkMoDRvmM1ovxUIB2F/aQWbSphKNS/Q68WI9N5JfyCTATax
 i+D73nd4
 oUDwQv+eEhxSdrFWDf9+T5TviErKKpKmONNzkVxVKvFaQXu3A9AjIeSWTXpZqdYKRIy6op4a7tHx6Ju4RNrqEPCCxw+/ywwXaSd+RVn01yte3tYoOMq95/9r1VPZMfF3use5QWKs8Oza+pPyYjgo6i3upa+1zgJS1Df/aP5gKb9v+3hSrD5lEbhdOibANkmMCQjPuIiXU56VrP14KaFALxpOZYI/QzWloOsOa5ctUXAmHkIQnK7q+a4ex0cxERvtcfHpB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/16/26 10:40, Dev Jain wrote:
> 
> On 16/01/26 2:09 pm, Lorenzo Stoakes wrote:
>> On Fri, Jan 16, 2026 at 01:57:21PM +0530, Dev Jain wrote:
>>> The recently added file folio unmap batching support forgets to update
>>> pte_install_uffd_wp_if_needed(), which still updates a single pte.
>>> We end up jumping to the end of the folio in page_vma_mapped_walk(), thus
>>> setting the uffd-wp marker only on a single pte in the batch. Fix this by
>>> passing nr_pages into the function, and set the uffd-wp marker on all ptes.
>>>
>>> Note that, since the nr_pages passed to this function is always derived by
>>> some sort of batching, it is guaranteed that the set of old ptevals of the
>>> batch have uffd-wp bit on all ptes or no ptes, therefore it is safe to derive
>>> the value of the local variable "arm_uffd_pte" from only the particular
>>> pteval passed to this function, but apply the result on all ptes of the batch.
>>>
>>> Use set_pte_at() in a loop to set the markers - we cannot use set_ptes()
>>> as that will increment the PFN, but we don't have any PFN to update here.
>>>
>>> The userspace visible effect of the bug is inaccuracy observed by workloads
>>> relying on uffd-wp regions to install their own pages.
>>>
>>> Fixes: 8798e255b5ec ("mm: rmap: support batched unmapping for file large folios")
>> Hmm this patch isn't upstream yet, so wouldn't this patch be better as a comment
>> replying to the series so it can be respun?
>>
>> You only do a fixes tag for either upstream things that obviously have to stay
>> in place or perhaps things in mm-stable immediately prior to merge window that
>> can't be adjusted.
> 
> I saw that the last comment on that series was more than a week back, so best
> thought to just do a folded fix on top of it - and I had formed the impression
> (from the conversations on list) that akpm prefers fixes over respins : )

That series is still on my TODO list and I hope Andrew will keep it out 
of stable until I get to it.

Hope is all I got ;)

-- 
Cheers

David

