Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DEF606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rn5egq4q
Received: by kanga.kvack.org (Postfix)
	id 968CF6B05B6; Thu, 29 Oct 2026 00:52:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916516B05B7; Thu, 29 Oct 2026 00:52:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F756B05B8; Thu, 29 Oct 2026 00:52:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 610C06B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:52:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B96E41401FE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:52:15 +0000 (UTC)
X-FDA: 85374442230.26.C9501E6
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id C22DD40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:52:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Rn5egq4q;
	spf=pass (imf12.hostedemail.com: domain of kuniyu@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793249533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=819kFpkDLQAr4MWHH4y5Dbz85C39d5EytvtFtpZLE/4=;
	b=BFaBYxJ6IQffFWfY06/+OVNla0IsZju0x1WZqp3IBcpMRDl4ybJigzHhZYYDKsvJFIYNAF
	gYE7I4QNOvjY7QAU2F+KaHCOpNdWFhcoUeSPNLrsjbiALNEilwvFWuVR+Mk/qgCboCOsmx
	jAKTSi4oO46P6V/mp2LtGQtv2AGY1iE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793249533;
	b=HU+OEX4/ORhKEWXixnO0QRqym9Ot/F4GP2R4wym6GblKgJMrCvur8e7zsKgLTcvfWADQH2
	La4WhCU/mbqenkc9OLxfRDFbEa5zlBqgeN+CNUpK0soNBkuFie65kK9MncoVo6s4E/Hen4
	D4rFnjfSOUNvSSKGDM5s3OH9dSvvqUM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Rn5egq4q;
	spf=pass (imf12.hostedemail.com: domain of kuniyu@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-18cdcfc05ffso2384394c88.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793249532; cv=none;
        d=google.com; s=arc-20260327;
        b=Lxdtuf6XtlMNdZE18msYHkI3P+XmKs1UfZXNobRIBiuf/ZhTCNzv8j2VEPlwoG9cLr
         dcDuHPTH/LH/1POulFk1kn9+3fM9nJH+SYlNtN7Gp+gSWZ5CqY/cCV65mPKnvPASDsZP
         vCd/NTUmxIsTdh984NF1na3BUAEF+KilqsMe4TRNKBlbNX9CMaUfQqXNp/ZH3nlwW8Eg
         Rr+atR31ruOGM4KkQlXo1n11ngq3bcX6USO2nEGxwkVgKMLkh9XkcnMe0p90CYili1jX
         XPKlakz1lNiaRCvokziHH2KzBw8vAzqf7LmLeQQD69CkhTgcZMyegP+KxpZGZs9Uyv2w
         HKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=819kFpkDLQAr4MWHH4y5Dbz85C39d5EytvtFtpZLE/4=;
        fh=RB5crhXt+AX5rYKG/axRzhbfV1pU4lSdOlEkPeFPjfY=;
        b=noNRfY1GN8jhkFhRobYMWZN6wHQmh6jw/n58dA5LgUv0vhGtdDHufoseCoKTuTSfSd
         iLVw8oUleDkhgT8pW1AJMndqwZIWEZGrEmEPjgYXVDFt6sWECWAFw+COJkJaPLcG+ab/
         XZoBf7wfqZCEbad9yu44Akdp7SGm+QYNq82/mhAz6u3H6IiDpo241+O69OezTr7zNUlT
         n6FMZPDMmP4ydzcrgNggNNLN9UDxNzPtGOfeS/6WLU5J1OijNi9lQBZo3yw6mOayN4Hn
         uNzfbS91LfrHb0OJseT7kKPjv/+Fpbsfg39kkY/kuVRUVv82/PazpdTDBFKr9X3DV8Rl
         nLFw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793249532; x=1793854332; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=819kFpkDLQAr4MWHH4y5Dbz85C39d5EytvtFtpZLE/4=;
        b=Rn5egq4qdOqPet5+bu01+cewfR18zXvIeY1IUOog6e35KFFchW8wU2QR3aeS6X/1PD
         Dt/7WGr+SQkmhLStntPo92lbVNiZh7SMK17gbpjCpxyoJv90TUUeusvfT95lJbIGIXKM
         IBzoH7HnIpGQFWiJAALhz2brnsl8Iv7VbXJly94hlIfD9vhz6f3px+8ok2IC0VBYYR2I
         Vd0Essv185IpvGSHHUaJ4Eh3Dpf+L0W3vpBfLzlUVntuKl3dWAEyrjwe1HPvOSZFlfIR
         GBDsVzN/xtgorej8HSKtMn6oDjOWI33JOIrcUc/lnFjmxm5RShky/LbkO6KLLjn25rCv
         aNcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793249532; x=1793854332;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=819kFpkDLQAr4MWHH4y5Dbz85C39d5EytvtFtpZLE/4=;
        b=VIRyf2RkJQTogZSlp465wH0qAKClC77Ps4zwo/udAscOnk4G/5ryKeVUoCtQfkJAex
         zf62blfksoZw6Wvglz4wHty7r3kYeecCRq40VhU7fv0Xd363QeqNmkci8nPXbS/qD20/
         nDTzr5TiiEXlwIOlp9dkctqO7zEcwMuXRBPxMbxW4LyCEkmH0AsH10OIqpV/0L/cqyHz
         Xq+CDIeOLiGdl6ZCoskHcypxFOXsu3B5Om+Rq+r0+ypOtJcUhYvdxz9nrrZOwo6iuHY+
         q1AgQvT4iz923WfeMQZSohUifVnd6Cs78Mm/FtESvfOoAL2RJWG9o3rK0bqwlRR9CRZc
         Aviw==
X-Forwarded-Encrypted: i=1; AKwUvBx7TQUaX8k/Rjf+hHmEGVAAShbWqe8KgOcRHr0YsNXRNIrh6/YldRkv5ZGO7b+6u+MJHMQ1+PlT7A==@kvack.org
X-Gm-Message-State: AFq9FYJRmE0MXwk5UPBx4li4dw3Kf7WD0qRoI1U+QX4USgvOA/vFSHMN
	Ws9hxhA0MPP3V3ipGM5HCiCrpCOcOfqdBum0jsvPr4SvUFHI1Adh/RYyth1xPrJcCWQrAmfGsiF
	nw9hXFhFdyRhTTtg06PUTHhgWhpIZVdA5REB9Ydfk
X-Gm-Gg: AYBFou0Rv0ZhTI7DiaT1/21ZvbHSUA2Y2aoAqbllWMH3UmgOV4vTgSrp1y8caP5caF1
	wrutR1//6lck8tm4r88QUTJ4c8yFhX1bk1mVX9WxZBVBcgMs8q0xiblrNncCdtbr2duI+UqmKhq
	5be2CeN2ag+uQDsh+joDmQO7AuDqVb0NKWDJPNk63lvFMwgXp0z4ILjYwfsLzb7/e8wYM4kxTqu
	vGqyWLcIhmyfPeFQBjyFLsnkAoElcrHUw7NL1oVk79qXdOs06erdjtQn1OqmNEtzKNVkNizDiKJ
	HrpWR4V/mWP2f1wh+ESDFjprJ2lURsostQRT0EiNQM7fiVMVWOW31PNiAUZLu8be/j0z7oQbqZ4
	AWr5HGabFMtnCGUkqD52VLq/95eI5/YOvTk2nCXoep/M13891QegRT5NbvMvyrs+uiZ3B5ZJEvd
	I6vexXUrVpl3NopWLtSXsiV6uTcuxUNlEs8aj2zJz/u/Z/cSejj5Ab5YW2Dlzcmb1nV5sSC3b03
	MTZDElfCeUkqyXHwr8nl/mrX4L7KIQ=
X-Received: by 2002:a05:7022:fa07:b0:165:dd90:1f54 with SMTP id
 a92af1059eb24-1a6cf446fc6mr7568412c88.47.1793249531473; Wed, 28 Oct 2026
 21:52:11 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028194014.3671161-1-kuniyu@google.com> <20261028194014.3671161-3-kuniyu@google.com>
 <20261028214628.aaaa47c78c5b1257d399257c@linux-foundation.org>
In-Reply-To: <20261028214628.aaaa47c78c5b1257d399257c@linux-foundation.org>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 28 Oct 2026 21:51:59 -0700
X-Gm-Features: AclHuK9Pd8zoXyr4beEM-18iuSqIF7Qg9p806QfOnO9FCdEibvUl-KQp_WspAy4
Message-ID: <CAAVpQUCphsL1zUaFL8ryHETRZsRg6iLUUc2onrMd4nK5uP9XjA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C22DD40002
X-Stat-Signature: cqb77dxix8son3oer4fbajjtpcra6rzr
X-Rspam-User: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793249533-143837
X-HE-Meta: U2FsdGVkX1+e+uDtnoB1yPmANqjeG5ixR7oDl4HOrsvoTEWGrv/AWtzy6+uGuooV+T6Fs1GgpLC0vAaP8tskYVr/Sv5gK2YYgGEtUMgA0jrYOLvCPw3FqzBWieyGYBT6pMqT+4dN0CPxV3+VztPladGEudsR+V0yqa/fmiq8+L4IFiuaABgfjlubDBKj4Mr/UyTGoInBr+FGDwGAUBRKEnSEaeR8URWBYqWuDtjxXXNRJKNCSttI+5pm/z4bIs/D/x9XsZn6S1URkPSXej7S10+z6uSdoPqAa9xtDITX8Ggq2iQVy+BF5Ba9uVwh/QmmtPP3L0eSJteV9/W/1QKglSnf+jhE+TslMQ9KpyGt9IqJckQoapyOK5g8TrVcR/hdPj1R0WAUM5W1+T6ZcwfyiBSyySVs7JEB8cYcQzMdV+3vB6Y7066Eps3CWy7WUyJop+uBBu6JQXZ3FKLCCgsyZFa50/YCiJwNMv0gHQh9sAddR/JSVmau9KAZJ+8NV0nKsUU7lbfQdKRdUtr4ffMWkSVU1PSYJtmzPvi2RCjMrbkY/IPTCWs0Yi+w1nr5xc9bZjk2mTXE2r6JIbS2BD7ahySrb2VBxpvsNNhng/Afiag34T7mcJs1ureAMuq2pHdsRXWBfrRb8qQuBA7QvK9lDyg95ZjDMjwaHPn6suaCX5GYEmgD0Ko5kBtAmvfbMul4hImJKnDDZG3mjYZC3C0of8XzuLX+Y5em0IbBJO/lErvVwPLwCamt9cYeSvZYdqaqD/chd/91p6xDCa/SfsAjORH9MAAfdmUTf5WBWpwpA4WEveEH+g1sxesx5MKgztEx1oSLNd1RgFNy8CqekBktWOGhf5ekhBdY2M1XQq0T4V3cmVOPSrw5f25OljmixBFkBRSYiw1wj2Zuj+xTqbq+WPoIm2gz07A3sdLZ4FqoKF4J3Mfv3YxuVh2OG4mosKDaXm7Qah8jnG/5CFqHQXO
 vQCqm78C
 0Rfyr209oB2UAyDQN9DydXFR19/t6gcd/0x+31XJT3KgeDlHcvZeYMomfYRlOVr3wbFyRDHkf7wLHeotNkMEeNo5um4LfcLwbzDjGBk83fiP++rX+G/1/N/E1B6X7FOHd4W04k9eqKbAvxgyhddIoIe26Kf0fGsE7cGG3HCpfpgurVjW3TTpDb1OjPpLeFO7w+Y6KRnTzEguRJ0zic5ym2v3ln6UA1w29Xo7Jl5Cde7lmNW1lumzuo1jrGt/6rfQekliNnnJylaJZ7iGYuvWD9aE1242FjR7fbeBHEyt2CxRd0rHqvn3W0ECtRAxFQhklFqqdxG9jYu+Kye7kGZ2B5/8uq9YLXov4ot1wZOmTN2EssAfrCMmOAKxIGZnjrAZyQ43fNv25r/kYhjUW0DUVUmU2wLceV0Qaj5iCh1dLp7v4fpsvqW7ptSmjSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 9:46=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 28 Oct 2026 19:39:20 +0000 Kuniyuki Iwashima <kuniyu@google.com> =
wrote:
>
> > The new test cases verify that KASAN immediately detects all
> > three combinations of double-free involving kfree_rcu_sheaf():
> >
> >   1. kmem_cache_free() -> kfree_rcu()
> >   2. kfree_rcu()       -> kmem_cache_free()
> >   3. kfree_rcu()       -> kfree_rcu()
> >
> > Each test also evicts the object from the KASAN quarantine and
> > reallocates it as a victim object before flushing the RCU sheaf
> > to ensure the live victim object is not poisoned by the rejected
> > double-free.
> >
> > Without the patch, all tests fail to detect the 2nd free, and
> > the victim is poisoned:
> >
> > ...
> >
> > With the patch, all tests can detect the 2nd free immediately and
> > prevent the victim from being poisoned:
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > Reviewed-by: Alexander Potapenko <glider@google.com>
>
> Thanks.  I believe this should have
>
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() op=
erations")
>
> and that both patches deserve a cc:stable.  Please comfirm.

I was not sure if a new KUnit test deserved it, but I have no
strong opinion, and I'm fine with that.

Thank you !

