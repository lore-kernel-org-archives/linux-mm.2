Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A11ECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 23:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148586B0005; Wed, 11 Feb 2026 18:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1295F6B0089; Wed, 11 Feb 2026 18:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BDA6B008A; Wed, 11 Feb 2026 18:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E75956B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:04:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93775B9FC9
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:04:12 +0000 (UTC)
X-FDA: 84433705944.19.25A56A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf14.hostedemail.com (Postfix) with ESMTP id 697D1100005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:04:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J7Gw8YCv;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770851050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MmGa1CbqJVGxYE1KuESaQ10Tgr1tsecMLOOVn9pd6+g=;
	b=4r09Aljuw5s+QkE72mgRb8uEmy7N1VuCqH8/gynv6ksGj4mah6aX0AP+NAN9rCoo6odg1m
	+AKChNPLm/uWkDxl786kze3kh5W26x11LtbJbLL78tYE4KUCAWgjscEnODhtHDLkYxoKr9
	wL4Ad2kItnZsVK/kxaca/wby1i5hO9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770851050; a=rsa-sha256;
	cv=none;
	b=bxGR/E2XUAjNO1R7HkIRx4nlEan21YZSw8WYaldYU0gJWeISe929mk6sg0NFKMYGvVu3c3
	HuIiFqG+gPlCxsPutkB8C44iV3rqGdUBtlKiWueo7RRDSM4LiJaN3t6++ZHy8gAeksjiv4
	fCg4eZqICjOtxV2cwmkSzF0nMHCcORA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J7Gw8YCv;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770851049; x=1802387049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZaxvFvq/ASbYGpBPUtlyLy8VCsLoJtBh6p2oZAoomcs=;
  b=J7Gw8YCva+bssuruMvf/kgfXxlinNPaWyyIz31G83QbfmcVBttQT6Bac
   m9TE80gIktBvCXG8DK80YwneILFh40v5hVYRyoUR2cw/XH02jW/rF0BEh
   SjaZid0V8FBlfUbfn8uOxCcLm8o+3Ut/GzYi/wRJvgjgHuLo4YffYRq7p
   bOcz/7EKkJC5hRk8q+lhTPX4Exp4YaUv4l9s97IprbvdktCI8CLD5OCvA
   9qLcfWXGqJiNFx3pcqEVz50HMEnFjT8hYxcuSnfKsgloc/Joz3LpXOtWz
   UbsHEw1feaFNApghJI+tHP72OkoTpUMiY/cSOXiDbPtqypetkE7IDUarU
   A==;
X-CSE-ConnectionGUID: /uFxZdhhSHuLKmoiEqg+yQ==
X-CSE-MsgGUID: N/0sgdGgS4eaIMAbPk7JuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11698"; a="59581988"
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="59581988"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 15:04:07 -0800
X-CSE-ConnectionGUID: 9MWZRNwaT+eamARnuN22RA==
X-CSE-MsgGUID: AN73fWJcS0avJo0pVpz7cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,285,1763452800"; 
   d="scan'208";a="216883830"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.108.146]) ([10.125.108.146])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 15:04:06 -0800
Message-ID: <9d088525-bbea-4481-991e-94df71e77643@intel.com>
Date: Wed, 11 Feb 2026 15:04:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] x86/mm/pat: Convert pte code to use ptdescs
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, akpm@linux-foundation.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-3-vishal.moola@gmail.com>
 <aYz65w4TP37_t97o@casper.infradead.org> <aY0BddJ9Xm6OsC_-@fedora>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aY0BddJ9Xm6OsC_-@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 697D1100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: je4a6ttghijst1sc7mjdjp84bsrhff9o
X-HE-Tag: 1770851048-858778
X-HE-Meta: U2FsdGVkX1/X8464hpaL6jbHImH3DKP6cT1QpCjraA7sA5togEG8dYQsMlm1poeOcovwxl79YyeuLzD6zB5ki54JZnloRQXgeCRsLOUhihIOQPKt5Ti7axmPAgnmEZKIiQ/gwLA4c4Y72QK8CWqmNeL+ulmgSRMcvFohHGjB0mZi4nNiPmcCxB/Z4mCN5sVWhqrX6KLauWhpq+nYBwFOL9naCuH9tVjrb9ZZOQuJpRFKecxXO3kKAa/pGCkwgemtyUVcgHSuztALp/Yaz63AzgakF8YOMxJuoonXXUbL22nvHg0F1PbWbu+7wuYhmbeTQuXn/hoDOetuZQMKl8KOljw9BQ7Vy+N1Lz0GJtYAQuzfKncAJmK3T7Tk1twuh9BppEP1HBxI06tJLTXp0jOoLkPhQMgj/Cmi1qKXCi7DleMkmwDOMteaJKhtetAxwDgwy7pccXq2ygw2O5GcyVPXh28XNgNopK9T0NhSQJGgt7WbhZfExJnpqMKN/Mk3q+WGSNPKDfAJ/mox9scwq6Z8NLqoO8XXMTWssiw9X48oUgOYjNf7JI7HlwqU37Kt89u4CYTRffS5fHadhFLEUAP/JDtR66nQYGkcE+DcUgiRgQcpjxRLiEASWLFrkaP01ocaBbz2ViYwJXAelCK6MLHbDAi+HEDJzSED6yfb435Ae/CRQseiSU4thq0Vr4EwFHhsFv/w2fIVdphkO9dNDzgfiCl20HIy+lEmANAaMmRGGi630re8f2yaSC+j1etjDjx+OCeakmwHADxjb2IJOyzJWQLcp7Kcu5tbrPvX6Br4UDysh9EVX1hhFAUiRBR23D7i4iO7TJsY+Af7OOZH6d+3jmTP4QDZA9/0yTfo3rkgIysqs/6qjV0g0NJw+aput+CWEgsgQ8XXe2YhkleVkyM0nOkUBF2PVHAdvIA9r5HVefaSrlA08IxKMLIzrr4JiKYXqMMdIpum/sPYw46VRFG
 DytRD7ms
 tJmEQK2HMaTk1iiQ/uMbXKYF4hLaw81Id620TS46cdCloZeewFxJW4Mic2d99o/N8RUxe+Ee0Ey8VQuURZBd8o2QMjep80NsQ/s5ZWVG2m2DdcktZbaGKPL724zCcYTUOkIVwSbRjX9NfgRF7FBnLaN7GOLeWzSJZNy1tY6BY2Q/KysD8RhdQGxshKCveYtpR4Pe9dlvH3PuMPseOmttFw/IrbfA5ACtWkkUpGmO0uRoa9chY/vvkHYFxkgnqh24V8488cW43DxGDnX0QxZFKTryDCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 14:23, Vishal Moola (Oracle) wrote:
> On Wed, Feb 11, 2026 at 09:55:51PM +0000, Matthew Wilcox wrote:
>> On Wed, Feb 11, 2026 at 11:52:31AM -0800, Vishal Moola (Oracle) wrote:
>>> -static bool try_to_free_pte_page(pte_t *pte)
>>> +static bool try_to_free_pte(pte_t *pte)
>> I don't like this name though.  You're not freeing a single PTE,
>> you're freeing a level of page tables.  How about
>> try_to_free_pte_table()?
> Ah, right. That would make sense to me.
> 
> Dave doesn't want the renaming at all[1], so I'm planning to leave it as
> try_to_free_pte_page() though.

Let's just talk about renaming later, please. I'm not totally against
it, but there is enough going on in this set already.

