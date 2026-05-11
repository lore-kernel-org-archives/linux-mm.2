Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3276FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644336B00B7; Mon, 11 May 2026 07:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F55F6B00B8; Mon, 11 May 2026 07:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3E46B00B9; Mon, 11 May 2026 07:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7636B00B7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:39:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C95748D80F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:39:54 +0000 (UTC)
X-FDA: 84754944708.28.C301095
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id C0ACE4000E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:39:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QvNa8uuM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778499592; a=rsa-sha256;
	cv=none;
	b=iQZ+XwWZX66TFPKg4+CBgDN43MQmsMn7xTL8wQEBJTUioTd/E+k/Yq4HqvvH9DTLtJ+5C7
	PdOGPbyYXhtIi8JHTeJliG/awlSmLuHGKkeGql8yMCsojUrkkOGiyD2QfbyLk5G0COOYPh
	qx4KOR2XWgyYbd3cv7wifFtCOicSY6A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QvNa8uuM;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778499592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JXwoxY9aO+DdJZo6FW5QgM56rkq1xPTTIDZwqNN6ABM=;
	b=nsgccf9PzWtQBKM21d7O6JDtL1U3oS/ZhTLH0aadMU8BD1u3Y1tnxoJh413jkbB/pfFvNU
	3Vefo2QnGPixZ0HLIw7nxv3RW/bGgCK8dHOt0TKYcpAEguRqx+yp/J73R5gAZL9cBVl3se
	3pxQaGmWN3ZXxKT+iHle6KvNtMOP/P4=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so45237985e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 04:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778499591; x=1779104391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JXwoxY9aO+DdJZo6FW5QgM56rkq1xPTTIDZwqNN6ABM=;
        b=QvNa8uuMKeWUWW7dEkZDt+SJNBlrEwamt+rFcrHtwOmYmaMoUj3V8CGiqaNkocD/Us
         uBxUk9PAgqAK7/9yejtY+Zh11IyIl/x4CzxPEJ7wth4G1e8ufqZMEcLmpApHaVX9gQBD
         zdo2pyswIgOoStLrztNwo91a0xh5HR/dAf/hSLk4Arx2kAb3zndSwJ4+Yn1W9Boiaar6
         vIUyx86sasZDtbmrs9gRHTYmgUPqUYokPomx4GpdxZ9ruC+/TugmSVJ5eeiycv6f/czr
         hVP6UJbsBmdeI9fd9M7I/FzcZ8erw1ely7adnbbFhWdiWJv6N1lqr0l8lRTuysuKvZDq
         3C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778499591; x=1779104391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXwoxY9aO+DdJZo6FW5QgM56rkq1xPTTIDZwqNN6ABM=;
        b=FnyThWbgntEGz5lg8qrLD/QnOURXhagLCEkbYKxx7epa8aTihYK8FJ0EB3OtLeezz/
         OYKTS5XwG9o58HQUUC3+CD0qnqDE9mZevVCcVyGlpIxC0+TqXKVDHuFv7rJi1WtMWqIc
         +PjMuJyUiJrwQYeU477an3LyFSwTE+RfoBcRJ00KRJWf6z0oeKRi1xjDStsKBKFW++H+
         0eoQLF3miW2CFjOi/q22RUorgkpwawzKMTJdL81X4Bn5zQDpe6WBI6OffVxOWiu/hmlz
         cNOVXkEuD/6m+kPAIDJ1lG1Pent8mJVYCwrfY4dU2ZXvE4chveC7aUYELOjvhUgn4YPw
         +HGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8l/yrWTx2vlVzTDX72/519/5BPX6iW/VMrlWuOhaIk1k7c5x00Jw1nRMFmbU7ztW3CpdBsNgt6AA==@kvack.org
X-Gm-Message-State: AOJu0YztjnS1lZJ9vnaePc+FFqH0iAyb2VpE0adGzeNw0LOVbR6YvOfC
	pfaIw1K3hJptmDorxu9QKgR+cy6jJV7l5XZMtoJir9xXDyoMLn4MQFuBERDIm86KY/U=
