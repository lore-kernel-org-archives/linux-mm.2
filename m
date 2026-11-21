Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51615606A331
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U08EaliS
Received: by kanga.kvack.org (Postfix)
	id 567F86B00EF; Sat, 21 Nov 2026 10:58:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F14C6B05B0; Sat, 21 Nov 2026 10:58:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA106B05B1; Sat, 21 Nov 2026 10:58:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2A86B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 10:58:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90359A8122
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:58:27 +0000 (UTC)
X-FDA: 85459583454.09.4F9A9E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 04B2A40005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:58:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U08EaliS;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795276706;
	b=xTQPeTiPVu5ibk85DT8LqyyDd6dBrHh6vuDoR5Ax1jZUdVLh/ZDs4hsA04BaErk4WJSTxp
	wYSJdGJbIFSAGsu8vZMR2m7kN9fnjnLhAQhAViRXOMyWslynyNRyk3ifL7LL+tMR0m6zRh
	smKLBP+UbkoiVks0+brsmAFjN+TZHds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795276706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v59nU/2/9ru5K4MWt6NBStp2evSJmM0oxZDWWYQAtDI=;
	b=MBvsW+p8yEvH1rT9xgd2H1g9f0qv7HogmFjff6cpL7p7CTAhWyAfnUcxcjpXLC7Sl8EFQH
	qa/VR9bG2LvRLBKqCpaSB0kqjlEUfzbYO+6OVeC1vMx89R6tc7luLnBCXC1kdXzIiRV9s3
	1cKmi/BsfxOGxMppjRAIqbk1WK1HnW4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U08EaliS;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 7372844E41;
	Sat, 21 Nov 2026 15:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCAC31F000CA;
	Sat, 21 Nov 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795276704;
	bh=v59nU/2/9ru5K4MWt6NBStp2evSJmM0oxZDWWYQAtDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U08EaliSbWubcMuaRUSpPl/xtocKTKRG5+LWCQtIwOvf1KyYvw7cQGTtMNjwQj+jx
	 Ng4QuX/N5lAp9jx7j2hYITxmWQlgrLoVVYa7nA2uyLxoanOfvKHnmbqHjP3p/WCFrD
	 wR2GLYIVuzGz9NvoACIKUCu691qClsGC87Em4zfKUaOoSmXlVErC63uKS9A8IKcQXV
	 JshEx6xACR1YzyWXaG3Je89a0VlL+//Y5PN4Fs+llD0UvUh/DHsT+RER+LdFLuuIYI
	 qeEI4tunehkM1Hw5Lm2kKHa7grtpMKogAQdxNcFXoeymOIsJD6zKuEuZzxuJLG15Uh
	 +W0MW70agCpIw==
Date: Sat, 21 Nov 2026 17:58:20 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
Message-ID: <awG_nK9E-UjkVgK6@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-4-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-4-jarkko@kernel.org>
X-Rspam-User:
X-Rspamd-Queue-Id: 04B2A40005
X-Stat-Signature: qf5i5ze1eyh9figqd9ejiqd8thwx8op8
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795276705-179516
X-HE-Meta: U2FsdGVkX18op+0dqzENtP12aaTTja3C4Jlrle0Q1DJlAhvHWVP2KZ4zi4dpKDkl30rqeuEVSC0G9oiuP7tVzYZZeQIlOXpcxeCqKO7o2ys6NZ27pvM2AQAQshlAyhwJU3o6x+dsPSnD+2LfASOeEf5inCcuQdwpHsxpE9aBm6Tp4XDw7wkMVJm3rut2/8P7nUgOVC+C/y0PPYYblSZAG9OIVVAVl+1zhQZdU3JB+P3RPaf1/wKY3nNm+2GER1i5j6PkT6jbtI22GufW8pHS7NqgyK8OzGC3DVS6UCsP2XJbc6BCua2D9raUhPDImB+9jXI+z4gVCz9gyMZHTS2qNu2jOhc9nIt3jix+E7HF+/S9ELA2uTbhZd+M5Wo7HM6ZXg/0d4coBrodQzY8i4zY4qmIMFwM+70qotmR1ePOXbRiN7u5YimPMPVytL0wLAmzLZheAmjMWaxFNdRPPQUHbmc0iRUVcRfEFuQ+gDkd5H2B9s1eplgrm4HVViCJ/iUxOA7dEAUVK4hOVyPvWhaR4UWiEknc0xq4sfr0YdYavo48hPnrWRh7hIMvvsDcOOuRlFGCgUM89nj+KHzjRtn9wOM/OPa9bs9/aviH3TsXKasquWvOJECrcMxMIHbpiweO030YJhZLwrOpPkslp6k3nexAE+3TAKB8L8SAIvPI1Ldd8WZWaUFm8VwT2sHUN1ZNhRqgnHIeTV7Jy4lVK5ieCVycxS2n5h5FftbxU7cZvK8KeZ9+9OwzCpOeXUlSEQyjiuR+mo/TLyzXmETOUzILeo7S05b3nEpKQYKnIm8K7Mt6q4A03Eko6sqFXfAvdnA0EMCxuxOE9CRAFHXLJ2zsFQeAA9AliSeOUo4CIQw3JoLXZ43Hnh1R96enkr+bTA7tSvg+ZILUvdQBVQJ+hwNZIi4XLdBR3RxopR8A/AV5tqwfClIgN1OlUQOx777335WQiBWHevp9ciDaBjDdUhN
 7djpxbiC
 08XwhL361+EsB7y9DqMP+h97CDlstwwK4nMhv+gwJkZn7Ny0OSi5fI768CnAjQ6w1vC8sVQgy5lFUMImT2J/Wkz6oujuofcd6Jqkok2dYRKGUgZq0s+s5fEhGfbie5CzyYXtIgPzvCfbYK3GlPkB6FOFc/FQyPQTqhJ0IM6O876BC2PrHO7zJnhtza5N/ZHAyD4VooNk0PU+Qg/2fJPLRUCLb/5Vj8TXy9BFsgGHePkgfwNu4QfDnibcJ74h9QjoHNiwtriDpS0njJCzvt/s1ONgoeASXilQqteXuyxjEZuQLxYYa/hB4xCB6CXmydqBD5gBtnBXtFuQOvDRWAUXOSs2pzcVE2j9G7e5jZLQrvdfB/UlJWJ0XiaZg4FeU1kUuq9iYITo9tI0W+hWcj/hXae6ab4PUigrLaAL6PtMsg8vFoB5kmZqII6SVMC1nRT5J4BS2tsWv+9h1cY8L3qaRasu51FMaotGVS/IU+yxf+ts6PqW5qqf6S2MrFrX4ayELUTEk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:22AM +0200, Jarkko Sakkinen wrote:
> Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
> system call tables and asm-generic unistd.h.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
>  arch/arm/tools/syscall.tbl                  | 1 +
>  arch/arm64/tools/syscall_32.tbl             | 1 +
>  arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
>  arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
>  arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
>  arch/s390/kernel/syscalls/syscall.tbl       | 1 +
>  arch/sh/kernel/syscalls/syscall.tbl         | 1 +
>  arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
>  arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
>  arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
>  include/uapi/asm-generic/unistd.h           | 6 +++++-
>  scripts/syscall.tbl                         | 1 +
>  18 files changed, 22 insertions(+), 1 deletion(-)

I'll populate remaining arch's at the time when I split this. It has
enough coverage for the time being.

Br, Jarkko

