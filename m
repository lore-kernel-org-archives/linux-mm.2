Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E986606A331
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EkbMnleH
Received: by kanga.kvack.org (Postfix)
	id 22D096B0322; Mon, 19 Oct 2026 13:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2052C6B0326; Mon, 19 Oct 2026 13:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBE56B0327; Mon, 19 Oct 2026 13:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D09686B0322
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:39:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63C741607C3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:47 +0000 (UTC)
X-FDA: 85340088414.04.9DB60F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6014F4000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkbMnleH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792431585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnQBvL9ThoitpYzUQcFIdzE3H2uK7kr1ppoIGal+PjA=;
	b=pV3nIhTmAIbNA9nEoLW0jIe48Vb84yce1UiZKdh1TW6zPN6Da1EtcvdKaXCBkAHkX0vLpL
	ZP0G8O/6aof97YIiB0w73h3jxNC+v36FHJ66ZmKSeQY2j8rIrWnw/HGTfQWu4ySik+NHrv
	oEkorrEckHk7WOMXhdVDzmg2Zvt11qg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EkbMnleH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792431585;
	b=v96O5do+t5a+i0C4NGAl1V0XXODqHSLNyePQod8/fM59gufxXT9YrwJEzRJ22ZXg0GQSjx
	WyXokZOlL/Zp45iwviuFHB+1q5+p90kF7nWMAudOTrbDamcyOKVBcqbRyAD8keLcbu6Id4
	8pCtmnUqH27ob6nKHlPNAtDdl+LneP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56693434AA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350911F01574
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792431584;
	bh=GnQBvL9ThoitpYzUQcFIdzE3H2uK7kr1ppoIGal+PjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EkbMnleH6Ux0aJawtFLpleM4XWROY17SoR2ZJUVHht30tBfxhMdGVLXQPeKAHJl4a
	 m/Z8JPoRveVu/5pysSp4L87w64yZqLzTCeH0I3RldQg3932x7x7HjTG6If0oePfWPs
	 Iquoay8yGHz9oP//eJtPewhK+vm4RNOxPMLfrPK1yZlbuHNONZnnKFQH4s/Xf238hq
	 /J0ODclJLzjeqfLwnlA2kxPObjzWwPwO5o3YK0FHiBtn/1GVjIKsw0eaLFEXQRrilH
	 DYLgxeGOaLNOeSssJY1nAy0dLbEb73T8Pl7tobbbBUo/BeN1EpOanMu0ZvjQ9ZrK8b
	 9M2xoZP0tW2MA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c315869241fso263266766b.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:39:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByX4y6YgukjRJNf1geDTb1K/FSPI0/EUtl/IkNCto4uLxK0F+/SNxU2QkhOqWjrZw0omYxtChFM+A==@kvack.org
X-Gm-Message-State: AFq9FYLQZepLi1PMgUWI7/Ty0kC11UGTSl60Fy2MpqIrE9vNkSkjcIgb
	F0gzGpUR3tPd3rTF87pj2E4QyWual6mvUlwJPzrZJu9Wqaj4D/vbbjWVxO922J2/uFKKpGldWp6
	Vv2X/a46sHfEElFi+HSAkALklooFjQWI=
X-Received: by 2002:a17:907:944a:b0:c40:19dc:a24d with SMTP id
 a640c23a62f3a-c419e648fffmr666097466b.9.1792431583119; Mon, 19 Oct 2026
 10:39:43 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz> <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local> <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local> <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz> <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz> <atY1vWRBRUwpISKb@pcnci.linuxbox.cz> <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
In-Reply-To: <20261019083529.a81910ac0976c1a5687d4c6a@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 19 Oct 2026 10:39:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
X-Gm-Features: AclHuK8n2lTFq8e9VdttHlGOs0y_QO-3e4ybHTHpOpRKbp8_vTnwjvldNPZm8AE
Message-ID: <CAO9r8zO41EromgLGhKv8H0aKXjrffH+t4CFGU6cLo59JJ3CEuA@mail.gmail.com>
Subject: Re: hunting memory corruption bug in 6.18.x
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Sean Christopherson <seanjc@google.com>, 
	Borislav Petkov <bp@alien8.de>, David Laight <david.laight.linux@gmail.com>, 
	Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, 
	Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>, luizcap@redhat.com, 
	pbonzini@redhat.com, Tal Zussman <tz2294@columbia.edu>, 
	Matt Fleming <matt@readmodwrite.com>, gregkh@linuxfoundation.org, sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6014F4000D
