Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13708CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 14:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102048E0050; Mon, 13 Oct 2025 10:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA4C8E004E; Mon, 13 Oct 2025 10:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31C28E0050; Mon, 13 Oct 2025 10:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1B748E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:23:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72953B9B46
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:23:00 +0000 (UTC)
X-FDA: 83993307720.12.3FC1CA1
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9FC698000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:22:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hLI7YbeT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760365378; a=rsa-sha256;
	cv=none;
	b=KIYkXpLsAQaZQ9PiQo/T3LcFTeSF3P+QSC1SUK2cLDE1CriQ5pslCGGXS1NffMuwzTBwwJ
	XGev1GKFWcR2iBiT/81JM77qCXQtOxbaQqLrAojWDekeGFbtUNlBHMe3s/YOFQHBLag7XY
	OcgrfPZ/9TnmBtcUzYb417elTu0aBQY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hLI7YbeT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760365378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQDmLmpvt7xyeehMRRFgwseVV7xUEOIemq4RQrq5AnE=;
	b=sNK/zNvhnJma6P7cmMLk9Tsf+0uHCvvDUUm+pV2KlEr6cn7UtBTW+wBp57StxdboFKyfnK
	Ha1TFfpMqXlKnrQ6T1TEYTNwb3xCzgRmfG6BU+sLEwnm/GturVGYub65GBtkIjnvI4t74E
	rULQZuByJPpCYn5/r7SmJH2RdAEGJ0M=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-781421f5be6so5533217b3.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760365377; x=1760970177; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nQDmLmpvt7xyeehMRRFgwseVV7xUEOIemq4RQrq5AnE=;
        b=hLI7YbeTnYBdUgrEGbc+Aicipysqenk95LWR+HyjhnSvcidx41iSAnBMbesJvp70DT
         xyaFoLagW3YyCNVPBL3EsnToRxaEfifiTHsQ7XOoL0d8GClA7Vs8+1FkaXLqB5CTkQf8
         xmqomJq2U5Ofjp3CdDJIeWOqXwYcnByOS8iskksGSGhv4cT9J00G9Zuiiqc9T7UxURoC
         kvczgsn0tljwpskWo2Xtfsg91owA1Zg2Y69Wp3apjCG/TmprFypHO4c/GPo8toy0MMM+
         wieycJVIKfeoDk+cLI+H9bow3wQccjRrNXfkTENP1N5dhE9z1UY8hmNoHXgESUBxrN0C
         nusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760365377; x=1760970177;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nQDmLmpvt7xyeehMRRFgwseVV7xUEOIemq4RQrq5AnE=;
        b=oVWEykY2dOiu6OseRyp4OS5RV2yNqqN3VWSNgHqgU6YPjBiCoMbMxwW5VPaJU7ZcdC
         2H2pLefDuhSvjej3Xn6eCnUxV9tICGY9n8dAvxWhhMfkwUgvR9BDs9YS10zJcFN4J1bJ
         Kc/ZElAL5AansoOL8jNiXhQdN6BHRBcsKKFeB787n/8zucKIVYd+abprhpvNyH+sI2Hy
         4x+tTgqfXISuClmClCV6c4Fs2BXtLJ+267Zuc2313X/9qpOJXvplHe8fjAAgFQ7sJ/D0
         2J6UuQYI1GAQSwElMbuFFFvU1fDGZBjHkehNJPjOaLyV8u3HO0X75W06zgaQz/DH8VEm
         OK8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNGQbJn+Tgw2AcR7TV8riQZVjSKwoy/A4XSKxIVWcZ8yrRi+ry3x8UXh6dHDqQxJgK0Cel7rD8RQ==@kvack.org
X-Gm-Message-State: AOJu0Yw8kXM3ug4vV9WZ7cSHRqEuS3XCRHmH7ohsIyictYTZFoecOIS9
	Zmvsmg2lfk/F9/8je4E1Aesn8rPkmVMSItdn4vhm6r2KPCSoA/tOUdJRQLJXSNpkxEqQ+mf7YVi
	aY1v+9rA6LVljowJnhS7Dpm4mCTQoI2c=
X-Gm-Gg: ASbGncu4xzKLUvbwXJe9xe1Uil9abl0bQnaydegQ7FHidiVbwpvj1+OLjnpQ47kNPA5
	jVWZhvRk7fpLkRj1A2aKK/qPilQg8FsrplfU9hPS5lVtAfTvZLZ30eG91KGWnp55PU/txPC9Zen
	BLmzR0eQJVa4j16uar/Hx6AtffkEIzVTg0kUTtN4pBpAXf8zrK0sKoOfKBnylU2ycMDxFoai4nR
	GyLmWF923AlBm2WVgNc2nLR0AR2g+dKpz3dNZ0QAUIWI+AKRB+V+KtzmCrXmG0st/GKn/ijAHWQ
	D4H35OQdQE8/u0dgeftjkN7gaQ==
