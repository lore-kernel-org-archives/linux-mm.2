Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D563CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 22:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 128756B0095; Tue, 19 Aug 2025 18:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9996B0096; Tue, 19 Aug 2025 18:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015CD6B0098; Tue, 19 Aug 2025 18:43:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5A456B0095
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:43:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B610116DE9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:43:01 +0000 (UTC)
X-FDA: 83794983762.01.4F9E645
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf24.hostedemail.com (Postfix) with ESMTP id B699F180003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:42:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755643379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SLtw4j7faHwHkE8VurEjGE3psV1wZ+7kipZfQicP7SM=;
	b=nRNAYeizeoRbZGzmWRpGZ/Cy/EdPBw3sBgW6Kpi4zyzq4DrjRmObcQMaFPXcSQwlzH4RFD
	GwPXESTgh6IbtQ82x4mtkgo90BpjTb3HDXRHQMiEEHoot3YswsBsMnoJWaUNbI9yjuL1Rg
	KfHywK6yqXf6J0U5Kkpl2OlMkJqojIU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755643379; a=rsa-sha256;
	cv=none;
	b=5hSE0BYNTrM5WXv6DL/1Brdkxk3dGPfxzdqg5KQebwfn3yyn8l8kxs3LlTNBA+f8EhBtQQ
	V9Z3AG/OyqV+t6elLnOY+IS3ZrGdcRXUXiF5K5JgRwxP6ZT09P3CjmsH9JOLWgL20k95Z/
	860cKPl7/8Pk4fQ16Ig2Xq2VB3DbqC0=
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 125551A0258;
	Tue, 19 Aug 2025 22:42:58 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 0F88017;
	Tue, 19 Aug 2025 22:42:54 +0000 (UTC)
Date: Tue, 19 Aug 2025 18:42:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux
 trace kernel <linux-trace-kernel@vger.kernel.org>, linux-mm@kvack.org,
 x86@kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Thomas
 Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
 Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] mm, x86/mm: Move creating the tlb_flush event back to
 x86 code
Message-ID: <20250819184255.74307764@gandalf.local.home>
In-Reply-To: <20250616161735.26785bf45d765345b89ad0c8@linux-foundation.org>
References: <20250612100313.3b9a8b80@batman.local.home>
	<65bb272d-b2d4-4d2a-9c7f-d3d5d2eba23d@lucifer.local>
	<20250616150942.789c791a@batman.local.home>
	<32c85c56-063a-40ea-b6ea-e49304447ad6@redhat.com>
	<20250616161735.26785bf45d765345b89ad0c8@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18mWXyQu4Tn6IbBk4CIsgvZXl26siHqgvk=
X-HE-Meta: U2FsdGVkX1+XndIv08WfvOQd4OZSE8G4SatZ6QNgHrKoQ9zOhRvDzdKX12BhM8tq/bTPj5QEFZZ1F9RABD0EBaHPj1Nnic3VyWpt4i141OrIyjHebhrDW5+Psoct2mFgNkGvHAwKuOVd9foy60hKP5P51BQo01itiwQ89ELlUE9LTSVPRUikxLHdNvNqR9PStiWct9sWgOcDqre5nwRUUkYoNR/i908naDSVk+TJ4jtFQEBBce1hoaBqAXm2rufGsuwGDKtFyryKpxKHPjnfuk2g0SRDNXDaNgKnz4F+Rm6N/8v3pNNJHYqJW7ZblvXbAlj/n+1lM8h4fCYI3g0y/RP5V3LJCdqTI2roayC7ZP6oUIBYkGOYNVV9V7gUDNE5GTPLRAeGuI69kLFlv0QCKrNsfUVYH7P4chWHYwb2cgkOn8U9ln0Sl8ji+Zc5f9gEa7PXovzU8PjGaRuLTugxVL4moSZORbxUNdXTJd8066w=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B699F180003
X-Stat-Signature: i7oyefsqr63gfx4sqsubj64pjz3cojhk
X-Rspam-User: 
X-HE-Tag-Orig: 1755643374-223974
X-HE-Tag: 1755643379-872934
X-HE-Meta: U2FsdGVkX18jFjyttHZWAowlsMffBQasNqxxUjwhT0Kd14hTbCOAwcw0hr55K7y0qGFlm6zT/bVv78Sa/Ih4NwXiWnu44wvsDW7RJwLRdNZE0GG6kvFkLipz7J/eaQDtRgwpRSXbYa4X5TzlWg85Nwq4AKh/uypww/x0L4ITp4hYL+LqMdWSM31+Tn6RVxwxEEjUAgdmFC2RWH6TPfFB1yVCG0oBQ+BS9mtbGWEqk67v7PAbkw/UTwScQFAxKubrAytgbEb2MVs/ACmsIFSEk0engFJ4vKHXFhGHwKe8Jz+bnM/OzF17uev/NINYSsYfbqKtgdTycS50Ze97kOfhL33tBBE2l5MBJ+BSia308eOy72RmWByMtkVoL7FTkymGhwYEdKanvlCDzCmsBvdWHBZhvqhNxJvg06NYjFhNOAO/2yLgwyWGzxK8c5IROvg816S1xZZztHqbBotohGglF/5o8p5wqzDYldU6vMxMDqnTrAVQL/4Q2VFdxMPmh0PPWl9KhmRme23FggQNCQSNTIoj98Z51rZCpk/NGvTKSz4Ash6IhHr3lWLQSRUilB9fb4EXU1IllLWUi+nLC/cMpfjFJ34GtpSYfdF7UP7dNKn3IB1XxBiH5D4++8fRmy9LySOqwn9KlPSqSwkRPFtYkkARPkGGJrK6+l/UUy44ZBkryq1HpJk6y1vKw14wjs7XueSHY99jh7P6rna+IR4NxAszw0M986oa7mvoP42bRq05jkl06PU753x0er9pWKEUlx2790eNwC0IL9CrzArafDQ4jbkjRIefdB+xLpytdTM5Ql5/OeOKEkBxSNhnnfhTBcsQWFW/1wdi93KfEiJN8qQ38HESS2lk2tlxZZMH+w//6r8j3vURbrjGC0cabmjAeG06OTlu82/jDRwkwvcPBTB8YTwHVjGoZpvJOx+o03jSFJmvpYs/RwDtFVUX2F2BFQf+dA6jFmUhgN54rL0
 en9pMpCh
 eRCSwzQQhhLrk36s5fO5/2ZvhDX5UvLELK87Y4GmsYpierlbnG+6ClqGEBUGcenPfQnMnLHDH+Ki9Ea2I6JvRGRKuGISU4TjXiziAlmemexbS7mTeIj0jnJpNf3xuNji2coP3FYcgZDfM3abohpqjh4Kccw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Jun 2025 16:17:35 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 16 Jun 2025 21:19:18 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
> > >>> Fixes: 4cc79b3303f22 ("mm/migration: add trace events for base page and HugeTLB migrations")
> > >>> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> > >>
> > >> LGTM so:
> > >>
> > >> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>  
> > > 
> > > Thanks.
> > > 
> > > Should I take this or should this go through the mm tree?  
> > 
> > I suspect this can go through your tree. (@Andrew)
> >   
> 
> Sure.

Did this fall through the cracks?

-- Steve

