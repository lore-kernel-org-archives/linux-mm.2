Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865C5C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 10:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B086B007B; Tue, 28 Jul 2026 06:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BCDF6B0088; Tue, 28 Jul 2026 06:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D41C6B008A; Tue, 28 Jul 2026 06:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 390CA6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:32:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C000BA1422
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:32:08 +0000 (UTC)
X-FDA: 85037820336.05.9F9018F
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE426C000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:32:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=TpKx91go;
	spf=pass (imf10.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.221 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785234727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECPB4sDjE6B4MA1/TyM93bXDTe4HCIWrfh13yJ+ccuA=;
	b=jUTW0Tb4/BPzCBXYK/vpEO52K4VH6++NWDc/k8MTLIvqDzZwOKv8bEjQ9aew3mhvpUhqrp
	GpfXSb3AFYmtBZ2rrz9CzYnrmi0bDf1ibsY5mUx/aypds59thwQQ1Nih08iOLiPLDOGtR+
	qPBd7W3jY1bUjX6QeP/LCOgEPUPOetc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=TpKx91go;
	spf=pass (imf10.hostedemail.com: domain of shijianlin11@foxmail.com designates 203.205.221.221 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785234727;
	b=KY1xbanfqcBnmH8Or94xuISf8Z1XkyeRerQV3Pi/Qug6680VvxI06J8gURFt6wRlFej9b5
	5Mr1VGqUnpZi23yx6V10B7/nQihlaK8v0jQ2A80Z18XqHJD2JSaLD8LKWgJ2bMvyNd1r+b
	rOFlKq+o07PJIhEceMeM3nJrAtNrl1k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785234722;
	bh=ECPB4sDjE6B4MA1/TyM93bXDTe4HCIWrfh13yJ+ccuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpKx91go4eSW0Je9ZZiBDAC+Bft1uWQ1IAlsrI1kKAifC13FRdtA7yVm+Y1MLI7Fb
	 2KKZpTJ/VA7E1ihf2AyshgdMbpv5NIpnUrczM2jPDKpc/H3nUg3N9BmW37ZNpvv2mW
	 tTugJgL4GSZ7Gi8BeceUH7xhu87Bb2IySsjZ9nvQ=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 8001CE0C; Tue, 28 Jul 2026 18:32:00 +0800
X-QQ-mid: xmsmtpt1785234720t1z8bzqq0
Message-ID: <tencent_F6BA5AC89695D952316A6ED3BFA3CEA2B308@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06iLY1MReuiN1ygzIQAADTrGVr6/IyVY6eWiXKMHqeykY6kd/Om0h
	 qcH+6WLkQ02lFhU2SXzis5hBuiqdcXeq8o3NepMHKzvEkMap2kYvRq0+DvWlAd+l6COxxZrsh/t/
	 /DepOjdik3CBMz0VJq5S+e+mEy6XrLKMsrfHYu4SuHudCel8FuYIjzGMubbqJupfaWZpq2hr2txj
	 JHSImZit+44d99jQjx2THBe7kBB1fE4akfEBfu8gEQdooXi1O9QODaKSF1TqVAwLDcpPprI0rT85
	 9eBx1aXKf1WVeAPl2njpObCzavTPdOOrkU+M9r+EzKhlidzex7xBzpxtRFIQcRpvhnyG3JyDFzM0
	 tjI+U0noTA/PPsK0PAJHUkZErXwAeo5ZMVurEWH+aBtrhBOey9q8CbvSKnBziJ4meEyLKcBwPuGo
	 LmP0addyjlJEnwyyiXlcQkJBlFFcmAe6awPjdUuobdOLMZKxhKUtS6TGp+sufvd6ua1QKFxTfRk2
	 Y+ee+34e9XUy1onw+l68qvz+jzy3uH7grF96Ov4fgLIcLs94Fqwde91o20nDKKqjjYpISNcaH13Q
	 qqAeVVLXxX9B14+6dKA7nJmvpbFC0YZL0jSRn7QWWjej/FxQ99Sz4hDQibwliUl1uJbEd7BHuTeP
	 WnZj3Gbw8NY101IFY9/bFs+QExFwWidTrGJMr4mdLYkT0KLA1pkoCf4fCyKxanMvpcYV4HqevwvB
	 C0fK/5z7AOyPTCqNWmsuQYqGyOrY0KA/zY7Hx+sWx/bFlJogVqekBQF81hL5RpKLPMhxIS5iGYBi
	 pqzaaFEiOLJF80t1fKIz8DjmUWacfZwz7shrY5ZNu6mbbY9UagbgcwREmTyi3MIxCtqrdTHSQWvc
	 UD5a6XTNfWsKPdNEzm8v2z+XE8CWqrI7syKfEvkP+DnlG1y2CrQX8w1dNnQikr/NxA+fexhBVNJU
	 Z2IC6xSy4WpSwaOXX99x8l0TWjoFZda0vWo+znHiIEPf2M0ojRZ4tswFb8uUscxg/7lJGEbz2xDM
	 AKzCEs+FSO5Exk8ZO4/Klhywc5mqg=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: only update NUMA min ratios on sysctl write
Date: Tue, 28 Jul 2026 18:31:58 +0800
X-OQ-MSGID: <20260728103158.1573059-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727155138.82e51e144237e66bff50bda9@linux-foundation.org>
References: <tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com> <20260727155138.82e51e144237e66bff50bda9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE426C000D
X-Rspamd-Server: rspam01
X-Stat-Signature: pm4e4xchdda5w44a7br58muz9y4xo45u
X-HE-Tag: 1785234725-311499
X-HE-Meta: U2FsdGVkX1+T2aQ0iVTNw+2GkDwBlQWjlEsPfCmJRSKsDx9FbNtK16f0VNKgczygQAGAj9IK9+y9F2C2ijwuNKndQp27YII8U2Ea0lrji7QXDmVkrAJgxtoQGQQOOmnBnRRKhc0SpYitlVL+VidA0IB0OVIFsNsJicTsp22XVynYEiN7B00w4YmwTny/oIMySq/tiT0f+eGbf8qZ6Dsll2Vw2NTl/UuMtQtv48GwGBWQBJHCT+opgjgNgLfN511XnoiXUlvAG9eCY1Pg9IUtps10A3bAQHwhY1AnIBm6lR4ukePtuz4lcHSR05n3iXvTsdx4OfzV0TsgSbcZmbSYL8275xDxZAXnZWNQvpGyY+dbr8adMb/caSOan/z7NV+pvZk9aKJ9o+Vi5BNaeTnH8j7d0Zox3yIP8RHO3oVnF965h2ylUtqDEIJUleXJ1Y+q7sGyYmisfrD4TuK/FvsFx4XZlW2puJKHt7m6OLMLJMfG+MDdcUId38+5+/hkPJPeOD+V1uKtWypm+pnLtgXSJOdIomgw757pEGq/E7+Yb+EE3aL4l556bOoIZZPncdsiTZ3Rulp/Yc5hm/M7Fm6bvdOVuCeuKGd4siit4dxip2FDHJ6qe0UetnpHgKtN0mrtb+c956OdzpAEbixegArjHkrFgIAw0weWZCaW1CNtKrrhAT/lTytQJoMJJm5tqp2wCbin2B5eZ3Q6uGsRKO2oxeIaytoyi/cLhmZ/o2VCmAixcOw9PIs7I5tSVT/o4aQSgF4dlQ94g2SpsJmAJJergCn+vFmGxXAvwzjfEunhHQ9HBkbhKWGWH30/HveZHWJYqII8FSqVquMEQTz1XdL8PxQOVsrN8JfR4+usx7C3V5v3dfEo56Dt8hy5iYAqaO1Dz3ZsepJdUxPJYVLUQjz5UxyupOscNWZlXhFiB8eEENyZGUcgSUk+xC79RhwOzanWeipNE+IM0TcgieQqmvn
 I4R4IooK
 qP/O7qH7Cl9Sfx8U/M1Ju0L40qbuDCe0pQFxSmdFdwzUoJDcyeka4So1lUA3FxOJThE//OewlPE/Vx+OxkJgyRDd85w5RMZcz9nqyT7OBXu/He7Kw3Z9glGINatTUH5BFj72b1P1YojdVNn4UqiYm8qF8YmoiN/BV/ODpddVQ8bwiwrp7/bXkmalVL3TG8ghaznu7NZIc22VjM0b5iSTw6wU90gN1UJHok0RWzfggS2i7DLUMmxj9Pw015TIQRrNeTHkfn05f/ZuEuXiPqglTXxB9ukvx987xej3bKXauos111Xo6jt3wYa9wj78ts2H1JveTKHjGab1cFDzkr1ShOzyASdwfPJNXpdL5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 15:51:38 -0700 Andrew Morton wrote:
> AI review points out that lowmem_reserve_ratio_sysctl_handler() has the
> same issue:
>
> 	https://sashiko.dev/#/patchset/tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com
>
> All these changes are non-backward-compatible userspace API changes.
> It's really lame and somewhat unlikely, but we should give
> consideration to this.  Perhaps there are systems out there which are
> dependent on the side-effects of reads from these files.  We should be
> careful about these things.
>
> So I suggest that these changes be proposed as two or three standalone
> patches (independently revertible if problems are discovered) and that
> each one contains a description of the worst-case regressions which
> such oddball userspace might encounter.

Hi Andrew,

Thank you for taking another look, and for the careful note about
possible userspace relying on read side-effects.  That is a fair point;
I had not considered it.

I believe the NUMA min_unmapped_ratio / min_slab_ratio change may
already be present as 874611d193f2 ("mm/page_alloc: only update NUMA
min ratios on sysctl write").  If I have that right, I will not resend
that part.

I will send only the remaining lowmem_reserve_ratio fix as a
standalone patch, with a worst-case userspace note as you suggested.
Please let me know if I misunderstood the tree state.

Thanks,
Jianlin


