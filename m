Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C27CCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0528E0012; Wed, 24 Sep 2025 11:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7B28E000F; Wed, 24 Sep 2025 11:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404AB8E0012; Wed, 24 Sep 2025 11:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2FF658E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:28:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5956BBE43
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:28:12 +0000 (UTC)
X-FDA: 83924524824.18.9090E50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4EADF4000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:28:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=irQgTQzj;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fO6Z//rPL79a8R8QZxUtb2XRgOYLfIxN6LnW/zgnSJE=;
	b=FVO5jvu5AhvYoJzTDRfyjVHCkPa8mhW0tV/zA14xE56XMg802i8k6lbu4yrG6DJGe5Ottm
	8ETZG86dzBOacA9BJxGyR3/AoTMb5EykCqjvtbANE/AXWl6Id8Ll7J1vSgMfo5zdVI35K7
	mf2wb3e3emNHUGBRbR7pOGD3L5WFlHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727691; a=rsa-sha256;
	cv=none;
	b=QzJLmqkPlfg5iolSzip++6mrut/o2Yav9djmbSfIlR7fIIvBGtVy/kwgI0TQJHnHO1xz1d
	b0FNZydkUHWqEyWSFoQ1EiDYvW5V+qQln8Icoh7s5C6DFpCt8uWRhDwvMVsMhC6vcw0SRW
	6ge2Yv2LIyMrgOa7mXcNQgIr/88KuEA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=irQgTQzj;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EFFD601EB;
	Wed, 24 Sep 2025 15:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F31FC4CEE7;
	Wed, 24 Sep 2025 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758727690;
	bh=O/bKTpvQARqt8FVg/y21EPm0JoWae7amDRNYbxV7ONc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=irQgTQzjfSAjWwFVUQYTRj/oZ1GIQOmw6hdssvbkPidionp5q5qRBCVgMhNc71jUA
	 RpsG9bOvIDFcynHxs5toNX9PmUeYLEkApMwKR07l/VKoaqMkKEi4uDMFbIKmpvCMF4
	 FdTi3dHPyvwoX3cnCcLsFQKRZXASwWuDUzS3vQoQFz2Vn2adC+XM1YHWXIcklNt1p/
	 wYGFAX22klRZ7NuqxsHnDpJjIRZeFh9CCAqb0si0AEFWD9ZP5V67PvFMS8xdbyMuBT
	 V+OlOwvaf35CchUJqb0cx5b/InhHOicYhWFNucyh5gLSkC2/UiOMh2riv7Cjk+T1j/
	 j0+7OvHvZ2RUg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,  Mike Rapoport <rppt@kernel.org>,
  Alexander Graf <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,
  Changyuan Lyu <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc allocations
In-Reply-To: <20250922143407.93e171f8b7c09eb21159a33e@linux-foundation.org>
	(Andrew Morton's message of "Mon, 22 Sep 2025 14:34:07 -0700")
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<20250922131948.GX1391379@nvidia.com>
	<20250922143407.93e171f8b7c09eb21159a33e@linux-foundation.org>
Date: Wed, 24 Sep 2025 17:28:07 +0200
Message-ID: <mafs0ikh7dg54.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EADF4000A
X-Stat-Signature: fkxs57fm7h7g9yfap17abafidjsisd4o
X-Rspam-User: 
X-HE-Tag: 1758727691-683100
X-HE-Meta: U2FsdGVkX1+AxQNhwnUHxrU4pmgu5poHrwaUQphxEnNSXKZ76o0pHhGxfAsGUqMW8RHUDIfQ5vON3MFCob7ICsn7PTHQoGZwYEpmbJOGmG5ujAiFoYcd4fJnNPofyUwSrNC3rRJxr5E2dlugMLgGLUxImvp39LwSFtppfYh9f/lEs77r+RxXnCNWGbz7qT8nxU3McSBs0pbtVbg6P98dMRxCnRDVKJ1jbcS4sVsQtWw0QFq0yVCBKdc+11ylKZu8j9ETvCXpBH6prBbO8syVoqkKekf2lieGmvSyZU9FowOMKqrLh+XYVamwkRjWsuPMY+j66rFxoG8hFQjaf9MQx2oWHaF+v3RkSSWFzlzKE6RAEDtErVZkw466sNpYNHS31GjvhMuG3Jwwjj9dZn4kGFpeIGpmlZcAadymIwDIph4OWEHi2+9wcZBnNu/11AwdYevwGSx3N7C6pT+zLlDZqGwP7wAaNY15jelb4plCevxYwC6lv6af1ESBHE5qG8NsIAieSYqhJiiS0zk5Z+ZWiVyeAXQyc+U+e637D6bAiefo2sJDmQLLOSNQd1bShTbFwGelnorbURtjhZtwNXqp/gDJT6LmgRVbej9hE0sFFxGRDLxv4fNaO0gJW6MazbuUQvHQHI9TxN87Ebc6zczSfvNXoskE/judH1N+wE62GtSHU6OKGZvInbtV2Oudg/mqLmMW/40orx9KdgcVBQMOPew0TT51MGf0isoOnJ7q5a/EF5kYhREqS4OFwxMVbFjAIorH+ju+IArmdFEjeSV+B31GHfY2DL/AZ3ulVC7n9ChQN4Z4KG6wQdrcLQTVGDsNnTgM5KN7RRiuIoNEC17hXR223ODMYS60xrZnYR0BaNwtBw44wWfYxsC6cDlSe0Fo6dIDXDEceSaXGyBvp4Rq3x31a9QcbC7FFTVPAJrqJaser2mujTethzLTV0BvqA3IBl+LKQaKcRaN3jltl4j
 4uTCSOar
 UgDi7U+SYHSm0tcyR4Ppz68zgSIcXeTJQFvSshkXx9xbSJzHP6Tr5RPbmhiugJE9rJ6IRS31pwr3c6tX8lglxF/CIt+U8lMKCGp9aJiKvzZQQgJebtLWaKM6IlkD33QDYCcSR6vQmVr+JpOlBTqHCOc8iznQgvlZuNhcxwAS9tNpcPFsN4dIkHyokgjq9Jc6TCvcm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22 2025, Andrew Morton wrote:

> On Mon, 22 Sep 2025 10:19:48 -0300 Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> > +static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
>> > +{
>> > +	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(kho_vmalloc->first);
>> > +
>> > +	while (chunk) {
>> > +		struct kho_vmalloc_chunk *tmp = chunk;
>> > +
>> > +		kho_vmalloc_unpreserve_chunk(chunk);
>> > +
>> > +		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>> > +		kfree(tmp);
>> 
>> Shouldn't this be free_page()?
>
> Or vfree()?

It should be free_page(). The chunk isn't in the vmalloc-ed area, it is
the metadata to track it. It gets allocated in new_vmalloc_chunk() using
get_zeroed_page().

>
> Not sure why this code works - I'll suspend the series from linux-next
> for now.

It only gets called in the error path and that didn't get hit during
testing I suppose. Until v3 the chunk was being allocated using
kzalloc() so I guess this got missed in the move to get_zeroed_page().

I think Mike is out of office this week. Do you think this series is
stable enough to land in the upcoming merge window? If so, I can send a
v6 with the fix today.

-- 
Regards,
Pratyush Yadav

