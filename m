Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9861093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D636B0005; Thu, 19 Mar 2026 22:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBE096B0095; Thu, 19 Mar 2026 22:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3FC6B009D; Thu, 19 Mar 2026 22:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFA586B0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:46:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F691C285A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:46:08 +0000 (UTC)
X-FDA: 84564902016.08.DB24085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AF858C0006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:46:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czaTvFVh;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8tR50/5Z1gzd4rEE758+lTBwQZp32+NjCqpI7YkIYM0=;
	b=Z1hR88GBrgkDuGxQXf3Xxy+kGL7z27pcnXd5mjFEETP+kTDP+belZAc9O5/+BxX9MLejsT
	3wXMix6WXPbWWPSFGiZaMp4cGm6+RWKr2EsgPZ5O9IahlamdfdGL1R4yR0A+NBSsphn1Gs
	trE6/75zXHCCdfYERsteNnOQdW+PXnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974766; a=rsa-sha256;
	cv=none;
	b=zrUKeyv21wrp3yUkhE99LisDOU8kxGrwxh1iOO+fDaVpkQBjRURkIArEYHWHWB5kOL4paP
	PdYX/lr6A9wf3sjTz8LBZSEAjdDewkih0vHJUm5iF3qOgyt2rQ1BN2lfI7f1DcFg+m1ECp
	KICdV6ZnKxyA1Vcv87BxdIwZKFkzUCs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=czaTvFVh;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1924160097;
	Fri, 20 Mar 2026 02:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CDDC19424;
	Fri, 20 Mar 2026 02:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773974765;
	bh=YunpBLhttoCZ/wIAcy4nfrL4p7VGWHFXXCquZN24h8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=czaTvFVhyni42YpuVBn1vWRh3Ky008Qc+XQuV8/+XFzKKmLC4NNt+pmObYqOsPzqK
	 yh8tyZF4bDmbUAUWMBZ/hcGG+vgyAVxgnPloZ0wgZwj/PxinC+3kAEOQZY8h/2UFMo
	 NRO4j9fuAShXnW+lMiJxKYTnE90r7LTXL5dGkcXs=
Date: Thu, 19 Mar 2026 19:46:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v4 0/5] selftests/mm: skip several tests when thp is not
 available
Message-Id: <20260319194604.0a9a733f521caf2dc2bf18c8@linux-foundation.org>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF858C0006
X-Stat-Signature: agorm6dh7wbw6sf85mekqw1b5b55qeae
X-Rspam-User: 
X-HE-Tag: 1773974766-269056
X-HE-Meta: U2FsdGVkX19H523iWGc13UxH/ttFx2JfKV6GutjWvJWiq7TZFbeLYNHgM/QwQ589d4teQD51Yk0hVpVTm7VlaWTqTL2VX07hWrcC066DgKEasJeXsaMyxr30aHNVQ4sVDAANdaehzJIr7T0F00EqRicik3OiH03QwHaiThrHySL2q2kZlLPh5FPBj5DciSvQ+wyyO5ic3owr6anSCNnrJ5FkeF1BgsgayOoP7MzVtVFbEaXBQ97fG0YnZsCJ5faNiBcubwimkllxqxbOYSgXuB+cOxbiP/phcv9xpYcUEnNo3TlL/zdgfMrhW/marGHyJKX7XJ/D2y6VrR08dBHc5o3OVkNBdHZ02K9mNo3KXb0MwIBUHN8HZKVAOTAMcrNPy3pHvaBYMHOFnI8RGnyacLkPsnvi2H8cHgr/BMnUFuKYhgXPSlC2sPvKwHh4+JeQ2BXVageWsetxq9R4ZJPNhDHZKSUDV9571jGPyYPiGL3rdlrKSt9UhOr2vnT1GuzP6YXLGoo+i0EnMARStFIn2DN1seiwFsOKM0DjRrLbGVvNF8+p5SqpyWNaXzSYSTFnZXNe55HTrSnAHSaz/fL/19iR9/7zjc2ZkIT3uDkm/Pyjp3HAqNS+ZTYe6fQsh2/h55MQXnP72oXQqru3AaBoaw7Lm05p6izWFuPqUPMwgG/TKqukQEOVfq503XaGtwGa+jVIjNEsoLZC575nJ3cmRR6VAGQ+XSniMmieSKvsJ1jeyXfEHkoN+8PxveDgozx/E2T2wXuhxxyiLbHqm8hycmeTv1G1gslTiPooIJ11WuDWm7QwHINj/XqrVmnx2Hkv99S55w3bq6ldiNPzPhYV4wf6PY7V1KLh9xW4YAwRfXLZtl+OG3Cvw1nukVJyYhysXucaazqHB7Kj9wtC9TnkyfLPJ+scSWv1N+/EgUQLWXrgBc4AtsHVz4I4lfy++FgjfSfpY25G6QrkMHovITb
 84830fhS
 4fIvcdA4D1+xbgM8aWJpngs/P159yoP8dqXJGg1iTHhgEzXcXDpkbsm/pZFKY91ipcreZCsAEPMvKYbYvuAEPdPu85/ATog4YZl9wdTxO7Q+w3XPQSNMfx2Trgc5135NBrW/Izxa818ma0dhSLW5pUiubL7+uWqCvhowMsqSau2kar6CfGpvWE+0zqoMv87DuX3+q8+SgeunuinejY2b5ePwIfcsuNDJVMyKQNrfynkF6GkEMdiyehvsaH4gjVoiSqKsuqtAVxnHtrrJh5CEsJ0RLrNFDA8DWMth1WCNoxAYB8UrlQzie7/g93wSyI9auM2ag+yxGUCW1CkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 00:06:51 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false negative.
> Mark those tests as skip when thp is not available.

A couple of questions from Sashiko:
	https://sashiko.dev/#/patchset/20260319160656.1480279-1-chuhu%40redhat.com

