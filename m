Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76CFCE9B251
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEA26B0093; Tue, 24 Feb 2026 06:39:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A724B6B0098; Tue, 24 Feb 2026 06:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A3E6B0099; Tue, 24 Feb 2026 06:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D91C6B0093
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:39:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3573E1A057C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:39:41 +0000 (UTC)
X-FDA: 84479155362.22.53562B5
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F60DC0008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:39:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eNNNqGxj;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771933179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7KthUXIGMkC3Ch7vQnkMN1zxx/VHydxO2+xjM+lwoS0=;
	b=ePIv3JEmgTzXZYYBlRI3OaPIo0IiOuzkYeGD4K1zaU8eXLiJGAmRyPbN9+V6BJa3mF6XEY
	W2xQHM9Efww1T/8fsqFnNhXy9j0iOn4fuBj7X8ek71+ACv5l/b7pvs8myu/ahe8JqIiE1a
	UjOlkqZFoGu1PRdZe9dKCVoGkKQkaIM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771933179; a=rsa-sha256;
	cv=none;
	b=mPJxVj8A/vvRFLo7qeMayXxjEGbJ0tISUI/gdzej2q0vz31pfDI723x/nS8YG3AV0+Mhw/
	3n5Zz/yq6TurFtiFGgrtGzW2SvPBCWITbAe/Zfzg++2vGN/+JZVCMyvfndiGPGBMqxb94t
	mVkWYxZXD7jSxq4Iaoh4WkI2wX7mIw8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eNNNqGxj;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38706b10b3bso53518551fa.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:39:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771933177; x=1772537977; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7KthUXIGMkC3Ch7vQnkMN1zxx/VHydxO2+xjM+lwoS0=;
        b=eNNNqGxj1HX8Yj4dYogMD2xZauRLfkqZq8kRqzmjVaPfN/GzA218ebj5NYxSXhiSan
         oMOBhRX4f6Xpl3h1Yc61QAMc8/CV2yyBHDlWvwtlmKo8Zptuw9tw7g5gdO0bO+TXL2eE
         /3Y0yaUhqWJ7WmL31RBv7p0BBNNsxoq4HsGHe9RUycE/6Kd/1jCWusZu46V0kHuoYAjZ
         E4yMxckRC7+vlZS2HEX9GDYuzUiTHtjL7FwTCFn8mZ6nHUHSgMQ514TDh0WelUmhjQHy
         1AYCIqquHLMMbS66kIQw6G+W4AlxLZvzbf68qWaRmtxDGrLrGOLE3jMQ56FvNIihDTHy
         rFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771933177; x=1772537977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7KthUXIGMkC3Ch7vQnkMN1zxx/VHydxO2+xjM+lwoS0=;
        b=T8ZDHZpyUdEQ67WkNlNwcV9rNAx9TrPf/VYoUCXMoZgVMng+9cgN62FfI0jQbm1Mfo
         Gt0b2TcrrMIDCl/iaAHEcy00R8HfclTyWmMwsa1ABqVjeAH1997cRv0P53fryfxAUaTp
         xqhjTGBm5TmN2BCx624IsUJXdQPpKKAt8tZHW5cZiTLZYnJhvE1z9XdLTzaxasurCPpf
         Bg6fYN4ZNNIxUSeOCTWuqxRVuAzk+jR3GOam9rJkoMp4u6+r2saalcmE6NxMKNDqEoFy
         ykimyJ2Ld3smEA3ZmWU1x0XoWUIOPAYe+jPTX6+SHrNMVdHXHYtJBJt661B7M/itma63
         HY2g==
X-Forwarded-Encrypted: i=1; AJvYcCW9XmpEQYJpuJXT+t+kCTeplmAMMmdJPb1JdQWnayOw9hUDSCd9d9Xjw406InRB/5kCHdTmKrdjSQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl2IKJt13zrbW5ecFeTG/ipOdv2G13YriTF9YfqASS69PamKoL
	G7nHj4sffY0Xyo9+Py/wexZiWTpmEqq/4+7NSXR+iCAHMM6dYkAeq4Vj
X-Gm-Gg: ATEYQzwRna/3mQD1CJxjpv16dVBHixVYLV5EfddA4BKjXGy5Gst8BUHqriU+uq9mub+
	40yyYCdLertRNSt6TCAFP5UsljHozgH9c5eF+MA/dVfHXXLW4qyLEK3c4HGBjIveabQ14dhBl5X
	qbP1qO08i6O2x7PUoIxc5ZzX96yVj9NKyO4U8DRPr2p1jK7ZaAhXsetrQmR4Mb30GzBLZ2Jp/KS
	oVVu85y56RinWREnCr5HN8m+jlPFY6JCVMoKUX3pB95FB1gk9TjH+2mwshfoTi4zaK+ttbiRRYW
	LMRcPsmoGpdWZATpqmVFKu1mLle/IWEwe7tdJaJ+xJ3YDU3HM+9UYp72+yElAcW7OA7KBz7i+Nw
	2+ctjW7DVoMv4Rf2IYtiesvSPYoj8tPLKIw/09J7ol0erB7+V3AMwvKhJbAFGJuDx/Trg6hWGS6
	4WkWSxt/Q3NSRrpoUsAzvBkEnSiiVTb2VGQLdE43p+LjOpPaYPJ+av
X-Received: by 2002:a05:6512:1306:b0:59e:6447:f520 with SMTP id 2adb3069b0e04-5a0ed99d856mr3918854e87.37.1771933176950;
        Tue, 24 Feb 2026 03:39:36 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb0b8f0sm2106563e87.14.2026.02.24.03.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 03:39:36 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 24 Feb 2026 12:39:33 +0100
