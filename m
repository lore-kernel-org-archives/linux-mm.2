Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22483CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92F46B0088; Fri, 16 Oct 2026 12:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44096B008A; Fri, 16 Oct 2026 12:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59AD6B008C; Fri, 16 Oct 2026 12:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A46006B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:33:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0DF6FC04D0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:33:56 +0000 (UTC)
X-FDA: 85329036072.05.6B0947B
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf17.hostedemail.com (Postfix) with ESMTP id E798E40002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:33:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=epxzLxC0;
	spf=pass (imf17.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792168434;
	b=AxJjhaCUbueXy3AoT7PLo7m8CGdnJB5E0Dey/fOCB1e7aBsUATn3OG+Xxh5EpYhfdJO3p2
	2FoKNHbbi+ne7yQVTVsh75Wauxoc6NyUvsr2lp5roE65FcgJNOQHykmytRtm5tKDM/po7n
	hokcO+x4MT4Df/FpbIjrQ8E4His4se0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=epxzLxC0;
	spf=pass (imf17.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792168434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJKrUMd1G0IBo0I8qT/dKyrOBSwsrbO7w6cKV5h30LQ=;
	b=6QXc4IIT346jtlI6ChdQdC6RUfu1IGR/p4Kx9giS9wB4ow9JiMNL8ldXUT5dvCcaQ8Y5By
	o1VtdILOuq0BXAukVOEO+sX4xns4UCG1xa0rqhhno7TYxBo/20g2r83dVkw5XpbVaBRCfk
	TZGlHJkGhDFeEH16ybnNTM+G/7kwK3w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fJKrUMd1G0IBo0I8qT/dKyrOBSwsrbO7w6cKV5h30LQ=; t=1792168433; x=1793032433; 
	b=epxzLxC0XR2kvRg0hyD59e9mBdGcft60t12ej13FnqH/O0yDTbUWQcVIbpdh2ofCSxHF7b+VFfR
	eQCB/cpv6qtEhuH+B3JFnyyJgjsg5bfdqY+2TKsv2rlyzjBcM7xokwXcsje7Gd2HRkBupp9+SiuJ/
	Uc8D9/a9oGxA3VH/CVne/v34CUAWSBCcshIXcTrEs6rgm2gcgIN4z8cglqmJmSAo871x7pnYGfj8a
	cHCUj44ztfXWn85eJq4wFUtfUg3uvcqnAoyjRh5Sg1k7aYsdqcvc6ItXsIl1k01kBjuztngAvHvyU
	tH/zUXeyeheFi7FTJw5bl4o+A3yLIFOIHFTQ==;
Received: from mail-ej1-f42.google.com ([209.85.218.42])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHksR-00Fand-T3
	for linux-mm@kvack.org;
	Fri, 16 Oct 2026 12:33:51 -0400
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c411e139259so8801566b.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:33:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxY3f4YsNxZjEQOqkiEw24PqM+fPOR2mt6lfMxXn0ex/jPYntwzTPB6eGcCySZvfO9UIwBraKkklQ==@kvack.org
X-Gm-Message-State: AFq9FYLLd7Kx+XBnhe/5b6Ue6lcBuhcoz0yjEDYDcvQwNr8SZytEzT8V
	U5oqHdX0+ZrxbehKnH7A1zvnNWBaRyaUWyR/f+RYnk/c913TRjdKzXl8cX7CRMAzKlNrnW1zCzZ
	hLrmw1LrZw4C/aO35h7zTrClk9TtVkAg=
X-Received: by 2002:a17:907:c00d:b0:c40:80eb:c541 with SMTP id
 a640c23a62f3a-c419a05d6d0mr30053166b.2.1792168430981; Fri, 16 Oct 2026
 09:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20261016132510.789715-1-nickolai@csail.mit.edu> <atJBK6hWYh2AqXwK@thinkstation>
In-Reply-To: <atJBK6hWYh2AqXwK@thinkstation>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Fri, 16 Oct 2026 12:33:36 -0400
X-Gmail-Original-Message-ID: <CADGQE7F2nLDe=emG0qVMRHSPGtqDMRB3_313C9sQHoiSRUTQFA@mail.gmail.com>
X-Gm-Features: AclHuK-ldb28rC0chx7CFiWEZ5xqOK-MBV-RXV0XASoMu-7VUmiEbSreuv-EtaY
Message-ID: <CADGQE7F2nLDe=emG0qVMRHSPGtqDMRB3_313C9sQHoiSRUTQFA@mail.gmail.com>
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array after
 concurrent resizes
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, Vitaly Wool <vitaly.wool@konsulko.se>, 
	Vitaly Vul <vitaly.vul@partner.samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E798E40002
X-Rspam-User: 
X-Stat-Signature: ntnz1s7tk4dcu7fd8o99o387mnq1my7g
X-HE-Tag: 1792168433-972199
X-HE-Meta: U2FsdGVkX1/u83vl1souGWLCVJ02qDEITUCCB5u/mTqf7BWq5WJ/ROaQPVyet4rZw8mcZfFqrJmM0D2JbW1BUnT2uvftst2eVmV2w304+rm3z5LzyEnzfgzjluCiOLBZ8f4yi2+VVpsjyRaw1w16MWC/6sARCtYKQB5mWZnKwC42Ti5sD1AcM26K8W+1ix9OQofFIJYVkWVkTyEE2mqzobuJ8KeEp8mVUQbpX0f/jA4k4AvzxB9V19QdHq+x+2yEK8+h057Wx9kHJQa8N9sf8uihwNZVrNuf8UfpZ5rT+aqqwFzZ1EbeMFKZ2gSwlR/+xa8et9gE4rrJhuu0sBAmiBbpAaq13c4479daHrqI+kO72X4ys+O61iJ35cv6F8LLkN7Ih+Z0skgcUy+z2HF9zECONYORfe3FNgKfhhHC4uZZMYaWpQqtodcX1clwwdQ5ox4VY8i/9Bo/jlK0i7dBxklG9XqOVEAjkGfee5koJrv7JwBvwTkwv4YxZ8Z/xzA1ViOumYwHJ6nzAJAo7K5mQ5QeelFaSWWsLvLv3GCZTXKum0DaRmOI/eBEqNXdfr8R86iWcyVKsWeaizOLEzmIgtYoPJCuyUmHXx20IupFr81qXFhJkyGboTpcTvneJn8paS6FxhnL5q6SdFPhuRNFJUICGxcNysza3iSTG5KxdxHHkmr0TDKnMVhI4n3b0UWI6nHADWM+/2CbeEVR5z3ruwsDcN01Zeyz7fgFlrrHnWEL8lui3BOHbDiycinBH7EiBpqkK6PSkDKB7ZSywgTZgriE33aNZ6wMowDhei+nB5UV9l7Y6rBH9QBBP/1vdco+oX5ab+TJQNNTzLskw20cGtA4xwhzfON5yNtQX3dAcmYJDVbSoXoWsFGPqascGTOPCi9MQdLQZ+gZDHYuYBRxBAE00WGEK1gTyF0xS8Rs+hqe2Q1MPu+N4d2elI6pixFlXAgVeLSKVInMjXdz9Mv
 VG3X104v
 ovdMRoo/TTlVjPEiJiNZATNbLDUcnLzxcGyPoqAeWY5LiTaSJAhjXiGLUP35P6en6j/jUyu+Woj0Ev1/FntSN6H55stq4MXr8YmlBQfje8VPwfTM6Ppb9EO4gDgCN0FmuKUMxYZKJvOiE6MRADx4T/5m4pTkXK8wYzuimGGFpm0CG3RCO3DAzfOLdZGy7+GunXgN93165stqYkvOTSLk9mM6Il0tEGoIZ8/lNeQZO14MqQkgwQphZLzDtz/d6zFoVjFmE59OfDjWC/axR5HuRYUkb94fF8F2lBd+C1Q6PVQMdJ8LJg/vT7bvaYC8b4ktHngU1qqwZCl4HNJcSkjJZ+WBJW2ckFTdC8gBSzUedZVDkvCgm0Bc7fPZdOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 11:46=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote=
:
> The bug looks valid in theory, not sure if how easily it can be
> reproduced in practice as resizing should be quite rare.
>
> (A bug is a bug and should be fixed, but no need to hurry in this case)

I agree; seems unlikely to happen, but might as well fix it at some point.

> So it's Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2") ?

Yes; I didn't think it was useful to include this "catch-all" tag, but
technically, that's correct.

Thanks,

Nickolai.

