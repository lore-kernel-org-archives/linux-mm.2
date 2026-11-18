Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D88606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uber.com header.i=@uber.com header.a=rsa-sha256 header.s=google header.b=Y4fRb51q
Received: by kanga.kvack.org (Postfix)
	id 64EC36B00EF; Wed, 18 Nov 2026 11:44:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FF2C6B05B0; Wed, 18 Nov 2026 11:44:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED976B05B1; Wed, 18 Nov 2026 11:44:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 190C26B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:44:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAEF7407D6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:44:39 +0000 (UTC)
X-FDA: 85448813478.03.3CFE331
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8F9B100005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:44:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=uber.com header.s=google header.b=Y4fRb51q;
	spf=pass (imf05.hostedemail.com: domain of mattathias.pinchover@uber.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mattathias.pinchover@uber.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=uber.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795020277;
	b=zQNwNkmAHI67+XkHO4AsDShiLApQBlVmrWJrEARC3+9ycem/E/ZaMRf1HkEiYq/NFyGqmh
	D0L7IZ4wuIxpAarIKJCP6MSKb5rSGuEqLKYJwbqVi6gBFkP/iomYicXVZ9jqfiNMqznK5W
	Pz/HQI/KHwMvrQ/6ITaq6hUYaDo89Pg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=uber.com header.s=google header.b=Y4fRb51q;
	spf=pass (imf05.hostedemail.com: domain of mattathias.pinchover@uber.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=mattathias.pinchover@uber.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=quarantine) header.from=uber.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795020277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYyNFxk1dSJzXFfTiiZNz0tVHb1k5s3TN+5JUzHxQFI=;
	b=7+bXVgdBVn3u9Svop8BIRdG3ZMH7tz50Jw7ADUBkdiyAUap4HvSCE8vdkRRjaN0VVxqxzv
	pGo0bmhbjPjoZtR59j3lF8sMlvb7L30LiTpxEMkvrNdgkrsQswg+9wbE9tXdhMcX441phU
	JAq8qlEFQyMYWDuQFmQvZQiSoEtHLko=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b88b74e54eso1307454a12.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:44:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795020276; cv=none;
        d=google.com; s=arc-20260327;
        b=fPsyHYOgwFWUnWh7q/SKDLmCrYCd0zwZULdukOuqY/URnNfVZTCrC+bTZr295f1U0k
         2hK0Rc1qEeRltdRWCcPbZeNjXtBodUIm7PPH0iX4cnxH0yCzwVDT1DreQ0nzJRaxANNO
         tWV368nsczK1xqwUV2U4LW4D+yP1CGS86vEC4x7PMKbfxaJjIZPEj6Mx6ugWRrfhHrnN
         9ghxMwZi7x9Ral0sSOjpbpfX+h/1gXyZnXDO2kiAV/k3gZZi/rQJCubFLY5cKb8Xd4UY
         NACZbe+U8yj61cSb3PsGnr+4rA0vvdWrAVI4S83bj/aqLcMh8ASL/n4uVMEV0JQ2gFgW
         9jmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=PYyNFxk1dSJzXFfTiiZNz0tVHb1k5s3TN+5JUzHxQFI=;
        fh=1tBiG4IheWTGv22L1Hz+7CG8zbQYEnv8Z+GDa/vZ7r0=;
        b=AvIXpROGClANstvI88oNkv5yXO7+kIK1Q4W0mCw6wzI7g6rE1+0E2gyeoMWIkrDyiE
         Rgb9YOuH4/eHEaxpROjN0T12FXdE8Y0O3rGbRo3/xoh/r8EdBieXx4zCL7UzinjDOWO2
         F5KfL112FjTugSPZM67lhRW+kx2/gh42djpwvzBLQyu69hBNWv+OcvXgHvYLqOuLFZAB
         0irWIrR2YuUOIjkiacg7pNnBAVP/kIlcI4reFjlXYWkFBqvPaie8gdyHJ8VTPY5AhBvD
         T0E3BTvrJ0JwE+Fw9FRNpxT890fJuzTy4VzUtUN9+pupBiCWHK/EAfkKRgzZDX7ZwMw4
         WZVQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uber.com; s=google; t=1795020276; x=1795625076; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PYyNFxk1dSJzXFfTiiZNz0tVHb1k5s3TN+5JUzHxQFI=;
        b=Y4fRb51qMqHoPdofOxqViipNQfXpW3IfMkwHizIRQT/yUfOfhUOBjZAd2QwixmfAco
         lghfodZTf0sfOzpaY8XT8V2kf98svX9QD5CgPzIcg4617rpotwZvX42qTMBNBMAGduW8
         0SMgV/sMR9tZeVk+lu0r01MVf8gIw1jUB1aLM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795020276; x=1795625076;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PYyNFxk1dSJzXFfTiiZNz0tVHb1k5s3TN+5JUzHxQFI=;
        b=bygBk1qhGdZQtMtwliRFs5V1aT9BBAZN5Mc4BFyx8jGK/z00D/oPTPOi7nG5dxSFAP
         J4Lejd4BZqzRn3kwOJS+h17Kvl21eIp3T/FKAHRoRVWurAcnoWzp2WKRB9Uq0p8eFclg
         ZH2lcAZ9PEtpQ4kS5zNWe+YqvFVqzce4tnz+Bvi8M1zI4XaM7hRp7HcfSM/zDzFrRVou
         RicJaf13FgXge7jyH1Wrol/dPl5GCdk2LwCMX8HB10FaEqeqYcrildNdwn5Y1DCKrTmd
         9GffE2nNsLJy7NXS94vstUeT1uNuDP3gCZq8lVMkB/SU4dJ2LSeIfJq67y3eDJbERLf9
         DbgA==
X-Forwarded-Encrypted: i=1; AL+hErHcYH0jI/TNCziZ3kJ2XyAEVr+Db/lKMRR+Z23xf7heyYcdleS8+qPLa2pwsTQis24zfDSl9rQ/7w==@kvack.org
X-Gm-Message-State: APuU4Z+bc42arZGbZogwJ2Y5grbedDZu12ECIO/PosuAugXNS4pFmSSp
	j0CZ9oxpqmxuYKx6Erjo5WNm7HpAx7REChFVTsCTBDjIzhKG6mA1JXvLYtLIMAyF1VfF4x63lLP
	eXNKAWdCdYgZ/jeiUQsvtqbdxl80ix5oDXffEGIlpEw==
X-Gm-Gg: AYBFou0ljFckrEvWyjfdx2+T7C8c/vaGWnYp0Rbc3tkSE2hQ3PNAE5wQ9JLayHu4mig
	NWhf3yh4lvvM23+wrZ6iNqFJeNa2/jTAeTmGAHBt64HIDXpvq6aefRfCvJuE1DPi2ov0n27HsbX
	Sq6Gj938CPDj5qNlV4RhtZHJOmoCKtqdg7qlgdonDF1lZN4nBOqlOcK3puMwdrH/jzdwuugGLdJ
	P/20yl/Jovso+Y1+RX5bQFVLf9wNSdY3vOWcJcTnf2qyUiwGfaDfv6/f9v4WmZ0EUJwr1Ny6Diu
	+reATUgfIYI3fsvufSF7FNpyjN5ggqNgQifACDR/Ams+DXpHu0Rh2q0higLF08vQTiymnfx+IZN
	1ysevdIEYjeQc8gUnGhyygl+UfYpLwGfvkkjXWll/DUdOeL1DiAXAm3e1OkA=
X-Received: by 2002:a05:6402:2707:b0:6b7:ce4a:7d0b with SMTP id
 4fb4d7f45d1cf-6b887e9855amr2534483a12.20.1795020275608; Wed, 18 Nov 2026
 08:44:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com> <20261118020709.97589-1-sj@kernel.org>
In-Reply-To: <20261118020709.97589-1-sj@kernel.org>
From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Date: Wed, 18 Nov 2026 08:44:22 -0800
X-Gm-Features: AclHuK-6XPm74litMhmdVuK8_NTVhzYRVTSElo-SfRmt_4KndLPU6eeWMs4VqdA
Message-ID: <CAJqG+6M=OPKDF73UQumL3=65c8VamkX+V74z_Lukm9bh94zEFw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm/damon: add sz_ops_filter_passed_last DAMOS stat
To: SJ Park <sj@kernel.org>
Cc: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000e5110006608fb9ea"
X-Stat-Signature: axjcro4sstk44i68whaqzqwg96ozrfph
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8F9B100005
X-HE-Tag: 1795020277-875042
X-HE-Meta: U2FsdGVkX18yImBZ3XwdbCb22gTUrdy5GId1mf7qvGT4iDTVFMU06Y1FTF7xJI13EOma2p/LY8nn+QyJPUDBj3SzyHP+7t3dyk+HP4J+usGckJJExh8YL3vIlV7WeB7ZklSh9Kn2cQ2NGr0/ViWApMj9FbPKuNnYwAOxm41vvzudKe8yNs3lRog+bWgoAq4O2PCmRoVWsm9Pblp+lMBK/ZwJTif9AlnabQnZG//rbTzC7hrF5BbF51+BrXaBfBFLYBViAIGbBCVm6Jms6zJqeoZVGWckR14gxC3szi7dhAavZ6ikChR9GtpWzAuHXjSAyuoW0oyyogGaeYKywCVKABUp/lR6KOV0JfMLzk4Va4bOb6fpWKsVLaraIuhUjNt7KHleQWr9f/X2c5sk0mvG4WMMU7zbxaTwOYVzbPSYWbBcpcV71aN2gO130R/cmoRKry6pPqA3cwZWhdRPv6oCz08BMF6Sa6cYNagm+5SmlTK/AtAMmOOVV5iVXMVR22GGkEgV43nZfAfUBgckGKh6OBEjzdJZHLoVpGtNO5dyWBGlA4LknEKAY4IllBU0Wxm8oJPup9BcRyfJS/jVnK4Uszjme9k6yUekeTIV1dKXX77cLWVJvSDw/C7V+TBlfhigKqXuSIFyZ3hSLfvyQE0qzlRM9w78WLlQxIB5Q7xw3xUEcN7NV/nti1eStdxl/G173SnGGuEXMJpjyV9na6GxKS75aZbJrzZSKBG+a33oXjjcVCjmUGILHjLS5tM5qa+ZScBN28SilTzr9Wig4llPb63nubb3xYveIj75AWA/2OQZg4tNod/nLJUo65WaC35gkP2tnA1prD9f5pvQPMs7an98D8YQbBsCJHHrnb+QHrZhuENxl0ytHrHdiw2tor9V9d8EGwxiUYUmD223EaUQx47GNdkKYOTckVI4mE2KFpp1sErIOjqx0lIxNv1oSTCYEpw2TIkXpEQdPsMQWNn
 Uhu/a1PV
 ffAcBjdvIo6HXsT4hV45dbnU/xQYXoE6HP2rYDYaERrlMnF0M8CI7MsTEIIAv+JJUl+jhN+CiEymtNSMvGMvDFI3lAhM2LICqGQ+3rEiK44fqTqlGAAPca7UDr4gksfBvfukDoJnSgWWN764+NfXMMmI3crU0JWlSVueTBCrsEnp9PaoeqiuQvAD96RdXMC330ARw+sAVpdMB1jCDvYWh4hd/Ux5AEJIxM8k8gftDtxEJtKbYsyq6v9gKWnCK0koWs5wJERyv7WgSUOb+V2sW0NmPFlHVatqbdntO0W7HPEMKYjdMl4pkV5cViDEtiefBPvWroHJmWd/Prq3UAp7otSGi/r7X1Rb63Rn9zzyLHTLIWPAgwCVCQhlKOr4k6AiSqlk4Lrj0Poq3D4zWtadTUk4c0nFM/hgWxlfEiK6qmoHOq2+cOtm9kb4+4aFu4GirE15J8/iDHy5mLwKABhEeoiUkvdozbY3yGNwCVVDGThw23mr5Fay2urhhih/FtQnmLopBmPFZFbrrDwJ6Ti8OWvXtdxcJ8Rdl1It0k5WEVxcg5D3MoHzSgAlvcPyqzupSjh0kdF2qGoL1rzBd3WnhuB3QCpbK6UL1GJo5GlWUo1cZpzMrAk6fIrml14v1lg4QtkQN5OUM3no9TA5/785KTJGGzn633rFSngWtWlJUevgCk3ZdP6RiIR8mEMK7wg6iBQ4Q40rphOQdRjVBYm+4Wy7RxWruClaYfLrjGy2FiAyKcmfkV+nn9kQWtEiGBdNmg+irFPg5mBuEBgPzIFuqe95LOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000e5110006608fb9ea
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I will make sure to do so.

Thank you for the review.

Thanks,
Matt.

On Tue, Nov 17, 2026 at 6:07=E2=80=AFPM SJ Park <sj@kernel.org> wrote:

> On Tue, 17 Nov 2026 23:22:14 +0000 Mattathias Pinchover via B4 Relay <
> devnull+mattathias.pinchover.uber.com@kernel.org> wrote:
>
> > DAMOS stat sz_ops_filter_passed shows the total bytes that passed
> > operations layer-handled DAMOS filters, accumulated from the beginning
> > of the scheme's execution.  Users who want the amount for only the
> > latest apply interval, e.g., the size of a workload's anonymous memory
> > that is cold as of now, have to keep the previous value in user space
> > and compute the difference.  To know how many apply intervals a
> > difference covers, they have to rely on nr_snapshots.  But nr_snapshots
> > is increased once per target per apply interval, so the computation is
> > complicated for contexts having multiple targets.
> >
> > This series introduces a new DAMOS stat, sz_ops_filter_passed_last.  It
> > shows the amount of sz_ops_filter_passed increase in the last apply
> > interval of the scheme.  It is updated at the end of each apply
> > interval, and kept unchanged until the next apply interval is
> > completed.  Like the other DAMOS stats, it is exposed under the stats/
> > directory of the scheme in the DAMON sysfs interface, and refreshed
> > together with the other stats when refresh_ms expires or
> > update_schemes_stats is written.
> [...]
> > Changes in v2:
> > - Patch 2: join the attribute declaration onto one line
> > - Patch 3: call damos_set_filters_default_reject() before adding the
> >   scheme
> > - Patch 4: keep only the stats list bullet, dropping the explanation
> >   that the stat is not accumulated
> > - Patch 5: wrap the stats line in the usage document
> > - Link to v1:
> https://patch.msgid.link/20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.=
com
>
> Thank you for addressing all comments I added to v1.  However, you didn't
> directly reply to the comments on the v1 thread.  That might confuse some
> future readers.  From the next time, please make sure the previous versio=
n
> thread is complete by replying to all comments and waiting sufficient tim=
e
> to
> let any other chime in if they have opinions.
>
> All patches in this version look good to me.
>
> This series is applied to damon/next [1] tree.  I will repost it soon (~1
> week)
> as an mm.git merge request.  So, no action from your side is needed for
> now.
>
> [1]
> https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.htm=
l#scm-trees
>
>
> Thanks,
> SJ
>
> [...]
>

--000000000000e5110006608fb9ea
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I will make sure to do so.<div><br></div><div>Thank you fo=
r the review.</div><div><br></div><div>Thanks,</div><div>Matt.</div></div><=
br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=
=3D"gmail_attr">On Tue, Nov 17, 2026 at 6:07=E2=80=AFPM SJ Park &lt;<a href=
=3D"mailto:sj@kernel.org">sj@kernel.org</a>&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex">On Tue, 17 Nov 2026 23:22:14 +0000 M=
attathias Pinchover via B4 Relay &lt;<a href=3D"mailto:devnull%2Bmattathias=
.pinchover.uber.com@kernel.org" target=3D"_blank">devnull+mattathias.pincho=
ver.uber.com@kernel.org</a>&gt; wrote:<br>
<br>
&gt; DAMOS stat sz_ops_filter_passed shows the total bytes that passed<br>
&gt; operations layer-handled DAMOS filters, accumulated from the beginning=
<br>
&gt; of the scheme&#39;s execution.=C2=A0 Users who want the amount for onl=
y the<br>
&gt; latest apply interval, e.g., the size of a workload&#39;s anonymous me=
mory<br>
&gt; that is cold as of now, have to keep the previous value in user space<=
br>
&gt; and compute the difference.=C2=A0 To know how many apply intervals a<b=
r>
&gt; difference covers, they have to rely on nr_snapshots.=C2=A0 But nr_sna=
pshots<br>
&gt; is increased once per target per apply interval, so the computation is=
<br>
&gt; complicated for contexts having multiple targets.<br>
&gt; <br>
&gt; This series introduces a new DAMOS stat, sz_ops_filter_passed_last.=C2=
=A0 It<br>
&gt; shows the amount of sz_ops_filter_passed increase in the last apply<br=
>
&gt; interval of the scheme.=C2=A0 It is updated at the end of each apply<b=
r>
&gt; interval, and kept unchanged until the next apply interval is<br>
&gt; completed.=C2=A0 Like the other DAMOS stats, it is exposed under the s=
tats/<br>
&gt; directory of the scheme in the DAMON sysfs interface, and refreshed<br=
>
&gt; together with the other stats when refresh_ms expires or<br>
&gt; update_schemes_stats is written.<br>
[...]<br>
&gt; Changes in v2:<br>
&gt; - Patch 2: join the attribute declaration onto one line <br>
&gt; - Patch 3: call damos_set_filters_default_reject() before adding the<b=
r>
&gt;=C2=A0 =C2=A0scheme <br>
&gt; - Patch 4: keep only the stats list bullet, dropping the explanation<b=
r>
&gt;=C2=A0 =C2=A0that the stat is not accumulated <br>
&gt; - Patch 5: wrap the stats line in the usage document<br>
&gt; - Link to v1: <a href=3D"https://patch.msgid.link/20261116-damon-sz-op=
s-b4-v1-0-1cffe7227e6d@uber.com" rel=3D"noreferrer" target=3D"_blank">https=
://patch.msgid.link/20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com</a>=
<br>
<br>
Thank you for addressing all comments I added to v1.=C2=A0 However, you did=
n&#39;t<br>
directly reply to the comments on the v1 thread.=C2=A0 That might confuse s=
ome<br>
future readers.=C2=A0 From the next time, please make sure the previous ver=
sion<br>
thread is complete by replying to all comments and waiting sufficient time =
to<br>
let any other chime in if they have opinions.<br>
<br>
All patches in this version look good to me.<br>
<br>
This series is applied to damon/next [1] tree.=C2=A0 I will repost it soon =
(~1 week)<br>
as an mm.git merge request.=C2=A0 So, no action from your side is needed fo=
r now.<br>
<br>
[1] <a href=3D"https://origin.kernel.org/doc/html/latest/mm/damon/maintaine=
r-profile.html#scm-trees" rel=3D"noreferrer" target=3D"_blank">https://orig=
in.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees</a=
><br>
<br>
<br>
Thanks,<br>
SJ<br>
<br>
[...]<br>
</blockquote></div>

--000000000000e5110006608fb9ea--