X-Gm-Gg: Acq92OHVVvD9YSLfOA5ahDhfEUsmw6qkE0d0GOHQJ/AK5r6/tSAoVana5q2Ym0eUWp1
	wr4AQMBab4wOpT3mNqdDdvuYeOBFiFJP+9C2JC+tOfUzlL6NU6IKhYzfhcPW9f/MMsy6NZjpbhi
	rNToWUe1GC0945LBSWjZ9T0FnCQDZT6u+IBKuGjlUihamRrKiw/9hT9p9PVGpC/9Ogx1zWP1DbY
	maJ0OB1D2bQALj5L3W7u4O1FXCtWLXZwUUPSO0tCn/YSIJ50wQEYpe78e8TodReoT5pxQEVMn0l
	8kGbORh8SzxES9v/d69EAJ6ZjWdvMVpG7Gz/VHH6U4zUCEtwQuVqBgvdaPA9Znf3PYvCBh3jjq5
	yQf2GtsI0DTYjuB6GbwSmCgW465wxfSF/n3pu7pZ3W1D0W0GHai1jYCGpOClg0eb/2CTAO2AGbd
	sph34DO86fj1ONWL1wH7XFNAzpGZoNi4y6yoTSMbstfTq1ebGo
X-Received: by 2002:a05:600c:83c5:b0:488:c683:be89 with SMTP id 5b1f17b1804b1-48e51f2a759mr342964415e9.9.1778499591165;
        Mon, 11 May 2026 04:39:51 -0700 (PDT)
Received: from localhost.localdomain (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6db0b08asm83235955e9.8.2026.05.11.04.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:39:50 -0700 (PDT)
Date: Mon, 11 May 2026 13:39:48 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH 0/3] mm/zswap: Implement per-cgroup proactive writeback
Message-ID: <agG-gNEclOVf-9WA@localhost.localdomain>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="o3jizhh4qfyisfpc"
Content-Disposition: inline
In-Reply-To: <20260511105149.75584-1-jiahao.kernel@gmail.com>
X-Stat-Signature: d5retrnj4prr4gjisr7mxz3zjemqex9k
X-Rspam-User: 
X-Rspamd-Queue-Id: C0ACE4000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1778499592-78449
X-HE-Meta: U2FsdGVkX1+Llk/m1OifSSayK8Mgdr2CtCUrFrMS2XBPOZBBriRoGOa+QXUwlf5b94WKhgSrfuF2/jJ93DWmG4S7U/+mF8U6/XfuNPnu5vhgMZBxUxop3/F4nmuxnGJXnn76WLf6WfwI+PtIFwtClhhw3QFGKlo1jlabgLkaMIFg3zKSvssnua9LFgT2EeuV8hLrdlirWSSoFDCDZS1ZUuov2DWPL/0yBJSCdmwyhYhvGpUQX4yw+lysP5NaijHla/VsZgQ6RCLC07WX15i8HyK1/Zia1IbqbEHFCo41A5fHW6p0oWpvzfxumamj83Xqr8BRg3qrdxJ/i7rnD3gHtWggs1/5La0dhJHjI5r/WxvcMIcYZHOWEoSF6v5sNcCn00pPI8cE6gQAqwU5dEcUhq5A6Ak94birvQ9TOQnC6AWC0mkudD5vgrxXK8Kq1871WVf3d51nGKNMyBzH35CcivFKPZyITd+GKQ1EnmujTA0JvjjOEHyUQkQqbmp7Wquujhl0DH80blEz2pJDQdEQTBRyk1Xe+HmONvYXguHLKtPc2XAuU9iQXl7W19Edo3dZfrxckFwc7byKPlT84LFYxtkMsZMg9faomZnD7H/gyISoHsXhxr1WT4LNkxMSolSRI8WK82gnQR+KGnOFCKEorndwl499yIKqmeUd2SywL8sTGTo4Han9DQESrHP7OMyb2gLUjbGY49VdoIqJqqrAKlaH1/y3leGt62I158K8a9djqa9rVXO5B3VOuGfEvdyQCEkV843WEmwy5kbiODyXm7CZL0QnR1oOYXJoWsnRyw3D1Snkp7GhBQMr+9XpmllmFFk+mmbGdTzD7tQXLB5D9X/aUJd18KxE/nQTi99YrhLGTomd4aMaSBP1oDTAOcYM97pBrRacFcRL/AhEhD5IeEYyGX1KKV3E6w6FEzznJmP9syAaZBnP7pZ4DjtzeT1ruv2MTbir4zX2iNy1EFX
 RwVUSEQ7
 4hJ0Jcza1YWpphtgghjIRc+uuihfyrRbX24hLLlviwIP3iFgrSj6R2fEaOTTKb0eM1iNJ0qswJUKW6It6D8qD+i2AqZcmhVEd9kEVGJy/JqFhbcTcAE84tNyIUfq3/hUBBL34N/jT03p+n6A3tF3pMdUOOci8MSQcMiOiVJ9gGM19ygWUo037s1t2c8ugrYOl9iki8+XrULMjH/3Qh4rvBCFcPr4V0ag88cE/c5alg4Ao/2utlTvEadhbNypesdE0tFxnb82LFB5DHL86gnnyumz3Ezqr6CKkBp+NhG/d4wrcQp6JDy15s0+xro7r+uCQ6SIxpsJaSC66/5uroiasBVA6DM29MrXu50uEQuKRjQjAkG5D/Vyf4z39YBDMDrw56CMc9m6bR/bqeL9blMX8L/liM0UabCyOgHC0vgB6u2un6KWJE8ch8C8ykntpptJ0+74KEREOAMmpbICEg5CUGZLv+MHNT36t//3F2zH2ybBS6/gd0k1/ZFe7sQRZatdi2hho45yp4cnrRvLTDsHdX0ITcqDOy/CeHY8cSGyywF/8MBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--o3jizhh4qfyisfpc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/3] mm/zswap: Implement per-cgroup proactive writeback
