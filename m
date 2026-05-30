Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1E7CD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095A96B0005; Fri, 29 May 2026 21:40:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F606B0088; Fri, 29 May 2026 21:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97366B008A; Fri, 29 May 2026 21:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D83A46B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:40:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 746D140333
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:40:50 +0000 (UTC)
X-FDA: 84822382260.11.57FCA17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CD60340009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:40:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WD3UrKFz;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780105248; a=rsa-sha256;
	cv=none;
	b=7EjDlNMzs9QTNex/wGy/gystO2fYtDi9hJIItkh8/h7lZtGfGIIlHTEUYMtbeVo2rDNIFL
	l7/W/j/5D9NqnhYHxOKD2gGc/D8Y4qWz6oIoT9Bsb2vWTTu1F5IpK6tN/a3PtXdITcsfmA
	+5vWWxnNMtfmVsWkHIbB51WcbhGiwHM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WD3UrKFz;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780105248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4q+rJpKHgVwRxohmm9Chks+vxiJ7/M2vuB2nm9avkVg=;
	b=CqHjhcr5Hb1/8dkryZOTRJkPlvKmxytId2iIDtDxFZaTKTsI/M60lgI0/JhOOzaeR6FUTv
	gQcKp18I4jdH1xqUJAUJQbUhgbEhFJ8h2F73UOoUaeW0MhRIw2kT0m41S2PRFkAytp7FcO
	qVVeughuBuSuJDxJHebkbDD1smdsHgo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 387FB60103;
	Sat, 30 May 2026 01:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE491F00893;
	Sat, 30 May 2026 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780105247;
	bh=4q+rJpKHgVwRxohmm9Chks+vxiJ7/M2vuB2nm9avkVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WD3UrKFzTBhsTvBy8XAR7HT86I2pI5cBYtmza2xJ6PNT7nfBMFJcn8upKnHxLga4E
	 PuS2QXJy17WZnzxh7CPOqWf2sh4s7gU4MrU5x5wYAcW6JbzMe0u/G+qSSIPEGqUhM3
	 WeBppVTvCCn011DeFk0MLQl0EXTAWB2B58gIxslun3IJz+YAN1nVCELMRn4q3VS4Rn
	 3CmKF1oNXAghPXD4mLbJ4tPOwi2HDaSBDBfqb4MHqi779GFCAEjR6HaVzsD5hAv6EI
	 y4PwvP81wRTJ1dRkOwAXjXabzCrn4kyuHaEpPZr8AAwEWpqR8Dt+9P7ichxSadIyL3
	 oChSzUoKET/WQ==
Date: Sat, 30 May 2026 01:40:45 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, 
	tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aho_VtLCmIRsNyvO@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD60340009
