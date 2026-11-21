Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869D3606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0zr1ZrU
Received: by kanga.kvack.org (Postfix)
	id 993366B05B0; Sat, 21 Nov 2026 14:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943D86B05B1; Sat, 21 Nov 2026 14:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF0C6B05B2; Sat, 21 Nov 2026 14:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59AF16B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:51:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7502A816F
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:51:58 +0000 (UTC)
X-FDA: 85460171916.27.F74636F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4488F140006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:51:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0zr1ZrU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795290717;
	b=eRnv0zeSOn9CAodiU9DH0POSgmcxYTM2z2Ps8DUxrV/JrchHt5Inrcih6qIn9F0COE2B32
	sYWWv28QHKcQXZqZGKIVllvfdM+9BIU/N545TxcE9f7JCx5Yh1zlsJQLjBXDLHLTtePB2b
	x8friEavRGUKSNfVzxeFiaDfqqWEwss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lacc16GR/cOxfo9/HxRF4FW+CuTPCiAe6jg0QMOUkhw=;
	b=bj1ru/k4MayjFUbOFdxaiSH17f/AquP0+PHvu+jKvk2+koNFjtIwCqaqKgetFnuZpnr0U1
	pz/3jLtI1WQjJ0sJWh3zdqukmGqWkJ/aPY9cKgLglYtt4Ip2T/Dzy6iCoEAROG7RaVOfOZ
	nj7SfR42apZhMX3L/ksJ55jCsP9T3Tg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0zr1ZrU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B9A8B6185C;
	Sat, 21 Nov 2026 19:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289471F000CA;
	Sat, 21 Nov 2026 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290716;
	bh=Lacc16GR/cOxfo9/HxRF4FW+CuTPCiAe6jg0QMOUkhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0zr1ZrUvK/FyVOUfqOXaYvsR86ilglrgFjyJfaJOlyr4Yz1nZLtLq08wiUwpEbUh
	 h3DEY57FbywD/BgNE1bhZO22LslxX7gYFMEFS+wZ4qPFZczQyMyb2F36lyjekNyi2O
	 W4cEUevlXm1Uhl/xOPFjJoulp3mPZg6qOOtQGX07x9s3cwolyoy3UXO+mukklVFKgn
	 3UCBhLOTdvmZy66iV02Qo+Ef6V8ngjrAt7ahv06IGm5R6F22QPbIi82jUHINKAmtY2
	 XvN0GmUlkpXWwuOlfuw0qiKSs6YHM3kkAfYzcdo2wYz+ncizn/WD71eXmjVVWEgg7+
	 z0hB8tStVGXbQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Randy Dunlap" <rdunlap@infradead.org>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/4] Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
