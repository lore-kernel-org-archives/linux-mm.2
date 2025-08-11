Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63F9BC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41948E0059; Mon, 11 Aug 2025 09:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1358E0045; Mon, 11 Aug 2025 09:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB338E0059; Mon, 11 Aug 2025 09:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A211E8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:52:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E327B6874
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:52:08 +0000 (UTC)
X-FDA: 83764615536.30.93BFA65
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB63914000B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:52:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i8X8nruw;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754920326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTn74kXTenCe2+mpLi8VY9GhjVyOuZE2DKDiF5RvCuI=;
	b=ic+PJaMK4kIIg1mGC0PrG7Z8L7KXOJKYvbA2R3oT1iu2Q385IHR5BkAC5Ero5tEoobpgF1
	M8rYjxXXveE/HLfNR3QyZeuNdmrN60wOIhhdP0Am6BzcvEqkV8nkdtPPx/l2czgrMy+6jA
	MFGh3OpISb8za14gIccKAV2KtjT++rI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=i8X8nruw;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754920326; a=rsa-sha256;
	cv=none;
	b=m7Izes7j6FHsqtU6nrNLEw0+1ynefo4YEspNWLU3jMmXpwjc0/bueCidl2Dr7eHdGphZuQ
	BYleIGwEKMtkTFoTvMRdu1o1RjxRb2UYbrU/iQI2DP7hSp7v79eGLD75HzuA9ZfF5QiLNC
	1FNi2FMv8ektZJiaVDQzWXU5XJtntLw=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b0ad5fa282so47561891cf.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754920325; x=1755525125; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fTn74kXTenCe2+mpLi8VY9GhjVyOuZE2DKDiF5RvCuI=;
        b=i8X8nruwmPhGF3GnESprsh/cv3vw/VGNhzGxJFbOJe/hKPDyjpivD+lXPhtHtC6oOv
         NRhhtCMCgT6RnaQU6wn8ceLnkP/1226AiTUXAK88oOctD4YJLo1AM5Olb7yyZ740Itxt
         aXK/t9UK/hGwvNoqQMrSVGRdyCI9WQG58bjGitWgkC4q6UzpaktO7Fdi5CwxSXP4w9tb
         Thm5gRMK9TRok43N/OGIst6tKtmqXG//Gs7eSomE60GlnBC1c0Gx25cqFmkopmSMH3z3
         acqQNP3+JeY44DyLhJW7lZISHguCRF9oE8XBKkqVEk0D0vRCu9xEbnlN2waFnB7ypNsC
         uvmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754920325; x=1755525125;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTn74kXTenCe2+mpLi8VY9GhjVyOuZE2DKDiF5RvCuI=;
        b=SHI0ULh1HTPbvOXSDnRbainEYhJfekvBqWU3RKwNRqc4EKWIXrpaipGdLgyoS6Q7ZY
         79aFbglzS1A9iOooHxUejwVK2eYK3G/plA1B5t25yThbsIAkQ2WwMrxbIoVJUeR84uCW
         KdFWAhXr40K8PuGr2hIvff2E+o7HrBVqAQhkRYZRv+GvVgxmcR+0z8kGHVHomoe4B/HH
         djyMuz3ADtr1VeDN20gLcouMWyxATopZrcoMC+VnfZsfXygcKYVJmrRwHnPFsePouQ24
         WP0UaDbLnNrOrnTdpjXvXA4EeT/yEXwVfz2wZXZMXiXwdugM48MAm64eVsUmp4t3cxg4
         vO6A==
X-Forwarded-Encrypted: i=1; AJvYcCVqUPvQh5lClDDfAPeoWucxXNohjatJarN5211FNxs11ECbhYUND0aIHBlZBmtWi1Fe4QTLmF0j6w==@kvack.org
X-Gm-Message-State: AOJu0YxErMqJs3gBcAFvHxi2ONErIGIASDT1mEhH0V2EefOvF78d2Emz
	Y2XG9LE1ggVrGLcJoEzv1IzdIKhWiT4IzrKxtljtUGQ66UKO3jZA/vrOOTC/Op+BVzWuDhLZ+CZ
	xwV6nb6AVK4k5w/fH0W+3ceWeodOJ0DYyY+FZHwzkag==
X-Gm-Gg: ASbGnctl/5MwwQRkeNR3XsAYNXpMA7HTjTIidXuDQO/FF4+8WHgldvoPkZtdSjQJr62
	dyTYsITY0WC+WscMOTBUccEUTC1CFvqG0tF5cghu2ST78K7zjhsaz4i0ojyNH2lDRdEe4vtlguN
	Swpb0xSlsDoPAklk55ROzmLkFc15ZXO24C/beWVqgX1IR3gGYnV6szTjb7sdzwDT2Z+mmyvFsgw
	7LZ
X-Google-Smtp-Source: AGHT+IFjGZMR0QC3maskM6Ppr2PsYUBGxXmOyXxknJLVF0Guw0qbzv3Uek3nZlX+0Fi9TLwpQwmiNNtUihpuPqK37/s=
X-Received: by 2002:ac8:5d07:0:b0:4ab:63b8:3320 with SMTP id
 d75a77b69052e-4b0a0814fa0mr205321201cf.23.1754920325560; Mon, 11 Aug 2025
 06:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <05f47f4f-524e-0925-9e23-bfa7286d455c@google.com>