X-Stat-Signature: whwksfb8iywghxzuoeqnbtiesfjq1nza
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792431585-776035
X-HE-Meta: U2FsdGVkX1/+tqVR7IDWAVlC3rFZeoivE18EEQNvnMuGNJFMic7PAAdAFMQ2zK/M3TbYJmO7Bo+9w8PtqHgb49Q8YqqAlb3pDaARzxFKJ9wGk9w80wv+/o7ge7hdL5HGdMJMdTa2Rqx/bQ+Tecf/3wBAISmBa/ncs9zLsIK6QbdunZzRTgahV8yMv1S+vcvv51xfHbyuaOkBUjW7FpQlKEXKB0FhC+XZ7OR8WRLFthTuCE+YT+a7+ROSoXX3D8tvcGmG93irVbl20tK/q7FBY5mUkv8z/NWEa3WtIVHnwCqc0FRU8FO873qO8ss0gvBOVbWHVsQm1V9fjEnXqqWm9qyMqnHJA3aPqj4wFGDNLCYIJg+Ca11ECOfXVVJ9kGF2rKA8eCqamHEMoBPQ9dGu5TDUz30OaKonkEhBJINoLuok9Tadtmpx+ZHqAz7gaE+NMT9ZfTzKxmHBXVI7o0ATdcgyCPeeCVVd5ifNstDRSrqH0wRq9cpgvjme7emIy4o+AYfaBrBWcsgKYQk6i0WQ6dqLq9fc7+WbyEz39R1CTr0cSRgm5OqLQ7Ca7KkkUJM9EgZqcO3o52FYt8ls/5tV+oP+uwVf8KWtNS75ZruIunqv9vm/cqeHNJbcfUqCoD7y8stJUIXWeXBpcTWZhBDzFG56Ijq9NZJCbi2QGa/Y9QdEPj2IIJcmC91xa4jt99jTNxRLUfADTU0c18Foh67w0F6goo9TPkCXXshVwEh3SuwVfDX4XJ+cCJeeCbiF4nCS2aHITWBPSVKfzTPbX9gfIYCqlpCPlBDkP1X/iehMnfuuhOJ/MpVQGiTr/qeE+o5Uo8AJvMsCNwasypY9P3mTMmEs6RNrhxFjgJb0R7Qo35XMWF0Gr3A1/Cv3EB8+j0/OE5orjwO3CPJJTFz7dNTFAOt9gVHSOxzzdztP08s18v796P3b8qOjSma6TOmSqynEZhtjW8eco5PpUDikg67
 /d99mGwC
 T072YHqQf+7Jp1VgOgTD1H1vpx76P31UxA/NoM0GrrYxxIDQfhO9KXlfPcy7jd8vsk1PZMmDOr9PBXZ5yV3xjXz0uHLcS9N/sWQ0LG7tD5iQUrglr9paGRIaDh5f6HIEzEGwvIDxqAMXd4ZJluAIlTgkumx1dn5+lK0CdExxeGS7EZ4PijtRGQpGCY0/qyGrG6D1ukPtyhzCVT2RlRSoXQlCnvHJ+1hhPcJ9aUjkxNRUX9RTWCGZnH0DiD3BVIlmdfNMYaTa62Y1ivwge+6MMt1/J+NogokMvVZ/ONr9UsXj98kSYGXyYNf+y945UtFcz/w51wKHq9+J3SvOnEp8+2Cu7whLT1BwZ8dGQNpEL7Gx0r6aaI2pYrI5pweYaqouv4klFK7zVskkPZTNiahd24iPkVBWieCR4eKoT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 8:35=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 19 Oct 2026 17:22:37 +0200 Nikola Ciprich <nikola.ciprich@linuxbo=
