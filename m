Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEE51CA0EFA
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4416B0026; Tue, 19 Aug 2025 21:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4CC6B0028; Tue, 19 Aug 2025 21:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594516B0029; Tue, 19 Aug 2025 21:37:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37AB46B0026
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:37:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5BA782F1E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:37:35 +0000 (UTC)
X-FDA: 83795423670.28.08642E1
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf20.hostedemail.com (Postfix) with ESMTP id B972A1C0004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:37:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=oh5JW0GK;
	spf=pass (imf20.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsaNmFeTmmq2GRfNcvc+yPDBROOyO4EEuBRnYKRbDAQ=;
	b=6ttCQQ1G+zOzIqdQzrsEM1bIKuFcGe0oNdMIUI5OAZKFugl8b+KIqlmYl9odAq1Y6uDiiM
	77ZeK6byrj9dkPfUv17W8cpPTcpApVKJ6d93PDcZduF1PRXre29fKZn68r4JhVKgvDAy/3
	NWBCyIkONjLXlvIAk4p3V+xDuJR1ZG8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=oh5JW0GK;
	spf=pass (imf20.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653854; a=rsa-sha256;
	cv=none;
	b=PJVnAooCY/PRlpIcit0O4YCJ3NnC42P4ds+UMc2cqAd48UFTGdgdkmuIvtZgs1xItPo9C8
	p9XQiqNSOefhl4iBOOaGmdetAPE8f46v0FGT4AWxkZfAbV/IIWSTWHf9JtHMDpwUZB2YUF
	OeQ+vYXvNjVMnJaG2cx4t0+ODRlGNKI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BsaNmFeTmmq2GRfNcvc+yPDBROOyO4EEuBRnYKRbDAQ=; b=oh5JW0GK0a0+MvHZCxmDOlPXnh
	nrq1IF2UbdTmiETHX+s/EFf/HdRvqEEyfYn4+nC1xIIU5g7ajXCPxuuQN0/E+0IWRHHhwlnmtwbCJ
	Gl18tTbVBF0LY5/upym+fV/kLf4xw8WLvmxrsI/gqDNMaZLJosVKM0FvVXh2zpcJ7eLkTP45qW137
	0XYKSv0PdZ7O1CvqDVofRwSj3V7myIlXI4oHE0G1yF14p4xvgMO28Aas43QQQYoU3fyQhcRJxsehG
	usM2EtNNXb1OpdFSkGt0c1DZNnITkhZO9Ln2o9Wm8SdInItoBE6YA4m+OqzWMC8ZNNZyfPUbbtwPq
	ai31HGuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uoXVu-00FfzF-0f;
	Wed, 20 Aug 2025 09:37:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 20 Aug 2025 09:37:14 +0800
Date: Wed, 20 Aug 2025 09:37:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
Message-ID: <aKUmyl5gUFCdXGn-@gondor.apana.org.au>
References: <20250819193404.46680-1-sj@kernel.org>
 <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
 <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4z6YvQULrEmNjFjLNrJ4RK6w0+d9uF2-7v06gOYirrYRw@mail.gmail.com>
X-Rspamd-Queue-Id: B972A1C0004
X-Rspam-User: 
X-Stat-Signature: zjhdb55b3b4z4o6jra8naqc8fgngdpm8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755653853-300851
X-HE-Meta: U2FsdGVkX1/hFZpaIKEdCEwirEVJgu0aab+zW2qXM4n77qBV/uYYHjo7DyxZGIbE8GimLToBcUy9f4tNqlXZTjI62Hj6B1oSbpD01ab3JJA3SjawtmQK6ycX4wBVayZx/q9sxBE9CXlUUOAPmLEv854jmZQAgzDCieeORwP5n2W661q0c1W+KM1zcgLJKhNi+kyXQOWpP24fS0iE34iK6+tB3QmkfTwlPfy1YcuyGAvLB7r58YeZpDDgjlTltDz8wavix2reQBtRwqPOR4QBO4Yg06fUk7LZMrT8AZCEP21fRKc4j2bSRDmZsvinVWhGGCEPnXSHunmz/GV1j7s9jUHaYbxU7Ccz8hm/wmAEagycZ7izGG8esG4IXSqmdc3MhDECr33jl3oyGK8i/ePhWxXFGJ/Bd5bxIkjyvfGyvLnr3pAkco3SnYg61rXhyJGunpfAh1CMZZIbyzLqjL4VqjoxeQtE5n/2cDZvRWPSpJ8iJaUV1HoSPduHRHQuQWyqtV29PZcR/Fqy8t7Ttf5Ibr6ydQdAkw9aMG0c+O0yoPkWg82uAeC2fdCwXh+blT96dD/xFezqWzy7M+cjFobFQFyfCM1r2B4o2Qhx2s8QVQYHmOxhKuDL218e7pJiztl/En9PIZPx4Mrhx9t3322+gIg/cI5J3jbL9cJhtutbXfQodp3RqktoJKxVt3U5hWBfkQisFP0BmJMTE2rMQTp5qka8V/pR65v9X1rVa4Ld5XPKA3B9Ott35q9/LtTRDrmUuGel2xdUlPAdM79tPNMrOJecQ35S9hs/bnMfvwoW4yFiPIJSryassdP+MFSimJW4caQAATt9V99ecUFQXpttlPHaaJu/x9PCJ1/nJT1kAoV80SURXvfD6DYrHayShOdQHaJgzvdnKc/46+JUCzZnarZ4NqzuEAVZtIeQCpskeBkxt9QNCt+UUjUu9dmdGBpmsrb9UCq1VDX3enF3NHf
 EHW39Kpi
 H/IYEyCEdxjtspcUnIWE1tN305k3+dH8N181p4xuSsG1hTLJLknDEfg4fmtwFWr+Uz80hCeGvBR+GABfcuPKjs4g7PfiKCZduioYpZZWtpoFcYLW/Gelpa0B1b3Vsea+UDYSgqtrGNWaJ8l0P1IOJYgWW56I8lBGd5XA9keW78i0gtb/Ivlzd+OmLyZF4et71iwFeALTbQtRZ8aIV3bjlFSdzRfj30gZGEVoRsaGniGDa8gk+wVptJ94eLWbxD2QJEredIA179/dj95qnxjNkn3e+YY7PWkWStELUJuixOfI5eFFy/nWoGPBuU/9jAk52Z98v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
>
> We might want to revisit the old thread to check whether it is now safe for us
> to move to PAGE_SIZE in zswap now.

It's perfectly safe as LZO was fixed months ago.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

