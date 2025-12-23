Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9318CE6B27F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 06:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82346B0005; Tue, 23 Dec 2025 01:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B052D6B0089; Tue, 23 Dec 2025 01:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E73E6B008A; Tue, 23 Dec 2025 01:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4656B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:34:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D7D9603F2
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:34:08 +0000 (UTC)
X-FDA: 84249770976.28.459F332
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23868180010
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:34:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HlY/eezt";
	spf=pass (imf24.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766471646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
	b=hT01ET/KyB80CXV8tm/BG9IkKgWrkR+qDpISpa2gkpDJDmUaOBiKPvrQjGtpgBY2x/1nN3
	MIl31ThpunGel4OcxJzcIrHUELNV9mb84gsCTkte9XkoKdV7GzoWlq++fRPuZ8MrFa1dmi
	iBujxMtG1qXaqGNfiMyvNLg9xoBwZJI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="HlY/eezt";
	spf=pass (imf24.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766471646; a=rsa-sha256;
	cv=none;
	b=a5zx2QNqHCjfuI2iPkm80DUxWTrLBI+Po79bMR2mLn1YqMbb9En4ZIErROeKZmbaDLgXCp
	ZhgNUs0Qf6AeCQeDttTR6zOB5k2JceHuQCuQIDA6/uGghMisRddlDjQIHcXHhOfX8DoFLk
	A0XEDPK7hiEOjObDd2c4XchIBefoHKw=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so39229351fa.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766471644; x=1767076444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=HlY/eeztahquNKs70ZAaVlZ6R++pORR7rnF2WwVe8z6SiqIeSCdTweGtJUUhGVfK3r
         py5MGWykBr4qg7w2oYXdgAfAhPcX1bLiIzaT5Vepv8yCOYIACLyns2rJEFpAaXzUKeto
         pTX0Wd9bcQ5bdZa5lgLQAJ+lha3X0cig0ENnrXjDBh6gl7fpF4CJ7GJAwl1zBhbMoV//
         +QeiZxJ2FGG0HbDoG7hqRe++C04i+AW7FotKJiCbaawSHh0ojEmRfSH0vCFk6brnFyZl
         dvD/s2mYJOPRayWmvttIzhLgU94iwavcNz3Ef+zmAfq0PkxiGzVUA6T82F4uY1jcDiHh
         MGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766471644; x=1767076444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=048jzD37H8lsx/zZlGI/PEx4g5lnBiNM8RokzD3mdsY=;
        b=jl5Ozi7V/ypEW1bg2AOydjPTGeWb9eD7f3xFHqm9WzFd5TZKF3T5wmRNh88nKiB2OI
         FIGpdxtj/EQxQMm2EGZle55uLmd8noMf8/zwsUXSFHPNrWpi/B+s8ZZ3hXSC2iM4Sd0c
         lk2YHu8fEojOQAehd7tX/VXsaIV9L9IdFdLE5ud7sUl1d+ODW3dEjXWBETVEokKA717S
         hHkg9PsUvSx1Ee5J6bw1B5yOdl4f9DGA4Ds/iWnfpqXM5OBfHqGWi6muuQB8rGP77T5H
         y5qPyFRppMXAQB1Y8ZUJkb2cxPNL6uwBm72NxH7jcDlWZWs53KsOccE6TFjfje9vhszt
         v6KA==
X-Forwarded-Encrypted: i=1; AJvYcCWbZ78PPOuFuSODghkFKARpPhGqilOnn+xpUoaq6VtSwgzJSPalleC0u1jqJIgyAv7+xkSCYrtfEg==@kvack.org
X-Gm-Message-State: AOJu0YxqeEzUR4qwhpelsr5jVsnTm5UZrxATwltd1Zwr8nsvNxgvMTZI
	tkt+01h6RBmSMVnlbzxl01TIwNm8SydXI9N+X9IGnmqz+fY1IUzmz02t
X-Gm-Gg: AY/fxX6HF4hy3Y8kVznEDAGCgZn2U+maB+6SidF2suElSjnhHtudxucHFKst7ph5c0o
	P/Fvqu70idvhvoGDWHN14FODrJ+J//q+SADNXiIw6tx1FGfaFqg2Yavx6zINCtxpLCxylJsoQJs
	T+Le/SKAS0Yg++lWFVMywKECxmRQdxhOwBMLsJ1sGuOvtQdHXxz186sWzDVZrUjZl9BrS92zAxw
	1vwCARcwt77RpozoWrBBo3MZIt8qyE3C6+rhMZ1ojAFa1ejyDCKLZMxNlyIjzfBsKXe7vfTnmjT
	PRK7eWSfmB8f+aPgon1PcG5XDjiKvjvfsekbt/liFvyubE3/VJ9uIBVTj+KLG8d0Scb+BphzjLR
	cNYPt7SwyXmx89OplUS0+oYdKsZ620tlKrG27WeFXOBfCluQxRSMnLoug1R0ReTmNig1qeJngE6
	ouhjWHnOadnujaLwWJQ0c=
X-Google-Smtp-Source: AGHT+IFaFE0nlDnowk+Ou3U+M9eX56ZCvZ4aEX/mIAF0sQ5oS0z9Fh1vnyWDY8DQIpJC2t19J66zfQ==
X-Received: by 2002:a05:651c:1506:b0:378:e055:3150 with SMTP id 38308e7fff4ca-38121566b66mr43783861fa.5.1766471643890;
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-381224de6eesm33742031fa.6.2025.12.22.22.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 22:34:03 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	safinaskar@gmail.com
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 09:33:55 +0300
Message-ID: <20251223063355.2740782-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: c5pxmomsgddp89r4j4134u4yd7gebhay
X-Rspam-User: 
X-Rspamd-Queue-Id: 23868180010
X-HE-Tag: 1766471645-284890
X-HE-Meta: U2FsdGVkX1+jVNkERPPJwJlzCyLiR/XOmJ9OEPZkkL+B7hYvcGhNH+NKIl+b0q+Frh6/rO19BfbGs3NR2hFcFkOjx2bh7z4HCgsNqd29YrGfaSAFv4xUnsqQoAQtJZ5RehU6ntlKtj93QyO60rTWXYg0bgT8kFjEDz6z8lieqr/Jcjhzujhym77gtM/IeX59D8nb1+BOL29p6r0U/3yDUMOzVl1A1wWvklxJQC7Rzmb9Ed5DB6/RLLlEQ560mnt2CVCcBHFMMIHzTocuvrHtPsQOrZuaQClhviP/sNo/mjYct8K8pzyf+dMlX5ZdXLxUvdAMx1lAvGqASG3RwyWeHKkSyc/DCyDDFEw3/pw2OnqajietUSUC/KH7K+TBee+7vh7ci0Mg8Tdh3AQBYxJcuzFy0I50goRQkLZeA/t0QoRQEXrxWDqcQiMBwVPG9zx42JR4iqVLOUCnsM0RGhgD09H0aFb0Cvqqhn5RHGURuLYLQ6xVkCGcaPTMAhuLDV3s+s4qeL8P1wErlFCxPxdF+PcT/qIbaT7mZW35BJMa6Hida7ARZm3N6dUAI3Z7Ap0X46mgtTPCrcfxIPfbGlkWwt5rsoYpAzW4CeQvm0nU+769ZAEAT2OyoeBX04pra9wYFvaTbhMNqoIYXfIFQ98X1dDv6MlWuC0K07+TtpQRmGI5bkx4RLGPipYa/CWqQVFziPa2aNVDlustE3FXL1hDnaZQnmzcmvfa0LyjngRKk9JyD4QqCv2POLKu4hXkNqoG4KfEGGU3tP73rQbF61+a+aQSiCgR+phD9cqAkWThbYzcAtSYpG0fW7BOBhFjafTDCl2KtxhwAYkEmT3UYkciscrB5dz9XrCSeQVVLjtGpPteOCFFEB9/1O8TkuHJ+BnQOnSBzkZvUV2kboXcsDLzJPkFkQDbe1xn1tlRVWfn+qJJ7HQu14gKaH8g2+laFMeMLBv+wftB3XDlxQqh2S9
 +Kc6PkeM
 ty4uY57KMMlhnlYWdMAG6CLrd09ohf4seJLKm5cAHpcgf/5PiGhNwzylzhgEL89/kbfLYOGuPxXrI7KOLYfWPgfgZ8OGvpuu8Tt4q4IN1CBcU2rs6ZD6jaG7BPEegzHJShaFMeNrx/NgjW8ABDZ6WgiixyjiCiQbt37nopa4x+C2GjAaiWDtdgus7NJnInsNGIHZy+JDkW9saM/yR5U+bESl+EOKo37kHIWw/tqyk0JMZxF+krguqCtoc+FcNTgCyXfT06xm4UPPOW5Neq3jMOvFSzBAd72F6IgbdOwu56j/Bwstw0leOzyAEFxh1LxuMFcSvEt3q+Y/g7YqJ8We/tWxRiyHeYXzhOyH1lli7+knlb1PFDQem+4WiI7ZWdAuvhhBk56e97fnSoBXg2sL7N2nCjqusMQ7mdPodmMnANld+jXzULyDbQcZvP8n8juBBRQWvA4yu1UT3txJmAOBSW+oqb7sV3M6W/LgA69grze5awhRzKCKviymMr7lKDhK8GfZasuPy0ltjgHDW84GrwtC5++/JGW5OPsJ8cV9gIsKnS2bcOv4QPapF09OAYv4njJ0S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Okay, I just read some more code and docs.

dm-integrity fortunately uses bufio for checksums only.

And bufio allocates memory without __GFP_IO (thus allocation should not
lead to recursion). And bufio claims that "dm-bufio is resistant to allocation failures":
https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/md/dm-bufio.c#L1603 .

This still seems to be fragile.

So I will change mode to 'D' and hope for the best. :)

-- 
Askar Safin

