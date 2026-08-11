Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B52C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D636B007B; Tue, 11 Aug 2026 01:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40406B008A; Tue, 11 Aug 2026 01:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B226B0093; Tue, 11 Aug 2026 01:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A22576B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:59:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0990F1A034E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:59:27 +0000 (UTC)
X-FDA: 85087936374.04.3A5A368
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 10298C0007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:59:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XxuTefxy;
	spf=pass (imf28.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786427965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1U4C7aa6hlRlxc8VgQ9o9mfmkNC5txByo1x4mRrukHU=;
	b=VpwYytAO/T8k03g53hRlxjqw2DHbS+LbSK/C0QQV2xrhLMl/C8uJsiIJK4avnsScP4fBzU
	8QEC3WqX4gYhRSBQizAWr4fBWsR9EaED10xWRuNcoq4PQ88G373CaayDKr6P1G8m2L4zk8
	kH8qh7F5+X6Szt02Fst/ep0/gxrzKUU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786427965;
	b=iaUO/hJbYZacvRPUugEwv2pIqu0HTkUiNvcLw19R8DSZYxj4CPWwufjT3lQEQezS6aZw3l
	jHs/UfGLTtSzYEJ48o9UrLqhl99qZX6USdsP+uWAtDeOBEVHJU4v2BMqF0D38dTIRYtg46
	gMGsRJ26xt9zTjKNRWx9XsU3wOH2SHw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XxuTefxy;
	spf=pass (imf28.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-664ae043b7fso267650d50.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786427964; cv=none;
        d=google.com; s=arc-20260327;
        b=Ii7+25YToRLprYUI90HvJYFNts6za4LLGoWbaMiEyECLQmPAydTJVBoZZbGI/F7C3h
         Gix9r+QdrSGTlP1gDs2dPxBFhxY+jzAbqJkcJDg3qK2jIR394I87ccP+gVQCb2hlzCho
         oOQueDSR+EUwerWVLUz3L2hrLaCYVv/MIE0AY//ZADdkcr7XzbvYOxE3XBVfqcfb0B5b
         zhGyksy6iGonwR7aAnk7YGGyZ0kpykLL/0SUHG582STdeu3sY8cKNKcrLD3F8Sk+JCjI
         AdSvOZrNcnnkJeBzZVejN7DKnmfNvYisK5TIKtlxrW1fXg85ngZ1qVfpI1CSlZ90N8CP
         IL6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1U4C7aa6hlRlxc8VgQ9o9mfmkNC5txByo1x4mRrukHU=;
        fh=hxiaw11nXsv9XPrFkFAu8VJe/lX2MMlyopCTk2A4eyw=;
        b=SPeSLqkZbqAYXDYw80x9ShkTmQllkREOBlxjUlwL4p66wF+iCmFdk1IuxNd7f7UMRw
         Eopd/TVpiJiQQNr2Bsikgr4qeyKJzW9Omed2Sypu40fGOJ8V42zkSUaQIwpUP9Y+ZjC+
         JoLofTNxe9ruYmE9qFUY67lBTTaRb59nE1/nb5NFu/cjKGmNgvHNB8m7c+hQMuNBy40s
         QzkZk73dbjTmjpTEZ6ilfSyUzyNY88LrOp1pQpoIzhDCA/mS3qlMQl62wwB9SvHr/ZLB
         2yGmqKXwcPer5C6mT/tbg6NKmHXFKv6weeknh0WCV5k6kfKNuQCuW4B5UIaBMAtke3Ie
         BRjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786427964; x=1787032764; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1U4C7aa6hlRlxc8VgQ9o9mfmkNC5txByo1x4mRrukHU=;
        b=XxuTefxyduwHaIXOKnZbGMcbPiXIWLgpyrjLGFoN4SsAsUoLeCgN1Z595Xekd7q7cd
         ihJ7/8JGL63AQCYzNvrWUXvaoqDziFr8CAfhQWpI+DSt82pChxPxiMvup3xNH1HXRz9N
         YZNJS1hTMMsZeMAZ+3gMddYuwiLoF602OnA/GHl7NZ2wen0807KeNXUDU7t98FDWZrPI
         2JctOvAw93MnIa/aUN9BMZE3pelRPGMEQvYmfs4wMPcWePTDcvUqbRjR52hHnYXNpGx1
         3NIFEQYNE8jvuJHpa1FuHKZJIfB2P8esicg8P0JeXT7Mm0wxYSs8GU7FfI9lF+1yv4pM
         CQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786427964; x=1787032764;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1U4C7aa6hlRlxc8VgQ9o9mfmkNC5txByo1x4mRrukHU=;
        b=bP1BpZSqOjJyC2/iP0S3dR4s3TUSMNyaePGgyX6TUu627QoTFZ3v4AlSzew1L2/BRw
         OYAalEAplQIl4IHg993pwJUsaBCRHmljacIkyJf0PV/rLNQKpLsvKyhjt3muL2FuITl+
         eaUuVgz18buTl43iDZQ1njTHyX3YdkYtJ7JCD/ZPSEV9Z3DYyXHEDWtDblRpPXBBRN6H
         4yEAbT2ZGE3cRofvrsZkSnV9uhzWAUOFuWOFbXY6KfDGEL23ORewM6XVkHYYev25wJ+q
         8GxL9d2JmJlHglb/ZOGmgL3H4k3YIO3V5IOMV/bOgkzJo6/6cqkCjd1faZUK/Xq6vY0B
         YgFQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpqm6rHw3FxI5Oj33DaFLWUfUPi97jv+F4sgRB/0dRqcCtkTBdhou3XbJ9d9TCaQvYaiYOWjKjQTQ==@kvack.org
X-Gm-Message-State: AOJu0YyaYgdbPjYPd2CTHXdAuV1h+nT7rXILtpI1c4uKI2YIQy8csIXX
	ZolkS4ugiAukf1SqXMpG3LZoImgh+t1ekrvBvsRTe70MAsIHTE7hq0L6HEqiggHcyBswwvbfTWb
	n58wMOpF71P66PbauUltWbtdvK4J78nE=
X-Gm-Gg: AR+sD106CNG13Vgh7JdAcmrfI1fWOAfCsHNQfGBT+L2uk2reiHsaYnGujbmGVIWmmvi
	H4l/KpYl5/8yyL3yJTsH4z+MbjbBqMZ6hLBDD9cSDDufrLDCIbbtj8Mmjyi++Z7ppCUA7z+8SFG
	eyxBJRIcJ5gWjE/MkiCWqbonJwNWMzrUPLYb65Hz0e/2ydG4yFloUZIuKbhwBgE8GYbkMmEwI1D
	3YYJOu9EbMV699a5s4/cdta7oMeQipsegtzeY6iPQZA7qO3QJeMYWCPGq0LIQxpzfgfcsYF54dm
	eVhLiAN3QOSVS0QwxeYd/fGgqqLiNQBsWqSSE7RRA49k4swiHblcxDB+QaDsdWxnae+hh0UxXFS
	RSIUxdMavV+cUHXJ/ugy9Jn/ynADlsCURxlk5puVK+l4mKVjCASTX7zXsnHk=
X-Received: by 2002:a05:690c:e3cb:b0:7ba:f0d0:5e9b with SMTP id
 00721157ae682-82f2a23c205mr3831507b3.2.1786427964217; Mon, 10 Aug 2026
 22:59:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260806100543.138902-3-giorgitchankvetadze1997@gmail.com> <2vxz5x1h6eqs.fsf@kernel.org>
In-Reply-To: <2vxz5x1h6eqs.fsf@kernel.org>
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Date: Tue, 11 Aug 2026 09:59:13 +0400
X-Gm-Features: AUfX_mzCRqYoBKGa8DDL-lqpnRc6U3cbNHCT5o2avTyr_B3psZ5m3uL7vd5nGsI
Message-ID: <CAE7dp2r4ky6mcJeBEoE7ELW58Zvtu57+13dLYNr72tZ-UhsYBg@mail.gmail.com>
Subject: Re: [PATCH] mm/memfd_luo: use real folio index in retrieve error logs
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"open list:LIVE UPDATE" <kexec@lists.infradead.org>, 
	"open list:LIVE UPDATE" <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1fxqjbcs1og9fpuosgojwkcgsofchbaz
X-Rspamd-Queue-Id: 10298C0007
X-HE-Tag: 1786427964-827607
X-HE-Meta: U2FsdGVkX18KmX/GmXMpRS3/EA2/0LcBt4YTRRg8zt+kLFfWpNpUpZwVBnHZxi6IHgvYjlsgw1JdDe7jylrzJRKemw4otY3IYl2HYNZu1cqhAFvPEPIw/lWfzdKPHaNFLxcwWGOmxxk7fgbVMk6UVHZuXqY8P2ds3f806SuHV4NytZmA6i1WsjLp5z1KmyCPNyVkyvwyVxmE1WTc9j0ORyuVAflfPeZ0wg3Rg4qdNukuYO8AMMeGS3VDbr4ucX5G1ofkhD0EcZd5Hk7NolWR7KMXy79eNTvXkhATdreQ+yhqRHmKn5zaV66jzZlF5L4fT2/MHcb9pRvwgZtm0uOLxho8lG7MM7myRs3Tynbf1FvFFXeDEzUaMlFFjiQgPq/8y0Y+klWr1emyzbBq48XPcjuu9HZso3s0xdgxga/MC/GhGrvPMFIb+UItDd8ENekShhdbe5vrwqZVvld4u9/2qSDom7g3mTSaADLSiBDa/WLjvg0TCGKTTiCaHDild62h6e/S9BQTbfagtckSbA6B/3lj5uS8WxmjvibqBySPeRIP09q/iTUH62e9EVtTx5WVZ/wZX64UOIwrgNm6HSSTu4av6JBFsyv8xeBfAH8gcpzc0oJDJBaR5XDrvE3CbTjX//YX08EdnM1f+jrmF7D+jg2kGbqIrQNNbjXYxlQyPwTDFNCj4p3mMHzitFu4IKNRL3Dk0TNOVs0fJix4/VUvunxwerV8OahbYaoSNzECsgISd7h7tPHWv4ebD51qiOgH8rgmgKXjjDrjH2lQLTVHDbLvrgAeDBKkBWSb0RaEq39GNQD15UqzxWtZiIIUqXelzB4qSYMh8iOGWzIq5xjyhbZIyVfzpbJGRyqHZ63u2Qt2hel/QdN+Pcg97vMXo2H+0vZto6yidD4NL9AUMzc6L8KkRrIbwFl1w1/j8j9S23X5A3O8Uij4kkqfQOP9WoZcPmg7V6RO9lIjpTAtkSu
 zmKmsRyf
 Zvt2Rcan/JrgT9OXSZsoF5/yPWNQ21e1K8ZcUpOBJqxuMOBWmDf2BXN5BSnfmT+Q5xsLuyZZFC/5dKDTpDzypHwwvNZOpTEf9sJGpEQcfiYJC4tK7lskJlE39i0I4D7FOAydFXcaJCQ7FSVe6QvCX0PfsP3XlZqzy/otJI9XnK7XDe1fMCtzSn2hkTDiZoyYLQ2B4NCgw2TriCE9nKsZDeRqbEW7N7o9Z3doYAzTAZnAJ7eyZGAdaDvETlR8yhrNZnj7BQHWnhj/HQV/zc1d8IhWRG0vixG+3blalRlKgd3+f5Zp2g4vX02u+BtpIUwFgU0YflLW3HBOxZkf4lkECoiuO+NUF8Dig6x02wMXjocKZV0AaKyuaA0Wblu81Sa97zi3wEttETC73Ke2nyhE6bb0za31prXgsZudMkqVamBlTGuljmV9me7XB4VfG9rKaAMBGbWCPDjtq4AkW4AWB0z5/KOzft//NPJUOEkrhyKmQljw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 9:56=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
>
> Why the cast here? u64 is always printed by %llu. See
> Documentation/core-api/printk-formats.rst.
>

Wow, the cast really is unnecessary. Thanks, I'll drop it.

