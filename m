Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 942E0CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D06ED8E0018; Mon, 29 Sep 2025 09:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB78E8E0002; Mon, 29 Sep 2025 09:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDA68E0018; Mon, 29 Sep 2025 09:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACB7B8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:48:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0E61A03AD
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:04 +0000 (UTC)
X-FDA: 83942416488.24.A3F19E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87BCD40007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=TQNQxHbi;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759153682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=FxHQb3KGEKk3bjUX082vb4J7La6NSNAReGV155YknqI=;
	b=w+PRT3ykUwx+DgnWMwTA2UIa+jXA6OuqW+VidNoxVmD0PawsOTFfpLVw+tWN7A66g1Lkwh
	ftEgMuRrhiHm++QIP+9qFAn0/9TbO4RlpichNNyZby8isUJa3EhQDEWo0e6RquSlG9jDS+
	elTQRLMAmt/OzImT5CZf89vCLIvkBQs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=TQNQxHbi;
	spf=pass (imf01.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759153682; a=rsa-sha256;
	cv=none;
	b=pGlEjzBqYQGh5ahIiNpUbJ7+TTpOfL8XK1tgVomRT0tI6QYqMMfOHN57ciL7segftv4a7h
	3LzIOgaYOAUR+vQwGraUwMGzR34SY9tZt/uEXS30oX4rUSR1Z7qfPM1X+ZoVZC3Mq0BXVT
	5DFw9BVHFQMvL3uPaF0EdrRGzrwX8wM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 800CF48A3F;
	Mon, 29 Sep 2025 13:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08107C4CEF4;
	Mon, 29 Sep 2025 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759153681;
	bh=eVkxFmIpIc7XoZdv+IJQ3n11xJPvt7/kqsX3m7/whd4=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=TQNQxHbiXXFunqr3EsqQP+eQU5/V6AcmO2pYhjttlAy1k/kZFFG8HLgV+0PhQo855
	 3fAUmSi42FQrP2kcKjGbfILeXg01Dwaav9tkPo41z+2mngqEWrK77O+9cQaFBtjp5n
	 rH3bDwWhlAISZbB66kPeA/xg/Z4OiOg4O/hVhdZU=
Subject: Patch "minmax: deduplicate __unconst_integer_typeof()" has been added to the 6.1-stable tree
To: David.Laight@ACULAB.COM, Rodrigo.Siqueira@amd.com,
	Xinhui.Pan@amd.com, adilger.kernel@dilger.ca, agk@redhat.com,
	airlied@gmail.com, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@foss.st.com,
	amd-gfx@lists.freedesktop.org, andrii@kernel.org,
	andriy.shevchenko@linux.intel.com, anton.ivanov@cambridgegreys.com,
	artur.paszkiewicz@intel.com, ast@kernel.org, bp@alien8.de,
	brian.starkey@arm.com, christian.koenig@amd.com, clm@fb.com,
	coreteam@netfilter.org, daniel@ffwll.ch, daniel@iogearbox.net,
	dave.hansen@linux.intel.com, davem@davemloft.net,
	dm-devel@redhat.com, dmitry.baryshkov@linaro.org,
	dmitry.torokhov@gmail.com, dri-devel@lists.freedesktop.org,
	dsahern@kernel.org, dsterba@suse.com, dushistov@mail.ru,
	edumazet@google.com, evan.quan@amd.com, farbere@amazon.com,
	fei1.li@intel.com, freedreno@lists.freedesktop.org, fw@strlen.de,
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
	liviu.dudau@arm.com, luc.vanoostenryck@gmail.com, luto@kernel.org,
	maarten.lankhorst@linux.intel.com, malattia@linux.it,
	markgross@kernel.org, martin.lau@linux.dev,
	martin.petersen@oracle.com, maz@kernel.org, mchehab@kernel.org,
	mcoquelin.stm32@gmail.com, mhiramat@kernel.org,
	mihail.atanassov@arm.com, minchan@kernel.org, mingo@redhat.com,
	mripard@kernel.org, mykolal@fb.com, ngupta@vflare.org,
	pabeni@redhat.com, pablo@netfilt.kvack.org, er.org@kvack.org,
	peppe.cavallaro@st.com, peterz@infradead.org, pmladek@suse.com,
	qiuxu.zhuo@intel.com, quic_abhinavk@quicinc.com,
	quic_akhilpo@quicinc.com, rajur@chelsio.com, richard@nod.at,
	robdclark@gmail.com, rostedt@goodmis.org, rric@kernel.org,
	ruanjinjie@huawei.com, sakari.ailus@linux.intel.com,
	samuel@sholland.org, sashal@kernel.org, sdf@google.com,
	sean@poorly.run, senozhatsky@chromium.org, shuah@kernel.org,
	snitzer@kernel.org, song@kernel.org, sunpeng.li@amd.com,
	tglx@linutronix.de, tipc-discussion@lists.sourceforge.net,
	tony.luck@intel.com, tytso@mit.edu, tzimmermann@suse.de,
	wad@chromium.org, wens@csie.org, willy@infradead.org, x86@kernel.org,
	yhs@fb.com, ying.xue@windriver.com, yoshfuji@linux-ipv6.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 29 Sep 2025 15:47:49 +0200
In-Reply-To: <20250924202320.32333-4-farbere@amazon.com>
Message-ID: <2025092949-coil-hardwood-72bf@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 87BCD40007
X-Stat-Signature: eb4yzhdyigguu79dw1abbnbwf9dmuq9d
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759153682-55693
X-HE-Meta: U2FsdGVkX19SAZ/lfHmJkiuSV47R0RP24bL6MUBj0OMHOMLRgn3VUtFPkTVzMSVqfuHKEqCQr51rU4aiTkayyRXqHjsuGzeF1/IEPTy2Le6SD1GzCwscjBereNd1O8HAA3yy13MArVOX8CR9VgHNHas09uz68NQAg72aGRu2GlokLwbEwWoNKPBM4GgxNJpdf2Vh1WNiGkchi7c2lO5QwG/CozluaCg7GhCK+fbKxWliruZgsXsABPzPLab92sbobosoOuYy51vDZc1GU7DIWJlecQm+5XXbaoSuWB6IuT8kUMcqwMe9zzYYMR5FzaXZwcRoEjwoXKWKlS/RZ/b+K2r2nvsml3EeL37BSI93SwPEDHjgSZDL+41fTVcjNiX2U5HyQ/AP+3LjOfUcCpCWr4vBDUAVgzK6V3jijVsWYKJoaEzKwCiX0hehvcd8Lei3GncMQlMVi7cVuD1su+CMO8VeaxDlF8JQHExQKSKTrkS3EGx6R58MF5ek4/rEoOEyTj3u5G3tuq/op57UuVXXdU6q8Gak/91TD+PszHAJ28HDe8/6ejGBKATeViUvaOpkCWeEuHuh0q5rl+av8ZcHX8KgmbKn2lFl/frqyDvpHlaqL8dY0WLQmrRWGCfmmtyIXQ+eO0PLUFrJXSoUgCq7DyQvMfIgjCBnM+lwOzRUdtuTxXcaS5HFocpe/UNIIOTrCFp5Aywc3AgLp9Eir/BPzDtE18DerfFLCgbo4y7kUQr6cMQS1lvqbe3gYwS0nYPIoV6v0FIvUkHXTXhUU/pItmiI7o/PxW4aHxZrS+wBf1NYnN710I7upF2hhZySx06c5528Q6CXk9xvDWyEYPMN+I7XWbU6mBVo1Pxv0+kodm9lCe9vLHtfwyfNpBQISnjIDc32JaeJ4BfD2Y0FcDwP20ZJh0XRdOAAXN6Jb8CAbjR9/44W0lABomybpzAIm9MaDill+mlqX9Gu7Q6nNTn
 npyBZvB2
 UO7Y26/GQ9EcI9P5LPSSahxOE4Jz0ML1n2+b68oUuZVzP+iVK7XkYEt2Gwj/k9LUVZiBpp4oAL/DCjmfQAYdVxbi2oznumuIM6yrHcV/fAffdY7tZR00XVOyjW61Ww4pKXHBHOwYnEOyDm+mOBbE2/rg3eZb9jYgghiuhp+fXADI8YT2OIFy6mVB4XJWFNRUHbkbYllmB98WvuqsHV9SgXtXDWxt8yWKtimI/qip/KKn1DtWjWlaRaOR7VMj93wqGoBBi3RPp1b6kSxkHk8nbKxxOIwIkv92TEY1VHW5rkqJyWG/4g1h/k2r0uJbVc6UZJw10dauJJloyceSgqf/ElA8Fpfw4Fe9hHEuq9spLEdvaPu8PHM+NO+COQcLHWqGD0ryIwlRAw/2KHMJQ5qXBqwyzBXdfjNs+Qi8akgHzksKL4Cb/cCq8qj490EQRpbQ3ha0rkDZnTi1jfWkp/vUECwcOc8P1Pek45SN4Wyc59eV5unosizqUs7qHstqp++WIpgkzqG5dtIzFibNLBvtAnXfL0QdCY5LRElE6q7daoArDhB+zNnNM1jRkcGtJE7k++m0NLf622cee9+JFtuKArxcznqx5QLYhQKrQMu5v8ZsRjuZmrqASs4+CMBMgHh6IO/iGXvsRArEj8BqdcloROSHFEpmKVOQ8icvb0xC+tcSc2XzkMvP7eFMNXdUcZo3nBOt3tPMP0HlafdpBDP7dyW4aFWdvd9GpxMCcQu6pPhUGkgy6XD11X8r2GfelaKvUlbpbqAGoOVjip3AyK1rRWqqodcdLhJ7rOvH5Qe0CY2F9GszLev0byftOrcP/iAgixATH0Sy1tj43zYhJsfhVuuphgAu2GyCJKmg+33hNuTsQghgniJek+UXSyUaXu/H46CUafdXdmI22iH92tOSGX8Jw11Ymb3WGumPB0JDA1Enc19n59Uou0E13xHQhcp/+oIEb1yTMeVarjO3dx+R+1btt66AP
 tStIDOJO
 /xaL+PiM3gnbzzdBABoTGe+i2MNooExSJHB98lXF5Ho/cxIxHKfss5W4EP/8PquGbvFzVfgTKRewD+PatahFO1kqnakV96FmM2MONiL/JPplt7PTDrYTfIdGnc/oyn/xA6ozOqVWuzOSlxwges+J51csvTiIk/HlKZ3detdYoIoaDzyMrpKJFD34CyxpOgHNzOGh5rRVe7i/cuqn78fjd04OzFBIuFqZAmISTTufjPQww/er9ltK14t7YSz56He6MMZvCmjQPIgJQCzA6Tt/yHm2ru9KlvpdJQaj0sAO+833P1lrERn7f1CJBZYYpfm5TdrWNHONycb3MnnJmXyAtc69CrJDbwahIZAFce+acUu03R0lviZNkJmwEbKgaO2MOPVQPaJiXVP9uQAaKbNRABMyoHvHcxdx0sCinDj6yH/5JLfJSHad0YY+8bHuXYP3tyjgzPZBuQAssMcP12EEg8t1nuYgVjsSrT4qxELy8DEGaXZJGkCOqID3ZA2t99tEn0tPiobR06R8MSNiWpb187FXJvpl23cx5ostJDOatp0PhNLEwR0w4n78htZOrpsyxElvg73EJxqEVMLA3I2EaZqzfYC/rg1zogtvlZFlzd/4YcqJ5n9Sg+lJ+tpWEtesIQODHc+C8bQ7y+lgB0NS8PphgrdUVli/IhOzYqOOTSDzOy5D+/wLyFMxsAtQ/VZ2aFMjLxuo6TcLxheuW+iM2BNABrWqZdN0gniOM7sH4sf9+fBWxFuNB+lpG3791ND5+qZKRXpOIH8Yso29dnpYEJ2QWS+rNqUqGL2SGRQQmCDbXDNUxmZbhTLoj3ryezmytR8xir8tLJXPgKjUIAOd30u3wGK1bia9J7dmFve0UHeuHUrhQCf6OSGSvVzzpvIlxL/NpJ7QjKcOHaN09+De+6NluRZRqteRxpjc2b5aO5LxdemwA7dT3+N0O5xWDlpAOv2rPgh3zgtGco/8F/HZ4NlKe4kWd
 365og1z7
 7A7G42B1i1BXRVqcSL8LZQmv6EoEwoUeEP7jp5R7ZUobyPynWEIkfaYs2ifMjrmCrlVmjNFlMu54+x/TAVq38bgdsJXseQjOHZ4DPC9psF3nLTz2Y4Bwrfsi9c8IdN6PF+avuUG0L+loGc8wtGHZhQHSGlO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: deduplicate __unconst_integer_typeof()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-deduplicate-__unconst_integer_typeof.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34577-greg=kroah.com@lists.linux.dev Wed Sep 24 22:27:13 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:04 +0000
Subject: minmax: deduplicate __unconst_integer_typeof()
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Message-ID: <20250924202320.32333-4-farbere@amazon.com>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5e57418a2031cd5e1863efdf3d7447a16a368172 ]

