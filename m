Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5773E606A32D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYbsTPPs
Received: by kanga.kvack.org (Postfix)
	id ECEDD6B05BF; Sat, 14 Nov 2026 12:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7FD96B05C0; Sat, 14 Nov 2026 12:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97B16B05C1; Sat, 14 Nov 2026 12:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD2226B05BF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:07:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13B0580470
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:07:51 +0000 (UTC)
X-FDA: 85434356742.06.508AF40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7778A100006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:07:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYbsTPPs;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794676069;
	b=NTqk5lcTksyPV+46Lt1hPIChSgOn8q3EOoNUrPhP2A9z9kGNqnf3EtRtSF3JQekZs47/0V
	b5RFAY+rD86bkfhKKYPlv8Gc9lnsS87mg8MYE46TQLrq8jWV8PQuO/MJ5MpCHb6PZhufIK
	I0PVdjXj9/WzgnqpJ5p0HDwB9NtJSKg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYbsTPPs;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794676069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBoCEw6CiwtCNOzOZnUMWIHoxrO2jUoBXpCdLr1vMBc=;
	b=mbIBg16FSUo4J/mvx5WXBjbIeR4K3ILKRNeLgHUTmQnR8qQ8vtjMhZOCLWXcLdbhxH85Uu
	h3iiSd6R/qr6WNNGVZQPG2pIuXThJUYQkB2Ldy9vckaBSiUkxNwW0lU1/kuRo41q1EHIbr
	TdNy8fleR9OJhj0zKq4XumynMVyQFhc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C904A60AA6;
	Sat, 14 Nov 2026 17:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384DA1F000C4;
	Sat, 14 Nov 2026 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794676068;
	bh=ZBoCEw6CiwtCNOzOZnUMWIHoxrO2jUoBXpCdLr1vMBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYbsTPPstTzbf6iO6y6MCxooU8WHmL4Yjsw6ZTBGAfMwoi9j1DUhateIRsD8zH23f
	 evujeQKdYvb1uxQOfiQHWSunIvh7O8LgPNjNWIDEPq4laSLVH/xkQgvHK92wnG/QzS
	 DYL14EekyTcLyfED8kq7nR0/4Q6Z8lrOViAh0gIu7Fkv4rzgm3l7sMY0mbZlF5Eq9/
	 zt6siETwaDkonabMQTLnzG69YAIXZUp5VUvmBw/0mylDPBml+2nOrBkAL4RBUpwFb1
	 sx55syQnxXmh9zFD7r9w4/Ds7SmOo6wgy2dGrhmXFcnbpg/ZFNDBYHRiR5WgRiFBYR
	 kvHSNMNoccokg==
From: SJ Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon/design: replace "same to" with "same as"
Date: Sat, 14 Nov 2026 09:07:40 -0800
Message-ID: <20261114170741.197407-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114055436.5546-1-lienze@kylinos.cn>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7778A100006
X-Stat-Signature: qsza4khq8pj4ux7abyhefkbiwb5fje1z
X-Rspam-User: 
X-HE-Tag: 1794676069-998501
X-HE-Meta: U2FsdGVkX1/P0oulVX2oQ20m7JxqJriGhWinXG7c3zOKQ2RQvVpaGbvimo7qwXwvrw2m1LbWH33VyPN9s4fkRZKm40mOw6f4zRBSAjIe3gNqb8tbNIljIMmS4biFKGzdiCH73bn+p50M2Q+1XFhwxqeN+Z1RPAyNamonbtezC2By4GpKynFeM3kOMi208MlSH6C6YLhEGlp7fpTxmY85Lr01AbpeuxCQD1dXAYhaYOP+k30g61ac14/iVi0VL5C6/FbpgbPb/9zVdj2sJuOlqoEi5l4J0xSZJdXpyZbsMc+TOKc/63PVPVRKoG9OWO35G1JDiOzcX/UXixlRep13NTn/qeJ/kxkDiR1fziNX6g2ADGQV5oS+hA3XcCxj1DNQ6SSfdk3IsVf1Fj39bT/HhIKP3kNaVKLFm40cNzZqp78yiFPvVlOphm3hi4CRAjWBWj1F6DXG4SbO/GiI4tG6zIhz65Oo1RwOMeI6U/hsYhXlKfYGmaOk6yEFbn2wqYYduNi11XmLLEwt8ZI9/lWX3JiY2d45srfC1ajxuiQYHhXC59AeUPSPqKfBmQN05OkGXD0JGanQjKMxfbtNrxFLH7kipyhwRNUOrMloNYzhC0/GkHPomDr6s0Z46Zhu1ta3MIh2KxQlyc6oljq4K7y6uywb8EHUek7luEjuRkNzXt7JRhELPWEXNZsC5+nLEGMKSPaE+T7e58JFB1ZuEtU8mLos5Y1WGTJIcXYas85SEJrJAFga8pCc1Fe4Necvyjt/YdI0f0TUJ3dz6x5n0PrD64v/czhaqLtYlTVM0+1JoG/+gpdfLdol8k1q+Tt8H8ryqawYbygL8ZmmWagLSGRdtT7vWjcLer+/ZqNuPiMhpSPBfXIhWVm1v52qK7DxI1RHEqv7ejyDfbbVgGXdnddB0yi/5E34S24OqSF7a6mv8RR1fp7xFDOJ0CbpZKMKyHPlzcnrGhuvvUHlRxhxzID
 FrTXBfCm
 Y/6WRJq+NLeUiXDQdTajziZNS1UwpR5n6+BvZD8saoyi/ByvakikSZrLITYG6+wqWYbzwS+vG+Hap1+szYYclX4htH5lBSO2bBpTcgloED7czX01q98+GX8UVx5RuajK53Hw3XXHVgiMmZZKa84MrOgbAgt7dzE2xy0MXz9br2vq/6zZVcFaNde9q1yIcaUwhtXGzm5iOmzlTy7gMBS5dfMyxuizGp6k5tHQZup6wrgJtRsopVpQ/1t188cDUlcxv16jS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Enze,

On Sat, 14 Nov 2026 13:54:36 +0800 Enze Li <lienze@kylinos.cn> wrote:

> "same to" is not idiomatic; it should be "the same as" or "same as".
> This doc has six such usages.  Fix all of them at once for consistency.

Thank you for fixing those!

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

