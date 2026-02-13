Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDF2EEA84E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 17:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 920376B0005; Fri, 13 Feb 2026 12:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDBE6B0088; Fri, 13 Feb 2026 12:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC806B008A; Fri, 13 Feb 2026 12:16:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9B46B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 12:16:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 572961C520
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:16:29 +0000 (UTC)
X-FDA: 84440087298.17.BFC489A
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5BE4720003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 17:16:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aUG1fILM;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771002987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HplMA31qZfBpB6z3/+MpciPRY73JxSvXBCeyJWi+CxQ=;
	b=yxSdC36bCzpY+xrLtSnlsxVuYjURLZOv4HE7SfgEejTnPBs4xIHijJ55B759ET3amsvy+h
	nnmivI3hhP1WwPY44aBUbph4jb7Zaix6j6GrWY0Pr0v1NiNPGGDK4IOc13xWBu031NFeCc
	0S6/6thMAXvad0KCYTOX5ooVZm+o7kI=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aUG1fILM;
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771002987; a=rsa-sha256;
	cv=pass;
	b=PqUAM1xB/d0jcea8oHX+qfNIwDI9sozoRYNYZKYcWPwT3vP5f4YlcD/uOliUS4ZiNIsFdC
	VwL59OHEI7rsuKNl2WKo1TRIDG5sUEPLVzg1WrhopyLgQ+6ZhDON8zQ7lTHRY7pXuOfzCo
	Uhj3qqJESrGGvHuad5y/aHosj2YEIWg=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5069a785ed2so563491cf.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:16:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771002986; cv=none;
        d=google.com; s=arc-20240605;
        b=bVvy9kP5+1xpV8UhJMgjCULhiQA+Q9RPR46VMVn4+/VfSc2Pb1QItL/DBXDmRNrx+H
         FhU+0JsR5T6SCdtbuS+YDrw2XCL+tHS3ivSxsVMNC+Yn87IokARoyu62dDNxKgZC0oCt
         kWuLTmiTh+00kP1TYwWpUY1et56y8fGhGfEJKTTvxwO9TPmpSyoo0MTPgCgIlIHwfmfI
         JIYKLoGbGdnSqNynRKIjQI0P6dweiBZr7adgXqM4ukFyisaGgKwiPDM2G2ditQ2uNcDp
         9hw503hik2y8H+7e49uNnnOn2yFTZtP5baiSkjzJTXZf6WEROJvlJ36OA4JplDa9URdG
         qQ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HplMA31qZfBpB6z3/+MpciPRY73JxSvXBCeyJWi+CxQ=;
        fh=+koLsKAKd67kWKK7WVpClLsXDVMo3x2SXT2Aj/hWKM0=;
        b=GogzsBzkiXlNeN+DihTvlvhBNp891bpzR7exVbL8zT7JsFdwWhiAXjPDzUB4/ZNoxV
         gt70KJEmuYUE2X0D7FTaxmCHBja5YvsecL3AmR+xGqLYPoufwEPmfvB6JiIj48yb7f23
         QY5Fk6D4UjXIWwg38nCWMe7HDg9ZQDJXL9iI97AeRLGq5AruF1b6Z/0zas3d40rbkCwR
         V7MtsNag+A4WWq2wNTJDGh5EtNKKx6hsSLt/KkiWB+6DVsCVIxiI1yS/A1i15II8/f+s
         YgSAQ4VU/05kixRNx+bvMqu+sb3b8g2uzLZ/x8RpGjW8tCjMed29Ra6jI5+btQOtOwxK
         y97Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771002986; x=1771607786; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HplMA31qZfBpB6z3/+MpciPRY73JxSvXBCeyJWi+CxQ=;
        b=aUG1fILMqa0wu1u6WN4gy3o7tUCNojCOlfEFxiti1jjhWDS4OiPSY01sRs3RXBJ4iv
         TAlVEfVNtM1Ax41WDjcWx8A9+AyyiPTzEfZMUNYdfr0ogPwg+iHD26ZvP/qLExb7M2p8
         WHDteUH7Piq8xaYcOPD1oDeZO+MPTNG/CRh+dOjeMBagPMl87uk4/12ZZZkv9qB+6HmD
         t8LqRldpxnRxw5mZWY3KofgbulTPdIDRT/gxU6JK7GPEitvA1wtXzc5WCI91wTRZsbnw
         X/eabhlidE7Jvnj96PXpyHr9pYAIrogoAIdlI+21fNPgJmI25tTymuWkafLh9e8WFCt6
         27Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771002986; x=1771607786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HplMA31qZfBpB6z3/+MpciPRY73JxSvXBCeyJWi+CxQ=;
        b=Neac7CS1HqiZLKktpNiOyUB2fE+P47UqJ7yzskRw7Ulq/5PefrnDKsKokWPuF0yXFF
         8nxeJvwIZ6zB239ONUUWMMsNoFvGyy3d26MfF9OjwH9noUqFq7mghSILpCw/qfo4Ol6K
         6M98LZuk5+LiS3z0oDLWDo/OO+lpqINjGfAtjQhWTWw+GfRcN8lwmhO6LDqDg7DHgDEm
         206YWRF2h3wx5m7Z0KubKiIANekjWShd2B4QwZ5ROFDwd0qesmieT0dU5tqet4MFUMQv
         46WKx4dyP57/m5ejkUgwCsuzq/nekZScTAoaRzsjYjJHY4z2kduf4vsQPUB/HRIaXHoO
         2dRA==
