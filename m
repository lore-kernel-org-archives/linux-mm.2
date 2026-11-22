Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B27606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFaCXoo1
Received: by kanga.kvack.org (Postfix)
	id 0088C6B05B2; Sat, 21 Nov 2026 20:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBC96B05B3; Sat, 21 Nov 2026 20:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E386F6B05B4; Sat, 21 Nov 2026 20:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C44FC6B05B2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:58:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ED1FA81A7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:58:48 +0000 (UTC)
X-FDA: 85461096336.18.C5E3011
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id AAB32C0003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:58:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFaCXoo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795312726;
	b=n9duhbGBeuRYU/cM8wK+gocSgkLHvb7ATBwHBNvaC614g/iZp6LEd85CVTMyIBkN1e2vGT
	PhbDsxncuveR017UAaq9lzKhOwErRTbXG4tKpvgzDNf+9s3ZFbXRnwIW/d9J1xSX6HyBSQ
	ZpYuVrAM+JIvX89pqoeNx/SnSAc3GJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795312726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=my1JKAIGP65RNH2BdYIO2cHSch4Ja97YSaehc+euNFY=;
	b=eZUKdwT7Suv2UvOYge1rlb91xEtaR5d2h1RZA2QKMRhUTi5JNB4Eipqmxh7js+/jpsMRDK
	BcZ/mlJdvae66A1x/D/3dnjweW9WJCCaCoB4YPkXCJNin9Vj0R2GCYY696NJyThtURh9ml
	ek6Hzebc8/hBIU0PtraKdhQ0n/RPjgk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFaCXoo1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E7AD2418A9;
	Sun, 22 Nov 2026 01:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4C08B1F000C0;
	Sun, 22 Nov 2026 01:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312725;
	bh=my1JKAIGP65RNH2BdYIO2cHSch4Ja97YSaehc+euNFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFaCXoo1RFl2e3MqcAATZcvWUBppaOK/u4W9/JRBcAkZTZdBf5NNHKDAP0XVFq2UB
	 18NyeT4o7uDpW+GnmmzI+4F6b4waTXBsZLCb5Oc5D078Fi5KZpOmNE5DRLdoF99CyC
	 fwmNjLEdakpaJ0FjhWNtTGhuldX628gpogHz2YrFO3V/F2JTjJYRYykIAz6ZKvEbdf
	 Eq4Aa9/TFt/ibItvOY1ZqmLL6sInT0GslX+yZWal1rDzhJqeSDUudf9mp7kJ/4VXuy
	 Yy1eAUnby1UT8qqZtlLSU/6Nmx51AhaQmuwK2mxrpWKp33SvdrM2vbo+hOz7jV/vBA
	 SCSWiC32vxOXg==
Date: Sun, 22 Nov 2026 03:58:41 +0200
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
Subject: Re: [RFC PATCH v6 00/26] userland: Userland containers
Message-ID: <awJMUf_Upp_ilYPe@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
X-Stat-Signature: 6om1i1i44yjxi9swd6wz4uubdbtcii4h
X-Rspamd-Queue-Id: AAB32C0003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795312726-791877
X-HE-Meta: U2FsdGVkX1/g9IxT1MZuLRR10hoSqCdLjgoYgyZaNCzWbfCChCah+yebzd4wEcgkj3LDfBlyYRSJz24dWJ/SYlRvgdBwp4/UXoYY3XSctRLfKRFDOxjz71HW5yCp2ecVehjjWDknzqkPqIu0bS2TAL/pXjjYO7L/XIuQ69qWbhDpMLNMbMLE+60bnzTBIIRElVHppPgML8qhTWr7Hch2I5Z8SfW4qMZ/UTjEuWfSGgbYwgrh/B1ESL9mPzEjMwjF3kK1NPPdD0jqlLe77AJmP/pxyKiS9oA5relHw+cZLWv9eVcejWiNVF2wStxjJoQPzgi9WyPCrB3OaqgI4umVuxI5joPm+DuebidRFjDBQOzZd62UXW5/+85R5kUglHpgUtGsKArxKDWm2PVa5QvapO1Sb+Lg7dInRSuE4l1jawWDQxibi8RGSasWkAyUqLjusqu8gZ78XzesPQhWBFUUazFix20xvgxGq02EusTEv7JCpFeS3WQdSuu0oBf5SoCpALafKobo5vbVh+4Xbcpnb++JrkzdF6sUDSy2vpPbFW2sYXz60xuFbVzQD9qSkmw8AIcZe7dxz7xvniWVaoG1fmFeLwNJRi2rLUV9PQa9EoV9ouL9YO++/IcyjxfK0HXsv4FDUFUOaWaZD+oScr63Wtw2uhNsk2aK5C8DMR/qLvprmLl+PHX0O3bov+7TBSlYtGlrSIF+xIoDXB3bXMvNcWtW2MC2UTJbvPCWR9pEN5n5t11o8G95vNSIT2I5h59a9/1pd9ZFM2whWPKXdnoH20bWk+RbahmohK0CD1i5uE5sUlhLmgm4MEAfCSyY+yBaQGCQp8i9hoTdOTaoTlZA+d0Iq3igkcdTnQ9ZlzV8GxSp8MibaJV3S1VUzM8V1Qk9P186Yfa75UdpOwk7no2XKhME1yQAEgDQ3bKvcUwpl7fBYV/4BsasOWpgNwb/vJ/pKUM+vVPQUGJRKXYvD2C
 lgh/hdck
 SR4sKPyKHPVuwfZmjuVpOFcG8jL4PjSOxi1hI8paNNOnJWwg1EO9+kYmqfUIVN+rlI7dqdwNd5znqn8lEyZog7KJlBzuA981zeuRouQPS7jhSdY9k/1MuAhc78a/kckB+Fk+AOxzU0BDx+j7GjdSAQCUB2IkJnMm/WVQPpmAwMnY8bV7nNeQ2yiTL5Z3VKq+i2ssfZsKaJl2cDOYfBE5x7m2FlkzE8jNtl+NhOcCDAPo/POAfC38lpqxkDGQNg6z5q2lOXgZl3WGybFp/wJeCYJdZXpHOc/HU22LTUpTeTCrW+zMZK/QK/FnyK5PJKNQxZ0wqTpETx5sqwA5i6K+Unnn0KeOLmHhtGijIdNgb1FLGk+xOUEFV1RuCJ5n38LnTlWoAoujwc9bfmk479/GN+hVw36dWmaWWcdVMVqhYsqRZakU0cJLxpBiwZ4wxaECVT6KfwjRNDr4PPwNNq0N4mD9ieauDl/Khjhjjzk7R3aI8v+98zan6JBpQUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 03:17:43AM +0200, Jarkko Sakkinen wrote:
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.

This text is out-of-date and need to be updated.

To put short, this is a continuation of "Failed" and "Repeatedly" :-)
[1]

When I looked David's patches in 2025, I thought that while the
packaging might be a bit unfinished the mechanics made sense to me, so
since then I've occasionally worked on this problem (with long pauses
in-between).

The lack of embryonic state, a compact and policy-agnostic
implementation,, the lack of weird parallel syscall API, clean
allow-list security model (with LSM hooks) and the enablers for hotplug
are I guess the main differentiators to the pre-existing science.

I used a lot of same thinking in the life-cycle model as in SGX driver,
which can be seen e.g., as in the staircase initialization i.e.,
how ioctl's work and some other things. It was a reference of
an isolated container I guess that pre-exist in mainline.

[1] https://lwn.net/Articles/1102593/

Br, Jarkko

