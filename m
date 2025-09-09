Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34BACAC585
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7A58E000E; Tue,  9 Sep 2025 02:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38ED28E0007; Tue,  9 Sep 2025 02:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DCF8E000E; Tue,  9 Sep 2025 02:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15ED98E0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:17:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB64313AAEA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:17:14 +0000 (UTC)
X-FDA: 83868704388.05.890E7BE
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id D155C4000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:17:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KTWVxTou;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUIpY/hUwvUpbS15H++8ZR5q5CpymLW4Dqai3m6j5P8=;
	b=vk19O6VdMUC/TOLd2W7/Wu7M2JSaLSQ6WXKamFdL20qtZPfL8kcHpv6Iz1s9Yit6jy3wyx
	rDGoZiAU7VUimCTDwf/xPCZYsPqxEIYqYPJNjPnvC7vWez6yZmoRNfPBw8Ef7oN8oONpJN
	ppMRUIn1ycHfOclQLxyuEy0nX8HyJ0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398633; a=rsa-sha256;
	cv=none;
	b=Ku3rYzXEeb1qdWA1/TT3AErScaG2WvW5wiuUc7UvNnQMYKAPrxzElyK2I8tyxD+42+/92j
	NNOnao4KBkgvvGClOsAEOzJaxv6UrqFDevHw0UDiIuRC387Exufvjvspv64WoTJSeEioEq
	+6KrQWyu+D+IMNZhIwjTB/sIeaRNLe4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KTWVxTou;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afeec747e60so973737066b.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 23:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757398631; x=1758003431; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUIpY/hUwvUpbS15H++8ZR5q5CpymLW4Dqai3m6j5P8=;
        b=KTWVxToujlw4tEjhCnbHL2pwzlDRM300Hg9hhU2JHJkkV9GuLjxcXDUP/W+4I5JeZQ
         T/PEk3Rm6c1Gwmh4xG49kmez/akz1DAXtiLzBCk7mQaFaHL2/WPaLG7bfzI+XyeNHaoM
         ybAQ/IQi+ZITlkuUOe48M0IZXOVyr6ZruGBEzYETBpfHWU+ztTcJ5IV8uZ5xQ6SsL7y9
         btk2fqgJZy7VaYausljUVg41w8WYY7kn9v1/CMxdy7jlRj9CDFy4mdbD7CKc2DEyvMQl
         LQV8BCJRa+x9oXhoRURovkDNPxZ0K7C6IHeMxa35pQFhomjks6vC7VBtvDbLO+TG4Pgp
         gG7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757398631; x=1758003431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AUIpY/hUwvUpbS15H++8ZR5q5CpymLW4Dqai3m6j5P8=;
        b=WfxtRqWStnm2Zz3kqkIX0kogyGEArNedbyZ9ysfG3qDeuJrfWu+OgCEJsoaIcYcCLH
         n2CUUDFOdJ2pv2BOFN6O2pPMeWPRQjE7f1zOPE3vDXpS2YY3xj0Avvv+r5Zg6oQAARgo
         h1UUqBKd1S6EebWsERS8H7sD8eYkwEdCrHgJCexZc7hSqv9hyspXaYV3ydFOYMvnf2Wu
         ci7sXEH3bUtZFzUVoHvGASGMyaB04iJ3GqTY/1U5zKukITZU/QAfj/CwYvAJOXqp0fmz
         JbCq12XLGWbTbZDahc+0y+0bgVNw3ao8y0J5UwT9SOh/MjsyxfCjHpH/pFC3vWxOKbqB
         Q6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEPHHNAch+LkROuK/cSglfqfHy5Zo1JIDv0/K7iHORO1lEif5f0YsIr62WGL0uHpiWUtbBSTk85g==@kvack.org
X-Gm-Message-State: AOJu0YwueTpAE4Kv9Cy2yaJhEdpW9Dc6+kMAq5VCIzVW2eQEsSzXtZ9V
	X8sXyCKaJ20snnIQypZSq+Gb0DXgDspOSLdOI96b5v3ElbItxSihyAeXl49gyAamirs=
X-Gm-Gg: ASbGncuOIBD5pCbls1cXUEinBoXSGCOcolDEcLHAJ94ZAMewevlEyGch8S5wmaNhkBp
	OAb77U3zpEqkAhEtcNVLgkr/afN53MTHGWwtOGkL7pJjquMM41sGN7uqXZDF0cxo3VCzS1QE2jQ
	6d97v/TPQnATQIfGsUYYLcNbBjtHCEpo5DpGrEkx4bfrtE926efV5rGZFkYDeqMCs2Mm+3T/UhX
	H8DGrnr/Mm2c9S5YkhxOB3ZNd063ZmHx21u6HfSTeWB/0ceVsddqvaHu1hOTMJ+oGzNXnhWytes
	gGCN3eNKILCoWHTtBUDLk9RlYogeMx4Yg8FcLeTMQbvm+V9hPWX+MpQo7g1EdfNURD0+uYhF1ZW
	IMPx3XFgVeiTxmLwOJXK6OdKp+hwDsS2unhjlSDEiOt8vNlXLCVF4rk0=
