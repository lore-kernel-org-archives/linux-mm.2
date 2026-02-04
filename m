Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C298E7FDCF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABADD6B0005; Wed,  4 Feb 2026 01:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67D96B0089; Wed,  4 Feb 2026 01:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9917E6B008A; Wed,  4 Feb 2026 01:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87F066B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:06:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B17F1A06DC
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:06:52 +0000 (UTC)
X-FDA: 84405740664.15.E38E516
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71D8240013
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:06:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6pDqTIf;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770185210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFDVggU2Y4zYIw5mPBf6KrhqPL/xBMVfQOvvo1nS1VY=;
	b=nb02fdLvW+4sXlCKCluILF0Ddeaf1zxGOS4A+P7TK7vSY3Gy13Ltj0Ini4h2CHxT2rjgci
	y6RlDxsC7SJ9uKVMhWEQtGgrWuQoz94MYtAAR96G5hXSwEUl/yUrNKF7EAGXve80qunfWM
	/yExgXr4KnfYco1QXiX35Hauy4l2dME=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k6pDqTIf;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770185210; a=rsa-sha256;
	cv=none;
	b=qMguHNmzas11bY/cxvXiBLSCBof5eVf5hBbQUiNdtOEx1IR3ZULTJFYxRhZOGhIu4p7fzq
	Kx/avh7ZDWT6gNe1m3qCTB4KM6M5XxH0tBmY8FpqljYPdcqH18g4qxLUzoHdkFWfWzQBO/
	nF+yjKhLNJJWthfQIizmGjRVg8soENU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 398C14088C;
	Wed,  4 Feb 2026 06:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9261C4CEF7;
	Wed,  4 Feb 2026 06:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770185209;
	bh=YDx6StxtpDi58Lvtwkex+sore9y1zO7/lL+DfNC6Sq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6pDqTIfKYSOHU297/fPjNP2NvQ2xMkHZOQq1eSZ1tF7slzQRnBqZSAx9mYGWMNTI
	 aDngLHWLLoiXoqHGUhdRuHyDbRuNrJgxWYqT8TAU4x5KHzX9lYalnmB66IJxPn4QWH
	 K14oTzSPh9cCeq9Yl4j9WgXaUD4G3zC5q0gwicfMNIjWmuW8v9rpHGL0XKeqD+9c9W
	 0HJv99ge8aOev5BnLoYfuzMuj4Z7G5idL05MuBDsByOXgguTSzazN8od7p6lg6+fcQ
	 QVxH6vkHAu+0zW+TsFySilcaTUZMRmRqtf0JyXDeJg/jLhPFAEheKsbVC7RNbdjv+0
	 vJp1A34Yv4nxg==
