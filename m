Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 243E310854A7
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 21:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F606B0088; Sat, 14 Mar 2026 17:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D226B0089; Sat, 14 Mar 2026 17:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34C056B008A; Sat, 14 Mar 2026 17:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FADD6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 17:01:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C47E7140927
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 21:01:22 +0000 (UTC)
X-FDA: 84545889204.15.86B837A
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A47840013
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 21:01:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sWP0FvmW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773522081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+zGRoENMrbo8et3bFP/gCtlGLikevvEj47JRHD6z8Q=;
	b=nGuCHs3KSeK2pczJDVLDdYESFcqXeoABmJ++eCXcG/CD7zQ6x6hDXr3hXOySsvbZEe00+F
	BKl3HSrajYCYdmKQYr2OC2rWxPz9sWroxS1Sm+BdzUCVuZP/efZMPM5c3nYERZqzSjX5Or
	p8gKAGY5yN5ISICLNqK1tVbAhFVoAe4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773522081; a=rsa-sha256;
	cv=none;
	b=1d2OX0Qcoi4hMOdwU1CNALG+8RHdYrH+B3rI/zHlDWnTgsoDDzNOYvkYO6gyx+Oh9aiEf3
	zOnF7F+N66V9eNHkfnDLgtK3IEFrVcmckvx50mia2ShshOYoRN1szDrs5WnA1WiTP8LSkg
	Ps0TVe/jUG8T6D8By5OEedMGepa0M20=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sWP0FvmW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-64ae222d978so3646736d50.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 14:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773522080; x=1774126880; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+zGRoENMrbo8et3bFP/gCtlGLikevvEj47JRHD6z8Q=;
        b=sWP0FvmWnQFS/QISqCHuXqrP2gVnl0QEbEHWSia/IPNJxV6prlknPZY6Ueepojaa/e
         /a53ahcjjwO9RnXnDzkrL5R0UJSDA5qY0L4oGt+cWi/4BEkyju37B40xTnLuO2dH0MUz
         HceCs00OOtkN9DsYDcjQ22+9FDFLLHLIn94xY/OE8VMbLlnZK/0hkT8nmlmA35VYPz5x
         k9m56Adbx+xUKYjpvS6yuaaNvIs88uu6p7m3I8dt2OnLqnOFhJG+efDVChGiG3q8y9Qu
         7Qc1tVhehovQk1/JWCbolmubP1D9N4RYF1YkK2npfc6E5JcW29546Wx4JdPVHOCZEx3F
         Tikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773522080; x=1774126880;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+zGRoENMrbo8et3bFP/gCtlGLikevvEj47JRHD6z8Q=;
        b=K7QJ3VHDYVLZ6MVJ9Giur0iL7Mhon7mqlZRlBPnlEozc6G1tIYzjpBKG5s5E4VHQeH
         Dvo0dOekawVvaMK8u2bD+MNBmIfwdpKjMqy6S9VGc2OQRSLMTaU+/cTMIehBTbSOoJgk
         GO/zRuCvR9Ib0wqf6DekBgXnHc00fwiq+GY9OlBgFO8u9+E8Zg6XdjP7OQl+eNfgAeM8
         P4WS97Y7k4TFdMbFckn8mqH1O+GW6Zxd2wnp+Uk2FHzlpbiccEdt9EbMYcn7dVZkQNrc
         uOQGRmtz5jnwOtCQIsl8fyipOEyimAZL4/e/I8MdTENOovhJUdJvoGa0ZCmyQk70dj1o
         OiOA==
X-Forwarded-Encrypted: i=1; AJvYcCXOKgi+yKvT6QcZ7J9bTTbLcjsCinO1t83x53Zfsor+7ROAaHdL4/yWa7W2CWP05p4uYhT4MKKHSQ==@kvack.org
X-Gm-Message-State: AOJu0YxKFL8WKh+zwPoZ0Koj8AxWAdPa9F+uTntflFum9gKOJYTNFtsX
	eoUaRiMSsiZoz2KrWaX5taf16Aa6F4H+RpY57Prub9yPuHDtJUohUn8w1iKzSwnJ0Q==
X-Gm-Gg: ATEYQzwvX3B6mObO9N7RTZ24kzKbfaabgyOVhRuS3BuK1WVVA8rbZ1iguE5/wlLfG5M
	Z8usXWs2fcZAjWAS2umF1j0YG0x9m6ls7TvyuuT4BDDqoI1TLAVJqp4qBSFx7vcV93aXJ5r81BB
	ShzrLTtnZ1Yfg3okuppwpF9FTgHasY+PLana/1gjAH4mLc2KFhvbys3QKKi389pG5fTeYSKx4QM
	NAQgB3mtWKOsi+ta+acZY/YpF2Ddz52PgOMDk6nqHNMFGs4fvGtAiKwDetNCtinPyS3aZgKV74R
	+RZavi5s5Mo1oncj1XtJ5rCwBX4XfYW3CHIycU4CCz1LXbAPt1hwv9yuZTLw3Zra4pq3JrVJVTj
	Y5+mRpaWC4gpho9bE2vhHyIZjh1QdH/lOWOknwlrsg3Rm/igJklo0hjEcj6uFPYLaIudhSEYeF0
	3b7aGftjExLuWmzSrVecBQaMLUcaI84ccraqNTviwZeWBnUNb0kEzf5hclJqocTJxCFxcvYdnRA
	G+9Jxk9dA==
X-Received: by 2002:a05:690e:1c19:b0:64c:f53b:d3d9 with SMTP id 956f58d0204a3-64e630957a4mr8568179d50.75.1773522079573;
        Sat, 14 Mar 2026 14:01:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e65a51580sm3183232d50.8.2026.03.14.14.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 14:01:18 -0700 (PDT)
