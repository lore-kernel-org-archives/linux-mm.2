Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02ADFC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9AE6B00A6; Tue, 22 Sep 2026 01:59:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD12D6B00A7; Tue, 22 Sep 2026 01:59:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0496B00A9; Tue, 22 Sep 2026 01:59:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98E7F6B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:59:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22E0DC038A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:59:10 +0000 (UTC)
X-FDA: 85240345260.09.385BA8F
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id E56A420005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:59:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790056748;
	b=i0ukMZ34cb4KTsg1XG7CuKXYAnHam8YWbDwinJTYBEG7Eh2UeRWHUd2eYimMQQCHZD5mXW
	KIB542POn7Kis9AmLStFNakHtWRjAtTsGd4oUHkjsdJa/cVgFoAd3nIdnJfbh0J1jgC2m7
	03u1Bgs2T3eADiKFtLPAbQy8ga1WBNE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of clx814727823@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=clx814727823@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=black-desk.cn (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790056748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zxmsk/EJ4w4QHvprrsLgwa7ofL6yH0BsSIWlOL221Nk=;
	b=yIXJR/rBd5BEdMp4Lg9apuayjwP4/lIYsqM8lAaO2Il/eDd5W99cdw9701wktve7IutJ6K
	/v5UwRBbr9/FTT4tEEr77dbD1m7ZhWcjrayQQiJmsmEWd8OsQ6Xi3Xct8WXza/sSA8uhvi
	ZybsyEjTx5Jxjoqv/wqIk1dHkktVFJE=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b8997bc6e6so401137e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790056746; x=1790661546;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zxmsk/EJ4w4QHvprrsLgwa7ofL6yH0BsSIWlOL221Nk=;
        b=N80wNB0Hi+O3HXA3u017F/utP/UqmWO9LCKVULo+bdF98GyzeIg8Z5ocNmN2PSUjVo
         XQF39cQrydEbcJ99bvNLiAG3RoCpX3zSj6EU6fGMzMmP2ghOTApnzoIZZ+cEpY8Z5r/h
         J/ZgpJSSBM65CGdONTKpx2j8tQY9WZaFKIvGErr+ehAhuUhkLWa3ig/TlzBlstT9H7mI
         vAeSOAj5wcq5Rj/J9qkktztnVg5xalQW0iC8WJDrCbsVZqibljzR2dLpjzMbXgZIiov/
         fupntJ+njurc52VyOvS3qlbivGrCDd++fIsf4D5zcVPAruKCETGnP2HE9bPsrYVNS1Ca
         y7dg==
X-Forwarded-Encrypted: i=1; AKwUvBwum4YLD1Cl7vGGwxw0Rg2+IgAtf0BDSaSkE2uS/8g1swk46ivcwPJB7Qd6FbTwKzvZjMlJdthSFQ==@kvack.org
X-Gm-Message-State: AFuF++kVk4EsY0cH3t+Fh4bkH/OKjnsBUVBqg+uZvx6nXEeRXOZte6EJ
	ffsYH/ra1NcephR9u+gyZB5JEc7kHF5wQMKK5FLb2tcVDOCYN+94sSzvp3HIeRzui4Yt0Q==
X-Gm-Gg: AYBFou0zleM10ZSc1unH3o9j0q0lYLXSSn1xnRK8SR/SiEodBJJPkpsKWRXBM7m7ZaU
	X8MSOMFztcLRQeIN0GTeKVYNUzNglyQ3gRBuBfJz9JYZD6V0McfHwDjL5KUrG4pBlStDW+liqm/
	sZiI3QRlpYAonIcwNL0J+ZVZJbZypOpo/PdpiuNtDYsp1Y9E2+8Vkc//6Pe4sEKtiJ/Skb+G1OY
	YWFsXsv19gi/d4m5Wt21iKF8Y2jK8vKxMFFGBLuA9oz5XMom+t555hhHLk22Kn0UZezIm2NNisT
	pxfSqcOFDT1LvMg3ND8xo9ZRxAwBizPppbbBZaC6G8I0ZKYOdsqoa4/+Rb3vvB9DCGByWV+c9H3
	A8Daz6Jn4MKChwgQUeTXSTb2OnZop3oLpMupGCLtv+/qwQsA+eYa1QGVEAJt8rF501BU8lYf30k
	h+15p8OdUMBcu8JIj4guGtb2AOliZK117C6V7MGEKVa/LTtA4qSuM6w2bewqPN8lTtixNBKyDe0
	fPFM+vmt5gVoq16Guz8ge4sP7WCWq0pO8vJKffaxnbAECLaugnivCQt0yy7lA7D
X-Received: by 2002:a05:6512:4059:b0:5b1:5e19:c496 with SMTP id 2adb3069b0e04-5b8d28f856fmr432816e87.14.1790056745967;
        Mon, 21 Sep 2026 22:59:05 -0700 (PDT)
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com. [74.125.229.205])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46ed2bfsm208816e87.76.2026.09.21.22.59.05
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 22:59:05 -0700 (PDT)
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f1e428so1282996e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:59:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwZcFb7r+0ebfexZftzGS8X85oEfJg3vIBRnwb1hokMcUEFiWCiEXj0QKeWa2wUhr1hglxegGlQEg==@kvack.org
X-Received: by 2002:a05:6512:220f:b0:5aa:62df:cd0f with SMTP id
 2adb3069b0e04-5b8d28f3a47mr500408e87.2.1790056745194; Mon, 21 Sep 2026
 22:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-pidfd-get-paths-v2-1-c59ea6a21b72@black-desk.cn> <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
