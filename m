Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A72FEA830
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56E26B008A; Wed, 25 Mar 2026 03:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07756B008C; Wed, 25 Mar 2026 03:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D7A6B0093; Wed, 25 Mar 2026 03:50:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B15596B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:50:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4243BBADE1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:50:16 +0000 (UTC)
X-FDA: 84583812432.29.A40F0E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 860C54000D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:50:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gtagggpx;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774425014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+fiJ+jhRg9QBU4ZpgZdNDn7+C4EtH3olA4dFFv4NCBM=;
	b=jWedmCxuNTB+SfEMmwGdwK4jnQZbWxEHTmPuzwzuMZf1L4qnPd5io0ZpxdyDbE+Sx2z6wp
	8h6M7mzTGWuHZ0PaS/8RwlTq15WRzBceVrCfQWKGDb//L6Mh8c8IU4rDrIhPBgUeHOver9
	OzVB3OdEEuShOrW0s0EMD/ivOOe5X10=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gtagggpx;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774425014; a=rsa-sha256;
	cv=none;
	b=Rp0lDqukYasRTRzaN1ke8T7et4nZ2+muk0j4q/u5SFj0i5bCwxxxCR9BFDNiSwNBSZLGgb
	DTMm5KqJQx1630Hy7g5+AHDx/bjFpYvVUpy6W1eDsP+KF+jcmbbnM01h0FejWB+bXHPgrk
	Oh5WYGFK8AxXTunwH938/ZTt7jxo2ws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E88DB600AC;
	Wed, 25 Mar 2026 07:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20FDC4CEF7;
	Wed, 25 Mar 2026 07:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774425013;
	bh=4q3lt84y5xkJHX2NvqLyOD8t9dOLT0rNNkE7iPIURaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gtagggpxwErZ7dDLrjYSUDCGIJ2Ntm7OBqIp2QanYz85t2kv8I7J12rhY1ig0mvFI
	 B6h5OW+ikTfI2BUZisXxQ4tA/XWL8BS6QLB9fI0us1uujV3qIWR/BBgqlRx9rGYhKJ
	 rukDSeA6eUvedu1HNtto2lJCinvFuAJEIiovd7VUST/9h2CEgPZJw5rVwSB8/UXE8F
	 pnck5C0jWVEQnsKIjtszrf3mo+PbCdU/s9AyNq2v++xUPJ/FUzR61yy8Xqfry3xcj0
	 5yYxc+xRTU4Z2/QO0p2P4pSB1ZSGKMQnaCclCB+8r5XBwOMrk+YOslxnl4ANCfs0eK
	 UOkqm6H20LmWg==
Message-ID: <ff139493-1964-4285-947d-1b43fe40f8e5@kernel.org>
Date: Wed, 25 Mar 2026 08:50:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
Content-Language: en-US
To: Jann Horn <jannh@google.com>, Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 860C54000D
X-Stat-Signature: 6fmx964m7gw65ibp9qqr694otayyrc33
X-Rspam-User: 
X-HE-Tag: 1774425014-543687
X-HE-Meta: U2FsdGVkX1/H7CdbNpmIOX1THGIRD+/ZXTsQMICAkiMubK0ko0gzfhF3B5rIC/2WHoBJP0F1Sudo9wyBCkiN+pIGwmU+XrOXEHxwCHEeF481p/HcplQJ0aOcKDSNqOhTLzzfyeQWTGolBTLZWiRlsdAxS3/v7fVj+KjTyEiirh8Hxp1OtSGuJkZDuG1vf44UBx7HwiBPjuRzBtm1CN14ust7XaHPHxkXZeZiNgVAllVkt5v7/oAwu7dwDOMqVacLfAdmay3wzzaQMllj/tpuA5hVHRgwL5AqUuwTclaOeTYcauVw8VUs3IPDC/T2rsSg6eRjxXyhsP+oC9E5zKZHTmq5rMlSOblnVeKijZvMhT3LhUN3oohBxoQzStMbV7C/JWQQ3ToGCuwlzmFv61RoBNHfesgv3bGzoE+bKhOrMgmNUTsqbmpJAY+hFpAOvRz/Dj9HThyKEg81VF2pKfTf99cMidS+lPTw6ZuJA4DGRFnQccEa4fMUIqn6ZDjDcybfXQGShXXhYVCYYpirtjd65mASAi5CVhPKixBN+BX97Uz6AMZfp0LL7B7YiHtLea9tppPTX3vi5DcQh5IAKytgvUqKBNOaGYhaWEJGvcsmCE7K3Q4kN/742Odm4/L3jEJ4nCeH1vQiy0vyunalwf/2qoqLho7BO3Xi1SIe8q+ZB/X40+wo44aBhj5rxIJzcv7uT1jO4t1QaBts0n5kFjaJn7EHfuCBQQona3JrIryP7RLGdfLU1JN7fmvQMuJ6b0V5Na35rLQxynWd93xAP6VgAEvkrUKFfHVXYgUgnaUeh/XR6WBZgSmbwUTT4V/DMKOq6Z1Z7EckOSkOlatGvaoA91aZHWC3a7Mn6c1YlsZbZBrUZXJSaM8xSQPpgIlamg5HeIgQZeHiIs0MCCd9yqzfsI4xJVQfRDRryhk7O5j6psPb2p00m+DL4WmWwzrttiDy8tQs10h8rcpfgp1nyZ1
 43rar4jT
 RZGm+4KP/+QnQKx4RTausKuUrmtMfTVmrsBDyo3D/hoMqnPdwPICyGTSrDAC/Dee5Li/bS0l1j/NHZIjaNqxltVCGT3sDk7ObfblhEgj7M6xTTCgDuqc4wF/eHpR+kU3Yyh3Y/A06/ERzRQ58Vw0cAyURVIWElHiO/gQ3TT8IjhzVn2q5JxBS7UniAiHmT2L1AQEd9ogwBwKbt8gPw/N0neuvsOgWBHlVz/WjrB/a9iwuefTUP9lIKgqrkucRWhy+QiiEJ4JVVe+2E1qaD4y0McApWshxTkpOPFq+aXxh8IWT/bapqy8xdh9nsFyyjddGjSr+sUrA5w6L208=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 22:35, Jann Horn wrote:
> Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> so that kernel fuzzers have an easier time finding use-after-free involving
> kfree_rcu().
> 
> The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> callbacks and free objects as soon as possible (at a large performance
> cost) so that kernel fuzzers and such have an easier time detecting
> use-after-free bugs in objects with RCU lifetime.
> 
> CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> expedite; for example, the following testcase doesn't trigger a KASAN splat
> when CONFIG_KVFREE_RCU_BATCHED is enabled:
> ```
> struct foo_struct {
>   struct rcu_head rcu;
>   int a;
> };
> struct foo_struct *foo = kmalloc(sizeof(*foo),
>     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> 
> pr_info("%s: calling kfree_rcu()\n", __func__);
> kfree_rcu(foo, rcu);
> msleep(10);
> pr_info("%s: start UAF access\n", __func__);
> READ_ONCE(foo->a);
> pr_info("%s: end UAF access\n", __func__);
> ```
> 
> Signed-off-by: Jann Horn <jannh@google.com>

Hm but with 7.0 we have sheaves everywhere including kmalloc caches, and
there's a percpu rcu_free sheaf collecting kfree_rcu'd objects. Only when
it's full it's submitted to call_rcu() where the callback rcu_free_sheaf()
runs slab_free_hook() including kasan hooks etc. If there's nothing filling
the rcu_free sheaf, the objects can sit there possibly indefinitely.

That means CONFIG_KVFREE_RCU_BATCHED now handles only the rare cases where
kfree_rcu() to the rcu_free sheaf fails (and I still owe it to Ulad to do
something about this).

So to complete the intent of this patch, we should perhaps also skip the
rcu_free sheaf with RCU_STRICT_GRACE_PERIOD? (or with !KVFREE_RCU_BATCHED
perhaps as it's also a form of batching).

But then I wonder if the testcase in the changelog appeared to be fixed with
this patch on a 7.0-rcX kernel (base-commit: below is rc3+) because by my
understanding it shouldn't have been. (unless there happened to be enough
kfree_rcu() activity on that cpu+kmalloc cache combination, so that the
rcu_free sheaf got submitted withing that msleep(10)).

> ---
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..67a72fe89186 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -172,6 +172,7 @@ config SLUB
>  config KVFREE_RCU_BATCHED
>  	def_bool y
>  	depends on !SLUB_TINY && !TINY_RCU
> +	depends on !RCU_STRICT_GRACE_PERIOD
>  
>  config SLUB_TINY
>  	bool "Configure for minimal memory footprint"
> 
> ---
> base-commit: b29fb8829bff243512bb8c8908fd39406f9fd4c3
> change-id: 20260324-kasan-kfree-rcu-4e7f490237ef
> 
> --  
> Jann Horn <jannh@google.com>
> 


