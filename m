Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8564FF531CA
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB696B00B8; Mon, 13 Apr 2026 15:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82BC6B00B9; Mon, 13 Apr 2026 15:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFAF6B00BC; Mon, 13 Apr 2026 15:56:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C95D26B00B8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:56:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7308413A0C5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:56:26 +0000 (UTC)
X-FDA: 84654589572.12.5C323D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A170510000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:56:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndjJELwQ;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jObOnXozybWQ3WR8NjHaugETmwef5C6VjxGvGmeLlEc=;
	b=lm9KPd3FAiYhgPDhJaIoq7Iijp7fcVEdIOPwLr3K/46SrudhnGIZtRSK0FmkQXFUvEWwu+
	tz+VKMEtIGgvajVaYov7JDeXGcLFaLN0sVhwyWd3YZqebqmjy6OUsbX6IdhahkIi8iyPLq
	zrS8kjfNEy7A8xWJn0JkSh7Rw2rqFXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776110184; a=rsa-sha256;
	cv=none;
	b=mQIYCs1vZ6mUnXfZR2fOQxcKD07vcDIGzIaCMuiVTYFmQoarfKQt5G6Vn1LLGFdkYR0ADB
	YUbSD3NpN6vmPXhhmQ/nTgavurd8iWDKGDXel43h19uNv6+VTAoRryG2uRyRoJN+cnp3yo
	kw6mBxC0RWgnXlmYrIUQCaYGy1M9PY0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ndjJELwQ;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A69C6183B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C256AC2BCAF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776110183;
	bh=jObOnXozybWQ3WR8NjHaugETmwef5C6VjxGvGmeLlEc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ndjJELwQ00jfUUu4QE3U7V/TbuRaLlN9kEjgdJZDUuCcEISM/NnLTyLrzcs+K9BJ1
	 fI8nv3O6Mpfy/cpFrC9D/0QZ7ciR8i0hz7mlaGQszBwWozyQ7r5V1HXV/xSCT0Sw7s
	 hkXSuekC19dp6LI0q1XVF/AdBon2kMgJps4F3hdM581LZnENOmhla88LMlNLxWGY8X
	 nkKbtoPr+5s1J64i+d6/sVQWUdflVO8s8AvOf0B4Z+X3isOjwrDjd0ZprEZOpRMD0h
	 5KeGku2mxlOJHfdTerlNkDdw7qCjO5jAK3r2DJYE12+Sa7QkEVZL7nemm4kWTo3oxV
	 NADvmXqffDfUw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a48deebe95so39972396d6.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:56:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9grbokNl9NOinRXX+U1SrLTMGCZ5Zj8ys+vMAOjSdtOFG92lz9Hj+X+S22bWLHHbAipYL1+sleLw==@kvack.org
X-Gm-Message-State: AOJu0YxpxpQFYc3feXpY6G0MbpOLKLQkiqozZr1fkXGUYDRIEUizQXSc
	LNp0StwtIxCWaCIh69PWEQCP00Z8lHJ6j9rFG3EWs/YmbJKbevakVM4NfPybumYbDOyrzy1++ED
	7kgo1y3UgP5xM4J1UK2WwoBkl4y8EDS8=
X-Received: by 2002:a0c:f089:0:b0:89c:3f22:c89e with SMTP id
 6a1803df08f44-8ac861fd45amr198886606d6.24.1776110183171; Mon, 13 Apr 2026
 12:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260408025115.27368-1-baohua@kernel.org> <20260408025115.27368-6-baohua@kernel.org>
 <c54e12b0-1a35-48e1-b243-991de246a8ca@arm.com> <CAGsJ_4yL3Y1Sr0MjTd6=ROC0jKf4JkCqNPODMh-m155rUFcS9g@mail.gmail.com>
 <add9XGTYL9sYilqO@milan> <CAGsJ_4xcCjDdFXrbhh1bJW2xT0_mx8T43yNHWCahZ3fBBqU5CQ@mail.gmail.com>
 <1ed24e47-538a-493d-bf37-af76a789ce76@kernel.org>
In-Reply-To: <1ed24e47-538a-493d-bf37-af76a789ce76@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Apr 2026 03:56:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wCBeVfyFraj_dRdsUrSNqDG5a8SO9C3=PFRSt04dRvGw@mail.gmail.com>
X-Gm-Features: AQROBzDWhDQICY-Pnn48ck6WscmI_XxZpwQTOCJY4g88d1Mu5VWOkHuK1ofhJd8
Message-ID: <CAGsJ_4wCBeVfyFraj_dRdsUrSNqDG5a8SO9C3=PFRSt04dRvGw@mail.gmail.com>
Subject: Re: [RFC PATCH 5/8] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	anshuman.khandual@arm.com, ryan.roberts@arm.com, ajd@linux.ibm.com, 
	rppt@kernel.org, Xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A170510000A
