Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD88C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C026B0088; Mon, 20 Jul 2026 07:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D606B008C; Mon, 20 Jul 2026 07:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5072E6B008A; Mon, 20 Jul 2026 07:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D3736B00AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:02:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8B0516010E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:02:28 +0000 (UTC)
X-FDA: 85008866376.22.29D8DF8
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id E7CAD16000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:02:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X36/+1en";
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+LqOLf1bSbbTbtCruD1zKjWdUcVSyhnCC+ieNQDkuA=;
	b=WbM2Lq4HzPXTrB8POkz+k2rfBkWhO5396L0XnR4cEokQq2uiPdMZdwH6i0GUfBArXUqdRY
	CKqA5dOLK5zrPe/b/Cs17yG0n66VJ1lFJtKQMZUvhmBHP5ROkOcUo1ZQYKqtz4rHD3tGF9
	AiEjyor2XAqxFrpisCP+cFmcSyaPgtU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="X36/+1en";
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545346;
	b=d0TrWrnf3NCxPELCL2PX8tJW0I8Gt68HcYipleS2pDHDUK/J9x+Oou8ozDQDs7au5X9QFr
	Zmeaf5skPYl84X6GRN0qLsLDTwKhW2wvplLZAQG55MCHreloOEA4v/bzS+N9J+ZhdStsRG
	gaQHN955oa+VwNCbsr7TVksn7BWz36E=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c999f162c9aso6210887a12.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784545346; x=1785150146; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x+LqOLf1bSbbTbtCruD1zKjWdUcVSyhnCC+ieNQDkuA=;
        b=X36/+1enWKS9kR0c8L55UMS1sF0gFBcgdxT91F0uwF6kGGhkFMs19lRoOb36Z3Mz6F
         641Ox41k6QwSK0EM31TxWVMqG0MMlZyNSUVNhDu9OtBIGEHI09Tw8yOk3s0D+h0mvrfn
         jkS9rTMankxy9uq182cj8NTcJYsNt+jHTcmr52JDRdTC5Svvdqvkkt00pW/9z7jy+aHv
         jwr4msOaPBB2AhDrPgcVbDXHe7FnshnkHuE2GnVkywAPxFcdOUQPJZw1TWM3/ENIzrgg
         xzGhNmBu3BVVUTCrwjqPxZ+cDobrG8dKz/M5fVKr2m2zCpCfZGLvdjHGA9PwIJ6m+CDp
         vB+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784545346; x=1785150146;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=x+LqOLf1bSbbTbtCruD1zKjWdUcVSyhnCC+ieNQDkuA=;
        b=ovZXgUAgLK2iBItl+fnEkK0FVtTNgCh6mHABwOJDno2JOP6MiLvUPWLYq9KRZJWHez
         dw5IGde7w+zQVmDWIHvqx/UWN4jUwp81DD/wM3mqTW077uImwtPz3AMB0gA98SFqLgyT
         capoZkH1UIse/29IranwarbBL1NUbmfljKlrPpJhZxk1wH/4kv7ZGI91ingf1l1Me4XB
         438YDYtZ8rSHKzv2jdil1H06Uc1EGhpzH/t/jPUlNkAhcMr7P/07XkQfALZXiKWd1fLJ
         UUE1V5Albas/ip7VlZ+a1WZ4Z1TmRfDijKpMysCGR98VL28Iw3umlhDqtkbzzH/fTrhV
         gfFw==
X-Forwarded-Encrypted: i=1; AHgh+RpaUcfavkV1H5QaFr9KkWSETeHePBn7QJIz+I2nxYhuYILKtOkcSIlnNmHFUX1ntXfRQcyKV3tgNw==@kvack.org
X-Gm-Message-State: AOJu0YyNbFixa/S1zD9iZGIDQ9X617aRQrTcwh/XXa1skCgZo3j9285q
	DM4VQ0eVwHCzeCnSuKsrR5GpnSWDZcKnPXo489d+xVqGYp2xJ45ZIFzH
X-Gm-Gg: AfdE7ck0Wznod41fHdfKr0OKTBOzZjbOJQzhWwIEVa7RBeUBthFpN/jq4GY6UwmEkC9
	IkFpX6qBnMVIVDhlYR4UZtu9iUB2Ob2SWBsEIXc0wCx/o/1cBllSR7HY3LcWiz+r97ynj+5QeQ5
	wiLnlxFROBIadUk4Lb8UlCvXCvhzJ8W7Ptm/4sJ/YHseFD0247ua4GZf3yEvyi8DM89lS3aLF9T
	W6nTq2pMwhDn6UiVthAJO4ERwEgcudb29fOrvRUjoAGi/MnDaL1+bDyk2aJJN3btmGq1iubjU/s
	1bCJfIGH4O7CCUKWIn1FUcejnF0YadYjaBIlwt8mnYR4X3+M1czv8ka+FfCKVNnaLd9CfV2FOxC
	KvEm7hsgmRwF8gxNi/8JLP2EpxVcxm6DklQ7sCRNdNphJBGcSpRVJdN3lQkxS9ZNsfeWZqTTMNj
	3Rv7Wbpqs6BRWmlYuXMsndXrentTzzGeg/v4uKwlfd
