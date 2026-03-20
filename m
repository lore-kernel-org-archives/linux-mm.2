Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 823DD108B91E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B381A6B0005; Fri, 20 Mar 2026 08:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE81B6B0088; Fri, 20 Mar 2026 08:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7906B0089; Fri, 20 Mar 2026 08:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE166B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:53:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 480E7B6880
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:53:55 +0000 (UTC)
X-FDA: 84566433630.16.B25A1C4
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E7741C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:53:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Y/HlYxmd";
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774011233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxb40RyXjBOvkVq2MrBV1Eo8DmTziCzGNtpBWcwYXIc=;
	b=MmGH2f+JzEjmNTKrCNndvLbxwIZ4JvJ3fOrBuAMGKRJmkmjJgx5/7xZ6BUxB5YZw4VnXYE
	FDvKkPeWLZ3pLHoW8qUPE3cwlHaJZT5cuGlCKez4KRwWqG28kTA176OONZwrr9iBmUxunO
	xPv7uu6/TBhKR5zlNIvgqbYlRDAmGxU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Y/HlYxmd";
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774011233; a=rsa-sha256;
	cv=pass;
	b=DBEKNmEEfd0grbqj2R0W5imqB3PjRKtNzlKHN+3JDo4UdxlImbtvPOovLMpBPKW/cPUYqR
	rV/YxFlrnilacHlss189YatDxX7AiOQNpPgNmqylrmEKOOdQWGLvLK0GHyuCqeekMzjEQE
	YO/VWEWbCCJcR7CH7pzsEKfF3P4j3/c=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6611d20c026so774553a12.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:53:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774011231; cv=none;
        d=google.com; s=arc-20240605;
        b=I+FBskjUjtkHhGBBBzKpjWG1CYHGKXMJgW+1t+62q4D7/rbVsT//WUY0rcBWLvq14x
         Qj3PmgW7met/rXLnk0Lq4rukoHw6o/fc2I6TjA5IlLequ2GGhahztwtAW0Xka55WktEg
         dGLkKYziBhzHQ2BVDfP2osrU53EyRi83VWn2aImAYRkpPqLiuRnOt0JmkFtkON+dso4E
         rlr6L89drsW8msQYSMoIKOSYEOXrgrRJZB4RJjXKSBu5UNJciZKE4NRS30P198+XU+aa
         olGi3LKeQ7gS3OGo103kk4vkoEJTFT0+n+TwVooOsoGgBBq5qde/jXnzV7z5occS+A3S
         jqYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sxb40RyXjBOvkVq2MrBV1Eo8DmTziCzGNtpBWcwYXIc=;
        fh=hbhWuJPLKNcC9muOgM7Rf1/Pq5wpTYOqPp9euPh1Sis=;
        b=DO9Rw6+2REQYqreqbve0Fa75gJ1FPMHUTAQBTzwtJuJhkNnt/itHXDqpo5Mjpqv37o
         UbhiqjynlhA2KryDhO82cNFskPp4PMIjos9ckU6+PE6UBjG4ZJRfOAz2s5AKM6m4UCor
         hWh+Y9BSGRChgq+OgLqdFz65RB0PRpL+V3Dwuz1GvZu88PJV65VipqxtUtMwsR/sRMSi
         BcjoGL5fuH+JpylkJRdr3MV0A16fD0m3+OjChkQ4TtCyB7DzL+nND1Il/J71oS6lmsZ0
         FoREAo7sEWfJUptfJhdzALTtFkrKhEJKrMFoulP/TnS0R6ED3F6FOVANOA3J9niuEv6x
         Xz0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774011231; x=1774616031; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxb40RyXjBOvkVq2MrBV1Eo8DmTziCzGNtpBWcwYXIc=;
        b=Y/HlYxmdHC4UfcpsAvr08T8bEXxvIg2U6G6MepMmgPQcZt8NRcF6LwSPwZd2iHKREG
         tlh5JMpqouZJKf+v87MAJQUDU72Z5e4jFm8RK0bNk4El6nxPkbYhrGkfECWwus4jXyRL
         39qqf0QWTrNmAr+O/rU6sqPuZPauUPpSmD839/bzUDfQoUvz2ReyxwC36d7ifhRCsVGp
         I4ZlgSjmfngrn4rgztKRO4bGQ8Ht7zKCGW+gVvPernx7/yX0UVuSu++AqpoROuFQyTLQ
         2lxT0IS410VV416PNxBpTWyNzgpL8RF5JpjjRwAt7JW4Huml+TflDNdpuFy0oEBw/fct
         ++AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774011231; x=1774616031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sxb40RyXjBOvkVq2MrBV1Eo8DmTziCzGNtpBWcwYXIc=;
        b=r/tN/qOaweGxhw7UoVoCjQi7JXKseGwT6hCS0GYyebYe2Wr4GY1bbQdbaxKdvc5za8
         inGPJtrd+puffczh0kthnIhBn+n8VbNTNum32FTeLTUs6gHGVd89chRce1geEH802e7J
         NyCoaSmd0Ez1+9rXxZJAm/f28yMoWhopdXtC7Qfa2b1LyZHh6mPkyvsib9+T/Dji3pxJ
         3EgS8TB4o9XrUFWbnK2DqciPap+8uErO2+AoTIVL3Rs1UAS7H3hUsXObpQ1elYqt8EzF
         /wwlrbNqeolbpzk0ysBKXYQBnHpfjbepUld6Uig3Tlj9m1FMNt/Qk02b3K827HnIfmjU
         0tLw==
