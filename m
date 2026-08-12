Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A67F3C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 16:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20DCF6B02C9; Wed, 12 Aug 2026 12:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEFE6B02CB; Wed, 12 Aug 2026 12:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D55B6B02CD; Wed, 12 Aug 2026 12:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8B0B6B02C9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:42:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A1AD160415
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:42:49 +0000 (UTC)
X-FDA: 85093186458.20.EBB245C
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17175140006
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:42:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YNqu+J8i;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786552967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x/EWoL2S0wFVxxUH9CDFZoGkIehfFWNIp7hAQk9bjwQ=;
	b=7/b+iJLS2FetjaETzbblHZd99ItCxCohTi8D2iVavtRPxyH9QvvqB/dULVcGT5JX+ihtaO
	rZWqmQ1Lv81HkwRVZ2Uw6gDXTwizjf/QyN7s3y734m4gFVleo+xr9TpFtOtV6ochiawYMv
	+yFoqOlf9hf5uZUoXLcTA9kbpwIa4LI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YNqu+J8i;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786552967;
	b=7YIihRuGBygeWWmLgZ/LTDWtYOgoY6Q2yab1FFaEKGxpQqlp1fwrXKBcMqQbAD374A48vg
	JdXYOeEzecby0j8D9v2s1qq1Z/DuSKKIvqV1S44fqo4tNlAItsKnXdDanf+PGXPKj+86i+
	xqLmfdv777IKcJbYdqSxAmhqqYh6uWo=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e6c4a867cso80492485a.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786552966; x=1787157766; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x/EWoL2S0wFVxxUH9CDFZoGkIehfFWNIp7hAQk9bjwQ=;
        b=YNqu+J8irBt7vE0FCxCBzbjk6NwFWu6kKeEekc8Zhtbl8cIiUzESrUZDnVmZkWpH7G
         z4smf4XwqQz0ATHsd3QKbWbEX7ojB26yDdV1QgI/iUGu63FMJ5cJmigDMqMb7CTN09Mk
         pWUtUnnis+kVgjpe4YH7zqPXs07dL+EVfqiNYc9pwsblYBFK6lKSjUPdMOohJhgL9d4C
         1NOEmDTjHrpBWuQZkDC5srlVeMpXjOxWy9I0I4NSD3aLBfHYT24hCr+1GX17mDBnSiiD
         LrfyKfGqOtbFw88/xJJ+V55wUHei1fsYl3ATtywyPq122cs3R/y/dYXGZoeq7of5GVTx
         urnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786552966; x=1787157766;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x/EWoL2S0wFVxxUH9CDFZoGkIehfFWNIp7hAQk9bjwQ=;
        b=CDagUgtx7NnkDuDOBVVpQFNmZEdOUhlY9seF+en0q2fP4uxpDXUfJA6P7YGXwLkKo+
         C3mfUFonidn96nTwC2HI1L84/qNqC3mskM+w0OlUChtcdKVPpKNcoWHYUSU2thNul+gL
         l+m3uPRkb9wCQZDYug31SVBTKwy8hC87Ko2Ar5jEZv2nIuJ3/TAWjvMA2nUWf/9Aq7Bz
         zFnnA8lg7huqCo8kqtytICdHvedW64J5GFGEGrx7GmyBq3pIWGwobtC+XkGAkPl+HmSW
         3mJE1up0YXvmhE3nZpfXTa5IGNRlSTaM+omAnlt7qVfEU1hfDAY1pYogAd+9tf6Upzek
         ijfA==
X-Forwarded-Encrypted: i=1; AHgh+RqDZI0siK5aGiOg+kDIp6I1lsdzJ+zQN6V2t7quH0bCdHDp2zTu7T8YLTlTljCjHyN/H9eipzXq7Q==@kvack.org
X-Gm-Message-State: AOJu0YxVkr8LMF3WpWvj8QOkJv9IKGqSnjg/s2f95GfSi2us9J4CAGH3
	6LF+CDOm386DtkT+0WTW0MpvTu50lr7JnW9+dBA94slEie6Px4LjXi79JACy12UoIp8=
X-Gm-Gg: AR+sD10vbFqZA/xdqu6nhz2xW8qQe6RmH5Z1gb46jqTjBnqW5eU5cqZrA1YAp6O53OK
	0yCcQhUl4dr6bGOydkrPKOL7mkBg/aqGTpihcwEX+/TfGaNDKCDNhWNmULRdv8/rPO9ftSK57NT
	qr5DgbLYwY2YrsbDPX+RRE4/fEomG12DJOkQ7gcvMjaZ6lS9RAnpVLrMcc5Ije0XEsSF043cSk6
	WIp2iTYzpUCuX+sokpN2QN7/5ujjR/TB/c13Zw7+64inY8SJeE5/goAAfK5TypWLvE78SoicheR
	lOWJ1DOhkwXL28g4jTO++EUmV4UPqkODF8hcLabdNTuw+wd3EZfi+vUyqRaJ/swVMYtl807podX
	3MTtRsefsgloGM0xB4FPdQn/peXImSI/Xm3WFt4BgLD3E13TcJj4MXtv8v378nXNR05EL+4gKqi
	k0yhRCDNqqB0E/3e95Qkdl7h9926KKHaF3qZKpjAi5e4QQQHN5pBhwIjgGV1E=
