Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91F61606A335
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 02:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=RTBldsy2
Received: by kanga.kvack.org (Postfix)
	id 95C996B00EF; Fri, 13 Nov 2026 21:35:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90D5E6B05B0; Fri, 13 Nov 2026 21:35:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBEF6B05B1; Fri, 13 Nov 2026 21:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4940C6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:35:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C341A1602F8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:35:21 +0000 (UTC)
X-FDA: 85432158042.28.5927FEA
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED9C0A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:35:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RTBldsy2;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794623720;
	b=tMUVlwfjYjVhUO+BU/WBPYJGLubJR0tj4AuV9gIvhL5ObtZkd4KRKHKL8Yc9Djvj1Eu/G+
	gGnQJHl8ZPUsQzLXtlFPa0T6fzvPGOrlDorXNQ78abaXio15MLGDWOWrGqjIk+LbFxZUR5
	6bswOM/JwYiT/w3GqUgLf6DzReqT0yU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RTBldsy2;
	spf=pass (imf25.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794623720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrzkgDtWmdDQLLKKJvsVZHgpBzkxi812kF2+E/CI8dg=;
	b=KJgYrUl8H+P1DbNp7sZ3xLavHGKH1kf8bhTwWL84twLfC2q6rR7VUDesOB/6aOkY6eCzfh
	RCZB1i+JMbma0SqKvpkn7z8Nl1kbB4PcSCKdNIBWGPGn25TYS/tzeaEnKldLOL1/CCPP1e
	k1/cMvJbA3A9zwIm4BDrY78nRJIMNaw=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36f8cdd30beso1079453eec.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794623718; x=1795228518; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BrzkgDtWmdDQLLKKJvsVZHgpBzkxi812kF2+E/CI8dg=;
        b=RTBldsy2ycHxSozkDLQVRS+cWNRhBr87lNeWiS6AAONrZhPRLjRS7YxLofqa1pQFZL
         fReFWmhplcOOUrM2DlPwDNSQZ65KpYsmBwIS0/lzjd+GnhtC6u91/ncxd0fxR7uuKxSE
         0YRHJp0ZfMCEh+/iTg8q4bTdLubgTOcgjqco0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794623718; x=1795228518;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BrzkgDtWmdDQLLKKJvsVZHgpBzkxi812kF2+E/CI8dg=;
        b=qE+L2njUDgrIR4cC7WvcUNoXXUxVUfdRbi2DGUTguzw6Ft7G7bviuVVXurhivyKYPD
         /IiLppwN28ua+BptnvRqm8XAjEDB97Yw5I9P7EC1Xk9jZrvvG6EUs7iP5v3pMNvY8kIp
         WlTJZL6s7WDFKqRVv2tgaMBqT3iFMW50u5UxRSW3yj+nw0lsAijOmSHkYQUNm8W/r1xF
         eROA83Fw3vqViPtHNS/koxmwf3lszjVMWAx5T/Y0MmqDqKN43FfqwlC4xKvDzmQUWKCo
         GvoRSaI37acQfzVYFVc6IiOn2kzj3uMi8ck6zogdIPLFfeox2+P2YaCUG6Ycx/K+bkgo
         qLJw==
X-Forwarded-Encrypted: i=1; AL+hErF0r2s+JnTt0Cf71ICSe6NgKFqsKnpUkBoqhbG7xkk0DjrEctYKrmcYE4O5H2HL36skTODHL5tKlg==@kvack.org
X-Gm-Message-State: APuU4Z8HkzbTuqiXY0S7C36cYRzzIeJDJ4qv5RON1EnMeCDq+Hk0nssI
	g1RTj8kfBTaDzxfCwND0AU6Qn8iz3ppjU7qW/uGxcmD4K1UUqc91q56GJMXWO0N9cw==
X-Gm-Gg: AYBFou2+luz1Yuav6L38t42jnrfTLuHX7bhYVa4jh+GVYv5cVNwsoN/P5ekojOZarap
	LYsG42VSbpq+5QLRRC1PZ2dg3oduQnfGfIUSg1IPC5ycrhUgrUa7IU+aiQ+l9jdaaSPN9EVGlqN
	RyixZ43ovnW6E8CE2X1RfNSu4bhl02Q1rzYk5ZfF5o4nNs0CbcG2/eYIOtvEsbMVNX8lSQWHwfZ
	WMk940jz2dHIgkGCCt87Z+QI2V9v71FD/nuAPdjaoEk1V2eZKY3Z8GCOSWucoHvXnk0cAtwucks
	j44bKHlFWb38bF/st4yYHNVPPok6Xv9SMugvn270YJWDaqvYRHmhfn/qqMcxI58VGe4C2r1Q0dZ
	F+UhFJUTs8BV0YB4UNdCYy9tPfl/jd1JGanynF3bcVmW3nv5vrq2kccFxhP/4f+LQ4hY1Od0JKq
	Te5dkRbEVpw5kIZX27XbG7fmNY3UwynxHT5ng4/KaZiyRpQ5xVHyeLeekPwfk6n+21Q21lDuAeS
	imJQrgjZjcLj+2JDjuwXE3OjyV/8ABwMAitTVMnAg7FMftwjTXbnthDr10Puy/ahQEZA2zOoJXQ
	8TP8lV27kO40gWBfm2NHg++9YtgzCa29Lgf6i3U4/xuoi9uL9V0nQlyzR61Yl1N7GcMr/Q==
X-Received: by 2002:a05:7301:9e4c:b0:366:dbf9:32bd with SMTP id 5a478bee46e88-37965da96cdmr3175541eec.9.1794623718394;
        Fri, 13 Nov 2026 18:35:18 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d97f:ef68:a8e1:6af5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm11080880eec.12.2026.11.13.18.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 18:35:17 -0800 (PST)
Date: Sat, 14 Nov 2026 11:35:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Alex Shi <alexs@kernel.org>, Yanteng Si <si.yanteng@linux.dev>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Helen Koike <helen.fornazier@gmail.com>, Vignesh Raman <vignesh.raman@collabora.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
Message-ID: <avfImwT4gmBYdNv3@google.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <avZyo_hCRonuhXW6@google.com>
 <179457128804.2142163.14813125534208665209.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179457128804.2142163.14813125534208665209.b4-reply@b4>
X-Stat-Signature: 1gpbuk3mfebxwm5gysn77i1w83czjgpf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED9C0A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794623719-609934
X-HE-Meta: U2FsdGVkX18XeV4PWVpdDFTWR0iLuZGVbnHQeX9k3UF7KKUopPDqXk2M77aSkVJvUX1QkjbKfQgqxOSza0ew2dffNOwfa/AlEDsCbjP288dD/DCMMi0+zXI5SOjOSYS/qcEqv6j8Xk+eueSzhtA1OCPUuPd82FoYrsoAEWslQKH3jpoHdDo+tmrzWhrfV34p1rML/dfS6UYBwh4VKnZHqf0wy/8K5twtGMOBq45bdofwfnhlkVpq4i0OVNzkD4YxXsQVNe06k4BxNjleKph2qv1QvzU0JhrVJ0IMNJWreG2i+FEVCO+dXuakwkH5sb8Y/ydJXBpDZCBU8Fk/mq2ut6UGLHs5gHQCBJQAjIWE9YBP/rjNRsNrxXErxC43JUKHX4mXEdXvCHhBfc+4T8OJXGS447WOwMYmiqkx3hfYQAbyDJkUvXo0gY2dW35i4LldqqseD2BnOqmx3gN2aBqMofy5cPzE/K3zN6E0gEEJidWeuZEYDHB7MX7wVLWyw18qOi5uouELipquSgBX3OKHK6WHxORb8r1Y+StVUzRh7qqsOF+r3l/BPuvBuqFGT30A56hfNIOO9OPNQsFPDlRsi2SibCcN5LYL1teY2XN6sL4XN+mJOpsDML6QDbAi0kxBVltRHnbCdgJuzbzTdbqHkmXkgUdOK6GIR1G0MAfOOGTKt2XJ1dkiGfT7QVnc/qAV1YJ3X8SVq5bkdxOwAf2Htmz9koF4dFr2RKHyyt/ET8AeEm6F6j3TbPH4vMfPwMcDrRkLGRUE+t7tkCIkcBjshq8+T2nD4EZiPbBHq9LbEO0ps+S7HRdnKIM+7256EM8Jj7UVjRspXxzILl30+3lin4AQ22RUD7E/PMJ6v/SEVegllgf23WAsM7wN5pV5QGTR2qpykPNgHCwjbCfM3KEHBBXJnpo6dui3geOyVgvSxWNCnJq0Oq2EuRwM1NG103yUum2N0NIgM8txj03KhSz
 viDpIyRE
 VD8nZYkTGad5Bcs7+efnyJoObrrxa47z2J7i1Hz3o/4jY7G5nEo4ZE+S1MAadfFMxweB56KNIh2p2X0Tv5ZCg1RFYkxoJijgAsSRsN12ZiKdCFbNirZnthswEVF/tECXT4Tm4uPnTgKBvOc7hsgOqRSzU7+p5Qc7DZ5Q3BGOGgNV+1P469lt/Og5aPIjV3V2TxWr6BBD8V3mzx0Kprsrbbd2lSys2BYrcGrvXDC/8d+UdkSqGr+X32QDFnRdszukoCz2n0/de5lBVzFl9ld5nt9LPWzL3DeJCtEY3MGcyNx2u1Ds1jSFeLrJQxoto9cqDhDNuAM7eAlk2ReKHiKjXzQazrk+8iEoG6GrjQOYDbtO4mxXxSn3Z4HLhqDzQ4AngpJtKV33ns2SaGR4Bq8fgbVNhPY42mFhAGKEpOEZKQUMVckvt2G7MuKS07zsnJjayA23qZVpBu2JoozPa/Em0NSyHNwhN+tlyn/cl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/13 20:01), Xueyuan Chen wrote:
[..]
> On 2026-11-13 11:19 +0900, Sergey Senozhatsky wrote:
> > On (26/11/11 20:41), Xueyuan Chen wrote:
> > [..]
> > > diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> > > index d2bbecd78e14..4c0786378dc3 100644
> > > --- a/Documentation/mm/zsmalloc.rst
> > > +++ b/Documentation/mm/zsmalloc.rst
> > > @@ -33,8 +33,8 @@ proper handle-based APIs.
> > >  stat
> > >  ====
> > >  
> > > -With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
> > > -``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
> > > +With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
> > > +``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
> > 
> > While we are at it,
> > We use zramX throughout Documentation/admin-guide/blockdev/zram.rst
> > and in some other files as well.  So let's just replace user/pool name
> > with
> > 
> > 	/sys/kernel/debug/zsmalloc/zramX/classes
> Zswap has its own zsmalloc pool too. How about this?
> 
> 	/sys/kernel/debug/zsmalloc/{zramX,zswapX}/classes

Ahh... zswap.  Good point.  OK, feel free to keep it as is or
to use zramX/zswapX.   Up to you.

