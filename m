Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B498C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708B36B00A4; Mon, 21 Sep 2026 16:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0726B00A6; Mon, 21 Sep 2026 16:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFD66B00A5; Mon, 21 Sep 2026 16:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4E96B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:13:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 649951A02C5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:13:05 +0000 (UTC)
X-FDA: 85238868330.01.B059720
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0AADD40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:13:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OkngjAGB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790021583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6chaT+lC13U/LIehoKCT6qfQE0dkbiIKm2cvcaiwV9I=;
	b=gdedCFr2DG5mBcXmP+GkJkwML4OiG3xwACWpcLdj3FiFIIk99L/M9PJwKTe10HSX9vGd6c
	p1l9zy4djcSWKYci3d22fzaH4ha70C8nklGg/GOzD5U3kwY5TfmM0/Z9V//mBvQANYHrmF
	d8Qikoiemok4c3uvvQzKU7pi/nkTLnw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790021583;
	b=temVQNr5sjvASntELIPcAbwaexCu9O3YCDQA9z3I3La25q/sGvFMG7/pgMUFH/OEPq9yIg
	DgWB1vYALz2Rg1vxNCDXlEkwcmYM0dH9KZeMjFTMFEC75mfj5oyW1C/Fe8DF68QwdtgDSJ
	gA/JUgUE3xMwUQVXixVhvNg72rxKdGc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OkngjAGB;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790021582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6chaT+lC13U/LIehoKCT6qfQE0dkbiIKm2cvcaiwV9I=;
	b=OkngjAGBfL7rYAkdsRDSd0C0LWXynQ/h8jOsP7nJF+Vq6EX+NwC9DfUNc1FZySlfOpK2pI
	NR3rHQ42ZvuBHEEdS0loQRJW4BSCuRQYOyZ0cFB2DcbXKCabWuVSyE1pXfWYDF5dbmJPF2
	Tj42l0KdfUJvGMDgTzxPQmwR3JvXwiA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-XVPIjv8BPgi4PlY_UW2Ymw-1; Mon,
 21 Sep 2026 16:12:57 -0400
X-MC-Unique: XVPIjv8BPgi4PlY_UW2Ymw-1
X-Mimecast-MFC-AGG-ID: XVPIjv8BPgi4PlY_UW2Ymw_1790021571
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 686E71828AFC;
	Mon, 21 Sep 2026 20:12:50 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BCA221956042;
	Mon, 21 Sep 2026 20:12:33 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 22:12:50 +0200 (CEST)
Date: Mon, 21 Sep 2026 22:12:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Gregory Price <gourry@gourry.net>, SJ Park <sj@kernel.org>,
	peterz@infradead.org, paulmck@kernel.org, mingo@redhat.com,
	rostedt@goodmis.org, jpoimboe@kernel.org, mic@digikod.net,
	tglx@kernel.org, david@kernel.org, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, rafael@kernel.org, gnoack3000@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org, rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, will@kernel.org, boqun@kernel.org,
	frederic@kernel.org, neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com, josh@joshtriplett.org, urezki@gmail.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org,
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
	pavel@kernel.org, lance.yang@linux.dev, mhiramat@kernel.org,
	pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com
Subject: Re: [PATCH v4 14/15] lib: convert process iterator to
 for_each_process_rculock
