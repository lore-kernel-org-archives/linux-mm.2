Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23626CF31BA
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 12:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288B06B00AE; Wed, 19 Nov 2025 07:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2605B6B00AF; Wed, 19 Nov 2025 07:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176A46B00B1; Wed, 19 Nov 2025 07:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01EFE6B00AE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:37:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B61ED4E3E0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:37:16 +0000 (UTC)
X-FDA: 84127306872.18.6DAA5C6
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id D5BD71A0005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:37:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xyHJxR2X;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763555835; a=rsa-sha256;
	cv=none;
	b=34tttoDjm+NNN0K6JGoUlslwvS/l1RZ+ywdOKzBSFqaGfNLiHLyMRf4/Q1rO4d7AyuBGbp
	A4ZfRuBusWDsUiuO7yb2Iu6VquDrADf+CqveS4BCUyOU3dPvrkHoZjX3Sj5hGDVEZT8alx
	U8t6zLbwYQtc37KVtHHC+wjmlv172ew=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xyHJxR2X;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf19.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.221.47 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763555835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=UbNuZv/5Za3Oc7Abgb1kuQDSQgL1n6Sh6FodFTL94fI=;
	b=cSDovq59b5nrGpniS2pj/0QNig/ADI5eFshEKNY6NMzExwh5zq9zhdbhdadyK5XWQkHNwH
	1pGiyKizH8O9wofHSO/exEmnilL7UfAN7z+kr2SOQcIRDfSaE3Rt+aKsKDRiLdrTJiv3gR
	g0k+scFXTancdPPuTFitOu/AdfYwyPo=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42b38693c4dso3013539f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 04:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763555833; x=1764160633; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UbNuZv/5Za3Oc7Abgb1kuQDSQgL1n6Sh6FodFTL94fI=;
        b=xyHJxR2XmkBiwusHq1eqnFP0eQ2JFLmCit2ttQcrkoTcGlTm4rILlmVsEtO7TSZlhC
         qX5HWBVoufd27iLwQCkFOuIavbndSxrVkqnokaL9JdebgIbbf4VM/xDQjhBHXBlbLdV/
         TTq+U6R1JEgZiVkDGIK/MyUpIzcPd+sTqPeZcLqtDKeQTpMc45XvHv/2FsUJken4VZ5f
         JVRqocO5DhfPYV02ad+j0OfH9/dVEjvk7HMzk1m0nE/IRtg8zoijqedvtpHW8YQJCZis
         3zgwlFM8raEAYr1S8LA1tQsVenQtopcebb/01Efg9peWcKWuD4XCDeFFxVsY1JneoXOL
         DgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763555833; x=1764160633;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbNuZv/5Za3Oc7Abgb1kuQDSQgL1n6Sh6FodFTL94fI=;
        b=RfBXTeXiBWkWlBK0AOpi7o4SmdluPvnlWsHUJK3bxt+sb/idyBWNmQEhB6NVP0zrL4
         LcPHPkR312ZY4UumhTCi/bhoDeBobreJOuQpdkpu4HYvynKY0NDUaZAb8w8/3YCuw+10
         U6ecgBEreXni/TU5p9euG9MrC8iu8UtCcsTJnvoUWIF2z+BajlTralQbq0+gM5ZIhGX7
         HpoA335zxq0Wmv25jTjEt/ueVUZ01qrvVxInI/GUG+QPBcl7T2ldFyvaChJMPBQPRaTg
         vXDChHUQHPPh6qNFrDZnivE6fEz3emvQb0rNxxZBeOsEnuaLkLTvmu4ntyDpc4bJHSUD
         expQ==
X-Forwarded-Encrypted: i=1; AJvYcCUv12Fo2KHyfmhmF+uL3PMJDy8zlLhnGOxgorKGYcGPrTeQ2Sg448Mq4cnDYLmWH8jRmmlKlVfbxg==@kvack.org
X-Gm-Message-State: AOJu0YxMPgKVME0SSulPgZej3k4SSeUkzF9Vz86ZeYxc+5yi5qdO1c2w
	5/1DfJ3HOI7jZsiBorCKfm34iyh2RyuXMWGYvOO4gNSVxt1fpXeV2rtKIeeBZEB5nPY=
