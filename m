Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB6BC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4D36B0095; Tue, 22 Sep 2026 09:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895B36B009E; Tue, 22 Sep 2026 09:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D25F6B00A0; Tue, 22 Sep 2026 09:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61D736B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:11:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C7EC804AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:11:08 +0000 (UTC)
X-FDA: 85241433816.02.2F11395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 889B4180008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:11:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3GjIaQK;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790082666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvmyyGPjbrWrJwbf5Whbrcgx8nNLvLw2m7m3Hwl69o0=;
	b=R4JJKDtNBVR6M1g9ERkmeGGN86gkTbM2t4o5OeMWGovlhEWuy0e7u63lw8y9wQGHPYv+/K
	C54cKQuYDHfAIZ1hDMTugXir+Uy9vpTZD4zswGUrKOZUkPI+ZlHvHCsggGLf4jBo97FBvS
	n3EowI3YTE9OAZh38mumAPP4l1TUvG8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790082666;
	b=rcE/kGWkYS7ZZV5cx7Y+PEl7R2LguqdrYJJMAhR9SlADWNGvYAtYZpuy6wlbIZKWoCkXxz
	JFhufD2V7yITe2OwhtZcWKa/0ll4r/VzZxB8iK7c6Wsrt0UIfVWkOmiVVVno4qdt0KdJOy
	2k1mlwlCfscNxgpV0O7cq9azo/N38qo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3GjIaQK;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAA2E40094;
	Tue, 22 Sep 2026 13:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07C31F000FF;
	Tue, 22 Sep 2026 13:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790082665;
	bh=YvmyyGPjbrWrJwbf5Whbrcgx8nNLvLw2m7m3Hwl69o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3GjIaQKp6vHSZAnCZSWn75z++PWW18Ss4iexzoJsz+yYJPFpyvP9IxXn2JoZkTn4
	 pL11QZKrxM+oHrkwISjQLgLJWWxuv5QWcaI2n+3EC8A3avsZBexKWdyFOUKxWg6lwX
	 YClfcL/bYao8CyX0taL+ZJ/7GHVJQJTZlQJ9a5AsjQhW+OlWN546KxnixXnG7ZsVr8
	 PlSrmda9yRFht2SciQxbe1TOjUJSSys6mJIztaG2eM+9Ee8a+Dp6OAShHdA1tz0k0n
	 RsR/saYkpk5kyp0jMjzDBicAgvkGmWUjIMeUXwmUz2FOE5xhLnuhpqNVbE+z9IRQDg
	 StSsoFseRQziA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: vbabka@kernel.org,
	akpm@linux-foundation.org,
	Hao Li <hao.li@linux.dev>
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: refill prefilled sheaves from the barn
Date: Tue, 22 Sep 2026 14:11:01 +0100
Message-ID: <179008262139.1310571.12383090243043565426.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260921094521.141665-1-hao.li@linux.dev>
References: <20260921094521.141665-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qw3qebe4i3ak31q6c7dh5346i849aat9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 889B4180008
X-HE-Tag: 1790082666-618347
X-HE-Meta: U2FsdGVkX19fI+GJMTl05uJAJxqnMurFbOI16HEkD0ozmEHOhDxEHbGNhp9z4Ey5nYd33jVjYbsc3hwqyo2dpfZyiFvWXbuwlEoy6mCZjYiOLDZEP1bmqcLam8WMllIhD+g6zGK4q06bCelGyhjEqTCmBxxZlhTBgt/Sn+D1e/Fb5fWXOx5obtxB3AJ5xMJl8urZB5fOLEr2YVp4hQAAaURG5PC+lkzQSV4xyatPRs5da5TVdpzK2oyUe0dz6ueHLxK98286+VAA0TetYs+0UP6fkH0xfRFeGZxXGB3dkcD5UyL9dfFfYzPkLy3Y8jDNvMGPDMY3VG1yw7qhHlYhTsrGWDEOGwKWlBgZJoPOjuccrYYtGRq5flex7TMJd98V1jIic00C3jQ1VEY/2uuD1/hNwhwANCw0i3Pf5w4ODo1EXvFD23+R5azT2PJCg39h9BFXTUD4JYyRqv5nNXlwnhImnbyIOr6qnUotJPsDuAL4QofYSUIwo524vr2XAxpmKWu6CEhDPnz5eQC95IQ5GkMkZTcknJrWPhY3I3zwT4u/iEQ0opJ7yKgJkw1tPFKc7zIWcTXSWtNPVhoHKANTQAltG1AU/8amB1Iwj3gPuMF3nWvZH3sv7tu26+wqhHs6iRq2r6VYsC0yBigQMZ806p6Sirh2sOB4SpPDcjIwY6EpJ0KfJp+IOw0S0JFkXoEDb1n1+HbTHitw/guWqSFbScx9p3FZmvYBceJW32zuqEO6tTbPnXJPZIpQK8Qpr0pugeRrkEOJjP0c9fG0gTRnwMQ8Zgn2+K+/7BZwhcWWHCRUrmw/SIGjnQvR5cJWGjVnXAEqqhEX245rL6pTarFAMVbvpHX769bG8sD7bFoXOPlHhjbG4wAWOno823A8DKU1429jT8LslSWyVV2c2O1eAyIiMGS85t9+WPxvg2HF70pA3ZtuKdpYSWib3wXk7IoAtYvQ3C9810oQ0drxF7L
 8I8aFun5
 P6TDkc6xa+e2x6HsO/KGsImb5KqjCmPXvdap26DYUd9Oq/ST2tJS8cLzOi3xx275FSCyqSmkMmLTrQ42eAiccs25sY1z8hpYm/4sgTIaMfZlAzFgXrCcVZozgqRKLmIeT/hLZ689eXYmuz6hcwNAltttOZzZ/hLQsYnxArDoEMOVwD73A16r4B2PjCfidLXuc+C+1wFevAWdek5v1f3IB/kX6DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 17:41:13 +0800, Hao Li wrote:
> Currently, when the prefill API refills a non-full sheaf, it takes the
> objects from partial slabs and never from the full sheaves in the barn,
> so once the barn's full list becomes saturated, it stays saturated.
> 
> For objects freed via kfree_rcu(), every RCU sheaf then has to be
> flushed to slabs because the barn's full list has no room.
> 
> [...]

Applied to mm/slab.git slab/for-next, thanks!

[1/1] mm/slub: refill prefilled sheaves from the barn
      commit: d7b92c1ee684978c5fed7b3496939d13c8a66b6d

-- 
Cheers,
Harry / Hyeonggon


