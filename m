Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 501F7CEFCF2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AE006B008A; Tue,  6 Jan 2026 14:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BB16B0092; Tue,  6 Jan 2026 14:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DF66B0093; Tue,  6 Jan 2026 14:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 115B06B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:14:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5E6D16090B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:14:07 +0000 (UTC)
X-FDA: 84302489334.23.93E2372
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CFD5C0010
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:14:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZwNWsoaa;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767726845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4b6An5MJliymK+l5lQ+asO/gerD4yNm0UvKmXCvNrg=;
	b=EyYdD+iIQ9D7pW3hJdhcQmNglmNpVrEIDgNJT5obGjcflfZXWPVFbEpTa5P1LVwoqGvhVd
	JL96Bn8Q6xh+H8iSmK7yFcdu6WXo2AbKkJERGV0D2sfhUVspp+jwV1xXWNKRG98ZH0wYQT
	Lw1lTvMORH5h1BWKnlHzdUuQ67AhGxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZwNWsoaa;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767726845; a=rsa-sha256;
	cv=none;
	b=BBNryzskatc9cJHjo9FjeMHO/BKD2aCFoMl6jcNBdZBRWgAreywRZVt493ZzaXIt7+N6UB
	h4FcQ5LBjlCGn29h6dVH46mBySRNshpEtCn035Ntb3YiIn1+AczAGhGurc1ztyH3oilJit
	MU4fVyfW8M7AB778RIQdnemqnoJAkFM=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47774d3536dso1298535e9.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 11:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767726844; x=1768331644; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4b6An5MJliymK+l5lQ+asO/gerD4yNm0UvKmXCvNrg=;
        b=ZwNWsoaaemn2+Ndp4pcWGpVM27F0riU6A9BxfbhI1jTZvpahq+ef55PgMDCvq6sSec
         kjeRueG9XReOfKOG16nRFYt6VV3lR6E6llWv11fL5QV3lciPJrnkd2uwBuPSInW4I7L0
         ZMULbh3+3ZMaopahqEl0YyZf2Kkrty2R0hy6rPKiZ6ohwvMoWnQ1QVzHUOKDHAUNHSs+
         7+WvTck734sKDw27CjOi3noTg5Fdoi+6P/yoIpiufFUlgz3po2zRfbwmeUYU0gQ3iMWX
         5kZUn4Gk80o2V0mKylqSmYGYz6HjTNA1938dHNxVsfKbu3mkucSTg1X1MVzq+x4vM0AS
         ytyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767726844; x=1768331644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4b6An5MJliymK+l5lQ+asO/gerD4yNm0UvKmXCvNrg=;
        b=KhQCDaWSRCWX86Z5msePKZJeAm1+bxzMih4XbdpJlOpjFlUmYmxi2/YYgtC1cvo7Jl
         GwwXmKYqm3AIsd1XAd06UCIpiXfO/UE6upYudCu3cYOkSm/kY3cO8reUBxZ3bNxA/kI7
         AES57P6NB1iOz7iI1i6BmCNt3YLt3focyIsBI/k6qYUE713OM9XJB4GeIdCmJ5yR3lho
         c+IFmbjaHZHL7CoHyxN5TWx069wDxTC3UdotoD3G/xHt1a9dtAEuS/syG4yhAdbROXIw
         4vFV6dbA8TLjCEBiG9ALMdj3gKTPPPXiwXZEbeexQyv41g0JIfttPb+Shpx7oprgINzN
         egPw==
X-Forwarded-Encrypted: i=1; AJvYcCXEoiStMkaLYAzMXtOfxYQmFFIJg33gVJorMGDOzQdllcThUUyiZ+gWIzjgNt463XPrXBmjwD9P7A==@kvack.org
X-Gm-Message-State: AOJu0Ywa65u/kXfMXwwRWeWIcw9nDjzkjWaTtuEzOxLt5VP6F45n/T67
	93EE27PRcRtrBaEhBVZxAgx/xxH0m/0JVMNQ4GLGBMTUTXo676f07Mc15oyzLJnTsbE=
