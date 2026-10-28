Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0ED4606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rsMV34VR
Received: by kanga.kvack.org (Postfix)
	id F09EA6B05B1; Wed, 28 Oct 2026 11:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBAB86B05B2; Wed, 28 Oct 2026 11:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9A16B05B4; Wed, 28 Oct 2026 11:34:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B12206B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:34:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 249711C1556
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:34:49 +0000 (UTC)
X-FDA: 85372432698.03.6243CD2
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 314FE160011
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:34:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rsMV34VR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNFgtKDp87voFFR8yXktG0LWODrSokHg8hARj7IkQYg=;
	b=nMrH/ATHhgOrOuYzRfBpFLqtT6vJIm0Uy9YGLDwwuoO9H0mzKrHQWn+TQv9CgQSEU9rhPn
	isTHsOSfnZ4qlu4b7gos/sOo6G+zF5g3TxMxwIS7qd2L3VMXF99ze2QIntoMO2iEha15XZ
	RBhsacpY6sXA949RVEAVNpae/YVyNSw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=rsMV34VR;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of avagin@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=avagin@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793201687;
	b=2NYqogayqym3yNLzHPF4aDDeXfr32Csp36Y2T5rnqC6xj3DJ6kLv6bz+GAC10U/IT/zs2J
	p4Uu/bhEUVq3yo06ZD0YBU6ERm81XlwAz7k9ErOb8MxEEEE8yPOggfqP4NrpB/m+43Nwd/
	h5QPekd6KSyxozZRb8G0WbV1rnLUfNo=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-8439fe796ebso805923a34.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:34:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201686; cv=none;
        d=google.com; s=arc-20260327;
        b=ZjGjuJ6lw3sGO2ZiCztGb5vIgHOQuOSWQ6OyW884qxHuQ+xbbZmVt8RIlszUSYFqcM
         tH8gELU5pjRE3B8qT9ZRri/qc1Wb3lCOUejPlSY7HQizuYrFGrIwSDK0LwsUxTa0stCx
         2cfdBj1UFasGgWzbJT9K4WIkDP4hrJQ6ij6nb/mUMpb8Ef628kkTyH77n1Fl24KyENIr
         LXSiqnF54VJLUMkUEMUlVGeIOBJ0qgdJbhDI4E6zHRny2i/GJXVlPrIjbhgMys0bU/Ui
         M81cKMBUhqpzTSXgGquej0G6XhlavF6lFBaQ+VADoYlJARkemkQi8QplSOKOfxLhHp2B
         w1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JNFgtKDp87voFFR8yXktG0LWODrSokHg8hARj7IkQYg=;
        fh=ULWujQpProCKXRGFt4bJf+wc1dUnqb+ABOjQSgk5yU8=;
        b=DN6sapXvMbooHicjAy8AhSYnc3FkOePbuQVMtSSnApOG2kqLcVhE7xYFCGvZNrtwc6
         LR3mBQce5HvVi7wSUIfMewGZjs5ik/4Wjn+BqraJ6ErLgKuxZmAO7npxbthZMsAum/Ua
         ln4YfVXx6d5osd2jEnN45iSADeJ/9myYsREotpCg/nD1AoJVK1GsHkZKfCWxxkYwQOJC
         4buHYi8ecDDvH5RgyYRcq6fvexFWpuU4q83asu4XHJdUlEwzkaPOy6VKj5jpVqhd6rV1
         RPXIIAkM8BeNOERB25T9Kg8t9YU/k3c+Ttch57ebtEPhTYePtSFMOmBh3IBPmeI4m4si
         8JiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201686; x=1793806486; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JNFgtKDp87voFFR8yXktG0LWODrSokHg8hARj7IkQYg=;
        b=rsMV34VRl4SzI3Gv1rTzBuwE43yBEGKn16+loiIADt7/ys+nsJEhjayG29+MdDZKP3
         2MiaHQLFCgTxH3s5iiKlVb4K0dsSX0+655eh/l92qx9QdgDx1EvGgNQJ5YHx3fL7H+/g
         o1ZaaSqPyiL63UILsqA8c9nHB6vq6dFZwdLNNZi6qwlHrH0xPzGKquKujiZ2POToMxmM
         xuxp2G4GtccSg/Bkp6cs0xE/LNVwW/Ptw0nH/LPFrJW3jIC1AdSVC0oCeTE6Ylp/5WJi
         zK3lep8U48w72qsQsjJH1OmE+dIHxi0L1AJXCjSE1teVIMJrbHjvlGjSP91GkAaWQtJw
         vlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201686; x=1793806486;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JNFgtKDp87voFFR8yXktG0LWODrSokHg8hARj7IkQYg=;
        b=P3x1wnPP6I6yQmEOR7LcoQYwN6FbULKa023ccMQ3Ubg32EVSgTmX6fI/mqqaptPpOb
         RLuJ3TNWHK4/Iv1pgpkmTifRsPLroP+1DlJqcX5IQ0iYxYUE/8+HeNdabJbCe3oe6bxN
         zqX0RA/ycKBUbCJqFvqO6ANrK185KABX+mJEIPqneuCurHCG7JayX1yow/prMSqEMZHC
         c+NCgikE756TKQ2kUZfLr4XMDSPKF4p/y/enR+1FdFmb7Nd+j79z7F7+wcZdouYswTL6
         OkD0UbrhHTGpAgjyLmM0bQbNJ9wsexvwgZNMatnJhV1PNr3SK4wBXZ0xfIRuOKOek17v
         qvOw==
X-Forwarded-Encrypted: i=1; AKwUvBzifhUW1Wx1z96etYy5leiRiHv3XUhIszW+U18zsj+jPhvS7H5x6Vs8BwDP+HpPvgd7qrhqFKMXVw==@kvack.org
X-Gm-Message-State: AFq9FYLw9TGZw4/lZIsRxtphv3uqmK0OQWGYWdTzqpZpS4Rq0cRl7dYO
	7q/rdg56WuIeCnsa3Bs3Xfc8koQWSY+jVrXkoVk1YZAxmWI7oyYZhJnB9e/khc0D9L1cv2VPGNH
	b6adscqmdnEPXW0jLcRgDzeA1psUbBn8=
X-Gm-Gg: AYBFou05YM+Yahb1mPrGWKOPKI0E5j1ERGh2P7ZWxz4dOoh/ZkWy+x8/++ICQjbBWpi
	npkM5Jj08gvhJhBb/9X6RZrPbd/razPIxBYiO65d9p1H3lWJ6oCH4s1k5ZWoruZzkRXhjpWvFZu
	hiIdDu9cbOP7ks2HURlDbiF9Tlaa0KLbzyHYxIKu/a9KlkR5JZqZ1IiOMZ1QbaeDcvhr/etx4S/
	ACIMLCOxt2/nTEi9wj7ftgWYg3kovWQ5zW3ak7Dl0/cCSxRXZb/Q923JbouNq2wiCf7UIKaC7QW
	IVA/pl/J/MuWpZJ5Ff/HhWgKMTXiKu6ATDQvkWHkOKNXhUOAbcTZ6ef0Zn7QDGWI3L0dcNM+ob/
	1Z1DksCmvdYXfZ1s7JK3vd60UUq53LvYgvZc=
X-Received: by 2002:a05:6830:2304:b0:846:e5a3:c8bb with SMTP id
 46e09a7af769-85ac012e9bamr2225801a34.15.1793201686073; Wed, 28 Oct 2026
 08:34:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793094611.git.chris@chrisdown.name>
In-Reply-To: <cover.1793094611.git.chris@chrisdown.name>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 28 Oct 2026 08:34:34 -0700
X-Gm-Features: AclHuK81v527zBLgjPgT7UgeAn0ZRsnw4w8kJ2Fr9s5y5HrZvwNULUli5C61ZOA
Message-ID: <CANaxB-zEaaDaaR2Fszx0D4TAcKAapOfcxQ2MzZbFVAhR2n3SOA@mail.gmail.com>
Subject: Re: [PATCH 0/3] mseal sysmap: Choose system mapping sealing at boot
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, 
	Jeff Xu <jeffxu@chromium.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 314FE160011
