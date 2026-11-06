Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F51606A33F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=If/BswNf
Received: by kanga.kvack.org (Postfix)
	id C1B8D6B05B1; Fri,  6 Nov 2026 09:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF30F6B05B2; Fri,  6 Nov 2026 09:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08EE6B05B3; Fri,  6 Nov 2026 09:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81C4C6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:06:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E815CA7DAF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:09 +0000 (UTC)
X-FDA: 85404868458.23.7BAF28A
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1FA21C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:06:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="If/BswNf";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793973968;
	b=I8liFCQI1egvnyxiAuPPlyAvXlAfuDFceFEdiUBUwEb6lOkUHEbBRqVoXF1Sxdxqnw3gnM
	kk+AiyFs8PaZN8F2ChVzo2dzzt20RbEEgW3hSJL+IyFWj+fpozlFYHGP3hCdFKQb2lXU52
	zKFumHMMXmaKmIgE0RY+goVKLnwTs60=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="If/BswNf";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793973968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
	b=o+0oIP4Q1DVsQPToJn65/cEcm7sSxWQl86Y+1XhUSEBTts2jZEQDux7vXbMw1u0WMmnDmR
	nepnmJgQma3PS5rvEDMNgM+uTr31N2XUbr0ltNycSggsTVaWZNv3Og7oyRxjaTYD2VwITw
	S3Kqu5rDOn4DT1G6IPX/Mu50QcjjLBk=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso7800677b3.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 06:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793973967; x=1794578767; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
        b=If/BswNfxWeynKFi+FZY57Tk7tLEmPMenWTY4XWh4jat9D1dEJLauKHZ88S76MXI6J
         5L5d6XJxmNu2ZnaVy9bryyN2nwkIpL/lLdmMQ9g4oX9Z8VXqR5hKt4ByS4t1tKCVzAlG
         CNnazTFdWdFbKMwGsZqyDtmFYo7H/LntXQ9gwpGAy2HbOglx/DlJl1pdEqmv60A2iaqK
         awRGnYSadMzLEuMyWFTeDJgi8nDIThj8A481Wv5mcdwoi2usO2guLuuXt2HbxhE06eaF
         FS38UpbjjqOHvqA2gUd2HAwPq4z0GoK4fjGI+Acpv1c+4UxrGkFwCQHvGhjSTr8cEpgc
         Fu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793973967; x=1794578767;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eqhBVbUtw3dy734MGt0XscJMrayl/heBjdE55TwHpBE=;
        b=pI5qMTo1DlIo10JcZYuoKBcmUGrcus9aZEw1S8XKiTWXxW4PdGpdyWAwx5pgNtUEnZ
         ak902AqMIUopVQ/9KSnz2nTCPGfJPyuBzLxO+LDiu+yLo8kc4yUtJcKDqKdrcJzw995k
         D/M3fRTJtZmW4dW0FNh+CNVZ3eh7wtAkT3Y2JN47G4mrdeHEdXGh0Ez+5CIHT3u/m9A5
         McnRq3rWr8ojq2KBWHj5hjBtTEnVaXo1yXdbATnisxHmAmImbpIWY/lsu8hR2cj9zHAK
         evoob8jP6OB065WuQM3UYklMD23QqktJioGW82OzzBxXLvpQV/UOnS+Kqezk4hSQ9eB/
         vdEQ==
X-Forwarded-Encrypted: i=1; AL+hErFUpsUgk0chb7QPS5xW/FnoW2N7GHtszdQu1KIZ1KNJ0SzmuwdqL4hgpSCSOLfxXFn66J3fS9baaA==@kvack.org
X-Gm-Message-State: APuU4Z+FkcBR8WP7A0sxBz8GeN2NPMiLZglisWxUQWu3ZxTp9+cVJEpP
	Rb91E8b1x7Ipl0++4fcCCl5/WNiXswO+2D9WiIOGfTVaT11l5noJafh2/JnxrQ5qPME=
