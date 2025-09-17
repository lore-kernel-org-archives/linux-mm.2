Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C89CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717948E001F; Wed, 17 Sep 2025 16:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8518E0012; Wed, 17 Sep 2025 16:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDD08E001F; Wed, 17 Sep 2025 16:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0698E0012
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:19:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E686D14063D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:19:42 +0000 (UTC)
X-FDA: 83899857804.19.75ABE16
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id A1B064000D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:19:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Dk89GY9H;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758140381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
	b=BNgGhsXEni+QwPOS8sv4EJeQfYBT3uypfPvTWXsX06e4ETXOpxWBTv3c1jcpcS5ASWTyph
	v7AbOUrUrBBaUnc3eZviWWa1W1pI/f+qMoBHt9RcaqedMhebjWw/t/3OYGM3/UXs8qBlpe
	0MqKgy588DGBdet3oxpJVi70GnwCd0w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Dk89GY9H;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758140381; a=rsa-sha256;
	cv=none;
	b=bF4OMUsJSdCas1sWDYtIKv/zhhY4eMVrrMqgrgoDG7Ng8keuXIT4G95/PVmPuj6+YkyzwW
	dla+AOEICaAoO5EpBpa6mT2o7klIB41KV5hl+bCJSgMYJh4+S8Rh6OUobKyxdKC86fN8cC
	dR8YhkQCrlkS/G6cA4IpnYzv1tmELgo=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b07c081660aso37743966b.0
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758140379; x=1758745179; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
        b=Dk89GY9H03u+ahb//SB70nC0SPlakZYG537srugfZG1461HlQN/WRxPv5+ZhuVeY5Q
         viqjxVnMS1e0lHcWvXt2z4F5BqyFAGJCegOmxx7VNlKsWNBl2UoNTM1ZvBnVlqz/gNHN
         Ee9t4koUUdwYttvnedXfD7g4ELtpvNQG4+6ZIxR/rzFXFtjFt7RGPh6l+kzx5nMunwHv
         W/DzlWwQ7GYBU47vyDEtSmA2Zekohbj/FBjLEDF2wkzBzn/4XF4YuG3Cm3BzZAK5mWEp
         B00fmscRXzV+OMjoKXEVHahIlI0ioRMFIThjVWGVBzIVNzpu5RAGaf0ACS3oMw843PAt
         GNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140379; x=1758745179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
        b=WpuH8PGUYrxf2dojJioB5ryAg98qo5Qog55bXW5K2MLX05hNhNkrLTQQ8vwkNCLdof
         caVJq6xqMvEpHWDbevFQLcugDrLuNTEucqT/RD9ERhnIaWpZuWpw9aviqv2Psi4O4P1w
         he0nQA0MY+CXEmYrTd+pIz3zdgsbsUu8PfZIoEBhU5rBrAjCMMhk6djA7anIy95LFCRN
         cuTakq1CVxeH0DVIrL7lMqM/EBegtQL5Jn0oR3IPiDD44FCX5yZ0jkz5pCgqgjf3nfir
         UDehuwAoZ+9IaOnTlbTS4YmuQWXX9BBV7OsAFl09BNm/meQ0pz1+NUZ2mJUUKRJKlWnB
         ZVAA==
X-Forwarded-Encrypted: i=1; AJvYcCX/QJxwFfTsVnexMAfpFM8DUxf1+m0toZ2F9zIXw7HnrNQS/rJGinTMpsuTrqH8leH2KrBDFY7DTw==@kvack.org
X-Gm-Message-State: AOJu0YzZrpSc471FR4StMN1xVk3S7vU57OOMNTTRkSNxWuNg+HHkqkN4
	eL/BX0hxic6ewgfKCXKqR+bV4FTOEG1IIQtBSGBn9KcChlwAJkDYajvm2lhQum39oLNIORK2adU
	Rki1F5+phWZXX4AJ1WyMeJ5cdrNf+Zi5qcIBDFH1jNg==
X-Gm-Gg: ASbGnctuWNQliciKZP+gyCXa713V8l5UfNfMnSainccWG/Sb6Tov4SuFJP5IXuPnSPm
	C3ORCOJPJ8ONt5XHH3BIeJ0/TANAjjBik4Pqw6TaFztoe4KUELZpEdLuYuAXovEKQF+3QWYo7vh
	Fv0sbiTnTF3frWhP0RZC179U4azHqDufkfxZE/ptmqXEqhpfnxmiyTZ/HIhCJBt2E21dCFOrDwG
	kULISdZha/KbVJVqBTjD4tUbL3ZPpUpd+AsqTWK08kUIT7MDkb0j2c=