X-Stat-Signature: fo9pe6t1tuumanbn3xgi38yj49iagpez
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793201687-538297
X-HE-Meta: U2FsdGVkX1/fDq1ER7GnarMJAwf6cjq7xOn10BzPPv5/oy/3blMO0wpswAsBlAKOc7rldb3S5gB/woFm93zu/8stAlrTmsMcmc9KLessvfpGl9NrkuxwUAR8C2FJ5P2APcddpCltEOhvNk0sAO8+1tNGfAes0KaWFvMUdbycSWRh8DI/k07WvFCKwJQJetJoyPb+4GKPy8rJkGlG7N3lfkR/AymDpNpOHKjqVpQUMITuUr5oCAJKA1x/9xrJn8KuYmajMzha5nX6nNRl9O1h4rXAdjr3A/YQIx9JvD1TPqszUUB3ZH0coTH/YkL9ez/fo8wKAwmaSrK0Jk1FX8bx8BuSVlyP1VBvc1UX+wu9NUcny8dyxmZQVGdwy9liUQWNgh/FE7rZQciTXtSpLdC8lbFxONttwZrElyeW/4GBgJf8Zx0jB9pUHR0aTp0jevPeTlWgkRH5IaStQXCAePhSehVNlspQOE1XwDjJzwR2iw7WRHDaZkV0r+5xV9RZh+LLICOfm1FIi8Qz93xzspY9kN1Oo357kj7305gaY8iHJVmLEoc9O5wYQ5U8qt9getn3vLQMXvvidg4g5Gpq58lFR4sLfaZIU7ygdDVDuiPyMmP/3vCOe8e68po+o+4aUsa2SdBuyM5G2FIkQQWomk4SreyXdKQx9W/t/NxBA5qKw1EwW/1u8ZzJyJTRstSVTo8QI34LpVGUdnqJYFgdgGdSx5wIicL796lsKg0qN7QNZ2I34be8Pvba48GstJF+646iQtXwlKSI0k2+oSN1IzEwf9C7qMGrQ6xElWC6GFwLQAbXmq7PeK1UgcP0isUqNug0pNTGDdbfY3QjMOyB9WrtPcvcBtVNtzz3gcG9HmVCRnd+Jh1cGEdLbb10YOoQVHz9VaIsooPDBNQ9dBgq/XlWMXEgfSqlPbHKo41twbt1QnarBINgZo0D9/IYxqK6ERTKmFMrCw8SoPWq46xYkeS
 0JI1gyFX
 6mvNipLxRkMEmW/rw33n/P8BX0BQhNlzReL/f1+NTdVx6nRayy5zMa1hbceM7fv3Uubx5um1SZLT80UoQk2HpwY46jID28hZv0dy9XTVjWvzMq4yIzH9o/eX9iYBFpjDsqn0yJMDjZ5CItpnhL1KfuJ1iVT5hEwk+LtyU3oHr1mwr3X0ORbk+ogqALgYoa2j0e7TamybgmoiPxDRiGqUhQL5gYYx3wZzLaBjQ85sQwnJpQqCGxQoSuLaVXWPV9stQgGyvuWifjwUhWr7fvAmG4AEu4j6JcTLwEGcK5D0SfKC37I5Q7AZ4yuGHcCaxfd6JmZF2LCijrjarSrHHQazjP0ZESdZa0QJwulno75tam2C9JjRd6Qr9iEcaeTNFFZK0CrlDGUHInXXzUwYNYnLLbFBzeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 4:42=E2=80=AFAM Chris Down <chris@chrisdown.name> w=
rote:
>
> System mapping sealing is currently a build time choice. Hosts which
> want it and hosts which need to move or unmap these mappings therefore
> need separate kernels, which is not ideal. Let's allow the administrator
> to choose at boot time.
>
> Chris Down (3):
>   mseal sysmap: Add mseal_system_mappings=3D boot parameter
>   mseal sysmap: Allow with CHECKPOINT_RESTORE, default off

This isn't just about CRIU. For example, gVisor does not depend on
CHECKPOINT_RESTORE, but it still needs to unmap the vDSO. Other
sandboxing solutions likely need to manipulate vDSO mappings as well. I
think this toggle should be off by default, regardless of
CHECKPOINT_RESTORE.

Thanks,
Andrei

