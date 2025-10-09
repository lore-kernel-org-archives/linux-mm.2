Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 859CDCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:38:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3358E0015; Thu,  9 Oct 2025 14:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74098E0002; Thu,  9 Oct 2025 14:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B62A18E0015; Thu,  9 Oct 2025 14:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0E3A8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:38:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58E8EBCD2C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:38:26 +0000 (UTC)
X-FDA: 83979436212.07.6F8AEED
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6950220009
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:38:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a8D7hYty;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760035104; a=rsa-sha256;
	cv=none;
	b=0NFmGyoLzTgli33AGzTD42xs3ZCkO3+HsTZGQRfH4vFgliLw1T/WOhlq215/JTtNaY/3Ia
	oUwqA9WENZmN5hCFJMpp5WM/59lTeGfmtFs9DucNBt0/ZouAe51ovbKYiQFzULczTHwJoD
	VVr/a5lAFURuiL44ZTVVTEeqyMdARBA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a8D7hYty;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760035104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=81ILHOUYQAEk70D7TUtGk2AtcHVEKY4trbt5HGWeKE8=;
	b=Z2a2v2g+i5ODp3c/KrYuV3uS0qbTr0fVU/xR6h7BC+Ok3TvZ2zfT18dDGTOCCmYOJFLuoE
	lsFCAfnCZhG8e9yZSaTjIsIrxrudw1emrb9DpAcdE7FZkZJaVsULs60QEvbSOCKlrBzZjv
	Rdur1IZE9khsISipaWUVslcd3Q0piD4=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4e3117ea7a2so17557181cf.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760035103; x=1760639903; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81ILHOUYQAEk70D7TUtGk2AtcHVEKY4trbt5HGWeKE8=;
        b=a8D7hYtywAP902PXs/UfEcoehB7K8q6WbYib757B3SKGw+JH+/Q2ByeXRFHyOTVANV
         ZDJTGV3+ojBNvZ97YctA4fcZU8GJb+3pTd/vaKgTAXM44PjzzQiCrOB4OBdjRzxj+HEt
         GVjPVLE+/rMZAwJMJS/65tkoWJziJOvnWNA8SUM+dGe1M0JvB7O2f2AnD8zqktrPtnir
         gl+FN0yYMJ+Xs7Js2/cdK1k9Ld16w2QXBOYI/cuUVaTTzG7RRZhxu4SfjQ3oKTt0o0nO
         et1t4X8xeQwKIvC0rLYKBXDVmJMdRz+MaRMIWsd573VZumvjCMC8TGVKDhfgCaHPjEze
         ssYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760035103; x=1760639903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81ILHOUYQAEk70D7TUtGk2AtcHVEKY4trbt5HGWeKE8=;
        b=WvcXsGsdEFjQ0CZltZHqkLNowEIx5Ga6mVP9iRUsmo8iOxsR/w/gDggjbZqK0qQfxk
         rBpaBMskgwk1srLPzlLuJX+sMZ6RX+D7F24cbdcmjEMot1S+CeOn+tSoO0Zwqa3AraQI
         xMQAGRlzd3JDLgm6UBXoX3f8TQn2rjhylb9BoY7y9N4/ufbc+AjdHrjOUO7lCb5ckTDb
         X5eua/WNZZ1b07ymn+XdcGOvbcckxfEB/q4XAcMoKoiu7wOrVKbDSYDnDtDNNC4NNgvx
         MuIxRJWI1yMY3CjYnGcQqZlPclMscaeFabeWU0IzdnnpENikJUVyS/+MIXSl/5F0+XQe
         n3Tg==
X-Forwarded-Encrypted: i=1; AJvYcCVHxcbVmDtHjqdxh0a/0bir91xFJcquud1qe8N1Qfy4mQAm8KOEnt1FWb9q8EX0drXubS+IBnyMhw==@kvack.org
X-Gm-Message-State: AOJu0Yx20KYKZJzJf3o17G/fIfiFWNInyKHdTvqrNrQw+DLXoLAJhL3I
	4uDepIgKAZH5146MTIGp1qIh4ty9KDj1/r4E/b4elJLMk+fdRa8LO74tiucFfKVx/mCn2VD6nyR
	MRaN8aitbBB3kcnvnzJzqJOd+20rpVNi3daxeRyp2TQ==
X-Gm-Gg: ASbGncvHfgSS3MDMJlayMGwKeyQihvCOFUt5YV5LZO4urlnwPWQJaUzy+memyB3rLVt
	3pOFrAMlF8tqrGAL4JE4EzuAZuc99jAxhZwhCUEG4Vimjzt/+s92te9kNWSuwAu623aHqCWLgIR
	Kq74iecr6s7e1UC76TblnbWoe+tIgZgb7CIAYhyf3tYJiphpCQz4KyimksscQM6nH9zaxiIqK1t
	Z8G/Oiqexazug5QM6+Luh9lkr9W
X-Google-Smtp-Source: AGHT+IFTvUtN/rpWG7psFmkleFQat5OJKejLftUiIf/dP75zdni12r9jj+HSaQKLJe6iZf61h/vhuCDqOsTOwxoEzRc=
X-Received: by 2002:a05:622a:5517:b0:4b6:15d:b3f7 with SMTP id
 d75a77b69052e-4e6eaccd340mr110183671cf.12.1760035103219; Thu, 09 Oct 2025
 11:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhSP=ugnSJOHPGmTUPGh82wt+qnaqZAqo99EfhF-XHD5Sg@mail.gmail.com>
 <CA+CK2bAG+YAS7oSpdrZYDK0LU2mhfRuj2qTJtT-Hn8FLUbt=Dw@mail.gmail.com>
 <20251008193551.GA3839422@nvidia.com> <CA+CK2bDs1JsRCNFXkdUhdu5V-KMJXVTgETSHPvCtXKjkpD79Sw@mail.gmail.com>
 <20251009144822.GD3839422@nvidia.com> <CA+CK2bC_m5GRxCa1szw1v24Ssq8EnCWp4e985RJ5RRCdhztQWg@mail.gmail.com>
 <20251009173914.GA3899236@nvidia.com>