Date: Sat, 14 Mar 2026 14:01:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kit Dallege <xaum.io@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Jonathan Corbet <corbet@lwn.net>, david@kernel.org, linux-mm@kvack.org, 
    linux-doc@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
In-Reply-To: <CAAZVx9_6ecePCB1MMRa0q8V4afa=zRSmcaiozaFPDrrK-+bv5w@mail.gmail.com>
Message-ID: <b4203018-78a1-2e24-fa65-b02553abcea3@google.com>
References: <20260314152538.100593-1-xaum.io@gmail.com> <87ms0ajtvy.fsf@trenco.lwn.net> <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com> <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
 <CAAZVx9_6ecePCB1MMRa0q8V4afa=zRSmcaiozaFPDrrK-+bv5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463770367-168415370-1773522078=:29478"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A47840013
X-Stat-Signature: r5amccne8mi66fxgb3xhg5gw5eytweyt
X-Rspam-User: 
X-HE-Tag: 1773522080-757198
X-HE-Meta: U2FsdGVkX1/KdiTIXxVVzT/aJOAfEhp+TiRQtjVuAB2bLKQThs6q9Cgdoup96EANmetY3dIcm7xtGCAtkQkNC9Zq8YFJ1ZGsER5zfIseQca2MpPvNxexnD+wfr+q3eAKuVJll+Cm6q7Cp+RI66y6cFpWlHQWP8S1IdIVTp43wVIv60iKGmUmxSG9tKMt4HlfnkJo/9r2JOA0ySXx3R3ctsEsiqZ/eoMIjIFmbgx3Kx6NIFGdLdtraLQKmSJpXKoO2szLirxxjAZLB1BuTl6JE00SwzPUpKoHHqfA+XhwgErfTrWYgwl2sz6EapxjepInpbeNhkqO26k4yjUsCYElt9QQOzZQ/2snkmXjUIdRuSsMac7uNsRcUrcl7pa3fmCvZpbWIvUynvXJKaDaYjBq0d/I/qjOQJhKVnXemdt65bOvC/caOzftTpfK/FcHQhNZsHMS5u8cEynt/xVta4LQfl2FGDegB326KEdjmUkMaH1NwHKb0kc9QAGeq8gIe7FzamWV/Mabk6oJdABKup0fQ4K2imOCZHdTrJ335EffyDx2hXqte5MSlJp6/UmeWSpbKf3C2IMhGMp2utfplMoMMhjxlug9HU/BfMb849B/51prbmmXx5Vf+wArCRwNIVSngIot5mgXVhWQYh60ZwJ60fyVRUk1zebxbs34qeLyfOMcAxJLlj49ePsOHhh6Htd0SYAX21Qwlb9/qNus5uhKr8PucJuLWdrlzm512kDKfm3o4jALD3ftEimuRvzrIMhJCd9M24rThChZ+uIqb6+FDPltu5GBymkGvEs4FR+kgUkfxdrY/mDf5DkHzHwC6yX9+BzP8DGNydk4wmdNlwoIw2D1p21EWQRoy+Im1e7vVoKnyweCYITligV4WV74gRr0K6ydcYgMHk8qQ5ZE0+3BvKjDrfVbv2HQCMAYLOatmVlwhqNJe+Me+68oJex2TJe9uuSgHZwCkoVNdSE104f
 8a396zcE
 igwVPgKF87Bu309X+ETXmpw64Xy2VF+iF+Fh8sWyU56ub5U58cBOYrCIi2obHlKrsVcuh74WCnFo80c++JAcbtW4NWTFnbC6Otibk51IaA1eoIVx5/RjwsdUOG90wBu559YJXc+72paKAlEu6ctkewnzoJfE1JIX6aLIti15cLMAo3NKfTEfz4q44zcpTxK4fnV7R5hIrQ9Jm86zxxhXgYNHQCJGXNpqUJ81SogIT/KfCghQsA3sCkMzz6Xc5a23s3GhKiWiaRzig7gKLCjOHlZZshFLeH6L9a3LmAPKaagY0EaXHV5p7P6hr00ljpywitc+++10IUtmUNFI7apJrkMHPrwDmbLrPuhirM5KQpwgtH7/g/cxpmv+L94jD9LZUSZyRLFghUgUMoxqOGZGZD4+cU6aiOKUT5sanumuuJhs0EvBqNK6wferBI8xgXFERHAiL7uefc3iNZ4GYQyZ8neNatcJ0rbWGCLluljAR+cyPSD0uqMCR94i/DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463770367-168415370-1773522078=:29478
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Sat, 14 Mar 2026, Kit Dallege wrote:

> Hi Andrew,
>=20
> Thanks for the positive feedback. I'll add the Assisted-by tag in v2.
>=20
> To clarify =E2=80=94 I used Gorman's book as a reference for understandin=
g the
> subsystem structure, not as a source to copy from. The documentation was
> written by reading the current source code and verified against it. I
> didn't contact Mel beforehand but the book outline was only used to
> identify which topics each stub file should cover.
>=20
> Happy to have the relevant MM developers review each patch. Should I
> resend the series with the Assisted-by tags, or wait for further
> feedback first?
>=20
> Thanks,
> Kit

And now the negative feedback: thanks, but NAK to this particular patch.

Documentation/mm/shmfs.rst? I hadn't realized that such a file existed.

tmpfs has been known as tmpfs since 2.4.4 (but a few people do still say
shmfs, and I'd agree with them that shmfs would have been a better name).

Please send a patch, either to delete shmfs.rst and its index entry,
or to redirect its readers to

Documentation/filesystems/tmpfs.rst

I haven't looked up the preferred way to redirect in Documentation:
I expect Jon or Claude can assist you with that :-)

Hugh
---1463770367-168415370-1773522078=:29478--

