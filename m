Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0F2CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 14:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BD516B0005; Mon,  8 Jun 2026 10:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295566B0093; Mon,  8 Jun 2026 10:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2976B0095; Mon,  8 Jun 2026 10:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EAC86B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 10:56:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B63488B59F
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:56:33 +0000 (UTC)
X-FDA: 84857046666.07.F15F7D4
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id DD5E420002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:56:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UbL6Z57e;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780930592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XaEoBFZ0wQN7RayZ7ZGkzrqQNmFAZboLFpyYk5DAFk=;
	b=DdfZmXMaCbQgBA5lRDO4aLVERm020gkaFqYPmofqXgGj9KP5zExVnqPQ5kJMNwOaegQNtz
	90kP1ZgTnWUUqjbXZNi/Pdj6lUW0V5lr1mUSQ6W4JmgDTxGw+HWA78ccg+83Pmc34PT+bw
	o3OVJhWLjt0OuF7ndf5WwBq7SNZ1O/M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UbL6Z57e;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780930592;
	b=C238jEpa3aJcq142aBcFmRBNu7OX84E8dxqG6eFjZvn1C9qjdIteyOzPd71Rx2q0Wxj88B
	Z/sscAzMsw+99ReH07uuoKYs/iaGAI5FheY1aEjkd1h8y3qTYnZLBsFUc1zmldNm6kTgL6
	33t3I2fyoTKKyuV/VPLKPNB8AgYdO2k=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5176bbb9384so45186211cf.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 07:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780930591; x=1781535391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5XaEoBFZ0wQN7RayZ7ZGkzrqQNmFAZboLFpyYk5DAFk=;
        b=UbL6Z57es61oJ7LCt9D8tWwlypWrWAgCkVM/rGCqSDGTuPGWPJ1dwofPbs4o13Op5V
         jCCobXKkJY+JTlzMJ5g71NAckvgQ0lsHyAVXMUclBsnYoVoQvNuUWRvPMjMUS6pKSH3e
         JoDtZW/B+KePKa96K0BX5I3B512B8Mn65+QwPzflx8GYuUX/oFNR8/E4bFmttJQhdae2
         CFp9QoLRyZrH2KhenonZABWvhKRLYTeCKyP5RUProDbbAksNVi4zQZxamwVKqQO5Uf11
         uyrE9OyHhuDRnyEpQ1fXU7vn3r0/4s16SLTwC3adaX3fAWaBg7pDhsVtJl37tXSpVN+8
         kmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780930591; x=1781535391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5XaEoBFZ0wQN7RayZ7ZGkzrqQNmFAZboLFpyYk5DAFk=;
        b=nczI8WtIzqXVUZPX3mIusuo9yqBsVHM+sdwSIPj3HyE6cOX0uR7sqwdgukvpnYOEBL
         Uw20+baZQpU5Q022XqShGJ1FbvC4j1mm3JwydTJ3v3AM8cVu/BWotwesgTRVSKtiYbQG
         jPVVgwE183QGcKZnUT9njbZh2mAER8OA1BKCWLIcbyAcKlOV2mQb4V4yv5kQPl8C+s1r
         NUBs/D4dmYfm0xGy7B5ScbPF+LKjb+xBlJ5f1cbkXh9UOJ8b76YHA2f4VhtWaTuRA8ea
         ZEMDgz8408f0cqD0E5mn4ccfdgZCFYX/+Qzncp1y5mS0HjrcgpDNQspsBdQbnBBrSErO
         MItA==
X-Forwarded-Encrypted: i=1; AFNElJ91Isv6lD8B5xrwy96YIH9niwWMAyn0Cb/2KNGyOhCSPw0A71AMfQog+hFZ858fR+VBPPGpZDxINA==@kvack.org
X-Gm-Message-State: AOJu0Yz60MLq2AfG2kIRwUGImcgRvWnCBd5hosZZ6pt3UWtk8sdPnz3F
	7S8V1JcHRiAEG1Yqzu1lVcKb4DXSyCnCSF9yPHEkeP5fWmxohLGZhgUtka9pn0o45Yk7XQvd2i0
	vsD0A
X-Gm-Gg: Acq92OGnT3IKsGxPxggbn0o6oCuUW85k4op/EUW/Rh1fnLePOudcCKDTtAd7sIbKy1+
	3i0ffGWEj33E3JeCuNtMibar4h2Pf/r6e5Rmp5TAeq41o9edQaQ7LdLV8rSkf7Ay/FWnxQVSnu1
	Fnf8xYw+n4SQDCtVeOet9Dv2xhjlRoZmMkv0503wKJi9uLEzaC4D5U9LvHnYAbb0qz3h71A7gPN
	150segoWhDQ3JhsTfaW/uxPqgsZKW9j3T3kJ+1lQbLwOcLWeXHQ2YfF1EdzYXmXbO8TPG6kDQng
	Ojz/ASYFYTrboxwsZZvO33LLsGgHfTG8ThO5rYQjVoWQBvXU0Y1pBG7hSJokDVXsUBsvdYbcvlj
	YTgWfKSRNYh1PG67lPSEoCEvzllnVVsjH4QKXIyAB+Om+nknRmhd7sWtOCMwAFsZGao5mamG6+C
	/j1dPllDNT3e9oJDqLi1BLZ/rvGK/XLoDPz3Ag9ca5MEfoC91zuJnorvG1mZzM7w==
X-Received: by 2002:a05:622a:1648:b0:517:6d75:a2cf with SMTP id d75a77b69052e-51795c5a18fmr245549391cf.43.1780930590664;
        Mon, 08 Jun 2026 07:56:30 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775dbd2c9sm158664971cf.23.2026.06.08.07.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 07:56:30 -0700 (PDT)
