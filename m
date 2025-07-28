Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF90BC87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 08:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7AA6B0092; Mon, 28 Jul 2025 04:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798A46B0096; Mon, 28 Jul 2025 04:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE626B009C; Mon, 28 Jul 2025 04:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6236B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 04:48:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7469C12F428
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:48:36 +0000 (UTC)
X-FDA: 83713047432.22.E902253
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5655AC0007
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:48:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="On/YO07A";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753692514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR7c0ZAFAaKzyT27ZB0Kt8Fjp9yREUlIQznWSSclreI=;
	b=4DFnyJJrLGKyLFGfoX4gLtFhQ0Gikc7XBYhQ+T63Oczue7djPhWXsMUA1Bkiq5upwhUvrM
	QtjD95N5TYDVp/x255OlCfBbqJ+EABivg4RxC4U6tXZ3VoRAbmZwZWGDArOtv0xX2PWMxM
	eP1muIICWg+bSgNzWKRdm0QQKr0A0j8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753692514; a=rsa-sha256;
	cv=none;
	b=4HCVVvjwvLc0gPAw5+TAapp65gAT0GDgnEx3BDIREjFFin7qszoNjLIihvcmPOhyaHxzv8
	poPakdFPZ1MDfuDDQRs5fgMzvdGXcIBunH3NFYMlQJrZFs2LGt2wWy8Huek/3BaaIrauk8
	hcQVf4NpADkN5fEY+SDBZqdospHn9F4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="On/YO07A";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae3be3eabd8so887524666b.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753692513; x=1754297313; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bR7c0ZAFAaKzyT27ZB0Kt8Fjp9yREUlIQznWSSclreI=;
        b=On/YO07A/Jv3vTKrR3T4PGXzLhav8WNiG05OGVDkLRoVlD3IFh+xnpw5Sc8OJ3oV6b
         j8lYu+HwxWX48+5l7DVV+5hX9wuYBuayx7DepK/Zgs1Q/WGpLRbFv2NeNx26t9+eW6G7
         NKF19JfmwKkUEmTgRJPiJI4Pb6Fi3pzUz2YlrMpX2RcB4o6Vwhjmrj+2j9JHtTBl/22A
         ujJjfVyAmNOxBPxZ+0Z22u+ObGOjmG2Mch2zzDpXkR/VVa2ERGSh8GiUjWk7mp8GX2Dv
         h6zKjiiNAT0PpA/zbgQdZfaQPe3KMDEDhfNsH7xAifbsS/aRq8ah/VMb9rIWwkQN+cTZ
         fvSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753692513; x=1754297313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bR7c0ZAFAaKzyT27ZB0Kt8Fjp9yREUlIQznWSSclreI=;
        b=Gnybz61Gfc3D5P8LsQ4opIuk7u40eBt+6Kwquag1YqMFwDll38DyVTXwdjgnduM/tB
         YZbzd2H3mX1eJ9XluR8p1/yoAbGAaTHyz+d7nW7td4UJrNeNflXzqm+Y8GLc8gKB3BC8
         ub+3nqIe/4dG5c3b5h9QaUnegrtgAZJZ9Nra6z5GK+shbfg8fI8N7NKjyEOuKBuQlRhE
         BjuQUvizh4bGdHP99OOksdb08eYtkRbVe+kua8aIat36V04pwySZpDggsFGdESCj3FCb
         konB9vHMUyX32jiodPHjGS+da6/loIHuBL/W68ZF6Lt8lC6zmBRrLDMs2cBxnkFJDX0M
         0Zzw==
X-Forwarded-Encrypted: i=1; AJvYcCUfBeHVOeySIff/lzL3x2r6TKmcNy+c5RaroU/RjQaTSD0vmNCMStRpX9VYrpdm1XiTE1g/sH8CqA==@kvack.org
X-Gm-Message-State: AOJu0Yy4bhHg7w/a3cSpV/ayKux73UIAf+gLL7AUqtQIBqKyN31Du8jv
	JyDMkKtVCOwTtHT7WqhRiUKVK5EABiP34rGQq5oeYKpBwAMYIangsaJ6pQYfz0TE/xw=
