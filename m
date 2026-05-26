Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FBA2CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1026B00D7; Tue, 26 May 2026 11:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8906B00D8; Tue, 26 May 2026 11:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9051F6B00D9; Tue, 26 May 2026 11:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F29B6B00D7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:25:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 257F5A030F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:25:43 +0000 (UTC)
X-FDA: 84809945766.11.20C4518
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 83F662000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:25:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSXlzwyV;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SrzDE8/cqy8nJcJUdAWFlhS2+gkYHsuU2i1VgUgaS8=;
	b=cFHLzf/SHso92dx3Z27p3atpIhbb6242LqO1S+ZhJWh1l9xO8PFMeQyX7m2H2RwxDSAa6a
	MX+N/xE9i5efYwQx4zXY99Y1btR86geeq0TJs4Ienm9Tn+8CoLvmkrPAil3Gj3adrp/yYF
	XR9ymoqPz3QteceTE02+JSqJEqIeA9A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OSXlzwyV;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809141; a=rsa-sha256;
	cv=none;
	b=jpWt2fQpv5uT9xSdr/dUe4qvJlaaIekkqTufVuIdsJlg62TpRr9TxONkshMaUtfL7oL0kw
	yg8btmpOwc1DbijROMgkpqQdX2TW0nPSg9oDbS/w6eSOPjEFgDTlQHhLtJ0VIw1CSmET6J
	9c/EOAsJ1qhKjsYfAz6W8FdDklmwbpo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 099DC60018;
	Tue, 26 May 2026 15:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608F81F000E9;
	Tue, 26 May 2026 15:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779809140;
	bh=+SrzDE8/cqy8nJcJUdAWFlhS2+gkYHsuU2i1VgUgaS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OSXlzwyVcKsXaBGOhuak3CF+tKURbsF4Nm1jQaXBh8JKquL1MBiG7GFYEq/FcdNyY
	 8npjNwcxyn3BX9EcZaWZ14zwr2sibLwWRmLumnohizDkrTFuGYefUcHiI5ZQhyWgi/
	 uX0p3yCxbHzhzSA9GPUFKhY2CIFVuDU6KPnAQ5scozqfyXWos6dwgCkI1jy3aVbLpe
	 NuTM0szFQOckniFftj5XFHwLjeExyH9gmjqOKEtEjavg6F0WfIqpZyf+GBWwRO42ns
	 0lIFnt434wblt0ChCBMdoskmW7hShLCCgAG5Tb7M+TUyiWaTnzEThNZNewYE3t+RYy
	 zW2y3cTTCnhcw==
Date: Tue, 26 May 2026 16:25:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Heechan Kang <gganji11@naver.com>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ahW7MaB7Tj0IcnEG@lucifer>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <ag3BNLU1b6p9u_6K@kernel.org>
 <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
 <z6t4kefzgrdiu4zurxt63f3qdyjbjsvgyjnpxjkufj546huf2s@hq6xghp5w4ns>
 <855a00a7-c1f4-4c6d-bd4a-f3ccb0eb1eab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855a00a7-c1f4-4c6d-bd4a-f3ccb0eb1eab@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83F662000C