X-Gm-Gg: AYBFou1SD4SnAVHSc2Q4ffut07Ql3ym6jnVwZjWdOYRihsZxodXxwgrQiVtc4MYhysl
	JgvFnFLjEHKGKG1ivKRm3E38Gw7fQV1C+8D2atldPYleDT8KHSWXiDAdefBC07ab36YHSokatIC
	eHT+XTHnR0DNJqnILXbrAfrSIgUetMHMpiDDU2cQmPSCcN2yMyf5BmgTzjDk4vmGa/4q437Kz60
	0U93XT1X9QtmoAOfYUPxno8winPGie5JbazXqV1caHaZTk7p01cuNdiKq13zRR+2H9MRq/HJiht
	O8h6/drcAm6V7oEpEEsXTmozWyL2H4aNQcuwRugMEUpUsf9CX9hAmpHck13Sd1ujT0uYDOZsAdH
	2ToALcQRFemvY/RKV4A62zMGJkQjXagZx2KzQImwRQw/zCp/XAHYpUSsf4Bm2iUC12FkPzKqWxr
	w0NURVLlwy8NP+41PWKKmw1FLieu+lhxFpw39SCTaD6rz3kcHBgGUOCpPJKpnseeJj8QRuaomm9
	kN120CFGMf8nFhtRuN+IvgVsL34/Jmtcr2L5wwnTkd1CEj0iIvTrvlYplFv9rpO8RbNwtFAA5JX
	LgJguLQOs39RCSI27XjqOsZzRzSg
X-Received: by 2002:a05:690c:560f:10b0:8b3:10df:54a3 with SMTP id 00721157ae682-8b341b1ebe2mr10611897b3.65.1793973966605;
        Fri, 06 Nov 2026 06:06:06 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b33f856f99sm19108527b3.34.2026.11.06.06.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:06:04 -0800 (PST)
Date: Fri, 6 Nov 2026 09:06:00 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, gregkh@linuxfoundation.org,
	arve@android.com, tkjos@android.com, brauner@kernel.org,
	cmllamas@google.com, aliceryhl@google.com, nat@pixelcluster.dev,
	arunpravin.paneerselvam@amd.com, maarten.lankhorst@linux.intel.com,
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
	simona@ffwll.ch, viro@zeniv.linux.org.uk, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, cel@kernel.org,
	jlayton@kernel.org, cem@kernel.org, akpm@linux-foundation.org,
	david@fromorbit.com, david@kernel.org, hughd@google.com,
	yosry@kernel.org, nphamcs@gmail.com, matthew.auld@intel.com,
	matthew.brost@intel.com, thomas.hellstrom@linux.intel.com,
	jack@suse.cz, neil@brown.name, okorniev@redhat.com,
	Dai.Ngo@oracle.com, tom@talpey.com, qi.zheng@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, liam@infradead.org,
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
	kas@kernel.org, mhocko@kernel.org, shakeel.butt@linux.dev,
	ljs@kernel.org, kasong@tencent.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/list_lru: Account node removals in isolation helpers
Message-ID: <au3eyCrHiuhbJx3u@cmpxchg.org>
References: <20261103045053.59548-1-kaitao.cheng@linux.dev>
 <aupITfr9pBKPrU20@dread>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aupITfr9pBKPrU20@dread>
