Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19FA710706F5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 18:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076C16B0088; Sat, 14 Mar 2026 14:39:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0247E6B0089; Sat, 14 Mar 2026 14:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72C86B008A; Sat, 14 Mar 2026 14:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D56CE6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 14:39:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68D3DBABFD
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:39:09 +0000 (UTC)
X-FDA: 84545530818.18.B15CC04
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6CFF4A000A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 18:39:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SgzHHYxh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=xaum.io@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773513547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZrOqUX77UA3vcyaoFXxYGiBi+f46D4ZwPXW+m53vIg=;
	b=cVPTSp/psa0L79f720z93HXtylNs/XJ1LjDwwXRXCMUYbCYtL6NWgNdD4My+aBhF7Q9CZK
	bcTDST1cpyo90n9b/ALXgBDcG08DI43eyZE59kt9Rof3Fx0kvU1odOEacVkB/vbZtAFHCl
	Yzu5PV6Ys9hm0LpwoARnX2XMhOv8QQY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SgzHHYxh;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=xaum.io@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773513547; a=rsa-sha256;
	cv=pass;
	b=tfMjPNu08MYGxx/wx2bVOYC851Rf8D65t6rW8iNZhRHd7eJdh39GwCxka+4gTftyjpnPNv
	MLq7fIqSoanr+IGXAuChPcpMeRrKMBhkLKHxxOby5qsayLyIylcvXMoHZFtGKjdYOh6uuX
	ELCLRqOq9kh2rRH7u6LC6myqiHw8Rzg=
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-466ec4c6852so2124868b6e.3
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:39:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773513546; cv=none;
        d=google.com; s=arc-20240605;
        b=VDztyYSSvd01/17menh2/TTySwqsTO53+2hF7B6kRyCxrTjOngy3a19SDAe2jUu9lQ
         OGJj6/JB3RsZ2RkDRFiEszeUA5nA6x5eB2hM49QtB09aaYCdNS3+RCZ2pODf09QM1Rz4
         zUspVpbpLRiDlNmOsVrM3aqIWa27L5uZ6MiDj9Gews9C/3cCpIaRNGsgEoWoZf+VrCti
         hUCij46DUPOIeJYmDiPaf8oiw7hRnx/Gw1VDHuV4nr8ON8ehsSW//MawOhtZQrm7oM5s
         ma0QtvOXiMQnWlUj4N5Xp+gOt2XKEUE6m1Ky6+8dw+GJFcqx/8jGszyIeEq+bRXwK9wn
         uf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AZrOqUX77UA3vcyaoFXxYGiBi+f46D4ZwPXW+m53vIg=;
        fh=YhCQ+31ej3ZHj7kTbSij2Skl669JuiKEFtpvAvA9YmI=;
        b=M0y3d9Z9SCLTPc+AQj5nQb7B//WuONHj5ZkA73wUWn1K+gda66VTosJQIB0sZN9tgn
         wEIQkzEA7gkmg1FifY6i5gJA81QHjoy5nd+fnkvsAtwC9bvLxHKom9XDjwJsQQQMCAEh
         FFVGeJrtSthtNID3c4ma1PmrVheHis+HHWkdw3lP+BLzu9pIz+cqa3AB8xdNTTUk5hGt
         fh4uSI6BH2or0JHG8g6Q/9Z+u70QtxPPQmpvXsrighgLwNmftkyjXWVBmADlDr4GHqmH
         nsqJ9udNm/QX37hz1Jiz3Wxp46seeTISpTqG/ZjvFTPIlxVZ6CwlWG/yukBdKX+YH/TF
         HKtw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773513546; x=1774118346; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZrOqUX77UA3vcyaoFXxYGiBi+f46D4ZwPXW+m53vIg=;
        b=SgzHHYxhw551YwnZWlZ+3luq5fJGDFuDkhBmKZm0BTscBn3BRz0Q/5OE59c0PUjcv5
         7lndEApkfbbptgy3s7V9Z3BGrPSoo2PSeMeeP9vSaGgzqe4JGfeiJ9DJXPyQqtK9alQq
         I/xIsa9ZCE3bBSUn76HLZJzsITLu0ihLGS/2F+tVkYJxSnr1n981gpw6zBWzuJHpRhLz
         2Ub5rOVDcn2LEoMwQs0riz4175yQ2yLZwUULeIqD7gYydkoNsHWqQFyySInO8HkBXzj0
         CMFKzbLXc8TBCHM2aOYB/MfsSFf6nnYUul3n2s9F8sqj2/qYJ+CLRd69kmG4kMvzO3Fl
         spJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773513546; x=1774118346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZrOqUX77UA3vcyaoFXxYGiBi+f46D4ZwPXW+m53vIg=;
        b=aNCjb7oKa8yO1N1yxZbL+kGxvUuko38tcSURO+/L6NwCI9jn7VbpENTcBuoYtl7AEi
         HHprsb2t0c+HM5BN43Tlurk2owDdUM8LD98eF/4Wc3kO7N/W/OVtxxauc9lQ8pdhayYy
         5z1YHjxqArcYg6sIPUbGi3mZ7rD/xMpLvh4xw8mm+La4Jkrd5eR+gsdN7BRvo+wL0q3x
         2cJNZusOinvJDVTUh/zTIth9SgsjbDMonceLQgiXeDGgtSB5UEZe7qmfESF6eyGBjarL
         DhI+LVL3uWArNdqCdsnHp2gYtrKK278TgX8b6132yGPB8JQ73wqeD2HjamGr897aRQxu
         E/bA==