x.cz> wrote:
>
> > >
> > > Sure! And I have more good news: after applying 55780d8a1dcc
> > > to 6.18.56, I was able to perform more than 30 migrations without
> > > a glitch. After booting back into 6.18.56 without it, both VMs
> > > crashed within 2-3 migrations. Furthermore, some memory apparently
> > > got corrupted on one of the hosts, since various commands started
> > > crashing too:
> > >
> > > [  303.466091] traps: systemd-logind[3085] trap invalid opcode ip:7f7=
b5667e616 sp:7ffe1afdec38 error:0 in libsystemd-shared-252.so[7e616,7f7b566=
6d000+22e000]
> > > [  303.493810] traps: systemd-coredum[11269] trap invalid opcode ip:7=
fc6bf67f614 sp:7ffc075da958 error:0 in libsystemd-shared-252.so[7f614,7fc6b=
f66d000+22e000]
> > > [  377.528955] traps: systemd[5607] trap invalid opcode ip:7f791447e6=
16 sp:7ffe83e61cf8 error:0 in libsystemd-shared-252.so[7e616,7f791446d000+2=
2e000]
> > > [  377.556993] traps: systemd-coredum[12080] trap invalid opcode ip:7=
f97ce07f614 sp:7ffe28b56a88 error:0 in libsystemd-shared-252.so[7f614,7f97c=
e06d000+22e000]
> > > [ 3746.173043] traps: hostnamectl[45846] trap invalid opcode ip:7fe00=
cc7f614 sp:7fff89916e48 error:0 in libsystemd-shared-252.so[7f614,7fe00cc6d=
000+22e000]
> > > [ 3746.202305] traps: systemd-coredum[45847] trap invalid opcode ip:7=
f7fe9e7f614 sp:7ffea227cfa8 error:0 in libsystemd-shared-252.so[7f614,7f7fe=
9e6d000+22e000]
> > > [ 3750.581940] traps: systemctl[45903] trap invalid opcode ip:7fbb896=
7f614 sp:7fff733e5748 error:0 in libsystemd-shared-252.so[7f614,7fbb8966d00=
0+22e000]
> > > [ 3750.612651] traps: systemd-coredum[45904] trap invalid opcode ip:7=
f90d347f614 sp:7ffdc7f55148 error:0 in libsystemd-shared-252.so[7f614,7f90d=
346d000+22e000]
> > >
> > > I'm not sure if this is of any use, but I collected a vmcore of
> > > this state by intentionally crashing the host via /proc/sysrq-trigger=
.
> > >
> > > Anyway, I'll give 55780d8a1dcc some more migration rounds, but it loo=
ks
> > > promising.
> >
> > 500+ migrations back and forth, no issues. I consider this solved and a=
m rolling
> > out the patched kernel; I=E2=80=99ll report if anything new turns up.

I am glad the commit fixed your problem!

>
> Great, thanks.
>
> oops, we haven't been cc'ing Yosry.
>
> > Definitely a -stable candidate. Andrew, will you send it to Greg, or sh=
all I?
>
> I volunteer Yosry or Sean ;)
>
> I think 55780d8a1dcc should be repackaged before sending over to the
> -stable people.  Its changelog is very wrong: "The bug is benign
> though".  Update the changelog to explain that the bug is in fact evil.
> Otherwise -stable and further downstream won't understand why we sent
> it to them and won't understand the impact.

It was found through code inspection, there weren't any symptoms, and
I think I know why my analysis was incomplete. It assumes that
svm_recalc_instruction_intercepts() already ran at least once for L1
(vmcb01) to configure its intercepts, which generally must be the case
(L1 must start L2), except during migration :')

About repackaging, yeah we can add a note about the new finding and
the necessity of the backport. One question tho, is there a way to
send a patch to "all" stable branch (the same effect as adding Cc:
stable retroactively), or do I need to send separate backports to all
open stable branches?

>
> And that repackaging would be an opportunity to add
> Reported-by:/Closes:/Tested-by: you, which is the least we can do to
> thank you for all this diligent work!

Will do.

