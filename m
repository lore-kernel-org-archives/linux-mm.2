Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 171F9D2F359
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C446B0005; Tue, 13 Jan 2026 13:33:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA5D6B0089; Tue, 13 Jan 2026 13:33:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9746B008A; Tue, 13 Jan 2026 13:33:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E20E6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:33:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8BA83139FF8
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:33:58 +0000 (UTC)
X-FDA: 84327789756.30.5D41157
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B5C21C0002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:33:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6UzhigH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768329236; a=rsa-sha256;
	cv=none;
	b=ReOmMRJIiiPb5J8csRaQRZ7ldm6fcz368cwoQKY74lwGVSI7/CzL7Khr/sunU5BeCuw0J5
	Dm5aJ6Y0fKgLhjaq/hVS+dCvLOiB4jY2hOqtW6wx5Uc5NVbz4oMSgiQ0yFxIVzwAC7M+Xk
	rday8nka9yWhPyvfW6pBoW0A9Of9fKs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6UzhigH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768329236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vD1n4fofwsxFZx8Y9vmmRRviFzIkQGtDaZlhVkXmiq0=;
	b=en45+ublcucH5u/cfc1mzZjAIcGEAjAWIL1B77RYcWq471rkj9p5S7Dfbmg5lKKLtdwy6e
	a4k6UwY/hRnv/oc2cdbB0Ivw+Vd53bHVv0BgxEwGRZ6WH8KvXAgSjbQCLmWSZ6XyxNxZ9r
	rUs7h6hgoLEhYRQZOroeZj6kCNELUUk=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso84993115e9.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768329235; x=1768934035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vD1n4fofwsxFZx8Y9vmmRRviFzIkQGtDaZlhVkXmiq0=;
        b=K6UzhigHr2UMgq6Qt9xOmw2RHqsNnKekFPMzu2v4iCh9AZlHNWSIpAVZ9ZCHSAoyhL
         PwrmNgGHmY5FOKjedy+MJV9t7ZOy0m2leM1CrpFDrzsdlUCW5GNRqHlZj2L86ABPBi6y
         HMlg4mZTC42+Ys0FgB9NkkxCptouHU4MgV62+GvJNwNbhI/Rn8I0FDRBkbWARznwt7sq
         Mb4jrdaGGJ+aoyUqZ1OHTL3OWDqlkC7xg+3xDT5o1piS2+X19fkYEUxsHwrCw2iiTYdi
         lHKyuccFK9PE77V0YSpXYEa4/Gvm4tfMWkio88JWAa+oEfufkhYYDfOXqKzTTC3Kb57p
         jLEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768329235; x=1768934035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vD1n4fofwsxFZx8Y9vmmRRviFzIkQGtDaZlhVkXmiq0=;
        b=qsTLK1J1Nag2MuGoW2DapszkIiv8PnPRqAyxYk4c7um2wJpGF1Q40LdMnflAeGNLEh
         gwoRhDKzYPQ0SuoHYm0ds6JWLYx/1GmBHSKxc/pkWDP1quuCUPPOz5lfk6lpBXBq/gNd
         NEM6qHcZ44RPBMTHKJP/4Rqxy/XLorvjeWeFRaPf8ZMAaGMtNKJ1l0Hn6gdS27FDecbg
         xiKnmmJ79GU55k25tEqx7XZ66q12vHTou+5Oci/nrU79j1FS/+90A3LZOk0XSLBql1iw
         rGxnKs6//33POdJZhqyXbdTzvb42jrPe7qQnYDGaK2c8Jtp1ryVa5w88NrSYRlt09Q3w
         PT7g==
X-Forwarded-Encrypted: i=1; AJvYcCXveHr4QapSNVnRvrDmQ3RmqSNSwOoerv+ZF522Hl9pp4lwvAf62qoWGF4+k3oTyNFoebMfENuryA==@kvack.org
X-Gm-Message-State: AOJu0YyqLtRuRbyI4pioTCVXDbsdMAJDOy2oXaVVjbMi/5rmYmZfvGoz
	Eigs5duTKE25A7qXYEQxFgWMRgjiSTtn6gJ1cBkPo4LR+wx2X/Q14FEK
