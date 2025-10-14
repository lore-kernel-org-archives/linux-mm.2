Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929BACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A622280006; Tue, 14 Oct 2025 11:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D478E010A; Tue, 14 Oct 2025 11:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593C8280006; Tue, 14 Oct 2025 11:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F23B8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:14:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A998A13BF86
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:14:51 +0000 (UTC)
X-FDA: 83997067182.06.53924E9
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9A721C000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:14:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=POIdsoPB;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760454890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQLfTHNnTKNjH+34TPL7Pi8OhXbeEQ0J4cWXx6jAeow=;
	b=EpqkFzaIcC8Rv4sVXSaXPYF2tq2Pu52DYCV2QFsKMbqPKfZD0Y13E4S9xVRowwMyb7s2KK
	yBRrgVXxLayRnoiiAvCeI3gSqtfNr4kVbzn04oqbH99upyZWkhJbySJjI5n2N0FT0+1AND
	UwYKyr9ILsAzAztDF/hdFjraikRmDPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760454890; a=rsa-sha256;
	cv=none;
	b=Jr8k6qNj25b8MEPG/sFCM9jFbhM/vP42M41ThzKEsEqW1GfC6nT8sCseI5QjtJmLLsELRp
	9sxmItYf9m+mIwqt1gqsyy6T7phO09heOLcoegbXFxo7w+Oe1mKi9IJt6jeIihA+GgFail
	cO0v2JEIeaqVb0DG7WESnf8++Rg6YGE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=POIdsoPB;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-46faa5b0372so33437415e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760454888; x=1761059688; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xQLfTHNnTKNjH+34TPL7Pi8OhXbeEQ0J4cWXx6jAeow=;
        b=POIdsoPBIfDQGwZkMBawqX57EpMnGPObBorjdIt0j8Z4gkITrGNC1LaTaWRsVxDyjc
         WJAU+CCgo2EXBgAXhoKB1H1AMpV7y2ytlMbByApp523EDHWDSMxMP543VRn2d36nt/5t
         zSQLnGmTMDlN4Wh5LSHMAhbHS9haC999VQ6pjlXYz/YodL3atf/mJF7CRUXiGXBdOdTA
         1l26Rb1HLv/o340om2Ss2ZaC16f94tAv2Lnx9/bt8ZJLL5Dc9rlNppa/VWqGab2i9aDP
         1LQGrjM1WWSvQ8fFFZIn5SOdIW7OmHw05qm3cg1s4/HHnXza1JZBkRogr8b3pjGGRtc9
         yd/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760454888; x=1761059688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQLfTHNnTKNjH+34TPL7Pi8OhXbeEQ0J4cWXx6jAeow=;
        b=eUC8gWcRLMsY9TUAW84ZZrVz4P2/6M8Nv2ZsuFpRJ89M95PSTczUOGS/L35qFIql/x
         Kq2Gmyfe+pc9Br5pByZmVpc/vjq5EUUgB+aSOmuCNyj8BaMhMOkE/Q7YiSJ1bRAvhsX5
         rCBX/mlDPtUIFOZyE3bwEhfG05Xle2V6Zqs/3txrOckWu9CYOt0lyMEESDgvXXmYXwDp
         Y8reQBXcbXTQaugDEhP3rP6JWdbPkFy9aYetOAn/Uulii+PTLsna6r73Z0nzgEl/4ZA/
         JvXi0PZPxNECrVyflWJkVA6CNFjXuV++z5nP3jxxMOx7e7Rzlfu5/11CtnI0R9DbR1ek
         Hoeg==
X-Forwarded-Encrypted: i=1; AJvYcCUUJ+FQoaaopWcwlNXHqEDHYrCe4FkJRA7Rc1YiSSzzv8keiEmtLukD/IXTt9k9tHbnbqrttlrodQ==@kvack.org
X-Gm-Message-State: AOJu0YzSKBscL8h2E2BYTGZ9P/QaOihMVcS3O1TfHjaankuDoZ/7CR+b
	b8xJ7w9NZXOfEjHES5hGZP2xB4h7vtFAGowXxBrtjmbEMQKBP7yRSMtfBV7xuYWocgs=
X-Gm-Gg: ASbGnctuuiUIFrGNd0tucQ8FDPOzMR7intP/n3TTToHjTGPYfOyUssWUPR2bah6wpzx
	QlssPkTUhT/PH5VgCq4XYvH7WZDh6l4SNkuCikfoP/iokacZ674mYunxq5faotHXNL5jwKlEmaa
	DABA1cxMCxun89kFtB4bwKl7vYvsnoG+R1JCeHxtuGmNCAmH13UO98mYz4P3PmJAmEwQTWcKooN
	Ja2WOaN+gWcznl8k8r5+7GvgatcDigzgbk+KayHHa0XT1Zb4IvGwhQTPS8jnuGY8Sk/uQmR7+0Z
	2i0JQTDXEkdr+Sl6yUkQBAC7A1Cj35GyBEzdugJgw9uHfeNlGwGHNhumRaotBWkljR8wcNxrkIM
	fFIo9yNwT8Q9OKs5Hs3yWuXjoErfAqQ/oTRTnUt7+53oi+ivviUfep9JjpSp4V6V+xHzbBJuurA
	==
