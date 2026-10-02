Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAC4CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255556B0088; Fri,  2 Oct 2026 15:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D936B008C; Fri,  2 Oct 2026 15:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BC46B0092; Fri,  2 Oct 2026 15:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA9FE6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:27:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D19C1C3B5B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:27:31 +0000 (UTC)
X-FDA: 85278670302.20.E19E9E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D88AEA0003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:27:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YS9o4Pq0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790969249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMLh6+kpgnlTMAS7jCwws3JUzVdAB4NK/Gtu/GGQ6go=;
	b=ELxOvwkB9WYMW29w7KbvTRdNM52pJIXHu6hoZbUJsa3dSyTR0ruZBFEp6dCWba28qJjot1
	oAz3fO4FjW7im1cy5PvRCfBIebMDFxxIaydRP3spTZZq/t8mk1jjdAV+5cI3IIUwI+iFHy
	+yiQ+EKpNWg/0nL4MoBswZ5x2oBfxhM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YS9o4Pq0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790969249;
	b=c+0jLPKCMRPjxmiQMKgwS4V8RITsWoF7fBU8eM80qNifHQBIQw0tPm/MolDeqYi3mFs6mn
	r5asj+l9JW9vWsZjYDESEOWdtw4gQtEci2/iJ0wCOt5r4yYdezkVWwudJF1PKO9UY+B2sp
	f7zIZ+AvK17++3wf87GK5+aS9IgrWmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E33D60AB0;
	Fri,  2 Oct 2026 19:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B331F000FF;
	Fri,  2 Oct 2026 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790969249;
	bh=TMLh6+kpgnlTMAS7jCwws3JUzVdAB4NK/Gtu/GGQ6go=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YS9o4Pq0335A+yCQuWG4Lsen37G2h6e9pTCh0mfvusPgL8a7VR36qoCuginbtio3S
	 HmQ+RNY3qpa/vWmy8XPS9kUoHeiTZk1bdQL7B8dMncshh2Zpl3PnBC3of1w0o94MLj
	 EMDI7pkpMgD7vUdXf8fJC1wKdXfJQ3XiAG80jFufIig//Nr5T45ZWU7us57UQtrEPu
	 gN+Z7BdZP7Jw0DQ8B6myqbY4djgb5wOoU6h5Q/Ktl4LnpralyNfQPXdtdHsXBLSR4X
	 YbomdDFA/lHVPoxqw6zZOBeWE2HGC1lzV1Kld0Dm554XWEl6fw+kmq8Wpx2FgbcUWZ
	 A80dN6DE1rs7g==
Date: Fri, 2 Oct 2026 20:27:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, pbonzini@redhat.com, 
	Borislav Petkov <bp@alien8.de>, Tal Zussman <tz2294@columbia.edu>, 
	Rik van Riel <riel@surriel.com>, Matt Fleming <matt@readmodwrite.com>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asAE3kLFDUx5v0Nw@gremlin>
References: <arZHp8hjYFXE8Rkt@gremlin>
 <arde/t0zQNEkWqi5@pcnci.linuxbox.cz>
 <areOeRwZOez0eHm7@gremlin>
 <arotyz5g6LozSjb1@pcnci.linuxbox.cz>
 <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
