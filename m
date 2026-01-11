Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E33D2502D
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 19:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FD96B0088; Sun, 11 Jan 2026 14:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F63B6B0089; Sun, 11 Jan 2026 14:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9526B008A; Sun, 11 Jan 2026 14:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E5776B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 14:50:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 984EB140E7B
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:50:53 +0000 (UTC)
X-FDA: 84320725986.11.FA43398
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id A48CB20003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 19:50:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sksIvq9O;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768161051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Rxaqcbxsoz2fcbOT7lRZNWfqn5zW6QshB87oNyAzGY=;
	b=xCJwLAp8ld4NGyDmmpk9TKgBge+zpGE2axvOtF/Qw2xxWkuQ9MoRdVvmgiDfQn1Z5IMQYd
	/7lX9qV/2oRhIPHpOpTip4ysU9NNTSB+eJqSS7vRIBhCbwR1FIkexUj/cNrxtSE4RxCe00
	dR10VJGUPIpryBAQDlorWFdr96dZ8xs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sksIvq9O;
	spf=pass (imf13.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768161051; a=rsa-sha256;
	cv=pass;
	b=QrEuu/qMpy9nLvLMmmSn33oafHIRvNhn8l0mpwAqLNUnSqLtTWPTsBQq6KKTCSV/K6QAuL
	bVrFDaXKl3PcvrgkS8EA9ZPdYVZUpJJrkR7HM1o0JoVnHgpYBnZbBFj1YM2g+Ji1xHQYpg
	hESSXzD3+N+q+j1zDEzYwU6/QZS3IhM=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso549921cf.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 11:50:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768161051; cv=none;
        d=google.com; s=arc-20240605;
        b=Vloh0BmIVWbRqdIHIU25647i1JbGjAvBxVXw4h8WE1W1qhZFul+cQJNZewDrfBFuTq
         giUbc+xyrzl13p5b8f02PXZa/VwcYFaunL9cMWOrG/pynRR/wTkoSjRrZq1PptT5cfvT
         mPq/a/LD0Li7xeTjsbUPtGef9lJVuEVPQ6veXTv8SGVI2FF37NQdnpA4Q0AU+5FJJYdF
         BZUsn4Ys/ewhlQ3Tq5VLvH+U9SR04tAf8YHl4ESC/hZB5c+jizabwu/2e2rHHWWWFxKa
         Vw+NtTTXxcxPhs/6PcrprMcV6uTsgHEammCUJ9tY+FhBL1Ms5Mj5JQs7Br/ufYpEDKdF
         J/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4Rxaqcbxsoz2fcbOT7lRZNWfqn5zW6QshB87oNyAzGY=;
        fh=LYj2T9EEmZ2rVGdjLSA7A9wxNq0tHfeMtGcJqCycOco=;
        b=XlgE8M31UMmogddS8gvC0FIlvEm39F72jfyf72DCeOBHMKX+OObOxJs5kdxybNsq8L
         IpGaV3faW0Fs6Fr/3AjRrlnDiKnt9a2HNGxIEWg1yFYdWf/6k0lBs77yAXZ13+/XKoda
         lvGeDPvpf5iu0U24UQU48bHsJqAhaMwjHENrevMZaSdM2xLusj+oQ5y/FwRihEaeSUK6
         N1ZZfVKGX91sqe5JEeFTOHSfpNUFMApq5aUobTGP1s8dI2TrRLTyIXPs9kIUsXZwxnJ2
         mEeBTmswcRgK6FLf94y+liRWaN7sgI/Sr9GJsV/ZCq7qiyvwkTVtzxw/Iuz9NQwin9cW
         8nIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768161051; x=1768765851; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Rxaqcbxsoz2fcbOT7lRZNWfqn5zW6QshB87oNyAzGY=;
        b=sksIvq9OGi1OaLTYDS7mIje4YKhgab7pB/zi7nxv+tedYLzd5L++S5nZ/jZN+nDhm9
         wrg5Z6CYpJh8Yh3aqfFvAsXCM+uB4erDqbpRX5+lVsjsM53BIWhfX+23jLpXUhiym9Sa
         FXSBHZOw4FYY5UCDARRwoe3Fd5AsaVj+9XXYHcXBBBMAZzHTwFBnUO9oZLanswYT2clQ
         E7UnOTsabV3padFc20L1Wo5f/wEdQdISMGDQ6D09Dy0Wtk5T15VlqF3+ZiYzyYyvlGqn
         H+Zovz1WgXrBLvJqmoQwWAvzrbl8/O0meQEyIclsNPGDnnBORVZnZWTd1DEOVjEYKLh1
         oodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768161051; x=1768765851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Rxaqcbxsoz2fcbOT7lRZNWfqn5zW6QshB87oNyAzGY=;
        b=lXZYlzAL023OHelhmInqieTPLqSEKA7LllNxELXty6/fbKoe6kul2c5ijUvZn0yaES
         UJScD9NKpP0BHSSZpztma1JsO9CvTY2U0ig9M3RmZeDTBDw9h3BNaiTIoRnNLemncN2s
         bGT5edscjDZ3El5enh2bY3x5gO4s5httmqWmqxj2UhEiHzgYH4IgRAJ0ejk1lfw5jObo
         2Cwa9nqzhPWeWuLW1ecSgcgN3VhwmUtDnYRoq2ja8MLHHjGzHDAyYp+ojHTzwnaHcAad
         dD/kJ5Xcate61tQeSgSMtQDzN7H3DsQz73vWDvCiSG1xn6j58L/TXFa+NzR6unBw/l00
         QH1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUHPhpzoNURnQhr/qEyMXrFIoeaDsbLslVaOK/kNrIVzNHtsC8VZUjuzPUA7rHzQuxI32ZpgX0gCw==@kvack.org
X-Gm-Message-State: AOJu0YyDDfEWMtQcIKXKroag/er5VFhu2WeXMApnTA8WFD5+EqWjVjnL
	SFhO3ygs70ba37lFmuaA7TdCNdcpORMTf0JOEWIy9bd8gx2uEVF/IGVGXEtJa07bCyed0f4SsGw
	iU1rYOQ9Nqsy6Qy1t/olyp1ZcGyGBBPmiqHmZP/ZFLqYTa30d74ScQgt08uk=
X-Gm-Gg: AY/fxX4MUZIpt8fqxB0mTjmcXN+PIImKJZreaY5eIaTp6ZJzDbGABtdETy1zOC2HU65
	eO4M0A4WemcT8Ohnv8Quo6Mpg6x4Y4oOAjfYgOB7nqvU8ZXUZptwkGpnvw7P3o1hcSTpk1N77+U
	0RzVL+S+hwfyiEsYwQQ3EwnvhbP4eKk+S8178lKC6pUCNlDJijvfGKvXOSWdlXwMf9QmhArgNTK
	znG1bN9oNs3vMO1S0wt3RKKgvrJnzQnICEmJDLsAW6laUoAoQAre8e1hhbPaG9VhUZ3ZQ==
X-Received: by 2002:a05:622a:1213:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-501183f4374mr12942481cf.14.1768161050037; Sun, 11 Jan 2026
 11:50:50 -0800 (PST)
MIME-Version: 1.0
References: <20260109062419.157284-1-ranxiaokai627@163.com> <aWMLQkvushKidjQQ@moria.home.lan>
In-Reply-To: <aWMLQkvushKidjQQ@moria.home.lan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 11 Jan 2026 11:50:39 -0800
X-Gm-Features: AZwV_QgnIj5jxqjZWPNyZ1aQJCUUVXKREdt5QrSWlYWPGsMwNuUxgnEOGHpRL-k
Message-ID: <CAJuCfpGo4wYcMChX_xJJ04pHYKJ8vMPrkN9GFxXhW-1xQEmfiQ@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: ranxiaokai627@163.com, vbabka@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A48CB20003
X-Stat-Signature: 4btqnswdxuh765hos3m69fgzqts5jcwn
X-HE-Tag: 1768161051-336490
X-HE-Meta: U2FsdGVkX19ybmTYLEdKF0w7E/NXZKIfrmcDqAMDjw6ThxMcsyjv7Opts2gVUjIEW2r9pT88p7hFTgxTroDyq5ornOtgNb93AmckRbdPmjUbWlWSt/r4KxVGuRGFBN7AJ82ucEDkg5yPbv8X68a1SewcXVEugnNBEQdPbxLwIltXBh3/bSMzKH8OHoN6URgMeO9WQ/PLLBuWW3vRUK8iTvRb2ak4WYhOLe7K9QmL9hDY5jZN6jFObV6la2WQfS++Z7EFhJ2cyyTIuDVMBGeLPiJ9wvJ28GRFW7bhoKlZziUX7JxsUjd5vv/cLj0lQKwyynG+XwAshlCqhCXkq7SOsA5a2H9uCBoeONihiC5jfL/W0Iy/cSmNJK2NUg0zj1g1yjgyRdlLWtwq/zSX1BsIIZFfLdg6+kNTstgKTa1MgDYoWHBeOd/D1V/2VUo+buuhhtW01eFez2JyR7Zz5LSb3cpVP5+PNgyjmc/qLsxhQ9wgS3X8Y9YaiOLOO6wHg3eCdflYrryTyF8tQQcqi2WsM3vru1sACA85eDqvsRXukxiwJoweTursDlY3FumOYK5AbXM74fRdw7HCfbVbUAA4NR4r2MrReLrq2Pt4M32gnA634zdeFm2iY5qZ7IQ7iDg7h60GShH7r2Hwbn69J/54FtlAC4Ps3SiAXJeK59jCSGUB5cZe8brarnzP53KSBN1F8vO53Nd8g7DLjBElWZnnHLEDTG6z4NF0hXyfHuqDrNMai7vLOo2gLRSe6NprGWMLFA9J47V2jDSIgFIxgPdFNQGVvR3CD0PBrJCT5AtztYsRSi/YVFziTuUXUtvr6Jp7V/QRQWF1zx5O8Wb8lNPt9da0dBfWLyhtW3iV+JsMWwEszuaPMmodKLIRzwKxqZVDZ1B3vOkk4j/RoevF3rDsvhEKJD4qnhqXHhKg9uqbOIEyNd/0sv5llsowu2MSlqpxCYR/+I6716kLu8I/UMs
 YxqMU0uL
 6GVwizOw3tqFIX1WCUJOQngzgX4Mt2aFzRprzmMiTA6UosvY1SqVShev/ACDDJNliIVQmC2qK2t1igJ1pB06tWYTusyMHN7O3T9UW+zJz6Qy+T8W/HoNKaHgqsGFCh/I8PermGaqzuCYX+pto/QckZfJWMn8vRUM+gx1Gifts+a37RVG2LxufrzfaO5kZlmInwlqdWlDBezRHcLsCBlIqbf3R/y0wm5fFwsES974vwIkC3vL3+Kala5W8WfEQqJD5Bab7E/IPeewOZnEQqco4YzpNMjGvvmXOjJ+R/yR8vBqi0rh9ZPzCmGeU+eb/35B6YYBr2WZ0aaj3tbU+6wkyQPBO+ArhUbGOsBD/XGIH/MESl763VJ2fFvBecw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 6:34=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > Boot parameters prefixed with "sysctl." are processed separately
> > during the final stage of system initialization via kernel_init()->
> > do_sysctl_args(). Since mem_profiling support should be parsed
> > in early boot stage, it is unsuitable for centralized handling
> > in do_sysctl_args().
> > Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> > the sysctl.vm.mem_profiling entry is not writable and will cause
> > a warning. To prevent duplicate processing of sysctl.vm.mem_profiling,
> > rename the boot parameter to "mem_profiling".
> >
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> How was this observed/detected?
>
> My reading of early_param() would seem to indicate that
> setup_early_mem_profiling() is getting called at the appropriate time -
> and then additionally a second time by do_sysctl_args(), which then
> becomes a noop.
>
> So the only bug would seem to be that the sysctl is not writeable in
> debug mode? There's an easier fix for that one...

Sorry for the delay.
That's not a bug. We want this sysctrl to be read-only when the debug
option is enabled. Otherwise if user toggles mem_profiling sysctrl off
and then on again, all allocations that were made between these events
will be missing their tags and our debug mechanism will generate
warnings for each such occurrence when freeing these allocations.
I'll look closer into this warning. Maybe we can suppress it when the
read-only sysctrl is already set to the value being assigned to it?

