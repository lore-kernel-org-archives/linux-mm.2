Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34A8C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8A26B0095; Sat, 22 Aug 2026 17:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF426B009B; Sat, 22 Aug 2026 17:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80C846B009D; Sat, 22 Aug 2026 17:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F66D6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:10:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41E7D1401EF
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:09:58 +0000 (UTC)
X-FDA: 85130147676.23.D1E4D30
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E790120007
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:09:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787432996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tizi2Uz63VDjzZwu+pGZmliKPuwtoD7SrzZgbbbMac=;
	b=FrN959t2V51YSFmoQNKUYqUJVZSz3YdMNKErykfrqwH5v0MkM85Qgc3AITOzbBkEmmtGs7
	wIhHFBm/3SRnXw+mLJtnYBCORibPUd7aM7PpdBtQ6ttkaqRg2RYZmNOT21v/E/zCiEMgkR
	vc7PtGpHZZOe1seD7m/irVj/OOw/CBI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787432996;
	b=RfMYWPxaquZgJjTkAssrQPDI0Ju/iroh7hxKBZrjrGsifjN8Z6U1qOtntr15ZmuL1PLk5v
	tRuYu4XpEuT55Q1sDqYiVpfOpkl6fMeOQNtJ5os2V1eErIWkuCHDYtOJZJdGWmVVzcuX3Z
	oLhdOabeDJpZ1lUX7eHV+35Cm9GL5hs=
Received: from omf07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA34940203;
	Sat, 22 Aug 2026 21:09:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf07.hostedemail.com (Postfix) with ESMTPA id D60A32002D;
	Sat, 22 Aug 2026 21:09:39 +0000 (UTC)
Date: Sat, 22 Aug 2026 17:09:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bradley Morgan <include@grrlz.net>
Cc: =?UTF-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, bsegall@google.com,
 dietmar.eggemann@arm.com, kees@kernel.org, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
