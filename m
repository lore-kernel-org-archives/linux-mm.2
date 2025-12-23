Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917ADE6F079
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C663E6B0005; Tue, 23 Dec 2025 04:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14116B0089; Tue, 23 Dec 2025 04:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20226B008A; Tue, 23 Dec 2025 04:29:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A195D6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:29:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 310AF140519
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:29:58 +0000 (UTC)
X-FDA: 84250214076.05.7D3D288
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5370100015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:29:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AEuLaghH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766482196; a=rsa-sha256;
	cv=none;
	b=o8M2/h8f+sbHtv57XQcxg4Q6wYzKdIOVniXrnJNM4fWTAFp+U3CP+IvEsnijPLW4ZN96oP
	HMM3KLu69k2ABsjYFdPKJH918RsE2pMIaD/F53FivLcLcXjAjEKcDANC14P9ODlh9nifKN
	tBoHgNqEjEiFk7OWZ2QnAbkH59QifK8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AEuLaghH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of liwan@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766482196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5+yO63YwLa4flqsofkNkaWk7XgJtylB2duw+RvJS3E=;
	b=5dJgqcFagaf9SeXpClOV5Mwp/VvKGdRnMIaZe6ICDwGs8G51MMvwgJbJXOM06z5+W5uJoY
	AOUXdJTBMCbggSuRJ1A+oX68EuJfH5k0+au4CwoLnQjwO1e53X6D7bSk1WqCjSzhdf14xP
	xNaia9H3Yl2ajWd8iSff8f3fIBbhIIQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766482195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+5+yO63YwLa4flqsofkNkaWk7XgJtylB2duw+RvJS3E=;
	b=AEuLaghHr7EuTc6dWOCsbYxw7TSu4q+P0a5fBW2EwoOf3h6gnpkza3PLEx8b2xFSGsaju1
	M7OJ+yR4qODUf7EcuyKzSZKletiUeWyWhQO8qUVf+/vraH0y00ytN8uZKhLUB9dfLToVUn
	SrTQmpu7EAeowCrAyxgKTfhLR+XUqn8=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-XdlI0GucPnKjsDtCw8LtWA-1; Tue, 23 Dec 2025 04:29:52 -0500
X-MC-Unique: XdlI0GucPnKjsDtCw8LtWA-1
X-Mimecast-MFC-AGG-ID: XdlI0GucPnKjsDtCw8LtWA_1766482192
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b99f6516262so13224930a12.3
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:29:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766482191; x=1767086991;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+5+yO63YwLa4flqsofkNkaWk7XgJtylB2duw+RvJS3E=;
        b=M7pAEWRE+pgu0EuI7sj+rSqbdPVeQCkZC9SJBKon1lLNUgLpsDVKXFR5Gz3hLET7bd
         NGwn8ie/7xLriwrLyR8f9+bqUVFmZeLawaTYZl6GNgda4ICzTIoFaX4HNP9iiQ6edOL4
         Ipp27usqNil8bEQ7z0pPeHUHXnUOxVoSE+LsE3SmZEBj9bP90jo1mVD9mZR+MgFunLB6
         nSYg/jzpg7s/p+u5BaNvaNKGmP8gSLOTLtsVyBnnIJqRlgnmzh5cWO6uha19LVBRT/3p
         h6tXMV0e003HLJCrKOG0bL2lbgH1j7c+5LE+0EvyUYo57irqN9lNRY13Ce0goG2SeEYg
         /jnw==
X-Forwarded-Encrypted: i=1; AJvYcCX8m+OlQIeygFKkgHs4vf0JOJJAPbXkQ1SJUabWEd0fQxYlBqc9TQqaXvZiOIkMtWX8uFiB60/mHQ==@kvack.org
X-Gm-Message-State: AOJu0YxoYSVbTFcx+hSalipxcfqeHGtf/uOqNYc6nTgJJFWWD/6psXzr
	hmTDxypPQI+ZSNnDx4DJjRRF91I9mL/2+u5mQW8FwFx3iPt1h5GicNHJf20d1oET5wKwK95ay+c
	XftoZvYYcnTOkXltSQYyuOazPs86QSU0xbA+ockWZPMqZYZXrHpbh8VApuZg8z4MLOL11OMaV9M
	lkMJnc44rmxC2EyA9Igk81VR8FyqU=
