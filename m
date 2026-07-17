Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09887C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B70126B0088; Fri, 17 Jul 2026 12:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48696B00A7; Fri, 17 Jul 2026 12:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85186B00AB; Fri, 17 Jul 2026 12:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 644086B0088
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:45:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3B831601D2
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:45:19 +0000 (UTC)
X-FDA: 84998843958.04.7EEA860
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2D964100014
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:45:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drhYBjEd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784306718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEgz/CuntGYOStSpXI8ppA6RRWGY8vrtqmOKGB5rJN4=;
	b=q8LasyJwoz3TSVjYlXZTgcGhUGWId9la25xOejnyXfmgFYeKhJtKj3RSdG6PPOzWAzO6Hy
	morABbVIC5IS6+0pnp/W/q3rXowAgIrIevH6TVJAVcUtyRZbcgSKIpPmyOpd9uVPQ5YLqF
	kqPFY9ogRZUL9PwNOWuukXnElNNuuPk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drhYBjEd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784306718;
	b=txz7A0WkGJ0jzWxBvU8LXRVmAOpee0T/mUHney6yff/TkQt016NwTg7vjRI+loqkIA/dWd
	g7Hr0KmLWU+1xIv239LTZoojG5eg20AWKd//m+IX3okmnXuBsv8zplXUdXDdGjxyyPs0Sq
	NValutjhoxpNMxTHvqHs6WJnSU4FEpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E384410B2;
	Fri, 17 Jul 2026 16:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A341F000E9;
	Fri, 17 Jul 2026 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784306716;
	bh=JEgz/CuntGYOStSpXI8ppA6RRWGY8vrtqmOKGB5rJN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=drhYBjEdbIEtNEffOHoK7lQvDmXwU7AqVV16o0gLOjipONy1TPiIEs93jVorFdvNO
	 IAvhXSdVYUIuNpYru36/4waLFeEH8fE5vluUdjmRPsxnUcFvW2/DDiouGo10o3BPyq
	 NTQl7Vhwcfef2QymsWh2eC41M9Fz6mprklcptBCeysB77HbmEcb9uENHzN8tHJkKYc
	 zxKPS6RSVI5qHbNWGxMT5TdcbGCRcw5eg1GrSFwkZFyGjen31Y3LaDDlpUrEd1dmOe
	 Y0tEeEiwV6KSxksr7nW1W/IP3rs/CwBdBU37Jj1z2aPK08/UM646W353D3Ods1ZO9z
	 j7rxK2OEiJgsw==
Date: Fri, 17 Jul 2026 16:45:15 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <alpcFCuIFqP2FCOB@google.com>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717085151.22822-3-jiahao.kernel@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D964100014
X-Stat-Signature: iji85ogz1dydyx5mp6xa6njwd44rr8ah
X-Rspam-User: 
X-HE-Tag: 1784306717-286237
X-HE-Meta: U2FsdGVkX1+lTx7vWcwD+iaSKwKqK05zNmdwqOcEQQJn7B8WedbXcsTxMBF3u53YR+wVOCMFDFBgDce2yTsVAWZ5AQXIzx174vmwDEDi7Io1m6vajQkgfqH9t6VqTpKcE0+RnTooXhnDng8rcIh+Hom9OI+B46wjL2gfooObdisQLD/EtZkUIczqI+YF+1JNw5pDyZWcXvT5DqRlaNuQdqlXAfMf/VDt9v63rd4sP9NSzWq3QosvDxJx+6vS8VLFRa6tgZyvFKjiJvhAdK+VwzAJt6rp7taDt9bZvY9OVUQiqM3slsMDtCjJga3+ZrjFDSzAO7PNx0fTnBGEWpyBA54AEbey5rMqhvKMvP8+lOVopc1RmZth4InikDpW3MIWRsb2+/RGiCtShrI7YIZBppu8ocCgN0wPTZqSdbNM2D5BWJ/DMPSyaLUXRRcQ4PCHc0gdLahRaxRZM8iV8UutS29ZU3TQM2v+bi+5TGEx2hE8JW/kh+AIcl/lZEopASqtO7iwZJcHSK/zqyxig7DecOogz/dFl2p1OmakChtn0D3KkjrpsBgnMqChZ1axd7y9gWhzVCPsU543a2Wzbr33HDrLL1w6x2wfXjRZxlZ2EViAp2yZXaGFQNwo6E+oq0JyXndCewAw5qDIrNvJZiLkMvvHm1MtSL4uATADU2qkwR9ks2pAbR+saag/k28NwFl3ln36PbaacpYjm64K/sMRsGsplJ9EMx7JCa4nPcROZ++X+yofZJgQ51fzdB0TsE6OANIomwYOalSFekzHh9wZS+QyR9dQVrolwcdDcns3vjyk61GVz71pFJowFVvBBalPTKeChqxU82OvaPOH571IMcdJixtCngSTzczlNzDImeuwlXLdZTVfmgUYxlU995h1VyLTkEYc4LvujUbhIu5CdwoUhCnXNzAD/whXaSHFJ+KOEkzDkB+cpj5y9tUNs4Paf3VmKOnbMp645PBf+Bl
 7+21CbvC
 tgDGZuN2UJBWvq+8r7EIVepoR2n7P6zGQJsuIgKIAKiLAVocl7dbEnNYODyiGQ4empOQXS6bFU364PEMlLWI36lTSro9v7dh00Ek7Fwy9OFsH9gzkFwLdCYFGUMuniEA3qOoDE74wxo3pwgSB1vIkYtEKNdxqDgsPvSaVMG19LcOvV5I9Vr/huzfT5etxIsCDSgXUfi9Xv7oe/sZl5prLa/2dm3lFD88UhiWbL70RYOBHFIz9wW6MZzh3PFxmuF2EMhLrWtM1jH+8UevjV3UALcyH8XoHSw6+Ixnisi76OYrbM6neKdhCiMIOaWZWxvm3XOR2R0Ivie40z1+AuPIHmR3rUCjZnF46pgU4saSMNgmH0yRGv3Bg2bGEjkG1djhmEJhhHr80+4q3hLxMiHwZKh2BjxXYlBNGr1yo2iJI6iKMzzKEozP6oVyDs2J/tCspOjJ4kBUkklU3Ce8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Currently, shrink_memcg() writes back at most one entry per-node during
