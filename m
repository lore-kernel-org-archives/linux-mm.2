Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 244B4CF45AE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496446B0005; Mon, 12 Jan 2026 12:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443C76B0088; Mon, 12 Jan 2026 12:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342CC6B0089; Mon, 12 Jan 2026 12:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2223F6B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:00:19 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93DE0D15D4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:00:18 +0000 (UTC)
X-FDA: 84323924916.24.C62287D
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 810A9120002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:00:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mlXMFelt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768237216; a=rsa-sha256;
	cv=pass;
	b=OGbp2f8IXx7eLU7Mzag4rLeT7voUihxQvhWDO6yrcfFpYAftdmQLeVn81zreUrQ7ZwMczc
	7MP9zqmKq791Z1kZ06VQjX2OgC99jwllUh/YTIcmpnRa8pgGSlk8uM4r5utCkVsJrQJ+Ka
	KD/92PSAqCK2ALJstAAk+VPFrZIUbtU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mlXMFelt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768237216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foR6hNjRvW1f03mtiXi331ioQ5S2XdjdkFQrMcL1TXY=;
	b=MvDAs2nPhazj5Nsr2ToB55nEVg5+fmfYcaK7ask69FhqALc7aHJxCPml9LOBD0iRkg+Tyz
	PwmzC9JMt6m/0yCazVMgafmskpKXUU/9ZvLo/Q9HS5AEYO8nBuPo1vOBUkD5VLobbPo2du
	nXIfSrQd4fKtDW/Xe3gfZUOO5P85agY=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ee243b98caso1008001cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:00:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768237215; cv=none;
        d=google.com; s=arc-20240605;
        b=FC/gPIFbYs/H8cwjyONnJeEvp3dRy//4d6D/oBEjzwWJg0pbotno39pjJtZcNG2RHg
         SvAEwigEMq+gXsQINZFg3kzEftAshEUMP41CE+qo3U1z0aywVTVIarj9D5983iphyAbb
         7dJ6iMMR5mNBgSYboBk6Mg0kqtGS6AF98A0+XeL1bfvJqO76NgS7/+4UlAc4eIOcCfCd
         hJQLn5dPaXch/IxNu9yKRuSeFMS4SWVKpjguYs0Z8Ablt+UH+J9RGoSta09YKghcqCAZ
         rHKHlfqyHwtv3JkkTp618QS2r0fcb/2YSBuWjUuEXs1OJ775kx6Fz8RKJmAk4mC4qQAm
         qx5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=foR6hNjRvW1f03mtiXi331ioQ5S2XdjdkFQrMcL1TXY=;
        fh=cqq3hYd/mdAqfIA1uWity1dhQQ9D9osjPHNMKFID1m0=;
        b=UVJtdvY2NHXOhx+hTG45cQaDUe9Xf61TJML0vPaIso7Ee1iQ4QkUZb8iPRaghRTnOy
         BPsSJxzx1VNQ+Cvtxwf/CobapyS8pCfb1/Xwe855zcIkoe2D1hkxTevAlZ32lBV3Kij2
         0THD7kuMP/RQoVwIfnfuRPgZyRg1tWodszq6QxQxFQy0TrbvwXWEVsbZQ97Yx9sMRZz6
         nL1qohLln+gQshk+b/nP67VOejI2S8yYjdKTqP2Ly2nhWyhViESZvBlsv9/EvJPpNB4L
         65earCHt3alKPtaZYONwh6Y91fzvdzXHTjo4vPyF43JfvLfK4+zA4F2x3lPJUwesdCo8
         av7Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768237215; x=1768842015; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foR6hNjRvW1f03mtiXi331ioQ5S2XdjdkFQrMcL1TXY=;
        b=mlXMFeltOojRG7sF7ExOs2E7JWC2S4jSrPNrV9K7fuhl4eR4591Fc1ZBO6XSr5bvqs
         2GZxF9M1zNOkAb6BdBPaCWifbNT/u+p8OZyRWbogaSmTC0brSmcRnzMgzi8f5EsLlu10
         hdfsYzOM313EEXIAo1vs5a1/yzoa4TyKnsMIOmQXZQxcwsjXbOiTV0dwqPo3GI2sPiuN
         Ov8OmyJPJBG0lcZElQm8N92V22wwKRa30aTJSvTaMjQ4o+1cuk/Js6zyobhHizG2uUff
         abNgWnuuLVUOweZoDY02zW0bHKn06kTk+NCfxO8wxU4iw5+1yRhAvJb+H6f45C5jo9nS
         aXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237215; x=1768842015;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=foR6hNjRvW1f03mtiXi331ioQ5S2XdjdkFQrMcL1TXY=;
        b=gcM20EJiuDNNGXErXBRmO7XCvzImEpC+cYKbFzMX2spg0bOBUiGR5gCuAbeNHtK4XW
         wOWv05Vsy66djgCQ3N6cGIJRw4X5te1D9IgQeyuA/EWY0nq16+j5/poOZF4X1A40W4Co
         /p6c4A4TbvBDT/gL2IIEgDWdEE2W4BKFFq1oKfU2qe14eiwlWI61wh7CEBHsAiIhuPAL
         lX2fiahVNtln6u+cz2Tiy8tIbSCJu+LByC8x9srL456Raq5Xox2pokpw2W5RRSUZUUT+
         eTzpWLyJUeqqyaql+/VhTa+onBk2gTO9L4t42HrKiFTULs2x3H6r23/X6vcwQcXuijgE
         4qCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpngtMbDO2E9J0kKcVSVWK7y160eU68zFClKzNUUpW9+pdjZPRXUh9Eauou+tNrO7jVNw3xRUTCA==@kvack.org
