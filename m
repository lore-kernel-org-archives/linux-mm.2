Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B312CEEA876
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE3D96B0005; Thu, 12 Feb 2026 21:22:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E916D6B0089; Thu, 12 Feb 2026 21:22:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72FF6B008A; Thu, 12 Feb 2026 21:22:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C57036B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:22:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57011B4D26
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:22:07 +0000 (UTC)
X-FDA: 84437833494.24.B9CACF2
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5CCFE18000D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:22:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L3BLj/XA";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770949325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0yYhiqhUVpmoKH4cWdQr5AuyekJIQMbtNgTRaSmD9M=;
	b=tQ5McxbPqKV7AVVyJyu3MOto0ADfiHalTLThXyyHTzRyvQc28LS1g6INuy8PijR3SAb8RM
	571V9mvzZVU6g/LHU6aHiTd1BVnfOwchbg9v8o5bPOFTo3s7FTzgvHR5AQDwBLPvU0ocoO
	39WZWE08wCV3zs2Uwv43nSe85bJBuMY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L3BLj/XA";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770949325; a=rsa-sha256;
	cv=pass;
	b=BqlCcyMHDtKh7BHxzZFAwcFdBetL1cVzKJu/fRgPtEPAmQQrQhhB8gU9By/zOyInje9/B/
	ulKuutKQu6EwlxKz61o0e3wEv/6xjICfzTigbIF2S0o9Vct1PqSAgQG61G4WnZRN54W3oW
	B/gIbVX3P33gBYMdG4TpP1cpb5mEPGU=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b885e8c6700so62004366b.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:22:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770949324; cv=none;
        d=google.com; s=arc-20240605;
        b=lvm01akmNPJm3bTxy8pLQWvXXWayYP93R+Yr7/dEcM1iUkC0b+IHwLY7vHlX35eqLv
         RSxiYUVnM/KTf7pEroHrQgS4TazLa9t8MNAc5qK2/R9VvBI5Bgsd0T/tYpdRpbXOUwQk
         tYufUz2QgCe6UDc4TUmDhBeH8vXIMKavbEYssvYqa/LDEIZkQnYv1xegJ4lLT90j0w4W
         U4syYAc2JfEl9EjtYEqi6BGARzR8sZzD/tGIac6Die7GoDPMGtE/b+kXV0WXFPG5oXPr
         f4ScCzUYVhuFIwXcO+jtpXCILn/Ifhr4mLcMuGtSNO8iZPmH5N0D3qV9Afo+emteAo3v
         ctnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A0yYhiqhUVpmoKH4cWdQr5AuyekJIQMbtNgTRaSmD9M=;
        fh=SSvsuFK+4bZrzzCPKF0XQj/iETdNxZISu55qY76DIZI=;
        b=OpRSj1zhI0zsyTjtp2VV3K0qZ+W/23guv2Kj8YSCqyB8H1z2R3a8HyAMG/eHCraHbv
         obW/4AJgfD4WfEcL4Z4ypIHUp4C7MkH4JYFvu0JU7EhCj+3mR6VqYekoXc4PLcaYAc2y
         /KsvYM6AAhxOV1fUPZHHtRQ97WaLu/yFDrTZFjFB1+rU23uyZDkG3B1Lph6iVB7xCRwZ
         Q1Xrysfvd5aWdou1+LsWr/IvKb0DRCMYtffN/aNz5Xfmcz48RahSHmuK0i9lMT5/zz3d
         0q289uzE78dYIroAj/dJiJHK18mS/z6KkNXc2+HDLNKQ3eEY/I8VGW8n+DhZgPBVJSXX
         gykw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770949324; x=1771554124; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0yYhiqhUVpmoKH4cWdQr5AuyekJIQMbtNgTRaSmD9M=;
        b=L3BLj/XAVHAMtprc2pjZeyxbrMWDHEYpaQGNx0MDwywYny0eJstAXdV0LHlt5xnYaK
         ZngshE70/1JCVVD+MBhTElilCA4hlfc0P5Pekaad+dNLP20ku4SP93eBxkb8bG2+uESw
         2Y6iBb74L4GtSUX7AlDX3zGIDUv71sdJnugoMMis+GdcS1WQ2zj6oP1EhOcUNpBYMJ3A
         MC0GwALvTceOKacQuSMEQJ658NbCjDMpNWTzE+E6wiaKipTeTHj0FsDAvImURjksKXPS
         wr6n+Nt39bqbH9REj6viV/B6U0w093NdnTZSGttQQvuoC9DwLoc4G1M2sFdS09voPJku
         OWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770949324; x=1771554124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A0yYhiqhUVpmoKH4cWdQr5AuyekJIQMbtNgTRaSmD9M=;
        b=U/7jKs15qHfcx9Frb6DSNc/DbG0TrMup16bDDZCkvDy4ZeCAhJqKRYiuqfDhmzxxQq
         J/QY5qxNZXGMS2hChzLLdrbRtLmHIP1+EXlFU8Pv5ih6ma8fo7vFs0vP+UjvQrfXc2bs
         mP9hxWvigkF8vhbm5z8NWv+vay5wJCOQLPb7eoSpVL+cPkCKhDl6Smxa3PnOjPRZwigW
         XvIhTjt7xJ3SNBheWVfzNCxZiGefSgO7UlpHtX1pT+p0jRp4tGtm29Cm9bsUYMkOG5RI
         sxN/pbKRT/q4kCfP/+uZzdjAQqJ5EoUApv3J+ZOFjHLsZdCGQR61Bx7yiz8CJ93jR7fj
         FoxA==
