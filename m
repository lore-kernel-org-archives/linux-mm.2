Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB626606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E+DW4KoP
Received: by kanga.kvack.org (Postfix)
	id EAABC6B05B6; Mon, 23 Nov 2026 11:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E82436B05B7; Mon, 23 Nov 2026 11:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC11F6B05B8; Mon, 23 Nov 2026 11:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE0656B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:20:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 601241A0921
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:19 +0000 (UTC)
X-FDA: 85466896158.09.24E2D5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B8731A000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:20:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+DW4KoP;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795450817;
	b=tbyKadq8FDyCe5VRWPAI21QyI7jbomEfz1Fy2QMZNJpTdpt6KraS+dEkjcgpbWWKBo0inv
	4pu6Jv22ey7a8j/lGRLbPV4mYdgJx+UW9apgesUTJmP0FqCtg6ILcg9gy6nHJghU51xPWD
	D9BBmG/coIt9PEBI5g0r24xj/T7PD1g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795450817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMGSS5PYQROX99GbX8HvEIwUcXDerAKEsLEch7k8S3Q=;
	b=joUy40od5bMW1+zTnNu1yD3qsYKBqVb5bHp8214fNtfLW2XtPHh538s2Y1S7PdYLHRQlBU
	04DEYoErnTNSpzu0dPEZHYrB7/GmlqZ0AO8hSiN11c4aMCFPeKOhEKhcRRfd21z2OTktl8
	lgca+0jcRhqm0qE6RlyFSewCbKseFIs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+DW4KoP;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 3060862333;
	Mon, 23 Nov 2026 16:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6B941F000E0;
	Mon, 23 Nov 2026 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795450816;
	bh=GMGSS5PYQROX99GbX8HvEIwUcXDerAKEsLEch7k8S3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E+DW4KoPCdkP0AQy8Eb0/14XBngcdtMwfMbHwhhIHUm50tW7cOaw/xqxK7jHRXVvA
	 h6xW4/VFgnzqKgIaQzItf4e5tWtRkfeo5rxwfdP5kmIRq52BJG+Cfxbn8F26657Vbv
	 bXLwCI4mAw8CMP7UnG2kbaWYiTDo/AEU9mEpPkzvjoFO203JPq8ZSSlccM16/paxWa
	 e4WbfLjHRcHYUHgcj3QyL/+wmyhqHwMCzQ1olCaopaSvnOe5wGmYmz3Ab8BIDg76Uw
	 Z8PS45zGNNQRJqS9ctOuLCzPVW0OH6XgNAGxzR4QiA4WTETKNhkM1EDbYY1MaTvT3i
	 mCam8UCZ/+adQ==
Date: Mon, 23 Nov 2026 18:20:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awRnvFNoyAS8XRwQ@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
 <awOUJCbB_j0BuHvo@kernel.org>
 <awQ-2UtDRtrv9fNu@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awQ-2UtDRtrv9fNu@kernel.org>
X-Stat-Signature: 8iu7tjfcj86eurg1cxqq4nbwfnky7hh9
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8731A000E
X-HE-Tag: 1795450817-899736
X-HE-Meta: U2FsdGVkX1+kWvqZS683YTpjgOIkrcdmKnMfxvq8PYRZEvrw2YBHhx9ga+KCYHraxjTsKXnmlh+60lHVgN7A+pUQ24x5seP0AXINp8kEVcjju0j2aeqjEHnVEvQ+WrJsbqyM5RPNDJDc2EfqMExQrO5Up/yWR1yNRezdZCEm18ZxrWtRrtNvI76l87rKHDikoYqhYrf+ptVbhn+kXZ8Ep0hdW2h3TG2ZHG3gxXYAwXOd2E1A1CX7oVG1JRur1LLWsJ/t4ILDMjBstL81Q5OfSTE6r5VNM5FJzm2860Lg4ax9OYHfTx6+5WJ3MkOK4+jWBzwE9zp+PAJWayVRnQTc532OSbao3CbKfG11xLEewX15E1+qK4qNVAP4ey+n7WeYLBP8Ilea9C3uRfvDJxttJKQHEZnL/Lt3aj5TSjNh5daeR/1vsdGQ/RExH/zwcdzWsVWqSG5q+I53AdZ19WomTy13YysWlk8Axel7Pn33SaXfdKYjZai1moDf/8FiqsQ1OIVy5e0zgO5Kp9InF+UWYp3jBWT24BfFEzaETG72Ur2UTSDxJAx/C2ecnmI33bdSfPqbVRZVanp7yF/J9fnrpGLzZCDDPoVpybu5rU0QtOBP8DbgStjLwhF+/GYHpbyuip30m4Nodt5xdPqwlgCU3tBPdKqNd3F8MCJJCj1MJW3PxwDN+YOcikd6CvheTBn5YjCaUOSDclZeLsF0wD6OYKjC6MNJ90veLjkMXmD55Hxr69FIDX572+QvE92+VrZSEP5dJhLopD+hUidA20SdlCTrFA4mV/KQQJWMfYuRdGrb0yPStXPFeVBOmfmTv9ftg8VgXZ9+ek/sbf5/pGtsL0MAM4POz1YGUClpiQT0RbrbXiJwIFu7ubbxT9Jg9uSEMhTelb8w1OB1miRerlxtOwK/ljNts9Kbny9zKNdmexCxgAAT9v3YY/jBDWDQ0p48LtbFjru+R3QbkE3pNF4
 vKpfbGqE
 A2C/O88rJLaEzgrwVBu9cZ8HzfoRfBfUm/2pNT2DyAGmc+Smv791WrPi4W8ytI11wwLzC1Zq8L5kPR6l4A2Lz/inYVWuw6Dei6Xmko+gSoZJ3FlTo9ULj4yJqhV7YfXsuwrkWDMOMfy0IHhXqKSbIafvTJztD6bVzKPlAgyl7yxKeGbngmdu6rRz7uWUkgNpzotLoB8nbgXXNhuKgl2leAvANJx4QEth7jfjhl2CdbF4FC3Tr4PLCK+SvWo7tLtscch9n1rhi+Cnw4kkL4R5ummGnFkFyqrUFiaefJSwoLjjiDfEoijTE8x93F8rDPBLsGDEO1bJKrmNqOeL+IrclhH9R9kJldo9a+f0iecImyKCAtSN/jn16JpT9s6PhQYzpcvvwQ71agl4n8Wmguqfzr/y6+ZuqhirzO3X4rYRVrZ3Vq0t3skTm2rGJcquzApfEpHahh0WmxBXtBjxgYiMoi2o0ubzpIhM4njTD+BBxd/okoq4kAvJZS/nsnaD+ofLoIvDCyies8sQ3XBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 03:25:45PM +0200, Jarkko Sakkinen wrote:
> 1. It is possible to use file a instead of syscall for container
>    creation. This allows to split the framework in two pieces:
>    the core piece and the driver piece.
> 2. It would be possible to create Linux Container Module framework i.e.
>    LCMs. I'm underlining the technical side here, not sure if this makes
>    sense or not.

One more viable option:

3. /dev/container i.e., replace userland_open() with a device and
   appropriate wiring in file_operations. It right now has only couple of
   flags as an argument.

Has advantages and disadvantages over a syscall.

Br, Jarkko

