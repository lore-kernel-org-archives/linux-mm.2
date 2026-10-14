Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A38CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 23:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68F26B008C; Wed, 14 Oct 2026 19:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAC06B0092; Wed, 14 Oct 2026 19:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA9D6B0095; Wed, 14 Oct 2026 19:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1EF6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:57:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEE751A085F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:57:41 +0000 (UTC)
X-FDA: 85322896722.18.75E54FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5945A140005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:57:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0dvHgBE;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792022260;
	b=cMNn+Z1SqMPrbNNe9hzAXj8fY+njTOMOv4+gkYlua9uelTHSukOUqWNQ28tqRnHlMgvfso
	GzzwlZ5aYXUBWfEAEmgnhmCPZCCQbtVuNAKRBB7F4+C4bhcDvNZdTDnkpuQ/MjHxvGaDzw
	mmDAXAga0vhG18YuLh1nphDEgZPWKlA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V0dvHgBE;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792022260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq2yiqf7IKcfbpJMDFOVhRDq022nhbRLUnX2UIpFd4A=;
	b=fOVHrx7ywvpcwOjHluUlLN7Cn+MOKlY6q2EeChWTZevjM92kgfiBpbKcmOne4bVtNtBPFy
	WGsNCtx+cd9fSk4Mj3ZYKOYlpDP6ydCygqlgtNviRvhcDJQKhMleZqGIKiZk74cI5Kcbwy
	iqcUQJ3kIWbdPemjFfTKLVBdEt+OJNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CD9866020C;
	Wed, 14 Oct 2026 23:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386821F000C4;
	Wed, 14 Oct 2026 23:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022259;
	bh=lq2yiqf7IKcfbpJMDFOVhRDq022nhbRLUnX2UIpFd4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0dvHgBEtYHJJe/gvaBfRPvwLAiM5Bu1SbGf4X2mUouI5ixNKKLFy+YaJZTF8HuLS
	 GnTX55DzpJSsRWZ3X2oQ5vYzHXkyQ2eHezAb7x9p0RPJB+MNbgX9hUekUbVtNBvNzp
	 fE5ruAwaZTctogR2uNZOHx1XjwoGarz1wRVMSOn2w/lG6nxjuddoVi0FDJx2OOnvyf
	 IWDs4WDR8ZeJ3kLp1TqPytBNhw7gjQ4+JBR+6Ebx9o0ICZlJE1GEf2y51l/hvleclV
	 pLmcwT04lWC3uvabP+LL0YH0vEQoKE1s5UqOL7n5XmZXM2BYgk3Wys2InAlgwOM72r
	 uOT52HdYr65TQ==
From: SJ Park <sj@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: SJ Park <sj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Date: Wed, 14 Oct 2026 16:57:30 -0700
Message-ID: <20261014235731.3646-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gnbaky9shmeijcapnf4idrxxdctxt3f1
X-Rspamd-Queue-Id: 5945A140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792022260-465167
X-HE-Meta: U2FsdGVkX18XV9Tiw31b1z/MFwsrntZnxy6mzsNv6cK2QG8hDcja3Xbf9dLhD+USmn2cwxQItwX6fQ6L0EPGCO0O75Nw5fwc0lXFKLvi+AWtzCl8Guqz7u4U55Q4KGiU7qPeI1ubU4EDKJN3a3qW70vgwVYmwcmf/1FKl+Mj/rY5j4oxFfMval+GH1njFV65iX842jHNxu/cAcmXv1t0KiKIZ9zPu+V44meN4Y0zqqIJG7V+CVyBuBGxQ1yqx0coy4RLmXqiVUnGg76euGlTAy+YXpU5ouIeK6ov+zmFmBqj4iBW2ryhN77hd4Gr8GsEXMHrLh31Fh/jLvTUfE2eyizvAIi5MQaiv7T5hOaRCxdCZuMyW7I2Nlas/JR19dcV/7GOQ2aEzDieEaH52gNhd1NiKuFnS1L0iPGq2b608n1GQIn5M6EfsZ0oUc4K6aVagipi/1HxtacNi7VfxIrmLZOzSt3q9mGI4sPhYYVTkHGIyYfjYZF2KBxeCzVTMYtvefF179bouuuLFHvQl2To9wCFvdoDjmOqCfJydly9gRlnG+wzBS/EoH5bS3CHCY61TJ/IO1CaAdOVoITFUARYvMMHkfYUSuqBIC91LnW+F45s7rrhorGva+cmFk22JA0UKuYfOUPoTr8+gjNCQVwz5ROcDJR5y6ERp69v+OJq0bpszRNUxT7Vzad3fgCbFrhRK/oxTO0/HyUtHYCe3KxM+fPiUIxlAEawWD5lJIJf/xwift8n/hCFGEW0YyIx+38xRFhkQl6OfZJMDKHSOZO+NVKxQAqBDs/C1wJX9K674lMPLOl+nA6rUjWYO+P7FWUgMdsv+ILl8oeB+653wDa03+bpR7w1dR5clIWF0+Ujn8AkbR9JRRGDusSmcp0VDqEeyTWwtHRYX+BwbaX8Oz0isTLYACtUZ/lDRbuPqyQFu4CytNHk/C1jjViczXJ60fm0Say79sWh8ZKNW7fddg7
 fK+uucg4
 VyfsVttNHRZR/du/kCwtdm3GN/v0Pes/4W2OiDOA1s3gPZg4kjzw6aCshpohc/J/d/r7cO8niuJiGuHICqEDpgU98xtvxl1MGkKUBYK8EHBFTlHFi5qDu1teyeZXTyT7FAMC8s5ILyMkDQ2OliRyDlM/lGyb1L3l4v00tmnh4l/uaqPjk8pG4HjJbPlmRHmlaqQNhd1qFgI3RTEnRJcq9hoDCJZe+/+6OYqUlXpM97GntXgdVejXhbJOUBACOuj/PeXZnX5/1W3DL1QWcMoAa9fy2OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Oct 2026 13:08:20 -0400 Tal Zussman <tz2294@columbia.edu> wrote:

> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.

Looks correct to me.

> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

