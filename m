Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6759F606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oU88Ot+D
Received: by kanga.kvack.org (Postfix)
	id 7930D6B05B4; Sun, 22 Nov 2026 20:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744056B05B5; Sun, 22 Nov 2026 20:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65B8C6B05B6; Sun, 22 Nov 2026 20:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 417A46B05B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:17:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9E3F212078E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:17:30 +0000 (UTC)
X-FDA: 85464621060.15.B0105A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 053CB40008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:17:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oU88Ot+D;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795396649;
	b=P2RQuTMzI8QN0sXAI78aQ9O7u2Bb+mmGb4POkJszLUpEoeHf8jONJXF40bmsL/PgKzbLac
	dgYAOE06fYtoaa1yXYnmfPZOZOD8shxYgKLsIDYETQwFWiNoQUJTojZovN6Rv1y3IfhwyK
	QW5Ck9rvsXda+nuyeH7SbV0TDsMExa4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795396649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0aOCQuegkDUwskKeZ1j/NRStwGaSRAPMc97ZLi2jvTo=;
	b=u9CBV1HLICiXP/3CSTr8qEX0cHpQ5QBDN5Yg13aZSe120brUYGH4xIJhNSOUE3/UkzygoF
	jYWdKTM26xdsNrrSrkMDzh7W18BTaXVif01Ee4wGTFxxXgZ+xHM+LT+emOCWmRPrmULiC8
	Wo4V9kFS9NrhZyhGzucUT7T7S4UPuT4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oU88Ot+D;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 32D3643C79;
	Mon, 23 Nov 2026 01:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 51A941F000C0;
	Mon, 23 Nov 2026 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396648;
	bh=0aOCQuegkDUwskKeZ1j/NRStwGaSRAPMc97ZLi2jvTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oU88Ot+DNQP+6mgTLa+2Y0T8my6gPsAHGZ88SJHShFaf8cOQRDR/RsBGJuK8xoFLK
	 ie9hfueXtMCampSV8SKLb3OF0QNXZC677qfYNG23pJ5iHahuOwYmCYQaDeoNgy4F/v
	 WrSodOYpWarCv74fRWHad1uMwFGvOjPMCZF6v7Wi0+rA5eMcDfTGMme0DFDaIYr4Bj
	 BV8BCmSY+LkBq+1fjI9o6dPp9AmTJdXStFcDzKkDk5gAEWZ2CVD8G/BBRGYx8zrMSG
	 V37z3MaBHsr34qCd4KVhM7YMEkrvDZO2nf/YcaxeI9eniMitk/+WJmG2GXL3uA5PBi
	 C9nhE3GDUd0ug==
