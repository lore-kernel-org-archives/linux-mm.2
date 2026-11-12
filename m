Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C715F606A886
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=dLNedJjN
Received: by kanga.kvack.org (Postfix)
	id BD5A56B05B3; Thu, 12 Nov 2026 00:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B86956B05C5; Thu, 12 Nov 2026 00:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D706B05C6; Thu, 12 Nov 2026 00:58:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5776B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:58:13 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA8A9A0297
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:58:12 +0000 (UTC)
X-FDA: 85425411624.27.6A66145
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B11D160007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:58:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dLNedJjN;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794463091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJdbe8Z1UGMii/S1oSNAgpt4OpGi3Zk0eQAxAhAGgRY=;
	b=remUUhz4Gb1eDFDuqxnOfPr6BGKrb2mL395riZaZvfsP3h18ok4yQ2YZpB8ZZNmOgBGuMD
	omRgss4LsTja/8MisRMh6gqQH6QZICJFOXZnaZOqpe7fjbnCYG7vU1Cb1sBfhpa2fCmrpY
	QfbemZNPenQqxtPTyU/b4cpS2leCAwY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794463091;
	b=zCPEESD3gRintOqYB6G6jI8nwtV91d2dLZzqOjQjV+S76SdHaXmpMSjE4IE+GrZpMcQTFG
	TiHEpWYuWRz1CL8FzraHJF1FQoqLWXr7l4dZNJ2GBuGHXh6UnRpUMUORpwgzJfERn3jU+J
	FVFWeqB3/R07jSeI8apLZPL8XGveTpo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dLNedJjN;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3712b6d9843so3778948eec.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794463090; x=1795067890; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJdbe8Z1UGMii/S1oSNAgpt4OpGi3Zk0eQAxAhAGgRY=;
        b=dLNedJjNQvQ/WbZZsHF7HSU9kqqZzap7wmwjrl/t1i40RNGlJuvDySeW1Wp1hbgsgc
         NQXUMVm7C1kKN+0FLpm+aH/iqQ2p44shjRRSlTEYw8Sa5w4170k1t+P3EdsbFq/oRXjn
         Ii6Zp2t4nTj6+kbLbnUknLnQ9sI8dCI9Kiy2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794463090; x=1795067890;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJdbe8Z1UGMii/S1oSNAgpt4OpGi3Zk0eQAxAhAGgRY=;
        b=BXlhzZdC2puQd0jQfNPj3e3xUMQ2qydvB3YJCGFcWVoTTY30BGRuvFt8j6l+BeXeSv
         3Gcbf6ESUNMVx/I127Us7VJQOTf2Y0jLf/AmvTyF0H3IwzJ4yCebdd+eeJbbsfRteNmB
         tQUfqlPOMPnPpBPZw9N99Qny5RarhrCMX3MFCrNC1/1RZaJWAS1Fi/NmDOqrTt3yihnV
         59BPpL0b3z90tLWdE4P7yfkK4u0oLwY3gehzRZHAy0kpJvmZPp1ourrYEnfTTyTmzfin
         GswZJtCDT+PZwmpX+SfclJGNY5cMdZJofl1JXjgaHDviGqg1VhizeEeEVpLuU6XRZijd
         jy1w==
X-Forwarded-Encrypted: i=1; AL+hErFzj7wGz6s53lvk80xMl9GivkCEMfS4xhKckW8P0zw+WFUwBSM91GqGBBs5V5gwSH83JgbGxGGA1w==@kvack.org
X-Gm-Message-State: APuU4Z8sGzIXE/f98/vr6+vdYdUFB4fNSsX39ggTkOYFVNDJzH9jAuWU
	BGj5MkI46RgBjH3Sj4g/uJQtvO9kEKxV/eSxx2pimRZCdH+1LKbO1UXDBc2VfZjyKQ==
X-Gm-Gg: AYBFou3p9+IpgVWE0hWuhvZJKXbmk9lZ9f19bjM7CEiQ+UFb5z2o2gB3zJJVWZUOpgN
	gXz9Bz6ysb+PWlIVt6mX4qtnff13qtUZuCoLj5Zzkv25ZJoxHAJFwQA3IWlsxapdmvHHGm2eNjn
	KbsIUx6iczgBQXSRcT25GDCd9FH+34QxiutQn1wwDGSmFfp+ZbWhnrVC9xmcLyfWZrzgObhz7ON
	mq/ifKnutSgIlA1PjH+l5BmlFqINYk1Yi36KqPk0h/f6BPm7S0CDoQTbZhJiiJWUtfRsZE2k+pF
	B0CXjV3Xv9Xf1C1cc0nhWLfywyT8bx4Ym0b8yLW2qzsq10HVVWuMbphKVsU2GXHkBwYe88BkuRk
	z/3AH0Eps1+PMX6uvgjH8D7fk8yufj5YaCorwSHkfG3EIsq39InsAzq2rBPsZ3+b4qKpRazMDbn
	ZLqzIXJb7WEDpJpSAm2m0ePf1wxc1rwDeIKlhpJatueMkt9iXeUQrmpCK0ayMRKEAGf8pmRmwDb
	wgNAzWB1g66tai6b3Q+jsycpDNpVqPiABU+JLlJBL/TQs63QMXNVPomxrd8HNLV/b6YJSFhdoq6
	/DDbeYlA7dNm0LVDvrLWz2Fk5lK8bHUI9mNqysxmyJZDHOWEKGEQwN89hLxXnTWL/K4i
