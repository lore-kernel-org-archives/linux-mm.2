Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B79C606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 04:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=no64QQxn
Received: by kanga.kvack.org (Postfix)
	id AF5E26B00EF; Fri, 30 Oct 2026 00:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FC96B05B1; Fri, 30 Oct 2026 00:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947726B05B2; Fri, 30 Oct 2026 00:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D72D6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:14:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6036FA8118
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:14:00 +0000 (UTC)
X-FDA: 85377974640.26.B440461
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 776051C0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 04:13:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=no64QQxn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793333638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cui/fkfgWpCfLIzu0sMbQtqdSWprMFO0xjMUt+zFXCg=;
	b=vZ8p0DtKt7ldikJTRgBuEyHyTZ27GIYCfXUHkO90e/Vqb7HGn9DszekmC9eQU1aMWE/O+P
	EU/67ifTuuT8nNVMH1Zuly3e51l1r7iySNdvdXQNCeEeEfne1OH9fBOtv+G5O9WcEHfI2T
	Go27p7K09fxl+916bGhRi0EP15RuD/Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=no64QQxn;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793333638;
	b=5Vf2KDa10Zid14X3e+EJ9SqniDdCdwbag/gmvOIc9dYKd7mKSvg/Rwn51SzVpHvy7tpCF1
	amHLZx3UPL6yK5IxrhGA5bpQ5VIyIJE7FVUfBdUlsoT6PX2eKFjFvKLCrSpxQl7AhC+YeN
	knxULSQn7Don0L0qL8XVU9paJwyzHaU=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35829219da8so1701662eec.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793333637; x=1793938437; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cui/fkfgWpCfLIzu0sMbQtqdSWprMFO0xjMUt+zFXCg=;
        b=no64QQxnhA9u/Ew06599YzyWvkYO6QBGW1SqGRvmv6WrXv6YqKJvjrXc3FMCq89lxd
         fBobH8am1kjmuWZDfc393Z5EQ6F78MNmamfvH8X7E5uzDdaQcNNyXPHNDLRaTYfQInVb
         mBnuzEPOVbQ2hoorzLfC2q7eMhIeXEaoSK7ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793333637; x=1793938437;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cui/fkfgWpCfLIzu0sMbQtqdSWprMFO0xjMUt+zFXCg=;
        b=UX1W0zaLT2iEh3dBOS6zInCJMbwfqKUsjt2qezUEGDhVGdZWSNW1urRAW1GOdCLejZ
         3uLDGBOSXNZDzIB83qYvYX0goCCPeKDY7Sqdaig991WiuUFAENJL1BpAgPFlKZKwkK25
         l5j/Cg7QGnfJhY7dNYRyDvBJfJsxXBuVVQilS7Ohf3SvEus26yfspyrMPhclVl1xwRbP
         PDmL16h1CrQlz6UQsJT8lKl9Eu0TD5n6uAwRVkurvJPXX0wElejCSf6Gjhl8eYKL8LH6
         5wJZXf3WuGV2tcGuzz/WJ0S+crWuMPylFdUkVSpoOTxd8KOWxG10nAWf7QbCCnsdZZwt
         h0/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzLSpGamKzAJfvUmZvN8rUl8Wu9/C2OSNDwcTZEcSodZ2cvf1FMZnjHmJDIM1zqGersdmNfG25CKA==@kvack.org
X-Gm-Message-State: AFq9FYIwS3HzasM5JlM0nCOUhXjxDgWw72dKkLvVGE6Ekfc9YpB5fkzJ
	70nZ5cjEcSF1OEyB/7SBF53W7R1sGzNT1b7iQZ12Sym8OUloYLXTdsfo5P01LHNgkg==
X-Gm-Gg: AYBFou3OKJ4QVxsspb7w0Hh6jVlaWFZMuq3NaVpyM10D5ikPi2TkDMuefaIAOuf+nAd
	ykIOV5c2LvhOY2S/nh8xvXc4bkzm4UpQDzod758wjWnSUm70OQ2Tm6k1asfYAs5CZyCd5oXdWzz
	J+kdlzXxeKi3P8XyGNAOBkwMv3nIlI+xkla6+5tiUAS7vuZ2cymCyV/sOPKJAnMgZBGfPTdGcr+
	7ptG00QOdlJOvSq241Nd/fgDJr+Tn3klFcnKRchNOaQICs2543qP6rzWSbjB2fkJNEmWxGhHqzS
	nM53dGkLC+JHYnOB10tByMW3AMMF2TR9gmpcwXDns7NMzXK8zRcMARxv+YjSR3NoUHC5kYT/kJO
	PJpMWLDt1WXWNz2XxNjul7TeHPg6GXQxmbzLCdvd7VVcW7OKCBDGZDBW9Nf9pYrdbej/64lTW/O
	12F+vHzp+eI29po6sTPhBkkqLSzW1fuNDDyCjuVcCHYmTY5eUJg1BGgxti9DkVLboDGmUr0JUsb
	uwI7OqMbRVAmDikQYPHVdpgTKHayvBdywDJJIxDE5MtPRL3T1kIfGEmevtJBuDWuf7KkFJrwEPJ
	9Z0vILg+ndrD8FYH8kHxY0lblFCLZKwhzE+SXrW6RFd2CO2bk50WwphBG/q6nDfcgfrnDw==
X-Received: by 2002:a05:7022:eb50:10b0:183:942e:8493 with SMTP id a92af1059eb24-1ac5a67f97bmr1611157c88.11.1793333636971;
        Thu, 29 Oct 2026 21:13:56 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:7476:5b7a:d979:2d91])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac0e738445sm3485807c88.0.2026.10.29.21.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:13:56 -0700 (PDT)
Date: Fri, 30 Oct 2026 13:13:52 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Brian Geffon <bgeffon@google.com>, Barry Song <baohua@kernel.org>, Bo Zhang <zhangbo0325@gmail.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 00/15] zram: redesign zcomp and rework backends
Message-ID: <auQUjtWYOuhf_M8T@google.com>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
 <20261029200205.ee2a4788b8fdba4a75c2edd9@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029200205.ee2a4788b8fdba4a75c2edd9@linux-foundation.org>
X-Rspamd-Queue-Id: 776051C0005
X-Stat-Signature: cs3oma3ddh3rhjqn1zsdim64knhh6zcs
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793333638-553988
X-HE-Meta: U2FsdGVkX18sort0vBzjL6egiSGC0nhKko+kvZjD5C5oji0ZQrtKML2j4LthmRnmoEwW/LrIJhKnwDZv0Gqy+N8le5qPqOL10T2iq8vMLyHQ7VlUy4rtoYPSu111a537pkKsELo8j+CnUQjPNu+nQEuTpMD/oKqUbchbGC2IjnsF5n1dGrLG3MtdBs516obgASljkCKYkjacyyU9SMPcFqsV1UOVDqajrQRVXgVKC/8ZYnd1WGN6XNYMOJUvLlO1wdN2J9jxe8lAuDaM8ryGSPUu+o5VvQ2RolxIzoEgq+fzyB/eI10yCaGV/9OuGcEde5x2MjmFXI17nlH/JxkkLY8O9LUfEosgVPkNkak8Ftbemdz8m9F0ptzMW814sTjIij8j/0BHQaA0nXHryCv1jdklsWJBM4W9KdgN/itJkzZT6VS2IZ/iRw/XQJPIXysioUjbruhPv08VjOGg/Ol4V0GenN4QT/AdYiePrL1PAOoFMJaZMYzRhOntDWODboR+q0TiNNDy23NO3oowA/QGCDsyN9RK4hcJMCCRecfdf/LhrLSB5Jyf12cRPUdCcCuCdeOg2yllRL8lA0u8e+rEwpagTb18HCfQyHxoiYgd8R62Ar0G+laLb+kapx2N3tDgvkVNXf9f6wY7pgslWViSKp+GxHRg53BELmK6q6pMRbjtT+Bbd+88ABCcjjuQyWbH5DfIKmhe+rOF4r9u+Jl/2FtLll7AhxaCBLpRrtMqA/W8nrLEF4rcCLWK/A9muSDcMSiHfQoP/H7Fkb5VjeZAEknHQwRHUXPlAkFkv7e7bKOtYaFWNGNGBHovqf2B5UAfE/jr0+gKUfEEBgdvSyCWLhWf1F/MjG4/cwRgZyU6+t+dJFKEmu/9jjI8WWH18BglO6znIzVpn22GsLl96h9yCc4gmi+vR3CuucSxRmZBSIshbbIjG7ULy3C0cR1v80H1gWE8ghGPihjrcvHKXSr
 iGJgOlIM
 3VI3Y+sLdimoT5E8Mzm8JEL1VlplOATsBf2IF/Wqek0Btea0wtnM/1WqLeME0M/YWqW50G2k/NwnKdPKiu1v58KpyW1DLBZp3s/1YdGqJAKjvhd3YuJtyagDtGJgFUeBjaWW1S+yrodBHz8iBxwfiTYvG7+jTV8l9Srito1ZQHEe0MpfnW8FTp6jN/OzU2rgdufEcOLTCDOvQfoJZCboD0kn5wKI+l4Fu8S/RrnM69A7uPXa76n9sCAgEDuBfPl9V0uc1royLhLVm65460XxYKwZ1whQqwXy3+ew91hn3O04QanC5N4OE/TIeM+7rdnD1HpGI5j7n/MMK1FVk5nr+LMIESQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/10/29 20:02), Andrew Morton wrote:
> On Sun, 25 Oct 2026 11:18:16 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > The series has a number of memory usage optimisations and fixes
> > that result in savings from double digits KB to triple digits
> > KB per-context/per-CPU, depending on backend and its configuration.
> > More details are in the corresponding commit messages.
> 
> Thanks, I'll queue this.
> 
> >  drivers/block/zram/backend_842.c     |   6 +-
> >  drivers/block/zram/backend_deflate.c |  98 +++++----
> >  drivers/block/zram/backend_lz4.c     |  85 ++------
> >  drivers/block/zram/backend_lz4hc.c   | 105 ++++------
> >  drivers/block/zram/backend_lzo.c     |   6 +-
> >  drivers/block/zram/backend_lzorle.c  |   6 +-
> >  drivers/block/zram/backend_zstd.c    | 133 +++++++-----
> >  drivers/block/zram/zcomp.c           | 298 +++++++++++++++++++++++----
> >  drivers/block/zram/zcomp.h           |  53 ++++-
> >  drivers/block/zram/zram_drv.c        |  71 ++++---
> >  10 files changed, 546 insertions(+), 315 deletions(-)
> 
> I've always put zram material into mm.git's mm-unstable/mm-stable branch. 
> Because "ram", I guess.
>
> But it's a blockdev, so I'll henceforth carry it in mm.git's
> mm-nonmm-unstable/mm-nonmm-stable branches.

Thank you very much, sir.

