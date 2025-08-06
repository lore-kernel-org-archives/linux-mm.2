Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CF8CC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4E816B008C; Wed,  6 Aug 2025 08:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25856B0092; Wed,  6 Aug 2025 08:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62446B009A; Wed,  6 Aug 2025 08:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 970936B008C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:29:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18E71C0448
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:29:08 +0000 (UTC)
X-FDA: 83746262376.06.0829519
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39B4140007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:29:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=LacdcLE2;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf04.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754483346; a=rsa-sha256;
	cv=none;
	b=cW5j717ts+wvMj0myyO93Y0NSeHJWJyg6YIX6QBIfCLX405DSRaNzr+K9uwOVwQ94h/V6G
	/a/hDblS+x+Q+V/tegZ9cpKqtGkXIuTA3ghWajDOiVrguFgTRJH1P/sFUmV/L59EoePskU
	ukXUJSjBqMUdjuV0bz1ZBF3y3OmDD54=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=LacdcLE2;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf04.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754483346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F8BQtW5gEKdjUpXxWIiVv1CLkHbu0OfI1Sll7FP47U=;
	b=XFJ8yQ8Td29OhZq7gI/jruRoLySNBmrsmYkD8snNr8l8zYzN+MFjPklbi05bCDWe+bNXmW
	xK1TPTxNqRgDPI5XGbXe3P1lmVjDhRQuZ64Cmhi4QPl5QyKwNebuuKNBhy2d9uw0Jk033N
	ycQ9yUEY9B9MqUvvgKMTx2XZ8EU/v0k=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bxqNG01wVz9tH7;
	Wed,  6 Aug 2025 14:29:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754483342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0F8BQtW5gEKdjUpXxWIiVv1CLkHbu0OfI1Sll7FP47U=;
	b=LacdcLE2Sl3BNVAhnaliq5tJcRCkq0DgNFSegd4CR6RwWZF1DYx4jEuqiabDykGdWJRyd/
	vmVJKr3FCG+CVve8Gdvn9ad9KjXQ9uZ5LS7R+QuoX5RLeqrn2wfKQlnTOMCJfADBN4Jhj+
	XXmesFjqMgXAnX21u0b5He5OPpMlHEztVJ6onekJ77Z053eBpEl39UYvYROP3HZjLFALhb
	fTN3qKT/vspypImciwtcYet1nZhANU62CxjGCQVrBL4Ei2U0Y1vqvhT5BOg3PX6IjOgLCi
	QSg8vidy4Vil82zaaKxISZPtLsLxJ66pOB33R0Jt2F+MxxBZQtBVJYu5aJwAqg==
Date: Wed, 6 Aug 2025 14:28:52 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	Ritesh Harjani <ritesh.list@gmail.com>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH 3/5] mm: add static huge zero folio
Message-ID: <iputzuntgitahlu3qu2sg5zbzido43ncykcefqawjpkbnvodtn@22gzzl5t77ct>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
 <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
X-Rspamd-Queue-Id: 39B4140007
X-Stat-Signature: z8jty9ngtftr1xwqct7gpcr5ysu5snxp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754483345-880435
X-HE-Meta: U2FsdGVkX195JQC4EuyQVPkFvWyEJ9ed2ZmItDRLilzZZNVkYldNEgf5kZnwuWBu4jEGereQBRXaH3sLyaA70yhrFxtxk7legpSScyBNR6iINFetU/5U1MK8vRLS0AEU5f4VpaK3z1LW2gKIWnSM4HglVR1MRclnGxf9QIogCwyVRjE/xDviQd3+tnxGzdMhZlqIfeLXKcXy/1mTr1FIV6nBEv3fzQNPtQNeSiD5/hQLKVeAX7iYNSWF0Bds3Kg/U+VkfOs8lXmGnTJIPoNUrVofJMQCm0k6EWxjZdwcn44Y5okUpVNA/aRMNVByxz2vf5rRqCo9Al2niG6VWASNoGfC9mDA3yZwDTHIO9JtqS5RoXFxQ3Zv3C830TVJeEXJU1e3DYNUAFKqPUNB7mNBmuqx3rJyxHAdkz0n9wfVvwk6Maf5Z081RAS4cXF2g52pjvrPKsnz03sP8q6HR52yxI6McNZlu8dj+7rPgdj/eJVW4U9n0DRqbBH8LFpEmGzR9vQbSxG6jW7GcGtKSGi3CxyPzh58KIUWcKtRfGxqSXsL+BvIsHmYp12+JdGtsnsU6ScclMhQjfrGkb7vdTbiyUCCBhdanfJ6ZVn/TEQKQvFuDQmLFma3UEoXtydPJEVZI1hmYiJxuePu4zn7yLo0nqCTJPF0pGeKz9SuFCpOX/nYjdSy0xD3N7IrggUG1/tikTuSp3/npZ/0ayW0rwX6lhX8YGquyhraZegVQrfkb0zpHF/aN7IDVB1JV9FlAnYD3vrP7J936wuB7kxUQ9uA1iJhh0QQVa4OKZmjSRC9IVUSTk2XUk1CICAIGgf6YcZNjjbe10nq8jhpXEnhEfye5n5wpaFLgjSgTDDDlqdk+FMCHT6rosD0gBvOi3TsAMh9WvA7mKh8pYedb6S0uZWFzmspCgnuXwt4+3nuui0iTds7YoAHS5/SVL0kCW15dcljgI4YPyN3BZ2eVrj+e+q
 7l4/Yfq/
 at9B9mTpaU1YxhiEjH40EJt6XQ5YvSJINDzBN0kOOiieacivEdQ2liaR4jts6Npxa3eXd5UYqYIW/hnKsADcrrLkfpVdxf4DUhm8ZDwf7xDs7VVbhvlDNGKV3SWXH5Gs+SEnA4uagZHqaHYNAPfU2C49IYlWgdZuxzXaapqOnKYG7KK0vg6zaHMw5SxTJo1p1cyLTipa1Rgt8riTLJ6m1e74gPnWlnEp/X8q6HnbjgtCFMjGt3usmF+T+sKr1+FAyuXTzMxOS/+/ilFDRZ29FFJcZ0xlbuRvGIhv64ZozIpxM/cdGEIA6UH6K5gqKvmT3kefAfLjaQwHvNRfMT4n5TUW46A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 02:24:28PM +0200, David Hildenbrand wrote:
> On 06.08.25 14:18, Pankaj Raghav (Samsung) wrote:
> > > We could go one step further and special case in mm_get_huge_zero_folio() +
> > > mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
> > > 
> > 
> > Hmm, but we could have also failed to allocate even though the option
> > was enabled.
> 
> Then we return huge_zero_folio, which is NULL?
> 
> Or what are you concerned about?

But don't we want to keep the "dynamic" allocation part be present even
though we failed to allocate it statically in the shrinker_init?

Mainly so that the existing users of mm_get_huge_zero_folio() are not affected by
these changes.

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

