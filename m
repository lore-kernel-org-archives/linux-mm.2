Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A8EEC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0BCA6B0095; Wed, 16 Sep 2026 10:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC966B0096; Wed, 16 Sep 2026 10:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB0D6B0098; Wed, 16 Sep 2026 10:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE766B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:34:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B630C1C2D3E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:34:01 +0000 (UTC)
X-FDA: 85219869882.20.CB9197E
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf09.hostedemail.com (Postfix) with ESMTP id CD216140007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:33:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=laykw4YS;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789569239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7XcWTAG9pLSnk29MAn2WD3gdRS8+vQtAmNxqtasz3M=;
	b=4L5eGijeBM42AER5VjZ2uCqyv6lbDIjrCjJkC/5DZEVOQbXNidDBbGpT9V7mOdJyHLR/bb
	4rbaRjQ4IzsAoh4I1WGL//gMNz38CwqEGob8MQpAsD9tTlsEZ2wc+ESBOQ3ckfkaWbZSki
	1k0/uNLxx4gDSwLnhwxHHkPSMsL5lNc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=laykw4YS;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789569239;
	b=4utXNIsdqw9Z6y4H479I9O+JgqGGvWMc1JPoEQiW/6xhIbIqYzOYVdpdhpJKIbhzdsN8qh
	P9vWlFdsrccquEU3n/xyrDkM4X2y953nNwy/l6G3CxBQrcMgmcRQ6umE08gygd5px4VtEw
	xb8ynekoj9jFHiNMOqoPkn++5czabls=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d6ff3aca06so115055ad.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789569239; cv=none;
        d=google.com; s=arc-20260327;
        b=RCTfUV848XYB3WObEO0AD5szpy1k/965FyMY16jCiviAVfxsRvgy/PkWXElI1a9RuO
         eQKOtbXGL4PLxOJTgbW6z8Q1gC6Gn7LF9qWX42CzwQl5Ah7n/tfpMtuR5SKPNyICeogn
         wgOZlLJSB/0/1c3erlS7r22BqC9XFo5W2fGmxM+2iX/QTjAaPgw+kz+R0VyuHA66yDRf
         fG/MrpCZNmhFVkTwFgJR+ghBboE4UX3q5fJ8A/ytyzkpFCcpSUCbTsl/xaWIknLiq1zk
         7Lupwf06VCQ37cQA2ZPRmo7ep7lvpPzuv2SMw/IFLh9ao9r60B03AGfB0se53M7IO1OA
         PIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=K7XcWTAG9pLSnk29MAn2WD3gdRS8+vQtAmNxqtasz3M=;
        fh=12Ik9piikOOiynn+QZd7Qz1JaFvVG7LTwnvnG8wXW/o=;
        b=RmWEfX9K6AvWmhpjn5fHuLOWVNNZ0tcAL2RbYQLMVcOw069F7kzWqFb/WeYCxyulLS
         lxgSNOF/vCv6hkWO3tJ0y0IU7aFnLTCJ9sZwOlAeSTu6E6WTiNlXrRFjgfWP+i6pfaPe
         HX4neFBSG5hshXukPFGCLCJEZJ8VNWq1PMI3GFaNjg8epSO6B0oi1UfWLe1c/w/NFUqp
         ch5Ql4qW7pdUhUsNlVUmNNFjtW3ytuLjFoH6Et8y7S7Fxi+ee1TJ8gxhIg4+w4h1wJs0
         Wf3BRllGXFlDJP6JkxkXG602U+d5spVnh5Pi7EFIAOoX5zOvUoXYF74O7B8376LdPzMW
         B2zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789569239; x=1790174039; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=K7XcWTAG9pLSnk29MAn2WD3gdRS8+vQtAmNxqtasz3M=;
        b=laykw4YSdQ5qMW0LKDufIjbDeJYby+ZM25xOWMrI5eJCv4NBSE0J7fDmSDZVNZKJ4x
         aiabxyl3tjyxRIm1v+DYoIaVIyJDBjjsQ8c1u+YYuK4H0NmshTXxFcorRAtjH6gulRXx
         aVRowx96othP4I6VgsC0ynQ9oXqhPdfI41QjR82pxnYKoBgfDOjdRpeippeN4lzIgQuE
         iYFDFX9reQjbLjWvjMBN892viCmBlI+0q8/RyATzBAx9O4wJSbJTj6zUYZsGqSYRLurT
         qobl090PROtddxuLrqCG6IMaP+PsREaTueCv44/cKYH5HlJc26OXfavKMGcu/BKQ/Mc0
         FB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789569239; x=1790174039;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K7XcWTAG9pLSnk29MAn2WD3gdRS8+vQtAmNxqtasz3M=;
        b=1ShXg2pBomoml6E+VlZW4s5xlpEU8sgZUQSh6m5ATnC/oUlCEUrt0t7vWGTUyPsRii
         9Lcc0YZHJOuGoGWsFf8PWKYdWL/hQx61jOTFlA3bRc+saVPss08RB4yI2X29ZrUYg/Vn
         7vBakli+nIx0+vRcQaxvs7YJJDGy/6nO5HMetYD6N4YoglZ2f7DruFG/uhdZpGU4dmwT
         TI/l4M/hqApHb2oVsOCiCM78f7arZM39RUp3NCxMQ9t31adKPgqDqF+Ac+qE/aTEEHhg
         ZeTHSP0GsCZc1aEJa9BTb6daaeHwqRU+mJdGSnyz8VYRl71GS8+0jQEQ9IpwRjirDALK
         tCKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwFVu3Dpce9lRHtHeDtOR/t6L4jXICSrZMIaavqvyr83wDV0V7VBaRaGqj5dRY8S5s51fsGyVqYjw==@kvack.org
