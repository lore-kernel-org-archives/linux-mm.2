Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1AD0D1F9B0
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D1A6B0012; Thu,  4 Dec 2025 05:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BDCD6B0022; Thu,  4 Dec 2025 05:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3226B0026; Thu,  4 Dec 2025 05:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07D776B0012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:42:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE8E68AD8C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:42:15 +0000 (UTC)
X-FDA: 84181449030.26.A43826B
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8D2BBC0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:42:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=ej4d6w5h;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="G rIG3KC";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764844933; a=rsa-sha256;
	cv=none;
	b=BcSxdIOd1PJl437gCBuyy0L7wKvcFbfKOa2gQKoWWDMrjhPcp47e1jq/fr16rKkV5ulagw
	s98F7OYgy92EOR3XEqWhdtzN4xPJDRvGxPJKTnXIyEmIYXNjGjVSE0/Q4CrJFe2oBGR8CL
	MgDJbsGF5ySBQK+U0wG/BGd2kKfSaFA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=ej4d6w5h;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="G rIG3KC";
	dmarc=pass (policy=none) header.from=arndb.de;
	spf=pass (imf10.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.147 as permitted sender) smtp.mailfrom=arnd@arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764844933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDUbjRGhNQ+ex3d0yzoBdn7uaEh3KYB4pRVBi/l0gRI=;
	b=pmD2K70WSyGVYJfgFh2bAXipSJ7pImeb7Vwc6682yxaNlP5Ky2iLeAg4dV8/hy8yH9VjZJ
	vORts7bsByfxy+aKh9SIngyqOcU/d0C/AYzMsQoMP2J1cteZbCbdYlJK2HFn4MRMfMeg09
	SML4UNdbz1F4p8zarp3egCy4vsJxuEQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 57E231D0023A;
	Thu,  4 Dec 2025 05:42:12 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Thu, 04 Dec 2025 05:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764844932;
	 x=1764931332; bh=XDUbjRGhNQ+ex3d0yzoBdn7uaEh3KYB4pRVBi/l0gRI=; b=
	ej4d6w5hBo4HK/pK9cS4NgLSyQRoOblysrFrMuA4i90aVjPCg6oCKBsybn2h4nOK
	lWxrlFM2e6+w7tob+4ov0HsE2NinH3kF5Jsrs5baB+ij+Ci1EtLa2cebHmap3Kbg
	iGqTaRWZL7N/e3lFPVk5yu5Q2tuzLeY9o+Scp0q+q0YKSU51dTFOWzOTiuxWnA8/
	lFzCMdu6R+VzCFA+KBHNCuocLHK3DBsEMWtxNVmTo3GSDvjnmaqMUGAqcOKvKRw7
	vnnduyyEk6DmXX0Rw9iaSc1h1hTD0zi4W9eDgvre5j8pb245ruSTwTlFeFGvet25
	xwLcqCqOCcEV4Hox0OIdfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764844932; x=
	1764931332; bh=XDUbjRGhNQ+ex3d0yzoBdn7uaEh3KYB4pRVBi/l0gRI=; b=G
	rIG3KCbbr55YpBoP+3q+rR1NTDddRv4aDMX+jPTx9o1lBqcGfpXdOu/yn7q0sVmz
	SLo0tQv+I8w8WEsbIFFJlAFZDMaOo7RtkxxulYxyRtOxZ80dwwuCzDzKVUy473aY
	bM4qagwEE1CI37mLN7Twx4Hxi2/SoKVB47n9ECER++Q7PBAnW6VVGeUvj6XuF1On
	P/xK0fibJwc/NxNOj2aBiTaaKVqvt2uibKmUpwMRYQO2Q4itwc5Av6A7G+DVGkAt
	iljGZXtsvg4ImWO1CaZGh83u763d728IdWIVt/IemAQkP3VdhOl7HgQqWoyZUIsD
	c/Ei3Qe9wyW3ih9bcs8tQ==
X-ME-Sender: <xms:g2UxaW4zM2nFjVihmnJ0mgaNNaVtIkkRPSD-85qZtHSnMoKB4sGglw>
    <xme:g2UxaauN-HOWEXI-NUISIqMeaUv8ABajTn0K-wlE5EIJS86PASpmnta6rWZoK7Tj-
    B3j0X0fhpeMlPYeVQkQ7_LmWoAdLpXV_ZF_WbPcIi7IBhF7PDIrdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    ephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepudehpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopehguhhofigvihhkrghnghdrkhgvrhhnvghlsehgmhgrihhlrdgtohhmpd
    hrtghpthhtohephhhughhhugesghhoohhglhgvrdgtohhmpdhrtghpthhtohepshhhihhk
    vghmvghngheshhhurgifvghitghlohhuugdrtghomhdprhgtphhtthhopegrrhhnugeskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphhrrg
    hthihushhhsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:g2UxaS07ApCU-jNg9pt9Hi32QgwcKE-k1nZfMXbYVyB50-M4Y2vr9w>
    <xmx:g2UxaUjEAAEwxEd9_xaPuD_rna33UItEoGrnlXaHRytVRImukD_xJw>
    <xmx:g2Uxab9HNxQTldRwmLDPlD8TLeV25lCvNiCX_6pso4cgKUYhJtSp5Q>
    <xmx:g2UxaYKZvT8Yq0dF5uzVu4-Hmvt7aXoHH7lw5XX5PpFCRtqbpJEHJw>
    <xmx:hGUxaY1RD4WsybU8zcOB1EOsg8zATRuPmJMFTsYjwCn6dvzjYiaoZM87>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1A8F3C40054; Thu,  4 Dec 2025 05:42:11 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AovB6anR1n37
Date: Thu, 04 Dec 2025 11:41:50 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Arnd Bergmann" <arnd@kernel.org>, "Hugh Dickins" <hughd@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Kairui Song" <kasong@tencent.com>, "Christian Brauner" <brauner@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Kemeng Shi" <shikemeng@huaweicloud.com>,
 "Guo Weikang" <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Message-Id: <998794e8-d8b3-4693-8e56-cbac0f2072f7@app.fastmail.com>
In-Reply-To: <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
References: <20251204102905.1048000-1-arnd@kernel.org>
 <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D2BBC0011
X-Stat-Signature: tnbk5rx6c4pchwt7egr95rguks9rw6kk
X-Rspam-User: 
X-HE-Tag: 1764844933-261886
X-HE-Meta: U2FsdGVkX19md7iRFRg9G/lYRWbKhctTYyUAuQRpwS1TROj+dNSpM7Ex9coAoraP/YFOFjq7tBgqVN2HuNhTISJ68f9VKPMkK0mD1hCmqvFnlkHYzGlPe8bK0P6TcreVvbAsqhvrWUA3iNy59X4owjkTX8YCuMA9knD8zJvSb/OqYWt84PnyY2LnZtlRVQKzIT/Lk1glj8U3vEr3kEzjuQEom9OsqzcbZuY/z7c3CML1m8iBqe12WiNE524MuBkzrjfAXKTTIKQysRlbj73BBUt+fNo2dN1+In0AO63R3SO6vRW5WWGAWvSW4ULTszYYD2hGqizUddqSyjskRW/uOZ78No3NavVZ1El1nvMol8eTGoZ+ZJ8wz9EOS2LtnCtnK6R1JNRSb3/PfdAQ6EJa9Wx3yRKlWqOKrjW8iPKyPMrVQNvTIwkjYADdmFqVtbCL1SYkGs4QN4kLmn2QtfVZQR0iUoG/ffRR69dDwdLSEpL2CFQ15odB9G9Ed79UNsJguV//yHRbCIajjjTQk6A/9M1CTyyQSE0ZaI8m4NYRYsSjKblhETcsv+/eup18B+3DiTIU1YAGYcXTJDnYGl+LYr93zCGQfZZKBahYoqI5eeelJ3Fzzl9nHH3a1n8eoXOMb6541fNCCeTxuLTr3R895/XkZ7TnhlHWFUXdS5ajWTbMHcVe/PFXiqHhqYmMXZ+6NR7yDRHb+FLau2snVMdhlHEYfd6fwachHq4UTfr9dCk4bRDepI0kFWL4c796G/0unTtaO25plovLT87C+CGQ3uJF1U2qW5rsIGo5lTE01DS3v7AXZ3m2b6iVrEbZJBaGk48t0NUNCGUg37VTa4FAMGk2oPMlCdfwoqXDlEnbiClZRtuXD4zMkROpHm57tYzPGIvdAwf1pECeigQYHj3ribspuSMEXiYAKmX/ExrDFTemnswGmXk5/pWcHxXfqYRQa56n/w3l0h3/13JNpea
 Wtqu/Tal
 gFX4VxkYoPnGLTnj8urEYMtqnXs9ALMPvqxKVoN46wfbRKWSsD+Qu83FL1tcf0HZTbQ+C+KIhjbkgXe5kybM5N7QoXADmbOdL5ka+aRKWnpS7fx2ohAxtBxou3oQPHUh49is0s+YyHuHArdrTIyQ40OauoQcb5Let8elLkT9wdyVHxB+NElBpwy6VIGTwgqZh/zVw/DEH/eQUYnijew2PZYLs4HLtgLnHRiBymDtUAjnYajtbURCmmX3HkOGiM1ytTO9xkdp1sbaiBINJWEBirjPFZnIlp0pEnGlPBuFzOiZtxYwauM4ROaEb3hTArYJ0dp5RwwzsvEY1g/YUR6c1O7q0kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025, at 11:34, David Hildenbrand (Red Hat) wrote:
>
> So we can likely just squash it into the problematic commit before 
> proceeding with it?

Yes, that would be best.

    Arnd

