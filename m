Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA11CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C41808E0066; Fri, 17 Oct 2025 05:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2A38E0016; Fri, 17 Oct 2025 05:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABA4C8E0066; Fri, 17 Oct 2025 05:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93A678E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:10:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E6D6BA4FE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:10:24 +0000 (UTC)
X-FDA: 84007035168.08.6161312
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5BC7E1C000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:10:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MYwnXBSW;
	spf=pass (imf21.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760692222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
	b=QcbfMOBxh+VQX/n+I4RKGiKp1TBwHuBwBhsVzc8ZibtYHZTmJQqCC9vFGSqvHvc56rqvcq
	u8A8rpohzNIDh2L5wDgQpFR3MQFcC2Slys+xEVuQ2UU68PmJxzdXKVFIe5eywQu1FTYXpq
	Fd41AFQ0jJiBGwIzCYmaiD4IVQM8sNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760692222; a=rsa-sha256;
	cv=none;
	b=yfOVKuaN+cBoU/ZDQfOXXg+uTIhuEDmf0HeU5rR8YoIBfeS52nvm1bY+tLTkfzfJ7SBxsL
	Mbn11Cgy+HViHaMOD8dCvu3x9pdv8tMerjTHYE5ppDRVGpBw7jBqkqwwkvwiinqTxLRq++
	nGwd8XD71ki+uj5epVyXQwgnJZYSg4Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MYwnXBSW;
	spf=pass (imf21.hostedemail.com: domain of "prvs=378230090=farbere@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=378230090=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1760692222; x=1792228222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIzXOOEvZKeS6UuNgkU2k1mesw4I+NOSJCqENQl3gzM=;
  b=MYwnXBSWpA80QYP1gstPZmIKyKrKndA+Td3uTF2+tCmy0DOnWzmd+rB1
   +NdhlK8sVPJL7U3FEy8vFi3wP7VzyDrEfMjhBxArNBS4v/x3ANkreoPhS
   H6xLyxXBds8Fx1eRo6HecEqD1VGpw9+fOgY8bZp+3NiSoOq80CELYD7OM
   meiYH5H0qgmFoZW0QqnZjOWE1ZZpgY/FyQdDnDoKSM8pRuqR6fYuo1cSn
   xDXykY4h/yxS6KbpoUKvRVwaJDa0EHXzQ4+vflTEjkPASeRSQr2FZ68R0
   JUF2fd+WeP/94h2e1Gwafe3XXpCHh5D46ln4v/WwgJexIhzheF2t7+3Sm
   Q==;
X-CSE-ConnectionGUID: wVS5NQnOQyWS2xJSBs8Cpg==
X-CSE-MsgGUID: tdHvAQuXRWet7li7oWOcEA==
X-IronPort-AV: E=Sophos;i="6.19,236,1754956800"; 
   d="scan'208";a="5070364"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 09:10:21 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:17257]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.16.196:2525] with esmtp (Farcaster)
 id 4bb96070-0aef-42c9-b96f-06f541250169; Fri, 17 Oct 2025 09:10:21 +0000 (UTC)
X-Farcaster-Flow-ID: 4bb96070-0aef-42c9-b96f-06f541250169
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 17 Oct 2025 09:10:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 17 Oct 2025
 09:10:05 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<linux@armlinux.org.uk>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>,
	<james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>,
	<mihail.atanassov@arm.com>, <brian.starkey@arm.com>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <fery@cypress.com>,
	<dmitry.torokhov@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
	<joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <malattia@linux.it>,
	<hdegoede@redhat.com>, <mgross@linux.intel.com>, <intel-linux-scu@intel.com>,
	<artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <clm@fb.com>,
	<josef@toxicpanda.com>, <dsterba@suse.com>, <xiang@kernel.org>,
	<chao@kernel.org>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<sergey.senozhatsky@gmail.com>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <kuznet@ms2.inr.ac.ru>,
	<yoshfuji@linux-ipv6.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<ruanjinjie@huawei.com>, <David.Laight@ACULAB.COM>,
	<herve.codina@bootlin.com>, <Jason@zx2c4.com>, <keescook@chromium.org>,
	<kbusch@kernel.org>, <nathan@kernel.org>, <bvanassche@acm.org>,
	<ndesaulniers@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>,
	<linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>,
	<freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>,
	<linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-ext4@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<tipc-discussion@lists.sourceforge.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v2 15/27 5.10.y] minmax: simplify and clarify min_t()/max_t() implementation
