Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09974CA5FE1
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 00:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66436B0005; Sat, 17 Jan 2026 19:31:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26DE6B0089; Sat, 17 Jan 2026 19:31:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D056B008A; Sat, 17 Jan 2026 19:31:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 937FC6B0005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 19:31:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CA64590CF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:31:22 +0000 (UTC)
X-FDA: 84343205604.25.D411073
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CE7140008
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 00:31:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gi1Zp6ug;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768696280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y71L8gBblqC5DHID0WPWlWL3f+ctkgtsC30cK08O62w=;
	b=qp0qQ9d7A5Aou/C5MsmANPZeoUg+8oEDJDEo2xvOeY8aX64kQDKKy4AgonUVIOM/oFVhuY
	7wwPdtkV3tb3MDrOoNxMmhR18Wjg/WNPu6+DmDAOfsWXMmRZT3hY//OBfWYSjEz8Bjc6j1
	neK1sWywEz0acnf/7yCNCREVNGG8nGY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gi1Zp6ug;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768696280; a=rsa-sha256;
	cv=none;
	b=w93yeio0O9sm9O0wBpZK6A8LLeNZeDxijKAUfTX+8jLR8pMYjr1b8KN7ne6py6kT7l+tAW
	YB0skX2KsNNZ35g6IG9fzlNzRSgrhenk6LBRs807fIe34G0lnNku01erf5s2r4ub8OqpUs
	1hKExFJPGulf76cmB27RMWlitzWfYJ8=
Date: Sat, 17 Jan 2026 16:31:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768696277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y71L8gBblqC5DHID0WPWlWL3f+ctkgtsC30cK08O62w=;
	b=Gi1Zp6ugkmez3FJ3H3PlYo/cUrHAVY9VqxvRxShl1ZYlbgxNlVqNYP0GNcx+SgSaB0xEMy
	m4ZVzIRsTdh20KpQeyaOHqhtaAL7Ac9FqCfFs5rEesAykpUdR5rspBUkEixgWXawKrrHCZ
	EX0S6AfzG6uiCRhq60WDzAVQYJLhGbE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 08/30] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <qdfq2vxdma4qnt7pyfvuiyiib6ffuv46jyqsfgab643ihzttb6@h4hodwsqkmom>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c8eba771ab90d03f4c024c2384b8342ec41452.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9rok5sbzauq1dzu9z4r17kzbzupc6htr
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CE7140008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768696279-730363
X-HE-Meta: U2FsdGVkX1834y1ndgRdkUkuiAxv28x7ub2/dHLaRidZco2kxJ54o5VUknivAPWazFXvnCiK6/jCOGzUQiyGVF84+Z6rA8Q2CbgcDGwZaBhn4D1neP/QSEWYOkE8T2PXTYyoAKj0lmO2OUaGNW/GlgfucIQ0YXves15GxH6hFWKWohnwjx61NMkx2MWfvqJ5pYcCpnEwZyPR/YccbdIwLS4L5AU1JcfFzSZG51ot9IVcF62xGdGbUevajCYlaqQ0UW/f2BWJQBfBfuDliaEyU8xcBMmduO0x6M4m1Kq12Vr+tHUWOEDS266MGU4fWBh3Pkw+7txGvMc02wiX+0N2geIlolWBnl4gO+7ojp37YrGlo6yC+OPoEjC5Y2hs825tUJZe9rDe8RCThevjXI422/XJ52QjUTpj34pzs88Rb2s5vG3oMZdnfrGV3k8b541O1aYphWaDxZhbkCri9+MAX03ewLyS8HMSAvHE2Nb44bnIVqPMABG7kmCxfE62TpyTQJwX6TIoZDFrUwbAdx2LBL/KAg/EFit8SjnJQoexYWbZDqqK/m02AVu5vZNYAnIpuF/dh7Ldc49nyb2sXysHpAii13kK8PgfPiektPwpHmfG/561VUewMWm3UWLsOpvjeCFVXKuBB3skfsnVEXX41JPtELlfy8ycOiUwOFeDHyG4jOfklLMUjJZAQUPpkuQev9ZFPb8vzeylgmPcXsyAlahW3Qf+RdLm4PE8feywcKejQiVmeEKU0+PWyetOa/0nU+lhRO3gmmt4diLtF4uMSbyjgb51bdSX4dCQiYlianmT4doohTYdsZ7jWkZ1eYf0QDIkl3tNJ4mWLxwm6L+YxJAYVUvm6iJYbq/76DoN1AgO/KOszGMJJYEFcUx3xgBETMtv2z92csyT2BGhoMX2QuOyYg5yP+3SOjUMnN83h0BERyeFUCbqiL0sOCzdBljm03Xo2JxFk+Uh/0kzuVb
 e4VWFH7R
 TMI62czzhAxjQL25gZ3SECn7605kufbhmwueP5Po6V5M+/aBEYVaxeZazTZg3bL+cNUPYqzgz8JFGQsQ/yussQiEDuFYzs7dZcyoA9LneB0OAOqkEnwnBEV7BLYq3OEd8s2e0yX9DRr69fcyAUI/mOG0MxYORGHd9OTLs1nnvxX5c0OjH3gl0TFg2oos0hJTKgX0ApoQuCjVfKdIu8qRGPv6tpGZT1CHxugr/QdzADVnm4pQqECrtHqSoESvqJGw1N15B8hn9lBTvJ66p1EH38Hwu8oBIVxx1sXRjJT/u32XNv5OiU7txFfTBClvtdmxLPAh8GaTMJMkSS4U24oYH4Ge5BeJYW+X+HKlVNdjn7V7Tp4pFUFS4W4pJGxig3OrCoz2B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:35PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in get_mem_cgroup_from_folio().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 982c9f5cf72cb..0458fc2e810ff 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -991,14 +991,18 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>   */
