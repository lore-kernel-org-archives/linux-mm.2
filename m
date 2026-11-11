Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8FE606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Jd4UA/DV
Received: by kanga.kvack.org (Postfix)
	id C68076B05B2; Wed, 11 Nov 2026 16:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18E66B05B3; Wed, 11 Nov 2026 16:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07516B05B4; Wed, 11 Nov 2026 16:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86E206B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:13:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1906E120405
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:13:34 +0000 (UTC)
X-FDA: 85424089548.25.E8D7B89
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2F26920004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:13:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Jd4UA/DV";
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794431612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IrB6l2ge+kT+1cpfqcWAfjg5pGysZEjTO7L0UKFQf8=;
	b=4R1FTvMjE9hX0BiM6gOIf7JR8ueu3CVPADBl1+cSPw5XXlZVwmdoyX9lJENpjc/q/oNkAH
	cIVLAysQmxb56YjFNJ6Qnv94wTP/uAzwwMiYphcuOTVKVW2B4wfrpTXNRAlLtH3BXriPGJ
	qfv2WLJyUo3alywmXcTTtM3uYcRTkyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794431612;
	b=v3wtfUY7mj3JYmtrf9nAdTdBW6NlPOHNUsWRQZuf2UStecGwtnK4LUMHkmacH03hQl+2qm
	DUK1wARXHJ4dRllhgNcO47hVYkTtbDHI1OFrHjp2KUE0CRrOTVe1TAcFNuLOxxHl57FmmD
	q7mbuinV+1KHhcHX+jjpP+hNaWv7zzI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Jd4UA/DV";
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-7d2d18f1bf5so1822915137.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:13:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794431611; x=1795036411; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3IrB6l2ge+kT+1cpfqcWAfjg5pGysZEjTO7L0UKFQf8=;
        b=Jd4UA/DVA0mq7z2ivR6Dt9w/MwmFLQYaDwe1oGEQ6MyJzVvuFNCt9TlVaP4jB6Y6EL
         mtD4dEdYbYTUruclGNVwkDva8MI4XGFEg1n47bIfXe3LTFKwqawsfRE10jus/KvGsD5l
         V8Dsdlw4jRjC4A9ouPIoFcRM0SyIeRjRCy1fp64ZLrcR+mEhgg8AjeUc6Hi6ZemxlCOp
         +h2O2It6TiLkKv00wn1FrMNSuairfQjL9fPew4AJpHwBCOwmPtwkx3oMKzMu3ckObqD8
         FzlY5KfTt6wnaBebuHqmtdwUWFKTOnH3KYTcIAsfUcGVOaK+vEl5sn6CYY/ZKq1q2C8H
         sGWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794431611; x=1795036411;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3IrB6l2ge+kT+1cpfqcWAfjg5pGysZEjTO7L0UKFQf8=;
        b=rBwiy200308CDt29ecrWzbbsSnpbVIbJjlKKnHD0J+kWPyZ0s1nrmof1V4fRFqWrxX
         sJGcKdXYFW1UbxJ4u4OBt05r8MskSfnNUGKReXbP+Qee7OhMAWzShns32+LpyBMsFIdi
         Vvbowa9csTM1FybVwkfOY1J/wsMKox7pxUFtoDi18KwV29g0qsLmJQ3NJeK0evfVtQeT
         jg0aCtZoOF5w7XMrgzGEZ+g/LL/VQRdDAjuq8f5lTfYB4UI7U+T/mtorFlZ8uN/FKm64
         6u+1k/ojJNq+ZZLeoesga2NwVGtkFz/3r5pF7Q+rPVX0722rPvRpKpNmphurSmnswuN/
         7F3g==
X-Forwarded-Encrypted: i=1; AL+hErEtkQcAo5ir+RVhaLFtNJzCoEy+IGCNZqQhD0B8rFPvSk058B/duZuKM2Ms8J/K7GnVi37rpuGLlA==@kvack.org
X-Gm-Message-State: APuU4Z+uf0vlUWKbP7jgAM+Zic/NN6CJft0G1h7KvGxc0k+h803fb+N4
	c7IkZqNlFXcbCa1mWIfcDh8GkCz2t9Jbh7+Tgf5n0sQ39xWd2XQH9lfj9sJk6N4iFw0=
