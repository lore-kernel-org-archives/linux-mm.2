Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6506D606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=Egmk40PK
Received: by kanga.kvack.org (Postfix)
	id 6CE9D6B0605; Fri, 13 Nov 2026 03:20:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6E86B0607; Fri, 13 Nov 2026 03:20:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5976D6B0608; Fri, 13 Nov 2026 03:20:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34D7C6B0605
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:20:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CE92A0157
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:20:05 +0000 (UTC)
X-FDA: 85429397970.07.1DD223F
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 866EB1C0004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:20:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Egmk40PK;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794558003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
	b=BQ6fW6BYwqe/Men6CGMXEn163kIkA13Pyy9ltla4AuI/wOTMWKR6HyyQdUfVLCHxgm3+Sa
	7vzCFMC/oftyDMXXGqIH3xytXDVMs6KNtEdrrUgICRYbrTeS2irOLAXu3NO9XRl49lOu9F
	QJ8N5exs6Rtn5OmqYFzO42SmpnRwkfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794558003;
	b=hWj374H58BVTPILpudZlF9a6qodTVnPebAU0DW/w8K9LJyX3rMnSEBKaJQq+8riw6fEWt+
	MOywOveJi5ukLjxUiyrtZsbdYaFax8dq0arks44iWtck0EafwGA6aLQh9X1P25rJr9xYr2
	pWKN3FsvKD3jZxxbVAGU91c+cdzk1hM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Egmk40PK;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso844034f8f.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794558002; x=1795162802; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
        b=Egmk40PKJz98bOx9Rf7msPLbEpGvWCtuoVB7K9jSbB/SlMg3ndXgTUroVMp01zZIp+
         YLb+sgfB2tB+hcGHJZX6XcO4Gtv59w4ydrvQiQh9qyT373pxPxFA9v/Aq8HqV0tpSjIL
         mb6GnGxUl5eaXH7qpyXuQNE41G9f88FfJsNFkUS93/KEwaY9Bq0vKUyLe96XM8Soan0W
         qdK2CD+3xSiQZMUguj7fPGNMZv9u8Fx906GmjApjQoxt5Mcg1H7RjnKRNtQ+YQf+0c9F
         s6q76Hre335j9fO8U7jyV+ZhMuGpJoxkUt9vS72+ian38u39LTMVqMxVKJRrCsWLSB0T
         T6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794558002; x=1795162802;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u6ODy5SnsRQugFSPY6vBQTFSWdeeo67enpuBFMw2vTA=;
        b=TNLNuiZKpLYjQWtRabZHiW+vD9qEoLHSFwk5m27kN3mO8vMDdVMadPVs8Xzs2PJOKM
         cnDIhER6WxlmBXNAgfp3yQKdrlekupTm4abF9DDVe0vM00+YKmscEU6+fwpHoGnJB6ns
         CvWHncPV/rMVyyE4VKdV6qW53n5V65ew7E72wRa0Dn5G4ByoksYkRTw20N4N5z0fHm/e
         C3N95djgLLJYNSnyD6Ix4FqY9p6gaOl+d4noVCjvVqa2/63/L1SkB124sJ10sicLrPhd
         5jFkuhrZbyTcNYVztVE8iUOWH2NggF8H7F4u4c6U7o0Oj8HuOAyCyJTGP88RyjCPqP6s
         IlXg==
X-Forwarded-Encrypted: i=1; AL+hErFrs0KFwIw9ld6/YWybPAzkLTlJPsE2LF/8GAUFg5QzR7sy6U0r48WqL13Zxyeis/hDf9urI+vVEw==@kvack.org
X-Gm-Message-State: APuU4Z/YglqtAtqWun0G9crN/1CyEnM+cRtR96vn2b+KAlIq93UbiUdw
	rrQB7Dw+B1DYc2rEXTxIstUsbu+M4n4sRgAF1dPtJx02aLovZou/6+LBZW/kl6uzZNY=
X-Gm-Gg: AYBFou06uzJBheH69moCZtf6om9QM7o1vij1qSA0hoji6nbVjQsP/DVr5zBb7VktfQC
	CvkMX1mWjkAvTOeiScRedG8D1G+9ajZJiIQQxKEPhYteyX6OCCSvV9264+AknmgbGBwkEu00vHN
	PVSIQGv3BXpR/xL47XcPC/H96135+LBM0fxdXclJFOCZO9S6zQuqQhMk2H27+a8C0I60bD8wQz3
	8R69vGMl0WDr6frUXE8hSX4k9IL4ZgDbwF0OuyrpFL+D03H4cSmYAoQ1bqZUBEEd3PGOHvnbjiE
	Eum4MOuH3vHwDER5uEuYBuBWnzp77UjL8N996q/ayZweqaYVOl3HCI88bD9xT1zYgYYzFDSX9oM
	hpp/LcYcww1PU1h0FW/sw0ix8Qxvg0ncVgrRe0TeJ7cLaPZNaXPjiDU82qB01vRL2zrWnwUwi13
	oGsA0Z1xoMnbCBnbGDX+OlNI6rFJOuj7wxaRcCghyp9mrI2UAO+ui1pNQZbn90Exy7mr4DCuDV8
	s5tL8bmzVLMD1xo+/pZqpeP7VX98S2UyrLlr3O1zshOLpyi0wKwn9vARo9qGNJHVSSKugA9djHe
	wek2IXTCZn+CjOFG8FkkKy2c703gaTEADrlk9fJ+dR0=
