Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2899C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A606B0088; Mon, 14 Sep 2026 15:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBF46B008C; Mon, 14 Sep 2026 15:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9C86B0092; Mon, 14 Sep 2026 15:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EFD06B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:01:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F9FC140268
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:01:25 +0000 (UTC)
X-FDA: 85213286130.09.3DF7FC5
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF82A180009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:01:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUJ05jrC;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789412483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcWr29ciRXo/Ssy/W3GMAIMRBylURTjvxgSXaybDMn0=;
	b=pjkmvx4UQNiHArvxnfpCxG2ZIi7B9zAmKzUEoVJfwBYcR7f/fHU2lmIxI73Y0ZhU6fEciE
	+mcQ5XqRg1Ag9h4uniJ5STXtoWi301foVS8d4L/3u4Q8GFCaKj4M5+IwaL0HMttkZALNs9
	vJb6iNv5hfb+ePlCaksK9iHRvzae++Q=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GUJ05jrC;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789412483;
	b=eEYeYgxxbzl5z44bmybFUiAPZenYDDkeHGB57172zkPHexv0W++E10mTnef6q4RZF8HgDt
	R8vXfWwJWryINnVCpovyHSeALZh75U+tQ+wU1OsTDyff28QJ6N/8rbcwndbkgYEcArmBCH
	l6y3sw7K9oN6vLz5JTHvZiWVenyKuo0=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48449f62b93so751417f8f.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789412482; cv=none;
        d=google.com; s=arc-20260327;
        b=Xh9ompcd/GCHpME6WR4jdHvpzHcOsPV5gos8zvqQt7JxS2Dd78jL99j0pvPyY5H3pD
         kGWTFrTuWhryNDUyaK3Rf4qbZdhNPIxH5kZOdGsIpI6rv8JxPMJoV6wbmDjVgGO0eeOL
         aLiqMh43/5UiXUxy1zMUuRtsQrNxSnYp/Wm3v7X0fptjCrNQ7pwd+kpQrvG8aO2msHcR
         w0cmyVxdrXjLPyP7DFmEnB5VThVu5usi2vkVBIlNXMUOI14yWdC63VFXikxtu4KJ6DS5
         ZJqq1nULSdi9pau6waew6dkZoAVBCtAEeeX61ZTUluVYz4vzOPfutWhUOBhDu+OsNHr2
         h4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kcWr29ciRXo/Ssy/W3GMAIMRBylURTjvxgSXaybDMn0=;
        fh=PZMn1W+BkiSiG+nxZxsKDtlM0JtO2Z1aUccjW7uw37I=;
        b=V17Zs8746qvKro7XojAwo0xjcxMtXIAQg7a+L9owBCl5iRPUqxtVkt+9axR8A8tHU0
         qUhRbPamvRk7KlD1i/6RkXWj3mgVAMnnB0caBqAIIbqsbeDZJ1sB1Lddo+3zGuUK6aU6
         jvFtfs6Ukx1D1ajH8ox/SoUtD4092mL2PQ2S5qkbvKNeO/2EJT8WTHNyNtzK1mWyALWw
         b9IABY6nQzIy4ThPBDiAw5MW0UXNjGfn+fHn+jxCjEs01IB06wwx6DmPP2m0PYWuh4iZ
         wTQwtc92al6f5wjS8jCkd4jRohOaO3v0YDrTUGvWwMcHpyQtkmqfzuqRgs0QT5wG/29H
         BL1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789412482; x=1790017282; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kcWr29ciRXo/Ssy/W3GMAIMRBylURTjvxgSXaybDMn0=;
        b=GUJ05jrCErfQG6xoOt7tcOOHPEwMTeozK8wiuJU2Q86fIhMIxje5x6lZmnMp523Z91
         9XXhwtmk1gXeZc0Biyy3V+xLXTaRDDIdBeBP6GAxzwC1LOiQh7db6VUUvM5cu5Gg9hXl
         Fru6uQfh+/XoZ0oZHHluLWh4a+zbYQ2C1VJo4+tDoq3xRrkVMtnitC5YWgVB4GTBgX6h
         /OyGKzpBrtcsa91ft34wKY2VhWKgJ5SexDM/ZUAwonjJSCnTd6+T9YyoWhwIp+vmFHon
         aKRoGejSlYkmu2ffOCicSyjj9K3D6csw6/Oaz4Z8yVLV1mUkTocNkFDyRep7hIlc4cp3
         1JmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789412482; x=1790017282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kcWr29ciRXo/Ssy/W3GMAIMRBylURTjvxgSXaybDMn0=;
        b=KKt8lUjMx9AIqaHvOvuG5wj/eJum7XtodJ5wXRoifKta16RpCsxxYv8aCXqLEBsPQA
         FoL+mBIQhPMCOAQwVDt2Ns/D5K2lGmEQgKO/8FpiTbg1ooqFG32kXGu7y0DZM8hk+JKd
         ANRrOLwkkdffCvVR45f2yWgDvpTQyR1ef+OykB0B3+K8z3x9bCngbWEn8WRZ9ixzojJ+
         9wLhFnRenpdFDsTNEEdEv4c5CiLDZ/h0/uG2tSw28Mz7hvvx6Q4Gj5OhuG7aBnmrNrkO
         skcG8iMMZ8yzUZbp34fIQ16GoMRIg8Wj74j5ZBjVKVVtom0YJq+Cb73pm9Zt54ulIhjl
         5JSw==