X-Gm-Message-State: AOJu0YyknKQruZ/ZgledLduwGfqfCuWVbE72JleycyeJTt+Dssix8cVA
	Gm5LO+F4Ehhxa/a7j5sQIZmQn82yV5fmhGGzKHp55I/Ub0+Vb/ebIISc4yHNapKr4Ue0B3ozGi9
	o7pVZ0FKh9rxAqjoWmt3/yQwo9zsQFR1HWgF1oiGe
X-Gm-Gg: AY/fxX7YnizCNgekFUTyNbvT8yzHgFQQeJD9i4XhaboBMMQDSvLqcKpgw/07oWzQ3f4
	DDwtyyvkV0pzRT6v71GNFE+H8g6CibVPXjcsdoraHj0Ki1jvgr8XcSAbnKHsEx6t0q1Sft3oWfd
	9iTyNIolYp6LpFWPVxeiQ9do7p7UuwVy2uGJ+LQgPDBnRWJCliIntdvDeiPzlQdPAhh/jYx+nbt
	4kbQwa2ldrj/hW5Cyoe59aV9mLoatAlGPVeqr4dQZxmdzyQpDuBZ0mTUY3Sr4OR0+dV/IKMRtKR
	XIKy
X-Received: by 2002:a05:622a:1213:b0:4f3:5474:3cb9 with SMTP id
 d75a77b69052e-501183f4374mr20963631cf.14.1768237213719; Mon, 12 Jan 2026
 09:00:13 -0800 (PST)
MIME-Version: 1.0
References: <20260109062419.157284-1-ranxiaokai627@163.com>
 <aWMLQkvushKidjQQ@moria.home.lan> <CAJuCfpGo4wYcMChX_xJJ04pHYKJ8vMPrkN9GFxXhW-1xQEmfiQ@mail.gmail.com>
In-Reply-To: <CAJuCfpGo4wYcMChX_xJJ04pHYKJ8vMPrkN9GFxXhW-1xQEmfiQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 12 Jan 2026 09:00:01 -0800
X-Gm-Features: AZwV_QiFJHurWcb7A73sgj96qzQLR2zt7kbsog28kwSnjsSGuH6xCsTcbR_i9sM
Message-ID: <CAJuCfpGABfhi+KiZ9X1pcjby+YZW+FfMfGgc0pfXvUBN88xdGw@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: remove sysctl prefix from mem_profiling boot parameter
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: ranxiaokai627@163.com, vbabka@suse.cz, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 810A9120002
X-Rspamd-Server: rspam06
X-Stat-Signature: h7kxyo7o5w4dyz333gryn8trod8agikh
X-Rspam-User: 
X-HE-Tag: 1768237216-434450
X-HE-Meta: U2FsdGVkX18gBJPNSTAMwV9IbI6LYii1GiD/oQsr+mOLdDhoL846h9KqLU5MpEVABkgvtgGurveXLYwN98S82MS7oqnazw2bgj2KithOBzyvRWc5EjNCQFDtkHKaugHqxWj8sRs2DfRcFf3F5Qn3zBYpAO18pt4J1qftvliVrAVTrJSAmk/9sHIsxdNZTiz82+PyeqqTdUqMvnb5zjcZxPs6vOvpkJKxYHA2Hb2kqJp+9p8j9pe4B38vm8ZaAowGwvvQy9DuMcDdtcKA4V0ao+4G4t/EOYJTbH+YdkqQjlogRpu8wRTSHKplnXq412ZuUcg6xDk6GNSTUA9GhDwlaBOvm5/J7SWo80mdxu4qG+lfMaZEN1fJdMi6E/8YYk9un+efhvK2toZUfBt0ftQfLf8e10RN4WFQWPjYZz31L+QO49BwQyjUv26gcXp8vzadSV5ZdWABtHj1MFesBnhXD51IOeqSVWMG0tISSQXBzXRztKXtVww6sRC2uCI3Pi53rwL3zO1NrBNR99LtBNpsnMQL1lN4X4zNiS8lZD0/zOmR6UjPvzPJKbbR3UiTGTNm2CPJweZRtwixaeUkaYYDrTJRBM0GhwBlW9UrsOB3Y2VuoeJ1GFjbyFKTnYtlTj1b7l4U2BooR6ApuhS+XCh+T0kYt4IrCCppz3csR1YahBWKQlfAXhze8/HDzvzYq/y0ni+3avUgTnh5vBkW5a9NH7xGFkRlfYUc4kJDrudl0EF6udEh5AR8yoGbYV4/hn/3xos01RPqbrR211rz09lnMmLCsQh+UoPoFV+hTUUU9lDMiYHFEeCdbbm/QsSO3WI8/2emTGs7aWN+DeOsCfuncSibCY8BnTy+O+cDygKsTWZzfRleSqT3GDx7rgk0ZUIAMqEgDQn0cbKSXMZ3sbZT88x5RzfGQofIIY3BwoxY33n0GatXFfkq3Fw8pli7rjDV+ffb+yp/X7DZHBBcSJe
 EgNhk6+R
 p1P19UhHDfpwNy2O0amdToiMgi0fquIE3ju8xwMhJgOhxfQpP+H/jMtd9/9c5xuYdHs/HGwhQt487NjxMgNSQ/4A5B+vBuRaKl5XC+BJ+TcNrlrKJD+BtVB6p/a34zTIqExMx8bH2tCXT0q/s/Q9TyZ+UrjZXHGUcRR4oacG0TrWCm1XhOEmOcmim2q/9nbIo8APUOF9K76lvknHFdygdoaC/OTmOevzf43RIOqoOr6qgkTb2zKs03ll75p9Tb8FmOPPMJ/hyGRzfdPpM3r/o4QTvI4x6wuAqUv+GPqVRsUeUKQ+lQ0hi4qHMI+roL3+tauu6BJTyEs51jZpzhLsoPbUUdV0UVTcCGtOctJyX89Y6P1EeBZOQ4RUJdsQP0anOErfImDPXpm8+AFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 11:50=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Sat, Jan 10, 2026 at 6:34=E2=80=AFPM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Jan 09, 2026 at 06:24:19AM +0000, ranxiaokai627@163.com wrote:
> > > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > >
> > > Boot parameters prefixed with "sysctl." are processed separately
> > > during the final stage of system initialization via kernel_init()->
> > > do_sysctl_args(). Since mem_profiling support should be parsed
> > > in early boot stage, it is unsuitable for centralized handling
> > > in do_sysctl_args().
> > > Also, when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> > > the sysctl.vm.mem_profiling entry is not writable and will cause
> > > a warning. To prevent duplicate processing of sysctl.vm.mem_profiling=
,
> > > rename the boot parameter to "mem_profiling".
> > >
> > > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > How was this observed/detected?
> >
> > My reading of early_param() would seem to indicate that
> > setup_early_mem_profiling() is getting called at the appropriate time -
> > and then additionally a second time by do_sysctl_args(), which then
> > becomes a noop.
> >
> > So the only bug would seem to be that the sysctl is not writeable in
> > debug mode? There's an easier fix for that one...
>
> Sorry for the delay.
> That's not a bug. We want this sysctrl to be read-only when the debug
> option is enabled. Otherwise if user toggles mem_profiling sysctrl off
> and then on again, all allocations that were made between these events
> will be missing their tags and our debug mechanism will generate
> warnings for each such occurrence when freeing these allocations.
> I'll look closer into this warning. Maybe we can suppress it when the
> read-only sysctrl is already set to the value being assigned to it?

I think the easiest way to fix this warning is to detect when the
modification is being done by do_sysctl_args() and return success, as
it's a no-op anyway (the same value was already assigned via
early_param). Something like this:

 static int proc_mem_profiling_handler(const struct ctl_table *table, int w=
rite,
                                       void *buffer, size_t *lenp, loff_t *=
ppos)
 {
-        if (!mem_profiling_support && write)
-                return -EINVAL;
+        if (write) {
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+                /* User can't toggle profiling while debugging */
+                if (current->mm)
+                        return -EACCES;
+
+                /*
+                 * Call from do_sysctl_args() which is a no-op since the s=
ame
+                 * value was already set by setup_early_mem_profiling.
+                 * Return success to avoid warnings from do_sysctl_args().
+                 */
+                return 0;
+#endif
+                if (!mem_profiling_support)
+                        return -EINVAL;
+        }

         return proc_do_static_key(table, write, buffer, lenp, ppos);
 }
@@ -787,11 +801,7 @@ static const struct ctl_table
memory_allocation_profiling_sysctls[] =3D {
         {
                 .procname        =3D "mem_profiling",
                 .data                =3D &mem_alloc_profiling_key,
-#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
-                .mode                =3D 0444,
-#else
                 .mode                =3D 0644,
-#endif
                 .proc_handler        =3D proc_mem_profiling_handler,
         },
 };

WDYT?

