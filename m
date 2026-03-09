Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2965EFCD9A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0895E6B0089; Mon,  9 Mar 2026 07:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C426B008A; Mon,  9 Mar 2026 07:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5B096B008C; Mon,  9 Mar 2026 07:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D53E96B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:33:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D3E8B5D09
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:33:46 +0000 (UTC)
X-FDA: 84526314852.28.044F613
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id CEAE640006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:33:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FUReVhKm;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773056025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZdc7LG7ZYkmcqRXQcEuwYKpiDy0yyiOVu0PO+EX6Pg=;
	b=3cHLaGqe+Pc0I3gZlui6er6eFO/gJ+hSvJs4E5SYHM/PFsxq1W4e3TCZT0UGars3v/tRLK
	YzQMTn7AM2DpfYyt/X0BcR61ppWV7jw7ayPqwIHxQCbVBabUkbFW1kWxfBREihsOPdVJtG
	ZAk/hjfJzDEOyAWn2uPj4H3VE1qDOOs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FUReVhKm;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773056025; a=rsa-sha256;
	cv=none;
	b=r4CG+xrmr3sDrkJqgGtnJlFkasSwIAk7DBXwYfYBZZZoFXRkZXsOMRhs8WLxWQbhiEbdvM
	4jcB+SMcto1bLcgm08mFvTUiSfzvfbonk6XoSGgIMMEIzAa9qv94/bs1U8pd7bIYzU1Jg1
	gYg+2LC292drOuzJ+m2sCBvhcjawyww=
Message-ID: <b26f48f1-c311-463c-be17-7384ca27c7c8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773056023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cZdc7LG7ZYkmcqRXQcEuwYKpiDy0yyiOVu0PO+EX6Pg=;
	b=FUReVhKmfpOpc9YHORo2h3+9SXjqXPHjJFQO5zvtyq3Z39iHLE1TxI9ctFAfiqbmPOZdDa
	w4CBNH+BqrCNTjtV84dpKUkGVjULP+mnrp4CfpKSFgpkSqJ7kBibOCJbCQj7PyG9FE/W+n
	IxASUlf+CmUZ/JhmFo3RnnJt0FcrFbI=
Date: Mon, 9 Mar 2026 14:33:33 +0300
MIME-Version: 1.0
Subject: Re: [PATCH] fix: mm: memcontrol: convert objcg to be per-memcg
 per-node type
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com>
 <20260309112939.31937-1-qi.zheng@linux.dev>
Content-Language: en-GB
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260309112939.31937-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CEAE640006
X-Rspamd-Server: rspam07
X-Stat-Signature: qihkz8n3m5j4ib5tisc3osuph9bfpmok
X-Rspam-User: 
X-HE-Tag: 1773056024-11656
X-HE-Meta: U2FsdGVkX1//dE08MIpqbxY1y4rzWqyfRyPM8afN6HWXugWw1KzacVTHJdgfePd0RhysGbvXdiSOoMwZhMBh9BBqZU5wBfI1G/U67EQjhyen8yCeNbnRxGUQu42y6gMUKCdfouR155W28rKkS0p5xfXgsILzYb3JMxpVSg3gkviZGG7cgCZ8JGH+rYTNxIBuQjK2basZrqKomxZS0Y71RO3j88CuB53uRI8nOhuHr2kA4ANVvpwixgZdI6Hk/gOn6jcYUirtuFQrT/WBhyGQ2Z+Gex+2yOjXhIml4hiMhVJ0GxmNRBWWzRYAHwWW/pyH75hwtjLT3nthLHPl3J1b/YNTXZ8aU3IjySuZvSvHxEXkqhdlWNs00RFXKZ6sTSqVsRueNnCcXKMLk7iM3Mwxr5IFCQOpmP0ovBNMbmRV4MZCxF0/0uW98+aA7IEsk/4iPsqlJ134qwP+h2IBQFUDKlT7BjkWqOzBjWMfV0V6BYMk/MSdPKWnjCfsYhF7AmwjiTm2s2JS5CdteXwZEugNkgAmTJ+iTT2Q89RqANZN8W2lgiGLeda2RmCiwOeqDKVH66kbhFQaEPvnXTAbhNpssHefN8X5kf31nLUAZzU8eHZXwwB28WSj1Mwe3VogumOHsBu5cSXe6/d+LkeqnGEhnaQnH8j52PfnHh5+reE4fluSuBjNwibxGNpPUm/UzmESAVVO7ZJuSk+YwtdaaMxJrOH7/Bk0z9bgC2v4L6VRoPgAuW6/tvgH9pSjgqEK6PIkppYdMfM73EFhugC6EXMFbeynvytyZ9F9DB2EJfzfgDc1eck5MGEVIMBIstIWlE7/uXsJ7JUoXG4e0LcI/PM0SotBITv28CQ0u4jrkSLNrJTPRCMGqzkfILpkDThQr9eMQCtwGUYfDwT6wYDctLkNcTR+UI5qLT71njaOp9CRIVuVWfBeq5zmevpv1+Sgnc5QwrAmRQWNiAsvz8a3l8y
 6Rf2dLMI
 odSZbXbQdKxoWtr+XMJIIoa8l3OeoQZaNOMDdmjAo7x5ymVYPGBguJz5gLhCTfKvDfSWqyE3Yv1fl9XRDI01z0tAA+sKZqvOZqE7AATeVN9ZgCJI2y3vTqmAkn996LIUWVNEtvaO5fy2RjyuoJprC4EVKFNaI9avaqcXDaMtaMgpUHDuyiYNPoScouAnCDbV3VGtezeOCesdVl0ackK0Hd26PvgKRk+d/PAoFbJsMeSP6vpo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/03/2026 14:29, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
> from being called agagin in __mem_cgroup_free().
> 
> Reported-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 992a3f5caa62b..ad32639ea5959 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4140,8 +4140,14 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	for_each_node(nid) {
>  		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
>  
> -		if (pn && pn->orig_objcg)
> +		if (pn && pn->orig_objcg) {
>  			obj_cgroup_put(pn->orig_objcg);
> +			/*
> +			 * Reset pn->orig_objcg to NULL to prevent obj_cgroup_put()
> +			 * from being called agagin in __mem_cgroup_free().

nit: s/agagin/again/

Apart from the nit.

Acked-by: Usama Arif <usama.arif@linux.dev>

> +			 */
> +			pn->orig_objcg = NULL;
> +		}
>  	}
>  	free_shrinker_info(memcg);
>  offline_kmem:


