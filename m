Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6EECAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 20:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86EF48E0008; Wed, 24 Sep 2025 16:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846B28E0001; Wed, 24 Sep 2025 16:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CBE8E0008; Wed, 24 Sep 2025 16:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 659368E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:25:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5D0E1D7ACD
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:25:25 +0000 (UTC)
X-FDA: 83925273810.28.F5BB3C7
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8CB9F80009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:25:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XXY6Ppq1;
	spf=pass (imf02.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758745523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
	b=KnMxA3jr3OXMEfK8kyQrHsndGCCsS/OTkdrsk240MYBxK9+Tbd6wnVIps590BP8RMzWCd6
	CYWSsbK/eQTlFR5UdZG7xLQIyuWPEpO6vSPwXCKyVOGeRh8knwK+9AgNTzZMODTDW8+unO
	MztBLKWXPH9lBTk9QbCCUdOcxXYqrDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758745523; a=rsa-sha256;
	cv=none;
	b=y3N1m+85axQ5PLpfX5XJDn1bOH2xiuWtOPSAf5SiFN37Gg7jmPxXKd8vRIeGwYls16Md+h
	mSrSuvpNdp7sqQlWi8A6Nx0vh8EpL9kAR7a99mm0cx8U74Lec1botP5HFxxY93N3ZUyR4U
	ZsCRWphdVOgqOz33EnWYaBA02TInYL0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=XXY6Ppq1;
	spf=pass (imf02.hostedemail.com: domain of "prvs=3555e8f33=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=3555e8f33=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758745523; x=1790281523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CCU0o8wSJQJX56U4+pnGKdTopFZ/0WcuCtYzGhhpTrQ=;
  b=XXY6Ppq1R6C8QB2yMsuG5I+Xm/vXqNYhHZXIRBFye8NPuFui1A63BsdI
   rhqJ2zNyIAkdT3f8ZIzd6c/rpH5MXd7MsKqAZ3r2+mMxN2tKXK7C6MnaG
   JUe72N2gIG+rbIMe6Hg402ttWYM1s8yMJDIuRaxEEUD5UJpilN0UDeJ7j
   deGUVXJ639MEjeZQ0UB6/aPcgfdWDWTzzW3giCYLsSnE/4w0UHep9jYgg
   lgoWwA6nCVE2A1MIw6XxatMLMCSAmft09Azkpjt7K8JH5eLkE/qY8kxIi
   o1uJZ4JG0YDAfKy6EybqQn2TGclVfSBWRFwwkQiMF4Jqjh18evKDxZEwr
   A==;
X-CSE-ConnectionGUID: a1kayFJLT9+jylO1cmhIAQ==
X-CSE-MsgGUID: /W5k3uF9SZ+FoDr6+hyF9A==
X-IronPort-AV: E=Sophos;i="6.18,291,1751241600"; 
   d="scan'208";a="2525115"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 20:25:20 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:17421]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.230:2525] with esmtp (Farcaster)
 id a321c2e3-9dbb-42fe-8549-d22fc4426b03; Wed, 24 Sep 2025 20:25:20 +0000 (UTC)
X-Farcaster-Flow-ID: a321c2e3-9dbb-42fe-8549-d22fc4426b03
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 20:25:09 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 24 Sep 2025
 20:24:34 +0000
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
CC: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy
	<christophe.leroy@csgroup.eu>
