Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8686EE67A8D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27526B0092; Tue,  3 Mar 2026 03:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEB06B0093; Tue,  3 Mar 2026 03:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35D06B0095; Tue,  3 Mar 2026 03:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D45206B0092
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:07:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52BD6C124F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:07:07 +0000 (UTC)
X-FDA: 84504021294.03.CDD20AB
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64598A000E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:07:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ud/YZkPH";
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772525225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EP+zAnJ+UxTB5O6daIsb9DhZ3FbIUZFGJrbg3N0r1PI=;
	b=5GgrvA1wad33Tl8uAC4+/K1DvpieGzRm1z+JXLOSCDgQRdCa5g+HOwdCG7vidvhjB5Migx
	NGn3VvCL76Qrii8Sr8o0+aQJW1pbibxLXQAVOfr16oXDEEXyZgB+NgLKl8pl4dIv1pfcaX
	QynIcn8XciDiSiLtAoRhNAUUCO1UCj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772525225; a=rsa-sha256;
	cv=none;
	b=4kSeMGnKGQ2zMPRHAhWpksa/i3KJ4fHvOwAvzDhcx/7x0SW6HrTkK/uwzn1g1FIUi064Ww
	fD6EHY37rE5SQjqEe9gIwDl0TTgL9ooSIGoijyGRVn0jEsiZFSNR6/UtfkJViLKYGMP2od
	ms0piV/fbevlFY0ALeV/pGqTWoQi6ls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ud/YZkPH";
	spf=pass (imf25.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 3 Mar 2026 16:06:44 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772525224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EP+zAnJ+UxTB5O6daIsb9DhZ3FbIUZFGJrbg3N0r1PI=;
	b=ud/YZkPHqub32UXTYjtmLzF4QYZzguG8X3rHXBC6lwzBFf+n9C4xn3xSzDLkgg4HoCj4aN
	/vgd9dZJ1JYkvDijejM6FkFNEDoGZ+WGKHX9pFjQAhIKwuZbRbLAhIJzbTETtO18D57X7d
	4MBnl+MC+K4HjFHNX6Hg7pQt+1EBSpI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] mm: memcontrol: use __account_obj_stock() in the
 !locked path
Message-ID: <e45q7htkmtf2uh7ry2wa3be4erlxtmw6g7v52qipdcatzhakgf@jjrlwpgkbig4>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-5-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5ndd9sh7gn39y6mrpnyju1nyhgeiy9bg
X-Rspam-User: 
X-Rspamd-Queue-Id: 64598A000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1772525225-599448
X-HE-Meta: U2FsdGVkX183DGKKpeNRO/DKOfJ2AQSwSkPz9ZTCN330Vaqhq0Gjo+/agD7KDlhCI4gcF6FwIOCdYt2wpZ4+WT/c3cK600w0Jr+n2totsBDmNcCwZT8DtY3TrJ6V1hH+wDhcQkdNAdqneYv7j5yKwcUOBpaECrO3AMpGx4Lqe+c1YgH7hQbP4O6aPin4GsDkQ/wIKuNjn2b1cOGVB0s9kqVFoFprBxjH5HxsPuVh0nctDpr4pe9TTit1vvRdiwDkV57Aj2r3m5fr+z7PEXF+BJ0GttM3uzbS0793g6oMLQTpNl0ElZfSTdxpWPfb9cQJrnxc3XahsQatwtYXflFDDr5kGdCFnlrk6PKZ4SHdassUqaDgLm6/6dI4ECUiHVkNMAZu7UdMbyjcjoicL0TfMLRA1HO1ZtBfjVfKjBi9NJeV1KeSVWV042apGEDkQEi/TFN6BoYSBsbM/gZ8FufgqjpMpH8jeZjJsRziFLOZwYgBz/6JgMLQLmtrXDYhLIZe3RO7NDnbGf0DnZkeWCJC+sqljBi3kyubinP/u5RAZsn/033ibX6014pzxEPs73nMvl7QkeY6GVVGoAkn8bPD3TEs/XydPjyPevnBg4xytr86bzWj4Cnw8FNFgpYgUBbzH44RsMgwIlMAXl5RQoIz/KgFEK8dNXyMx0LrCS8PBZ+ulWECneJywsBrK4W5mhODBWbX4N5egOEjDNXvyJ8DkeOeIIEeVicm9rcDSHit0v2MQIHb5pc0JG6LTwE4qPQRAlhP16MDWc2dKV6oihOpAGGOM3WttNm3QANUSA+HsalrTq5s+6Y0J6OKyJiVEmRxq5opug7icKo2ZxuMk9As7AUe30VeYYJrlNX7oMw0UOr01svB84c2R+rLbn4VKPIK/8jVPJMiDavSruyONKoMNf8QPgEyVdwdX1Z39nAX2doS3ofZ5v6+wpmPnKyHCNOiNDsAicCBXeGZIAMITaK
 KVC5TQ9o
 WRWYejrDCwUBJXvznTaaDGDEXsgl5raKMoygovIh6ll0f6WHRdYRYdY1VgzzCUcKtkm+e52pp+kXkwKUmaGyMSPpgawLHhH0BRm6yoyDLIojurhYAAfPvbItnu/0W0HSqm9ru/MdDmKa4LFZ0yH0AGYZjbHMm+HGiLeGLBLQkr+jQFXl2ypxzF14+vkvJGIK0UNVpW2fM0QWatWuIaxyKbBhd3vnHsxjnVBGHMNs3iFRY+U2gLKcBmSYv8HGp5Lj8c6GP2HJ6vxh1hXz/KukQgqHJn0czoi36rhdy4nutf49OBxjqKydK/e1a2Xh8oPe0QaUchnFAqMLEcMCCx0xdEhiN3TeOZmV0SnTR2rLhITYAPS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:17PM -0500, Johannes Weiner wrote:
> Make __account_obj_stock() usable for the case where the local trylock
> failed. Then switch refill_obj_stock() over to it.
> 
> This consolidates the mod_objcg_mlstate() call into one place and will
> make the next patch easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 

LGTM.

Reviewed-by: Hao Li <hao.li@linux.dev>

