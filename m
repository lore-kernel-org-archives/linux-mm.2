Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E55DCCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBD08E0014; Wed, 24 Sep 2025 16:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB818E0001; Wed, 24 Sep 2025 16:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373848E0014; Wed, 24 Sep 2025 16:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3698E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:32:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E07AE118499
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:32:08 +0000 (UTC)
X-FDA: 83925290736.03.F9671C3
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C237180003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:32:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=E7SxPV5T;
	spf=pass (imf24.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
	b=xJ6UAB3jHgwjV4HPhRk0TC+p44MzYwF6DxlUbSOC8gqdsCqX7mnrQLE2/0d8eGWHTys9UE
	WzIJeZcqeBbKn6cUe0eI9z4iLEaX6SLTa5RVqREqF8NrpkmHo3LzSaT4pWyw/qNUXhb3G1
	cyxg/YgHa6Z9C+jOXtl1pbd05N/+kq0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=E7SxPV5T;
	spf=pass (imf24.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745926; a=rsa-sha256;
	cv=none;
	b=xX2if2NaoImoF7/V9dhBVNcsm05WAknBh0gjeYmyFPoD+dSWaIYBN8qRt0YbZY/7ylWsdO
	wWdxR3Qr8LNtrvFJscZ4beHVanHT/jGyYTpXm3zHrIsvL1C6NKVKe8bTQvWc+gBc7x8b85
	h0a6wwsQ0IiXtWZ75kd/GDFvnJrPclQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745926; x=1790281926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fgKTaT7jj0zRx6jbQ7DJOMsaZramokk9q66dhz8aLl4=;
  b=E7SxPV5TunVCqaEX9aCgd4u322DBN6hu4lbYh24IbL3H8ite96s231EZ
   fVHpw2EsE1z1oXSqUb3wsmKsxxqh+jdfh5MyyP+nwBuYYFCrB8dN0wq1N
   5t3kEesSNLEBgt25ka6DybfUJ7g1v27EpXpd7GxxtkeDtO/s1JDeRwEBe
   uu5UtaixtsgQcKNZBveaKh0vjyEfTxcBekYHe9E9mn4+CIUCj2CTrG2qy
   HS4bd6TrOjEiY6bDgrxAqu9uceic+06hsgsW0KN4WvY4rO6UROz4tg5Vl
   X8DFqbn0JJfQWl6E9XSaBN5/xInLg4AL1JU2m+4C3VgYQwbdeREAaa3yJ
   w==;
X-CSE-ConnectionGUID: 2CEhoLgVTqullHJPeNHiCg==
X-CSE-MsgGUID: reczyUXmQ7qpBKCYdBCVRg==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2531827"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:32:05 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:13400]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id fcd5402e-3c7b-443d-a8ef-25b2e4a26559; Wed, 24 Sep 2025 20:32:04 +0000 (UTC)
X-Farcaster-Flow-ID: fcd5402e-3c7b-443d-a8ef-25b2e4a26559
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:32:01 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:31:26 +0000
From: Eliav Farber <farbere@amazon.com>
To: <linux@armlinux.org.uk>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>,
	<mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>,
	<harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>,
	<dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>,
	<snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peppe.cavallaro@st.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>,
	<pmladek@suse.com>, <senozhatsky@chromium.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<minchan@kernel.org>, <ngupta@vflare.org>, <akpm@linux-foundation.org>,
	<yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>,
	<kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>,
	<ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>,
	<song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>,
	<kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
	<jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>,
	<wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>,
	<sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<stable@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH 12/19 v6.1.y] minmax: fix up min3() and max3() too
Date: Wed, 24 Sep 2025 20:23:13 +0000
Message-ID: <20250924202320.32333-13-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: yjiyhzrponzbcktxn5z67xrtiyw48pa7
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C237180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1758745926-202929
X-HE-Meta: U2FsdGVkX18Waqd3/VnRX/l4WD5cK0nCI0WNzQOQRB7yKrfvC/P5E14cEsOtdJimSf2wQp0iigO4qgsJY8HOZz5S5FfbO3kjy1p7q9pa9kZQs0X1H5B5AcPNGEtJRua8LUAjB5djd1KCKqzrUDXQ62PFgXGhuo8KhPy7O+MxelLLRT+B3gyGhtNQk/3JJYa7SA6ptNiwQSDkPqDvckz5QLyY2NPH2XXJoyFZ55FiboHXVEq6wTGCns5Rit2s3lN6cADmaE7kfJInVzGOWuqvunClPgTtiRyQHhc8ZMA1xtNj8dAxyynI4vRIOMv4IMrPW4CAW6/4GkD62+cp3WDZlPACtDNbXTqmQsySif7jMgXZ3+4hs1Dte8uy0pb6YFK9vDnLc6vSVu80zneQmndBBN4wPp6JZUd2NPN+brp6Ul0GOY+mTBdFqQep3rzNmypF4hPteVEkjw+K0zuobbIdBxXjqhjgobDuMJTRSQghkqRAOtwFFdgBSXKop0mcKbe7jTA1WrItcaxYB+PhYjXn7emmYla3o2KFluRUIjQnJwu0GZakQX8JpwLUYhL4B/+0nP+j2Kt4eUpkK7kMMj+jFrDrwu/bufcgEZ3Z9aaRpcV1/TsdtVVSYQAQ68sJjQ9kcojMcaUss+/p3QtCVdaU8tzM9zrPln/9iuIlPP4PNMDWF5DukFcO0E9zmQWvKScuJVMFTtf+DWJTb9oGxqf+Gb4Y9p5z7AtnWApCnGVxHDf7a+eG34nxZ1tCt2lAw1TgloE6GcNjz/4PjtbmpSEGohu0jlwNQHcoTrmMBP+/ow3rGorm7jWzg30X8OTGPFKiulHBVJP4SI6L5q78sJxFb7TVaDaoEk7OEDha4fmG8k97iTKDJ+m/EUjXuMyAJCg9BRhpxhUyjIhdtPNVOJTum6XfKeWqSQzB6tnHuUBZEC/R1K2vX4cK2IoRnOx/PYgny+9exNBdu6zWcobDMOv
 KswQfUlj
 xsgGBw/QkZA2dTrjbzUOzCdmY3MU3trzfabbG2JTkjvCSj7jJcjvgCLx+ZpkH0a8TCyWMDaSb69El3UcFvwavocxWUzyx4/+a/2hHZLJmo4x8GpKEass/8NTO7DGSlog0sqv+iGdf9sDb0J7qYnOVie69hWyNvYI2uJ7OL5Fklri4chq+HOjGGyaDuL9pj2vi9ZskEnvkkOaE/pfBCE3Z/3h4XExe9aruxPyzwaXUljHnRDjVZFjvx0LbJwuRVMCW69A5/CtM4nOXwIsY0CwLOI2IMwmmdHTiPdofubgmS1GCpc+RiokHjGAwn1vlmBW9ITTs9nX8IRmNTuejNv2DSuAjzSAgmIWSs2PHK27TXl2fjE7gC5v8yyAkTvo/GFtE1U0DvHCp4XL5f/9NrN4oHpYdFt43zmMZXhnce5DXMlXWWuhYSRg35RjJujP8sURbqOv859Pgjhz/lD7R+GriR3rS1SKmBnqCuJlW5/qSkVqDBZ6xxOXJd36jnG33AYwFJj1uKmdXe7u+c2Swa1BwaB3rJcEf1gqI1gOQYfOU+ihUBm8NxPmsgjIrWRL2fjy00O0kXXcoJVHjZt21LTJm5S9qzv4ikvUp2WiShplxWEjbRRaxhhgcTMq0jc5B06ndcTbicKnF0JrGDDfrLCR11hfxUcY8IwyRkxymvSwg2aFDqrwIZtb1V7oVyIkSbro4rb4MsikQIMjIhnRckVqnsKW3VFDoDcO3K8p5LKxh03zYo4JPZht8ME3g3b6Ej8EcYlOu0nWAnNfk3mtdlhDNKQwT0Mnul8wVMJl4ws47JvgNgYXCtqofl1LM7tBuo4NhSfq9/ENbcnNygcu+jNoHQfsl8SvqC9TaYH0JgdbCAkl6R2NfGrIK1IwljnKd3Qr2/xcSR71wleu2KEVkvzOXH3sbGPGyZelIFdMNefGSzPkabCo6hSnTqxHgCgdSpDEhwIlqh5Ge+6/0Fswi3G0Z+Wd0aYPT
 iQeu2Sy6
 yjRDdPSyPlh1OP2m69u00WBO/bP/QbimfKU03wNeO/BYCbqN7sf/0zf5EfIDST73d/9WtoSQZnPOe7fRugJjwES+us+cWCLredRhlfygEJhh5eT40IQsa5qrtHmSvsPkTjUklldsx8V2nwqXcTMz+tdOELPQwo9VH00MbJe1+WYPxhC9ZLSdS6abn8PuDrwh45yzm5tb9bsvxY9XJZjfK70dDAu7lVm5GOKtxO1HXUMmqUYdw+s/rUOhbggpBq4MpSZflJQGEUrdo5r2Ohv2J/zP9FfC4UYUj6tezLTdhOuLSaeUEvfpHxFmx8uVNfgBh940FEpAh3IJgkAo8T3xrgxFK6GjI6P8I0NCU7gytM7NEY+DHMZ/zyU/Kv8Q+k7l8BUQtWQvNG3PyKNa1ga4sBf6jV3aEFZ/h8G1m1cNX2kADQKQxK61oCqjzdhg0F6q6YE7ijKk3Z8oLl/P4qIOMGxJtyrVIcwN9d/yhobqQfv2BrTW05TMYHEstvhinebo1okna3TsFlBWsIt/15PLQgBh+ipKVcVR5E91KuTecydAwlU4EYeefiYbvKeTHYiUhm206QHsoiMGOwUR2+R8g6cvLV31bcA4hx/7s541upjtH4JYh0W4JbF0yLytYBRKkH1Z6W3aFGa8y88Sc7lNvYn51769ubNNTN8w6aDK0SpxXxvPLovjVzGqYiM50VjKgOQZBkvF56k1zLMEj7v05aNZzb6lNfYGjp9rEuH7w7tEUwBvsLtg0stHQ1K+KMGMxULgNo7bprN5iieblTSfsxCILWLgnYCogA7qYVGdmSdCnH8r+v3NIYVFTW3eDnMlU2hbxiRUZZyN92GlDJDNO6cl2PYTmfyWQDV+pKAsowQ50ESWq31uCf/rgTNQXGGk+YNxIO0RRcDSCAwTbOXGA0xXkFJppaqYGPLDhsjY+FcBB7UgqNKwjjAYTwzgB+kpVHS7Rp5HlOnynbQuWOdbL7IFTMDUq
 jEG1Q43n
 p0e138p/3g1Bii3lJDLYVxrp6qKzcQGSCTb1orKP80xOHxkHnn1hqkF6Ljn5IqVwFjl3VX2R+w0ZroL+tz5u9xBl114fUUveRJgB0hOxR6SgrdQXO9mnhVFLF9bUH685jLC8jDHcCLkum4PxaXEYzZY7FPI/8iQdOGSpUQPBWgBaijtU+i4GWfMpL4rZ8iM8+lrwmJYhhLx0dEYQA30lNHPMlBHWF5JwQ5e4GQso2OCsFvUaTZLr/Q7sqqr/V9W4kcSG7viNHep8hLSNgoUZbhPFuImL2tZnYLsvEJ4TsAY5t8Nlp6NIQit0Q9HGTK5qYN72DU71JpgOvgaG1y2CQXccb22ij4JIF0RniPd9IpeluaFDlE2YAI0aMhpiaLhaEcGqFpGJ7eRJFoVPNVCzSTXq5xzMKfdq7n/A7Xs03CvMe5XpI+zMOc5CY5JTkfHo5aR3LasYFvJFF3tN/fN/mwl2jaRvWkujL/b+uDdmoqjfajAuWahUr5YI9zL/AUN7Bgw2NdX8DZEru6cWfFjWc3KO3Fk54i0TexLQGpqy8Norv1tPeaY7wSF2JVEbMmFuaKqcrUprE8BXEmBdtNbYVS3loQS5UoWxHAxYhhNRhPo6FeAZsyw/9URzZlkFIFduetMdETGz56OPA7qFiVifN2356706g2unZAYEW7kYLNOrCu+XGLw3pA7Cm7QPTbXwqvc/341vEvfBhrK1pzeUb8uYkkAAAQMUluTO3kUPwxe2SE8ayE+6gr1tHI/qdA3XFZ9qqnsFXGeqt0lcGKsBlQNNtWzeWRaJLvPPqUyZSQUzd3Y3hIJ4/Jp0R8myv7zcwT5pMFR95xC38KvlOTn5pwdoOOIlJ9QGRDl2yt4JjIW3i6WtwsjvzI3kShnBJa4sJAY0hr3MRDIJRIUtJXJ9dBoF13jJmk3vKlHROzhi2GDDSH5cgspGaG1MD3L2qxHbqmPvYfwLVkZKgSVggxMMWbNbN4Nyd
 jmqHNEzT
 1LswHrRNlEYDPXADSwL3lkw/7/7hWrT8ryjHadksqNpGqnDp/IH5xNmXKg9rU4FHjAxdY+8NzrAH2hJVBT9/0nrf/lIsm1XOTpaq5mSqJ1ZNRQ5UP8IouVRhkEL37B/ndcwsVYnEa0oJKHj1sQP9cH0pW2bPj1R16dHbDHweONZrRynwFZVHNAw5tYUU4/i0JZaVKldUvUUb+3mmZoNzPsK+Gc7HIczCT5uvjEbvsguC0t/cBDg4QLhO4PyYR1nRqANXBzgghd1e4uOjKagCQbG9Ued4o82dRyBWcKdJRBdORn4lpjXBkfp86eUSDWmEkbP2CdYJp5XmgZawdKqR9T9vkz+Qn0BQ1JQOen326rtlcTod+dgoOIBe5i5BCVFSVM3gzZBSelfeBa67GKdg7Kj03kGb9ENGEeBV0w8Ak+3UA9UXzzkg9iIldfVPVX2AClDE/og+0WTsDhKZ0wYXKqMDbA919a7fTYpHx8ueCffX2J4yuInw0UsYR07i+AOjUEDo7QZBaC/fFIPMe2QgLz+eQx6qanwPRa2VeOAVF9GlElSTFlQj6V/3usaW8gSawLZ5Em+DhClvD3HQ+CuIYW8ZAV8Rlbin027K1Gx8FCHQSF999AcMZ1vtHqL5AmgpH5gDsm/+XzhFWtgyNNPMB5XHnXCwtoMCxPKAlzS9EFB5sYZbTRIl3x/qL+Qbc7/OjOVX59+blfJFizChjnMKmunNnbEMA6jFjn9aHqsVqOCIqp4GUU+xM+0gEoK29xrZ7xkbc6TghROtlp1JO1zIumVWe+rM5tYpUEQOSZp8VkjBqFNu4l1b0vGhptQyQO7z+IjNlxEu6OXXdcz7nlx8hnhE4vCB8dVe4QrEqkMfn0ui3vqlTF3CCuDyTufxjrp3MR/dt8Te8H6ddXETPiVSg+0lANirus2zrPPVQDnSFabVmPB+Twp4yhyegBcXsXNMUx/4+j2Pe/OLGKylUDTGSWtQbNAcu
 hna/x3CG
 X2RRD0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 21b136cc63d2a9ddd60d4699552b69c214b32964 ]

