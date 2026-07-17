Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1EDAC44516
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 22:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F3A6B00D1; Fri, 17 Jul 2026 18:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68096B00D3; Fri, 17 Jul 2026 18:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955216B00D5; Fri, 17 Jul 2026 18:00:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 596B46B00D1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:00:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E17F01C027F
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:00:16 +0000 (UTC)
X-FDA: 84999637632.22.B79905C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4F7980005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:00:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VEEQOEfk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784325614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifI+MxSrxAA6sSWteBBgDksztUF+b16cD5klnXr7OpU=;
	b=Po9IZ7Kzl5WOhVosLIqeq8Tl4rUOOOqR+bbrDeSK6vjVE3c94aajYrgKbc1T182AuWNL2x
	NS8e2nadjJ/bL0R2qeMT8Pq9jvruQZF5ReaowrhGMwX3fo1o6vJs4jCTMuCjdB0jU7w303
	OJBEp3Qkm7Slm5GNkddafO7Fi7efYl8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VEEQOEfk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784325614;
	b=jiiSFp5TWXV1cdVqVbuc4aQ41wYteAMbwchTr5YOPs6nDX957GFc/sOtsnkJHiUpzS5QKN
	AubdjYk+fGhnOKoSbUpSjsyknu/emFjNXJENp3L+uyVKLnbXnSgXlJL8HdFTR12ZNxIeoA
	GKW3Umn2t8FthWsqkAJP5UC57Urfdvo=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c2808dbc3so54024701cf.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1784325614; x=1784930414; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ifI+MxSrxAA6sSWteBBgDksztUF+b16cD5klnXr7OpU=;
        b=VEEQOEfkaivXjJIWjo2eRVqBGZ898p5Bn8DOQPX0Q7pj6M6H1WAaPuLJP3ngTAP36L
         12pqB9CQnHDckuGH4KmG3fEY70GmUt0btLw0t5YTnYfvRQFzSmnq83GeDsJBv3rf/DoG
         2bzfmSikSnev80+frbF7da779SZsKNWpRhLZM9f/PMGMGjmD1n6+cdlaIjUi8SPdnqua
         kypAoaVPdCdUImY9anBOCyylDKmYcjzr6jFWZS4IC7LwyqkPO2bc667isRRgCMs7ynxn
         jgPe3d8DBmTVzwFvjmuBq1CZxF5EutNipEwpMay/PNovwjiu6wVDhMKTYky7yglFIx6J
         3c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784325614; x=1784930414;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ifI+MxSrxAA6sSWteBBgDksztUF+b16cD5klnXr7OpU=;
        b=UWj84LXaBgmuLRRwk2Sn3Cxm8g2zHQrlOQ2xlyFnM9fdj1PwUMNhMmEXl6LvpgYTTt
         DzmDlzdOUO4acYXBtQvBbvadxLVV175AbZer45D+IwqJ2Ocm8F8Bhie9JS7IOcPOBkJN
         algo4Sj0HUzzEgY4oYGylAav9zDDx61W8GIXsIsezSFbg5kpixwGlLz/FnnTIdmH8dKN
         09o5HAo/hV7cgv/M7aj1WhtELg1k0z7fBYwXRYciAvtMUGTJRLAb5HeZbwM9EEAwI5aG
         9s4NJtLE7EwKvuhbXqWzE+pTK2PCX6vBu9zKtw6xvacbsW4/zRZbVbwDkg5ME9xPQO89
         BWKg==
X-Forwarded-Encrypted: i=1; AHgh+RroVVCVL5KZPhMZNiKLvkJzGiEWvUZ+/f5mh2B6r7RKISUS3ynyelslZzBXlyMPxPi56ArrylC2oA==@kvack.org
X-Gm-Message-State: AOJu0YzVCgBqmu0R1QTHb2+HhvytezWudggrOCbDgD3kLo4eArdaiRAD
	veqtMrqHwZbV7IAHoiCl+bI9A4lqwp/vISPisp8JpjwrUB3ZIdRAAc9SkDiWMLpJzds=
