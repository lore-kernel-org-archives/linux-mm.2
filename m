Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2804EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E150D6B008A; Sat,  7 Feb 2026 17:17:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2636B0092; Sat,  7 Feb 2026 17:17:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF97F6B0093; Sat,  7 Feb 2026 17:17:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C11E16B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:17:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75099D5E74
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:17:56 +0000 (UTC)
X-FDA: 84419074152.22.CDF103C
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 711441A0002
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:17:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSw5vSoS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770502674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTEotBHOv9XHNf13oedq1hnzOooeLueatFWrHjrBC+o=;
	b=V2JZ96V+h2XAZLcMypO1CMFsxZeqDSDjvo24xbOYNotzGRsgDhJiCQULtSfZ+aY3D/V0vs
	yugf6PKmneAfE5/BqQZ7S5dboyJrvznGKHDg5ZBwSjg7D0eU5E8KK88cjxxgY5FC+5qFpF
	JRI4+M8S7LrgtOC5Teyvoj6GH4dTokk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770502674; a=rsa-sha256;
	cv=pass;
	b=A+V4Lwl3DRryBKFbJGgRnU7Pk4vXPukcawnAJ/7PLfMDJ3+wgOY7bj1mZoPtvO9BVceqvo
	A6ouTlLxSKJvaGELxRnIz6kYc1tLs0LC7BEfyQQAbwWX0QOEhIb8bddgqsTTzcjZXyywvz
	6mYyc9bWSY5hE4ppHpgI13bbP32TwLk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kSw5vSoS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5013d163e2fso20404721cf.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 14:17:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770502673; cv=none;
        d=google.com; s=arc-20240605;
        b=j/FCNgi6uGD11KrBwcOg1EOL0eHEQRDWoZ15zHbq8fnIjS6Ctqr2xnZ36VDkQUKQKB
         09UZfIII5XOijB0o66k1gUueAWyyzam454sK2l3XO2/3WmVDF60Qlu8BTeJJFmAQn5Ow
         nMI0kdNxXcoejy5IlJd7TPwPRiVi647xmzfxAuBsIMLF4OwTWPxd7jFOSgxULKq5XnlA
         +ogoe9JAFKOPj2l6FIrmjzgKhkZe4eN2dfTecJBhGB3/G5SHI+2n27DzTCF9RAJelxas
         4ZTQab4xfZLVpimQYh1z4BbWd3QN5eZCNJtDLW0tD2n2USG995JxFYydakGILyG0MNwa
         nglw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BTEotBHOv9XHNf13oedq1hnzOooeLueatFWrHjrBC+o=;
        fh=xCa2SfIThJMi1nVb9FLg2PPZXzmtzNEhRs3EA8wWH/c=;
        b=GihBKcRmxuUzFZV9ovXpzfrmCA1IP4l9QQ8rL9UWGHYSHlYMq0c6Tg4v1QStqEDNBE
         JnraJNqQmkP616qLj6rdTiuEwWPRdYlKkpAKWFr7nJOAb842OzhhaoiXY2yBCF63EaBC
         wQcGqd6XVz0sHhZIfnTKhretUTJKdFlHeD1ZWdgitqw1CMRXe2Li+UBHpgWCw4NnNQDz
         3q3QYHoQjk7zrYLSf7eEyH2+LHPFyg+hN1e044iJ4wWPGqZcku6Qsyewgp9I79jHAAMC
         saPr+VCeRrOSyTjJT+USZzUvk+/hxDa4eJ5KcJ5rEDMbNGnwTXZMAu11J9Xtz/rGlDwg
         BPmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770502673; x=1771107473; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BTEotBHOv9XHNf13oedq1hnzOooeLueatFWrHjrBC+o=;
        b=kSw5vSoSITexZkVLTCiHmM7qDHx8rg6LQoCbb32R2DFGLzifsyLzuCUTOcC9K+jnsz
         iPqmb6+DsbkVwve+NCFG9ocOvVg+b8XRMjgaygw47nhs7asq9KWcgVSuoNcaAMrXd1yB
         nEn8zf667wd6bVNNIaJAcDjYGvst029z4LtvBqQ1lG+uYtshO+EiNaFYKlClYTz6QFsu
         5M/6JuTIrlVu1DBSfIFLxxGzukcv5+sKONTKAyjfS9XJo38UUoYrQOisozT/U3ZTbR0o
         dX0twgT2ZSwKwXNpUPCRouBL6G3SxXASxa2x9838xbcQfT2VoHwKYyweEJqm7UYSAFuk
         Rljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770502673; x=1771107473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BTEotBHOv9XHNf13oedq1hnzOooeLueatFWrHjrBC+o=;
        b=HWylDYO+PA0BAAT4a42D4k7hFw5RwkMm0muXuf76YkTMfypGQkh+ssuAYeqVaMv8Jc
         1OjJ8jaLyHW0CQHlmImH03j6pn/5sUPkICyQSNGE4TrBItkW7lDhbDi0KFWpTzSneTB9
         Iu4zuDNCSMS280OfJ3xL6A5KXsOxz834wC9sykVKoMcQLGuLKJokQVPYD3jhsy8mOzUY
         5ozG/Af1TTer48EEt9h7qyMtAOQL2KEbd3rbZ/opX7+7mrioiBQmTxfGL4N/W2taPavS
         YSLJPO5eAAGZaWfY737FzKTfLNfPA+eeLUicLXNvoCM+7s8IEQZCxc1HDxyyreGalcc0
         1P3g==
