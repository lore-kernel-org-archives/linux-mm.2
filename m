Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C5BCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 18:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135386B008C; Thu, 28 May 2026 14:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CF56B0092; Thu, 28 May 2026 14:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A326B0093; Thu, 28 May 2026 14:27:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E96306B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:27:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89A2EC2CCA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:27:17 +0000 (UTC)
X-FDA: 84817660914.24.C7E4DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B0FAC40006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:27:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1ZMVEpk;
	spf=pass (imf17.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779992835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNFRPkLBDJywU48J/noDObDM2rNQtdyFBCATGMJKuNA=;
	b=2+B5LcFmagICkPeHg4X99mIju9ivjTU3qOBVRgcCu5CqGOYJj8jMl2KLcnM5d0idYeK+R/
	6tW2MwmaUIB8shC5D1UWQ2MLc6JC548LijzeiBQlQWj6kfQQLhCaErPyQF5Jz0HYC4u12q
	LBV7wOArWt5rl5k71fqbrEDAujL6EaI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1ZMVEpk;
	spf=pass (imf17.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779992835; a=rsa-sha256;
	cv=none;
	b=grPZSY1RrhForMDbN1h1fs3Jhgh2T2ZwAOArW5/xRqqmeZ54NlhlebcmYRKasN38x9YXSz
	2ou0JWNLUB9+J48MlzqwrFALHyVqiTIUF1DUCKH1TLc7AhPu1H0kXJVO9rpmZm6/32vf+D
	gT3MeziPp6Jxy+9L+fA9wxRxi4gBfhk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 182B660561
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14501F00A3C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779992834;
	bh=uNFRPkLBDJywU48J/noDObDM2rNQtdyFBCATGMJKuNA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G1ZMVEpk3gU59XUYucRTVMRJcbeiKLzqLpDypug6RLe3b0aZkBevWVae+ifxekpfH
	 oK0A2zbmeC5ZTA99vp4wtydk0KLKr7s6YrhBhqlELKUA4YPvzb9R897/Puix9njxHP
	 BFJw1WeJIjscHQ+t+pbLwwad0o7Rs1f9ACYEbBFtGurd7bOngpecSA58TDf8ZtiVMF
	 Nnxzk9Jx4YRSpY8EU+ZeIq88xf1iP+S/0WJ3tOHqp+jfqCnHUvRStcNy0GkuHYC5VR
	 1Up7KG4/Rq58EQz73+oQzXQqOS/+d1al4rJVbjlIUq9MknFi0WX8EcGkYOPM6fiLft
	 TkIgS9+Syz1Hg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa2d5a1d51so6133337e87.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 11:27:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/CLF+5WDrkF6XSi4WEtsAYVWP8pnw0k/SPUWMvtUjmjbflWT35xKOuIYydrPCAFc35KidGdsKwww==@kvack.org
X-Gm-Message-State: AOJu0YxODPhuWYkXxd3rMUrhw3ycSdagPkNrQNNamE+I3TKkCjYiWvBh
	BVve1ytdPD7mk0OjAaO40FHaZggb7hz3S3awL0H1PLG9pPlWgdK1RiWTI9ENr629w+br3OgqQfu
	kDv36O06psODMeBJTZkNWpMpwrMF0Gxs6ZhSd2qvv
X-Received: by 2002:a05:6512:4017:b0:5a8:87fc:2b34 with SMTP id
 2adb3069b0e04-5aa57e2c285mr81991e87.32.1779992833237; Thu, 28 May 2026
 11:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260528095235.2491226-1-me@linux.beauty>
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 28 May 2026 11:27:00 -0700
X-Gmail-Original-Message-ID: <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
X-Gm-Features: AVHnY4IbWwLdSkNuWrooNBUAlyUyrWFavzF9Z8DQApcFhZZC4EFwzAXsIa5vxFY
Message-ID: <CALCETrXqWcqn_79sMKnkyKOSAjg4AmcSHsuyH83oW8zJFoV6Dw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
To: Li Chen <me@linux.beauty>
Cc: Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: dqresbjoonzgas46npoxxuottxirttyu
X-Rspam-User: 
X-Rspamd-Queue-Id: B0FAC40006
X-HE-Tag: 1779992835-98874
X-HE-Meta: U2FsdGVkX19Nymz7wguJb4E1wGVFWQOW2/MdT0yoRQXUkkROHuh83tu4FfLGOIOmfUDYWBcO84Bm2ZyOoqeV1jWictoCTsUl6mmkylwXb0X/QRsFCsGP71uMcRIPlRKTAH0rDvj/WKzKsUbTUV8bp/oM2UUC9+RGysdDySDoTLeHnEShE5cx94H+CE53+GjqZwHHzJL87QqwI64KAqysN/R77hI4o1oUio5wyFVt5fE18nesKNo4GDAzCr99mia5DCSi1tsF4DUuAAuA+eDe7k6MVsedwtbfgc+SSagSWS8i7LqGZGdEXp0q9ReV16NSqS8gYmVKGpDDveew1l4sLbdOIBxKwXgg47DKgiRwpQtPYt4H7KvT5pKPtJJ9iuNkpDHIPQeK7z8OaIFkX1yIG+1pe5IZVtfhGQzoNZnuGk/C2ypdirGPmEDhCYW8jLISjNHRQOUoGcXy8f8gutAHdT2KqHoJpyooQiPJ55fmBW3X7TzDxhaLMMSDaothi03sWBkbfWvRUIwofESt6Qn56PrzAVzPEx9A+ARsp9EBBmJT03WEav13gaB34a9SNqZIsU4g0s61pE8lVxcwuqiniu38NOu9hO6ulRbYZd2eO+NmWcoQSfew6eeEKiWP0ReSsN1/ugixx3su9dA5hcUJ9xYKIrdm9a5UWvRj6MfV/VbXRDmWR0K/fDuwnZla3xw2xYtvbaFvcdOJWYJ93WOvHbI5oX2FVOykAaGEdfe4PI7f0i0Y7/IdkX9DkU5Ep+YwXsT39jUxwykFm8aUuHMkKeZnn60NHtB6GSoyuY1hgzfaWvymMyIz5Nqz4SN9dab205v9l1gQPmbzvmuAUgnMCecUbszm4qabn7XIIhc1t2n5PGRPW9zq0u9cToSqQudMEIGVzpriDiV6wG5HPwoPgC2f+HDeG7OB+xnORCPWBF6anRw5u2Q/FXKPazVNTY9pAJvFBXX9jjAsB2LN7iF
 ab2jsNDS
 vIVU6mPZ+twKccbSQePe1QVTvaeWsABpZnmUEvDd7fi5iaJBwTxWiYooxFCjDQqXAcvgAFrN09U47yGE7qLz8ZiMnR0EBUst4WSizohQWyW8WhYdvn0RmybOiIbPJV9oC7eDjXZ/Ibd4c7dewdl0pqWiLT6p7upsx4cCoEU40J7+eLVEDWxclp+7z60mF3QEnBB2hJCcxwSBB+FdY9XCjH8VRKAGoILOHZMWkCm4T2XUE1IIh0yzxEt9pJVZVm7JY0Zu6ZY7HvLp4OOcar660XnNEoqdSk9OHpf9eujuqbVsnys82vkSzYB0i5CDchJkDcpztcSrOGo8z9Bs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 2:55=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
>

>
> The template pins the executable and denies writes to that file while the
> template fd is alive,

Please don't.  *Maybe* detect when it gets modified and clear your cache.

Or develop a generic way to open a new fd that's an immutable view
into an existing file such that the fd retains its contents even if
the file changes.  (Think a reflink that's not persistent and has no
name -- you'll need some way to avoid resource exhaustion.)

>
> Workload     Calls  subprocess  spawn_template  time_s       Delta
> (workers)    calls  calls/s     calls/s         seconds
> 1x16         6144      411.04          420.32   14.95/14.62  +2.26%
> 2x8          6144      666.78          690.08    9.21/8.90   +3.49%
> 4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
> 8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%

This is a lot of complexity in the kernel for a teeny tiny gain.

I'm with Christian -- a better spawn API would be great (and much
faster than fork/vfork + exec), but that's a different patch.

