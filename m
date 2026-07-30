Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE2FC55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07C36B008C; Thu, 30 Jul 2026 13:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91716B0092; Thu, 30 Jul 2026 13:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58FF6B0093; Thu, 30 Jul 2026 13:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BB1B6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:30:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1332B14022B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:30:35 +0000 (UTC)
X-FDA: 85046132430.26.0B67467
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 369654000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:30:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=E6PAYe0+;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785432633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1gNcDYuy2kFPtuMWDBBdwYzU3pwqwyp43h1K8eiHJI=;
	b=O0lTCZD1ZlMuqK5ZIutO9dSDM3vuaX/V7NPMiLDpfW3mxT/135o02jzDWa12RPvwAkEeod
	efFmQM0TsK+TZoOjDpYf+RY38VdrPhWZAj+vi+REt8BiiztNyEPrnkhg/jNfQWo6sVRyao
	8T1gnV/5EJzGW/skIA+xST1rSG2c1Xo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785432633;
	b=Tq9GEl7RMyFDoUDGljawKJrN9CYcM72zaVfya63+Ns8Lq+rE/w9Qxm5dHUC10dmf4nJaPD
	lrgiZKyrmv+C9BKFQUAOPMswckIWuaUDmkY3vXim2HDEahjAMIxbxIBspLmBIjJ48a6ptg
	Se6aTXJPlb9kCf5vu7h8QytCWcyHZq0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=E6PAYe0+;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e5d50b0dbso8221385a.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785432632; x=1786037432; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O1gNcDYuy2kFPtuMWDBBdwYzU3pwqwyp43h1K8eiHJI=;
        b=E6PAYe0+x3mvjEF2BplG0dHkN7svdzav9Br9sgLKHxkll38QNyuZt0dCHVCqSbU2bn
         i75wnQv5nRLZuBhTOZLf2yoS75JVtVoMC2fCyz5WVd2Kf1VCDUxXE6pQfg/ho//ZZaKP
         93YVFlNeorZatTQTu2PKw2pISy5y33PD/jw1F9cELjaLdW+YMLEIkGazx2/Y/2BscSIX
         OW8blV6AmNjH8cakvArJXae3x1lNQ8g0MlBm9aq52ZvN5dwhDicKXjg5LyraHdbOIQoM
         pZbjX3vdDh+2EMZVptub1yZL1UFLWnG0WGbdcF92rO//xivDSOS6v7P//kTmLxZDwce3
         vCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785432632; x=1786037432;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O1gNcDYuy2kFPtuMWDBBdwYzU3pwqwyp43h1K8eiHJI=;
        b=Dr0Qx84J++UbvVH6ApOXen0fZar8MDkl2p1qs1bIolRjosW1MvXTtjepq3ZwraKw2s
         fTFudl7OcXzmO6r/xE1vDJJexkUcIry062wcEaJemQLscRA6IHGMSI+S5rtTXemgrA3U
         jFTlYL3/UHMoN6tCFRxOCdvQDPk4tbiNzuEaJCrhMoedPyMYflQF+YFivSwKXaqI8exq
         rjuZZbb+dC5UPoMtHvKGhVE0KQyLil+0IYDvQ5FJqhO9OQM6bY4sPejvgIYvJHVSoXo/
         LvoH6DscmpYMcposhgXyrinoPMr2+iItpIr/fqZTk4YgmyEwZAqgKbVlPUOfAF0e4RYa
         /tMg==
X-Forwarded-Encrypted: i=1; AHgh+Rp/vToxuGjS4c89BsBro1fyOcmzB1KufKbPCba12Zkv5hyO7qALnz4ZPilLUQmNpR4Blyf+x6rwHA==@kvack.org
X-Gm-Message-State: AOJu0YxDHW1esH6kCyufN0qt7qrQXvea531bo85lKqyzfzdEzVjwjrkL
	mPIt43DEJMr2pci9gq9+WB+3eeoBKqEiT6Q58eu7UpXEPl6kJ24NaEXcqSDxGvymrYA=
