Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CCCC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301BB6B0005; Wed, 21 Jan 2026 11:22:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284FD6B0088; Wed, 21 Jan 2026 11:22:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167856B0089; Wed, 21 Jan 2026 11:22:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 035286B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:22:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36C8D5A76C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:22:03 +0000 (UTC)
X-FDA: 84356487726.03.677BD07
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47875100012
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:22:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SMQ0D0G8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdVLEMD28EfX+5P0zrv2LIUEohcfDySK6bn0IJ0lRR4=;
	b=QWDcvp3iEd8wq02+4sOFg28u+5yGJablOBE59+T8Tnw8u+l+zOijc5RB/1aAx6fGj8AtSp
	5fX722ETkPfq1LdNCjVFbtvWUJERujAia5RE4oBEiD243XZz7zWzxnyfT9EYVGYbiQn0np
	u9+E4J/h43s3YepHGREuWmqWASiOa6o=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SMQ0D0G8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769012521; a=rsa-sha256;
	cv=pass;
	b=6Mo/CUpuR4PBNPYJ++hpolLIBjJT2rVUAthotampgPcTK4frf42lY2DRmEopKwD/kccS+G
	GO2d0dwBtl6kfSlVf9GvewwNbZsJNH9z5nI+Lq7pQTrpx9022jDexMB2cmxcbb+TmdMjej
	lMNvcW7g57zXZBLgDFESkHKyBzjtKjc=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-501511aa012so115701cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:22:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769012520; cv=none;
        d=google.com; s=arc-20240605;
        b=P4qOZjOZ01pAoG0qskm4uVnd/n/l65+EH0wbGYw9sVWK4QvqF9ptSnLpL2iR4AXMf5
         5eXuhxgxd864XJumJZQC/ldWhBN407OJ2sYewAmyzeaGrB9S8Gx4nNCLchCLctryXx7D
         DQ45lJrSifmyRnQOw5ZiKViToehIqcAuWlYrhDJkWbeS+P09iRsci1OipZyqbAy/JzkF
         aOCvjaWn1sAqQUm1+In+0SEFxG5aEjJ6t0//uYf/RTX4hbc9dAJ15762J/7KTokqG32F
         5vD+fVCUitZ3m9M4b3MYuE/AiQENeT51Awspwc7E0MoSDtz1JNHHBgZTiu87hy2eVj9M
         dW+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VdVLEMD28EfX+5P0zrv2LIUEohcfDySK6bn0IJ0lRR4=;
        fh=U/Mq1+P82U13ahNuiBA6nru5liHh2Y1MD959aHvWQH4=;
        b=TPFi+uoSHN8h6dBosuY7m1YuhzZyek9T49wC+92jjTNPfMKFnwIJFofaoJJkYqnekP
         tR3HRuasFiaCyzY4OYgfos79OR2LE5su2/a11F2irwVRT42SUwu6J1/LOoqAEHUJUs4E
         6rkA1dvsMHkzHo/tcca/jQoHejNOVxxv6l05o37TYKzh5hEGo5SM5vcw3h7T07gYHb+0
         4jl/a5m4kPZ9evE9WMyiCQEq1CtDCq1Bs9+fOkeGQtowiPVHRc0PsnNKs5h0qFuZpUCZ
         JV+wjOMXSADqOikxC07DoWy6TevHF6Gt2K7ASxjj6HYO0KY6gvuFmklWCLYLmkzRqaOP
         SyJg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769012520; x=1769617320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdVLEMD28EfX+5P0zrv2LIUEohcfDySK6bn0IJ0lRR4=;
        b=SMQ0D0G82s6LyPuM0C83s5NSNdoYnSJBmwCdfU/sDNgLJK1zGmfTsBG6PCfP7ib119
         fZk9d1b2rJpPKqOVJODTVYHHyM70YRXszapTT4WPQNr/On+WBTKBdy3DIoI/idaxPC2m
         aZO2MJjaRQ/XnuTud9R3vw7q2ZiM2rzmWbYbLOuKG9SRDvWiswPWCRtUGM5YzHRrMoqT
         xnDq5w+JorS8dAsrZ+kaJN89ROUXP9o9ZYcQogkgThjyP9zC3Eqf2mfXeT/xxcyp2sHg
         3tV4QreGIYkrFwpSRSj4QRetAjfBa2KWut7Lw+j1+vQmSVl8aTRFi1SIu/ZAjUUxobyc
         mXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769012520; x=1769617320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VdVLEMD28EfX+5P0zrv2LIUEohcfDySK6bn0IJ0lRR4=;
        b=WLQGLWI/TrbA149H/axCl+iKIEuKOf3VrwoHlX+AGbNNwA55rbj4iQSGxKJZ7foNhT
         dQbXLx3FJAbHEarvcOE/U2etDUzuq2aCYjCCbHzXlW+o+ih6rgKDppIqen0fWVzz6ecU
         BNjDjLSRrPxqkmHeCRDSQL+Jgw/W/wIDGQVhMiDt514YSMtQumRuA0DwJVSIj/ML6eUz
         Lnaw4IFZz82VSjlVAgOMrM2zy1K/rAIfAzCQ3HHs+jxxH3UO4WP6u8n9jIAhww7cKkc8
         a17q+HGShYkfbZ30PxLMpNmHSE44s8DeMwOwivbL/3u7ec6dBdKPUB1NZ1FG7rxNjZkV
         fcmw==
