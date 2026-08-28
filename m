Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88079C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92ABE6B0095; Fri, 28 Aug 2026 09:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9030B6B0096; Fri, 28 Aug 2026 09:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2766B0098; Fri, 28 Aug 2026 09:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57AC56B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:05:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAC018039B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:05:19 +0000 (UTC)
X-FDA: 85150699158.30.3C567CF
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id DA3C81C0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:05:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PBc593lv;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787922317;
	b=oYdpRue7dDy2ePpEDExfN60sZdTKEKTOdRi+436PZi2UFeQ3r9R/bCSwF6MpRzZ+RWQEIv
	xt0W81e5JEoX7gHPI+AOijBvakew5/sM6ATc73UO9hgxNtl2W+FBCQVUgOcwRvUn3SRZcE
	cXcOAWa07gEBSjIZQSa1Jln94uSoR8I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PBc593lv;
	spf=pass (imf18.hostedemail.com: domain of jannh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyY15gZ/uyotBCsU5YViQYJjvIkD9znAZ6y7wL3wuFw=;
	b=IN9uAZVfMGcXssWJiwt2X6imv6o8Xnb6XJuxMOEjv1kB33LfOZgDAi2aKD3nQNGocI+6Cf
	hzbmlrJ2fd/q68XjMf69EBuIqO3OSssq/LAAXzUAt5xVyIGt7lHjrM5y06IrrI19j8UwcP
	4enUeu4u7HNcqPpXHPpIxiKv7uVEI0I=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d3b440b97aso105905ad.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:05:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787922317; cv=none;
        d=google.com; s=arc-20260327;
        b=dq0Pq/3+djyCM4Idr9QGIlzsTdJMCaJ2PUlYRbpuoQCdvOi6XHscNUKapwAFt+fYzp
         PhPUs1ZR9nzeYWFUK2mO6SaYBUx7hvQP2K7Y7Fax4E/A4PbWn4aRcwie0emI4aKlJpdC
         daxJy8Xg1T0mUsqhEAcDOZSY88LJNZB6NKA57jOI5LOmG8HG8U0w8HFL8rlPlWaUkKIl
         0ARmboM9bvVnBFPA0GT0dzIuvgOZT2aORsKsc0Y0TEBebN7W7q8hWS34maicTnIVMU8u
         stqRrLGVbItw+8yE1mAy3Bk+YafmL6usk4cqJnOzDLy5UNAgt3+RXQJYQZAMoK9ojOOc
         8/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XyY15gZ/uyotBCsU5YViQYJjvIkD9znAZ6y7wL3wuFw=;
        fh=/gSEX/Mf317V5pvXpVHShdtmuUEj1DVrU81sA9wHzOE=;
        b=XUWVdUjPbFvEkXANRIZ1xVnC+/pwEYcPRkQRakHYoCtWHZvoPYF753S7Qmccta/2xW
         g7IFkt5BSOQ+ovFtMV8WOeXP0eoj3IGNrumYNE1iTkKQnDLukK4+PwLWutbMibH/zEUM
         LZQobQksjtadIxxAa7gjWEdVrGPXh+0OgxQP9uE/tNnGvmEfLoz2ZcrsrcTcyEO8FA9a
         NSy4JYKKnsPd4QRBSfPqdTowfXaaw778pUiD1o5v4aruVyCGLPKkl4nazFblpDfml/Ni
         /jCBFi4fToUt+7k+fB9uDyFtUI+EUhectVVA45D5FhQcnPfvsOJqrTeGEY9Mxxtog88y
         lONQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787922317; x=1788527117; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XyY15gZ/uyotBCsU5YViQYJjvIkD9znAZ6y7wL3wuFw=;
        b=PBc593lv1sqQoz/UM+Kfm0yoKqbiDMXeZyMuPGkeMYTsgYsyUeCHhLW0f/B4RJor1J
         r4VXq/s0wmZBjgmUPJA8McNyjUdOypN68Bvl1wfoKsBaWEo5dEQbGFxtYzW+03dkUquk
         5yQUT3gWbx/2i5y+tqlchB0mN88P5Dd5v5a352SMfJnnHbdyfdpmJ9T18v4PHekWUTQw
         djaN0XNtJNNayAgoke+tkCr7F1oXlWnStKIl0xBWEmc+GoF45J554OP7mEx86oXj6ffO
         zt0r3Hje4YPXMTZphAQfgyOMDXSQRcQ4J0+cm1bPopWxe3cLORRumMos2L2L2JUAh3u9
         v8dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787922317; x=1788527117;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XyY15gZ/uyotBCsU5YViQYJjvIkD9znAZ6y7wL3wuFw=;
        b=Nwn37DNrvDfp7tWDnd2JBKqfw1R6gEccjpGqcW20NNpZ8enUDnoX83F/lO0xR5uCct
         JxdqvIes1eyeO4npKAylNAm6UeX1F+MdhHsaI1uZtgMIxJNWk6LZh7IJX4VREXmw1BdX
         pgTmDj6svkrOSt2NjRQ7keGi9sDLenNJkIk7cN6BT4hjIOeGdWoVlolEZ4vkt+PojA3S
         go+9+XC7NGQ2J9Do8UghurnQ1P6/XDDzVsoOxXyqfS2ngyezUGWk66icpli33DmeJADe
         i5uTPKihJAhh34T7eYXoJPXwQk0CVsElXaF9uFssm5hPmLtpTfKcaxtwv+JYBSBtCo57
         zhAA==
X-Forwarded-Encrypted: i=1; AHgh+RqLGykKSkF1zsNqQ4CJXC5ftLXh/jz3TVFvoh9punu3u3uLg1Di5KwAtzWm2ILFIvv3xSH9dvo0iw==@kvack.org
X-Gm-Message-State: AFuF++nYariR8gQbV874feX7WcTivuqabUU6lt1GyCQEg/3nxmkR0JgJ
	F51ywvW7dTKOH1nNsQ17pyBZsjPFv6QMsxKf4REDDSOP8ajPXiLzNjtU3jTinCXB1RMCRTG6GvW
	TcTAzfONQQ/RGyNNAbUBO7JlOuE57YL9FEgXqxheI
X-Gm-Gg: AR+sD108gJKlDMGXf5G/NrGdVYbfj5x+BLqktZMm3PsHaH8xix/T//UcZ1G64eUhpur
	JP/GfF1iHTN8uDAAcpe72Fk4fN9GWDs3/gr6CB4pD3JvCVb/nLMpFd95W3a3KG52+GMyE0QTwU7
	0YgKM54z/wp+wduP6CdeNmTddqnecjLifk+Z141KRlR6UWiDh6llhHrIaGXj34Oqk3iOlo7vBCw
	XHSrkGDYlEBLcVqyU2TORMr6DkR842JuBvDvg+5R1TDrf+pADuCzW+iRFuaXcC/6XMoUXF4Mrmq
	V/RqKCqoMWtnhvNVEUTtC0LFHbqrxqGJHgla9qwkJx68AQckvEViAOni8PLZLeNa7pDr9yUe/MJ
	vTU3KaRfZ7bUn0WxDCNisXImdc1GCik4=
X-Received: by 2002:a17:903:987:b0:2c7:b1e7:501e with SMTP id
 d9443c01a7336-2d75482c43emr5737145ad.3.1787922316046; Fri, 28 Aug 2026
 06:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com> <de5f1c2fb1ccbb92beda6906e23ac457@paul-moore.com>
In-Reply-To: <de5f1c2fb1ccbb92beda6906e23ac457@paul-moore.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 28 Aug 2026 15:04:38 +0200
X-Gm-Features: AcwNN1VyfOvZNu7ELf4xzHHJ3BQoTm58QSMty2PAZc7oNVjQteiUlR74XB89qaw
Message-ID: <CAG48ez1NsUqpZmr66RaeFXMicpZT2FjMfwqTJwcQva50XN6cGw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE introspection
To: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA3C81C0007
X-Stat-Signature: zy95h5w31t74mutdyhugacwo45dbtpu7
X-HE-Tag: 1787922317-677845
X-HE-Meta: U2FsdGVkX196T0xJP39ze1xegTjsqo5TTN8twxrpC+t7NzPmaP754IUJy+SJMh/U/ULte4siAjD5QITp1bfTLvh/fZcDeKaCb9UWGE1YzPXtIYupfOrQF1CXDDxNg8lAJ7ujksDC6U/FMnjlBEqou3r05F7noLnVUkavy2WwDR7NJcUjvpc0mGIBb6TODe3c/RfghC6mAdNkewl1DTy8DNUq69Rl4JmabxgnlkN6dnM6R38mK1wHP5Mq8KdHCt5/5zmxxNsB2I+szcxxl6tkdnkbjl3Nn9DqDsu3X1H8WQFEtlcRdbhyzB+Dd8EZdJPftYo7sTXMZnS1FqOTROZ53mHhs90/G0hRlzLvpnYnxgTMNVIaptp0QN7J6H2gmrPfc7eWdyPRCUV1iL29tw4RXovVe/UMQ7pyDbppLaselpGJStlTQHBVzYhDWXaMGGSW9Nkp63yEjey0ZVy/2TLtLqJAtKipaPCYlmZ4vOg3RucmVidvhDbM7Dy1GFjbshySJpWethozOG/2JmQK465Yoe5vwfNG40cwMV1qGkzs/w2KWqqrrweoQtLXNdjMn04XuDJHc1qGq0sjxb1PfiwD6Cw2fdLKufpKgU0Urw7BcClZU+0QV5VzU8MiNJ75ZEFI1yFXszHIQRfTFo/HLZnTpYk1/bcU8oU+aIuRcyt/LqSf/CQDSU1CIxh15aU1KQ4mURtlCiA9PQZsNHRgOW6UaGKueU7BM3ZMLBV3oAND5rlZkoXztq1H6WgukFoGaOJyEghKRLH0YwlRgbxOfAnleFZhz49Jm4Eww9pIO6RCIpse+7yYZE3wnofPLkJ3X3epAmiZ15q/k92ZdjmySmceI75tBnUpt2gJXNTf8ZQidGiQbgQdKyVGU/kjMJJwhMwwR7rW7DjFH9bdRchDrCRZF+bJkV6MUkZPEAC4U+5SZy6Zof4xCPolVlaRgFI+f2VhOlhqKmAaASyNnt4AU6z
 1P3YUK2i
 Evd+cp9ML2zjfDHYd+W7FBApp43UQJi11PZyutmaYuvLO7KVwqymJx/Aly7Jh9lPOqPJmGPa2HxDxVH5SKwubvhNtB9qh92/OD42fTHJbLyrVoOSeJhQuvGkoFilhngb8tVJRdfwaULMbN0xB8lAxfR1Qx59iEZP0cq+4U/NRWYcf5fQNrTqfqSt1xtzT5fP/xdc+Y3W20Lnt/Dr8RENcQoQE6y+AO9d86CoeUYYbHQ57h0478R4JmJH2Y3iMp37M+4rBXTiMmqy3CzPptrk549wp2qmQeZBKbq8/uidCXOc4KVbybKG+3MY9YbF6vADx9EjJazMUYijXbepVnZKSkiRZbDgwLwCcqdGfohO5MGwHah6+EKooA13uKDuw7QO13VsoNh3+1gFaaucR7soqKxoCcpPJINlNGKr7JIcLs/9B8Vv917N4iU2p6vr0MHD4TRmL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 3:10=E2=80=AFAM Paul Moore <paul@paul-moore.com> wr=
ote:
> On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
> I realize not all of the SELinux hook callbacks use proper kdoc comments,
> but I'm trying to fix that.  If you could make this a kdoc function heade=
r
> comment I would appreciate it.

Ack, will do.