X-Forwarded-Encrypted: i=1; AJvYcCWH46fUtJOaDdiVJwCG/VeMMa+QbS2BpaQQ2P+sS/Fafy2MQe63iM+fwnaw8cQHBldDyD8e3x8qNA==@kvack.org
X-Gm-Message-State: AOJu0YxsK567pDuOiAk1I3JT9DOorNqFsIxGQB+2ufz/0JWrGIqOe+B9
	BmD9t0OAZZ5/9ng7aJThWWpqu+Y3ou2AFrNGC2Ohn+n0yBNvdHF3qGhcukhVpeDH2lrz082gByl
	kCCU+JEkqZ9X+qzC4wpWbOhOYC9qKJac=
X-Gm-Gg: AZuq6aLoWvCNAKVIvOzsHJD0FEUH4JJL0OsVaJQ6G7Zq7BRHz2jNKtcV2I9abaztOAb
	vNsrsV0OvTECRYU94NTGXcACax45ZTR/5XzESXy2AImdJ9nn/cVZgXdV9tS8jF6zeEVX9ICY8ws
	LqcGl+4ouSQuaEL7XaHSv9GY6yPwA6ItPhwNEqbPAsJHT6LzoDF54j7ZINXmqe2d/MBoav69HCq
	/CfQ6xNomLZKeT3WfjbVhC0U8Ya05leVYi8bmYoc0TRJkb/dAfkrPM3Rj7o+M9beWjezw==
X-Received: by 2002:a05:622a:46:b0:4ee:17e9:999a with SMTP id
 d75a77b69052e-5063992680bmr94061321cf.33.1770502673172; Sat, 07 Feb 2026
 14:17:53 -0800 (PST)
MIME-Version: 1.0
References: <20260207081613.588598-1-vernon2gm@gmail.com> <20260207081613.588598-5-vernon2gm@gmail.com>
 <CAGsJ_4zxAmDS+FWzfX-670W3H3LM=nUZ-gGe3jMV9tYM0E_EaA@mail.gmail.com>
 <e106bb45-5563-4b9b-bcb5-defd6e204c79@linux.dev> <c1280171-b9e7-4f10-adb5-b6a8ed69e54b@kernel.org>
 <CAGsJ_4yEfgipUe37_k5rArrYMPY_31JUKQGjRk+NNJTK9QhBWQ@mail.gmail.com> <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org>