In-Reply-To: <05f47f4f-524e-0925-9e23-bfa7286d455c@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 11 Aug 2025 09:51:27 -0400
X-Gm-Features: Ac12FXxgVHHQR2XNHo6Ln5u1bpFpbMFBWMIT_RQnUZCHHdyi-Fvosfa6QFSyvoA
Message-ID: <CA+CK2bAC84Kmov3+zHjMnH38Ux8kgyxPqeptg01mYCUhzYRpqw@mail.gmail.com>
Subject: Re: [Hypervisor Live Update] Notes from July 28, 2025
To: David Rientjes <rientjes@google.com>
Cc: Alexander Graf <graf@amazon.com>, Anthony Yznaga <anthony.yznaga@oracle.com>, 
	Dave Hansen <dave.hansen@intel.com>, David Hildenbrand <david@redhat.com>, 
	David Matlack <dmatlack@google.com>, Frank van der Linden <fvdl@google.com>, James Gowans <jgowans@amazon.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jork Loeser <jork.loeser@microsoft.com>, 
	Junaid Shahid <junaids@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Pasha Tatashin <tatashin@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Praveen Kumar <kpraveen.lkml@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	"Woodhouse, David" <dwmw@amazon.co.uk>, linux-mm@kvack.org, kexec@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AB63914000B
X-Rspamd-Server: rspam06
X-Stat-Signature: ufbkjioyna6w1jc3xkngzr1nc8iq164u
X-HE-Tag: 1754920326-286794
X-HE-Meta: U2FsdGVkX1+ykFBKh7HVWTPXU1a8gXnaQqw7hCtdGfwRnJnwXF47lmHl/ln7a5ka6nMKfZ68vWsdD67TJ21zJWfrx4DoXKhB9cYLAtxNP1CiW1+Kns/lIrvTYMYMIDY9FHQP2nWiiNo+5lIIpdhodR7olhFPPMTgjJAvxmLna5Esk4oK9X2nj1g7ICqJmLy6tGYBa/TiYfzfJfrYGBoV+oJL4tvBcW4iBHb1H/ECNco7KXUTB9QN6df/hRSTS6/JCDK0FKTPEvijt0acLQICqsK3HxFeb8SyXrySkweMg5e665fCZmxCtKMViVTeauGOzonkoOa+6GboXsWJVeMgNkSinoOKRblwUtcqGNw6dmxwVEViJZKQHx6nLtKj8thxrKp2vI/qPvixUheQVU1G99oGpHVHXiMnX9lL6dtpNtB9vPKxOU8zLnVMJ8RovnwjwpA0tGqDk63pj4Rm5ZwC35EnK8G3nTrE5XPHzhscH7/GCZNQEX2jb0I7HRKqRnXCQk+r17Ybugs0IaYf8h4zZexQSJ6xDdysuEXhBhazxLEeGgYQlRsddT7+prK2GjWNqfG6PARvUaDK/8Cbff2cnjgFImQA5YvPh5n+3KiTCxydundd0C7DWkM+kchMTv40QAuAVNZAA55+C+AWkIQmo4bQEOxawpUhoNmyD9vEFrpTDDSX6zwt2a/FuOHPElqSEecBUAE0yq0X2tODuMERdvT3815U4fFi5qGkeahzhDwdtsrn5y2ZanWU4fCqbTb06uN79xf0w0SExZLOGuHwc3OGZAozfuCfuqrItSUDXZUF+rws32wM8eVej73i3bej4pvLmsspSk/eycShzfzCCp4r7pOkaxx2HI9jGNnFbKdCN+WeYg0U5wHR/PL4WFGA66qzMlbQKsCmQsHO7HuvkYpJpji8PGg2647yykL6KQpX6vFds6a5xkp35V7YO5beBfCQwGAVu46nrBh+spr
 nbI5goYO
 yw2XQwg8Y3WOcBQRv7ocjy4g1ydAs9k1VoZuxVkEPXlhNPJKJPz2luo37otPKsOMaoveYqM6MWdGTIzLexPUmxGusC6AqMZ8cMob0J6BAaQFzG/Fw7bVH2RKY52u04S2XfojgCmrt2f0QdSPAo7F9VXy8zeSStf0lCCn3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ----->o-----
> Next meeting will be on Monday, August 11 at 8am PDT (UTC-7), everybody is
> welcome: https://meet.google.com/rjn-dmzu-hgq
>
> Topics for the next meeting:
>
>  - follow-up on sticky preservations with KHO, any additional insight
>    provided for MSHV use cases
>  - update on LUO v3 and akpm's request to rebase on top of 6.17-rc1 and
>    send v3
>  - discuss enforcing single open in LUO and also support for using the
>    ioctl to get an fd with a session label
>  - design discussion for luod, the agent previously referred to as
>    LiveupdateD

luod design: https://tinyurl.com/luoddesign

Comments are greatly appreciated.

>  - update on physical pool allocator wrt folio support and the ability to
>    pfnmap from within the range of memory
>  - update on PCI preservation, registration, and initialization, and the
>    RFC patch series posted previously
>  - later: testing methodology to allow downstream consumers to qualify
>    that live update works from one version to another
>  - later: reducing blackout window during live update
>
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!
>

