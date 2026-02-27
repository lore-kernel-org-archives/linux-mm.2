Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6800BFD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF1F6B00A3; Fri, 27 Feb 2026 14:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6746B00A7; Fri, 27 Feb 2026 14:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B256B00A8; Fri, 27 Feb 2026 14:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 523FC6B00A3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:10:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B828C5B821
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:10:17 +0000 (UTC)
X-FDA: 84491177274.25.D2D5494
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id B064B1C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:10:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P1DagLwt;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772219415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sh4Slgmg+UM8ULkOgNjOfZ5JCRqub7cSuOexnoiN0l4=;
	b=kI33gQPwT0z3hCCRaypX8DPnAWZMS4qp1fa+i7fJhPCnf/6JX4qi03pIydqChhShXm1XXo
	zRYqBf2IWP2W2x8rwVbnhPpXboqEuTD2G8e0ZzEkAGB41uez7I2akRYS7kIk4kWo8A+WYb
	uRKI1igUVOAxbfQweuoK64ciVq0pPl4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P1DagLwt;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772219415; a=rsa-sha256;
	cv=none;
	b=RRFT0Z4CnF8w3b7H4X9fdBwcehlbYkuTHM4rUzE+66Nd0lWZ0fc17UcFFF2nPF0L7MAw4P
	gNEKVtN47Rj8dyA9pV11hRczNDcBbYBC6FwSnxki054NLVqAXU+qhpTZuEw/ENmV8i8zi9
	CPSqdG7hmbG3v9bnywS67p8zv87/4p4=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-46394090d2fso922053b6e.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772219414; x=1772824214; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sh4Slgmg+UM8ULkOgNjOfZ5JCRqub7cSuOexnoiN0l4=;
        b=P1DagLwtnPFKYHVVfiYUQ+DRa4RbyAHVG4J5KYQEfAoRXOZM0LFaXKoZh/ivsrBPc4
         +q5nvBSvSGA70TmybbRhdRGdfXEbTQl02DK/Xo2VOoWKQDdBlLYF7tq70b53sommusjD
         it2jSJqbBEQ27TaWdFe3ImJKzTupJeqS8xIZkTUMXopZ80Bs1/0u9FUKi6UT+Rz86VRn
         NnKVMcH8r+RtBxtEJFc2bN+PxE34M3FbBOOu1twnAZK8kM8Q03MRowcGebH4tRacqmbj
         xf2QURGegshY++37l/p3fST1b+wjmWbIt0iuWZKw/4vd4+zbPtIowaSf4u8Dlsi65l9c
         3agA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772219414; x=1772824214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sh4Slgmg+UM8ULkOgNjOfZ5JCRqub7cSuOexnoiN0l4=;
        b=RrjUjyWAIAz063pvbiIuUt7O4go/TdUXqz7zX1WK3rxb7XLydF48AxhGJ+WAS9uWdN
         /6P43jczc68CIzwpBuFfAmFGZ/E2Q5nHJjL1VQHShp5AMNUbZbL416pNCMBQPUCcsJHH
         EvnyATc9HSCzv/6ETuHKZXYTnRxP37ENNsrTPoa83w4oKFvn3UdEO0ujnkZb0ncoxgYR
         lmqASGqgjn9RPGqcW4SLFWQ4ywFQ1oiWeoYNpmITRJSkSNhJtfhHgIBnxvzkvy9Q2CDY
         kcSEFke/NN54VT/wkXs+pr33wF0G11LjmJ95HhU9LkTupFA2SiK1/oCJTWhN9PZi7VOn
         6Qcg==
X-Forwarded-Encrypted: i=1; AJvYcCUMvD/IcHRiY/B0AweOibmo8PhmmfqtwJvWW6VDkHfUHpPrSyN78lxPG0UD2aQPQrKKDlxb+AkgGQ==@kvack.org
X-Gm-Message-State: AOJu0YzgjvlQGHf2IL6wbo359z1rFlyOGSUjQHy1A8sLbH0TOC8NUufk
	T0bHTsQtlsobzMMbKYx6wQz5QBv9wsynVpV/iiA8Muxi15/W3SDhrf7CfX8iJwYw
X-Gm-Gg: ATEYQzwuK6qJryghSUKyPwWWvYjYSyz8JPEUToyEb/TOR2Gip5EvqVXEDcWwz0g2lD5
	iFdZ3k7QSKE3X7wG3jQd9ITuzHmxJRhJTYW2S0YAwhzOFFLDr0ZNobIQLpv8U7xv9mktCVkSmaS
	sacGY1CjBoCbf0eNIZu2uMiB3u+LyZkzznElu+kw1umsdgeFsIP/rnixWLD39wrBfKZFXQdT3kr
	fHvPM6Btcil9BJ35RQL13eTFWi2XDAF5EHDU9Da4+sORqHpAg5r63tLXdPje5S/sY2XhNyPUhW2
	eTNTMTwWt4Ybw8f1PVPHNUYj01aFUeXqs51MxGD9O0Y8aHAn7rDHOZC2eKiiAx/S5rAX93lFd7/
	5m/jAdruU8OXEbKMQo5aJ5PIfqkWogwq9IfCTFTFLN2wn4TEfEIRjCkkngyk52Jefow/hESvV9A
	+RkpgzjDfqnngbYRZjC7Nt
X-Received: by 2002:a05:6808:2205:b0:45e:a749:81ed with SMTP id 5614622812f47-464beceb3c7mr2131034b6e.25.1772219414489;
        Fri, 27 Feb 2026 11:10:14 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4160cff1aacsm5051639fac.9.2026.02.27.11.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 11:10:14 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	oe-kbuild-all@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 5/8] mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
