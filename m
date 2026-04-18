Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1641F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304276B029A; Sat, 18 Apr 2026 07:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBF86B029C; Sat, 18 Apr 2026 07:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F18F6B029D; Sat, 18 Apr 2026 07:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DCD96B029A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:01:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD1868B99E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:02 +0000 (UTC)
X-FDA: 84671384364.11.C60BF82
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1F1FC000C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVhUUdTP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sef1548@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776510060; a=rsa-sha256;
	cv=pass;
	b=4WOHyMNH+wpZdBnaR1/zKEMXSjPPTmxZ21Q+FrufZm40UWqGK0FJ59baA0TZIPkwVy/Hka
	6xlVrokApXfC1Z/9iw7ICvfMH+tnPim/OxIjXAaa7tz7w0ylx6fld8RY3plc0zchUw2H/L
	AOiq9zhmEKSeY/G9qmNoeBkVsNIHJ/k=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVhUUdTP;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=sef1548@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KY9FDmf/9WVv8g70PDtqy5k3Dg+uSpxFrEmWBPNN6G0=;
	b=oLKXg3iEyn9zAISHcp5BbK3YVoWaS8/ge+vphhOW7jUIqDiole3m38D/w+2AvabqD7unki
	jxQM6xhwwQG7ys5E7rw6bP/nQ1fEwWHK4i/PQhHdS+NimakTTzJ8vrVHKT8J3UgHJJ1yAY
	4zSKFHiuYYXMc3Zflzdlxpf2CmnvkRc=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d03db7f87so912714f8f.3
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:01:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776510059; cv=none;
        d=google.com; s=arc-20240605;
        b=h5f1M0Y2CRVCeL9/TN9DdC3PT8vKLrdbZn/aXNXXXhJ7EZ7K8TaPt8eOzdfXbMVKuq
         kOsY93iKC3lOmwMkxciTShiwHbCNjCNvFcaT7mqADvS9oZrKOJiWnSJ+B+Qrx5lVyuBW
         cc5pC9CHjonNLLfa/mMJSNpXwF+QysgnVfwKOgZ5//JHYzBaNld5cla4WzKCCtRwgrM9
         0hvZffl72RygbhY85OX1E9n2O73TBlT2ioI80p+6SVBHAlDi7d4CxLynPo3L2lszjUDY
         GnGsvHjTSI7KLGqY8drfESQa9CpObtzYJeZATBk6v4C8fkXrmPgjKsJqeU0w2nc60UaO
         lExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KY9FDmf/9WVv8g70PDtqy5k3Dg+uSpxFrEmWBPNN6G0=;
        fh=1egOpRjCSJqYLk4pHRe7SXsq+wSBhFy/b27ZZzxqGP4=;
        b=hjPumUkAXxcP3hvSnk0HpH9reLjjWaiudIKmPz3EJ5CBCOyQ+tupuekDwGY6z98hyJ
         bGMULoLXwjm33Ei+AsMXeV9hYs1SAUvCv8fq0q4tDFK2hTk4NaEhqIjScLKspEzB/ZzW
         G33b38eG7zNPjxVR2ObjJeNTqpyqpK+hZpectnhLwJWMfDsmFdwBAL4kq607b9Se+jCH
         QBqCKPRbzpgrdpOv8U9slK8Yu/rH5SVrKus/0i2THXHZ7MxyEJ2IufSWes9xkwgML+Fa
         TjfSV2soblrfgk5uOxpYYBvBpB4SYuSqBvCyknb0PUX/7j2Yjjqo4k4isRmP6GLitYH4
         eRNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776510059; x=1777114859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KY9FDmf/9WVv8g70PDtqy5k3Dg+uSpxFrEmWBPNN6G0=;
        b=OVhUUdTPgOxtr2BkYlayYicyYt+EohwpQ9CMvXTTQUDHcpFApnERYMr2Kf4C90Zshz
         Q7J/4iHhhIOvwn9shMV8FCy5tKdUg4xtCd3bDwqfRfpzrVtZ1ahjTn7+S/Y36GQSVOah
         tGMkY9Oy3QrZgL064r1eiGj2WZEbxuOEkjjX+4uQgAd2gSckU+EZcLvrBzfhCxlKrBBH
         zc050j/ZNynQCthxoRdPPDWVmne7NFGkw1Uo6TQPuus68JO+MK3LcepBBcRCFbm5FPjD
         Bg/higB2XHnML0e7WBsI2h/ZUGc7+Uu4iXA/lpXEVwyR9Uiot1dGL3lEswoP0te7v2up
         Og5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776510059; x=1777114859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KY9FDmf/9WVv8g70PDtqy5k3Dg+uSpxFrEmWBPNN6G0=;
        b=S6SpB2nLBx4TQq0DYC9BVPuSR8kVVGLwFQQMP6X0wcbBPfQpGIe4gEmfriWvyW++Tk
         85J3IcDwef0OTe8ug51A9Kb8+EQPYkxBOJ/suiULZ19XFr5RoZLfyD25w3ez/3gUQp3k
         9fWJ2+kLk57pTtJMAIByS5ihb2WM5NfoxepRxBQA+D03T7Mveb+1oeku7y38YwTPTkTM
         vIIPlxVjP4YShbuk3km69h5RfSfuWigABecn6lDep2hfBiMb3eTcYOuBrnvUtYNFGfm/
         x794PN6+cAXS7bUMsAdJX5Ye8pkzeOjyU1j4GI0uqIGZaYQLx5z2JWCYq6tnOX4sqhBm
         9sEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+tfC1EUKFw/T55isJAEYTuxWcQoqrZF6qoFmfnAaIOyFR17NEm+oKVARtvru12OSby26agocug/g==@kvack.org
