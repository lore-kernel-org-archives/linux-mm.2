Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC926CAC5BE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:48:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A3528E001F; Mon, 29 Sep 2025 09:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 454518E0002; Mon, 29 Sep 2025 09:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C168E001F; Mon, 29 Sep 2025 09:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8968E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:48:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4D93B7646
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:07 +0000 (UTC)
X-FDA: 83942416614.20.18C37AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EDAED40009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=wjq3sRmx;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759153686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=MnazkwmtkHzbA9udn5Jk6AtKQ50YRQLThYOttsS/75s=;
	b=mJnCMpOjLuSwP6ntDb7bq/z+qlUM6ICB8j7saagp9bBVHXE5IowrNJvJVB8RV8pVfRsYkf
	s3CWUAdo0ncnAoiyVYy1lO1Jsord6VDk+LK4bSK1t6T65b5B0K8qw5MvIDrEAQ00ZYsicU
	0K5+fH17XAnLWGkH0sd/nz13fo7Krr4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=wjq3sRmx;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759153686; a=rsa-sha256;
	cv=none;
	b=U0hjhWaL50lh/P/QDv2Iels11CCnvJ3wiMjeTcqCtMP8Z6V71KH4nvjmpXUU57/IndPNfE
	etruRLL4o1sj0kMSGT0pG3IVVW+XhO5gZABbSvpvtabofoZf94Ehdg+X47Ul9dLlfC8I1D
	MxJxc+R9A/jqgASglxT9TxekXc9Q6C4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A7C16250E;
	Mon, 29 Sep 2025 13:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE755C113D0;
	Mon, 29 Sep 2025 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759153684;
	bh=wbHj0ZDVZsl6ycoce1jc98/fwkaVeepCp5kpxZMpRpI=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=wjq3sRmxcKr3Q3OX1MINo6enZ8hPpq33GBW/IpZhQI6tq74S8UOFk+j3kqvD3rIS9
	 uORhn4ViPO1YcbQmK3TR5RRW4umYVi/mp+VJZT7hi2nrk8ceOGPYVfpznyz58yGbn/
	 Xey6neh3PWJjaLYnSiakQ1b/l1S6DT4daa/XIkrE=
Subject: Patch "minmax: fix indentation of __cmp_once() and __clamp_once()" has been added to the 6.1-stable tree
To: David.Laight@ACULAB.COM, Jason@zx2c4.com,
	Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@gmail.com,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@foss.st.com, amd-gfx@lists.freedesktop.org,
	andrii@kernel.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	ast@kernel.org, bp@alien8.de, brian.starkey@arm.com,
	christian.koenig@amd.com, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, daniel@iogearbox.net, dave.hansen@linux.intel.com,
	davem@davemloft.net, david.laight@aculab.com, dm-devel@redhat.com,
	dmitry.baryshkov@linaro.org, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, fei1.li@intel.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, haoluo@google.com,
	harry.wentland@amd.com, hch@infradead.org, hdegoede@redhat.com,
	herve.codina@bootlin.com, hpa@zytor.com, jack@suse.com,
	james.morse@arm.com, james.qian.wang@arm.com, jdelvare@suse.com,
	jejb@linux.ibm.com, jernej.skrabec@gmail.com, jmaloy@redhat.com,
	joabreu@synopsys.com, johannes@sipsolutions.net,
	john.fastabend@gmail.com, jolsa@kernel.org, josef@toxicpanda.com,
	kadlec@netfilter.org, keescook@chromium.org, kpsingh@kernel.org,
	krzysztof.kozlowski@linaro.org, kuba@kernel.org,
	linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-staging@lists.linux.dev,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-sunxi@lists.linux.dev, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, linux@rasmusvillemoes.dk, linux@roeck-us.net,
	liviu.dudau@arm.com, luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	markgross@kernel.org, martin.lau@linux.dev,
	martin.petersen@oracle.com, maz@kernel.org, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, mykola@kvack.org, l@fb.com, ngupta@vflare.org,
	pabeni@redhat.com, pablo@netfilter.org, peppe.cavallaro@st.com,
	peterz@infradead.org, pmladek@suse.com, qiuxu.zhuo@intel.com,
	quic_abhinavk@quicinc.com, quic_akhilpo@quicinc.com,
	rajur@chelsio.com, richard@nod.at, robdclark@gmail.com,
	rostedt@goodmis.org, rric@kernel.org, ruanjinjie@huawei.com,
	sakari.ailus@linux.intel.com, samuel@sholland.org, sashal@kernel.org,
	sdf@google.com, sean@poorly.run, senozhatsky@chromium.org,
	shuah@kernel.org, snitzer@kernel.org, song@kernel.org,
	sunpeng.li@amd.com, tglx@linutronix.de,
	tipc-discussion@lists.sourceforge.net, tony.luck@intel.com,
	torvalds@linux-foundation.org, tytso@mit.edu, tzimmermann@suse.de,
	wad@chromium.org, wens@csie.org, willy@infradead.org, x86@kernel.org,
	yhs@fb.com, ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 29 Sep 2025 15:47:50 +0200
