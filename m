Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F7ECD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C736B009D; Thu, 11 Jun 2026 13:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CEA6B009E; Thu, 11 Jun 2026 13:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779A56B009F; Thu, 11 Jun 2026 13:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63DD46B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:39:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1427BA073A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:39:22 +0000 (UTC)
X-FDA: 84868343364.18.E7E8681
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1AFCE4000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:39:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHbkmLxC;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781199560;
	b=K/7fDun2k94rmLhPs0mQLZqLIf197FCHwcPBm0q1JWfc12VX8pB32TMaei6vny1ajCKwOP
	TD7nH31E37dlNzPH6hXvW8UjYPWyM/1GZt318aY5cy36WwighLScXSgpkBxCpY+mHfQFp1
	oaBvNwjzYnqP+fEnJx94hTcBy9EYGZM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BHbkmLxC;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781199560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDVNXhL2Pfk2NWjHVmUzJTm6IqAYDANPcobDFgmKGWg=;
	b=fS8/PnT667tayBfZPOQ4hdx1rwAK71eY+O7HUiiinL4AxpuQ9Qetl5m5ODig1Sgz+9zk9A
	dCCWjCCIzPgMSfwCewUGLgxj6gCp/XBSeMzGZF+2WZZyAOWtxYBAx2hUshXepojLkVyjtS
	iu0dKC2Yjmfu7Ln4B6NsHSkwcpe8tBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0543344576;
	Thu, 11 Jun 2026 17:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484E51F00893;
	Thu, 11 Jun 2026 17:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781199558;
	bh=EDVNXhL2Pfk2NWjHVmUzJTm6IqAYDANPcobDFgmKGWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BHbkmLxC9oZUeSXsvuN7EeETvKhppZNCiJLffMi5U8/+iNueDNzhoRtOta14y3//J
	 si5BbetblwiOz15awvoRP9Q0yltQG9G4PJ0ow1o29o1wuxWPQQh8Xn0cMwpVmEfkGQ
	 1ImvBKSBZ7yIN7KNE9CGBNku0v4iZEjDtovmr7034CX8KGq+wWpKT5LyXiOreR7CWD
	 DXhq+ZhzvjFsXdY8P08EpFWi3ZmjZSz15DX/bwmLQVlv1rbYnQQ05uCgwnSisfgWnv
	 ZCfVo9utox81XMowyQqzQUOKl+KTB9gHzbYRj0UmHvXBI1s6FNwNUwyCXw87KcBLn8
	 oxsgp/LWYbXFQ==
Date: Thu, 11 Jun 2026 17:39:16 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <airypNnKrJJ54k_0@google.com>
References: <aiBpibRNi0BcM1Zu@google.com>
 <9898f83d-fae9-e284-6b85-c7f4089840a0@gmail.com>
 <CAO9r8zPBH6-0SQ6-_ZOhTQeyu=rz4F=ugikCrU-JR_skm6fEWA@mail.gmail.com>
 <a60eedb6-f3fd-4092-b726-04a17a695ace@gmail.com>
 <CAKEwX=MQ3xXBAY-2H8vA+XSX5GHNBubJ2GCYAXGD+Hra++ZM7A@mail.gmail.com>
 <90730fa7-62e7-d5f4-b638-23b22a8509f2@gmail.com>
 <CAKEwX=PF9hfERC_QMq+rjkSc-BsJyawMgTe+EhwR_86HiQKm=Q@mail.gmail.com>
 <CAO9r8zN6VVZz7dpjNrh8n7wbLkqcrsROPm70MQQxO49HJSmMFw@mail.gmail.com>
 <CAKEwX=MCFbsh9ndBtR0-bGRr_=v-6bBwTo=muzd9ZSD-LAK1nQ@mail.gmail.com>
 <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c25650e-bf98-2863-d505-9b94c385668b@gmail.com>
