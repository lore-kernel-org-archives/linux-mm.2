Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B6FCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF528E0009; Tue, 11 Nov 2025 05:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FA98E0002; Tue, 11 Nov 2025 05:22:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACA38E0009; Tue, 11 Nov 2025 05:22:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACE38E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:22:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 378A01A04DE
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:22:54 +0000 (UTC)
X-FDA: 84097937868.29.57EDF12
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC5A6140003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:22:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=VL4TfpXZ;
	spf=pass (imf26.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.171 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762856572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr4TOuugTT1EseGcVB5iZB82tbqvLcivaLR74+txrKo=;
	b=s41C3Z9Bq13XHQbC545xqAeDpTcBUWDxwvXkBbfQuUzhfiF4kI2AnvcmVYU2hQsS4Emimh
	wqZINi8kdUqPUmt4SXBYxW5G6FivN084hXkhyx1KbMEfrsIGWxokq+Kpd+g10HXhBng5RT
	+6irfAqY89dnX/M/xNrmexsClofTktQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762856572; a=rsa-sha256;
	cv=none;
	b=j9YauTaMiOpedS80l2RIw1TC78L+UgL7gsOV19bGs6r1YFyFLDeacgPjlJOcNPeRE38sLp
	PnV3qITiClVwmI+L0vwq7Gwum9re6kWgGnHOsxbudqqz+x04Z0Otmw8B0kvyJS5wgs2XeE
	efa6cmwXqPJUhXWY4vWK7aKv+K6y8T0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=VL4TfpXZ;
	spf=pass (imf26.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.171 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4edb2eef810so32516011cf.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762856571; x=1763461371; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Gr4TOuugTT1EseGcVB5iZB82tbqvLcivaLR74+txrKo=;
        b=VL4TfpXZcrVF4fpk84Q8XDROdfO0Vf3+Gq67gMcNcxA+l1EkFTcTCOHrOFnaVTv5TB
         8l39ndcm7UrNaAugBLHOexu6hacmeQJU5r5SznuJfQGKeNKTCZEN5DIMsKbcs5P40qn3
         sai0AdMLG1QtNy0G5w85LaHsJtGPqexsOPYxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762856571; x=1763461371;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr4TOuugTT1EseGcVB5iZB82tbqvLcivaLR74+txrKo=;
        b=JhEGQH2+p9uJTHbGrZIVQHKy5zwikBPW+CkkeRLKvcZVUmsY17IsZAzwbgutlgVLgO
         jcnQy52fa1iMIY9w9vRJHhaUHjxx74AEAMxQlYf+YiBUKmYXSaBgiNSoEHcmh32lglVa
         KYpH6x/V/TJduKxXO/duvCGYpx4p2XYpeC3uqkAT6yE3eH7I5UabHkqCtGhQfsN3Fljc
         Ub5a4w8VR36s4zkRRLMu1uX290bKJSgaG7yLpf15mFXs/+/MxSyik9xq4PH7Ouzx23rM
         FvK0dY72AOTKLgwOtJRawtNgvRN47hYeDvWP9q3DHqvbdVmT1MU7z2W0/sOdwuji8Eac
         xHFg==
X-Forwarded-Encrypted: i=1; AJvYcCWiOfrlyxSAjNM2y7DBdHEsiTrjx30qWa768bfJZLq8/lrlHSb/2V1JYuMyXLIJkaxK34kP/ajHkQ==@kvack.org
X-Gm-Message-State: AOJu0YwjUa69OlHmrRoYJB7DVfOayPYcL6h8NwlcUFuXCQoSj2LrNlbF
	EFUNzAHgmWsfzQSoJF9bomoEWgaHWTF7YAVaJhnRDlvIFpf7irGVE+etriv6kg/k1ddV1j8KLFe
	Mw5GMQ3inlgeZcgPxDtxCY5lMuglyeaeiHXxfGzURuw==
X-Gm-Gg: ASbGncs/riRcpMY22iokLWkFbTxUcoV3m9SHoyjEHsoo1vcaKXrfgXRnW+xloz5c54L
	DMQW8FhuR9zU5LTvvFwT5pzs6XZVtOOoS2Q3EVDdqCaN8zWUjsMrfxwVbp5/1MafhbSLPGS/dLO
	Tb0z7ZtrQOM9D0i5UDjSRy6dT8138BAciEh9HcnpCol4xI6NAKiGp1BhcCfIjkmZe+hNUIRH0yI
	zJbfWD8WsUhr+AeOhCn4dLmiZr7ZMDfy6El7SWE4PwlURV6ubEzkhqH/KQ=
X-Google-Smtp-Source: AGHT+IElRIVhqCvDTFpSgFEYkQvi9Gos4SnKPGf8Juir9zGtxxq03gYdBJSCGUUe4Ii0djCwuMFVWPO3CN8YKO0f0p8=
X-Received: by 2002:ac8:57d3:0:b0:4ec:f073:4239 with SMTP id
 d75a77b69052e-4eda4e7cbb2mr148255861cf.6.1762856570888; Tue, 11 Nov 2025
 02:22:50 -0800 (PST)
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-2-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-2-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:22:38 +0100
X-Gm-Features: AWmQ_bn6E4e4WTTnqqQ9ptsMdEgyTHjWIJOU4-smQyjZiT3MKecFKgj620d_-Vc
Message-ID: <CAJfpeguqvHUDVzR7N=To8keErrF8Bn9kuojoFtM_58sLY_XXDw@mail.gmail.com>
Subject: Re: [PATCH v3 01/50] fuse_ctl_add_conn(): fix nlink breakage in case
 of early failure
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, 
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: b7izjjdqstrb4kwxpicy6bejan5ep553
X-Rspam-User: 
X-Rspamd-Queue-Id: EC5A6140003
X-Rspamd-Server: rspam01
X-HE-Tag: 1762856571-84901
X-HE-Meta: U2FsdGVkX18mMznRdZEX3vXrL32lriWUV6L5vnqEealcfXSgrPXKCVx7+KPidc8U7d7pTkAJz/eTIEfVx/pLe3kO6OyKMBqZ8RjvNkf8g6c4bMbdNi944qpGnUvyELtFyD7WOcWcBHjImtxMfDhqV1IvrEF+DhiP6ona8lRvmWHlfSJCx3eCoefBjMHt5z4mRRi7c0ci00sPT+c6FEXdQdo3tr2XPsZKvqkYbOl+F+F3POu7CDtWmRW06BLcGwM+eUYVcqQ4aaUnT02xr4hvzLxyg9497gCivCVRV7a8dQ10pRK3jLTEh3CwllrTrhPFw91dY54E8ZUxyCptAt75IHRQuicL6vg2dwPcMWNyIZZvu+J1+zdIshSF0Nes/tDreHQNDcNz6Z1w3ySzp7lLcwUgy2YQqI0OUaC95ojqZNseKLZ++ug5rs34h4ITLql0S9bgJLvECqHE39a7k84JDOHZP2D0gZhPQ924tw6WnGKIAOS5pFXKK44kiRm2vdm0oAkkab2RHnh2Ql95aV7sE+671dUCApTnAyhuo7Ufg/NcJMX4xqs5Ny0cy5SA9UWzM1UT0hqIvcAvrZL9B9yjqEDwHNM3yqGgYqCX4gAntCDJc65UQ/6mNj8budo0sJV5I9S95KHduRJhE2Ngr30Z5HCS/QTu8WKgJ+PeX9WRgAnVmsj9DbsGXEUW+InyrIYZ/9GSyK2V4+lTaLFMqdb+SBfOxUooTI5QO2F/l8a56RUEJ2n7gT6Voajwd3k4qCSab6Q2f8XQXnxWV9x9fkZvZrOpuXhAByc+EG1Lkl1+NOJhs+VI0qXpxsqCuVYtPBl8ry+piRORm/uJxO6zLIsNqAtPM6b8xWLFX8gss/dKVgJoFa/ka5RIBF6o452QUurkRXgAIQEb/2Jr9iH6XQVZsVGvKS66xsUs6SNPjND/FIS9BzluW7KIDjx4Ij8NL+GlXrcREPi+d0QN7q134NO
 7oKDYOX4
 4UJw0g3D/XLustK3tYU4h9fmO7GpbJncRCPbzNyZ+asTRPeFp+ll/jbvCGth6DVS69KH3wigbn9tpuAUOIgk/rluoFx5IYnsorYgi2c6J0agEBae2Js6VbcaCCxGBRBuVYRftaTR9HdOGIoV3MAM9DnhY1M6715NEW5nEcyg8He0NOuuWN9cE7i77siDOMQBOzsD0OihcX4lfqSXOgQ09WjvSAiXhH6mIM2bP6p1sbmcv21luAAxaPFvYOaPcatpmlN5GENxi4BZLM8BM6g1tQ345mjY1V0hGuLLoKWmrppDX1Oz/XaV+4UhKnfNbu9c24JDwA/5vFHCyCO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 at 07:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> fuse_ctl_remove_conn() used to decrement the link count of root
> manually; that got subsumed by simple_recursive_removal(), but
> in case when subdirectory creation has failed the latter won't
> get called.
>
> Just move the modification of parent's link count into
> fuse_ctl_add_dentry() to keep the things simple.  Allows to
> get rid of the nlink argument as well...
>
> Fixes: fcaac5b42768 "fuse_ctl: use simple_recursive_removal()"
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

