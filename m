Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2BE6C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B366B008C; Wed,  2 Sep 2026 00:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7238D6B0092; Wed,  2 Sep 2026 00:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6395E6B0095; Wed,  2 Sep 2026 00:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9246B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:05:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54F101A073F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:05:18 +0000 (UTC)
X-FDA: 85167482316.16.3780769
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9AC351C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:05:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gimvmxs5;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788321916;
	b=Htoo3x0TLmq2IBWh/SJ2x5AG7EXlrxkOnqCMc7TfuEEOHsqE4YsZYEvLvDkY5n7QthGXPw
	VCE7CfPv/B2DgXwedTETZLTxSj2OMBkbOX5csSgGqkchzNnLjvoYlBOm4BFc5WSHv2EKzO
	Uq3VPfe0yxEuWO7ePtx5U4SqjUsnshw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gimvmxs5;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788321916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sggsj0swIY6SNlhR5Rlr4w6l9mVN7Mj25L4G93WgJu0=;
	b=PelcFa1SBU3TmMP694iKqjIXpY9L4h7GaKKyqMujDc0a0PjltRz8LQemve88ELn+9q6e9g
	Q7bLkj415EGaxTlGpFMTc2Az2926auezSaifhv4BAkDJD7ISb+TH6g/h/sXdTc51cPEux0
	fE4NTFeRrhPKUk2LsSO9KaPuEUsS8+0=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-861feb6d61bso7918837b3.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 21:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788321916; x=1788926716; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sggsj0swIY6SNlhR5Rlr4w6l9mVN7Mj25L4G93WgJu0=;
        b=Gimvmxs5K+QuNv/52D1yG4gWNjPwDv0JBm1D0+BKuYhI2LBbv8cfVScD8WWVzKcs58
         g5nAvGVS2/Btyue8oJoaVegHWlkHMcWxmxfJ697R1CMLBf6BAyYmYL3F1oZMM+F8REdp
         9eyE4Jvn896rx1VNmXcK0Rxi8YtgAmoJyfy+O1YNvKrl2haA9jKeGtat0o6O293mTRjb
         oJ0IwsYpzaEGLHMh9PuezaqoUradGpSNXhHZ9bYgbTEgt87zdhkkdezO2bWrC6ToMXV2
         rkerTknohzwM9vOkN20qNFOJh9xdU+saJ05Mr/db4b/3+dBWKHB66mTr+2OUCaaccqCY
         Thzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788321916; x=1788926716;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sggsj0swIY6SNlhR5Rlr4w6l9mVN7Mj25L4G93WgJu0=;
        b=H4ck0QR7qbwmcxIiJFnMaL3pIFDTTE+7uop42u+yClNgIhh6roj7QWyaXTnwI2xHGJ
         n+d3TBbbzEN3vLpAONu8g9AtMErFtWrmOakMd3wA1PhPUODUqLKrjjHpR1AXzlCO39mU
         z2/+ZQ66A3nULWggD8GhNdt1PCs++nUtbA3we4pwLgiQl/pdiVyXbqF8x9HtBQfm7/4B
         ZHdNHRgZuBkrqec5aO/CuPK488jcJAFpyURrPg+//eEOe2PTv9oWulAz4LPJkM7kSsgr
         h495VIcsfw0KhF4IL8rYv36qJuTiKi1wkxYxEIVrznTRke0kTVqQX2oogumnmGY90O6S
         /9Bg==
X-Forwarded-Encrypted: i=1; AKwUvBxXcGpdAdpNEyHr/OLuYrAOYWMiReuGQeEgINKGi4LaEss5lcD7IFYCuc27yHmaagodBBCbLZsHjA==@kvack.org
X-Gm-Message-State: AFuF++nrTSaPjnV7aSr9l0ipIUmfGBly7EwTKL2WvYR3lnl7i303KToV
	Rt1xzP5Ypo1FFeG90LmaXQwLpRZ2ejsrJY8c7oipuiIpapPU9JGCDaQhUBZo6sZ9Ig==
X-Gm-Gg: AYBFou2WInh3Po/jgWD8HiM6nf89BNtr/I/C+eTGbFroyRJzP6Ar1lSU855LMEzEt+w
	9M7Vbs9pBKhVjK5QR8aAZ1fs69WF/lxL6XpR02x6m72fXjt2f8GdBY4sqqbVtqMcEpS6INaQpJT
	55L/LMnFJgKIAO+TJbXLukKaxeHpWS8pwc0736T/ctMxTjs8yBTKcpV0Q5JDbTJWJmLTUM6aCkl
	2zIkKKqg/oN0elPwyBzF5g/9GoKlDhgYB+oa7NhLFMprRTYVmsyNP7FmGq3cTm/hFDsCB8ALG18
	jU7Q9WwVcx4F1MlXcEkqtmkkZW/DoSYJXvKZShmvGA32qe279+Xj4GWBgH6RmpKduXc+b1dyVXy
	IcItZS8UN632FEdFfIDe1+m68Wt9GYU2WdktVUgx1pXJ3XKbhOyVvpxy3ElBr88PGa1IcqJqd77
	ixeLYStnKgNcgbSKn9EV7xRJcHcti44ma0q384gZs6tOjhLCh1YJub/0JKN27Uvy/8I9uhOUfd7
	4sLKre1EZD/dycbPcCYwCQLIpjkOsxRzjJ6T8eCSD2h4Vvn
