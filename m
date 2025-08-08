Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5B5C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 10:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCCA6B008A; Fri,  8 Aug 2025 06:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B51A6B008C; Fri,  8 Aug 2025 06:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAC26B0093; Fri,  8 Aug 2025 06:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB706B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 06:37:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D93491340A2
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:37:32 +0000 (UTC)
X-FDA: 83753238744.14.F025685
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id E169880010
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:37:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXtvu46V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754649451; a=rsa-sha256;
	cv=none;
	b=IBNgAC3J2l6RKVN6u+4HI4+CARaeaWzTB4J+Hc0tAPUlecJlTdzyQMungDeJaos1LmKlKy
	ZX4p4C5nyO93AQWhRWQcFVAFMiIfo/Ag2U8NIoFOMvA35mVsyxmAiTnGYH7Oj8OAlG+czR
	iZd8U1FrSnh3eE0dVO1xPhLWFalGZJw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lXtvu46V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754649451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tivFsmlGRlUC+/lbvStJvCaC7HPoVZahlLXTN48EL6E=;
	b=FB88u+q8iEdiIOW5mSKfBqaomcd6PD37gpmJRT7dNaFGRgXN58nn6PNioY9PpKDOPwkSMh
	kSPLERlcTy0PQgigUZV8SEMqO0div3mciD33V095QnMcX6SiA2mcW582fKMLSu36YkI49y
	IH781CjBy4hDfaKJLFjrYGoscSdG2qY=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55b8f1a13e9so1635258e87.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 03:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754649449; x=1755254249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tivFsmlGRlUC+/lbvStJvCaC7HPoVZahlLXTN48EL6E=;
        b=lXtvu46V8LL5xvvPUX+NtFQTvStZAgkkm1eTr9+W2VNwmq3f8Ai5uWT2GdlN30P+u2
         I1pVwOi2KxxiAz40+3IBmQaomsDbDXLgyUbIss6K6EZWrp9Gmgfa9hHuHuet91QDFxD3
         P1ybO0mevHF6eXuFdmJPBoknIYGJc7mse8IOda8FXvxgHjr1WgDwz+OxuKadUWybA0If
         f3bhoFStNCwj9yYNY4gwTsrd1T8egqjdF3gI/ucu0dWsZMwbAuDCXmMwxzkkvUqjnsQS
         Wt4/ipT9/e9O1oJKZvQItnlPWz51ioy3fqdXeuXJIzkOUONW8V9G/iCiHoO5UgXJyjdR
         qKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754649449; x=1755254249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tivFsmlGRlUC+/lbvStJvCaC7HPoVZahlLXTN48EL6E=;
        b=BfJNfh2yIw5fXjKiQ2iHw9OCMW7Zap/3cRVmk5NxX0B7ueIMrJjtE2ecuaAVVjq6Ef
         f50n0L9otg2/r+qOs5O9aSbV238M+++tofRp2PAjpdBugFqTiQpouXTqwhQznjdizqbL
         r7z4jIOVeOxIxvl/B/8NIRKQkj0DYhlspY/YmdRIEJAWgu+SZOLDsS4h3cddzQVa/8ew
         5WMsWexIu0M71l+1MsfBQmIbQMWo6gyPlopbsyuV3LGM5rSbjhqXJ826Ti1FvkbTY4eg
         RxVPd4K0BvGsH0nx6D47XDDWAuhL4ei/VrVqvTkDsLyAdEYuOyjNvnqhBd/xROtjaRRH
         Q7pA==
X-Forwarded-Encrypted: i=1; AJvYcCUOX8TG3jQfnF7wrr+Y113KvYXwIVSw65NnsumLp+3mA+hFk8ZKhRH7ZVKVWM6Ln4X4iYRi3eDdDw==@kvack.org
X-Gm-Message-State: AOJu0YywuqORcqFbLtC4pcFh8PJdoSXnxI+A/A1yEwO7b1xA0KR1CJuP
	HyrsC+ZCrLrzMzLVbCMWKrckOXBbvPCDXA2pdImo/qp4/S+tvP5zTDmz
X-Gm-Gg: ASbGncvCx8UrTbRVtKleDzt4YKUgveNHTV/FWpB2D35zXAhCzpkoYQf5QMp0U8N4RCx
	psnHa3Ci7KN/XP/D3XQATKBQoMvGVgR7ohCBmqnTutj4u3g+RVlvp8fE4IeK5IgpODXCmIyH2Jb
	FV1VY4QG5FNM3EyfOaWwee3s/oZDU+naKo87JYcV+VIMCD6jqlmyP1MIujimqd5ZY7VZgIMdgjt
	dfk40XY92kvnvP7d2RyHo8wsIWdM0ik3O+BUrv7ssA+x+l8tuAapyc0v73BzNxaPnrLXn0KmVjA
	4HpyPhxmImPO4qqwF5PzwJtMH5TJBUQL9rGZV1aJDna0O3/WiIXqv9y6rQU0mLf2r029MbnBaCZ
	T7SYnSl90ak0T3IcgRt2DpjUzEXP66diCmIs/W/dv/STICyLt7Q==
X-Google-Smtp-Source: AGHT+IGNPK/qZH+sTZpLkeVRCl0hK0nwxTZO2ywKJOBNHZUofU093y94ClyRD93Q0Qu6fX0gT++vdA==
X-Received: by 2002:a05:6512:4021:b0:553:a30b:ee04 with SMTP id 2adb3069b0e04-55cc00ea59fmr619925e87.14.1754649448954;
        Fri, 08 Aug 2025 03:37:28 -0700 (PDT)
