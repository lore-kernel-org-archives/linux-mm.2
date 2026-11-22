Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AFB3606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T9FXVPmj
Received: by kanga.kvack.org (Postfix)
	id B6E546B00EF; Sun, 22 Nov 2026 08:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1F466B05B0; Sun, 22 Nov 2026 08:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35F06B05B2; Sun, 22 Nov 2026 08:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 866446B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:17:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08E811406E6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:17:21 +0000 (UTC)
X-FDA: 85462806282.09.1F4DED9
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FEC9100003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:17:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T9FXVPmj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795353439;
	b=HsoOR61/NXFhAP7HPLxilDT1hGWCjXATBpIB0iSiUtemk3KddcfJkSxuAGTTquQmpdGKg/
	gjpW5pCy1xDEAjgz2WpY5v+BI4wOo17Z85lneTsdtiL5WjMdWu9viETu0MnGR4helruUGx
	1I1NpB0ImOUpALU02kJYAXFu1n+8gvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795353439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCrN21sAIS5vBdasJPF7/+7hDBAoVVfaCO+8Vn3uACs=;
	b=Bf1UvlhrdCXRUVnKtnW+5QAr9BScljZAgzLsX6szQpnNmzRFyQfG8bVWij0o0X2+KylYEM
	u+ni2V92Q75nwQc7fbMaaCE0Cz560KfgnGaS9liDqFmffZ+MSci4eFSVVx2MO/8OIlDUD6
	gRp+kgDh7slIvcy+TPJ0TjxFHs3uKNM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T9FXVPmj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-382f4710a17so4159801eec.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795353438; x=1795958238; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PCrN21sAIS5vBdasJPF7/+7hDBAoVVfaCO+8Vn3uACs=;
        b=T9FXVPmjnAcB1OBsP017k2S7ZKJG0PDBfnMIlaY57HylyK4y5+4BQiH1bILHsG14fQ
         bsSUC+7yMNJyVJH76dliuNtClcva2YrEkYvuBo1CzlLnWjbUIVImELHtS3PvQsXEKbTE
         s5Ui4xNdj2KD5+xtkWHSWKyvrTndSrQ7cwm5V2pJaN1+N4Oe63ERvuEF+hRNhZwjgn+f
         YW+3msjMi4G29oPjDIJdj+I2rJ/eaaAWd2AxHCEJkuEL1gNzbiEP30XaNX3SEamNiCJv
         oUXXUAVZQfpBX2Tf4DfX8JgFi/Zu5mwyZMFNzw854aZE3vIFg2QNh6JDWqqwwt4RRIDF
         1pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795353438; x=1795958238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PCrN21sAIS5vBdasJPF7/+7hDBAoVVfaCO+8Vn3uACs=;
        b=vVpAyMlhvvBmhNUrnOq8YPsEFvxs0uWhUnUbtPZzUFAEGSO6BCSvRZvxOqsbVEMj2U
         Nof9jp62l0u9qXVIguS+UMlxSuWBnxTaU4Je/a67YdLRk/turdK7xsS138+B6wNNpXxc
         withFJO9tXkRvdvWS9KyMMYPYuJNR1hhTLIncTIPd/UV2sJmp1nm0eerFUy2DvoLbSae
         huqO1ICeL1+ZOP6egKcVEg9O/fDMkU3ZhtR41gmPFBCVKFB5sZe0YFpqifSEMA6g/usP
         Eb6V8PwXNqB2M7jL/auBW4tB3W1NS8YsQW2pgb2eAm5h5lsc6ooqEQP55nhA2QRZxPMt
         5EWA==
X-Forwarded-Encrypted: i=1; AL+hErE9Hh/lTmnwRoPE9n63YCEty1p3MseT+jj41uMqs1wAXxu/mVmc0kdk17qLmjQG0XGnsXfQQ93GUQ==@kvack.org
X-Gm-Message-State: APuU4Z9sz2XHu19c7IRtDZ0AsA7oiCDbNNW5b2vTwRSATGEgYXYAVnoS
	AoyqnEzB5J/XA2UR9OZYP0JI7FCzoN42SMieVWSnc/hrke0jlb2DkW31HJyZqIMrPUc=
X-Gm-Gg: AZFdTZfbNNpomnpWIJjjm2V+lECJzE00lottzj36LFb0QijEKumRWqJusDahC+QrPzg
	MWKMkyFT+1J+UF926K5M/VseBt/z8WSai7iBZ761btycBxyPIJYKHQpvaBgAWAfK5RrIxylbopK
	+Y/F0RZAc4VP7YP+lRDt96VpnSGplfG2TxNe00QFhAeqvVIdIQNKFLvbe6S9/e69aYDAZ7HXhL4
	VNLY7//oACyYdQ1c/LxziWRn0oyupnV1XMl45wpa6sNVCoboC5waZN3v/wqf9mF0QpiUBuiMPt2
	NINef1LJGneeGwW1GW/PMBq6SDsytYfxPkWL636L58mzmvLh9/r8jVwhK6ZotcRr92kACxcPq4/
	0ZlK/l7pVAlmsc+1lQRsx0WVyIiG1P7hQskUXjgmSMoQ4w9KDIe8OQosgmucP65pSDrWJSUhTOe
	cSjN4Hin6hQwueKwg6/4b+U86LNyxAhcLoH46tJ27WKwK3cIXbYEupk7FL7bUvqthC57joGMnl3
	4n01AgpVe/oJ6WYalyOWckPllf91zTZaMfChuB4Z4Kk1qO5bxsDgverVpyQny3APfGFk0r1pBfd
	ugfLF9fbHFgl+Bbyg107yGptyA0YpKFjn7PnB+Hu2lj5TS+binkjp4o/5U745iJ7UDTQ
