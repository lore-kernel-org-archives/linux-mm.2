Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB2D606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+CvZPBh
Received: by kanga.kvack.org (Postfix)
	id 5A4146B05B2; Mon, 23 Nov 2026 06:40:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CA76B05B3; Mon, 23 Nov 2026 06:40:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492256B05B4; Mon, 23 Nov 2026 06:40:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0C76B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:40:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 878861C42A2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:40:01 +0000 (UTC)
X-FDA: 85466189802.27.9B23CDB
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id A8532180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:39:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f+CvZPBh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795433999;
	b=G/IcQGuFYJAR7OY08/sAAb9ewYrrYPnVLNBQdZemCDLDtYbLMGBn7oTsezyyzajQYExmeV
	+EKH1tVoNDtABBVDat1Afv1PEo2rCFyrPpmrLHI3Er0FGd/WWcBJjd+6sBX9VW2N7SFpbn
	dRFZaa4OSDTqEVcnp8A6SP/Dd8taiT0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795433999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
	b=bu7SmlFC+vudZQdK49ZsahUs0MiQ6owdvH/FsQAc0g73ib/2PSe/ZsjCGGdFfpv+BjmT7k
	uHMNkK4bIkn11MiyBUkt+6YgXuJurfY08VNG58/jWDZ2vd0CiwMmSOwGgFr3Mc+7Gx3Cnx
	RM+wvOJ/PItCUNS/rqsp2aIxOr5YNIY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=f+CvZPBh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2f03eeda984so16104865ad.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795433998; x=1796038798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
        b=f+CvZPBhXBc8ZQO8YGJWVdlkSBGZGGlcDxhUVImdJTiswo+UgBfmk9bl7/CNRecppq
         fs6mik+YWc8d8tkquUMnmgWevoJOrO5fzs4wa63BsetcB7fDjHgXbs3YaVsAV6h7+8S6
         AQ3vsTxfPxMhGYcYBL9OjBg8aUrdUfLMyMPu4jJwy0BEuLWWaVcOPPAUW9DJsgUb5lVk
         1Pw/wSnsKueHzSfxVcn8V0xYkvR7n9BpP1/g7xnIXuK0bMLA1o8NkdjtgnJubGLjEXNo
         jCMAKcmgMZEkN/iZpqANzelNfLcB1I+LJOBMgfDS44VsNsBcjqctlaSoJuyYbdCQVuwT
         Tytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795433998; x=1796038798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dzG3GXZhvfXV1CjH4z9JC/RUQc8XXCYXZlNff5428CY=;
        b=upgv8+HvUPUiG3IPhSdrDY1vCtTt4ZV/Oomy55E1sGVrUrqSRR+9KyO/yaoo/iT0fY
         jfQAsVbvoVFiazwRJXCIHjFS4Y3nFXxugJKm1gn6rGmBLbdF0/W4rZmE2xVStTKquYR6
         H3eOIVLOZZcmeKzP7BDDfXYb+D2aRLI7SNc+gNECrBC3bdmtwGjnvurQnURjRtVCbpAq
         bUv3g+MPIkv9HRnKIZLfJa8sNgW+jiL9KDKCPYY/5mHIMsznYwxvjvc6zAUPUyNCFf3k
         66fGxuRFQ8eGzBQr5nRJjqes7d1Mm+Nuuk5vMJO8YR60yqhb7nFElM+MSDEfO0QdPEQ1
         1jYQ==
X-Forwarded-Encrypted: i=1; AL+hErF/oACwYuK1ddG7yAASDn2Boypn61yj52g/YxeU5AGaEsoicOqDSEQ0xDHLyK++UPADdHHu23c2kA==@kvack.org
X-Gm-Message-State: APuU4Z9ssS5GyCFirkLtOIJ89+Y3PhRDGksaBl2L8pgQ4jv4KFH5Hbp5
	wSPrr4T5ZO4SGViBZdpwFojfGfUaaMkTXGtnw/UbVarnFQjP16TSj2/t
X-Gm-Gg: AZFdTZf6B2QdDupKQ1BQBx1TbDoaZ5g2ZDCIF3yDKT0wE+aTxagLr1Z0Z0tPR2djJtj
	ghsegquZSmm+EZxoIVzX72iT8pYPzyo+YuywYolxJZi637fSMj9nlcKUbowZR9upFXbmVW9Aha0
	LZypvtZx8p7OHwcEXWkPPPq+6mwUfLIr/sJQrS/a8HzoUStR1eKflY0YejSTtdlYhDXv4YLmqiu
	V/JfKmwaO5oaLN6pGTgJPf6o4DF6yRDHRwi/rybwuNsm8wrgVKGRkIeWpu0KcLmcGUMavReNzJ+
	WiPeSVqLNbhUbCyrIBEl8nBq+Zq43Ox5u1lWLj7951ZyQaclA+QXlgUnWHC2fUcbNb4kBSQ41GK
	BimDTEPfuPVa+XlxFe0eTaGmwseCsmH7QCRZPsuH76gZ+DSUu33U0O2LJB+LIoF+04t75bu3Auq
	sL187G243DET9EFGRbTG85/9QiaRW5osSh1OdbEyBUZZhV6nddSBghq4PSzQpk0D50iqSyv62l7
	DEGpGlh9PaCyTs2pr7GywT6svVIxo9GK947u2fjEcUMLifkfn6ImFW8worKSWxej1oCaInNCpXS
	nPEAqaO2QqjtYdyyY03XVygQO/1Cc6voyckmQuPGK/z4jw==
