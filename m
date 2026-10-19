Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1C0606A325
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ri2ytWQ+
Received: by kanga.kvack.org (Postfix)
	id F21866B0387; Mon, 19 Oct 2026 17:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAD26B0388; Mon, 19 Oct 2026 17:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A406B0389; Mon, 19 Oct 2026 17:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7629B6B0387
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:25:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0564F120839
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:25:28 +0000 (UTC)
X-FDA: 85340657178.21.F722EAA
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0D03518000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:25:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ri2ytWQ+;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445127;
	b=Txhb9UcCZKN+GNCC/WUqvLZrPfyG+cpUmCs3qf9vrP/Zd2k0vjKLE5kWq7EXMm6ChuawSz
	XAjdrtwtTExFP6QErp5sMNiK5qGM1ushzzW0hysE6BLBKWlwMRnjr3F3n58DNUIi0Fg/vP
	8/4Cv2QNMvw3WIzmcxDx5xkdzSV2eoo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ri2ytWQ+;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqwC/Ywk/urErM3liCKcvDfgOsAI1aXiD3ThAOoBayk=;
	b=gwPMUQP2rDexlLU1rcpr6eOK1S1EgafxT8w2FlFNGzd4jXyIaK87MZzIJNGlhUNAmBFYMO
	lFbafUGSA6tqMPIWdhnLsPOiuCbuX2P2UlZzHcN0vreg8mtcVQ9u9jVPosuStCwFMsm8Xh
	gPAYlR8aGVdOynTeze0UVychTtGHzQ4=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a19cba5c14so26770345e9.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792445126; x=1793049926; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqwC/Ywk/urErM3liCKcvDfgOsAI1aXiD3ThAOoBayk=;
        b=ri2ytWQ+QGTTFxCy+3AnSVHl8v1VHZ44IY/1In4b7Ee6uvNsNIpkArOE0SftF7t6Pr
         y4StG4E2Z1FWbQEWS2K0VA/exh2e2F5oQ+Gg0/tY1hM2hLI92vIo7tedMWWBRMWMNfa+
         3UgwVSSvG77VldOvNki7Dt/k8r6mNaMPWan8ktknwmMLfElAH9ekqVNakAZ9YDomNO5t
         0ermA+O5+wbfA5J/+Qp2dBpjxaeTcEVgTqpNKtpC0/Z5+A+Y2NbHfnaCuTQ571/aWFXC
         rX6kjgJx8vOHpIaXOLskT05eqvPedWKSum96bnpBLnJbZ02Rwt8dUm/CvKipCqr/lHS7
         7K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445126; x=1793049926;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqwC/Ywk/urErM3liCKcvDfgOsAI1aXiD3ThAOoBayk=;
        b=nXHF7q9WHT3FGWUryfr1JZ1/BzQCaKxV0E/KCX0Xc5ve/oA41/ysUZj7I1tmy1x40l
         uSS63QBsAtj8p1TeaTc12QGLXDTM8HASw2BeYH1P5NSKjDIpAP6YiUaDtQzgI756NKrA
         0VaFC2a/FJEZ23oizTFg54yR6CK4ELX5qp7AiKY3VY5/7SHtm0lkm+p3dBR5Q25ybpFN
         DbzNX3+ogNhLkvfzaMK8dXbImagEuWU+lELtMD/v/KKswLWW/7VvnkvAyHR/RimFb5p8
         FCG8nnD+LHcgrnOzMF5HvJ2JgNpoiinQVYY4okCKTKENG1NCYCygUjdL4HaeUuRU/noB
         iMnw==
X-Forwarded-Encrypted: i=1; AKwUvBzIZsZtrWyBjf6tqKtfuurS5jny3jHL9QTtrlngmjw8r/TZLa+2ca+vX2T5cWV7WvIs+koN/MwSFg==@kvack.org
X-Gm-Message-State: AFq9FYKvnBAvs1x7k0315xg2fzf1yogcto2DqD/klMefq2sWon7jTWqJ
	DF9xTjOrNZtxaRxeSBjekIZTQlwqphZDFxlIYTVP2aaDv1Y5rbrA425FV8vqnlE/
