Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C77E6CAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8258E000E; Thu, 25 Sep 2025 15:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258A38E0001; Thu, 25 Sep 2025 15:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195AD8E000E; Thu, 25 Sep 2025 15:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07C588E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:38:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 985B4119A16
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:38:58 +0000 (UTC)
X-FDA: 83928785556.21.D4F18F4
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 681B4100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:38:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MB6FHwY4;
	spf=pass (imf14.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758829136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75E1Q5XfZ4Bfg2w2EoM2j48gcNpE/T3wRma7TEvZTJE=;
	b=UNJQgmyvVc0XZxVe95UmjWxIktC0kj89mWFWi0MBAedRHXj964KLh0DLJmg7EPzUURT5Kj
	3k0Qr9Ci6+2hFciXt5Yt7CeWwti0saHL2RN7WYWGK96h6JdPjY9a6r7WBxvKdl25lgsZyv
	x3yC8aufLo7b8gvnxCq97lo4BtcSJ5k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MB6FHwY4;
	spf=pass (imf14.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758829136; a=rsa-sha256;
	cv=none;
	b=sGxbIU9XiWfbVNrdyaQqB8g4dkb81PbmDKuFTB0hJaoFmBRXvsvSfBMu1iXRUfsfwgEdUD
	Bapxp3w7LdkzpJPm6SH/YkLlyzf9UptClBo5hlkv9Uh3/UfxU1vCTKQm8d7piU+z1W3rE3
	Nc9xoCTH7KpU8J1ojD/NzkCZbLkw5KI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=75E1Q5XfZ4Bfg2w2EoM2j48gcNpE/T3wRma7TEvZTJE=; b=MB6FHwY4LDBtbxBXqasNGKvKmb
	S/OHSszJAWTRT0GHLUTxTYu0nt271jQEUCIbnfuVQPz2NHc08vzEq/kOfVsyZcmda6wFRS8CNXnMn
	uyvWgj0flV3U7LjTvvWPHxidi8WOos0kKym6b2vG/lmEnwb2C5DNRC/drFq0cHwMeLGsHjQ9EtEpF
	1LcntmscQGblOBfN/Feu2kxsbohB4QB0dUhUUZyFqscXDBo/5lJiSkjEUjdQVGLtxdCIMEPl8diu1
	yn8s7IEaBmOvakBloYUqIFhdbdeaOVXNni/kdUYmkolP6O38wbl7UUyxpCDxXp7NgM9S0eszLMjkf
	Y/0YuR3Q==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
	by fanzine2.igalia.com with esmtps 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1rnk-000GyL-KV; Thu, 25 Sep 2025 21:38:48 +0200
Received: from webmail.service.igalia.com ([192.168.21.45])
	by mail.igalia.com with esmtp (Exim)
	id 1v1rni-00EDOR-G8; Thu, 25 Sep 2025 21:38:48 +0200
Received: from localhost ([127.0.0.1] helo=webmail.igalia.com)
	by webmail with esmtp (Exim 4.96)
	(envelope-from <mfo@igalia.com>)
	id 1v1rnh-00BmjL-2w;
	Thu, 25 Sep 2025 21:38:46 +0200
MIME-Version: 1.0
Date: Thu, 25 Sep 2025 16:38:46 -0300
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
 <vbabka@suse.cz>, Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan
 <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH 0/3] mm/page_owner: add options 'print_handle' and
 'print_stack' for 'show_stacks'
In-Reply-To: <aNVpFn9W0jYYr9vs@tiehlicka>
References: <20250924174023.261125-1-mfo@igalia.com>
 <aNVpFn9W0jYYr9vs@tiehlicka>
Message-ID: <4c2a467113efd085530eb055e4a4e1fe@igalia.com>
X-Sender: mfo@igalia.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 681B4100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wgyziw63oyjc4zfdzgduxobq6orrg4za
X-HE-Tag: 1758829136-174491
X-HE-Meta: U2FsdGVkX1929UXoNFDeN9rZlzkYlb5jXs0C9dwHzGQ1krwT6N6jBWt7y+YMlWcvuzRe1CR+a6+MVA1336cVVT95nHHEIdSQOuE4vAc6ST9GL+rayZ/7hn4Z1lbbJ44HykMrY2FngbHQJOtn0PQB1i7oCc167GmHccaDwNmb/Ed1RHvFt4iLXHsRKr35cfXgo1yVtZgOyx+4ZzJeG2dvdYqEDGR2IVrVCx6dVBasbjuXDkeoI0j5PTeKDvBdjTcmfk7P49M+SmQxpefLGB1H0Sza/ldzolkE1cGa2ZDSnG9lBO8bGNNajW3i7nAd/U1iTxHztO3KmJporJq5MXjCRpjHLaelNvEP37se07r12wRm3T99Go7aovhy+AAq4WkA2s4tOaJuX76uSgMoEdXUOBIeIWXxXCwDfA/a5pZn4upxieu6LU+vf5rTZKgyTX8Ly4LKfl5QeYNflpuPGUZVYC9AzS9tfnTwTidPGPp3wRi03NDI+E1/HzaE1lfkZ752dDAHBZ5/WW9OxYhfp3HWOV/z005OHicwbM53EreuegbQNj1M5PZSW7WjVdRpap1+dxkY59R2JLu0gipXgww5Am5VlyXIxjxXJAnRsTCqb6UenMBekOzsDXW15C2TWzXc64K5a/J57eoM4vVj0+2t7AZnozcoXscgE6PbJstxqv1z5cpRi2ULfnQQ24qfDsyAG4ICZNKezbMmYznBt5eXLGGjfG2s7xGgsMxYK//yMgjCRTJymZrMybOmIqW7rl66t43Ve1+ZwyCaFAjGQgmcYe0/vjKmpCST3d7JH4q7chdcivBwYr0CsvhNIfDSbEQyo0wT36JOk8pH6AW7g57knQzDCFvCXCR/2yc1zvC417wXAK8CDeJDB+j2/mxuBBRltr894A57q4eZHAcd4Dn2XubJb4YeHy4k+c7IyjgEZN1vnYPxdzeXjyelPTeWSilH2vfUGyZpPhvDSuYf3ee
 aJkNElOR
 6ippn4KJ9J9t8posLLqZZwZ/KT08rz3qLnixvgEmawiDohC43JM/yhDN5S5SQKOTliq0nzhm45wUDMsI6FjPH1Yei5ZaC12FV3P4uXbe6DjmzNPvXLkR20DsyfXKvCW5xHCk0EbyUPDQHagti+rUntXpjXLuQVr+ghrb8RHTqgRi+6KTQG5cG+j9YlHCNoduq/s6C3mufp5ip/+dJ0T5QkGZqY+IDjGXMVEnTrBiU/8f6qkIuvQqh3SYJovD0YRGsQpoFjovyrKMuZ+BqHwCaLBQy5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-25 13:08, Michal Hocko wrote:
> On Wed 24-09-25 14:40:20, Mauricio Faria de Oliveira wrote:
>> Problem:
>> 
>> The use case of monitoring the memory usage per stack trace (or tracking
>> a particular stack trace) requires uniquely identifying each stack trace.
>> 
>> This has to be done for every stack trace on every sample of monitoring,
>> even if tracking only one stack trace (to identify it among all others).
>> 
>> Therefore, an approach like, for example, hashing the stack traces from
>> 'show_stacks' for calculating unique identifiers can become expensive.
>> 
>> Solution:
>> 
>> Fortunately, the kernel can provide a unique identifier for stack traces
>> in page_owner, which is the handle number in stackdepot.
>> 
>> Additionally, with that information, the stack traces themselves are not
>> needed until the time when the memory usage should be associated with a
>> stack trace (say, to look at a few top consumers), using handle numbers.
>> 
>> This eliminates hashing and reduces filtering related to stack traces in
>> userspace, and reduces text emitted/copied by the kernel.
> 
> Let's see if I understand this correctly. You are suggesting trimming
> down the output to effectivelly key, value pair and only resolve the key
> once per debugging session because keys do not change and you do not
> need the full stack traces that maps to the key. Correct?

Yes, exactly.

> Could you elaborate some more on why the performance really matters here?

Sure.

One reason is optimizing data processing.

Currently, the step to obtain the key of a strack trace (e.g., hashing)
incurs
a considerable work (done for all stack traces, on every sample) that
actually
is duplicated work (the same result for each stack trace, on every
sample).

That calculation is a significant overhead compared to the operation
it's done
for, which is '(calculated) key = memory usage'.

Thus, optimizing that step to just reading the key from the kernel would
save
resources (processing) and time (e.g., waiting for results to be ready,
on post
processing; or reducing the time required per sample, on live
monitoring).

Another reason is optimizing data collection.

There is some overhead in periodically waking-up, reading and storing
data, and
later in filtering it. (Admittedly, much less significant than the
above.)

However, despite being a minor improvement, it actually prevents the
production
of data that is discarded at consumption; that helps both producer and
consumer.

The cumulative improvement may be interesting over very long profiling
sessions.

Hope this addresses your question. Happy to provide more context or
details.

Thanks,

-- 
Mauricio

