Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE667CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0D58E000E; Wed, 15 Oct 2025 02:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0918E8E0003; Wed, 15 Oct 2025 02:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC22E8E000E; Wed, 15 Oct 2025 02:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2CC8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:21:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F017C0B60
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:21:26 +0000 (UTC)
X-FDA: 83999351772.24.C07DF58
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf04.hostedemail.com (Postfix) with ESMTP id 841CB40005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:21:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OYnejFiy;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760509284; a=rsa-sha256;
	cv=none;
	b=MgY4kvj1bpQ7FYLpXjHQS1klQbDAuGZTuMlxBUZNrYWGHvL9c/dYa9NS1LU4l3SYgEHtg+
	5sc4cbL3bsuSxu0jCXqtMQVgE5vQb9I3AeXWhh+pXxaNqMnLj9I973lzJChDbCn+QLDJwJ
	I04ypvLTJBlXA+dEoXTqltgVbzwNGY4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OYnejFiy;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760509284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3PV9C1telyfCjlpsA7EV6fPruE8tbKt63BPSU3FM4M=;
	b=C2Al2J4EA2fzRIa7Eflrgqah7gElQRP+I+qUBIs9Y2VGGpwR83TOncre6fuhED8ueAKQtH
	3SLC4ntO51lVDczga642xTUa4dEHOUfousa51e9RctxMv9YpnrT71d+Kfa8O2FgWmgbCJ2
	qizgrlx425ZFGQtLtgVHbT0FFqNzQmE=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-46e2826d5c6so36658045e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760509283; x=1761114083; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L3PV9C1telyfCjlpsA7EV6fPruE8tbKt63BPSU3FM4M=;
        b=OYnejFiyfbPZRU19eMEXvly4XknWhhfyMWTssV00wsmpBvXKE178LPiYpLJYudj0nx
         QykUAuRIk/gSsawQneHggWV4dL0e9bAfK8b3ufEZhuGHi1Q5ahmAyeC6wBdKIuhA0BOl
         YRilD8/9cNDpLIJVTvMleD2PbYddUDKpO8KqnmUXUTkgdt1iupkHKJ8shEJCuK4G7ch6
         zXEDImrbdMq+z8L7nLAXtotcfKvOYnDdENN7jUa0hBbeY8T8duR3U3+0M6sy+/tt7Z37
         fNGYCbAEoXED6EfTO0XXs+rvif8Ojtq49eVswJTdATp7cXHLhImRS2cIrODVvmSoz61Z
         GDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760509283; x=1761114083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L3PV9C1telyfCjlpsA7EV6fPruE8tbKt63BPSU3FM4M=;
        b=qOLxUWkZetVrOydVg8fvJSZFsYgPio4m7pPCFPijsZZlupgbRPm+9FJFdp1igwHYwN
         VrNaBOkcaXSjVpNQ+UHp9Ma0tdhEVj+WP7uGIe8p5vf8albSq4P8DLt9fUIaB2ixFbIg
         H40mM8K1JWgDclM2EUW+czzTDzqPgrTmi1IqIX4rQsijck165SJFMZx/DfqeK1VUWlAK
         jS53kbeAUyvC2hCHwjC0DYtv1ukNEcf35kwtTRVrPDt662DgZ0L+S8jGZ2VNb94VCZpU
         jJlUa2JwGO/5bGw6QkW86K1yygfIpBCll2m2SJQIlf2RnmOoT4n5z4SPrKzRqAG1+BTx
         q3gQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ4DehlJEYYej8uOdB7BqTsThFdT3d9syVDqXEL5x6JgO0kZ3kZA6RsxWcaYHQmqEDRQFK6x4Fag==@kvack.org
X-Gm-Message-State: AOJu0YxdkSjueb+TFZRQ1Nco5OKEN6NE2QkyxICmCzvDsbS82wxEie0d
	/aQqwghrOIRsFgRCUttKzRffd1ZvNuSvGBAoT+O9cVDXTwT2E8WJ73UWkGCPfsZtbus=
