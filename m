Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E75CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43C96B0093; Fri, 22 May 2026 03:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF4346B0095; Fri, 22 May 2026 03:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30E46B0096; Fri, 22 May 2026 03:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B27CC6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:59:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C92F1618FE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:59:59 +0000 (UTC)
X-FDA: 84794307318.07.CDC89DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7ACD118000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:59:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgcu1bJN;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779436797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksWIf070K7BXXzRSN1Ju2eTiWS9mqy4PNkoshlF94P0=;
	b=p6Pp5M9F+KKHs8Ld/6j/yRfwW4rh7jzuEz37HyX8Dd8EOV0gQBsmGpv5JEE9RyjQfUMUt/
	TM0Wvz32zsoBYUrVr05tpoRCM5gKoEAYUN2z6JgriDhHE43X2JWhFmXiRGanySLOVntgRL
	a8T91YCnWNs8Z6o3mJ1k6iuMq86GWwg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgcu1bJN;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779436797; a=rsa-sha256;
	cv=none;
	b=QsFvOZXBYF4ooUAb+SLfhy2ArpnRzJuEm/K45kuEsqjhZOYDfKqPPLj1dAx2rWTRv6dzOv
	99CddmV61SmrGhAHJ1wl5hpHhbqVRgFpBz6cxJP7Ln3Y7zb1LRQOlNMliUWtJkcumoVusf
	QUbuM5JXJp+ql4AiXJFiIoZ3QYnGZLU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A29141E5F;
	Fri, 22 May 2026 07:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9654E1F00A3D;
	Fri, 22 May 2026 07:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779436796;
	bh=ksWIf070K7BXXzRSN1Ju2eTiWS9mqy4PNkoshlF94P0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mgcu1bJN0Zm5cDI8nGLE+7dAKJI9KXOskAQMhFcMbp58VdxiSkMAz797u0AxYJYZr
	 6kocNK9k800jYEtIx3nmaVr4t8M0Euf0k0czqlPUEs9pu1mvRznDr7PTtg9DVJJ/TR
	 2QnUzV2BPUZtIF2DUx6czqQkLEZjJEjj75T3HBmqYujrFAsSxkKhcpZzTvAUdLPUUn
	 bVfZKSLsgVzVzh1Dy8aJ2xOW/ABuKXSlsO82wRmweyHdlHT2EogVZuICOXV+VnnAKY
	 UkS6USaW8ElY8NbUSgkTUSeTbNr68010aDiwdp9oyO4fJproRDmCyU6nmyZG/wyzAG
	 UUSNPevwk2Fkg==
Message-ID: <cd721e44-05cf-470b-ae92-d86791778c28@kernel.org>
Date: Fri, 22 May 2026 09:59:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
 <DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
 <20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
 <CA+i-1C1THr6fH=wdTKEngbCSD_DMS5tGroN64BEf3L56DH2XWA@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CA+i-1C1THr6fH=wdTKEngbCSD_DMS5tGroN64BEf3L56DH2XWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7ACD118000A
