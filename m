Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA159CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C0E6B0096; Thu, 15 Oct 2026 15:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC346B0098; Thu, 15 Oct 2026 15:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC3F6B0099; Thu, 15 Oct 2026 15:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68C586B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:36:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F115E140115
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:36:48 +0000 (UTC)
X-FDA: 85325868096.01.3A6378C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66BF1C0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:36:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drMwZbZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792093007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1z5Mj7Qv0mYk0cUgbxcksNvYokCdAeTNoA5oCpS1fmM=;
	b=oQwmKG5tsjGympAmFzzmvcZc3tDiUVUu8YBr5PzBkVkKGhL/8nyjPGRbsxz3LXUY1G9V50
	dEz2XL06NWWuOO4i0jVDEz1YIaqa7ilacwhKbAvz5PReD5LYo01uT1uhK6lkjT30hf++i/
	XN46t+UnNMVBx6Q4TNBXK2rtGQ0f4aM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=drMwZbZD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792093007;
	b=zieQQNI+CFz6UofRmvQ2I5p5ws78QK8devHuf0M7M9ixvNN5uG/NvzCKBMdTQDP8IVoPTr
	vg3HZDOJAZm2O2UFg1O/QW4KMfIVt9Kgn/iY7wBO8Npx2LV4ohXnLOAKwbO/OgOdtGfraI
	/8u4CerkmYx9NnJv792nS8VUcw0SkVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E10FB601F1;
	Thu, 15 Oct 2026 19:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5B91F000C8;
	Thu, 15 Oct 2026 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792093006;
	bh=1z5Mj7Qv0mYk0cUgbxcksNvYokCdAeTNoA5oCpS1fmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drMwZbZDNf5+SguqHmNBtAZ4xBACuClt1Kn5WP8X6OgHcKOUP4M4lyfztKSHJFWNw
	 yBOf74fpKVFidbWhQmjMn/a2ky6uZx0OE0ES2b7MkkfcsngKHndlmlfsitqVXkkQfG
	 RxPJ/ok3KK36BmFbmumSCMNfeL+84DdfCzggpOa90Y1E7F9GM+KgekTNP1QcBDgUJH
	 r/ULWLQClMqCocZqzFyrh7yx4ezGcDPFR/HSNpGpRhCizuDidaiAai7KSyF/xmRk1j
	 xCpDFGwZW0hPforQwl0rXRQVug/7hHzJu2uYab8ZGQG2gd2yaUg5OAXg0gaGpufCLz
	 sDP3yCR/TBucg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Helge Deller <deller@gmx.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-mm@kvack.org,
	linux-parisc@vger.kernel.org,
	"Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Kees Cook <keescook@chromium.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Tony Luck <tony.luck@intel.com>,
	Gyokhan Kochmarla <gyokhan@amazon.de>
Subject: Re: [PATCH 5.10] highmem: round down the address passed to kunmap_flush_on_unmap()
Date: Thu, 15 Oct 2026 15:36:02 -0400
Message-ID: <2026-10-15-1-daily-reply-0019-highmem-kunmap-flush-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015112701.650511-1-gyokhan@amazon.de>
References: <20261015112701.650511-1-gyokhan@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66BF1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: wy16h814jo3zibb361x719rebu1szj5r
X-HE-Tag: 1792093007-138000
X-HE-Meta: U2FsdGVkX1+fCooZZPiaLbWz+BLF7Xq1xhdwP1uaXzPCUWsFcbOYh6vmUAkihOPi4kODx95Vn9vu5PjdxTExZFUGiRiTIxpwJJrNlfhf44aPCtTo2vc4dAyVvo4/AvAEsN14DNZaF28Y4X8NqONhLVAdIRsITK1ey2rO36wslAz2Rd6ytFG1dQ10DUdrmRqzShH3gcCYGorv3dmkLFMrQIg5OSDtR5cbC55WkpI7sSj/bO3jHJfguX8M9M6c4+QCHofi+invwZEEL5oAyakdFo0Zy3MWgy4gJwh8oh5ovafzkLytYXhInyLcPCoCZvWBYY/Fd1MkICdaDkJuafSMyEWoHUNdB3yuclXgjKZ+q/J65+cNgpvd8sv6sXig8/x5MRFiFOS6e7zJxJOsk7LHPNTfEUDkRcJnL6nxlhSiStSIU5/s/sSnCW7x7cHIPEe6qS43iJlASDpZqkOtlig5ckdYHEVweZ6+EZpNvB6ukCvfftMahpydSRVw0+bbzSZaBD8f1Ascqel3AhE0BCzU1C5knScqLdcRHMo6RrIQCMIbQoJoNvax+gqqKIP88SSWLu6Rw29p4QiMrMSZcOIbK4eYWZSjICI4KUcgdu9Fs2Gr61CTtBMx/STnqzxwN9eL22JbZ0ManPdaMeJV0GOl/BSravjPA8ah3AI0fwCUm+jM0BQsYnuVmQ36z16qlMJSytjTN+9JEO5QFdLdo8+1LnpIJGGm+XIB4aUOI7KIV1KCe2BtM+2Iklx1LGOBIMK8ugKPf/wN2sxjD6Fv93Ro8O0JDMT5lMa/9ugZnnSdpfuckQHzQtzeFvNxJX1oKez0+PeoLujYYiFXSeu1W8FOB4+4dgv3ChzqqnhjusVxZuhKiZydPQb5CouoXvc76CME4Bf0QWpsdrTU4n9lkhihSxkQV5p8hadAp/9EAcJPFBwTmZDGSBeOVtlmVnCnISH6wtVPZIiP9aTOLyD9YxX
 fzb5zziS
 vAVx6ckpWyy7Ib4Uo+zt6b1erSoKG1Q7AQb1Ef/bpgmgVg/Y9vwl0FW+85eQrfccXMnxH8qUtOvWcrNX76aj7s8ou4heTYyZLTOYLIaqNTTaCRBvZTUfB7zm77DQgJC+AGGpM3eMoSz3JcDyCHT4rBYXT/H2mvz/rS+FXTmRSFyckmHR0cZ22jo39cQMSPzVfa+pl0/XXlyR1c2HYuXrJQNYYqsHf4Gp8TqVPUJBv3/k/iF1mfCEHHzSAlD6FvBFDON26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> We already round down the address in kunmap_local_indexed() which is the
> other implementation of __kunmap_local().  The only implementation of
> kunmap_flush_on_unmap() is PA-RISC which is expecting a page-aligned

Queued for 5.10, thanks.

-- 
Thanks,
Sasha

