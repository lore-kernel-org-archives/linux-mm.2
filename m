Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C72C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA1F6B009B; Mon, 24 Aug 2026 16:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B946B009D; Mon, 24 Aug 2026 16:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0E46B009F; Mon, 24 Aug 2026 16:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589D16B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:19:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D41F81A025B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:19:45 +0000 (UTC)
X-FDA: 85137278730.17.B799581
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 229854000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:19:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GCF1qXsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787602784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDQCrhRKJv1CgmBzHk5DV2Zi2hk1jJel0LnyJEuda+g=;
	b=YmdaaA4jZjWCOEjX95o0sJY/vTC5ZBCRrQ8a62cx2hbSkk0ys8NYszbm6sRc/3IBG2QNI7
	b3Puy2SOENxl9irix5LEcwZuX/1kDtN3y/q9zXDuH9laEgVFhobEXShnm6nE+I5uHODZyN
	L2DdhSgepty6XOy9TrLOdglws6FJthA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GCF1qXsl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of maxi.saparov@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=maxi.saparov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787602784;
	b=qOg4nWW66P3RF6+mTBfCzjb/EQB7WXKRT0wq+jl8Z2UbBxlAFcUVEZt9syHp/N8/s6aREK
	DEpPZARD+5olMW5c/RUXdiNhDXE1ltWRCTTQzQgyRUMSEDeEW46gJQ3mR+5oEax7St5Cxx
	qTOlcqOJlaojHqcXJ5A+/lTSrJCObP8=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-52b3934af3fso43437411cf.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787602783; x=1788207583; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dDQCrhRKJv1CgmBzHk5DV2Zi2hk1jJel0LnyJEuda+g=;
        b=GCF1qXslxroI8WjHzyIbEHEmF2t05bPDcX4WzMFX/Hf9P6hnqjUoDZorLtcmvOX06Q
         jW6PMnTREg61iEiBLIVnQmfnGQ16A5nzucrAIyQbOMOuny1l6GZ0m3FHizcWARQepWDf
         4kCMvt+NXkRcvvBMl6yA1OnK6HAJIKV4uTe3J455cOySzwYhm7+sh+AtR5p8W2Onsn+c
         tbxapgy4ZOKYrIkUl4rnSv3AO9EmnOYXbhMDdNXg6fTs1AGf9SCiQsKjNEEMxz5aXghj
         0vuo+PJ7110y8ChR6BlzNQo1s8cb2Yo7Yd0IgcYEhF3w38PoJo468R6ozDFxhbTbVP43
         eNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787602783; x=1788207583;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dDQCrhRKJv1CgmBzHk5DV2Zi2hk1jJel0LnyJEuda+g=;
        b=J6zs8YE6BS9TPKs1YaCHkUTKPggeV0idmO3Vrbgg+IIMTNOC8a1tkZPAHrWaKUg2Oy
         iojT8Lf7vpjxSTZC4slUafW6KPSk1bpu+DiCgU8HXCOAadnUp5aoPe88y6BcDxYM3eWH
         QLM6Q6Nm1B4YvjVF0TtCDgRIR2mhjDY3+Ylk3To1rgaNao0oXVvA1IpBr1ll/DCypq5p
         R5C0ZvNet7Jofyzysj/DBDdjcPQge9U02vaaZxttAhetNkj/0tiMZUYdnBVpEJULIfdH
         FwiRwHLcji/dTk690Xf8GQXa0QbQ+MlKt5T3m984nnGJa1b2K4/Onisn4OBYG8pP7buQ
         IU2Q==
X-Forwarded-Encrypted: i=1; AHgh+RoXs32SqtfKH5l+vyaT0eM/4dJWDcavNlNpBp7n+dnyQWHCZKwRdqLDxVMVUAVL2iDgydGcGEi+Gg==@kvack.org
X-Gm-Message-State: AFuF++lSdWWqd+Qkmqoab5XAIFwQ1mdLdKyO8xldUyZiX4pEym2M6als
	UYiYxw7C33XWnICx4KryOUIoXFh/Cak25amtqoKz/5fR8GuuXVQCGyj5
X-Gm-Gg: AR+sD138JwXbHpAlBu+8MimL4g2gthHH+JwTwnyWs2L1K7cEWOSqSnmWq0dFEn0wzpS
	RPjIcBgM3berCGoNJ3+JPc2H2LDrf32qiQy85Bsn77N79+6SoVSU8tihJMVRxTux2QiFYtt1i8O
	KILyrAr/vk+dsKzNuQ5rykF94Qyk1HSGbJBxXwm26NZUHV1AOCpiz4tocKT9FHH8BPBSV/prDhI
	TRZNmz5Vi0vIyz5VJNuyG5RXn0m+MD+EimhEtUV0m07vBtsZFBHWCdLmi6DV8HXMYqG6E2gWLJp
	0aocDYSRae/FxQplsAtUfdADum3JjedkxUc1TW/Ki2XCQOhE0vdOVc/TR3XY0M7y46ceTJLMK47
	xWvOIbqgQCfXqW+JJVpRiRpLfmpaJOYpid8a+BDteGPoX3r87WhJC1DVxt4vOcc+mt0kcisyrHX
	btviJtq9rKNgYzDugiAec2PEn6uK9SgHI00Nl7oqBEuz4j54Hmt5sw/2QYW+8P5q6ALtj+BJw+P
	bJdRkVqFSiWYIXWAjasYSg=
X-Received: by 2002:a05:622a:1f97:b0:51b:fd82:22dd with SMTP id d75a77b69052e-52e2f092d74mr19871991cf.15.1787602783060;
        Mon, 24 Aug 2026 13:19:43 -0700 (PDT)
Received: from CW-D0XG2Q16P7-L ([2600:4041:5d54:8900:65b6:6c48:5883:571b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c939332c0sm69720456d6.28.2026.08.24.13.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:19:42 -0700 (PDT)
Date: Mon, 24 Aug 2026 16:19:34 -0400
From: Maxi Saparov <maxi.saparov@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, sdimitropoulos@coreweave.com, 
	Maxi Saparov <masaparov@coreweave.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] kho: do not reserve scratch memory in the kdump kernel
Message-ID: <aoylgHzZKP8av1pN@CW-D0XG2Q16P7-L>
References: <20260803193938.8778-1-maxi.saparov@gmail.com>
 <20260811161857.3096-1-maxi.saparov@gmail.com>
 <aoF8zPXiKpjt2Nsv@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoF8zPXiKpjt2Nsv@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 229854000B
X-Rspamd-Server: rspam07
X-Stat-Signature: t47y34q8zf917w5p1iqwn8973ph81uoc
X-HE-Tag: 1787602783-194096
X-HE-Meta: U2FsdGVkX1/jE9fnpT7/4ScNZrQr2rAMYZJ46aJll+UCUqS1oOphWsePu9F/+BPsg4dxLe97L2yORes1VF3ndUmCSoMxPbickJSafNu4Y0vbDR2HcSQ/AL0GZA5af7+Cypl/M+KpCJifNoRI6cJg82dNBFGWVLCA4/lWAuT10DNOALlL8jMQI+2XwQKO+HFf51atsRtOlEYFX9haTppmjKjclDapRJlQiyfw6IdFwbkMQLZPzFm/SAU7dhMfTDiyafzOYViU/xbLmcPb2AVG7ZanrbYN5LdEzbH1mndtgTAqHBVcSqYkcHGz3GxxbDcOxnXQsW2CZ4TKDnGIT//hEgJL4oD/fZWFqYImSGeMUsUa3atdlN/pEcEiTEqo8o/4YqeCp+CVIsN4KEOsK0dkrBVo88ePeLg9mbS48BxEIRlo6rbpsgUcTFyRNUWqMyrHaF5tTSIxo6Xvp0b497gEFWnK4gEoBmY7Qw6qTmtYiQXfZ5BbdESdiFIKxOAXjuQbb8PumlZFCp6L8FNoV/kZI1BwmewQu1+m4/HAC067QBi+S0RYNfjQu9pQMwJlJS9ffxmVnuABW54FPja5fP7NH/cdVucMMzRVOQb75KZWUiNEFPxdE7NBcN9WZhq5IpPc5JP7F3/bW3OWuAzvJEPb22pDlTHkO3RqUYq0IfV8RZTvUKiWp+lQv78iSCU3t9zuz1dtvM8C0zLChjqFlepS01g12UroE1Bw6HIAst4VSPfR8ESlrzWRPa/NLispZSMSKcsDSpX9RH4q0xq7FITwyPL+38XzhA6dQwSvYktgsWfQn8prXudV5Bd/s/VSbMKNaPVrDCGaUDQxbvxD+v82ER7ZURsuiny3VzSihfFXMTWaqRTuMrYvQ3T1WPwbBW9jUvsTK3rzWUIkD27LSFkDm+q9SsIKUiP5dOV3t0nvaA9HTP/NaEcUkL+cateKIWaiePIyRhtZhp6ZPWcXXI+
 hV/7MHm3
 XfQGDyDdg5tw3v2TM0ynlkInm/wb4NoZqSyhczzZ+gN2RFVeQR6Z6YsDtMqtXXv+LlzrfRx/B3d6IsX5s6M6IVofxHI8ix5ag4/aD7E+Es9nbxCe7t/O5+MDQDtXy5qizw3ydg745KEWAsZj/De2MLe+h+ywGh+cXIcxPBfIpxMFwVNTgzyce+BB2rZLv25AclpwODZeGQOeIc72Lg2NaHg4TcjstgIE+pjbeVbWLjdcdgXUJIGqnSyh5N2sYMZ4Hz9kTsQEJjzx6/8KLk0OW51hVNoBYm8J3k8uECV/oetvah7JwsVL2uIXLnszchMDP4IgulnxmVMdbH9xcxWU0GhxgbJIYk52gPGjDwUyOdhLY6w2x5R29RE5Lg/jrx6lDFzGCap8cf4qZFC54r+g7Ory5b4JV1gYJbP0YJ0Vkvm938jhgVfNJ9iS6A2s7vVwgR/bcufDWyANiMDuRZag00GJcHrMKq1tf5aPqbwA3CHGLaJNhMW9F1ZaKNo4X5DOmXv6nXN5zZuXLVMDiMWhkifgn/4U380kIsz7p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Aug 16, 2026 at 12:03:08PM -0500, Mike Rapoport wrote:
> Hi,
> 
> Please don't send vN+1 as a reply to vN next time.
> 

Ack, sorry about that! Thank you for the review.

Maxi

