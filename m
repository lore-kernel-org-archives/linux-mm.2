Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF88CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4AE8E002B; Mon, 29 Sep 2025 09:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5B88E0002; Mon, 29 Sep 2025 09:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B94A08E002B; Mon, 29 Sep 2025 09:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A75C08E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:57:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 664FE13AB4B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:16 +0000 (UTC)
X-FDA: 83942439672.25.41E4B16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3551A000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:57:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=nUumuTKR;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759154234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=X5OTAJRR5VXjQ1BLVbwYihiXEtH0nF5z5KdLNBwIvvU=;
	b=tjVIO7vpyddHFEufhKmIZBCrxoxiuqXKXsnh0kMSA0mcYea2ITADd7N5YYwvcaE+vWgkMP
	sSjnQpLNTUQFFKDGp1OEW+mqEB8zlhsaj9er4fhfM63MSvHKCJFGdv9LUwooq7blYffERN
	iZA2auQWzInCWXkG9XFWnxo3g14HBOo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=nUumuTKR;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759154234; a=rsa-sha256;
	cv=none;
	b=YtWurpE9AjbJ4GvyN6RVHpVE9Vl2N36SnTzwXOdX5BR/G5y0B2Ehy7vRfHTlaZY/Lpp15G
	aP8v7ykF5udzSUYbbvgObeK4EigOJOkEiCCXE/o4Rg/roNneIZAmDV2phT+7OxOJwtKz5X
	LkSJ3uOKWai5kD6QIe2jA2K+meRDce8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 322E662520;
	Mon, 29 Sep 2025 13:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF40C4CEF4;
	Mon, 29 Sep 2025 13:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759154233;
	bh=r8zfbFYfHX1WfZdSxsVPqtrAYpzX+e5qti73nJalc2w=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=nUumuTKRYacE52H/pjQK/IOrdBNjtObk1mj2vF6iCW9TgVJYqH0rkvXCd9fwRRouY
	 l6KrrKeuLoTnFWUCthr9OyhM0l9jVNXb935o9E/LOwht0m3hdqljO4ojZfqSO9bH18
	 Js0u+q7WJUJwup2aqFzg2SInCnG2aKFfwSgD7CYc=
