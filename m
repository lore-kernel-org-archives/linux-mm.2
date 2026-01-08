Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29002D14887
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 01:17:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA606B0005; Wed,  7 Jan 2026 20:17:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658316B0088; Wed,  7 Jan 2026 20:17:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58E306B0093; Wed,  7 Jan 2026 20:17:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46BDA6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:17:50 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6A1113B603
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:17:49 +0000 (UTC)
X-FDA: 84307034658.27.D13E588
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 357A38000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:17:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="N7dyJaI/";
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767835068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+G/kn4RVfJsb6z80XJti1wtBnZoS4lSo01oUAVCvB4=;
	b=nojSK0y2bVQ8z88EmON3LpjUGMeHTWAE0TjkeKbCFyWgTtxW/r+RtQgenHhNyXcp/+2m07
	JvPvQpoHuT0s2wUU8vkJyCvFkshgOu3cvbzDjzoz8tdYDywUt4NpP09kbIlMDTC2War/R5
	0HAswcRI2FcG4Aw4IbPP0pzC5tukReA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="N7dyJaI/";
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767835068; a=rsa-sha256;
	cv=none;
	b=VOg0Om68G4IhSj7Xsyr0sjCOeZ9di3WpaemzZntUmEDNwz/h2F77v0E3+Zoks9d2ClheTc
	6sks+WAjoMaidQ3fMJ4CgUy+ib0/o4PLeAGJum7A2PvKTN5Al1cHTLeHEfdh3vW+aSK2Ax
	KVsyt0WePUVCcU0NJ/Ym4Qh9pd0lEgY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a09d981507so11691975ad.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 17:17:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767835067; x=1768439867; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/+G/kn4RVfJsb6z80XJti1wtBnZoS4lSo01oUAVCvB4=;
        b=N7dyJaI/Kf9eDs8+7b9KiIOwGELOCawU99HWYorFNMJATYcU49PDEf3DZ5lHg9zhht
         ulk2qvP50AWEDEpnP/YrFWCpdSKoj65mGASzlDcYeVmQ3nX+tnAshzPMOtvAdWTX+SxG
         WLPW1HszpoEzPXCHwd54ERvaz6PwKktwKIB5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767835067; x=1768439867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/+G/kn4RVfJsb6z80XJti1wtBnZoS4lSo01oUAVCvB4=;
        b=VSY0VvRHmWcVbq9dhCD3imVHbL4Gm941vLNzSY1c14NWDGeBfss2EPdH1eeYeWc9LW
         hogY5TchDp8gWgHMNMAkLgGo8uiH0ecFVm0dWSm/2ai+sO7I8zJbuzKYg9VoFSE7o62K
         FUQOc/TP3HMcgZPuOtFWzFAMXzyv26oVDLuPxDOh22rue/+T/PLT46OZ0JBrdv/ZzvUo
         /7Dqizt5U3dkGvM9Wdqqp+Exxw/iF2Hdjl8TixwOXs8gRPX9xRDN+veX5ikWUvpPyQZR
         lDqUyv+vTfReiLCrpEv+dPaaIpfIyWiw9ABBw0qwrwBHlw5h8u6JdzU3bYV+6h9HPBcv
         wwrw==
X-Forwarded-Encrypted: i=1; AJvYcCXqih0ITuD+tGOxc+2BxE0nqPha0Cg9UWkTKG2mUevfNgcKlk7Y6CDjdlEx0BHK+yXTjGOA4GQz7Q==@kvack.org
X-Gm-Message-State: AOJu0Yz6vhzwUvBa8jcIDmyyNeOGAcnPH6a8AdNHwhtFYkYJ1+hETQto
	qS8OQ+aH2H1j/4IfiPxbn9PiLPzc3IEdv/d/TuY2vWeceE8rqAjq2oAW709TTLxC6w==
X-Gm-Gg: AY/fxX7qx7iLzdHN0uBKb65etIQ4Y8nZlJ3/u0raxhDAKbSH82hxCa4GXGLq14wgcId
	BtdKpYLruI5zIN7TBo3QERgy89nYHulYcoUC/br4iAI0c4nxRJXHOWxJVKeHpPeV/CQ6eky0eS+
	DfV2RsaSZYZXU+zeVUfvTx+GAdhkWZd5oTtg6dfs9wAesXcTKHsjbtQVyFhHmx2TJa7912LJpPv
	+tYPU7uYo4tukFFwIVZHKYBIVFdeuAZC5JmVVZ4y5b2Ewtf/D7w1QNBKDZtAGYN+mev83sac0xz
	SVGHttgnUCsEdoXM73Du0iWDAC3IWK5pDangzraNO2kmSxd+3H2lIPf7BxbB2raRb4MZu25rRe7
	VP3PVWIigFlavg4SLxaPtHR1pKXG/4OFbGSRiFw0gB/xDEx2g8wp4A+tmtzAAEXZZVu0akc8bia
	lzWWxArPtl9JYJCTk/8YHBVmIIZru6c/Jb26IomChWreztKv28YHA=