X-Gm-Gg: AY/fxX5vYas/0QVxrswW7X+n+bdoZEbEL76a29DticZ4ih9lMOhQ2LeIyTbwCtsonfp
	o4+yfvUXaF8w6wEOJgRtdCg09j8FVz84e6a/k++c1ii0Ba8TV23N2Puneu/XqVhEAMiSg+CXd4t
	YVbMSvSFeCOMhDBLmVm8+Q2LK+Oqeult+3i9WRH3UTgm4lc3VgVUl8F9beDppoLHCNgds=
X-Received: by 2002:a05:7300:2aa6:b0:2a4:3592:cf6b with SMTP id 5a478bee46e88-2b05ec0281emr11037152eec.15.1766482191546;
        Tue, 23 Dec 2025 01:29:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHhPgrR15PKVagmzN7a6PStvExivEAOucLTLUlaHSb2NA12G5e7NTScTQz7LY2+bHQ6pqAyAVZSFZr/lVtpm0s=
X-Received: by 2002:a05:7300:2aa6:b0:2a4:3592:cf6b with SMTP id
 5a478bee46e88-2b05ec0281emr11037139eec.15.1766482191161; Tue, 23 Dec 2025
 01:29:51 -0800 (PST)
MIME-Version: 1.0
References: <20251221122639.3168038-1-liwang@redhat.com> <20251221122639.3168038-2-liwang@redhat.com>
 <20251221221052.3b769fc2@pumpkin> <CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
 <20251222094828.2783d9e5@pumpkin> <CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
 <20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
 <CAEemH2dZ3DxDPWuV1Uze213CqoFHec9kK+MeteigGANYTUzbqA@mail.gmail.com> <20251223084035.67ba1b76@pumpkin>
In-Reply-To: <20251223084035.67ba1b76@pumpkin>
From: Li Wang <liwang@redhat.com>
Date: Tue, 23 Dec 2025 17:29:38 +0800
X-Gm-Features: AQt7F2rofrXsNRAbOaW8CCv-eBKvwDj-FJXSisJFaKR--ywyBYO5VAjZBdVePmU
Message-ID: <CAEemH2e3C_oor-CK3_35m-gAp6uU5+75up7sL0wfX1MZdh3+jQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oS_VyLn34HpVR4kGExPT3wCh5aDexP4F3SwzxONqHjQ_1766482192
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C5370100015
X-Stat-Signature: t8qf538u785kzy16fwdnddds8ezmacpj
X-Rspam-User: 
X-HE-Tag: 1766482195-863885
X-HE-Meta: U2FsdGVkX1+W12nPel03sW7dEBD4DtMKrOFZvivRwpC5FaxOwJtojmumld3YqHQgGDcf+yk3orrCylcU+LK817LCzefn4WwAjG6314q8bdx070Z9NFuQGl3lci0k8xaxXfS5dIditvBPYKJijWlmZc+ckGr6YVg29vy5kXU0GaUvZ5mbs/7ijGsD0++iPXAnC4ZfZyjferzobSNbojed5bWgCCdV1vkCV5F6m7q/qsLzjkGYkDrUzXR58TkQddEyX1MNaM1lJNVHCpVCP7KADtopIu01K9yEoG0KdEAqZHVwSYMYU9CJ9QqDgjZ2TcmR2Foo/Vl0OvjuNYI76D8dnasmu+wKFcXXnVHptif64yV1vO2AasKkv91r1F7HqPDZKGSff/l/FT8e4VeNGZpTYo57PbJrQWBDQoMl5vVFMdzYAWxfwGLbbJe/pOm+B+q26ftOTtFMRqjGfkLC4pzaIDvXEDX3+jZTPvb0luMCyCa+4FEsl7JDpZ62Ml5MwSxpQfb2FAIMIAFFyWRs63IARtBPZAENEfsWxyGaqF/u49zTfb9lV2ZAwhh5Y3G1lsRllHnrek+QWQzqocvAsrYhwqlFJQhZY8pKCJCILrSPf/4F6N9bzMLEV+C4pFikXWBrrVrrSwd9H9id8W05T1AMWX85/FxGxHddP/n8yx23xWozOT8pdSguTnlo4p4QryXRRDI97SnEX9j3A+YhPY1cfJUOF0VWW15mISvJXcnyF387eb+hCrDPNIL6nGK+9Brm5t8siO2haFxXMcX8tM5rvhP9oJZ5AdH0KlsMjje3eUA6uTgihJdIZOkHK7NSWFQy9HrpSm1l1M84TAEkfIQyjt2zAMu3jkfwF1MY0AmXSI+GGiEE1kt420TbycjFWawt41uWchJFHQ3nJm5Xtn8NDG6o3a6rfN3Vs+g1dbUpn8hxgell8DKF0k+eF4MooUnuY8s9/g9VSLSzS+bzrXH
 K6sx7R6J
 WmYF48mWDDjIXVCoBJl2gW2SLXMwwTPJD6PJAXWWCqaRXRtTtedayn8TbLecIXLEzZiaTPj+x0UbDply53l1f5dLXMJNGozHyiahh4oGLHrKWAQgm97I+1eMu8ZIP4+ZF9+VTD7zai/TRCqhFP0dbEsTFE42V7w58DATtgKIP5bNJP8+Re/wSOsBjwZtvkf6Rj7DovPqDBWNXQok+Xtl1YV0d1fA7C592r5WNzpL/+NCH1O/mnGuqsgVdgIrnVrnGkcg6LJoW+udQTVFRbqXIdxjXW39h+pjB5vNMF3HvZVRhP4txsB1SdyTq6p2xL8WwsEypJGyR34O4ObrG+psaCg/0+YU3cWppjW/0VCzquKF45BGgF+krqhWFMpRYGbofZv7eTS4IwNnzc8/ovCcP/yw8gUv5weOsZM7Ws6zs8azutFZ9ERNmUDJIalyhE5qG4hqBXJ11JyQzpL+vaYXEgbJZpLp2YuN+jRUPfCpnzvE1n0djEEDRZ11n4afb33kenBaQJRjgHRivXyrMA1vrOolGzrEypLLlyg/msTX75DeiRTDrIi2hmBXHUNL7So/IOcm8LP/UoDhSN+ev1cFCHEhK88wzXZQXm1kqUnN1Vwrf5NA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

