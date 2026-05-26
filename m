Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332D4CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6672C6B00AC; Tue, 26 May 2026 13:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EB26B00AD; Tue, 26 May 2026 13:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554DC6B00AF; Tue, 26 May 2026 13:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45DD96B00AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:08:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06646140286
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:08:14 +0000 (UTC)
X-FDA: 84810204108.30.98021A1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DBBD40009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:08:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C79rSAdL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779815292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3wcos1obwj7Q08IZk4VCQrr8blDf1SXS18FsOnkuTg=;
	b=KQmvgA2/fOU6na43ZCwAgIgv2hWLTI6NDi55HboENbq0ROnC6A226G4dNwRVJYz3+x09sF
	Mu2VbwJJtcTPBAF/NYwUyZAK6sVdZI5ShJXaI6fsWYk/V8F59LE07YNddtl0gMLN/LsnAu
	lOapQzNjwiLvINCss43gvTibta0xIMk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C79rSAdL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779815292; a=rsa-sha256;
	cv=none;
	b=FjyDSP9jurz9ZgXUmTBZ2D31Z1I0S5aW2bvQdr/unPoug5MmsfUxUjv3iMhCVhxm4BJQau
	gsC/Szconm8MarHTWi2W/x5J9Fm4+sNOcRakYw6bjC7mp2x441X2EJiiiPWRrJ3VoLQEvG
	m7EhYDWsagldK3mY2vOPQRiOO0FKxHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779815291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n3wcos1obwj7Q08IZk4VCQrr8blDf1SXS18FsOnkuTg=;
	b=C79rSAdLQD2pL84te7YOlCv3zR1zwG2pYoogdQGnYd7pse5wf8Ysng+WKlJagkWsV6hlJo
	oJP8bZ6PwXszXhIpWE2wOvlRWfuGS+uL8oKH5Ria5kinSjQ2NM2n09A8PdJL+ahW9myPBJ
	yziIyU8OzUiKMsFu6TeJFLMuGk+p0Z8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-355-OKmV876oPbGdzv2yO-e-yw-1; Tue,
 26 May 2026 13:08:08 -0400
X-MC-Unique: OKmV876oPbGdzv2yO-e-yw-1
X-Mimecast-MFC-AGG-ID: OKmV876oPbGdzv2yO-e-yw_1779815286
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A021919560AE;
	Tue, 26 May 2026 17:08:05 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id D06E119560AB;
	Tue, 26 May 2026 17:07:34 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 26 May 2026 19:08:05 +0200 (CEST)
Date: Tue, 26 May 2026 19:07:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate: find_mm_struct: fix race between security
 checks and suid exec
