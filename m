Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25AC8C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3296B00A5; Wed,  5 Aug 2026 05:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284356B00A6; Wed,  5 Aug 2026 05:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175DC6B00A9; Wed,  5 Aug 2026 05:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B176B00A5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:19:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF6CF1C0C6F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:19:04 +0000 (UTC)
X-FDA: 85066666608.18.C8886CE
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 169CA40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:19:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8FkTTZu;
	spf=pass (imf04.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yY9/CAJt+CCCGsWRlVdSNtH7ZN1mKB3TuW1AtqU1v84=;
	b=GNLi1woOoz+gffNfrVLLIeEdfpZXde09ETH/u3XGe0K5dIqLqZ4CSDRiTL1fpPXFmm2Goc
	JwL0Bsam+D8SnG5Wyfw9M8WB/KD3jzbH2eQtVNACqhSnM0znFs8nBweoFvBNqkbRn+TvzS
	ytK+LKRcug9R47ZxFrH3TaAM5ipYB/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921543;
	b=3eJFpouklVK6Hcmn/MemJk3B8wfVRoQkvbx0hR4mejib0GxbFo0T9t9uNgk9WwNUNVzyrJ
	aKVXT4UpYTJpBYkYsMrFw/8uU2cHdCdBxJnThWsspD+3Wt6CZ6tNvMtdGWBIyC0tsFuIOb
	iWLZkDafTncZAzCaf8cblOav5Loj1og=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m8FkTTZu;
	spf=pass (imf04.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-476a130c138so679314f8f.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 02:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785921542; x=1786526342; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yY9/CAJt+CCCGsWRlVdSNtH7ZN1mKB3TuW1AtqU1v84=;
        b=m8FkTTZuKrB9z7nzKf/8L68QpP23YucDJhyLWLpbVR7QWT2ZlenvnKJNC8SkGlDkUu
         jg7SiOUiE6/WWg16OfCzbBfWVMA7aWQJxdjFZJVsEv9gxj3BDcyo7XiLwbVWd7MW/VL2
         S8/MDWNQDiPzoUVQNUlAcOuX84c+Aeg7GZu1ZkEq2YugCrQDfuiOmnNSZ9k4M/NlqovG
         Qii16eubDVS6gA4QTGv/JiEq/gCT3EyJbO4dtLY4J7qiDzhRaKY2ISq6xraRuGtuD3/5
         O8JZziK16BdWoWHM6jz9nLl3T5WLYZj/ADfEva+SJmqdnV0hJPz4cwJxIm4vn5i3k0ck
         wGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785921542; x=1786526342;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yY9/CAJt+CCCGsWRlVdSNtH7ZN1mKB3TuW1AtqU1v84=;
        b=oSRchxB/DmE5P3ZWJWaJXOxuSux/EYxIlmZml7GjmaZAdwZdvrxp7DlMFs7ATmhU+q
         n8ILl9UKO0qYXUnwFVsecXthjSZea0dUxoIuKoOyaquDBIme1rrn5PmErdPqk6EWiIXQ
         3jzvJVA0JnYFV6I6MneSk+d4F9+wA9K6Zj+XqozEF87ujmp0KeFOUM+Gbku04XgxsEYc
         PW/ZFY17li66/8z95WnMe7kHCTyMXsU7FYA0wAAcyXiLyBeboBlBPOP5I50LtHyDQCT8
         WisE719D/g8XWjYRiPhNVGZpduhlrhBDe5YyGElpDtcxA5UdEUyPWdSrMZAO5rzpAr1C
         o9oA==
X-Forwarded-Encrypted: i=1; AHgh+RrG4NqtQrH6xFVb0VO8PtVH4ffk2wb3FHGc9SsCNwoty7AO6MP/RX6nPTMtX7tyQEcVPlGzy77DCg==@kvack.org
X-Gm-Message-State: AOJu0Yw2YzsiQg9V3B82UwRyraJiFyONEkXk22C8goXjvcLSIapor4hl
	rUzAaRFwPWw0uWwV2uKb0XpCQo3wGFe5A8Jtn6jRIsDz2xm3RdImbiQ=
X-Gm-Gg: AR+sD10tk8Bxe96O+2r59Q2lqbAvoFNehfpwOSzYHbMG73BYZZTOc8WynL5C5jW1BRj
	HVC2JPVov6dQkQPMiFen84VMXVPpOV01CbnQ2hpGcFpjzPPXxCxJPVppMB7+bveovp8+otKssXB
	bPlMGYqbd5H6HY6e5QF1WuRHpJ+UFYsFTdfSScZis9Lk6Gf+O8WoAuDBefd0MPg3c+0IOmNZ9a9
	tLtRPEGIx5iT1NoozifBwgJSTu1gY9Pr4532h0hnqokueP1TJG+7xLBJAfPtME3PBOzlIoEC+z0
	gxDLhpy+bwTYZbJeqD9IIy5nEHeao56SMuKUSnZ4wTIR4S7S68oO0yWUcyalrv0KBIb0K5hzlrb
	WafJLLv5KPFfz9OH3J9phd7XzLetwBdFzSuTACnl+0s/2DhKzMQZCMMKBqwWCrNNQvej/4IoAmo
	8fyn150U1B9AH2shD9DOSg1E3rQRvT+apyJks/elbEMeVfiYQ/ZIesBLj7Wl+OQpj7dvZlTtSSd
	kMdAbojrjQzna9PCiYlnu2g4nf1ymGm
X-Received: by 2002:a05:6000:2486:b0:47f:80df:3ba4 with SMTP id ffacd0b85a97d-47fec62aec8mr8012718f8f.28.1785921541639;
        Wed, 05 Aug 2026 02:19:01 -0700 (PDT)
Received: from p183 (dynamic-vpdn-brest-46-53-134-148.brest.telecom.by. [46.53.134.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfe5e85sm7167813f8f.14.2026.08.05.02.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:19:01 -0700 (PDT)
Date: Wed, 5 Aug 2026 12:22:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slub: print just the function name in
 /sys/kernel/slab/*/ctor
Message-ID: <68e28ff5-8cfd-496a-a895-30de110b0214@p183>
References: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
 <ee600151-85d5-4cd2-922c-d2d8df21878c@kernel.org>
 <73d28cff-77f5-4cd6-888e-5dce5ebae459@kernel.org>
 <am7NCCxeg3BsoYSa@dev>
 <c89d1843-e06e-4b8b-bf86-5b0debf489c9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c89d1843-e06e-4b8b-bf86-5b0debf489c9@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 169CA40008
X-Stat-Signature: uwsejczf4gxt7mgqsg314fuho9fo4gci
X-HE-Tag: 1785921542-859590
X-HE-Meta: U2FsdGVkX19E9vS2xXUJhRlkN1wWg/NMjzr/j7kU3ZaQtiOCMr0pQm9K98PcuIqln697fH3mn/HunaFzIzH/o1YguXGB/OoGe+dxEatHxoZbE8qJtur29w8IIls8vAf0iZVfe4ibRUEtIBLczTNMdhnPvPrwiviyWNeddOccjjqdLVvcGxSP0NDGZqkmOEPiaGyeaSz7M7lMyFafkXvykCQ+J86AozUIj1PhIm2kA+bwySCAidzMT7xdoCMzoWcHv4Mq8nt6aZ10d8vi4NNviIxq/SyewktgUTpO+aCjAXJ6Orjl6t5bVWovofDgQlTKQpdGmsY1Pl4XQEtO4V3qUFlC/XzOlJOAFtZCTOX8zIivZrQdrcVo2bzj2nYT1YGI9xfSwWks5RHBATIjyoo85rYyrR1DFcNSZiQHJkqI78IBY/yFLAHk9PaqGzAKV1DZcGVg/WesRbC0B9v+Bw6ZljnjRygmhfHuellwYYQmyIhZIxQMl5bLKZaL1oEdt9EEz9wL6qlfc4pJyzFE+kg4ybZNfu2BJurOCgfufLzZyhy/fSByOdqbQZERSB1DzWbwpA665YGRJ/KSh6o4TmkT6Jr7Hb0oRgeU8L1STuPfnw4cBW+vCeuHAFrSfQ6O1V7STI5uolfN7n1r/U8C5lyFQR/sr/QhOj+5GEct+wCJVV6OQESbUqTgDPu6uLiLwM0aWpOPJzfpsOYkelNjMvfv2lVIXzM1UoEAs5E0VbNfK21RikWKQoDzxVfLm/eAlh+TofombMEFkhAaO7C0bc8mjJ5W7oFhoz2fnAUTquDdwHPCSpiC8Lq1S4Y3cUa9S0HJMAXcTSaVy4SEKP1z/bmTjPnGJeuKEXYa95/gDEYoi67aFIuBoID0zgN7QJVs1EjgTXtvo1Y6N0GHPnG8sHY2/sw43jiutgSuG4oPZ1s+BMa7NKrc7fV3GVL19viLgrDyazi16HYsSO0JL19kCcH
 pDHmKCd1
 VmnA8S8r/9b3kVzFWxsE9yXBvWEoZ7yMum4ycRnjLuUc/z0ZI7W+jP7LzOwKLyawy/WkvPgghOqpGYq/j97KLg3JIZAwxKyL1+gEE8SOa1qQWQhFp8fF/7Kgf7RiGEsjXOjJQaNvz8KYqEBu3Oex8J0fLrc21+NcEciMoZf+i+AR1h74iU62tiPBagP0FJAj/Ra9K5UngN6NtL8Ah0055m2Gok4AFl9/jHIOi6ECQhwgwpr2YQhAVVEhPHNmmhARzUua+bVRGeSzj5FW4/aOt73Ue7k9jkMCgc0c5n/815fuZ5PdCQbE6L2jYRzKjtkyQNdQ/YA3JT23dmAsIw2H8+HT3n+/noZlMfNOB4rfm2OW9H38fzZ4gisCnDKte4TgjpmCh/xGTGTVbz3MgJL/KscTyzFh3gIMsBAt0y7lpSnv+FMJ6lv+C5szlG2lFjpnILEo0oRtBuSAqgAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 07:25:15PM +0200, Vlastimil Babka (SUSE) wrote:
> On 8/2/26 07:13, Harry Yoo wrote:
> > On Thu, Jul 30, 2026 at 04:15:26PM +0200, Vlastimil Babka (SUSE) wrote:
> >> On 7/27/26 07:27, Harry Yoo wrote:
> >> > 
> >> > 
> >> > On 7/25/26 10:28 PM, Alexey Dobriyan wrote:
> >> >> Sysfs "ctor" file prints offset/length of the cache's ctor function
> >> >> 
> >> >> 	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
> >> >> 	init_once+0x0/0x10
> >> >> 
> >> >> This is not useful:
> >> >> 
> >> >> Offset will always be 0 because ctor is a function.
> >> >> 
> >> >> I'm not sure what ctor function size is doing here, it should be in
> >> >> /proc/kallsyms
> >> >> 
> >> >> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> >> >> ---
> >> > 
> >> > I'm not convinced that changing this (without strong justification)
> >> > after exposing it to sysfs for 10+ years is worth the trouble.
> >> 
> >> Agreed. It's a pity this was exported in the first place. I can't see a
> >> benefit for anyone knowing what the function is called. Should have been at
> >> most a flag whether there's ctor or not.
> > 
> > Agreed.
> > 
> >> But possibly a justification is not to leak the function size, which might
> >> be theoretically (although unlikely) a hint to some attack.
> > 
> > ...but you need to be the owner (root) to read this :P 
> > 
> >> Well at least if somebody complains about getting broken, it's trivial to
> >> revert and we can hear about their usecase.
> > 
> > If we were to experiment with this, we'll change it to print a flag
> > rather than the ctor's name, right?
> 
> Yep, let's try that. Alexey?

I don't mind ctor name, it is internal implementation detail,
but offset/size are kind of useless.

My order of preferences is
1) delete +0x0/... part altogeter,
2) when someone complains, restore it as "+0x0/0x4" which is a minimum
   function size across all archs (or some other fixed fake size).

> 
> >> In-tree tools (slabinfo etc) were checked to work properly?
> > 
> > Looks like it doesn't read ctor at all.
> > 
> > Commit a87615b8f9e2 ("SLUB: slabinfo upgrade") added -o/--ops option
> > that should "Display of ctor / dtor etc.", but it reads "ops" attribute
> > that has never existed? Bit puzzled.
> 
> Might have been stale code from some previous revisions that included dtor.
> 
> >> >>  mm/slub.c |    2 +-
> >> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >> 
> >> >> --- a/mm/slub.c
> >> >> +++ b/mm/slub.c
> >> >> @@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, char *buf)
> >> >>  {
> >> >>  	if (!s->ctor)
> >> >>  		return 0;
> >> >> -	return sysfs_emit(buf, "%pS\n", s->ctor);
> >> >> +	return sysfs_emit(buf, "%ps\n", s->ctor);
> >> >>  }
> >> >>  SLAB_ATTR_RO(ctor);