X-Forwarded-Encrypted: i=1; AJvYcCU56O0yCh+zgwE/20n9rzUzUxvakvoSfVI9JOhbI6jcir06Zkju7ofwfqjC4cgfPoUwbSzLtMfaEQ==@kvack.org
X-Gm-Message-State: AOJu0YwmwFS1VkdNjL7FUvsSZK/zFZZyxPnA8WWwVWUiQDZVB+AXV46N
	TlAEyQl10U3qCLWkM2b0vYQJX+pZPoov30UZQT1rrQ9pPMA221JeF9cQeiiq/JRUZjTV38dKI7/
	DK0neRyBk1TimTFU/qdN1G7UwFMstUIXyou/VRDa3
X-Gm-Gg: AZuq6aKVDAf9UUT45PxmKXXqyHp5/EPNzF4PtYC7+zRVi4PiT89UBQtNMYJRsNdH9sI
	V2w8ANdTVEI+y1BJpFlpymRP0qXO0u1KPLzzit6AFUv/keKvmBJeiFT8tT1D4s9fB9anfA/X0DU
	MIoWHhmo86q6f3sxbJehcqHhs5mdY196pofQvFpI81aU9rTMINOc1hWID09IuSWOi4E5C2X9kTF
	qcEnlPVkn9cxura+DW+NlK+Pf1amj8r4OH4UoQwoz/iD4KKTh3pPNenDNbeYJ5LuFwU7OWxBSBe
	scOWMrHyaqn1ClLSYiHcZOQD2OphMHVJAg==
X-Received: by 2002:a05:622a:1998:b0:4e5:8707:d31 with SMTP id
 d75a77b69052e-502e1a7f7b3mr11247441cf.7.1769012519794; Wed, 21 Jan 2026
 08:21:59 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-11-5595cb000772@suse.cz> <CAJuCfpHaSg2O0vZhfAD+61i7Vq=T3OeQ=NXirXMd-2GCKRAgjg@mail.gmail.com>
 <aXAkwLsGP9rqamKL@hyeyoo>