Date: Fri, 17 Oct 2025 09:05:07 +0000
Message-ID: <20251017090519.46992-16-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017090519.46992-1-farbere@amazon.com>
References: <20251017090519.46992-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D037UWB003.ant.amazon.com (10.13.138.115) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Stat-Signature: b1ig797gx463cax4zbawtyhwfdtep1yu
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BC7E1C000E
X-HE-Tag: 1760692222-784823
X-HE-Meta: U2FsdGVkX18kVMz9mLEQib4+BbI/YA50nlGGKrsvDLZGE/o7BUeC0ztxUATIyahGQ9SD4Kd4XLtpvHwmK1hxaQVIZX16CGIkeTFCII+XhBLFPt2BwxxS1I0jKkSFgkFoLiHJ9gsu/EdoV57sDRBCbXJl+IUq1pZA6JTFCIv5WuC3D9zGtFogjznPiDIYaVO8ipz2zTf35/n3uWINNZesihn4KKTAtrJaYhfUbvH0l5Oc2MradFnYUME28rJU05Tt0onv3FXG3r9iL++UfJfXSmfr8ACO/od5y2F2DACiEBL/PlcMh1TFOMMp9RjgISvhKMjrU7G0yHVicx7aCzevym9N9+qiFcS4+smYcvR5Nf1bbo2kQL9cUrn+9lqgoHLKgWzlFj7L1I1tkLwhVn28y6RaUU34R1G+8Spfc+Igxh97vYxOxBq0top5rYeL9VIMhYXc431vG7nNtnbLjmmH6VBozWrPCyauJTfp4Ly01QE7Wo5+J3R2ZwnIW9TZ25C7E/bQN9k9BAdaAz7TWmKNCzfsqvJz02XsL63Sn1h5dXjWQ1sJsHr7haaxaNpqAw74kmlh9arOAL3SnesGnvjsiXls70HYa6S6qLGZy3R4l/u+Ij26BwLWu22nMhQaBnwvzwCsRmu5lfXGYIH2ZwYgxiDlHxiVcfe7bJSqj/sWw6bqMueTMAHEl0CUdoA/9IpSnieNk2/H7aBUE+5O0OzMeFTix1IZUK4A/t1XddbgJKsROL6O9shy3oWc3EcUJ9WbUWJwLOFiIDSbyTjbARAwLmcB+nLmCDQgDOCiOLsc1ttFwcSwwe+ES5m/eir0zZgzFhIwuxOnEg9Kq3wShlRszyeEU5k/UzddPSMdjUg2xyubNQdkUSyCFqTc72ZeG1B7CMuXCH5lDh0uW3kOr4z5fmxNV1mAXta8iHnhqjly0mvnI2lmI68Iepn463lAEGBwsZ3AzVv7N5uQwEQ3FCL
 DvD/iMwU
 5ZIbwDnDQC3NEssqPdSrXIf5Il0jqmW1Bfv/Xbw1NUQB4iFRcuzeY3yErpIXClGdmf9woaDu3BIwELpOa8PSMMlFwDQFGtDcCWsTl1DCVi3VYW20x0Rq2My3bOOokmogMFck6sCs9uc3Xm97imFa8ng2QVgzbIU8TmjDzaooEUq1Bu8qZyydoN43cp56gXAqdqeISP/JaVgExWl/JrFbE1wIy3ddzeK56d/uPxYypeh+eko3VjiBp6045dmxYiyitgxJpmLI/i+dec7xY6TGizwZKV4yEsrzKaaqWgsPCxYgj6Yzoreh6pB+BX6Brl0E185BFe/it+YspnPbI8Ysme++jPHUlpY773DLtZiExsWUM8qJ3W7uBx8IR3wieNgVLE/qL5BwtlDTIJWzMsc2GhQxE8kc1QEmfzALQJdLNem1mfee3QvQ5DuY+ufdGaFBdc0QeIMrGY1+GWrAf+X8kZNYLOd+MSAv9+jTZCFvyT0lI6yh5dPlxO8FB9tFuxhUmeAno00GT6jzYQM6wGn4jBSx8bxDFSCg/NHx9Ed0swxtLeyRvaRQbapW6OIYwu/zdt4T0JGLcCUopI89DF1sUddABCwmu+3BPVfrSdQV/aODss2YHk/YX30iU6F72ecBrrS4fwAL9gSfU2ajhycUxSQslfv4TRnGLodSA6raW4UyP+yVDmYjIuS6GUx8mzAK9Q2VMvJ686ZsNYqycFzLmlU8AbgvXajCpQfNWMbIBMLvtWthkCJnsaZgBYVw5qQW5kVrwklQNgmlm/jeSPKHj+3TWPfMCo2777bFuwmbLIN0yJJ0JAQRyrLnko2Jr+zErXrgXVsF+yVjceWFBpapqOLLgFcW+KmR0p2WY4AzMCC+fnHiyVTl8GRk8YW91fHQxL4Y/ZVvB3DOw/7o3wbafDm2pOnKlVWFaLwqDee7MamDw6KuldNNRvh2IutV+9wqE2BkMJcgYGwJrFAs1g19AGvguichH
 6gEMglX7
 WjG1/8ASjFj1ySbWDvJX1w8y7Ei0b1e0/RSiKm9B3UWYqQsoJ40hFE9lzq38bXX1v8pOYELycV+95OtIbdb92zpMkQ9QLfrzy/ApBIiFHBX96gDdNUhzdpP9Y3vAwmOGK4UFij9b7gN+tefTGnA9YJZa61Z7byZfLdE35Kfmr3qpElr56xiK2cIMDdhp6Wp5dlymGAEhtYXpkx5qPIaVe6dQnsbx+B2HK2uA8j/02pG/qa76sEHCUnFizJVRGDqJIeI1VPYkW0fZ7oEN1E+kr+kpsSlp7UplAhPR5a0y4ODKRWFXJ4xGKh50lY3IGjdb8IbJFqXJtWNktXQDa5Fi9MZG+zW24A2zJv8EDFRxQmGw8iVGKXy1G2unWL3KyKa3NpAgJGk+pQ0c39klX7r/pI/5p7dWsv69CvZzlEQaV3w7u61r6Ih+Uk58QgM6TCKsu3HBUWbk5D/YqWK0IKtg8pmmrWTq0IVP0HSxTMac7Cdvj9CmLfSdTBWwvHlCVZIaZqJbG5VHqJrV4yqJDgLW0ZJL3Wq9+hYtYHSmUlREzISEd5FIf3jylWq6Bd92RsPWu3iQx0ag+CRN4K9k4LZ+MQ0ZIibMtZjsQVyzFsBlDVm08AYJQEVSd3WIKxLw+0iJwDUwxQCTofX3/Wr/bvZX9syjVajD4KAJExZg80DbXxoq3Ct8uT7u6nmzIDSwCeBKO8fgNtIkV7LwmXFSP/Y1k2IY6UOSPc7eHg+cm1Ok8gxo4hy5f9/PaORZI3HUQOGvTP+BRrTyyk8BXJ4lfsrh4IBcBrVro0gn6rpvkRcW0Wt4ZYgq/BvFZtbNKkAlqz42XWvNbJVsjJXlLCmh/Gw6VbJAVKxh2iv1egiCnNC2QAVMoPwt2HMMZ5+ONCaKPe+L57IYqmIextasuC7h/66ZX6F61Vtx9hMiGo5Jp7g12F8XQd37D7rh7aNmZVpJAhDS2N3AKwiS92vTkSwYDKmR4zg6+AKCu
 ZWCmTTqh
 x75c5Rkxnbw3d/2KAuiaIXcusKN2a7oCJWL/Qk88TdwtWMligBWbMmAIeybRX+cWWp7w8SFkXn/eV1/gba+rfz8otTeTFTrKrg8IRjdgZXkh6gImhZbJvQnlEbkhoip2DrGz3sMyVb56meAbbQuEYQ8Ah5UD2Msov2vAJw21mrvHkvqI2GLmgM3gx3P47/33zUBsH/5aGtlBceAc+G1YNomFgbDjVif0A9guicAUBRnL+cPzU4JEdDiT9Qak32PBL3T4FQkZo1Uy9lpzBwD42VYvvnJ9ugQ2h2cxWCigWFczokJSAuf4BgG/JMwc96Zl+imgnQIEzAiAO7SAAEY5Mb5DWaBu1NAd75XaX240VH9rE07vGGBPU8CGP+l42Fb0RflFeTqXsPJJctfc7qwZEBOm7PieXKcwD8Gi8Hk5szRTcNPDnQp36DadXDfBp69Cb6IsOubyVqyKv/LtawZ4yDriNDGiH3y23brsHL0+YsQ6cqQXKOtEIFdybvkQOoxECCBnjCgQgc4KWaVmYdW1IKemsHbNnfJYWZ1RQYEZ4Fx91NNyLxtGWxa0b6iuWC5zF7YIKd9mPV4L96UTedt61IXCc19aYrH2TFwHd6BhIrSl9FHMpR5gLsGP5XTrfSWjd1bkFP8z1cnDqpqY+Odq5e8SnZLQnuklT+SYYvEMXJUuA00IU1Zq+Vp7JyznLMIeEUZT3Q2TyksTpAOnaIAUFjc53A6UkbZGPjy0uiUlCHSgPYHZOMJVq0g57AKmr3n6Y/e+PP0QQuxbMOi0EhwmzZH7C8uIIIR34Jqtd1y0VwR/8rb0CXWPQv8F0CFAZpgiINL2beeGh0ZNF1L+dxvDq4pIJamKmFJP+d6tUkYGx8fUXQZfxXs35NhaCwXTQmKEPzspyALHdrdhn8pKTmRoBCWvjlMnl3pIIOCg0iSG5AGEQ+ASOIq/7Iwk2PMRMm/tTb+jDi2zgNodHHmHAe7WAC8Glmp+1
 ghJ+hGxR
 dz9JW9Fp4g9PBxyM9D/tBo36T/Cr3pO6zdSGtkOMyLsauSwl7XmIHTnJw8nhNhZyTKV8LFBnGZSQeycwDyF/3tz3E4K7JRxKOwbqehE3FbIRXNpnnC/9r+TrwPdk/AexEmm/YJvob2jjhi701KW78JxFEDdcFM1muPDUMgZ8yZS+JgmqYNNDjw7SOSJP9XpAyhMcvo0UsGI+xsU7dVGAni2qEH4B9fo86snlOT1HqKCMzkZiVKI/6S813r9whAZhTPSSGas6QtxwuRFa9VqLRnI6+P2UTeY664fBBI0iRF4Li+wGCzBB7J2s0DfXy33qBDlQd0qQVlZ0WSGDisntI+9Sc3gGAZMFrSvVHiN17RoOY191HIKYEqchaZYp1GReX/95RqW3rnD/lVl2uVuuF/bt2hVezKL/DPT3HEPEzzvt4l0SotF05ySPvG07yQbSThCsEbqXnxBRiFdxzpdqTRqAfY3YNYRucVs4I+VTLtvjQwbD7Bw2Nd405hhMSX+CboU11tQJYTa9Cs7DVzLLbyeMi2pEYpP/bWzmKgKv++oyzfIum1yNG0Oeq7BoOHpGqPHJI2AY2wb7sC4oZIpHzBNA9MgLYsTuYSdcDf474GlrwKn+26B0Gg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 017fa3e89187848fd056af757769c9e66ac3e93d ]

