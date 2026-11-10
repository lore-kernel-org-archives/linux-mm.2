Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97B0606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZNk0F2A
Received: by kanga.kvack.org (Postfix)
	id DCB9D6B05B2; Tue, 10 Nov 2026 15:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA6EF6B05B4; Tue, 10 Nov 2026 15:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0156B05B6; Tue, 10 Nov 2026 15:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD7F66B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:36:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5406AA0A80
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:36:10 +0000 (UTC)
X-FDA: 85420366500.16.209C56D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ABF5B1C0008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:36:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZNk0F2A;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342968;
	b=I5EpoAO/oHEuycDzzsCpdNKDyYdjly92oUzxgDi0WWFKvt1qOSGmB6mfPrrnYjNkodO3Pw
	PzsmMMALHFdIrKpL9uL2dH/i6eBP6GR6t3+XO1YYg123oZpipE7tNgYCzecsVHw1sYDv9G
	s4xlhXb0jDSB379XRWW1/ZYmxObZZwQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZNk0F2A;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342968;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUgz3Zj4l1X+7pLJOjMeK6znxMPodZgNhJVee3GIBpY=;
	b=HDk/bdH/Bl32+PuQhtem9+y/wrDPMeiJJaYOkYlepWpd5YF3ItMqxL2tAwC0dLz6JbmcGQ
	zKvRN7JZCGomXljIZbL5j0r0CTSzran+iXpTkrktWYejh7ZJ+6FBxUD5pZ68CY4XMz8wZZ
	aiw9Ez0zwBlL2sUBmO8DWXmgYIaBEHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34CBC601C2;
	Tue, 10 Nov 2026 20:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A6D1F0089F;
	Tue, 10 Nov 2026 20:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342967;
	bh=ZUgz3Zj4l1X+7pLJOjMeK6znxMPodZgNhJVee3GIBpY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AZNk0F2ArbqLF1NOLT+6cm2uesJciY53GvhbThDnVJqf1bZG2MCJ5/Nrvy7loZ1gW
	 C9022AnNNRoYBC7ugXktDd2Ax7Ds7ztythfHq4vhKFNW/pTR6kxv1Y+P0P+iGmikmf
	 WJvHD+eaEiquCd2Hf97MvozEmhoE0Um3tZRf45KlTN+rQgn3TuUunqH2NEQ2aE01wn
	 yvFqIIAs51d+VKHVl5fKqUVNcqsC0W+3NNc1LgmpPs48SxghJ6AhbdkBq7ZaHF6JKr
	 ozcEymvuAGr3RILoBqmRXXhSrMbt/S3EWqw9rb2DmvT5Dp8eo73DjBgL4tWEVE4wkU
	 s85LmRmmAK0Qg==
Message-ID: <sashiko-outbox-207715@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 5/6] kernel: add KAP checks for unshare and setns
Reply-To: sashiko-reviews@lists.linux.dev
To: "HARIHARA SUDHAN. R" <harisudhan@armoriq.io>, linux-security-module@vger.kernel.org, "Paul
 Moore" <paul@paul-moore.com>, "Kees Cook" <kees@kernel.org>, "James Morris" <jmorris@namei.org>, "Serge
 E . Hallyn" <serge@hallyn.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Jonathan Corbet" <corbet@lwn.net>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Liam R
 . Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mel Gorman" <mgorman@suse.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ben Segall" <bsegall@google.com>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Juri Lelli" <juri.lelli@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Valentin Schneider" <vschneid@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Ketan
 Bhardwaj" <ketan@armoriq.io>, bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261110202246.274-6-harisudhan@armoriq.io>
References: <20261110202246.274-1-harisudhan@armoriq.io>
 <20261110202246.274-6-harisudhan@armoriq.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 20:36:04 +0000
