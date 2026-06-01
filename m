Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4A4CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4ED26B036B; Mon,  1 Jun 2026 08:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7AE6B036D; Mon,  1 Jun 2026 08:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6E46B036E; Mon,  1 Jun 2026 08:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97BE76B036B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:16:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E5DC162471
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:16:25 +0000 (UTC)
X-FDA: 84831241530.07.6FC7307
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 307851C0007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:16:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=krg+cvXV;
	spf=pass (imf18.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yNpTWl0xPBGUcGWfJVj2ICQUSqQfQ1mvZCI3ufELKfg=;
	b=SvXbLYMTc+5Mmk/waxb7ktkfpoMu69KCRkmRaQqMhZtwVAl7vjjBHqNwwi60ij32xlZ3Y1
	uNOrtwUWbY71kcB6dgGCbrephcSWbVqw+5zfMjYKRckRzgzHzZO01wfLC9tXhu+5N/g/Sd
	FhSzr4MrAyknIYYHYrHnU1AJ5mAYBZs=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=krg+cvXV;
	spf=pass (imf18.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780316183; a=rsa-sha256;
	cv=pass;
	b=Ati/IgHjI8TVqNUdKlDbdPgVcZrQK5nMkZwYEwWTvv52fCVRsIay+8jPJB1E6+shrtKG1F
	p1ZgkF1hLl/xqE9Kchr7pnjvTFHDBJS76eicG4lguJRiE2tqmnp4qGZxxFcaQCk9K/E64A
	mFCuWl5oOreFAijOrJ59lw5jemDbiEo=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6603d54b317so579313d50.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 05:16:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780316182; cv=none;
        d=google.com; s=arc-20240605;
        b=UBHPCrFJUTYisrzB/eveEQNKTScjKfpHI5KsjeXxJN6MMAldJLQjSUbctcFRIH3U3B
         EWYpktXGHBKV7thsnYIfKyptdWBpAZ1tACRWfD35ZoZ+b87nBwzyMmOxJGgCoGW0+Wzd
         v3q9VIWeuGJnqchC6V+j5cmD2Lyo1cMEKF+rgo1wbDmvsKMjoL+DQ4pGobbYai3KXoCt
         eIX70noPg0pbLeSUQsIE5aCT9BBTUkN3HhG+FuZjFfkEQYQCbbvsQ8q24nz3HoDnqetl
         qeUARhJRCzFt03ni9OumtyVsBSokP6vnddBufOTRRr6C3aUYXhuS/h7+OGnTXPXh4fO9
         fsVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yNpTWl0xPBGUcGWfJVj2ICQUSqQfQ1mvZCI3ufELKfg=;
        fh=ftHXBZiZtTZwr+fwuf9q5v3P3pz72fwRr4wbA5dwq/A=;
        b=idn/WyaTLTYeb1QQnbng4GXiT+G6EuiLwnhX6CKl32HvX3bEjhm7z0mBVEaE51YKBj
         rn7wkXMkU142+98zCQaG5XD101S7j3TGXpsRq228rVnDOyecW9yH06RW0Q4vdczvxrIW
         LmaqMRtfzw8KeKwWRXVOb5ruDfXPfCiYTcVlMkSPuMLZhgydiPbKRMXEyzSAmB+6xi6m
         yazowRsiJ/ama79dK7GmNB9uAewws63L13fX2ObBwNZDXprIVXQLsrneN4uHn9NJdMKy
         gIudM8h2qL9YYH01JLadA8OQLWjOs92d6m5q3lRbpXSxIdTLDH9DM5v1+R7wCziCulTy
         puIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780316182; x=1780920982; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNpTWl0xPBGUcGWfJVj2ICQUSqQfQ1mvZCI3ufELKfg=;
        b=krg+cvXVcQrL9bqfvTWpI3yPqmqZ2MQZb98EP0Nq68xC6jaYCYC+X+WoaU+bgvnuHm
         OzVX3Ii5Kd4pMahqoyJRZFVa02ODV7kVrfyiv9QYb9fOPSsb8NU+aoeWsfyjGVivND20
         l5O5vxjDKxwpclOvlxzhUVwvVbcKNnBbT+S89C4bZLS3gMC/ufhzunNlo82TfYMESp6M
         BDZqW71HqJF0JMDMUbPJksP9Z6UPodq7D5VtlClzWcenpBuuKdgYD/wfE9aPI9u7c+sq
         MC8dYSQX9l/Hz++21CVgXFUcha7qnwaTZkwYJoJN74Z47954Am3kvLP3hjU19kySUllB
         NGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780316182; x=1780920982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yNpTWl0xPBGUcGWfJVj2ICQUSqQfQ1mvZCI3ufELKfg=;
        b=qbkY/laya3J1c4dnk3BfaX8HU32n2IQW15FU11VYcDpLxsBgoXScMH8Ra0zjHpViuy
         b/qwOyuvP9Pcks1rkI3v8th0Zt4/9AC09WkEhCDSoCy9q6TndKB7nLedByQCgKTwCDRS
         tlchAlZc0J4fwfVA9zX9dt66cEbYRxFk6z8WJR4hKfZsNmVcvv9ju99wlFxvhlYPxSb1
         H8oBIDhdfVhNkrfF+dxhUTVaIltpgAVo7hWyoY04qqAM9/LboTOSh1hWkgIC5b5hvrFB
         WHIslTstLfmPoimY6VhOO68b7SYgztyfbqP5BZxi88g4Chc0KtTfKf21gYipDp6F2+1j
         9vhA==
X-Forwarded-Encrypted: i=1; AFNElJ+P5N8n4Ic7+Q4oL5LTaKBTtrxvKeWe8gqlcQFJdwIzxw53e3YTsm/bpDM6zv2yid9ooUegs6zw1w==@kvack.org
X-Gm-Message-State: AOJu0YwoCJ56U6949efEgjmS6ceff41hohjE+3/tpOKwFfP5NMuImSSf
	XKBWZtiHvl45Zn2jXJYrMwO9d8Zcw7TT2raFNI/EE9fwIs0MdyMQiNL6CEiKa6SoU/W2sqxrRmk
	uiZTULSKlE8IpXm+vX7MHRlrhJnvI1NE=
X-Gm-Gg: Acq92OGSXdQHLPXZp+9xNAn/SBY8NQOylJ/s2Webob2qVRhTYecSrIwzvL5E0dgNyw6
	jy57yFXAF6im+Sxk0xskxu2JIgwUmKbyYaUQqGYxS6Cys3PahkpdQ5EqR7nh0Vx/tLPcEwG8Khb
	FfmE859N8dEbGQcTlkoNLM86ICQzz/U1XJeS3vlNo6JDd4GEf3bZrQolPg7YJYMwbWG0v4n8hrI
	MlXon6aGblf+A8LCzigSGJRWGifNXSSPjKLk+17UC3Dh2B2pMRO0i+LwadRCvb0yAD/HWrfZdhe
	O8pK58Lv6KVs9Gy+encH0kerQJ9rWXRs5cpnBajmVknj5Y4OICJFZCoLyLlOflrP9Dea0pmcHM7
	VULos4FqhXSgoU8TLvA4TD58Xb6qfSzdZrC0ds3Pbo/A=
X-Received: by 2002:a05:690e:13cd:b0:660:4d8a:961d with SMTP id
 956f58d0204a3-6605f01621bmr5971899d50.5.1780316181995; Mon, 01 Jun 2026
 05:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260601121122.94379-2-giorgitchankvetadze1997@gmail.com>
 <ah1puPfob4Ux3BWi@kernel.org> <CAE7dp2quHOofO4T9EV9+s2qb5o0jY0yO9L1f1Riu605OOWXbQQ@mail.gmail.com>
 <ah11RCIxMMji_PP-@kernel.org>
In-Reply-To: <ah11RCIxMMji_PP-@kernel.org>
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Date: Mon, 1 Jun 2026 19:47:12 +0400
X-Gm-Features: AVHnY4LD7MbLg3SwFU_rB9Yf9nFEQoRuyGaI9-mbjd6lZQU9UkMSxiTzDk89KKs
Message-ID: <CAE7dp2qEdeBCUCVxVuQhHsDgyeskUTUQ7Sz+TCb-rqJ5Fr-ALw@mail.gmail.com>
Subject: Re: [PATCH] mm: mm_init: use div64_ul() instead of do_div()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: s5ry86gof4asqnbdfwgno718xxtjxioh
X-Rspam-User: 
X-Rspamd-Queue-Id: 307851C0007
X-HE-Tag: 1780316183-489071
X-HE-Meta: U2FsdGVkX18gng90OxW7rSVejZgz2/iGzVDdpXYH3akbFKai4UUIjdkorG91q5Kmbaun+4AUHE68/bF/hW9eYNoOHeH9MAOhg2u3zeKOUe/W36OFWR2lGoRqxy//4zTSeuYmmuHP/s6Hq5IQbk9gbgzPXs9VFTKYHauUyL2aAJzfqdw6IWxq3fhp3qwS/ZsFLO9atf82SR0JLBN92xjVBHya0Ggu8ZKW3sz0gZROZxve1S9H+hTziJ9ghlnPgyeEj7Y66D6VKp7Rei+7GmccUYxBwyrRL6Lt+MMc3ZfjOjKBC0hg+QZ2wL33pqb7WMwGHFyk+qkbic8TJNmuqU+GCl9VTK7qTUYSDrGlm59iji+ICCwRjpGrMteqBh1Jx3+qIPzn1/7BRYHyWTIXt0mL+DI1FjA/k+Kb4OBSf76HcIL6s/7rkLHVmn5KExsArUmLZPDsRhDPWCqbl96U74oKm/FSR+xMkbt+QPRKDC3Zg6fmfkG+v882Ol4qg2hEtngnOYZ7UfWLeXl4wzJnzxLJ+yupX7QH9nEagWl63KBxdgSNIjIkhTUDwXZnqK985TvWzdSjoX6X9uYwmhaFo6GoRbWI6jaV3XWfguFcD23emf3H25VcKZlH01LGxafWCmC1VXkqKATxT//CMZFukUAMuLZSsGYS2e+VkqDUtfp2HPrqMm6cHC8gvLN5DsmM3gieqoSPaWqsjZz/n9F3KuV0OnTFigown+T0PIhbb6+BvM6T11L/GVVQ78YoG4B+CLCLu3GjpOO+FG8UdN2Bl+lVbQfvoEse3OibgmLaDOLCs17d527yRA0y/fHb9V+INF5gh9fE1QW55Xinn8M9dAeD/2kSX0yX1cyZApYZW4Mumx05eNDUTiUkjugBYsTmNfpLj2TgZHO3rxykr7YhKXX8iuzo7cbtLp6hQmOFc+jk4iW4fMQAmFRZLv4+IgD6z0HW3o3cZTSaysln9d3o63I
 x3qLFucQ
 8T+m33fiseKxCZFyohsuff/CGgyDx8uCjxu4jUbhw4OFwwrqVBcU9qEfTF+sEqcPUXiovWIRPfq+GmhRbGlSJGTgYhcgQqAL1PfzFPPgquSzG0yMfs2T9GgLYiJ6VKIaGMIUthqSEQEC41Q7BPDI6BMh5FbmfWtAJKxtYv8KHCaHS8xuND6WAsUeN1wOwd475FbLkdzVXG8QgcLIPAn/MMXPKuyNp3g4F5JVu8LyLfzi6l26igkdgam+cYopXsCyKAi1+cbBWDAmgJ4tRYT0SxV3gwE2WzwdZcWUXcl78jXYeapHj4PGxwvqXAm5Od3kT6FJ06gvrv1GVk9K4Rwr/pjHSfRoJOujqZMOMJb4V5P+8FJ4CVsH1z8ig6tf1GJprrjT1C3RsayYx+GwdmDm/UyO36EBvoK9xbBQkQGK3C+VDLoIFFf4oQgYrvSg74H+7ADyrr/0A69e/2eT8ufySxGh+fjYVxeJPhbT7wFo5IN55RIsaXRWeJbSs9NFyFU5soi3cPQdtnJLtt6YXPryuDS1SYEmst5uPLkqDKlo4heaYbIuZNjQv5aQOUfNFLPRQpITsacaIq/WUUtQFS+3bxR36LgxbFm3AhDnD5yb1j8RxWV7wbO+c0rHgVUNBnpPO4xbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:04=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> Can you please add something along these lines to the changelog?
>

Sure thing.  I will make sure to fix the changelon in v2

