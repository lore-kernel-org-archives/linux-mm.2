Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8285FE9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666D76B0088; Thu, 19 Feb 2026 02:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 613736B0089; Thu, 19 Feb 2026 02:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F58F6B008A; Thu, 19 Feb 2026 02:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0A16B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:44:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDA0313AFD2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:44:29 +0000 (UTC)
X-FDA: 84460418658.10.BD7E3FD
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id B5F401C0008
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:44:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NZN3NIFS;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771487067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiNigTXvKFQq/mQsA2lOiDoUz3cg+K90vNti2KDBySo=;
	b=u5q5s8sh7zfbWkLNkrT+AUnKpAQxHPhtOcJZOD4WKUlGUd4DkSPNV7I4Cz1DoVf8wGFBHr
	1xH3b42/ExlvoGwCo8VgzEwCC/As5G9RbkXWyJ4ZJyRCYtvu861MWE0IyR8PtrUcrcmLMO
	DlFn1QUlPynr9flXIIgimwOwQ2fppGk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=NZN3NIFS;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771487067; a=rsa-sha256;
	cv=none;
	b=MwLf3U3LVvGA92Q9T0AusrTs6SeRJnrCkJohWvVdraKgo8Xxi5nP5+Nl/l15cYLS4nmMDk
	XDqJdCt2zKqiF8yRn0T7Aag8nsbSFOPFYZ1Wf4dHk+7aJzon45Kf0Mf+L3DRKBudZKHNVV
	IJa/axOhBzZO2TChREvykwx41IOmBcU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65a3fdeb7d9so800411a12.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1771487066; x=1772091866; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fiNigTXvKFQq/mQsA2lOiDoUz3cg+K90vNti2KDBySo=;
        b=NZN3NIFSkhBOrtxi/UB7lvWK1dNGwj2MsjRfy+xJJAXbQ76XFGkxEmcoKLJgSy53K2
         yZx6de3NasXk+8U9fiJu53W3oDfSSSAHgkQHsD2fmpLgm9oh8eB+aDK9LBHdi2awbSPt
         BG5pA+WBi7rJ6isM/SVWXwbD9A2g79r5OpJDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771487066; x=1772091866;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiNigTXvKFQq/mQsA2lOiDoUz3cg+K90vNti2KDBySo=;
        b=Zr64oWNGGzVXo/h86NzSv8hXvkU9lb7A/Gyij7V5nFW1PnQ7wXLEai924rCCfJe/HW
         hao5MKd1NB2AthMSSpJHZ3oIGTQOiUkEIquikyOMJaCzWED/O1KkBOoCsXT5WfwEnbCg
         2ABMWTY97zotLF27sBhsh/7aO148ZAY9QKr2g74Nw0C695asFW85wAEP9kzgzcOFUriL
         u963w//ewL56V87c/JNy5o1seKFWcegbMgzHBeJfpH8DzHMuQCfNAAMwFX6vZLeW0+p7
         DtG8FFcPlmTFnP6adfHplKxly/7WCkaZ4D1Hx7WBALFC6/GLL+lP1SG68Yum3oL71xMu
         OfoA==
X-Gm-Message-State: AOJu0YwzMdJvvkKaBofaERnOAqWF9Q12qe+QdkvD2yxBm2c1flkTJivF
	pZLgFZyiVEV83opL7prerVRE8AiXOvOapN7facfHr9kpdalkiNNO6Av2DQIgv/ErPSOyO0IGs2X
	rDV0qdcj/kA==
X-Gm-Gg: AZuq6aJUA/rdqTc0+B5mVOX3upNFHfBzizPinEhXCdE3xG94Nq/5Pzn/tXV6EpZlh6H
	3fFZaiS7XBvaADQ0AzXYVFIy6Ay7Rd87ircQ7pjY0buRvdCExUfgMW8C5qD1tKAWPNi5lyiPhKU
	6o2XVvxZN9DvfFUNQFAYD9AJohOpbs/ykvSAMczPMDmRvWsH3WyAkmAMa8serqdIArJAkkqhJ5I
	QXAKZSTNzE8fzJpC/edq2BZbogPBSS0ASgpF3dPpb1XvHFNQmS3ZNpGBxLAQT6mFmZJhuPAqbzn
	sApZWOTvyceBsiRzjK2IPRcrmcPfB6VOjjFQXtjV0lJLTaCKDJ6ElCacBAIxeiBW2c4QwPEAZk3
	9z40RhXPYDreAnCSZ2A33VDBHIkLr2Gjyf0bCAN/uGX3FCYCfxBnINJV5ItAJRfAOh+kv3vzt/T
	cXETNMzT3i+wvp4Oie4n7aPsBGMUUIKO2lDnb1g3mdrn7MjsvIPadKjBjyCNWNUX13SAIEsXY=
X-Received: by 2002:a05:6402:5202:b0:658:323d:1b3d with SMTP id 4fb4d7f45d1cf-65bb0c162d8mr10789053a12.0.1771487065638;
        Wed, 18 Feb 2026 23:44:25 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad3e3ae4sm3680456a12.21.2026.02.18.23.44.25
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Feb 2026 23:44:25 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so108754166b.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:44:25 -0800 (PST)
X-Received: by 2002:a17:907:3d8c:b0:b8e:92e:d316 with SMTP id
 a640c23a62f3a-b8fb452e7d1mr1091137466b.56.1771487064956; Wed, 18 Feb 2026
 23:44:24 -0800 (PST)