X-Gm-Gg: ASbGnctxET6EEqG/k4yS+k1UfDdSe0SOmTqSfQ9xJW1j53iOPV4gx7M4HRRNmeellY8
	6pD0fDKHqf0XoNe6e5X4G+ZOJF6MjrbJd5swiZuhIlGGwED5YGg3t9otivR99D0IC+hlixdakzp
	Z6r3Wt29RrwDm4x9xXGrDYIjjlA7Z1g8STRkcVNgsBHgRmMyOjt0qgTdyGWNIBktAji0eFtZFw3
	F7CRSMetaOnykk0cJ4UwyeWWdMCDrgq0I3mOk4EBc/ngHO1bTFD2/W/GfiK78EemNyBFIR0NI95
	/niCqJZMtlXq+IFbaZU7SbJMt8FlSiUghgbehFg7UiEUyaNx+6YHfhFXuCEA0NtcB+aho4p91Up
	YbeLEW76tGjLk9CGqdvtEUZFS+up5IeZKOwcnYiOG6kpSlc04Dy6hvz8CImHMPrA=
X-Google-Smtp-Source: AGHT+IGxun/Yco6mevgEGwKjaOT0R/pW6Puo6dQ1aSXUtNSS99XdqPVFdMPH7X0OcIpuodI7EV7NzQ==
X-Received: by 2002:a05:600c:6383:b0:45d:d353:a491 with SMTP id 5b1f17b1804b1-46fa9a8c425mr178418635e9.1.1760509282825;
        Tue, 14 Oct 2025 23:21:22 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-426e50ef821sm12670523f8f.38.2025.10.14.23.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 23:21:22 -0700 (PDT)
Date: Wed, 15 Oct 2025 08:21:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Huacai Zhou <zhouhuacai@oppo.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <aO89YYhEJ-GDPWFg@tiehlicka>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <aO37Od0VxOGmWCjm@tiehlicka>
 <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
 <aO5o548uQAuBcw0P@tiehlicka>
 <itljl2e4rwbblmnhe2vucmsvxzbu42x5foszf4y5b63evbitpj@qsxj3amwhts3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <itljl2e4rwbblmnhe2vucmsvxzbu42x5foszf4y5b63evbitpj@qsxj3amwhts3>
