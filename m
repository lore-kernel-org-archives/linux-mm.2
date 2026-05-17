Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75444CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0896B0005; Sun, 17 May 2026 13:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50F46B0088; Sun, 17 May 2026 13:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67156B0093; Sun, 17 May 2026 13:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B925D6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:31:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A4D88E054
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:31:20 +0000 (UTC)
X-FDA: 84777603120.24.90AED78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D86E11C0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:31:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATudrdgA;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SVvrudyMWIoIq0kLhspON9LEtbwJPMngxEuTZrbdhE=;
	b=12asSn46MuEZiaGVyDhH1ikJzMTRR4mpSN94dW+VU1kvEP6l1UY2cjrt0HFPiBspYXuNiz
	fJ/Of4aZXfNslwIFBFS1MxB9ibbr40nnwfEfJoujaucXls26Nyq4zAAOpCvifxvPVGlUS2
	bDjE6tlC6sYXGhWVbtMzBB862MDYC/w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039078; a=rsa-sha256;
	cv=none;
	b=Mi9gapHtE6QzQIy+UnaJo0zxQEJJIEtMG1w+u1Z7oLT2WFPfb3jjPOpAJaENy3zlfNEAjI
	XZr4gum68euwDfYlhTSkhhSZattW6xFoPjWz19xspV87LvYiU7nYw/GCi8A/l/SoKISJOG
	p2qPVmr0moQefF9hkh7U7ZePRuZUfVI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ATudrdgA;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 57F84601E3;
	Sun, 17 May 2026 17:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918B0C2BCB0;
	Sun, 17 May 2026 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039078;
	bh=+aUjJ1d0JLkcLl5wfHdzIg1GFF63EALYJshPzkwzzWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATudrdgAiAFP4FEfv8ThrK2psXtOQgx8sXHFshWDMMTTuGVH4CMNWy9K9lhSWo9Mf
	 5DupSbZ6y5SI6XPloBrlt3dCIIznNJP5tSCT1346pT17DNoLyE3dqQUUlMB/4TePD2
	 e9Mxeg6wnZm6SQ1vCGuvVSXXYbh+pvblsFS6QS2FCZi0DOdlL4Xd8V4qDG5h9L2Nge
	 jNFBff+2mssd62VCHPlFXyW0/c2eRPnTFjTnOYphBteuCELIYPmLh0KmQMdwSu+DNl
	 B3GTtS9UqqUjGy2KBciMoaQqQcVlWBJbJ4Gq8HUayIbjktidN91bW44PVTrzbhnofm
	 d8+0D1W3PgWkw==
Date: Sun, 17 May 2026 20:31:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 05/10] liveupdate: defer session block allocation and
 PA setting
Message-ID: <agn7XnuO7VU4eK52@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-6-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-6-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D86E11C0005
X-Stat-Signature: 7717y438gb31bub3tojcu3nr4qb69aqc
X-Rspam-User: 
X-HE-Tag: 1779039078-828172
X-HE-Meta: U2FsdGVkX18dELyMOG2czKqcW8u06iQ6+C8kgIZFfANx5VevZt1GWQ/aWsXmf7Jqgp39Vej8ioDIuFEqgAItKqozuDHYxQq7vxfSV79DPD63Uc8vimVV7K1jNvqSpyOjSHCNYcvbRXrpXwvMz+vk59dQK6/0sSu4Xw4tbcof9vPElMr8GfwRFvitda18u5Y4ciFstE25LcP6UkN6lCjzq4Cko3qM63w1NiqXtwx6wBRLbqvjs8YQmoQob4ndcWXRUOnrG9GxYeMY5Bh1gjTKCXe8OeMbfSXDDgj6B6FLqHtvQHMg4xWGFy0BoE0jy7OkawlunvLBKwz0z/yaKyCyj+4RPrJiPL6XOS9Al/4EgDeFrueoctlu4najhwULy6egXQGIDEYZFu+MZwrFPrV0tgZdS2w0maB8fTQLDPBEKmBjawGUd1DZBl2taf1N0uhom1WRrng8yFoHgMTAdgk1kYP/8ugehyuc1HMdRUXay/gTQe+hviXpuKIMrKsqVcu9X3QKW2BNjUOKNKP8K29XCpL5V68LRcgTZAuiiZ7IpQAp8ONiQ7gGAVLggxEH5ycg/QRoyaTl2L3rOIGMwaBhrCuccXlmLWi54sl1OA0XAzPfNRH1KxsMK3jCcbeq23nMnheatwCtmEW8qiLI76+YuYueUCrxaLCn52E8Fov73sVf6H97rZ8FHsbePuS8gZXz7vWnG5Kd/Scwb1PoUhHP5+JwBUPHav24+WAr3ziDolaRtxvQ/it5kuufi+WibvnPrdBYGEIOAYrek1ILcVA5quLBj7oVyigMPC+pmRWgTbJ9jLBCmsZNjwboizose8g4g7b14zpSWqg7TCyj1oPjcom/zFLeRaU8L1yNeX01R1kpaz0NbOvLYZFymPPwdaCVZDSAqC2g9KVfwVOLV4JMB14ED5kOCcfPWVkuhGmqZ0jMcM1aW8EI7Gr490xg/4ulGIIez+/Ow93SrVDVRJP
 wyiGQxDP
 NvfaA/DC3ws4HyROUYlkYN8iFyi3KC5bhN+7Mm5YQT4/zP1voqHbnx0yiJYHllqrnS8ObdRUr1+4sRRtDprfnyrNPjXhZYrypRcQrvzmYbrJvcSNTJdfS0K1MHUe6+Sk6d/9n440NwHK2o2xHddchs8aTs9AAr8V2e4TbOxe9WKFJm0mElsR9FZl4qIGjsX7R1q3gBPGIwiS8H+enxDtwp8nSJxQigiM23DdCqc2rmweqFRigdh9wzY97tEcH4wlP7cVU41epzuCbg5QHJ2f3BF9YquzuIV7+ZDzNabmA36Mjgs26Gprb6hjPIY5/USy2nIXxNq2qe7MtlaPCc6rGZev9Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:23PM +0000, Pasha Tatashin wrote:
> Currently, luo_session_setup_outgoing() allocates the session block and
> sets its physical address in the header immediately. With upcoming
> dynamic block-based session management, this makes the first block
> different from the rest. Move the allocation to where it is first needed.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> @@ -77,15 +77,16 @@
>  
>  /**
>   * struct luo_session_header - Header struct for managing LUO sessions.
> - * @count:      The number of sessions currently tracked in the @list.
> - * @list:       The head of the linked list of `struct luo_session` instances.
> - * @rwsem:      A read-write semaphore providing synchronized access to the
> - *              session list and other fields in this structure.
> - * @header_ser: The header data of serialization array.
> - * @ser:        The serialized session data (an array of
> - *              `struct luo_session_ser`).
> - * @active:     Set to true when first initialized. If previous kernel did not
> - *              send session data, active stays false for incoming.
> + * @count:       The number of sessions currently tracked in the @list.
> + * @list:        The head of the linked list of `struct luo_session` instances.
> + * @rwsem:       A read-write semaphore providing synchronized access to the
> + *               session list and other fields in this structure.
> + * @header_ser:  The header data of serialization array.
> + * @ser:         The serialized session data (an array of
> + *               `struct luo_session_ser`).
> + * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
> + * @active:      Set to true when first initialized. If previous kernel did not
> + *               send session data, active stays false for incoming.

Hmm, why addition of a single field changed the entire block? :/

>   */
>  struct luo_session_header {
>  	long count;

-- 
Sincerely yours,
Mike.