X-Gm-Gg: ASbGncslAxc0U8R1zT3AUDEYLWxY1sjOwhef2PRDkvG/PkajKdiSn1JUDd+xajBsF2L
	LMq+MivEJmlTjOBPWlrfE5YIg5acnSROzhVkLAaBkR3FSQXjlnFO+aaaa08Hx/UfoquH2O1WL0t
	kjEeqYKt45cwGoGCAzyk5y2gYzieTk8VHirbHEIgGgLjO3QS5tIUReDM4pnI4VYFQmzrzPms9t5
	FfbFwOv3jVMyRRwIjdNHdXGcSGkBdunaSFjThVBjiqNUP5xoXD1V7TD07vwsmYzWE/1fd4TaUPD
	CQ4TOHNnRRtXva5F3pgcBOndru9TsIaCY/Oru+SSySl84FLA2JiSgiyrKTmaC+wo6zcrlAyi55y
	XHTbp1oZe5DFzDhuhprd5UrEanbbc9xfr4pRJTikoBz15C1xhIBKvWqPeCSnmnglgFuqZM034os
	xdMkQdChtgnUxuA/pd/ASk8PDOpNw=
X-Google-Smtp-Source: AGHT+IEkeW7AYIkdag7V6zOou3VntsZM8Hgog/jx8e0yYhvUx47QmrZwYx5wIGi3mp9Al3RK8NbQFQ==
X-Received: by 2002:a05:6000:40c9:b0:429:8b01:c093 with SMTP id ffacd0b85a97d-42b5934f642mr18648197f8f.15.1763555833162;
        Wed, 19 Nov 2025 04:37:13 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-42b53e846afsm36908546f8f.13.2025.11.19.04.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 04:37:12 -0800 (PST)
Date: Wed, 19 Nov 2025 15:37:09 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Wei Yang <richard.weiyang@gmail.com>,
	willy@infradead.org, akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <202511151652.GKPwEctt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114075703.10434-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5BD71A0005