This simplifies the min_t() and max_t() macros by no longer making them
work in the context of a C constant expression.

That means that you can no longer use them for static initializers or
for array sizes in type definitions, but there were only a couple of
such uses, and all of them were converted (famous last words) to use
MIN_T/MAX_T instead.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 include/linux/minmax.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/linux/minmax.h b/include/linux/minmax.h
index a7ef65f78933..9c2848abc804 100644
--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -45,17 +45,20 @@
 
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
-#define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-	typeof(x) unique_x = (x);			\
-	typeof(y) unique_y = (y);			\
+#define __cmp_once_unique(op, type, x, y, ux, uy) \
+	({ type ux = (x); type uy = (y); __cmp(op, ux, uy); })
+
+#define __cmp_once(op, type, x, y) \
+	__cmp_once_unique(op, type, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
+
+#define __careful_cmp_once(op, x, y) ({			\
 	static_assert(__types_ok(x, y),			\
 		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-	__cmp(op, unique_x, unique_y); })
+	__cmp_once(op, __auto_type, x, y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
-		__cmp(op, x, y),				\
-		__cmp_once(op, x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y)))
+		__cmp(op, x, y), __careful_cmp_once(op, x, y))
 
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
@@ -158,7 +161,7 @@
  * @x: first value
  * @y: second value
  */
-#define min_t(type, x, y)	__careful_cmp(min, (type)(x), (type)(y))
+#define min_t(type, x, y) __cmp_once(min, type, x, y)
 
 /**
  * max_t - return maximum of two values, using the specified type
@@ -166,7 +169,7 @@
  * @x: first value
  * @y: second value
  */
-#define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
+#define max_t(type, x, y) __cmp_once(max, type, x, y)
 
 /*
  * Do not check the array parameter using __must_be_array().
-- 
2.47.3