David Laight <david.laight.linux@gmail.com> wrote:

> > > > --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > > > +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > > > @@ -86,10 +86,17 @@ int main(int argc, char **argv)
> > > >         while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
> > > >                 switch (c) {
> > > >                 case 's':
> > > > -                       if (sscanf(optarg, "%zu", &size) != 1) {
> > > > -                               perror("Invalid -s.");
> > > > +                       char *end = NULL;
>
> Initialiser not needed.
>
> > > > +                       unsigned long tmp = strtoul(optarg, &end, 10);
> > > > +                       if (errno || end == optarg || *end != '\0') {
>
> I doubt that use of errno is correct.
> Library functions that set errno on error don't set it to zero.
> The only test needed there is *end != '\'.
> (end == optarg will be picked up by size == 0 later - if that is actually
> needed to stop things breaking.)

Good point!

>
> > > > +                               perror("Invalid -s size");
> > > >                                 exit_usage();
> > > >                         }
> > > > +                       if (tmp == 0) {
>
> No point checking for zero before the assigning the 'unsigned long' to 'size_t'.
> So the result of strtoul() can just be just assigned to 'size'.
> (Ignoring the fact that size_t will be unsigned long.)
>
> > > > +                               perror("size not found");
> > > > +                               exit_usage();
> > > > +                       }
> > > > +                       size = (size_t)tmp;
> > > >                         break;
> > > >                 case 'p':
> > >
> > > Geeze guys, it's just a selftest.
> > >
> > > hp2:/usr/src/linux-6.19-rc1> grep -r scanf tools/testing/selftests | wc -l
> > > 177
> > >
> > > if your command line breaks the selftest, fix your command line?
> >
> > Yes, I am ok with sscanf() :-).
>
> What was wrong with atoi() ?

As the patch summary described, write_to_hugetlbfs previously parsed -s via
atoi() into an int, which can overflow and print negative sizes. This
problem was
found on our kernel-64k platform and

 #./charge_reserved_hugetlb.sh -cgroup-v2
 # -----------------------------------------
 ...
 # nr hugepages = 10
 # writing cgroup limit: 5368709120
 # writing reseravation limit: 5368709120
 ...
 # Writing to this path: /mnt/huge/test
 # Writing this size: -1610612736        <--------

> Or, at most, strtoul() with a check that *end == 0.

True, this will work as well, but as Andrew pointed, it is a tiny test issue
and also resolved by sscanf() so let's just go with it.
(He has added patchset to the mm-new branch and queued it for linux-next)

If the issue remains controversial, you could send a separate patch later.
Anyway, thank you for the review comments.

-- 
Regards,
Li Wang


