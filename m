Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E187C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECF86B013B; Mon, 13 Jul 2026 12:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3B36B013F; Mon, 13 Jul 2026 12:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5EF6B0153; Mon, 13 Jul 2026 12:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43A3C6B013B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:46:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 239718C07B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:21:01 +0000 (UTC)
X-FDA: 84983965122.19.7FC80FF
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	by imf05.hostedemail.com (Postfix) with ESMTP id F083D10000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:20:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=aC+I2FN3;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf05.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952459;
	b=fUlUMa5N0tNVDOijfd8MlrpyAgNxzd8Y3vjBLnim9/fYQV+gOk+UTrDJoKzdFZxepDvrnI
	7nbEp+wJr2m2umLbwikPaKsAqXjDYcE10Hv5wedA922i52Ss0Vul5zI9HVfKE3W2rQVD/f
	sqS3V1n89AvHLwPnM+8Ct9+f4qknF6M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=aC+I2FN3;
	dmarc=pass (policy=reject) header.from=xs4all.nl;
	spf=pass (imf05.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.183 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bIFnZ3KGdR4CKnyx75LCp3jZBE63H4isY2YjwT3K40E=;
	b=3zoulu47nYUrgoYZP58j/Z8Agtw6K6j8dFOj9svUJdlpXSzAOoBlOlT24BqKuJAMLosIWT
	V6Ej3ohIt3JEMmQFgQKmkmBMn7qNuKRx5+gHIYgZY6YvzSfL1g5DhjHOt5rVbCR4LNTysE
	Y0wiNlOYSYVZQJi5HmdoZPUuLk8mL6Y=
X-KPN-MessageId: 1068b33d-7ec6-11f1-8f54-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 1068b33d-7ec6-11f1-8f54-005056992ed3;
	Mon, 13 Jul 2026 16:20:56 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 10678412-7ec6-11f1-9b0c-00505699693e;
	Mon, 13 Jul 2026 16:20:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=bIFnZ3KGdR4CKnyx75LCp3jZBE63H4isY2YjwT3K40E=;
	b=aC+I2FN3BHeYqiSmNdjSu7P7ZTGylyF2zlsyTaHpcMrxnOQ8LdZLdCbpQohJj4NsK1gm8DaEPRtu8
	 07RoAADHF+zSHEcJtcJzpxL4aFElCeOupaxGBTxZz5hRdI+cNZLh4W0h5rvMIDtMHrr6xgvhlgWert
	 bo3pVXzOM27gWjS21C6r7evTzSQ/o0Rfim9dLBpk72rRJSCRarNKcV21tR1aX+JpO17MIzRxfAbWZg
	 4OiHFSbWthl6YDnYV55dS3CuegD3Rn73pxp5hX+ETn+LTFlVPXIrsmol+i9MgRd8PENcVmfCVDzGq1
	 kgAF1lOfJZ1pKdDwFQ1qwceg0026EPw==
X-KPN-MID: 33|fFDYJmCM2JyhhASvSGhTgTleZxTLrdjH0y1cLbO3y2QpbaysJjOai6CaO0r+exD
 Jruq5D7vLJ0pnZps+8hGyHiHXCGQ51BOu3uWprkjpgkY=
X-CMASSUN: 33|0RkxCv4tFRlwJdj8l/MBDyA6+HZKOlkOXM/yBWmui5g1GI2jOCjlC9qw9O4V11R
 YcMTgRjUi0ENp2aD4oW/c9w==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 1059c206-7ec6-11f1-8edb-00505699eff2;
	Mon, 13 Jul 2026 16:20:56 +0200 (CEST)
Date: Mon, 13 Jul 2026 16:20:56 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com,
	stable@vger.kernel.org
Message-ID: <479591519.862301.1783952456807@kpc.webmail.kpnmail.nl>
Subject: Re: [PATCH v3 03/24] binfmt_misc: reject a flag character as the
 field delimiter
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Originating-IP: 178.229.242.209
X-Rspamd-Queue-Id: F083D10000F
X-Rspam-User: 
X-Stat-Signature: oaz5m1oooo3p3c7q8e884ir9b8jryq65
X-Rspamd-Server: rspam03
X-HE-Tag: 1783952458-603820
X-HE-Meta: U2FsdGVkX1/DRwpqPjs+Sv8saciiw/mQuLZpB26YLsqj+03NMViOC5gxu2lRLmMj0iaiKPqYyn7AjBfxytnJ0s0KsIfuOuEYwT9dpYZnG4HFqoA/WU/XnWMroNSDqtBiSYSKPeP9Pdge8WwHccdMiUKxeCA5Uap5zj2dHxWx/ALJVGE0l3EPRwNXlKg/8LrR2YYkSw8KV2y36YObp1A/mz7d/w5SzYbRIGVjh172cLaNsWDFki9bWs8zoQODzHZdE8uPXvi5x8tB+skz009OgQXVSrFoi4/XJtHWKlgWXoODiN3RZ+awinaEW3rf/D+X8nA3hnwWo5zvwdZJSznBv5CKc6dwtPeuQMq4y8t41zyK5OGnA2P8TuccAtONpoR7rCXMPa525XFmzxHrGt/b3nhDv8TaTotAK9by9sGGfLgW5VuPoRnnmlcu2yUA5SW9e1e3K0mcdn0unYfDK7WTjyMYaUNMse8kPPK2srBPN+aWveJtmUsiTe/73Q6pD5vVp4xBiw9dt8wZ8GsaPsQIsq+w9wWA1Tf0x7HiGTcxCOsz6AMAzpu+mLch7lIGSolXnMfPTfRlBRk2iA7duJWyvIulAWGebZzqO0m4aEXpCTmxpd4+Pj6RFA4ZdWVSbMpDHO40Y2grao/asO8E6N7Iw5tluoDNR6SLpj3H3FN3KT9JbqMh+p0YUx3xVsAPc00I1Z8vf+cF3bZuXo6q7DOpZEOX2ZHPoMjAogJ+HSc27JMCY9833IkIfrZzu+3gjf5eECv7TEmvJw+iSm6TjxqwbrQlZNRR4WThf85JHR4DRCICCtcyBvYXWhJUF7ieUfU2iVNzHFGS87ZlbS6RXNrmAYQR1jqbyVmUC6vgTZQ1wfCOoRHdUb4wrVhSKMgr3fy0YzUh7yKgsyGn3qMp7ZJ9sqVWoYZje4HQrYL+frxe3L+k9wZrg5FRYjLMVGt2qGLm0p9WsSvdcYCqq5wDoGC
 ZxDXKa/g
 AmmremXV9K2ighxHo1P0rkUKK4zxZkzpx3YJdI7M/xQippvK7xN4FOGxYYHgfLh/JKy1sopGc20RjpDXuo+iuXp8eVRS0Nj1V25MGpxJOAodQ55CkON8ebB1z1Yyd4HpLUg+sjQTBjy19rYE+bI0zqvMq1FpX8iuYk/kHUK0h5/k3M+v2buFqXoiQdNU5NKTavkYd45cjFMhikaKH+7RrhsC9yspud4vpWZGzHUoxHHivHqM34VtN7NFIR/z8NFA7zQn4oBfwwFVVOY1b28ITbfgAYiMqLnv2K807ONreaeINI5dT/OJTN4cPvEITNJ4W4lzxxxO6/EhxYcV0le2o6B60vuHv5H6Ob+vNmXeGoXz/bH7nQRd2YOqMwSrTYrXX3VArZcplu44oOb1yX4RfGjeKzbImrvLwzL4Ula1ZQatC8ZervJxx5zi0/QYawHJnaY6Nlu5qm2ERUeUY9rhdbza657DVgELfpeluzfbdo3z3/gU2DewzwZqlPfjUA0gj1pvnbdHWhjwWq3ixPCtXG3u/e13uCDdlGLNfODkch6G1SnulEfrYZm28OHa32VqoDTm5DVQ363jD5Rs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:04AM +0200, Christian Brauner wrote:
> The registration string starts with a user chosen delimiter that
> separates the individual fields. So that the field parsers terminate
> even on a truncated string create_entry() pads the buffer with that
> same delimiter:
> 
> 	memset(buf + count, del, 8);
> 
> Most fields are scanned for the delimiter with strchr()/scanarg() and
> happily stop on the padding. The flags field is different: instead of
> scanning for the delimiter check_special_flags() consumes the flag
> characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
> none of them, relying on the trailing delimiter to end the scan.
> 
> If the delimiter is itself a flag character the padding no longer acts
> as a terminator. The scan swallows all eight padding bytes and keeps
> reading past the end of the allocation until it hits a byte that is
> not a flag character. For example registering
> 
> 	PaPEPPxPPiP
> 
> with 'P' as the delimiter (name "a", type extension, magic "x",
> interpreter "i", empty flags) leaves the flag scan running off the end
> of the buffer. The registration is rejected in the end because the
> parser does not stop exactly at buf + count, but only after the out of
> bounds read has already happened. With an unlucky allocation layout the
> scan can walk into an unmapped page; under KASAN it is reported as a
> slab out of bounds read. binfmt_misc mounts are available to
> unprivileged users in a user namespace so the read is reachable without
> privileges.
> 
> Reject a delimiter that is one of the flag characters up front. Such a
> registration was always rejected anyway, only after the out of bounds
> read, so no valid registration string changes meaning.

Looks good, I see no user visible changes.

A general comment on the code that does not affect this change: the
nesting is awful, it would be great if we could reduce that by moving
some stuff in separate functions like check_special_flags().

Also, can't we support a less arcane and impenetrable format, like JSON
or YAML?

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 24142859658c..b7664d90eb8f 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -385,6 +385,10 @@ static Node *create_entry(const char __user *buffer, size_t count)
>  
>  	pr_debug("register: delim: %#x {%c}\n", del, del);
>  
> +	/* A flag-char delimiter runs the flag scan off the buffer. */
> +	if (del == 'P' || del == 'O' || del == 'C' || del == 'F')
> +		goto einval;
> +
>  	/* Pad the buffer with the delim to simplify parsing below. */
>  	memset(buf + count, del, 8);
>  
> 
> -- 
> 2.53.0
>

