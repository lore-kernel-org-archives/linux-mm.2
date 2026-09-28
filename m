Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F12AFCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5346B00A5; Mon, 28 Sep 2026 13:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97BEF6B00A6; Mon, 28 Sep 2026 13:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B98F6B00A7; Mon, 28 Sep 2026 13:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6DED16B00A5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:33:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4B5DC0273
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:33:17 +0000 (UTC)
X-FDA: 85263867234.15.80FFF3C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5329240004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:33:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IA++G6Ke;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616796;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZAMQYYiiCkPWOPSajMdbfju4b+8ZMSrcWzT8+A/DzM=;
	b=lElq4xnD/373nW8+H3Nh6d/+ktgGJzvJAWRPy+AV62Q9aTC84NpB9ez6kO+43necbTWaH+
	8hvttuGY+qaHmyq+DvtgQXp6ik6MD50YPw8uOHJvWKk3OsUC4xqNoh1dJymYUHyZsi/GT7
	kQioQ68OkmER6JsAOdM8Od01JPcGdOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616796;
	b=QDw3MAdR5POmRRctShgkI9z6eJZCT1abspLu+y3QyXvMAjEwuKPAS9HieABYAMb9RZHsOa
	1MO9QPJbzdGEpaUTe7KGIAwRSv9X4QkEYx3Ff0QZvdZBPVId2+9OE6iIAg/tbV2YLtnPrq
	3OVRzsc/dYeiTjZQtnBG2a96fdVoVYY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IA++G6Ke;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 726A160120;
	Mon, 28 Sep 2026 17:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338DB1F000FF;
	Mon, 28 Sep 2026 17:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616795;
	bh=ZZAMQYYiiCkPWOPSajMdbfju4b+8ZMSrcWzT8+A/DzM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IA++G6KeWHo5KL4bWJkkW5kJ8rbX8uqYdP/N7/J6hUzwwPck9BMUiXbG7dv08mV+W
	 Mkhu7jYEAXKJ1jRG5xqRur6EpFCt+ugPjtVsCE3BOsuKgglOdOrcZwJpNzjmNxa6UT
	 bfZ+1lKO2H+JA+sQJJG7Wl/PBhYmoAXqnfUh7mH3/dnQ6oqK8J2Btnwoc3gVO1El+C
	 /keEp2AcAZTa6AinGiweR+Dc6hX1maKvscK9nl2GolTZI4w+ybNzA4vbF/5Vb0oA0a
	 OrXVKvI9dafmHTw4WBEi7Zkl4TfykIjBJ24IRHEjZfvg+S5xDuHTslMQXkC0rMMmKV
	 /9b/IY3S1qSKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] kbuild: Mark usr_gen_init_cpio as
 no-dot-config-target
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VGhvbWFzIFdlacOfc2NodWg=?= <linux@weissschuh.net>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>, "Nathan
 Chancellor" <nathan@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Luis Augenstein" <luis.augenstein@tngtech.com>, "Maximilian
 Huber" <maximilian.huber@tngtech.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Willy Tarreau" <w@1wt.eu>, "Alexander
 Graf" <graf@amazon.com>, "Nicolas Schier" <nsc@kernel.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kbuild@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, "Askar
 Safin" <safinaskar@gmail.com>
In-Reply-To: <20260928-move-gen_init_cpio-to-scripts-v4-1-f437a33c40ac@kernel.org>
References: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
 <20260928-move-gen_init_cpio-to-scripts-v4-1-f437a33c40ac@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:33:13 +0000
