Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB66CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19EE6B008A; Mon, 28 Sep 2026 21:03:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3E96B0096; Mon, 28 Sep 2026 21:03:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96846B0098; Mon, 28 Sep 2026 21:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B46146B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39D441A034D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:03:28 +0000 (UTC)
X-FDA: 85265001696.22.BC2F767
Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75398100003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:03:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o+465sgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC2G8MEi+Qgc6YtX4GqkDnJqijVswtbQdET6mIsE3zQ=;
	b=WyJvbe6cDFGSmtWkTHWjztO6zYlUIo4evTGbmoqIvDMEOXot/jtIyB8MEc5gRX+c55tqTp
	N6dMiFyFNP9iJlk1Q5NKYLKpCezb8Y5NsoIqhYOLzoFsa1r4Y3FuNpHLaDY7DuMS2bC9W/
	rZi78CWOB5Kq1S1r0R10UpDoLl+LIxU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o+465sgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.170 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643806;
	b=k08jsSB3fAr1W2tUbYr4SM8ZALhF9n5hDowgqk9WEOP6oRX8bfjbcnTRwVTKrXy1lXZ1RW
	1apMZz5G3RqPSXqnWWGfAsaCp9UxFa5nDW3peeRfZUcPpTBW5Pym65tevcj/ZgJtUpQEPu
	gVChVMZpNuHjfHOO0+J6anGXigwjNbM=
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so2173619a91.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790643805; x=1791248605; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tC2G8MEi+Qgc6YtX4GqkDnJqijVswtbQdET6mIsE3zQ=;
        b=o+465sgkZBISXYUBN3A1zt7ftIqIWnMaUPbuV/8RYmeUHYLSO31nqoi1RtA7QBvtPF
         wAnBEkRBGMqIuwDTWUarwWcjZ50ONEQX33Zfz0NMaMkemfu2g6UJ4WWTqjbLo4Wsc/Ls
         NUBmV6Fr7pV0/jIoLaMWtWh4p/wGsXWjHrKvs0V/bvyRO7dNYnSi9hFj0z2r76IYDLcy
         ssmPZ+GcyA79Ago75yf85J7J1LgoNNTrL5MAs2mq+8n7lCDgY3HQ4qtgZsh7mAnSQDAd
         AmVnFDBNlWGqRhnKZrfBDF4d6vna/KhUOdsKesypTe9WQkFzeOKXIqFPA44aWJ6YupRw
         MnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643805; x=1791248605;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tC2G8MEi+Qgc6YtX4GqkDnJqijVswtbQdET6mIsE3zQ=;
        b=oxDg7f19vjeUz3qVvuNeeetm0h4XsAlxaRdW4VLhr6p03wSeuuVpfWV77DH5GXvzAg
         yYVZ4+JmI0Ba+ktITEbcUWHAypSYtjWMwSwGdMxbr9CGoVEn1TYEAhlkFWrzxPdiCUa6
         BRYgMNI7VmlF4w4Jw2nCE5ki9fdJJ6TK39QZFDYn2D1DsBPfQ6iq2Bh0Ha7nM5dOdT/8
         Z72raPZimmN1tzYswSodKHk/V4pd+WyNK5DmZVtX6UsOO7Z+v8d0+5TdNJx+9EywlexB
         JQ4KH1jsQAlTcz8BM9N2akvh96TfR9p78lO474XUp6CIzUozqktz47JjtRLppjFYP5Ji
         mJtw==
X-Gm-Message-State: AFq9FYLOSoBFuJlhGVyNX1Yk967cfJ+7vbJAxSU1tIiBvMia22fwlSUM
	Y35hiZwezXcHlqS73jtA8jjM8+BqByq8rWnp60qpBafmJ5rQvlL+rVjh
X-Gm-Gg: AYBFou1QH9hZTcaGaIBBlnVvphdiZQqjKzmpNMNqg0Gf+z2bDFC//oMGRITllyJPWIA
	PrTr1NUecCU3KQgEqj6EtUIMzKSCAOGg+lF6YoragZ3S5vHLiHSl7WP6lUBqWyitbe7s7JrgwV3
	9bY0QD4mcc7Cvq/NoLsk3SXwYEJcn6fnncqaAqniUJTSIcsLQu5zueVIVLpfSrg8c4GOIrvAu0F
	JvK7uK59luzd/e8P+gI+SxORUKnVm+1FywMOdeaKE4skp1pOok7fVe+xZOCY0gDWOvI2AQZ2BeC
	fTp/mTT0WrH/D7U6a4fuCL6F64oQT73/y9bRUuqww4NmK07S2uyM5JRaszuUSHbD802Ag+4TAIQ
	0caL7XtvusZmGZtX4RGyJ1YMOgi0bswHC06UAlcqjDhQLpGA89OerM//tYD1T5tA+JqZI869ByW
	oWjcSKAcAnk4/T2PdsgfBZvtiG1f9laoMTqfeP+PUtNZwek53GJG7YzZHAPwZ6aBkg/DB31MwBy
	MVqeO+OtRMTYR08R/L4aFL1rkE+JHXakicb8S42q+PC683IEMqfggMFpOexLc71NhKRYils03Tt
	aYu5TR1+vpqQPOCIm2w17BhsHKDCDL83/1Se2qsgezjt7hnuyLUvggPsUqdpViMtEqrNbi7TLdh
	P