In-Reply-To: <20250924202320.32333-5-farbere@amazon.com>
Message-ID: <2025092950-excavate-stipulate-da60@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: EDAED40009
X-Rspamd-Server: rspam05
X-Stat-Signature: q15ka1qo7fgczewyxfxidpa3fu3cpcze
X-Rspam-User: 
X-HE-Tag: 1759153685-865977
X-HE-Meta: U2FsdGVkX1/uTysHXmVo/P2LNMiq3Zfxew6NT9cP8C64cMkaBmdhqItjX5rNyOW+9eeSewDqCeKtW5aQ66zFNB+OTiO6MVTuAUZ2BAlmEquL+p7uPJ4x5TKxADRn0OqJddCdP0wK11gSqdo9fxx/BYcA/YdZLiD1It85vjuL9tjXLKQiOQFCF8lKzTOoaoZo2iVUIbP/MHDPSEFsD1M/vNyETnP2xob8eHsuLPsVBrrDlyxD6nOFaZHfIrbH6ziO/QFuXvqxCf35DTrXtn+H1KdhJLvFc5NBxJQyWJJe2KxYL9O2PXuGZv1QmbZT/3jRBizEyGVFAijtea1ZIJ/7n5o0VeaOjbMZqjnVEpm6PtKU9+1Jyo61BQ/7kA+vwraqVFDfAxfzBRIQYTBOHnPM5nku6bYx7ze8kdt+zORauhYlr7jeKB5Tev54oGBMURMxfOPDCH2+gy++cgqJHa1fTcBF2ugZC1xCaT4mnXMY5io7hAJFkZLEUmI6YwAgZlQh+kLvU0U9V+lHib4TC5Tnc3TpN1dF+9qm+sDHqI1HJ/WiTwP3Il1OmOvV2JT+O9NhiR8Nbh8fiJx+KhUwzyLufZQISt9trEHwgDneDJFg/HxMCOm2MY3N+fH9ZRqqSw62FYUjoTRbUry6GF71V6mK5hiEZfDMl2USsZMItxFi4zSZpPhlkUA9t6SbKMq/jXAD1rZ7jFhdD6NVW4l8y2FuwTXHQznetNDfxmYbZKxJU818N1MkR88Qny1eYRYV5K8qGQUTTy7CsY4FTpchdihGL5V1gGUEOwgsJtzXZWIfu5eVnyezLiEfBzHvJfqdT36DAOwk1Vm+wvZexsaDIaOuL0vflL9fRx4J7LGR6Nuugv3FKT2xzrlHPb22JhRfTut37CYvqyKTNzV1Exlz1SSfzC4nQ3UJbUdjr44AaWJj2LAnsEkrLCLuwZJIW5wFFuRhXUXc8ZEMuY3EKqBBnge
 XVIhOU4U
 QB9GIlc89ZIk8psvS75nyelyYNGrlewqVH1efrvYJ7+UhNXqy2va8tP+Vn/aDrpZRrVsQunkF8VXeXS9FQzyqCT3LzhVF2YDi8ZjhfYwUyUusG5qYH8Ugbnvf1Dhmj746DRyubtsOeghOZMQiM7/UHWgW7we0PQvMJyS5HiL82MyrBnYfq0vPHlfqKm7LkGu6/9A0kxV7CwCKR8cCLj43E4bntdyw9K0YUNk4hBEIS+q6h4YUehIT/sQ36ynDFNt8ZTCddkzauzaNbqS4rKwXDwAfjqt4o3APoyhyl+vL37zNs0n/Ecy4xudJ0+DulR0mZKlWVstHKBBOKbOdsIgqa1m0G7418E9KOKsUloBnalo+Nuu4qDiixjy090JcopSgyuFonK4F9fQBB7CzNsV/4KrPmNVP2+28tsLQHgEd00yFCGhx1hxOw1wyqKl621wXEmGXiTRu8kXnkpm7+xis4DfunWAqIu64+wEJZj4T2BuLIe7TLhCY8BFVW9qoDyHNWj/xPR8xUUqD9zfCI+fg1hkPdI1/kI0NYtVAioveblsmbPOmkc6eKHGC+N1Csk923kBf/wgzGJF8fQ+2lUXrHsstD4+3MU4U57Zaa8J2yEZfEFXbTvmiD1g5oW7vv3x1VLdOtFzp9eDWMPHl+Cgx/l5C60boPqRM17g7vVTI7gnaADUKjt4Lp4qffxzjkOC0Ulsp9TRIcPUI060L+cuUBDjE6/tcyp/FFeMrFetTl+lM1bP20gGnGXYQ95drtkP7kcDCWrHNEibQ5162puqhvC6bkVCOz9ZerB5+ncqixZDkanTw/rtCxt/Jc9BUKDuziSbCB6AaLHHZWPsbKTFLQhf5BI90yGFJu14vRpow6u/mmwRXod2tHBF1x7Ojtgz6Hp05F1JgHRzvJn6IhHwy3F5TSZn2vhHWqyKY0oLy+hBezbnKiuJXWVkSFkK8f0BPfFIWNYFQr+t1Dxp9zuxtNlU3dmyV
 OHdBwVSh
 92UeU2h1PX7yQpfbwrg2Rmk0dijuTzfgc4uaQt3ZHzkdxhJ5mT09ay1cqDeW6M6EkojVH+JUMN7o3+X8xbtLB98AYuPbb3mpr78PMokmqfEIhmxrq1vTvo55n6a4NCWuwyIt3k/ja2RCLFLiWl6NanaLpmJv4yvrievKzVj67HZsfoMMeRQaoWaQUT/orw8mdDpzegAHds+0GHdYijRC6O5BrRkOEqTWpK4qS6ww1xcfOse8sv8HwQGPnUqOw39USCkXh/3QoebE594Du+QtOgg5vNxdtRjFk1SagUSaV+GjA325MYaj7ME/m/hWdMEenM61aSFDSscegXoJoe0OQxcy9fT2UCUNTf7bhjGy8Z+LIjyQcwRmw5RHNtyepr5Gu76pP2/1VbUAP1BInp7MbSbM6szX5FofoJM6ZLqouzM6XB9dqgaLiXJemTSx/1NeAzLlI3wYFY0wLBNf6VZ9+Qff3Csak9aVJi7l7w/2q047EVXh9fxijjk3V6Ry8hb1fmEmz9YmbaAMVRiRpqXqVvgdjEWJXQBSkaNp75j8vnDuRYUfgN79Sw9a7t8YBJ9GyYQuCm7Ee1/BrJrCgebLhrgbw6IZxAxI8Q0P4V5tZp6n0vEbPrT6/KKA9jaosxvay6QFiTMi7W2c3dMB7NhPb8jd29CQF5KKRcowVKPyJI0Gyc+QWVmRoMzIbE2PCoCQ/JfZqrlfSgp/OH1NvvtZFJiSpadbEKnXLt2C4gMG1XIM3VlUN/MuXIjvi0+p+uhTOOsVEwxDghVTsYyDM5AbGUIctlVkqRGOvdJcV/yjMa2OtoToqiAWcJSXtkLK4NUr0YNcZvzJbb08RCchbMMHbTEUfbPuRE7sqBZnp16ufx9tDp1UZuAcpXx21LXTuIzT3aVQ0tvQosPzccFssxmrMzB3kGi+BmxzKQ0toPCDD7RmLa7+W/28NvMu9gMEClbE94mYcyaO6vW5lYHkc5p7k1OuSFUaO
 7WNcOJFy
 Y7/sEOSvmRsIkf3uRViOcduRch9nlq/IT6FIgyUWA57k4tJxeJFH3YXh8HjNpXHXWf0oaMU5Y8+mfzl76DPkmVRzzoEh6RePxE5hu62psLhSxXR2+XoTphN/Hn/VQAS7iQdNPtl29M7mC0VbtRbiOHt05SFPNZ44wRWQoIl4IC2zp2PBRNap49Fa97lZYi4X5k3P71XMkYhkcoFpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: fix indentation of __cmp_once() and __clamp_once()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34578-greg=kroah.com@lists.linux.dev Wed Sep 24 22:28:06 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:05 +0000
