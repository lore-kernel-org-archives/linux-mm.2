Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D28AC5DF81
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 02:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4E16B0095; Thu, 20 Aug 2026 22:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5726B009B; Thu, 20 Aug 2026 22:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DC16B009D; Thu, 20 Aug 2026 22:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A032E6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:23:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2101BC0303
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:23:49 +0000 (UTC)
X-FDA: 85123680978.21.AE20192
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B9CB40009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:23:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKOdp80K;
	spf=pass (imf01.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787279027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwj029qvfIuS0n2IlGGdFsymc671fa/erueghYr3m0A=;
	b=2jYZ1Wk0J7ArGPRR1oByjTyVQRhDaAdYj62XaF3e5yuI+xCaT6kETIqM81qXPNXFysi3z3
	mQBaun6aVMguxPN1n48Jfn2WCPRvP8F1VADeGLeMb0JRe2OFa5+tiH1sKx46q/RYhqgGF8
	K1il4tBaSqrdgNLH1jIrVknEuTvAYn0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FKOdp80K;
	spf=pass (imf01.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787279027;
	b=eYCts8k6sPa4YF+Rs5lO9FpaRkyB9aKVHevehAVFVuAMjm5MzbCZrQuQrNs6Sins9hZm+R
	2gawhLpDQzs7BJSW4ulBz9yVLqi/x8YpBthSHbrDPlJDJmwbIYaOqXi8Q0guZ6fAFRhfS3
	wdpBiueEuAI2wZyfxu+/yxTth/c5BMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E251A40179;
	Fri, 21 Aug 2026 02:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7941F000E9;
	Fri, 21 Aug 2026 02:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787279025;
	bh=nwj029qvfIuS0n2IlGGdFsymc671fa/erueghYr3m0A=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=FKOdp80K1NCdExfZ1tcV6jarRclI8uxefHf43o0VfsGMY7h6gHGbb2Rx1STpUXm3W
	 ZqllCnvzbL/8/x8dercSC6kVEvqT2XPEZGyYrbE/rwLPpSiTtbtKl/4vEvNiotiM+H
	 /ppk8euQ1OD384/8sy5svQj87ViMgNLjapwxeRn6TmnDbBv5i/zXQQ8t/325nQ2NjH
	 AqolJF6RXXh+L7bpAQA8mNzojnq//qqj9QpSOI+LWw5dQiVChms/JXaexpX7c34u1l
	 e++Owow0HeRcTCq1jG3DhsIBIx9wYnOEK/idwAIO06GpBh+b3diywe7T4A4oLu4hfJ
	 p6mVte1Qi/1sw==
Date: Thu, 20 Aug 2026 20:23:44 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: =?ISO-8859-15?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
cc: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
    linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
    linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
    linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [PATCH 07/15] RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
In-Reply-To: <20260302-at-vector-size-arch-v1-7-a11f03ba2ca8@linutronix.de>
Message-ID: <236a0edb-76f4-a28c-175b-f43994310a9f@kernel.org>
References: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de> <20260302-at-vector-size-arch-v1-7-a11f03ba2ca8@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-746012605-1787278993=:86110"
Content-ID: <1dd06b80-a066-feec-b1fa-addb8fb6fff9@kernel.org>
X-Stat-Signature: 7wgn6hpunxgzg9637boansjuzco9kxay
X-Rspamd-Queue-Id: 7B9CB40009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787279027-810512
X-HE-Meta: U2FsdGVkX18pQtWqlte2fVYKTryKrIw+VZ57aSmTrs/jlt/PvtzMUCf4g3H31bV8zK8aiPLzEmZ3093hgp09rQ+eNqwAZeuOXnsqCKAUITapSMewANHcUhXYZdDjTpVSOPqb7qjSFTQArZKAhQmxe0FX0kqINzoe6UpmIW1tB90/99EFoQ7CLZaGKZbJHEY5HRuEVCtJ4+anSFZqmLiugR5IVmSKiTutsSLi7pukTjAHaANo3hBFsTyVwnOGnFZa/7OiDd2tRSVKsw1U5cvtQQolnsm+EeyAa+FdcclQ3oI5XWbVsrkIMe3vOqQC7KXvqWwxrGJyrN7y88YVB8eRcOVghMuAHCQ+haIsn8+8cxIW+hLBBKv8kKRagsCX2c/byepUtcwAV2bKpXdqdLvxuu9stHcb3lZAu2u3XkgJPPQp4PunKki7WCzC4SCobxTIl1XIjyt4TwuSQG9lO1K9MZn1FlSzHezkh1T5+8gSizU5cD/rwTzm+SHmMoT/YBCGaAP4G16bKfRGPMa+j7pAD8NyNpMGrwH51hFNBw/5neKbmoU6WQ0WA22HCU7WyjUCM+2zRlXN5RiiodLdWNqSbImFyjQz5EWW9ACoK4FSpFQT44wZ06J3p0Pwl5DRyp11HnQPl3c5d9hxZs00SLctB8ujc+jRI0l+qm2+Fku8NpYZXlFjT2q6b8QvFsH5T0iRDtIrehtqM0UWcQ9VAdItC2Xb2mwrLHsidbz1On108hJfW3cR1ixcZCIgpPqCFBci80FSdd6xFZLsgEsD9tYi/n9E9CM+1Sv9J26IQtxHDH5KzZitA1ZuYTIpdXNkOJKMzqeKFXgj6y/LBzw1fHUK6deOw+a9qwD7Lhd6Fx3HmIRvcAAZvMcH/G/V90X5HxF9bfWebzm97C89RamGXFzr8BG/EuY4x378wxhi5pm/zfR2aVsgazeKKnev2m1Zb+XUzRYDmhmcN7KiEhjA7dk
 DHnQR/Nn
 0jeWoRJ0HN4hu5Q4pnkIYSFBpPMAtHOhvg+2YUg0oD7OncdjH5epCrWMW2jxXgTtNqI9mQH+B7PKnG3TM/6AoGYkJGdiAJn5VadssVr0KoK2qKrG/uGwW/B48/jD5uF+zSjyBeTV2bB6jZAjk9PA0P73BJqZKFC8wWFgeAKOLZZbNH0ka0WOv744LMlXopW6jqsoFlGsjBYhumr8/9jtuktr04kZrOQExTzu04bZxdVrhJIrV+wnLkInA2q8C/AwnKAiIVrgI0vqPTPFzIYHUPbZxA/a3+OQo+apPbz3N2vJTb4i50dpKYHOagKgDdVSWpIjHT6Sb0ucdcqfedWoxaC+0/XxQn2SGabvcaOw760sA3fMNrui7PpF/bT5xvNTaeq576xxubZx26PRc8Q9YsLN28d+de5MWiy3zbeFdfVD0luFNyBhp+APSkKml+fL/qSbWfVRp9TtyOkojtoZL5s8R7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-746012605-1787278993=:86110
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <c4da6fb9-7dfb-d0d8-ef0a-6c21140cde31@kernel.org>

On Mon, 2 Mar 2026, Thomas Weiﬂschuh wrote:

> There is nothing userspace can do with this value. In the kernel is
> always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
> userspace and also changes from time to time.
> 
> Move the symbol to a kernel-internal header.
> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>

Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv


- Paul
--8323329-746012605-1787278993=:86110--

