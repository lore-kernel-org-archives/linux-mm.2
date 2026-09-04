Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D625C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5126B0092; Fri,  4 Sep 2026 10:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865FA6B0095; Fri,  4 Sep 2026 10:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7544D6B0096; Fri,  4 Sep 2026 10:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3E26B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:53:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6F7CA3D46
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:53:32 +0000 (UTC)
X-FDA: 85176373464.02.2599DB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE7E2180005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijXpG7Hq;
	spf=pass (imf24.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpOLr06SKT9VWUbfIdRTrVaGCYppzQHTCSBPigs1Iqw=;
	b=KmWFqjxWCCmeOnCfMEK0sghPHcZhp1Zlyupa3RiwV0LI0BMS+hib2+vJW+CERabnRRYSeT
	e2yYK+qwHTi4uemY6wXZYzxdd+JDpAG01g/sZEYfocs4jof4rG/Y7KCuch++vZrCRTRd2N
	TA2SqIAzKIKlo46HyeyXNcZApCORewI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533611;
	b=Br4iSQX5lrh9pOYyKeZQVFFDq8739vrjP9LABO+zw2adA1auUJlBhm1rnDBorN9nad/263
	PYYohZbDcDwgm+dRut5R889V/2iJYOVZUIopu9Diz+1nA25CHij5rX5qCsFSUD3kEusSnk
	azgnHLfx9DbfenTi2zKV9rYeBNAulLQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ijXpG7Hq;
	spf=pass (imf24.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788533610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lpOLr06SKT9VWUbfIdRTrVaGCYppzQHTCSBPigs1Iqw=;
	b=ijXpG7Hq3AOLrUWIJ82qH8xOHkZzBGA1+AsADSzOKuKiLQ4EkAWrtopi7/5JYlTITMQID1
	6olOog8wE2TbEExWpOzjdnoCYhiBxdlBVbjduX1KPqi9nk6jMn3JQD0cMO6OrmB/YuRwsL
	vH5JRNXqCPTkZ1aBe1gAOJD+aIkaLCU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-SGgM8J6hPr6FYVMWtzv7og-1; Fri,
 04 Sep 2026 10:53:26 -0400
X-MC-Unique: SGgM8J6hPr6FYVMWtzv7og-1
X-Mimecast-MFC-AGG-ID: SGgM8J6hPr6FYVMWtzv7og_1788533602
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F41CD18CD2AB;
	Fri,  4 Sep 2026 14:53:19 +0000 (UTC)
Received: from fweimer-thinkpadp1gen4i.stuttmso.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2752A1955F10;
	Fri,  4 Sep 2026 14:53:09 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra
 <peterz@infradead.org>,  Juri Lelli <juri.lelli@redhat.com>,  Vincent
 Guittot <vincent.guittot@linaro.org>,  Dietmar Eggemann
 <dietmar.eggemann@arm.com>,  Steven Rostedt <rostedt@goodmis.org>,  Ben
 Segall <bsegall@google.com>,  Mel Gorman <mgorman@suse.de>,  Valentin
 Schneider <vschneid@redhat.com>,  K Prateek Nayak
 <kprateek.nayak@amd.com>,  Kees Cook <kees@kernel.org>,  John Johansen
 <john.johansen@canonical.com>,  Georgia Garcia
 <georgia.garcia@canonical.com>,  Paul Moore <paul@paul-moore.com>,  James
 Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  me@black-desk.cn,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  apparmor@lists.ubuntu.com,  linux-security-module@vger.kernel.org,
  linux-api@vger.kernel.org
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn> (Chen
	Linxuan via's message of "Mon, 31 Aug 2026 10:59:05 +0800")
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
Date: Fri, 04 Sep 2026 16:53:07 +0200
Message-ID: <lhuecf9cbl8.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 8IiZ1pVwU9kd91Eu_kSxivm8vMQQlUq3L5H8O2SwwW0_1788533602
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE7E2180005
X-Stat-Signature: ey41dampwt3frhhydub7npyyhtxctnf7
X-HE-Tag: 1788533610-120966
X-HE-Meta: U2FsdGVkX1/flqi3FGj+7NOGZPr9N84qL2IkW2tFNihr6hV2Stn5/0EJngTbwL1G4832P1y+//tLPbj/RKBKCFF3nwqAtkNsSpw7G1tiyrGgA40Be82mnRHUZ8phcVDXpmftp29cWO70G+IaSB/YzllFwNp3pusa4NpH5znP1Bs/Tv9sn7n7b1TeEKSLLXUVsAfYdrYRmpjkCjawUReORlUPLQ/U33m0j/gpBdHKZgdjGgbcKtJJZCl3Z24RQFpVgGEAhECoN2DEn1PwTe8vx2RXY5LhgI4nwrkdouRhUg71WKi8tdClcCIsRQcxBdNEs1AURAts0fpgxnFlAaZ3jVNnTK71M/7oDmcm2iidfL8g2YMEii6WmBjWJ21clx2L/lb1B9JV80yZHyiGIRBxpmtv6aRJwmG+2zBfKPpl+8wIp3xMvjKHUnQCMA6/+KqaICAC3Clz0fx/CyVNkdOCZ3XxBq/hcp2fN9oodgI7xX0W+ivjBMCt0VC0/2DzB2z9gIN6ZOSlv44UJGBCfVxEW/kWeiKQddBbYXlU0mNGc9GylJZEEXdrm3o5SpaHC777/tYX7aLbJ6QcgsRnXjWT6waR8EgSCKkNc/XP8VJvAVe2/pcSJhuHvFw3E31aGk7I7Kf4UZbeCimqi+JkAvNdOecpirIYka8MZ4zFcMfHn39BZMHn55Eass/b+eBECS3brTXLAFaH2RPMG+28p+or+Jh1L19ZVX/owOsNWUV9rLpR+21S76Y9rv/lB96OwqzX+xYBdeW2+GDev3kT2+cMuaHQWyNPiTEXBGSbxaVPwluiKhZ4i6MVv1INckCRQ4EupCwuBjqpFlfF1x8bZM1JcM0FX4X+8Y2ah0+naicuca4A9QoCSVN/T+wzMrLWplrCfepSL1OL70E5HzjIPCop2rDYGULf2Bq2hPhQhhCUqKEcDaoCFHdBnU8L/f7OHAT97D6RhWkz8e9jFw89E4v
 9dSCKw5J
 jKRKzhpPocp+13NQuUucctoT13ET5DqdHy3Uio3Hj6d5Zm1XouvGGFcmgkcHtvcjbJHElqlJu6L+I+qTFZrXaoAEhtglAZK0QMrIer03hl5A/YsTsjEBJQbhcunsMINN/YiV6M4FzAnTELXo9+fnE/5GXyXhEDC3oOwGFKojo6yfZQspGaGiBvDaVHjuA4W9ZfkwOT6x+igWF8df56YR8Iz4e7idhyEHJfJ8jz+b1ydfHQ6i8JVxxtfkAUg7IiS6OuLnBDPYVgvVxSEfo/wKGT5/9niwIxFE+4XpxxDB2lUEQVwTKlW0NzKhIxcQ5yuwJtTrTSKLeGlPKHa75XiK3UynCQzx2Ul+KDL54JKzaKl/WjqwZlBNQ3y+t/fZ43W+KDxxagsyJJQZlakoVBQilvvkW8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Chen Linxuan via:

> This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> ioctl takes no argument and returns a close-on-exec O_PATH file
> descriptor referencing the corresponding task path.  The new ioctls use
> the same ptrace permission check and nonzero-argument rejection as the
> existing pidfd namespace ioctls.

How would one upgrade the O_PATH descriptor to a full descriptor without
a mounted /proc?

Thanks,
Florian