X-Rspam-User: 
X-Stat-Signature: uxxtn8yteub76a5w5gxkrfz6fcx3ymm1
X-HE-Tag: 1779436797-289268
X-HE-Meta: U2FsdGVkX18xZhWuzX7bYo0zy5U7V3IgeUdHKhwPXULWMHaE9AQDC8FySE6Qyfavp1hPuDs9Ofsehr/asTTS0ifH/bwxlkREvJrN9gu/7NbkWHdqy+uNn6Y6TeS2sQMwvHzWFDngO2wXDogWgPBqVTyd3wxZRLDOuAWZ/DEoF76rUSdzINu+wQfBGnQFq8+YN9qu6a0uB4o3FDuEYq9Xomv05S0cLkvvREkDfuauh4MKx+mewyBTXheTIIODkl+eBHWLJXXXb/Me2zJ1IYgBs+N9tktvEDIjaxysB50bpceqg3cySe/TBtA2hp2FfpzEC+6nxIu62nOffsP3z6coCi4pwQyybSlxBwmYfO4wPstUF37lldGXySpHqU5FYpenQfliuzZGeGhdyyd118QNCqKeIZWGvjgnhap5SI7H3kRVBQa1xvHRfoJgBjSJOdddUSOc3hWp2dhub0QyzyOzuBBAbK7xNcaUSHM7I/Ao/mzSBkhYJZhxTv9JzR4XufdtrL6uVHQb9c6niDzZxRL1a8DrWVmZ8aQ2LRM1ULZ0JEmbETrJ9L0xmk/Ei3ZicyxqzYtIGHmn03tB2kNZfeuAxssGmuD1Ul31jbIdkbjm0G6YgWfRcZUa3Jk4Zd0s1GqxLmgfVd4BBN+6a6u0IlDjlpDScj4Cel7Xqwu4neFebSSkz/b0guNA8ZAtr+bL3OMScSHimPIpmK7AoW55PnHW/3cZKIVGg7LdJhAeCDpqNvo0LBWILDKTYg4pPkxt6A0lRdzZ8mlDJBznx1Bsn3xRLMlU7/9YvHeQJIpurvq4goE3Rgu9KR5D38OK6BP7cEk6/tMPsXFEbwRgMqCfRrgmhS+apKn+krU+mBl5CEqLQt8pNp3C8vzvJeq6v8gYmgtb1tP9Z1mKy0eYqck+3xSWNrKIfEVn/1TzDFXxNOKOYcqRV+Yv2L9iBOlu5pVkgoyEp9qrhtGVU7Yig0UvAW/
 uk+5I4D7
 Uzv85b5x0ZzScmvWnAJ/gCq8FIc3WLJqqslsM/EmqqFgZ3nZ3Mtv9bzcMv/FQCq7D0nWR/gvlMlmQmOJcF9HbVkDO16ROfe/CtFRVb2AthRQJnC7HQNQQAGuGgKAatlN+DUzagLib5yfgp/QzwPRxMLJLyKkxCcTEXB1wRJUSCPiSkUWv0xiCGdRKC+GSvH6DA6nCEtnpo2mokeA8manM4jQldRLl1CK4xOelT4XjLc3vM3QCJKakqLIwBl2CiYQfa5uOdWZu1X4IFEvifBbdvaJpka7FdqMomUwe1As/B5/hGKl3DqU/CxQWmuK4JrGx9Svbhk///70c9qVmS8rnkevNiR/7Vy8gYrqWNrIYy9+Yq5KoGoyGLdjn6ZYb2eb/QXZT7IPp0QDqNq6wU/dbGw/YcBMFfl37sxds
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/18/26 22:58, Brendan Jackman wrote:
> On Mon, 18 May 2026 at 13:48, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Mon, 18 May 2026 20:20:50 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>>
>> > On Mon May 18, 2026 at 6:15 PM UTC, Andrew Morton wrote:
>> > > On Wed, 13 May 2026 12:35:12 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>> > >
>> > >> In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
>> > >> could potentially be merged as independent cleanups.
>> > >>
>> > >> These are all independent of one another, if you think some are useful
>> > >> cleanups and others are pointless churn, it should be fine to just pick
>> > >> whatever subset you prefer.
>> > >>
>> > >> No functional change intended.
>> > >
>> > > Thanks, Brendan.  I added this to mm.git's mm-new branch for testing,
>> > > along with a note that [4/4] may be getting an update arising from
>> > > Vlastimil's feedback.
>> >
>> > Cool thanks, (also I got the "added to mm-new branch notification" and
>> > realised why I missed it last time, broken mail filter).
>> >
>> > The 4/4 update is already up, in reply to the thread.
>>
>> Is that "mm/page_alloc: tidy up pindex helpers"?
>>
>> For some reason I didn't receive that email, directly or via any
>> mailing list.  I do have the similar "mm/page_alloc: remove ifdefs from
>> pindex helpers" from May 13.

Found it, seems to be threaded well with In-reply-to: too, maybe it's the
different subject?

https://lore.kernel.org/all/20260517230556.590677-1-jackmanb@google.com/

Should be fine to replace the current "mm/page_alloc: remove ifdefs from
pindex helpers" in mm.git with that.

> Ooh, that's unfortunate... I used git-send-email directl to send that,
> which is not how I work most of the time, so I suspect something went
> wrong with that particular setup. Will keep an eye on that.
> 
>> Oh well, please check tomorrow's mm.git and send along whatever is
>> needed?
> 
> Ack, thanks again.


