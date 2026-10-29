Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB296606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WIvSeu0T
Received: by kanga.kvack.org (Postfix)
	id C20AB6B05B1; Wed, 28 Oct 2026 22:02:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1B76B05B5; Wed, 28 Oct 2026 22:02:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8776B05B6; Wed, 28 Oct 2026 22:02:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BAA66B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:02:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06CC18029B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:02:46 +0000 (UTC)
X-FDA: 85374015132.20.8D2A751
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2FF0C20006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:02:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WIvSeu0T;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793239364;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgvWlnWFppEnT1CoCTYoqGmvjAB4fbAjntbvbb4Z4i0=;
	b=hd9lAAAzkHQzY7qAqL3v1DYwmL5uZDsrI+Twz5ppVhbyPt9fCRFKxI5OkoDyYu5ZOY+y43
	DCbvix7jPu5O86Bvo21Y3kJa6mumRO39O7gjRV7NoQOfafksxzgktrDsbn2p+TNoZcT4i0
	wutsVtFVeHyv4DyVSDY24DcywSHR45k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WIvSeu0T;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793239364;
	b=tBBMbEbioY8aerSOcCou+vWbXNYh8mxUacT7/yqp4A9QcaRFLakAZY0IaXno+n8bAVTWaG
	gg2qEcW/pllXtAnyDui1AgNTfpxq7twUh3sc7+SoYqZqYqg4vpIZz2Eqv/cwjhwJmxHGXG
	DGPR2LT/ulpl/eJuYJ+9AAvb0pr9pN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C424640F00;
	Thu, 29 Oct 2026 02:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F61F031E1;
	Thu, 29 Oct 2026 02:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239362;
	bh=tgvWlnWFppEnT1CoCTYoqGmvjAB4fbAjntbvbb4Z4i0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WIvSeu0Tvx+LeNyQgMMt4LthVOnp1EQG0LopAFXH/6DEbtlehnx8zCjdP6o8aAk+A
	 enOu/ge+RTZkAC1WA0s/bIlovpZiI3IHXhYgAxVZmuXsa7q+Ppp8QMR2lbNwTYVLRp
	 EDcWQ0AoFRJ8QXcsx9BAbKqpWFdmDc+fcOaUPdZiC08JpegemntSPM28Zzvun0WiFf
	 3SY/q+KchD973cSumOZKHjKkqwmhcZSrqOEMjnxaJFTXsFJq41ukD500jCmX1PyIAu
	 /cZQaHhaTm2c0MtVR/ZNPJpBHiuxP7ZWSrQWI8chzJbrPdhudej90PXgizxmvkILzk
	 axorqdNxkAo3w==
Message-ID: <sashiko-outbox-188628@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/damon/tests/sysfs-kunit: fix leaked pid reference in
 add_targets test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xiaolei Wang" <xiaoleiwangxiaolei@gmail.com>, sj@kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, error27@gmail.com, yanquanmin1@huawei.com, wangkefeng.wang@huawei.com
Cc: damon@lists.linux.dev, linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, "Michal
 Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
