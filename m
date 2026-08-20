Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06DEC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 15:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F2D6B0095; Thu, 20 Aug 2026 11:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20FB6B009B; Thu, 20 Aug 2026 11:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F656B009D; Thu, 20 Aug 2026 11:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7939E6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 11:23:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F786140197
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:23:56 +0000 (UTC)
X-FDA: 85122018072.21.07635EC
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2162910000B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:23:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MEVdWEUe;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787239434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lma3KONpFpngSE5q14dN/Z1uVUgszHUnJkkI2Hjlr4Q=;
	b=ItTX/AdaRrsgR3GhyiGGmNqgrPZCuSEojCU5iopFf+lrGF63wVUArvKoa9JTU/P7BUnOIG
	O5CDyptsLImjuCGPwF1ynp95ULhHKHxpx/Z7zQCdmCsiR/+SOW4x7pDR1ZLM0ehPwm5sXY
	cBFA32I038Y4rm9McFRY613GuCkDsRk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787239434;
	b=S8Mscp+EpUh3bh26OL38TS/0aXS868B5Dct/U/lVmLmv30uShwOTH+Oq8j+o4c+ArQg/sx
	rvGdkxd60SkHTU2R+pp5EVQSwvpiArQM0vz8RKFDZLV/tdhgRd1zUU0ZdIyhmai879KExp
	kqxF8jtfrq+s02oBTPtCoupG3mBj9N0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MEVdWEUe;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b440b97aso68035ad.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787239433; cv=none;
        d=google.com; s=arc-20260327;
        b=kyLcnZGGSg04cJT7xTTop4Mqlf1aKZXrAZwdU3n0qsA7eHU+iV1CDvDpVVAco+46Im
         FbHknRVuMdog0bFb+01jfugP6uf1rLm9cqPrkgXat3RbsGNhTFS+32dSIgWRCB0xzUUH
         uCWHEV/WNXNvwXSytWQah2D2V92AlyHgzKO2c/iPx1ZEWRmN1s8h62A4lXzX+f1Wy7zm
         M7AKtJI0q3iEPNhbzWgB7Df8+OCV3rgeQXVfRozD4yH7KE+Jtl0XwUzrxVV+WYVF4FfV
         3UfPlKLeI9ZpxGyoa60gKBkfv3QE9txaE1iIz7CNnqTmyP53nnKadZntLPn7jNp/Zd15
         fACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lma3KONpFpngSE5q14dN/Z1uVUgszHUnJkkI2Hjlr4Q=;
        fh=DdpAL1elho8YnwdhK3114O0f+zdmvnLO9+QGNTXTB8I=;
        b=FbuYN2nlAtzzp/KxYQF2KH+enYO2jdoJoqysGBZeo4D27raKRhpBrC7doPPVXZ1Cyv
         GxnMhruPjZk2WJazRj20eks9feuzALF/8raH3u8BG/YIvPmsPvoEmbUkedggyyP8wYD5
         IHREGDxMznrrTjVvgCVBcBBi8w40egV33KOfGdryZNRcJ2xoPwW5IHlXBc5tkgiy8El8
         REcuG/SXmQVQsGe4ZxAyjrzy85ujgOTMbN3WeCzJ+NTlsuWN3ftqPROopcp3dxXitiMn
         28vcYuH6Oc3awQyBMDmOkqGcJ5DgoLKyZIuDtlgwWa6DrpFMif1yo7hYNFgeC8rQsca3
         t2GQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787239433; x=1787844233; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lma3KONpFpngSE5q14dN/Z1uVUgszHUnJkkI2Hjlr4Q=;
        b=MEVdWEUeCbPuswG8YJXIfC5LYBHZ5jKRuT6HQhN7ecNd3qBjaTVjhuWVvbgudEaHMd
         eWG/4Mxhb8S3jfOUvv+3iv+iS8RFH26C2x5WoN1cG4jczEwU0O7ZR3/cHYidL/YpR7n4
         9BvEuEZsyXT6E7Q0d6YkEaK9W33CoewFrRmEPiyAfw3Y/grFAdLGFSLSxeL7b4ZQs3Lw
         PwxbDnjyr46vXBRZwH3pDhl2xIoAUWwF4R4Cum7DqBkP6sJd5eiUlAsAHdvq8AmOdFSg
         h18ZdpwNkW4x5qC8oykuoZWNCqznZYJixp229+RnqDbDJ6RySTUd3Mfv2I+uvIC4UAyt
         SwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787239433; x=1787844233;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lma3KONpFpngSE5q14dN/Z1uVUgszHUnJkkI2Hjlr4Q=;
        b=NSI7oiDgb4Ul6iEy58h3h8P765n09LeKUF4XCqNWA+6HfhZ15b6SRV14/cL9XsaQXx
         soc9fAx3PUejT2Qj9gfVabMj2pzUi5k157cad8I0O210UxgBaI2jpv4BFw1dP7o7UIMD
         tgKeNCEjHcNhY+a9pL4+u35clDuPD+NXzx+2awzqiLOT3MVeyVTFTHTpxW8EFHs924DY
         pdGkrvmFjslMB4chb1R8+m5whA/RpyTnEmHAQvC4SJzTrGzj2Af2RsYFXaGOzFdE/4nj
         H9zKrsJRIe3aRJRZJmRSVRS3KetCQn2Z3pvUARNClD92b2fpdseGdWfXFERKQg6RA4bt
         oPqw==
