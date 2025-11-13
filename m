Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78D20CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77D58E0010; Thu, 13 Nov 2025 01:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C28DC8E0003; Thu, 13 Nov 2025 01:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B166A8E0010; Thu, 13 Nov 2025 01:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 999368E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:11:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D5151A07E0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:11:27 +0000 (UTC)
X-FDA: 84104561814.16.4CD1EA2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 62F9B12000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:11:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PxlU/FxD";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763014285; a=rsa-sha256;
	cv=none;
	b=aOTdLbUHBwoPIMQXQDReZEPBZ0L5tsTUOkT0nDSJ5pxOKxnUCuz/RA2FWKtIRma+Thylhz
	QlrnLXCAfHdBe69xfTLl9JaB7CYRetE0ILBu/TefX3aswJP9otDYOL0qBl6d9YwVrmbtbw
	x5zn0MeAMBKlNrzXoroK87DBCyolDKM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="PxlU/FxD";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763014285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2LqphD8tGRygLilDfD3DdZsx92tK0p16bJTr+js2PHc=;
	b=IvAYm+pTR2ncM9tVLd26UvbSy60xzRRwkh4Goc9caE1WIHdS21oSm6wqs3PjG2Ua8xKNMD
	f9xW0ruiBNgmQgTFW4gWQP8aISDPVVO3GyqVrLUMInshb4jWKEuWJlrdYNlxqwfR9jYSlz
	LoKVbfhs9XCP3JhpYEKGDbm6cbDhjBs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2953e415b27so4035055ad.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763014284; x=1763619084; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2LqphD8tGRygLilDfD3DdZsx92tK0p16bJTr+js2PHc=;
        b=PxlU/FxDNzDlGdoK9zE6k6awexycGu2pLCeqTg9X0Tex+s9gfYo1YCC3OqtFyClCDo
         4DkRHnEYubzwmAMs9gYN2pEe2fJdGcsbYKp/ZPLtsrHQwzUDXBDGQ4bJGs5oIoYa8rJO
         A/v329fYf4ywBtGs7vGkcED8KykDOk9EeoGgE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763014284; x=1763619084;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2LqphD8tGRygLilDfD3DdZsx92tK0p16bJTr+js2PHc=;
        b=Vd/MmDXE1qj461PzHnvj2pyep3vxewzcR7cXmOUm0QFdZz9rcPhZIBWQpxS4evhrP+
         qT0fmCIRh+5rhc5cSBqQ/hrdgD15D2dMvaBcfcZZce26SIaZ+/TxUXzqnG9qp/PXYBqO
         fUH3JxR1jCWfwsrymxKxTcHSH5nnSjC18RBMwb8hWk62P7x+ituvz/ic2OxePwlaDBha
         6qMarUxe5UOOYcmGRCCykpOogCkpNYcUM6Igobzcwb2rGXpXFUFFidfuZtKjVSZSBpgP
         PsCz1WjrmUJhIYVeAztHYDWAg4zW0DhAoNlPOtnoFMtwnRVlRzmVa9qsDhDD0+5Dd5au
         NwEw==
X-Forwarded-Encrypted: i=1; AJvYcCV160xAj/VFYeMszmH8SCs+ZzG3+CzCZKVyrsrvZgVIQXd+ddMNU2bx8Pr3qVZ8/OBXzJiPeZGcjA==@kvack.org
X-Gm-Message-State: AOJu0YxU6x8Qp3Qhbc3UJ/RlJEWKUsy6sCir9cqYl/Kr8bEa/wioVl8V
	CbVcG5ecH/MO1zhlXliaKm0I8OrddMvqKs84YAb5fxLaOSXjTI7C0Ca9OtHxL++JLQ==
X-Gm-Gg: ASbGnctvPfFaZyzRg4MHcF1Bbs/9XY+LkM4bzMdU/y64aqhR6K88/9/xHbuzCqfkbC8
	y5Gq/UTw8HE6aaeU6m6yJCP6y02jU+XEcvT/beTRLkvSHFVubmM168cAckd+Au8uxH7YQfQBA1m
	KUw2dd69+sqWVJ5i2/0H9X6wQn2aed0/nzKJb5Z2XdG+QJ3XlHovtLHcvoplUU9hvgkMMuubQ3e
	Qq3bSxD48zHWMrakzZQNG8G+yhlckFCrUDQtqAfopaIuBPB5Z1DySEjqI6oWxTSV68g9ojQL2tX
	oXftsb6C6Qlwz/ZvqogT62SBp8cN67T4bBnAJb2EItHxmF1/C+BI4rzq9YHlUdC0qb56FES0ApJ
	YjypJg6cZPNwBXoIOggbqMxlIkBd/fGv2m3pXud3hyRJJ/DH/3y08ZUIYSDnuPqEnJPl+mC+YAg
	t4SdHxE8D60UymmGE=
