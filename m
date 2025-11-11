Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70F6CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5658E0010; Tue, 11 Nov 2025 05:28:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CD38E0002; Tue, 11 Nov 2025 05:28:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA868E0010; Tue, 11 Nov 2025 05:28:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1608E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:28:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A524E4C161
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:28:31 +0000 (UTC)
X-FDA: 84097952022.27.DE4CA63
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id C80814000D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:28:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=Qzk2zNHv;
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.175 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762856909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/p7mEepN8jUuWyprYCkVkbNxCuAN/nU2Y/T4HHlQA0=;
	b=foyxoRMNOLpel7FYuWJqNV8ewSs/rchQfCt5LOFaxpja/waxc5WiRdCTT65zBxOXXFi+A+
	0mdHpXZf6G0Ul3Pzj/H5iONW4tSEu05vdzTXE/J7dA+kT2UyAc7hea1tktaQPHETi2G8I3
	rxyUstzo5lGB7WUp43B+b7RaY9ZSX9w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=Qzk2zNHv;
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.175 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762856909; a=rsa-sha256;
	cv=none;
	b=eKCtCBAooNiTKo+4qld47tGPrry+kd+QcWkllDit3+3SbETiX6QHpn8ou0FgtrZfXFYZkc
	k9LZTMJmFcsUY4Uu4qtUE79cFG7j/6nh+27y4eXUW6u5SZN5Ok/hVcsPcku2d0sB0tHorT
	0WZJ7NviWiL19cCxnH9t1kpduThqXGo=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4edaeb11634so20277971cf.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1762856909; x=1763461709; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h/p7mEepN8jUuWyprYCkVkbNxCuAN/nU2Y/T4HHlQA0=;
        b=Qzk2zNHvmiummXOKBkHY3utAn9KwSNsy9kNHeof7B524rcv3QMIHrbCruiKBiTPA8v
         DwDMKDRVy31M5/4Fmk4PdHJXDfkff72TaO38JPnxbqP70v1uri1pKRNmfZ+4hEPuJAES
         9puh0ieRmZOpSzLxjgcjri9K4/WdfmrPdfbtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762856909; x=1763461709;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/p7mEepN8jUuWyprYCkVkbNxCuAN/nU2Y/T4HHlQA0=;
        b=lvaQyrgWxEi47RRk70SzxT1u5cJjZIVc/27yNpU5AXhM4mxz8OplX48vdYEG9iYiqe
         d6SP0hA50liwv2Hp4fNiLbysOz0aWjKj7xPekyMFx72hLtTPHV0Y3BAHvfLWV5kKdvHT
         ceOCK0Zi/ywfPyEEoo//wzt2s/UWovaZ+E0q7gZLfSwrOdyu+d69xtfQtsY/ok64At6C
         OV6FVfecCWwhYKXfTeaj5fN32UFfJ6KGKaKZwPUcTuJyuZHJs5+4a5qdMuL0CPQY0Tfs
         K7avWsjRphP9He3EpXpJjb760OdyftI3GlFw0CtQVyN74wlZkLYEuJqjRkZv8Q6QRakI
         eLtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkUOKfIEHG1jCSQ36CpnOjAazItXms6YowTLhJkvPAM4luRNsMmz2ZapT8/JNTiL4y6U48132okQ==@kvack.org
X-Gm-Message-State: AOJu0Yzv2jbeYUAXU2tzGdWagVZrL7eBk4ZqKSxGeso+QKX2mC1xaHPB
	q3i51/RyUrmeYQvRfWDOkMOQif4s9kyf4cmt4Q4c69acJKUTm4EJrTUPdtYYai+9OKwf1jlJvYv
	TXl/w6tgXmyid+/CJTLwxWiVh2JOHKyHztYnQwick3A==
X-Gm-Gg: ASbGnctVSM9YGNDZ5C/f7BS3lT1eRSTwX6q/gyvWH0IPmeZ7Cr9rzvP/ay0BQZgpvl+
	ZX22VYj1qXCyehOxB/T+jPM45JSeL3HgY1tjigC3nxT7KtsiagEb3yo+LACaNjfWZbJikznr0cQ
	0FJMuXHWXlWO3RrE0j/bnF+0Qh94dp/tA/KpCwXWLUsXDkhRLeJODsKxp378LJLPF+cD719Fmz2
	zuzZ2pQHyKDiePG5Hd0NND5XuRLFp9a+eorppybbV2qoLlVGXx0tOLH6i0=
X-Google-Smtp-Source: AGHT+IF2jsXtOYznzAlKiswAAYjfBT86jbKpGaMbobTgICmObIV//j5aCRxdPYkP+19MfGrAnajQvcSXxRuiu1TbWoM=
X-Received: by 2002:a05:622a:1898:b0:4ed:602d:dfb8 with SMTP id
 d75a77b69052e-4eda5043040mr135933731cf.82.1762856908949; Tue, 11 Nov 2025
 02:28:28 -0800 (PST)