From: SeongJae Park <sj@kernel.org>
To: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	kernel_team@skhynix.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for
Date: Tue,  3 Feb 2026 22:06:40 -0800
Message-ID: <20260204060641.97191-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204022537.814-1-yunjeong.mun@sk.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: putsbudtrs1efn6mpdgqkpzd1drqnk4w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71D8240013
X-HE-Tag: 1770185210-156881
X-HE-Meta: U2FsdGVkX18Llnm8vyacZbNnWRg7aJxFKRFG67pn7Zl/k6v/3Xcg+23vFNwHd2ccUy22GPsNn3Kk2pbIJ3iEZYMfkMaB8A4cAB5A07VWmoTDsVxb9ZfzBqSN8MtFVM7GiZcs0vVWJF5aeNeHYhHJp4fBTggHjGpuVdOLE3vRUmj8ppTbwx0Ew3rWtPhdWt0YEI7OjxnH9MNNQg0IWtd1J49+ZNkjK+NjHENGC0mBlIIWXALkII98yk65JgluBIBcBdDiiqC/mS0JyOTErfYFbyNgCjDYZ4xCv8IGWFT/uP0U7X/hjsbaD1zSxFivTF6Vp1AGXv6ItNV/YgobHfCiuq01y6YPn4DB0Fo7nkQ6V5C/UFUVtUVqI0OvD90NBDm7Z7OfBsg197ol7FixKzme3I+NnaQGYCEn9//FWnZbaanV4vvyFc6MkNps9HORw6UvhbfZ3EVAv0PdUehHUtAC/8CxV0R0ZxXJkkQW6qpmQHUfahn1qumQ94DnL2w2xRqivn97NGc90/yfg/gMu9Egcy/fWqGhldXwO3J2J7gEZ5u8u+4DhADrKjsctEjBn0IkzisOOn/WBxvbIbOrVLCTBUKjJuvGiOp+XMhJtAFua53qdaqqyVaX3y0Sm/8xLkwQIvp//o7vM1TiYg0Ap61ff1oldchGCilxuOh2h1jOEcF+TcuVWO44Z0D1detdGe8p47o0/gSpkQe9po0C04CVrryX8GUJybgTjItrvNdfWRmif8Jpu/qVh0LKkUh3VofaD8vpNq0RHKhXs93mD57PSYA/Cw5AN+zVZGSZgQbzQ3SLibC06flPPqDg4ZtjsV5yuoqEKS9o7rFGwozGEdm/04s8s17VPF8xFu23N6EjgsUtg5WNovW2npyFZgU8qHK8fIFx+2uYsBrogqrt4lo9sYFYGaqfUCV0RnyFj6WvAwUufukyEdHK9DxHiRrbA5mgqJrD+Z+PFkhWTLSr+ux
 CxM+ADoh
 +9aUylT3hwkJrFPURbwbSYz13G6x67ycnPrjz4VbCzyZ+AFz0rSfprvKmK4caRb5g1mk5EkAX+glZr21ODfcs6Y68gb44BkHqkBvJBK1NFwsMz0m10oZy37ocNrDsMws1R8ljdzSY5DY0ZrZDvTUebxlkSdhgZf8XOoi4Vbz7KuA6DfHcIC09mJ0vZ63SKO2O0uAn2mmhEmKgKAXKQ1SYiNCEFBvaPlHuKmygg3jhNqdfAcrQJxu9+xyNia5qI4XvkRfrlTqo5hnvJVRFGB9JjKZwJVNA1hbeSv6fBRkbSJ3tqg8t38PYdU/JcjcVgeMnMXF4Pmc1V2N8vh5lGykapogwMbDZnSXi8mcdgdE3qeISFrwU3JmWW7OTPbxYBtqPH2bp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000016, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Feb 2026 11:25:35 +0900 Yunjeong Mun <yunjeong.mun@sk.com> wrote:

> On Fri, Jan 23, 2026 at 05:50:43PM -0800, SeongJae Park wrote:
> > Cc-ing SK hynix folks (Honggyu and Yunjeong) for quota auto-tuning behavior
> > confusion (not stop immediately after satisfying the goal) I discuss below.
> > 
> 
> Hi Seonjae, thanks for Cc-ing us :)
> 
> > 
> > Please note that the goal-based quota auto-tuning works in proportional way,
> > preferring small steps and "eventual" goal convergence.  As a result, migration
> > will occur a few more times until it is completely stopped after the goal is
> > satisfied.  Unless there is another scheme that migrates pages into node 0, you
> > may end up having node 0 having a bit less than the 40% memory.
> > 
> > > 
> > >     No oscillation - migration stops when target state is reached.
> > 
> > So, little bit of oscillation could still happen.  Hopefully that shouldn't be
> > significant, though.
> > 
> > IIRC, SK hynix people also confused with the behavior when they experimented
> > migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tuning,
> > but using only a single scheme that does migration in a single direction.
> > Because this is at least second time it made confusion, if you need, maybe I
> > can try to add a feature for making DAMOS immediately stops after the goal is
> > satisfied.  Let me know if such new feature can be useful for you.  Cc-ing SK
> > hynix people (Honggyu and Yunjeong) so that they can correct me if my memory is
> > broken, or answer if the new feature I described here can be useful for them.
> > 
> 
> Yes, you're absolutely right. Currently, esz(effective size) starts from 0 and 
> esz gradually increases as `current` approaches `target`.
> Once `current` reaches `target`,  `esz` then begins to decrease.
> 
> However, we observed that even after `current` hits `target`, 
> migration still continues relatively aggressively - because `esz`  remains high, 
> and it takes time for it to decrease.
> 
> To address this, we previously suggested that initializing `esz`  at `target`
> (or something suitably large value, rather than 0) and letting it gradually 
> decrease as `current` gets closer to  `target`.  
> This would allow for stronger migration when `current` is far form `target`, 
> and gradually weaken migration as `current` approaches `target`.
> 
> Such a feature would be useful for us to experiment with tiered memory system :)

Thank you for confirming, Yunjeong.  I now agree this is what really need to be
implemented.  And I agree your suggestion makes sense for the use case.  I want
to take sufficient time for good design of it, though.  I will share update as
soon as I get some idea.


Thanks,
SJ

[...]