Subject: Patch "minmax: avoid overly complicated constant expressions in VM code" has been added to the 6.1-stable tree
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
Date: Mon, 29 Sep 2025 15:56:59 +0200
In-Reply-To: <20250924202320.32333-6-farbere@amazon.com>
Message-ID: <2025092959-even-dreamlike-60be@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: C3551A000D
X-Rspamd-Server: rspam05
X-Stat-Signature: utpa6dcybtafjw1uzo4qxbc33j7w4gb1
X-Rspam-User: 
X-HE-Tag: 1759154234-256506
X-HE-Meta: U2FsdGVkX19Gt/UTPVd5XkLmNi32GIihMhGjhXZl9yXJ03CpHCGV5oHut/D/Bvr8fF9RcA4K0PyH9Wz1oW8c3nwBW2rYTo0ZMNjbjS3TBsMmT3uAdKfKSq8uExi03q4y3S8QvkQliWeQXQuf7thHeTp64rF4ZKDpK+qtxNyzzXCfTVXgvz9pbGXx70BLWf3zKRIV0qF2a510I0GVS+avBJ0+shcjYFNIGhP2PX0HTz8ILXfQCLpUd3MYt7Bi1ZrWqJ+sTXsmlgxbwyOcuSrjXaaJql1gH1yNAZwis/Yo6SnE3CbRTYnzmoKkBnrCaLgzYnEK86QcyTCoBO9bVKiB+pESZk7l16NHd8R3W/wbFLcOH0Iloi30P0mGF/g8KPY+Niess1TKg2lTE0dAsa3a04LQTpPKzgLKFcphhO3z4/hUNsE4NMbjtTQninvwMEF38VBmyD7mmxf3rhKEDiRJUxt6/rkhrHl5Z8V+98hrorty5cfhME8b4qWV9sHrgE+x6GfCKl7MtzD4FORno2YpuuMZ8bTEkAfXTqezNAe6sCyys+M2w/gYW85aZe6Xf0MNSX8L9D/AGmVktIYlPEfVJiB0q+HbqW3KnjPzzgHt8aAhPr87IhActcrQfi0Kk0b4E1GGVgVaRftnv1TLxSC+TqI2xn8wxHTk3SE5fpT5nK38clEoAyuLCYhb3k3zoE9SqWX7HK/ZYw+JXedST8gkAslaV6T9kMDO9rqM2hCRNZ+N4/SsxbYoaFteRbtYReiSFu1M6rSkAkpmozYaLs1OyCechzSQgX+Y3R+s472BxHUuwbXU9LDc31YthqXV+MDrVnMpTHtDMpI7dRJcv/85It1XxlBZAqlAvk5GVoZW3duCmi9+Ci/pf5sLqsPleK5wF4aqGCYRRCuYImwMd9DMOwg/2xJ1MO4l/fKYe0umgAGCsYsMpzx+BqV5huUgZStjhL3uOd7X+2Zhq4xmNHr
 1IfPBRh3
 17Q0+1ba7Z75aMqWqViYHgUzW/i2jBgzSlo7VpoUIr+0rjbrgnzRThQgNjCC1lmIQMPKSEJkmkpnPDWETLLMP0ZVfzpnwupjPnPHsLSEAGIR8H+0RoPts9xAhxCgGKERhyfWWbGkSYjK8gpQfh2cjUZM+gJR6ITnxg5OZIGdvIC+RW7AwSfi/1rR4sY97rNg0/AEsNlWSliFJwGC6Vcr6EOYU5wgqm/XnRh5R/9lYjTEx/JbQIDX9l05QmmKJ+W/3oDC9765HoCf2ILcAkZwf3EXq+YEeYgMQBHEoT8jMDOsnx47hPypBrtYTmFyQJXzmdYK0M5THnUQIcTXwtXIhenTKl0Bpo7lx1w6ocEu54j0Kku0tVcNObaOSas9fEjyJRW1z3H+heOhXwXfKlXuB1GL5Gz72JYBwMrCRxCzIG+sMQeVXnpfBq4sKh7Woc6q2XlP8etP01LckP54obg+ro5XklO7fhH99LfD3qpK8FGE/Ct5vRMFdnrTClYsdQo88HFkeUZBEb06UauABFwnd/nHIsJkF1s61vrz6dngIPzQnWYZ+6ag6GA7Xl4tq6imfR6K45Ktw0tLERNsJ7Z3tPTMY1axTFhldftWS4NkBHgODxROmGvxRtM2Oo2W/rJqcMq/Sh3ADqPExfFBJH9VzTjtmyJuju70S/vydJ1jvnCikHyzMmPx8x3TTOIuPWZYH+ArypNKbEJ09bWh3BeP6hYA5blIhv5TuKnMtD1dPIJqe7DZrx6r9v+0KbXslmhoBUnaMn3L1d0/IvY6DLge987GFEtS0KDA5D1Los75kDfYcmRDsQdxFRBhZyuoz4Ap2821vCGQdGZZJvIpj9uDKTlNc/PdeZcRH+a14vCmbfuSpOHN/0b50CjCYQd3M7IkJHmr8UE8NBjUeUWt54IozVmZwurA2UzwTmgUgh5jGnlsG05DNlYXjFHqMRrDbQvUzZVbb3Fu5FFbw8TDiqk9SJ7dauLPC
 ld+oqJWY
 Pg5zpEXxX34KYNCOzO7/UB7d3gYpANwU+suMww9RB9VgwK4A1P24oONHXT/8JmFkSsSpe9229oGI66yyb+6Z+FWGzyyNDvBtAWFMbgmPdytgxDy6Wvvq384UfHhc1xifphiackp4/247YmETK2driF/CVa6oFgOgrGZtH97ZWc3LXqCK55h0/X7lxghW2sX/LPU1t5C5c884U5Kk63LyPQpSGwjGcAdDJr9JegwJ3i6s0qajNSKkTsqFdtnF0m/5sihCfbne9EQOAhK+6G76AFHxvghwUkfmAbrm6SV8TMYgmn8Vdbb7Is2vaWRZ6gT364pPNMehJFPILc4OJF9qxwtLvAgyB4qq/HthDNGJ7kqqlcQppPWYIQxGY/Cd/fB5r8Kwgk3wVpZ2+aPuPSO1L3q+OUKB+Skv+Vv2qWZS4UWRiJDL0TDtjPqnUi1AIWdUEApqk8tq85UEFzrOLs2wNOvU9HKChWlqZBeMt7opWa8J5z10yriBEAiDRriBpzG32yEGV4o3QAxNFHzkq/tm4HHKcovf0WhcP59QrvWv0WfocjDnp5foTrrhqJFsaM3wqYlZhAymdYaXNWre3MrR9O6EkDZ44qypKhhelOUdoZvQIvkNdoLNUR9nYCnHSrs+2UdqlBp2KzpYAAGYb+j4a0RaxXAV9dxzSBKJ8Zk7G9EJTjfPE7n9BZ7fF0Z21SrLmxB0wCFyMFJ7oFWUQPz+15KWrpEXB9sNLTE7PbJjozvrHq5zNKeYlYcWjT1FrTJtlEUut2Lba1R1/3ZLa5GmMuHAB5E+3bv6NX2d3eWQD5RmzdgERXqY13clBrVd9EcRDeC6jG2EPT5Yqdo9Tq21c1L9dAm4Y3aaYjquPYlgAZ+NR3IyDDZtf+mzw2kXVf7r9Ipu262CLQIYc/8hUaBVPfBbbWqOtJ1Kzaamc4HZuCERRazpSwJ4y/vxhidnmiTjwDqI6yKStGCRTfmAZG8OCg5ks4ggK
 UvGb9pYB
 LtEq9jKdgQySw7aWf/iEeD3nhpoMn0khmP8DI18irMw8BYd9jxrWSvb9rEs8301svD3RgRy7dtnd0/rMOaYsk4gk/psIKs1W6yQxZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: avoid overly complicated constant expressions in VM code

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From linux-staging+bounces-34579-greg=kroah.com@lists.linux.dev Wed Sep 24 22:28:45 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:06 +0000
Subject: minmax: avoid overly complicated constant expressions in VM code
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Laight <David.Laight@aculab.com>
Message-ID: <20250924202320.32333-6-farbere@amazon.com>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 3a7e02c040b130b5545e4b115aada7bacd80a2b6 ]

The minmax infrastructure is overkill for simple constants, and can
cause huge expansions because those simple constants are then used by
other things.

For example, 'pageblock_order' is a core VM constant, but because it was
implemented using 'min_t()' and all the type-checking that involves, it
actually expanded to something like 2.5kB of preprocessor noise.

And when that simple constant was then used inside other expansions:

  #define pageblock_nr_pages      (1UL << pageblock_order)
  #define pageblock_start_pfn(pfn)  ALIGN_DOWN((pfn), pageblock_nr_pages)

and we then use that inside a 'max()' macro:

	case ISOLATE_SUCCESS:
		update_cached = false;
		last_migrated_pfn = max(cc->zone->zone_start_pfn,
			pageblock_start_pfn(cc->migrate_pfn - 1));

the end result was that one statement expanding to 253kB in size.

There are probably other cases of this, but this one case certainly
stood out.

I've added 'MIN_T()' and 'MAX_T()' macros for this kind of "core simple
constant with specific type" use.  These macros skip the type checking,
and as such need to be very sparingly used only for obvious cases that
have active issues like this.

Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Link: https://lore.kernel.org/all/36aa2cad-1db1-4abf-8dd2-fb20484aabc3@lucifer.local/
Cc: David Laight <David.Laight@aculab.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h          |    7 +++++++
 include/linux/pageblock-flags.h |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/minmax.h
+++ b/include/linux/minmax.h
@@ -270,4 +270,11 @@ static inline bool in_range32(u32 val, u
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/*
+ * Use these carefully: no type checking, and uses the arguments
+ * multiple times. Use for obvious constants only.
+ */
+#define MIN_T(type,a,b) __cmp(min,(type)(a),(type)(b))
+#define MAX_T(type,a,b) __cmp(max,(type)(a),(type)(b))
+
 #endif	/* _LINUX_MINMAX_H */
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -41,7 +41,7 @@ extern unsigned int pageblock_order;
  * Huge pages are a constant size, but don't exceed the maximum allocation
  * granularity.
  */
-#define pageblock_order		min_t(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER - 1)
+#define pageblock_order		MIN_T(unsigned int, HUGETLB_PAGE_ORDER, MAX_ORDER - 1)
 
 #endif /* CONFIG_HUGETLB_PAGE_SIZE_VARIABLE */
 


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-add-a-few-more-min_t-max_t-users.patch
queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-simplify-and-clarify-min_t-max_t-implementation.patch
queue-6.1/minmax-avoid-overly-complicated-constant-expressions-in-vm-code.patch
queue-6.1/minmax-introduce-min-max-_array.patch

