Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF06BFF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7086B008C; Tue, 31 Mar 2026 13:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E796B0095; Tue, 31 Mar 2026 13:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3E56B0096; Tue, 31 Mar 2026 13:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06D836B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:50:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3862C422D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:50:57 +0000 (UTC)
X-FDA: 84607098954.28.D94A077
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id A98BF140011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:50:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J3fCEuap;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774979455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSpt569BZn9s9W7oEJMwarKmLrOigBiTyhQtatPKvaw=;
	b=CCiG34M0/ZIAjXJKYyTyalKUbyLECb5HUTUPFgnOq6I721brAErYAN5YD5997JE4JXDrPq
	YZMOt/9LVBCyR3LvOWSveh31D9OQrsmwIWiZB+7f2E0OOSF6sq/zfYZdNDyH/2Asn9FqZd
	PPp68CCfkR7mjFYN28zgphbBEe8jDyI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J3fCEuap;
	spf=pass (imf23.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774979455; a=rsa-sha256;
	cv=none;
	b=rfPlJsBF4G785UxAmqGMoNTakrOZjcLSHhQ9fQjiL99Jt3qzXBsyj8wQS8cUPQ3Sd6MJVZ
	7yp1hdmPQw0whnWyyY5+kQR1rUYM+/JEGtWXonZQrZwJOm8lO4XwJjNrHyIvbDqY6aJxWQ
	PznD+DFDVDpgkFXAmlVsV0QYNCoVrmg=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38ad12fb595so1145161fa.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774979454; x=1775584254; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lSpt569BZn9s9W7oEJMwarKmLrOigBiTyhQtatPKvaw=;
        b=J3fCEuap5w3DfSWhR0CWA7bOLtELBxe4jaSZ1xjr7//a1HhMJ2rFLIwB/sobvqzOEr
         T9DO/PzMAVwZGwJUf2EqHGRj51FWPvLNUCzihY5f+EBznujPOHUfEFYscdurcloLkIa/
         fRDAWFYCvR4S2YPlXxjqWUsDdfVm5qHCRN7j5oQ03Kv4ULCc0EgxMYz0YYZPGbTO2Zcu
         gYGUHnA3Q6mHSIFBo8RajYJUsSc0Ij6Kma62YWDu905ZIfM2SdGJ60+tHgZz2uEShLF+
         zHn2M89CmRHxxws9fwcTkJKuw/aZDmMhf8uVveJDmI2Bel/i+9ElFy1TrcSuAtRhsQ48
         3tUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979454; x=1775584254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lSpt569BZn9s9W7oEJMwarKmLrOigBiTyhQtatPKvaw=;
        b=PzRjpmg5l9n5Jlv8y2TfHXK+dGtIghgJgfFjZz5nbJNh/4UEuube8xzI0ddCGeGd3j
         V0NlSpKBDw0n+dngOSnCBxezDbjf1DOTW1GTkKSSzhSqa1TnuhwslDUDa4gzAV4nxqFh
         KiVp8y7eT25vh6JVao2NvTu5j5bf8VyFVwR5cEnRuXv3whY1UxV+cRH0fBmzKpHQR1cY
         A9Keu6sIC7WEGcRDX05MjvZOrtMA5k5qjXZTd208h0BRV3B2Dd4L+dEcm5351DZAYPev
         sB3q4ieNFe9wWLo1yV8emlJOkgTEEXz15fS+vpqzy5QbJ2p56NG/sYohLHfUB9kaGJ5t
         WNUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUIOWecfeCHEmrNsVOQKCqWGBeO5gyooUuj2tuWsMZ11AgAEE/DR5EtqpfF2qA6rMTtVbofUoviQ==@kvack.org
X-Gm-Message-State: AOJu0Yxdx+UZyhLz/sqCzx1eyTm3FRsahdMned+jknedSUoPjH+hVByS
	Kdd25znrgW00sRPXpVFX0IitOiPyLsQk2MK3dm+BI6EpQONd7UrVi9/N
X-Gm-Gg: ATEYQzxi12OOJMxUJlFUPl00dl14e+5tENZpOYIpKHqryNkOOLno6/Hm7FUbUHMd8YF
	nt4iLzKC+/IYeJuA5WfNf9CTP3OWsFhgHzsiZt+4jqJ+oyk4YI48daLJ1L9cmb1rN6kFslfv2AF
	DmISD827i5YVv4G7mdfUGKYEneindvlrnXG51AGbeJdTOAS7VZSp72FjkWuGsQe2VtSGRDjJLg9
	ZaKNsZwmFXVKNusOl17NvzOlfmo4gVLyGeJAjUTwKRCSPQ7kfgcdYQNLSZw432T0OfW1DI61sRE
	BSFuNWz8Hiuxpa7qaCdcYhDCWP42FT3EUQUIz7LAmhtPjAsiYCmzHvbx3hBy22ydT9e3YKZ2aAc
	c7QyrSmQ9uIJYLlsRb62puRjkza6LGmvxeRbYBAof5Ghvki45p3IVT48/AmB2wjcd
X-Received: by 2002:a05:6512:6cf:b0:5a2:b43d:ac67 with SMTP id 2adb3069b0e04-5a2c220483cmr84806e87.16.1774979453562;
        Tue, 31 Mar 2026 10:50:53 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c2233101sm45232e87.49.2026.03.31.10.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:50:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 31 Mar 2026 19:50:51 +0200
To: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Uladzislau Rezki <urezki@gmail.com>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
Message-ID: <acwJe5yhAt1M7RfJ@milan>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
 <20260327113758.75f04588310a707b4d4b1aac@linux-foundation.org>
 <acou2CsZOUQPx5nW@google.com>
 <acpsKv-GmaYj2Bmx@milan>
 <f6f04017-3dcc-49af-b875-05a9ed4f4dfc@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6f04017-3dcc-49af-b875-05a9ed4f4dfc@zohomail.in>
X-Rspamd-Queue-Id: A98BF140011
X-Stat-Signature: hguw4zmcmptzjyzyujq98k8bg9x6qwnq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774979455-816374
X-HE-Meta: U2FsdGVkX1/Ni2fQXbhuyTYgQDQ1xrpDCLT9RiqLGEeb/7d9BGPkk0E66SfN6MitA1o74fMhhFo9a6GXV7WnU2653TxRpcUD44eBRLUXmPdAlpPVAV8hJ44s3A6aSqWF37C5WRP4Jlcsu/qyDDf+nudq0bs4NyroJK+H/o35Jmar5GsFH03j54VeFphbXtZduqpZlxm/foolgTcZuDTIzhir4CWNLFth1qvbxzA1o9+y/o4qfK+ly1nzev1Sc6dkQ1lmouYEMFUc/zVpPXCH9nvk2x8gaTvnylXI+Z/kIRGmiLovvPCgX/85asfRy12MFYOGU46tm4DngpCp61v0fjGN/LTVd0RcQ25JoGdX7tZtTJQC5bQ+qgm+BI22NFpiq+Zm1LKeItL/Abiguxtj4Cy7i5Wt2/V0/WTazFpRiNIEY11mWpA10Jk9dzYxR/GTicYtcqSJvPIxdwpF74jfXf6J2AsvVf4v2oEhEyyQTy5262qcEv1I+FP7ObOzg+Mf3idFnW5faIvI9DSSEy0qPsq5WEg/GjgrF61Uq1n16ljYFl622O5wg7OorHyyddxODW31HV4ckjWk+u9Mb23uo7+1gxZtU8yhCERQbX2frc4/jGK+6jY/Tmy2Nys/hGiAaWbkRPSjGOOanyvweFXw4B7PhizDFzMwR+9GmvLT1cLxAiQGlq2C0HSQ/ug87/pD6Fc1Xw3bNORvHiD+P09mhLXKk0nGNLwjPFJVfqrdC80fTtx0M08EGJ7gjhiJqGcSeev7zjgLjypSkNZ/ukI99Nn9+rs5xfVsCo4YAPaMnC5mM2HGp4tYnl58pdsJVle5mFE8wXgDB8toQOf0VBlyf0fRCOI33mvK1epztaawaXYSVzTc4S5XGT0T3bUyPnpaf4YqCjDvJ0dzRXidW9TrZGA9WsSdcvSyai6vgi362KtIedmzud93tMei4wxWVSnu7ohqficsXpxPSyqncko
 Ow9rCRJi
 qiYW15NwBuxMA1thjiuUB4AgS3QM+en85ONYqfYh6e9Ju5QXjfnTRMEg5pNBJ8km0nRdg8lSd7tO6EA/ILtRaVsNYrAB1E8oLhg6OzQWmctEOhS1FLS8e81r19yqNU4pyqYlfKtOpneVQpZitK4H2FF1FTbuy0rEBqlI2ENodAc0N7qqZjXEQfUO0/QkbCIEDQvo2M+1KDLr2XIcH3oup9R1Jcx3JWHveLseZEBPYYIOjfBgEOBzZ+9Ou8ER4v9BPcZx+Ae4JNx4S9lgGf9mEd6dIGpTAIkPPwQr7Q25aLu7p+Y/VfjifkZ0qza8sCdUWw+59M+dnTt4SKaaWNG3NCRoQfkbAsCGFhZOpE/E+Vc90ezkrZ4c6OsVaFu102roM1KCnDmAD7cokPWs13Gln0fz0SIb99aDZeL+znGwwkdf/KkrWka20D9WcB9QOwNE/tQEfxHpb9LGtgQ4urCldAhdoW4d14rsFQRfBN8GJXE7n2LkJOPCKjfInts8jtAo3Uu5DcYuMKZYCbmqC+iyYyDNOU1Ei0AF924eywO2d1oEt9FZXa1jLXWu6kil/MUUlJZ0hPY6KG4wIqPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shivam!

> On 30/03/26 17:57, Uladzislau Rezki wrote:
> > Agree, let's postpone this, so i have a chance to check it one more
> > time even though it seems ready.
> Hey Uladzislau
> 
> I missed rephrasing the commit message pointed out by Alice in v7.
> If you want that changed or any other assistance from my end,
> let me know.
> 
I have added some comments. Please have a look. Do we need those
READ_ONCE()/WRITE_ONCE()?

--
Uladzislau Rezki

