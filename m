Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 839C9CA1002
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 02:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF09B8E0003; Mon,  1 Sep 2025 22:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7E98E0001; Mon,  1 Sep 2025 22:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04748E0003; Mon,  1 Sep 2025 22:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B05ED8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 22:10:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 512AB1A0A9C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:10:14 +0000 (UTC)
X-FDA: 83842680348.15.C405D6E
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61D99180009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:10:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="D019CI/W";
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756779012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMToDNcwi+JjPobVyHU6qbfn2l8RCkFP2dBoE6EGpl0=;
	b=VgO9sjQdNkPYDhW85d4cezj1q08+38uY52jlhtALUFQxaUhbHaVe3DXPX1IBBGqFRTgKNW
	/i3pwUyuhEUp5IxsPzLrp8gIxTHOGxYAXRREXKZXD2JzSYlr37ha6gJ2A2kttxp2tf0kgZ
	vs0h+EU8QTcW8/8QBtmqFszKClqUdYw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="D019CI/W";
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756779012; a=rsa-sha256;
	cv=none;
	b=4ko5CkCE7IVVdrFDtlXY4vDQZ0lnR69MpALuMHgjB0H39Pt1OF3DXVY36xWcs8L57O14Lp
	bKMnolZCfm0D2BX70QHRvQ9nIgUNbcMQrzSVQcO4kwtQjznzR2R8/odPaKNIjJQulrc6CC
	Q0dJSy9pK+J2JkCm2XtOU/PRw1vQ0bA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24457f581aeso44730755ad.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 19:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756779011; x=1757383811; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMToDNcwi+JjPobVyHU6qbfn2l8RCkFP2dBoE6EGpl0=;
        b=D019CI/WyeqFK+UMgdpUJgaVVGuH1jzNyp0Hm7q/L0Q+1w2rBHSGF8Jb0syQjwSxDs
         bkGNW7TRjBJ7tLTMS1Fd+SmAUR16kzISpnCFgAYgt2BmSb/iqaVBujWfmfFYvZfRlUlr
         k6idJHNflNG4twdIGmg/LJ0Zhzh8TYZM/CnP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756779011; x=1757383811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xMToDNcwi+JjPobVyHU6qbfn2l8RCkFP2dBoE6EGpl0=;
        b=QXX+bheHkVLEoC0qWpX6OOitpjN3FjEXjhKGrzSD2Kbf68bOP2R+2BhB0teJBLmgiM
         R9V8twyXA2l8grCmDKaGubwfcKfpd3BRJUQfjnfFlN/Ns/lQ7ALuoeniTgmnLB+hJoKX
         UXlSjhJuvi/mDhuncPLfzZx2BWu3MNg6xHFHhds2piTK9iSMjTyEwUzkTCezZeHQgyIQ
         Kb8V3lM9X5pOPcy/eVlJ0s2fd4JTAUzh1ERu4xDLpqt/wY8Sx2MNMKOea/q2VrMCdxDQ
         7f0MXkzZ3RdHEwi32+CyCmVIy78rZYw4D1LNV6KeqTFfYNUGZ3dEJGhkdx1MeXTGswZ6
         Wo4w==
X-Forwarded-Encrypted: i=1; AJvYcCV9RIcvYjIvh8Ge59kUnQaQnB8fKU29YKc/O4er5qseugLjlyEl6Frjvc1P9si6UOkvCLYHTQGFGA==@kvack.org
X-Gm-Message-State: AOJu0Yy97HL7EshnsPQ4Xn3eZrryKA0tGm81h7J5KjHDWR+gM8rGotlS
	Vmx0J1KSUAZlhnIRLIdHHyUXKSfPIZ9CfUN0SKOGgdvoTecNFQI0O30b51ZbR0dBJg==
X-Gm-Gg: ASbGncsRH3xHm/SFiZj0mlOudraFVSH4yo7t1KhOenxdgyPycCQ6LyXqMO8cHYot2Qo
	8+MRCD7OY5xxW+L/WQ4/Nbpdsu426U8a9epku8nrA2EM93gGHKPduLHZZ73iNbmoDgmFJMcG23X
	m+cqHqdsC3xOtlW64qxljwSDZY8vAnG75UXjgQAM4Nre61XphyPV6sPsxE/7P/qUSUFEo1rgb0t
	RnMyoPAEVSWyPd4muDRHIzMZOIjvDX7PeHd5ao8ieM3stNL86nyyRVz0nhdU6yqTgFcR7JwPdPd
	ii+HLlFv2BbuczmK0HPmMdv+cM1HqupQTwQcnfpmvk347iKoHYohwuzqaJxq3bGgmQI7pbEuuGD
	kn87Q2twctoROppJfINUGcGzsHg==
X-Google-Smtp-Source: AGHT+IFFsgaUMNmStaw7X17phzd3lUhWjfR+pBLqnu11jIGmAdr9OFQevWfZTFcfLRVDyRy4wJSiFA==
X-Received: by 2002:a17:903:28c:b0:248:fbec:7c99 with SMTP id d9443c01a7336-24944a7728bmr128727935ad.26.1756779011223;
        Mon, 01 Sep 2025 19:10:11 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:52df:d776:7862:776f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b0d881afasm9754075ad.47.2025.09.01.19.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 19:10:10 -0700 (PDT)