X-Rspam-User: 
X-Stat-Signature: febahd6gkwzro6q1qze8o8eukphco11t
X-Rspamd-Queue-Id: 841CB40005
X-Rspamd-Server: rspam09
X-HE-Tag: 1760509284-97039
X-HE-Meta: U2FsdGVkX1+rSdD1di8yCRXKsCGtmRde69yGA3D5BFUemQj+HPNn0eLl1V6msHf0jzKEOWKiGct2ieIhTdpBPGUialSKOKWrXAQkxlFfLmeWV1zxEbqHCzjXfVg/oyI7D4xpNV2FyBO7TP1tirm6a8ZaOdiRcumwr0Bwt/OgnsKjNBKuXaCdFnixEE5lu5p8f4PfyV/R1Shk9NAKdxVsQg/WwsGEr660DFdDA+2Q4flue9Lbo1CCEJfAeEQBfGav4465qoXmdOmO3keZdlzMVvnCQIun/M118KCc6BEJdU7ilVrYypg2GacNPTXIEr7Lt8ia8dYTvJEbpth9ECmaU5sRPR8Zzg3lot2kw5LHjLGNuo0dRUedL3tglpbZMthV0fkXN7GsPqaBsAs8ab7T8N0kxe9jcJslMBlGlBILbLHMn34LvLqkBiSxXx3i9CzE61kMCqHMpPOYPP4Tm5uWhYmZk47jFY6j/Onw9P8WjIgJwY2qB7CY1R+Rh4aEAI0YB8qNV06qS+Bt/x0reK6CtibipOzIHk9LyPAWb6k9Pft1VNFfEa6Ju2QT6kDdgye1wWxyE71mjQS6IkoHUqd3yX91/AIQ+VkIh9c84MfiWeaKKfdxPol4ewL7pTagTMcudkavtekhMvdJdY4oOCuw9wrjG10Uw0vQrgcSOMWMdeskUD21bu8+XJ+yjh/Dc/856PZBlk1Ja/boQhKTpL8HTvkqrBrBGSMPweXEM4oPzg2ru8W4uo3MozHrRteWfvOJ4K7w5x8M99ktOxr3uZjACeEy1xYg/ryYWWk4rnE3WEp93fdq4+TDaAJKU7RhEbZFuowiHTk004IEoTb4DVjkL0+IazmfYmveFz+Unf35q1ssqmH1SJ6MGGVlQHw5//EbX/1ztPKmRLnEzrVY+EFH7dHy7+VRWsj/swwPRELbAnJzLKr0MRO44Xs7OP0IWQLRcoDMYN3g/HRJ/RLN9A/
 Lc2gmCXd
 D+urpm7B7q0TkzKWMg6lWdk6weYUDPul5Sx6mGTCtrfjYno6TZDCVmWtUCP0CiMVpx+U3nGWLUZ2G/W7kAguiklCo41pN05x4Z86vWYt8BUE7OCYSr+HmpP4SsQkmfgPM/P1SWiZAuSu72/9q12aakWseuurERTAzlNlPyMYN+q4FlJBloaoSV0U7VxJ6yCaclgMlwFiWQfLy9CV/QTOsC9av6zgfexwleI9ljfF/ZvlCuMHC41qPYjwoSKogdLA9cZzgZhkvVpW8tjoeVg7fazJtmJ5iHjtqvyzVvTWPspK+IBmY/Jx7+XoDqS0eUZcQKUm0/ZZB9pmNavmgPYh118BmloENkcrRjKE03qURRBFMpREM8RNLISKDHJrMKUYkpxY7VyGQwKt7fBP2lHC4DyRQGBDUpRX4prqA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 10:22:03, Shakeel Butt wrote:
> On Tue, Oct 14, 2025 at 05:14:47PM +0200, Michal Hocko wrote:
> > On Tue 14-10-25 07:27:06, Shakeel Butt wrote:
> > > On Tue, Oct 14, 2025 at 09:26:49AM +0200, Michal Hocko wrote:
> > > > On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > > > > On 10/13/25 12:16, Barry Song wrote:
> > > > > > From: Barry Song <v-songbaohua@oppo.com>
> > > > [...]
> > > > > I wonder if we should either:
> > > > > 
> > > > > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > > > > determine it precisely.
> > > > 
> > > > As said in other reply I do not think this is a good fit for this
> > > > specific case as it is all or nothing approach. Soon enough we discover
> > > > that "no effort to reclaim/compact" hurts other usecases. So I do not
> > > > think we need a dedicated flag for this specific case. We need a way to
> > > > tell kswapd/kcompactd how much to try instead.
> > > 
> > > To me this new floag is to decouple two orthogonal requests i.e. no lock
> > > semantic and don't wakeup kswapd. At the moment the lack of kswapd gfp
> > > flag convey the semantics of no lock. This can lead to unintended usage
> > > of no lock semantics by users which for whatever reason don't want to
> > > wakeup kswapd.
> > 
> > I would argue that callers should have no business into saying whether
> > the MM should wake up kswapd or not. The flag name currently suggests
> > that but that is mostly for historic reasons. A random page allocator
> > user shouldn't really care about this low level detail, really.
> 
> I agree but unless we somehow enforce/warn for such cases, there will be
> users doing this. A simple grep shows kmsan is doing this. I worry there
> might be users who are manually setting up gfp flags for their
> allocations and not providing kswapd flag explicitly. Finding such cases
> with grep is not easy.

You are right but this is inherent problem of our gfp interface. It is
too late to have a defensive interface I am afraid.

-- 
Michal Hocko
SUSE Labs

