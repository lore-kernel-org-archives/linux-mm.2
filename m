Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14DE6CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5178E000A; Mon, 17 Nov 2025 20:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C878E0002; Mon, 17 Nov 2025 20:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B29D8E000A; Mon, 17 Nov 2025 20:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B89C8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:35:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 888FF88933
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:35:05 +0000 (UTC)
X-FDA: 84122009370.21.8A2F157
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB12DC0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:35:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VcenCjNg;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763429704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/SXq/AF7H8y+VoI6kp4MhMaHqiTlt+abCl6XyFVL/M=;
	b=IjYXFWJSM1xv4Mwhq07WD/Tt+n2fHDTF4tyGawAiPYluKJE32q9LnQZGBF8CbeYb+04I14
	D03Y/Z7mP6r87fcQbBcj4DG6MQDuD6V/VG+cVNJOYubFr9hNu7mGqr+lKrWximz4aIiruu
	Iw7NLWxP0d3nFR9UgObuL17MJf455o0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763429704; a=rsa-sha256;
	cv=none;
	b=tzqNtSkam4rKskaHudi5fI3OzGpCVmlu4XCbLfpFFfP1WfSb/37RrvywlbKwyMK6Ccukf4
	7e5KVZOmbAI0U+tTJ7tEWO3pknOJcM2dweWBtuVq0FSyyP3mcmDYhK6Qw4k9e8bJaGAlmL
	txSSnWl6tSEdcIGjVEdm8U5CSTvzZxg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VcenCjNg;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BC74C40903;
	Tue, 18 Nov 2025 01:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FDDC4AF09;
	Tue, 18 Nov 2025 01:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763429702;
	bh=vNjEVQiizwyx0ZZFgN4+71FpiOQ/CbYlv37kbyN1Apk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcenCjNgyZjZb3iq3KdS64DsECxuUc1vrAD2ULBgTScwdwxFljgnOPm7576CCQBnf
	 97ZFPphC9geA4WkLslRhsJ6dtLbL5WxUhm7Aflx2JEkp6j2VcS8bRu1n4wvvAdd56d
	 kupAj1Vdv81KSLeZ+TGaCir7A+F+2TJSlRtGsCA4urVhE+ntGsv1lEaPoHgXUPGa3C
	 yyR4HuamgF/NVrFf2Bl8cSr5T3qpuWrMAdNfs97WsU8tXgaDzTs4i4gzr841SzG0TC
	 WBmtkw76qM9DeQCsVKDxp+HhHnVdraT9cCX5F57GVGGgauB4KVY6Njd73hRFJx/9H0
	 Tk/SFqQOLJxFg==
From: SeongJae Park <sj@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 1/2] mm/cma: Inline cma_sysfs counter hooks
Date: Mon, 17 Nov 2025 17:34:51 -0800
Message-ID: <20251118013452.75700-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117115602.7b9c7ccd@endymion>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h6moaibn9eih7dqp87gened8e1bcrge1
X-Rspam-User: 
X-Rspamd-Queue-Id: DB12DC0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763429703-4229
X-HE-Meta: U2FsdGVkX18IqpkwBx2o2/+gxUBiX1dPatTaU326CnVBivww08OUDDxCFA1wTG2YrWZWqmn4S4EE1dIypg/6pGgokbSUWH4h+4Z+YdhMIJ2LEwrzM6Ml6z2V+Ns9kUIoN9S8YLPii8S1TiaFkqya+BEhFY7D3VaEGqYGt64+scee6UtygUbhXiAdWlJ+Nxnq1vkbD3/WTMmmXO8Lqx92s+etFw9Yh6SRFEcNT86Bva/UUAnP0eKoZ9tA+yZo3LXgESy5EohQ8We//Wv2q4eSPtDbO9ys929/jZmgcJjs9W9/wg/bQ/pvls7qX5uJQkhHOVx4a2etuW7nNs1hgHPiZCsEi0byPlrPOeBPtUmpL5LSfBSWgzX5Di1dejAsIZxoFlaYd0ktEv3VaQe8p7Xb1f+reZe1GKgQFP/JlXoUP8+9IKmPExkOod8mjSaWFilfEeTghC4l8lHsEU9HI6FeeeAOeiG+1eH/IFnkOQKif5t6XivUdRxwA7IHX5TtjcgKvQinMD/dZ6jARzvFAWxSq07BQzfBM6DVal9YHjBvPjHikv0NrTMXmTiByoO2DzMNJgMTbn/U2ER+RBe3NrztXIWn3ZOvNMFTYowSQdzjHOmayKtxtSHSPwUTVLXBgTTkPMq1oVXPuKTg7iiR4I46ls5helXg80JRNMZX53n68WY4KG3LECvHLsPPbIvSussDnYtESjfa0vjuMte91hWDA9CtMMf4lu3QK0c6mP0P5bIEn1ZzptRh4DVX5ITTRLz5J6M1JX30tNqA6I1jTGjTKIG2QDWYD8I5RalknnlGOyuRuYnyr6ebpp3IejAzWKCK+VrqILaAJum1J+Al8SZi3SkoJl7Brq46jvhJfaoxPvZjR8j6yh6c3uNOSdwpezoWC3QRdC2osr+9CR5JZheoT55wcq+VEArDtuGI1sfye6KmbVoLqBcyy9T+Ut5SjVRtIEzS+/RMfYnMqaB9GBs
 BvIO6DBz
 PmMjaFNWN3LrjJRbjFmIw/GNgnRYjdYMSmMDKMSGs6x5YF2D/9F52SwJ9a+QPikNqm0oDHYNCGjrceTRLOb3/U3tGReOdsLExstTqRg7bX9CpsfiCrnVzrEAaPuitZJhlw80LV1xgsWM4gXNbB9c07d+HmNE40Iczviwt+2i9SFOScm/LXrQMQDHxo+boxHBUIvoKjQvXkTKHSjEBdvSyWb5+2uSwiDi3QA9cUv8RTpUPzkaapHktI+H8x3Ky15zPaKGeh9+TEZ1m7KOVsi7U7hirIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 11:56:02 +0100 Jean Delvare <jdelvare@suse.de> wrote:

> Move cma_sysfs counter hooks from cma_sysfs.c to cma.c. These
> one-liner functions are only used once each, but the compiler
> currently can't inline them because they are defined in one object and
> used in another. Letting the compiler inline these functions lowers
> the footprint and runtime cost of the sysfs interface to CMA stats
> even more.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