X-Forwarded-Encrypted: i=1; AJvYcCX+/wNZWihp1xRWx2C1fT03p8UnAt6lhYZSwfRGFc9XS34Hwxgih+RyA+iB67pq2T2G/BWUE/LMsA==@kvack.org
X-Gm-Message-State: AOJu0Yy8mK0B0aM639YpOZV8bx1L0v4fn+uubXU/r8FF5NyhOr5sRrO2
	Sg1R2Bozi1/OPo7D55l8CfUIWz4NRiYI6mMKAgSF4mIK/+J2IUdotKKx7Xeq9ZIZZII2TIyVmso
	2jT0mOXjna64+nvomzhEIsi+toDq+Roo1ITUfIsKXdw==
X-Gm-Gg: ATEYQzzBuK9lMoiCX4JRlOrWNf4v1h+HLYALOjt6TKE6AnJ03GpoJSL7j8et0wgpbt0
	RFq5tyIJZX98NAiPibfTxaBzP8y8u0xIg4U4vzngYx3w5n8gqCzuSPJFWnvhRB3gYtpYWl/tRGv
	sVvp6egxg/L1wGyFP7Wsky4xUVman5baOV3iLqTxPCkex+Oq+EIwAAzMUuLDy4qlVCE8vsq2XVl
	ZCYdcHUvV1Xg1ZuwCDfeMtdmti4P6S+idETSHT9TmVqLsFgoCkl5l6R91+6bHSZnrk6cyIe7xno
	S3lpsve+OW098+hV1YPUSB1LZRhFHnA7nPMCfQ==
X-Received: by 2002:a05:6402:4542:b0:662:b884:d1c with SMTP id
 4fb4d7f45d1cf-668c9420fc6mr1899113a12.10.1774011231281; Fri, 20 Mar 2026
 05:53:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260317023834.487682-1-pasha.tatashin@soleen.com> <2vxzqzpeaj1s.fsf@kernel.org>
