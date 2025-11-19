Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE9ECF31BE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAFD56B002E; Wed, 19 Nov 2025 07:39:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D887E6B0093; Wed, 19 Nov 2025 07:39:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D796B00B0; Wed, 19 Nov 2025 07:39:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B85A06B002E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:39:09 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 841431A04A6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:39:09 +0000 (UTC)
X-FDA: 84127311618.27.E6813A8
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 814AC40018
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:39:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NL9140IN;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763555947;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHvebzZNHtF5Uirfhl1zM1fOdHCkj14yEnqWrebk/Qs=;
	b=In+Qlol3oUbmjq7vM1WpoA7RiVcC/e7VdEIXm6DKECAyAKJ8arulC5c7CnToOhfnSjnAYZ
	GxtYguPRvNRdU+AgDn7ZaRb3aOcxgo4a5nwVxoQy0ekRvPkplXebbeyY2LCuvrKIliE/Xn
	vokhoW+pEtVeWb3UWzToTh3bIqsv1K8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NL9140IN;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763555947; a=rsa-sha256;
	cv=none;
	b=QG65anFrRBzCQN1OG6hXqSpA4iUXQzF6mJEFNboOA84rHueNm8BaDj/E77yQhUzpmZeopQ
	8RlLS3tI88Ljj0fP8s3kIHKtKKjXcQvjAR/qJOst/RLeO+tkZvvpIK/nksOe4LRARAfcul
	ez+2Uc1h2FmsXQj8r5qPo3Js7E1kEHA=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so11353159a12.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763555946; x=1764160746; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHvebzZNHtF5Uirfhl1zM1fOdHCkj14yEnqWrebk/Qs=;
        b=NL9140INI8ABq5EUbXzijFxPi66gBftTdGThd5tw5NuCqPFTEFSh7+QwLFZKzz0NGy
         fPXozTjRf0BGUJ+hiKpksD8ZieVTKbLdifIaY5EDFylZ8TYE8vQWnP10/azuhqlTICFK
         AN/RajiwmMqHx2OdIPBhkpwx7kE/5tnAViBiZl0/jdLxJrhEDvyQotPs7/u3JZWsM6qL
         MTmHQqYR6van6cnInderphG81CJXbX86L6yvbvz6Y4+KFCx1UOIhKldYKB+CIdZSEpmF
         uukpQjVonSq4uL+Hj2mUxa6i2QP0iFWFNxQaXT6mxBCy/frxeIht89UBZqTgffrXu2FZ
         xH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763555946; x=1764160746;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CHvebzZNHtF5Uirfhl1zM1fOdHCkj14yEnqWrebk/Qs=;
        b=IoxWIX4WOCblMmg45SDzrJ5CXpfKsNKBLgs3E950DHIcCNRD41ps8edGlt5RmtxLMJ
         P5gDt+Fsddo/jCYKrHTQN5OaIDONyH5bmlfPdzclOhEQvZUMrLEzaw5wD4auaunBk9Dw
         ja94IWaSAbPwcYFLv2NC/uXYior/bkHoKigz7fVrvlmBlUvJNmiQ4V6NmGtIMF3QUPKU
         xxrtN04MRiuhoXVrekqNIBJS/+JvAFWSpJMkKTnBqxx8iPA9jUspszuW1yRSwP7zj3yf
         eLv3FmKwQs0aVveFsLbOXnERtVlVBtm6VgcQWgNo36YRqAsdjxto7F+BvIvYkCrXCkd9
         ea+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMy0/wh971PoyX36nenN1TQg5AJqRgugrKSVSNnJ4vBikWACnQ4m3FkrW8VwOmmvbIFJt6RXFxxA==@kvack.org
X-Gm-Message-State: AOJu0YzsNnVFs1RBEUw69hBFZ3a0zYgBOSBX5LCOaopARPvpy+NfPnCC
	KEJIP9yYcpAkS8WLbxMiwq/FAY+0u7LrOOYKpND08GYlC+LH3CCi8PTb