It appears that compiler_types.h already have an implementation of the
__unconst_integer_typeof() called __unqual_scalar_typeof().  Use it
instead of the copy.

Link: https://lkml.kernel.org/r/20230911154913.4176033-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -169,27 +169,6 @@
 #define max_t(type, x, y)	__careful_cmp(max, (type)(x), (type)(y))
 
 /*
- * Remove a const qualifier from integer types
- * _Generic(foo, type-name: association, ..., default: association) performs a
- * comparison against the foo type (not the qualified type).
- * Do not use the const keyword in the type-name as it will not match the
- * unqualified type of foo.
- */
-#define __unconst_integer_type_cases(type)	\
-	unsigned type:  (unsigned type)0,	\
-	signed type:    (signed type)0
-
-#define __unconst_integer_typeof(x) typeof(			\
-	_Generic((x),						\
-		char: (char)0,					\
-		__unconst_integer_type_cases(char),		\
-		__unconst_integer_type_cases(short),		\
-		__unconst_integer_type_cases(int),		\
-		__unconst_integer_type_cases(long),		\
-		__unconst_integer_type_cases(long long),	\
-		default: (x)))
-
-/*
  * Do not check the array parameter using __must_be_array().
  * In the following legit use-case where the "array" passed is a simple pointer,
  * __must_be_array() will return a failure.
@@ -203,13 +182,13 @@
  * 'int *buff' and 'int buff[N]' types.
  *
  * The array can be an array of const items.
- * typeof() keeps the const qualifier. Use __unconst_integer_typeof() in order
+ * typeof() keeps the const qualifier. Use __unqual_scalar_typeof() in order
  * to discard the const qualifier for the __element variable.
  */
 #define __minmax_array(op, array, len) ({				\
 	typeof(&(array)[0]) __array = (array);				\
 	typeof(len) __len = (len);					\
-	__unconst_integer_typeof(__array[0]) __element = __array[--__len]; \
+	__unqual_scalar_typeof(__array[0]) __element = __array[--__len];\
 	while (__len--)							\
 		__element = op(__element, __array[__len]);		\
 	__element; })


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-introduce-min-max-_array.patch