X-Gm-Gg: AY/fxX5cvZXF9xQzzbv4wMYOJ+ANMRE6eMe18qjRITXQ4BBE7rxgDXvGgfaBUkctSX+
	d9RAA8/zaMWPxa5riR5HV2dSXZOuR58MqEGyVbleEQWOOhRhQE63lO1tM9airCnSNgGrm/IeFgY
	UAobd9tZfPnvN0RtWvuwrVX0c+6arJ8KucFXfMC46l1m9Txnsli7JxmZOeKG8V1g+RtjCkPk2IQ
	Y4ykDywDuEkgdDVvFtajPP5GplHrhycEY1x39Cqv44ZzUkzahZRbUFDfMKsY8ViXESPM9BMYURX
	7eVQl4h8InqyUNaXZs5soPPtxRlr7cENyXoi7tKacRqFCzEwZtWYZtSxURotx4ndkUv5BlY60Ka
	QRMQtPBrURJkAKqvV3NI5Ru2gtP9qIk8YHUKYp2OL9TSLjA5k6SQW/gUWC7kB8Blk4On0Cg6mTX
	jTe3HqjLm02X3YPrBgNErQMqHYDmdkQ0vfeVw1aSXHMWUfGACkI+7FP7HG35ew5jE=
X-Received: by 2002:a05:600c:6386:b0:47d:403e:90c9 with SMTP id 5b1f17b1804b1-47ee32fc6d8mr1578295e9.11.1768329234806;
        Tue, 13 Jan 2026 10:33:54 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f69e802sm426004125e9.8.2026.01.13.10.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 10:33:54 -0800 (PST)
Date: Tue, 13 Jan 2026 18:33:46 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro
 <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <20260113183346.18ef7c74@pumpkin>
In-Reply-To: <62097ec5-510e-4343-b111-3afee2c7b01e@sirena.org.uk>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-31-david.laight.linux@gmail.com>
	<62097ec5-510e-4343-b111-3afee2c7b01e@sirena.org.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: d5megifhrynmwc5ujarcdr7txnqxck9k
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B5C21C0002
X-HE-Tag: 1768329236-509090
X-HE-Meta: U2FsdGVkX18fC1/t6fyOLj1yxR1tAgwh2dQq51Nvc8HFpDefDGrcsrWeWqqVFoR9C1soU5WrMYAvzL10SATrQjE8dEtkDyyGJlHiSWrPaZZa0Sx1Z55Ho2kV4ZdNbsLxALiRDsRxMyGC/kitR5focSMw+S1Dy/lUHaHkinNyLSG/jgQa0D1OZAMso2AresbK2l/9IPETkgEAbDvMDZ6+YL14ZJEObSiVspu0bbFxNOSUWzb5cClSyBdoB5mMD8UsoTvp/i/aRBSVFjV3ms4GeS+X4WKKMA5/NDYeIE/wzaKcryugZKaMXdVr28496qKBIFm4i9v9ud/ntj7Q3Mow2AXM51t9tHB5yuaDCAxPSipwCHK4TEnrKI1A/vFjY7RTjKjOQ16JvW+6q/VO+Ze5TRgSpLygCwnm6Igi6cGBUqLtUnMc12VKtf50iPCQ0tGeXT0riMp4MpmQRnGgRUgPkki2G4kNw4VMDj0U6QyLmSE/Q2zEXH4Qqi7INunhfQRArY3AMJejAbS9FhnUUpPE+cm8ZP163IQznZhNsImuhVMVctIbKEN1rsvAbqTuCdg7vwvu/jBFkBckCi2Z78gyURCzml8mthCS9MDqgou14I+fkc6w+6K0rJGwgfnTsj+xskRiBw7MEXji6mVT3tdMsilvCR/C3Msd0s1Ldh+c+dnCKph93b+QVoGcXWUC2HYneNhe8b/qpHtrnxEv3OMU/0KhadjEji2Lv3qofdWxHkuq6v5SmH5RYTB4yuA2jls+0zWLkp2rHWn5HD7F0NXFK+c8OMmAvVPEEUh/M7GuoBWjBrhnjmu8NG62xL4a68EQjtISpQk6/k92d5RYUedUPDPmm+sn3DycRQOcciHhvNIH6xoqJY8wDNrdLYLm+MLXYAkiwiAUyuvBQxqEapdcs2to75PYAn8bgZlaYcNqqNG/FL0vVDrxQvsa+9PTSxaGeGHPl/KEj1umKFaHAqT
 RvWIP9ur
 xxH65jAp9SyhqBPo2zppRIA0FvbZ3jNXXuhMTABDBCf+TyJc6cYS66dKjt/usUxas0XbS1vKV6KX4Co4N3yFqM3EKGo81r7TjGSCUeoMxNqHv+7cM/tFf1JD4ZPzhuygrT12wO+9qPSWKvnxpgdC3nwE9KfvVYvdvzmoYCp2kP9+zQ/I4MDo3FniwpkuyYANEsMGx9hwMyBVZ0SJJO+3rFli+6CBDTPr/os1+bXrHwivx16HDeA05AdEhb/XndF+9IkTCBbXY6aWTvSrLgk2pPfd7AWCgYZZjHzYlRaW6reWmuI4iHES4rzAeD/CZBeTX1CPXbptoN5G03b812Tb9aNaJv7d4+dcgKsjHpnDpgAxcSz9ACAs5ufHenV2HOa1rraJQCtXjvCkvEhkGUvYslDMlbxJEyecSfmf3Pg5503P6fMF6QEWg4bNn93dIv2ljwtn4ZvNQ2LNcUIRIZdlCRsBqeu7vKlHUY1fAfWF0RULUgKXWZfahy7ZXlPfHppLqJLd4ouBynvPEPyI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Jan 2026 16:56:56 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned long'
