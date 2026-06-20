Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56DC2CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1EA6B0005; Sat, 20 Jun 2026 13:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 263CF6B0092; Sat, 20 Jun 2026 13:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B926B0093; Sat, 20 Jun 2026 13:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E630B6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:20:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56B56A01F3
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:20:43 +0000 (UTC)
X-FDA: 84900955566.19.9047028
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7910D40002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:20:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K7RN7MWW;
	spf=pass (imf12.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TdgMWRr2s45zf2CRds4OwO6qMuavpApSwfTh/s1olI=;
	b=fPY3BUkn8etJoLcT24/lFupFT6FLRv80InkwWBkQDEDa8xnk2V0pe43qt4GzROQ2fnQY/n
	DgTt1jg8cMwy5DOP4wGqkIHwOF5NvfAQyfGbPIG8LBn10y2hQd3YKYlAWp+KGTyAVCEgvb
	xZkXga6ecnWK5SFtsPq6AhF9RhGrapU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K7RN7MWW;
	spf=pass (imf12.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976041;
	b=4Yt9kZhQ7DQncVYWUPL+Z//CzkSezQAPpTlzEC9kDnE4rA2tKGqFiWCBwKWiNCujPHZVXl
	zKJllCnlpc/QF1hGIGN3OkiYiwH787hwP9EIukhGNP4WAzQUIIjpxyfqkSZlEs7lLd3yk+
	4g1QKDcrCSIp0mUYEzosNzyHaQ97BqI=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49222b6e871so25600645e9.3
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 10:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781976040; x=1782580840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TdgMWRr2s45zf2CRds4OwO6qMuavpApSwfTh/s1olI=;
        b=K7RN7MWWuXg+D26fAxrW+NPVgqHP9v03/BKMSu9Ga5g6E0d0v9bA9CecZJV8dlIidH
         bfC2TQePhCcj2IIiEkkuTaFZn28m9Ruwh5vIS/04/6sqCi952at2W7RQshvOkWnF3uZW
         6T0uohqZG95VUqOJR6T2I+reKiY/djf67rHnBZnPZR2oIpIL98Kp2/65N2waF6etXav1
         63ssNqXudEdDA21hXWWOVdyxr/tv0o45s6baHRUadFUEQl1m2cLlyKj4ndiFA+LT/Ko6
         bl5UTzRuVHT94bBAzFODUj07ObT4oBZ6NPbVN1RPX48Ev+Vc0OWYJJ+N1mOxewrkw3b/
         94Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781976040; x=1782580840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2TdgMWRr2s45zf2CRds4OwO6qMuavpApSwfTh/s1olI=;
        b=oBx7dccIaYWTtEiS+pJWqRWOi1qiuB0yz+GiBmHUPFDpXsKMI9mp9ypWS/eW7rAtMI
         Eb69FcBhEAOS1131KRdEEsiIvdl4oBzTC9A7aM3bq9qBYNIXSQKIm/Gr7Ms6RPz2K3Rx
         9ueYt6kd9ySvXRFoFopbseUc95aHvjHn0O0STnQtlmbaBc8WkccSKA5NyGXSeP/5GOzq
         qLtnq/hh6T+ag+4+3NzXhROEtQ1MCVssTA8S0MHkfGy/GZggC2ZdRpXAc03p+m0LLVYB
         OJvpPba+RCTCPvzPPyirClYi/aAb1KkMcYwBO6mjbx1D4tmVFORP65r2+q9fGAgWDFx6
         F/ug==
X-Forwarded-Encrypted: i=1; AFNElJ94DlHtlqX2JOfPm8fnaaAVSyNDUlCNt3uVi9xpw+V2m3b3M3WmSqPSdfgXJCUrLzbJro8fsUkjJg==@kvack.org
X-Gm-Message-State: AOJu0YyOWmhXscqc5fVLv1CmXpptpuyi6Ijd34OK+VIV5UOBBtHiZaY/
	lNu2w3Mxpo/ToC83PtLioRtzrrKF6xfzvtYiqeGwDQpWArpZq7sZ0y3B
X-Gm-Gg: AfdE7cmODSDyKTC1tjNcsnoy9TYNNUXJs8N53o5PSMSfQfaq0qNGY7NYYoDhc1aeZ4V
	vwjBWGizEHiL5q5cfuzG3RBSprUkNDAA1BoJIS6L+FMxyc5CSvPDLQpVByPRelGVfS5H15350fN
	dlmcr2Po+AbIvjqtUyksWIv8LOYQRPYUPeyAuN4M5kufbSy6oJC7M2tYyMDZkyEr9p0YglY51Zz
	BlAJ6bb0+TLjASrt22IUr3bfDNjhyM1PpMuCnH5w8hhAHXMxz+/lw9rcaGvfbKJuzvbyQtp7yon
	dpf/tAdixjR0GaRCWvEjpMXxj5Y5NZACa6EbBnb39yhSNG+Z69F7OyfIMZo108Wpu3fpHAgt8K1
	7zfgAehD2U2GnvEgVGcXKBXLbhWD+eEZ3jvM57oLR33sfLZhIoqJ90Rj9Z+i/EdqE3ff8S4gf6J
	qphzS4GUAKDhQ=
X-Received: by 2002:a05:600c:3b01:b0:492:4911:8a with SMTP id 5b1f17b1804b1-49249110250mr54012005e9.12.1781976039950;
        Sat, 20 Jun 2026 10:20:39 -0700 (PDT)
Received: from user ([104.28.162.145])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49249238bfbsm83974275e9.5.2026.06.20.10.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 10:20:39 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/reclaim: fix potential memory leak
Date: Sat, 20 Jun 2026 20:20:37 +0300
Message-ID: <20260620172037.13894-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260620170935.89236-1-sj@kernel.org>
References: <20260620170935.89236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7910D40002
X-Rspam-User: 
X-Stat-Signature: pfs3j5dw3r68mhnu3ktjsz143xdm9pmn
X-HE-Tag: 1781976041-332829
X-HE-Meta: U2FsdGVkX1/IjM95DwUR8rMP+P/6Me2TT0p744uKTjbGGrSf6aAefPdFyFj/X1oSCUqbmmgtBOUOs67ce+e5fMJHR/9hM0BXYMrGTfoRMVJJxZTJtoQeu66YqT+kUEkwb7ji82XTX4H0uDClVOkpFCrpAvmo78fJss3KaI/ewEpvCVqoszSBGUWO6jFAhXV/HeKy2MNpMjg3PakuAVp6sYhOKkOg2bUYvlbL/oUaW9QlRMIMi0f0SFK/KoERRuymwlzTBGQ0qlvzP6p+UNHZc7KI9dGeer6f4kNb6X5tFHZKjll53/B0hYvSlJE2fOGCwprxm0Lyed//y35s5n5KHpEXKuIOhHRM3iDKJK39tVvwLnQhISEbwWp6zCMIePG9sG2lZiMUUA21WifmqNS1Rlzxc6jWPiKgAbskE4RPfHCmP//n4/4vVbhhm+YGDyyxSREpjMe+tYZ7lelttHk2Hh/qTj+Zayqo132xVsoNQxIk4jDXKtG/vC8/bEBeEjFLc9PBeUoJtYsJGLilwfIN0nf37PuU6+OjbO/ZQ+l/RtKkWQ6l2g52+gznpRnyYfcjVHdL2IUIy67lQWIn4HBdhODaG6XP3aV8MQ2Hbp2b9iXSttIHTL/dDomqoXnwVWQml5reC6K2RgUzz62mKyMMr/IXIUlesnQ/upQYQ0K928FsuMuf3LiyWo8Ym/MnksgehZ5ViIGBnzwBsJ3W68AJCVdLWP7T0Ytw+dKwFkE/8LU9X/bKhqKcCCSaIXf66OYlZ9UrtIva/SRESPwK5hm1GtG24umEaxIqx6Mv6Y0sM/cd1n3Tk5KYm2SqCx29r4pTJ8xbwJkNVU1Y6R8p0cp/vg8cuQtKV/nvG5YV9MYW9Q07gB2+cWtgj/mvzos4exSnFPmQj4IMVp/hiqd4OONqPmpAISx5Uzlu76/JbLFvSK12l4XZ990psOrDtuEewa/75HSoFzqcpPuO+jblcpW
 eLNdz6ui
 YvCeYdr2oN74DDYOMx+YqnMHllkFtjIWCLrWQdC3IfkG9Lbdd+JceBSqwlYdZFI/5wqB6+VjKQJff849mQcZdYy9QjERHdRPzWEqYfbbh7dRQ22UF/ofSqygZ0Wkag42Vl7Fh6Vf/iArOqFUPgKLYqaIcMHcTxRnZg3K2dztCsw5diYL8yehubNAlVO/z6KiPzllEQjzASCujFuZD+Nc7JQQhJEMBd+qJPIs+Vdnx4NsKWjPzq3gd2QLrc4/Xp885E2HyvVGVrpblscdXKpmojiHPmoq8q0AnkjPeD8lCoVZu+mpEthtrOBZ8oYpIqJB9a19BJR4cIkf9CzdMzAi3cO5wVi1gy6rzMVqQwrQ3+q5EDr9WHe8qzVKGWg+Z8N7maxZSBALQTxbS42QTO9aXWl+uSg8brkgTK7rbWiSoy/PwOYmuKzYia64/TnDc3hgJR1JflSQEzyEGunw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for your clarification
on the design intentions.

Best regards,
Yahia

