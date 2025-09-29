Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705B8CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 13:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0DD8E0027; Mon, 29 Sep 2025 09:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90F98E0002; Mon, 29 Sep 2025 09:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80188E0027; Mon, 29 Sep 2025 09:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A674D8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:48:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64A45119A44
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:19 +0000 (UTC)
X-FDA: 83942417118.27.F61320D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id BADFC80008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 13:48:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=B6t+Jrd3;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759153697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=r+yfnouGAxJLMxX7PYNWLinKX2hTrrnX1JjuNMojpG4=;
	b=wicLhJTA6IpHhQ2j3pHjxvqzqGRAkikc2sX2YjJVFOe/c2UmXkUYEpU0vCXaseTKx61/YP
	csAKHL/tRQwr4cDVVyBfs1S+OqHAdxCjXfuxQWgJXILrrxz8Vv0HN4BUydVewpJCtPGr4z
	AhTwfyZWmqLtvLZsFWfkeKVDZFlHW2k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=linuxfoundation.org header.s=korg header.b=B6t+Jrd3;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759153697; a=rsa-sha256;
	cv=none;
	b=yAtUhSh4JgklBxKXium0JDpNlRFHtLsWC3DG1uvo7gjzZEddxzVBg5VaG++GnzsiWW896G
	74uGYUsjEm+wZkFu8GIJXUB8bxZxHCJhnBdwjK9g9jLIR4TZkXtK+PI50+DxuC+VNx3ASZ
	IJgYPYmm7MWgFApKc+cWSwtizNBm7lU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1529462515;
	Mon, 29 Sep 2025 13:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1B0C4CEF4;
	Mon, 29 Sep 2025 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759153696;
	bh=FRCZRfk0/9Y0TgXFpLHgUktrJCsdSngcjZYfOD5xZeQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=B6t+Jrd3GyamU4Ar7VX528fTEGPw8TfIGLU+v86PgGuTdJBU5fURzBfMtrPPpNBHn
	 VBRNmAsDrb0Y9aUYk8ilRuUzMH87bN+auTdiVcj9Ry/18znhvhzzhca51CuLTEUIdH
	 keAbfTPJvzLrltacoycIYTVEGViEsKeEmZ5Er910=
