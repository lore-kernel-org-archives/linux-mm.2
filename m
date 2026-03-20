Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C965710987A4
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61AA6B009D; Fri, 20 Mar 2026 12:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12256B00A4; Fri, 20 Mar 2026 12:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F116B00A8; Fri, 20 Mar 2026 12:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B339D6B009D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:26:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 54C221D47B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:26:26 +0000 (UTC)
X-FDA: 84566969172.10.1D6A39E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93A11C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:26:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="09/G+fnS";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774023984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tu20ycLJMSEPILOZtHMmLwg2sS5RK+UEOzg9qkfpFzM=;
	b=sjQizlcM4yoyj980ikNQOQHzsmCSiopx3w1pAxxuPgP6YE9pbshP+4Ze/UZGODwH1yZURL
	rt03j+Rk19UtvKOY4AvzpVqc6tDgFZako6YLivXpAgrgit78XmzY4oZZu1QkfqUn7YKN9T
	B3YvAXIiSz7QVjr9NWI8014kBZlrfAk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="09/G+fnS";
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774023984; a=rsa-sha256;
	cv=none;
	b=3pto7HIsrK04FXDNcfWcIZETHVLbh0GmuGi3MD4eVCjgM57NGS2Ns65giQjxtEjRmGG3JG
	ZjglHq85q/UQy1qx75TY8IXXgM/EG4tCporAfrNSnyB4GGf2TqDga3T8TQ8ljeMsdWjDjH
	ajMAP3dEBxAjGNo84Bq9dlCDT64wDWY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D787435BA;
	Fri, 20 Mar 2026 16:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38B5C4CEF7;
	Fri, 20 Mar 2026 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774023983;
	bh=WN1vrlRzzntzx2h731DA67/8e1a0KGEgvQkZaMrWl9U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=09/G+fnSMt0ifbpViak5U8Q8uUx0pIk7SuO1rMP4wqwYfCRYj1rwLXTmJlCj+64of
	 n06ScFRITAhoT4vRzGxVScpoDfclBQkrfvuH+cjkaOEFX4/ADk/z61lYUwaeAP3Tfr
	 OFiW9AII6EEnCfHZJiJLgtuhxuWw5rKZh8ixNtJk=
Date: Fri, 20 Mar 2026 09:26:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Harry Yoo
 <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau
 Rezki <urezki@gmail.com>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Message-Id: <20260320092622.4b56e9f67a89400292768ed3@linux-foundation.org>
In-Reply-To: <DH7IBUV7758T.10XWQ2VX6KCR3@google.com>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
	<DH7IBUV7758T.10XWQ2VX6KCR3@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kyt9uunw397bk3tqk7y8o3ga5nc5gdyz
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 93A11C000C
X-HE-Tag: 1774023984-559766
X-HE-Meta: U2FsdGVkX1+VSnvpI3f3stQvc25tkjOeYVmPBHe5BBPZONhcGwGpiPeUIlYttcN5pVB5C4kDCW/wr3bxBa0vDBf4z2cr+qRlrE/arteFdXGz9DJ1ea7iyiL8fIqX6dP3+hP26TyVAwWDaU5P9k9fHCc20YqUtYMajpeEO31iBvRF1EQ+CGqXV1xP0ICFWP3pIZu/o8ApneX4XlzBq3ti2lt70h3nHcuqDtVZgKEYMv1/QtsrezZqGctH4o3hBWJDwwcgTLOVyzr09CNXmyvxo6PycTmbkN1Z4/qGxqO2IEygvCZI7bX1ZfoqlgT1ZZMriAkHTDKJPiXd4u7WjPITRKmEPPEDeVoxh6jMET3r+2LZ6grRehtMLBmKXII8kLDG2C3SataZCo0wK9SKmCHHMKWCUQq5kfNR9A+Bcb+rSzoVyYF+XLksG3PH9/28SiIEeq5zN8NbI5kIiCpAtjHCCekm82065Varb+eIUnjchw6TT9iXGQfKQrYgUDD1v3BgOoeFgyi4W3WF6S/jtGeyahSkbiLk5+qnVKs2cnBOyLk0GKaF97xiyiNC1scz4YEJh3GPTtDHIDsHmoO45ZSxVg7S2CebyKPa2ji7p/Sg2O8vTH21s3QOHP43ooz+CWnxzakJuuzhPdeTf0/Go8cOICStoVMKO+kzeLCu77P3FYMupdX/vXqvkJ3NLHiW+UO56jyWSnDiuhdgsWFR3eEWOeZHKPoiLYf30dZmqdYLnUGb7Wu9TYuwLjnQV9nnLgqX8Ts+IG9PwCe+Gc4ZK2ux2akIB/6V3Qx4YrsbdWc2b37ItiXsdojj40zQkGUn1FZD0I5aHTqHWvA+Vzpkzvhpq8gT/iNpr8aKskR58kFOqET77tGRhnr7bA2FCTNf+U3vnRkh6Twa3dTuRNgbAI3A4JvbWZeCc4gGCuAQOkpCjRKp0x+h4VqNmx0TREQF2/oFmSDhTBZcmmArzBHSMJO
 mf3WSxiB
 gGhEbKPZEO9iid9UrIHtT2FYZ/jl1V2DaBmcqpkySmDVJzGZsVlLuFAcf5XBLvPQc1OEI6rubdM62QmmBlRRW9QEsGF58MvbkJ7rxr+VjbbOrpMNUqH4IntYBpr6wI0QqstVe/QxJdnhg1FjjZqmUvrQi19flfgD8wBl+oaJfM8aDLnOkGJg87+bKAWoLzma7K96x4lwjHKkzu6vFDR05voJhNT8fFWvXNhXlrw9DvwJvutosGAM3EcvQKgMSzOIEQ4B+DjZoa1lh+KqUfyFtZf1fvSAJjH6gZROry7t1VaBR4+O3OU0zzJOUgi5fW4ZD8yWE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 09:37:52 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> Human summary of Sashiko (AI) review [0]
> 
> [PATCH 2/5] iwlegacy: 3945-mac: Use special gfp_t format specifier
> 
>   Just identifying pre-existing (and low-stakes) issues in the code. I
>   can add a patch to fix them up.
> 
>   Andrew, I think it probably makes sense to merge these cleanup patches
>   regardless of the gfp_t change, as Zi said. Would you take them
>   through mm or would they need to go via the more specific branches?

In an ideal world the subsystem trees would take such changes.

In the real world it's more reliable for me to take them all, make sure
the relevant maintainers are cc'ed.  If they ack the patch then great. 
If they merge the patch then I'll drop the mm.git duplicate.  If they
say nothing and it has decent linux-next exposure then ho hum, in it
goes.