X-Forwarded-Encrypted: i=1; AKwUvBxUiP3MTp9pnbFATRDbsSFG0WbUw/4tSDRp13bdSdM+Y/SWOtMuZX2AYH0s5CanA9uD9V7BnSdViQ==@kvack.org
X-Gm-Message-State: AFuF++kRqPdICFDTtUwzFK5miJ/3A4A+JFqsITZst4SN3CtprlaRFiPH
	hOspq3x2e07XdT5DFxKDIdTjkS8GbB619JpNrKum1dIyYaewLE6JFw9zMlD+2PyyiHWoGuiIKa6
	w1QsYuSoRXaktZEP0/zuG/NT6hOyeukk=
X-Gm-Gg: AYBFou22lEUIsc50a7qbhJeTi8kbNFiKc6L5XOdYlLFfmo0WDs/fKgnO2i7lfVx10YA
	qS/BcvOKdOgOPzcntUaZD1DXVwaYbJPpxuqNdbpzCv8AK5w2MMSPfH924Q2JivOcQ/Vrm34X8Lo
	YisW9I4tX4/v6WndLtMHUJdq9jfzeom25oIYOSzUNaQ4ziiyuv+uotNcn2AsJ+6EZR1q6BAq04l
	CCadxboK5yFhDfnakOEauRGrcB8F+5VVW4XlJ/h91XhkswQWIOpcrafz+K5jjTfVOpevrAANzMW
	6XlHsqU1Ow5oZ+7tApESrfUm4xJJIb7RN4lMtoLZ+pfILSmjhzyD5d2F+YoS81+mYOqWrT32FND
	N1UKkX8ScisGMr2/VclCcfK8g/g0QYjSyeDZ2n4Q0fMPcFlf9
X-Received: by 2002:a05:6000:4803:b0:485:7d6d:e0e0 with SMTP id
 ffacd0b85a97d-48705a39405mr1037299f8f.3.1789412481801; Mon, 14 Sep 2026
 12:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1bk66ZhRAS7mojSnD5RBfFS+0ChAPymE3ObRWr0C_udWg@mail.gmail.com>
 <CAO9r8zPpe6fWOSXtRUjFB8WNMroeBqvLT+2QtAU4E27AtLUXMQ@mail.gmail.com>
 <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com> <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
