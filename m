Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E8EC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C526B008A; Wed, 23 Sep 2026 13:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91D9C6B008C; Wed, 23 Sep 2026 13:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CA46B0092; Wed, 23 Sep 2026 13:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5716B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:26:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9E411A083B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:26:23 +0000 (UTC)
X-FDA: 85245705846.06.4D6E620
Received: from mail-qv2-f14.google.com (mail-qv2-f14.google.com [74.125.230.142])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A20518000F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:26:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FNxTzfRb;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.142 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184382;
	b=JYUUjIMJCTHU8fuJBvFA0mApLE7uANUbLSx0gxq9xn8nnagSfp3Zfl+VQMTTWf7rLgRHAj
	VvOlS0hUF8/o1nfqOBD41lyxSJUsCD5XueJR6obtt3brVYubDf6JgYVOSygSmrP+6AYT/a
	CvQ2BE6IchurslCMotlJdmnRxZYPLjo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FNxTzfRb;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.142 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygDODDMwSzeN83/ZHU0g9sP6Gsnzm05V7Ys0IkkdAKM=;
	b=V359oZw0JTkRV+VYvekPn8k3zH+bkr21owmSs49ldsOTDQ3KlrhX4Er8m/0yz5z6YyHjd7
	HEKaHR8Razg3WSTwIQ0GwZi/rPJsw5IqzLmU3hi+HKHWtc865d5LRAGFIFXRX3Fej9nHrt
	nrNZgZCA/5iygq+4zFqjd5Xj1Sqr1ZA=
Received: by mail-qv2-f14.google.com with SMTP id 6a1803df08f44-90cdfcbe20aso11117246d6.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790184381; x=1790789181; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ygDODDMwSzeN83/ZHU0g9sP6Gsnzm05V7Ys0IkkdAKM=;
        b=FNxTzfRbwuwESVdxVzItTJyE5HC11IgjvYbj7odlvklv9DqC+7Urz8XQFzk5ukiZy3
         cfKeZeyAY6/58z4sSQPgLEadSGzOb5GoscYErH7Ad8KlWjFn8BNX6u+0YB9JS+IfIuEu
         q4Dt1q16NODHWN2R63q1SipP4i0d80nnz99zK/9GvC9IaH48kP58SeOzxaSIxJVM3/R3
         SpfiVXnqXeKF81kPRORqfwnaYVdTRtQ1v3QhPw0Lr1TisJ6i3F8XbkRZ9xHZVsEUhC7G
         6tulaARxT1ujdsZUN3uQyz5srL5HcAO5iFt/QQ4nRfmmfRZrbbHPR4akIveTH9Yb6iRS
         2Z5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184381; x=1790789181;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ygDODDMwSzeN83/ZHU0g9sP6Gsnzm05V7Ys0IkkdAKM=;
        b=gcCW0Fw9SGoq0dD0FW8XTvcUxJQzj64fxKDtuoEf3X8sRz+d3LBVaZ6a7zLfWf+cl8
         5yQmCNCNWGo+RspxN6A2F/+dBMfz3VwFFt5qRL+5SEDCCKBVO5u7Wz+1pPn/9QlzmDqP
         MAw2YCbnwKLljGt07GdW777QtxADUBCsxQDCbzTibYyxbip7ataNTI7GbyF9iwC2GwFu
         0T9/AhyooTtlBGvO23uXjJGFytbyqgQ0wBGwVHt9iGAK++SI6IDhqGuZCPepvaoPZ2Jl
         GNXiZYYyJ2JSsZDnB7Ux7Wv2xuZgiPTR076Frr3y54bM589Z2drpPIcA6I5ARicNh0jo
         6iWA==
X-Gm-Message-State: AFuF++l8LZaUeP+fP2GkRhw5EJZqC3TM80DssEcGicNaFgl/Eypv/7ME
	WTZTQip0/g+s7Nntc39sco6v3p4hS7Qib6Qb62uw+cLlcxE5x/p6RTq4n7e/lWWdRo0=
X-Gm-Gg: AYBFou3HtiFXnTR2U0eu7+pvCghx3BCsmL4y/BTtjoj+RLCbx5lJO5rJkCS5grLSHGm
	tkeslZgkPxra3T2ziS9BcvyNEl/yogYJV4FfxdD0SsNxVi56HEFfU1oJ86BFplk868LKgwXxZZR
	5Z8kd+srK7l82lYkQkJgIsN881NE+bA7i688y2jzekrD/MjtHFteqkqXB6XUMaGr2duqktBZW/l
	r3GbgttdqMjrGIyOYf9Ji8/8lVf3qeO3Nahv/RL95mqVHD5C0bOXGoytRcrHAf/TTnwm8jUUeVF
	Er+/IxvHdOyatr85y6KTl16HNZ9Jll55PmGgtTrE0F4i0Ha/TpH3/W6ZhHyungDEMcd6/NcDEz+
	3LnbcTP8o4euAaAt81c8gPc4TEVl8ahztR8fzYHzK2k28ItdF1ArtfwjNRzxbakrjlQtPqeQaG9
	VC2HmnJMcWvf9dICe2ZbSpQxsnrrknlSpThipc9yQYX0A/U/h0WSCWDUvmAVFi1UMhRpNei/C9+
	vgINSORRdn+4nx5HgN5V9FlrmexBdvwWKdMSl+Qk2vMxlHHrO+0bQg=
