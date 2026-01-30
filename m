Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91863E6BF31
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 17:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3F56B0088; Fri, 30 Jan 2026 12:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC3C6B0089; Fri, 30 Jan 2026 12:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2B06B008A; Fri, 30 Jan 2026 12:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9B456B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:34:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45EDE1B1A57
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:34:40 +0000 (UTC)
X-FDA: 84389329920.30.98564D4
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 77C8540005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:34:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="s4SQ/q/H";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769794478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lr0ACEC4r9sTM7XeNDuo4Q3LP3+bjrKF/ES76GEt9Qc=;
	b=b92jOAwPRx5nZKemEUUD4RJLB3FrQbeWrmb8DK0BJXBxf2IJEJq8tGG02rDWzfM76LJy+2
	CqVER713JSdIkZXc/Lbi3oLxDfPlb6knyLtgtaG0M3+8tGaSjNzdsR4gp8a2suMXdK4Dq7
	n4b1VttoKbCS7dahREoOFXE5LuQu3RU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="s4SQ/q/H";
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769794478; a=rsa-sha256;
	cv=none;
	b=2W3IiZC/hpChwcTURPPYHP7HGmyfCF4eEIgjgOczpehMCXrG5Z7MpJsjgeC43Q5rNDVXL6
	GS34K7JTlvDk9lHV3/pLQGfIZH/WF15ixAi+VgLuwR+K3iEIlS8JK89uUn0jih0cME7Kur
	mPg6eqtNuKbKvSYTUaz3zTW1Jh5gYFA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-502b0aa36feso29310271cf.1
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769794477; x=1770399277; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Lr0ACEC4r9sTM7XeNDuo4Q3LP3+bjrKF/ES76GEt9Qc=;
        b=s4SQ/q/HRoYo9i0sOeMiCGNX0hLIHbOggMwqRudgK6++VgsRIxwSQvZwYMhV5/8Yev
         9W432ZoYY4Lut2X+LF/MiZ9iQPSNq2VMB6YlfZm6D+r01gKo2iM+n7BOhxlxUbQx4G4Q
         pS3Srqlks+ygklfmyTi9ynoNj8bIgtz44PUEkDcvpNK02sRfTlQKvk7Gi54hEA+7/hM5
         Ig73YliIcCb+1h+yz4le+eHhNeT6mrYPYU6ZBM6b4ScEYcpCb/501xFAYfwe3G19ONGZ
         agdq4AOoQPK6FkPVh52rfYwbdd0SxhN6eYw6zP7YPlED05Mkn61HROQ8joC+17bYRft2
         zTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769794477; x=1770399277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lr0ACEC4r9sTM7XeNDuo4Q3LP3+bjrKF/ES76GEt9Qc=;
        b=lwTZ239uLc9orPa1/n2YztdpVe6K0ZUxooWsCo5TNjRRoSLP33bUAo5OiGYprRsrq/
         AL8ymz1Tro1dDyi3A+wiFqjUesWEjpEAhFHop+D7Fl/r+Kc6sogns2e5GeX1UX/hMk8z
         tA5f25V2hku4NHAjAAreiCn0bNOfHaH+lm1VAikBcVekicNH2RRokRVUKXycWtzBbvfW
         cd7a5fNaTdxjaR2rB0ut8MVLnScc/xcrgADFsCY/CatKdqF2tHYjJppZu6su0mvAC4TH
         xs635DfjmTq/2hSK6LASPvR+cYtQ8oaoZr1SoIBeMADNWKTjFuuT3vmiqVL3GRDkYiv1
         VxHg==
X-Gm-Message-State: AOJu0YwNg77wxig0MnLehdgodtkt6yK89U8dd6Fsajb5+WHOzdaWoH6Y
	cBzZZvoi9bZjYHAxU1+D1HhtX+KED/smRi5/lcNzvmYiOO68t9JTd7q+fr9iqNmkGvHm1LGc5z1
	435gjhAM=
X-Gm-Gg: AZuq6aKRkFuKVgiWOyZOrUHXDWe4H2O8mG/3gPhG/2im56vax4rAkz8iT3RNFgilN2U
	8FHHBDJwxaDUVMm4fA2TkPDItmByGCjzsgy3VEIuGrJP4BC98NDjUsxVFTjf2jwIFBG1MsyT8AK
	zDzEQgYUjm5pNWoHhclzqx2p/IfXzXrYe+lZkFF6Xd+zhr8NDxHZXglx29ZpeHSsxsyqMadTBgH
	mIX88IeM0VEJtGGl4OAMphmjE7okvwHjqRc0j8xaqsvgk3VlrYZw8O4CXuvmaeaamPKqzsmwskz
	Dua5XrFB/FKW8MQdS8sftDkZp9NwNvpVtUKSwdFkqcZWJvejHrv2fsxyCyG+eDnLkJCpH1W9BSQ
	KytX+/YeVLtrE3oAMTi1XdeJit9naszW2Gdpfts0JHWbKKefLWMpzYJqp8qvqcePg1KR1QS9lT7
	wmOfXue3cmxMUbpLQza4X/IHjdWt46aqWveRKli0xUHmJgCTNMxxHWUSPRyM4sEtLOXZKysg==