X-Forwarded-Encrypted: i=1; AJvYcCW3d3x6aPjsaTU6u6/x1BFF/Wo9JCg+KchfdQ/DL5sS+EcwBvEddkse+QJnuxcms+kxzePe42Rakw==@kvack.org
X-Gm-Message-State: AOJu0YzlkZoYEi2vYi/DJ1PlMFgZAZBaec1OpN7JfpXZn5jB6sqeJjxi
	JKo1UjuRV3uxJIgYhan6Q3h3JfCiVeKDSwXdeifQ3aTh/g3q6Ko2Ebh8C5i3zYuKeZpinVpomnP
	VvV2l+KVLD94j8UanTl8RMIhWPyc9UGs=
X-Gm-Gg: ATEYQzz/7p2JnnPQ7BmWybeOVvgAxaFh6z0Yq7NXtxMt3kX786alrOLCLfDNz5VxlxE
	S5oC6vlV+NnC7g3tpK9gC9y900jO9ycs6GOW6XoYUHBYb9zAJ3vXDuVgbty8oHtYsNa8pFA2uZ2
	/AUR0oDxQAh5Wl5cbjvl2QAs9qlTVjUsO4nSMWEKXxHGZky3OjGe6jbeMDGle2RwW27huGv8CGo
	iIcTvx41xl2Eymi/dWtcbuOuAE6vfBakGgkOjgvnKqT19eHA2bss4C1HON/tKFXfDBq1aUT0NLK
	qdWblhRvOoyNVcDU28ZjviodYeSnBV3DLFcUpop4brEwWoDbS9HVNn3wsG4sFhB/nIAP3g==
X-Received: by 2002:a05:6808:1b2b:b0:467:318:a74b with SMTP id
 5614622812f47-4675716c5f1mr4054747b6e.28.1773513546160; Sat, 14 Mar 2026
 11:39:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260314152538.100593-1-xaum.io@gmail.com> <87ms0ajtvy.fsf@trenco.lwn.net>
 <CAAZVx98Sz1MknCcMpQXxeGpUjXBDyz+0KyRuUiCXsM+3qzqpeA@mail.gmail.com> <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
