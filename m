Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D88C3C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C37546B008C; Mon, 24 Aug 2026 13:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE77B6B009D; Mon, 24 Aug 2026 13:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCF56B009F; Mon, 24 Aug 2026 13:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87D466B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:43:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08FB3C0208
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:43:44 +0000 (UTC)
X-FDA: 85136885568.05.4F9A6B3
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A5E91C0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:43:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CzDGE4fy;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787593422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSsbOf3Y0yWkw9e5dn0dpe66TCS/Em1a5SohkF1dHrY=;
	b=LvqiLqu1s6/lbOn9AO2gvkO57/TV8rnsxT+Q0jcVth/seWH9CBcKSGUGwQf6Z+hgn5EiTS
	pLYmNxQx0IApV71EGlVNVu5KkQkCV3NRFeXZXQuEcaEs1l+UBHyqtq7AimGbUtNZ2FzoTM
	mtokIgr4RXH4nj+a8HmVOvXXgRcuzz0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787593422;
	b=QmpS8DXP5KvNm9tXxcnMrwlAoDrIN0xcYnlsIk/CTLBjRWxqugZxUwrpf+aL3XQAZQUeM2
	HdmVjklxKy+3Q4d17fFn5zIE8QQN+iYLgiPmjRMGhglym6gOgJP71UJSoRGk0re/rUTe15
	+sqcV8IxqnVoN96pFCP+IwPfiIgkp2Q=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CzDGE4fy;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d3b440b97aso11935ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787593421; cv=none;
        d=google.com; s=arc-20260327;
        b=PdR6uV91eaUpYZqe1o3twarSNdF0asS9AclUR9m1m4/oNGLwLQhFur5UIU8bbrux9b
         4qugAf5WkJOJO/c1n3iZYNAtPIZzIUQXJQJjWYJmxEdL6eMqEu88vGsaEQ4wSeoru2Ho
         qdKVchYGKK/kZeQnbkfxKkX+lG1HdO+G25f6RDAhY9NcKCPuQFrvuiNnX5JdqJ4+5F8t
         MMt1xWs8YFc1fXif0fJC3QXi5zB0aXBBtYqSA8qgyR+e1+LeT0Sbz759UkAB/QMPKZ6g
         JGt+wIEeE6O9gveoowJZ+I7dmFD4byO2ZjbzBNERVhVGSe3TbH6w6EaiTkb9G6jCrHUV
         WeaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NSsbOf3Y0yWkw9e5dn0dpe66TCS/Em1a5SohkF1dHrY=;
        fh=kTYe7q1RsWMFPZ5+pRW2RSZHKtEey+/akTVnkQlCg24=;
        b=phwMcWitnk4/qYY9K6qkkmxbDMTieaUSvoQThaiDvHJaQU5FlowUf6f3OZ3NCXyGPI
         uNpdeB9zcapaDGMymMookWtbCFtu07WvDVt85EbRtxNZ7hqVwWZSExs76EYN0XwhK5uR
         RsSWouatbDQNSV4OnHFgtDljENlmTnAlndH4ud5AhZgr5rHiFqsQAHqt3WIZJ5FY+OCj
         jTVHVoG+RKNhz8rEuDFZ/OhDNgt2IimRbPRTQT4UxapAQs2rIRy9wwbTwzTyNiqOy5KV
         jk5G0nPM/khN5lkAGzGW1eXL+E2AOvcqIKa4mkrM3mxqsZRd9V7lstdCBts88Ms850QX
         O7bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787593421; x=1788198221; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NSsbOf3Y0yWkw9e5dn0dpe66TCS/Em1a5SohkF1dHrY=;
        b=CzDGE4fy09v1Cpn4ctd1XCXPrAREhDPSJPYX+DkD3zEcXfSmssO3SoII7S13a1cOAO
         4Q8Y5QpHeTKbP0U9zTlHLWNgurJbsf9fVhP1SvoshK8aep5PKWjE7PAVXHsLOOB6kkC8
         DN7Qc37HRbGu3O+JLGSNToKUQep0zO8csx2U4zX4ccI6q1Wc6XZy2YP1Xjlh4a2f7eZ/
         1lM0rCKlw77ipRf/91HWbZUH/1hRnG5Vxn526QHPXBuKFHp9LaOcrt6cGVZ/QL+knU6A
         2K0k+bTf0BH7gl/hLNgnSN5FisMfFPtwfIS5TdwRk04m/ZQCD2MYpz/AflFfxJSyucRm
         4cdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787593421; x=1788198221;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NSsbOf3Y0yWkw9e5dn0dpe66TCS/Em1a5SohkF1dHrY=;
        b=k+VebBRC7R6M1F7G957+Rt7nNi5YR9argS1qXP37caL+Kbd2LXec55BwhNaQhzVW1M
         1gi9iNxDSwIIqndDkkHoDgYatqVScsbLX9TB4MsjBNgFj4rC8+MIX9l2yBxz0842F5NH
         2BO8SRMe28BAO6bnZrFlvCE6jyMMYrcvw2xLJqd7jjRU7FfItgOxJR+TlpfKCSjUEMwD
         So0b6fMozxq3BRtDBdwDpx2/w0NSJnFzAbIk0unHBP8uO0+Iiy2DseXT4dZwx9egCVep
         mvKWxAufeysizhFUCrgdGnnQvbsg5SwluzJefzMbkqSYNYHHfsy9mX4+D9Mc3FvukGnM
         lApQ==
