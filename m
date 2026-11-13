Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE0260A2615
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=W6tEwpaC
Received: by kanga.kvack.org (Postfix)
	id 3E2676B06A2; Fri, 13 Nov 2026 05:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA2E6B06A3; Fri, 13 Nov 2026 05:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B02B6B06A4; Fri, 13 Nov 2026 05:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 083436B06A2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:26:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8260940579
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:26:03 +0000 (UTC)
X-FDA: 85429715406.13.6E550B5
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf26.hostedemail.com (Postfix) with ESMTP id 996EB140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:26:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=W6tEwpaC;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565561;
	b=xVB7xsLRs1Qxn/d40GXlyKVDzTrfKfwNVYfb940NOEx2gYaoRfunZSz3g3dTLyWvAxJnbV
	qm2t89WuEUt25ZYXkJbS2/Lm5Sf2ygYGKTaZTiBXKNYs0Ff7Ni5NqbQAj4JQw394CE+4Db
	6qyARu2VXBaGHqtZRylfTEPR/vzCyyU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
	b=YvDdGzbH56tfJz8oEVAcBh/C3QiQBEucDj2eDUU3Fs5ZceE1sxWjnlCjhWlwPqKgsbRNCD
	IDroVmKOvG0VWqUKtVIcxSG1LXUOSOsY4i/c49hmfQSPczcfZ39h8fvKuTW5U7URmi9Vqf
	9xYC0zmA7ooiZ3G9miPM6olx9FxgzCM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=W6tEwpaC;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-4b80834ce1aso1170625e9.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565560; x=1795170360; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=W6tEwpaC1ZEga9OlK8iHnWaadG+fRM6k9nZq4jk9pv+P06E05rl5XUmFKthZyaPSVE
         B1RJag2gQNBJNGPl21lscHBE7G4OhG1bUrsNx1IEeWAA4/TDoh2TVyhmHmUidKtGLpHx
         X8sDs73Jkxj2luFV7iHyonzC8xASGVeXPCPNAJjfqrkuaXp8fHegmd4rge9ScHJ9CH6q
         w9TNtqOr+g4YZTnwPf7/P0EzECKCZpo/ZKlyUbyXV7HBRdvdAqRwMU+Qs6fvzQphohtL
         2zAq1x6i2CVhGbLJNQ5TjIU1NGbQdyilSA/e+8AFFlvLhIh5X+r6W0tWo8jH7RzS2ymQ
         sl8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565560; x=1795170360;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5OyDtStyAeBedN7jaZpmypaL0n4+GQJgji3UYOQMX7Y=;
        b=v18QMgX/2dIJ3g7qMdRqjIa5FzojHtp8Lua9Yo177c94h9TW6S0pY/zJ8TXLgada3l
         jYhLtpAjfzAnRW6IhuuSpDO7ARbgEBToW7y1gQHRGKelbFgRldtnW6fYVeBwo5BqSKLh
         TOGV4ydQFEjlOePdtH/deTsLAkQoqwRMWDjq52XxPsUmB1P8iq2C5n9O8L21Wil0FcCx
         yef/PXl+z1/2sUL0XlCpS9iT7Mm+J6tvmWSFTC7/GBH7hGVl0Rd+In4y+Jr8OkGrEM/r
         C+NBfpbvMWhSxCIpWga2Mgcm+WcU6jVwyqnXlf5KYwcBIksT2cbVbiihcAN3XEzO2uTN
         vl8A==
X-Forwarded-Encrypted: i=1; AL+hErEnGhGmjaJb7++MQYddJ9A9ZvlGfAqTwP5bjDYN9Qz4/ixDeLsvMV7NU77jB/abdj1gKaAJKNqtpw==@kvack.org
X-Gm-Message-State: APuU4Z/uRFLOyNfVjz1jxf/mzuSWGcuXBWTkb6EX5arlwJDLxE7QAxxk
	VrTPH5dwNPuls9GLKjAC3Ng0tzH2QIzgm3SwK7FVAu4v4am32PoZaavWfHn6lTxSG8Yz
X-Gm-Gg: AYBFou3e89vb7qBid4MTmW40gZLnVNIUdC4lWZ+DcBqIDZIYtvpjZhlDktNenpVFIfN
	NHGnNDuVqlE1RQ42E5ssTPzeaPzI63JorBr8QaUvJa28qiaaUs5o70om0ITPZfCk6Cdx+nRn9Pm
	UiTtRZtj/VkhpsTItLoQRkSUrlIOLXIhBeJw96tm2UF07zl81d30Ov6M44La2PzfsUTbTnAdakV
	0I6YfOu8r4+d5Rgqrq1OcD9bg06v73tFqWX968sbGz8oCfdMh26EIQKc9YdBMcrm2Cz6ip35wXI
	9+bbam2OtDwWqysilmd3RUnv37wCIxqeivQwlEMwxlJaKOkPDZCnX3RsvhAqBZIC4NsBf6UNI+Y
	7TE1Wy6FDbi0gk0DN8H1C172+o6fdVQaKbIQVwaerJQrJ+Q2tJpj7t1Kh6HCeudjmnCWvxMzxgY
	oEST9wU1rT0JUviGDG0HsQkhrHbWmBv2gW82ZGW1rb/FkG9FNMnM8H7L6Tk4gkonubuK3bl/l0d
	ULWu7pO7eQhrRHfQFNTwn3oOWHz2gWvi9xUVGV/Ph32DyqYSLT8N6MvlAiFLgBRV5/qvr0rLCQI
	Ey3QJRJ9Me9AnbWQVQwT5B/dueScSs3hxVHYS5OAMrqUbMbHEwGagpktAb8kXg8=