X-Stat-Signature: w5i9wz7a87kezhu5t8rwrjiys6oqaqp7
X-Rspamd-Queue-Id: ABF5B1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794342968-278918
X-HE-Meta: U2FsdGVkX19jD+3puoVsXEfAmXncpoFUDsRmPdQu1OP5GtOAKnZOI5cpKX3pEq8i7sbKMTMSh6apGf3411u7dVdSS9sKENwYjoZqDrxdtrubGTE13XsxzB+DBOHroherbRU4+pUZ5fJGdKQV8+V+r73F9Rm5YOzLk5Zj220bXjr2CA8FJfr3bIhFTTEVpHVqaZzIkTLyQAAqreYfRclXog8t6MAS8jggRH4c7za5N5jGp7qWEBLE8myYQYFYrSqKgnAfRIangfxmgJ+/BK4d9RfCnI+hTwukYuBjT1Q4s9+lDnoK+FlKsLZTW91Ig69F88apiW2CbuSgb/eUNH+nB2DTKgW64codIIz0nytPpbjXzqRNvJ0v5VzRueUAYLxMImQH68D92kr194cMYwq79m/wMkM9GI1X6B+xW78UcZcG+ziZZBUfAbkYj1qCrQX2QLS24NhLlTOmZO3qzDPaZtb4TTnlCxgltmJuSScPdZ5ixqlb3qmWNb9E+/lUCuBIIB0AVUR4z9iTRD20qY3HKXLo0K7AwkDm7GrKSddffAWcGMBvWK4Tv209+xDAdwy3MPRpcP1IfkcVHoT5ugTkJFq9eE6xV0u/m1MpHRHg08SiXiuuHKgsBEN80FeaOk//ywtgfx83BTEOwEDKGr/KvtfuqcKg8kUM8Opj5J8+EuBkoyJ2fdOgy2CK/zDHChk0gmp2hMsbhUVc0b1MJSoIEytNwoWpoOLRhvi9a6RY+psN9pP7mtGrQYoxFQvEzc4H43Hrc9J+cHHyBtmNXnekiXZQb2IsgfOEmp53HMl/jvozHPAepFtA/6siHTpLXe438qZXpjr1V34Nkacx/HQK3Nr3e4l37q9dIUFn3tGSttbQA2fdlljNnOWy7qT3cpAl+ihFmwKxeUzTZ8LH7UWihkK25+9eAqnLj31W46Odg412+9KhaLoQcaSSKR+lVh8K69nPlJmyyUY7zzzPRd0
 rraWbZ+C
 5uAJqYcLvJqp7zJwZ3jFa2O9guroX03LRa+swYGXeK5s6e3ZfdEjfPlzeSrW1VDgrjS+lwAe08Ifsf0/HHIYIwny+cdg8xjQ/B3H0E0gh7b+GFh+XUnpL1gidU1uTxLE+eY0YQhYn6RQJOo/YIR8WEzu1ZpzTF+NvYBGmwJNZg0Qvr//3QxIp4x6z1cq0Jw8h/2QUhzEcsYJaHNmzgtHwQGjKIw7D6cmyHtiuOAdg8xNm5D52xJt3McK3QU63Fmt9lgXM+CNmoDYwkXPCHFEYgknWFXB2PKg1I1aJMI/y2P92/Y2Opr06WmWRvM/dyJaeKsU5j0jG/b2Vxs+X4nqp9ZLVrYTElIhAuIcPc2Yw2blg3+DMaUrY+EGyIZ7yWm6EdbKuyh1o7qvKqvW80O5OhL1SEsu4gyrtEJOynmFfrwo0+iSsWsbGs9oAnsc4pAYyanGr6AxNiekuEDIzVOeO/oWoSl7vGbHQ9zbcIYRr1LiJw2cVGMN777CVBVw8XHD79P8SyxXMhYFCfzGk3HUIKTEZhkdsvIuX8+M0IxmC/Fnufsl433c4i/AKcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] security: kap: CLONE_NEWUSER skip in
  kap_check_namespace_flags() breaks user:unshare rules
--

commit 9adc8e1a3a53f48cafa9cf1ec8d4bd24d0a65150
Author: HARIHARA SUDHAN. R <harisudhan@armoriq.io>

kernel: add KAP checks for unshare and setns

This commit adds KAP namespace flag checks to ksys_unshare() and the setns
syscall.

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 33760ece3bb30..3dda9f211ceae 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
[ ... ]
> @@ -3286,6 +3287,9 @@ int ksys_unshare(unsigned long unshare_flags)
>  			 current->fs !=3D current->real_fs);
> =20
>  	err =3D check_unshare_flags(unshare_flags);
> +	if (err)
> +		goto bad_unshare_out;
> +	err =3D kap_check_namespace_flags(unshare_flags, "unshare");
>  	if (err)
>  		goto bad_unshare_out;
>  	/*

[Severity: High]
Does kap_check_namespace_flags() fail to enforce "user:unshare" and "user:*"
predicates when unshare() is called with CLONE_NEWUSER?

security/kap/kap_lsm.c:kap_check_namespace_flags() {
	...
		if (kap_namespaces[i].flag =3D=3D CLONE_NEWUSER &&
		    strcmp(operation, "setns"))
			continue;
	...
}

Because kap_check_namespace_flags() skips CLONE_NEWUSER for "unshare", the
check is deferred to kap_userns_create(), which passes the bare target stri=
ng
"user" to kap_check_static_target().  In kap_string_match(), "user" does not
match "user:unshare" or "user:*", so allow rules using the documented
TYPE:OPERATION syntax reject unshare(CLONE_NEWUSER) with -EACCES, while deny
rules for "user:unshare" or "user:*" paired with a broad allow rule such as
"*" are bypassed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202246.274-=
1-harisudhan@armoriq.io?part=3D5

