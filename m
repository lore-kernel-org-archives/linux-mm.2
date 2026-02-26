Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21864FD8FD3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CEA6B012C; Thu, 26 Feb 2026 11:21:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803986B0154; Thu, 26 Feb 2026 11:21:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7068B6B0155; Thu, 26 Feb 2026 11:21:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF626B012C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:21:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 259761602CC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:21:35 +0000 (UTC)
X-FDA: 84487123350.27.99C135C
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 23A0FA000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:21:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RNnXl9ii;
	spf=pass (imf15.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772122893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i6OR9L/2JEII0FDOqkHjM/vIFngVooiK7atGXQPLJ0=;
	b=2eBZPprdpYfdlF9zJDGqB9ycwJIN0tqLJLwPo8r6WA70Ui6L+K3DEvsOGnXIco83LGpear
	1RRGjV/azd1Pm4YsE80UsuqWXkDL4U1Wns5jIgvgwl58Y96KaeNayA7amB+AXJttymsf85
	+nV85RjJyuITcPnjM/EtSjb3+Mvt+aE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RNnXl9ii;
	spf=pass (imf15.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772122893; a=rsa-sha256;
	cv=none;
	b=larQx565kX7iyZdDyWLVyknhbMFW6oXMVdbWMJlBNd7EB3xi94Hof6mIad7FnZ7DHLYgrt
	N5h1L2PtSBSsOZfReDzIGSw84dby97b6xBzyrwSPM39yiqiaocB0vcLv6hUu2/3pyZtMeH
	ovF9ksNNGD+lVNwFbAjJiegQN4xP6eE=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-389fa352b0eso6652251fa.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772122891; x=1772727691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9i6OR9L/2JEII0FDOqkHjM/vIFngVooiK7atGXQPLJ0=;
        b=RNnXl9iigPuVAsuNQGxjylLRWJqjdDWBbGLiNXUHNqalxGLcj2Vo6/IZBCnYpuMEgJ
         1KeNZTzhb4onO6ZXW8CmlagM3JSntaf9id6PLIZNI0wBUfaJMKm9x7i6kZiIP50dGuvk
         iGlEBhdkuI4RAmCjglGPdt1F5BteU2d0upVW7G32qRip16WYX05KZ4BdeDSzcDOfhxbS
         qLhq6JtH47T28uIPoG8EYt1yAdBqkPADHMlxoDzvSO9VhJfVZD6+DM2+2xcw7Yc5rkl8
         bunJ4MKTPOx4fWMIJkrYJfBriJlOze//4xVmlppPjwnCaiVuB28e+IlWmR/HiDY5TTYr
         ABDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772122891; x=1772727691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9i6OR9L/2JEII0FDOqkHjM/vIFngVooiK7atGXQPLJ0=;
        b=IABY+4jDl6jgj39NrRYKSTngVu7x0BjamBtwpxm48ffb6oUKvhcsPni70RoBlRzwsc
         NsH9ZvkvvFONo5GleuPu8YfXP9jRIG7c8wS+NH8KOrJ/hOyv84XuGvtKxrS7jKEFmnoA
         jTv6OKFRVeLFrTuCv+RqLaZsoLLzg1KKAAsb2bg5y/1Id6K7EO1LX0OWI5MwbDVY6VHL
         gN+kseuXOhis7Yff6OaIAhy/Dq8FMA5YfCe85paQI+SFYiVcPm4eN1fkv4JY/aiHWCOH
         r85S+/leuavNY1TQwGxsmXKpscvXMcAx4UHpg7rzImDUW3m/NlbtCGdUefg4TIwhHNo2
         JFXw==
X-Forwarded-Encrypted: i=1; AJvYcCVtQ3pFsR32imFfO3XWqsakR4AEIIaMRIDVbtqyiKfPSRVXdmWQlVIE3fNYPW71a/R0iCthCw5PpQ==@kvack.org
X-Gm-Message-State: AOJu0YxfUHSCzOA3N4Jj46y8EM3WIBMao31HI+I8RnZr2bxAXQp0NFL0
	yiqUMJbdsTLWnO0ESc/YX9OL8n8sADjiNarLsVW1+M7PyPjqaqFSScDY
X-Gm-Gg: ATEYQzwZyPbtOI63JxXdUeGjs7qigPSK3UYCRvQbFPOG7hKdwfp3m8Pir7PqZuDbI9D
	6KkEP19nxc5YZndopiSW40SjilDNSe27bHSf89/pDvYtc9X5sadErUHHmAieittD8P6eZx3r7AR
	tQFC+uzIfMIEFfvGtbQgVQpY3WpjfK++I2T1wAGN7lMzeVfNAL0meze+MFbOS09PAJgU66r/rUk
	CtvT7lfuKskuGAXom3dUVWwnT+KCPMQVlgQse3nqqj72ur0pkHhApnGTE3ZpFxLLa1pwfrzHYwv
	JhWVqwDGIDZLg2h9IyE+6DJzBrk3dbAqX7uOBPMcimneW+46CCYb+xUg8YPxE0YMM938Kqxzzyr
	jHwTVeBilIpJNY3tpPUI1m65J21Dp6qhngOtV063I11zhfk/zdpfipw+yXZ0bq2eUXV+Gft3Uc1
	WM3yi6F4UgHWkn7i7b+qmiuBSYQGuNh8AuYQ==
X-Received: by 2002:a05:651c:4210:b0:388:3d86:473 with SMTP id 38308e7fff4ca-389f2f55ee1mr7937691fa.9.1772122890871;
        Thu, 26 Feb 2026 08:21:30 -0800 (PST)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-389f2f4b356sm7855121fa.2.2026.02.26.08.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 08:21:26 -0800 (PST)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: harry.yoo@oracle.com
Cc: chris.bainbridge@gmail.com,
	vbabka@suse.cz,
	surenb@google.com,
	dsterba@suse.cz,
	hao.li@linux.dev,
	leitao@debian.org,
	Liam.Howlett@oracle.com,
	zhao1.liu@intel.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org,
	regressions@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Subject: Re: [REGRESSION] kswapd0: page allocation failure (bisected to "slab: add sheaves to most caches")
Date: Thu, 26 Feb 2026 21:20:52 +0500
Message-ID: <20260226162052.36121-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZ5aAlDDpUoZxx_g@hyeyoo>
References: <aZ5aAlDDpUoZxx_g@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m9wrw1azf5g3djjsetggk1ygx9jszmsd
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A0FA000A
X-HE-Tag: 1772122892-278460
X-HE-Meta: U2FsdGVkX1+qh2KrRb7IusrxksxAmyiqp3HhOhts0Bw+19pCUeG+qNfzmr2YqJ3xI529/Ysj15GOol8LIRgIE8obyLqBZPLrv6+04u2CNZahTyp4RkvtzkRffSEQXLXX0rxI4NizegPtn612GBzpY/mVmnZL5SV6ljQvCJ4FsU7S0e6UHLVwVdqBA0voQ+llsd/yoaXJbnUVGdgWmVJduHCRR8JryMruU/Nsr/T1oy6wPMZPCvRTREAcwIHi9IX84A0Nyrv6uupv6aK9iOFl1RU3kolYLNmHioFUPFatIJ84gtkR6mGlRbX/IuO60r26XRDJb2CxBJpC4zHS3LVx/y3+WstZQktd2iBrZrdWen6hXiD23mcL/PAxGS/e++2TNqqDkDZ5MH+S4FKmK5q9keL0v52moeiClqIdZs7Q+hjMl4lA31o9e29tEqzUwVEwEopP591jR5SBLnU7qsB0lxpv5pkOtInTlETxHSFKLJ+zHcPHln8cT31GeuEW0dDamTApl9ZPFKd9Ma15oDZEQBKR6KUaUWOTffzu9q+QJH2xPORlRpu6LvYNi4TZ6rJzMKO0mSyTo2kmzidOPifK7x7WpzCdvu3sgSMTdy1KMSNVnBd2v1fmdZK4/HIJoxEpuVKOV7YsJFDdYcglhdUoImpK3D2kIBZbmV7jTOlAr0DtDSmNTjeim2hyPkoYdOOwyXhSrFyJPEK8Q8eW9aMEv7qglBXFNqsvSYOXPG0CRve2tQHaC3o2Zzr+gm8v7vLM6HU0Mjt5p+5SojHZx+ql1TfeJIhv5T950qwLdUAN/ZwH44wNwvsb/q9vDibn1CCW4SgpqVXj/d2nCfv1jcDenCGXq6IB2i7FnrH3m5WmNtH1vF95Si0sR4iy1Dtc6q1oYNTYwJDE0YPKe++GkXqpYz/mfoKltXhFh3nlIGwa+VPCR0g5Lz+nWPXM5JT4oLNpN6LT9O9F+KefO9Dtict
 m9zx2KM0
 UBjuaTEuL9KpEaOfOXZmjaMYAZonAkj1YXO9luIc3B+b5i3/GOKlBN+TPjZvX8Evxrs1/bhONjFTO8mck2L+4kbq8YUNq1Z0jfRUQXEXPi4YbN752zfPlpdqigdQOzLZpyiAXLQkee5dzH9F4luzs1+9fEEMnv6C+O+hse8ZaJbXy2LxxfOrz+M9Z4Ygi3f+tOpMe5bDUuc+6VYmXSKEBSaYNnslsolnpuW5BPolZWo3kXASC8YG8MoHPrXCK8NFAUwoMm+V75LTQlZ2FQj0Qot2ECfVQpkjr7YivYTLMxZ1048+n9KGNLkOEpg0zVv8fIsKU2acQM4pT2NMUDL88GF00R7y/JYuu6b+pQjcfQgGtFHAUjDtiyPMnn/+ZSXt5czGWTdiBxeqizc22ArDwOBATeS3Fx0H2hn8hG1vd7rT8v3gQetwza3wUlX7VU3F4fyk8gepPipfQvDEAxw67VWFVql0Kks00gmZS0WHDxh5bjo/KzbAvPFUkIDc7md86lCD6MruwKfoon4ecHoBD4au+yK2EUI9WVoNZqmNfNoeKwf3bNETOwIKOcErOatGvj+ek1wC/xOVqP2d8fTYnvwvadCjtVNVeOX3gOD6ovMx1oEGceY6dAd+vl52a7PkODVeeYfkHVi0w/jmiivsAcYKGTipVsCOokYEw+JWq2eAy8LIpuZaWjumpHVcitZZfVR+WwFSMbpkYJ0MijqOAUnk5Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026, Harry Yoo <harry.yoo@oracle.com> wrote:
> Slab fix is submitted here, please feel free to test:
>
> https://lore.kernel.org/linux-mm/20260223133322.16705-1-harry.yoo@oracle.com

No page allocation failures after 33 hours of uptime under normal
desktop workload with memory pressure (64GB RAM, btrfs + zram swap,
Chrome with many tabs, AMD GPU).

Previously without this patch, I was seeing failures from both
kswapd0/btrfs and chrome/amdgpu callers within 10 hours.

  Kernel: 7.0.0-rc1 (commit 7dff99b35460 + this patch)
  Hardware: ASUS ROG STRIX B650E-I, AMD Ryzen, 64GB RAM

Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