Message-ID: <ahXTUjrU44xKuofI@redhat.com>
References: <ahWxQ3JxdR5ff2qf@redhat.com>
 <20260526094242.adf161e66ee7adbb445d81ee@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260526094242.adf161e66ee7adbb445d81ee@linux-foundation.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: mLyQoYgSO8UXCjbLwEpuFnw6jBD6Ra2EvQLf1y5La-M_1779815286
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DBBD40009
X-Stat-Signature: bao61d6ub95gydbcpe9h1xp5zxfoqm46
X-Rspam-User: 
X-HE-Tag: 1779815291-70080
X-HE-Meta: U2FsdGVkX18leBFK2rZlECnH2nUc6rDL2VE83zfiquIPJfwn9RHwvjI4FtUZtxjGjYMEqzXgeSVbFAlWZfdYI5A52A/XJwwajA7Do1koU7WmmDNLp32OGgPWxClbl/ZoLvJPd0sPZGuaV+AJgcT+0P6RjeGKpNGq6UvjgJkyuzkXUxRNmIJOJGObScRBjCLOVSTGX1U95VvaTaUoXDEdCMNsvj3liTeSTr4EmTHdkkhHqvmJh3sisRhewN8QQwGTZmMPw65k9npmyy+CeZsKT//3w0g85Ku6kHIvTX+L0UaqGY6ThCRF4j+6oJSzzyM9g9N5VYPd56kPgEWXfOe52+1UStSChxwyIguujapuD8U59KZnZWX7iYjaZgHfWbcd0Ed2zF1WYnyp+wFJxB0EoEckWMih4s14fTUCMF7BmgtB0BJVMwIroNbXENQS3JBUo8ULHCuLIRYiyAbWQ5yCr6QRZwmr+cKn6XRZfHHKQ8U4khOw61eID8eL7sl6Qi9MENgXlIUjh0zAS7CiJPjnbTH1fJ83Dor11k5claui3Kqakvv/SgKCyPd/FqnO/IiDYbY7vmV3ox90cmj0p3BH0KjzlQSxmydxwLCGTMMxLu5VYr9JeSfJCEf7NN9QN5t5hX+bxHowz7ojOXushvoAMATh2q2T4UlWO5G7PQEIlpmrDCRgcv8VnEv/NyDUBEHY2IrFApmzT7nyyw8WTxInuinsDGbEgRRqgpwcRXYePByyohB6v2EEctb2bfqMVVq/PzoJBLIWLvOhB7wNzNk236ZXp+xOXsFqJWliCY9HFa/Pjsc/yQyGbExv6xhxXFtNdebM2peZiTabpLt5cTr+UGVtyxU/w2Llsopr9bQYH0aaZtoGtJfaBY617hf7upbuYy8YKL50/lWoVSWUtioNYz1vOcjQRK3TCPSeh5uQjaSW7/4rLjhw4U6v3o6Oulp4JsRerE8+F3EubHEVN3k
 G/1byanb
 2k8vcWMp5O3SW8QWbN5fdvd9XIASsdjA0YBvVkHp2zqbaVX48JUnG6SCgqdVdYANzazhamj5TAKPWEY7ESrywprcCrANChkDv6G41b4kg9/NTbmg1YPViFh3VmMld7WkWoZZb4LkDd9IzcSDCJBtrH8TPO1JN/6Sp5rDS50PW8CQcKEU7G/1tR+0Pw6zWNXnBPAOsBV+5POfEMfUbOLjtJgCxSztN17YkdF9uF0iykyi/qiPgWX/x0PjoDckTnpWqXuucX8hEqg5yWMgRuDDdtDPxgBZOC8T2nrDJk1rzmFNLdgRZ+In1vLOKZbL1/+KF3u+8cxrSANNIFTEY7p2StPMNSk/Lpr4eavPay5UJ95Ts/qUWwCBCUmD3omeR7lCBUYKswMkab/tbzQ8Bg+dnw1zz+ZayfWET6kTPaD1+cQs01VI1JmLbdnxHsye60ELcIdyG5a3tSwZj//J+hitLKoWMQ6N81qK8MbfqHCZPRi/LXXvgxUFvkj2DyYmTJu/RX9LaFqV+schSb4/9j2keyAuFFNy115qIKnWgLLHhpXCwEvlmjN9440EkFKn8ORFR5aai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/26, Andrew Morton wrote:
>
> On Tue, 26 May 2026 16:42:11 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > The target task can execute a setuid binary between ptrace_may_access()
> > and get_task_mm(). Protect this critical section with exec_update_lock.
> >
> > I don't think cpuset_mems_allowed(task) should be called under
> > exec_update_lock, but this patch just tries to add the minimal fix.
> >
> > Perhaps we can later add a common helper which can be used by
> > find_mm_struct() and kernel_migrate_pages().
> >
>
> Thanks.  Sashiko thinks we should fix kernel_migrate_pages() also:
> 	https://sashiko.dev/#/patchset/ahWxQ3JxdR5ff2qf@redhat.com

Of course ;) That is why I have already sent

	[PATCH 0/4] mm/mempolicy: kernel_migrate_pages: fix race between security checks and suid exec
	https://lore.kernel.org/all/ahMt6xyUNnacZU8-@redhat.com/

and mentioned this in 0/4.

Sashiko has concern about 3/4 in the series above.

I personally do not think this is a problem... Without hidepid != 0
/proc/pid/status reports the same "info leak".

But may be I am wrong. Still waiting for review from maintainers.

Oleg.


