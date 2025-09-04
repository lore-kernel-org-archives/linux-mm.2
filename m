Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C710CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 07:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE428E0009; Thu,  4 Sep 2025 03:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F398E0002; Thu,  4 Sep 2025 03:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4E28E0009; Thu,  4 Sep 2025 03:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96B198E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:14:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2ADE95C24B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:14:33 +0000 (UTC)
X-FDA: 83850704826.17.F7BA83D
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10020A0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:14:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756970071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yQFtSGmSmsUqUdi1kJEQZ5Ac2b9AfyFnN7ZWwP46VX8=;
	b=5qFuW5r/xJ3IrzHAeGbgZhqXk8ECsviJr+V4xdgqLfC/oGB4StZGnD0ccnv1xo+0MRtxxZ
	nXx2nDKVqvDbY0RyVk3eSZbuvDiBvc4j1lhB/bDoJh9HQqTy0XbRZsWWCXcbX/LKzfdnEQ
	ZnhpfLqex5p0G4LSWPwrOiexY16aVwc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756970071; a=rsa-sha256;
	cv=none;
	b=KSMXuq4dzHXSE73sK9EcfaeOgjX0a2J8UzpW3jIocQlZfBEN4pwooylHfCw2xiNkLn8tJI
	YorbCLJprcq89moD6oF9MrT0LLe092CUbWVbHZcCTwAMy22/PuPlE0nfqmG7/mNWeWuu0i
	w9CLv9nNVFb2jzf3RQEfwyRnIz4lY7c=
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4cHW1x3QJkz9sVl;
	Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id i2kdusz8gaKW; Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4cHW1x2g6Bz9sVk;
	Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4512F8B764;
	Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 3J62ZvdVNPwi; Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
