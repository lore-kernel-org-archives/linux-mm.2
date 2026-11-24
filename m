Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6721606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=ERnNt4hW
Received: by kanga.kvack.org (Postfix)
	id ECAB76B064B; Tue, 24 Nov 2026 03:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1B16B064D; Tue, 24 Nov 2026 03:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE9F6B064E; Tue, 24 Nov 2026 03:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADF006B064B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:52:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45CAC1A0977
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:52:31 +0000 (UTC)
X-FDA: 85469396502.01.DBDCFD2
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 262BD140003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:52:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ERnNt4hW;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510349;
	b=DDVTpJ7MlG0rtPlrNdc3QIEtDOSYVRo1UjZo1o0gnUCES66+sBFeuZ3GiflSXx3ofPxyew
	wo6Kc1HR7DP37HGJaT9mL6eD5RjDpidD/z6G6Be21EXIW1GIzDKAD4O+/p1Bkfp6rd7iCl
	ON3G44h/bEsJEgfnbG98IFIdjranW74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
	b=laPItlnGrrmxMGhJA2wMYf4zhBK0jLB6sqmuRUKjUs4QPM/o8z2Vt3ONC4kwlMMdcj4ZMv
	SMHGoqzSO96IdIwGqwBsDo5eDXkjevyoHtZ70Ztm5Zfu7a77ULMBccqyl4bHAjdMB8Sosf
	Jxo6mZNzgoVThRa87v7HUc4k7RWICuM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ERnNt4hW;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-498f5fa5103so2490627f8f.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795510348; x=1796115148; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
        b=ERnNt4hWpwm6HhvLtgtkf3uKBIRT4aoozkiCzwyMzIUP7HVrtFHw4HqpRADD3+tRzq
         TD3HG783MEKBckYpbNOcM4Fyi8NYc+mPhYIOSCsvX6fV7HbmLN4Y/UQPdpaFWTmYCsh4
         Zr4BMvENTgjFV0omAptVjjaln6FiQ5dbL/NIa37dGc1iGyTzg9kONLlVz0Ww6IpvZ3oq
         WmnyqLT403BUovPBNdoEyzjEheuvU8KsRlkIsfa/0YFfWyg4uOPBP/WFphxnEB9DkpK5
         uEBRA3zOiTWuVizBtjJPcPCNkZdYvhi8NnLeg9w4XqOdJOyEzVddiErbpLzbv9wqLEId
         zbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795510348; x=1796115148;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R4vZ6P/pxgMeaZu3yTIBPWC7zlioL2LZflk1ZvJYOpA=;
        b=WMRPxhTtskOPGKxHvhV/0ZlX+nTxJgPknOzULeuW6EzCUn884QTVPV1XGHtEfmIOVe
         9x2jQyeUCQmhVSzQ8Ag9MBHUtuanNdOmSHJFRXE4GMfbtkh1kEnJwGdVSRmlxJYfumKC
         gkBMDNhS5vL/ve3dNjAdtBUpkD7lYVRPyO51kpOnbao9yvx8k62+1HhlyKhDXXdcgGBJ
         PbyPkmGdL+fYPmkTNPi08wfb2TQx+UsXKwKk9Vrjmk0mDFNgpwx6qZggo1MOweqorCDE
         c+m646o/ygHI9h5+fJXJNzG6d81IidyhBVfUGTAPgtAm2Yz9qQZFv/ElJgT2T8+Ap5Xs
         Owyg==
X-Forwarded-Encrypted: i=1; AL+hErF8FoI+pFwZ/AA5NO1qqfOEgrELizWMHpCjsvM2YZpucsmsBnn1RPH0W7SObEWWv12mGubNkT2mtA==@kvack.org
X-Gm-Message-State: APuU4Z/v8d2XSfMldq53UwjAxXno+KZQs6ps3qzrzT51dqPtzAgDdV9k
	pEXrSN9BVLC8PzEB/V6Zkn9ebFIHL+FkriERqaBVpMzmrOtoWRK/eX8BAk1txOM/XEQ=
X-Gm-Gg: AZFdTZdy2hn7BUnCGfuJOLuv36bYrBYJ1XBvtKZ/kHI2/qqcfCnFy/pCxdhEXDgUqMw
	99WHGOmMwhgh+N4HxpS+MSglKcEu233AcukV9wJynQs1RKqahWiToca46DRjuQEZ7egtHXIoz7g
	A9J8UAK0lZ+zvXUJTDvPEta5nLqw5bOn0Ls51wQKOr9Ji1L+PZo7+28X9mOFAyQ2ugjshlzOx7j
	w4VEoRbiBT0DP24ywvS1J4co2WFvzr+WapldUz47tPrbjdmpqUjVHmoOetFxStnSmG2iABZoFpT
	M7MZRUctQJy2L+5Mom5eRLnJ5u0sTfJmgHC+0oeDd9GDVfm4wVD7x13R8Cw+Qye9hrZG+sWptPL
	RZ0cQ3naS5px+rpWrEFVK9kLpNslrOzg+CFFRwxbv7qq5MrTYJQ5xoETGR+PoXAyNIQifE+qJmt
	uNlY+6WPYzbAkKPg0G8HwQ7fTLkjdmm2GVlT7wPPeBZGHLWFaysZ0SnlNql8XnKbyXYFb8gS7xO
	HgGUtrYhv7hOrjStZZFCk7mmbu6jWGTtBex3ak8myLwoydOxFySXKlzr1b5ZdFbHQBKUDMx5DA5
	bmFAQIVe/t8khHX/q/hIWkvSn6NoytsQPjd5rTh2Pm7UYM/widWJdd/dmlZbDw1t
