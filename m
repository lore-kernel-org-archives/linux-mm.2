Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E74C9EC7C
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695366B0088; Mon, 12 Jan 2026 06:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6424E6B0089; Mon, 12 Jan 2026 06:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517556B008A; Mon, 12 Jan 2026 06:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 431AD6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:49:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFCBB1ADF22
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:49:56 +0000 (UTC)
X-FDA: 84323142792.11.F9A887B
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id EF5D08000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:49:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="j HBJR/C";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Q6q1FAMo;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768218595; a=rsa-sha256;
	cv=none;
	b=QPNzlQvhJaqn+g3qMdmb8GOUXAeMBXW4W8qJLnYBx9JXu2tH7xZO7VuaOcswQQ5UUSianA
	pWO/baaspzZ2HKwjuZUEZrJGSmKIdwvrlMytNq4Y4vcv6ia8QfJ9q0y0VrFfM2tnBkOfv9
	dCN/EUodH5zkzcwzP9AtROd5d8cn+qw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="j HBJR/C";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Q6q1FAMo;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768218595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfr7rwNeBEfNjDqxxa6871mVoe7fZyHSOBc+ry0OW2A=;
	b=k3bkMZy/Vy3+y6w/LMumzAGUDdS2OmFt7QhnUupiT87kUDzSH5EiN/dOlTNMYpjezoWtLw
	UqFQem+caiaqG1Fc1YrNk8v1Kv/EgTRvjhOrGhrTyoJ6qDvadQpg51sjRgfLgD5nlvIu2w
	ygNdaYadzU1Y3peVkO9Zsf3cNbUna1k=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id 308C713802CD;
	Mon, 12 Jan 2026 06:49:54 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 12 Jan 2026 06:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1768218594; x=
	1768225794; bh=lfr7rwNeBEfNjDqxxa6871mVoe7fZyHSOBc+ry0OW2A=; b=j
	HBJR/Cf+udrUA67+PqA41njitE3/YL3H6i+zFBmAhyryFgMw3BBwAsN/VR/Ckows
	Q/0yD0WTn7oKLe1SFLfZfMOg7Q7WuhEStq0bXEthvxJLFk343cgM/fHGm1pEtEh4
	8OKSDV9Hus2lkdR7CHXnOp65F/8Qe4JjlGgYngOgPgvFcR/SkoZ848F9t23pZGdM
	qbgfZyGYmLJjPCgRM2ot+fe3QGo+4tKb/fXHJR6bGWaShj8Zopa/Eof3PMRPYstT
	9ZsP7IQK0D5o9bnft3lDrMv7gmMob1Qv021HLW9YgSA0GZivuUNDEEtGkfprJd+j
	5CK4FgGZ3pAKcxxiT2peg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1768218594; x=1768225794; bh=lfr7rwNeBEfNjDqxxa6871mVoe7fZyHSOBc
	+ry0OW2A=; b=Q6q1FAMotpBn2pmHYRbK04OWNmFLJ7qdsiolga5T4Fe0sh8/h8L
	hwFKOdMzb9abW5qDmq5wocy5gK+cOoyf7yps9Dl5pJoDNFVyDqFe1lCSNQrTjNnp
	4paRMke5AVPtTmb0bLSvK0onAVweA6NjqUs0vYzIYmIvrM5QC7x5vYrPkoquf0VI
	h7tFXI5AaBbc+TRaIqCL1qVrkxA/Hp4DUxYNH3K8zOsr28kcvrO1zMc9KEDUBM6r
	VGN10xUFP7HBMHDJxcz2pQDhPKFp4Z6Gd7HhmiROd/v4+pgIghb5nzH/1GdXspnQ
	1YValrA6fE9qbHzY5qwliDpuwyqqZOd1SaQ==
X-ME-Sender: <xms:4N9kaTdYaofvnDJgUUPd_Y3RTrIYBg_Vci3iSlupR2cNnthQkQDSZQ>
    <xme:4N9kaXoKrooVvlMSem9oVuPtGKM6p5zLDLgegYT4Q6Jcxpwb3dudeeuSZsuicvMq4
    AMes1UBKJDitr6V1ZXbiz5R2B5ceEcp5-8EL-neVniMEJRJDSDN6Nk>
X-ME-Received: <xmr:4N9kaTqZaN04cOUZoLWrkLOZ-7Fd5QsnNmoUvS4SAsX_ty_9B_8Q_hugPUJGGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduudejfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnheptdegvdfftdehteelheetfedtjedvgeeltdeuhfdtleehgfdtjeeg
    jeejkedujedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepghhlrgguhihshhgvvhdrihhlhi
    grudeshhdqphgrrhhtnhgvrhhsrdgtohhmpdhrtghpthhtohepghhuohhhrghnjhhunhes
    hhhurgifvghirdgtohhmpdhrtghpthhtohepfigrnhhgkhgvfhgvnhhgrdifrghngheshh
    hurgifvghirdgtohhmpdhrtghpthhtohepfigvihihohhnghhjuhhnudeshhhurgifvghi
    rdgtohhmpdhrtghpthhtohephihushhonhhgphhinhhgsehhuhgrfigvihdrtghomhdprh
    gtphhtthhopehlvghijhhithgrnhhgsehhuhgrfigvihdrtghomhdprhgtphhtthhopegr
    rhhtvghmrdhkuhiiihhnsehhuhgrfigvihdrtghomhdprhgtphhtthhopehsthgvphgrnh
    hovhdrrghnrghtohhlhieshhhurgifvghirdgtohhmpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrghhruhgsnhhikhhovheshhhurgifvghirdgtohhm