To: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2N9a4XgxnurOhz@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZzPwsBp-Z4XM58U@tiehlicka>
X-Rspamd-Server: rspam09
X-Stat-Signature: dh77d39r7ycktohjtooreuwjt9itut9i
X-Rspamd-Queue-Id: 3F60DC0008
X-Rspam-User: 
X-HE-Tag: 1771933178-696268
X-HE-Meta: U2FsdGVkX18zryjPaP+/Tne6t7WFQspb3azTzW1FmR2RKnvb/l5Vmq1zzIQyptQUl9sZicWtH0ofT5+lNl0MnaTgN+vQtGpE8ZObIdXekIXiHQ2DxH5nxStDPPk4Lg6RZ9Fmyawr6vvgB8F7dyZGcI06C4O5UE+4UtmaRuqc/ON0QmMRaFRMmBzJ+LvHN7r6/z0TUEZDVBaubsYfi2IS811Uo1gRXQnLez7HV/Q3j8/NyXZBkf2CLOHDOTv3KNwMDAOMQ5rIdYVDa8ZYJ9azK/PoCSISoHbbTQeoFhXLclGqqeu89ugFssApJxyftv6qzKK6/1oKQHWBI2BoQaZCGqi4wWzmChbVNsy0XcoXhUt3Wl1Nd/zAlLeBU53VPCT+uNlVTSAJ+cZg+n2NAOHmBTtkKbvcAAuUbr+iDtwLi5BlU9KjGaYcW8Zp+EEOncmp50me1NsN+jxMuQX214ROdV2Ol3t/duSlqiDZwRyBeYyWxghefmoiWzkNj201iy3HOmOriuPWtAEwWm7TI4/gsbVH1/Sadr+1BcROiby1bghNj5hCn09jHfTLMVfUwJ7L4F2704cIigJ/U8z7w05JUqQotYTNzsX6vLnRmWTpK4/BmCZCJO33TaOjBIcLlRH3rGQPvAN0NuG4Sl/EprN0pwVbZHALzVeVp5urZz5HKu3KcnaGxybN9XS6vJ/u0bnarAqvV7m1+vGgNrex/PLS3wOaV8VniiyKxe2ernuGAozCodSG3KyNrKjMEfQawq7se8J5WJU/ur72ywQvkXSdlYXFHiXyaXPFOzJegEOw+J64mryUXurkf4bc/VKVKozsNm3MZrSZkV1/lcW+lDSPpxnU1R8j3twj4vYtd1Xe/eCcPaHudL2loSnf1T2Uk+OjAC4XfYjDr5eKD5RYo9JFd8wVLoLlxQ9TtWSa8bbKb7AfpkFJ5357TvvO41nDhwz7qIyXP0NG60GKNAECOJY
 gNonzqF0
 lZfIS2D04ww6LfsmSzrY0Y6A89QBWamBLyTuyCAT7wCI3QU7y5RH/MaOD1NhUAKXst+ovEB3cvyB1tb8DKIE+a++UVs+CpFys66y2vHxMO9qn6YIPX0mtODxNQ+v0lQAgokVx+JkqvheFn35x513QYptzjsfN4bgJScUIY0HgKPOwmMmWz3zPh1cS9bSXIk0GqC42Lnii+Jr9yzY2amQ+vIZcufQmNYwGpwH2yeT9gpQgAKr456ER0l5I9ClLW1qT6/sfzMT1D0M8FJoMyi3far5PjJwWA3j2Yjcy1KsvqhbhBlwT+/6nBNKlnwN9G+7qkcawh9OflQdxTV8NmNYtZ93JtOWtvoa6wUtiOe6BDavP8AzGL6xkJGQl/q1jx1fpmVUGaQc6F/EBPYNWoiOBqurn3Oa75gFIWgP08MWg5mYFhBeNHaGQaaZ2ZABZQqxvgwgSs8s0OZC0i34x9Ngl3kcCDZQt7Sax133BGah7dNoMy23WMowKfuLDUhDlZXuQLtgvfCCM8ioLJ8OiigtQRGx4oPwqjpBM3YTgjL9YRBJ8jcs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > 
> > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > flags.
> > > > 
> > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > 
> > > My only skepticism about this comes from the line in the
> > > vmalloc_node_range() doc: 
> > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > 
> > > I myself don't know why that may be. Could you elaborate on if/why the
> > > doc is wrong please?
> > 
> > This statement was added by Michal Hocko in the commit 
> > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > you think that __GFP_RETRY_MAYFAIL is not supported?
> 
> The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> supported. While pages that back the allocation can be easily made aware
> of this failure mode there are page table allocations which are
> hardocded GFP_KERNEL and there is no sensible way to extend the API to
> change that (as we have learned several time over years).
> 
> > The VDO module needs to allocate large amounts of memory and it doesn't 
> > want to trigger the OOM killer (which would kill some innocent task and 
> > wouldn't solve the out of memory condition at all), so I think that 
> > __GFP_RETRY_MAYFAIL is appropriate.
> 
> Understood. But as said the very page table allocation could be the
> trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> unfortunately as well. vmalloc has just recently gained support of
> GFP_NOWAIT allocation mode, though. This will make the allocation
> failure much more likely though so I am not entirely sure this is a
> proper solution for your problem.
>
Yes, the page-table manipulation entries are hard-coded and it looks
like it is the last path which is not wired properly with gfp-flags.

Since we grow PTEs and never release it might not be a big issue for
the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.

--
Uladzislau Rezki

