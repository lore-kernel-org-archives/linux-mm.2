Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93893D66BB2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE81E6B0005; Wed, 17 Dec 2025 16:28:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95726B0089; Wed, 17 Dec 2025 16:28:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77B16B008A; Wed, 17 Dec 2025 16:28:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7D556B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:28:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52376136DD7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:28:19 +0000 (UTC)
X-FDA: 84230251518.12.6D077AF
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3BB3214000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:28:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KxtdMx+Q;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766006897; a=rsa-sha256;
	cv=none;
	b=QjSUH21CncR3HLKF3Xh1gzJwo+eg9JENqN958xt/esUYJ++iF+qA2VwCCtzy/LVzsgrZce
	NAYK7T9s0fOyBbhuWtz8KfzNQniAgkHAHxb0tPsInaObQqoFCPS4yqUAOgPRmW/MHFB4Pb
	SaitIsJNmPrmL6IuXXsb2QiyHes31o4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KxtdMx+Q;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766006897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kd2WcobjQdnwsk8zN1EwNDl7xZ4zvUhbh6TmBYqAKCA=;
	b=4sIuCgFSzPp5JiwGRKvxesIeat+eIroZIJukIuUVn82N3q7in5Nf+gbZdVm2VzwipkQF3B
	va9KWGbpLdeNur2vva0ngl2vsLPjot3N3jgBMs/BTPXlQVmdZ/fgb+id6NY73Lw5kDmqoA
	KVXuWOnhNEi1ts8bKw1be39VKyKnRIE=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4f1b147eaa9so48942821cf.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766006896; x=1766611696; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kd2WcobjQdnwsk8zN1EwNDl7xZ4zvUhbh6TmBYqAKCA=;
        b=KxtdMx+QsmqCgbOWIIZbL56Z+iU8rA2lZFu0blVZHbYAGwhHGGI7BNFjQXzLzcXi1j
         rG8pGLhfyX8Irwre36BqMk+xRY6nn+F2AqexXgjkHHrY82gK/x0IcNRGwcq2cQNUsSEp
         FIc5F8Iv2tE1QUXXLhe3GZSNgbxyChiJYnBNokHy4YSyaEUMJYq+Sb9eoctM+ylv10RV
         BvxN3QgLY14f5EEs3rxbQxAN56n59ZUku8Rf8D0zV/0cMxNE2/JAoZ8cVaY3AK4s2X/n
         hPT0o1nJ8/yfV/lAIMX1CZiHxvokH3EKAaTi0hBSap8eP93Y2GbtEBnm33+vemJba7jN
         y3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006896; x=1766611696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kd2WcobjQdnwsk8zN1EwNDl7xZ4zvUhbh6TmBYqAKCA=;
        b=soDuRlOuMqdf0YUk1K2Q1royijiRYkn7F32qvHMuyBDz4GTHkH3LMtj2Tm794T3lRa
         yZlnW747jA01wj9Udnbkjuvr5SUzJGV1SOhEl4Z/vjdrdDcdQevgcknoPq5hsZBXg8dO
         Uy12Jz32km9ylr5pzmhwcnn/Xrfj+sztabiCgGOKpJ131ASN/6jJyAHBsM4C7JQsMwMJ
         H6IQb1mQH0eM7+P4tFKjKgmnlrRATwPzAnXfFomJXCEbfcGzgwZ7G+jvrvhVsabE8FcY
         KsNKQ1zNiwDv1WM+IffQt1SOJGNW9cp9zykxzABgxhsROrjkfOBerZpr8r1N2wgr0LOW
         rdVg==
X-Forwarded-Encrypted: i=1; AJvYcCVCdz5g0h9egj2tDPOFgqEyIPvMtJ8dPJ/3P0j1pFqAtJ56QShn4dBT6lO9b9GkRGY7kGh5jYSGUA==@kvack.org
X-Gm-Message-State: AOJu0YwrDGK+yqePe9lVa4BFqVgOx2S3FPGaoLhoFVNW+Jmi/ObqZ9sb
	KqH98dMb8QllLwI2YcTtgt17py/O8CPajrrynq6fu742wFSFjgOuB0zUgeJr+HrdV90=
X-Gm-Gg: AY/fxX5Dnl1P2aHfenkJeY1HX6zGGHlKZvJkEXeBT+vbf2AdfA3kmrgPyJd55rJG2nr
	mxDms8ykg/4gApmBrkZI85OjnV5PFE94HGuRh0rHe50nx9B2JKkEnuPHvV+yz3RxwGrNYB0MYGG
	i4Z3PI1T+LolT6n9kYxea4SaIEHQN2OMAFSlo7WJAYBCGgCHqMrEyf+4YkMekP7xrVFb+gxUx4R
	LGtTTvw3ztQC8NzPgZJhTERuVxug+fDsks8TFN6H0es+Ox4o3+vh7PfbEXSavM6ZSP1lQYfTitE
	IFjvaTwwqNARvIbQyjq3MC3HclopMq0mTQUflgJrcSaB/ujXqPmXmfNz2Pfr4SxbdHEKQQHN/tC
	J2Th4qr7JNjhqo/G61ObwLwcMYZ131cSzg/SRETLL2X5j63us4RXHtA0k9CBLBa4uzJbSNdlvQt
	O/kSX/OGEIfA==
