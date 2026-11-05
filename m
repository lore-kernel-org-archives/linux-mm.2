Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44E0606D817
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n83ov0yb
Received: by kanga.kvack.org (Postfix)
	id B670D6B05B8; Thu,  5 Nov 2026 07:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B115B6B05C2; Thu,  5 Nov 2026 07:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF676B05C3; Thu,  5 Nov 2026 07:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC786B05B8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:12:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07A97C0988
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:12:45 +0000 (UTC)
X-FDA: 85400953890.16.C69E870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16A451C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:12:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n83ov0yb;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880763;
	b=TBEQVSFMnil8Ys5kRrIatXK1k+N3gFIzHpajyxBYxOmPrIBeE7QlIgROLh0jxIG9NG64ZH
	XbWeQMB7ObFktwsXqykH1CcyiV0WJcux8cArkbaswSC60mAJPFwo54FD69IVLTgpbffvhT
	q1W2W6akic07vSEj2K0rD4wYYOjPvBg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n83ov0yb;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHMd/dXYh7gIG0cBwUrUnPLYGKq0g6gjljh3Mny/LFw=;
	b=g8Y/GIhFWuVFyP59Hdkj+dlQ5MW6RYfq+50pFxgygbuKpzQfZb4+zggtrg4HUQV3tHKf7v
	YPF2KMsUAWkFrLQLQkLzGl+NndztUCX6e4yjzQ1dj2p4tVn0e2cc+u/AVCf0O/yKa1xm9c
	gi4om5KfVNEq4JQztyUi0hmk8jorkcU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8855160267
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0FBA1F0093A;
	Thu,  5 Nov 2026 12:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880762;
	bh=zHMd/dXYh7gIG0cBwUrUnPLYGKq0g6gjljh3Mny/LFw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n83ov0ybs9zKjBE+JDKTc4TPiw5KduZShNqgRdasi9NMkwyZpv9GLkz4bkaF9cFXT
	 t1RXCJACx+SLGqI76ahilnF5Hghlr8BcHq5Q4+ctzVdzne1JxE1T80Z+msPh8iSWcG
	 Wq/F1ukxPloyUBAKh2tFffyAngWvC2GqcFWfyMGYXCdIIdsZrI43ONo8fczLlAYQiu
	 fWqAQ2THJmzKgeR6S4k2jBoiMsGdPGbPXgf6Vg1E5v3mf+LXtxpi+Mdycih4L4nz+t
	 bIPbeOyGnj1SwlPupDwntO7HTqvB4zyyzBFD8//WJe/f3ipgyqkUSuZ8zoBTd8wPRa
	 zi1CQyyyWdH+A==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id BFC97198003A;
	Thu,  5 Nov 2026 07:12:38 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 05 Nov 2026 07:12:40 -0500
X-ME-Sender: <xms:tnLsatKWpvswulKG_-ndkBrKLQLI1gU79TIrVbtQEn6pI1aW18xTCg>
    <xme:tnLsaoYbvRuiZ0YqcNqrJ-JBhLTqH08_KeeFGjFaujvQbKWLcRuE3fySPU94bZz_d
    JBHg08cTKfLvfIBsEULgWqkShEEcVC0HytwY-Uj2DSI8-mT3uL3I54>
X-ME-Received: <xmr:tnLsaogQJmRYXQI6KN_HWwqOXeE9GufB7k8H4mYx9jWOL6qMLw1EuTqo5M0>
X-ME-Proxy-Cause: dmFkZTFSCgiRUzVCJYCqptrUSa9RHQsLWQK1L6z9r9zyIOoZgIGHK/fHlQJAVg90TKAzJ3
    s4UplecP7s1f3qOUWNCj5tYaRHeCEDqQKOYgk3SWTs3mYDAtRtLSDSya2S0qC24O4N3NP7
    Hc222vgyIrKhtZHOstUnlYYDNDcxuWUYVxaKNabOt10YTuemJKgd7oOphgIehKzrjXcH+V
    YHa8b2QL81OVg8O0nTCEw0sxzYDLw5LJ1tdblkIm2kd/XRoBN5iuZBfEh0LXeo6+/pZ+Bj
    9/ybhAJ6xcJ/Rib4C9vXdNXcqtFniKdrO19OrbOg5LNTt/el6+WBUWKwXLc7Sy8y3GeZFq
    xAGe7EK8aR7Nld64zmyK1EMnNXKRWPa7dPDsLG7XgfWEx9jXTHU9TApHgygnxsw71KnEhr
    +E0Uc0ouJy3xpuTYTPcPym6iVmVuPwbOHiMJb+4rYKxvdfBnVfQZxTheF/5Dmzo0t+Ihvc
    E2r8qAWyRV3T0wKJMPoyozVSXaLKFLmmDsnespiGkdOim9QHqyZDYJTnQfD/YFJD7Gt/Bd
    MkcHiQLVZMIwvUNZPsfOEelQMt5BXwHLuOxmUIobhmNRBMdOaaZvCGqVn4iTczB4mCBznY
    MWgm/wVf17mSFUw921U8q8JLuzeLlj2XEPeH+nRaAoiFL+3rMtGPysUjxlgw