X-Forwarded-Encrypted: i=1; AJvYcCU1Yoyc2vLnEbv2Nq0nLiCFfRbdATOjCh/clsl1997hI+b9wS0N3sPdK6YAPXTJWLHX4SytUF2TgQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5WaNRipCNT+wOYbAdGDX3Nf9n0lB8bMEZC+NPEvYYap5bDF2X
	zErcFCwMKbAiv73e+UpiafIWc+At1ZlH6p/dp7VT/zVxcaFOFaoNH6d5/Bo17Tbtsz5pCm1SIuw
	zKGsBkSdsWh314EszrLlTQI9FjQ6cwkU=
X-Gm-Gg: AZuq6aLHpUyxhKrCwSsRMNSFQgBhWswG+ClaVfLl/msnhxCfExgWYWdtyrKFzE5zi5l
	oGoksQIpJq88SO+jXq2bVMu29jXfwx+TXM0kB/6lQQc+Bp04ipIH7XccFb+N/rNQhKttQK8kVcR
	TW4lszuLxNocG9hF1jYkN+tSfjiRMA/A8tlRhDsYb2WubcpWib/oM16eoUSTwKQiWt8s1lp4FUk
	NpbCKBa/+mdBfGx9jVW03Zreo3DrIPY3lbUIdXDaLaNUio29ezTAsRr6ryHCOEAMZQYIDPSLCW5
	G4ncMtkPgFweIObZw44NutIRrz9cksniN+Dfm0++I42EYAaU1vs=
X-Received: by 2002:a17:907:e158:b0:b8f:ae35:cbdf with SMTP id
 a640c23a62f3a-b8fae35d9aemr26884966b.48.1770949323608; Thu, 12 Feb 2026
 18:22:03 -0800 (PST)
MIME-Version: 1.0
References: <bug-221055-27@https.bugzilla.kernel.org/> <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
 <aYt4RwxqH1W_zHez@KASONG-MC4> <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com>
 <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
