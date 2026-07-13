Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BDDC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA706B0096; Mon, 13 Jul 2026 07:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB706B0098; Mon, 13 Jul 2026 07:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A7A6B009B; Mon, 13 Jul 2026 07:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFCF86B0096
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:40:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45D19A0100
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:20 +0000 (UTC)
X-FDA: 84983560200.14.19F79E5
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4F4B320008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:40:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ej9ot11D;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942818;
	b=uSW/ZfDJ369uznavhNQYrwxAuLzPO3b8W/V4NchiD/Sn/QczBYGfco8uv/GuK8R2awxt+h
	BKQ4rdBpVqlpqZI7ifL9ziIUPq6qwsqvzSSW2K+QnNusAODN4eR9IpN8N+QhxWCA2K8l4A
	k3k0nwiIoA9YMqSDqQ9RAMQH20mghNc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ej9ot11D;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.221.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLOEompixDXd9MerUC7lz4YUSr7Q/4Il60gdac1Zioc=;
	b=raPlup+buRyaKHpQNb5PcwVnE5DLpfUU9LB1bK2gXbTi2V6E0k+kHahs63VPDlFx3HPfwI
	bBOacRPFptrawnMTH3s8j3Wwo86Mxxjg42LesnDi7voLty5Sux/Vvwr/Lwc4gbGlUSyNUv
	W0ANevUGo9R/kdYtdTElnEIJuYU7DwI=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-475417f010dso1396497f8f.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942817; x=1784547617; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BLOEompixDXd9MerUC7lz4YUSr7Q/4Il60gdac1Zioc=;
        b=ej9ot11DPGZRdjSk0z+Vdw+GpFMvmpvW7i6r7IWIao7/jUbXuuYQKI0P1iZulFj670
         ZH3RuHii4IexKZVTXrt/FFAYLTMe3v0K76z9haMvfrizG0vx4dnEyD0qvzgJQECQbIjn
         bbTn8yE0fIKD3BHjdeuvuemUSbGBzLJYvOLgDxhkbbBBPvn4SUpjMtauObNdjhk2fPD+
         DmXl1d3AWKw0DN9lFa48jgnTeyB57FY1lB02fne4yliNgbPG9xlocHjzRDTWEqQg0cYz
         wFfGNMbTmRmBsY8hBBUzsmRI9FOKGv7jH/3LfG2Mhl/EnXq9cdlSg0bnY8EO5dcArB5I
         EYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942817; x=1784547617;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLOEompixDXd9MerUC7lz4YUSr7Q/4Il60gdac1Zioc=;
        b=mGQZcDtHQTk8Fzd32+wR1+6wtHS8GQPkm7ofWNja5l180ytauBAz26Jrcs5Me/cWF6
         BqoSnrvNZq5kDks+1zdTM/wbYWkyibp7moi1JQW7W/YYyrLS7JpULh2EUld3aACZvlON
         0iMS9BIUlvIeS2ue38w8v0nza+CWvCboq9Jg0p4NL9ofLv8soue3DBmQNn7q/eo5aheT
         q3k6GU3WoakN2IOntty1iarPTuOlFtLtkEZ5NelB6ZL2CVO4zbx180LZkTjwqMR3Tc/C
         fPt4x7Y91XMh1Ez8pxpZ3n3w49sS3ukF/jNV7/PSBdFn1urgQDb7vG/b9mt7s91SRIvm
         d+Wg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0UwSV1l9WgTpMX5PM53d8eitAItFOXHarRkckYAYORAxd9q7sY0rrbeI4GhJhb+7SfO92ZbLsOg==@kvack.org
X-Gm-Message-State: AOJu0YyZuxVvL/046PtgGsDmOM//3+Fcpoorb9gtbAdpRKdzjyIPJ5z/
	+gAon8ixj3sMutcMpBDss3Doe7DvobnrdSyPahMwsPhcHCC1RG5vN/zfgRJ6NN883KY=
X-Gm-Gg: AfdE7cmjiHx0+GCHwhhqXP0K9/y+UsszF/cFlBlEDCNBxugDYVGUz+hRtMWhF64Z+ga
	WGT1Hy41o/2E7lTLctqvgO89UAtkhGL/k6tycz9PWqamb6QPJAti7rX6UyPVxGHdb7ZRaV8IMu+
	/vKxYHxIqHdL8MduwthQDtx/qTPltQyT3vI6kY9+hzzzhf4SzzIe1519LGrL4/veVhmy1/oVpZE
	r/nmCqOUQXIIyOhzIXcU9GfItvWGREk8bRo3FyWiuxtOGGgYQ35Cmu4xx4t3xlWh9wdC3/ZK/K+
	jjjv5tRUzA6LbY2jWDYlapSFsXHqw6/lWcA9NB9aDDWcN5zqgQJpji6kJjPOPoBW41hp0JrwyEG
	YsuaYC0/OurRj3IdcfwUWXCBXO1FBGqvGzJxZvBBd7/dmssmAAmPrC57ISGoQo7PlTUs4/XH0Fz
	CleNxIvhMM1w==