X-Gm-Message-State: AOJu0YwTDf4C4zNPnzP+zD3oa64f1wEDebIEbbyteciOnO2meiGq7rI7
	CGvcpkrXZRH3YRR2k0fSPZTqfHjQZVDTRcDt6EqrVRUIx58zjVUg4xY3b1sbs7y+C2e4vx7yd4B
	m2WnDGVsRQJROqy71r05U5T9yZVxj/1U=
X-Gm-Gg: AeBDiet2J2dJ7eTF0g4rHLRVtYf5ibp4txykA7R3W+Fje9AwKeuMANHYlKPNIryQLUF
	xOad4OVT5vS2/o/A0IonNYLxPgLvttMk6jRIuD07ZoKZcJ+p2MVyv83kuK3+bODoSu6fEtqO1ME
	Dnbjvd35YT1p2CQTQd0jaer3ib86ZQnHNJ6lkQ4ISdjZ+WKwoTLTNSxEfcIMwXYXzg2ssTogTo6
	gYadnA3xDjVKdQ5H/Fff7v3M6enC3BJqLQh4UBGylV4wmftt4Yb7vkSotxo93S9h/XySaHGM9XT
	jFRlrJGvVc6s/HOyuKK1CHgucP7jhAgkq8PMFQQcLNM4dnLL/pVd9cJESvUWa7s=
X-Received: by 2002:a05:6000:2389:b0:43d:7ea8:62e6 with SMTP id
 ffacd0b85a97d-43fe3e12691mr10336752f8f.46.1776510058749; Sat, 18 Apr 2026
 04:00:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeMQ36jFnCKmCSyA@casper.infradead.org>
 <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
 <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com> <aeNKDh8S6pXHqRFh@lucifer>
