Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E222C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 500676B00A0; Fri, 21 Aug 2026 10:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0D26B00A1; Fri, 21 Aug 2026 10:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1436B00A2; Fri, 21 Aug 2026 10:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13F996B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:35:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 936A040156
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:35:45 +0000 (UTC)
X-FDA: 85125525450.16.D05C95F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81A0EC000B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:35:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=exajbgBA;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787322943;
	b=0Sw9O8gTRqBNwJfZ2SAFP6q4OSO1wWr3EkZ5VB7U7GJ6kv3Mi1e8YewCE6lXPUc7hquts5
	y/r3011GIOudRX/w1Nbwt4vhAtTGmSk9fxtDqMB++ABqrX1VXeHP4iCcC5Ms66hKgTx50Q
	vRDeFSAhCrWi+EoVFL6YaPRkK/eSgrg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=exajbgBA;
	spf=pass (imf10.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787322943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11dPx6bGB018UBDYzKEYfI8AnpdGEAinmo2rW1PteIc=;
	b=lZe9r/k0046JqmhoK3ezPjbvywbZkAgAuBoQl/sADj0nU8IWMFixz3XNlOdPvVk4Mf4K7e
	I1HeT4GTBd4L5OQI+7I1oSk83BZYpOeKGPD4m5Tg81fvEKnf7l9HFnwhurMJ3VrVjMZ1Id
	OjdNXIWiU/FuIHhytSF517gTTyDfozM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11dPx6bGB018UBDYzKEYfI8AnpdGEAinmo2rW1PteIc=;
	b=exajbgBARwLYvnfOCutZV2Ui2DEekgW6FACGLmAUghYmUr1JLLiB63wR8d5JnZzxzPl7lO
	iK/AL8zUXnlbc4ADQRJTPWM/yZ8cZ6n4/BDKhypVV+qdctzR+z1EVjm+CWPYYpq8KuA1iy
	TPsIWHtEXpMzNPrI4fVR5mbwRtgCjRo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-118-62cyuJzCPGGsO1KE7j6-FA-1; Fri,
 21 Aug 2026 10:35:32 -0400
X-MC-Unique: 62cyuJzCPGGsO1KE7j6-FA-1
X-Mimecast-MFC-AGG-ID: 62cyuJzCPGGsO1KE7j6-FA_1787322929
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D7921954B20;
	Fri, 21 Aug 2026 14:35:28 +0000 (UTC)
Received: from fedora (unknown [10.44.49.72])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 08EAD3002D30;
	Fri, 21 Aug 2026 14:35:23 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 21 Aug 2026 16:35:27 +0200 (CEST)
Date: Fri, 21 Aug 2026 16:35:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] signal: allow taks to temporarily block
 TIF_NOTIFY_SIGNAL
Message-ID: <aohiKmI6IBpX7mvS@redhat.com>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
 <20260818-work-tif_notify_signal-v1-1-1ee1fcc5b3ff@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260818-work-tif_notify_signal-v1-1-1ee1fcc5b3ff@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: VRSn4nUlengsHv4AVrUQ9z_deaxIrrPDH8VwjEpa5sI_1787322929
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 81A0EC000B
X-Rspam-User: 
X-Stat-Signature: diqsnak7ju4ceyprx4c9gb4jzisy9urt
X-Rspamd-Server: rspam06
X-HE-Tag: 1787322943-560423
X-HE-Meta: U2FsdGVkX1+OysuCAY4hLUQd+2w5MMObe4a54vQwrgfg5laHWy3vj8ekNexlt5/lxgmsoyyQfV6EdqtjCNKKGqBU51j7BWpRdgCKa2nMKaLWaMj4PCEUmq6kJ+9GHCON2To/mlXwtbyC5OpMTJwVVzrD2qPcPzeNZGbvOV/6XhPeg46I4I/W+SmrrSO5WhTm5YDaTCZVyOIrD9HBGhuPpbhz0e3BQdX0JlFAc7T7m5EXXreKJaKqpFr+2iVFOE00Q2iBqCoAoLcMf/StVwBRE2c1wwqArDR2ftPusjg2//OxFDrDlnIxO2wOMngxGpSKLRFNAxhUrCnIfcpeKqtF9ADYAOodYulsm+Se22mm+EDnSdQ4kCoG7k8uc3KY2Ivzq4a7ke12WWeAjYxAwf4Ox0AKtT/VP2JhfuqgtA//ug9kdraO7Qyd1lzKbu4X/76WfcRE2B3YyVNr12a9hPkc5IcTA+XexWz5+/DOo+5wQ7ISWqax1qElJLKIY79+LKWOWJa89oecB2JvEs35vghi2FKWQDpi0sWbh0RCczPfEozYnfUUpsfKUrn6oo5aVIH6tw4/B/1FpvllQzrWSb1xWRwnrKr84JBeQfbjeWeZB9ifEX8d53UJ9kKg97iu26duoP6zEM4KM4qYKOSLhOshchx5o6G3SqNHR10e7cRYsNbAiJoY6Shdgq5vSSkhPgbVu9mZCQshlbkYVlirM3vmwob4cUysp5igcS3ydjKFDxYm/6DJw9YLJaDMUKCpEtoPpvqrv/izhmzs5VrJjm41McATrMEf8UL8b8n+2jcUti+P8YfhDnOc4gDys6y8IzDcCk10zSkI2drr+xupLwnxWkdcE7vKlsM1gFCodVvmwzszZnchCgUKno6oSPrKbZ7BCcADx8YWXpI7//RLu2CtBSMLFe5ObcGHMHF9bz+D0+xSu7+hAkVrlEFi+83B5pVVsj+S/uaxXPygpVdUqxc
 A2/avMtn
 sBmq0H8YvlmnPsqzp4pMcWRJ1IdO4gpcvCTLy2WIxOBqGwatCUT4GAsI3Fl+n0Yi1gMYnBMFd/Hfw5zIzWooHRzZcRLb+PgpdO4EDWe4lEedLY6k8cVjct2yssHapeY6uSG333OHmSKNTSYPCEQzV21yo0WdKemXy7HS1b5InLOYq7QlyGDftxyrEDCLb0YSIcJTVSLO02hrJBWUC3OVUcJEdODpSnshWa7MrTzgs4Qw9h00kMK8Oux4pS0TsIn0ewu9aHW+Sji8UuUiUY6aNCHvn78HgtWJ/KmYYZfCXxT6EOSbW837Rvw3HrNi/eGfr4X+WjvJBnOuZHg86BQdN+lzfJa8noBYQlt+2ZGNT9u0OaQh9fLgl9gdf37Vdw2ROvkYsUT2fvoUDs+mEtYAwDmfLM5/vnGcKua10vSzBtbSNk7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christian, sorry for late reply.

This series looks very good to me. Just one nit...

On 08/18, Christian Brauner wrote:
>
> +/* Prevent TIF_NOTIFY_SIGNAL from interrupting this task. */
> +static inline unsigned int no_notify_signal_save(void)
> +{
> +	unsigned int flags = current->flags & PF_NO_NOTIFY_SIGNAL;

I think that

	unsigned int flags = current->flags;

should equally work?

Oleg.