In-Reply-To: <20260314111757.2a17c3acce8c3a1eb68ed209@linux-foundation.org>
From: Kit Dallege <xaum.io@gmail.com>
Date: Sat, 14 Mar 2026 19:38:54 +0100
X-Gm-Features: AaiRm537Q06X8UVE9YoUBvoT0K074F941B6dRgRuPTK0qHXNEw40OFUaMlZ389U
Message-ID: <CAAZVx9_6ecePCB1MMRa0q8V4afa=zRSmcaiozaFPDrrK-+bv5w@mail.gmail.com>
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, david@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CFF4A000A
X-Stat-Signature: 85gnp565w5ax7unyug46wjwso85cx4cw
X-Rspam-User: 
X-HE-Tag: 1773513547-640010
X-HE-Meta: U2FsdGVkX19Ubf8dwSeSlZGHHUSRRKE6RH6dq4Q5sYJ9+nA6ECXWNyYem3tP7xzFn07hchBhAypvydlHGCOrMIMuADA+4YNBeqCL9WubVlfAXYMbUXrRM+T4qw9eIk8hiG/ojGltSFOxXVKzcPTyVQtk7dYPMfvr8GQOhmKbkycaPCUda/g0vO+I1Wj2fBaR28y1XYIF0i5OtcIaqlNvZT+tvl/7e/3HqOWJ/7bnSW4e0NH0NOczfbwfjvqaRsSJYCOwWCt6St1pQLpXF5Fwb1Awz4BuX3XS780YQgHY+iBqmXxFosKp4x5RElmJZHswIbez8MxdOn9EXWdIF6ZkN11Ryn4khmWykjd6BnSzLcJegw3Z5lMFnQZrXRLZAqIiJ2kUenLpUxGWB5swSJ5+B61Gt5K9JaEGLgFEjozW+Ur460iJK2D+yl/xJy+BXVWYyLabLV+cXYnNQJQsH935O0oJoCDOsolHzEgMvE2U3OmTdgWdK+O3Sjk8xCy/Hob3L13TS4krmGjqmI2qTZmn3Xt1HVzovXqQLVHE/Wkfhdm+WARBdPBCiQ59BNPnQ5SCWx/ZP7zuglmiqIcwE//fmJ5/zneKeUiuyCsGcyJejISTm3qdUw4FVvichEaBXXPn1urEI9YLwVdUjqlbLk8L0VSnQ6nfaOybclYHpqqC4xPsU1Ipj/W4wDuUURVsNzyxUReXAgZJHkHc1TgsHT7Ng8GQZ3fGW+nWmxalq/2Z8ussXNWW5MQyjb3yI4LLm+Af4rHNdS/Igol0jLeEMx+NoQOeCakspKegg5iCLK1YMkBDCseCRaEmcflMZzzYcsW+jGn90Vvqo9ylOq+mtlcxK6JMuimHmK4aTUcTB3y0ZqXHLuOH8893/KdNUaSwHkuICVnap3qQgT5Ucj6iDnEueAI4Szvm6dzQ4P4+XyfVHN+TYKnGO8wq19emCvL01jx58QGnX8u2oRv0F6ir6XG
 nP4/84yj
 JN0JEEPVvI8NdspnexG4rDehPzZgwfQdFEPTVrLm6Uh2FxiNEBg1c/FYkiMtTuQH7FFnAYprbfx6iZFIqOj69X0alP/SwQ88jVX90T6aJ7KS51dcgBomF0prRFPZKprgQHLgJI5XlWEr3bfsTPW55kp+dlO74dfmsMwtY+S1dhtYxEGyHhjNKuIZtnEF6RAb8MD9JWEv1Mnz81VAa9Af0j3+KjU6ByVUanBeW/xQnZsnVRxJm8zztbth2M3wsEbYtHiv/6KulCVPCDUVTWYewwScjdSM/+86u05iIVZxshJ/3FOHYTV5eaDCZOoesw0h7Jp9RTmPv4bWinQyqq2o35V4AUaZ/uKCO6r8zLgIY5+IMQ8AC0Ekp0rhu7GpAn0DxzjbfQ4CgJJhypPZ1DtNjfB5u8W57qDstJcQN7Crbvx/+thA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Thanks for the positive feedback. I'll add the Assisted-by tag in v2.

To clarify =E2=80=94 I used Gorman's book as a reference for understanding =
the
subsystem structure, not as a source to copy from. The documentation was
written by reading the current source code and verified against it. I
didn't contact Mel beforehand but the book outline was only used to
identify which topics each stub file should cover.

Happy to have the relevant MM developers review each patch. Should I
resend the series with the Assisted-by tags, or wait for further
feedback first?

Thanks,
Kit