Received: from [192.168.235.99] (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 220558B763;
	Thu,  4 Sep 2025 09:14:29 +0200 (CEST)
Message-ID: <8c8fa4e8-0c81-4697-b620-696adf8e50e0@csgroup.eu>
Date: Thu, 4 Sep 2025 09:14:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Question: a module for wiping userspace RAM before
 shutdown/reboot/halt
To: Kamil Aronowski <kamil.aronowski@3mdeb.com>,
 Danill Klimuk <daniil.klimuk@3mdeb.com>, linux-modules@vger.kernel.org,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <bfe72929-ba4c-4732-9f80-25cc7b95a0c8@3mdeb.com>
 <eb88e58f-1515-4f51-8102-79cd3c20fea5@3mdeb.com>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <eb88e58f-1515-4f51-8102-79cd3c20fea5@3mdeb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 10020A0009
X-Rspam-User: 
X-Stat-Signature: rkpof46pwpgbybdirfpwfgbt8bxewwur
X-Rspamd-Server: rspam09
X-HE-Tag: 1756970070-555800
X-HE-Meta: U2FsdGVkX1+EmHWTNzjUQKUhTHcV/Rl6XVxVsoA/PER7lrQECwtStRUvbba3WWNcFlD7pTNjLXVU+VfEH4aZsGUtNZWNrYmhIIANd2roF3ZX2OK+0cHUWhA81lX4gAqOlgFbfwi/x6yHFBaw15cgm+Y11zlDrZuU7gyHWoRoksVUeyn6NIsVgI3ztyHLon1F3tas3ymQNwTtqbPOkNOPzeejeb9BAqj/Ec4N+M12pedNIycBhnW0W07Pti6yegswcIgrIFp16NgoINAgTGwM0XFGgThkJBUNGUm4IHBaDJ8iT4ydx8E5ftuYCPaxZtAvA1Y9J8NvVW8A0SHGqz2Q5rqYEYIWN6Mt1KCiudHWsLxKsP3JEVdmWmTw9YchSLHG7yeuQBHR3gX5ThdBdq1pkRJkSHyzFRMm600/Imv3xmr+9dTq8h6AP6WgVaJQVzeuXt5tleyPgDGSkjXuZghiagZJ1UhQ5+oNO3G8KjAvEd5XQGANoWRWwk4i2mMB9W+8uKOWfzCzq1SI1U2eLINO47QCZwJo/Hk6NljxDvYU/WJ2LCBic9DKqp1KZJ2vCZq1ZA59HvVWX0SzcfYQDnmS33TvwvVwS8FVEB6/eGPlbfmDKT80tWCR7qPSL7Slh2gjbucq9lJsOgJB7g05/retawiaga4c+v5ngrQtYKCADt0oGocoiN/zvdcOKM9eRm+J0dN+bQTR3E+bqc/VCo31pVtaZX7kEtumZYguL6Uo7N2Dzckmv58jXeCaO+JxnPXuYQuGWUXOQXLeVqUcre6lyB/cuq+vE6wvc6BY9rHiVSArYZyC5cFZBejIIJFXDIbrB9wFl+Og0WK4WD4BXrQ3WHfGuhcUeGLJV9FsVHYrDbDfGM+LA7PXYhpKXemoqhMUOMq+fIOW0VJ1LKY0Mu6r/1rCTy1WwIiVDeHAjm+2rPICa8TqVgF0i4HW/8EvuHd/AsVzTFmAdJNSS3AzRFk
 BDv1IWLg
 bGPAF+ZwpEY3lmslhWrQOfpJhK7AmVVy9lPnGg/s+d80st1F32yU4eGU2vPRFo6SYPCC+8grDS+i48lLZYr02W1DSbsbI6KHqwr4o/3DMS4g0S3YcyBKNbdBpEzfYZ/OOnuWZUzURMVGj+s+1kNP9MflVSGVJfNZ90Hwug69WWOk4z8lz0qYcWByIgFd7HLo0AILtuYsRKKOiD4pf2ViNvYPMLEH5Uy+Id5EmYxkmd/veDNfgqvS++nRlcz9Lceyw+AR/Lqr9qxxdpQc/OJb/8fX/8FpkfFzDSZojSrYSgvMx5SpTEl1aVhe2BS8qzmKuJuva6TTYTTkgCcQ8jdLUC9VHRspdDOvrde+QLNPvVFvp3Z0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000035, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+mm list

Hi Kamil,

Le 21/08/2025 à 14:13, Kamil Aronowski a écrit :
> Recently, we evaluated the effectiveness of the `init_on_free`
> mechanism, particularly in the context of preserving privacy by
> clearing RAM for individuals with high operational security
> requirements.
> 
> As mentioned
> (https://lore.kernel.org/all/e71bd62c-5ba7-4363-9af1- 
> d9c9de394a54@3mdeb.com/),
> we'd like to ensure that our clients do not have their confidential
> data leaked after their session has ended with a shutdown/reboot/halt.
> 
> In short, `init_on_free` appears to wipe the LUKS secret key
> successfully, but some non-kernel space snippets remain in memory.
> Some tests have been performed by dumping memory after booting Debian
> 13 (with `init_on_free` enabled) and then rebooting to our custom EFI
> memory dumping application.  For instance, the mentions of
> `apparmor_parser`, XKB, udev, or systemd units have been found in the
> memory dump:
> 
> ```
> audit: type=1400 audit(1755156467.556:2): apparmor="STATUS" 
> operation="profile_load" profile="unconfined" name="Discord" pid=967 
> comm="apparmor_parser"r"
> [...]
> 
> partial alphanumeric_keys
> xkb_symbols "tib_asciinum" {
>      include "cn(tib)"
>      name[Group1]= "Tibetan (with ASCII numerals)";
>      key <AE01> { [ 1, 0x1000f21, 0x1000f04, 0x1000f76 ] }; # 1
> [...]
> 
> I:10114000
> E:ID_MM_CANDIDATE=1
> S:disk/by-id/dm-uuid-CRYPT-LUKS2-00b4b79c209a4dcfadf37e310778f583- 
> sda3_crypt
> [...]
> 
> [Unit]
> Description=Switch Root
> AssertPathExists=/etc/initrd-release
> DefaultDependencies=no
> Wants=initrd-switch-root.service
> Before=initrd-switch-root.service
> AllowIsolate=yes
> Wants=initrd-udevadm-cleanup-db.service initrd-root-fs.target initrd- 
> fs.target systemd-journald.service initrd-cleanup.service
> After=initrd-udevadm-cleanup-db.service initrd-root-fs.target initrd- 
> fs.target emergency.service emergency.target initrd-cleanup.service
> [...]
> ```
> 
> Is this the expected behavior, a bug, or a misconfiguration on our
> end?
> 
> If it is indeed a bug, we'd be happy to cooperate on improving the
> `init_on_free` mechanism. If it is expected behavior than we will
> consider wiping userspace memory some other way, e.g. by implementing
> a separate Linux Kernel module as described in the previous email
> (https://lore.kernel.org/all/e71bd62c-5ba7-4363-9af1- 
> d9c9de394a54@3mdeb.com/).
> 

This topic seems to be a memory management topic, not a modules topic.

As I mentionned already in this thread, Linux memory management topics 
should be addressed to linux-mm@kvack.org

Christophe

