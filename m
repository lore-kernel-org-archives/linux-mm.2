Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1952D5B87E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BBDE6B0088; Mon, 15 Dec 2025 20:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D556B0089; Mon, 15 Dec 2025 20:00:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29BFF6B008A; Mon, 15 Dec 2025 20:00:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1240E6B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:00:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7A6B140416
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:59:59 +0000 (UTC)
X-FDA: 84223527318.10.2268D98
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5ED020002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 00:59:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KZNxntaw;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765846797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XwPO9yMCVhQskNTI1ysT1se2RsNXzL/QNGlyZ6nBCg=;
	b=BVrM40XcNxvzY9GQO6LzRcJcrTnOvBRss96upXyMlKKPe44xg754NJsvDu5/oX54uEUfZR
	JUbjttPVuSW8kUP4oY+4FgTicJj+TWj8USYpVHLq1MJcvuuQsRqFcB4ttAqShk3DhE/T+y
	fRo40jyerz1Cx2sJcwKXsbLNRBXs57Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=KZNxntaw;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765846797; a=rsa-sha256;
	cv=none;
	b=Uj8BXITJCdnsdTCR3jdCkDTKsQ9BbUAzPKwuF4u0kEYWCOxqZ7lP6syVh5OnkIndrDs+gW
	KUI4WHeN7DTHY4GY6CRXBOZpYrMYetEbWa1pMQNehzX1rnCRyXJWaw9IRRUtmyRT+vjHNL
	T8I3PAdp4S3Og/t4nPsF6QdWxr5N6kA=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo4643365b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765846796; x=1766451596; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8XwPO9yMCVhQskNTI1ysT1se2RsNXzL/QNGlyZ6nBCg=;
        b=KZNxntawW40dF36LNkChGNabsekO1xeoHpWvPZviBk/CevsD7l6PYysjJOkaU5a5Uq
         rMxaox4Tzxwdapp2ptzmtTh8+Qi0HTmryxoLnp8LqcMkYHTAOlcCm4u1FvaNkjvcoaXI
         4lVQvJ10mx00lJPWQpR+yI5HkXNjP1I+2SPAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765846796; x=1766451596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XwPO9yMCVhQskNTI1ysT1se2RsNXzL/QNGlyZ6nBCg=;
        b=EKjpR2AEatG9rjKHoj4mGUxowmFn4/QTATuaKqp+UYh35B5UvoQXitV0rZFo8QtldD
         37oSh1FUde0vqZBqIFs3Au2x/mqsMH8knRJ6wFZ2i2OJOMXYWLjC319RpLEBmkQ3gy7N
         L+QSDCMIPeTUk4HJAeIhvahvcOMvB/zxl01hIi4RdbwIFJ+LLDjUBVgIFfqWQtKqBxL5
         ziEF5jV+JcpedI+6oiwV0xCpovUwb3pcefrhfiDERb+amj06Jse7ybplXuWf9m6HtOpZ
         lz/Ar3x9zBlQjM8/50BJk+FwMjr2x3RlZR4fPzt8ay1BdY/XDcbpP9SzoMMTxXjb5CAt
         qXdw==
X-Forwarded-Encrypted: i=1; AJvYcCUOJDZ76Kp4hWA1xxoui6ARB8G3E0Jo77C6iUlCH5mLr/hpCIlROO60iJjzO9bMahc+XjAXtqxNzg==@kvack.org
X-Gm-Message-State: AOJu0YzBqsyPrvHUR4kggvx6IRgAX1dRqtIHnDn8vECI70X0jKZL39sp
	NNVQ818728vltT+OApMZ+fow6R4HH7vJerumg4r+a7TVbicE05pDXeDbp2FIqkrcow==
X-Gm-Gg: AY/fxX4cPx+sOJrWLYBR1ydq9P0Ngs39epbdySUWxRzDoLKV1VZur1okElRZQyV2dVZ
	wDgRcExt+rZMdCSGwlvcohIqwqTY92tCHt6L2CFK12Uh94/IixTycmaffVtD5ar7E1EYc3pmveM
	gX+36Twje4CmT9kOlkdwEosyyptAX2hCpBhuPscGb8fTveA0zqUj9gqPKIPE/4F6ist69R34u2y
	C61ik841d52WRskmzU35jz48cj3iGjYB16xn4ElcVgdE86j7YkNFuqEEq4Zlx/LVdYqnfnA7czd
	3MMI7YuC/XnGD99o+4+PPjabiaj5ai54Wywot4ypB31DwMY1S0gM31w5xyBxudxkdGvJ2Yfpgz7
	Z5O7SAr38QxN9Wh6SadGc1cByQspqEWGpQz3HCBDQuFr4XcRKvm8NnHozo+SxV1r8Lddyqhzl/7
	iiSoxhAQQUXgQ2ka5S3sc8JI4/SaAVyazQKxV5ggu8n6QDrkhsnOM=
X-Google-Smtp-Source: AGHT+IGEC3wHBt1cpaWxFq3rArlKaxZEuML78xaGrv1POPMuUxQiI92/Ql/BFfcCGA/NMFccVMpAMA==
X-Received: by 2002:a05:6a21:9986:b0:35f:30ff:89db with SMTP id adf61e73a8af0-369adfb32camr12542999637.19.1765846796634;
        Mon, 15 Dec 2025 16:59:56 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:88fa:c762:fe19:6db7])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c0c2c963b53sm13573171a12.36.2025.12.15.16.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 16:59:56 -0800 (PST)