In-Reply-To: <bd36d92d-dbf1-4818-bb31-0330c1f53577@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 8 Feb 2026 06:17:41 +0800
X-Gm-Features: AZwV_Qh-gSOsEfSs0Y3r-5yEnjwmRauQ9mEa9C2Jg6pXLA6HDZrwCYmuNH9_Y7Y
Message-ID: <CAGsJ_4zBpL6a5ORAQUFwZMM+ikmMS8JSo9enLDZ7VFT9kkge+A@mail.gmail.com>
Subject: Re: [PATCH mm-new v7 4/5] mm: khugepaged: skip lazy-free folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 711441A0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 81k4xiwm3xfxcc7much59deyir1u6ez7
X-HE-Tag: 1770502674-359353
X-HE-Meta: U2FsdGVkX1/e7WNom9amx4vZOQpc3byCX1S0ft06cpS7pYEnE8JILrCzDLRBsapdWucvEWIPFIl5yDygjx6iW/pVr8h5ZjwG192D2uiK6oVDoWRUGpPRb/P5w6Fw6GVszh/yOb4wepXZpL7pVr6SfBwyHRHZaTgd8H7BFgTGpXdNN5dqmxvszKWWtYBIqczCbWmPh1AWF3qWDdN5/6VHU5ETIg6C76qCKaQFapV0jPrIgIz94VIllj1YuT+zz9jomHkXUroDCZaGlreMGIDfWHvQEiQ6KwCwobY4YOaNpm3klY5lKtfvxbta08AaUUmJXRRxpDR+SXP2Jfv1eeHEa7yxmRlU9a/onj5RzSijlhEG5uaGfvYcseUVKlGf3PSPwexxSwZ1LFs3OWPeJWRHJ6dDcWepyVijal+0hrpfSysCEFg/UM1MRRLLPV1aemIz3CPix23NZyTce7/UtX4X8dB+NPKUTA+Z39FCsjKtbwlasYJz18wNw7QgOPh6DM3w4L6A4m0pRQYH1KgSwPznPosujuobdwZUQoefid1fyDA+YqeWdwkOYEj5FdjGBVgcY8UMH6K9jxWNz/gr3cC7Rpt3XuLYuxU/PiCr4hJhp7nR0faBLHWkCgg+WPLaM2pWjX4B5ZrQXM5yBgTavQfLPP37zQ6btHa/yqdcVF5idlSFBSQAfvuNZOblsNCYvgjXQaerxZoHrkJVWauwN7jtKTn+mLo0hefgS5qoJyrwq31Jrj1B60beXz8QLP2qNmSXOqbF2Nqw7oekQgBdeP5BQeDq7tfiBvN3wBf0fmMTErDBhAwBs3Rsq0OSinnAT54eX7qgnFwxJisxmmRIWrs6WoOQo9YLRZhuBk/5nrjCC6n+qp4hgh0RyQxR5dtp811Hap+GTzCqny4B8e/4Umc8KaI9qtYwN4TIR4bP0MqNp7Yie1L5IpdFgsgCUMb2Q3BWomUWWsDW5rBPEN2JAaw
 Gp3cz8ig
 VPgC//d2zfUbVZi3B7bPybade4QJEMA4EOvDOmxKnM35IaDYkBx7uJ7jit1XVVvi/fjCXxXAe4eb3anHpejgnTOwJoIRBd5TpTLE0/JqMf8FRiHvsuq+hWJBxdgcWkLDNOMAIbv/55do5M514Qp7gsxX+EYMtjaU54th/43g+aF7u1x5V0/t639VNFuVV+vyclD4b1V0/cTfk4JXnFnn7dauBXrl47Z7bCGsEH8GuYVowojvNxrKFkULF/68DpUPpemQ3GfJfjzP7MMnflBz4F1rRx6Tia/pfPDg01Au/hqKhpXh//ja2Akg6njJNgh1qY4LvE/CM+ApUEkEA0VUx2WxMdv7cdSlseGdTo2LA8+CgMapq1+FlLu72eV89AF2DCUD2mk33/Negw+sexE+APy8PBCmAxKSDsUAt/6Fo7NWFdEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 8, 2026 at 6:05=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 2/7/26 23:01, Barry Song wrote:
> > On Sun, Feb 8, 2026 at 5:38=E2=80=AFAM David Hildenbrand (Arm) <david@k=
ernel.org> wrote:
> >>
> >> On 2/7/26 14:51, Lance Yang wrote:
> >>>
> >>>
> >>>
> >>> Good catch!
> >>>
> >>
> >> Good point!
> >>
> >>>
> >>> Right. When the VMA has VM_DROPPABLE, we would drop the lazyfree foli=
o
> >>> regardless of whether it (or the PTE) is dirty in try_to_unmap_one().
> >>>
> >>> So, IMHO, we could go with:
> >>>
> >>> cc->is_khugepaged && folio_test_lazyfree(folio) &&
> >>>       (!pte_dirty(pteval) || (vma->vm_flags & VM_DROPPABLE))
> >>
> >> Hm. In a VM_DROPPABLE mapping all folios should be marked as lazy-free
> >> (see folio_add_new_anon_rmap()).
> >>
> >> The new (collapse) folio will also be marked lazy (due to
> >> folio_add_new_anon_rmap()) free and can just get dropped any time.
> >>
> >> So likely we should just not skip collapse for lazyfree folios in
> >> VM_DROPPABLE mappings?
> >
> > Maybe change =E2=80=9Cjust not skip=E2=80=9D to =E2=80=9Cjust skip=E2=
=80=9D?
> >
> > If the goal is to avoid the collapse overhead for folios that are
> > about to be dropped, we might consider skipping collapse for the
> > entire VMA=EF=BC=9F
> If there is no memory pressure in the system, why wouldn't you just want
> to collapse in a VM_DROPPABLE region?
>
> "about to be dropped" only applies once there is actual memory pressure.
> If not, these pages stick around forever.

 agree. But this brings us back to the philosophy of the original patch.
If there is no memory pressure, lazyfree folios won=E2=80=99t be dropped, s=
o
collapsing them might also be reasonable.

Just collapsing fully lazyfree folios with VM_DROPPABLE while
skipping partially lazyfree VMAs seems a bit confusing to me :-)

Thanks
Barry

