Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428C7CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710586B0088; Wed,  3 Jun 2026 05:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1A76B008A; Wed,  3 Jun 2026 05:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7526B008C; Wed,  3 Jun 2026 05:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAA26B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:15:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A16FD161BFC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:15:06 +0000 (UTC)
X-FDA: 84838042212.04.A1CD065
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id AFD42180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:15:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nIbQzVZ3;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780478105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUny2P+n6s64FxOiYIiTZOU4vfbpKQNJRW9sV8W1Tag=;
	b=jQaduJrP1e6/W03QUxZ9gD8m/WU7z70fSflHcoSUOkjN98GHDs7FAR4VIHq5r0vOPKI44X
	jo0m7lH5Nx6mukKabUat6wOWWxKpnpPiYoUQNfEDkLXTKaL4QLIK5L70cIO21IdBoXXlPQ
	wm5EMYQcn0osa0LQ9LVYQOcMmIYqoY4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780478105;
	b=ZG51730dmPTYOJpzsp4KF4flZfMN5mbqcQzkJEqYdTEdYIvMgLSjVHzB1aRXPOauYZDDiQ
	ffzWZwcLf3lpfL4c7EASLslPThtKnLrnAZPOTIK3sbq2Af+pT8VdnEkgS/VBaONPh1aZaI
	2maHTQf0q49tnLp9SWuXexRoav9ZDmg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nIbQzVZ3;
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780478102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wUny2P+n6s64FxOiYIiTZOU4vfbpKQNJRW9sV8W1Tag=;
	b=nIbQzVZ3H+WQX7NN+qawhZFTFRXfAXwxX6AJ/g0g/09kHk8He4+ve+LZlKYqbTxXHBj5UW
	KDShM9jzOLqSvJIxaKVKSpB9jWzIzPhMXzqfV/wsqnn0t/3wbn3A7eyhtqJdNWI4Q9AcKm
	k0Qsj1cn9FVSB8hIXPbvkmZscVdjwGg=
Date: Wed, 03 Jun 2026 09:15:00 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <1eeea60ae762c3969344592bd58a50082877ce02@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, shuah@kernel.org, damon@lists.linux.dev,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Kunwu Chan" <chentao@kylinos.cn>, "Andrew Morton"
 <akpm@linux-foundation.org>
In-Reply-To: <20260603050219.91743-1-sj@kernel.org>
References: <20260603050219.91743-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AFD42180006
X-Rspam-User: 
X-Stat-Signature: wnwnjh4bon6msjaqaaiw4e5g4oxsyfbp
X-Rspamd-Server: rspam08
X-HE-Tag: 1780478104-434334
X-HE-Meta: U2FsdGVkX18sPFBmb3LGi1qah1PI+W2ADtWjjY8G6ALDuSLiB26G5rdvS+HXiUVkIbrQS4ek3c86GiH6iyKXpU77hLADaFkeIPLHp8t/v8eGQv22C6r7sfz3ikLmbPXCGIzcjPag3sJ98PeXmNZMUWa5GfhTjIWg1f+6BE3i9/esKYD8ZnUek9DzMqsN8kQSqCS4moFSCxqx6qVwoOqZOlBeOIfY5XQC10rLWjeah1MvvVWxQntX8IDBBwSUfuvISd4BsK7Sa6MYeH83ZB0SrQ2SzmfF6StWZqhYHlSvxG0eHehaDIeTNqmxxRF7VwPgMToYCiB3fKkP6MZeHCnBrqV2ylbSQuxV+3flFLEuNOUKS0k1fiuMR/UXpCuUKtJUM5BKUlXWXjxI+TESvhgXwv0r3LFvK+l+H8dOLT1oAbEMVqqDIg3S8aDrWHSynPt3snpdE7c87gIgFYUl+D3eFXkfJrFAzv2NtRb0fQHkFEVk8O/ceQAyz6l2VCP6S/ek1UJKDrArtY2RG6TrhRV4PgCRuqHcLdwbi5zRMkNyJubSd2NSzi8jCF5tkDiri6/g2sgdrHbHpx61JTvnKDx9mJFYOfGgDUwCYcQMObdZuBZaYYAO6/Y84CUUvnlrTj5n7hJp1H3nsKSxUM0cCk6HwfYjNaE6bb4kBycGuaHP5r06YyKmxnIYGdjJg+Oe3AAEq5wnvu1gNtDiK+SErOASObftVawjIcW7TtEDuiKN4oas/yEWf/zh/b8fCPg+x/reDihMhD1mJ0MABRwUi3T++9xG/QNkn9k4p85pcQblpJUuSoZMyABxlq/1yc9hd0L0NOMP2d3BkLL/6uAXf/4T6RwdWYVVPBD5aLka7ZWvQQX47pIlpfAVEVAJiEDznRs1CbwAoZkcbUHEhCdMdEQSAvpd1COvZDbcAZRbNsighH/Tcd9qURBnlRVqPq0dI0gmskClrNQeezDIze8Ej4J
 F/Abmvfa
 tUgVdg4Sg2guYzKNUI050FNqSC++eKdqa7wodETtYMt2qJf+rIAZGhXRH35rTZxNg5G0xISyWJkzlpu655lqikYgkSDac1HrROpJ2ifsK2aZNQ8x8WSMRfCWwKs3g+TXDbALLSxhI7XLq5aAmpFq+AKLfwU98mlVxAlAZy2/DAoNYdyWI0CR9a9zc/XgTi7p2TNAYjA/NwC03WuC3Fq8lAxVXmWNt95SjZm5Jy5Lc5M+UtBDLV2N1nF20jFKFi/lv+UqjF05NOLqWa9EequoX9zNokFnGbj9obzjuBPFpINtUXQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B46=E6=9C=883=E6=97=A5 13:02, "SeongJae Park" <sj@kernel.org m=
