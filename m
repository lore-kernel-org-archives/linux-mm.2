Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16729CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EA88E00D3; Fri, 24 Oct 2025 12:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36538E00C9; Fri, 24 Oct 2025 12:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A252C8E00D3; Fri, 24 Oct 2025 12:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 90EB58E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:31:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 394BA13C4E1
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:31:54 +0000 (UTC)
X-FDA: 84033549348.24.18DA379
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 367EC12000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:31:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M0sB9mvG;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761323512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
	b=dDUbcZqoraVFPcJlZBqEul+OYQEMn8uSP/TeTGp83tNnrusRjrRjYLECOGGZcVuOX+DPFz
	UWGEmp0ubXzmH2c+hIkrVVS31f04+BA7g90iYBsuVT7pLjek5SnZYjSVgSpC/I4PDmzr7V
	UXKjo/RMmPtjJB4AVrRCuSqP4jtj3KI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761323512; a=rsa-sha256;
	cv=none;
	b=ApNjk0GS48WjMGNZBVqJhlZkPP96oDbThDO4rVDrKDUahWWmPLjkufbfk3+U9zjb9ReV7G
	QlLpf/HAD6YmK+/4ap1wMCaw6P0c89CjkWLOp84p4dY9okbAbSUbMRWCHhmUWq3M7ImRbD
	hgQHmGkec4fILl3L0vpIctujrv7g1zM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M0sB9mvG;
	spf=pass (imf29.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c45c11be7so4053582a12.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761323510; x=1761928310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=M0sB9mvG56rJg9pntfg+2F+DagYZEAjsWJsL2SHT0DKurTQmrmdUBbx6ralMvRECvQ
         20v8NZExLgnXugkVYjqR8nqmccDnKvyVTmv0zY6apKFA1NlOWDzTe6VxLbEbkNzYEvmR
         qatF8N+ccz+dQ5ixrp2ZC9n77ffrMX/LTF9JsNNjsu7Q2KOGmMVLZrF+v4ERozaCvIZt
         F52mCdl2ZD8e8VIGG2Ka8QNmvzJL43alJJCa7ANmfBuOpCVX10W629k+33WFk6QDChKt
         lxmL8P1MTkKONkqQetpbKo2/A0VEacHtL3IEq+PuWqX0lXFP+vhHi5YcnO9S/ABoX76m
         jP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761323510; x=1761928310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OU6+xLScjAoCvkgYL37muGkf8RRryUsuClOGQPNvZ0U=;
        b=QCIUkXM9Ft+aJYs7Ph8wdo9sCCc35s2pBBybt7Vj6ExHk71yL/4RB8WSElH/Xyzb0B
         4ZNPsvUo2Wckpk+tWmaKxGAwK2tvdnViutuM2cadUMr3RaeK4qdkny1tA9I10Avqp+sx
         /kQNqyhxSOqEXqaTsrwJpSrPifVPJAPsYn0Z4tyjI/cUBCt937hOI2FxSZkCwxD7cWi6
         66AqWqNO8owoZIsOAUde3AnoG27c59IrpbAt2sqakkMsAUoS7zhwEOfXisOO3fVNHaak
         iQ0sLW9mu/hJQ01TnWvh3B8cFKGKzhyXzeJn4AvJcTrBhrsbOrktN/8u+Ps1fR3311bG
         94aA==
X-Forwarded-Encrypted: i=1; AJvYcCVzBEj0vEug5a/xr4tAyC4+RICoFASzPLXmsds6XFhehjcm6uqChzjZ2fFnyJOPQRlfUqxVqKVijg==@kvack.org
X-Gm-Message-State: AOJu0YyQCkd+kV+aJWren7dByIQwRYuEfg+ItXAHUiNNzI08ZUuoZTHQ
	ebyD1hLYxn1EDBwxxNY7WOa0VWTJ4yjIyptnSZAFx0XrEm0lZDqNbzf4
X-Gm-Gg: ASbGncubFgrkIdwMsCxceyaeAGTC1w/y6l1Yj2T/s1pbrEQlKMOvk6JpHhUGJw3riOw
	VGEAuL1/ldy0jt+mT1dz4YzqIRBEQpZW/CknBGNh/OOYNoXwv1mM7mNoq6PAZibPsg/bwOJB+8Y
	rtiwgFJuS095v1ewvnR9Cbhfj3Do7+meTEU0oD9GxEzoBfQzB+lCyu2qtCy6K04f43ct7CrW803
	HoWQHu+F05eYqZcgIN3W26KBM5/F7vOkzvlfdq9FQLklxbFYGg8/ctt/LTzFxt6WHGb0BiJSJyB
	ejk/HWAqH/D/+2lgZi3ZjA4XW9K4uDkcuOc05pndQzuz+e+pBAnGoimPvJNM2iCkEaqxlZ8Yf3m
	1tIvfJCDXN1Z+CJhHgF0nb5FpYkrkRW12tUoDL+5U6Yh2tguV53CPUtqhBVKxpu9W0dzNeOU7Lj
	hw
X-Google-Smtp-Source: AGHT+IGJrzUB5n97Ss2T/JTlLzP7kGDtRqESJivToHOWW6+qmykXupmsLuZ+wNfM3MQ1VRw6GaGwKg==
X-Received: by 2002:a05:6402:42ca:b0:63b:fbd9:3d9c with SMTP id 4fb4d7f45d1cf-63e6002459emr2596805a12.15.1761323509904;
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-63e3f316b64sm4717822a12.22.2025.10.24.09.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 09:31:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work (how to get data redundancy for swap?)
Date: Fri, 24 Oct 2025 19:31:42 +0300
Message-ID: <20251024163142.376903-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
References: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: iesa9miw1whqnnstpqz8hppwoingsbcu
X-Rspam-User: 
X-Rspamd-Queue-Id: 367EC12000D
X-HE-Tag: 1761323511-554033
X-HE-Meta: U2FsdGVkX1840DUNp1xmG+YiYv6cWZBfuba+1YclgvUHBMXQ6rGDRRSE/jVhmPNWBAFjU+V8Es1ELjYEPVFHFMniRy2n1DLReMYKOIEtXjKLALl/qXfsgJvLjf4nPPOahbIN2uLhtqngA2Hv6wupPURLwozsfJinWYkPtI8hTxCwrk93p45A5QQHPtg4xRg42Cn+EDLrM7yEimdEcFmHvUeYyEkmsX7D/VwKZNz0+zk8QaYOxJIHgf7xws024NWAh7RhTIYpYghoL8Ckbz32XPVCQfrevKg/WaH276i/vIfssAZJ5sIJP5rSbSwPapWKdP4mV2ChQxQSckMAJVHruxLRN3yxA62KtTYEGQ0JLQ51wc70rtsYH3x+Q5NN5KhPqXM4e0efmlw8omXqAzf/3CckYwGJ04+JZnw3NE/Gttw8bcs5lkUO8vfLxm+/6Dq3wC2hfTOsjSxOy9haKV9ZXjdQyOcftPF9Hhwbf0hF4G+PE06zo/NSeUjZNp2HC/AZX9WG9vZSgwJB9t881uDGSCReqUJBOHXkyWLfczh34niZhtnRK2PPsd+po8YehFLt2YH6olMi2idCcblJFEPoTbaYNYjnZLxl24lLizhmztKMMEuRKdXJgQM5MKQb0k3OOrohj9wvDgpbq7ZRxgbY3MXKNOJUHUdBIiuWgcyvT2H7OaHe+Fxe2KN3YMXA4JAo51nmEYtqEixufp1VrMJSiiNn/MokYIccfKwY3wcmOqH90KuIx2dT2ciGnU6Y6s7wI9yDJ98zJ2oJjTqiE3GMvbFRAj6s6Kd0EK5uJUbGtlILZWhXJSmbAvbddnTx9Vd2ohuDnY4uqlOh1eenGNG5US/dJwn+wt7cu/nrkoS38A726gvcuMgTD28qKc4fimMQp3Mg1IkRicWq95IhrtzHXDrBEZF1PllTOiEHybOxgyv6C49r6F+bKUBFc3t/9IQ1Bb/IZw6w8TTqSKUBpHr
 fgHHnFtK
 cqEp2pV7lHCBNioeRJnF6wrx4kTBW1A/6yo4zvw/JLAyRsr2aPcpaOMz9Z3vDpcic0Cb4sSIT+4GOluYXVwjlXmC81UCFj3U9LeDSQNrCrziRQt9R9+bEx2GDIQTu1aMcm91Z62U7qdwBuln7TdljfT7JfJ0vyLOLAjgpmArICjJlOdzmYRb7x4VLrF7be2QJ3OmrZg90Lu8wc8pIaO6PnavnGK7rD7WsEnhYhgNI02CwWsSaETZAnt2tfZgIVXPnn1bMM6NX5KE2Dx79Zdkpa1X9iE5wxf67CNR61/6KVFW1wCFWISib+X/NBrrz1328N3nUh6VznufQyrmTtV0b+xh1lokpSoHQyl3f/LsXUIz3M0Zck69+D749l1cR9AL2etrPLNS7mzJdOsbcgxhNi+uicKdQ55zR1BsPuVr78RAlbhG+GEvnISFBfY1z/0pAncZpKGur6TtZmqg26umzBNlPJQIw4xvgG/9Clw6y2OMvpVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Hi,

I just wrote script for reproduction of this bug in Qemu:
https://zerobin.net/?4e742925aedbecc6#BX3Tulvp7E3gKhopFKrx/2ZdOelMyYk1qOyitcOr1h8=

Just run it, and you will reproduce this bug, too.

Also, I just reproduced it on current master (43e9ad0c55a3).

Here is output of this script on master:
https://zerobin.net/?68ef6601ab203a11#7zBZ44AaVKmvRq161MJaOXIXY/5Hiv+hRUxWoqyZ7uE=

As you can see, hibernate succeeds, but resume fails so:

+ blkid --match-tag TYPE --output value /dev/mapper/early-swap
+ TYPE=swap
+ echo 'Type: swap'
Type: swap
+ echo /dev/mapper/early-swap
[    0.446545] PM: Image not found (code -22)

Also, I just noticed that the bug sometimes reproduces, and sometimes not.
Still it reproduces more than 50% of time.

Also, you will find backtrace in logs above. Disregard it. I think this
is just some master bug, which is unrelated to our dm-integrity bug.

I will answer to rest of your letter later.

Also, I saw patch, I will test it later.

-- 
Askar Safin