X-Received: by 2002:a05:6214:29ec:b0:910:3ddb:d2b9 with SMTP id 6a1803df08f44-9140c33814emr52013376d6.19.1790184381067;
        Wed, 23 Sep 2026 10:26:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140c454374sm24399576d6.35.2026.09.23.10.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:26:19 -0700 (PDT)
Date: Wed, 23 Sep 2026 13:26:17 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 05/10] mm/madvise: factor huge-PMD folio processing
Message-ID: <arQLDnIocQkdRzUI@gourry-fedora-PF4VCD3F>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-6-gourry@gourry.net>
 <arP4Igew3iL9qVKW@gremlin>
 <arQGK4RbYWYm4En7@gourry-fedora-PF4VCD3F>
 <arQItpXkh7WV4yyR@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQItpXkh7WV4yyR@gremlin>
X-Rspamd-Server: rspam06
X-Stat-Signature: i4hck8rye7yk7h451q6trwtin3xxha1s
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A20518000F
X-HE-Tag: 1790184381-456818
X-HE-Meta: U2FsdGVkX1+BZDM+gGpoZb1ZN79mx5S053p3jnzmaju1woUOPj7lusqi/awKrQMzSBbDNUBDFHZh6UqFs4umQYpH4VvtP5tS225Em7Mh/kE7G4PT4469ncgVaY6jJB5uVGiZDpP2jht1SctKrwHOb+NT0KRfqNv52DnUcnXmi/xzVYzwJoyQYHR9BT2r0Qh3xEDxVHxtexJmFAg0q0ajHS3LlLKK40U1E/ScoNaNEJEWOKdnNWvxh5LtDesUXs5PK64mculTiEhtZ6GbE5ef8WCDYCr5KBBpk9VsDmS5BsWcwwqckH4NtJdjU10SuE8ZPSdnEq1GOyToOHJ0ScFLdw3gDTEEEKAiBmCzMm7Gx7iGUfleZLTYJrhTOkpS2u6Xb0Cw3blb0Kkd+480CJSND3Mqlnoil8pc7mKx8ZtlhSu1A5KWQWOHN39FsmH9Gg7NJK0RV627vje+LjzQyzsEH2WcEhwsloHLovU9cHFbzB3FKcHWF8AqOlFqTVa3kLdqPlnYLWIdZUc7BLj1DzUpEltaJSFKkUDEaSpWF11XIWWoVIHKDtRQIkuY29FojB/VbKyp5/7pzYdggHc1JiIYaEMQoXG1s7i6WUOLevHzg+akfdsYfSYNRk9EFJOLpUZ6Eoyxl/bCpWGLXuQO2IlwPE1Pzx1xAAumAlPtDnxv6D5sy0fimxEdw96Qc3XofNk6V7WkSAlehn0+wU9AU0JRKfpTIkFwRuHnDS4ULscrYDfz2cyoA7OtuepI93KW430qm+QszDxkG6U7M9KE4MGWOXLEVOxkdQjv8KgEH2PLBb0jZww8BrtZnRPPSWZfumML2vACPXn8lDEESRiF54kdWraHDXr2tnU+YhR+jAJMgJe9586YdhuH73SoSgXPeQirUIJU33WhTE/wZ8zBtCV3rZosnc8yQBy1OQR+Pq2JUN+eEE5I1uE7fjxu+3a2Nv35eOMleSrNubA1sTavRMd
 WzoXcRbI
 5an+E+ozYuNLJHw4QsppEvOjkSRc7okQMQjSJmYmM6Rjs6Sms7iP/wZedeR7UBeQtJbcmnwGo9TRjKqdmqIcx6185OlWCUV5C6JeOWmgRmSX4B6BeU8mRitVUPOiFdynoaulHGTC9in/pDg2MOWNbBaXh/RorLe/7HNUPKDH/tAgvMfV+nhr/RMWWu13dAuapCAf5DeyOCNya7lvGqu0OgSyoQBsu7oZDSVLgMfGug6w2htgHKYNPwiEM/DYrkHai/3bUtGT0MsGr37w21EN39A9q/IDv+7jcfGQgpR4ev9Hg6q6rFxiC5bnlVZcpK7WtgxNvx9ghn//z8rA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 06:14:29PM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > I think there's some tweaks that could be made here, but I err'd on the
> > side of "don't break shit" before I went twiddling.
> >
> > It is at least easier to understand, but certainly this shows how poorly
> > the original code was structured.
> 
> Yeah, if this is an intermediate state I won't necessarily insist but it just
> feels so odd.
> 
> Maybe have a look at it doing the split in the function and see how that
> sits?
> 

There's an implied v2 for this series i think, i was going to look at
this commit a little more closely for sure.  There's a balance between
making a reviewable patch and fixing poorly structured code.

Let me take a crack at reworking it on top of the series, and then see
whether anything appreciable changes.  If so, then I'd prefer to keep
that in a separate commit so the behavioral change is very explicit.

Some of the sched() nonsense is going to look equally weird.

~Gregory