X-Rspam-User: 
X-Stat-Signature: jgeg4zhzzyxieeszeq531hfbtccmqbwo
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D88AEA0003
X-HE-Tag: 1790969249-999788
X-HE-Meta: U2FsdGVkX18z8hmJp3a11Ah7Q0d9LLTRzQD3HLChuCTbMfmwBK3XPw/Ntq7b/eNvDHcq7jxEfDG59hY41NMljiLNRq5FfmqOhWMK8J3r5gjZjAlNnEdwNrLXPY/oYW7+bxH836kRvCzvbW37DjFsYuGdxn9rmrsqq8e/jgGkWkZe1qPZJ/WW8hvx2Wm3oFvT5EFyDEKS8Q8jI++fYS6jAIGXxthJGXSKTny3OAmGqvxBaMh1ImRlOWFlT8jwsZm+vnkMncDSzYetZnWiCn/vRIq7CL/KyriL1bt6uW1Sw2SJoDTB137Kq4DZGoPvSkUvljgFDT12q3GGFup5LlSRKPyKd2YMVwKly2xKtcOH7Iezsy12lckTR1c35dF2C+NE1pCnv2A9o6ewjllD73ljIKcdOOsfp3RARSL2vRuEnKZGb5Tb2bwmSOVZXqw+5QWtVNdnwWbnLvAyjYtmuk8JdIB973xoqMg9ew0VwAy7TcLE/3tOxamZYs/EEXTcWHP5zEAkv+RZTol6hchnCwqvYTBQfjaWnk4CZJ+CaQlZlaf6MIuyLyefG98hl1ljP0PRK3Bz8P4Cb1McmKWAFybE49I+sb/wVE/rY02R1Lbn9hXzLReEXf0bhP3Xikgaywu0JdPnVVTm5XmBtr/SCfJfpPK3hRppyINAUsi0SZKB0iqqDu4jn4ULS2e7z19aIDq4JcCVAypaQV/CfZFcJ4IMHU+BUv0oB/fyXaePEFVR6U+tzG/DwzYYNu0zlCd1ZTVMjPPzr7n8+7sLQiTm4zTYv0ytHceuvL3u6XykdaOXHdolkzhsN+aLkC64DRoVuM9TepNg/DarNUu1fCJ21KytPrwWg5K2Gjq1iXuujwJLO7acS5/3y5btEKi4swjExptn0+t6VEYwsFvW/V1S5nf7tyqnkP95dkeFzRxrzB/ak6iWlcIA/azD8fcu8HN44oD0lRf5/P8OzNIWTd9Xdz3
 fnFPcqEs
 GYb93+yZUnmPBVTSS1BPYKHE/kUNh331x5/cT2SK/ZyDDSdmiHtCcAx1oVVXBxFeIqhvtdiNNssSC181YkfurlI5S3QQZRqrXyL4m8q+E5lK59dsBd5CTCEEmNyvcoF/bQytWRpYefCqrn0lBDYrSV+1wVFJbyaw+UC/7crFpLenPmza4K8mwO3QgKpSOrWfwc98byXRtvQr5l4iPFgHQFkpyNUnVjECYzK6bJggbBYbwshJQJ64P0BuXqioixJWO7T4LCD5VcEkuzFlTosfYmmIpXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 04:55:39PM +0200, Nikola Ciprich wrote:

> > The fact you've seen this on a Milan machine (EPYC 7343) is new information
> > so that could be useful for the report, so if you can reproduce _without
> > the fix_ first that'd be very useful to know!
>
> well, not so good news here.. I tried the reproducer on multiple
> lab machines and also on one drained production box on which we've
> experienced one crash and wasn't able to get a single hit so far.
> Here's the list of machines:
>
> hostname   	 CPU	   	RAM    kernel		microcode
> pocstdv1b	EPYC 9124	384G	6.18.31lb9.01	0x0a101158
> labtest		EPYC 9274F	64G	6.18.20lb9.01	0x0a101158
> lbxovav6d	EPYC 9124	1.5TB	6.18.31lb9.01	0x0a101158
> prfjazv1g	EPYC 7343	1TB	6.18.53lb9.02	0x0a0011de
> nrbphav4a	EPYC 7343	1TB	6.18.15lb9.01	0x0a0011de
>
> I'll leave it running for few hours, and report back. If I'm able to reproduce,
> I'll try recommended workarounds and report as well.

Thanks for trying that!

Yeah, it might have been tuned to the zen arch rather than milan so that could
be making it less effective unfortunately.

> (and lots of more addresses, truncated)
>
> crash> vtop 0xffff986002783a50
> VIRTUAL           PHYSICAL
> ffff986002783a50  582783a50
>
> PGD DIRECTORY: ffffffffa0836000
> PAGE DIRECTORY: 143a7801067
>    PUD: 143a7801c00 => 80000005800001e3
>   PAGE: 580000000  (1GB)
>
>       PTE         PHYSICAL   FLAGS
> 80000005800001e3  580000000  (PRESENT|RW|ACCESSED|DIRTY|PSE|GLOBAL|NX)
>
>       PAGE         PHYSICAL      MAPPING       INDEX CNT FLAGS
> fffff2715609e0c0  582783000 ffff996e5a8932d9 7f6a1589e  1 2ffff800020938 uptodate,dirty,lru,active,owner_2,swapbacked
>
> crash> search -p -m 0xfff0000000000fff 582783a50
> 3c600964f0: 8000000582783067
> 11e238a54f0: 582783e67
>
> should you need anything else, please let me know

Thanks! The LLM has informed me that it got that wrong but it was interesting
data (...!) which suggests guest memory page tables might have somehow ended up
there.

Could you try:

    crash> p d_hash_shift
    crash> eval (0x5560450b >> D) * 8 + 0xffffb18900a00000
                                          D = the d_hash_shift value
    crash> eval (B & 0xfffffffffffff000)
                                          B = the hex result above
    crash> vtop B
    crash> rd -64 P 512
                                          P = the hex result of the second eval
    crash> search -p -m 0xfff0000000000fff PHYS
                                          PHYS = the PHYSICAL column from vtop

  And for the pages the physical search found:

    crash> kmem 0x1ae234000
    crash> kmem 0x24f0e2000
    crash> kmem 0x103360000
    crash> rd -p 0x1ae234000 512

Thanks!

--
Cheers, Lorenzo

