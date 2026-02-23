Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDCAEC1106
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35426B0088; Mon, 23 Feb 2026 11:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D6C6B0089; Mon, 23 Feb 2026 11:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2CFC6B008A; Mon, 23 Feb 2026 11:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFDBF6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:28:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 845C21A01ED
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:28:51 +0000 (UTC)
X-FDA: 84476255262.10.FF3913B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0FAC140004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:28:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ofecjYvj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771864129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSB+twJ8RQrq+fHV4d1Hxvqhv9VsSzrh8s/dkyStF/k=;
	b=txIemxoblbpk1O3yQhHzsYjsd9SPpBLQeEKqQ6rOrU4iwIV5mZXHOKAKfedB2TgIw7BJQ3
	cJaD96XiGMV64X72ptPkaR1cGn7iw1Xb4hFdzFsJpkCgxTrZGYCNKiaMVBrhDott791Oic
	TVO8AbzmUnr2i4SoB8T8JbugmNKuDN4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ofecjYvj;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771864129; a=rsa-sha256;
	cv=none;
	b=8FQ+BDyERJdrnYHdU2fLE3YpqFoEgLXjuU5X/4r1uKcGuKPaLEWB/fNrMqt/Y+1WNUV8bw
	XTuZmASwHb/rljzNRJznR4IDZTWB2oZkzLx8nlVk9Jv3eTYfqMLnQ34N+86nAt9P51URqz
	DczYXY5yWIgU01zRiJOsc/sQD4M3plw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE91A43708;
	Mon, 23 Feb 2026 16:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF94C116D0;
	Mon, 23 Feb 2026 16:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771864128;
	bh=dl4eqRFk/KrviE517x++cn1PZar9Tp8XEK8Khfk13J8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ofecjYvj20dCGmilmiV0LD/TRrNYIpF4QAIatXjGsQlCf6bxawsnZT4iLzxnyjcwb
	 vPK4jm4v1nSB79/4C2tCu+RcNOWvkxrNXL1Tf0krqX/aLBf854IXa9c5CBDqhX+odn
	 MJKXGuK+IB+by+V4P448oY2VabEbcviBV7rAkOtPYUN7GJAJcMj5Ir1PoKbLZ9x+uj
	 QBlMnsc8VNOqUctFBiBmh1OWLptKyOfw5xukfKmFbUA73OgOoax2hsGeRh4aDFIcvz
	 kx302ts42lzqGTu/SlFjQ1vIcowYoKANs+ztvM9mvEHXxsohO6aBy9ny+yq1MxRQNl
	 FJPwAJ6L2FiJg==
Message-ID: <e7af1815-3028-4530-8d62-6004e421e35b@kernel.org>
Date: Mon, 23 Feb 2026 17:28:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
To: Matthew Wilcox <willy@infradead.org>, Dev Jain <dev.jain@arm.com>
Cc: Pedro Falcato <pfalcato@suse.de>, lsf-pc@lists.linux-foundation.org,
 ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
 ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <yfe2xbb6qwthg3cf4yr7zszpw5o3mx2v4bv32iwnm7yzxqjsvl@et22s2nuwzzk>
 <a778d249-afea-4488-b045-beff3492a48a@arm.com>
 <aZxv0mEd2BA3Mq-N@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aZxv0mEd2BA3Mq-N@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A0FAC140004
X-Stat-Signature: wp9ygkwr8j4e5e8aw45faec1tzy9erb8
X-HE-Tag: 1771864129-914480
X-HE-Meta: U2FsdGVkX1+f8IEtodbYH1Rtgqysz15sZyqm6W+nRnc+cebsRwpb8yXSOcBblSeC5cR6G16g62BAMlmji4r8f8KzoFHjNxE4LcsnhDZ8zJfkPFs52piKeWDfpkJoI5FN4E0ni1x77anhNDpKNln7JQifQnW48zN0XdHpbqSsIRvHBGqgAJwXVci6UJXTEGwj2ProonXVvExU72yNa2kHm+KVWfBIFs2pv1xuLGDXfoVI48J8ozrDr9iUGjl0MBaixLXM40uAwSM3fiF5P6/iO6dPhYOleB8zZzRBbFy1tAi2QMvsGLVTWAgCpT50XiZJhDRlwvsknIXgnHbGOv52wg76vQXJnzbXAfW/61RyRAjUmlt2EYIsXgjbWnOFq8vzVBhCpTW94wcsPZrSsUIHCpmnHtj0dYTop7UJZzENfbcLU5Xfu7Jm2MSJ78gVu01yXqcK6hTNknAi8TsK2gFux/JxFl0V8mz83YnqVGITC52l2pkXE+AnlZ3Gke89d21Hhtlr8hbfk5sYTPGRax0Nt4aGMIT+qDICEL1PqoZrGtMMYPuIs+JtlrdrItfWyGD9HoE5tqQusqkYyMkvRq03YFuY63Mr/g9Xx/g4OdGMtZLCqkgNoytORaF9VtQhrMYeVIfwzzSApdMV37T4qO9BXqWS9CTqSPn0U0w+u/fzvRsXLRTCbzqXrZxpHGLN1TfLCuWs2s15LmAyVowW4NQDhWHO/tJy4dQlrhhQdRlGPxsr7oiw4fZUQ+OqBS9Rt/bFpWtKa+P6i3oqYikhW7qo++C94BgFkAQOJFoKCVZkm+34Rl7XAL5xf00sOy1hrqmHUMs1iWbP4gcSlqUpXAKXuIvmHgkKz/MWlQh13AtatVzCFJtuG65oOz1QR9s5NeHPatbdv9nJjj5ZOvij1TAwP8PgNLyH1eoJCht0xCB9Ual1C4Kr5VqhWYUXEBA3L1CiaY1A8sMoy5+LG4NWMIw
 MsmPtP8G
 IcHEadQZMiYQBSae0KUWctR9Yk/3ow6Vi06IN+OJknd+B9A2jebpn7hc5a1kbQ4lylRF5wRycZu4cYifeGV/bVbEOabMHDv+dQ1skecVDDXrxad9KYRWYOYshym/xa4Xlv39ygX7N8jH/sCl87pyi9XYCEqAf/v0KTzbDc3M2TbPXraBhfupejeIFgCc5lhcoqONmJUIaWD0gZBbjQhsp0b8peijJX/rS0jPVGXRhKBL+uhycltZGU65T4xuu9PdB+MMC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 16:18, Matthew Wilcox wrote:
> On Mon, Feb 23, 2026 at 10:37:55AM +0530, Dev Jain wrote:
>> I didn't understand the reclaimable reference, but yes we need to make this efficient.
> 
> this goes over 80 columns so much and so often, it's painful to read.
> so i didn't.

I just found out that Thunderbird was lying to me the whole time.

If you're using "Toggle Line Wrap" plugin you might think that mails are
properly wrapped, you know, like *they are displayed*. And even lore
displays them properly.

But in the back, Thunderbird set "format=flowed" and screws you.

So, if anyone else believes that they are sending properly wrapped mails
with Thunderbird, read

	Documentation/process/email-clients.rst

and make sure that "mailnews.send_plaintext_flowed" is set to false.


Thanks Jens for the pointer!

-- 
Cheers,

David

