Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E177EFD374D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 12:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058086B0093; Wed, 25 Feb 2026 07:24:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030046B0096; Wed, 25 Feb 2026 07:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E74C66B0098; Wed, 25 Feb 2026 07:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D590E6B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:24:52 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E48F1601EC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:24:52 +0000 (UTC)
X-FDA: 84482898024.11.062AC6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52A2EA0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:24:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZvioR9D3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772022290; a=rsa-sha256;
	cv=none;
	b=FSAv3d13OPqb00ZPKKOyrSGYLFfHbYjp5exJ1KvTA9N4dN//i3tHS4mJizrDegXDOcx7FH
	Vkg2rX6aE/lzOvpG7v+Be72MmJA7C9s2Pz0gfGnYruaW+X9jjMp9UxLj6Z9Eu64VhjLkFs
	4TZgcyf5uEPW6Rz/tniMFpJClqsHXAc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZvioR9D3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772022290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U257YdxdwDD5/SgQz18TMn2ak9cgpijlpsO3hFbhA88=;
	b=OOY1I6dsCKF2Wk8wTq3mlDV0QpwV2ASLxe8t+WjyizRlVYaPqTP3dk60J2F025cVw8B4uZ
	WvdupdvDKqE67rFoK1uZldKkv4skEAnzDkS0ahcOyfWHYnQhRyqyMyFB6bfxIoUOb8/LvF
	2Z7jJK2Ylj+sA5MTX0Y0Jlhew61WCB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772022289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U257YdxdwDD5/SgQz18TMn2ak9cgpijlpsO3hFbhA88=;
	b=ZvioR9D3ge9rQe37C6t0wsUgLpgcvttNM5HKK0pxjMT35gFMxcMxaqw9m/4RBN5P98e0YF
	Eb4I4ncODoDWa4bSN4KhEt+owuB6Yh0UnT2+4V41qNlD4wmygieKroI0HSjPu58ZCh0Lbk
	neW6wvL9GkoEbmlc+SdiBUf516o/97E=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-N0jqdGwYP0SRQhDomDtz2A-1; Wed,
 25 Feb 2026 07:24:46 -0500
X-MC-Unique: N0jqdGwYP0SRQhDomDtz2A-1
X-Mimecast-MFC-AGG-ID: N0jqdGwYP0SRQhDomDtz2A_1772022284
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D83A1800464;
	Wed, 25 Feb 2026 12:24:43 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2B60319560A2;
	Wed, 25 Feb 2026 12:24:35 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 13:24:43 +0100 (CET)
Date: Wed, 25 Feb 2026 13:24:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/4] pid_namespace: avoid optimization of accesses to
 ->child_reaper
Message-ID: <aZ7qAl6XCweViRY5@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-2-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <20260224164852.306583-2-ptikhomirov@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 3Cum5TR8UO49F66Y7yinx1ZzBST14roZL4G48DvvJpc_1772022284
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: xcnawcn19aq1rhejw95wiuptjfmcysfj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52A2EA0005
X-HE-Tag: 1772022290-31392
X-HE-Meta: U2FsdGVkX182mNpIOFFh5YpLE+PgeO0a5K30KsnN5PBP8Xibfm6mEPGZC0XxhFZApM8OzECFAVV8uqNpTOp9VhNT0tfDtR7S0SaBdoFPHKCWB4374Glel/Ag6gsBXZNBGx7hpQTuqjL6fZ7gJqUrL70L9UPvjSbkh/ennJApGIZvREHGSSe1F3qal43yKmAbAPJoNgDBSaoCd07kOQAdtY0i7qLcIR5cwrBJM3fqMYxPI3pY1Y4dXAkkucqZY5g+BjZPUM0bTAzAjlh5x2Pm8m/Qz7b90DJfqB4uHIol0t/tI69/kv8H5pl5lBA0nPQI+x+as+0d84mNMkpQSZINHhJXI3Djf+phqhw7bYgFI65WW5zUUViKQj3k1n/D8Ih8HEwCSMVVzE+noffrN1UN+whmnrfyuksIZOXl/R+oJsGEyqG0bktjm10F0iV+PRFySYm/IFIRwTSFH/nEc3kf+iEB6e6Pb9KJjD712QiSFe+rZoAd5TBeSdJ4PwfZkBaogD7rOHXd6MTb1NlVtlHxKc0I1UpWVAhkd+7+2uF6hnD6+2NG9N+H/3W3uGaEsoy1grIXDEOndqzsrkYAIjXBdzrpMj6KPbY4O9d9BRrO4hAq8DPoTqdkCaEdw7IDZCOyZ3Rq10kVUIaVX4hcm2MfXp8+tBd2bqSwjpqHKLA/byW6iOR6RtiiRHQofR7cl5Rb/+g2YxsEQ/R34YbN+sXXeRz8a3E8tW/8q/1lBUn6yQyjctrJfPqopGc8Sg5KBnHWJOWUxK2UHqBmW8iOg8uLQaXX336LTav/yOYlMPxx4ioKLlTKD48/ZGpYixlzTVyYAS+jticJurGOhiz7NMoIVi53YOU76ly/GxEVvhY4rnTzpE0RtpOxhEOfGfCqLoEV7DhIuF09H3P5OB5UagP9g1Euuv1oT48cC40Sj39W5MQIcqwV6xp16Kx3I2cMMz78se+v88b1Ox+dpUNZAL3
 Q/SWUJAY
 ibalZn3yeaCYdzYTj9/h7SlOXaaMchzn8wK8Ast+sQlqldflpBqcPLPwCbPDWYwh4BK4Z0aYXE4MoCtmbonvZmMaoMJAXoWhmLTixYWEiv4XUKeZxQLq8yLeG2CMU2a67/KRYU5TVHDujC/+hfq9lcS7dhI5lKBjvN/56Y/AwH+ANQx7nSqLq0/PMkrRaWpchqLY6XnZfgDcWrZXisDSMjAE9phZckCrsuBQqmSSebRlGoZ1GKTgc8vjVYAwiJ4y5f08SC6QI+yRS1ufuMP5UNlr1VFpGdzSnK/W5TZ1imsOPQ+NbKf7YiT4tl9wnYSf/4VV7tVhd6iAdUiXypL5zh+DYW2CaUfKXChZcrUHxiD5tqhxie/EM0StYcKe5vflvvcdYontH6P58Vw/CT3D0ukdsv/vbMMoRsRS3Am2LdGNxpOIVZkCjqYh7PJWcYIxbi4fNULlznOeG4aPd4NdiLdFJdE2wZzzFV0POlJq8s0FFqhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Pavel Tikhomirov wrote:
>
> Also let's add ASSERT_EXCLUSIVE_WRITER before write to identify to KCSAN
> that we don't expect any concurrent ->child_reaper modifications, and
> those must be detected.

Not sure this makes a lot of sense in this case, but I won't argue.

> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Acked-by: Oleg Nesterov <oleg@redhat.com>


