Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C187CAC5A8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0511B8E00FB; Thu, 18 Sep 2025 07:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029358E0093; Thu, 18 Sep 2025 07:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59CD8E00FB; Thu, 18 Sep 2025 07:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4EF58E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:50:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98EB7160159
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:50:18 +0000 (UTC)
X-FDA: 83902202916.20.16E6C49
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9C2ED20009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:50:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNMN+wKl;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758196216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cinYAB168v/wb2VrppQflF57ZyFZxmkxcgnsCP7opUw=;
	b=zS5shoWE+TOUESx17Yq7LYdtr8PHdXXbpB9prEBgXppQyYgKxnCv638RcqobVaXFj5U9Fr
	mmODlFQWWLy/AcWs4PnIKahVL7jsmx2xFD6XdjHIH0vLbHwlE3UQiHiyaQwL5ONFxE2bDn
	NA0RY7DtjP4glWTwXJp1S3LSqRdzq38=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dNMN+wKl;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758196216; a=rsa-sha256;
	cv=none;
	b=ezMSZGJpGkfedJGD61Sp6C8/Voeag+fN33LVI8l2NFVT2KjNfq+SVEI6UCaJLDE5Ys+4+E
	IrvsbuxbAvJghwGRqyWF48szG379kZHzcglabjeUOsdIlsNBO4RsW3pz6Sn5TyvSkhJrYL
	Mj5kwUDsDf9binlWTvtXOQhntjnPQZo=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-571a58b385aso1136557e87.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758196215; x=1758801015; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cinYAB168v/wb2VrppQflF57ZyFZxmkxcgnsCP7opUw=;
        b=dNMN+wKlnVr5PjJ1XbFwV3+TKwGIYyI3pLCrqZF5odVEzoZpg1Zc/QT+wLcfbWzQEW
         w+wKqw2L/RBAGAOamYlMJG8PN8H/h2Oc9ixr5Vr0ecWY3t+FDYhSkB/a5ldbXlk50Gcl
         eicDivaxrYkxedNp1XSkXqMwd2nQhfAysYS0KgIYIaeMOafcl5b/4C44i6+LSweKwB24
         WlczFNvPQ7QnhypkaokEiYdmHzZf0vjvsLM0o24L+l4+bKpH7pYB2+sg7D3/a+kAYl6t
         DjGSKSiVLIdzkoGHjIc8UczvwjrNAvVLFjRvRPkxxu5gRQ4wuJD8fyN7j+Vd5VUdBEVU
         XhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758196215; x=1758801015;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cinYAB168v/wb2VrppQflF57ZyFZxmkxcgnsCP7opUw=;
        b=DdXgGMH6JuB1toVuFQEFbHkzCVWb9gbdgCyXpIC94ze31v+fH26RZpn/y8D1PONt/N
         r0UJ4Lol4qIzcVoRw3PlolXBoiZ6/zra4f/iL6eHrHZ+ANLUUOloWLrzQQ5AJGyb6+jA
         63y2nsPu8+GRm6UaaVy1mTsMhtWrscW94IMw/sVDnNLr3Ry/FuPtkpRyJotlEpoHcnux
         CDge2tNP6UT2+7SXPuWlqDA3vlY6ZZ/F3E9PCRx1rKJm5zBq1z6jOkxkSC1i7R6enFyD
         +Us2nsxJ9qYkR5ggAm0eFV8R2EdRbRVvwOLZNkTc4DBZ81NVEBJR0heHPOKIuov5YD2E
         or2g==
X-Forwarded-Encrypted: i=1; AJvYcCXSS5s2nKCHLyZt4HAHiEB6pDTSrl35GmKTOXpsby+lFaHS6m9yXyRZrXqktGpE8M3bik+15SparQ==@kvack.org
X-Gm-Message-State: AOJu0YznfAiG068KixxTrGpx1OX/xXGcSerzF8vTZt+iAl1ESt4G+k9j
	lph7H0j50Vg6cWgEdABey6BWZtdAkZev/bb9q+hhmvpaVmrqF5BaHGmu
X-Gm-Gg: ASbGncuxD8TibdySGJBhwvSZIz9emDiD6ohJGXi2qAIPBLHnrYS7CuxiAbjHo83qdu1
	HF5PqSIP4BVU5ggQINRhiVbtBtddBC/dAYVkbGbfMFYx6TThzMoZZELNZwmsJEANLXSnzCa/gWl
	KscZHp1TsDojm7jADnfABNbBfpbF1JPFn3gUKVDSR/+upv0UBOW7l8kk/FjVbQcSVRyU5hrooJO
	PlSg1FBRmsRAOX9GY8qN8pjfIAuOnHdzYmLWv25fheTdjUxYtJ2+2Psc3wLms5SFyxWamO0ICSe
	1UVTDZsOsaobIZ+maYFVnw2IUR/F5vv7kwNVepJ8cetA/c5pZhZO31MowQyWX5Q9+Z6xPVTCn5Y
	9qQSkB8P6