X-Stat-Signature: yj71kxuj3fid6cadzwdfr3zkhwm5i1zc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1FA21C0002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793973967-368031
X-HE-Meta: U2FsdGVkX190bedQQkFbfGB/5M9waq5XPpgt1qhMUNs3Xv3Tntlajjv7rIZq0sUZ29h5TsZe/GtozAn6zkp2BugzMZfH/YY4iUdXqr9/ab2NsvUmZjnii/3xvAraLnG8A2hk6iYfVlPDcn2CiOJCeFb9F45G9GWFV7iRe5pPUqBtQawGcQhIzG2ouc0huZ/IbJyEsiOnQ4eQcG7BeCiq3H9wwtXNR0aSgBlwnV4mI8c2Redkg9cTYNcAjpcCj7wWAt9C91yFCPA7DXf/sH9KeOMCTH/1g3kQU1Vg3mDlNix3ItzlPOaHQT/9Iog1i3y/HJisk26uVxMbGHI97qGwiGRz9EGKS7i2TN2+Qg/JpOKKVNdR8u8oP8RdWn1F7i+3GilzWtJAdWL+1A6qDXRX9DyiOJkt/QO7MokuIF+0CpSXz6DjypttaiaKErB8O/an/navff17i2BsRB7GVrrgUAz9ZM7PHaIP2XaIa0CfozJnr6EioZkomDYfaHEt6ot1ta+2wvYB7sld8KkQgQOlDdGUp8gMcl2fi2bHLBxaifeOieZn0jA2E9eDg4ajon/rObZS+uY5qq8zKauRBlON/jxSs0f2rpAOUXWUK7j1Xbi394ZGIutNXHvPDBYbx71AzB6EFRpTIU5jfhWTQIUSXBKOSwTqbtUv0UEA09glC6grtozANym2X7lkTd9LvIzXWBkXFp71ZWp9hfJ6wKb6mJQv6f7z0X281lDUfrYHY+0WWRZsxtzFU2EcYuCo2ggXn1iGet/dq3KpuADPkt8E/IoCfx0hOgt6fLrWOhKNleOs81Nf1KMFZYyfv83jQGfQZK0NWslZeFtOlsj43s1D4BIqQhMX+STFf2e8vHck5+GJuZ2rt2CSt/uUJ7bO2qUFqT1Vk1BySeer04e3fSElsscN9jMrcWKXnE9EWerUR/sFuxseK4E83uxPz5C9IgbIm6ki2hqspfUkfCsN8m5
 KoBtylcJ
 GiJmS8usH932Lq8CwW2GRrrOeAcaSBxAqx0SWREscNpYsAHIY/eM02N2+gV62MDNdUgAjKwFWi7JJ6Zw5+si49dCuMDZZCeZY54VfKTjEhcIkd3xtfl5keTRS3VP912tV0vH/Vzfoobd+hsdktAAVoO+WJCvFknM06AbEenCoZyqMMzQZkevtkpOKJiP4xc5/GpAgd/XuIQWYzzitVJ9mR+uOFyZdnL6LfaKwvnWElcH3N5q3nrbH6VV1CIap8VU8DhxzBVRDu7BxaSwkhDuqTcg2asfkSepTfDUUa7mPuQdOvOSXWfvfY6hedI4CPeuxVAix1B9AfUsPl8+B2mBFduN+7Z3YtTvwlJJjbbrFjo6GE4IoTFVMbOk3X3senwA6oDeyU256LCM9sQBUgt0whOqsOR2KK7ltrbkkBYIruO4CuumgP6p4K9AO+VClyA5FXCXve+8x5Wljy+2JOm7J0Z9SRb9g33VCIRFnZZEFHp6cvGvCdg7O+1Vf/zE9C91CJi4CJ2CZ2Ku1+Xm4a2F+lGAX3A7l4/pB9ESiJBjToZ7ZkhzNa7VCQuQXaAuJ0HgmOQin
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 07:47:09AM +1100, Dave Chinner wrote:
> On Tue, Nov 03, 2026 at 12:50:53PM +0800, Kaitao Cheng wrote:
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > 
> > Successful writeback calls zswap_entry_free(), which removes the entry
> > from the LRU and decrements both the sublist and node item counts.
> > shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
> > to decrement the node count again.
> > 
> > The affected call path before this change is:
> > 
> >   __list_lru_walk_one()
> >     shrink_memcg_cb()
> >       zswap_writeback_entry()
> >         zswap_entry_free()
> >           zswap_lru_del()
> >             list_lru_del()
> >               __list_lru_del()
> >                 atomic_long_dec()  /* first node count decrement */
> >       return LRU_REMOVED_RETRY
> >     atomic_long_dec()              /* second node count decrement */
> 
> That's a bug in the zswap code. You shouldn't be calling
> list_lru_del() from __list_lru_walk_one() context.

Grr, Kaitao you dropped the wrong thing that I thought had merit in my
proposal...

Dave, would you mind taking a look at my patch at
https://lore.kernel.org/all/auJkvb-Lq0M5Enkz@cmpxchg.org/?

Ignore zswap for a second. I know it has problems. Most of it stems
from the fact that we rely on the swap locking and do none of our own
locking/lifetime on the zswap entry. As a result we work around it in
odd ways. Sorry, you didn't ask :-) That's worth revisiting, although
it's likely more invasive work.

The observation that led to the patch above was a much simpler one:
since we now have the caller-locked __list_lru_del() anyway, the only
difference between that and the list_lru_isolate* is the
accounting. The patch is about one thing: removing the isolate helpers
entirely. There is then simply one tool for caller-locked list
unlinking, __list_lru_del(). It removes an avoidable distinction,
shrinks the API surface, makes it harder to screw up.

The zswap weirdness made me look at list_lru. Consider it a stress
test from idiotic code :-) But I would propose the list_lru
simplification for its own sake, regardless of what we do with zswap.

