Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355C2D3CCA5
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943566B0088; Wed, 14 Jan 2026 21:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F16C6B0089; Wed, 14 Jan 2026 21:59:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A196B008A; Wed, 14 Jan 2026 21:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDBD6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:59:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3206F1A01AD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:59:31 +0000 (UTC)
X-FDA: 84332692542.09.208E968
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3286A160005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:59:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="UmZb/53P";
	spf=pass (imf08.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768445969; a=rsa-sha256;
	cv=none;
	b=k48vzULkR8AfIZ3MqTL6iH/ruGvJ73M3vgs4LLxOaqbfkraeNl+Lx6/juMHyFmk6u7GcWJ
	mj9LQR5cPOy9uR/K6cFGfIjM1eLwVpPIYFV4uLM+OLnluwIXymINO+EXtOrQUk0aCF+FET
	YuYZimXwnlBB7vVhMwdiJo5lVk8XOU0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="UmZb/53P";
	spf=pass (imf08.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768445969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVwRIckv6hP7BPwU6nSlIw7mTHKhTypmIXbL7wDMCIM=;
	b=X7gHokDb/d7bl6ffhhdpxdwCrBu2xaRBZfGE7/cU9pCwg+fbRO1NmIfM2He1r35Q1ymhi2
	1W0ZeV2d/jn/wMtd9CbsFsVVV18PJZk/GLGNb/1AkVwGwfpb6SWyQX0z/KerJ4JDcBHBFR
	Adbth8jEVr+xFpoXymV/abu/F1CGpeI=
Received: from macsyma.thunk.org ([136.144.33.86])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60F2xLwB031016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 21:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1768445965; bh=dVwRIckv6hP7BPwU6nSlIw7mTHKhTypmIXbL7wDMCIM=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=UmZb/53P58ZLyeA6AB8w9g8xIw4S7dqR7SIXG0UyxVRyjb6oH3WghaHfWKX1aEGN+
	 4bziNhDhod9dmddTCxz91s9onzKh/GTRYqwnsonVNnp8UBM4GMr1xXgQN7CYlHR78l
	 7vDeBw9h34OPPXTd98kybcp4ZO7SXSK7k43ILwiU5Lw4g2IA+KqsNfQ7PjlBhna+Jx
	 pjtW2cxK+85iQQKoORnW0D/DSlEUN3ZGU7zBpOJaEi5bYdMyk9QWRKeZ29qyBxkPPw
	 BjMzPp7YCYg6YBECvl/gclPKiTasHwaR1yI3au7XcWYsvJL3wsBf+NW5gJHI3CfgzI
	 fFLs4FO/zubbw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 531EF54BBE79; Wed, 14 Jan 2026 17:59:20 -0900 (AKST)
Date: Wed, 14 Jan 2026 17:59:20 -0900
From: "Theodore Tso" <tytso@mit.edu>
To: Nathan Royce <nroycea+kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: TmpFs Incorporation Of FsCrypt?
Message-ID: <20260115025920.GB19200@macsyma.local>
References: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
 <20260114204352.GA19200@macsyma.local>
 <CALaQ_hq==FY64FcLedWnpgOXf_aT9g2eNyM6BgWwvTv8r0FR7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALaQ_hq==FY64FcLedWnpgOXf_aT9g2eNyM6BgWwvTv8r0FR7w@mail.gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3286A160005
X-Stat-Signature: okpyiwj6sptun3h6br4azhjotjxqa78d
X-Rspam-User: 
X-HE-Tag: 1768445969-431728
X-HE-Meta: U2FsdGVkX19Cp2sLjV9AxoXvRlmPIT7KFTKmMeS3adEZnUi2v7Lz1Nbcan7+JBrKonllDnXLFCP3LNrXmO+4EuD3Wd1kY1nXKglPQnm8rykTuFYzUKGVz1es8cT1M+McQW4yWtLVHJ8jvM1kXt8Ovu6LPuiGYCw4lxlVL7rhH83d61J8WQDJbFHGIdpo3X5c6/wjv/NP3xY+vhoyaQEFQTvsYyVGI4TVnNnt4EjAj6+0jPqioDWaehYHBBUXKo9yidzCmHa99wDDzOK2VKUEWbqwn0wsmLZDPaZN7KS8rHN5MjwibHXGJKqtkHAIGpqeAGYzfyIEpCVtXRy2Iq+YH1Y3bxUH5jfokAlpfPnfmvS4f7Dgw8EKgrL65hA5GUT98JRtg1i1ZDLXkiNHYqy6Y8hrpd7DEHpXpF27jtc6PpHnGDa+mPsvf5a7qOMM/KLm0aIxm2XXMk0IXUiFo0lL000PvVUJA0DgZrnZx3W863E0QtIC1+YDUYpsp9fl/scH0leEMQ983+z4QAtnRvVU4wb+B7THT/ze7jimiv/2CRRpSzzuSfW6zvSh31HNIIIpvexEEK4dqvHbuzM/pFuBVe/ibc4qEA4RJ+++uwK8DGPRg924qhb871z2DS1pa4+JQYm9vytKIJYg7c96yVN8uD72cGO3n0JabL+G1mOEn9AahsW1bga6YgMB1uZdp30tXoR0PA0QqWS+eFPIpj0n7yhTbM7oWup+5BVMYFchDIpsPlCCGrdFVMywuTkfi9TwUdnF5+thqQs+5Ih5tZcwzMF5WA6Y/6AQmwo5sHEgzcd06G7f6e13Q7rfp/36kETmIPbeWahZT7YG9rEf/INv31V4iFuuq3MUnhHlI7rUJ59SP+7Eqh9J+cIX2G/YgdZfC70ny2RI/0RiR42qzPsB/xrsqzx02p3ZtmRop9LgPJ6cjZJjRCPp7zGkYVs3t3vf21ZZ0eII4YgZJPQj6aO
 eAPR9SpQ
 w9tiL1T02iiA/w5aOysRYo/v9jwnhL/oMEiIeRBHLCOOLJ56GcodkdNvbdqD9Li1ImjaROCBFruqGRS1p8S8QquNr/zI+7xK+CFWgcv2S6JgUVyUpfXQgr6cQVMSEGQe7qxSVg4d+j511QSgbmSS7KuKn5DNesJLF47qWTuQvbBsvVF0VsaCBVR6HWLFLK0+3x8Rd3YzXiy1L+f+lyteGOda7F54nRxhY8Ww5R/8Ftrqp9Iak4LB21YKMKwYICeK0mMJ1PADu+fkXIWvQQ1/tY2taowCHVpgcyf00F0/vEi9WR5s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000034, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 05:32:22PM -0600, Nathan Royce wrote:
> What I like about fscrypt is it does appear to be session-based, so
> compared to LUKS, which just needs a key once to unlock it for
> everyone, fscrypt looks like it remains encrypted for everyone except
> the user that unlocked the path for that session.
> So if a user account maybe shares a path within their user path, with
> another user/group, a misconfiguration would supposedly keep an
> encrypted path still encrypted to the other shared user, even if the
> originating user has it unlocked for themselves.

Actually, no it doesn't work that way.  Access to the fscrypt key is
on based on the keyring, which is session based.  However, that key is
used to derive the per-file encryption key.  Once that key is
available, it's stashed in the in-memory inode structure --- and if
the file's unix permissions is world-readable, anyone will have access
to the file.

When the user logs out and the key is removed, we will iterate over
zap all of the encrypted inodes and dentries; see do_remove_key() and
try_to_lock_encrypted_keys() in fs/crypto/keyring.c.  So if you have a
ChromeOS device which is shared across multiple users in a family,
when Alice logs out of the ChromeOS laptop, and her brother Bob logs
into the laptop, this is the mechanism that prevents Bob from being
able to access Alice's files, even if Bob has a zero-day exploit,
given that Alice's master key is only available when Alice has
presented her password to the system, Bob won't be able to read's
Alice's secret dairy.

The main advantage of fscrypt and LUKS is that we can have separate
master keys for Alice and Bob, as opposed to having a single for the
entire dmcrypt device, as in the case for LUKS.  The other advantage
of fscrypt is that Alice and Bob can share the free space --- and
indeed, if Bob is logged into a ChromeOS device, and the free space is
almost exhausted (since if you have a very low-cost ChromeOS device
with only 32GB of flash, we can still reasonably share this device
across multiple users, since most of the user's data is stored in the
Cloud), what a root process can do is to find other users' Chrome
cache directories (e.g., such as Alice), and while the root process
which is managing ChromeOS's storage space, won't have access to
Alice's file contents, what the space management daemon *can* do is
delete the oldest files from directory that happens to be Alice's
cache directory, thus making space for Bob to cache more files in his
home directory.  Of course, then when Bob logs out, his cache files
might be subject for deletion when Alice starts using the machine,
even though Alice and Bob won't have access to their siblings' file
data.

Cheers,

					- Ted