Message-ID: <arGPsIWUJXVshwqY@redhat.com>
References: <20260921092101.89285-1-ye.liu@linux.dev>
 <20260921093311.104814-1-ye.liu@linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260921093311.104814-1-ye.liu@linux.dev>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nZxuTCjU4QOrEY-7yMox4Y0IvN_2uhPxH6LwQWh7sTc_1790021571
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0AADD40004
X-Stat-Signature: gadc56rdonf8eops61ycjnihk6effyz5
X-HE-Tag: 1790021582-135254
X-HE-Meta: U2FsdGVkX19PKJrUoBKpNDK2Lqnrf7HaZm4zuhOq51qb5azdCsCTmhGLlCRPtLq8sLO2E72HcsLF2/6Gg0FxKKR24L1t5CQnvDN00NNKbt8PqbX05vVDUaVb1BjyO2dF+P6mHhMd5BSFlIM9OZXpvvUQIivWjbYBbKUhg89J/kA7kT8FNQaYW+l871IQCXEQ1HE8DJ5N1N2+z9hlKsaL1MHejSQrRrE8KNK6gHahXAIXx6t00lnoHhgO0chMFc2PpiKAxB8eJWT5QUi5dM8AJJdQ2HnB/P3W13ManRQ3SAYB5PVrlwHnz9k8GQ3FGLQUwH90bBeTqnG3hLDtoimmGGrj3nRvPKCTJmykXThVaxe1W5RKai5ikucosgyZXp0wHhQMB+3MoNpcwyp4Mak38z2m/EAmJVXlFc1SGFQt5PtjAWevBrTsgTq4CjLG5V5ghXwUSyUQq6X7v6LP/gFwNctM8HyBcDR/m+DTnQH+MPm4hmp2jWSJP+NbjE6a1KljyEt6qqIqbwvDztYsvnaA9KKhUySGKmg9jAOaa1QXAu7Ng9GYor+sDgi1if4pXGXbgbOW5oVlCA1TaUV0INXKw4cE/P6m6vXs5B78Shiycbfv2PAExfMFfLQF8fepOb/tAtrkSv8qP5ZU0hXqIKN1RYgYQQqLnJJukPw85iH9e3SqXS8wSPFv1xJWITdJe/PNpybaJfi+ijzwzTqq/3ge1yWsZFB3JgBXHeLM3ZIrJFxw2Hp/ls/WjlDf5hZ7JV2ewwXxxPxejiKyckqDfKzrI3dKabKnM1v670Rt+PcNbBIHFgv9lX2GKKaZl8JMDWHKZ1SzJ9UBHnQHsvCD5mUdravCV9tcpKQ57KVrM1KxUTliozjQjaUgaB3v/VwPW5fLNwyGdb+r9x3r3NZmSrR58YgOSpWyMBdxEMNZKfbIVUhcdAb9UleTp8VEEpyqerP5telibvZq+8w4uaoPP27
 q1UnyPR7
 0arHOwFyUNrgwyoTUVH+tr02ETZKnNxBKbTFGmZ7pkS6/dyvC6ng9mR4l8awDPlrfDfy7vlFU5AnZ3L1y8fhEofb6Qzx5hcz8tbIsMQWSEFNIUWayjheJgWeblrq1r6hdIdxpFV1ZWSIfFqBya/P3hgGCaSarZsft3wP1DkIy4/MmA2XACgp8eDXJsSIij5Mmznp6qj7QOe2ouBcJ9wIGDvHQWilCB9MMyxlONN6JAGVziFSANEZ7phyVM9dHwGNBgKHmIMWmdou1WxouPp8NEJjqukIjb+lh0e3KqHFQYIkVgZrnAaFXTwGWLa0KUMxPDwmxMiUkt5jKsmnbyGlnIcHumx39PxBX+4xCX+963B25HT9KeNDF4lnmi8j+7DwbhGrrDdPsGL0VsTQUrJuluV6dmL5iwZ7BaQVBKl34+1+eaXZ100cDAjmhffgxH5M5P2dRZYRq4ZdPH5iBcAHPOMSmQ3IjDRJ3u1PeyUerKr/Cu/NED88/Qrjhdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Ye Liu wrote:
>
> diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
> index 8c98b20bfc41..4e7fe85454ab 100644
> --- a/lib/is_single_threaded.c
> +++ b/lib/is_single_threaded.c
> @@ -26,8 +26,7 @@ bool current_is_single_threaded(void)
>  		return true;
>
>  	ret = false;
> -	rcu_read_lock();
> -	for_each_process(p) {
> +	for_each_process_rculock(p) {
>  		if (unlikely(p->flags & PF_KTHREAD))
>  			continue;
>  		if (unlikely(p == task->group_leader))
> @@ -48,7 +47,5 @@ bool current_is_single_threaded(void)
>  	}
>  	ret = true;
>  found:
> -	rcu_read_unlock();
> -

Reviewed-by: Oleg Nesterov <oleg@redhat.com>



but I think that the "found" label and "int ret" can now be removed,
the for_each_thread() loop can just do

	...
	if (unlikely(t->mm == mm))
		return false;

and current_is_single_threaded() can simply return true after
the main for_each_process_rculock() loop.

But again, I agree with this patch, it looks simple and "obviously correct".
Even if I am right, the simplifications above need a separate change.

Oleg.