Message-Id: <20260928173314.338DB1F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Stat-Signature: 1ub3wh8453c33s8wew8i5mp3inrtqq8p
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5329240004
X-HE-Tag: 1790616796-981386
X-HE-Meta: U2FsdGVkX1+4fej+caIqNHfImTcfxAzM3rKXwT8VNzFy66FRSsTul0qvH06NcZS6CBImj0giNi4E/xq/WmIZxRUxEpEl7wUXf5v1cdLFq8GyOX+tpbDR16X5qggtdrfFoR2PA1Ejw+jcshq9qV3OX0kS+6M8Ib9U/8zHnZ7+FYysHOBrxXmUmw6JFgwuUtXemdm1csVTSTdAW0A2xW79DZI4Ez8kkE+zaxz4m+RT/Tx965/JLUyJfXMst1jMggDtXV+5UMoVtzYR8q6z31S3Q8B3ZhBVtbfaY3GBFIUY4vKDUirlV+bodEC2yknUPCY8+Qr/xmzH4h5qNKNPo7WGJ15siDFVxF3r96y7ZeRE8A0eRbVB5OHMBnmwGszfdRPVqDZKoWAxjyOKjclM9i1GF2Yc/mifB9mmTrKEIyIYN+IBzIiUci9g8ia6KQYj/4tVcfoZyvO2/Tzglt7/Yp99pu1neGxIbFJjG8Qqar1p9eqat9ZThi6bBPNHQMcCXNUj5BQa8AMpVj5lmrwEd2LAxjTelUA3GorT5JoRtGKzo5IvvjEjonIXxDVWZCfWp4FDbrl/4isNv32bIciQRJ2ell0poSCCAK524+oKg9HghXK01p9AgVgg0xLnNr9yJVfYsNvnOS6Jcy3k9jeItvHAX2R69kBBFdhuX1xzUrU6CZgTAJ9EfvebdDlsW0C5gJkfNTrMUnNvTjYON5iBTo2KN+4k3GpFD/fdMzISLt/haU4sEYoaX7G4bA9H44+WSAdlay1RxVW7Qn/Hs2x5Vp8rASxsC1iNkWIjNOCIBbwaCMSd+dAJRmWeTKipr887aMsVotEyKXQl3hqkB6ShGZ3swH+au/Y3aKfED1x1PtCYlFpTLn7bLQevZTZ0t/Bm7/6grvdghFVWGF9nqMq2rWy2p4u0vipUi6Xd0oWZtLWjdDtol+Edk7+ZyaxEaG1YNtYHGlsdxYlpfvIxj2HNpd2
 QKpYfHKt
 8Wnhme1ROZm+0sLFZigaUZ7vw2hgRGjiBFrr+AFCju9RVmx0cohiMzi3EW2KlsQ22R73yqafrrwS0eS0LXTxBIzOpuNcbEw8K2Ab0F5KPAryZ1VXlKkwA/gIWxebVNxCk0Z5YX7W4vybGlD6rQH0/BcxLffOibJyEmxak6kst+0asqauFFHhOimOj3En1HbvDAG4kYIiK0TuJfkkFrJ2nbEL0y3HdXPSdg1Hw7iCIIiVp1vL6e5jTJ8ilxOu/6lJwUHEZbk7mUHNJaNHaI1ASgOmj+YZ5IjPemjmDBRXiIbY0k668LtUxIqaHKVIaxswgqNB5Q0OtqyGdEb7wpqR7yqenk70tUBtAQcTXwnY+9zKtfGxJLSYOm/N7BZpfIWPwCA/Afg1j+xUImULdHJYGuM9ksKTf3lpKZykO7tmXbUNK6ggigqUUsMn0lwLy49sPAjbgpvPY0GgBOFuljWldhfctQEHFgxwCIJJ1iQKqlGsJ/o4vR4PFVGdfWptp3g+WWIyt6MP14tSNIVBeNGZti+7T1ydfbyu+kRg5aE2bhD3a8vjEpfusOLecpFEWqhn/EFfLJGTI16Q9P6C/ub/kQZLanpJed8NOHNtCqfqXrZe/vC2TEsJwH+2e6bJWqH+MjayIfgY43BY9in5QB0U7vfWbB0+zkkyKnPG9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Let usr/gen_init_cpio be built also if there is no kernel configuration.
>=20
> Askar Safin reported that gen_init_cpio may be of use before any kernel
> configuration is available.  Add usr_gen_init_cpio to list of targets
> that do not require a .config file.
>=20
> Reported-by: Askar Safin <safinaskar@gmail.com>
> Closes: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gm=
ail.com
> Fixes: f8e05c10631e ("kbuild: Add top-level target for building gen_init_=
cpio")
> Signed-off-by: Nicolas Schier <nsc@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-move-gen_i=
nit_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org?part=3D1