X-Received: by 2002:a05:690c:81:b0:80b:9f4e:a70 with SMTP id 00721157ae682-86c526f66dfmr8698707b3.26.1788321915018;
        Tue, 01 Sep 2026 21:05:15 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c1975dd91sm8720547b3.49.2026.09.01.21.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 21:05:14 -0700 (PDT)
Date: Tue, 1 Sep 2026 21:05:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Subject: Re: [PATCH 04/25] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
In-Reply-To: <e0887417-85a7-453e-e733-561dc11db08f@google.com>
Message-ID: <04101fb5-a723-1fe0-37ee-5e62b5fbb9d7@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <e0887417-85a7-453e-e733-561dc11db08f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: d6rpdptceiq8en54s9w5wh8ts3tfwapw
X-Rspamd-Queue-Id: 9AC351C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788321916-580037
X-HE-Meta: U2FsdGVkX1/aInOzapA+OhJeLCp17lZDTY9dmln3MQdHOd8YByyp641YiKTYWxydDTdXCKXY3W+UUpFSe74sTtfmFpULjhZxhMxsgUqM/WJtw8ZVB08L9tfha9W4IravrrSCzkvZvT+5Gugmlr/09SR5yKb1sb/LJyju6kQjZea0eAwILi/jsefVsSlXWEImZb2HTe6phubXQ52BbAT38QhQK3yHmUnTsbvG2idHqDEXZprJ9kMIZoLPpIgZtDnDEGs15J4pTY6yNmuCDXucaMpcIU0vuktFnbE4bV6ZnQpZlUNuD4tRIngw88Hrbys51w2AWqC8UDUq2/8CKtmylyJrSx5IoiYn75mhFNRILrMlQHO9lbOJPoCmyYOVxJ7rY3FnmvB9V1IM32n1SoQQCGsiBrIL1kl9inNnx25g+1fl6ftc/V7Q9FQ2sw/li/hvLZDf5tNB1fNZxB6UGDPxmBHTN5kD7QWJUHXLUu26+fvJ+uK9TPUT7YdiUGYQFVnIg4p+/YjkSzxBBAfhjCQtuCRfiF3zsx4Zy5e8zxf9Gb5VqREaKXYN56jhyNNK0I8hMp7lYo42lpFGS5Crc0A2wu3D9eItjsok8e2urPQG92N52SCBBB/l2cWVq2vU9uBNmLsBBOiOqC/+68qpX5AkK3Bdw4OWqvayFxM4tNllrCt/wFkHO6ZTneeBJu6I/keE/ua3CRXuxTuJTfmshKtbHMmF0oZz61rWzi0/oyG6V60monKqSwpjroxxB9AqRDFs/lRU30BVaWWR7VolD3s50raCdFGkF6DJ/BLOE2Y7SeAiKomUOhtjZ5craFBih4945JvBALo2mRbVDFknT87LJ0CF8SKxrkvFpBJDRZWuq7R/upbQxt7+wA8yB6KKiKGZ7bIn6dsZYQ4fAN8swWGNUfHdISdlWgrM3o3SQRmwvm2NEVKUPxhCCKc85svp7vSo0Jk8I8FsrI1alwjw3df
 sCBX+bpl
 dpnscVjS4JORZw9iyTsTtC0xR/9XVMlC7A+AsRZS1pIptFSwpLuuA6QFKqbGRqDSWsKn+WTFlhI1P8ZKP8tN8s3PLLnY5lAGZsV6D3bA/4FOsgiWJdz1oIbWiZmoqB8Ge9xNWXbJw1bjkGAPsuEpmWa/2Hp2Pv/21UD+9YXrqO70skmi6NhPtYMcJIAzkFk0UIQF4WV2W321hNnpRIXTzY5Iu1zzImALSm68Mv3zjaIBRpQtm7IojwVUwbCNwAXVgvF7xd4fV7RvLjXJi28flAYnz6XctC/w0G/ow/S80ZiPrLomIPqbaX6rMLbt4cnCiS1z6exgyoHWaT3E6ct5xDHjtMTjVfNcpMMW+VwELo1Jzg5tK2Tl2VGg8vSJbmr3r1VK7XRwWX3KX/1/5uBoSmeEoJUxf0WJn2acSu37M6dR++2mjCASXpGVRag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026, Hugh Dickins wrote:
...
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -343,6 +343,23 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
>  }
>  #endif /* CONFIG_LRU_GEN */
>  
> +enum {
> +	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
> +	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
> +	NR_LRU_NEXT_FLAGS
> +};
> +
> +static __always_inline
> +bool lru_add_del_folio(struct folio *folio)
> +{
> +	/* BUG_ON(folio_test_lru(folio)); */

That was a good statement of intent, but clearly I never booted
a system with that BUG_ON uncommented: it actually needs to say
	/* BUG_ON(folio_test_lru(folio) && folio_ref_count(folio)); */
because once the refcount is 0, __page_cache_release() chooses to
lruvec_del_folio() before non-atomically clearing lru flags.
To be fixed when respun.

> +	if (!(folio->lru_next & BIT(LRU_NEXT_BATCHED)))
> +		return false;
> +	folio->lru.next = LIST_POISON1;
> +	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
> +	return true;
> +}
...

