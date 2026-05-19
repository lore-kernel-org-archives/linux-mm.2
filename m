Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75A7CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C40F6B008A; Tue, 19 May 2026 11:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D6D6B008C; Tue, 19 May 2026 11:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115E96B0096; Tue, 19 May 2026 11:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAD446B008A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:28:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 975161A050B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:28:51 +0000 (UTC)
X-FDA: 84784552062.08.628AE1B
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id 448BB160007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:28:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779204529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41IoTmzqXr53RmB6owczF2apNHb2eoFFvybTnR8Tgts=;
	b=gUiqiieDxsBRNZjehmJLauQx2o1WzPfPaulU4HdpOcD221GZ9S5F/foqv95GiWfVSvl2hp
	VQPjuc3xKGFo9nTg5gvX4Xao7jUK/j8XzqA5gEzhNrh2NgJgLk6Qps8s2b/nvZ0OERfiVU
	bV9q02JaFZzCj16CEm4KZKSUoV3xCQs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779204529; a=rsa-sha256;
	cv=pass;
	b=Y/MdwSvDo0Vcw2EZsaUSqHD+9ms1+Wt3/3sFV2YYZmEZGqGG/Q2+bLtOEdf6ri1Rl5/jpd
	lEbI366MHhL0Zy9AkbhWiD+vd+VML75BiHABr7acySv+rU/EdzrW6G7+2GFrS/D+Wa60q9
	+aXEvl6GSsnwxejJt1BW1duAhKvLq4s=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
Received: from relay.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC7F912059B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:28:48 +0000 (UTC)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EE7E16109B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:28:48 +0000 (UTC)
X-FDA: 84784551936.02.D7D79C0
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5660C1C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:28:46 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779204526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41IoTmzqXr53RmB6owczF2apNHb2eoFFvybTnR8Tgts=;
	b=nqeOYIBX75SxSIL643ky8NMIYcXFZZcqlcoaayiayeVWveNDa6WAWa25svkqZOSS11TYkI
	J8512Ryt5XMZmeXxar2xNwGq1Fz+JZjOXScB5E4tnNJX88kFAHl+A3Xt9tcqqUI0xyafBG
	opnnZUYy6UjmDo2qdRVe9QupWh9tom0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Pco5/uMu";
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779204526; a=rsa-sha256;
	cv=none;
	b=fDfMcsnc0/AIz+gZnf/ef6RLvSyhAIZX0ezE/40rn2ddi6iY/mu/vyhLXatqbNLgmLgZn/
	M7D1LFLVLBHORz2n3CstzIYVVrJ1NLUrZpxnwRHd5y/qtdyjFfSL8o9mvOZoCpXIpZLqfF
	YgJGnJTN1xz6n1+FJEFNaFNIATXBE94=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5753a289955so1201067e0c.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779204525; x=1779809325; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=41IoTmzqXr53RmB6owczF2apNHb2eoFFvybTnR8Tgts=;
        b=Pco5/uMuN7wOzXEb+2q3g22SKcRG9v/1lBlvxS4vDrp0j89dRRVPrwSoGOkbvaGYWu
         ddXkt87tlmVQNHKulkwQsfxUFo4RTkJ0b88a166ND2g8ViaOanK71Yv4qw/aS0jRA+pN
         7uxuqxDxMgHXKvNd0hxC0FsqsIFg9a8BGAZ87p0Wm2StPuaMGhhQoLTA+O6B6U9WSbkc
         CgKjKYl10yqGg9cfAUDHZrDxz/NixirU26URy7lwaOTrR3XHzOf8g6knBoz+mz/WYnvB
         GIKRnbQwVNbiMrBjA9dhNi2ljTei9fd5oJqCo8fNre8LSDiCdtpQ119Ib30LjLOJL0H2
         +TeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779204525; x=1779809325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=41IoTmzqXr53RmB6owczF2apNHb2eoFFvybTnR8Tgts=;
        b=UZdgCzH6nNXitn6w9a92lOgPqUJsSxCRHmHaQCW4FEmvWYZnU0QpwlaJEd6WA8Q6qd
         gwp2KC1wYlFbFzfoQa33sfkRXedZ64xEfqPjFze71WYpeR8zLrcr2dHKMJH2FWZZxqtF
         zbIRcZZ6tzS4KEjN2YIxQl5qkF87+2j2w619SGPyEXdRyQGNnRiPbmnjAuSjU+1G4zSL
         PjWoMImM3H66zn44/ddF/5GsWr7XTdsfaVoHrvyNVTbCI/tIPIuhFhUUQvi5v7HmfKHl
         M2UuDApipp6iP6nXLV6a/ReN6vqs+hpgeN6JkutR6DQkO/pSiiBohdMKcRLmGREvCpKa
         n8bg==
