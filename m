Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CDDCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BA18E001F; Mon, 29 Sep 2025 09:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCBB88E0002; Mon, 29 Sep 2025 09:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93A08E001F; Mon, 29 Sep 2025 09:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B4678E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:57:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46E11B857E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:05 +0000 (UTC)
X-FDA: 83942439210.16.AF5AD8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71B5AA0014
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GqRw4zd2;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759154223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=4iLqh/iHK/S+xoiRjXRxUyBXfxjOwX3J0YjU8HVar1g=;
	b=FomIK0ce/gahv3ybCKtVazqwqUTcyAei77FKzoAl8WcLSQKTPBcM0sBRd90kOylRFSxHHJ
	PVZj47nEpFJY2SZmJM9Fcor5QVJhxh/qivwRB1sfzCaHjw70npQWAjJjMpbn2BZ5LjaS08
	7zRzXYQa9rwEZnKODeBEAOfCSvY4apY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759154223; a=rsa-sha256;
	cv=none;
	b=AaXbIFPX+hmhogLIGztaNq7K7Idqy5vUfmUaWwT180cFk1M0SpmMJEIza4PTXDRP+trhlH
	hq4AVLM8PV8Mt4CJRRQnFt3QWWSCYkDEnM9kA5Q25R9DMyQMCtvlwB9yYIyMTKUtQZpx/a
	ABqWkhrdDvYRKAkUp8rGCdq54hwBx08=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=GqRw4zd2;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1925C6250E;
	Mon, 29 Sep 2025 13:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF0C4CEF4;
	Mon, 29 Sep 2025 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759154221;
	bh=E14WfPin0LzGbpkE/QYPJfHq60PNmeSxrFwOpyiNBLM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=GqRw4zd229z1LGABWSG7HvFTAIvVwEtgdJ6ImfUwElHkL84KTT7b7u6/Ng2215rd7
	 OFEiSbWO6CBgTQAPgVITKo3gHiubYoyJzu/7hGxwrFAqbzXN2NUQuKXxyDXKcOlznj
	 YGXGY0XXz/Nl4HGSkNGFn2xN2BGjRzYHu7mEqNis=
