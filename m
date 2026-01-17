Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0094C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150B36B0088; Fri, 16 Jan 2026 20:21:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131E76B0089; Fri, 16 Jan 2026 20:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033E56B008A; Fri, 16 Jan 2026 20:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E88ED6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:21:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EFA81AE50B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:21:56 +0000 (UTC)
X-FDA: 84339704232.19.5E8FEB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E705E80006
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:21:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AypgwY6x;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768612914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijMe9IoCGALr0uEmQFimYVQgdAjGEEnEDAeuPSmEq00=;
	b=Q/5/g5ZrIT0Uh/Ln/VBEJsCo2uMeCzgw6mkaYa6X39DHcJjKrq/Bi+Su1DNWGv00sb1Kdo
	ITWjN2Tdf7WRd3hsMRE020mmxi7kgJjZf2KgqfJJlYTUsFg5w/+I1sNg2pxKfH4NkbeAp0
	ZIgi1oZEdNsuh6MNj0guTMs46UnhodE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AypgwY6x;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768612914; a=rsa-sha256;
	cv=none;
	b=OKYgs+/h7CJSvFYn7h1Q1pRwhV8gQDfgLKWMLqg2sJWeZFRuqbBI/UJzUNsmz5bFvAkNat
	v9WHEUEMlQXN39rJ19JIzeB+7hWkmFoczg+YT4dsA3A+QaFpel0peY3F69GQtJm2YJK63y
	RA3p4LqA0eeYK/tcLgapDPLIS3BdFYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5364560156;
	Sat, 17 Jan 2026 01:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0333C116C6;
	Sat, 17 Jan 2026 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768612914;
	bh=6xxMF1nF4gFfiAabY8bBSiHZyIKO9vi3p2MzOkcN4lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AypgwY6xtKtraBu85pjM4BHwPQHL1gZRO1U25ZRbUGgvO9BBiA5OR6Idyypbuhc9y
	 oqgTVz4aQ/D/ncN41RYp0VPZgyI75z5bdONyF7epuUSv7WPh/bUNVpdwHp/UqCfUJS
	 x9DZOpbk8yf7WbREHWtT1bf0mVQyI2BrL4s9UkMj/zfIcNZWFh+G01NfjduIKsfY3d
	 An6X9zQWlfzHM6lOC8LFc40Nwye1wMMx3Qe2Gs3pwdzKWSjq/eqFKILAtGiGYkPWz1
	 C/licmDrm6cziIvMeOdlxmB8srXbY4SRMzMw9koB34jimYHMES+56JWu71ADMrIJvN
	 r5wHsNzS3PHnA==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] selftests/mm: remove virtual_address_range test
Date: Fri, 16 Jan 2026 17:21:40 -0800
Message-ID: <20260117012141.224053-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116132053.857887-1-lorenzo.stoakes@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E705E80006
X-Stat-Signature: grktuqw4i6woeerh65b69gmn6r65iade
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768612914-569927
X-HE-Meta: U2FsdGVkX19pgB6Twd2q81+S9rLU+iiwvZkXAjgrzSkUibTcnCCAHbL+Gy1VQSWGJyQwW0t0UzxTKs6ndUnOzuBW/jZ1GKXaAMyU7CPK7Jxdd1+2gK5l0CmGa1gsCRbrP7bhL3XvFUoOXY8t3AC/J+Ur1Mrdnc+aXSMpQl81l3aZ8QsDMhojsmKHqY+hrsJ3MwYku9xvMOIUh33CtLyT20H41jy9yA7Jy0OidXbvRQjeSav/ZwNCY77BoV9hY7FnQi0H99zd2n2N2QCIvO7/q883RzaLjnDJ3vadHr1h5rYcMwK0fICsGaLi9lrHrPht9oAYsjRVxkSHeIohiG4IUTYPrBPaYfaP7syOZrp3lXQ7f1iUPUJc3YXuZYhMX+2ZXsdl+z21VGYtaHe2wEcgLbeb4X7Ayu1gBVp2s9cGKRelqQUEi1jPpKdqcSV4c5D2StelNIflAQRekZyZJDpBrkXGwMDgwRo6xXW2WZV1qcR4EAv1Q/CgdJTTxXd0+CSDspvWguGcUnO3YMHOpkSd6AiURTPLiLIEQQels6vptM9pc4Tk7d4E9gB/DVMWX6WbqKXWBbf332zxZX7vt/7lfq53JjA3GRHh0RB5FRmOStDM1ivMD6rDNBE3jXgXasT2HTQU251JAVRdUiAq13Rl2NlawftsZJlXtP2v38giz/iAO0Sn2hZ6kmNaZ3Jbyncl3nXgfGSFz4BdnEL6lU8TPNRB4HsNw4/gQKdxMywrzD9Z/O0QPyPPmKJy2AMhxne3O8ok3i3mFVCnznIC0AwgE5dRDGiYBDPmn1Q15oc6w7SyvoSmsYSwrVkoUkXa9TPRssfUz360Ut3Ab/ET1ZG9WzXqX7Uhf4MZuixT86+s4O/TIEk235oxzmHbo96EPSOBz/FRCxRgKaBl51u0A4OfK9r4hgtdSPXqUobJaAiMoMqdGebx85rXFUnWh+ajDjgjbq2ScOOuE9v+6et2sgZ
 RIqGbml+
 2U3E8+7ZxJCwh5mo9NxM4i+ifbylLH9V2iVzYttWvv1zsgiIQudoW6caWY4dPkc6acMMHPKw37VzGrQjAJ+3jMQOhYPzRWf9FNb6r9fXgkbOO4yS2awPwseaUl6h9vKzIbb8naRktyYBermKG7OfBQZCpFWs/bGokqVg+VfLYSy0mjctdcKyMMTH7aDfbvopbzNzKwA3VRF/2pOy75shtqEl+DUyf/IR+ohXVCJU3wqwExeMArHyBHQ30qWZyfEN9ZHqgSM+WFVZyWqoG/mFQsA3+CJ7M24Vttoq1F1cv2NmjsdGAdV6dUGhEMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 13:20:53 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

[...]
> It therefore, sadly, seems that the best course is to remove this test
> altogether.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