David Laight pointed out that we should deal with the min3() and max3()
mess too, which still does excessive expansion.

And our current macros are actually rather broken.

In particular, the macros did this:

  #define min3(x, y, z) min((typeof(x))min(x, y), z)
  #define max3(x, y, z) max((typeof(x))max(x, y), z)

and that not only is a nested expansion of possibly very complex
arguments with all that involves, the typing with that "typeof()" cast
is completely wrong.

For example, imagine what happens in max3() if 'x' happens to be a
'unsigned char', but 'y' and 'z' are 'unsigned long'.  The types are
compatible, and there's no warning - but the result is just random
garbage.

No, I don't think we've ever hit that issue in practice, but since we
now have sane infrastructure for doing this right, let's just use it.
It fixes any excessive expansion, and also avoids these kinds of broken
type issues.

Requested-by: David Laight <David.Laight@aculab.com>
Acked-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index 41da6f85a407..98008dd92153 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -152,13 +152,20 @@
 #define umax(x, y)	\
 	__careful_cmp(max, (x) + 0u + 0ul + 0ull, (y) + 0u + 0ul + 0ull)
 
+#define __careful_op3(op, x, y, z, ux, uy, uz) ({			\
+	__auto_type ux = (x); __auto_type uy = (y);__auto_type uz = (z);\
+	BUILD_BUG_ON_MSG(!__types_ok3(x,y,z,ux,uy,uz),			\
+		#op"3("#x", "#y", "#z") signedness error");		\
+	__cmp(op, ux, __cmp(op, uy, uz)); })
+
 /**
  * min3 - return minimum of three values
  * @x: first value
  * @y: second value
  * @z: third value
  */
-#define min3(x, y, z) min((typeof(x))min(x, y), z)
+#define min3(x, y, z) \
+	__careful_op3(min, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * max3 - return maximum of three values
@@ -166,7 +173,8 @@
  * @y: second value
  * @z: third value
  */
-#define max3(x, y, z) max((typeof(x))max(x, y), z)
+#define max3(x, y, z) \
+	__careful_op3(max, x, y, z, __UNIQUE_ID(x_), __UNIQUE_ID(y_), __UNIQUE_ID(z_))
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
-- 
2.47.3