Received: from pc636 (host-90-233-217-11.mobileonline.telia.com. [90.233.217.11])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88ca3327sm2957802e87.127.2025.08.08.03.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 03:37:28 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 8 Aug 2025 12:37:26 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] mm/vmalloc: Defer freeing partly initialized
 vm_struct
Message-ID: <aJXTZv5axtX08qnT@pc636>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-7-urezki@gmail.com>
 <aJSNDcMxE5BVl6or@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSNDcMxE5BVl6or@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E169880010
X-Stat-Signature: mftt13p15zznihw14e66yiak4qi1ing1
X-HE-Tag: 1754649450-22698
X-HE-Meta: U2FsdGVkX1+Ymgq2MiSbREn/3mNPZadQ5jQvWDSFyx07bocef7GfJuOJdP3lKlXEJnhYN7UKHvkN3OFf2EoBEw+Q/RZobarLjR6Wr41hs6x+b3i/mLrJ34DAUp42ZrT5EaGMLME7F2+9qrOa4CBGYIA81wQJP7Jo+1Bt5+ArumXGBhQlnY7oeUoM6hEm/5SLJA6yZ2yvi4XuwKr4C37RPzFHs7Ny4HHcoEhHAFeUNzh/yL/nhFeEJ/vwM+DwFdDWPJMQdoR6acJZLygBdJTr2CDPezUaSN32wy7rBwwxDd+2Ye73ah/URtZDYqJaiBUiUNQZ8+hhBQin8pOfCoiDfS6M9Uhxc7YFFq7wpw83Q3o1ZJ2BgjXbaXsGCbaTFkWUcwep1zCggCOTF+vk+XvAROaRdhQEAm0ism9SSR1c7jI52GBACfTPtdU2pAOVpRPxX2YoUAiWTfes4//gvAFP//v/MpdqFBYtFtyzNwzh7ai8hpKo7P09KmbLWyPlU0mP2Td+MUM+YZ9qHJvg0KLlwiO2foPUOD6rjxBRxOr8r3rpni1TZIUFSKt0lLwmtM78BF/VWMJh9s/dtOkWMl5vLNuL8Nqo7nfKzPh9ZqD4eRcyuuLdGHqfyhXtrgfPuxRpEuJW2XPS3CS9HnFN4bO+0IoZovUqobS9/c6lAgsCcIfnK4qijz+DpsHZgojDCf6PStqame1HOf+jzzLaPffwNktXMQSedJ0JWpXMywrtSY0YoHMaO+ccehO2gslStPLuodkOoDFsi/+ilNk1CqzJH5QZ0Jxxp6Lf82LgcAfoSWRXOnT3xPqkHK6EYIK4lupnIljBUyY2mupSgMVymwcPhtw4VdcgrfViTgR8odsemON2rhxmdCeXEpPUrHkfAhDLC7bsSEAU+LQJ/0KrfuAENcjzWz3bRWJMS6fOOUvmbwSJqcJs7LZb5tzNOWx7X0bbZzuSkyehN2EehfeR/uF
 MOJzcV6m
 +QEaYEkDmAKA1Usk3VPP2QELFBlrdtpMgHXmNnXmEX50alBESIDczN2S/XaqYU7ynDgS961ne8YxZhtmztRPfMhPonkhlVIZvsBPsX8yiWKrurqpC82fJT3AKbI0+T4uaxtuVz91wAJOMJ25BXiRjK0TD2pVHd0sfHGN837tUjZ2dEh2hqoExgxriKjS5jPWqE0SrnDDxeY7u3Ed/RF2Be6aNmGoEFbRhKds6J9ZDz1VYpFOqm/rJhOA/hg+vk6i1Uug2Chewe0NpDFSOSNAuF1mc9xJ+/qSYao1LjAbsjuHdprVJ67F1pNVU8qyrnLpaZIBIJ4R1nvd70C3qo6t1Zh0mMpBVuGfWhgVuyvkCF5gMqe7R44NSefAKWX0PF57hKr5+uKh8Rs7ZtWhHQI9GOzS3vmLJA9h25CT1V3CYYkhSklCnLGVbjrhaXs0JxyQWl4Yns40M8l15N6SE6G1gPslLPaVgMQoDy1QAr6DpSpl5xpd5O1+m+kzAejIO9ZoSjlnWiwH3pxiGFVeADbt6uZbUL2xDR4TsAAcFJ+e0SRLZ3M9Y8hqIoJ1FXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 01:25:01PM +0200, Michal Hocko wrote:
> On Thu 07-08-25 09:58:08, Uladzislau Rezki wrote:
> > __vmalloc_area_node() may call free_vmap_area() or vfree() on
> > error paths, both of which can sleep. This becomes problematic
> > if the function is invoked from an atomic context, such as when
> > GFP_ATOMIC or GFP_NOWAIT is passed via gfp_mask.
> > 
> > To fix this, unify error paths and defer the cleanup of partly
> > initialized vm_struct objects to a workqueue. This ensures that
> > freeing happens in a process context and avoids invalid sleeps
> > in atomic regions.
> > 
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> LGTM
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks!
> 
Thanks, applied Acked-by.

--
Uladzislau Rezki