X-Google-Smtp-Source: AGHT+IFw3m5r5B57PTPTqjIZPVu/VeImTsLrIGOLmdDTjH42dwQ/oEcjzZqblWVNhJBiQlGGV3aa/bbrC//1J8fxHRQ=
X-Received: by 2002:a05:690e:c4a:b0:63c:f5a6:f302 with SMTP id
 956f58d0204a3-63cf5a707e3mr8298400d50.68.1760365377470; Mon, 13 Oct 2025
 07:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20251013093337.4432-1-kartikey406@gmail.com> <bab3249a-d9f2-4f19-9493-b7560aecc3ce@redhat.com>
 <aOz6wqdZcEY8-ufB@localhost.localdomain>
In-Reply-To: <aOz6wqdZcEY8-ufB@localhost.localdomain>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 13 Oct 2025 19:52:45 +0530
X-Gm-Features: AS18NWBUkYtvmMzc5cc_0q9l-c8KMySPiyoca6hPI3y-2obBhc_-nDf-RcT0WDE
Message-ID: <CADhLXY6wvugZN+_ok8LnwWjUP8CWB4ETKtD6Er7y1thnJXwFFA@mail.gmail.com>
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
To: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>, muchun.song@linux.dev, akpm@linux-foundation.org, 
	broonie@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 53pk89hekrhbkzdmfqmt5wz1imff7kuh
X-Rspamd-Queue-Id: 9FC698000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760365378-390329
X-HE-Meta: U2FsdGVkX18LnSr9tWpFS0x0yNRGBdBwQ9enxoAXv0XR+gOgrwWPV0AYjY1N3gpa6F+fYEtB/tjoJHr3Om+FHadbMgN+cGpnWuercgDFAHxJUW7MgIyNn+hSF1ETe5RakZ2R3hDdfcnQ8AGtKR9Ajp+8QLyXxjGaHLp0MJXTQl+LaJ2voHKt2r7jPk4jNOfz2ikXceQsp8b9DyZ2kTQwB5xVA5rhutclbLuPf0SXJTXKLaQxrIaEz+RzJAZTNDZdw+siv0nYvwoIuZt6PEFsJKSVwW2EAjt7dvR17Fn0vCoMWIBHqNZQ4QIlcyppZ++qke8CE9C+7ClEjh6fAAuJ131m/hbounngGxJD47EQ13t3Crg/vH0XE9x0tyF6RhGQWDNC3FuYbHPVeJrs30vnaie+0cRWE+RnjRYYV9H4ZpkT6f/jXgDrmMPKihr/7s7QH42k/htGqtanFA0sW+7JjqRSDTAeULqgH4zw2V1ciDO5Np5siI06vU+/MJBQoGp4lZxoASVcVt/7gXrYWStmttErnHRkvIrLIPhtTYysGfww6DUaF/ZNIo8fN3Km6ACyDH78NqbRMAxUxzPE16dysQC8Ac3liX5drej88hoZECb1IUg7uVy8AOy1BeLIG5wH444Aom/dfTaQmujs0umk4s+XScQbv82qLrld7Uheow0DhiRnskQW8ihL6euUTMC6PeRht6UGAZTmKKkHYb0akjm28scvudbB+Ceyf9C/P5xis9xQJDrYtZP8qvP0cSdtt4PcnhuvU/klD8OeITyMM7uDcnHmzdDAOHB05HSYMmV5AVLHHYD2DsG20CELXqd422M3bXpp5EvO5ectG5aGofyhTjIKNrOcAj8qtOA+94S3xSNksE/NHyAaE9XpWSGUXyrwDm1slNrym37bU5VO9/Lhk0tIg7xyDfo3GVKDfJEEbqlDWVFc0GU0oQiZvoLFSMyYMg67p04T8pnvim8
 Mr8B8b02
 lFCC/sEijECwEPP14RSima0Ar1p3A9to2VV7O1Wfrr9Vs56fE62mzch4E5pKIV+uh2dlFrEA4xyzNanNlip+887N7MBm+bPXFdAMIkA+eSF9bBqGCA/TbrF2X6NsxRnOHiNoJH0BjSQJmqHse3yTThA65PwkjsEdzypAk0DlC9GmXpAftT0beNydAKt4VrBicvx16qSIxKGo6P5Za8qDhj5bgpDW3+fL2Gca9eh+MjdLrPKBm2GTZZBFF7iyrEKnq6rHbGL7EJfzfNw68T6Ab/CeF/tdqE2FwQssgl/mxxz1/ETDCVEzGAs+S9dtbEirULyd2UDr7ZDUC50/hX1LWHkyulGWCA3G49/YUlKURkFvuM2Avlf7mhz+lzn63kAOqNlQjAYOqbMrO6nPlKBhfZpnJ9vklXQhFhhPwGa2XsYxGRGBo0Hp7pLWoNmSXJhMQ/dDEUVAqnrBmgMppdCC4agBOT7hqHpyau38Jn5o1clWsl7iHQrTEW61i7wiqPUwkrzkohWhf+3y6EMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oscar and David,

Since I've been working through the iterations on this fix, would it be
okay if I send v5 with David's suggested change? I'd like to see this
through to completion.

Thanks,
Deepanshu

