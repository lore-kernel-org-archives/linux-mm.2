Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CCBC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2AB6B008C; Fri,  8 Aug 2025 03:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65546B0093; Fri,  8 Aug 2025 03:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D798C6B0095; Fri,  8 Aug 2025 03:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C74DB6B008C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:59:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83DBDC1590
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:59:35 +0000 (UTC)
X-FDA: 83752840710.15.042944C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 82D66A0004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:59:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2XJKYr9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754639973; a=rsa-sha256;
	cv=none;
	b=2EUyPRrGE2heXKS20c5FgabtKqJl+Cp6QbrsHGu2W2sv9XN/OSIxd+B+wbmt37p3TmnuGK
	UraosH/IFbfkVmZN2GdKtHu5qVduTXditK3pPt1Xk4g3le6kqEhsig3Dxnh0/xdi4XLfZc
	hPFbEmcILT2PdnAIOtfYshL+DaHq3IQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2XJKYr9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754639973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV0E+W7TpF7ScFUrIhlu67F3pDF1bA8Hd4KFXigqUCs=;
	b=UY7fmngzNmGibBfpzQx3fKD8r9ItkLmuf9tYU4zt4SKmhK9LYn4GdquuZ+q80G6gd+rDZ7
	isrbE5yi2kmG62yxxSk0deeKZCed+goBxRRwe5hnjnhB/FkA2O33KuEpk8DZsJy3T8/RUp
	Lv98Nb/ppvj/sEFISf5GKF9NZ1csVi4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754639972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aV0E+W7TpF7ScFUrIhlu67F3pDF1bA8Hd4KFXigqUCs=;
	b=L2XJKYr9JdWfQZN69A68Tf3d9LOtxv2DaPdBdleAU/WzRXFOiYNa5fzuhLTxNmX8jWwknX
	9mp5icIT+Sv136lOSLkJz9chYgF6t2akUPDY5E5Cq3QbIoBJaSeHcGjbLzg3kGCHTYY92S
	tZ+9vubNmF6MaASbfYvvXsRzwd5i9zE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-UNIuuF62OhurBbbx6qeMxQ-1; Fri,
 08 Aug 2025 03:59:29 -0400
X-MC-Unique: UNIuuF62OhurBbbx6qeMxQ-1
X-Mimecast-MFC-AGG-ID: UNIuuF62OhurBbbx6qeMxQ_1754639965
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7991C1800446;
	Fri,  8 Aug 2025 07:59:23 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.225.117])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 24BB41954185;
	Fri,  8 Aug 2025 07:59:06 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri,  8 Aug 2025 09:58:12 +0200 (CEST)
Date: Fri, 8 Aug 2025 09:57:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <20250808075753.GB29612@redhat.com>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
 <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: y6aawzbij6xrp6ixwmgudppyu8uk3b5u
X-Rspam-User: 
X-Rspamd-Queue-Id: 82D66A0004
X-Rspamd-Server: rspam02
X-HE-Tag: 1754639973-103437
X-HE-Meta: U2FsdGVkX18AFlZy9H9DAD+KY/n0WdeZ7zHjIBGk46obypHJXdsnEfxOj3MgElwD/TXYH9e44dszFsD5BNlhmg2ix06zbsbL098fwC/3QEM4g3Jr9GG6hD4AG5Yc1cSKoG2jeWiKwwZyuAYE0sDBWLkNsG67llA7LnwW7gI/oRJYVpzR6sTsR+2HkmIu1hCqFXI8Yxodyo3g7WEmf4JeH5rxDai5hDij6a8OS6Wwwts2onjj850zCP9I9dUu90ChZMn8f77kASmRMPv5xTxDZT/wuNFiCabe0vWmE2cGtUcSrlE0IfRLAJaq6plqYYQ4XcsUtgpYbrsy/CJNz4yvoq0pTDvLIRLNrjVYTorhT8JZQjCBh4tyBE09Rx63mS7eIk7HbIZSd8PpCgQEsLT5ZXsOQDxBgpHuTK9bSxdBlCQwLCKi2uND+OX2yP2ITPnEO0yZA9hH5wUt/ixNhBaNnkFLb2o2IV5+0I3aMg2a66/G8iVEdqQHus+N55BZbwppP+yJvFDZw9VOjx/irUI3jh5WIJSMTPsqxUlL8k3Bs+B8leMbxMiCk5c7Nv4RIehOxObTT6lCgAgs1hwtpcxmgn1015vX5m4vnULuSKrlC4DcPLqo6PcLgMFhjd6ICZsWn+GBS3nPLHxCV5ObSC/gIHVQW4pburVtElkk2S2TAYM+YEZnZK8weKZJ5Fyi+fesKMlVySeO5kSCOhE+8CSR7lY+i9kbwMtpQMUQ1HjBI1waMrw8gZStIPIlT+faqLH/Va9Z7j7XnIJbVGpg4UkTYUGpvKuuINnD6yPrMkQ8df+xSnMwZA7iekXy+ROhaU0Yi1qtAMRlIj80rT24O22Fiy55O3PKyUtBxaOhHmRcKUBYR32WcFPx1z2X/PaldlqbnxLQc8xKA7RUhOQfU1PDG6NaP8f1HkIeaudDiBNzjgAbl9GLN9q56PTRFTrRxL6V6Ec3rMAhfU4io78n6Zs
 4bOgz1Rm
 IN40jtm/lC+9pjHj6FkmT+nS5I3PYZINnoidjaV0ACy2v9XCkUDUdAEw0wk/QGXbgz5vUVuOK9u7JQdaFoekjE7uAIEXMwH6KxRi3py0V75pexKm6Jz9RdyD53FbCGbxJrLVsNKdRKNELdIVUGIX1I+cydMg0GQqyEpXSqEHjDKGxbxi44ysoEgynG88kLIFGqPL1ILpvCAlX19Kk98dtyOF9W+Erc101vDjCoE+YDjcrY3GcoAbUfyf4ecb0gWvwCqnUmXue3bk081xTplJqAnrF2QFAwIP+DBLVdeAOlldqDHuJcLQ21w0kh7SfBKCT699wF+DqFf1YWgWttMCeObyorw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/08, Zihuan Zhang wrote:
>
> 在 2025/8/7 21:25, Michal Hocko 写道:
> >If they are running in the userspace and e.g. sleeping while not
> >TASK_FREEZABLE then priority simply makes no difference. And if they are
> >TASK_FREEZABLE then the priority doens't matter either.
> >
> >What am I missing?

I too do not understand how can this series improve the freezer.

> under ideal conditions, if a userspace task is TASK_FREEZABLE, receives the
> freezing() signal, and enters the refrigerator in a timely manner,

Note that __freeze_task() won't even send a signal to a sleeping
TASK_FREEZABLE task, __freeze_task() will just change its state to
TASK_FROZEN.

Oleg.


