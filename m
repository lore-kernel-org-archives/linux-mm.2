Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D5ACE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530BC8E0018; Mon, 17 Nov 2025 20:08:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5082B8E0002; Mon, 17 Nov 2025 20:08:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E1A8E0018; Mon, 17 Nov 2025 20:08:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3038C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:08:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6276586A4
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:08:55 +0000 (UTC)
X-FDA: 84121943430.04.4474DAD
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id DBCDBA000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:08:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TqdwJKNr;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763428134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHz3ZSch0j3icwKric4qmANXVXIVVUz44Th0hsI02rw=;
	b=ts63Z0wCxLkmBrZ9Ew2phCWUTb9JozokmpaYkb4F5kY8R83oWp9bq4sA4CXLLq9GjogbK/
	urGqnI8PPjQIWXewt2fIdxqLkWjfhcnOSsrseHMXDntXRJlRHPGU6NWyBE395RrsiFrk6h
	Qm8FFwfqCc+2Z03utjF/yJGHsvVN1HM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763428134; a=rsa-sha256;
	cv=none;
	b=P1drskQ4vM5NtiHQN2LZqhy03GLQlHuwANEVpvIvxac0b76LWIhV7OpXPOEa0BOM5tJ/IA
	1ZijCG8RycdQcla2NMAh9FSIZxbvGeXpHb5pWBNFysWZ/XmdI6SrQ8sHojrTPPh3tBK+Mm
	NHMy1EejVjtsB5Ai9oZqWp27drNJWow=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TqdwJKNr;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so8291564a12.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763428132; x=1764032932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHz3ZSch0j3icwKric4qmANXVXIVVUz44Th0hsI02rw=;
        b=TqdwJKNrqB2cuTo4evvV9uExdvmi/AaC7tH8BPRY9itPCcZKEIa/RhR+vysTAsDmwO
         ktZ/mUVfY33txhbGy9xp/yc4muC3wAKJdwugvHmfJrDLxjJCHM2LNFGYBLlz1QNnsUlt
         AAjNK+5lnbpI4k/oE2Jzfglvp/lMmfIw2+h0MFImoet/juST+hDWlKmr0kX4zmTMjh8e
         NgxNbAQM8KmF16n+HOfbob42NMh7k1I76v1W25vQYm9SFl6dUO+1rWWpa+/MfducX017
         Kjdr+oIbJq3N9L5bHZFgusRK0JIHKIkz+L5+5MtxoPKF6DFolfoJZVXlOIvpBCqwan/h
         XnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763428132; x=1764032932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PHz3ZSch0j3icwKric4qmANXVXIVVUz44Th0hsI02rw=;
        b=Lf0gfl5uSN+RsOC7TzMGC3awBfZ19HIAapovFu2MGekT6fKQ1GpJihCuzG5sLVLqUq
         pIjQtnKgMhtgQBdhzCcZXAejvFahWbbw1CkI6wjj3fCkAC6ED3H3mCrikZqOuNcf8Emu
         JWYGdXeqoTWtgyzb1tqaswjtqMpySy28NQ6OE71cA8ADfpXnczNYl13wEkW7C4TKfzdN
         wfMaWKIxOXWOUJJmLZzuk48UzU1M7RObQYam6uu1O+eb7kDhyAR0bCiMroKJQ8hvjl43
         6McbSuqFdZueNCtk82d8dgfrgPvCkc8me06scI9PMITEF6uSnUKs3/Rq0fG/wfnmw/Qi
         2glg==
X-Forwarded-Encrypted: i=1; AJvYcCU9FgwYGPXV0xP+tACKUu4RV5LnOnHyCvLvIf1OEJZ4jJXRPLSkjVUaQsMLd4Q4zyNPf5HZYnszMw==@kvack.org
X-Gm-Message-State: AOJu0YycGMSxZY/oEIt8p88v6BFn19G85pBptF0J3JbcTYIXmFOxMiK9
	U2hWoYKwSK06HZyfeZgwyI2OmGcwnvEAJZWvnSp/b07yhIJwItGYxBH2Sl1G0fLA48npENoZkRH
	xkOfaikb16g2MVFfRugKlymFsiZ8EWYK4g907nZxcjA==
X-Gm-Gg: ASbGncuYi/VeQBlzgFVKLpmspfD/wM94Do6w3cAK9/YemRD8kJC9rIJM49tjBicu1Ft
	B4q2uBtYW5XxLvGnObZxtQ2K2HqPslq9zxqDLtkiI/6+wY+f7qNtGfk4KaxyXAhjnftaxFE3BDo
	yWKaIXgghRSKls7mxcsKTnsS4HnbK9h8RJlVdXFert/l6tiWmoZ+HrJMEI318s8HYou/JMZtF9j
	JIGX2Iy6Km9vD3Ucf04AHPOMluUGdZRWo8a8zxhKkVEtfOaC6dKytsCh+11UTI8yFqBOHgy62Nk
	sl0=
X-Google-Smtp-Source: AGHT+IEZfZGWJ8aSWhQVB4jEcLruJ8I9XFSeNCTF/yy15o6Dh+TeGJ/djBXr3AHvYW0X+PFfQd3I51m6KkeXZLCq7a0=
X-Received: by 2002:a05:6402:524a:b0:640:c460:8a90 with SMTP id
 4fb4d7f45d1cf-64350e06a53mr13323263a12.12.1763428132223; Mon, 17 Nov 2025
 17:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <aRu4hBPz2g-cealt@google.com>
