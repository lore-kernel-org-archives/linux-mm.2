Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2C6CDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 07:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0980D6B008A; Wed, 24 Jun 2026 03:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06ED26B008C; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0236B0092; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63176B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:12:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 478C44022E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:12:36 +0000 (UTC)
X-FDA: 84913938312.09.207BE77
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65E73100003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:12:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aMK7jcJg;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782285154;
	b=oqG0TbaslsJPVFfyPKS5XPiEFiPbRR5AY+/kdag8hfEPHhCNMNR9/V6UYoA9OqGjZWGZVK
	YEqf1vU9Obqvzziu0lFzOPmsG/QPuW6TLVEN/BpF+ktbAjLQiR6AMHqRZckgnGt7VE3acQ
	n0iPbwWiSOg9NgVrgm4cfHfC4KMOgFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782285154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VhG9FcF945Re4Q58PUpr7BwlsxWpmlT6fgah9/vT28s=;
	b=52LLBLIzuTWJKuYvjjXKl2OQNz3tFDODVyDEltqko2zK1k4LKSNz7gePbC741dD3wFqDay
	MaG6Mh4Amm6tnGyOb6gkbenUXDE7ZWHqlIJvTWdamM2CjeO8+bHh6JA+Elftg52NrC21ZO
	xxmj/UTOSJ+dtt67gcUM8PN38LvFggE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aMK7jcJg;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4633193af19so509442f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782285153; x=1782889953; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhG9FcF945Re4Q58PUpr7BwlsxWpmlT6fgah9/vT28s=;
        b=aMK7jcJgsUf84iidVgXs2MMy9mqiGycImzWt4flzR3IYjXq1BKnkkobNzd4Zu9FrLH
         gGhztLykeIFnQgmSpMrpatLgSedQnEyq2+D6l1Na7aKGCzUhK/GmAMdfS19WivJlSZAQ
         vQBXPX+aJ09wsDriQWUTz+kXd55qjpy4Ns5Ng13v7BgcIOtNWGaJAqXnuFQani95geKh
         RUPNhCNEgFj0eCnlC806ex3rvu5zTWim/QlMuUdMAqc49tdIcrHzDCnp3lk9EreXAv0D
         qoPEwa66Mozu6dFS3MCJ7AqS+afAaPlTRKx51P7SUfl3bhsx/nHIrh1MKkGOU+C2hMON
         RCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782285153; x=1782889953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VhG9FcF945Re4Q58PUpr7BwlsxWpmlT6fgah9/vT28s=;
        b=U79nOUyR/Bk+DG/SLFWwOk2a5oWJowT2LVUzEDSRJYgBxIpSFoj1LY2B3DdcV/Mf26
         wi30STzcg0pdm13gIFdghgl/WT9+E5rQD+KqSxiWTvKggxAnMbRkuiLioMgMEZSWWoCk
         CyGGbOd+Ivp/KObtf7IsLEgSMl1ET96rZE+i7wlD2kBk1jEZQFa9JNEBzQSzAlha78AF
         pJlA290D85XPidF2pFKOB0ag/MlWp/ENJqmrsT6Xhfq6uBLOm7OzDgkHmpY0f5+Z2TwF
         /SoJPNoPM/+jXZF6eiaJqfjkKm5AGSNVIqL7t/eF8B6WHmdzrjdGzMqmao9t8q9+TSWF
         Ad3w==
X-Forwarded-Encrypted: i=1; AHgh+Rrq5bHVpxd/mejcQ7TGXXzhf6RCJ531joN1qSPCM/Es+BIqtl0nM4TZtIOh9BSzkIcyzhbGZwOQnA==@kvack.org
X-Gm-Message-State: AOJu0Yzn7cwTqQWcJ6jcmbuONcIVSBEtmuUAG/iqBdrOWMBvmRg0tbDH
	tt+XlD5RVhrvadZnpHFQqx2HZSqBy7kRG4EiIlJsX/w0LleAQ6w4iI6F
X-Gm-Gg: AfdE7ck4tgIOORaQ2aSLuBOQ9ttxG57TGsWzmhUFnYNvQHrrUf3DZTZ7Ew9FXAbSbOp
	kr5otFn9uqKp4hUVgZ9oRAjofNL10F+ejuboM/+XPGrtRbc0PiF9m51/YWpaAOeWuePD1MSE2bo
	cjyrxRh74uJN9AOaQCXTiflO0lTLF4Q1Z9zgdsCC2+rrqUkMYVupNWQXMgnqhoXwpADaEH9X0C7
	7rsy4/Cx3jdAtQI6H98dPm8kcHAgaCPpsJ3bhOXXsEiftqANIaQq95LGy489CA1sPkbIgq/ZHQT
	YKaKVJbTtugWlDLFD/q4n9ttF8eXl2eHviq/tQIw1IG4vAHtPYpFSlqHM5qnKRzwHC0cSFEMI/u
	rPcF0dJAciOnJRvq65g1eHR/b/fzIpMmqvlf9XIT6yXXuv7MQoKtfACPPDj3YetXf3DR0KIotmL
	ffDwqz705V