X-Forwarded-Encrypted: i=1; AFNElJ8ZMLi3S2uno7co+S3tB4Hk+gQoy8O+SEyZPXD/zLPNjCsXiYQvhxyKh+RVBzbHWVOwiMh2pcIIbA==@kvack.org
X-Gm-Message-State: AOJu0YzgBkYzlIT/xIX/fPbztjs5Kh6MeLJGSwnkD1dqtOkRvpX5SrxN
	tKJX1fSj5lL/B8o6cUMgXbgYzkzBjNzRhV29PsMEEdK2NMyaeiZDf7TgEXzSWbt+GNY=
X-Gm-Gg: Acq92OEPs69AiSoK8p4a7GTmUsLInSoNG7/76D+aJ1dZzdMQuHuPxv4rvv3rVRWoTxs
	Ji7pYV6So7ORHX6LLcGq4rzyJ0hxcFEItpFuVQz2pkECvCF4Z/BY/NLMHFTAISf6dmcpSlX5BC2
	63JEF3hzGQC3EhBOqVEO/LGyk9TYIfzlgdeq5qYMPQyPhf+TXlIcSsNoFx5DuBIrV7H1LaBwQDA
	GLidnEPDZzEw2+ik9CLOW40Shb/wbzR0C05dE8ioVQbsQ2WjkpkvrM3BkpuBBPh7ZC6IQBZBqu5
	waSWtcx3YhA6hXWS962YlayIWVamnKc4tkEZBNq+2fWn61R11W+B4SQuqJ810Vtt5e8NEY5uVGh
	LdNDp4+IPkaRBBYSNkIdLTk/OZT56VypeOgPTKbSma8El+eTho6FHzbHadolZ8AaXy131qQh20l
	39u7eQt2UdQe4OYiZzjKkYYQ==
X-Received: by 2002:a05:6122:3412:b0:575:33d4:d100 with SMTP id 71dfb90a1353d-5760c08e3b6mr11890452e0c.13.1779204525141;
        Tue, 19 May 2026 08:28:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51645688c13sm166193861cf.1.2026.05.19.08.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 08:28:42 -0700 (PDT)
Date: Tue, 19 May 2026 11:28:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <agyBp_j6CXuhfkfp@cmpxchg.org>
References: <20260518163736.173910-1-d@ilvokhin.com>
 <20260518132422.8cfec729a4d7e974c87ace72@linux-foundation.org>
 <agxqCE2juj14EhyZ@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agxqCE2juj14EhyZ@shell.ilvokhin.com>
X-HE-Meta: U2FsdGVkX1+xJ6e7O96YQBsOrsdc2c9PrvaUARHhlHmmhjzWSE1kPQSOR/UXQqsUIWsklKteiL8hgcQc3YoKQyLhF6YoU1qziQkNcZDNBwSaZIDmAwj2+yoYAHUWFflv+tnjGi0PHPpVsFHmMXk94uXk0fSuHcOyfCwH0chP+44a6zjRtdiwcxmIJfub730CurP87mJqZ0eBgo5uixW83HQDvJMwemUCjYtPffxyZTELVfQ+T+QY3eFOJCp4GbXK8Ij/dZs1iI5xWnBLHadln6n0mmtQbUNTpXNMj9DAxMp+3I3V/RVR8QMyp+mW6D91ERvHthH1b5P50dn38kxfLNBLTyhzQeE2M00RDhFCH8nxoUs7AGW7dOZglZFoVgcUIHbEZc+lb4szIbamQHSCun0fi/I+4FH8EoF4HkD1TOox8ueccDI/Ytc+jG//pl2EyeH+ND8R4vPdHnuPrXVx45+5xulK0ioQSqjdt3cZN6AoaDoHNDF6HsPUU5rU205XubSvDc/tefqXbmFkOOyC1ltPzu6xZRESMtS4T7V1vXb9xaDz6JLvaEqIX+YS+CexjMC5X8QKvXfj7EkuVvKH6I91TFRN3u6qUFGPRvhWO5tVQAo+95hW5StlMsNpq2AizfiivwBsrN1KDpNZ/8Kxj4y/EM/mClbhSqXU4FADbwaKKg2tWsIu1gK6/z7lvkPT2XaE932OEOjYmAeKXWFAE44MHQLukmaiGwiniGIUjefRohW841RZB+Svm6FOuspJ9iYCIn4jtHFIdZIIjrYsgDrl41I0lpni1oXfcuiADn/Ah1IySpuHd2B20L76jZiSfG+F9HWddXSc0B446urqUWpbHEU0EvrmEAdISXUG87g+EW2j30H38mXj93jrQGV+mVfbvvcY/lnIVTmPtc5cCTUhknxYloucs48MSdeEsDHesmOmUnJ8fFXRgbGwc7uJS36BriqXzg4+vvUh31w
 eYR9M1k0
 46zKwflAoxbDU9n/BfDPMpcMfMM5JYFlawEPgudIeY6ana55w9KsFodK1iNrixZ8OHthiotprp4KlhKgvkTn3kupkfR2XVZUeRYNY9M0rn3UpRrL9OW8slMGNcbyy7L1QP+/qwki7Y+xI4Ks5BE08hAScL0ktSQlr8a6LkopoLZJdcxODcPQDj+b1XNTzU4KDwVNSEzFhE8UUyafuVFfQAJSip51UL2LF5lpNupAtpuvbgvQIoE+TRH/yxfdtrB3SqUgeYoca5pMHYA9fXM4jVd1y2O7ysDVG0GtqflG9YGYtrHfHYU9VegT9CwVQl+71RRDwSSxwsvoJwXa3Zr5LXN913TZsCFoHdUljOgIoT/1UXyAiiRgrbJ5KTluePEX143FtUxJpPqHKeWsf/tEQpji/xYviopkwxB/zRsT54ck2rr1XXDNQOT1Z5HdSBpsGzz6hWOfFU51AuW8cqPbYbDvb08GcGgtsl/tK6pNr+gEjl+S7SODp+Ymmn2pFV2BYjfWhqAUNm88GwAMjAYMbcFB95kIOccz01nTbqwoP4j7ECNSCY8gXsPvNYLD4s0PvJK4EfYOvMQMZfvSvIXBjGs5XkA==