X-Forwarded-Encrypted: i=1; AJvYcCXC2a4hwdrQ3Sk6KVEmUMmiaQ9gbw6FDOtLjC9872SywmLO+9R5xhyw4UzpsLxScEQllxcWDvzE1A==@kvack.org
X-Gm-Message-State: AOJu0YzHDjzg+GMZ95nNiidUarCyZ8Et30WBH3q3zcsA4M9+7iEfwLsz
	DxX3dDIAKNreSOZLyJxNXEHzs2lDsKi92i6aOYHuEcfyynby295OdHP5f6KKoqq5OR0XYhQe+DL
	jRhA/LBdlBT5QQBiFTfzc/tIPHN9EK17qY0SHTKTV
X-Gm-Gg: AZuq6aIErK6d+5NQT7zqF+c/3Yt7DuPLT5epWAy+2tn/YZBDJZJAPbS7SgU1aMZbSX9
	xem1zy/+xt127MN15uSesnKjCChPqEBulmqVldDG/NDJdEqN1lKmvE/aZv72cDejZptTTWHgJAh
	uQlqtvEdD9aemZPmE7RwlS3DjvmzRPy8vmupYD5ckiBTX9e89fdJ1bBxiNL7PJ/XwYR0QlXo/15
	zcosVEUewVqskjxYrK18u1ux8Jpe7IPRa+EXXhh0CgjsnCWcDXGoF147ExVA3RK1k3tnHJ/o3hO
	xDGYvf6GACzkPcfdtSv+0TQg83jEM7gqYdc=
X-Received: by 2002:ac8:7f88:0:b0:506:a3c8:d44d with SMTP id
 d75a77b69052e-506a84d6966mr8954301cf.9.1771002985737; Fri, 13 Feb 2026
 09:16:25 -0800 (PST)
MIME-Version: 1.0
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org> <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
In-Reply-To: <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 13 Feb 2026 17:16:14 +0000
X-Gm-Features: AZwV_QhbHh33PpamBb4RLF5fCzFN3MBz1GIFZu4QV5yrw682piRgoSYsRH-hgfg
Message-ID: <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Pedro Falcato <pfalcato@suse.de>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Luke Yang <luyang@redhat.com>, dev.jain@arm.com, 
	jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5BE4720003