Subject: minmax: fix indentation of __cmp_once() and __clamp_once()
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20250924202320.32333-5-farbere@amazon.com>

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit f4b84b2ff851f01d0fac619eadef47eb41648534 ]

Remove the extra indentation and align continuation markers.

Link: https://lkml.kernel.org/r/bed41317a05c498ea0209eafbcab45a5@AcuMS.aculab.com
Signed-off-by: David Laight <david.laight@aculab.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -46,11 +46,11 @@
 #define __cmp(op, x, y)	((x) __cmp_op_##op (y) ? (x) : (y))
 
 #define __cmp_once(op, x, y, unique_x, unique_y) ({	\
-		typeof(x) unique_x = (x);		\
-		typeof(y) unique_y = (y);		\
-		static_assert(__types_ok(x, y),		\
-			#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
-		__cmp(op, unique_x, unique_y); })
+	typeof(x) unique_x = (x);			\
+	typeof(y) unique_y = (y);			\
+	static_assert(__types_ok(x, y),			\
+		#op "(" #x ", " #y ") signedness error, fix types or consider u" #op "() before " #op "_t()"); \
+	__cmp(op, unique_x, unique_y); })
 
 #define __careful_cmp(op, x, y)					\
 	__builtin_choose_expr(__is_constexpr((x) - (y)),	\
@@ -60,16 +60,16 @@
 #define __clamp(val, lo, hi)	\
 	((val) >= (hi) ? (hi) : ((val) <= (lo) ? (lo) : (val)))
 
-#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({	\
-		typeof(val) unique_val = (val);				\
-		typeof(lo) unique_lo = (lo);				\
-		typeof(hi) unique_hi = (hi);				\
-		static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
-				(lo) <= (hi), true),					\
-			"clamp() low limit " #lo " greater than high limit " #hi);	\
-		static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
-		static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
-		__clamp(unique_val, unique_lo, unique_hi); })
+#define __clamp_once(val, lo, hi, unique_val, unique_lo, unique_hi) ({		\
+	typeof(val) unique_val = (val);						\
+	typeof(lo) unique_lo = (lo);						\
+	typeof(hi) unique_hi = (hi);						\
+	static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)), 	\
+			(lo) <= (hi), true),					\
+		"clamp() low limit " #lo " greater than high limit " #hi);	\
+	static_assert(__types_ok(val, lo), "clamp() 'lo' signedness error");	\
+	static_assert(__types_ok(val, hi), "clamp() 'hi' signedness error");	\
+	__clamp(unique_val, unique_lo, unique_hi); })
 
 #define __careful_clamp(val, lo, hi) ({					\
 	__builtin_choose_expr(__is_constexpr((val) - (lo) + (hi)),	\


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-introduce-min-max-_array.patch