Subject: Patch "minmax: Introduce {min,max}_array()" has been added to the 6.1-stable tree
To: David.Laight@ACULAB.COM, Rodrigo.Siqueira@amd.com,
	Xinhui.Pan@amd.com, adilger.kernel@dilger.ca, agk@redhat.com,
	airlied@gmail.com, akpm@linux-foundation.org,
	alexander.deucher@amd.com, alexandre.torgue@foss.st.com,
	amd-gfx@lists.freedesktop.org, andrii@kernel.org,
	andriy.shevchenko@linux.intel.com, andy.shevchenko@gmail.com,
	anton.ivanov@cambridgegreys.com, artur.paszkiewicz@intel.com,
	ast@kernel.org, bp@alien8.de, brian.starkey@arm.com,
	broonie@kernel.org, christian.koenig@amd.com,
	christophe.leroy@csgroup.eu, clm@fb.com, coreteam@netfilter.org,
	daniel@ffwll.ch, daniel@iogearbox.net, dave.hansen@linux.intel.com,
	davem@davemloft.net, dm-devel@redhat.com,
	dmitry.baryshkov@linaro.org, dmitry.torokhov@gmail.com,
	dri-devel@lists.freedesktop.org, dsahern@kernel.org,
	dsterba@suse.com, dushistov@mail.ru, edumazet@google.com,
	evan.quan@amd.com, farbere@amazon.com, fei1.li@intel.com,
	freedreno@lists.freedesktop.org, fw@strlen.de,
	gregkh@linuxfoundation.org, haoluo@google.com,
	harry.wentland@amd.com, hdegoede@redhat.com, herve.codi@kvack.org,
	na@bootlin.com, hpa@zytor.com, jack@suse.com, james.morse@arm.com,
	james.qian.wang@arm.com, jdelvare@suse.com, jejb@linux.ibm.com,
	jernej.skrabec@gmail.com, jmaloy@redhat.com, joabreu@synopsys.com,
	johannes@sipsolutions.net, john.fastabend@gmail.com,
	jolsa@kernel.org, josef@toxicpanda.com, kadlec@netfilter.org,
	keescook@chromium.org, kpsingh@kernel.org,
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
	mripard@ke.kvack.org, rnel.org@kvack.org, mykolal@fb.com,
	ngupta@vflare.org, pabeni@redhat.com, pablo@netfilter.org,
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
Date: Mon, 29 Sep 2025 15:47:51 +0200
In-Reply-To: <20250924202320.32333-3-farbere@amazon.com>
Message-ID: <2025092950-unwritten-skittle-230c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BADFC80008
X-Stat-Signature: ja8drec7zoe79bfbym8s3k7y1amywqmb
X-HE-Tag: 1759153697-376566
X-HE-Meta: U2FsdGVkX19EZbZ0C8cGxcrYeAIKeRkBwH3FD604qk5cN92E8iflZhJWgLOe8wD3tD8VVx+Ja9BfH72H1jFw56/pgpHSuKFj7p+v5mIH8+1hiLLfMJZFQ3TCWYKyK0E/UvA3GuH0Bh/LSCkxijgMabWJ3cuSmPtKT/62oLqternVXurkX7XF5rmESQ6rML3IrkqD1Peh5Zdt6XPMAcQStTeRfGO9pG74anxIwlf/Sjy9+NpHAA2/p7LhRYWfBdyEvRq3FhpoUWQOlAIEVFnd7mJ9/MKzjJFPxI58XTppA2HWKDZUtqupujGWH5fDE6G9NMHbmCOV3Ke0bbMQ2aFpmguKpjOw5/n4gGXEaNVP87fQP6gO9I3Xh8p96JpYLXFBo/ZJThgd70/iCvBTeSkn2l9H5UaTvkLjGgeEOklZutTM1iEi5jgr7zRIGJOJ7t7cno1/xcfW9nQ4viqgpta52fMWnv6fpxvBfyTxKspB2F6OCY+1dVGRF7P0usk5ejiqx3Lk2osn30oS8nKn/mB6xo63QadLrcbWrmOgqibMoJb/nEiE6lsEZItkVu4wEW4hF9MjTbdIg7Wo8KCJ9v3nV64zxotTQ63LBa7WLNftiP5+HuzDmjnbmKNtVMkb7KvKFG6HoFAVvyGnT340XKqAqCzbRdnPigETx2zBFp7Q4DMOa2yueE+mikOHZm+ZHbCXKrVQ8QZuBe2EKGTJlUqHy2o4KjWAVhgV7cI0k7I09s6vQPk7u2yODcrSH6WuWimAT6MDoGsGfYR1DaMn0OwzLzUwCGS2Yo219aZGF+o0GzCbtYktQw6vnivZU4cfQq5Dxg5fkyzM2v8yZuAAWlWpNfQrS+/Q9rhXrXGM6Uux2pxw+Vkjbd1W4qJjZ0kXQDR3Lx6ImO6JWwJDlfaeFLGJPF3e+dFernxGRKKY7eBM2kWkSlcLsTNUC1LFOkhFFAU4tBr0u6vvm5vkgumeApA
 Zh0iiS0+
 FQNcQu6D7OxXBbvneslr1KaB78KRDrkcBeh7XpoL0FZf+IAyYKp5pOkDn80ixy0c0HFMW+XBVXYvSLZuVYeskoogJfl7bWx6rtIchiVObCSmoqEJInT5G4Y4/EfbGadBDoK9QD9GpkKoYYfT3p+TZlmP62M0B5pWvEOjAMsNX2pfX3XH2hFEUwguhW0l0TcUiAUN2CNLPf8mUWtzLvY1GIMXqzFhbKLNMSfHcIY8pnQe0iINRK6DFyUJCzyV3U6heDWPzQ3YD54GRTxiY8CFeqTT6KikA6VKdQcPS4pu9wdIVL7EZd2AUcwMhLMu1MwgnuyLzv1AS1JdjGuVJjjhna64ueYsxH4xryyoy7B0qZA1DqpqG3CTIQ0BYN45hLnGcCcAG71fVDZ9/vyOw3/omvb4W170TxwF/swe0F16W0fHokVZ3q2pJZ5yzdnoHMkeW+gSUKtf0FKY0vO80Mv8Gt8S/mrZwsSsxcHxfReiimYIlK2AmiZOBwJEfUl/5jQgOgJTjRtkDcZ7bYoH7STGVcpdpRPchSMbYKg4b7/KK9haqNluYwyFfvWQytUAz9DI39kFkoms8BT9zZK8111oi3wsoKpLM24W2gr9t31WGg3453QnzAvtGxPfPZAiP0+2poumwEXRNeP2XS5i7o4vHogz9axf55KxaMWvs/NTBe8HGjEWnZ98g3DQ4VK+j07MuDCxGbgJh29mqE7yUmACAPS4qGx0OssOM7zuKiCfS+aCVIlWGTXRxlGxSO5Snk4D5qIcBLovgIOLxfnPbfTUAU+o9vz/X/LavuB94UAlZ7AO1b+9DLtbNp2pUH2ftv1bUEYmueQD47QCcFfYpyvlPWknF2LISW2LTaXt8yjjNADSYtJ++iAqaYMJdMEHoREpijVRz266EaIVYTkxL35J8THVdcsnNb7GlHkNNfXWYWot1YZdjmgcglyjj0LvcXQLRPe8EnnKtbfzqOdm4A1eHGU3GdB/U
 sn2d8VuG
 Kq4LMFp9AbtTyH2geUr1agP1iKrHfVVtogb1b0Br7YDd1+ADwsrK1bsc7B6ytHOB8XCqwpRabXxoHeXe20ySXzqtPcPtV8/gupN8ADxX18n+wyJGC8zeEgGkEP+1xTemQ/FMSaQuV8cPTLnFPxdDwg57y5Y3X/2yTSEIE9dEJpf4M+32wkWZSadCh3nkqkjvtQ+xObL7QdrvJDckzkxEWTPyexbCYj1sL6snRvKuoqVUDGQ3PRXVVgufnl3KMa6FfNle7Xewaueb6D6CQmOnyEyyUT6CjfISrrXO3MV6Pyrjkuk90Rc4UGhk0pMPGRv7VX3W4znwiSuzCuSi3F7lkmLUb8c96XYOjFkvprijiQm++cPVlHwhz8gEWrNCAFtfpPOEgsFuZpT30oa1vo7xRmXVBjLx/OR/IXyIogeI4i6l7gKfgscr7JAh46KBREjytAiVsqZ3Y4Q9VmW77cclCxOeQH6pTuu6O3HoRjwKY0sLxW4ZfB+ZMDHnCRcwGKsA1Gh+NfJMe2X0yvRkFlPI0B7i5sMrrkLXhvVFNR5UVGoklThpV76Bx10Fg3NygJkXZaPukdcynWZwNfLtPRwVxIWXHuGBRO1ptI1UTn4BTPUnKilMQsLoTipdaerkEVyCzR9aUogCwaoXU/xcESsF/nnHclKoy12LH0NbuyJEHjbO/sz1eTvvdkdVpyT67k/RYvewgIi1R365VPJar/4v70qoHILIhrGsWibTNPk0DFD+Rwh2+OsE743k6IxoDusiyGajhm6FMo82txmBbzuVBRkGwyJdSDXDvlj4ZAYay/p/uQiFuj6ANDigEwmxydpkEFBoxxfgbS2051RLRQogrmbxz/lv/YuCKL8FoXG5vW7rZTckytu7ib9IRiRKq6BtgZXOVW0cHEjaqHHMtY/r2ZvPYgrJtaXVV4r5XI3eqZz8abNQPppCOvUm/1wza4YJEvAxM+EEQjnrFD80cS7399ZEXvhJp
 v0WjcS1L
 MPHUpAG5d9qxJ3nFkV+RD7mpvrdeAI6L7J11wyoCoSJ0NmljJxCmYLuDwzFD9dDWpIegN7fULPr2JiDfOwCcu0lbv9SKB8NBHQoXIqSRYdEk/wTZPw6RgCTJ5mxiV0X/5+5AS3fLmebhrEAd1R0PU3TWE9A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    minmax: Introduce {min,max}_array()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     minmax-introduce-min-max-_array.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From prvs=3555e8f33=farbere@amazon.com Wed Sep 24 22:25:22 2025
From: Eliav Farber <farbere@amazon.com>
Date: Wed, 24 Sep 2025 20:23:03 +0000
Subject: minmax: Introduce {min,max}_array()
To: <linux@armlinux.org.uk>, <richard@nod.at>, <anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>, <tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <mchehab@kernel.org>, <james.morse@arm.com>, <rric@kernel.org>, <harry.wentland@amd.com>, <sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>, <alexander.deucher@amd.com>, <christian.koenig@amd.com>, <Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>, <evan.quan@amd.com>, <james.qian.wang@arm.com>, <liviu.dudau@arm.com>, <mihail.atanassov@arm.com>, <brian.starkey@arm.com>, <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>, <tzimmermann@suse.de>, <robdclark@gmail.com>, <quic_abhinavk@quicinc.com>, <dmitry.baryshkov@linaro.org>, <sean@poorly.run>, <jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>, <dmitry.torokhov@gmail.com>
 , <maz@k
 ernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>, <samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>, <rajur@chelsio.com>, <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>, <peppe.cavallaro@st.com>, <alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>, <mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>, <malattia@linux.it>, <hdegoede@redhat.com>, <markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>, <gregkh@linuxfoundation.org>, <fei1.li@intel.com>, <clm@fb.com>, <josef@toxicpanda.com>, <dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <dushistov@mail.ru>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <mhiramat@kernel.org>, <pmladek@suse.com>, <senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta
 @vflare.
 org>, <akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, <jmaloy@redhat.com>, <ying.xue@windriver.com>, <andrii@kernel.org>, <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>, <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>, <shuah@kernel.org>, <keescook@chromium.org>, <wad@chromium.org>, <willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>, <ruanjinjie@huawei.com>, <quic_akhilpo@quicinc.com>, <David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>, <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>, <linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>, <linux-hwmon@vger.kernel.org>, <linux-i
 nput@vge
 r.kernel.org>, <linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>, <platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>, <linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>, <linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>, <linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>, <bpf@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <20250924202320.32333-3-farbere@amazon.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/minmax.h |   64 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

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


Patches currently in stable-queue which might be from farbere@amazon.com are

queue-6.1/minmax-fix-indentation-of-__cmp_once-and-__clamp_once.patch
queue-6.1/minmax-add-in_range-macro.patch
queue-6.1/minmax-deduplicate-__unconst_integer_typeof.patch
queue-6.1/minmax-introduce-min-max-_array.patch