X-Received: by 2002:a05:6000:4683:b0:46a:1f35:113f with SMTP id ffacd0b85a97d-46a1f35172dmr8359155f8f.21.1782285152523;
        Wed, 24 Jun 2026 00:12:32 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-46c1ee0189esm4296531f8f.9.2026.06.24.00.12.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 00:12:32 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: avagin@gmail.com
Cc: akpm@linux-foundation.org,
	alexander@mihalicyn.com,
	axboe@kernel.dk,
	bernd@bsbernd.com,
	brauner@kernel.org,
	criu@lists.linux.dev,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	val@packett.cool,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed, 24 Jun 2026 10:12:26 +0300
Message-ID: <20260624071226.2272209-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
References: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65E73100003
X-Rspam-User: 
X-Stat-Signature: h7zu8iksrmmbc538aauob93ssi939wwj
X-HE-Tag: 1782285154-125635
X-HE-Meta: U2FsdGVkX18E7gXEJp5XtUBBZ6Iic7cb1OGyAnirSIciPO/bntuQi48FY/cyiTqNyp7/gjJRiPJYA9SFAYMe6lemnvlcjB/Yru/HYUSIKyk1McY0IlRxVPUpIOF3OTXPyKccob8TYSGvFUh+KAgKv2R1D15f4vPSC5GQBG1D11YpgXMp2yKkmSZoMsPpFnkmVueilsCFrl1n7x1GCDVJ5Vt8/yFnt0n8oIJIFpJWGO4AW+2C3qLjpB7EKV8sK/626gR8zQgu6dg8FXoduVYrcI9Y/VG+ZaBk5KwMKaruYGhuc/khpTCEL6AAgkkW2nAQYSvF6OQQ8+pmluQH/EaZ04g9u4S3FoMlvidBS+fs6eQ25GbnCtDCrZYajsCSSgNa4GsCNqaUJDuhxft68P7h8ukR3fCHAX4We/OZI3Z7f6QCd169EUyXM09Dj/Hf0jKOzuOwzJQzJpzpV22GPmAuAhqf4bEvOFwvrN9ksBfK9Fuk7jY6E2PyLqyF5TUQuydfC9Q8RqLTZgVVgHG7Wtiy2YVFELJalTRJpPGtkkmihERYn9d8aiLerASfvoaBsyLxLKgayDsTGkaAohuD+BVwRXhfzBk5g1YxoHLYxqNoA+lvvFMpkasbWwHdiqqF0jbZXk7BGcpgNCPdU5cb9unYh3Yc0EDJY+U/PPIAmaEbawZY09xj0ht7BfNTxdDy4VIHWmvaxYBmdGLl+fvFEPW30dvnH6FRyo3RQtj3nd8YAgiQSNCcxTZxIzfWCRH7M1meRnXZ32iWjNjFtl6nZOYHd1bLjIQo0N1hgU9yTbNq1hRJhCAwf/zAZPVcOB7bG0MH2/OTorZOhEruz16mPVENP6QulvNaTp/HNvwuds6HRr/dfBowCgcAEN9T8hbLWts3PFZlXLkDIUTgI9b/6JIXftkWJwqFprW1DwrMLhq2M04cWuiiCgdw5mekRnEWyWoDXVbGAmyxdyxYZb4MlJy
 04xFafVT
 6vvZn2ck26qc7uL4HhptnW43FXi+CLQFUpc66k2NGZVsD6fJFMSRV8yUFm0T/qt2k6O502S2cBOifoGKqPM1FPA38EdvrN3agfN/YEv7hv1V5HHiOqhLvzT+5QMCKk6zH+J1GrhGAfsWzOhjzyb14cZCSVVyB1H31hReOnMEk1kXoOMKBBvXLvollHsUrpmuuduBnFRqVKf5sws7/Z5TL6iZRf1CN5TunoSkHj8DGyj2GZYPilkKNwsp69IHaEu1VEmSRX9zUQ0VYqmJuLvpYNsBiGewt3hyEDpdH1OsF1+HIR89qzG0aXekCf28fU213B8mfItHRDZLX2mIYM8TJoyWyxs4hJxGKuXEIyvwHJq7ix0pYZP/2EE/Z2PaTXHlOO2cL6guqBCF3SK1abLA02esW4Akel8QE4wXG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrei Vagin <avagin@gmail.com>:
> The CRIU fifo test fails with this change. The problem is that vmsplice
> with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.
> 
> It seems we need a fix like this one:
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 429b0714ec57..6fc49e933727 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -1253,6 +1253,7 @@ static int fifo_open(struct inode *inode, struct
> file *filp)
> 
>         /* We can only do regular read/write on fifos */
>         stream_open(inode, filp);
> +       filp->f_mode |= FMODE_NOWAIT;
> 
>         switch (filp->f_mode & (FMODE_READ | FMODE_WRITE)) {
>         case FMODE_READ:

Does CRIU actually rely on ability to do SPLICE_F_NONBLOCK vmsplice into
named fifos? Or this is merely a test?

If this is just a test, I think we need not to preserve this behavior.

I did debian code search with regex "vmsplice.*SPLICE_F_NONBLOCK" and I
found very few packages. And it seems all them use pipes, not named fifos.

(On speed: I still think that my vmsplice patches are good thing,
despite performance regressions in CRIU.)

-- 
Askar Safin