X-Gm-Gg: AYBFou32mJ9aJNlXRoZWwl8e5786nDvduswV3ekv2V72s/zdv87PH25kqtwJ6JH2mLR
	s2dnfa8Zvpf3Slgdzi9kdOEAud9hiIK6w/k/bHtTChEgBM/bEt8SugtpqPqpGsTv5IIclz+P0UK
	tTjlogk9CupmAaOAvxiDG3dbqQE0eyTAqu90vJEI9znWMUWavjS3/sB/+XxHkXDMvYEq0QC4Aq4
	6ZUlTpyISBoeSYYwbkVA4SGro3IDkbNZpqcejgzKfiAj9cOr8SP5m6b5S26GAK7BlmPryrWE+ex
	EtJ5gaWkzHPjWfWOfGC9E+oLwPfMhDd21OfuvDIZ2bh44Vb1EukAHQB+Xvy8PwQb60GsYlQKZdY
	Vh+nxb5838Jd1sMN55q4+ly6O9jt3Wjlkg7gzoD4cPCOk8aVT9vD/PV0kQHNMAzBOH4iRt9yKrH
	koh0Zd0fDPHh9b0dlddKA0f4c7TH6F/PE25ELKRuXtFuRjrT8/iLPWyqQ38pfLW46tmH0MM6pdU
	K6Wk+Bqhzlub3hyjteGVjywgCCIvPJSKsA=
X-Received: by 2002:a05:600c:c8c:b0:4a0:bc9:28c6 with SMTP id 5b1f17b1804b1-4a1d7643dadmr171548545e9.34.1792445125587;
        Mon, 19 Oct 2026 14:25:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f2c1e0e6sm25118305e9.0.2026.10.19.14.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 14:25:25 -0700 (PDT)
Date: Mon, 19 Oct 2026 22:25:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek
 <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
 bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>, Lorenzo Stoakes
 <ljs@kernel.org>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>, Luis Chamberlain
 <mcgrof@kernel.org>, Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
 Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 next 03/15] kallsyms: Improve selftest
 test_perf_kallsyms_lookup_name() output
Message-ID: <20261019222524.695a4d31@pumpkin>
In-Reply-To: <202610200434.qSHPOyDo-lkp@intel.com>
References: <20261018155206.132411-4-david.laight.linux@gmail.com>
	<202610200434.qSHPOyDo-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D03518000C
