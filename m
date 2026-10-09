Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E02CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 10:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BA66B008C; Fri,  9 Oct 2026 06:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC416B0092; Fri,  9 Oct 2026 06:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAD86B0093; Fri,  9 Oct 2026 06:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 20C306B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:46:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FCBFC015F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:46:08 +0000 (UTC)
X-FDA: 85302758016.25.713D144
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 844554000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:46:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791542766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4G1ZQyZGjXPyKeZrRB3z99WagOOKrPbnI4HKfEsJM6E=;
	b=19LGTA5Y+TIQusSrgo74qk1GOr7gRtbNrwYvTMNfskq2qyFOEEHcWeCvnCSpuRlnDxSsPY
	eNw77Z+vnpAzu2KHysYOiqTn6+pcN+6Xm9MiA9s+WiLw823cvmhDeqw1wvfPwcwyYmgJcW
	nwxkMl8A7HWE2/R81mVt8gleTrOOFjM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791542766;
	b=7QkPpiTPPWf9UyVTHmpSl398jRvUTzBQd64cX1luZhLdFGSkJ6RB/+0Ola0na2VmAAcokC
	9mBYthj3qbRHWYbtOGMOVR/+ZMLLRKtxLh9izZYEnKSlffIsbNm3hao7lDSUExddIR6yPQ
	0V79iajFsDl4mgRTn6jW261vxvFekdE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 308D61F7CB;
	Fri,  9 Oct 2026 10:46:05 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 240871326D;
	Fri,  9 Oct 2026 10:46:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CvXVMuvFyGp4LgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 09 Oct 2026 10:46:04 +0000
Date: Fri, 9 Oct 2026 11:46:02 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org
Subject: Re: THP placement BoF at LPC 2026
Message-ID: <asjDTxAfUSGm0obS@pedro-suse.tail5790ac.ts.net>
References: <arZ5-VB0xkq-dJzG@pedro-suse.tail5790ac.ts.net>
 <CAAa6QmRt+4w9U_R8B5s+uOmS3DsFhc5JfucGcgz7D96pNDrwGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAa6QmRt+4w9U_R8B5s+uOmS3DsFhc5JfucGcgz7D96pNDrwGA@mail.gmail.com>
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Bar: /
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Rspamd-Action: no action
X-Stat-Signature: 3917c4dgkmn3ncbbce6hxino8y77jpu9
X-Rspam-User: 
X-Rspamd-Queue-Id: 844554000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791542766-411684
X-HE-Meta: U2FsdGVkX18q4desrUDjpXJOVSlyo8tPKaL030DLSzaz4D7K2kYQOTlcQAKzKv7cNbS1YZcVESgLacbpM+PY/pOeH0GsuyyiTOjiwNhdbbwtCErkAZWP4R4vkbyIqQcd7GlScnHaPGPcmPGbRtS3uLFiqMNR0IicifxFaTVdA/8KPtqUJBYl0vRTXzwsK96UtB5yn3MWpXBoqdgXkKlmqoxTEznO2z0sXByP6fD93xmKkEsdaXKkwNvQmd5yWzMSJyIhJ9o8Q7BCj2bmsrz9hgof4SdEdfY5pkt13uyndVyIaApxp9NJTynhe7hUbN53ystksEnyg5Klze0jiYhSWFmjvyXtAOBQzTGFZl4mAgnrc4F94O+oM+NCo8mFbbFYJhjgDkWxXWSgtwvl1My/P/YZGC+vARMx7STqOkPwDEJziHowODokKCKrVq+7pC2VUm8PPuhLEw0CCQgq5K2aNi5/MIhwSj51M76W46hpgGFVXK0gXD9oeg0gCX0X0o3cO8SNsyvmOrwiYVhz69m4OwZD4BEXD+DXImxRHcFH7WOb+/crVYnebW94PA4QFN1H9hu1AvdHRMGRWJvGixMZcwMlUaf4bLwj7mCH1VWYr5eua0c4TyXZu1iwQ18lDb2vjesoVi8k+NGGW7x5OnmRT/ZcQoMGmlgxEVW0YRzBsbRkdbCLkLo5qUUfM/zX7ZipYQV9w5MsNgwRrIqsrgX2t3Hl3HiG7nq3GsCfqZ8UZCz/YODpPhTm6Q9IX4YuGokXbI9O0tBLF14B8LMMq09LtJvQWhm4yBpQFMTs8ffk77zHHJbgk+vv/kjig42XvfixiUB7vck4TzkYGbfzuvqXVcYai1sMv+1ffr71SCYcszoWDL8nFI72a3zZsbWwnvibyx8h8nsWGh/4P4dj09u45LK94vGRklAlrkaIDrWsO1U/OS3cw/ia2DMEDVsFNLJU6MYrTwEyBBUTbEYepJh
 4iD/pzoU
 FwkIw+J48WpbVeluparcmdO8NNF5TspyH3x69g/R9zNwsVFUp3yEuZpCfbHafCjX+oRN+Tf8wpo9+2eUJeOg/JmWNYzhkSSdnnAF0A3hPkNPksavYtk07AlPpTvGv/3iPJH/hdp4oYvGrBG/ra63tdJMN+s8gJqpDflls6guL5OPvoFZsweGt8e5GOVA1nZXOLjqeAmxrSO+K3Pzq/NSSEM3OZ/cK835RojBD+f7DbjMcMSAvaS7svK5OKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 08:23:44AM -0700, Zach O'Keefe wrote:
> On Fri, Sep 25, 2026 at 6:57 AM Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > Hi folks,
> >
> > we will be holding a BoF about all things THP (but more focused on fixing
> > placement/not-automagic-THP issues) at Plumbers 2026.
> >
> > Session link: https://lpc.events/event/20/contributions/2452/
> >
> > The point of the session is to build upon the latest THP discussion at LSFMM,
> > and build upon the latest problems that have been raised over the last few
> > month, to get somewhere meaningful.
> >
> > I added a bunch of probably relevant people - it would be great to see you
> > there! and anyone else that may want to join of course :)
> 
> Thanks Pedro.
> 
> It seems there were some AV issues, so remote attendees couldn't see
> or hear the talk.
> 
> Perhaps someone who attended in-person would be so kind as to
> summarize the discussion here, so we can continue the conversation?

Hi Zach, Zi!

Just got home yesterday, here are my (editorial) notes:
1) mapping 2MB THPs in ptes initially
 - tough ask for lots of folks
 - problems:
  - might take too long to get a THP
  - problematic for short workloads
   - my counterpoint: i've done some testing with kernel builds (lots of short-running processes)
and THP is mostly noise in measurements.
  - non-obvious how to store the 2MB folio
    - maybe hang it off the ptdesc?
    - can also just PTE-map the whole thing and do deferred collapse on that
     - but that's basically khugepaged's whole shtick
 - could be possible to carefully map THPs until you have some confidence
   the task is using them effectively (some sort of THP slow start)
2) there's only one accessed bit, one dirty bit in the folio
 - this leads to hard reclaim, and write amplification for anon memory
 - could perhaps use more memory on large folios for this stuff
   - 64-bit field could be enough?
3) can we use hardware metrics for it?
 - maybe, but sometimes they have overhead.
 - unfortunate that hardware vendors do not supply us with more A bits
  - could the 128-bit arm64 ptes work for this?
 - AMD IBS could work but does it have a performance penalty?
  - Intel PEBS definitely does.
4) splitting off a VMA for MADV_HUGEPAGE VM_HUGEPAGE is silly
 - could perhaps have a parallel maple tree with these hints
 - my thoughts: wondering if it can be made extensible for other
hints/metadata. or if the performance penalty of needing an extra maple
tree lookup is measurable.
5) THP shrinker is a bit silly
 - in no way does "scanning for zeroes" actually indicate if the data is cold
   or not, if you ever wrote to that page
 - Per Usama & Kiryl, Meta used to have quite a lot of issues with this until
they fixed the userspace malloc
   - i think that's a tough ask with a lot of setup
 - some mallocs actually write malloc headers all over the memory chunks, so
   the zero page shrinker fails then and there
  - and on free() you'd need to zero memory, or at least issue a madvise()
    to the kernel
6) MADV_HUGEPAGE has no size hint
 - what do users expect? unclear, they ask for "huge"
 - problem exists for ARM64 16k and 64k page sizes
 - I floated around the idea of defaulting to 2/4MB-ish sizes instead of
giving out PMD-sized chunks
  - ARM64 can do 2MB huge pages with mTHP on 16k and 64k page
    size configurations
  - or have userspace give hints through madvise?
   - I don't like it, neither did anyone else
 - overall I didn't understand if there was a positive reaction to this or not
7) BPF was floated around as some sort of funny-piñata
 - it could certainly make things more flexible, but definitely less transparent

I hope I didn't forget anything important. I'm definitely not nearly as good as
Jon at writing ;)

I'm not entirely sure on the way forward for many of these questions. I am
vaguely planning on at least attempting the PTE-mapped solution, if nothing so
I can rule it out as a possible way forward.

-- 
Pedro

