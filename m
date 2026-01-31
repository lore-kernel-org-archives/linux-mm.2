Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 552DDE7C6E2
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314476B0005; Sat, 31 Jan 2026 15:11:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBF46B0088; Sat, 31 Jan 2026 15:11:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C03A6B008A; Sat, 31 Jan 2026 15:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04EFD6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:11:25 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9062C1D83
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:11:24 +0000 (UTC)
X-FDA: 84393353688.13.2FF6192
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6618740008
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:11:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769890282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
	b=KPbQAcfjVqCrLtdRidCwEHgalbgtScfBzQbXsCOIcP52+xzag0yqKcEMtxk3X8m+p3wFN+
	iRc7rY8D7slWRGyUtYXYtzdiAxWlr6tOo7EZ0Ct3vcV5Q5TAA5bq21EcCG7uFPFKCROZtP
	YtDQdq9GFO+T9kxZop3Yz/DqJg1un+E=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1769890282; a=rsa-sha256;
	cv=pass;
	b=ZwehPTuPCtTyttyiXdszcT1TUPUNEGVpV/SyORwETL5ReisvwdXVBZ6VPCl+3iETMskg4g
	CGOEVG0xI0cwpEg/VpNh5257f7ebwEqQig8SI3r52K0ic5KzacdhVCsYdlL/lqQo2/WfF+
	CKTleZDNHpd5JmN5pIp8S5k9WDbowgE=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E57E5160894
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:11:21 +0000 (UTC)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA49ED4FAF
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:11:21 +0000 (UTC)
X-FDA: 84393353562.24.50005B8
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACEE0160004
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:11:19 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769890279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
	b=xu6/weCx/PTRvOxp77R94lI47lzAxYjkDMBfSb4WXjyO6my+6tPY+tY9tEuahHN/PEiFkf
	dDmLW8umzIywCCWRFOpv4x1cOtd9MRFU4ZIJauvrrABVi2DWiO8vIXUv0uA7KDvfQ5cvMi
	erj/ebPrGfqRZAnE2N+Yxgy24bdt8Bg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qWihSs9j;
	spf=pass (imf08.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769890279; a=rsa-sha256;
	cv=pass;
	b=8qZC8tkS0IUFS7RYMsiw9NvxjoL89PfEKndP06jcl4mbPFasEpHYf0AUypmIqsi9RsDhg9
	141HTX5wLNOFrIof5AOLRvk7KKiDZek23nxhlhWawSphNufh+wDSbpM4MpCVsd55hnx48f
	bHD64qJEoCfXn0hCo+BRTBRm8iBTPm8=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so4016261a12.0
        for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:11:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769890278; cv=none;
        d=google.com; s=arc-20240605;
        b=NtXm1w2mPJumVvrDcge0LVtHdVcFF9qpzxMY8hp6OyKR+RhQyKf8lIFVUK9S1+3m5X
         /QGa5bykcwGTEXx8clGTKHT8PvA6vsruM4N3VnoEnBXQ+9sP18vk/nDxy3CJKcUUh85h
         nVa+7bNNMfJCr5lT3vaXiBKZB5jmoyJsxTEpp5eC/zguOezEZQQCz466sZkiYvRWAOs+
         t63rMS9cQTgq8GbchA46hA+UF7POtSUI78dzcTtn51w/c5wE1LmPwM3scHlDk3ZgcfZ7
         OH+zqRKPEyAd7nRNChyZrCVLQJd9OEd3BL+w0fl6Mj9vrVqZJv7hGsAOfUFXxN0yr+Uq
         cF0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        fh=GUQcNry/DFj2I8FpI3IyY0NomaW9oAT22nq5cvWi1ww=;
        b=eKkVqN9DhbchQHjkASw6mYfLDQiQiR1gmLgd8TFT8ecJkDRQoAT1ZGPWlqlrOYhdz9
         2CLVA3bPFO9GAgRc6jvsYU/XVSwzR/fnGf43v95uJUF8Uulv1t+ZWz3bCmd/T9YeyyCX
         ftg+BTsv7uogjz+GdvNwCmRhghyWWwfToRVJdaE6ZR9DIs3KMFEcI3JMaNZsBBm2kNXh
         VRzIOPL3ejxxsccupLMO35ANHB+Ab0Q13Hz5oOulgKPapZph7GdzWIoylnoWlR9f6oNd
         DJOSeN9jSaYt4akpycAjKDpAow2p9/zObDbAhEZp1Lk9TD1WvLTLIRApYIhsk2N3iymN
         9Mfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769890278; x=1770495078; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        b=qWihSs9jVyWIIohYlXQ7RRnF3PGCYgbXkaGwFZw9ykL14u9xu7qaXVhZxifm5Ufbfx
         Hsxu4u+5FnUpCRzfSbCqzTC9S41ecpho62rl+XuSUUZcgGwgP7epDhMQbXeBL6+xYASI
         QL56J+WbosjheOMu0ejhjav3oOdmB1Y4GB9VFDp3qDFMNvYPMDEMB84uBhEW9ccf35Et
         m8RmAgsXMPgSsipOCQxpE5wLGmF/cKEdDpaRjUbI/AMrXj7jB6sQ7eUkih0POKfXsMBb
         I8uIS4ima9NI3ZUhW0M8VkaqjxVk7DUqU1lCKRu+JuaKVB5bxJplOX4qyN8i3d4/aI9S
         aIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769890278; x=1770495078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rL+Su5x/WeCqYgfxZztlYQTOnKf9OKjLga2LNBzR/Ds=;
        b=Gdr/6J10Ca9HeH6qHRy2oCrD1SkXmb+TeSpiNjEKBKwcC21Ice6QuKdeg37rOZruXO
         Rp4suY9jRaUvIQUjhQNMSeWnNVjaRZmXwLABzjNqIkuPiIExwdEwQgQ20Kd2awe5wWAI
         EhpYNa1tRcelBYmmty8x/ctOAe3EhHFeZpAoxzptjrO/xrVzkiKTk9wKu4dS/oM7DsPu
         XBoWvW1ZrNTkfZh5UcuKO6TrM7So6lQZBsJ9KVQR9h8vHuvkV7wsk9sV7Sx+JHUxxOXx
         22JnG9Hup4UDJpGFEUxQWNZb2IFujaDk2FJ4TfGKxN3n6n70LuvTU1MOS3VTCMSrojLs
         XqCw==
X-Forwarded-Encrypted: i=1; AJvYcCULtfvyTUPln5hRMqRcDgLmOHMD6Rt9zYHk9X2oWCcbDHwCI4MoZL+zzk5l0FyV4DfYfIDsTlRvMg==@kvack.org
X-Gm-Message-State: AOJu0YxI60SZ7zrOCl7S42gW2Ip7w1aRM2EJGevPe/7XwLzKqEdjHQwu
	raRrd2l9POWhN2tfKGz4fvzNewtkqJT1QY8AxuUrqSGNbtUjZzop82bBdbpUQcV0zUQueOxiADD
	Fe8JiUkAD1N83F3t+V7svqD04Yc6nJhShH8jn9mHqk6KvyM+ZqS0zrLp40a8=
X-Gm-Gg: AZuq6aIMe6w3q85sK1VtGqdht/OLOlj9qxvxat0kLQaxIYpMNIErjx2pwUUOV91OW/M
	SK53oQb7hL5bY7aRWi5X1rfXJdYKn0xAh4XH66EBEUJQOREBNXqUxqeFdhIYbuzbP4Hsnsx2FNp
	8TsSemB4kDqlJnaYrf7bIMYfC6jS1QcQywD0Lgj5+lmK6g04LyG/ctLgDSMb2pA6i9LfhqtRmHD
	9gWX7TpyjjpqWDmP4SOdOwP/pSFArIFNlWueO32e7cRi4PEd98mA7CM2DHwGJZU9hqXW76annZW
	0aY=
X-Received: by 2002:a17:906:d555:b0:b87:2675:9eaa with SMTP id
 a640c23a62f3a-b8dff56a89dmr396045166b.15.1769889782950; Sat, 31 Jan 2026
 12:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
 <2026012715-mantra-pope-9431@gregkh> <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV> <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV> <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com> <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
In-Reply-To: <CAEiyvppoiL2EiSmVvNV3DEkr7wwyC1Fbwhm14h7Rfus4Z8uP7g@mail.gmail.com>
From: Samuel Wu <wusamuel@google.com>
Date: Sat, 31 Jan 2026 12:02:51 -0800
X-Gm-Features: AZwV_QhcEbOb_GQTelufeNwJJCU6MsAWKA6Gjz0fMmR9BpLj1Kmi7hMzQGebBBY
Message-ID: <CAG2KctoHRG+4J0ujC9162n-Ndgn3nKMu_s5jh0-c-B_P6EOk6Q@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Krishna Kurapati PSSNV <krishna.kurapati@oss.qualcomm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, 
	linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, linux-usb@vger.kernel.org, paul@paul-moore.com, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Meta: U2FsdGVkX18zEI2dueOrRqYC00SwAZtlyEIVGGcvp/rHxZwP123O20bVe+T9y8HoAmpNrYHP2X7Ho97gWhe8DIJsXVR8Qc+74ZwrM2FXy/0NOpCbXTyQ38R2sxOw7YvB+ctuydBtQ7ZcglFj78Ot2yqkMEetpGq9NhwdLU9tHg5Q1krbL6De92O66kGpa/BhFpMTM5PS+LETKpSAoECAWO56q02tS8FyXpj2ZqBL45fBL4wXZo2YLSPFcrJkqmK4vazfpNBwVmw+l3UzbGzUAbvWKfOgx118gZFWQDDhTcyWa6wpyKPjz13TxvP0a79e5gJrofw5Y/VHkzVojlFRCT6pqbet5FpuN67P1BxscLSOVNX/CUp2uX6po+u2ghZ1Vtqp6O3FwOyjQs2LCa2gfcfUh/AaeM/GXQoz21Lcnxgdo/1Q9Di4sfi3Hp5tGJ00r52pgI52g0yeiqo67kjr+Y1LlPvGeuk1n5pR4vwMgnA6MbaoGMCuKtXv0ULgPsIimtF4uw43s0KGNpyQo7l7C9UpXLW5KBFXo8afsv/CyC+0nDuELGel2k554E5wPTY5QEJZcJery34UX8FfvLlWtg1XXUD7IQh7AP5jMOadNQu3L2+GGfPBKUnkoSImS93aEO1VZUYyN0ulv1Ekej035FLZQ5Dtofy32NCBdIMX6zad/Dx/NN0jai8gyZBY2JlGtW7ZBz2XiXWNoRSfPTTfAyhgTnhM8QpFt2V1GkdaV6Nl1AP8CBe7aR0LXFkP1H0QZaqQ1n2UW1drgYBRZ383gZ2MYZsSvQivWmadpTraiYlEXDa9kikETMC4i5fkdprLXfd1m6PdZOEUwqvAevKsJpvycKpXiiShYl4cFndNYTTNr6Go6I/kCtXy8wGgUKOsUIPcYJEw6A+lMt0jQhS22ZEt+VPRS2Pxc7ZXqPPejGxDVYvXKE0J+ZVEd5DfbPdh1wTla4JNZhNp0Ox/Key
 ZNp7iVCG
 3y8M/xogua4rZOgqGarWUwY67XTFCM+3TE72x/By4Y+A7uIYZ3Qp2j3QrCAikujImmqiBD6FALi2+W7c9dR8wJSab0gN91cT3WQGZwyI36IPiP796IDjkFAQA87ibf/6BkJm5nEGuMuoK7aII+9BfOXcweNUNJ/C0PTjXCa2TPm7+UwgchQs61I1PUYuKWVI1r2+gj/R2qZ8+bHT5uKdygKOxYp7XyeP0oIZQH6frBJ2tV8SK6YHwkNRWQKtxB3nJlKxBMr2ZtUmLyxse0dTlLCovwMT6RIX6lW+gsUYhuGLkrjFcluNI0lSX2Tu3FuSSuaWAFZT2uY4n2S3LWUjc7fmry+vHXyPxtsaG8LldcfOCW57BtpvziAYKDTlFtlG6tBYq5gXJUG90GKUviRYLyM4iyhN9tUg6+R5CcveRogLohY86qnlvMpMKocicoQbZ3SwQIwgjHx1GPs8=
X-Rspamd-Queue-Id: 6618740008
X-HE-Tag-Orig: 1769890279-58105
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: da3da4g9budm8scec9egy4s489u5psth
X-HE-Tag: 1769890282-972600
X-HE-Meta: U2FsdGVkX1+AjwWu75/qejotTshCRj0a1AFt+OiJRJ+XDGIngWbkpxaGfhV2hB49kc2XlDlfKEyaj9YQTQ4DEnF5RbqLzrCX+d+cCFMoZr7sHDkBT35rT4xw8pU7TXtKtL/YYRfaVqWmcof0sb5uqrSFklCu8QtmvFE8IlIcBWREjpuQixAJ4K6hoSeS95kfMC5zF2MB+qy/gBOguzkWZRD8vdPW1WxnVEBP9v0WMfYu/cnC7wWqHP2L0RC0I7i08+o5yjapoevxDBi+e4uZB1BiJSwlw9c5qglvO1/w1ftHszqXVligesXO28eaDnOA3PYRozgUVruweX1Nuve9h/0s2SPCTyJtiqy/KLoHFApgNn3wBnkiWCzp7M+xhxq3C8FzXChO29BeLfTq+IylsZxvupAWW/qN2ng7qy0k3UKqnBjq8OD4t2Kye35vZDv8Ju7Xde+31038FwHnSHVEGYfUowG66AXkkj8OewFcvS1/LKPZrLZq4FAksE4oadSux7yhjhVbA/xsD8i/ad2jHwyGwpyrrGHCsz7do1HcKGtPL581J2oaGmw9wuOMSi1RGE7eAha9ePrJ0ONgjH8Gd+njULHb2QZwx/Dli9r73oE7gBK1ESzjORZf3nU14yWBfIZTxA0Vxy3JQ/fsRleLkkAtBHeWHLj3iv6aUdMLVXbbR91AVs1+jsO021NqpEda/5nUDc9Yo6RIzkj9dNNtX06ULIpr4dAWrf4IbfNVdGdaIBwXIgUPT9Vsg0SK9d0JMtYTuviIuOVxua6bX4O5eBFaiDL/SBA6kvMHUBUsvrRN+U2Go65mRyDCD97eGIapLVv2dmkfoSbIiVFE27UkEs0DXAMhmBIOdT6IjJ8tpdIuM/8KXdXXIlEM5kdxtcp6tStCGtrYBDsiV1N7lHrsbOykaoaeGmbZsTCXbkf6f0mqeHt1rVBr/SZHuuxMrLjv20X0HggFnzaGdCpfkfd
 DDi1P7uq
 ZU6TlHgR7j/b443+qynXX/V/lo9Cc4CUn8xKg72tsgvQteBW4o+com+dCy1nPOpfJtDNXZEewDq8x0MlMgCmIRMOXN+9vAjMhO9wJ5WojoVVIAWWIJZ8f/EpaOXMZ6yuQfteUGLwx2TXv+400hmo4uFpzdXqYMNLtUO2wvsWlfhsM/p47ss3n3htUDrfMnLb9/9roYZxCsn2U3x8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 6:58=E2=80=AFAM Krishna Kurapati PSSNV
<krishna.kurapati@oss.qualcomm.com> wrote:
>
> On Fri, Jan 30, 2026 at 6:46=E2=80=AFAM Samuel Wu <wusamuel@google.com> w=
rote:
> >
> > On Thu, Jan 29, 2026 at 2:52=E2=80=AFPM Al Viro <viro@zeniv.linux.org.u=
k> wrote:
> >
>
> [...]
>
> > I'm exploring a few other paths, but not having USB access makes
> > traditional tools a bit difficult. One thing I'm rechecking and is
> > worth mentioning is the lockdep below: it's been present for quite
> > some time now, but I'm not sure if it would have some undesired
> > interaction with your patch.
> >
> > [ BUG: Invalid wait context ]
> > 6.18.0-rc5-mainline-maybe-dirty-4k
> > -----------------------------
> > irq/360-dwc3/352 is trying to lock:
> > ffffff800792deb8 (&psy->extensions_sem){.+.+}-{3:3}, at:
> > __power_supply_set_property+0x40/0x180
> > other info that might help us debug this:
> > context-{4:4}
> > 1 lock held by irq/360-dwc3/352:
> >  #0: ffffff8017bb98f0 (&gi->spinlock){....}-{2:2}, at:
> > configfs_composite_suspend+0x28/0x68
> > Call trace:
> >  show_stack+0x18/0x28 (C)
> >  __dump_stack+0x28/0x3c
> >  dump_stack_lvl+0xac/0xf0
> >  dump_stack+0x18/0x3c
> >  __lock_acquire+0x794/0x2bec
> >  lock_acquire+0x148/0x2cc
> >  down_read+0x3c/0x194
> >  __power_supply_set_property+0x40/0x180
> >  power_supply_set_property+0x14/0x20
> >  dwc3_gadget_vbus_draw+0x8c/0xcc
> >  usb_gadget_vbus_draw+0x48/0x130
> >  composite_suspend+0xcc/0xe4
> >  configfs_composite_suspend+0x44/0x68
> >  dwc3_thread_interrupt+0x8f8/0xc88
> >  irq_thread_fn+0x48/0xa8
> >  irq_thread+0x150/0x31c
> >  kthread+0x150/0x280
> >  ret_from_fork+0x10/0x20
> >
>
> Hi Samuel,
>
>  Not sure if it helps, but Prashanth recently pushed a patch to
> address this vbus_draw kernel panic:
>  https://lore.kernel.org/all/20260129111403.3081730-1-prashanth.k@oss.qua=
lcomm.com/
>
>  Can you check if it fixes the above crash in vbus_draw.
>
> Regards,
> Krishna,

Tested above patch, and it didn't fix the device enumerating on
lsusb/ADB issue. Seems like usb dwc3 lockdep was a red herring.

I'll respond on that thread with what I'm observing.