X-Google-Smtp-Source: AGHT+IGLA0K5P73dswsNYikfMMmpLlFqC26fbLtRsRpLv9nuaLU8vXgG0Id9f1eI3msFaa2JG7mMMA==
X-Received: by 2002:a17:907:c14:b0:b04:3513:5138 with SMTP id a640c23a62f3a-b04b154786bmr1150331666b.41.1757398631137;
        Mon, 08 Sep 2025 23:17:11 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b047041dddasm1412028266b.72.2025.09.08.23.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 23:17:10 -0700 (PDT)
Date: Tue, 9 Sep 2025 08:17:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Yueyang Pan <pyyjason@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Sourav Panda <souravpanda@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Message-ID: <aL_GZFkPp525rsfu@tiehlicka>
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <aK2/Vesgr9Xcl5gy@devbig569.cln6.facebook.com>
 <CAJuCfpHJMSd16j3ANrtJGVfLieHdeO_Epq=U9OKty3TV362ckQ@mail.gmail.com>
 <aLFKHGe2loD657fu@tiehlicka>
 <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zerazodfo2uu5az4s6vuwsgnk7esgjptygh5kdgxnb74o2lzjm@fkziy4ggxrxc>
X-Stat-Signature: trn8pkq16w6e5yn5uzsjjz1gpgaucsud
X-Rspamd-Queue-Id: D155C4000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757398632-437693
X-HE-Meta: U2FsdGVkX1/oTcRA8AOVQgS24/qhWO79S9wDH6S/Dvyd7oI2hfCC29tR3ybSJrnly6RJeIAbD+ual9RmFQ7mEe3QS56Jg+VGNCiOfbFkKkXLudfqd+jcUsJlLoiohDKlOwAtZFf8D+97FiisXi/IpiKCdAg16KtS2A14tWAW/xHaQ9VxkvAVBOyoLGuJkflyeIEfXR9FfZJWeOLJ/DZ/Jl/R08xnkW/yIwLOPtoUj5koyr5TFTipwKMRoxVfZQWt/+d93HcgvbeUrw2hy87xdifQ8JIPoM1+OPK+sOXUO3Zwq8nnc/CZ1pi69m0mzBmL293VrKkgp9vGMFo6frV/Ej6pWoCOOfgPDl+a5wnK4J6As8KFan19kZNGMo3w6FHJuowI5SAU1fOCjxMb57Ph/A8HOX2BLhUEK8o0Oc34BHa7kP4picYakCwwlxwNHvKCEPiVSnzHvGHAu6acdbo+ZFbdV2ERmrNZpe2da7uoSqbVxWuyBuvonplq3Mwrv4MtfnMBIpM4wmHTScokokpMxDEiKMAybq7fAq3E/+XwILOfBv95El1XiFdr53j3D8ILhWDK3lEPmr6RSw9xzMEgvqHbS+kKatpfd4fjdVchZ2wdbg4rq5UQYHmnnH4y3Icz+QtPQt6/0ocoxvW04WNlYIBs5thSntPGCVdRZydwPKL1vmd73dXwEgW597dmbdrM4lyEbcPsokT9YACfobNMWp4OBgWjKBb3NqQmsgjJmitMf813RrUa+N1smfsC9AYHpyH2rPY6awSOKMcKF2tN5/BsBgpslKRNl/cKFL54tPPIdewayAHJPrT8DjhmH9iOFn42qLLRiPtzFby8+Hpm/1EduHRf34C4hZsjFv1yCzp+AIEl14irkEBXCdKEVueGlPj/ukza63mlmJnawo8ZmIYe1UmKFH7gr+Uq37kvaCEZWbsmV7gGDrNK6eFSoAotfg3UPri/tsP6h2LVUIT
 qaplQ0BW
 bquPOt6ZuwBrpvsm8vh58KvkGe3bZQrFEB8+V5d2cgaHbtiZGPn0yWAkviraVQaQgpfzptmb0lEzKlNG9XDK+XIrzJ97Df6e6EKApvyo8e7A7/d/qngr7hVdgglv6tU9oHjyJPe02/W0GB8m/KsT2lfYltUfjK7uo1j2jRXUxAveIXl/Sm0EoKaOY2C4TkAvCo9Tu1+Rkb+Ku41CQs/jq4UMTqFnf9AlNgukUTSaWOb0La9UVT7ufPVtnTGAwUu5xYriGYlFtyLCyne43OCoBkeVWwfwW5FKtwiitxXbJBO9eTEhwG6a2pEzsgTiceQcCNeeU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-09-25 13:34:17, Kent Overstreet wrote:
[...]
> I'm not sure we do that very well at all now, I'm looking at
> __show_mem() ad it's not even passed a memcg. !?

__show_mem is not called from memcg oom path. There is
mem_cgroup_print_oom_meminfo for that purpose as memcg stats are
sufficiently different to have their own thing.

Now, what mem_cgroup_print_oom_meminfo prints is missing more detailed
slab memory usage break down. This might be useful in some situations.
If we had memcg aware memory profiling then it could be added to that
path as well. 

-- 
Michal Hocko
SUSE Labs