X-Gm-Gg: AY/fxX7h6E7vjUAG29LzjOyHY3erVw7oPyAGmNvigScW+D3ybrXUltmb6EO3CxSG3zx
	62GYzdroPnIVkij8FDGxilVx4od6UsG2S/tj6UOgbsHOFTn54SwRnhnkfohJHTbFSoVCfMBpsAD
	tv7j0/3iSWjL3R9IiMqhLllb6C43sVlyChEVqTcVrdj5S96hbgiWXAA6ZpHCG7lrY0tJxprxGi/
	xv8twdmEWnn5zRqEoLIoh1rwb+/L2zUPNiblfbzhf2kyVF/zmv3cftAU/ueU2yLfc0gp9huRctX
	z7uiuqlOoQf1a6Xgy7u6YkeAL/nU5hkwzSVH4cJGgGdf8pyzUJUdGA7tLvcBKYlElIec9wM5Qyb
	b0isVh21qhydXVe6OzxMUh0r3x8jYJJajHn9fB1BDGdUq/9SI4BzgSuAEJPoviHGq8VLHEDnzaP
	NVhs6kDdNgLuyyg35LceRVRsFv
X-Google-Smtp-Source: AGHT+IEyNwsx2FHFz7Vpse3jYP2GR6qjdO3W7d0IOA9iHAVE6nWkedBySE+QtJWPz2tdpfLkjzsUNw==
X-Received: by 2002:a05:600c:848d:b0:477:9a61:fd06 with SMTP id 5b1f17b1804b1-47d7f41153cmr46778365e9.8.1767726843867;
        Tue, 06 Jan 2026 11:14:03 -0800 (PST)
