Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4B0C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 10:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D17726B019E; Thu, 24 Jul 2025 06:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC86A6B01A0; Thu, 24 Jul 2025 06:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE006B01A2; Thu, 24 Jul 2025 06:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AE6846B019E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:20:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A9111319C4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:20:59 +0000 (UTC)
X-FDA: 83698765038.30.ECB0720
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 60F5A80002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:20:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NenGF8Hp;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753352457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYm6W3lhDtWPf0nyR6gtmDQZY04eZ8vBUrCNtxu4k+0=;
	b=Uw4mP8zatBYN2hkcCJUKdvBFAaL5yerpW/8dPQT56xTwYbkHOZ+YlVK5yHZN5kroazn1Do
	CGMoPJVpVDQI30bn/IF5b/MR0FKZesX52A9pFheB/n/I7OrOzv23mX9yiyJKXTI7wEcrcS
	RRVpKn012ljnjTbOESfBu4UCsDMZIbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753352457; a=rsa-sha256;
	cv=none;
	b=ocge/OXqss4v1S2xY/K7qWuGPaNzTCnumgt8STXG5NEOe2Dng7ysFfhY0yxvFgJEwR000v
	yYpHA2FGf8zoMDhEWbjtknUAoj8sO1VkGV9ggdiCEInOvqS24sgw4dz+gcn8vvB31zGv4X
	5rjwqEnM97R9kYzBvllj6BFe4jQYaQ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NenGF8Hp;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6fafdd322d3so8091646d6.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753352456; x=1753957256; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYm6W3lhDtWPf0nyR6gtmDQZY04eZ8vBUrCNtxu4k+0=;
        b=NenGF8Hpghth9dhbUJKJyLeTttcv71u6NzWjwJUT9yo7TwO1qmB99Vnn4VUgWlh6EL
         Kkz6xs/Rz4f6smUfM6jQgzHC3ysuT+0m4ZAVTIbVGtMZwHg7SRwBy/qP8Hd2cNFJ3g5y
         YZ3C4TyLKyRJv/TiSRylkg7E+0GWendSvXTDVxXRV/7qpH9naeBZ6vLHdBYr/qMUAwBb
         0Jg/DfQYwDpm27BB0j1xhaWxrU6SF27WnVgqLVLWdAsjG8BihsbesPiaLRXlFjJgmjyw
         zR8Z2bdZTcW7NLZW60gAEhCepnTOunY2b+nUI+0s6y8o3flAYpNVQOoqJKl6FQtV2s0a
         d03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753352456; x=1753957256;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WYm6W3lhDtWPf0nyR6gtmDQZY04eZ8vBUrCNtxu4k+0=;
        b=bCqpVASz41jg4PTjlZVpsmY5aDbsyQusq/VcmQfxKH8OOQUNYmdHtN+xXivfVtLShB
         H7N+YBsARXPgO1/X6+Xka3jG1jRfzOiV6MJiqqAq3pg3vhH9rMF2FJ8nLjIWPCe3LZmE
         zicq3Ma3qBHFewR9FcT0k9cyqmhoPv0oNhNG9CPGfD8wFECJH1IAyH3UMQ9DVNHsWQmW
         gmq/Zf4nSHufcRLSBe6AnAR20vJOyub1GtSv9WpLF6+mDasdzLB76q6r+0yR7UtHrsn2
         Nv2NPSIo4wjwrrLRoD8cLrfu5zxM+jiKE1LovGRSPyW9nQDwJJLSlpGcRDSbc7zd0inN
         j0Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVCQtn+phh5pQ4dKcoy1rtXUOHu8nBMwNCWIdaV3u8z5m0iF8seHjyV5/dvdvOXD3xMQ2N6YXEh7Q==@kvack.org
X-Gm-Message-State: AOJu0Yzzv5Bz2F1B8uOapveAjujKQ3Russ1CQyxxcx5c4+ZcWNeiXzW9
	Zzk0Wsj4mOpcP9YZutCEfAKv5uC+7zEI8J489BVJELVRufNPOLb5KhYhjqVPOf7GN9nrN5jQ8yk
	KCbrdqJE7aVUPIA2+7deII3w3VNnGgqfsvX8j0IK1
X-Gm-Gg: ASbGncsB0MgD0RzWrVBOr1oJZczbwEaudY+C9sn7iL6OsJafy5UNM56PqNpDijt1ltd
	T6vwvJOnxXH2onDpDTTYiqSssXQ4Rob+QtT7eOaX3EqdjQc3xHb52ZKM7SRFXbK554WPq7tALCb
	YujMJL9HAfUxG/6pQJ3Wxhr9pq6naIO54/uvENdnlRomAMCgfx3fd64TmOwX4pvQJe3F3c1muSB
	IvFxe5pGHgHtWFuFcc2/bhYsHE1EqHfE7uJMseLbamaojwx
X-Google-Smtp-Source: AGHT+IHm/dsVYrorBJCAhcgFQf8u4HKXu0VmjUBu1gYiDjcjTyaS1Vkb5EZMu2Ly0rKWULvfFSmpC24HSdAJiuC+xUs=
X-Received: by 2002:ad4:5de6:0:b0:6fb:33f7:5f34 with SMTP id
 6a1803df08f44-707006ffbe4mr78804786d6.43.1753352456183; Thu, 24 Jul 2025
 03:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250723-kasan-tsbrcu-noquarantine-v1-1-846c8645976c@google.com> <45cd4505-39a0-404d-9840-a0a75fcc707f@suse.cz>
