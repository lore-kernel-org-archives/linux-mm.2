Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70CA606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JQmo1lpa
Received: by kanga.kvack.org (Postfix)
	id E57B76B0335; Mon, 19 Oct 2026 14:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08BA6B0336; Mon, 19 Oct 2026 14:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9746B0337; Mon, 19 Oct 2026 14:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A27576B0335
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:16:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC81D14071B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:16:32 +0000 (UTC)
X-FDA: 85340181024.01.F5E3C8E
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE19310000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:16:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQmo1lpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792433790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9GcCoJID0P6FXucLCwUTBYqCKowiVzUjNAVvxodr5aw=;
	b=0Ugcr+o6OkyV5Q6soROwuvh1C5C+RQrH2hy0XkR0FDTX1fw6nqL2zmWk0yEoEQ4lcksBf5
	s8O+gq++GRPy5DXChnI/oFnqW1+pgs2IrYGRFjD2Hmw8LION0eQfn7SqkyD30DxxjbOwxa
	d6rRo4Extrs7yLJysUPuWFp5Tvrg8t4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JQmo1lpa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792433790;
	b=Fr8FGE04AXzuL6ZHKnMF5xejk0cHxJpRHOGolfRcEwIYJwXwL8vLqThBrWWgj43WYBibfw
	FOOtk/A9s5QDhH+W2isijm+82pWBy4NF4u5Zez/bcUXVnwDa0xcnIxL2psWpQm5cJCk0Nn
	Z+FBFv3pKC8O/xi5XuJJMdHqjrdCfaE=
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-833e671ee9fso1599518a34.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792433790; x=1793038590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9GcCoJID0P6FXucLCwUTBYqCKowiVzUjNAVvxodr5aw=;
        b=JQmo1lpayYCN7pY9BPsyxtnk23XqC0ZhW4w6oB5u0vrALIvDnou3o1Fq2bW7KEuxNX
         0TssillEVYdBIt7r/BLrQUfNa8AkwIdnGKim6EmtSM67KDsiBED4dYPHLY/hz2/ja9iZ
         tzD6nD0WazDYt1+aTmSLK0HhOSKkDH0pZA4ITNFPUU2aFiVCw2uPAeNFoM1eBw1HZb/c
         baqkG01l40yY+AQskvVmBzfjteu43Rr6L8NwebqDmKYBC/Q/dzn0AqyP1SbEow/lphfa
         O4cF61wtiEOabiz3tNct2ZRc6Mye4ZrgbuPkun98Zo1ABEbOoivq2v+upujCHag59zSW
         S5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792433790; x=1793038590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9GcCoJID0P6FXucLCwUTBYqCKowiVzUjNAVvxodr5aw=;
        b=I37ZAfi3oiH9WYfRFmoX4Nkdnm2tSvZVV1ZgWL1kXYr6KgogntL6MyhM/yFOt6DoK5
         eWU+H10FeH31mG/0t/EoYIxZe25jdDgX/Fl+KfJ7rlWKdhUJfZ3cPWniMYtGE6tAZBYh
         fn1AJsoz2zew1sp+1U8NHCa8Qxu8kx4PF9D3b3ptniX1jLDo4X/KRwjuzdZA4wBuqU6B
         8xqbvy8RJgyLNl2FzzF5EAP4IV95lH1Phb9f9axP84P/+f5Zz5skashrMxT2/0HWGkst
         GI580769t9F8U4D6WtK1r/riQMha16EdUzSx71XpSNVQca7zHmnJe9N3hqKZXyGgMw/F
         ZFRw==
X-Forwarded-Encrypted: i=1; AKwUvBx39DPJ0GEy5zKcPlzxJ/fW/o6TEMvt+4l5h9xn0Xzr6pUln58EfX+uoGid8TfrB/l//gQD7GoVdA==@kvack.org
X-Gm-Message-State: AFq9FYL4h2jQzEKWr7z+BM42fz/vPZ/ZF4wjRKJhLMuR3U6TAJYJYKU5
	qg4KpF88ObRMiD477NBGUpcxFRojhz4tNVyv5PMIPV/QsGvm1F35Xrsz
