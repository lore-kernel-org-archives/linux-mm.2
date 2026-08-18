Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2438C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BE36B0188; Tue, 18 Aug 2026 08:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD066B018A; Tue, 18 Aug 2026 08:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12766B018B; Tue, 18 Aug 2026 08:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7E886B0188
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:47:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36A5E140C32
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:47:07 +0000 (UTC)
X-FDA: 85114365294.25.F3DEE3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1DE440002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:47:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOdVgCsd;
	spf=pass (imf12.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787057225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFtjPd1BVmXAbioi3JU56OCVjaF4nzNNaOm0GcnCP7o=;
	b=RFraB470tQBIWziMT0PVfFteJpR20Hjuo7gMCe4g6soWV1n39+19BLAXHKvwvwHSdUDIm6
	cR1HbrunT4CoRwvYMKOZLPDh/W7JSXJbt7JpF959Eet0OqRSS39oJ4VP5+CFXWHAOs/dzY
	lBUk2jwzMp9ZdJC6X/1GDx2De9QxWtE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787057225;
	b=Acd+hb4Sa6Q36x3HPF0q/E9J9OTEDZMmz/XnigJiKfSGy1H2a+o28MoLJMBkXfrhPA7psb
	vU+XahzHb/XUpvmunjNYRSL5Nj4k6t6WuuAvgdxx26zNxllrWZgQgR8oh+/QgPL51PN0mm
	gvzhXCyPHxOXR8350C0I/YQ4ptX7DcQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lOdVgCsd;
	spf=pass (imf12.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC39D601DE;
	Tue, 18 Aug 2026 12:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40951F000E9;
	Tue, 18 Aug 2026 12:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787057224;
	bh=iFtjPd1BVmXAbioi3JU56OCVjaF4nzNNaOm0GcnCP7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lOdVgCsd+iB0AFj6Ivg0q9ZtPJ8aP3+6a8hfErCZiUukHR0gibiRmW+VOaim5wuYc
	 ZrF8AbL+O5sZ4bB4s9C59+22+KiJlWkQz83mH9R1NswhWnDgCke1RSZ84Gd03CQ+fc
	 DPAGkRuqc0I5+U6pzLgFTL8VkFf/9QZSQGNG0UwzgrPDJfM9fm0KoSXI1zrrDfpYQQ
	 SEvHYJeKicw+tZiiN2hSkSqAewsghXoKIbhAftK4pRYrOlI5XywkQubaJC/rGqQubL
	 /CZpXzfUE7MBBL1eNNByOtRNOaQKqsnPStmYELMB11y+fU7O+0wI+KAop+n9ZaXKQx
	 yf4REBnfSVKyg==
Date: Tue, 18 Aug 2026 14:46:58 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Bradley Morgan <include@grrlz.net>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, shijianlin11@foxmail.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 0/4] sysctl: Disallow partial updates of
 miss-formatted sysctl vectors
Message-ID: <4hbx4orb23mruq4dsjolglzgsjue5g25bbmnbeu5w37x7em4rm@o4hp6nu54ye6>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
 <5F021629-DD85-4941-8263-3C4F51E9D6BD@grrlz.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="l4ylzp3pd5pjeqyl"
Content-Disposition: inline
In-Reply-To: <5F021629-DD85-4941-8263-3C4F51E9D6BD@grrlz.net>
X-Rspam-User: 
X-Stat-Signature: rp6qiwr98imy7e9bof77y8o1w3r5ifo3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1DE440002
X-HE-Tag: 1787057225-228086
X-HE-Meta: U2FsdGVkX1/otLqs7d8HUbgc+8tKZHyQaLZj+lnQEbLFHdBIzZuMEG+UTqB6z1SV0LJ78miIDhjtvEzruvAz7IZntRBUQaJ0rJYfUW5CvMFvvn6DgZY1c2VxahMqrbveIO/WqZdiLPUzMGTgwMdK8O2Dilx+C9RR6255LlvBKY7vdoP+B3ydf1Hmh+4k9IqELlRPn9ZwXCnU106XMmGy+LZfaQHpK7YiT7woTdLYQ6kjAChBfGeNKhFtRGPSzlroRZY4mcNlaq6QX80LiFynEV9HSsKOpW12WCqIqFPVHGc0g8v+OMpdyHzPaIiXrbrez//JtPbxmv5doU6eMpKkbnpGyijze7nMbpegqMElDvehsmraonSx3AwBPNINT7zjOcM2opuuhnXpc3OaYrWODHiniak4UEh6sLar89/DQr2lEwMXnR1pMJ1XnPTvRcsgTTtAzSSQ6fZ5V46I8n7exb0N+OXfj/my51Anl2UVKeIuC95G5EF5tT66om+iyZHIArTDJkj64RnbN7MT+djqgBxGu4rX/zER2X6n5YfWtTo6OwU6pFYhuFSjotjfZpKkLhv30k9uh3OwMwTnI6YdqEX1Jl2R4j6E0ZVDtVxTaiLPzXGS6i8ZYqJWKSKvI2QyE0vq8avVWuGOyxsAFRzD70TDPFKp3BybaJh+h2H3sAbOl6JvXS0/r9NI46sZc9ZCaCubCI02ylgsabyOF6E0k7cBiSYIIATW/DUE9KTqXb+kdv9YOuJYUwSg9wlKYsGdj6TDrYTgEw8sbe3i7ExzREhRB2SF/J25eSMd3lEMjCELygPWSUuOGOyKTL2JLdxQB/bnQa0rgvBwDom8Rb2pIKfb7Y0xtFQK6NVVg3tCcKWGGGtlJfTT5zKNxOz6sAIkZk6VMJd6KwD2AGmYph+YI446jsxlf8P2s2dzb4hlB3b0satlgaUaJTzGLH0D5PTlk3oT8xTrSsXi+iyVJVN
 rKJavTiy
 yKi94yvnH18FREf8kKpm99JBqeXEg1+HiJSfe81W0N7rJxNr4y6TMinHr2RtfP5zvgue8lwd+LmhjE0HmAoqY/+1pWcsiYXz/RcxN5icLq0vMsEvyp5haPmDvy2RAu0/3GLLqOnJqiRiEItv5a1TZqD77Pg725UsTNJhzf9ONVHDnc229giOfjVoeR8HNK39yupZHidiIqEV2ooIAzda+WkYVJImJeUe5IGgz7aPXmW1eLmFOReQU4F6pfBPu3AeA50r5eiDZrp8821uD49CAYPjHg/oIO+uoy3rI3igzTwnNCLV7fvvBOFWVZzsxWouJHXRYqK70XM5tivd8HO5RP0WiT7cz84Egnt5K/BXmxLy2N3+s+WzvNpTi1vA467ga4q4C/Ry94Y3BsllL5YuDJM2XGdPVh34Pej1j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--l4ylzp3pd5pjeqyl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 05:09:30PM +0100, Bradley Morgan wrote:
>=20
> Copy it, only write back once every value converted. That's the
> right way to do this. Went through the whole series against the
> tree, notes in the patch replies.
Your feedback was useful, but it was riddled with a *lot* of hand
waving. Please be succinct and to the point. The previous paragraph is
not needed.

>=20
> Some nits on the series:
> - "miss-formatted" in the subject. mis-formatted, or just malformed.
Note that this comment is missing the why. It is good to know why you
want the change

> - akpm's scalars nit still applies.
> - Sashiko saw something on this one (akpm linked it).
In my opinion this is just noise. If you see that I have missed a
comment, call me out on it. If you have additional information, answer
to reviewers mail.=20

>=20
> Otherwise fine by me, the split is clean.
>=20
>=20
> Reviewed-by: Bradley Morgan <include@grrlz.net>
> also
>=20
> Tested-by: Bradley Morgan <include@grrlz.net> for the test
How did you test? And what where your results?

Best

--l4ylzp3pd5pjeqyl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqEVDkACgkQupfNUreW
QU+sdQwAiiR0nJg+0a4UBdZxBcSQ1BO7cn+hJgcmdVyUFr+plSJKAcYIJW4gWdJX
2V2MSMvW2RSvPkucsQZJogIPsw7Uf/vSCwtyiy2sOCBPIGxd4KaMJRKunzrZGbSp
BNqLfvKzm8VUWBCA9x0b28LIVuZLp28mDR8tv/+W+4Ah2GcaeDDRccCtZL3TjYV0
ScfIr710yqRMkCUPil0qkEdU5LApmXvIEHz0N+HxksOGddsW4SPBmtmQ91ZNa7+v
X9ldCz7evpB9n22vjGkMI3QXI8IeRB7lbWWDtvQZXeWypFPvyhgBXbmAi4HZqAjj
dNcPj4rPVAR7saqHOm5uFbR5lMYolL3xApT9pZx31h7bDNrkKxn9CUosZ8yJ1L6b
MOxxPxY2DAFU1T377mMnzF4cVrPAaCgAEP4lvzax4ictwZpMJ1n30HMghgmeb2R6
IK2TdWDgavFQLBtUKOCPY0SawLS4ekWMsA0CeqDZoEoWPHtNgaz/jPLw5V8YHu+W
zhJT4INO
=x0ir
-----END PGP SIGNATURE-----

--l4ylzp3pd5pjeqyl--

