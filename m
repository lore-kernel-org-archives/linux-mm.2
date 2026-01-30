Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46244E6BF20
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2DE6B0005; Fri, 30 Jan 2026 10:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0456B0089; Fri, 30 Jan 2026 10:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AC516B008A; Fri, 30 Jan 2026 10:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB2F6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:44:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAB18D453D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:44:05 +0000 (UTC)
X-FDA: 84389051250.12.4718345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3F8694000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:44:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/8K7XTe";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769787844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxlkvUNgHBZIt/kwRk8N2mm+e4pGDfXUWcc4AZNlRks=;
	b=EbMPJ+/H5oHGk1/W+sIS6reG4I9J3uReij977a1KvvQUFk7Xuc6NsbxR+s5UQXcgXDbpQp
	5Zw2/t8r79QbSOo2JIYycrE0Fm39AbbNG6EVCMKSj/Wye4WvoumOz7uOU4/dKsNx4fHXes
	JT570oyq+gawop2WVhL0+30AsfpNAy8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/8K7XTe";
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769787844; a=rsa-sha256;
	cv=none;
	b=S3NwrqqTDZX07rhtvVZvoOmwpygO/Tlp7rTCbQVPEW3sAnnwTPvb/dKtKdFu8fbZvY+LxJ
	qm5tkhajCHtK4NbQ6d/FpilHEOMRTmNH2b+5QR5KqLKgfZCiFdWowTlaFZZdEE58kUs+Bz
	/JpPAsywc1ecbiohezUzioiw/waAfgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A7FF16001A;
	Fri, 30 Jan 2026 15:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48290C4CEF7;
	Fri, 30 Jan 2026 15:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769787843;
	bh=dwYtLrPFUWzsdRZijCrgxVOKvCrrHbwJHagwewUlJLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/8K7XTeCjOi7IBVRmpSdHddjXnj/3yMYkeIFqKyCcafQt9NN+2/Ff9csk8aeWjZb
	 F1ugQinEx3A20mTBkl477lQbfdfWwuGmWNWDnbjy2dHAgHUVZAx1vQXtDrvEP5xoFm
	 vWqzqtNaYntqJg2dSBmJKCYkR3Pqj41ZpfanmiBtBywtXhUqqejFpE0wwguj/629zh
	 Fl6lqi3k6Cu4J0xxTc/PtRS1hMK//eqzlDKovlnjygZa2n88XdcdiioVgqPd0v+nLJ
	 4St7j9OJ8LjiCFVbQiy61l8IGLt2F9oRaGcDSVIwC1k2QA3+w+5rzgIxej87riM4h8
	 8fjyhOCr5xQxA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: lirongqing <lirongqing@baidu.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: remove __read_mostly from memory_idle_ms_percentiles
Date: Fri, 30 Jan 2026 07:43:48 -0800
Message-ID: <20260130154348.1094-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130153813.784-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F8694000E
X-Rspamd-Server: rspam07
X-Stat-Signature: upka1ey63akxfnf4nowqduxr6z34td9i
X-HE-Tag: 1769787844-811029
X-HE-Meta: U2FsdGVkX19G6BvJjOckNVCLB+LjqO58U4vZf5JlCsRajKCAJT0Q9rSY4IpECvaUreSvStZY3JwUK4nYLbQGszVMqWcYwqmhuNInfSszbfSVbBd/zjYdOsoQFVcOLGQ8XXjjTXpFZCAJTIrLeVPJAvsWwXBstOLrTmcqHGXRU3w7v8PL3D1xeqs5WF/RvSU5RHhfG6hba6twvRpIoNUcD7XAJyWZSJX5cyxl24XOmhJa3PP7IDs2UwTAtaF2bkhbIhziYf9M+Y48JKHzEjcWkSSVy2twQrLIGOKYe/O19S6vYCyfpgECgmOphENjtLJr9/VOV7yYWMxFeoz0DJL0BXXF+q1U91wcdJsToVJUX0PO2A5UF1jASNstb3hIFtScRSGygi8I9txl7nb6XHBWnYnBgBgbElmFiAIjFEI/7W6NLnb4l0kpgJ9TCP9chqW4GlzaA9X3mu269kR2M8hQm0mNAzedXbVftigStvphAmrMxcZC2sOJ771RQPAVVlezlngbfwBq9R/cxBS8w/1Q1Crych+awaikmPG2jGhjozPaRAekXQpl+AvfSFvpzwBldktLo04k3N71SPJFKlgxiSvlYMZPrlCa4j0yuobQKHW1wvZDj1uYTvG/wSScBhIyc2hcOdflDKl7Hq1FAtdhXUCJSY8Mc0C22JJYrAwa6atzTvLZizVS2oHnOzbAgM4qYtWpujfNCGfYyI9/6AJHzD9EOVU6x1raJaHnQN9XyCZNI5jskSe2FKWuEVIn0rx4yfANeyBg8GO9+fFpH5ea0pYTaEuoPkWlKh99YVQ6mJeTuPdtbGQtV5e8gK5kNasl5Xj825oZ0GZtBo6gxTgLoIvTb4fmlz3bZAbrg2xhRPjnUAYJFlCYvSBFwC4t9FPK2rTPBRuOUfRmpjETocfXJgB1L/pdtoSvDvn+wn+nAAC4654/OEXyoA4mK6vCZxMOxYpkRPx3iVjEskZv4B4
 mIqUiFzA
 2lodhnVslGyzHtJhjXByU+toKprstRGCnC3r8n6RKI5dXM2TBNnKjITaG6vm0G5N/Bhd1ZjIkIrQSd7GSoXTpKEdvdVPTUcU7oJ4GMwnHVbHc5eJzbt9sIBWIjEnpp9KsL3yCS6w9aMb9COEf+FuqITrpxGWpe8RunrYN9Q4cZjLc6Z1mg+KymbLyyvLCaclvbQeDySjUCSXxjc39yu6Q5bbwON6T3mizDOfeDpZPA6zY6ar7H8juFArAwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One nit.  Let's use "mm/damon/stat:" for the subject prefix.  Andrew, could you
please make the change when you add this to mm-new?


Thanks,
SJ

[...]

