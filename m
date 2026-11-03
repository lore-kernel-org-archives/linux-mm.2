Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE6A6072CA6
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ji/KLjH5
Received: by kanga.kvack.org (Postfix)
	id 52E176B05B4; Tue,  3 Nov 2026 05:34:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE766B05B7; Tue,  3 Nov 2026 05:34:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CDCD6B05B9; Tue,  3 Nov 2026 05:34:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7656B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:34:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95D101C35BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:34:25 +0000 (UTC)
X-FDA: 85393448490.07.4B49895
Received: from mail-oo2-f11.google.com (mail-oo2-f11.google.com [74.125.231.139])
	by imf08.hostedemail.com (Postfix) with ESMTP id B0F4F160002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:34:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Ji/KLjH5";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.139 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793702063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XOmN6uI5+wry7lHPZoeSnGmX96UmyVh3KKEQZr7ankQ=;
	b=y9GJKTJZ7mq/2PPRWkEQ0OnVHMV4Y5116zSdfOMTTyg2oK97p3VkmjRPyl8xvSdy/GCiZ3
	xZlDfz/jXQ6jnVRfPjWrK1swhSQ1RxJfJ72FNSy3KfHD685MLgVAqwANOEFZXZ2IT3qCHb
	8mCJnoKkAM6YeMfyxSR3dW1HIPBPWKw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Ji/KLjH5";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.231.139 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793702063;
	b=78FEdcp6eSCnX5ezx8n3jQI6al7kK/TNfbGyrmJW+xcSqQrFS7EvkP8q9O7WJB3FOdsthH
	MZ0wEKWDpihvRJG9zEifTe/gcavt4Dga0xuhw8Jks2nQnSfMOUN9xnDitkcdEGwvO7jTmk
	aSmoMjQ+O1z9Ze1a3wHxuQvUeLiBO4k=
Received: by mail-oo2-f11.google.com with SMTP id 46e09a7af769-828c0b569f6so1525218a34.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:34:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793702062; cv=none;
        d=google.com; s=arc-20260327;
        b=MBhtG1rR99u8b8CcTty1MCiVevwCYRfbNrnH1MHzfdCadko1RwR6xBeEgAZbIINDA7
         0fEpqPncI775Fab1HR31AzaIvWS1PD5Cwy4XLkLHKj+yOihHuTmoK+JEmk/muGDeGHi1
         OMtlyiMasDPeDl3N/RRjDLHtFMyZScQ6bV4H8D+imUlU0ty3u18ToZT9qwTI0FICHV5g
         bwC2kOlUa4dkOwBz6b/oIB3P/kNYehQFRzKFlDd3cE8go2C7McYBvSONLvCQHwB2hRVz
         fsIL1/HXnSvuJWG2XQ/c9tJOmVrmMqvRORW6mJA6WDWENXSMrOrLCyD0rf3GAm8KgUfV
         jYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=XOmN6uI5+wry7lHPZoeSnGmX96UmyVh3KKEQZr7ankQ=;
        fh=TNPsZfin74RA3S0Mb30LQx1PjFD8iADRghDCJnUQptY=;
        b=pIrgPFEXX9lc9JOSGb7TCpiQ7kaZS0K8QO/8rXcA9eemqnDRc46LmShwGpCy6APrGA
         327HyYTgrHBLISFYMqNtAalFkPVlaqOYC2vXVKpZAo5I5MILtCe7oUb9yr9BxMU8DHqt
         xKQdpQItWaSmg2GQiHKKPIjVamp45vhqqhCrktEb8t7sXWsXnrhTanY5SsRYpEzJFWLa
         U9pteGJwKthY6EQp7Td6foI0sjvs7e0yj9/dQNVz9w8X/T3vu7/20t28+glBZ5rkpZM0
         nBErcaC/icniWk/CfwhnUUzXenTYd5mrFBuX6ybNxdEaeJGzBzKTe+IvN2diZAUjHwnJ
         WCgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793702062; x=1794306862; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XOmN6uI5+wry7lHPZoeSnGmX96UmyVh3KKEQZr7ankQ=;
        b=Ji/KLjH59MdIyy4ECCglmgzS/66Y3mLOD1dJpyXtD0UfrJL2XIoxmkEP2nJvJFpJIe
         56sksw7jUyEoZkqpV8gXlo1iMkd7IxL6yQrkSrs7FNCXW+t3yDTngpwhdsPcdis2ssJE
         b3aTwGRwrbzIf43pP6pvg8ce1J8HbfWP9xOPH85TPCegt2PViEco2/HRlWJeLTxdzrmX
         CurCZPe2nTWXA+7lYS12EvZ6KuJOZNKoO08rB/zrZ9Ob9p3Rp1nBvjQlkv1Ugsme0vWC
         /68sxusrnAcH7qwsFtLPH5zUns+8yOqNF/wmvCzChsaR4BX/4t+GViDsKvYrV+vQPKJH
         k5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793702062; x=1794306862;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XOmN6uI5+wry7lHPZoeSnGmX96UmyVh3KKEQZr7ankQ=;
        b=umeH+VPYrTTZR8cBAgLqn8fs5yaSPS0KHqtLEcdJCV+GubCBRdVFTfpu8hHOMtdIFN
         vBNjEbAaAn9nj1X3aGYmK4M6pMBG4aLIuZOfeqP4FDV1FptX24oImdJCBUOd+llD6ziG
         13ZT/fW6y8OPXCxC17o4A6nTWf3mBR5S+MLqIy9hkdqXrbFR4x/ATkRVx+BnCd7SxN5I
         eT5w6hMiA7Nb1hRjy7CtZuKXKAMucm4O3roNUjlZu6jFS+/1KQ4A1kxiZ8t+RN/RNbfA
         yZ3p+lVL+d73xAjjo/yPnBzU63aezCQ47epwXBPRjiGPnprhFCKI5Mj1p8XH/RM5AFge
         MvLQ==