X-Google-Smtp-Source: AGHT+IHK1mtmutqg6y/0hzjFEZWVKJiT38oIxOrMBicUN/5fclSvNdPVw1dIIFG4MX76NHiSFnTZwA==
X-Received: by 2002:ac8:664a:0:b0:4f1:e8d2:6335 with SMTP id d75a77b69052e-4f1e8d268ebmr148928131cf.77.1766006895940;
        Wed, 17 Dec 2025 13:28:15 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f360751619sm1247261cf.12.2025.12.17.13.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 13:28:15 -0800 (PST)
Date: Wed, 17 Dec 2025 16:28:14 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 07/28] mm: memcontrol: return root object cgroup for
 root memory cgroup
Message-ID: <aUMgbirV5dNpuBoM@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e454b151f3926dbd67d5df6dc2b129edd927101.1765956025.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BB3214000D
X-Stat-Signature: uxrxc51g1cg9fkgmfpn3jqakuc6158u1
X-Rspam-User: 
X-HE-Tag: 1766006897-909326
X-HE-Meta: U2FsdGVkX1+9equvPT4UBrVrSC1WxVRESRAaoJuERalnp7L6o+qUb4xqS+b/achQT2Ny5/1STi7+MWbIVXKVR7qaU5dgszjQ9rcI0ZxD8++lz8QhxAvNHmzi/ABLm9XMdbgCh0XLoR1U1zqXepjykl36V1jB1rQeJGMXEEBrO9FPQHdZD6YjX17rHYBMNAdbXo5npGVvQjxR9P2Kw0TKX2PV+aqmcgXz/sJVXHAfvWZnomrR4PTQM0gxgxnFV7wKKFP5ROU+SVpRgUJBYqSYb9Ob6HASFa4pYqeHDd8KlMviggmbQFdTJoTx4YNMlOim2zPxb4DgSyqXq90WmuCYbgmgNVusW4ss5sSXcjZ7RLhtZZpqzOrwxPauhvpRwAkQMGXpmpeTV7g76faATpVlfHi1sbfoaE1rhnz6tI/SIes/Un8/oVZ1pMCEEZV7piGmSqeu8djVbhCr44MnJqcSzg7qabDbsClhnp7/a89s4qvNTjuL1pL7hAAw26aKHBWlFnDbEa8i4DBDPm0NWvmfYDLDdpOQTQxj5WErSVdayd4xg1979mLwuOmP+cMft+U2jW38MXXR6M/ogYhrO0YdpT7/Fez17gWQHHZEZ5XyytroTHT/4WJ6NAuCw3w/yGrnH6EpCnflV3DNxT28RroxPFy+F89sob78dEMBGItf2UIU51jQuhyAV2gWkave5Cxs2s93ibsBH/BB00KDbmdRdt3b+3yMaCerD57piQWZ7cYMTiBZ2ZOKiE2RMkoIk+NnleZh0yN5DZ6WJoCkUn+pjONUu/6Mrk/FU9uUleqRqJtzvdwX2NBOvJGHkA0uluvYBE7weRVB2nFN2POaCJqGydf8vtHF2qxd6UDxEgX/2Y6/JLGkbbh0smVzpilpMS1DO83LggPFESn9rUUBk+FOTWcMWg54nqePX7AT0Ubnv2uFCKWSpo/eC1kpoAbcrlF/hyT/u8rf7oEJD9uvT7c
 VuUZIPgL
 RIZYlBsIOptSLQXTqRLFQByRocfGFxu8bUydZrMqToQmZMjwt87Vf68R2CIZ7Pboet1IBlURiXfGGC2T6zuM6Jdz5axcZFNxdLgLzUUtfXlltE4PA151neRfjYM6MINaTl6q/FEcIWa93ARh4+pJp4jR8s7ky2V44GqSodqzOepZVWzTaIm7AqHD3Wtwlm1ziZlcebsAbjxfskP+Hx6RMK6Mjbmn0wyzmRJRQa8HfiH8wClJUo2lHKUyAZzlrTK6ItzNDJgAUt/t5QobPthT9GDOpnCqT8eRdF8jGnO09syFpznOXri7tHVOgekZsomTlCyx998E6sZLQKRIiKoPXAMPSGZ8MxHyeZZEweABCejdLzE8cW/YZCM+W/BEcyKbpL7eEeecyA9jy0I/Jh/FmnD4upadcYtJxmLqXzRjAVVnFDDk090HdJumFN/NljXHVuf/FfEGJqLJzv4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:31PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Memory cgroup functions such as get_mem_cgroup_from_folio() and
> get_mem_cgroup_from_mm() return a valid memory cgroup pointer,
> even for the root memory cgroup. In contrast, the situation for
> object cgroups has been different.
> 
> Previously, the root object cgroup couldn't be returned because
> it didn't exist. Now that a valid root object cgroup exists, for
> the sake of consistency, it's necessary to align the behavior of
> object-cgroup-related operations with that of memory cgroup APIs.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