X-Forwarded-Encrypted: i=1; AHgh+RpLA4zHq7WCXh71HjSVAsYu+s234mTGq8gvGkYBSjmpBF0S/cRhd2eha8MkWsnXJIRqUrTi+R3I6A==@kvack.org
X-Gm-Message-State: AFuF++mg8AkHdkJPK0ADCsFDTU02WZVwDSa4gh1LqeLfVQbDBJRX6wsh
	IdSHUaczb5TFmeyzxHFKUV1pswZbMal3UE4FRdMlzlue7QVHa7L8QtcaOHSOnnlR2YE7e8VZ3mr
	gBreOY7ZzlKIos4TuFQTmvgP+g0mjj0TOSq2NzD1K
X-Gm-Gg: AR+sD136opF08nE11iBHzjl+w2txW6dpOYRYMSvM1nN1/Ijxc9AEkUqP1LECmLuCdiW
	aG6UrnT+ldujF8x21srE4vVGU5I0eHC922eMNZNX6VvaS0/NqUYKpzXjqpJKlWA7pYg3UCcYZiP
	baMpVnl4+WviIKB1GH5tAYn8y6q86IhsS3+AfvZ4RxwftvMkxFxv3KOIy85zjZEbNbQ4SeCy83Y
	9AM7fSVlGRHOXl23DyMzfuspwAS1F0zRu3BgIDnmy6JnvqRyxIcXLpUN9WlfJZ5rzJCXBeOsvtB
	dc4aBb7LnwehQrVA/CNMOrPUg2cA+DWaEcVNgPPItRJXbVpV2i+lJOkGViKilBTPBlk35lJObDc
	qy4RClFX100QWIJnx1exruNQTSyVXB6o=
X-Received: by 2002:a17:902:d592:b0:2ca:bf8e:360b with SMTP id
 d9443c01a7336-2d673b9e9f2mr11726905ad.9.1787593420034; Mon, 24 Aug 2026
 10:43:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org> <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
 <aoibvf6CY99IXynk@gremlin> <CAG48ez0CX-PT5Yk5gYJuB6wPe26j0gHHXQqYoNtTA=iHe_5Wdw@mail.gmail.com>
 <aox7tVIQBMuz-xFO@gremlin>
