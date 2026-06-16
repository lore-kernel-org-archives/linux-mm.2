Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A92BCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 184FE6B00BA; Tue, 16 Jun 2026 16:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E77E6B00BC; Tue, 16 Jun 2026 16:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25696B00BD; Tue, 16 Jun 2026 16:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA52B6B00BA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:53:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8CA712012A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:47:31 +0000 (UTC)
X-FDA: 84885903102.04.C410CC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 01D85A0012
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:47:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nDwbZi8+;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781617650;
	b=PlyCsaKNUEPfZnEmoMFnAAaXxraSuvFL5u0bR6oLlwWDLYtmraRIpcs/6gidETcN3gGeZ3
	sVxgpllG2WOdSb9HRO3/d0CzKx//herUbhWJ8SqwLgruPtK52LfKaLc+n5acCAmlERMRuH
	r42/fB6ej2mgRGD3+ta/LFr12znbwP0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nDwbZi8+;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781617650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueqeZiXccR+1N8MpKcCjFRAaupEEHZmjagtqJlUB+8U=;
	b=s+mcDL5wiCN08E40mTDsYu92y1LfFn6cgRFywMlgg2UlEV8z9lBAZuQx6avM1KiD5NQ0yz
	56RClmLQXQxopIuAQQ8rFvKABWtxX2Mw6nyj3Vsl7gg/yRivFTW/jYVzYAnWQF1K+/EmVH
	2FfXGnuL7mvimuItz4QhEP6J2q++3Q4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BE2F600B0;
	Tue, 16 Jun 2026 13:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A8B1F000E9;
	Tue, 16 Jun 2026 13:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781617647;
	bh=ueqeZiXccR+1N8MpKcCjFRAaupEEHZmjagtqJlUB+8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nDwbZi8+e/dGKXtcrpGXPmEhM/DghMEGVTtHfwSpQ52zGuICYxOi74vFCQv/zHb80
	 DNKwTVq3dqwVCanjs8V86bwWmI8ky5iiV43lCStdWAO65aHH2tuGh0AG31eb8lJqaX
	 uADyOz1Kc8lxE4lUKSowubuVgh09e5GsbAHLrxJwUwt0npwdkEq+Fo3E6i1XnhUbKU
	 4PozIljuPdj/ttLdWN12uRXYlU1wu1Fjdh8TtZnbzya5rR35HbW/YgT3BDZ7OLDFJj
	 67ffidd+NVICbaIdx0tGW4QR5fFeasy23xBEmaZ3TIY6mer7PdNlK+lhcnRChPKKN8
	 HnmyE8SNOudcg==
Message-ID: <762b89c4-c452-4922-92d9-c245dbbbe076@kernel.org>
Date: Tue, 16 Jun 2026 15:47:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/12] mm/swap: rename subpage->page in
 folio_dup_swap/folio_put_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-7-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-7-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 01D85A0012
X-Stat-Signature: ah4odfrk7pamuesugxxt41kz6gc3john
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781617649-979325
X-HE-Meta: U2FsdGVkX1/PMI+Hbi4FlETB/CpCR50SifTT8JcMi8mies8oFkAYXaT5Z026HiGTun/rJl8WtDDm/7NWu68VvycJrV5KKg2uqdpOhC9f3SaBtdw8A7uPwk7u6X7JVuf2LcRJukdqVUFoNN6Gk2BZe1BHTslnY+Duf3AqKyOweJ5Pz+zQTOj+jjcywGkQrfPyBrWwJ4BQABTaaQn5GLbLPkhUpSQwzcQ81FMlgW5iyKUpG9DaMN9bNCji1l4+TZb31D29El7opUWe+arLbooEctZZn/3fv7xm+uRpYhIXVgIH5imdA3TLb0+SreSWoXlqotXQYUeBT+yhxG1HgqTCMuWAcFth0HIBF70kA6Upj8V7OY5iDJBnMPExr8dm7EBapIeBI99G8KDro05In8MXrDPn4+HjarMW2d5sYSEycgwCeFIXBRqHdJD+8Q3kTUMHHksBIkVsmI5gSSMYpD8JIJI8W+2RfuFk4pimOmRztCEqMUtoriTmFnXql4OM+6MLLiVN4zZWamQzsahCGwBw4SA5+A48P7tPkVI/ybb/lZG4r6kE1wMdAgjUDTkZi4fVyc9dUHpHnGzBVX0wkduNTZzw2o1W7tC5IlEvtX3ggCL/9TfJ4YUTtjkLhKcyDh7ZvOHN7AzkZzDf5w0bjhdcnnYy1nZBlv17sZwikeCLZsolUkcGE0tdV0ZhlRa4KvWY/cEA0p4HjILjqnuxwT2miJpVKwPxsm829K29RIrlSXFWLAciQIWL6nJHb5ayo64pzrx+wF+Vt/7hIVjszmh0ezH+j1c4nKihPtl4O6bpJ+vYstUh3mvKjW9Dv4KWzdlQDAxb5em/1pBJxO3mb6yDacZ8YkSmZpZMSkUMbsOfamu5FVLTrR4OSJKFI8etynT4/kaehgJyQJijqiDxYLpRALuNnOXWdBW7U4RMiVp8oQSfuKoBxlBSuS2ucrsgvIBgM7KqYa6Yb+6b1crA+/D
 qLiA8k+s
 6XzurW8nCizOad8C89s1BJI2V5sAI4lSiRhyb+GOcXASLp2BWcaTTowUpveMKTYGc0r9/h+mOKVQA0nB3t/+ffAlNItINUl5XPlkmQQq2GfFs3tVPLJYOoAMs5n3IYAESs9Ghkc4m6H1at28ZA50x0yunVuzjED2fk3J0pXclxxf3CuIhn6vb0TRAspbqnDW7Os4ns4jxdZk1WlheVVpNBhGB2ukdAT6TGFoNRC/SfxgNajw8kJawGkfy63eigOkvwxNkwdKton1dSEJ923FR2WbmY1SaPTyt4zb8C1mnn8AUkwWkwtv2GlP75AwQg7n8AoWP79yKFavG1bkfqZkI0aixddSBxg+W4naH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.
> 

I would hope that this patch would make Willy really happy ;)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

