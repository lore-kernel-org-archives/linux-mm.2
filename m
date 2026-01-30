Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 745CCD73EAF
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 01:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE056B0089; Thu, 29 Jan 2026 20:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EBE6B008A; Thu, 29 Jan 2026 20:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9BED6B008C; Thu, 29 Jan 2026 20:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B57776B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:49:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C2B01A04B2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:49:51 +0000 (UTC)
X-FDA: 84386948982.25.4A32B54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9279C40006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:49:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkrIXiuG;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769737789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ae7qiu6MaAb9fAtYbHWOp6kcdwoLHNeaFGHkq1+v+5M=;
	b=EFBXCd3QENzni17G+dnCiu4KFJb8W4wfboIaJAoWT808FFDN3vXM+kHRNaneVaoMlUvCCD
	PqQE0/rSYfT1gwmbHX9qY0m5uAEHtLTHsj5MdT2a/rKD7eYELN+4VUIydnuW0UNCY3++zZ
	ATDfdx2S/eI7eHWaJijjn1Y0qjI7E6M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkrIXiuG;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769737789; a=rsa-sha256;
	cv=none;
	b=ggeOMasMzEN3bh6CZnStcL5r2jyWvvMCY0lNOVWliaolKTuNSwEiCocQIlaERAGfMZmpi4
	9xryE8Cw4cVsaeWXEyC6suN93iFfy1e0lphqzCzy/8CyIm/Dr6/rupTumPQwb3iZzqRVv1
	9DqUvK1j4jUK/cbQkchhEURX7dr/Yig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 804FC417B9;
	Fri, 30 Jan 2026 01:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0EC4CEF7;
	Fri, 30 Jan 2026 01:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769737788;
	bh=+O3oU11p7vlRhXMV+aih4qEsfTLVMG95zNWLgADSuHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkrIXiuGbLxJG8ZqMHTviK6n2FyqIjagYGwqzQwgwlsRgH+04PztC6s0aU11TVb7I
	 B2qSHtwKzrpbdCKoeUGDZfmzxvQ2uXxqpY9FnuhGsdX65Ae9P2/dNmTPK77sh8xIdK
	 uo1ycSHc12fFbdPiYgFa8X+X8it8rPZUW5FBvxpAQme1x+L1l5ERAardjcj35bl1ak
	 6KZqqSVUPJeJlvyzFq0wHpj1SwuQUAUj0Gb+Q75XAvTHXz6QEyZj7zxIfUNXGBSYU6
	 EoBo+IwcLJxbZ/Lsf8mr8Ct3mkRH/QDAizUj3TYIJEB+8hsGEJhTXoaswpEa/27bEc
	 tJgtkS8Er4qYw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 1/3] mm/damon/core: add DAMOS_QUOTA_NODE_TARGET_MEM_BP metric
Date: Thu, 29 Jan 2026 17:49:44 -0800
Message-ID: <20260130014945.51416-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260129215814.1618-2-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rhd3qprsz6cw1eznmekuob35ukpff5gk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9279C40006
X-HE-Tag: 1769737789-765191
X-HE-Meta: U2FsdGVkX1+OsPJhlkCQavpAaM+wh4QJjFlmLg/rSAEbb3HBeKPkZKpT4DKzQ2WkBHioUbIcHOmN5qigMEsKuQxwJuvmwQYl+B4QHHYjf1bCUZ/DkYIT2kzFO2GJub8KslPVZXrX4wpFeJmhVk/2df/XGQ1Qy03ihr8hrum9VJUWLF+7z1Dj7UQhX2Xd/LlU5AvlOcY9cYhixnBB2ILZ0mtiuiKUmRGkYYB+LHrP62EEm1yPv9e0sA7VfvTOpRD1uN3CSI9sTfpBgPHlx8xCbw2eGJqOdp0JZShEm09igwse1uR8Yf0KoqjAD0wDbCPVtzcV9L7iJ/Lm9c50szSfLJMw4Se3ZyFS06JzeZ9XokqixLM59aYYuwPH4KZJ04N78mUT1BypWEsNQdBd/XmjNVc9FL2dvMtzgsjKXt9oBU0SOy7aJ2MqHZNqPAkpuxxiJXELBjT2loJGF0L+bY1TOxpWRSHMcNeTtWL7vUBp3vxYsh8/t9JZCMJlqCVXkzn0/DKsMEXot5KoHnoQ+01o9ii4dW7SWaMyRcrEOcSNNymwxRtPnfgzn4OdNZob4L/Fe/7zZaw5Aw3GvhlfQut0tMAJS0S7Qbgbdv+te4k6Y3LbhPph/2bd8TO9889gagt1P0QELIy5Y/9/8Yt25RQfkMNESL6Q2p7XHRmvRyrjVTySFx/wR9uU+ZfY6WP50TYZqCb1W1pK8Hvn55miX3vHPaqMBt5bC8rKR714gulWce46szIJjaubKJU2Vi4ONknFqpowd0ZEtMtnmi1P1O28GDHKe4SuiiJ+oyi64ZIWTyJzU/3r8qLeFLV6OGZZGGhmpfQpCGhcFUlsDs2Y8o9t6DdkOdbQWIlxWHWi8t05SRz3vjkVa7v+yzNNPWUNJiwNBo0h6o6t/PkkGG05TZyxCEijh080u55OroIbtd51OWr2E/xy/e7G1E/RtJukh4WknIVqTpoWVUxNQVCAyw9
 b0k0hwqv
 k3keHdmp/qHI6Ja4mQq6EFtSv0zGw0VyMgxI+9C3cCwVGhOKwgX+mitow7Ffgv9c0ebkhA5NyUXwciQKiQAjdooqoHVkMBkiu5TaWfsZuWqDBRMpJIoVDMBdW0OecF4JIJkS9n690+9jjXYXhMTjtXxWOsTk/La+ZaUmoC0+3qozdJQ7uCNZsEN8/GeEFihbZqds6L889G8Oj+x+J4WI9hak6QlqCeRfvA7i96GYDXAd/sQZ/cNxAEsy43GOXUip/rp36HOiuienylRBGIzMjySEv+WQIVrmbHnzMKNVK1MeKA1PSVjOhKnaKioJ8qqL7X2J5snLTQoF1CQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please keep "RFC" on the subject consistently.

As I mentioned on the cover letter, other parts including the design and
impelmentation of all patches look good to me.  Thank you for doing this.


Thanks,
SJ

[...]

