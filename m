Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD96BEEC28C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1A66B0088; Mon, 23 Feb 2026 17:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175686B0089; Mon, 23 Feb 2026 17:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056B46B008A; Mon, 23 Feb 2026 17:08:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E589D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:08:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CBA8140191
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:08:07 +0000 (UTC)
X-FDA: 84477110214.28.415AEB7
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90BA1120013
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:08:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EM8f7X1d;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771884485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A174gTXfl3TSZiuYfi+u8aLIZY/OSVOEvYujAHiLL+s=;
	b=WCQ93zPBjj8OmFo76ApwAynaio/TGW36n7a/uEiF33/KLKqdppHfnfLzQIWBDTS0mcMOz5
	O5UcqmIYIkFMZ413Rdxpm+TOIPLjLewS8OTnDLInkupoEiMYwB7jBc5sufGxYTxnnCvhX6
	NrLBbHo19C3WWefXnPimKm+Js+Zqyac=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EM8f7X1d;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771884485; a=rsa-sha256;
	cv=none;
	b=4ns3nbiGU3rir9O5xl1T2bwPiqMBpGzBwsMLkbZKVlAcn8y3Z0IYHRFluitzNjrqvPq6L9
	YBFhS2j+NlSr1RG2EkBJpJGnPYnuCBSbiECr4THuexUYGtHm6E7nMym8bav8dWtVy+gcgP
	1W/nuwP1RdjZODtO+XE9eKYy/YrVraE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-483a233819aso46950505e9.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771884484; x=1772489284; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A174gTXfl3TSZiuYfi+u8aLIZY/OSVOEvYujAHiLL+s=;
        b=EM8f7X1dhJngbyhmfiHR/aL2XpPnLCSUasWZSlUxqWajwgQ58oEN5WANcFwSWNPHka
         idxNgEtFfg6eTteLI7H/2qQNcZgJb8rQn80X9F3et2GJ/ShERfOadc1ijTrc4T0VtV1l
         A8N1Fvgd+mxZEjR8nPyz+wqjM9gBlf2tOpP9EJ18Fk1IESqxdOw9bcyTkqTwvhWmn954
         Rrlz1Qn49fAfN7IopJclRXKbdsHY+2wA6L4jald/f4UugwFfi3zPoosQXQ9whNhq9FvG
         E1P/Hmd2tg+Ei0t0TUBedXmp9manCLGArlbTYb9ruKWJ3oCY5UeUVkCqItULbPQiTuNj
         nYUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771884484; x=1772489284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A174gTXfl3TSZiuYfi+u8aLIZY/OSVOEvYujAHiLL+s=;
        b=RKZ/8rDqIIyvpAfBFk5mtc2sJhWwrgjXWN51g1dOb1fUtcE5NYHduLI9IsxKo95LEy
         SUAp8Bahap04RaEAxbmveE+8x3oCk7qg47KheSpsrxhql6Cf8Nsr5TV19FGVvva56jZG
         TuzeSEfHMHxIvG4QFit51LOxREXaIClhvyWICw0jAzhRRezcj8qHwoATntLbFQQoNfzM
         SbC8+NvCU5Bbjk5wsFLTaTJ2Z2ZlsJitiBHCsxwS3GSZ+aSpvnzR3ShAbfQdNjSiqdX9
         WqOr3cKeiWzjyZ8labRPHGKqQpzgnFQGQcjZ2ygkGNlNY/Md1k8yoipNwxzQkHUGzv4C
         S5zA==
X-Forwarded-Encrypted: i=1; AJvYcCW7OqLmiF56piKjRb24lPTGEevbudsLgEykZamjaLiGGJOo6B9fK+LFdb4SK540uiMkxJ9KL6ilOg==@kvack.org
X-Gm-Message-State: AOJu0YxGiGOq67VapO6LCllyfOACQ3pFpRXrliAsULePg1dFJgV3npqm
	s3uoODLCJMq5dJj4geEZC1K7Vq2u6oux4HeOxlte8Dlklfqw6qaCyqBynt3WaLKvQ/8=
X-Gm-Gg: AZuq6aLGUQMTt2xw8QC4FhiP+0/gtbqdmuaZDUMGounH+25+tsXZ9peJcFY6VXiVEsZ
	cgMWuKs3FZsxOB0dCyNQlE0IYoxEZxTFU5RNcU6UfU0tq9FWC0yb6uY/jHuhrbvGGQyWgxnLZHO
	dfET5QixGhWMtVHdQY1j+JaREAu5cAibG7yFbMZ1rJOLd7BhpjURIMhcMv0qP8Wv+5mMQlOhaMl
	ydmMvbJOhZnhg/kuviFWgeDl0F5+Q7FGtGNMIA9l9Dcw65W4B8Ky3P0qvm5D7hozCbZIc59wesO
	NbJNbAVqIXFEqo7/IE8tppppextlP7BXGIGWcRr2YDjDZ/N26likAWiVYLi++xWGOJPnjS76tlg
	5xH8+tIVs+fwWdP9d6Zji5+WZHOlFmfC33Bhaom9VO27Qs56yjMohXPsumGz5DRiZ5xq6Dz+ldB
	RUjYjFIvlZHtvWIRkLoy8IBSMk2DAKDKI=
