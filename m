Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB48ECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91B736B009F; Mon, 28 Sep 2026 07:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2A86B00A0; Mon, 28 Sep 2026 07:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B686B00A1; Mon, 28 Sep 2026 07:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 543986B009F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:04:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFF0980198
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:04:08 +0000 (UTC)
X-FDA: 85262886576.19.BD8E3B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 294291C000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:04:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJaay7PG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKzxJQmNYQsUt2PEmdmsZav4S/mmfjAvnn3I6ZHTKf4=;
	b=c3iNKMhvx8aFBtyb6hEuQSqdgGH9MNr65Uozn4AFGbOB4mXhwTYDsfc8bLXj+rawWNz33v
	4oGwtw9k6xZ8lwoMvs3JY3sJzlW6JmMqAtlbfyJkyuSke2HyQjQY1fhImM3cQtLXZsaTsN
	3JEQMqbmwx/PVhiF7/poOGUPq+kxT0M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJaay7PG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593447;
	b=pIbVZQ6N/oAqG+pvcBc44Mmp3NjYob5AqJ1UPDVUpDAZQM/9Ts5ROolQH6EqjklJmfhwAB
	6ly3TS9hdcmI3EjxZlW8Ixe1At3KhhQRPlMsgr4H8nZU6p5Yft/0AAXDE+E0lTAvfpOBsK
	fPSlkw7BPSCpH/Iilstc7KJ3bQEXdGY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99ED860052;
	Mon, 28 Sep 2026 11:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15191F000FF;
	Mon, 28 Sep 2026 11:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790593446;
	bh=iKzxJQmNYQsUt2PEmdmsZav4S/mmfjAvnn3I6ZHTKf4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DJaay7PGP72R0tGkgyP+Oia4imEuYm8t8qR2pXFgrg9WILqzSl7Vjhp2rqDjHKhux
	 uDvrW2JpIyiASNUHIEFPZCnwPdOnC86ajBo8MeUmgKWcO1RGq3jtrAcpsqaC2H/gSN
	 YN8/cyXRUqo+vKyymEyDaWP/qu79jZshTmfGQWuhHsZgZlrxlBA4TpI5fBeUFX/zP9
	 Q5IWXT00yBQBnN09zoLUi1pomgDek0CrQ7diRBg3IxLLnE22BgtzKyel6+XVNdLMUg
	 BUbrKXD6vrPDCndd/xW8t3MDQHdtA92TFc5Ucd4FjBjsCfi2hMUSQGyF4YZtKTsPIl
	 GRMJ5Vp+/rHuA==
Date: Mon, 28 Sep 2026 12:03:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v3 2/3] selftests: run tests on nommu architecture
Message-ID: <arpJSAGhxSRtgPyr@gremlin>
References: <20260926010819.604346-1-thehajime@gmail.com>
 <20260926010819.604346-3-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926010819.604346-3-thehajime@gmail.com>
