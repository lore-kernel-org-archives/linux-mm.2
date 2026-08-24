Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7299DC61CE2
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B486B0095; Mon, 24 Aug 2026 03:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6308A6B0096; Mon, 24 Aug 2026 03:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B786B0099; Mon, 24 Aug 2026 03:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE4B6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:27:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADAB6803F0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:27:47 +0000 (UTC)
X-FDA: 85135333374.30.13F4429
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1BAE520006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:27:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hghfi3F3;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787556466;
	b=4D72qn7fZjmY+MvN8mDneW5DUUhlbJJBJa51BCeix40rmSQIb7WIf3jTtnikES0y5y5khe
	VHLl5dCkFt2Yjbz9j2JsZsROQyqxQfKZoz2TI4N+EyaA/cG0aKmCxF75Ztn6UzgV8U7auO
	unHSQi2DUDQ9TjKi44vsNM+6E8NOlUM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hghfi3F3;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787556466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpXldSP37oQmlhckItfAzwUOG6JobW41WzP0kSdLesI=;
	b=yNKVrDy81YKI7FsuxETcN2HAfBH4k59/Z/3IAFE7f+Ml9MVJvlUoaBhUnMz4lMDS2fIhcB
	kvxbMEl3Yfk+Rk8P0dEwL0C801rNFH0htC6x5ThcxURzm6Z8UUtyFjMWr+iqr/WJOCmA/z
	3Guy/Wmxu7A87UuHotjsGcU1GUj6noo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 300B1600AD;
	Mon, 24 Aug 2026 07:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B017B1F000E9;
	Mon, 24 Aug 2026 07:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787556464;
	bh=hpXldSP37oQmlhckItfAzwUOG6JobW41WzP0kSdLesI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Hghfi3F3hhjgblfEVPUEEPHALjTTBAgKBK8MbewWtmMLpyrYB+8Jo29/224FAiShM
	 0SLcU5txHHDDVRBQmZbs0Km1ZqbqYphsVzR3okw73rVZzhWFSwmbPshMJk+4ij8Gwk
	 wBlW/tVqVoMXtxSb8VWH+7r37m/WC7KmAwdV5lxYZr50+jzu/iInwaVg4PoIgWPYV+
	 C5co0jxq4J2+miGm/bYP5+zECjtlCOUz+jUuPUU4mw1mdcjIPjf5Qqh658+sfYqF50
	 oCrhxE7AzAMSOiSyXc8TzEpXzk6qb68sZUnHfTQBzsRUMB6GzKuCnUN8V+wutnGyd3
	 qgVllw8rmVK3Q==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC V3 0/8] mm: Drop pxd_ERROR()
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260818040041.1891769-1-anshuman.khandual@arm.com>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
Date: Mon, 24 Aug 2026 10:27:34 +0300
Message-Id: <178755645423.3606540.14531883744138096395.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1BAE520006
X-Stat-Signature: 1wn9miefu3614tyefgau56hf7btzi4dk
X-HE-Tag: 1787556465-34916
X-HE-Meta: U2FsdGVkX1/tDygHzHxi/K+4gP0qJC3kAVDNJi0FiOSbIm8Tu+O/qp3LukuDCsZ4iWzMSMjejyBkGSV5CCgg+pzr+leGQsgBFgqkmFc51UaJcTozORQr+QMNJoH33YLIn0Y/J2G/FMXw/0tGk3DmtKs6W8Mxm1LOLSUHXCEQW8NtEx+qJZO+ugW7dbLNFS3NSgbGEPw3y1py3SrS9yOsBkeO/UIHbCY8QFIJqfIOrKuIY2ZUKM8m99b+V583WeBVjCdCpTKqDP6EKINcSImUidzEZWZIud1Nr4HjWBo5HlBxYKnhlxWCUmddNFfB0d+ThoEmQXip+k2tpGYYj4xsV8D2uY+HhnB/bjxbd48X+XlTxwKZGebanx3ae2/yiQpKLiNMLHh659esXRStsv+53q2QO92ujlQLWd4RG+/B3xs0vTmel9KvNKFsNCkLH4BnNIOPUypptsIEnpsFWXmKuuk+MZz2hR0NOpghrKLoZo0C+ufNo9s0GWSBUaRJWQHSNRHc9HMCpu+xvVT8vIAG/aHMxwJdT86G5OZj6bqqCC8EOrOpeyuV5YW2ZQ5DsMd7j8/46O88cmCm49AmeA55p0DSzNxo9CmSTqXFR0NWb0SkTUOMX6PN/SvSxOGGeKFrrEMhLHim6sdgzxtA87oA0LDnHRftfCokCG/33zqEkEkxobiOtq1Toutc4Hb7FjYUHVg42FFV9P2ajNz/HCuShET83Frd27aO2Lyyctx6i7cNB0hGfmw8wJbdZCkijmkcqQ9twrVwF2UaTBKAJL33dnG16spFX+tGpRCR3NnrgkUBvqQpi2juv7O2hFyvr4nLDtT+V/L3jibM1x1x8iWsvLTfPd+rOvbMg14jwuJgLz+ShzWrnTOAmw1ilBqDunetUxykDrsKrGwWHj2J2Zd9+SRTLuuXgYfLdMjvUqATBnmY51z3g9wTtHu+8w3k2F6Dql23iXwOG75YZeonxBf
 yj1emPNr
 evq+o3Q7bllGqDUDvT8zPbdlRSbAL18oRS3+WWYe/vTgYrqtQ87VIWUpVCM/8ycVXZQA/gj7BAXfzGoz1V1LdK2rrFVow7njjD3BSK6P3n0Ak02fhJIWQJ5Tqnjpa/pkww6pueulIgK222zXyVgpmN8lAuHc43RFOncuSU9p/A0vAkbJhGg3HMbozCE3DBbExAQfna8hoEJQ5Ed7l3FxWpgDQjwxY0GqDHPo3K/wvcIszyxNaeJZ09XpSXdbqfuArsV2Xv80hvyCT8Fa45o/l9QKuXSkDSME6M/0BEJ8riTFIN9Tybndi8yO7pcL0rcI/sM7q5U5FKqXhadCayv22K4uVVUAkgiDCgO5ds6NcvU0MkMyMzD1RxtVNdk1g2eYG+qNJ0BT9lp+N9cxkxpRz+3SZsqV7SA5FPfSK0pSdHHBhr+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 09:30:33 +0530, Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> mm: Drop pxd_ERROR()
> 
> pxd_ERROR() macros have been provided by all platforms, which are very much
> identical and can be dropped off completely if these pgtable printing could
> be moved to callers in generic MM aka all pxd_clear_bad().
> 
> But first cleanups and re-organizations are required in some platforms that
> are using these macros internally. Afterwards [pte|pmd|pud|p4d|pgd]_ERROR()
> macros have been completely dropped from the entire tree.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


