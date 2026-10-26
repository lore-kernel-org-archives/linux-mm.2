Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD31606A326
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ip6XgOhe
Received: by kanga.kvack.org (Postfix)
	id 50DC36B05B4; Mon, 26 Oct 2026 10:11:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7846B05B5; Mon, 26 Oct 2026 10:11:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC796B05B6; Mon, 26 Oct 2026 10:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15EEB6B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:11:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 862D8C0756
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:11:33 +0000 (UTC)
X-FDA: 85364965266.17.F6E37C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EE2BF14000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:11:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ip6XgOhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793023892;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1z6uUx4ZdMo2N5+aoAcDCMioFr0x+B/lAmEEynuZSk=;
	b=ReiMZnIoU9qJdb+VInS59gJxMUz0W6TniOXgmNdFSLgWcpFYwhdQEoncfxHk9x8/h4I/jN
	LBK/d3a9cgqZmoK32Wht1B6nb0kVy588gtrRqxJV7IXbboqRuLtRugmWlul2yOB9rWuj1E
	qspnFCFRseiQaAoAoz1h7TxaLWXQDxI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ip6XgOhe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793023892;
	b=mwAuBaSTLxF1va5xchaxy3OQ4YH75z10CW5wW0uQCk80VZwQ5kdnmKd+F5y5q0fNsZVVRf
	2+TVJcKlDAZijCskCg6CSSV2NQ26AfO4laSOpUPK9ItBP+fuv+7xRnh756WfrQ1ItTK2bG
	YnrD/J8laZnx9NZunFym2qrHJWhWygU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74C48600CB;
	Mon, 26 Oct 2026 14:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F2E1F01828;
	Mon, 26 Oct 2026 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793023891;
	bh=b1z6uUx4ZdMo2N5+aoAcDCMioFr0x+B/lAmEEynuZSk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ip6XgOheGZu2j4YrE8jAzgPZ+SjimhRitLbh3QzOKUEj+yEGJFz5C1OwMD3qz+TmB
	 GelXorRMy2PlR5g+G2HF3N1AmCrdiT31xCq9bxJM/fbDMc/Z0EAqk//AnJrRD1Fi+O
	 Q7UPbG7iR7uTHL+kxiI2b93UptBMFo4pX46xpWl3XEnKG4PzmZVSGTymS9keFynLoi
	 h2/DtRx4PzAoC2mXfQEiUwcgChce9ee0M45wTnCnt90NlorIu0e8rsebicIhPndvqN
	 SvXAJDrUqSYKmoDJ4UUF3806BPUYOV+3jl+qpJRRjZtkBcClc65W2hEFdmJCl5JMR0
	 rCNc8R9OYEA2Q==
Message-ID: <sashiko-outbox-185379@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6.12.y v2] mm/damon/core: error
 damos_commit_quota_goal() for zero target_value
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261026135555.149244-1-sj@kernel.org>
References: <20261026135555.149244-1-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 14:11:30 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE2BF14000E
X-Stat-Signature: 1jdy83ihiab77rf94r6a6gmctafqtow4
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793023891-934196
X-HE-Meta: U2FsdGVkX1/UAGeYewMUUIEMZHJjtnbOhGPXOoWa8zd4kMedD3ef6QD3DGs26jM8hy7MdbiIlkogRUJruCZtsyuJ0B9TFasxwe5b+5pZiC3lihUwxrFzIK8EUM/rXfNzof8dXsFO9LWuZfJBXxbVTTfbAtlemkM+6ydL2QjL5+/Gi4R75xnci/ea9mZvnwbIKlS/L0u947PgIzcVx4dHL9Btth2NTa3ISzZqnzrXTBRyJejdXEJwXuwxZzGd7N9tAdCPbIJbHioZIcT2pFSg58RQ44FH/XgTmCoTV+zbvmNJWYoTg1/ZTb8SRbp+buzZD3e8iM/9Oc7A4+PCUHx+r+z+8j06zf+Of+26Ks/iVxM2b8exF2GTW73YuAVgPLQWIK1k5XGQY99Oipupm4BJMI7G8JxOOI0MUm+NEKjTaYuRnyr5FYUWjGTlj3GpiuzNa8yeCKk1lj6YVZU8n1nLGdKQr8HmNjv+gIpz/qdnNMVnWgTvhmUbqCw+0iz3AFLUuMBJUOjNLBYQtW5uvHIIc/SZD4Se1PisavDCLfNuWG7CtSvp71NQ4Ps0LfjuOozS3Fb11PQ4+9uOwMQX1YwPDPGZFBZighdTqP4g5P317StlBB+/BaOH66NoHLdMHlYp+5y2aEPlelCWcxgZ4amwIjdAW+/JVFSbnRKG4cxROSS1xL5jbpz9s1ZHrZTN0zoDBxBudBmR017Nl/Iy6JyQlCxcUxpJQKVBN6Qzr2qT/LDAW5REjWPOmQKWXCd8HNtG43SMxzISfP5dOAuPF4V8ol9q8GNFZc5YaI5f6NAsPob9dheb2H/ZS4qWqg+o/zkC10FwXPnXXyGYbv7eulG35G4zKnj6HZ0Xo8Yhv6y+Y1K9To0376s2+wqJidZlGkUHRxK3Y5MMpg+onQWwqNwsW0K9XFoYOVxcFXLlGeXEwBs9IEVT+IdmAPGMuiD2nCgG5+jZkuBDYWYhq4wfC2R
 N/hfy/tI
 BIG0lg+dq7cmZrFbsDDXB8xic7xB7EEoPFx3ZLLczHxi0cwGS/qU/zPuwL8l0DzEK866DmajAxw2hzt2uQkU4TNbxNFAur6sixomonq47upbdzLmMLgVmteeGuIC5qQAMv9qwChdlPki4TYSXmQG2o7uXyI2dLtBMaXQH93JESfUHoRLa2tjK/3CsAspdS5150sDxLB1NvJhak1pODafmu53j1BdPfcNlffmWLsmCWalcudfPUTCE5GddDRq20l7baCqlD2VD3V1o8Bb2Se9an8vITvNuoKq4p8hKhFb/8ngc6LGF/vf95LgVxaFrWMfNh1qwsIkqUoybrkOy88/iRk0ZfcYxWjvVw+5wHhpcQ248jCYD33v5QA8NAnmLRTh7EGaJCg30wVM5ZpjzWiQq2DFS2USFUg8EBbGVqkV5BQlUIfQ5sl2NVqYQ9nPSp+NnNRM1HjxWwd9EHbIPsUtXbbDNtH/4FeLqXInjCN/mUCouat5QHvLuu5JdvpZEzCZsuVPKe/QXkPzSYSD6o5vAb0AZrTsL6uNecoMDt89GWU5inOowAT371rlgyU71KhSbVBS4xeZX18f2WtHH4Xo3ZqzG/hOU34fBnvII6d202GC7Fm9a71N9y25ljFw9A+Mnb34X
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
- [Medium] mm/damon/sysfs: pid leak in damon_sysfs_turn_damon_on() on inval=
id start ctx
--

