Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB81C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58176B00A5; Thu,  6 Aug 2026 17:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09476B00A7; Thu,  6 Aug 2026 17:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8046B00AB; Thu,  6 Aug 2026 17:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF316B00A5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:12:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E27301C04E0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:12:42 +0000 (UTC)
X-FDA: 85072093764.10.F2A79E8
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF6DBA0015
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:12:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C7RHqZxM;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786050760;
	b=JkOXRabhyEHNhpVAKf5M7kqFj3Nf549yCY0qqrRB5OZfxFzuAhbYP7bSH0h7Uv+QT65Nb6
	NnxzD74ai53PpZ7jq6FjBypP67yRz0U9Ry8b2NScBDqm+EqmYElzLKsmC8cejJgU98OTYa
	d2AFjNi79Zpv4FFToXoOQQs/eYEJA4Y=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C7RHqZxM;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786050760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
	b=g7T0Btbkdkdm37gsvJjsdxHo1XCtR9NG/40W8vruXgt7nSn5vAW3yLdJy0+Px1W5p30EN2
	/aQbqEFecpuivvPdFe2DZ4jPVtc6O7IhKDFmhZ6XMCz84Xd5RqpICeRjzebxEFOWiXQic7
	tMmqELp7LKq2+EL9nTRUqXEJCBhTUkE=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f7872abb6so1306492f8f.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 14:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786050759; cv=none;
        d=google.com; s=arc-20260327;
        b=L51ogDtpUnru7a+rk+m/JBONhKyW/NS/GaXVdlNm3cCalFBoZafmXdEru4FOQDFzL9
         PTzRxJfsA2uPbmNCf0YmfTi2MijwdvmOYtvA8ogL7zetd5gin8wpmhlPA6GDSxiWB+Wr
         u5ydJXClasuonm/89d8OOstzy+St1a2Ymjq9UNWKzIV4u+824MhwKOiu9d3Mpzm4qNie
         CmSD6DeK4ezhdXjaoJAOewK2QAHydDHdOXG8XxF8GRfQe2vk/YrOKrZlNWdhjMfNm1cS
         xa/IMg0jijF0xp4KD6kMVmrDy48jxupe2RWGijf+lT6NaSIW+xTWrFtZ/DNz+eDHhPMo
         1xmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        fh=xm1LNoCMkZPEYlLaBN8YQzf6qpfeONSKQ87fzfPMuXg=;
        b=AUYdnsTg/4tYcDgtsKCN7aD7Q8TK9HqrWCNtZPFeErEG9ddjWS7hg59CFiqA0IdueO
         DzynFAjjOc4iNDpauFKaJiDM37JEni/dt1tPDqVeLsNCwpzsNxZgZ95sProddWQU4Fce
         7pDRPrGi7VC4inL64Q316TwiYQhNBHbE8i4FHbc6fReU71TgFLS5pzlSwPcvDy2aimHz
         bet5uKDFzxL4rn+TPhPIRrFJ+jY4RpQ98cDgK7n8G/bUIqXkNNDx4uAMHjhCmhygbpPP
         H8hKuh8llvEYq2ynpnfx5Ce1Ydg0L97iV8SzHsF4nZkDLMD95VO1IX6/DUVFiPbhguml
         mNGA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786050759; x=1786655559; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        b=C7RHqZxMpZDtuHIQcqXk+w5BACSPr3C+ivJxb1NaQ1EiuylMaXAVZJkd3Y6QwqM/Du
         RtyNVGW7m/3NzYP5+icHOoJS+pYAvBmRdIX7O/SNZgkeYtVeCQUYXLXbX/v2CjocZdnR
         gj0m/4jIZXUSGKOiRouhV3aCZ4E6rk4SbTo2X++drUgD7ZVoP7sLfc7KK1AFscq4YPc6
         K4r0KLmogwfuITksDWLiOhunnunBxxceJkogB3q1bcefFdjqH/dTNLhNiWC6bBbOcwSN
         1itWv2T7Lw3O+h8NiZQfkYLeH3dkKrIYTwmad2xVwQDc405n5rJwLzxIeptYsI8aNQT3
         EjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786050759; x=1786655559;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O2nXCqD4o4f5F4Q2WJbaQxzYFvLIe2CbH7K3L5QM6zE=;
        b=jFH8gRhHmzzJ3EE1DXxUpfHOEWSiIidtybmm4FosMwhUisU0Le27NL/zlFIZn0YCzn
         LiRcLhuP1r/7ZnCfTVEU0UMoOwl5RcBo87nAyWq5UBZwcT3Vwp1ROTmqR8CZ1Ai4Hbu6
         fZ1711hyMqH50Ewl4R0FD7frVY0Ux5sZWFZeW2TfoTOraGGylXUWGlwexYwGPrh5WIoD
         xqZ8CSQVOs9hI6otk1K3C8U8OBe+BXnMA6ihpC6luJwzBIClraYKsENHA3UJvbliBOTj
         5ebIclkDX3xg5xa33S4aS+PM70ARd6vrBWP0Y0FumFl23WUPuHVRjqQTQv66ZuMmzZXQ
         HZmA==
X-Forwarded-Encrypted: i=1; AHgh+RoO8MymuzsjmDx9lU9NlDfS4tsBLlFK8sJ/JjLVg2XL0ncIP/bWI1VGnGkBgJsJnSstkdHP3atf8Q==@kvack.org
X-Gm-Message-State: AOJu0Yw2HlAg9b+wTfYGVJUa5LMRjUW369Vsx/kBhLrnO6gherqPF6uC
	ej1poz8DTczbkBobETN7MNRVLveoBkqADu7u92Hw5IYBkn8vjihrAXGBgLS44my/42uH6yFCH9h
	J7fhoyCJiqjhjzfab/tHUFfLa993/LZQ=