> its traversal. This makes shrink_worker() inefficient, as it must
> repeatedly re-enter shrink_memcg() to make any substantial progress.
> Under high memory pressure, this can cause the writeback speed to be
> too slow to keep up with refaults, leading to zswap store failures and
> forcing pages to skip zswap and go directly to disk, which results in
> an LRU inversion.
> 
> To address this, extend shrink_memcg() and rewrite its LRU iteration logic
> to support batch writeback. Introduce the nr_to_scan parameter to bound how
> many pages are scanned per call. This enables batch writeback in the
> shrink_worker() path, while maintaining a low scan budget in the
> zswap_store() path.
> 
> Test Setup:
> - Total memory: 32 GB.
> - zswap settings: max_pool_percent=1, accept_threshold_percent=50,
>   shrinker_enabled=N.
> 
> Test Case 1:
> Allocate 512MB of anonymous pages and fill them with random data (to avoid
> compression), then use cgroup memory.reclaim to force a large amount of
> anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymous
> page where the first 4 bytes are random numbers and the rest are zeros, and
> then trigger a reclamation of this 4K anonymous page through cgroup
> memory.reclaim. When the pool threshold is reached, shrink_memcg() will
> be triggered.
> The test data after running for 120s is as follows:
>                                 Baseline       Patched
> shrink_worker wakeups              5,363            85
> shrink_memcg calls            11,373,201       180,928
> written_back pages                40,212        40,236
> zswap_store calls                161,190       168,741
>    store succeeded (ret=1)       102,743       127,644
>    store rejected (ret=0)         58,447        41,097
>    store reject rate                ~36%          ~24%
> pool_limit_hit delta              55,826        14,062
> pswpout                           98,659        81,333
> pswpin                                 2             1
> 
> Test Case 2:
> To consistently force zswap store failures and trigger shrink_worker(),
> the following stress-ng command was run for 120 seconds within a cgroup
> limited to a memory.max of 1G:
>    bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
>    exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
> 120s -q'
> The test data after running for 120s is as follows:
>                                 Baseline       Patched
> shrink_worker wakeups              5,640           987
> shrink_memcg calls             8,481,500     2,504,818
> written_back pages                   260       768,576
> zswap_store calls              2,742,756     2,301,414
>    store succeeded (ret=1)       934,640     1,308,686
>    store rejected (ret=0)      1,808,116       992,728
>    store reject rate                ~66%          ~43%
> pool_limit_hit delta           1,181,310       101,593
> pswpout                        1,808,376     1,761,304
> pswpin                         4,288,497     3,902,658
> 
> Under identical workloads and runtimes, batching the zswap shrinker
> exhibits a significant reduction in both shrink_worker wakeups and
> shrink_memcg calls. Furthermore, the sharp drop in both pool_limit_hit
> and zswap_store rejections demonstrates that batching the zswap shrinker
> effectively mitigates zswap_store failures caused by hitting the pool
> limit. This significantly prevents pages from bypassing zswap and falling
> back directly to disk, thereby reducing LRU inversion.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