In-Reply-To: <aXAkwLsGP9rqamKL@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 16:21:47 +0000
X-Gm-Features: AZwV_QhmIp5S8mEMP1h6Gx-TWCdfCxovy5QQV_d0u6153x3grZV0j2owhClsj2k
Message-ID: <CAJuCfpFiLnvXF-yOVmLDNqQ9ZoJC1uKz3J7UNawhp5Epev=eNQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/21] slab: remove SLUB_CPU_PARTIAL
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 47875100012
X-Stat-Signature: h6yywfnec8zsb318yhicesgjkfatecyp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1769012521-818810
X-HE-Meta: U2FsdGVkX1/08FX7OgFzXSDPtdXLWaiUzwtPYwxCN6dIG7GjT7TCMGyg0O1DZxGjksReCn+ZKuoYYYzB6gQZtaql2aqR/S9PJKpz76A+cek2fxp9K++0/yp4GlkH099vPA10c4siTzXU33VNOO1DTpFyoSDJvfD5XaKbmSTLZo5PzMKjMV27vyhUfUI46SkaHViprvBo36inu36JnvDS1F0AKnEyVnzjccE6aSqOYBHMGyP0e4K6JxbCXGWWIcOpLx8vofl85Mj91dhyzOrQNwlDrzl9LAm8yyolZZU4UmVZZIPUW56QEvTN0Ctb0/WxfzVEuh4RqlRVmG0zK+2yXdk6u8T63hf9G2W/lQ/9pjuc0C0tjQkD1FYTDFJUrK2yJHVHc5VY9f9YAr7fPj5U/tX5gcOewGt45NEhYMINBVirRJIOKZivRUGvgCpnhNaLKLtmTMXKJRufVOBsn2xCl3W/qgXIHtUBnlcbA1j1dJYcBdD11MssjV7ul7kS8eS6JtxdOyGuGnCgiHf2ELomnQYQdEX3/y7StfnFXOuIbcH87i5JxTbe76cgLiXHWRCsBhP9fWxIBFniRejPZHWVX2zHEQHqFQjsW7789S9/8+HASUIGAHgU4GZV7xNYRreZcAS427W9ya+BKjnyjLmwbnfV7xPCfnt8il6hM8TPfUlozzYk50kHo6yAN5srCp0kXhQKNpJ1R7SQFsCbYBhWnmJMtDoP3mqcCuzNhu75k03PvMnoi66m1L4Hm9Tu1Q8yUwCPNi9+PSF5m9ux76E8/zoS0D1/NXcq9LP1l0wfSZc476e8+TvSFldGlCNkOS9vQvgtmJD+waGXMWdodxGRH28IUPd7bSkDMryAm4baY1T+6gGRLeg4lNHvNlH51ZiRsEHFk6TZctye7E0R1h4ExTnJPReoGAcWiw1snQph+91sgqJaa+JzfMjqasJvFssde8yEhwd57bCx4namm7h
 bOy1mAKf
 Dl3Mf66xS6WELSeSbIbKEv/7nG9jk5PrcmuQVNyNfUuGvb6HiHUHIYBYj3w6dz54FakrH4UEIGe1PqyPXASDgX/04IDr/j6dn/8hyeRiXVphfb5TTQOu7ukFVHKnAayyai9w8IWMNHif2qAsbpO3d5kbKtmkdYenMp0g48f3L0QQfT/W7FgvCHTVZAjrQ/Sr7Dd4wdGS1ve3TItrgSjkLwdrxs4dO4KiSuwtye5udbiD9gx/XUVv3IcQrsuNxV+RhhFyjDOKHqDOlTznbKp3vEhAdF5Cuc7+l/pShefAWuVVybxZndGL35c5Mnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 12:59=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> On Tue, Jan 20, 2026 at 10:25:27PM +0000, Suren Baghdasaryan wrote:
> > On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> > > @@ -5744,10 +5553,9 @@ static void __slab_free(struct kmem_cache *s, =
struct slab *slab,
> > >
> > >         /*
> > >          * Objects left in the slab. If it was not on the partial lis=
t before
> > > -        * then add it. This can only happen when cache has no per cp=
u partial
> > > -        * list otherwise we would have put it there.
> > > +        * then add it.
> > >          */
> > > -       if (!IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && unlikely(was_full=
)) {
> > > +       if (unlikely(was_full)) {
> >
> > This is not really related to your change but I wonder why we check
> > for was_full to detect that the slab was not on partial list instead
> > of checking !on_node_partial... They might be equivalent at this point
> > but it's still a bit confusing.
>
> If we only know that a slab is not on the partial list, we cannot
> manipulate its list because it may be on a linked list that cannot
> handle list manipulation outside function
> (e.g., pc.slabs in __refill_objects()).
>
> If it's not on the partial list, we can safely manipulate the list
> only when we know it was full. It's safe because full slabs are not
> supposed to be on any list (except for debug caches, where frees are
> done via free_to_partial_list()).

Ack. I guess I'm reading the above comment too literally. Thanks!

>
> --
> Cheers,
> Harry / Hyeonggon

