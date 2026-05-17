Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F6BCD4F4B
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 17:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9CC16B0005; Sun, 17 May 2026 13:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4E496B0088; Sun, 17 May 2026 13:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98B616B0095; Sun, 17 May 2026 13:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 855916B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:38:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40EEB40668
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:38:16 +0000 (UTC)
X-FDA: 84777620592.16.F793F37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E824940015
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:38:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFLx6ZNf;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779039494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KisQipb+u8ZX/MhoM0RgywoyXEoAnE3ZKJTKFmwfaO8=;
	b=NXdtQYVTDaPnsc/greyb7dJixgiXaugu32/+XleNz5w6ys0NkgUk9kmi+FQiyDeUl2f4e4
	WSB3ow4eBu2DIMLJFO9cGwhgVsqhyG4wlPCRXAAcA13doSykyRB/NjiTkT8tSluR7QBB4q
	1jpU72hNycLtktbB9S94ajHxLVr9IIM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFLx6ZNf;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779039494; a=rsa-sha256;
	cv=none;
	b=cTS+5GBjLInEKTlYDuAM8wkTNQ4ngnSz3vItPeJwJmKW6zvqhTQsbeyBfUI5CByEDqG71y
	/IXF3vsa8gIDKTfRInubsC3JEHyQQ5f6JSd6Ztcl4PRWA7u6Ha7MqlsMoBYiTFFxddATRJ
	e+boaj1SosUKj4cahjMzqQ0M9PfbD3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDE7943CAC;
	Sun, 17 May 2026 17:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624B7C2BCB0;
	Sun, 17 May 2026 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779039492;
	bh=hUXEIurEBWkC2u5wz4FjIdplyJXliJSJqkf1ECw3UDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LFLx6ZNf3rrbva2M3m65Nd4aTUKBDskBTAyJvCjKxOWOWO2U+uXm55P1kFR6D3V5B
	 2MghIV+hpD7aSSqQ9qjxY1v9NiV5EuhzuF/tpzGOtf2xJcKApaPaMkRt9vT+D6xMtB
	 WhKI/ZquiUJE/91W4Vl3vVJ+nvSp2GiVE7A9FqNJij3E0FbOQvX8MhfzQ0dCaQ0Vcc
	 weiEdPQRSeTvrepjQbsJ76kfFv8m/cSg6Au6rflUxL7NuXB0MaLp5OTzaFNN0AoVkC
	 TbqxfzIevYlrwaGMBK68BNqj5UMzmD7DONdBpD56DqyFVugzLDSZ9nU7Ror2x0iwRz
	 3xS5LjIPteA5g==
Date: Sun, 17 May 2026 20:38:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, corbet@lwn.net, dmatlack@google.com,
	kexec@lists.infradead.org, pratyush@kernel.org, skhawaja@google.com,
	graf@amazon.com
Subject: Re: [PATCH v2 10/10] selftests/liveupdate: Add stress-files kexec
 test
Message-ID: <agn8_FAtMdc8B5c9@kernel.org>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
 <20260514222628.931312-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514222628.931312-11-pasha.tatashin@soleen.com>
X-Stat-Signature: yj699nta47ycqe99xsdtugfsafxc5yg7
X-Rspamd-Queue-Id: E824940015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779039493-301351
X-HE-Meta: U2FsdGVkX1/Ix4OUs1lj/D9Xyqcmlgy69Obhb6RaX6goNJTgGqQB8ZsT8i4Sq4aanOKHEaaIHCVd+OvJgGX2E5kkb0AMLHaQjqOO0ld3uDa/ULotdcQG3CF7PHIYaAkDRt448M41gNqHDcnkEp7KTQycaKZjS4K0FuT0joB+Q4Mhrk2v8J3QEe2wIuS/oBgIdd9ToXZdrrwVm/xh8JsI59thD+M0CLSMyvqArlsN06vwZDGua/ttnnnNSEFz4fBx69wPCVbHqe/EcdmAhM2yCFcU7/skYKFQVvQDLnQbdngr/6KnxNr5VSu2WsuotJKfykuxzkQ7whCUr9Z4bWU1HAl6+HCQ9auGEX4R9VeeLBUvF7G99TaOkDNbBc32ePCDN/iQuKVAerBBq/eOpFn0A+jOMQlT9B5f2K///B8tQNq3mPQqvuH4UeRM8KpuZ6Q/cEoKWqq5FTXH7x1PYxebVYYg91wdfVKoOLkBR/l25NZe0GIjHBmH67x3QncHY3tjp6UT/1wDXT85k4I6juRLinbEM1DiW3puqcflmwx9QJ6MiPFzLfcXEM/3GfYgstsq4sOPJqDmEsJKsAvVr0ina8UCG1b6ElhxPEETVFtWO0ZT6FXTTWwIj6KLtUXn/RoD5lFhHzbPsMEig0iIaDZT8UAG/9zdpkBd1fPpv6M/sKURYweND2/R+n5+suaNrkqO67DNvq4urSP2uY6Nm4y4jAfyhr4bVu+ywqRCW0Abob9ge8y2OvM32Y/MjIoU3Gg7DIJVlF/0uHe3kFwN4p70QNq9cPW3E3xpIR8nQsj3MCHN6U1Ht/1tqC1WpQ3EDowzZL3MAJcC6N9NBM66WQT+BepEBgb5gm5f8j1RKskH/VEPq7sKIVqELx07OtdsKyQrJPhDprRGdnfJHmAQTQ/Z3TmHDzEPP1SARE4/pEbDleJlXStA47ngoTypiAdKXP1aeUXisHAjH/2Y+IPYhb0
 QmEsqjGG
 ejGe9eTlPUqH38U0VPM2s/y7fYrV7S/Rvav6DnvGQaMUbOOKefBPfbHb81rVMscNH97ZH4SDkRsTLswzvx6oVB4uRIn4JwfMOe8dUZDHWpu1RI0fvcXSpQ5wyumPDt9ndFPuC8EA57zAXHna4gXdncPlSysIBHNW6XIQWBPQfObz2+UUSfawUUGXvno8oOM5i6BgChP+2sQW2Hynj2/ABz6zZe6Jvp5zNX55c8RTRqO93oULd6lVltOB3Z+yFH4EDrYQVSf8KF5hee05f/c4rzn894vNjmrm7QbB84oSxERy6jP7a0svgcOHukrmyEc9drljkEgLyIoiO0FSb2cQs84Orbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 10:26:28PM +0000, Pasha Tatashin wrote:
> Add a new luo_stress_files kexec test that verifies preserving and
> retrieving 500 files across a kexec reboot.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/liveupdate/Makefile   |   1 +
>  .../selftests/liveupdate/luo_stress_files.c   | 101 ++++++++++++++++++
>  2 files changed, 102 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_stress_files.c

-- 
Sincerely yours,
Mike.

