Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CDCA606B159
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O219Tw+0
Received: by kanga.kvack.org (Postfix)
	id 9E1F66B05B3; Tue, 10 Nov 2026 04:53:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9496B05B4; Tue, 10 Nov 2026 04:53:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7666B05B5; Tue, 10 Nov 2026 04:53:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F67F6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:53:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC7971A02B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:19 +0000 (UTC)
X-FDA: 85418746518.29.8AC4BC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 515C5180007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:53:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O219Tw+0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794304398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEXSXYkyFGniiZMHCfKiWmZXRWV8IRfRZw7Qjxv3Fg0=;
	b=SLODH4vPxbw4717shPIYxwgSX2Tu0LNyXtYt1uBZM6pIB3YF/roL5gDw8axahpK+tUarkU
	GcZwODroHeCfN87bqyQQlxeo2Q2XeQJv/1jFRHno1fDKo5TW9GqT74x1/SpDcqKwnXlY3b
	oxK1rtvXKYRl+G8mZKf+wc7icpRPA+Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O219Tw+0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794304398;
	b=RkoEVtXpVFUhUfBbeVzSySN8D/TT6KdHM3G3jo91kJsue44BXdo4mxjyfeFkDb5Wz2MY4t
	/298DiEpnYjbs2aOZ+e8Xk+chLlY8DGwZjicc4bP9oIe5v/oTjfz+AScKrRRIHK5l0nGVQ
	Yaib0e5ij6hETBIos8Yqecp+77n+haE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 705D042342;
	Tue, 10 Nov 2026 09:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFEE1F0089F;
	Tue, 10 Nov 2026 09:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794304397;
	bh=mEXSXYkyFGniiZMHCfKiWmZXRWV8IRfRZw7Qjxv3Fg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O219Tw+0gQgtbh8myx0h+fAxqq9gpRZ6wwraMvxP5lNiGxivADhjo+V0kYMiQ9P6C
	 S/cjRdnFTOYJYUqOuvCjDsPXT7If+daCVRTTQ1eLTJBilt7IpToBeOxDnLX1RvIzbe
	 KYCc7GgLJ3fyzD1kTho3QBcc0zmzcgxPH+yMWOxXU9Zrzkw5Sz10gSBr4I+Li5NZYG
	 dgErCIIYOUxA3I/00W5ymL/GoCl/Q+sWn90zsL/lH5ZkPbq0vn/m4pMsQ7fqMqGp/o
	 BYozLQP38VBeIZdHfMiDOqIFNJ6AHGwYEYk+2D8g1BoCv5qnohbabF/ctcx1PeXTS1
	 F29P9NALjLwAw==
Date: Tue, 10 Nov 2026 09:53:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
Message-ID: <avLpQhAv8MkaOevD@gremlin>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 515C5180007
X-Stat-Signature: kre46qscpuxr3ziw17boin475yg9n5q5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794304398-499119
X-HE-Meta: U2FsdGVkX1/sPG0rnHlOU3e0QqkhgMbO3oGoWR3I2Ns3xDiNzu3IQNDXpNIEgy0a2HJlmyfIaWGRVnqwpMhpR3Xk6n4DvEy5yCyLhuId5QQthUQAo1b08qihkIvtaEd0zKE3Ki24596kDLxhq4kSy1zGt863DM+l2kIhS7Nfo0C2rDHBlY/Sby75Upa+yqjRlLBt91I2n3lBtfKkHd4GT47LIPihOSnCgfUckEkdioLdPrrQZXBK5rNBLvZ7AtNOFP41kH/5A0KUDbqYaEm9fBw1UdOW1d5Hn6l7GhP2jkYaziwrON00OX4lHxfKmd2G9CCstW0gr6pr3A5n6nWIpwriITuIFe2ooJChJ2CFCcJBIHfrbArjHstkUT3I64GzwuOrBbjkIN5X0ryfQe3MfomSWAyNrqmMHXGqIxteH3G8/rvnvEMsLldGu8RzCWAigwwdwrekVB1OO2/QF40xdw6BYbhgMocHxylctdzf6UYzG25a6Zprjo78nQW3miLwpLjuH39tvgyyeK/EOqjWk9gAuBL3dUN5VyZSOdUG24y3ACR6rEkTmHVLusyMyyK5pRNxJtRSxMx/4FXFB0CmZypn3MsiDVm5GIMuXzU7KVX9meYxGME39fTvepScZCd1JVn3963GtcSfsGhxjhdfD8JZ9mx2tmhyIYeXYmGh91zFqdgkDV67p96KSZejrlzhSaH6Zt0mbGJn9t8eEqrpUZidNmgkdffhTepR/g944TcnodJI4gAnpwEINDrxkiFO14uVjQxcwGyNofUrctWbCeRA5EquAviKkyisRQQ+NGC9BAiUap0+k2af8JG1iZJE5H8ZBMDXMt9iS9T2oog1EgZUxEF6p6hyMBeHbZEhCcIO40kYu8GdNVWBhYBZ1dEoRpcpJnbJKOyOrx+a2jjvbfNqxiiKCzLWUB9IDdFnW+tumBRPs/bFHQ4aiJi+ExNRSVKo4RNpQBikElAJk5N
 X50nntjT
 KeJ8ll3df2FdjaXoFrxOcm9QYmVyIi8YplCKMsIlkhPOoiVpNOd4kiG87l1pk8o8YbLqz47FDOl0+1DRlE9JaGX+gInQaIhXxyZ4k2xfxO7yrbJaanpkAuSgJXF7YIhJ/RXV2GhmGTTASQzFOOOWZPYkrFSVrzmQ+xqY8vkY4udrENb268FVVJID6BLUaULUkzNTJWWjRtvcypo5FXs/N69yQ7szxHPejs0XyWbzz/w9t2GFgmXrpa8mnGxQcSbD/7Qhm+51fitfuH1OEYw4BlM7vuByXwCtla+zG2MKyzToJHBykT1i1ZwHpHrMq6RX0Pb2rhSCtXs4Nd8FEGG4MpRlAp9i7PzxzjjqJG3eG+TfKsijJpqPG52Zz6i6DBUrOw8pp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 07:31:53PM +0100, David Hildenbrand (Arm) wrote:
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
>
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
>
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Congrats Kairui and Barry! :)

I am so glad to see the proactive efforts people have made to get MGLRU moving
forwards again, it's a real success story in mm.

Thanks to everybody for their efforts in making this happen! :)

> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..e7ac319a570c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
>
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Kairui Song <kasong@tencent.com>
> +M:	Kairui Song <kasong@tencent.com>
> +R:	Barry Song <baohua@kernel.org>
>  R:	Qi Zheng <qi.zheng@linux.dev>
>  R:	Shakeel Butt <shakeel.butt@linux.dev>
> -R:	Barry Song <baohua@kernel.org>
>  R:	Axel Rasmussen <axelrasmussen@google.com>
>  R:	Yuanchu Xie <yuanchu@google.com>
>  R:	Wei Xu <weixugc@google.com>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

