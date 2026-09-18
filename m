Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BC29C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4347D6B00A3; Fri, 18 Sep 2026 06:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CBC6B00A4; Fri, 18 Sep 2026 06:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AE46B00A5; Fri, 18 Sep 2026 06:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17A06B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53FD280639
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:18:56 +0000 (UTC)
X-FDA: 85226484672.08.9B742E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B0E7C140008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:18:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=lj1qm4nu;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789726734;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5fb2OONy/GtAEA2nh09Nc6VmArU5Yo8QzF94WDuj7Q=;
	b=YCZuBHdPeFlKoQRpRDTqTSzBmY92aCOgKH8+HDhDkh1BBiyPSPM4r8f16dOvkCt6ivIfDT
	pREMx72qE8FLX7ZKxp8UyD9LymG36paBMQSSbsxNF1pvJA/1Z3htp+XlDwQPVRjcBZ8+4f
	P2xBnKLqjUbRq1XDgnh6JnFbntbPOaw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=lj1qm4nu;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789726734;
	b=Ak29nASi/JhE634Ooei06/N62dzRA2Ij1gjl9FgU7XUrgTOoP6kFWnMM/Rl3tfmx3mX4eR
	c/3STMvgC+6wTD/RN8RAYN3RBE4X9bJe1NQKwGK4SjU0sSP+JIW/fLLmao7T39UBy18ToM
	6Dvtmr8COPS/KrRa66JdkIf0OA9yBYk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02C8C417C9;
	Fri, 18 Sep 2026 10:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1441F000FF;
	Fri, 18 Sep 2026 10:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789726733;
	bh=w5fb2OONy/GtAEA2nh09Nc6VmArU5Yo8QzF94WDuj7Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lj1qm4nuzvY02T7ZQm88v8594RzQxLp2GRkXbWgVVtVBvfJ+6goLRgyhIpzhTJXQZ
	 2pCDF8LvVM9fJ6fKY4+uc/wQedLYCLDrjQbRopgkTtwyv4NIZXDsJsBsWAeToGhILW
	 qd7/SMXEZaj32E8uUi5oBjPfqyGM9+5tnt3G7yuecWX/qsPGerXYb2JIpM5s946iF7
	 yX0r6HiqXBjOBn9Vf8OIhbAyKlBkfCZ5xjd2UdjefGRfUDGraENXigs62wTGvXo/Nl
	 LkzE83NwKAHUJdQRZdZ5u09Z6Rm8qLlOmfxoay4Us/G2o7l2JK4cU7+i/D/m+wP5MR
	 vk5oADV1Jc8tA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/17] kexec: Extract kexec_free_segment_cma() from
 kimage_free_cma()
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org, me@linux.beauty, vishal.l.verma@intel.com,
	npiggin@gmail.com, sourabhjain@linux.ibm.com, lizhengyu3@huawei.com,
	dakr@kernel.org, blum@kernel.org, linux-mm@kvack.org,
	dave.hansen@linux.intel.com, eric.devolder@oracle.com,
	adityag@linux.ibm.com, akpm@linux-foundation.org, will@kernel.org,
	takahiro.akashi@linaro.org, bgwin@google.com,
	catalin.marinas@arm.com, coxu@redhat.com, zhangtianyang@loongson.cn,
	driver-core@lists.linux.dev, kernel@xen0n.name, kees@kernel.org,
	hpa@zytor.com, kas@kernel.org, seanjc@google.com,
	linux-kernel@vger.kernel.org, mingo@redhat.com,
	ritesh.list@gmail.com, sshegde@linux.ibm.com, ruirui.yang@linux.dev,
	jbouron@amazon.com, leitao@debian.org, tglx@kernel.org,
	chenhuacai@kernel.org, hbathini@linux.ibm.com, james.morse@arm.com,
	mclapinski@google.com, palmer@rivosinc.com, ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org, robh@kernel.org,
	linux-fsdevel@vger.kernel.org, maqianga@uniontech.com,
	gshan@redhat.com, chleroy@kernel.org, liuk@kvack.org,
	exin@kylinos.cn, "Jinjie  Ruan" <ruanjinjie@huawei.com>,
	mpe@ellerman.id.au, pratyush@kernel.org, ardb@kernel.org,
	piliu@redhat.com, maddy@linux.ibm.com, yeoreum.yun@arm.com,
	loongarch@lists.linux.dev, baoquan.he@linux.dev,
	mark.rutland@arm.com, rppt@kernel.org, linuxppc-dev@lists.ozlabs.org,
	gregkh@linuxfoundation.org, rafael@kernel.org, chao.gao@intel.com,
	graf@amazon.com, thuth@redhat.com, guodongtai@kylinos.cn,
	bp@alien8.de, pasha.tatashin@soleen.com, tangyouling@kylinos.cn
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-4-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-4-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:18:49 +0000
Message-Id: <20260918101850.7E1441F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B0E7C140008
X-Stat-Signature: n6myuf4b76y4ea8bkf4mzjfbgxf5ujje
X-Rspam-User: 
X-HE-Tag: 1789726734-487996
X-HE-Meta: U2FsdGVkX1/09OtVyNHmRL7ob3VaMn5QYHnUlrVcVsx4jeZQrMkbHg2Xni7HH7lNHNpbJPdTtIm6GAevCb0AUV/FFo5MaVgQyJugiaQxc2cBbqJc4Nn7PjX8GchZgpUMCfEW3pRq+aBlo95f/vRhb1Ydl78jv/BtUO1AH98uPWABnWz3k/XmSoBxA0IlBowDWCMLqUSg1662n0pAWjv7N1A/SxUM5+7P48mBr4ont2w/TRooU9EODlA4ENxMHp9wTNtjb5MbglXMGC2VOtzeD+lXUaogO4hTHSpU7ojZzSem6eISvbQIPRgLFEHXt4uucdA1hbyDutibSvyO1yoNIz4Spr2lXQgMBq9Iu3KV2kVdQGKwU8lHsNRSb0J10BZvO5/UfdtBK/5wwCabye8XeX7gqtOd4+XIUFqUSZjKBjLMHx/L8t6UdAtOrNJh3auIhzI1ZaOcJN/EFWuyUrxS+/qEcZZoj1+lgFJUykO7AW+AJ5Sn53faZ2aWkCe8/WX7ZKEWNQx/Z1MuuoorJrdllxgWXjGLEeN0+vhXzyvwv62hF2zFvkkTjkWT5PD7kuwDZRpzg/af14ImI1xdpFg6mIYR6cntgZU0BCtzD4Iosue0OB3ry+lcnUzUKWr4S9pbNSOAVPfKO1lgbUXunMXAGYROu0wbDgZnpooiHVLQHPiDm7dzROeQTWmBaWE7usOnxkoet6Vby8hb6o+HhZLHR3+wy6euXtlAT/vMtorE2aTme6hMAL+U+RAXCthU7GWGnH65cgaj/Z0GkIg90JyuxrA0GfEts1N75VdARvw12WMTltyGGhwsPwzmnqHWa58DEhMRNFarLUGlpQYFwsk/ORsVtQc9gq/QucrL9CdLe7fc6CRVoT8hDhV9zX58Exeqmpn5RK8uwdPstn92uGJGsnCge6tddpSSTk9pOJRK8ArRK29aAC3tjZil0AqkCzwRiWB2j3YrNmzV+JxlJ1R
 jV8h7n3V
 3GIaHnq3mqiozKopcu6HqrjBLN15WXcUy5gS0ZLBmgc0euPygPnoSkoTpnaoo9oIow517z0AWTgrH4nkj7C0s5NwcmH9313ToDBMWQEt5bSCgXpVgxijHhjLo/FhL/HmfoJIg8CsZGdCAXhH0KbHm4JFcLhXAVUu2m41fmNgwDEfS7AYycJyB5A5FPuZ1xymZlizHbIm9+8AMQwC0i7pAYHeAvAcN5TY5d1/7w+idfK73+hkziqp+x8tEYIG692aS+8VFyUJ2DKifp/5nekfjBO0GvZbqK07W2KSusFTDJ9k/TdIZh/zmEj/261fi2iZU5cFMhsdd1qc+tMIMVoR4lOjgnByi3K/HDsDax406K+H4RyQRRBzd/wdYpj8MT5O4UusxHxfCqJgwNqql1vU4hN1wmyWgItbOWQXnCZB4dCyzZaQWlhdH3pBTRL/ylFeefvZjpFXNHiHoulrVAaYNid1ZqBRhSVhw6kAq0k3zwIhfvqsw6Nv9lo12SX18/2kV2FVrp09tIhB0/UoRqeoYW+tWtIVi8XS+nyDgtKIyNxzxjjYKGR6C+MK2gVbPZCBLoozfimPqA4+4iq2gnv6szuTKOQzu5IYL3L3Pst+e5RkQAdQYq6PO7SRYDTUXnkpxGV7E5E4LCKrjK/JDkyruadsJyQ0dJKWDEX3EQyrN0HrZO0tR8I+vEzJlrAfkm8YCv9sNsb3HcNk80l7m9nBEH/inHttQMlw+6vqk0Idd8gE4BQm20XdOb1R5IKXMpLFGk1KceZ5i7yq2JQ56MBKaXu5YFqfzCwjJVnpPzDV3TSNipS+1uSWtLOFZwLWBfFATlnGopH4o2j3dbgvDwrk2lkk4/rH5ScK+FFVnBmrJT81ZTqvw/Ei3QILZ92e85tpC78yHCDMLJROTeLD+kaKj+4vFjg5g6hNl0JEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> kimage_free_cma() relies on image->nr_segments to iterate over segments.
> When an architecture loader (e.g., arm64) truncates nr_segments on a
> mid-way failure, CMA pages allocated beyond the new boundary become
> unreachable, causing silent memory leaks.
>=20
> Extract the per-segment freeing logic into the exported helper
> kexec_free_segment_cma(), so that architecture loaders can release
> individual segments before nr_segments is truncated. Refactor
> kimage_free_cma() to loop over the new helper, preserving existing
> behavior.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D3


