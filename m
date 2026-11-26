Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E6A4606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 09:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=F8wGvLSG
Received: by kanga.kvack.org (Postfix)
	id D63536B05BB; Thu, 26 Nov 2026 04:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13F26B05BC; Thu, 26 Nov 2026 04:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29EC6B05BD; Thu, 26 Nov 2026 04:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A28EE6B05BB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 04:56:12 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D518A87C7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:56:11 +0000 (UTC)
X-FDA: 85476814542.12.B4587A6
Received: from mta0.migadu.com (out-43.mta0.migadu.com [91.218.175.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 730C940008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:56:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8wGvLSG;
	spf=pass (imf01.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795686969;
	b=bpv9IDk0iXUx1eGcE3NMeoR+PlhBCwgp3eVExelOiaoL1iAMZuZbecP6pkmy13ad5P6SfQ
	rhtdGtI4BIajG9Zust36sw6OUdtaJhoCYs2y8PVzW17zsAsIslnb3+lLpKRqsIeFTCSSJb
	7l+xSrmDPOMMQ0djyxdemtmZEk9JR6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795686969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQcIcei88kUqCnw+OzaF/BPCcNprpGmpU6tq1V0AoeA=;
	b=VZV3oH0kSpkvmO/7BkmYUR7V30uJoWag813/RrGqVehL7KPs9VRt0IpP0ydPsCX09a7qgk
	Mh+rS/WVXLX8qnA6XO54hjALmn2Svx1KaIURpcwASHhKRXAtsYQyWqPulQPE1MdjSc2fz5
	8mm2wj+3FtWS6XPy4v9+3NGGLKuAtRY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F8wGvLSG;
	spf=pass (imf01.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.43 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dxPJpYyq7fmjNCgcazcTAlVEtnKcktGtMN2JR/cLLl0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795686967; v=1; x=1796291767;
 b=F8wGvLSGGHwwvClbV9xt7ors1OyBtyBOwm/iNTdtdHmTT2CixXnH5DbsLdPRDcSIcJZjLuH1
 +u0Cqp4PaaEBcLGqVaIXTWmJmTUajjIL9hzhav3KscOlwXkg9UuY3tD6xVWQFxCbBqhEVgk6lC8
 n/QJM2rprvnaWIVjvJusqC/4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f274d0239c21fc85;
	Thu, 26 Nov 2026 09:56:07 +0000
X-Mizu-Trace-ID: f274d0239c21fc85
X-Migadu-Flow: FLOW_OUT
Message-ID: <0ad1c783-8ddd-4f55-a08e-ec1e690f92d5@linux.dev>
Date: Thu, 26 Nov 2026 17:56:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/27] mm/damon/sysfs: implement report producer
 directory
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-8-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-8-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 730C940008
X-Rspam-User:
X-Stat-Signature: buwpg16ahhzgsu3tua1zt4ns1dyt73ow
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795686969-421463
X-HE-Meta: U2FsdGVkX1/OoPglTFg/TE7mDlCXePnyZH5i1HIE44P6CXTPGo3/Ijm4KY1+09y5tDlbgfRYdyoG975uLFz4rCQIWz6FbCghlSmehofmp77j2HZPhtr5wEkk334qEcRjBgLyCxhi98O3UzvoEKppWAJcC90aEWguOWptWBF2w3e5t57Rlo+mOgQSREDW5Ez0LQ7RioYMAE3CiOnW7x/DA0v6SDcwaJTFnazaRjd4CDYgHmR8RhoLXY3rsvocrQOrqVRpKe8mQ/vx4WWyK9WIHsnAQhMMUsQerjpq57RNJF0/tz4GJtaKbnKzNPenQV4nnmlGE8NRBlxpDy92OVGyZE0YLEBbbGuaOb/00wETr1iVWDvV+yru9eMggWiISM4TZBnFGpyuZVsIdDYg7UE+KHhkq++YLgdLPbhFYWw+KPmTVGBOx3VFrOhXlH+vzoXyzo96OEErqxHbOwGlR85ZunGfSMTwHIsm9a9PTYCQ3iW9bSYMlyeavKY1wneQzSITCYAHDDUil40PKiZDPDcF0ufJeyzUUSjB5sfQrbausEakQV0m5KCnw0c23OvdGl9r/0jp2Vxrp5Vv7yXdlcAP6l6KkBHVyS+66u3eGm8An4ICj99rmKpVVlYlb8mHnqOYAV9TprMUp1dVoLV/XG4HOwzOJFqLdmvc7tD/7kl0LiCerWdro35eGvCVhGxO0GNEscw+N3QdbEqLYhrCjrtiTp0YnwpCbcFOysA1F4FnabrFHf3YeG/tMeGeq00wpd+L0J7a5IFm55EPop+quqgidRXVNU9VhTFEDhzl26sQ3npWDen+IPquEPxqPXxEmgho04MUf20SJjU40ZfYkOR1aVxvdanz8M6324vzJsxA9PPAixP/Pphb57hVI+ddLyastndOndQJXPJAvh4M9H/cPFR19nz0/tE5/fZvi2sFMM9hTy1jCqsfoLS2oGp/zAQ0CzkYKB17kBfCK/DyR6n
 Xe0+JmIp
 qh4kDQJnhLpnBtn/nTrcyYRG3tJ/mugQ3ojxwsXGe/oDgxINSnNEVsSfXwum8hIDLWnWH9W8vm7E3yPfrHC3pywauX8jUp2Sff8ZiJJ03lCrp82qXEH2jIGhdw+/XOT3pbIa3RRLsYHjtd9cZ8rvoi45tmbrTcvvmJoNexpayv7g43kvAzMei1QdRl+6HI360zXoLbOUl4U5SxXt+hkIYMhwJ474Fg7SKxYkiRsHQQ/Lo5YEuFy+uXJNvxY+zzjLSk2zoyjxk400cP4rgF0rdezJHS4m6NDYM1CTYhx0FnfpeqRFeaH5Jewfxw6IPM//1kcdPAck1RJexLqHM6xVYmCfuiuqOOLXbHQzMFFWFhez/FqMKKuluLrpv6SzAH+CmVjeNPmMdttaMtWxy1h73lap4aSwAoik6896RGFcS/IS/McESRd6ES5aT2vC3cRchT2T8lXzXEkkmUZbs/d0M+U4k1HqCXbz6ORkI+SKxf1Eof0L1ASaODqk9maNlJFG1ju31gHXX6RWSDByuGJ4wvnbFniFq7DtKzhN1m9XmJOkzGGlRK0EVLbJCecQYK0wfmq72S7ZNj17jrtIEXbms0iN3/K62tQ3dlwgARDpQcQHMyWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Implement a sysfs directory for each report producer.  Create and remove
> the directories for reports/producers/nr_producers file writes.  It is a
> placeholder for sysfs files that will be used for controlling each
> report producer.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