Date: Tue, 16 Dec 2025 09:59:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Brian Geffon <bgeffon@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 1/3] zram: use u32 for entry ac_time tracking
Message-ID: <gqkugg2q3hafwikx2wvnsh6oa44ifbtuskmigsqbrkaztjwj4i@33n5p55zq3nz>
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
 <CADyq12zu_o1fEz2B0nrZUFhbnEgiLPVkJv4ku5mrXYNBBNQ-Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADyq12zu_o1fEz2B0nrZUFhbnEgiLPVkJv4ku5mrXYNBBNQ-Dg@mail.gmail.com>
X-Stat-Signature: 3c6dqzs6uu689954za5rso488oncn96p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5ED020002
X-HE-Tag: 1765846797-808300
X-HE-Meta: U2FsdGVkX1+WTvbdCDaXH4ufAlgPb4mKIZfs6AIHsQHtEe4TFl7fR4YrZ1I+qkMhg7plf0IIe7RDLk6ZxGdpRW4ukux/VQa7IoLGhI00hQnkPLlE/0ld7rPVuf0wJTRAtC0Iq9Dk3IfM888dbPUJlgQrmhIQf9UY62TeamgO6smiILvyvsL1RMP1RDzliUB5/bhh4zM3S1Ye52xgKtDweH1hc4H4tTr6AGLjw30wN7A8voqH3SfUyk4HPmshPDh2J0521nViWUoSaVJ/K3tHNnfv226TghxgysRcfRWNqZPD1fer4B1+Nyzy56GLir8ZdoghDtK3J6yUrB66ywT8ytDjK35ev0H0T/sVFNIZ5oQ9jFj/CvmLEQU9iEdRamlAK5Eyn3ssZjyoDwee+e0oLawki/92DMtbsP/CRxmaoBPPXlOlAvuVy4PWOge3LKTCJ2DsMX9tLaXDQGYSIenb4/wsYjXfUzoi/P+sKaGGJ2Yt4yMCcygNm4xuZg22CSV6HmfrM0617j/lyxHSK03jvfO/KzW0/p6xAR6BfBLvQ4ujrxLtYxW4qO803OMGxE38aQFAEzHS2IntE3SqyTufVzw/9FLg3ikmCUMyYq2qd1Mji4KmbgDTxT5aOpBB9hWVv4EclxRzjsPvX9n28elYqJoFCAmDHQkrTIUV8JfR3a54aN9fQzBX/SwektmRRyLnTUd5+ssPixRKZAzFOpIs+UVJ23RgRj8K2YvEzsHw/HDi/VRvmDpGu0kqG2wJdj/E+3SvyE42zoJ0H7g+eIYZpeDKi5SfkV4322PaioB+hM/XyG/bwF1DJwcD61mludADjS1UrOaa4TQ0GjYNjjYLyfB5vgk3z2HtemZR1b9xKp+nkRGQfeMWWITX9IOps1qxV6Ln/1yMjFOFd58JQjoR6f7lHZr+ORQETnp/zyKuEQg4TmsLXVYw/aHQNOzhkL/R5uS+FOA2Lt9LDVi+dHX
 bpGG50bn
 mqgFDL+NUGim9QBMkhw7jNRGIUoU1+hHj/xq+soWo1ZNy3C8tOlSNpLWSbwf+RGphaJrOmMTfbN655L1GwH7kD6B88otQ4/Gq355uYPDmIze3eegL5tudHFUKy1Si7WF6pO/S049zrUsxes+igJlWwMYUJoPqddBo6qOecYCLuc7lcG65Rrhow/IDeL1mkIra7tTN0pTYKziae6eNZ6TtYZgNaZhXPrB7IXI1jsGKWs8aId0TAKYKgBhNUn1lPcsQqAEVle2UM55cd1LzaN8BX6yLOnMKfNGZalne/hq/6Yq6qX3dnk6u+ZgInS1RjWlShUjPhH5/32tqsKHqdvvYKhZsfWjFTxZ85d5fObQzAUHoPHQGWnOdj5s4fxAfu3j/eYFKRd/fX5sjL97IZQaZkK5Ckg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/12/15 17:31), Brian Geffon wrote:
[..]
> >  struct zram_table_entry {
> >         unsigned long handle;
> > -       unsigned long flags;
> > +       union {
> > +               unsigned long __lock;
> > +               struct attr {
> > +                       u32 flags;
> >  #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
> > -       ktime_t ac_time;
> > +                       u32 ac_time;
> >  #endif
> 
> Why not just always enable CONFIG_ZRAM_TRACK_ENTRY_ACTIME now that it
> doesn't consume any additional space?

It's "free" only on x64.  On 32bit systems the removal of
ZRAM_TRACK_ENTRY_ACTIME will unconditionally add 4 bytes
per zram_table_entry.

> Also, why can't we do this with a single unsigned long flags
> as before and have a simple method that isolates and casts the
> lower 32bits as a u32?

There are no upper and lower 32 bits in unsigned long on 32bit systems.