X-Forwarded-Encrypted: i=1; AHgh+RpIhKsrlRWhD/EhkM+ua+DaKcnJk/glCXm9mBR8+Oe3PMdcgqQLUDvKwBUpXhLCZ4UiHEW2Tq+ndg==@kvack.org
X-Gm-Message-State: AFuF++kz4LQjm/Sy5rbbB9ZYXBrb20OL8Ae2m0p0j7mycuKooZnPEuJG
	zk1L8sHq9cavr5V23jQOXOSE9N8n4vqGCuTpdGJcmZeo5qdH5wp8zaQCfwpD1U4I/tpy2oMG8TR
	YQ+JmI5fWEP1F5qSFQUait7fmzBt/oC96qRSzrv6c
X-Gm-Gg: AR+sD10arTd/YH5ulUdHAb6sP+sDu0kva/ERDAz7Alk5HnYPJtufilkwGB2jEtcVf9e
	oogwyUOtQHjQSC57RXPF430I5/trZSJ8kewWXOs5Hhnr27jfzA9nJmLI2jE7h/speNXET/ukdXe
	2xe7MW297g9kjimH3cM+HWGIGXjVPN1e3Ss/xTDbTjcc0VDOUijBIfysBScDJx2I8FD0Wm8EThz
	4K50r7glq4HrJwjlRaTm9iYXnCXaZmZdV4QPfCLG0wC1r/BweNGXjtBDAYyGDMTvE85LkcekaAT
	Nn8pQwteU70ALsF3JAD/uyUmc7xbscyqGVdiBCD6AGISEe4rMeDQU/X1AusDPDNb83fSSuexBr/
	gMJuE0PE/H0D3GhyxteUEI914fX2b+w==
X-Received: by 2002:a17:902:fd8b:b0:2d5:db38:8013 with SMTP id
 d9443c01a7336-2d61eaf0bdfmr8352105ad.18.1787239432253; Thu, 20 Aug 2026
 08:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com> <CAEjxPJ714iCMiQRVAN6MQoOyNx998MS5Xfhbhmugcwz+gWYAuQ@mail.gmail.com>
