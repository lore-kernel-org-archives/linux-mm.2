Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E228D4A5E4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 02:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC47C6B0005; Thu, 15 Jan 2026 21:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67846B0088; Thu, 15 Jan 2026 21:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9534B6B0089; Thu, 15 Jan 2026 21:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 846996B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:18:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6C86591BA
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:18:45 +0000 (UTC)
X-FDA: 84336218610.07.E38D1C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 392CAA0009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:18:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPTDAJ13;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768529924; a=rsa-sha256;
	cv=none;
	b=pGprx0C1eCP/nQTMhbmG6h7oabgcu1YcH8XlqwvcgzS9KTNQ0/1+Q8autbJ/iUl9x1Gf/3
	3bq3Ak9i5LXZZosO/uNjKfWIfjucRN3xJNyz9YgFP2tdbRG+mXhvn/2sgXm9B3H07tQyMK
	z0DyPRCZJY/V8B9+EKNb5dB810MgILc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fPTDAJ13;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768529924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrYeB6FwP88E1cVSomuA8fJM7drO5+NvPdMEgmwLbTs=;
	b=XzxyvD/7Htynw0ZHmYAhcUsvXtbEL4QjmIpko+6hGFrygW/GE4JZyV6Q1EhMQVoiSAzvox
	hsI79yNbtNT5T/pfoQVwgvG4pa3RhVGYWUS7UvwK0udDdz/vNffFwg051WaE1IbG3iqgrv
	5EvxEh3mKW2BvUsSjIHTVdDUlqOLLUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 372AA43FAC;
	Fri, 16 Jan 2026 02:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61F3C116D0;
	Fri, 16 Jan 2026 02:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768529923;
	bh=xGlwY78YgnNbg3yS+LVBBKRA+TOB2qhqnJXMmBJVQWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPTDAJ13Mve+x1u8jgmEeoGS4WDvjrP7KrYW3HxmWZTXqVCi2dJc/rOgv7H8ds82O
	 1R8PeGdcoXBmm2psxQlZpWlh2m49WiwjtZLwMTsNT0EHfgvAI0AwHdC6g42Kd5Yewx
	 SoHzScXpKaMLMaZfklq2B7rFUv5qXKYYnKSa/wKDVQbDVtfZs5Ao//PgCMJDSFY8N9
	 jCHeKQdjx8pRw15XfLbtf7Qu10HI4vKTbL9pYNjGwtHfF+ermolFnR2P//PwHyq3AL
	 vTBVyrwR4v1cbFm1S782F5numkyOC1890a1zxTgvh1lSOI2BL41urUp5qaFuU9MaAx
	 jVUzMSdqDs2Lw==
From: SeongJae Park <sj@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	akpm@linux-foundation.org,
	kent.overstreet@linux.dev,
	corbet@lwn.net,
	ranxiaokai627@163.com,
	ran.xiaokai@zte.com.cn,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode
Date: Thu, 15 Jan 2026 18:18:34 -0800
Message-ID: <20260116021835.71770-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAJuCfpEQZMVCz0WUQ9SOP6TBKxaT3ajpHi24Aqdd73RCsmi8rg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 392CAA0009
X-Stat-Signature: z68gjhehkauittsmf9n1buz6fo98zodz
X-Rspam-User: 
X-HE-Tag: 1768529924-415472
X-HE-Meta: U2FsdGVkX1/yppLoQNdNDzOquoZQAaPpmJ9sWRvjBjFEzXELoFAPNepjp7wfQw9fPiVncJKkwQXNuKreWA3GEs5VX2Wsr8Hfne28Zy0MPVkh8rQYD6Lw8VSOXIymA/Vrg/Z/BcoQwceSc7sBoHxtcksw94M3qO/xmM2SwM2QEpnsohSwuvwrhwaPMVls4ry3mCQJSIOx7LcheMGDc9zEmwPTbjsWOE41cU1FTHsuyM1/aR22H0G/rVUdMP1xZYMOyZ8u+KpZ+vU648FZX9OuIvPjQ63RDDx88SdKw6xOwnq3G5kHiaHPthydKBu6KUN0b2P18lsH36vqY5x2Z0yoF8EdbLxOdc1QmBLAQhrrJcFt2QrmKz0xd3Qi94q70mVF+iV0aOQwXAeptI2Y5q0veh/V2eCGcxGOgOppk5MHtRpFkh+rHbZnBhSs7azt29c8QPeK8hpZRNubi3T2D/zrKlgIRA4bQjLoYaRe4CkwcGCMUfj4rUk/TWbFmX3kKmoT6eXpMuPXxwN4dn8jjuVoPDQTXG1B1/xXQbJiLuhjJS9VnI5sL0aNLpc8KOwqnwEZPgRlnq6tEmNiPbRsSMU9qv87FGz8g6jtAkkvc8t3u539JTXofiZrGYCnplTQj0MWvtDwIf6nOz8jL4sgcwnOOtT3sbit2QQFN45s+33r+HWdzyc1lfAvAMa4dkyqm5YZVrj3lBPK/e4p+hpTE8095kU2wSrbxZeTkvL95cEmVtQ+TbAD6mmuNUh3+afCQGPIkuXY6pt9pHrKGCz4akgGN3efUYsTDSTIpwbZw213j3zBflXu9B0x5ujEpaoGOSCA38Yvq9J0elK+e/+WsUQADGlysCiXuyhLgxU1jj2LQ4d/UovVp3a5dJJWX6Zq39RX/dQUTpSFbxlstWwm2zSTBA3Iv5p9QxcSd/n71nKAQwfSas4RkuO0BjZ7JI7rFfHSEj6ML6X5Iq84G9SeQFk
 5vDJ65yF
 JzHHDd1GG2cEShtj1vfx0oPwn+1OX6PpFPI6W/JZ+UokpsVqpcE6g2CSVIckwZmUBvb3wsBWJBqyl0DcNOKWWLNNKYx10VvZzK3HtBj7Xcx1Nt2bKlCFVI/M3JWaRJCowEklu681gAVzvH8KC7VDrE7XDtc9wqIS05duP0sRv3DDRWmiwZBBUpvwiGUB5Qkcak0tvxIe2yd1r+RNHtO4hPdap4m/JjPhCEJC/5UZANRxREqCxs0UMtYFDHH71dfu77Zdicy81nSh9wiNen1R7fDN/qxp5Gun1XfzaKH+AfaEEAOywG7jtKXj6JxnhP3EDNUUm9oGybyj0sLTXgDv8o3imbmUy8/45+uzN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 09:05:25 -0800 Suren Baghdasaryan <surenb@google.com> wrote:

> On Wed, Jan 14, 2026 at 9:57 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Wed, Jan 14, 2026 at 09:45:57PM -0800, Suren Baghdasaryan wrote:
> > > +  warnings produces by allocations made while profiling is disabled and freed
> >
> > "produced"
> 
> Thanks! I'll wait for a day and if there are no other objections, I
> will post a fixed version.

Assuming Matthiew's good finding will be fixed,

Acked-by: SeongJae Park <sj@kernel.org>

Fwiw, the typo is also on the .../sysctl/vm.rst part.  And from the finding, I
was wondering if it is better to put the description only one of two documents
rather than having the duplication, and further if the 'Usage:' part of
allocation-profiling.rst is better to be moved to
'Documentation/admin-guide/mm/'.  But I ended up thinking those are too trivial
and small things.


Thanks,
SJ