Date: Tue, 2 Sep 2025 11:10:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>, 
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, kernel-dev@igalia.com, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>
Subject: Re: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Message-ID: <ypp4byiagmgmdaaq3wskjxwxvub7pxhhqlvwsrhsyqlapqp5v2@rbfidxth3z6z>
References: <20250901183729.3900578-1-cascardo@igalia.com>
 <f25b1ad3-c2d9-4267-bf7d-f48c78beebc7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f25b1ad3-c2d9-4267-bf7d-f48c78beebc7@suse.cz>
X-Stat-Signature: mkn56m9z5ftt9yom1yipbxrz7ibs3u7q
X-Rspam-User: 
X-Rspamd-Queue-Id: 61D99180009
X-Rspamd-Server: rspam05
X-HE-Tag: 1756779012-883100
X-HE-Meta: U2FsdGVkX196JupRd/eugG6KOqUqRLC9LL0lhdEYKIMdof1Pv6/4Z8Yl49JGfGgEjVmwf6jirngOVXXVQ+xF77DRBLQlgFwm67R5qwfHgJhEcZStaPkh3x14IABJPcnBqoR68EZYQWe10IyaPis5vUyc7O5SokRTsstCETikDzUKrepTiyqYl/KcBE5VZ1EBbdDxCsy1yuXQtWBEa0PG92+VvwNHYpK5SXU9+tGI82LEpVbbi6udOM5lbB6oBUsoHuvVShDyJbaCvXJWggZBRdPUQZzt330tiEYMiRk+z5Kq/2iVmuhTzUmHfA4zOjJ6ebG/LIDzgAUhvoC3dwqrX/jgQxDixal659bpDzscuNeC+iiesp1Lz4CLwYic8qw96AKWgdkTpC5/WoWZNmATpQ1tsHrlEmF0l+CbeZOdulZ7qXLk4TJRLYKHp8BU4Fld3c8WCRm8rl/VZRfietEFR93847dFcnbmJ6T9vRvLmLOdxilR/x3Dm/1Hvzt7tZU7mfy1e6AIGkm2dDEuicYzKe5SIjh1zCPO6yo7i5/Yczcv/oOY7z2LbQvhfMuBO5T9GGUOJJqKkXQu1pQ+99+AkQUog9z1mLRAUpyaC14RP5qoaPubseaNO9JjmD6wsdlR/xfjVVD12Zu7JLfW8nD5yBK8Zj8x36ggzZL9JMMYOIbjnDT1WlBpw6LD7sp9JVHDFIlSA+vMmVpBFqP38QLIAPxT8M2DIgFQBoZGkzztcJ0o5v67Whxy6EvaP/1l0fFhOGvtZBBTHoV51dfTc7Z9TkbRwnoFIMtOw/zJqj+RTjGJeTghgOc2jIR+IQodOKeaneCmGhruvr9UiwEpW34VwDW6mZ+BVQu4jnTvSbgFpof1mwgA3ueI1mF8vy8xNnSLUA15/QFwaMoJtGxaQ6/Sa8yQEgsMaecYtEhSMle+VbXHykEAFPuDFpNM+Oab8+ZHjhfW8LOuiiGt8J8ok+3
 i/LTODy4
 m7qVAG3QcCsyhbUMFcU07CvcV7S0o5M02D9bfGM0QkfBr83EEveUeNDxcccCjPSq3hW+M7BPJBZ8/7CTu0vxslNebQwCU+UZt4Ydr1PQobWTavenLbKva6fVbMUTZ0cOvOdITgnlVWvcF9HRN3V+muXdKd7vzJ70tQbPBW/9uVmBfXoH1dXBZFF9ZMe99lDsaAAfTJ9a96txdPlLHvGW911SpfO1Nv6uG8Zq63d95y5Pvz0ofwnhtAVBbF/FXw/dh+aKmkgQd/x+4It+G5X7O04YnnjgsTGoDe5KFY3aCJvEoT9++SL2wbN4d6zODVLvj3xgwxCaFpaE/gZxAHgqOVLlLp9eYmRTi1Y70HzSXI4VkrpqHFTUj4lnJmzPjdGYV3Az6DK/IpWnsrepNgagtF3Jwan/+2I9LloZU0Gg7VCplUB1HQ3F6JTU92dNAFVHjpoAUmai/Mb3MgZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/09/01 20:54), Vlastimil Babka wrote:
> On 9/1/25 20:37, Thadeu Lima de Souza Cascardo wrote:
> > When OOM is triggered, it will show where the pages might be for each zone.
> > When using zram, it might look like lots of pages are missing. After this
> > patch, zspages are shown as below.
> 
> AFAIK zswap can also use zsmalloc so this would be reported for zswap with
> the same effect too, right?

Correct.

> > [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> > [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> > [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> > [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> > 
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>