X-Received: by 2002:a5d:5d86:0:b0:48e:43a:1d84 with SMTP id ffacd0b85a97d-49c712ac267mr3929586f8f.23.1794558002001;
        Fri, 13 Nov 2026 00:20:02 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c602dsm3640220f8f.46.2026.11.13.00.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:20:00 -0800 (PST)
Date: Fri, 13 Nov 2026 09:19:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Zhan Xusheng <zhanxusheng1024@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp, tj@kernel.org, mkoutny@suse.com,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH] mm: memcontrol: don't miss processes whose leader has
 exited in OOM scans
Message-ID: <avbIL86R61Lu2YVF@tiehlicka>
References: <auhiGqKJeukk7t3P@tiehlicka>
 <20261102114029.1259655-1-zhanxusheng1024@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102114029.1259655-1-zhanxusheng1024@gmail.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 866EB1C0004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: uw7zgbdr3mcxkb5nncu64pfb57fu9kax
X-Rspam-User: 
X-HE-Tag: 1794558003-971222
X-HE-Meta: U2FsdGVkX19LeM9vpYhMrpfBUD/3ufgiTy2qvQzMyqtIX2sf1LNhzRAib9u/CrrHdwF6XBm35FFJZH5nEOJ9G7OIaaWVasYtoRZ4NcH17g+/kofWdszWKN3cajB4aEP5W45uspLl3X8NbD8KGXaWy0KUYbM2w4kbEv6Ogul8PScmM66ug7tvNe6O39gDQRIGVKb5buEs56z8hNLPJblh2SShkfKXMgAPOzm3VLD6Ru7EPdASu8tl9bRh925833aKjyM58cbX78zvVGwNVuazIrbx5mHsqB3H3JHz+tN+mq4qscR5tu2NsS6tFOGNsvPLKmmc6PiTjDWMbrTns8xauoUlyqqc/RSmyHLpLSDnYbWPDdN310GXgQi7mN6eppYJi3l3PiGJ7ZzpxmtAp57qgAXG9jm9GuoCFmvisEJEBqAs+H/NiR8Auj/rRaCy3ONR1AzAWygqzTpgTvL0+mnyA/loLK+wzsyl1ZnARNcamVlZLnfy3/CAVoUr5WRsafIYO50QzphKGKSqslPchmPOWLQGvP92vHZNEh0e/gGR7hCIi5du7oMXAsp5MGIB3WCgI814iv+ZyHx2kttjr9zjiIt0W0Yu1DmhVzo2TImoPLlJkR6uROMUKWjWUiEsM88wgcfGkiyWHOvwDY9KVwOyHihmqI27TNHt50bqO9TZnLglHhHhYRR2f0zzGQ+KjtKZUzDl4O9vOvL84QcqVUf3DJ8VIR+ZJdILCNiI6RrTzezamq60S7UumO/SQ3apHwhn05XxBkISMc8xBYqNHwO46VM5sLIUM4m7OX/QYqJYg0NIeT7OimpYCnMdj+sDzdK1OrZet4SZ1Rmp7IZUudZ3BDMGlmYm47mZuvw0gKFPu8M9MV5bBclPosI4HbDi1AA/m50pSfSip8y5zI0fzntX6srCOANvvINfKRI1FFKBU6JF2KlgaLelRm+69EJr1bBhk8uX/CJdEFGbR0lYBzS
 Sqw5Xq34
 7rka/Qs/R2VGBXz5gkmbR952RiDFJfowCB/JfcDonK2Mgr2cnSg4rwb8jCFkjNprF15ZJX5SOjg6dP71PJR7RSKTUh0ek5V+xkCwyMsp0yyylgZxoGrj16jWJ+O7QZwDxyZM2zHCoTBXDmTGg6FoovPsa3CfAzT37dTqa+laxg0kq7f5mbkFzlcQTV5+fYsJH3lRs4Ff43tkS6xpcSp/WE6xhQ8Uc5AU3/UjewJ6Doldw9CiuVwQJZgCbsoM3AGJjXwtg/LptnkrEpL3fxHe0sKWFSWfZp89stMmH8CDz39XsjDqWZXJgZQ2L3UB9At44Yv3P/EIGl1U16wCFDkBX0tlmwd2ni+8c2EeauB1lSHicwmpdI8N2ikZoI5yv+/Bnu6QZ/eDbl7SVas7AwZ1wOd0yzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 02-11-26 19:40:29, Zhan Xusheng wrote:
> Hi Michal,
> 
> This is v1. v2 [1] reworked the check, but your questions apply to
> both.
> 
> On Mon, Nov 02, 2026 at 11:12:42AM +0100, Michal Hocko wrote:
> > Is this a desirable/intended behavior? Shouldn't we move the dead leader
> > along with the rest?
> 
> Userspace sees it too. After writing the PID of such a process to
> dst/cgroup.procs:
> 
>   src: cgroup.procs = 85       cgroup.threads = (empty)
>   dst: cgroup.procs = (empty)  cgroup.threads = 86 87
> 
> Moving the leader would fix that, and memcg would then need no change,
> as the PROCS walk already returns a dying leader with live threads.
> The catch is that the leader has already gone through
> cgroup_task_dead() and is still accounted by controllers: pids, for
> one, uncharges it through task_css() when it is reaped, so the move
> would also have to transfer its pids charge. Tejun, would that be
> acceptable in the core?

Do we have any conclusion on this?

[...]

> [1] https://lore.kernel.org/all/20261027144016.2582880-1-zhanxusheng1024@gmail.com/
> 
> Thanks,
> Zhan Xusheng

-- 
Michal Hocko
SUSE Labs

