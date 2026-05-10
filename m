Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B711FCD37AF
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 00:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 558606B0005; Sat,  9 May 2026 20:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509556B0088; Sat,  9 May 2026 20:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446196B008A; Sat,  9 May 2026 20:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3600C6B0005
	for <linux-mm@kvack.org>; Sat,  9 May 2026 20:27:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3E188C606
	for <linux-mm@kvack.org>; Sun, 10 May 2026 00:27:38 +0000 (UTC)
X-FDA: 84749621796.12.26AE95E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAB5D1C0003
	for <linux-mm@kvack.org>; Sun, 10 May 2026 00:27:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sm2BqhhI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778372856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ro1dSbK7YaXyzS6gYFkxsTldjrKUH9gqfqM+chPZiwo=;
	b=yQyxmrwtCOYdeEwN3St7kI54mRLgRVsxOmMAQjJQGJqd+01Gig5YwuK7jz3/8oUsc4wNs0
	yNX0PQvUxngpCmAIlpHIZ8ffHUfBe7n97tZw20CRd22qtfGbL1rpwvrh2umK64Q42c7N7F
	fPPzLhOUYYYDJwYTA54sS8qr/XZXZas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778372856; a=rsa-sha256;
	cv=none;
	b=t4E4WwAg1Djul7uyL8i9PfrLc8pwRo+UJqsaLS5FlNiQ9jCSLaLvMsMrHKmxBQ1Y6d+RsH
	+coeSPr/AC5lxXGUuFLy2cXYwlQL6CPbS4Ns4F72BZEHTHTiVbNk98171U++9DpkjcO3Io
	YlPXe8wIMCcY1XuhfEao/G6z/5KnLQU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Sm2BqhhI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of qiwuchen55@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=qiwuchen55@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2baca4df358so18666095ad.2
        for <linux-mm@kvack.org>; Sat, 09 May 2026 17:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778372856; x=1778977656; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ro1dSbK7YaXyzS6gYFkxsTldjrKUH9gqfqM+chPZiwo=;
        b=Sm2BqhhIDnaSHZ+awVC8+bl00Dljmau2BBZg48shBxp5dkGSvD9OQN8cFmbCgFrXIn
         4XtBkOXEnREw3GerhH9nA7cfx2gkcJNB12ODaXLVHwTjEWtv70I1E4F+4YNNOBNAMAzg
         x3/WrDBWRtlMcTZ3gCHzdixBZ+aaPFxGtpnIAmzSxRNlUmlP1N0dHU29myOXrG4et8pi
         NyKWibiOasGzAbfI7Lp7putMQpu63Kb0VkdqHWqi7Vo6WAVUmWbztZk2vdSTl2LJS5r4
         xOeaPRMWf3IQfSEssdU1C3HdjwfiVwdeNEbDxhqV4syFOfQuZMaLPlJenQb1iuk3H+iA
         t0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778372856; x=1778977656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ro1dSbK7YaXyzS6gYFkxsTldjrKUH9gqfqM+chPZiwo=;
        b=EQuSNeyy6G3bG/uyrlj5YfviBm7mA2MzNFviAave5oetfMi8xBr86ns/xB0117bES5
         TCfZxrTkSLPuHN+z0PqLteI83EvLnJTW2s/6Phzx+V6tQidZV3BDpnLeM6uNEbcT7YUg
         jyOJvJkR+OXAVHA2ljotnLX0zCqVvIZUyEUpiKf0k3TRnxBP4HgqEjvcJPwTfT05Wc05
         Gq41sniexhtWq0bghqMeiOsOH6rTCCHiMx/AkeMOdQULahl6t+Btyo7IL8nRtZNWvrxe
         gsGTODTgtiIJ62YGB+osPpmC153LyZWiw4d14aiDDAwKlKlXhG6Vx53fWv//jHXkB4J0
         0zWA==
X-Forwarded-Encrypted: i=1; AFNElJ/T2bNKT/dy5YZF/+wVoayaX2V/xTSSrzSoZcRv+zq9ZIxTcHYUHrXPaHGyL0qzi8ID5JRS65QEqQ==@kvack.org
X-Gm-Message-State: AOJu0YwXz45UIlgtB/4rusUEgDXV1kKTAsHSQ4mk6sSJabgeUF8bC29/
	XsV7nms14fZo0au/Yge/AEchrI1toiccisN7dtvY/R98LBo8zSR+Uo3P
X-Gm-Gg: Acq92OEuRTierOCgvFYbw39+7H44+yhtRe/27SQX0a8GvRdTmezJA5FsClvOFjv1p7e
	JKSGJBvAWOOkeLbKQwO7vrrW0hMXUhRzDtJxaJIVNgrCf3oO4ZggKQ0yAINT44HAcFVTa2gjJXj
	yqUmXYdRAjd6uugusi3zTBTQ0YlbUgW3g7Qmq+Sb43uVuQX+43cd7b8HKDS9s5fJEKHOR6rEGb0
	Zx44PJslDl0doJa3xj0wiErbU9mfSvf0RDN3F0DGWn2VgCEBuL7j8i45tXNM1rEFFACWv8P6iyI
	IoqGR2WAuAWw12wXWy6cSKhcjmp+O3q27zDIu+milRo3u4hd91RW/7ZeUVUqzJE19GmE2bNkTNf
	KTSJN+kh5ENPkyY/9qBBOVuhoMLkC4BNWBjeI9cDpe9yRf4gfXmEvm2pS6FjhOh4Rv+fLnMtdjj
	UdeAezAOpJwar+nKpie/7LrfN5q3ZpKH69IfvjdI1dI+1xCrzLQ2bLtj+j3A==