X-Gm-Gg: AR+sD11pS7J0pOG6P3NK5oAuOfbHGN8WU44JBbao9x6Bh0POVGsQZEpGbiCeBHKnQyJ
	ya1Dix8ISI9GYtOp/VYQfF77ZL3K6AGnTlM8V1Rh4gqbpwI0F9HBVuWtzwh3g0ufk34uDYsTzlS
	MY7YTjVTpdyvNozNyUx8GU15ty0hCgpCLCc8yBttilFXItJA7xqR6ulOBXpaqToYNNLm/AcEy8N
	Bl8PDWwjOUvXjlmLBPRGXLHD5uj9aictFhzTwE7sMpFq3P91iTUtFaTih9gvKWyxSZoPizRv0sm
	1xybgceS8I/3a29h8BITa7jrNsy+9MpFfSsx8KatCPY6U+w7WlqyUTuhOHhh2nNlgOPmVkEDw22
	JsgDOeXLtcLthA83EvpUQtEKt1iUU2wl2FPrnzSdXJhkWhs18F1aMsZ+wHHXqTzQCj9iy0q6fzw
	yPcKdrZvwSjOZxpgkXEBBP+5QDmDoIEpLyWrOKA4CyHA3eSuwRMXrnuxipsTF4q+bafcGj94Fyx
	cYfObMvPFKWnnNktmKP28VvC46WYs14KiNrevWHp00J
X-Received: by 2002:a05:620a:27c5:b0:92e:56f7:c5fb with SMTP id af79cd13be357-93485f9c0a0mr372532985a.12.1785432632074;
        Thu, 30 Jul 2026 10:30:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d325a17fsm457745885a.13.2026.07.30.10.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 10:30:31 -0700 (PDT)
Date: Thu, 30 Jul 2026 13:30:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
	Raghavendra K T <rkodsara@amd.com>, "Rao, Bharata Bhasker" <bharata@amd.com>, 
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, 
	Xuezheng Chu <xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, 
	dimitrios@palyvos.net, Ryan Roberts <ryan.roberts@arm.com>, 
	Huan Nguyen <nhuhuan@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Alirad Malek <alirad.malek@zptcorp.com>