ailto:sj@kernel.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > =
=E5=86=99=E5=88=B0:


>=20
>=20On Wed, 03 Jun 2026 02:11:33 +0000 "Kunwu Chan" <kunwu.chan@linux.dev=
> wrote:
>=20
>=20>=20
>=20> 2026=E5=B9=B46=E6=9C=881=E6=97=A5 22:22, "SeongJae Park" <sj@kernel=
.org mailto:sj@kernel.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org=
%3E > =E5=86=99=E5=88=B0:
> >=20=20
>=20>=20=20
>=20>=20=20
>=20>  On Mon, 1 Jun 2026 11:23:11 +0800 Kunwu Chan <kunwu.chan@linux.dev=
> wrote:
> >=20=20
>=20>  >=20
>=20>  > From: Kunwu Chan <chentao@kylinos.cn>
> >  >=20
>=20>  > This series fixes several bugs in the DAMON selftests. Most are
> >  > trivial but cause tests to silently pass when they shouldn't, or
> >  > fail prematurely on slow machines.
> >  >=20
>=20>  Nit. Only patch 3 fixes a fake test pass for "avail_operations" fi=
le existence
> >  test, and the series is not doing something for slow machines, right=
? I think
> >  the last sentence should be updated, for example:
> >=20=20
>=20>  '''
> >  Most are trivial but makes test output wrong or even silently pass t=
he one for
> >  'avail_operation' file existence check.
> >  '''
> >=20=20
>=20>  Other than that, all look good to me, and already have my Reviewed=
-by: tag.
> >=20=20
>=20>  Asssuming you are ok with the above change, I applied this series =
to damon/next
> >  [1] tree with the above change. If this series is not added to mm.gi=
t in short
> >  term (~1 week?), I will ask mm.git maintainer (Andrew Morton) to pic=
k this.
> >=20
>=20FYI, we are now quite close to next merge window. We want to focus on=
 making
> mm.git more stabilized and therefore ready for the next merge window, r=
ather
> than adding more changes that no really urgent. I understand this serie=
s is
> not really urgent. Hence, I will request adding this to mm.git after ne=
xt -rc1
> release. Let me know if you think this is really urgent.
>=20
Waiting=20until after -rc1 is perfectly fine, this series isn't
urgent.  Thanks for letting me know.

Regards,
Kunwu

> >=20
>=20> So, no action from your side is needed for now. If it seems I also =
forgot
> >  doing that or you cannot wait for my action, please feel free to dir=
ectly ask
> >  that to Andrew.
> >=20=20
>=20>  [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-=
profile.html#scm-trees
> >=20=20
>=20>  Hi SJ,
> >=20=20
>=20>  The updated cover letter looks good to me, thanks for fixing it.=
=20
>=20>  Thanks also for applying to damon/next.=20
>=20>  No further action needed on my side.
> >=20
>=20Thank you for confirming!
>=20
>=20Thanks,
> SJ
>=20
>=20[...]
>