X-Received: by 2002:a05:693c:414b:10b0:386:9e32:a65b with SMTP id 5a478bee46e88-3869e32aac6mr4989257eec.1.1795353437815;
        Sun, 22 Nov 2026 05:17:17 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38577214c2dsm25663585eec.17.2026.11.22.05.17.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:17:17 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Date: Sun, 22 Nov 2026 21:16:23 +0800
Message-ID: <20261122131652.72647-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-14-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-14-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2FEC9100003
X-Stat-Signature: g9ktbhs33jucwrjedomay93nfwaopmf4
X-HE-Tag: 1795353439-800736
X-HE-Meta: U2FsdGVkX18Cec6v1H1CMzLCu0dkGdjmUl1mt5NOR7KNMSMRnJoqlSnYw8kVc8QGULUBrOeBd42g7oYppqjSdTNYZTYqJ3cycSMKh0yq5ll/uveCY/gi0w1vJny0z2lPVRj5I27nt6VmDdgEZkWOYarhtwpWDms7b9jb+z3gEhJoaIlpe4051OpMcEclDF4m1dTLW4hRdFIAuUKF2UXHVldDEN/Pj6eL7wl9BiCT5E0r5zK3AZOwXPPoSUJ2YY02Hn8ikn1jGG6+lmyyEsL/riWrmjRpah3mDKCmTcfa+Tu0+a6Jo1zdf+fTNfF3IlDVs7JGPJiKNLUA/pdtDY7PBx+t1ewvaz7SUkvrPTBl8mnJX/nJtxg6NytosJ9GHSh3nNvZOE61u3WPbl3DdbQXL0sFW1hM4qloMRQn79VbrOsCcVIVaozkEDZ2kpQ4julzZZVFsxtWsvUL5Dn+Pi2V8xqSsIXLIiAMC3ZneCgSffknIQNX4Y5YL1ThHmwkJBnhfAApX2VBs/IhUpFPhSOw7+2Z3OpuO0Yjvt+g+tP+eO9YFyXWqiXs3bR+1mEt6GYjH2uWf+5jKWIzEXVkByo7ZjbqA+/neeBl8RZFUbgnZP9PNQlHuongXmj3lVZuxuPBmua/KnMzJ/0UXHjrAESN+Lu7zguRVL1TEqJN3MokvR37KRhZ61jeXB8c48E4IaZAUkF142XUOhse295FJ6faR4NMPaX1X4+SJhttcwERFatL808Jy/mYDvSuAom7/WqkW1kknhNoaCi9oE5zYyeZPvSWEE8WM3ir/n0VWCXyej1ge3fHvkcGkYz4QN5yjR46Ci4Z80PDlVG+/P7a2zJ7lI8Jc3h8MHGTVYq727Hh9hE5eG3QNkUp4HQuEEW0S8iTUkBjlSjDDr0aqXpwyZA8mElRFOk03mUrkddrbiAT+aLwIii1fp63aw/jmIyKSS25YwDikX3azyAGiPhovAE
 slVDrN7H
 VbwQZtlg6QvqAEanyJmZPFAbEnLF7DY4Y3Rbig2LuyYBoJAjnqj0jhK4jARQXlzxD9hLYabdJ+LhtXArjTOBZ3swYZKSuwK80W2/dP3qizHbPCAeCvM2zvrA7Id65e+fUlhkKPDFr48qZV//551u7ITKZLm1DY9yldndaTN2NKcPNG9PPbwf8qbpwIeqkSKyMDngawadwb45LKdg0o/VW4EzY12nYbOs2swg58ySBlVW8VeCO4zICPPqgiqbmns2Y14irSlKZDTVx00K6pAR251ahf1FoE7REsDDQuj7IaWldC0P6gKFc4pOP/F0YcVg1TOe8XeHKfYYqTt0I5w/x7w49u4UHRy2Q04n3X8dXifl3Oxziyx7uZtRtMyb+c1ISbIp7x5Rq19WcNwS1+o9IpCA9WEO3MVhio8s+Wcmcwm26KlIZNUYzfUU4WIlYIbpaATMBG1JeOvuJG6h1854Tg8FDiHYI9zjYVmHRqRYXcG0eSeDfWFJ40BWpNRkT8+nJyJHdhDFAy4R3J37fXFuzJGY+4iPRhukvpZ4CCfiKMfX111hSUgEflJBPVkHY5VcH7PhfZldtp/V5V1ks9anpdchDoNIG6RV3a9hgvjeVtyvGH10wIxvOiXd+wiWp4N3+ehpDBUEjPraJMqU9YTm8BQSWlyXQ4DlDnGJp5AIqv7o25CGG2WBHFJfC6Zt5Ow5mJvx6jHTq0egaViTBb9gReZpNq2jHLED/iazOfFWmUGcP3Pk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:57 -0800 SJ Park <sj@kernel.org> wrote:

> +		if (time_before(report->jiffies, jiffies_old))
> +			break;

damon_submit_report() sets the timestamp before taking queue->lock.
If A is preempted after that assignment, B can enqueue a newer report
first, then A resumes and enqueues its older report.  Both submissions
succeed, but this early break can miss B when A is expired and B still
matches the requested time, type and address range.

Could we set the timestamp after successfully acquiring queue->lock,
so that timestamp order follows enqueue order?

Thanks,
Lian

