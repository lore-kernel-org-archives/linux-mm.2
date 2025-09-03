Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF3ACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78CA28E0008; Wed,  3 Sep 2025 04:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764848E0001; Wed,  3 Sep 2025 04:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A10A8E0008; Wed,  3 Sep 2025 04:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59B928E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:28:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE60A85EF1
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:28:52 +0000 (UTC)
X-FDA: 83847263304.17.62A15E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5B3040006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:28:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EhYOLid+;
	spf=pass (imf12.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756888130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AY+7ko2gNvuN0XuehA6wPYfLN3DvbUbDT9bIC2ND47c=;
	b=Bv/xun6g4wXJ2Ez1EH2dvLVI9Fa/XRZ7XlVmk33+TF1/JRCjdrqj3Tys8M+1TLjZNpw1GI
	G5Km9/jIzCkl83jUfMfSyKgOXjUzf3t+gJhaPf9x6OCFhGe1f1AZSVAfs04LyXVv5vVsso
	hY8pFSR32sKJe+jbLRZGCboCJjFoxpI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EhYOLid+;
	spf=pass (imf12.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756888130; a=rsa-sha256;
	cv=none;
	b=ShW2t0mH3zqjBPkCa3vO8zzAw0HKB0cnZ/uy94LHDsq6poo4WZX0EVOVXmoX4RfjQucGB2
	YMcI04hkCxYnUssj8/oWN3rvLI8+VlhGQ7VUhokAsZTG0QOfvwOBmFgT1+c+KrgglrBVXP
	HDS/7SQhhuelaM1hxEnSRqpyaqXzIB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756888130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AY+7ko2gNvuN0XuehA6wPYfLN3DvbUbDT9bIC2ND47c=;
	b=EhYOLid+EPWJKqvKC82/03tVwUngXRjvK4NaIHKXV6C/1d4SeV6UHO09gqilIboVxeoc/b
	VzheOeRVmbwFd/rNOAdbIq09C76c+NfJrkt8B18TaRn/nQ2q1GKOxZbAL91o9/6KtgydUO
	TT9MPQtkBCLz20avXhqtTbOd0n5cUxA=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-cXLoVeiMNDWdK4oIgqdzzA-1; Wed, 03 Sep 2025 04:28:49 -0400
X-MC-Unique: cXLoVeiMNDWdK4oIgqdzzA-1
X-Mimecast-MFC-AGG-ID: cXLoVeiMNDWdK4oIgqdzzA_1756888128
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-71d603c7e05so88093117b3.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756888128; x=1757492928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AY+7ko2gNvuN0XuehA6wPYfLN3DvbUbDT9bIC2ND47c=;
        b=Cj0sFtjWw/9wdXwNipEBerlzzIjnOd+M/P1hjgb3v3joYBRED2VVK5eTDt+iEVEBE3
         +Kdoos0jGbtRkIfitVTp+CTylKk047DeCvGbqQCHudDrSS4Cp8tLXakApsDmAM4MIfju
         Lul7xf6rDWf19sulD8MQ1/Wo93nrs6dZy+eqt7mxwTFS5gZnysNo6V940bo7I57hrxVu
         yXTL4Jz8cqmN6L0oHUGy/sUsFOgw0iNcRNiVKiV8i9KXFj/HaW3KeCkfzOD+3t6gHE5d
         o1WpHCEuJ1IZD0vMdWAPxyC+wNbqsO5U/YPkI0aNDAHZUdXHJqp8kNTibBYFvhRkiDsu
         FJLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaFBlJhBsOFxkAKTUSTEEQmU/7pvz+JLNbAJk+RXN+MVKBSEHp9gbJNDcLEgqYS1/0UV0dm9/2Lw==@kvack.org
X-Gm-Message-State: AOJu0YzVfk1Nze6fzupg+/beJNlDfXgA9/mmj/DrfeR0f57wsSycoE0F
	R6cS5qJBOkqQ76eGHcg7KZcnAgp91Zi2Vl6RwKj7xvhGOxnyk5OoXMmsYaG2RXdLlFQOGjftrPz
	iT80tUu8iB8vFtXmvAMs7uYOxSuJPV6N6IKZ6+1KxryRpdFagCG1gbiOKI3NyngjJYJylOsixxi
	Gk0SMaUf++8XdOiC/VOK3plJhfRZo=
X-Gm-Gg: ASbGnctuiWMTUsnyF0g8J2tUiXRnEmYoec9HZA97J3DtzeKY+nyMS70sSFKkR9A9dSw
	HWzjpOulR05vEmTQByk8DXtJDPEKTU2S5rWX7z/gH0cpixUt9cq8BcT6QhIkyzS1CYpmis02Nmb
	N/vKGL3KoVFyJuYRMjBfkpxLo=
X-Received: by 2002:a05:690c:7244:b0:71f:e538:9d3b with SMTP id 00721157ae682-722764eff7fmr166457617b3.26.1756888128557;
        Wed, 03 Sep 2025 01:28:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuYG1aLTZAojkV67Ys8INIr4fhAsoDsqd/5OIuV3VuDUxLodstA7ei+5D3jLjj9I8dZDMccgIc3EmQHN35EXA=
X-Received: by 2002:a05:690c:7244:b0:71f:e538:9d3b with SMTP id
 00721157ae682-722764eff7fmr166457477b3.26.1756888128234; Wed, 03 Sep 2025
 01:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <345d49d2-5b6b-4307-824b-5167db737ad2@redhat.com>
 <20250902095250.1319807-1-nogikh@google.com> <20250902154043.7214448ff3a9cb68c8d231d5@linux-foundation.org>
 <20250903090934.4b5479d8@canb.auug.org.au>
In-Reply-To: <20250903090934.4b5479d8@canb.auug.org.au>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 3 Sep 2025 10:28:37 +0200
X-Gm-Features: Ac12FXwfp66OxV2wPvU3kcSifrwN6wBBZVCwf5GBxB_zYjlveqlVWbBCkVqp5nA
Message-ID: <CAOssrKe7CzU3295uZa5OTyfGM4PObvFTL2rm2LBCKSf0LDTtgg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix lockdep issues in writeback handling
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Aleksandr Nogikh <nogikh@google.com>, david@redhat.com, 
	joannelkoong@gmail.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, m.szyprowski@samsung.com, 
	willy@infradead.org, syzkaller-bugs@googlegroups.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3ZLmbzjtklu41rzRce2d0AnwAe9y6x4YogTXkT28DS8_1756888128
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5B3040006
X-Stat-Signature: 5sct4n3bjde77o9d95ea5tjnhbppmbca
X-Rspam-User: 
X-HE-Tag: 1756888130-345126
X-HE-Meta: U2FsdGVkX1+YutEjJGEG8KnpyakEz5ILyr9LssMhOHiqPTz8iNFEnWNbi8cc59iD8pu4ofbVnxpGTASARzPNr2BJCnJBMUCyVeFSSpr5pZcZIoDK3s69msR8Wbxy59f/uwNZenx2QBRhdqVXg1e+uOnE1Dmc8VcOz/shsd761B6PUpEGwY/t2+7Ud/pRrkspDj98R/HL/a4MilvJg6pgW19pnq7Z5GY62xP8gLWRu0l7ywkUPaviNUDqbQUV7wpIctuS3n8/3gahJu85InjlLquJHYutmvQaPY0+5FF7tGAbKEzkyCtL8b8tQVwO7cNInLOtrqgF9lgPId4ysqQjbTmN94b/dEA9J0lT1p9Od1uzeDbVRmuc9GG2R6VHP9UT3Seo4CQhaAt+U3Zv8YE1peoxUqtg/YMlTnx8G1vKIXzoqm80pGMYjB9cD4kdPQs5njZ4H1RCWuPcGTMgDbSnMobOY6DTRpbayTT1BV6wdB+AKq2ui+6TymVCJjSF28PuMd6Rj+1lELYlUYwaI5NMlMM26o791GQ64QqDkeSYakWiOq+8NDM+5pTjh/sNS1PdiVhndlflF9Wfo0tPLyQ5W9F4ILb4zm151cv8/2KQ8MQibpAHAtX6LwgDNWpiaOe8E0V/SSbam++spM50hnMPlr/NH3XCsBjVGGAO8ROoSO573pM/KshAnuDNuIKMu5U67J43ETerrBq3fLQbY0GpisaABXEy9xGI63AP1E6arWb8gKzB9mSYBr5UA1J5kYaM3LmXsjnjgfoi/FIE9g6D99ncYSZb6C5Sn4HIzoGOZQYgwqGSZ+ol1OhEtnCxt8emqaYqJzIBMU0KO99xyUFhRziz8XWGl0b+hzFLBUkSEuGJxZ56RmuBVB16e8fWyCZbjy/177pJr+5j+mztzR8i15o9ZZ/HjBGVI95x75hgYPNj8ZtirVqAzsoHfRdVl7PzVSPreNo/v6hkqOt0+2O
 P39q5BCV
 LeniKdz9HOzNPyEmM/Tuxfu5lDPdzlfIDjanfnckkcGGUD2VL03hu/3VCxtYnPQyY6+xKn50SlsA93ksoEm9ZNupf+8sZTM3XXxoT1fErzYLwaRpMIOtFR5oFIa98ETSmrrIYHFjR57ly9vm/IbD8hTgFqIN9NPrn1gSZHqHFcnVFZHAEkP+pBmqF+rzNPZpO7TeunPDJEGv0qo5No8GTQEgnorhw0tQUkIK5k5HEGMJCl1OllP5KK7COwDI2m+gkQOQWG1yoSUxZYYRaTLzMjm/jqTqu/VOG/EMHA5on7F9/6j/0nQyeHibIxt+0AoeI4i/QGMJGezl9NAOIQFWijdm5yRZ2vKoxGT3Dq5a8fD38Uh/mhPVL7m2bIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 1:16=E2=80=AFAM Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
>
> Hi Andrew,
>
> On Tue, 2 Sep 2025 15:40:43 -0700 Andrew Morton <akpm@linux-foundation.or=
g> wrote:
> >
> > Perhaps Stephen can directly add it to linux-next for a while?
>
> I will add it to linux-next from today (until Miklos sorts it out).
> Note that the fuse tree was updated since yesterday's linux-next, but
> this patch is still not included.

Sorry, I just didn't realize this was fixing a patch in my tree.

Added now.

Thanks,
Miklos


