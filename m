Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE81D6AB1A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 01:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A066D6B0005; Thu,  2 Apr 2026 21:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B72D6B0089; Thu,  2 Apr 2026 21:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5A36B008A; Thu,  2 Apr 2026 21:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7974D6B0005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 21:11:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F875140296
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:11:55 +0000 (UTC)
X-FDA: 84615467790.25.9BB0B37
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 368411C0006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 01:11:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LK6bi9Lt;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775178713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5JCSWcE47Vi4//k6Cj8RofOrUpNno5OWCOLUMIqerY=;
	b=BhzJQVf26FtCAIVVpdacFsBl2n0VOIstNEWtpjUtTkNyvORPUvBQ5isz3yJ8JtBde7twlO
	qWCchstXWq9iF4gOQssWbUWbdSIBn0clzi4yUOsL2IlTsU3kp6Ef0xHmWkZzw8i9NTfgaT
	77g7SIIPVreX8ChP5RPJK6Ggl0UhiG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775178713; a=rsa-sha256;
	cv=none;
	b=1OCVkjolKFXEemKWaI04Z54zcNEEITmGbdlQHnR63MgAm9rJAQmu/Qg/FICXt+rtKlEDtU
	p1LOeR9RJXgzQCviH73EEKMHxuLwWH/esdbdsDPHSjCe5Z2q849ets7JCW05PC52XFJEyZ
	C1nEHK0Ooimxb/bZdh3+vdv41MahyK0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LK6bi9Lt;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I5JCSWcE47Vi4//k6Cj8RofOrUpNno5OWCOLUMIqerY=; b=LK6bi9LtFJ8g9ArdhgcBTpD2Lx
	mZAgYqoQu7bHWMFgkn9JNXkJtW04BrcFjUWsRm/Kf38g+Cot1sZchAdWS3inhqdbm4UpWehd2YmBY
	qt31ueCe6vwVVzMzM8BXBPnDVB0AF/yEFvuB3+7RVclYr+ueZl1BsewI+J6eubaEXXCfJ2Q8EzdLD
	jRjNbvNh8rXquqXtNefejbj3bcjtGnFOXZd+Gk6mLnZVL3u3r3NskLbU1znQ58/3Rq2TY9EpkOMXe
	t/AiZcFNhGj/OWmBjfghi+igOuk0iLwjXf+ILBxWG6b7Iymrh+w87paJbwF7yCjkS6YCgrygwQqph
	BYIrMxxQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1w8T47-000000001SB-02vK;
	Thu, 02 Apr 2026 21:11:15 -0400
Message-ID: <fca2b02ce88efa3b2e2981b0ea5f836dddc3a77f.camel@surriel.com>
Subject: Re: [PATCH v2] mm/vmpressure: skip socket pressure for costly order
 reclaim
From: Rik van Riel <riel@surriel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>, "JP Kobryn (Meta)"
	 <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, hannes@cmpxchg.org, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, 	mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, baohua@kernel.org, 	axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, kuba@kernel.org, 
	edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Date: Thu, 02 Apr 2026 21:11:14 -0400
In-Reply-To: <ac8DEuZhb_aQA4ez@linux.dev>
References: <20260402232511.17246-1-jp.kobryn@linux.dev>
	 <ac8DEuZhb_aQA4ez@linux.dev>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 368411C0006
X-Stat-Signature: jo84gtxndc61wahrmxagzucm8i5pc9xq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775178712-196249
X-HE-Meta: U2FsdGVkX1/5pJiCA2QDILPW5BOEZrcoz+DRl0NBXopzQt+UbzafvTyOZ+IRrpNeYvP4IjnhL42H/+2msHMhsCPJbist53PqBFie2Mhk+oiWS1dW1bargMPwmuU8XV/Y28hjZ+r5D2tCOEJhNaS+ZZKwqkTZD06s7o2cJ+zvmMYP/kJC0IBJL6WG6cctJ/gNKR8C9Pr3NX9Wrd04DxfF4boL+gboael5XtiTIYRTgFzpCQb2iCZ+AK7+9PBVGdw1oiXwtrENPTa1SjBy21KdAQYZo27bRWg2xbx759nzN4xWuqSa6aONyG/wKglsH1G/9etPsrry/x28+YPUWrTXojbblBINNMGAvPeRngUD8ZDlVKFIvO1xMNUzMgIoy1c8BpSRwfnRnbcQdfWAnm3cJKZ7tzagYCMr/Y9fseK/JtOvmj9V753eBaWOAKnpNG5q47Lb8bUf3tVT9iKStzHgw2c7YLaFM0YO54wHouWLKOfubSP2Wme4ZxKvguuPWy1JmVQtc/dYgZ/AlR6mAmFHKBItJUelFYrnoIkWFfbyhW/Z9IORfPgJ4mlzeneCg9hEGd7DDk5AzZHgdYgeH1IK8yZdQAFltEZidyXfbqLdEVTjy5kZp+1GhGfgSilarBOAFkkSOrkzYKEwbwU4O+xGkfQNkWYoJ3JRLTV8DEUSZYWwaiO/+myXsrlUG0Tekkuoy3pS+MFOC/76CCMuAfobK0IvhR9IKq1lCNCmu9V7v1VB/+05rQWmWsmLJBp0ryGCWgadU+zTG2nlxNed49yw7JcEraoDhj9R9iMCzkeLZXrHuxEaFEszPy6vCE5o7cpeAKBFOcqr1i4piywRB/jMT6hL58ncXHIrWyDKSJPThylWQhxzQB2nJjRPK8ewtPuMtg5vv3JVQrXDYnvcjxDxD2SpdlkuUAvdhKQoEARTFso/c4ImY9/YTyLKcupuMGCDz0CTF0eX52PPikuCF8V
 FzcwgXeR
 uaGWY6jgX0FPUDPmCrgXPftVTw43typeBSXh7GKiwRus/VgNscGFPScJLlQUkAN83UiBWBsSYPJbxu9dXRPzd4NM3h6gqhbM5efDY/shF9jtl98sGXO8jxJonRRMpCcfky/zzVYMHJr39ibuxhrEHIDvPlvN6rzltehGxzDMkY5Ywy0Xk3ZXHdv4A5cZ6JoonTflA2P13CXTroLT6JoScaeKE+6Cfsq9tqSbsjGKr+7WB9vA9FP/04BKlO8gBfkE2T+qdmYAgWodjCurDfHEyFJU8zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-02 at 18:03 -0700, Shakeel Butt wrote:
>=20
> Net not doing costly order allocations is irrelevant here. IIUC you
> want all
> costly order allocations (like THPs) to not raise vmpressure as those
> don't
> necessarily represents the memory pressure.
>=20
It sure will be nice to not have THP enabled=3Dalways,
defrag=3Ddefer result in smaller network buffers, and
reduced network performance!

Reviewed-by: Rik van Riel <riel@surriel.com>


--=20
All Rights Reversed.