X-Gm-Message-State: AFuF++muvIUnzzhHRb0mnUTZ6pb++wf7AsQhoF5MjaUxKWNsoIw1b24V
	W6uUvK6VSJiojDDWQWaq1N1bd6fvUbE6eCOdk+c6OmIYmcX8bIXD+3cytOgM2Wt/eKNCqPB9nHD
	k42z1ODeOBcQUvPcEtiaZReZkoyHAxGHwM4fKcBg1m5hy9liUZfFyCRfo
X-Gm-Gg: AYBFou0PQTiloXB0NUBlSogZaQbN7MBynoanQ2EhE6M5FADVD79qu4AFZHn/r1iWnMV
	iahJsgd9azpBMyKccaXmt/GPeXtT8KrX88jF7wVKVJwyoy12u3zuL0VwsJRLwEImWvpALwfSbZE
	lzyw4SsfZg4f6hgTqhl+5ER57mx7gfrSWvF3WEPxN8sPOOU1nYg61729j+7nthdXnE9WPxnR4k4
	SKbES6WzCRoY3iDh2/XUj/6doHF5ARM0VjTdFyuwqfEpjPhIO7OmpUKJFH7vA/ydxEK7htQaVuQ
	GQ9Be81RKoAhEsO1Ujkuw5Y7iHiBGPVFiuoJF3WzfjxVCksTPoDkFOSW+kM4RlY5Y0IrnkwrFEQ
	VafvMiwn/oi8pH6iwEqdl1bmcGMjsP9C9flWtNELPqg==
X-Received: by 2002:a17:903:1b70:b0:2d7:2a35:d14 with SMTP id
 d9443c01a7336-2dd8e92caefmr4932795ad.11.1789569237830; Wed, 16 Sep 2026
 07:33:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
 <CAHC9VhTE82bRRSXSUuMOdrfoMh=xOb5hDvqiKWzBKD1urab3hA@mail.gmail.com> <20260916-begossen-tischbein-abgemacht-e7dada3d1e56@brauner>
In-Reply-To: <20260916-begossen-tischbein-abgemacht-e7dada3d1e56@brauner>
From: Jann Horn <jannh@google.com>
Date: Wed, 16 Sep 2026 16:33:20 +0200
X-Gm-Features: AcwNN1VHcCpN0atD-cxO0BibJJcgM5o-LVFXYygCh_MGPfeRHWgz6O_0BmL4XXc
Message-ID: <CAG48ez3DRgU7eQtF71EEQw72+xV5kWv0nQn==9uVd=YPyGhJUg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] proc,security,selinux: let SELinux block
 FOLL_FORCE for /proc/self/mem
