Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD656CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 03:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9626B008A; Fri,  2 Oct 2026 23:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9CD6B008C; Fri,  2 Oct 2026 23:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598C16B0092; Fri,  2 Oct 2026 23:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36AF56B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:31:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 259811A08CA
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:31:18 +0000 (UTC)
X-FDA: 85279889436.27.1BFB056
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3ECF4140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 03:31:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Mbb9tg7x;
	spf=pass (imf09.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790998276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97uawHidSB1rYodKjDdjsSlDXIsf2v1irs/NqM+eBxk=;
	b=mi+Th2oYYQOYQc4c0gFdn3dWpTRqElEHsRIhJcs5CXX/TA3xDXMqhABIkK6glqDqLFK4GP
	z/jmXzNmfi0GY1eUTWWmqIDCedeBKe6CIL7xeC/OmsV/7RoHNe3ulxQkLXH/kFXkffl7xZ
	49+E1M7f0B3udOgmPnIhm6dDFEHPcjc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Mbb9tg7x;
	spf=pass (imf09.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790998276;
	b=twZCl81AnR3w3y0e8TOUGEW4O7wxvdlZOPQR8/H/0Rtd6VMp8apB55sbqpi42PNnPKSOM9
	GgIkJIiUSjOSh61eajuA28YODkXF7k9YwU85mPCnDs8oSx/cEGRpgR6WCd8X8tUTHMvr/J
	gPS6fTqCfHWX+dM2u21xyJCmrZXNbtg=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a2adb9bc3cso16054a91.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 20:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790998275; x=1791603075; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=97uawHidSB1rYodKjDdjsSlDXIsf2v1irs/NqM+eBxk=;
        b=Mbb9tg7xmMWVC2P9OHbqXuwN3YmibcxXcu5yPcVjyhPHjdDguT6txJwyOlCFO0c9jp
         bsxkEr8IPSr0CCIcvlrSv6qBzCNTl99dGt3F/96VbXnZK1lGFFZV6rJP4/4flsT5PTZx
         wJGk1vyqTzECH7Fq8CWT7M7T4yYq3P76W+JqYYA5bpcS64v4/gmD9nwOerHFaJ3E3SdU
         7bi/KjyQfupfSJtSO6ObF4FEKGLuh7uHU389EfdQ/IqJ79FCHfZY22JFz1p18XB/AwnQ
         NMNGzBZk/Q3kdGdauU36UbLNriYKFxfRpVFEodkcEi5yZgR1dyjsgQfvD/yuNkw1tLFb
         d2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790998275; x=1791603075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=97uawHidSB1rYodKjDdjsSlDXIsf2v1irs/NqM+eBxk=;
        b=FRIdcEHZeNM9/xIT7LYCo8KlzlsidII1Zg1wxX5niQClbSEBGWXXIYbBZe3m+X7BzN
         FGijFBuUCYu8/nYdjMC8b6Kg2hhOXpBl/LyC1/OHQ6KsDM4ZkgNuXkXeOxiDGlP7qPvU
         uzP7rxdyIJ7zEVmyI3ll+4yoNn2d5EI/3uywjSJ0ES8tYS52Yxc0B9B9g4icBdVjAv5F
         N/jjDAdLlS0kZwPS27OH/vlnRDesmVs27g/CjPslp/reftDofNWoLzFKBFNbaMczaPqH
         Xf5zqK9Y7mz9jWwOI860UYJSZyS3G4BAdBHdB+K5NuiHlZs6cxNN6hDWPeuV5qE8uPAE
         TkpQ==
X-Forwarded-Encrypted: i=1; AKwUvBysoyWNabwlQQOVYApfooxcet4LvtOAOHcvCQbg7mh7f2+Kq5lrFdi01MOCwYCvxcrZ1NvnV65FcA==@kvack.org
X-Gm-Message-State: AFq9FYKBlRIryAV6fvPQ6AJEP0aprqw2vriJDTomiXvxichQsOoHK1t9
	H5isNJfqMEj9xa5L4Vzt3en3Qt59G+75+rmdRgjdkRdBNC+4nO694NHxivdN5TEm6jY=
X-Gm-Gg: AYBFou1y4pihC2pstv6Rg4uZGSjQEBEPvxCtPxHdtx2sC4vbvSQfG2H5spNB1/+vj0T
	dUXSTfIEZSojnk0aajSS28CbZnY/Xin6sZyQhJQIqNjm/bFyXNm+QDu+z3PcQkaITkfulOPXrAR
	bMN+fvxLRNKbQLpFsmAL0Vd3GjrIJQBaPB2+LWINUdd2qkGVa59ElRZ3P7tsSW3BJcDSJnj8w2z
	OwBjd874RtJ8ZYl0/anO/vyi5Tp7dcAIp5W3+c6LkK7Qw6mPZkFthCfcMSZJ80LYc81jYmVbWpw
	7PDx9bTDTVH26fFomNZ6FNMuZRunoyu2j60iKdnNArjIhma7X/XNVhaAri2a3BHLC/nxUMt0ONz
	Vpnfk2i1jVFJuLBF55LBIXrSPkow2ZHWpJsqm4ghZCV/dVTyt51NmPJlMASQyTNHiZll0P3b48N
	4D+yxiw0r45/a5kJSIt0moLrd5whIYeKKI4CNC72YvNRX2CbdAGN/x2Sw29flC1bRS8+syzT5Jr
	IGmwee6puRgJop3knej+5EQVvqH1znMFEb5vNYA2Di7OzlrgmvcBIhJhfARkTYObEgpH9N0tTXU
	M7zI9MTNKQ28WB/yx/he3ut9MWXzNo4o1D/v2Q==
X-Received: by 2002:a17:90a:fc47:b0:3a4:a3cb:9c8e with SMTP id 98e67ed59e1d1-3a6ce7f243fmr1649986a91.38.1790998274745;
        Fri, 02 Oct 2026 20:31:14 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78e4f3911sm1184151a91.15.2026.10.02.20.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 20:31:14 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Sat,  3 Oct 2026 03:31:03 +0000
Message-ID: <20261003033107.1488699-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260925065013.3682431-1-ayushr@modal.com>
References: <20260924061708.1645968-1-ayushr@modal.com> <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net> <20260925053027.1998394-1-ayushr@modal.com> <20260925065013.3682431-1-ayushr@modal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hrgojt6xiz8qx4qb834odegn44jpkumi
X-Rspamd-Queue-Id: 3ECF4140003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790998276-763735
X-HE-Meta: U2FsdGVkX1+1T3UVbBpWYr1vOokjZfY/Syas9mUTCyeDpTahIw36qSA/atN/CJ+s5jvAnxUvD5/RoWQZy5c1Jl98PoSpmWIeK/qIvxe2JvcTUuN3aAjlo4wldpoOlu/TcPN46d9SObkI077kpBj3ghUDvhs/N0HiVhs4H7y4yzR+hCF2QQk6gEIDPtVjlXd2yDIqL2g/g3bCMc0ALxnLvyXLOOLQ9Np+rJEPt61Dgd7XGR9gtn0spB3gtzeV8owqzEihuDRzytD3eh95yhCqwhoSBTA8GHGtsPN4DngxAZAG8HdpEiY4c8W7skkvkmOPadeV/r2soa+G5bbi8H8YsaNT9wz0B8PbFJ0QBSzuPOBJGybgoFWfSTUUGs9+x2fpqrsxXylBNHD/FwIUtvAncmVvWl2XkzsT5s5qOarvP8Y3phMyX/F3JoMKhBW4UO3Z7NC/e0JfVomoZZXfiNytewsRjYuhsAgnFhgiiI1jwtqWzCoqTmnZiku9WZq7dA/z1flXbwyV4clOy6H4KjviBPCz/v6t/flDmUDfZpsWZygNl9NC1WD+/e3OJl0k0PLSGKLUtc5jdTeVJY67cqmzVtC7gJM819NsfX30TaW+N9mDTEJCGS/D0a8ITBMejXgacBhqWxFxpud+nActL8j4he2UQYgdGf1kcNcZDmso0JQx1/I2X9LtfUpF+uvrlcodGP+OrJgLLXZuw7AwnrsfsLzdGcipVvu73hiAglrj3hjgIHZEZAipVTxebggeegmvSZ1eQEF5P92+Lds7BQqca6EU1HLV/5OwWVC5XkbmtYwn95HzUT6YRLedN4B4M6qf4ZCMWBaMzAtCVwnZUhTiRcmQqTmx/Pq73tYBXQYVAQ4fS1svv1MtBvp4gcvNyyO+ziZQS5QU31zOuRprN6soEyQGVd0DgRiN4f4kgileOg/eXeCkwDV9SD0JSeHuf+eNXnrNfp7i2/8jfRjcEoH
 aZ2DZL8K
 QUrbX5yBroE53LJOOsDrkWcQ3RJDgmVlcc3MAz1WvDMDC+9hr0NsLiy6MqlxIifaPqwinnnQzW/r3UYav6OHB4GPnNiswiHElrEapPBmkwGQ6DOtcpg1e8Irw+Yf8eAjv0GXtP/RkpC1QoCVAwxBLHetfxAztCxbt7oqZryGwjKmd/4tsIJSikjav4kUL5rhjcXPzQ1HKscH4LS3wWI9bsSY6hLSZeLqUmoHrS6CKD+IZJPsUoCR0+Mrc7jRj9k/lXgkTQFWt40w7O0zni/dn9jGplDXJg/Q8m6MJa6kDHOa0t2pWIgmLMerS+e0+sRc0I80MTnaUBVCriYsZMwfjznmhcNChNbpV5h7vXoJTp/5nXoJkZPFxCsOwyEJOGaJlM4KrnAazuRjoSOj1GJEk9QzkDbCsvzt54ToP9roIhXfEYrz+Zpl56AISujIdr2n5gH9xm8A+UMxAy1tmUlYPf2V8Uk0TLkWTm0gRSVyZwMFhnxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Gentle ping on this. The reproducer in my previous mail [1] triggers
"Bad page cache ... still mapped when deleted" on 6.18.46 within a
couple of minutes on a 128-CPU bare-metal box, with no fork() and no
gVisor involved.

We continue to hit this in production at low frequency, so I am happy
to test patches or collect more data if that would help.

Thanks,
Ayush

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/