X-Google-Smtp-Source: AGHT+IE7hQS37m/XPXlVQ4Foh9+BFb/rN2BBQKZCymZyiayaTIgspcciVj3iEqly3oeCkfBztppdXA==
X-Received: by 2002:a17:902:da4b:b0:297:d6c0:90b3 with SMTP id d9443c01a7336-2984ed6c342mr74657745ad.23.1763014284214;
        Wed, 12 Nov 2025 22:11:24 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2bed23sm11944775ad.87.2025.11.12.22.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 22:11:23 -0800 (PST)
Date: Thu, 13 Nov 2025 15:11:19 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 2/2] zram: add writeback batch size device attr
Message-ID: <otnmm7behvnsbcqmknx45pgonsdvk4fma4o72qui3bjidwfc35@aurhln6nfyyz>
References: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
 <4b7b8f9c68f1a05ec6ada8aa7be9b735eae57446.1763013260.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b7b8f9c68f1a05ec6ada8aa7be9b735eae57446.1763013260.git.senozhatsky@chromium.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62F9B12000D
X-Stat-Signature: xun3ba8w645m88uh3i6actfuzp9dwnda
X-Rspam-User: 
X-HE-Tag: 1763014285-110055
X-HE-Meta: U2FsdGVkX18cBiVpYkpHEjz1ksf+colKbcpcOKjDvfu9whZKFojGjvrS5Ep+7nh7SsdgKgKBHxig9EFm1yfdCe9iYOyWTZqz2b8RlqxQUYa3g0fCM+UHkJ3BDTSy9RTzuCx/kMxbxQTboWPjXm8eNx4ir2DodkfVNhk5rN2+fybvxtTqDQhJWoGeNKr0fLaipNg1uNTzbDXqNBkdLQ1GGerOgMDGEFknZwe784qTh3ioA8sMLDGzjoZw1nlMqzEujuJ3xPNwfLI8tAcAsjW+Xpncgli5jONv513NjkvJYoTczIfh4Ii3RtSr3KwgmfO0xnWwihdHT92wYSbUdN/lqb9vhpyGP3PWlY1LgtPyn/Q/3LD1MYr94jRItvWR+sSDa2k6IeFtMUwE6aYLaCsBdZKp1fdJE7dOnp2VM1qzS9N7DgxRTYWroxnzHPNNCku/7CTAGE83Ds0dkUHR1gxI1jwy17pgKkBhG/tib46pBhcZJyKIKoofXweEOtr8YanU0Qk3CdSU2HAsSqXzdpqqonCCEmo5mltpzFXV7X11FHGP96xZJQI4eE+/C7ZhYFI+dM7bCA+7lnC3BB+QHiSwux43ak6UA3UdIXoUF1VRBc11BoGW36S13e4X0icu2z0zNrWVHWIri6xqc02N1ATnRJOalp6Ap5bvoSOMM3zWAHby1OSQf8W9YnvZhojmkuPY7DCo9UOIVOL0vUr/ti0YDZcHOg8PQotHfDt07v4Y7XC/Rej4Fo2k/v8b6UvM8ZWDBkIDfBptut0kr5iJm7cqONuLEiBoGi0HvgwTuDzHRYkVHshEXnhRr65dFo8MJT3OnbqYlIJr0Tiu/X8Jj+Qt1a7/Zoo1mCWHbS/6LY7l8LALBDEcK46ZGybSW0z3BAqt1wvSVVxuoXiCw9gSsXgxElzN7Ml8F/3XgPGUaku90REvgbtd4AFAQTkJBcjrLVFUgp4NTGs7zN4HUBFiahI
 2LntnmBL
 oomOqk0GdtJluU0K2Qo1WaZ+y7XQG1aFsJY3gP1FE5zZHwdolXMi8nmj0Mx7hhRAx8wu1kyvjOZ+M9VXsEYkxBANrDLf6gyoImQ7dl3iZy9O/ecw0tu15kX10sbE5Xrc/TpQ83Qm/c6gnTzz4Tk09noQPy2H6Sh0hEeN+ZPr8eIhp9z+LnQNTRe/2KsW8aSbpURM8VDpcnHDhP1IQle1e3ptEavcY1aBOQMtSErpqJvDICWsyWGbuV768nr8RO7ZWU4ZyQ49Wg0ipcwR/AzFq7O+5rrhQTM0IFnLJbOcRqTumzGuLOS8kN/qmMHjVcHkpYBGrMlMLbUhogUTalqHDokzi/qQrD6uyVtSQqJn+Wuy7Meg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/13 14:59), Sergey Senozhatsky wrote:
> +static ssize_t writeback_batch_size_show(struct device *dev,
> +					 struct device_attribute *attr,
> +					 char *buf)
> +{
> +	u32 val;
> +	struct zram *zram = dev_to_zram(dev);
> +
> +	down_read(&zram->init_lock);
> +	spin_lock(&zram->wb_limit_lock);
> +	val = zram->wb_batch_size;
> +	spin_unlock(&zram->wb_limit_lock);
> +	up_read(&zram->init_lock);
> +
> +	return sysfs_emit(buf, "%u\n", val);
> +}

The ->wb_limit_lock is not needed here, a leftover from an earlier
version.  Will fix in the next iteration.

