Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F35BB606D822
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IHrEgzoa
Received: by kanga.kvack.org (Postfix)
	id EB18D6B05B6; Tue,  3 Nov 2026 04:02:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A0D6B05B7; Tue,  3 Nov 2026 04:02:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F716B05B8; Tue,  3 Nov 2026 04:02:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2A8E6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:02:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A399A0359
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:02:43 +0000 (UTC)
X-FDA: 85393217406.25.BF1152A
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46B6240003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:02:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IHrEgzoa;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793696561;
	b=FUgyPXZu/hV0zwq+Emj5WBYB1JdSy5c5dEKcYkOjFs8bXwaF0Vmhudo2l4QVpIiYA33ixv
	1zSRrZlsNbSAy5zPGfdUVi+U+XcHw0f8ENsa88lmZMQePWb4dHUcR9w8bfPoO30gSw4dK+
	/s1iYgCPCIGmL+cLA2kMrIZk3cKEV9I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793696561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWIvex+EJW9vCLXQbA9ZAE7jkop1tjSSd80f2cNzUHA=;
	b=gdklm29JYQLgsti4oqP+t9fhR+Oeai0iwq/UtV6Uyz7UzAGVPQ+AMVouZy7jP/wdPQ/+v4
	2g2GOhDTuURTJoQ67ametsKYmqQ6V5ev911LHjlrbCrnXQBvF7u6dV2LgJhXx//ZblBxs9
	Kk1Ms1jfQXEog8yPo64bVQwOslyEmNw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IHrEgzoa;
	spf=pass (imf04.hostedemail.com: domain of hughd@google.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-67b9bd530b7so2585386d50.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 01:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793696560; x=1794301360; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWIvex+EJW9vCLXQbA9ZAE7jkop1tjSSd80f2cNzUHA=;
        b=IHrEgzoaje2x/7LtA0XlJCQlJDsvfqcAZDru69RiGNHKScxNAqR8sQ27aSe8hqX7eK
         LSl4ySkquD4vu7sm9xIdVNssjxjK7vfyoou0Ham41lHh7QRkL8i7ymwui2bekaQjshPM
         kzxAiVI2ZKgoYnVRbU8Jf9V7rwGsDQeALizmqaA2RACL68W2IFnsS4h6nW8nQLakxDGh
         /MFrOBkZZqXTA+9fkzDSHBAJBYjkERepRvgvZC1h+68cyUWMEAByOnY9Nx6duajRq/YM
         rkSzPA1cGtKvDBCGTfAvu2iBps+Aab6+GA/j5S39Qe7eftZYbvhd56TbBBsNQhCL/m4V
         wg0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793696560; x=1794301360;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LWIvex+EJW9vCLXQbA9ZAE7jkop1tjSSd80f2cNzUHA=;
        b=iOA7vE5CtRic0n9EmylQtG1NYwQTDGKqJ5FJFC30owtENp1AuIKYl2OU57LbB9e11O
         SjPyUviayJkIuD4SVsF4yf0Xhc9fVMfnLBcqArFkYRo0dwFNvJ2Fu/wd6G+spDS9Qvya
         GLJzaQXMwaoJvL99NROrxXnsriir7xo4es89nKRmURptPoV82d38PmqG+3qKpbzTh+bw
         /GvPeKT2IbMBYpfePq7s/aqiEUBMW3JQ6rydKK2sJWN6zUzpkvzDU3uJjxkO1fsSKFxO
         OhxUgW6iSIPDZlC2ezGRBCJT/68Q/LLE6HFnylfA812MppGsQcM363sEYTDxMaqeNSpN
         mQpQ==
X-Forwarded-Encrypted: i=1; AKwUvBza9/NafPZX625MhzzxXkn4k06FqK2oWSXTuyp+3zCoL/ssqv6ZAeCVXarGcmhUOPt8KpuNb/JkOw==@kvack.org
X-Gm-Message-State: APuU4Z+YxBXq7u8+usKvr2JqQCzZp1THFnML7ex+iFerSCynj0jVlM5W
	THFp6/XxVsUtmltOaoufjSl5e5jb4ky+81a9FgqwasINu5bHWWsiFnesP5XdNfYqkA==
X-Gm-Gg: AYBFou3FbE+FfAtkYhm0gxz8m/rA55Rnt80opcswl0le+pa5m1gREvcpto0E1fsZbSI
	rgsJSVdHw9waE9BXb1PlaDWabucGoGBmUCrU8k2EJRJ711Pt34CltUP00MifO2uCoSIe5b+5rbT
	C1VHUhHla1xsCLcDQvP69smuCi6uU8HiZHQPRUDWSuVrqgbJQhB2veuezREnb9zc00YfIwpmxU0
	IdpR6r9wLvQJ/iNj4uX4V6EQaseq3Pec0l+10o9uHPsLVOPP1ToF8ApafdMZkpU+C2fgdf4BR29
	q3VjlI3kGUWn/AYX/s2KYnKXeLCqmjxS2PYQaW7GxkPp8Wo6KaEZNr8F64dz3CVov6PYHF8afdD
	TcuSlYZSEJt9SUI8+2Oj7S7eauOK5Phion0+cpoQ0zKrJ/BvuzeinjbW5Hv6bGTlc3Dp8aQFhuT
	Bcd8Qs5J2L8SEn8bGav/+n2U7qcc2aVJuWQ6h1WfA/JpLcZc2Pp/5cHc8GwE52PLnkAUjqwDOVi
	lrrp0HryuQNieVOun++917CxTwoG4otx8rZyWmrjRTCCX4CpiBE9mmyQMx99yB2YMfW7Bi5pHTu
	h7UQgtfknxRIOS0DHpKgrDdAoPENxm5oWYAYz+uA056oQg==
X-Received: by 2002:a05:690e:191a:b0:679:8dac:aa85 with SMTP id 956f58d0204a3-67ba4fbad8cmr9812036d50.25.1793696559513;
        Tue, 03 Nov 2026 01:02:39 -0800 (PST)
Received: from darker.attlocal.net ([172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67baf148ed8sm6751439d50.3.2026.11.03.01.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:02:38 -0800 (PST)
Date: Tue, 3 Nov 2026 01:02:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Alen Karnil <alen.karnil@ideasonboard.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 17/26] mm/fbatch: no lru_cache_disable() in
 __alloc_contig_migrate_range()
In-Reply-To: <4898b6a7-1824-412a-aef0-ae6bde021e38@ideasonboard.com>
Message-ID: <304cbee9-0f1f-e1fc-7fe3-3cc4935a0d28@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com> <84ed3bf8-da32-3447-0577-052c5d1a56b2@google.com> <4898b6a7-1824-412a-aef0-ae6bde021e38@ideasonboard.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: ckz4jroxikx193uysqti8o3cqbabyt6b
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 46B6240003
X-HE-Tag: 1793696561-104288
X-HE-Meta: U2FsdGVkX1/V/vMX99GSqSdcShSylAhaOwUUXlRRA+oE+TBm4UK2cio97kArzNVll3qXZQ0sFrlSYLRU7VFff3UFxAUDTeMi+XGIggUNbZ29N/hwpCSvNGj+yL+F4IDJGeVfYUaz1SLdrsUom4ccXSlu6l8pFBki+GaIIYudxPUw1JlsFtb1nglILg7VLFdZIMHLl5CI5XPxD7TGMuIuD34HXKt7Kl6km7LuoR4zl51ThxmGAuwavimllUeRtxmoBonRkewxIxgCTsOS1FiTTcwVAMQN/jA6lqUCUXWiFmou9ejPT9SEEYAMPqJkxIPYQhmTZZDVH/u7LrJ0/AUU7G6f4aY1PUHxGUtTjvifiMAHuJcwLUGX0tESYd2RkXyl0mn8qXFbTKis1VSpgIATGp4BX2M0XndkIzRAROGDxkBCxeuRMSslORJZ8KpSJS1dKaWijAyXdq5REOQ8naw8RX9MQDIT9uUL9jZnEPImj467+roHD9GaCPcL87jCC4uJYXL9D7Xuenm/1E7yBOUmX6S7i/ioVAKg6OHrf1GMWXbt6DP/HeyW4zIZhFySbpWZswaj046WqqdGVsZX10bIT3cz55cusZOBaeVIHfe3Q39ufW9Z8lpMKObs7pUATIBhiX9EgJHX2G5cRNCizvZYGPH2ljuiqKfz6WeAsJbI2NmgeHyaAhm6CesKMWgAa3sJ1wmWnrwqNH/z593grTYDoe7DKCGUBZg4lm14JplPeofzPl+i2+WsBH/617Jdk1VnOyb40MYC4lNpP5mEamaglsJ9yBKF9qrUvz0Tm86TXU7vGN4790/h2xyQMUxtPOMl1cCkhjpymdr3FBHAk03iD2EUFX1HrxyUoA2vrq3a8WvuPpqBsrXr4KY8dRSEPlFWQt8AJhgdzUQ+5QXgEbESPMYVOcQFk6+B9DibK+f9CeyNo1m6CBRh0pwYLqiC7lQZorvOyM5O2VD8nVVY9Fu
 eAShI05s
 1xLRw0iYFmH8ZMugw0VHynAU/o09R4HA7JnUPkJFliNp7ayCsQ7mMZ/d6L7rVVnTsth9S1mOFGSg5PH6QbyLtagQYw8sUJ63dLPIxKEvEmZT3GtNIgLfrDyIyezYQV2+KNSRfscS5cUnciR/WosUErQpFpEKHC/Tn/KJPPor0nhWI4xEcNl6py9Ai40N8hvc3DSnH7TlfBYDms6cAyPN3mCzlJdl2pcwaKnx+jBNU7hZZFt/bUEzgfozzZhJ7zDTedxMxwY25Kn6migLLZIkIlWpGO9HkXRZGIPhlTIt4Rm9g8AgBdvQt6Ju7qjC47mO6JEDRd7pEMKAT5OIg3ocL8jRUF1AgCw7rhnO8TY3gwbxe5I3S9NfyDMyp7NJ7kmTNPXjNytHu+piCDvA5QMvX9/AhX4B7wZwDOsqEWgFAEQ0jWyeYVA2r3VrVYy1+i1W7JUJqfISO9605hu9c2SYlJELAzxYk5jufL2Ln4UCwaU4fFl2jMMsuKdN254P7aTVIdJASBv/jabOTvpxywux7IN/PrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026, Alen Karnil wrote:

> Hi Hugh,
> 
> I've come across your series because of a usecase I have, namely this patch.
> 
> Not to bore you with details, I got an IMX8MPlus with some cameras.
> Due to the cameras (and other associated HW), it ends up allocating multiple
> framebuffers using CMA (currently 16 per camera)
> which is quite slow (~200ms for a single camera).
> 
> I've spent some time profiling and found that the biggest
> stall is when lru_cache_disable() is called. Just applying the patch on its
> own, I saw greatly improved performance (cutting the delay almost 5x).

That's useful information, thanks for trying it and reporting back.

> 
> This is on a 7.2 kernel.
> 
...
> Can the patch stand on its own?

Yes and no. Yes, you can include it in your own builds if you're finding
it useful: it's not going to cause any corruption or crashes or suchlike.

But without patches 1-9, it does increase the likelihood that, once the
system has been running for a while and memory has become fragmented,
compaction for CMA allocations may fail. It's a temporary failure which
the lru_cache_disable() protects from, and maybe the retries and system
activity would work out, but there is this increased likelihood that your
camera will not work when you need it to. (And I don't know how long
the camera's memory buffer is kept, between uses of the camera.)

So no, I would never recommend this patch for a release, without the
preceding patches of the series.

Hugh

> > ---
> >   mm/page_alloc.c | 3 ---
> >   1 file changed, 3 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 12fac9084c48..3e085a25a776 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -7147,8 +7147,6 @@ static int __alloc_contig_migrate_range(struct
> > compact_control *cc,
> >    	.reason = MR_CONTIG_RANGE,
> >    };
> >   -	lru_cache_disable();
> > -
> >    while (pfn < end || !list_empty(&cc->migratepages)) {
> >     if (fatal_signal_pending(current)) {
> >   			ret = -EINTR;
> > @@ -7182,7 +7180,6 @@ static int __alloc_contig_migrate_range(struct
> > compact_control *cc,
> >    		break;
> >    }
> >   -	lru_cache_enable();
> >    if (ret < 0) {
> >     if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
> >      alloc_contig_dump_pages(&cc->migratepages);
> 
> -- 
> Thanks,
> Alen Karnil