X-Gm-Gg: AYBFou0tjyDON6urwp2YWBnI60J+qUlNBjEbKhYcX0txlV3KCVH5MiMEtaPgVKn+PSi
	R2DO9Uihxsq30jO9ul714XJJhUUmsf+rONBZ9J+r2Ys9i/h+mT+u5RzLoWNZQX/2QTeK9XMzEog
	FwCvDc/7ctDRaLMYnDNW5FAXM8ykW82h8cJZC8Fg+zPaEjrYh43UGDNjp/3Hdck6uOQvhaIld/x
	sSzmmhufLZb+ms9ijx637UBuavtBX9e92deiGS85XcQzoXBsQavAHBYjp5ecuESxY7wrdRr9U9y
	w+5qonFLk24nGPqWJcc5XP7DqWsMlHDD7JyylTCfBIkZ3EZqAF1LMpdZNjiXY+rUCASAmyOIi8H
	pv9PO+SqwrgVCbU9QRYs2b1tej2IU5MV8S7UMDtRPvSFqmu8UszxpprGhTeBl51fLWpt4nwpPwL
	bEUeGMSBVzpLcXH0HUOJ7wLBgwUH77LyGKne20qQwDbs/npSzgGkplEUJHdzlQW0jOaYpzKCjM1
	hkpMg2aCEV4TgT6mDpFXrGzjA0Aro2PDGre6sBzJ+x5qct1HfDecshiZYz1ZFsBibGVuEqiuVxp
	Zz35i5MBjy3dmCcAyeO7C0CFB+49sWFcSwksjsEkGOs4GTlzdNZ+a6SfOViv5RoIL4qrevoOqJ2
	pSO1IQ1coufwmTPAL5JkExgEpKLnl
X-Received: by 2002:a05:6102:2d0e:b0:7cb:bc5e:7d9f with SMTP id ada2fe7eead31-7d4fb2577edmr1659351137.11.1794431611247;
        Wed, 11 Nov 2026 13:13:31 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d3023838a9sm4907083137.7.2026.11.11.13.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 13:13:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 16:13:29 -0500
