Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2935BF364AF
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 19:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA5F6B0005; Thu,  9 Apr 2026 15:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2686B0089; Thu,  9 Apr 2026 15:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA5A6B008A; Thu,  9 Apr 2026 15:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DDB1A6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:41:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 781A9B6B35
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:41:18 +0000 (UTC)
X-FDA: 84640036236.19.E845B04
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40A5780013
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:41:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="JUwRa/wE";
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775763676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ge1b1xcWybylA8rGPuIV1asvwgEzJw2EpZ+7Ph4FvfI=;
	b=p7nn5EznAJtF13c1aPCgiCv+7ZwZRXh6fV7YovNvNLR/YB/WsuYjs7MUQGL/o8uNB8Lefx
	0Hsl3J9vjoxDnzFz82HEP15ywm0twzEoFK7/pk2vPH6h++Z/NKE49cO+U1XWbuPN1kdDoh
	Bef/1PnsMdCtc5Jbk/lorCM8AXB3HJ4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="JUwRa/wE";
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775763676; a=rsa-sha256;
	cv=none;
	b=dqQo2fnu5ulJDzo4VzNITA78PnLKdSFXt6djkOOEQb0JtaZ0Kl5unS29DeTDKk9jIY9uiE
	LXVv7McIK9fYArZkt6AdtPA4J1Y1uCPoWmQwoZ2iie8w9wWSoc/Mxd7xIL3mv2znKUP74S
	KrRS0sIoJIy+ZLTbobDOTENpJEeqN0U=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfbd17589so916336f8f.0
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775763674; x=1776368474; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ge1b1xcWybylA8rGPuIV1asvwgEzJw2EpZ+7Ph4FvfI=;
        b=JUwRa/wEYjaSID9SM+bbL8ztKbotWdkIH4t3nK4NMyIpuaudh/GQDR/920bDlIYklB
         sCFnAqz6XVwEMsaATvSOVbC6bLD1h+g7rUP75mgmfppaUQkOU54s/yyKHNiaHVAjVPmL
         1+uNfbMfGILInSkV1VkXd/KC/DNKLZtBCXMPoPCTN6EOJGTHPbY7QbJ1IfdLFkXwQfjX
         +kCzJbVwqqWq+61faBs1d9R+AnuPNTwduBsKRt4nlHwfYtsK3wI2YvYsblKAP7/4ukNA
         OdsvN/qJNkK+Zoau3+XvgLBXMdqSj1GDn6PX6N4pIyLPiIcecwvnk1LIUvU+5yNaX9pV
         o7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775763674; x=1776368474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ge1b1xcWybylA8rGPuIV1asvwgEzJw2EpZ+7Ph4FvfI=;
        b=DjR0vXhYzF0nDFCmnZ0sappgsG7o6NgJX49dyrdE7hAeP7WZhpRED/eXCaiF98mSFB
         sT2GIBWeFHEENZji/SsUxibJFJ/pz2/vSc4kJQBgxwTglK8XzVr/s2aceN/aNTny7F9T
         IbRcEmSClw1FeEdFbZ7s2HAlxznuzNNtQGCDHNayXX1esQY7H11gs0O0CtJGstHQsHJ5
         Xv/kDsKi/WE2EfT/yHMMoFSQKBhGv2RlDPuYkJvKxmWXkIS7jazRLD8fZ2cu9qh57E46
         JZFpkWZSOdl2vrClTC/W/yyoV7b//XvpHlB5iCSJ1km/UOt0EdnWFpg0rD9h0NX/Wrtf
         tOeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUwm6GQ2PzCEGF0r4eTc4d6K5Rwr2h7s8Itco1CQ9lcKy8JF7IVSq2fH/jq4vmcE5awB7SOOt1xQ==@kvack.org
X-Gm-Message-State: AOJu0YzPwtzZMdOiXE4oqkocnIkZJAYxFANfOehykWeERA0s0b1yotP1
	TPjZGg1eHsDw7AAcJ3C8mtHab0QYYaKIWbR+feW6WFaq5i93WU1sfAlmPbcPNVY+QBc=
X-Gm-Gg: AeBDiesmLJDtOc2ok2CHG1MMRl/vg+PLjRZ7+T02oQ0oMugID/XFI0OcXeTPy7Lsfvg
	tXdsBqsvVtrw3AIcLcjx1CX1xbGHYmK07BCo9r57tSbEykQEKMv2WrPIYfVEeNrvHYLyEDVPkBE
	RCiquAokTJdGqsGdfaMSXrpyq9/4zQstMtGZM0lqNifH0cOvoHX5ReGzXhlW2vtWzDMKUhY8nzQ
	t5tW44X9qHkb6zqHJmL7M/zw841KnD6llk5h5X7jgay4C8P+hVzEgf5UBbn90omMbzTvwk7ce7b
	h59Nf9wjNLdqH2lh7JjGzYn2bLYlENC9PbB1sq/CkTNpHSrz3/OjyUjaxVg7KLUkQsUN+4YwOPi
	ffOUAihnId28FAVdKknik/CDISU4P4mN64dpcN2zfFB3rgGnObFjCO1NrP3gzNLYKI+BGX/887h
	6S0fhNIad5P2zVVjLTR40zkf2tbLbBK8m/ZA==
X-Received: by 2002:a05:6000:607:b0:43c:f81f:3e6f with SMTP id ffacd0b85a97d-43d6423cfdemr517256f8f.8.1775763674566;
        Thu, 09 Apr 2026 12:41:14 -0700 (PDT)