In-Reply-To: <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 14 Sep 2026 12:01:09 -0700
X-Gm-Features: AcwNN1VFoc_2eKOenFa2PrLINBfqq7xz_q3LPSvn75t1DU2-aSfT1Pyeo05pSnY
Message-ID: <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF82A180009
X-Stat-Signature: zyhjy3pgahdmnktg35y8gyc669x6ah1g
X-Rspam-User: 
X-HE-Tag: 1789412483-552997
X-HE-Meta: U2FsdGVkX1/HGRVH9Yf9dfAWETvBqx8ZU5995hpQpxJVLdE7DDjK29x+T1cADlyGgto5aQvxUgD7UAq8DU2fQZtoEjfD12j0olanYqTBakynzIJ3JzPuwnDY6vzuyMwAVj4y2T2br306tRR84itl1fi5RVFrks3nL5w/9Q9rGmuFEOHvrHNxC3r9xQZN+NwhUWxI0hSyrKLjpyymwuPR3vqR+Ir7Qt8yNnvoVDAXMZe1YUebU3kCRVlnKxSlsCajcJcAtkjvwjVpVuQRfzE3zvseDUL/IdoSvlviOOonDkArDR/scs1z17AhtYlSMDmZRyvFJqYU4PcmwwirPjMe90apsZcxMnfxPxKPnZX3QSETaL9OmxYex96wIWyePqP43P43/uH6TfTSoUVwYGx36HIKek0V7xPb2jyhlgBxBcnNRPkogXzZ+u/V89ItkmsX15esDe0xNWG1pmZvG74it7JYZaiweCuSnuKDVbN7X0xhYy2WWB7O5LshqTUmFGn8XIAGGPM7Ef2BxVUuFwbNlm56OmGhg7B5XaSGB/GuKEdxJsQ4J4/HP28odTPrRZXhpJsznMtR8wrJdPBtZOfGcnD5fgv+jAzlLNEg6LDEQ8wh+Qo/8NNq7bOtBUbvKJPr/8AXJgj7ZYm2qCiZeNtRdh4VOlNlOu+O9Ytu77z9Qa0aABQaxFduL9KDRTkvcg7vpQTTx9MBdgspvRT477atcu8Vf+kpFfVGvpBPvA4At/MIll0REKZTJL81dkH7Zt9bNd9pYbkI3XwEURfFiqqlzxDrf1X9sXy3V+boCBYPmf2rcVOYIuxprzXz4pe4yFFXPPPL3ZJrAqzI4xwbi/3NYKNW/EBTxBVgJvEVasv/Cn4JD1Hjg8cf6RkFbdYWYs7HV1Fum2pTYRJ8Fpz08RbpU4Z+TOXDSWqaZ4Pdxp76QhNdC63y6qMHIyn0DqJXGMVvS1ojWY/fxk8dlh0MdDj
 nzIRDg/P
 /tTPoBfaAxjies7gJsHH85PAnBjKUljZsO0SzsOOnpANtSu2MdmQsdhib2ikG7vONdeLNL3N8sYnWPL/QJ4h6e+BvIx1AfTGSwJySOkV1Pyl7uqpdqet0AICu6DqaMGYGBe9Jemk9vMHEtQH47UZgsaWM9DIEBYU4NmBM3ZpcaH+wUkJjBMoHi1YQPKUo+C6dgpMniXZtg7gkk/0VhfeTu9PeETq+v3AjM+/oNOp4mOcSj7RaaoIoxUXpUPXYhC5NseoYGLdEl6aAg6cVDW25LqOSS9k+fk3+///cjYoD2EQEvf4zjC0UZM5UIcsNN6BN32Yc/OJE719zCcEcq15hQLZrZ0rPl9VxNrii/o5Es0TdPpAZcFz0BRU/V8UCOtp1fDCi1sSGXrdcDnmcZ5cYKktKi/QlkZm8KzYlvtCeY+WqtEU/J6eiSpbwSRWgd9VdSQOWUx6QInnwFRgpd28SODICqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 6:39=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> On Fri, Aug 21, 2026 at 12:41=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > On Thu, Aug 20, 2026 at 4:39=E2=80=AFPM Joanne Koong <joannelkoong@gmai=