X-Gm-Gg: AYBFou1Vi5t7O/3O4MhewazA2NTyvEyypjH09pCOAcaRV5Y0lMspnYhm3/qMiNjqox0
	R3cKscXdk+XXNhzjRNxM2mbs4SwxwWn3HFex51NywfTFm+FCdnvFlJMpTntBnsvDBFBKjG8+H/h
	7loJjRybdaGNicARPxN+96akdoMLLilJtpCq7iNgSJM+NNwcuDlTfwTWdCMhf3Y1bPFnvD92H3R
	qbfzIPl7x/wXD5kfNIQ7teuryn/zheGQ4YvxRjzfk+CjegE9LbUFREj3UwnM6+f/Ru1gCH8SJNW
	sbqJAXFND0ImNWMHvYtHvbHNik0lNRpAgtbTMW8FIUfpQTG3hPEWLou7/X4usP/9pHp7D2MCbdU
	Oq3Uic8SQu3o10HBvLObk7tr7/2Zlt4Q82YG9DVhILd9/sSY3q/AZ/a7qGBzx0Yu8lNQyOc8WWv
	pRxtpiDW83SO6LzW2l9cJaLAnCHPoncV2IcHJzIJAZZXYO9GAS2gogedtiOC0aBf9KNOhdxJgo0
	yz3GnaBmTHf6GTQ6PEepTemfz/tSw==
X-Received: by 2002:a05:6830:64cb:b0:843:8982:9532 with SMTP id 46e09a7af769-84500b76ebamr7325422a34.28.1792433789721;
        Mon, 19 Oct 2026 11:16:29 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-848e7d444e3sm3722002a34.25.2026.10.19.11.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 11:16:29 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Harry Yoo <harry@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu: clean up callers of pcpu_obj_full_size()
Date: Mon, 19 Oct 2026 11:16:27 -0700
Message-ID: <20261019181628.2113224-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atZWW7V0MI--HOke@thinkstation>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE19310000A
X-Stat-Signature: 9ipz3dhp5rdoiatyfzfi6us4u9ur3ndw
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792433790-401932
X-HE-Meta: U2FsdGVkX1+zPdXiKvnvmIdFBHVe23gkViPIby5X86RXwaXuZBeu1UI1J2VrWp01OAOqFiVbwq6xJnmySoO3SN9gmhBUJ64u81MBasNGKJ1dvutfTfTBTrBsg5TxH86tCojYD1jTa8FMk73epRln9pPhHWzyZgPSFSEfJGMioFA4UazbdyvNEDcvD1iTzQ93ew85VEsDrtUm2/C5oohOwbTi094xV14br8mU0y0JfqBVxOm3P86ekSgIf3FqFd8Q32fPiKCJQMQJMpOtC2BOiEMDCweaUsXjLyottH83HV8hNQuZFPuR7AXm0TteoyzhhV1thP+5gXot2BLvnz4Fvz2z+W95gTx06zTuvPkrX/+v55OfybJXcJQhRt56ju7LcfKaJgbzMXwDdUFXASyoARHjmhQIwuRxSdon0u1wONK7LUMPcQ9/EGNODbCsktX+zALZuw0dXYSgZnGRaAsZV+EBPxEh0MNHcougs1OQcJMCzOHq3fISD87YbGNBao4tB4LXjT6VrmuAm1h3sPAEML/Ci4C0PpKJ2TnEoB1O5OGIFCykq22GPySSTfzSqVNZw354i1cy6w89nEiu1IAdqjC8Na6anT4djo6IJKvv3QWbFTGk2BJmwtXcy7hWfbae/2ikiJSx+sEdliisxtozyOg2kB6ix2HcnhPXZqCUrU+cLT0vhhI9dFetilOeVb9QABpZvFzEByIMqSHo5SRX3hQROCJzrT+LOFgImaf8VdKHwH1DgwBahIiOJtwCU+fpMUtJQniFN19cyHGtJtgKBZbeo7OLNPW56JYC4Ful3JoHq6FzAYVPzGkb5XVYxYSPxreuuxvfykHG5LtK0GIl4bS8Yb1JgdfQagQGcedbEXMCPV8NbxZ+BCQ0HlIOJwubq76llVwfTfQXT3hqVCa3GMfwobYUKe3qPfBQanCNYRlLC5QwbhyYc2MvtbE2I+b+6qf2jsXw7jEu1nFB8MI
 gFuzSC2C
 TQ9Gxzr+PproxGzFKdzYhckvpv3JxNzbE1Nan3ShCmHjVjOlq+CM27Q2sNreykBQ4RU9ImyEdu5N7nLcCBilK4PCTM4caCeh/d0893WjrmRRLtKuvwA2XblZptkUGU36e0BgZ8u8LdJJ+gq98Q8B/ryJyXYUnbaJA3ve2z1V7Ziwx7n8QboB97rYB6YwqSLEgVhJVpMPZJhU3iTQ9nTiYVnPRmPwj0KJer9KUNpiwfaMUWQt0q4dKzwCMW3I8Va3FeRo5zAxxOqChB19YWY9miHqHiJJBE+ogQG3Di+8rvuk/AHlx7zCMypjDPYSE/gW7DtDwoEOB3CHqiNkxtOeeKoDUbwNtvyP+foP4Q1g0V7SmkLfTj4nTX4PcJun5cImR+y1rppY8PLFEnv4Gs/B0WKNcpCZVt3CC3NsGZiBKzxUPGtjngVDtze7EWgNflSCjUDE/GatiKw1gzqkciTdXtWebsSbfHWKg2gCIu8d8oHbMeres2fnSmnmLRSb62DbzemUgHC3Yiz1osdF5TAN/P0B3qBU1rh71hs849tr2/PSmF5qcZyohRhzI+SdLogJX7sLI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 18:49:26 +0100 Harry Yoo <harry@kernel.org> wrote:

> On Mon, Oct 19, 2026 at 09:28:02AM -0700, Joshua Hahn wrote:
> > The size of a pcpu allocation can be interpreted in two ways:
> > 1. The size of the allocation attributable to a single CPU.
> > 2. The total size of the allocation across all CPUs, including the
> >    allocation overhead (for obj_cgroup membership).
> > 
> > In most accounting paths for percpu memory, we need the second
> > definition (total size). Make this more obvious by coalescing the
> > callers of pcpu_obj_full_size().
> > 
> > No functional changes intended.
> > 
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/percpu.c | 39 +++++++++++++++++++--------------------
> >  1 file changed, 19 insertions(+), 20 deletions(-)
> > 
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index d7883507dc151..76848e096caee 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -1623,7 +1623,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
> >  	if (!objcg || obj_cgroup_is_root(objcg))
> >  		return true;
> >  
> > -	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
> > +	if (obj_cgroup_charge(objcg, gfp, size))
> >  		return false;
> >  
> >  	*objcgp = objcg;
> > @@ -1642,11 +1642,10 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
> >  		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
> >  
> >  		rcu_read_lock();
> > -		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
> > -				pcpu_obj_full_size(size));
> > +		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, size);
> >  		rcu_read_unlock();
> >  	} else {
> > -		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
> > +		obj_cgroup_uncharge(objcg, size);
> >  	}
> >  }
> >  
> > @@ -1662,11 +1661,10 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
> 
> Perhaps it's better to rename 'size' parameter to 'full_size' in those
> memcg hooks to make it clear it's expecting total size?

Hi Harry, thanks for the review! That sounds very reasonable to me.
I'll spin up a v2 to make this change.

> Otherwise LGTM!
> Thanks for cleaning this up.
> 
> And it might be beyond the scope of this patch, but I think
> trace_percpu_alloc_percpu_fail() should take full_size instead of size.

Hmm, I'm not sure. The trace event for percpu_alloc_percpu actually
tracks both size and bytes_alloc separately, but percpu_alloc_percpu_fail
only tracks the "size" paramter. I think it might be a bit confusing to
have the percpu_alloc_percpu_{, fail} have diferent meanings for the
"size" parameter.

Perhaps the right approach here is to add a new field "bytes_alloc"
to trace_percpu_alloc_percpu_fail so that we get full parity with
trace_percpu_alloc_percpu?

( Actually I think we don't even really want size, what we really care
  about to me it would seem is the size of the allocation request that
  failed but alas... it may be too late to change the meaning of the
  field )

wdyt?

Thanks again Harry, have an awesome day : -D

> Wdyt?
> 
> -- 
> Cheers,
> Harry / Hyeonggon