Date: Mon, 8 Jun 2026 14:56:28 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [RFC v1 1/9] kho: split out radix tree tracker into kho_radix.c
Message-ID: <aibX8oS4toOVaCqm@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <20260605033235.717351-2-pasha.tatashin@soleen.com>
 <178083348873.1648214.11020626647820932506.b4-review@b4>
 <aiWYZhoSOAruIIM3@plex>
 <178085518028.1648214.13339471022594901667.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178085518028.1648214.13339471022594901667.b4-reply@b4>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mukhwrnye75mnuyin4w3oycakn6gsnnx
X-Rspamd-Queue-Id: DD5E420002
X-HE-Tag: 1780930591-710769
X-HE-Meta: U2FsdGVkX1/2/SizYOyFNGolKjltCGtobOGk9d9vkt+xkEAhJsfqEJV1+PH/Ya/ujzeHau3ZpfY385jauTxVrTv83HOcz4ClucWSge1jt6vMYUBxXrNP8yfrcryKbyzCTQnehq/uaQaEUakj1kg/Pfl+T2OOakCx2eQTpIRh6s451/3vwq7vCs7j5h8QJrZ2U5EHV9YHZjfrNywFVji05Kqp0Tn7O6w9IbjA+anbfJZDWUkMblg5/Cg5UXZagsVRqJezecLoA/kpvfGl+EUmYGGJHWK8UZ47czqoY2ghFRY/L2B5peZnKB7pdcwlX93a9ekZpFrySBR+o9Ql/FThSWhJAh1HpHPxQh2KrdeldJRTi4xxDO8z6sVflc/xyPkIHH4GUDexzK/ODB4me9ycVbQwv6o/5mvxsjCbXyYRZQnaHj/v197jGATAD8ZDbgpzV2nUUOEbmuDlEuyvZ5unUN83xi9xQ0VwNrtx57Y68csLVKfNocq6U38RS3jrBQ4IQVQLmBKnqYYa5BU853sbIGeV5iHdAC8+ruCauYt//BwIABcTLiUHdmByakzqVd4ATC/IfW29eSwH9ycOMVev8kHmp0/IpM2luyEojjg5fBFC5Z1Hr7nvLmXrr7wmJw/dPeGiqpVYewDW5wyuxC6cqCM4YHozP+KsOiysa9Bv0JT3gdCOuPUDz7RtQ6ppHkm/+nNauTn0BacIWMQeZQhReq1RgDxFOLh/+4bCBI7JOoV7Aqyk3k5Sen8fizxYckonQGIdfI5qLkiKuI9qJB2xl3GaQ5BOIoCpmZD1Z/p4T6PxknTtpThiY4mlzh6pl16AOrypJjxUjmpY1lTWISULkokQLpGDBdIkiZEN+Lqu7TsSBklFJ0OfimlVNJvxPxPxnfFUpJxxQrB+iMJET7GS2i/XrpHKPIax+sTQtX+TgLfSGkTDQWBC0DAgmNAc8LlzXkrRyYJoo+NLj3NDbcj
 XycQX9fm
 gGCMaZU0GozMUbGW+we0kZieM+Q9Pa5ezEOsmkz+HhKsuDLD+bdG43HqxgI3kzHmuuBnXT+lEzkf+NPxirJC7vcXq4EJZFN6m6XgCo1SR7rSzaJj52IjHHZzqzPHL0+j0iXCvL2GpnvxVgC0qkRQPIIpCryHzPprzaDunvh5GWqp+4GcvPfD+7BQDZPxeAEnaeGeY4zZc95Hr0kzLbyR8T6iGjgWWsp8Qdp7EdYZ557RUFbrVKbSkMOY5Z0KlSv/rhX6BLAivBJe5IDdEoNFWDoqaYmM7TuaZPP9x7FOmptgvLmokksRu35UyTPV6vdE+9C6Lx4YAjwrUKQjTBV7cfLV2L4M4UKxrBEOTmtirDC3RaX8+ItNiRVmYgy47vaNPVqZmdQIGyxOViSkXKXxpide7EwU+7RqUpv2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-07 20:59, Mike Rapoport wrote:
> On 2026-06-07 16:20:50+00:00, Pasha Tatashin wrote:
> > On 06-07 14:58, Mike Rapoport wrote:
> > 
> > > On Fri, 05 Jun 2026 03:32:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > > 
> > > It's radix tree data structure implementation, kho memory tracker is it's
> > > user. Please rephrase to keep the semantics clear.
> > 
> > Yeap, I will update it.
> > 
> > > I don't see much value in moving kexec_handover.o to a separate line,
> > > btw, the same is true for luo_core.o, but it's not important enough to
> > > change.
> > 
> > This is purely for consistency. I wanted to use the exact same style in 
> > the Makefile instead of having two different ways of declaring the 
> > object lists.
> > 
> > This:
> >     luo-y :=                                \
> >             luo_core.o                      \
> >             luo_file.o                      \
> >             luo_flb.o                       \
> >             luo_session.o
> > 
> >     kho-y :=                                \
> >             kexec_handover.o                \
> >             kho_radix.o                     \
> >             kho_block.o                     \
> >             kho_vmalloc.o
>  
> I mean this:
> 
> luo-y := luo_core.o		\
> 	luo_file.o		\
> 	luo_flb.o		\
> 	luo_session.o
>  
> kho-y := kexec_handover.o	\
> 	kho_radix.o		\
> 	kho_block.o		\
> 	kho_vmalloc.o

Got it, I thought you were against making the consistent :-)

> 
> 

