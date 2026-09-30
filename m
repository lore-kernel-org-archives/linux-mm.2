Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809C3CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 10:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774586B0088; Wed, 30 Sep 2026 06:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725476B0092; Wed, 30 Sep 2026 06:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B926B0096; Wed, 30 Sep 2026 06:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40AA96B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:33:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA2E5A7290
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:33:42 +0000 (UTC)
X-FDA: 85270067484.02.E2CFA38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F483A0005
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:33:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFYtGKpD;
	spf=pass (imf25.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790764421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DHevYFtTq9LXip3P6yx2LmGPrDIe2gZf1mJcG2SySg=;
	b=kgyxG6vp+beZf4kc/RBR708WcG46IlMH7oQhpqXwwIYjD100sFLelXi2YiDI4d3KhhIb3l
	roZ/6D+e3aUku1z20TlDNO23+cFH0OVaKUez5AZk2VXeB54BH/5HMMplc9oS/f3p1zfN31
	a9/HQeaZOn3NflNH5jGgRcen8CQ9Vi0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790764421;
	b=C8GD8RqyGaQUQxG0j9quJit0LjgWi6nT75S4hIKaPwBVDOZEMqNqlkLTlu0fBYU3gGTm0F
	qt49fGNOXfHw7TLx/n1eaFSXwvBgkGfzyOyimrneC3j1FYo8YkiECGudhJg+zKi21X0FOR
	oS553CkrDPzZWiT+tstAHycpi3J4EQY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mFYtGKpD;
	spf=pass (imf25.hostedemail.com: domain of xiang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAA5A60236;
	Wed, 30 Sep 2026 10:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7321F000FF;
	Wed, 30 Sep 2026 10:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790764420;
	bh=+DHevYFtTq9LXip3P6yx2LmGPrDIe2gZf1mJcG2SySg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mFYtGKpDX0b9KjPmZS692yinOoPah6ZGGq0I1FramSDyXTiA7QYBhBVI/JblfVCfr
	 N57pJP5APLX6fXbpxyr4r/3q72ud866zC8eDGWyH95Sy2BrvvNZpGW4WAW356UJ/JG
	 2laHbLBfqLu/EvUNG2afTr6QYgcVIXFJbCDhQPubqAf4Xr9zPpZTfwQE0QkvsuIxxp
	 ssMKDyL6dwhgqaxlnvnJncyNWYTqjTfBsEJt9lkDJG/HxtXSOhga4P2W0xTW9w7BHZ
	 w8N1xYJZYAKmabHd63kHkYjxZWrJ6NxdQ2MMo6qBPV5Q2IRZSkmtg9EhMo8PyVPQcV
	 e0e4IPAjn50vA==
Date: Wed, 30 Sep 2026 12:33:33 +0200
From: Gao Xiang <xiang@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Gao Xiang <xiang@kernel.org>, Jialiang Huang <huang-jl@deepseek.com>,
	lance.yang@linux.dev, baohua@kernel.org, damon@lists.linux.dev,
	david@kernel.org, kunwu.chan@gmail.com, lianux.mm@gmail.com,
	linux-mm@kvack.org, mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
	virtualization@lists.linux.dev, xueyuan.chen21@gmail.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <arzlfSOgtC-CLoZt@MacBookPro>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
 <ary5Nn9le4xG7_-N@MacBookPro>
 <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
X-Rspam-User: 
X-Stat-Signature: jatszfcje9j6557hqxrqqcgh4xhknhxx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3F483A0005
X-HE-Tag: 1790764421-512836
X-HE-Meta: U2FsdGVkX1+zbtj5hg74Wg/EyazgAaZm7eNZp1ox72WdG/Jr2ME/JiRds0Z4sj2YYW6pY2slJ/hSkOLUwytLPDtbMz/CR0eXNgnCaec49bkp2Z/UWL2c/WjXoAiD/9qrblYKhfZ+/pd+0fVebwNztDtMvaMttZW0BQynEWrCIdj12GhgZop2+JAotB1cQ8+6xTiSTEGdS6EkKP7QEODwgr0t99EuHU3AP7ma42ZV75zU73niKmcLX5eJIm8OjgMPWMPh3Ccps/Z9+P/sLypVwW59gBioab9uI0FqFxv8l02khftANYmfOuZx8FQlt9Wh/Zon10ZomDmYqxuBdlwseQCluYg+/U5KN8IYTXlSrVYO+GAW7glsn8D2mrKqjv99BzIb0m6QkbVTUIeGDNQFmTjIFWT1tGGM2sWufOyUTGkDsYdbMukXu8kd+P2mFYiL9XyfulKHcDMi2a08vLTuSa7EhFcN1/1N9Jc+NIAPvehq2Bf8AsHsop04ZzLNeR5CqZ3dChThT8b/jCHQ1nHX9D9B0VK791rSyGO2NQsnJ5U0wVY4ndNnuh1pJH2DE5z3zH/uw27eAq7ptkC7kBnsDlCawx8vCA6zQSbylGBiRCM2lo/vkziyjgcbebTRn6zOupCXcDc6MaAVicyklIinPP2bNC1jziN5IJu75VI1+gu3VlGr2braABXWStewLzKuyJ7F8jc90G/23u1qkX8biNYE0QSZb0mRiJPStG/terEv0aj8AMakehgaAord+YZM+gQ3wmbqnmq92ngMwh8eHqEyWhlM3EN+WcNzDqmKyoumgKMyAZk4sgixzkNh3HABEPdgPRB+jG0ElnDraSQx5HNFH8i2mwcCGSiUydc+wiOhtM1a7/OxeVLlbZ3wkgaozExFs0FxP6zWHZCsSGuszfN1xzhjqpYepFwMFON/RIo0r3DMJEP3ID+TVfHnz29NN7xqT5Werl6DGUorh4O
 04hfGRFp
 A0ltF0HHHVJSEC6VEWxQq3av+c56Pi7peSuHZrIZkN28FMUr28nTEWEwCRPs6OT5/ui7X1LS5nFG72wzwtmcx/iVh5ZVJYHWY3SH/R+3wcWajRi8dpu5AF3yoLFyWZMWt0HpD0UkJY+wE6lLwk+xq/qJ1J+tjA3F98gITQVCjCb2AgEsKt0apM789UvrkBCm72i2sYYJ50NrooXDKez2vktkzwkohSBk+G1s03oCGITC5Xs9Q8ujWkwTt3nnuugqX0085y390x+V1zsk4z758zEvLCCS883QkOC4QJ+AqkII2treFeHyhdZKVZnGvupGM6uKIy52xSJ6M7WRfXtotmfeuMmEX4Fxv0mS3hQ3fkqrfC6jVUnMUiiTNrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 05:37:11PM +0800, Muchun Song wrote:
> 

...

> 
> > 
> > Anyway, it'd be better to get some numbers with RL or agent workloads
> > (especially the host memory is under reasonable pressure) before
> > landing all these new infras upstream if proceeding in this way.
> 
> At least for now, as far as I'm concerned, I don't intend to land all the
> features mentioned here. The first thing I want to address is on-demand
> allocation of struct page.

From my point of view, on-demend allocation of `struct page` for FSDAX
is indeed useful and can be landed upstream, mainly because `struct page`
initialization takes much long time for large FSDAX devices even a small
range is used, that impacts the guest startup time a lot.

But in order to make it safe for production, I suggest reserve the
guest memory in advance for the worst cases of `struct page` at the first
stage, otherwise it could cause unexpected issues for many guest workloads:
it's hard to perdict if the guest memory is still enough, it's unfriendly
to system designers as well (that would completely based on their
experience and hard to ensure the service quality beforehand.)

Since the guest memory for `struct page` is touched on-demand, the memory
over-committing on the host is still workable, the memory reservation
can be removed after the reclaim path is done.

Thanks,
Gao Xiang


> 
> Thanks,
> Muchun
> 
> > 
> > Thanks,
> > Gao Xiang
> 
> 

