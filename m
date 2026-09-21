Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822CFC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:15:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADB46B00B1; Mon, 21 Sep 2026 06:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685796B00D1; Mon, 21 Sep 2026 06:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574276B00E5; Mon, 21 Sep 2026 06:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D92D6B00B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:15:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 481F71A00E8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:15:10 +0000 (UTC)
X-FDA: 85237361580.29.121B9EF
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 51D9914000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:15:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUYcGutW;
	spf=pass (imf23.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789985708;
	b=A/bhziFgzlQpfquj8ENQwcVSAST9P3pLk7I1EX/kIQbDazTiV6iZeDFfegPO1QBG+LDlyk
	8R4NKHm1NCjHexfUkrLGUk3xyRftggXJwFbbXQ62DTKdPxPUa3W27fdk14wD0B1Slw8N3D
	3M4ym7Hpj7XS723ow3PmTTXzRRe1Ckg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LUYcGutW;
	spf=pass (imf23.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789985708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXWnRzHT+g9cmiFs8MOXnDEGP2sDTVQKaPvmvaWRkxw=;
	b=xoDjzkutvNcx+UYyVcV7641ipRqvcLvwhGxUu83Ph+gtKmg2sk4v72hCYJC/Cbsq9l1WpI
	XWyQNE7wHA50E1Pw3SuD1KnoAzT1zcNX6pPXep3lir38pEKpSrg5AxErOXxRFOIt8eBElD
	x46aHvH6b2pA5356q/bDmHcdG/TaRjw=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1eso433448766b.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:15:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789985707; cv=none;
        d=google.com; s=arc-20260327;
        b=VvRvYWrL+JWt58ZmqNmDOKGgR0wT5dlDxCSjItRvAyhiL6m1NakouZTfRMdf+i/HZf
         9zZDBqsGQNJ9JlVws3q9g4zIcPWHhkV5n5oeXHDjdOS/0E7rGfgkdDPYQuZLmDuICZsc
         7Ei2G9xouhn29iokOoHObV+kIir84uF/yLFxnfxCF5DTZMm4U8r5H6sPfhJ9Ns982QAZ
         zWc/EwOkqrTvZYUJjNg2vCgCriyf/cWifiInpwxQU9ls/GIbZnjPlq9HIvpxRyMzyR+s
         ICqxsPS51m2dF9s8Jg5q0kVoTkN0ugNZqyDaBdd66mK/kUpPSIdwWjZiKvwOIykA5VNJ
         DmaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cXWnRzHT+g9cmiFs8MOXnDEGP2sDTVQKaPvmvaWRkxw=;
        fh=G8Uozgs6G1Z64kvYRgZ0xJHTxBX89wQaVdjLqORaDeA=;
        b=pl1lnWwidpjFnj19wq4V19bpQYvAvhcYBJlkGdQyXHtLyvKX2cLZOXagOZMmAIGpLS
         33KsaWPMnXQ3cXKQ3+nQkBX0GKq6lAKdy8kZmLyU5Fg01m7oP0orTb9l1GtPU4E7fC5V
         j+90nvU0tZTzbmzmsH3QH0/udVb95wTM5oajjt7Y+duN72mBrmKSWlI8KGwYH5diRk7q
         ASlIeQ80KL85wzwgBdgZg1huHfSHPZPg1NnweTBmMvuua3NnhpUnGA2kRKyyl0nXfgVk
         GWoXo8Nb47hRKOPIXx76wR4knL3A/lg3XBSBysuJb/hou9arta87Xoqh9ZyExoaNcenO
         uLvA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789985707; x=1790590507; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cXWnRzHT+g9cmiFs8MOXnDEGP2sDTVQKaPvmvaWRkxw=;
        b=LUYcGutWLf4mXh6xXCUwvSSwQCmmI+WgkVmm5gjOmDwONEfdNYGRqTevudhgkYikQL
         +6hbCQECcWgt7Wxpz2Lf+S0PDfw1iw5nQeiluSOlKyaFz7uPg915MAQCRMc6xVrA7F8O
         6gC9aa7o+Lv+RtPsE1zM1iGhWXcL/ddeovLOY33t4Nc0uRhmhgkviODsX9wKzm4a349p
         afKmRm7ukrCHTHvVTYwWCx0z24EilOJ4hAj4SfbNO5HU5q978DonW8lNVb4XisDN2ihN
         PVSVXaqWfOgJOuTjUiZb74nsssXKhCvCOyxf4POZyi9j6kZIEndbuc9aQOsiN2v26R+R
         yTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789985707; x=1790590507;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cXWnRzHT+g9cmiFs8MOXnDEGP2sDTVQKaPvmvaWRkxw=;
        b=CKDqocxsjoejumM78y9oI5NSS/nef22leXVDZn+ocwmiE3USb4P0RmfHl6qdjmfqeI
         KlL1SNvmPCX0abTt4VPZSJrvf6sBT52WKlF9sC3qTxtj4KQHmWHdSu9jjo3LFNpPH0Ql
         suyHs0STlQ+TGHIV33WtCG8e9m1jkrFTGafyTXYdFGyxyfmlt0zZEA77jshygD68zab9
         lZiWF6UqTNfvaaCMO7+EngtE1ZncadkOvBmDUSIBzsw1TYIFizPvR0WDKlxoMXYOnkRU
         jouIeLCir68QqHtJlqsoihLDhcOMMi6zKeua4Wv+v9C52Lr5t+qGBeSeP/JKsV/lg1eg
         XH0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxyf7sBnQbqktFvQiRSEIVQxpZ543bJLPDJ6PhxSkvHOSQ94FWlIw4b+tPeDmOGEQ1X6PddYDmpdA==@kvack.org
X-Gm-Message-State: AFuF++lSpWjiaX6dVRLp+sn8me6CBvmHOZQNL14tU7ZufMEEM8VHoQY5
	JA71FBhXafSYy/nJymNns8+8YQ5ptz8Xefxt4o8dQraqUF4JZ+dZozdJLWiU5WtlKfazSEdKm8v
	G0zxvfh/15PXHIy/1D32m0W0cIPo9lw==
X-Gm-Gg: AYBFou0JzYlG0NBaK/hXSRl8H8Q5pIgWfrqXkxBWoTWM6GYjJykiA2QLIPN4tTr01FW
	mSKsavlTtfJwRb/H9jD1UQnorHUEsIj2+mboQTEclz7koBgfQYYRA91f8ZQDEq53PI+2U78yfB5
	2ZTO446+Z04/NzybPa65Flyz/DsV9pJAcrm4vDDxHcihD7qXGcYCsV5MXBndStBL//J51FgSgpD
	CDIOjg51g9oZMM6mQVN2/x/qOSCsLEFs6hZZl4d5La6bGd/Wqoe6KFTzgXu2XzmCN/oRN0X3jDH
	suid/bnyeHfT7MuZ/Xi1zZriw25jvn6kH8/InrArjKgSlEKVqtFh8hm/7AKZE/SSP2tvjIziz6r
	GtXRnHyS0nVa155S8Q0WHm7/WsWnU2Wg9FQQQWxs7ebcqC3XHR1Vku2gsqPLyZ81q9A==
X-Received: by 2002:a17:907:6d27:b0:c25:4f7c:8ec5 with SMTP id
 a640c23a62f3a-c2a158032f4mr915252566b.23.1789985706566; Mon, 21 Sep 2026
 03:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <3c1598eaff225a155cdec5e92d5c97fbfc6c00fd.1789724312.git.med08elkadiri@gmail.com>
 <arDhf-LH0ZAxsd5V@tiehlicka>
In-Reply-To: <arDhf-LH0ZAxsd5V@tiehlicka>
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
Date: Mon, 21 Sep 2026 10:14:55 +0000
X-Gm-Features: AcwNN1VMPCErRyQzCgZI9ldC_hs8iL3BoMfZTPkjzOYctfo1Ss6NPr8aBlYsdfs
Message-ID: <CAAMeuQRQz7UhoxiOdcRpZ9MNVtrX6z8XcXYijKAvw1yB4AgPhg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/page_alloc: enforce upper bound on min_free_kbytes
 sysctl write
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com, sj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51D9914000D
X-Stat-Signature: b7n456cac9r98ieuja9p8e9uehupxh6x
X-HE-Tag: 1789985708-937282
X-HE-Meta: U2FsdGVkX19eu7W7Xh/weVa8OKlHGJFPvH/eUfY4dQLhq8uKCCmk/LrRD6GDLA6YZKHSPystH7maWiFp5yUCBLgOLGhl1/Vcx6nn9jZRiMDZXwabtgDh9ih8CrzQbDRaWum6pSv0X40pG3wvOtj4DFndRyf6xaxPpv8FTOlFN3hSekjCZK8oxlpAVykfbTqE1pUC/zUXAXGArSoN+iX4MSLhHlyjnC2ZZGgtpLAIk/MeB93aac/zNOc5AQZ6X6rsYRYn+MLaEFZ9iyTABnsW+LFnRLDhsBDnUJdi5hNkpyOJ0/P0ocMFOclL2FdoXUHxWpfZVV36GcVxDGa5gf2nWavL/0uayA6J51piNvT+l1LBJqNGMLYqW+3u+XENfrmEZACh22XIUWMecODhfH5Kee39BKkKooQIXHHJGuq476iRQsuUzHhoySKNBbNhnyo+0oMSNIFXY4iEo3sKQNJBZRThLkWjgJhkT4o/nF6uQhdlRlXrWlePVD/zwZ2ao8/SIfArekCgQdLXlyW6UOCoNHDpvohuTWJGMTixspwxYnvQYsHE1+D9O8VfsI0Ip12rrypH8aXWw4lnlje+Irmb8qKZAnlezCmIkxVnLbWcYgyHilmaFplNBXllro8JeURKshiDoozQSaBNFaOkIcNnZKqzhtUsycaZV1UKRhjKEVKK1mG5i4Q6blVsG0PKqiLnDp+dNShb0UnyRP5tGhPzl/gDMlaZ1ZhorNnfwThVc/5jp//2oKrXONw+RG6wbJ1k6dgus57ypS6cLM/zGkbQtg8yVNPSOEzMow7P4x0XQSlmXn/AtQbgcIwDSiD7rb1Xk2prqgTiD/K+/ZH2XUqW6HfKz1ABct8a7VX2dWPBHGHjHF43dz51gRj5o/oB0hIshFR2mpBcxjazf1exD4UIKk1bd7ecAx36Um7/C7RvUPZ7HOlyigmJmquPUtO18r46jIK3tXtgCDb1B0F/XA7
 A3l2F/AK
 kWQto3/9e9CmYbC47HXdfhbgWTWpW/ob02ZmIgM8BF2D70IxbR30hRx0pEfco72wbgOzMEDjoeL7G7QXtJpTZP3bDQShWLoPI8AwqBvyHN30cQcMxwX7NtBvYJUeS868mb3ASBXfrveguMLHpZZORJOzAJU9QoGYb1SLduaGbll2Fnl9ZFwklCPmrJnZh4I5MrjvCr+C/6YEN15Qn4maAVlljbJmjghwdegzk1eDiwCaksOjw/07uJ/Dn7RuyIRnFHahcYY9O+TP1VMIzzKkSSnzsbU0MFGOt6FFWfwgnIoUl1LJr9wlY3ntC5156Ytv18f6bt1og5H7xKddDb99QUgYHGcdr/V+ZdXD293ZBnDYZ3ljvbc/OUc4fSldXL7YMvl9jJ/TjCRbQREZ3kM2mEMZESJG8OnlJlbzSgBTym1BpSZ3jC7X5w1PsyLfRZthzzAlRdECCiOGTqJrGWqAsFbHKpYNF+dfhgUwdbdtR5q77WRcDma+2Fl57Y0tPQIokDRN3i3GI1EqmuF212NXteXZlFUraJwXaIS/f1fAUuAzuvlJh7fVCLRP7twlsSmViuSRuewHrzpzoJZTRI9jgyB0hL503pBKSQG73H+rZ0hao03U5OIinoyg9lNLudTfzZdwcWlq2DXicuc8F0RUNr40cEZd7bpOm0+ljB3c9ypcCui6RRkrlbFhtUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 7:49=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
> This is an admin only interface and we assume whoever has access can
> realize consequences of the set value. Auto-tuning really cannot make
> any judgment call so it needs a cap. The same doens't hold for the
> admin.
[...]
> There is nothing really to fix.

Thanks for the explanation. This is a useful lesson for future syzbot
reports that need root. I'll drop this patch.

Thanks,
Mohammed