In-Reply-To: <20251009173914.GA3899236@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 9 Oct 2025 14:37:44 -0400
X-Gm-Features: AS18NWCn4swK0ST2nIuzLp0_IoWDyMPKV38mC4btlFHmbHQv1r2bdrSfddLjGqM
Message-ID: <CA+CK2bBtrkdos6YmCatggS19rwWYBXXDLwiUWmUrs2+ye23cXA@mail.gmail.com>
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s1fr79x9coorwaz6o36xqwuq4ddnbrtm
X-Rspamd-Queue-Id: 6950220009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760035104-806450
X-HE-Meta: U2FsdGVkX1/X58VskuZuLT8Ll++pzvGerTjBR41W3BTLvonbPcTvb1t95Gjg4TDBvJDydj/eJCSn0htDqxw1AzGZV7t6JRN7ZmCfzIZtSXOzTf1Kz/PuPn5UoUQkac5rne3MFRceWYcVpkH/dhdc/c2ONb2Iero15HG3wbKj5pWpp6hkRZRNoDhDBqKnBXuZDS7/TV1TbgZ7ysncQwNgiDtHNUGLGra0YRN87F53epOm3QVj+iVok4trk/1g7KGszgEVowzALbOYrwz3YfN3+bkukyAhQKJsOLMSfDMr7O8Y/WD9kYZ/piWt1kikXeff5e883hlJ4HpYsf4Fc6txavDKs6jkqhG9r7Tm1tFOdtpDFvQiV1++XVPRMfvP4lKXMbc+K5HcxhQXtQ1pGhCN8h6TPDZ1M2o3ydVee59cI7TRtT022YIvnl7dd4qy0P8LbCc4Hp7C9swVbLBKdyxRanFh4bsmQqz0afj7PK/3SvKTEu0AbVqFot0XoNL2mREhs8iNIQABt9xARr5pXa6tzKd4ASOHFqVvJ02g3Q3TgKD1jy9bCD15xU/tZrCIdPsfsqUlS6AcQLVuDtXa3hlnCxsqVXA8HmPfbjzVwgOqDqi38QzOdbxkONNvipbb+H43hyGmsmyV+vVWB1THsMhCqR2bJjmtM4y0a3wM0CoTT38XTDzr0yDdjt/ymp/jgbn23KdlDbVfbI454Zi0TxbHoa9+VHHBF5dRBRprGW+9AQOacOiPsL6WUimTVrlIytDy3C02I9BP2p96fpkyZ6jpy6fOgic5ti0HKnNiRlk09Od4rxFCTqP4O95N4kYnfZQaTRh0HV8/8e9+dU3ksSsQ4IfroPXN0Pg6zp03LA6sK/E9fW3AOolWMDrOCYX2SrZHptNKSG+OqNE/hr9gvrIeHtwe8Ly6wMMgqdR7etP6cv1BYkrAiM5x//6RxQm+lFEt4gxevYHCjF8dttsPsZz
 5ViKLUoX
 eV/AMtDgB8YxDk/0iJGtxiJIKlCddWgPSzRzVyfCtteEjPFirg+m5sqqgjfDOHGLauRuJ4gF9fsrXnW/n2JO9yWGJggNDBM8S6gtT/1drrKhIB8JK3RK2GSegR7doqyXASYo1N/1d0L/IjLoHVpHU0FUzMPIeCDcEA1zM9QuuxVS7TA2vfx03d0Hfbh+KdLuDgGpCST/itbAoc39KYqRJbVO3kKuL+TpykCNmqLNJqsRNQ+rVymQBMXX1BAJia6yVFGbZp+HCmD5L/rz/2+epF6NJVKsPdmBq2u7/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 1:39=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> On Thu, Oct 09, 2025 at 11:01:25AM -0400, Pasha Tatashin wrote:
> > In this case we can enforce strict
> > ordering during retrieval. If "struct file" can be retrieved by
> > anything within the kernel, then that could be any kernel process
> > during boot, meaning that charging is not going to be properly applied
> > when kernel allocations are performed.
>
> Ugh, yeah, OK that's irritating and might burn us, but we did decide
> on that strategy.
>
> > > I would argue it should always cause a preservation...
> > >
> > > But this is still backwards, what we need is something like
> > >
> > > liveupdate_preserve_file(session, file, &token);
> > > my_preserve_blob.file_token =3D token
> >
> > We cannot do that, the user should have already preserved that file
> > and provided us with a token to use, if that file was not preserved by
> > the user it is a bug. With this proposal, we would have to generate a
> > token, and it was argued that the kernel should not do that.
>
> The token is the label used as ABI across the kexec. Each entity doing
> a serialization can operate it's labels however it needs.
>
> Here I am suggeting that when a kernel entity goes to record a struct
> file in a kernel ABI structure it can get a kernel generated token for
> it.

Sure, we can consider allowing the kernel to preserve dependent FDs
automatically in the future, but is there a compelling use case that
requires it right now?

For the initial implementation, I think we should stick to the
simpler, agreed-upon plan: preservation order is explicitly defined by
userspace. If a preserve() call fails due to an unmet dependency, the
error is returned to the user, who is then responsible for correcting
the order. This keeps the kernel logic straightforward and places the
preservation responsibility squarely in userspace, where it belongs.

Pasha