X-Gm-Gg: ASbGnctRlz+AKhr+hZTsOebutz7fylPTR4PIbVHOx5A7IjSV7vQI3fMZ1/J43cXwt5M
	w0a+MNlbbQ4MDtKtKoInPUvqBF89OGrx7GNhfCzw5+HKOy17p7+yhVI5j9c1UC6JT9DIypeqXf8
	3zi+vgUkyFlOQg0pZMIphjM7NWgKwhuWgcReMz8T+m63H7hRxe9q2HbvGmFiaSs/syx3yAGRRIy
	NZ5MfqLOFDEPV3P3tg9rl5bbB5+d96d2wKoGErIZ6oyKa+2AXoiS8b29mPVCJmh0BbitY3Zgthz
	8HFOL2YiGm20M08nTfMJuW+iBMkzj84lHssk6k4DwEY64mIpnLnlOgQDoWTLExd1nxyHS0VbKw0
	zSoDIbwq88OpZrojCUi8mXp9yT4zugatHkVFeWe/V3/SIB2uIaOM7ZR06RFHOmoniH5vgB9HTqr
	cgByDvd6y/TW79iz8/2FR58eXp
X-Google-Smtp-Source: AGHT+IH6kOS0l+EUbnypOaJgGizNY/obs0hzloB1TKPSHs9xqLDPIWs5NS3ucRiDjUds0rraP+UpiA==
X-Received: by 2002:a05:6402:354d:b0:640:ef03:82c9 with SMTP id 4fb4d7f45d1cf-6451e36df53mr2153224a12.11.1763555945740;
        Wed, 19 Nov 2025 04:39:05 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a3f96e2sm14975912a12.16.2025.11.19.04.39.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 04:39:05 -0800 (PST)
Date: Wed, 19 Nov 2025 12:39:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: oe-kbuild@lists.linux.dev, Wei Yang <richard.weiyang@gmail.com>,
	willy@infradead.org, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251119123905.ak67ykufvfr4iulr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <202511151652.GKPwEctt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202511151652.GKPwEctt-lkp@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 814AC40018
X-Stat-Signature: mndh5demy5yc1npocgqnwunyebca3zoj
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763555947-942829
X-HE-Meta: U2FsdGVkX18c4N3HbkcxYJWD2vNk92va2Fs7dP5aUcxZgp7n0kio3bZxWdoTc0jM8uFKh3fw3youdPDtz+F5LSMbPNLUK8DV5j5n34Pdk60R/O0DIahqb9rQ5MZbb4DzPO/MCHwMN82g0Dq4LyOirVI0YEggnTw5Hs7PoP/zOe80pEsdso4v5iVTXIzL4tuPqRZlOrk2PbbwnheOX6WSccgzO9QBWR8S9DC6HLtOEZVRzbVki4/+tDtiBIGgK/bODGqMkdcXNbDGB+ykmLS/5xyzekezxdlgSUDi+o399la3gn5rFFDxYce4WYrHb87at84+k5gnOhwtyHh6KEwCNCmoIBXBxl0h8UjmnBUAcWAOQiRG6jqd387Y61tvzNRDpYxqTCdEmfafy5SqOTVENqipPz06FG1Yt8j7s/r7WZt4CYuyBoN8JfC7IGpES9QF2kyy4v8HjCvJfnuFJI0NN6ubsm8ljhcGeNt/2TTaduGbdzpsCtkCYMp0TQHoMfhAUQwFMhPDK0D5BRdvpszCoUHa7gfKlob0nreqGGf/TRnOYX7voPiTa183g5MPrRHyjx5F3tI+CQo7tM5srjcSTXG7Zg2WpjhWM0BIeUq1Lrn1sxcyAVAmA7rda8WrXvi3qsRWew0P65rHuxSO/voZmlnFeZcJeIYF7XC9gjvegV9rSMDc1NM21ritCFADm2cag01J+7sSaHrP0mFSPd6yyn/vWO+rssXeeQJ0hVq1fFPU1fmm4ITZsX7FwVAoDah3XtnZU0DDScbL2kU1C1GmlmxDMEXM9OFZ1WPUmA35lhDCKa6pRDw71kHL2C7MgLoKiRA+8mZn3a2XtTRbPjOTKuCJ1zpnDQJllCtN29uHiCgh+xAaepcHZeMO9J0r8evoOBmMhv0TQ8MWnjZxLLepjg0UgDQTHVPE8U64tzgKMchthIPl9rNWgvFBJPzBXH/oGDWhYH05ciWOalrP3Xj
 Q4ZVW6eS
 udA75urTTZm3K5bGNWRqeZVfCLZeG0tuZwKKyc4YF6sl/3piYv5T1nwHm+n+hS34b9lsBD5UkfxZieCsbmLRHldrFrnkPFZ+R2rCIWBtN+WcLV1NDlfq7tGDdX/xaC40gs7Q25Fly32wWZyg4opZACu/qYlNc7lOpkpmzZQSDC/sNbwyMT/8nTcQzze57SsNQ21b21lo4poKjWxma9mPCbI4qx6A9oTCqfEl0i+khxAj5dxN97eG0rVIiKlibS3fO1WwsX9zEeU4yk9MhH67/KGLq+tKpJwqqiVBYE0a1e/gdfWxgs3qiEq++zyYttiF9xreulw8KzfxoZaZ/X3S5BCAfZQyNrb1w5SNS8bXReIzBZe0G3jTWCuuQ3lLBJqk36FSB2EZeZ3uqMWRt6dBO+ZNojS7rFOgo5anNVlb1HZ/N+E3O3r3jl8ShT8DA4MP6N8hTvxWP9jfjzbCB1mv4Yk99iQQMNpp0asEeDNF9/xJkjD8uAYHNfUBbb7MQNkSAMTQOMtXV9UWsb3WESwoKlNnbY4vXLKPhH/RUkAIABn9XlFGjpskB8U4ZwP6W0lvT4S5REia6iJIRo4uir/7yx9ddA6c+kZWvUIOr5mINKlvGIBQ0WBM7/H6mN7NSaaZ441sHIfC51ERm5KtBcgXVnr4DrqOjoEE383j2bk5+GxIcLHA0USS+mzRr3ZNUFqHFfrVfJ8aDVuq81aZKCU16cvNAl1ZWaes2/NbBT1HtRf0hntJukypkWMwLEp2+TciDUaZKISMzFXG/iFu7O+cYZivlkjzm1889/9FvVyWU2g11jCBFCLd1BFMQGQ6ASPH6GqYatG5PDdRpaMjmnw7PyhtDdyWDs++p/TLYljfOlAM0Fdv767Lda70nnpr84/hRhRcnjf2xKssp5Ofk39w8okc/KM0am7tJhqszeOL9WTYcOrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 03:37:09PM +0300, Dan Carpenter wrote:
>Hi Wei,
>
>kernel test robot noticed the following build warnings:
>
>url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Yang/mm-huge_memory-consolidate-order-related-checks-into-folio_split_supported/20251114-155833
>base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
>patch link:    https://lore.kernel.org/r/20251114075703.10434-1-richard.weiyang%40gmail.com
>patch subject: [PATCH] mm/huge_memory: consolidate order-related checks into folio_split_supported()
>config: i386-randconfig-141-20251115 (https://download.01.org/0day-ci/archive/20251115/202511151652.GKPwEctt-lkp@intel.com/config)
>compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
>
>If you fix the issue in a separate patch/commit (i.e. not just a new version of
>the same patch/commit), kindly add following tags
>| Reported-by: kernel test robot <lkp@intel.com>
>| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>| Closes: https://lore.kernel.org/r/202511151652.GKPwEctt-lkp@intel.com/
>
>smatch warnings:
>mm/huge_memory.c:3696 folio_split_supported() warn: signedness bug returning '(-22)'
>
>vim +3696 mm/huge_memory.c
>
>aa27253af32c74 Wei Yang 2025-11-06  3690  bool folio_split_supported(struct folio *folio, unsigned int new_order,
>                                          ^^^^
>This is a bool function.
>
>aa27253af32c74 Wei Yang 2025-11-06  3691  		enum split_type split_type, bool warns)
>58729c04cf1092 Zi Yan   2025-03-07  3692  {
>ab62f1bb0caaa5 Wei Yang 2025-11-14  3693  	const int old_order = folio_order(folio);
>ab62f1bb0caaa5 Wei Yang 2025-11-14  3694  
>ab62f1bb0caaa5 Wei Yang 2025-11-14  3695  	if (new_order >= old_order)
>ab62f1bb0caaa5 Wei Yang 2025-11-14 @3696  		return -EINVAL;

Thanks, this is noticed.

>
>s/-EINVAL/false/
>
>ab62f1bb0caaa5 Wei Yang 2025-11-14  3697  
>58729c04cf1092 Zi Yan   2025-03-07  3698  	if (folio_test_anon(folio)) {
>58729c04cf1092 Zi Yan   2025-03-07  3699  		/* order-1 is not supported for anonymous THP. */
>58729c04cf1092 Zi Yan   2025-03-07  3700  		VM_WARN_ONCE(warns && new_order == 1,
>58729c04cf1092 Zi Yan   2025-03-07  3701  				"Cannot split to order-1 folio");
>28753037121116 Zi Yan   2025-11-05  3702  		if (new_order == 1)
>28753037121116 Zi Yan   2025-11-05  3703  			return false;
>
>-- 
>0-DAY CI Kernel Test Service
>https://github.com/intel/lkp-tests/wiki

-- 
Wei Yang
Help you, Help me