X-Gm-Gg: ASbGncsyeFSu5109+vEq33mjMHc/p0A2m8bH1zpd9pciEnZ1+WB4Uc7Uevhohhp2ynG
	dmuwJ4zvG4XrVfu6++HgkhJHiV2dILbqLTniYD+NYHncTxv6UZA+vG6tBJ6hefnfD8o5A4lRcct
	d+7NENgBdGCBxVruvV0pYCgQuacWwZo0HwMbY936dcTkHD7tW5/MclpvbnMC1T3ceBZq1srtLeu
	0XUnLH3RKvK43YcPLJhBiY7cepmvOxkRbFgvP+NkeiZJY8YRqxkrxr5RNAk22HJQaYbPlbWWkkg
	LQu7uowKT7FgUmhe1UyVO4PjuJ2ia7OIKVeszZUMvw2eOSAqlkjWajMP7n8EN1kELzYajxzUJpN
	1o06U4t8ukhH/3G18HlPKzBLJK4pKttz1LhQ=
X-Google-Smtp-Source: AGHT+IHi7H8NR8o28tIzJSeZI/+7HlESXaOn9KT46vVqBAUj4Gay+LjMHcsh9y9oWHszFX14+DDgrA==
X-Received: by 2002:a17:907:1ca2:b0:ad8:942b:1d53 with SMTP id a640c23a62f3a-af4c4908882mr1459481766b.27.1753692512525;
        Mon, 28 Jul 2025 01:48:32 -0700 (PDT)
Received: from localhost (109-81-20-172.rct.o2.cz. [109.81.20.172])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-af63586008dsm394972366b.16.2025.07.28.01.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 01:48:32 -0700 (PDT)
Date: Mon, 28 Jul 2025 10:48:31 +0200
From: Michal Hocko <mhocko@suse.com>
To: Oscar Salvador <osalvador@suse.de>
Cc: david@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [RFC] Disable auto_movable_ratio for selfhosted memmap
Message-ID: <aIc5XxgkbAwF6wqE@tiehlicka>
References: <aIcxs2nk3RNWWbD6@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIcxs2nk3RNWWbD6@localhost.localdomain>
X-Stat-Signature: is88myqam9poe33fw359uw3ypudef57g
X-Rspamd-Queue-Id: 5655AC0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753692514-295079
X-HE-Meta: U2FsdGVkX1/soGyzNV8rQkmyeNWzYMOHF70MxjciABzJrxAeWNJ4A6q1qU9Er/kun8Pu6dxk+Z2zn+iT70H9IWCmf4fx5sLnw/hvlnzQ/hyTv9l58UAr2g3yM6UDMpyKFPzkwmZ2PFUr9gV6YaUxDfpAb6TlwSc8DWZCW8DrMe4RRO5D4fhjoyaW33K/xuwd3LGLMlKWKwsX4LczeMf1/+0Onso2xw3vSevFMjecz8MQ5ojomFnJwqqJU4NFTxwFsg7LLrgjDfAz/yLIsGLdZ8l3cKnzF5dNNmzqn1a9RvaHtzlUfU+EuCKcFTb66TyEAAT4KSRbN4/4SLufMv+eTFtFUthznZZt33wgdyYHk3YowkFhUq9H6NtinmXZN0+6g52lhfbaep4Jl/ky1KQ6lfB0YDZin8Qz+hrh0G0u1ny0YOZIxQSF/smXm4UdwezXLlSDcnukm+22Xwl8F8IH5I5WMIaryp18xpD8TV82K6rg9cBZFR0Ky7R5WzEAjm6LL8TDVu8Fw/D1n/O4O1uSCOO3ouTW1Ciit341qgg2F0hiDvdRyg+NXcQ2dqhiN6G1j/DjOUb4jqMxLL3uP0Zr6PaLMRGmKx2cfjFyIwgO4iVwRZncH/u4b3ozi49lkOusTGsd/WblYxCI711ECmOGty/mi7LlK0q2kBbxAu/gH8Km67tsobQ/5VW14X4FVr9QXIcQYa9M+We+szib4FS7VYp2YGEgB6IGjFQxhvQApLkzt6hBd4yGPFK8+2t89CR3z8To6NqOEj09tMVWnpEbI2pDas7Nsbqqlqg07kOwzGpEORy+juKK898FGO07R/XxFSVUVYTk/vUOCo9ko6cVZTjabpxTNvFd/JJ9eNQWvcK++6bHklFQd/eIQDkB3OLDj92pvWqzCnf9Irvn80LOPKqHxks3PfdW1OyO9m6S+lkPW7GkY+sDqPk3tCwuANtUbNuiqo3hp2qw0lt3p6M
 kYOkiTYk
 breHmbpPkkGhdVSKQvuqeur7wCdws8j6YN33Fo7GZeIsnLokcJf39Ij7kvl/eIh5ekI9BWHw2NmA+YzWReSDvwIw0WALEcJCS4j+xdTmzASUMNYfTgKB0Y2frGVpNuANOyBIDKyJ1+f6GYZPymsvzFjRnhBAc0bPdhzcnJH9qGeNWrmWbpKiIMGThjxWMm9+Wi4H6lLcYZC7ad+KcHwCdnRDSUH0cDzZZXeQqiyKnHT1LeFWKL1UOG6zRFYKm5SYpXdd6N4SsDwmTzzstqoyxAzczcAbSJh34b8g/3KF67VzISUVSZwBu7bZCgKnqQ+h2lMoY4bJU9cbrJCZYKkr6BeEvbg0E6ojcxXrhiWmT+jcgrsptTS3eevfUxWf5/LuFrrQ3V3J/RPKhKATznEd9Iw035w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 28-07-25 10:15:47, Oscar Salvador wrote:
> Hi,
> 
> Currently, we have several mechanisms to pick a zone for the new memory we are
> onlining.
> Eventually, we will land on zone_for_pfn_range() which will pick the zone.
> 
> Two of these mechanisms are 'movable_node' and 'auto-movable' policy.
> The former will put every single hotpluggled memory in ZONE_MOVABLE
> (unless we can keep zones contiguous by not doing so), while the latter
> will put it in ZONA_MOVABLE IFF we are within the established ratio
> MOVABLE:KERNEL.
> 
> It seems, the later doesn't play well with CXL memory where CXL cards hold really
> large amounts of memory, making the ratio fail, and since CXL cards must be removed
> as a unit, it can't be done if any memory block fell within
> !ZONE_MOVABLE zone.

I suspect this is just an example of how our existing memory hotplug
interface based on memory blocks is just suoptimal and it doesn't fit
new usecases. We should start thinking about how a new v2 api should
look like. I am not sure how that should look like but I believe we
should be able to express a "device" as whole rather than having a very
loosely bound generic memblocks. Anyway this is likely for a longer
discussion and a long term plan rather than addressing this particular
issue.
 
> One way to tackle this would be update the ratio every time a new CXL
> card gets inserted, but this seems suboptimal.

I do not think this is a usable interface.

> Another way is that since CXL memory works with selfhosted memmap, we could relax
> the check when 'auto-movable' and only look at the ratio if we aren't
> working with selfhosted memmap.

This is likely the only choice we have with the current interface. We
either need a way to disable the ratio altogether or make it more
automagic and treat self hosted memory differently because that memory
doesn't eat up ZONE_NORMAL memory and therefore cannot deplete it for
ZONE_MOVABLE.

Lowmem (ZONE_NORMAL) oom problems are still possible but kinda
unavoidable no matter what the hotplug interface is as the CXL usecase
really needs its memory to be movable to operate it as desired AFAIU.

> Something like the following (acthung: it's just a PoC)
> Comments? Ideas? 
> 
>  diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>  index 5c6c1d6bb59f..ff87cfb3881a 100644
>  --- a/drivers/base/memory.c
>  +++ b/drivers/base/memory.c
>  @@ -234,7 +234,7 @@ static int memory_block_online(struct memory_block *mem)
>   		return -EHWPOISON;
>  
>   	zone = zone_for_pfn_range(mem->online_type, mem->nid, mem->group,
>  -				  start_pfn, nr_pages);
>  +				  start_pfn, nr_pages, mem->altmap);

Shouldn't this be a more descriptive (enum like) argument?
ONLINE_MOVABLE, ONLINE_AUTO etc..

-- 
Michal Hocko
SUSE Labs

