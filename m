Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF9EAC5DF6D
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 16:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445E56B083E; Sun, 16 Aug 2026 12:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1406B083F; Sun, 16 Aug 2026 12:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEA26B0840; Sun, 16 Aug 2026 12:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE9DB6B083E
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:56:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 647811C18A9
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:56:43 +0000 (UTC)
X-FDA: 85107736686.13.8BA2B46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BAD8640004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:56:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoTWVWmF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786899401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E22bAb27mfMqnbRiG04AZdJeCfsHv2IcYh0cVnbi8Vk=;
	b=7FiE8JS5Tgp6vHsFfGDgnF8QlmRiyVCbeF22aoypKh5UKzao5VyHcRvOU2p35Zls7ly4Sd
	QK9OLT8NK4h0v8opgkim6MpJDEPVU46eGYjQ21rCbIMpit0FAH4nshph5ijQZ7KRDuMqLU
	5+yT6z/Uyy7A8y9rumwEMsrYcxdXMJA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MoTWVWmF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786899401;
	b=cSka3s3dPUo6zcsjzhWyUiAKxCiEKUjubl+9pxWvHT2ZZdZvVHOklhhnVGXaz0NC3lIJE4
	eOmOVTYSwxOoo45TKNbox+RYOW36SGOIVeVHbsZhpcA7GUnO3rHcFr94kwaWklCCxjH5VG
	Bz0HsQqa1NrmXTFroeh4xQBq/Wu9/ak=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECE1B60120;
	Sun, 16 Aug 2026 16:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2391F000E9;
	Sun, 16 Aug 2026 16:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786899399;
	bh=E22bAb27mfMqnbRiG04AZdJeCfsHv2IcYh0cVnbi8Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MoTWVWmF1j3YIqeKXe6Zcl3S0IhuZuEXW4jICpFS155i0lG9Qduxj7ysRpwX9Rgoa
	 ED7J//lF0Bnks4pHOgZHXMMwA5nvtc2VY5nxlyHyT3QklK20SQAQTJuLmaZZaFsNBr
	 aFrIdXvX/J8uhi3M6tdpTAqhNH4D+J5vLvfng/llZ69dSBB5V6OdohPrhwnc8jYF3i
	 g4Zt4UEY3jah8KoVVRCUFF7NFE8BxjyNyHDgpodZcBjbgORLHg1iutERtC9A6sElQr
	 AACpNqLU/y15qDx76bzdFvhg8CMvrYlKKZuTj0LsSE274QrxQzlEKKIyWufwrXs62J
	 zoUQ/yrdU7xTg==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	will@kernel.org,
	mark.rutland@arm.com,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] mm/damon/perf: add ARM SPE AUX backend