X-Gm-Gg: AfdE7cnLKgWymY94ayRoPSMeLXH2nPj9AvwHa/YN1jkhjyV2PylXM9wxDnfPzsiKXsr
	zlvMoqsjoZQCJF0v3xWaV3/LB0xq5me56YeLb82pspasFV7ZyEB/jbgaCC/MDziSkJt7RhAf1GH
	Pf1rAkEkJkqonudZ9hQ1hqyqcfW3E6wFXaeZFIDcXBLCBLQVacUb9g48Y0aXjlYIIBxirEycC9B
	cxpLFUC+umyWkknlnD0wb6u43QxNMMa2jjKtkYAUqhUPx1mL3v7I/XHzfVtHGdDcBk/Y4h8w+di
	xG/kzH0kUux7BW3h65ZoF659b7Gdhurcmg+/J/pyaFISijLgdndrQz1cTQ63xzQyQ2pardSPBTz
	GjpXhgQIwOX8ZdcdPSBn3+MUpSZHIgFJBMCHhFILUI+Dc2Y+gLB8oK9auH3o3PwUU5rEP1Pp8FM
	1HG46pdz5WSWNuvEKvrIc6lt795EmVaF+oxmYM4Ik=
X-Received: by 2002:ac8:5fd5:0:b0:51c:7b12:5fe7 with SMTP id d75a77b69052e-5213f378d24mr42575461cf.83.1784325614000;
        Fri, 17 Jul 2026 15:00:14 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907786b2a5csm27038726d6.25.2026.07.17.15.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 15:00:13 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 06/12] PCI: liveupdate: Auto-preserve upstream
 bridges across Live Update
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
 Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pranjal Shrivastava <praan@google.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20260710212616.1351130-7-dmatlack@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-7-dmatlack@google.com>
Date: Fri, 17 Jul 2026 22:00:09 +0000
Message-Id: <178432560931.189683.8819967076124393595.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=635;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=qvWcvkNG2F6VP4AQ/OsjiXWkoEcGbEfuK0Svedjd88A=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqWqXst23iQddM5JeKJBv5+L2AUkI6Q1Imib8QW
 FplXhImuLmJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCalql7AAKCRC7dyhM23N6
 3h10EACKK0N2VwEouy2CYlXnQQDJcHE0yJsT9DHhMi2Mje4OjA+G2J5YK8Ey9tSvDFEN4MIxr1C
 IZPZjgDZHgP6pYqeWYUKqF2adMUoo/gT3yM0xVuTHeyIwVU62yur28Xfb6YM9xVDfvGFBv6vtfO
 jm7GyFSIVeTdMitTPUwJ9+dSDxWZVL/Av4OrHAmbpsCdtjU7ipKoGAZ8mjFd1LQJQWo2r+iDqQ8
 F35z2mfJYXSEiHmuc8NDXRunjTg+VzvwBDFdMrrWDgW2R0dzM1fP9kuTUxix91XHpMwBXUIJFk2
 f6zhYw2ecfhQ9QUraWoXPAvpO/zcWsJZJTPxmwjJguJWsY2u0fWnprkQQQRUBl36KJOffbjb0z7
 fI/gzFrFkS1P2N0l1uwAv27v4n5GDfPok9wFNXYwvhEIFi9QF3y5EYHTxoblOxdIhOGcYe19jBz
 0YtAyz1zbJL11x4KiVA7vH9rRb57YZwnrVzae6b8DzkkIjtpCur0tNk7GiRU4JwFioWjr3UVcMm
 jYkRI58+ErcB766VyU6VNEEI+AOYi5hmlSIXCY4SCJEu8mnnzar4ozhZ/5GeWfJORkK0gOE8YGC
 K19l9lBFbdGjs7nS9EQtHBT8DqPt5iudHpvDhMfozA/RFMnUT8eETh1IhocLyiqY5FNzxM+SSzW
 CsGDXtheCUaiY2w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4F7980005
