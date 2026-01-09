Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF17D232DC
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 05:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FBA86B0088; Fri,  9 Jan 2026 00:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9C96B0089; Fri,  9 Jan 2026 00:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58B916B008A; Fri,  9 Jan 2026 00:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48C256B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:17:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D24FE1AC33
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:17:28 +0000 (UTC)
X-FDA: 84311267376.01.5BF8F23
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id F1AAB40009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:17:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mDl46hoo;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767935847; a=rsa-sha256;
	cv=none;
	b=RM1olCIkP/C9TWREF+SBzJL1NGEuORbZ6Iin/oWsHL9k22duQxQwCw3XbK5oext+9wemKU
	UJTtwovnJeahakshjIhTqC4ix7ntsiP2PywrH0trCyvSsU1sfcX9mvhqRcAvAxavI3AQfR
	9EMkVYEj5lz5VusJS1bN7PCgY37Erlk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mDl46hoo;
	spf=pass (imf11.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767935847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUdR4J2NcEwRabitt5lFfdi3Imf8JYD/I9QAXQ0Qcts=;
	b=vyJ91IgTmp7psfeERy1RNnCbzH3tQ60y8TSRQszMhknZTyEVLF/RLcSvCTyXIqeCKXNGHE
	TQN0j376NRDmyWAIn3Wpp4WQCLlhUiLmcm2hk+QI+tGSgj6882UwzNLrreJnTxU/fiEMh4
	m3tAs0lexLOaPN6zb1ERiFbTBwjWvoo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a099233e8dso28823915ad.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 21:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767935846; x=1768540646; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WUdR4J2NcEwRabitt5lFfdi3Imf8JYD/I9QAXQ0Qcts=;
        b=mDl46hooQP2SVIFWyG6yj9z/w4G6isWxUgKhfbWSJRuqeqmJ/AMBXXkv9S6e/Q+5lh
         q+hnrXF3QfTviMkhR7ecsCqxg+RiMNyXiu3QGmj4te5Rsk+vPzaPyXJUbX9t7s30hKxC
         7ShUk5d7+qH+PLGuNM/1c+24uImSmxy43HN3Z0ERbosMySsew+BOly59XHiqAy6vE1FW
         CWB3t8OvpGlQkPpxA/WPN+8Kkq7eA8Fe9fRShkFPpCPUVGKTUy1D4Bm/WVZkqf+9W88e
         WicHH2L9jbKCXw/wZe5g90kAQfGIcdtjkYA6+wSpBs+C2pwYedTwUxaH//cgWg9hlKIZ
         bfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767935846; x=1768540646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUdR4J2NcEwRabitt5lFfdi3Imf8JYD/I9QAXQ0Qcts=;
        b=WjGIq4kYQetT9FibEVk8vs3jNEHmfXFTivWsiv+Lu1sBRWDBWcxdxhZWEDtIDfCMKS
         cvsDMjuOxSdvTgDKDUruz1s5Phbg/cgGAzX5736IKuNR2niU+wVVLZXYoCls6FYoOChv
         X3qOzglwzkaHxqXvjMQCEVxfEC3Bk62t2RxmCQNi0GmuXbMOuXBh/6kljhoOwcZs3pb2
         7qF6jkCKhbxmaIoNkYAYqlyKLxm7tfTX1+KUfODKUoh8f0YrHdFqiY3Q/Epk/cEjU6/g
         Eh2xuhxSeawlM9nqUs5F8iIW0li0t4HXtZW7sfZnopteVO2iR5Uux3uE2I0lnYk69MST
         f9OQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEZ86zSt7S8jOVMlLmA+xOhCywGTx0Fj4SAlKi+bWbea50+pwyBRQRUh0sxZWEmtcBNkQTJSHSRw==@kvack.org
X-Gm-Message-State: AOJu0Yz5NWNaWvmLLDZc/+au39BvXjQyRbgF4qkIfrdkX3L32TBINeC+
	io0osDCydUvvw+r2iQbxCXx7Tqm+2GvF/5TyNHuPGChDBQLb99NjX0At
X-Gm-Gg: AY/fxX58yPfVgn/uD0H5wpA6AB7rY3Q8MiPqRGcl6OjlARWvDKrbmWmoOFBR6c5tldm
	VgSgQxR94RHqVdtOfUQBSliLpk2i+q/A6fOjrM5gtdXjCz5/KTAIxpga866g/zS9COISChCa2b2
	8XN1tL6mh3xfXAqmZo9FhL+lOYxFewWC7fglBQMDHFeF5lFXYkw/GqmUR/NBZ/0PbkkIvA+BlsJ
	LPaaOjg+EsX7/X+i0fzWOfJOlYpAtxJekBzFDXXHBSPqJG692VZSKKNpNGE4/H15Jv/YeqpjKsZ
	msI800f1z7PFACia/1QpqPBzSs6PT2Ib5a8Od1HfknPhHW0Z+/lOPb/tkj0mieYffvrhHHUCzZy
	RfZy0D4faiTH5cHXEyt0sXF858oeN9d9n3XFGSAc37OI/bophp5B9wOKYBEQEbFY8pfrVVBpUtv
	HCSG8=
X-Google-Smtp-Source: AGHT+IFtYDJf2r2F0XZHmYKqp0iQiXW5S1YwUq9AbEmuZXrtS5/mtv+bWO+/b2KsmnDWRU8bOawHkA==
X-Received: by 2002:a17:903:3504:b0:2a0:c58b:ed6 with SMTP id d9443c01a7336-2a3ee48fcc5mr85152645ad.29.1767935845695;
        Thu, 08 Jan 2026 21:17:25 -0800 (PST)
Received: from localhost ([2a12:a304:100::205b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c4796asm94372225ad.34.2026.01.08.21.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 21:17:25 -0800 (PST)
Date: Fri, 9 Jan 2026 13:17:21 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
Message-ID: <aWCPQKQk-nTKJwFZ@ndev>
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
 <aWB-vt6VUJ6fQPcC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWB-vt6VUJ6fQPcC@casper.infradead.org>
X-Stat-Signature: 3wqombnc7sthntqu9o4smdhbjg49bm76
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1AAB40009
X-Rspam-User: 
X-HE-Tag: 1767935846-958220
X-HE-Meta: U2FsdGVkX1+tacUZn3qqp57EQYDP2lNx/vjh4OfGfDE5m6cyJAQDgKUPlrH7kUYKPCQH+9GRzyto9FidTK3nBg5L1zOhq8WOIv4AaMI7t0Pz3VQTocogNY74smMgJsTmEzBpXcb1k1oeZU9c0gfVqnNtPFzRsm/RCLkKRAIIcsodNxelTVVKdKJCLOupLPfkqEAaMGgHHtnfzr8GAWt40MqUqxFUi79lbxjRX3aBKU74wu6Ni7B6RdMKMhkrlvxWPJi1BDSF57VmNPdveB6Nb7xOJluuCXl79xjg07NjwfIVseM1ze2YG2Oxt4U7Uq6MFjVkGyuGSGgbUqevL2MXq26jDEXndfNPYWKaK1Q8i1PSmA+3EMOtDKDoxru7xqoHmHJudtmw5WO0Sj8vCrvoEtP8tj6xMsERvf6r23vYisChQt15wQvXL1uGK+E8v7GjlF/teOx4Iqp5k85pUzVt1xIAxGgYYeLIYjTugY/Ws4KI1gmVBsgvka8mkksicd7YaW/kEAb4YBpfSAPv39iyL25fEdaqZdRRwudCiGor5EzmewDsb4g18Bqbd5mZdXKQ4Xf+mxoxMuybDlQPVxUQEEg7jJYjR6uMNCpT1YM+Q0FvCZ9Q7QtRM0rQKV04G5z4gDcQ8HjUk6eNGCtjGmxKyuy9NQtZEOCjc6UgsNTTl+U5IwfAUpw314ao35wknv6O9SIoUgFvPGpveC1a4i3s2C0BWEhC1vF6KAOyPgnCncCfgGoGdQHcwcEatPG++mR4UyTMiHvLW9FwrURtrhHWTCky6pWeQHlYXdISckAyrEbeJSIuS4rWwp5raiygcRR23EmOlQNVmxedaVQ+JohiBBDiSHLv8uRlV1ot64bEgY9kGuhQ2aiPZf40F6W+atu54sxAPnJFxKHZ1Q04sq3vGLPV2K4E+tpSeoOdI8NGfe4XViEf+8C8fFxSveK1XDeLUF/Q2nnb/izgwV3W2JT
 awQK4Sv+
 7LTXSuBDlBUt3qBNGtU/3lOw4DrR8aUyNrT1+CH9Hz0Qh8n/ji0DlmzvzjZ2ctrvpKTRzBa+mKJKqTB5pAfz6niL8zgCMnWpwxRAHE7GQ36Ba6eS8AeTMloM2euKrNmgr/UEL8IGQl7y9Qp78R2rZwWJzk2WIDegVXrulE0oa2ZQK5Oyw4tU7Dzii6KP9YNBmra3VXCbVdmNW6oh66qmnH7f/WUW9CFGMMdSWnJzDxFs0mUbYYbM1oPILufylf3zlwdTSkpxhGvtkmCQ1iVP1IUPXsKCQkUlNYMdfXQmKPse9dj7LxsxhzKr92xoELbbBJFDe8LghdeOLFGfh3iRjuJlGzcGxp5ZT/t9ftJ0M5pWZoG06HbNAo77nsdwzXtiod9ugkdJT8qUjyG1uKhj+xIBsTUdjyt9aJz4AoQnrrtcAFJu2xEWK9egQW0lLHhAiGyE0l2GFGtqjPVgs0KYOwDuKW6yksqZDlHP6oQg+bKZY0UGH9VgsDgvA5U9kngAI/VfGSINvmgfA0GNbHbDicETg9s6Bx+BmAnr0+pJdnD6l7KpgIYFNFn8MkGF5OCB9r8Au7sVxO4PO66mKd43lFYeQEDgA1Nikb63HLlTkpHAETtIFqSANTo7emWUh41VeEq4J9tpZF6QWo+0tmVMSisCzKnjouEWS1gXyZ0oG7fba7RtX38fC7snHQONPssYfjzYwcbkeSIc1xk0aHv8B6X5KTA313jqwMcX2CS+6fgUAPkq6ahOGHbvUF9alVmeTVVJ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:06:22AM +0000, Matthew Wilcox wrote:
> On Fri, Jan 09, 2026 at 11:47:16AM +0800, Jinchao Wang wrote:
> > Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com/
> > Link: https://lore.kernel.org/all/20260108123957.1123502-2-wangjinchao600@gmail.com
> > Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> 
> ... and by "Suggested-by", you mean "completely written by", right?
> 
> Or did you change it in some way?

Yes, it is completely written by you. I verified it against the syzkaller
reproducer and reviewed the code logic.

If you prefer, I am happy to update the attribution, for example by replacing
Suggested-by with Co-developed-by, or by listing you as the author instead.  I
can also drop my patch if that is more appropriate.

Please let me know what you prefer.

Thanks.

