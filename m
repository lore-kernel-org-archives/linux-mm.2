Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E37606CCD0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d6MT47PK
Received: by kanga.kvack.org (Postfix)
	id BF37B6B00EF; Sun,  8 Nov 2026 20:28:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3636B05B0; Sun,  8 Nov 2026 20:28:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8F56B05B3; Sun,  8 Nov 2026 20:28:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE126B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:28:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A1E34053A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:28:28 +0000 (UTC)
X-FDA: 85413845496.26.D29F515
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7201840008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:28:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6MT47PK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187706;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nyw5jYEPKA/70cvicg5V41eQLNfCnLZDywD0sGaa0is=;
	b=WXXe6MbOKgwXXiPc1YDI+nAMq1cxtq6ey1D2ELemWruh2AVDXTrNMWTr79KEfVxxn5rsJd
	c1uOuftuvRyC+hpDJxBZeJyxZGuMAL/RvHSwStAfd9BBUDXTOFVrZUWbxmE39MOeLpJfLW
	BpgpTDL6GNHsF3TGocyoJ/fJGbBnF08=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6MT47PK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187706;
	b=CuX9e27Gxzak7d5KSFWA4c12JUGDoI8bME780S2Y6bxwpktgKIlbryys/YMIFpg1QdjD+U
	nThX+IxIEccIsfQiOrKVpLSMkLE8AM24P08OZ+41QHjPMql84LJ85INwKJ9HE02KbCCPJW
	depaZddPRcTvAgOwxTc4kBWL5OO3b+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01B8161EE9;
	Mon,  9 Nov 2026 01:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9211F0089F;
	Mon,  9 Nov 2026 01:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794187705;
	bh=Nyw5jYEPKA/70cvicg5V41eQLNfCnLZDywD0sGaa0is=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d6MT47PK/nb0gL3PL+V22I42qqTQfK18II2EorZdzWHtojpJVZNlWtmQ+37mUkYjh
	 Y0yWccuPEEhF5tSrmPvN/LCf4LMchXvSIDvncOT18JQdVtT7fnb4xb8K1xVxyuNIQx
	 z7jkjqA/+P5njS7ATivkITJ2zPU4ghBT+ch/3cCLYZNgJhxUHha8Vno0np65eZ4KmO
	 Whyeu7/lP57xuQVshQ/QgbJoqL5glCaG8C3y2Q8l9DAAZESglJk+cWlWNYXq62UswQ
	 DBvq2G/j7qkKWaFaKr8uP8K/6YtGEpQhbdCAROj4NQYfqj9nxs5+AluGU43PpaUZGZ
	 i/37VzwSYk6BA==
Message-ID: <sashiko-outbox-204294@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12.y v2] mm/damon/core: handle uninitialized
 damos_quota_goal->last_psi_total
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Higgins" <brendan.higgins@linux.dev>, "David
 Gow" <davidgow@davidgow.net>, "Quanmin Yan" <yanquanmin1@huawei.com>, damon@lists.linux.dev, linux-mm@kvack.org, "Lian
 Wang" <lianux.mm@gmail.com>, "Kunwu Chan" <kunwu.chan@gmail.com>
