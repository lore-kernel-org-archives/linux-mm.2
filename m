Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92E2CD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434528E000F; Thu, 13 Nov 2025 01:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BCD18E0003; Thu, 13 Nov 2025 01:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E1B8E000F; Thu, 13 Nov 2025 01:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5EF8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:08:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9AD312E352
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:08:52 +0000 (UTC)
X-FDA: 84104555304.07.5773351
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1142C0004
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:08:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CZ8Ij5zZ;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763014130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gw80Q3rADiMFZJQ1jC3X078+JYTq1Rdist1GKyxgI/A=;
	b=MK2oid40uxTl2uojDRm8bLUMpjQu7KfN73+4EE5BWoZ/6UespeSC+szooDuwf2FdApIL1j
	eR7jPox/mbQmvvbHGXXNibZB1hbBrCYk99vU5z29BqXTAU0FF7fUSYYrLTXSry1xkDWPin
	rSE3P7XDF3xmwHd0R2F+yFmQoqnuO9k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=CZ8Ij5zZ;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763014130; a=rsa-sha256;
	cv=none;
	b=0FXzN+Bq/ZcDfo40S+IOyV/Z1dFebc3U18x0HEnQp52O85lWU9ctmgX4S5swQVzoCkrjHg
	191KHoHqvNZTi1zgfKrf3KqwVlvwCsbbGkct0ab9FN3JWoQp8ujRXpCK833yB352LjtKI+
	Y/QPn4NC2yTf8T/GoGoUP2gZcWcIsNU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7a9c64dfa6eso295308b3a.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763014130; x=1763618930; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gw80Q3rADiMFZJQ1jC3X078+JYTq1Rdist1GKyxgI/A=;
        b=CZ8Ij5zZaxAPZAsV0QAQCSofoVTpvFE5RolfHC4wjxLtoGs2O8hkYc0wGNQ/DZz9sZ
         GFNWPxp4n1yZ3OICkjRKDSCP2ZUi1eunoGniPqVQsV8I/CjWXN1Ft+kCb7chnvLOpsBX
         A9PAc5jWa0YVn1EDZcp6r6QyfBLjAPE0Pr35s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763014130; x=1763618930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gw80Q3rADiMFZJQ1jC3X078+JYTq1Rdist1GKyxgI/A=;
        b=IuTUnUmhVvw3/eTuV3i9n2zVlhOkR68xJwBmRVN0VNhEgLyXARLR5ApA/zEw+G6Jum
         nVnHWyd64ge/dk61kdTBWiSQGgZ5G1Cqv15YrcP6hstns7iWz0ILl7x3wezn0ZL7URmJ
         S/37eMz0DxI8tVEyZCKO7GxfDGjExsZxm4qjHqUzRkNt0TYBgdxjyvGyxUCLeD2jGcPW
         QSpECPwYX94ydLaRBR/X6St8tj9EbYWdoAUHP9l9+pHmmvmLB+dXme/OLP/hy0P5n8AR
         /tL8DM5B6VfrYDBhbQkGBuY1O9L0dUVRQ4X28ae8+ORZj8Yidexn7BPC92xLBwLa6t0A
         7Mxw==
X-Forwarded-Encrypted: i=1; AJvYcCUuEju0Iyi70Hmi8/HevOfWGvPjlt7fjgs74vMoDef0iHmMOn5vrcdMZUwNoaJZiLYypPycRk89Xw==@kvack.org
X-Gm-Message-State: AOJu0YwL71CKRN7zNm/52cthxXXGg46n1/eS/atwEKalvNi6eXmLyHku
	6NVpNL65ujaBXZvYxc0p6z8a/qfvgfg5Rz+EdHCemUnd1yGCqofRBdTV+8dixNquiQ==
X-Gm-Gg: ASbGncvwGvxwkhdlU9kLgwD1Q8+s0EK8c3MtsQhCFnoC1TT/vkZm5Mb5DHVwvUnZCEr
	pZoXqAjLdVBsUJocYW40Cf019a8e1+w6c9lvBoH052dKXKcproBoejwfvx+mg7r5wACrcD4SfgS
	t5eMHcnno6XZYg2lXqFsldX6WcJj/Yud4f4ujDSCNwJjXvEKA6whbO3thxSgq9WteEKN9C/KtQN
	C/JP/TKy/pFuLRuAQ44K9nAm0arsH3Q+DIhDyWwd6RVK1AyCRsHfdxDujphSueYZLJbGjDrOJuz
	94hPQ5/yc+bpO5f420TpwwcqJqi5BeE+OiD73fAKsdope8rQaWcAOWk6vMndmiPX3E/vvt6K5Sm
	wFmdF9T6/1gh5jTRkOENcGiHjSTNOQRIovJr/lj8ikQ+LDTDwTrini5tXKuLUdoDIBgCD9nqPAh
	Mtb/GN