>  struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
>  {
> -	struct mem_cgroup *memcg = folio_memcg(folio);
> +	struct mem_cgroup *memcg;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> +	if (!folio_memcg_charged(folio))
> +		return root_mem_cgroup;
> +
>  	rcu_read_lock();
> -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -		memcg = root_mem_cgroup;
> +	do {
> +		memcg = folio_memcg(folio);
> +	} while (unlikely(!css_tryget(&memcg->css)));

I went back to [1] where AI raised the following concern which I want to
address:

> If css_tryget() fails (e.g. refcount is 0), this loop spins indefinitely
> with the RCU read lock held. Is it guaranteed that folio_memcg() will
> return a different, alive memcg in subsequent iterations?

Will css_tryget() ever fail for the memcg returned by folio_memcg()?
Let's suppose memcg of a given folio is being offlined. The objcg
reparenting happens in memcg_reparent_objcgs() which is called in
offline_css() chain and we know that the offline context holds a
reference on the css being offlined (see css_killed_work_fn()).

Also let's suppose the offline process has the last reference on the
memcg's css. Now we have following two scenarios:

Scenario 1:

get_mem_cgroup_from_folio()		css_killed_work_fn()
  memcg = folio_memcg(folio)		  offline_css(css)
  					    memcg_reparent_objcgs()
  css_tryget(memcg)
  					  css_put(css)

In the above case css_tryget() will not fail.


Scenario 2:

get_mem_cgroup_from_folio()		css_killed_work_fn()
  memcg = folio_memcg(folio)		  offline_css(css)
  					    memcg_reparent_objcgs()
  					  css_put(css) // last reference
  css_tryget(memcg)
  // retry on failure

In the above case the context in get_mem_cgroup_from_folio() will retry
and will get different memcg during reparenting happening before the
last css_put(css).

So, I think we are good and AI is mistaken.

Folks, please check if I missed something.

>
> If the folio is isolated (e.g. via migrate_misplaced_folio()), it might be
> missed by reparenting logic that iterates LRU lists.

LRU isolation will not impact reparenting logic, so we can discount this
as well.

> In that case, the
> folio would continue pointing to the dying memcg, leading to a hard lockup.
>
> Also, folio_memcg() calls __folio_memcg(), which reads folio->memcg_data
> without READ_ONCE().

Oh I think I know why AI is confused. It is because it is looking at
folio->memcg i.e. state with this patch only and not the state after the
series. In the current state the folio holds the reference on memcg, so
css_tryget() will never fail.

> Since this loop waits for memcg_data to be updated
> by another CPU (reparenting), could the compiler hoist the load out of
> the loop, preventing the update from being seen?
>
> Finally, the previous code fell back to root_mem_cgroup on failure. Is it
> safe to remove that fallback? If css_tryget() fails unexpectedly, hanging
> seems more severe than the previous behavior of warning and falling back.

[1] https://lore.kernel.org/all/7ia4ldikrbsj.fsf@castle.c.googlers.com/