X-Forwarded-Encrypted: i=1; AKwUvBwM+zr30e+v2Be2jlWPrcVLUrF/ebzzpjjmEbkuMC0gDxrkIrgNgjh3aTMtxyFlk2ulXFvItBgG/w==@kvack.org
X-Gm-Message-State: APuU4Z8eEZMzGlnmqITL+lTzK/s00qzrx9OrhQDROooWU8WCVFB/zD0K
	yz4bNSWqsIGV9bt5vyyBUK8+OPhVXkosvKomkD5OQCnKZR9EcH5SouwFmDTFqGtxbwQX8PsODMb
	Ql3DPAOz7F4aX0JMoA+E9JstPLK/oXGo=
X-Gm-Gg: AYBFou2SIxhLhRPGXUw+jl1mR6QvBS2aWJiyefKI0gZ6GVXRIBtVPrzCouZpgm28XTs
	um2kWdAGy9+gmoaxIHbBtIDfLH8A0TweMU6+NmNRTRPN5eRQhHXRnrxWIPj7B0h/S9NAbx/K7Co
	JRDWlaDg180bfnv3b/qQhImJfd7feM4G752tzff67KvHJy1Na70fmoYxgk0gN7HaXoH5ks0Fo3W
	7SbOOe4tmuNahGALBWXDUIxasjRrSWoiLEYL62taN2ar7M0JV3K8+0qCZRJHdsdIV6lngxjrL0E
	/mnM8WzujurDBcSfai1iQUbkp4FvhXJVpPkvbGcNefVe6mbFam1T2u0AB0ZfX8x8tKJDdD9Nmmq
	Du3e3JZBhMcdNRgvJEClse7ayBlUAemikQ4jBsTMd4cjLp/qVhT5vqoz+ZFZ5AOBwtl8WGw==
X-Received: by 2002:a05:6808:17a3:b0:4ec:4c7e:37b5 with SMTP id
 5614622812f47-5640ddb4f38mr7698087b6e.29.1793702062547; Tue, 03 Nov 2026
 02:34:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025164619.89992-1-dennylin0707@gmail.com>
 <at9xXRhD2xZhszEj@thinkstation> <xmp7ni65vbinfj4j2baisrhp6xzro3asbepuq7xp3mvx6maptn@r4dnoj63uw4t>
 <at-XtWBQg3jv3H8Z@thinkstation>