l.com> wrote:
> > > Would you be able to share the test you're using? I've been trying to
> > > repro it locally without much luck.
> >
> > The exact test uses some internal testing libraries, we're looking
> > into whether we can translate it to a standalone C repro.
> >
> > From a high-level, the test:
> > - Creates a VM with 260 MB (256 MB for testing + 4 MB margin) in a
> > cgroup, backed by shmem THPs. The VM is not a fully fledged VM, just a
> > KVM VM running bare metal code (so 4 MB is enough margin).
> > - Enables zswap in the cgroup.
> > - Tells the VM to write to 256 MB of its memory.
> > - Checks the cgroup shmem usage and that no swap occurred (no limit).
> > - Sets the cgroup limit to half the VM memory.
> > - Checks the cgroup shmem usage and swap again, usage should be ~half
> > and so is swap.
> > - Tells the VM to read the 256 MB of memory again. This should cause a
> > lot of thrashing and reclaim, but no OOM kills as all guest memory is
> > reclaimable.
> >
> > With the ratelimited flushing, the test started flaking 5-10% of the
> > time due to OOM kills.
>
> Hi Joanne, Yosry,
>
> I've attached a reproducer for you (as a patch that should apply to
> Linus's tree).
>
> In tools/testing/selftests/kvm, `make` should build it. Instructions
> for running it (like setting up swap/etc.) are in the comment at the
> top of the file.
>
> As part of the patch, I've also included a sysctl to dynamically tune
> whether or not the memcg stats flush is rate-limited. You should find
> that when it is rate-limited, OOMs occur, and when it is not, OOMs do
> not occur.
>
> This reproducer behaves slightly differently than our internal
> version. This version, when run with `-b 512M` anyway, seems to OOM
> simply by setting memory.max, whereas our internal version would OOM
> upon re-accessing the memory. Not really a meaningful difference, but
> just wanted to point it out.

Thanks again for the repro, James.

I added some instrumentation to prepare_scan_control() and have been
seeing that the OOM gets triggered in this pathway:
a) the memcg is created with memory.max set to unlimited. 512 M gets
faulted in. The new anon folios get put on the inactive list. Nothing
reclaims them yet
b) userspace then sets memory.max to half of memory.current (~271M
from ~542 M currently used). This causes memory_max_write() to trigger
reclaim logic
c) the folios have already moved to the active list (my
instrumentation shows 122684 active vs. 179 inactive) when reclaim
does the scanning, which means the only way for pages to be reclaimed
is for pages to get deactivated from the active list back to the
inactive list.
d) prepare_scan_control() (which decides if the pages get deactivated)
reads the LRU sizes from rstat. This memcg hasn't been flushed yet
(the 2s flusher hasn't yet triggered since when the memcg was
created), so the NR_INACTIVE_ANON and NR_ACTIVE_ANON stats are all
still zero. The real values are all still sitting in per-cpu buffers
that haven't yet been flushed. My instrumentation shows:
        inactive_anon       rstat: 0    actual: 179
        active_anon          rstat: 0    actual: 122684  (~479 MB)
e) the deactivation logic in prepare_scan_control() is:

                refaults =3D lruvec_page_state(target_lruvec,
                                WORKINGSET_ACTIVATE_ANON);
                if (refaults !=3D target_lruvec->refaults[WORKINGSET_ANON] =
||
                        inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
                        sc->may_deactivate |=3D DEACTIVATE_ANON;
                else
                        sc->may_deactivate &=3D ~DEACTIVATE_ANON;

The if check fails:
     refaults !=3D prev refaults: 0 !=3D 0      (false)
     inactive_is_low(): both LRU inactive and active values are 0: 0 *
inactive_ratio < 0     ( false)

DEACTIVATE_ANON gets cleared

f) pages don't get moved from the active list to the inactive list, so
reclaim ends up freeing nothing. memory_max_write() goes through all
MAX_RECLAIM_RETRIES and OOMs, even though there's 479 MB reclaimable
(but it's all on the active list).

I saw that the skipped_deactivate retry did fire (on 858 of 4264
scans), but not enough to get the memory.current back under the halved
memory.max, so memory_max_write() still exhausted MAX_RECLAIM_RETRIES
and OOMed.


imo I think the best fix would be
a) for non-root memcgs, revert back to the non-ratelimited version
(mem_cgroup_flush_stats())
b) for root-memcgs (which if flushed will flush every cgroup on the
machine), don't use rstat at all and use the existing node counters
instead (which is what the non-memcg case already uses).
mod_lruvec_state() always updates the node vmstat and the memcg lruvec
stat in the same call. For the root lruvec, the node counter reflects
the same value and doesn't need any flushing. It has an error bound of
125 pages/cpu at most, but this is tighter than what we currently have
with the ratelimited version.