In-Reply-To: <aox7tVIQBMuz-xFO@gremlin>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Aug 2026 19:43:02 +0200
X-Gm-Features: AcwNN1XNlUaHE0KSmD27zjyuJQAPDoj5SG3PPI6IvJrIGr992XerqXx0rzodOY0
Message-ID: <CAG48ez2-8UjzOp=St5eTPyG_yd2iBmPF6y7qVBTNaPNJgoX=BA@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6gb6y1xxcf53qa4k9swokenmfs8phkam
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A5E91C0002
X-HE-Tag: 1787593421-324860
X-HE-Meta: U2FsdGVkX1/AcJgEPkQoLwm9tX6E6CdlX8WOONdm7k3n/2vYiLVQ4GUR6hCCvkpqYA5jgq7MkwaDa1DiR4R9x6xGc/uO4JseqbiILQhDPwN24rQBasiewuCYGiaOXGLLEda3IsMERsnawLnPpgAXbZ7446jQ4feRsmbRgb79vV1moJudUF/FA0DnQWmeH/Fq+mlciachDIZND93Cny3fYr+DO7REQSVCrAKffSz/Bzp2aX/scRGPFtQsKhgqeoYALPrXgpCqQMxO5JUQJbZ/RXgKy/ACNyS/3fUBM9v0xOuqg9B0NYOHgcDtaFav+9IYCOIXPMVXnYjts38lquTgL0JHW46wlO8CXRYfUHYfW2BY74ulYTSQgASzDWondvsbjJrNN3KlaNAIVkplHueFwZG4WsDR3qu2tNBOZD08RKU1XpNVqB3b+M2d4/YHACxIoPiXB0R3b+j/Ajo3sNcfxd1KKoLEaj7vIgR05D6RUicrvFdZBceMzj64mzMluocMHW6NCh+wMUs1auHkL92BnK1hGhTtIOGzjKL1x4Mlb3VCtSGNRfcI8vllveexus5GGQur7pxpn3UZk9eQE7DmlW0w01yh19WOu2wHkQKf7tTHQhQ6BHTN1nC9kRYJOF98KIQwiz4ILreGVBFoFLiTUv9gGn5TRwGP1xHa51RY8V8ldK0okNgrXg5Ez6OVgPTfatpWY+B678SCsY46rr4jgI0azY3/TfH6JbiSBHVaNtOf/h7Ra3YY3QSMWitXwPSiINLzldgtaOSucRmNEQPqO4g/UCkeEZ1qVX//6wupbg8btW/jEpjBdchca3rmGdjnXW0GlEhEBsbWHiaV6Kx8vj/+hScXnbQU2ThugW/HSdIyL9lxnlR/75cvCPp2urPAj3RZDGa69gEgmyvncNE3T+MO+RRpvpEH2gf5GQCusW396FSgMUOMs+/xtc4iQQjq1fQjE9w3ZBLpjQwM32Z
 BS5fF/yL
 qrhQ/6YVizc+WCKaxgqEoMtf/GT/16j/KsegAwb8yfRZ17INzzVzOOldWsVOyIXcZoBleWBe7u1UggXheG3orPbK9E1bNsnyJFdXL+ZvprVIUOeanQj56i8UZvjn3v83x7CORT+6ncA7sc2bz5VXzMwubvcofR8/OJAaHUPupC457kff+kfCj1Zsy/N2enTYo/wuallz0kz0ufI8fI5SfWPn6Ro0608Snxh5esQW3qRlM8D9ZGZJI5oEqhMdqDHGy2Ls4QqIsuMnm4vWwM8lDqfk5VpdbVpTnpGJ99Hvi6wMh0y/9oUkxPh0yk6Muf/bd8I2JWorKnQfPvp7L0XvC9ZWnm8D+RiAp19lFNu0EvjYgZsCgS7/c4/ap1Q7i/2oYBQCL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 7:33=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> On Mon, Aug 24, 2026 at 07:06:04PM +0200, Jann Horn wrote:
> > On Fri, Aug 21, 2026 at 8:52=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kern=
el.org> wrote:
> > > The sharing a /proc/mem fd seems like that's a pretty dumb thing to d=
o in
> > > general :) but I guess you have to protect against that.
> >
> > Yeah, it's a kinda weird thing to do...
>
> Yup :)) but I guess we have to account for people doing weird stuff...
>
> In this case (I do mention it in a reply elsewhere I think) it does seem
> like perhaps you should separately check for current->mm !=3D mm of (what=
 was
> originally /proc/self/mm)?

I wouldn't want to do it for this access check, since that could lead
to "confused deputy" problems.

> Or at least it seems like a crazy thing to be able to get full access to
> another process's memory (that it... gave you though).
>
> Anyway perhaps overthinking it :)

Hm, yes, though I guess that is kind of orthogonal.

For what it's worth, SELinux can prevent such things happening across
domain boundaries - it enforces that, in the SELinux ruleset, the
process calling read()/write() on an FD is granted FILE__READ /
FILE__WRITE permission to the file's inode.

