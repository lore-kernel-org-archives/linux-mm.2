Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2CC606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UUwelAap
Received: by kanga.kvack.org (Postfix)
	id BB6B46B05B1; Thu, 26 Nov 2026 04:22:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67F06B05B2; Thu, 26 Nov 2026 04:22:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2F2C6B05B3; Thu, 26 Nov 2026 04:22:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77F166B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:22:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FE7680338
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:22:23 +0000 (UTC)
X-FDA: 85476729366.16.6A5C543
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7020520004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:22:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUwelAap;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795684941;
	b=pvwTodz5I3RLrmX9qa+V2DISOfmuYbcGDGwyKS+Mn6BPAH+k5Xh7+LpVUx5kWo+wC5cSJ/
	EmT7VcZl8EVfdlTG5XTStCCmfWp4IZuPbJaQFgIk5atCLdRFIjJLznuNf+gjRnYiNIjrWE
	TkHhYreaE5BQ/ECkelqotuCkaFPXu7k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795684941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9NuElDwmx9JKzBH+xtXilAFMLSLkvMpGnhqiyMaCkE=;
	b=WsvXQQrDwa3vqwwjQUShOz6fatacS93Yr4QSQUmX871Xjp7wzyE0n8MQI/OCiPRM/lsyjG
	nZTEASaBu2ifFGCv5WpSJaIHKrw5Xm0Bkq1iPn3fN+lgvhv+D/kRMWh+VCRIcyIcqKASAJ
	ZeM+Pr1GOlnrgDeJAsM2WZBsw/q18tc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UUwelAap;
	spf=pass (imf03.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B6A6860D91;
	Thu, 26 Nov 2026 09:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785BC1F000C0;
	Thu, 26 Nov 2026 09:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795684940;
	bh=f9NuElDwmx9JKzBH+xtXilAFMLSLkvMpGnhqiyMaCkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UUwelAap3lS3Bvdnj9h0Qtbpx8sIJc00DcdbYb4TcBr1Ymzp0wFoeXKcYyCZ/K7af
	 QEapR5Bdj+9HKP+NimN/goz+/EdUA2WO3VMuz6OKgHycexEPT7ITVxLLWW5feSm4jc
	 HLdrI3SLTELdvHViFvbaIgi1kWFj/YAaM4DOSH4HXfAbzDr96emSYfaZ+Wva7Memwp
	 qtFCWL3yfmS8pR4qY0zqI69JLx+/kZTWfVpMpyhnspBiPR75EyrCQ8kOBAKmpuEEu3
	 XdRSjEPIZT2sdn7YT86n2I0gEydYkTyjkb2B8pRU8SMl9RZJJgsFpFmILJc28cfGxx
	 oJSxPglwibcPA==
Date: Thu, 26 Nov 2026 10:22:14 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mani Tofigh <mt4022@columbia.edu>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	tz2294@columbia.edu, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory_hotplug: don't offline a hwpoisoned page
 still in the page cache
Message-ID: <awf6RghUETgb41pr@localhost.localdomain>
References: <20261105-memhp-hwpoison-pagecache-v2-1-029d35634d42@columbia.edu>
 <d4812513-6cfb-4865-8636-b83dd92c23a0@kernel.org>
 <2e11ba52-b5c6-463e-a5ea-c165ba935704@columbia.edu>
 <89037847-8875-4d8b-a8f3-d77a59aaddea@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89037847-8875-4d8b-a8f3-d77a59aaddea@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7020520004
X-Stat-Signature: uet53atotmnone79i6oyytyhzpyqsoej
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795684941-380145
X-HE-Meta: U2FsdGVkX1+SkEHceJn+OhW0jfsTIkzqznR4fyOVn7yll/Dt8DRl6CWey3HXD+vRSolFw4Z4O0nZl7NC/REyiGuUO+SO//Lm3BEsROXaflAvHCb/f+TEuXg0WM+uGOt4FzF4IyIKzpTk29AQG5+5b+FNuTRL3KRXqjW0MPtu0JallqaD3+DlNj9Al0D6cEkkFUwTyHfyod5SfJ+ssV46Dh0kK3JFxP97oW5rwXwRSwroItj8iAImB9khK7qD8YIjO5FD8jd7tqERO9weKLfoVIG/EQEGSKuA/jYMjds8htQXJtwdf3z9Ovm198c5nIsdzOc2Pl4+XfsSrN6ZjoIJwyGwvd0xYFOI5chNHmnEHvNLpvItpqNJBlsNvTCVpi1Wq4xYP2MKKJ6+Q/Va4EltPXdgmEQydwiK2CThK5c2YtWTC1G8dXcMLLrXGhwZXxefjxTbtQPnH0jNZ6TjJHVPBwzdfXqUNZJAjNnJaQ3u0qA3m3AuN7iewA4ZN2XdayrBM6OIe7pWK8/v75OWrV9CdmjB8lIZnGVrCeuiWPxK6+NGKgLE9tbmrw0uh7cPs8u/vp7FKKPUAgeCZaeDha3onWV2qFnkG3/16TIMLoQNuoJb3AHu/WxYt+PMQZ/LIWtHPWPIR5xCKx18XDGUbiKZ3HJlPkxk2VJLw7uVVGN10p9SP2oazlF9y+/D/He8eEYJR/tn2wNpuvhGadRzak+5BfLMdOFA1SEwtwYWujDvRHkG9QXFx0Xoii56IHjiZ+frIYOKSZ7fmT5xXt6DF9CUX4bNdXH6mPBX+qhVPPZc8H9Gs/i+7k10vafs5X5dGaJTiQBt/OEJNLJy0toLgUdb9MfA3M989KG9LZGTd/4rca8L/7ZrtlTJiIm8idw8iOh9U/uHXwCPeKZDdFWbAEY1/vyztEQSkXPH1L29EvuyLTd2fy04Jos6UwsaQoUBwU6hoSwvvU0kM2hRffAwWQ+
 q2L17pWQ
 jzBnAY+VJBAugnoa6j9bbhkAm+bWe9AcNWJIjvpd9XoKDBRdpCOziYBECn3g85BvPSnRrkL3RIKl7d1kTN9nUTaBPjjLSqhVt/h0PhDGz0gVYlML4YeIEQ3ubf1exPFFCg5sJCnwltKDxNH83eOjfKcJpW4xx6dFdYpGtdmRxZHF0K5amCp5fh3lGtbfn1qhdmwBwlYkd6e18c2B0VQh3aHHKQBX5ijwvLCtj5jTxo+PGE1F5I8MK6TGjjEgpXN2sHL9iNLM7c0z5AhmuGhl5pKnMuLIitsdxYVe2qGTf4D9ei1UEY2WfQkj49C+zNbXK4HZIrfM3jZszqmYIg3faK+bsxxIxD3k8B1qC3KTSici2vf3xDZt0LhvIxPZAwF1RZ113rn03+0W0f9XmcJH7uUffoM5CbKPJg49E9YCGMXeq6h4lws9YRw7TLEoSxa0dPl3FBWaCGiZZbN5uH4PyoNDwVpVgb+X4nHdKCDs2A92P+ngrnRHzMRIzlnX2gekwG2ApizcsgT/afWxPr/ZZpIODUFIlfe90b1Fi+5FmbC8s1GpEoGcYWRQjnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 08:45:37PM +0100, David Hildenbrand (Arm) wrote:
> We'll have to find a way to make that reliable. Everything else is just hacking
> around it.
> 
> Why can we block concurrent offlining through get_online_mems/put_online_mems?
> But I hate these functions.
> 
> Or alternatively (better?), have a memory notifier that block concurrent
> memory_failure() by grabbing the mf_mutex when MEM_GOING_OFFLINE and releasing
> it when MEM_CANCEL_OFFLINE/MEM_OFFLINE.

I think this is the way to go.
memory-failure is a shaky operation and over the years we have seen how challenging
was to interact with other parts of the kernel without crashing.

IMHO, we can try to be clever and try to workaround those issues
(memhotplug vs memfailure) or just make the two exclusive.

@Miaohe: Thoughts?

-- 
Oscar Salvador
SUSE Labs