X-Stat-Signature: etceju9iner3857u5b4iay4iobyc6qxz
X-HE-Tag: 1779809141-494734
X-HE-Meta: U2FsdGVkX1+cW6WOwST11OP577c9/RhPBBONKvA9xCFDZ5Ym5Z9Oef7IQZHrRzPa7n/ac2lwvhzIUCcK70K8mS7hYr49JUl3INgMzApGdMASwxCKoHaqzZ5utmhCBQjHhEPhZElzTw/a7xQ+qfRHy42fw6wLLIALsf2/L7fB6NBrKwpuDXfLW0QOdPB9Fc83uiCV9sS0x29JGx5C3eGpKCCqH/i3dQZEXiQkBXlFGxlZxIp6ZSHYlLTQfSW8q8ymSdj4R2g0Ij27tBkbYVQ5KyfZn18Rqs/wZI/jZ/XKXgFlw/sbMNw+tI88f8pJlUOR7FXUzfFiQV1zhG7SuGDvcSHBRCyjKHx1czdYI3sPTplZc+qpGv0kK3+/jGQ/eIDEVDYgXFz875dYW57eobC+yx2yO99DMVu3jqOCvZ7FYIWgr3jLS1UzOZkGMY/OM2qBDYQQL0rp0qZDEb/N07CgMtOrf58JIEFYL3sZbEuyuRkMuWbEmiOYrxfdVyMYvi1dL2vza0JjSjhBrmtKihSWRUtdZyKYElCmEoIHOWJFD7r//yfj3wRJyaiS/cQiOq2k4u9hwNICnAgYH1Odgxa8xWxF111DYJBEd0X0ANtui8JVfxUhQsdKf/uNzEBQP3JLfzZwAepSdNwSFGAiVsmS0m8Vtqc6EEIkqvKTzc+NWrJ+VbIdBEGw2IYpAnE5kKUOd+RnmMm9TQiVLf7WCYhXkSYxdKBTGYix5z7C8P00xj50ZugJhlL02qIWnR3bAUrXrVKTGbg6wrTkJJDR+HLbwrox6Wjbu7Blm3bcKNmJAIGYl6EFWvP6Noe7wA9GTiK+UJV/H7LcL9VWJgDh4V1r+L1qWAfvSSXfcG7mdP/VJUHkx43bl07SrcSAOf2jUTCWVGAz4h0OlUPnRcKToB1I1afJVsn3ERf9Cya8MxPu2Ann81Jmd9HsteIXRiLNCQvNE/RXWR2rg0aALc9G4rE
 qI7hdBuC
 UOLoGKTFUNJLSBZLDe/5wAcAlCE/n8sDqPdea6sLz2qxTCfPojfJXa625pP+pe5QOXy0asYKMCZmpFtgN7glwv5vXv4UECS4RDwS+o6GuhjvqXccbY7lnjopHt5JAhdk0biuMcyQPQeeIsp+KFcYalK7WntiaOgihv9PZmNzvuJczX7IAG7fwjxlGll64FrWXH4/Nfi6IeidT/XnDvqkyzI5RiKl8DfKsKdQ6yG6VVxcgFFzd9aNnE4b19Ikwb12WhRxlh5CY65tfGh+dLKVxcWd8br1m8bBLTH1QwoVNoUcu3XqiD1h/m7QZjw6Ri3yCVuo6wMbfyZrdbUKBeYpnV2u8mYqcKG8f3Aks68IzRO/02efvk1qsayBH+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 02:47:45PM +0200, David Hildenbrand (Arm) wrote:
> On 5/25/26 19:12, Liam R. Howlett wrote:
> > On 26/05/20 04:38PM, David Hildenbrand (Arm) wrote:
> >> On 5/20/26 16:12, Mike Rapoport wrote:
> >>>
> >>> Let me reiterate:
> >>>
> >>> A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
> >>> re-gets the VMA and checks if the per-MM counter stayed the same.
> >>>
> >>> If another thread makes any change to VMA while mfill_copy_folio_retry()
> >>> waits to re-get the VMA, the counter would be incremented by another
> >>> thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
> >>> and will bail out with -EAGAIN.
> >>>
> >>
> >> Yeah.
> >
> > This isn't bulletproof anyways.  The sequence count can wrap.  So, if
> > someone can replace the vma then cause the sequence counter wrap, then
> > you can be fooled into thinking it's okay (we had this problem years ago
> > with the vmacache using a 32 bit counter, iirc).
>
> If you can get it to wrap for such short durations, then how would sequence
> counters possibly work in any reasonable context?

Surely even for a 32-bit value, we can be pretty confident we're not going to
see a wrap that matters (the seqnum will != the prev seqnum unless 4 billion VMA
write locks were obtained)?

I may be missing something though!

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

