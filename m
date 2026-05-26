Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C283CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CEB6B0005; Mon, 25 May 2026 23:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54646B0088; Mon, 25 May 2026 23:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91CB46B008A; Mon, 25 May 2026 23:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDA36B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:06:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4518A1C016B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:21 +0000 (UTC)
X-FDA: 84808082562.13.EF83655
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id ACB8E40003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=OEZUsMWJ;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779764779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bD1DxynsoU0auV377W9yW3PuxMlzlNdl+Ii+zM/7Nyw=;
	b=yAkGjaSnHno3L2H1TU3vGClYoz4e+wfwF5eCliFfIwW8nFhfkWfjJI2iRZUHMFgsHFWI4P
	xOWpXCyMBlV2LBq+xk9k/M469w6MMExY0k6A7FalKfTnjXTEAm5LVTrVcCkEjELwh/begd
	TXCi13+jdV2te2Jp8p7T5Vd6TKru270=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=OEZUsMWJ;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779764779; a=rsa-sha256;
	cv=none;
	b=0gMz+kbg06BxEHjN8CYy1Tw9kvgKZXPsINt/aQo/P3bt6DT/Umu3pPbTifwA7UQBkd1Iex
	R3xgWf+cTG1V2WVUglJcCdBTzjzrpAvZGzh7axBNJLyO4e4fcFouFq5asAYNvzhMmngL+D
	ewKQ2bak1lbSON4/K0R32KlyIUtr4Y4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0B2560018;
	Tue, 26 May 2026 03:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6B91F000E9;
	Tue, 26 May 2026 03:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779764778;
	bh=bD1DxynsoU0auV377W9yW3PuxMlzlNdl+Ii+zM/7Nyw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OEZUsMWJZw+E2RPT7SKO+DpKRsUypIy4D1QbA93XYWm2kMCltw5/oEklDClh5LEJy
	 5lSKehzlacNUJqsYr+GRe7JLbgf1x09YNwO7zMvJGGT1yp3pMjzrZnqF3UqvsX0w2i
	 UxGVr9958J6eJhwfaq84fQZCCRE0h6gXORUvlP+LILyQh1+uFhtvronjqICIH3k71a
	 n7BEl4G6kAWOpsfMzLBBAfhFdlbakJ0krQreyQGgADtIIoAUjxAjgJ0Q4FB2f+PuLb
	 cibao5KCroPmmz4ejin76N8MkSL1Bqy6pdPJ0XD7RvaFjAx5Y2A0QGCBOoERO3y869
	 iZt6awx6fsXjg==