In-Reply-To: <at-XtWBQg3jv3H8Z@thinkstation>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Tue, 3 Nov 2026 02:34:11 -0800
X-Gm-Features: AclHuK9ZD1xD5M3EAerFCyanz0JIq-n7E7W9-r11Oa-jyzsbvAJqtwo7Cf6PVcU
Message-ID: <CAGEkeHfq1xZf_jMw9a9cz3iunj6O3UZ4-=iW-65aN2Ss0oT3Uw@mail.gmail.com>
Subject: Re: [PATCH] shmem: do not extend i_size when no data was copied
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Jan Kara <jack@suse.cz>, willy@infradead.org, hughd@google.com, 
	baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B0F4F160002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: j5bib8819g9qswd6uoeoe8s83xstpg7w
X-HE-Tag: 1793702063-5851
X-HE-Meta: U2FsdGVkX1+HQBn8BQQCYDqHJljY+8ourw8Gwe+g2OG65dKM3asMDIRE2cSodQYkXUxU+rvmdKOgtJ1urvdAsJh+ANEKgiXwHKRP+zumBeaq1PZYbAibLGzR4kUL+JtNumFraRg/9RdGjYKH7dqQ6LkbCAyBROqhhwiu7+u0kOYTtS6HKNIfYEb0pGkTD6ApGNP+UdY2/Qx/AoWxglNtgfv+oWQWnf0XVx5g8xYNz9IFVPZFG4yKuStBq5eLOz4Jmj1WEGtRIIojybYvFt3Vyw7s6hUsG3MeePMBicBJlzQa+DH0ShGy7rRoWnt6vTgVDiY01yzHY4GREVXFTt5USeXvYgWD+acZD8TRBKWgMjmkFXYR5liB5HAG3zwC7wVOknhdj4xNOvBDZsC8TopTf/gAmg/kyt9A1MEd0mGFoyUgA8G9TKHmm1VAFvPal2o32bN8hplov/axCN5/6sqOLcJ9F2k0eISS87BSAtPJVk8hVbu4SaBNXYLEf/gNltrMufx00+nOpnTHqidan8Ma58738a3wbLQ/Akec2qgumJVAMzToBkvalcqBQu3sFjDsAtTnzHBtjFlomwyeO9Gn9Dgbfe/vjXZpixdlAFBUfY1Shtmt+a/Jg8bbr+2WcmJ/HqUA6xPVNQn1SPI5dRm6l/aW5on2njMu69IIO1LNEl0Cwg3Q79ruCtNNgpAXhVf+ZPfNAigFtvXq3xuYc13oyL2h5iyDEOdPG1z+EoZ45FI5XQ6r2zymlVGIeaKrq/nwUpxUEiPWRi+w5o6a6UobFcrueiGuJpK/rpoaix5PRBBCbdcDK0vuKveI6tBUqXqwkLUNZ3BV1jZqR0pR7Gcul/W/4CcKT/ec/6YdmdrKSCe0Via+rTe/RGT/VESfi4B51nWRL31brooworfyaCwZyEl8JjSVF+TyBAeX7FMBBV2ImIacPZWboxMPoQtO2I8pdkvDGIkL2u07+IICJMV
 wQS6xQ7N
 lzkVUI5a4vfzAxXXy4JuDyKr5GyeTnLnprcjpl2Z2U9h2sLo+PkonimTSN3nGZLYqZn/Gb3XRzs1IuMuezTvu9hBNJYpCl8BUxmw06fFz03Y1PPnct2HH0y1hJg92o43J4JYm/t4MJqXI07MbI/IUa8jpb5U4Cz2HGTtejR+ju8e0izdfhCKoY45Gp8et2TNleNTM++zLCXK0e3hoJB3vEU8PbUjd7kZMJQrFAuaiYOecJu7KmEuX7DU+KIBDiG5P26ORl0qsGuz4Tvht5Bsreyh/BT6pCUQwwwShDDaASCMoWkyEOH9vtGVvLHbRB4e7htZjps0GoV53w4HwuP7NvfoC0X9Fmmkb0noKqu0rktaQ13nTadxwc5X4Fs4Fj9uScqbOscwbs0EHOslzKCcjGPI3k5x37H1WUPzwxHNCVtkiDWUjgfT+gZ2qewQZEZY274Cg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 06:18:39PM +0000, Kiryl Shutsemau wrote:
> The per-filesystem alternative is a 'copied &&' in every ->write_end.

Would it make sense to keep this fix local to shmem for now?
I'll check the folio handling before sending v2.

Thanks,
Hungyu