Date: Sun, 16 Aug 2026 09:56:30 -0700
Message-ID: <20260816165630.84808-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260816142222.689624-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: hzrw7tzarutodo4odwft1mfhcrtorxoz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAD8640004
X-HE-Tag: 1786899401-205710
X-HE-Meta: U2FsdGVkX19V2ndyLRWKfceDNLzcet9tTNgxcqpqEQsip/mAH2S59VTNFmtt5wz1QqYfAPHO89GoBord6+88AahBCjbrcJOi2iEIlUGp8p5xKaIdO3oL/13eUhJP7y2JSEuQAMXlujItnQ/UTgjC+Hw4OlebDjSA8TI0SXBHXwbrpETWLouPoX9DZc4xKIxmjSI1DEih0utq+yiiS/RSdvByHDT6ODDe9uJmFWVN9Who+yoJwb2zIWoEYWiQMkkaYl+6W+7fANdpUrC6aPsRXK5K7lsq8xx+XAUOfDTCL5FFPvWZeJ1OKJhjfv08grO95GJieZrBzBgNEukHeMxmbBc8qprIEghBDgBIK889nzrdNRIa7lAmvsRUugY6Ju37m7zexfPu+wBKGt6nEvJJRyd+wJaPSLBPXRpI/TbURE5v4TkC2xWAK24ykmptMfvYbdmUOnqxAt4tiEwx4Cp+KUj4PKbC/ruS6LfqUhqybt2OjA+WLuNnzmBUS4Ms9ENY6BkWnbe3uGB2g5VfllDv1Fr6pmr2zPHTNAs6rEtknQj4uGKTcZv7DPIiSxa6Qlp0spspp3igCALvb728P4QLdIODgMr10b12o6fwOzO5/rWJ3Xji1pGrvaToVj7gn27HA/axhs1LrZGqLkRoCkOfPy433RTkWCdFt3qClLHt7X8Mwj8HICaF46uRHYCnZ3PRYBUnrXyjsSKWLpXtHzp3D7Cgk/OyFubL0hdjiDhk27J95sCDvV110nMSeNBM8AE73nbcYoX6o76nPOaMx/jom9Cm8Y/9zqq48W5vhWWkzFE7aAU6sDulXZVuvlweUVC7ChJyfXh3mWrq41YaRmQmnTGunKQu+hp/74+XOciPSM73ScfZ6truwWozGcLYflDW60jaWG0mU5med3esptZDEkNOXSj4dnaTXmn7sS5lSjkKU0e7/BTn0Y4XBK6+gbhXmpV09EYKhIC2kY+F/Jr
 Af4Dc4l0
 EGl7P/SZKOWU0otlx3byzogLqoE+tUtsWAcekEAoRQHBAByjNOolK0lTHYZT0yAUSRG1OIF4TgN9IVBBCBlC8Qhkhzn6ByPQhIz/W8QU+AmyvW8unFEF56UL8u9ZdY1lDIYPwVZviQREA8h8FWSS5jSRQ3zDd7sxxq57vJt87KYGbfO4GOrxTJXKBbUvid5qUOLla9bdDjtqRA5KaC+MT6V+Sa3i48FGN41Plc7cV+0aVH7D5aU23oGwgPdjkKDqA5ExbafyHBL21SICsPNVjPt/QhDKdfMN2qq0i2uHTFd+ZSGRqpHdZ2MbFdWRhjDHWAKxMnJQQNpd+MM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kunwu,

On Sun, 16 Aug 2026 22:22:17 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> From: Kunwu Chan <kunwu.chan@gmail.com>
> 
> This series adds an AUX trace-buffer backend to the DAMON perf
> observability framework, enabling ARM SPE (Statistical Profiling
> Extension) to deliver hardware-sampled access reports into DAMON's
> existing SPSC report ring.

Awesome.  Thank you for making this.  This will make DAMON be more useful on
ARM machines.

> 
> Patch 2 touches drivers/perf/arm_spe_pmu.c to expose the PMU matcher.
> This change is tightly coupled with the DAMON AUX backend.  ARM SPE
> PMU driver maintainers only need to review patch 2.
> 
> This series is based on the Ravi's hardware-sampled access reports 
> branch [1], and depends on the perf AUX kernel-consumer RFC series [2].
> The dependencies is not upstream yet, so this series remains RFC.

Unfortunately I haven't had a time to thoroughly read the dependent patches.  I
believe the basic idea of this patch series is aligned with the ongoing DAMON
extension roadmap [1], though.  That is, this series is supposed to be a part
of the milestone 3.  We are currently at the near end of milestone 1, and aim
to complete milestone 2 by the time around next year's LSFMMBPF.

I will hold review of this series for now, and take more time on making
milestones 1 and 2 for thier planned delivery timeline.  Sorry for being a
bottleneck of your work, and thanks in advance for your patience.

Please feel free to let me know if you have specific parts that need my review
right now, though.  Otherwise, please make sure this is aligned with the
roadmap until we finish the milestone 2.  I do want ARM SPE support of DAMON.

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