commit dc23c827b1a01b5ed768b0a218bb6a67def40106
Author: SJ Park <sj@kernel.org>

mm/damon/core: error damos_commit_quota_goal() for zero target_value

This commit validates that DAMOS quota goal target_value is non-zero in
damos_commit_quota_goal() and damos_commit_quota_goals() to prevent a
division-by-zero error. For the stable backport, it also adds
damon_sysfs_valid_start_ctx() to reject zero target_value before starting
DAMON in damon_sysfs_turn_damon_on().

Link: https://lore.kernel.org/20260903010722.94244-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010722.94244-2-sj@kernel.org
Link: https://lore.kernel.org/20260803134034.15217-1-sj@kernel.org [1]

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 5aa23c6545cb8..2c8749b62c621 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1497,6 +1497,20 @@ static struct damon_ctx *damon_sysfs_build_ctx(
>  	return ctx;
>  }
> =20
> +static bool damon_sysfs_valid_start_ctx(struct damon_ctx *ctx)
> +{
> +	struct damos *s;
> +	struct damos_quota_goal *g;
> +
> +	damon_for_each_scheme(s, ctx) {
> +		damos_for_each_quota_goal(g, (&s->quota)) {
> +			if (!g->target_value)
> +				return false;
> +		}
> +	}
> +	return true;
> +}
> +
>  static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
>  {
>  	struct damon_ctx *ctx;
> @@ -1517,6 +1531,10 @@ static int damon_sysfs_turn_damon_on(struct damon_=
sysfs_kdamond *kdamond)
>  	ctx =3D damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
>  	if (IS_ERR(ctx))
>  		return PTR_ERR(ctx);
> +	if (!damon_sysfs_valid_start_ctx(ctx)) {
> +		damon_destroy_ctx(ctx);
> +		return -EINVAL;
> +	}

[Severity: Medium]
Does this error path leak the target struct pid references (t->pid) when
damon_target_has_pid(ctx) is true?

When damon_sysfs_build_ctx() constructs ctx via damon_sysfs_apply_inputs() =
->
damon_sysfs_add_targets() -> damon_sysfs_add_target(), it acquires a struct
pid reference for each target:

mm/damon/sysfs.c:damon_sysfs_add_target() {
	...
	if (damon_target_has_pid(ctx)) {
		t->pid =3D find_get_pid(sys_target->pid);
		if (!t->pid)
			goto destroy_targets_out;
	}
	...
}

Because damon_sysfs_valid_start_ctx(ctx) fails before damon_start() is
called, kdamond never runs and ctx->callback.before_terminate
(damon_sysfs_before_terminate()) is never invoked to release those
references. Calling damon_destroy_ctx(ctx) invokes damon_destroy_targets(ct=
x),
which frees each target without calling put_pid(t->pid):

mm/damon/core.c:damon_destroy_targets() {
	struct damon_target *t, *next_t;

	if (ctx->ops.cleanup) {
		ctx->ops.cleanup(ctx);
		return;
	}

	damon_for_each_target_safe(t, next_t, ctx)
		damon_destroy_target(t);
}

In comparison, damon_sysfs_commit_input() cleans up an unstarted context fr=
om
damon_sysfs_build_ctx() by calling damon_sysfs_destroy_targets() before
damon_destroy_ctx():

mm/damon/sysfs.c:damon_sysfs_commit_input() {
	...
	err =3D damon_commit_ctx(kdamond->damon_ctx, param_ctx);
	damon_sysfs_destroy_targets(param_ctx);
	damon_destroy_ctx(param_ctx);
	return err;
}

Should damon_sysfs_turn_damon_on() also call damon_sysfs_destroy_targets(ct=
x)
before damon_destroy_ctx(ctx) here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026135555.1492=
44-1-sj@kernel.org?part=3D1