MIME-Version: 1.0

On Mon, May 11, 2026 at 06:51:46PM +0800, Hao Jia <jiahao.kernel@gmail.com>=
 wrote:
> From: Hao Jia <jiahao1@lixiang.com>
>=20
> Zswap currently writes back pages to backing swap devices reactively,
> triggered either by memory pressure via the shrinker or by the pool
> reaching its size limit. However, this reactive approach makes writeback
> timing indeterminate and can disrupt latency-sensitive workloads when
> eviction happens to coincide with a critical execution window.
>=20
> Furthermore, in certain scenarios, it is desirable to trigger writeback
> in advance to free up memory. For example, users may want to prepare for
> an upcoming memory-intensive workload by flushing cold memory to the
> backing storage when the system is relatively idle.

I can imagine the zswap writeout can come at the least possible
moment...

> To address these issues, this patch series introduces a per-cgroup
> interface that allows users to proactively write back cold compressed
> pages from zswap to the backing swap device.

=2E..but I see this series is not only per-cgroup proactive reclaim but
it's also age-based reclaim.

The per-cg consumption and limits (and regular memory reclaim) are all
measured in sizes. This age-based invocations don't seem commensurable
(e.g. how would users in practice determine what is the desired input to
here).

Could you explain more reasoning behind this design?

Thanks,
Michal

--o3jizhh4qfyisfpc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCagHAARsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AisVgEAue3WyVVGY7GBg1v3Zt8e
eeD5pIl0nLnXPUEjlLTIJNUA/2WZU04Y/56uL4zU3y+755L6om2vsL3DmWWaCGB9
0zoN
=7Raz
-----END PGP SIGNATURE-----

--o3jizhh4qfyisfpc--

