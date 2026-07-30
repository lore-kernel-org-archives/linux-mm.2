Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E28C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8B06B008A; Thu, 30 Jul 2026 03:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBEF56B008C; Thu, 30 Jul 2026 03:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8206B00A2; Thu, 30 Jul 2026 03:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93BA66B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:06:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 232B5808BD
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:46 +0000 (UTC)
X-FDA: 85044560412.08.C84FD2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 78A0D40008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:06:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XNz1kbC/";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785395204;
	b=pwNsMUOGx+O6OC9TWo29wVsi9Viq6IOAruTam/9ePDzZfvKQJSNH8nPmLvmrEcY6eHdTER
	QcdydMrJsXnTyYXMU5r4i3gxLKVCsi5Zj1S5xSTNp4IHjN8iCL+Cj3pAdvpsNq9FmZWpn7
	NAZ6bYzy0c+8q1YkHzKha6UoUlWXydg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XNz1kbC/";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785395204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRokCM6JarhpXfPcsVgL4nJ7LiMw29NcZfV0+7Aittc=;
	b=Ts2wqRTktSjlPLZcsLmmZp7qgBB8tjYOIg9dL8GRFAztchuVLsLOHfzW8Ll5xJIUGfwqS4
	OkBZ35xrefSlNjvA9vSVr7vqddQpaT0RcFSUTPeapek8YxVqsUMlBZPmwelrako6Uc3FWf
	FSBDNcvRcrQTePzX6NCVuEuhM8g6rEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68EB143873;
	Thu, 30 Jul 2026 07:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788F21F000E9;
	Thu, 30 Jul 2026 07:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785395203;
	bh=lRokCM6JarhpXfPcsVgL4nJ7LiMw29NcZfV0+7Aittc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XNz1kbC/rYeQ0+kAjUlHyYZb3UDR1ALrPtDA66PMjeeQGwAVWOW935rrrRNPsvhyz
	 exDN9lHjx6JhYmzQfI3EfwJ0t0RKz8RvduT8TgyqsZlYSe/J4UgEiZW0Aafz2K8EOz
	 9ETeQ+cR/8ZGO5Cx0hc1gLqq2RXLtsJCSFmCKOjznOwcbTTnAfu3FszC7K2wQoGG/q
	 yNlA7YvS/98GayMa4MifJBu6LFX0X+LcI63NlhAXglC1YjJM+8LIC3akUE3BfyoljM
	 oHSxabmqMv1AeCw9KS55iw8wRIB6s76cr5A6nVE0WowKmR3GPYNev1X0JrVVAWQTHN
	 m6tm5cz7dtLtw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20260729155143.177790-1-ekffu200098@gmail.com>
References: <20260729155143.177790-1-ekffu200098@gmail.com>
Subject: Re: [PATCH] mm/mm_init: remove unnecessary initialization of
 pgdat->per_cpu_nodestats
Message-Id: <178539519703.2150480.7647949676967159388.b4-ty@b4>
Date: Thu, 30 Jul 2026 10:06:37 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78A0D40008
X-Stat-Signature: gfyx69ruu1mth3u44eb7pjpoy5nxd6up
X-Rspam-User: 
X-HE-Tag: 1785395204-364440
X-HE-Meta: U2FsdGVkX1/zMXOH2UYU8b7S0z9DmU7iwnjYRvZv9/lSw8yhPlavT1GwkguGntUA6FlG75pf7GY4TzG15cmziMQnwsENsAxHR7+VMQA23G1MTlZvKjUvRyHGFqaxVQ/Jd/rlfn1+HcJEGB7J+TxPR6XiDne0jb6kZC3BGUPmKL7GpEGzNDLRfIsMogcXgsw+j+bLZoug3MaV/mmCEIBHgKzYmlP5ObXIqc+QOWLBaxleXuoYsdKMr/t++GtAxC6O+DA/LwBZjtGjE/WGoc4xFemtzTgESmRXmu8KbB8RYzlyffSj1O93ixSyEolfPbPIH/AF38xqAPoImr1O/b2qXlkwtmTT6YfuMrgzCkfXD73mvd/jqqtRZED0sC9e9GkiZk15+rQ3LjFdDl+qpZXk/zKAccXQNaCf8NtB+Q/9acHdQBGRO9TxpD2T4y8ZGrA+WyOYhEtFBJii5LNi5olsdoXeDCn/nhjNy9M807mGp3isI6XSHukniV6FnTdtUk5QqnYXJ7xbTHg+WIOl7LqAVbCRPSTupFl9cjS5gsHfcrO7/dFozF+dJXXOPogQmdLZwbK1/ZEKg32YKv8yWFQJjaCL+qYRZSr0EGM1sqLD+WoANf6yaizWMzIwMGHfwZXFxCA6GAnambU2woqkDBc4nXXkJvnb/f+95EWhKguTOr3eGxjIk6U1bY6uaHjsU8FdWJcszX4BI2g06YZeomcHE8lbogVU+oDvwrT0VKKItir8lKupr7Kvvp2Ho95tkx4tk0Tf5g6kYxNQT82pLcrQfAvQLSQfA6QttdtHA/bqtOjpzs3KGzvzz4hOHxSp2WnUuXPe9rk8cZlI0xLcP6MxZUQ/gCMvGQD7Kh+1xk84agj2wHS/zyIftoklZuE0J/flDOF4aVPUaP643BCR5NiWNbpXgawNoikvR5Kn4WcNxT7n5PD98EG6aS8T5aRxhaaAixnD+nnqpzBcQHPM4qS
 i7Rzyuqt
 D3xwTmepYrVjbqBmZxSvb97eCeRhCg09JBwRd/R0NythAPYidktS2QMyKeHXRrraFkzk0qQi/K+mL+Mba2QtCZmnT47qMW48YBFyMUflfKz1YQp1f+ZnYGdN3eHV5WcOQltoBOB920pfNakOo/qhX/QtH4fdrhlURf+aA8QCO86ncX4mF173i325eiEHOfdz91hOIljwy/OGL1DBs1dT8VOKoiGiPXnnYZTzN3jEeZAHsCKS1cbE1GSI+S/TGibyXVR+LwiK44qByHkia0J+yrfx1anR/m3y09G72
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 00:51:15 +0900, Sang-Heon Jeon wrote:
> mm/mm_init: remove unnecessary initialization of pgdat->per_cpu_nodestats

Applied to misc branch of memblock.git tree, thanks!

[1/1] mm/mm_init: remove unnecessary initialization of pgdat->per_cpu_nodestats
      commit: 78fac571b06490654af45c902c7ab5f651fe7067

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: misc

--
Sincerely yours,
Mike.