X-Stat-Signature: a5haowxywz39kf6zhefmbxo46yddimkh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 294291C000D
X-HE-Tag: 1790593447-129854
X-HE-Meta: U2FsdGVkX19GV3724IWRmDIxenPNitAqubqrzN/hvykunjAhwa3TekDAYSSv8mYY5xY9t57hGJw7Yjs6RPskQfvSvxccJQF/1Cr0ufB/s+5qmYHhgvFanCPE5cNOo9Cp6qi5lU3DlVc4DyvyOaGxlM/+AvnIZ8XNoSucTsys2gnuvwGsy0OWXpQIgIqTYBjh1RV2EL1hCoSGaZiAW8zA0Ivy699Md7OZIX+YTAk+zL2FboDvkpgGbxnDlVmOl9yHkAsv1ujJFpB08H36YoO5Go8pRR7fsvSUWSRG1lgWeMPb0u6V9GKmcvdLkIMRM5QhP2rBFkRA2p212aU56MbNuLuNQAGipmoc+RibDoygcawsTSm7yj/2XnYcAYs06FrUDm0wOz/n4e7pb1ELJi2BZtWmjn/vfHPpse1f1dPGeW1pkn1Zj8x468QskOayYSOvDxxawP1UbHGzos3sZUCkxmDrOrDm7P1+DUQj1IM3CwlJE502lgrKfhN0RciF9ZXothPfic629JIw3df5Kx+39HigKIlwg47PJs16W2WxKT6awpRbAL+9mqiuP6ZvSYjWDsvj2KMU0ARYp6NVJEEOwlb8ytG8QuEb1O5HfdNtIk356Wof0K47LxubXrnNNaawWiL4IuVgDWXItFYqsyb5XoTIkcTvMeIYKhpgKafpbejr790VSsc0/dI3u7lrVI/pV6pyWbZbuhB43LhJ4VV6ws8/b9iqDh2fe3DUsDH9MC/OoQwEpJXlL2Mb8HZHF8Lj5gFxWFbunZHg0BwphxWo3g+vGtSIU9ZOTT4zxHi7KcHhFAuHk4akWuMqdeE9GCS6sLowPbb7G+CtAqhKzd/EgLEGyjIkCGoF7JwI7t8ta/7XtEyo/vGIWbl4Lrtkag5J/+46qYN0TCE+JlT5SxzxnO1fA6tK/rp5++31tA0dZVA3pUK5xjmwZFy6c4wLN6gBt/kz5YeK4kUy2oe7FtG
 9ikFVRvj
 d4IVBTjyE5Cm5at+NPV34xI9VywI0Wo4sGbcpG4rRFomjT0hn8V8k0d15dib9Nmb4obSABO8uqJUxcYpVnVpibWmkX7YxpJ0l4rdW0z42lCLE9fWigZpOsfs6++G1CV73oZNLrW2ZBf5SiEF2N05gQBYAO3r1qY+C7QaOAulGMbkDNCGGNgil2+sv7yf9toXJXkmSVhp2OJ2oDEO1A4XlaYEMHEuPyjOMEp1KlrUyWUJFUkn2NG3esSRJEwMgmycV6FLoXVDj06aC2Tlmw2D8QXDs2jmNzYEg//Di8PGrpFIycVRHjnn79i6XH/gGp3TIzlfBoK5RA04gZqU/k0U3LQjhfcPQLfYzg78KALD/ULfGc0XktthkmCW9xHXFtP/m0Ss4v7swhmJWpgQALRABRH6E81gYpVXuRzw0zdB9UhI+yiP6I2utnaBL72WHEFSRosn+i1NSvdi3vlQzZws2R04YA3IFZiDoYCC+A4bVMqk+btNMjZIxekCPSv9yGYTHpEzKkjY90QwMSfkAQ7AqXdMB6mMLfUcFYN0bZe8cNhOXPQXStj6CZ+dHxpQ9nVna15AQWSL5g8W5P5L9wL3LQs/NTNRuapFyYyWKsd0ycLnh2VHfjccBccwxFPXXXNcHP8ERXd4wQGgosEX5TsAgmdKRghHZHei5brdvOg0P8A3xVA01sejQ7GiAO15Sp8S9eYk/GwXtX1uOdqUwKIhxMg1bws1sg18D2IkC10tGuB/xBS7d0kQjwkrFaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 10:08:18AM +0900, Hajime Tazaki wrote:
> Architectures lacks MMU doesn't support fork(2) syscall and only
> vfork(2) is available with limitations.  Thus, we cannot run kselftest
> on nommu architecture as is.
>
> This commit addresses this issue with the following changes:
>
> - on test run stage, avoid calling timeout command when NOMMU=1 variable
>   added to environmental variable, since timeout command uses fork
>   syscall which nommu platform doesn't support.
> - describe the difference of nommu tests in the document.
>
> So command line to build/execute tests for nommu should be like below:
>
>  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu
>  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
>  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
>    -c nommu
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
>
> v2 => v3
> - remove unnecessary modification
> - new target is moved from TARGETS=mm/nommu to TARGETS=nommu
> - rename CONFIG_NOMMU to NOMMU to avoid confusion to kernel config
>
> rfc => v2
> - reformat ktap header, reported by Sashiko review
> - https://lore.kernel.org/linux-mm/20260825015945.141739-2-thehajime@gmail.com/
>
> rfc: https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> ---
>  Documentation/dev-tools/kselftest.rst       | 14 ++++++++++++++
>  tools/testing/selftests/kselftest/runner.sh |  6 +++++-
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 64c0ec7428a2..c35b819947b7 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -230,6 +230,20 @@ section::
>
>  .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
>
> +Build and test on nommu target
> +==============================
> +
> +If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
> +``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
> +checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
> +using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
> +
> +::
> +
> +  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=nommu  # <= build-only
> +  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=nommu
> +  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c nommu
> +
>  Contributing new tests
>  ======================
>
> diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
> index 8fc1018d6fec..95b5ebb8bbb9 100644
> --- a/tools/testing/selftests/kselftest/runner.sh
> +++ b/tools/testing/selftests/kselftest/runner.sh
> @@ -38,8 +38,12 @@ tap_prefix()
>
>  tap_timeout()
>  {
> +	# nommu doesn't support timeout command (missing fork(2))
> +	if [ "$NOMMU" = "1" ] ; then
> +		echo "timeout isn't supported for NOMMU"
> +		$1
>  	# Make sure tests will time out if utility is available.
> -	if [ -x /usr/bin/timeout ] ; then
> +	elif [ -x /usr/bin/timeout ] ; then
>  		/usr/bin/timeout --foreground "$kselftest_timeout" \
>  			/usr/bin/timeout "$kselftest_timeout" $1
>  	else
> --
> 2.43.0
>

--
Cheers, Lorenzo