X-Stat-Signature: oksh3geazmatr83gas1fpd3a3h3mpgts
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792445126-584592
X-HE-Meta: U2FsdGVkX19phJzvkSuKVLGxqSr2mFP0SI1QO6G3SULJhghnJ/fOPH97/ugzCYb8t01N+Hy6NYkTUsNIDx2T8MqWTpbH0oCHPTlIbUGWuPEcD53rzAwfmMrhSyT7ZP+QiNrX1k4qeJ6fiP6g4XWau02bS3uohDemdtKDQVJpo1NmwhoDHVde6FpDseJz9QBfSEPHStLFdBOXSEpXy4+90ThL5w2FzemVbwnFI8Dr3mIowPLtwVY0fgs8ze1HVhtWHzsSUqR74i0Ha1Z/HMWi1AdX0uvNYIWKwnsoxi9c23rP+hreH2vodEq8FyxkHI+Pw/bHnPrYWlxPXPScves+krK4QvGmd5Z9GFPl3ko3+lD5I2ixf83BXmlLS26n8yD9B9GnZ119zDMA6GeKAMnOHkixysq1duCd/4FwMYmSs3I4pyjJQsHxQ108jBeqVbEBBuP10i8wCDN5hCGf7BF+bmywLuftJxT6k7xrvbs4GK5EGpTY79sfMNKIBeYriWnNf/B45pZf0ey73SJDeOK3gQPU6utomocsAaSxmz8yqpG0Kn55qjsRHCDXXGHujM0kmz+z+/+Lr+Ie0Ykww1aEwpGoK8xp37SxymcqKcoPTSZf4AaGnKFIouA8vjwK4sIwZkAzxMtC3IMFgUhY8A4s/lTbEWVPU2y20XNHqN5ed1IAhWYEJXFex7z2P/HF922yC813cdXiES2Xy5/e/wh0dkE1FngF4spRM0wjmZQDhoP8Et6b2hHHKm2PrI0lUid2GB3RyWYBBC6JeJaV0575idWYsDE6AJHwJyux4NpyBFuLPYJ0MIAK1HAHGXpjekqOcIIsK89UHomttW71ghI8yCG54PA9NA3Di+xh+WGfKqd7dJd5zgpcwGGB69rWT55FW3WEbHvgcCmkhyoRJLYTCZ+5oDTuwCVbrKa1dDAxrLqrDxNm5Dy/9UqKv5v77HdQgxNkZeYQUOnOr2NV+KS
 EFnrQLoj
 quXytUh7VYgorOPaAUkblDJSx2BYtLxN6zKM8rliGOfNz6L28K4CqiVyBBHujKs+W3bTreh+7QSvEdSXzrdcKd26CxBm5ORDj4+UWvsOrl2SxkD4iOnbu+xLZGR9RqN9NImumyPcvZEEQ77DjRgWNpyGANZjXxM2otUffrUyCCB9lp2GNOUn0lsVqZa0db0ByZdZ23uK3oMJLwJ8DHfTS5gPVMKl2ucDAUg+MNcUv1SaNW96Amt8coxmWChrgAOjYBXEfR7cvt12Nia+jB2h6kZh/+09OALuVyVOH+5K2U0LFAC1Dhlte5u5edH2FzJqHIXjrxHUuhDQHVX94L0cN2PnaQjK73G3pnXim3V07fDvYu6F9xLNMG6H6Hnm9qeFJcEVUwLTfBBTQfEHvwRWi1faWH3lhCG28Lfesfr6JnJmCkfP/3fACl7mNrg16Le870BVGLEPeLJsnt3MT17P8zhMbdE4RTaSXUQMfFzrluFTNPjxDiUUVMuQna012LFJGQxpjHH0GdFPN1nvqG+pzyVmV4KJn2yr3OvTGwVAUr0l+tKms2HVexWTI82CAmcW3tNgrVZF6w+ps/GidK+DH7Wotn9Dk8HUqD2vSD6Lx2mgmD7c265N3flGXgkIHuTKTw2FwvSoOot1aSyoH3TLF/uFmKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 04:57:54 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi David,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on linus/master v7.3]
> [cannot apply to next-20261016 next-20261016]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/kallsyms-scripts-kallsyms-c-Avoid-overrunning-on-stack-buffer/20261018-165152
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20261018155206.132411-4-david.laight.linux%40gmail.com
> patch subject: [PATCH v2 next 03/15] kallsyms: Improve selftest test_perf_kallsyms_lookup_name() output
> config: arm64-randconfig-1000-20261019 (https://download.01.org/0day-ci/archive/20261020/202610200434.qSHPOyDo-lkp@intel.com/config)
> compiler: clang version 21.1.8 (https://github.com/llvm/llvm-project 2078da43e25a4623cab2d0d60decddf709aaea28)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610200434.qSHPOyDo-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202610200434.qSHPOyDo-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> kernel/kallsyms_selftest.c:82:12: warning: unused variable 'The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun' [-Wunused-variable]  
>       82 | static int kallsyms_very_long_name = 1;
>          |            ^~~~~~~~~~~~~~~~~~~~~~~
>    kernel/kallsyms_selftest.c:69:33: note: expanded from macro 'kallsyms_very_long_name'
>       69 | #define kallsyms_very_long_name \
>          |                                 ^
>    1 warning generated.

Duplicate, depends on config options.

David

> 
> 
> vim +/The_time_has_come_the_Walrus_said_To_talk_of_many_things_Of_shoes_and_ships_and_sealing_wax_Of_cabbages_and_kings_And_why_the_sea_is_boiling_hot_And_whether_pigs_have_wings_O_Oysters_said_the_Carpenter_Youve_had_a_pleasant_run_Shall_we_be_trotting_home_again_But_answer_came_there_none_And_this_was_scarcely_odd_because_Theyd_eaten_every_one_The_moon_was_shining_sulkily_Because_she_thought_the_sun_Had_got_no_business_to_be_there_After_the_day_was_done_Its_very_rude_of_him_she_said_To_come_and_spoil_the_fun +82 kernel/kallsyms_selftest.c
> 
>     81	
>   > 82	static int kallsyms_very_long_name = 1;  
>     83	
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