In-Reply-To: <45cd4505-39a0-404d-9840-a0a75fcc707f@suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 24 Jul 2025 12:20:19 +0200
X-Gm-Features: Ac12FXzt-IFrliKGU4TwKEp3QLTmaoCdMeEtiXeM1jbFZZjxX2c_7PM9ohrYsnk
Message-ID: <CAG_fn=UnykD8Sc-8dfkFo-UKj88rdk2j78+AcH8fJ-TOJfFQ8A@mail.gmail.com>
Subject: Re: [PATCH] kasan: skip quarantine if object is still accessible
 under RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 60F5A80002
X-Stat-Signature: fipisq6tmmjcj1juok17fx8a56cpmkrj
X-Rspam-User: 
X-HE-Tag: 1753352457-735908
X-HE-Meta: U2FsdGVkX1957LMHsey9J5QuB2nsS+UkQsGEK/HX5nLQjh+8yq3a2Bga8JJtzC1DyO8f7eb5Y7dDS5mvohKlo5nONvnJecezXr+OtdqQif/8VCAKG5DhTkuXsPLuX2M4baHKeRLoW6eAUfmxR5xVLFroFKHBT9hRR3iYVhHItCcbbVn3nZNrlbqaXNGEmgaYvUaLkm/sRPJBXUVx1iwctkP9UluwqeRkYsOH0tRW9kZHWgjn7xdHTEHg92LZ1hIzXeQm6Tb659v9wJWJ7m/wOqrOKkT5i/0k/GaaeEMmge1nmgYHDPLOwOi4vZswALy+AFjFRIdoRoqZmoe9NICllBh8BTVAGhxihUUzM2sA0XU2pKqFy5t8XOE7FjYYV3xDkMHP8auSMS2dIHOM4qUaPTb7ddLSrKIihSInivoylYosvVwwmaOLrLgaWn/J+yKfQggQRycSLorSU3LQaq/E4F8gA5nWcAXY1XMMf25YZ783ZkRLXxB3NMlFoUINQNh1Hx3RfIWV1r7zKtsnWQS7NPkFbL4h/jF6MLQvz6v5GIWyUUpUx5B9Bm9gy9tVRProYa3ZFNNNqz8YpATI9kiVwce9dAYkJpID3YlsZxwXtw6RQj3DmW/a8529Qe01iuscPuRmkGfQT4ONKyRSryDoOzUYwzghgAZiQ8lDAcZEzgor7sHO80iG3Ka7HFmzX6vZkyBdZnepRYpp+BUAaPP/5gdvNt/9GP7xe1kBXxegMcITKjnQV700kggCwgY7RtneqyZJbWlVIQFqipkENinTtNE8Zgoj3hEZQ6Wf/V+ZJx1TXE/h9kIsD7CyJDSmL4K+Lq59EtqlDOvbnRQE/vSKNQ33k9fAA8x7xbmObzO5llvGryQN2VyS2pcMgpwk0+dH5/gRjpGPpyoW94xSxPn0V28TTHxMhTH99T59vUzFOjFGhhr+gHQmmnBq9rG7WRYXTntZ7B0VVOOlx+n6wt5
 oQLNn7o4
 ZyqMrlY5NLHyg+O81FXoZ+gRLFpVpRSTHfCO8EeNiRcDdFLa3YIR1XWQMgxq1ddYOD0feYodkGMAXGNGKyjxZoQbIoUE1ZPGJBGpyJGVthEauGP13zDAzp+N/ZA/rm+hMWlPswGYcBxOjsOOXOWu0Vd+5miXafkGnltoBzEdrXOtizM7hr9OzZ1AAvOml0eFIK4h13ASFadn35XqGPcUQSers7YQFYld/oKff67u9A7LdcAAP9VpHx+EjNTW0v3ACm+cIa19UZMoWtwFLdSnH4GIcIVcJDQ2W7Fp6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 12:14=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 7/23/25 16:59, Jann Horn wrote:
> > Currently, enabling KASAN masks bugs where a lockless lookup path gets =
a
> > pointer to a SLAB_TYPESAFE_BY_RCU object that might concurrently be
> > recycled and is insufficiently careful about handling recycled objects:
> > KASAN puts freed objects in SLAB_TYPESAFE_BY_RCU slabs onto its quarant=
ine
> > queues, even when it can't actually detect UAF in these objects, and th=
e
> > quarantine prevents fast recycling.
> >
> > When I introduced CONFIG_SLUB_RCU_DEBUG, my intention was that enabling
> > CONFIG_SLUB_RCU_DEBUG should cause KASAN to mark such objects as freed
> > after an RCU grace period and put them on the quarantine, while disabli=
ng
> > CONFIG_SLUB_RCU_DEBUG should allow such objects to be reused immediatel=
y;
> > but that hasn't actually been working.
>
> Was the "allow reuse immediately" not working also before you introduced
> CONFIG_SLUB_RCU_DEBUG, or is it a side-effect of that? IOW should we add =
a
> Fixes: here?
>
> > I discovered such a UAF bug involving SLAB_TYPESAFE_BY_RCU yesterday; I
> > could only trigger this bug in a KASAN build by disabling
> > CONFIG_SLUB_RCU_DEBUG and applying this patch.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Potapenko <glider@google.com>

