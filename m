Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A3CCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA116B00C9; Mon, 18 May 2026 20:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A456B00CA; Mon, 18 May 2026 20:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689C26B00CB; Mon, 18 May 2026 20:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 528E96B00C9
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:36:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF2C086F61
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:36:10 +0000 (UTC)
X-FDA: 84782302500.29.DBF19FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 501131C0003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:36:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wd84Ncl1;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779150969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEfh4A9kFxCidLPeLXZv3NLukjkutw0I/pUHGJ2wCPc=;
	b=ZpKNX0juH0YTaY/SpPvfPYWomj61LVgrS0eurxqrIcBVN5pg4Ep9m7asPufd3uWGsRBPPj
	FDVj7oxO1h/7aWqk/P9Ry1JlLp+StPIv323oC1tovsqr19zc0AUJil9sug+DZF7mtL94Tk
	6skFWghHF7L59c5vhmJWZfrrxh3Z3ko=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wd84Ncl1;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779150969; a=rsa-sha256;
	cv=none;
	b=RNJ1NpKwC0wh5syyln9rqS5JWIPnKNyTKMYgfXttZ8ctqaBkxDAleX8esuRk/NApyLBu1Q
	0MuTbAGKD8RFR91ugU9RCRaWnkwGvpHENwaIOIo/+9iD+afDXRa1TJrIIV4fyZ0Dcqk5xy
	Nz9s6IgcYUQXg2fiOWsXwlxTRFloGl4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B0DBB601FC;
	Tue, 19 May 2026 00:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2731FC2BCB7;
	Tue, 19 May 2026 00:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779150968;
	bh=owBd0P0lMA93py2CTXoS7sE422LrV+LBEo2KaUK1wvU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Wd84Ncl1cKfRDwH/wi6QfTzzmChXx52Wgx8SMIiE3jURiN3qUVIWT066jjas+BOqa
	 tkp502xzXuiZ7hClg2eXZiBop5bFw9/Wthm/tc29S268FiI0sgVLbtmbsdnns7ByB2
	 y+YWrLEM8TWv1ZGqyPgKfyRR8KaFSpEqUA0Ug5DI=
Date: Mon, 18 May 2026 17:36:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: wangxuewen <18810879172@163.com>, david@fromorbit.com,
 qi.zheng@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
Message-Id: <20260518173607.c250f771be2baf92fa471b2d@linux-foundation.org>
In-Reply-To: <202605151100.lH0pRo2I-lkp@intel.com>
References: <20260512085546.368911-1-18810879172@163.com>
	<202605151100.lH0pRo2I-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t9a1frg3q3hp1qytkpep5m4b4qtqbtyb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 501131C0003
X-Rspam-User: 
X-HE-Tag: 1779150969-275893
X-HE-Meta: U2FsdGVkX1/4peT4u+XdMXFTCfzff83KSJtyBNTluC85zi4V65RLV7kpeaE0y0JUAVbxILQw0XMLEvfqHIdL9bDfyNc2NdCwcFde+WMcvyZi+Ye1JRiovIM6zV9Nicoo3RLkew8vvt9VmQhJc/XkzKayxTHVoiGkDI94WcJDHW94NklxFuSnBeUFV/HM6QyqNSYOCQyRHUXia1MQ4JwE/TkLXPVYsrwRkTboYispK2+46cxQfQ/5yR9xGxuXRUhqw/is+YRRm5heZJ2ATwHklS2iyqe8dW+8jgtSL5HnNEb4bla4wYxC/K+fw3nVE8Klfm+5+Ge2/L3+3+NAuRTCMCUETbo6yj/ZVS0JJn2zJKrjV/h9fRXbv7fdH9kIDHqvffHk2RxTTw19PDqdF2jgU2Zn1DahpbFsd6T6e0ul5fmCPxDZQAaOskhmJt89ZnCrlyOiXB7r4pYmLP9i8VP2gQxN46MC9tIsu0gVigidH1LkQpd+JHUjjiZveFxPNQ1f0WIp82Dju5y+0rspVoxfsC9T/AagehDE+uH98Q+0bqerFQx90yyJ4t8qkJdLGg50cpIMhCy9Qim92hMCiuTE/oITMC9W6MCqwwJ34c6O1wGNcmzS2Jca+PCS2d6f6Euc4ZGd2DS6Y4frw4rPHYDci0cQy4egDdrUt7brEZsowhR8mMxqUslIi+IFUyPvJVYmETEBTdeGC2MCBVznFiM0OjT9RR4SoStQubBtuEOzmxzrfLQCjFzURx//owRNbRndHpqUPx+h3aSVr483Kk7k8X3zM3eoLcc37CiAqg4ubf2bmDTK2cIm7mu2ovplIPAux6cwseXnW45FYTdGOZjMbYzF7BAm87LStlV/nZn9BBVpMcrkNR3Rqq56ZPdUoCUUbQWQk1MCmwpo0NM91mnsFAJZglgQpto8EGQm8MwljBYDGB2hhOvACHck5xmoVXmsOzJ/g1uh244CG0wzI9J
 i+x3a4GH
 hkBQ5RdGdxAHRfgEBUHABRyQpyivhskcGAqFG2UwEUuyRq+z7N3/TdPAwe33p34bADXUmyVbn1nOpz1VMmVNspLT6ZOdn6tTP70aSiw9Lv9MuuOcyecN7r68VR4py4Npbp89iUSVc41UaRUzSaMIq4qWTb2RusZTz0T1ec/HuCKn+r47nb9Hq6vcz8yV1ETwun+o8UHybRu6jIlJvqcgjBSEsQhtUiRe2yfm3hd2VDptUks1b6gm6BucYakWAGc5hjtH6pNDVD8i/e8NUn+hbB9zwcYiibKxRFT7U6djFnwa4gkFQ7jkk2SgAURN9Ze+C2napi+SkjisabNd9TMtStIvu9t6cbLubCtFCXpnlbJyGJRMEvcpuJUEsC6VcyN1F/pyutX8BKC2PuG9AYZLvX2sZREPzeJ0pucOvwVKjtyTA66i0ju6np96RDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 May 2026 11:15:40 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi wangxuewen,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on v7.1-rc3]
> [also build test WARNING on linus/master next-20260508]
> [cannot apply to akpm-mm/mm-everything]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/wangxuewen/mm-shrinker-simplify-shrinker_memcg_alloc-using-guard/20260515-014803
> base:   v7.1-rc3
> patch link:    https://lore.kernel.org/r/20260512085546.368911-1-18810879172%40163.com
> patch subject: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
> config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605151100.lH0pRo2I-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    mm/shrinker.c: In function 'shrinker_memcg_alloc':
> >> mm/shrinker.c:218:17: warning: unused variable 'ret' [-Wunused-variable]
>      218 |         int id, ret = -ENOMEM;
>          |                 ^~~

Something went wrong here - that patch *removes* this definition of
`ret'.

https://lore.kernel.org/20260513075214.2655710-1-18810879172@163.com

