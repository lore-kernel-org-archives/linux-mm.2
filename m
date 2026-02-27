Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC12BFD7F95
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9DC6B0005; Fri, 27 Feb 2026 07:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87986B0088; Fri, 27 Feb 2026 07:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D946B0089; Fri, 27 Feb 2026 07:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A30536B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:02:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BDBC1B6BDB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:02:40 +0000 (UTC)
X-FDA: 84490099680.05.77A3483
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 42E0C4000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:02:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZIlhqS5C;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772193758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARsZZaJbz4Se7XeH2kij1cdc9Sgjng1W/WgzOfkjGow=;
	b=alPNTlYvF6r5s6E01wLvV6dvFG1Uk3/pDFTxrVhPzcq7ye0/BmWeRKdXg4oXXjxDuP7LZU
	eCOfMvFKKbhERxNg7s5t0MAB1fdzdIqMBQTgUhrg4zK+pqRByLkxj36evPp0E4BNbWPoWo
	mwDlpo/QbeXNhjTP3zX03Ygdb/mcGVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772193758; a=rsa-sha256;
	cv=none;
	b=MFOoHv9e2m6Cd0ayccntqxGVMzwHGdfoTcTXS9jPMe4enM5679TioqIAsdqSgI29FqfN7e
	vylqXYpDH9723qx5+KFBW0nmwUy2AA0ZAleiIS1y54F2Wc4/0hshsXwUUdz2JzndOeSesd
	K5C02cTcqJpy66WdmqLEO0+VrY5qsAA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZIlhqS5C;
	spf=pass (imf07.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772193757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ARsZZaJbz4Se7XeH2kij1cdc9Sgjng1W/WgzOfkjGow=;
	b=ZIlhqS5C70oHUXCIdlQwSQpNsNA9fVDkThlbTzWKw1Dc0qgo+ClRn3htkjAW8764IxLZQf
	86gTZluMYZyAfiIHBKNtxeKNb1XxD8zrkmEh+V4U4FHpCyavLPDCtkX/cCSPVIG0wqW02F
	6r/ckX27+ntDkKbw4A87i3xzdGh62ks=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-104-CIEq5yPeNk-cclyWlY572w-1; Fri,
 27 Feb 2026 07:02:33 -0500
X-MC-Unique: CIEq5yPeNk-cclyWlY572w-1
X-Mimecast-MFC-AGG-ID: CIEq5yPeNk-cclyWlY572w_1772193751
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 259E2186096A;
	Fri, 27 Feb 2026 12:02:13 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BC68C19540E9;
	Fri, 27 Feb 2026 12:02:05 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 27 Feb 2026 13:02:12 +0100 (CET)
Date: Fri, 27 Feb 2026 13:02:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: [PATCH 0/2] pid: make sub-init creation retryable
Message-ID: <aaGHu3ixbw9Y7kFj@redhat.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: ZaiuEhD10KESTwGGIy3ALFllFfGO0VXeA_kOdEovO6E_1772193751
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42E0C4000F
X-Stat-Signature: 1a8mh3431zjpeoj63wrtzszu73wpsgng
X-Rspam-User: 
X-HE-Tag: 1772193758-312085
X-HE-Meta: U2FsdGVkX1/BCW+3QiTD9NYlKSXMetQ+2eaEI4rEDLSH6iVarlikXVUrfIHYNKLNr+qR/50yAn9zm4kMiMZ8unBt03OpEPy/IuS3aWG2q6m89+Busydda99DD6TtMB6anOrdq+U7s6obR5zLTBvny63RKVpbTTct5YJgtiF4Bz3m8gKM87z89rCR11YcGCsrdy3A9MlZPpew0LW4tvFp7vancdiBY2IJTOC9gSxWUjF5sIFgHsnxJ6EYCFW94Nm1Xa99V+x3ftuLHG49pexndT/l5Kse+CN8Rr0QnB+1MgWUQNmvnwFLYJYScTNkEQ/NFy7uox0xQwss47b7ItO7sFc2PPxDXJ4LiRq8QdzM4tbxSKQLEY11T6CUEp0sK6yo7ZVxOhmKNse7SqdpVeB/+tE2QeTTziONliDZSfK+G79l4MWMRsVxYVNE7Vpv/dIEYlHYfXKnRBO90MN4xInQtuA5MVRFsurwvKgUB/OYh5gwuylFcCSoEnmHITa3fNg65fWPfimhncWKNo6HPjpEXjgC9vjgneBL0NWIzZUA8vK3alklotiYWL1aVMcqhe9tpCS15C8QzwFZLfueN5dqBjnCM8ZHTOJVl95CO9A6X7Uw81DGbG3OIgWf/OdIUfSH7n9ON+hylFnM5D07AhfhEcUJop4OnLyS6fYNmQt6ap+BaJB3Cph2IphFxmD+vKrxIh+Tz61iWvH6vVnh+Tr51OKtoX2++25IhixrgCGhp1DUduGSnWVJM5HqpdXefJ2PjSc8s2cCw66ECNnzVcyovodEzEp/dvlPS6Tr/2L7pfAUoQLOn9bGpb9R0rbKwIi8IcnD7VXEFD9OSBDLTBfm6qatF4srBOspCCr3SwaSzLn2CmkpjlUp1A1pDmDrvmRb+c2T5wuXfcygbapc1dt4oGyqwUq0tZVrmGqORjD95zm1C7nqt+51bUR7MlLpSepsp9xtx6WRmIakesU9jmY
 LjqlbDRS
 aarddMJPW27CMkEiszUXyyAU1IvKsjqMVJbx0uf/7vH4/G7ONtoqpj95zETePpr06HEMAPujOaD4cCO8IzON2JuxK8VF5gSmD2bR+7QfrMS224nv546lTqLSF+pChXlpm/8WZbvCXZSknFh5THITk8EfHFfmoUxhdAKcj2EsTUiTrarwp8L8xoT728r3lnQvLmvsYcEEguTXTMN1YsBqJJX3hqkto5eJ4EwIYXngIn6WdRIoU52nQRQDmFIxh5hJdTG0K8D3WoPxKFfm3ly8ybRcXJUz7hb+anthXmQgG0vyKH6Z7WXcrwIEcyRGoO2ddYoKk/9ggDKueVx9o7YkoOtFyEtcaF3cnwEk6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

On top of Pavel's series but but doesn't depend on it.
Can be applied before or after.

Oleg.
---

 kernel/fork.c |  6 +++++-
 kernel/pid.c  | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 8 deletions(-)


