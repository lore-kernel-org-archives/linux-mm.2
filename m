Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F50ECA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CF06B008A; Thu,  8 Oct 2026 07:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00D416B008C; Thu,  8 Oct 2026 07:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C566B0092; Thu,  8 Oct 2026 07:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C19316B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55C8FA020B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:30:28 +0000 (UTC)
X-FDA: 85299240936.23.F38A56C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6E2F180009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:30:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F8Hz1Y/S";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791459026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyZEXCsrjIRssFr/XscNfX4V4CetnsdggN0Nwhan5is=;
	b=06aVvTIQ0i+A1bAfpZfu1Y8CpXuc6ejLImMmKUOp2N/fZch4qU7jd7J8fCP8TWn3qfIrhW
	PHWFmdY/y2Cni9WdRtv0eUYmR9O0LmZMFa0d+Qp5cOwJysI/P+QHGZP33f6ThL1vF/zMLN
	ynqDq1wKcv3uUDUpbW0mv1LDtOP6HOI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F8Hz1Y/S";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791459026;
	b=Anpg/FUN6YYF5W7abtdKAxCPlWO1mZ/EyRd8slua2K7CvLR/YXUS+Ac5vIodEcGHKv5Nbm
	S9NCFXkg8RcVxpgVUhYJz+cWBRpVZhLWJNKeyoysq4sH5fW9573PnDSIxcPHhNjR0rC9Sb
	zHePyWnAqDnKxM+jImHxb6jXrcMTX6w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBB4243CE9;
	Thu,  8 Oct 2026 11:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFAD1F000FF;
	Thu,  8 Oct 2026 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791459025;
	bh=JyZEXCsrjIRssFr/XscNfX4V4CetnsdggN0Nwhan5is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8Hz1Y/SBwi1BdY46Ig3T8lYjqv1KCqjC+yNvHC4mkiyTe0couKTWG8QhjbId/Tk9
	 4yHtOuzVeAeJvZ/TwL9NCXxEIWaRpZvfVAcZRF/ROXeDbV3enliR1RFa58tAjt3Sbz
	 9vQWB/zFLBYwOnBE9/UbOSDRSdqeiTiFIhJfcI9OQwiXqawVQJ4zxuzjKXvUrLkFob
	 yDnbvkuO3YM5XOezquzGDbIQF+RmvEn5wGMP7/71m/fsnQVwJQfqSqnp3wl52R+G4G
	 3MfVPEWQqHUkERgYl2d0qXWM9COxJNDCrd2sG8e0og68G/84fu0zsbJ/o6sOnPCh7W
	 rtiAO/oC0T5Ng==
From: SJ Park <sj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: SJ Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: Re: [PATCH] docs: kernel-parameters: adjust reserve_mem build option
Date: Thu,  8 Oct 2026 04:30:20 -0700
Message-ID: <20261008113021.44149-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003213457.96408-1-rdunlap@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A6E2F180009
X-Rspam-User: 
X-Stat-Signature: y93qaijwwfb51kk9jbhham1ht9shb1jz
X-HE-Tag: 1791459026-329552
X-HE-Meta: U2FsdGVkX19mrHpNXEtXq3RRdJATiapI9d20OjqgWkGotSjUJcknmP9hBFoIW6Sft2mpLr43D5mywfOIawqgbFXzRUKOcv49K/st3GT1gvs5W2EnmPHvJQNzUYLg2Nkf8HZPnXV9J/9rXtWOV3wsMJ7qHVnVgIrrApiclckwusKeyRzaMDdzemhr4FB4S8XqPqQ9Nra5BRSZZzQ3YRkshQBh0DjlcQEgJ5FPMIUUa9R/mVGWxFxEzZA9ZIT4+zK/0dR9DM0V67KNf/mEz/c+NjrvZ+Uhf0r31sCO23eRIQYmL4WeaK5PsnVIb6nscs+1n0tMMc9PH/kiZAylN/ZkikIplc1EyZH5JwFKrJ/268keT31WQyHv4EkA/ltgVL2GoKJ6hWngr+If0KECn/6ZiIsWFZy0qbHlveyboCabiQ1fW0+QbuTdFnHJ/5WBBS7lT7358D1Z8uvK8nEJEpjZZIeU/rsicEA2qFSxGWVHwduvp4OffgOm4W6do86cgz6YOXfgI/S591BK9trmOpaRSeym254iH7bWQhKAUpbRv3/JZ1gr04mRO+1RllZoYN5GwzjrlYaS0bwb4h2o0CBv6TYiMxg5dRvpM4Rd+2X45Q6p/vUjcxYUrkqzLZJNdjJLV46wqEEyJM9KTAlLL4inh0Z7O8wEjXNHTmViPQna8fSWtMCg5+ivlyoUJbCrO98L+2TxgSOMcxy3XwiVry2MSXnXMEHz/PdcpdT5tgrxGaF0/rLbGfD7Ux3fnOrRIj8GiWEoZOr2GLm5gGQbQ4rNyS7U9+DJxd+UpQEi8LP5iPhSadrpu3nl0wt5KRNrG1xlg1YNVaErFo89L1fdxSJRaB3mGJYWrIbHb8HcHKCuJnkvlrRa0DhsyRcVeEFBK9kfj21KhJYmBCFzIYdktUeamIWkA1U634341kddus7tyx4VzDFDAmCXWF2mmGtsSbOuEo13lxzdn+wKeCMfG/9
 ShLiXwTG
 NbplObbiupeRaVKFniVL1muDqN7dyy78wQd8TK4do4uduEPMDD9ruTOT1MkcPP5YyNdOFSAp8SyqcYrA+XHIopcsykDqGUbfcAm59T/N23Nj4A3qMRbFE7nVv1Y4oOq9qMSqXtFkKj4cdElpcFNF42JA168/U+WunBZ0oqP+PSSMxA2qdq3U+XbiwkLLjAE96BoZ4OsN0j+NYvHk/v5JuC0ntEm/I9nq7J9RJOUt/nltkDMlzssixdhfIPbYz4StTGdIPM5xFjQwVrFKAs+/RVYzgwnfDiiJSnD2t0Ci5d4pP3xTiGF2nMtFcDzJVy8e6VYZ1USa9IE+AZrAlSld1uVjegA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  3 Oct 2026 14:34:57 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> "[RAM]" means that the command line option is applicable when
> "RAM disk support is enabled." However, the reserve_mem command line
> option is not related to RAM disk support, so modify its build option
> relevance to "[MM]" instead.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

