Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B28CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805DE6B025F; Tue, 26 Aug 2025 09:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DDF36B0261; Tue, 26 Aug 2025 09:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC0D6B0266; Tue, 26 Aug 2025 09:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 58DC96B025F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:52:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0332F160126
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:52:13 +0000 (UTC)
X-FDA: 83819047788.06.3D2117B
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12291160012
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:52:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9Lha6ZI;
	spf=pass (imf08.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756216332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0RJ5MIbPMLBw2d/Ope4l99pa6BtCCu8eU768yu062E=;
	b=mdyql69hDM1KJ0Ss13WNHcgAOcuYBNABvtdsjN8K5fAr46u9izASBcsRaHN7cu+Q2nFIrX
	MWGsysfg6gSaCjvKCCikqBfaU2/AVupBkUQLx0E49q2taSCv1ma0TZKm0flijPKFvSCerj
	j8+MsauitW/uqxY9GIjHej7STwApdPQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k9Lha6ZI;
	spf=pass (imf08.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756216332; a=rsa-sha256;
	cv=none;
	b=tgL71N0JS/7am62x0kU/61BZAZzVtFlseUyG0Z9rzxfYuOYZjPwMlNqcSHnXgAEbBF8+KO
	R4wf0ZPofhYPJlEl8XFCHsctoZiep+6de+l2ohovyRDh0ty/xP+rhvgXcQDTMJTaZ4P5d4
	r7FgVUmBsgoXCalfN0HLsW742Tggstw=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3c380aa1ad0so2860388f8f.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756216331; x=1756821131; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=d0RJ5MIbPMLBw2d/Ope4l99pa6BtCCu8eU768yu062E=;
        b=k9Lha6ZIAqn92yMvFV+AGtMJPi2Hoib5dxle+3I0vlpLkbR2r+dQB9MfbFOP8fIUz1
         bKSLNihGLcJxqG6wxpoWGRJ0vuMuHMNLDYXfJdegOMN7uNHJxM7auvSUaGl4yDcV7ZtJ
         ObNyfZhOm8ci797Fg83q/dvvFpyFH8/S5W0HGh4C+Tf2lyxD2qDHYCZqUmcNIVM3R9rb
         xs3yzmwxCQl/IsZqAhPhmJmHKLZ03QGnpGWmVQ8TNENqhLz83rImTadf/nOZiGYu2s6T
         6Rec1B3Nc4slS2cF1kMdb4zHVM7fC3xXBJIU0BGrNBMQz2M/RMfl64qRy+CW5BYEFqYk
         8EOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216331; x=1756821131;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d0RJ5MIbPMLBw2d/Ope4l99pa6BtCCu8eU768yu062E=;
        b=SD9ae2uCjUvHIKnYGMbldDY/nnv8vAuurI9EnI9BCXBHuN+mQpTF72cYoweupqWge2
         DBI7ozOYw0cG4LduK0AHeCEerM5mvEVU0CWAalp2YrOfy0XHb2i/OITSwEB5/ApCohp7
         3HtuFMKK+402xnzMamYc7VbUVCv2Xm03MN4pL0ZzSUe1lvnkn9RAka1B2GApL68doL/+
         huScGdsgoJAb3p+LeAoLbxB/+az7Z3Q9CSeihpaeC1YnboxU3IRKMRiyMW0hkZlzkIa6
         OEyTFdoxjdhmiIE30N5YZVTHXHsFJqqDjHzlA9zDmZ75dp3D3lnkfWkUmOqt1627BEOm
         woRw==
X-Forwarded-Encrypted: i=1; AJvYcCVQZlc3yhY4fd1AA6SXoggVtfkxYub1txuj163i0rWW+xdDuj55fJOev1ctP/hxa+DvOlj46zN2Ag==@kvack.org
X-Gm-Message-State: AOJu0YxhTalhPpQfvhJtn16hO66R4CQ8KHOSsVCTcta9zvXieSHfTz6c
	2C5YAsGDRg0IHIh4ncHDAJMW+1cnaxFfyhWY3jBtpM0nzVm9wsKf1zM5hA3RoFmq
X-Gm-Gg: ASbGncsQ+6DS7KxaTs4EAnYVWx8Z8Tt1cFsjRUK2EcXcZnq/voC6a0ocCLEeTVqGAHH
	ENM6i+PT/NwP7vMMjZESJKbFCpuvyxFfWj1KGpS6BuYp/ecPSbwLLezJnOQcBeN8Y/x2Rd5om4s
	iMmh15vfzdG2xmt56ZjsodDfriKkMSpeO4k+3bF6QTHajEpPPvvgJRMgt+aj7sPn6foA5dS2ddM
	foOVzxxaaHOkbuwHIdjyVet1W7WA9DoZM/hgEIrjtjljW8GZemqcg7KYCJwXgSGKL3VngB3KqDR
	MMAgvuahoXGcwBM95McuL8V1GZa0dXqk2YWxokAeXjYBDoImiScIvMOrBEv2x8OQpyh7S3VMcq6
	zrgoonfSUvAUFl1OLNcDTmD8CRMgFIC1blHztmA==
X-Google-Smtp-Source: AGHT+IEjp2yGDtvnOY/+wJx7BwMFpeVlyxftPjDY2xU0V+FjBiKh1w46T/k9BNcNGen6Dcv76DyO7A==
X-Received: by 2002:a05:6000:2411:b0:3c7:c594:232a with SMTP id ffacd0b85a97d-3c7c59427c6mr8426437f8f.19.1756216330408;
        Tue, 26 Aug 2025 06:52:10 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:4::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b575929a0sm150127695e9.25.2025.08.26.06.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 06:52:09 -0700 (PDT)
Date: Tue, 26 Aug 2025 06:52:04 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <aK28BEMMelOAMi5U@devbig569.cln6.facebook.com>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <CAJuCfpFKNQrjtoctVt0N=r1cABeyPjpwrzP6M=OTpp1Rq_0QaQ@mail.gmail.com>
 <gxildlinmmimk7rd4olsz4rstsiapttbjbtbtzbekrmfxbvuhh@cmio2ckbyzxn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <gxildlinmmimk7rd4olsz4rstsiapttbjbtbtzbekrmfxbvuhh@cmio2ckbyzxn>
X-Rspamd-Queue-Id: 12291160012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: is3wt5jt3dduirnpmr7fuzwpmtr73e5j
X-HE-Tag: 1756216331-241410
X-HE-Meta: U2FsdGVkX1+LeZyhoH27CM5hw0+toZeyuPqNNL6Bxwdn8nV+gaoISTvSB7/bqbV9A49wLeqZ/lDEC4SEuKRywtXPWTOpNUHzDGKi/Ej+8n6hJ7g0R3GieZyyyMtIaPIu85j66Y3pNgtGvzald269OZLFPcWIboB4ZLoNo+ubaws968rnKk3tA8GXDAt5M/1ox8zdwdg0l41FesptIKrfzYZcKz62G0a+NNTAL5uUWcXTD9siCd+6bFF1mxNCE8IkzQgYvst0Z177rpr8jA/mZvvZbElaaVkCAiJHtQt5SMMcEAp2d4syGtTaCxsOgjW/DIxu57hwdQ71aiu8x7+8MXcbtV5MT58iTM2ktkP+YDRHcHn1lN5t13uWF3mpVon41eSGkAuUaG2IOROLL9e88KB4ELO2l3FDyJo7SKNp5PEAGnMCEca/VTFbCVDGnCew4VQzWmqocBeSkOh7xxw/mJwoMhSv3cY0vPIWPPEWbJ47pvQ5YneTJyFHR0nHpv+xg9Tslm1isiKMuLPBRjYrLah4Fluggkxb1wZLBsrhJ77o2qGUwrihQxyd1FNkgF4Ar0R+9s1iwuUh54VEadAN0exC0QazRdfIEVNTO/oZxgOho5cFli9hP/xiey4qT98Ft9s3L+GN/Ggo0S9bARC5IGOSEMIKXYxkYeRHGxu3ZhIIG2RR/3rgoIKZowAKjhbp9MvRGz6vcXZ7zfaV7v8JUztVCJfi4E3uM2Q2AC8hqMZdKmNVlnHwf7+6DuGRMsSSMMR5G7rqLc3hQHcfQi4QIGfoLXvMCeJvu9YxxhA1MyIAses+i63f/hw4R0iaPTrgQvSbexmDX2bYv8cOsk4jq8E5OE7JwALc7+upGjoMPMN8Mf72v0NMycZ3q4RN5s43BmWpPCTAvLhOy2AYsE+5IcR+91OW0q616XUI6hl2RBUBpLiW7xfYmFFbNbQFLWsOjbOR4bJ7IxtVd+/UL6O
 3QQc40KD
 jdxZFAx9II60DpetyQrbquZQHUVs5phltq947HXiDf55cb+flXxNco6Bj9wux7k0JTCzyDoOgg8i/20zKSrkaiQmsRdY4lfHznLPWvt0LlKSTamfbI4Tslxot1kinH8k4ZhJrnhH/3932u8BOZmaGKrhwFv4+Yh2U0rUMlGU8I+HOZgVvnOvsZtff6ErKTh2oGgpb6xodj8VOBjfE0b1LJ8rwVCKtJu+i7WcecLBXw9gsiiZaGGk76C8Ji0ReHLg6mW4J12klQXt5P8bcjhzY9G8CNBYUR+bXxyXH2aI4HknDndx9XgLJwH+uZOOeiQ3e5iKWRIFWciRp1sY2BRHYEWGje5HOTbEBrFDmHhrkyRsWdHXXaI8dLwDmkjmOg7Zh4KNwFvT4tUg1gDDKjjT9ehyxeKUaa0igzBN5qOesFPMhpEVA2S/0OFXg6venkQR+hppnprVwW/oxdZlURqlkPsgqjMPc8OwJgNlZJ/Bq3+hXiIXtsCXi/6qKNHHVUnY9KS1GgIEVLi3Z5YGkVpt9vLLLwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 02:26:42PM -0700, Shakeel Butt wrote:
> On Thu, Aug 21, 2025 at 01:00:36PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Aug 21, 2025 at 12:53 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > >
> > > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > > Right now in the oom_kill_process if the oom is because of the cgroup
> > > > > > limit, we won't get memory allocation infomation. In some cases, we
> > > > > > can have a large cgroup workload running which dominates the machine.
> > > > > > The reason using cgroup is to leave some resource for system. When this
> > > > > > cgroup is killed, we would also like to have some memory allocation
> > > > > > information for the whole server as well. This is reason behind this
> > > > > > mini change. Is it an acceptable thing to do? Will it be too much
> > > > > > information for people? I am happy with any suggestions!
> > > > >
> > > > > For a single patch, it is better to have all the context in the patch
> > > > > and there is no need for cover letter.
> > > >
> > > > Thanks for your suggestion Shakeel! I will change this in the next version.
> > > >
> > > > >
> > > > > What exact information you want on the memcg oom that will be helpful
> > > > > for the users in general? You mentioned memory allocation information,
> > > > > can you please elaborate a bit more.
> > > > >
> > > >
> > > > As in my reply to Suren, I was thinking the system-wide memory usage info
> > > > provided by show_free_pages and memory allocation profiling info can help
> > > > us debug cgoom by comparing them with historical data. What is your take on
> > > > this?
> > > >
> > >
> > > I am not really sure about show_free_areas(). More specifically how the
> > > historical data diff will be useful for a memcg oom. If you have a
> > > concrete example, please give one. For memory allocation profiling, is
> > > it possible to filter for the given memcg? Do we save memcg information
> > > in the memory allocation profiling?
> > 
> > No, memory allocation profiling is not cgroup-aware. It tracks
> > allocations and their code locations but no other context.
> 
> Thanks for the info. Pan, will having memcg info along with allocation
> profile help your use-case? (Though adding that might not be easy or
> cheaper)

Yeah I have been thinking about it with eBPF hooks but it is going to be a long 
term effort as we need to measure the overhead. Now the way memory profiling is 
implemented incur almost "zero" overhead.

