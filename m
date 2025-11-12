Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791E5CD484C
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 21:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2D18E0008; Wed, 12 Nov 2025 16:57:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A8C8E0006; Wed, 12 Nov 2025 16:57:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0638E0008; Wed, 12 Nov 2025 16:57:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28DF58E0006
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 16:57:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB2C812DA2B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:57:03 +0000 (UTC)
X-FDA: 84103315926.26.D2F2AF5
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id AB4F5180018
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:57:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=Ngp85mQS;
	spf=pass (imf24.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762984621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtzYm6CaQwwng4XDexAXOIVM2T8jYsSpOQI11uV7cIk=;
	b=ug2YM3kbfnpTNadLuVgNQXg5RY96qllHoLFlKf1FIthM6csWqgNtSH8kkaE0+2DFiMwn6z
	2BgqYsQILDAaBL3onkBlMNjEHvzxWh7Zr14hyGm+KmvnNWSOFGyamBspXmhjvb8slDyBjG
	0PzEA6+Up1gDQn7injkmKk4iuSXONOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762984621; a=rsa-sha256;
	cv=none;
	b=ULOBcNSorMtG5S5RDnNEb9xhdvtfcxlFsx7nzt3Zr6+ZoMiiPm6d6WoGdx5xFHOkrZYijx
	6iFvAZNjeCqOviKS5IvYuCfxNpvN1NEg8XP/+SV74XXawt8e+yt1s5i/La4ij5kl30PAWd
	AW3x+eZnRiW19Mahwo1DkXSxf8Old6E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=Ngp85mQS;
	spf=pass (imf24.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bc169af247eso98130a12.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1762984620; x=1763589420; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UtzYm6CaQwwng4XDexAXOIVM2T8jYsSpOQI11uV7cIk=;
        b=Ngp85mQS+iw36+ErvgSC7Ryj4U2McsfYGOy7XJGHNvPdF424Q8DtKUgdGXpXo9WZPz
         PyJp9v/bXdmEgerE50eR53wL/ILBol197ewbpiNmUlZVoULG5p85bdP7nQKr7mjzXmIp
         o2XnmwtnSQD+wWalQyCjh+9Ir90gTJHvVTzhzmGPJt/9+kRC8RL99i6tefc8UoZmQQou
         19Jh3bebALZoLUlJEGF27/LBejUArjVZAxSHL+BUJWVIXIVQmMbmMDNg3tXhZYgbCAuX
         jNgv26IEaCCs7nSVOMSVfC5vfKuZlBBR6B7F/sZ6b2Dux+bJOJBR8EHYRdWD5FHABKyF
         bwCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762984620; x=1763589420;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UtzYm6CaQwwng4XDexAXOIVM2T8jYsSpOQI11uV7cIk=;
        b=AFs0TecoGd73J1y+fZ5C2D1YPKsShcMeiG27tS3UO3UAr6JEgxIfCqpbwr2JT4TtLq
         p8PomRzIS/PMfNg1/oD5GkyRWqcM0HDGw+eMif5KyVphSgC5FTZMpIwoOawVZL3nfXBa
         X7sU7uPM51ucZTzuOU4FqqJUgTe0eRWc2lhEFj0zm5GVoAnDGa3sPdcCr0a5BR0M4rQu
         uNvdYxf6FQBieryxEUHf08ZK16gBiXcUl4J/PJTsZNh+4ChGka0JLnn9mSwyIeCd+xGj
         0YQ2HXmHXBaDHS7R2Rckw2t/8MwUGzJTxeahGV5PfdP1Ez38ok4AXozQ3Sy+yRCMKgH6
         xtnw==
X-Forwarded-Encrypted: i=1; AJvYcCVFjk/hc6hYJ6jfFhPvkPoUKZpgM2FlHlEIResbv+BT6rdYmcJruNgVXxqUHoTq1ir7tJ81F3BAvw==@kvack.org
X-Gm-Message-State: AOJu0YxbC34MaAMYztyTdPOTMsxgufXXoHxi9GssnnEhN6cJsMMxMQ7W
	KtOUE29i1hXTnsByXXMBr4MeZsBDT4VerIYkYQUN45wGqioJYQrsy9WTSkBKKd2CHvA=
X-Gm-Gg: ASbGnctQAe8SflKnPlzIEHzroBK+xqkIwPiKiOKbMWYNU+TuB36AkMk3JKALonBCTpE
	UH7s+Qp1yH7oqjwFiS+HsD71I4v5RK6fsDLvIZLLHL8MUEuDIlHaJalSlP1ORQvnqKzh14vB1FU
	Ve0EMcEHYqOHG+1lI6nPjl1QTgma1VTEaQxAprjI2SM7ZGn3WZZIoAoYEWHb4ShWAfSWeULOzOM
	oh87GGY6M1q+hnoPyF5rDgDPOnoZHtjFxhSM1oarmb3WDQbaEKJwF39TmG+w1ZTZSq8+WMejooa
	B1HxtEpLPzisGVX8jGmWbT121sbrx7VbGl+bXcisr0i7a8ZO1c6I/nDVn7Uqww9AdY5KqB63amP
	P20GaJ4+8xosNhhDOive4DYhuohvViILaGVwRKpp/SFNnVHJcCKeH6rij20Yv2bq5NLRsMMsvH+
	WPbhoq1gEFVIswi87Rccmz4ZZxH+aDmvTKWTX8tbfGfyZ/iU0heN4=
X-Google-Smtp-Source: AGHT+IGGcSgtma54hv+7RKzmUmjycRVqw/LnJDNDCrdXo50noFmBCjb2IbQqtC0Ft6zra7BT9FpOHw==
X-Received: by 2002:a17:902:d4c3:b0:28e:756c:707e with SMTP id d9443c01a7336-2984eda94d4mr56523225ad.33.1762984620190;
        Wed, 12 Nov 2025 13:57:00 -0800 (PST)
Received: from dread.disaster.area (pa49-181-58-136.pa.nsw.optusnet.com.au. [49.181.58.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccd1fsm1507945ad.110.2025.11.12.13.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 13:56:59 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vJIpk-00000009zCe-0KVQ;
	Thu, 13 Nov 2025 08:56:56 +1100
Date: Thu, 13 Nov 2025 08:56:56 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
	willy@infradead.org, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <aRUCqA_UpRftbgce@dread.disaster.area>
References: <cover.1762945505.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AB4F5180018
X-Stat-Signature: h47m1ox36objm4sknugmtx3qwya4sdc5
X-HE-Tag: 1762984621-540325
X-HE-Meta: U2FsdGVkX1+ZLcrHBr1qV9UgYj1O64DPCC19D3qofMKIle9lP4jpdz+30PBhDeeCYBwqORiuAYWawMGb45+CPBWC4+UFPdI6UP9qtZl0rJWzojyhQ6kKTiDkdqTHZaV5GqxIv5CfNXte48B2ajcDVBShCYEfWYS5d7IrdVtDp96X8yYiAq4edvXTSj5Pbm1iguFn2zPpuB9l+WifvukGtmg9BNsgUOAwJ4bedBFXrJeNtoj/BmMlORNp3yY1UF1Y+pIsMMRxzNFnLn0GIOZSq7zzwOfG5dvoiBzuPxt61bq4XOtsd45TS4sWT/N6woGpsMfvs+0C8tdQa+xoHMoVsdmBV8OXVTaFm4bmxAA8gY7Ng86pWMH8/FQ91z4Mi8cW2zwtejIAos3Jd2MWVnPAVMdrtIPS+3hwumv0CvxaecSyJoW18DLQU0tKrslWgue1l5ZCiyn60ECrA26kJoQoxnEQ3110lm3a3ag4LZsJ1P4t3tIuTKm3CVsa9ZE0tftbmRi40aOpaOD/xBYdxr1UtnRqZxDLiidP7GnSb6E+VAPDMro9mRnzn3PUN3Hz0PhtqJoQbzw1H4L2anEUq1g+QkKCDyr9vTqgvPhxB2bIroOz9IQ5yN5nRO43iAb7MZDKQyET7u1KqLwwYtX5tYFSYnKykFdtZpV12DjEHrCbY3yCYTRhFU5+YB5kX0rIzSEnFXGfsMEVQpSPVswx5eh21NSusFLBsrDfhPyPllGLWJ1Rg4SkLfn9Xg93I+SxEscsCgQ3FLekaLHjscYeRpdad0b2AwNjIop6fgrIPEbApRUqNsOcTfKjyEq2qXdlC3jjcdTnQdsMi293JWbvSaGkvL+bBbrdELtkLH22Rk7Kctsc9UHX1jhaZpl15Ed9Lcknr7Th3wJZ96UdAgQEO9em/KMct4Xn7CThpML2aUZZMtFJpVzLiKBy+vB0vcyeNKNwKUzdSwjBPehZVsvWmiz
 +3xri4Gx
 f4gnqDzUwUJd51s+ShPJYvy83GbZgMlESYXBg8+CNClACPfpvPq8IpzOsDqxjUUX50JYF82GWQF+PAJ25bLmRjBAlFOhjuylA2lqYNDxz2W85ZHpkZCPygUiQeuZcNKAGe4l9hO05nMwhrOf65tk697hZnNHX/CaRR//jflk0ITWSM3VWH7ZVEQlePa1LXWsQQc9zRX4dtzL6yxFA4Tl5mYaQprQIotByaeg3qgC1r1AgE+gXNtPUkPbl6H/H//NOWoYzoIVgcO89ObPpOGno4A2TfkxUDjXCstSeMqIcfbz3Vje0paptCOmnZo4IcGlawhvJbkDlNSRB0btQR5nzcDfmJ5nJCcVkcl2AaUZXVuWkNJa+wS2VtpYWZ9nYTtbqKSUsQDKxOBp7roy5fwtxTkQDp3R6hkrxD3PdoHQg12ZBavkM2y/atC5X30yooiMcA4bp7gJMwJFqkg0u3Y7qhM6BZEdPFmE9xG/kwOsxGKg/KT9cYnkn2USix7ZSwX+sXMa53sGjoqMheL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> This patch adds support to perform single block RWF_ATOMIC writes for
> iomap xfs buffered IO. This builds upon the inital RFC shared by John
> Garry last year [1]. Most of the details are present in the respective 
> commit messages but I'd mention some of the design points below:

What is the use case for this functionality? i.e. what is the
reason for adding all this complexity?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