Content-Type: multipart/mixed; boundary="===============1607772065207942128=="
MIME-Version: 1.0
Message-Id: <8739793736cb8eb1ec6e271f59142e97a34af26ccb023469e23e5b47bed2aa61@mail.kernel.org>
In-Reply-To: <8bfb7027abcc02c21db565cf52d6af78a6ce5b7d.1779760876.git.zhuhui@kylinos.cn>
References: <8bfb7027abcc02c21db565cf52d6af78a6ce5b7d.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 03/11] libbpf: fix return value on memory allocation failure
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,laoar.shao@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:06:17 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACB8E40003
X-Stat-Signature: m19gsxw7yrrbpis6fjwg8ebei9qtcoo6
X-HE-Tag: 1779764779-207001
X-HE-Meta: U2FsdGVkX18d0thnM9hNPyOtwe3gZVIsoBaQqVmeE0q6OLBr45ouV/sAiAl8LXImPbEUOVkNM1qnyypf5NknMM5dg5Nmi3Rn1Nuu71LEEKadsbW8WLAf46fjlU1Yl4So2qybPnQCw5C8d4Y9KkuPXxNRYogmwviP1x07OP2c0hBejbMcO+he+yT+snS7FWUUZRveoM1bHKmkw9a9//E0iECDt/jCaBdqJPxu/5UyxmY1pchOra8qf1J0TgmgFdf2xBFpYLJekp85hApZSBqVpA2ZMW4chyy3zVXDWgYyjScpC5BFylybRMelnCaugKYuY92LdsC5i715dxopgaVOEFiz9lxbq40viQ8maRuAjDhvJ1pyrvar7oQ6Q1BNznh+M9Rahfdw+hX1Lwgkwbc3pk7AYEtmUW4vVulsO5o2CIEzhjuazFTca1m7eDHaleLGd74/o44GduEJZHmYYMOMtlOw8sISaJrfvTsKS6uHbNUq+QepVDiiBr8WaG7xlvHKJhk5b3KJMeDNxmdJ9/+SPiSVgOl+nm3HvqCPi/MF4oYB55CX3Fkrv6lgevGoxy7EHzlpixR2yh5q22c6QNIXKOFDiqpm7BFgwnrCzMv7hL77ZVy6f/hKW89m+Qm6e0Ce6VVC7z29+txEYYJQC++34VDwlp4hqEosVUOyXwIHFILNkA/NudnNCB0fXlYtHBhAjN5xKPdzYrrWx8nDzrfAcRvA0IQIC7iylebZ+4Si8/vSJRZlje6XeE3LX12F67tEZdljd1nFWk54C4yL2QZfNunByyWstQ7eiVhhw/rRCeZStWkki76h1nC/oGHgm7p9AoviZwUuW2NJLVBira37a0orOl9EOT8ZTraFoUuE7oNLMzUX3D+PxMvxuXQCPHe6WoVWPDPQHljSOxCH02wEAEXkndIEaqECo1oAkXLgSUnLzAGKz6ckF3RI9Gl5EcVaAHV12l7JVjB6veY0Amc
 4b0VQrxw
 WEJfKNbcuwHKLCEIsh+WfdCFyyvoFnoflGuHUJhna8OuOcEip70Jss1Z4Z9mtk3lyd1INPHeYOUbdpS6z1Jnl3hzT3yivrkPPN8ZFxQRkNY9B8SepL7sYny3di2GDlSGa2j0BlvGaEPG5yIPEEpLDl4gh95ZyPq8gwBgors0q70iVf0ILT1scXT3i5TPkH+xSToMs/3/zRcCgtrs3NbBGwJhUWTeCzjN4iazRKOslge6DM+dvDXSkH0npfEUeXfeSpf30YtzWGtP28eadf5acqUCLpeYLLiPWpQd4guCzn7lJgFkHRlBPMzBgN5qMaCcdX2T95s+BcsWhEEl8fP5I7yVn7/2USja+Qx2NvslYlH8eGuzbZxr4cC1fl9WgMragt4Rd3+0zRPr2CW27iMZUhkKs0paclMKDi8E5I4UgEWP0xt8b16kE71aERobYUor+FipDMYyQnY0Hwru4Z2SfsfAAUJpohn4cRgLrG6NFCZ8au08aoz8SSYYCwXN3DUlwUFfN2ZGoiDL3fvUUNF9japLDvpK8T4BD7QOOah/fMlr52CXSQ23EiE5iV/24Nswu09JJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1607772065207942128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ab2071fdd3e8..1e8688975d16 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -13701,7 +13701,7 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>
>  	link = calloc(1, sizeof(*link));
>  	if (!link)
> -		return libbpf_err_ptr(-EINVAL);
> +		return libbpf_err_ptr(-ENOMEM);
>
>  	/* kern_vdata should be prepared during the loading phase. */
>  	err = bpf_map_update_elem(map->fd, &zero, map->st_ops->kern_vdata, 0);

This is a pre-existing issue, but can this dereference a NULL map->st_ops
pointer?

If a user manually changes a map's type to BPF_MAP_TYPE_STRUCT_OPS using
bpf_map__set_type(), or if a malformed BPF object file defines a map in the
.maps section with this type, map->st_ops is never allocated.

The bpf_object_init_struct_ops() function only allocates st_ops for maps
found in the .struct_ops and .struct_ops.link sections.

Because bpf_map__is_struct_ops() only checks map->def.type, could a missing
NULL check on map->st_ops here and in bpf_map__init_kern_struct_ops() lead to
a crash when privileged daemons parse untrusted BPF ELF files?

Reviewed-by lore thread: https://lore.kernel.org/bpf/20260526024145.5309F1F000E9@smtp.kernel.org/


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============1607772065207942128==--

