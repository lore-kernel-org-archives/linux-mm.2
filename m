Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB77DD74EE9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DDF6B043D; Fri, 23 Jan 2026 10:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CEB6B0504; Fri, 23 Jan 2026 10:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1946B0505; Fri, 23 Jan 2026 10:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4C46B0503
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:29:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1846A160392
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:29:24 +0000 (UTC)
X-FDA: 84363612648.24.05B66C9
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id E1CB52000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:29:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLdAiOJ4;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769182162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMXK3faP5WjLETtx/txqZzUS76vNYg2LRy3y3k2r+zQ=;
	b=0KGNVH1grVsgvnI80kj2gx3ryonCheruJ/zLkY4rWM+kUaNIeUs2ZbpqXaoMo+0nvkWtAq
	aUJRAwtOEI1GQdIn6L3MfcZZAuAfXRbP7KVN9GRWTSl4itibym32mW2BMSlq3p97fDgs3D
	uLppNd9BfxtnMtfev1j5NGxFptoizZA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769182162; a=rsa-sha256;
	cv=pass;
	b=7wj2V0lxJR3clvUcSvNVIyUyevwpxCJG70DLjnrM342DcwnZWyQhEza6vOBTFuzanN+qyN
	0P3CaFKYOeU5HV3DnAAeh9s5gcdeyQ3y/D5vE+gE3/ffE1yJeHQZkHJ56qE0uS6vkWzHif
	G6pGO3tDuu9nGx5rWZUgtWxKdFyG1Dw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YLdAiOJ4;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-59b672f8ec4so2455829e87.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:29:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769182160; cv=none;
        d=google.com; s=arc-20240605;
        b=cd6rYT9XGfOlZ4aE1W9QKHt2KmdP94naBppkJCCTcb1KPOB+XXEE4vBgwMG8gu528Z
         X/5SwQUm57BBR22xeR3TVzXWhRxckxZthLyOo+9DaNXw9WqZCbhFK7vzsy5RLx5GMVX7
         CiFmtPlKU3uPt5ym5KA0CFdLkbkxX97qc1bjUECCdwuqjNNgwSfhFOGFeyLx3VUAbcpW
         4x2ys0uWeqc7RbXdEYEyrk2v51/Eh6K2XswvqDcU0tjaOfyPHNPxNMaRGkVsoeGGXMDW
         T2nnHk6p+F008yeu3D/rnqwj2x4t5oQ0WCweaFrAcDZ/u4XBJml5IBGLfw9s0Q+s3gIh
         bNTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YMXK3faP5WjLETtx/txqZzUS76vNYg2LRy3y3k2r+zQ=;
        fh=Sm8SNpwLE0Z+BvR07HENKG4EtzdX1Oy8bEAHlFLES7M=;
        b=hTI8cT2H26cIUqtw21NZm9CUBy3AMwSSw1rYnyw5SZe89yhjHyXiSvMFP/kiQKan0h
         E2rJXiGeOs8BUOOUj9Ew0c38aA9krkGTS+YoDngF422efcf0hyhVavxKl74b8yvX0AkF
         JUUErvfn3oktl1mYFtJbBqApDLszXUau3zO7Wnzj7KZZi/4nM1DVJY/XITDCdDDuiMVC
         qN5skHlQOvaSdyZ5ng8XbjORhEnHnDuQB8Iq5A7JOugXI27tNXpw+Dn411HYIdTAfh8u
         jveyADUkfw00/iyqvk2hbzNnMHvRib/onmZLjWxxu9aDV8t1ldAL/2EtQY+ujsXCyTB3
         itLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769182160; x=1769786960; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMXK3faP5WjLETtx/txqZzUS76vNYg2LRy3y3k2r+zQ=;
        b=YLdAiOJ4sWXkWFs6ADNlF0ouTn3YZC79o7mPJJ55y7jjjgSr56bHle9W18Gjzi+CzX
         E8vD8TYbGeLqr/P9Ssm8oHbbQshBUVbwTutg24LvPv3Zal3gqZAO+Y21SifsczN4fEcQ
         rlAuKspKdpbTU6HBrzML3DQc5YS5rAUDb9FKZwc9wJ5f3lCa+SQA4JYtM36hW/NljyHT
         NPSQ4ecooHF6ZNaPNncmwtFAkC1wzDxV5j7qPevKebbVnKO7fLC/pkhqqZLL6VX/kVZJ
         CPbmRM4nG8JLoQz9MpL4YYARjHCBaQZQx9Oi11HiYI32uHpBo4XmERarX4A0A2Qc6Ft1
         irsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769182160; x=1769786960;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YMXK3faP5WjLETtx/txqZzUS76vNYg2LRy3y3k2r+zQ=;
        b=ndrMae9nZmM3tE1CZpqLU+5W6bKjmVSwsAzdb90jG/7l3BP1VfHdBPeJYeK8jQzhg9
         5UvMgEq8yOFGFBlQZgukcdYKEsxu949nRnqHXGOiOf4KELyy+jRZnB5GGBgc9vgaH1Xb
         J2RwPKpjC8kaSDEmJh4MjDBg2QQbO5MXMqqYRBLE0F431eZIpRWbkWIN+12+L0rSlUAH
         CBoa2BKcFxFWXQsw+wbp5CqOWY7+DWxQlj1f6e2b/BHDWsVCtaTZ/8//Hk1LXqQvUwsL
         Ie7KZMBImpDAH+5G6OSENac5EZhBdhm4s1rKh+RJuG67z2fz+7roemaygNhDyQ7UJPNh
         zUYg==