X-Stat-Signature: xiype3ti3ychqchhkphimidiwegaphch
X-HE-Tag: 1780105248-479898
X-HE-Meta: U2FsdGVkX1/zHY+KffFTM/OBET0BnGmtsKkaTrxeRiunc2DSQXPqgd8dyFOFUuYME3KxTmUG1TmskKXc+zp0y6OjMeSdjDFrPbYe+2yXPfiZcBcibwW/HUhPTmZvgqDzMwDcshYIOTF8OAek+8ryM3eOP/VHkW96XXR6wLThEPdTkaRSxqeOQhviR9pilRKS9MBpKnv7gsdmfUw2MfsUT/rvRR5VTaGzPsGkB5y/6UC6lNCCIyl98xYY1W4Fgx0wSb3DtKL/hZaEJ6Ljf/v3EPYI+aWq5N83jN069dHbB33JvuRKcDePx1tMi9dl+fviVeovXqedMiBpgtbUwCOxVaNg+0LYRI+rmqN8aVD34WflqebJr4SBm/gUeN7qDs8/xliyVDcsB4w+YpXyzBnZhdkNfyuBVre1I5iZmmYlySOhBh3Y2I1iw57Rs5bR9Phv6gLuplDMu7uBZzPL2Yp+sRo/iHOjWTcUOR3t3SiMKt5bwrqRtfWYQNM6ucNivNbfTS2z1JlLbmFQkxvxoO5YP3DGbW6xKLl2npZsxBkeC+A3Bj/W51D/8sZ7KdvKqIsupdPvt9E4KWDkfRIpjFo58nxaMwg4bu81rOmvYx0LhZbzXJ7Pxp7S3/l445mQO2eQHVEuHDblyfrKyaWmpe6aNsTWyqxACtKIiJM6yT7GDfVpcxyCaitWhmvHBI8H1qreMdNhzNWxLnG7OJJrD9YnXCDa0ZPHViGRTTUCbSObpCQsh78hWKAqTzBI47cmvlQ4UEan4HIhrSICtg8PxdTTBg35conZKcGZq+HD9hb/alrSTnb5E5ZfQVt79xM2MtaEvPPLCe1bG5Ut0Bh1Bl4wyQr2hHkwweZ6qaQf8dLZQVciN0i+Qfm6auSfIApuIBm3hi5mPjWCyY9IJW3mGfT5lBff70kYCyZqYNpsdd5gCn48mAXfwOtpljTmQ8DnTS9I1H7r0nRX90xH73kg/wU
 udAplGs5
 OCNamsO2/SYUGnRn9fWddBsejdgPCJudWqodBVl9Gf4JCWiTcm/WBaMY2lfKSPL8sLUymbB0SBXY/JNpcxrBtxXWlTMmqru+6PGzOlLlFdvaqYDNpNdUs5McxY92t+RyVo2cYxN9Hyo7rU63MXXfKOMQkrP/tZAazhflFjdPrntfmQ6//4WCfoK3xCVcq4ZiVfR3GC/Kl4mwVkRWtgKeo37fGxr69bdGCqPnZtZZL6SUwjBy+F1Mp2UFVmWSvfvzx4/yU3hW0thMSP8pRZ4pUUN0+95kQfHBRzMfBDtCP3Odssj9QHT/xl2CeYxukHuDDPdJm3IMIKz8BKdpFOKO0DemKV8sA+LGCN9fQClspYIkjYKr53reaT0AjKbGIu4UB+nho65awv8G0PFnaCGPz01xTJLSx5u2WsklX6kvsd7UysBaQCyqalwXvk+PPR8F/1hHezia3FvvhzvRjyVnKYGCKFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 12:58:09PM -0700, Nhat Pham wrote:
> On Tue, May 26, 2026 at 4:46 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
> >
> > From: Hao Jia <jiahao1@lixiang.com>
> >
> > Zswap currently writes back pages to backing swap reactively, triggered
> > either by the shrinker or when the pool reaches its size limit. There is
> > no mechanism to control the amount of writeback for a specific memory
> > cgroup. However, users may want to proactively write back zswap pages,
> > e.g., to free up memory for other applications or to prepare for
> > memory-intensive workloads.
> >
> > Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> > interface. When specified, this key bypasses standard memory reclaim
> > and exclusively performs proactive zswap writeback up to the requested
> > budget. If omitted, the default reclaim behavior remains unchanged.
> >
> > Example usage:
> >   # Write back 100MB of pages from zswap to the backing swap
> >   echo "100M zswap_writeback_only" > memory.reclaim
> 
> Hmmm, so this 100MB is the pre-compression size? i.e if this 100 MB
> compresses to 25 MB, then you're only freeing 25 MB?
> 
> I'm ok-ish with this, but can you document it?

That's a good point. I think pre-compressed size doesn't make sense to
be honest. We should care about how much memory we are actually trying
to save by doing writeback here.

The pre-compressed size is only useful in determining the blast radius,
how many actual pages are going to have slower page faults now. But
then, I don't think there's a reasonable way for userspace to decide
that.

I understand passing in the compressed size is tricky because we need to
keep track of the size of the compressed pages we end up writing back,
but it should be doable.

If we really want pre-compressed size here, then yes we need to make it
very clear, and I vote that we use a separate interface in this case
because memory.reclaim having different meanings for the amount of
memory written to it is extremely counter-intuitive.

> 
> The rest seems solid to me, FWIW. I'll defer to Johannes and Yosry for
> opinions on zswap-only proactive reclaim.