Subject: [PATCH 02/19 v6.1.y] minmax: Introduce {min,max}_array()
Date: Wed, 24 Sep 2025 20:23:03 +0000
Message-ID: <20250924202320.32333-3-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250924202320.32333-1-farbere@amazon.com>
References: <20250924202320.32333-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 8CB9F80009
X-Stat-Signature: fyd5itgxsn5tba8ifiuquhehdzhpijac
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758745523-976752
X-HE-Meta: U2FsdGVkX1808mjJFq1qzU/ShVPxzzhx9B/GBTaT9VXJA+EoNI1TP1wmOLSP9mvzqN5EAAr0mW4/CLIjZ07uTTaM1mWyWQm6Ln7cvtGm7KWhEihllQMp1WsJc43qSOD7Z35WezInMQ2aQRJvGJ2FzfUfebEZZN5ou15P6/VK6fRGZYo9GzJ1X0yvE3tHp8sWuVDro7cvM5kf1QFcEeye6Es68sEwGdHDnzXjUk1bmgEgZ7cECCRA+yvtCpxrI5pG8CsgfNRD9SXyMVRjOMjmsT5mvwC7B20nPTKD7Ruweg39vS4SeYEYqFYr1qrT0XWyp0A+j2JUGvlrnBWQQtlwXgREJRaftpzVvikOnmZhU0nJ2t2vuFS9LRe8A4DUXpOK/jrB9+BAB4B81KjtPWPzPwAXcMMGdkJUs6pXjAZ5fISIjfXZJ6nQBWwi24tyK8JiZIjEQ/BmX1J4bQINPknHwWlLmp4zO1qG/6U45RbKXkLKOzrLkvGg5LCWeTnw1bEHAGzzoZ+OEINGX6T9NZ1hOKFCHzDqVE7xjf6ZvAhMOr9marZngSJlP8h6/TdA4JNa3xt2GlXDIqv4rYKxUfftiTBqCFU0TOAscjdn+5R+t9VUNHt5T4ibot7EcHswl7FlR6xDaAj/P9X1+/gpZfNtUbDKh6vqZWDKdfUjGALR3omOPtTbt0DK4F+7EOuWLE+pBD/389kfS2Xb8n2j0h5Xkh1KsFSz/UbEmBjQYYbeDdCtk02Z2gpuoSGMb7o8BiZAanW56/EK4BxBiPhL74J0D7XEitYDBYgIM2Ziwx+ZsTwvKEoXbMx0B/pNbphrMUlU8IUl62BBOEA8RNeusSH32tKn/Y0I8LH1gn1yeQHk4aTUAdVRQQ3xOVNXX7uKwXtS5X191fDvcXdVSheX6UOP+muw4CwhztKiZGfvcOGFVuj9m2JL0fGwE0IT23LlVg7yMQpyjpte6pIVkpnqCyP
 n6NhFDj5
 R2OlVDzfW2hfZnQcUQqXidZFBmSKNS9q4NCRGJ+0df+idLdKmT9Smef1LozS7XQ776ROJ9mt18WeduXtIie0SlVuHtakZxpHF4nsksD9d88Os/I9kjngysDDLQPgVuLpEJDwvM6aJhhvmZBDxozxOF+6Lh+j9eeSaxUYgZmlbKeZolQF7jzEBQohFxeDT5nO7skn4EX5F2SkXupKeOfIhCeTuFjUoYT5oAe2kf5RCLM/aM4SLjkcg60UHvwcT8anu+1Nxhyxlv3k6U56iXZ+RQtqOGORVlG6gRH7jIwG1b68fjfKY11dUBkkyzCqtmtT+J+WVkF2TlIfLK/78KnHFhXeYNUvm5qEu8qOFsrMXMwJJoJJYSD6skmztLrZxf8LOURjHlYQtnCj0PhiEobO4FEnCmiLhGFHFDR9j4U9mxBpMMezdr7TkF4iE90PEt3jjeFG6m3qSuo2kjTq82d2jS+RSG7JcoBzdmlK8IubhbCmEbBprMXXHu3KiqCoh9UtYOnk82Lvgzh+D8o7d+cFpwRk+qNyYw8dBizKFuqqKSVcgMrsrw/vEWnqWcULpTeUAasV0xtQ2sJc5QyMwS7dwEhdvhAj1BofWgBZrr15XNEGuWn7XgPDgTFQMkHoZwbXzCLbP9GTMkyj8dTT5sKjfOpEMW+WPptpaD67UIL9mtHQCRQe8VKF/4nt4zmEwb2Xb4l4t5MdBF6KNz+aA46R6GkXDNkNcFnFG92VMP+g7rET0xc9/cE6FC29mK97pa1Tg1N5MISfsVmGGntxPnefWqKL2FpVXBUKWeJFZekGclL9JzOSLnK9h/jGd51KWawH54AO2P2Ye7p/uwK73FWoLXYKsvdw/KmIn9Y5+HZ26xaojHQ+sqAyong4BQy0mM+WIAkHAQgbZwCLVBy71wqlc2OQVzTaG8ymCtVdx+C13WaMj3iDag2b0ePzP3As7dfu5Oe8lKyRovU+UO3Bw1ObjLC6xLHnP
 S+Er3w5P
 /1RnKEbPGAAYQQDdrQYOfTNr2iuBVX+NtGqw5yjt961dX7/CWt+j8Is6xwwILzbRAZd+7r7iDROsT7uZR3sgPYCDNh4Zl5po4SxfQm0ShZnrfstQ8n+PNtX4aePKoQ1IaGCWJqJ/CQ7vdSH0z6tatxdo1x1LZJ9D+8uNyCtqtb4HGxLlUkgy6FmLxGX3BBpdoEjfVRVOcKsYpOxcOD2LfCw3BE0o3Bde8RvVi5auuJA0+qn8nSNgG0u6xKQkcmsBXU78cS2MjY62xT/aXp5o5KaauJFmX7xI4OKBLXYqMCBmU1FhlQYcoqby1cQ7BJHJiumeVl0tiwL1tWxFzlC7Fy+IqyqWedpTTAB6SUAZksHNUNHME+wZ7A8/pONm9D9WTaKjjle8DUuzg02xVvzIwyByr0vEED64pzfZ0TiGjwzY+/c7F5N45cAHK50b4jWzeLv9O6FbMN4GNc6tOfqYlUlsKhcVdug0SRKkLzbfZhLItALxd6aldITBYOqTkSeALSUi1482/CFfF5OxXFa1KQ4xB8mgRQJv1qUbYPpwV2HTL2DNzpRO33jDwIPuemqbATVLFOUQVF1nZde49y1wM+2B0oAS3dq3uKB1g6gsRldhfTAx+lR1TsV1nwBrch4hbhF6G0poQ0+LMNbmiJNcOOU9ot0sl/xhHt2rxt2Uwhc9v8RwNm8MfpdSqHAeDylpucGi30ewQkf5r8Z0MYQnlCGxCFbGL2qtP5rtn5A62mOcEN2a05LaE8eJVj6kXnS5El5HhhjnkdWoIN0JQrlT5IMUXdCRmQTExoyg87Lj2wPuRrUs0yH2k0aoJRuCBRUPHh2hTmpb7R35WIuw7De6jKFFvHXa65s1iiqA0/mdwOxf4BMKvMBfS5zK8vhrBaRGq/01WXxr7pl7YCDa31QcWRLSFdqOliNxrNGrSwy30Mz25QAq5QVySn3FJXjVytRoDJhjmiGroZVNU+r9BVSxXvc5/OoWR
 Y66V6MMF
 1+QA4gQKK9ZepAgkNBCG3MncrDTq9nUyorH6xIg7Et0W7sPfnOBNOJMMy+vuE5JcfKHuuwTSnHTs0/MPBU29KZ+md034+TMUZlZJloQxqKUznaIeIELE/ZcJncZhocN/XYT8q8efXDNAa73fRc8ggzBjrVaSoMp1k2QyWclWP/DiMbn3mo6dorxx4z6uo/HkkiPV7mu/+xE2FNxXcrBjMsOJBgEh7p3lo/3pHvOA5P1TuxKRpejaSiPrfjyGIF91hLoB+egvzGlKvX0v3+a9+3P34/XSgX+HiHA3Vke1N08RvZQPwaL+PWVz6k5yCe+vJKnPqaiuq1Q7AyZYq9bQkaByz2eAGiP2jCs/6fHmqX2fFmOvKEhBBjGqo8YJfTXwDTr1IUuYwG5tg4YNvXz93BqypZ2sedG0mOwyFEgm6MlGwmyzXpehAx3nJh63nRgAKia/MRXGr59Slh6J5TTtI4Ak0qCNA2uoxqitIpZgTxOOaXlLhlPL82EOpbmiUQ342sjZstXOMJq2yj1I0n7k2qryV4E8yC0N4l09R/xmGSFb1/N740ni5GwoGxDcBw3bCZOnYOG4nyEiPCUn1uzUh7riypxqIpxgIJOgVtYYKYPO5hAJNoRB6DFSJcpWFF3wpGXn6PlxEBv6aQchTpQmdJPsmKlONUkieYaUbsGyf/Mn3mF+8tojNUczS8V1+o/qVUqOziqNsYg2JJO6IvBsDPBtvFAcjesj5Qor9u56JaL6idSsNXoraGQmQun91jHwQ2VWvoW6rumX23wLAvan9/Yu360ToGEXFvp8PfEiDJlUvryLpv6DL/f+DyqMrCDG7r1jCDZUrDRKW/FIG6pSvF+HdnAmq0ZJuYhg9AmMa/bAAbG7TSj0/p7x1omktt84rAOVZHQHMEv69TgGHxFeWpmvzGEBJs6v9iEb8YZqicJWucx1vXSTlFvffPebaoJWsEuxyJtjY55t0LfmnmZRpZgZcmaPG
 U2RFydKD
 bnNbzHerMjt0NzdZxE7lJXQ3B1+aCZgJ6dqaUoTGytrdr9RXWPamUcVD99qFYyiHHZj3bRy7kCVeUBRa9TSczwhqAWXhD4ruNoXQfmOfgmJQJwg4jU9E7uF+8V6n4/hXlZAhOjUBNeL64w1YaEMHMjApUhrwM3P8L/V+DxEJPs/Hz8+TC6COVUEO4zPUo4IFk8FIjJOZSVviVz2AnjbNLBAYZKiLHmfun6MUNNESDvXCG3ghlWiyiDj5H0rYxWPuo78oBA4O+/v4ccxjrw5xN6aCyXWd9/MQK47BQhJvzcevmxl6eVzAYf1eCQVa+5N22BRVGdq7l2HYXPs/6uRP6LlW81lHlVdZ9bUGr5/CHzST4h3oZn22IwGlMGzzhY668EscwEP6/a8h0MoOUvzUQeEwAhXh1Ytlotx1O+J+3pr9V5l0gImq0TKybGs+nPd2+QYgjwS2ZQ1cWucREG+LNcyELufwaos87POyTE2CScqcNzvKUNrliEyZkoAQ4ab4dG8GDTtoG2LXI5PoPk3tMOmU0m5eInuxOVcVNTZLqoAG8zhSOBaGvAsAygZvuYwpYuDpqpq1y1IuUKowkBpvgsYTZdbOFNro2XT8qyIttsW8UTdgmu+wZtKG1Fek3VbuY3uIhiNNglfBcO5mA2WtBtOve3Rj5xLh2z0itermVqjt7TGzxKGbZMJ8ihBVW0GnrmimmXH/mGQbHslHKhJEUfNtrS4JltRezKFoqUD53LaDeqNFFGjVrhA/n+6yxEEjL/Pb50X8C75TkfWejsyqp9I/4rvXWC3h7AUG4Ncmg9SulS6oh1NEUb4cdZrsZhkVGoMbsPzO4j2vEGZbtau/K24NjqsYaykPfMp/rPsYifszjJ8XEWMpG7+HtdRV60+Xfda8xiZRWbnLR7Kof0rbctfxl/nFkIi9zMEelTegKUp060qVg/XIOjelp8myYkPJ2zr5oBYs2N/pjVi/Mg3/XPhjBMnp4
 7/czZbbr
 cvrboGpRmDesrriYNwVdNdej9eYBs//ZEPWlh/B4Erl3FXD8d/okRT0QI4L5mLehguX1awZg5w4OTnr2l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit c952c748c7a983a8bda9112984e6f2c1f6e441a5 ]