To: Christian Brauner <brauner@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, 
	selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CD216140007
X-Stat-Signature: 7a1ofnircmgjecc4o1s5phpyoznzop3t
X-Rspam-User: 
X-HE-Tag: 1789569239-201536
X-HE-Meta: U2FsdGVkX186HNbfzL+7td+3bIF0LLwe52zBDVaUaTXUupISVka9yDjfdEV+azkm4pdtX1uDpvtL0tcq4seRB58QFHSrpLMFQ5x0SrXW2WZXRAabRoac+Ks3DzNmRkpKUTQ6o/S6N9XSOYYk7cZABJrq9+fImZE4Rufp8yzlAy/h08lrMtri37j2z05HaTPOVaucC8GQvDp/FvJUYMuw5bDbdm15D+WKsNGEl6Vn2DzwclxxXqVBtb5f84Itm6sHqfv0Odv9D0pO6vV8xNtl/WfQ1+ZvxytCJhDQAjrsXdHvBI6v4PaEhje/NIfxlUl3mAlFDTP6zg2yK3pSXKnNnGToFvVZkHOiuFYH5+QCze52419M9xjZQDkmNOS3jBB7+Cn9BETgJD4TV9DDZh6P2KETOp+77q84wxMZue4koMHVYNaHawkSznPp9jRyk9MGbfJZJnaliE0xGKVxxffDUUcMcUsQiYEEn3+Se46AAcYRdDtHoslGkAPK0z2GuVG774QuLmQnt2gt21dJPlPcbztcN3TRqtDDd0vA2T3+hegBFKgt1GUnkvGTmD+0dZ1ybrke+7ZZIPo06R1xLXBpy9zODoei7+z1PnRrT1XP0S9DPkF84XISjfGHqL/jhy1r0hYmvObIJzpc61mb7u6TEgMh+vtB37zftFygdeyawZ7UJtnSLDo+eAk7bC9DZ8y3ruImS6WsCV0n64i3Ip5ug+5ldbEcLY61GWeOVvXfSt5EKp6JrboZMkQQHhdm+8Ti6W1iYzrR6cuVztWgdNwt1ztq1NbEofrbYZTkccRm/rNf3+102jmzEEAjei1jCPRjfZlv0vqSdSO/GX8KmJ+Pb2ilAqD1IM4JpmdfgB8sIO2c+01gWzEm/JT9GdqfCeQzAqYrw8NYpUnR8kg5lGikGMogW1x2w3AIfwelMiuZxFa7X8WonecobmubPxyjnBsvW14+sDAJ6iDiwIq31tE
 RRBmcSEX
 O7Sh+E+Cx8xAi0cfG7EGj+L3j9A7Mpbc+iWLSmdlvRuLS+8OFkSgNFxbSQkcVKaq+g2RYxj2K3yuN2CLdrecExca8cpryc2YblXt7amKDWBtiRxZWtofJkfIJ8qrpM7xx5L5Bvg4R5/zzO2KlqiPY6CSpqmaPuPq3pTTUUfztb+vGj2UFGzvtSYGswq1AIqUfT9kTz570rJnTXnckl7Z5ULIPSRCOgGWPfeKSzHXOrQgdxt38Zz7NJXL8tJeVZKIG1cTaVEHVZVrLqrJEiqk+0l38LIqL9ut+6HtN2pNfRUrQwacAaMOGO9DzMIr+amGvN42mmeqHDcenDt6cNDGK72G4/lrrHP2mqoZutq6PidXZD0XfqFE4ybUTeC3fnfg7FXcR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 11:02=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> On Mon, Sep 14, 2026 at 01:05:39PM -0400, Paul Moore wrote:
> > For some reason (/me looks at gmail) your email never hit my inbox, I
> > only noticed it now while reviewing Jann's patchset.
>
> Oh weird?

(Same for me, I don't see that mail from Christian on this thread.)