X-Received: by 2002:a05:622a:20c:b0:502:a1c6:3487 with SMTP id d75a77b69052e-505d289da0emr31891651cf.1.1769794475777;
        Fri, 30 Jan 2026 09:34:35 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033746eec5sm60844171cf.9.2026.01.30.09.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 09:34:35 -0800 (PST)
Date: Fri, 30 Jan 2026 12:34:33 -0500
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 0/9] cxl: explicit DAX driver selection and hotplug
Message-ID: <aXzrqYOmgo15NZ7s@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77C8540005
X-Stat-Signature: b31t5kw5zgmojffumo1c1xy1memoouti
X-Rspam-User: 
X-HE-Tag: 1769794478-759164
X-HE-Meta: U2FsdGVkX1/JOuEd6y/rMVffwyts6jWbJG6OhDwjfdZL+43JhXdZh61NITsxSxQPnxSMpm1iD2826OBb5piK5CnsWcPn7vruThy4DCSot/zi4onavmSMxdGL1C4dxX7YpzxGAnXx5NU8Xr9t7FDhzNmNBHo6+qf6j6W3Sp0o1em70eKYAA3Xw+Od8YQjHMoNEkKaMUSTSUImGDFDEgvGRwQtzuVDBWjtgDme0zbtC8Cxou/D/d+X5seAoD1gMG3uscrjYonAlYSiLgn6nHO81j7q6AMSM9oPQs5ZZ38oHozkoXM0V/Bmgl7C5uluiZ2a251mFcJksDP/DDucYqyOAGQJXo+Ae1It4fLbIuvhtLgDnh2+MkARnC/0jRbPRY3JQAxaj28KPDdMY9Cyo5ESOcVZyGvc99ZllK5PNNvbVaQB+Z7tcrmikpgyk9DgGEHrrWcSdCckiR9oG/yctHq1aS4pLU1/mDDM1BEsDgfMqXzF71YJ8dG0gD9Sd2B0d3YoKiGhuVCOU3j+L/PQzSiCK8d/B19039sy76fO6kzhG+Fc6txEMHKnln0Be3SAdAMTX6B1GbEnfalDSri7dl0eJZ5lArvRZRLTWT2PyxJmnlw2JlOzSHtxMCstbntSl/PMgICQ2lxLa8i0B+OCPQX6DjkhQXnBR9HejhjVINQ0HCuYjnHUGsFA5XYle+PiX/NeaU7aY4YuaeShuRe4Sqa3Nt4W5XSmbwh/V0eMhB9Wk6fQn/GTm0n3rCv7aBORYSc3Re5SNSHgEHIzb1Fwtwc0++7LaBkyVoLRJy1MrvWFCpRHWSI2c38SBIkPwPhV5guW5b5F2nsHSrrS+JnAtbwsB/bjOU5O34WFSCsqhCR4fFgyL2CRgBzevUzuOfKA59qj8ulonvaA+kbRx2OD8Y+BUTkxhJMioHHBHPrG1FwjNiok+vRkYrkwgdAkfQFxClGKf+9HPHlY0JR2li+YwR5
 CjkaTuqK
 +I++8Dneodq2nUv4Bl1IuHKSP0eHIjYzRE8iTBPRafs1zhhH5GBjb/vZljGA9Brcfv6/IZt1h8E1rhM7sjI07INrWX7r8DPjiH1FN+zX38NBAJ/rc2zpdcFwz3WhVJJgrUW70fL/nhyt2wW/w0CqKJWlbIPaDdSDoFGdRbHSRU2bP3/FXNypkPEsZb66VszyBnwixpzfD8LF0t3n7oSaoKej/7ymlbgTIATdxvz0W/VWZBbLglg/mKGTdkzz6OTLD1Yd3xoVkcG5wdlQcOt3h2nsiZDhZNIZZpJfi3pbTD1DstHHvCbuQKaZJxSKlYNj+xzslkAHEQDG5auA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:04:33PM -0500, Gregory Price wrote:
> Currently, CXL regions that create DAX devices have no mechanism to
> control select the hotplug online policy for kmem regions at region
> creation time. Users must either rely on a build-time default or
> manually configure each memory block after hotplug occurs.
> 

Looks like build regression on configs without hotplug

MMOP_ defines and mhp_get_default_online_type() undefined

Will let this version sit for a bit before spinning a v2

~Gregory