X-Received: by 2002:a05:6000:26c1:b0:4b3:b495:d5ad with SMTP id ffacd0b85a97d-4b3b495d6efmr9273447f8f.23.1795510347681;
        Tue, 24 Nov 2026 00:52:27 -0800 (PST)
Received: from localhost (109-81-82-199.rct.o2.cz. [109.81.82.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6bb989eesm26747447f8f.50.2026.11.24.00.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 00:52:27 -0800 (PST)
Date: Tue, 24 Nov 2026 09:52:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
Message-ID: <awVQShRRwF1IfEws@tiehlicka>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124020800.2313930-1-shakeel.butt@linux.dev>
X-Stat-Signature: icwfs6irr7z649mnyffd59gc599xa5ye
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 262BD140003
X-HE-Tag: 1795510348-318013
X-HE-Meta: U2FsdGVkX1+yjNlMfS8vNWGI5SM8HoY9cwWCjn5A4c3padQtbx+1uo1z0FLkAJHYwzW7Ec8oPWqVkW2QDazfEJ7na37KCKutrBpqmVTW9esp7Oe0KXSxUCKHF8Xndcj18pgLq8fAMTm8rjGs53F103SlPXKa60JJGW/+mn31q+x+hyFsrvIUOUXhWchRU+9e4Xdm3tAxZRS4/046Zgt21NdFpH3a0O3VwCNwxZ3p6VjK1NLyNUve3vwcgxTGKb6EGgzkmOiTt6uDVQ0aWc7unz1yqzTkMaoTsQxFQym7v5pg6PNmmKjd3GFQVT75ANiAgSB1yQ/qbA455LB5MQ4lNvKVt4Iy2ejNzk62YQU678qULwxvtE9lBcpnews1xPcgQkxJQZtP8CDwbCrCQjE6JyMYmuhpJf70JI8echNBwhAeEPOxGh2r4BTWCeSW6dO4VnqNkcA71XrUe0mVg6CStc3oync0gGKaDRk4AYaETl462kYoiaAFUWBztC+OArYZ2We/hSLCwYdK0U02We31WTF8WmZ63+y2NJRMuBXYcjpaYob1rQ2HXweDsLZvT8ye4LoC8mtd9jQ3BBDannsI2R4Sm115rysGyQboYHA/6KFBY4odlx306tQEdR/vuoVuq4gwwv6fDiSj4414vJ+y7w70KDy1XGVdNxXQWyq1Mae/68q5sKwl8sNj3awytf9RzTKzP8uxjcGdd65L/3Hxf6dXnVj5AjWKqwDA6lhKeBrCSjjAGnoLRCZG5BQg+HyLV3DMKUn8BF9u+fC4hU9iScKcPR5q5r3Wd4QL1pJ3P0ZWPp2EHymv46uhtky4xkPpER5sQClRwhgn+2JiZvBLb5+Ch5j4rTX7p+rfqbtnDKkJ9KTsy4EtXV4sPpGHuIZ5A0rnn6/eg/wvE/LP6vhuUqg7m987gbDOEHMAYgsno+MGP2mh0Sai178GzAMdVNFrGIn4ptan6LEvkzIeKuR
 ydHU6zIM
 v9w82Rvx0KinL1c/NNU7zHUkIjQt4yjjeFJdBcuAmczNip1mYF5SzKEs1fr/HNM12IYh5h1cDvqDyuf0BJntDdLA2Z/7ck685ugZphqSn6c5jrAit5cR9odTF39IVTSEApjGa5ejWyafT+eEm2pOEffGtOf3vQhhLo6jpleQV3h/7S1xheFSqb3DcN+mNX5DfEG73yrIPth05NXoLFeiKrdY/BtPNB+sUp8qtMdpfLrLnHgLXWtYkB1vzUSi1Ck8OshbWPh5EdQv+LhxUK5Gtw1dxJYDoInvDSyUCaF8sBSfXca5B1NHJq4PREJ3drMmMj9zf1mp/KWUQRMv8M9AchW7ai8Tw293qoZzs/CdNCVYm6OAVZuuEaIFgrchbX3n+TyZOiPq6CgULIdM2J9ePvXVlTRRPh8+ZBxYA3HqZy9JRp4GpJhG3xHSPsGQCIFi4ZCPfO2cZbjNAiOrwf2rXZBRaG/f+UXG1mr4sjIGnyWLcLUg6YktKRvhD7ib8Bv2/hvsj4WFHdHb209V10mDYX2imhlLT05brEw50N0H+OKbDkkDVWtcd70tcl0shrLs7vZezIQheOVfaBZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 23-11-26 18:08:00, Shakeel Butt wrote:
> Every memory cgroup gets a 16-bit private ID, so a host can have at most
> 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> as long as any swap slot still records it. On Meta hosts that create
> many short-lived cgroups, dead cgroups held this way filled the whole ID
> space. After that, every mkdir of a cgroup with the memory controller
> failed with -EBUSY: systemd could not start units, and container setup
> failed.
> 
> This was hard to see:
> 
> - Nothing is logged when the ID allocation fails. The only sign is
>   -EBUSY from mkdir.
> - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
>   objcg"), a dead memcg is freed even while swap still holds its ID. So
>   nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> 
> Print a rate limited warning when the ID allocation fails because all
> IDs are in use.

Not that I am against but isn't the issue clear by observing EBUSY from
mkdir?

-- 
Michal Hocko
SUSE Labs