X-Forwarded-Encrypted: i=1; AJvYcCWeQ4y7vA6iYvJMHtlZvK4fO54ZzC1pi6O4zne7eXToHqmMYwtITUzEgQU+y9vtgbqBwpaoRe1mEg==@kvack.org
X-Gm-Message-State: AOJu0Yyud4abVPCY+GFZDfGLiTVWZDU0ikdm24VEmqRb0teLiOmaHWvJ
	bNflFIWlCBmri+5fPoFCkkpjv6SrmUnGiKWLIaF4u4hUTz43UdpJ+I8hQ+lJrqvTIHoclmwtu15
	pceO3g3SQG2kFOyod0vmJvSrWys7m4FQ=
X-Gm-Gg: AZuq6aIHoFIJvYcf+dGiu2LIDzv5AkXmLAG164uIQtZa402sVunqAlBXC0UQ/QTA8jE
	j14m1PxWIjFoTXH8TB9n2cba7H0OxmSQR5q79vqhC1KQYqHxF61hSZAyn4Uoy1d+zQhH1wX3aAF
	IsB9xL/J+5adZgPmygJQEq6ji6SWC2olP0lRHVw40M1BFxi+aioGde5lf/mfaTrX/QQHi16T8DX
	xjkX3WSqKa0ezxqMa7Gi4yMgBrhsmXWPCi4SloKddcQLEWbdOQgDCjaZUIHN0b70em8M2w=
X-Received: by 2002:a05:6512:4021:b0:59d:a4ed:1aee with SMTP id
 2adb3069b0e04-59de4927d8emr1283868e87.40.1769182160092; Fri, 23 Jan 2026
 07:29:20 -0800 (PST)
MIME-Version: 1.0
References: <20260123082232.16413-1-vernon2gm@gmail.com> <20260123082232.16413-3-vernon2gm@gmail.com>
 <aXORiA7_Oy60MSDR@casper.infradead.org>