Received: from localhost (109-81-92-28.rct.o2.cz. [109.81.92.28])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e50289sm1144780f8f.28.2026.04.09.12.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 12:41:13 -0700 (PDT)
Date: Thu, 9 Apr 2026 21:41:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
Message-ID: <adgA2IKrdStZJ6AX@tiehlicka>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <20260409081619.34f172dad0e5a56923b7eb2d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409081619.34f172dad0e5a56923b7eb2d@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: zkgtp9aetki5tx95se4jfqt4h3ptrmjw
X-Rspamd-Queue-Id: 40A5780013
X-Rspamd-Server: rspam09
X-HE-Tag: 1775763676-696977
X-HE-Meta: U2FsdGVkX1/pyaR03dLgb7OpjaDB1Td7zQgQH/lp7dZXFKQvBmRT3Va+xwByIcKWKY1uT/BUPUoZD5AhxfbXCrMUNigDGglouTuSGAgHd93xvgTlkfny4reR3K2LdIxphlKWNCM8nFB75+IhzfkCj+kT4xZwA4092GQk/+kFOAYscA17P1lEOKdzL3YMg/pPQ6XDQmQEOxxAmzw5n+yXD54dnogLP30faVPjPxWOIuSNDuvL+jTO1ZL/DU6EJcD32qrWmiIp4n12s/E1PwXZhy36TX4YxiywYeF2KmN2KMwav429giq3zUVMOZzcliRGHPPfwwGpxlebI/u8z9d+PztpxvGCtgyvRq41aGr5qH5ekcjlkBCVwQP8jOixCb0nalfyGtFKCF9MAeJs4S1NzW+YKMEE9uKPIxGPx9k1Fq0pcBx+bjWPgw8w4gjifcXNPXKvOdb29096NPdQd9gs8+SWj0YPE1vxUKH0hsKetX3t3skRhP/ltv1VUlX7+kFKMoP5Q/gDC0M73MjRInAbWLzUEVWoTYxkKdZM0tKSR514uVF3Anir5eNKXWrBhIPXzFp4K7TY9hebUsn7eSmZv0I47ZRRw7srBjjBpFXGixrmxJi3NsX6nnd2W8QVrETGeoo5X7xlQ4BsrE3mvyIrRcpojN7gpYkZMQ698Et2HDwePfTOoz5JISZxW2+fKlQMGch9Zua3xFuJX7jSfbVs+eFJyg6GRreRyjAWBsPovzpaE9vUxyR5w0zZmb4ukFpSHZvtiitBVB9P5VSB5mnMX9RHUJMQeSGUppSTC9SjOqKmYi2UZgdRR4dwirBMt7dzB2sZeFRTgFrPpy0PR8EZOjYpfx5mfs3HFvkldVY5Wv4XyxOxYehzDzYMBzxVurBJUjI7e605qXBPhPdjGyrVxUmMZdKnZpNqZNQF/p/IcMPW/tUGEL6fv2yMej3oyN/+cHWDg4tj4uGy3WGH2hi
 2OyRuH+c
 Y792SeeekDZkcvXwbyuRuuGMsWg7M8Hx0xAu2DFQJGBAv3Ew0PUIVG2oB7DaWc9CK0QN4Kp34Qgs1kjzRw3DoH7r/GtjUuyGRBRsqmRISpjwnTn8psX3s74cXca6aud7vn/s0N+D+PPml24eK+HL9kwINuKTBBwNXMsYsMpOIMT7PPP32MzDX4EcwOKtDdsLWD/2+ajhVHv9Mk5WC6VFNiac+NsLvrEnDH/mexsRrHjmgrOt10n6pjGmr4OcFqX/AqNkOIUgpLJ6dcJGu2mMMQGtMEO/scsiRNmM8p7GcTFa65wl6HfGMeJP8q7S78Mc2MRALWaBdZ69GWISWdJQtjCJBzk82G3kGLbgpKcICy1uACnSpchZrfMVipIWPVJbQuZTg9qRQrx1LLdfHFduyKDDcHjUYRJQiu6Lgv8QamrdjF5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-04-26 08:16:19, Andrew Morton wrote:
> On Thu, 9 Apr 2026 16:08:37 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> > > Quite honestly drop_caches is not the best interface to build any new
> > > functionality on top of. It has backfired a lot in the past and we have
> > > tried to make it extra clear that this should be used for debugging
> > > purposes only. Extending it further sounds like a bad step.
> > 
> > 
> > I am not clear about this history of this interface, but some of our
> > products do use this interface :(
> 
> I added it more than 20 years ago (before debugfs existed) as a way of
> exercising cold-cache testing fs/pagecache code.  My stress-testing
> code was previously using umount/mount but this was inconvenient for
> some reason.
> 
> But the damn thing because so popular!  Mainly because our caching code
> has always been problematic in various ways and people found that
> drop_caches was an effective workaround :(
> 
> So it's an unhappy story.  Caching causes people problems, caching code
> doesn't get fixed, people get stuck on using a stupid debug thing which
> I guess I should have just kept local in my tree.

<rant>
Our caching strategies might not be fitting all existing usecases but as
usual we are targetting as many of them as viable. The problem with
drop_caches is that it has grown unproportianal amount of cargo cult and
grown into "solution for any performance problems" magic pill. Even when
proven to cause more problems than it solves so many times. Again and
again. That is really sad. Same as THP causes more problems than it
solves and that you should be using 2GB of swap space or that swap out
is a signal of a disaster. There are more and they are hard to die.
</rant>

-- 
Michal Hocko
SUSE Labs