In-Reply-To: <20261029015725.17378-1-xiaoleiwangxiaolei@gmail.com>
References: <20261029015725.17378-1-xiaoleiwangxiaolei@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 02:02:41 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FF0C20006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: nsxemwsdcf3qb7ebjq6s3ri9uc8t8pgi
X-HE-Tag: 1793239365-199681
X-HE-Meta: U2FsdGVkX182BGzEDumq9wIFRGXGBs3ft74bf+P82E0Ig93aMnmKgtlAlJ25FQyygqU6cg/C1/6Spr2amVrOaRypb2XmD3mdG0i09J/hZY/AyfZDaK019AeGyp14jj2VWh9+gRhRfYc65VC1+PU/tmVjWVHtv3mVUhbml/s/gLurO3FPGw/k66bh/PqA8Q2JlJGbsiBpdsD+Wjc/9DEIIB1A7eQjPFOlbpCRVjfb/RE79ee6qOIsZH7i18itRJN69jJ9EXomuTgkuoYMHH/n3e4x1FhVSAHusyOMtzliaOSpdm4uh/Z10aXloNxxj+9b15yj50F6U7P3lC1XxJUTPJW2f/TFnHDXcnL8JqRdYlN1Hbutxno/uOlicNNOIPKRzIkSZ21vYwbUa6WL2GfkfTPxrxwV+c3jI4/sXeXRSU1qD/S6xW70Ebws33f9QL8d3dIrZXs/1LQ2NrM3eddU9MxCoht/EFRZ9NIdq7ROMr3Db5s7sro/7B/kcUwyOGPmiIbxDMaRLKy06buOBhmBgjyGKfw6X7AgwsmZmdOcD4sn0b5qlTgWL34srn2L0hpd4+MEqz+GIkYFV1uZ8CRe+Dm640mRzzaNzeQAZIiE92p5hHRcLGRwiUgNUSng8pntfWB1n8WVW/8PhJEynTwCI9xEjX8M8FI48hacTtDagTSMeBLD7+HuVdWZyVpCjer4KWde2zU2bhUIZH5MCKcO6vU9/h5dBYx8iIlO2PjNw6FUH2BOPdyrXr6iG9jTGa//wPv2DFp1YRBkLUPSKKrNbMGyk+iuvZm4G2Zb/5tQT4Ms1OUfjzIBbXEkTkd825jZIC0us5zwJAjXfQx7Mq4D1rxg7PerUWms6QcCl7mLIpEdnY77JcrR+j1PgxTEc5uKGQnzarVy6roRTmLdPaY4nsqYIKIsSoR0qzzhpcRmTaTF6nCb2XclwJbD5G92nyIexcRzTv3iBwPU7W0oeI6
 VwLPpDUE
 1ISTAd8i8H/sGiy/9MogWKlPzcDa5oexUbPiNgOcJPGaXpO2fG5SWwf+3JsaMl4T1Nkwh8VJMwatazm282PyERZ6nJz1Lu/Y8+Q767WEEod+BbmcUUFRMgv1F4+pUCn5D6mucSAAOPuk+L2/djKp4i1Q7d7ftQr6XClCiACKeMn27tLHK31LJmMZo/lt7KUZhrCWI6bV3OH1KhyNsxqPB2VBancKRIwKjWIYnADEmguf55InQp12Yn7CeyIGUIDAg4Dkr5QxZbeUG6XT4/3u3D+bPvS8fK3QoBIjTzqrKkARxaqJh4Xf2d0Vzu+HFMzKuqjuhfXfvLSnblwWiIGt5rFYJ0fiPSq8qWWq1Q6/iCxUbf3ljKdkCoKKHywSbJkPCBrbkVUj7z1GXCx3HuHY3RPwL3j9Fpo350++O3erwwfkjlwphTLR72zFWFefzOnwxJlZL9BFZ9tB0z7sKCTXY3h9DYLHr9o1mnQ4YYZmp42M30vvddD4Vlh2C9UYd+pBY8k0jIB2lL6aaSQr0ZM0smaVzTk2XstL/0psl89Fl63LeesTMegm5864xKxMl9dLorVkV0f91caWK4R3Ofzt9r4+YUBo2FLsIukz4CZClPj2HKRlo0HdHqoxmL1ARQygavyT4ubGKwF8IBNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/damon: memory leak of ctx in damon_sysfs_test_add_targets() o=
n skip
--

commit 15e9d751202cdf7c593524fe7b4266b6f6dd0dbf
Author: Wang Xiaolei <xiaoleiwangxiaolei@gmail.com>

mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test

This commit fixes a struct pid reference leak in
damon_sysfs_test_add_targets() by calling damon_select_ops() to select
DAMON_OPS_VADDR on the monitoring context before adding targets, ensuring
that damon_destroy_ctx() invokes damon_va_cleanup_target() to release the
pid references. If DAMON_OPS_VADDR is not registered, the test cleans up
its allocations and skips itself.

> diff --git a/mm/damon/tests/sysfs-kunit.h b/mm/damon/tests/sysfs-kunit.h
> index 138a4b8d14e73..634387c6178b9 100644
> --- a/mm/damon/tests/sysfs-kunit.h
> +++ b/mm/damon/tests/sysfs-kunit.h
> @@ -79,6 +79,14 @@ static void damon_sysfs_test_add_targets(struct kunit =
*test)
>  		kunit_skip(test, "ctx alloc fail");
>  	}
> =20
> +	if (damon_select_ops(ctx, DAMON_OPS_VADDR)) {
> +		kfree(sysfs_targets->targets_arr);
> +		kfree(sysfs_targets);
> +		kfree(sysfs_target->regions);
> +		kfree(sysfs_target);
> +		kunit_skip(test, "vaddr ops not registered");
> +	}

[Severity: Medium]
Does this error path leak ctx when damon_select_ops() fails (for example,
when CONFIG_DAMON_VADDR is disabled)?

Earlier in damon_sysfs_test_add_targets(), ctx is allocated via
damon_new_ctx():

	ctx =3D damon_new_ctx();
	if (!ctx) {
		kfree(sysfs_targets->targets_arr);
		kfree(sysfs_targets);
		kfree(sysfs_target->regions);
		kfree(sysfs_target);
		kunit_skip(test, "ctx alloc fail");
	}

When damon_select_ops(ctx, DAMON_OPS_VADDR) returns a non-zero error,
kunit_skip() aborts the test immediately without calling
damon_destroy_ctx(ctx). Should damon_destroy_ctx(ctx) be called before
kunit_skip() here as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029015725.1737=
8-1-xiaoleiwangxiaolei@gmail.com?part=3D1

