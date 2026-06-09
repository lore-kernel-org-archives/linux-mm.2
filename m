Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70D7CD8C85
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 06:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB666B0005; Tue,  9 Jun 2026 02:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993046B0088; Tue,  9 Jun 2026 02:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFFD6B008A; Tue,  9 Jun 2026 02:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F79D6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 02:08:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C0921C250A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:08:27 +0000 (UTC)
X-FDA: 84859344654.12.5FFF0B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7298A0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:08:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJJDZ+ur;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780985305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbOz6L7GY6LUh60QQjLA14yLmOVQNSrkAN1JuAX65lY=;
	b=o4lW1b8hG96qScaDeXS1teMGaeCSfHIpik4sSLKFpSJFhxLd252lwhRtLsl5Y+pkFeNbHY
	E4ZbARHbJqVtEpM7hjv6ekJn4XSKcsXIfRs3on6QTghrBTGOCaoyccR0+o9kxxbqs86bk/
	mxoh6+VG0bHXk1NWb+x5jyHJ9oeI3+E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XJJDZ+ur;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780985305;
	b=dWyygKXn8F1BdU9czny+nO3T4D9PzKR5yxtyLW8I6CCSOWVFST3fbl1oSev7Mvk301RJ44
	D1g/mAHaWIW/jeAIf34ts0Yu/KDuvi15dlV8yUUNrr2cThaLlPJbsVvNSAVfqlI1VSY9gt
	zSkuY6DdV2UKgecOqF/96X4NL1lRGb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780985304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lbOz6L7GY6LUh60QQjLA14yLmOVQNSrkAN1JuAX65lY=;
	b=XJJDZ+urmvq35XyvnvzmcDs0ksHm9aygngKtj1VCy8eBDMS0AdjYuQ86V1AYDD4CpzBdGL
	QMWBFLhIem8EPm9Fc7xXHaefT09LKJa9KfPEpcymksZZi22UGYtIgKMbGuTR/QHruBXl5A
	mXsY4a4HVbhmOv9bWnHVwl/SvvZFLwo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-144-CiiFh2z4PQSasqSREsKifg-1; Tue,
 09 Jun 2026 02:08:18 -0400
X-MC-Unique: CiiFh2z4PQSasqSREsKifg-1
X-Mimecast-MFC-AGG-ID: CiiFh2z4PQSasqSREsKifg_1780985295
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FD03180065C;
	Tue,  9 Jun 2026 06:08:15 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (unknown [10.44.32.189])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98CB719560A2;
	Tue,  9 Jun 2026 06:08:07 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Jann Horn <jannh@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>,  Christian Brauner
 <brauner@kernel.org>,  Li Chen <me@linux.beauty>,  Kees Cook
 <kees@kernel.org>,  Alexander Viro <viro@zeniv.linux.org.uk>,
  linux-fsdevel@vger.kernel.org,  linux-api@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-arch@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  x86@kernel.org,  Arnd Bergmann
 <arnd@arndb.de>,  Andy Lutomirski <luto@kernel.org>,  Thomas Gleixner
 <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov
 <bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>,  "H. Peter
 Anvin" <hpa@zytor.com>,  Jan Kara <jack@suse.cz>,  Jonathan Corbet
 <corbet@lwn.net>,  Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