commit 90a6f2a8f442 ("memcg: use ratelimited stats flush in the
reclaim") was what switched vmscan to using ratelimited flushing. The
reason for this was to fix the stalls from concurrent reclaimers
contending on the rstat lock. For the Cloudflare case, kswapd threads
were contending on the rstat lock on 8 numa-node machines. That's the
global path (eg sc->target_mem_cgroup is NULL,
mem_cgroup_flush_stats() turns it into root, so this flush essentially
ends up flushing every cgroup on the machine), which gets addressed by
adding the fix in b), which takes kswapd and global direct reclaim off
rstat entirely. For the non-root memcg case, the flushing is bounded
by the MEMCG_CHARGE_BATCH * num_online_cpus() threshold (a non-root
memcg's stats_updates only accumulates its own subtree's updates, so
it takes a lot longer for it to be exceeded than the root's does).

I ran some benchmarks to get a rough idea of what a) costs. I set up a
workload that allocates 512M of anon memory in a memcg with memory.max
set to half of that to trigger reclaim continuously. I varied the
number of threads touching the memory, so that N of them hit
memory.max and enter direct reclaim on the same memcg at once. I used
bpftrace to measure the time spent inside css_rstat_flush() and
shrink_node() and used those two numbers to get a percentage for how
much of reclaim is spent in flushing. These are the numbers I saw:

# threads      flush as % of shrink_node()
1                ratelimited: 1.10%       non-ratelimited: 2.22%
16              ratelimited: 0.36%       non-ratelimited: 2.87%
64              ratelimited: 0.16%       non-ratelimited: 2.52%

Between the ratelimited and the non-ratelimited runs, walltime and
pgsteal were pretty much indistinguishable (42.7s vs 43.6s at 16
threads and 41.7 s vs 42.4s at 64, with the ranges overlapping, and
pgsteal within 0.2%).

I also measured the lock contention. At 16 and 64 threads, 15-20% of
__css_rstat_lock() acquisitions hit a contended trylock with the
non-ratelimited version. At 16 threads, the mean flush time rises
about 8% and at 64 it roughly triples from the single-thread case
(26us at 1 thread, 42 us at 16, 87us at 64)  but I didn't see any
effect of this on wall time or pgsteal between the non-ratelimited and
the ratelimited version, and the percentage of reclaim time spent
flushing stayed at 2-3%. I think that's because css_rstat_flush()
takes and drops the lock once per cpu rather than holding it across
the walk.

I also ran it with 32 actively churning sub-cgroups under the reclaim
target, since css_rstat_flush() walks the descendants that have
pending updates. I saw that per-flush cost rises slightly (~24 us to
27 us) but the share of reclaim time spent flushing went down rather
than up (4.1% to 3.2%), because reclaim gets more expensive faster
than flushing does. I don't have a ratelimited baseline at 32 children
though, because with the ratelimited version, all the runs I tried
OOMed. I think this is an alternative repro to the OOM issue but
doesn't need/have KVM dependencies, so if this would be useful to
clean up and send as a standalone C repro, please let me know.

(Also btw (this is a bit tangential to this OOM issue, but somewhat
semi-related), I don't think the WORKINGSET_ACTIVATE_{ANON,FILE} stats
checking really does anything in practice. On my benchmark runs, the
"refaults !=3D prev_refaults" check evaluates to false in pretty much
every scan. Even with flushing working properly, it didn't trigger on
1673718 of 1674912 samples, even though the cgroup was thrashing the
whole time (a separate run of the same workload counted 6371860 anon
refaults vs 6523 activations). I think it's because reclaim is
scanning faster than the refaults counter advances, so it'll almost
always see no change. I'm not sure how much this matters in practice,
but I think effectively in that check above in prepare_scan_control(),
deactivation relies entirely on the inactive_is_low() check.)

What do you all think about adding a) and b) as the fix for this issue?

Thanks,
Joanne