X-Stat-Signature: hg8p1k97w9hbokte8ys36tpqgwqy8pjq
X-Rspam-User: 
X-HE-Tag: 1771002987-951308
X-HE-Meta: U2FsdGVkX1+KcMZb5wzORPS6a4YI9HDePtq+DJwi11LArOpvv5JB8yaXn9v4DYBc0WOL/eNPl2Tuf+EX5pdDB3ObO2RYksOTm1HWM+WSrPTGQcRCtn8vOc9XKYsZXbEuBlWH++yj7Jzs+tmeEf2FNB89aS96PtbxoGXMY0ton6GpoY69eZjWZpW7+B66CBjcNGd3FD+cMBLWffZ3x2umRs4FNTxZlmofFFycxD0VpzmfjQDdRE66v3avktInMlEMLRN1mWiwxviurZS+ygN6o9+YVKsX+5y/wt077cAS+92g2JN2AOyH0gVecnQeBJh35tnpcN7NwzLCeAmLrJS1wNcFzQkyu9aRvh0H5WdM0ZRbfKdKDdPwhJeyeqGXvgjojunLP+FDNFKH2gxDmjo7X0SFWhQKqzBqxO1wu7oCgzIPh/MuCASA2tiRJbA07Nq+fFhthmm2LG3ko0NKJkfVWNCkUgZqRcTcg8VE7c6XFQlXj5tJEuQfDPwoQNB6ok1IQrC6yOKTB//iAWNyR4iT8oN0G35TtS33+eYugTXPnhpunj8KvnMS4n5AxCKLMileq72i/yyGBrXTNX1B2Pjrm0/5eKIkcHWwW8cD7eNKNl16bAK8tmVBpW46lpkR6QcedIZDrTMnK+qVUHJmCUtwI0zslWvV+poSALGrLBdHCQcP2qvmY6e1K9lhkoRS1+4T9uRJEjiMZHvMIsbSJtjt/8QoYn4WMhdJ7+vPMjzOEVOB6EijMcqLFDo1y6xBWoCb38oz96JKhdfqX6KxXMtTtzSMmGk23MExokqjM/PH0MLpLyDGcIkiVMUSdJoxtXmQ4mAb7QToN5hkc+jfINjTWBLeHTkjtxuT+lKVfGJviF4X4NEnqCNOKr+op3gQMmeqq9+syBiBskrkq4a3kyaIrzLPJ+szrFjFfkM4UlGzFF1Gw2eZg2subBa5MblQ1uPPxu+qXO0qOkzztFogSCr
 ncBwjIPE
 VUEg3/14rPguno+pVYeO5/XzkUCz5FpkbLbDu+fMbH26lg1K7OI5J4Qqztdy/AOjX7MQO/YG7hGMkGg5Vca71Du+L2L+5hSjDwolqEa2dg2DQxuNYnCTkqGW+1+mFdKhRp39InNaapU6Gx/OVPO2TmHEQ1eua9N6TbqvLYUj5Ju+XKaGongR1ToamJ8kCwWSwzFCeJoLztRA09vvFLMdXdFA3lvEj+BNaKhxP6DA6kjrAs28=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 4:24=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
> > On 2/13/26 16:08, Luke Yang wrote:
> > > Hello,
> >
> > Hi!
> >
> > >
> > > we have bisected a significant mprotect() performance regression in
> > > 6.17-rc1 to:
> > >
> > > cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
> > >
> > > The regression becomes clearly visible starting around 400 KiB region
> > > sizes and above. It is also still present in the latest 6.19 kernel.
> > >
> >
> > Micro-benchmark results are nice. But what is the real word impact? IOW=
, why
> > should we care?
>
> Well, mprotect is widely used in thread spawning, code JITting,
> and even process startup. And we don't want to pay for a feature we can't
> even use (on x86).

I agree. When I straced Android's zygote a while ago, mprotect() came
up #30 in the list of most frequently used syscalls and one of the
most used mm-related syscalls due to its use during process creation.
However, I don't know how often it's used on VMAs of size >=3D400KiB.

>
> In any case, I think I see the problem. Namely, that we now need to call
> vm_normal_folio() for every single PTE (this seems similar to the mremap
> problem caught in 0b5be138ce00f421bd7cc5a226061bd62c4ab850). I'll try to
> draft up a patch over the weekend if I can.
>
> --
> Pedro