X-ME-Proxy: <xmx:tnLsal4RQYFZtsdaTsaU_I3frjcOpHVNtg7FlgKyT_8NH1TbATU9eg>
    <xmx:tnLsaoohQzjIGt0BjtURG0YcFYmDLrCm_RVsKKgO0UgpHqCxMnHLoA>
    <xmx:tnLsaqiS8re4jucvqlzhjTO32YU6x9Tj0Fkb2mpLap_1xKXQ7hbw9w>
    <xmx:tnLsaotI_y1-TwwYZCvhRI1cs0nglmjXg4Vdf_JQ7OypcNwe0JuGwA>
    <xmx:tnLsaj2vda6mSJQo077WW3NDOB4_zz7nGw8pJqEEUxn9beWFUfTTcast>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 07:12:37 -0500 (EST)
Date: Thu, 5 Nov 2026 12:12:36 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] filemap: prefault writes starting beyond EOF
Message-ID: <auxyhE-b_fHQ_Eqz@thinkstation>
References: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104071002.49693-1-dennylin0707@gmail.com>
X-Stat-Signature: 5oq34kgar7u43g6xp17ktdkey6wmp769
X-Rspamd-Queue-Id: 16A451C0004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793880762-371520
X-HE-Meta: U2FsdGVkX19iy1cG1nmMBJftVpTjj0oaGAhQzb5AdX9oPSfBmFN6+poHYXbnTyJpDi1JK/AXwKUC6qOrH6pQsHzuF5q5zuCeNfGDMqMXs68P2eV3dscSGzPaKUjnsIhH7Tpi+bjtZJCq8oWz1cCCDnsJ4yV/2zCpnonWYQQLdf0XJSn8I7/Ny/zUQ5dS225t3xxblul/eyl7CK69Hwz93QbQbHWohJOmFasZZjsSC4KElW1hxa6vt1ICYhGuduGvr1nOhEIzbtoDcbBkRWaFWwkZQtRNv9/bEGF+ZOlyPyZ8ZiOEQJIJvJ7ebSmQKDFOgJIEArvvxiADYQ2e1R99oIsB2vqTzap+kX4+j5Eqsika7J7bVFYpRDX29galL/Z2xZQqV/wv15xDvDSVAxJ+ptjL7EaH4RcTVmD1X3tX36n4neZErhVuiEo1ayUTozzmrlx28uNk/Xz6w+TmLy05C4gFyPiptImGsuhVNqWcXolJT3bNoJ1dv+0hdfL1hjBw2JhdCI29BsKjqtrjLt9Q1jrWrKFEiRm9tCCX+9PKJ7etpkNzcY8EQYacCTRqyPilyPE130nha2aTxBk+XiKKv+987DSgwvWmqxBzCWRVj/OjYUydUXAF7lQNSskDL56poyfcaU2PsGM1UGZj+2sABozQzWFkCPp2fcFyglvmipRfdlKfxbL1yQspRQTeYMP8MmMRuasz30hqE/BLP//0bEyvQSZX9Pfb2VwP8QktkSJXA+zJ1zngmMZz9cF7tp66DxSXuatcA3fH784/f3UNI9wt3Cq9WHh3Adz8x1KqPQdvxzvpYeUYcbFWfSFTf5lmoi1QWAX/ajEndYK1AItWZN5lPuaHY5WAxeKWFinwMhjHhousLAP3+h/9LVSYmMy0r5W+CRpul1PSSCskDIt5QrcO0HNvQcuYvAjS9YRl+pcx5BKJ4E2v0llQ/FCvhusfzAVR+FOLSbQ6N+rpNOU
 Y7NdfUlF
 sn53t89PsZ10+SgU2Sa9UqZ188SU+TxCUK8zuq6xud0VAaK+vb8jhUDVU1gi4+Jy/bdQU0qSlOX2NfrdFxC4BK63b3Ole/VA8mGvNz17TlWxtJmsNYllxMpz/0AhlWBDWfpPdr6sZbaFHs7v6E4jgZinjXak0zwtLOw7W1s0XWPRPztbN9XiX/t2VrDe7HglXBspolnWi9r4rkyUXbZE/1s5oEvXZUd6X/bYsT9NCzVZgvBawxC1irlX1yVR+2R0jaRX1CRke3Dqm0CHgpguKC+oPANIVJi6W3HJx8s2TN6pRu8I1g+vx6pFMZffOXo+Sk+mJMr5pBo4PszARPWpPgqaqW97LV8N84S/d2I6DuIKgNoDwJAv9ECqUeUNUIx0kHIITUzGWeIEPk2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 07:10:02AM +0000, Hungyu Lin wrote:
> Since prefaulting moved to the slow write path, a buffered write can reach
> ->write_begin() and ->write_end() before discovering that its source buffer
> is unreadable. Several filesystems can extend i_size in these callbacks
> even when no data was copied. For example, a one-byte pwrite() at offset
> 4096 into an empty file can fail with EFAULT but leave a 4096-byte file.
> 
> Prefault the source before ->write_begin() when the write position is
> beyond EOF, and return EFAULT if no source bytes can be made readable.
> Overwrites and appends continue to skip this prefault. Keep the existing
> slow-path faulting for forward progress after a failed atomic copy.
> 
> This also leaves intentional zero-length ->write_end() calls used by
> generic_cont_expand_simple() unchanged. As with the previous prefaulting
> behavior, a concurrent userspace unmap can still race with the later copy.
> 
> Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
> Reported-by: Kiryl Shutsemau <kas@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/at9xXRhD2xZhszEj@thinkstation/
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

You found the bug, I only pointed out that it is not tmpfs-specific.
Please drop Reported-by and Closes; Suggested-by and Link are enough.

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

