Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3204D12675
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 22:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A466B000D; Tue,  2 Dec 2025 17:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612F36B000E; Tue,  2 Dec 2025 17:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5293A6B0010; Tue,  2 Dec 2025 17:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 427926B000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:07:49 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8BC0131CD2
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:07:48 +0000 (UTC)
X-FDA: 84175919016.14.F7CCCB1
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id D934720013
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 22:07:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=amVHV3yL;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764713267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R+xUpa7tpcXlrKuK2TYMeoF7urpbvQwlpFTRmhMT/tQ=;
	b=wCJTe60T2qoT2i0AHMjvI8Hzv7TaGg6FIU236oVc2a0OucJ84kadlEVHQeGhLLhuC6lhmc
	jZNcoI0Tw3f5fzDtsg1ZpyXOJwRYN8LpA2F1UizvXy5PbtfmLhDFu5UzL90FYHheZbbr1H
	zRAWMcJY1LRZ/R8iOXX8MlhO9siTFQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764713267; a=rsa-sha256;
	cv=none;
	b=yFdahjleAAb7HM10h9CAd+e9XAllOptBzVkDPUbr1POaBIlTiHuh48NozQd/lVGCilyAoW
	ZzCJ2MDlUXf6+Qc0Li12YsFsYBHs6vKAwFKqu0Q/bsk0YKOtvmLKab9+lJ3JrQLPcOdnKj
	be/VXC+E9a9OXw+d0Vh5JxA20yl3e/E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=amVHV3yL;
	spf=pass (imf03.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so3910235a12.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 14:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1764713265; x=1765318065; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R+xUpa7tpcXlrKuK2TYMeoF7urpbvQwlpFTRmhMT/tQ=;
        b=amVHV3yL3vhvYbIUKKODAEscw61CMC05tb+WIDt+C5UMRAcmdVii9SFA3Xns3ZnDZU
         iqXXjZDDEhtdQfksvPxhEs2I2kH1au3L3LAANc51rj1FI3KIvdLXXWYgHlOThK8GFxQ5
         7rKfPksBLsWlQnDU2veh6zPVIdrWv+F5e8XWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764713265; x=1765318065;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+xUpa7tpcXlrKuK2TYMeoF7urpbvQwlpFTRmhMT/tQ=;
        b=oLyG/JCsMS6smOp7rfym8UDwPPfNCe6EVbHTJxwVlCP8XdA+onuDIrhkNPX8ZTraWl
         fmPPAxyxU7if9XAxKphNIN2kntsPBG8yUZP0FHu+t2l0y9HTbQMfcNAZIapGrI9yHwId
         UPLSim9NkNrU7/1vP/gl7gVvbS2r007sEVPvk5b5gf+MSVdCiChdNLKY66YTODOOY6Rp
         M1J57RIS63N3IB7CuKzicAPCXsR1OLzwDKtGX1+qZF7MX7/ZIH48uwRU3ZJhH6v/J8uO
         baQvt2tdUZjPnrDO/MTWVh9c6NGefMioQl8isPtryV7s9FaPVbkhRpUaeIoC0d0AVPj/
         meXg==
X-Forwarded-Encrypted: i=1; AJvYcCUdgVB3exumYiYP7MeYTOz348mtOpsE8DtQj/tvrrfo2bG+cAwaxK7qUGhAq/p4x4boDJvciCotDg==@kvack.org
X-Gm-Message-State: AOJu0YzjuboI02DdHcmZa9mv62KDQngeuiAESMGDpCGQgj20dUYlB9tE
	wsLRGKg16GICCJ/jHzjPdMZclIcQSBrAYDM7yj2sE0A5QRf5ZIB8qqju/pPUUehzRuQWVUIRvCJ
	D4PDRijw=
X-Gm-Gg: ASbGncvm1bUxzTx3G1pscQeB8dTX+wZWpwVVvgYuPtyQWuXJp8oKMn09jOH4Kfo+APF
	6z+5qAGX+4rjXqNaszVOLolhOD+adE2vhmAJbfeM9sGRoV5IaiiCL90UifvK2S6UiwJwZr6AQxN
	6io5V564WqoAikgcrz/PjfNHARMEMXDbkZc63Z6FKeEbe6lrkVsF62dPrqGH6Fomm8OEVjsH71i
	gHwlYEfO9dPdfLa6K+H13l+fwlm3w/yZRUiDtO2tzz9Tv1gdmq1Dtw+Wr7Ws5oAWtWYE/RpaXQb
	2ayC3rzJdSIfXiKdjc+aLmA9Ba4y80F4SUnbQ7+ZTTOt3397uAX+GITd7LNTnVpymepe5OSToY1
	3lc36q78iHbE025jDR6Yuq1WgEbA5Ym6q5mOK4+ryz6OBcbmhRhsdHRUlg26HxV4sizAbbwbfqE
	o0IxM5FYI39A2v0wdHW+zMEV1No392kok8hoKerAwcsjfvLNQg/DsjrgZgxJN57eH21gEnmxg=
X-Google-Smtp-Source: AGHT+IFOucKLXe2oFUvgNRq+/h/Bmh+jWSsZJRwc8CD2Xtl0vZ+eLM7nDVw4gPpxhgqxK1EJyzhMEA==
X-Received: by 2002:a17:907:3d8e:b0:b72:5bdf:6074 with SMTP id a640c23a62f3a-b7671547f7cmr5416859266b.20.1764713264841;
        Tue, 02 Dec 2025 14:07:44 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f51a9819sm1637955466b.25.2025.12.02.14.07.42
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 14:07:42 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso3601947a12.2
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 14:07:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVfGVJElCfqpiPBA/eUivD9qMSIY6B+Vps7D/vzjLzUPNaKXaYjNUMTwJyz/yzmtJcCVlS+VWA0Dw==@kvack.org
X-Received: by 2002:a05:6402:280e:b0:643:129f:9d74 with SMTP id
 4fb4d7f45d1cf-64554320e9emr44585697a12.7.1764713261899; Tue, 02 Dec 2025
 14:07:41 -0800 (PST)
MIME-Version: 1.0
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com> <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk> <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
 <aS7e9CbQXS27sGcd@shell.armlinux.org.uk>
In-Reply-To: <aS7e9CbQXS27sGcd@shell.armlinux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Dec 2025 14:07:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4ZnsfpgXYL5qhjYDYo1Gnssz+VxnKZzHXMEmE7qrnQQ@mail.gmail.com>
X-Gm-Features: AWmQ_bndnZuSySd3c7NVIocYoeSzskkAStzH6Kc1-mQN9xQL8na8ufP2gzQ6Lfk
Message-ID: <CAHk-=wg4ZnsfpgXYL5qhjYDYo1Gnssz+VxnKZzHXMEmE7qrnQQ@mail.gmail.com>
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, jack@suse.com, brauner@kernel.org, hch@lst.de, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, yangerkun@huawei.com, 
	wangkefeng.wang@huawei.com, pangliyuan1@huawei.com, xieyuanbin1@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D934720013
X-Stat-Signature: k4yqyoydtdhwpfyeshyu6u571nz18t39
X-Rspam-User: 
X-HE-Tag: 1764713266-290215
X-HE-Meta: U2FsdGVkX183cs/6j75mWuL9D3dVyz5VMdYmBGdKL4+AUiZikScC7R3DewVS3F4oaJpaGNVNPuYhiCCBv1lI62m2lslF4AIhNoIAOcygM+0YHuKnHifHB6UnQIvwOKK1xtcbd3a3MAkGOodiof85RFWAzhXvhcyvLpMp0TCrGeQABlY556GInr/p7MLKO7DGZYGEtBWvbgcuWwTxN3NgHwaSraJuLY3+wrfx5y5OxE+yJyq1D3pqpeAUMPHuYDGFjcrPAW9BCgfhNtEegVMSdETyAs00NK4ghiZKWm43d6YR9Lg6XHOMEgXyD/G83uodk+8j/6WWipIHqC81hx3PjuLuDyur7hdeA4mHABKzEmlGQ+1AFizmuD1Tgrwx4OqNjngq3i9IcIHwLXj6TLtdKi6KeT4mLAyVdZPrLjmOuXlP+UsCSS6lSimlHwD5aja3oiNojAHeLQG5Q+6/W7xS5texarpmAENFIF1tHcrdfz8nU77ZNRM63k51sVm+w6hlvSMqkyqh52b9oaw4YpomUvq9nOEBZjTHPxlP0B6Dg+ZM5E6ays8MKxvwo7h6yaXhH2uMSjIW4EqSJUfYvKr0sAER4AelOzw9sBrx4TV2ivjXymsLDkWSM6KKhwZqvyuoKhtXA3tE15IE0LGSAT9gkiCP4952iBnEJl7aRecEUp+h/pWvv0hLN/O2W8CFCp9a8cLqKV2m1agrDSJGC26lgLeT8B5IcHflyR6H88LDQzYqHFEzxHKsUWBPjEygMwoY6D0Iy9BTRx6etey7PlXqrUnwV5g7wPwKDy41qndNv6MdnwXzDn24AxIdZBDi7lYskQW+HqiUl85jJXJ9ccky5dfZnVlJ72BH3updF4XbXM81hfPE39REpwUv/kC0a0TF8rDFHLyHO6fPtrzgVtqSs7ohdoKKDdYu9+PkQBJUdCpkLDcieEplQJLitTv3JkP3Lx8iOiuMp4KSLUxqddc
 u/kJtEFN
 zgXDqz/iZ8Io6Y2jfZO1Tlox5YWcqAbvXS4sH6hox+mlV3fOrHovPbag7bYZswnHF5C3BQPGfEdxSj81jhDBxnmhSEnEJ9/AkuGCPRcI1/96/ZY5HdwZ4M4wiCCey2nROrvP0qZfVD7B0WvupvYRlt6I3zAg97fJKOGfwHXz6cAi2bhgL1RJRpTN7IC8NWDQtTHt7HKGzK6pbl1OQijIhCM3u4s1yaKtqiL/uqfP+dYn0rIAiNGKqFWyeWevmZaUDoytR+3HX7YqqA3IMbpovs0tB+Tn6e454tEOlLmQodIL4WFIPLBKKwJY7Jv7qijij0X6iV3Cwy7Y4glmqyP1exOHE3TrxdhkHLFZg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Dec 2025 at 04:43, Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> What I'm thinking is to address both of these by handling kernel space
> page faults (which will be permission or PTE-not-present) separately
> (not even build tested):

That patch looks sane to me.

But I also didn't build test it, just scanned it visually ;)

            Linus