X-Google-Smtp-Source: AGHT+IGowM4k2KBhCbph1UBTZNDjTuE4Z+T0S2CNV/KUAFRo/MaW4AiJx6RQgvWm445j+0v0k5/emw==
X-Received: by 2002:a05:6a20:3c8e:b0:340:aead:3c with SMTP id adf61e73a8af0-3590b02ae4fmr7840094637.37.1763014129699;
        Wed, 12 Nov 2025 22:08:49 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aea0f8sm1003329b3a.5.2025.11.12.22.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 22:08:49 -0800 (PST)
Date: Thu, 13 Nov 2025 15:08:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 1/2] zram: introduce bio batching support for faster
 writeback
Message-ID: <azppxi725gcsjgbmcy6c2zvjwgevzt2ci6ri2bwsdc7x3zrk2r@w5yiry3cy2kc>
References: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1142C0004
X-Stat-Signature: etuq8bitepqnhwfxfozrmwxqp19xadu3
X-Rspam-User: 
X-HE-Tag: 1763014130-5368
X-HE-Meta: U2FsdGVkX18CItDpSWry9pFU8rDu+qpjH51yQaiG+3xL/ETcvi4kutpIUeDT7wzTL8UGm5fmtP+/TxRtxxWda3/nfv3+VQFHoP1fOvRSyScPGMbo6fUBSkFzi08vPrGaD9nWRJgrAnALZIIMEvODkI9OkPOeE/jnq7kIxwRlDKBDwJLG5x/dQGF9vTILwuGjNscOWJbCSVqgAJ6hSg4hW/cXRIHa7rojxVH8filomeJoWoy+w0ZI9oY9yWjfd0Q6h/zfC4CCecGIcvSvvHyt9zeXFyOGlskIBdzRkW9B3j/h+Q/qsmTClKo5z/yJCc8/CsuqfZw13qPOYMBMmcaGIHM1ZgSuHHDdOS9BFXg1kRGK0GQ+lY5xUUkDx83Jsnufh41zufXNQvmXK1HNNJwqXu7MZX8FQSgpou71M+GjQL+d7rEWye2OZoTTQGPlWujn9H6SYp1zsOA+oK3pi2HDGR5Wz3n6d+PDDTx+40D5L2vIl9R3N2GCRtEx8g03fnPrMW/qDGf12I2lSUfzgFnn839K9JYRW0On3SmuhOclcQEFUeTkCdQgb9g7lU7VHx0ADIjYYTF8KF/n+95fSpjU+wYtRX15EJzKlMVClZ1+AFnTjmkP7Txg16WMvpcXjwlBu9Rlc9hx5S9Ar+AtAIs4wnMRp1ttYhqsjFCUMS3ao1KQ/yb40XDxDcpKo5m2Geg2o1M7Rr3+C2RxTrrMHRynXwQYBKRdEmWtnygrvjx0o3lM4xXHYLbsqocH/y/0JOApSs+RaMSm+m3D0g4MJb1I1v8qb6OMZnfjYO3taB4w0O1ZlTzz7hd9p3sIsmgUFpiJRfLqo5NF+aOWONTnPKFzbMXesyMAmzkcAjDfK7pKr0Ef9eQMOX6lJ8dV6eIrGJJugDQRPLmUt3TLxl2PoqgIxE/JakzMikE/93v5wDZq+uQrJtXaYmRjEmsvy/Z6XMYglufj2b5b/6nFTTa7VQq
 kifYBmy8
 5xi2Kd7oYCgWlh9JN0M7yOQ/5viFB5XH0GYGK8Dpb7o1nc0ENZNjT+RWibfQKnsQUXan+HppBCGG4qPX8wbS4IkqwJFYa8sst1iM4i2mGyOMFSEf4b0zx/WY5OLjoZmuKJP5WdxB1mrszO5BaeDa7Pv3kh8qhps9Vx/+wF0VoRtGH/ChBGVPFtRr7xd7EzY0MNdClt5sSRTwB1Rhs3dxR91wCz28Y05SDfmHqfy20q9LbeHVXE2UUAHmAsfrWqZDNZrpAikvwb9ywHA/ZyTBEtFqUvOGDXsLaD/SgK1jbqcszlgRaeG6YsKaeiOawhWE4Csd106IDvO7Yj07qeHSjaIaZ2akjGLqw4k6BDIVBT/AQXzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/13 14:59), Sergey Senozhatsky wrote:
[..]
>  		if (!blk_idx) {
>  			blk_idx = alloc_block_bdev(zram);
> -			if (!blk_idx) {
> +			if (blk_idx) {
>  				ret = -ENOSPC;
>  				break;

This really was not supposed to happen.  Will fix in the next iteration.