X-Received: by 2002:a05:600c:5020:b0:483:71f7:2767 with SMTP id 5b1f17b1804b1-483a95fc0a9mr183175305e9.11.1771884483837;
        Mon, 23 Feb 2026 14:08:03 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b82392cfsm6801775e9.3.2026.02.23.14.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:08:03 -0800 (PST)
Date: Mon, 23 Feb 2026 23:08:02 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZzPwsBp-Z4XM58U@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
X-Stat-Signature: d91mtepqaw4sf83xfse9bsdckyiqa3ua
X-Rspam-User: 
X-Rspamd-Queue-Id: 90BA1120013
X-Rspamd-Server: rspam01
X-HE-Tag: 1771884485-996990
X-HE-Meta: U2FsdGVkX18P4SEfpUMU7K+pGCJPACIJcd28Zhz83P08+joXk2IR35Fp8+eihSLaNrv6xuiPlctjTijjiw2GZUAcBAZLg+s0CltwWMbbY0z/onyJNa/zTJE5l9VvjprNQFSAxedXajCBqOJwn9g62VeMhv2W4B4QyBZ2mH9N7cKtZe7pWCFxSu+CmG+AtmFdKnWnx2e4wohaUV1BZGYqlM7NDLMEPxrpW8Vo0uVctPZpA9Zb692lCwZhFqNKqm5RpuRUPdmcq/sRChejOnrsnXeSnCW/pNsrtDuvVXFlY7WX7LLx9kIjrBDz0AU9UUoUu+qkm0YZsub844FoteyBhULHbaYepGTGzSrp/0JjjVVcUYbh6sVaa2/RO9InugOhoM6ycsG4o16AVMjARl2iEH86DG4TSVkSKeqGk/kKX9xo/QmfKmJwYJRsJMZsGmpjK+QN8Fmmp7q+8aP8oGda05aV6LYmX3WTam3Ifp2KQlMHlXd8KRJJ8TtNh3yrCDHD6uRlpOx5xNL1atGxuPemQDCPAQzIGz8pjIMZUc+H0Rmvp3jtm6ikmxqmtzMgLEjRTYLlRFplXXm5lHD0O8w857uUaoJLGZzrJ9oiLUsRAH57VYeBXQGzltqVOzxrDwVXo/wAOT14Lliq8e6+9XoYMl7WlLt/mtmkE5BRUAdOG/QozANeHQa8UBxB8etOSXjW1+YVogX1XVELzvl0nlklZ32o7tEUB8ZY4C2J8w5VsjME8JO3LKJ+Zm28HrDcPhKTml7S7zBgo943QqN1X1G2bHad6EH5h8GthAwKmM/iGWb30S9MVJWVBeZnkdOlPeyZQHtDntxcdX67kniRxM6NVcTIhCsXRx8M0cKQNV2a7c6u8kW0D35x/P1pEyFyNUjFEz1zyKzyNP0quey1owR+/9XfoeT0kUl2D6Fl72lIHyDQag9NYcXFv3YpIsohHoLuO4YS//LoyqWiSnv7C1b
 7vh+s0qA
 E6mCuOjkJNdN1Mu0yegzhBpG4iI4Jdonn8uAD7sS1QxG7AtVtfobdMlYFmZxVobHt5OV+2G8Ld25v4GhYgrWugxBzPDAPqrJiJq6f3SDFsdywTJOhFFMa5YR7Ovvrh8hzFGPPSKxquJPvL08ytQFGEolmMlRbsWJnQkNtk0sDNZdXr7ZHvyHDQpaoJ7h+iV0Ju/qS7lW9GXkPkaLiu2Wa3VPGuNKMDqkWFvjqXbqKVL5R/ieHuBLmXw7uOC3mQivtNyzInBxdgwRP8q+ebsARByn9z4WkcKiMoqMafPSNk0bbkpYg+j3S/bkbkvTb4FHH0rfynBMzt99p+6ttE8ocXnwFtJ2XQ/2UvVDVTwRMKkB3qG5DnH0UR+2jTJLVz2G8P/GH6AW9V3tZ3MX0TJQLnRgCjsQnFdeOVSg/LgGsgNE0mkOZZl1R9YddvreaZCT6m0smhvw60qsWE9a56ydovPxa5IKuzehzrgO8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> 
> 
> On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> 
> > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > flags.
> > > 
> > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > 
> > My only skepticism about this comes from the line in the
> > vmalloc_node_range() doc: 
> > "and %__GFP_RETRY_MAYFAIL are not supported."
> > 
> > I myself don't know why that may be. Could you elaborate on if/why the
> > doc is wrong please?
> 
> This statement was added by Michal Hocko in the commit 
> b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> you think that __GFP_RETRY_MAYFAIL is not supported?

The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
supported. While pages that back the allocation can be easily made aware
of this failure mode there are page table allocations which are
hardocded GFP_KERNEL and there is no sensible way to extend the API to
change that (as we have learned several time over years).

> The VDO module needs to allocate large amounts of memory and it doesn't 
> want to trigger the OOM killer (which would kill some innocent task and 
> wouldn't solve the out of memory condition at all), so I think that 
> __GFP_RETRY_MAYFAIL is appropriate.

Understood. But as said the very page table allocation could be the
trigger for the unwanted OOM. The same applies to __GFP_NORETRY
unfortunately as well. vmalloc has just recently gained support of
GFP_NOWAIT allocation mode, though. This will make the allocation
failure much more likely though so I am not entirely sure this is a
proper solution for your problem.
-- 
Michal Hocko
SUSE Labs

