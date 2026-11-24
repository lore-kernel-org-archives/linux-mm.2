Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFCE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FpgAv4k7
Received: by kanga.kvack.org (Postfix)
	id 9D4D76B05B2; Mon, 23 Nov 2026 20:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985BE6B05B3; Mon, 23 Nov 2026 20:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874496B05B4; Mon, 23 Nov 2026 20:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE0A6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:19:39 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B40601C4526
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:19:38 +0000 (UTC)
X-FDA: 85468255236.12.9341259
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0F1EC160005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:19:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpgAv4k7;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795483177;
	b=6wW4VCRp3BhD02yyCFXiWRbZtT62mE1E8V7bZ26C+/CnU3FEw858khlEo2bTjq03Cv/wdd
	9f1wMMON5gMacwxMADn8S/eEIY7tJMp5/I3+ShWpespi0K6JQP2hr3MbynxQgBFW75xR/T
	HCp/wAGi6P8viRDkkQhtageXChmmAaY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795483177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqTFyo2p9NHEAlnK/bLSQvmwgpmG1lbV/jfBCx+FnUY=;
	b=29CV2y8nm+ZO94MKcV3NuS+aPSSIp+0x7OhzVYErVjxIwsowZsqBa6jzrgvImcVzTrqyre
	lZ1k4pT1rUrYNno6DBmHNN3zwhKUoYgDOAIj+0qkCJXwMYorohkydFI6/6pFAOSf2ARgAR
	1BUIY/Jehok9bHeeqj1QPVAEdBbmUfQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FpgAv4k7;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 6FD8260207;
	Tue, 24 Nov 2026 01:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5602A1F000C6;
	Tue, 24 Nov 2026 01:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483176;
	bh=TqTFyo2p9NHEAlnK/bLSQvmwgpmG1lbV/jfBCx+FnUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FpgAv4k7DgTjREaE3kro0UZn3XG5jzdbXdwUqCiY0H/lFIyxXhzxKdUjGfewSzdRJ
	 AQv/xvoOKqEm+aHsUnmXP7PwlobCZQd+uY7uHAZTyThrK/+fCSfOgXaaTDk8zdtC9V
	 uZXFUa2oVY74if4PpQoYMmsWfcoAzHvkyUqGZf4VbXQZrql0SqEm0LqqOBNr8pf3Bk
	 ChIpk1dvOQ0+H9x+KeXwb+c+0oJ0CqAHmhymiEOisQGz0RmR6YY6DWkqMqZDxnuKqj
	 pQYz9w2/bOPD5gPpVIjBUGn/+/+YICibM0voCPOItGdwtQz84KoY3IMZqMK5FJtKgJ
	 uPDRW+LVkgcSw==
Date: Tue, 24 Nov 2026 03:19:32 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
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
Message-ID: <awTmJIErjasO4lqq@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
X-Stat-Signature: u9yc7yqbkb3aw7dhuspwtkg18gg5y44t
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F1EC160005
X-HE-Tag: 1795483176-55076
X-HE-Meta: U2FsdGVkX199/RMR+ptgZE75IPYdmN3gUecsLON210LkmBxMZsgdRjIIT4uUal1RI7Zpvbq8GyQN5QoeSfV/iP+NSrwpj6AiR48m8L4JPCOT2EUj2ru0QyGuZhxrlVQCrx9uGz/XiEAO8ByhWbFYkdEfOMLHlPEF+rFIwI5Q0McoR9LeCybeW8z9MxQ5Kc2i9K86MDCdtN4NHjcejUHZ/XxZKgVLAyNI+RxV6tpvV8b8UyrK81MGEM7PjW8gmWLI4kaOwNyBzxYRCcyG8IBvYsfiyE1yC1b3PrsyijQhXQ59hbYdboW2qUR8s5QNRr032iwiHadA7sjVpS48mspWl+NfCN5Pu8WptwQKrSw7It4m1yTPypQS0zamizkj2jATleJ1TN2q30ubnki3bTMG+VF+h1WdD4wYa8GA+czK+oY2uiMB8bL1wMqYgL+Qe0Z5sRxhxCxKx42CcxTmd9N5uxm5bCe8vqKcAuTe2w3B75yd/j1SSgqhdQu76C2Dpkxm8v2YNL10Q42mB1MSPquBydGZCkwU+wwhxm/VYDuEJn7s4QkAjEtslA2FLrSoSSnxbXqXJa8+/WxP0Lf9bpGZLJcBVKbYWIjZt+rPe2GxePSVDdBQAKHb7fkff5D8UddqCEt9OF9rRPL/OLODxobXyKIUsj7DWWktV8Qa2uOzmQt1/5SpmmiYjU0i9VdyVW6Z+QcISn9xZCjOPfeniJtTcJQtjzWGQB3yLMtj5lCzMTFcxV5RZGKZ3/sTLDn4WmIZXU2IRGSUXwOWKHLgXsrfI6BBCmwn9AMWTSCUBKwgh8eSrcHK0B3L86hAsQCHlhc67eC4DILhd2IzNfOeh6g5k2TROLsEXhrKy8iRWe9U32QAPUk6H9RT2cus86Ric2f/IS0jIJjrDl9kHsrc/X+HCeUbwZFIajqEN1mzmRpvHTfWnKuJ4SwfNp7C7PnkvtlvwBhrZTC+C9ID4ltUO8w
 tTpVA8ef
 q9JV6jyr4on4q4T+Xx1XGI9sgE6QtS7tSXPqzVEtAnWTjyqKEUlL3aGC1onnJg/YUGn+b4QNyQzt3EOY/R3eqPfKj4bHouqwhdeav5JnNlBeCg+f/0o5XbFLv5Ka0klJ6FNjo5+fhbUGuipjx3C68PjJ5l7XqeqU8QseAXG59qQp7C+UDwVdcTXQBO24daRm83KNChSt1lOZDm5mBd24A/iIL2eY4fdFAM2mEiQ1USCI2VUhExRbqc4jZXfUGDy6auV9WXyPimR3Vlm6PRQ016JHY7VbkuVv9IsqAtDQcJfhhh2CpOfT0C9t6Sjmj9ekrnb5dH1a+seDG0+1iXcwFYEf1rKWAfDHQZ2+CtPzeZ9Lm3GURTinS4lHfqhEZYhygevqjx8SlS+BLt+aiF5Xgc6zFJSHfb7S/deBHVPqXZBJ/FJAbDefwlMwkNwMn/TToFJ8RkKKZ8peB+jv1UPuXTGs8VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> SYSCALLS
> ========
> 
> Two new system calls are proposed:
> 
> 1. userland_open(): open an opaque staircase-initialized container
>    object (modeled on Intel SGX enclave initialization with separate
>    build and live states) with no embryonic state, opting selected
>    shared namespaces in via an allow-list instead of unshare semantics.
> 2. userns_set_idmap(): configure all UID, GID, and project ID map
>    extents for a container user namespace in a single atomic system
>    call.

I played on patching systemd and userns_set_idmap() alone does already
a lot of good. I'm figuring out userland_open() integration next.

For the test implementation I probe the opcode's and dependening on that
use either "userland path" or "fallback path".

This auto-probing is done so that I can commit the patches to my kernel
test harness, which already has systemd, and try them out when built
against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main

The project builds a hybrid ISO, which is a bootable bootc/composefs
based operating system, and has toolbx bundled i.e., a reasonable test
environment for all of this. It is also device-installable via "npx
@puu/install"

I had to level the harness up a lot so that I could realistically test
lockdown-hibernate but it is is also pretty good emulation environment
for any possible container features.

Br, Jarkko