MIME-Version: 1.0
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk> <20251111065520.2847791-18-viro@zeniv.linux.org.uk>
In-Reply-To: <20251111065520.2847791-18-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 11 Nov 2025 11:28:17 +0100
X-Gm-Features: AWmQ_bl7He3VQsld2UXN2E831Naa9ot3hmwpZMaWScQnQVWsufspzsog6zo2yMQ
Message-ID: <CAJfpegv0jMq96xD8gSbMBydj=1wRixVGy+qd3feC2vSSn7v_rg@mail.gmail.com>
Subject: Re: [PATCH v3 17/50] convert fuse_ctl
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C80814000D
X-Stat-Signature: abr1ndn63fn6m7zbbidhu4qawf7xfajz
X-Rspam-User: 
X-HE-Tag: 1762856909-292577
X-HE-Meta: U2FsdGVkX19mcpFFjDSiZgSUGE5xKzENVRskY3c45d3WFZQM1SIR6RWlipv8efUab2Q/te+mgshU2HCdTciisbBUUc33rmtJrZFOAqiLcNiOEfPac2Yq+yzMYi89nH3XOpcx65VcBOq4EOYjf1uEFZlKH9xeOmFO/twK/OOGPC5JpEWxepJLUIfI68aO7RQFKCiaM1+JcF8AWPAiGoPR6MadE4bxWstFz1hjnxyLAl1MAr/5q0lMkBDv0BMdQPLLpEjDrcmXEhrqmx7vKOT9amk2EQgvgzqEwPbGqBH6/Xvh+CBx1RHri/GlToYhb62U6VDDCzccOjSOmblnYldTQRMbvl/JHaHcqKDe0z16xHCePGHH3KbYtRgKvCtyVdst8fQwwkqifH9p29NP95i7Y+TuXbsucusM7cd8yvQW5KPg7NdECtkEeGjOVLnoyonniTo6SiGIoZ+T7NGL9n8h1IXWAcRDwdyLTdZyApcf8pKX4PVdZeexh/zJT8lQQdhRdtj5nnWC7kJJjW09i3JNdwijdDlnZis5u0OwTVg/hzAXZV0CYDWLjKV5kHXfzpMmT4vODwZvQIRTMeGo5RMPGStMC/vCxHrghZkQBVOe3txMUbYCocEarmEp2grtyCXgbXf/q0Km+2P690nmHjz9YmfQCeOFlieygZmV+dVugTaTewL5P0F9JA9d5nw8mcrKlnXPhVrxCJl9JRiSX8YrHxvpgfrwi2XRpcwRLpnWuKOjEpTPvijBcYVNeXxOH7JOD1iPThKnjWmixIbLYc05qtMXgZlygDn2/qCUhvFuoR3yQrY4yMqmLkF5+d31IBtr7ieiZUxZCwHYonUjLzIQTwskkydP8PFsi6xx1YQ2HVqHIAagDLEwGzRp+hTugkT8PjkA4IUS96tFTNk9ZpYS5bYncWfls3u496GASdAWyPWI5kqq+MQvb7lKdIltnSzjMXhNh5sOd77l7mYLnas
 hIWjd3qV
 jUs47ty5EGwTC2DFW2qutkpUs6rJRcAVVrj6OLADczUMh37wVHzbeiWE8OZAFy1pSn6YII9Z9Xa0RXuTIf6FbzwPpUFlpsrKdt/AmQENvc7FSZ2wscTayvJ/NdEvL0yD9KVVWdRAsAZy+YCOdBhvLIW6DtaFyu2lF+pvG6ezeV2/8gI/kOLi4nwBUDSMvqwFPtlaIvmZv+XI2Qj+p6bKFFdkKgw8kNA0AvwUqOG5fcaRusNeCpGlFgs2EX4ySYqRRQs1ENiiomqh/noa0qwGZ9IcNFoBP2LG9y5ZoH6f2wDXQVtJxciMCq2XmDBHhBjLDfYAI4US6CsM6NhM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Nov 2025 at 07:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> objects are created in fuse_ctl_add_dentry() by d_alloc_name()+d_add(),
> removed by simple_remove_by_name().
>
> What we return is a borrowed reference - it is valid until the call of
> fuse_ctl_remove_conn() and we depend upon the exclusion (on fuse_mutex)
> for safety.  Return value is used only within the caller
> (fuse_ctl_add_conn()).
>
> Replace d_add() with d_make_persistent() + dput().  dput() is paired
> with d_alloc_name() and return value is the result of d_make_persistent().
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