X-Stat-Signature: wghtyraaymbr1ngrn1p3b1eukuawiqzz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776110184-116076
X-HE-Meta: U2FsdGVkX1+wGNngjT9hNVEXvtuzI0Dmxc76wEUWqZKzQqiVndqGi/cW2mXPMrsuECW8SLQRRk9i5dq+uXGyyV9dXa6okW7B31i739MeA32AacDaRF7+Uz00g5nqkpFjwZ5FvK2BUyVgFEJvu5SQWJVkrzSpQe9JLc1rW/KQ307lzPLV8zTWuupuw6tvV/haYOcImB2phVF4BNuI9atJignb4LeDnshOD7aJ6NVtj2F134cFxnbf+hgQhNt5rEqmlAC+M7khwhZ1KN2m+e10nng67zQ+eG1STysY9Ex44CYsPGjnBK2Q0esp+qY5AxG8HkJakkq4bt4lrmlC1SG+eOIFucB0vtU4PaRq8dHc9pVbp0O2F2lChU3QAT+hH9rvwEjSrnT0cfI1kBQP2hQ+0DFL5LRYqmvjLunt8dQuijW22K+nhRef8JgkkbHT7ktu8d1e1mZnsQXpiP7HLYK/OZCSnYnJSV6R550jTufJdWDqe5D2kF4aQTdoVspjcjIbc7eEart+gwkiMfCAjMyFHjLzka0I2jGVADeI46+FQdf6J3+5HA8hWMJQm5iT11UxTsGdOxCL1aqnqclJGqTENp1QC8uF8CkTcvCw3mGSCvdUs9GqI0StlzEDy9BD0o+BhibxgtphAi8yBsfYa5KjiwAEhKb+8JK9z0X9pMn3nlD+grsnJaZkOG39/1PxCM6+NjBqDGRkOnjVoDRz8g6iGGxQm5M6WZDrDHnhhZXgPCy2njsDwZ0siB+bIvfynNSWtF36tGgtudRao/Z+1LJDvvbLq1BDCLB+uaWlUkaaxFzyEr4bD0RxQD22EaIyHYdBdr9nv5EytBXqCIE7BqKmF8RRkTvDO/WUvVrl6sNGv21DS7NjRQkzwzF5uU1iSxGj38iz2i08iNuWQ1mX6i7f583euO6tYQjdDhBfP2Z/A19ocqLkVbma2Y06mmv8YWpP/quzFQ4XLa2fmLT+Aji
 jbp2L3q4
 7lMl3lpSBXdrN2c4sAAZqgnvy26Tnt8WhyUffHrgeOoJmKLZFr5wG8/ukNI2mY30qdAxplakDyOYrqS//yTyYbHoixKx9wleGnS2nBRHPDEA/EpiIfEWpqgBGwH84wfGfcPpw5VEZI500VRIKd8fSIu36CWwO+r71gqW/vd+XMuXm9ftmTfjz/6Y+EwryGxCNkUJKpqpCb5dPfWhzE/T3f/re0UqOL0FDfwxlX55x7DEcODVDBPoEaKcWqfoTSFkQc0ieTP2+DlgAOOlkCr2rBjmPa42EoFEO1KrEO7U4GPaCyOSJjl0fuI0WqKoSHirIU+N9o+mfWUJ59n+ksOZstgMyfaDK6AlN46xzMraeV3voTc6RQ7nj/kMjr+mDxLsTYK3LC/P+WZdjLnhUGR73WbRigw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 3:24=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/10/26 03:02, Barry Song wrote:
> > On Thu, Apr 9, 2026 at 6:20=E2=80=AFPM Uladzislau Rezki <urezki@gmail.c=
om> wrote:
> > [...]
> >>>
> >> It would be good if you could combine the work together with Jain.
> >>
> >
> > Sure, thanks! After discussing with Dev Jain, we=E2=80=99ll also
> > support non-compound pages in the next version.
>
> Will there be a v3 or should I review v2?
>
> https://lore.kernel.org/r/20260404084333.55984-1-baohua@kernel.org

Hi David, sorry for the confusion. During development, I
found many more opportunities across vmalloc, ioremap, and
vmap, so I dropped the original approach that only targeted
vmap.
Let me reply there and say that it has been withdrawn.

>
> --
> Cheers,
>
> David

