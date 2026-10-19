Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50804606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=CdlxHtSE
Received: by kanga.kvack.org (Postfix)
	id 48AE16B02F6; Mon, 19 Oct 2026 15:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462896B035E; Mon, 19 Oct 2026 15:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FA36B035F; Mon, 19 Oct 2026 15:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 191726B02F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:54:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86E89C07DB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:54:34 +0000 (UTC)
X-FDA: 85340428068.18.410F59F
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7339E4000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:54:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=CdlxHtSE;
	spf=pass (imf12.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792439672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4Dziqd1OmNhjy33+aycNRkzYAof3VSJ+fHhVZGkSd8=;
	b=5CUW8ooeNMUmphTa9SBXDj4tPFl9N64HjMZV8MHKLJSveEiAuy0qW6Ojfxz+ucuLCurpRw
	6l9a0Enze1T39ftOpJKgJKHFqczxdOxYhv+eswjpAwuc2ulCKYwWHs7DRppEIqn9y5PPQP
	BByU5mjBfU7c6rwKVZxX5PPGzg2jbog=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792439672;
	b=LFne/lLHK4HIgr7/oi+asnb0v/B+JcE/GnX68OKAWEaudjMuMU7PDrIT4j5CiiyZrJh3qc
	Z2W+i01wyK/ie/TlCi5emv4CX3LWxFfAs1vIJoEVh9+LYdaNpJ2Y++LXe68ljeG4S9oeIF
	FSStei4MwY27XNPEF7eeOBtDl+TBQ5w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=CdlxHtSE;
	spf=pass (imf12.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=r4Dziqd1OmNhjy33+aycNRkzYAof3VSJ+fHhVZGkSd8=; t=1792439672; x=1793303672; 
	b=CdlxHtSEVvIQ20aNHy1KRkeXKuZNnBqScnms66NPVyXuBCz1iSiXTku+9GRj9dS7yqga4FOLMrG
	H3GYCQvpc2axCZqDQvDyrPJ6+/lXk9KCB7vJf7+x3j8jnKfS4kXgH8cid8x4m+y/2xsrTYE+Awkun
	/JBSV+FmZ+NKlIV0RPLStcalWZZpV9bI3Ep6mrjlV9qgnrPIyJZ8lXQ4VkihhUAZuNK9Zki1jvBGm
	p4fGMeN9nQ8npxxTFjvb9/EYRwI5k/innkEG7AX4ECUKdKxBLUKEO0uZktNnpbFk77VpqPE7UnX9G
	R/IFycV0LDdfPWEAzFWbtE2GBEufuH0V1+RQ==;
Received: from mail-ej1-f49.google.com ([209.85.218.49])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xItRH-00C9Ec-3q
	for linux-mm@kvack.org;
	Mon, 19 Oct 2026 15:54:31 -0400
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c413dea9ca6so392562466b.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:54:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBybSJ0/s16NtlsTEGatOH63OyO0ydM0CP2aSuR6IeM2c0rvMprpU18Kx/pbmYlLqI98Qmlf9uOVaw==@kvack.org
X-Gm-Message-State: AFq9FYKCk3Gm/Kzmu1QEKyuRAwuXtNyhm80GTWUBtfz7ANzAyXQled7v
	9BBd+gPGvWcW5oHxP5LdhpT0za7d/sg1LeiLp1B0ZgOQUDVlVXT0Rn7jl7pD6a3nPx3J7KcNpSM
	somxj9VQLxV9FeEF53juzTiMrzmmCoj4=
X-Received: by 2002:a17:907:86aa:b0:c26:1691:b364 with SMTP id
 a640c23a62f3a-c419f314d81mr620262366b.29.1792439670207; Mon, 19 Oct 2026
 12:54:30 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016222721.791785-1-nickolai@csail.mit.edu> <atZw_gtMIIKXgc1q@bfoster>
In-Reply-To: <atZw_gtMIIKXgc1q@bfoster>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Mon, 19 Oct 2026 15:54:14 -0400
X-Gmail-Original-Message-ID: <CADGQE7H91ZwPgUzPHoAJmF3WjzRKxeQkQcV8+BLdGn7+kkEduA@mail.gmail.com>
X-Gm-Features: AclHuK89MSswr69kBbcBKYnmvmSPp-W3tduRDj-mdyB6dBht9FWZCtTRTbNC_Go
Message-ID: <CADGQE7H91ZwPgUzPHoAJmF3WjzRKxeQkQcV8+BLdGn7+kkEduA@mail.gmail.com>
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of pagecache_isize_extended()
To: Brian Foster <bfoster@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7339E4000A
X-Stat-Signature: 9xo5iijidfuktnogrfj3gb38jf3z7ek7
X-Rspam-User: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792439672-783836
X-HE-Meta: U2FsdGVkX1/kK1zT05HErq+AikZEGxCwDkFjui286EB7ax1bWvDZas85RMpD0ZufM3RVApiirYFiD2cHpLOXW/A/LRoSFgpUwwp5MGdS1/CAJrV3EThpL7qHxMV/JuOg+2H+r1eZ5QbdZJ8sehyv8pi9PJiuxBBR6IZGGGZ2tAlbIc35316iN+Z+t4RJ0BFc4V+hDdujGth1ewADITZQF71DZuQ8Se0B31Zc7hi77UVASdXTwSdaQgFRzn7soe5f0TlxhLK5QVi+Y3QfKsMlmBecburUjHBHHArzODjtCujjDzfNevtSUe7YbS6eHvZisgIyPqxq2Sms6pzExE4kOm/UhjbZon8UoZL7PQuq97yd41f66pnCg+kR3JmqydyZwTlAkBGfwQM9Gr0SuHMeVSQZ/FJfsRc97aQPXxyyDl5KtOx2gUUAHOMV4H3ETDnVYoL9lBb8ibmAsgc80ThTNhXsCBz6c+K8GJz7MDhMk+QR6aCdmkHeFikg5I14U3SM4uUtbeGKqHbjVAxVoinoUosklwnaJn+ZOvTYg9NF6+9WPiR+kKg1h8VC1pMeoTWQp2CIDlSdK7JWqx6bMcjN0GepAU4ZUDIGt2aNzM3HUPcu2M69XpHSRV7aTj7vhYGkBHLTqLM64gtSqIiiCqeTZ8peWziCthjR1tPPU56lSDn/pWY643FYa345NLGIncb3fwV9ajbNkEGFIzNmQJF7hd8n6RMM+Y5BL/90ewwfxPZ00MC+E1jmQ7AxL/Xv5wxlM702JkjyDeJl6JNqFQKzxRt6pvvH4lMNfo3lokOgxZi8+zzGDG4Ws4vltMamNRuIfNVKi2pyJaZCS/EUUeIvMcsnr4VIugrPnQHuCdZ20Z6rAbUZSE2KNY4vNTiewUhACOMr048H2gvYZwkBWYI0UCeralhvKDBlT0u9n9O3SLs9K1gtonsZ0m6jOyMR7+n9JccKnEOJNo2Uh581uD+
 M70NuI83
 aIvtGaIyhSLaShoioXp4tkzLnDsjUfOq8heRjBYfMzO4lJnxY2b36pdeAYVVYmSKxGqBSatciQlAbHWZ3zJJjM9LqPeMGTn415umB84tpRLAIK1xjJgWu8EizzL+Pv+h6c1aNH8KqmNwuQpIhWG4EVoSOxJEHBjB/y1fKesraet/atyINR0K8+BMtCNYZUyOfmTI0hvFjbBHA6L+OFMQA6M5bH52L328/2J49/rgUlILxgw0bZ4AdwkHpZ7DlzZdQcWUHojBrM/g25PHhV6lHBsO6AJ6uRpZp1VY03TJqQBYlaLKtL36u6osUFiaTifc9kiz1CU4Eb5hyx7hPMMJRFgStuqym2aqrW5WDRrEZPxb9FDKvN1TKPVX91g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 3:35=E2=80=AFPM Brian Foster <bfoster@redhat.com> w=
rote:
> > --- a/mm/truncate.c
> > +++ b/mm/truncate.c
> > @@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *inode, =
loff_t from, loff_t to)
> >               unsigned int offset, end;
> >
> >               offset =3D from - folio_pos(folio);
> > -             end =3D min_t(unsigned int, to - folio_pos(folio),
> > -                         folio_size(folio));
> > +             end =3D min_t(loff_t, to - folio_pos(folio), folio_size(f=
olio));
>
> Good catch...
>
> folio_size() returns size_t and folio_zero_segment() expects size_t for
> the offset params. Perhaps we should that instead of loff_t?

size_t is (unsigned int) on 32-bit machines, like i386, which has the
same issue (reproducer from the patch).

Nickolai.