X-Google-Smtp-Source: AGHT+IGPXawyjl1pf4A0JhR7iwy1/wI6/9VL3klvy4kLXlBQi62TAUdK1LlD/gQhEjPPojUrq+oGdA==
X-Received: by 2002:a05:6512:3e08:b0:55f:572e:2417 with SMTP id 2adb3069b0e04-57799ea9e63mr1847687e87.56.1758196214358;
        Thu, 18 Sep 2025 04:50:14 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-578a68e26d2sm618824e87.54.2025.09.18.04.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 04:50:13 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 18 Sep 2025 13:50:12 +0200
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
	paulmck@kernel.org, Jan Engelhardt <ej@inai.de>,
	Sudarsan Mahendran <sudarsanm@google.com>, Liam.Howlett@oracle.com,
	cl@gentwo.org, harry.yoo@oracle.com, howlett@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	maple-tree@lists.infradead.org, rcu@vger.kernel.org,
	rientjes@google.com, roman.gushchin@linux.dev
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
Message-ID: <aMvx9GKgIWtrkZ_R@milan>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250913000935.1021068-1-sudarsanm@google.com>
 <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
 <f5792407-d2b9-42b3-bc85-ed14eac945ec@paulmck-laptop>
 <d1ef1cbb-c18d-4da6-b56b-342e86dca525@suse.cz>
 <CAJuCfpEQ=RUgcAvRzE5jRrhhFpkm8E2PpBK9e9GhK26ZaJQt=Q@mail.gmail.com>
 <aMpE-oSjtlDU4TSl@pc636>
 <CAJuCfpHQ_JedSRHKKoYXyVzaFOm=dDWzgFZwqerfEC1fn35j0w@mail.gmail.com>
 <CAJuCfpE48n=QM0nY8yE3drqZU0wgC76=70EyftL1WZewEcykyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpE48n=QM0nY8yE3drqZU0wgC76=70EyftL1WZewEcykyA@mail.gmail.com>
X-Stat-Signature: 47wyspyxymydfz6h1rsdno8j7hofonzn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C2ED20009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758196216-269991
X-HE-Meta: U2FsdGVkX1964XntD3LsaB2tU2GVC/O90vYsYZPhf/ckFrLlH/zc1RgT+JvlQOrClDC5UJsORjgQ2GQv9kh5sXPwyGrRAFPYc02B/riqQ2slVdvFz2+s1qgZrZ3haOBGlhkRsWp8lZsqmM+d8RazIq7QRL/p7HuVawdmKkswDrC1Lv+cSiZks9Q+WDZXY3du+5zRGA4p1EHy1gukJFlHtJEGLtUrKQ5beiLcnH7AYJFjo4fos0wYmMqbSxUDFr9f+ADTC2U3Vwc+P1ZE9hrJUsHuObjuLUG70CGd3M6Mp62vK5XF4FAN13mZAOZTNBs5G4vkftBya0AougAx1KDLNtqa5fyYyduEpkn0nGT0QGBq8gOgOtQGJAGnstAcpnBAjUZ0/mR0oIft51r8d0US7/67p/lvoTVYdcha2/9svG0wTPTCsuaKC4XXI5cL6wf0AaOP3GdeitIhjHmq0fIp/aD8INBCcqyzodIBy58hIV/kCPwdXXWGQYDu9N2M2xOviuSl2hDOPEsb/FMZa1XNVQtrB4YkCQIQ1UEogpALOgl7dSaW9Ku8/9J1OqcpnZxBbFKwUqagttK9MHV0S+Q0uficlAWmboHx56OlE0UCHPNpsAm895zbzHCERwxXwObgITXNB3KGRw3k5uJExT6vsnNpentAofoFuJl6JhJAGkHYmlyotblSd8Cb6nrB82m926U2fwmPtUtHjneonhePK37pFobc6LEu20nZASRImmq0FFcWwO04K/ble689SfoSgL6Ss7RcAjso1IW09bchqFS+bliUPd70aqFJFuMIVasBxXgMh79ULwhUM6lkMPlAMSjZ3DG5kxGy2p5F03Ujd1iRpLIH6HVZv0oyRBZzKBXFEx+YtkPcO3jJp5Dvz4S+p3OouiLJzP0M81/pw3CEtH9g3/RG4C/IOQCQg2DQ+MVq3ATZg0pJlq54lkljab6OUMm/zfXjriOYJK9Kh4o
 8S00gbsd
 FJajdr5cWZ9DbG5WORqwspDI8uOW7ou3Q5Y/hGWWB+OIUUMJV5VerCvC9r3pA74kItMM125YpYQmR4LbO7uyAqtmtlYj064OP0Ki5CHtOPwlCTIWva5IGhfmM0InM06oSfasZfJVKYw7qwEa6yy2zgjfGztXNNqCI/hEYNWDHiQ5cRNqiv7iRlQHiEoSnc0/TuHK8oOrD6DkOrUzpgXvpL2te+hiLMFSpGmPguQEASmlKCq22B+kCkvdxIYVIwNoyNOzi3iYOEfzLDkNWctTUDj6o64ZAqDnZpGlfZNeD5MCE+6x+YZEGlwd3uboY+XPRrK1mbDp+0+rYULpQ/ZWE+e83CsUKCnc+qzb0yHSVlGSUVAQRnurxOipFHUsup+FNatCQlP+7+0bISmOGBYDf7KSndc9fGve+qCxSEgfr42a926uyN7n+21jIbLFaKOAIl/Pr4exJslBy2+eaeH2OquRvyhiVPjpwrlWZmzCE8BctpJvIQGesCTG3WDLzOgMDfszPmHtLUxeGQsE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 04:59:41PM -0700, Suren Baghdasaryan wrote:
> On Wed, Sep 17, 2025 at 9:14 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Tue, Sep 16, 2025 at 10:19 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> > >
> > > On Tue, Sep 16, 2025 at 10:09:18AM -0700, Suren Baghdasaryan wrote:
> > > > On Mon, Sep 15, 2025 at 8:22 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> > > > >
> > > > > On 9/15/25 14:13, Paul E. McKenney wrote:
> > > > > > On Mon, Sep 15, 2025 at 09:51:25AM +0200, Jan Engelhardt wrote:
> > > > > >>
> > > > > >> On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
> > > > > >> >
> > > > > >> >Summary of the results:
> > > > >
> > > > > In any case, thanks a lot for the results!
> > > > >
> > > > > >> >- Significant change (meaning >10% difference
> > > > > >> >  between base and experiment) on will-it-scale
> > > > > >> >  tests in AMD.
> > > > > >> >
> > > > > >> >Summary of AMD will-it-scale test changes:
> > > > > >> >
> > > > > >> >Number of runs : 15
> > > > > >> >Direction      : + is good
> > > > > >>
> > > > > >> If STDDEV grows more than mean, there is more jitter,
> > > > > >> which is not "good".
> > > > > >
> > > > > > This is true.  On the other hand, the mean grew way more in absolute
> > > > > > terms than did STDDEV.  So might this be a reasonable tradeoff?
> > > > >
> > > > > Also I'd point out that MIN of TEST is better than MAX of BASE, which means
> > > > > there's always an improvement for this config. So jitter here means it's
> > > > > changing between better and more better :) and not between worse and (more)
> > > > > better.
> > > > >
> > > > > The annoying part of course is that for other configs it's consistently the
> > > > > opposite.
> > > >
> > > > Hi Vlastimil,
> > > > I ran my mmap stress test that runs 20000 cycles of mmapping 50 VMAs,
> > > > faulting them in then unmapping and timing only mmap and munmap calls.
> > > > This is not a realistic scenario but works well for A/B comparison.
> > > >
> > > > The numbers are below with sheaves showing a clear improvement:
> > > >
> > > > Baseline
> > > >             avg             stdev
> > > > mmap        2.621073        0.2525161631
> > > > munmap      2.292965        0.008831973052
> > > > total       4.914038        0.2572620923
> > > >
> > > > Sheaves
> > > >             avg            stdev           avg_diff        stdev_diff
> > > > mmap        1.561220667    0.07748897037   -40.44%        -69.31%
> > > > munmap      2.042071       0.03603083448   -10.94%        307.96%
> > > > total       3.603291667    0.113209047     -26.67%        -55.99%
> > > >
> > > Could you run your test with dropping below patch?
> >
> > Sure, will try later today and report.
> 
> Sheaves with [04/23] patch reverted:
> 
>             avg             avg_diff
> mmap     2.143948        -18.20%
> munmap     2.343707        2.21%
> total     4.487655        -8.68%
> 
With offloading over sheaves the mmap/munmap is faster, i assume it is
because of same objects are reused from the sheaves after reclaim. Whereas we,
kvfree_rcu() just free them.
 
Thank you for your results.

--
Uladzislau Rezki

