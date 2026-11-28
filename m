Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665D5606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 01:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=OMFS6n1U
Received: by kanga.kvack.org (Postfix)
	id 602FA6B05B2; Fri, 27 Nov 2026 20:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3FF6B05B3; Fri, 27 Nov 2026 20:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2AB6B05B4; Fri, 27 Nov 2026 20:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5D16B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:53:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EC9B140569
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:53:20 +0000 (UTC)
X-FDA: 85482855360.28.BEC8A26
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD93440008
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:53:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OMFS6n1U;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795830799;
	b=EYExIHxSw62PGL6VTE/2egkoVYLoGyQWzX7TLo1yUqltlvLv6vW1zgolqGE0FKgLehIQx/
	WPMhpijA2O5qM5Zb0xFX27mlWwFPNzVNfl72cTRfSFBJiUtHdkuNVH/tXECP5TLbOAJkfa
	Iq0AftoFwnhgjNWERdPdtUTnt11Kx6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795830799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyZ/R6k/xIQG/tPusrclgUu0QXpjH1Ks1DGOLNZIqaE=;
	b=1GU8UHVc7QSeyK838JWHxRgzl1h7RHg9iJVgcxdjH+i6OLGD7YRcLCUMkcGDUetj55fP4x
	mvVhxi1bhmOAJLE67iQVl2RVsELc+qRTvZevw4PgQ0zLpSVt1TQIE2bJZqMBAnMnLZN9RX
	qmzqqSb7y6AUZODFxjFIs5TMUOtA+Tk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OMFS6n1U;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc751eddf25so5453519a12.3
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795830797; x=1796435597; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hyZ/R6k/xIQG/tPusrclgUu0QXpjH1Ks1DGOLNZIqaE=;
        b=OMFS6n1U/OnDBIDS8v/4LlyVZh7lIt4n+4oh6xfy7H8IrOp+6nkqUL2zj3VFLd1Ani
         u8uKC3ojq1pr9SzREMIpUQJPa8ARkM1yjyASjAW8gqXhNjC4EqVxccPH8skzzAu0lMSz
         61uaD1iUwIL/vDbOnYTSQbT5yDBfsi8r9/lEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795830797; x=1796435597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hyZ/R6k/xIQG/tPusrclgUu0QXpjH1Ks1DGOLNZIqaE=;
        b=n2DfKIRY0tgdPbmv5/u3JTKGaSUPnCs+Xtf0I/LEFd3edoWa+lclhtRltm/1Er/0ow
         gPB6ITV6V4dWPCZK9aLQdphcLOjAWNGF2t+upe0fAVKBH/rbN6vVUr8KYHkSdptfa/z0
         3vKAbfBI84u/9YjqikKLoz9q04T3VWSIsoSlelWczC0DUu1uUVYr4FD1MFFSdX3Ql/g3
         EiokF/LcURhx8SMJ5WPpzq3l9LMcM1/UcpJdNDJ3CCpNK7/sMwQcPNHACNEywV2cJqh+
         xqO9/oGibd8Ojv+r+SDWsoJYd4hrPcihEx1prrSFqctHoroM8Hner1bnR4eKK2VITLjl
         MUiw==
X-Forwarded-Encrypted: i=1; AL+hErFLpLOdG8wQDZT7vbCjeLn2W2slOmYq0AsF9+4JG+BueA/WnAX3565dCzdWJ/obxw2PgK3Em2K4mw==@kvack.org
X-Gm-Message-State: APuU4Z/qScVaId8f1fqgj75gl5bi6WVSrTrzWdt0UaFcxlmUHeZcUTR3
	LO+aUOKEdJuIcMsKOe4RgFSMJTH9ZHCVEWyq5Q04DNPOhOB6ICXzZzgYnO7ZMcgbHQ==
X-Gm-Gg: AZFdTZeKMI7yRfXeLbMuQzy812qXhF/wJu5cQX3a3FzTSAhfe1+oBb0hvk6JcCGg+v2
	+x1mlWMG59WjrqFkseTjlKTRcwJ+9Cj5M2g74X/O5ZZS29MRHpTIaB4PgyB7SJE3ttbCgZFkTGi
	BM+dNeRH0EiXVD2J4Ykp+e4425G8J+lNv8WpFUQKPAoA76DKZ7W1SC2zSB0UvnCCl8FrIC73BQX
	CwmTSSkgNQKX6wcJ8wD+aIuDLbd0Oom4HUIwPhTa8yJ/ZDDYUtq5vExOLl40fRasTiWxi0rAgza
	0AKwdz8SaGZFSZeUfo4jJ1IrORw3AfKn9hbNXEC+il41czZeylUlzx6nD72FllxQ5Aj458Ncann
	GHxZdH7fxC6ULN3IlkNEROcMsadK2EfbK0vKzUIKEb8HKd0bWtEcxFdW98TQzMWZ1YNfbFNFeFd
	l54b1wL3jmLzuRxQJm9XerBEB0tiFBC7+TZHF27QYinIsgTUplwvrFjJZc4r8MKJEdtAagkutV+
	/xwO/hAIUaugNPP9R+o0XHh1XETVqvbwT8S61cpq2lIUuVexvy4SrI5uw0CVQeYZ34tPusO2+PT
	laMymxUJsRgrZpWCDwrPLpf+vKz90YtcmlAM7h7d/vrzMI1rGCryRDDWIKmgTBwpuS1nPw==