X-Received: by 2002:a17:902:ebd2:b0:2e9:970c:2c9 with SMTP id d9443c01a7336-2f03f1c75bdmr133283195ad.42.1795433998310;
        Mon, 23 Nov 2026 03:39:58 -0800 (PST)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f42sm51601475ad.25.2026.11.23.03.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 03:39:57 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: tj@kernel.org,
	mhocko@suse.com
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	penguin-kernel@i-love.sakura.ne.jp,
	mkoutny@suse.com,
	chris@chrisdown.name,
	cui.tao@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH v3] mm: memcontrol: don't miss processes whose leader has exited in OOM scans
Date: Mon, 23 Nov 2026 19:39:51 +0800
Message-ID: <20261123113951.1771223-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
References: <305c5803b904a57c188b505d6ed9e1e4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1geoycuapuky6sjwtfgzykcz5ep9xhte
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8532180006
X-HE-Tag: 1795433999-232674
X-HE-Meta: U2FsdGVkX1/eJK2PcIt7LNQ9HHPsnSm7PYk5yNSH2gbR1KzL5wiC5gjArWB90wdfRPhkQuPGS+Vbbdy/Z9JExwyGzG9uf08kJ6a7MgfglykE9Pmab1Qg1QHPcij3p6LkqoOippAdVrMloRl1W3KW/q3fBnNXXOtbMIjwUnUgtL+a9kJJx18RHcQBzMXqRmHb1sxOzQLvTHi+TWqCH/7HyAKDZ4iAYiIshyQ/ugkoKAQcyKwiilWaytUANv27oZ9lFrRTtOryJNNrsiY9wb4CyabslRPLiY5dro8CvQZWkfFT7I4M7vTmaITWf8r9fdCIuXQGP0pQJJYTVBHDajPrjglKrhGa1LZjMP/6aQFaKMAObdP+R7Lmx2XzMZl9ylV+6c60cPZUAwarcnhuhfYe9gf61DDe+QPbTN1UIY+/u2v/pVruaAp0NP9kA+knFz2hFYM8CHrrRZIRuSQdDc4v7v5UYmulNZzzlddMcITC0QPr4qfF37TmLQNc/VZqmtKOjv02JwQSokseJsliwFFMDpSdlRjBJnUUuq4YjD4rNeB+TiUPtlAIEjlAa4JYy8Xr0hnoMyNRR2SNstuECjvJQavtCG0SXTJOBpE9Z5RClD3j0DNGALwe3A4l6GpFHT/Nlpp9hYBggwVTBliZBrMO4TOzs3bNsXq51ytIx1qKdTOxxEHvgqURZZve2dDQf697gpwn+1/VDDpM+ijystF2GDxHCLbh78lAeMdCPOIuEQTwI0dlClRnzh0CCk0naC5NjMTFSGQkOJFoEC/KK+gvLRfc7JzwAldC+X7lUK+Ga0qq28jN6B5pYLE5hKEoH2gy1Nj7GyI38+rgm1k38mwDFluvcNNg8ixD3zY/6fLBNc+5yablo0Jhor5PAlw1bhxRQW6vDxUcRQ6KGxRcZeiGj0UWyZj9AaMluGeJM1YvMPnXHF4qhh3EmngHacrzah12aUZ0TbYJvEVdMn2vnbm
 jkyyn5IB
 1Jm3DCTiJ2T7GpBKylZ0VarjW/5Ag53oy2lfMimuyS89t0P9mT2DP86CJN11l9z9sLHnL14wJ7obFjjHY35SOB+DAFG6Vzc+q6yX5oN9Of661mZxecR43C1Y+5O5EsVXr7jRhebzgUSH446mj7TytTTJwXAuRHvMI2kv8XIvYOl/iTi8WnVHzcp784G0+iAYarssMr3x0I14TMkBBwX4chFE4LkDa30ufSVdHF8UbWnsLRffutORh1pW/Pgunju6h+0px2GAJsNVhU3MW9UuBCAgCxt4PrF1bdFQA4X79PAiNLjgzu4zcx3js2KVhRsNQdi6CbGM1fN+0Ol+akayVpZ9i8cxla1ni4QBJ+T68l7ES1cLpnSJZniaXlr0jAdBTXwhX8kRRM+MDKHA6KumiAZLuQubFRHyLG35oMHkffIzLesa2Ucud7B81naVSad34YZ27qZSvaanNjPKCeuorRcU/WPb1XTATtAghSHmloiZpc7KDK+TLB/6DSEoAlx+cItQBuQFULS3NvYDJoCDw/LB+1q2GSmySyBQRh+v1ek5AdcfhNYFoXsE9Vs8sg0fTDtuDwx/mBCmQYGsI5kvlRwmT/zxyoK8939aVRgvtj+Gf0XY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tejun,

On Mon, Nov 23, 2026 at 01:13:25AM -1000, Tejun Heo wrote:
> Maybe the leader can pretend to be in the new cgroup instead.

Thanks, I'll implement that and send it to cgroups.  The memcg scan can
then stay on CSS_TASK_ITER_PROCS, so this patch is not needed.

Thanks,
Zhan Xusheng

