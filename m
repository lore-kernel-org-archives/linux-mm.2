Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC394606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z4iRM4Ao
Received: by kanga.kvack.org (Postfix)
	id 0163A6B0B1F; Wed, 25 Nov 2026 17:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F116B0B21; Wed, 25 Nov 2026 17:41:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45BF6B0B22; Wed, 25 Nov 2026 17:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0EC16B0B1F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:41:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49DFEC0180
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:41:55 +0000 (UTC)
X-FDA: 85475115390.16.F058807
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id B45241C0004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:41:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4iRM4Ao;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646513;
	b=ZElePzlUlvNyJQi8cVjVnH0axKSUFyhvRFhoWnhI5KvY9sr4cq4GQ8+u9a9JXlfnqVNoGs
	jWyXwFgJrI+BmKM8N7sFUfojJWKRA9+psPFISQgqgFu3+1aBnH369NUVhbOpZepqprml1T
	GUQDPSb9sjSD+cn6gmkLiuoHfq3EH/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646513;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ED0uK9gSgMRdaztBMPwhRS1wrHxALrpPXBMM2eVrwvY=;
	b=x2LhVqBqO51VdBCth4lCwDDw/DHmAVsD5hjgliVwnXzSoPk+/7DioVUHty6txaiuK6XnEH
	rffe/1am4PspojLnd/sAQzxug4I6nVLrSFwOAa+P4OExwWKo57EorpCOqDdF+5t2hDIC5Z
	HANPuiDklUcNluyfnKW5BTUgecl/oZc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z4iRM4Ao;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FE8262526;
	Wed, 25 Nov 2026 22:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAA81F000C0;
	Wed, 25 Nov 2026 22:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646512;
	bh=ED0uK9gSgMRdaztBMPwhRS1wrHxALrpPXBMM2eVrwvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z4iRM4Ao0AM/MyCyxG/3LFCxRNrCzEmTe8ckWG1T2Mt4/DpmBWCzMiHAL4z4ktZPT
	 Y0HFxSGxCmWXo17GqhLUyuovUbGiioMw9V2XW64+ZnwYbqHZjaxtj6JOVpYDklIPMa
	 t9XtdgJdoBVA7Zq7iOUO+5di/o4hO47X8cWP96DdG08qyCt3j3xxu6KmDgWt/Ua6lq
	 gPVSoWdjVqa6wzLJJtG70SuRJTnsljgLGVawim/IYlw3yeF++AxD7bes5BZu/8a4Jq
	 Z5UJvDzpRbkQJh4l7+63INXkbZtFWNzDoinAlUFuHcfxl9HyoZ1PHEW+HEIcm9vJQ+
	 K9SxUVEpZ0STA==
Message-ID: <sashiko-outbox-234265@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] docs: filesystems: update filesystem type,
 superblock and inode documentation
Reply-To: sashiko-reviews@lists.linux.dev
To: mohamedalibouhaouala@gmail.com, jack@suse.cz
Cc: corbet@lwn.net, linux-mm@kvack.org, rdunlap@infradead.org, skhan@linuxfoundation.org, willy@infradead.org
In-Reply-To: <20261124223841.45091-1-mohamedalibouhaouala@gmail.com>
References: <47rkrhjkulqvgfkp3ssvgrrmsfmeof6adtjrght2fcmq6ykbn3@dis6c75io7ri>
 <20261124223841.45091-1-mohamedalibouhaouala@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 22:41:51 +0000