Message-Id: <DMSOX12JE1BL.33ASGRFO04NUM@soleen.com>
Subject: Re: [PATCH v5 5/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport" <rppt@kernel.org>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>
Cc: <linux-kselftest@vger.kernel.org>, <shuah@kernel.org>,
 <linux-mm@kvack.org>, <skhan@linuxfoundation.org>,
 <linux-doc@vger.kernel.org>, <vipinsh@google.com>,
 <linux-kernel@vger.kernel.org>, <corbet@lwn.net>, <dmatlack@google.com>,
 <kexec@lists.infradead.org>, <pratyush@kernel.org>,
 <rdunlap@infradead.org>, <graf@amazon.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-6-pasha.tatashin@soleen.com>
 <179439592041.425130.6098227055493441109.b4-review@b4>
In-Reply-To: <179439592041.425130.6098227055493441109.b4-review@b4>
X-Stat-Signature: nqy1ztzojtj4eni51194swbr8jc1e341
X-Rspamd-Queue-Id: 2F26920004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794431612-782797
X-HE-Meta: U2FsdGVkX1+px3DZH6epwFvXHmCGPgUZlcbQhzWTFzBQ5UUDo9GMiXmq+vXSA2S9b059VLNS7mjqKYy29EcQtYnS8aHN9DoJZJOoV3In0TFk6U5X6DDz7Yf5s5G9hEe1/JIQk9wiaVVX9FsztTJ5xK/Pql+iNXMuhTwV3fZpiw+cp/8+DY0zjBXSp85JOH9At8tzWmLVnrfD2kxe0vEB0bYOkVSmrKHqfuT0zbHX2j1nzuncrsYM7Fs9s1izWsPCKEltzSRDXXjjqpYV4rQVY7VIamC2x8f6yAaPnStIut8bx/JGEM8aFoDdZy556HQ1vwoiHcce/lYPs7MvoPEBBXxOMKCaylxLTArSvlt0dNRiPqSMvExIUBVwA3eZ42xRiu0YsDNrTIg6Hdcx89YXnR2BRcP83baLXb64w8eqx0lLSH9xGZsEX3VLWdHjf5pX4tVeHtIAtu04v2l3m0+BC0ZiDSl+EwLzXUZIcI3ChQ6KucL+0SyAJVWQgkSirukRqmGF0iFiMyIToNTbES8i1IJzBgLK6wV4uKOJnPeXR5lGnk2CqVLRHt7RdyzUkNrrmYk91z3JSX+15lusjW0So/0TI5mA4UBzuZAHdNDdDGpzFRkvt+z+jSrXajQDVYQGd7We0/uPEyBkA0YhAzumuQLm5loI/M6yXVWZgKRJ6b1lxFDt54tTR3wXakzjcozCT1kNQhsK6fcXF8yoDfDJgu9ZVJ1Nh0s7O6bXJi77EtABKtIH964oY39QsVDyGH4EvtiRBQISmKsuqEc89igF42O7/+ixQvsIrw3hoMkXeVukbcPixY0TW+sj/18KNiEmhcuxUXHsPWIO6O0bi4C/z2s1HruN3jzI16Np6pxvmR5/L7AWHcYDdNKURCDCPyyuA0qkRf4VXYAfepcIn34GUi2bKDm1G7DM3+KNcKKrbV1aZaiaaiTVXw60FcmMeo8hS7MRcm24x2BBoSFrBEw
 xvWE8Tm/
 oSp/fhy2Ynx6yiQnQLQQzKKnRAGOxRl6zf5zEJOaGoRmW36M6DqkpPx+9zY+49A6CQ8QzlNdpRpMo6l0RTgrh9qVDUBhMbfBsq2viN6t7d9QHYVmFAbN4KRt26DYcQ4NLxS6n7hEyWIGphXWlVMAul7Ib03KHplkf1qC36lj7jK4pSLLdCKyoKtNl1pqwBbnZMQfeqnTRb5XAR8xzX+z/4By7mH4kuEGYX9u0vwCXollmkl1eikpDh8HNTWN9QNwq7j+VfLRMtaEKJWVzQAg+3dylZEqKRKJl5CmI6rZ2r/dWsKRu8VvUi/t5BkzXmpEH2R5O1Ps1BPTusrJog6JzAdEbvs7nXGjaVT9xX1v2uJP8dsJWSM+N2ggtJzRNnQ6UfclZWgVeUB+mawhihVLsWT0q5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 6:18 AM EST, Mike Rapoport wrote:
> Hi,
>
>> Currently, LUO sessions are frozen automatically only inside the
>> reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
>> iterates through all outgoing sessions under global write locks and
>> freezes them serially during shutdown. On hosts running multiple
>> workloads that quiesce one by one ahead of kexec, userspace needs an
>> explicit per-session freeze point so each session can capture final file
>> state under its per-session mutex as soon as its workload pauses.
>>=20
>> Introduce LIVEUPDATE_SESSION_FREEZE on session FDs to freeze an outgoing
>> session early. The ioctl runs .freeze() across all preserved files in
>> the session and serializes their metadata. Once frozen, no additional
>> files can be added to the session, and subsequent freeze calls return
>> -EBUSY. Freeze is only valid on outgoing sessions and returns -EINVAL on
>> incoming ones.
>>=20
>> By default (flags =3D=3D 0), session lifetime remains bound to the sessi=
on
>> FD: the session stays frozen while the FD remains open, and closing the
>> session FD before reboot (for example, to abort the session or on
>> process exit/crash) unfreezes it via .unfreeze(), unpreserves its files,
>> and reclaims all resources. During kexec, already-frozen sessions skip
>> the late auto-freeze and are published into the outgoing KHO subtree.
>>=20
>> With LIVEUPDATE_SESSION_FREEZE_COMMIT set in
>> struct liveupdate_session_freeze.flags, the frozen session is committed:
>> it and its FLB dependencies are immediately inserted into the outgoing
>> KHO subtree via luo_session_publish_one(), and the session survives
>> close() with full ownership retained by LUO until reboot. Once
>> committed, closing the session FD (or another session failing to freeze
>> during reboot) never unfreezes or unpreserves the session, allowing
>> processes to hand off preserved state and exit prior to kexec.
>>=20
>> Update the uAPI and core LUO documentation to describe session freeze
>> and commit semantics.
>
> Please teach your LLM to use shorter paragraphs, focus on why and don't
> list every implementation detail, but only important ones.

The first paragraph explains exactly why; however, I agree that it needs=20
to be more concise. I will address your comments in v6. Thanks!

--=20
Pasha