X-Stat-Signature: gc5d8iuhith9xbkarzu8aykdjbjxc71r
X-HE-Tag: 1784325614-626634
X-HE-Meta: U2FsdGVkX19ePeLcpbNOUyKGa5uXnOmB0nvM7iQ/oIhH1rvkw5t1YwO0vruL0T0hLk35mqmOZScMN3kRDo8EEN9Fa3zLtjvZwPg1/AogbWMC9RJQVZfjrNlWco4y8qPy67PznibroJkADYl5Xqf32PBBzbKkIIKQ4JmSR34XOOZYF/bn5ejHC/it7HYf3AxHS/gvBpctlebc2OIOdiRX2BrraaQyhCQyU5ovN5a0SJPC3YpNp8B1OyQs9hRVm5DAicrIj5fenE/UpysctHMwNlMsd+0Opnm6cCsuLJoVKXDOba3tdSDWcbQQLQrDsz47wRH7MYnB9cYK54Zdk/mpGcR8lXa40Ra9CdAyKGrL0UhPoch+a7hVZZ8dL+DOHYwL0cKNfLlgDvZ5sXpVdsjeMnDzO6FcFdNidAHCTSqidTCnfyI+BWuVvjrB8gcY1ogL5UWCw9cuAnAt1LRoNsuREJ1NoNk5TkrkmEaI5h8dR/h1wRxirNSynnZeOi1mFZsEl7UQLI1tI/kQZ/fMSo388C4zNxU+TzUzV7qy57Qkn9fvId+C53Smf4mT//bG6+PX1fhuxKLNK+mozoPsssjvNa+iVISeSi2QpQ4rzbeVLi/RoGCWFaNY/WV3l8O82cTKgi4EIxjXFd/Nxbj10CMJEWqUIytTdZ3FkPwb6Kyy8mpwqozmtQ0Ztm0HDcwIJGY08dajUJ+weioZPCuTRscgZML6sPMKz3bzChvhPZGnR4Cgjp6UkBg9/eNNuORv5T3XbNzCgr3OzeEp/H/nQRyBhp6eCN0sBrFpxFjWW4SN+aHmpjv80QYjjXWWTPP16lHg3JKPDLzEvI99vP6smNdZ/Ezj1JSEht9IXf2exQu+P+A52n3+to53iRSrkimby6+OEn7W0g1a27c3Oinv+UIIl/P9+6RJleavF7Al/qJEK76EkJr9bAK/mYgEc2mqUhFouLEKBODoG5z3U/KE+8U
 hNHJLpYl
 dqDP4NEiZxMhb+/YmoyWElqhe4cC7tyLw35PndEVn72X+LJ+f4AKQgB1bi8R3egeg7namh3eNZMp4GSa4Av3oRLRBGznvt3skkqYVTvuA6sslUsA2r4w7pWNUhfbke8K/OL6bi8LK1bJDtHpDOGAr873lnObRd+mtjy3G8cunqa3JoGRan1y0yDWM9my0Ld4HhdYaBfz1A+FgEUkH9lsjaDpGboPcoDht/Wm3Pum8TdZqlFgw3k1I4/ypM+gu5lP9SuEv6JMlDQnel8gU5U5D+FhHErqTOf+VJJzFQzydsWo0hqzjmhyREeKz6y0gFHb9UpXphbgywx59Jiqjyu4zTuHQkla7TdajRM+W444N76OAyEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 21:26:09 +0000, David Matlack <dmatlack@google.com> wrote:
> When a PCI device is preserved across a Live Update, all of its upstream
> bridges up to the root port must also be preserved. This enables the PCI
> core and any drivers bound to the bridges to manage bridges correctly
> across a Live Update.
> 
> Notably, this will be used in subsequent commits to ensure that
> preserved devices can continue performing memory transactions without a
> disruption or change in routing.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha Tatashin <pasha.tatashin@soleen.com>

