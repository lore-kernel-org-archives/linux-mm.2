Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC04CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 007626B0092; Wed,  3 Jun 2026 09:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFACC6B0096; Wed,  3 Jun 2026 09:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F956B0098; Wed,  3 Jun 2026 09:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D08746B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:32:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83203A03B2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:32:09 +0000 (UTC)
X-FDA: 84838689978.06.DFF35E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D4B5C1C0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:32:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JU2sXsiR;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780493527;
	b=hSwDt6VfmEbzkgrrtz/kcvP8iz80ahGXjG08VIN5J7R/ivLeWE4HWYKH9FybxxMV5isWMF
	swnpk1F8GyKP1tp6OyjMd16RU0aSHsWwHE8FptlJlHcKCnnGKSl3h9CTjMjZvAAojuHaiX
	+thEnSqPYlfyXhrPvF9ar2I7jYMfnZU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JU2sXsiR;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780493527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cg+TcWYKH4zzSMQZZLp5kN+E2gVzcXQLNcYelVPRezE=;
	b=w4WqB4OGIYrly7TfnGyBSrvXaRnDk8gGODNSvGmZqSnLGA7u89MWKQpigqManxPPxt9M5S
	iZIxOQPgCazgpBGzEX9BidRvkQ2b89RLTHP2PfnTkML+CPCi3SUt2b9G39KNE8j2+xk9va
	1jPtLAVTPGIqsufo2NE81Q+bx7BeXPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 40A8D60238;
	Wed,  3 Jun 2026 13:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48181F00898;
	Wed,  3 Jun 2026 13:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780493527;
	bh=Cg+TcWYKH4zzSMQZZLp5kN+E2gVzcXQLNcYelVPRezE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=JU2sXsiR/R+jB1usuGwYZ9BkGQPozH+ZvF/mkoXgnW9AWwiWthn17AkDWglmUgy6D
	 sKvP7SS3IghC9HxhVcaGk/dG9dfxglfPxiv48m5CkmN9l/WwewFQD2K0VNLdLuw4f/
	 cYLpukaqAyfBFTsUtgzZVJ9av54lTUEupI9P1/1oGScoc7gGnBOkHlyeYbeyPSFw6J
	 Xm/3tUTPs3oOsLRD0bZ0+4sycFGE98Ix2++7hnQRW5twZkUPI+weT3yZdEvmO4FgRS
	 gGo5UrJwPmDfNAmEYMzodASNKLFmXxOJSA5frYYJ3GeH7FlGD4G0XJCk0v1vF1Spyk
	 wQSkGFQnd0TKA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 04/13] liveupdate: register luo_ser as KHO subtree
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260603032905.344462-5-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-5-pasha.tatashin@soleen.com>
Date: Wed, 03 Jun 2026 16:31:59 +0300
Message-Id: <178049351951.475072.17505666427466268204.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: D4B5C1C0003
X-Stat-Signature: jwoc59zdsw57dbz1cku9zm1534idmr64
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780493527-914907
X-HE-Meta: U2FsdGVkX1+TKlIcfaCDiUrQikJUzyRC9dl7C1MdLtSXcgUxmSHz7yuG6MLBH3znaVeHyMq2Tx3Vv0Py9+BSAce7ROIpxXhOawm+6hAWvDTRk6eddq+QB1/K0XtAalJk87ItL63SFcz258e9HrX95Edz1TzKXCasQ2hGNYxyeDMdvqEmlUNs/CuM6kmUvcGbU85tHiwVO4G+PLNFRfrwde5l4dpCMA/FYp+91+mcFzQI9BH2vB7aDltJQhjnLh2i9Yyj+/pHX1SCrwjpWHrBYgAr/MUrQWazDKjOJJxGtoSLj6hk0sDbdKzS083mzWxjeIXLu/MNYH/mS+pe1fEUQ4rO8lD6IoaIMm/O1am4TE8z7anWV2iQ6491c+NfIsz/l0UC98YGzm0lJFAHkhldFf41MHiMe4bzmns0mkfMkhTkh4ut38iAZF62iI+qpoDUSghEaNbf56W5lpHhrjCHxOqzEJe0X1Zom1eC+f9+mJVNnJW2MlsHIAyJSPw3O6LzAIcfMuzUGKxXNv7WxjcIEZ4OGoUNm2vD/RE33iuT1tNxW186KwiqzbkLcVoS7J2ZPgJr2IpqgzVtsz1CTr6m4cZ44Le86QmnGQWSYaAvIxf6wWrVuxDq+Cn/4a0NPWO3LkLW1/x6Aa3ZIoDkyOIdpVWuZiAk0sByCAnJJEmomMuBGVsKipyvPG/GfFvFe78AXnBu0AIHdiDTxBgGkG6lu1+5VbH+m2Ie5qGMs1JRcnV7nz5EiK1+2ioMx1DeW+QQdZ366SNlrY20aAEdrTiJWBr09UYA+Pu5K3Wopy7RCJpe/fQbBmzpOxQlsibif4nZzkxeFQqmPI+EnF3i+TfFqmKsHaT9tyd3NmXe6jqFczOlKVK3s8A76uHk1uUqD3lEWpdNal0inCUr8NfH4k4fH3xBqb36QmBWA4UEV9tXN/jphyuC82vpCGAaMSdxjAMCCagxNJZsTg22+S+L6Dh
 +qdedryP
 KdzEEU7Arf70PW1HfjDNaFUautjluRlSRe+gf/IKcmOHIBAgmrT0PKSYcP/SUnitvJ0sICrKFeWH3//aEGm2BuYcckJWbuWjY1zI2Eq7C/U1ZFdQK45CjSN/YT4AaJzUXAaIVVQCoNviE0oCbYGtzdYl54zp5cbwwpYiCn+2ye1z0t6jQCvRL2AarAKu8r6JwKgycji5skKMQ9Lqt5gV4T+TvwNxp9kO5x9RnrGWQAt+naNRy3XslxJljw2e2SPzXoCW8C5WFmoRWDcI5CvrwdJbKdeIe/l3664jIFRP5pLlknEMp8i+VTMko/ZyBsq2zGQtgkonj9Z8+TcN81T2aNa/HmryyIy6vobvg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 03:28:55 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> Entirely remove the LUO FDT wrapper since the FDT only carries the
> compatible string and the pointer to the centralized struct luo_ser.
> Instead, register the struct luo_ser via the KHO raw subtree
> API, placing the compatibility string inside the structure itself.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