X-Received: by 2002:a05:693c:41d0:20b0:36c:9d4c:6465 with SMTP id 5a478bee46e88-37686566c17mr4649032eec.24.1794463089494;
        Wed, 11 Nov 2026 21:58:09 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:a83:9554:c09e:5352])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751fe306e3sm23839542eec.7.2026.11.11.21.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 21:58:08 -0800 (PST)
Date: Thu, 12 Nov 2026 14:58:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Chris Wiseman <chriswiseman@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <avVVRYkIAQnLC_Yu@google.com>
References: <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4>
 <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1tfwyor8uazraheuybcqff5pmo918tbw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0B11D160007
X-Rspam-User: 
X-HE-Tag: 1794463090-613703
X-HE-Meta: U2FsdGVkX1+TA2OKib4UYu0krm1aYIOQWD3ohvHCZVvkmd7R1ym1fKgKMLXHh/2srOKyu7wh26iYfcZZO4kB98liBU1KUiAhbAXihTLPnfSjq/dEx4fDiKJXudirIER4vCusSedgxoQ+SSQTNQeFukpwmtJHVQbWzDYHMHw6lznGQ5rgrQmNlckNixCa6KF0T2AFiiPKC7PBIBYnjQbwY8aAna9Jk59EYC0pX7mMU4ln1D2C4lP8AsUBjr+AEJSP250F/4XxvK+FUV8FPNEdv/44SwR538NKhM012NddZ++v9Mq7MPg0pZqR0eU8XWdoRv8urxvvoWTv1WkR8QhHc3pl8/c2iXyZOsJ5YM6Nw+gvQkWUT2nT5m/8//XIrYaqIfGsNLUdMGc2HmeG4M2wbyQu0kId6ht2krHSPW7jeUYXIgP6McAyxf3SfPZE+eotfEl2oLlQobxJhXRN8n05Ghy5dbVe+VejhVYJLVftNiNHGlu7YiqSk5Wf1GzKfaCZtSzVQJ0s1ngLeKDxVMhjqb5AUsWMPEwfpaFGqItBGAju8f7iDfp4pB56sD6ygrYvM6HWeVg9ifDP9cNJIqXfWXjvCe0BsBkGHWdAIJ7KY7fwN+uenEt7qKKDJP0NUpSTRbGfK699yx3+vHFiGvTQkMSAFfQgGlutLGvh+wGlXUNZV/NJRG00L7JHec4gHSvc/qNlKl9BxekKGOMlS07NjkMheF6oSn9/g7N3ij4s1+PPRpTZBiQQanE6Gja+x1LMNXaMvWs3AsJfBpyYYjAq59HDkLx2oro4xbj4uv+uokSGeLClZzYbaaYIDIBobze9bLzaSbBCuPUwQVPkTFAlJY/fvMUOBYeLzN8K7BTKH1u7rUu4azwBFkvPDeXQNpd2rD8seunzPfdzqjRs3n0RPQIXPPwsXAqfVjvcwzJPczAucwo97QrLSL+Efpirr72NS+KzIzzE3yDrpmCqn7a
 /khF0BM/
 53Yw6yLtGHV09xmXzmvFxA2Y2tpAbUXdpDnMOIAXDSRBIqRQJpbTElMAhXvxg0kR4tL8erCSRB0YiDlgfHwW6qjREFuFFnhNKNn+nag4aGHMnEnCb07uF3/hPNr/f7DWBUxXb7MOWxnSjbZzskEEIQ+HpU4gy8FFCi94ehd2jNoV4FrAgTPlZAwDsi9+6Ek64wfz/sCTrfmz2DM8nHyK//Kid9IdE27Tim3OpNPCN6N3QXfGs8mCx7Qc0csy5YUv2f8g3AsrQTRHu11TvSa52bLomGhDnmhYqCOV7igSuSmbIhsrjpa8cAYkpcx9U+GyxZybDPmtszG+C+XGm5a4HcsjnoZYAc2TR0I68faylZ2hOR/hhyFOXY3Fzf0JPUvJxbI/P2FTLYaCfDEJMUWvW1LwzdVSNh7cu2xfOmCWMTvFsxVMN0rO/H8Hew4Ew8fcXTVtpM+rBW/Hp/Tlgmc11XZ7cZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 16:53), Chris Wiseman wrote:
[..]
> Maybe we go with Nhat's idea (CONFIG_ZSMALLOC_SHRINKER defaulting to
> ZSWAP_DEFAULT_ON) for now, and if zswap adds a proactive compact knob
> later we can just kill the shrinker?

Sounds good to me (on the zram side).