X-Received: by 2002:a17:903:1b50:b0:2b2:5314:e96a with SMTP id d9443c01a7336-2ba7a32a517mr181332465ad.34.1778372855675;
        Sat, 09 May 2026 17:27:35 -0700 (PDT)
Received: from localhost ([154.39.63.254])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1d40a65sm60925375ad.20.2026.05.09.17.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2026 17:27:35 -0700 (PDT)
Date: Sun, 10 May 2026 08:27:31 +0800
From: chenqiwu <qiwuchen55@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, willy@infradead.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <20260510002731.GA5833@rlk>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
 <20260508164743.ef0194a1223d457bd0e13494@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508164743.ef0194a1223d457bd0e13494@linux-foundation.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DAB5D1C0003
X-Stat-Signature: tz6fy3chsjfkgj81ytnkygsc3k99dw41
X-Rspam-User: 
X-HE-Tag: 1778372856-869542
X-HE-Meta: U2FsdGVkX1+stYdauCPN2me98h9wudqu33/wBKyCnBdb0LHkcrY3CPyeAMTzQCq6Zvgd5m0CF93s4qtxrrMhQ2cJrCVnvu4Oo8y/Gcfteq+Pfsths28QvBW8q+XwXBawMUeiBMAIHLrbFu4qXy8b2Vf51r+KCN8M3Q9C8xB3rWmnASi46kDYehRHD4OArx0ONcSO0b6TK+A5j7pD9Dw8cgMVHqTP0mJMUwLUkvOemoqIYmyy+JCdFKK8gALC4E49Z5MKZwQUgvx23EcWOZ/T4Xzxy3DVRrDPjK/J06IiqP6QRn3MWt/eIGoqARDjjYpV8IWRXHOFSK0aCTm8dcf8eDpGFRifam1SPK+RtqRbXzo9BFU8XAnDv/eKOrifAWqdQ0lDZPCS7JKabXAYCqgZUr3ZUZS5EAG01F/DMWJskfMmEpwG/+NfQvy5HcC9GwDw8swPhqnX1u1z2eMFHED/pVqE8qwdKAv0DZh3+o/sTScwODRozPRrzinCZDzFl+22o3Nl70ijKUP9s1cNxTadliinBV1C5TTo2D3IKgVCRxHmeNNrAayjrUzkDM1cLNu9DB9l+vSlZzz1QkA3I6F50J/vphZ53QVVVPLssgu/yp5nz2ZuGQOZ5moT3KvCsWz/GuDDf9cI1up/cyLmvfFQeT24dut5h7ADV7e1AZUmttOV83sRWYPJ2sOQnluWIP/pI2eiTTVQ46WVeF28MHbAv0y4o1ItPT3RDjz4ovPAM7T1DcI/xf5NmmDCSgy00xkKP6jeCU8Kj+jySzI0c/MItecjI1AMPtse9jCVwmim+QegMMD/jKbE/ev7Bjnspj9TYqL/miiLtNxrxjR9V8ammbdp967KqmermmbyTh0yV3mFAyhaFA8QwlgN77oyk0zeKwXSNmmeXbatQ0p2QhiUfbqzbXt2i2ZCaHmso5DZdqwta5vluWoAaeOMsFPZPuefkeuHJCdxcDqkBvLTSlL
 K3S82hEm
 Yf2yyAM3wyN1zqhJosw/CAy6DkB/hDvCGaMGw1an/WK6H6Lw2P+lrDB1HvJ6VaYXUS9IjDwFVvzoeTnIaN2BfZaWPLwafULek0ONfW7jvsxU9HjHZsuohaqT2Be9QGdb9lQq092kOic+Smi/B5CPYAFVkt0SCYgc43FF+lWrANvcrfI6Amu1r/Ykd59PQ6j3QkLlZiupRi3+aemGXYf68DJwNn/KOhl0an9o/Sv83m+zXeYkQqXDq0XpddRoTKoj9BZqaKZGQetaenVTtxLHjwxLgEkl0193y5KgONjU+2fEcaeLvnQeM7toSD+wnw5VFZy+y9sFRVHC377hY65bCeVV5qcKh1LQv67ffmSbNZx9KkxG0VKYE9b3ymjwkSJPaS3Srmwj0wngJ6g4bkX49DF2NfUmTjfoyg2lp4gKFBNNVTUV8YZuGvRDLwmvA9T2X/1DN2novKHNa2qSZjlygHXypuOf0N28IRd+UWOz+I2+KuWwx0L//TxS5aanlkzbyIVXf7Za52+fwWMGI/wGemvor1kpHU+LLptOQljZsucJ9bS3N8Co9DuE/TVlVjOQrotMp3cVpYa6FtiQR1BW61yR9yivbOaO4tH/E3FnBxNVr2muHiP+ezHtoXda/4B4wGcvWQH4OM3kGBNXH8DMrXlcMxFXHV9Xke5F92gyqymr4nc1HPlm22qe368tTRc29T1ck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:47:43PM -0700, Andrew Morton wrote:
> On Wed,  6 May 2026 16:36:52 +0800 "qiwu.chen" <qiwuchen55@gmail.com> wrote:
> 
> > From: "qiwu.chen" <qiwuchen55@gmail.com>
> > Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>
> 
> Which should we use?  If it's the transsion.com address (which I
> assumed) then this can be communicated by placing an explicit From:
> line at start-of-changelog.
>
gmail address is used for communication, transsion.com is used for SOB
which cannot communicated with msmtp normally.