X-Received: by 2002:a05:620a:1b8c:b0:915:f96b:8f5a with SMTP id af79cd13be357-936b3d9dee5mr568196385a.36.1786552965979;
        Wed, 12 Aug 2026 09:42:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936b5dd3f5fsm167905385a.8.2026.08.12.09.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 09:42:45 -0700 (PDT)
Date: Wed, 12 Aug 2026 12:42:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cui.tao@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Message-ID: <anyifeWkUecN6Z0a@cmpxchg.org>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-2-ridong.chen@linux.dev>
X-Rspamd-Queue-Id: 17175140006
X-Stat-Signature: gdc16kgag76nbxf5rfgjgxm5c3aiqmhf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786552966-741212
X-HE-Meta: U2FsdGVkX1+khR/n4GvUObJGi3A1NMSjqWSnmcUZqdO2SKuF6nUfE0lRCdFQJ2rsYmc6iSduUqvHhmgzg4S9hmHBnIBAIeDRf8+FEafHqU4U0WSVpFW71wMi7xB0dGRBIyIaMhhx7870u/KddaVRZY8ASdBooWUx/7svjY3UYrbrzmXE44d4X6g1LOkPtjM0svFrC5uJiwTsdOmG36B36vDqjp0xI6jmjdPgCIFHJGc4cwVlSJhkpFQK2dGeW3UbMbm/K1H1OetAu3OERATaRd9WmSUMrPOv2pGvUZRByistdmWcXm+o4pmoT8rTcPpNw/y6jhxHO1oc4FH4Wa7Ors6qIQMNC8B7AnUKAv1Jm+h8cYa04KziV5DCa5/+DvPu9SXBYn1juux6DWyL4Z42Y/v4Fe/CwFWuLWqn3Vnmtm3qT2gChvMoFI0tSPTA6skXeemWzICq1qgzRyI7WCAoNLa4yHi+BQZKNEsrQTR70Fm6HQ6FLDzBOSqDNIXXzq/gnMvxt3UMdnotoxEX96EuiXAxTqs0ip7fxJKy9YXCdupEHh5o1GOsoe85hnVb2zaAyDmNO6f1surx7LHUHV0ptgWp7F8DwVnMKeutmwpqfzuaIPkx1gj317+60ChOURAvNmu2FHKNquTM9XSwfUoXzBfuMtwCSX48EyCEnfmKXTppmw0flx0z4cnyFDFtucYK1NjxzkdbC2ZruXtaKCMGHHOeQRJZ8OwoTuVYVzcqlBCl3y6JBLTJ6z5CrNWHQK9Povu5WC80tO1DApf4ZIQP0pjox1+3FpkNFClXN63P/S3/cqkCC3l41OLvo87Ag85SUAFZT/uXaJhqN6zy/x+sKQ/QjUUQ+oSVgJdbF3eTj6dPz5ihkpmPK7N+ONBDywJVkA1BMe0FqVkOlGOId8e4uuyO8fZBYbuq3StRcYAhdrOXLK6IT+xikARdhV1+kuLlBf/vxizZ8ldRYN32Ygp
 TA9Khk/1
 k1O9TKt713D8dDKku4H/YjHKdemCWoSWQWp2XXlvo2TETJzBX4nMiMYhaITscOdK3EkrkosFEcyc9UQtmAdOWTH4mLVvesnijBU7FbX9z7MNocPG0Prj2vq2z8zK2+DkPh2NG4lHO9zn7sIOp0yqHu7aqWd6niH/Tfb5PpH69hvhu2O7MXlRnd0gOBYA6kzIVVin4e1O4UeRhasnYYBEDcF4SseysGB3ULr9kyRcK5BlFgV/0rc9lkMFckJHSnzWqgUmikVOsn+xYvH0s9fFEO81aiK9q/Y1phVuRFCSMB2KnZDV8mSn4gPE7FIEuIESKx+bx7w8//HMGxfTImWvrj8eM1LoL9q28PPA99ES548hfCeZgz+RbYZjTJbzUL+ENfQ5cvWR2sPOs/EjpD/wLwThHghaex3i05opb5hyDJVRDtu/bM0LCy0HZu4lzbbeI4jLS6PAPubGvAyn/8PGKqwzVPHzNw1u7t1WDeiwuEkuD8Mj9yrWffMXCIfoCoc+PZv014eGxlkLdgZBpQDNJ6gHKEP88aQ+uvf66lZ0v8/HFbYSsPpCHjTds1dckfcpdo3AWUymamCEoGog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:59:59PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
> 
>   writer (reset on fd A)                 reader (fd B)
>   ----------------------                 -------------
>   usage = page_counter_read(pc)
>   WRITE_ONCE(local_watermark, usage)
>   // watermark lowered to usage
>                                          lw  = READ_ONCE(local_watermark)
>                                          // sees the lowered usage
>                                          val = READ_ONCE(ofp->value)
>                                          // B's value not updated yet
>                                          return max(lw, val)
>                                          // both low -> low peak
>   WRITE_ONCE(peer_ctx->value, usage)
>   // B updated, but too late
> 
> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
> a consistent snapshot of local_watermark and the per-fd values. The same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