Date: Fri, 27 Feb 2026 11:10:11 -0800
Message-ID: <20260227191012.144117-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <202602270738.SxqPEs3Q-lkp@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B064B1C000A
X-Stat-Signature: xoysfugn5cxtrmwtc6ej73fehfaow1ka
X-Rspam-User: 
X-HE-Tag: 1772219415-666766
X-HE-Meta: U2FsdGVkX195sxGwm5xhlL3TXVco5n1Ppbs4g0MTarvTPUW5A3QlNS606HHnJoeoicIStxZMNvHdCaS502xsC0RtDVEB/zEu2f4DCYUKvoXLV+o6f7M+yQ1WCY680FKj0E6NatA3t5ffc3R+lumxqisZTfKwDlfsqt3Mqi8ZJWdlzivJmoXFJUVBI4h5ETnfvurqSUx8Q4MI5I4/s1us4Fowgdw6AHzPDP9E0zfsJhPLzFHD5RsysajQFptkfXW9hoye7TjF1kTkFySDxwJx/V23z97CdgaGg5ZB5EZ6OxNy3tAsBRjomFo+PMWw1dLbO1ACtwVy59Mmf0ALD7SbcOVw95ZoircpoN4VeULH4pnNoaffenPUoBSx2jLiJY+OZshUFkkt6m8UJu8QI49crapnqoW/jq+/lqKoNSiai15aF1tQzJRFx6D81CD82YhFNV8V/GBpDDCqr++0ScUQEDsO3SCNs9AnKIPya4x5FLXC2fU3UvR+RpJuz3x/d9mJD9DDeYcT/QybG7N+EjC+sxF1rq+be46GsbuUuyXP1l0xXT1tx3MKRfri8sn684yrjOheeDcvtKRnrTNaRuHGDhxNL4UFdNO7w/E7vSFe2q9djudaJwCxBbWXiB3L4efQae81PQZ/mgJ3WIffCX7NkV9HIfbnlCTEttLZj2t8st6+bIFQ95H6f+M1QYU51hJvSywrn+BvyNceA8ovuc9WzQ/Xsv6tRuBkEcLLLA5e3mAwIJ1/b/iUrKRb5sXqWdsNgSG/qEZLYAde7ywdDFV1K81rrQkvprpSOCDoAFXeOUWexRgq17oeOk3zSgc1OY9roGc8KyUvyFjwBhPTDdK6qhMO1i07gquUNzbOGkFQ9+WArQgPCZDyAqx1pc24Re8lDiYI8qj73h+Ms0+lU4dFDvk/ZOIO7Y3x37oxqzPwLJGRuQQeSP7co5ftCQfPytngK+Jgx2VraY2xSGSrHa0
 3ZeJMl95
 R6jF55ZYFlvh4nC1QScISh0Bjm5Di7gkleICmDV8BHRlImF6C9sdJas44qtOqb4VbWob2KbX1/7geCBYxo1i7oX8ObpAjq4BQLCGfu5Yr/sGMeEaNapX/fTUrS4fUawxXFQqXCaOB8e1I5BvaQeYRnhOs0lKUuC4/CUvCZFkJdduEA+nyS3GJJrUhR0PitH0bGFp0+9zLBBopFxZnbwqyj/9Jg+K2NZ9ncRxn/Rp96LxPT3y45AUdglnqPP53sI8BdtvLngyUO9jkdasJqPAUKYbmvEhO2DhogYoGyzVkwERvlGb3cR8v/OqDOSgzAsdI5URzCk152v4BRFObUMUGFMYc69KY7Ggy/hl0/Q6gvw3YDq56LgiZZaVQVtoUqJnvaGMysnzZCjnVuWXDqI3VbYZodUpfA0v5fCFrYI+HXCSTOgVzlOjRGFnrMc0UtQb3fEcwB5cYNFg91cQQ3mV21idTzU+iAUssrfZGQV73rSCe6TquI8RiCZS0QKEe7zWS9YZW92k8TFXHfpZeWPURIT2KkAmkCVU5v5nGBkngaOby6Gr7pP00o/YsJ3tNjRfC3uKJTfNh4my4lAu0PfDjEfYxL5w/XbNejYS0paF1u5YL7DekrWNXE+m1ZaOwoFRf+NVN0X6OK9VSZr0x6FVONCg/lkqKaRL7aa96
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 07:13:12 +0800 kernel test robot <lkp@intel.com> wrote:

> Hi Joshua,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on axboe/for-next]
> [also build test ERROR on linus/master v7.0-rc1 next-20260226]
> [cannot apply to akpm-mm/mm-everything]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260227-033239
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
> patch link:    https://lore.kernel.org/r/20260226192936.3190275-6-joshua.hahnjy%40gmail.com
> patch subject: [PATCH 5/8] mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
> config: x86_64-buildonly-randconfig-004-20260227 (https://download.01.org/0day-ci/archive/20260227/202602270738.SxqPEs3Q-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270738.SxqPEs3Q-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602270738.SxqPEs3Q-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mm/zswap.c: In function 'zswap_lru_add':
> >> mm/zswap.c:626:25: error: implicit declaration of function 'obj_cgroup_memcg'; did you mean 'obj_cgroup_get'? [-Wimplicit-function-declaration]
>      626 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>          |                         ^~~~~~~~~~~~~~~~
>          |                         obj_cgroup_get
> >> mm/zswap.c:626:49: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
>      626 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>          |                                                 ^
>    mm/zswap.c: In function 'zswap_lru_del':
>    mm/zswap.c:639:49: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
>      639 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>          |                                                 ^

Hi Kernel test robot,

Thank you! It appears that I've forgotten to define obj_cgroup_memcg
for the #else CONFIG_MEMCG case. I'll update this in v2!
Joshua