Date: Mon, 23 Nov 2026 03:17:24 +0200
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
Message-ID: <awOUJCbB_j0BuHvo@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOQDOel_72Xwjm7@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 053CB40008
X-Stat-Signature: 9mnuuxk8yxhe519mt3dh3x6jatabqs9b
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795396648-424862
X-HE-Meta: U2FsdGVkX1/VtHXfosUx/QRRIBfQYaLnB4rmdwOpMr/bnwjhUOnTNqQC/IdiwWbNEMBzpQgY8qGl0sDc2BJTMQOiYT/wcUEJ59J0TulJKEw16vXUntx1PTQTt2JncroKpAUs25sb54T8RwYLSz2MgviOZB+R8EU55qUexFQwSVJz61PMhsrWJrU/2QvyNO+ulkwOFtfQWrl676rZfmM8VwL201JcZykbfmj9x0hxHBhOhzMx/jC+vDASnjHvgnEz2SPOPHyB1KXbWMBbt4YaaM89a4vOQRxGIl/TbJSysAMl1qyWb7f9M679yPVlOjUJ8i8q2MzASEjU6b5ICGHjYE94ygYT59HPvcxEzKWFbdUexM1LSfgdxzvWf8V7f42gy38mTwg+DDHLbJEqH6GXG0qOl/6mjbYXb2b/y7ZCPGvV5uPZeL+/xWpmuDn+zPflVfbzTRym9iInMRMtJGEtU/4U/1bUBaRoxNcVHeftzBbEQDhFIsN/yPN1vGcpSnLcQWop5ftU2NURk3aBZrRwaBwO3t5wcMaNfdiZbK8sGY6NcGQS2IDCtpn0pf6zwfHgc/PcCZ8lI5R4LHAw3AtZrlXB1Dek4+9ie3JRqV3j/vjPUnMVXb528A+wS2/jJeEKLzgHgn4XnxM3il85Z/Q2jGReBbZ2k2Om8l1UAwZV3Pk9B6cUVGDD7QvF0XGZLSIVaUfYHzzpKQaQQq6aLsOMuU3unByyVHwRjWD7qMsAdSpPMnkTpIU49GdfnJD/C1/+1OiMmIbGUqUOCFWVN1M672zbz7XXJvyfGupDfczAGllu5S0ZmHoNcl5IE9NH4oITJIKPwnQOiGTGCvWeo2f4yxcAC6Y9prUz+VhIor2WIqgIan6qhg0CUp0gMMgwsTnkzL+TDOZbtXjOtjRrhad5z2iH29ENdiv3GfvWorlJZFL+hq82pCBWd0uRLoOfMZYObhKqZuxZKAQcLIXS1ER
 212erI4m
 pt6aWv5H9zstTPy8s8x0eVjUALVe4C6E7z5To+MDUGvlycuu7W+ZqzM0WWYtXt1cfaWwz4KZAD5uSNIrMmw+/sIl0E+/+T//jTQ7FXNm29X+L8SJ3SVWN0ngvkCo/2pju35JuGmWu+NKnP8DGWmTEQ5QUfkTMhZ5SFMU91m1xFtLgoU5uW4SF7Tuw1oU8f4c0M49h46GfRahnvRUqQ93Y7T00I2shrDwnVrUytwDNa+0//fgjWIKA1y8EKX+ED/pfnDkOR/Ng8PRMJOzIDlI6TnxnA0iTky3qoEtLeX1M0dbvacMjJAMVE8zzt/aH7eZCLH2ZlwRZAsJA+SAcStItmZzIL7fviGLLQ4mdmVvHC4r/c3EI/NoptSOmZqZc0cIXZmKk8CyprJpz13bIjz0KVKDA/e5ITMAzJtcyMJnL9I0/IxQ+RowGF5nMNGYDheWTwshOzX+HX6V7kRjkHaiZItpjq+YrXHHS0eHIH5AI84eZsFA09S1OqCaTFb2wIrUYJOUFXrsOHMN0F2IUfV2bougtYQ1uYi95NTcz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 03:00:00AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 12:21:16AM +0000, Alexei Starovoitov wrote:
> > On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/
> > 
> > v7 was sent 18 hours after v6. v6 got replies from the bots only.
> > v1 was +2559 lines. v7 is +5782.
> > All six findings of sashiko on v6 are still in v7.
> > None of the seven versions got a reply from the vfs or LSM maintainers.
> 
> Apologies, I started testing this with bare metal as a result of
> hotplug, and things just started to roll out as I got a better touch on
> its use as a result.  The growth is by majority in kselftest. The
> feature has not really grown but API has shrunk along the way. Still,
> demonstrating that full detachment from syscall API is important,
> because it sets a bar for any approach trying to do this.
> 
> I had no idea that e.g., that  quality would be even possible but
> one thing led to another this went a bit out of hands.
> 
> I also wanted this to as good form as possible before going on
> holiday, which I'll be starting tomorrow but this was not a
> motivative reason.
> 
> So yeah, again, apologies.
> 
> > 
> > The way you're spamming people you're only reducing chances of anything going in.
> 
> I personally think that "getting in" should not be a goal in the first
> place. I care more about that whaever gets in has a high bar of
> quality enough. It can be something different than this but
> when I read the LWN article about Cells I was alarmed enough
> so that I had to do this and prove my point.

For completeness: I'll consider this final RFC.

Br, Jarkko