In-Reply-To: <2vxzqzpeaj1s.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 20 Mar 2026 08:53:14 -0400
X-Gm-Features: AaiRm52JEkyZm6b_G1RRMaL21J4AyKm75SR_joFkY5PERgm0yr9pb9DptmMSN6c
Message-ID: <CA+CK2bC+U9BfPAScE4pvtd4BVbEZohy1xH9BT+_gN57_NQ-rZw@mail.gmail.com>
Subject: Re: [RFC] liveupdate: prevent double preservation
To: Pratyush Yadav <pratyush@kernel.org>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, rppt@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z9bgbi4guzjo4ihg1cxszi1fh63tfukp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E7741C0004
X-HE-Tag: 1774011232-160832
X-HE-Meta: U2FsdGVkX1/GQxgnZp5vpRKrVXLJSH/WCyPsvcId4O40cb22WvGJRkp9G2Ag4NxTrMyNB6BoN1tTW5j38zudYcfnv1OxzRTvuZiu+KLCvmsUNJSGErkwTfQb81rmZOEjbfrqBjE6nUdIpZQlGTXnmYagQoYB0Kifnk8cB5lUqdJEFLa2H4mC7HCFmPdQ+NqS7mJLVHfuwwhkVEDIfKaqN1z+OK15DF0mVPyRTAPdDQaRAckVp31XvQyrXSNnjhKcAMAKiT8FBbvqJRcV5LDd7e5Z/o0YMvCJoaWnX31ZEy8WhzoCbkl3Vi8ZQu/PKZQnq6afyXyhOc2Cx/fJc46R5/NtjF8MayYbfVXaNZSInH/fV+NUl4vDcBpljxadczUcIZ7EHXpJT7bOW0zUNnClWD/Ir4mtcbXlhDmOJg3APTO9qAfiEROnXaFYC7SIS8wy6bXY+2l0TJBW8k++U2FJYcYJJKCCNwx60dlfmOv/TGDedyaVZtIf/ZL2UysEDU43WMpDAY+siuTTGYwegBIEQUm+EaE1COuj3/xiOp+46vAFWkAG1pfUAY5Yjoh32IUMOy6vGvxuXE0p4JK414eXTZ9oMzOplOwaXIZbj8xzrPW3DMc8EeCOOHuUyB4c4Omy2wS3BAur5LrXGNnyN7wNSMslWv11sH3yZ60oW5gEULNkFASAHU+HWPj29si6C7NPJLE7GlhoZ2ULmf58YB4n5/LJnHaKNXBfNGAsEGYkBIXTVlc6SGguaYF5DASWoSYrYFx6yE83q5p1+YOORP8EbF49EjBnOjFemhOYkAIXPzIeBE+7AmT9gdoK1mOvFAWnXTAOto3pt0q3UbeHTv572UbQF6hdxq/QtFrkaJocSf4wTmCB/7sCvz6+G7fmteU1bmR7dXTwZVH1nhwkDa6Q6xltmxzHn0Zwcr2Hc8UE73JoOsRR86Cn9pnzapfbObecF/O5u7LJRjcFG44x1OD
 27pihuBa
 6OLUFQOiXTTQWFc9QCnY8Q5XalV/OprDa8NbkRTVvIEJXI7miqSG8s17dBmtSNldVwjs5D/2KEfh37si81O4YdTsZTGEykZunzQLSaUePmTfQsxJo2xVMVUZO9cAo05viSz++/luSUvK7m6jjAAeJ2NZbkO+erxIsLI6ofv/w8t/iYncHJavX4c/or7zhr3T3ox6K0vvdY9dMKEt+BYPq1Q64a8+BijZlhAqt/rRG3LbvS0ybXk1tWzapbU5As/Ue4CqH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 6:31=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Mon, Mar 16 2026, Pasha Tatashin wrote:
>
> > Currently, LUO does not prevent the same file from being preserved twic=
e
> > across different active sessions.
> >
> > Add a new i_state flag I_LUO_PRESERVED and update luo_preserve_file()
> > to check and set this flag when a file is preserved, and clear it in
> > luo_file_unpreserve_files() when it is released. This ensures that the
> > same file (inode) cannot be preserved by multiple sessions. If another
> > session attempts to preserve an already preserved file, it will now
> > fail with -EBUSY.
>
> For consistency, would it be a good idea to also set this flag after
> retrieve? And then clear it on finish? If we do that then I suppose we
> should rename the flag to I_LUO_MANAGED or something similar.

Hi Pratyush,

That is a good idea. Between the retrieve and finish operations, the
file still has limitations due to LUO ownership, so keeping it flagged
as managed is useful. For example, in memfd the memory should remain
pinned, and in iommu the DMA mappings cannot be resized until finish,
VFIO also has some limitations.

I will rename the flag to I_LUO_MANAGED and update the retrieve and
finish paths in the next version.

Pasha

>
> Other than this, LGTM from LUO perspective.
>
> Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>
> [...]
>
> --
> Regards,
> Pratyush Yadav

