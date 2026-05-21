Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F06CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 18:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100756B0095; Thu, 21 May 2026 14:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8A36B0096; Thu, 21 May 2026 14:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F996B009D; Thu, 21 May 2026 14:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E5F0F6B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:00:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85496120415
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:00:34 +0000 (UTC)
X-FDA: 84792191988.17.4FE9AD6
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFDF24001E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:00:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MipSMY4C;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779386432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fpbk6DPvyYML+NSWi9mMU4VfHIZbK/PcW4cHuFgQyhg=;
	b=NJCJdCLRPXU/p0YRgF2VtJxXxrXaANFjpmwNyDGJyNrpAtrAqSphCR/EZQk35vZragCs+K
	fAK4WdZZBRY7SD9/VQKkRtqMsAADXhfgXRpPJj9QrW9pMGzZfdMzAJQd5826LrnYN8sXP7
	mDL8+H0iYMArq77x1x5bY4MDNGD2zbU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MipSMY4C;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779386432; a=rsa-sha256;
	cv=none;
	b=GNZbiFvJkX/V7/5b+kltYm1MznkF9AYkVw/WNo/14rzTN/fGeoy7fDQwU0/1B6j36AAP29
	cNBkHo+52mpeGqnzwx1teVvRG8nHVnsaZGdJ+8Clu3jyO1dYUsr9HzlkQVnH1On41lxLpf
	5JDDDxkItukDWpQ0DqX72nnJUYSKhoQ=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8cc0ef7c306so23467046d6.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 11:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779386432; x=1779991232; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fpbk6DPvyYML+NSWi9mMU4VfHIZbK/PcW4cHuFgQyhg=;
        b=MipSMY4CgZraP4mJxwYVTYv119bDZBAHh5oaDSqkJMKo/VKbUIw0+svtTGIqDYkiqg
         hl2oZ2Rvj7JGjhRUlBrmpleWEM0KDFlDBe2tWJKXSYyAa8bWw5HVO2i5wdY3M/HkvS6y
         JP8CAnW4SXaVJSSga8rv0/nB/DXwpz8nbeBzHFXBq53WCU/1QPhWfbwf0c/1IJAdnY4r
         plUCcFiVINq4KVIYDhHgd6MIW8hzm22CDcVNXixCGYDJd4PARgp5P/kpCOgW2cllS1C8
         /8xfzmzvOAqtubcZdBih3zweSfLYT85JMdLxaTokO6J6VFyCy6IKSjBRFR2DCyJaSZot
         C49A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779386432; x=1779991232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fpbk6DPvyYML+NSWi9mMU4VfHIZbK/PcW4cHuFgQyhg=;
        b=TY9xq9x129DkHaCGafX+ZlhE9VJdh8yUAB6P0PDyxHMUDN/vpaWhD78+lBBXChWdpQ
         nOdhHBrV0f7aynoOGsu0eP1LW5nLu+b/iEq1X1ooSdbN1BVkmwtH1Ggl8mejs86VqgZp
         x8EUA7LJ8YeQYi11CNK2yt9tdYofOwJ2NjPt8xRbfWKogxNwdXnTwineWoDEvy3EuFQ4
         ROBSQ64/Qbfv6RBI17TpgSTtZfNZu4rgtx4zj8DvK9VE7r3A2sHofL8Mn5uksCG3rkg6
         ttq3NpNId/0BMGp++f7M7Agalz/kDuY8+B9QwmDr7LF1TlAKhdJrOS4r2iFoQMHAyG9/
         qeCA==
X-Forwarded-Encrypted: i=1; AFNElJ+KH/kg1IWqzdeUvGaYTBaJck2hAPg7MR1sE6OyYNy7VJV1IBEQZScH6nfSr6ktvktwsPXIvA6BZA==@kvack.org
X-Gm-Message-State: AOJu0YxzFIe2xaECj5P5zmFJE3YsIY6j2m4bnuHKGRyBjkWY5mF+4R+O
	pZOnr95YI+rXLyjCqlyAqVhXtWkXRt9ddw1HuM6DkLVrKpi1RJAM8UliBlNnS/ZL88RJsV/VXzX
	f9NEK
X-Gm-Gg: Acq92OF+Ve9t2+Qle23Te53r4Mk1I9zmfxBVG4r5uDY4giezfKOIPkNZMO6D7zUO0Ca
	OqWP8doBmfNGvLUrk8wIoe1JgTHdxljynlLi8eFkxDsEdi/VYEA5gw0lzjCkSfIR7S8rjboa96H
	y+EyN6l7LN5iiML6cbqIJcuS0LTsprZXNfDrjbC7NSC1RfRr7zlbZ1ToMIIsMpr3ZmC8ygJyQai
	qyH2ST0acZJQ1HfhXMaMbHu6yVXiZwZrrRWzAVuXafGCTrPslwd/tRGILNoE/Jm3kyVD9Gcz716
	RAqGWYr9t9ssfJZoojRdK2AbUu7UOsA1oVBxJHIcEd8NvHzFkOteuZdmR1BggP1Ywc2DoENL8jp
	Ggk8YhY6+xJ7Zvz1VPaFqYI1ky1g5qYGI+nbWIVZ/y8LlAqiCygOswlGzyml3VZ8Xmc/AAcDLlG
	QSBNFjajzsurmATyFxzqMa4OobR6/dTYeX50TY5AkbD6GGuBGtgFoI4A4dxbe07Q==