In-Reply-To: <CAG48ez3vJrbt+qYh5b-PYxmr2txcg3DAKDRwmBwVzNhRB+8Ueg@mail.gmail.com>
From: Chen Linxuan <me@black-desk.cn>
Date: Tue, 22 Sep 2026 13:58:53 +0800
X-Gmail-Original-Message-ID: <CAC1kPDMUT6pUarj-ohTGB9=5u=7osk+8bvyyAAjStsJN6Z3sEw@mail.gmail.com>
X-Gm-Features: AclHuK-ZUoiNUpNllD9s0TdWDgkEMFXuDsvm8kdoP44o6gMCMaHAEIjZzTqw_NM
Message-ID: <CAC1kPDMUT6pUarj-ohTGB9=5u=7osk+8bvyyAAjStsJN6Z3sEw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] fs: Introduce task path helpers
To: Jann Horn <jannh@google.com>
Cc: me@black-desk.cn, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E56A420005
X-Stat-Signature: ch55dr8m3skx1x7h9gcw4urht5poejep
X-HE-Tag: 1790056747-337922
X-HE-Meta: U2FsdGVkX1+GKZfgm7IAEn9a4n1/2l+ztN8mTGzoYXi1kfnnKUrY5Zo5tgudWX8UxCzL8WYxKSIKlHLRtHokO3Vo6JZ0h22HqONra/hGpIqu4phWslumDSmI2n6XkPYau6XWOk7u7hoe6CSM68biChFbUaV6NrarbuB/1S+vpfxOg+qx23PkgcC3qjSoDJohhs8h92WPu3oZJGutcigIguL+yyRzMxu65Ubczqirt6pwv+suICYEMIS9uz3756YO1nI9Arkt9OVXQPR7/poNVlyY+ek5saqM1koZqL4TPxmw9tZ/HeyMorYVxFTKgmqrpW9f07GjSP1uh54n+yT7LGvw8G/Mjem/1p+Q+GXCfNyRra+eUYwR18EvER+Vg9KWtrrjZNm0iKxTcJbWCvZF1n3HvvRmFOX7juu1ZpZAUrZLXKGeoyknFLN3JPoUEv7VNkf2yxwIFf6Zaro3DBM5yr6h/GVQCnJ+H5+7lM2R1nfEOlwZMDXMWCtfQcl5smMXPLLHR7KAIRRp8ks6PcG19/yFlJgIa+LJoqAgOcMiEST3JGEAbUwsa0Rwbf+UogxfZwz9GDaD0MlxICfWAn2RePe1Vb0HPS24yoQUQmVsTln/w7uQLyrBlytI79IVPMreB6UKerhFK8ZAGynkouq2t2rGxrDXSy92x5szcBeUKq2kd5IjWpgJPQjYbK1D/1MyzWupL0UpqEeT5Kpum+YOdwqBlMHMuZMLLneriUEJ87ghDlQKhWzaygET7cVrzDKM196cBgpDJnMXHGC7LVU8jYl9HE3VoaPgcKIUdTQNB3NxHxFjhaRBgPFO4DukbDdafVOJGi58KVHuZq8809CVJ2ntSuBppV733ttzpNxQYqL6SuJFo+WvbTIogL+nCkoILQiUsICakdDEnJ0lJVKL87wwBXA3SnoqClW6JDXMv8JDM6qwAJ7G2j8LysSLsIWbpC+4GsGQCT4JWKCu2QO
 Qy1KXW+5
 odd4UHSlC2ULJWrg8UW6z7awrkUJfUP0ccMB8JNigCBQtH4ZQjljONOQOl8i5rY8K58bmHSSp5kgzhtYClRI5hh4y8Qsf2IRJs8h+1UIz6ORXR+0dkz5Mi9bvrWXPSHGoAspwa6nuN5sDbKcLKa/3xdiaUucrTmRcH1xwl7wY4mknd8Qx3MwrlTx6pYB1kcB6eI45EBKKraaep++S5eIQGpVHof9S0NRl06lbPDbr7DOfmxGe3PF7sofA4RRXVXA9IBVt1fsy9Sd6jZ7ClOfDD/VGVAAuadXM5f2rAoV8IbXOpTz30MLaEx8I7UAWQJhixOgdFK8ssaA9vF2byREKYjrgKxAxOYPtxkb6wT7Ya0hR+sFzRbYbNefnTTu2R1uxALBWgoxr/++soostgo58ALnMB6WOvbG5D/2N83k+7SIkCsvTszvJr3MUVoTKJkJhFE7wR0swcluNqR7PAlpPBwc1mJA1l5xSBhwB85Jq7s/ghes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 3:21=E2=80=AFAM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Aug 31, 2026 at 4:59=E2=80=AFAM Chen Linxuan via B4 Relay