X-Received: by 2002:a17:90b:4acf:b0:3a0:f2c8:9ad6 with SMTP id 98e67ed59e1d1-3a0f2c89d98mr6052076a91.64.1790643805183;
        Mon, 28 Sep 2026 18:03:25 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4985ff0f2sm2052278a91.8.2026.09.28.18.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 18:03:24 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:03:18 +0900
Message-ID: <m2zex03m3t.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v3 2/3] selftests: run tests on nommu architecture
In-Reply-To: <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
References: <20260926010819.604346-1-thehajime@gmail.com>
	<20260926010819.604346-3-thehajime@gmail.com>
	<04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: piyj4iapg9nqgkwyjzj4t99hdftk7r48
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75398100003
X-HE-Tag: 1790643806-385927
X-HE-Meta: U2FsdGVkX1+dtnSbfu3pgDW8VgeVtLE0/4OMGVX4luk5ytKx3smfSD1xctnf85F1NnKK+dlIUoW1G4pRbymrkoZg3lt1eK82UGV6Np0pYN4L0RHI5pO23HPHZxJOGpjgikxArjJyMZwTqK4ufR/j+E8gifrmMF2L3hsRHJ3IAY8o85klNRkbSS3tYINOabGtXLzAWjlBotqBLQ3guvBSqPHDBaTvuNsfMJiOux3BwP6dpa17S50LCZhEohmMvhpyvUTPsd5twBbL2aZwx70uttb6MszmihPA6JOPGY3rffjmCviApuzZ58uTbkoDLGltPBRLWW2nGltp/wja+4L1gxkz/V3UlXCa33Omk1wRlRAQ0nr0sPlq7ekNTCkqCoAIhlSw6O+fnIH4UX+KjdtFTGTxFIVzBzPb5/VAl4dyQHYpnkjCE5zKj+XwgORnWL76ftrPXqIcLoQYfOTu7M8t4V5MT7iGGxtnKBRHWSgCEwrfHw4PE+FukgFeGF9NSnPDnNhaf9mLszOHonVvxt6vp6eLQpYlgklIuNDRkb0Y3IHa0P+gxxFLgPVEqM9VxTY8tmGwflB1dgG/3M3EUSYCqyHih8WXeprznLasUJHFfC7+k/Wne/0/1l+JO2lHSdoA2cj/7rvnBOTNu4lODaUJSdcbniP3SnKfitezyql0VnkR+JRVGKqj1/E/ifjgBOtcMaWAi+xlNrZ9lcaabEccTzKBXrvUrWB5G+xBZMFUh0YpLCM2gNosvCPclMp10HghlSUVlSR4ohfmpd52VLi5s6Om8siEOsgY6n8uwLNOeoAAzhtC3l7EnkDvPGaaQrLMZK13wLOEU6AOye3mndi2ght/237FRwf6kc9UBB4DHdodSaTUkj6wvOuS3VpeiB/xS2+kKZDWFjMXVCTM36UYFwwehpu8o+8tfQokzCLkrtZYSDBFGfmbAHWEcHyVtaFb0xpKRd9TZ/SLve7S6wC
 dGR2exJV
 r2uqKzqNG/eSdFtm0teNv9I+8JDQQVgbZhHMxZ9u6FZMTvubNYD0HPc99kBjDbqx1HBuNQq6Gjs9V9qWdo4aZQCgl9Qa7xhkgfJjU1GxLMBBj94nbiqYt9nsnGELiypfyb+fYT6kcn//jm4ogUOjrdng6z7wFIe5eO3W1ex253vVuViQi91Gq2git611i/goPPqc+COGP6p3LiP4iq/1Hqxy/Km1Ekty+RVO7F7TOWwKfi3JenjjLcDegS7awZP1sr16fTn3+8G0EHaSwrBHB8ablBRq4FWa4RCmco/1NGnLBzTmBtZjba80G+WgiAzrG5m2wWAA5WMyauKvxOmNtqUZN90FW00yOcEP90Dxa5H9+ass=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, 28 Sep 2026 16:44:49 +0900,
Johannes Berg wrote:
> 
> On Sat, 2026-09-26 at 10:08 +0900, Hajime Tazaki wrote:
> > Architectures lacks MMU doesn't support fork(2) syscall and only
> 
> nit: Architectures lacking MMU don't support the fork(2) syscall ...

ah, thanks.  will fix this line.

> Not sure where this should be merged? I guess selftests would make most
> sense, but you can't actually test it out before the UML nommu changes,
> so that doesn't work too well right now?

I think this can be used for other NOMMU architecture (riscv, arm,
m68k) if those are properly build so, it isn't intended for UML only
tests.


-- Hajime