X-Received: by 2002:a05:6000:4b09:b0:475:f0f0:9ef9 with SMTP id ffacd0b85a97d-47f2dd0249dmr9451318f8f.48.1783942817057;
        Mon, 13 Jul 2026 04:40:17 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47df6a31dd5sm41971514f8f.16.2026.07.13.04.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:40:16 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:40:15 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
Message-ID: <20260713114015.GI276793@cmpxchg.org>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F4B320008
X-Stat-Signature: 7nm91rbuyt55ykpmcjdtiut4nxe9piah
X-HE-Tag: 1783942818-967250
X-HE-Meta: U2FsdGVkX18Ntz8sGz/k2Hx0p6IbZmOGE9fUEY31w7F9ZPAyrHVrEz/rVXORqmGIxuttGD1vrXsfzc9qmajIA1NAwthnJ7mkRqGG1r+2fw3nuXhcaezRQTUkQsPMXrV6mGNbYxrfGGtYbe8X1cpjlDV/Xag2e//o2VT8yrv6mWTyHgBqXo8WpuHbZIiKWQo4lygcwYD3W1vim4c+SBdp6K9/aKx7geusrNCe7ibu1ffxz4fhLj4iDcPd36V7BtxHJZv+gPBMKcGVQV0BY8V804lfeCl8iAJLsE2FLOfTJpKPWTme3J/TShsXqj1BHzAXKy/gQn6sdYYAVhQkYtGmiuuv5zoyAd5HCTaFg+e2EwtiK+LJAzjktMdWgtQCeXSUsriO591p1owELDA3rqPtLnb/SVYfeqbBHgQozZH+S+C/Oco6SX3mQ+oRoIV01vFNuWdS0iqBK4oeJ8b0/aVtOZLnSaQ9mJr5FL9sxajdCdbdlQVuoZ26dAjSwyi0VM7BEqjxWKzjtiMGDGkg7gcBgJtmqXunrrMJIAGQS3Fzmj4WW3d8pPMPuUjevUlUz1rpzytt/NgI3b4PZv9gI/t1Obo3+4DXxwhKQga4k9k9ZFfk9uE6Yt+W5HneA1e2uLSCoHi8zM1d7bdqek8jmQHB3ntB5oO2TNYXGL7dPsvHjVksUEGp2fCU5kbWlv6rokSeqzwWeAsKTE8bR8zGUzO4w490u8SDPE68LLQvVUc9f1Ny+W75bmwAXBY3kTorZ6xZgOjorOGGl3wdQE2dk1We8mDQDe6vlUUTrcHB0+6bN0QtJPdaz70LAaYU/m/eC8kO+KWo+ZgEFcVNmHxv05bvSuMhktPvUjw53NXeGDWDnTG3aePzey2jmd1bqCJPTFyS489FwNsO+c957TzCTzVHl2OAWr852v5z9GuDODGv+Kr9WDf6NNp89JXgiqPe/0sPWlD8zc/KSg20aL1ouns
 m3pNrLWX
 0rAcKE6v66qWOSHowosG7l3nNmX0zh011SWq6cac+YT9v3E7uF+hBI7zGVAOWhkjtftdRI2iA5LasgAwTMzTMjFbmT9dTJx0uPzj01Tb/3WJSdCopjhBR0GkcmITv+UwahdlEnIah1ppkBHhBoZtLu4IhE2QO4AcP8EP21FW3xH3jnVV4zIjFFhi1QZ1xTWxe27v5S1eHde5gagTz122blxJMlqukWIFFzdy+Imu2TRhj8giAcsc4myFxtGBwvjF7M2L6fypuUjHovD9I5SNELe4b1uTrtN6hBnnxkhNf1MEtA3fiWWcMgywYM/8jjgim6w/3Sc8K5r1Mw8pGroJshtwbJzalFsuZwev0KEq/+6nHjOCvTBcshQsR22/o8FdAOP0/84dQdf8Kirn9JM4p4+8Sq8UKKge8Bvvuea+DDZcOhfs6GlttdiaUYGmfQHrg8MzRdwVkNm4oYZmWaCpGDGB1eFF7QR5+Hj1XZPyKUauNtD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:57:56PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

