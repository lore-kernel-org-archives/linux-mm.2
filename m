Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65D61F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 16:31:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE68E6B0096; Sun, 29 Mar 2026 12:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDAE6B0098; Sun, 29 Mar 2026 12:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA8D6B0099; Sun, 29 Mar 2026 12:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADA776B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 12:31:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D934D13B0C9
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:31:05 +0000 (UTC)
X-FDA: 84599640090.28.697A66A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5758F120002
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 16:31:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dHG7ShdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774801864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+q5vekc2WltDoktuyDQG1fEbX/Pne8fCO9uTI0lic/Y=;
	b=wIpz/xghAr3it5qtiXTLrsQd+VkNVgrr6MYLIy4zVASwr0R4iw7SGcTE/P+1RNOYigFZaH
	pib4PeRN+IrrOl76YN69zo8LDh+7R/CZd9/BqnrBaKhRjq3QiCJqHjoUQIFa2jscCEVpbl
	DuWuK3hjGrbsWlakhibFCuzY0dByBoo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774801864; a=rsa-sha256;
	cv=none;
	b=oUpJwznYhozAUryRvy4RuuEsTApf6nyn4q/RHNZRGihDn5C8U+mgjPIUG09ncelkH2SPet
	0RnD4g/D+qwGRTxQLdKIuN84j13MerLKuTsOWOLjGxpvSo8BZmR3oYrBTHqYfrs1CXj6JT
	kVWn1hki3NJtVjlBdoOjZrCuamk8nIU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dHG7ShdT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D906460054;
	Sun, 29 Mar 2026 16:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD00C116C6;
	Sun, 29 Mar 2026 16:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774801863;
	bh=jfomB9Uz3yQOLGJFFYlU4E/h6qSYhn0UQnLbpdiUXjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHG7ShdTq4l3d6sHIW1dKby7NFGmjqzGd+TXp57D8BVzl/iJVCDKDzB0LI1tnyGxl
	 siLf+hTFcVFIh/pMHqOdC1PcYNjRxbXsDjrf+6njnToTCRJp7j5DP/ghiyhDYQvQtR
	 zjNa8XKhNh5twdNNd1cOdEGd8n0YLYgz8OFG0QuFx54mB+avi4B1uVaiuji9EKRmKQ
	 OMcPOhhHK/BawZLeRvMH3KSoRRwM10J3FAyFsjCmCr7NRPUlw8qCTU03efBkaKpbkn
	 figLIapySep2Ym99cd7Z8BkaK4EzHJVp+GHr6IEL82cg1Ptj7Mc/v1257RdRhn7C49
	 XDfuDmqdwwvaQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn commit_inputs vs other params race
Date: Sun, 29 Mar 2026 09:31:01 -0700
Message-ID: <20260329163102.58683-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329154917.47598-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5758F120002
X-Stat-Signature: 5sw4i1tr5fr6dosdf87t7ndttod3xap3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774801864-710261
X-HE-Meta: U2FsdGVkX19kuEvL+2Y/q77fAXxnub8w89SLiW+utS5iT48lSiOAieE8e1Xk6tUd2Cdak3N/iJVt7sjNAQ/d8teETbSjzExlaH3Xqvi+7dvorJBlZ408d5dyUJZuuvZ3Y0iPDBtkd/fA3SW7Q8lcfD+44JWlN2xY5ltBsog5h7qJez1e2cxP/dB3OBp09uPFGyqcQD2BP5yO58uCzBShv1h4JVH/95t5wDrGgvwj1Pmb/PkGpG8FpXXR+RsWA42zr1e/FCOS4FrPmgwfrL0dKzUJjDA1nBYVXhVWwjY/1a9t9EFlGbMAcP60xtdPYk2ECjAHegSDAa4BSXqbKtjeCyqJx1WqOEfjBc2I8N86WJnBGoeemIp8yK1mqHuWxiQ+M294muV2t9xyVuNizAP31RMBvapNUGWLDmO5idJRYszxpFsvgJ9PO50LjHW1uAdxsaRHBWHwIRq4Fxk5ZByx2kUVpdlCEgiFaM5nFQWSAh/Aj+eMvTkmRRvJvPO7qPNbmpD+/llsg+Bj1lHrgAftq42db9QD2RYyVPTf5IkwTGYgFWVkKIbOnS/VJWDIx70hEo+Vgl6XvVWySxWfBm+u7i8mJtuvP5W+ITvN25t+8eY0LLlKahAymGThW2IT/kFDG5QH/KkkfQpWf4Ng+QU1oquWWZ7Oz2wEwHoxhgOqP/2kBKkBpLvoZRFro7T9nLorYui4Oake9ao8LWqSyys2IKushSgWQEhC0F1VempeFrW7uw6QICRp0lv0CvmdwDSlG+N414rLA2TPDFoDVAWdcNEY5lZTRbRR1e84c52A2HyUxisO34QlmVOl9IrQhtpginj+2GdLejy2F8fEcjjCOAlDc/H4v1LPtPP6zwZQvH+Jtbfa0aZDtgd1PA33jFCcaq/+wxoC7g/JyaNq3n0Oa4OitDEHTuOFOn7T8QfrRqq8NqZLSou6a4HSQ0mN6HmfNZ3lflBhTjE+FuOWd8s
 Sou1lNIg
 6SLEl4HzS+OOsDb+6vhzD2gJxssFEP0lefk9j9X9k3yqUj4FrTUSGNeFMZjBTujXBFQRMe4eSq0scJfZFVxgEY8l2SGos1oojEK+oZE2TB3o1CEOz/tnKGFtAKo5GKf2HerJAZoJpLQxsgTD9qe4KUrSO/tmklCD/rjhvD9zfbNptH04db7y4Jx4tezvjLUnMFZdKq03Z3osFjT55BF/AEALo04f5FKUC85VQGAHkgncDtOM0aRMNWD6dtLYuadyaGgG+CZSvBTOthjkLKyruKKmgPGdJnsXQ3zanAHum0UqgVOngrD1xHcncs06QKVQEJeKlfE7rMbL3LsNsnaqFewmpkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 08:49:16 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding sashiko.dev review status for this thread.
> 
> # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org
> 
> - [PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
>   - status: Reviewed
>   - review: ISSUES MAY FOUND
> - [PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
>   - status: Reviewed
>   - review: ISSUES MAY FOUND

TL; DR: I believe those are not issues.


Thanks,
SJ

[...]