X-Gm-Gg: AR+sD13mkftYG5MsgkLP8wNG/Q0hCTq5tPmrr8Tpms2x3tnpgpEJNQ1zama3ejl+ura
	gN/EltkD1vZXgFto4iyCW0J7uCBSx9oRYjkWKMbh7jmlxO6YchPC9aPMqWscV/ffFfDqnBQjDJK
	0w62byJ4Z5SM+M9J3rK5T2+aXSgPtkMHXPMSTTBkxcx9hGOOc+dB3liS2cDwzfm91KBMvnJzYU5
	9HS66C/Nk0qRmwdnQytpDAXabb3mvZ+ACbAiL05Skn6NqNewEn600RaqOp2FpDB+KbOUxNfkk9I
	SB2yhINE5QsS3JYh+ajBNIRyFeFyFrXHkz8z3NMip+ofR3kJ9ufLQwrl6c2cdaQ3zMwuVrDoQs8
	st1dnmpe3BNU8TyNoopY148w0
X-Received: by 2002:adf:e012:0:10b0:47f:762f:32a9 with SMTP id
 ffacd0b85a97d-47ffd2322d0mr5562298f8f.12.1786050759421; Thu, 06 Aug 2026
 14:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
In-Reply-To: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Aug 2026 14:12:26 -0700
X-Gm-Features: AUfX_myi8qSsw8YaJ3oXvGriDbREJKOHPf6InLwZIwXLf_s2phZcmAT4WgkHKVs
Message-ID: <CAJnrk1YNZ-mW7VDXtbNYDUbim7g20gSsec1Gxpy8kWKrDEN5_Q@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EF6DBA0015
X-Stat-Signature: tfanf761jreqeo1y11zhrsr4smynssgm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786050760-309165
X-HE-Meta: U2FsdGVkX1/jvNU5lu2uH4ZXlheLnY60DiRnR9pEAA4RjzHkaNdxeZenskSzC0g8PibPSkkr0A4oNJ1RSAjYAdPEE6KGb5yziOej3HdDYcqerIfBNzz0b2WHK8w2s2YCjmPY289eSeFFeBXk6sovBKNMFRYwkIpOvTJMShcj/B3mjdwJNSn9Ju8SZA1BPqcTToSVsY2KgCsOZRed3Q2eFV6bsvULDuuxSlYhoi/r6OFfvw39XyWU1ueJ/wDVpgtAklTMGjdUYc4MCckOb3CTveTZRruLZf1gmwXEHxT5Xd99OQXX1DnnhKRmfcOBbk/SWyMSr1doSooXRabUWdN16ZFZaPxR7xtZOn4SLtJZq0NzSCeOL8pSrgtTHBBsQm1/28WJcLOsW5D0W4vYbTNC4rn6iC29EF9eENPnWW2IvRFU6yFHBDLgvMjYD7MceCj/KE7R2VKTh9cu+mwfvrcZn53bUsualnZU0NK/w6vmF959AYElFXR65y9oomHfaxbG8Q2rVKXquUiOpCZf1tpJmfiJtnZxIkAJ/Xubm0cFMStJXdMyHpXM5VvkqRLzp+0X68qoaxslqRRhJT1U/lS25oq/NYyL24yhaq9cla/lAWQgtYtb9GEbfrLiHwXortTRiOLCOMuJPrOPFxgvE4X7HiiMZfFzf9v0BIak7Cm+SjmjnW7mtRXiXCnjIvxUoroXiejoVBSPLn7kqBOfrKRy0l0fLENKOUfxTfSLoYYqpk4HUEztoaJHfLzJBQCzDiyGgcD2uTii+Jy7dpSlVdldCgivh06lq15yiUA02QGzmcp0GgCsTS0/AQUDWSqQNq7EwIHQL+2iYIaGSJddL8vT5xynnqICI4cX/6MzIHKsUkOmw1VL+6Sj0WP+b5tLrRqjiOn3u+PSRkONgfabj2fdtSBNn2d/zn4HhcXxT4aJwbpN5RGIWGK5XTWhloueTxf6GiWg7twyk8GS3742yAB
 dZ5bZR60
 S7W8LiHtYlvXCvdJlPtb0EDOrFHJO6/PIzW05RAFkjv7XLid8z/IWzOKGwtXSi7UjnSqgEPBxJ+yxzPn2SBM7iNHcttZyX2Hu71F2EVF1I00/vExr7APSWQFCAiVk9yVRQLEteGo67ztzLUOkQJDS0+4jeDSIt5cI9SIjU6VOLwBirsUEDPy2/rIl6IigWgoRXfuKXDpir5gHu7liVuPoWyUxhpVV/de3QU/5dWY3kjy+i9aqlNvACGd65Eietj5DcF+KU6f0a3nNOYSAYLqn/zdxsu3vZ2G5pIKx0SU+7kG9I9h3poKI12H2ta6/pxE2ml8PrUGURYXWCyLt86/wKtadfHUTAS+k0pDrLnEbMfMR2vupNnTZr1llnJmout2zsbXcwduAJA/dxDwPURbbwLWOsXkAvPEXiaAtU33BIKFXveNTLHQGnRMrVjH77du5Q6KNnY2PekteONGI0a4ojsTpv0cSgLFjCUQ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 2:04=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
>

Sorry, I think I messed up how things got linked when trying to update
the thread title in gmail. This is a continuation of the previous
discussion thread ("PATCH] fuse: disable default bdi strictlimiting")
which is at https://lore.kernel.org/linux-fsdevel/s4kv7qep3jlncs67q72xfhser=
pd66hpbwzkoppiddc5raufyjd@ksuvlfqcrbk2/T/#t.

Thanks,
Joanne