Subject: Patch "minmax: add a few more MIN_T/MAX_T users" has been added to the 6.1-stable tree
To: David.Laight@ACULAB.COM, David.Laight@aculab.com,
	Rodrigo.Siqueira@amd.com, Xinhui.Pan@amd.com,
	adilger.kernel@dilger.ca, agk@redhat.com, airlied@gmail.com,
	akpm@linux-foundation.org, alexander.deucher@amd.com,
	alexandre.torgue@foss.st.com, amd-gfx@lists.freedesktop.org,
	andrii@kernel.org, andriy.shevchenko@linux.intel.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	ast@kernel.org, bp@alien8.de, brian.starkey@arm.com,
	christian.koenig@amd.com, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, daniel@iogearbox.net, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@redhat.com,
	dmitry.baryshkov@linaro.org, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, fei1.li@intel.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, haoluo@google.com,
	harry.wentland@amd.com, hdegoede@redhat.com,
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
	liviu.dudau@arm.com, lorenzo.stoakes@oracle.com,
	luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	markgross@kernel.org, martin.lau@linux.dev,
	martin.petersen@oracle.com, maz@kernel.org, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, mykolal@fb.co, m@kvack.org, ngupta@vflare.org,
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
Date: Mon, 29 Sep 2025 15:56:58 +0200
In-Reply-To: <20250924202320.32333-9-farbere@amazon.com>
Message-ID: <2025092958-defiling-cognition-7b6a@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 71B5AA0014
X-Stat-Signature: cdz11jdyrjnji9si1m6ah1ewunifrh18
X-Rspam-User: 
X-HE-Tag: 1759154223-191323
X-HE-Meta: U2FsdGVkX19Bytw1GtYsXBKVnjmeJ5Orwk3h8g2KKuZSQ1P8Lv9HK5gcfdefSY6jSBrLFqjd4V2GSBrZ/gymop+IC8gX6R/V3q6AGXmneoV92Xl4pMPP4hfennAmLZt/Xsss6EM2IY+sHzgQWgV8uK/X0ZGCHWySoFzG8xOfyh04OCgFza4olqthMQaYgb61Zyqn6GFUQyyKpuvC8zxQrF3SwZ4KqI8z6obhdah6LWvgw94tlmLSqLxcdyFVL0JJPOIMSU0QnwMrEQSqxg7C1Im/P/r3zHR2BWHm8XGoZon4PxFXEOrFBNhbRH3x5rdnNpsi528uefE2oyxhc7osWzLI+A6e8rjPLqTsng0dwOA0XS2cLX1R7bJ+kJV0QW8Uiup923Wwn47cmO9aKa8hAFgxBzOWSjvt2ChC3VP5xHnHwmRutNck85gVU1vrcYzmlJpFEbn6VPcFSCwA9zQfMY7vJzRsLrPDvek4BEbKMNfWPXBG8jOP1vWeejQuEwD9aU4vFa9hAoZUyenZPObA62Z+B3TlKLFtSIwvanqwhqHzN1lGWuIIzvcm1goHyhboEwdvXw10+ObI7+6k8NqVbx55Y6rNEpqenf1kullNpkv+PmeAoTqyTBR8tJfYamfFgTc7rC7SBGfUm/6CpmtZphjNXeP7Hc1uJbqIrAq2Vp/g6jZh59jzZG8cplBvHVT72aboofw6flB6gu6cQEpUdYXhKyX0Zy2AOCgmEdlcOt0KbereB1yyvE4KwSQLQzI7pWoccFcrnbtizasChB94Cl5ED1+cGjD8rXNBLWwaCqIC/udyUtfhnYR5Dx7eH+c9e9LI4lBzPN2ys8y26Dc3AvAK9ZRlS8x8ttW9ChDkLwC2tHDb/INEJL/qM+r9WvzX/2dYHzeys9GUWnjBtua5sKU+CL/d8Q4iC6iSqLDMN+REzTtCXf7Dah7dR/lcqI1g215puB//09z/4zQXqTD
 /67pmU0K
 QIFuBh37PoiZZTDxRa9KfDZHVLjLZtZvjFtkXxWpKSigFi3SXKp0ri4xGlc977GzcLNheRpeOBnQITGsbvxEsV/UByhM//1Ph4bF+lyH3C0SRQaHwgLOdhHleGoTugctEuMxXAs9EPBRqKJUwDAJOaHuiVgQC9YsFWtzFBYZom/OXEwq1s21WxGa2PQwiYViuYBeJy+feUWo0mDzADGJmNTjKpAlOHMExapGPKku7czoB6yUqp/XDSEzsZbwPCQYat+jbkFXbZIELFOJNijgH1HkSNHVTzYJc43upq+1hoRZpPYxzYhJgEjhl0HxeEUoI9SpTM64qZt76r0CVwVAIL1xSKUlKhPMTsdGDAIkNw2XyzImfCXth+Aq0TTq1GDXjXfGOdH/RHEuES8aMu6VvLDB+UuOCsMU4fh0Q3gCFt4xwqDqhkQf8gF3NajbMmEcFVUzeIp0+E/oMM4oGuNV7ZTqp3eCGyP8E3jUvPczG4DbHYtVFOZCFYZ6a++uWOUt7N180vzUoSh6C+0svf83lWmZEdAM1YXTs2PdRGCBKWvsS59ObUuWoH2pEMDYqptsEf4kwv9xWvjblWcUySuThL+KUOg/T14+Eu8s+ufpRqyGW+8NMJRpLlz6zWDrlTuzSoPLj47TbDtOhRG+KncvR17bKDc00/Y8o/JxysSgYAUFH60gxTLh7ksfAJFp+xDDlIeieVc8NPKoMFj6cz+fjV1jsrpYylk8pXbxmdrKjqoi6GZlcbNEiRpCDWepQ9+ZsjqG+S7N30fPfdS0yI/euanyjICyY8AsUsclSORo8lEkudaq4N6+GtDvFqbgkGCQUqJUvawfRbgdyezQLitIkYcLjXXJj5u1XI5XbPDR6HzvzcHJVeEoOnuDlsCTk/k4HPCM1+0OHjAWUdDmtavwHOLwwWFM4OGad3hWM0LIxLZvGbp8AAXPC/DsNR7EvvBZE0nJD51Zx81EHCuyqbMDSwvq3spY+
 +6ffaIah
 ii7zKU8VQKBroTr9K3Uo6W5g4kSF23ppWA62i/ZQGOMSWwghzdPaFjnS9nGZbNSYp4kfWEqDd7Oxzi2bmREA2Fp+PWJsoVbxGAiw3k6SPI5qhbCvLOqFrMPlaAXrfEHnBWT4OhnWLTO/xjU7l6Pj3NCVc1A5y8iEmfmazdbn29CjHspEjhyAf+yCIswjssI7wqSWn0Mq3KxVHe+ab0VLSo0wjjgKo8PIXDsXGkoofSJOEoVW8L8TyFKCQvNIJCE7NebOF/pT4jNifiDPP98w6xmwpzl8KIcuYdbDNxlSb6caDk+3eIR+Oftn4fb9V3VS0MyEA+PB589AxidYYIjOixk68rNbRT+kNu4BbLXLS5Hen82EaNdTjrn1hDe60Xn5xtg8xdFYrltkcpm5HMfbtxfU798vSMyrL4c7zNtCombnwfe2Gg+6DMLIM9wfhTxzjcuuQpE3mlHq+h0UgjYdSCfChZ/8IseXl0MxBkQf9j8LgH1e1KUEqjm4DY1E2X2VzHgY/XYBMl1GwBtQM91u/OZdrlorQFG5U8iYUeGhZz9nMstbrVLhUrMth0oazBIMndQWjlQpt2LwBNMyyv/uDdkPmnt2VKXXLlDAwsP8N2T2+ZaLim18xPX5i+qqn9xCjyyep7TTeXfI62GOizRqA6wkNtZ72UmnQDR7nqhhYgDfriET6enq2KBNquiIcTsSfWkm6HtG8e7NngI3V8ms/yotaJOmt5DH5Mbzck+bgn2YOnp9+qcC58LA3X4RPxxiJ9c54Bz9dnwbtr2qd1jKrDuelJ5w/8MJjh43yMGuVOcQmAsb3Dr2+f6rIZMtiNqqCj1srKckZsdc6O8vCOQrN4+w3ri0BJEsvGfjPPLuFRHIeNGemau/ZajnCbyAwt1rq+XkzChe7kabrjC4OfT0WyC092jU+tRvTMEvCwiRmvmxoVyRjJRJpVvvCjnSZHMKs/eBzamJvCaA0bEyXEgZLza3JGn9e
 zvgAy5M6
 S7UShGNgfxQlKznkNPseKPWTOddE40QacLzZ4l+Pbbjde8hTTDNv7doxplXZBXlU4pyiRczupxHq6KMi5PSRZsQRlwmJSnG0Qb/hqPxzXoghdiZfeuQCztH6E1VcMFPu1lLD6dskoM/Qw3JFsx0qRCJoydi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: add a few more MIN_T/MAX_T users

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-add-a-few-more-min_t-max_t-users.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=3555e8f33=farbere@amazon.com Wed Sep 24 22:29:32 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:09 +0000
Subject: minmax: add a few more MIN_T/MAX_T users
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, David Laight <David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Message-ID: <20250924202320.32333-9-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pgtable.c                             |    2 +-
 drivers/edac/sb_edac.c                            |    4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  |    2 +-
 drivers/md/dm-integrity.c                         |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 +-
 net/ipv4/proc.c                                   |    2 +-
 net/ipv6/proc.c                                   |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *p
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] =
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -532,7 +532,7 @@ int drm_plane_create_color_properties(st
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2618,7 +2618,7 @@ static void do_journal_write(struct dm_i
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2827,7 +2827,7 @@ static void stmmac_dma_interrupt(struct
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-6.1/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.1/minmax-introduce-min-max-_array.patch