Introduce min_array() (resp max_array()) in order to get the
minimal (resp maximum) of values present in an array.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/20230623085830.749991-8-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 64 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index d4bc394b449e..aac0b7d23768 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -168,6 +168,70 @@
  */
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
+/*
+ * Remove a const qualifier from integer types
+ * _Generic(foo, type-name: association, ..., default: association) performs a
+ * comparison against the foo type (not the qualified type).
+ * Do not use the const keyword in the type-name as it will not match the
+ * unqualified type of foo.
+ */
+#define __unconst_integer_type_cases(type)	\
+	unsigned type:  (unsigned type)0,	\
+	signed type:    (signed type)0
+
+#define __unconst_integer_typeof(x) typeof(			\
+	_Generic((x),						\
+		char: (char)0,					\
+		__unconst_integer_type_cases(char),		\
+		__unconst_integer_type_cases(short),		\
+		__unconst_integer_type_cases(int),		\
+		__unconst_integer_type_cases(long),		\
+		__unconst_integer_type_cases(long long),	\
+		default: (x)))
+
+/*
+ * Do not check the array parameter using __must_be_array().
+ * In the following legit use-case where the "array" passed is a simple pointer,
+ * __must_be_array() will return a failure.
+ * --- 8< ---
+ * int *buff
+ * ...
+ * min = min_array(buff, nb_items);
+ * --- 8< ---
+ *
+ * The first typeof(&(array)[0]) is needed in order to support arrays of both
+ * 'int *buff' and 'int buff[N]' types.
+ *
+ * The array can be an array of const items.
+ * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * to discard the const qualifier for the __element variable.
+ */
+#define __minmax_array(op, array, len) ({				\
+	typeof(&(array)[0]) __array = (array);				\
+	typeof(len) __len = (len);					\
+	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	while (__len--)							\
+		__element = op(__element, __array[__len]);		\
+	__element; })
+
+/**
+ * min_array - return minimum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define min_array(array, len) __minmax_array(min, array, len)
+
+/**
+ * max_array - return maximum of values present in an array
+ * @array: array
+ * @len: array length
+ *
+ * Note that @len must not be zero (empty array).
+ */
+#define max_array(array, len) __minmax_array(max, array, len)
+
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
-- 
2.47.3


