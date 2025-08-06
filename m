Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BFBC87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4B68E0007; Wed,  6 Aug 2025 08:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2943A8E0002; Wed,  6 Aug 2025 08:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183788E0007; Wed,  6 Aug 2025 08:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 069558E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:43:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B25B31361EC
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:43:49 +0000 (UTC)
X-FDA: 83746299378.09.8AB880F
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6DD4280004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:43:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=QMucSp9y;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZophTKdo4O3A36vGcC5G0lV5mUY9trAmIEPn+lZrbVg=;
	b=OifW4ryT/Kd4ZtUq0VViezl4EBqhwq8wRDGD1rKfx6cHXqHIIJ54NF8Gq58i+fDwcmy5n/
	chcMyogcnTIgnMmDPgtM3urOrT5I6m25eDrfNeI07nZBuckrI8IH6GeGOh39dcEgadW6tE
	kNl1DxlHISCFKRxp8WOVxSTja9Ufw1c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484228; a=rsa-sha256;
	cv=none;
	b=U84sUzG/Bvg13o8SW0y8Av/vSuUuOGOkV8LkXNc5SkqGpjjNYXR3gI2qrEzdXUh1bcuX7V
	9EFEtC7a3bJe4VVweUIUFscOxDThgMhbEBxTYDCxP3O3u5Txf4ddl2keEsYacjwBXG2hLs
	1W5HwjEuJwbFw6GKiwsywk+EJM4rG60=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=QMucSp9y;
	spf=pass (imf30.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bxqjC35nkz9tGN;
	Wed,  6 Aug 2025 14:43:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754484223;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZophTKdo4O3A36vGcC5G0lV5mUY9trAmIEPn+lZrbVg=;
	b=QMucSp9yjzTRGS3JNNwUENMKvP5/sRhXP+HKsADS77xEB0DQ47TT+6Nm3BywgS+3ZTWgE8
	FDVYRrg6d651lQ3fvj/bKEUJaL+NNjcReQYrtHwEKkrCZMgTLevtAxm92vk66VagiGM2Bv
	VchgcKSTtEYhg17rYrQuY5vEjVZoc7cqxesoLvL2LqtvH1bdkXk3BUqp+NBFJE0OPAhGjo
	+UP/o6D799+eZyGQQQkRu8KFKW8ZjZ+4Tx7tj2cJC1n/bjv+OJdRL1eQqLVGrgSmUE8L1N
	0GaHRhouyJPzw12uHKykUG9ZpLjcTfNs+FEk/sIuuTKW3qClFdaVOLgvhZt+1A==
Date: Wed, 6 Aug 2025 14:43:32 +0200
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
Message-ID: <lyfgmdjehtfjb2gmj5ciao6l5lmkvlfe54wtlnlhjjf7ge65sa@2dyo3tb6ka4i>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
 <20250804121356.572917-4-kernel@pankajraghav.com>
 <4463bc75-486d-4034-a19e-d531bec667e8@lucifer.local>
 <70049abc-bf79-4d04-a0a8-dd3787195986@redhat.com>
 <6ff6fc46-49f1-49b0-b7e4-4cb37ec10a57@lucifer.local>
 <bc6cdb11-41fc-486b-9c39-17254f00d751@redhat.com>
 <bmngjssdvffqvnfcoledenlxefdqesvfv7l6os5lfpurmczfw5@mn7jouglo72s>
 <e67479f5-e8ed-43a7-8793-c6bff04ff1f4@redhat.com>
 <iputzuntgitahlu3qu2sg5zbzido43ncykcefqawjpkbnvodtn@22gzzl5t77ct>
 <9a657c84-99fe-41ba-88ca-097acab4b96b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a657c84-99fe-41ba-88ca-097acab4b96b@redhat.com>
X-Rspamd-Queue-Id: 6DD4280004
X-Stat-Signature: cxj58krbjcax7iq1ph5ptfbfg3qncjid
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754484227-300448
X-HE-Meta: U2FsdGVkX1+3LOLrr8vqQJ4J2gycjneQPU5msoolQtKIPEmjlp7eI5Bme6g4FVjK3/V0/5QWfxOnKkNoVsAzVghNdKt1NDFnVaPpqC0eDXWo9Ikr8AGlZA9pyj6XvBGJ8tTk/QdIPGCs9PugZK41Kto7uq5o9AZRQ8u4ZlK6pAn+Dptc9CNQ817/5uQE+ohWElIa8zXlXW0tXasrlcx9Qza1lKGwTkmVCajOaXzzwQIfRx7OJghnDGfAAaDGQByh6nEoIp15fum2OHk3KtDGHWizjQQrqsNCUj82igHbxfUfYPu0jxLza3kPspGu9hhMQcwBoQdWA0LmiDwW5gOJZVeDIAnQS9Z1Uh90d9pjYAL1vsHztH6V5Ruim2961NlhwQZYV+20z2134vJ6X3p9cp9Bu8muNoJdaYzDSq3Ogqa0cby2CGBzaaCVhV7F++IposbwacwjctlQP4rHjODs8I6J+1JZKstM4xWh3o+X+lzbPTRVUBboQZ1LRWtLm01fg6eGSMahKS3anQun+zQD98aI8Sugl6ySl4YfZSEOl0j79hDiMcFIUiVTa6QxgCIj4YlD4LyZRsvjhWLeKgKOxqze42y3odfo4KcpC2v59gZ6DlBnqSee0Y7PZICCHvXbc3XnP6sTSbtHkt7CaQrkOOywF6GnOd5aU1LegB2Jx+3ZekUNmPXfDn0zVQ3IRQlBmJY1dHRCC2XedueciZzQ5v2MDRNIFZoE13acXhINZcETccAPjDJShoHTNAWabyKVWqXnFfA9RlNadShrUlOjLb5v0UfsMQ8Q/luZC63Mj+A16WFRDMI+L/zbqbrsUf8d+h7+FyIPGxzvJEt3XFWkkevvt24C6QG0dFCrqyegDUYU0FBUwomC8MayhNJfVQVo5kvSiWWKztKGcQU539AGVrcaeiqK+vMidfmK6BNVLpTtVzmnUHO6kcnsyE9xDCQ5PouG8Hac3mimGOex1Ud
 nBec3k8D
 7X2kvg8hPhl1Y//Pna/XIaZ6Kts5wuDi5hF1og4ckPij+UjS3YYOaZXrqoVDlQbe4gTO0NuYz1YNZoRyUymgomhisP/2VMNls2tUZ994sGUHjTNP5yI5s7kwfUag1GUXwcW7Ua6v4ePbHeKnUaYJWObsydbdqVfi60aNwFZl6FykJBFISo4jUWGcrg59tdB4EvSRU+dbGfFNqYE2uXRpHHx7h/XE8VVrVjwCEFweY/xbYH8n7TDjE+rCWI2HjiS/X62EOqW4a7dDhA2fRyVKX5HkdIoNJ6jN2yGC1edddobOyJY7zMJidwgDqm2g8u3JVCJun230+Z09ZIlESeILD0zTJ/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 02:36:51PM +0200, David Hildenbrand wrote:
> On 06.08.25 14:28, Pankaj Raghav (Samsung) wrote:
> > On Wed, Aug 06, 2025 at 02:24:28PM +0200, David Hildenbrand wrote:
> > > On 06.08.25 14:18, Pankaj Raghav (Samsung) wrote:
> > > > > We could go one step further and special case in mm_get_huge_zero_folio() +
> > > > > mm_put_huge_zero_folio() on CONFIG_STATIC_HUGE_ZERO_FOLIO.
> > > > > 
> > > > 
> > > > Hmm, but we could have also failed to allocate even though the option
> > > > was enabled.
> > > 
> > > Then we return huge_zero_folio, which is NULL?
> > > 
> > > Or what are you concerned about?
> > 
> > But don't we want to keep the "dynamic" allocation part be present even
> > though we failed to allocate it statically in the shrinker_init?
> > 
> > Mainly so that the existing users of mm_get_huge_zero_folio() are not affected by
> > these changes.
> 
> I would just keep it simple and say that if we fail the early allocation
> (which will be extremely unlikely that early during boot!), just don't ever
> try to reallocate, even not when we could through mm_get_huge_zero_folio().
> 
> That sounds as simple as it gets. Again, failing to allocate that early and
> then succeeding to allocate later is a fairly unlikely scenario.

Ok. I will also document this as a comment just so that people are aware of
this behaviour.

Thanks a lot David for the comments and feedback!

-- 
Pankaj Raghav