X-Received: by 2002:a05:6214:5c43:b0:8ac:9fc3:b9fb with SMTP id 6a1803df08f44-8cc7b5d5584mr6556796d6.45.1779386431403;
        Thu, 21 May 2026 11:00:31 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc781f7a88sm12544246d6.43.2026.05.21.11.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 11:00:31 -0700 (PDT)
Date: Thu, 21 May 2026 18:00:30 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: luca.boccassi@gmail.com, kexec@lists.infradead.org, linux-mm@kvack.org, 
	pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] liveupdate: document systemd support
Message-ID: <ag9HpKdDuu7LvL3N@plex>
References: <20260519152957.548119-1-luca.boccassi@gmail.com>
 <2vxzbje8944z.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzbje8944z.fsf@kernel.org>
X-Stat-Signature: o9rytxoiqmrkrqhyg638iba6d6enn7cq
X-Rspamd-Queue-Id: AFDF24001E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779386432-536193
X-HE-Meta: U2FsdGVkX1/5dUpni9qiVjl2ds+fuKpA5FaY6tixYWN+syvN5+a1TlqfiGo0zPotTvLO/jnST4Poax5Z1D7NRLEdg2+psq42M/KpwRPTMbtReu2YEE1ZwXG5ewgmUiZLKZdJVTSTYi6xAw3c9ZnpUba8YrEyLn3cBjaPDxRS8ikGfDSSl80yVv+g1BvtcqlrWmKdXxDsgjNmOBvzkuJiH6HvkLlZFR00c0Ps+Ty8dGiIcMXwn68dGYzXoJWPUwgO/3qA8IATP/rwj0SQw0v1+9ynH7UWT4iHClxfdDDv+v4BPbKDbmV9vKgtlRITBkCo7Q/ecOVE+UxUtemeUHNlPKSgcb4JGd1oiZV+uztjXOdN89bfS60ia1CfazzX5PwLmlwHP5zwT7SwnuM44n32IVXP0AidfNBc5ZFEuGtkl46Kamv5wvr7z0pHF2lMuj3Z2R9R6VTRm+gxLeTrejJjH40oyjTiDmwQ8b3HOjisBm2mf5RaivYp8W02Ouwzbg1CDXRJKwcjsHQxakf8oGsBReO+bZDtD3LvaTghMPKtuw71Yc6pS6Beheo1662dsFmMje29ZsDJMyFxaxEHDNY8jMdMwKbSdasm9TCuYtzx7llXcMwGYPwcPhnXHj1lRc/MQijcmEcy4dLykYJ7sObYq76L0A5N10o24Q9Eko/brDV35fFOP+oaLRtZnof5TP9U4gSvZ8Tv+go7O0r4OrSH2Ro/OD2Ws3vsLW3cLG4d6hd4RWFBpb4TEJPJpboPBNrRS/h5vl7LBD+U3y+ge66a7u4fv/jNIhw4AbsPS3GUvVYbYYaDKJNJ8g/qBi5iPXGGU+P8h/L+KIvmTFE4m5/2Kg9B0auSYh2F26rweNVinI3IzD+o2V4AEPKJwhCqkWsn2/3tGEbTMbkcgZFb7t8ERmtJkj4YRnJQtqZEObQLBOy7NofdcR4G6DzcY5D6u7EVdSVoy1vGgxNUo6d0kf9
 oyADGIwa
 86q03AYZmu9U1nW8fzIlyzR9vaMZTmAil2fn66zFpZzPwjtXXGbHaJzUlMY9/nYERSbyvg6UjP6B8m0hj5XgxFmVEYeaj7CWdcrXp5OXXUrSX9igRDN1GK3NdWpIrZ1RZ6RHobp5Lx72BD65NPgRIFlRCbosD56ojfDIObHB3Jjv0NPlMTrRukA12vNN/7WXCRzLXoWDki3TP3AQ8J2iR1b5Msn9ZBWW8PH4ma5zKSP5RATso/kDZEBQyNYbKtEA7qDAbG4qJCnNPepvXBmgD+c5xUuzVRSK4cEWNzYEahfHXslZzQzdYgwWm+ulhRy0xLCYDB8pn9gpCc/SoY8BKA6Uh4F8dfNaLZp1c38QOZnw/5zBAfQgSHIjW3VRpBJRR3OzylbcUxwWjRTP29FJ9v/ulAWQkiClPovB8s5YORkk1CoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-21 17:25, Pratyush Yadav wrote:
> On Tue, May 19 2026, luca.boccassi@gmail.com wrote:
> 
> > From: Luca Boccassi <luca.boccassi@gmail.com>
> >
> > systemd v261 will add native support for LUO via the file descriptor
> > store mechanism. Add a brief paragraph in the LUO userspace documentation
> > page to inform users.
> >
> > Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Acked-by: Pratyush Yadav <pratyush@kernel.org>
> 
> But of course, we should only apply this once systemd v261 is released.

I think, time wise it is fair just to add it to liveupdate/next branch 
instead of micro-mange the exact time when this lands.

Pasha

> 
> > ---
> > NOTE: the external links will mention LUO after the next release is
> >       published, which should happen within ~4 weeks
> >
> 
> -- 
> Regards,
> Pratyush Yadav

