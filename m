Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBD4CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 22:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230346B0008; Sat, 30 Aug 2025 18:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207386B000C; Sat, 30 Aug 2025 18:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1444A6B000D; Sat, 30 Aug 2025 18:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03FDC6B0008
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 18:31:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF2181602AC
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:31:28 +0000 (UTC)
X-FDA: 83834871456.14.0B565C0
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3EC2C0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 22:31:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvXWPywL;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756593086; a=rsa-sha256;
	cv=none;
	b=e00/I1Ny6J4VAV1+E+1XYf5nvddGnfbAuIwLwHnN/P4ZOEKgNPkPSQt6Kin4zFHBGoi9BP
	v0KyWroPQZcaA7gUot/nxgFj/sDa3Y7COV7KwQhViZoa8/jqgrye6qi6kEMQPWSj3Y5PWY
	0X5MFPCMrCf6GXK3POXeqyUxg3OaQRk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DvXWPywL;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756593086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dP10iBY6r2O6+u94mWJqPK9jcvtIXqc9gI+FX4Bha6Y=;
	b=41d/1ifUG5wdUzi5o/RzfRcETNu/MJgtdag/trqBkk3HDzkCMCV1fEvaPfRXeIuIg+HQze
	fVRxlZKR3Y+tT7GVw05Ca+HE/LLiJaSIbu6TlFSZNVJR9rTw16oqjYZmd4v8GfrIpJzov+
	kcAB8pLoNPTChHVIE7c2ZakcQlnC3IY=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b0411b83aafso56730566b.1
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 15:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756593085; x=1757197885; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dP10iBY6r2O6+u94mWJqPK9jcvtIXqc9gI+FX4Bha6Y=;
        b=DvXWPywL0U16fKNPxTcZPyhQmdRDFwvWSF7S07H3mmgOGYZ0DpKLMQ5CToHuPoMaB7
         wY/uUm6K3s5n7AsNUiS5vkB5zLwALvITS/gjzbWA24Nx4LmgqlptHs2bNe2tVqrdJqi3
         mDLw7G3cNSRBy0pzaBCrrlTxECaP0NNMCTKB3UpHgH+/bxLUV/WCJqGEFizXu0+splqC
         M6JFdHiBqB8J9l2COQkDQ/LLkTbMo364HU6eOmmCy8Hjk+qzXEmlZT8H8qPOpWdFHUoe
         iPe7qTkaED0amg+23BrLEmpGTQ2VtuACeyhMyt8HZR+WHFLqk4R/8lbDMT1Ivb2i7ACk
         f0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756593085; x=1757197885;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dP10iBY6r2O6+u94mWJqPK9jcvtIXqc9gI+FX4Bha6Y=;
        b=Bg1MePv1kvompeLcefcmPxXOAPgG123NIGlvfW/AmHc3wwDxGsGwO3xh3JVlxqX39L
         PCvZVaMiCmXN84o/rcSuHC0ubmck8ECII19WyM3s3HVL2Ln2RLxbdjpMa8wykqqDSLkL
         Z2Z1rSZFnuaA2U+3sQdbRMcy+x8jAEzxL2d3Y6b6+A5sm2Fz7JVRBjB3hFHnFUwkmIiy
         /TiCAQooK4M6N3Vmql246ozFgiRuYkgpnNCmSkan57ZkmHVJ3V9pfJ1pYPsIow/rtn2J
         gmc18DXEoxVbgauC6LdFGCOf5M3UPMFYrFKnH2qma88bIoZRws4+5Xu+ZB4OPT9xpjUv
         tnLA==
X-Forwarded-Encrypted: i=1; AJvYcCXVvNkaKodafaXbHwkTrcvB8hol8r9jaweLjw0lbW4E90C5Ax+MqFRCq6ZtHKiU9GplMrHYTyGinA==@kvack.org
X-Gm-Message-State: AOJu0YyyP65O587+JDSTDU6isb5RaExwhuuVHWd2BoqFaM+zGZ8sT21b
	jm/WiD1Dub30kEuNFDZAu1VHTE6ZiXMFw5KK6/3gfR0ulxHyQEydKd+a
X-Gm-Gg: ASbGncvYNMGOf/GVzx4a9OUBZIE2AXOzLxVAvIypFUeExJzzhfFTPfjqNwmxKgITcqM
	Qz1pKIrBkV8v9sz5EAlEYjOeURFrZ4E5BPoBKTZlmcmA24+KXpRFLhCKL23iDcV9LGvIONJxnx2
	nEFzjn87ZH3mamY/sUCduWFOZn3ZDHQ/TR3glVj6eUDTU+2bxTI8lnWJlLOddXQL++cEwTrM/ME
	bn8mh3O3bnYYc0bWw62OLFsQ9eqRuI6YFFRyR3AKe9CLErUNA+iAV5QgxuUiTkJdWHI027wLjl+
	jrx6Rid4bN/pdhY1x5ljWXdoZC7HYmP8PIUydUVQc4Zg+kPlMC3t40knikvndXXz7mNd7EDnvS0
	5DbpsGu9mdk7ez8KIB+p3rG4gPRxAXFJQpmk4
X-Google-Smtp-Source: AGHT+IES2Kjr0AOxsz7datcuUI0aZP8fHojgyxtf+KPZQhQeEJBGdpYaQY0OkpY0CwPNkhgAsv3e2Q==
X-Received: by 2002:a17:906:6a25:b0:ae3:6651:58ba with SMTP id a640c23a62f3a-b01d973ed1cmr265056466b.35.1756593085128;
        Sat, 30 Aug 2025 15:31:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcc6ea3esm491734066b.109.2025.08.30.15.31.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Aug 2025 15:31:24 -0700 (PDT)
