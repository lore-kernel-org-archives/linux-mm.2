Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 558F3C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3882D6B008C; Mon, 14 Sep 2026 10:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347946B0098; Mon, 14 Sep 2026 10:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284606B009E; Mon, 14 Sep 2026 10:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0983B6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:38:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49C298016C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:38:27 +0000 (UTC)
X-FDA: 85212623454.28.922F771
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54DF0120004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:38:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y+q3qCkJ;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789396705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TtHTqL+UFORJacBemcx0LNXtW0Z0/+7lM+21HB24SRA=;
	b=P5s9XT9uTWFkgK+7RdsRFLw/bgBaSl358Zrl4yPNm2xspx8Q15awmBrEA1Mh3dZvynHxWY
	OnscIRupLIVtSQhoMT1r5sOxHxXC4/YyDKSus/s9u6nlZpekOXOFuzUPo7zRZ94cEwIQds
	0fi29yMiFR/V5YGk72yH5dYMbx49amk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y+q3qCkJ;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789396705;
	b=SP2KGO2VBK9c6o+7i/53Miajp10LYXu67vEitKiqt6yMVbEY2KHHtBDMw/PtDya4Hj4GVs
	s7yK4oEF/NWIuBBDBBzRclfN1NOFNkNQ/5NTG1c0U6W2NlndP6t3b8/HC/mLV/GBxEVbfY
	L9+8/NvKu77AmCNgIuHc+9d7eZYj9P4=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc6db0bso28895266d6.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789396704; x=1790001504; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TtHTqL+UFORJacBemcx0LNXtW0Z0/+7lM+21HB24SRA=;
        b=Y+q3qCkJRYfoc3Xab58B1jug3lZQR8F/Pt/209PRJj5f0F3b6qv48FURuG1aGd9IYL
         39Xmn1PVJmBFmdx8xMz/GEyf7VzPk58Ctt7lbM6DeTaLkzI3kGweeBNpArzd41MBJQiH
         Qvu6hOnSfV+DjM5PAuiEAx2juJ7Xp6WG2hhPZV8YjdI/x4DAchhCrg9tPIgIRQcuva4Q
         wDkLrwjkbBX8EQHoKbc85zxvQJRDAFx6CQNVYnoBVBEAgwSBcSSyIbnMh0w+XW5YdVcQ
         EdF5udj/cypxvXCtrcvRUISIrNk12rhTW6S34tdmpqvmrtpQ+pzzo5n4wEmo3A2AoHKW
         axuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789396704; x=1790001504;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TtHTqL+UFORJacBemcx0LNXtW0Z0/+7lM+21HB24SRA=;
        b=RZZiA27o9wgB0f1bkdeVJvIdD9hDA/UsvzkeAtbIr0NxbaYuk3TzKtTMsp+JgKWFdM
         tQLe5k/yacdhhJHHUbbko7aOrV3vBEkiF+TqikO5Shc4ToB4zRXHzCU1aqOGRuI9qWwx
         jim933iemnbFbMoKlBoC0VtnmJk+IL1lWRtyKDJA5sv6bHkqIgWYzOaTAouNpG628fZe
         JvlzJ/w+EvVgdf4wF3/9+0yi64lGvvWunfavI5yNr+hAdZrquvpeKwdJuoWRcMuLlWMb
         XIirMieD39XTBljcpglIXqbOlRy0oj6GoFMRaICScu9KD/WX6Ag0yLAN0SHSLHF7+gJJ
         vAXA==
X-Forwarded-Encrypted: i=1; AKwUvBwYq5L6PXb53oNL+HQp/kMRIJ0ClucNN2OqnBOKufX8HVqMRZSPEF/xcUObSiR8KfTgdyNu+xRihA==@kvack.org
X-Gm-Message-State: AFuF++lRiRh/Epb5Z/ZgBIY4Php6zuupMuubRsYtPxiHSiZdcs/GbkCO
	a0U+HFxKR7duKyeKv/Z1iG7KCJww+L2eJaGqoYKT0ZkqhnrMVdNgJIq4Heh0P4LBg71M2UiVvHZ
	Wdg2x
X-Gm-Gg: AYBFou1iKSLNXQfy2g4BTA6QBhqZX82X8CDlxoxOaIyYg9xdfNBTPgp6B4u13bv3Q+5
	47lD5myQRahNiI09NMASdaXFkMK3A3tfOaH2Yp+A9zkJKqV2i/UQlgJzyc0Zr9HLVRIpXRv9YWE
	OdAvlRE8WN88c4/zoq9/XA6A9Mp2O2ltoamzXLvEmHqSyQwsbJeWAzGKGfRZJhowB6WCEq7KN12
	QYm6cX3AFxo4r3Oswj7CeE6YKbZ/0U7TZ6nKwMNQJof9uZDv5MWMUK3NCB5ftOtCL6w8S9agr0M
	xlab1fT0Cyc0A1rioDPI6AAGteqYrlrbAEMopOkIUUOvEPJxUBdYhJuTOtc7mzzUh3vJ1phHfvr
	R23t+VyXDjpPhsTMahadugOOph48vmAeghnivguBpDqtbWwI7Y7Cuu71gFpS3PkKbPyRfxGuqQc
	dkJOKs/rVtMWQJm63hoXuNl7TBSCLpKEyNQ2+FDwNTD/x0mKVW4VjtoLCoY3KUzzd77tUXLYvRN
	cHbUvi8pomwNFcmYvddrVvD/wI2b+IExJeNfI6xKWt9/dsWZAllO5s=