> <devnull+me.black-desk.cn@kernel.org> wrote:
> > Introduce helpers that acquire a referenced struct path for a task's
> > executable, root, and working directory. Reuse them for procfs task
> > links and AppArmor executable-path handling instead of duplicating file
> > and path reference handling at each call site.
> [...]
> > +/**
> > + * get_task_exe_path - acquire a reference to the task's executable pa=
th
> > + * @task: The task.
> > + * @exe_path: The task's executable path.
> > + *
> > + * Returns 0 if the task has an executable path, or -ENOENT if it does=
 not.
> > + * The caller must release the path through path_put() on success.
> > + */
> > +int get_task_exe_path(struct task_struct *task, struct path *exe_path)
> > +{
> > +       struct file *exe_file =3D get_task_exe_file(task);
> > +
> > +       if (!exe_file)
> > +               return -ENOENT;
> > +
> > +       *exe_path =3D exe_file->f_path;
> > +       path_get(exe_path);
> > +       fput(exe_file);
> > +       return 0;
> > +}
> [...]
> >  static const char *get_current_exe_path(char *buffer, int buffer_size)
> >  {
> > -       struct file *exe_file;
> > -       struct path p;
> > +       struct path p __free(path_put) =3D {};
> >         const char *path_str;
> >
> > -       exe_file =3D get_task_exe_file(current);
> > -       if (!exe_file)
> > +       if (get_task_exe_path(current, &p))
> >                 return ERR_PTR(-ENOENT);
>
> This assumes that when get_task_exe_path() fails, it doesn't set
> members of the path argument to non-NULL values. That should be noted
> in a comment above get_task_exe_path().

Will be updated in V3.

>

