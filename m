Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1962606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F08YV3Vc
Received: by kanga.kvack.org (Postfix)
	id 130656B0719; Wed, 21 Oct 2026 10:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108606B071A; Wed, 21 Oct 2026 10:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E4E6B071B; Wed, 21 Oct 2026 10:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF4966B0719
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:37:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2FF028056D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:37:34 +0000 (UTC)
X-FDA: 85346886828.23.B0FA078
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 978B01C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:37:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F08YV3Vc;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792593452;
	b=e7MYBVc0Uv2gAMOb65w/sNnXuZwwEdig3APi71seYYutSGReeMfIUu9lFfyWL3qTKWWODt
	n943S5PBxMF5GU7fHRxEUkzVAPiaS6+G0fU/O2uhIMcF94WXvrhq4xuyF9pm7lPsuxeNmA
	m1BeHKv0E09z3JhmRJpINjOdBLXsA+o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F08YV3Vc;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792593452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=LNqUh1ctm4UHtwJf1BYt5KCSbLCVqB9wnPT3dznMsCY=;
	b=QeLlEjuxpU5iIcR0yYYNTVwX5xiT4EuJU/MYO+RLrrv8VaQIPOgXk18Lacm5loOrb8z1TS
	z+7lDkSb7JX3mARhyfnQGz0X/kQxqnmK1aokkLhdCCtYW0pd13vrY2eY6T4vmTVPxIDL2J
	rol8xP3YeRauInoIa8/NRB1jNGOpHks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9203343391;
	Wed, 21 Oct 2026 14:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ED61F000C1;
	Wed, 21 Oct 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792593451;
	bh=LNqUh1ctm4UHtwJf1BYt5KCSbLCVqB9wnPT3dznMsCY=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=F08YV3VcVZcG1A937aiiuDbtWGBbtf1gdDJzjrWCoFJmAYy6miP4DAvelUBbaIlOe
	 4bXSMFjLEECp4d3z7J8eM9Vhf7+ftCE0SniWXthZDaer7ipB9DQ1+kz/GxsMY//q5e
	 8Jtd5z1sr9R9x5IamdwCnNXs91poBcPdvRtGWFaGyT8GMoi0HjYZUnlHs1RqvRB+oX
	 hFpL9VJbihZnVp5GYWXiOP0/NESkbebp/1fejrPh+66HM78oXbbMAA4E5gR2aDlMPF
	 zMNhW+G1uZjEkl6JlL8eajTMSfpxCSqtv4/FwWFhL9qSgrGHRqwOq25dTnG89P8tXW
	 NP8n9R82cv52A==
Date: Wed, 21 Oct 2026 15:37:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/39] mm/vma: fix mmap_prepare file handling, remove
 file_doesnt_need_get
Message-ID: <atjAgZCWdYN77C4n@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179253282492.1207257.6426479952081115792.b4-reply@b4>
X-Rspam-User: 
X-Rspamd-Queue-Id: 978B01C0005
X-Stat-Signature: iqnnq663961jpfqy8mffc9ha7k5yha93
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792593452-619021
X-HE-Meta: U2FsdGVkX18Q6lJUnUGqs2c4DWNQ0N0TEcUATxz+SLKqpLqf+wP/6OdlJyLZ7EDd7tFCSg0eXgshV/xluj0izzGIjGkrIXluddwH7jzPZlcTDdH/8JP5cu2pcID185Ddj6aUUcp08qpE6I+2gpEY2tEm51b9fXsTw0d3rF8i0oME3dq3WCVUP5usszDxvMjj2GXiBoujO8sPJBCK+lX8lAhmc7isYai2+h4Pg9I0I7zbdw5+NJovR8t7eXLtZDIk7dsNMCpLwhFHacxIEO2NeU7h8yDT15wBNdy9wwxTPcN5sLaovlrq8t0zyeH98AIPqdzyom9vOkNpv2IWNFWK6okcJ6VRumqcnW8cqgCrTAx45ypSOZGrFH38F1gRwm7W2fWKCN494nDZh9hpH1uT6UtRlB9mvChWltghMMFAzf4BXiTsK+e7kAZXHBY8edSkv4GEaa+AZ+tW2YVLm0OwJCoJSj8al8aIFmh935keVtVyQh+H4Ecrm5dxm/1OKU9lXj9VS5eQP/Lxd0+ihKn6vn8fEXL1nAPLppMxTPBQoMzI9G8gsfkM0fOYOFPpXpAUptUYyoABGWE9XjGNT88DKG/QLbDN/b3TVFMhzbzE7F6blLYdNJ75+7I7x3ne91ZmMIZOrB/oybsCmZr7LC2vGyTakOpDJW/m1tOQsoaIcqM9YU/Mge6dqH016scfYCQ7RXLSLP+loG5s1vO0afRig/T34oHpjbxEhJkV9eTabwwhU3EsEE/TtW2canATeRsUZxEr0vCI407fv3iK6sG8BqOHH2rgS6YQHaBFEsRuGAo4LwEl/9LjZ2qn2ibL8G3uOQDyyEh8YQbgbwXY1WfiOJqgTXzIg+bvKWQIvSGQmp+wMaE8eZsRFOKSLy0C7ZkG6hlgJUsT4XeO57zylYXX8eNn8TSQwrX7ggq302PHjN6xQfhMG2M06NwjH0tdPvYbp1QK6lytX+arm+t/UHs
 IJuscSsT
 nYOO3OyI6+R2Yly1DUlo4vRAROamXgwWopFKM1EyoHHWRuvwR8LzEBsg8X4OLVRb5x5QxgdGAF5Kb6odpSiK1+Y1Lhhcw3J/mYV/eIYVJXeQCGeJmgJ+ebF8yFKWdy8V0iciBnfjrHZhu9uPvwKme2h7dBMhEALHPqbjl64qTP0yYD6kyV2pfVsY+UnidiQc1rXuNCnxRjiD3rqdv0b4SRQOslmXaNOLK4Ti2mHgO43AYezC+pYWSzWpp9o6om4kLivGjnfM/ul/jurL4RzeC5ceVOKDHmecYCcBo4ckawuXt+4QcfvTx1xF3dBDpDNkzzKpflkRikwLt2SdhzcTjhs6JkSqel1a2njepHfPd4OegtGPi3oUJI3rWkN2rwWfwjvDqlnxJH3TANSX90gklnB2pFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[ cut cc list for sanity ]

On Tue, Oct 20, 2026 at 05:47:04PM -0400, Gregory Price (Meta) wrote:
> On 2026-10-13 16:04 +0100, Lorenzo Stoakes (ARM) wrote:
> > The map->file_doesnt_need_get flag is confusing and the existing
> > implementation has holes.
> >
> > Drivers are permitted to change the owning file of a mapping. If they do
> > so, they are required to take a reference on that file.
> >
> > The mmap() operation which ultimately invokes __mmap_region() is guaranteed
> > to drop the refcount for the original file the mapping was made under, but
> > this is not true for the replaced file.
> >
> ...
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Have a nit below, but otherwise
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks! :)

>
> > +static bool map_same_file(struct mmap_state *map)
> > +{
> > +	return map->vm_file == map->file;
> > +}
> >
>
> Terrible function name :]

I think let's leave things as-is and maybe chase this separately as a
follow-up ;)

--
Cheers, Lorenzo