X-ME-Proxy: <xmx:4N9kaYgO5n6vHZVn9Yu6rfUE2yg8zQqD0EwNjOyK_Coxx9kSvWdrUQ>
    <xmx:4N9kaTF8RjAs9WhFIqY64uHY6O6M_7zyWAXTcddThoiCYwaKraQLKA>
    <xmx:4N9kaQmcZKfjHuqR1B76y6QzfPbW6ujSsTKEv8tTbEbtyUwyFUcdcQ>
    <xmx:4N9kaeA4gcp2jDfh1plTeGaG4Ffqv-tajh50QPp2Kdets0EndvoeFA>
    <xmx:4t9kac2PE3xoz9mVB2VGB5VCVT4iWEfybxiOEF70scE1Zcnnh2BN1oMd>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 12 Jan 2026 06:49:50 -0500 (EST)
Date: Mon, 12 Jan 2026 11:49:45 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: guohanjun@huawei.com, wangkefeng.wang@huawei.com, 
	weiyongjun1@huawei.com, yusongping@huawei.com, leijitang@huawei.com, 
	artem.kuzin@huawei.com, stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com, 
	gorbunov.ivan@h-partners.com, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	willy@infradead.org, yuzhao@google.com, baolin.wang@linux.alibaba.com, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: improve folio refcount scalability
Message-ID: <aWTfduyPXjhymyzW@thinkstation>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF5D08000B
X-Stat-Signature: epqu7yku5bgbnjg1as8d83rf75ynoi1k
X-Rspam-User: 
X-HE-Tag: 1768218594-24744
X-HE-Meta: U2FsdGVkX199VpRNdEwM5bxMNw5GooL1wC8xqclTGR/yqOexDbwKDgGWHqNkU8eVMOnZKUFBgjCk/2ar52Cv4FpHLf8lWer2bJWqbpybizaJAUcqCo2McG9N6kJ904SaQZC/HMMCCiWBmpODwtUcAnAvLz3eFm7w7wIkMMgRRi2dSwwf11k3wsfs4xim81iIRckIH8KUgLa3H7j7DjH5WG5IT5MMyhkmzAk6Vo8WZiySUgXqEQrxIMWklTeT52GdS8T65PItQotZ2h33CXpY4UyGuLvWvYmKmjBYA6PunaKr4IfliupVx2u9xpeZUbtCQSaCFSvQNCCIK6dRmqPGq+pAZbf/Peq5ZyGn99ZL5WtscX78RcaDH2NkaFJpiRqiknNEwa00LShv1gNVqQTW94bQjC8Kpcweoft459ulYQxSPVvjEupX2Fudg/QaQriFhFt3tUi/54pn7b7IZZSJQdpRD+v3amFoUTjFplzMMYqpm/NkKvP9XvI9de60U2rRMnpLrpfgfiRCPS9JBD9rN7KXDk9r2+ISw4MqIu2q6LLOO1SkXGLXHNCobDFPplKl8TMwYI0/DgbX2AMI2jUT4I8D5uiEkPcRHS/tVhDxyp0sk0+JUyU7aJFdqgvS3c/0BoKLCJgyQ7RCjc3IIMKgRFXyDWNqD4togRlujWo35e0WpYkY+/w9Emff72X3CIVOmmcgcEJ/8AVgbYXml0+9diT9rBNSxr05BHeSaWfkcRYttubb9K5NcyVCYykuXQ6mjzcK9FMPS5Dv7eCM1Osjyj2AF8f4bSiqHxMqnz4Nc+2U1pKPKKYdRxin97bwpHlKOBh4CKcLZr/h61OPAliRw/6iXZrX3mAZKUAmwvRKjM73Gvi1N+2R+VCkgMiV7WPrbpfYkQOq24KenSO2TjSREkg1vH1kS0zB7bh9Aq7xzNKE5t/LcmmPtshGRYiw0K5WsEKS5CmXCjubEQPtYKc
 MhPQYVKv
 adcPkVmQe0bQznjm2EzzaH3glse3qfirrKLWB5CEDHA2igFsxBbAaqE3JyW/9iYPjv26kquVs6IvahaFiLgivxkUO84kz51VP8iFdA2m4UwMf4anxYxBmGXkQRVMXsd6YvAnSzC/aU21NJZuxszlYbg1T70fTV5kD1p6gJ1N90mX5PQlDUbYzSCmGx8LtGBCFDAE2xosBboe+HZWZr5/69xTgzXygvDap53FUCr56LM3I7i0SfOw80sXaTRYCXZiZwhXx/SY1v3ilSMr9CJ5aSkjvsm3Jbl7/LhU6xTU1UbDt8sKBfhWHqYBq6589s9dSvIa2OnfRUeRw253MVeR2Geb0qfyYW7WH6pAksnYVTtseEgMP+xaEVBuUm4IPRO0YczAgfDuR1tbGdeHD+3AiPJmU8lIlJASjBvLQeQf0DL0prgV7rEVsXmtqmC7olWh2Ky3J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:30:38AM +0300, Gladyshev Ilya wrote:
> Gentle ping on this proposal

I generally like the idea, but I would like to hear from folks who
actually understand serialization.

Also, do you have number for "a full CAS loop when the counter is
approaching overflow" thing?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