In-Reply-To: <CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com>
	(Jann Horn's message of "Mon, 8 Jun 2026 17:02:06 +0200")
References: <20260528095235.2491226-1-me@linux.beauty>
	<vealb52tv5suireenkke4lul2l3wbnaul2rp3ea545ly5wa5ty@yk3aksvp7skt>
	<CAG48ez38OEE8ZPLyU6nr9=cYx-hMsdoh5WRrv-GMZGMDKyyOTA@mail.gmail.com>
Date: Tue, 09 Jun 2026 08:08:05 +0200
Message-ID: <lhubjdk1c1m.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: e65ChdFYnyDGG6E3bfO8BpdMt2GPpZXVBK7sdeuLm-E_1780985295
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7298A0002
X-Rspam-User: 
X-Stat-Signature: s1se43qhrqgdz5pdp34eznfsf5o1zxyr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780985304-315529
X-HE-Meta: U2FsdGVkX19gSZby+kimDHjEKHnAzw3StT2ZUzy8ED3YYa8/afNY14pWhfPTd5+G8uHEnlYHB5jq33kv3kY1fHIGDVV3mGSY64XrGcDfJO4XFmw0Zx0TLika31xdpJWx8VFudR0FAJ1dAfKqySm8mfCa8vsmjE8OVzuRRzAsRKY3Tjk0FeKc2wzPrJA7VFhKHGVSQRzb3CGNKoBNzKqlsntvJ/rX4SyA5cXEr5LMutMQsY3PNfKLW9NyU5Hm8Aq4SK5Y6W1rGBnXZmb6EBgWqWDccgkwDa6CYqU/Cxs0M15meWf3L1A+j9jG0KqTYq9nX29zCbBFW2Xx7Md/4GFVD5MYgOGpUQzfs6sppgNH7L8r746QxQ6MQ41x6F6389KTbd7Z6RgJIJMLi3sv5bH2fsbNGwXqDc9UHMxsaKu6xADIP7B8QgBLtzvX3DmcqO+D9Ri9XhJjv4fyR3mgjceJ3mDt+8xUIT8gZpzTzXdgkOJ/Yr3jpsQ4OgyFio+RFqKdAMjx/4AqMWZjZesRXUaxLtO/mc43LjboKykyA2ikLBITL9G1iLO4CE9wKpx0mDAAEseFSWLdhtNG+RAAA9CmoIT1uTd1dVV7avHhniZQ1HKsLU9IjvixuW4xQ2JK23MBY8PVNgzzmJNsfqn/OM/WJ0k90keA2uE3q+/3DCCf9L3YpJIGIgs52eWgCQCDXUypBIt2GG8NUFNkXrSVsmlT/inhPXcRFpZZjRlOpwCxULjYbE/On3CNDbMFvvDlUILHIBBEp1eiVGFh3j3YFKwkOcGpHzU7u7FoYV5AyQHwfNhsUDoiJMcj6z6BClIBBotrsvgltt8owkr2cyIIaXoDcVQMLMP0JTceLC3lY9oILN0fcWTS494onrhUAebt7c9YOOos/6+R1yWsDDDG8Y7It9/Fifs1vlSUkRATyfYaL5y9FJe9nhHV28Fb9VKvx/FyJsIRvKG5AnUA66RtZLj
 DJkSVjl0
 pnQN25STm5lQ5cBCpBrpFuj6PiqHu62OHF6qsO4+a3mYGroHRuQYovRksxAB5u3TKN7fstx56VLOE/Cxu7r1zdUbS8+lic8QjL2GPXjs0+2HPtx9KK7GCkQVerwIru9vG7qnPy7t9n9Zp8zBhvZ0BiJ13E2UnPxzTiGb+abj+3g9ZrOd9kbX86IHG+49Dt3qFnFMlOduvYp5WJ22mNKNFm6KuSt0rIaxur7XKtW3DFRvpgex1NdeLeoM01iS9aOlc+Za/ZrStKlZxMtijb0k5Sa0hCP3EQzsKj+6f0NJ+FOFBVRBftJiYX7MJEg2oJW2dgqI457s0/wY8EIGJzx1+cvp7TCEdZuKR+Xg05u3iIcc4EyHC/dg52hXYtx9c3em2OG7aYFjHc9RONyLqZEsbDBbsKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Jann Horn:

>> Per the above, the primary win would stem from *NOT* messing with mm.
>
> As you write below, I think we have that with CLONE_MM? The C function
> vfork() is kind of a terrible API because of its returns-twice
> behavior, but I think if process cloning with CLONE_VM|CLONE_VFORK was
> wrapped by libc in a way similar to clone() (with the child executing
> a separate handler function), or if it was used in the implementation
> of some higher-level process-spawning API, it would be a perfectly
> fine API?

No, there is still a problem with SIGTSTP handling because we cannot
atomically unmask the signal during execve.  We need to unblock SIGTSTP
before execve in the new process, but this means that it can get
suspended by SIGTSTP.  Consequently, the execve never happens and the
original process is stuck in vfork:

  posix_spawn: parent can get stuck in uninterruptible sleep if child
  receives SIGTSTP early enough
  <https://inbox.sourceware.org/libc-help/2921668c-773e-465d-9480-0abb6f979=
bf9@www.fastmail.com/>

More on the low-level side, it's difficult to make sure that execve gets
a consistent snapshot of the environ vector.  Both vfork and execve need
to be async-signal-safe.  Any locking or memory allocation (except for
the stack =E2=80=A6) persists in the original process after vfork returns. =
 The
environ vector can be large, so making a copy on the stack is not ideal.
It's even harder for getenv/setenv/unsetenv implementations that use
locking instead of software transactional memory.

In general, I prefer the vfork+execve API over things like posix_spawn
because eventually, you have dependencies between the syslets, or need
control flow.  This introduces a lot of complexity.  Conceptually,
vfork+execve is much simpler, and in many ways quite safe (even mutexes
work as long as they do not need a correct TID).

Thanks,
Florian


