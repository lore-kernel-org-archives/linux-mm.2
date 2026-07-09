Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05281C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE40A6B00A9; Thu,  9 Jul 2026 14:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC4C6B00AB; Thu,  9 Jul 2026 14:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3A86B00AC; Thu,  9 Jul 2026 14:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9242B6B00A9
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:22:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BAE61401E4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:22:52 +0000 (UTC)
X-FDA: 84970059384.25.BD61381
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 44B5EC0007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:22:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPmrjvqA;
	spf=pass (imf10.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783621369;
	b=itzQu1PY49W8C0Uh2eB4iT3mbxi3VehodeSdkrEjImMUW+r1KlZjuQuKsYDlFj43pxRBKB
	vhlfKtfC6qBfVKhyVJFLill1vH/wSPoC4hdnVboQHItGIFOIARmuN9STIgYGpq3s/nACFf
	JcT1TaCu3RcLt9vmAvqpNsHFkQX/rRQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPmrjvqA;
	spf=pass (imf10.hostedemail.com: domain of dave.jiang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783621369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+H3hJf63T6C4VnzXfjUdDuFHeC93G6M1XPLd+xR+Zc=;
	b=YlColuS6TLnNz5Waho6ETV/Zm+LtL5mOkNBu30fWpMYaazDCSDIcg27iQ+hO6yMQnifZVG
	VJODTmWjtqUUStK8e1pyte3N+IXfMm2JE7197q5VzcdVEmxgDhDTxo5yWOETjEEYIhLLIg
	UFgRZ2qV9kL44BRVQdvgvvAxC4DVwUk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783621369; x=1815157369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J2V7pKlJhKQawZoorNAwgpGNERi+fNljDDAyDSdjiqQ=;
  b=DPmrjvqAWj/QE/Wnpe7yytnO165A8qNjFevOrC9/B3/Y3Jtldwfppllu
   rr4DoU1/WqSyq8mpaRbZ2DBjiHukJuPY3ymEY7Ek2yXtresIP3yCat4Y4
   OEseNMyF5ic1c4DmfBMuZgnI02kcqrBdg4EDaVuxRXf8/sM8nqSbJmtPg
   a7FXDR6hYo0KchGeYm3MUu3shv52cHppHHR6KL/NWID8050bzLMyTw4I/
   jbxYl9uwKSDAyhk7bnij9IkGLv/mgEwsOfAy7Qx8NjEHSLp1yPEDX/v3a
   8U0dWYPFUmXUfNSQkK7MvahynDCuxAiJ+biJuCYBAWRg2xMqRr2kBK4nZ
   Q==;
X-CSE-ConnectionGUID: 74pGml/HSzq2AkicIDL/hA==
X-CSE-MsgGUID: JYjI8dqMRP2Vo4pYjZ6+6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88231500"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88231500"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:22:47 -0700
X-CSE-ConnectionGUID: FjvWRgBjQ9WWQi8JEzfF4g==
X-CSE-MsgGUID: ovSS3j6bR8axoTyoJ0LHhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="256578857"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:22:45 -0700
Message-ID: <fc78da27-d642-460c-99f1-35b2fdf11913@intel.com>
Date: Thu, 9 Jul 2026 11:22:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/10] mm/memory_hotplug: pass online_type to
 online_memory_block() via arg
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
 Pankaj Gupta <pankaj.gupta@amd.com>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-4-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44B5EC0007
X-Stat-Signature: 1khri4c8ddo5e1u99yyp1hzoat8oxqg5
X-HE-Tag: 1783621369-649013
X-HE-Meta: U2FsdGVkX19FjLX3KtJL2uik2bNRgRUwSY5KKiabmIW47LTmuWtVxUgIMU+ZFt/Q2zhJGOkUmYgOFM9anK8aNWS0tp6LtojtUdjArE3LxaxvNEPm9NCGj1Uv01AilDZ97s1Qw+yQqh+T/ssjFzxIpCT059j8LHs0ZReEi2Sl/uBRFQveB4kcr5j3mRplBZ2bhmBCL8f/rwA7X9vP0vwPg5LTEC4KwNdajTQeQI+ybx8WKEmqODpbzUnb4Ei8y1xdabX/M18tRR2a5rmS7xcw40p7WaHQDxXBmAErc31y7UbJsHs8DezVliiwzdnwhESb3iDgWun4EPMpYyKM2NYblvgQD+qcuEClK9fN1P/UX6ZSGdGRMECX7DrO9r2bYmR/djrjVqLKv3vtrkXCXFClomnJT+o4jMPz0Tq158ofbWi7B/34HtEYvwBBW+5MLWNG7uxG0WGnH19rxOapiZOOhUcb9aINZRNTFz/GuZRFwnv275EQENkNbJ5VUO551hdLeBU+eSN2QUcRbtuXEHe4FvPczTzt0TQYwXkOExUbISFESFcpvbZ6vDn3IO8ptXSvZ+NoOOhomOH0N/ZvFpirlQY+PTzgfN8/USO8btj50WyDTzTVTVuNu3q0/9MBFuBBVrP1QJfOKbyxkgdjrS9M6KfXJJmO4gbUkIRLXVI+vwmuX09hy5Tb5Co5E+hLQ+UVNKjmlxUTlhUhggGBtgBaAxPyR+NQSIGU/nZ9Xc/yD4MDZXBBt5hA592R7JM5m1NN409fFz55aR+x2rhfYn2Le3EQHqMIw0boluBgjg/daI8e4PguwjpA5yq6U46bfTmeQVWoTl4fLFy0u2c8VDPQYtQEuRJqesKuQO0wn2TaxQcC0vMHlOKk57n4ZZj9QiyvlvnwelcgtWKn+mXPUb+98fnG1rOg9QO3p/+z5+TtLxpG/R5Vquyy4ajXEkjdTukaUWrse66QwTslv8SWde7
 CGgth/jZ
 k9Go57sZiyN/rncWRTrTyZlSv5fJCVTIVQMSKdRTehLMp+eAi6TRF5P/JLmRoaxSigErZQ/k+HKv5aXiOd4YhdxHUcvwVYvXb7ilw1dpqfYaRtaO0wcTu2Oql4LOqAPxSAgyNUbmmoOe2kj/Npz4uUbCC+aPqybu2UHb07oIMIi6rNUdZ3TmwlnK1wszjvM7ZdwLmqAbbrIOHReD3HYOrpDTM7ynVl+kymMU1K67inH6PcJVlheU+3Oyx6LWnt51C9ocaTgw8RXEX5YS3kzjPgktCW4jFxVKH1JdZujgSqaT5fe4EHhgO2wCvpiq19SwU4obEvYnm5hJf1O33qLl2gLjBbnBFNWOKp/Uvco5dDdSrmfzaGARsQaNgoNaEmjHOy1pOl65+i8Wy+rkMCsk7t+rJyuka4VpOvC1EBw+o6QLNujYi70OT55bVpm1ylgbbiez/xHkvDlM0Lf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> Modify online_memory_block() to accept the online type through its arg
> parameter rather than calling mhp_get_default_online_type() internally.
> 
> This prepares for allowing callers to specify explicit online types.
> 
> Update the caller in add_memory_resource() to pass the default online
> type via a local variable.
> 
> No functional change.
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  mm/memory_hotplug.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..6833208cc17c 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
>  
>  static int online_memory_block(struct memory_block *mem, void *arg)
>  {
> -	mem->online_type = mhp_get_default_online_type();
> +	enum mmop *online_type = arg;
> +
> +	mem->online_type = *online_type;
>  	return device_online(&mem->dev);
>  }
>  
> @@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
>  int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  {
>  	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
> +	enum mmop online_type = mhp_get_default_online_type();
>  	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
>  	struct memory_group *group = NULL;
>  	u64 start, size;
> @@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>  
>  	/* online pages if requested */
>  	if (mhp_get_default_online_type() != MMOP_OFFLINE)
> -		walk_memory_blocks(start, size, NULL, online_memory_block);
> +		walk_memory_blocks(start, size, &online_type,
> +				   online_memory_block);
>  
>  	return ret;
>  error:


