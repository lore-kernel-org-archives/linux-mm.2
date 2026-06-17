Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C587CCD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73906B0005; Wed, 17 Jun 2026 09:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B8D6B008C; Wed, 17 Jun 2026 09:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 960B26B0092; Wed, 17 Jun 2026 09:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA126B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:16:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E26191C1F9B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:16:55 +0000 (UTC)
X-FDA: 84889454790.27.9E0F6E2
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id E69761C0007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:16:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q70hf4ek;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781702214;
	b=y0VNfA+RQLb0EIvWlfAyHu0nGnYzKlWFUk854ETuHLB0RmOAJQTKbBxe6y0cvswkweDA5i
	sucY2+Y4nuvmTGf9vEM4iRuJnI7o0pAz7qkknPcRR2uiSwlVsbL/kdWqMPilenOf1LqQTA
	oL3NCNMVkCNcfXqNGnCA+9VR6WG0V3c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q70hf4ek;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pPCU6nCdJvVHJbZRjEnMddaR/VZZZQcrWepUMo+BZw=;
	b=bvRMR732zyS4RrW3rXEPORpzWoiR+kxKliDjkHxMftJJyQkBxW0jMHfJKzqhAb+pFXbC1F
	nGy5IEaKr3V0jtEjOtWby0sAqOui23EcVcOoUv09Xg891g7ZSK1tnp2sptnnJ9iGduotj7
	Oos08X2ZCIznhJ2UeQglZWkTD7kjRVc=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4923139e940so11264095e9.3
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 06:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781702212; x=1782307012; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pPCU6nCdJvVHJbZRjEnMddaR/VZZZQcrWepUMo+BZw=;
        b=Q70hf4ekV/P/GUqV5MuqiiGw/j9/N3qWI4b5UUfpTt2zBhoD/EVKfIKNDrGou54oCv
         uFNB2wtHQVoes5SM9fg17U7OXYvjJs5Q/k4Ghcf8l81HIhHTCHG5JmnJhG1BnF758med
         Fl124SQ1Xn0kQsxnwBWRRk9jmghzCi/yMCCbC14vBV3zpGNU55dXxHiQZhi39tgGqk7a
         /kjYoAoXIqaxDmlVLwUNWVEx/TpiLLDv2VZQ+eU6sCPYte0lK9VOWtBzQ/ba+PD6C6ej
         M9WfRlVjSHbqi+dAzaC4s4rs8vHIsVRX7NBh5e9WcA+OMXUenmYL8PH5e1xHWd7GbwrS
         ynPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702212; x=1782307012;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3pPCU6nCdJvVHJbZRjEnMddaR/VZZZQcrWepUMo+BZw=;
        b=H14TnEsffTu5y65gIDWHiNn6uZ6afyTPTW6tJ1X+AJy8gvI99tHh02yU8+R6FFxJ5g
         PSl5ASkKo3Wyp81zDc43ILBWZz4hdQTmqJIXdodBO7ruyIJ7XfVh86z/KeklrV7ZRtx6
         apGzZXK4QCpn/sdRIe5bKp12san7jOYE9B3pgmVEPNCjo6u4TcVjjy8qpw0cboPukBgN
         mWYETB4aDTLp8ZT+gNrdy7DfZzaUjIJZ+JgHL7FWVlZ7RnnXAZQvPx9BsSUc/VmumJVw
         zxcB+dmtSJGURbhxIoWZARJV/raLE7n+6dl7eh9T/qjRKtOT3ZiRAcHtuw3XgvwabbT8
         fOmQ==
X-Forwarded-Encrypted: i=1; AFNElJ+vX+7mDctfTWZx7AijqClI3KdH5qu6tZexU90qBwLZB0R0TJlqkk8mZhik5WAPhumsWOIBb2y9vg==@kvack.org
X-Gm-Message-State: AOJu0Yyty9aoppIe60LqFHyHJC5q+wPyVoPsknhyC7Smc6HR+3fjwC0Q
	0sOBR9fvsj1inGLZwHQK40vuUsSWGC+pVXPQK1A4SNalF8KgdWI1YTb0oLYkasBm6j4=
X-Gm-Gg: Acq92OG5zDd5kvd/ECvtGoow65/PQ7GhDV6QOZUsTNK+nHuX/Z0beWBHgmihoQnnxd0
	SHC445Q5HVS4Pyj/hraAfSEjnxvilthZkxadhHc3laTlD74MzdxdqM8tsRwJYfufxBpcfIPp/vi
	ihfeq/qIsLrcjv2kvgZFBUeHXkMbsEe4B8MjnjEA/hojY9gJlcmZITsyhPpG0DC2yU3dHfwiMkP
	/jJpC44UMyIuL6XRBjcbjEiwiL+sOXrK1lcuMTkL9+M3K6sJOudXE07HCeS81seanvpFNOGRlok
	EmlFJ6sP2VwhhrkvfGhn1Izy+njIV/5k2xgJoYyPMh33CNVnUYhOdCsDcIX0yo2RQ3wjYJ68a57
	XPPBWK0zZLLDQpUCKRuCc0gxgnCKKYhGAydC3C9CTk49cZSIg4z0ptx1D+aseEEbPfUiYb4/TeL
	ttWvVo51At5BqqyJnJWM9C7t4=
X-Received: by 2002:a05:600c:4f93:b0:490:bb3e:30b0 with SMTP id 5b1f17b1804b1-492340feb65mr46215015e9.4.1781702212016;
        Wed, 17 Jun 2026 06:16:52 -0700 (PDT)
Received: from localhost (109-81-90-71.rct.o2.cz. [109.81.90.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa891acsm164250535e9.9.2026.06.17.06.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 06:16:51 -0700 (PDT)
Date: Wed, 17 Jun 2026 15:16:50 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 3/3] mm/percpu: Avoid IO/FS reclaim in backing
 allocations
Message-ID: <ajKeQhvsPwjjVLEx@tiehlicka>
References: <20260612022648.13008-1-kaitao.cheng@linux.dev>
 <20260612022648.13008-4-kaitao.cheng@linux.dev>
 <ajJETfcD2XzzpR8w@palisades.local>
 <def64c45-bbe0-426a-bba1-9ac9e4db672d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def64c45-bbe0-426a-bba1-9ac9e4db672d@linux.dev>
X-Rspamd-Queue-Id: E69761C0007
X-Stat-Signature: xfspxa6furopthnywxpichk5s3jp1ci4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781702213-925063
X-HE-Meta: U2FsdGVkX1+dC8CXUoZ3N5vgDCAJ0RA+uqYEyX15bYRmdPo45ctQFWewwVckDMpra86hQGOjbDPzmulGOYL3Ww7nkWWzDu88+9fprZB72Iy7CdCmJ/+udqz/7f5sjMty9FRgW9C+bOb+JTDtbcmUdQ5mXh2BAOhunxE27GEUUrakxBi8DspEjHYJxF9bcczvqBlvJNJ7qdmsh01X+tFHYvbsYzHt2Cd8C0BREOKN/4KLKAVlLSNCb6yuSeWYh8zqgrwD5Z8sNOVnKIW7B9qx7WHi39jnAtCsPmbIgyYqRIwgO8pGJ8/JFapKt75TkPAkT86JnDnvuiXkLoTwk3PsNpHiputabdH7sbXI+9fQGw2V+QLcePlXwsNt2VEvICWq2ljoEb34k3UapOtMLLRwRiMhU54FmbKKQvyXHmV7PJ/XS5ieVseiGqS3p8f3w7PZcJtNyu92zG5Hp5kTNfhENAboKUBs6g84fE0ZIf+m87LkUiNP2r6iBdHpdKtaNGuJLD3VtQIs1Q2amGcZx5ymJCglARBItp7xCO0DF9Fap29M2gyEOV9kUx75/1aqwMHGG8DYbSDx+6cw0nvJy8njrk/xTQne0ipsklIGlCuxvCGP/k3X7jF33vpNN21InS3sJ6znv+OCRNVT1nNTxYE7qYDgKWhj2SLBnnEUzWR93wotLwySDRpnUL3A2eFQx4pRbYzvQWCDmCdabAv9v3BEdHZI+Za0lrXgkLVI93gQj/jX6ajh8BcO4YzXZ7JMSkcGs5f2ZAx9rhxhz4CpAUBaPW3IdYFHD5AnYo2kgHy2zbpcXcD4eJMehIcZtwE0Wx0CtGMwcy3eqLFX4nikL5oKzLWqQ8eE+kYXNUpgiVTGV7A4A1T1B2L0buafZs+Wfqng5eGvzQq9TvREStcZJS2bBL+XfXMUJoWcNCbAWHmCvMS6SChSTb1GimKx0yf831LxJ1UipVuxbhxtvvjBlM1
 PrxKW5Bs
 Z9xQXEwLH+BE4ESYSDMe6lqAFVOge0H/GEcdlvV9dkJjpuiGzjffu8muhIQO551q2U9lzNoeKWdAj1WB3XzhytstndC5KPdP1gNgCb05rir84ntfNB/SFhCcswJ/5wvSqxB+y1/O5GkVMp5dveO/xmO1PZi4B0MHiunUrC4V2DPP0CNy8brXdjGyQZS32ST5jvsBApNysdEqRAbzkVvnjQvM+YIceZn9dnNSmeuCa3m7EjEyPdrlgFUnndTiylh+ZPbhx7J2NVV5tIjEmEdsa4XdO0XfbjN1kK86fTDMsNrTFBOOOht0G/z8wmVdwc8cnvTYSBjrAn48GwnB0K8hzLf8okUV41aCwBoAn3GQ0rzw9dS/lgADJCFirHJfgjtau5L0e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 17-06-26 16:56:56, Kaitao Cheng wrote:
[...]
> __GFP_NOFAIL is actually unnecessary here. The main reason is that,
> for now, I have not found any in-kernel callers that pass __GFP_NOFAIL
> to pcpu_alloc_noprof() or its wrapper functions. The reason I added
> __GFP_NOFAIL was to address the issue reported by sashiko, and I
> provided a detailed clarification in the link below.
> 
> https://lore.kernel.org/all/3de3a89b-92f0-4cd2-9f41-8e853eae4e78@linux.dev/
> 
> We should probably revert the current patch back to the v2 version,
> and then add some comments explaining why pcpu_alloc_noprof() must
> not be passed the __GFP_NOFAIL flag, as suggested by Andrew Morton.

Do not add support for nofail semantic until there is a clear demand for
it. Supporting this semantic is a big commitment and it shouldn't be
done without a very good usecase in mind.

-- 
Michal Hocko
SUSE Labs