X-Google-Smtp-Source: AGHT+IFTHGjFphXZexQjbUWRV0zNN1oAawyBZFjG8j79GJAZYI0e5RFLHEUzsaTaFKvHfVpvOLq1+w==
X-Received: by 2002:a05:600c:6818:b0:46e:36fa:6b40 with SMTP id 5b1f17b1804b1-46fa9af915emr172798525e9.24.1760454888343;
        Tue, 14 Oct 2025 08:14:48 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fab500706sm157838725e9.3.2025.10.14.08.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 08:14:47 -0700 (PDT)
Date: Tue, 14 Oct 2025 17:14:47 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <aO5o548uQAuBcw0P@tiehlicka>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <aO37Od0VxOGmWCjm@tiehlicka>
 <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
X-Rspamd-Server: rspam05
X-Stat-Signature: 8dyc5ss9jqzuz7jcg8zgrkjrpfh1s44m
X-Rspam-User: 
X-Rspamd-Queue-Id: D9A721C000D
X-HE-Tag: 1760454889-500801
X-HE-Meta: U2FsdGVkX1+HhBVPn6zD72gGgHubjCJyfMONtCgA3uTUjgItpgI/i+qoLrEcF03ka6BPzPd2BWHteqDo0RQHoa0CvOB4J+WPsB4+Mmn1s96GdhvhKchXBJJSBEJwUczFsqZWM3rx2HJx4DhgJ6Oxp6a4cdlpb0lRR1rw8JFLE1TMIZxilW6I7HFg+caJ2EP+ujQmDHG/V0uHTC57xyjJCeTlBJHXq5GLKDKurtPDm+dN4BIDd2BBy4ZL3dTu9O34JASIR42XC8K/pB5QSCD8KHVykFyLR1j3tozjR0zMbbjpbcl8BrBnUl2JS3A5VenvQ70+DPsSzVhjttBkeMKACu8IOm3gvGXgTyiHWBdeItcow/qDX1J+anY62CLaYf+X4SHmpFp6dEialwllHE9uR4A7JCNG/T5fcgB8wNlV2OkIm5WPMAoQ1XIT22rPttXMowFu2JSVmyCu0kg4SWrAWD9DZb1tjDpy5CZyxHcp0V0u9EEqeO+1cevJw602uBOwcqHvT5ls012CmRrcIvZEXG6GoFFnbhaNI66rbN4MuBCJj30oklm4ax1VLur8bPSq8CvHS+tWXKdG0RW1Fx4yG8bzo+rKaK8LCrp+0CndTMW+IDmgNHsMgKmC5VZT2cTt1rm/3iifi7W4OJ9+2R5ZVV+W9j3Dyt9zBQQY5XOtAPbukxJXXRhoGsyekOJzxUliBfieu9SMkQGFSzRHoNQ3jcbWrIGvN12Iz8rTQ1AfI+kDsdlZJ088vtmAYbq+AhzNMI1e261x1MjoYIQs9fVOaGKN3KXP3TytSrQ6Gzy1DRLY/admGfDZlBRfPeGznCTX+eVC99ZA3/8Iv8Iftp2LkfVYtlNenQZo+kDGeIZXsGnMaXqkSqidYktVkKjSUlY349WWV0IxlM8YoDdaxgnvMHJQVK0ZA/3qIXQ1HJjobk40F4X6IwkiItSt2K3KFRzh1WmsXdCq6Ka7jEk9Cno
 3+ovt7uZ
 RL6TbmDY7C7s7ZrWdonTdO/MUXuK2XvwDKVhMdKvGMq1ZyE5jKQRRn0PCK3ggDHj9tsZ4ksXkeRIIr9hiARJXMXoADSgYoZu6oqvzKcCoSGustXdWHqHuKnjObKmoheOSjgXLWmS780/v5oP7svPcKzZQ/E5mq1o2Ye8vo26mMU8J0qE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 07:27:06, Shakeel Butt wrote:
> On Tue, Oct 14, 2025 at 09:26:49AM +0200, Michal Hocko wrote:
> > On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > > On 10/13/25 12:16, Barry Song wrote:
> > > > From: Barry Song <v-songbaohua@oppo.com>
> > [...]
> > > I wonder if we should either:
> > > 
> > > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > > determine it precisely.
> > 
> > As said in other reply I do not think this is a good fit for this
> > specific case as it is all or nothing approach. Soon enough we discover
> > that "no effort to reclaim/compact" hurts other usecases. So I do not
> > think we need a dedicated flag for this specific case. We need a way to
> > tell kswapd/kcompactd how much to try instead.
> 
> To me this new floag is to decouple two orthogonal requests i.e. no lock
> semantic and don't wakeup kswapd. At the moment the lack of kswapd gfp
> flag convey the semantics of no lock. This can lead to unintended usage
> of no lock semantics by users which for whatever reason don't want to
> wakeup kswapd.

I would argue that callers should have no business into saying whether
the MM should wake up kswapd or not. The flag name currently suggests
that but that is mostly for historic reasons. A random page allocator
user shouldn't really care about this low level detail, really.
-- 
Michal Hocko
SUSE Labs