In-Reply-To: <f743bc48-b576-471a-b679-28a792822cd7@gmx.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 13 Feb 2026 10:21:27 +0800
X-Gm-Features: AZwV_QjIdYYLeq0-W9Pd3UDvXrzxCZ0JUOqu-ddbGxVhDOCh8J5eNSV1mMQvUlc
Message-ID: <CAMgjq7C64AHL1e4HDJ22_SC7PNzU0Y3=quxDwQk0d4c04gYn3A@mail.gmail.com>
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm, swap: remove swap slot cache")
To: Carsten Grohmann <carstengrohmann@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: h3z1msgibtqeqdyu8ikompnkqufwim1k
X-Rspamd-Queue-Id: 5CCFE18000D
X-Rspam-User: 
X-HE-Tag: 1770949325-223844
X-HE-Meta: U2FsdGVkX1/i+WIP5c4gFw8cqRifRDtNy44cE0QqAQetS8iNk7cFWr7Wu5ptNcbb6u+Rbir74Gk9tqNghxcMNtAFJj6XuGDaOZZTJhs0fWJvk8qP4K2geb+ypbhTJps5bhQ59KeXTySScFRIxGH+ya5B2W+z+Jz6N7y78ijr0Oqf19w6H/UW1e87hHQJn8e6AHKZ5rR7aEoQ2fG832/eSsVFs3ibyW/4Vj59PbBO/KKfqb0ziyT+cCBYPF0XMIx0Qe4ozw+pIuQo5K71ALlDisSGP3PxOvjm8g0gc/Zl9e9ng9z0gH3FdNwerUrkDctpBM9PCZ/hn+SNfCwBzjqI/3OGl47MWJ+3l5hKP1ifItMTjsGgPosGJa/s7bnFj4CUhGQ0Fp/IYjp23zXv7TcJSDMRGy6vGza1UbjHwbMGBBt5kxdEBscjoKjhb/eELIua/j3Xycjkm1iYC6BdHC8qYxCshLpilpI2+LZadk6+znAuVg9ikK6SqrMxiWui8wc4KCpU9XtAAM/8q58B+cTU+1AAVX52O9XKCjC3Y/jPZ6//ag30IZRAeIjn+L2fvB87/r8oYarlFL6LFr8X4IH2SGwMBZNhSvnybUr16f8bWCKc1/RiQw6W1NRrM4cRwqv51WgQZsqAr7cZow2eXHCYx4Un6H0JdbXA3FOE6RAR8hv1wD0AWHxMrokw4QAZNRgcFjxKa7p7GIckUNyPl4A2mUh8LmZwTWUAEj6zosfhYBxOQ7IL+NWhneh8nZDv1z6CSaKVaUBRM37cpXdLf/A36YbAYNfMKhTjrpdpyCfOBEaUDsWWvJgVquyOdBOpNHEOHABn4WmjQZJUIBmOHxOc2MRoE1f37DHKy7ILL23ehl5KSHcrABXmljtYZIouZyPIufh+fkau17Umm1FaxATNTumzoFhq9Jl2G3d3iPo2VxoYWnsLu20rwNVEuLLNEk0+uMOyrJgRKl+nN6awNAu
 fP0YIa+j
 GH22ximpmVyXd4P0c6wvpiHYMqXqQ+VXJjOn9rCFsOH5j++0gMZ+BRapbx2fRaoyWNhTNv/VI4rqHFW6YeGOIXOUDKLPkU0FM3k6nq+3lsj3yXUIDRE515ZDrXjX2Wr42PB1cHrqyjiX/+YiU8jRtcLJfAAPtE0E9bC6ZhIuDrgiC90TUntcyPHQX6HqySKQsuvmMLRfTw04zDbMFCrLeRl+ijk0NsGduIczNv+yoF36457cECZjtoByHMMFDBXQRy85CEuIpAIVZCK1meuoN78qU58e40CbXHYqXe/SyriDoNlCqVKvDbJ8aHwzmKG0A6bPCreQtizpTxviWdHeue9Vn0kp7gEOJgzvpMtRZhQguJ8gVp09xogA4Jfc4wiGj5V+Hj5jicJu5Xf9DIHNGNrEoaouIrzV1szX6qWVfKvWZIPU5zpeIzoT2lZsqbSwdnjSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Carsten Grohmann <carstengrohmann@gmx.de> =E4=BA=8E 2026=E5=B9=B42=E6=9C=88=
13=E6=97=A5=E5=91=A8=E4=BA=94 04:37=E5=86=99=E9=81=93=EF=BC=9A
>
> 12.02.2026 20:01:48 Kairui Song <ryncsn@gmail.com>:
>
> > And can anyone help verify this fix? I'll also try some other SSD later
> > maybe that's only reproducible with SSD that have very poor 4K
> > performance.
> I'll try out your patch over the weekend.

Thanks a lot!

>
> > HDD should not be affected because the allocator has a special
> > way to do HDD allocation.
> I can connect an older hard drive to my PC and test this as well. Should
> I do that? If it's not necessary, then I can save myself the effort.

That's not necessary, let's just verify the issue you reported. I have
been running swap tests on HDD for a while and hibernate uses the same
allocation method, the performance is good so far, I can double check
that.