X-Received: by 2002:a17:90b:3d4d:b0:3ab:36c4:b502 with SMTP id 98e67ed59e1d1-3b41c90329emr26496488a91.30.1795830797454;
        Fri, 27 Nov 2026 17:53:17 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:6b7e:ff5:f0cb:5bb0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b4b3c71192sm24769916a91.5.2026.11.27.17.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 17:53:15 -0800 (PST)
Date: Sat, 28 Nov 2026 10:53:08 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: SJ Park <sj@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add mm and block lists to zram entry
Message-ID: <awozzzB7zkfAVBqE@google.com>
References: <20261127031658.2049871-1-senozhatsky@chromium.org>
 <20261127185347.87793-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127185347.87793-1-sj@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD93440008
X-Stat-Signature: aspph88akxrmk9eazmzcfhjai8uxgbzu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795830798-302585
X-HE-Meta: U2FsdGVkX1+L+xPppg3zs0D/lO+2CyD8cDjl1LRxVCYZMQdOKjbuD4G+oYpismZJRn+cglxdS5uMEabU0jiXbsvx+qcoqx57CQeaKsb8KImURgU3HWxOyKzROvKxdOKAuD5BCWLLGUXSauj+xJRzZNJ5wQlucdScQ4JQ4sZT327Dm8b01Cf8uAyAhna1HfwXqlhicA7Zb8YfE/XbXiTJkgR+CUJCtnmdtB/zsGLUO1b6FYsXHDxUP4j/PjKxWbMzReJ3X3Nkdhtp5kVzUjZuMPEYJwUX4sbq8PsvzMtgjomAgDvHSro2NLOhF6y08DGdzaZyv0ZJPmrro81p5Uvs1vxajMiKoamCo9n4CF4OcaGZVf+SbU2viF7k/S1r+ThvfroXSfjIztoJYcJpnOA5t+UX0get81OwN787WQLRGsMLpP87tOdI/UrDaiDeRJ3Qx/JiOyAF/5JxDVtoQGkAY/7NjQ23cA3WeWWF9se9fWKwekFQrhHmUPDjhNvBLf0osnmeUQZvxaE5B/tzyKPWyWw23/xY6bL+cRkSX3FUCMxRP10b4b05/1jflwf9bq5j6OPwz3f5XrA0BU5V+6hS6myHLpkhyvtd8lhf00KLaLdOwuSSNS4ciopI96n/PrScoONlasLEi+X2tYq8VqkTTjrM1Po0fOr6T2Iz1TfLxVJ9/bpnafWBDaFuHkUpdZ4TTJdb3KMCEb480LK+RPXtpaFdMlJRoR/3vlr7uZi4cz0kM+UoZfiuDQu5rZp+hPD7Qu6QcdH1Y+P2bpRQTWhR5r819V+qrj6er4woi/U+4L3aZEDpjp6ElsWQddeWDWX6m7vY3Vdw4DKgRgFUcIf9udr24d0t8OPbtCQw51gVR2MRLlQZ4wf9yihvKc3gyK/Ay67+Ja49+EG5WEU6yl6hrABInbk3ton1IByvs5fXfOokJrD2tvOB6Km3nVYAEWtJr61NVhnyl/YQ2nhOrxu
 jLQFPMOZ
 CZA457DgCya5GCjGk5Oh5TblNIzMWaF1CTL8Y+8Q6MV9ht752W4MxSnS/a0MkZ/ubHbsK6ggBpxXgcV1sBnX78QKtDbxUzcIQsoMEb12jbpJRKaold/UDTvfMgqrL+A4uA3dhR2UwXfuXiesPEH4uWHB/AVJELw517Q606bZmqNzr6wVwgsH89/JzoCYIbYUKDkkSbW89wXLje5P1Jz4lTWsnElVDSq/4Bznf+NeCHgIEefV5QhbD/ek6F67A6lshsw75C30aZ7hrX5/ZRg139T4AaPHOhEWAUNN/XJbO0Co73BzPO20/AS7QwQa2ACWht4np2TkiC0YPQ/pWY6+6esrHpefjBl6equdTpTrd9aX3A8TvLlhjoP2GL/EDKmYMy0Gnwi++q/msCsansjltbEfC2h2YvGVtT04u/gQvV8KiSG+yXK0VrULvclTiIfIW6ZYdbAk8hTAezsFXuRukZ/F43LhxMae1Vy9WcCtSzLd08iPQ+SUa25fmWkw5+RBtCTrySgpfxxEukbXdAibLazBmoQu11+2WL/3zn+NbOT1kW+tLFvoOhEeaNN+gWQ0NyLiF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/27 10:53), SJ Park wrote:
> On Fri, 27 Nov 2026 12:16:38 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > Route zram patches via linux-mm and linux-block lists,
> > rather than through the generic linux-kernel.
> > 
> > While at it, fix a DRVIER typo.
> > 
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

[.]

> >  
> > -ZRAM COMPRESSED RAM BLOCK DEVICE DRVIER
> > +ZRAM COMPRESSED RAM BLOCK DEVICE DRIVER
> 
> Thinking loud.  I was wondering what is changed here.  I found it is fixing the
> typo: s/drvier/driver/.

It is mentioned in the commit message, the last sentence :)