Message-ID: <20260822170928.1acba2cc@fedora>
In-Reply-To: <4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX187Mxv5W4DFJ3fURMYUvMnrhDd8uqR80Rw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=8tizi2Uz63VDjzZwu+pGZmliKPuwtoD7SrzZgbbbMac=; b=cZd72qi9ymxUl9V8XfieHWrIXrJ1PnIzyJy+BPyUoZrE9UlS1TULy/OrTaw0wO848HgkMqFDmS2QTWaSfHHIaxvi58GjfP566ANuzX1viHqvMYZh2GKd5g98sj66woLci9OVSoVcVP1aXikh2H3LscvPwIPNvQpx1J279Q2CNX8=
X-HE-Meta: U2FsdGVkX1/CrHML0TEz1SejKFmkDQnB4+yKcjQD66q8Jcu+lGWPWRCs5jyXT3aVqU8qktRFuQNQhr6DRgV/hroJHlTbByDPzksYd2yEIXrXn1wGg0AV8iDGQCD04ysBGEA0GaxkiSRvAdqOGoLfLVhYopv1sGOP+9U1Y3tKeC8cZsND7kDaEJny3ouPRaHP9b3Mv5J3czn2EUYy7qEhXOpWH45TNyhEphrDGaGdtMeC3MLLHe7OorJSN9Y7OS7kqw0zHcCjXoyU5LRWKphlXUx4STKkxO8RPpUOr56rBwhwC7lrSJgPCl6Pv8CHB6/fS6gbvhTxgZ1uJ6CKT4Abp/8pMJVjhqAhgTqm6ucrSWd3ASzCABe5VBKvQ5NQdCXTvo+3XJKR9laQVlc7BzA3Uw==
X-Rspamd-Queue-Id: 7E790120007
X-Stat-Signature: bchptuiitregw8grxmyadnsig59ji9zy
X-Rspam-User: 
X-HE-Tag-Orig: 1787432979-424543
X-Rspamd-Server: rspam12
X-HE-Tag: 1787432996-214025
X-HE-Meta: U2FsdGVkX18DNLfx1OWYCBKPG0G4F2vp6mTkVMOWqPtwLkEczcYPmJ9H0sU6+wtmyXNG18N5SCO5l1Kjo0z8f4/ooau3TjroE7k767hXCN42RNIlSVtat0xjD84e4pOkOKCh3uBmmqfe5lXVfcytheZ0Hl3yX3wCvXzdVy9W2iDys2lxE/fTVpOjHquqcd9F48CUJOI8A5iSXE65ICXcUpUIV/To5MMPoaY+Rpf3wozuzVgYXN0HsCJFaf5GUNnCwToQUIZ8W8sRqoFI4+KsOPEvRBH+YkfIs8dlQqnZNWCXOznjEXIpFdQsMs+g41GL0wqi8V0gNCL5gaKYmEo42wN1CQmkLvRO8EDRBzJkGUWnEZEuEb+ZvmUMgdhMAuCgjIiWiXAmb4eOyFaidUIcAbj6sL+CJox4XLR0u16s8qpN+IFmgn7hpr/S5Wu4/vmmBj03tl2VCamhSaJTfcenjpdvWC9MnjmQGETjbiYukIazOSnhNTRn7ydTunVjpFfWgS+XSjVVPVsD8hI0F+GyRtvbHY1kWrebuB0m/WaOHb+DvIfHZwaMUO0Onk93jpYns+494IuvTWv3I2PY6kQSy24M7RQWajDHGahytJY9VoRBDR52fW5H7iDvMZ47PZAoL635TJm6fBc738BTatANsRbI/0ArAcOAenJqUyhb6UdYKoAakUPrdC1sPHzaQKEBYMGx6Y4k6LUnQKJlwB8Ka2gib7LDWP05wMrWJasoAO6VnWGRi70819o+fKZjFowuCv2RdK7TB7XYKUeHcz5wOIH6ReP2cLAv4I6xww/5mnXVkMbmBpi9c3ElkLlZDfaft2WJXEJMG3CyBlAOd4rvK2KmgwjLbyk63qnIliIdp2JFKX2UEeHJw8AvyCC+yzELMGKsaCI3dA24FpRZGenUvIkunshKGb5zlcgCQAnJ9mqCiZLxYuvMUHUmTp990uBGCaYMvaibZugQmjHu3A6
 ymNZ2pJ9
 KwcBm9ljhklOtmW8ACQF6K+LPb5Y5oVhIz6WcfAQCzcqn+iBPna0Ml7qY/HO3z9hqKLTBYAm9Q9os2XMX39klb5l3QvFR/83dxN1BM9ggds2idSEZAnGkBGe4MWbzSs4SzR912POIqjl8WV4qtfKOzs40knZ7XLnj70OUX8BBL7eO0HKXtC18opGkHU8OioWCVlf3aSQH1xcRIyna0XsNvZ14nkXYOV1az4exBRGTV0fxEHgLjTbdY0SU0DOeMF3WGxmsiWMVkePaIWR2V+Lh6Ub7eLqlLs7sQ0FccRHuXqVaH48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Aug 2026 20:58:15 +0100
Bradley Morgan <include@grrlz.net> wrote:

> >Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")
> >Cc: stable@vger.kernel.org
> >Assisted-by: Codex:gpt-5 =20
>=20
> Where's my R-B, nothing changed also, it's V3!!!!

No need to get so excited ;-)

Anyway, as there was no change, it should have included your
Reviewed-by tag, as it will not be automatically added from the
previous thread.

>=20
> >Signed-off-by: J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> >---
> >Resending v2  =20
>=20
> (no! V3!!)=20

Right, when resending, it is best to add "[RESEND]" to the subject:

   [RESEND][PATCH v2] fork: initialize function graph state before copy_exe=
c_state()

And below the '---' have:

- Resend to include linux-trace-kernel mailing list.
  Previous sent patch: https://lore.kernel.org/all/20260822195321.962383-2-=
Jeremy.Jean@oss.cyber.gouv.fr/

-- Steve