X-Google-Smtp-Source: AGHT+IEsR8aExUZXdeUusQSsTjMpLN3nP6NIEIEvJNT8CI4eoDLhwSkNU7svDvm/2HfKkSranx1BwA==
X-Received: by 2002:a17:902:e545:b0:298:639b:a64f with SMTP id d9443c01a7336-2a3edb0de06mr43730205ad.6.1767835067043;
        Wed, 07 Jan 2026 17:17:47 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7bef:7c13:79b4:e9de])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a507sm60054065ad.3.2026.01.07.17.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 17:17:46 -0800 (PST)
Date: Thu, 8 Jan 2026 10:17:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCHv2 2/2] zsmalloc: simplify read begin/end logic
Message-ID: <se3v2st4cr6vbqgw5y3a5egeq5zrkh5bede2rcheygpdsem5sm@j3k75zxt73ou>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
 <20260107052145.3586917-2-senozhatsky@chromium.org>
 <gl54caplknnljganmswspw3cggoyjxe2n7szvnwhhiyl5y7ynh@tzl2yz7bw725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gl54caplknnljganmswspw3cggoyjxe2n7szvnwhhiyl5y7ynh@tzl2yz7bw725>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 357A38000B
X-Stat-Signature: 4ncj5jyabhhwdx8nebbtazh3rjfhbj7f
X-Rspam-User: 
X-HE-Tag: 1767835068-529671
X-HE-Meta: U2FsdGVkX1/vnOARLoCPmyUT4iWi3mpPFjyJr3VtkZY2DF6+PWuRu/zDUs9joXgt8EWcvv+qet4eMebeyQT7X4yLKVqC7r4uVF75mnq5smaqMMPVvHaHDyIU6gdIv2hk0Rucrnhwi7x7M8/L3jvnUOYj/OCFirUcPnFqKC4nYk3FMHoMoT9wRSf7y84nIerik18GoVpmr2w2mqzXOVsZplVrb6RhVaSdOVMnpKLHvYrdS0Sf4hyITabXh5qSeBjdSABeKo2k2faPlNiVovDaZxtiH1Va4GBt7npisV3+WFOXHtpXjAPMVl1sFfxxSxzFKHbpNe7eLZcgoN38Bx9BCH0cf4MBTh2qhKqqwO+9iXQpARwl1HYfzdkzDWn6v94vyP1CoqoogyyWudLdnWG63VesPFs9qwqtPEsGHxCE8x2GUe7cMrhvx0wdyZHOBOr0o/w/KK4B1iJ1OdHCLqdZoh6ffF4udbIrgZ4JH6XA7NPoLiPd8K113JCVvpkAiiioQnI1PqQLjTOHSGCeHCxQEPacQtR81Ngf/ND4wx89egytHHLvKrFvVZ9G1u0M2zQzXvTI9GQ9OiwPHf9zlhoa6RBI7IoYZHdBN/K1Av5zTv5x2uZat2J1H0FVbUqLIi1iMXw0cCMCq9ZvPIEamZZRJmUkmkrhZhqHgK1/j/rYFNn6I1OzhOKR0TgpJD1zWA3UxD9+tR9lqf1vJxPDeqiZ1AZgOaKuTsgF5aB47FELtx3m91NPYzSOe3w0If/5OBnUS3vZNWeC1SRU0YkdeqktauwkE584eLSHN502zSvNEftVuw+r0PF4FzbIgGG2M9C9rtwOADfF5mLCTesUfXksjM393cdBCbIQYRJGNhoUYyabZFY55JySoSEjzxDzWqpfn0KfiBRLJ7mjZiOOadTiW76A6kvh2V82r7UTI//Vw6QCFjdPrvskJ+O558zAbrZkwl+J8EbGomux4BojERb
 bihulRhI
 EI9A/KLFrGJt5Vtg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 19:03), Yosry Ahmed wrote:
> On Wed, Jan 07, 2026 at 02:21:45PM +0900, Sergey Senozhatsky wrote:
> > From: Yosry Ahmed <yosry.ahmed@linux.dev>
> 
> While I appreciate this, I think for all intents and purposes this patch
> should be credited to you, it's different from the diff I said as it
> applies on top of your change.
> 
> If you're feeling really generous, I think Suggested-by or
> Co-developed-by + Signed-off-by is sufficient :)

Okey-dokey
Co-developed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> > When we switched from using class->size (for spans detection)
> > to actual compressed object size, we had to compensate for
> > the fact that class->size implicitly took inlined handle
> > into consideration.  In fact, instead of adjusting the size
> > of compressed object (adding handle offset for non-huge size
> > classes), we can move some lines around and simplify the
> > code: there are already paths in read_begin/end that compensate
> > for inlined object handle offset.
> 
> I think the commit log is not clear in isolation.
> 
> How about something like this:
> 
> zs_obj_read_begin() currently maps or copies the the compressed object
> with the prefix handle for !ZsHugePage case.  Make the logic clearer and
> more officient by moving the offset of the object in the page after the
> prefix handle instead, only copying the actual object and avoiding the
> need to adjust the returned address to account for the prefix.
> 
> Adjust the logic to detect spanning objects in zs_obj_read_end()
> accordingly, slightly simplifying it by avoiding the need to account for
> the handle in both the offset and the object size.

Looks good to me.

Andrew, can we trouble you with commit message update or should I resend?