In-Reply-To: <aeNKDh8S6pXHqRFh@lucifer>
From: Nick Huang <sef1548@gmail.com>
Date: Sat, 18 Apr 2026 19:00:46 +0800
X-Gm-Features: AQROBzAjQEWkZDpqcselXTdf--Plbsz__t87x58mMY0oY0BnRQbcqKaJWjYoYNY
Message-ID: <CABZAGRGCwM1PiSxennV-Uy9y1gGKjpcHeq+eOAbqSZcy3Qb55g@mail.gmail.com>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A1F1FC000C
X-Rspamd-Server: rspam12
X-Stat-Signature: rroms8hfb6ujpqh4mx8ynukx1jzz793b
X-Rspam-User: 
X-HE-Tag: 1776510060-748948
X-HE-Meta: U2FsdGVkX19Wa4xUGeyhMPuk17AWAeyAb39vXaMxlL2jhb4F6+Q42B8ISZm3H4Hjv8hIkEhDMpNeRby9fI2/noxIrOd1j1XmFEYIZDAABIZckZC5Ov2GRK5nDP5SJfmV5b6aUE9yxOLcQw2Y4mkEKDeCvaTxvZr8ClU64+BZGUjgOq88R/LxdhgOn5E1yO/HnGE7ww/FS19qxwGB+Qz3lKYZipo1A/YmU2e/iA8joxXimxYq9CFl0etV/jQfuBK4m47eBbWA194pLy5B2IhdcmXGTmZwbWFSz3LJ4kUoT74E5M4VI8IodbSGmXEQlKhvnY9bOmZSUz6mdIjpIL8d0yb3RwX+YcKYKP+DYhfFu/BEo5t4WTIh3GToByPDbr+JELMpPPiUueJQEXCG2XhaLx13nYi3mRxZuxfOnk7H6I4vNKW/051vkqZwPFuk9GwJ4torME5eq4w32RMrPEtFWW+Q+uwgw9aTvMLhJX0hYfsUCGybGuU+ZSKNWXJoBmorO1pRgMiB9Un2ZTZPtJsJhKo5/UdgadsN9XDZHj4pngxiDvaG8TUg7IHSv2UGrDpHAR8HAiucyFjrfAsGiLDvMDQ9C3K33kchbQKXSurcdhgA6yExq42sKEuxWGsisFz5VdVv4DMN1IV563EygAaAgBnaC6XR4ZGbO7YnQjVKhXuRxa/hGqFgIGnYUuvGAI07W8fzIXIYMBG/fZYk0QmFEGFfrZSf0RPlxr5hgKgTJKWlzDXzP3Xy1F45+445Ovbi0sfbb8vrj28qK/LmCCdFGZ38Vz3dk+ii5Zu/h5Wumv0TMS6Q1nT8nLkpnfdkD5M5RdmcI3eAnVylF52zJFNzmKQsZUEZt5jEk532fVD4ZQ4TBTxd71A+34/3jmjy5pKc9yQZTL69Uo9sLZdfFXG8wywIHoWnUJyQoZh8fSGoVwqy+Sgk2WzYu5mfHQZHqKHZF/4YQg3qrMkJbgIKPFa
 9h47WbHd
 25/EpCP9Wy0Lpy/zfHTMvNbSf67rJT3dmV620GmkxVqWrbbTm0G3oRG1rMHeMINNfq5yl/hL0CY4B3qImqyb8O4W7V8AgTJAswASy9qZG5stwDLZz7Dlz/WUzuRB1inFIvlqn9Wt3JWrvEAFzsuAD7e9Lm/BvkEth5W3vAW2cXoJrwrEGcH61vlGo3A/eUhmxG/9f3GCMhqp+v3q+mqbCUW0CfMTy/ntrWGfwqKyuEhF6VMS1wBgval8Odkllhz+X6tPVY8xZqnmsRvoNHQMWIk3HKZMbldglZryjkY7pmFP97vwA2IKNOVIqWwnfc/bRaH0CT7oV4W1rWqqMq3LKlovcxibRZNcfdRReL07ADhgt53Q6plVCVyfZsnz1l8iP/nC+R+inNXBTqorVN0DT9wHrYV6aLH5R8xaLXy2kg1RxR/6fK12MnboTLPfP1RRKNMHvXikwOWBU0HY0UbUQstmEaeA6uzNQhMrlxtn4VAO2IVSxucKfta/lBhHRMGek9sPl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo Stoakes
Lorenzo Stoakes <ljs@kernel.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=8818=E6=97=
=A5=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=885:11=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Sat, Apr 18, 2026 at 02:12:22PM +0800, Nick Huang wrote:
> > Nick Huang <sef1548@gmail.com> =E6=96=BC 2026=E5=B9=B44=E6=9C=8818=E6=
=97=A5=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=881:27=E5=AF=AB=E9=81=93=EF=BC=9A
> > >
> > > Matthew Wilcox <willy@infradead.org> =E6=96=BC 2026=E5=B9=B44=E6=9C=
=8818=E6=97=A5=E9=80=B1=E5=85=AD =E4=B8=8B=E5=8D=881:04=E5=AF=AB=E9=81=93=
=EF=BC=9A
> > > >
> > > > On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > > > > - Add "Overview" section explaining the slab allocator's role and=
 purpose
> > > > > - Document the three main slab allocator implementations (SLAB, S=
LUB, SLOB)
> > Hi Matthew Wilcox
> > I will remove this sentence in the next version:
> > =E2=80=9CDocument the three main slab allocator implementations (SLAB, =
SLUB, SLOB).=E2=80=9D
> > I=E2=80=99m not entirely sure I fully understand your point. If I=E2=80=
=99ve missed
> > anything, please let me know what needs to be changed. Thank you.
>
> No, please don't send any more revisions of this garbage, thanks.

thank you for your guidance. I will correct my work and introduce the
more recent `barn`, `sheave`, and `kmalloc_obj`.
Do you think this is appropriate?

--=20
Regards,
Nick Huang

