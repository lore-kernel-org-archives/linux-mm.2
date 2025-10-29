Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED710CCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6BBB8E00A9; Wed, 29 Oct 2025 12:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D434C8E0045; Wed, 29 Oct 2025 12:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58B38E00A9; Wed, 29 Oct 2025 12:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6C1A8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:09:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 475691A083C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:09:25 +0000 (UTC)
X-FDA: 84051636690.16.EBE02E7
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40F5D140012
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:09:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=P5c4sRsa;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761754163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ra6gE4GNLdWG7Tqyy4+9etzH3tIuFsSBjp83q0VcDV0=;
	b=jvCFsNMgu348p/EvgwXEtxQzFPp5NVxYU1Km0sCRRaypzcqxAweeAOqodL3Hrd1iXTiXCL
	BXTnM6jXHd1yNLJ6vri9tzG48Q7q9p6RA2xIbGEjWK4pr5i+qwzagOTZDX7GI8RWKCV+ix
	Jay/ZsBFPC3HcWxvbeV1OUAg+uWjtSs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=P5c4sRsa;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.176 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761754163; a=rsa-sha256;
	cv=none;
	b=z26IxpfOQJQbAQC5qnUUB5b2DvpuvDao+DRrMsTvTNNVriv28EX/LBGtMkEoWuh7TvNRWB
	SdKf/ADI04P7kGIbGVJYHQjD6Odief/uaPvFZHL7m2OiFj1bnnlXc6/IfQuHhSn0MuYIzK
	B7YzCHmZByF12bFOmKuE8Z5W+zKpksk=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-88f2aebce7fso762084485a.3
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761754162; x=1762358962; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ra6gE4GNLdWG7Tqyy4+9etzH3tIuFsSBjp83q0VcDV0=;
        b=P5c4sRsaiKlzEJrLKubHF3ixd49fJCqClR/xacKUuihCYiSwvOC1L0ayBoblaEmMld
         +Z8TFrypD6gtbswKqFX5MF3A5vpnjGUDue80LdSa6MaCwqhUktLBo5LDC2HQ1uff2opq
         iVFHDOIAZFuD/uW2oLY9LPr8/rAMp4vUOAKsNqBNhoVHZdBgnElbOUQg4hZfPQv8/bQO
         QM3r975zgzS1ag/BYAs9SbDVk5tPwGiLug/zUF/abhSL8x84PDVtm2fEJGfGv3QjaP7k
         nOS0bBsShQmnTHkHsRvuZw7SDfa6n5K4pmytbQ7hjA3cwEAQht9BoQfk6xaofat/jI5D
         N3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761754162; x=1762358962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ra6gE4GNLdWG7Tqyy4+9etzH3tIuFsSBjp83q0VcDV0=;
        b=LEQLaxTJkpubFtJBTVe+FI1aCzBT3xtvL+wuxmYSAoP3sp4fe/13Pc+6Fj9NpVdLKq
         4nCnBy/F7BtBlT7pl08T6P8t6SMMCM2fo/c4f4Hr2c9JC1MiAUOlHToMlCM2Vlcg2JyU
         VF2CyiE+lEURaZS8jSJcrfdsgLZEB4OYvgRYs8b3IAuhKFfxPlzAx6G9AQJjXdlxiqiJ
         wRLLH0biimZ+sEqqZgm7RhW/7GuHNCThW+FmGfvJxagR0JI73yAkkPQCiIEuSTy7GCiS
         XdrV2CoELYDK3Jxav8NIS74LNI1Wem6QFqORsD5SSh5hQZqFadtev1ZyaVP2rNuZuFRb
         PnmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUb5MlYCi1EzaoOgu76xdRYfocl86lRt7dMEWo5GBDhoD2H2D5iEWWJVPsEkVcmfNlLPbfL0iCLMQ==@kvack.org
X-Gm-Message-State: AOJu0YzKHjmOFX25d2WVgUpsoNxXvAOYDYxR71/YuVsOtg+O4rXVzNt7
	u3+tRbGzrYbjnxA1S1nOXllWADlTo4wpOCm4V1UQp4TeNl8iRXP4WPoUx++yolDYgFY=
X-Gm-Gg: ASbGnctrRBa+eRqFW17a2ykQ8gkgPVZ6sv20rdChHMvO3Bd9TA0a+7bEFm4bxMWyK0F
	vTwa1MLsAb972a8qm/zJtDfT+pcyPqiRdlWMDYclh4l51OVHIrO0Vjs503mIvuMwq2kDk86DEWr
	R8zyml52wBJj1nf2K317yWhko5tUdwTTJdi9Gw3xxiepM7/U2fGTDJAuJHwAfMIVp1phc7Atpos
	AA53p2O9xT6BtI6RjTWxjWIUzO+TQg/bC6a1VHl5lXV2udtascu5c1lh1Pp2I/W6awA4L/JKxXM
	quXYshXoJI5zqEWwrrjirCQPEu5zntRX6gUPRpDx9dU566eZWfuY8MXQCF7IVCAwCV15ZnS+UP7
	uX+8qJQ5iGSOvDo5DAOuJl+SLTK+MoUrdgimWOWAgWakAJ60bVbAiOp2RyC/+n7amnREsZX3Lcu
	9BBrazRbGd7tNKPa3E413SfeEA5I4mlKCspBV9unPyrjrDhA==
