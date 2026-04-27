Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50725FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C476B0095; Mon, 27 Apr 2026 12:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64406B0096; Mon, 27 Apr 2026 12:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A15C6B0098; Mon, 27 Apr 2026 12:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2636B0095
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:32:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB3BD121387
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:21:27 +0000 (UTC)
X-FDA: 84704851014.23.1760AD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E816D120013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:21:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHpyoUJW;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777306886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC5Ajr4a4rXVj9lOYr6ncLyoFPtYegjs3bNCdujjCOU=;
	b=B1JvieI4FZ71o342LNTgT0p9/ZermjbnoBVXnFwvHkQlFYujr2WbfhQqX8sZvfGLkDgQfx
	ahGK2KzyuIcbggqLA4qzh5hD+eAYeUXZnlbKwEo4Np/jOvhHCcje/GxDM+uF16V+TElREd
	Xw+7OxNJBvhL+dQWtX7qcJ6pQtR5Fqw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHpyoUJW;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777306886; a=rsa-sha256;
	cv=none;
	b=b6fZvLy3WukqxBx+5Wv3LGuNyY7dfeejHmqI/1tTE3LfZysgXIHgXuwIT8hTT1ytqsNHZL
	l8iWziPO9K7mTiS9GYdh9QdByWJNqtc7v8xhNlL7jHPFR32s2MI2jLD/gUD18bCqIokmIp
	d/qXQbaZhBDLD4aCo/QKKHi0imaJAPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F3343919;
	Mon, 27 Apr 2026 16:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC569C19425;
	Mon, 27 Apr 2026 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306884;
	bh=Qn6KG8K9yrtcG327jkMoStft/n8GyYVwtBTkac6FJZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHpyoUJWSEbFh+Lkh0+aQpZHuWd2gyE0vKYYeDA/AVyUCe21NPRrGQ1fY+FlJn2A2
	 JJx/ZD0h7gFf6QPiOm84qB6YwSATbPZPYyvohxYNXSHBXoNMUWgejdpxu9SyQGvhNO
	 uSrn1EPskbnnZ5urRPGWjQ9neKN4tCOO4e5UnsfaW+W9ysb95OryKPMn/BUu20sksF
	 +5rzCgytas/KkeEhYV0wBESiuUi7YydhnlHljcZtXNWVwYrFvBZpG2wDYbejzQsbdA
	 siF7uJTsFfhS7ILMBAWRC0WSSfT3cUnkDFjrqrJ7Ksls3D+gEzrF/mIFkaeuoDSAxA
	 hXGpByAbc+GUg==
From: Mike Rapoport <rppt@kernel.org>
To: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Michal Clapinski <mclapinski@google.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 0/3] kho: add support for deferred struct page init
Date: Mon, 27 Apr 2026 19:21:01 +0300
Message-ID: <177730685404.1888067.9769034341045819620.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423122538.140993-1-mclapinski@google.com>
References: <20260423122538.140993-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E816D120013
X-Rspam-User: 
X-Stat-Signature: pfyn1ppw1mkzri4enio397cph33ccenx
X-HE-Tag: 1777306885-669262
X-HE-Meta: U2FsdGVkX19vNy6mJ6JRlbBbumXe7ZsdhJqlirWEXD1biAt7R+BCYd930m7g9pb1/MJqcaHhTwrcOKWLGjRSaJCV6D0UgFM+GkOZRE7jQ/YSJapbtbEogzX8VosnhDqA67m9J6FdwCodWc1P4g/b/n/VhtfdI5oT6cJ7eR3p1ThuFMg8P1kd1ei0A6M45FOYXMcJLEU3Zux51z0ZTcwsEi9mJ/20ww18yn7r2I8h2/Rzce+63kM64fJO+2Dd7x/nopf9setKo6uWtixKLEOgJOxT4+uIeEE3DtQT8noKBU1SwmKgoh/xlh6uJJZ6knpmyXp+IX7ZDovZpv/asGI4Fw/Yd85A+DSVxPO7KPXxEDhdQub5NXVRdU5rJz/r+rCghSnRtIm6dyNDOquGhRmfEJpeA1r/PRXLZU3MomnCIMyImbvTxIQglV2b5dHPO/WOxSdF7lr3vWAI5TvOFxL0Nocdleo5mOuJVPOozo7LOOY3Cjil1VIubGFodr5aDx1l0QN407ocpI3h57Fu3M203qNf7DuBZVgsB0WsOlYrRQ/4ZUpYLip5Jfm9yUhWXvZbS6k4AuspcX8ZmNunsW87EoOWiy9Rcd2mjN0Ip9HRvbCb08o166DyHUpR16KhYvRY6NMOXzwiudDhkdKJqACw508S/VFBPTjSoz8YcAveA7hoE7fdW5OUIk57hW0tnp7kXfp2uGMET/As+JP60uKZdp54owFEvjg86aJcRFNqjxNuiK8lAKMljrqeVVpYiP91PYTi4wjXgXEDWoqYXG8Wi/YUMLdgS113I477Un0l8Tc9sP7bKhXBFhmg7qcIuVkkrp1c8e4t6XxYV4yRixLYtGJ53J7v5/LbE9rtTvDUfNFZHqKT8eVxAhMe4dlo7DfrHqnlvewPXvHVWOpKq2qqiQ7vuVZrVboZkeZDZTj7CGe4ckHilmqTeabUeAXYidTwYwVf/yNzwTZuQduLdKz
 5fy+kNYa
 tP+Gs67f56Qeb8IQkTYUvShAT8p20ftUwZxOobrr1aqYUyHDvZcMLla1RTElsaArksnJ19iH7xQX/CKMrpGb6og5wuWZxQktbEL171/pqv/lUNInbYOGQ8TdBnXp17OipwbRc+g6Ax+QjyvQbCy3YnefsdDR6qVWxICRh4cSJOl8oU3Qdza2dTJwKbIFFrfNdigUuCi6/HRxQzEnJzNsewmkHFcXIdv8O5iGQM0bLfgIv5LqbjKcKntMZCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

On Thu, 23 Apr 2026 14:25:35 +0200, Michal Clapinski wrote:
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later in
> the boot process.
> 
> Currently, KHO is incompatible with DEFERRED.
> This series fixes that incompatibility.
> 
> [...]

Applied to next branch of liveupdate/linux.git tree, thanks!

[1/3] kho: fix deferred initialization of scratch areas
      commit: fe60961059eee7a3a303454c827bb347c45612c1
[2/3] kho: make preserved pages compatible with deferred struct page init
      commit: d4835433f4f6b5d618955a6a6eeb3e9f8b2b725e
[3/3] selftests: kho: test with deferred struct page init
      commit: eee13213401bafb7ffe3b447adffb1f570b9d813

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: next

--
Sincerely yours,
Mike.


