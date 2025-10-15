Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFB8CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDE88E005C; Wed, 15 Oct 2025 13:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447DC8E0005; Wed, 15 Oct 2025 13:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F678E005C; Wed, 15 Oct 2025 13:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0A58E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:26:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C34AA139AAF
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:26:13 +0000 (UTC)
X-FDA: 84001027026.13.6BAE432
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 286C118000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:26:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hA5+vBqM;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760549172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQZpbRRSeXhqck6KWzejU4ySPcJxpAvSTRDOqN4La38=;
	b=y1+nn8Tblk5yyZ1mBVJc5yeZVpTPDBv9s5kJt/A3CQ7KY6Ac7KJwu5lYstcf/0nBx6owDG
	2Bx6H2l/zTujuB5QsSKm+U5yxLMLfA6xhiLDPEMIc6ORtlB4xzG22wC3ozhKvo9Q0pujhq
	jg3ty9IWCJ9jJ2Mn8udqr44GyIXNf0g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hA5+vBqM;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760549172; a=rsa-sha256;
	cv=none;
	b=WpT1Rz/ovjLWh870k8KyUabIRJN+77gNfeS5olk8BwZS++ZjsX+U6A7F5mkLjBuK4YVwsJ
	7OAjfdnmT/1trwjZQj9uN58tb4UHxfEf45ViJRZKa4rfzMr/t3UbjKPAvHbgxS3vBbuP0P
	1bNvzP8dGXrLWU0JNH3034YOLvYt0O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 264F2602CB;
	Wed, 15 Oct 2025 17:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B3FC4CEF8;
	Wed, 15 Oct 2025 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760549170;
	bh=EBPP//KAlBskb9pMhxaBL7Kga+U6vtFga53T2SeQa9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hA5+vBqM9+KAbQ2ZLh7xQyiaPk15CQAjVlTcxPL7on3gUbUnV5A9Zz4mGOXglD3qf
	 kC54OsUK04mRPIzbcfAB2XY0uYmS1yrt3fKFMOn3J3rRnP9gKLoVN7ahh0rKEOZlLz
	 Mg+hR1OoHGMmWrFZfURy66L9UrkbTAoX/JjzMFPGSSpyhoeLM2GjmMFJnNfsjgnqkp
	 YlKLClzCBN9+FfBQdc8eIsjh19j+C53f6pBwkHcZ+XMa9sA958ZqqaeJFvrD4ZRgDh
	 EPt+SUwO5Wif8Qh1Eoq7XKuEX2DfGOu0WsDI7vvhyH+1qVgK3NK+eOF3zbctTZQ9gQ
	 V0LVOVJeJklDQ==
From: SeongJae Park <sj@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rafael@kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v2 1/2] drivers/base/node: Fold register_node() into register_one_node()
Date: Wed, 15 Oct 2025 10:26:00 -0700
Message-ID: <20251015172601.69756-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <910853c9dd61f7a2190a56cba101e73e9c6859be.1760097207.git.donettom@linux.ibm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 286C118000E
X-Stat-Signature: h1z94m5c9eniu7ckab8izufbxkah1ad1
X-Rspam-User: 
X-HE-Tag: 1760549171-370781
X-HE-Meta: U2FsdGVkX18/gs5cRRij0hYBy6tsU7lnAjjjNekQAFr9QrqC/rUTWFjtejA6QmtTPZ/RnLDd1j2AsMdH6n7F3FaHhkpVy9dceoNpN5yMA/wdbdF9bm5PgnM/rAcN86Ma8FutMP0Y9bLNmyMixbDWGhJ3gnBjR997wqCGNVNg9neS6wAPbti+HrI7mU5WMGXQs3vxlOUaoIBTrvv9mt2A9cAyvgb2nm/35GR697nrAN3ymZhY0EZYf614PRPWNemvHt1gzv46Zs6vgxHG2z/Cv2bbg/19LVXpIolmZVCVmc6953MB3IOQCiRq2HWtxc39sb5FO88nTe/S3Z3fqGoySu1YP5ddrOET0ft20cZuM2MapDPpWMtBV/XHsq/67ckf+UOxM3KfVCTn/A8LmSQAdiY0QSv/SbrKUcNoFCQ2plewQPzqLtplZ3rO4CQg04zwXE6AgetORnA+cCmjyokFOTqWdkB5XzeMPb0t0RI1WLtjxpcdP/gPI8io40nVqTjeTGzlziqjC0nheqF253q13kAENhzJw2kT6eQxBHAFrafENJVrzt3NoEGNUvoup24r1vwPW+Q50hlAfe4VOsYg+04J4zc+aJiJrQBZ84GL/hNbpopYCNBIN1y/XQyLxNR9Ey32TmHJQ68pduwEg25Oi+i1L62O2W5lKCNNJB9VpjHsBEapLxoyMuWHKkOTIeK6JfOzsnQ203uzVP5k0K/tGIkcF8j04Co8FNwo5uYKEVFLsayto7o76oJisxA38E0oLBesfn8EGnVYGjAOX513j4X9t+Aa/povX3Ow3vMG/baKWzhESrj0KxtZ99UqwTT19y6W58jdKWPSAWTtJ6oDXzmO/nkfLZcN8shBM5Ujt4mWQlr51oZk2ecIdIzS9ReGwhz6xpcpIqJRUmfejz5MtJC2K5OHmyRi3+L+mk3P1roYmpqKLv930wVi74OaNnXKO5rmmBO8v5qd6uFRcg9
 FLmRi8hf
 wJVOQCaqOs8sGivHj+0eCAMArrlwIaPMwZAzhyvLj35bIcQObI9tn8ZWn+p1cMLlkXL/soEdM8G7+VW/kH8KomhnT/uQamOK2q4m7Y9+qzqF4nSmyGNBsJIX1HjzKcB2sY7k/GkH/QB+6YJA7+hSo+oO5mczbM8VdTg3t5yW+uo9KpNkD+KzHAizihPaw0vVOaAyn50j+LQgud4hBDEb9Pwe+2qT69L1QrQtkoPYGsxKEyhWarp4MX0XOj7i8x7mXr840cbj+NVZUDT0LWBaqiW8cadb/llibk7lONuXkb1cKT2I0bVZcubeisAvsbaRGCBgkNRLCeRnoASTgRsto4XDDqMEwtqmxmQx7ImWwuFl5L8dUmTYuaU1hzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Oct 2025 21:09:16 +0530 Donet Tom <donettom@linux.ibm.com> wrote:

> The function register_node() is only called from register_one_node().
> This patch folds register_node() into its only caller and renames
> register_one_node() to register_node().
> 
> This reduces unnecessary indirection and simplifies the code structure.
> No functional changes are introduced.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

