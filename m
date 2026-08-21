Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 494F2C5DF93
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FE26B009D; Fri, 21 Aug 2026 10:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5505C6B00A0; Fri, 21 Aug 2026 10:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4661A6B00A1; Fri, 21 Aug 2026 10:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2333A6B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:16:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2BA1AA0156
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:16:50 +0000 (UTC)
X-FDA: 85125477780.29.BBA733C
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 474B810000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:16:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxB1yZCS;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321808;
	b=r55jfioN5Bngtyowwmk1DlOUn+ZOta2H8pWIPsvQlD2sAaDDQCBmCPN1HoSsOGHZCB+QUH
	tJ9HInHJUvR0SyPzUvKQTM97hv4kJrpEGLWXdf14rRF449W5R7Z7YLVYCxYERCqzW2Motx
	fmDnYAdtIhuUO81nGjiwxkx/CXofApQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dxB1yZCS;
	spf=pass (imf05.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkFIWdQrIG5uSLpHBwsVSrnZ/Bh83b4gEGjaE+vppUY=;
	b=fiv26V2Z4quDKvvuWpI/Att4YPzDRsCHQv6A3U1mOdksFeZIoq6+5Ff5eBy1MHMg4Hhjnd
	AVcnVFi1U3Zod7HtanpJnT0kkypgup2lSvry0NBoJwg9eEm9FII8e3rX6CUsNuPJYsZZUf
	CbIAveko2rvgzNQGwrlCfUFqVY9gtzM=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ccf2360620so8798655ad.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787321807; x=1787926607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gkFIWdQrIG5uSLpHBwsVSrnZ/Bh83b4gEGjaE+vppUY=;
        b=dxB1yZCS7U1i0TPoXgsK71lM8lMgiiKp1Wwi3xaFIWYZQzSKC4dOs+bK7C3rSKWf1u
         7/+DojPLblE1foi+/n/lv5O2+lCNE5p0CdHIjILpA8IJcCOCdAAfHeJFIA5swKPhb8q1
         6SKEY2BX9mcs2ip36RUzKOY4H7IEtFZf9XJL52yp3wvfA8bDSyD7nOXixfxbmxvjHsNf
         i4UaGDHAL0HUvQGDpOLcI887jb7iWegNg4+m67wGDkhJD/1MZsKRwDpAD7O8Fxys1mRe
         d+8OBjVReu6SCCBjzvtWMnro1BnslLc+L7u194Ce7RC+SvKrDs/PjreVN3XgPCl7rsYB
         8Wtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787321807; x=1787926607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gkFIWdQrIG5uSLpHBwsVSrnZ/Bh83b4gEGjaE+vppUY=;
        b=aGBj7lyrGe1TeSjR4d9jKEHdzkEHalFccD5BhAvhqDqWwh0AdQbegFgPy50QCTSUJk
         +TcR8EFsDuZoEVYnHZHJHbEOHaR6MCgVyN9dzhdDh05F4kJEANIiJnhbofyPp7iVH1fG
         ufTwzVfC/IKpTQPCFIywO7/Czb1ynViEJ16mPIR/C3/wCqN3Ic9n+GSxp/5D1JtOVNSZ
         Eahkvr4SJtN96z6cEi4gvn9DjXegAM0C3bCAgZwPbRgAHPB42Hs9ZuC0SH7AQXwKtqmA
         K0J3aIb8SZnLmgOsAlUE3pTZT9LD/0oUAH4kxhv8YwFMOxcdKx6Sc3dATf3um7CUJXij
         pxBQ==
X-Forwarded-Encrypted: i=1; AHgh+Roti36O07T/Z6HIKrIiPcyldxBRsUPW1V61YXwj0f36nX2M+zTyfgH2BEpVf3hqB77hcO32FZ6qqw==@kvack.org
X-Gm-Message-State: AFuF++nLYs2P3KGCfI3Ne4oJeq10LJuAmj+qOIthFYVmwNyNETlFE3iO
	SpAlmHHz/LxnhWgF9K9GG/uWk5Qr288lCmbxnXVIcnuM68igR+JIPxJY
X-Gm-Gg: AR+sD13S9EAR7xzSGA3tef3lllGBWsf9pHPtfr3Mw5WUwREiOFYPDOxPKSaX+RgvsT2
	j5lPFLESpQOjMurU0BaqPv+O0aWjsbQhUkb7J8h15UW1dd7t4BWE2Re+yq7vP0VBNwI+3dGWA5+
	m2KgIxiS9a9zK2pmMkcQfYrSyCeX3tSxfEKIvtl3vYekxUij2FVetq0lci023S/YE5/4e2LwnQC
	KrEZv3G67L2QaUXZGNRHsfZUIfBwX0S7B1DqybNT7yDaDYfAPZyHKZT4x4mQEpcf9ZUcYXXMTEC
	jh2W4r8DZWqKXBz0OjflZOUdwtnKc4FGI042xETZ5kjlFxDnp7a+U2fK+P9FSBttMmcQsKlF2rj
	5RjGgLoauTD7QpE6sXI+6Wj8FTPbZbnLXdT6uR8pJ0EwC6MFRPDJZ+Cd660kCRRuhlIuE35dIHG
	9DJJM3RGSKbiufVqar+RbrxCYD4JoNHAzeDtVbr08FiRCOn/G+UawfISqkt0ydblL9zA==
X-Received: by 2002:a17:902:ebc2:b0:2c0:b6c7:227e with SMTP id d9443c01a7336-2d64adea473mr133703485ad.5.1787321806882;
        Fri, 21 Aug 2026 07:16:46 -0700 (PDT)
Received: from celestia ([2402:1980:8916:4049:ca73:3818:84b0:e2c4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d62ec88ebfsm19455455ad.84.2026.08.21.07.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 07:16:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	gutierrez.asier@huawei-partners.com,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Fri, 21 Aug 2026 22:16:54 +0800
Message-ID: <20260821141654.203418-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817135742.75706-1-sj@kernel.org>
References: <20260817135742.75706-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 474B810000C
X-Stat-Signature: 6x6ih9s38dqweu4bzh3sie6jeddppo7b
X-HE-Tag: 1787321808-102897
X-HE-Meta: U2FsdGVkX19p6M4f1t8jAuCZYllYJxXGtSXh5lYCvGb3DP6TouWVVjVy15owdQG68oGcLwHp7bz8kVMj59dJ3KiYcGtcm/BgxeCecmzpR73HWAK4hLIyypDqpEO0ddH75oMSPdzfGkK5jiX8Itksb4uaqVNli9htyYmvUG3D5BM8EV7ToANFxSE08P8hfwo6r+gLHtPJEhbnNAOsdUSq05QRWhZ1ezflb5Q+WWlIOGWEa9ijU0w3RwpVXNBv92yv1DgT9LFRJY6K5UYVu5moE7nv9wqXtiFhAEnBB/y/dpjl+TbYco0Y8yMPMky2OpBPZ2Wad1Jfg/LCQ+MpfJ1JMLkVgn1xiGA9mDBkW5zOKaTfI8q+I5r7hNdCw5RNw7/UEQeonnHkZUZQB5yT7mPSwDWu48ITu+GXLKIhngy7ScUcLe2bbhY9036yNo1V9dU5GsUm/smrZqmVPzx//KjamEK+pBlLWnXbbPOwkSKdJrFkEmRE1hgn8vg2eG0V8Hps51MjDHV3wqMFIz76ZTit8da4xAMrFL6jYeUaqDZcsFZedyoIJeuB+0O9PsrtvYUOePOxRnQL9+z6UvxjKHSVkMoH7wiyAb1QD6YnqIT5bkcTqSGFz2jAgxnbdSsD+r0QDpM54YrWyx6Prpi8aVtWxFujF+KpQ3UGgMJKQq9BiyCDOPUi/4e4t3xoTseL12mGEMat9nY7nk1NFR480xsvYV2PQfqjU+G99kzPxBDWAcHsNl/x2t5R/2dZ0Ugw7G49Z+W7wgA1jQCf0as4psadorQR+ewvSCjjkRNBjDr58cw5400aJNPcYh+IDAis3YZb1yL5JTisJWrkowjVDEBCIOOBB4vNk44uR7cA8DVHPDSSMZjQfa6vkvVlm3kJmAgVXjajMy+5LeQulFLZjtTDDY2TLmQFINTi9nEvgBR67qa/w0qBgKoVj6NQMgFakZKlaBmIQ5EHblFZXrWzyu5
 ib0LKNRB
 NLYzFhNejWAV1r5en+ZAjookAbN0W7V/qlZXgZUZQrxp6vwcoJmhZQM/baYu1YW4a8igMuofJsHhDtn+3I5cY6h9eXXzP+LYZJvArHD4s6SO3ddc1d6C4YYffVESLeYqracaENuG5V5nRMwWHEFJP8AkhnF6ateK20nX9qyv7QoZ74N6Z5KUDemTd5945JoDiT4zmn906Y7sf71e5TGzIpwNV/U8ZO3A2P8mJkrYCvLpNl7pC99+ddsf/1XJ52Hc2X90np/Qoz8wYXIwx7tb94gLPZwGT8OpQ0hKH/ERTbtLsV6Qnp4e6yxJz8vPyGVdFrlsiTzhJGKWHE8Tqxa3mAkhj7iKUK37B+rZiD3hyGmLBR8JCiTCjTMLQxWa1AHTy8eR75fHPHPgM5Qrjg/Q+vwQFh3X1oJ21TgUzO+3qRVIUjKp3fPJt3vz03+NWCqRGMLEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 06:57:42 -0700 SJ Park <sj@kernel.org> wrote:

> On Mon, 17 Aug 2026 16:39:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> > 1. Why use Watermarks? And what was the problem?
> > 
> > I now understand why we do not need better Watermarks, so my answer is
> > based on my previous thought.
> > 
> > I used Watermarks primarily because it is the only mechanism I know for
> > stopping/running a Scheme.  The problem is it can only monitor MemFree.
> 
> Thank you for clarifying.  I'd like to go one step further.  What is the
> initial problem?  Why you need the automatic proactive reclamation?  Do you
> have some data showing the problem?

To be honest, I have not encountered any problems, and I do not have any
rigorous data.  I simply using DAMON to try proactive reclamation, and
see if it would cause any serious issues.  So far, it has not; it has
almost no noticeable negative impact on daily use.

> 
> > 
> > 2. How exactly the page cache becomes a problem for you?
> > 
> > After prolonged computer use, the page cache can become full.
> > DAMON_RECLAIM might then mistakenly assume there is slight memory
> > pressure and reclaim those cached pages.  Unnecessary page cache
> > reclamation can incur unnecessary overhead.
> 
> Thank you for sharing this.  I can theoretically understand the issue.  Maybe
> you are concerned if page cache is too aggressively reclaimed and therefore if
> file io becomes slow.  But I'm not really sure if it is only theoretical or
> real.  Since the proactive reclamation reclaims coldest page first, and because
> it works for not only page cache, the performance impact might not that big in
> real.  Do you have some data showing the problem?

This is currently only theoretical.  I also think that the performance
impact will likely be minimal.  I think adding a MemAvailable option
provides certainty, if users know for sure that their devices will not
lag when MemFree is low, but will when MemAvailable is low, then they
can choose the option that best suits their device based on their own
situation.

However, since DAMOS Quota already supports checking current_value from
user input, and I cannot yet prove whether this option can bring
improvement in any workload, I think we can disregard whether to add
this new option for now.

> 
> > 
> > 3. Has the MemAvailable based one solved your problem?
> > 
> > Yes, using MemAvailable as a watermarks/DAMOS Quota metric can avoid a
> > lot of unnecessary memory reclamation.
> 
> Great to hear that.  I'm curious if you have some data showing the improvement.

While I do not have rigorous data to demonstrate any improvement yet, I
appreciate your guidance on this.

I will continue exploring DAMON on my end, and I might send out some
patches later regarding a few logical issues I noticed in the code.
Thank you again for your time and answers.

Best regards,
Rui Yan