In-Reply-To: <aXORiA7_Oy60MSDR@casper.infradead.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Fri, 23 Jan 2026 23:29:08 +0800
X-Gm-Features: AZwV_QhkyYsxGHFIj6K6zwoYgTkO6oi4AcRtifxnCWJS7ebvej8Lb52hMIv2alc
Message-ID: <CACZaFFPx3b9VH9GLoXY1HrMaLs9OtJ+oENfobAvoyaQxAhCsQg@mail.gmail.com>
Subject: Re: [PATCH mm-new v5 2/5] mm: khugepaged: refine scan progress number
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E1CB52000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qe1k49urxgbdu9zug5ukgeuix41e8yas
X-HE-Tag: 1769182161-992038
X-HE-Meta: U2FsdGVkX1/4zCHXqx7oqi7cA0BEHQl2PWYfPdAfYqhZeMaZAteUBwb7daozYMl/if2bX5J1PPmDIzwjPyklzrruoFfTWbLnot+ZyfjzdARaZO3VoGzJT7jkhjjJf2TYrp+brOhs5H34v4VAEkZUrDX3Wz/NW1u3WXbSKyEeERiuypsWKkxZvyYRiR7DO6y+GvomPkpMzKq9WqToENQez73PTfWKJzY0wW3tdXbu3hO7K8DaNiwkRC6KCw//1jHdzwV++GFf+yG98SR7OtUdI/j3VtECDHUaJD9GSi8Vnczflst6CaO9psqXoGRGn1LjcP2RPKl2FBf93Cun+41UvlukHBTX+Z2eG02PjTKVeFgpPb1NRKf3ETnhkL6BFCzqqFa9SELF7DTLW0TP1DDO8fV6dcMBWTgkJNLIppoZPRaFoHarkbqIAUP9wUBubrP+y0Wh065bLNhrPYOxZ0k+tQbI3d6oXfCsa4dZJ+TUfe2D2ZsyYOwcOQudz56U/8fywDXAGBvZgdJwDTAKvyS63j0PfdhEsi7+pOBbysHEb3AmTGjEqGO4F1WBjeVTJ/bNAV6DFdJeSEQ0t6ZdzXGC4/IYZk4toONWooE9ODZ2W+Dcm3+TXEwcJfvs2p4944p54B/I28YEUDkXCxKwb+K/0xWpPTMPdaKfje53MLZU5OZBhXmHe9GuHdeLSAa+w9r/rL9oPLm9Bm7gDNi6vT2MVQrO4O0kQTBB3V2N/GtWAK77MF3DVNfHasPBPpvmHxJnvQfnVCR4wpEIQAGVH7pjywXrSZ7aEDed2/RBF/15v40vcoBrdPcp8vy2W8doANcEQV1xfz3wGShfhEa1QwCflwD2nHgc1QWhotFjWtBcg3Wn8Ev//HXh/0L8s7+sN25cXRbvPxP+TzVKDHYcUe5z9dwvvnf1SlunWPqhYxpsUuKUsY/TlT190IGdfaNvIwuZ6fIB2WD5hOgRCDPl9C1
 WHwBVHpv
 ofSVCCrhYWyCEjE6fkiHLRT3Fn+e4KIHQkVqp58dtbu+nSe8hhT4wlv/x0SiUbXwTTQR1ITgNqAMOFnxEZgz9nk1hxn0I7qK2xPIb81QS6xJbZuVEStmKihjbaheTrsDUsZcbWCv75OtDsTGCJbSY8dEFCK8ShsoZZPQZbMrysCwDQPaW09Dlor71KU6lqWMNg77BBj+3bh16aIvte43KAbGk1I2BBJyJcAtro9ds5m0sRYwLpAvz3cec/SUGMHZYfJwO/KdhsDsWj4CXmbVt85kpqIvhCp6D3CQH2kMatWIMF3tI7MFdwBWxRHJ9N8yloIjOnHLvJBtzEsi+1yN3YkWCAl8wMDr27TA11C0EcNxeF0wi+6JPa/jEmvzPcwT74OUeakegPwUSuIUvEpCfv4hxwuUvJSd9VarkMSa0/QM2NyjVFfUmDaH7B7jaRnZ9+k1HsSERoyqSf70=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 11:19=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Fri, Jan 23, 2026 at 04:22:29PM +0800, Vernon Yang wrote:
> > +     if (cur_progress) {
> > +             unsigned long idx =3D xas_get_index(&xas) - start;
>
> I agree with Dev.  This is less readable than:
>
>                 unsigned long idx =3D xas.xa_index - start;

LGTM, I will use "xas->xa_index" directly in the next version. Thanks!

