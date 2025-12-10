Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E0A2D3C523
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 02:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3426B0005; Tue,  9 Dec 2025 21:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594136B0007; Tue,  9 Dec 2025 21:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A92D6B0008; Tue,  9 Dec 2025 21:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39A716B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 21:54:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5D34140341
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:54:06 +0000 (UTC)
X-FDA: 84202042092.18.D752FFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20C59120006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 02:54:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZjOr8wZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765335245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpwcqEZXG/Kyyr5k+PAAy0sZSzpgAJyBKKjGcahAV4c=;
	b=kbwZeB/npqnc21LZVedD1YFDIfQbaVeEHTtAns0760nxFu0PnNKEJmvv2LxdEimI7iBevp
	zIbf3aHrVAcY5X6+E7KoOukdZHnLqrvumwnkFrRmnBy7zA2z31I5BbDi4jWwvpnm94P6hc
	V+KEOOExVdQOSwlPT4fdRaHl3ENDQ9U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZjOr8wZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765335245; a=rsa-sha256;
	cv=none;
	b=PjIW2Dcn8+UOZqRO4HTqQYwyRl/0dAtwXZxkjlKBrYKvEW0X8R2eCuYnaxBK8ufzBi30es
	w+UmZbt1FOs55ClK5devHiKRF3VL79RkWCU951koXxZjtowBGV8XIenLhEwXxq4rx6RTt1
	jz+Tgh7P0IimlCd4RC1csT6gzouE5G4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 501B060140;
	Wed, 10 Dec 2025 02:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A18AC4CEF5;
	Wed, 10 Dec 2025 02:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765335244;
	bh=spWxJyy4R94LZwBzdlJfetrxCR+ynZ+CcEoHHb7SaOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZjOr8wZRraf7SUQzi/1ZFnnoiw4O5ED4fQZlTaDRUWA2uT3f+VpoBUp9/Bf703CO
	 JW/u6h0Ic+DMRDiI6hTDxYKu1QQLXlTVF5F20G55mksRYD2iE2Fj9iM19DbODyrXin
	 Fkqd4Kc6gfItZ1OxQXdwns/vh8l6G15A6maowQ0w03DaeKi6tlK9jywpqiOedl3CAi
	 bb5r8TcMMqmUeaT606EU+MqCKZ159oDW1rgh37w49XA3ax35r4HjJyAVvFXccl6dIx
	 pho4HXaq85lEiLBL5qX+/VU0qeLK2bm3a19+hVFP5Kdy4FC3VUjg3ETwNQMd7DxoSE
	 5vUJ4qzGyLGRg==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
Date: Tue,  9 Dec 2025 18:54:00 -0800
Message-ID: <20251210025400.51467-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC6_-h1jQkZMbtYDC_jrB490jzp1t1Fx-_mhYnE7tqvzbw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g1gqtdxts46mkp68yd8nrk4nanfanhhz
X-Rspamd-Queue-Id: 20C59120006
X-Rspamd-Server: rspam06
X-HE-Tag: 1765335245-704444
X-HE-Meta: U2FsdGVkX1/xPrZpxe/pI0lumhCBT6eHo0XVvas1GX/RZpzaJVnr5pAuSpJ8K8Gmq4Cj8aIbGi6INrw0jGYrMlZznmZvxn1v9tX7DmOsiM+3qLPPIhPDeE7TI8wowju3xdfXR/nUGHfutrc5FRAg0IheqLCB0wRH4Bp5naEilYY2Q9EVbxxlbE5LPhzPGhTVgyP6RGuJgpslvP/05INXZGnsD1mpBkHl43nQC0C/Asa4TvNbT+p9cGGl/mWBYoDYx8KymCAru0WvItbC2DSgVy/K5Qopa9bXtVQQ6T+1jg2SPk9Rh8JjWcyCdqvKNxPyTWbFxaINKu/v2BWBlPqylOvsO/u++KhZEhsWykKFDLeCe1/lTTpU5xTw3v2Z1rqga4gz5F4rQn7hULgGcF20I+GGajzEwEezV2nJASVABTGVse529X+0R0F3EC/a1vkcP94CY1zAhB/FRc3ZfIGye2ClxMASRfm0r1j60S+QXiIPC/Jx5Ua3V5AIbOAdgHhutP3Vo8N1TWaYlag/cdHGhe4ZDj+OUEiOp86MTox4sb3IOeBYQAtllRNkVrMGtmDiMEFnEpvl0QiIeg4SZWtByGGwkPt8hPu3EnAZ5mS3JK2x0pkE7PqpptoZflpcbORoIarz6nL5jkoDWJKQZNCoXEpJ+stZcR1fWadeYSIhmNwxQ1u3mzeiMj7ECX6JGD6d3mqhUTtOkqqwVVRW0vlSP6PuimN/uO14GcLFjxlh8PE7svLBtxFg+9gjZCb+T4v3Je0t3h4Nj7iMuSiSBvNnbyFZopD8hYguDy1bRucDQRlts9J1y79PtHAvKSI27yW8+tTGVdplg9SIsI3jdGBdiF3CqIUtsQseJz9OPOoOattinqaU/ho8LuFqQcxvXI5W+SN1PY3j/Ccdle0hoZj5P33dn/Q0lA1zPIRY/6va5i5eeRtt7GlMwHCFNgTraM4jmSAswddtCNEJ1ckZkv2
 lB+wH1ZB
 UaZm2AKm4EjK63egwjd4tDD+v/TpLqmwafeREIgErGnaoXThUxMlSQpdcOKFiiQkGKtyTUguG6nBtBzerOqTtbTNkSGYvAzQqtxMOHyqYZI7MxWSrVHMp4wEN3IbxBUAARZ55Nq/PXzk3/Z7IcpD5ddLb+Gk21lJaSxV0R00arRzOezez5RbcBnImCYKeFf4rSXPVjV0sctjibVbRvvkFCxFjuvZcNcjAOsdUDoUTT1uATs7CXacMLEsS4ac3//kdSi3DHoBjTVCPD9gUGz+Epmj1vCTmq76GacJiOutJW3MhwW4mE0fHVePnoJLWEu4wVSsP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 9 Dec 2025 21:20:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> Hello, SeongJae,
> 
> Thank you for your detailed feedback.
> My patch has the advantage of removing the use of
> the damon_call_control.dealloc_on_cancel variable.

Thank you for keeping this conversation for enlightening me, Jaejoon.

Could you please elaborate why you think the removal is an advantage?  I
understand reducing code is good in general.  But that's only if the code is
unnecessary.  dealloc_on_cancel is there for real use case, so I don't clearly
see why it is an advantage.

Meanwhile I find the feature might look complicated, or not well documented.
Specifically, dealloc_on_cancel should be set on only dynamic-allocated
damon_call_control object, but that is not well documented on the kernel-doc
comments.  Are you saying removing it is an advantage because it makes reading
code easier?  If that's the case, how about improving the documentation?

Btw, please consider not doing "top posting" [1].

[1] https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying


Thanks,
SJ

[...]