X-Stat-Signature: e3bbiwj9eigf6ou8r4neu9nwikcj148f
X-HE-Tag: 1763555834-348548
X-HE-Meta: U2FsdGVkX18ZAVhGX+y2ZRARGA1DTHvT/OzI079jWXXYxtQqVd9idTGK9ahVXpDTFjvjblmqDJobigchyea1WYVAMW5vVW9ZlbwLvIEBSzKsKOgRTTjEbMBpNwoxsc6raDD0bmEkMHYN5dbaGgPPxziLmczxzWd3aPBjMeeAk9V0mdhek5SsewlQ9qKqxq9s5tEBZ9LXro3HTEloAn7Ohol/nFg+HlYasI5n1WZhnLJdHlX299VR+WXnr6dWbkTb7ETqfEbYwQYr+0TSed1Ay9i+OZLqsB7u9lx91twA0GLwNnE8dkDo0CJXLluMNTfPzgomyzYDg2mSaY02mNMIlEy3RIPbZIdTH4JdF44kzgu0EkpdbwHmErr8b3cQR2lkPwhUgL3qF9YwGR5Y2ebD6t//IFzEyuLgSQEftAcRPtSWk0KD20sN9Gw3UjeKY4SMGUC+7EfjtObP6ESaZI/74ccCLeP/EVqQ7CjTDUVlGhn+nujOUOU2PLG0NNQzbyyRNFIExwaNki2V+1aeUFQ/ALDxd1qmSgFh4lPFcmlhBHpQhBdXKCMyVi1qT4j0YDnAkrfFyYnaIFUklGamb+F2bLa0AwNPt45xQwK+uqD8RCHMvAc6KAMNb06ShqkK4vP0xj3Uz9pIvrjdKFhhxfblcGlw5i/gqoqNdyp+PMlR/Ula7F43n5Yp8ORuMJNz+EyLOB+dUlUBpXLlZLT5p6PeXdybzHYRag59+zApuf7n/dJit2BQqTffuGwSizsZL5TWkH9z5geNNcocd0SEWY1d3ohFsR+/JCyjsZyZoQ4IMw5ZMe1UJcY82/8yNZRTbeMxYg65HjxXN4uSMPtTkEm1EmwhkyXj7IbZDXlaup7nVVBvhDIOSw5AooHQpOCdsFKNJDzx+bIhOje8q7BKnvT35R7XAhO0GiD4pHVCtWQzmKB/E/IEB6zllmAw0tb+q+Rb5Z2USW9oTsagycmtZmp
 tnzrOjXl
 ovT7pm6q+d1u9VBb4h0Zpa0VjuIMYXWG/J4VhdMTqiwdpCKZjQ/OGCGHZy6Tt4DNlg7b15e0dztWJgS1omt/OULtW09zwGIyI1s1bfCpqg4irUdIn2vEBGQqC2seies2n6p9ix8OiAF8n2o3HFmeLsQVfqknHXUupiIcM5gw48UjbbPNoYKIaf/w6GawPZQCN5Hz0EPOvvSwDwnTKbBbE4XZJIiW51Qmo3je7fsJXlqFxCDY2o7Fn/cqG2CpX0VkZFXlfN0m0S7YpSKFIryI+Lqa61yKT9DKmlTZhLABVfh8nLsPj420riBH4vl4r1LvZKK5sfTsgJ5BGj/Ble1YzrhprfL5Oj+hqxIhnUKVfQlxZd3AcvtZWjlWzPP+SDk4hxorlKr+HhF0aPgqTrVAY6/V1mcIRPjBxyxEUoxksG5xGIvcB1nXv4kKL11xCs1OkSKal5fIixduuyV0GdjK993sfcl92RvmHBknxVSctKnefLvWH+s2EGzdc39mWqViP5gskwj57UbtuqOFbbho73Dijp9thLoHBozV9fv+B0d/Iyv2nadUmgodQrRWlbkepZxiVz6RR6fuJNmvmw43/HMWSb7ttgvfr+4rS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/Wei-Yang/mm-huge_memory-consolidate-order-related-checks-into-folio_split_supported/20251114-155833
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251114075703.10434-1-richard.weiyang%40gmail.com
patch subject: [PATCH] mm/huge_memory: consolidate order-related checks into folio_split_supported()
config: i386-randconfig-141-20251115 (https://download.01.org/0day-ci/archive/20251115/202511151652.GKPwEctt-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202511151652.GKPwEctt-lkp@intel.com/

smatch warnings:
mm/huge_memory.c:3696 folio_split_supported() warn: signedness bug returning '(-22)'

vim +3696 mm/huge_memory.c

aa27253af32c74 Wei Yang 2025-11-06  3690  bool folio_split_supported(struct folio *folio, unsigned int new_order,
                                          ^^^^
This is a bool function.

aa27253af32c74 Wei Yang 2025-11-06  3691  		enum split_type split_type, bool warns)
58729c04cf1092 Zi Yan   2025-03-07  3692  {
ab62f1bb0caaa5 Wei Yang 2025-11-14  3693  	const int old_order = folio_order(folio);
ab62f1bb0caaa5 Wei Yang 2025-11-14  3694  
ab62f1bb0caaa5 Wei Yang 2025-11-14  3695  	if (new_order >= old_order)
ab62f1bb0caaa5 Wei Yang 2025-11-14 @3696  		return -EINVAL;

s/-EINVAL/false/

ab62f1bb0caaa5 Wei Yang 2025-11-14  3697  
58729c04cf1092 Zi Yan   2025-03-07  3698  	if (folio_test_anon(folio)) {
58729c04cf1092 Zi Yan   2025-03-07  3699  		/* order-1 is not supported for anonymous THP. */
58729c04cf1092 Zi Yan   2025-03-07  3700  		VM_WARN_ONCE(warns && new_order == 1,
58729c04cf1092 Zi Yan   2025-03-07  3701  				"Cannot split to order-1 folio");
28753037121116 Zi Yan   2025-11-05  3702  		if (new_order == 1)
28753037121116 Zi Yan   2025-11-05  3703  			return false;

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