X-Received: by 2002:a05:600c:4e49:b0:4a1:78c5:79f5 with SMTP id 5b1f17b1804b1-4bb55aa999dmr38995625e9.33.1794565560090;
        Fri, 13 Nov 2026 02:26:00 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2538b9sm244439965e9.1.2026.11.13.02.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:25:59 -0800 (PST)
Message-ID: <fb1d72cf25d10a960da627f6d93a3e041820ed3a.camel@amutable.com>
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, Chris Mason
	 <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:25:57 +0100
In-Reply-To: <20261111151202.GA11391@lst.de>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
	 <20261111151202.GA11391@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 996EB140002
X-Rspamd-Server: rspam12
X-Stat-Signature: 9aknqjkosiaaktqtt7hcqnyut6fd7nq6
X-Rspam-User:
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794565561-764408
X-HE-Meta: U2FsdGVkX1+M8emqz4aU9LcpZ7LsPyWcmRUpRYUt7UCah7gwxHsbjUqf80TLeLFyhQBL4h44dJQpWy69Qr7wS0aXEcBwx2rwXdzvGeYT5rIs/YnGpnuqACPgIozwdetWiF6M6mQyFeeDveVL/2Daq1JXBIOElxHvKmjb3j4lT8vAwlmw7mpxyE7IqEsVZ14YRm/3IWSghkCAYlbLeB/vTtjooDVSPFcbvBR91uGhKem2ZB7uKwAIoCzpEV9qzm6Tn4PZQVjnyAO5JvrrshUMUj92AaiSpmxMgdKdlhR9AbWAhu7nUgXZXKhU2G/jleNa6qTRjTD73oEBY1vKf798TOSQcKiN7Ok8ATv+LqXHQdGrxWoUuYqY4/yYbnUAudeNLLKAZP6zGp85eyv8Q8IbDjtRYYxktT5EF4Mxmt/fkmpFl/Qb1/tng49y+qnbnNGSDioYlodm/zvR6xEAxhxBVD/560agqMkG1X4KWfQLUphaC/bX2iJLvktaQrbDMvoqZIuaRoXf4pnll/qSECzvhJiVXkTIRYX3IGOjJl6ZchMKv748i2Y44Qskfds5lEUngntcfVP/8sryZvp+aa5UgCHBxWkxCFw82gkbEEQIeIchNrMxlSQUxkQ1a8B9xCuUI8GjFm2/+k4dPyrArjhW+xTdmpAKp6Hj27quM5SlmH6Sdkaw6ZJbpEAc5clEXrk3Pe2FxK4LX7lWV+iMDDcKpCJxRCzB/y5vtdoi7QzC2bWRXuYK+auzBCbOdrRfK3DM2Jrj0u2kyVTHabrGzgv+7pAdZSzUgGXi+PEtywW0150zTWu9hkTQlGQNW172L1I2sYV8BxrfDYcnFL+L9I480n2hyhEk4Qa6jyTvUjJdccebbSJtCCRndB+Y6zmwBl05Q1rfCgQGSjyEX9nxcWen75HL+mzK8FWAO6QY05xiBIE8xJmf1C0+MsnJR3TMEkMx87kQB5mU8+KRCob/ELU
 zS8KUP7w
 yzm72Uiw55mt/oAmMGlsUIte0/uQhxPPRt/I6VgfNKdsQoG8kAWxB/DmSyfuAo7sxh55OiRteAxIQfqt6ke1A7hWBEejPbS14qWK4/FXazY1meVnARL5zC9cOJd71w+ZgPieYDghizm5ddBeCZ5x/CK0zh92WFWcY3NHzTd1/h6b+M5E7N2wjvZzq7xI373xIzDRw62tvlkjsirZaNSZNwzrd/awXxmM8zzb8RK/toDyFsDGNZIIScFjVyxoEC2JK6MJ9UrvIKhk5s4ZsywqCtEDzjTGkRhXXd11Mx328cGZ1TIE1fwPoNmsKKsfI2fn8gfoPHKDOKP1DdAD3dhSu1bu3ZYY3X2Lq7/CJGSqjkT6iHYh8Szl73WBDNyLDCOu4nunoSpEhXovdumZNh4Psp7PUUOlMsQPqbr2BRgS8XpRrWxvPFRg9mRQezzRZQVKTVst4HWjeNhx+/cw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Christoph,

On Wed, 2026-11-11 at 16:12 +0100, Christoph Hellwig wrote:
> I've seen setups where people use fuse to mediate access to sysfs
> sysfs in odd ways.=C2=A0 No idea if that's still around, but if so, this
> patch will break it.


Oh, that's painful. Do they use backing files for that?
It's a relatively new feature in FUSE...

Kind regards,
Alex

