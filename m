Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A44A606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5+lXO5E
Received: by kanga.kvack.org (Postfix)
	id 8C1536B05B9; Mon, 26 Oct 2026 10:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899C96B05BA; Mon, 26 Oct 2026 10:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFCA6B05BB; Mon, 26 Oct 2026 10:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 604A66B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:59:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 043B91A076C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:59:33 +0000 (UTC)
X-FDA: 85365086268.07.07CE5D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6365F14000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:59:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5+lXO5E;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793026772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XGT9zayb74NMaQfkHtdMf2rxcAZC1OQzMLQh8262C4=;
	b=xfVPnPipc4Ig0hNqFfYhDE2SdScURuvY0nlLvFDIa8yqhtRDqq/p+Yg/+N5qvmFxnHQBUz
	S5Nd+KwebTXeSECSHUbLUqHXdGruZogeRINt91d7ylPZiMVsEVXIyMvVeUrzDIynV1RfKZ
	pK7BfHmnVUQgv58ChWXLWUtL97GI6Ss=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5+lXO5E;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793026772;
	b=ka16iO4PozB0Qm9RmrIljQKs9z7m3bdAum6Pb0/GvzNZuUmQf6GI3zguc7r3kOPBLu64wr
	T92T/TtxLyFRi6b4rHFmS7E+VRH4ltiB9uOZN/0PnSQ9cOcXYgzA+2g61ShxZHxzjE2mu1
	GOfEW5AFOXQPIiVP/xfWPrYo243nI2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA2AB6021D;
	Mon, 26 Oct 2026 14:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E98A1F01825;
	Mon, 26 Oct 2026 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793026771;
	bh=5XGT9zayb74NMaQfkHtdMf2rxcAZC1OQzMLQh8262C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5+lXO5EpTR35gK7UDBt9Dr29o4Ac65z6kAbDynbPJdj5oe3/UV8IoH5cEByDCTrj
	 z8MQbpxrHEdtfP7wfQD2bdG1cppB70hJUeakAyZaKls7m1GYc0oQd9kowzyyXa6gkL
	 OyL9qwY2NeZiAu2oaD89cJd2RkAlSMN+0IvS6YlIFAhjx8m0Mb/tSMgcJfu4cNDyn0
	 kjTt2cR90jqwR544omfMrplkKXjARr63p5+556Epuk2l8DLXBII349bxY5QL/ToIkD
	 YzNqD9y0KUirtbu6yabSHcwAO7Qu2q/2LOt196AGS714jv02m3PqUfdPC7waeVt5fq
	 ZF4W5YqQZOISQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] Docs/mm/damon/monitoring_intervals_tuning_example: fix grammar and typos
Date: Mon, 26 Oct 2026 07:59:23 -0700
Message-ID: <20261026145924.151190-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179301327249.2.2968995103662294177.damon-docs-grammar-8@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6365F14000B
X-Stat-Signature: tqhcri3981xkxkzf7pxxsd4fhkm718kd
X-Rspam-User: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793026772-753985
X-HE-Meta: U2FsdGVkX1/iFrFKp7D3zJ+nk+c/mabEn8lx1y0SrrOPWBQ2kQQb9rhLueSbnFARz9nH6OGfWrWiUYdFoENPB7nV7ROku5G+xJ9vhQ/TzZTH/DYKjNb0c0BrvsBmBgC7UGsLKsmNvpFtog9CYAJvPfqAZo1YnK3M96qdocBMdvsT0zZcPNThq9pyi61kCIVLahrrhZc2RfmSasMt6QN2snvS81t3Cx3CQ25oTlHh7h7xM0zhJkAuetMdRjOBAbjSXIbEH9Tvrt4q6u/s06T4yratvwgPu3S50beEZHdkkcBvWzWYaqMBuXV2BW7KND3/zEi2doFD6h4gIZ2DYD8QynyRmMeO2PfEwwJDmEMudW/+lqXjb3/B0TBmY7EXIM7AJRk8FzyihLrC+o9yf9DA+NWITjTnhF4APNFJ7+sEGFn0QDnLkVCJwPkjkL951OrHnYueA+lNh/YmLgSc866ysISudtxyCkI0U3UTi5cbzAwu47knJVyj0d+bc9JEMWB+O7NGne7cqe9L4ztAZ9NLvRmAebEaezObjZWRlIaGcooN3uQVcAte/lovJAowXeJ3UG2txu4RjZLzT1ePFvX38w0jUwqK9fqe06Cm0YVAGGPRuoM3n6+IvzbmmcKLKmPle2TpSFkwtw8jdmdVsOIsJEWXTBZxf2YTFnV/WB3ac4dfMI8WHlE8O6iBjXAbEdZ53Aeo4ZpfklOFd0bwKGKy3ydTeyR43ovi2jqykXihq8hz4UFTZ2r2zkLc9NT9M3ej8mfCRbDHMKLCDCrFxLh8DP+UAPlNP8H1vD/1yw1VpuGkvFrcpu/uGoy5JPH/6IWLMcnFmqv2FIHhl57mEqsoAgKzzAtmQtgEfl1rK7RUhnVg7HRDA+N8StqMOOy35hBKjxJX7vCQdE4FYU3c+1UmhmaGrF5scmzFFfJIB3WayT1GHpbtu3BND6InwnMTKjoRsqyt+zyNpfC+zWMVxzq
 VnT1i0Nn
 63xUGtOC7EYzUHC6RAIx/5DnztGrDTaNbbegOgXqeoXexdn8ir1Wid+ldd6Vxs5gNJdmrBLQ5Z5w019/ngP5OrwOYg7A1C4wlr4nq2gdLUVY1uaR3D2xrM0N06LHvAqQoRl6wpyhxcUdzYaXAnWkU9epd926r2eAEKdQ0k98Qq/7yrtw/ZmK8BxWZmiBIJIiOIReM/WPEF+JIAf6P7XSluzVrt9OHDbaG3rCGXg9RBWBKWLzTCxJVKftJQfVHJP7JQNyX1v6vFwktXMM5qtiDMX64iGQNdutVUjWASbWDDW1+Arw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 22:14:40 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Fix a few typos, including "Moniting" in the title, and some grammar in
> the interval tuning example.
> 
> "starts looking degrading" should be "start looking degraded for", as I
> think the sentence means the cold region detection starts to look worse.
> Rewrap where the lines got too long.
> 
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

