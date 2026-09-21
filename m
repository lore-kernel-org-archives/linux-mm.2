Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880F5C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413DE6B00C7; Mon, 21 Sep 2026 10:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C47C6B00C9; Mon, 21 Sep 2026 10:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4F56B00CB; Mon, 21 Sep 2026 10:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F33886B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:26:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7965316011E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:24 +0000 (UTC)
X-FDA: 85237994688.22.6D2DEA7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46D3220011
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NnUcfUbY;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790000782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pcLJlj5TIE0odij7lPFRE58kbHckgF1Zqih4BUaQQ8=;
	b=yYhxQv6BYzJHA79TSB3BXuILXMDdwpU1BswHKcL/jvhVDcTEMOxxAb3L53kX7obDYqBoM4
	dNQolTSU5YPdhFH7bxyJr+pU3Htg28tk2r7mlyjmR0g/DZNh705HzA46Cuv2vZzM1ZszF6
	gSLMPhfaUl92M4EQXC2FwrB4fKIw0Gg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NnUcfUbY;
	spf=pass (imf03.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790000782;
	b=rC4iuPbl2G2Jxc1BfKFDDxANJNnm9dASD7qXRde+esQuBVOAuWxE2cZ4nQGnyuKWdSx+oT
	wQg/Ywond7W2+V06MWr5mc+6SJLZrgmWxQCj1Eqpg+GYCylYlK7CBDgtDjCrGtvlN/NOyE
	iZdyOcgrJUdCaQ9pz6H6TyydWxNCoPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790000781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+pcLJlj5TIE0odij7lPFRE58kbHckgF1Zqih4BUaQQ8=;
	b=NnUcfUbYrAdUlQ2OB6A+tnSnSIfM0d9/bfEDSbNGckENS2my0FEYEuo6API0Ekb5EklLtL
	mgvTpNtnHj+z3lny4WVi8HxN2PUMIlm+5d6rtjW5TKqMXx2sVe6oq22HMt+/2C+5+5n3zi
	PzAAK/TvPgRmi9vti29WhJTxbESwi04=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-zIc0_6r3NoSA_cJqD0Vc_A-1; Mon,
 21 Sep 2026 10:26:18 -0400
X-MC-Unique: zIc0_6r3NoSA_cJqD0Vc_A-1
X-Mimecast-MFC-AGG-ID: zIc0_6r3NoSA_cJqD0Vc_A_1790000776
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 422C11953994;
	Mon, 21 Sep 2026 14:26:15 +0000 (UTC)
Received: from fedora (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5D11B41D;
	Mon, 21 Sep 2026 14:26:11 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon, 21 Sep 2026 16:26:14 +0200 (CEST)
Date: Mon, 21 Sep 2026 16:26:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Chris Mason <mason@kernel.org>, linux-fsdevel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	NeilBrown <neil@brown.name>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 14/17] fork: don't create io threads once
 PF_POSTCOREDUMP is set
Message-ID: <arE-gZw53CqPTRXP@redhat.com>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
 <20260921-work-coredump-fixes-v3-14-8e4adb1619e6@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260921-work-coredump-fixes-v3-14-8e4adb1619e6@kernel.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: VbzgdjeNRZilgKcvjoUc_L_EQHUcixr3LXbl_F86tlc_1790000776
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46D3220011
X-Stat-Signature: xf66uryprka97itwgooairt6m4fpnf9u
X-Rspam-User: 
X-HE-Tag: 1790000782-888370
X-HE-Meta: U2FsdGVkX1/zscnuQG5NrgcbaCuB1AHKLDdY1oj1BalQjgmEwRuiZnaeQliJ8kFaiZY/Id/3JPJUi6IVKEQkzVlZgsG/8qnIgHyAmZP3Zh6EjWTL8kW8DBprH+Ca+NhKuvFBb8LMi5oNaVAsTfcOu67X/5lDjl0X+7o2bmgYAVhDzICStzOducCZLDIR1tiSOWvz+1H2zgPJWCKDAa4SIfIdFplK1rRRHkcVd2ygSCXNhh1Lsxxo8LdAN30cpu1wNnRqInnzlXOR4u2j8bS3UD2g7PX5psBJ7KHiYrkB0Yiwlacuvuhl8N4e1MA8zW1SfGVhKzJfXk5dAqBAEQ+0188U5fdvTGV9m2Wd/F2P4i1NJPMdLXRItDlP8P7TS8O0SQNAegRYsxSXtABaa6uMsFjddMYQBxj0nwqbI7OpHnOL6oa3Gjazyin11qvsMMWZVP3u7npmn7PidGS3MI8080g56+qTvue0tG1y7yCyZGK2U8cAbGBCr2Se48T5DHoPLzfF28cU1YfheZdbdgwCIdTLseEQDLyjwyKz+LziF+AgEAHx9kWV7HoAhH6PZEtBkv6vS7C98pl1DymEK0t+sHJRxQJRA/J4F1yoCiL2ndL3N8KVCdbxtB21Aa2YLHEe4P4GzaPMWBHLTGQpxL3gQzUWNIXHVmiWvk3HRG/HgiM+hikVrUCE+0c7BBaSzRpyzg1ZdGJE5lcGOBkmfEyW81V3CM9emr5flR7nGF+dsiU0nJGGIsEF+s/9W94mAT8jnKiVKYfEF9f8hF0V4AE7jysbEZg9iaY4SRwXNoTxfk8JyM8LEjWCe1X2EUYdsT361JAX2M+mQaO+Rk2voYjcA2Y6QZfqHrgcbiedYReFbHIh6citS7JYbLS0LiAmBItkRfZnaX6uq5ssblfMg5aFgPlz5QeIuC0CNmnFs2fA6+ocZcS7rYIKxOr/1M70Oj8+tfxAZ3ScICM9cnxUn7S
 eU8UjgYs
 BLm/3vcCfP/05E1Q1Uv+O1EMIuESJNt9WdGs7iMlGi5hHM2R9QPsCMwhOdJek5bxSS94ypfo59QniPzsxm1jUVjOCAa2sSK6NDSoLAFxXXO6wxx782MhAvWG07ANxPgF671B0wmKVydSoQueYo9OfV594Wpyv47sbV9GtgHyrsauW8Ng2xg1s6ai4d6qrLcECSZoH3Xw6Glps5CtROoiN128P6CRAQ9+wfLpLuOm6MlFt4UKH1yqUpVFJ5p/r40j0SD7V8hDkaoXwi+rAWe0l3ZgQpQ9xIHwHAMlmnJEFZIeIJYWN/wlsOzwc6DfaxVZBShrUlCRBqh3WVPSLvN2vmNGsyJx8ZNG8+B87Kmws2X9+iy+tIs0DV+wZxt1L1uAV02nmRGc5u+hm5A2z8efjGPogl29Z/nxUYD9MWaVZPnOWxm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/21, Christian Brauner wrote:
>
> Refuse to create an io thread when the creator has PF_POSTCOREDUMP.
> That costs nothing. io_uring_files_cancel() raises IO_WQ_BIT_EXIT
> before it runs any task work, so a worker created from there only ever
> gets to exit again, and io_should_retry_thread() doesn't retry -EINTR.

Thanks for this note in the changelog,

> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2706,8 +2706,8 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>  		.user_worker	= 1,
>  	};
>
> -	/* A creator past its fatal signal gets no thread. */
> -	if (current->flags & PF_SIGNALED)
> +	/* A creator past its fatal signal or its coredump point gets no thread. */
> +	if (current->flags & (PF_SIGNALED | PF_POSTCOREDUMP))
>  		return ERR_PTR(-EINTR);

Acked-by: Oleg Nesterov <oleg@redhat.com>