MIME-Version: 1.0
References: <20260218200016.8906fb904af9439e7b496327@linux-foundation.org>
In-Reply-To: <20260218200016.8906fb904af9439e7b496327@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 18 Feb 2026 23:44:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjY6+W+E7oVEZDUB6cH-HN5nUzEn_2R84aT+mJoYUM+tw@mail.gmail.com>
X-Gm-Features: AaiRm51-lSIF1gl1yENxwN-64AXieqI8d_Mw3Zg5Jo88la1acanf7LSZ4kfat6I
Message-ID: <CAHk-=wjY6+W+E7oVEZDUB6cH-HN5nUzEn_2R84aT+mJoYUM+tw@mail.gmail.com>
Subject: Re: {GIT PULL] additional MM updates for 7.0-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B5F401C0008
X-Stat-Signature: ds1pqoo4rtmf56zobzofzxwf1bowecpa
X-HE-Tag: 1771487067-788163
X-HE-Meta: U2FsdGVkX19tLO0CTS7wJJZZXTb/v5hLe6p2o473CT9gvA3ozA+sAjxqQBdjGum5KAWqgCW7t5MDIIz4ZM5Rrc4ZbkzTOhZUU/SgiB4wCIIPoO/fmQOGXa0n6pygliOaV3d7RCgELrn5A1GyY8BkS9+aOk0pC+WTBPF1E8/dPlmsSHaBu2QMo6C+BeGYndzdyj54YwUQekIlGLpB07OSQGJVV3PjJ/WSKhC/viwJwHF8bn9SeuL2yUPtdA4UMsgP/rqH/GF2pPiyIMo50jC4puDVaq/BgmFFOd4yRUKb/k2vlrAwjFJPj2MhDiBtLWStvJvNonn6AtYrlGSvX4XzQajzwClAOIhdwudBqdN/7AZW7Ty9xSiMaf5oDI9EPHVTFG2vyT3XMDE0WHKYjVsBTKD4fZKNrRxe3Rv3B/7yH0oEP9UAE0+pFqwMIC54nskEXhwxwz4AbVXhpCa0xXUGdkPAnNxlje0GeUYTnPbE4Rbc9JFkJYbVl3Qj/gqM6qHkLXdNDuWfureNcOxXGsrZ2hxKGp+zdVYjsjdYgYyb/nTejdp8w+EvleG9hdOL96ZnkYy6WKIFvDk8AbeDtTmOozk2MDLdK1Kl2mL2PFcxM7Bxk7M/uZgngYArwESW0nqXGa/hHP3hqbppPoVEV7qh/DbUlK+iTz+4svddfXjD9I3QGMQgNNSVbNmNjfENCrClsU6D6G8t6zjdoKEEc8PVAo9Z6bWYCqsoM59NKieEblKgTCLL2X4ua0G/LYDG51dbLMjqMHityU9FJUBwIzPaTWkTOAHB06DDMlTfxo3qO3yw2nG96ZRC10jnOO+Dyxsy7tGoZRiBAhNo1uU56WSwGAnQQawW4UBq5Le3cpEsXuGGnX3q+6c/ZsQqbx2ra8GAfKlSRZvdq7qJ1tgla62bLZpaM/Ism3HibWomAYz0CN02H5K0FbAnN9rTU/P1HOP9FPHU09UZOVpgvh2OHPg
 2fDgIaf7
 LJB6moXiFOywyKDYsRwC6rKYi4NE/pJuVJUPPXzjXAjZKqH8yCzeU1MgQhF5JMUa+GEyp1aMfyH0VwlY2hHhxglwO8lXoKBCbWRR7ykkEsiBOFIpMFXoCzENjpyVRTCz8dk0tWvPGdDN6+wsJSJ4zf9KV3Y3kB1TBsr9N2QLZ/7BOef1zAbB7KPJ6p9zry+hwQO1NlKBVUOUhO0/syMmoGTv/npoBzalFERQTxZZADhkvfyw0mItepbPLbN6bMIKVj6YH7/t0jll36bvZQ46UoYzKr29gzjXxh/3BP4IxxhnrYusrcMfrJ8Bt6hMCy0WACosIqjV3gbavWodyIEib80rX3IJFea7+k6sTehkRb7SVa6IduVY2IrP9ReDkPGglUI2jaSJY3crHxYQp5jnKLFZK+n6pkbtFkWYbNllv89KrAC53UsGjGf3O4K0V7RFLI8RL8A8g80l6LEw8baye/j5LIpyS59+M78Fkq93jp/lMKqhuCiijmOj98PfIOhdzj7S3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Feb 2026 at 20:00, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-18-19-48

I'm not sure why pr-tracker-bot doesn't seem to react to this having
been pulled. It reacted to the non-MM one.

Anyway, here's the manual "it's been pulled"

             Linus