X-Google-Smtp-Source: AGHT+IF6rFnidmIfY6Ro1wANLijusetvx4ngsO9eh8sfxCbTUwpnkArLo2xTU45YJpn8RBXsZSHBbA==
X-Received: by 2002:a05:620a:19a5:b0:866:73f7:25a2 with SMTP id af79cd13be357-8a8ef52d830mr451427585a.64.1761754162225;
        Wed, 29 Oct 2025 09:09:22 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f254a41cdsm1078205885a.29.2025.10.29.09.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:09:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vE8jh-00000004ztF-0Awe;
	Wed, 29 Oct 2025 13:09:21 -0300
Date: Wed, 29 Oct 2025 13:09:21 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: David Matlack <dmatlack@google.com>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org,
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-ID: <20251029160921.GP760669@ziepe.ca>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <20251021000852.2924827-2-pasha.tatashin@soleen.com>
 <CALzav=egQiF6tanYxR9Tow7TnT_UK9bNAR_4DQ2P=2EJ+H4ZJA@mail.gmail.com>
 <CA+CK2bAibAPzTq+edRTXS9g7Cs0w-zCiSSrXUkoFAHe7=3C0QA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bAibAPzTq+edRTXS9g7Cs0w-zCiSSrXUkoFAHe7=3C0QA@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40F5D140012
X-Stat-Signature: c6s36h9yixhuejir1mw7pprmy1jfr8bj
X-Rspam-User: 
X-HE-Tag: 1761754163-733135
X-HE-Meta: U2FsdGVkX1940UJsry8vNLv3VV5YEn9TPN/ybCs3+ImftuXwznFCxYKm7/2iZjXGcjY9lWUX2NWPTRbnE3VBfpheihsmYQu64CWOYpgPj5iMyIgVAZp+rkMG1jPwC+pqWVe/JdtyBH6zU7/HTc29JzwAjHS5N9R/dFcdaYc3WnksNi5DWtem5n9RbzY3TzwGKvBQY7zcQezEoHJXGHj8fHnRd7fEYFFMqKdOSz04iivyDIh6hlxK2rck385h2cxMtwxdHIlh5buSLoYP01+bBZMU4LHprMFKa6ZxzrjseCW8TIaGUVeWqwXY0tCwLshxMaOT96FIofyDDd7JpNDE1sEursNf5jTa0WQ664Zllkan69qWs/x39Gprx9Q68O8dvv06xjk6e5QxpK8DQJ6pnXPquQIGHwJZbNMczicDMcAGAG10kX030BXd392YXdxzljBVTtUfoJxarD3lVALU5QxJhRyxgEvGyvqXKeN7PK3C8DfPGYYMxynsAXKzb4dhbwcLbtbQT/EkiXkLcBlqm/hUtPtEMKb4LYoylQsrsfYUJNTYgnTLyS2mzNak9hGEhThLT8nVnXGZAgFulBlUwrbhT27DlZXB6V+9emFG3IZNVZkgT3rZgTQ8MdL3W40GffZkNV/bXZ6CTiMlsCsoSLfmNMH6lEkWPee7oBTmKk19A7jWdf0KHbZwz41M3TsFiBJRt7t5I6duxUglsVKVBFZWND01IcBbjkquqZSTLiaKc02yI/yxNFX24V+TDrVwRy9MZ2yIl1MIMCtZBTuM0vIRKlyUgTzzOV13oQRf5KZAvwHqEctfPiuZcW6NVWtxKR3YHD2Fm+C6ghNkh7lde88w5Ef067D9/Uj71mQ0biAuSThLZ73ljF0hFBOgzmZD1M3YbZ7AekYfWRMllpZjc/Bc6cAngtB9F8+aCu+l2B1NggHTUcAi41uCMrspJRIdbvuQ8P3GdLQomDO5fy5
 8r9FxR17
 7zvVjARcrwQDdQ1oRjhsZ/pNydoDo9frhFrPzDQu3qbsRFP8/ZHUrd014SWM6KPiDWn9LrYWugOqOeVA99Peq/uiwN1IVDIRZV0ZgrlJLDiEKvtkIRerczqcKu2AE8JnqtodQ4aQtd1Pc9SfjwcXu6jeNRdhko6lXZe52Aq8j/rd+wG/7y5DKE7KXAdpWZux/kwuvsIhp/07SUtmuIpl02X3WffzQhDaDtVqM9UitojrRnHZmW+y1Mix60A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 08:01:59PM -0400, Pasha Tatashin wrote:
> > >  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
> > >  {
> > > -       void *elm, *res;
> > > +       void *res = xa_load(xa, index);
> > >
> > > -       elm = xa_load(xa, index);
> > > -       if (elm)
> > > -               return elm;
> > > +       if (res)
> > > +               return res;
> > > +
> > > +       void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
> >
> > nit: This breaks the local style of always declaring variables at the
> > beginning of blocks.
> 
> I think this suggestion came from Mike, to me it looks alright, as it
> is only part of the clean-up path.

It is the recommended style for using cleanup.h stuff, declare and
assign in one statement.

Jason