> > and so cannot discard significant bits.  
> 
> This breaks an arm imx_v6_v7_defconfig build:

I hadn't tested 32bit when I sent the patch.
It was noticed ages ago and I thought there was a patch (to fuse/file.c) that
changed the code to avoid the 64bit signed maths on 32bit.

	David

> 
> In file included from <command-line>:
> In function 'fuse_wr_pages',
>     inlined from 'fuse_perform_write' at /home/broonie/git/bisect/fs/fuse/file.c:1347:27:
> /home/broonie/git/bisect/include/linux/compiler_types.h:630:45: error: call to '__compiletime_assert_434' declared with attribute error: min(((pos + len - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error
>   630 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |                                             ^
> /home/broonie/git/bisect/include/linux/compiler_types.h:611:25: note: in definition of macro '__compiletime_assert'
>   611 |                         prefix ## suffix();                             \
>       |                         ^~~~~~
> /home/broonie/git/bisect/include/linux/compiler_types.h:630:9: note: in expansion of macro '_compiletime_assert'
>   630 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>       |         ^~~~~~~~~~~~~~~~~~~
> /home/broonie/git/bisect/include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> /home/broonie/git/bisect/include/linux/minmax.h:93:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    93 |         BUILD_BUG_ON_MSG(!__types_ok(ux, uy),           \
>       |         ^~~~~~~~~~~~~~~~
> /home/broonie/git/bisect/include/linux/minmax.h:98:9: note: in expansion of macro '__careful_cmp_once'
>    98 |         __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
>       |         ^~~~~~~~~~~~~~~~~~
> /home/broonie/git/bisect/include/linux/minmax.h:105:25: note: in expansion of macro '__careful_cmp'
>   105 | #define min(x, y)       __careful_cmp(min, x, y)
>       |                         ^~~~~~~~~~~~~
> /home/broonie/git/bisect/fs/fuse/file.c:1326:16: note: in expansion of macro 'min'
>  1326 |         return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE_SHIFT) + 1,
>       |                ^~~