In-Reply-To: <CAEjxPJ714iCMiQRVAN6MQoOyNx998MS5Xfhbhmugcwz+gWYAuQ@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 20 Aug 2026 17:23:15 +0200
X-Gm-Features: AcwNN1WfGO0jtM01Prl7T2bhwvtOuD_4x4w_Hjk9Mm13CRcqjZxrghBAfwYQIPw
Message-ID: <CAG48ez3h2Gft4onQ8AgBmf8gHrF26YqTinajuBysNPkUKaTBoA@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: qx1ywfe9jg3awd4pum593imqcbf4jt1d
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2162910000B
X-HE-Tag: 1787239433-605465
X-HE-Meta: U2FsdGVkX1+Of+2uC8UrVxQQlWCuUV35HgmWIlKukt7WqGKv4zgBE+keH+RfbuAOClPJOpW2IV7CPBgXb55UlB+Xd0gKoKJk/6QYR5udR5vI/Jh2/nK43lrb6H0+Tjv/V48FavP7xerbEJMf/abaluXT6h/Jr9uyW9AoCEd++JS5MzJQYFrjZ8pUEgLypO7S3Zgfa8MQDMfc4z6ychm13I4zmO3lkxKHk6ZHbcjeYFxfoqv6xVX2dl/n/I6Ln258aqSEHyiunp+P8tUCD6YaN5zm9BF6jBvmnS/Mjh6wNXWp85+Ee/NL9Bcg90v5hwGnTS/lmKMcjlOrXjuDkV7JHJ3ntJclzMvsvWKpXVrA6Kg9sov5U6VZal2Q7onrhGwTkl67yNOJXKl6MO9gDpgCb/N9eYfsYt2tQ97hhsMpPJEHjLoHY762XSP1s6EgIcObyGW7AAVrFrpwl1o6qbfPiyWGii+LyZisxLW16OFxOlbNnSCwGNuFzntr0WhBQO0kMIOW21uijrd1fWNi2Sb4Ao3/soCDRnTQcX3KIle48YSX6dOdt74xDAQ+cSJFDQ73BVJOec5ry7v6+yDJiriEfR1xRRQyZcmvslHHhDo7BGdZgm8ajMVNykH9Z7rSO/pp1hrOAg2lxDBMGhZRLV/1zQo5Mbua454mcASlOwEjBQAlJFx0Rm3U4uKoPvZDnNVS8gvFJQJZv3ule+0MHtaUNCPl1atTlOoM+A8qE/jLqI/BvHS9DHYkECh6KA7FYygS4XijSaRe6v53gV6g3D1W9s4lXF+yDZgfTt0pS5ldFtRFqPeXQd0L2ZywC74d6j7rk4S2pc2KjqTQhp+7vsnbDwoM6LpMmxEQSLYf+flm7OkTQiuehdJ75pd+DOg2qMAzDr1v1JfZ/GzW59usv37qBP6gTHCRreZhcDBqQMPHQJXbHxS+ncpvAV7zQPU/NV3f99Ow4PELQQ7fGks8ZJi
 3jyhZX/y
 eetPm6cn0DtIP7Ls9gImHnYYces17uPGoJ06C1U4fWBeAupB5EMV4DjvcKS8SS9Rr9PMeuCcyy+UQkp006SKv/7vDKf8NH5ssdySunrOkPmaNR+iBAVPamICVd3IYAkRx/iX3NfyG6zVsZveSIekIQP8gBQFEjOVCALR3l60Tu+CGl7WPbNMKQtn7shlMedSpjt7mEazIQh0F+gjXznRIZ1OleCdSV5qI4zQBffZmSkJTVmrckEQYDhnxhH5ftybzL2sVyMaqrkFY2y/I0U8UepjKSqMmUevmTyhWk7aDeM989tfOsXyh6TOlgfzztj0e6B3mCOxA2FKfz471syD0uFcwPvRUQaqNn7Bz0SRQj1TZfZGSmYnVH2dwFuBuKrhnLNbl6nvDzHRdsfSCV3toPYtZlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 4:54=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Tue, Aug 18, 2026 at 3:51=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> >
> > On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process=
 can
> > only create anonymous executable memory via /proc/self/mem if it has on=
e
> > of:
> >
> >  - EXECMEM (like for other methods of creating anonymous executable pag=
es)
> >  - PTRACE (like when using /proc/$pid/mem of another process)
>
> Allowing it if _either_ permission is allowed is unusual in SELinux
> and seems prone to errors.
> Is there a reason to not just require PTRACE always?

Hmm, that might work.

My two concerns about that approach are:

1. This is an operation where a process acts on itself, while PTRACE
is normally for acting on another process. It feels to me like those
are different types of privilege.
2. I feel like blocking this operation even for a process with EXECMEM
privilege increases the risk of breaking existing configurations.

I think if we want to gate it on PTRACE, we might need to put this
behind a policy capability and let policy authors figure this out?
But I'm no expert on how new security hooks are normally added, or
what SELinux policies outside Android look like, so if you think it
would be fine to just check for PTRACE, I'd be happy to go with that.

(I've caused stable regressions several times at this point and am
trying to avoid causing more...)