X-HE-Tag-Orig: 1779204526-492604
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 448BB160007
X-Stat-Signature: txnngc7o35baxyux447ebzjts3seboua
X-Rspam-User: 
X-HE-Tag: 1779204529-477468
X-HE-Meta: U2FsdGVkX1/jylJZdQHyaKKq/nMjZ7kG4vB72ksBwX38v/HJCmqxkxAxHsK2nCNsd/4Y45evto7QfIoBjHRry+ZE7V1FLErj06BDaJPtA9Yr2pg/eRgqSa65sRI85oLHoWhvsj+MQnGlFEPNkatp+x08jzNRf7vxu/0IMi7xFQVvskmHrDyri6BwrcjfekYb0VqsCIB4RudZFMAcTOzHUc4iogr4/5XfD1satq//c7LYd018sd2fmMF3hCvqQ4KP39YlP0oSciY8xiz5fnCFej0zc5gveYQCnA+9tN32fyMS0wqdh0/UAyBmxVZF9dFSP3DFs2+gJ5iAQfu+Dbxfr2kCIT+bop3Mqji3sx5uLPHowk8BsOHmTTtGPcbRmEYaqCdzjYFQPGCgyFgdtqufZ8AV8xHlaeW5X8RsIGhmQcAGZ3ZYFfq2aw2JYnR/OfsMI1fyAREVjgVh7kTfeCSCb1WasaXvLts4pCQROG40kEa1R3sXusV5tZ/SprRRKaPLmafHHV70mcxsdHV2ebcFOnJGJW23Hy7MTO3T+lhhXAMnZDjt9L0+tBZzei/6CSi+T4MLw4SL2FCJulXzMWaV4XDxQdHCyrf/UelhZyDQdXhf2JLN/qpT6Cgfsa2SNTKn9Ba2iivxVF+BKL1B2js15O/L0KbB704S/apk7ZEHS+K48SZM1gDUnxYiUA8Jexmi996HlXJwGVP65GfWmrfLnJiR7F91GdZR9QkE0UMTy3T4dB3ATu4DfZLJ2nSfHqxbsf7mvVkadAxunOS4xv3h0OyW9rFVNIMxdg6Tww06VmyE0/xaBKIOQ48vaCf4cycOiEqFxpLVYzQjjy05tVUg4rp/bkatijyp1muVfrXT1oEhQj+aaMu7+2Yp/6vmpV2NCxr+c3lVhShVN4cm7sm4tPc7LyGukhOVGVQv8nvnF8W0sTkgTDtelIN0srqXEQ9kNzRACexFj21bP1+xB9t
 o2DuF8Bw
 lKP6MvbnYvSnNnG/U6/h+fnEh4ryFyrmaZRoyNo7QCtvyUjMKa4JrEN6gDD8jJ74UZIiytvYmeT+t+vC9sIiM9ItdqxUKfYD0jLFLMrMwsDkDayhg2K9UuSjPTg4EFRWHsRmsS5yYUKcApZ4+mL6aL02+IC8DAvLTbbCSUI/r8tSMdnmmZw7Crww7dZrnThk1At59Y9h37vi2kXoORoljvoKzikHTzl8neO1nXteVOCSk6qZxUJ0LDGTpo51G3YGotrLJUIcQw7sXfrpTWRrPBkRu2qJ2lb4OhYjuwFZlv+neh7KwwyD9AQoSKchpk+fp49KrMJCbOEVnwMKHrh0DvkZfFzN+FvJQMTpfS5KGKNLnDxYvIdtZgsy/aDfEuC2vlNvH2XhriOzpYBBzZCgKNxiTeILmIGsdmsTmGGvM0kT4ZmAjKJSok+bPREcBDDzePVJ1Mb2ZZYIk/7jm7L3l+3W1kLW91Gwo8UQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:47:52PM +0000, Dmitry Ilvokhin wrote:
> On Mon, May 18, 2026 at 01:24:22PM -0700, Andrew Morton wrote:
> > On Mon, 18 May 2026 16:37:36 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> > 
> > > When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> > > migratetype fallbacks and keep pageblocks clean. The allocator relies on
> > > reclaim and compaction to free pages of the correct type before allowing
> > > fallback as a last resort.
> > > 
> > > However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> > > direct reclaim or compaction. With defrag_mode=1, these allocations hit
> > > the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> > > ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> > > 
> > > This causes a large number of SLUB allocation failures for
> > > skbuff_head_cache under network-heavy workloads, despite free memory
> > > being available in other migratetype freelists.
> > > 
> > > Clear ALLOC_NOFRAGMENT and retry before giving up on allocations that
> > > cannot reclaim, following the same pattern used after reclaim/compaction
> > > exhaustion later in the slowpath.
> > 
> > Thanks.  Sashiko asked a couple of things:
> > 
> > 	https://sashiko.dev/#/patchset/20260518163736.173910-1-d@ilvokhin.com
> > 
> > I'm not sure what to make of the first one - we aren't holding any locks
> > in there which prevent concurrent cpuset or zonelist alterations
> > anyway (?).
> > 
> > But your change might violate the later comment `No "goto retry;" can be
> > placed above this check * unless it can execute just once'?
> 
> Thanks for taking a look, Andrew.
> 
> Goto retry can execute at most once, since ALLOC_NOFRAGMENT is cleared
> before the jump, so on the next iteration the condition is false and we
> fall through to goto nopage. This is the similar to the existing
> can_retry_reserves path.

Yes, it's just a one-off retry with relaxed fragmentation rules, no
need to re-evaluate the cpuset. So this looks fine to me.

> Just for the sake of keeping everything in one place. Another point
> Sashiko raised.
> 
> "Will allocations hitting this PF_MEMALLOC check, or the __GFP_NORETRY check
> further down in the function, still fail prematurely under defrag_mode=1?
> Because these terminal error paths also jump directly to the nopage label,
> they skip the normal ALLOC_NOFRAGMENT clearing at the bottom of the slowpath.
> Should we also clear ALLOC_NOFRAGMENT and retry for these paths so they are
> allowed to fall back rather than failing outright?"
> 
> I think by the time we reach the PF_MEMALLOC check, ALLOC_NOFRAGMENT has
> already been cleared, since we set only ALLOC_NO_WATERMARKS and
> ALLOC_KSWAPD in reserve_flags, when PF_MEMALLOC is set.

Yes, that's correct. alloc_flags gets overwritten, losing NOFRAGMENT,
for privileged requests. And then we retry with that already.

> For GFP_NORETRY, we can do direct reclaim (compared to GFP_ATOMIC case),
> so we either succeed or not, we don't need another round.

This is an interesting question.

GFP_NORETRY can reclaim and compact once, yes, but ALLOC_NOFRAGMENT is
still a higher bar, increasing the likelihood of failure.

However, unlike GFP_ATOMIC, GFP_NORETRY are usually speculative
allocations with reasonable fallback options (like slub's optimistic
higher order requests).

The idea behind defrag_mode is to not fragment until the alternative
is OOM. For GFP_ATOMIC, failing is an OOM-like event. For the other
nopage cases, it's more about "my favorite thing isn't available".

So I'd say let's fix GFP_ATOMIC and leave the other cases alone unless
somebody specifically brings it up as an issue.

However, there is one catch: GFP_ATOMIC is not its own flag. You're
gating on can_direct_reclaim which is also true for optimistic things
like mTHP allocations (GFP_TRANSHUGE_LIGHT e.g.). We don't want to
fragment for those, either.

So I think you'd want to check at least if __GFP_KSWAPD_RECLAIM is set
(which it is for GFP_ATOMIC) to decide between fragmenting and
failing. If the caller doesn't even set that, it's a good indicator
that they're purely speculative, and failing is the better option.

With that,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>


