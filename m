Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9844C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63096B0193; Mon, 17 Aug 2026 23:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B3A6B071B; Mon, 17 Aug 2026 23:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50806B08CB; Mon, 17 Aug 2026 23:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF1E6B0193
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:12:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 862241A0A91
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:12:46 +0000 (UTC)
X-FDA: 85112917932.25.693EA89
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB3BFA0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:12:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="Nw5I/gd9";
	spf=pass (imf25.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.171 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787022764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMP8Ja3+ZNELH3tfUgGHoK2S1Rf6V+67czaj+c/eO7A=;
	b=NMqLgaBIO7O+2qLSmk7FKYc1Q0/sp46HrAcZuVEszYJcrpe2uRo6cnrlrvbrg+qA3Dampk
	fiGDJqmhLcbAdEhmaZwSRAABgwFpn4ovzVnBPS3ascN+Cweo99ZRlHHXek7b0VpvbCnIpt
	6kxqa+u4rTj9Zf46Pl6xARSM7FtCkcE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="Nw5I/gd9";
	spf=pass (imf25.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.171 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787022764;
	b=tvFktEsMOq1wOxUTrE/Lixy6d74j752LZKwDa5vLISmI2PZXn0Jy3fbgAfLVCnMVgvxKC8
	ULQ6ONvWe6S7k/yDHBHxgDPmyUof/tQjyHwn2MwK0R/rLhbVEYDnBf8SKzdpKheCIs2svn
	3qZ16AYe4yi0ng/RfHSUO1iERbcL6Jk=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92ed3993c1eso219116485a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1787022764; x=1787627564; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hMP8Ja3+ZNELH3tfUgGHoK2S1Rf6V+67czaj+c/eO7A=;
        b=Nw5I/gd9vN6zd+oexKhsO1DlL11Hwhmfzqfl4IEjwLmxF4be43Gd2uVw34ejv83Vy6
         EOEI7l6p+hvSdKC/H17FuHzxbhUvDQvpBrtlsd1bHHQ+DuwRzs6ofnlhE1R8cUWpnyJV
         CHfoNVe3sg5jC+lz55lHElJujQoTXnV21HdjlpM/ABNnsNKmNRC5/2t4My8JDa1F41pY
         Jh2vUKEJzoiB43MPfbGROlHMb+RAPAcRs56qbecToxrb+sBColKjax9NKEXng4JQ/FH/
         rDf2n/LpCNcsbr5ecE5Z6pxTE0B6i0+b4aJDu2EnmSP/Nx8KW9uMG1TmU5HbJ+utxQ3o
         Aplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787022764; x=1787627564;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hMP8Ja3+ZNELH3tfUgGHoK2S1Rf6V+67czaj+c/eO7A=;
        b=qiNK87zoRNutdbtaaL2VVSxJrkZVIh/IBofX/FZ3WD32WRkrUbEB+rYxnGuflK/InI
         wgxHN5hXVR3xXSRgcJ2rT9M9D+DSB5xFmAzxsxZ/QHnC4CwrzXHwNJZnonOGPelra0ap
         8/NUTEJmEI3E6UYYyIhnvL59g9pZUCXB+hdEzVo/dP889FUptvDixnGIqpktA3rEQt58
         O0De+Y2rc5ox0GIwS1sGMMR/j3MfpsHz7z0RveKX57FlWU7fdmHZAvnuKVdSnA4Ui/UQ
         e06HJ5g8zbaqeg+cFCvh4X0QsYkmoSK+Uupong4BTv8SH/XTPgSGqLUMVC2YKVBVa2kP
         tw1Q==
X-Forwarded-Encrypted: i=1; AHgh+RooZAaDVJ9y8L+h/nuFTNf5+L5Oqd0tZbnkqf/Ps+Es1XhKOAbXauo4LFNRY/nylt4uBIHb6D31ew==@kvack.org
X-Gm-Message-State: AOJu0YwWTBF9GRLFbk1om1klNZgVaU5R3oSGibvNhbeLkRl2kwASkeQT
	wkptPPWWCEMO2IW06tFuqRVXt6XxQ/h16VXRDj0pB6aK+0Z/bZrErJVlTHjvG5fI+w==
X-Gm-Gg: AR+sD10SMe1HS2LPe74g+CD6euzJwYXcB2Zt2QW+ct0t/0O9mGPNjYptxBwMOyedG8j
	TBUk0TuGy83SSGPsjp8KiSCrol8OvSZdXgMR5wungooi4Vfk63P8vC5XbNUAx73BqX08MIMKHDI
	uIvNJyJQzvMjWbSgheeL7bokL0lvL+ORXJM3CCcBZVnGMvfCrS+p/1EnsvE4XQnilLZ8kEIBZ+i
	lckJ8EVjfFY0hNLKBJSAxBcAYmaBc/GSf2wJjOqL/8svmB4X4i8pEbvOf712/UJw6O35RMuXhDd
	wji54zlht3/2MjW/EyLxTMg3UtOuErHKnrUSWIbO7cHZS1hA9MBRTRAUdslViMR3fqqeXkEyj61
	cemBoSykWWUuh4G/ahk+NeqwL/z/RyxsnGbzWkKHM46KBTc5s6DxRvDPekEsWnrsiNMhPrQAg5h
	DVcwR7LUhkpepuLoLAu/qKcgqbyxdmjLcB82lVresy1cEQ6rL2I4ux0f4J4zPhrw==
X-Received: by 2002:a05:620a:a1d4:b0:936:9db3:b82 with SMTP id af79cd13be357-936d22e9eafmr2865871585a.31.1787022763675;
        Mon, 17 Aug 2026 20:12:43 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033cf47asm191170785a.26.2026.08.17.20.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:12:43 -0700 (PDT)
Date: Mon, 17 Aug 2026 23:12:39 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <15b086cc-7f10-4766-9b0c-88c3302e7398@rowland.harvard.edu>
References: <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
 <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
 <7deabd9c-04d5-4a45-8b8a-39929c046152@rowland.harvard.edu>
 <A2BA0883-6B5D-4AB1-A7CF-6B9BDF27F439@nvidia.com>
 <2bf01548-723c-465d-8368-247a814f61eb@rowland.harvard.edu>
 <6FC11E12-9428-4975-B135-E24805C2D9BF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6FC11E12-9428-4975-B135-E24805C2D9BF@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB3BFA0004
X-Stat-Signature: 8zh7yq1j4nkeu93dpsfp9ykh7rtd9ts8
X-Rspam-User: 
X-HE-Tag: 1787022764-26779
X-HE-Meta: U2FsdGVkX18BZ6NK37/p/YYpP16NPKphWZ772vJlfoJTjcWmAcXL2t7UJi9WY96XyAnMjDFyFLUstOOTAw2vo0h8vCbunQr+QDB0ED8THzn9FtNM675gxe6nYZCOYkt8M04COONf2vxRX/bcy5YiKR4cfmynxig+qddhNA33PzM0iFka65VNtbyhEBEUtQOJFdpKmmUnGWzzgX7q2SKA/5AXYn/Xyq6fL+zypY08p1ZiwRl203NJagtLCd1HMyOR+dD99mKZcNGJmDCkzFCt3K9j3jUSopprhP37GYow3CubznMKo3Nxt6Q8HY+IIstIkohzYKUXJ1l2lQNmAK937vRZu4siCW3sW0VtSUsv/nbp9y+n4u8Wiu4FEW5U3ab5+QhZq1JPBCxUpVQ1IrzUtcvEYb+NllyLoteoiozPgxQDhK/FymQFHZCnF9PGFqcY8pHPkGTJp3+shghiYo/NosdQF/p46T/PJfpXo/zJSgcCyL378fuWycFSe3ZW4F99QAm1RKIaeicyEtlAebEY5iu9r+w7URiwQfNkQI8ePCPQHuXa18TfJhUYlqqnA/FUzdQL3jO6hGzo54TZZhAHWTVJKTzUWl9zvz9SRekokpecxiWJIWKTSLbu+19lgYXaVy/5BoPj5uDl1lH/Ga/EDWuW3sW5x5l5IzJi6INjCfGZrG66w/f92EyJ4aAJXS81b6q3/UDuGSxTy9ufMNoAD66TRqZNVuNa9N4lUJ7BUbJ76feHSIdMhuplGfn2kICgwSiLg2JQhC2xl3Cl4csoyot52wF2jmNlPEhr9vXqJ68T3QAkvERZbDkH96W45AyfLVE+JO1tJeLVDa+be6rnf0WnGxMN5Oh5XAk7Ud1x44iNg38Odj7o0kLSGUt0q8i8Mi0nhknrECjlM+hh3XcgT0/DPqib2P33d7+OKKE6zc24kRjUifSJh6vadRBLPWEWLCAqqNJJpsNN8IHjlVZ
 Gc0/E7RA
 k3pTH+JXQoBJWMQ9yCUPGgcgNggfnkLcS1Sh9TzfgPgnAXrjC+B4H5h/k7NrvZXhIZRJLTCODjTtiyuf1rlcV3imODhXD3M2l86Ue86jDxs6Rl499VTtNu88eS9U0MPEPZsIWLGP7OMx/omsoufB70GYI1v5q9xtw1AZRTDOij8X3ho4w1NFN7INksj0FKXIpSEONZM8bLtgMewQbRMXTQQ4jd6VsJqiJ+p1upMZ6cJuY+tuooLMj5nchPbK5gKY6GVgg2vwNXh65EuVTEUEZjX5m6WX8o7n7YEnB+onFtiBH7U4fmNZhdMwQQaAv0JkC280ngDj1f8NGVzGPHl1rC+0UQ1B9NIHiYE+GLviqyNe+xZ3ZycA3bqNWj4oYqBnv2Ks7az2W0woD5dc42gfNHACUhMb9IvTJZEMk32OPeFfEFCkBK+2iaD+XHVokZVODxOErT6ger2B0IUvvMdJ4/r9lNRv8wRqchAL4/SQVH0OqLOXD1vf3+UaAbQnxQc+yHbxZxxyc3eodGnmcRLyKxB0Im5gvREf6sxp3DDmznKH588vAX0ReEJblq7Akfm9T4o6ZzCjuIrLjKT8EbCljXDwFdl9pvjTZL4Cz+gY637WqMZEGPeOyh5PDH6CZ+X7cuV1S8BweO2UME5vZg5c5Lq7w00N/PdmKcf5VmCeocIcRE9UyA1InLjuXaB4QUlhilNa2bIrIt2RjNT6wgXOu09xIp/MonM09w2ooTqpzj/Lx7vDZX0KztvK5rm2ou/Aey48zJ7Q7DAQ3GQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 02:45:19PM -0400, Zi Yan wrote:
> On 17 Aug 2026, at 11:37, Alan Stern wrote:
> >>> Regardless, if it is important to let kernel developers know that their
> >>> code is doing something wrong, why not make the WARN conditional on
> >>> CONFIG_EXPERT or something similar?  In other words, prevent it from
> >>> crashing production systems.
> >
> > You didn't respond to this.
> 
> I do not get your argument here. Why does this WARN need to be conditional
> on CONFIG_EXPERT? What makes it special? Or you mean you want all WARNs
> to be conditional CONFIG_EXPERT?

This may be a moot point now, but I'll answer the questions anyway.

This WARN should be conditional on something indicating that the kernel 
is meant for testing rather than production (not necessarily 
CONFIG_EXPERT but something like it) because it does not indicate that 
an operation has failed badly enough to leave the kernel in a 
dangerously unstable state.  Rather, it indicates that a programmer has 
tried to do something that can't possibly succeed.  The result should 
not be dangerous because the caller should always check kmalloc()'s 
return value.  If the caller is unable to recover from a memory 
allocation failure then it is the caller's responsibility to WARN, not 
kmalloc()'s.

The same is true for all other WARN statements.  If they merely indicate 
a programming infelicity and not a dangerous failure then they should 
not fire in production kernels.

Alan Stern