Date: Sat, 30 Aug 2025 22:31:24 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: akpm@linux-foundation.org, richard.weiyang@gmail.com,
	Liam.Howlett@oracle.com, davem@davemloft.net, david@redhat.com,
	edumazet@google.com, gnoack@google.com, horms@kernel.org,
	kuba@kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, mic@digikod.net, ming.lei@redhat.com,
	pabeni@redhat.com, rppt@kernel.org, shuah@kernel.org,
	skhan@linuxfoundation.org, surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH v2 2/2] selftests: Replace relative includes with
 non-relative for kselftest.h and kselftest_harness.h
Message-ID: <20250830223124.zf6dhkeyn4hxgdvu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
 <20250830163949.20952-1-reddybalavignesh9979@gmail.com>
 <20250830163949.20952-3-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830163949.20952-3-reddybalavignesh9979@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3EC2C0005
X-Stat-Signature: i1og7owmiogiptc46746rt3sw691zcze
X-Rspam-User: 
X-HE-Tag: 1756593086-733691
X-HE-Meta: U2FsdGVkX1/H77NsUWA0plSL9fPrzrEdcjKzBOgIIqRmro4C7x8qEZC8C5yLhUmPMOAAfzccuiCMi2cZmEku1cZmJM+sct2T3oOtmJbgxrb3xDE/567TdACSxPE7wfrfeeDQJhEJSw7F5ydHoVKwEOvyWBxAo4YSJKyNIX0/vgKge0u151tIOZRml6ZpnrpOlaJojM3PthZejg+u/Ae5Af4qiwYs3YtvyXKFPbxIusBbwhe0yQ0RMnFCW26Q7XZcH8Lp0V3eh3A2bhUSxXJ/zR81OCFcITJclloJWMFpfjdBnHk3yLvKyYnRqu4hZFfzoc1XJzdbEZGQ8FGY2syiIixjMIRDqYwIdBY/nKNf/wHLCx4vyiZBdyYgUzHOIektS/vgCiSgEK9j1IJXSLjQcdBG+DOZCuwcGo9sL9dqJgzGTbyrlRJirH315rpDSzgWbATb5w0qzTlrOArH1FN5Y7Pc7W3nQ9x4vCMeg2fSx6uS5x7FCCJ6qQ3xGr5TwhQV/a7LtI0JN5d6ifDXS/iVO0jf0UIgthSQda3g1Q57ue+udoQxY7caOt0DGdKrLcGYdg5+awdAQDtCihs6rQ7lVL74RnpswbObXxTyZVhY03RtoejDwuA0sSNlHbFGahXv7Iu9n1r0vaCB3L/wubmK3o/lDVeIY/GEv3ERbp3jgtgmXQiF8i5B547iSuo3ufnq5tTJwIle6pk1SadVI9pkr7dUu3ym6HCtkD74M+k4v+3u4OgMqe5QZMe3egXTVyZmK8CFu5J2FrFdFSgXlJryjnL188Y1+NNEb1kPxZM6zWY9ABPmifbntQyC0XZg4Jn4Z7mT3RMiUE/wEgWU+7IKECeUlifeofTncSenUbKHmGhWU/o6JKDSsdXCsElTSJO3Q4+FsxAuUvwIQtFo+M5yoJWBt8tE11S1qu/QIVX8/FooSd8rIIiI5+jAcAz1/cB4Yhg9FqjDoxIqPFy3Cho
 +5p0bPrR
 w+looJYOyewcbI82CZBmNuZ03C/PaFCZEYnMxyayVm339Zvote+1c1U+c3vna4WMW6Jqwz4mNplEwXzqnmr4LY71p9uhSEKZ5/0v+gYJ6OqyHUhqqpBU2otxnVdZ+tQR+rEkHbFmLcr6Lrd3Zp/z8mlOoEE4aFVAaMF+yqO4MA2kmkw1xF7cQ01+GxBivEMH8xjKgRraBOwqjMw6kTJ/h2nDUU23Gqlt5X9FOel9fvUdgf173WkiFAjSGJyGgCaleThh6/WkfQe80ImMCFEu14y8ZYfDoUziJlGC2GzFwTbhpgRKccqaJuKtwrwBFETEsPUUbxZRiUUu2Q/P5psh4P6lfVz0lH6P8ridJUHHcoup27n9hw+2R0tdhLKpvUkvHNpkaCe11UMXZPd/Pog1iS7rs3f2etC2a4/mzqBUS/XSmV85GGAcqPfmkrKgdHmlWCU2+Okk+/rICDZofbEcJJlXgcrBhVjLnb3PEl4wpS7LUP06XEfi42vmbr30ZEr/+qXOO8MIFXieFoOqDIuitZR/oHUJh9EbShqCtEFnbU2f+w8oG9QHA27auStC4PG7k15lyIcxm1Zuw/NTlUjUl/gOcPQ8gU681YBxfibkt+e97wjvnY4Y/KmjOwFatxXfyGQ5Cib50XijCOPYpKOTDcmpHd4KjaQFeh47E7wJ6hq8TXn+0+SIFzeZaArUpj9AfduD+qrFL3sZoisPm8f7+MdEUXbd2rLvHFs3wFHaNvMNzPgzS701Ka3UrVen/fX50PblyjHPhjbaBtbFDpzvdjD1KDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 10:09:49PM +0530, Bala-Vignesh-Reddy wrote:
>Replaced relative path of kselftest.h and kselftest_harness.h
>to a non-relative path
>
>Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

Take a glace, LGTM.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

