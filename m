Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1D3606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQzoRCH4
Received: by kanga.kvack.org (Postfix)
	id 1592A6B05B0; Mon, 23 Nov 2026 09:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10A6B6B05B1; Mon, 23 Nov 2026 09:48:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F9D6B05B2; Mon, 23 Nov 2026 09:48:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D0FF56B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:48:28 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 669501208D4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:48:28 +0000 (UTC)
X-FDA: 85466664696.30.50210D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3D27C000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:48:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQzoRCH4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795445306;
	b=pXnVV2cYU9YWEXhzaY61mgCk9RO+vdcCO9OPC66vdSy/X49qAsEshTPNYLFW0awKAQwzfv
	snQjRPLatoeOfZsvKgCgJoBn09FKWRLkZw0iWJ3Zvi0BWmBXpsfPGLeEEnc/iVjzDCNv3j
	AJVOzrnaeDq0Dl6E/EJf+w7FNiK1INU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795445306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJ3P4mBUVy41qNcxI7plDsGfTdz3BhWQQIugrNMcZRc=;
	b=REriL+xpgKpBI7YD0vru9d2P2W2gId6NlZReIzHg27LzhO29g5MvMWx4dikKYOY990KZs7
	/Cuv4rXW+XEyhmN2cS6vEfaAXMANnuRzsD1VbeD1jRivuDBCi+AUii169JfpsebIhpyhjK
	6LQ2C0R6WF+w7naxO0nLhhT7eIM+zh0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQzoRCH4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D28A04076E;
	Mon, 23 Nov 2026 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1FC1F000C0;
	Mon, 23 Nov 2026 14:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795445305;
	bh=WJ3P4mBUVy41qNcxI7plDsGfTdz3BhWQQIugrNMcZRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQzoRCH4BdAdPYRHQXArv/qj4IGGIGykWokCNRMIgp/SdNn+qeMBjgOoRVJkLCgvC
	 pv2f9XCF/58/29WtKNsTwKNpSPdpn51eazUR1G4blpwTaWVgSR/ByKkVBxfWZyqeMq
	 tV1QWZ/fJ133l/Josnqmd9h9iB4/lISzgZpQ72alvT3h0NjBXhV0yoJWtU+prVWxBR
	 8tsqjBIOzsGPKtybB2stL854tYpi2f+Ircge5iHHSqilfMxrWyGIctT6GKipeEMRaL
	 rx1IWsdyAYI3UaZX/FGclvu0K8Hlnujn3GhLFvDnBsdJb6QJwryfnAIG1Tz94/ePAj
	 0oPosEg2bVnLA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: vbabka@kernel.org,
	akpm@linux-foundation.org,
	Hao Li <hao.li@linux.dev>
Cc: kernel-team@meta.com,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: don't set SLAB_MAY_ACCOUNT for KMALLOC_PARTITION_CACHES
Date: Mon, 23 Nov 2026 14:48:19 +0000
Message-ID: <179544526759.3606123.1000047458494853310.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261111125628.375624-1-hao.li@linux.dev>
References: <20261111125628.375624-1-hao.li@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B3D27C000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wh4z6ura4stpespqbfrdjon8kkpgqzfe
X-HE-Tag: 1795445306-708214
X-HE-Meta: U2FsdGVkX1+SF4iBWHrM05YVyQOPEW5dsyhePc9cTL1M9PXrNEFBbVHUMvGfPVBE2LXsoI8sumXh9SoBOGawN5SlSQqnALpktRnGn3+fH3byXuuo0pB1tfl4gEMNoyilVrOk/48Du35BRD0Th95rCeizVlFZX0yfWdpW033xwfmTMK3v/yVrvxZCupWzFQrq+qpw6PkoHz9I5Hn3kw+JeomY0irlGzTlhjWUMA0cHJLpc8RYrhql2vjBtTDWcqfgp0JcwA6Ygu3o4rVDQjTTAlIHjp8cl84NaP25yJ7jCrqdvhwtXEy+K1YWkzoMgcSkHNI+4cWXkt8GvjqmA9BNLE81JEiomt88PCtKSxJZmC0aXyVVWxY6ER+y2t6XqAcNmcnRQc82HGWKPuyWf1McHsevhAbPLpLTbKeLa3DQNO27waytz03p8Ovvcr9UYKJMSqweNdpuSMYkp917m+iY9EUqu/crP2xkB1VMy5NjDNMkk/p6OEXhTQlgWMG1i9IXOXFaDf0+UmXOz+xbmPZw9+H7VKZ3MHQRAtJ0HQe0+2CCMxOP1CkyK4Zxdnu/b0icFnyXmVgzJgoMJNojyyjTZ5cVXRscJdTvzLZUxZp6dCV1LatjsFZokll+Xzde5SG5l4iSR52r52VA5/yIoqtWHWoxK8J9b2IiR/gTIoPWvQTPSWRVnWZxxHyZ597NSRDW2NVWwYnt38ImjtCJ82ExuJgAtd/yDsE1xvsIRyHMncM5E32gq7PK8bvwqvxYzegYf0JVilJQWVNeAqlZcHC7tDdrC46pCow7SGjWnkATwcWplpt2P8vofRTDNt9ViKHlvwjYBX7YRflw2ODGEuM+WXt3DeM1XefZJqb4ky8p9Y65DlmKlsFPHCuhQLeG4PqfvIYSotux7K3DAwcXR3MsJLieHY9C4iEGKiQyw1ePqVbyqsLrAWkNo+wkQOtSL6e7gTQEAWSGAmWxosWdspW
 PoFmAO2+
 C4FIiY68ciqCQMzv+GgtAHGCtF6Rj8ifCn67S3YoqxmAAZIejb9kz25vpnO7V7X+IOw52YrkIw14azcOm66QNqxlB5bwvQbQnuaYjNSouMmKTBJ1qNen8rfxhUiiAikCNm0dv/cGG5p97oCl3ovalQ/d6N8ZFbrQ6VL7QCC8MNSXR1CHmDIUz1QbmgEV5xgZ9Rwv9xpDxGDnPwae/bYmYvkU1xutL28qHkGv+VkOsmmJzKOBCHVcs49+NNbXkgraDyELomKf0E35L786rAuSzIJChOzYSVgA36EshY6Bvnc2fmk3AH/7l+jQLbO/ldABoIkXT3p8nJF1LpBeNnA23zcFUteDqOx4fkLqNvKDzbclFGZ12EPZ3xy4EVnZMcM8OJhzrVx4uiWvcK0fiRlOFKfNGwCYTY+7vgx4+OVjdFtVpWs0YPB4gvsOHgDV5SzogKIm7y9J9DcS1rbPELv+7B7+dD5VC+YmUq9yzWTp0Q+LxGac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 20:49:10 +0800, Hao Li wrote:
> An allocation with __GFP_ACCOUNT set (without __GFP_DMA or
> __GFP_RECLAIMABLE) is redirected to KMALLOC_CGROUP and will never hit
> KMALLOC_NORMAL or KMALLOC_PARTITION_CACHES. Consequently, neither of
> these caches requires objcg slots in obj_exts.
> 
> While KMALLOC_NORMAL already skips setting SLAB_MAY_ACCOUNT,
> KMALLOC_PARTITION_CACHES still carries it unnecessarily.
> 
> [...]

Applied to mm/slab.git for-next, thanks!

[1/1] mm/slab: don't set SLAB_MAY_ACCOUNT for KMALLOC_PARTITION_CACHES
      commit: ec81fa8f7dbcf89d9b4112544f76f47c8eb5c725

-- 
Cheers,
Harry / Hyeonggon