X-Rspamd-Queue-Id: B45241C0004
X-Stat-Signature: tqqwzj4cmkfsuueyjn16qwhwfs7p75ob
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795646513-568173
X-HE-Meta: U2FsdGVkX1+Hj9rAugY1QTinq/SxHjQ7Rxj73C75rhU35uYn1L6HXkCRcwC8RvcCMdxHDcK9LAN9Llxz9DAhvyVErU9sSkR94Wb7RPGCFArdAQgkuTHi5M+Vh+GukePVsEXgsDDWjOMdGL6K5Iy5rE42OZeyn3d/hGg508jZS/vlHr9EaY8p+VbWwel0y36kerTOXDcyj7e0wrfin0nEqZTFqYsg1W983Tb6KWCRnfzyNYpGqWmByPtdj2j2hS5z4W97U3ZxwsPY5/CPdMbS9U98l3HaAfEZQe4O1p/fcr54G9xNZ4LLmmlPAryYlm5JDbBAeNt6cjtWb9EQYcnGgsgNrh3h6Nj4O5oAs7cBLGpr+e5Tng5HB6x14lYqOtWSoVC0ymV438Ir6MD4TQEf9VjCBToKp4xbVVhz21INCJu0lXGuf5cgTUN1n8+AgCVkXoFWXCTB2N00WTwThEldZp+rbZkPB9lfBdJVNFntKErqQGHIts8h2p9If2KevZwXepo6BKo8L7Sn5qQqv7CqpwlG8GPV2O2xaQt0d8T3CQ+D73lCnIF2K0A4O8LfSHLRwDejsD/rf3TUyiTdNEuzyfN5bALPsiRjZWvp7HM0TQNaOjoDgwS2YIWGbkD79mHIKsYzozK6a/aZoTZDfkoX00KSPeU2tOjVHgySVaZVLAyh0XfWAWYUxDxH3sXosKEG738EoQrBRPmYV0Okl208pZtydl8KuqMxw9Tha4GE/sRnFq/5HTPq4FHUXhSrHhgiHB4czvAuM7bfeUHoK9hmO78pmQY7spTMIc6WXLFzF+AVW7YgDPdnZDH7whSyi3LQfSehpyiHAt3+/LJGxJxfuudIcMZVPZ41lE4gwUIzdGcGG45hAf7nEKMOHfcUKmnyc37nAhmKzGxc4ZRFFIVUnIC6+9s2XQtKqz191bjQyyJ7H99//gcIQf8sDQ21p/NatSFL0Cka8hSX7Zc0/vK
 dnukCvGi
 EwkTqTRsXQEVOXd78i+/ihlAeCqlAtWJcMhXWAvBQkISXMOd1a9BKkefn0Z7UI/x+S/sxuDhfzqX4itTPXwogSUlEaQyjmus2Uemvxvahxyky82Egtgjchw5X5htsERxghmbf/OOLfsiWolY2MMzefVu8Prq0hF0raNiGjmndqOYrAuzWqtCz5CHu38s+nae0wBJFB7IbOGm4/jMNKx8z4VxZzR0e0wSFFbQuerP+y+IQNU9gFwjwVQ089bPcPHS80YSLAfdHb9SeDBmXnWJWtzOz6Lis1YEES6orr6kp1OV+wJNifhjwprMMkunjeBMESqi0ycXuRJOO3xOqZLehnwIyaZzzvfgtAUpmVqKX0kP5Dig+vTZj4duT7OBZ/12ek4GYTF8XBkrCh71hLFiDrkZZ5WwbsKXwhiwNUKqbf1kY3A98uptpw2+84uT1EzZRTxD71zqjL7yrSLTfuYxWGNVmBsOTamnCmo8ObkhfSBuoaSXgUYrCKX8O2AJ6hFvZIzV8ZpX6N0kazM4s3/AO0feYd24/XjDV2KI7e3jl+Xd97xJOkAc0YG6QmFOjCvl1f/0UGK55epmqKijm0lLnBsbalSAQg7GbCcloZ68LYL+K6J0bVUgqdhPD3Jzs0hVVDlnNV0XjFUhpGhU714tlCtLQ9b9631qUofoM8QhlarADrgMU7xlkLz9BCNyBY9qLsXJU91Mwlww5rfSHLN6Oqj5oLxtKEsTwNkMLanT/0ws94czHRMw01Hgix0CUDPPfrnPQYQb45uwr4UJaFQsCnbODlbsJ4AZLQ8SaSbZaU5x5/U3CJOeAFBg2/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] docs: filesystems: vfs.rst tells callers to initialize
  hlist_node list to NULL
--

commit d7e2903820e76954308c4fadd359952c7070652b
Author: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

docs: filesystems: update filesystem type, superblock and inode documentati=
on

This commit updates the VFS documentation for file_system_type,
super_operations, and inode_operations to match the current kernel
definitions and callback semantics.

> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystem=
s/vfs.rst
> index 1824462a43711..da4aefb1cc90f 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
[ ... ]
> @@ -156,14 +158,14 @@ members are defined:
>  	for internal VFS use: you should initialize this to THIS_MODULE
>  	in most cases.
> =20
> -``next``
> +``list``
>  	for internal VFS use: you should initialize this to NULL

[Severity: Low]
Can file_system_type.list be initialized to NULL?  Unlike the old next
pointer, list is an embedded struct hlist_node, so initializing it to
NULL does not compile and callers leave it implicitly zero-initialized.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124223841.4509=
1-1-mohamedalibouhaouala@gmail.com?part=3D1