X-Received: by 2002:a05:6214:8613:b0:912:12cc:33d with SMTP id 6a1803df08f44-9122e552dadmr42040046d6.23.1789396704371;
        Mon, 14 Sep 2026 07:38:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f4d389esm95618176d6.42.2026.09.14.07.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:38:23 -0700 (PDT)
Date: Mon, 14 Sep 2026 10:38:22 -0400
From: Gregory Price <gourry@gourry.net>
To: "Zimo.Lu" <louis2665573906@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/memory_hotplug: use public nodes for migration
 targets
Message-ID: <aqgGVIJwV9wt8gon@gourry-fedora-PF4VCD3F>
References: <20260914074323.3567923-1-louis2665573906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914074323.3567923-1-louis2665573906@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54DF0120004
X-Stat-Signature: tsxs7nzwg7bhebnehw8d8caomgmqkoqg
X-Rspam-User: 
X-HE-Tag: 1789396705-874929
X-HE-Meta: U2FsdGVkX19zGvUZZxIZA6yOxP5dsS2lIPQFUk/hgrMJm2RLPIsx1Zkudz0asAalrT42PH/ZflCF+idUASRvKpBQBSfvbT+aG/s2hB1p4wnVPcMDEFW/LkB1OUsotBTDy0vkpyfvX0dI8VV1Ji8sLgpwE9GOxccGqTxwFMttbt4cQoQwxhw2RFhfddUrPT7aTXWSshN6uMK6ePM6tqf6682VSBCuVlVrcTVtnSBjSoEtcgbOtedT4bMUrVbzoyEulM6oQ8Q+xGrCElh8kqENI6dTp9NkF/25nPgY3PNYCBHVr7rSRvVvdHOFKXzs6PloaxNOvGwl1nJnK1k5uXH2Lgm2WNFBOw6jwOihrPDxCBYlLFd5kJfKAYrL2c2C+pd18GBizHJ8PlXxcr0Dg3LWUy/GWAaQBrEowbXNRFep+VETJAIRqgpJbNOWyPSFQ6fzwNKJUvGzbfNAt1R0fGB5XY5iiOEXP/6AluI1aj8h3Jd4Ed++uaz8dLbHD/bxRjh1bS052GKeNYUzN9GO2nJC91RKHxvkQMQez/0+xYC2+UC3NaSW6o0QkqaAtGQAzE7ixu051YkYJIgeDXEDWrlA44oXriwz/B/3tJrmm6Wefx5gVIHYQBnzpX56y9hFYXIUmdIB1ad2kZ+Gdg/JM6yLGPD/gTDurvEtZpDEuS4ah9JdcjOldeijf4JX7rjpes6HKDiULtwBGU+jwo5fpsUz4HGyuPGqQS3AmvwWWHfEEqIOp5YGTeqMCEisTKiPWod2Fwyyz5VbNRXfTBYbAyAqM7rNYxFDwdwRFrZithUgk49Axx06inyD7L5wXv69Rtfb5VEyonidDmsFOxYjtDHXi+HmSF72SNxO7HPAJFUCHsS+KUj0YvOUKhwM6EMhZZBqKDM77miQv1RgXwHUzjBdrRqG1GckCm2YufS9yQTNc/tOSjEQNEGOb7qh7UXP6vtcF7bKGpGUPagoHKU7BR7
 +TGCkHZI
 Rz68m7xD7vsPQCzGKWtpzFqb1xPKYivuamTH60aj1hJJdswka7aTVdNuTBVOEOotzPxVlEHmM5J5Nsm8rSW1od3572isj0ZXpdAY3l+ng7o5q0Fey22ywksJnvWGVO3MfI99tURgb1hrk4sZyRFI/iUarKCb18azl/S1MTxMbTkWHHhcZAm1XdR2UqQfojaCZBD9jrSn8u8eVR0zFrXtqhupZ+xoOdIgHuD6qy0YNemQkjHGamiOlrRYVwMp+HvZCej45nPaVFTF4en+7MO4OlshNyQQYNzwzmJh3RcjDtyncDEl4OR7FtdmJMdWIwrbeA/514S1Hy55nEl6tzf8dXWg3CnFgaU/lqNKlRQU7BA1JOVHY+vFQBCXUXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:43:22PM +0800, Zimo.Lu wrote:
> base-commit: 38c7f48162aa282dc6a9edfb7011378594057c10

This commit is a random github hash from my v6 working branch that no
one cares to (or should) know about.

I haven't even RFC'd this to the list yet.

I'm happy to work with you if you have feedback, but you're getting well
ahead of the work here.

~Gregory