Date: Sat, 21 Nov 2026 11:51:42 -0800
Message-ID: <20261121195144.109526-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-227319@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4488F140006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 16wt6coy8y9n3cfxhje9gbniqfku6bc5
X-HE-Tag: 1795290717-890404
X-HE-Meta: U2FsdGVkX1+2w0UNGMhVK54AZ5/0EStNR529P5VnrJrWfVl1bsMlDNHy8lyBFn6qTAcA+STGt4tPbsjQcOm8mQk75r0YhRbtcVBGejuawxJfolRjlKC8v+g9SGJbbpzr//2bmLaF/ptBn+d+0Pq++cen++CHyPj2EIbOSpsl+ZyV6EQaYDNEE2IH6UcvHry5GYyfji5jBJsAKzECXBqx6v59rHJI8lSc8Sy5otxPMoyhryVzznV4TDeKaslxlxxMXKEVATxY5ZAvLj+u0bogtCMlZ9MK7Fsxvs3lpBHAGseqOjEVgmRQd0bTdzZrVN24Q5HNCyh8JUkY2SDPUPYRutdTQ6rnuho56fGXShtZ3hUuLJUfq0QGVOu8rai9+avRArOPfruoQM6sTVxn0aK7ZZ+FEZ8eHxOHaj3gqEPXFKOIGnz3XJ/7uPFZ96K07WRemFYkg3ys2uR50gPrc/dkVrI1NWj2ucml0IBqs314BupJ2PJ13yPdz0vumgQI41fxWNgL5rErc3kV3seC0qesSqzF+nlx6yJ/ZGkzEb9+1a1kqvorZaWlbMtFtwy6p8VHa/Fwzexvud5VuDZWHiHRkR7OWbJaA8I31XzGsiDe3UHA6EqZlowsfZCqIaOE9NfQVCdZdZMCbO9FxXT5gZUXgQzftYvxAXGSyZbcZuGPrhshx+/h6Dh6bYTexHroF+/KuMrtUn2/s2LVOcHYXTzT/3MtG0pCmS1Bmjx9DLWnnaBvJyIxzU5i6/n3VHBH8PCJoApdc0Bk5MBoSTkJnMNXpas+2eccJvTAbsDxRbDNx9Lratq2BICcsNw6buL7yvVJFj6WpG/kbfQwBLFrhVEaNNHeBwnX6QDq9x2AkXiUkxtOgH46zhY8ymSdpBbn8LXHH21kKxsqgvhg2GcFQ6LboUpC7YQnq7olAPa/fIBkkPmVCoNMYwswira6E5xPnObmI6Q6k+wrNueDBIyQ8gs
 23l52Ksb
 JitzSKOqXVNREDuIp5jEjy1xN2RLicYMG5FitMX5zIvaToytxnqwx/GDEy1eY5b2FOv8oHk9BGI++2oaGVsNra2IQpXYhEbrUqV3UF5J3KRSo9/RKIzRtG/Ie9MHw4/KESxy4Gv8WYOEsT2zAbOHX2vzKHJe7in1qpa1vhI36CtK0hYNQEECp2Lt8zSwhIZY5WXkA58LOC9k0C5mUBiJIlMdu6sImFRd1GZMokFmzftNFzSTrSQePicFyzVRcVvXgDSf+mkAFjeMarL136n0nzp43p2LYLkMhhf+Es/g7H0ugOlPtXQvStJeHmlbgdoAy1+BohM3el9bsseDFZBzD215IAyBIZSkKKDqg3JLLuUZXteuWCxAunbV3hczsA/ukmW5mN2bGYS2ywZoQ5zLzrbBgEH7pvOVJy1rUF1MfmqTqSJGeAwRt96hdGV7vO2m4WUzYHQo13aAlp2QX+NpTgw8StPfaNHnwIvYmZQPkJexqZtvwCPAhBcL3qL2qc1YDHmnTMeXFo2rU5Ml+XpfR05jtSkMmpF3sjV9lEYhcmVTXLPw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 19:42:08 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] Docs/mm/damon: commit message omits MAINTAINERS section name
>   update
> --
> 
> commit 6bab7534a11559ea9b976bf2b9816f3e4a1d90b2
> Author: SJ Park <sj@kernel.org>
> 
> Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
> 
> This commit updates the DAMON maintainer profile documentation to direct
> patches against the damon.git for-next and for-next-fixes trees and updates
> the referenced MAINTAINERS section name.
> 
> > diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
> > index c482690320249..cc6b79c066a64 100644
> > --- a/Documentation/mm/damon/maintainer-profile.rst
> > +++ b/Documentation/mm/damon/maintainer-profile.rst
> > @@ -3,13 +3,20 @@
> >  DAMON Maintainer Entry Profile
> >  ==============================
> >  
> > -The DAMON subsystem covers the files that are listed in 'DAMON' section of
> > -'MAINTAINERS' file.
> > +The DAMON subsystem covers the files that are listed in 'MEMORY MANAGEMENT -
> > +DAMON' section of 'MAINTAINERS' file.
> 
> [Severity: Low]
> This isn't a bug, but the commit message only describes updating the patch
> baseline branches to damon.git and doesn't mention updating the MAINTAINERS
> section name reference to 'MEMORY MANAGEMENT - DAMON'.

Good catch, I will update the commit message in the next spin.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261121193331.108587-1-sj@kernel.org?part=2
> 


Thanks,
SJ