In-Reply-To: <aRu4hBPz2g-cealt@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 20:08:15 -0500
X-Gm-Features: AWmQ_bk93gbIXM7C6K1DzdPuJ9gaoWasB_RAHgan8OE5p-hPDMrjsz6s60y6azk
Message-ID: <CA+CK2bD2VDTP7dCaebAOVpNmhyviptRbqLegW_FhAbHkMeN-DQ@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBCDBA000E
X-Stat-Signature: hj1cqehmkdg3sozxwdgpbwufwabqg4bm
X-Rspam-User: 
X-HE-Tag: 1763428133-962089
X-HE-Meta: U2FsdGVkX18Hr5ORrWKR1E8wkcEHWyxO+1KW0De6p/h/SeKsbz7kYOQRpv6J1nLXVc0nCTQZOULJM5XlFvEVTIQIH5vPsewzSjUGPdf3XltY7weaSaoNWenMpPoLizZqegIuVowzTu31rp1/eGqd7cFjRe7JkVpwRzUsOUa6Xyqm1OgN4JMHtbOtnZUOiLIzbTqTf5OLR019OTOn7Qhs7BUqT0vBCNQ4v/jv8HU2sk9bXnl9ipExw2ZKe+4MufynO7ivz1wItewRGdlnQiHpxpNvrJKb47bOhaDRhWeMkEcqw1CZ70hiTBSNPlTEdtmZB6F4l2UlpqbHBMb7q3fYBye0q/ve8beuKD+FRGtSeT5DA1TzbYj0ZW/ZU1cbentJcmJ/ytACB3GeHB8oSlLwgjOCUGwEzhphjdaLGF2XZzQ7DhoG29Z8WOaqQ73dRMnj9oc4XbE2uju4byZ97VRMrCaU2ey3mVUu426cBd3GrrccQ6PW1YK9Gi5+HO2FPkM4U49WoeQaZPHxAWKFp+RSbqO/TovvqrNZ7v7guii8e+HaKoDne6aO/jk+x/TY2vYbR9sMta0VAb6cb4Clh1x+vo4HOSulFV9HrqXS7Pk962kz5y+NO+m4NLEHyKUC0i774EqIYwNYHWXUcbfeFVsON3QLWjp44BQtW5iiFwHxpG6SqMnJizRafdIjkYbOH2O/7HagXOgV9pCEV3gdAHLrLJiYvfyw8X4mQLt9DPy7Ijw8VxvHNyoYgkupEH7vo61IL+2AKZS1Y5ldWo2tc+BndIdEA5/TEu3h5OmtnTMoqVZGX8hkigCuhFBtQOWRFneKEafEF76yYEUCzr2cDbD5AooYpgS9tXE/eM/A6HK6wL3G/vOA7IyrNMQgr3ynvVvBsZJIJUNiUlwWlgdgJQYQ7LC2nxSGVJ8VJNs0WLH8FeCNQHp1zUdZFlxm1CxPKR1n/qPiXPAQQhKDzDmxFnk
 tcc2K0a5
 oDBcNowZ5PC50rTBDJ4yXAxkahCx2q6XaUtMdvhsxboiDbOK69g7wwFSADbH/hK/BH+EoDt2k8cHXVHArOWWVqHGZkU29YGw/sfoVTPXoirD8Ej/3xhYatHUQJNQUOB5Ux9kzvKl5RjOUnWuQmg7Wi8VE9SyCs0gfwHNTbthuW/Lk5xUCS/wqcVCqaLC31x6mR33fRS4BR8lLwR1grY9z9U4iKPWK8szKGHetKvKYGh2MvgP0W3pq3Xp/lSFg+bXB/m4FlSrHVrKlVzxq5zNaIOMtHj2HYflFQqjo5dYJyxgplewcy/Ht3ouSHlSHd+oxmjKi0nyFRNpNZuvKvbHz55eMa/vOMUwKWPTVTDwuF1Cj6aHnNP4JJ7G/uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 7:06=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2025-11-15 06:34 PM, Pasha Tatashin wrote:
>
> > +/* Stage 1: Executed before the kexec reboot. */
> > +static void run_stage_1(int luo_fd)
> > +{
> > +     int session_fd;
> > +
> > +     ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
> > +
> > +     ksft_print_msg("[STAGE 1] Creating state file for next stage (2).=
..\n");
> > +     create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, =
2);
> > +
> > +     ksft_print_msg("[STAGE 1] Creating session '%s' and preserving me=
mfd...\n",
> > +                    TEST_SESSION_NAME);
> > +     session_fd =3D luo_create_session(luo_fd, TEST_SESSION_NAME);
> > +     if (session_fd < 0)
> > +             fail_exit("luo_create_session for '%s'", TEST_SESSION_NAM=
E);
> > +
> > +     if (create_and_preserve_memfd(session_fd, TEST_MEMFD_TOKEN,
> > +                                   TEST_MEMFD_DATA) < 0) {
> > +             fail_exit("create_and_preserve_memfd for token %#x",
> > +                       TEST_MEMFD_TOKEN);
> > +     }
> > +
> > +     ksft_print_msg("[STAGE 1] Executing kexec...\n");
> > +     if (system(KEXEC_SCRIPT) !=3D 0)
> > +             fail_exit("kexec script failed");
> > +     exit(EXIT_FAILURE);
>
> Can we separate the kexec from the test and allow the user/automation to
> trigger it however is appropriate for their system? The current
> do_kexec.sh script does not do any sort of graceful shutdown, and I bet
> everyone will have different ways of initiating kexec on their systems.

Yes, this is a good idea, I am going to do what you  suggested:
1. provide stage as argument.
2. allow user to do kexec command

Thank you,
Pasha