X-Google-Smtp-Source: AGHT+IFQaLDy/LlqDOKaXH33/5p9CVpaIIbnENcFkO7c6Maci4zFzsFceKZ4fsH5U+Ovj7N6lS3oxCJsn8eTAC3ubkw=
X-Received: by 2002:a17:906:c156:b0:b07:b7c2:d7fc with SMTP id
 a640c23a62f3a-b1bb5e571cemr321943466b.6.1758140378862; Wed, 17 Sep 2025
 13:19:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <20250917201408.GX39973@ZenIV>
In-Reply-To: <20250917201408.GX39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:19:27 +0200
X-Gm-Features: AS18NWBTAX9o17WGEZG3_vr6672P-Z73BzGF9K0FZmb6uSVnrvZWBv6zug26UJ4
Message-ID: <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cznahrbnibrttpf6n68b4ruh7j7an48g
X-Rspam-User: 
X-Rspamd-Queue-Id: A1B064000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1758140380-888662
X-HE-Meta: U2FsdGVkX1/cx4dwlTBkBAxWZgAzCPpUFNyiCtvSJDxx47OSzRL+5PacmQM9JqBQNItovNWOrWlUz9GkkxOkNwT4K2uX7ysy7tVCBF+vawU/3yY7KRd0j0LglP7sDgv5HAMSb6AwEGv8NXijeNg63QGZDBkTmPejxRPgx3ngSTov43VA9KhhigVLequlM/XTidfxbn58qWEwJkXpx9OeXBg0rHMiDeLcdTi5OLScHZ1Lgx15+t02/CbKjc9DS9eMJXCopvlZZX0SbmDuYJ0mQ9DqOrHsO8iYlCIJ45ETQfNwJ8+KRCit2c+KkwP86qwvU1jB+cZSCW7hUSOhTatVYwqaq08HNM7mNTCoqRkReKj2MraYa4zP71wOpRyFv8WhxmWQXq7nEXh36dd/cqn7jATo1XNZ9gGrANvqwq93STELlOwUg5lOWYe9pDdhYtJ47L/eOmFPtGYxIfq/mEqOuLHZoXbcWB0IwcfGBaqRo3MihejkIMNXnbQaZoovt2B4Z+nZhJHcQPanrZz1PPm5+bSA8TffvIgLo6XWL5Qe675VzSfXmPA2h6xXWGV3icgOf2KQ/BdNR3xcWms+XBvJWHqIIDQV+cZ3QneQfx0tkkNnyVDEn3/hk0H8Ocg7NSrT9VlpeMiTohpPoZYmB3Y2ukKO1cPeNHW8OS2pcdKpKIsvX1gJLiwy0UFR5ZmEYK81C6JSJsNoq5DzO/7nE69bshLEs3XPejkl2U5JX9Pz4e5MpoweXg8x33GvPA39v+WuhZZcqSBpHjjaH57evfiteu2k89cnuPS+KEERS4GWYDr8VUgm+irn+3DEgdD8m9tfPwoR4HW3SZGcAxPHF+8qSpPAba0s2lr2C9ar1RJKgIq6H0n2jqrQGDqls5LPnHyEtAWYoTSphMWko/lrh/l4bSmp7iLOXRQD99rAXrzqYUKoyPiKvKlUDvOnjWwrMy+cZ6gyDNQMVBj8umfm2bU
 +4WeN3wj
 IVdE4r054uRF06p4LedUxbXxjRFbFtZfQef1/OvvoUF+fqWZ76ita0C2Gc7gFN4MUlQjtJghbxqN/27MMeRiokqnlwInt5BmCO+nX2f2YPuZhcWILfstoPahpjYiTIN3hbi6J4GjN8LRvRja9geipS/8MZ0awTEs8yPuOhSG5w0Q7fY3LEhOc5NA/wxw1oKELJo5XeFOCi4vKl2Im74siH/pVI3QyFPvQYmVAkW7ZPoWqqNdDDKcNMIf47/9o9NScDUNwK+c+a5J5MRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:14=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> Looks rather dangerous - what do you do on fs shutdown?

Sorry, I'm new to this, I don't know how fs shutdown works - stupid
question: is my code any more dangerous than what's already happening
with ceph_queue_inode_work()?