Received: from localhost (109-81-93-164.rct.o2.cz. [109.81.93.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f661a03sm63555415e9.13.2026.01.06.11.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 11:14:03 -0800 (PST)
Date: Tue, 6 Jan 2026 20:14:02 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <aV1e-mn1JJix4bZ5@tiehlicka>
References: <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
 <aVzaqAZ5Wagh5cDQ@tiehlicka>
 <52cc0b2671b068903c6580b7431db0f22982ae86@linux.dev>
 <aV0HI2-iRXuQ4MGv@tiehlicka>
 <rlibyovqzrcir3egfa5pzjn3rgk6ctav63okppevjpsp5fu4lx@rerujqrjf2j6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rlibyovqzrcir3egfa5pzjn3rgk6ctav63okppevjpsp5fu4lx@rerujqrjf2j6>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CFD5C0010
X-Stat-Signature: 64mefz345wr75jun8m7mfypujcx69nbq
X-Rspam-User: 
X-HE-Tag: 1767726845-600039
X-HE-Meta: U2FsdGVkX1/X0MwTGKn6RcW3y1eyYDe4XkWSJGcUOlqlsCaZCRa6mxEHKBryYETHU1aJTnfmXwMXa5L9HD87dBQnxQE3WigOzPRyXaXoMGi8jYnjh6gWfNBwIlhphJ1GRm8h/S8b8EWKpEZfAba9EYKjGNgYcslgr6hlKCS8OaNZ+LC41ehQzTk7uIhF4zzPaBbUgsxQ4wyGA3qRyCeas2SqqonOFDjZ+je8iXsVAaVLa7BDgZKF1PYKsGvoV1a0pQZI7ENnpZ3s8rJc8HgxFw2S2hVQTFBE7bOd1qlJuMVeDJidOgmM/rx4MyX5c+y4wTNO8s3p0K9YUxsDbbBkflSIBKJxV7k1iyjNBJgPnsvBT6zZDh9MhpmoDVLXOTsDhdpuhNWKeuo5XKjkqk6hV9gW3HrsZv/8n4nWDTI0DGpXc5FW5ohSeZU7rZt30BiXSA9AOigAvTTB3srE4YchM4IrtMRhmPdZ/nDMELvTLWqdbzZ2FfyoZf97cWSkkcIuB6GS8caam9u+uJq14Y22gaHbngjg85PO2/OnreeQ2DbMVK6J20AL/Y/DXzkZPIJo5nKya74ErRmlsjV3IXRh7YCNRVqsPWP2autn8HxJslgrSd4vmheLFKOPrjqsyYD8+3lwmSwLjRuw02jlHl8ZqJUsl5+a1my8D0VGdyg0bNFKDBjCmA+aF2cEiJ7zb8iPIWQq/bFBepWId/UzfSjSvSnCckgOdM9t6LX0LKm8YEKYo556IbFISQBfokTNCYzxXlBrlY0uXOlc9D7WSeln4bpGoqZpqnAcHhtNNqImHeOOVIA/d6RdLn+eFEst+VQGYUSV8LkIqPFttt4fYsFGnnmCiM0sc02gilK9VZMPnc9wCjsPg1zo+I0PCuf46zJP5+WXEMdXKQryLRmDyYStI263m/vhjI4lkoupwgKUoopyHN0WH88uunHojvoUPsbYoKh+K48qUsUSz3neT2E
 Es8OBdDw
 1wlyAE5xmQ0ls3WLEXjtmVssWTUuZgIxswik1tOMqXKrGGk+gKXnh5iNxmUmsBKSFERkaAR3qK7xBAgLDfBuR0QLRbsc7VJfhmzLLoqMeB8S07PJMUfORLSHiIS5SJsM3PgJad7HeoTFQ0whMz31LswRNbqNE/PT31bk//ot8awepP54xma0YmrhmBsIL4LTffKhABTWwjuDiI6a3fyR4Mao2HcqKp54bRaChU1YRYBwcVqYrpbqHS90vrpN34nuE3Gu/kS6oAlcxnd0VlVlNx82hMP6uecfs/KAf4XnyJ/Ln8tIfu0kk9ydpaZCWICkgmGgPaLnUuEyKS7HOdvBzQvAMZjFWtYu8LHpl6PYvfKIYG1C6OhKVXWq+bZu7xmWIUKY7Y69BiJMxGmodq1QSx/fj2CLQm04tkkZ6MAIN2qBNGAWBUsvMMv+atneNmm/jWiRsjnVKiemACWAFg2fhsurK4LfrtA0fJjx8n3YxvIu+Tp63B2Dpbrr7Ypk9WxNdAbTwFvpPwuP1Ed/rvqBlHatoTiX1d/glPqDxHKJlajTCM+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 08:50:11, Shakeel Butt wrote:
> On Tue, Jan 06, 2026 at 01:59:15PM +0100, Michal Hocko wrote:
> > On Tue 06-01-26 11:19:21, Jiayuan Chen wrote:
> > > January 6, 2026 at 17:49, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:
> > > 
> > > 
> > > > 
> > > > On Tue 06-01-26 05:25:42, Jiayuan Chen wrote:
> > > > 
> > > > > 
> > > > > That said, I believe this patch is still a valid fix on its own - resetting kswapd_failures
> > > > >  when the node is not actually balanced doesn't seem like correct behavior regardless of the
> > > > >  broader context.
> > > > > 
> > > > Originally I was more inclined to opt out memcg reclaim from reseting
> > > > kswapd retry counter but the more I am thiking about that the more your
> > > > patch makes sense to me. 
> > > > 
> > > > The reason being that it handles both memcg and global direct reclaims
> > > > in the same way which makes the logic easier to follow. Afterall the
> > > > primary purpose is to resurrect kswapd after we can see there is a
> > > > better chance to reclaim something for kswapd. Until that moment direct
> > > > reclaim is the only reclaim mechanism.
> > > > 
> > > > Relying on pgdat_balanced might lead to re-enabling kswapd way much
> > > > later while memory reclaim would be still mostly direct reclaim bound -
> > > > thus increase allocation latencies.
> > > > If we wanted to do better we would need to evaluate recent
> > > > refaults/thrashing behavior but even then I am not sure we can make a
> > > > good cut off.
> > > > 
> > > > So in the end pgdat_balanced approach seems worth trying and see whether
> > > > this could cause any corner cases.
> > > 
> > > Thanks Michal.
> > > 
> > > Regarding the allocation latency concern - we are already
> > > in the direct reclaim slowpath, so a little extra overhead
> > > from the pgdat_balanced check should be negligible.
> > 
> > Yes, I do not think that pgdat_balanced call itself adds to the latency
> > in the reclaim (slow) path. Mine main concern regarding latencies is
> > about direct reclaim as a sole source of reclaim itself (as kswapd is
> > not active).
> 
> Yes we will be punting on direct reclaimers to collectively balance the
> node which I think is fine for such cases i.e. high kswapd_failures.
> However I still think the high kswapd_failures is most probably caused
> by misconfiguration of the system by the users (like overcommitting zones
> or nodes with unreclaimable memory or very memory.min).

I am not questioning a misconfiguration. It is just far from great that
kswapd adds to the problem under those conditions without a very good
reason. I would be pushing back on increasing complexity for apparently
misonfigured systems but I believe it is fair to say that failure
counter reset logic could see some improvements. So let's see whether we
can deal with the situation better while improving on this logic without
much of an added complexity.

> Yes, we can
> reduce the suffering of such misconfigurations like this patch but
> somehow the user should be notified that the system is misconfigured.
> Anyways, I think we can proceed with this path.
> 
> Juayuan, have you tested this patch on your production environment? 

Yes, getting some reclaim stats to the changelog would be highly
appreciated (with and without the patch of course if you can reproduce
the issue).

-- 
Michal Hocko
SUSE Labs