Subject: Re: [PATCH RFC v2 0/3] Demote to lower tier using non-temporal stores
Message-ID: <amuJbBrTW9W6_sx8@gourry-fedora-PF4VCD3F>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
X-Stat-Signature: b3xnfih54rc17ry5g966rya4dzuof833
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 369654000D
X-HE-Tag: 1785432633-174513
X-HE-Meta: U2FsdGVkX19xpAPSRpbtO3PCRPuE22YYMpf1wpMFIeBlpCwkV3XtfpsnB1cYgdCBxIcAQIYj34IQgYqBHfLuZrISGF0mOfCtUUzorjus0nutTf4Beka9zURt0/g0AunJ0m04DdjbNJ8UYbYyp4/i3xhNexOFmvc+Hsan0bcqt5B+aLvOC8e4TFaoQDfLcY0qJ9hZ8RbSj9SfnvLxfNtHoS7ICeJl1X9enSAVxS7awDQf/x6UZKwGoAsxGiWgKNPVgKEek3KF3D4lp+KK+zdCxm3nu8LBbJeMfIcmEcarw2Y3LYLdXkClrdd0K0pKMrgO6BC2iD+5pYjRCbzSYIqWk+1dUEHQxTUiFhvr+wRCGWkjSrScCDCdMSvuZL+JY/1tIml3J1AQorHr++T/LSyl6pKMB7yrM2X7vsLEhqAszQfM2c34ME0L2d+AqfYgMT67tgMiAOfuvMoTcYOLsBNfIJ2w5g5NDbk7XHGyTaiecHHCn+/BEbH3/Ts/7Mi+ivuL6cz2GdYLDrsuhQri3f2ljvGiHJMON64M55jW92UVoKTd909pSYdbgcgSTEFBXhmKoTGJhBy2BBLnwQFYCT3zLKlAGUW8i+eA7RV5/MKo7vg8y+pt7EObSDJjaETQOZiR6iI1rZo7UvQJusTIiEz6MYuIKhp0Odzu5B7c8dEU+GW+HMXqzqqOHbBoX8YdCi1+4rG6kc51/UIdL7NlZQqkfWVh0yTCTTFi6mMfzpKkJVTyJBumddLjxhPaIiJm/bogxwBswwhEZTIqNSLhximZYAv4c+bTlJ7Edl4DBUJg4li1Wux0/EYUvTgQ91z2SBPJW5p26t4A7j76fXsrS0M8MZEszMFd64g58HgGDgSN0Itq/qXM5irHf5TkMb5P+7qiXDnM28AxKNwF4d9dsT+5T9yVBO9sbzdjPa8xs4YLn05NStqyJTQf644cQJ+hJG+s+qBjMCoBZgKBKqDOx4K
 6I6ZvtmN
 woEH8vq0N9mdU6zh6JSvpt6Ko54xkFp3zX8vJ5Xxc2yCv8fw1rGUadWLQzuEpFCw/QBwOLE4KRUvevyvOcs6kzuVpvSOLubWDhPAfLM04AotB3XsIaNK3Ifr5ZJz1QBQ2XMOWFBcgh0NYp0J5Y/NI48N+u+aFg4mtRxVZMGCq0cAmOjALjcsOFi+Eyn6rh7GZA0dy9ezCpx0TND/t0MuSY9PqDQrt/1yMx25bej3udPKdBa5e1dtgGv/h++q6sBZd7kU5rl8Sq/h3s2rq3lN11IWlx/Oq/8VE9AZgJnJ0980taAuMP/6Rqiad8dTLcz7dnmmDCtSZp4Qa+t6KrSRZz83rj2roq5HwNOH0OaFQviSoSmGHm4uLiRIoUn7tjX0Z58FTRv/8dWakmmzXd5QUPnXSQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 05:02:56PM +0200, Yiannis Nikolakopoulos wrote:
> In most memory tiering scenarios, the memory to be demoted is expected
> to be cold and most likely out of the node's last-level cache (as well
> as target pages in the target node). Using non-temporal stores instead
> of a standard memcpy path can reduce the cache pollution in the local
> node and the bandwidth overhead to the target node. Furthermore, for
> certain types of CXL devices that support in-line memory compression,
> the last-level cache eviction patterns can negatively affect the
> bandwidth of the device. Non-temporal stores can mitigate this.
> 
> This patch-set introduces a new migrate_mode flag for using non-temporal
> stores that is used only in the demotion path. Patch 1 adds some helpers in
> x86 and mm to bring non-temporal stores support to a respective folio_copy
> function. Patch 2 adds the new flag and necessary changes for compatibility
> with the existing behavior. Patch 3 uses the new flag for demotions.
> 
> Experimental data: in a CXL system with 1 memory expander, a microbenchmark
> that allocates N=64 GB memory in the local node and then triggers demotion
> using memory.reclaim, shows a practically complete elimination of read
> traffic on the device, i.e. write traffic is N GB with and without the
> patch, while read traffic drops from N to almost 0 with the patch.
> 
> Opens:
> 1. There is some "duplication" in the x86 tree and a bit in mm. Can we do
>    something better there? As it is now in copy_mc_to_kernel_nt we
> duplicate the machine check functionality, which if available will override
> the non-temporal. We were not sure how to prioritize these two and what's
> the best approach here. Can we completely skip the machine checked for this
> path? Huan Nguyen has some ideas here that we will align for the next
> version.
> 2. I am not sure how this should be structured so that it is easily
> adopted in other architecture trees (e.g. aarch64). We rely on
> memcpy_flushcache for x86_64 but this does not use non temporal stores
> in ARM. ARM support is currently out of our scope but any input is
> appreciated.
> 

I'm still a bit confused why using NT Stores needs to be an explicit
option - rather than the default behavior if NT Store is available.

Lets assume we did this for all ASYNC requests, is there a negative
effect? A positive effect? Why the new ASYNC type? Is there a
correctness issue?

~Gregory