In-Reply-To: <20261109011347.92467-1-sj@kernel.org>
References: <20261109011347.92467-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 01:28:24 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7201840008
X-Stat-Signature: c15gfcm4to461ttr7m7w5dpmf4ujizge
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794187706-835613
X-HE-Meta: U2FsdGVkX18BlEqkffNzdSj5Uj5QKGEo508Hlb1LO2p/PLuZkiFJrMQH1C0tw9fdb+t/NFGq7afJNeVG49t5kR9QyjuO6wf9mWbsomQju156mR9VETb+sjHtLeGPSieIYXwgrXo4HguUmkJ/7/uLZP7ZSuHG1nHgeG9UVs/spXDMulowivVtRFGX4QC0/NlyGCVN6nLwa4+6bLsIz1soaNaMML+Ha10Sivbet2xVPEyeCakJ+ltPHEYIV2G3d2Z7g2q2nG2aMfKXM0ERCBo33IfHWxUVmGPqG+e2jAxABBJDmByk3RgqPiKnJH+DdbK5H/oH7f0c9aKWhakaJ4LzwxVJ73cMRd2iAnX655eqBO2z9NnJYhn6ng27LCEGMbovD+joV8K9tiyYWIqn9ZyM3GA5Pp8FOcrJYnKUhKeugxxddlI/WEuHQVtbb4uzMXlqXwYpeGPmPvN3GBe4vf3lYhk44cDk2jEz9z9x6LV7LXD2iVVPhWKvIMreHuj4qjwmao+Wx9IcnFa2roGFUirL/xjgn35zDf0qeKPS3uaL1qvH5ANS/MVCn1FB1QwgMJGMopbHBxP2vYdDqzXExSR2LUyxzfs82EVLvS+zVzZZL1KpfdLWt7FRKVu4FZt7MC9ydLG92r9eTAB55PXHpVvAVtqZY/Jvg2gAZXUvdBwHoIgLm8InEYHtqgbUNGUKNBtbPbdQGXzKkZNbp+C8R+mU83DQLFY8C58cC+xnniTdt0am6csuREBik8O9+l7/cAThC2tYWACEaG7jT617K8SINZmZQbic0UOwp2OjXQZfMDcJ3/n0jwRSwwCNQL6+mwKsYomaI5U36amlIy4eG4z61LQCilMKiSe4FYoVsHwFn4un4ABfL//dyhfXvzWHRLs78hkewVEuZxlBZlKI8/QQ8nvpC+3+QvmBFHnXjWoZmwUhOKTMV4hfutuvdo1LcWY1CD+A0K0OXrSO1X3LFEX
 5r5AjVxT
 0mI72a0D7gdhbKAf/h9MT6e8bEGfkNlTufle+Acv08ZP4aZ757iUrQF1ccANYSVNInRzta2Le0iobVDoojXkPCCzVi3otLwf2p4WqpP5+1jRH7+BVmnm6m4JhbyABt4+U87h8ccJGh+hul675G7nESHP2vAfIWWcKrerWV6J03bePHMA/TVdFuzc9JIkHU0kPYw2NVpeGpDPAirHrrLywCZWSbfqlVKYqBXyuiFoRjkXCEF9hY9wNM+/V7AeIBWHqjqmu7ltkyMLCuzxyxFl+I1pSNmy53vAu+Nm/YzjSgTj9HPghj+FRu2Ii1DSr4VdZaazFjJTLxPPmP4dRvtfN2GpMFNwV6/XSvNDhBHF/nCUQExNeFrK0JpbLPG4GvJL82VZO+sWk2tgIqSScKQ0ycA2hHzKzINeq7kxgWKzI09yp+6DR1RBoasDiStVryr1beWD714kaJ1B8qnURSb7ejYnvAHsGtGNBmCTym6nXocGTx0U42pnerSTH0P4DKx6wFzax1xJT5ywNfr+JQ6wwhO3yD6sMJ9SiMGXmyZq/fP6/mtb5PF0dy3o4+f3SM233nVxB7ZISK4Zd9+UkQpSHc+Xi6qp6s2a0dLFNghiitlM/parI6L0l+Msy7XkdNoqD0Ql0lVaOKWC0sIy5S5QoWC5ss3j+A2CWg21VSRYS1KoN50UdLcBOoHrkWgYUZoir0wcqNrCWkTPjGd8=
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
- [Medium] mm/damon: integer overflow in damos_quota_score() on first
  PSI round
--

commit 5e9b1f636c184ecf41e05d717ad5e0116b0fca20
Author: SJ Park <sj@kernel.org>

mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total

This commit initializes damos_quota_goal->last_psi_total to U64_MAX when
creating or committing a DAMOS_QUOTA_SOME_MEM_PSI_US goal, and sets
goal->current_value to goal->target_value on the first tuning round so the
effective quota remains unchanged until a baseline PSI reading is recorded.

Link: https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org
Link: https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3142776e2e0ee..420ef0adaa7e3 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1616,7 +1619,12 @@ static void damos_set_quota_goal_current_value(str=
uct damos_quota_goal *goal)
>  		break;
>  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
>  		now_psi_total =3D damos_get_some_mem_psi_total();
> -		goal->current_value =3D now_psi_total - goal->last_psi_total;
> +		/* uninitialized last_psi_total; make no effect this round */
> +		if (goal->last_psi_total =3D=3D U64_MAX)
> +			goal->current_value =3D goal->target_value;
> +		else
> +			goal->current_value =3D now_psi_total -
> +				goal->last_psi_total;
>  		goal->last_psi_total =3D now_psi_total;
>  		break;
>  	default:

[Severity: Medium]
Can setting goal->current_value =3D goal->target_value here overflow in
damos_quota_score() when goal->target_value exceeds ULONG_MAX / 10000?

Unlike mainline where damos_quota_score() uses mult_frac(), this branch
computes the score with direct unsigned long multiplication:

mm/damon/core.c:damos_quota_score() {
	damos_for_each_quota_goal(goal, quota) {
		damos_set_quota_goal_current_value(goal);
		highest_score =3D max(highest_score,
				goal->current_value * 10000 /
				goal->target_value);
	}
}

When goal->target_value > ULONG_MAX / 10000 (for example, above 429,496 us
on 32-bit architectures), goal->current_value * 10000 wraps around and
produces a score below 10000, causing damon_feed_loop_next_input() to
increase quota->esz_bp on the first round instead of keeping the current
quota unchanged.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109011347.9246=
7-1-sj@kernel.org?part=3D1