X-Received: by 2002:a05:6a21:478c:b0:3bf:b182:94e with SMTP id adf61e73a8af0-3c3ad66b538mr15799239637.5.1784545345587;
        Mon, 20 Jul 2026 04:02:25 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8d9:11d7:8597:c44b:bbf0:2c09])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29c2c93sm31585842c88.3.2026.07.20.04.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 04:02:24 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: gregkh@linuxfoundation.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org,
	stable@vger.kernel.org,
	yikai@z1k.dev
Subject: Re: [PATCH] mm/damon/reclaim: fix typo in damon_reclaim_timer_fn()
Date: Mon, 20 Jul 2026 19:02:32 +0800
Message-ID: <20260720110232.312053-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2026072041-rearview-unselect-3f92@gregkh>
References: <2026072041-rearview-unselect-3f92@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E7CAD16000C
X-Rspamd-Server: rspam01
X-Stat-Signature: bzdd8eusfrfzcxnow71sr6deyg6d6nuq
X-HE-Tag: 1784545346-350940
X-HE-Meta: U2FsdGVkX18sDDSYPD9naI/ACyHpAGSh+JdAGFnDM46FPIC3wXIeuI/1H593IlcksOP1X5NzyW2gSt4QgSb10iJ0cck5o+eum5AbA2nzKCSec3RwjofQITV2rk+KJa1dixMUIz+E3dYf8MFnUMislg393LSaOBsuZstwlA+lJSjx+tEd8QgiId94ikK6V96c3N1s3HWNzp2mDLT84OaK9gNypRYEwpjFcw9YqEdItbt8x5iUOWe5ZXQsEySdRkR8Ywero2A8IX1EpToFV3gcY7R+POYq8JJGFcPDjzNv8/lqVgs+mN9Mrm8cnRBqlVczzZyrAneaO/MyJNUn85W/ruWK/dYDfi0gX50riZmdG5KTbUxOycEbwMyDd2Ic+xSIonSGGhYHMnrR7JJIpzo3PB0toEsHzW1ZR87WebddC+urVHXvy2yrPzJ4Hg8KyznienZbdwL81CRON8yTiil9VzRmiMJ5t4/Nk0FwAjQTMpUWpuCfimEpmmT/H+47ks9dOpkFTPrDzuVExqz/Bbsw+TzyrC0Wwg9ipB0m/0aOD3/5BzCIiOkWVvdrjPwDr/DG/yaI3NspHiwUae/gxRnV4Ptzp2Fr8qJ0I+G4CqbLEfdq94mY34sI8LRL834SxWFKr9hWNqp7DTPhMZVgqoVL5FTDcoGrvlBOvwSBAehXen/XXkcznMJ9FZHfm71qkIrSUR4LAF0Ff4zJifSCf/wU9R/CzG9I8yMjYHbU5vS2sJsKPlEFVT4Ob4bBHneOIg8ItEs66LlPUl3Fu36V2equnZc8l1T8TUE2wrLfIwOH70RHhpxiI6v0iZ9ezWWaG/sxNtj1OidiLMyU1LLjXOC1yYICv8YHPFH+ClFJMIaZz5PcdE9Z/oMyNUQDuik4urYNoa4U6QPBigqk2GSYeSR88HLTIe/x54qyRcalpqqaQvqGJKTOYTTZdd8TcVvJKSqQa2HdW3xhxVgclZ7izmf
 2gLzvhso
 ITo/UMSLLC9o9PIr+EQySboEe3AweEU/LrQw8TDnpFycYZWvlXb+xMyZgJUhSE3pqdmkHaW0PCrWjflhQKJYFePzCHKVhp7xdhhJWkPfN34h+oNjqC8F3VlxCkVBqLam9bH4ESscik7NhwpxYMoSLgpJGSw6/FgqZs684201nvU2kiWNyhAj5U1JYAxHUkgIvLwW1nOkoS06LyewKRq4/cd+DkY/iBr0a+53XWelKKeeEveWLuMUAU4vOEu/mINvwnFmbGrgmdY6FP9Bucg5TcZnVnlTWe8Rixp5C1uUc7Ia3CZNeM6eKu+JwREGsgbW/PT3bGEMrl7wtEfpJZ15hNek6lEp6GuH8n4PosGI8az6x43yo3oAkdctiL9PN7e1L2fGtf/l1aIZ8QxeL7qU3SwkjsJSPKPoTs5xYdLgdf6kywS0AfCIFsGIH/7MhGb8cwMwc88lItTOigBXrrU1uM9WBe55DYPCJ119e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Greg,

On Mon, 20 Jul 2026 11:59:03 +0200, Greg KH wrote:

> Why is this a stable-only patch?  Did something go wrong with the
> backport of this commit that is not in the upstream version?

Sorry for the confusion!

This is a stable-only patch because this specific function was removed
in mainline starting from v6.2.

Therefore, this bug only affects v6.1.176 and v6.1.177 stable branches.
Mainline does not have this function anymore.

    $ git tag --contains 2f54908fae21
    v6.1.176
    v6.1.177

Let me know if you want me to resend with this explanation
explicitly noted in the commit message.

Best regards,
Rui Yan