X-Rspamd-Queue-Id: 1AFCE4000F
X-Stat-Signature: eb11wnwqfzw15rn563uht9ckuyraoqqy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781199559-781120
X-HE-Meta: U2FsdGVkX1/iB9XULCV7XGGFpvmW3o260e/XQxyRBoZIZe0c/9kl90JDeeBLSPJ5ezrajh7GwWtj1c297WWJoHYphY3fmWygvjEny1nc//c74P6x6UPXCEABs1GsP6x/SK+G70iobQcG4ZQK05LMdwVBAIZuKAXbeLDDLweMy+DoW8KRml0PWDWwdwB++IogyY0l/wruuG3v2+qGLBlr4HE+oifsul9h6qB7Dj8sUiSY1PugDinKf3J1NJZIxL8Qa2B1D4uJwfvBFrKfb7ZUOHdkBRO4hRYwl/0JSvcsgXHOJTdjeiEd2Cf206ezYQ+GV7udSL5NQpK6GgW5lDzCjQU2KRgvO9n+mx+AMZbZhiGjCjg3EVFUfWklSOwerDtycZ/9zLhMdo/dEEImeB2kIp+zTJwfBJxSQiqwkPapSh5RzX26xqMc2aDbxlhwpjQb7zMqpy33eo8n8R2ckU3AcblPq/BoPoQrcoA9J64EAUzIcsSEzUYXasFnbb0DOYyLnZYx91m0E8pIsqHGMCDaQmN2WKegAz8EuNkKxlqkFuXuSPEb+FdpgLqcm4EI1ujqGMa1E1DGp77LymzQcoJEpU7pB9JAunnlugnZ6oxOhp9JA1+jZVNnkLvfPjhKdg92TXwFZkUmO7EpHhda5JKbZ50FfHQSzD1DYgb66+OH6MsRNsBNAnyGNa0HSUVMop+bvSGWux/7Wb12wYASP9out349Udgd2Ky8c0LYVnIBAfz9eEodDDgWaAdcon5NvxOwLqEA/MNNgQiDKk7s3G9MQx1FVn18ijRGT/JlpaNBjSc0zjVkIIdxCFWzmevfYKqKVW4qkJqeePa2Dwmieiab/vkH9MQLdKvvgJwTvyWo7qzogBctgMjLp/Crmkwd46KBGbceB6a3EJ2o2irzXIBu+brKknM5YDHYLvcYmBkuJIM4ngssToTgj+sTat/vKgME+c7CRxVsms1Ppk5xYoH
 Mbvjbs5G
 9KRDMLnzPG8MpaCh/ZzduC2XndrLmYOFfZD7ztb6eQlPaWVVjkh0TCqqoWn5885EQq/oTrqK8SZl9qenQ0G/VKDw7m1ZuZzZ11yDqut2qBIw5ZmQPU26M8XhbBo6kut1xUqhb/WCN116KsNzYIrbYzw0yAsx8st3S3UuoZPZipudx4Wus3rcD+b68Ip6IpLdi2IeQVEBLDMwADQ8SxJ27RvBRX9rwuny46qCooKH+4q4Y4MNJ9f55Vile31hPUmr1WmTWUl15WdK0XWbkTgF2q2aeFCtIDFKwUDTJqZVqx+f3lCuQSVV1RnpkuFTf7lewmViraRNRh53l+dZBRYaoSAFVujmTPmn4GvT+90JwyqRoQSZaa1RVDo6Ytq3y2FMyoeo83QDE9yhoP2feuiNB6jGXoUvhxC6zDGFVkCXinZZMhR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:18:26AM +0800, Hao Jia wrote:
> 
> 
> On 2026/6/9 02:01, Nhat Pham wrote:
> > On Mon, Jun 8, 2026 at 9:48 AM Yosry Ahmed <yosry@kernel.org> wrote:
> > > 
> > > > But OTOH, this does seem like a recipe for inefficient reclaim. We
> > > > might exhaust hotter memory of a cgroup while sparing colder memory of
> > > > another cgroup... But maybe if they're all cold anyway, then who
> > > > cares, and eventually you'll get to the cold stuff of other child?
> > > 
> > > Forgot to respond to this part, the unfairness is limited to the batch
> > > size per-invocation, so it should be fine as long as you don't divide
> > > the amount over 100 iterations for some reason. Also yes, all memory
> > > in zswap is cold, the relative coldness is not that important (e.g.
> > > compared to relative coldness during reclaim).
> > 
> > Ok then yeah, I think we should shelve per-memcg cursor for the next
> > version. Down the line, if we have more data that unfairness is an
> > issue, we can always fix it. One step at a time :)
> 
> Thanks a lot to Yosry, Nhat, and Shakeel for the great suggestions!
> 
> Let me summarize what I plan to do in the next version to make sure we are
> on the same page:
> 
>  - Drop the per-memcg cursor and keep the root cgroup cursor
> (zswap_next_shrink) logic intact.
>  - Stick to using the zswap_writeback_only key, and change the proactive
> writeback size to use the compressed size.
>  - Consolidate and reuse the logic between shrink_worker() and
> shrink_memcg(). Enable batch writeback in the shrink_worker() path, while
> keeping the writeback behavior in the zswap_store() path unchanged.
> 
> Please let me know if I missed or misunderstood anything. Thanks again for
> clearing things up!

Sorry for the late response, yes I think this makes sense. However, I
have some comment about how this interacts with swap tiering, let me
reply to the other thread.

> 
> Thanks，
> Hao

